#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_sigalarm(void);
uint64 sys_sigreturn(void);
uint64 sys_settickets(void);

uint64
sys_exit(void)
{
  // myproc()->syscall_counts[2]++;
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  // myproc()->syscall_counts[11]++;
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  // myproc()->syscall_counts[1]++;
  return fork();
}

uint64
sys_wait(void)
{
  // myproc()->syscall_counts[3]++;
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  // myproc()->syscall_counts[12]++;
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  // myproc()->syscall_counts[13]++;
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  // myproc()->syscall_counts[6]++;
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  // myproc()->syscall_counts[14]++;
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_waitx(void)
{
  // myproc()->syscall_counts[22]++;
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
  argaddr(1, &addr1); // user virtual memory
  argaddr(2, &addr2);
  int ret = waitx(addr, &wtime, &rtime);
  struct proc *p = myproc();
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    return -1;
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    return -1;
  return ret;
}

uint64
sys_getsyscount(void)
{
  // myproc()->syscall_counts[23]++;
  int mask;
  // int pid;
  argint(0, &mask);
  // argint(1, &pid);
  // struct proc *p = 0;
  if (mask < 0)
  {
    return -1;
  }

  int syscall_num = 0;
  while ((mask & 1) == 0)
  {
    mask = mask >> 1;
    syscall_num++;
  }

  // for (int i = 0; i < NPROC; i++)
  // {
  //   if (proc[i].pid == pid)
  //   {
  //     p = &proc[i];
  //     break;
  //   }
  // }

  int count = myproc()->syscall_counts[syscall_num];
  return count;
}

uint64
sys_sigalarm(void)
{
  int ticks;
  // void (*handler)();
  uint64 handler;
  argint(0, &ticks);
  argaddr(1, &handler);
  struct proc *p = myproc();
  p->alarmticks = ticks;
  p->alarmhandler = (void (*)())handler;
  p->tickcount = 0;
  p->in_alarm_handler = 0;
  return 0;
}

uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  // if (p->in_alarm_handler)
  // {
  memmove(p->trapframe, &p->tf_backup, sizeof(struct trapframe));
  p->in_alarm_handler = 0;
  // }
  return p->trapframe->a0;
}

uint64
sys_settickets(void)
{
  struct proc *p = myproc();
  int n;
  argint(0, &n);
  if (n < 1)
    return -1; 
  p->tickets = n;
  return n;
}