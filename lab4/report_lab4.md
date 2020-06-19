运行命令和lab3一样，

```
qemu-system-i386 -s -hda bin/ucore.img -drive file=./bin/swap.img,media=disk,cache=writeback -monitor vc --nographic
```

因为proc之后才是swap开启，所以一开始，填入之前的代码之后，这个玩意儿，并不显示ide0那行后面（ide0就是昨天吃瘪的那个地方）

这个lab4的事情是一个线程的管理，起因是，ucore这个内核，算是一个进程，而里面可以执行多个线程。

# 练习1：分配并初始化一个进程控制块（需要编码）

alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

> 【提示】在alloc_proc函数的实现中，需要初始化的proc_struct结构中的成员变量至少包括：state/pid/runs/kstack/need_resched/parent/mm/context/tf/cr3/flags/name。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

#### Answers

就是对结构进行初始化。



# 练习2：为新创建的内核线程分配资源（需要编码）

创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用**do_fork**函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。它的大致执行步骤包括：

- 调用alloc_proc，首先获得一块用户信息块。
- 为进程分配一个内核栈。
- 复制原进程的内存管理信息到新进程（但内核线程不必做此事）
- 复制原进程上下文到新进程
- 将新进程添加到进程列表
- 唤醒新进程
- 返回新进程号

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

# 练习3：阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的。（无编码工作）

请在实验报告中简要说明你对proc_run函数的分析。并回答如下问题：

- 在本实验的执行过程中，创建且运行了几个内核线程？
- 语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`在这里有何作用?请说明理由

完成代码编写后，编译并运行代码：make qemu

如果可以得到如 附录A所示的显示内容（仅供参考，不是标准答案输出），则基本正确。

#### Answer:
这个编程不是很难，有一定的问题的地方在于我之前lab2的内容，正如keypoints里面写的那样，先调用了proc_init之后，再使用idle的进程，所以显示输出的时候，由于之前物理页框的分配不对，所以，check_swap的时候，出现了一个神奇的错误——但这个问题在lab3里面也没有出现，可能的原因是，lab3里面因为没有线程空间的调用，所以那个swap的check没啥毛病，是在调用了lab2的物理页框分配的地方出了问题，我以为他写好的，然后后面check的函数也没啥毛病，所以，我就以为没啥问题。结果，我还是too young。