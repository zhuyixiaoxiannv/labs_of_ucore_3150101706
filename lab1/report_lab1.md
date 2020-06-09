# 练习1：理解通过make生成执行文件的过程。

在此练习中，大家需要通过静态分析代码来了解：

1. 操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
2. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

My Answer：
1. Following is the makefile with some comments, and my comments are written in Chinese:

```
PROJ	:= challenge
EMPTY	:=
SPACE	:= $(EMPTY) $(EMPTY)
SLASH	:= /

V       := @
#need llvm/cang-3.5+
#USELLVM := 1
# try to infer the correct GCCPREFX
ifndef GCCPREFIX
GCCPREFIX := $(shell if i386-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	then echo 'i386-elf-'; \
	elif objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; \
	then echo ''; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find an i386-elf version of GCC/binutils." 1>&2; \
	echo "*** Is the directory with i386-elf-gcc in your PATH?" 1>&2; \
	echo "*** If your i386-elf toolchain is installed with a command" 1>&2; \
	echo "*** prefix other than 'i386-elf-', set your GCCPREFIX" 1>&2; \
	echo "*** environment variable to that prefix and run 'make' again." 1>&2; \
	echo "*** To turn off this error, run 'gmake GCCPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif
#---------------------------------------------------------------------------------------------------#
#检查系统环境，主要是指令平台是否为386系列，否则报错并退出，
#这是通过调用shell指令来执行的
#此处运行到的是objdump这一行命令（木有任何输出）
#关于这个命令，作用是输出相关平台的一些信息，包括系统架构等等
#---------------------------------------------------------------------------------------------------#

# try to infer the correct QEMU
ifndef QEMU
QEMU := $(shell if which qemu-system-i386 > /dev/null; \
	then echo 'qemu-system-i386'; exit; \
	elif which i386-elf-qemu > /dev/null; \
	then echo 'i386-elf-qemu'; exit; \
	elif which qemu > /dev/null; \
	then echo 'qemu'; exit; \
	else \
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif
#---------------------------------------------------------------------------------------------------#
#检查是否有QEMU模拟器，其他分析同上
#另外需要注意的是，这里面的echo并不是在屏幕上打印出来，而是将值赋值给了QEMU这个Makefile变量
#---------------------------------------------------------------------------------------------------#

# eliminate default suffix rules
.SUFFIXES: .c .S .h
#---------------------------------------------------------------------------------------------------#
#设定合法的后缀为点c，S和h，分别是c代码，汇编，以及c头文件
#---------------------------------------------------------------------------------------------------#

# delete target files if there is an error (or make is interrupted)
.DELETE_ON_ERROR:
#---------------------------------------------------------------------------------------------------#
#如果中断编译，则删除目标文件
#---------------------------------------------------------------------------------------------------#

# define compiler and flags
ifndef  USELLVM
HOSTCC		:= gcc
HOSTCFLAGS	:= -g -Wall -O2
CC		:= $(GCCPREFIX)gcc
CFLAGS	:= -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc $(DEFS)
CFLAGS	+= $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
#---------------------------------------------------------------------------------------------------#
#上面是一些设定
#事实上并没有定义usellvm，并且我表示不懂这个变量的含义
#使用gcc编译器
#gcc的编译参数，-g表示加入debug信息，而-Wall则是输出所有warning，-O2则表示优化等级为2
#事实上，这里面，CC这里gcc依然没有用到别的多的信息参数，因为$(GCCPREFIX)在此处是空字符串
#CFLAGS里面，则是一些参数
#下面的代码没有跑到，不用看了，基本差不多
#---------------------------------------------------------------------------------------------------#
else
HOSTCC		:= clang
HOSTCFLAGS	:= -g -Wall -O2
CC		:= clang
CFLAGS	:= -march=i686 -fno-builtin -fno-PIC -Wall -g -m32 -nostdinc $(DEFS)
CFLAGS	+= $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
endif

CTYPE	:= c S
#---------------------------------------------------------------------------------------------------#
#接下来是对于链接器ld的定义及参数
#---------------------------------------------------------------------------------------------------#
LD      := $(GCCPREFIX)ld
LDFLAGS	:= -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)
LDFLAGS	+= -nostdlib
#---------------------------------------------------------------------------------------------------#
#objcopy是将二进制文件链接到可执行文件中的
#objdump则是查看内容的（表示并不很明白）
#---------------------------------------------------------------------------------------------------#

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump
#---------------------------------------------------------------------------------------------------#
#一些文件操作的变量定义（虽然看上去没啥用）
#---------------------------------------------------------------------------------------------------#
COPY	:= cp
MKDIR   := mkdir -p
MV		:= mv
RM		:= rm -f
AWK		:= awk
SED		:= sed
SH		:= sh
TR		:= tr
TOUCH	:= touch -c

OBJDIR	:= obj
BINDIR	:= bin

ALLOBJS	:=
ALLDEPS	:=
TARGETS	:=
#---------------------------------------------------------------------------------------------------#
#include下面这个文件，其中后面的listf等函数都在这个文件当中
#此处知识点，mk文件是Makefile引入外部依赖项需要的文件
#以及下面的call是makefile中使用别的函数的一种方式
#（well, I will do some analysis to this function.mk file and the funcitons in it
#but now, lets focus on the makefile code itself
#这里面对几个需要使用到的函数进行了封装
#add_files_cc添加了文件
#以及后面的几个file都是生成目标文件
#prefix是前缀的意思
#patsubst是替换通配符的意思，并不懂这乱七八糟的语法（让本宝宝糟心）
#---------------------------------------------------------------------------------------------------#
include tools/function.mk

listf_cc = $(call listf,$(1),$(CTYPE))

# for cc
add_files_cc = $(call add_files,$(1),$(CC),$(CFLAGS) $(3),$(2),$(4))
create_target_cc = $(call create_target,$(1),$(2),$(3),$(CC),$(CFLAGS))

# for hostcc
add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))
create_target_host = $(call create_target,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS))

cgtype = $(patsubst %.$(2),%.$(3),$(1))
objfile = $(call toobj,$(1))
asmfile = $(call cgtype,$(call toobj,$(1)),o,asm)
outfile = $(call cgtype,$(call toobj,$(1)),o,out)
symfile = $(call cgtype,$(call toobj,$(1)),o,sym)

# for match pattern
match = $(shell echo $(2) | $(AWK) '{for(i=1;i<=NF;i++){if(match("$(1)","^"$$(i)"$$")){exit 1;}}}'; echo $$?)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#---------------------------------------------------------------------------------------------------#
#总感觉接下来才是真的正儿八经的编译过程
#开头include一些文件
#---------------------------------------------------------------------------------------------------#
# include kernel/user

INCLUDE	+= libs/

CFLAGS	+= $(addprefix -I,$(INCLUDE))

LIBDIR	+= libs

$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)

# -------------------------------------------------------------------
# kernel

KINCLUDE	+= kern/debug/ \
			   kern/driver/ \
			   kern/trap/ \
			   kern/mm/

KSRCDIR		+= kern/init \
			   kern/libs \
			   kern/debug \
			   kern/driver \
			   kern/trap \
			   kern/mm
#---------------------------------------------------------------------------------------------------#
#指定kernel和kernel source dir
#---------------------------------------------------------------------------------------------------#
KCFLAGS		+= $(addprefix -I,$(KINCLUDE))

$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))

KOBJS	= $(call read_packet,kernel libs)

# create kernel target
kernel = $(call totarget,kernel)

$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

$(call create_target,kernel)

# -------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
#创建写入boot扇区的内容
#---------------------------------------------------------------------------------------------------#
# create bootblock
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))

bootblock = $(call totarget,bootblock)

$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)

$(call create_target,bootblock)

# -------------------------------------------------------------------

# create 'sign' tools
$(call add_files_host,tools/sign.c,sign,sign)
$(call create_target_host,sign,sign)

# -------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
#写入img文件
#---------------------------------------------------------------------------------------------------#
# create ucore.img
UCOREIMG	:= $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

$(call finish_all)

IGNORE_ALLDEPS	= clean \
				  dist-clean \
				  grade \
				  touch \
				  print-.+ \
				  handin

ifeq ($(call match,$(MAKECMDGOALS),$(IGNORE_ALLDEPS)),0)
-include $(ALLDEPS)
endif

# files for grade script
#---------------------------------------------------------------------------------------------------#
#感觉下面是一些函数
#---------------------------------------------------------------------------------------------------#
TARGETS: $(TARGETS)

.DEFAULT_GOAL := TARGETS

.PHONY: qemu qemu-nox debug debug-nox
qemu-mon: $(UCOREIMG)
	$(V)$(QEMU)  -no-reboot -monitor stdio -hda $< -serial null
qemu: $(UCOREIMG)
	$(V)$(QEMU) -no-reboot -parallel stdio -hda $< -serial null
log: $(UCOREIMG)
	$(V)$(QEMU) -no-reboot -d int,cpu_reset  -D q.log -parallel stdio -hda $< -serial null
qemu-nox: $(UCOREIMG)
	$(V)$(QEMU)   -no-reboot -serial mon:stdio -hda $< -nographic
TERMINAL        :=gnome-terminal
debug: $(UCOREIMG)
	$(V)$(QEMU) -S -s -parallel stdio -hda $< -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
	
debug-nox: $(UCOREIMG)
	$(V)$(QEMU) -S -s -serial mon:stdio -hda $< -nographic &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -q -x tools/gdbinit"

.PHONY: grade touch

GRADE_GDB_IN	:= .gdb.in
GRADE_QEMU_OUT	:= .qemu.out
HANDIN			:= proj$(PROJ)-handin.tar.gz

TOUCH_FILES		:= kern/trap/trap.c

MAKEOPTS		:= --quiet --no-print-directory

grade:
	$(V)$(MAKE) $(MAKEOPTS) clean
	$(V)$(SH) tools/grade.sh

touch:
	$(V)$(foreach f,$(TOUCH_FILES),$(TOUCH) $(f))

print-%:
	@echo $($(shell echo $(patsubst print-%,%,$@) | $(TR) [a-z] [A-Z]))

.PHONY: clean dist-clean handin packall tags
clean:
	$(V)$(RM) $(GRADE_GDB_IN) $(GRADE_QEMU_OUT) cscope* tags
	-$(RM) -r $(OBJDIR) $(BINDIR)

dist-clean: clean
	-$(RM) $(HANDIN)

handin: packall
	@echo Please visit http://learn.tsinghua.edu.cn and upload $(HANDIN). Thanks!

packall: clean
	@$(RM) -f $(HANDIN)
	@tar -czf $(HANDIN) `find . -type f -o -type d | grep -v '^\.*$$' | grep -vF '$(HANDIN)'`

tags:
	@echo TAGS ALL
	$(V)rm -f cscope.files cscope.in.out cscope.out cscope.po.out tags
	$(V)find . -type f -name "*.[chS]" >cscope.files
	$(V)cscope -bq 
	$(V)ctags -L cscope.files

```

Some interpret：

-I（大写的i） 可指定查找include文件的其他位置.例如,如果有些include文件位于比较特殊的地方。
-Wall 显示所有警告
-o 目标输出文件
-march 设置CPU类型
g 生成gdb的调试信息
-fno-stack-protector 不生成栈溢出保护
-m32 编译生成32位程序

$* 　　不包含扩展名的目标文件名称。
$+ 　　所有的依赖文件，以空格分开，并以出现的先后为序，可能包含重复的依赖文件。
$< 　　第一个依赖文件的名称。
$? 　　所有的依赖文件，以空格分开，这些依赖文件的修改日期比目标的创建日期晚。
$@ 　 目标的完整名称。
$^ 　　所有的依赖文件，以空格分开，不包含重复的依赖文件。
$% 	   如果目标是归档成员，则该变量表示目标的归档成员名称。

After I typed in make, the screen showed:

```
+ cc kern/init/init.c
kern/init/init.c:95:1: warning: ‘lab1_switch_test’ defined but not used [-Wunused-function]
   95 | lab1_switch_test(void) {
      | ^~~~~~~~~~~~~~~~
+ cc kern/libs/stdio.c
+ cc kern/libs/readline.c
+ cc kern/debug/panic.c
kern/debug/panic.c: In function ‘__panic’:
kern/debug/panic.c:27:5: warning: implicit declaration of function ‘print_stackframe’; did you mean ‘print_trapframe’?
-Wimplicit-function-declaration]
   27 |     print_stackframe();
      |     ^~~~~~~~~~~~~~~~
      |     print_trapframe
+ cc kern/debug/kdebug.c
kern/debug/kdebug.c:251:1: warning: ‘read_eip’ defined but not used [-Wunused-function]
  251 | read_eip(void) {
      | ^~~~~~~~
+ cc kern/debug/kmonitor.c
+ cc kern/driver/clock.c
+ cc kern/driver/console.c
+ cc kern/driver/picirq.c
+ cc kern/driver/intr.c
+ cc kern/trap/trap.c
kern/trap/trap.c: In function ‘print_trapframe’:
kern/trap/trap.c:100:16: warning: taking address of packed member of ‘struct trapframe’ may result in an unaligned pointer value [-Waddress-of-packed-member]
  100 |     print_regs(&tf->tf_regs);
      |                ^~~~~~~~~~~~
At top level:
kern/trap/trap.c:30:26: warning: ‘idt_pd’ defined but not used [-Wunused-variable]
   30 | static struct pseudodesc idt_pd = {
      |                          ^~~~~~
kern/trap/trap.c:14:13: warning: ‘print_ticks’ defined but not used [-Wunused-function]
   14 | static void print_ticks() {
      |             ^~~~~~~~~~~
+ cc kern/trap/vectors.S
+ cc kern/trap/trapentry.S
+ cc kern/mm/pmm.c
+ cc libs/string.c
+ cc libs/printfmt.c
+ ld bin/kernel
+ cc boot/bootasm.S
+ cc boot/bootmain.c
+ cc tools/sign.c
+ ld bin/bootblock
'obj/bootblock.out' size: 496 bytes
build 512 bytes boot sector: 'bin/bootblock' success!
10000+0 records in
10000+0 records out
5120000 bytes (5.1 MB, 4.9 MiB) copied, 0.145082 s, 35.3 MB/s
1+0 records in
1+0 records out
512 bytes copied, 0.0029916 s, 171 kB/s
154+1 records in
154+1 records out
78908 bytes (79 kB, 77 KiB) copied, 0.0038386 s, 20.6 MB/s
```

Well, just some information , mostly about the files compiled, some are about the warnings —— but I don't think it's useful, just neglect it.

As for the files, first is using GCC to compile the C code. Second write it into the image.

Actually, if I use the "make "V=" " command, the output is in the "makeout.txt" file. Your can see it. Here, you will see there's no space between -I and the include file or dictionary.

2. 参考文件tools/sign.c里面的定义
    第31和32行

  buf[510] = 0x55;

  buf[511] = 0xAA;

  所以是0x55AA

# 练习2

1. 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。
2. 在初始化位置0x7c00设置实地址断点,测试断点正常。
3. 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。
4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。

My answer:

#-----------------------------------------------------------------------------------------------

* 调试的一些记录

关于这个qemu的模拟，主要包括两个部分
一个是qemu中运行img，第二个是通过gdb使用qemu暴露的端口进行单步运行调试
首先是qemu中运行img

* (1). 我的运行环境

Windows 10  1909版本下使用Windows subsystem Linux（WSL），镜像使用的是Ubuntu 20.04 LTS

* (2). 使用qemu

我这边能够运行的起来的命令是
qemu-system-i386 -s -S -hda ucore.img -monitor vc --nographic
虽然会报个warning，说什么没有指定raw格式
但是不是事儿

首先，因为是命令行的模式，所以肯定没有GUI
因而打开qemu首先必须加入参数-nographic
另外只能使用虚拟终端vc，stdio不行

其实在Makefile中也是有定义make qemu的啦，但是，可以对比一下下上面我的命令和Makefile里面命令的不同，然后在我这边，make qemu真的跑不起来，原因见前文，会报错。。。所以不管了

* (3). gdb的使用

直接安装gdb工具（反正都是GNU的）
然后输入gdb进入调试
再输入target remote localhost:1234
连接127.0.0.1:1234
随后开始调试
（目前表示还不能连上）
OK终于搞定

* (4). 关于gdb的gdbinit文件的使用

gdb -tui -x tools/gdbinit

需要注意tui参数在x参数前面（其实在文件路径后面也应该可以，但是我写成gdb -x -tui tools/gdbinit就报错

* (5). 关于顺序

先开qemu，再开启gdb -tui -x tools/gdbinit

* (6). 总结

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
如果不需要的话呢，可以自己设定gdb的断点

如果不需要gdb，直接去掉大S的选项
```
qemu-system-i386 -s -hda bin/ucore.img -monitor vc --nographic
```

#-----------------------------------------------------------------------------------------------


1. 参考附录（原谅我之前没有看到，到处搜索资料。。。）

首先我来补充一下自己知识的盲区，硬件复位后执行的第一条指令竟然并不是从0x7c00开始的，emmm这么说吧，因为bios的程序也是需要运行的，比如设定最基础的中断向量表等等，因此，在执行我们自己的代码之前，先要执行bios的代码。关于这部分的知识，附录中有一点点提到，我同样放在KeyPoints.txt里面。

换而言之，整体执行过程是先BIOS，再bootloader，再kernel（也有可能在BootLoader和kernel中间存在更多级的跳转）

这道题我单步执行的结果是

```
(gdb) set architecture i8086
warning: A handler for the OS ABI "GNU/Linux" is not built into this configuration
of GDB.  Attempting to continue with the default i8086 settings.

The target architecture is assumed to be i8086
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
warning: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
0x0000fff0 in ?? ()
(gdb) si
0x0000e05b in ?? ()
(gdb) si
0x0000e062 in ?? ()
(gdb) si
0x0000e066 in ?? ()
(gdb) x /2i 0xffff0
   0xffff0:     ljmp   $0x3630,$0xf000e05b
   0xffff7:     das
(gdb) x /10i 0xfe05b
   0xfe05b:     cmpw   $0xffc8,%cs:(%esi)
   0xfe060:     bound  %eax,(%eax)
   0xfe062:     jne    0xd241d0b2
   0xfe068:     mov    %edx,%ss
   0xfe06a:     mov    $0x7000,%sp
   0xfe06e:     add    %al,(%eax)
   0xfe070:     mov    $0x7c4,%dx
   0xfe074:     verw   %cx
   0xfe077:     stos   %eax,%es:(%edi)
   0xfe078:     out    %al,(%dx)
(gdb)
```

但是说几句实话（好吧有可能跟他使用的是AT&T的汇编指令格式有关系）

首先我不是很明白这个0xffff0为啥变成了0xfff0（少了开头一个f，我知道就是会有段偏移导致的基地址加上地址的模式，但是，那也应该是0xf000fff0呀。其次我不清楚的是那个ljmp指令，和附录的指导相对比之后，有一些差别，我这里得到的代码是
```
(gdb) x /2i 0xffff0
   0xffff0:     ljmp   $0x3630,$0xf000e05b
   0xffff7:     das
```

但是在附录中的是

```
0xffff0: ljmp $0xf000,$0xe05b
0xffff5: xor %dh,0x322f
```

换句话说，这个ljmp多了两个字节，导致下一条指令的代码从0xffff5跑到了0xffff7

以及并不明白要弄个das指令来进行十进制减法调整是什么鬼。也许是BIOS的不同实现以及gdb在指令格式上面的写法不一样

2. 在初始化位置0x7c00设置实地址断点,测试断点正常。

gdb的输出

```
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
warning: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
0x0000fff0 in ?? ()
(gdb) break *0x7c00
Breakpoint 1 at 0x7c00
(gdb) info breakpoint
Num     Type           Disp Enb Address    What
1       breakpoint     keep y   0x00007c00
```

3. 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

我把整个扇区搞下来，竟然还写满了，interesting。。。
```
(gdb) x /255i 0x7c00
=> 0x7c00:      cli
   0x7c01:      cld
   0x7c02:      xor    %eax,%eax
   0x7c04:      mov    %eax,%ds
   0x7c06:      mov    %eax,%es
   0x7c08:      mov    %eax,%ss
   0x7c0a:      in     $0x64,%al
   0x7c0c:      test   $0x2,%al
   0x7c0e:      jne    0x7c0a
   0x7c10:      mov    $0xd1,%al
   0x7c12:      out    %al,$0x64
   0x7c14:      in     $0x64,%al
   0x7c16:      test   $0x2,%al
   0x7c18:      jne    0x7c14
   0x7c1a:      mov    $0xdf,%al
   0x7c1c:      out    %al,$0x60
   0x7c1e:      lgdtl  (%esi)
   0x7c21:      insb   (%dx),%es:(%edi)
   0x7c22:      jl     0x7c33
   0x7c24:      and    %al,%al
   0x7c26:      or     $0x1,%ax
   0x7c2a:      mov    %eax,%cr0
   0x7c2d:      ljmp   $0xb866,$0x87c32
   0x7c34:      adc    %al,(%eax)
   0x7c36:      mov    %eax,%ds
   0x7c38:      mov    %eax,%es
   0x7c3a:      mov    %eax,%fs
   0x7c3c:      mov    %eax,%gs
   0x7c3e:      mov    %eax,%ss
   0x7c40:      mov    $0x0,%ebp
   0x7c45:      mov    $0x7c00,%esp
   0x7c4a:      call   0x7d0f
--Type <RET> for more, q to quit, c to continue without paging--
   0x7c4f:      jmp    0x7c4f
   0x7c51:      lea    0x0(%esi),%esi
   0x7c54:      add    %al,(%eax)
   0x7c56:      add    %al,(%eax)
   0x7c58:      add    %al,(%eax)
   0x7c5a:      add    %al,(%eax)
   0x7c5c:      (bad)
   0x7c5d:      incl   (%eax)
   0x7c5f:      add    %al,(%eax)
   0x7c61:      lcall  $0x0,$0xffff00cf
   0x7c68:      add    %dl,0x1700cf(%edx)
   0x7c6e:      push   %esp
   0x7c6f:      jl     0x7c71
   0x7c71:      add    %dl,-0x77(%ebp)
   0x7c74:      in     $0x57,%eax
   0x7c76:      push   %esi
   0x7c77:      mov    %eax,%esi
   0x7c79:      push   %ebx
   0x7c7a:      add    %edx,%eax
   0x7c7c:      sub    $0x8,%esp
   0x7c7f:      mov    $0x1f7,%ebx
   0x7c84:      mov    %eax,-0x14(%ebp)
   0x7c87:      mov    %ecx,%eax
   0x7c89:      shr    $0x9,%ecx
   0x7c8c:      and    $0x1ff,%eax
   0x7c91:      sub    %eax,%esi
   0x7c93:      lea    0x1(%ecx),%eax
   0x7c96:      mov    %eax,-0x10(%ebp)
   0x7c99:      cmp    -0x14(%ebp),%esi
   0x7c9c:      jae    0x7d08
   0x7c9e:      mov    %ebx,%edx
   0x7ca0:      in     (%dx),%al
--Type <RET> for more, q to quit, c to continue without paging--
   0x7ca1:      and    $0xc0,%al
   0x7ca3:      cmp    $0x40,%al
   0x7ca5:      jne    0x7c9e
   0x7ca7:      mov    $0x1f2,%edx
   0x7cac:      mov    $0x1,%al
   0x7cae:      out    %al,(%dx)
   0x7caf:      mov    $0x1f3,%edx
   0x7cb4:      mov    -0x10(%ebp),%al
   0x7cb7:      out    %al,(%dx)
   0x7cb8:      mov    -0x10(%ebp),%eax
   0x7cbb:      mov    $0x1f4,%edx
   0x7cc0:      shr    $0x8,%eax
   0x7cc3:      out    %al,(%dx)
   0x7cc4:      mov    -0x10(%ebp),%eax
   0x7cc7:      mov    $0x1f5,%edx
   0x7ccc:      shr    $0x10,%eax
   0x7ccf:      out    %al,(%dx)
   0x7cd0:      mov    -0x10(%ebp),%eax
   0x7cd3:      mov    $0x1f6,%edx
   0x7cd8:      shr    $0x18,%eax
   0x7cdb:      and    $0xf,%al
   0x7cdd:      or     $0xe0,%al
   0x7cdf:      out    %al,(%dx)
   0x7ce0:      mov    $0x20,%al
   0x7ce2:      mov    %ebx,%edx
   0x7ce4:      out    %al,(%dx)
   0x7ce5:      mov    %ebx,%edx
   0x7ce7:      in     (%dx),%al
   0x7ce8:      and    $0xc0,%al
   0x7cea:      cmp    $0x40,%al
   0x7cec:      jne    0x7ce5
   0x7cee:      mov    %esi,%edi
--Type <RET> for more, q to quit, c to continue without paging--
   0x7cf0:      mov    $0x80,%ecx
   0x7cf5:      mov    $0x1f0,%edx
   0x7cfa:      cld
   0x7cfb:      repnz insl (%dx),%es:(%edi)
   0x7cfd:      incl   -0x10(%ebp)
   0x7d00:      add    $0x200,%esi
   0x7d06:      jmp    0x7c99
   0x7d08:      pop    %eax
   0x7d09:      pop    %edx
   0x7d0a:      pop    %ebx
   0x7d0b:      pop    %esi
   0x7d0c:      pop    %edi
   0x7d0d:      pop    %ebp
   0x7d0e:      ret
   0x7d0f:      endbr32
   0x7d13:      push   %ebp
   0x7d14:      xor    %ecx,%ecx
   0x7d16:      mov    %esp,%ebp
   0x7d18:      mov    $0x1000,%edx
   0x7d1d:      push   %esi
   0x7d1e:      mov    $0x10000,%eax
   0x7d23:      push   %ebx
   0x7d24:      call   0x7c72
   0x7d29:      cmpl   $0x464c457f,0x10000
   0x7d33:      jne    0x7d74
   0x7d35:      mov    0x1001c,%eax
   0x7d3a:      movzwl 0x1002c,%esi
   0x7d41:      lea    0x10000(%eax),%ebx
   0x7d47:      shl    $0x5,%esi
   0x7d4a:      add    %ebx,%esi
   0x7d4c:      cmp    %esi,%ebx
   0x7d4e:      jae    0x7d68
--Type <RET> for more, q to quit, c to continue without paging--
   0x7d50:      mov    0x8(%ebx),%eax
   0x7d53:      add    $0x20,%ebx
   0x7d56:      mov    -0x1c(%ebx),%ecx
   0x7d59:      mov    -0xc(%ebx),%edx
   0x7d5c:      and    $0xffffff,%eax
   0x7d61:      call   0x7c72
   0x7d66:      jmp    0x7d4c
   0x7d68:      mov    0x10018,%eax
   0x7d6d:      and    $0xffffff,%eax
   0x7d72:      call   *%eax
   0x7d74:      mov    $0xffff8a00,%edx
   0x7d79:      mov    %edx,%eax
   0x7d7b:      out    %ax,(%dx)
   0x7d7d:      mov    $0xffff8e00,%eax
   0x7d82:      out    %ax,(%dx)
   0x7d84:      jmp    0x7d84
   0x7d86:      add    %al,(%eax)
   0x7d88:      adc    $0x0,%al
   0x7d8a:      add    %al,(%eax)
   0x7d8c:      add    %al,(%eax)
   0x7d8e:      add    %al,(%eax)
   0x7d90:      add    %edi,0x52(%edx)
   0x7d93:      add    %al,(%ecx)
   0x7d95:      jl     0x7d9f
   0x7d97:      add    %ebx,(%ebx)
   0x7d99:      or     $0x4,%al
   0x7d9b:      add    $0x88,%al
   0x7d9d:      add    %eax,(%eax)
   0x7d9f:      add    %ch,(%eax,%eax,1)
   0x7da2:      add    %al,(%eax)
   0x7da4:      sbb    $0x0,%al
   0x7da6:      add    %al,(%eax)
--Type <RET> for more, q to quit, c to continue without paging--
   0x7da8:      lret   $0xfffe
   0x7dab:      lcall  *0x0(%ebp)
   0x7db1:      inc    %ecx
   0x7db2:      push   %cs
   0x7db3:      or     %al,0x50d4202(%ebp)
   0x7db9:      inc    %edx
   0x7dba:      xchg   %eax,(%ebx)
   0x7dbc:      xchg   %al,(%eax,%ecx,2)
   0x7dbf:      addl   $0xffffffc6,0x41c38c02
   0x7dc6:      inc    %ecx
   0x7dc7:      movl   $0x4040c,-0x3b(%ecx)
   0x7dce:      add    %al,(%eax)
   0x7dd0:      sbb    $0x0,%al
   0x7dd2:      add    %al,(%eax)
   0x7dd4:      dec    %esp
   0x7dd5:      add    %al,(%eax)
   0x7dd7:      add    %dh,(%edi)
   0x7dd9:      (bad)
   0x7dda:      (bad)
   0x7ddb:      pushl  0x0(%edi)
   0x7dde:      add    %al,(%eax)
   0x7de0:      add    %al,0xe(%ebp)
   0x7de3:      or     %al,0x50d4402(%ebp)
   0x7de9:      dec    %esp
   0x7dea:      xchg   %al,(%ebx)
   0x7dec:      addl   $0x0,(%eax,%eax,1)
   0x7df0:      add    %al,(%eax)
   0x7df2:      add    %al,(%eax)
   0x7df4:      add    %al,(%eax)
   0x7df6:      add    %al,(%eax)
   0x7df8:      add    %al,(%eax)
   0x7dfa:      add    %al,(%eax)
--Type <RET> for more, q to quit, c to continue without paging--
   0x7dfc:      add    %al,(%eax)
   0x7dfe:      push   %ebp
   0x7dff:      stos   %al,%es:(%edi)
```

和汇编源代码里面的代码比，emmm首先上面的代码肯定没到512字节，会有跳转，有些地方都不知道跳到那里去了。。。但就以我的汇编水准而言，我觉得还是基本上跟源文件翻译出来之后会有一定差别，包括编译优化啊等等。

和生成后的asm文件对比，我觉得相比而言还是安排的明明白白的，至少跟反汇编的代码差别不大（只是不明白这个扇区后面的部分是什么玩意儿）因为源代码的汇编最后到了0x7d84，但是这里面整个扇区都写满了。


4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。
和上面操作差不多，看明白就懂了。

# 练习3：分析bootloader进入保护模式的过程。（要求在报告中写出分析）

以下是对bootasm.s文件的一些阅读理解（我尽量只挑选重要的说）：

整个大体的boot的部分，应该是bootasm用汇编写一些c里面无法编译的东西，然后跳转到bootmain.c的代码去执行，用于载入扇区，并检查一些重要的信息，然后再跳转到kernel去（但这个跳转并不返回，和传统的计算机上的代码并不相同），也难怪bootasm和反汇编得到的代码不同了，因为这个扇区里面还放了一些别的东西。

bootasm.s

```
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

```

上面就是正常的关中断，cld使得df这个flag为0，从而string复制的时候地址为递增的。然后再把ax清零，ds，es，ss寄存器都清零。

接下来是开A20地址线，事实上，并不止一种方法来开启A20地址线。这边只是记录一下这个代码做了什么，具体的内容我放到KeyPoints.txt文档中摘录和分析。

```
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

```

随后过程是加载gdt，使用lgdt指令——但这需要设置gdt字段

```
lgdt gdtdesc

#---------------------------------------------------------------------------------------------------#

.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
```

之后是打开保护模式

```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```

前后两句是为了保存eax的值而不是为了别的目的

最后是保护模式的一些代码并跳转到bootmain.c代码执行

```
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain
```

但对于上述代码，说真的，如果看过bios的开机内存分布的话，我不觉得把esp放在0x7c00是个安全的选择，从0x500到0x7c00大概30kb左右，如果大一点的系统未必够用，不过对于这个，我想肯定够用了。

这题目就算完成了吧，具体的知识点我去写KeyPoints里面去，这里面应该有三块内容，A20地址线，gdt，保护模式的位要打开。

# 练习4：分析bootloader加载ELF格式的OS的过程。（要求在报告中写出分析）

内容主要在bootmain.c文件中的readseg函数被定义，主要就是加载elf文件，需要记录一下elf文件头的作用

不过在此之前，需要看那节硬盘访问概述，了解，硬盘读取的众多端口和指令。并不在此记录，放在KeyPoints里面。（我真的不明白那个0x40是什么鬼，到时候测试一下下吧）

对于ELF文件格式的内容也放在那边。下面只解释代码

```
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;
	#指向末尾扇区的位置
    // round down to sector boundary
    va -= offset % SECTSIZE;
	#因为这个段肯定是连续的，所以减去后面的余数，每次开头部分加载一整个完整的扇区，但是结尾部分则多余的地方给删除掉
    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
	#读入扇区在内存中的位置，因为还有0扇区，所以+1
    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
        #每次加载一个扇区，然后加载完毕就好了
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
	#先读入8个扇区（并不懂为啥这样大小）
    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }
	#检查是否损坏文件
    struct proghdr *ph, *eph;
	#定义两个program header，一个指向末尾，一个用于计数
    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    #将计数指针指向头部
    eph = ph + ELFHDR->e_phnum;
    #指向末尾
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }
	#遍历，来读取某个segment
    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
	#加载完毕可以执行了，并且不返回
bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```

其他使用的函数，比如readsect，就是读一个硬盘的扇区，和前面提到的硬盘的有关。

另外，我觉得这里面用的ELF文件恐怕也需要加指定参数生成，因为，根本就没有后面其他部分的加载。

# 练习5：实现函数调用堆栈跟踪函数 （需要编程）

在这里我记录一下，这个实验中用到的一些函数的作用，以及编程的思路。

### 首先是这些函数（包括其他文件中的）：
1. read_ebp()
得到目前的ebp

2. read_eip()
得到目前的eip值
(容我说一句沙雕，这个，read_ebp函数放在x86.h下面，这个read_eip放在这个文件中。。。有猫饼) 哦好吧原来不是他沙雕，一个是内联函数放在x86下面，一个是非内联函数。我个人觉得理由是为了只让该文件中的函数调用read_eip（）这个函数，不然会很危险。

3. 我觉得首先需要解决一个如何按格式输出的问题。
这些东西其实放在stdio.h文件里面
（另，就个人看了之后，觉得层次感还是不错的，首先最底下console搞定输出一个字符的问题，主要涉及到底层硬件问题，然后用stdarg这个东西进行封装——因为字符串还要考虑format这种，参数可变，最后是printfmt.c文件里面的输出字符串等等操作——总觉得自己睁着眼睛说瞎话）

#### STDARG.H 文件
这个函数提供一个可变参数的作用。
必须说明的一点是，无论是linux还是这个ucore，实现其实差不多
都有一句
```
typedef __builtin_va_list va_list;
```
或者类似的语句，这里必须指出的是__builtin_va_list
这是一个编译器内置的东西，builtin的东西都是这样的。
不要想太多，就这么搞下去就行了，
```
#define va_start(ap, last)              (__builtin_va_start(ap, last))
##here，虽然ap没有指出，但是是一个va_list的类型。
##因为栈的特性，所以用栈传参的话，last就是第一个参数的指针
#define va_arg(ap, type)                (__builtin_va_arg(ap, type))
##考虑到字节数，所以要加一个type
#define va_end(ap)                      /*nothing*/
##防止野指针用的，有始有终。
```

#### vprintfmt（）
按照不同格式输出的函数就是这个，但是不同于平常C中写的printf
注意这行
```
switch (ch = *(unsigned char *)fmt ++)
```
这里面的fmt首先可以指定多个参数（因为有个++），应该是个string吧，到时候测试一下下。
然后它根据传入的fmt的参数进行处理，不同于C的printf，感觉他实现了一个**有限状态机**。
还可以选择不同的putch（我觉得是考虑到linux重定向，它会写入文件对吧），这边一般用cputch（）

注意：
事实上，并不经常使用printfmt.c这个文件中的东西感觉（虽然在stdio.h）中被定义
但是对他进行了封装，在stdio.c文件中，vcprintf（）调用了vprintfmt（）
而随后，cprintf（）又调用了vcprintf（）
所以最后一句话，直接调用cprintf就完事了。。。

（我会说看了半天代码，从底层一直看到上层，然后发现这回事的嘛，心情沮丧，当然不会啦）

比如说，到底哪些格式应该写成什么样子这些都是需要考虑的，而这些都要看源代码才知道。
这里面进制数
d是对有符号数十进制
u表示无符号数十进制
o表示无符号数八进制
p表示指针地址
x表示无符号数十六进制

（竟然不给文档。。心里一句mmp）

4.关于代码中的3.2的部分，就是要取该地址的内容，而不是该地址
注意到，ebp和eip就是指针，所以，直接读取的时候，虽然返回的是个uint32_t，但是可以作为一个指针来指向的。
另外要考虑到位置。每个arg都是加1，一个地址占用32bits

### 思路
其实就按照源代码给的注释，但是我觉得有必要去解释一下。
这里面一开始我不太明白最后那个popup做的是什么事情，然后我把读取两个point的事情放在了for循环里面

但是实际上，他做的事情是这样的，一开始获取当前的栈，然后每次假装pop，但是，并不真的pop——那样会导致整个程序都出毛病，所以不需要改动真实的ebp，就只是需要提取出上一层函数的栈就可以了——最多调用20层。

而这种方法做的就是每次迭代curr_ebp，就行了。

另外注意，每次退栈之前，要先读取上一层函数的eip，不能反过来，不然会出错。

### 运行结果
```
Kernel executable memory footprint: 68KB
ebp:0x00007b28 eip:0x00100ab4 args:0x00010094 0x00010094 0x00007b58 0x00100096
    kern/debug/kdebug.c:306: print_stackframe+23
ebp:0x00007b38 eip:0x00100db7 args:0x00000000 0x00000000 0x00000000 0x00007ba8
    kern/debug/kmonitor.c:125: mon_backtrace+11
ebp:0x00007b58 eip:0x00100096 args:0x00000000 0x00007b80 0xffff0000 0x00007b84
    kern/init/init.c:48: grade_backtrace2+34
ebp:0x00007b78 eip:0x001000c4 args:0x00000000 0xffff0000 0x00007ba4 0x00000029
    kern/init/init.c:53: grade_backtrace1+39
ebp:0x00007b98 eip:0x001000e7 args:0x00000000 0x00100000 0xffff0000 0x0000001d
    kern/init/init.c:58: grade_backtrace0+24
ebp:0x00007bb8 eip:0x00100111 args:0x0010343c 0x00103420 0x0000130a 0x00000000
    kern/init/init.c:63: grade_backtrace+35
ebp:0x00007be8 eip:0x00100055 args:0x00000000 0x00000000 0x00000000 0x00007c4f
    kern/init/init.c:28: kern_init+81
ebp:0x00007bf8 eip:0x00007d74 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d70 --
ebp:0x00000000 eip:0x00007c4f args:0xf000e2c3 0xf000ff53 0xf000ff53 0xf000ff54
    <unknow>: -- 0x00007c4b --
```

这边我发现和gitbook给的结果有些不同，但是我检查了之后，觉得应该是这样没错。可能代码后来改动过。

# 练习6：完善中断初始化和处理 （需要编程）
### questions：
1. 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？
2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。
3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。

### Answers:
1. 中断描述符表一个表项占用八个字节。其中低32位代表中断处理代码的入口。
2. 对于中断初始化的部分，我这边也记录一下我写代码的思路和一些其他代码做了什么。

首先要考虑到中断向量的位置，不能在函数中定义——因为那样会被放在栈上面，且不讲空间够不够，很容易引起内存错误的，所以需要在外面定义，这边是用了一个gatedesc 的数组表示的。

代码我看了一下，觉得挺神奇的
它从C代码跑到了汇编，再从汇编跑回C代码，具体执行流程是这样的

vector.s里面的汇编都把入口指向一个alltraps的函数，这个函数被定义在trapentry.s里面，主要是对一些寄存器进行保存，然后call了trap.c里面的trap函数，在返回之后再调用iret指令返回

我觉得写得还是不错的。代码逻辑清晰，原来调用汇编代码是这么个搞法。。。不过，我个人的理解是写内联汇编可能会有压栈等等问题。

vector.s文件里面分为两个部分，在下面的是__vector[] 这个数组的定义，每个数组项内容是一个指向相关函数的指针。
而上面部分则是函数的定义

vector.c 则是生成那个vector.s，其实差别不是很大。

所以要做的事情就是根据数组里面的指针填入那个门描述符表，然后调用lidt就没了。

emmmm但是我不知道，这个段选择符是什么呀？？？

我个人看法。先试一下，不知道对不对，这代码也不是很长，然后vector.s里面用的是code segment，回忆gdt相关，bootasm.s里面对于code segment的定义是第一个。所以，emmmm就用这个。
然后要用一个段选择符 segment selector来进行选择，那玩意16位（但我目前还没找到定义在哪里）

好吧，看上去真的要我自己写。

另一个事情是，看了实验的描述之后，我发现，在pmm.c文件里面对于gdt，他重新加载了。

不过，参考注释，kernel code segment并没有改变，仍然是0x8

好吧，我找到了，放在memlayout.h里面，定义为一个宏KERNEL_CS
这个文件的作用应该是内存布局的意思，所以有需要的话可以找找看。

3. 其实很简单，就是clock里面的一个global量递增一次，然后每100次就打印一次就好了
（但是我竟然跑飞了，说明，就是2里面的步骤有问题），啊不，改成__vector[i]就好了。。。？

我搞定了

总之而言，我觉得吧，这一节对于中断的部分，以及如何在描述符表里面找某个段，另外还有上次的printf的从低到高的实现，我觉得都是值得研究的部分。

