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

但是虽然是inode文件的形式，实际上，却因为那个union的原因，和sfs_inode 差别不小。

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





