运行的代码，有两个一个是用于测试的，

```
make grade
```

还有一个用于正常操作的，同lab4

```
qemu-system-i386 -s -hda bin/ucore.img -drive file=./bin/swap.img,media=disk,cache=writeback -drive file=./bin/sfs.img,media=disk,cache=writeback -monitor vc --nographic
```

这里面参考一下下Makefile，就是说，需要多加一个disk了，作为文件系统。容我看看Makefile。

他大概就是多加了一个disk，写成上面那个就很舒服了。能用，但是恐怕得去看看那个driver的代码了。

emmm相关理解部分我写在KeyPoints里面了。至于跑的时候报了一个什么乱七八糟的pagefault的错误，我估摸着，应该是，那个load_icode的部分，那整个直接给空了，没给人新的进程创建memory，可不能不出错啊。

# 练习0：填写已有实验

本实验依赖实验1/2/3/4/5/6/7。请把你做的实验1/2/3/4/5/6/7的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”/“LAB5”/“LAB6” /“LAB7”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab8的测试应用程序，可能需对已完成的实验1/2/3/4/5/6/7的代码进行进一步改进。

#### answers：
反正写完了跑不了，就酱紫，能说什么。

# 练习1: 完成读文件操作的实现（需要编码）
首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，编写在sfs_inode.c中sfs_io_nolock读文件中数据的实现代码。

请在实验报告中给出设计实现”UNIX的PIPE机制“的概要设方案，鼓励给出详细设计方案

#### answers：
这部分对应了读文件这件事情。