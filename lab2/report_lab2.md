# 练习0：填写已有实验

本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有“LAB1”的注释相应部分。提示：可采用diff和patch工具进行半自动的合并（merge），也可用一些图形化的比较/merge工具来手动合并，比如meld，eclipse中的diff/merge工具，understand中的diff/merge工具等。

### Answers：

emmm我是直接复制过去了，但是，怎么说呢，不是那么的emmmm正规，另外，貌似lab2和lab1之间的代码还有一定的差别，所以我在这边记录一下这些差别，以及对这些东西的理解。

另外，看上去五个实验——对的，是五个，之前的lab1的challenge因为需要用到后面的知识，所以并不做处理，但是这个lab2的几个实验，其实都是可以做的。

（据说lab1和lab2都很难。。。）

# 练习1：实现 first-fit 连续物理内存分配算法（需要编程）

在实现first fit 内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改default_pmm.c中的default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数。请仔细查看和理解default_pmm.c中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

你的first fit算法是否有进一步的改进空间

#### Answers：

首先对于前面的阅读进行一定的回顾，大概就是在pmm_init()这个函数中，已经探测所有可用地址，然后基于可用地址，切分并实现了每个页框，用Page这个struct记录，位置放在内核代码后面。并且把n个Page struct之后的所有可用地址标注为unReserved

然后定义了一个alloc/free的manager，用于分配和释放可用的内存页。

~~但是正如前面读的时候的问题，在page manager里面，并没有完全的实现这个双向链表的建立，就是，所有节点都弄了，但是没有搭建起来这个链表~~，具体可见default_manager的default_init_memmap这个函数。

正如我之前猜想的一样，因为要动态分配内存，所以设计了block。就是一个block里面有多个page，然后list并不是用页框作为节点的，而是用block作为节点的。每个block，一个是链表，一个是这个block有多少个page

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

# ---------------------------------------------- #

#### Attention！！！！！！

（2020/06/19补充）

我还是too young，在做lab4的时候，发现这里面有问题，我现在是直接抄了answer的代码然后让他跑通了。

主要我以为原来的代码没啥毛病，虽然上面写了要加东西，但是。。。emmm还不如给人全都空着让我们自己填写呢。太。。。太过分了。

最后检查了一下，原来，其实只是default_alloc_pages少了一行,在改动的lab4文件那里line：142（但是并不打算再同步到lab2和lab3里面了）

```
SetPageProperty(p);
```
我个人推测当初没注意到的原因是，PG_property和property这两个东西给弄混了。一个这个block的页的数目，另一个是指明是否是头结点这件事。
# ---------------------------------------------- #

总而言之，这个pmm_manager的设计，真的挺棒的。

但是，也并非完美无缺，说句实在话。因为每个page的node都被定义为有一个前向节点和后向节点——当然你可以使用其中某个然后弃用另一个——这只适合一些特定的数据结构，二叉树，双向链表都看上去不错，但我觉得不是所有的数据结构都适用，比如那个伙伴算法，需要进行一定的改写——把前向节点视为左节点，后向节点视为右节点等等（并且我并不觉得这有用。

关于改进空间。

# 练习2：实现寻找虚拟地址对应的页表项（需要编程）

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

所以只做练习二会导致ref没有减，所以就gg。所以我还是放在练习3下面去进行文档描写吧。（相关文档我等会再写）

# 练习3：释放某虚地址所在的页并取消对应二级页表项的映射（需要编程）

当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。请仔细查看和理解page_remove_pte函数中的注释。为此，需要补全在 kern/mm/pmm.c中的page_remove_pte函数。page_remove_pte函数的调用关系图如下所示：

（图片也不放了

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

- 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ **鼓励通过编程来具体完成这个问题**

#### Answers:
练习2和3的内容，最主要的是理解其过程。（但是这里面还需要考虑虚拟地址和真实地址的区别）
页目录表——> 页表——> 页

#### 2. 

```
	pde_t *pdep = pgdir + PDX(la);
    struct Page *page;
    uintptr_t pa;
    if(!((*pdep)&PTE_P)){
        if(!create){
            return NULL;
        }
        page=alloc_page();
        if(page==NULL){
            return NULL;
        }
        set_page_ref(page,1);
        pa = page2pa(page);
        *pdep=pa|PTE_P|PTE_W|PTE_U;
        memset(KADDR(pa),0x0,PGSIZE);
    }
    else{
        pa=(*pdep)&0xFFFFF000;
    }
    pte_t *pte=pa;
    pte=KADDR(pte+PTX(la));
    return pte;
```

页目录表的起始地址是pgdir，这是一个虚拟地址，

```
         page dirctory table    page table
         -----------            -----------
pgdir -> |         |   |---->   |         |  <- pa 
         -----------   |        -----------  (pa is physical address)
         ...           |        ...
         -----------   |        -----------
pdep->   |         | ---        |         |  <- pte
         -----------            -----------
                                     |
                                     ----------->  struct page
```

具体结构如上图所示，

pgdir加上PDX（la）的偏移值，得到pdep的位置，然后pdep的内容指向二级页表的起始地址（以及该页的属性）。
所以get_pte这个函数的执行过程，先检查page table这个页是否存在，如果不存在，那么需要创建（如果create这个属性也为false，那么就凉凉了）。

调用page_alloc之后获取一个物理页，这个地址pa是个物理地址，对应的page结构的地址也是物理地址，所以要KADDR（pa）来得到page table的虚拟地址。
而pdep位置里面填写的则是物理地址pa。（为什么？）

物理页框的ref从0+到1，清理掉物理页的内容（这里面却要用虚拟地址，迷）。

如果这个页是存在的，需要把后面的几位都清掉得到二级页表的起始位置。并加上PTX（la）的偏移值，得到指向pte这个页表项的指针。

我觉得这里面不懂的地方在于，memset里面用虚拟地址，而页目录表的表项里面填写的是物理地址。

看了page_insert函数之后好像有点懂了，就是，**页目录表的表项，页表项里面指向的地址都是某个物理页的地址。** 至于memset，之所以用虚拟地址，是因为，他在entry.s里面enable了虚拟地址之后，现在就运行在虚拟地址下面。

#### 3.

```
    if(!((*ptep)&PTE_P)){
        return;
    }
    struct Page *page = pte2page(*ptep);
    page_ref_dec(page);
    if(page_ref(page)==0){
        free_page(page);
    }
    //*ptep=(*ptep)&0xFFFFF000;
    //修正，这里面不是把存在位等等清除，而是直接清零。emmmm我在报告中再讨论两者的差别。
    *ptep=0;
    tlb_invalidate(pgdir,la);
```

因为这里面直接给出了二级页表的页表项ptep，先检查是否存在这个页。

这个函数的做法是，清理掉这个页目录项及其所对应的的页内容。首先根据ptep这个，得到物理页框的位置page

物理页框的ref减去1，并且当为0 的时候，就释放这个物理页。

然后再把ptep这个页表项清零（我以为只是把存在位给清除掉，但是这边觉得是要清零。）