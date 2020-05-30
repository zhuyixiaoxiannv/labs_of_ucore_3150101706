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
1. 关于这个qemu的模拟，主要包括两个部分
一个是qemu中运行img，第二个是通过gdb使用qemu暴露的端口进行单步运行调试
首先是qemu中运行img