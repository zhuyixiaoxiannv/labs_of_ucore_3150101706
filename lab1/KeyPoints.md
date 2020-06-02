## 本文档用于记录在lab1实验中遇到的一些关键的知识点，便于后面复习（虽然也会在report中体现）

### Makefile相关

（在本目录下也放着一份GNUmake中文手册，其实里面很多东西都有，只是没有必要全都弄一遍）

#### 变量定义

简单赋值 ( := ) 编程语言中常规理解的赋值方式，只对当前语句的变量有效。
递归赋值 ( = ) 赋值语句可能影响多个变量，所有目标变量相关的其他变量都受影响。
**条件赋值 ( ?= ) 如果变量未定义，则使用符号中的值定义变量。如果该变量已经赋值，则该赋值语句无效。**
追加赋值 ( += ) 原变量用空格隔开的方式追加一个新值。

#### 引用

$(变量)

如果引用shell操作，则使用$(shell + shell命令)
例如
INCDIR	:=$ (shell pwd)
获取当前路径

如果引用别的函数
使用$(call function)
这个funtion也可以在别的mk文件中
mk文件就是专门用于Makefile的

$(error TEXT…)
报错并且退出执行
$(warning TEXT...)
生成一句warning，但是不会退出执行
$(info TEXT...)
显示一句话

$(eval )

#### 预定义的一些符号和标志
.SUFFIXES	表示合法的文件后缀
.DELETE_ON_ERROR	如果编译中断的话，则删除目标文件

ifndef
......
else
......
endif
判断是否定义某个标识符

#### 工具
objcopy是将二进制文件链接到可执行文件中的
objdump则是查看内容的（表示并不很明白）

#### 其他

projectile文件是Emacs的管理工具吧

反正我用vim

### qemu模拟和gdb相关

（部分复制了report我写的内容，但并不完全）

我只描述在我的系统环境配置下需要做的事情
首先，编译的时候需要指定Makefile里面加上-g允许调试信息，这是前置条件
其次，编译完了之后，使用

```
qemu-system-i386 -s -S -hda bin/ucore.img -monitor vc --nographic
```

打开qemu
最后，建一个新窗口用

```
gdb -tui -x tools/gdbinit
```

打开带text ui的gdb并使用设定好的gdbinit文件
如果不需要的话呢，可以自己设定gdb的断点，tui也可以不用

然后用

```
target remote localhost:1234
```

来连接到qemu的模拟器

然后关于用gdb调试

```
break *0x地址
```

打断点

```
x /10i 0x地址
```

表示执行地址随后的10条instructions

用

```
si
```

指令单步执行。

其他的，比如quit退出等等可以自行参照



### 硬件复位后执行的第一条指令

```
9.1.4执行的第一条指令

硬件复位后获取并执行的第一条指令位于物理地址FFFFFFF0H。此地址比处理器的最高物理地址低16个字节。包含软件初始化代码的EPROM必须位于此地址。

在实地址模式下，地址FFFFFFF0H超出了处理器的1 MB可寻址范围。如下将处理器初始化为该起始地址。 CS寄存器有两个部分：可见段选择器部分和隐藏基地址部分。在实地址模式下，通常通过将16位段选择器值向左移动4位以生成20位基地址来形成基地址。但是，在硬件复位期间，CS寄存器中的段选择器将加载F000H，基地址将加载FFFF0000H。因此，通过将基地址加到EIP寄存器中的值（即FFFF0000 + FFF0H = FFFFFFF0H）来形成起始地址。

硬件重置后，第一次在CS寄存器中加载新值时，处理器将遵循正常规则以实地址模式进行地址转换（即[CS基地址= CS段选择器* 16]）。为确保在完成基于EPROM的软件初始化代码之前，CS寄存器中的基址保持不变，该代码不得包含远跳转或远调用或允许发生中断（这将导致CS选择器值被更改） 。
```
### A20地址线相关

原来我以前和ucore所看的A20地址线的文档是同一篇百度文档。。。事实上，xv6应该也是这么做的。好了不说废话了。

```
8042有4个寄存器

1个8-bit长的Input buffer；Write-Only；

1个8-bit长的Output buffer； Read-Only；

1个8-bit长的Status Register；Read-Only；

1个8-bit长的Control Register；Read/Write。

    有两个端口地址：60h和64h。

读60h端口，读output buffer
写60h端口，写input buffer
读64h端口，读Status Register
    对Control Register的操作相对要复杂一些，首先要向64h端口写一个命令（20h为读命令，60h为写命令），然后根据命令从60h端口读出Control Register的数据或者向60h端口写入Control Register的数据（64h端口还可以接受许多其它的命令）。

    先来看看Status Register的定义，我们后面要用bit 0和bit 1：

    bit    meaning
    -----------------------------------------------------------------------
     0     output register (60h) 中有数据
     1     input register (60h/64h) 有数据
     2     系统标志（上电复位后被置为0）
     3     data in input register is command (1) or data (0)
     4     1=keyboard enabled, 0=keyboard disabled (via switch)
     5     1=transmit timeout (data transmit not complete)
     6     1=receive timeout (data transmit not complete)
     7     1=even parity rec'd, 0=odd parity rec'd (should be odd)

    除了这些资源外，8042还有3个内部端口：Input Port、Outport Port和Test Port，这三个端口的操作都是通过向64h发送命令，然后在60h进行读写的方式完成，其中本文要操作的A20 Gate被定义在Output Port的bit 1上，所以我们有必要对Outport Port的操作及端口定义做一个说明。

读Output Port
向64h发送0d0h命令，然后从60h读取Output Port的内容
写Output Port
向64h发送0d1h命令，然后向60h写入Output Port的数据
    另外我们还应该介绍两个命令：

禁止键盘操作命令
向64h发送0adh
打开键盘操作命令
向64h发送0aeh
    有了这些命令和知识，我们可以考虑操作A20 Gate了，有关8042芯片更详细的资料，请参考该芯片的Data Sheet。

     如何打开和关闭A20 Gate。

    理论上讲，我们只要操作8042芯片的输出端口（64h）的bit 1，就可以控制A20 Gate，但实际上，当你准备向8042的输入缓冲区里写数据时，可能里面还有其它数据没有处理，所以，我们要首先禁止键盘操作，同时等待数据缓冲区中没有数据以后，才能真正地去操作8042打开或者关闭A20 Gate。打开A20 Gate的具体步骤大致如下：

    1.关闭中断；
    2.等待8042 Input buffer为空；
    3.发送禁止键盘操作命令；
    4.等待8042 Input buffer为空；
    5.发送读取8042 Output Port命令；
    6.等待8042 Output buffer有数据；
    7.读取8042 Output buffer，并保存得到的字节；
    8.等待8042 Input buffer为空；
    9.发送Write 8042 Output Port命令到8042 Input buffer；
    10.等待8042 Input buffer为空；
    11.将从8042 Output Port得到的字节的第2位置1（或清0），然后写入8042 Input buffer；
    12.等待，直到8042 Input buffer为空为止；
    13.发送允许键盘操作命令到8042 Input buffer；
    14. 打开中断。
```

(总感觉又回到了被硬件电路支配的日子)上面的步骤，主要是

1、等待input buffer为空然后禁止键盘操作，此时可以安全的操作了

2、发送读取output buffer的信号并读取保存得到的东西，然后将保存的东西，第二位置位，再送回去

3、允许键盘操作

我觉得这样做是较为安全的，但是，对于ucroe的方法也未必是错的。它的做法省略了几个步骤，首先，并没有关闭键盘操作这件事——就目前的CPU速度而言，这没什么大的问题。其次，他没有读取再置位后写回，而是直接赋值了，这可能会引起一些错误——但我觉得其实差别不会很大。

其中，0x64端口是控制指令，0x60端口是数据

```
0xd1->Port 0x64 向P2输出端口写命令
```

另外

```
后来，由于感觉使用8042控制A20运行太慢了（确实，那么长的代码，中间还要若干次的wait），所以后来又出现了所谓的Fast A20，实际上，现在的大多数机器都是Fast A20，Fast A20使用92h端口控制A20，同时BIOS里提供了一个软中断来控制A20：

    入口：ah=24h
          al=0    关闭A20
             1    打开A20
             2    读取A20状态
          int 15h

    返回：如果BIOS支持此功能，CF=0，否则CF=1
          CF=0时，AX返回当前A20状态，1=打开，0=关闭

    像8042中的Output Port中的定义一样，92h端口的bit 1控制着A20，为1时打开，为0时关闭，从92h中读一个byte可以看a20的当前状态，所以对92h的操作如下：

读A20状态
mov dx, 92h
in al, dx
如果al的bit 1为1表示a20打开，否则为0
打开A20
mov dx, 92h
mov al, 02
out dx, al
关闭A20
mov dx, 92h
mov al, 0
out dx, al
    特别要注意的是，大家从这篇文章的文字中可能也能感觉到，A20 Gate的设计本身就让人感觉很别扭，不是那么流畅，所以和A20有关的事情就难免也会有相同的感觉，很奇怪的是，上面介绍的三种方法并不是在每台机器上都适用，所以如果你要做一个商业软件其中要操作A20，那一定要三种方式联合使用才比较稳妥，否则会有意想不到的结果，LINUX公开的启动代码中就是这么做的
```

如果是这样的话，会简单很多，但即便如此，我想，请务必多种方法联合使用。。。

TODO：将Fast A20方案写进代码，使得其更完善

（PS：个人认为对于一个正式用的操作系统而言，显然512字节是不够用的，所以应该设计为2级加载模式，第一级的512字节只是把需要的第二级加载程序的内容加载到内存中，而第二级加载程序再进行所谓的进入保护模式，设置GDT，设置分段分页等等工作。另外考虑到所谓的文件系统，如果有需要的话，显然，我觉得，磁盘的开头第一个扇区应该设计为BootLoader没毛病，第二个及之后的几个扇区则设置为第二级加载程序。之后从文件系统加载。）

### GDT相关

每个程序都用一个段描述符来表示一个段使用的内存空间

当然关于段描述符的具体内容并不在此处展开，太长了这些字段

这些段描述符组合起来称为段描述符表，并且GDT表的第一个描述符是不使用的。lgdt和sgdt用于访问GDTR寄存器，lldt和sldt访问LDTR寄存器，但访问LDTR的lldt指令使用的操作数表示GDT表中一个描述符项的选择符，即LDT是一个在GDT表中存在的段

### 保护模式开启

我发现，虽然在代码中写了下面几句：

```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```

但是在实验说明中并没有包括这部分的知识，因此我来记录一下（虽然之前已经了解过了）

正确的理由其实得看Intel的80386手册，我这边就写一下

80386总共有4个控制寄存器，CR0-3

其中CR0存在几个重要的位

PE——保护模式开启位，bit0

TS——任务切换位，bit3

PG——分页操作位，bit31，指示是否使用页表将线性地址转换为物理地址

