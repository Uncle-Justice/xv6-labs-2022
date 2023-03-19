// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

#define PA2PGNUM(pa) ((((uint64)pa-KERNBASE) >> 12)) // pa转为在引用计数数组中对应的物理页号，
#define PA2REFCOUNT(pa) kcounter.refcount[PA2PGNUM((uint64)(pa))]
struct {
  struct spinlock lock;
  //物理页的引用计数
  int refcount[(PHYSTOP-KERNBASE)>>PGSHIFT];
}kcounter;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);

  initlock(&kcounter.lock, "kcounter");
    for(int i = 0; i < (PHYSTOP-KERNBASE)>>PGSHIFT;i++){
      kcounter.refcount[i]=0;
    } 
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
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

  acquire(&kcounter.lock);
  if(--PA2REFCOUNT((uint64)(pa)) > 0){
    release(&kcounter.lock);
    return; 
  }
    
  PA2REFCOUNT((uint64)(pa)) = 0;
  release(&kcounter.lock);

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

//对引用+1并返回值
int paref(uint64 pa){
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("paref");
  acquire(&kcounter.lock);
  int count=++PA2REFCOUNT(pa);
  release(&kcounter.lock);
  return count;
}

//对引用+1并返回值
int paunref(uint64 pa){
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("unparef");
  acquire(&kcounter.lock);
  int count=--PA2REFCOUNT(pa);
  release(&kcounter.lock);
  return count;
}

int parefnum(uint64 pa){
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("unparef");
  int count=PA2REFCOUNT(pa);
  return count;
}

int uvmtrapcopy(pagetable_t pagetable,uint64 va,uint64 sz){
    va=PGROUNDDOWN(va);
    pte_t *pte=walk(pagetable,va,0);
    // printf("uvmtrapcopy va: %p, pte: %p, flag: %d\n",va,*pte,PTE_FLAGS(*pte));
    if(pte!=0 &&(*pte &PTE_V) &&(*pte&PTE_COW)){
      return uvmcowcopy(pagetable,pte,va);
    }
    // }else if(pte!=0 && va<sz && (*pte&PTE_V)==0){
    //   return uvmsbrkalloc(pagetable,pte,va);
    // }
    return -1;
}


int uvmcowcopy(pagetable_t pagetable,pte_t * pte,uint64 va){
    uint64 oldpa=PTE2PA(*pte);
    if(oldpa==0){
      return -1;
    }
    uint64 newpa;
    if((newpa=(uint64)kcopy_and_unref(oldpa))==0){
      // vmprint(pagetable);
      return -1;
    }
    // printf("kcopy_and_unref newpa: %p\n",newpa);
    //去除页表项，并减少物理页的引用
    *pte=*pte|PTE_W;
    *pte=*pte&~PTE_COW;
    uint64 flag=PTE_FLAGS(*pte);
    *pte=PA2PTE((uint64)newpa) | flag;
    return 0;
}

void *kcopy_and_unref(uint64 pa){
  if((pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kcopy_and_unref");

  uint64 newpa=0;
  acquire(&kcounter.lock);
  //如果引用为1了，那就不用拷贝了，直接用这页即可
  if(PA2REFCOUNT(pa)<=1){
      release(&kcounter.lock);
      return (void*)pa;
  }
  if((newpa=(uint64)kalloc())==0){
    release(&kcounter.lock);
    return 0;
  }
  memmove((void*)newpa,(void*)pa,PGSIZE);
  //将原pa引用减1
  PA2REFCOUNT(pa)--;
  release(&kcounter.lock);
  return (void*)newpa;
}
uint64 uvmcowtrapcopy(uint64 va, pagetable_t pagetable){
  pte_t *pte;
  acquire(&kcounter.lock);
  uint64 old_pa = 0, new_pa = 0;
      if((pte = walk(pagetable, va, 0)) == 0)
        panic("handle COW page fault in usertrap: pte should exist");

      *pte |= PTE_W;
      *pte &= ~PTE_COW;
      uint64 flag=PTE_FLAGS(*pte);
      if((*pte&PTE_COW)){
        panic("PTE_COW error\n");
      }
    
      old_pa = PTE2PA(*pte);
      // printf("parefnum: %d\n", parefnum((uint64)old_pa));
      if(parefnum((uint64)old_pa) < 1){
        printf("parefnum: %d\n", parefnum((uint64)old_pa));
      }else if(parefnum((uint64)old_pa) == 1){
        release(&kcounter.lock);
          new_pa = old_pa;
      }
      else{
        new_pa = (uint64)kalloc();
      if(new_pa == 0){
        // uvmdealloc(p->pagetable, va, p->sz);
        panic("new page alloc fail when handling page fault from COW pages\n");
      }
        memmove((void *)new_pa, (char*)old_pa, PGSIZE);
        // printf("memmove end\n");
        // paunref(old_pa);
        --PA2REFCOUNT(old_pa);
        release(&kcounter.lock);
      }
      
      if(new_pa == 0){
        // uvmdealloc(p->pagetable, va, p->sz);
        panic("new page alloc fail when handling page fault from COW pages\n");
      }

      
      *pte=PA2PTE((uint64)new_pa) | flag;
  return new_pa;
}
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk

  if(r)
    // paref((uint64)(r));
    PA2REFCOUNT((uint64)(r)) = 1;
  return (void*)r;
}
