#### kmalloc/kfree()

在pmm后面加了这么几行，但是我觉得，这个1024是不是打错了呀？虽然运行的时候也不会超过这个数。

主要做的事情就是控制内存分配的大小（不然会容易有溢出问题——但是。我觉得没卵用）

#### do_pagefault()

这里面主要需要描述的是一个数据结构。参考lab3的指导内容，我觉得基本上，要做的事情就比较简单。大概就是，之前只是对物理页框进行了管理，但是这里需要对虚拟地址空间进行管理，所以会有一样的FIFO之类的算法——但是其实，emmm比之前全都是硬件基础的好理解多了。

![页错误数据结构](.\页错误数据结构.png)

这里面就两个关键的数据结构。一个mm_struct, 一个vma_struct 

```
struct vma_struct {
    // the set of vma using the same PDT
    struct mm_struct *vm_mm;
    uintptr_t vm_start; // start addr of vma
    uintptr_t vm_end; // end addr of vma
    uint32_t vm_flags; // flags of vma
    //linear list link which sorted by start addr of vma
    list_entry_t list_link;
};
```

```
struct mm_struct {
    // linear list link which sorted by start addr of vma
    list_entry_t mmap_list;
    // current accessed vma, used for speed purpose
    struct vma_struct *mmap_cache;
    pde_t *pgdir; // the PDT of these vma
    int map_count; // the count of these vma
    void *sm_priv; // the private data for swap manager
};
```

vma这个结构，主要是链表的每个节点。

而mm这个结构则是，用于描述这整个链表的，其中mmap_list是头结点。其他的还有一堆属性。

it‘s easy to understand，所以我不写的特别详细，具体见那个指导材料。

而对于实验一，上面那些函数都是工具类，其执行流程其实是，page fault引起中断，调用lab1中描述的中断流程，其中对于中断分类的地方，找到对应的中断号，然后里面的执行，就是一个do_pagefault()函数。

```
CR2是页故障线性地址寄存器，保存最后一次出现页故障的全32位线性地址。CR2用于发生页异常时报告出错信息。当发生页异常时，处理器把引起页异常的线性地址保存在CR2中。操作系统中对应的中断服务例程可以检查CR2的内容，从而查出线性地址空间中的哪个页引起本次异常。


ucore中do_pgfault函数是完成页访问异常处理的主要函数，它根据从CPU的控制寄存器CR2中获取的页访问异常的物理地址以及根据errorCode的错误类型来查找此地址是否在某个VMA的地址范围内以及是否满足正确的读写权限，如果在此范围内并且权限也正确，这认为这是一次合法访问，但没有建立虚实对应关系。所以需要分配一个空闲的内存页，并修改页表完成虚地址到物理地址的映射，刷新TLB，然后调用iret中断，返回到产生页访问异常的指令处重新执行此指令。如果该虚地址不在某VMA范围内，则认为是一次非法访问。
```

这里面值得记录一下的是pgdir_alloc_page()函数，里面page insert（参考lab2的内容）就已经做了填充pte的事情，所以只需要检验，返回的page的指针是否合法就完成了exercise1.

#### swap

swap这边跟之前的物理页框分配差不多，也是做了一个分配器swap_manager；

这边做的事情，需要注意几个数据结构，一个是mm，一个是vma，还有一个是页框，

```
struct Page {
    int ref;                        // page frame's reference counter
    uint32_t flags;                 // array of flags that describe the status of the page frame
    unsigned int property;          // the num of free block, used in first fit pm manager
    list_entry_t page_link;         // free list link
    list_entry_t pra_page_link;     // used for pra (page replace algorithm)
    uintptr_t pra_vaddr;            // used for pra (page replace algorithm)
};
```

这个struct里面加入了两个，一个是list_entry_t pra_page_link，还有一个是，uintptr_t pra_vaddr，我个人觉得，这个pra_page_link指向的是虚拟的某个vma的节点，而后面那个指向的是具体的虚地址。

在mm结构中，有一个指向用于记录页访问情况的链表头，void *sm_priv，所以在swap的init工作就是

```
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
```

#### 其他

哦，这个最后还有一个实验报告要求——然而事实证明，这才是重要的部分。



