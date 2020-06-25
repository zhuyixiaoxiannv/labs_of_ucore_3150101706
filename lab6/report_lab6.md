运行的代码，有两个一个是用于测试的，

```
make grade
```

还有一个用于正常操作的，同lab4

```
qemu-system-i386 -s -hda bin/ucore.img -drive file=./bin/swap.img,media=disk,cache=writeback -monitor vc --nographic
```

# 练习0：填写已有实验

本实验依赖实验1/2/3/4/5。请把你做的实验2/3/4/5的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”“LAB5”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab6的测试应用程序，可能需对已完成的实验1/2/3/4/5的代码进行进一步改进。

#### Answers：

哦呦我真的是每次都要为exercise0给操心，真的是心累好伐，代码复制过去了，但是并没有把lab6（甚至没有lab5_result跑通）而且两个地方都是一样的报错——而且，lab5_result用的是他源代码，我没改过任何地方。

我说一下问题的定位哦，这次的问题，我也表示看不懂了，事情是这样的，会在vmm.c的check_pgfault函数的357行（差不多这附近吧）在free_page函数释放这个page的时候，存在了错误。
说的是
```
 assertion failed: !PageReserved(p) && !PageProperty(p)
```
这个报错。
然后呢，我仔细查看了这个东西，原因应该是前面访问0x100这个虚拟线性地址的时候，正确的应该报一个页缺失的错误，然后巴拉巴拉一堆处理，之后释放这个页就完了。

上面说的是正确的，然鹅，包括lab5_result代码中的，这个页其实在之前check_boot_pgdir()函数（查看pmm_init里面找吧）里面也用到了这个0x100地址，换句话说，之前检测的时候，这个页没有释放掉其实，所以后面出了一堆问题。

神奇就神奇在这里面。我怀疑我lab3 的code也有错，但是一查并不是这样的，在check_boot_pgdir()函数之后，访问这个地址，还是能访问到的，但是print_pgdir（）之后就访问不到了，不知道为什么。

更神奇的是，我查看了lab3_result的代码，发现，在这里面，则是跳出pmm_init函数之后则访问不到这个地址了，而不是之前。。。我真的受够了，不懂得这里面的问题在哪里。

唯一的一个好消息算是，直接将测试的addr改成0x1000之后就跑的通。（但这并没有卵用，相当于让他去找第二页，但是并没有解决第一页存在的问题，确切的说，第0页，懂我意思就行了）

我的看法则是pte的问题，我在lab5_result的check_pgfault（）这个函数这边，addr定义后面加了两行，来验证问题存在——其中get_pte的后面create参数可以为0和1，就能明白了。

```
	uintptr_t addr = 0x100;
    pte_t *ptep=get_pte(boot_pgdir,addr,0);
    cprintf("%08x\n",ptep);
```

参数为0，就是不创造pte的时候，不会报页中断，其实在页表中没有对应的pte，这个时候的pgdir[0]是0，那么表示这个pte的页不存在，但是没报页中断，依然能正常访存——这就离谱。

参数为1的时候，相当于申请了page，这个时候肯定不会有页中断了，但是其他一切正常，后面都可以用。

于是我查看了ptep的内容

```
	cprintf("%08x\n",pgdir);
    pde_t *pdep=&pgdir[PDX(addr)];
    cprintf("%08x\n",pdep);
    cprintf("%08x\n",*pdep);
    pte_t *ptep=&((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(addr)];
    cprintf("%08x\n",ptep);
    cprintf("%08x\n",*ptep);
    assert(find_vma(mm, addr) == vma);
```

```
c0124000
c0124000
00000000
c0000000
f000ff53
```

结果是这样子的。我就很神奇了，按照页表的查询来看。这不可能啊，

（表示头大）

算了就俩解决方案，一个是这边改成0x1000，要么就是那边不要check（反正能对就行了），大概就是把check_boot_pgdir注释掉，我个人倾向于后一种，因为可能不知道为什么莫名其妙（反正我也不想去测试了）这段代码会导致某些内存结构被破坏掉，而且他只是一个check函数，并没有做什么事情。

（我今天算是学会了程序员如何和稀泥，简单来说，只要能跑就行了，到底bug出在哪里，根本不重要好伐。）

哦我反应过来，可能，还有一个东西叫做快表。

果然如此，在这里面，少了删除快表中的内容。

所以解决方案是，要在pmm.c的check_boot_pgdir（）的末尾加上

```
    tlb_invalidate(boot_pgdir, 0x100);
    tlb_invalidate(boot_pgdir, 0x100+PGSIZE);
```

关于这个错误，我已经提交到了原来代码的github的issue中去了。（但不要指望我commit一份代码，这不存在的）