// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);
void kfree_cpu(void *pa, int cpu_id);
extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct{
  struct spinlock lock;
  struct run *freelist;
}kmem[NCPU];

void
kinit()
{
  
  for(int i = 0; i < NCPU; i++){
    initlock(&kmem[i].lock, "kmem");
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  //均匀分配物理页
  push_off();
  int cpu_id = cpuid();
    pop_off();
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
  //   r=(struct run*)p;
  //   r->next = kmem[id].freelist;
  //   kmem[id].freelist = r;
  //   id=(id+1)%NCPU;
  //   total++;
  // }
  kfree_cpu(p, cpu_id);}

}
void
kfree_cpu(void *pa, int cpu_id)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  // acquire(&kmem[cpu_id].lock);
  r->next = kmem[cpu_id].freelist;
  kmem[cpu_id].freelist = r;
  // release(&kmem[cpu_id].lock);
}
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  push_off();
  int cpu_id = cpuid();
  r = (struct run*)pa;

  acquire(&kmem[cpu_id].lock);
  r->next = kmem[cpu_id].freelist;
  kmem[cpu_id].freelist = r;
  release(&kmem[cpu_id].lock);
  pop_off();
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  push_off();
  int cpu_id = cpuid();
  

  acquire(&kmem[cpu_id].lock);
  r = kmem[cpu_id].freelist;
  if(r){
    kmem[cpu_id].freelist = r->next;
    release(&kmem[cpu_id].lock);
  }else{
    for(int i = 1; i < NCPU; i++){
      acquire(&kmem[(cpu_id+i)%NCPU].lock);
      r = kmem[(cpu_id+i)%NCPU].freelist;
      if(r){
        kmem[(cpu_id+i)%NCPU].freelist = r->next;
        release(&kmem[(cpu_id+i)%NCPU].lock);
        break;
      }
      release(&kmem[(cpu_id+i)%NCPU].lock);
    }
    release(&kmem[cpu_id].lock);
  }
  pop_off();

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
