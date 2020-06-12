# 练习0：填写已有实验

本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有“LAB1”的注释相应部分。提示：可采用diff和patch工具进行半自动的合并（merge），也可用一些图形化的比较/merge工具来手动合并，比如meld，eclipse中的diff/merge工具，understand中的diff/merge工具等。

### Answers：

emmm我是直接复制过去了，但是，怎么说呢，不是那么的emmmm正规，另外，貌似lab2和lab1之间的代码还有一定的差别，所以我在这边记录一下这些差别，以及对这些东西的理解。

另外，看上去五个实验——对的，是五个，之前的lab1的challenge因为需要用到后面的知识，所以并不做处理，但是这个lab2的几个实验，其实都是可以做的。

（据说lab1和lab2都很难。。。）

lab2代码中比起lab1中多出来的部分：

（其实读着读着，感觉就明白做了什么，实验代码反而只是一个实现，感觉也就这样吧）

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

~~然后查看了代码之后，发现，没有置位也就是int15调用失败就往0x8000位置写入12345。。。而且。另一件事情就是，如果因为内存分段不是全都连续的，这么做，**只会探测出最后一段可用内存的起始位置**。。。~~

~~所以真正的os（按照前面的说法，还要各种探测方法轮换使用），有时候需要管理这些未必连续的地址，那就不是一个地址描述符够用的了。~~

well，我为我之前这段话写的错误表示道歉，事实上，c代码中定义的e820map包含了最多20个可用的内存段的信息。

因为他用了个数组，map[E820MAX]。

而在boot的这段汇编代码中，并没有对于到底有多少个连续的内存段的探测，所以上限其实可能超过20个，并且在内存检测中，也没有把这个上限当回事，ECX只是描述描述符占用地址大小的——尽管这在通常情况下不会导致错误，正如一般来说堆栈并不会溢出一样。但并不绝对。

在page_init这个函数的开始，就对于这个数据

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

**tools/kernel.ld**

另外需要注意的是tools/kernel.ld文件里面的链接地址，对比lab1里面的链接地址（那个时候没有开启虚拟地址，所以链接地址为实际加载的位置。

并且，因为这个原因，存在地址的转换，所以不能使用C代码，需要一个汇编代码来搞定。

随后，它重新设置了kernel的堆栈

另外，附录C中有段话我觉得也比较重要

```
edata/end/text的含义

在基于ELF执行文件格式的代码中，存在一些对代码和数据的表述，基本概念如下：

BSS段（bss segment）：指用来存放程序中未初始化的全局变量的内存区域。BSS是英文Block Started by Symbol的简称。BSS段属于静态内存分配。
数据段（data segment）：指用来存放程序中已初始化的全局变量的一块内存区域。数据段属于静态内存分配。
代码段（code segment/text segment）：指用来存放程序执行代码的一块内存区域。这部分区域的大小在程序运行前就已经确定，并且内存区域通常属于只读, 某些架构也允许代码段为可写，即允许修改程序。在代码段中，也有可能包含一些只读的常数变量，例如字符串常量等。
在lab2/kern/init/init.c的kern_init函数中，声明了外部全局变量：
extern char edata[], end[];
但搜寻所有源码文件*.[ch]，没有发现有这两个变量的定义。那这两个变量从哪里来的呢？其实在lab2/tools/kernel.ld中，可以看到如下内容：

…
.text : {
        *(.text .stub .text.* .gnu.linkonce.t.*)
}
…
    .data : {
        *(.data)
}
…
PROVIDE(edata = .);
…
    .bss : {
        *(.bss)
}
…
PROVIDE(end = .);
…
这里的“.”表示当前地址，“.text”表示代码段起始地址，“.data”也是一个地址，可以看出，它即代表了代码段的结束地址，也是数据段的起始地址。类推下去，“edata”表示数据段的结束地址，“.bss”表示数据段的结束地址和BSS段的起始地址，而“end”表示BSS段的结束地址。

这样回头看kerne_init中的外部全局变量，可知edata[]和 end[]这些变量是ld根据kernel.ld链接脚本生成的全局变量，表示相应段的起始地址或结束地址等，它们不在任何一个.S、.c或.h文件中定义。
```

**页目录基地址寄存器**

分页之后其内容一定是4k字节对齐的，所以，末12位是0。

在entry.s文件中，除了代码之外，还有一个页目录的数据结构。

（算了先不管这个了）

#### 3. pmm.c(主要是pmm_init)
在kernel中执行的pmm_init是其顶层函数之一
1. 第一行，boot_cr3是个在这个c文件中定义的一个变量，反正意思就是boot过程中用的页目录表基地址呗，PADDR则是一个将虚拟地址减去0xC。。。。的一个操作，但是对于虚拟地址小于这个base地址还报个错。

  ```
  boot_cr3 = PADDR(boot_pgdir);
  ```

  

2. 接下来，init_pmm_manager(),这函数就很简单，调用了default pmm_manager的一个init方法，并且输出当前的memory management的名字。

  ```
  static void
  init_pmm_manager(void) {
      pmm_manager = &default_pmm_manager;
      cprintf("memory management: %s\n", pmm_manager->name);
      pmm_manager->init();
  }
  ```

  

  至于pmm_manager的init

  ```
  default_init(void) {
      list_init(&free_list);
      nr_free = 0;
  }
  ```

  

  首先得说起来，list.h里面定义的一个双向链表，pmm_manager中只有一个这个双向链表的init，也就是list_init()，而这个init，做的很简单，生成一个节点，然后前向指针指向他自己，后向指针也指向他自己就完了，就一个节点。

  而对于这个节点，这个free_area_t是一个struct，他的定义在，memlayout.h里面：

```
typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
} free_area_t;
```
​	其中list_entry_t 则被定义在list.h里面

​	反正就是初始化一个描述双向链表的数据结构。
3. 然后是page_init()
    这里面就是用到了前面探测的e820map的信息

  首先来设置kernel的内存分页。

  第一步遍历所有的每个表项，然后得到mem的top（要么是KMEMSIZE，要么就是比这小的可用地址上限，反正两个取小的，这里面可用内存的上限表示为maxpa，也就是max physical address。

  ```
  cprintf("e820map:\n");
      int i;
      for (i = 0; i < memmap->nr_map; i ++) {
          uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
          cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                  memmap->map[i].size, begin, end - 1, memmap->map[i].type);
          if (memmap->map[i].type == E820_ARM) {
              if (maxpa < end && begin < KMEMSIZE) {
                  maxpa = end;
              }
          }
      }
      if (maxpa > KMEMSIZE) {
          maxpa = KMEMSIZE;
      }
  ```

  

  然后，注意这里面用到的一个extern char end()前面提到过，是ld链接脚本的数据，表示BSS段的结束。

  ~~前面得到了，Kernel可用地址的上限，这边的end表示内核代码和静态数据段的结束，在end和可用地址上限之间，则是我们在kernel中可以使用的地址。~~

  ~~又因为要分页，所以，end对4k页对齐并向上取整。完了就可以分页了。~~

  

  好吧，我太天真了。这个SetPageReserved函数，是对Page这个struct，进行置位，因为这部分的内存属于kernel的，所以，置位0。这也没有错，但是我其实没怎么看懂，pages这个struct Page的指针，他++是几个意思。

  就你（pages+i）访问到的是什么，他也不是C++运算符重载，然后指向下一个节点呀？

  ```
  	extern char end[];
  
      npage = maxpa / PGSIZE;
      pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  
      for (i = 0; i < npage; i ++) {
          SetPageReserved(pages + i);
      }
  ```

  哦，去参考阅读一下下，3.3.3 以页为单位管理物理内存，里面有对于这段代码的详细描述。

  另外，这段描述下面的参考图片我觉得很有参考价值，我放在这边

![物理内存布局](.\物理内存布局.png)

也就是说，这边的end之后是n个page的数据结构，来指向所谓的内存页，所以这个（pages+i）就是情有可原的。

请叫我天真，这里面pages这个变量是全局的一个指针，然后

```
pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
```

这行代码的作用其实是让这个指针，指向BSS段结束位置向上4k对齐的位置的一个地址（换而言之，BSS段结束和pages这个指针的位置，中间还有点空隙