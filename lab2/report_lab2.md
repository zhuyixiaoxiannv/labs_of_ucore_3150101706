# 练习0：填写已有实验

本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有“LAB1”的注释相应部分。提示：可采用diff和patch工具进行半自动的合并（merge），也可用一些图形化的比较/merge工具来手动合并，比如meld，eclipse中的diff/merge工具，understand中的diff/merge工具等。

### Answers：

emmm我是直接复制过去了，但是，怎么说呢，不是那么的emmmm正规，另外，貌似lab2和lab1之间的代码还有一定的差别，所以我在这边记录一下这些差别，以及对这些东西的理解。

另外，看上去五个实验——对的，是五个，之前的lab1的challenge因为需要用到后面的知识，所以并不做处理，但是这个lab2的几个实验，其实都是可以做的。

（据说lab1和lab2都很难。。。）

lab2代码中比起lab1中多出来的部分：
#### 1. bootasm.s
```
probe_memory:
    movl $0, 0x8000
    xorl %ebx, %ebx
    movw $0x8004, %di
start_probe:
    movl $0xE820, %eax
    movl $20, %ecx
    movl $SMAP, %edx
    int $0x15
    jnc cont
    movw $12345, 0x8000
    jmp finish_probe
cont:
    addw $20, %di
    incl 0x8000
    cmpl $0, %ebx
    jnz start_probe
finish_probe:
```
这段汇编是用来探测可用内存的
资料中的说法是

```
一般来说，获取内存大小的方法由 BIOS 中断调用和直接探测两种。但BIOS 中断调用方法是一般只能在实模式下完成，而直接探测方法必须在保护模式下完成。通过 BIOS 中断获取内存布局有三种方式，都是基于INT 15h中断，分别为88h e801h e820h。但是 并非在所有情况下这三种方式都能工作。在 Linux kernel 里，采用的方法是依次尝试这三 种方法。而在本实验中，我们通过e820h中断获取内存信息。因为e820h中断必须在实模式下使用，所以我们在 bootloader 进入保护模式之前调用这个 BIOS 中断，并且把 e820 映 射结构保存在物理地址0x8000处。
```

**e820h参数的int 15h调用**

```
eax：e820h：INT 15的中断调用参数；
edx：534D4150h (即4个ASCII字符“SMAP”) ，这只是一个签名而已；
ebx：如果是第一次调用或内存区域扫描完毕，则为0。 如果不是，则存放上次调用之后的计数值；
ecx：保存地址范围描述符的内存大小,应该大于等于20字节；
es:di：指向保存地址范围描述符结构的缓冲区，BIOS把信息写入这个结构的起始地址。
```

返回值为

```
cflags的CF位：若INT 15中断执行成功，则不置位，否则置位；
eax：534D4150h ('SMAP') ；
es:di：指向保存地址范围描述符的缓冲区,此时缓冲区内的数据已由BIOS填写完毕
ebx：下一个地址范围描述符的计数地址
ecx    ：返回BIOS往ES:DI处写的地址范围描述符的字节大小
ah：失败时保存出错代码
```

然后对于探测的结果保存在一个0x8000地址开始的一个数据结构e820map中

```
struct e820map {
                  int nr_map;
                  struct {
                                    long long addr;
                                    //起始地址，64位
                                    long long size;
                                    //长度，64位
                                    long type;
                                    //type为1表示可以被os使用
                                    //type为2表示被使用或者被系统保留
                  } map[E820MAX];
};
```
总共长度为8+8+4=20，也就是ecx存放的20表示的含义，之所以放到0x8004，是因为前面还有一个int结构。

描述最后一个可用内存段的baseaddr+length即可得到内存容量

然后查看了代码之后，发现，没有置位也就是int15调用失败就往0x8000位置写入12345。。。而且。另一件事情就是，如果因为内存分段不是全都连续的，这么做，**只会探测出最后一段可用内存的起始位置**。。。

所以真正的os（按照前面的说法，还要各种探测方法轮换使用），有时候需要管理这些未必连续的地址，那就不是一个地址描述符够用的了。

#### 2. entyr.s

这个文件的运行顺序，是在bootmain.c调用elf文件的入口之后，kernel的最开始执行的函数，而在kernel init之前。

（看了之后，第一反应，就一个感想，什么东西啊？）

之前说到CR0有各种控制位，还有CR1保留，CR2为页异常线性地址，CR3的高20位为页目录基地址
这个文件分为两个部分，一个是代码部分，还有一个是数据部分。
这个kern_entry，一开始设置了cr3，值为__boot_pgdir这个数据结构减去KERNBASE。
但是说真的我不知道，这个应该怎么解释。

KERNBASE也就是内核代码的基地址在memlayout.h 里面设置了，是0xC0000000

嗯好，参考一下ucore说明里面的lab2附录c，链接地址/加载地址/虚地址/物理地址
开启了分页机制之后，
ucore内核的链接地址==ucore内核的虚拟地址；boot loader加载ucore内核用到的加载地址==ucore内核的物理地址。
在没有开启分页机制之前，没有虚拟地址这种东西，只有开启了虚拟地址才行。

所以
```
	orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
    andl $~(CR0_TS | CR0_EM), %eax
    movl %eax, %cr0
```
开启分页机制和虚拟地址

```
	# update eip
    # now, eip = 0x1.....
	leal next, %eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
```
从而真的开启了虚拟地址。

另外需要注意的是tools/kernel.ld文件里面的链接地址，对比lab1里面的链接地址（那个时候没有开启虚拟地址，所以链接地址为实际加载的位置。

并且，因为这个原因，存在地址的转换，所以不能使用C代码，需要一个汇编代码来搞定。