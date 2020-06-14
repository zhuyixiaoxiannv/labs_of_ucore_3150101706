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
其中list_entry_t 则被定义在list.h里面

反正就是初始化一个描述双向链表的数据结构。

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

也就是说，这边的end之后是n个page的数据结构，来指向所谓的内存页，所以这个（pages+i）就是情有可原的。(我想说reasonable的，但是中文这个意思就很。。。)

另外就是关于Page这个struct，他里面也有一个property的字段，但是，和下面的PG_property 是两个事情，SetPageReserved的时候，是对flag进行操作

请叫我天真，这里面pages这个变量是全局的一个指针，然后

```
pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
```

这行代码的作用其实是让这个指针，指向BSS段结束位置向上4k对齐的位置的一个地址（换而言之，BSS段结束和pages这个指针的位置，中间还有点空隙

之后工作就是分开已占用的内存和未占用内存

```
为了简化起见，从地址0到地址pages+ sizeof(struct Page) * npage)结束的物理内存空间设定为已占用物理内存空间（起始0~640KB的空间是空闲的），地址pages+ sizeof(struct Page) * npage)以上的空间为空闲物理内存空间,这时的空闲空间起始地址为

uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
```

他的做法是，先把所有的都标记上了占用，然后再把后面的部分给标记上未占用。

前面的一堆对于开始和结束的if语句其实没啥啥，反正就是获取到Pages数据结构结束的位置到top的空间，然后调用
```
init_memmap(pa2page(begin), (end - begin) / PGSIZE);
```
分配给manager里面进行操作。——~~但是这个好像就把第一个节点给加进了链表~~——不懂。。。再往下看。(哦，原来是要我写)

总结一下下，就是探测完可用内存后（需要考虑可用内存不连续的问题）然后kernel结束的位置end向上4k对齐之后，放置n个struct Pages的数据结构指向所有内存，一开始全都设为已经被占用，然后计算出所有可用内存占用的页号（考虑不连续问题），并设置为空闲，并用manager来进行链表数据结构的设定（这里面pmm和default_manager的功能划分和层次还是很清晰的)

4. check_alloc_page（）

这是默认的check的过程，不需要看，要我写的代码不在这里。就是跑到这行，对于kernel来说没啥作用，就是只是为了检查上面的函数对不对，这步之前是EXERCISE1。

# 练习1：实现 first-fit 连续物理内存分配算法（需要编程）

在实现first fit 内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改default_pmm.c中的default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数。请仔细查看和理解default_pmm.c中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

你的first fit算法是否有进一步的改进空间

#### Answers：

首先对于前面的阅读进行一定的回顾，大概就是在pmm_init()这个函数中，已经探测所有可用地址，然后基于可用地址，切分并实现了每个页框，用Page这个struct记录，位置放在内核代码后面。并且把n个Page struct之后的所有可用地址标注为unReserved

然后定义了一个alloc/free的manager，用于分配和释放可用的内存页。

~~但是正如前面读的时候的问题，在page manager里面，并没有完全的实现这个双向链表的建立，就是，所有节点都弄了，但是没有搭建起来这个链表~~，具体可见default_manager的default_init_memmap这个函数。

正如我之前猜想的一样，因为要动态分配内存，所以设计了block。就是一个block里面有多个page，然后list并不是用页表作为节点的，而是用block作为节点的。每个block，一个是链表，一个是这个block有多少个page

```
 *  - If this page is free and is not the first page of a free block,
 * `p->property` should be set to 0.
 *  - If this page is free and is the first page of a free block, `p->property`
 * should be set to be the total number of pages in the block.
```

well，还是画个图吧

我自己画了个图，emmm，这是个带头结点的双向链表，就下面那条“他的内容和page struct里表示头结点的那个是一样的”这句话，是错误的，他有个单独的头结点。

空链表就一个头结点，而正确的链表实际上是头结点加上这n个page结构。

![物理页分配管理](.\物理页分配管理.png)

大概就是这样，如果不能理解，再多看几遍代码

（我怎么看怎么觉得，这几个代码都已经写好了的样子）

（也很神奇，我对比了一下跟答案的代码，差别不是很大呀，为啥一个跑的出来一个不行。。。这并不科学。

哦我直接检查那个check里面的内容，发现按照原来的方式，free之后，链表并不按照地址顺序排列，而是，free的block直接插入在尾部，导致check里面的检查p0的时候，原本应该分配在p2这个页前面的一个页框，现在跑到后面去了。

另外需要记录一下对于这个双向链表的遍历（貌似是通用的格式）

```
list_entry_t *le = list_next(&free_list);
while (le != &free_list) {
        p = le2page(le, page_link);
        le = list_next(le);
        ...
}
```

哦，成功了，我之前直接把free后面多的那段代码拷贝过来的时候，没有注意到下面那个listadd，list_add 是插入在后面的，但是，前面那个while循环是寻找到第一个在之后的节点，然后在他前面插入。

所以，做的事情就是，把最后那行listadd删了，再加上

```
	le=list_next(&free_list);
	while(le != &free_list){
        p = le2page(le, page_link);
        if(base + base->property < p){
            break;
        }
        le = list_next(le);
 	}
    list_add_before(le, &(base->page_link));
```

说真的，原来的代码当中还有一个等于号，并且对等于的情况作了一个assert，但是我个人对此的考虑认为，由于alloc的情况，应该不会出现这种问题。

而如果要检验的话，应该做的事情，不仅仅是考虑等于的情况，而应该是考虑下一个节点p在base到base+size这个区间内的情况都考虑进去。（个人看法）

总而言之，这个pmm_manager的设计，真的挺棒的。

但是，也并非完美无缺，说句实在话。因为每个page的node都被定义为有一个前向节点和后向节点——当然你可以使用其中某个然后弃用另一个——这只适合一些特定的数据结构，二叉树，双向链表都看上去不错，但我觉得不是所有的数据结构都适用，比如那个伙伴算法，需要进行一定的改写——把前向节点视为左节点，后向节点视为右节点等等（并且我并不觉得这有用。

关于改进空间。

**练习2：实现寻找虚拟地址对应的页表项（需要编程）**

通过设置页表和对应的页表项，可建立虚拟内存地址和物理内存地址的对应关系。其中的get_pte函数是设置页表项环节中的一个重要步骤。此函数找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。本练习需要补全get_pte函数 in kern/mm/pmm.c，实现其功能。请仔细查看和理解get_pte函数中的注释。get_pte函数的调用关系图如下所示：

(图片我就不放了)

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请描述页目录项（Pag Director Entry）和页表（Page Table Entry）中每个组成部分的含义和以及对ucore而言的潜在用处。
- 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

#### Answers:

PDT（page directory table）

PTE（page table entry）

首先呢，页目录表占10位，页目录表4k，而且只有一个，所以每个页表在页目录表里面占4字节。

同样的每个页，在页表中也占用4字节。

以及，最好去看一下页表项相关的内容，他的内容我表示并没有看到
由于页都是4k对齐，所以页表项的低12位都是不使用的，高20位表示页框。至于没用到的低12位，主要的是三个位置，P-存在位present，D-dirty修改位，A-Accessed已访问位。
D和A都是硬件置位，所以不用担心，P置位则表示可用。

这里面需要注意的地方在于虚拟地址和真实的地址。
memset用的是虚拟地址。

emmm，再说一句，只有练习二和练习三都写完了，才能正确运行。就他里面有一个ref，练习二是二级页表不存在的时候给他创建一个新的，会把二级页表使用的页的ref从0设为1，而练习三则是减一（并且如果物理页框的 ref==0 的时候就释放这个物理页框）

所以只做练习二会导致ref没有减，所以就gg。（相关文档我等会再写）