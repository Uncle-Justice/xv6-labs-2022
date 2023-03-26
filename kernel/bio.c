// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13
struct {
  struct spinlock evict_lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf heads[NBUCKET];
  struct spinlock locks[NBUCKET];
} bcache;

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.evict_lock, "bcache_evict");

  // Create linked list of buffers
  for(int i = 0 ; i < NBUCKET; i ++){
    bcache.heads[i].prev = &bcache.heads[i];
    bcache.heads[i].next = &bcache.heads[i];
    // bcache.heads[i].refcnt = -1;
    initlock(&bcache.locks[i], "bcache");
  }
  int id = 0;
  // 初始化把所有的buffer直接堆在哈希值为0的桶里，或者其实也可以均匀的分配在各个桶里，等会可以试试
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    id = b->blockno % NBUCKET;
    // b->lastaccesstick = ticks;
    b->next = bcache.heads[id].next;
    b->prev = &bcache.heads[id];
    initsleeplock(&b->lock, "buffer");
    bcache.heads[id].next->prev = b;
    bcache.heads[id].next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  int bucket_id = blockno % NBUCKET;
  acquire(&bcache.locks[bucket_id]);

  // Is the block already cached?
  for(b = bcache.heads[bucket_id].next; b != &bcache.heads[bucket_id]; b = b->next){
    // printf("*");
    if(b->dev == dev && b->blockno == blockno){
      // printf("cache hit\n");
      b->refcnt++;
      release(&bcache.locks[bucket_id]);
      // 给这个block的实际数据加上锁
      acquiresleep(&b->lock);
      return b;
    }
  }

  release(&bcache.locks[bucket_id]);

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.

  // 发生置换，加bcache的全局置换锁
  acquire(&bcache.evict_lock);
  // 先重新到bucket_id的桶里看看有没有命中
  acquire(&bcache.locks[bucket_id]);
  for(b = bcache.heads[bucket_id].next; b != &bcache.heads[bucket_id]; b = b->next){

    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.locks[bucket_id]);
      // 给这个block的实际数据加上锁
      release(&bcache.evict_lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  release(&bcache.locks[bucket_id]);

  // 遍历所有哈希桶，找一个可以用来替换的buffer
  struct buf *selected_buffer;
  int find = 0;
  int selected_buffer_index = 0; // 被选中的buffer在第几个哈希桶里
  for(; selected_buffer_index < NBUCKET; selected_buffer_index++){
    acquire(&bcache.locks[selected_buffer_index]);

    for(selected_buffer = bcache.heads[selected_buffer_index].next; selected_buffer != &bcache.heads[selected_buffer_index]; selected_buffer = selected_buffer->next){
      if(selected_buffer->refcnt == 0){
        selected_buffer->dev = dev;
        selected_buffer->blockno = blockno;
        selected_buffer->valid = 0;
        selected_buffer->refcnt = 1;
        find = 1;
        if(selected_buffer_index != bucket_id){
          selected_buffer->prev->next=selected_buffer->next;
          selected_buffer->next->prev=selected_buffer->prev;
          // 遍历某个桶中的元素，如果找到了符合条件的buffer，就结束这个桶的遍历，并释放这个桶的锁
          release(&bcache.locks[selected_buffer_index]);
        }
        break;
      }
    }
    // 如果遍历完一个桶中的元素，都没有找到符合条件的buffer，那么结束这个桶的遍历的时候，要释放这个桶的锁
    if(find == 0)
      release(&bcache.locks[selected_buffer_index]);
    else
      break;
  }
  if(find == 0){
    panic("selected buffer not found\n");
  }
  // 如果selected_buffer不在我bucket_id的那个桶里，现在要现加进去
  // 如果本来就在，就不用加
  if(selected_buffer_index != bucket_id){
    acquire(&bcache.locks[bucket_id]);
    selected_buffer->next=bcache.heads[bucket_id].next;
    selected_buffer->prev=&bcache.heads[bucket_id];
    selected_buffer->next->prev=selected_buffer;
    bcache.heads[bucket_id].next=selected_buffer;
    release(&bcache.locks[bucket_id]);
  }else {
    release(&bcache.locks[bucket_id]);
  }

  release(&bcache.evict_lock);
  acquiresleep(&selected_buffer->lock);
  return selected_buffer;
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);
  int bucket_id = b->blockno % NBUCKET;
  acquire(&bcache.locks[bucket_id]);
  b->refcnt--;
  if(b->refcnt < 0)
    b->refcnt = 0;
  // if (b->refcnt == 0) {
  //   // no one is waiting for it.
  //   b->next->prev = b->prev;
  //   b->prev->next = b->next;
  //   b->next = bcache.heads[bucket_id].next;
  //   b->prev = &bcache.heads[bucket_id];
  //   bcache.heads[bucket_id].next->prev = b;
  //   bcache.heads[bucket_id].next = b;
  // }
  
  release(&bcache.locks[bucket_id]);
}

void
bpin(struct buf *b) {
  int bucket_id = b->blockno % NBUCKET;
  acquire(&bcache.locks[bucket_id]);
  b->refcnt++;
  release(&bcache.locks[bucket_id]);
}

void
bunpin(struct buf *b) {
  int bucket_id = b->blockno % NBUCKET;
  acquire(&bcache.locks[bucket_id]);
  b->refcnt--;
  release(&bcache.locks[bucket_id]);
}


