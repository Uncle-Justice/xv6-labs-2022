#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


// #ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  uint64 starting_addr;
  int page_num;
  uint64 bitmask_addr;
  argaddr(0, &starting_addr);
  argint(1, &page_num);
  argaddr(2, &bitmask_addr);
  pte_t *pte;
  uint64 bitmask = 0;

  // 设置page_num上限
  if(page_num > 32)
    panic("sys_pgaccess page_num too high");
  // 循环walk，拿到每一个虚拟地址对应的物理地址，然后判断access_bit
  for(int i = 0; i < page_num; i++){
    // 不知道是不是+i
    pte = walk(myproc()->pagetable, starting_addr + i * PGSIZE, 0);
    // 判断pte的access位，如果被访问了，该位重置，并在bitmask中设置
    if((*pte & PTE_A) != 0){
      *pte ^=  PTE_A;
      bitmask |= (1L<< i);
    }
  }
  // 返回结果
  if(copyout(myproc()->pagetable, bitmask_addr, (char *)&bitmask, sizeof(bitmask)) < 0)
      return -1;
  return 0;
}
// #endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
