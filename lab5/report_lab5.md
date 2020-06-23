运行的代码，有两个一个是用于测试的，
```
make grade
```
还有一个用于正常操作的，同lab4
```
qemu-system-i386 -s -hda bin/ucore.img -drive file=./bin/swap.img,media=disk,cache=writeback -monitor vc --nographic
```
但我不知道是不是系统的问题，这个跑result的代码依然搞不定，这就。。。emmm了
# 练习0：填写已有实验

本实验依赖实验1/2/3。请把你做的实验1/2/3的代码填入本实验中代码中有“LAB1”,“LAB2”,“LAB3”的注释相应部分。

（随着代码渐渐变多，emmm要填充的地方越来越多了)

# 练习1: 加载应用程序并执行（需要编码）

do_execv函数调用load_icode（位于kern/process/proc.c中）来加载并解析一个处于内存中的ELF执行文件格式的应用程序，建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好proc_struct结构中的成员变量trapframe中的内容，确保在执行此进程后，能够从应用程序设定的起始执行地址开始执行。需设置正确的trapframe内容。

请在实验报告中简要说明你的设计实现过程。

请在实验报告中描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

# 练习2：父进程复制自己的内存空间给子进程（需要编码）

创建子进程的函数do_fork在执行中将拷贝当前进程（即父进程）的用户内存地址空间中的合 法内容到新进程中（子进程），完成内存资源的复制。具体是通过copy_range函数（位于 kern/mm/pmm.c中）实现的，请补充copy_range的实现，确保能够正确执行。



#### Answer：

#### log（反正是给自己看的）：
说个玄奇的事情，就是那个FL_IF的定义，我真的压根没找到，那几个头文件全都找了，没有。。。好了，它在mmu.h文件中被定义——但我真的觉得这是x86或者def里面应该做的事情，为什么flag寄存器的几个标志位要放到mmu里面。

这个lab5 比起lab4，就要复杂的多了。我这bug报错还不好找

我碰到的第一个bug感觉是之前代码的错误，就是一个swap失败然后do_pgdefault

emmm~真的让人揪心的说，这个直接用lab5_results的代码也一样不行，看来有些地方出了问题。算了想想办法吧，明天再说吧，这个太糟心了。

目前查到的问题是，由于物理页框用完了，然后swap_out可能某个地方没有起作用，所以发生了页错误，在寻址0x5000的时候又要为了pte去分配页框。但是这个页框没分配成功。

好了，最后发现问题了，是我，lab3的代码，有一个地方没有复制过去。。。

第二个bug是打代码的错误，发现了在填充tf的地方，tf_esp的值给弄错了，直接等号给了elf->e_entry，这个emmmm肯定错了的，然后我估计原因是那个initcode.S里面不是有检查esp的嘛，减了20，然后直接跑到了尾部的内核代码段，所以报错说

```
do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n
```

是一个读写位的错误。

第三个bug的地方，目前的表现形式是，kernel生成第一个用户进程成功了，但是生成第二个，失败了。而且有个莫名其妙的地址0，因为userbase不是从0开始的。所以我觉得问题是在于，addr为什么会找个零（感觉像个莫名其妙的指针给跑飞了）

我个人看法在于fork这个函数，因为这里面如果fork的返回pid==0应该表示着这是一个子进程。（也不一定，也有可能是复制的时候的错误）

但是，这里面的问题是，看这个代码（包括我去网上查找答案）并没有看到靠谱的代码。就直接返回proc->pid结果没差别的啊。好吧，我看了一下下，是copy_range 里面的错误，他的page_insert的参数，我原本那个线性地址，应该是start，但是我傻乎乎的用了那个dst的那个地址。

第四个bug，我也不知道算不算bug吧，反正就是，我输入了make grade，然后报错，说spin和waitkill少了几个，但是呢，我直接检查代码，完了之后，只是会慢一点点，中间多了好几个时钟中断，然后就出来了这几个语句，我不是很懂，为啥还报这个错。

哦，这里面，这里面，请务必把print ticks这件事去掉。

输出结果
```
badsegment:              sleep: cannot read realtime clock: Invalid argument
(1.1s)
  -check result:                             OK
  -check output:                             OK
divzero:                 sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
softint:                 sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
faultread:               sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
faultreadkernel:         sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
hello:                   sleep: cannot read realtime clock: Invalid argument
(.6s)
  -check result:                             OK
  -check output:                             OK
testbss:                 sleep: cannot read realtime clock: Invalid argument
(.8s)
  -check result:                             OK
  -check output:                             OK
pgdir:                   sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
yield:                   sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
badarg:                  sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
exit:                    sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
spin:                    sleep: cannot read realtime clock: Invalid argument
(3.6s)
  -check result:                             OK
  -check output:                             OK
waitkill:                sleep: cannot read realtime clock: Invalid argument
(12.6s)
  -check result:                             OK
  -check output:                             OK
forktest:                sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
forktree:                sleep: cannot read realtime clock: Invalid argument
(.7s)
  -check result:                             OK
  -check output:                             OK
Total Score: 150/150
```