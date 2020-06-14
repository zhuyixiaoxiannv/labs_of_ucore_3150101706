# 本文档的作用同lab1的KeyPoints

### 段页式管理内存

![段页式](.\段页式.png)

首先，见lab2实验报告里面对于entry.s里面的内容的阅读，一开始，在没有开启分页机制的时候，是线性地址就是物理地址，逻辑地址是为了在GDT中寻找线性地址

如果开启了分页机制，则可以启用虚拟地址，逻辑地址先通过GDT转换为线性地址，线性地址再通过页表转换为物理地址。

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

![物理内存布局](E:/code/操作系统/ucore实验及报告/mylab/lab2/物理内存布局.png)

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

换句话说，这个函数里面需要考虑的知识点，就是EXERCISE1做的事情，那个双向链表和block之间的关系（具体内容见report吧，没啥要多说的）主要是对于可用的物理页框的alloc/free。

5. check_pgdir()

这个函数和上一个函数一样都是用于检查的。但是这里面需要考虑以下几个组件。(我是说大的组件，那些小函数就算了吧)

```
get_page()
page_insert()
page_remove()
	|----get_pte()
	|----page_remove_pte()
	|	(above 2 is what we need to write in exerice)
```

get_page() 就是根据一个虚拟线性地址la，得到对应的页面

page_insert()  我看了一下，应该是做的把la指向的那个虚拟页（确切的说是page table entry项）指向某个物理页框page,我引用在下面。

```
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
    pte_t *ptep = get_pte(pgdir, la, 1);
    //从系统中找到la所对应的pte指针。
    if (ptep == NULL) {
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_P) {
    	//如果这个物理页是存在的，那么和想要新赋值的page做对比，相同，那么减少引用次数
    	//否则，移除pte项
        struct Page *p = pte2page(*ptep);
        if (p == page) {
            page_ref_dec(page);
        }
        else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    //重置pte项
    *ptep = page2pa(page) | PTE_P | perm;
    tlb_invalidate(pgdir, la);
    return 0;
}
```

以及，对这个函数的两个引用我想可以对于理解有一定的帮助。

```
	p2 = alloc_page();
   	assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
	assert(page_ref(p2) == 1);
	
	assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
    assert(page_ref(p1) == 2);
    assert(page_ref(p2) == 0);
```

这里面，一开始对于p2这个页的引用是1，然后让这个页指向了p1这个物理页框，所以p2这个页的引用为0，反而p1的引用值增加了。

(一个问题是，TLB是什么时候建立的？？？)

——另外，我们必须注意到一件事，这里面物理地址和线性地址的映射并没有实现，而是在之后的boot_map_segment实现的。

page_remove也是一样，释放某个pte项对应的物理页框。

**注意：1.这个函数只是测试这几个组件，并没有任何卵用（我是说没有实际应用）**
**2.这三个组件的作用都是将虚拟线性地址和物理页框进行对应。一个是根据la得到物理页框，一个是重新分配物理页框，重新指定某个线性地址所在的pte对应的物理页框，还有一个是，清除某个线性地址对应的物理页框的映射。**
**3.这个时候还没有建立TLB，都说了是测试了啦。**
**4. 这些函数的下一层是基于对于物理页框的分配alloc/free**

在参考网页上面说，pte是理解虚拟地址到物理地址的映射的重中之重，我的理解是，一个虚拟的页，其本身是不存在的，而是通过对应la描述的pte才能够被表示，只有当它们被映射到某个具体的物理页框上面的时候，才能够被看见。——但是由于不同的映射算法，每个物理页框都可能被多次引用。换而言之，pte就是用来表述这个虚拟页的作用的，所以说是重中之重。

6. boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
说句实在的，到目前为止我还不知道他到底怎么映射的
就目前，用的还是entry.S里面定义的boot_pgdir来作为页目录表，而接下来的要做的事，是建立虚拟页目录表。
VPT的值为0xFAC00000，（我怎么觉得是因为高10位的值为十进制的1003，表示清华的代码呢，好你秀任你秀）

这部分请参考课程网站的附录D

这句话的含义，我们先来讲一个事情，叫做自映射的机制

#### 页表自映射
1个page占用了12位也就是4096b，而一个二级页表，中间的那段，占用10位，可以表示1024个page，加起来，总共4mb，也就是说，一个页目录表中间的页目录项，指向4mb的内存。

而对于一个2级页表，总共也正好需要4mb的大小。
所以这样就有一个骚操作，把页目录表放在其中某个页目录项指向的位置。称为页表自映射

但是这样做是有代价的，接前面的话，也就是二级页表需要全都放在这4mb的空间内，且按照4mb对齐。

另外，对于他的位置，也不能随随便便安排了，而是说，页目录表起始地址的高10位和中10位应该相同。而其第一个页目录项，则应该为页目录表高10位，后面全都填充为0。

所以这句代码，应该说的就是这件事

7. boot_map_segment（）

这个代码就是将虚拟空间映射到实际物理空间，一页一页的进行然后把页表的pte对应过去。
这很好理解——由于前面所描述的自映射机制。

在这里面我必须解释一下，这个函数以及上面一段话的作用是如何使得所有2级页表全都集中在4mb里面而不是别的地方的。

必须要明确的一点是，这种集中在4mb指的是在虚拟的线性地址角度来看的，但是并不意味着一定会在物理地址上面连续（这取决于get_pte里面的alloc，换句话说，page_manager的分配机制

首先上一句话，把pgdir的起始地址设为那个之后，然后，la+=PGSIZE，pa+=PGSIZE这个地方才是关键

la每次加一，然后去找这个线性地址对应的pte项，那一定是连续的分布的。
但是必须注意的事情（但这边没有写进去，因为设定内存没有那么多）就是因为这4mb的内存相当于被固定使用住了。所以这块区域内存的二级页表项，实际上是不存在的。

所以如果把这部分映射过去的话，就会破坏掉页目录表。但是这边页目录表的自映射用的是1003，但是操作系统用到的这块内存大小只有不到1GB，相比于虚拟空间最多4GB来说，肯定访问不到，所以没问题。

事实上，整个操作系统使用的虚拟空间，是低size，加上1003那4mb内存。

如果想要整个4GB内存，（肯定不可能，得4GB-4mb）那么这个boot_map_segment函数必须跳过这部分。

（说真的我已经写的有点意识模糊了，这，有点难度，我才不是那种只顾刷完实验的人）

另外，这只是改变pte的结构，就是将虚拟的页和pte一一对应起来。然后将pte映射到物理页框——但着不意味着到时候能够使用这个物理页啊。

8. gdt_init()

9. check_boot_pgdir()
这里面我只说一个例子
```
	struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
    assert(page_ref(p) == 1);
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
    assert(page_ref(p) == 2);
    //这里面0x100和0x+PGSIZE指向的是同一个物理页框。

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
    //所以两个比较会一致
```
想了很久，然后终于明白这种映射，（然后也觉得，get_pte里面，物理地址和虚拟地址这种东西为什么这么讲了，切记，每个表项，无论是页目录表还是页表，里面的某个项的内容，都是下一级页的物理地址），觉得很神奇。

10. print_pgdir()
没啥好说的，就是遍历，然后打印。