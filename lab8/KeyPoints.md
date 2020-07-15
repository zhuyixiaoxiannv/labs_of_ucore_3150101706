看着这内容，感觉又要很多事情了。听说lab8也不简单。心塞塞。

多了个磁盘，我也不知道，这个盘和swap盘的区别是怎么区别的。得去看那个具体的实现。另外的话呢，刚才copy代码的时候，那个proc的部分，emmm原本的话呢，编译的时候，用户的这些代码是放在内核代码编译在一起的，加载的时候，直接加载到内存中，然后现在放在文件系统中去了，显然，这需要更改proc处理的代码了。

还有就是，fs这个文件夹下面多出来的东西（感觉超多的说）和原来那个fs文件夹下面的内容对比一下下，就能明白了。

新的fs.h里面，定义了三个设备号

```
#define SWAP_DEV_NO         1
#define DISK0_DEV_NO        2
#define DISK1_DEV_NO        3
```

对于之前的swapfs_init，是放在swap_init里面的，而不是放在fs_init里面的。

（我擦为什么会有这么多啊，我看代码都得看的心碎吗？）老娘不看了，明天再说。

#### 执行流程

fs.c里面的init只有三个步骤，分别是

```
	vfs_init();
    dev_init();
    sfs_init();
```

#### vfs_init

要解释这个事情，首先得解释一件事，在这种类UNIX系统中，万物皆文件，所以说，一个磁盘disk（这里面是文件系统disk0），也必须表示为一个文件，所以要创建这个文件系统，首先就得将目前的三个磁盘表示为文件。vfs_init只是做了一个链表一样的东西，分别放在vfs.c和vfsdev.c两个文件里面。并且申请了两个互斥锁，也就是bootfs_sem和vdev_list_sem，并且初始化了一个链表vdev_list。

因为其实这里面虽然只有三个磁盘文件，但是其实还有stdin stdio等等其他部分。

而这个list每个节点表示一个设备文件，用一个vfs_dev_t的结构表示

```
typedef struct {
    const char *devname;
    struct inode *devnode;
    struct fs *fs;
    bool mountable;
    list_entry_t vdev_link;
} vfs_dev_t;
```

这里面最后那个list_entry_t是用来表示链表的，而name就是个字符串，struct inode在下面介绍，就是用来表示设备文件的，fs则是设备文件对应的文件系统——这个struct用于连接设备和文件系统。mountable字面意思不解释。

#### dev_init

随后是dev_init的部分，这里面又分为了三个，然后还调用一个宏

```
#define init_device(x)                                  \
    do {                                                \
        extern void dev_init_##x(void);                 \
        dev_init_##x();                                 \
    } while (0)
```

```
	init_device(stdin);
    init_device(stdout);
    init_device(disk0);
```

先看disk0的初始化，这边给他分配了一个inode结构，这个inode结构吧，一个union，包含一个struct device和一个struct sfs_inode（算了我懒得去计算两者的占用大小是否一样了。）反正显然是把这个设备初始化一个inode的作用的，这个struct device里面包含了一些基本操作，所以init disk0的作用就是将这些操作函数和实际的操作函数进行绑定。

而stdout和stdin的参数都差不多，反正就是将这些设备的文件给出的一些操作接口给设置好。具体可以参考实验指导材料里面对于stdout和stdin的内容。

另外，stdin由于需要等待外设也就是键盘的问题，所以，需要进行一定的同步，加上需要考虑中断当中的问题，也就是中断当中发生键盘中断的时候，将等待键盘输入的进程唤醒，会有一些内容，但总体跟这部分关系不大。

在这三个init的最后，都将该设备用vfs_add_dev函数加入了vfs层的设备块链表里面，大概这就是这个init做的事情。

~~但是虽然是inode文件的形式，实际上，却因为那个union的原因，和sfs_inode 差别不小。~~

#### sfs_init

到了这一步才是文件系统里面具体某个设备（这里面应该是disk0没错了）里面具体的文件系统sfs

这里面做了一件事情，将文件系统fs挂载到设备号上面——正如前面分析的vfs_dev_t结构，里面除了设备相关的结构，还有一个fs的结构。

这个fs的结构定义在vfs.h文件里面

```
struct fs {
    union {
        struct sfs_fs __sfs_info;                   
    } fs_info;                                     // filesystem-specific data 
    enum {
        fs_type_sfs_info,
    } fs_type;                                     // filesystem type 
    int (*fs_sync)(struct fs *fs);                 // Flush all dirty buffers to disk 
    struct inode *(*fs_get_root)(struct fs *fs);   // Return root inode of filesystem.
    int (*fs_unmount)(struct fs *fs);              // Attempt unmount of filesystem.
    void (*fs_cleanup)(struct fs *fs);             // Cleanup of filesystem.???
};
```

而这里面的union（就一个并不明白为什么这样，我觉得原因是，考虑到多个文件系统类型的需求），啊呸别扯远了，来说说看这里面的sfs_fs结构，这个结构才是我们使用的simple fs的具体表示结构。

```
struct sfs_fs {
    struct sfs_super super;                         /* on-disk superblock */
    struct device *dev;                             /* device mounted on */
    struct bitmap *freemap;                         /* blocks in use are mared 0 */
    bool super_dirty;                               /* true if super/freemap modified */
    void *sfs_buffer;                               /* buffer for non-block aligned io */
    semaphore_t fs_sem;                             /* semaphore for fs */
    semaphore_t io_sem;                             /* semaphore for io */
    semaphore_t mutex_sem;                          /* semaphore for link/unlink and rename */
    list_entry_t inode_list;                        /* inode linked-list */
    list_entry_t *hash_list;                        /* inode hash linked-list */
};
```

这部分就好理解多了，因为实验指导材料里面有了，说的就是，包括了超级块，bitmap等等部分。

这是表示整个文件系统的数据结构了。在挂载的时候，参数为sfs_do_mount函数。

这个函数的作用是。（好多啊感觉为啥这么能写）

```
在sfs_fs.c文件中的sfs_do_mount函数中，完成了加载位于硬盘上的SFS文件系统的超级块superblock和freemap的工作。这样，在内存中就有了SFS文件系统的全局信息。
```

但是，我得说，看了代码之后，好像，只加载了超级块和freemap。关于根目录的信息，貌似没有在mount的时候进行加载。

#### 打开文件

我感觉上面说到加载了超级块以及根节点还有bitmap的信息之后，基本上就算加载完了，剩下对于init来说其实没什么需要考虑的事情。

就，我的意思是说，其他一大堆的代码，就是需要访问特定文件目录的时候，通过上面加载的信息，以及用户或者内核给出的路径来打开某个文件的事情，这不是init里面需要做的，而是在systemcall里面才能找到的。

可以看看参考资料的打开文件部分。

所以看syscall里面，开始会跑到一个file_open函数，这里面首先分配一个空的file结构给他

但是问题来了，什么时候读取的根节点的目录呢？

说法是说在proc的init_main里面进行了vfs_set_bootfs，但是emmm我表示很迷惑。我实在看不懂这个fs是怎么加载进去的。（主要这里面函数和乱七八糟的结构体太多了）

好了我发现问题所在了，这里面主要是vop_lookup，我标注一下下啊，inode.h里面定义了这个宏，然后做的事情是，调用了struct inode里面const struct inode_ops *in_ops里面的操作，而这个操作，被定义在sfs_inode.c 文件里面的末尾，还定义了两种，一个是对于路径的，一个是对于文件的。

具体可以看实验指导里面inode接口的部分。

对于sfs_inode.c 文件中这么emmm多的 内容，基本就是讲这几个函数是怎么完成的。

所以我觉得看了半天（其实并没有懂，但总之，会在初始的函数中，调用这个玩意儿，然后去找到根节点——并不懂弄得这么复杂做什么，但是我觉得这个应该也是分层设计的一部分吧，虽然我没看懂这几个层怎么构建的）

反正总之而言吧，看了小半个晚上，就是说，这个打开文件的作用就是构建一个struct file并且找到相应的磁盘inode转化为内存inode，然后返回这个结构体的指针作为文件指针。

然后对于inode的操作基本上可以用inode.h里面169行开始定义的一大堆对应函数所表示。

另外，对于根目录的inode，是在proc里面init_main的时候就创建了的。

#### 读文件

因为这部分和我要写的代码有关，所以需要认真理解。

这里面开始计算了开始的偏移值和长度是否越界等等问题的检查，随后应当按照实验指导材料的说法，开头不足一整个的块和结尾的不足一整个的块单独处理，然后中间的调用sfs_bmap_load_nolock得到磁盘上的扇区号，并调用sfs_rbuf和sfs_rblock，一个是读一部分，一个是读一整块。

以及

```
sfs_rbuf和sfs_rblock函数最终都调用sfs_rwblock_nolock函数完成操作，而sfs_rwblock_nolock函数调用dop_io->disk0_io->disk0_read_blks_nolock->ide_read_secs完成对磁盘的操作。
```

而这两个函数则被分别指定为sfs_buf_op和sfs_block_op

这里面的sfs_bmap_load_nolock的作用是，就是文件在磁盘上面未必是连续的，而是按照扇区一个一个用disk_inode结构里面的指针所记录的。所以需要用这个来找到对应的。

另外我觉得需要考虑的一个情况是，如果写入，那么需要新增分配的磁盘块给他，所以这个函数应该还有这样的作用。

#### 文件系统的结构

这里面主要参考了参考材料的索引节点部分，因为磁盘inode和内存inode还真的不一样。

磁盘inode使用了一级间接索引

```
对于普通文件，索引值指向的 block 中保存的是文件中的数据。而对于目录，索引值指向的数据保存的是目录下所有的文件名以及对应的索引节点所在的索引块（磁盘块）所形成的数组。
```

对于内存inode，相关的操作都很多了，前面反正已经看得头晕了。要注意的是inode这个struct

前面应该有引用，我这边写一下

```
struct inode {
    union {
        struct device __device_info;
        struct sfs_inode __sfs_inode_info;
    } in_info;
    enum {
        inode_type_device_info = 0x1234,
        inode_type_sfs_inode_info,
    } in_type;
    int ref_count;
    int open_count;
    struct fs *in_fs;
    const struct inode_ops *in_ops;
};
```

看了这么多感觉，这个才是在文件系统中用于表示一个抽象的文件的数据结构，in_info可以是一个设备，也可以是一个文件inode（sfs_inode) 并且还有一堆附带的操作in_ops，

而前文对于fs的init是将设备的一些属性归类为一个inode的属性，将它弄成一个文件，挂载的过程只是将超级块和bitmap读进来然后构成一个fs和文件inode进行对应。

所以这里面很清楚明白的表示了所谓的，一切皆文件的思想（用这一大堆的虚拟函数，和union来按照实际需求进行选择，而封装到一个inode文件结构里面去）

