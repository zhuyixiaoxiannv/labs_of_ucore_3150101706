首先看整个实验的流程，正如指导材料所说

```
直到执行到创建第二个内核线程init_main时，修改了init_main的具体执行内容，即增加了check_sync函数的调用
```

这里面，init_main属于内核进程的第二个线程。pid为1。

#### 计时器

虽然通常来说，这玩意平常都不做考虑，因为当时钟到达某个时间的时候，就触发事件，这功能用到的实在不多。

他使用了一个队列，然后每次将某个时钟定时器事件加入这个队列（就是说需要某个时间点之后唤醒某个进程），那么就把这个进程放进队列里面。emmmm，对于某些特定的clock的任务可能有一定的用处。

### check_sync

分为两部分，第一个是基于信号量，第二个基于管程。

#### monitor

看的老娘晕乎乎的。先看看这里面的数据结构

```
typedef struct condvar{
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;
```

然后管程的是

```
typedef struct monitor{
    semaphore_t mutex;      // the mutex lock for going into the routines in monitor, should be initialized to 1
    semaphore_t next;       // the next semaphore is used to down the signaling proc itself, and the other OR wakeuped
    //waiting proc should wake up the sleeped signaling proc.
    int next_count;         // the number of of sleeped signaling proc
    condvar_t *cv;          // the condvars in monitor
} monitor_t;
```

这里面总共有三个信号量

mutex的用处是保证对于这个管程的访问是唯一的。就同一时刻只能有一个进程在管程内。

next 说法是，由于发出singal_cv而睡眠的进程进行互斥使用的

sem则是对于某个条件c的信号量。（要注意到管程init里面的代码，

```
mtp->cv =(condvar_t *) kmalloc(sizeof(condvar_t)*num_cv);
```

这里面malloc了n个资源，用cv表示，所以。。。懂了么。）mutex和next都是管程里面就一个，但是cv则是管程里面所表示的资源，可以有多个。

