
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100045:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  10005d:	e8 6f 58 00 00       	call   1058d1 <memset>

    cons_init();                // init the console
  100062:	e8 4b 16 00 00       	call   1016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 00 61 10 00 	movl   $0x106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 1c 61 10 00 	movl   $0x10611c,(%esp)
  10007c:	e8 39 02 00 00       	call   1002ba <cprintf>

    print_kerninfo();
  100081:	e8 f7 08 00 00       	call   10097d <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 be 31 00 00       	call   10324e <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 98 17 00 00       	call   10182d <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 18 19 00 00       	call   1019b2 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 5a 0d 00 00       	call   100df9 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 d5 18 00 00       	call   101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 17 0d 00 00       	call   100de3 <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 21 61 10 00 	movl   $0x106121,(%esp)
  10017d:	e8 38 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  10019c:	e8 19 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  1001bb:	e8 fa 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 4b 61 10 00 	movl   $0x10614b,(%esp)
  1001da:	e8 db 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 59 61 10 00 	movl   $0x106159,(%esp)
  1001f9:	e8 bc 00 00 00       	call   1002ba <cprintf>
    round ++;
  1001fe:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100213:	90                   	nop
  100214:	5d                   	pop    %ebp
  100215:	c3                   	ret    

00100216 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100216:	f3 0f 1e fb          	endbr32 
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  10021d:	90                   	nop
  10021e:	5d                   	pop    %ebp
  10021f:	c3                   	ret    

00100220 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100220:	f3 0f 1e fb          	endbr32 
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10022a:	e8 1b ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10022f:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  100236:	e8 7f 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_user();
  10023b:	e8 cc ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  100240:	e8 05 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100245:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  10024c:	e8 69 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_kernel();
  100251:	e8 c0 ff ff ff       	call   100216 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100256:	e8 ef fe ff ff       	call   10014a <lab1_print_cur_status>
}
  10025b:	90                   	nop
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    

0010025e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10025e:	f3 0f 1e fb          	endbr32 
  100262:	55                   	push   %ebp
  100263:	89 e5                	mov    %esp,%ebp
  100265:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	89 04 24             	mov    %eax,(%esp)
  10026e:	e8 70 14 00 00       	call   1016e3 <cons_putc>
    (*cnt) ++;
  100273:	8b 45 0c             	mov    0xc(%ebp),%eax
  100276:	8b 00                	mov    (%eax),%eax
  100278:	8d 50 01             	lea    0x1(%eax),%edx
  10027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027e:	89 10                	mov    %edx,(%eax)
}
  100280:	90                   	nop
  100281:	c9                   	leave  
  100282:	c3                   	ret    

00100283 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100283:	f3 0f 1e fb          	endbr32 
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10028d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100294:	8b 45 0c             	mov    0xc(%ebp),%eax
  100297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10029b:	8b 45 08             	mov    0x8(%ebp),%eax
  10029e:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a9:	c7 04 24 5e 02 10 00 	movl   $0x10025e,(%esp)
  1002b0:	e8 88 59 00 00       	call   105c3d <vprintfmt>
    return cnt;
  1002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b8:	c9                   	leave  
  1002b9:	c3                   	ret    

001002ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002ba:	f3 0f 1e fb          	endbr32 
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 a7 ff ff ff       	call   100283 <vcprintf>
  1002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002e4:	f3 0f 1e fb          	endbr32 
  1002e8:	55                   	push   %ebp
  1002e9:	89 e5                	mov    %esp,%ebp
  1002eb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f1:	89 04 24             	mov    %eax,(%esp)
  1002f4:	e8 ea 13 00 00       	call   1016e3 <cons_putc>
}
  1002f9:	90                   	nop
  1002fa:	c9                   	leave  
  1002fb:	c3                   	ret    

001002fc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002fc:	f3 0f 1e fb          	endbr32 
  100300:	55                   	push   %ebp
  100301:	89 e5                	mov    %esp,%ebp
  100303:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10030d:	eb 13                	jmp    100322 <cputs+0x26>
        cputch(c, &cnt);
  10030f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100313:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100316:	89 54 24 04          	mov    %edx,0x4(%esp)
  10031a:	89 04 24             	mov    %eax,(%esp)
  10031d:	e8 3c ff ff ff       	call   10025e <cputch>
    while ((c = *str ++) != '\0') {
  100322:	8b 45 08             	mov    0x8(%ebp),%eax
  100325:	8d 50 01             	lea    0x1(%eax),%edx
  100328:	89 55 08             	mov    %edx,0x8(%ebp)
  10032b:	0f b6 00             	movzbl (%eax),%eax
  10032e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100331:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100335:	75 d8                	jne    10030f <cputs+0x13>
    }
    cputch('\n', &cnt);
  100337:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10033a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100345:	e8 14 ff ff ff       	call   10025e <cputch>
    return cnt;
  10034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10034d:	c9                   	leave  
  10034e:	c3                   	ret    

0010034f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10034f:	f3 0f 1e fb          	endbr32 
  100353:	55                   	push   %ebp
  100354:	89 e5                	mov    %esp,%ebp
  100356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100359:	90                   	nop
  10035a:	e8 c5 13 00 00       	call   101724 <cons_getc>
  10035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100366:	74 f2                	je     10035a <getchar+0xb>
        /* do nothing */;
    return c;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10036d:	f3 0f 1e fb          	endbr32 
  100371:	55                   	push   %ebp
  100372:	89 e5                	mov    %esp,%ebp
  100374:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10037b:	74 13                	je     100390 <readline+0x23>
        cprintf("%s", prompt);
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	89 44 24 04          	mov    %eax,0x4(%esp)
  100384:	c7 04 24 a7 61 10 00 	movl   $0x1061a7,(%esp)
  10038b:	e8 2a ff ff ff       	call   1002ba <cprintf>
    }
    int i = 0, c;
  100390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100397:	e8 b3 ff ff ff       	call   10034f <getchar>
  10039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10039f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003a3:	79 07                	jns    1003ac <readline+0x3f>
            return NULL;
  1003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  1003aa:	eb 78                	jmp    100424 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003ac:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003b0:	7e 28                	jle    1003da <readline+0x6d>
  1003b2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003b9:	7f 1f                	jg     1003da <readline+0x6d>
            cputchar(c);
  1003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003be:	89 04 24             	mov    %eax,(%esp)
  1003c1:	e8 1e ff ff ff       	call   1002e4 <cputchar>
            buf[i ++] = c;
  1003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003c9:	8d 50 01             	lea    0x1(%eax),%edx
  1003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003d2:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003d8:	eb 45                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003da:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003de:	75 16                	jne    1003f6 <readline+0x89>
  1003e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e4:	7e 10                	jle    1003f6 <readline+0x89>
            cputchar(c);
  1003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003e9:	89 04 24             	mov    %eax,(%esp)
  1003ec:	e8 f3 fe ff ff       	call   1002e4 <cputchar>
            i --;
  1003f1:	ff 4d f4             	decl   -0xc(%ebp)
  1003f4:	eb 29                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003f6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003fa:	74 06                	je     100402 <readline+0x95>
  1003fc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100400:	75 95                	jne    100397 <readline+0x2a>
            cputchar(c);
  100402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100405:	89 04 24             	mov    %eax,(%esp)
  100408:	e8 d7 fe ff ff       	call   1002e4 <cputchar>
            buf[i] = '\0';
  10040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100410:	05 20 c0 11 00       	add    $0x11c020,%eax
  100415:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100418:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  10041d:	eb 05                	jmp    100424 <readline+0xb7>
        c = getchar();
  10041f:	e9 73 ff ff ff       	jmp    100397 <readline+0x2a>
        }
    }
}
  100424:	c9                   	leave  
  100425:	c3                   	ret    

00100426 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100426:	f3 0f 1e fb          	endbr32 
  10042a:	55                   	push   %ebp
  10042b:	89 e5                	mov    %esp,%ebp
  10042d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100430:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100435:	85 c0                	test   %eax,%eax
  100437:	75 5b                	jne    100494 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100439:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100440:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100443:	8d 45 14             	lea    0x14(%ebp),%eax
  100446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100449:	8b 45 0c             	mov    0xc(%ebp),%eax
  10044c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100450:	8b 45 08             	mov    0x8(%ebp),%eax
  100453:	89 44 24 04          	mov    %eax,0x4(%esp)
  100457:	c7 04 24 aa 61 10 00 	movl   $0x1061aa,(%esp)
  10045e:	e8 57 fe ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046a:	8b 45 10             	mov    0x10(%ebp),%eax
  10046d:	89 04 24             	mov    %eax,(%esp)
  100470:	e8 0e fe ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  100475:	c7 04 24 c6 61 10 00 	movl   $0x1061c6,(%esp)
  10047c:	e8 39 fe ff ff       	call   1002ba <cprintf>
    
    cprintf("stack trackback:\n");
  100481:	c7 04 24 c8 61 10 00 	movl   $0x1061c8,(%esp)
  100488:	e8 2d fe ff ff       	call   1002ba <cprintf>
    print_stackframe();
  10048d:	e8 3d 06 00 00       	call   100acf <print_stackframe>
  100492:	eb 01                	jmp    100495 <__panic+0x6f>
        goto panic_dead;
  100494:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100495:	e8 eb 14 00 00       	call   101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004a1:	e8 64 08 00 00       	call   100d0a <kmonitor>
  1004a6:	eb f2                	jmp    10049a <__panic+0x74>

001004a8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004a8:	f3 0f 1e fb          	endbr32 
  1004ac:	55                   	push   %ebp
  1004ad:	89 e5                	mov    %esp,%ebp
  1004af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004b2:	8d 45 14             	lea    0x14(%ebp),%eax
  1004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004c6:	c7 04 24 da 61 10 00 	movl   $0x1061da,(%esp)
  1004cd:	e8 e8 fd ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  1004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 04 24             	mov    %eax,(%esp)
  1004df:	e8 9f fd ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  1004e4:	c7 04 24 c6 61 10 00 	movl   $0x1061c6,(%esp)
  1004eb:	e8 ca fd ff ff       	call   1002ba <cprintf>
    va_end(ap);
}
  1004f0:	90                   	nop
  1004f1:	c9                   	leave  
  1004f2:	c3                   	ret    

001004f3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004f3:	f3 0f 1e fb          	endbr32 
  1004f7:	55                   	push   %ebp
  1004f8:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004fa:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  1004ff:	5d                   	pop    %ebp
  100500:	c3                   	ret    

00100501 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100501:	f3 0f 1e fb          	endbr32 
  100505:	55                   	push   %ebp
  100506:	89 e5                	mov    %esp,%ebp
  100508:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100513:	8b 45 10             	mov    0x10(%ebp),%eax
  100516:	8b 00                	mov    (%eax),%eax
  100518:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10051b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100522:	e9 ca 00 00 00       	jmp    1005f1 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100527:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10052d:	01 d0                	add    %edx,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	c1 ea 1f             	shr    $0x1f,%edx
  100534:	01 d0                	add    %edx,%eax
  100536:	d1 f8                	sar    %eax
  100538:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100541:	eb 03                	jmp    100546 <stab_binsearch+0x45>
            m --;
  100543:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054c:	7c 1f                	jl     10056d <stab_binsearch+0x6c>
  10054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100551:	89 d0                	mov    %edx,%eax
  100553:	01 c0                	add    %eax,%eax
  100555:	01 d0                	add    %edx,%eax
  100557:	c1 e0 02             	shl    $0x2,%eax
  10055a:	89 c2                	mov    %eax,%edx
  10055c:	8b 45 08             	mov    0x8(%ebp),%eax
  10055f:	01 d0                	add    %edx,%eax
  100561:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100565:	0f b6 c0             	movzbl %al,%eax
  100568:	39 45 14             	cmp    %eax,0x14(%ebp)
  10056b:	75 d6                	jne    100543 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100570:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100573:	7d 09                	jge    10057e <stab_binsearch+0x7d>
            l = true_m + 1;
  100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100578:	40                   	inc    %eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10057c:	eb 73                	jmp    1005f1 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10057e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100588:	89 d0                	mov    %edx,%eax
  10058a:	01 c0                	add    %eax,%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	c1 e0 02             	shl    $0x2,%eax
  100591:	89 c2                	mov    %eax,%edx
  100593:	8b 45 08             	mov    0x8(%ebp),%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	8b 40 08             	mov    0x8(%eax),%eax
  10059b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10059e:	76 11                	jbe    1005b1 <stab_binsearch+0xb0>
            *region_left = m;
  1005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005ab:	40                   	inc    %eax
  1005ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005af:	eb 40                	jmp    1005f1 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b4:	89 d0                	mov    %edx,%eax
  1005b6:	01 c0                	add    %eax,%eax
  1005b8:	01 d0                	add    %edx,%eax
  1005ba:	c1 e0 02             	shl    $0x2,%eax
  1005bd:	89 c2                	mov    %eax,%edx
  1005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c2:	01 d0                	add    %edx,%eax
  1005c4:	8b 40 08             	mov    0x8(%eax),%eax
  1005c7:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ca:	73 14                	jae    1005e0 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	48                   	dec    %eax
  1005db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005de:	eb 11                	jmp    1005f1 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005e6:	89 10                	mov    %edx,(%eax)
            l = m;
  1005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005ee:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005f7:	0f 8e 2a ff ff ff    	jle    100527 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100601:	75 0f                	jne    100612 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	8b 00                	mov    (%eax),%eax
  100608:	8d 50 ff             	lea    -0x1(%eax),%edx
  10060b:	8b 45 10             	mov    0x10(%ebp),%eax
  10060e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100610:	eb 3e                	jmp    100650 <stab_binsearch+0x14f>
        l = *region_right;
  100612:	8b 45 10             	mov    0x10(%ebp),%eax
  100615:	8b 00                	mov    (%eax),%eax
  100617:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10061a:	eb 03                	jmp    10061f <stab_binsearch+0x11e>
  10061c:	ff 4d fc             	decl   -0x4(%ebp)
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	8b 00                	mov    (%eax),%eax
  100624:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100627:	7e 1f                	jle    100648 <stab_binsearch+0x147>
  100629:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10062c:	89 d0                	mov    %edx,%eax
  10062e:	01 c0                	add    %eax,%eax
  100630:	01 d0                	add    %edx,%eax
  100632:	c1 e0 02             	shl    $0x2,%eax
  100635:	89 c2                	mov    %eax,%edx
  100637:	8b 45 08             	mov    0x8(%ebp),%eax
  10063a:	01 d0                	add    %edx,%eax
  10063c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100640:	0f b6 c0             	movzbl %al,%eax
  100643:	39 45 14             	cmp    %eax,0x14(%ebp)
  100646:	75 d4                	jne    10061c <stab_binsearch+0x11b>
        *region_left = l;
  100648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10064e:	89 10                	mov    %edx,(%eax)
}
  100650:	90                   	nop
  100651:	c9                   	leave  
  100652:	c3                   	ret    

00100653 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100653:	f3 0f 1e fb          	endbr32 
  100657:	55                   	push   %ebp
  100658:	89 e5                	mov    %esp,%ebp
  10065a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100660:	c7 00 f8 61 10 00    	movl   $0x1061f8,(%eax)
    info->eip_line = 0;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100670:	8b 45 0c             	mov    0xc(%ebp),%eax
  100673:	c7 40 08 f8 61 10 00 	movl   $0x1061f8,0x8(%eax)
    info->eip_fn_namelen = 9;
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100684:	8b 45 0c             	mov    0xc(%ebp),%eax
  100687:	8b 55 08             	mov    0x8(%ebp),%edx
  10068a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100690:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100697:	c7 45 f4 08 74 10 00 	movl   $0x107408,-0xc(%ebp)
    stab_end = __STAB_END__;
  10069e:	c7 45 f0 74 3d 11 00 	movl   $0x113d74,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006a5:	c7 45 ec 75 3d 11 00 	movl   $0x113d75,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006ac:	c7 45 e8 a3 68 11 00 	movl   $0x1168a3,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006b9:	76 0b                	jbe    1006c6 <debuginfo_eip+0x73>
  1006bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006be:	48                   	dec    %eax
  1006bf:	0f b6 00             	movzbl (%eax),%eax
  1006c2:	84 c0                	test   %al,%al
  1006c4:	74 0a                	je     1006d0 <debuginfo_eip+0x7d>
        return -1;
  1006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006cb:	e9 ab 02 00 00       	jmp    10097b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006dd:	c1 f8 02             	sar    $0x2,%eax
  1006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006e6:	48                   	dec    %eax
  1006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006f1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006f8:	00 
  1006f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100703:	89 44 24 04          	mov    %eax,0x4(%esp)
  100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070a:	89 04 24             	mov    %eax,(%esp)
  10070d:	e8 ef fd ff ff       	call   100501 <stab_binsearch>
    if (lfile == 0)
  100712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100715:	85 c0                	test   %eax,%eax
  100717:	75 0a                	jne    100723 <debuginfo_eip+0xd0>
        return -1;
  100719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10071e:	e9 58 02 00 00       	jmp    10097b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100726:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10072f:	8b 45 08             	mov    0x8(%ebp),%eax
  100732:	89 44 24 10          	mov    %eax,0x10(%esp)
  100736:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10073d:	00 
  10073e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100741:	89 44 24 08          	mov    %eax,0x8(%esp)
  100745:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100748:	89 44 24 04          	mov    %eax,0x4(%esp)
  10074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074f:	89 04 24             	mov    %eax,(%esp)
  100752:	e8 aa fd ff ff       	call   100501 <stab_binsearch>

    if (lfun <= rfun) {
  100757:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10075a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075d:	39 c2                	cmp    %eax,%edx
  10075f:	7f 78                	jg     1007d9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	89 d0                	mov    %edx,%eax
  100768:	01 c0                	add    %eax,%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	c1 e0 02             	shl    $0x2,%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	8b 10                	mov    (%eax),%edx
  100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10077e:	39 c2                	cmp    %eax,%edx
  100780:	73 22                	jae    1007a4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 10                	mov    (%eax),%edx
  100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10079c:	01 c2                	add    %eax,%edx
  10079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a7:	89 c2                	mov    %eax,%edx
  1007a9:	89 d0                	mov    %edx,%eax
  1007ab:	01 c0                	add    %eax,%eax
  1007ad:	01 d0                	add    %edx,%eax
  1007af:	c1 e0 02             	shl    $0x2,%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b7:	01 d0                	add    %edx,%eax
  1007b9:	8b 50 08             	mov    0x8(%eax),%edx
  1007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c5:	8b 40 10             	mov    0x10(%eax),%eax
  1007c8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007d7:	eb 15                	jmp    1007ee <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1007df:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f1:	8b 40 08             	mov    0x8(%eax),%eax
  1007f4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007fb:	00 
  1007fc:	89 04 24             	mov    %eax,(%esp)
  1007ff:	e8 41 4f 00 00       	call   105745 <strfind>
  100804:	8b 55 0c             	mov    0xc(%ebp),%edx
  100807:	8b 52 08             	mov    0x8(%edx),%edx
  10080a:	29 d0                	sub    %edx,%eax
  10080c:	89 c2                	mov    %eax,%edx
  10080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100811:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100814:	8b 45 08             	mov    0x8(%ebp),%eax
  100817:	89 44 24 10          	mov    %eax,0x10(%esp)
  10081b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100822:	00 
  100823:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100826:	89 44 24 08          	mov    %eax,0x8(%esp)
  10082a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10082d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100834:	89 04 24             	mov    %eax,(%esp)
  100837:	e8 c5 fc ff ff       	call   100501 <stab_binsearch>
    if (lline <= rline) {
  10083c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10083f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100842:	39 c2                	cmp    %eax,%edx
  100844:	7f 23                	jg     100869 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100846:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	89 d0                	mov    %edx,%eax
  10084d:	01 c0                	add    %eax,%eax
  10084f:	01 d0                	add    %edx,%eax
  100851:	c1 e0 02             	shl    $0x2,%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 0c             	mov    0xc(%ebp),%eax
  100864:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100867:	eb 11                	jmp    10087a <debuginfo_eip+0x227>
        return -1;
  100869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10086e:	e9 08 01 00 00       	jmp    10097b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100876:	48                   	dec    %eax
  100877:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10087a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100880:	39 c2                	cmp    %eax,%edx
  100882:	7c 56                	jl     1008da <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100887:	89 c2                	mov    %eax,%edx
  100889:	89 d0                	mov    %edx,%eax
  10088b:	01 c0                	add    %eax,%eax
  10088d:	01 d0                	add    %edx,%eax
  10088f:	c1 e0 02             	shl    $0x2,%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100897:	01 d0                	add    %edx,%eax
  100899:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10089d:	3c 84                	cmp    $0x84,%al
  10089f:	74 39                	je     1008da <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	89 d0                	mov    %edx,%eax
  1008a8:	01 c0                	add    %eax,%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	c1 e0 02             	shl    $0x2,%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b4:	01 d0                	add    %edx,%eax
  1008b6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ba:	3c 64                	cmp    $0x64,%al
  1008bc:	75 b5                	jne    100873 <debuginfo_eip+0x220>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 40 08             	mov    0x8(%eax),%eax
  1008d6:	85 c0                	test   %eax,%eax
  1008d8:	74 99                	je     100873 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008e0:	39 c2                	cmp    %eax,%edx
  1008e2:	7c 42                	jl     100926 <debuginfo_eip+0x2d3>
  1008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e7:	89 c2                	mov    %eax,%edx
  1008e9:	89 d0                	mov    %edx,%eax
  1008eb:	01 c0                	add    %eax,%eax
  1008ed:	01 d0                	add    %edx,%eax
  1008ef:	c1 e0 02             	shl    $0x2,%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	8b 10                	mov    (%eax),%edx
  1008fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100901:	39 c2                	cmp    %eax,%edx
  100903:	73 21                	jae    100926 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100908:	89 c2                	mov    %eax,%edx
  10090a:	89 d0                	mov    %edx,%eax
  10090c:	01 c0                	add    %eax,%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c1 e0 02             	shl    $0x2,%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	8b 10                	mov    (%eax),%edx
  10091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10091f:	01 c2                	add    %eax,%edx
  100921:	8b 45 0c             	mov    0xc(%ebp),%eax
  100924:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100926:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10092c:	39 c2                	cmp    %eax,%edx
  10092e:	7d 46                	jge    100976 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100930:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100933:	40                   	inc    %eax
  100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100937:	eb 16                	jmp    10094f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100939:	8b 45 0c             	mov    0xc(%ebp),%eax
  10093c:	8b 40 14             	mov    0x14(%eax),%eax
  10093f:	8d 50 01             	lea    0x1(%eax),%edx
  100942:	8b 45 0c             	mov    0xc(%ebp),%eax
  100945:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10094b:	40                   	inc    %eax
  10094c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10094f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100952:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100955:	39 c2                	cmp    %eax,%edx
  100957:	7d 1d                	jge    100976 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10095c:	89 c2                	mov    %eax,%edx
  10095e:	89 d0                	mov    %edx,%eax
  100960:	01 c0                	add    %eax,%eax
  100962:	01 d0                	add    %edx,%eax
  100964:	c1 e0 02             	shl    $0x2,%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10096c:	01 d0                	add    %edx,%eax
  10096e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100972:	3c a0                	cmp    $0xa0,%al
  100974:	74 c3                	je     100939 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10097b:	c9                   	leave  
  10097c:	c3                   	ret    

0010097d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10097d:	f3 0f 1e fb          	endbr32 
  100981:	55                   	push   %ebp
  100982:	89 e5                	mov    %esp,%ebp
  100984:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100987:	c7 04 24 02 62 10 00 	movl   $0x106202,(%esp)
  10098e:	e8 27 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100993:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10099a:	00 
  10099b:	c7 04 24 1b 62 10 00 	movl   $0x10621b,(%esp)
  1009a2:	e8 13 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009a7:	c7 44 24 04 f5 60 10 	movl   $0x1060f5,0x4(%esp)
  1009ae:	00 
  1009af:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  1009b6:	e8 ff f8 ff ff       	call   1002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009bb:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009c2:	00 
  1009c3:	c7 04 24 4b 62 10 00 	movl   $0x10624b,(%esp)
  1009ca:	e8 eb f8 ff ff       	call   1002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009cf:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 63 62 10 00 	movl   $0x106263,(%esp)
  1009de:	e8 d7 f8 ff ff       	call   1002ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009e3:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  1009e8:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009ed:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009f8:	85 c0                	test   %eax,%eax
  1009fa:	0f 48 c2             	cmovs  %edx,%eax
  1009fd:	c1 f8 0a             	sar    $0xa,%eax
  100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a04:	c7 04 24 7c 62 10 00 	movl   $0x10627c,(%esp)
  100a0b:	e8 aa f8 ff ff       	call   1002ba <cprintf>
}
  100a10:	90                   	nop
  100a11:	c9                   	leave  
  100a12:	c3                   	ret    

00100a13 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a13:	f3 0f 1e fb          	endbr32 
  100a17:	55                   	push   %ebp
  100a18:	89 e5                	mov    %esp,%ebp
  100a1a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a20:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	8b 45 08             	mov    0x8(%ebp),%eax
  100a2a:	89 04 24             	mov    %eax,(%esp)
  100a2d:	e8 21 fc ff ff       	call   100653 <debuginfo_eip>
  100a32:	85 c0                	test   %eax,%eax
  100a34:	74 15                	je     100a4b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a36:	8b 45 08             	mov    0x8(%ebp),%eax
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100a44:	e8 71 f8 ff ff       	call   1002ba <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a49:	eb 6c                	jmp    100ab7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a52:	eb 1b                	jmp    100a6f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	0f b6 10             	movzbl (%eax),%edx
  100a5f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a68:	01 c8                	add    %ecx,%eax
  100a6a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a6c:	ff 45 f4             	incl   -0xc(%ebp)
  100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a75:	7c dd                	jl     100a54 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a77:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a80:	01 d0                	add    %edx,%eax
  100a82:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a88:	8b 55 08             	mov    0x8(%ebp),%edx
  100a8b:	89 d1                	mov    %edx,%ecx
  100a8d:	29 c1                	sub    %eax,%ecx
  100a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a99:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aa3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100ab2:	e8 03 f8 ff ff       	call   1002ba <cprintf>
}
  100ab7:	90                   	nop
  100ab8:	c9                   	leave  
  100ab9:	c3                   	ret    

00100aba <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100aba:	f3 0f 1e fb          	endbr32 
  100abe:	55                   	push   %ebp
  100abf:	89 e5                	mov    %esp,%ebp
  100ac1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ac4:	8b 45 04             	mov    0x4(%ebp),%eax
  100ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100acd:	c9                   	leave  
  100ace:	c3                   	ret    

00100acf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100acf:	f3 0f 1e fb          	endbr32 
  100ad3:	55                   	push   %ebp
  100ad4:	89 e5                	mov    %esp,%ebp
  100ad6:	53                   	push   %ebx
  100ad7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ada:	89 e8                	mov    %ebp,%eax
  100adc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t* curr_ebp=read_ebp();
  100ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t* curr_eip=read_eip();
  100ae5:	e8 d0 ff ff ff       	call   100aba <read_eip>
  100aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //读了代码之后我觉得差别不是很大，我觉得需要注意的地方是在for循环里面的终止条件里面加上了ebp != 0
    for (int i = 0 ; curr_ebp!=NULL && i < STACKFRAME_DEPTH ; ++i )
  100aed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100af4:	e9 86 00 00 00       	jmp    100b7f <print_stackframe+0xb0>
    {
        cprintf("ebp:%08p eip:%08p ",curr_ebp,curr_eip);
  100af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b07:	c7 04 24 d4 62 10 00 	movl   $0x1062d4,(%esp)
  100b0e:	e8 a7 f7 ff ff       	call   1002ba <cprintf>
        cprintf("args:%08p %08p %08p %08p",*(curr_ebp+2),*(curr_ebp+3),*(curr_ebp+4),*(curr_ebp+5));
  100b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b16:	83 c0 14             	add    $0x14,%eax
  100b19:	8b 18                	mov    (%eax),%ebx
  100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1e:	83 c0 10             	add    $0x10,%eax
  100b21:	8b 08                	mov    (%eax),%ecx
  100b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b26:	83 c0 0c             	add    $0xc,%eax
  100b29:	8b 10                	mov    (%eax),%edx
  100b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2e:	83 c0 08             	add    $0x8,%eax
  100b31:	8b 00                	mov    (%eax),%eax
  100b33:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b43:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  100b4a:	e8 6b f7 ff ff       	call   1002ba <cprintf>
        cprintf("\n");
  100b4f:	c7 04 24 00 63 10 00 	movl   $0x106300,(%esp)
  100b56:	e8 5f f7 ff ff       	call   1002ba <cprintf>
        print_debuginfo(curr_eip-1);
  100b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b5e:	83 e8 04             	sub    $0x4,%eax
  100b61:	89 04 24             	mov    %eax,(%esp)
  100b64:	e8 aa fe ff ff       	call   100a13 <print_debuginfo>
        curr_eip=*(curr_ebp+1);
  100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6c:	83 c0 04             	add    $0x4,%eax
  100b6f:	8b 00                	mov    (%eax),%eax
  100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp=*(curr_ebp);
  100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b77:	8b 00                	mov    (%eax),%eax
  100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0 ; curr_ebp!=NULL && i < STACKFRAME_DEPTH ; ++i )
  100b7c:	ff 45 ec             	incl   -0x14(%ebp)
  100b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b83:	74 0a                	je     100b8f <print_stackframe+0xc0>
  100b85:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b89:	0f 8e 6a ff ff ff    	jle    100af9 <print_stackframe+0x2a>
    }
}
  100b8f:	90                   	nop
  100b90:	83 c4 34             	add    $0x34,%esp
  100b93:	5b                   	pop    %ebx
  100b94:	5d                   	pop    %ebp
  100b95:	c3                   	ret    

00100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b96:	f3 0f 1e fb          	endbr32 
  100b9a:	55                   	push   %ebp
  100b9b:	89 e5                	mov    %esp,%ebp
  100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba7:	eb 0c                	jmp    100bb5 <parse+0x1f>
            *buf ++ = '\0';
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	8d 50 01             	lea    0x1(%eax),%edx
  100baf:	89 55 08             	mov    %edx,0x8(%ebp)
  100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	84 c0                	test   %al,%al
  100bbd:	74 1d                	je     100bdc <parse+0x46>
  100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc2:	0f b6 00             	movzbl (%eax),%eax
  100bc5:	0f be c0             	movsbl %al,%eax
  100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcc:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  100bd3:	e8 37 4b 00 00       	call   10570f <strchr>
  100bd8:	85 c0                	test   %eax,%eax
  100bda:	75 cd                	jne    100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
  100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdf:	0f b6 00             	movzbl (%eax),%eax
  100be2:	84 c0                	test   %al,%al
  100be4:	74 65                	je     100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bea:	75 14                	jne    100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bf3:	00 
  100bf4:	c7 04 24 89 63 10 00 	movl   $0x106389,(%esp)
  100bfb:	e8 ba f6 ff ff       	call   1002ba <cprintf>
        }
        argv[argc ++] = buf;
  100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c03:	8d 50 01             	lea    0x1(%eax),%edx
  100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c13:	01 c2                	add    %eax,%edx
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1a:	eb 03                	jmp    100c1f <parse+0x89>
            buf ++;
  100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c22:	0f b6 00             	movzbl (%eax),%eax
  100c25:	84 c0                	test   %al,%al
  100c27:	74 8c                	je     100bb5 <parse+0x1f>
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	0f b6 00             	movzbl (%eax),%eax
  100c2f:	0f be c0             	movsbl %al,%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  100c3d:	e8 cd 4a 00 00       	call   10570f <strchr>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	74 d6                	je     100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c46:	e9 6a ff ff ff       	jmp    100bb5 <parse+0x1f>
            break;
  100c4b:	90                   	nop
        }
    }
    return argc;
  100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c51:	f3 0f 1e fb          	endbr32 
  100c55:	55                   	push   %ebp
  100c56:	89 e5                	mov    %esp,%ebp
  100c58:	53                   	push   %ebx
  100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c63:	8b 45 08             	mov    0x8(%ebp),%eax
  100c66:	89 04 24             	mov    %eax,(%esp)
  100c69:	e8 28 ff ff ff       	call   100b96 <parse>
  100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c75:	75 0a                	jne    100c81 <runcmd+0x30>
        return 0;
  100c77:	b8 00 00 00 00       	mov    $0x0,%eax
  100c7c:	e9 83 00 00 00       	jmp    100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c88:	eb 5a                	jmp    100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c90:	89 d0                	mov    %edx,%eax
  100c92:	01 c0                	add    %eax,%eax
  100c94:	01 d0                	add    %edx,%eax
  100c96:	c1 e0 02             	shl    $0x2,%eax
  100c99:	05 00 90 11 00       	add    $0x119000,%eax
  100c9e:	8b 00                	mov    (%eax),%eax
  100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca4:	89 04 24             	mov    %eax,(%esp)
  100ca7:	e8 bf 49 00 00       	call   10566b <strcmp>
  100cac:	85 c0                	test   %eax,%eax
  100cae:	75 31                	jne    100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb3:	89 d0                	mov    %edx,%eax
  100cb5:	01 c0                	add    %eax,%eax
  100cb7:	01 d0                	add    %edx,%eax
  100cb9:	c1 e0 02             	shl    $0x2,%eax
  100cbc:	05 08 90 11 00       	add    $0x119008,%eax
  100cc1:	8b 10                	mov    (%eax),%edx
  100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cc6:	83 c0 04             	add    $0x4,%eax
  100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cda:	89 1c 24             	mov    %ebx,(%esp)
  100cdd:	ff d2                	call   *%edx
  100cdf:	eb 23                	jmp    100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce1:	ff 45 f4             	incl   -0xc(%ebp)
  100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce7:	83 f8 02             	cmp    $0x2,%eax
  100cea:	76 9e                	jbe    100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf3:	c7 04 24 a7 63 10 00 	movl   $0x1063a7,(%esp)
  100cfa:	e8 bb f5 ff ff       	call   1002ba <cprintf>
    return 0;
  100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d04:	83 c4 64             	add    $0x64,%esp
  100d07:	5b                   	pop    %ebx
  100d08:	5d                   	pop    %ebp
  100d09:	c3                   	ret    

00100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d0a:	f3 0f 1e fb          	endbr32 
  100d0e:	55                   	push   %ebp
  100d0f:	89 e5                	mov    %esp,%ebp
  100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d14:	c7 04 24 c0 63 10 00 	movl   $0x1063c0,(%esp)
  100d1b:	e8 9a f5 ff ff       	call   1002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d20:	c7 04 24 e8 63 10 00 	movl   $0x1063e8,(%esp)
  100d27:	e8 8e f5 ff ff       	call   1002ba <cprintf>

    if (tf != NULL) {
  100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d30:	74 0b                	je     100d3d <kmonitor+0x33>
        print_trapframe(tf);
  100d32:	8b 45 08             	mov    0x8(%ebp),%eax
  100d35:	89 04 24             	mov    %eax,(%esp)
  100d38:	e8 bc 0d 00 00       	call   101af9 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d3d:	c7 04 24 0d 64 10 00 	movl   $0x10640d,(%esp)
  100d44:	e8 24 f6 ff ff       	call   10036d <readline>
  100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d50:	74 eb                	je     100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d52:	8b 45 08             	mov    0x8(%ebp),%eax
  100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5c:	89 04 24             	mov    %eax,(%esp)
  100d5f:	e8 ed fe ff ff       	call   100c51 <runcmd>
  100d64:	85 c0                	test   %eax,%eax
  100d66:	78 02                	js     100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d68:	eb d3                	jmp    100d3d <kmonitor+0x33>
                break;
  100d6a:	90                   	nop
            }
        }
    }
}
  100d6b:	90                   	nop
  100d6c:	c9                   	leave  
  100d6d:	c3                   	ret    

00100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d6e:	f3 0f 1e fb          	endbr32 
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d7f:	eb 3d                	jmp    100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d84:	89 d0                	mov    %edx,%eax
  100d86:	01 c0                	add    %eax,%eax
  100d88:	01 d0                	add    %edx,%eax
  100d8a:	c1 e0 02             	shl    $0x2,%eax
  100d8d:	05 04 90 11 00       	add    $0x119004,%eax
  100d92:	8b 08                	mov    (%eax),%ecx
  100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d97:	89 d0                	mov    %edx,%eax
  100d99:	01 c0                	add    %eax,%eax
  100d9b:	01 d0                	add    %edx,%eax
  100d9d:	c1 e0 02             	shl    $0x2,%eax
  100da0:	05 00 90 11 00       	add    $0x119000,%eax
  100da5:	8b 00                	mov    (%eax),%eax
  100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100daf:	c7 04 24 11 64 10 00 	movl   $0x106411,(%esp)
  100db6:	e8 ff f4 ff ff       	call   1002ba <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100dbb:	ff 45 f4             	incl   -0xc(%ebp)
  100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc1:	83 f8 02             	cmp    $0x2,%eax
  100dc4:	76 bb                	jbe    100d81 <mon_help+0x13>
    }
    return 0;
  100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dcd:	f3 0f 1e fb          	endbr32 
  100dd1:	55                   	push   %ebp
  100dd2:	89 e5                	mov    %esp,%ebp
  100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd7:	e8 a1 fb ff ff       	call   10097d <print_kerninfo>
    return 0;
  100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de1:	c9                   	leave  
  100de2:	c3                   	ret    

00100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100de3:	f3 0f 1e fb          	endbr32 
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ded:	e8 dd fc ff ff       	call   100acf <print_stackframe>
    return 0;
  100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df9:	f3 0f 1e fb          	endbr32 
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 28             	sub    $0x28,%esp
  100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e15:	ee                   	out    %al,(%dx)
}
  100e16:	90                   	nop
  100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e29:	ee                   	out    %al,(%dx)
}
  100e2a:	90                   	nop
  100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e3d:	ee                   	out    %al,(%dx)
}
  100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e3f:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e49:	c7 04 24 1a 64 10 00 	movl   $0x10641a,(%esp)
  100e50:	e8 65 f4 ff ff       	call   1002ba <cprintf>
    pic_enable(IRQ_TIMER);
  100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e5c:	e8 95 09 00 00       	call   1017f6 <pic_enable>
}
  100e61:	90                   	nop
  100e62:	c9                   	leave  
  100e63:	c3                   	ret    

00100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e6a:	9c                   	pushf  
  100e6b:	58                   	pop    %eax
  100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e72:	25 00 02 00 00       	and    $0x200,%eax
  100e77:	85 c0                	test   %eax,%eax
  100e79:	74 0c                	je     100e87 <__intr_save+0x23>
        intr_disable();
  100e7b:	e8 05 0b 00 00       	call   101985 <intr_disable>
        return 1;
  100e80:	b8 01 00 00 00       	mov    $0x1,%eax
  100e85:	eb 05                	jmp    100e8c <__intr_save+0x28>
    }
    return 0;
  100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e8c:	c9                   	leave  
  100e8d:	c3                   	ret    

00100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e8e:	55                   	push   %ebp
  100e8f:	89 e5                	mov    %esp,%ebp
  100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e98:	74 05                	je     100e9f <__intr_restore+0x11>
        intr_enable();
  100e9a:	e8 da 0a 00 00       	call   101979 <intr_enable>
    }
}
  100e9f:	90                   	nop
  100ea0:	c9                   	leave  
  100ea1:	c3                   	ret    

00100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ea2:	f3 0f 1e fb          	endbr32 
  100ea6:	55                   	push   %ebp
  100ea7:	89 e5                	mov    %esp,%ebp
  100ea9:	83 ec 10             	sub    $0x10,%esp
  100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb6:	89 c2                	mov    %eax,%edx
  100eb8:	ec                   	in     (%dx),%al
  100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ee6:	89 c2                	mov    %eax,%edx
  100ee8:	ec                   	in     (%dx),%al
  100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eec:	90                   	nop
  100eed:	c9                   	leave  
  100eee:	c3                   	ret    

00100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eef:	f3 0f 1e fb          	endbr32 
  100ef3:	55                   	push   %ebp
  100ef4:	89 e5                	mov    %esp,%ebp
  100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f03:	0f b7 00             	movzwl (%eax),%eax
  100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f15:	0f b7 00             	movzwl (%eax),%eax
  100f18:	0f b7 c0             	movzwl %ax,%eax
  100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f20:	74 12                	je     100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f29:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f30:	b4 03 
  100f32:	eb 13                	jmp    100f47 <cga_init+0x58>
    } else {
        *cp = was;
  100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f3e:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f47:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f60:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f67:	40                   	inc    %eax
  100f68:	0f b7 c0             	movzwl %ax,%eax
  100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f73:	89 c2                	mov    %eax,%edx
  100f75:	ec                   	in     (%dx),%al
  100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	c1 e0 08             	shl    $0x8,%eax
  100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f86:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f9d:	ee                   	out    %al,(%dx)
}
  100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f9f:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100fa6:	40                   	inc    %eax
  100fa7:	0f b7 c0             	movzwl %ax,%eax
  100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fb2:	89 c2                	mov    %eax,%edx
  100fb4:	ec                   	in     (%dx),%al
  100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fbc:	0f b6 c0             	movzbl %al,%eax
  100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc5:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fcd:	0f b7 c0             	movzwl %ax,%eax
  100fd0:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100fd6:	90                   	nop
  100fd7:	c9                   	leave  
  100fd8:	c3                   	ret    

00100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd9:	f3 0f 1e fb          	endbr32 
  100fdd:	55                   	push   %ebp
  100fde:	89 e5                	mov    %esp,%ebp
  100fe0:	83 ec 48             	sub    $0x48,%esp
  100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
}
  100ff6:	90                   	nop
  100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101009:	ee                   	out    %al,(%dx)
}
  10100a:	90                   	nop
  10100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
}
  10101e:	90                   	nop
  10101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
}
  101032:	90                   	nop
  101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101045:	ee                   	out    %al,(%dx)
}
  101046:	90                   	nop
  101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101059:	ee                   	out    %al,(%dx)
}
  10105a:	90                   	nop
  10105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10106d:	ee                   	out    %al,(%dx)
}
  10106e:	90                   	nop
  10106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101079:	89 c2                	mov    %eax,%edx
  10107b:	ec                   	in     (%dx),%al
  10107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101083:	3c ff                	cmp    $0xff,%al
  101085:	0f 95 c0             	setne  %al
  101088:	0f b6 c0             	movzbl %al,%eax
  10108b:	a3 48 c4 11 00       	mov    %eax,0x11c448
  101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10109a:	89 c2                	mov    %eax,%edx
  10109c:	ec                   	in     (%dx),%al
  10109d:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010aa:	89 c2                	mov    %eax,%edx
  1010ac:	ec                   	in     (%dx),%al
  1010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010b0:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1010b5:	85 c0                	test   %eax,%eax
  1010b7:	74 0c                	je     1010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010c0:	e8 31 07 00 00       	call   1017f6 <pic_enable>
    }
}
  1010c5:	90                   	nop
  1010c6:	c9                   	leave  
  1010c7:	c3                   	ret    

001010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010c8:	f3 0f 1e fb          	endbr32 
  1010cc:	55                   	push   %ebp
  1010cd:	89 e5                	mov    %esp,%ebp
  1010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d9:	eb 08                	jmp    1010e3 <lpt_putc_sub+0x1b>
        delay();
  1010db:	e8 c2 fd ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010e0:	ff 45 fc             	incl   -0x4(%ebp)
  1010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010ed:	89 c2                	mov    %eax,%edx
  1010ef:	ec                   	in     (%dx),%al
  1010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010f7:	84 c0                	test   %al,%al
  1010f9:	78 09                	js     101104 <lpt_putc_sub+0x3c>
  1010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101102:	7e d7                	jle    1010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	0f b6 c0             	movzbl %al,%eax
  10110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10111b:	ee                   	out    %al,(%dx)
}
  10111c:	90                   	nop
  10111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10112f:	ee                   	out    %al,(%dx)
}
  101130:	90                   	nop
  101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101143:	ee                   	out    %al,(%dx)
}
  101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101145:	90                   	nop
  101146:	c9                   	leave  
  101147:	c3                   	ret    

00101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101148:	f3 0f 1e fb          	endbr32 
  10114c:	55                   	push   %ebp
  10114d:	89 e5                	mov    %esp,%ebp
  10114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101156:	74 0d                	je     101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101158:	8b 45 08             	mov    0x8(%ebp),%eax
  10115b:	89 04 24             	mov    %eax,(%esp)
  10115e:	e8 65 ff ff ff       	call   1010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101163:	eb 24                	jmp    101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10116c:	e8 57 ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101178:	e8 4b ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101184:	e8 3f ff ff ff       	call   1010c8 <lpt_putc_sub>
}
  101189:	90                   	nop
  10118a:	c9                   	leave  
  10118b:	c3                   	ret    

0010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10118c:	f3 0f 1e fb          	endbr32 
  101190:	55                   	push   %ebp
  101191:	89 e5                	mov    %esp,%ebp
  101193:	53                   	push   %ebx
  101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101197:	8b 45 08             	mov    0x8(%ebp),%eax
  10119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10119f:	85 c0                	test   %eax,%eax
  1011a1:	75 07                	jne    1011aa <cga_putc+0x1e>
        c |= 0x0700;
  1011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ad:	0f b6 c0             	movzbl %al,%eax
  1011b0:	83 f8 0d             	cmp    $0xd,%eax
  1011b3:	74 72                	je     101227 <cga_putc+0x9b>
  1011b5:	83 f8 0d             	cmp    $0xd,%eax
  1011b8:	0f 8f a3 00 00 00    	jg     101261 <cga_putc+0xd5>
  1011be:	83 f8 08             	cmp    $0x8,%eax
  1011c1:	74 0a                	je     1011cd <cga_putc+0x41>
  1011c3:	83 f8 0a             	cmp    $0xa,%eax
  1011c6:	74 4c                	je     101214 <cga_putc+0x88>
  1011c8:	e9 94 00 00 00       	jmp    101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011cd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011d4:	85 c0                	test   %eax,%eax
  1011d6:	0f 84 af 00 00 00    	je     10128b <cga_putc+0xff>
            crt_pos --;
  1011dc:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011e3:	48                   	dec    %eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f0:	98                   	cwtl   
  1011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011f6:	98                   	cwtl   
  1011f7:	83 c8 20             	or     $0x20,%eax
  1011fa:	98                   	cwtl   
  1011fb:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  101201:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101208:	01 c9                	add    %ecx,%ecx
  10120a:	01 ca                	add    %ecx,%edx
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101212:	eb 77                	jmp    10128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101214:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10121b:	83 c0 50             	add    $0x50,%eax
  10121e:	0f b7 c0             	movzwl %ax,%eax
  101221:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101227:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  10122e:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10123a:	89 c8                	mov    %ecx,%eax
  10123c:	f7 e2                	mul    %edx
  10123e:	c1 ea 06             	shr    $0x6,%edx
  101241:	89 d0                	mov    %edx,%eax
  101243:	c1 e0 02             	shl    $0x2,%eax
  101246:	01 d0                	add    %edx,%eax
  101248:	c1 e0 04             	shl    $0x4,%eax
  10124b:	29 c1                	sub    %eax,%ecx
  10124d:	89 c8                	mov    %ecx,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	29 c3                	sub    %eax,%ebx
  101254:	89 d8                	mov    %ebx,%eax
  101256:	0f b7 c0             	movzwl %ax,%eax
  101259:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  10125f:	eb 2b                	jmp    10128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101261:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101267:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10126e:	8d 50 01             	lea    0x1(%eax),%edx
  101271:	0f b7 d2             	movzwl %dx,%edx
  101274:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  10127b:	01 c0                	add    %eax,%eax
  10127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101280:	8b 45 08             	mov    0x8(%ebp),%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 89 02             	mov    %ax,(%edx)
        break;
  101289:	eb 01                	jmp    10128c <cga_putc+0x100>
        break;
  10128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10128c:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101298:	76 5d                	jbe    1012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10129a:	a1 40 c4 11 00       	mov    0x11c440,%eax
  10129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012a5:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012b1:	00 
  1012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012b6:	89 04 24             	mov    %eax,(%esp)
  1012b9:	e8 56 46 00 00       	call   105914 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012c5:	eb 14                	jmp    1012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c7:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cf:	01 d2                	add    %edx,%edx
  1012d1:	01 d0                	add    %edx,%eax
  1012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012d8:	ff 45 f4             	incl   -0xc(%ebp)
  1012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012e2:	7e e3                	jle    1012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012e4:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012eb:	83 e8 50             	sub    $0x50,%eax
  1012ee:	0f b7 c0             	movzwl %ax,%eax
  1012f1:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f7:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101310:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101317:	c1 e8 08             	shr    $0x8,%eax
  10131a:	0f b7 c0             	movzwl %ax,%eax
  10131d:	0f b6 c0             	movzbl %al,%eax
  101320:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101327:	42                   	inc    %edx
  101328:	0f b7 d2             	movzwl %dx,%edx
  10132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10133a:	ee                   	out    %al,(%dx)
}
  10133b:	90                   	nop
    outb(addr_6845, 15);
  10133c:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101353:	ee                   	out    %al,(%dx)
}
  101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101355:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101366:	42                   	inc    %edx
  101367:	0f b7 d2             	movzwl %dx,%edx
  10136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101379:	ee                   	out    %al,(%dx)
}
  10137a:	90                   	nop
}
  10137b:	90                   	nop
  10137c:	83 c4 34             	add    $0x34,%esp
  10137f:	5b                   	pop    %ebx
  101380:	5d                   	pop    %ebp
  101381:	c3                   	ret    

00101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101382:	f3 0f 1e fb          	endbr32 
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101393:	eb 08                	jmp    10139d <serial_putc_sub+0x1b>
        delay();
  101395:	e8 08 fb ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10139a:	ff 45 fc             	incl   -0x4(%ebp)
  10139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a7:	89 c2                	mov    %eax,%edx
  1013a9:	ec                   	in     (%dx),%al
  1013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013b1:	0f b6 c0             	movzbl %al,%eax
  1013b4:	83 e0 20             	and    $0x20,%eax
  1013b7:	85 c0                	test   %eax,%eax
  1013b9:	75 09                	jne    1013c4 <serial_putc_sub+0x42>
  1013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013c2:	7e d1                	jle    101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013db:	ee                   	out    %al,(%dx)
}
  1013dc:	90                   	nop
}
  1013dd:	90                   	nop
  1013de:	c9                   	leave  
  1013df:	c3                   	ret    

001013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013e0:	f3 0f 1e fb          	endbr32 
  1013e4:	55                   	push   %ebp
  1013e5:	89 e5                	mov    %esp,%ebp
  1013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013ee:	74 0d                	je     1013fd <serial_putc+0x1d>
        serial_putc_sub(c);
  1013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1013f3:	89 04 24             	mov    %eax,(%esp)
  1013f6:	e8 87 ff ff ff       	call   101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013fb:	eb 24                	jmp    101421 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101404:	e8 79 ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub(' ');
  101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101410:	e8 6d ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub('\b');
  101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10141c:	e8 61 ff ff ff       	call   101382 <serial_putc_sub>
}
  101421:	90                   	nop
  101422:	c9                   	leave  
  101423:	c3                   	ret    

00101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101424:	f3 0f 1e fb          	endbr32 
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10142e:	eb 33                	jmp    101463 <cons_intr+0x3f>
        if (c != 0) {
  101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101434:	74 2d                	je     101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101436:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10143b:	8d 50 01             	lea    0x1(%eax),%edx
  10143e:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101447:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10144d:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101452:	3d 00 02 00 00       	cmp    $0x200,%eax
  101457:	75 0a                	jne    101463 <cons_intr+0x3f>
                cons.wpos = 0;
  101459:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101463:	8b 45 08             	mov    0x8(%ebp),%eax
  101466:	ff d0                	call   *%eax
  101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10146f:	75 bf                	jne    101430 <cons_intr+0xc>
            }
        }
    }
}
  101471:	90                   	nop
  101472:	90                   	nop
  101473:	c9                   	leave  
  101474:	c3                   	ret    

00101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101475:	f3 0f 1e fb          	endbr32 
  101479:	55                   	push   %ebp
  10147a:	89 e5                	mov    %esp,%ebp
  10147c:	83 ec 10             	sub    $0x10,%esp
  10147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101489:	89 c2                	mov    %eax,%edx
  10148b:	ec                   	in     (%dx),%al
  10148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101493:	0f b6 c0             	movzbl %al,%eax
  101496:	83 e0 01             	and    $0x1,%eax
  101499:	85 c0                	test   %eax,%eax
  10149b:	75 07                	jne    1014a4 <serial_proc_data+0x2f>
        return -1;
  10149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a2:	eb 2a                	jmp    1014ce <serial_proc_data+0x59>
  1014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014ae:	89 c2                	mov    %eax,%edx
  1014b0:	ec                   	in     (%dx),%al
  1014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014b8:	0f b6 c0             	movzbl %al,%eax
  1014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014c2:	75 07                	jne    1014cb <serial_proc_data+0x56>
        c = '\b';
  1014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014ce:	c9                   	leave  
  1014cf:	c3                   	ret    

001014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014d0:	f3 0f 1e fb          	endbr32 
  1014d4:	55                   	push   %ebp
  1014d5:	89 e5                	mov    %esp,%ebp
  1014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014da:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1014df:	85 c0                	test   %eax,%eax
  1014e1:	74 0c                	je     1014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014e3:	c7 04 24 75 14 10 00 	movl   $0x101475,(%esp)
  1014ea:	e8 35 ff ff ff       	call   101424 <cons_intr>
    }
}
  1014ef:	90                   	nop
  1014f0:	c9                   	leave  
  1014f1:	c3                   	ret    

001014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014f2:	f3 0f 1e fb          	endbr32 
  1014f6:	55                   	push   %ebp
  1014f7:	89 e5                	mov    %esp,%ebp
  1014f9:	83 ec 38             	sub    $0x38,%esp
  1014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101505:	89 c2                	mov    %eax,%edx
  101507:	ec                   	in     (%dx),%al
  101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10150f:	0f b6 c0             	movzbl %al,%eax
  101512:	83 e0 01             	and    $0x1,%eax
  101515:	85 c0                	test   %eax,%eax
  101517:	75 0a                	jne    101523 <kbd_proc_data+0x31>
        return -1;
  101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10151e:	e9 56 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
  101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10152c:	89 c2                	mov    %eax,%edx
  10152e:	ec                   	in     (%dx),%al
  10152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10153d:	75 17                	jne    101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  10153f:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101544:	83 c8 40             	or     $0x40,%eax
  101547:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  10154c:	b8 00 00 00 00       	mov    $0x0,%eax
  101551:	e9 23 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155a:	84 c0                	test   %al,%al
  10155c:	79 45                	jns    1015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10155e:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101563:	83 e0 40             	and    $0x40,%eax
  101566:	85 c0                	test   %eax,%eax
  101568:	75 08                	jne    101572 <kbd_proc_data+0x80>
  10156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156e:	24 7f                	and    $0x7f,%al
  101570:	eb 04                	jmp    101576 <kbd_proc_data+0x84>
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157d:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101584:	0c 40                	or     $0x40,%al
  101586:	0f b6 c0             	movzbl %al,%eax
  101589:	f7 d0                	not    %eax
  10158b:	89 c2                	mov    %eax,%edx
  10158d:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101592:	21 d0                	and    %edx,%eax
  101594:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101599:	b8 00 00 00 00       	mov    $0x0,%eax
  10159e:	e9 d6 00 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015a3:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015a8:	83 e0 40             	and    $0x40,%eax
  1015ab:	85 c0                	test   %eax,%eax
  1015ad:	74 11                	je     1015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015b3:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b8:	83 e0 bf             	and    $0xffffffbf,%eax
  1015bb:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  1015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c4:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015cb:	0f b6 d0             	movzbl %al,%edx
  1015ce:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015d3:	09 d0                	or     %edx,%eax
  1015d5:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  1015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015de:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  1015e5:	0f b6 d0             	movzbl %al,%edx
  1015e8:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015ed:	31 d0                	xor    %edx,%eax
  1015ef:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015f4:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015f9:	83 e0 03             	and    $0x3,%eax
  1015fc:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101607:	01 d0                	add    %edx,%eax
  101609:	0f b6 00             	movzbl (%eax),%eax
  10160c:	0f b6 c0             	movzbl %al,%eax
  10160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101612:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101617:	83 e0 08             	and    $0x8,%eax
  10161a:	85 c0                	test   %eax,%eax
  10161c:	74 22                	je     101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101622:	7e 0c                	jle    101630 <kbd_proc_data+0x13e>
  101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101628:	7f 06                	jg     101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10162e:	eb 10                	jmp    101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101634:	7e 0a                	jle    101640 <kbd_proc_data+0x14e>
  101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10163a:	7f 04                	jg     101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101640:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101645:	f7 d0                	not    %eax
  101647:	83 e0 06             	and    $0x6,%eax
  10164a:	85 c0                	test   %eax,%eax
  10164c:	75 28                	jne    101676 <kbd_proc_data+0x184>
  10164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101655:	75 1f                	jne    101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101657:	c7 04 24 35 64 10 00 	movl   $0x106435,(%esp)
  10165e:	e8 57 ec ff ff       	call   1002ba <cprintf>
  101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
}
  101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101679:	c9                   	leave  
  10167a:	c3                   	ret    

0010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10167b:	f3 0f 1e fb          	endbr32 
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101685:	c7 04 24 f2 14 10 00 	movl   $0x1014f2,(%esp)
  10168c:	e8 93 fd ff ff       	call   101424 <cons_intr>
}
  101691:	90                   	nop
  101692:	c9                   	leave  
  101693:	c3                   	ret    

00101694 <kbd_init>:

static void
kbd_init(void) {
  101694:	f3 0f 1e fb          	endbr32 
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10169e:	e8 d8 ff ff ff       	call   10167b <kbd_intr>
    pic_enable(IRQ_KBD);
  1016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016aa:	e8 47 01 00 00       	call   1017f6 <pic_enable>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016b2:	f3 0f 1e fb          	endbr32 
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016bc:	e8 2e f8 ff ff       	call   100eef <cga_init>
    serial_init();
  1016c1:	e8 13 f9 ff ff       	call   100fd9 <serial_init>
    kbd_init();
  1016c6:	e8 c9 ff ff ff       	call   101694 <kbd_init>
    if (!serial_exists) {
  1016cb:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	75 0c                	jne    1016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016d4:	c7 04 24 41 64 10 00 	movl   $0x106441,(%esp)
  1016db:	e8 da eb ff ff       	call   1002ba <cprintf>
    }
}
  1016e0:	90                   	nop
  1016e1:	c9                   	leave  
  1016e2:	c3                   	ret    

001016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016e3:	f3 0f 1e fb          	endbr32 
  1016e7:	55                   	push   %ebp
  1016e8:	89 e5                	mov    %esp,%ebp
  1016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016ed:	e8 72 f7 ff ff       	call   100e64 <__intr_save>
  1016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f8:	89 04 24             	mov    %eax,(%esp)
  1016fb:	e8 48 fa ff ff       	call   101148 <lpt_putc>
        cga_putc(c);
  101700:	8b 45 08             	mov    0x8(%ebp),%eax
  101703:	89 04 24             	mov    %eax,(%esp)
  101706:	e8 81 fa ff ff       	call   10118c <cga_putc>
        serial_putc(c);
  10170b:	8b 45 08             	mov    0x8(%ebp),%eax
  10170e:	89 04 24             	mov    %eax,(%esp)
  101711:	e8 ca fc ff ff       	call   1013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101719:	89 04 24             	mov    %eax,(%esp)
  10171c:	e8 6d f7 ff ff       	call   100e8e <__intr_restore>
}
  101721:	90                   	nop
  101722:	c9                   	leave  
  101723:	c3                   	ret    

00101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101724:	f3 0f 1e fb          	endbr32 
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
  10172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101735:	e8 2a f7 ff ff       	call   100e64 <__intr_save>
  10173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10173d:	e8 8e fd ff ff       	call   1014d0 <serial_intr>
        kbd_intr();
  101742:	e8 34 ff ff ff       	call   10167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101747:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  10174d:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101752:	39 c2                	cmp    %eax,%edx
  101754:	74 31                	je     101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101756:	a1 60 c6 11 00       	mov    0x11c660,%eax
  10175b:	8d 50 01             	lea    0x1(%eax),%edx
  10175e:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  101764:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  10176b:	0f b6 c0             	movzbl %al,%eax
  10176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101771:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101776:	3d 00 02 00 00       	cmp    $0x200,%eax
  10177b:	75 0a                	jne    101787 <cons_getc+0x63>
                cons.rpos = 0;
  10177d:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10178a:	89 04 24             	mov    %eax,(%esp)
  10178d:	e8 fc f6 ff ff       	call   100e8e <__intr_restore>
    return c;
  101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101795:	c9                   	leave  
  101796:	c3                   	ret    

00101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101797:	f3 0f 1e fb          	endbr32 
  10179b:	55                   	push   %ebp
  10179c:	89 e5                	mov    %esp,%ebp
  10179e:	83 ec 14             	sub    $0x14,%esp
  1017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017ab:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1017b1:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1017b6:	85 c0                	test   %eax,%eax
  1017b8:	74 39                	je     1017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017bd:	0f b6 c0             	movzbl %al,%eax
  1017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017d1:	ee                   	out    %al,(%dx)
}
  1017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017d7:	c1 e8 08             	shr    $0x8,%eax
  1017da:	0f b7 c0             	movzwl %ax,%eax
  1017dd:	0f b6 c0             	movzbl %al,%eax
  1017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f1:	ee                   	out    %al,(%dx)
}
  1017f2:	90                   	nop
    }
}
  1017f3:	90                   	nop
  1017f4:	c9                   	leave  
  1017f5:	c3                   	ret    

001017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017f6:	f3 0f 1e fb          	endbr32 
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101800:	8b 45 08             	mov    0x8(%ebp),%eax
  101803:	ba 01 00 00 00       	mov    $0x1,%edx
  101808:	88 c1                	mov    %al,%cl
  10180a:	d3 e2                	shl    %cl,%edx
  10180c:	89 d0                	mov    %edx,%eax
  10180e:	98                   	cwtl   
  10180f:	f7 d0                	not    %eax
  101811:	0f bf d0             	movswl %ax,%edx
  101814:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10181b:	98                   	cwtl   
  10181c:	21 d0                	and    %edx,%eax
  10181e:	98                   	cwtl   
  10181f:	0f b7 c0             	movzwl %ax,%eax
  101822:	89 04 24             	mov    %eax,(%esp)
  101825:	e8 6d ff ff ff       	call   101797 <pic_setmask>
}
  10182a:	90                   	nop
  10182b:	c9                   	leave  
  10182c:	c3                   	ret    

0010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10182d:	f3 0f 1e fb          	endbr32 
  101831:	55                   	push   %ebp
  101832:	89 e5                	mov    %esp,%ebp
  101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101837:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  10183e:	00 00 00 
  101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
}
  101854:	90                   	nop
  101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101867:	ee                   	out    %al,(%dx)
}
  101868:	90                   	nop
  101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10187b:	ee                   	out    %al,(%dx)
}
  10187c:	90                   	nop
  10187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10188f:	ee                   	out    %al,(%dx)
}
  101890:	90                   	nop
  101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018a3:	ee                   	out    %al,(%dx)
}
  1018a4:	90                   	nop
  1018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018b7:	ee                   	out    %al,(%dx)
}
  1018b8:	90                   	nop
  1018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018cb:	ee                   	out    %al,(%dx)
}
  1018cc:	90                   	nop
  1018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018df:	ee                   	out    %al,(%dx)
}
  1018e0:	90                   	nop
  1018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018f3:	ee                   	out    %al,(%dx)
}
  1018f4:	90                   	nop
  1018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101907:	ee                   	out    %al,(%dx)
}
  101908:	90                   	nop
  101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10191b:	ee                   	out    %al,(%dx)
}
  10191c:	90                   	nop
  10191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10192f:	ee                   	out    %al,(%dx)
}
  101930:	90                   	nop
  101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101943:	ee                   	out    %al,(%dx)
}
  101944:	90                   	nop
  101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101957:	ee                   	out    %al,(%dx)
}
  101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101959:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101965:	74 0f                	je     101976 <pic_init+0x149>
        pic_setmask(irq_mask);
  101967:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10196e:	89 04 24             	mov    %eax,(%esp)
  101971:	e8 21 fe ff ff       	call   101797 <pic_setmask>
    }
}
  101976:	90                   	nop
  101977:	c9                   	leave  
  101978:	c3                   	ret    

00101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101979:	f3 0f 1e fb          	endbr32 
  10197d:	55                   	push   %ebp
  10197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101980:	fb                   	sti    
}
  101981:	90                   	nop
    sti();
}
  101982:	90                   	nop
  101983:	5d                   	pop    %ebp
  101984:	c3                   	ret    

00101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101985:	f3 0f 1e fb          	endbr32 
  101989:	55                   	push   %ebp
  10198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10198c:	fa                   	cli    
}
  10198d:	90                   	nop
    cli();
}
  10198e:	90                   	nop
  10198f:	5d                   	pop    %ebp
  101990:	c3                   	ret    

00101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101991:	f3 0f 1e fb          	endbr32 
  101995:	55                   	push   %ebp
  101996:	89 e5                	mov    %esp,%ebp
  101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1019a2:	00 
  1019a3:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  1019aa:	e8 0b e9 ff ff       	call   1002ba <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1019af:	90                   	nop
  1019b0:	c9                   	leave  
  1019b1:	c3                   	ret    

001019b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019b2:	f3 0f 1e fb          	endbr32 
  1019b6:	55                   	push   %ebp
  1019b7:	89 e5                	mov    %esp,%ebp
  1019b9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    //修正，这里面的256，应该是要idt的大小除以gatedesc的大小来判断有多少个段描述符
    for(int i=0 ; i< sizeof(idt)/sizeof(struct gatedesc) ; ++i){
  1019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019c3:	e9 c4 00 00 00       	jmp    101a8c <idt_init+0xda>
        SETGATE(idt[i],0,KERNEL_CS,__vectors[i],DPL_KERNEL);
  1019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cb:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  1019d2:	0f b7 d0             	movzwl %ax,%edx
  1019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d8:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  1019df:	00 
  1019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e3:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  1019ea:	00 08 00 
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019f7:	00 
  1019f8:	80 e2 e0             	and    $0xe0,%dl
  1019fb:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a0c:	00 
  101a0d:	80 e2 1f             	and    $0x1f,%dl
  101a10:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1a:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a21:	00 
  101a22:	80 e2 f0             	and    $0xf0,%dl
  101a25:	80 ca 0e             	or     $0xe,%dl
  101a28:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a39:	00 
  101a3a:	80 e2 ef             	and    $0xef,%dl
  101a3d:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a47:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a4e:	00 
  101a4f:	80 e2 9f             	and    $0x9f,%dl
  101a52:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5c:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a63:	00 
  101a64:	80 ca 80             	or     $0x80,%dl
  101a67:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a71:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a78:	c1 e8 10             	shr    $0x10,%eax
  101a7b:	0f b7 d0             	movzwl %ax,%edx
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a88:	00 
    for(int i=0 ; i< sizeof(idt)/sizeof(struct gatedesc) ; ++i){
  101a89:	ff 45 fc             	incl   -0x4(%ebp)
  101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a94:	0f 86 2e ff ff ff    	jbe    1019c8 <idt_init+0x16>
  101a9a:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aa4:	0f 01 18             	lidtl  (%eax)
}
  101aa7:	90                   	nop
    }
    //修正，这边加了一句对switch的更改，但是在任务中，我觉得没有表现出来
    //SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
    lidt(&idt_pd);
}
  101aa8:	90                   	nop
  101aa9:	c9                   	leave  
  101aaa:	c3                   	ret    

00101aab <trapname>:

static const char *
trapname(int trapno) {
  101aab:	f3 0f 1e fb          	endbr32 
  101aaf:	55                   	push   %ebp
  101ab0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	83 f8 13             	cmp    $0x13,%eax
  101ab8:	77 0c                	ja     101ac6 <trapname+0x1b>
        return excnames[trapno];
  101aba:	8b 45 08             	mov    0x8(%ebp),%eax
  101abd:	8b 04 85 c0 67 10 00 	mov    0x1067c0(,%eax,4),%eax
  101ac4:	eb 18                	jmp    101ade <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ac6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aca:	7e 0d                	jle    101ad9 <trapname+0x2e>
  101acc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ad0:	7f 07                	jg     101ad9 <trapname+0x2e>
        return "Hardware Interrupt";
  101ad2:	b8 6a 64 10 00       	mov    $0x10646a,%eax
  101ad7:	eb 05                	jmp    101ade <trapname+0x33>
    }
    return "(unknown trap)";
  101ad9:	b8 7d 64 10 00       	mov    $0x10647d,%eax
}
  101ade:	5d                   	pop    %ebp
  101adf:	c3                   	ret    

00101ae0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ae0:	f3 0f 1e fb          	endbr32 
  101ae4:	55                   	push   %ebp
  101ae5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aee:	83 f8 08             	cmp    $0x8,%eax
  101af1:	0f 94 c0             	sete   %al
  101af4:	0f b6 c0             	movzbl %al,%eax
}
  101af7:	5d                   	pop    %ebp
  101af8:	c3                   	ret    

00101af9 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101af9:	f3 0f 1e fb          	endbr32 
  101afd:	55                   	push   %ebp
  101afe:	89 e5                	mov    %esp,%ebp
  101b00:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0a:	c7 04 24 be 64 10 00 	movl   $0x1064be,(%esp)
  101b11:	e8 a4 e7 ff ff       	call   1002ba <cprintf>
    print_regs(&tf->tf_regs);
  101b16:	8b 45 08             	mov    0x8(%ebp),%eax
  101b19:	89 04 24             	mov    %eax,(%esp)
  101b1c:	e8 8d 01 00 00       	call   101cae <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2c:	c7 04 24 cf 64 10 00 	movl   $0x1064cf,(%esp)
  101b33:	e8 82 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b43:	c7 04 24 e2 64 10 00 	movl   $0x1064e2,(%esp)
  101b4a:	e8 6b e7 ff ff       	call   1002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 f5 64 10 00 	movl   $0x1064f5,(%esp)
  101b61:	e8 54 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b71:	c7 04 24 08 65 10 00 	movl   $0x106508,(%esp)
  101b78:	e8 3d e7 ff ff       	call   1002ba <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b80:	8b 40 30             	mov    0x30(%eax),%eax
  101b83:	89 04 24             	mov    %eax,(%esp)
  101b86:	e8 20 ff ff ff       	call   101aab <trapname>
  101b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  101b8e:	8b 52 30             	mov    0x30(%edx),%edx
  101b91:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b95:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b99:	c7 04 24 1b 65 10 00 	movl   $0x10651b,(%esp)
  101ba0:	e8 15 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	8b 40 34             	mov    0x34(%eax),%eax
  101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baf:	c7 04 24 2d 65 10 00 	movl   $0x10652d,(%esp)
  101bb6:	e8 ff e6 ff ff       	call   1002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 38             	mov    0x38(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 3c 65 10 00 	movl   $0x10653c,(%esp)
  101bcc:	e8 e9 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  101be3:	e8 d2 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 40             	mov    0x40(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 5e 65 10 00 	movl   $0x10655e,(%esp)
  101bf9:	e8 bc e6 ff ff       	call   1002ba <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c0c:	eb 3d                	jmp    101c4b <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 50 40             	mov    0x40(%eax),%edx
  101c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c17:	21 d0                	and    %edx,%eax
  101c19:	85 c0                	test   %eax,%eax
  101c1b:	74 28                	je     101c45 <print_trapframe+0x14c>
  101c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c20:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c27:	85 c0                	test   %eax,%eax
  101c29:	74 1a                	je     101c45 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c2e:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	c7 04 24 6d 65 10 00 	movl   $0x10656d,(%esp)
  101c40:	e8 75 e6 ff ff       	call   1002ba <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c45:	ff 45 f4             	incl   -0xc(%ebp)
  101c48:	d1 65 f0             	shll   -0x10(%ebp)
  101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4e:	83 f8 17             	cmp    $0x17,%eax
  101c51:	76 bb                	jbe    101c0e <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 40             	mov    0x40(%eax),%eax
  101c59:	c1 e8 0c             	shr    $0xc,%eax
  101c5c:	83 e0 03             	and    $0x3,%eax
  101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c63:	c7 04 24 71 65 10 00 	movl   $0x106571,(%esp)
  101c6a:	e8 4b e6 ff ff       	call   1002ba <cprintf>

    if (!trap_in_kernel(tf)) {
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	89 04 24             	mov    %eax,(%esp)
  101c75:	e8 66 fe ff ff       	call   101ae0 <trap_in_kernel>
  101c7a:	85 c0                	test   %eax,%eax
  101c7c:	75 2d                	jne    101cab <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c81:	8b 40 44             	mov    0x44(%eax),%eax
  101c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c88:	c7 04 24 7a 65 10 00 	movl   $0x10657a,(%esp)
  101c8f:	e8 26 e6 ff ff       	call   1002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9f:	c7 04 24 89 65 10 00 	movl   $0x106589,(%esp)
  101ca6:	e8 0f e6 ff ff       	call   1002ba <cprintf>
    }
}
  101cab:	90                   	nop
  101cac:	c9                   	leave  
  101cad:	c3                   	ret    

00101cae <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cae:	f3 0f 1e fb          	endbr32 
  101cb2:	55                   	push   %ebp
  101cb3:	89 e5                	mov    %esp,%ebp
  101cb5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbb:	8b 00                	mov    (%eax),%eax
  101cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc1:	c7 04 24 9c 65 10 00 	movl   $0x10659c,(%esp)
  101cc8:	e8 ed e5 ff ff       	call   1002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd0:	8b 40 04             	mov    0x4(%eax),%eax
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  101cde:	e8 d7 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 40 08             	mov    0x8(%eax),%eax
  101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ced:	c7 04 24 ba 65 10 00 	movl   $0x1065ba,(%esp)
  101cf4:	e8 c1 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 c9 65 10 00 	movl   $0x1065c9,(%esp)
  101d0a:	e8 ab e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d12:	8b 40 10             	mov    0x10(%eax),%eax
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 d8 65 10 00 	movl   $0x1065d8,(%esp)
  101d20:	e8 95 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d25:	8b 45 08             	mov    0x8(%ebp),%eax
  101d28:	8b 40 14             	mov    0x14(%eax),%eax
  101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2f:	c7 04 24 e7 65 10 00 	movl   $0x1065e7,(%esp)
  101d36:	e8 7f e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 40 18             	mov    0x18(%eax),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 f6 65 10 00 	movl   $0x1065f6,(%esp)
  101d4c:	e8 69 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 05 66 10 00 	movl   $0x106605,(%esp)
  101d62:	e8 53 e5 ff ff       	call   1002ba <cprintf>
}
  101d67:	90                   	nop
  101d68:	c9                   	leave  
  101d69:	c3                   	ret    

00101d6a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d6a:	f3 0f 1e fb          	endbr32 
  101d6e:	55                   	push   %ebp
  101d6f:	89 e5                	mov    %esp,%ebp
  101d71:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d74:	8b 45 08             	mov    0x8(%ebp),%eax
  101d77:	8b 40 30             	mov    0x30(%eax),%eax
  101d7a:	83 f8 79             	cmp    $0x79,%eax
  101d7d:	0f 87 e6 00 00 00    	ja     101e69 <trap_dispatch+0xff>
  101d83:	83 f8 78             	cmp    $0x78,%eax
  101d86:	0f 83 c1 00 00 00    	jae    101e4d <trap_dispatch+0xe3>
  101d8c:	83 f8 2f             	cmp    $0x2f,%eax
  101d8f:	0f 87 d4 00 00 00    	ja     101e69 <trap_dispatch+0xff>
  101d95:	83 f8 2e             	cmp    $0x2e,%eax
  101d98:	0f 83 00 01 00 00    	jae    101e9e <trap_dispatch+0x134>
  101d9e:	83 f8 24             	cmp    $0x24,%eax
  101da1:	74 5e                	je     101e01 <trap_dispatch+0x97>
  101da3:	83 f8 24             	cmp    $0x24,%eax
  101da6:	0f 87 bd 00 00 00    	ja     101e69 <trap_dispatch+0xff>
  101dac:	83 f8 20             	cmp    $0x20,%eax
  101daf:	74 0a                	je     101dbb <trap_dispatch+0x51>
  101db1:	83 f8 21             	cmp    $0x21,%eax
  101db4:	74 71                	je     101e27 <trap_dispatch+0xbd>
  101db6:	e9 ae 00 00 00       	jmp    101e69 <trap_dispatch+0xff>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101dbb:	a1 0c cf 11 00       	mov    0x11cf0c,%eax
  101dc0:	40                   	inc    %eax
  101dc1:	a3 0c cf 11 00       	mov    %eax,0x11cf0c
        if(ticks%TICK_NUM==0)
  101dc6:	8b 0d 0c cf 11 00    	mov    0x11cf0c,%ecx
  101dcc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101dd1:	89 c8                	mov    %ecx,%eax
  101dd3:	f7 e2                	mul    %edx
  101dd5:	c1 ea 05             	shr    $0x5,%edx
  101dd8:	89 d0                	mov    %edx,%eax
  101dda:	c1 e0 02             	shl    $0x2,%eax
  101ddd:	01 d0                	add    %edx,%eax
  101ddf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101de6:	01 d0                	add    %edx,%eax
  101de8:	c1 e0 02             	shl    $0x2,%eax
  101deb:	29 c1                	sub    %eax,%ecx
  101ded:	89 ca                	mov    %ecx,%edx
  101def:	85 d2                	test   %edx,%edx
  101df1:	0f 85 aa 00 00 00    	jne    101ea1 <trap_dispatch+0x137>
            print_ticks();
  101df7:	e8 95 fb ff ff       	call   101991 <print_ticks>
        break;
  101dfc:	e9 a0 00 00 00       	jmp    101ea1 <trap_dispatch+0x137>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e01:	e8 1e f9 ff ff       	call   101724 <cons_getc>
  101e06:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e09:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e0d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e11:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e19:	c7 04 24 14 66 10 00 	movl   $0x106614,(%esp)
  101e20:	e8 95 e4 ff ff       	call   1002ba <cprintf>
        break;
  101e25:	eb 7b                	jmp    101ea2 <trap_dispatch+0x138>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e27:	e8 f8 f8 ff ff       	call   101724 <cons_getc>
  101e2c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e2f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e33:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e37:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e3f:	c7 04 24 26 66 10 00 	movl   $0x106626,(%esp)
  101e46:	e8 6f e4 ff ff       	call   1002ba <cprintf>
        break;
  101e4b:	eb 55                	jmp    101ea2 <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e4d:	c7 44 24 08 35 66 10 	movl   $0x106635,0x8(%esp)
  101e54:	00 
  101e55:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101e5c:	00 
  101e5d:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
  101e64:	e8 bd e5 ff ff       	call   100426 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e70:	83 e0 03             	and    $0x3,%eax
  101e73:	85 c0                	test   %eax,%eax
  101e75:	75 2b                	jne    101ea2 <trap_dispatch+0x138>
            print_trapframe(tf);
  101e77:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7a:	89 04 24             	mov    %eax,(%esp)
  101e7d:	e8 77 fc ff ff       	call   101af9 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e82:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  101e89:	00 
  101e8a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101e91:	00 
  101e92:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
  101e99:	e8 88 e5 ff ff       	call   100426 <__panic>
        break;
  101e9e:	90                   	nop
  101e9f:	eb 01                	jmp    101ea2 <trap_dispatch+0x138>
        break;
  101ea1:	90                   	nop
        }
    }
}
  101ea2:	90                   	nop
  101ea3:	c9                   	leave  
  101ea4:	c3                   	ret    

00101ea5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ea5:	f3 0f 1e fb          	endbr32 
  101ea9:	55                   	push   %ebp
  101eaa:	89 e5                	mov    %esp,%ebp
  101eac:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb2:	89 04 24             	mov    %eax,(%esp)
  101eb5:	e8 b0 fe ff ff       	call   101d6a <trap_dispatch>
}
  101eba:	90                   	nop
  101ebb:	c9                   	leave  
  101ebc:	c3                   	ret    

00101ebd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $0
  101ebf:	6a 00                	push   $0x0
  jmp __alltraps
  101ec1:	e9 69 0a 00 00       	jmp    10292f <__alltraps>

00101ec6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $1
  101ec8:	6a 01                	push   $0x1
  jmp __alltraps
  101eca:	e9 60 0a 00 00       	jmp    10292f <__alltraps>

00101ecf <vector2>:
.globl vector2
vector2:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $2
  101ed1:	6a 02                	push   $0x2
  jmp __alltraps
  101ed3:	e9 57 0a 00 00       	jmp    10292f <__alltraps>

00101ed8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $3
  101eda:	6a 03                	push   $0x3
  jmp __alltraps
  101edc:	e9 4e 0a 00 00       	jmp    10292f <__alltraps>

00101ee1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $4
  101ee3:	6a 04                	push   $0x4
  jmp __alltraps
  101ee5:	e9 45 0a 00 00       	jmp    10292f <__alltraps>

00101eea <vector5>:
.globl vector5
vector5:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $5
  101eec:	6a 05                	push   $0x5
  jmp __alltraps
  101eee:	e9 3c 0a 00 00       	jmp    10292f <__alltraps>

00101ef3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $6
  101ef5:	6a 06                	push   $0x6
  jmp __alltraps
  101ef7:	e9 33 0a 00 00       	jmp    10292f <__alltraps>

00101efc <vector7>:
.globl vector7
vector7:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $7
  101efe:	6a 07                	push   $0x7
  jmp __alltraps
  101f00:	e9 2a 0a 00 00       	jmp    10292f <__alltraps>

00101f05 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f05:	6a 08                	push   $0x8
  jmp __alltraps
  101f07:	e9 23 0a 00 00       	jmp    10292f <__alltraps>

00101f0c <vector9>:
.globl vector9
vector9:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $9
  101f0e:	6a 09                	push   $0x9
  jmp __alltraps
  101f10:	e9 1a 0a 00 00       	jmp    10292f <__alltraps>

00101f15 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f15:	6a 0a                	push   $0xa
  jmp __alltraps
  101f17:	e9 13 0a 00 00       	jmp    10292f <__alltraps>

00101f1c <vector11>:
.globl vector11
vector11:
  pushl $11
  101f1c:	6a 0b                	push   $0xb
  jmp __alltraps
  101f1e:	e9 0c 0a 00 00       	jmp    10292f <__alltraps>

00101f23 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f23:	6a 0c                	push   $0xc
  jmp __alltraps
  101f25:	e9 05 0a 00 00       	jmp    10292f <__alltraps>

00101f2a <vector13>:
.globl vector13
vector13:
  pushl $13
  101f2a:	6a 0d                	push   $0xd
  jmp __alltraps
  101f2c:	e9 fe 09 00 00       	jmp    10292f <__alltraps>

00101f31 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f31:	6a 0e                	push   $0xe
  jmp __alltraps
  101f33:	e9 f7 09 00 00       	jmp    10292f <__alltraps>

00101f38 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $15
  101f3a:	6a 0f                	push   $0xf
  jmp __alltraps
  101f3c:	e9 ee 09 00 00       	jmp    10292f <__alltraps>

00101f41 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $16
  101f43:	6a 10                	push   $0x10
  jmp __alltraps
  101f45:	e9 e5 09 00 00       	jmp    10292f <__alltraps>

00101f4a <vector17>:
.globl vector17
vector17:
  pushl $17
  101f4a:	6a 11                	push   $0x11
  jmp __alltraps
  101f4c:	e9 de 09 00 00       	jmp    10292f <__alltraps>

00101f51 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $18
  101f53:	6a 12                	push   $0x12
  jmp __alltraps
  101f55:	e9 d5 09 00 00       	jmp    10292f <__alltraps>

00101f5a <vector19>:
.globl vector19
vector19:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $19
  101f5c:	6a 13                	push   $0x13
  jmp __alltraps
  101f5e:	e9 cc 09 00 00       	jmp    10292f <__alltraps>

00101f63 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $20
  101f65:	6a 14                	push   $0x14
  jmp __alltraps
  101f67:	e9 c3 09 00 00       	jmp    10292f <__alltraps>

00101f6c <vector21>:
.globl vector21
vector21:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $21
  101f6e:	6a 15                	push   $0x15
  jmp __alltraps
  101f70:	e9 ba 09 00 00       	jmp    10292f <__alltraps>

00101f75 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $22
  101f77:	6a 16                	push   $0x16
  jmp __alltraps
  101f79:	e9 b1 09 00 00       	jmp    10292f <__alltraps>

00101f7e <vector23>:
.globl vector23
vector23:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $23
  101f80:	6a 17                	push   $0x17
  jmp __alltraps
  101f82:	e9 a8 09 00 00       	jmp    10292f <__alltraps>

00101f87 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $24
  101f89:	6a 18                	push   $0x18
  jmp __alltraps
  101f8b:	e9 9f 09 00 00       	jmp    10292f <__alltraps>

00101f90 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $25
  101f92:	6a 19                	push   $0x19
  jmp __alltraps
  101f94:	e9 96 09 00 00       	jmp    10292f <__alltraps>

00101f99 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $26
  101f9b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f9d:	e9 8d 09 00 00       	jmp    10292f <__alltraps>

00101fa2 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $27
  101fa4:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fa6:	e9 84 09 00 00       	jmp    10292f <__alltraps>

00101fab <vector28>:
.globl vector28
vector28:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $28
  101fad:	6a 1c                	push   $0x1c
  jmp __alltraps
  101faf:	e9 7b 09 00 00       	jmp    10292f <__alltraps>

00101fb4 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $29
  101fb6:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fb8:	e9 72 09 00 00       	jmp    10292f <__alltraps>

00101fbd <vector30>:
.globl vector30
vector30:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $30
  101fbf:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fc1:	e9 69 09 00 00       	jmp    10292f <__alltraps>

00101fc6 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $31
  101fc8:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fca:	e9 60 09 00 00       	jmp    10292f <__alltraps>

00101fcf <vector32>:
.globl vector32
vector32:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $32
  101fd1:	6a 20                	push   $0x20
  jmp __alltraps
  101fd3:	e9 57 09 00 00       	jmp    10292f <__alltraps>

00101fd8 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $33
  101fda:	6a 21                	push   $0x21
  jmp __alltraps
  101fdc:	e9 4e 09 00 00       	jmp    10292f <__alltraps>

00101fe1 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $34
  101fe3:	6a 22                	push   $0x22
  jmp __alltraps
  101fe5:	e9 45 09 00 00       	jmp    10292f <__alltraps>

00101fea <vector35>:
.globl vector35
vector35:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $35
  101fec:	6a 23                	push   $0x23
  jmp __alltraps
  101fee:	e9 3c 09 00 00       	jmp    10292f <__alltraps>

00101ff3 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $36
  101ff5:	6a 24                	push   $0x24
  jmp __alltraps
  101ff7:	e9 33 09 00 00       	jmp    10292f <__alltraps>

00101ffc <vector37>:
.globl vector37
vector37:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $37
  101ffe:	6a 25                	push   $0x25
  jmp __alltraps
  102000:	e9 2a 09 00 00       	jmp    10292f <__alltraps>

00102005 <vector38>:
.globl vector38
vector38:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $38
  102007:	6a 26                	push   $0x26
  jmp __alltraps
  102009:	e9 21 09 00 00       	jmp    10292f <__alltraps>

0010200e <vector39>:
.globl vector39
vector39:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $39
  102010:	6a 27                	push   $0x27
  jmp __alltraps
  102012:	e9 18 09 00 00       	jmp    10292f <__alltraps>

00102017 <vector40>:
.globl vector40
vector40:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $40
  102019:	6a 28                	push   $0x28
  jmp __alltraps
  10201b:	e9 0f 09 00 00       	jmp    10292f <__alltraps>

00102020 <vector41>:
.globl vector41
vector41:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $41
  102022:	6a 29                	push   $0x29
  jmp __alltraps
  102024:	e9 06 09 00 00       	jmp    10292f <__alltraps>

00102029 <vector42>:
.globl vector42
vector42:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $42
  10202b:	6a 2a                	push   $0x2a
  jmp __alltraps
  10202d:	e9 fd 08 00 00       	jmp    10292f <__alltraps>

00102032 <vector43>:
.globl vector43
vector43:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $43
  102034:	6a 2b                	push   $0x2b
  jmp __alltraps
  102036:	e9 f4 08 00 00       	jmp    10292f <__alltraps>

0010203b <vector44>:
.globl vector44
vector44:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $44
  10203d:	6a 2c                	push   $0x2c
  jmp __alltraps
  10203f:	e9 eb 08 00 00       	jmp    10292f <__alltraps>

00102044 <vector45>:
.globl vector45
vector45:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $45
  102046:	6a 2d                	push   $0x2d
  jmp __alltraps
  102048:	e9 e2 08 00 00       	jmp    10292f <__alltraps>

0010204d <vector46>:
.globl vector46
vector46:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $46
  10204f:	6a 2e                	push   $0x2e
  jmp __alltraps
  102051:	e9 d9 08 00 00       	jmp    10292f <__alltraps>

00102056 <vector47>:
.globl vector47
vector47:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $47
  102058:	6a 2f                	push   $0x2f
  jmp __alltraps
  10205a:	e9 d0 08 00 00       	jmp    10292f <__alltraps>

0010205f <vector48>:
.globl vector48
vector48:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $48
  102061:	6a 30                	push   $0x30
  jmp __alltraps
  102063:	e9 c7 08 00 00       	jmp    10292f <__alltraps>

00102068 <vector49>:
.globl vector49
vector49:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $49
  10206a:	6a 31                	push   $0x31
  jmp __alltraps
  10206c:	e9 be 08 00 00       	jmp    10292f <__alltraps>

00102071 <vector50>:
.globl vector50
vector50:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $50
  102073:	6a 32                	push   $0x32
  jmp __alltraps
  102075:	e9 b5 08 00 00       	jmp    10292f <__alltraps>

0010207a <vector51>:
.globl vector51
vector51:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $51
  10207c:	6a 33                	push   $0x33
  jmp __alltraps
  10207e:	e9 ac 08 00 00       	jmp    10292f <__alltraps>

00102083 <vector52>:
.globl vector52
vector52:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $52
  102085:	6a 34                	push   $0x34
  jmp __alltraps
  102087:	e9 a3 08 00 00       	jmp    10292f <__alltraps>

0010208c <vector53>:
.globl vector53
vector53:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $53
  10208e:	6a 35                	push   $0x35
  jmp __alltraps
  102090:	e9 9a 08 00 00       	jmp    10292f <__alltraps>

00102095 <vector54>:
.globl vector54
vector54:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $54
  102097:	6a 36                	push   $0x36
  jmp __alltraps
  102099:	e9 91 08 00 00       	jmp    10292f <__alltraps>

0010209e <vector55>:
.globl vector55
vector55:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $55
  1020a0:	6a 37                	push   $0x37
  jmp __alltraps
  1020a2:	e9 88 08 00 00       	jmp    10292f <__alltraps>

001020a7 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $56
  1020a9:	6a 38                	push   $0x38
  jmp __alltraps
  1020ab:	e9 7f 08 00 00       	jmp    10292f <__alltraps>

001020b0 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $57
  1020b2:	6a 39                	push   $0x39
  jmp __alltraps
  1020b4:	e9 76 08 00 00       	jmp    10292f <__alltraps>

001020b9 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $58
  1020bb:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020bd:	e9 6d 08 00 00       	jmp    10292f <__alltraps>

001020c2 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $59
  1020c4:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020c6:	e9 64 08 00 00       	jmp    10292f <__alltraps>

001020cb <vector60>:
.globl vector60
vector60:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $60
  1020cd:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020cf:	e9 5b 08 00 00       	jmp    10292f <__alltraps>

001020d4 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $61
  1020d6:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020d8:	e9 52 08 00 00       	jmp    10292f <__alltraps>

001020dd <vector62>:
.globl vector62
vector62:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $62
  1020df:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020e1:	e9 49 08 00 00       	jmp    10292f <__alltraps>

001020e6 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $63
  1020e8:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020ea:	e9 40 08 00 00       	jmp    10292f <__alltraps>

001020ef <vector64>:
.globl vector64
vector64:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $64
  1020f1:	6a 40                	push   $0x40
  jmp __alltraps
  1020f3:	e9 37 08 00 00       	jmp    10292f <__alltraps>

001020f8 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $65
  1020fa:	6a 41                	push   $0x41
  jmp __alltraps
  1020fc:	e9 2e 08 00 00       	jmp    10292f <__alltraps>

00102101 <vector66>:
.globl vector66
vector66:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $66
  102103:	6a 42                	push   $0x42
  jmp __alltraps
  102105:	e9 25 08 00 00       	jmp    10292f <__alltraps>

0010210a <vector67>:
.globl vector67
vector67:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $67
  10210c:	6a 43                	push   $0x43
  jmp __alltraps
  10210e:	e9 1c 08 00 00       	jmp    10292f <__alltraps>

00102113 <vector68>:
.globl vector68
vector68:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $68
  102115:	6a 44                	push   $0x44
  jmp __alltraps
  102117:	e9 13 08 00 00       	jmp    10292f <__alltraps>

0010211c <vector69>:
.globl vector69
vector69:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $69
  10211e:	6a 45                	push   $0x45
  jmp __alltraps
  102120:	e9 0a 08 00 00       	jmp    10292f <__alltraps>

00102125 <vector70>:
.globl vector70
vector70:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $70
  102127:	6a 46                	push   $0x46
  jmp __alltraps
  102129:	e9 01 08 00 00       	jmp    10292f <__alltraps>

0010212e <vector71>:
.globl vector71
vector71:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $71
  102130:	6a 47                	push   $0x47
  jmp __alltraps
  102132:	e9 f8 07 00 00       	jmp    10292f <__alltraps>

00102137 <vector72>:
.globl vector72
vector72:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $72
  102139:	6a 48                	push   $0x48
  jmp __alltraps
  10213b:	e9 ef 07 00 00       	jmp    10292f <__alltraps>

00102140 <vector73>:
.globl vector73
vector73:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $73
  102142:	6a 49                	push   $0x49
  jmp __alltraps
  102144:	e9 e6 07 00 00       	jmp    10292f <__alltraps>

00102149 <vector74>:
.globl vector74
vector74:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $74
  10214b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10214d:	e9 dd 07 00 00       	jmp    10292f <__alltraps>

00102152 <vector75>:
.globl vector75
vector75:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $75
  102154:	6a 4b                	push   $0x4b
  jmp __alltraps
  102156:	e9 d4 07 00 00       	jmp    10292f <__alltraps>

0010215b <vector76>:
.globl vector76
vector76:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $76
  10215d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10215f:	e9 cb 07 00 00       	jmp    10292f <__alltraps>

00102164 <vector77>:
.globl vector77
vector77:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $77
  102166:	6a 4d                	push   $0x4d
  jmp __alltraps
  102168:	e9 c2 07 00 00       	jmp    10292f <__alltraps>

0010216d <vector78>:
.globl vector78
vector78:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $78
  10216f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102171:	e9 b9 07 00 00       	jmp    10292f <__alltraps>

00102176 <vector79>:
.globl vector79
vector79:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $79
  102178:	6a 4f                	push   $0x4f
  jmp __alltraps
  10217a:	e9 b0 07 00 00       	jmp    10292f <__alltraps>

0010217f <vector80>:
.globl vector80
vector80:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $80
  102181:	6a 50                	push   $0x50
  jmp __alltraps
  102183:	e9 a7 07 00 00       	jmp    10292f <__alltraps>

00102188 <vector81>:
.globl vector81
vector81:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $81
  10218a:	6a 51                	push   $0x51
  jmp __alltraps
  10218c:	e9 9e 07 00 00       	jmp    10292f <__alltraps>

00102191 <vector82>:
.globl vector82
vector82:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $82
  102193:	6a 52                	push   $0x52
  jmp __alltraps
  102195:	e9 95 07 00 00       	jmp    10292f <__alltraps>

0010219a <vector83>:
.globl vector83
vector83:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $83
  10219c:	6a 53                	push   $0x53
  jmp __alltraps
  10219e:	e9 8c 07 00 00       	jmp    10292f <__alltraps>

001021a3 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $84
  1021a5:	6a 54                	push   $0x54
  jmp __alltraps
  1021a7:	e9 83 07 00 00       	jmp    10292f <__alltraps>

001021ac <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $85
  1021ae:	6a 55                	push   $0x55
  jmp __alltraps
  1021b0:	e9 7a 07 00 00       	jmp    10292f <__alltraps>

001021b5 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $86
  1021b7:	6a 56                	push   $0x56
  jmp __alltraps
  1021b9:	e9 71 07 00 00       	jmp    10292f <__alltraps>

001021be <vector87>:
.globl vector87
vector87:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $87
  1021c0:	6a 57                	push   $0x57
  jmp __alltraps
  1021c2:	e9 68 07 00 00       	jmp    10292f <__alltraps>

001021c7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $88
  1021c9:	6a 58                	push   $0x58
  jmp __alltraps
  1021cb:	e9 5f 07 00 00       	jmp    10292f <__alltraps>

001021d0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $89
  1021d2:	6a 59                	push   $0x59
  jmp __alltraps
  1021d4:	e9 56 07 00 00       	jmp    10292f <__alltraps>

001021d9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $90
  1021db:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021dd:	e9 4d 07 00 00       	jmp    10292f <__alltraps>

001021e2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $91
  1021e4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021e6:	e9 44 07 00 00       	jmp    10292f <__alltraps>

001021eb <vector92>:
.globl vector92
vector92:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $92
  1021ed:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021ef:	e9 3b 07 00 00       	jmp    10292f <__alltraps>

001021f4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $93
  1021f6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021f8:	e9 32 07 00 00       	jmp    10292f <__alltraps>

001021fd <vector94>:
.globl vector94
vector94:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $94
  1021ff:	6a 5e                	push   $0x5e
  jmp __alltraps
  102201:	e9 29 07 00 00       	jmp    10292f <__alltraps>

00102206 <vector95>:
.globl vector95
vector95:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $95
  102208:	6a 5f                	push   $0x5f
  jmp __alltraps
  10220a:	e9 20 07 00 00       	jmp    10292f <__alltraps>

0010220f <vector96>:
.globl vector96
vector96:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $96
  102211:	6a 60                	push   $0x60
  jmp __alltraps
  102213:	e9 17 07 00 00       	jmp    10292f <__alltraps>

00102218 <vector97>:
.globl vector97
vector97:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $97
  10221a:	6a 61                	push   $0x61
  jmp __alltraps
  10221c:	e9 0e 07 00 00       	jmp    10292f <__alltraps>

00102221 <vector98>:
.globl vector98
vector98:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $98
  102223:	6a 62                	push   $0x62
  jmp __alltraps
  102225:	e9 05 07 00 00       	jmp    10292f <__alltraps>

0010222a <vector99>:
.globl vector99
vector99:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $99
  10222c:	6a 63                	push   $0x63
  jmp __alltraps
  10222e:	e9 fc 06 00 00       	jmp    10292f <__alltraps>

00102233 <vector100>:
.globl vector100
vector100:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $100
  102235:	6a 64                	push   $0x64
  jmp __alltraps
  102237:	e9 f3 06 00 00       	jmp    10292f <__alltraps>

0010223c <vector101>:
.globl vector101
vector101:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $101
  10223e:	6a 65                	push   $0x65
  jmp __alltraps
  102240:	e9 ea 06 00 00       	jmp    10292f <__alltraps>

00102245 <vector102>:
.globl vector102
vector102:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $102
  102247:	6a 66                	push   $0x66
  jmp __alltraps
  102249:	e9 e1 06 00 00       	jmp    10292f <__alltraps>

0010224e <vector103>:
.globl vector103
vector103:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $103
  102250:	6a 67                	push   $0x67
  jmp __alltraps
  102252:	e9 d8 06 00 00       	jmp    10292f <__alltraps>

00102257 <vector104>:
.globl vector104
vector104:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $104
  102259:	6a 68                	push   $0x68
  jmp __alltraps
  10225b:	e9 cf 06 00 00       	jmp    10292f <__alltraps>

00102260 <vector105>:
.globl vector105
vector105:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $105
  102262:	6a 69                	push   $0x69
  jmp __alltraps
  102264:	e9 c6 06 00 00       	jmp    10292f <__alltraps>

00102269 <vector106>:
.globl vector106
vector106:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $106
  10226b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10226d:	e9 bd 06 00 00       	jmp    10292f <__alltraps>

00102272 <vector107>:
.globl vector107
vector107:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $107
  102274:	6a 6b                	push   $0x6b
  jmp __alltraps
  102276:	e9 b4 06 00 00       	jmp    10292f <__alltraps>

0010227b <vector108>:
.globl vector108
vector108:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $108
  10227d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10227f:	e9 ab 06 00 00       	jmp    10292f <__alltraps>

00102284 <vector109>:
.globl vector109
vector109:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $109
  102286:	6a 6d                	push   $0x6d
  jmp __alltraps
  102288:	e9 a2 06 00 00       	jmp    10292f <__alltraps>

0010228d <vector110>:
.globl vector110
vector110:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $110
  10228f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102291:	e9 99 06 00 00       	jmp    10292f <__alltraps>

00102296 <vector111>:
.globl vector111
vector111:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $111
  102298:	6a 6f                	push   $0x6f
  jmp __alltraps
  10229a:	e9 90 06 00 00       	jmp    10292f <__alltraps>

0010229f <vector112>:
.globl vector112
vector112:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $112
  1022a1:	6a 70                	push   $0x70
  jmp __alltraps
  1022a3:	e9 87 06 00 00       	jmp    10292f <__alltraps>

001022a8 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $113
  1022aa:	6a 71                	push   $0x71
  jmp __alltraps
  1022ac:	e9 7e 06 00 00       	jmp    10292f <__alltraps>

001022b1 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $114
  1022b3:	6a 72                	push   $0x72
  jmp __alltraps
  1022b5:	e9 75 06 00 00       	jmp    10292f <__alltraps>

001022ba <vector115>:
.globl vector115
vector115:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $115
  1022bc:	6a 73                	push   $0x73
  jmp __alltraps
  1022be:	e9 6c 06 00 00       	jmp    10292f <__alltraps>

001022c3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $116
  1022c5:	6a 74                	push   $0x74
  jmp __alltraps
  1022c7:	e9 63 06 00 00       	jmp    10292f <__alltraps>

001022cc <vector117>:
.globl vector117
vector117:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $117
  1022ce:	6a 75                	push   $0x75
  jmp __alltraps
  1022d0:	e9 5a 06 00 00       	jmp    10292f <__alltraps>

001022d5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $118
  1022d7:	6a 76                	push   $0x76
  jmp __alltraps
  1022d9:	e9 51 06 00 00       	jmp    10292f <__alltraps>

001022de <vector119>:
.globl vector119
vector119:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $119
  1022e0:	6a 77                	push   $0x77
  jmp __alltraps
  1022e2:	e9 48 06 00 00       	jmp    10292f <__alltraps>

001022e7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $120
  1022e9:	6a 78                	push   $0x78
  jmp __alltraps
  1022eb:	e9 3f 06 00 00       	jmp    10292f <__alltraps>

001022f0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $121
  1022f2:	6a 79                	push   $0x79
  jmp __alltraps
  1022f4:	e9 36 06 00 00       	jmp    10292f <__alltraps>

001022f9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $122
  1022fb:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022fd:	e9 2d 06 00 00       	jmp    10292f <__alltraps>

00102302 <vector123>:
.globl vector123
vector123:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $123
  102304:	6a 7b                	push   $0x7b
  jmp __alltraps
  102306:	e9 24 06 00 00       	jmp    10292f <__alltraps>

0010230b <vector124>:
.globl vector124
vector124:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $124
  10230d:	6a 7c                	push   $0x7c
  jmp __alltraps
  10230f:	e9 1b 06 00 00       	jmp    10292f <__alltraps>

00102314 <vector125>:
.globl vector125
vector125:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $125
  102316:	6a 7d                	push   $0x7d
  jmp __alltraps
  102318:	e9 12 06 00 00       	jmp    10292f <__alltraps>

0010231d <vector126>:
.globl vector126
vector126:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $126
  10231f:	6a 7e                	push   $0x7e
  jmp __alltraps
  102321:	e9 09 06 00 00       	jmp    10292f <__alltraps>

00102326 <vector127>:
.globl vector127
vector127:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $127
  102328:	6a 7f                	push   $0x7f
  jmp __alltraps
  10232a:	e9 00 06 00 00       	jmp    10292f <__alltraps>

0010232f <vector128>:
.globl vector128
vector128:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $128
  102331:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102336:	e9 f4 05 00 00       	jmp    10292f <__alltraps>

0010233b <vector129>:
.globl vector129
vector129:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $129
  10233d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102342:	e9 e8 05 00 00       	jmp    10292f <__alltraps>

00102347 <vector130>:
.globl vector130
vector130:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $130
  102349:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10234e:	e9 dc 05 00 00       	jmp    10292f <__alltraps>

00102353 <vector131>:
.globl vector131
vector131:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $131
  102355:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10235a:	e9 d0 05 00 00       	jmp    10292f <__alltraps>

0010235f <vector132>:
.globl vector132
vector132:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $132
  102361:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102366:	e9 c4 05 00 00       	jmp    10292f <__alltraps>

0010236b <vector133>:
.globl vector133
vector133:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $133
  10236d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102372:	e9 b8 05 00 00       	jmp    10292f <__alltraps>

00102377 <vector134>:
.globl vector134
vector134:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $134
  102379:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10237e:	e9 ac 05 00 00       	jmp    10292f <__alltraps>

00102383 <vector135>:
.globl vector135
vector135:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $135
  102385:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10238a:	e9 a0 05 00 00       	jmp    10292f <__alltraps>

0010238f <vector136>:
.globl vector136
vector136:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $136
  102391:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102396:	e9 94 05 00 00       	jmp    10292f <__alltraps>

0010239b <vector137>:
.globl vector137
vector137:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $137
  10239d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023a2:	e9 88 05 00 00       	jmp    10292f <__alltraps>

001023a7 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $138
  1023a9:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023ae:	e9 7c 05 00 00       	jmp    10292f <__alltraps>

001023b3 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $139
  1023b5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023ba:	e9 70 05 00 00       	jmp    10292f <__alltraps>

001023bf <vector140>:
.globl vector140
vector140:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $140
  1023c1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023c6:	e9 64 05 00 00       	jmp    10292f <__alltraps>

001023cb <vector141>:
.globl vector141
vector141:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $141
  1023cd:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023d2:	e9 58 05 00 00       	jmp    10292f <__alltraps>

001023d7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $142
  1023d9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023de:	e9 4c 05 00 00       	jmp    10292f <__alltraps>

001023e3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $143
  1023e5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023ea:	e9 40 05 00 00       	jmp    10292f <__alltraps>

001023ef <vector144>:
.globl vector144
vector144:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $144
  1023f1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023f6:	e9 34 05 00 00       	jmp    10292f <__alltraps>

001023fb <vector145>:
.globl vector145
vector145:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $145
  1023fd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102402:	e9 28 05 00 00       	jmp    10292f <__alltraps>

00102407 <vector146>:
.globl vector146
vector146:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $146
  102409:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10240e:	e9 1c 05 00 00       	jmp    10292f <__alltraps>

00102413 <vector147>:
.globl vector147
vector147:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $147
  102415:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10241a:	e9 10 05 00 00       	jmp    10292f <__alltraps>

0010241f <vector148>:
.globl vector148
vector148:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $148
  102421:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102426:	e9 04 05 00 00       	jmp    10292f <__alltraps>

0010242b <vector149>:
.globl vector149
vector149:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $149
  10242d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102432:	e9 f8 04 00 00       	jmp    10292f <__alltraps>

00102437 <vector150>:
.globl vector150
vector150:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $150
  102439:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10243e:	e9 ec 04 00 00       	jmp    10292f <__alltraps>

00102443 <vector151>:
.globl vector151
vector151:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $151
  102445:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10244a:	e9 e0 04 00 00       	jmp    10292f <__alltraps>

0010244f <vector152>:
.globl vector152
vector152:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $152
  102451:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102456:	e9 d4 04 00 00       	jmp    10292f <__alltraps>

0010245b <vector153>:
.globl vector153
vector153:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $153
  10245d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102462:	e9 c8 04 00 00       	jmp    10292f <__alltraps>

00102467 <vector154>:
.globl vector154
vector154:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $154
  102469:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10246e:	e9 bc 04 00 00       	jmp    10292f <__alltraps>

00102473 <vector155>:
.globl vector155
vector155:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $155
  102475:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10247a:	e9 b0 04 00 00       	jmp    10292f <__alltraps>

0010247f <vector156>:
.globl vector156
vector156:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $156
  102481:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102486:	e9 a4 04 00 00       	jmp    10292f <__alltraps>

0010248b <vector157>:
.globl vector157
vector157:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $157
  10248d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102492:	e9 98 04 00 00       	jmp    10292f <__alltraps>

00102497 <vector158>:
.globl vector158
vector158:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $158
  102499:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10249e:	e9 8c 04 00 00       	jmp    10292f <__alltraps>

001024a3 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $159
  1024a5:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024aa:	e9 80 04 00 00       	jmp    10292f <__alltraps>

001024af <vector160>:
.globl vector160
vector160:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $160
  1024b1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024b6:	e9 74 04 00 00       	jmp    10292f <__alltraps>

001024bb <vector161>:
.globl vector161
vector161:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $161
  1024bd:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024c2:	e9 68 04 00 00       	jmp    10292f <__alltraps>

001024c7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $162
  1024c9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024ce:	e9 5c 04 00 00       	jmp    10292f <__alltraps>

001024d3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $163
  1024d5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024da:	e9 50 04 00 00       	jmp    10292f <__alltraps>

001024df <vector164>:
.globl vector164
vector164:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $164
  1024e1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024e6:	e9 44 04 00 00       	jmp    10292f <__alltraps>

001024eb <vector165>:
.globl vector165
vector165:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $165
  1024ed:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024f2:	e9 38 04 00 00       	jmp    10292f <__alltraps>

001024f7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $166
  1024f9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024fe:	e9 2c 04 00 00       	jmp    10292f <__alltraps>

00102503 <vector167>:
.globl vector167
vector167:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $167
  102505:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10250a:	e9 20 04 00 00       	jmp    10292f <__alltraps>

0010250f <vector168>:
.globl vector168
vector168:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $168
  102511:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102516:	e9 14 04 00 00       	jmp    10292f <__alltraps>

0010251b <vector169>:
.globl vector169
vector169:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $169
  10251d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102522:	e9 08 04 00 00       	jmp    10292f <__alltraps>

00102527 <vector170>:
.globl vector170
vector170:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $170
  102529:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10252e:	e9 fc 03 00 00       	jmp    10292f <__alltraps>

00102533 <vector171>:
.globl vector171
vector171:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $171
  102535:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10253a:	e9 f0 03 00 00       	jmp    10292f <__alltraps>

0010253f <vector172>:
.globl vector172
vector172:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $172
  102541:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102546:	e9 e4 03 00 00       	jmp    10292f <__alltraps>

0010254b <vector173>:
.globl vector173
vector173:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $173
  10254d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102552:	e9 d8 03 00 00       	jmp    10292f <__alltraps>

00102557 <vector174>:
.globl vector174
vector174:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $174
  102559:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10255e:	e9 cc 03 00 00       	jmp    10292f <__alltraps>

00102563 <vector175>:
.globl vector175
vector175:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $175
  102565:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10256a:	e9 c0 03 00 00       	jmp    10292f <__alltraps>

0010256f <vector176>:
.globl vector176
vector176:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $176
  102571:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102576:	e9 b4 03 00 00       	jmp    10292f <__alltraps>

0010257b <vector177>:
.globl vector177
vector177:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $177
  10257d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102582:	e9 a8 03 00 00       	jmp    10292f <__alltraps>

00102587 <vector178>:
.globl vector178
vector178:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $178
  102589:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10258e:	e9 9c 03 00 00       	jmp    10292f <__alltraps>

00102593 <vector179>:
.globl vector179
vector179:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $179
  102595:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10259a:	e9 90 03 00 00       	jmp    10292f <__alltraps>

0010259f <vector180>:
.globl vector180
vector180:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $180
  1025a1:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025a6:	e9 84 03 00 00       	jmp    10292f <__alltraps>

001025ab <vector181>:
.globl vector181
vector181:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $181
  1025ad:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025b2:	e9 78 03 00 00       	jmp    10292f <__alltraps>

001025b7 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $182
  1025b9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025be:	e9 6c 03 00 00       	jmp    10292f <__alltraps>

001025c3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $183
  1025c5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ca:	e9 60 03 00 00       	jmp    10292f <__alltraps>

001025cf <vector184>:
.globl vector184
vector184:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $184
  1025d1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025d6:	e9 54 03 00 00       	jmp    10292f <__alltraps>

001025db <vector185>:
.globl vector185
vector185:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $185
  1025dd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025e2:	e9 48 03 00 00       	jmp    10292f <__alltraps>

001025e7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $186
  1025e9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025ee:	e9 3c 03 00 00       	jmp    10292f <__alltraps>

001025f3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $187
  1025f5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025fa:	e9 30 03 00 00       	jmp    10292f <__alltraps>

001025ff <vector188>:
.globl vector188
vector188:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $188
  102601:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102606:	e9 24 03 00 00       	jmp    10292f <__alltraps>

0010260b <vector189>:
.globl vector189
vector189:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $189
  10260d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102612:	e9 18 03 00 00       	jmp    10292f <__alltraps>

00102617 <vector190>:
.globl vector190
vector190:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $190
  102619:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10261e:	e9 0c 03 00 00       	jmp    10292f <__alltraps>

00102623 <vector191>:
.globl vector191
vector191:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $191
  102625:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10262a:	e9 00 03 00 00       	jmp    10292f <__alltraps>

0010262f <vector192>:
.globl vector192
vector192:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $192
  102631:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102636:	e9 f4 02 00 00       	jmp    10292f <__alltraps>

0010263b <vector193>:
.globl vector193
vector193:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $193
  10263d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102642:	e9 e8 02 00 00       	jmp    10292f <__alltraps>

00102647 <vector194>:
.globl vector194
vector194:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $194
  102649:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10264e:	e9 dc 02 00 00       	jmp    10292f <__alltraps>

00102653 <vector195>:
.globl vector195
vector195:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $195
  102655:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10265a:	e9 d0 02 00 00       	jmp    10292f <__alltraps>

0010265f <vector196>:
.globl vector196
vector196:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $196
  102661:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102666:	e9 c4 02 00 00       	jmp    10292f <__alltraps>

0010266b <vector197>:
.globl vector197
vector197:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $197
  10266d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102672:	e9 b8 02 00 00       	jmp    10292f <__alltraps>

00102677 <vector198>:
.globl vector198
vector198:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $198
  102679:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10267e:	e9 ac 02 00 00       	jmp    10292f <__alltraps>

00102683 <vector199>:
.globl vector199
vector199:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $199
  102685:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10268a:	e9 a0 02 00 00       	jmp    10292f <__alltraps>

0010268f <vector200>:
.globl vector200
vector200:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $200
  102691:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102696:	e9 94 02 00 00       	jmp    10292f <__alltraps>

0010269b <vector201>:
.globl vector201
vector201:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $201
  10269d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026a2:	e9 88 02 00 00       	jmp    10292f <__alltraps>

001026a7 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $202
  1026a9:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026ae:	e9 7c 02 00 00       	jmp    10292f <__alltraps>

001026b3 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $203
  1026b5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026ba:	e9 70 02 00 00       	jmp    10292f <__alltraps>

001026bf <vector204>:
.globl vector204
vector204:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $204
  1026c1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026c6:	e9 64 02 00 00       	jmp    10292f <__alltraps>

001026cb <vector205>:
.globl vector205
vector205:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $205
  1026cd:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026d2:	e9 58 02 00 00       	jmp    10292f <__alltraps>

001026d7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $206
  1026d9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026de:	e9 4c 02 00 00       	jmp    10292f <__alltraps>

001026e3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $207
  1026e5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026ea:	e9 40 02 00 00       	jmp    10292f <__alltraps>

001026ef <vector208>:
.globl vector208
vector208:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $208
  1026f1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026f6:	e9 34 02 00 00       	jmp    10292f <__alltraps>

001026fb <vector209>:
.globl vector209
vector209:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $209
  1026fd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102702:	e9 28 02 00 00       	jmp    10292f <__alltraps>

00102707 <vector210>:
.globl vector210
vector210:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $210
  102709:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10270e:	e9 1c 02 00 00       	jmp    10292f <__alltraps>

00102713 <vector211>:
.globl vector211
vector211:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $211
  102715:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10271a:	e9 10 02 00 00       	jmp    10292f <__alltraps>

0010271f <vector212>:
.globl vector212
vector212:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $212
  102721:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102726:	e9 04 02 00 00       	jmp    10292f <__alltraps>

0010272b <vector213>:
.globl vector213
vector213:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $213
  10272d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102732:	e9 f8 01 00 00       	jmp    10292f <__alltraps>

00102737 <vector214>:
.globl vector214
vector214:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $214
  102739:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10273e:	e9 ec 01 00 00       	jmp    10292f <__alltraps>

00102743 <vector215>:
.globl vector215
vector215:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $215
  102745:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10274a:	e9 e0 01 00 00       	jmp    10292f <__alltraps>

0010274f <vector216>:
.globl vector216
vector216:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $216
  102751:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102756:	e9 d4 01 00 00       	jmp    10292f <__alltraps>

0010275b <vector217>:
.globl vector217
vector217:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $217
  10275d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102762:	e9 c8 01 00 00       	jmp    10292f <__alltraps>

00102767 <vector218>:
.globl vector218
vector218:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $218
  102769:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10276e:	e9 bc 01 00 00       	jmp    10292f <__alltraps>

00102773 <vector219>:
.globl vector219
vector219:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $219
  102775:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10277a:	e9 b0 01 00 00       	jmp    10292f <__alltraps>

0010277f <vector220>:
.globl vector220
vector220:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $220
  102781:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102786:	e9 a4 01 00 00       	jmp    10292f <__alltraps>

0010278b <vector221>:
.globl vector221
vector221:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $221
  10278d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102792:	e9 98 01 00 00       	jmp    10292f <__alltraps>

00102797 <vector222>:
.globl vector222
vector222:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $222
  102799:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10279e:	e9 8c 01 00 00       	jmp    10292f <__alltraps>

001027a3 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $223
  1027a5:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027aa:	e9 80 01 00 00       	jmp    10292f <__alltraps>

001027af <vector224>:
.globl vector224
vector224:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $224
  1027b1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027b6:	e9 74 01 00 00       	jmp    10292f <__alltraps>

001027bb <vector225>:
.globl vector225
vector225:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $225
  1027bd:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027c2:	e9 68 01 00 00       	jmp    10292f <__alltraps>

001027c7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $226
  1027c9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027ce:	e9 5c 01 00 00       	jmp    10292f <__alltraps>

001027d3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $227
  1027d5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027da:	e9 50 01 00 00       	jmp    10292f <__alltraps>

001027df <vector228>:
.globl vector228
vector228:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $228
  1027e1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027e6:	e9 44 01 00 00       	jmp    10292f <__alltraps>

001027eb <vector229>:
.globl vector229
vector229:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $229
  1027ed:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027f2:	e9 38 01 00 00       	jmp    10292f <__alltraps>

001027f7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $230
  1027f9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027fe:	e9 2c 01 00 00       	jmp    10292f <__alltraps>

00102803 <vector231>:
.globl vector231
vector231:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $231
  102805:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10280a:	e9 20 01 00 00       	jmp    10292f <__alltraps>

0010280f <vector232>:
.globl vector232
vector232:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $232
  102811:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102816:	e9 14 01 00 00       	jmp    10292f <__alltraps>

0010281b <vector233>:
.globl vector233
vector233:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $233
  10281d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102822:	e9 08 01 00 00       	jmp    10292f <__alltraps>

00102827 <vector234>:
.globl vector234
vector234:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $234
  102829:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10282e:	e9 fc 00 00 00       	jmp    10292f <__alltraps>

00102833 <vector235>:
.globl vector235
vector235:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $235
  102835:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10283a:	e9 f0 00 00 00       	jmp    10292f <__alltraps>

0010283f <vector236>:
.globl vector236
vector236:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $236
  102841:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102846:	e9 e4 00 00 00       	jmp    10292f <__alltraps>

0010284b <vector237>:
.globl vector237
vector237:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $237
  10284d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102852:	e9 d8 00 00 00       	jmp    10292f <__alltraps>

00102857 <vector238>:
.globl vector238
vector238:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $238
  102859:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10285e:	e9 cc 00 00 00       	jmp    10292f <__alltraps>

00102863 <vector239>:
.globl vector239
vector239:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $239
  102865:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10286a:	e9 c0 00 00 00       	jmp    10292f <__alltraps>

0010286f <vector240>:
.globl vector240
vector240:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $240
  102871:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102876:	e9 b4 00 00 00       	jmp    10292f <__alltraps>

0010287b <vector241>:
.globl vector241
vector241:
  pushl $0
  10287b:	6a 00                	push   $0x0
  pushl $241
  10287d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102882:	e9 a8 00 00 00       	jmp    10292f <__alltraps>

00102887 <vector242>:
.globl vector242
vector242:
  pushl $0
  102887:	6a 00                	push   $0x0
  pushl $242
  102889:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10288e:	e9 9c 00 00 00       	jmp    10292f <__alltraps>

00102893 <vector243>:
.globl vector243
vector243:
  pushl $0
  102893:	6a 00                	push   $0x0
  pushl $243
  102895:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10289a:	e9 90 00 00 00       	jmp    10292f <__alltraps>

0010289f <vector244>:
.globl vector244
vector244:
  pushl $0
  10289f:	6a 00                	push   $0x0
  pushl $244
  1028a1:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028a6:	e9 84 00 00 00       	jmp    10292f <__alltraps>

001028ab <vector245>:
.globl vector245
vector245:
  pushl $0
  1028ab:	6a 00                	push   $0x0
  pushl $245
  1028ad:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028b2:	e9 78 00 00 00       	jmp    10292f <__alltraps>

001028b7 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028b7:	6a 00                	push   $0x0
  pushl $246
  1028b9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028be:	e9 6c 00 00 00       	jmp    10292f <__alltraps>

001028c3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028c3:	6a 00                	push   $0x0
  pushl $247
  1028c5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ca:	e9 60 00 00 00       	jmp    10292f <__alltraps>

001028cf <vector248>:
.globl vector248
vector248:
  pushl $0
  1028cf:	6a 00                	push   $0x0
  pushl $248
  1028d1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028d6:	e9 54 00 00 00       	jmp    10292f <__alltraps>

001028db <vector249>:
.globl vector249
vector249:
  pushl $0
  1028db:	6a 00                	push   $0x0
  pushl $249
  1028dd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028e2:	e9 48 00 00 00       	jmp    10292f <__alltraps>

001028e7 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028e7:	6a 00                	push   $0x0
  pushl $250
  1028e9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028ee:	e9 3c 00 00 00       	jmp    10292f <__alltraps>

001028f3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028f3:	6a 00                	push   $0x0
  pushl $251
  1028f5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028fa:	e9 30 00 00 00       	jmp    10292f <__alltraps>

001028ff <vector252>:
.globl vector252
vector252:
  pushl $0
  1028ff:	6a 00                	push   $0x0
  pushl $252
  102901:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102906:	e9 24 00 00 00       	jmp    10292f <__alltraps>

0010290b <vector253>:
.globl vector253
vector253:
  pushl $0
  10290b:	6a 00                	push   $0x0
  pushl $253
  10290d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102912:	e9 18 00 00 00       	jmp    10292f <__alltraps>

00102917 <vector254>:
.globl vector254
vector254:
  pushl $0
  102917:	6a 00                	push   $0x0
  pushl $254
  102919:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10291e:	e9 0c 00 00 00       	jmp    10292f <__alltraps>

00102923 <vector255>:
.globl vector255
vector255:
  pushl $0
  102923:	6a 00                	push   $0x0
  pushl $255
  102925:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10292a:	e9 00 00 00 00       	jmp    10292f <__alltraps>

0010292f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10292f:	1e                   	push   %ds
    pushl %es
  102930:	06                   	push   %es
    pushl %fs
  102931:	0f a0                	push   %fs
    pushl %gs
  102933:	0f a8                	push   %gs
    pushal
  102935:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102936:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10293b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10293d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10293f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102940:	e8 60 f5 ff ff       	call   101ea5 <trap>

    # pop the pushed stack pointer
    popl %esp
  102945:	5c                   	pop    %esp

00102946 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102946:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102947:	0f a9                	pop    %gs
    popl %fs
  102949:	0f a1                	pop    %fs
    popl %es
  10294b:	07                   	pop    %es
    popl %ds
  10294c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10294d:	83 c4 08             	add    $0x8,%esp
    iret
  102950:	cf                   	iret   

00102951 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102951:	55                   	push   %ebp
  102952:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102954:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102959:	8b 55 08             	mov    0x8(%ebp),%edx
  10295c:	29 c2                	sub    %eax,%edx
  10295e:	89 d0                	mov    %edx,%eax
  102960:	c1 f8 02             	sar    $0x2,%eax
  102963:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102969:	5d                   	pop    %ebp
  10296a:	c3                   	ret    

0010296b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10296b:	55                   	push   %ebp
  10296c:	89 e5                	mov    %esp,%ebp
  10296e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102971:	8b 45 08             	mov    0x8(%ebp),%eax
  102974:	89 04 24             	mov    %eax,(%esp)
  102977:	e8 d5 ff ff ff       	call   102951 <page2ppn>
  10297c:	c1 e0 0c             	shl    $0xc,%eax
}
  10297f:	c9                   	leave  
  102980:	c3                   	ret    

00102981 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102981:	55                   	push   %ebp
  102982:	89 e5                	mov    %esp,%ebp
  102984:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102987:	8b 45 08             	mov    0x8(%ebp),%eax
  10298a:	c1 e8 0c             	shr    $0xc,%eax
  10298d:	89 c2                	mov    %eax,%edx
  10298f:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102994:	39 c2                	cmp    %eax,%edx
  102996:	72 1c                	jb     1029b4 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102998:	c7 44 24 08 10 68 10 	movl   $0x106810,0x8(%esp)
  10299f:	00 
  1029a0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1029a7:	00 
  1029a8:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  1029af:	e8 72 da ff ff       	call   100426 <__panic>
    }
    return &pages[PPN(pa)];
  1029b4:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  1029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bd:	c1 e8 0c             	shr    $0xc,%eax
  1029c0:	89 c2                	mov    %eax,%edx
  1029c2:	89 d0                	mov    %edx,%eax
  1029c4:	c1 e0 02             	shl    $0x2,%eax
  1029c7:	01 d0                	add    %edx,%eax
  1029c9:	c1 e0 02             	shl    $0x2,%eax
  1029cc:	01 c8                	add    %ecx,%eax
}
  1029ce:	c9                   	leave  
  1029cf:	c3                   	ret    

001029d0 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1029d0:	55                   	push   %ebp
  1029d1:	89 e5                	mov    %esp,%ebp
  1029d3:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d9:	89 04 24             	mov    %eax,(%esp)
  1029dc:	e8 8a ff ff ff       	call   10296b <page2pa>
  1029e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e7:	c1 e8 0c             	shr    $0xc,%eax
  1029ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029ed:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1029f2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1029f5:	72 23                	jb     102a1a <page2kva+0x4a>
  1029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1029fe:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  102a05:	00 
  102a06:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a0d:	00 
  102a0e:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a15:	e8 0c da ff ff       	call   100426 <__panic>
  102a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a1d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a22:	c9                   	leave  
  102a23:	c3                   	ret    

00102a24 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a24:	55                   	push   %ebp
  102a25:	89 e5                	mov    %esp,%ebp
  102a27:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2d:	83 e0 01             	and    $0x1,%eax
  102a30:	85 c0                	test   %eax,%eax
  102a32:	75 1c                	jne    102a50 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102a34:	c7 44 24 08 64 68 10 	movl   $0x106864,0x8(%esp)
  102a3b:	00 
  102a3c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102a43:	00 
  102a44:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a4b:	e8 d6 d9 ff ff       	call   100426 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102a50:	8b 45 08             	mov    0x8(%ebp),%eax
  102a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a58:	89 04 24             	mov    %eax,(%esp)
  102a5b:	e8 21 ff ff ff       	call   102981 <pa2page>
}
  102a60:	c9                   	leave  
  102a61:	c3                   	ret    

00102a62 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102a62:	55                   	push   %ebp
  102a63:	89 e5                	mov    %esp,%ebp
  102a65:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102a68:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a70:	89 04 24             	mov    %eax,(%esp)
  102a73:	e8 09 ff ff ff       	call   102981 <pa2page>
}
  102a78:	c9                   	leave  
  102a79:	c3                   	ret    

00102a7a <page_ref>:

static inline int
page_ref(struct Page *page) {
  102a7a:	55                   	push   %ebp
  102a7b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a80:	8b 00                	mov    (%eax),%eax
}
  102a82:	5d                   	pop    %ebp
  102a83:	c3                   	ret    

00102a84 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a84:	55                   	push   %ebp
  102a85:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a87:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a8d:	89 10                	mov    %edx,(%eax)
}
  102a8f:	90                   	nop
  102a90:	5d                   	pop    %ebp
  102a91:	c3                   	ret    

00102a92 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102a92:	55                   	push   %ebp
  102a93:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102a95:	8b 45 08             	mov    0x8(%ebp),%eax
  102a98:	8b 00                	mov    (%eax),%eax
  102a9a:	8d 50 01             	lea    0x1(%eax),%edx
  102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa0:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa5:	8b 00                	mov    (%eax),%eax
}
  102aa7:	5d                   	pop    %ebp
  102aa8:	c3                   	ret    

00102aa9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102aa9:	55                   	push   %ebp
  102aaa:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102aac:	8b 45 08             	mov    0x8(%ebp),%eax
  102aaf:	8b 00                	mov    (%eax),%eax
  102ab1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab7:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  102abc:	8b 00                	mov    (%eax),%eax
}
  102abe:	5d                   	pop    %ebp
  102abf:	c3                   	ret    

00102ac0 <__intr_save>:
__intr_save(void) {
  102ac0:	55                   	push   %ebp
  102ac1:	89 e5                	mov    %esp,%ebp
  102ac3:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102ac6:	9c                   	pushf  
  102ac7:	58                   	pop    %eax
  102ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102ace:	25 00 02 00 00       	and    $0x200,%eax
  102ad3:	85 c0                	test   %eax,%eax
  102ad5:	74 0c                	je     102ae3 <__intr_save+0x23>
        intr_disable();
  102ad7:	e8 a9 ee ff ff       	call   101985 <intr_disable>
        return 1;
  102adc:	b8 01 00 00 00       	mov    $0x1,%eax
  102ae1:	eb 05                	jmp    102ae8 <__intr_save+0x28>
    return 0;
  102ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ae8:	c9                   	leave  
  102ae9:	c3                   	ret    

00102aea <__intr_restore>:
__intr_restore(bool flag) {
  102aea:	55                   	push   %ebp
  102aeb:	89 e5                	mov    %esp,%ebp
  102aed:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102af0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102af4:	74 05                	je     102afb <__intr_restore+0x11>
        intr_enable();
  102af6:	e8 7e ee ff ff       	call   101979 <intr_enable>
}
  102afb:	90                   	nop
  102afc:	c9                   	leave  
  102afd:	c3                   	ret    

00102afe <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102afe:	55                   	push   %ebp
  102aff:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b01:	8b 45 08             	mov    0x8(%ebp),%eax
  102b04:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b07:	b8 23 00 00 00       	mov    $0x23,%eax
  102b0c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b0e:	b8 23 00 00 00       	mov    $0x23,%eax
  102b13:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b15:	b8 10 00 00 00       	mov    $0x10,%eax
  102b1a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b1c:	b8 10 00 00 00       	mov    $0x10,%eax
  102b21:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b23:	b8 10 00 00 00       	mov    $0x10,%eax
  102b28:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b2a:	ea 31 2b 10 00 08 00 	ljmp   $0x8,$0x102b31
}
  102b31:	90                   	nop
  102b32:	5d                   	pop    %ebp
  102b33:	c3                   	ret    

00102b34 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b34:	f3 0f 1e fb          	endbr32 
  102b38:	55                   	push   %ebp
  102b39:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3e:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102b43:	90                   	nop
  102b44:	5d                   	pop    %ebp
  102b45:	c3                   	ret    

00102b46 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b46:	f3 0f 1e fb          	endbr32 
  102b4a:	55                   	push   %ebp
  102b4b:	89 e5                	mov    %esp,%ebp
  102b4d:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b50:	b8 00 90 11 00       	mov    $0x119000,%eax
  102b55:	89 04 24             	mov    %eax,(%esp)
  102b58:	e8 d7 ff ff ff       	call   102b34 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102b5d:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102b64:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b66:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102b6d:	68 00 
  102b6f:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b74:	0f b7 c0             	movzwl %ax,%eax
  102b77:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102b7d:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b82:	c1 e8 10             	shr    $0x10,%eax
  102b85:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102b8a:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102b91:	24 f0                	and    $0xf0,%al
  102b93:	0c 09                	or     $0x9,%al
  102b95:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102b9a:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102ba1:	24 ef                	and    $0xef,%al
  102ba3:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102ba8:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102baf:	24 9f                	and    $0x9f,%al
  102bb1:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bb6:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102bbd:	0c 80                	or     $0x80,%al
  102bbf:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bc4:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bcb:	24 f0                	and    $0xf0,%al
  102bcd:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bd2:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bd9:	24 ef                	and    $0xef,%al
  102bdb:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102be0:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102be7:	24 df                	and    $0xdf,%al
  102be9:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bee:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bf5:	0c 40                	or     $0x40,%al
  102bf7:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bfc:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102c03:	24 7f                	and    $0x7f,%al
  102c05:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c0a:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c0f:	c1 e8 18             	shr    $0x18,%eax
  102c12:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c17:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102c1e:	e8 db fe ff ff       	call   102afe <lgdt>
  102c23:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c29:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c2d:	0f 00 d8             	ltr    %ax
}
  102c30:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c31:	90                   	nop
  102c32:	c9                   	leave  
  102c33:	c3                   	ret    

00102c34 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c34:	f3 0f 1e fb          	endbr32 
  102c38:	55                   	push   %ebp
  102c39:	89 e5                	mov    %esp,%ebp
  102c3b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c3e:	c7 05 10 cf 11 00 f0 	movl   $0x1071f0,0x11cf10
  102c45:	71 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c48:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c4d:	8b 00                	mov    (%eax),%eax
  102c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c53:	c7 04 24 90 68 10 00 	movl   $0x106890,(%esp)
  102c5a:	e8 5b d6 ff ff       	call   1002ba <cprintf>
    pmm_manager->init();
  102c5f:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c64:	8b 40 04             	mov    0x4(%eax),%eax
  102c67:	ff d0                	call   *%eax
}
  102c69:	90                   	nop
  102c6a:	c9                   	leave  
  102c6b:	c3                   	ret    

00102c6c <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c6c:	f3 0f 1e fb          	endbr32 
  102c70:	55                   	push   %ebp
  102c71:	89 e5                	mov    %esp,%ebp
  102c73:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102c76:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c7b:	8b 40 08             	mov    0x8(%eax),%eax
  102c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c81:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c85:	8b 55 08             	mov    0x8(%ebp),%edx
  102c88:	89 14 24             	mov    %edx,(%esp)
  102c8b:	ff d0                	call   *%eax
}
  102c8d:	90                   	nop
  102c8e:	c9                   	leave  
  102c8f:	c3                   	ret    

00102c90 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102c90:	f3 0f 1e fb          	endbr32 
  102c94:	55                   	push   %ebp
  102c95:	89 e5                	mov    %esp,%ebp
  102c97:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102c9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102ca1:	e8 1a fe ff ff       	call   102ac0 <__intr_save>
  102ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102ca9:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102cae:	8b 40 0c             	mov    0xc(%eax),%eax
  102cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb4:	89 14 24             	mov    %edx,(%esp)
  102cb7:	ff d0                	call   *%eax
  102cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cbf:	89 04 24             	mov    %eax,(%esp)
  102cc2:	e8 23 fe ff ff       	call   102aea <__intr_restore>
    return page;
  102cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cca:	c9                   	leave  
  102ccb:	c3                   	ret    

00102ccc <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102ccc:	f3 0f 1e fb          	endbr32 
  102cd0:	55                   	push   %ebp
  102cd1:	89 e5                	mov    %esp,%ebp
  102cd3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cd6:	e8 e5 fd ff ff       	call   102ac0 <__intr_save>
  102cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cde:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102ce3:	8b 40 10             	mov    0x10(%eax),%eax
  102ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce9:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ced:	8b 55 08             	mov    0x8(%ebp),%edx
  102cf0:	89 14 24             	mov    %edx,(%esp)
  102cf3:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf8:	89 04 24             	mov    %eax,(%esp)
  102cfb:	e8 ea fd ff ff       	call   102aea <__intr_restore>
}
  102d00:	90                   	nop
  102d01:	c9                   	leave  
  102d02:	c3                   	ret    

00102d03 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d03:	f3 0f 1e fb          	endbr32 
  102d07:	55                   	push   %ebp
  102d08:	89 e5                	mov    %esp,%ebp
  102d0a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d0d:	e8 ae fd ff ff       	call   102ac0 <__intr_save>
  102d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d15:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d1a:	8b 40 14             	mov    0x14(%eax),%eax
  102d1d:	ff d0                	call   *%eax
  102d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d25:	89 04 24             	mov    %eax,(%esp)
  102d28:	e8 bd fd ff ff       	call   102aea <__intr_restore>
    return ret;
  102d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d30:	c9                   	leave  
  102d31:	c3                   	ret    

00102d32 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d32:	f3 0f 1e fb          	endbr32 
  102d36:	55                   	push   %ebp
  102d37:	89 e5                	mov    %esp,%ebp
  102d39:	57                   	push   %edi
  102d3a:	56                   	push   %esi
  102d3b:	53                   	push   %ebx
  102d3c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d42:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d57:	c7 04 24 a7 68 10 00 	movl   $0x1068a7,(%esp)
  102d5e:	e8 57 d5 ff ff       	call   1002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d6a:	e9 1a 01 00 00       	jmp    102e89 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d6f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d75:	89 d0                	mov    %edx,%eax
  102d77:	c1 e0 02             	shl    $0x2,%eax
  102d7a:	01 d0                	add    %edx,%eax
  102d7c:	c1 e0 02             	shl    $0x2,%eax
  102d7f:	01 c8                	add    %ecx,%eax
  102d81:	8b 50 08             	mov    0x8(%eax),%edx
  102d84:	8b 40 04             	mov    0x4(%eax),%eax
  102d87:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102d8a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d93:	89 d0                	mov    %edx,%eax
  102d95:	c1 e0 02             	shl    $0x2,%eax
  102d98:	01 d0                	add    %edx,%eax
  102d9a:	c1 e0 02             	shl    $0x2,%eax
  102d9d:	01 c8                	add    %ecx,%eax
  102d9f:	8b 48 0c             	mov    0xc(%eax),%ecx
  102da2:	8b 58 10             	mov    0x10(%eax),%ebx
  102da5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102da8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102dab:	01 c8                	add    %ecx,%eax
  102dad:	11 da                	adc    %ebx,%edx
  102daf:	89 45 98             	mov    %eax,-0x68(%ebp)
  102db2:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102db5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102db8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dbb:	89 d0                	mov    %edx,%eax
  102dbd:	c1 e0 02             	shl    $0x2,%eax
  102dc0:	01 d0                	add    %edx,%eax
  102dc2:	c1 e0 02             	shl    $0x2,%eax
  102dc5:	01 c8                	add    %ecx,%eax
  102dc7:	83 c0 14             	add    $0x14,%eax
  102dca:	8b 00                	mov    (%eax),%eax
  102dcc:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102dcf:	8b 45 98             	mov    -0x68(%ebp),%eax
  102dd2:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102dd5:	83 c0 ff             	add    $0xffffffff,%eax
  102dd8:	83 d2 ff             	adc    $0xffffffff,%edx
  102ddb:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102de1:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102de7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ded:	89 d0                	mov    %edx,%eax
  102def:	c1 e0 02             	shl    $0x2,%eax
  102df2:	01 d0                	add    %edx,%eax
  102df4:	c1 e0 02             	shl    $0x2,%eax
  102df7:	01 c8                	add    %ecx,%eax
  102df9:	8b 48 0c             	mov    0xc(%eax),%ecx
  102dfc:	8b 58 10             	mov    0x10(%eax),%ebx
  102dff:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e02:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102e06:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102e0c:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102e12:	89 44 24 14          	mov    %eax,0x14(%esp)
  102e16:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e1a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e1d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e24:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e28:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e30:	c7 04 24 b4 68 10 00 	movl   $0x1068b4,(%esp)
  102e37:	e8 7e d4 ff ff       	call   1002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e3c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e42:	89 d0                	mov    %edx,%eax
  102e44:	c1 e0 02             	shl    $0x2,%eax
  102e47:	01 d0                	add    %edx,%eax
  102e49:	c1 e0 02             	shl    $0x2,%eax
  102e4c:	01 c8                	add    %ecx,%eax
  102e4e:	83 c0 14             	add    $0x14,%eax
  102e51:	8b 00                	mov    (%eax),%eax
  102e53:	83 f8 01             	cmp    $0x1,%eax
  102e56:	75 2e                	jne    102e86 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  102e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e5e:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102e61:	89 d0                	mov    %edx,%eax
  102e63:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102e66:	73 1e                	jae    102e86 <page_init+0x154>
  102e68:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  102e72:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102e75:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102e78:	72 0c                	jb     102e86 <page_init+0x154>
                maxpa = end;
  102e7a:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e7d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e83:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102e86:	ff 45 dc             	incl   -0x24(%ebp)
  102e89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e8c:	8b 00                	mov    (%eax),%eax
  102e8e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102e91:	0f 8c d8 fe ff ff    	jl     102d6f <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102e97:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  102ea1:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102ea4:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102ea7:	73 0e                	jae    102eb7 <page_init+0x185>
        maxpa = KMEMSIZE;
  102ea9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102eb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ebd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ec1:	c1 ea 0c             	shr    $0xc,%edx
  102ec4:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ec9:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102ed0:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102ed5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ed8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102edb:	01 d0                	add    %edx,%eax
  102edd:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102ee0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ee8:	f7 75 c0             	divl   -0x40(%ebp)
  102eeb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102eee:	29 d0                	sub    %edx,%eax
  102ef0:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i ++) {
  102ef5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102efc:	eb 2f                	jmp    102f2d <page_init+0x1fb>
        SetPageReserved(pages + i);
  102efe:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102f04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f07:	89 d0                	mov    %edx,%eax
  102f09:	c1 e0 02             	shl    $0x2,%eax
  102f0c:	01 d0                	add    %edx,%eax
  102f0e:	c1 e0 02             	shl    $0x2,%eax
  102f11:	01 c8                	add    %ecx,%eax
  102f13:	83 c0 04             	add    $0x4,%eax
  102f16:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102f1d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f20:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f23:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f26:	0f ab 10             	bts    %edx,(%eax)
}
  102f29:	90                   	nop
    for (i = 0; i < npage; i ++) {
  102f2a:	ff 45 dc             	incl   -0x24(%ebp)
  102f2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f30:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102f35:	39 c2                	cmp    %eax,%edx
  102f37:	72 c5                	jb     102efe <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f39:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  102f3f:	89 d0                	mov    %edx,%eax
  102f41:	c1 e0 02             	shl    $0x2,%eax
  102f44:	01 d0                	add    %edx,%eax
  102f46:	c1 e0 02             	shl    $0x2,%eax
  102f49:	89 c2                	mov    %eax,%edx
  102f4b:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102f50:	01 d0                	add    %edx,%eax
  102f52:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102f55:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102f5c:	77 23                	ja     102f81 <page_init+0x24f>
  102f5e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f65:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  102f6c:	00 
  102f6d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f74:	00 
  102f75:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  102f7c:	e8 a5 d4 ff ff       	call   100426 <__panic>
  102f81:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f84:	05 00 00 00 40       	add    $0x40000000,%eax
  102f89:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102f8c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f93:	e9 4b 01 00 00       	jmp    1030e3 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f98:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f9e:	89 d0                	mov    %edx,%eax
  102fa0:	c1 e0 02             	shl    $0x2,%eax
  102fa3:	01 d0                	add    %edx,%eax
  102fa5:	c1 e0 02             	shl    $0x2,%eax
  102fa8:	01 c8                	add    %ecx,%eax
  102faa:	8b 50 08             	mov    0x8(%eax),%edx
  102fad:	8b 40 04             	mov    0x4(%eax),%eax
  102fb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fb3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fb6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fb9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fbc:	89 d0                	mov    %edx,%eax
  102fbe:	c1 e0 02             	shl    $0x2,%eax
  102fc1:	01 d0                	add    %edx,%eax
  102fc3:	c1 e0 02             	shl    $0x2,%eax
  102fc6:	01 c8                	add    %ecx,%eax
  102fc8:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fcb:	8b 58 10             	mov    0x10(%eax),%ebx
  102fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fd1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fd4:	01 c8                	add    %ecx,%eax
  102fd6:	11 da                	adc    %ebx,%edx
  102fd8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102fdb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102fde:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fe1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe4:	89 d0                	mov    %edx,%eax
  102fe6:	c1 e0 02             	shl    $0x2,%eax
  102fe9:	01 d0                	add    %edx,%eax
  102feb:	c1 e0 02             	shl    $0x2,%eax
  102fee:	01 c8                	add    %ecx,%eax
  102ff0:	83 c0 14             	add    $0x14,%eax
  102ff3:	8b 00                	mov    (%eax),%eax
  102ff5:	83 f8 01             	cmp    $0x1,%eax
  102ff8:	0f 85 e2 00 00 00    	jne    1030e0 <page_init+0x3ae>
            if (begin < freemem) {
  102ffe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103001:	ba 00 00 00 00       	mov    $0x0,%edx
  103006:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103009:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10300c:	19 d1                	sbb    %edx,%ecx
  10300e:	73 0d                	jae    10301d <page_init+0x2eb>
                begin = freemem;
  103010:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103013:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103016:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10301d:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103022:	b8 00 00 00 00       	mov    $0x0,%eax
  103027:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  10302a:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10302d:	73 0e                	jae    10303d <page_init+0x30b>
                end = KMEMSIZE;
  10302f:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103036:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10303d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103040:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103043:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103046:	89 d0                	mov    %edx,%eax
  103048:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10304b:	0f 83 8f 00 00 00    	jae    1030e0 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  103051:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103058:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10305b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10305e:	01 d0                	add    %edx,%eax
  103060:	48                   	dec    %eax
  103061:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103064:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103067:	ba 00 00 00 00       	mov    $0x0,%edx
  10306c:	f7 75 b0             	divl   -0x50(%ebp)
  10306f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103072:	29 d0                	sub    %edx,%eax
  103074:	ba 00 00 00 00       	mov    $0x0,%edx
  103079:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10307c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10307f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103082:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103085:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103088:	ba 00 00 00 00       	mov    $0x0,%edx
  10308d:	89 c3                	mov    %eax,%ebx
  10308f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103095:	89 de                	mov    %ebx,%esi
  103097:	89 d0                	mov    %edx,%eax
  103099:	83 e0 00             	and    $0x0,%eax
  10309c:	89 c7                	mov    %eax,%edi
  10309e:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1030a1:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1030a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030aa:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030ad:	89 d0                	mov    %edx,%eax
  1030af:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030b2:	73 2c                	jae    1030e0 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1030ba:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1030bd:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1030c0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030c4:	c1 ea 0c             	shr    $0xc,%edx
  1030c7:	89 c3                	mov    %eax,%ebx
  1030c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030cc:	89 04 24             	mov    %eax,(%esp)
  1030cf:	e8 ad f8 ff ff       	call   102981 <pa2page>
  1030d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1030d8:	89 04 24             	mov    %eax,(%esp)
  1030db:	e8 8c fb ff ff       	call   102c6c <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1030e0:	ff 45 dc             	incl   -0x24(%ebp)
  1030e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030e6:	8b 00                	mov    (%eax),%eax
  1030e8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030eb:	0f 8c a7 fe ff ff    	jl     102f98 <page_init+0x266>
                }
            }
        }
    }
}
  1030f1:	90                   	nop
  1030f2:	90                   	nop
  1030f3:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1030f9:	5b                   	pop    %ebx
  1030fa:	5e                   	pop    %esi
  1030fb:	5f                   	pop    %edi
  1030fc:	5d                   	pop    %ebp
  1030fd:	c3                   	ret    

001030fe <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1030fe:	f3 0f 1e fb          	endbr32 
  103102:	55                   	push   %ebp
  103103:	89 e5                	mov    %esp,%ebp
  103105:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103108:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310b:	33 45 14             	xor    0x14(%ebp),%eax
  10310e:	25 ff 0f 00 00       	and    $0xfff,%eax
  103113:	85 c0                	test   %eax,%eax
  103115:	74 24                	je     10313b <boot_map_segment+0x3d>
  103117:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  10311e:	00 
  10311f:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103126:	00 
  103127:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10312e:	00 
  10312f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103136:	e8 eb d2 ff ff       	call   100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10313b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103142:	8b 45 0c             	mov    0xc(%ebp),%eax
  103145:	25 ff 0f 00 00       	and    $0xfff,%eax
  10314a:	89 c2                	mov    %eax,%edx
  10314c:	8b 45 10             	mov    0x10(%ebp),%eax
  10314f:	01 c2                	add    %eax,%edx
  103151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103154:	01 d0                	add    %edx,%eax
  103156:	48                   	dec    %eax
  103157:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315d:	ba 00 00 00 00       	mov    $0x0,%edx
  103162:	f7 75 f0             	divl   -0x10(%ebp)
  103165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103168:	29 d0                	sub    %edx,%eax
  10316a:	c1 e8 0c             	shr    $0xc,%eax
  10316d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103170:	8b 45 0c             	mov    0xc(%ebp),%eax
  103173:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103179:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10317e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103181:	8b 45 14             	mov    0x14(%ebp),%eax
  103184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10318a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10318f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103192:	eb 68                	jmp    1031fc <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103194:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10319b:	00 
  10319c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a6:	89 04 24             	mov    %eax,(%esp)
  1031a9:	e8 8a 01 00 00       	call   103338 <get_pte>
  1031ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031b5:	75 24                	jne    1031db <boot_map_segment+0xdd>
  1031b7:	c7 44 24 0c 42 69 10 	movl   $0x106942,0xc(%esp)
  1031be:	00 
  1031bf:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1031c6:	00 
  1031c7:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1031ce:	00 
  1031cf:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1031d6:	e8 4b d2 ff ff       	call   100426 <__panic>
        *ptep = pa | PTE_P | perm;
  1031db:	8b 45 14             	mov    0x14(%ebp),%eax
  1031de:	0b 45 18             	or     0x18(%ebp),%eax
  1031e1:	83 c8 01             	or     $0x1,%eax
  1031e4:	89 c2                	mov    %eax,%edx
  1031e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031e9:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031eb:	ff 4d f4             	decl   -0xc(%ebp)
  1031ee:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1031f5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1031fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103200:	75 92                	jne    103194 <boot_map_segment+0x96>
    }
}
  103202:	90                   	nop
  103203:	90                   	nop
  103204:	c9                   	leave  
  103205:	c3                   	ret    

00103206 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103206:	f3 0f 1e fb          	endbr32 
  10320a:	55                   	push   %ebp
  10320b:	89 e5                	mov    %esp,%ebp
  10320d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103217:	e8 74 fa ff ff       	call   102c90 <alloc_pages>
  10321c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10321f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103223:	75 1c                	jne    103241 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  103225:	c7 44 24 08 4f 69 10 	movl   $0x10694f,0x8(%esp)
  10322c:	00 
  10322d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103234:	00 
  103235:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10323c:	e8 e5 d1 ff ff       	call   100426 <__panic>
    }
    return page2kva(p);
  103241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103244:	89 04 24             	mov    %eax,(%esp)
  103247:	e8 84 f7 ff ff       	call   1029d0 <page2kva>
}
  10324c:	c9                   	leave  
  10324d:	c3                   	ret    

0010324e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10324e:	f3 0f 1e fb          	endbr32 
  103252:	55                   	push   %ebp
  103253:	89 e5                	mov    %esp,%ebp
  103255:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103258:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103260:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103267:	77 23                	ja     10328c <pmm_init+0x3e>
  103269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10326c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103270:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103277:	00 
  103278:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10327f:	00 
  103280:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103287:	e8 9a d1 ff ff       	call   100426 <__panic>
  10328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10328f:	05 00 00 00 40       	add    $0x40000000,%eax
  103294:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103299:	e8 96 f9 ff ff       	call   102c34 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10329e:	e8 8f fa ff ff       	call   102d32 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1032a3:	e8 28 04 00 00       	call   1036d0 <check_alloc_page>

    check_pgdir();
  1032a8:	e8 46 04 00 00       	call   1036f3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1032ad:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032bc:	77 23                	ja     1032e1 <pmm_init+0x93>
  1032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032c5:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  1032cc:	00 
  1032cd:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1032d4:	00 
  1032d5:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1032dc:	e8 45 d1 ff ff       	call   100426 <__panic>
  1032e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032e4:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1032ea:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032ef:	05 ac 0f 00 00       	add    $0xfac,%eax
  1032f4:	83 ca 03             	or     $0x3,%edx
  1032f7:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1032f9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032fe:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103305:	00 
  103306:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10330d:	00 
  10330e:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103315:	38 
  103316:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10331d:	c0 
  10331e:	89 04 24             	mov    %eax,(%esp)
  103321:	e8 d8 fd ff ff       	call   1030fe <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103326:	e8 1b f8 ff ff       	call   102b46 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10332b:	e8 63 0a 00 00       	call   103d93 <check_boot_pgdir>

    print_pgdir();
  103330:	e8 e8 0e 00 00       	call   10421d <print_pgdir>

}
  103335:	90                   	nop
  103336:	c9                   	leave  
  103337:	c3                   	ret    

00103338 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103338:	f3 0f 1e fb          	endbr32 
  10333c:	55                   	push   %ebp
  10333d:	89 e5                	mov    %esp,%ebp
  10333f:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la);
  103342:	8b 45 0c             	mov    0xc(%ebp),%eax
  103345:	c1 e8 16             	shr    $0x16,%eax
  103348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10334f:	8b 45 08             	mov    0x8(%ebp),%eax
  103352:	01 d0                	add    %edx,%eax
  103354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *page;
    uintptr_t pa;
    if(!((*pdep)&PTE_P)){
  103357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335a:	8b 00                	mov    (%eax),%eax
  10335c:	83 e0 01             	and    $0x1,%eax
  10335f:	85 c0                	test   %eax,%eax
  103361:	0f 85 bb 00 00 00    	jne    103422 <get_pte+0xea>
        if(!create){
  103367:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10336b:	75 0a                	jne    103377 <get_pte+0x3f>
            return NULL;
  10336d:	b8 00 00 00 00       	mov    $0x0,%eax
  103372:	e9 1c 01 00 00       	jmp    103493 <get_pte+0x15b>
        }
        page=alloc_page();
  103377:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10337e:	e8 0d f9 ff ff       	call   102c90 <alloc_pages>
  103383:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if(page==NULL){
  103386:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10338a:	75 0a                	jne    103396 <get_pte+0x5e>
            return NULL;
  10338c:	b8 00 00 00 00       	mov    $0x0,%eax
  103391:	e9 fd 00 00 00       	jmp    103493 <get_pte+0x15b>
        }
        set_page_ref(page,1);
  103396:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10339d:	00 
  10339e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a1:	89 04 24             	mov    %eax,(%esp)
  1033a4:	e8 db f6 ff ff       	call   102a84 <set_page_ref>
        pa = page2pa(page);
  1033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ac:	89 04 24             	mov    %eax,(%esp)
  1033af:	e8 b7 f5 ff ff       	call   10296b <page2pa>
  1033b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        *pdep=pa|PTE_P|PTE_W|PTE_U;
  1033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033ba:	83 c8 07             	or     $0x7,%eax
  1033bd:	89 c2                	mov    %eax,%edx
  1033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c2:	89 10                	mov    %edx,(%eax)
        memset(KADDR(pa),0x0,PGSIZE);
  1033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033cd:	c1 e8 0c             	shr    $0xc,%eax
  1033d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033d3:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1033d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1033db:	72 23                	jb     103400 <get_pte+0xc8>
  1033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033e4:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1033eb:	00 
  1033ec:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
  1033f3:	00 
  1033f4:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1033fb:	e8 26 d0 ff ff       	call   100426 <__panic>
  103400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103403:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103408:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10340f:	00 
  103410:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103417:	00 
  103418:	89 04 24             	mov    %eax,(%esp)
  10341b:	e8 b1 24 00 00       	call   1058d1 <memset>
  103420:	eb 0d                	jmp    10342f <get_pte+0xf7>
    }
    else{
        pa=(*pdep)&0xFFFFF000;
  103422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103425:	8b 00                	mov    (%eax),%eax
  103427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10342c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    pte_t *pte=pa;
  10342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103432:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pte=KADDR(pte+PTX(la));
  103435:	8b 45 0c             	mov    0xc(%ebp),%eax
  103438:	c1 e8 0c             	shr    $0xc,%eax
  10343b:	25 ff 03 00 00       	and    $0x3ff,%eax
  103440:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103447:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10344a:	01 d0                	add    %edx,%eax
  10344c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10344f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103452:	c1 e8 0c             	shr    $0xc,%eax
  103455:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103458:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10345d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103460:	72 23                	jb     103485 <get_pte+0x14d>
  103462:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103469:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103470:	00 
  103471:	c7 44 24 04 7e 01 00 	movl   $0x17e,0x4(%esp)
  103478:	00 
  103479:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103480:	e8 a1 cf ff ff       	call   100426 <__panic>
  103485:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103488:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10348d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return pte;
  103490:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
  103493:	c9                   	leave  
  103494:	c3                   	ret    

00103495 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103495:	f3 0f 1e fb          	endbr32 
  103499:	55                   	push   %ebp
  10349a:	89 e5                	mov    %esp,%ebp
  10349c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10349f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1034a6:	00 
  1034a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b1:	89 04 24             	mov    %eax,(%esp)
  1034b4:	e8 7f fe ff ff       	call   103338 <get_pte>
  1034b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1034bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1034c0:	74 08                	je     1034ca <get_page+0x35>
        *ptep_store = ptep;
  1034c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034c8:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1034ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034ce:	74 1b                	je     1034eb <get_page+0x56>
  1034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d3:	8b 00                	mov    (%eax),%eax
  1034d5:	83 e0 01             	and    $0x1,%eax
  1034d8:	85 c0                	test   %eax,%eax
  1034da:	74 0f                	je     1034eb <get_page+0x56>
        return pte2page(*ptep);
  1034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034df:	8b 00                	mov    (%eax),%eax
  1034e1:	89 04 24             	mov    %eax,(%esp)
  1034e4:	e8 3b f5 ff ff       	call   102a24 <pte2page>
  1034e9:	eb 05                	jmp    1034f0 <get_page+0x5b>
    }
    return NULL;
  1034eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034f0:	c9                   	leave  
  1034f1:	c3                   	ret    

001034f2 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034f2:	55                   	push   %ebp
  1034f3:	89 e5                	mov    %esp,%ebp
  1034f5:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(!((*ptep)&PTE_P)){
  1034f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1034fb:	8b 00                	mov    (%eax),%eax
  1034fd:	83 e0 01             	and    $0x1,%eax
  103500:	85 c0                	test   %eax,%eax
  103502:	74 62                	je     103566 <page_remove_pte+0x74>
        return;
    }
    struct Page *page = pte2page(*ptep);
  103504:	8b 45 10             	mov    0x10(%ebp),%eax
  103507:	8b 00                	mov    (%eax),%eax
  103509:	89 04 24             	mov    %eax,(%esp)
  10350c:	e8 13 f5 ff ff       	call   102a24 <pte2page>
  103511:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
  103514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103517:	89 04 24             	mov    %eax,(%esp)
  10351a:	e8 8a f5 ff ff       	call   102aa9 <page_ref_dec>
    if(page_ref(page)==0){
  10351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103522:	89 04 24             	mov    %eax,(%esp)
  103525:	e8 50 f5 ff ff       	call   102a7a <page_ref>
  10352a:	85 c0                	test   %eax,%eax
  10352c:	75 13                	jne    103541 <page_remove_pte+0x4f>
        free_page(page);
  10352e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103535:	00 
  103536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103539:	89 04 24             	mov    %eax,(%esp)
  10353c:	e8 8b f7 ff ff       	call   102ccc <free_pages>
    }
    *ptep=(*ptep)&0xFFFFF000;
  103541:	8b 45 10             	mov    0x10(%ebp),%eax
  103544:	8b 00                	mov    (%eax),%eax
  103546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10354b:	89 c2                	mov    %eax,%edx
  10354d:	8b 45 10             	mov    0x10(%ebp),%eax
  103550:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir,la);
  103552:	8b 45 0c             	mov    0xc(%ebp),%eax
  103555:	89 44 24 04          	mov    %eax,0x4(%esp)
  103559:	8b 45 08             	mov    0x8(%ebp),%eax
  10355c:	89 04 24             	mov    %eax,(%esp)
  10355f:	e8 0b 01 00 00       	call   10366f <tlb_invalidate>
  103564:	eb 01                	jmp    103567 <page_remove_pte+0x75>
        return;
  103566:	90                   	nop
}
  103567:	c9                   	leave  
  103568:	c3                   	ret    

00103569 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103569:	f3 0f 1e fb          	endbr32 
  10356d:	55                   	push   %ebp
  10356e:	89 e5                	mov    %esp,%ebp
  103570:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103573:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10357a:	00 
  10357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103582:	8b 45 08             	mov    0x8(%ebp),%eax
  103585:	89 04 24             	mov    %eax,(%esp)
  103588:	e8 ab fd ff ff       	call   103338 <get_pte>
  10358d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103594:	74 19                	je     1035af <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  103596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103599:	89 44 24 08          	mov    %eax,0x8(%esp)
  10359d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a7:	89 04 24             	mov    %eax,(%esp)
  1035aa:	e8 43 ff ff ff       	call   1034f2 <page_remove_pte>
    }
}
  1035af:	90                   	nop
  1035b0:	c9                   	leave  
  1035b1:	c3                   	ret    

001035b2 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1035b2:	f3 0f 1e fb          	endbr32 
  1035b6:	55                   	push   %ebp
  1035b7:	89 e5                	mov    %esp,%ebp
  1035b9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1035bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1035c3:	00 
  1035c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1035c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ce:	89 04 24             	mov    %eax,(%esp)
  1035d1:	e8 62 fd ff ff       	call   103338 <get_pte>
  1035d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1035d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035dd:	75 0a                	jne    1035e9 <page_insert+0x37>
        return -E_NO_MEM;
  1035df:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1035e4:	e9 84 00 00 00       	jmp    10366d <page_insert+0xbb>
    }
    page_ref_inc(page);
  1035e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ec:	89 04 24             	mov    %eax,(%esp)
  1035ef:	e8 9e f4 ff ff       	call   102a92 <page_ref_inc>
    if (*ptep & PTE_P) {
  1035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035f7:	8b 00                	mov    (%eax),%eax
  1035f9:	83 e0 01             	and    $0x1,%eax
  1035fc:	85 c0                	test   %eax,%eax
  1035fe:	74 3e                	je     10363e <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  103600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103603:	8b 00                	mov    (%eax),%eax
  103605:	89 04 24             	mov    %eax,(%esp)
  103608:	e8 17 f4 ff ff       	call   102a24 <pte2page>
  10360d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103613:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103616:	75 0d                	jne    103625 <page_insert+0x73>
            page_ref_dec(page);
  103618:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361b:	89 04 24             	mov    %eax,(%esp)
  10361e:	e8 86 f4 ff ff       	call   102aa9 <page_ref_dec>
  103623:	eb 19                	jmp    10363e <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103628:	89 44 24 08          	mov    %eax,0x8(%esp)
  10362c:	8b 45 10             	mov    0x10(%ebp),%eax
  10362f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103633:	8b 45 08             	mov    0x8(%ebp),%eax
  103636:	89 04 24             	mov    %eax,(%esp)
  103639:	e8 b4 fe ff ff       	call   1034f2 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10363e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103641:	89 04 24             	mov    %eax,(%esp)
  103644:	e8 22 f3 ff ff       	call   10296b <page2pa>
  103649:	0b 45 14             	or     0x14(%ebp),%eax
  10364c:	83 c8 01             	or     $0x1,%eax
  10364f:	89 c2                	mov    %eax,%edx
  103651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103654:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103656:	8b 45 10             	mov    0x10(%ebp),%eax
  103659:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365d:	8b 45 08             	mov    0x8(%ebp),%eax
  103660:	89 04 24             	mov    %eax,(%esp)
  103663:	e8 07 00 00 00       	call   10366f <tlb_invalidate>
    return 0;
  103668:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10366d:	c9                   	leave  
  10366e:	c3                   	ret    

0010366f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10366f:	f3 0f 1e fb          	endbr32 
  103673:	55                   	push   %ebp
  103674:	89 e5                	mov    %esp,%ebp
  103676:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103679:	0f 20 d8             	mov    %cr3,%eax
  10367c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10367f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103682:	8b 45 08             	mov    0x8(%ebp),%eax
  103685:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103688:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10368f:	77 23                	ja     1036b4 <tlb_invalidate+0x45>
  103691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103694:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103698:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  10369f:	00 
  1036a0:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  1036a7:	00 
  1036a8:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1036af:	e8 72 cd ff ff       	call   100426 <__panic>
  1036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036b7:	05 00 00 00 40       	add    $0x40000000,%eax
  1036bc:	39 d0                	cmp    %edx,%eax
  1036be:	75 0d                	jne    1036cd <tlb_invalidate+0x5e>
        invlpg((void *)la);
  1036c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1036c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036c9:	0f 01 38             	invlpg (%eax)
}
  1036cc:	90                   	nop
    }
}
  1036cd:	90                   	nop
  1036ce:	c9                   	leave  
  1036cf:	c3                   	ret    

001036d0 <check_alloc_page>:

static void
check_alloc_page(void) {
  1036d0:	f3 0f 1e fb          	endbr32 
  1036d4:	55                   	push   %ebp
  1036d5:	89 e5                	mov    %esp,%ebp
  1036d7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1036da:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  1036df:	8b 40 18             	mov    0x18(%eax),%eax
  1036e2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1036e4:	c7 04 24 68 69 10 00 	movl   $0x106968,(%esp)
  1036eb:	e8 ca cb ff ff       	call   1002ba <cprintf>
}
  1036f0:	90                   	nop
  1036f1:	c9                   	leave  
  1036f2:	c3                   	ret    

001036f3 <check_pgdir>:

static void
check_pgdir(void) {
  1036f3:	f3 0f 1e fb          	endbr32 
  1036f7:	55                   	push   %ebp
  1036f8:	89 e5                	mov    %esp,%ebp
  1036fa:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036fd:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103702:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103707:	76 24                	jbe    10372d <check_pgdir+0x3a>
  103709:	c7 44 24 0c 87 69 10 	movl   $0x106987,0xc(%esp)
  103710:	00 
  103711:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103718:	00 
  103719:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103720:	00 
  103721:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103728:	e8 f9 cc ff ff       	call   100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10372d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103732:	85 c0                	test   %eax,%eax
  103734:	74 0e                	je     103744 <check_pgdir+0x51>
  103736:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10373b:	25 ff 0f 00 00       	and    $0xfff,%eax
  103740:	85 c0                	test   %eax,%eax
  103742:	74 24                	je     103768 <check_pgdir+0x75>
  103744:	c7 44 24 0c a4 69 10 	movl   $0x1069a4,0xc(%esp)
  10374b:	00 
  10374c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103753:	00 
  103754:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  10375b:	00 
  10375c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103763:	e8 be cc ff ff       	call   100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103768:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10376d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103774:	00 
  103775:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10377c:	00 
  10377d:	89 04 24             	mov    %eax,(%esp)
  103780:	e8 10 fd ff ff       	call   103495 <get_page>
  103785:	85 c0                	test   %eax,%eax
  103787:	74 24                	je     1037ad <check_pgdir+0xba>
  103789:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  103790:	00 
  103791:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103798:	00 
  103799:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1037a0:	00 
  1037a1:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1037a8:	e8 79 cc ff ff       	call   100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1037ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037b4:	e8 d7 f4 ff ff       	call   102c90 <alloc_pages>
  1037b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1037bc:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1037c8:	00 
  1037c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037d0:	00 
  1037d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1037d8:	89 04 24             	mov    %eax,(%esp)
  1037db:	e8 d2 fd ff ff       	call   1035b2 <page_insert>
  1037e0:	85 c0                	test   %eax,%eax
  1037e2:	74 24                	je     103808 <check_pgdir+0x115>
  1037e4:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  1037eb:	00 
  1037ec:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1037f3:	00 
  1037f4:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1037fb:	00 
  1037fc:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103803:	e8 1e cc ff ff       	call   100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103808:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10380d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103814:	00 
  103815:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10381c:	00 
  10381d:	89 04 24             	mov    %eax,(%esp)
  103820:	e8 13 fb ff ff       	call   103338 <get_pte>
  103825:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103828:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10382c:	75 24                	jne    103852 <check_pgdir+0x15f>
  10382e:	c7 44 24 0c 30 6a 10 	movl   $0x106a30,0xc(%esp)
  103835:	00 
  103836:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10383d:	00 
  10383e:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103845:	00 
  103846:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10384d:	e8 d4 cb ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103855:	8b 00                	mov    (%eax),%eax
  103857:	89 04 24             	mov    %eax,(%esp)
  10385a:	e8 c5 f1 ff ff       	call   102a24 <pte2page>
  10385f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103862:	74 24                	je     103888 <check_pgdir+0x195>
  103864:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  10386b:	00 
  10386c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103873:	00 
  103874:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  10387b:	00 
  10387c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103883:	e8 9e cb ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 1);
  103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10388b:	89 04 24             	mov    %eax,(%esp)
  10388e:	e8 e7 f1 ff ff       	call   102a7a <page_ref>
  103893:	83 f8 01             	cmp    $0x1,%eax
  103896:	74 24                	je     1038bc <check_pgdir+0x1c9>
  103898:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  10389f:	00 
  1038a0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1038a7:	00 
  1038a8:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  1038af:	00 
  1038b0:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1038b7:	e8 6a cb ff ff       	call   100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1038bc:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038c1:	8b 00                	mov    (%eax),%eax
  1038c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1038c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038ce:	c1 e8 0c             	shr    $0xc,%eax
  1038d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1038d4:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1038d9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1038dc:	72 23                	jb     103901 <check_pgdir+0x20e>
  1038de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038e5:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1038ec:	00 
  1038ed:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1038f4:	00 
  1038f5:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1038fc:	e8 25 cb ff ff       	call   100426 <__panic>
  103901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103904:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103909:	83 c0 04             	add    $0x4,%eax
  10390c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10390f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103914:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10391b:	00 
  10391c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103923:	00 
  103924:	89 04 24             	mov    %eax,(%esp)
  103927:	e8 0c fa ff ff       	call   103338 <get_pte>
  10392c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10392f:	74 24                	je     103955 <check_pgdir+0x262>
  103931:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  103938:	00 
  103939:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103940:	00 
  103941:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103948:	00 
  103949:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103950:	e8 d1 ca ff ff       	call   100426 <__panic>

    p2 = alloc_page();
  103955:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10395c:	e8 2f f3 ff ff       	call   102c90 <alloc_pages>
  103961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103964:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103969:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103970:	00 
  103971:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103978:	00 
  103979:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10397c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103980:	89 04 24             	mov    %eax,(%esp)
  103983:	e8 2a fc ff ff       	call   1035b2 <page_insert>
  103988:	85 c0                	test   %eax,%eax
  10398a:	74 24                	je     1039b0 <check_pgdir+0x2bd>
  10398c:	c7 44 24 0c b0 6a 10 	movl   $0x106ab0,0xc(%esp)
  103993:	00 
  103994:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10399b:	00 
  10399c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  1039a3:	00 
  1039a4:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1039ab:	e8 76 ca ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1039b0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1039b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039bc:	00 
  1039bd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039c4:	00 
  1039c5:	89 04 24             	mov    %eax,(%esp)
  1039c8:	e8 6b f9 ff ff       	call   103338 <get_pte>
  1039cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039d4:	75 24                	jne    1039fa <check_pgdir+0x307>
  1039d6:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  1039dd:	00 
  1039de:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1039e5:	00 
  1039e6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1039ed:	00 
  1039ee:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1039f5:	e8 2c ca ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_U);
  1039fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039fd:	8b 00                	mov    (%eax),%eax
  1039ff:	83 e0 04             	and    $0x4,%eax
  103a02:	85 c0                	test   %eax,%eax
  103a04:	75 24                	jne    103a2a <check_pgdir+0x337>
  103a06:	c7 44 24 0c 18 6b 10 	movl   $0x106b18,0xc(%esp)
  103a0d:	00 
  103a0e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a15:	00 
  103a16:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103a1d:	00 
  103a1e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a25:	e8 fc c9 ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_W);
  103a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a2d:	8b 00                	mov    (%eax),%eax
  103a2f:	83 e0 02             	and    $0x2,%eax
  103a32:	85 c0                	test   %eax,%eax
  103a34:	75 24                	jne    103a5a <check_pgdir+0x367>
  103a36:	c7 44 24 0c 26 6b 10 	movl   $0x106b26,0xc(%esp)
  103a3d:	00 
  103a3e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a45:	00 
  103a46:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103a4d:	00 
  103a4e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a55:	e8 cc c9 ff ff       	call   100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103a5a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a5f:	8b 00                	mov    (%eax),%eax
  103a61:	83 e0 04             	and    $0x4,%eax
  103a64:	85 c0                	test   %eax,%eax
  103a66:	75 24                	jne    103a8c <check_pgdir+0x399>
  103a68:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103a6f:	00 
  103a70:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a77:	00 
  103a78:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103a7f:	00 
  103a80:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a87:	e8 9a c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 1);
  103a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a8f:	89 04 24             	mov    %eax,(%esp)
  103a92:	e8 e3 ef ff ff       	call   102a7a <page_ref>
  103a97:	83 f8 01             	cmp    $0x1,%eax
  103a9a:	74 24                	je     103ac0 <check_pgdir+0x3cd>
  103a9c:	c7 44 24 0c 4a 6b 10 	movl   $0x106b4a,0xc(%esp)
  103aa3:	00 
  103aa4:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103aab:	00 
  103aac:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103ab3:	00 
  103ab4:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103abb:	e8 66 c9 ff ff       	call   100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103ac0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ac5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103acc:	00 
  103acd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103ad4:	00 
  103ad5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ad8:	89 54 24 04          	mov    %edx,0x4(%esp)
  103adc:	89 04 24             	mov    %eax,(%esp)
  103adf:	e8 ce fa ff ff       	call   1035b2 <page_insert>
  103ae4:	85 c0                	test   %eax,%eax
  103ae6:	74 24                	je     103b0c <check_pgdir+0x419>
  103ae8:	c7 44 24 0c 5c 6b 10 	movl   $0x106b5c,0xc(%esp)
  103aef:	00 
  103af0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103af7:	00 
  103af8:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103aff:	00 
  103b00:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b07:	e8 1a c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 2);
  103b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b0f:	89 04 24             	mov    %eax,(%esp)
  103b12:	e8 63 ef ff ff       	call   102a7a <page_ref>
  103b17:	83 f8 02             	cmp    $0x2,%eax
  103b1a:	74 24                	je     103b40 <check_pgdir+0x44d>
  103b1c:	c7 44 24 0c 88 6b 10 	movl   $0x106b88,0xc(%esp)
  103b23:	00 
  103b24:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b2b:	00 
  103b2c:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103b33:	00 
  103b34:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b3b:	e8 e6 c8 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103b40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b43:	89 04 24             	mov    %eax,(%esp)
  103b46:	e8 2f ef ff ff       	call   102a7a <page_ref>
  103b4b:	85 c0                	test   %eax,%eax
  103b4d:	74 24                	je     103b73 <check_pgdir+0x480>
  103b4f:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103b56:	00 
  103b57:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b5e:	00 
  103b5f:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103b66:	00 
  103b67:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b6e:	e8 b3 c8 ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b73:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b7f:	00 
  103b80:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b87:	00 
  103b88:	89 04 24             	mov    %eax,(%esp)
  103b8b:	e8 a8 f7 ff ff       	call   103338 <get_pte>
  103b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b97:	75 24                	jne    103bbd <check_pgdir+0x4ca>
  103b99:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  103ba0:	00 
  103ba1:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ba8:	00 
  103ba9:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103bb0:	00 
  103bb1:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103bb8:	e8 69 c8 ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bc0:	8b 00                	mov    (%eax),%eax
  103bc2:	89 04 24             	mov    %eax,(%esp)
  103bc5:	e8 5a ee ff ff       	call   102a24 <pte2page>
  103bca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103bcd:	74 24                	je     103bf3 <check_pgdir+0x500>
  103bcf:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  103bd6:	00 
  103bd7:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103bde:	00 
  103bdf:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103be6:	00 
  103be7:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103bee:	e8 33 c8 ff ff       	call   100426 <__panic>
    assert((*ptep & PTE_U) == 0);
  103bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bf6:	8b 00                	mov    (%eax),%eax
  103bf8:	83 e0 04             	and    $0x4,%eax
  103bfb:	85 c0                	test   %eax,%eax
  103bfd:	74 24                	je     103c23 <check_pgdir+0x530>
  103bff:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  103c06:	00 
  103c07:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c0e:	00 
  103c0f:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103c16:	00 
  103c17:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c1e:	e8 03 c8 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, 0x0);
  103c23:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c2f:	00 
  103c30:	89 04 24             	mov    %eax,(%esp)
  103c33:	e8 31 f9 ff ff       	call   103569 <page_remove>
    assert(page_ref(p1) == 1);
  103c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c3b:	89 04 24             	mov    %eax,(%esp)
  103c3e:	e8 37 ee ff ff       	call   102a7a <page_ref>
  103c43:	83 f8 01             	cmp    $0x1,%eax
  103c46:	74 24                	je     103c6c <check_pgdir+0x579>
  103c48:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  103c4f:	00 
  103c50:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c57:	00 
  103c58:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103c5f:	00 
  103c60:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c67:	e8 ba c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c6f:	89 04 24             	mov    %eax,(%esp)
  103c72:	e8 03 ee ff ff       	call   102a7a <page_ref>
  103c77:	85 c0                	test   %eax,%eax
  103c79:	74 24                	je     103c9f <check_pgdir+0x5ac>
  103c7b:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103c82:	00 
  103c83:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c8a:	00 
  103c8b:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  103c92:	00 
  103c93:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c9a:	e8 87 c7 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103c9f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ca4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103cab:	00 
  103cac:	89 04 24             	mov    %eax,(%esp)
  103caf:	e8 b5 f8 ff ff       	call   103569 <page_remove>
    assert(page_ref(p1) == 0);
  103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb7:	89 04 24             	mov    %eax,(%esp)
  103cba:	e8 bb ed ff ff       	call   102a7a <page_ref>
  103cbf:	85 c0                	test   %eax,%eax
  103cc1:	74 24                	je     103ce7 <check_pgdir+0x5f4>
  103cc3:	c7 44 24 0c c1 6b 10 	movl   $0x106bc1,0xc(%esp)
  103cca:	00 
  103ccb:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103cd2:	00 
  103cd3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103cda:	00 
  103cdb:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ce2:	e8 3f c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cea:	89 04 24             	mov    %eax,(%esp)
  103ced:	e8 88 ed ff ff       	call   102a7a <page_ref>
  103cf2:	85 c0                	test   %eax,%eax
  103cf4:	74 24                	je     103d1a <check_pgdir+0x627>
  103cf6:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103cfd:	00 
  103cfe:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103d05:	00 
  103d06:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  103d0d:	00 
  103d0e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d15:	e8 0c c7 ff ff       	call   100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103d1a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d1f:	8b 00                	mov    (%eax),%eax
  103d21:	89 04 24             	mov    %eax,(%esp)
  103d24:	e8 39 ed ff ff       	call   102a62 <pde2page>
  103d29:	89 04 24             	mov    %eax,(%esp)
  103d2c:	e8 49 ed ff ff       	call   102a7a <page_ref>
  103d31:	83 f8 01             	cmp    $0x1,%eax
  103d34:	74 24                	je     103d5a <check_pgdir+0x667>
  103d36:	c7 44 24 0c d4 6b 10 	movl   $0x106bd4,0xc(%esp)
  103d3d:	00 
  103d3e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103d45:	00 
  103d46:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103d4d:	00 
  103d4e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d55:	e8 cc c6 ff ff       	call   100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d5a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d5f:	8b 00                	mov    (%eax),%eax
  103d61:	89 04 24             	mov    %eax,(%esp)
  103d64:	e8 f9 ec ff ff       	call   102a62 <pde2page>
  103d69:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103d70:	00 
  103d71:	89 04 24             	mov    %eax,(%esp)
  103d74:	e8 53 ef ff ff       	call   102ccc <free_pages>
    boot_pgdir[0] = 0;
  103d79:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103d84:	c7 04 24 fb 6b 10 00 	movl   $0x106bfb,(%esp)
  103d8b:	e8 2a c5 ff ff       	call   1002ba <cprintf>
}
  103d90:	90                   	nop
  103d91:	c9                   	leave  
  103d92:	c3                   	ret    

00103d93 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103d93:	f3 0f 1e fb          	endbr32 
  103d97:	55                   	push   %ebp
  103d98:	89 e5                	mov    %esp,%ebp
  103d9a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103d9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103da4:	e9 ca 00 00 00       	jmp    103e73 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103db2:	c1 e8 0c             	shr    $0xc,%eax
  103db5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103db8:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103dbd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103dc0:	72 23                	jb     103de5 <check_boot_pgdir+0x52>
  103dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103dc9:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103dd0:	00 
  103dd1:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103dd8:	00 
  103dd9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103de0:	e8 41 c6 ff ff       	call   100426 <__panic>
  103de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103de8:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103ded:	89 c2                	mov    %eax,%edx
  103def:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103df4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103dfb:	00 
  103dfc:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e00:	89 04 24             	mov    %eax,(%esp)
  103e03:	e8 30 f5 ff ff       	call   103338 <get_pte>
  103e08:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103e0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103e0f:	75 24                	jne    103e35 <check_boot_pgdir+0xa2>
  103e11:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  103e18:	00 
  103e19:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103e20:	00 
  103e21:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103e28:	00 
  103e29:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e30:	e8 f1 c5 ff ff       	call   100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e38:	8b 00                	mov    (%eax),%eax
  103e3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e3f:	89 c2                	mov    %eax,%edx
  103e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e44:	39 c2                	cmp    %eax,%edx
  103e46:	74 24                	je     103e6c <check_boot_pgdir+0xd9>
  103e48:	c7 44 24 0c 55 6c 10 	movl   $0x106c55,0xc(%esp)
  103e4f:	00 
  103e50:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103e57:	00 
  103e58:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  103e5f:	00 
  103e60:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e67:	e8 ba c5 ff ff       	call   100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103e6c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e76:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103e7b:	39 c2                	cmp    %eax,%edx
  103e7d:	0f 82 26 ff ff ff    	jb     103da9 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103e83:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e88:	05 ac 0f 00 00       	add    $0xfac,%eax
  103e8d:	8b 00                	mov    (%eax),%eax
  103e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e94:	89 c2                	mov    %eax,%edx
  103e96:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e9e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103ea5:	77 23                	ja     103eca <check_boot_pgdir+0x137>
  103ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103eaa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103eae:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103eb5:	00 
  103eb6:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  103ebd:	00 
  103ebe:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ec5:	e8 5c c5 ff ff       	call   100426 <__panic>
  103eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ecd:	05 00 00 00 40       	add    $0x40000000,%eax
  103ed2:	39 d0                	cmp    %edx,%eax
  103ed4:	74 24                	je     103efa <check_boot_pgdir+0x167>
  103ed6:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  103edd:	00 
  103ede:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ee5:	00 
  103ee6:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  103eed:	00 
  103eee:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ef5:	e8 2c c5 ff ff       	call   100426 <__panic>

    assert(boot_pgdir[0] == 0);
  103efa:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103eff:	8b 00                	mov    (%eax),%eax
  103f01:	85 c0                	test   %eax,%eax
  103f03:	74 24                	je     103f29 <check_boot_pgdir+0x196>
  103f05:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  103f0c:	00 
  103f0d:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f14:	00 
  103f15:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  103f1c:	00 
  103f1d:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f24:	e8 fd c4 ff ff       	call   100426 <__panic>

    struct Page *p;
    p = alloc_page();
  103f29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f30:	e8 5b ed ff ff       	call   102c90 <alloc_pages>
  103f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103f38:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f3d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103f44:	00 
  103f45:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103f4c:	00 
  103f4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103f50:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f54:	89 04 24             	mov    %eax,(%esp)
  103f57:	e8 56 f6 ff ff       	call   1035b2 <page_insert>
  103f5c:	85 c0                	test   %eax,%eax
  103f5e:	74 24                	je     103f84 <check_boot_pgdir+0x1f1>
  103f60:	c7 44 24 0c b4 6c 10 	movl   $0x106cb4,0xc(%esp)
  103f67:	00 
  103f68:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f6f:	00 
  103f70:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  103f77:	00 
  103f78:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f7f:	e8 a2 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 1);
  103f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f87:	89 04 24             	mov    %eax,(%esp)
  103f8a:	e8 eb ea ff ff       	call   102a7a <page_ref>
  103f8f:	83 f8 01             	cmp    $0x1,%eax
  103f92:	74 24                	je     103fb8 <check_boot_pgdir+0x225>
  103f94:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  103f9b:	00 
  103f9c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103fa3:	00 
  103fa4:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  103fab:	00 
  103fac:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103fb3:	e8 6e c4 ff ff       	call   100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103fb8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103fbd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fc4:	00 
  103fc5:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103fcc:	00 
  103fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fd0:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fd4:	89 04 24             	mov    %eax,(%esp)
  103fd7:	e8 d6 f5 ff ff       	call   1035b2 <page_insert>
  103fdc:	85 c0                	test   %eax,%eax
  103fde:	74 24                	je     104004 <check_boot_pgdir+0x271>
  103fe0:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  103fe7:	00 
  103fe8:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103fef:	00 
  103ff0:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  103ff7:	00 
  103ff8:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103fff:	e8 22 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 2);
  104004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104007:	89 04 24             	mov    %eax,(%esp)
  10400a:	e8 6b ea ff ff       	call   102a7a <page_ref>
  10400f:	83 f8 02             	cmp    $0x2,%eax
  104012:	74 24                	je     104038 <check_boot_pgdir+0x2a5>
  104014:	c7 44 24 0c 2b 6d 10 	movl   $0x106d2b,0xc(%esp)
  10401b:	00 
  10401c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  104023:	00 
  104024:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  10402b:	00 
  10402c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  104033:	e8 ee c3 ff ff       	call   100426 <__panic>

    const char *str = "ucore: Hello world!!";
  104038:	c7 45 e8 3c 6d 10 00 	movl   $0x106d3c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10403f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104042:	89 44 24 04          	mov    %eax,0x4(%esp)
  104046:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10404d:	e8 9b 15 00 00       	call   1055ed <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104052:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104059:	00 
  10405a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104061:	e8 05 16 00 00       	call   10566b <strcmp>
  104066:	85 c0                	test   %eax,%eax
  104068:	74 24                	je     10408e <check_boot_pgdir+0x2fb>
  10406a:	c7 44 24 0c 54 6d 10 	movl   $0x106d54,0xc(%esp)
  104071:	00 
  104072:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  104079:	00 
  10407a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104081:	00 
  104082:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  104089:	e8 98 c3 ff ff       	call   100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10408e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104091:	89 04 24             	mov    %eax,(%esp)
  104094:	e8 37 e9 ff ff       	call   1029d0 <page2kva>
  104099:	05 00 01 00 00       	add    $0x100,%eax
  10409e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1040a1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040a8:	e8 e2 14 00 00       	call   10558f <strlen>
  1040ad:	85 c0                	test   %eax,%eax
  1040af:	74 24                	je     1040d5 <check_boot_pgdir+0x342>
  1040b1:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  1040b8:	00 
  1040b9:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1040c0:	00 
  1040c1:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1040c8:	00 
  1040c9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1040d0:	e8 51 c3 ff ff       	call   100426 <__panic>

    free_page(p);
  1040d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040dc:	00 
  1040dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040e0:	89 04 24             	mov    %eax,(%esp)
  1040e3:	e8 e4 eb ff ff       	call   102ccc <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1040e8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040ed:	8b 00                	mov    (%eax),%eax
  1040ef:	89 04 24             	mov    %eax,(%esp)
  1040f2:	e8 6b e9 ff ff       	call   102a62 <pde2page>
  1040f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040fe:	00 
  1040ff:	89 04 24             	mov    %eax,(%esp)
  104102:	e8 c5 eb ff ff       	call   102ccc <free_pages>
    boot_pgdir[0] = 0;
  104107:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10410c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104112:	c7 04 24 b0 6d 10 00 	movl   $0x106db0,(%esp)
  104119:	e8 9c c1 ff ff       	call   1002ba <cprintf>
}
  10411e:	90                   	nop
  10411f:	c9                   	leave  
  104120:	c3                   	ret    

00104121 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104121:	f3 0f 1e fb          	endbr32 
  104125:	55                   	push   %ebp
  104126:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104128:	8b 45 08             	mov    0x8(%ebp),%eax
  10412b:	83 e0 04             	and    $0x4,%eax
  10412e:	85 c0                	test   %eax,%eax
  104130:	74 04                	je     104136 <perm2str+0x15>
  104132:	b0 75                	mov    $0x75,%al
  104134:	eb 02                	jmp    104138 <perm2str+0x17>
  104136:	b0 2d                	mov    $0x2d,%al
  104138:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  10413d:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104144:	8b 45 08             	mov    0x8(%ebp),%eax
  104147:	83 e0 02             	and    $0x2,%eax
  10414a:	85 c0                	test   %eax,%eax
  10414c:	74 04                	je     104152 <perm2str+0x31>
  10414e:	b0 77                	mov    $0x77,%al
  104150:	eb 02                	jmp    104154 <perm2str+0x33>
  104152:	b0 2d                	mov    $0x2d,%al
  104154:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  104159:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  104160:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  104165:	5d                   	pop    %ebp
  104166:	c3                   	ret    

00104167 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104167:	f3 0f 1e fb          	endbr32 
  10416b:	55                   	push   %ebp
  10416c:	89 e5                	mov    %esp,%ebp
  10416e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104171:	8b 45 10             	mov    0x10(%ebp),%eax
  104174:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104177:	72 0d                	jb     104186 <get_pgtable_items+0x1f>
        return 0;
  104179:	b8 00 00 00 00       	mov    $0x0,%eax
  10417e:	e9 98 00 00 00       	jmp    10421b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104183:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104186:	8b 45 10             	mov    0x10(%ebp),%eax
  104189:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10418c:	73 18                	jae    1041a6 <get_pgtable_items+0x3f>
  10418e:	8b 45 10             	mov    0x10(%ebp),%eax
  104191:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104198:	8b 45 14             	mov    0x14(%ebp),%eax
  10419b:	01 d0                	add    %edx,%eax
  10419d:	8b 00                	mov    (%eax),%eax
  10419f:	83 e0 01             	and    $0x1,%eax
  1041a2:	85 c0                	test   %eax,%eax
  1041a4:	74 dd                	je     104183 <get_pgtable_items+0x1c>
    }
    if (start < right) {
  1041a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1041a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041ac:	73 68                	jae    104216 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1041ae:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1041b2:	74 08                	je     1041bc <get_pgtable_items+0x55>
            *left_store = start;
  1041b4:	8b 45 18             	mov    0x18(%ebp),%eax
  1041b7:	8b 55 10             	mov    0x10(%ebp),%edx
  1041ba:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1041bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1041bf:	8d 50 01             	lea    0x1(%eax),%edx
  1041c2:	89 55 10             	mov    %edx,0x10(%ebp)
  1041c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041cc:	8b 45 14             	mov    0x14(%ebp),%eax
  1041cf:	01 d0                	add    %edx,%eax
  1041d1:	8b 00                	mov    (%eax),%eax
  1041d3:	83 e0 07             	and    $0x7,%eax
  1041d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1041d9:	eb 03                	jmp    1041de <get_pgtable_items+0x77>
            start ++;
  1041db:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1041de:	8b 45 10             	mov    0x10(%ebp),%eax
  1041e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041e4:	73 1d                	jae    104203 <get_pgtable_items+0x9c>
  1041e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1041e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041f0:	8b 45 14             	mov    0x14(%ebp),%eax
  1041f3:	01 d0                	add    %edx,%eax
  1041f5:	8b 00                	mov    (%eax),%eax
  1041f7:	83 e0 07             	and    $0x7,%eax
  1041fa:	89 c2                	mov    %eax,%edx
  1041fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041ff:	39 c2                	cmp    %eax,%edx
  104201:	74 d8                	je     1041db <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  104203:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104207:	74 08                	je     104211 <get_pgtable_items+0xaa>
            *right_store = start;
  104209:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10420c:	8b 55 10             	mov    0x10(%ebp),%edx
  10420f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104211:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104214:	eb 05                	jmp    10421b <get_pgtable_items+0xb4>
    }
    return 0;
  104216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10421b:	c9                   	leave  
  10421c:	c3                   	ret    

0010421d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10421d:	f3 0f 1e fb          	endbr32 
  104221:	55                   	push   %ebp
  104222:	89 e5                	mov    %esp,%ebp
  104224:	57                   	push   %edi
  104225:	56                   	push   %esi
  104226:	53                   	push   %ebx
  104227:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10422a:	c7 04 24 d0 6d 10 00 	movl   $0x106dd0,(%esp)
  104231:	e8 84 c0 ff ff       	call   1002ba <cprintf>
    size_t left, right = 0, perm;
  104236:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10423d:	e9 fa 00 00 00       	jmp    10433c <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104245:	89 04 24             	mov    %eax,(%esp)
  104248:	e8 d4 fe ff ff       	call   104121 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10424d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104250:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104253:	29 d1                	sub    %edx,%ecx
  104255:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104257:	89 d6                	mov    %edx,%esi
  104259:	c1 e6 16             	shl    $0x16,%esi
  10425c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10425f:	89 d3                	mov    %edx,%ebx
  104261:	c1 e3 16             	shl    $0x16,%ebx
  104264:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104267:	89 d1                	mov    %edx,%ecx
  104269:	c1 e1 16             	shl    $0x16,%ecx
  10426c:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10426f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104272:	29 d7                	sub    %edx,%edi
  104274:	89 fa                	mov    %edi,%edx
  104276:	89 44 24 14          	mov    %eax,0x14(%esp)
  10427a:	89 74 24 10          	mov    %esi,0x10(%esp)
  10427e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104282:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104286:	89 54 24 04          	mov    %edx,0x4(%esp)
  10428a:	c7 04 24 01 6e 10 00 	movl   $0x106e01,(%esp)
  104291:	e8 24 c0 ff ff       	call   1002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
  104296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104299:	c1 e0 0a             	shl    $0xa,%eax
  10429c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10429f:	eb 54                	jmp    1042f5 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1042a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042a4:	89 04 24             	mov    %eax,(%esp)
  1042a7:	e8 75 fe ff ff       	call   104121 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1042ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1042af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042b2:	29 d1                	sub    %edx,%ecx
  1042b4:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1042b6:	89 d6                	mov    %edx,%esi
  1042b8:	c1 e6 0c             	shl    $0xc,%esi
  1042bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042be:	89 d3                	mov    %edx,%ebx
  1042c0:	c1 e3 0c             	shl    $0xc,%ebx
  1042c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042c6:	89 d1                	mov    %edx,%ecx
  1042c8:	c1 e1 0c             	shl    $0xc,%ecx
  1042cb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1042ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042d1:	29 d7                	sub    %edx,%edi
  1042d3:	89 fa                	mov    %edi,%edx
  1042d5:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042d9:	89 74 24 10          	mov    %esi,0x10(%esp)
  1042dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1042e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1042e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042e9:	c7 04 24 20 6e 10 00 	movl   $0x106e20,(%esp)
  1042f0:	e8 c5 bf ff ff       	call   1002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1042f5:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1042fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1042fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104300:	89 d3                	mov    %edx,%ebx
  104302:	c1 e3 0a             	shl    $0xa,%ebx
  104305:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104308:	89 d1                	mov    %edx,%ecx
  10430a:	c1 e1 0a             	shl    $0xa,%ecx
  10430d:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104310:	89 54 24 14          	mov    %edx,0x14(%esp)
  104314:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104317:	89 54 24 10          	mov    %edx,0x10(%esp)
  10431b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10431f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104323:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104327:	89 0c 24             	mov    %ecx,(%esp)
  10432a:	e8 38 fe ff ff       	call   104167 <get_pgtable_items>
  10432f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104332:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104336:	0f 85 65 ff ff ff    	jne    1042a1 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10433c:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104341:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104344:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104347:	89 54 24 14          	mov    %edx,0x14(%esp)
  10434b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10434e:	89 54 24 10          	mov    %edx,0x10(%esp)
  104352:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104356:	89 44 24 08          	mov    %eax,0x8(%esp)
  10435a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104361:	00 
  104362:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104369:	e8 f9 fd ff ff       	call   104167 <get_pgtable_items>
  10436e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104371:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104375:	0f 85 c7 fe ff ff    	jne    104242 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10437b:	c7 04 24 44 6e 10 00 	movl   $0x106e44,(%esp)
  104382:	e8 33 bf ff ff       	call   1002ba <cprintf>
}
  104387:	90                   	nop
  104388:	83 c4 4c             	add    $0x4c,%esp
  10438b:	5b                   	pop    %ebx
  10438c:	5e                   	pop    %esi
  10438d:	5f                   	pop    %edi
  10438e:	5d                   	pop    %ebp
  10438f:	c3                   	ret    

00104390 <page2ppn>:
page2ppn(struct Page *page) {
  104390:	55                   	push   %ebp
  104391:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104393:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  104398:	8b 55 08             	mov    0x8(%ebp),%edx
  10439b:	29 c2                	sub    %eax,%edx
  10439d:	89 d0                	mov    %edx,%eax
  10439f:	c1 f8 02             	sar    $0x2,%eax
  1043a2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1043a8:	5d                   	pop    %ebp
  1043a9:	c3                   	ret    

001043aa <page2pa>:
page2pa(struct Page *page) {
  1043aa:	55                   	push   %ebp
  1043ab:	89 e5                	mov    %esp,%ebp
  1043ad:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1043b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b3:	89 04 24             	mov    %eax,(%esp)
  1043b6:	e8 d5 ff ff ff       	call   104390 <page2ppn>
  1043bb:	c1 e0 0c             	shl    $0xc,%eax
}
  1043be:	c9                   	leave  
  1043bf:	c3                   	ret    

001043c0 <page_ref>:
page_ref(struct Page *page) {
  1043c0:	55                   	push   %ebp
  1043c1:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1043c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1043c6:	8b 00                	mov    (%eax),%eax
}
  1043c8:	5d                   	pop    %ebp
  1043c9:	c3                   	ret    

001043ca <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1043ca:	55                   	push   %ebp
  1043cb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1043cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043d3:	89 10                	mov    %edx,(%eax)
}
  1043d5:	90                   	nop
  1043d6:	5d                   	pop    %ebp
  1043d7:	c3                   	ret    

001043d8 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1043d8:	f3 0f 1e fb          	endbr32 
  1043dc:	55                   	push   %ebp
  1043dd:	89 e5                	mov    %esp,%ebp
  1043df:	83 ec 10             	sub    $0x10,%esp
  1043e2:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1043e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1043ef:	89 50 04             	mov    %edx,0x4(%eax)
  1043f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043f5:	8b 50 04             	mov    0x4(%eax),%edx
  1043f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043fb:	89 10                	mov    %edx,(%eax)
}
  1043fd:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1043fe:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104405:	00 00 00 
}
  104408:	90                   	nop
  104409:	c9                   	leave  
  10440a:	c3                   	ret    

0010440b <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10440b:	f3 0f 1e fb          	endbr32 
  10440f:	55                   	push   %ebp
  104410:	89 e5                	mov    %esp,%ebp
  104412:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  104415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104419:	75 24                	jne    10443f <default_init_memmap+0x34>
  10441b:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104422:	00 
  104423:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10442a:	00 
  10442b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  104432:	00 
  104433:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10443a:	e8 e7 bf ff ff       	call   100426 <__panic>
    struct Page *p = base;
  10443f:	8b 45 08             	mov    0x8(%ebp),%eax
  104442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104445:	eb 7d                	jmp    1044c4 <default_init_memmap+0xb9>
        assert(PageReserved(p));
  104447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10444a:	83 c0 04             	add    $0x4,%eax
  10444d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104454:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10445a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10445d:	0f a3 10             	bt     %edx,(%eax)
  104460:	19 c0                	sbb    %eax,%eax
  104462:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104465:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104469:	0f 95 c0             	setne  %al
  10446c:	0f b6 c0             	movzbl %al,%eax
  10446f:	85 c0                	test   %eax,%eax
  104471:	75 24                	jne    104497 <default_init_memmap+0x8c>
  104473:	c7 44 24 0c a9 6e 10 	movl   $0x106ea9,0xc(%esp)
  10447a:	00 
  10447b:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104482:	00 
  104483:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10448a:	00 
  10448b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104492:	e8 8f bf ff ff       	call   100426 <__panic>
        p->flags = p->property = 0;
  104497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10449a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044a4:	8b 50 08             	mov    0x8(%eax),%edx
  1044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044aa:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1044ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044b4:	00 
  1044b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044b8:	89 04 24             	mov    %eax,(%esp)
  1044bb:	e8 0a ff ff ff       	call   1043ca <set_page_ref>
    for (; p != base + n; p ++) {
  1044c0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1044c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044c7:	89 d0                	mov    %edx,%eax
  1044c9:	c1 e0 02             	shl    $0x2,%eax
  1044cc:	01 d0                	add    %edx,%eax
  1044ce:	c1 e0 02             	shl    $0x2,%eax
  1044d1:	89 c2                	mov    %eax,%edx
  1044d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d6:	01 d0                	add    %edx,%eax
  1044d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1044db:	0f 85 66 ff ff ff    	jne    104447 <default_init_memmap+0x3c>
    }
    base->property = n;
  1044e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1044e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044e7:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1044ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ed:	83 c0 04             	add    $0x4,%eax
  1044f0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1044f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044fd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104500:	0f ab 10             	bts    %edx,(%eax)
}
  104503:	90                   	nop
    nr_free += n;
  104504:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  10450a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10450d:	01 d0                	add    %edx,%eax
  10450f:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    list_add_before(&free_list, &(base->page_link));
  104514:	8b 45 08             	mov    0x8(%ebp),%eax
  104517:	83 c0 0c             	add    $0xc,%eax
  10451a:	c7 45 e4 1c cf 11 00 	movl   $0x11cf1c,-0x1c(%ebp)
  104521:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104527:	8b 00                	mov    (%eax),%eax
  104529:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10452c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10452f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104535:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10453b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10453e:	89 10                	mov    %edx,(%eax)
  104540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104543:	8b 10                	mov    (%eax),%edx
  104545:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104548:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10454b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10454e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104551:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104554:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104557:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10455a:	89 10                	mov    %edx,(%eax)
}
  10455c:	90                   	nop
}
  10455d:	90                   	nop
}
  10455e:	90                   	nop
  10455f:	c9                   	leave  
  104560:	c3                   	ret    

00104561 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104561:	f3 0f 1e fb          	endbr32 
  104565:	55                   	push   %ebp
  104566:	89 e5                	mov    %esp,%ebp
  104568:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10456b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10456f:	75 24                	jne    104595 <default_alloc_pages+0x34>
  104571:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104578:	00 
  104579:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104580:	00 
  104581:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104588:	00 
  104589:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104590:	e8 91 be ff ff       	call   100426 <__panic>
    if (n > nr_free) {
  104595:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  10459a:	39 45 08             	cmp    %eax,0x8(%ebp)
  10459d:	76 0a                	jbe    1045a9 <default_alloc_pages+0x48>
        return NULL;
  10459f:	b8 00 00 00 00       	mov    $0x0,%eax
  1045a4:	e9 43 01 00 00       	jmp    1046ec <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  1045a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1045b0:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  1045b7:	eb 1c                	jmp    1045d5 <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  1045b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045bc:	83 e8 0c             	sub    $0xc,%eax
  1045bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1045c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045c5:	8b 40 08             	mov    0x8(%eax),%eax
  1045c8:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045cb:	77 08                	ja     1045d5 <default_alloc_pages+0x74>
            page = p;
  1045cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1045d3:	eb 18                	jmp    1045ed <default_alloc_pages+0x8c>
  1045d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1045db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045de:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1045e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045e4:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1045eb:	75 cc                	jne    1045b9 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  1045ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045f1:	0f 84 f2 00 00 00    	je     1046e9 <default_alloc_pages+0x188>
        if (page->property > n) {
  1045f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045fa:	8b 40 08             	mov    0x8(%eax),%eax
  1045fd:	39 45 08             	cmp    %eax,0x8(%ebp)
  104600:	0f 83 8f 00 00 00    	jae    104695 <default_alloc_pages+0x134>
            struct Page *p = page + n;
  104606:	8b 55 08             	mov    0x8(%ebp),%edx
  104609:	89 d0                	mov    %edx,%eax
  10460b:	c1 e0 02             	shl    $0x2,%eax
  10460e:	01 d0                	add    %edx,%eax
  104610:	c1 e0 02             	shl    $0x2,%eax
  104613:	89 c2                	mov    %eax,%edx
  104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104618:	01 d0                	add    %edx,%eax
  10461a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104620:	8b 40 08             	mov    0x8(%eax),%eax
  104623:	2b 45 08             	sub    0x8(%ebp),%eax
  104626:	89 c2                	mov    %eax,%edx
  104628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10462b:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  10462e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104631:	83 c0 04             	add    $0x4,%eax
  104634:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  10463b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10463e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104641:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104644:	0f ab 10             	bts    %edx,(%eax)
}
  104647:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
  104648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10464b:	83 c0 0c             	add    $0xc,%eax
  10464e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104651:	83 c2 0c             	add    $0xc,%edx
  104654:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104657:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  10465a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10465d:	8b 40 04             	mov    0x4(%eax),%eax
  104660:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104663:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104666:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104669:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10466c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  10466f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104672:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104675:	89 10                	mov    %edx,(%eax)
  104677:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10467a:	8b 10                	mov    (%eax),%edx
  10467c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10467f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104682:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104685:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104688:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10468b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10468e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104691:	89 10                	mov    %edx,(%eax)
}
  104693:	90                   	nop
}
  104694:	90                   	nop
        }
        list_del(&(page->page_link));
  104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104698:	83 c0 0c             	add    $0xc,%eax
  10469b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  10469e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1046a1:	8b 40 04             	mov    0x4(%eax),%eax
  1046a4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1046a7:	8b 12                	mov    (%edx),%edx
  1046a9:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1046ac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1046af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1046b2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1046b5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1046bb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1046be:	89 10                	mov    %edx,(%eax)
}
  1046c0:	90                   	nop
}
  1046c1:	90                   	nop
        nr_free -= n;
  1046c2:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1046c7:	2b 45 08             	sub    0x8(%ebp),%eax
  1046ca:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  1046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d2:	83 c0 04             	add    $0x4,%eax
  1046d5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1046dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1046e2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1046e5:	0f b3 10             	btr    %edx,(%eax)
}
  1046e8:	90                   	nop
    }
    return page;
  1046e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1046ec:	c9                   	leave  
  1046ed:	c3                   	ret    

001046ee <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1046ee:	f3 0f 1e fb          	endbr32 
  1046f2:	55                   	push   %ebp
  1046f3:	89 e5                	mov    %esp,%ebp
  1046f5:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1046fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1046ff:	75 24                	jne    104725 <default_free_pages+0x37>
  104701:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104708:	00 
  104709:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104710:	00 
  104711:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  104718:	00 
  104719:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104720:	e8 01 bd ff ff       	call   100426 <__panic>
    struct Page *p = base;
  104725:	8b 45 08             	mov    0x8(%ebp),%eax
  104728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10472b:	e9 9d 00 00 00       	jmp    1047cd <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104733:	83 c0 04             	add    $0x4,%eax
  104736:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10473d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104743:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104746:	0f a3 10             	bt     %edx,(%eax)
  104749:	19 c0                	sbb    %eax,%eax
  10474b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  10474e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104752:	0f 95 c0             	setne  %al
  104755:	0f b6 c0             	movzbl %al,%eax
  104758:	85 c0                	test   %eax,%eax
  10475a:	75 2c                	jne    104788 <default_free_pages+0x9a>
  10475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475f:	83 c0 04             	add    $0x4,%eax
  104762:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104769:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10476c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10476f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104772:	0f a3 10             	bt     %edx,(%eax)
  104775:	19 c0                	sbb    %eax,%eax
  104777:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10477a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10477e:	0f 95 c0             	setne  %al
  104781:	0f b6 c0             	movzbl %al,%eax
  104784:	85 c0                	test   %eax,%eax
  104786:	74 24                	je     1047ac <default_free_pages+0xbe>
  104788:	c7 44 24 0c bc 6e 10 	movl   $0x106ebc,0xc(%esp)
  10478f:	00 
  104790:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104797:	00 
  104798:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  10479f:	00 
  1047a0:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1047a7:	e8 7a bc ff ff       	call   100426 <__panic>
        p->flags = 0;
  1047ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1047b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047bd:	00 
  1047be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c1:	89 04 24             	mov    %eax,(%esp)
  1047c4:	e8 01 fc ff ff       	call   1043ca <set_page_ref>
    for (; p != base + n; p ++) {
  1047c9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1047cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047d0:	89 d0                	mov    %edx,%eax
  1047d2:	c1 e0 02             	shl    $0x2,%eax
  1047d5:	01 d0                	add    %edx,%eax
  1047d7:	c1 e0 02             	shl    $0x2,%eax
  1047da:	89 c2                	mov    %eax,%edx
  1047dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1047df:	01 d0                	add    %edx,%eax
  1047e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1047e4:	0f 85 46 ff ff ff    	jne    104730 <default_free_pages+0x42>
    }
    base->property = n;
  1047ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047f0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1047f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f6:	83 c0 04             	add    $0x4,%eax
  1047f9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104800:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104803:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104806:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104809:	0f ab 10             	bts    %edx,(%eax)
}
  10480c:	90                   	nop
  10480d:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
    return listelm->next;
  104814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104817:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  10481a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10481d:	e9 0e 01 00 00       	jmp    104930 <default_free_pages+0x242>
        p = le2page(le, page_link);
  104822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104825:	83 e8 0c             	sub    $0xc,%eax
  104828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10482b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10482e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104831:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104834:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104837:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  10483a:	8b 45 08             	mov    0x8(%ebp),%eax
  10483d:	8b 50 08             	mov    0x8(%eax),%edx
  104840:	89 d0                	mov    %edx,%eax
  104842:	c1 e0 02             	shl    $0x2,%eax
  104845:	01 d0                	add    %edx,%eax
  104847:	c1 e0 02             	shl    $0x2,%eax
  10484a:	89 c2                	mov    %eax,%edx
  10484c:	8b 45 08             	mov    0x8(%ebp),%eax
  10484f:	01 d0                	add    %edx,%eax
  104851:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104854:	75 5d                	jne    1048b3 <default_free_pages+0x1c5>
            base->property += p->property;
  104856:	8b 45 08             	mov    0x8(%ebp),%eax
  104859:	8b 50 08             	mov    0x8(%eax),%edx
  10485c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485f:	8b 40 08             	mov    0x8(%eax),%eax
  104862:	01 c2                	add    %eax,%edx
  104864:	8b 45 08             	mov    0x8(%ebp),%eax
  104867:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10486a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486d:	83 c0 04             	add    $0x4,%eax
  104870:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104877:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10487a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10487d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104880:	0f b3 10             	btr    %edx,(%eax)
}
  104883:	90                   	nop
            list_del(&(p->page_link));
  104884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104887:	83 c0 0c             	add    $0xc,%eax
  10488a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  10488d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104890:	8b 40 04             	mov    0x4(%eax),%eax
  104893:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104896:	8b 12                	mov    (%edx),%edx
  104898:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10489b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  10489e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1048a1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1048a4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1048a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1048aa:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1048ad:	89 10                	mov    %edx,(%eax)
}
  1048af:	90                   	nop
}
  1048b0:	90                   	nop
  1048b1:	eb 7d                	jmp    104930 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  1048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b6:	8b 50 08             	mov    0x8(%eax),%edx
  1048b9:	89 d0                	mov    %edx,%eax
  1048bb:	c1 e0 02             	shl    $0x2,%eax
  1048be:	01 d0                	add    %edx,%eax
  1048c0:	c1 e0 02             	shl    $0x2,%eax
  1048c3:	89 c2                	mov    %eax,%edx
  1048c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c8:	01 d0                	add    %edx,%eax
  1048ca:	39 45 08             	cmp    %eax,0x8(%ebp)
  1048cd:	75 61                	jne    104930 <default_free_pages+0x242>
            p->property += base->property;
  1048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048d2:	8b 50 08             	mov    0x8(%eax),%edx
  1048d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d8:	8b 40 08             	mov    0x8(%eax),%eax
  1048db:	01 c2                	add    %eax,%edx
  1048dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1048e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e6:	83 c0 04             	add    $0x4,%eax
  1048e9:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1048f0:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048f3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1048f6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1048f9:	0f b3 10             	btr    %edx,(%eax)
}
  1048fc:	90                   	nop
            base = p;
  1048fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104900:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104906:	83 c0 0c             	add    $0xc,%eax
  104909:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  10490c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10490f:	8b 40 04             	mov    0x4(%eax),%eax
  104912:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104915:	8b 12                	mov    (%edx),%edx
  104917:	89 55 ac             	mov    %edx,-0x54(%ebp)
  10491a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  10491d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104920:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104923:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104926:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104929:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10492c:	89 10                	mov    %edx,(%eax)
}
  10492e:	90                   	nop
}
  10492f:	90                   	nop
    while (le != &free_list) {
  104930:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  104937:	0f 85 e5 fe ff ff    	jne    104822 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  10493d:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104943:	8b 45 0c             	mov    0xc(%ebp),%eax
  104946:	01 d0                	add    %edx,%eax
  104948:	a3 24 cf 11 00       	mov    %eax,0x11cf24
  10494d:	c7 45 9c 1c cf 11 00 	movl   $0x11cf1c,-0x64(%ebp)
    return listelm->next;
  104954:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104957:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(&free_list);
  10495a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
  10495d:	eb 34                	jmp    104993 <default_free_pages+0x2a5>
        p = le2page(le, page_link);
  10495f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104962:	83 e8 0c             	sub    $0xc,%eax
  104965:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(base + base->property < p){
  104968:	8b 45 08             	mov    0x8(%ebp),%eax
  10496b:	8b 50 08             	mov    0x8(%eax),%edx
  10496e:	89 d0                	mov    %edx,%eax
  104970:	c1 e0 02             	shl    $0x2,%eax
  104973:	01 d0                	add    %edx,%eax
  104975:	c1 e0 02             	shl    $0x2,%eax
  104978:	89 c2                	mov    %eax,%edx
  10497a:	8b 45 08             	mov    0x8(%ebp),%eax
  10497d:	01 d0                	add    %edx,%eax
  10497f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104982:	77 1a                	ja     10499e <default_free_pages+0x2b0>
  104984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104987:	89 45 98             	mov    %eax,-0x68(%ebp)
  10498a:	8b 45 98             	mov    -0x68(%ebp),%eax
  10498d:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104990:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
  104993:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  10499a:	75 c3                	jne    10495f <default_free_pages+0x271>
  10499c:	eb 01                	jmp    10499f <default_free_pages+0x2b1>
            break;
  10499e:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  10499f:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a2:	8d 50 0c             	lea    0xc(%eax),%edx
  1049a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049a8:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1049ab:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1049ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049b1:	8b 00                	mov    (%eax),%eax
  1049b3:	8b 55 90             	mov    -0x70(%ebp),%edx
  1049b6:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1049b9:	89 45 88             	mov    %eax,-0x78(%ebp)
  1049bc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049bf:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  1049c2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049c5:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1049c8:	89 10                	mov    %edx,(%eax)
  1049ca:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049cd:	8b 10                	mov    (%eax),%edx
  1049cf:	8b 45 88             	mov    -0x78(%ebp),%eax
  1049d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049d5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049d8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1049db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1049de:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049e1:	8b 55 88             	mov    -0x78(%ebp),%edx
  1049e4:	89 10                	mov    %edx,(%eax)
}
  1049e6:	90                   	nop
}
  1049e7:	90                   	nop
}
  1049e8:	90                   	nop
  1049e9:	c9                   	leave  
  1049ea:	c3                   	ret    

001049eb <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1049eb:	f3 0f 1e fb          	endbr32 
  1049ef:	55                   	push   %ebp
  1049f0:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1049f2:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  1049f7:	5d                   	pop    %ebp
  1049f8:	c3                   	ret    

001049f9 <basic_check>:

static void
basic_check(void) {
  1049f9:	f3 0f 1e fb          	endbr32 
  1049fd:	55                   	push   %ebp
  1049fe:	89 e5                	mov    %esp,%ebp
  104a00:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a1d:	e8 6e e2 ff ff       	call   102c90 <alloc_pages>
  104a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a29:	75 24                	jne    104a4f <basic_check+0x56>
  104a2b:	c7 44 24 0c e1 6e 10 	movl   $0x106ee1,0xc(%esp)
  104a32:	00 
  104a33:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a3a:	00 
  104a3b:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  104a42:	00 
  104a43:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a4a:	e8 d7 b9 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a56:	e8 35 e2 ff ff       	call   102c90 <alloc_pages>
  104a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a62:	75 24                	jne    104a88 <basic_check+0x8f>
  104a64:	c7 44 24 0c fd 6e 10 	movl   $0x106efd,0xc(%esp)
  104a6b:	00 
  104a6c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a73:	00 
  104a74:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  104a7b:	00 
  104a7c:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a83:	e8 9e b9 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a8f:	e8 fc e1 ff ff       	call   102c90 <alloc_pages>
  104a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a9b:	75 24                	jne    104ac1 <basic_check+0xc8>
  104a9d:	c7 44 24 0c 19 6f 10 	movl   $0x106f19,0xc(%esp)
  104aa4:	00 
  104aa5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104aac:	00 
  104aad:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104ab4:	00 
  104ab5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104abc:	e8 65 b9 ff ff       	call   100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ac4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ac7:	74 10                	je     104ad9 <basic_check+0xe0>
  104ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104acf:	74 08                	je     104ad9 <basic_check+0xe0>
  104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ad7:	75 24                	jne    104afd <basic_check+0x104>
  104ad9:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104ae0:	00 
  104ae1:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ae8:	00 
  104ae9:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104af0:	00 
  104af1:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104af8:	e8 29 b9 ff ff       	call   100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b00:	89 04 24             	mov    %eax,(%esp)
  104b03:	e8 b8 f8 ff ff       	call   1043c0 <page_ref>
  104b08:	85 c0                	test   %eax,%eax
  104b0a:	75 1e                	jne    104b2a <basic_check+0x131>
  104b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b0f:	89 04 24             	mov    %eax,(%esp)
  104b12:	e8 a9 f8 ff ff       	call   1043c0 <page_ref>
  104b17:	85 c0                	test   %eax,%eax
  104b19:	75 0f                	jne    104b2a <basic_check+0x131>
  104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b1e:	89 04 24             	mov    %eax,(%esp)
  104b21:	e8 9a f8 ff ff       	call   1043c0 <page_ref>
  104b26:	85 c0                	test   %eax,%eax
  104b28:	74 24                	je     104b4e <basic_check+0x155>
  104b2a:	c7 44 24 0c 5c 6f 10 	movl   $0x106f5c,0xc(%esp)
  104b31:	00 
  104b32:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b39:	00 
  104b3a:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104b41:	00 
  104b42:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b49:	e8 d8 b8 ff ff       	call   100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b51:	89 04 24             	mov    %eax,(%esp)
  104b54:	e8 51 f8 ff ff       	call   1043aa <page2pa>
  104b59:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b5f:	c1 e2 0c             	shl    $0xc,%edx
  104b62:	39 d0                	cmp    %edx,%eax
  104b64:	72 24                	jb     104b8a <basic_check+0x191>
  104b66:	c7 44 24 0c 98 6f 10 	movl   $0x106f98,0xc(%esp)
  104b6d:	00 
  104b6e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b75:	00 
  104b76:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104b7d:	00 
  104b7e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b85:	e8 9c b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b8d:	89 04 24             	mov    %eax,(%esp)
  104b90:	e8 15 f8 ff ff       	call   1043aa <page2pa>
  104b95:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b9b:	c1 e2 0c             	shl    $0xc,%edx
  104b9e:	39 d0                	cmp    %edx,%eax
  104ba0:	72 24                	jb     104bc6 <basic_check+0x1cd>
  104ba2:	c7 44 24 0c b5 6f 10 	movl   $0x106fb5,0xc(%esp)
  104ba9:	00 
  104baa:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bb1:	00 
  104bb2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104bb9:	00 
  104bba:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bc1:	e8 60 b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc9:	89 04 24             	mov    %eax,(%esp)
  104bcc:	e8 d9 f7 ff ff       	call   1043aa <page2pa>
  104bd1:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104bd7:	c1 e2 0c             	shl    $0xc,%edx
  104bda:	39 d0                	cmp    %edx,%eax
  104bdc:	72 24                	jb     104c02 <basic_check+0x209>
  104bde:	c7 44 24 0c d2 6f 10 	movl   $0x106fd2,0xc(%esp)
  104be5:	00 
  104be6:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bed:	00 
  104bee:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104bf5:	00 
  104bf6:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bfd:	e8 24 b8 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  104c02:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104c07:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104c0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104c10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104c13:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104c1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c20:	89 50 04             	mov    %edx,0x4(%eax)
  104c23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c26:	8b 50 04             	mov    0x4(%eax),%edx
  104c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c2c:	89 10                	mov    %edx,(%eax)
}
  104c2e:	90                   	nop
  104c2f:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c39:	8b 40 04             	mov    0x4(%eax),%eax
  104c3c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104c3f:	0f 94 c0             	sete   %al
  104c42:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104c45:	85 c0                	test   %eax,%eax
  104c47:	75 24                	jne    104c6d <basic_check+0x274>
  104c49:	c7 44 24 0c ef 6f 10 	movl   $0x106fef,0xc(%esp)
  104c50:	00 
  104c51:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104c58:	00 
  104c59:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104c60:	00 
  104c61:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104c68:	e8 b9 b7 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  104c6d:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104c72:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104c75:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104c7c:	00 00 00 

    assert(alloc_page() == NULL);
  104c7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c86:	e8 05 e0 ff ff       	call   102c90 <alloc_pages>
  104c8b:	85 c0                	test   %eax,%eax
  104c8d:	74 24                	je     104cb3 <basic_check+0x2ba>
  104c8f:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  104c96:	00 
  104c97:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104c9e:	00 
  104c9f:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  104ca6:	00 
  104ca7:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104cae:	e8 73 b7 ff ff       	call   100426 <__panic>

    free_page(p0);
  104cb3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cba:	00 
  104cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cbe:	89 04 24             	mov    %eax,(%esp)
  104cc1:	e8 06 e0 ff ff       	call   102ccc <free_pages>
    free_page(p1);
  104cc6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ccd:	00 
  104cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd1:	89 04 24             	mov    %eax,(%esp)
  104cd4:	e8 f3 df ff ff       	call   102ccc <free_pages>
    free_page(p2);
  104cd9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ce0:	00 
  104ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce4:	89 04 24             	mov    %eax,(%esp)
  104ce7:	e8 e0 df ff ff       	call   102ccc <free_pages>
    assert(nr_free == 3);
  104cec:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104cf1:	83 f8 03             	cmp    $0x3,%eax
  104cf4:	74 24                	je     104d1a <basic_check+0x321>
  104cf6:	c7 44 24 0c 1b 70 10 	movl   $0x10701b,0xc(%esp)
  104cfd:	00 
  104cfe:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d05:	00 
  104d06:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  104d0d:	00 
  104d0e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d15:	e8 0c b7 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104d1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d21:	e8 6a df ff ff       	call   102c90 <alloc_pages>
  104d26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d2d:	75 24                	jne    104d53 <basic_check+0x35a>
  104d2f:	c7 44 24 0c e1 6e 10 	movl   $0x106ee1,0xc(%esp)
  104d36:	00 
  104d37:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d3e:	00 
  104d3f:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104d46:	00 
  104d47:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d4e:	e8 d3 b6 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104d53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d5a:	e8 31 df ff ff       	call   102c90 <alloc_pages>
  104d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d66:	75 24                	jne    104d8c <basic_check+0x393>
  104d68:	c7 44 24 0c fd 6e 10 	movl   $0x106efd,0xc(%esp)
  104d6f:	00 
  104d70:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d77:	00 
  104d78:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104d7f:	00 
  104d80:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d87:	e8 9a b6 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d93:	e8 f8 de ff ff       	call   102c90 <alloc_pages>
  104d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104d9f:	75 24                	jne    104dc5 <basic_check+0x3cc>
  104da1:	c7 44 24 0c 19 6f 10 	movl   $0x106f19,0xc(%esp)
  104da8:	00 
  104da9:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104db0:	00 
  104db1:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104db8:	00 
  104db9:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104dc0:	e8 61 b6 ff ff       	call   100426 <__panic>

    assert(alloc_page() == NULL);
  104dc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dcc:	e8 bf de ff ff       	call   102c90 <alloc_pages>
  104dd1:	85 c0                	test   %eax,%eax
  104dd3:	74 24                	je     104df9 <basic_check+0x400>
  104dd5:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104de4:	00 
  104de5:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104dec:	00 
  104ded:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104df4:	e8 2d b6 ff ff       	call   100426 <__panic>

    free_page(p0);
  104df9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e00:	00 
  104e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e04:	89 04 24             	mov    %eax,(%esp)
  104e07:	e8 c0 de ff ff       	call   102ccc <free_pages>
  104e0c:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104e13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e16:	8b 40 04             	mov    0x4(%eax),%eax
  104e19:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104e1c:	0f 94 c0             	sete   %al
  104e1f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104e22:	85 c0                	test   %eax,%eax
  104e24:	74 24                	je     104e4a <basic_check+0x451>
  104e26:	c7 44 24 0c 28 70 10 	movl   $0x107028,0xc(%esp)
  104e2d:	00 
  104e2e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e35:	00 
  104e36:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  104e3d:	00 
  104e3e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e45:	e8 dc b5 ff ff       	call   100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104e4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e51:	e8 3a de ff ff       	call   102c90 <alloc_pages>
  104e56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e5f:	74 24                	je     104e85 <basic_check+0x48c>
  104e61:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  104e68:	00 
  104e69:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e70:	00 
  104e71:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104e78:	00 
  104e79:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e80:	e8 a1 b5 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  104e85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e8c:	e8 ff dd ff ff       	call   102c90 <alloc_pages>
  104e91:	85 c0                	test   %eax,%eax
  104e93:	74 24                	je     104eb9 <basic_check+0x4c0>
  104e95:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  104e9c:	00 
  104e9d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ea4:	00 
  104ea5:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104eac:	00 
  104ead:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104eb4:	e8 6d b5 ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  104eb9:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104ebe:	85 c0                	test   %eax,%eax
  104ec0:	74 24                	je     104ee6 <basic_check+0x4ed>
  104ec2:	c7 44 24 0c 59 70 10 	movl   $0x107059,0xc(%esp)
  104ec9:	00 
  104eca:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ed1:	00 
  104ed2:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104ed9:	00 
  104eda:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104ee1:	e8 40 b5 ff ff       	call   100426 <__panic>
    free_list = free_list_store;
  104ee6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ee9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104eec:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104ef1:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104efa:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104eff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f06:	00 
  104f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f0a:	89 04 24             	mov    %eax,(%esp)
  104f0d:	e8 ba dd ff ff       	call   102ccc <free_pages>
    free_page(p1);
  104f12:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f19:	00 
  104f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1d:	89 04 24             	mov    %eax,(%esp)
  104f20:	e8 a7 dd ff ff       	call   102ccc <free_pages>
    free_page(p2);
  104f25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f2c:	00 
  104f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f30:	89 04 24             	mov    %eax,(%esp)
  104f33:	e8 94 dd ff ff       	call   102ccc <free_pages>
}
  104f38:	90                   	nop
  104f39:	c9                   	leave  
  104f3a:	c3                   	ret    

00104f3b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104f3b:	f3 0f 1e fb          	endbr32 
  104f3f:	55                   	push   %ebp
  104f40:	89 e5                	mov    %esp,%ebp
  104f42:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104f48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104f56:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f5d:	eb 6a                	jmp    104fc9 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  104f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f62:	83 e8 0c             	sub    $0xc,%eax
  104f65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104f68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104f6b:	83 c0 04             	add    $0x4,%eax
  104f6e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104f75:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104f7b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f7e:	0f a3 10             	bt     %edx,(%eax)
  104f81:	19 c0                	sbb    %eax,%eax
  104f83:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104f86:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104f8a:	0f 95 c0             	setne  %al
  104f8d:	0f b6 c0             	movzbl %al,%eax
  104f90:	85 c0                	test   %eax,%eax
  104f92:	75 24                	jne    104fb8 <default_check+0x7d>
  104f94:	c7 44 24 0c 66 70 10 	movl   $0x107066,0xc(%esp)
  104f9b:	00 
  104f9c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104fa3:	00 
  104fa4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104fab:	00 
  104fac:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104fb3:	e8 6e b4 ff ff       	call   100426 <__panic>
        count ++, total += p->property;
  104fb8:	ff 45 f4             	incl   -0xc(%ebp)
  104fbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fbe:	8b 50 08             	mov    0x8(%eax),%edx
  104fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fc4:	01 d0                	add    %edx,%eax
  104fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fcc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104fcf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104fd2:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104fd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fd8:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  104fdf:	0f 85 7a ff ff ff    	jne    104f5f <default_check+0x24>
    }
    assert(total == nr_free_pages());
  104fe5:	e8 19 dd ff ff       	call   102d03 <nr_free_pages>
  104fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104fed:	39 d0                	cmp    %edx,%eax
  104fef:	74 24                	je     105015 <default_check+0xda>
  104ff1:	c7 44 24 0c 76 70 10 	movl   $0x107076,0xc(%esp)
  104ff8:	00 
  104ff9:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105000:	00 
  105001:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  105008:	00 
  105009:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105010:	e8 11 b4 ff ff       	call   100426 <__panic>

    basic_check();
  105015:	e8 df f9 ff ff       	call   1049f9 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10501a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105021:	e8 6a dc ff ff       	call   102c90 <alloc_pages>
  105026:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105029:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10502d:	75 24                	jne    105053 <default_check+0x118>
  10502f:	c7 44 24 0c 8f 70 10 	movl   $0x10708f,0xc(%esp)
  105036:	00 
  105037:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10503e:	00 
  10503f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  105046:	00 
  105047:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10504e:	e8 d3 b3 ff ff       	call   100426 <__panic>
    assert(!PageProperty(p0));
  105053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105056:	83 c0 04             	add    $0x4,%eax
  105059:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105060:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105063:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105066:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105069:	0f a3 10             	bt     %edx,(%eax)
  10506c:	19 c0                	sbb    %eax,%eax
  10506e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105071:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105075:	0f 95 c0             	setne  %al
  105078:	0f b6 c0             	movzbl %al,%eax
  10507b:	85 c0                	test   %eax,%eax
  10507d:	74 24                	je     1050a3 <default_check+0x168>
  10507f:	c7 44 24 0c 9a 70 10 	movl   $0x10709a,0xc(%esp)
  105086:	00 
  105087:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10508e:	00 
  10508f:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  105096:	00 
  105097:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10509e:	e8 83 b3 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  1050a3:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  1050a8:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  1050ae:	89 45 80             	mov    %eax,-0x80(%ebp)
  1050b1:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1050b4:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1050bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050be:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1050c1:	89 50 04             	mov    %edx,0x4(%eax)
  1050c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050c7:	8b 50 04             	mov    0x4(%eax),%edx
  1050ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050cd:	89 10                	mov    %edx,(%eax)
}
  1050cf:	90                   	nop
  1050d0:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  1050d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050da:	8b 40 04             	mov    0x4(%eax),%eax
  1050dd:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1050e0:	0f 94 c0             	sete   %al
  1050e3:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1050e6:	85 c0                	test   %eax,%eax
  1050e8:	75 24                	jne    10510e <default_check+0x1d3>
  1050ea:	c7 44 24 0c ef 6f 10 	movl   $0x106fef,0xc(%esp)
  1050f1:	00 
  1050f2:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1050f9:	00 
  1050fa:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  105101:	00 
  105102:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105109:	e8 18 b3 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  10510e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105115:	e8 76 db ff ff       	call   102c90 <alloc_pages>
  10511a:	85 c0                	test   %eax,%eax
  10511c:	74 24                	je     105142 <default_check+0x207>
  10511e:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  105125:	00 
  105126:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10512d:	00 
  10512e:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105135:	00 
  105136:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10513d:	e8 e4 b2 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  105142:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  105147:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10514a:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  105151:	00 00 00 

    free_pages(p0 + 2, 3);
  105154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105157:	83 c0 28             	add    $0x28,%eax
  10515a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105161:	00 
  105162:	89 04 24             	mov    %eax,(%esp)
  105165:	e8 62 db ff ff       	call   102ccc <free_pages>
    assert(alloc_pages(4) == NULL);
  10516a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105171:	e8 1a db ff ff       	call   102c90 <alloc_pages>
  105176:	85 c0                	test   %eax,%eax
  105178:	74 24                	je     10519e <default_check+0x263>
  10517a:	c7 44 24 0c ac 70 10 	movl   $0x1070ac,0xc(%esp)
  105181:	00 
  105182:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105189:	00 
  10518a:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105191:	00 
  105192:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105199:	e8 88 b2 ff ff       	call   100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10519e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051a1:	83 c0 28             	add    $0x28,%eax
  1051a4:	83 c0 04             	add    $0x4,%eax
  1051a7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1051ae:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051b1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1051b4:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1051b7:	0f a3 10             	bt     %edx,(%eax)
  1051ba:	19 c0                	sbb    %eax,%eax
  1051bc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1051bf:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1051c3:	0f 95 c0             	setne  %al
  1051c6:	0f b6 c0             	movzbl %al,%eax
  1051c9:	85 c0                	test   %eax,%eax
  1051cb:	74 0e                	je     1051db <default_check+0x2a0>
  1051cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051d0:	83 c0 28             	add    $0x28,%eax
  1051d3:	8b 40 08             	mov    0x8(%eax),%eax
  1051d6:	83 f8 03             	cmp    $0x3,%eax
  1051d9:	74 24                	je     1051ff <default_check+0x2c4>
  1051db:	c7 44 24 0c c4 70 10 	movl   $0x1070c4,0xc(%esp)
  1051e2:	00 
  1051e3:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1051ea:	00 
  1051eb:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1051f2:	00 
  1051f3:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1051fa:	e8 27 b2 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1051ff:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105206:	e8 85 da ff ff       	call   102c90 <alloc_pages>
  10520b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10520e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105212:	75 24                	jne    105238 <default_check+0x2fd>
  105214:	c7 44 24 0c f0 70 10 	movl   $0x1070f0,0xc(%esp)
  10521b:	00 
  10521c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105223:	00 
  105224:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  10522b:	00 
  10522c:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105233:	e8 ee b1 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105238:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10523f:	e8 4c da ff ff       	call   102c90 <alloc_pages>
  105244:	85 c0                	test   %eax,%eax
  105246:	74 24                	je     10526c <default_check+0x331>
  105248:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  10524f:	00 
  105250:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105257:	00 
  105258:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10525f:	00 
  105260:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105267:	e8 ba b1 ff ff       	call   100426 <__panic>
    assert(p0 + 2 == p1);
  10526c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10526f:	83 c0 28             	add    $0x28,%eax
  105272:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105275:	74 24                	je     10529b <default_check+0x360>
  105277:	c7 44 24 0c 0e 71 10 	movl   $0x10710e,0xc(%esp)
  10527e:	00 
  10527f:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105286:	00 
  105287:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10528e:	00 
  10528f:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105296:	e8 8b b1 ff ff       	call   100426 <__panic>

    p2 = p0 + 1;
  10529b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10529e:	83 c0 14             	add    $0x14,%eax
  1052a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1052a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052ab:	00 
  1052ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052af:	89 04 24             	mov    %eax,(%esp)
  1052b2:	e8 15 da ff ff       	call   102ccc <free_pages>
    free_pages(p1, 3);
  1052b7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1052be:	00 
  1052bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052c2:	89 04 24             	mov    %eax,(%esp)
  1052c5:	e8 02 da ff ff       	call   102ccc <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1052ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052cd:	83 c0 04             	add    $0x4,%eax
  1052d0:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1052d7:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052da:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1052dd:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1052e0:	0f a3 10             	bt     %edx,(%eax)
  1052e3:	19 c0                	sbb    %eax,%eax
  1052e5:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1052e8:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1052ec:	0f 95 c0             	setne  %al
  1052ef:	0f b6 c0             	movzbl %al,%eax
  1052f2:	85 c0                	test   %eax,%eax
  1052f4:	74 0b                	je     105301 <default_check+0x3c6>
  1052f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052f9:	8b 40 08             	mov    0x8(%eax),%eax
  1052fc:	83 f8 01             	cmp    $0x1,%eax
  1052ff:	74 24                	je     105325 <default_check+0x3ea>
  105301:	c7 44 24 0c 1c 71 10 	movl   $0x10711c,0xc(%esp)
  105308:	00 
  105309:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105310:	00 
  105311:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  105318:	00 
  105319:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105320:	e8 01 b1 ff ff       	call   100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105328:	83 c0 04             	add    $0x4,%eax
  10532b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105332:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105335:	8b 45 90             	mov    -0x70(%ebp),%eax
  105338:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10533b:	0f a3 10             	bt     %edx,(%eax)
  10533e:	19 c0                	sbb    %eax,%eax
  105340:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105343:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105347:	0f 95 c0             	setne  %al
  10534a:	0f b6 c0             	movzbl %al,%eax
  10534d:	85 c0                	test   %eax,%eax
  10534f:	74 0b                	je     10535c <default_check+0x421>
  105351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105354:	8b 40 08             	mov    0x8(%eax),%eax
  105357:	83 f8 03             	cmp    $0x3,%eax
  10535a:	74 24                	je     105380 <default_check+0x445>
  10535c:	c7 44 24 0c 44 71 10 	movl   $0x107144,0xc(%esp)
  105363:	00 
  105364:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10536b:	00 
  10536c:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  105373:	00 
  105374:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10537b:	e8 a6 b0 ff ff       	call   100426 <__panic>
    
    assert((p0 = alloc_page()) == p2 - 1);
  105380:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105387:	e8 04 d9 ff ff       	call   102c90 <alloc_pages>
  10538c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10538f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105392:	83 e8 14             	sub    $0x14,%eax
  105395:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105398:	74 24                	je     1053be <default_check+0x483>
  10539a:	c7 44 24 0c 6a 71 10 	movl   $0x10716a,0xc(%esp)
  1053a1:	00 
  1053a2:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053a9:	00 
  1053aa:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1053b1:	00 
  1053b2:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1053b9:	e8 68 b0 ff ff       	call   100426 <__panic>
    free_page(p0);
  1053be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053c5:	00 
  1053c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 fb d8 ff ff       	call   102ccc <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1053d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053d8:	e8 b3 d8 ff ff       	call   102c90 <alloc_pages>
  1053dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053e3:	83 c0 14             	add    $0x14,%eax
  1053e6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1053e9:	74 24                	je     10540f <default_check+0x4d4>
  1053eb:	c7 44 24 0c 88 71 10 	movl   $0x107188,0xc(%esp)
  1053f2:	00 
  1053f3:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053fa:	00 
  1053fb:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  105402:	00 
  105403:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10540a:	e8 17 b0 ff ff       	call   100426 <__panic>

    free_pages(p0, 2);
  10540f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105416:	00 
  105417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10541a:	89 04 24             	mov    %eax,(%esp)
  10541d:	e8 aa d8 ff ff       	call   102ccc <free_pages>
    free_page(p2);
  105422:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105429:	00 
  10542a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10542d:	89 04 24             	mov    %eax,(%esp)
  105430:	e8 97 d8 ff ff       	call   102ccc <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105435:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10543c:	e8 4f d8 ff ff       	call   102c90 <alloc_pages>
  105441:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105444:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105448:	75 24                	jne    10546e <default_check+0x533>
  10544a:	c7 44 24 0c a8 71 10 	movl   $0x1071a8,0xc(%esp)
  105451:	00 
  105452:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105459:	00 
  10545a:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  105461:	00 
  105462:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105469:	e8 b8 af ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  10546e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105475:	e8 16 d8 ff ff       	call   102c90 <alloc_pages>
  10547a:	85 c0                	test   %eax,%eax
  10547c:	74 24                	je     1054a2 <default_check+0x567>
  10547e:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  105485:	00 
  105486:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10548d:	00 
  10548e:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  105495:	00 
  105496:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10549d:	e8 84 af ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  1054a2:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1054a7:	85 c0                	test   %eax,%eax
  1054a9:	74 24                	je     1054cf <default_check+0x594>
  1054ab:	c7 44 24 0c 59 70 10 	movl   $0x107059,0xc(%esp)
  1054b2:	00 
  1054b3:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1054ba:	00 
  1054bb:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1054c2:	00 
  1054c3:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1054ca:	e8 57 af ff ff       	call   100426 <__panic>
    nr_free = nr_free_store;
  1054cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054d2:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  1054d7:	8b 45 80             	mov    -0x80(%ebp),%eax
  1054da:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1054dd:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  1054e2:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  1054e8:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1054ef:	00 
  1054f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054f3:	89 04 24             	mov    %eax,(%esp)
  1054f6:	e8 d1 d7 ff ff       	call   102ccc <free_pages>

    le = &free_list;
  1054fb:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105502:	eb 1c                	jmp    105520 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  105504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105507:	83 e8 0c             	sub    $0xc,%eax
  10550a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  10550d:	ff 4d f4             	decl   -0xc(%ebp)
  105510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105513:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105516:	8b 40 08             	mov    0x8(%eax),%eax
  105519:	29 c2                	sub    %eax,%edx
  10551b:	89 d0                	mov    %edx,%eax
  10551d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105523:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105526:	8b 45 88             	mov    -0x78(%ebp),%eax
  105529:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10552c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10552f:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  105536:	75 cc                	jne    105504 <default_check+0x5c9>
    }
    assert(count == 0);
  105538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10553c:	74 24                	je     105562 <default_check+0x627>
  10553e:	c7 44 24 0c c6 71 10 	movl   $0x1071c6,0xc(%esp)
  105545:	00 
  105546:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10554d:	00 
  10554e:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  105555:	00 
  105556:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10555d:	e8 c4 ae ff ff       	call   100426 <__panic>
    assert(total == 0);
  105562:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105566:	74 24                	je     10558c <default_check+0x651>
  105568:	c7 44 24 0c d1 71 10 	movl   $0x1071d1,0xc(%esp)
  10556f:	00 
  105570:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105577:	00 
  105578:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  10557f:	00 
  105580:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105587:	e8 9a ae ff ff       	call   100426 <__panic>
}
  10558c:	90                   	nop
  10558d:	c9                   	leave  
  10558e:	c3                   	ret    

0010558f <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10558f:	f3 0f 1e fb          	endbr32 
  105593:	55                   	push   %ebp
  105594:	89 e5                	mov    %esp,%ebp
  105596:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105599:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055a0:	eb 03                	jmp    1055a5 <strlen+0x16>
        cnt ++;
  1055a2:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1055a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a8:	8d 50 01             	lea    0x1(%eax),%edx
  1055ab:	89 55 08             	mov    %edx,0x8(%ebp)
  1055ae:	0f b6 00             	movzbl (%eax),%eax
  1055b1:	84 c0                	test   %al,%al
  1055b3:	75 ed                	jne    1055a2 <strlen+0x13>
    }
    return cnt;
  1055b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055b8:	c9                   	leave  
  1055b9:	c3                   	ret    

001055ba <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1055ba:	f3 0f 1e fb          	endbr32 
  1055be:	55                   	push   %ebp
  1055bf:	89 e5                	mov    %esp,%ebp
  1055c1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1055c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055cb:	eb 03                	jmp    1055d0 <strnlen+0x16>
        cnt ++;
  1055cd:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055d6:	73 10                	jae    1055e8 <strnlen+0x2e>
  1055d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1055db:	8d 50 01             	lea    0x1(%eax),%edx
  1055de:	89 55 08             	mov    %edx,0x8(%ebp)
  1055e1:	0f b6 00             	movzbl (%eax),%eax
  1055e4:	84 c0                	test   %al,%al
  1055e6:	75 e5                	jne    1055cd <strnlen+0x13>
    }
    return cnt;
  1055e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055eb:	c9                   	leave  
  1055ec:	c3                   	ret    

001055ed <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1055ed:	f3 0f 1e fb          	endbr32 
  1055f1:	55                   	push   %ebp
  1055f2:	89 e5                	mov    %esp,%ebp
  1055f4:	57                   	push   %edi
  1055f5:	56                   	push   %esi
  1055f6:	83 ec 20             	sub    $0x20,%esp
  1055f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  105602:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105605:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10560b:	89 d1                	mov    %edx,%ecx
  10560d:	89 c2                	mov    %eax,%edx
  10560f:	89 ce                	mov    %ecx,%esi
  105611:	89 d7                	mov    %edx,%edi
  105613:	ac                   	lods   %ds:(%esi),%al
  105614:	aa                   	stos   %al,%es:(%edi)
  105615:	84 c0                	test   %al,%al
  105617:	75 fa                	jne    105613 <strcpy+0x26>
  105619:	89 fa                	mov    %edi,%edx
  10561b:	89 f1                	mov    %esi,%ecx
  10561d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105620:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105626:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105629:	83 c4 20             	add    $0x20,%esp
  10562c:	5e                   	pop    %esi
  10562d:	5f                   	pop    %edi
  10562e:	5d                   	pop    %ebp
  10562f:	c3                   	ret    

00105630 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105630:	f3 0f 1e fb          	endbr32 
  105634:	55                   	push   %ebp
  105635:	89 e5                	mov    %esp,%ebp
  105637:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10563a:	8b 45 08             	mov    0x8(%ebp),%eax
  10563d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105640:	eb 1e                	jmp    105660 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  105642:	8b 45 0c             	mov    0xc(%ebp),%eax
  105645:	0f b6 10             	movzbl (%eax),%edx
  105648:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10564b:	88 10                	mov    %dl,(%eax)
  10564d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105650:	0f b6 00             	movzbl (%eax),%eax
  105653:	84 c0                	test   %al,%al
  105655:	74 03                	je     10565a <strncpy+0x2a>
            src ++;
  105657:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10565a:	ff 45 fc             	incl   -0x4(%ebp)
  10565d:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105660:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105664:	75 dc                	jne    105642 <strncpy+0x12>
    }
    return dst;
  105666:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105669:	c9                   	leave  
  10566a:	c3                   	ret    

0010566b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10566b:	f3 0f 1e fb          	endbr32 
  10566f:	55                   	push   %ebp
  105670:	89 e5                	mov    %esp,%ebp
  105672:	57                   	push   %edi
  105673:	56                   	push   %esi
  105674:	83 ec 20             	sub    $0x20,%esp
  105677:	8b 45 08             	mov    0x8(%ebp),%eax
  10567a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10567d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105680:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105689:	89 d1                	mov    %edx,%ecx
  10568b:	89 c2                	mov    %eax,%edx
  10568d:	89 ce                	mov    %ecx,%esi
  10568f:	89 d7                	mov    %edx,%edi
  105691:	ac                   	lods   %ds:(%esi),%al
  105692:	ae                   	scas   %es:(%edi),%al
  105693:	75 08                	jne    10569d <strcmp+0x32>
  105695:	84 c0                	test   %al,%al
  105697:	75 f8                	jne    105691 <strcmp+0x26>
  105699:	31 c0                	xor    %eax,%eax
  10569b:	eb 04                	jmp    1056a1 <strcmp+0x36>
  10569d:	19 c0                	sbb    %eax,%eax
  10569f:	0c 01                	or     $0x1,%al
  1056a1:	89 fa                	mov    %edi,%edx
  1056a3:	89 f1                	mov    %esi,%ecx
  1056a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056a8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1056ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1056ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1056b1:	83 c4 20             	add    $0x20,%esp
  1056b4:	5e                   	pop    %esi
  1056b5:	5f                   	pop    %edi
  1056b6:	5d                   	pop    %ebp
  1056b7:	c3                   	ret    

001056b8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1056b8:	f3 0f 1e fb          	endbr32 
  1056bc:	55                   	push   %ebp
  1056bd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056bf:	eb 09                	jmp    1056ca <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1056c1:	ff 4d 10             	decl   0x10(%ebp)
  1056c4:	ff 45 08             	incl   0x8(%ebp)
  1056c7:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056ce:	74 1a                	je     1056ea <strncmp+0x32>
  1056d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d3:	0f b6 00             	movzbl (%eax),%eax
  1056d6:	84 c0                	test   %al,%al
  1056d8:	74 10                	je     1056ea <strncmp+0x32>
  1056da:	8b 45 08             	mov    0x8(%ebp),%eax
  1056dd:	0f b6 10             	movzbl (%eax),%edx
  1056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e3:	0f b6 00             	movzbl (%eax),%eax
  1056e6:	38 c2                	cmp    %al,%dl
  1056e8:	74 d7                	je     1056c1 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1056ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056ee:	74 18                	je     105708 <strncmp+0x50>
  1056f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f3:	0f b6 00             	movzbl (%eax),%eax
  1056f6:	0f b6 d0             	movzbl %al,%edx
  1056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056fc:	0f b6 00             	movzbl (%eax),%eax
  1056ff:	0f b6 c0             	movzbl %al,%eax
  105702:	29 c2                	sub    %eax,%edx
  105704:	89 d0                	mov    %edx,%eax
  105706:	eb 05                	jmp    10570d <strncmp+0x55>
  105708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10570d:	5d                   	pop    %ebp
  10570e:	c3                   	ret    

0010570f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10570f:	f3 0f 1e fb          	endbr32 
  105713:	55                   	push   %ebp
  105714:	89 e5                	mov    %esp,%ebp
  105716:	83 ec 04             	sub    $0x4,%esp
  105719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10571f:	eb 13                	jmp    105734 <strchr+0x25>
        if (*s == c) {
  105721:	8b 45 08             	mov    0x8(%ebp),%eax
  105724:	0f b6 00             	movzbl (%eax),%eax
  105727:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10572a:	75 05                	jne    105731 <strchr+0x22>
            return (char *)s;
  10572c:	8b 45 08             	mov    0x8(%ebp),%eax
  10572f:	eb 12                	jmp    105743 <strchr+0x34>
        }
        s ++;
  105731:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105734:	8b 45 08             	mov    0x8(%ebp),%eax
  105737:	0f b6 00             	movzbl (%eax),%eax
  10573a:	84 c0                	test   %al,%al
  10573c:	75 e3                	jne    105721 <strchr+0x12>
    }
    return NULL;
  10573e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105743:	c9                   	leave  
  105744:	c3                   	ret    

00105745 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105745:	f3 0f 1e fb          	endbr32 
  105749:	55                   	push   %ebp
  10574a:	89 e5                	mov    %esp,%ebp
  10574c:	83 ec 04             	sub    $0x4,%esp
  10574f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105752:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105755:	eb 0e                	jmp    105765 <strfind+0x20>
        if (*s == c) {
  105757:	8b 45 08             	mov    0x8(%ebp),%eax
  10575a:	0f b6 00             	movzbl (%eax),%eax
  10575d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105760:	74 0f                	je     105771 <strfind+0x2c>
            break;
        }
        s ++;
  105762:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105765:	8b 45 08             	mov    0x8(%ebp),%eax
  105768:	0f b6 00             	movzbl (%eax),%eax
  10576b:	84 c0                	test   %al,%al
  10576d:	75 e8                	jne    105757 <strfind+0x12>
  10576f:	eb 01                	jmp    105772 <strfind+0x2d>
            break;
  105771:	90                   	nop
    }
    return (char *)s;
  105772:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105775:	c9                   	leave  
  105776:	c3                   	ret    

00105777 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105777:	f3 0f 1e fb          	endbr32 
  10577b:	55                   	push   %ebp
  10577c:	89 e5                	mov    %esp,%ebp
  10577e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105781:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105788:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10578f:	eb 03                	jmp    105794 <strtol+0x1d>
        s ++;
  105791:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105794:	8b 45 08             	mov    0x8(%ebp),%eax
  105797:	0f b6 00             	movzbl (%eax),%eax
  10579a:	3c 20                	cmp    $0x20,%al
  10579c:	74 f3                	je     105791 <strtol+0x1a>
  10579e:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a1:	0f b6 00             	movzbl (%eax),%eax
  1057a4:	3c 09                	cmp    $0x9,%al
  1057a6:	74 e9                	je     105791 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1057a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ab:	0f b6 00             	movzbl (%eax),%eax
  1057ae:	3c 2b                	cmp    $0x2b,%al
  1057b0:	75 05                	jne    1057b7 <strtol+0x40>
        s ++;
  1057b2:	ff 45 08             	incl   0x8(%ebp)
  1057b5:	eb 14                	jmp    1057cb <strtol+0x54>
    }
    else if (*s == '-') {
  1057b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ba:	0f b6 00             	movzbl (%eax),%eax
  1057bd:	3c 2d                	cmp    $0x2d,%al
  1057bf:	75 0a                	jne    1057cb <strtol+0x54>
        s ++, neg = 1;
  1057c1:	ff 45 08             	incl   0x8(%ebp)
  1057c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1057cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057cf:	74 06                	je     1057d7 <strtol+0x60>
  1057d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1057d5:	75 22                	jne    1057f9 <strtol+0x82>
  1057d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057da:	0f b6 00             	movzbl (%eax),%eax
  1057dd:	3c 30                	cmp    $0x30,%al
  1057df:	75 18                	jne    1057f9 <strtol+0x82>
  1057e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e4:	40                   	inc    %eax
  1057e5:	0f b6 00             	movzbl (%eax),%eax
  1057e8:	3c 78                	cmp    $0x78,%al
  1057ea:	75 0d                	jne    1057f9 <strtol+0x82>
        s += 2, base = 16;
  1057ec:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1057f0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1057f7:	eb 29                	jmp    105822 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  1057f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057fd:	75 16                	jne    105815 <strtol+0x9e>
  1057ff:	8b 45 08             	mov    0x8(%ebp),%eax
  105802:	0f b6 00             	movzbl (%eax),%eax
  105805:	3c 30                	cmp    $0x30,%al
  105807:	75 0c                	jne    105815 <strtol+0x9e>
        s ++, base = 8;
  105809:	ff 45 08             	incl   0x8(%ebp)
  10580c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105813:	eb 0d                	jmp    105822 <strtol+0xab>
    }
    else if (base == 0) {
  105815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105819:	75 07                	jne    105822 <strtol+0xab>
        base = 10;
  10581b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105822:	8b 45 08             	mov    0x8(%ebp),%eax
  105825:	0f b6 00             	movzbl (%eax),%eax
  105828:	3c 2f                	cmp    $0x2f,%al
  10582a:	7e 1b                	jle    105847 <strtol+0xd0>
  10582c:	8b 45 08             	mov    0x8(%ebp),%eax
  10582f:	0f b6 00             	movzbl (%eax),%eax
  105832:	3c 39                	cmp    $0x39,%al
  105834:	7f 11                	jg     105847 <strtol+0xd0>
            dig = *s - '0';
  105836:	8b 45 08             	mov    0x8(%ebp),%eax
  105839:	0f b6 00             	movzbl (%eax),%eax
  10583c:	0f be c0             	movsbl %al,%eax
  10583f:	83 e8 30             	sub    $0x30,%eax
  105842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105845:	eb 48                	jmp    10588f <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105847:	8b 45 08             	mov    0x8(%ebp),%eax
  10584a:	0f b6 00             	movzbl (%eax),%eax
  10584d:	3c 60                	cmp    $0x60,%al
  10584f:	7e 1b                	jle    10586c <strtol+0xf5>
  105851:	8b 45 08             	mov    0x8(%ebp),%eax
  105854:	0f b6 00             	movzbl (%eax),%eax
  105857:	3c 7a                	cmp    $0x7a,%al
  105859:	7f 11                	jg     10586c <strtol+0xf5>
            dig = *s - 'a' + 10;
  10585b:	8b 45 08             	mov    0x8(%ebp),%eax
  10585e:	0f b6 00             	movzbl (%eax),%eax
  105861:	0f be c0             	movsbl %al,%eax
  105864:	83 e8 57             	sub    $0x57,%eax
  105867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10586a:	eb 23                	jmp    10588f <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10586c:	8b 45 08             	mov    0x8(%ebp),%eax
  10586f:	0f b6 00             	movzbl (%eax),%eax
  105872:	3c 40                	cmp    $0x40,%al
  105874:	7e 3b                	jle    1058b1 <strtol+0x13a>
  105876:	8b 45 08             	mov    0x8(%ebp),%eax
  105879:	0f b6 00             	movzbl (%eax),%eax
  10587c:	3c 5a                	cmp    $0x5a,%al
  10587e:	7f 31                	jg     1058b1 <strtol+0x13a>
            dig = *s - 'A' + 10;
  105880:	8b 45 08             	mov    0x8(%ebp),%eax
  105883:	0f b6 00             	movzbl (%eax),%eax
  105886:	0f be c0             	movsbl %al,%eax
  105889:	83 e8 37             	sub    $0x37,%eax
  10588c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10588f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105892:	3b 45 10             	cmp    0x10(%ebp),%eax
  105895:	7d 19                	jge    1058b0 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  105897:	ff 45 08             	incl   0x8(%ebp)
  10589a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10589d:	0f af 45 10          	imul   0x10(%ebp),%eax
  1058a1:	89 c2                	mov    %eax,%edx
  1058a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058a6:	01 d0                	add    %edx,%eax
  1058a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1058ab:	e9 72 ff ff ff       	jmp    105822 <strtol+0xab>
            break;
  1058b0:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1058b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058b5:	74 08                	je     1058bf <strtol+0x148>
        *endptr = (char *) s;
  1058b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1058bd:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1058bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1058c3:	74 07                	je     1058cc <strtol+0x155>
  1058c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058c8:	f7 d8                	neg    %eax
  1058ca:	eb 03                	jmp    1058cf <strtol+0x158>
  1058cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1058cf:	c9                   	leave  
  1058d0:	c3                   	ret    

001058d1 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1058d1:	f3 0f 1e fb          	endbr32 
  1058d5:	55                   	push   %ebp
  1058d6:	89 e5                	mov    %esp,%ebp
  1058d8:	57                   	push   %edi
  1058d9:	83 ec 24             	sub    $0x24,%esp
  1058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058df:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1058e2:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1058e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1058ec:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1058ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1058f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1058f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1058f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1058fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1058ff:	89 d7                	mov    %edx,%edi
  105901:	f3 aa                	rep stos %al,%es:(%edi)
  105903:	89 fa                	mov    %edi,%edx
  105905:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105908:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10590b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10590e:	83 c4 24             	add    $0x24,%esp
  105911:	5f                   	pop    %edi
  105912:	5d                   	pop    %ebp
  105913:	c3                   	ret    

00105914 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105914:	f3 0f 1e fb          	endbr32 
  105918:	55                   	push   %ebp
  105919:	89 e5                	mov    %esp,%ebp
  10591b:	57                   	push   %edi
  10591c:	56                   	push   %esi
  10591d:	53                   	push   %ebx
  10591e:	83 ec 30             	sub    $0x30,%esp
  105921:	8b 45 08             	mov    0x8(%ebp),%eax
  105924:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105927:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10592d:	8b 45 10             	mov    0x10(%ebp),%eax
  105930:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105936:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105939:	73 42                	jae    10597d <memmove+0x69>
  10593b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10593e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105944:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10594a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10594d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105950:	c1 e8 02             	shr    $0x2,%eax
  105953:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10595b:	89 d7                	mov    %edx,%edi
  10595d:	89 c6                	mov    %eax,%esi
  10595f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105961:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105964:	83 e1 03             	and    $0x3,%ecx
  105967:	74 02                	je     10596b <memmove+0x57>
  105969:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10596b:	89 f0                	mov    %esi,%eax
  10596d:	89 fa                	mov    %edi,%edx
  10596f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105972:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105975:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10597b:	eb 36                	jmp    1059b3 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10597d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105980:	8d 50 ff             	lea    -0x1(%eax),%edx
  105983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105986:	01 c2                	add    %eax,%edx
  105988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10598b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10598e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105991:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105997:	89 c1                	mov    %eax,%ecx
  105999:	89 d8                	mov    %ebx,%eax
  10599b:	89 d6                	mov    %edx,%esi
  10599d:	89 c7                	mov    %eax,%edi
  10599f:	fd                   	std    
  1059a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059a2:	fc                   	cld    
  1059a3:	89 f8                	mov    %edi,%eax
  1059a5:	89 f2                	mov    %esi,%edx
  1059a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1059aa:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1059ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1059b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1059b3:	83 c4 30             	add    $0x30,%esp
  1059b6:	5b                   	pop    %ebx
  1059b7:	5e                   	pop    %esi
  1059b8:	5f                   	pop    %edi
  1059b9:	5d                   	pop    %ebp
  1059ba:	c3                   	ret    

001059bb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1059bb:	f3 0f 1e fb          	endbr32 
  1059bf:	55                   	push   %ebp
  1059c0:	89 e5                	mov    %esp,%ebp
  1059c2:	57                   	push   %edi
  1059c3:	56                   	push   %esi
  1059c4:	83 ec 20             	sub    $0x20,%esp
  1059c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1059d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1059d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059dc:	c1 e8 02             	shr    $0x2,%eax
  1059df:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1059e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059e7:	89 d7                	mov    %edx,%edi
  1059e9:	89 c6                	mov    %eax,%esi
  1059eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1059ed:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1059f0:	83 e1 03             	and    $0x3,%ecx
  1059f3:	74 02                	je     1059f7 <memcpy+0x3c>
  1059f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059f7:	89 f0                	mov    %esi,%eax
  1059f9:	89 fa                	mov    %edi,%edx
  1059fb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1059fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105a07:	83 c4 20             	add    $0x20,%esp
  105a0a:	5e                   	pop    %esi
  105a0b:	5f                   	pop    %edi
  105a0c:	5d                   	pop    %ebp
  105a0d:	c3                   	ret    

00105a0e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105a0e:	f3 0f 1e fb          	endbr32 
  105a12:	55                   	push   %ebp
  105a13:	89 e5                	mov    %esp,%ebp
  105a15:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105a18:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a21:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105a24:	eb 2e                	jmp    105a54 <memcmp+0x46>
        if (*s1 != *s2) {
  105a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a29:	0f b6 10             	movzbl (%eax),%edx
  105a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a2f:	0f b6 00             	movzbl (%eax),%eax
  105a32:	38 c2                	cmp    %al,%dl
  105a34:	74 18                	je     105a4e <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a39:	0f b6 00             	movzbl (%eax),%eax
  105a3c:	0f b6 d0             	movzbl %al,%edx
  105a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a42:	0f b6 00             	movzbl (%eax),%eax
  105a45:	0f b6 c0             	movzbl %al,%eax
  105a48:	29 c2                	sub    %eax,%edx
  105a4a:	89 d0                	mov    %edx,%eax
  105a4c:	eb 18                	jmp    105a66 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105a4e:	ff 45 fc             	incl   -0x4(%ebp)
  105a51:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105a54:	8b 45 10             	mov    0x10(%ebp),%eax
  105a57:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a5a:	89 55 10             	mov    %edx,0x10(%ebp)
  105a5d:	85 c0                	test   %eax,%eax
  105a5f:	75 c5                	jne    105a26 <memcmp+0x18>
    }
    return 0;
  105a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a66:	c9                   	leave  
  105a67:	c3                   	ret    

00105a68 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105a68:	f3 0f 1e fb          	endbr32 
  105a6c:	55                   	push   %ebp
  105a6d:	89 e5                	mov    %esp,%ebp
  105a6f:	83 ec 58             	sub    $0x58,%esp
  105a72:	8b 45 10             	mov    0x10(%ebp),%eax
  105a75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105a78:	8b 45 14             	mov    0x14(%ebp),%eax
  105a7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105a7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105a81:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a87:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105a8a:	8b 45 18             	mov    0x18(%ebp),%eax
  105a8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a99:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105aa6:	74 1c                	je     105ac4 <printnum+0x5c>
  105aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aab:	ba 00 00 00 00       	mov    $0x0,%edx
  105ab0:	f7 75 e4             	divl   -0x1c(%ebp)
  105ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ab9:	ba 00 00 00 00       	mov    $0x0,%edx
  105abe:	f7 75 e4             	divl   -0x1c(%ebp)
  105ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105aca:	f7 75 e4             	divl   -0x1c(%ebp)
  105acd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ad0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ad6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105adc:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105ae5:	8b 45 18             	mov    0x18(%ebp),%eax
  105ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  105aed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105af0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105af3:	19 d1                	sbb    %edx,%ecx
  105af5:	72 4c                	jb     105b43 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105afa:	8d 50 ff             	lea    -0x1(%eax),%edx
  105afd:	8b 45 20             	mov    0x20(%ebp),%eax
  105b00:	89 44 24 18          	mov    %eax,0x18(%esp)
  105b04:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b08:	8b 45 18             	mov    0x18(%ebp),%eax
  105b0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b15:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b24:	8b 45 08             	mov    0x8(%ebp),%eax
  105b27:	89 04 24             	mov    %eax,(%esp)
  105b2a:	e8 39 ff ff ff       	call   105a68 <printnum>
  105b2f:	eb 1b                	jmp    105b4c <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b38:	8b 45 20             	mov    0x20(%ebp),%eax
  105b3b:	89 04 24             	mov    %eax,(%esp)
  105b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b41:	ff d0                	call   *%eax
        while (-- width > 0)
  105b43:	ff 4d 1c             	decl   0x1c(%ebp)
  105b46:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105b4a:	7f e5                	jg     105b31 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105b4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b4f:	05 8c 72 10 00       	add    $0x10728c,%eax
  105b54:	0f b6 00             	movzbl (%eax),%eax
  105b57:	0f be c0             	movsbl %al,%eax
  105b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b61:	89 04 24             	mov    %eax,(%esp)
  105b64:	8b 45 08             	mov    0x8(%ebp),%eax
  105b67:	ff d0                	call   *%eax
}
  105b69:	90                   	nop
  105b6a:	c9                   	leave  
  105b6b:	c3                   	ret    

00105b6c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105b6c:	f3 0f 1e fb          	endbr32 
  105b70:	55                   	push   %ebp
  105b71:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105b73:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105b77:	7e 14                	jle    105b8d <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  105b79:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7c:	8b 00                	mov    (%eax),%eax
  105b7e:	8d 48 08             	lea    0x8(%eax),%ecx
  105b81:	8b 55 08             	mov    0x8(%ebp),%edx
  105b84:	89 0a                	mov    %ecx,(%edx)
  105b86:	8b 50 04             	mov    0x4(%eax),%edx
  105b89:	8b 00                	mov    (%eax),%eax
  105b8b:	eb 30                	jmp    105bbd <getuint+0x51>
    }
    else if (lflag) {
  105b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b91:	74 16                	je     105ba9 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  105b93:	8b 45 08             	mov    0x8(%ebp),%eax
  105b96:	8b 00                	mov    (%eax),%eax
  105b98:	8d 48 04             	lea    0x4(%eax),%ecx
  105b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  105b9e:	89 0a                	mov    %ecx,(%edx)
  105ba0:	8b 00                	mov    (%eax),%eax
  105ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  105ba7:	eb 14                	jmp    105bbd <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  105ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bac:	8b 00                	mov    (%eax),%eax
  105bae:	8d 48 04             	lea    0x4(%eax),%ecx
  105bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  105bb4:	89 0a                	mov    %ecx,(%edx)
  105bb6:	8b 00                	mov    (%eax),%eax
  105bb8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105bbd:	5d                   	pop    %ebp
  105bbe:	c3                   	ret    

00105bbf <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105bbf:	f3 0f 1e fb          	endbr32 
  105bc3:	55                   	push   %ebp
  105bc4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105bc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105bca:	7e 14                	jle    105be0 <getint+0x21>
        return va_arg(*ap, long long);
  105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcf:	8b 00                	mov    (%eax),%eax
  105bd1:	8d 48 08             	lea    0x8(%eax),%ecx
  105bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  105bd7:	89 0a                	mov    %ecx,(%edx)
  105bd9:	8b 50 04             	mov    0x4(%eax),%edx
  105bdc:	8b 00                	mov    (%eax),%eax
  105bde:	eb 28                	jmp    105c08 <getint+0x49>
    }
    else if (lflag) {
  105be0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105be4:	74 12                	je     105bf8 <getint+0x39>
        return va_arg(*ap, long);
  105be6:	8b 45 08             	mov    0x8(%ebp),%eax
  105be9:	8b 00                	mov    (%eax),%eax
  105beb:	8d 48 04             	lea    0x4(%eax),%ecx
  105bee:	8b 55 08             	mov    0x8(%ebp),%edx
  105bf1:	89 0a                	mov    %ecx,(%edx)
  105bf3:	8b 00                	mov    (%eax),%eax
  105bf5:	99                   	cltd   
  105bf6:	eb 10                	jmp    105c08 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfb:	8b 00                	mov    (%eax),%eax
  105bfd:	8d 48 04             	lea    0x4(%eax),%ecx
  105c00:	8b 55 08             	mov    0x8(%ebp),%edx
  105c03:	89 0a                	mov    %ecx,(%edx)
  105c05:	8b 00                	mov    (%eax),%eax
  105c07:	99                   	cltd   
    }
}
  105c08:	5d                   	pop    %ebp
  105c09:	c3                   	ret    

00105c0a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105c0a:	f3 0f 1e fb          	endbr32 
  105c0e:	55                   	push   %ebp
  105c0f:	89 e5                	mov    %esp,%ebp
  105c11:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105c14:	8d 45 14             	lea    0x14(%ebp),%eax
  105c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c21:	8b 45 10             	mov    0x10(%ebp),%eax
  105c24:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c32:	89 04 24             	mov    %eax,(%esp)
  105c35:	e8 03 00 00 00       	call   105c3d <vprintfmt>
    va_end(ap);
}
  105c3a:	90                   	nop
  105c3b:	c9                   	leave  
  105c3c:	c3                   	ret    

00105c3d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105c3d:	f3 0f 1e fb          	endbr32 
  105c41:	55                   	push   %ebp
  105c42:	89 e5                	mov    %esp,%ebp
  105c44:	56                   	push   %esi
  105c45:	53                   	push   %ebx
  105c46:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c49:	eb 17                	jmp    105c62 <vprintfmt+0x25>
            if (ch == '\0') {
  105c4b:	85 db                	test   %ebx,%ebx
  105c4d:	0f 84 c0 03 00 00    	je     106013 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c5a:	89 1c 24             	mov    %ebx,(%esp)
  105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c60:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c62:	8b 45 10             	mov    0x10(%ebp),%eax
  105c65:	8d 50 01             	lea    0x1(%eax),%edx
  105c68:	89 55 10             	mov    %edx,0x10(%ebp)
  105c6b:	0f b6 00             	movzbl (%eax),%eax
  105c6e:	0f b6 d8             	movzbl %al,%ebx
  105c71:	83 fb 25             	cmp    $0x25,%ebx
  105c74:	75 d5                	jne    105c4b <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105c76:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105c7a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c84:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105c87:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c91:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105c94:	8b 45 10             	mov    0x10(%ebp),%eax
  105c97:	8d 50 01             	lea    0x1(%eax),%edx
  105c9a:	89 55 10             	mov    %edx,0x10(%ebp)
  105c9d:	0f b6 00             	movzbl (%eax),%eax
  105ca0:	0f b6 d8             	movzbl %al,%ebx
  105ca3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105ca6:	83 f8 55             	cmp    $0x55,%eax
  105ca9:	0f 87 38 03 00 00    	ja     105fe7 <vprintfmt+0x3aa>
  105caf:	8b 04 85 b0 72 10 00 	mov    0x1072b0(,%eax,4),%eax
  105cb6:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105cb9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105cbd:	eb d5                	jmp    105c94 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105cbf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105cc3:	eb cf                	jmp    105c94 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105cc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105ccc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ccf:	89 d0                	mov    %edx,%eax
  105cd1:	c1 e0 02             	shl    $0x2,%eax
  105cd4:	01 d0                	add    %edx,%eax
  105cd6:	01 c0                	add    %eax,%eax
  105cd8:	01 d8                	add    %ebx,%eax
  105cda:	83 e8 30             	sub    $0x30,%eax
  105cdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  105ce3:	0f b6 00             	movzbl (%eax),%eax
  105ce6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105ce9:	83 fb 2f             	cmp    $0x2f,%ebx
  105cec:	7e 38                	jle    105d26 <vprintfmt+0xe9>
  105cee:	83 fb 39             	cmp    $0x39,%ebx
  105cf1:	7f 33                	jg     105d26 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105cf3:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105cf6:	eb d4                	jmp    105ccc <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  105cfb:	8d 50 04             	lea    0x4(%eax),%edx
  105cfe:	89 55 14             	mov    %edx,0x14(%ebp)
  105d01:	8b 00                	mov    (%eax),%eax
  105d03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105d06:	eb 1f                	jmp    105d27 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105d08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d0c:	79 86                	jns    105c94 <vprintfmt+0x57>
                width = 0;
  105d0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105d15:	e9 7a ff ff ff       	jmp    105c94 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105d1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105d21:	e9 6e ff ff ff       	jmp    105c94 <vprintfmt+0x57>
            goto process_precision;
  105d26:	90                   	nop

        process_precision:
            if (width < 0)
  105d27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d2b:	0f 89 63 ff ff ff    	jns    105c94 <vprintfmt+0x57>
                width = precision, precision = -1;
  105d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d34:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d37:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105d3e:	e9 51 ff ff ff       	jmp    105c94 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105d43:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105d46:	e9 49 ff ff ff       	jmp    105c94 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  105d4e:	8d 50 04             	lea    0x4(%eax),%edx
  105d51:	89 55 14             	mov    %edx,0x14(%ebp)
  105d54:	8b 00                	mov    (%eax),%eax
  105d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d59:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d5d:	89 04 24             	mov    %eax,(%esp)
  105d60:	8b 45 08             	mov    0x8(%ebp),%eax
  105d63:	ff d0                	call   *%eax
            break;
  105d65:	e9 a4 02 00 00       	jmp    10600e <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  105d6d:	8d 50 04             	lea    0x4(%eax),%edx
  105d70:	89 55 14             	mov    %edx,0x14(%ebp)
  105d73:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105d75:	85 db                	test   %ebx,%ebx
  105d77:	79 02                	jns    105d7b <vprintfmt+0x13e>
                err = -err;
  105d79:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105d7b:	83 fb 06             	cmp    $0x6,%ebx
  105d7e:	7f 0b                	jg     105d8b <vprintfmt+0x14e>
  105d80:	8b 34 9d 70 72 10 00 	mov    0x107270(,%ebx,4),%esi
  105d87:	85 f6                	test   %esi,%esi
  105d89:	75 23                	jne    105dae <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105d8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105d8f:	c7 44 24 08 9d 72 10 	movl   $0x10729d,0x8(%esp)
  105d96:	00 
  105d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  105da1:	89 04 24             	mov    %eax,(%esp)
  105da4:	e8 61 fe ff ff       	call   105c0a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105da9:	e9 60 02 00 00       	jmp    10600e <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105dae:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105db2:	c7 44 24 08 a6 72 10 	movl   $0x1072a6,0x8(%esp)
  105db9:	00 
  105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc4:	89 04 24             	mov    %eax,(%esp)
  105dc7:	e8 3e fe ff ff       	call   105c0a <printfmt>
            break;
  105dcc:	e9 3d 02 00 00       	jmp    10600e <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  105dd4:	8d 50 04             	lea    0x4(%eax),%edx
  105dd7:	89 55 14             	mov    %edx,0x14(%ebp)
  105dda:	8b 30                	mov    (%eax),%esi
  105ddc:	85 f6                	test   %esi,%esi
  105dde:	75 05                	jne    105de5 <vprintfmt+0x1a8>
                p = "(null)";
  105de0:	be a9 72 10 00       	mov    $0x1072a9,%esi
            }
            if (width > 0 && padc != '-') {
  105de5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105de9:	7e 76                	jle    105e61 <vprintfmt+0x224>
  105deb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105def:	74 70                	je     105e61 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105df8:	89 34 24             	mov    %esi,(%esp)
  105dfb:	e8 ba f7 ff ff       	call   1055ba <strnlen>
  105e00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105e03:	29 c2                	sub    %eax,%edx
  105e05:	89 d0                	mov    %edx,%eax
  105e07:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e0a:	eb 16                	jmp    105e22 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105e0c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e13:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e17:	89 04 24             	mov    %eax,(%esp)
  105e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1d:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e1f:	ff 4d e8             	decl   -0x18(%ebp)
  105e22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e26:	7f e4                	jg     105e0c <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e28:	eb 37                	jmp    105e61 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105e2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105e2e:	74 1f                	je     105e4f <vprintfmt+0x212>
  105e30:	83 fb 1f             	cmp    $0x1f,%ebx
  105e33:	7e 05                	jle    105e3a <vprintfmt+0x1fd>
  105e35:	83 fb 7e             	cmp    $0x7e,%ebx
  105e38:	7e 15                	jle    105e4f <vprintfmt+0x212>
                    putch('?', putdat);
  105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e41:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105e48:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4b:	ff d0                	call   *%eax
  105e4d:	eb 0f                	jmp    105e5e <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e56:	89 1c 24             	mov    %ebx,(%esp)
  105e59:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5c:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e5e:	ff 4d e8             	decl   -0x18(%ebp)
  105e61:	89 f0                	mov    %esi,%eax
  105e63:	8d 70 01             	lea    0x1(%eax),%esi
  105e66:	0f b6 00             	movzbl (%eax),%eax
  105e69:	0f be d8             	movsbl %al,%ebx
  105e6c:	85 db                	test   %ebx,%ebx
  105e6e:	74 27                	je     105e97 <vprintfmt+0x25a>
  105e70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e74:	78 b4                	js     105e2a <vprintfmt+0x1ed>
  105e76:	ff 4d e4             	decl   -0x1c(%ebp)
  105e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e7d:	79 ab                	jns    105e2a <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105e7f:	eb 16                	jmp    105e97 <vprintfmt+0x25a>
                putch(' ', putdat);
  105e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e88:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e92:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105e94:	ff 4d e8             	decl   -0x18(%ebp)
  105e97:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e9b:	7f e4                	jg     105e81 <vprintfmt+0x244>
            }
            break;
  105e9d:	e9 6c 01 00 00       	jmp    10600e <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ea9:	8d 45 14             	lea    0x14(%ebp),%eax
  105eac:	89 04 24             	mov    %eax,(%esp)
  105eaf:	e8 0b fd ff ff       	call   105bbf <getint>
  105eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ec0:	85 d2                	test   %edx,%edx
  105ec2:	79 26                	jns    105eea <vprintfmt+0x2ad>
                putch('-', putdat);
  105ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ecb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed5:	ff d0                	call   *%eax
                num = -(long long)num;
  105ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105edd:	f7 d8                	neg    %eax
  105edf:	83 d2 00             	adc    $0x0,%edx
  105ee2:	f7 da                	neg    %edx
  105ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105eea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105ef1:	e9 a8 00 00 00       	jmp    105f9e <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105efd:	8d 45 14             	lea    0x14(%ebp),%eax
  105f00:	89 04 24             	mov    %eax,(%esp)
  105f03:	e8 64 fc ff ff       	call   105b6c <getuint>
  105f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105f0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f15:	e9 84 00 00 00       	jmp    105f9e <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f21:	8d 45 14             	lea    0x14(%ebp),%eax
  105f24:	89 04 24             	mov    %eax,(%esp)
  105f27:	e8 40 fc ff ff       	call   105b6c <getuint>
  105f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105f32:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105f39:	eb 63                	jmp    105f9e <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  105f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f42:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105f49:	8b 45 08             	mov    0x8(%ebp),%eax
  105f4c:	ff d0                	call   *%eax
            putch('x', putdat);
  105f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f55:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105f61:	8b 45 14             	mov    0x14(%ebp),%eax
  105f64:	8d 50 04             	lea    0x4(%eax),%edx
  105f67:	89 55 14             	mov    %edx,0x14(%ebp)
  105f6a:	8b 00                	mov    (%eax),%eax
  105f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105f76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105f7d:	eb 1f                	jmp    105f9e <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f82:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f86:	8d 45 14             	lea    0x14(%ebp),%eax
  105f89:	89 04 24             	mov    %eax,(%esp)
  105f8c:	e8 db fb ff ff       	call   105b6c <getuint>
  105f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f94:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105f97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105f9e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fa5:	89 54 24 18          	mov    %edx,0x18(%esp)
  105fa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105fac:	89 54 24 14          	mov    %edx,0x14(%esp)
  105fb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  105fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fba:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fbe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105fcc:	89 04 24             	mov    %eax,(%esp)
  105fcf:	e8 94 fa ff ff       	call   105a68 <printnum>
            break;
  105fd4:	eb 38                	jmp    10600e <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fdd:	89 1c 24             	mov    %ebx,(%esp)
  105fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe3:	ff d0                	call   *%eax
            break;
  105fe5:	eb 27                	jmp    10600e <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff8:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105ffa:	ff 4d 10             	decl   0x10(%ebp)
  105ffd:	eb 03                	jmp    106002 <vprintfmt+0x3c5>
  105fff:	ff 4d 10             	decl   0x10(%ebp)
  106002:	8b 45 10             	mov    0x10(%ebp),%eax
  106005:	48                   	dec    %eax
  106006:	0f b6 00             	movzbl (%eax),%eax
  106009:	3c 25                	cmp    $0x25,%al
  10600b:	75 f2                	jne    105fff <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10600d:	90                   	nop
    while (1) {
  10600e:	e9 36 fc ff ff       	jmp    105c49 <vprintfmt+0xc>
                return;
  106013:	90                   	nop
        }
    }
}
  106014:	83 c4 40             	add    $0x40,%esp
  106017:	5b                   	pop    %ebx
  106018:	5e                   	pop    %esi
  106019:	5d                   	pop    %ebp
  10601a:	c3                   	ret    

0010601b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10601b:	f3 0f 1e fb          	endbr32 
  10601f:	55                   	push   %ebp
  106020:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106022:	8b 45 0c             	mov    0xc(%ebp),%eax
  106025:	8b 40 08             	mov    0x8(%eax),%eax
  106028:	8d 50 01             	lea    0x1(%eax),%edx
  10602b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10602e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106031:	8b 45 0c             	mov    0xc(%ebp),%eax
  106034:	8b 10                	mov    (%eax),%edx
  106036:	8b 45 0c             	mov    0xc(%ebp),%eax
  106039:	8b 40 04             	mov    0x4(%eax),%eax
  10603c:	39 c2                	cmp    %eax,%edx
  10603e:	73 12                	jae    106052 <sprintputch+0x37>
        *b->buf ++ = ch;
  106040:	8b 45 0c             	mov    0xc(%ebp),%eax
  106043:	8b 00                	mov    (%eax),%eax
  106045:	8d 48 01             	lea    0x1(%eax),%ecx
  106048:	8b 55 0c             	mov    0xc(%ebp),%edx
  10604b:	89 0a                	mov    %ecx,(%edx)
  10604d:	8b 55 08             	mov    0x8(%ebp),%edx
  106050:	88 10                	mov    %dl,(%eax)
    }
}
  106052:	90                   	nop
  106053:	5d                   	pop    %ebp
  106054:	c3                   	ret    

00106055 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106055:	f3 0f 1e fb          	endbr32 
  106059:	55                   	push   %ebp
  10605a:	89 e5                	mov    %esp,%ebp
  10605c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10605f:	8d 45 14             	lea    0x14(%ebp),%eax
  106062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106068:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10606c:	8b 45 10             	mov    0x10(%ebp),%eax
  10606f:	89 44 24 08          	mov    %eax,0x8(%esp)
  106073:	8b 45 0c             	mov    0xc(%ebp),%eax
  106076:	89 44 24 04          	mov    %eax,0x4(%esp)
  10607a:	8b 45 08             	mov    0x8(%ebp),%eax
  10607d:	89 04 24             	mov    %eax,(%esp)
  106080:	e8 08 00 00 00       	call   10608d <vsnprintf>
  106085:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106088:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10608b:	c9                   	leave  
  10608c:	c3                   	ret    

0010608d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10608d:	f3 0f 1e fb          	endbr32 
  106091:	55                   	push   %ebp
  106092:	89 e5                	mov    %esp,%ebp
  106094:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106097:	8b 45 08             	mov    0x8(%ebp),%eax
  10609a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10609d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1060a6:	01 d0                	add    %edx,%eax
  1060a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1060b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1060b6:	74 0a                	je     1060c2 <vsnprintf+0x35>
  1060b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1060bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060be:	39 c2                	cmp    %eax,%edx
  1060c0:	76 07                	jbe    1060c9 <vsnprintf+0x3c>
        return -E_INVAL;
  1060c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1060c7:	eb 2a                	jmp    1060f3 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1060c9:	8b 45 14             	mov    0x14(%ebp),%eax
  1060cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1060d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1060da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060de:	c7 04 24 1b 60 10 00 	movl   $0x10601b,(%esp)
  1060e5:	e8 53 fb ff ff       	call   105c3d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1060ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060ed:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1060f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1060f3:	c9                   	leave  
  1060f4:	c3                   	ret    
