#### stride schedule

一个有更小的stride的进程，会被更频繁的调度到。这里面的stride用虚拟的时间单位passes来表示，而不是真实的时间单位比如秒。

每个客户端持有三个变量，tickets，stride和pass。

tickets指明了相对于其他的进程，该进程分配到的资源数量。

stride和tickets成反比例，表示每次重新schedule之间的间隔，用passes来衡量。

pass则是代表了虚拟的时间标签。

含有最小pass的进程被选择，并增加stride——如果不止一个，那么任何一个都可能被选择。

哦我看了那个图之后明白了，正如上面的意思所述，tickets越大，stride越小，每个时间片都调度一次，然后调度的时候，选中的那个进程，pass每次加stride。

就看那个论文3,2,1的例子，你就明白了，so easy的说，不过，需要指定一个最大的stride的值。我就直接10086了哦。

#### 优先队列

本来这样也就算了，因为这边要找最小的pass那个，所以采用了一个堆的方式每次插入都会得到最小的，而且是log（n）。这边呢，如果是传统的heap的分配，就用数组分配的，因为是能够计算左右儿子及爸爸的，那么不用管，但是这里面则是一个proc——还不知道这些结构都在那里，所以需要这三个节点都指明。

然后用这个来实现调度，大概就是这样子了。还有啥问题不，没了吧。

#### Linux CFS调度算法

Completely Fair Scheduler

有一个vruntime的概念，vruntime记录了一个可执行进程到当前时刻为止执行的总时间

每个进程都更新自己的vruntime

vruntime +=  delta* NICE_0_LOAD/ se.weight

delta为当前进程执行时间，NICE_0_LOAD，se.weight 是当前进程的权重，简单来说，一个进程的优先级越高，并且该进程执行的时间越少，则该进程的vruntime就越小，该进程被调度的可能性就越高。

而具体实现则用了一个红黑树。（所以说这个challenge，别逗了，谁高兴手撸一个红黑树，还未必正确）

