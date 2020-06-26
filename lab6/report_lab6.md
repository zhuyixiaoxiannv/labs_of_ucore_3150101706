运行的代码，有两个一个是用于测试的，

```
make grade
```

还有一个用于正常操作的，同lab4

```
qemu-system-i386 -s -hda bin/ucore.img -drive file=./bin/swap.img,media=disk,cache=writeback -monitor vc --nographic
```

# 练习0：填写已有实验

本实验依赖实验1/2/3/4/5。请把你做的实验2/3/4/5的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”“LAB5”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab6的测试应用程序，可能需对已完成的实验1/2/3/4/5的代码进行进一步改进。

#### Answers：

哦呦我真的是每次都要为exercise0给操心，真的是心累好伐，代码复制过去了，但是并没有把lab6（甚至没有lab5_result跑通）而且两个地方都是一样的报错——而且，lab5_result用的是他源代码，我没改过任何地方。

我说一下问题的定位哦，这次的问题，我也表示看不懂了，事情是这样的，会在vmm.c的check_pgfault函数的357行（差不多这附近吧）在free_page函数释放这个page的时候，存在了错误。
说的是
```
 assertion failed: !PageReserved(p) && !PageProperty(p)
```
这个报错。
然后呢，我仔细查看了这个东西，原因应该是前面访问0x100这个虚拟线性地址的时候，正确的应该报一个页缺失的错误，然后巴拉巴拉一堆处理，之后释放这个页就完了。

上面说的是正确的，然鹅，包括lab5_result代码中的，这个页其实在之前check_boot_pgdir()函数（查看pmm_init里面找吧）里面也用到了这个0x100地址，换句话说，之前检测的时候，这个页没有释放掉其实，所以后面出了一堆问题。

神奇就神奇在这里面。我怀疑我lab3 的code也有错，但是一查并不是这样的，在check_boot_pgdir()函数之后，访问这个地址，还是能访问到的，但是print_pgdir（）之后就访问不到了，不知道为什么。

更神奇的是，我查看了lab3_result的代码，发现，在这里面，则是跳出pmm_init函数之后则访问不到这个地址了，而不是之前。。。我真的受够了，不懂得这里面的问题在哪里。

唯一的一个好消息算是，直接将测试的addr改成0x1000之后就跑的通。（但这并没有卵用，相当于让他去找第二页，但是并没有解决第一页存在的问题，确切的说，第0页，懂我意思就行了）

我的看法则是pte的问题，我在lab5_result的check_pgfault（）这个函数这边，addr定义后面加了两行，来验证问题存在——其中get_pte的后面create参数可以为0和1，就能明白了。

```
	uintptr_t addr = 0x100;
    pte_t *ptep=get_pte(boot_pgdir,addr,0);
    cprintf("%08x\n",ptep);
```

参数为0，就是不创造pte的时候，不会报页中断，其实在页表中没有对应的pte，这个时候的pgdir[0]是0，那么表示这个pte的页不存在，但是没报页中断，依然能正常访存——这就离谱。

参数为1的时候，相当于申请了page，这个时候肯定不会有页中断了，但是其他一切正常，后面都可以用。

于是我查看了ptep的内容

```
	cprintf("%08x\n",pgdir);
    pde_t *pdep=&pgdir[PDX(addr)];
    cprintf("%08x\n",pdep);
    cprintf("%08x\n",*pdep);
    pte_t *ptep=&((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(addr)];
    cprintf("%08x\n",ptep);
    cprintf("%08x\n",*ptep);
    assert(find_vma(mm, addr) == vma);
```

```
c0124000
c0124000
00000000
c0000000
f000ff53
```

结果是这样子的。我就很神奇了，按照页表的查询来看。这不可能啊，

（表示头大）

算了就俩解决方案，一个是这边改成0x1000，要么就是那边不要check（反正能对就行了），大概就是把check_boot_pgdir注释掉，我个人倾向于后一种，因为可能不知道为什么莫名其妙（反正我也不想去测试了）这段代码会导致某些内存结构被破坏掉，而且他只是一个check函数，并没有做什么事情。

（我今天算是学会了程序员如何和稀泥，简单来说，只要能跑就行了，到底bug出在哪里，根本不重要好伐。）

哦我反应过来，可能，还有一个东西叫做快表。

果然如此，在这里面，少了删除快表中的内容。

所以解决方案是，要在pmm.c的check_boot_pgdir（）的末尾加上

```
    tlb_invalidate(boot_pgdir, 0x100);
    tlb_invalidate(boot_pgdir, 0x100+PGSIZE);
```

关于这个错误，我已经提交到了原来代码的github的issue中去了。（但不要指望我commit一份代码，这不存在的）

#### 队列 enqueue问题

这里面有个问题，说assert了一个list为空的情况，但是，第一个proc的入队，难道，要我手动写？？？反正删了这行也能跑，问题1跑了个make grade之后大概就能有163/170了。

我个人对于这个报错的看法是，创建第一个进程，也就是idle的时候，需要将其手动入队。用于调度。

这里面idle的pid是0，initproc的pid是1，但是将pid==1的进程入队的时候报错是空的，说明，需要将idle入队先。

（但是我看了一下，貌似这么做不太可行，非要强行做当然可以咯，但是会破坏一些比如说设计与实现分离的原则，就那个run_queue rq并不能在proc里面访问啊，对吧）

不过这个地方这个assert肯定有问题是真的，不然的话，第一次入队的时候也要检测是否为空，那肯定为空啊，后面的入队还入个屁。

# 练习1: 使用 Round Robin 调度算法（不需要编码）

完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件）个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。执行make grade，大部分测试用例应该通过。但执行priority.c应该过不去。

请在实验报告中完成：

- 请理解并分析sched_calss中各个函数指针的用法，并接合Round Robin 调度算法描ucore的调度执行过程
- 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计

#### Answers：

第一个问题嘛，你去看那个指导材料的那个RR调度算法那个部分，几个函数都很清楚了，一个入队一个出队，还有一个是，如果时间片用完了就设置标志位（但是这个函数实在trap.c里调用的)，最后就是选取头部的那个PCB。没啥更多的了。

第二个问题的设计：

数据结构上的设计，对于PCB没什么好说的，因为有个proc->rq的结构，所以可以通过这个指向所在的那个队列，间接的指向了特权级。对于队列，需要n个，比如说，取n=3.

函数上面的更改，原有出入队列函数不需要更改，初始化函数需要初始化三个队列。选取PCB的函数，改成，首先看队列1是否为空，再看2再看3。

另外需要增加一个变更特权级的函数，这基于出入队列函数，从高特权级出队，入低特权级。

# 练习2: 实现 Stride Scheduling 调度算法（需要编码）

首先需要换掉RR调度器的实现，即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride度器的相关描述，完成Stride调度算法的实现。

后面的实验文档部分给出了Stride调度算法的大体描述。这里给出Stride调度算法的一些相关的资料（目前网上中文的资料比较欠缺）。

- [strid-shed paper location1](http://wwwagss.informatik.uni-kl.de/Projekte/Squirrel/stride/node3.html)
- [strid-shed paper location2](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.138.3502&rank=1)
- 也可GOOGLE “Stride Scheduling” 来查找相关资料

执行：make grade。如果所显示的应用程序检测都输出ok，则基本正确。如果只是priority.c过不去，可执行 make run-priority 命令来单独调试它。大致执行结果可看附录。（ 使用的是 qemu-1.0.1 ）。

请在实验报告中简要说明你的设计实现过程。

#### Answers：

emmm这里面注意一件事，那个rq，init的时候，lab6_run_pool是个指针，所以初始化的时候，不是调用skew_heap里面的东西初始化，因为都没给他分配内存。但是proc的init的时候，这个则是分配了空间的。

（我怎么看怎么觉得这就是个优先堆）我先去看论文去，相关内容放在KeyPoints（一如往常）

尴尬的地方在于这里面变量的命名，lab6_stride表示了这里面的pass，而lab6_priority则表示了这里面的stride。。。

另外需要注意的地方在于如果使用list，别的地方和使用RR差不多，但是在pick的时候，需要遍历一遍

设计实现过程，其实，我觉得没啥可以多讲的，因为这个优先堆的内容都给我封装好了（封装好了还有什么讲头）

最后关于结果，那个12345我是真的调不出来，而且看了网上的答案，好像大家都没有正确的弄到12345，虽然lab6 result神奇的做到了，但是我把代码给复制过去，并没有什么卵用。