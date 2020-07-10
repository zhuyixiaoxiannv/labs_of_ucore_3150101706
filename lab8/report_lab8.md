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