
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
  10005d:	e8 b6 56 00 00       	call   105718 <memset>

    cons_init();                // init the console
  100062:	e8 4b 16 00 00       	call   1016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 5f 10 00 	movl   $0x105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 5f 10 00 	movl   $0x105f5c,(%esp)
  10007c:	e8 39 02 00 00       	call   1002ba <cprintf>

    print_kerninfo();
  100081:	e8 f7 08 00 00       	call   10097d <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 b0 31 00 00       	call   103240 <pmm_init>

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
  100176:	c7 04 24 61 5f 10 00 	movl   $0x105f61,(%esp)
  10017d:	e8 38 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 6f 5f 10 00 	movl   $0x105f6f,(%esp)
  10019c:	e8 19 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 7d 5f 10 00 	movl   $0x105f7d,(%esp)
  1001bb:	e8 fa 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 8b 5f 10 00 	movl   $0x105f8b,(%esp)
  1001da:	e8 db 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 99 5f 10 00 	movl   $0x105f99,(%esp)
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
  10022f:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  100236:	e8 7f 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_user();
  10023b:	e8 cc ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  100240:	e8 05 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100245:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
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
  1002b0:	e8 cf 57 00 00       	call   105a84 <vprintfmt>
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
  100384:	c7 04 24 e7 5f 10 00 	movl   $0x105fe7,(%esp)
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
  100457:	c7 04 24 ea 5f 10 00 	movl   $0x105fea,(%esp)
  10045e:	e8 57 fe ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046a:	8b 45 10             	mov    0x10(%ebp),%eax
  10046d:	89 04 24             	mov    %eax,(%esp)
  100470:	e8 0e fe ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  100475:	c7 04 24 06 60 10 00 	movl   $0x106006,(%esp)
  10047c:	e8 39 fe ff ff       	call   1002ba <cprintf>
    
    cprintf("stack trackback:\n");
  100481:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
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
  1004c6:	c7 04 24 1a 60 10 00 	movl   $0x10601a,(%esp)
  1004cd:	e8 e8 fd ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  1004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 04 24             	mov    %eax,(%esp)
  1004df:	e8 9f fd ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  1004e4:	c7 04 24 06 60 10 00 	movl   $0x106006,(%esp)
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
  100660:	c7 00 38 60 10 00    	movl   $0x106038,(%eax)
    info->eip_line = 0;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100670:	8b 45 0c             	mov    0xc(%ebp),%eax
  100673:	c7 40 08 38 60 10 00 	movl   $0x106038,0x8(%eax)
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
  100697:	c7 45 f4 48 72 10 00 	movl   $0x107248,-0xc(%ebp)
    stab_end = __STAB_END__;
  10069e:	c7 45 f0 d8 38 11 00 	movl   $0x1138d8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006a5:	c7 45 ec d9 38 11 00 	movl   $0x1138d9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006ac:	c7 45 e8 e6 63 11 00 	movl   $0x1163e6,-0x18(%ebp)

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
  1007ff:	e8 88 4d 00 00       	call   10558c <strfind>
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
  100987:	c7 04 24 42 60 10 00 	movl   $0x106042,(%esp)
  10098e:	e8 27 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100993:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10099a:	00 
  10099b:	c7 04 24 5b 60 10 00 	movl   $0x10605b,(%esp)
  1009a2:	e8 13 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009a7:	c7 44 24 04 3c 5f 10 	movl   $0x105f3c,0x4(%esp)
  1009ae:	00 
  1009af:	c7 04 24 73 60 10 00 	movl   $0x106073,(%esp)
  1009b6:	e8 ff f8 ff ff       	call   1002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009bb:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009c2:	00 
  1009c3:	c7 04 24 8b 60 10 00 	movl   $0x10608b,(%esp)
  1009ca:	e8 eb f8 ff ff       	call   1002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009cf:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 a3 60 10 00 	movl   $0x1060a3,(%esp)
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
  100a04:	c7 04 24 bc 60 10 00 	movl   $0x1060bc,(%esp)
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
  100a3d:	c7 04 24 e6 60 10 00 	movl   $0x1060e6,(%esp)
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
  100aab:	c7 04 24 02 61 10 00 	movl   $0x106102,(%esp)
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
  100b07:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
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
  100b43:	c7 04 24 27 61 10 00 	movl   $0x106127,(%esp)
  100b4a:	e8 6b f7 ff ff       	call   1002ba <cprintf>
        cprintf("\n");
  100b4f:	c7 04 24 40 61 10 00 	movl   $0x106140,(%esp)
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
  100bcc:	c7 04 24 c4 61 10 00 	movl   $0x1061c4,(%esp)
  100bd3:	e8 7e 49 00 00       	call   105556 <strchr>
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
  100bf4:	c7 04 24 c9 61 10 00 	movl   $0x1061c9,(%esp)
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
  100c36:	c7 04 24 c4 61 10 00 	movl   $0x1061c4,(%esp)
  100c3d:	e8 14 49 00 00       	call   105556 <strchr>
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
  100ca7:	e8 06 48 00 00       	call   1054b2 <strcmp>
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
  100cf3:	c7 04 24 e7 61 10 00 	movl   $0x1061e7,(%esp)
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
  100d14:	c7 04 24 00 62 10 00 	movl   $0x106200,(%esp)
  100d1b:	e8 9a f5 ff ff       	call   1002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d20:	c7 04 24 28 62 10 00 	movl   $0x106228,(%esp)
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
  100d3d:	c7 04 24 4d 62 10 00 	movl   $0x10624d,(%esp)
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
  100daf:	c7 04 24 51 62 10 00 	movl   $0x106251,(%esp)
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
  100e49:	c7 04 24 5a 62 10 00 	movl   $0x10625a,(%esp)
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
  1012b9:	e8 9d 44 00 00       	call   10575b <memmove>
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
  101657:	c7 04 24 75 62 10 00 	movl   $0x106275,(%esp)
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
  1016d4:	c7 04 24 81 62 10 00 	movl   $0x106281,(%esp)
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
  1019a3:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
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
  101abd:	8b 04 85 00 66 10 00 	mov    0x106600(,%eax,4),%eax
  101ac4:	eb 18                	jmp    101ade <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ac6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aca:	7e 0d                	jle    101ad9 <trapname+0x2e>
  101acc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ad0:	7f 07                	jg     101ad9 <trapname+0x2e>
        return "Hardware Interrupt";
  101ad2:	b8 aa 62 10 00       	mov    $0x1062aa,%eax
  101ad7:	eb 05                	jmp    101ade <trapname+0x33>
    }
    return "(unknown trap)";
  101ad9:	b8 bd 62 10 00       	mov    $0x1062bd,%eax
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
  101b0a:	c7 04 24 fe 62 10 00 	movl   $0x1062fe,(%esp)
  101b11:	e8 a4 e7 ff ff       	call   1002ba <cprintf>
    print_regs(&tf->tf_regs);
  101b16:	8b 45 08             	mov    0x8(%ebp),%eax
  101b19:	89 04 24             	mov    %eax,(%esp)
  101b1c:	e8 8d 01 00 00       	call   101cae <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2c:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  101b33:	e8 82 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b43:	c7 04 24 22 63 10 00 	movl   $0x106322,(%esp)
  101b4a:	e8 6b e7 ff ff       	call   1002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 35 63 10 00 	movl   $0x106335,(%esp)
  101b61:	e8 54 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b71:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
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
  101b99:	c7 04 24 5b 63 10 00 	movl   $0x10635b,(%esp)
  101ba0:	e8 15 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	8b 40 34             	mov    0x34(%eax),%eax
  101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baf:	c7 04 24 6d 63 10 00 	movl   $0x10636d,(%esp)
  101bb6:	e8 ff e6 ff ff       	call   1002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 38             	mov    0x38(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  101bcc:	e8 e9 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 8b 63 10 00 	movl   $0x10638b,(%esp)
  101be3:	e8 d2 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 40             	mov    0x40(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 9e 63 10 00 	movl   $0x10639e,(%esp)
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
  101c39:	c7 04 24 ad 63 10 00 	movl   $0x1063ad,(%esp)
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
  101c63:	c7 04 24 b1 63 10 00 	movl   $0x1063b1,(%esp)
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
  101c88:	c7 04 24 ba 63 10 00 	movl   $0x1063ba,(%esp)
  101c8f:	e8 26 e6 ff ff       	call   1002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9f:	c7 04 24 c9 63 10 00 	movl   $0x1063c9,(%esp)
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
  101cc1:	c7 04 24 dc 63 10 00 	movl   $0x1063dc,(%esp)
  101cc8:	e8 ed e5 ff ff       	call   1002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd0:	8b 40 04             	mov    0x4(%eax),%eax
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 eb 63 10 00 	movl   $0x1063eb,(%esp)
  101cde:	e8 d7 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 40 08             	mov    0x8(%eax),%eax
  101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ced:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101cf4:	e8 c1 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101d0a:	e8 ab e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d12:	8b 40 10             	mov    0x10(%eax),%eax
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 18 64 10 00 	movl   $0x106418,(%esp)
  101d20:	e8 95 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d25:	8b 45 08             	mov    0x8(%ebp),%eax
  101d28:	8b 40 14             	mov    0x14(%eax),%eax
  101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2f:	c7 04 24 27 64 10 00 	movl   $0x106427,(%esp)
  101d36:	e8 7f e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	8b 40 18             	mov    0x18(%eax),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 36 64 10 00 	movl   $0x106436,(%esp)
  101d4c:	e8 69 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d51:	8b 45 08             	mov    0x8(%ebp),%eax
  101d54:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 45 64 10 00 	movl   $0x106445,(%esp)
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
  101e19:	c7 04 24 54 64 10 00 	movl   $0x106454,(%esp)
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
  101e3f:	c7 04 24 66 64 10 00 	movl   $0x106466,(%esp)
  101e46:	e8 6f e4 ff ff       	call   1002ba <cprintf>
        break;
  101e4b:	eb 55                	jmp    101ea2 <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e4d:	c7 44 24 08 75 64 10 	movl   $0x106475,0x8(%esp)
  101e54:	00 
  101e55:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101e5c:	00 
  101e5d:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
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
  101e82:	c7 44 24 08 96 64 10 	movl   $0x106496,0x8(%esp)
  101e89:	00 
  101e8a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101e91:	00 
  101e92:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
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
  102998:	c7 44 24 08 50 66 10 	movl   $0x106650,0x8(%esp)
  10299f:	00 
  1029a0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1029a7:	00 
  1029a8:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
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
  1029fe:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  102a05:	00 
  102a06:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a0d:	00 
  102a0e:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
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
  102a34:	c7 44 24 08 a4 66 10 	movl   $0x1066a4,0x8(%esp)
  102a3b:	00 
  102a3c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102a43:	00 
  102a44:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
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

00102a84 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102a84:	55                   	push   %ebp
  102a85:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102a87:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8a:	8b 00                	mov    (%eax),%eax
  102a8c:	8d 50 01             	lea    0x1(%eax),%edx
  102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a92:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a94:	8b 45 08             	mov    0x8(%ebp),%eax
  102a97:	8b 00                	mov    (%eax),%eax
}
  102a99:	5d                   	pop    %ebp
  102a9a:	c3                   	ret    

00102a9b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102a9b:	55                   	push   %ebp
  102a9c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa1:	8b 00                	mov    (%eax),%eax
  102aa3:	8d 50 ff             	lea    -0x1(%eax),%edx
  102aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa9:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
  102aae:	8b 00                	mov    (%eax),%eax
}
  102ab0:	5d                   	pop    %ebp
  102ab1:	c3                   	ret    

00102ab2 <__intr_save>:
__intr_save(void) {
  102ab2:	55                   	push   %ebp
  102ab3:	89 e5                	mov    %esp,%ebp
  102ab5:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102ab8:	9c                   	pushf  
  102ab9:	58                   	pop    %eax
  102aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102ac0:	25 00 02 00 00       	and    $0x200,%eax
  102ac5:	85 c0                	test   %eax,%eax
  102ac7:	74 0c                	je     102ad5 <__intr_save+0x23>
        intr_disable();
  102ac9:	e8 b7 ee ff ff       	call   101985 <intr_disable>
        return 1;
  102ace:	b8 01 00 00 00       	mov    $0x1,%eax
  102ad3:	eb 05                	jmp    102ada <__intr_save+0x28>
    return 0;
  102ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ada:	c9                   	leave  
  102adb:	c3                   	ret    

00102adc <__intr_restore>:
__intr_restore(bool flag) {
  102adc:	55                   	push   %ebp
  102add:	89 e5                	mov    %esp,%ebp
  102adf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ae6:	74 05                	je     102aed <__intr_restore+0x11>
        intr_enable();
  102ae8:	e8 8c ee ff ff       	call   101979 <intr_enable>
}
  102aed:	90                   	nop
  102aee:	c9                   	leave  
  102aef:	c3                   	ret    

00102af0 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102af0:	55                   	push   %ebp
  102af1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102af3:	8b 45 08             	mov    0x8(%ebp),%eax
  102af6:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102af9:	b8 23 00 00 00       	mov    $0x23,%eax
  102afe:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b00:	b8 23 00 00 00       	mov    $0x23,%eax
  102b05:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b07:	b8 10 00 00 00       	mov    $0x10,%eax
  102b0c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b0e:	b8 10 00 00 00       	mov    $0x10,%eax
  102b13:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b15:	b8 10 00 00 00       	mov    $0x10,%eax
  102b1a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b1c:	ea 23 2b 10 00 08 00 	ljmp   $0x8,$0x102b23
}
  102b23:	90                   	nop
  102b24:	5d                   	pop    %ebp
  102b25:	c3                   	ret    

00102b26 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b26:	f3 0f 1e fb          	endbr32 
  102b2a:	55                   	push   %ebp
  102b2b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b30:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102b35:	90                   	nop
  102b36:	5d                   	pop    %ebp
  102b37:	c3                   	ret    

00102b38 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b38:	f3 0f 1e fb          	endbr32 
  102b3c:	55                   	push   %ebp
  102b3d:	89 e5                	mov    %esp,%ebp
  102b3f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b42:	b8 00 90 11 00       	mov    $0x119000,%eax
  102b47:	89 04 24             	mov    %eax,(%esp)
  102b4a:	e8 d7 ff ff ff       	call   102b26 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102b4f:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102b56:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b58:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102b5f:	68 00 
  102b61:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b66:	0f b7 c0             	movzwl %ax,%eax
  102b69:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102b6f:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b74:	c1 e8 10             	shr    $0x10,%eax
  102b77:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102b7c:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102b83:	24 f0                	and    $0xf0,%al
  102b85:	0c 09                	or     $0x9,%al
  102b87:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102b8c:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102b93:	24 ef                	and    $0xef,%al
  102b95:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102b9a:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102ba1:	24 9f                	and    $0x9f,%al
  102ba3:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102ba8:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102baf:	0c 80                	or     $0x80,%al
  102bb1:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bb6:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bbd:	24 f0                	and    $0xf0,%al
  102bbf:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bc4:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bcb:	24 ef                	and    $0xef,%al
  102bcd:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bd2:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bd9:	24 df                	and    $0xdf,%al
  102bdb:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102be0:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102be7:	0c 40                	or     $0x40,%al
  102be9:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bee:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bf5:	24 7f                	and    $0x7f,%al
  102bf7:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bfc:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c01:	c1 e8 18             	shr    $0x18,%eax
  102c04:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c09:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102c10:	e8 db fe ff ff       	call   102af0 <lgdt>
  102c15:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c1b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c1f:	0f 00 d8             	ltr    %ax
}
  102c22:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c23:	90                   	nop
  102c24:	c9                   	leave  
  102c25:	c3                   	ret    

00102c26 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c26:	f3 0f 1e fb          	endbr32 
  102c2a:	55                   	push   %ebp
  102c2b:	89 e5                	mov    %esp,%ebp
  102c2d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c30:	c7 05 10 cf 11 00 30 	movl   $0x107030,0x11cf10
  102c37:	70 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c3a:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c3f:	8b 00                	mov    (%eax),%eax
  102c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c45:	c7 04 24 d0 66 10 00 	movl   $0x1066d0,(%esp)
  102c4c:	e8 69 d6 ff ff       	call   1002ba <cprintf>
    pmm_manager->init();
  102c51:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c56:	8b 40 04             	mov    0x4(%eax),%eax
  102c59:	ff d0                	call   *%eax
}
  102c5b:	90                   	nop
  102c5c:	c9                   	leave  
  102c5d:	c3                   	ret    

00102c5e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c5e:	f3 0f 1e fb          	endbr32 
  102c62:	55                   	push   %ebp
  102c63:	89 e5                	mov    %esp,%ebp
  102c65:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102c68:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c6d:	8b 40 08             	mov    0x8(%eax),%eax
  102c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c73:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c77:	8b 55 08             	mov    0x8(%ebp),%edx
  102c7a:	89 14 24             	mov    %edx,(%esp)
  102c7d:	ff d0                	call   *%eax
}
  102c7f:	90                   	nop
  102c80:	c9                   	leave  
  102c81:	c3                   	ret    

00102c82 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102c82:	f3 0f 1e fb          	endbr32 
  102c86:	55                   	push   %ebp
  102c87:	89 e5                	mov    %esp,%ebp
  102c89:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102c93:	e8 1a fe ff ff       	call   102ab2 <__intr_save>
  102c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102c9b:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  102ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca6:	89 14 24             	mov    %edx,(%esp)
  102ca9:	ff d0                	call   *%eax
  102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb1:	89 04 24             	mov    %eax,(%esp)
  102cb4:	e8 23 fe ff ff       	call   102adc <__intr_restore>
    return page;
  102cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cbc:	c9                   	leave  
  102cbd:	c3                   	ret    

00102cbe <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102cbe:	f3 0f 1e fb          	endbr32 
  102cc2:	55                   	push   %ebp
  102cc3:	89 e5                	mov    %esp,%ebp
  102cc5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102cc8:	e8 e5 fd ff ff       	call   102ab2 <__intr_save>
  102ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cd0:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102cd5:	8b 40 10             	mov    0x10(%eax),%eax
  102cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  102ce2:	89 14 24             	mov    %edx,(%esp)
  102ce5:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cea:	89 04 24             	mov    %eax,(%esp)
  102ced:	e8 ea fd ff ff       	call   102adc <__intr_restore>
}
  102cf2:	90                   	nop
  102cf3:	c9                   	leave  
  102cf4:	c3                   	ret    

00102cf5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102cf5:	f3 0f 1e fb          	endbr32 
  102cf9:	55                   	push   %ebp
  102cfa:	89 e5                	mov    %esp,%ebp
  102cfc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102cff:	e8 ae fd ff ff       	call   102ab2 <__intr_save>
  102d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d07:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d0c:	8b 40 14             	mov    0x14(%eax),%eax
  102d0f:	ff d0                	call   *%eax
  102d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d17:	89 04 24             	mov    %eax,(%esp)
  102d1a:	e8 bd fd ff ff       	call   102adc <__intr_restore>
    return ret;
  102d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d22:	c9                   	leave  
  102d23:	c3                   	ret    

00102d24 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d24:	f3 0f 1e fb          	endbr32 
  102d28:	55                   	push   %ebp
  102d29:	89 e5                	mov    %esp,%ebp
  102d2b:	57                   	push   %edi
  102d2c:	56                   	push   %esi
  102d2d:	53                   	push   %ebx
  102d2e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d34:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d49:	c7 04 24 e7 66 10 00 	movl   $0x1066e7,(%esp)
  102d50:	e8 65 d5 ff ff       	call   1002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d55:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d5c:	e9 1a 01 00 00       	jmp    102e7b <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d67:	89 d0                	mov    %edx,%eax
  102d69:	c1 e0 02             	shl    $0x2,%eax
  102d6c:	01 d0                	add    %edx,%eax
  102d6e:	c1 e0 02             	shl    $0x2,%eax
  102d71:	01 c8                	add    %ecx,%eax
  102d73:	8b 50 08             	mov    0x8(%eax),%edx
  102d76:	8b 40 04             	mov    0x4(%eax),%eax
  102d79:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102d7c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d85:	89 d0                	mov    %edx,%eax
  102d87:	c1 e0 02             	shl    $0x2,%eax
  102d8a:	01 d0                	add    %edx,%eax
  102d8c:	c1 e0 02             	shl    $0x2,%eax
  102d8f:	01 c8                	add    %ecx,%eax
  102d91:	8b 48 0c             	mov    0xc(%eax),%ecx
  102d94:	8b 58 10             	mov    0x10(%eax),%ebx
  102d97:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d9a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102d9d:	01 c8                	add    %ecx,%eax
  102d9f:	11 da                	adc    %ebx,%edx
  102da1:	89 45 98             	mov    %eax,-0x68(%ebp)
  102da4:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102da7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102daa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dad:	89 d0                	mov    %edx,%eax
  102daf:	c1 e0 02             	shl    $0x2,%eax
  102db2:	01 d0                	add    %edx,%eax
  102db4:	c1 e0 02             	shl    $0x2,%eax
  102db7:	01 c8                	add    %ecx,%eax
  102db9:	83 c0 14             	add    $0x14,%eax
  102dbc:	8b 00                	mov    (%eax),%eax
  102dbe:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102dc1:	8b 45 98             	mov    -0x68(%ebp),%eax
  102dc4:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102dc7:	83 c0 ff             	add    $0xffffffff,%eax
  102dca:	83 d2 ff             	adc    $0xffffffff,%edx
  102dcd:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102dd3:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102dd9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ddc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ddf:	89 d0                	mov    %edx,%eax
  102de1:	c1 e0 02             	shl    $0x2,%eax
  102de4:	01 d0                	add    %edx,%eax
  102de6:	c1 e0 02             	shl    $0x2,%eax
  102de9:	01 c8                	add    %ecx,%eax
  102deb:	8b 48 0c             	mov    0xc(%eax),%ecx
  102dee:	8b 58 10             	mov    0x10(%eax),%ebx
  102df1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102df4:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102df8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102dfe:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102e04:	89 44 24 14          	mov    %eax,0x14(%esp)
  102e08:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e0c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e0f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e16:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e1e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e22:	c7 04 24 f4 66 10 00 	movl   $0x1066f4,(%esp)
  102e29:	e8 8c d4 ff ff       	call   1002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e2e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e34:	89 d0                	mov    %edx,%eax
  102e36:	c1 e0 02             	shl    $0x2,%eax
  102e39:	01 d0                	add    %edx,%eax
  102e3b:	c1 e0 02             	shl    $0x2,%eax
  102e3e:	01 c8                	add    %ecx,%eax
  102e40:	83 c0 14             	add    $0x14,%eax
  102e43:	8b 00                	mov    (%eax),%eax
  102e45:	83 f8 01             	cmp    $0x1,%eax
  102e48:	75 2e                	jne    102e78 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  102e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e50:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102e53:	89 d0                	mov    %edx,%eax
  102e55:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102e58:	73 1e                	jae    102e78 <page_init+0x154>
  102e5a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  102e64:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102e67:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102e6a:	72 0c                	jb     102e78 <page_init+0x154>
                maxpa = end;
  102e6c:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e6f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102e78:	ff 45 dc             	incl   -0x24(%ebp)
  102e7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e7e:	8b 00                	mov    (%eax),%eax
  102e80:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102e83:	0f 8c d8 fe ff ff    	jl     102d61 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102e89:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  102e93:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102e96:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102e99:	73 0e                	jae    102ea9 <page_init+0x185>
        maxpa = KMEMSIZE;
  102e9b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ea2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eaf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102eb3:	c1 ea 0c             	shr    $0xc,%edx
  102eb6:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ebb:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102ec2:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102ec7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102eca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ecd:	01 d0                	add    %edx,%eax
  102ecf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102ed2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  102eda:	f7 75 c0             	divl   -0x40(%ebp)
  102edd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ee0:	29 d0                	sub    %edx,%eax
  102ee2:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i ++) {
  102ee7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102eee:	eb 2f                	jmp    102f1f <page_init+0x1fb>
        SetPageReserved(pages + i);
  102ef0:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102ef6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ef9:	89 d0                	mov    %edx,%eax
  102efb:	c1 e0 02             	shl    $0x2,%eax
  102efe:	01 d0                	add    %edx,%eax
  102f00:	c1 e0 02             	shl    $0x2,%eax
  102f03:	01 c8                	add    %ecx,%eax
  102f05:	83 c0 04             	add    $0x4,%eax
  102f08:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102f0f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f12:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f15:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f18:	0f ab 10             	bts    %edx,(%eax)
}
  102f1b:	90                   	nop
    for (i = 0; i < npage; i ++) {
  102f1c:	ff 45 dc             	incl   -0x24(%ebp)
  102f1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f22:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102f27:	39 c2                	cmp    %eax,%edx
  102f29:	72 c5                	jb     102ef0 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f2b:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  102f31:	89 d0                	mov    %edx,%eax
  102f33:	c1 e0 02             	shl    $0x2,%eax
  102f36:	01 d0                	add    %edx,%eax
  102f38:	c1 e0 02             	shl    $0x2,%eax
  102f3b:	89 c2                	mov    %eax,%edx
  102f3d:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102f42:	01 d0                	add    %edx,%eax
  102f44:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102f47:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102f4e:	77 23                	ja     102f73 <page_init+0x24f>
  102f50:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f57:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  102f5e:	00 
  102f5f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f66:	00 
  102f67:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  102f6e:	e8 b3 d4 ff ff       	call   100426 <__panic>
  102f73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f76:	05 00 00 00 40       	add    $0x40000000,%eax
  102f7b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102f7e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f85:	e9 4b 01 00 00       	jmp    1030d5 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f8a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f90:	89 d0                	mov    %edx,%eax
  102f92:	c1 e0 02             	shl    $0x2,%eax
  102f95:	01 d0                	add    %edx,%eax
  102f97:	c1 e0 02             	shl    $0x2,%eax
  102f9a:	01 c8                	add    %ecx,%eax
  102f9c:	8b 50 08             	mov    0x8(%eax),%edx
  102f9f:	8b 40 04             	mov    0x4(%eax),%eax
  102fa2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fa5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fa8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fae:	89 d0                	mov    %edx,%eax
  102fb0:	c1 e0 02             	shl    $0x2,%eax
  102fb3:	01 d0                	add    %edx,%eax
  102fb5:	c1 e0 02             	shl    $0x2,%eax
  102fb8:	01 c8                	add    %ecx,%eax
  102fba:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fbd:	8b 58 10             	mov    0x10(%eax),%ebx
  102fc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fc3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fc6:	01 c8                	add    %ecx,%eax
  102fc8:	11 da                	adc    %ebx,%edx
  102fca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102fcd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102fd0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fd6:	89 d0                	mov    %edx,%eax
  102fd8:	c1 e0 02             	shl    $0x2,%eax
  102fdb:	01 d0                	add    %edx,%eax
  102fdd:	c1 e0 02             	shl    $0x2,%eax
  102fe0:	01 c8                	add    %ecx,%eax
  102fe2:	83 c0 14             	add    $0x14,%eax
  102fe5:	8b 00                	mov    (%eax),%eax
  102fe7:	83 f8 01             	cmp    $0x1,%eax
  102fea:	0f 85 e2 00 00 00    	jne    1030d2 <page_init+0x3ae>
            if (begin < freemem) {
  102ff0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ff3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ff8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102ffb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102ffe:	19 d1                	sbb    %edx,%ecx
  103000:	73 0d                	jae    10300f <page_init+0x2eb>
                begin = freemem;
  103002:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103005:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103008:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10300f:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103014:	b8 00 00 00 00       	mov    $0x0,%eax
  103019:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  10301c:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10301f:	73 0e                	jae    10302f <page_init+0x30b>
                end = KMEMSIZE;
  103021:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103028:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10302f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103032:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103035:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103038:	89 d0                	mov    %edx,%eax
  10303a:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10303d:	0f 83 8f 00 00 00    	jae    1030d2 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  103043:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10304a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10304d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103050:	01 d0                	add    %edx,%eax
  103052:	48                   	dec    %eax
  103053:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103056:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103059:	ba 00 00 00 00       	mov    $0x0,%edx
  10305e:	f7 75 b0             	divl   -0x50(%ebp)
  103061:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103064:	29 d0                	sub    %edx,%eax
  103066:	ba 00 00 00 00       	mov    $0x0,%edx
  10306b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10306e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103071:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103074:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103077:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10307a:	ba 00 00 00 00       	mov    $0x0,%edx
  10307f:	89 c3                	mov    %eax,%ebx
  103081:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103087:	89 de                	mov    %ebx,%esi
  103089:	89 d0                	mov    %edx,%eax
  10308b:	83 e0 00             	and    $0x0,%eax
  10308e:	89 c7                	mov    %eax,%edi
  103090:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103093:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103096:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103099:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10309c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10309f:	89 d0                	mov    %edx,%eax
  1030a1:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030a4:	73 2c                	jae    1030d2 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1030ac:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1030af:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1030b2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030b6:	c1 ea 0c             	shr    $0xc,%edx
  1030b9:	89 c3                	mov    %eax,%ebx
  1030bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030be:	89 04 24             	mov    %eax,(%esp)
  1030c1:	e8 bb f8 ff ff       	call   102981 <pa2page>
  1030c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1030ca:	89 04 24             	mov    %eax,(%esp)
  1030cd:	e8 8c fb ff ff       	call   102c5e <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1030d2:	ff 45 dc             	incl   -0x24(%ebp)
  1030d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030d8:	8b 00                	mov    (%eax),%eax
  1030da:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030dd:	0f 8c a7 fe ff ff    	jl     102f8a <page_init+0x266>
                }
            }
        }
    }
}
  1030e3:	90                   	nop
  1030e4:	90                   	nop
  1030e5:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1030eb:	5b                   	pop    %ebx
  1030ec:	5e                   	pop    %esi
  1030ed:	5f                   	pop    %edi
  1030ee:	5d                   	pop    %ebp
  1030ef:	c3                   	ret    

001030f0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1030f0:	f3 0f 1e fb          	endbr32 
  1030f4:	55                   	push   %ebp
  1030f5:	89 e5                	mov    %esp,%ebp
  1030f7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1030fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fd:	33 45 14             	xor    0x14(%ebp),%eax
  103100:	25 ff 0f 00 00       	and    $0xfff,%eax
  103105:	85 c0                	test   %eax,%eax
  103107:	74 24                	je     10312d <boot_map_segment+0x3d>
  103109:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103110:	00 
  103111:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103118:	00 
  103119:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103120:	00 
  103121:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103128:	e8 f9 d2 ff ff       	call   100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10312d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103134:	8b 45 0c             	mov    0xc(%ebp),%eax
  103137:	25 ff 0f 00 00       	and    $0xfff,%eax
  10313c:	89 c2                	mov    %eax,%edx
  10313e:	8b 45 10             	mov    0x10(%ebp),%eax
  103141:	01 c2                	add    %eax,%edx
  103143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103146:	01 d0                	add    %edx,%eax
  103148:	48                   	dec    %eax
  103149:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10314c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10314f:	ba 00 00 00 00       	mov    $0x0,%edx
  103154:	f7 75 f0             	divl   -0x10(%ebp)
  103157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315a:	29 d0                	sub    %edx,%eax
  10315c:	c1 e8 0c             	shr    $0xc,%eax
  10315f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103162:	8b 45 0c             	mov    0xc(%ebp),%eax
  103165:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10316b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103170:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103173:	8b 45 14             	mov    0x14(%ebp),%eax
  103176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10317c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103181:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103184:	eb 68                	jmp    1031ee <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103186:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10318d:	00 
  10318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103191:	89 44 24 04          	mov    %eax,0x4(%esp)
  103195:	8b 45 08             	mov    0x8(%ebp),%eax
  103198:	89 04 24             	mov    %eax,(%esp)
  10319b:	e8 8a 01 00 00       	call   10332a <get_pte>
  1031a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031a7:	75 24                	jne    1031cd <boot_map_segment+0xdd>
  1031a9:	c7 44 24 0c 82 67 10 	movl   $0x106782,0xc(%esp)
  1031b0:	00 
  1031b1:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1031b8:	00 
  1031b9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1031c0:	00 
  1031c1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1031c8:	e8 59 d2 ff ff       	call   100426 <__panic>
        *ptep = pa | PTE_P | perm;
  1031cd:	8b 45 14             	mov    0x14(%ebp),%eax
  1031d0:	0b 45 18             	or     0x18(%ebp),%eax
  1031d3:	83 c8 01             	or     $0x1,%eax
  1031d6:	89 c2                	mov    %eax,%edx
  1031d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031db:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031dd:	ff 4d f4             	decl   -0xc(%ebp)
  1031e0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1031e7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1031ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031f2:	75 92                	jne    103186 <boot_map_segment+0x96>
    }
}
  1031f4:	90                   	nop
  1031f5:	90                   	nop
  1031f6:	c9                   	leave  
  1031f7:	c3                   	ret    

001031f8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1031f8:	f3 0f 1e fb          	endbr32 
  1031fc:	55                   	push   %ebp
  1031fd:	89 e5                	mov    %esp,%ebp
  1031ff:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103209:	e8 74 fa ff ff       	call   102c82 <alloc_pages>
  10320e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103215:	75 1c                	jne    103233 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  103217:	c7 44 24 08 8f 67 10 	movl   $0x10678f,0x8(%esp)
  10321e:	00 
  10321f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103226:	00 
  103227:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10322e:	e8 f3 d1 ff ff       	call   100426 <__panic>
    }
    return page2kva(p);
  103233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103236:	89 04 24             	mov    %eax,(%esp)
  103239:	e8 92 f7 ff ff       	call   1029d0 <page2kva>
}
  10323e:	c9                   	leave  
  10323f:	c3                   	ret    

00103240 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103240:	f3 0f 1e fb          	endbr32 
  103244:	55                   	push   %ebp
  103245:	89 e5                	mov    %esp,%ebp
  103247:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10324a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10324f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103252:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103259:	77 23                	ja     10327e <pmm_init+0x3e>
  10325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10325e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103262:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103269:	00 
  10326a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103271:	00 
  103272:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103279:	e8 a8 d1 ff ff       	call   100426 <__panic>
  10327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103281:	05 00 00 00 40       	add    $0x40000000,%eax
  103286:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10328b:	e8 96 f9 ff ff       	call   102c26 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103290:	e8 8f fa ff ff       	call   102d24 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103295:	e8 64 02 00 00       	call   1034fe <check_alloc_page>

    check_pgdir();
  10329a:	e8 82 02 00 00       	call   103521 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10329f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032a7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032ae:	77 23                	ja     1032d3 <pmm_init+0x93>
  1032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032b7:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  1032be:	00 
  1032bf:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1032c6:	00 
  1032c7:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1032ce:	e8 53 d1 ff ff       	call   100426 <__panic>
  1032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d6:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1032dc:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032e1:	05 ac 0f 00 00       	add    $0xfac,%eax
  1032e6:	83 ca 03             	or     $0x3,%edx
  1032e9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1032eb:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032f0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1032f7:	00 
  1032f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1032ff:	00 
  103300:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103307:	38 
  103308:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10330f:	c0 
  103310:	89 04 24             	mov    %eax,(%esp)
  103313:	e8 d8 fd ff ff       	call   1030f0 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103318:	e8 1b f8 ff ff       	call   102b38 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10331d:	e8 9f 08 00 00       	call   103bc1 <check_boot_pgdir>

    print_pgdir();
  103322:	e8 24 0d 00 00       	call   10404b <print_pgdir>

}
  103327:	90                   	nop
  103328:	c9                   	leave  
  103329:	c3                   	ret    

0010332a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10332a:	f3 0f 1e fb          	endbr32 
  10332e:	55                   	push   %ebp
  10332f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  103331:	90                   	nop
  103332:	5d                   	pop    %ebp
  103333:	c3                   	ret    

00103334 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103334:	f3 0f 1e fb          	endbr32 
  103338:	55                   	push   %ebp
  103339:	89 e5                	mov    %esp,%ebp
  10333b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10333e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103345:	00 
  103346:	8b 45 0c             	mov    0xc(%ebp),%eax
  103349:	89 44 24 04          	mov    %eax,0x4(%esp)
  10334d:	8b 45 08             	mov    0x8(%ebp),%eax
  103350:	89 04 24             	mov    %eax,(%esp)
  103353:	e8 d2 ff ff ff       	call   10332a <get_pte>
  103358:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10335b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10335f:	74 08                	je     103369 <get_page+0x35>
        *ptep_store = ptep;
  103361:	8b 45 10             	mov    0x10(%ebp),%eax
  103364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103367:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10336d:	74 1b                	je     10338a <get_page+0x56>
  10336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103372:	8b 00                	mov    (%eax),%eax
  103374:	83 e0 01             	and    $0x1,%eax
  103377:	85 c0                	test   %eax,%eax
  103379:	74 0f                	je     10338a <get_page+0x56>
        return pte2page(*ptep);
  10337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10337e:	8b 00                	mov    (%eax),%eax
  103380:	89 04 24             	mov    %eax,(%esp)
  103383:	e8 9c f6 ff ff       	call   102a24 <pte2page>
  103388:	eb 05                	jmp    10338f <get_page+0x5b>
    }
    return NULL;
  10338a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10338f:	c9                   	leave  
  103390:	c3                   	ret    

00103391 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103391:	55                   	push   %ebp
  103392:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103394:	90                   	nop
  103395:	5d                   	pop    %ebp
  103396:	c3                   	ret    

00103397 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103397:	f3 0f 1e fb          	endbr32 
  10339b:	55                   	push   %ebp
  10339c:	89 e5                	mov    %esp,%ebp
  10339e:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1033a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1033a8:	00 
  1033a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b3:	89 04 24             	mov    %eax,(%esp)
  1033b6:	e8 6f ff ff ff       	call   10332a <get_pte>
  1033bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1033be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033c2:	74 19                	je     1033dd <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  1033c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d5:	89 04 24             	mov    %eax,(%esp)
  1033d8:	e8 b4 ff ff ff       	call   103391 <page_remove_pte>
    }
}
  1033dd:	90                   	nop
  1033de:	c9                   	leave  
  1033df:	c3                   	ret    

001033e0 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1033e0:	f3 0f 1e fb          	endbr32 
  1033e4:	55                   	push   %ebp
  1033e5:	89 e5                	mov    %esp,%ebp
  1033e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1033ea:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1033f1:	00 
  1033f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fc:	89 04 24             	mov    %eax,(%esp)
  1033ff:	e8 26 ff ff ff       	call   10332a <get_pte>
  103404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10340b:	75 0a                	jne    103417 <page_insert+0x37>
        return -E_NO_MEM;
  10340d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103412:	e9 84 00 00 00       	jmp    10349b <page_insert+0xbb>
    }
    page_ref_inc(page);
  103417:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341a:	89 04 24             	mov    %eax,(%esp)
  10341d:	e8 62 f6 ff ff       	call   102a84 <page_ref_inc>
    if (*ptep & PTE_P) {
  103422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103425:	8b 00                	mov    (%eax),%eax
  103427:	83 e0 01             	and    $0x1,%eax
  10342a:	85 c0                	test   %eax,%eax
  10342c:	74 3e                	je     10346c <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  10342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103431:	8b 00                	mov    (%eax),%eax
  103433:	89 04 24             	mov    %eax,(%esp)
  103436:	e8 e9 f5 ff ff       	call   102a24 <pte2page>
  10343b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103444:	75 0d                	jne    103453 <page_insert+0x73>
            page_ref_dec(page);
  103446:	8b 45 0c             	mov    0xc(%ebp),%eax
  103449:	89 04 24             	mov    %eax,(%esp)
  10344c:	e8 4a f6 ff ff       	call   102a9b <page_ref_dec>
  103451:	eb 19                	jmp    10346c <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103456:	89 44 24 08          	mov    %eax,0x8(%esp)
  10345a:	8b 45 10             	mov    0x10(%ebp),%eax
  10345d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103461:	8b 45 08             	mov    0x8(%ebp),%eax
  103464:	89 04 24             	mov    %eax,(%esp)
  103467:	e8 25 ff ff ff       	call   103391 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10346c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10346f:	89 04 24             	mov    %eax,(%esp)
  103472:	e8 f4 f4 ff ff       	call   10296b <page2pa>
  103477:	0b 45 14             	or     0x14(%ebp),%eax
  10347a:	83 c8 01             	or     $0x1,%eax
  10347d:	89 c2                	mov    %eax,%edx
  10347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103482:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103484:	8b 45 10             	mov    0x10(%ebp),%eax
  103487:	89 44 24 04          	mov    %eax,0x4(%esp)
  10348b:	8b 45 08             	mov    0x8(%ebp),%eax
  10348e:	89 04 24             	mov    %eax,(%esp)
  103491:	e8 07 00 00 00       	call   10349d <tlb_invalidate>
    return 0;
  103496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10349b:	c9                   	leave  
  10349c:	c3                   	ret    

0010349d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10349d:	f3 0f 1e fb          	endbr32 
  1034a1:	55                   	push   %ebp
  1034a2:	89 e5                	mov    %esp,%ebp
  1034a4:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1034a7:	0f 20 d8             	mov    %cr3,%eax
  1034aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1034ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034b6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1034bd:	77 23                	ja     1034e2 <tlb_invalidate+0x45>
  1034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034c6:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  1034cd:	00 
  1034ce:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  1034d5:	00 
  1034d6:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1034dd:	e8 44 cf ff ff       	call   100426 <__panic>
  1034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034e5:	05 00 00 00 40       	add    $0x40000000,%eax
  1034ea:	39 d0                	cmp    %edx,%eax
  1034ec:	75 0d                	jne    1034fb <tlb_invalidate+0x5e>
        invlpg((void *)la);
  1034ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034f7:	0f 01 38             	invlpg (%eax)
}
  1034fa:	90                   	nop
    }
}
  1034fb:	90                   	nop
  1034fc:	c9                   	leave  
  1034fd:	c3                   	ret    

001034fe <check_alloc_page>:

static void
check_alloc_page(void) {
  1034fe:	f3 0f 1e fb          	endbr32 
  103502:	55                   	push   %ebp
  103503:	89 e5                	mov    %esp,%ebp
  103505:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103508:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  10350d:	8b 40 18             	mov    0x18(%eax),%eax
  103510:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103512:	c7 04 24 a8 67 10 00 	movl   $0x1067a8,(%esp)
  103519:	e8 9c cd ff ff       	call   1002ba <cprintf>
}
  10351e:	90                   	nop
  10351f:	c9                   	leave  
  103520:	c3                   	ret    

00103521 <check_pgdir>:

static void
check_pgdir(void) {
  103521:	f3 0f 1e fb          	endbr32 
  103525:	55                   	push   %ebp
  103526:	89 e5                	mov    %esp,%ebp
  103528:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10352b:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103530:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103535:	76 24                	jbe    10355b <check_pgdir+0x3a>
  103537:	c7 44 24 0c c7 67 10 	movl   $0x1067c7,0xc(%esp)
  10353e:	00 
  10353f:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103546:	00 
  103547:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  10354e:	00 
  10354f:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103556:	e8 cb ce ff ff       	call   100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10355b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103560:	85 c0                	test   %eax,%eax
  103562:	74 0e                	je     103572 <check_pgdir+0x51>
  103564:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103569:	25 ff 0f 00 00       	and    $0xfff,%eax
  10356e:	85 c0                	test   %eax,%eax
  103570:	74 24                	je     103596 <check_pgdir+0x75>
  103572:	c7 44 24 0c e4 67 10 	movl   $0x1067e4,0xc(%esp)
  103579:	00 
  10357a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103581:	00 
  103582:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  103589:	00 
  10358a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103591:	e8 90 ce ff ff       	call   100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103596:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10359b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1035a2:	00 
  1035a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1035aa:	00 
  1035ab:	89 04 24             	mov    %eax,(%esp)
  1035ae:	e8 81 fd ff ff       	call   103334 <get_page>
  1035b3:	85 c0                	test   %eax,%eax
  1035b5:	74 24                	je     1035db <check_pgdir+0xba>
  1035b7:	c7 44 24 0c 1c 68 10 	movl   $0x10681c,0xc(%esp)
  1035be:	00 
  1035bf:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1035c6:	00 
  1035c7:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  1035ce:	00 
  1035cf:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1035d6:	e8 4b ce ff ff       	call   100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1035db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035e2:	e8 9b f6 ff ff       	call   102c82 <alloc_pages>
  1035e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1035ea:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1035ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1035f6:	00 
  1035f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1035fe:	00 
  1035ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103602:	89 54 24 04          	mov    %edx,0x4(%esp)
  103606:	89 04 24             	mov    %eax,(%esp)
  103609:	e8 d2 fd ff ff       	call   1033e0 <page_insert>
  10360e:	85 c0                	test   %eax,%eax
  103610:	74 24                	je     103636 <check_pgdir+0x115>
  103612:	c7 44 24 0c 44 68 10 	movl   $0x106844,0xc(%esp)
  103619:	00 
  10361a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103621:	00 
  103622:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  103629:	00 
  10362a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103631:	e8 f0 cd ff ff       	call   100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103636:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10363b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103642:	00 
  103643:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10364a:	00 
  10364b:	89 04 24             	mov    %eax,(%esp)
  10364e:	e8 d7 fc ff ff       	call   10332a <get_pte>
  103653:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103656:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10365a:	75 24                	jne    103680 <check_pgdir+0x15f>
  10365c:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  103663:	00 
  103664:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10366b:	00 
  10366c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  103673:	00 
  103674:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10367b:	e8 a6 cd ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103683:	8b 00                	mov    (%eax),%eax
  103685:	89 04 24             	mov    %eax,(%esp)
  103688:	e8 97 f3 ff ff       	call   102a24 <pte2page>
  10368d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103690:	74 24                	je     1036b6 <check_pgdir+0x195>
  103692:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103699:	00 
  10369a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1036a1:	00 
  1036a2:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  1036a9:	00 
  1036aa:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1036b1:	e8 70 cd ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 1);
  1036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036b9:	89 04 24             	mov    %eax,(%esp)
  1036bc:	e8 b9 f3 ff ff       	call   102a7a <page_ref>
  1036c1:	83 f8 01             	cmp    $0x1,%eax
  1036c4:	74 24                	je     1036ea <check_pgdir+0x1c9>
  1036c6:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  1036cd:	00 
  1036ce:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1036d5:	00 
  1036d6:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  1036dd:	00 
  1036de:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1036e5:	e8 3c cd ff ff       	call   100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1036ea:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1036ef:	8b 00                	mov    (%eax),%eax
  1036f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1036f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1036f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036fc:	c1 e8 0c             	shr    $0xc,%eax
  1036ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103702:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103707:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10370a:	72 23                	jb     10372f <check_pgdir+0x20e>
  10370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10370f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103713:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  10371a:	00 
  10371b:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  103722:	00 
  103723:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10372a:	e8 f7 cc ff ff       	call   100426 <__panic>
  10372f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103732:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103737:	83 c0 04             	add    $0x4,%eax
  10373a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10373d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103742:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103749:	00 
  10374a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103751:	00 
  103752:	89 04 24             	mov    %eax,(%esp)
  103755:	e8 d0 fb ff ff       	call   10332a <get_pte>
  10375a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10375d:	74 24                	je     103783 <check_pgdir+0x262>
  10375f:	c7 44 24 0c c8 68 10 	movl   $0x1068c8,0xc(%esp)
  103766:	00 
  103767:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10376e:	00 
  10376f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  103776:	00 
  103777:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10377e:	e8 a3 cc ff ff       	call   100426 <__panic>

    p2 = alloc_page();
  103783:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10378a:	e8 f3 f4 ff ff       	call   102c82 <alloc_pages>
  10378f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103792:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103797:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10379e:	00 
  10379f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1037a6:	00 
  1037a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1037aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1037ae:	89 04 24             	mov    %eax,(%esp)
  1037b1:	e8 2a fc ff ff       	call   1033e0 <page_insert>
  1037b6:	85 c0                	test   %eax,%eax
  1037b8:	74 24                	je     1037de <check_pgdir+0x2bd>
  1037ba:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1037c1:	00 
  1037c2:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1037c9:	00 
  1037ca:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  1037d1:	00 
  1037d2:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1037d9:	e8 48 cc ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1037de:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037ea:	00 
  1037eb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037f2:	00 
  1037f3:	89 04 24             	mov    %eax,(%esp)
  1037f6:	e8 2f fb ff ff       	call   10332a <get_pte>
  1037fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103802:	75 24                	jne    103828 <check_pgdir+0x307>
  103804:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  10380b:	00 
  10380c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103813:	00 
  103814:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  10381b:	00 
  10381c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103823:	e8 fe cb ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_U);
  103828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10382b:	8b 00                	mov    (%eax),%eax
  10382d:	83 e0 04             	and    $0x4,%eax
  103830:	85 c0                	test   %eax,%eax
  103832:	75 24                	jne    103858 <check_pgdir+0x337>
  103834:	c7 44 24 0c 58 69 10 	movl   $0x106958,0xc(%esp)
  10383b:	00 
  10383c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103843:	00 
  103844:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  10384b:	00 
  10384c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103853:	e8 ce cb ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_W);
  103858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10385b:	8b 00                	mov    (%eax),%eax
  10385d:	83 e0 02             	and    $0x2,%eax
  103860:	85 c0                	test   %eax,%eax
  103862:	75 24                	jne    103888 <check_pgdir+0x367>
  103864:	c7 44 24 0c 66 69 10 	movl   $0x106966,0xc(%esp)
  10386b:	00 
  10386c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103873:	00 
  103874:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  10387b:	00 
  10387c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103883:	e8 9e cb ff ff       	call   100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103888:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10388d:	8b 00                	mov    (%eax),%eax
  10388f:	83 e0 04             	and    $0x4,%eax
  103892:	85 c0                	test   %eax,%eax
  103894:	75 24                	jne    1038ba <check_pgdir+0x399>
  103896:	c7 44 24 0c 74 69 10 	movl   $0x106974,0xc(%esp)
  10389d:	00 
  10389e:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038a5:	00 
  1038a6:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1038ad:	00 
  1038ae:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038b5:	e8 6c cb ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 1);
  1038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038bd:	89 04 24             	mov    %eax,(%esp)
  1038c0:	e8 b5 f1 ff ff       	call   102a7a <page_ref>
  1038c5:	83 f8 01             	cmp    $0x1,%eax
  1038c8:	74 24                	je     1038ee <check_pgdir+0x3cd>
  1038ca:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  1038d1:	00 
  1038d2:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038d9:	00 
  1038da:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1038e1:	00 
  1038e2:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038e9:	e8 38 cb ff ff       	call   100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1038ee:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1038fa:	00 
  1038fb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103902:	00 
  103903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103906:	89 54 24 04          	mov    %edx,0x4(%esp)
  10390a:	89 04 24             	mov    %eax,(%esp)
  10390d:	e8 ce fa ff ff       	call   1033e0 <page_insert>
  103912:	85 c0                	test   %eax,%eax
  103914:	74 24                	je     10393a <check_pgdir+0x419>
  103916:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  10391d:	00 
  10391e:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103925:	00 
  103926:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  10392d:	00 
  10392e:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103935:	e8 ec ca ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 2);
  10393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10393d:	89 04 24             	mov    %eax,(%esp)
  103940:	e8 35 f1 ff ff       	call   102a7a <page_ref>
  103945:	83 f8 02             	cmp    $0x2,%eax
  103948:	74 24                	je     10396e <check_pgdir+0x44d>
  10394a:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  103951:	00 
  103952:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103959:	00 
  10395a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103961:	00 
  103962:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103969:	e8 b8 ca ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  10396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103971:	89 04 24             	mov    %eax,(%esp)
  103974:	e8 01 f1 ff ff       	call   102a7a <page_ref>
  103979:	85 c0                	test   %eax,%eax
  10397b:	74 24                	je     1039a1 <check_pgdir+0x480>
  10397d:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103984:	00 
  103985:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10398c:	00 
  10398d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103994:	00 
  103995:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10399c:	e8 85 ca ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1039a1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1039a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039ad:	00 
  1039ae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039b5:	00 
  1039b6:	89 04 24             	mov    %eax,(%esp)
  1039b9:	e8 6c f9 ff ff       	call   10332a <get_pte>
  1039be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039c5:	75 24                	jne    1039eb <check_pgdir+0x4ca>
  1039c7:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  1039ce:	00 
  1039cf:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1039d6:	00 
  1039d7:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1039de:	00 
  1039df:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1039e6:	e8 3b ca ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  1039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039ee:	8b 00                	mov    (%eax),%eax
  1039f0:	89 04 24             	mov    %eax,(%esp)
  1039f3:	e8 2c f0 ff ff       	call   102a24 <pte2page>
  1039f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1039fb:	74 24                	je     103a21 <check_pgdir+0x500>
  1039fd:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103a04:	00 
  103a05:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a0c:	00 
  103a0d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103a14:	00 
  103a15:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a1c:	e8 05 ca ff ff       	call   100426 <__panic>
    assert((*ptep & PTE_U) == 0);
  103a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a24:	8b 00                	mov    (%eax),%eax
  103a26:	83 e0 04             	and    $0x4,%eax
  103a29:	85 c0                	test   %eax,%eax
  103a2b:	74 24                	je     103a51 <check_pgdir+0x530>
  103a2d:	c7 44 24 0c ec 69 10 	movl   $0x1069ec,0xc(%esp)
  103a34:	00 
  103a35:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a3c:	00 
  103a3d:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103a44:	00 
  103a45:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a4c:	e8 d5 c9 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, 0x0);
  103a51:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a5d:	00 
  103a5e:	89 04 24             	mov    %eax,(%esp)
  103a61:	e8 31 f9 ff ff       	call   103397 <page_remove>
    assert(page_ref(p1) == 1);
  103a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a69:	89 04 24             	mov    %eax,(%esp)
  103a6c:	e8 09 f0 ff ff       	call   102a7a <page_ref>
  103a71:	83 f8 01             	cmp    $0x1,%eax
  103a74:	74 24                	je     103a9a <check_pgdir+0x579>
  103a76:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  103a7d:	00 
  103a7e:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a85:	00 
  103a86:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103a8d:	00 
  103a8e:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a95:	e8 8c c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a9d:	89 04 24             	mov    %eax,(%esp)
  103aa0:	e8 d5 ef ff ff       	call   102a7a <page_ref>
  103aa5:	85 c0                	test   %eax,%eax
  103aa7:	74 24                	je     103acd <check_pgdir+0x5ac>
  103aa9:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103ab0:	00 
  103ab1:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ab8:	00 
  103ab9:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103ac0:	00 
  103ac1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103ac8:	e8 59 c9 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103acd:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ad2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ad9:	00 
  103ada:	89 04 24             	mov    %eax,(%esp)
  103add:	e8 b5 f8 ff ff       	call   103397 <page_remove>
    assert(page_ref(p1) == 0);
  103ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ae5:	89 04 24             	mov    %eax,(%esp)
  103ae8:	e8 8d ef ff ff       	call   102a7a <page_ref>
  103aed:	85 c0                	test   %eax,%eax
  103aef:	74 24                	je     103b15 <check_pgdir+0x5f4>
  103af1:	c7 44 24 0c 01 6a 10 	movl   $0x106a01,0xc(%esp)
  103af8:	00 
  103af9:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b00:	00 
  103b01:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103b08:	00 
  103b09:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b10:	e8 11 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b18:	89 04 24             	mov    %eax,(%esp)
  103b1b:	e8 5a ef ff ff       	call   102a7a <page_ref>
  103b20:	85 c0                	test   %eax,%eax
  103b22:	74 24                	je     103b48 <check_pgdir+0x627>
  103b24:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103b2b:	00 
  103b2c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b33:	00 
  103b34:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103b3b:	00 
  103b3c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b43:	e8 de c8 ff ff       	call   100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103b48:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b4d:	8b 00                	mov    (%eax),%eax
  103b4f:	89 04 24             	mov    %eax,(%esp)
  103b52:	e8 0b ef ff ff       	call   102a62 <pde2page>
  103b57:	89 04 24             	mov    %eax,(%esp)
  103b5a:	e8 1b ef ff ff       	call   102a7a <page_ref>
  103b5f:	83 f8 01             	cmp    $0x1,%eax
  103b62:	74 24                	je     103b88 <check_pgdir+0x667>
  103b64:	c7 44 24 0c 14 6a 10 	movl   $0x106a14,0xc(%esp)
  103b6b:	00 
  103b6c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b73:	00 
  103b74:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103b7b:	00 
  103b7c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b83:	e8 9e c8 ff ff       	call   100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103b88:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b8d:	8b 00                	mov    (%eax),%eax
  103b8f:	89 04 24             	mov    %eax,(%esp)
  103b92:	e8 cb ee ff ff       	call   102a62 <pde2page>
  103b97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103b9e:	00 
  103b9f:	89 04 24             	mov    %eax,(%esp)
  103ba2:	e8 17 f1 ff ff       	call   102cbe <free_pages>
    boot_pgdir[0] = 0;
  103ba7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103bb2:	c7 04 24 3b 6a 10 00 	movl   $0x106a3b,(%esp)
  103bb9:	e8 fc c6 ff ff       	call   1002ba <cprintf>
}
  103bbe:	90                   	nop
  103bbf:	c9                   	leave  
  103bc0:	c3                   	ret    

00103bc1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103bc1:	f3 0f 1e fb          	endbr32 
  103bc5:	55                   	push   %ebp
  103bc6:	89 e5                	mov    %esp,%ebp
  103bc8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103bd2:	e9 ca 00 00 00       	jmp    103ca1 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103be0:	c1 e8 0c             	shr    $0xc,%eax
  103be3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103be6:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103beb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103bee:	72 23                	jb     103c13 <check_boot_pgdir+0x52>
  103bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103bf7:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  103bfe:	00 
  103bff:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103c06:	00 
  103c07:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c0e:	e8 13 c8 ff ff       	call   100426 <__panic>
  103c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c16:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103c1b:	89 c2                	mov    %eax,%edx
  103c1d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c29:	00 
  103c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c2e:	89 04 24             	mov    %eax,(%esp)
  103c31:	e8 f4 f6 ff ff       	call   10332a <get_pte>
  103c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103c3d:	75 24                	jne    103c63 <check_boot_pgdir+0xa2>
  103c3f:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  103c46:	00 
  103c47:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103c4e:	00 
  103c4f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103c56:	00 
  103c57:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c5e:	e8 c3 c7 ff ff       	call   100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103c66:	8b 00                	mov    (%eax),%eax
  103c68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c6d:	89 c2                	mov    %eax,%edx
  103c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c72:	39 c2                	cmp    %eax,%edx
  103c74:	74 24                	je     103c9a <check_boot_pgdir+0xd9>
  103c76:	c7 44 24 0c 95 6a 10 	movl   $0x106a95,0xc(%esp)
  103c7d:	00 
  103c7e:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103c85:	00 
  103c86:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103c8d:	00 
  103c8e:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c95:	e8 8c c7 ff ff       	call   100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103c9a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ca4:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103ca9:	39 c2                	cmp    %eax,%edx
  103cab:	0f 82 26 ff ff ff    	jb     103bd7 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103cb1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103cb6:	05 ac 0f 00 00       	add    $0xfac,%eax
  103cbb:	8b 00                	mov    (%eax),%eax
  103cbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cc2:	89 c2                	mov    %eax,%edx
  103cc4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ccc:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103cd3:	77 23                	ja     103cf8 <check_boot_pgdir+0x137>
  103cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103cdc:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103ce3:	00 
  103ce4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103ceb:	00 
  103cec:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103cf3:	e8 2e c7 ff ff       	call   100426 <__panic>
  103cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cfb:	05 00 00 00 40       	add    $0x40000000,%eax
  103d00:	39 d0                	cmp    %edx,%eax
  103d02:	74 24                	je     103d28 <check_boot_pgdir+0x167>
  103d04:	c7 44 24 0c ac 6a 10 	movl   $0x106aac,0xc(%esp)
  103d0b:	00 
  103d0c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103d13:	00 
  103d14:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103d1b:	00 
  103d1c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d23:	e8 fe c6 ff ff       	call   100426 <__panic>

    assert(boot_pgdir[0] == 0);
  103d28:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d2d:	8b 00                	mov    (%eax),%eax
  103d2f:	85 c0                	test   %eax,%eax
  103d31:	74 24                	je     103d57 <check_boot_pgdir+0x196>
  103d33:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  103d3a:	00 
  103d3b:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103d42:	00 
  103d43:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103d4a:	00 
  103d4b:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d52:	e8 cf c6 ff ff       	call   100426 <__panic>

    struct Page *p;
    p = alloc_page();
  103d57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103d5e:	e8 1f ef ff ff       	call   102c82 <alloc_pages>
  103d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103d66:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d6b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103d72:	00 
  103d73:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103d7a:	00 
  103d7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103d7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d82:	89 04 24             	mov    %eax,(%esp)
  103d85:	e8 56 f6 ff ff       	call   1033e0 <page_insert>
  103d8a:	85 c0                	test   %eax,%eax
  103d8c:	74 24                	je     103db2 <check_boot_pgdir+0x1f1>
  103d8e:	c7 44 24 0c f4 6a 10 	movl   $0x106af4,0xc(%esp)
  103d95:	00 
  103d96:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103d9d:	00 
  103d9e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103da5:	00 
  103da6:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103dad:	e8 74 c6 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 1);
  103db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103db5:	89 04 24             	mov    %eax,(%esp)
  103db8:	e8 bd ec ff ff       	call   102a7a <page_ref>
  103dbd:	83 f8 01             	cmp    $0x1,%eax
  103dc0:	74 24                	je     103de6 <check_boot_pgdir+0x225>
  103dc2:	c7 44 24 0c 22 6b 10 	movl   $0x106b22,0xc(%esp)
  103dc9:	00 
  103dca:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103dd1:	00 
  103dd2:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103dd9:	00 
  103dda:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103de1:	e8 40 c6 ff ff       	call   100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103de6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103deb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103df2:	00 
  103df3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103dfa:	00 
  103dfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103dfe:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e02:	89 04 24             	mov    %eax,(%esp)
  103e05:	e8 d6 f5 ff ff       	call   1033e0 <page_insert>
  103e0a:	85 c0                	test   %eax,%eax
  103e0c:	74 24                	je     103e32 <check_boot_pgdir+0x271>
  103e0e:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103e15:	00 
  103e16:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e1d:	00 
  103e1e:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103e25:	00 
  103e26:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e2d:	e8 f4 c5 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 2);
  103e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e35:	89 04 24             	mov    %eax,(%esp)
  103e38:	e8 3d ec ff ff       	call   102a7a <page_ref>
  103e3d:	83 f8 02             	cmp    $0x2,%eax
  103e40:	74 24                	je     103e66 <check_boot_pgdir+0x2a5>
  103e42:	c7 44 24 0c 6b 6b 10 	movl   $0x106b6b,0xc(%esp)
  103e49:	00 
  103e4a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e51:	00 
  103e52:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103e59:	00 
  103e5a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e61:	e8 c0 c5 ff ff       	call   100426 <__panic>

    const char *str = "ucore: Hello world!!";
  103e66:	c7 45 e8 7c 6b 10 00 	movl   $0x106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e74:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103e7b:	e8 b4 15 00 00       	call   105434 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103e80:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103e87:	00 
  103e88:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103e8f:	e8 1e 16 00 00       	call   1054b2 <strcmp>
  103e94:	85 c0                	test   %eax,%eax
  103e96:	74 24                	je     103ebc <check_boot_pgdir+0x2fb>
  103e98:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  103e9f:	00 
  103ea0:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ea7:	00 
  103ea8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103eaf:	00 
  103eb0:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103eb7:	e8 6a c5 ff ff       	call   100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ebf:	89 04 24             	mov    %eax,(%esp)
  103ec2:	e8 09 eb ff ff       	call   1029d0 <page2kva>
  103ec7:	05 00 01 00 00       	add    $0x100,%eax
  103ecc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103ecf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103ed6:	e8 fb 14 00 00       	call   1053d6 <strlen>
  103edb:	85 c0                	test   %eax,%eax
  103edd:	74 24                	je     103f03 <check_boot_pgdir+0x342>
  103edf:	c7 44 24 0c cc 6b 10 	movl   $0x106bcc,0xc(%esp)
  103ee6:	00 
  103ee7:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103eee:	00 
  103eef:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103ef6:	00 
  103ef7:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103efe:	e8 23 c5 ff ff       	call   100426 <__panic>

    free_page(p);
  103f03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f0a:	00 
  103f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f0e:	89 04 24             	mov    %eax,(%esp)
  103f11:	e8 a8 ed ff ff       	call   102cbe <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103f16:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f1b:	8b 00                	mov    (%eax),%eax
  103f1d:	89 04 24             	mov    %eax,(%esp)
  103f20:	e8 3d eb ff ff       	call   102a62 <pde2page>
  103f25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f2c:	00 
  103f2d:	89 04 24             	mov    %eax,(%esp)
  103f30:	e8 89 ed ff ff       	call   102cbe <free_pages>
    boot_pgdir[0] = 0;
  103f35:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103f40:	c7 04 24 f0 6b 10 00 	movl   $0x106bf0,(%esp)
  103f47:	e8 6e c3 ff ff       	call   1002ba <cprintf>
}
  103f4c:	90                   	nop
  103f4d:	c9                   	leave  
  103f4e:	c3                   	ret    

00103f4f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103f4f:	f3 0f 1e fb          	endbr32 
  103f53:	55                   	push   %ebp
  103f54:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103f56:	8b 45 08             	mov    0x8(%ebp),%eax
  103f59:	83 e0 04             	and    $0x4,%eax
  103f5c:	85 c0                	test   %eax,%eax
  103f5e:	74 04                	je     103f64 <perm2str+0x15>
  103f60:	b0 75                	mov    $0x75,%al
  103f62:	eb 02                	jmp    103f66 <perm2str+0x17>
  103f64:	b0 2d                	mov    $0x2d,%al
  103f66:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  103f6b:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103f72:	8b 45 08             	mov    0x8(%ebp),%eax
  103f75:	83 e0 02             	and    $0x2,%eax
  103f78:	85 c0                	test   %eax,%eax
  103f7a:	74 04                	je     103f80 <perm2str+0x31>
  103f7c:	b0 77                	mov    $0x77,%al
  103f7e:	eb 02                	jmp    103f82 <perm2str+0x33>
  103f80:	b0 2d                	mov    $0x2d,%al
  103f82:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  103f87:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  103f8e:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  103f93:	5d                   	pop    %ebp
  103f94:	c3                   	ret    

00103f95 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103f95:	f3 0f 1e fb          	endbr32 
  103f99:	55                   	push   %ebp
  103f9a:	89 e5                	mov    %esp,%ebp
  103f9c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  103fa2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fa5:	72 0d                	jb     103fb4 <get_pgtable_items+0x1f>
        return 0;
  103fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  103fac:	e9 98 00 00 00       	jmp    104049 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103fb1:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  103fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  103fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fba:	73 18                	jae    103fd4 <get_pgtable_items+0x3f>
  103fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  103fbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  103fc9:	01 d0                	add    %edx,%eax
  103fcb:	8b 00                	mov    (%eax),%eax
  103fcd:	83 e0 01             	and    $0x1,%eax
  103fd0:	85 c0                	test   %eax,%eax
  103fd2:	74 dd                	je     103fb1 <get_pgtable_items+0x1c>
    }
    if (start < right) {
  103fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  103fd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103fda:	73 68                	jae    104044 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  103fdc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103fe0:	74 08                	je     103fea <get_pgtable_items+0x55>
            *left_store = start;
  103fe2:	8b 45 18             	mov    0x18(%ebp),%eax
  103fe5:	8b 55 10             	mov    0x10(%ebp),%edx
  103fe8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103fea:	8b 45 10             	mov    0x10(%ebp),%eax
  103fed:	8d 50 01             	lea    0x1(%eax),%edx
  103ff0:	89 55 10             	mov    %edx,0x10(%ebp)
  103ff3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103ffa:	8b 45 14             	mov    0x14(%ebp),%eax
  103ffd:	01 d0                	add    %edx,%eax
  103fff:	8b 00                	mov    (%eax),%eax
  104001:	83 e0 07             	and    $0x7,%eax
  104004:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104007:	eb 03                	jmp    10400c <get_pgtable_items+0x77>
            start ++;
  104009:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10400c:	8b 45 10             	mov    0x10(%ebp),%eax
  10400f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104012:	73 1d                	jae    104031 <get_pgtable_items+0x9c>
  104014:	8b 45 10             	mov    0x10(%ebp),%eax
  104017:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10401e:	8b 45 14             	mov    0x14(%ebp),%eax
  104021:	01 d0                	add    %edx,%eax
  104023:	8b 00                	mov    (%eax),%eax
  104025:	83 e0 07             	and    $0x7,%eax
  104028:	89 c2                	mov    %eax,%edx
  10402a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10402d:	39 c2                	cmp    %eax,%edx
  10402f:	74 d8                	je     104009 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  104031:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104035:	74 08                	je     10403f <get_pgtable_items+0xaa>
            *right_store = start;
  104037:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10403a:	8b 55 10             	mov    0x10(%ebp),%edx
  10403d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10403f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104042:	eb 05                	jmp    104049 <get_pgtable_items+0xb4>
    }
    return 0;
  104044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104049:	c9                   	leave  
  10404a:	c3                   	ret    

0010404b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10404b:	f3 0f 1e fb          	endbr32 
  10404f:	55                   	push   %ebp
  104050:	89 e5                	mov    %esp,%ebp
  104052:	57                   	push   %edi
  104053:	56                   	push   %esi
  104054:	53                   	push   %ebx
  104055:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104058:	c7 04 24 10 6c 10 00 	movl   $0x106c10,(%esp)
  10405f:	e8 56 c2 ff ff       	call   1002ba <cprintf>
    size_t left, right = 0, perm;
  104064:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10406b:	e9 fa 00 00 00       	jmp    10416a <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104073:	89 04 24             	mov    %eax,(%esp)
  104076:	e8 d4 fe ff ff       	call   103f4f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10407b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10407e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104081:	29 d1                	sub    %edx,%ecx
  104083:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104085:	89 d6                	mov    %edx,%esi
  104087:	c1 e6 16             	shl    $0x16,%esi
  10408a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10408d:	89 d3                	mov    %edx,%ebx
  10408f:	c1 e3 16             	shl    $0x16,%ebx
  104092:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104095:	89 d1                	mov    %edx,%ecx
  104097:	c1 e1 16             	shl    $0x16,%ecx
  10409a:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10409d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1040a0:	29 d7                	sub    %edx,%edi
  1040a2:	89 fa                	mov    %edi,%edx
  1040a4:	89 44 24 14          	mov    %eax,0x14(%esp)
  1040a8:	89 74 24 10          	mov    %esi,0x10(%esp)
  1040ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1040b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1040b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040b8:	c7 04 24 41 6c 10 00 	movl   $0x106c41,(%esp)
  1040bf:	e8 f6 c1 ff ff       	call   1002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
  1040c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040c7:	c1 e0 0a             	shl    $0xa,%eax
  1040ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1040cd:	eb 54                	jmp    104123 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1040cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040d2:	89 04 24             	mov    %eax,(%esp)
  1040d5:	e8 75 fe ff ff       	call   103f4f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1040da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1040dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1040e0:	29 d1                	sub    %edx,%ecx
  1040e2:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1040e4:	89 d6                	mov    %edx,%esi
  1040e6:	c1 e6 0c             	shl    $0xc,%esi
  1040e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040ec:	89 d3                	mov    %edx,%ebx
  1040ee:	c1 e3 0c             	shl    $0xc,%ebx
  1040f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1040f4:	89 d1                	mov    %edx,%ecx
  1040f6:	c1 e1 0c             	shl    $0xc,%ecx
  1040f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1040fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1040ff:	29 d7                	sub    %edx,%edi
  104101:	89 fa                	mov    %edi,%edx
  104103:	89 44 24 14          	mov    %eax,0x14(%esp)
  104107:	89 74 24 10          	mov    %esi,0x10(%esp)
  10410b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10410f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104113:	89 54 24 04          	mov    %edx,0x4(%esp)
  104117:	c7 04 24 60 6c 10 00 	movl   $0x106c60,(%esp)
  10411e:	e8 97 c1 ff ff       	call   1002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104123:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104128:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10412b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10412e:	89 d3                	mov    %edx,%ebx
  104130:	c1 e3 0a             	shl    $0xa,%ebx
  104133:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104136:	89 d1                	mov    %edx,%ecx
  104138:	c1 e1 0a             	shl    $0xa,%ecx
  10413b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10413e:	89 54 24 14          	mov    %edx,0x14(%esp)
  104142:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104145:	89 54 24 10          	mov    %edx,0x10(%esp)
  104149:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10414d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104151:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104155:	89 0c 24             	mov    %ecx,(%esp)
  104158:	e8 38 fe ff ff       	call   103f95 <get_pgtable_items>
  10415d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104160:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104164:	0f 85 65 ff ff ff    	jne    1040cf <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10416a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10416f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104172:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104175:	89 54 24 14          	mov    %edx,0x14(%esp)
  104179:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10417c:	89 54 24 10          	mov    %edx,0x10(%esp)
  104180:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104184:	89 44 24 08          	mov    %eax,0x8(%esp)
  104188:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10418f:	00 
  104190:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104197:	e8 f9 fd ff ff       	call   103f95 <get_pgtable_items>
  10419c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10419f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1041a3:	0f 85 c7 fe ff ff    	jne    104070 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1041a9:	c7 04 24 84 6c 10 00 	movl   $0x106c84,(%esp)
  1041b0:	e8 05 c1 ff ff       	call   1002ba <cprintf>
}
  1041b5:	90                   	nop
  1041b6:	83 c4 4c             	add    $0x4c,%esp
  1041b9:	5b                   	pop    %ebx
  1041ba:	5e                   	pop    %esi
  1041bb:	5f                   	pop    %edi
  1041bc:	5d                   	pop    %ebp
  1041bd:	c3                   	ret    

001041be <page2ppn>:
page2ppn(struct Page *page) {
  1041be:	55                   	push   %ebp
  1041bf:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1041c1:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  1041c6:	8b 55 08             	mov    0x8(%ebp),%edx
  1041c9:	29 c2                	sub    %eax,%edx
  1041cb:	89 d0                	mov    %edx,%eax
  1041cd:	c1 f8 02             	sar    $0x2,%eax
  1041d0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1041d6:	5d                   	pop    %ebp
  1041d7:	c3                   	ret    

001041d8 <page2pa>:
page2pa(struct Page *page) {
  1041d8:	55                   	push   %ebp
  1041d9:	89 e5                	mov    %esp,%ebp
  1041db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1041de:	8b 45 08             	mov    0x8(%ebp),%eax
  1041e1:	89 04 24             	mov    %eax,(%esp)
  1041e4:	e8 d5 ff ff ff       	call   1041be <page2ppn>
  1041e9:	c1 e0 0c             	shl    $0xc,%eax
}
  1041ec:	c9                   	leave  
  1041ed:	c3                   	ret    

001041ee <page_ref>:
page_ref(struct Page *page) {
  1041ee:	55                   	push   %ebp
  1041ef:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1041f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1041f4:	8b 00                	mov    (%eax),%eax
}
  1041f6:	5d                   	pop    %ebp
  1041f7:	c3                   	ret    

001041f8 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1041f8:	55                   	push   %ebp
  1041f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1041fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1041fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  104201:	89 10                	mov    %edx,(%eax)
}
  104203:	90                   	nop
  104204:	5d                   	pop    %ebp
  104205:	c3                   	ret    

00104206 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104206:	f3 0f 1e fb          	endbr32 
  10420a:	55                   	push   %ebp
  10420b:	89 e5                	mov    %esp,%ebp
  10420d:	83 ec 10             	sub    $0x10,%esp
  104210:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10421a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10421d:	89 50 04             	mov    %edx,0x4(%eax)
  104220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104223:	8b 50 04             	mov    0x4(%eax),%edx
  104226:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104229:	89 10                	mov    %edx,(%eax)
}
  10422b:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  10422c:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104233:	00 00 00 
}
  104236:	90                   	nop
  104237:	c9                   	leave  
  104238:	c3                   	ret    

00104239 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104239:	f3 0f 1e fb          	endbr32 
  10423d:	55                   	push   %ebp
  10423e:	89 e5                	mov    %esp,%ebp
  104240:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  104243:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104247:	75 24                	jne    10426d <default_init_memmap+0x34>
  104249:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  104250:	00 
  104251:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104258:	00 
  104259:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  104260:	00 
  104261:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104268:	e8 b9 c1 ff ff       	call   100426 <__panic>
    struct Page *p = base;
  10426d:	8b 45 08             	mov    0x8(%ebp),%eax
  104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104273:	eb 7d                	jmp    1042f2 <default_init_memmap+0xb9>
        assert(PageReserved(p));
  104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104278:	83 c0 04             	add    $0x4,%eax
  10427b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104282:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104288:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10428b:	0f a3 10             	bt     %edx,(%eax)
  10428e:	19 c0                	sbb    %eax,%eax
  104290:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104297:	0f 95 c0             	setne  %al
  10429a:	0f b6 c0             	movzbl %al,%eax
  10429d:	85 c0                	test   %eax,%eax
  10429f:	75 24                	jne    1042c5 <default_init_memmap+0x8c>
  1042a1:	c7 44 24 0c e9 6c 10 	movl   $0x106ce9,0xc(%esp)
  1042a8:	00 
  1042a9:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1042b0:	00 
  1042b1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1042b8:	00 
  1042b9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1042c0:	e8 61 c1 ff ff       	call   100426 <__panic>
        p->flags = p->property = 0;
  1042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1042cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042d2:	8b 50 08             	mov    0x8(%eax),%edx
  1042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042d8:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1042db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042e2:	00 
  1042e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042e6:	89 04 24             	mov    %eax,(%esp)
  1042e9:	e8 0a ff ff ff       	call   1041f8 <set_page_ref>
    for (; p != base + n; p ++) {
  1042ee:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1042f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042f5:	89 d0                	mov    %edx,%eax
  1042f7:	c1 e0 02             	shl    $0x2,%eax
  1042fa:	01 d0                	add    %edx,%eax
  1042fc:	c1 e0 02             	shl    $0x2,%eax
  1042ff:	89 c2                	mov    %eax,%edx
  104301:	8b 45 08             	mov    0x8(%ebp),%eax
  104304:	01 d0                	add    %edx,%eax
  104306:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104309:	0f 85 66 ff ff ff    	jne    104275 <default_init_memmap+0x3c>
    }
    base->property = n;
  10430f:	8b 45 08             	mov    0x8(%ebp),%eax
  104312:	8b 55 0c             	mov    0xc(%ebp),%edx
  104315:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104318:	8b 45 08             	mov    0x8(%ebp),%eax
  10431b:	83 c0 04             	add    $0x4,%eax
  10431e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104325:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104328:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10432b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10432e:	0f ab 10             	bts    %edx,(%eax)
}
  104331:	90                   	nop
    nr_free += n;
  104332:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104338:	8b 45 0c             	mov    0xc(%ebp),%eax
  10433b:	01 d0                	add    %edx,%eax
  10433d:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    list_add(&free_list, &(base->page_link));
  104342:	8b 45 08             	mov    0x8(%ebp),%eax
  104345:	83 c0 0c             	add    $0xc,%eax
  104348:	c7 45 e4 1c cf 11 00 	movl   $0x11cf1c,-0x1c(%ebp)
  10434f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104355:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10435b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10435e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104361:	8b 40 04             	mov    0x4(%eax),%eax
  104364:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104367:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10436a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10436d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104370:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104379:	89 10                	mov    %edx,(%eax)
  10437b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10437e:	8b 10                	mov    (%eax),%edx
  104380:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104383:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104389:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10438c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10438f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104392:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104395:	89 10                	mov    %edx,(%eax)
}
  104397:	90                   	nop
}
  104398:	90                   	nop
}
  104399:	90                   	nop
}
  10439a:	90                   	nop
  10439b:	c9                   	leave  
  10439c:	c3                   	ret    

0010439d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10439d:	f3 0f 1e fb          	endbr32 
  1043a1:	55                   	push   %ebp
  1043a2:	89 e5                	mov    %esp,%ebp
  1043a4:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1043a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1043ab:	75 24                	jne    1043d1 <default_alloc_pages+0x34>
  1043ad:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  1043b4:	00 
  1043b5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1043bc:	00 
  1043bd:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1043c4:	00 
  1043c5:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1043cc:	e8 55 c0 ff ff       	call   100426 <__panic>
    if (n > nr_free) {
  1043d1:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1043d6:	39 45 08             	cmp    %eax,0x8(%ebp)
  1043d9:	76 0a                	jbe    1043e5 <default_alloc_pages+0x48>
        return NULL;
  1043db:	b8 00 00 00 00       	mov    $0x0,%eax
  1043e0:	e9 4e 01 00 00       	jmp    104533 <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
  1043e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1043ec:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1043f3:	eb 1c                	jmp    104411 <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  1043f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043f8:	83 e8 0c             	sub    $0xc,%eax
  1043fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1043fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104401:	8b 40 08             	mov    0x8(%eax),%eax
  104404:	39 45 08             	cmp    %eax,0x8(%ebp)
  104407:	77 08                	ja     104411 <default_alloc_pages+0x74>
            page = p;
  104409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10440c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10440f:	eb 18                	jmp    104429 <default_alloc_pages+0x8c>
  104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10441a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10441d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104420:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  104427:	75 cc                	jne    1043f5 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  104429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10442d:	0f 84 fd 00 00 00    	je     104530 <default_alloc_pages+0x193>
        list_del(&(page->page_link));
  104433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104436:	83 c0 0c             	add    $0xc,%eax
  104439:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  10443c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10443f:	8b 40 04             	mov    0x4(%eax),%eax
  104442:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104445:	8b 12                	mov    (%edx),%edx
  104447:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10444a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10444d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104450:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104453:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104456:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104459:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10445c:	89 10                	mov    %edx,(%eax)
}
  10445e:	90                   	nop
}
  10445f:	90                   	nop
        if (page->property > n) {
  104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104463:	8b 40 08             	mov    0x8(%eax),%eax
  104466:	39 45 08             	cmp    %eax,0x8(%ebp)
  104469:	0f 83 9a 00 00 00    	jae    104509 <default_alloc_pages+0x16c>
            struct Page *p = page + n;
  10446f:	8b 55 08             	mov    0x8(%ebp),%edx
  104472:	89 d0                	mov    %edx,%eax
  104474:	c1 e0 02             	shl    $0x2,%eax
  104477:	01 d0                	add    %edx,%eax
  104479:	c1 e0 02             	shl    $0x2,%eax
  10447c:	89 c2                	mov    %eax,%edx
  10447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104481:	01 d0                	add    %edx,%eax
  104483:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104489:	8b 40 08             	mov    0x8(%eax),%eax
  10448c:	2b 45 08             	sub    0x8(%ebp),%eax
  10448f:	89 c2                	mov    %eax,%edx
  104491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104494:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10449a:	83 c0 04             	add    $0x4,%eax
  10449d:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1044a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1044aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1044ad:	0f ab 10             	bts    %edx,(%eax)
}
  1044b0:	90                   	nop
            list_add(&free_list, &(p->page_link));
  1044b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044b4:	83 c0 0c             	add    $0xc,%eax
  1044b7:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
  1044be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1044c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1044c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1044c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1044ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  1044cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044d0:	8b 40 04             	mov    0x4(%eax),%eax
  1044d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1044d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1044d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1044dc:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1044df:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  1044e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1044e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1044e8:	89 10                	mov    %edx,(%eax)
  1044ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1044ed:	8b 10                	mov    (%eax),%edx
  1044ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1044f2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1044f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1044f8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1044fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1044fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104501:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104504:	89 10                	mov    %edx,(%eax)
}
  104506:	90                   	nop
}
  104507:	90                   	nop
}
  104508:	90                   	nop
        }
        nr_free -= n;
  104509:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  10450e:	2b 45 08             	sub    0x8(%ebp),%eax
  104511:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104519:	83 c0 04             	add    $0x4,%eax
  10451c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104523:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104526:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104529:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10452c:	0f b3 10             	btr    %edx,(%eax)
}
  10452f:	90                   	nop
    }
    return page;
  104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104533:	c9                   	leave  
  104534:	c3                   	ret    

00104535 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104535:	f3 0f 1e fb          	endbr32 
  104539:	55                   	push   %ebp
  10453a:	89 e5                	mov    %esp,%ebp
  10453c:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104546:	75 24                	jne    10456c <default_free_pages+0x37>
  104548:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  10454f:	00 
  104550:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104557:	00 
  104558:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  10455f:	00 
  104560:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104567:	e8 ba be ff ff       	call   100426 <__panic>
    struct Page *p = base;
  10456c:	8b 45 08             	mov    0x8(%ebp),%eax
  10456f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104572:	e9 9d 00 00 00       	jmp    104614 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457a:	83 c0 04             	add    $0x4,%eax
  10457d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104584:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10458a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10458d:	0f a3 10             	bt     %edx,(%eax)
  104590:	19 c0                	sbb    %eax,%eax
  104592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104595:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104599:	0f 95 c0             	setne  %al
  10459c:	0f b6 c0             	movzbl %al,%eax
  10459f:	85 c0                	test   %eax,%eax
  1045a1:	75 2c                	jne    1045cf <default_free_pages+0x9a>
  1045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a6:	83 c0 04             	add    $0x4,%eax
  1045a9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1045b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1045b9:	0f a3 10             	bt     %edx,(%eax)
  1045bc:	19 c0                	sbb    %eax,%eax
  1045be:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1045c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1045c5:	0f 95 c0             	setne  %al
  1045c8:	0f b6 c0             	movzbl %al,%eax
  1045cb:	85 c0                	test   %eax,%eax
  1045cd:	74 24                	je     1045f3 <default_free_pages+0xbe>
  1045cf:	c7 44 24 0c fc 6c 10 	movl   $0x106cfc,0xc(%esp)
  1045d6:	00 
  1045d7:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1045de:	00 
  1045df:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  1045e6:	00 
  1045e7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1045ee:	e8 33 be ff ff       	call   100426 <__panic>
        p->flags = 0;
  1045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1045fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104604:	00 
  104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104608:	89 04 24             	mov    %eax,(%esp)
  10460b:	e8 e8 fb ff ff       	call   1041f8 <set_page_ref>
    for (; p != base + n; p ++) {
  104610:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104614:	8b 55 0c             	mov    0xc(%ebp),%edx
  104617:	89 d0                	mov    %edx,%eax
  104619:	c1 e0 02             	shl    $0x2,%eax
  10461c:	01 d0                	add    %edx,%eax
  10461e:	c1 e0 02             	shl    $0x2,%eax
  104621:	89 c2                	mov    %eax,%edx
  104623:	8b 45 08             	mov    0x8(%ebp),%eax
  104626:	01 d0                	add    %edx,%eax
  104628:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10462b:	0f 85 46 ff ff ff    	jne    104577 <default_free_pages+0x42>
    }
    base->property = n;
  104631:	8b 45 08             	mov    0x8(%ebp),%eax
  104634:	8b 55 0c             	mov    0xc(%ebp),%edx
  104637:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10463a:	8b 45 08             	mov    0x8(%ebp),%eax
  10463d:	83 c0 04             	add    $0x4,%eax
  104640:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104647:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10464a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10464d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104650:	0f ab 10             	bts    %edx,(%eax)
}
  104653:	90                   	nop
  104654:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
    return listelm->next;
  10465b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10465e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104661:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104664:	e9 0e 01 00 00       	jmp    104777 <default_free_pages+0x242>
        p = le2page(le, page_link);
  104669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10466c:	83 e8 0c             	sub    $0xc,%eax
  10466f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104675:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104678:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10467b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  10467e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104681:	8b 45 08             	mov    0x8(%ebp),%eax
  104684:	8b 50 08             	mov    0x8(%eax),%edx
  104687:	89 d0                	mov    %edx,%eax
  104689:	c1 e0 02             	shl    $0x2,%eax
  10468c:	01 d0                	add    %edx,%eax
  10468e:	c1 e0 02             	shl    $0x2,%eax
  104691:	89 c2                	mov    %eax,%edx
  104693:	8b 45 08             	mov    0x8(%ebp),%eax
  104696:	01 d0                	add    %edx,%eax
  104698:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10469b:	75 5d                	jne    1046fa <default_free_pages+0x1c5>
            base->property += p->property;
  10469d:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a0:	8b 50 08             	mov    0x8(%eax),%edx
  1046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a6:	8b 40 08             	mov    0x8(%eax),%eax
  1046a9:	01 c2                	add    %eax,%edx
  1046ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ae:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  1046b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b4:	83 c0 04             	add    $0x4,%eax
  1046b7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1046be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1046c4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1046c7:	0f b3 10             	btr    %edx,(%eax)
}
  1046ca:	90                   	nop
            list_del(&(p->page_link));
  1046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ce:	83 c0 0c             	add    $0xc,%eax
  1046d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  1046d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1046d7:	8b 40 04             	mov    0x4(%eax),%eax
  1046da:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1046dd:	8b 12                	mov    (%edx),%edx
  1046df:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1046e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  1046e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1046e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1046eb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046ee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1046f1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1046f4:	89 10                	mov    %edx,(%eax)
}
  1046f6:	90                   	nop
}
  1046f7:	90                   	nop
  1046f8:	eb 7d                	jmp    104777 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  1046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046fd:	8b 50 08             	mov    0x8(%eax),%edx
  104700:	89 d0                	mov    %edx,%eax
  104702:	c1 e0 02             	shl    $0x2,%eax
  104705:	01 d0                	add    %edx,%eax
  104707:	c1 e0 02             	shl    $0x2,%eax
  10470a:	89 c2                	mov    %eax,%edx
  10470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10470f:	01 d0                	add    %edx,%eax
  104711:	39 45 08             	cmp    %eax,0x8(%ebp)
  104714:	75 61                	jne    104777 <default_free_pages+0x242>
            p->property += base->property;
  104716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104719:	8b 50 08             	mov    0x8(%eax),%edx
  10471c:	8b 45 08             	mov    0x8(%ebp),%eax
  10471f:	8b 40 08             	mov    0x8(%eax),%eax
  104722:	01 c2                	add    %eax,%edx
  104724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104727:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  10472a:	8b 45 08             	mov    0x8(%ebp),%eax
  10472d:	83 c0 04             	add    $0x4,%eax
  104730:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104737:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10473a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10473d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104740:	0f b3 10             	btr    %edx,(%eax)
}
  104743:	90                   	nop
            base = p;
  104744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104747:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10474d:	83 c0 0c             	add    $0xc,%eax
  104750:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104753:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104756:	8b 40 04             	mov    0x4(%eax),%eax
  104759:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10475c:	8b 12                	mov    (%edx),%edx
  10475e:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104761:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104764:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104767:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10476a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10476d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104770:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104773:	89 10                	mov    %edx,(%eax)
}
  104775:	90                   	nop
}
  104776:	90                   	nop
    while (le != &free_list) {
  104777:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  10477e:	0f 85 e5 fe ff ff    	jne    104669 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  104784:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  10478a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10478d:	01 d0                	add    %edx,%eax
  10478f:	a3 24 cf 11 00       	mov    %eax,0x11cf24
  104794:	c7 45 9c 1c cf 11 00 	movl   $0x11cf1c,-0x64(%ebp)
    return listelm->next;
  10479b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10479e:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(&free_list);
  1047a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
  1047a4:	eb 34                	jmp    1047da <default_free_pages+0x2a5>
        p = le2page(le, page_link);
  1047a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047a9:	83 e8 0c             	sub    $0xc,%eax
  1047ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(base + base->property <= p){
  1047af:	8b 45 08             	mov    0x8(%ebp),%eax
  1047b2:	8b 50 08             	mov    0x8(%eax),%edx
  1047b5:	89 d0                	mov    %edx,%eax
  1047b7:	c1 e0 02             	shl    $0x2,%eax
  1047ba:	01 d0                	add    %edx,%eax
  1047bc:	c1 e0 02             	shl    $0x2,%eax
  1047bf:	89 c2                	mov    %eax,%edx
  1047c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c4:	01 d0                	add    %edx,%eax
  1047c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1047c9:	73 1a                	jae    1047e5 <default_free_pages+0x2b0>
  1047cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047ce:	89 45 98             	mov    %eax,-0x68(%ebp)
  1047d1:	8b 45 98             	mov    -0x68(%ebp),%eax
  1047d4:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  1047d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
  1047da:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1047e1:	75 c3                	jne    1047a6 <default_free_pages+0x271>
  1047e3:	eb 01                	jmp    1047e6 <default_free_pages+0x2b1>
            break;
  1047e5:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  1047e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e9:	8d 50 0c             	lea    0xc(%eax),%edx
  1047ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047ef:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1047f2:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1047f5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1047f8:	8b 00                	mov    (%eax),%eax
  1047fa:	8b 55 90             	mov    -0x70(%ebp),%edx
  1047fd:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104800:	89 45 88             	mov    %eax,-0x78(%ebp)
  104803:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104806:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104809:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10480c:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10480f:	89 10                	mov    %edx,(%eax)
  104811:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104814:	8b 10                	mov    (%eax),%edx
  104816:	8b 45 88             	mov    -0x78(%ebp),%eax
  104819:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10481c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10481f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104822:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104825:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104828:	8b 55 88             	mov    -0x78(%ebp),%edx
  10482b:	89 10                	mov    %edx,(%eax)
}
  10482d:	90                   	nop
}
  10482e:	90                   	nop
}
  10482f:	90                   	nop
  104830:	c9                   	leave  
  104831:	c3                   	ret    

00104832 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104832:	f3 0f 1e fb          	endbr32 
  104836:	55                   	push   %ebp
  104837:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104839:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  10483e:	5d                   	pop    %ebp
  10483f:	c3                   	ret    

00104840 <basic_check>:

static void
basic_check(void) {
  104840:	f3 0f 1e fb          	endbr32 
  104844:	55                   	push   %ebp
  104845:	89 e5                	mov    %esp,%ebp
  104847:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10484a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104854:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10485a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10485d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104864:	e8 19 e4 ff ff       	call   102c82 <alloc_pages>
  104869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10486c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104870:	75 24                	jne    104896 <basic_check+0x56>
  104872:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  104879:	00 
  10487a:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104881:	00 
  104882:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  104889:	00 
  10488a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104891:	e8 90 bb ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104896:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10489d:	e8 e0 e3 ff ff       	call   102c82 <alloc_pages>
  1048a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048a9:	75 24                	jne    1048cf <basic_check+0x8f>
  1048ab:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  1048b2:	00 
  1048b3:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1048ba:	00 
  1048bb:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1048c2:	00 
  1048c3:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1048ca:	e8 57 bb ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048d6:	e8 a7 e3 ff ff       	call   102c82 <alloc_pages>
  1048db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048e2:	75 24                	jne    104908 <basic_check+0xc8>
  1048e4:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  1048eb:	00 
  1048ec:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1048f3:	00 
  1048f4:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1048fb:	00 
  1048fc:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104903:	e8 1e bb ff ff       	call   100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10490b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10490e:	74 10                	je     104920 <basic_check+0xe0>
  104910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104913:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104916:	74 08                	je     104920 <basic_check+0xe0>
  104918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10491b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10491e:	75 24                	jne    104944 <basic_check+0x104>
  104920:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  104927:	00 
  104928:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10492f:	00 
  104930:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104937:	00 
  104938:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10493f:	e8 e2 ba ff ff       	call   100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104947:	89 04 24             	mov    %eax,(%esp)
  10494a:	e8 9f f8 ff ff       	call   1041ee <page_ref>
  10494f:	85 c0                	test   %eax,%eax
  104951:	75 1e                	jne    104971 <basic_check+0x131>
  104953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104956:	89 04 24             	mov    %eax,(%esp)
  104959:	e8 90 f8 ff ff       	call   1041ee <page_ref>
  10495e:	85 c0                	test   %eax,%eax
  104960:	75 0f                	jne    104971 <basic_check+0x131>
  104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104965:	89 04 24             	mov    %eax,(%esp)
  104968:	e8 81 f8 ff ff       	call   1041ee <page_ref>
  10496d:	85 c0                	test   %eax,%eax
  10496f:	74 24                	je     104995 <basic_check+0x155>
  104971:	c7 44 24 0c 9c 6d 10 	movl   $0x106d9c,0xc(%esp)
  104978:	00 
  104979:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104980:	00 
  104981:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104988:	00 
  104989:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104990:	e8 91 ba ff ff       	call   100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104998:	89 04 24             	mov    %eax,(%esp)
  10499b:	e8 38 f8 ff ff       	call   1041d8 <page2pa>
  1049a0:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  1049a6:	c1 e2 0c             	shl    $0xc,%edx
  1049a9:	39 d0                	cmp    %edx,%eax
  1049ab:	72 24                	jb     1049d1 <basic_check+0x191>
  1049ad:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  1049b4:	00 
  1049b5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1049bc:	00 
  1049bd:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  1049c4:	00 
  1049c5:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1049cc:	e8 55 ba ff ff       	call   100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1049d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049d4:	89 04 24             	mov    %eax,(%esp)
  1049d7:	e8 fc f7 ff ff       	call   1041d8 <page2pa>
  1049dc:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  1049e2:	c1 e2 0c             	shl    $0xc,%edx
  1049e5:	39 d0                	cmp    %edx,%eax
  1049e7:	72 24                	jb     104a0d <basic_check+0x1cd>
  1049e9:	c7 44 24 0c f5 6d 10 	movl   $0x106df5,0xc(%esp)
  1049f0:	00 
  1049f1:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1049f8:	00 
  1049f9:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104a00:	00 
  104a01:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a08:	e8 19 ba ff ff       	call   100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a10:	89 04 24             	mov    %eax,(%esp)
  104a13:	e8 c0 f7 ff ff       	call   1041d8 <page2pa>
  104a18:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104a1e:	c1 e2 0c             	shl    $0xc,%edx
  104a21:	39 d0                	cmp    %edx,%eax
  104a23:	72 24                	jb     104a49 <basic_check+0x209>
  104a25:	c7 44 24 0c 12 6e 10 	movl   $0x106e12,0xc(%esp)
  104a2c:	00 
  104a2d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a34:	00 
  104a35:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104a3c:	00 
  104a3d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a44:	e8 dd b9 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  104a49:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104a4e:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104a57:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a5a:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104a67:	89 50 04             	mov    %edx,0x4(%eax)
  104a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a6d:	8b 50 04             	mov    0x4(%eax),%edx
  104a70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a73:	89 10                	mov    %edx,(%eax)
}
  104a75:	90                   	nop
  104a76:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a80:	8b 40 04             	mov    0x4(%eax),%eax
  104a83:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104a86:	0f 94 c0             	sete   %al
  104a89:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104a8c:	85 c0                	test   %eax,%eax
  104a8e:	75 24                	jne    104ab4 <basic_check+0x274>
  104a90:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104a97:	00 
  104a98:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a9f:	00 
  104aa0:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  104aa7:	00 
  104aa8:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104aaf:	e8 72 b9 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  104ab4:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104ab9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104abc:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104ac3:	00 00 00 

    assert(alloc_page() == NULL);
  104ac6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104acd:	e8 b0 e1 ff ff       	call   102c82 <alloc_pages>
  104ad2:	85 c0                	test   %eax,%eax
  104ad4:	74 24                	je     104afa <basic_check+0x2ba>
  104ad6:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104add:	00 
  104ade:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ae5:	00 
  104ae6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  104aed:	00 
  104aee:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104af5:	e8 2c b9 ff ff       	call   100426 <__panic>

    free_page(p0);
  104afa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b01:	00 
  104b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b05:	89 04 24             	mov    %eax,(%esp)
  104b08:	e8 b1 e1 ff ff       	call   102cbe <free_pages>
    free_page(p1);
  104b0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b14:	00 
  104b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b18:	89 04 24             	mov    %eax,(%esp)
  104b1b:	e8 9e e1 ff ff       	call   102cbe <free_pages>
    free_page(p2);
  104b20:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b27:	00 
  104b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b2b:	89 04 24             	mov    %eax,(%esp)
  104b2e:	e8 8b e1 ff ff       	call   102cbe <free_pages>
    assert(nr_free == 3);
  104b33:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104b38:	83 f8 03             	cmp    $0x3,%eax
  104b3b:	74 24                	je     104b61 <basic_check+0x321>
  104b3d:	c7 44 24 0c 5b 6e 10 	movl   $0x106e5b,0xc(%esp)
  104b44:	00 
  104b45:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b4c:	00 
  104b4d:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  104b54:	00 
  104b55:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b5c:	e8 c5 b8 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104b61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b68:	e8 15 e1 ff ff       	call   102c82 <alloc_pages>
  104b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b74:	75 24                	jne    104b9a <basic_check+0x35a>
  104b76:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  104b7d:	00 
  104b7e:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b85:	00 
  104b86:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  104b8d:	00 
  104b8e:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b95:	e8 8c b8 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104b9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ba1:	e8 dc e0 ff ff       	call   102c82 <alloc_pages>
  104ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104bad:	75 24                	jne    104bd3 <basic_check+0x393>
  104baf:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  104bb6:	00 
  104bb7:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104bbe:	00 
  104bbf:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104bc6:	00 
  104bc7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104bce:	e8 53 b8 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104bd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bda:	e8 a3 e0 ff ff       	call   102c82 <alloc_pages>
  104bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104be6:	75 24                	jne    104c0c <basic_check+0x3cc>
  104be8:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  104bef:	00 
  104bf0:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104bf7:	00 
  104bf8:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104bff:	00 
  104c00:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c07:	e8 1a b8 ff ff       	call   100426 <__panic>

    assert(alloc_page() == NULL);
  104c0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c13:	e8 6a e0 ff ff       	call   102c82 <alloc_pages>
  104c18:	85 c0                	test   %eax,%eax
  104c1a:	74 24                	je     104c40 <basic_check+0x400>
  104c1c:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104c23:	00 
  104c24:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c2b:	00 
  104c2c:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104c33:	00 
  104c34:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c3b:	e8 e6 b7 ff ff       	call   100426 <__panic>

    free_page(p0);
  104c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c47:	00 
  104c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c4b:	89 04 24             	mov    %eax,(%esp)
  104c4e:	e8 6b e0 ff ff       	call   102cbe <free_pages>
  104c53:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104c5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c5d:	8b 40 04             	mov    0x4(%eax),%eax
  104c60:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104c63:	0f 94 c0             	sete   %al
  104c66:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104c69:	85 c0                	test   %eax,%eax
  104c6b:	74 24                	je     104c91 <basic_check+0x451>
  104c6d:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104c74:	00 
  104c75:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c7c:	00 
  104c7d:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  104c84:	00 
  104c85:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c8c:	e8 95 b7 ff ff       	call   100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104c91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c98:	e8 e5 df ff ff       	call   102c82 <alloc_pages>
  104c9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ca3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104ca6:	74 24                	je     104ccc <basic_check+0x48c>
  104ca8:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104caf:	00 
  104cb0:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104cb7:	00 
  104cb8:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  104cbf:	00 
  104cc0:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104cc7:	e8 5a b7 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  104ccc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cd3:	e8 aa df ff ff       	call   102c82 <alloc_pages>
  104cd8:	85 c0                	test   %eax,%eax
  104cda:	74 24                	je     104d00 <basic_check+0x4c0>
  104cdc:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104ce3:	00 
  104ce4:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ceb:	00 
  104cec:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104cf3:	00 
  104cf4:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104cfb:	e8 26 b7 ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  104d00:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104d05:	85 c0                	test   %eax,%eax
  104d07:	74 24                	je     104d2d <basic_check+0x4ed>
  104d09:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104d10:	00 
  104d11:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104d18:	00 
  104d19:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  104d20:	00 
  104d21:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104d28:	e8 f9 b6 ff ff       	call   100426 <__panic>
    free_list = free_list_store;
  104d2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104d33:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104d38:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d41:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104d46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d4d:	00 
  104d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d51:	89 04 24             	mov    %eax,(%esp)
  104d54:	e8 65 df ff ff       	call   102cbe <free_pages>
    free_page(p1);
  104d59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d60:	00 
  104d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d64:	89 04 24             	mov    %eax,(%esp)
  104d67:	e8 52 df ff ff       	call   102cbe <free_pages>
    free_page(p2);
  104d6c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d73:	00 
  104d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d77:	89 04 24             	mov    %eax,(%esp)
  104d7a:	e8 3f df ff ff       	call   102cbe <free_pages>
}
  104d7f:	90                   	nop
  104d80:	c9                   	leave  
  104d81:	c3                   	ret    

00104d82 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104d82:	f3 0f 1e fb          	endbr32 
  104d86:	55                   	push   %ebp
  104d87:	89 e5                	mov    %esp,%ebp
  104d89:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104d9d:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104da4:	eb 6a                	jmp    104e10 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  104da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104da9:	83 e8 0c             	sub    $0xc,%eax
  104dac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104daf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104db2:	83 c0 04             	add    $0x4,%eax
  104db5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104dbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104dbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104dc2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104dc5:	0f a3 10             	bt     %edx,(%eax)
  104dc8:	19 c0                	sbb    %eax,%eax
  104dca:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104dcd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104dd1:	0f 95 c0             	setne  %al
  104dd4:	0f b6 c0             	movzbl %al,%eax
  104dd7:	85 c0                	test   %eax,%eax
  104dd9:	75 24                	jne    104dff <default_check+0x7d>
  104ddb:	c7 44 24 0c a6 6e 10 	movl   $0x106ea6,0xc(%esp)
  104de2:	00 
  104de3:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104dea:	00 
  104deb:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104df2:	00 
  104df3:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104dfa:	e8 27 b6 ff ff       	call   100426 <__panic>
        count ++, total += p->property;
  104dff:	ff 45 f4             	incl   -0xc(%ebp)
  104e02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e05:	8b 50 08             	mov    0x8(%eax),%edx
  104e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e0b:	01 d0                	add    %edx,%eax
  104e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e13:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104e16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e19:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104e1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e1f:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  104e26:	0f 85 7a ff ff ff    	jne    104da6 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  104e2c:	e8 c4 de ff ff       	call   102cf5 <nr_free_pages>
  104e31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104e34:	39 d0                	cmp    %edx,%eax
  104e36:	74 24                	je     104e5c <default_check+0xda>
  104e38:	c7 44 24 0c b6 6e 10 	movl   $0x106eb6,0xc(%esp)
  104e3f:	00 
  104e40:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e47:	00 
  104e48:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  104e4f:	00 
  104e50:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e57:	e8 ca b5 ff ff       	call   100426 <__panic>

    basic_check();
  104e5c:	e8 df f9 ff ff       	call   104840 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104e61:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104e68:	e8 15 de ff ff       	call   102c82 <alloc_pages>
  104e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  104e70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e74:	75 24                	jne    104e9a <default_check+0x118>
  104e76:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  104e7d:	00 
  104e7e:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e85:	00 
  104e86:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  104e8d:	00 
  104e8e:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e95:	e8 8c b5 ff ff       	call   100426 <__panic>
    assert(!PageProperty(p0));
  104e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e9d:	83 c0 04             	add    $0x4,%eax
  104ea0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104ea7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104eaa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104ead:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104eb0:	0f a3 10             	bt     %edx,(%eax)
  104eb3:	19 c0                	sbb    %eax,%eax
  104eb5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104eb8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104ebc:	0f 95 c0             	setne  %al
  104ebf:	0f b6 c0             	movzbl %al,%eax
  104ec2:	85 c0                	test   %eax,%eax
  104ec4:	74 24                	je     104eea <default_check+0x168>
  104ec6:	c7 44 24 0c da 6e 10 	movl   $0x106eda,0xc(%esp)
  104ecd:	00 
  104ece:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ed5:	00 
  104ed6:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  104edd:	00 
  104ede:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104ee5:	e8 3c b5 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  104eea:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104eef:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104ef5:	89 45 80             	mov    %eax,-0x80(%ebp)
  104ef8:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104efb:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104f02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f05:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104f08:	89 50 04             	mov    %edx,0x4(%eax)
  104f0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f0e:	8b 50 04             	mov    0x4(%eax),%edx
  104f11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f14:	89 10                	mov    %edx,(%eax)
}
  104f16:	90                   	nop
  104f17:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  104f1e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f21:	8b 40 04             	mov    0x4(%eax),%eax
  104f24:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104f27:	0f 94 c0             	sete   %al
  104f2a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104f2d:	85 c0                	test   %eax,%eax
  104f2f:	75 24                	jne    104f55 <default_check+0x1d3>
  104f31:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104f38:	00 
  104f39:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f40:	00 
  104f41:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  104f48:	00 
  104f49:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f50:	e8 d1 b4 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  104f55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f5c:	e8 21 dd ff ff       	call   102c82 <alloc_pages>
  104f61:	85 c0                	test   %eax,%eax
  104f63:	74 24                	je     104f89 <default_check+0x207>
  104f65:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104f6c:	00 
  104f6d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f74:	00 
  104f75:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104f7c:	00 
  104f7d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f84:	e8 9d b4 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  104f89:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104f8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  104f91:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104f98:	00 00 00 

    free_pages(p0 + 2, 3);
  104f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f9e:	83 c0 28             	add    $0x28,%eax
  104fa1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104fa8:	00 
  104fa9:	89 04 24             	mov    %eax,(%esp)
  104fac:	e8 0d dd ff ff       	call   102cbe <free_pages>
    assert(alloc_pages(4) == NULL);
  104fb1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104fb8:	e8 c5 dc ff ff       	call   102c82 <alloc_pages>
  104fbd:	85 c0                	test   %eax,%eax
  104fbf:	74 24                	je     104fe5 <default_check+0x263>
  104fc1:	c7 44 24 0c ec 6e 10 	movl   $0x106eec,0xc(%esp)
  104fc8:	00 
  104fc9:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104fd0:	00 
  104fd1:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  104fd8:	00 
  104fd9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104fe0:	e8 41 b4 ff ff       	call   100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fe8:	83 c0 28             	add    $0x28,%eax
  104feb:	83 c0 04             	add    $0x4,%eax
  104fee:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104ff5:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ff8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104ffb:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104ffe:	0f a3 10             	bt     %edx,(%eax)
  105001:	19 c0                	sbb    %eax,%eax
  105003:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105006:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10500a:	0f 95 c0             	setne  %al
  10500d:	0f b6 c0             	movzbl %al,%eax
  105010:	85 c0                	test   %eax,%eax
  105012:	74 0e                	je     105022 <default_check+0x2a0>
  105014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105017:	83 c0 28             	add    $0x28,%eax
  10501a:	8b 40 08             	mov    0x8(%eax),%eax
  10501d:	83 f8 03             	cmp    $0x3,%eax
  105020:	74 24                	je     105046 <default_check+0x2c4>
  105022:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  105029:	00 
  10502a:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105031:	00 
  105032:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105039:	00 
  10503a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105041:	e8 e0 b3 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105046:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10504d:	e8 30 dc ff ff       	call   102c82 <alloc_pages>
  105052:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105055:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105059:	75 24                	jne    10507f <default_check+0x2fd>
  10505b:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  105062:	00 
  105063:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10506a:	00 
  10506b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  105072:	00 
  105073:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10507a:	e8 a7 b3 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  10507f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105086:	e8 f7 db ff ff       	call   102c82 <alloc_pages>
  10508b:	85 c0                	test   %eax,%eax
  10508d:	74 24                	je     1050b3 <default_check+0x331>
  10508f:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  105096:	00 
  105097:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10509e:	00 
  10509f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1050a6:	00 
  1050a7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1050ae:	e8 73 b3 ff ff       	call   100426 <__panic>
    assert(p0 + 2 == p1);
  1050b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050b6:	83 c0 28             	add    $0x28,%eax
  1050b9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1050bc:	74 24                	je     1050e2 <default_check+0x360>
  1050be:	c7 44 24 0c 4e 6f 10 	movl   $0x106f4e,0xc(%esp)
  1050c5:	00 
  1050c6:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1050cd:	00 
  1050ce:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1050d5:	00 
  1050d6:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1050dd:	e8 44 b3 ff ff       	call   100426 <__panic>

    p2 = p0 + 1;
  1050e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050e5:	83 c0 14             	add    $0x14,%eax
  1050e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1050eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050f2:	00 
  1050f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050f6:	89 04 24             	mov    %eax,(%esp)
  1050f9:	e8 c0 db ff ff       	call   102cbe <free_pages>
    free_pages(p1, 3);
  1050fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105105:	00 
  105106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105109:	89 04 24             	mov    %eax,(%esp)
  10510c:	e8 ad db ff ff       	call   102cbe <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105114:	83 c0 04             	add    $0x4,%eax
  105117:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10511e:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105121:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105124:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105127:	0f a3 10             	bt     %edx,(%eax)
  10512a:	19 c0                	sbb    %eax,%eax
  10512c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10512f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105133:	0f 95 c0             	setne  %al
  105136:	0f b6 c0             	movzbl %al,%eax
  105139:	85 c0                	test   %eax,%eax
  10513b:	74 0b                	je     105148 <default_check+0x3c6>
  10513d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105140:	8b 40 08             	mov    0x8(%eax),%eax
  105143:	83 f8 01             	cmp    $0x1,%eax
  105146:	74 24                	je     10516c <default_check+0x3ea>
  105148:	c7 44 24 0c 5c 6f 10 	movl   $0x106f5c,0xc(%esp)
  10514f:	00 
  105150:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105157:	00 
  105158:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  10515f:	00 
  105160:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105167:	e8 ba b2 ff ff       	call   100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10516c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10516f:	83 c0 04             	add    $0x4,%eax
  105172:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105179:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10517c:	8b 45 90             	mov    -0x70(%ebp),%eax
  10517f:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105182:	0f a3 10             	bt     %edx,(%eax)
  105185:	19 c0                	sbb    %eax,%eax
  105187:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10518a:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10518e:	0f 95 c0             	setne  %al
  105191:	0f b6 c0             	movzbl %al,%eax
  105194:	85 c0                	test   %eax,%eax
  105196:	74 0b                	je     1051a3 <default_check+0x421>
  105198:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10519b:	8b 40 08             	mov    0x8(%eax),%eax
  10519e:	83 f8 03             	cmp    $0x3,%eax
  1051a1:	74 24                	je     1051c7 <default_check+0x445>
  1051a3:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  1051aa:	00 
  1051ab:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1051b2:	00 
  1051b3:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1051ba:	00 
  1051bb:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1051c2:	e8 5f b2 ff ff       	call   100426 <__panic>
    
    assert((p0 = alloc_page()) == p2 - 1);
  1051c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051ce:	e8 af da ff ff       	call   102c82 <alloc_pages>
  1051d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1051d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051d9:	83 e8 14             	sub    $0x14,%eax
  1051dc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1051df:	74 24                	je     105205 <default_check+0x483>
  1051e1:	c7 44 24 0c aa 6f 10 	movl   $0x106faa,0xc(%esp)
  1051e8:	00 
  1051e9:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1051f0:	00 
  1051f1:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  1051f8:	00 
  1051f9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105200:	e8 21 b2 ff ff       	call   100426 <__panic>
    free_page(p0);
  105205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10520c:	00 
  10520d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105210:	89 04 24             	mov    %eax,(%esp)
  105213:	e8 a6 da ff ff       	call   102cbe <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105218:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10521f:	e8 5e da ff ff       	call   102c82 <alloc_pages>
  105224:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10522a:	83 c0 14             	add    $0x14,%eax
  10522d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105230:	74 24                	je     105256 <default_check+0x4d4>
  105232:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  105239:	00 
  10523a:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105241:	00 
  105242:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  105249:	00 
  10524a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105251:	e8 d0 b1 ff ff       	call   100426 <__panic>

    free_pages(p0, 2);
  105256:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10525d:	00 
  10525e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105261:	89 04 24             	mov    %eax,(%esp)
  105264:	e8 55 da ff ff       	call   102cbe <free_pages>
    free_page(p2);
  105269:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105270:	00 
  105271:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105274:	89 04 24             	mov    %eax,(%esp)
  105277:	e8 42 da ff ff       	call   102cbe <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10527c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105283:	e8 fa d9 ff ff       	call   102c82 <alloc_pages>
  105288:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10528b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10528f:	75 24                	jne    1052b5 <default_check+0x533>
  105291:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  105298:	00 
  105299:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052a0:	00 
  1052a1:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  1052a8:	00 
  1052a9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052b0:	e8 71 b1 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  1052b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052bc:	e8 c1 d9 ff ff       	call   102c82 <alloc_pages>
  1052c1:	85 c0                	test   %eax,%eax
  1052c3:	74 24                	je     1052e9 <default_check+0x567>
  1052c5:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  1052cc:	00 
  1052cd:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052d4:	00 
  1052d5:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  1052dc:	00 
  1052dd:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052e4:	e8 3d b1 ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  1052e9:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1052ee:	85 c0                	test   %eax,%eax
  1052f0:	74 24                	je     105316 <default_check+0x594>
  1052f2:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  1052f9:	00 
  1052fa:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105301:	00 
  105302:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  105309:	00 
  10530a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105311:	e8 10 b1 ff ff       	call   100426 <__panic>
    nr_free = nr_free_store;
  105316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105319:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  10531e:	8b 45 80             	mov    -0x80(%ebp),%eax
  105321:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105324:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  105329:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  10532f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105336:	00 
  105337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10533a:	89 04 24             	mov    %eax,(%esp)
  10533d:	e8 7c d9 ff ff       	call   102cbe <free_pages>

    le = &free_list;
  105342:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105349:	eb 1c                	jmp    105367 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  10534b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10534e:	83 e8 0c             	sub    $0xc,%eax
  105351:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  105354:	ff 4d f4             	decl   -0xc(%ebp)
  105357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10535a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10535d:	8b 40 08             	mov    0x8(%eax),%eax
  105360:	29 c2                	sub    %eax,%edx
  105362:	89 d0                	mov    %edx,%eax
  105364:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10536a:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10536d:	8b 45 88             	mov    -0x78(%ebp),%eax
  105370:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105373:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105376:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  10537d:	75 cc                	jne    10534b <default_check+0x5c9>
    }
    assert(count == 0);
  10537f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105383:	74 24                	je     1053a9 <default_check+0x627>
  105385:	c7 44 24 0c 06 70 10 	movl   $0x107006,0xc(%esp)
  10538c:	00 
  10538d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105394:	00 
  105395:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  10539c:	00 
  10539d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1053a4:	e8 7d b0 ff ff       	call   100426 <__panic>
    assert(total == 0);
  1053a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053ad:	74 24                	je     1053d3 <default_check+0x651>
  1053af:	c7 44 24 0c 11 70 10 	movl   $0x107011,0xc(%esp)
  1053b6:	00 
  1053b7:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1053be:	00 
  1053bf:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1053c6:	00 
  1053c7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1053ce:	e8 53 b0 ff ff       	call   100426 <__panic>
}
  1053d3:	90                   	nop
  1053d4:	c9                   	leave  
  1053d5:	c3                   	ret    

001053d6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1053d6:	f3 0f 1e fb          	endbr32 
  1053da:	55                   	push   %ebp
  1053db:	89 e5                	mov    %esp,%ebp
  1053dd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1053e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1053e7:	eb 03                	jmp    1053ec <strlen+0x16>
        cnt ++;
  1053e9:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1053ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ef:	8d 50 01             	lea    0x1(%eax),%edx
  1053f2:	89 55 08             	mov    %edx,0x8(%ebp)
  1053f5:	0f b6 00             	movzbl (%eax),%eax
  1053f8:	84 c0                	test   %al,%al
  1053fa:	75 ed                	jne    1053e9 <strlen+0x13>
    }
    return cnt;
  1053fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1053ff:	c9                   	leave  
  105400:	c3                   	ret    

00105401 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105401:	f3 0f 1e fb          	endbr32 
  105405:	55                   	push   %ebp
  105406:	89 e5                	mov    %esp,%ebp
  105408:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10540b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105412:	eb 03                	jmp    105417 <strnlen+0x16>
        cnt ++;
  105414:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105417:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10541a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10541d:	73 10                	jae    10542f <strnlen+0x2e>
  10541f:	8b 45 08             	mov    0x8(%ebp),%eax
  105422:	8d 50 01             	lea    0x1(%eax),%edx
  105425:	89 55 08             	mov    %edx,0x8(%ebp)
  105428:	0f b6 00             	movzbl (%eax),%eax
  10542b:	84 c0                	test   %al,%al
  10542d:	75 e5                	jne    105414 <strnlen+0x13>
    }
    return cnt;
  10542f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105432:	c9                   	leave  
  105433:	c3                   	ret    

00105434 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105434:	f3 0f 1e fb          	endbr32 
  105438:	55                   	push   %ebp
  105439:	89 e5                	mov    %esp,%ebp
  10543b:	57                   	push   %edi
  10543c:	56                   	push   %esi
  10543d:	83 ec 20             	sub    $0x20,%esp
  105440:	8b 45 08             	mov    0x8(%ebp),%eax
  105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105446:	8b 45 0c             	mov    0xc(%ebp),%eax
  105449:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10544c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105452:	89 d1                	mov    %edx,%ecx
  105454:	89 c2                	mov    %eax,%edx
  105456:	89 ce                	mov    %ecx,%esi
  105458:	89 d7                	mov    %edx,%edi
  10545a:	ac                   	lods   %ds:(%esi),%al
  10545b:	aa                   	stos   %al,%es:(%edi)
  10545c:	84 c0                	test   %al,%al
  10545e:	75 fa                	jne    10545a <strcpy+0x26>
  105460:	89 fa                	mov    %edi,%edx
  105462:	89 f1                	mov    %esi,%ecx
  105464:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105467:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10546a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10546d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105470:	83 c4 20             	add    $0x20,%esp
  105473:	5e                   	pop    %esi
  105474:	5f                   	pop    %edi
  105475:	5d                   	pop    %ebp
  105476:	c3                   	ret    

00105477 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105477:	f3 0f 1e fb          	endbr32 
  10547b:	55                   	push   %ebp
  10547c:	89 e5                	mov    %esp,%ebp
  10547e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105481:	8b 45 08             	mov    0x8(%ebp),%eax
  105484:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105487:	eb 1e                	jmp    1054a7 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  105489:	8b 45 0c             	mov    0xc(%ebp),%eax
  10548c:	0f b6 10             	movzbl (%eax),%edx
  10548f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105492:	88 10                	mov    %dl,(%eax)
  105494:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105497:	0f b6 00             	movzbl (%eax),%eax
  10549a:	84 c0                	test   %al,%al
  10549c:	74 03                	je     1054a1 <strncpy+0x2a>
            src ++;
  10549e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1054a1:	ff 45 fc             	incl   -0x4(%ebp)
  1054a4:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1054a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054ab:	75 dc                	jne    105489 <strncpy+0x12>
    }
    return dst;
  1054ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1054b0:	c9                   	leave  
  1054b1:	c3                   	ret    

001054b2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1054b2:	f3 0f 1e fb          	endbr32 
  1054b6:	55                   	push   %ebp
  1054b7:	89 e5                	mov    %esp,%ebp
  1054b9:	57                   	push   %edi
  1054ba:	56                   	push   %esi
  1054bb:	83 ec 20             	sub    $0x20,%esp
  1054be:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1054ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054d0:	89 d1                	mov    %edx,%ecx
  1054d2:	89 c2                	mov    %eax,%edx
  1054d4:	89 ce                	mov    %ecx,%esi
  1054d6:	89 d7                	mov    %edx,%edi
  1054d8:	ac                   	lods   %ds:(%esi),%al
  1054d9:	ae                   	scas   %es:(%edi),%al
  1054da:	75 08                	jne    1054e4 <strcmp+0x32>
  1054dc:	84 c0                	test   %al,%al
  1054de:	75 f8                	jne    1054d8 <strcmp+0x26>
  1054e0:	31 c0                	xor    %eax,%eax
  1054e2:	eb 04                	jmp    1054e8 <strcmp+0x36>
  1054e4:	19 c0                	sbb    %eax,%eax
  1054e6:	0c 01                	or     $0x1,%al
  1054e8:	89 fa                	mov    %edi,%edx
  1054ea:	89 f1                	mov    %esi,%ecx
  1054ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1054ef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1054f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1054f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1054f8:	83 c4 20             	add    $0x20,%esp
  1054fb:	5e                   	pop    %esi
  1054fc:	5f                   	pop    %edi
  1054fd:	5d                   	pop    %ebp
  1054fe:	c3                   	ret    

001054ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1054ff:	f3 0f 1e fb          	endbr32 
  105503:	55                   	push   %ebp
  105504:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105506:	eb 09                	jmp    105511 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  105508:	ff 4d 10             	decl   0x10(%ebp)
  10550b:	ff 45 08             	incl   0x8(%ebp)
  10550e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105511:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105515:	74 1a                	je     105531 <strncmp+0x32>
  105517:	8b 45 08             	mov    0x8(%ebp),%eax
  10551a:	0f b6 00             	movzbl (%eax),%eax
  10551d:	84 c0                	test   %al,%al
  10551f:	74 10                	je     105531 <strncmp+0x32>
  105521:	8b 45 08             	mov    0x8(%ebp),%eax
  105524:	0f b6 10             	movzbl (%eax),%edx
  105527:	8b 45 0c             	mov    0xc(%ebp),%eax
  10552a:	0f b6 00             	movzbl (%eax),%eax
  10552d:	38 c2                	cmp    %al,%dl
  10552f:	74 d7                	je     105508 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105531:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105535:	74 18                	je     10554f <strncmp+0x50>
  105537:	8b 45 08             	mov    0x8(%ebp),%eax
  10553a:	0f b6 00             	movzbl (%eax),%eax
  10553d:	0f b6 d0             	movzbl %al,%edx
  105540:	8b 45 0c             	mov    0xc(%ebp),%eax
  105543:	0f b6 00             	movzbl (%eax),%eax
  105546:	0f b6 c0             	movzbl %al,%eax
  105549:	29 c2                	sub    %eax,%edx
  10554b:	89 d0                	mov    %edx,%eax
  10554d:	eb 05                	jmp    105554 <strncmp+0x55>
  10554f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105554:	5d                   	pop    %ebp
  105555:	c3                   	ret    

00105556 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105556:	f3 0f 1e fb          	endbr32 
  10555a:	55                   	push   %ebp
  10555b:	89 e5                	mov    %esp,%ebp
  10555d:	83 ec 04             	sub    $0x4,%esp
  105560:	8b 45 0c             	mov    0xc(%ebp),%eax
  105563:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105566:	eb 13                	jmp    10557b <strchr+0x25>
        if (*s == c) {
  105568:	8b 45 08             	mov    0x8(%ebp),%eax
  10556b:	0f b6 00             	movzbl (%eax),%eax
  10556e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105571:	75 05                	jne    105578 <strchr+0x22>
            return (char *)s;
  105573:	8b 45 08             	mov    0x8(%ebp),%eax
  105576:	eb 12                	jmp    10558a <strchr+0x34>
        }
        s ++;
  105578:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10557b:	8b 45 08             	mov    0x8(%ebp),%eax
  10557e:	0f b6 00             	movzbl (%eax),%eax
  105581:	84 c0                	test   %al,%al
  105583:	75 e3                	jne    105568 <strchr+0x12>
    }
    return NULL;
  105585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10558a:	c9                   	leave  
  10558b:	c3                   	ret    

0010558c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10558c:	f3 0f 1e fb          	endbr32 
  105590:	55                   	push   %ebp
  105591:	89 e5                	mov    %esp,%ebp
  105593:	83 ec 04             	sub    $0x4,%esp
  105596:	8b 45 0c             	mov    0xc(%ebp),%eax
  105599:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10559c:	eb 0e                	jmp    1055ac <strfind+0x20>
        if (*s == c) {
  10559e:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a1:	0f b6 00             	movzbl (%eax),%eax
  1055a4:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1055a7:	74 0f                	je     1055b8 <strfind+0x2c>
            break;
        }
        s ++;
  1055a9:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1055ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1055af:	0f b6 00             	movzbl (%eax),%eax
  1055b2:	84 c0                	test   %al,%al
  1055b4:	75 e8                	jne    10559e <strfind+0x12>
  1055b6:	eb 01                	jmp    1055b9 <strfind+0x2d>
            break;
  1055b8:	90                   	nop
    }
    return (char *)s;
  1055b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1055bc:	c9                   	leave  
  1055bd:	c3                   	ret    

001055be <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1055be:	f3 0f 1e fb          	endbr32 
  1055c2:	55                   	push   %ebp
  1055c3:	89 e5                	mov    %esp,%ebp
  1055c5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1055c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1055cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1055d6:	eb 03                	jmp    1055db <strtol+0x1d>
        s ++;
  1055d8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1055db:	8b 45 08             	mov    0x8(%ebp),%eax
  1055de:	0f b6 00             	movzbl (%eax),%eax
  1055e1:	3c 20                	cmp    $0x20,%al
  1055e3:	74 f3                	je     1055d8 <strtol+0x1a>
  1055e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e8:	0f b6 00             	movzbl (%eax),%eax
  1055eb:	3c 09                	cmp    $0x9,%al
  1055ed:	74 e9                	je     1055d8 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1055ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f2:	0f b6 00             	movzbl (%eax),%eax
  1055f5:	3c 2b                	cmp    $0x2b,%al
  1055f7:	75 05                	jne    1055fe <strtol+0x40>
        s ++;
  1055f9:	ff 45 08             	incl   0x8(%ebp)
  1055fc:	eb 14                	jmp    105612 <strtol+0x54>
    }
    else if (*s == '-') {
  1055fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105601:	0f b6 00             	movzbl (%eax),%eax
  105604:	3c 2d                	cmp    $0x2d,%al
  105606:	75 0a                	jne    105612 <strtol+0x54>
        s ++, neg = 1;
  105608:	ff 45 08             	incl   0x8(%ebp)
  10560b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105612:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105616:	74 06                	je     10561e <strtol+0x60>
  105618:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10561c:	75 22                	jne    105640 <strtol+0x82>
  10561e:	8b 45 08             	mov    0x8(%ebp),%eax
  105621:	0f b6 00             	movzbl (%eax),%eax
  105624:	3c 30                	cmp    $0x30,%al
  105626:	75 18                	jne    105640 <strtol+0x82>
  105628:	8b 45 08             	mov    0x8(%ebp),%eax
  10562b:	40                   	inc    %eax
  10562c:	0f b6 00             	movzbl (%eax),%eax
  10562f:	3c 78                	cmp    $0x78,%al
  105631:	75 0d                	jne    105640 <strtol+0x82>
        s += 2, base = 16;
  105633:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105637:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10563e:	eb 29                	jmp    105669 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  105640:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105644:	75 16                	jne    10565c <strtol+0x9e>
  105646:	8b 45 08             	mov    0x8(%ebp),%eax
  105649:	0f b6 00             	movzbl (%eax),%eax
  10564c:	3c 30                	cmp    $0x30,%al
  10564e:	75 0c                	jne    10565c <strtol+0x9e>
        s ++, base = 8;
  105650:	ff 45 08             	incl   0x8(%ebp)
  105653:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10565a:	eb 0d                	jmp    105669 <strtol+0xab>
    }
    else if (base == 0) {
  10565c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105660:	75 07                	jne    105669 <strtol+0xab>
        base = 10;
  105662:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105669:	8b 45 08             	mov    0x8(%ebp),%eax
  10566c:	0f b6 00             	movzbl (%eax),%eax
  10566f:	3c 2f                	cmp    $0x2f,%al
  105671:	7e 1b                	jle    10568e <strtol+0xd0>
  105673:	8b 45 08             	mov    0x8(%ebp),%eax
  105676:	0f b6 00             	movzbl (%eax),%eax
  105679:	3c 39                	cmp    $0x39,%al
  10567b:	7f 11                	jg     10568e <strtol+0xd0>
            dig = *s - '0';
  10567d:	8b 45 08             	mov    0x8(%ebp),%eax
  105680:	0f b6 00             	movzbl (%eax),%eax
  105683:	0f be c0             	movsbl %al,%eax
  105686:	83 e8 30             	sub    $0x30,%eax
  105689:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10568c:	eb 48                	jmp    1056d6 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10568e:	8b 45 08             	mov    0x8(%ebp),%eax
  105691:	0f b6 00             	movzbl (%eax),%eax
  105694:	3c 60                	cmp    $0x60,%al
  105696:	7e 1b                	jle    1056b3 <strtol+0xf5>
  105698:	8b 45 08             	mov    0x8(%ebp),%eax
  10569b:	0f b6 00             	movzbl (%eax),%eax
  10569e:	3c 7a                	cmp    $0x7a,%al
  1056a0:	7f 11                	jg     1056b3 <strtol+0xf5>
            dig = *s - 'a' + 10;
  1056a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a5:	0f b6 00             	movzbl (%eax),%eax
  1056a8:	0f be c0             	movsbl %al,%eax
  1056ab:	83 e8 57             	sub    $0x57,%eax
  1056ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056b1:	eb 23                	jmp    1056d6 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1056b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b6:	0f b6 00             	movzbl (%eax),%eax
  1056b9:	3c 40                	cmp    $0x40,%al
  1056bb:	7e 3b                	jle    1056f8 <strtol+0x13a>
  1056bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c0:	0f b6 00             	movzbl (%eax),%eax
  1056c3:	3c 5a                	cmp    $0x5a,%al
  1056c5:	7f 31                	jg     1056f8 <strtol+0x13a>
            dig = *s - 'A' + 10;
  1056c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ca:	0f b6 00             	movzbl (%eax),%eax
  1056cd:	0f be c0             	movsbl %al,%eax
  1056d0:	83 e8 37             	sub    $0x37,%eax
  1056d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1056d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  1056dc:	7d 19                	jge    1056f7 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  1056de:	ff 45 08             	incl   0x8(%ebp)
  1056e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056e4:	0f af 45 10          	imul   0x10(%ebp),%eax
  1056e8:	89 c2                	mov    %eax,%edx
  1056ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056ed:	01 d0                	add    %edx,%eax
  1056ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1056f2:	e9 72 ff ff ff       	jmp    105669 <strtol+0xab>
            break;
  1056f7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1056f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056fc:	74 08                	je     105706 <strtol+0x148>
        *endptr = (char *) s;
  1056fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105701:	8b 55 08             	mov    0x8(%ebp),%edx
  105704:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105706:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10570a:	74 07                	je     105713 <strtol+0x155>
  10570c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10570f:	f7 d8                	neg    %eax
  105711:	eb 03                	jmp    105716 <strtol+0x158>
  105713:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105716:	c9                   	leave  
  105717:	c3                   	ret    

00105718 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105718:	f3 0f 1e fb          	endbr32 
  10571c:	55                   	push   %ebp
  10571d:	89 e5                	mov    %esp,%ebp
  10571f:	57                   	push   %edi
  105720:	83 ec 24             	sub    $0x24,%esp
  105723:	8b 45 0c             	mov    0xc(%ebp),%eax
  105726:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105729:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  10572d:	8b 45 08             	mov    0x8(%ebp),%eax
  105730:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105733:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105736:	8b 45 10             	mov    0x10(%ebp),%eax
  105739:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10573c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10573f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105743:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105746:	89 d7                	mov    %edx,%edi
  105748:	f3 aa                	rep stos %al,%es:(%edi)
  10574a:	89 fa                	mov    %edi,%edx
  10574c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10574f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105752:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105755:	83 c4 24             	add    $0x24,%esp
  105758:	5f                   	pop    %edi
  105759:	5d                   	pop    %ebp
  10575a:	c3                   	ret    

0010575b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10575b:	f3 0f 1e fb          	endbr32 
  10575f:	55                   	push   %ebp
  105760:	89 e5                	mov    %esp,%ebp
  105762:	57                   	push   %edi
  105763:	56                   	push   %esi
  105764:	53                   	push   %ebx
  105765:	83 ec 30             	sub    $0x30,%esp
  105768:	8b 45 08             	mov    0x8(%ebp),%eax
  10576b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10576e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105771:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105774:	8b 45 10             	mov    0x10(%ebp),%eax
  105777:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10577a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10577d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105780:	73 42                	jae    1057c4 <memmove+0x69>
  105782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10578b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10578e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105791:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105794:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105797:	c1 e8 02             	shr    $0x2,%eax
  10579a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10579c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10579f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057a2:	89 d7                	mov    %edx,%edi
  1057a4:	89 c6                	mov    %eax,%esi
  1057a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1057a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1057ab:	83 e1 03             	and    $0x3,%ecx
  1057ae:	74 02                	je     1057b2 <memmove+0x57>
  1057b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057b2:	89 f0                	mov    %esi,%eax
  1057b4:	89 fa                	mov    %edi,%edx
  1057b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1057b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1057bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1057bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1057c2:	eb 36                	jmp    1057fa <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1057c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1057ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057cd:	01 c2                	add    %eax,%edx
  1057cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057d2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057d8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1057db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057de:	89 c1                	mov    %eax,%ecx
  1057e0:	89 d8                	mov    %ebx,%eax
  1057e2:	89 d6                	mov    %edx,%esi
  1057e4:	89 c7                	mov    %eax,%edi
  1057e6:	fd                   	std    
  1057e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057e9:	fc                   	cld    
  1057ea:	89 f8                	mov    %edi,%eax
  1057ec:	89 f2                	mov    %esi,%edx
  1057ee:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1057f1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1057f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1057f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1057fa:	83 c4 30             	add    $0x30,%esp
  1057fd:	5b                   	pop    %ebx
  1057fe:	5e                   	pop    %esi
  1057ff:	5f                   	pop    %edi
  105800:	5d                   	pop    %ebp
  105801:	c3                   	ret    

00105802 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105802:	f3 0f 1e fb          	endbr32 
  105806:	55                   	push   %ebp
  105807:	89 e5                	mov    %esp,%ebp
  105809:	57                   	push   %edi
  10580a:	56                   	push   %esi
  10580b:	83 ec 20             	sub    $0x20,%esp
  10580e:	8b 45 08             	mov    0x8(%ebp),%eax
  105811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105814:	8b 45 0c             	mov    0xc(%ebp),%eax
  105817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10581a:	8b 45 10             	mov    0x10(%ebp),%eax
  10581d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105823:	c1 e8 02             	shr    $0x2,%eax
  105826:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10582b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10582e:	89 d7                	mov    %edx,%edi
  105830:	89 c6                	mov    %eax,%esi
  105832:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105834:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105837:	83 e1 03             	and    $0x3,%ecx
  10583a:	74 02                	je     10583e <memcpy+0x3c>
  10583c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10583e:	89 f0                	mov    %esi,%eax
  105840:	89 fa                	mov    %edi,%edx
  105842:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105845:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105848:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10584b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10584e:	83 c4 20             	add    $0x20,%esp
  105851:	5e                   	pop    %esi
  105852:	5f                   	pop    %edi
  105853:	5d                   	pop    %ebp
  105854:	c3                   	ret    

00105855 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105855:	f3 0f 1e fb          	endbr32 
  105859:	55                   	push   %ebp
  10585a:	89 e5                	mov    %esp,%ebp
  10585c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10585f:	8b 45 08             	mov    0x8(%ebp),%eax
  105862:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105865:	8b 45 0c             	mov    0xc(%ebp),%eax
  105868:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10586b:	eb 2e                	jmp    10589b <memcmp+0x46>
        if (*s1 != *s2) {
  10586d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105870:	0f b6 10             	movzbl (%eax),%edx
  105873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105876:	0f b6 00             	movzbl (%eax),%eax
  105879:	38 c2                	cmp    %al,%dl
  10587b:	74 18                	je     105895 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10587d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105880:	0f b6 00             	movzbl (%eax),%eax
  105883:	0f b6 d0             	movzbl %al,%edx
  105886:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105889:	0f b6 00             	movzbl (%eax),%eax
  10588c:	0f b6 c0             	movzbl %al,%eax
  10588f:	29 c2                	sub    %eax,%edx
  105891:	89 d0                	mov    %edx,%eax
  105893:	eb 18                	jmp    1058ad <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105895:	ff 45 fc             	incl   -0x4(%ebp)
  105898:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10589b:	8b 45 10             	mov    0x10(%ebp),%eax
  10589e:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058a1:	89 55 10             	mov    %edx,0x10(%ebp)
  1058a4:	85 c0                	test   %eax,%eax
  1058a6:	75 c5                	jne    10586d <memcmp+0x18>
    }
    return 0;
  1058a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1058ad:	c9                   	leave  
  1058ae:	c3                   	ret    

001058af <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1058af:	f3 0f 1e fb          	endbr32 
  1058b3:	55                   	push   %ebp
  1058b4:	89 e5                	mov    %esp,%ebp
  1058b6:	83 ec 58             	sub    $0x58,%esp
  1058b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1058bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1058bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1058c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1058c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1058cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1058d1:	8b 45 18             	mov    0x18(%ebp),%eax
  1058d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1058dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058e0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1058e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058ed:	74 1c                	je     10590b <printnum+0x5c>
  1058ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f2:	ba 00 00 00 00       	mov    $0x0,%edx
  1058f7:	f7 75 e4             	divl   -0x1c(%ebp)
  1058fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1058fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105900:	ba 00 00 00 00       	mov    $0x0,%edx
  105905:	f7 75 e4             	divl   -0x1c(%ebp)
  105908:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10590e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105911:	f7 75 e4             	divl   -0x1c(%ebp)
  105914:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10591a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10591d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105920:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105923:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105929:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10592c:	8b 45 18             	mov    0x18(%ebp),%eax
  10592f:	ba 00 00 00 00       	mov    $0x0,%edx
  105934:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105937:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10593a:	19 d1                	sbb    %edx,%ecx
  10593c:	72 4c                	jb     10598a <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  10593e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105941:	8d 50 ff             	lea    -0x1(%eax),%edx
  105944:	8b 45 20             	mov    0x20(%ebp),%eax
  105947:	89 44 24 18          	mov    %eax,0x18(%esp)
  10594b:	89 54 24 14          	mov    %edx,0x14(%esp)
  10594f:	8b 45 18             	mov    0x18(%ebp),%eax
  105952:	89 44 24 10          	mov    %eax,0x10(%esp)
  105956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105959:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10595c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105960:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105964:	8b 45 0c             	mov    0xc(%ebp),%eax
  105967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596b:	8b 45 08             	mov    0x8(%ebp),%eax
  10596e:	89 04 24             	mov    %eax,(%esp)
  105971:	e8 39 ff ff ff       	call   1058af <printnum>
  105976:	eb 1b                	jmp    105993 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105978:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10597f:	8b 45 20             	mov    0x20(%ebp),%eax
  105982:	89 04 24             	mov    %eax,(%esp)
  105985:	8b 45 08             	mov    0x8(%ebp),%eax
  105988:	ff d0                	call   *%eax
        while (-- width > 0)
  10598a:	ff 4d 1c             	decl   0x1c(%ebp)
  10598d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105991:	7f e5                	jg     105978 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105993:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105996:	05 cc 70 10 00       	add    $0x1070cc,%eax
  10599b:	0f b6 00             	movzbl (%eax),%eax
  10599e:	0f be c0             	movsbl %al,%eax
  1059a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059a8:	89 04 24             	mov    %eax,(%esp)
  1059ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ae:	ff d0                	call   *%eax
}
  1059b0:	90                   	nop
  1059b1:	c9                   	leave  
  1059b2:	c3                   	ret    

001059b3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1059b3:	f3 0f 1e fb          	endbr32 
  1059b7:	55                   	push   %ebp
  1059b8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1059ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1059be:	7e 14                	jle    1059d4 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1059c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c3:	8b 00                	mov    (%eax),%eax
  1059c5:	8d 48 08             	lea    0x8(%eax),%ecx
  1059c8:	8b 55 08             	mov    0x8(%ebp),%edx
  1059cb:	89 0a                	mov    %ecx,(%edx)
  1059cd:	8b 50 04             	mov    0x4(%eax),%edx
  1059d0:	8b 00                	mov    (%eax),%eax
  1059d2:	eb 30                	jmp    105a04 <getuint+0x51>
    }
    else if (lflag) {
  1059d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059d8:	74 16                	je     1059f0 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1059da:	8b 45 08             	mov    0x8(%ebp),%eax
  1059dd:	8b 00                	mov    (%eax),%eax
  1059df:	8d 48 04             	lea    0x4(%eax),%ecx
  1059e2:	8b 55 08             	mov    0x8(%ebp),%edx
  1059e5:	89 0a                	mov    %ecx,(%edx)
  1059e7:	8b 00                	mov    (%eax),%eax
  1059e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1059ee:	eb 14                	jmp    105a04 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	8b 00                	mov    (%eax),%eax
  1059f5:	8d 48 04             	lea    0x4(%eax),%ecx
  1059f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1059fb:	89 0a                	mov    %ecx,(%edx)
  1059fd:	8b 00                	mov    (%eax),%eax
  1059ff:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105a04:	5d                   	pop    %ebp
  105a05:	c3                   	ret    

00105a06 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105a06:	f3 0f 1e fb          	endbr32 
  105a0a:	55                   	push   %ebp
  105a0b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105a0d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105a11:	7e 14                	jle    105a27 <getint+0x21>
        return va_arg(*ap, long long);
  105a13:	8b 45 08             	mov    0x8(%ebp),%eax
  105a16:	8b 00                	mov    (%eax),%eax
  105a18:	8d 48 08             	lea    0x8(%eax),%ecx
  105a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  105a1e:	89 0a                	mov    %ecx,(%edx)
  105a20:	8b 50 04             	mov    0x4(%eax),%edx
  105a23:	8b 00                	mov    (%eax),%eax
  105a25:	eb 28                	jmp    105a4f <getint+0x49>
    }
    else if (lflag) {
  105a27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a2b:	74 12                	je     105a3f <getint+0x39>
        return va_arg(*ap, long);
  105a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a30:	8b 00                	mov    (%eax),%eax
  105a32:	8d 48 04             	lea    0x4(%eax),%ecx
  105a35:	8b 55 08             	mov    0x8(%ebp),%edx
  105a38:	89 0a                	mov    %ecx,(%edx)
  105a3a:	8b 00                	mov    (%eax),%eax
  105a3c:	99                   	cltd   
  105a3d:	eb 10                	jmp    105a4f <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a42:	8b 00                	mov    (%eax),%eax
  105a44:	8d 48 04             	lea    0x4(%eax),%ecx
  105a47:	8b 55 08             	mov    0x8(%ebp),%edx
  105a4a:	89 0a                	mov    %ecx,(%edx)
  105a4c:	8b 00                	mov    (%eax),%eax
  105a4e:	99                   	cltd   
    }
}
  105a4f:	5d                   	pop    %ebp
  105a50:	c3                   	ret    

00105a51 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105a51:	f3 0f 1e fb          	endbr32 
  105a55:	55                   	push   %ebp
  105a56:	89 e5                	mov    %esp,%ebp
  105a58:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105a5b:	8d 45 14             	lea    0x14(%ebp),%eax
  105a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a68:	8b 45 10             	mov    0x10(%ebp),%eax
  105a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a76:	8b 45 08             	mov    0x8(%ebp),%eax
  105a79:	89 04 24             	mov    %eax,(%esp)
  105a7c:	e8 03 00 00 00       	call   105a84 <vprintfmt>
    va_end(ap);
}
  105a81:	90                   	nop
  105a82:	c9                   	leave  
  105a83:	c3                   	ret    

00105a84 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105a84:	f3 0f 1e fb          	endbr32 
  105a88:	55                   	push   %ebp
  105a89:	89 e5                	mov    %esp,%ebp
  105a8b:	56                   	push   %esi
  105a8c:	53                   	push   %ebx
  105a8d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a90:	eb 17                	jmp    105aa9 <vprintfmt+0x25>
            if (ch == '\0') {
  105a92:	85 db                	test   %ebx,%ebx
  105a94:	0f 84 c0 03 00 00    	je     105e5a <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa1:	89 1c 24             	mov    %ebx,(%esp)
  105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa7:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  105aac:	8d 50 01             	lea    0x1(%eax),%edx
  105aaf:	89 55 10             	mov    %edx,0x10(%ebp)
  105ab2:	0f b6 00             	movzbl (%eax),%eax
  105ab5:	0f b6 d8             	movzbl %al,%ebx
  105ab8:	83 fb 25             	cmp    $0x25,%ebx
  105abb:	75 d5                	jne    105a92 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105abd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105ac1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105acb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105ace:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105ad5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105adb:	8b 45 10             	mov    0x10(%ebp),%eax
  105ade:	8d 50 01             	lea    0x1(%eax),%edx
  105ae1:	89 55 10             	mov    %edx,0x10(%ebp)
  105ae4:	0f b6 00             	movzbl (%eax),%eax
  105ae7:	0f b6 d8             	movzbl %al,%ebx
  105aea:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105aed:	83 f8 55             	cmp    $0x55,%eax
  105af0:	0f 87 38 03 00 00    	ja     105e2e <vprintfmt+0x3aa>
  105af6:	8b 04 85 f0 70 10 00 	mov    0x1070f0(,%eax,4),%eax
  105afd:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105b00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105b04:	eb d5                	jmp    105adb <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105b06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105b0a:	eb cf                	jmp    105adb <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105b0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105b13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b16:	89 d0                	mov    %edx,%eax
  105b18:	c1 e0 02             	shl    $0x2,%eax
  105b1b:	01 d0                	add    %edx,%eax
  105b1d:	01 c0                	add    %eax,%eax
  105b1f:	01 d8                	add    %ebx,%eax
  105b21:	83 e8 30             	sub    $0x30,%eax
  105b24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105b27:	8b 45 10             	mov    0x10(%ebp),%eax
  105b2a:	0f b6 00             	movzbl (%eax),%eax
  105b2d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105b30:	83 fb 2f             	cmp    $0x2f,%ebx
  105b33:	7e 38                	jle    105b6d <vprintfmt+0xe9>
  105b35:	83 fb 39             	cmp    $0x39,%ebx
  105b38:	7f 33                	jg     105b6d <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105b3a:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105b3d:	eb d4                	jmp    105b13 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  105b42:	8d 50 04             	lea    0x4(%eax),%edx
  105b45:	89 55 14             	mov    %edx,0x14(%ebp)
  105b48:	8b 00                	mov    (%eax),%eax
  105b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105b4d:	eb 1f                	jmp    105b6e <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105b4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b53:	79 86                	jns    105adb <vprintfmt+0x57>
                width = 0;
  105b55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105b5c:	e9 7a ff ff ff       	jmp    105adb <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105b61:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105b68:	e9 6e ff ff ff       	jmp    105adb <vprintfmt+0x57>
            goto process_precision;
  105b6d:	90                   	nop

        process_precision:
            if (width < 0)
  105b6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b72:	0f 89 63 ff ff ff    	jns    105adb <vprintfmt+0x57>
                width = precision, precision = -1;
  105b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105b85:	e9 51 ff ff ff       	jmp    105adb <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105b8a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105b8d:	e9 49 ff ff ff       	jmp    105adb <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105b92:	8b 45 14             	mov    0x14(%ebp),%eax
  105b95:	8d 50 04             	lea    0x4(%eax),%edx
  105b98:	89 55 14             	mov    %edx,0x14(%ebp)
  105b9b:	8b 00                	mov    (%eax),%eax
  105b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ba4:	89 04 24             	mov    %eax,(%esp)
  105ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  105baa:	ff d0                	call   *%eax
            break;
  105bac:	e9 a4 02 00 00       	jmp    105e55 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  105bb4:	8d 50 04             	lea    0x4(%eax),%edx
  105bb7:	89 55 14             	mov    %edx,0x14(%ebp)
  105bba:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105bbc:	85 db                	test   %ebx,%ebx
  105bbe:	79 02                	jns    105bc2 <vprintfmt+0x13e>
                err = -err;
  105bc0:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105bc2:	83 fb 06             	cmp    $0x6,%ebx
  105bc5:	7f 0b                	jg     105bd2 <vprintfmt+0x14e>
  105bc7:	8b 34 9d b0 70 10 00 	mov    0x1070b0(,%ebx,4),%esi
  105bce:	85 f6                	test   %esi,%esi
  105bd0:	75 23                	jne    105bf5 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105bd2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105bd6:	c7 44 24 08 dd 70 10 	movl   $0x1070dd,0x8(%esp)
  105bdd:	00 
  105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be5:	8b 45 08             	mov    0x8(%ebp),%eax
  105be8:	89 04 24             	mov    %eax,(%esp)
  105beb:	e8 61 fe ff ff       	call   105a51 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105bf0:	e9 60 02 00 00       	jmp    105e55 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105bf5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105bf9:	c7 44 24 08 e6 70 10 	movl   $0x1070e6,0x8(%esp)
  105c00:	00 
  105c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c08:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0b:	89 04 24             	mov    %eax,(%esp)
  105c0e:	e8 3e fe ff ff       	call   105a51 <printfmt>
            break;
  105c13:	e9 3d 02 00 00       	jmp    105e55 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105c18:	8b 45 14             	mov    0x14(%ebp),%eax
  105c1b:	8d 50 04             	lea    0x4(%eax),%edx
  105c1e:	89 55 14             	mov    %edx,0x14(%ebp)
  105c21:	8b 30                	mov    (%eax),%esi
  105c23:	85 f6                	test   %esi,%esi
  105c25:	75 05                	jne    105c2c <vprintfmt+0x1a8>
                p = "(null)";
  105c27:	be e9 70 10 00       	mov    $0x1070e9,%esi
            }
            if (width > 0 && padc != '-') {
  105c2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c30:	7e 76                	jle    105ca8 <vprintfmt+0x224>
  105c32:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105c36:	74 70                	je     105ca8 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c3f:	89 34 24             	mov    %esi,(%esp)
  105c42:	e8 ba f7 ff ff       	call   105401 <strnlen>
  105c47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c4a:	29 c2                	sub    %eax,%edx
  105c4c:	89 d0                	mov    %edx,%eax
  105c4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c51:	eb 16                	jmp    105c69 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105c53:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c5e:	89 04 24             	mov    %eax,(%esp)
  105c61:	8b 45 08             	mov    0x8(%ebp),%eax
  105c64:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c66:	ff 4d e8             	decl   -0x18(%ebp)
  105c69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c6d:	7f e4                	jg     105c53 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105c6f:	eb 37                	jmp    105ca8 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105c75:	74 1f                	je     105c96 <vprintfmt+0x212>
  105c77:	83 fb 1f             	cmp    $0x1f,%ebx
  105c7a:	7e 05                	jle    105c81 <vprintfmt+0x1fd>
  105c7c:	83 fb 7e             	cmp    $0x7e,%ebx
  105c7f:	7e 15                	jle    105c96 <vprintfmt+0x212>
                    putch('?', putdat);
  105c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c88:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c92:	ff d0                	call   *%eax
  105c94:	eb 0f                	jmp    105ca5 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c9d:	89 1c 24             	mov    %ebx,(%esp)
  105ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca3:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ca5:	ff 4d e8             	decl   -0x18(%ebp)
  105ca8:	89 f0                	mov    %esi,%eax
  105caa:	8d 70 01             	lea    0x1(%eax),%esi
  105cad:	0f b6 00             	movzbl (%eax),%eax
  105cb0:	0f be d8             	movsbl %al,%ebx
  105cb3:	85 db                	test   %ebx,%ebx
  105cb5:	74 27                	je     105cde <vprintfmt+0x25a>
  105cb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105cbb:	78 b4                	js     105c71 <vprintfmt+0x1ed>
  105cbd:	ff 4d e4             	decl   -0x1c(%ebp)
  105cc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105cc4:	79 ab                	jns    105c71 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105cc6:	eb 16                	jmp    105cde <vprintfmt+0x25a>
                putch(' ', putdat);
  105cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ccf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd9:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105cdb:	ff 4d e8             	decl   -0x18(%ebp)
  105cde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ce2:	7f e4                	jg     105cc8 <vprintfmt+0x244>
            }
            break;
  105ce4:	e9 6c 01 00 00       	jmp    105e55 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cf0:	8d 45 14             	lea    0x14(%ebp),%eax
  105cf3:	89 04 24             	mov    %eax,(%esp)
  105cf6:	e8 0b fd ff ff       	call   105a06 <getint>
  105cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d07:	85 d2                	test   %edx,%edx
  105d09:	79 26                	jns    105d31 <vprintfmt+0x2ad>
                putch('-', putdat);
  105d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d12:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105d19:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1c:	ff d0                	call   *%eax
                num = -(long long)num;
  105d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d24:	f7 d8                	neg    %eax
  105d26:	83 d2 00             	adc    $0x0,%edx
  105d29:	f7 da                	neg    %edx
  105d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105d31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d38:	e9 a8 00 00 00       	jmp    105de5 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d44:	8d 45 14             	lea    0x14(%ebp),%eax
  105d47:	89 04 24             	mov    %eax,(%esp)
  105d4a:	e8 64 fc ff ff       	call   1059b3 <getuint>
  105d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d52:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105d55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d5c:	e9 84 00 00 00       	jmp    105de5 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d68:	8d 45 14             	lea    0x14(%ebp),%eax
  105d6b:	89 04 24             	mov    %eax,(%esp)
  105d6e:	e8 40 fc ff ff       	call   1059b3 <getuint>
  105d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105d79:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105d80:	eb 63                	jmp    105de5 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  105d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d89:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105d90:	8b 45 08             	mov    0x8(%ebp),%eax
  105d93:	ff d0                	call   *%eax
            putch('x', putdat);
  105d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d9c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105da3:	8b 45 08             	mov    0x8(%ebp),%eax
  105da6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105da8:	8b 45 14             	mov    0x14(%ebp),%eax
  105dab:	8d 50 04             	lea    0x4(%eax),%edx
  105dae:	89 55 14             	mov    %edx,0x14(%ebp)
  105db1:	8b 00                	mov    (%eax),%eax
  105db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105dbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105dc4:	eb 1f                	jmp    105de5 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dcd:	8d 45 14             	lea    0x14(%ebp),%eax
  105dd0:	89 04 24             	mov    %eax,(%esp)
  105dd3:	e8 db fb ff ff       	call   1059b3 <getuint>
  105dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105dde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105de5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dec:	89 54 24 18          	mov    %edx,0x18(%esp)
  105df0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105df3:	89 54 24 14          	mov    %edx,0x14(%esp)
  105df7:	89 44 24 10          	mov    %eax,0x10(%esp)
  105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e01:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e05:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e10:	8b 45 08             	mov    0x8(%ebp),%eax
  105e13:	89 04 24             	mov    %eax,(%esp)
  105e16:	e8 94 fa ff ff       	call   1058af <printnum>
            break;
  105e1b:	eb 38                	jmp    105e55 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e24:	89 1c 24             	mov    %ebx,(%esp)
  105e27:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2a:	ff d0                	call   *%eax
            break;
  105e2c:	eb 27                	jmp    105e55 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e31:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e35:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e3f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105e41:	ff 4d 10             	decl   0x10(%ebp)
  105e44:	eb 03                	jmp    105e49 <vprintfmt+0x3c5>
  105e46:	ff 4d 10             	decl   0x10(%ebp)
  105e49:	8b 45 10             	mov    0x10(%ebp),%eax
  105e4c:	48                   	dec    %eax
  105e4d:	0f b6 00             	movzbl (%eax),%eax
  105e50:	3c 25                	cmp    $0x25,%al
  105e52:	75 f2                	jne    105e46 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  105e54:	90                   	nop
    while (1) {
  105e55:	e9 36 fc ff ff       	jmp    105a90 <vprintfmt+0xc>
                return;
  105e5a:	90                   	nop
        }
    }
}
  105e5b:	83 c4 40             	add    $0x40,%esp
  105e5e:	5b                   	pop    %ebx
  105e5f:	5e                   	pop    %esi
  105e60:	5d                   	pop    %ebp
  105e61:	c3                   	ret    

00105e62 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105e62:	f3 0f 1e fb          	endbr32 
  105e66:	55                   	push   %ebp
  105e67:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e6c:	8b 40 08             	mov    0x8(%eax),%eax
  105e6f:	8d 50 01             	lea    0x1(%eax),%edx
  105e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e75:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e7b:	8b 10                	mov    (%eax),%edx
  105e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e80:	8b 40 04             	mov    0x4(%eax),%eax
  105e83:	39 c2                	cmp    %eax,%edx
  105e85:	73 12                	jae    105e99 <sprintputch+0x37>
        *b->buf ++ = ch;
  105e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e8a:	8b 00                	mov    (%eax),%eax
  105e8c:	8d 48 01             	lea    0x1(%eax),%ecx
  105e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e92:	89 0a                	mov    %ecx,(%edx)
  105e94:	8b 55 08             	mov    0x8(%ebp),%edx
  105e97:	88 10                	mov    %dl,(%eax)
    }
}
  105e99:	90                   	nop
  105e9a:	5d                   	pop    %ebp
  105e9b:	c3                   	ret    

00105e9c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105e9c:	f3 0f 1e fb          	endbr32 
  105ea0:	55                   	push   %ebp
  105ea1:	89 e5                	mov    %esp,%ebp
  105ea3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  105ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  105eb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  105eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec4:	89 04 24             	mov    %eax,(%esp)
  105ec7:	e8 08 00 00 00       	call   105ed4 <vsnprintf>
  105ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ed2:	c9                   	leave  
  105ed3:	c3                   	ret    

00105ed4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ed4:	f3 0f 1e fb          	endbr32 
  105ed8:	55                   	push   %ebp
  105ed9:	89 e5                	mov    %esp,%ebp
  105edb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105ede:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ee7:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eea:	8b 45 08             	mov    0x8(%ebp),%eax
  105eed:	01 d0                	add    %edx,%eax
  105eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105ef9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105efd:	74 0a                	je     105f09 <vsnprintf+0x35>
  105eff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f05:	39 c2                	cmp    %eax,%edx
  105f07:	76 07                	jbe    105f10 <vsnprintf+0x3c>
        return -E_INVAL;
  105f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105f0e:	eb 2a                	jmp    105f3a <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105f10:	8b 45 14             	mov    0x14(%ebp),%eax
  105f13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105f17:	8b 45 10             	mov    0x10(%ebp),%eax
  105f1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f25:	c7 04 24 62 5e 10 00 	movl   $0x105e62,(%esp)
  105f2c:	e8 53 fb ff ff       	call   105a84 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f34:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105f3a:	c9                   	leave  
  105f3b:	c3                   	ret    
