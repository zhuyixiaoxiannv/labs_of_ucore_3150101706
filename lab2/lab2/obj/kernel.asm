
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c010005d:	e8 b6 56 00 00       	call   c0105718 <memset>

    cons_init();                // init the console
c0100062:	e8 4b 16 00 00       	call   c01016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 5f 10 c0 	movl   $0xc0105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 5f 10 c0 	movl   $0xc0105f5c,(%esp)
c010007c:	e8 39 02 00 00       	call   c01002ba <cprintf>

    print_kerninfo();
c0100081:	e8 f7 08 00 00       	call   c010097d <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 b0 31 00 00       	call   c0103240 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 98 17 00 00       	call   c010182d <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 18 19 00 00       	call   c01019b2 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 5a 0d 00 00       	call   c0100df9 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 d5 18 00 00       	call   c0101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	f3 0f 1e fb          	endbr32 
c01000aa:	55                   	push   %ebp
c01000ab:	89 e5                	mov    %esp,%ebp
c01000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b7:	00 
c01000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bf:	00 
c01000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c7:	e8 17 0d 00 00       	call   c0100de3 <mon_backtrace>
}
c01000cc:	90                   	nop
c01000cd:	c9                   	leave  
c01000ce:	c3                   	ret    

c01000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cf:	f3 0f 1e fb          	endbr32 
c01000d3:	55                   	push   %ebp
c01000d4:	89 e5                	mov    %esp,%ebp
c01000d6:	53                   	push   %ebx
c01000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f2:	89 04 24             	mov    %eax,(%esp)
c01000f5:	e8 ac ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000fa:	90                   	nop
c01000fb:	83 c4 14             	add    $0x14,%esp
c01000fe:	5b                   	pop    %ebx
c01000ff:	5d                   	pop    %ebp
c0100100:	c3                   	ret    

c0100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100101:	f3 0f 1e fb          	endbr32 
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010b:	8b 45 10             	mov    0x10(%ebp),%eax
c010010e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100112:	8b 45 08             	mov    0x8(%ebp),%eax
c0100115:	89 04 24             	mov    %eax,(%esp)
c0100118:	e8 b2 ff ff ff       	call   c01000cf <grade_backtrace1>
}
c010011d:	90                   	nop
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	f3 0f 1e fb          	endbr32 
c0100124:	55                   	push   %ebp
c0100125:	89 e5                	mov    %esp,%ebp
c0100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100136:	ff 
c0100137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100142:	e8 ba ff ff ff       	call   c0100101 <grade_backtrace0>
}
c0100147:	90                   	nop
c0100148:	c9                   	leave  
c0100149:	c3                   	ret    

c010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014a:	f3 0f 1e fb          	endbr32 
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 61 5f 10 c0 	movl   $0xc0105f61,(%esp)
c010017d:	e8 38 01 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 6f 5f 10 c0 	movl   $0xc0105f6f,(%esp)
c010019c:	e8 19 01 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 7d 5f 10 c0 	movl   $0xc0105f7d,(%esp)
c01001bb:	e8 fa 00 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 8b 5f 10 c0 	movl   $0xc0105f8b,(%esp)
c01001da:	e8 db 00 00 00       	call   c01002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 99 5f 10 c0 	movl   $0xc0105f99,(%esp)
c01001f9:	e8 bc 00 00 00       	call   c01002ba <cprintf>
    round ++;
c01001fe:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c0100209:	90                   	nop
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	f3 0f 1e fb          	endbr32 
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100213:	90                   	nop
c0100214:	5d                   	pop    %ebp
c0100215:	c3                   	ret    

c0100216 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100216:	f3 0f 1e fb          	endbr32 
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010021d:	90                   	nop
c010021e:	5d                   	pop    %ebp
c010021f:	c3                   	ret    

c0100220 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100220:	f3 0f 1e fb          	endbr32 
c0100224:	55                   	push   %ebp
c0100225:	89 e5                	mov    %esp,%ebp
c0100227:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010022a:	e8 1b ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010022f:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c0100236:	e8 7f 00 00 00       	call   c01002ba <cprintf>
    lab1_switch_to_user();
c010023b:	e8 cc ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c0100240:	e8 05 ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100245:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c010024c:	e8 69 00 00 00       	call   c01002ba <cprintf>
    lab1_switch_to_kernel();
c0100251:	e8 c0 ff ff ff       	call   c0100216 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100256:	e8 ef fe ff ff       	call   c010014a <lab1_print_cur_status>
}
c010025b:	90                   	nop
c010025c:	c9                   	leave  
c010025d:	c3                   	ret    

c010025e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010025e:	f3 0f 1e fb          	endbr32 
c0100262:	55                   	push   %ebp
c0100263:	89 e5                	mov    %esp,%ebp
c0100265:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100268:	8b 45 08             	mov    0x8(%ebp),%eax
c010026b:	89 04 24             	mov    %eax,(%esp)
c010026e:	e8 70 14 00 00       	call   c01016e3 <cons_putc>
    (*cnt) ++;
c0100273:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100276:	8b 00                	mov    (%eax),%eax
c0100278:	8d 50 01             	lea    0x1(%eax),%edx
c010027b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027e:	89 10                	mov    %edx,(%eax)
}
c0100280:	90                   	nop
c0100281:	c9                   	leave  
c0100282:	c3                   	ret    

c0100283 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100283:	f3 0f 1e fb          	endbr32 
c0100287:	55                   	push   %ebp
c0100288:	89 e5                	mov    %esp,%ebp
c010028a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010028d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100294:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100297:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010029b:	8b 45 08             	mov    0x8(%ebp),%eax
c010029e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a9:	c7 04 24 5e 02 10 c0 	movl   $0xc010025e,(%esp)
c01002b0:	e8 cf 57 00 00       	call   c0105a84 <vprintfmt>
    return cnt;
c01002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b8:	c9                   	leave  
c01002b9:	c3                   	ret    

c01002ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002ba:	f3 0f 1e fb          	endbr32 
c01002be:	55                   	push   %ebp
c01002bf:	89 e5                	mov    %esp,%ebp
c01002c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 a7 ff ff ff       	call   c0100283 <vcprintf>
c01002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002e2:	c9                   	leave  
c01002e3:	c3                   	ret    

c01002e4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002e4:	f3 0f 1e fb          	endbr32 
c01002e8:	55                   	push   %ebp
c01002e9:	89 e5                	mov    %esp,%ebp
c01002eb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f1:	89 04 24             	mov    %eax,(%esp)
c01002f4:	e8 ea 13 00 00       	call   c01016e3 <cons_putc>
}
c01002f9:	90                   	nop
c01002fa:	c9                   	leave  
c01002fb:	c3                   	ret    

c01002fc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002fc:	f3 0f 1e fb          	endbr32 
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010030d:	eb 13                	jmp    c0100322 <cputs+0x26>
        cputch(c, &cnt);
c010030f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100313:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100316:	89 54 24 04          	mov    %edx,0x4(%esp)
c010031a:	89 04 24             	mov    %eax,(%esp)
c010031d:	e8 3c ff ff ff       	call   c010025e <cputch>
    while ((c = *str ++) != '\0') {
c0100322:	8b 45 08             	mov    0x8(%ebp),%eax
c0100325:	8d 50 01             	lea    0x1(%eax),%edx
c0100328:	89 55 08             	mov    %edx,0x8(%ebp)
c010032b:	0f b6 00             	movzbl (%eax),%eax
c010032e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100331:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100335:	75 d8                	jne    c010030f <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100337:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010033a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100345:	e8 14 ff ff ff       	call   c010025e <cputch>
    return cnt;
c010034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010034d:	c9                   	leave  
c010034e:	c3                   	ret    

c010034f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010034f:	f3 0f 1e fb          	endbr32 
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100359:	90                   	nop
c010035a:	e8 c5 13 00 00       	call   c0101724 <cons_getc>
c010035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100366:	74 f2                	je     c010035a <getchar+0xb>
        /* do nothing */;
    return c;
c0100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036b:	c9                   	leave  
c010036c:	c3                   	ret    

c010036d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010036d:	f3 0f 1e fb          	endbr32 
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010037b:	74 13                	je     c0100390 <readline+0x23>
        cprintf("%s", prompt);
c010037d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100380:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100384:	c7 04 24 e7 5f 10 c0 	movl   $0xc0105fe7,(%esp)
c010038b:	e8 2a ff ff ff       	call   c01002ba <cprintf>
    }
    int i = 0, c;
c0100390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100397:	e8 b3 ff ff ff       	call   c010034f <getchar>
c010039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010039f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003a3:	79 07                	jns    c01003ac <readline+0x3f>
            return NULL;
c01003a5:	b8 00 00 00 00       	mov    $0x0,%eax
c01003aa:	eb 78                	jmp    c0100424 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003ac:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003b0:	7e 28                	jle    c01003da <readline+0x6d>
c01003b2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003b9:	7f 1f                	jg     c01003da <readline+0x6d>
            cputchar(c);
c01003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003be:	89 04 24             	mov    %eax,(%esp)
c01003c1:	e8 1e ff ff ff       	call   c01002e4 <cputchar>
            buf[i ++] = c;
c01003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c9:	8d 50 01             	lea    0x1(%eax),%edx
c01003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003d2:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003d8:	eb 45                	jmp    c010041f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003da:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003de:	75 16                	jne    c01003f6 <readline+0x89>
c01003e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e4:	7e 10                	jle    c01003f6 <readline+0x89>
            cputchar(c);
c01003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003e9:	89 04 24             	mov    %eax,(%esp)
c01003ec:	e8 f3 fe ff ff       	call   c01002e4 <cputchar>
            i --;
c01003f1:	ff 4d f4             	decl   -0xc(%ebp)
c01003f4:	eb 29                	jmp    c010041f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01003f6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003fa:	74 06                	je     c0100402 <readline+0x95>
c01003fc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c0100400:	75 95                	jne    c0100397 <readline+0x2a>
            cputchar(c);
c0100402:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100405:	89 04 24             	mov    %eax,(%esp)
c0100408:	e8 d7 fe ff ff       	call   c01002e4 <cputchar>
            buf[i] = '\0';
c010040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100410:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100415:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100418:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c010041d:	eb 05                	jmp    c0100424 <readline+0xb7>
        c = getchar();
c010041f:	e9 73 ff ff ff       	jmp    c0100397 <readline+0x2a>
        }
    }
}
c0100424:	c9                   	leave  
c0100425:	c3                   	ret    

c0100426 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100426:	f3 0f 1e fb          	endbr32 
c010042a:	55                   	push   %ebp
c010042b:	89 e5                	mov    %esp,%ebp
c010042d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100430:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100435:	85 c0                	test   %eax,%eax
c0100437:	75 5b                	jne    c0100494 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100439:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100440:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100443:	8d 45 14             	lea    0x14(%ebp),%eax
c0100446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100449:	8b 45 0c             	mov    0xc(%ebp),%eax
c010044c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100450:	8b 45 08             	mov    0x8(%ebp),%eax
c0100453:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100457:	c7 04 24 ea 5f 10 c0 	movl   $0xc0105fea,(%esp)
c010045e:	e8 57 fe ff ff       	call   c01002ba <cprintf>
    vcprintf(fmt, ap);
c0100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100466:	89 44 24 04          	mov    %eax,0x4(%esp)
c010046a:	8b 45 10             	mov    0x10(%ebp),%eax
c010046d:	89 04 24             	mov    %eax,(%esp)
c0100470:	e8 0e fe ff ff       	call   c0100283 <vcprintf>
    cprintf("\n");
c0100475:	c7 04 24 06 60 10 c0 	movl   $0xc0106006,(%esp)
c010047c:	e8 39 fe ff ff       	call   c01002ba <cprintf>
    
    cprintf("stack trackback:\n");
c0100481:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0100488:	e8 2d fe ff ff       	call   c01002ba <cprintf>
    print_stackframe();
c010048d:	e8 3d 06 00 00       	call   c0100acf <print_stackframe>
c0100492:	eb 01                	jmp    c0100495 <__panic+0x6f>
        goto panic_dead;
c0100494:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100495:	e8 eb 14 00 00       	call   c0101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004a1:	e8 64 08 00 00       	call   c0100d0a <kmonitor>
c01004a6:	eb f2                	jmp    c010049a <__panic+0x74>

c01004a8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004a8:	f3 0f 1e fb          	endbr32 
c01004ac:	55                   	push   %ebp
c01004ad:	89 e5                	mov    %esp,%ebp
c01004af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004b2:	8d 45 14             	lea    0x14(%ebp),%eax
c01004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004bb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004c6:	c7 04 24 1a 60 10 c0 	movl   $0xc010601a,(%esp)
c01004cd:	e8 e8 fd ff ff       	call   c01002ba <cprintf>
    vcprintf(fmt, ap);
c01004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004dc:	89 04 24             	mov    %eax,(%esp)
c01004df:	e8 9f fd ff ff       	call   c0100283 <vcprintf>
    cprintf("\n");
c01004e4:	c7 04 24 06 60 10 c0 	movl   $0xc0106006,(%esp)
c01004eb:	e8 ca fd ff ff       	call   c01002ba <cprintf>
    va_end(ap);
}
c01004f0:	90                   	nop
c01004f1:	c9                   	leave  
c01004f2:	c3                   	ret    

c01004f3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004f3:	f3 0f 1e fb          	endbr32 
c01004f7:	55                   	push   %ebp
c01004f8:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004fa:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c01004ff:	5d                   	pop    %ebp
c0100500:	c3                   	ret    

c0100501 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100501:	f3 0f 1e fb          	endbr32 
c0100505:	55                   	push   %ebp
c0100506:	89 e5                	mov    %esp,%ebp
c0100508:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010050b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050e:	8b 00                	mov    (%eax),%eax
c0100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100513:	8b 45 10             	mov    0x10(%ebp),%eax
c0100516:	8b 00                	mov    (%eax),%eax
c0100518:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010051b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100522:	e9 ca 00 00 00       	jmp    c01005f1 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100527:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010052d:	01 d0                	add    %edx,%eax
c010052f:	89 c2                	mov    %eax,%edx
c0100531:	c1 ea 1f             	shr    $0x1f,%edx
c0100534:	01 d0                	add    %edx,%eax
c0100536:	d1 f8                	sar    %eax
c0100538:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100541:	eb 03                	jmp    c0100546 <stab_binsearch+0x45>
            m --;
c0100543:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010054c:	7c 1f                	jl     c010056d <stab_binsearch+0x6c>
c010054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100551:	89 d0                	mov    %edx,%eax
c0100553:	01 c0                	add    %eax,%eax
c0100555:	01 d0                	add    %edx,%eax
c0100557:	c1 e0 02             	shl    $0x2,%eax
c010055a:	89 c2                	mov    %eax,%edx
c010055c:	8b 45 08             	mov    0x8(%ebp),%eax
c010055f:	01 d0                	add    %edx,%eax
c0100561:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100565:	0f b6 c0             	movzbl %al,%eax
c0100568:	39 45 14             	cmp    %eax,0x14(%ebp)
c010056b:	75 d6                	jne    c0100543 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c010056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100570:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100573:	7d 09                	jge    c010057e <stab_binsearch+0x7d>
            l = true_m + 1;
c0100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100578:	40                   	inc    %eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010057c:	eb 73                	jmp    c01005f1 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c010057e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100588:	89 d0                	mov    %edx,%eax
c010058a:	01 c0                	add    %eax,%eax
c010058c:	01 d0                	add    %edx,%eax
c010058e:	c1 e0 02             	shl    $0x2,%eax
c0100591:	89 c2                	mov    %eax,%edx
c0100593:	8b 45 08             	mov    0x8(%ebp),%eax
c0100596:	01 d0                	add    %edx,%eax
c0100598:	8b 40 08             	mov    0x8(%eax),%eax
c010059b:	39 45 18             	cmp    %eax,0x18(%ebp)
c010059e:	76 11                	jbe    c01005b1 <stab_binsearch+0xb0>
            *region_left = m;
c01005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005ab:	40                   	inc    %eax
c01005ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005af:	eb 40                	jmp    c01005f1 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b4:	89 d0                	mov    %edx,%eax
c01005b6:	01 c0                	add    %eax,%eax
c01005b8:	01 d0                	add    %edx,%eax
c01005ba:	c1 e0 02             	shl    $0x2,%eax
c01005bd:	89 c2                	mov    %eax,%edx
c01005bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01005c2:	01 d0                	add    %edx,%eax
c01005c4:	8b 40 08             	mov    0x8(%eax),%eax
c01005c7:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005ca:	73 14                	jae    c01005e0 <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005cf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005da:	48                   	dec    %eax
c01005db:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005de:	eb 11                	jmp    c01005f1 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005e6:	89 10                	mov    %edx,(%eax)
            l = m;
c01005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005ee:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005f7:	0f 8e 2a ff ff ff    	jle    c0100527 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c01005fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100601:	75 0f                	jne    c0100612 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c0100603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100606:	8b 00                	mov    (%eax),%eax
c0100608:	8d 50 ff             	lea    -0x1(%eax),%edx
c010060b:	8b 45 10             	mov    0x10(%ebp),%eax
c010060e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c0100610:	eb 3e                	jmp    c0100650 <stab_binsearch+0x14f>
        l = *region_right;
c0100612:	8b 45 10             	mov    0x10(%ebp),%eax
c0100615:	8b 00                	mov    (%eax),%eax
c0100617:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c010061a:	eb 03                	jmp    c010061f <stab_binsearch+0x11e>
c010061c:	ff 4d fc             	decl   -0x4(%ebp)
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	8b 00                	mov    (%eax),%eax
c0100624:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100627:	7e 1f                	jle    c0100648 <stab_binsearch+0x147>
c0100629:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010062c:	89 d0                	mov    %edx,%eax
c010062e:	01 c0                	add    %eax,%eax
c0100630:	01 d0                	add    %edx,%eax
c0100632:	c1 e0 02             	shl    $0x2,%eax
c0100635:	89 c2                	mov    %eax,%edx
c0100637:	8b 45 08             	mov    0x8(%ebp),%eax
c010063a:	01 d0                	add    %edx,%eax
c010063c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100640:	0f b6 c0             	movzbl %al,%eax
c0100643:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100646:	75 d4                	jne    c010061c <stab_binsearch+0x11b>
        *region_left = l;
c0100648:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010064e:	89 10                	mov    %edx,(%eax)
}
c0100650:	90                   	nop
c0100651:	c9                   	leave  
c0100652:	c3                   	ret    

c0100653 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100653:	f3 0f 1e fb          	endbr32 
c0100657:	55                   	push   %ebp
c0100658:	89 e5                	mov    %esp,%ebp
c010065a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010065d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100660:	c7 00 38 60 10 c0    	movl   $0xc0106038,(%eax)
    info->eip_line = 0;
c0100666:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100673:	c7 40 08 38 60 10 c0 	movl   $0xc0106038,0x8(%eax)
    info->eip_fn_namelen = 9;
c010067a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100684:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100687:	8b 55 08             	mov    0x8(%ebp),%edx
c010068a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010068d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100690:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100697:	c7 45 f4 48 72 10 c0 	movl   $0xc0107248,-0xc(%ebp)
    stab_end = __STAB_END__;
c010069e:	c7 45 f0 d8 38 11 c0 	movl   $0xc01138d8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006a5:	c7 45 ec d9 38 11 c0 	movl   $0xc01138d9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006ac:	c7 45 e8 e6 63 11 c0 	movl   $0xc01163e6,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006b9:	76 0b                	jbe    c01006c6 <debuginfo_eip+0x73>
c01006bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006be:	48                   	dec    %eax
c01006bf:	0f b6 00             	movzbl (%eax),%eax
c01006c2:	84 c0                	test   %al,%al
c01006c4:	74 0a                	je     c01006d0 <debuginfo_eip+0x7d>
        return -1;
c01006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006cb:	e9 ab 02 00 00       	jmp    c010097b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006dd:	c1 f8 02             	sar    $0x2,%eax
c01006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006e6:	48                   	dec    %eax
c01006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ed:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006f1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006f8:	00 
c01006f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100703:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070a:	89 04 24             	mov    %eax,(%esp)
c010070d:	e8 ef fd ff ff       	call   c0100501 <stab_binsearch>
    if (lfile == 0)
c0100712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100715:	85 c0                	test   %eax,%eax
c0100717:	75 0a                	jne    c0100723 <debuginfo_eip+0xd0>
        return -1;
c0100719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010071e:	e9 58 02 00 00       	jmp    c010097b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100726:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100729:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010072f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100732:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100736:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010073d:	00 
c010073e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100741:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100745:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100748:	89 44 24 04          	mov    %eax,0x4(%esp)
c010074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074f:	89 04 24             	mov    %eax,(%esp)
c0100752:	e8 aa fd ff ff       	call   c0100501 <stab_binsearch>

    if (lfun <= rfun) {
c0100757:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010075a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010075d:	39 c2                	cmp    %eax,%edx
c010075f:	7f 78                	jg     c01007d9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100761:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100764:	89 c2                	mov    %eax,%edx
c0100766:	89 d0                	mov    %edx,%eax
c0100768:	01 c0                	add    %eax,%eax
c010076a:	01 d0                	add    %edx,%eax
c010076c:	c1 e0 02             	shl    $0x2,%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100774:	01 d0                	add    %edx,%eax
c0100776:	8b 10                	mov    (%eax),%edx
c0100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010077e:	39 c2                	cmp    %eax,%edx
c0100780:	73 22                	jae    c01007a4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100785:	89 c2                	mov    %eax,%edx
c0100787:	89 d0                	mov    %edx,%eax
c0100789:	01 c0                	add    %eax,%eax
c010078b:	01 d0                	add    %edx,%eax
c010078d:	c1 e0 02             	shl    $0x2,%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	8b 10                	mov    (%eax),%edx
c0100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010079c:	01 c2                	add    %eax,%edx
c010079e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007a7:	89 c2                	mov    %eax,%edx
c01007a9:	89 d0                	mov    %edx,%eax
c01007ab:	01 c0                	add    %eax,%eax
c01007ad:	01 d0                	add    %edx,%eax
c01007af:	c1 e0 02             	shl    $0x2,%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b7:	01 d0                	add    %edx,%eax
c01007b9:	8b 50 08             	mov    0x8(%eax),%edx
c01007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c5:	8b 40 10             	mov    0x10(%eax),%eax
c01007c8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007d7:	eb 15                	jmp    c01007ee <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007dc:	8b 55 08             	mov    0x8(%ebp),%edx
c01007df:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f1:	8b 40 08             	mov    0x8(%eax),%eax
c01007f4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007fb:	00 
c01007fc:	89 04 24             	mov    %eax,(%esp)
c01007ff:	e8 88 4d 00 00       	call   c010558c <strfind>
c0100804:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100807:	8b 52 08             	mov    0x8(%edx),%edx
c010080a:	29 d0                	sub    %edx,%eax
c010080c:	89 c2                	mov    %eax,%edx
c010080e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100811:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100814:	8b 45 08             	mov    0x8(%ebp),%eax
c0100817:	89 44 24 10          	mov    %eax,0x10(%esp)
c010081b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100822:	00 
c0100823:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100826:	89 44 24 08          	mov    %eax,0x8(%esp)
c010082a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010082d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100834:	89 04 24             	mov    %eax,(%esp)
c0100837:	e8 c5 fc ff ff       	call   c0100501 <stab_binsearch>
    if (lline <= rline) {
c010083c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010083f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100842:	39 c2                	cmp    %eax,%edx
c0100844:	7f 23                	jg     c0100869 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100846:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100849:	89 c2                	mov    %eax,%edx
c010084b:	89 d0                	mov    %edx,%eax
c010084d:	01 c0                	add    %eax,%eax
c010084f:	01 d0                	add    %edx,%eax
c0100851:	c1 e0 02             	shl    $0x2,%eax
c0100854:	89 c2                	mov    %eax,%edx
c0100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100864:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100867:	eb 11                	jmp    c010087a <debuginfo_eip+0x227>
        return -1;
c0100869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010086e:	e9 08 01 00 00       	jmp    c010097b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100876:	48                   	dec    %eax
c0100877:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010087a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100880:	39 c2                	cmp    %eax,%edx
c0100882:	7c 56                	jl     c01008da <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c0100884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100887:	89 c2                	mov    %eax,%edx
c0100889:	89 d0                	mov    %edx,%eax
c010088b:	01 c0                	add    %eax,%eax
c010088d:	01 d0                	add    %edx,%eax
c010088f:	c1 e0 02             	shl    $0x2,%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100897:	01 d0                	add    %edx,%eax
c0100899:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010089d:	3c 84                	cmp    $0x84,%al
c010089f:	74 39                	je     c01008da <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	89 d0                	mov    %edx,%eax
c01008a8:	01 c0                	add    %eax,%eax
c01008aa:	01 d0                	add    %edx,%eax
c01008ac:	c1 e0 02             	shl    $0x2,%eax
c01008af:	89 c2                	mov    %eax,%edx
c01008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008b4:	01 d0                	add    %edx,%eax
c01008b6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ba:	3c 64                	cmp    $0x64,%al
c01008bc:	75 b5                	jne    c0100873 <debuginfo_eip+0x220>
c01008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c1:	89 c2                	mov    %eax,%edx
c01008c3:	89 d0                	mov    %edx,%eax
c01008c5:	01 c0                	add    %eax,%eax
c01008c7:	01 d0                	add    %edx,%eax
c01008c9:	c1 e0 02             	shl    $0x2,%eax
c01008cc:	89 c2                	mov    %eax,%edx
c01008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d1:	01 d0                	add    %edx,%eax
c01008d3:	8b 40 08             	mov    0x8(%eax),%eax
c01008d6:	85 c0                	test   %eax,%eax
c01008d8:	74 99                	je     c0100873 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008e0:	39 c2                	cmp    %eax,%edx
c01008e2:	7c 42                	jl     c0100926 <debuginfo_eip+0x2d3>
c01008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e7:	89 c2                	mov    %eax,%edx
c01008e9:	89 d0                	mov    %edx,%eax
c01008eb:	01 c0                	add    %eax,%eax
c01008ed:	01 d0                	add    %edx,%eax
c01008ef:	c1 e0 02             	shl    $0x2,%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f7:	01 d0                	add    %edx,%eax
c01008f9:	8b 10                	mov    (%eax),%edx
c01008fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100901:	39 c2                	cmp    %eax,%edx
c0100903:	73 21                	jae    c0100926 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100908:	89 c2                	mov    %eax,%edx
c010090a:	89 d0                	mov    %edx,%eax
c010090c:	01 c0                	add    %eax,%eax
c010090e:	01 d0                	add    %edx,%eax
c0100910:	c1 e0 02             	shl    $0x2,%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100918:	01 d0                	add    %edx,%eax
c010091a:	8b 10                	mov    (%eax),%edx
c010091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091f:	01 c2                	add    %eax,%edx
c0100921:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100924:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100926:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010092c:	39 c2                	cmp    %eax,%edx
c010092e:	7d 46                	jge    c0100976 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c0100930:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100933:	40                   	inc    %eax
c0100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100937:	eb 16                	jmp    c010094f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010094b:	40                   	inc    %eax
c010094c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010094f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100952:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100955:	39 c2                	cmp    %eax,%edx
c0100957:	7d 1d                	jge    c0100976 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010095c:	89 c2                	mov    %eax,%edx
c010095e:	89 d0                	mov    %edx,%eax
c0100960:	01 c0                	add    %eax,%eax
c0100962:	01 d0                	add    %edx,%eax
c0100964:	c1 e0 02             	shl    $0x2,%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096c:	01 d0                	add    %edx,%eax
c010096e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100972:	3c a0                	cmp    $0xa0,%al
c0100974:	74 c3                	je     c0100939 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100976:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097b:	c9                   	leave  
c010097c:	c3                   	ret    

c010097d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097d:	f3 0f 1e fb          	endbr32 
c0100981:	55                   	push   %ebp
c0100982:	89 e5                	mov    %esp,%ebp
c0100984:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100987:	c7 04 24 42 60 10 c0 	movl   $0xc0106042,(%esp)
c010098e:	e8 27 f9 ff ff       	call   c01002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100993:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010099a:	c0 
c010099b:	c7 04 24 5b 60 10 c0 	movl   $0xc010605b,(%esp)
c01009a2:	e8 13 f9 ff ff       	call   c01002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a7:	c7 44 24 04 3c 5f 10 	movl   $0xc0105f3c,0x4(%esp)
c01009ae:	c0 
c01009af:	c7 04 24 73 60 10 c0 	movl   $0xc0106073,(%esp)
c01009b6:	e8 ff f8 ff ff       	call   c01002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009bb:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01009c2:	c0 
c01009c3:	c7 04 24 8b 60 10 c0 	movl   $0xc010608b,(%esp)
c01009ca:	e8 eb f8 ff ff       	call   c01002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cf:	c7 44 24 04 28 cf 11 	movl   $0xc011cf28,0x4(%esp)
c01009d6:	c0 
c01009d7:	c7 04 24 a3 60 10 c0 	movl   $0xc01060a3,(%esp)
c01009de:	e8 d7 f8 ff ff       	call   c01002ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e3:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c01009e8:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009ed:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009f8:	85 c0                	test   %eax,%eax
c01009fa:	0f 48 c2             	cmovs  %edx,%eax
c01009fd:	c1 f8 0a             	sar    $0xa,%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 bc 60 10 c0 	movl   $0xc01060bc,(%esp)
c0100a0b:	e8 aa f8 ff ff       	call   c01002ba <cprintf>
}
c0100a10:	90                   	nop
c0100a11:	c9                   	leave  
c0100a12:	c3                   	ret    

c0100a13 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a13:	f3 0f 1e fb          	endbr32 
c0100a17:	55                   	push   %ebp
c0100a18:	89 e5                	mov    %esp,%ebp
c0100a1a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a20:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a2a:	89 04 24             	mov    %eax,(%esp)
c0100a2d:	e8 21 fc ff ff       	call   c0100653 <debuginfo_eip>
c0100a32:	85 c0                	test   %eax,%eax
c0100a34:	74 15                	je     c0100a4b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3d:	c7 04 24 e6 60 10 c0 	movl   $0xc01060e6,(%esp)
c0100a44:	e8 71 f8 ff ff       	call   c01002ba <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a49:	eb 6c                	jmp    c0100ab7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a52:	eb 1b                	jmp    c0100a6f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	01 d0                	add    %edx,%eax
c0100a5c:	0f b6 10             	movzbl (%eax),%edx
c0100a5f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a68:	01 c8                	add    %ecx,%eax
c0100a6a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6c:	ff 45 f4             	incl   -0xc(%ebp)
c0100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a75:	7c dd                	jl     c0100a54 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a77:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a80:	01 d0                	add    %edx,%eax
c0100a82:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a88:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8b:	89 d1                	mov    %edx,%ecx
c0100a8d:	29 c1                	sub    %eax,%ecx
c0100a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a99:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 02 61 10 c0 	movl   $0xc0106102,(%esp)
c0100ab2:	e8 03 f8 ff ff       	call   c01002ba <cprintf>
}
c0100ab7:	90                   	nop
c0100ab8:	c9                   	leave  
c0100ab9:	c3                   	ret    

c0100aba <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100aba:	f3 0f 1e fb          	endbr32 
c0100abe:	55                   	push   %ebp
c0100abf:	89 e5                	mov    %esp,%ebp
c0100ac1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ac4:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100acd:	c9                   	leave  
c0100ace:	c3                   	ret    

c0100acf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100acf:	f3 0f 1e fb          	endbr32 
c0100ad3:	55                   	push   %ebp
c0100ad4:	89 e5                	mov    %esp,%ebp
c0100ad6:	53                   	push   %ebx
c0100ad7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ada:	89 e8                	mov    %ebp,%eax
c0100adc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c0100adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t* curr_ebp=read_ebp();
c0100ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t* curr_eip=read_eip();
c0100ae5:	e8 d0 ff ff ff       	call   c0100aba <read_eip>
c0100aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //读了代码之后我觉得差别不是很大，我觉得需要注意的地方是在for循环里面的终止条件里面加上了ebp != 0
    for (int i = 0 ; curr_ebp!=NULL && i < STACKFRAME_DEPTH ; ++i )
c0100aed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100af4:	e9 86 00 00 00       	jmp    c0100b7f <print_stackframe+0xb0>
    {
        cprintf("ebp:%08p eip:%08p ",curr_ebp,curr_eip);
c0100af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100afc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b07:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
c0100b0e:	e8 a7 f7 ff ff       	call   c01002ba <cprintf>
        cprintf("args:%08p %08p %08p %08p",*(curr_ebp+2),*(curr_ebp+3),*(curr_ebp+4),*(curr_ebp+5));
c0100b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b16:	83 c0 14             	add    $0x14,%eax
c0100b19:	8b 18                	mov    (%eax),%ebx
c0100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1e:	83 c0 10             	add    $0x10,%eax
c0100b21:	8b 08                	mov    (%eax),%ecx
c0100b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b26:	83 c0 0c             	add    $0xc,%eax
c0100b29:	8b 10                	mov    (%eax),%edx
c0100b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b2e:	83 c0 08             	add    $0x8,%eax
c0100b31:	8b 00                	mov    (%eax),%eax
c0100b33:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100b37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b43:	c7 04 24 27 61 10 c0 	movl   $0xc0106127,(%esp)
c0100b4a:	e8 6b f7 ff ff       	call   c01002ba <cprintf>
        cprintf("\n");
c0100b4f:	c7 04 24 40 61 10 c0 	movl   $0xc0106140,(%esp)
c0100b56:	e8 5f f7 ff ff       	call   c01002ba <cprintf>
        print_debuginfo(curr_eip-1);
c0100b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b5e:	83 e8 04             	sub    $0x4,%eax
c0100b61:	89 04 24             	mov    %eax,(%esp)
c0100b64:	e8 aa fe ff ff       	call   c0100a13 <print_debuginfo>
        curr_eip=*(curr_ebp+1);
c0100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6c:	83 c0 04             	add    $0x4,%eax
c0100b6f:	8b 00                	mov    (%eax),%eax
c0100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp=*(curr_ebp);
c0100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b77:	8b 00                	mov    (%eax),%eax
c0100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0 ; curr_ebp!=NULL && i < STACKFRAME_DEPTH ; ++i )
c0100b7c:	ff 45 ec             	incl   -0x14(%ebp)
c0100b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b83:	74 0a                	je     c0100b8f <print_stackframe+0xc0>
c0100b85:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b89:	0f 8e 6a ff ff ff    	jle    c0100af9 <print_stackframe+0x2a>
    }
}
c0100b8f:	90                   	nop
c0100b90:	83 c4 34             	add    $0x34,%esp
c0100b93:	5b                   	pop    %ebx
c0100b94:	5d                   	pop    %ebp
c0100b95:	c3                   	ret    

c0100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b96:	f3 0f 1e fb          	endbr32 
c0100b9a:	55                   	push   %ebp
c0100b9b:	89 e5                	mov    %esp,%ebp
c0100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba7:	eb 0c                	jmp    c0100bb5 <parse+0x1f>
            *buf ++ = '\0';
c0100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bac:	8d 50 01             	lea    0x1(%eax),%edx
c0100baf:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb8:	0f b6 00             	movzbl (%eax),%eax
c0100bbb:	84 c0                	test   %al,%al
c0100bbd:	74 1d                	je     c0100bdc <parse+0x46>
c0100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc2:	0f b6 00             	movzbl (%eax),%eax
c0100bc5:	0f be c0             	movsbl %al,%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 c4 61 10 c0 	movl   $0xc01061c4,(%esp)
c0100bd3:	e8 7e 49 00 00       	call   c0105556 <strchr>
c0100bd8:	85 c0                	test   %eax,%eax
c0100bda:	75 cd                	jne    c0100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdf:	0f b6 00             	movzbl (%eax),%eax
c0100be2:	84 c0                	test   %al,%al
c0100be4:	74 65                	je     c0100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bea:	75 14                	jne    c0100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bf3:	00 
c0100bf4:	c7 04 24 c9 61 10 c0 	movl   $0xc01061c9,(%esp)
c0100bfb:	e8 ba f6 ff ff       	call   c01002ba <cprintf>
        }
        argv[argc ++] = buf;
c0100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c03:	8d 50 01             	lea    0x1(%eax),%edx
c0100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c13:	01 c2                	add    %eax,%edx
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1a:	eb 03                	jmp    c0100c1f <parse+0x89>
            buf ++;
c0100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	0f b6 00             	movzbl (%eax),%eax
c0100c25:	84 c0                	test   %al,%al
c0100c27:	74 8c                	je     c0100bb5 <parse+0x1f>
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	0f b6 00             	movzbl (%eax),%eax
c0100c2f:	0f be c0             	movsbl %al,%eax
c0100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c36:	c7 04 24 c4 61 10 c0 	movl   $0xc01061c4,(%esp)
c0100c3d:	e8 14 49 00 00       	call   c0105556 <strchr>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	74 d6                	je     c0100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c46:	e9 6a ff ff ff       	jmp    c0100bb5 <parse+0x1f>
            break;
c0100c4b:	90                   	nop
        }
    }
    return argc;
c0100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c4f:	c9                   	leave  
c0100c50:	c3                   	ret    

c0100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c51:	f3 0f 1e fb          	endbr32 
c0100c55:	55                   	push   %ebp
c0100c56:	89 e5                	mov    %esp,%ebp
c0100c58:	53                   	push   %ebx
c0100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c63:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c66:	89 04 24             	mov    %eax,(%esp)
c0100c69:	e8 28 ff ff ff       	call   c0100b96 <parse>
c0100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c75:	75 0a                	jne    c0100c81 <runcmd+0x30>
        return 0;
c0100c77:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c7c:	e9 83 00 00 00       	jmp    c0100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c88:	eb 5a                	jmp    c0100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c90:	89 d0                	mov    %edx,%eax
c0100c92:	01 c0                	add    %eax,%eax
c0100c94:	01 d0                	add    %edx,%eax
c0100c96:	c1 e0 02             	shl    $0x2,%eax
c0100c99:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c9e:	8b 00                	mov    (%eax),%eax
c0100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ca4:	89 04 24             	mov    %eax,(%esp)
c0100ca7:	e8 06 48 00 00       	call   c01054b2 <strcmp>
c0100cac:	85 c0                	test   %eax,%eax
c0100cae:	75 31                	jne    c0100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cb3:	89 d0                	mov    %edx,%eax
c0100cb5:	01 c0                	add    %eax,%eax
c0100cb7:	01 d0                	add    %edx,%eax
c0100cb9:	c1 e0 02             	shl    $0x2,%eax
c0100cbc:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100cc1:	8b 10                	mov    (%eax),%edx
c0100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cc6:	83 c0 04             	add    $0x4,%eax
c0100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cda:	89 1c 24             	mov    %ebx,(%esp)
c0100cdd:	ff d2                	call   *%edx
c0100cdf:	eb 23                	jmp    c0100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce1:	ff 45 f4             	incl   -0xc(%ebp)
c0100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce7:	83 f8 02             	cmp    $0x2,%eax
c0100cea:	76 9e                	jbe    c0100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf3:	c7 04 24 e7 61 10 c0 	movl   $0xc01061e7,(%esp)
c0100cfa:	e8 bb f5 ff ff       	call   c01002ba <cprintf>
    return 0;
c0100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d04:	83 c4 64             	add    $0x64,%esp
c0100d07:	5b                   	pop    %ebx
c0100d08:	5d                   	pop    %ebp
c0100d09:	c3                   	ret    

c0100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d0a:	f3 0f 1e fb          	endbr32 
c0100d0e:	55                   	push   %ebp
c0100d0f:	89 e5                	mov    %esp,%ebp
c0100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d14:	c7 04 24 00 62 10 c0 	movl   $0xc0106200,(%esp)
c0100d1b:	e8 9a f5 ff ff       	call   c01002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d20:	c7 04 24 28 62 10 c0 	movl   $0xc0106228,(%esp)
c0100d27:	e8 8e f5 ff ff       	call   c01002ba <cprintf>

    if (tf != NULL) {
c0100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d30:	74 0b                	je     c0100d3d <kmonitor+0x33>
        print_trapframe(tf);
c0100d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d35:	89 04 24             	mov    %eax,(%esp)
c0100d38:	e8 bc 0d 00 00       	call   c0101af9 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d3d:	c7 04 24 4d 62 10 c0 	movl   $0xc010624d,(%esp)
c0100d44:	e8 24 f6 ff ff       	call   c010036d <readline>
c0100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d50:	74 eb                	je     c0100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5c:	89 04 24             	mov    %eax,(%esp)
c0100d5f:	e8 ed fe ff ff       	call   c0100c51 <runcmd>
c0100d64:	85 c0                	test   %eax,%eax
c0100d66:	78 02                	js     c0100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d68:	eb d3                	jmp    c0100d3d <kmonitor+0x33>
                break;
c0100d6a:	90                   	nop
            }
        }
    }
}
c0100d6b:	90                   	nop
c0100d6c:	c9                   	leave  
c0100d6d:	c3                   	ret    

c0100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d6e:	f3 0f 1e fb          	endbr32 
c0100d72:	55                   	push   %ebp
c0100d73:	89 e5                	mov    %esp,%ebp
c0100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d7f:	eb 3d                	jmp    c0100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d84:	89 d0                	mov    %edx,%eax
c0100d86:	01 c0                	add    %eax,%eax
c0100d88:	01 d0                	add    %edx,%eax
c0100d8a:	c1 e0 02             	shl    $0x2,%eax
c0100d8d:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d92:	8b 08                	mov    (%eax),%ecx
c0100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d97:	89 d0                	mov    %edx,%eax
c0100d99:	01 c0                	add    %eax,%eax
c0100d9b:	01 d0                	add    %edx,%eax
c0100d9d:	c1 e0 02             	shl    $0x2,%eax
c0100da0:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100da5:	8b 00                	mov    (%eax),%eax
c0100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100daf:	c7 04 24 51 62 10 c0 	movl   $0xc0106251,(%esp)
c0100db6:	e8 ff f4 ff ff       	call   c01002ba <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100dbb:	ff 45 f4             	incl   -0xc(%ebp)
c0100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dc1:	83 f8 02             	cmp    $0x2,%eax
c0100dc4:	76 bb                	jbe    c0100d81 <mon_help+0x13>
    }
    return 0;
c0100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dcb:	c9                   	leave  
c0100dcc:	c3                   	ret    

c0100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dcd:	f3 0f 1e fb          	endbr32 
c0100dd1:	55                   	push   %ebp
c0100dd2:	89 e5                	mov    %esp,%ebp
c0100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dd7:	e8 a1 fb ff ff       	call   c010097d <print_kerninfo>
    return 0;
c0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100de3:	f3 0f 1e fb          	endbr32 
c0100de7:	55                   	push   %ebp
c0100de8:	89 e5                	mov    %esp,%ebp
c0100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ded:	e8 dd fc ff ff       	call   c0100acf <print_stackframe>
    return 0;
c0100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df7:	c9                   	leave  
c0100df8:	c3                   	ret    

c0100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100df9:	f3 0f 1e fb          	endbr32 
c0100dfd:	55                   	push   %ebp
c0100dfe:	89 e5                	mov    %esp,%ebp
c0100e00:	83 ec 28             	sub    $0x28,%esp
c0100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e15:	ee                   	out    %al,(%dx)
}
c0100e16:	90                   	nop
c0100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e29:	ee                   	out    %al,(%dx)
}
c0100e2a:	90                   	nop
c0100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e3d:	ee                   	out    %al,(%dx)
}
c0100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e3f:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e49:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
c0100e50:	e8 65 f4 ff ff       	call   c01002ba <cprintf>
    pic_enable(IRQ_TIMER);
c0100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e5c:	e8 95 09 00 00       	call   c01017f6 <pic_enable>
}
c0100e61:	90                   	nop
c0100e62:	c9                   	leave  
c0100e63:	c3                   	ret    

c0100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e6a:	9c                   	pushf  
c0100e6b:	58                   	pop    %eax
c0100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e72:	25 00 02 00 00       	and    $0x200,%eax
c0100e77:	85 c0                	test   %eax,%eax
c0100e79:	74 0c                	je     c0100e87 <__intr_save+0x23>
        intr_disable();
c0100e7b:	e8 05 0b 00 00       	call   c0101985 <intr_disable>
        return 1;
c0100e80:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e85:	eb 05                	jmp    c0100e8c <__intr_save+0x28>
    }
    return 0;
c0100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e8e:	55                   	push   %ebp
c0100e8f:	89 e5                	mov    %esp,%ebp
c0100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e98:	74 05                	je     c0100e9f <__intr_restore+0x11>
        intr_enable();
c0100e9a:	e8 da 0a 00 00       	call   c0101979 <intr_enable>
    }
}
c0100e9f:	90                   	nop
c0100ea0:	c9                   	leave  
c0100ea1:	c3                   	ret    

c0100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100ea2:	f3 0f 1e fb          	endbr32 
c0100ea6:	55                   	push   %ebp
c0100ea7:	89 e5                	mov    %esp,%ebp
c0100ea9:	83 ec 10             	sub    $0x10,%esp
c0100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eb6:	89 c2                	mov    %eax,%edx
c0100eb8:	ec                   	in     (%dx),%al
c0100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ec6:	89 c2                	mov    %eax,%edx
c0100ec8:	ec                   	in     (%dx),%al
c0100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ed6:	89 c2                	mov    %eax,%edx
c0100ed8:	ec                   	in     (%dx),%al
c0100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ee6:	89 c2                	mov    %eax,%edx
c0100ee8:	ec                   	in     (%dx),%al
c0100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eec:	90                   	nop
c0100eed:	c9                   	leave  
c0100eee:	c3                   	ret    

c0100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eef:	f3 0f 1e fb          	endbr32 
c0100ef3:	55                   	push   %ebp
c0100ef4:	89 e5                	mov    %esp,%ebp
c0100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f03:	0f b7 00             	movzwl (%eax),%eax
c0100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f15:	0f b7 00             	movzwl (%eax),%eax
c0100f18:	0f b7 c0             	movzwl %ax,%eax
c0100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f20:	74 12                	je     c0100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f29:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f30:	b4 03 
c0100f32:	eb 13                	jmp    c0100f47 <cga_init+0x58>
    } else {
        *cp = was;
c0100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f3e:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f47:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f5e:	ee                   	out    %al,(%dx)
}
c0100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f60:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f67:	40                   	inc    %eax
c0100f68:	0f b7 c0             	movzwl %ax,%eax
c0100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f73:	89 c2                	mov    %eax,%edx
c0100f75:	ec                   	in     (%dx),%al
c0100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f7d:	0f b6 c0             	movzbl %al,%eax
c0100f80:	c1 e0 08             	shl    $0x8,%eax
c0100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f86:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
}
c0100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f9f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100fa6:	40                   	inc    %eax
c0100fa7:	0f b7 c0             	movzwl %ax,%eax
c0100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fb2:	89 c2                	mov    %eax,%edx
c0100fb4:	ec                   	in     (%dx),%al
c0100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fbc:	0f b6 c0             	movzbl %al,%eax
c0100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fc5:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fcd:	0f b7 c0             	movzwl %ax,%eax
c0100fd0:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100fd6:	90                   	nop
c0100fd7:	c9                   	leave  
c0100fd8:	c3                   	ret    

c0100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fd9:	f3 0f 1e fb          	endbr32 
c0100fdd:	55                   	push   %ebp
c0100fde:	89 e5                	mov    %esp,%ebp
c0100fe0:	83 ec 48             	sub    $0x48,%esp
c0100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100ff5:	ee                   	out    %al,(%dx)
}
c0100ff6:	90                   	nop
c0100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101009:	ee                   	out    %al,(%dx)
}
c010100a:	90                   	nop
c010100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010101d:	ee                   	out    %al,(%dx)
}
c010101e:	90                   	nop
c010101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101031:	ee                   	out    %al,(%dx)
}
c0101032:	90                   	nop
c0101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101045:	ee                   	out    %al,(%dx)
}
c0101046:	90                   	nop
c0101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101059:	ee                   	out    %al,(%dx)
}
c010105a:	90                   	nop
c010105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010106d:	ee                   	out    %al,(%dx)
}
c010106e:	90                   	nop
c010106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101079:	89 c2                	mov    %eax,%edx
c010107b:	ec                   	in     (%dx),%al
c010107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101083:	3c ff                	cmp    $0xff,%al
c0101085:	0f 95 c0             	setne  %al
c0101088:	0f b6 c0             	movzbl %al,%eax
c010108b:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c0101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010109a:	89 c2                	mov    %eax,%edx
c010109c:	ec                   	in     (%dx),%al
c010109d:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010aa:	89 c2                	mov    %eax,%edx
c01010ac:	ec                   	in     (%dx),%al
c01010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010b0:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010b5:	85 c0                	test   %eax,%eax
c01010b7:	74 0c                	je     c01010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010c0:	e8 31 07 00 00       	call   c01017f6 <pic_enable>
    }
}
c01010c5:	90                   	nop
c01010c6:	c9                   	leave  
c01010c7:	c3                   	ret    

c01010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010c8:	f3 0f 1e fb          	endbr32 
c01010cc:	55                   	push   %ebp
c01010cd:	89 e5                	mov    %esp,%ebp
c01010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010d9:	eb 08                	jmp    c01010e3 <lpt_putc_sub+0x1b>
        delay();
c01010db:	e8 c2 fd ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010e0:	ff 45 fc             	incl   -0x4(%ebp)
c01010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010ed:	89 c2                	mov    %eax,%edx
c01010ef:	ec                   	in     (%dx),%al
c01010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010f7:	84 c0                	test   %al,%al
c01010f9:	78 09                	js     c0101104 <lpt_putc_sub+0x3c>
c01010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101102:	7e d7                	jle    c01010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c0101104:	8b 45 08             	mov    0x8(%ebp),%eax
c0101107:	0f b6 c0             	movzbl %al,%eax
c010110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010111b:	ee                   	out    %al,(%dx)
}
c010111c:	90                   	nop
c010111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010112f:	ee                   	out    %al,(%dx)
}
c0101130:	90                   	nop
c0101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101143:	ee                   	out    %al,(%dx)
}
c0101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101145:	90                   	nop
c0101146:	c9                   	leave  
c0101147:	c3                   	ret    

c0101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101148:	f3 0f 1e fb          	endbr32 
c010114c:	55                   	push   %ebp
c010114d:	89 e5                	mov    %esp,%ebp
c010114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101156:	74 0d                	je     c0101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101158:	8b 45 08             	mov    0x8(%ebp),%eax
c010115b:	89 04 24             	mov    %eax,(%esp)
c010115e:	e8 65 ff ff ff       	call   c01010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101163:	eb 24                	jmp    c0101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c0101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010116c:	e8 57 ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101178:	e8 4b ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101184:	e8 3f ff ff ff       	call   c01010c8 <lpt_putc_sub>
}
c0101189:	90                   	nop
c010118a:	c9                   	leave  
c010118b:	c3                   	ret    

c010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010118c:	f3 0f 1e fb          	endbr32 
c0101190:	55                   	push   %ebp
c0101191:	89 e5                	mov    %esp,%ebp
c0101193:	53                   	push   %ebx
c0101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101197:	8b 45 08             	mov    0x8(%ebp),%eax
c010119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010119f:	85 c0                	test   %eax,%eax
c01011a1:	75 07                	jne    c01011aa <cga_putc+0x1e>
        c |= 0x0700;
c01011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ad:	0f b6 c0             	movzbl %al,%eax
c01011b0:	83 f8 0d             	cmp    $0xd,%eax
c01011b3:	74 72                	je     c0101227 <cga_putc+0x9b>
c01011b5:	83 f8 0d             	cmp    $0xd,%eax
c01011b8:	0f 8f a3 00 00 00    	jg     c0101261 <cga_putc+0xd5>
c01011be:	83 f8 08             	cmp    $0x8,%eax
c01011c1:	74 0a                	je     c01011cd <cga_putc+0x41>
c01011c3:	83 f8 0a             	cmp    $0xa,%eax
c01011c6:	74 4c                	je     c0101214 <cga_putc+0x88>
c01011c8:	e9 94 00 00 00       	jmp    c0101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011cd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011d4:	85 c0                	test   %eax,%eax
c01011d6:	0f 84 af 00 00 00    	je     c010128b <cga_putc+0xff>
            crt_pos --;
c01011dc:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011e3:	48                   	dec    %eax
c01011e4:	0f b7 c0             	movzwl %ax,%eax
c01011e7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f0:	98                   	cwtl   
c01011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011f6:	98                   	cwtl   
c01011f7:	83 c8 20             	or     $0x20,%eax
c01011fa:	98                   	cwtl   
c01011fb:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c0101201:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101208:	01 c9                	add    %ecx,%ecx
c010120a:	01 ca                	add    %ecx,%edx
c010120c:	0f b7 c0             	movzwl %ax,%eax
c010120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101212:	eb 77                	jmp    c010128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c0101214:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010121b:	83 c0 50             	add    $0x50,%eax
c010121e:	0f b7 c0             	movzwl %ax,%eax
c0101221:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101227:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c010122e:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010123a:	89 c8                	mov    %ecx,%eax
c010123c:	f7 e2                	mul    %edx
c010123e:	c1 ea 06             	shr    $0x6,%edx
c0101241:	89 d0                	mov    %edx,%eax
c0101243:	c1 e0 02             	shl    $0x2,%eax
c0101246:	01 d0                	add    %edx,%eax
c0101248:	c1 e0 04             	shl    $0x4,%eax
c010124b:	29 c1                	sub    %eax,%ecx
c010124d:	89 c8                	mov    %ecx,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	29 c3                	sub    %eax,%ebx
c0101254:	89 d8                	mov    %ebx,%eax
c0101256:	0f b7 c0             	movzwl %ax,%eax
c0101259:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c010125f:	eb 2b                	jmp    c010128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101261:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101267:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010126e:	8d 50 01             	lea    0x1(%eax),%edx
c0101271:	0f b7 d2             	movzwl %dx,%edx
c0101274:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c010127b:	01 c0                	add    %eax,%eax
c010127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101280:	8b 45 08             	mov    0x8(%ebp),%eax
c0101283:	0f b7 c0             	movzwl %ax,%eax
c0101286:	66 89 02             	mov    %ax,(%edx)
        break;
c0101289:	eb 01                	jmp    c010128c <cga_putc+0x100>
        break;
c010128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010128c:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101298:	76 5d                	jbe    c01012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010129a:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c010129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012a5:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012b1:	00 
c01012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012b6:	89 04 24             	mov    %eax,(%esp)
c01012b9:	e8 9d 44 00 00       	call   c010575b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012c5:	eb 14                	jmp    c01012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012c7:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cf:	01 d2                	add    %edx,%edx
c01012d1:	01 d0                	add    %edx,%eax
c01012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012d8:	ff 45 f4             	incl   -0xc(%ebp)
c01012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012e2:	7e e3                	jle    c01012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012e4:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012eb:	83 e8 50             	sub    $0x50,%eax
c01012ee:	0f b7 c0             	movzwl %ax,%eax
c01012f1:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012f7:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010130e:	ee                   	out    %al,(%dx)
}
c010130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101310:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101317:	c1 e8 08             	shr    $0x8,%eax
c010131a:	0f b7 c0             	movzwl %ax,%eax
c010131d:	0f b6 c0             	movzbl %al,%eax
c0101320:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101327:	42                   	inc    %edx
c0101328:	0f b7 d2             	movzwl %dx,%edx
c010132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010133a:	ee                   	out    %al,(%dx)
}
c010133b:	90                   	nop
    outb(addr_6845, 15);
c010133c:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101353:	ee                   	out    %al,(%dx)
}
c0101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101355:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010135c:	0f b6 c0             	movzbl %al,%eax
c010135f:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101366:	42                   	inc    %edx
c0101367:	0f b7 d2             	movzwl %dx,%edx
c010136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101379:	ee                   	out    %al,(%dx)
}
c010137a:	90                   	nop
}
c010137b:	90                   	nop
c010137c:	83 c4 34             	add    $0x34,%esp
c010137f:	5b                   	pop    %ebx
c0101380:	5d                   	pop    %ebp
c0101381:	c3                   	ret    

c0101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101382:	f3 0f 1e fb          	endbr32 
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101393:	eb 08                	jmp    c010139d <serial_putc_sub+0x1b>
        delay();
c0101395:	e8 08 fb ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010139a:	ff 45 fc             	incl   -0x4(%ebp)
c010139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a7:	89 c2                	mov    %eax,%edx
c01013a9:	ec                   	in     (%dx),%al
c01013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013b1:	0f b6 c0             	movzbl %al,%eax
c01013b4:	83 e0 20             	and    $0x20,%eax
c01013b7:	85 c0                	test   %eax,%eax
c01013b9:	75 09                	jne    c01013c4 <serial_putc_sub+0x42>
c01013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013c2:	7e d1                	jle    c0101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c7:	0f b6 c0             	movzbl %al,%eax
c01013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013db:	ee                   	out    %al,(%dx)
}
c01013dc:	90                   	nop
}
c01013dd:	90                   	nop
c01013de:	c9                   	leave  
c01013df:	c3                   	ret    

c01013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013e0:	f3 0f 1e fb          	endbr32 
c01013e4:	55                   	push   %ebp
c01013e5:	89 e5                	mov    %esp,%ebp
c01013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013ee:	74 0d                	je     c01013fd <serial_putc+0x1d>
        serial_putc_sub(c);
c01013f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f3:	89 04 24             	mov    %eax,(%esp)
c01013f6:	e8 87 ff ff ff       	call   c0101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013fb:	eb 24                	jmp    c0101421 <serial_putc+0x41>
        serial_putc_sub('\b');
c01013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101404:	e8 79 ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub(' ');
c0101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101410:	e8 6d ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub('\b');
c0101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010141c:	e8 61 ff ff ff       	call   c0101382 <serial_putc_sub>
}
c0101421:	90                   	nop
c0101422:	c9                   	leave  
c0101423:	c3                   	ret    

c0101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101424:	f3 0f 1e fb          	endbr32 
c0101428:	55                   	push   %ebp
c0101429:	89 e5                	mov    %esp,%ebp
c010142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010142e:	eb 33                	jmp    c0101463 <cons_intr+0x3f>
        if (c != 0) {
c0101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101434:	74 2d                	je     c0101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c0101436:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010143b:	8d 50 01             	lea    0x1(%eax),%edx
c010143e:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c0101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101447:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010144d:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101452:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101457:	75 0a                	jne    c0101463 <cons_intr+0x3f>
                cons.wpos = 0;
c0101459:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101463:	8b 45 08             	mov    0x8(%ebp),%eax
c0101466:	ff d0                	call   *%eax
c0101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010146f:	75 bf                	jne    c0101430 <cons_intr+0xc>
            }
        }
    }
}
c0101471:	90                   	nop
c0101472:	90                   	nop
c0101473:	c9                   	leave  
c0101474:	c3                   	ret    

c0101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101475:	f3 0f 1e fb          	endbr32 
c0101479:	55                   	push   %ebp
c010147a:	89 e5                	mov    %esp,%ebp
c010147c:	83 ec 10             	sub    $0x10,%esp
c010147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101489:	89 c2                	mov    %eax,%edx
c010148b:	ec                   	in     (%dx),%al
c010148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101493:	0f b6 c0             	movzbl %al,%eax
c0101496:	83 e0 01             	and    $0x1,%eax
c0101499:	85 c0                	test   %eax,%eax
c010149b:	75 07                	jne    c01014a4 <serial_proc_data+0x2f>
        return -1;
c010149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014a2:	eb 2a                	jmp    c01014ce <serial_proc_data+0x59>
c01014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014ae:	89 c2                	mov    %eax,%edx
c01014b0:	ec                   	in     (%dx),%al
c01014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014b8:	0f b6 c0             	movzbl %al,%eax
c01014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014c2:	75 07                	jne    c01014cb <serial_proc_data+0x56>
        c = '\b';
c01014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014ce:	c9                   	leave  
c01014cf:	c3                   	ret    

c01014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014d0:	f3 0f 1e fb          	endbr32 
c01014d4:	55                   	push   %ebp
c01014d5:	89 e5                	mov    %esp,%ebp
c01014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014da:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014df:	85 c0                	test   %eax,%eax
c01014e1:	74 0c                	je     c01014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014e3:	c7 04 24 75 14 10 c0 	movl   $0xc0101475,(%esp)
c01014ea:	e8 35 ff ff ff       	call   c0101424 <cons_intr>
    }
}
c01014ef:	90                   	nop
c01014f0:	c9                   	leave  
c01014f1:	c3                   	ret    

c01014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014f2:	f3 0f 1e fb          	endbr32 
c01014f6:	55                   	push   %ebp
c01014f7:	89 e5                	mov    %esp,%ebp
c01014f9:	83 ec 38             	sub    $0x38,%esp
c01014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101505:	89 c2                	mov    %eax,%edx
c0101507:	ec                   	in     (%dx),%al
c0101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010150f:	0f b6 c0             	movzbl %al,%eax
c0101512:	83 e0 01             	and    $0x1,%eax
c0101515:	85 c0                	test   %eax,%eax
c0101517:	75 0a                	jne    c0101523 <kbd_proc_data+0x31>
        return -1;
c0101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010151e:	e9 56 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
c0101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010152c:	89 c2                	mov    %eax,%edx
c010152e:	ec                   	in     (%dx),%al
c010152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010153d:	75 17                	jne    c0101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c010153f:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101544:	83 c8 40             	or     $0x40,%eax
c0101547:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c010154c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101551:	e9 23 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155a:	84 c0                	test   %al,%al
c010155c:	79 45                	jns    c01015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010155e:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101563:	83 e0 40             	and    $0x40,%eax
c0101566:	85 c0                	test   %eax,%eax
c0101568:	75 08                	jne    c0101572 <kbd_proc_data+0x80>
c010156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156e:	24 7f                	and    $0x7f,%al
c0101570:	eb 04                	jmp    c0101576 <kbd_proc_data+0x84>
c0101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157d:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101584:	0c 40                	or     $0x40,%al
c0101586:	0f b6 c0             	movzbl %al,%eax
c0101589:	f7 d0                	not    %eax
c010158b:	89 c2                	mov    %eax,%edx
c010158d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101592:	21 d0                	and    %edx,%eax
c0101594:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101599:	b8 00 00 00 00       	mov    $0x0,%eax
c010159e:	e9 d6 00 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015a3:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015a8:	83 e0 40             	and    $0x40,%eax
c01015ab:	85 c0                	test   %eax,%eax
c01015ad:	74 11                	je     c01015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015b3:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b8:	83 e0 bf             	and    $0xffffffbf,%eax
c01015bb:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c01015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c4:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015cb:	0f b6 d0             	movzbl %al,%edx
c01015ce:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015d3:	09 d0                	or     %edx,%eax
c01015d5:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c01015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015de:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015e5:	0f b6 d0             	movzbl %al,%edx
c01015e8:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015ed:	31 d0                	xor    %edx,%eax
c01015ef:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015f4:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015f9:	83 e0 03             	and    $0x3,%eax
c01015fc:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c0101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101607:	01 d0                	add    %edx,%eax
c0101609:	0f b6 00             	movzbl (%eax),%eax
c010160c:	0f b6 c0             	movzbl %al,%eax
c010160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101612:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101617:	83 e0 08             	and    $0x8,%eax
c010161a:	85 c0                	test   %eax,%eax
c010161c:	74 22                	je     c0101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101622:	7e 0c                	jle    c0101630 <kbd_proc_data+0x13e>
c0101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101628:	7f 06                	jg     c0101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010162e:	eb 10                	jmp    c0101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101634:	7e 0a                	jle    c0101640 <kbd_proc_data+0x14e>
c0101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010163a:	7f 04                	jg     c0101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101640:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101645:	f7 d0                	not    %eax
c0101647:	83 e0 06             	and    $0x6,%eax
c010164a:	85 c0                	test   %eax,%eax
c010164c:	75 28                	jne    c0101676 <kbd_proc_data+0x184>
c010164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101655:	75 1f                	jne    c0101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101657:	c7 04 24 75 62 10 c0 	movl   $0xc0106275,(%esp)
c010165e:	e8 57 ec ff ff       	call   c01002ba <cprintf>
c0101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101674:	ee                   	out    %al,(%dx)
}
c0101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101679:	c9                   	leave  
c010167a:	c3                   	ret    

c010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010167b:	f3 0f 1e fb          	endbr32 
c010167f:	55                   	push   %ebp
c0101680:	89 e5                	mov    %esp,%ebp
c0101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101685:	c7 04 24 f2 14 10 c0 	movl   $0xc01014f2,(%esp)
c010168c:	e8 93 fd ff ff       	call   c0101424 <cons_intr>
}
c0101691:	90                   	nop
c0101692:	c9                   	leave  
c0101693:	c3                   	ret    

c0101694 <kbd_init>:

static void
kbd_init(void) {
c0101694:	f3 0f 1e fb          	endbr32 
c0101698:	55                   	push   %ebp
c0101699:	89 e5                	mov    %esp,%ebp
c010169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010169e:	e8 d8 ff ff ff       	call   c010167b <kbd_intr>
    pic_enable(IRQ_KBD);
c01016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016aa:	e8 47 01 00 00       	call   c01017f6 <pic_enable>
}
c01016af:	90                   	nop
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016b2:	f3 0f 1e fb          	endbr32 
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016bc:	e8 2e f8 ff ff       	call   c0100eef <cga_init>
    serial_init();
c01016c1:	e8 13 f9 ff ff       	call   c0100fd9 <serial_init>
    kbd_init();
c01016c6:	e8 c9 ff ff ff       	call   c0101694 <kbd_init>
    if (!serial_exists) {
c01016cb:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016d0:	85 c0                	test   %eax,%eax
c01016d2:	75 0c                	jne    c01016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016d4:	c7 04 24 81 62 10 c0 	movl   $0xc0106281,(%esp)
c01016db:	e8 da eb ff ff       	call   c01002ba <cprintf>
    }
}
c01016e0:	90                   	nop
c01016e1:	c9                   	leave  
c01016e2:	c3                   	ret    

c01016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016e3:	f3 0f 1e fb          	endbr32 
c01016e7:	55                   	push   %ebp
c01016e8:	89 e5                	mov    %esp,%ebp
c01016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016ed:	e8 72 f7 ff ff       	call   c0100e64 <__intr_save>
c01016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f8:	89 04 24             	mov    %eax,(%esp)
c01016fb:	e8 48 fa ff ff       	call   c0101148 <lpt_putc>
        cga_putc(c);
c0101700:	8b 45 08             	mov    0x8(%ebp),%eax
c0101703:	89 04 24             	mov    %eax,(%esp)
c0101706:	e8 81 fa ff ff       	call   c010118c <cga_putc>
        serial_putc(c);
c010170b:	8b 45 08             	mov    0x8(%ebp),%eax
c010170e:	89 04 24             	mov    %eax,(%esp)
c0101711:	e8 ca fc ff ff       	call   c01013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101719:	89 04 24             	mov    %eax,(%esp)
c010171c:	e8 6d f7 ff ff       	call   c0100e8e <__intr_restore>
}
c0101721:	90                   	nop
c0101722:	c9                   	leave  
c0101723:	c3                   	ret    

c0101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101724:	f3 0f 1e fb          	endbr32 
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
c010172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101735:	e8 2a f7 ff ff       	call   c0100e64 <__intr_save>
c010173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010173d:	e8 8e fd ff ff       	call   c01014d0 <serial_intr>
        kbd_intr();
c0101742:	e8 34 ff ff ff       	call   c010167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101747:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c010174d:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101752:	39 c2                	cmp    %eax,%edx
c0101754:	74 31                	je     c0101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c0101756:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010175b:	8d 50 01             	lea    0x1(%eax),%edx
c010175e:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c0101764:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c010176b:	0f b6 c0             	movzbl %al,%eax
c010176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101771:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101776:	3d 00 02 00 00       	cmp    $0x200,%eax
c010177b:	75 0a                	jne    c0101787 <cons_getc+0x63>
                cons.rpos = 0;
c010177d:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c0101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010178a:	89 04 24             	mov    %eax,(%esp)
c010178d:	e8 fc f6 ff ff       	call   c0100e8e <__intr_restore>
    return c;
c0101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101795:	c9                   	leave  
c0101796:	c3                   	ret    

c0101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101797:	f3 0f 1e fb          	endbr32 
c010179b:	55                   	push   %ebp
c010179c:	89 e5                	mov    %esp,%ebp
c010179e:	83 ec 14             	sub    $0x14,%esp
c01017a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017ab:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017b1:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017b6:	85 c0                	test   %eax,%eax
c01017b8:	74 39                	je     c01017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017bd:	0f b6 c0             	movzbl %al,%eax
c01017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017d1:	ee                   	out    %al,(%dx)
}
c01017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d7:	c1 e8 08             	shr    $0x8,%eax
c01017da:	0f b7 c0             	movzwl %ax,%eax
c01017dd:	0f b6 c0             	movzbl %al,%eax
c01017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017f1:	ee                   	out    %al,(%dx)
}
c01017f2:	90                   	nop
    }
}
c01017f3:	90                   	nop
c01017f4:	c9                   	leave  
c01017f5:	c3                   	ret    

c01017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017f6:	f3 0f 1e fb          	endbr32 
c01017fa:	55                   	push   %ebp
c01017fb:	89 e5                	mov    %esp,%ebp
c01017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101800:	8b 45 08             	mov    0x8(%ebp),%eax
c0101803:	ba 01 00 00 00       	mov    $0x1,%edx
c0101808:	88 c1                	mov    %al,%cl
c010180a:	d3 e2                	shl    %cl,%edx
c010180c:	89 d0                	mov    %edx,%eax
c010180e:	98                   	cwtl   
c010180f:	f7 d0                	not    %eax
c0101811:	0f bf d0             	movswl %ax,%edx
c0101814:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010181b:	98                   	cwtl   
c010181c:	21 d0                	and    %edx,%eax
c010181e:	98                   	cwtl   
c010181f:	0f b7 c0             	movzwl %ax,%eax
c0101822:	89 04 24             	mov    %eax,(%esp)
c0101825:	e8 6d ff ff ff       	call   c0101797 <pic_setmask>
}
c010182a:	90                   	nop
c010182b:	c9                   	leave  
c010182c:	c3                   	ret    

c010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010182d:	f3 0f 1e fb          	endbr32 
c0101831:	55                   	push   %ebp
c0101832:	89 e5                	mov    %esp,%ebp
c0101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101837:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c010183e:	00 00 00 
c0101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
}
c0101854:	90                   	nop
c0101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101867:	ee                   	out    %al,(%dx)
}
c0101868:	90                   	nop
c0101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
}
c010187c:	90                   	nop
c010187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010188f:	ee                   	out    %al,(%dx)
}
c0101890:	90                   	nop
c0101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018a3:	ee                   	out    %al,(%dx)
}
c01018a4:	90                   	nop
c01018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018b7:	ee                   	out    %al,(%dx)
}
c01018b8:	90                   	nop
c01018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018cb:	ee                   	out    %al,(%dx)
}
c01018cc:	90                   	nop
c01018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018df:	ee                   	out    %al,(%dx)
}
c01018e0:	90                   	nop
c01018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018f3:	ee                   	out    %al,(%dx)
}
c01018f4:	90                   	nop
c01018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101907:	ee                   	out    %al,(%dx)
}
c0101908:	90                   	nop
c0101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010191b:	ee                   	out    %al,(%dx)
}
c010191c:	90                   	nop
c010191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010192f:	ee                   	out    %al,(%dx)
}
c0101930:	90                   	nop
c0101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101943:	ee                   	out    %al,(%dx)
}
c0101944:	90                   	nop
c0101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101957:	ee                   	out    %al,(%dx)
}
c0101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101959:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101965:	74 0f                	je     c0101976 <pic_init+0x149>
        pic_setmask(irq_mask);
c0101967:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010196e:	89 04 24             	mov    %eax,(%esp)
c0101971:	e8 21 fe ff ff       	call   c0101797 <pic_setmask>
    }
}
c0101976:	90                   	nop
c0101977:	c9                   	leave  
c0101978:	c3                   	ret    

c0101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101979:	f3 0f 1e fb          	endbr32 
c010197d:	55                   	push   %ebp
c010197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101980:	fb                   	sti    
}
c0101981:	90                   	nop
    sti();
}
c0101982:	90                   	nop
c0101983:	5d                   	pop    %ebp
c0101984:	c3                   	ret    

c0101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101985:	f3 0f 1e fb          	endbr32 
c0101989:	55                   	push   %ebp
c010198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010198c:	fa                   	cli    
}
c010198d:	90                   	nop
    cli();
}
c010198e:	90                   	nop
c010198f:	5d                   	pop    %ebp
c0101990:	c3                   	ret    

c0101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101991:	f3 0f 1e fb          	endbr32 
c0101995:	55                   	push   %ebp
c0101996:	89 e5                	mov    %esp,%ebp
c0101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01019a2:	00 
c01019a3:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c01019aa:	e8 0b e9 ff ff       	call   c01002ba <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01019af:	90                   	nop
c01019b0:	c9                   	leave  
c01019b1:	c3                   	ret    

c01019b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019b2:	f3 0f 1e fb          	endbr32 
c01019b6:	55                   	push   %ebp
c01019b7:	89 e5                	mov    %esp,%ebp
c01019b9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    //修正，这里面的256，应该是要idt的大小除以gatedesc的大小来判断有多少个段描述符
    for(int i=0 ; i< sizeof(idt)/sizeof(struct gatedesc) ; ++i){
c01019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019c3:	e9 c4 00 00 00       	jmp    c0101a8c <idt_init+0xda>
        SETGATE(idt[i],0,KERNEL_CS,__vectors[i],DPL_KERNEL);
c01019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cb:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019d2:	0f b7 d0             	movzwl %ax,%edx
c01019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d8:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019df:	c0 
c01019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e3:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c01019ea:	c0 08 00 
c01019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f0:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019f7:	c0 
c01019f8:	80 e2 e0             	and    $0xe0,%dl
c01019fb:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a05:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a0c:	c0 
c0101a0d:	80 e2 1f             	and    $0x1f,%dl
c0101a10:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1a:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a21:	c0 
c0101a22:	80 e2 f0             	and    $0xf0,%dl
c0101a25:	80 ca 0e             	or     $0xe,%dl
c0101a28:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a39:	c0 
c0101a3a:	80 e2 ef             	and    $0xef,%dl
c0101a3d:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a47:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a4e:	c0 
c0101a4f:	80 e2 9f             	and    $0x9f,%dl
c0101a52:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5c:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a63:	c0 
c0101a64:	80 ca 80             	or     $0x80,%dl
c0101a67:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a71:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a78:	c1 e8 10             	shr    $0x10,%eax
c0101a7b:	0f b7 d0             	movzwl %ax,%edx
c0101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a81:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a88:	c0 
    for(int i=0 ; i< sizeof(idt)/sizeof(struct gatedesc) ; ++i){
c0101a89:	ff 45 fc             	incl   -0x4(%ebp)
c0101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a94:	0f 86 2e ff ff ff    	jbe    c01019c8 <idt_init+0x16>
c0101a9a:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101aa4:	0f 01 18             	lidtl  (%eax)
}
c0101aa7:	90                   	nop
    }
    //修正，这边加了一句对switch的更改，但是在任务中，我觉得没有表现出来
    //SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
    lidt(&idt_pd);
}
c0101aa8:	90                   	nop
c0101aa9:	c9                   	leave  
c0101aaa:	c3                   	ret    

c0101aab <trapname>:

static const char *
trapname(int trapno) {
c0101aab:	f3 0f 1e fb          	endbr32 
c0101aaf:	55                   	push   %ebp
c0101ab0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	83 f8 13             	cmp    $0x13,%eax
c0101ab8:	77 0c                	ja     c0101ac6 <trapname+0x1b>
        return excnames[trapno];
c0101aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abd:	8b 04 85 00 66 10 c0 	mov    -0x3fef9a00(,%eax,4),%eax
c0101ac4:	eb 18                	jmp    c0101ade <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ac6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101aca:	7e 0d                	jle    c0101ad9 <trapname+0x2e>
c0101acc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ad0:	7f 07                	jg     c0101ad9 <trapname+0x2e>
        return "Hardware Interrupt";
c0101ad2:	b8 aa 62 10 c0       	mov    $0xc01062aa,%eax
c0101ad7:	eb 05                	jmp    c0101ade <trapname+0x33>
    }
    return "(unknown trap)";
c0101ad9:	b8 bd 62 10 c0       	mov    $0xc01062bd,%eax
}
c0101ade:	5d                   	pop    %ebp
c0101adf:	c3                   	ret    

c0101ae0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ae0:	f3 0f 1e fb          	endbr32 
c0101ae4:	55                   	push   %ebp
c0101ae5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101aee:	83 f8 08             	cmp    $0x8,%eax
c0101af1:	0f 94 c0             	sete   %al
c0101af4:	0f b6 c0             	movzbl %al,%eax
}
c0101af7:	5d                   	pop    %ebp
c0101af8:	c3                   	ret    

c0101af9 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101af9:	f3 0f 1e fb          	endbr32 
c0101afd:	55                   	push   %ebp
c0101afe:	89 e5                	mov    %esp,%ebp
c0101b00:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0a:	c7 04 24 fe 62 10 c0 	movl   $0xc01062fe,(%esp)
c0101b11:	e8 a4 e7 ff ff       	call   c01002ba <cprintf>
    print_regs(&tf->tf_regs);
c0101b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b19:	89 04 24             	mov    %eax,(%esp)
c0101b1c:	e8 8d 01 00 00       	call   c0101cae <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2c:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c0101b33:	e8 82 e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b43:	c7 04 24 22 63 10 c0 	movl   $0xc0106322,(%esp)
c0101b4a:	e8 6b e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b52:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5a:	c7 04 24 35 63 10 c0 	movl   $0xc0106335,(%esp)
c0101b61:	e8 54 e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b71:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0101b78:	e8 3d e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b80:	8b 40 30             	mov    0x30(%eax),%eax
c0101b83:	89 04 24             	mov    %eax,(%esp)
c0101b86:	e8 20 ff ff ff       	call   c0101aab <trapname>
c0101b8b:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b8e:	8b 52 30             	mov    0x30(%edx),%edx
c0101b91:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b95:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b99:	c7 04 24 5b 63 10 c0 	movl   $0xc010635b,(%esp)
c0101ba0:	e8 15 e7 ff ff       	call   c01002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	8b 40 34             	mov    0x34(%eax),%eax
c0101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101baf:	c7 04 24 6d 63 10 c0 	movl   $0xc010636d,(%esp)
c0101bb6:	e8 ff e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 40 38             	mov    0x38(%eax),%eax
c0101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc5:	c7 04 24 7c 63 10 c0 	movl   $0xc010637c,(%esp)
c0101bcc:	e8 e9 e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 8b 63 10 c0 	movl   $0xc010638b,(%esp)
c0101be3:	e8 d2 e6 ff ff       	call   c01002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 40             	mov    0x40(%eax),%eax
c0101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf2:	c7 04 24 9e 63 10 c0 	movl   $0xc010639e,(%esp)
c0101bf9:	e8 bc e6 ff ff       	call   c01002ba <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c0c:	eb 3d                	jmp    c0101c4b <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c11:	8b 50 40             	mov    0x40(%eax),%edx
c0101c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c17:	21 d0                	and    %edx,%eax
c0101c19:	85 c0                	test   %eax,%eax
c0101c1b:	74 28                	je     c0101c45 <print_trapframe+0x14c>
c0101c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c20:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c27:	85 c0                	test   %eax,%eax
c0101c29:	74 1a                	je     c0101c45 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c2e:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c39:	c7 04 24 ad 63 10 c0 	movl   $0xc01063ad,(%esp)
c0101c40:	e8 75 e6 ff ff       	call   c01002ba <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c45:	ff 45 f4             	incl   -0xc(%ebp)
c0101c48:	d1 65 f0             	shll   -0x10(%ebp)
c0101c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c4e:	83 f8 17             	cmp    $0x17,%eax
c0101c51:	76 bb                	jbe    c0101c0e <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c56:	8b 40 40             	mov    0x40(%eax),%eax
c0101c59:	c1 e8 0c             	shr    $0xc,%eax
c0101c5c:	83 e0 03             	and    $0x3,%eax
c0101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c63:	c7 04 24 b1 63 10 c0 	movl   $0xc01063b1,(%esp)
c0101c6a:	e8 4b e6 ff ff       	call   c01002ba <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c72:	89 04 24             	mov    %eax,(%esp)
c0101c75:	e8 66 fe ff ff       	call   c0101ae0 <trap_in_kernel>
c0101c7a:	85 c0                	test   %eax,%eax
c0101c7c:	75 2d                	jne    c0101cab <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c81:	8b 40 44             	mov    0x44(%eax),%eax
c0101c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c88:	c7 04 24 ba 63 10 c0 	movl   $0xc01063ba,(%esp)
c0101c8f:	e8 26 e6 ff ff       	call   c01002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9f:	c7 04 24 c9 63 10 c0 	movl   $0xc01063c9,(%esp)
c0101ca6:	e8 0f e6 ff ff       	call   c01002ba <cprintf>
    }
}
c0101cab:	90                   	nop
c0101cac:	c9                   	leave  
c0101cad:	c3                   	ret    

c0101cae <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cae:	f3 0f 1e fb          	endbr32 
c0101cb2:	55                   	push   %ebp
c0101cb3:	89 e5                	mov    %esp,%ebp
c0101cb5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbb:	8b 00                	mov    (%eax),%eax
c0101cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc1:	c7 04 24 dc 63 10 c0 	movl   $0xc01063dc,(%esp)
c0101cc8:	e8 ed e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd0:	8b 40 04             	mov    0x4(%eax),%eax
c0101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd7:	c7 04 24 eb 63 10 c0 	movl   $0xc01063eb,(%esp)
c0101cde:	e8 d7 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce6:	8b 40 08             	mov    0x8(%eax),%eax
c0101ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ced:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101cf4:	e8 c1 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfc:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d03:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101d0a:	e8 ab e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d12:	8b 40 10             	mov    0x10(%eax),%eax
c0101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d19:	c7 04 24 18 64 10 c0 	movl   $0xc0106418,(%esp)
c0101d20:	e8 95 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d28:	8b 40 14             	mov    0x14(%eax),%eax
c0101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d2f:	c7 04 24 27 64 10 c0 	movl   $0xc0106427,(%esp)
c0101d36:	e8 7f e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3e:	8b 40 18             	mov    0x18(%eax),%eax
c0101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d45:	c7 04 24 36 64 10 c0 	movl   $0xc0106436,(%esp)
c0101d4c:	e8 69 e5 ff ff       	call   c01002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d54:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5b:	c7 04 24 45 64 10 c0 	movl   $0xc0106445,(%esp)
c0101d62:	e8 53 e5 ff ff       	call   c01002ba <cprintf>
}
c0101d67:	90                   	nop
c0101d68:	c9                   	leave  
c0101d69:	c3                   	ret    

c0101d6a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d6a:	f3 0f 1e fb          	endbr32 
c0101d6e:	55                   	push   %ebp
c0101d6f:	89 e5                	mov    %esp,%ebp
c0101d71:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d77:	8b 40 30             	mov    0x30(%eax),%eax
c0101d7a:	83 f8 79             	cmp    $0x79,%eax
c0101d7d:	0f 87 e6 00 00 00    	ja     c0101e69 <trap_dispatch+0xff>
c0101d83:	83 f8 78             	cmp    $0x78,%eax
c0101d86:	0f 83 c1 00 00 00    	jae    c0101e4d <trap_dispatch+0xe3>
c0101d8c:	83 f8 2f             	cmp    $0x2f,%eax
c0101d8f:	0f 87 d4 00 00 00    	ja     c0101e69 <trap_dispatch+0xff>
c0101d95:	83 f8 2e             	cmp    $0x2e,%eax
c0101d98:	0f 83 00 01 00 00    	jae    c0101e9e <trap_dispatch+0x134>
c0101d9e:	83 f8 24             	cmp    $0x24,%eax
c0101da1:	74 5e                	je     c0101e01 <trap_dispatch+0x97>
c0101da3:	83 f8 24             	cmp    $0x24,%eax
c0101da6:	0f 87 bd 00 00 00    	ja     c0101e69 <trap_dispatch+0xff>
c0101dac:	83 f8 20             	cmp    $0x20,%eax
c0101daf:	74 0a                	je     c0101dbb <trap_dispatch+0x51>
c0101db1:	83 f8 21             	cmp    $0x21,%eax
c0101db4:	74 71                	je     c0101e27 <trap_dispatch+0xbd>
c0101db6:	e9 ae 00 00 00       	jmp    c0101e69 <trap_dispatch+0xff>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101dbb:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101dc0:	40                   	inc    %eax
c0101dc1:	a3 0c cf 11 c0       	mov    %eax,0xc011cf0c
        if(ticks%TICK_NUM==0)
c0101dc6:	8b 0d 0c cf 11 c0    	mov    0xc011cf0c,%ecx
c0101dcc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101dd1:	89 c8                	mov    %ecx,%eax
c0101dd3:	f7 e2                	mul    %edx
c0101dd5:	c1 ea 05             	shr    $0x5,%edx
c0101dd8:	89 d0                	mov    %edx,%eax
c0101dda:	c1 e0 02             	shl    $0x2,%eax
c0101ddd:	01 d0                	add    %edx,%eax
c0101ddf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101de6:	01 d0                	add    %edx,%eax
c0101de8:	c1 e0 02             	shl    $0x2,%eax
c0101deb:	29 c1                	sub    %eax,%ecx
c0101ded:	89 ca                	mov    %ecx,%edx
c0101def:	85 d2                	test   %edx,%edx
c0101df1:	0f 85 aa 00 00 00    	jne    c0101ea1 <trap_dispatch+0x137>
            print_ticks();
c0101df7:	e8 95 fb ff ff       	call   c0101991 <print_ticks>
        break;
c0101dfc:	e9 a0 00 00 00       	jmp    c0101ea1 <trap_dispatch+0x137>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e01:	e8 1e f9 ff ff       	call   c0101724 <cons_getc>
c0101e06:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e09:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e0d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e11:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e19:	c7 04 24 54 64 10 c0 	movl   $0xc0106454,(%esp)
c0101e20:	e8 95 e4 ff ff       	call   c01002ba <cprintf>
        break;
c0101e25:	eb 7b                	jmp    c0101ea2 <trap_dispatch+0x138>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e27:	e8 f8 f8 ff ff       	call   c0101724 <cons_getc>
c0101e2c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e2f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e33:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e37:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e3f:	c7 04 24 66 64 10 c0 	movl   $0xc0106466,(%esp)
c0101e46:	e8 6f e4 ff ff       	call   c01002ba <cprintf>
        break;
c0101e4b:	eb 55                	jmp    c0101ea2 <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e4d:	c7 44 24 08 75 64 10 	movl   $0xc0106475,0x8(%esp)
c0101e54:	c0 
c0101e55:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0101e5c:	00 
c0101e5d:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101e64:	e8 bd e5 ff ff       	call   c0100426 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e70:	83 e0 03             	and    $0x3,%eax
c0101e73:	85 c0                	test   %eax,%eax
c0101e75:	75 2b                	jne    c0101ea2 <trap_dispatch+0x138>
            print_trapframe(tf);
c0101e77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7a:	89 04 24             	mov    %eax,(%esp)
c0101e7d:	e8 77 fc ff ff       	call   c0101af9 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e82:	c7 44 24 08 96 64 10 	movl   $0xc0106496,0x8(%esp)
c0101e89:	c0 
c0101e8a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0101e91:	00 
c0101e92:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101e99:	e8 88 e5 ff ff       	call   c0100426 <__panic>
        break;
c0101e9e:	90                   	nop
c0101e9f:	eb 01                	jmp    c0101ea2 <trap_dispatch+0x138>
        break;
c0101ea1:	90                   	nop
        }
    }
}
c0101ea2:	90                   	nop
c0101ea3:	c9                   	leave  
c0101ea4:	c3                   	ret    

c0101ea5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ea5:	f3 0f 1e fb          	endbr32 
c0101ea9:	55                   	push   %ebp
c0101eaa:	89 e5                	mov    %esp,%ebp
c0101eac:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb2:	89 04 24             	mov    %eax,(%esp)
c0101eb5:	e8 b0 fe ff ff       	call   c0101d6a <trap_dispatch>
}
c0101eba:	90                   	nop
c0101ebb:	c9                   	leave  
c0101ebc:	c3                   	ret    

c0101ebd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  jmp __alltraps
c0101ec1:	e9 69 0a 00 00       	jmp    c010292f <__alltraps>

c0101ec6 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $1
c0101ec8:	6a 01                	push   $0x1
  jmp __alltraps
c0101eca:	e9 60 0a 00 00       	jmp    c010292f <__alltraps>

c0101ecf <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $2
c0101ed1:	6a 02                	push   $0x2
  jmp __alltraps
c0101ed3:	e9 57 0a 00 00       	jmp    c010292f <__alltraps>

c0101ed8 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $3
c0101eda:	6a 03                	push   $0x3
  jmp __alltraps
c0101edc:	e9 4e 0a 00 00       	jmp    c010292f <__alltraps>

c0101ee1 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $4
c0101ee3:	6a 04                	push   $0x4
  jmp __alltraps
c0101ee5:	e9 45 0a 00 00       	jmp    c010292f <__alltraps>

c0101eea <vector5>:
.globl vector5
vector5:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $5
c0101eec:	6a 05                	push   $0x5
  jmp __alltraps
c0101eee:	e9 3c 0a 00 00       	jmp    c010292f <__alltraps>

c0101ef3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $6
c0101ef5:	6a 06                	push   $0x6
  jmp __alltraps
c0101ef7:	e9 33 0a 00 00       	jmp    c010292f <__alltraps>

c0101efc <vector7>:
.globl vector7
vector7:
  pushl $0
c0101efc:	6a 00                	push   $0x0
  pushl $7
c0101efe:	6a 07                	push   $0x7
  jmp __alltraps
c0101f00:	e9 2a 0a 00 00       	jmp    c010292f <__alltraps>

c0101f05 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f05:	6a 08                	push   $0x8
  jmp __alltraps
c0101f07:	e9 23 0a 00 00       	jmp    c010292f <__alltraps>

c0101f0c <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $9
c0101f0e:	6a 09                	push   $0x9
  jmp __alltraps
c0101f10:	e9 1a 0a 00 00       	jmp    c010292f <__alltraps>

c0101f15 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f15:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f17:	e9 13 0a 00 00       	jmp    c010292f <__alltraps>

c0101f1c <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f1c:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f1e:	e9 0c 0a 00 00       	jmp    c010292f <__alltraps>

c0101f23 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f23:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f25:	e9 05 0a 00 00       	jmp    c010292f <__alltraps>

c0101f2a <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f2a:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f2c:	e9 fe 09 00 00       	jmp    c010292f <__alltraps>

c0101f31 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f31:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f33:	e9 f7 09 00 00       	jmp    c010292f <__alltraps>

c0101f38 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $15
c0101f3a:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f3c:	e9 ee 09 00 00       	jmp    c010292f <__alltraps>

c0101f41 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $16
c0101f43:	6a 10                	push   $0x10
  jmp __alltraps
c0101f45:	e9 e5 09 00 00       	jmp    c010292f <__alltraps>

c0101f4a <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f4a:	6a 11                	push   $0x11
  jmp __alltraps
c0101f4c:	e9 de 09 00 00       	jmp    c010292f <__alltraps>

c0101f51 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $18
c0101f53:	6a 12                	push   $0x12
  jmp __alltraps
c0101f55:	e9 d5 09 00 00       	jmp    c010292f <__alltraps>

c0101f5a <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $19
c0101f5c:	6a 13                	push   $0x13
  jmp __alltraps
c0101f5e:	e9 cc 09 00 00       	jmp    c010292f <__alltraps>

c0101f63 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $20
c0101f65:	6a 14                	push   $0x14
  jmp __alltraps
c0101f67:	e9 c3 09 00 00       	jmp    c010292f <__alltraps>

c0101f6c <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $21
c0101f6e:	6a 15                	push   $0x15
  jmp __alltraps
c0101f70:	e9 ba 09 00 00       	jmp    c010292f <__alltraps>

c0101f75 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $22
c0101f77:	6a 16                	push   $0x16
  jmp __alltraps
c0101f79:	e9 b1 09 00 00       	jmp    c010292f <__alltraps>

c0101f7e <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $23
c0101f80:	6a 17                	push   $0x17
  jmp __alltraps
c0101f82:	e9 a8 09 00 00       	jmp    c010292f <__alltraps>

c0101f87 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $24
c0101f89:	6a 18                	push   $0x18
  jmp __alltraps
c0101f8b:	e9 9f 09 00 00       	jmp    c010292f <__alltraps>

c0101f90 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $25
c0101f92:	6a 19                	push   $0x19
  jmp __alltraps
c0101f94:	e9 96 09 00 00       	jmp    c010292f <__alltraps>

c0101f99 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $26
c0101f9b:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f9d:	e9 8d 09 00 00       	jmp    c010292f <__alltraps>

c0101fa2 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $27
c0101fa4:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fa6:	e9 84 09 00 00       	jmp    c010292f <__alltraps>

c0101fab <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $28
c0101fad:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101faf:	e9 7b 09 00 00       	jmp    c010292f <__alltraps>

c0101fb4 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $29
c0101fb6:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fb8:	e9 72 09 00 00       	jmp    c010292f <__alltraps>

c0101fbd <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $30
c0101fbf:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fc1:	e9 69 09 00 00       	jmp    c010292f <__alltraps>

c0101fc6 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $31
c0101fc8:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fca:	e9 60 09 00 00       	jmp    c010292f <__alltraps>

c0101fcf <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $32
c0101fd1:	6a 20                	push   $0x20
  jmp __alltraps
c0101fd3:	e9 57 09 00 00       	jmp    c010292f <__alltraps>

c0101fd8 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $33
c0101fda:	6a 21                	push   $0x21
  jmp __alltraps
c0101fdc:	e9 4e 09 00 00       	jmp    c010292f <__alltraps>

c0101fe1 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $34
c0101fe3:	6a 22                	push   $0x22
  jmp __alltraps
c0101fe5:	e9 45 09 00 00       	jmp    c010292f <__alltraps>

c0101fea <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $35
c0101fec:	6a 23                	push   $0x23
  jmp __alltraps
c0101fee:	e9 3c 09 00 00       	jmp    c010292f <__alltraps>

c0101ff3 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $36
c0101ff5:	6a 24                	push   $0x24
  jmp __alltraps
c0101ff7:	e9 33 09 00 00       	jmp    c010292f <__alltraps>

c0101ffc <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $37
c0101ffe:	6a 25                	push   $0x25
  jmp __alltraps
c0102000:	e9 2a 09 00 00       	jmp    c010292f <__alltraps>

c0102005 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $38
c0102007:	6a 26                	push   $0x26
  jmp __alltraps
c0102009:	e9 21 09 00 00       	jmp    c010292f <__alltraps>

c010200e <vector39>:
.globl vector39
vector39:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $39
c0102010:	6a 27                	push   $0x27
  jmp __alltraps
c0102012:	e9 18 09 00 00       	jmp    c010292f <__alltraps>

c0102017 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $40
c0102019:	6a 28                	push   $0x28
  jmp __alltraps
c010201b:	e9 0f 09 00 00       	jmp    c010292f <__alltraps>

c0102020 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $41
c0102022:	6a 29                	push   $0x29
  jmp __alltraps
c0102024:	e9 06 09 00 00       	jmp    c010292f <__alltraps>

c0102029 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $42
c010202b:	6a 2a                	push   $0x2a
  jmp __alltraps
c010202d:	e9 fd 08 00 00       	jmp    c010292f <__alltraps>

c0102032 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $43
c0102034:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102036:	e9 f4 08 00 00       	jmp    c010292f <__alltraps>

c010203b <vector44>:
.globl vector44
vector44:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $44
c010203d:	6a 2c                	push   $0x2c
  jmp __alltraps
c010203f:	e9 eb 08 00 00       	jmp    c010292f <__alltraps>

c0102044 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $45
c0102046:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102048:	e9 e2 08 00 00       	jmp    c010292f <__alltraps>

c010204d <vector46>:
.globl vector46
vector46:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $46
c010204f:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102051:	e9 d9 08 00 00       	jmp    c010292f <__alltraps>

c0102056 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $47
c0102058:	6a 2f                	push   $0x2f
  jmp __alltraps
c010205a:	e9 d0 08 00 00       	jmp    c010292f <__alltraps>

c010205f <vector48>:
.globl vector48
vector48:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $48
c0102061:	6a 30                	push   $0x30
  jmp __alltraps
c0102063:	e9 c7 08 00 00       	jmp    c010292f <__alltraps>

c0102068 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $49
c010206a:	6a 31                	push   $0x31
  jmp __alltraps
c010206c:	e9 be 08 00 00       	jmp    c010292f <__alltraps>

c0102071 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $50
c0102073:	6a 32                	push   $0x32
  jmp __alltraps
c0102075:	e9 b5 08 00 00       	jmp    c010292f <__alltraps>

c010207a <vector51>:
.globl vector51
vector51:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $51
c010207c:	6a 33                	push   $0x33
  jmp __alltraps
c010207e:	e9 ac 08 00 00       	jmp    c010292f <__alltraps>

c0102083 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $52
c0102085:	6a 34                	push   $0x34
  jmp __alltraps
c0102087:	e9 a3 08 00 00       	jmp    c010292f <__alltraps>

c010208c <vector53>:
.globl vector53
vector53:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $53
c010208e:	6a 35                	push   $0x35
  jmp __alltraps
c0102090:	e9 9a 08 00 00       	jmp    c010292f <__alltraps>

c0102095 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $54
c0102097:	6a 36                	push   $0x36
  jmp __alltraps
c0102099:	e9 91 08 00 00       	jmp    c010292f <__alltraps>

c010209e <vector55>:
.globl vector55
vector55:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $55
c01020a0:	6a 37                	push   $0x37
  jmp __alltraps
c01020a2:	e9 88 08 00 00       	jmp    c010292f <__alltraps>

c01020a7 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $56
c01020a9:	6a 38                	push   $0x38
  jmp __alltraps
c01020ab:	e9 7f 08 00 00       	jmp    c010292f <__alltraps>

c01020b0 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $57
c01020b2:	6a 39                	push   $0x39
  jmp __alltraps
c01020b4:	e9 76 08 00 00       	jmp    c010292f <__alltraps>

c01020b9 <vector58>:
.globl vector58
vector58:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $58
c01020bb:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020bd:	e9 6d 08 00 00       	jmp    c010292f <__alltraps>

c01020c2 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $59
c01020c4:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020c6:	e9 64 08 00 00       	jmp    c010292f <__alltraps>

c01020cb <vector60>:
.globl vector60
vector60:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $60
c01020cd:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020cf:	e9 5b 08 00 00       	jmp    c010292f <__alltraps>

c01020d4 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $61
c01020d6:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020d8:	e9 52 08 00 00       	jmp    c010292f <__alltraps>

c01020dd <vector62>:
.globl vector62
vector62:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $62
c01020df:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020e1:	e9 49 08 00 00       	jmp    c010292f <__alltraps>

c01020e6 <vector63>:
.globl vector63
vector63:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $63
c01020e8:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020ea:	e9 40 08 00 00       	jmp    c010292f <__alltraps>

c01020ef <vector64>:
.globl vector64
vector64:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $64
c01020f1:	6a 40                	push   $0x40
  jmp __alltraps
c01020f3:	e9 37 08 00 00       	jmp    c010292f <__alltraps>

c01020f8 <vector65>:
.globl vector65
vector65:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $65
c01020fa:	6a 41                	push   $0x41
  jmp __alltraps
c01020fc:	e9 2e 08 00 00       	jmp    c010292f <__alltraps>

c0102101 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $66
c0102103:	6a 42                	push   $0x42
  jmp __alltraps
c0102105:	e9 25 08 00 00       	jmp    c010292f <__alltraps>

c010210a <vector67>:
.globl vector67
vector67:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $67
c010210c:	6a 43                	push   $0x43
  jmp __alltraps
c010210e:	e9 1c 08 00 00       	jmp    c010292f <__alltraps>

c0102113 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $68
c0102115:	6a 44                	push   $0x44
  jmp __alltraps
c0102117:	e9 13 08 00 00       	jmp    c010292f <__alltraps>

c010211c <vector69>:
.globl vector69
vector69:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $69
c010211e:	6a 45                	push   $0x45
  jmp __alltraps
c0102120:	e9 0a 08 00 00       	jmp    c010292f <__alltraps>

c0102125 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $70
c0102127:	6a 46                	push   $0x46
  jmp __alltraps
c0102129:	e9 01 08 00 00       	jmp    c010292f <__alltraps>

c010212e <vector71>:
.globl vector71
vector71:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $71
c0102130:	6a 47                	push   $0x47
  jmp __alltraps
c0102132:	e9 f8 07 00 00       	jmp    c010292f <__alltraps>

c0102137 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $72
c0102139:	6a 48                	push   $0x48
  jmp __alltraps
c010213b:	e9 ef 07 00 00       	jmp    c010292f <__alltraps>

c0102140 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $73
c0102142:	6a 49                	push   $0x49
  jmp __alltraps
c0102144:	e9 e6 07 00 00       	jmp    c010292f <__alltraps>

c0102149 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $74
c010214b:	6a 4a                	push   $0x4a
  jmp __alltraps
c010214d:	e9 dd 07 00 00       	jmp    c010292f <__alltraps>

c0102152 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $75
c0102154:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102156:	e9 d4 07 00 00       	jmp    c010292f <__alltraps>

c010215b <vector76>:
.globl vector76
vector76:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $76
c010215d:	6a 4c                	push   $0x4c
  jmp __alltraps
c010215f:	e9 cb 07 00 00       	jmp    c010292f <__alltraps>

c0102164 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $77
c0102166:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102168:	e9 c2 07 00 00       	jmp    c010292f <__alltraps>

c010216d <vector78>:
.globl vector78
vector78:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $78
c010216f:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102171:	e9 b9 07 00 00       	jmp    c010292f <__alltraps>

c0102176 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $79
c0102178:	6a 4f                	push   $0x4f
  jmp __alltraps
c010217a:	e9 b0 07 00 00       	jmp    c010292f <__alltraps>

c010217f <vector80>:
.globl vector80
vector80:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $80
c0102181:	6a 50                	push   $0x50
  jmp __alltraps
c0102183:	e9 a7 07 00 00       	jmp    c010292f <__alltraps>

c0102188 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $81
c010218a:	6a 51                	push   $0x51
  jmp __alltraps
c010218c:	e9 9e 07 00 00       	jmp    c010292f <__alltraps>

c0102191 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $82
c0102193:	6a 52                	push   $0x52
  jmp __alltraps
c0102195:	e9 95 07 00 00       	jmp    c010292f <__alltraps>

c010219a <vector83>:
.globl vector83
vector83:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $83
c010219c:	6a 53                	push   $0x53
  jmp __alltraps
c010219e:	e9 8c 07 00 00       	jmp    c010292f <__alltraps>

c01021a3 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $84
c01021a5:	6a 54                	push   $0x54
  jmp __alltraps
c01021a7:	e9 83 07 00 00       	jmp    c010292f <__alltraps>

c01021ac <vector85>:
.globl vector85
vector85:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $85
c01021ae:	6a 55                	push   $0x55
  jmp __alltraps
c01021b0:	e9 7a 07 00 00       	jmp    c010292f <__alltraps>

c01021b5 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $86
c01021b7:	6a 56                	push   $0x56
  jmp __alltraps
c01021b9:	e9 71 07 00 00       	jmp    c010292f <__alltraps>

c01021be <vector87>:
.globl vector87
vector87:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $87
c01021c0:	6a 57                	push   $0x57
  jmp __alltraps
c01021c2:	e9 68 07 00 00       	jmp    c010292f <__alltraps>

c01021c7 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $88
c01021c9:	6a 58                	push   $0x58
  jmp __alltraps
c01021cb:	e9 5f 07 00 00       	jmp    c010292f <__alltraps>

c01021d0 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $89
c01021d2:	6a 59                	push   $0x59
  jmp __alltraps
c01021d4:	e9 56 07 00 00       	jmp    c010292f <__alltraps>

c01021d9 <vector90>:
.globl vector90
vector90:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $90
c01021db:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021dd:	e9 4d 07 00 00       	jmp    c010292f <__alltraps>

c01021e2 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $91
c01021e4:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021e6:	e9 44 07 00 00       	jmp    c010292f <__alltraps>

c01021eb <vector92>:
.globl vector92
vector92:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $92
c01021ed:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021ef:	e9 3b 07 00 00       	jmp    c010292f <__alltraps>

c01021f4 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $93
c01021f6:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021f8:	e9 32 07 00 00       	jmp    c010292f <__alltraps>

c01021fd <vector94>:
.globl vector94
vector94:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $94
c01021ff:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102201:	e9 29 07 00 00       	jmp    c010292f <__alltraps>

c0102206 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $95
c0102208:	6a 5f                	push   $0x5f
  jmp __alltraps
c010220a:	e9 20 07 00 00       	jmp    c010292f <__alltraps>

c010220f <vector96>:
.globl vector96
vector96:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $96
c0102211:	6a 60                	push   $0x60
  jmp __alltraps
c0102213:	e9 17 07 00 00       	jmp    c010292f <__alltraps>

c0102218 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $97
c010221a:	6a 61                	push   $0x61
  jmp __alltraps
c010221c:	e9 0e 07 00 00       	jmp    c010292f <__alltraps>

c0102221 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $98
c0102223:	6a 62                	push   $0x62
  jmp __alltraps
c0102225:	e9 05 07 00 00       	jmp    c010292f <__alltraps>

c010222a <vector99>:
.globl vector99
vector99:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $99
c010222c:	6a 63                	push   $0x63
  jmp __alltraps
c010222e:	e9 fc 06 00 00       	jmp    c010292f <__alltraps>

c0102233 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $100
c0102235:	6a 64                	push   $0x64
  jmp __alltraps
c0102237:	e9 f3 06 00 00       	jmp    c010292f <__alltraps>

c010223c <vector101>:
.globl vector101
vector101:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $101
c010223e:	6a 65                	push   $0x65
  jmp __alltraps
c0102240:	e9 ea 06 00 00       	jmp    c010292f <__alltraps>

c0102245 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $102
c0102247:	6a 66                	push   $0x66
  jmp __alltraps
c0102249:	e9 e1 06 00 00       	jmp    c010292f <__alltraps>

c010224e <vector103>:
.globl vector103
vector103:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $103
c0102250:	6a 67                	push   $0x67
  jmp __alltraps
c0102252:	e9 d8 06 00 00       	jmp    c010292f <__alltraps>

c0102257 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $104
c0102259:	6a 68                	push   $0x68
  jmp __alltraps
c010225b:	e9 cf 06 00 00       	jmp    c010292f <__alltraps>

c0102260 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $105
c0102262:	6a 69                	push   $0x69
  jmp __alltraps
c0102264:	e9 c6 06 00 00       	jmp    c010292f <__alltraps>

c0102269 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $106
c010226b:	6a 6a                	push   $0x6a
  jmp __alltraps
c010226d:	e9 bd 06 00 00       	jmp    c010292f <__alltraps>

c0102272 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $107
c0102274:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102276:	e9 b4 06 00 00       	jmp    c010292f <__alltraps>

c010227b <vector108>:
.globl vector108
vector108:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $108
c010227d:	6a 6c                	push   $0x6c
  jmp __alltraps
c010227f:	e9 ab 06 00 00       	jmp    c010292f <__alltraps>

c0102284 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $109
c0102286:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102288:	e9 a2 06 00 00       	jmp    c010292f <__alltraps>

c010228d <vector110>:
.globl vector110
vector110:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $110
c010228f:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102291:	e9 99 06 00 00       	jmp    c010292f <__alltraps>

c0102296 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $111
c0102298:	6a 6f                	push   $0x6f
  jmp __alltraps
c010229a:	e9 90 06 00 00       	jmp    c010292f <__alltraps>

c010229f <vector112>:
.globl vector112
vector112:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $112
c01022a1:	6a 70                	push   $0x70
  jmp __alltraps
c01022a3:	e9 87 06 00 00       	jmp    c010292f <__alltraps>

c01022a8 <vector113>:
.globl vector113
vector113:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $113
c01022aa:	6a 71                	push   $0x71
  jmp __alltraps
c01022ac:	e9 7e 06 00 00       	jmp    c010292f <__alltraps>

c01022b1 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $114
c01022b3:	6a 72                	push   $0x72
  jmp __alltraps
c01022b5:	e9 75 06 00 00       	jmp    c010292f <__alltraps>

c01022ba <vector115>:
.globl vector115
vector115:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $115
c01022bc:	6a 73                	push   $0x73
  jmp __alltraps
c01022be:	e9 6c 06 00 00       	jmp    c010292f <__alltraps>

c01022c3 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $116
c01022c5:	6a 74                	push   $0x74
  jmp __alltraps
c01022c7:	e9 63 06 00 00       	jmp    c010292f <__alltraps>

c01022cc <vector117>:
.globl vector117
vector117:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $117
c01022ce:	6a 75                	push   $0x75
  jmp __alltraps
c01022d0:	e9 5a 06 00 00       	jmp    c010292f <__alltraps>

c01022d5 <vector118>:
.globl vector118
vector118:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $118
c01022d7:	6a 76                	push   $0x76
  jmp __alltraps
c01022d9:	e9 51 06 00 00       	jmp    c010292f <__alltraps>

c01022de <vector119>:
.globl vector119
vector119:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $119
c01022e0:	6a 77                	push   $0x77
  jmp __alltraps
c01022e2:	e9 48 06 00 00       	jmp    c010292f <__alltraps>

c01022e7 <vector120>:
.globl vector120
vector120:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $120
c01022e9:	6a 78                	push   $0x78
  jmp __alltraps
c01022eb:	e9 3f 06 00 00       	jmp    c010292f <__alltraps>

c01022f0 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $121
c01022f2:	6a 79                	push   $0x79
  jmp __alltraps
c01022f4:	e9 36 06 00 00       	jmp    c010292f <__alltraps>

c01022f9 <vector122>:
.globl vector122
vector122:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $122
c01022fb:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022fd:	e9 2d 06 00 00       	jmp    c010292f <__alltraps>

c0102302 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $123
c0102304:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102306:	e9 24 06 00 00       	jmp    c010292f <__alltraps>

c010230b <vector124>:
.globl vector124
vector124:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $124
c010230d:	6a 7c                	push   $0x7c
  jmp __alltraps
c010230f:	e9 1b 06 00 00       	jmp    c010292f <__alltraps>

c0102314 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $125
c0102316:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102318:	e9 12 06 00 00       	jmp    c010292f <__alltraps>

c010231d <vector126>:
.globl vector126
vector126:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $126
c010231f:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102321:	e9 09 06 00 00       	jmp    c010292f <__alltraps>

c0102326 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $127
c0102328:	6a 7f                	push   $0x7f
  jmp __alltraps
c010232a:	e9 00 06 00 00       	jmp    c010292f <__alltraps>

c010232f <vector128>:
.globl vector128
vector128:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $128
c0102331:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102336:	e9 f4 05 00 00       	jmp    c010292f <__alltraps>

c010233b <vector129>:
.globl vector129
vector129:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $129
c010233d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102342:	e9 e8 05 00 00       	jmp    c010292f <__alltraps>

c0102347 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $130
c0102349:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010234e:	e9 dc 05 00 00       	jmp    c010292f <__alltraps>

c0102353 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $131
c0102355:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010235a:	e9 d0 05 00 00       	jmp    c010292f <__alltraps>

c010235f <vector132>:
.globl vector132
vector132:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $132
c0102361:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102366:	e9 c4 05 00 00       	jmp    c010292f <__alltraps>

c010236b <vector133>:
.globl vector133
vector133:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $133
c010236d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102372:	e9 b8 05 00 00       	jmp    c010292f <__alltraps>

c0102377 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $134
c0102379:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010237e:	e9 ac 05 00 00       	jmp    c010292f <__alltraps>

c0102383 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $135
c0102385:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010238a:	e9 a0 05 00 00       	jmp    c010292f <__alltraps>

c010238f <vector136>:
.globl vector136
vector136:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $136
c0102391:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102396:	e9 94 05 00 00       	jmp    c010292f <__alltraps>

c010239b <vector137>:
.globl vector137
vector137:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $137
c010239d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023a2:	e9 88 05 00 00       	jmp    c010292f <__alltraps>

c01023a7 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $138
c01023a9:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023ae:	e9 7c 05 00 00       	jmp    c010292f <__alltraps>

c01023b3 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $139
c01023b5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023ba:	e9 70 05 00 00       	jmp    c010292f <__alltraps>

c01023bf <vector140>:
.globl vector140
vector140:
  pushl $0
c01023bf:	6a 00                	push   $0x0
  pushl $140
c01023c1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023c6:	e9 64 05 00 00       	jmp    c010292f <__alltraps>

c01023cb <vector141>:
.globl vector141
vector141:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $141
c01023cd:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023d2:	e9 58 05 00 00       	jmp    c010292f <__alltraps>

c01023d7 <vector142>:
.globl vector142
vector142:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $142
c01023d9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023de:	e9 4c 05 00 00       	jmp    c010292f <__alltraps>

c01023e3 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023e3:	6a 00                	push   $0x0
  pushl $143
c01023e5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023ea:	e9 40 05 00 00       	jmp    c010292f <__alltraps>

c01023ef <vector144>:
.globl vector144
vector144:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $144
c01023f1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023f6:	e9 34 05 00 00       	jmp    c010292f <__alltraps>

c01023fb <vector145>:
.globl vector145
vector145:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $145
c01023fd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102402:	e9 28 05 00 00       	jmp    c010292f <__alltraps>

c0102407 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102407:	6a 00                	push   $0x0
  pushl $146
c0102409:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010240e:	e9 1c 05 00 00       	jmp    c010292f <__alltraps>

c0102413 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $147
c0102415:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010241a:	e9 10 05 00 00       	jmp    c010292f <__alltraps>

c010241f <vector148>:
.globl vector148
vector148:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $148
c0102421:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102426:	e9 04 05 00 00       	jmp    c010292f <__alltraps>

c010242b <vector149>:
.globl vector149
vector149:
  pushl $0
c010242b:	6a 00                	push   $0x0
  pushl $149
c010242d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102432:	e9 f8 04 00 00       	jmp    c010292f <__alltraps>

c0102437 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102437:	6a 00                	push   $0x0
  pushl $150
c0102439:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010243e:	e9 ec 04 00 00       	jmp    c010292f <__alltraps>

c0102443 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $151
c0102445:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010244a:	e9 e0 04 00 00       	jmp    c010292f <__alltraps>

c010244f <vector152>:
.globl vector152
vector152:
  pushl $0
c010244f:	6a 00                	push   $0x0
  pushl $152
c0102451:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102456:	e9 d4 04 00 00       	jmp    c010292f <__alltraps>

c010245b <vector153>:
.globl vector153
vector153:
  pushl $0
c010245b:	6a 00                	push   $0x0
  pushl $153
c010245d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102462:	e9 c8 04 00 00       	jmp    c010292f <__alltraps>

c0102467 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $154
c0102469:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010246e:	e9 bc 04 00 00       	jmp    c010292f <__alltraps>

c0102473 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102473:	6a 00                	push   $0x0
  pushl $155
c0102475:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010247a:	e9 b0 04 00 00       	jmp    c010292f <__alltraps>

c010247f <vector156>:
.globl vector156
vector156:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $156
c0102481:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102486:	e9 a4 04 00 00       	jmp    c010292f <__alltraps>

c010248b <vector157>:
.globl vector157
vector157:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $157
c010248d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102492:	e9 98 04 00 00       	jmp    c010292f <__alltraps>

c0102497 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102497:	6a 00                	push   $0x0
  pushl $158
c0102499:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010249e:	e9 8c 04 00 00       	jmp    c010292f <__alltraps>

c01024a3 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $159
c01024a5:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024aa:	e9 80 04 00 00       	jmp    c010292f <__alltraps>

c01024af <vector160>:
.globl vector160
vector160:
  pushl $0
c01024af:	6a 00                	push   $0x0
  pushl $160
c01024b1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024b6:	e9 74 04 00 00       	jmp    c010292f <__alltraps>

c01024bb <vector161>:
.globl vector161
vector161:
  pushl $0
c01024bb:	6a 00                	push   $0x0
  pushl $161
c01024bd:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024c2:	e9 68 04 00 00       	jmp    c010292f <__alltraps>

c01024c7 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024c7:	6a 00                	push   $0x0
  pushl $162
c01024c9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024ce:	e9 5c 04 00 00       	jmp    c010292f <__alltraps>

c01024d3 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024d3:	6a 00                	push   $0x0
  pushl $163
c01024d5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024da:	e9 50 04 00 00       	jmp    c010292f <__alltraps>

c01024df <vector164>:
.globl vector164
vector164:
  pushl $0
c01024df:	6a 00                	push   $0x0
  pushl $164
c01024e1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024e6:	e9 44 04 00 00       	jmp    c010292f <__alltraps>

c01024eb <vector165>:
.globl vector165
vector165:
  pushl $0
c01024eb:	6a 00                	push   $0x0
  pushl $165
c01024ed:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024f2:	e9 38 04 00 00       	jmp    c010292f <__alltraps>

c01024f7 <vector166>:
.globl vector166
vector166:
  pushl $0
c01024f7:	6a 00                	push   $0x0
  pushl $166
c01024f9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024fe:	e9 2c 04 00 00       	jmp    c010292f <__alltraps>

c0102503 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102503:	6a 00                	push   $0x0
  pushl $167
c0102505:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010250a:	e9 20 04 00 00       	jmp    c010292f <__alltraps>

c010250f <vector168>:
.globl vector168
vector168:
  pushl $0
c010250f:	6a 00                	push   $0x0
  pushl $168
c0102511:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102516:	e9 14 04 00 00       	jmp    c010292f <__alltraps>

c010251b <vector169>:
.globl vector169
vector169:
  pushl $0
c010251b:	6a 00                	push   $0x0
  pushl $169
c010251d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102522:	e9 08 04 00 00       	jmp    c010292f <__alltraps>

c0102527 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102527:	6a 00                	push   $0x0
  pushl $170
c0102529:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010252e:	e9 fc 03 00 00       	jmp    c010292f <__alltraps>

c0102533 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102533:	6a 00                	push   $0x0
  pushl $171
c0102535:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010253a:	e9 f0 03 00 00       	jmp    c010292f <__alltraps>

c010253f <vector172>:
.globl vector172
vector172:
  pushl $0
c010253f:	6a 00                	push   $0x0
  pushl $172
c0102541:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102546:	e9 e4 03 00 00       	jmp    c010292f <__alltraps>

c010254b <vector173>:
.globl vector173
vector173:
  pushl $0
c010254b:	6a 00                	push   $0x0
  pushl $173
c010254d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102552:	e9 d8 03 00 00       	jmp    c010292f <__alltraps>

c0102557 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102557:	6a 00                	push   $0x0
  pushl $174
c0102559:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010255e:	e9 cc 03 00 00       	jmp    c010292f <__alltraps>

c0102563 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102563:	6a 00                	push   $0x0
  pushl $175
c0102565:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010256a:	e9 c0 03 00 00       	jmp    c010292f <__alltraps>

c010256f <vector176>:
.globl vector176
vector176:
  pushl $0
c010256f:	6a 00                	push   $0x0
  pushl $176
c0102571:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102576:	e9 b4 03 00 00       	jmp    c010292f <__alltraps>

c010257b <vector177>:
.globl vector177
vector177:
  pushl $0
c010257b:	6a 00                	push   $0x0
  pushl $177
c010257d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102582:	e9 a8 03 00 00       	jmp    c010292f <__alltraps>

c0102587 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102587:	6a 00                	push   $0x0
  pushl $178
c0102589:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010258e:	e9 9c 03 00 00       	jmp    c010292f <__alltraps>

c0102593 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102593:	6a 00                	push   $0x0
  pushl $179
c0102595:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010259a:	e9 90 03 00 00       	jmp    c010292f <__alltraps>

c010259f <vector180>:
.globl vector180
vector180:
  pushl $0
c010259f:	6a 00                	push   $0x0
  pushl $180
c01025a1:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025a6:	e9 84 03 00 00       	jmp    c010292f <__alltraps>

c01025ab <vector181>:
.globl vector181
vector181:
  pushl $0
c01025ab:	6a 00                	push   $0x0
  pushl $181
c01025ad:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025b2:	e9 78 03 00 00       	jmp    c010292f <__alltraps>

c01025b7 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025b7:	6a 00                	push   $0x0
  pushl $182
c01025b9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025be:	e9 6c 03 00 00       	jmp    c010292f <__alltraps>

c01025c3 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025c3:	6a 00                	push   $0x0
  pushl $183
c01025c5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025ca:	e9 60 03 00 00       	jmp    c010292f <__alltraps>

c01025cf <vector184>:
.globl vector184
vector184:
  pushl $0
c01025cf:	6a 00                	push   $0x0
  pushl $184
c01025d1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025d6:	e9 54 03 00 00       	jmp    c010292f <__alltraps>

c01025db <vector185>:
.globl vector185
vector185:
  pushl $0
c01025db:	6a 00                	push   $0x0
  pushl $185
c01025dd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025e2:	e9 48 03 00 00       	jmp    c010292f <__alltraps>

c01025e7 <vector186>:
.globl vector186
vector186:
  pushl $0
c01025e7:	6a 00                	push   $0x0
  pushl $186
c01025e9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025ee:	e9 3c 03 00 00       	jmp    c010292f <__alltraps>

c01025f3 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025f3:	6a 00                	push   $0x0
  pushl $187
c01025f5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025fa:	e9 30 03 00 00       	jmp    c010292f <__alltraps>

c01025ff <vector188>:
.globl vector188
vector188:
  pushl $0
c01025ff:	6a 00                	push   $0x0
  pushl $188
c0102601:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102606:	e9 24 03 00 00       	jmp    c010292f <__alltraps>

c010260b <vector189>:
.globl vector189
vector189:
  pushl $0
c010260b:	6a 00                	push   $0x0
  pushl $189
c010260d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102612:	e9 18 03 00 00       	jmp    c010292f <__alltraps>

c0102617 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102617:	6a 00                	push   $0x0
  pushl $190
c0102619:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010261e:	e9 0c 03 00 00       	jmp    c010292f <__alltraps>

c0102623 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $191
c0102625:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010262a:	e9 00 03 00 00       	jmp    c010292f <__alltraps>

c010262f <vector192>:
.globl vector192
vector192:
  pushl $0
c010262f:	6a 00                	push   $0x0
  pushl $192
c0102631:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102636:	e9 f4 02 00 00       	jmp    c010292f <__alltraps>

c010263b <vector193>:
.globl vector193
vector193:
  pushl $0
c010263b:	6a 00                	push   $0x0
  pushl $193
c010263d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102642:	e9 e8 02 00 00       	jmp    c010292f <__alltraps>

c0102647 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $194
c0102649:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010264e:	e9 dc 02 00 00       	jmp    c010292f <__alltraps>

c0102653 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102653:	6a 00                	push   $0x0
  pushl $195
c0102655:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010265a:	e9 d0 02 00 00       	jmp    c010292f <__alltraps>

c010265f <vector196>:
.globl vector196
vector196:
  pushl $0
c010265f:	6a 00                	push   $0x0
  pushl $196
c0102661:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102666:	e9 c4 02 00 00       	jmp    c010292f <__alltraps>

c010266b <vector197>:
.globl vector197
vector197:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $197
c010266d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102672:	e9 b8 02 00 00       	jmp    c010292f <__alltraps>

c0102677 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102677:	6a 00                	push   $0x0
  pushl $198
c0102679:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010267e:	e9 ac 02 00 00       	jmp    c010292f <__alltraps>

c0102683 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102683:	6a 00                	push   $0x0
  pushl $199
c0102685:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010268a:	e9 a0 02 00 00       	jmp    c010292f <__alltraps>

c010268f <vector200>:
.globl vector200
vector200:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $200
c0102691:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102696:	e9 94 02 00 00       	jmp    c010292f <__alltraps>

c010269b <vector201>:
.globl vector201
vector201:
  pushl $0
c010269b:	6a 00                	push   $0x0
  pushl $201
c010269d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026a2:	e9 88 02 00 00       	jmp    c010292f <__alltraps>

c01026a7 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026a7:	6a 00                	push   $0x0
  pushl $202
c01026a9:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026ae:	e9 7c 02 00 00       	jmp    c010292f <__alltraps>

c01026b3 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $203
c01026b5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026ba:	e9 70 02 00 00       	jmp    c010292f <__alltraps>

c01026bf <vector204>:
.globl vector204
vector204:
  pushl $0
c01026bf:	6a 00                	push   $0x0
  pushl $204
c01026c1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026c6:	e9 64 02 00 00       	jmp    c010292f <__alltraps>

c01026cb <vector205>:
.globl vector205
vector205:
  pushl $0
c01026cb:	6a 00                	push   $0x0
  pushl $205
c01026cd:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026d2:	e9 58 02 00 00       	jmp    c010292f <__alltraps>

c01026d7 <vector206>:
.globl vector206
vector206:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $206
c01026d9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026de:	e9 4c 02 00 00       	jmp    c010292f <__alltraps>

c01026e3 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026e3:	6a 00                	push   $0x0
  pushl $207
c01026e5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026ea:	e9 40 02 00 00       	jmp    c010292f <__alltraps>

c01026ef <vector208>:
.globl vector208
vector208:
  pushl $0
c01026ef:	6a 00                	push   $0x0
  pushl $208
c01026f1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026f6:	e9 34 02 00 00       	jmp    c010292f <__alltraps>

c01026fb <vector209>:
.globl vector209
vector209:
  pushl $0
c01026fb:	6a 00                	push   $0x0
  pushl $209
c01026fd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102702:	e9 28 02 00 00       	jmp    c010292f <__alltraps>

c0102707 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102707:	6a 00                	push   $0x0
  pushl $210
c0102709:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010270e:	e9 1c 02 00 00       	jmp    c010292f <__alltraps>

c0102713 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102713:	6a 00                	push   $0x0
  pushl $211
c0102715:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010271a:	e9 10 02 00 00       	jmp    c010292f <__alltraps>

c010271f <vector212>:
.globl vector212
vector212:
  pushl $0
c010271f:	6a 00                	push   $0x0
  pushl $212
c0102721:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102726:	e9 04 02 00 00       	jmp    c010292f <__alltraps>

c010272b <vector213>:
.globl vector213
vector213:
  pushl $0
c010272b:	6a 00                	push   $0x0
  pushl $213
c010272d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102732:	e9 f8 01 00 00       	jmp    c010292f <__alltraps>

c0102737 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102737:	6a 00                	push   $0x0
  pushl $214
c0102739:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010273e:	e9 ec 01 00 00       	jmp    c010292f <__alltraps>

c0102743 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102743:	6a 00                	push   $0x0
  pushl $215
c0102745:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010274a:	e9 e0 01 00 00       	jmp    c010292f <__alltraps>

c010274f <vector216>:
.globl vector216
vector216:
  pushl $0
c010274f:	6a 00                	push   $0x0
  pushl $216
c0102751:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102756:	e9 d4 01 00 00       	jmp    c010292f <__alltraps>

c010275b <vector217>:
.globl vector217
vector217:
  pushl $0
c010275b:	6a 00                	push   $0x0
  pushl $217
c010275d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102762:	e9 c8 01 00 00       	jmp    c010292f <__alltraps>

c0102767 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $218
c0102769:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010276e:	e9 bc 01 00 00       	jmp    c010292f <__alltraps>

c0102773 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $219
c0102775:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010277a:	e9 b0 01 00 00       	jmp    c010292f <__alltraps>

c010277f <vector220>:
.globl vector220
vector220:
  pushl $0
c010277f:	6a 00                	push   $0x0
  pushl $220
c0102781:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102786:	e9 a4 01 00 00       	jmp    c010292f <__alltraps>

c010278b <vector221>:
.globl vector221
vector221:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $221
c010278d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102792:	e9 98 01 00 00       	jmp    c010292f <__alltraps>

c0102797 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $222
c0102799:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010279e:	e9 8c 01 00 00       	jmp    c010292f <__alltraps>

c01027a3 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027a3:	6a 00                	push   $0x0
  pushl $223
c01027a5:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027aa:	e9 80 01 00 00       	jmp    c010292f <__alltraps>

c01027af <vector224>:
.globl vector224
vector224:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $224
c01027b1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027b6:	e9 74 01 00 00       	jmp    c010292f <__alltraps>

c01027bb <vector225>:
.globl vector225
vector225:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $225
c01027bd:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027c2:	e9 68 01 00 00       	jmp    c010292f <__alltraps>

c01027c7 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027c7:	6a 00                	push   $0x0
  pushl $226
c01027c9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027ce:	e9 5c 01 00 00       	jmp    c010292f <__alltraps>

c01027d3 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $227
c01027d5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027da:	e9 50 01 00 00       	jmp    c010292f <__alltraps>

c01027df <vector228>:
.globl vector228
vector228:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $228
c01027e1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027e6:	e9 44 01 00 00       	jmp    c010292f <__alltraps>

c01027eb <vector229>:
.globl vector229
vector229:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $229
c01027ed:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027f2:	e9 38 01 00 00       	jmp    c010292f <__alltraps>

c01027f7 <vector230>:
.globl vector230
vector230:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $230
c01027f9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027fe:	e9 2c 01 00 00       	jmp    c010292f <__alltraps>

c0102803 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $231
c0102805:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010280a:	e9 20 01 00 00       	jmp    c010292f <__alltraps>

c010280f <vector232>:
.globl vector232
vector232:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $232
c0102811:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102816:	e9 14 01 00 00       	jmp    c010292f <__alltraps>

c010281b <vector233>:
.globl vector233
vector233:
  pushl $0
c010281b:	6a 00                	push   $0x0
  pushl $233
c010281d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102822:	e9 08 01 00 00       	jmp    c010292f <__alltraps>

c0102827 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $234
c0102829:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010282e:	e9 fc 00 00 00       	jmp    c010292f <__alltraps>

c0102833 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $235
c0102835:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010283a:	e9 f0 00 00 00       	jmp    c010292f <__alltraps>

c010283f <vector236>:
.globl vector236
vector236:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $236
c0102841:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102846:	e9 e4 00 00 00       	jmp    c010292f <__alltraps>

c010284b <vector237>:
.globl vector237
vector237:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $237
c010284d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102852:	e9 d8 00 00 00       	jmp    c010292f <__alltraps>

c0102857 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $238
c0102859:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010285e:	e9 cc 00 00 00       	jmp    c010292f <__alltraps>

c0102863 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $239
c0102865:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010286a:	e9 c0 00 00 00       	jmp    c010292f <__alltraps>

c010286f <vector240>:
.globl vector240
vector240:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $240
c0102871:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102876:	e9 b4 00 00 00       	jmp    c010292f <__alltraps>

c010287b <vector241>:
.globl vector241
vector241:
  pushl $0
c010287b:	6a 00                	push   $0x0
  pushl $241
c010287d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102882:	e9 a8 00 00 00       	jmp    c010292f <__alltraps>

c0102887 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $242
c0102889:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010288e:	e9 9c 00 00 00       	jmp    c010292f <__alltraps>

c0102893 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $243
c0102895:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010289a:	e9 90 00 00 00       	jmp    c010292f <__alltraps>

c010289f <vector244>:
.globl vector244
vector244:
  pushl $0
c010289f:	6a 00                	push   $0x0
  pushl $244
c01028a1:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028a6:	e9 84 00 00 00       	jmp    c010292f <__alltraps>

c01028ab <vector245>:
.globl vector245
vector245:
  pushl $0
c01028ab:	6a 00                	push   $0x0
  pushl $245
c01028ad:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028b2:	e9 78 00 00 00       	jmp    c010292f <__alltraps>

c01028b7 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028b7:	6a 00                	push   $0x0
  pushl $246
c01028b9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028be:	e9 6c 00 00 00       	jmp    c010292f <__alltraps>

c01028c3 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028c3:	6a 00                	push   $0x0
  pushl $247
c01028c5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028ca:	e9 60 00 00 00       	jmp    c010292f <__alltraps>

c01028cf <vector248>:
.globl vector248
vector248:
  pushl $0
c01028cf:	6a 00                	push   $0x0
  pushl $248
c01028d1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028d6:	e9 54 00 00 00       	jmp    c010292f <__alltraps>

c01028db <vector249>:
.globl vector249
vector249:
  pushl $0
c01028db:	6a 00                	push   $0x0
  pushl $249
c01028dd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028e2:	e9 48 00 00 00       	jmp    c010292f <__alltraps>

c01028e7 <vector250>:
.globl vector250
vector250:
  pushl $0
c01028e7:	6a 00                	push   $0x0
  pushl $250
c01028e9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028ee:	e9 3c 00 00 00       	jmp    c010292f <__alltraps>

c01028f3 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028f3:	6a 00                	push   $0x0
  pushl $251
c01028f5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028fa:	e9 30 00 00 00       	jmp    c010292f <__alltraps>

c01028ff <vector252>:
.globl vector252
vector252:
  pushl $0
c01028ff:	6a 00                	push   $0x0
  pushl $252
c0102901:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102906:	e9 24 00 00 00       	jmp    c010292f <__alltraps>

c010290b <vector253>:
.globl vector253
vector253:
  pushl $0
c010290b:	6a 00                	push   $0x0
  pushl $253
c010290d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102912:	e9 18 00 00 00       	jmp    c010292f <__alltraps>

c0102917 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102917:	6a 00                	push   $0x0
  pushl $254
c0102919:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010291e:	e9 0c 00 00 00       	jmp    c010292f <__alltraps>

c0102923 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102923:	6a 00                	push   $0x0
  pushl $255
c0102925:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010292a:	e9 00 00 00 00       	jmp    c010292f <__alltraps>

c010292f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010292f:	1e                   	push   %ds
    pushl %es
c0102930:	06                   	push   %es
    pushl %fs
c0102931:	0f a0                	push   %fs
    pushl %gs
c0102933:	0f a8                	push   %gs
    pushal
c0102935:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102936:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010293b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010293d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010293f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102940:	e8 60 f5 ff ff       	call   c0101ea5 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102945:	5c                   	pop    %esp

c0102946 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102946:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102947:	0f a9                	pop    %gs
    popl %fs
c0102949:	0f a1                	pop    %fs
    popl %es
c010294b:	07                   	pop    %es
    popl %ds
c010294c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010294d:	83 c4 08             	add    $0x8,%esp
    iret
c0102950:	cf                   	iret   

c0102951 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102951:	55                   	push   %ebp
c0102952:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102954:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102959:	8b 55 08             	mov    0x8(%ebp),%edx
c010295c:	29 c2                	sub    %eax,%edx
c010295e:	89 d0                	mov    %edx,%eax
c0102960:	c1 f8 02             	sar    $0x2,%eax
c0102963:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102969:	5d                   	pop    %ebp
c010296a:	c3                   	ret    

c010296b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010296b:	55                   	push   %ebp
c010296c:	89 e5                	mov    %esp,%ebp
c010296e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102971:	8b 45 08             	mov    0x8(%ebp),%eax
c0102974:	89 04 24             	mov    %eax,(%esp)
c0102977:	e8 d5 ff ff ff       	call   c0102951 <page2ppn>
c010297c:	c1 e0 0c             	shl    $0xc,%eax
}
c010297f:	c9                   	leave  
c0102980:	c3                   	ret    

c0102981 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102981:	55                   	push   %ebp
c0102982:	89 e5                	mov    %esp,%ebp
c0102984:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102987:	8b 45 08             	mov    0x8(%ebp),%eax
c010298a:	c1 e8 0c             	shr    $0xc,%eax
c010298d:	89 c2                	mov    %eax,%edx
c010298f:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102994:	39 c2                	cmp    %eax,%edx
c0102996:	72 1c                	jb     c01029b4 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102998:	c7 44 24 08 50 66 10 	movl   $0xc0106650,0x8(%esp)
c010299f:	c0 
c01029a0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01029a7:	00 
c01029a8:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c01029af:	e8 72 da ff ff       	call   c0100426 <__panic>
    }
    return &pages[PPN(pa)];
c01029b4:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c01029ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01029bd:	c1 e8 0c             	shr    $0xc,%eax
c01029c0:	89 c2                	mov    %eax,%edx
c01029c2:	89 d0                	mov    %edx,%eax
c01029c4:	c1 e0 02             	shl    $0x2,%eax
c01029c7:	01 d0                	add    %edx,%eax
c01029c9:	c1 e0 02             	shl    $0x2,%eax
c01029cc:	01 c8                	add    %ecx,%eax
}
c01029ce:	c9                   	leave  
c01029cf:	c3                   	ret    

c01029d0 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029d0:	55                   	push   %ebp
c01029d1:	89 e5                	mov    %esp,%ebp
c01029d3:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01029d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d9:	89 04 24             	mov    %eax,(%esp)
c01029dc:	e8 8a ff ff ff       	call   c010296b <page2pa>
c01029e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e7:	c1 e8 0c             	shr    $0xc,%eax
c01029ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01029ed:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01029f2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01029f5:	72 23                	jb     c0102a1a <page2kva+0x4a>
c01029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01029fe:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0102a05:	c0 
c0102a06:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a0d:	00 
c0102a0e:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102a15:	e8 0c da ff ff       	call   c0100426 <__panic>
c0102a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a1d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a22:	c9                   	leave  
c0102a23:	c3                   	ret    

c0102a24 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a24:	55                   	push   %ebp
c0102a25:	89 e5                	mov    %esp,%ebp
c0102a27:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a2d:	83 e0 01             	and    $0x1,%eax
c0102a30:	85 c0                	test   %eax,%eax
c0102a32:	75 1c                	jne    c0102a50 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102a34:	c7 44 24 08 a4 66 10 	movl   $0xc01066a4,0x8(%esp)
c0102a3b:	c0 
c0102a3c:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102a43:	00 
c0102a44:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102a4b:	e8 d6 d9 ff ff       	call   c0100426 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a58:	89 04 24             	mov    %eax,(%esp)
c0102a5b:	e8 21 ff ff ff       	call   c0102981 <pa2page>
}
c0102a60:	c9                   	leave  
c0102a61:	c3                   	ret    

c0102a62 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a62:	55                   	push   %ebp
c0102a63:	89 e5                	mov    %esp,%ebp
c0102a65:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a70:	89 04 24             	mov    %eax,(%esp)
c0102a73:	e8 09 ff ff ff       	call   c0102981 <pa2page>
}
c0102a78:	c9                   	leave  
c0102a79:	c3                   	ret    

c0102a7a <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a7a:	55                   	push   %ebp
c0102a7b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a80:	8b 00                	mov    (%eax),%eax
}
c0102a82:	5d                   	pop    %ebp
c0102a83:	c3                   	ret    

c0102a84 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102a84:	55                   	push   %ebp
c0102a85:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8a:	8b 00                	mov    (%eax),%eax
c0102a8c:	8d 50 01             	lea    0x1(%eax),%edx
c0102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a92:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a97:	8b 00                	mov    (%eax),%eax
}
c0102a99:	5d                   	pop    %ebp
c0102a9a:	c3                   	ret    

c0102a9b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102a9b:	55                   	push   %ebp
c0102a9c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa1:	8b 00                	mov    (%eax),%eax
c0102aa3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aae:	8b 00                	mov    (%eax),%eax
}
c0102ab0:	5d                   	pop    %ebp
c0102ab1:	c3                   	ret    

c0102ab2 <__intr_save>:
__intr_save(void) {
c0102ab2:	55                   	push   %ebp
c0102ab3:	89 e5                	mov    %esp,%ebp
c0102ab5:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102ab8:	9c                   	pushf  
c0102ab9:	58                   	pop    %eax
c0102aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102ac0:	25 00 02 00 00       	and    $0x200,%eax
c0102ac5:	85 c0                	test   %eax,%eax
c0102ac7:	74 0c                	je     c0102ad5 <__intr_save+0x23>
        intr_disable();
c0102ac9:	e8 b7 ee ff ff       	call   c0101985 <intr_disable>
        return 1;
c0102ace:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ad3:	eb 05                	jmp    c0102ada <__intr_save+0x28>
    return 0;
c0102ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ada:	c9                   	leave  
c0102adb:	c3                   	ret    

c0102adc <__intr_restore>:
__intr_restore(bool flag) {
c0102adc:	55                   	push   %ebp
c0102add:	89 e5                	mov    %esp,%ebp
c0102adf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ae6:	74 05                	je     c0102aed <__intr_restore+0x11>
        intr_enable();
c0102ae8:	e8 8c ee ff ff       	call   c0101979 <intr_enable>
}
c0102aed:	90                   	nop
c0102aee:	c9                   	leave  
c0102aef:	c3                   	ret    

c0102af0 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102af0:	55                   	push   %ebp
c0102af1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af6:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102af9:	b8 23 00 00 00       	mov    $0x23,%eax
c0102afe:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b00:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b05:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b07:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b0c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b0e:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b13:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b15:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b1a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b1c:	ea 23 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b23
}
c0102b23:	90                   	nop
c0102b24:	5d                   	pop    %ebp
c0102b25:	c3                   	ret    

c0102b26 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b26:	f3 0f 1e fb          	endbr32 
c0102b2a:	55                   	push   %ebp
c0102b2b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b30:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102b35:	90                   	nop
c0102b36:	5d                   	pop    %ebp
c0102b37:	c3                   	ret    

c0102b38 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b38:	f3 0f 1e fb          	endbr32 
c0102b3c:	55                   	push   %ebp
c0102b3d:	89 e5                	mov    %esp,%ebp
c0102b3f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b42:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102b47:	89 04 24             	mov    %eax,(%esp)
c0102b4a:	e8 d7 ff ff ff       	call   c0102b26 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102b4f:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102b56:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b58:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102b5f:	68 00 
c0102b61:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b66:	0f b7 c0             	movzwl %ax,%eax
c0102b69:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102b6f:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b74:	c1 e8 10             	shr    $0x10,%eax
c0102b77:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102b7c:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102b83:	24 f0                	and    $0xf0,%al
c0102b85:	0c 09                	or     $0x9,%al
c0102b87:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102b8c:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102b93:	24 ef                	and    $0xef,%al
c0102b95:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102b9a:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102ba1:	24 9f                	and    $0x9f,%al
c0102ba3:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102ba8:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102baf:	0c 80                	or     $0x80,%al
c0102bb1:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bb6:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bbd:	24 f0                	and    $0xf0,%al
c0102bbf:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bc4:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bcb:	24 ef                	and    $0xef,%al
c0102bcd:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bd2:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bd9:	24 df                	and    $0xdf,%al
c0102bdb:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102be0:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102be7:	0c 40                	or     $0x40,%al
c0102be9:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bee:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bf5:	24 7f                	and    $0x7f,%al
c0102bf7:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bfc:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c01:	c1 e8 18             	shr    $0x18,%eax
c0102c04:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c09:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0102c10:	e8 db fe ff ff       	call   c0102af0 <lgdt>
c0102c15:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c1b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c1f:	0f 00 d8             	ltr    %ax
}
c0102c22:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102c23:	90                   	nop
c0102c24:	c9                   	leave  
c0102c25:	c3                   	ret    

c0102c26 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c26:	f3 0f 1e fb          	endbr32 
c0102c2a:	55                   	push   %ebp
c0102c2b:	89 e5                	mov    %esp,%ebp
c0102c2d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102c30:	c7 05 10 cf 11 c0 30 	movl   $0xc0107030,0xc011cf10
c0102c37:	70 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c3a:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c3f:	8b 00                	mov    (%eax),%eax
c0102c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c45:	c7 04 24 d0 66 10 c0 	movl   $0xc01066d0,(%esp)
c0102c4c:	e8 69 d6 ff ff       	call   c01002ba <cprintf>
    pmm_manager->init();
c0102c51:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c56:	8b 40 04             	mov    0x4(%eax),%eax
c0102c59:	ff d0                	call   *%eax
}
c0102c5b:	90                   	nop
c0102c5c:	c9                   	leave  
c0102c5d:	c3                   	ret    

c0102c5e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c5e:	f3 0f 1e fb          	endbr32 
c0102c62:	55                   	push   %ebp
c0102c63:	89 e5                	mov    %esp,%ebp
c0102c65:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102c68:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c6d:	8b 40 08             	mov    0x8(%eax),%eax
c0102c70:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102c77:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c7a:	89 14 24             	mov    %edx,(%esp)
c0102c7d:	ff d0                	call   *%eax
}
c0102c7f:	90                   	nop
c0102c80:	c9                   	leave  
c0102c81:	c3                   	ret    

c0102c82 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102c82:	f3 0f 1e fb          	endbr32 
c0102c86:	55                   	push   %ebp
c0102c87:	89 e5                	mov    %esp,%ebp
c0102c89:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c93:	e8 1a fe ff ff       	call   c0102ab2 <__intr_save>
c0102c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102c9b:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102ca0:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ca3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ca6:	89 14 24             	mov    %edx,(%esp)
c0102ca9:	ff d0                	call   *%eax
c0102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cb1:	89 04 24             	mov    %eax,(%esp)
c0102cb4:	e8 23 fe ff ff       	call   c0102adc <__intr_restore>
    return page;
c0102cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102cbc:	c9                   	leave  
c0102cbd:	c3                   	ret    

c0102cbe <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cbe:	f3 0f 1e fb          	endbr32 
c0102cc2:	55                   	push   %ebp
c0102cc3:	89 e5                	mov    %esp,%ebp
c0102cc5:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cc8:	e8 e5 fd ff ff       	call   c0102ab2 <__intr_save>
c0102ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102cd0:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102cd5:	8b 40 10             	mov    0x10(%eax),%eax
c0102cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102cdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ce2:	89 14 24             	mov    %edx,(%esp)
c0102ce5:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cea:	89 04 24             	mov    %eax,(%esp)
c0102ced:	e8 ea fd ff ff       	call   c0102adc <__intr_restore>
}
c0102cf2:	90                   	nop
c0102cf3:	c9                   	leave  
c0102cf4:	c3                   	ret    

c0102cf5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102cf5:	f3 0f 1e fb          	endbr32 
c0102cf9:	55                   	push   %ebp
c0102cfa:	89 e5                	mov    %esp,%ebp
c0102cfc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cff:	e8 ae fd ff ff       	call   c0102ab2 <__intr_save>
c0102d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d07:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d0c:	8b 40 14             	mov    0x14(%eax),%eax
c0102d0f:	ff d0                	call   *%eax
c0102d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d17:	89 04 24             	mov    %eax,(%esp)
c0102d1a:	e8 bd fd ff ff       	call   c0102adc <__intr_restore>
    return ret;
c0102d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d22:	c9                   	leave  
c0102d23:	c3                   	ret    

c0102d24 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d24:	f3 0f 1e fb          	endbr32 
c0102d28:	55                   	push   %ebp
c0102d29:	89 e5                	mov    %esp,%ebp
c0102d2b:	57                   	push   %edi
c0102d2c:	56                   	push   %esi
c0102d2d:	53                   	push   %ebx
c0102d2e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d34:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d49:	c7 04 24 e7 66 10 c0 	movl   $0xc01066e7,(%esp)
c0102d50:	e8 65 d5 ff ff       	call   c01002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d55:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d5c:	e9 1a 01 00 00       	jmp    c0102e7b <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d64:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d67:	89 d0                	mov    %edx,%eax
c0102d69:	c1 e0 02             	shl    $0x2,%eax
c0102d6c:	01 d0                	add    %edx,%eax
c0102d6e:	c1 e0 02             	shl    $0x2,%eax
c0102d71:	01 c8                	add    %ecx,%eax
c0102d73:	8b 50 08             	mov    0x8(%eax),%edx
c0102d76:	8b 40 04             	mov    0x4(%eax),%eax
c0102d79:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102d7c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d85:	89 d0                	mov    %edx,%eax
c0102d87:	c1 e0 02             	shl    $0x2,%eax
c0102d8a:	01 d0                	add    %edx,%eax
c0102d8c:	c1 e0 02             	shl    $0x2,%eax
c0102d8f:	01 c8                	add    %ecx,%eax
c0102d91:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102d94:	8b 58 10             	mov    0x10(%eax),%ebx
c0102d97:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d9a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d9d:	01 c8                	add    %ecx,%eax
c0102d9f:	11 da                	adc    %ebx,%edx
c0102da1:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102da4:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102da7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102daa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dad:	89 d0                	mov    %edx,%eax
c0102daf:	c1 e0 02             	shl    $0x2,%eax
c0102db2:	01 d0                	add    %edx,%eax
c0102db4:	c1 e0 02             	shl    $0x2,%eax
c0102db7:	01 c8                	add    %ecx,%eax
c0102db9:	83 c0 14             	add    $0x14,%eax
c0102dbc:	8b 00                	mov    (%eax),%eax
c0102dbe:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102dc1:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102dc4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102dc7:	83 c0 ff             	add    $0xffffffff,%eax
c0102dca:	83 d2 ff             	adc    $0xffffffff,%edx
c0102dcd:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102dd3:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102dd9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ddc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ddf:	89 d0                	mov    %edx,%eax
c0102de1:	c1 e0 02             	shl    $0x2,%eax
c0102de4:	01 d0                	add    %edx,%eax
c0102de6:	c1 e0 02             	shl    $0x2,%eax
c0102de9:	01 c8                	add    %ecx,%eax
c0102deb:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102dee:	8b 58 10             	mov    0x10(%eax),%ebx
c0102df1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102df4:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102df8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102dfe:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102e04:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102e08:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102e0c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e0f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e16:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102e1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e1e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102e22:	c7 04 24 f4 66 10 c0 	movl   $0xc01066f4,(%esp)
c0102e29:	e8 8c d4 ff ff       	call   c01002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e2e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e34:	89 d0                	mov    %edx,%eax
c0102e36:	c1 e0 02             	shl    $0x2,%eax
c0102e39:	01 d0                	add    %edx,%eax
c0102e3b:	c1 e0 02             	shl    $0x2,%eax
c0102e3e:	01 c8                	add    %ecx,%eax
c0102e40:	83 c0 14             	add    $0x14,%eax
c0102e43:	8b 00                	mov    (%eax),%eax
c0102e45:	83 f8 01             	cmp    $0x1,%eax
c0102e48:	75 2e                	jne    c0102e78 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e50:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102e53:	89 d0                	mov    %edx,%eax
c0102e55:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102e58:	73 1e                	jae    c0102e78 <page_init+0x154>
c0102e5a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102e5f:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e64:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102e67:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102e6a:	72 0c                	jb     c0102e78 <page_init+0x154>
                maxpa = end;
c0102e6c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e6f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e72:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e78:	ff 45 dc             	incl   -0x24(%ebp)
c0102e7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e7e:	8b 00                	mov    (%eax),%eax
c0102e80:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102e83:	0f 8c d8 fe ff ff    	jl     c0102d61 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e89:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102e8e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e93:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102e96:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102e99:	73 0e                	jae    c0102ea9 <page_init+0x185>
        maxpa = KMEMSIZE;
c0102e9b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102ea2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102eac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102eaf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102eb3:	c1 ea 0c             	shr    $0xc,%edx
c0102eb6:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102ebb:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102ec2:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102ec7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102eca:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ecd:	01 d0                	add    %edx,%eax
c0102ecf:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102ed2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ed5:	ba 00 00 00 00       	mov    $0x0,%edx
c0102eda:	f7 75 c0             	divl   -0x40(%ebp)
c0102edd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ee0:	29 d0                	sub    %edx,%eax
c0102ee2:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i ++) {
c0102ee7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102eee:	eb 2f                	jmp    c0102f1f <page_init+0x1fb>
        SetPageReserved(pages + i);
c0102ef0:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102ef6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ef9:	89 d0                	mov    %edx,%eax
c0102efb:	c1 e0 02             	shl    $0x2,%eax
c0102efe:	01 d0                	add    %edx,%eax
c0102f00:	c1 e0 02             	shl    $0x2,%eax
c0102f03:	01 c8                	add    %ecx,%eax
c0102f05:	83 c0 04             	add    $0x4,%eax
c0102f08:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102f0f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f12:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f15:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f18:	0f ab 10             	bts    %edx,(%eax)
}
c0102f1b:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0102f1c:	ff 45 dc             	incl   -0x24(%ebp)
c0102f1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f22:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102f27:	39 c2                	cmp    %eax,%edx
c0102f29:	72 c5                	jb     c0102ef0 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f2b:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0102f31:	89 d0                	mov    %edx,%eax
c0102f33:	c1 e0 02             	shl    $0x2,%eax
c0102f36:	01 d0                	add    %edx,%eax
c0102f38:	c1 e0 02             	shl    $0x2,%eax
c0102f3b:	89 c2                	mov    %eax,%edx
c0102f3d:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102f42:	01 d0                	add    %edx,%eax
c0102f44:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102f47:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102f4e:	77 23                	ja     c0102f73 <page_init+0x24f>
c0102f50:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f53:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102f57:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0102f5e:	c0 
c0102f5f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102f66:	00 
c0102f67:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0102f6e:	e8 b3 d4 ff ff       	call   c0100426 <__panic>
c0102f73:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f76:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f7b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f7e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f85:	e9 4b 01 00 00       	jmp    c01030d5 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f8a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f90:	89 d0                	mov    %edx,%eax
c0102f92:	c1 e0 02             	shl    $0x2,%eax
c0102f95:	01 d0                	add    %edx,%eax
c0102f97:	c1 e0 02             	shl    $0x2,%eax
c0102f9a:	01 c8                	add    %ecx,%eax
c0102f9c:	8b 50 08             	mov    0x8(%eax),%edx
c0102f9f:	8b 40 04             	mov    0x4(%eax),%eax
c0102fa2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fa5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fa8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fae:	89 d0                	mov    %edx,%eax
c0102fb0:	c1 e0 02             	shl    $0x2,%eax
c0102fb3:	01 d0                	add    %edx,%eax
c0102fb5:	c1 e0 02             	shl    $0x2,%eax
c0102fb8:	01 c8                	add    %ecx,%eax
c0102fba:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fbd:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fc3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fc6:	01 c8                	add    %ecx,%eax
c0102fc8:	11 da                	adc    %ebx,%edx
c0102fca:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102fcd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102fd0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fd6:	89 d0                	mov    %edx,%eax
c0102fd8:	c1 e0 02             	shl    $0x2,%eax
c0102fdb:	01 d0                	add    %edx,%eax
c0102fdd:	c1 e0 02             	shl    $0x2,%eax
c0102fe0:	01 c8                	add    %ecx,%eax
c0102fe2:	83 c0 14             	add    $0x14,%eax
c0102fe5:	8b 00                	mov    (%eax),%eax
c0102fe7:	83 f8 01             	cmp    $0x1,%eax
c0102fea:	0f 85 e2 00 00 00    	jne    c01030d2 <page_init+0x3ae>
            if (begin < freemem) {
c0102ff0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ff3:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ff8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102ffb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0102ffe:	19 d1                	sbb    %edx,%ecx
c0103000:	73 0d                	jae    c010300f <page_init+0x2eb>
                begin = freemem;
c0103002:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103005:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103008:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010300f:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103014:	b8 00 00 00 00       	mov    $0x0,%eax
c0103019:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c010301c:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010301f:	73 0e                	jae    c010302f <page_init+0x30b>
                end = KMEMSIZE;
c0103021:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103028:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010302f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103032:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103035:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103038:	89 d0                	mov    %edx,%eax
c010303a:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010303d:	0f 83 8f 00 00 00    	jae    c01030d2 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c0103043:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010304a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010304d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103050:	01 d0                	add    %edx,%eax
c0103052:	48                   	dec    %eax
c0103053:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103056:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103059:	ba 00 00 00 00       	mov    $0x0,%edx
c010305e:	f7 75 b0             	divl   -0x50(%ebp)
c0103061:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103064:	29 d0                	sub    %edx,%eax
c0103066:	ba 00 00 00 00       	mov    $0x0,%edx
c010306b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010306e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103071:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103074:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103077:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010307a:	ba 00 00 00 00       	mov    $0x0,%edx
c010307f:	89 c3                	mov    %eax,%ebx
c0103081:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103087:	89 de                	mov    %ebx,%esi
c0103089:	89 d0                	mov    %edx,%eax
c010308b:	83 e0 00             	and    $0x0,%eax
c010308e:	89 c7                	mov    %eax,%edi
c0103090:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103093:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103096:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103099:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010309c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010309f:	89 d0                	mov    %edx,%eax
c01030a1:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01030a4:	73 2c                	jae    c01030d2 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01030a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01030ac:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01030af:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01030b2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030b6:	c1 ea 0c             	shr    $0xc,%edx
c01030b9:	89 c3                	mov    %eax,%ebx
c01030bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030be:	89 04 24             	mov    %eax,(%esp)
c01030c1:	e8 bb f8 ff ff       	call   c0102981 <pa2page>
c01030c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01030ca:	89 04 24             	mov    %eax,(%esp)
c01030cd:	e8 8c fb ff ff       	call   c0102c5e <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01030d2:	ff 45 dc             	incl   -0x24(%ebp)
c01030d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030d8:	8b 00                	mov    (%eax),%eax
c01030da:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030dd:	0f 8c a7 fe ff ff    	jl     c0102f8a <page_init+0x266>
                }
            }
        }
    }
}
c01030e3:	90                   	nop
c01030e4:	90                   	nop
c01030e5:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01030eb:	5b                   	pop    %ebx
c01030ec:	5e                   	pop    %esi
c01030ed:	5f                   	pop    %edi
c01030ee:	5d                   	pop    %ebp
c01030ef:	c3                   	ret    

c01030f0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01030f0:	f3 0f 1e fb          	endbr32 
c01030f4:	55                   	push   %ebp
c01030f5:	89 e5                	mov    %esp,%ebp
c01030f7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01030fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030fd:	33 45 14             	xor    0x14(%ebp),%eax
c0103100:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103105:	85 c0                	test   %eax,%eax
c0103107:	74 24                	je     c010312d <boot_map_segment+0x3d>
c0103109:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103110:	c0 
c0103111:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103118:	c0 
c0103119:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103120:	00 
c0103121:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103128:	e8 f9 d2 ff ff       	call   c0100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010312d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103134:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103137:	25 ff 0f 00 00       	and    $0xfff,%eax
c010313c:	89 c2                	mov    %eax,%edx
c010313e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103141:	01 c2                	add    %eax,%edx
c0103143:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103146:	01 d0                	add    %edx,%eax
c0103148:	48                   	dec    %eax
c0103149:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010314c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010314f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103154:	f7 75 f0             	divl   -0x10(%ebp)
c0103157:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010315a:	29 d0                	sub    %edx,%eax
c010315c:	c1 e8 0c             	shr    $0xc,%eax
c010315f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103162:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103165:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103168:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010316b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103170:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103173:	8b 45 14             	mov    0x14(%ebp),%eax
c0103176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010317c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103181:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103184:	eb 68                	jmp    c01031ee <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103186:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010318d:	00 
c010318e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103195:	8b 45 08             	mov    0x8(%ebp),%eax
c0103198:	89 04 24             	mov    %eax,(%esp)
c010319b:	e8 8a 01 00 00       	call   c010332a <get_pte>
c01031a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01031a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01031a7:	75 24                	jne    c01031cd <boot_map_segment+0xdd>
c01031a9:	c7 44 24 0c 82 67 10 	movl   $0xc0106782,0xc(%esp)
c01031b0:	c0 
c01031b1:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01031b8:	c0 
c01031b9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01031c0:	00 
c01031c1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01031c8:	e8 59 d2 ff ff       	call   c0100426 <__panic>
        *ptep = pa | PTE_P | perm;
c01031cd:	8b 45 14             	mov    0x14(%ebp),%eax
c01031d0:	0b 45 18             	or     0x18(%ebp),%eax
c01031d3:	83 c8 01             	or     $0x1,%eax
c01031d6:	89 c2                	mov    %eax,%edx
c01031d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031db:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031dd:	ff 4d f4             	decl   -0xc(%ebp)
c01031e0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031e7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01031ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031f2:	75 92                	jne    c0103186 <boot_map_segment+0x96>
    }
}
c01031f4:	90                   	nop
c01031f5:	90                   	nop
c01031f6:	c9                   	leave  
c01031f7:	c3                   	ret    

c01031f8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01031f8:	f3 0f 1e fb          	endbr32 
c01031fc:	55                   	push   %ebp
c01031fd:	89 e5                	mov    %esp,%ebp
c01031ff:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103209:	e8 74 fa ff ff       	call   c0102c82 <alloc_pages>
c010320e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103215:	75 1c                	jne    c0103233 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c0103217:	c7 44 24 08 8f 67 10 	movl   $0xc010678f,0x8(%esp)
c010321e:	c0 
c010321f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103226:	00 
c0103227:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010322e:	e8 f3 d1 ff ff       	call   c0100426 <__panic>
    }
    return page2kva(p);
c0103233:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103236:	89 04 24             	mov    %eax,(%esp)
c0103239:	e8 92 f7 ff ff       	call   c01029d0 <page2kva>
}
c010323e:	c9                   	leave  
c010323f:	c3                   	ret    

c0103240 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103240:	f3 0f 1e fb          	endbr32 
c0103244:	55                   	push   %ebp
c0103245:	89 e5                	mov    %esp,%ebp
c0103247:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010324a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010324f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103252:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103259:	77 23                	ja     c010327e <pmm_init+0x3e>
c010325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010325e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103262:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103269:	c0 
c010326a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103271:	00 
c0103272:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103279:	e8 a8 d1 ff ff       	call   c0100426 <__panic>
c010327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103281:	05 00 00 00 40       	add    $0x40000000,%eax
c0103286:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010328b:	e8 96 f9 ff ff       	call   c0102c26 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103290:	e8 8f fa ff ff       	call   c0102d24 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103295:	e8 64 02 00 00       	call   c01034fe <check_alloc_page>

    check_pgdir();
c010329a:	e8 82 02 00 00       	call   c0103521 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010329f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032a7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01032ae:	77 23                	ja     c01032d3 <pmm_init+0x93>
c01032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01032b7:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c01032be:	c0 
c01032bf:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01032c6:	00 
c01032c7:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01032ce:	e8 53 d1 ff ff       	call   c0100426 <__panic>
c01032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d6:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01032dc:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032e1:	05 ac 0f 00 00       	add    $0xfac,%eax
c01032e6:	83 ca 03             	or     $0x3,%edx
c01032e9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01032eb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032f0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01032f7:	00 
c01032f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01032ff:	00 
c0103300:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103307:	38 
c0103308:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010330f:	c0 
c0103310:	89 04 24             	mov    %eax,(%esp)
c0103313:	e8 d8 fd ff ff       	call   c01030f0 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103318:	e8 1b f8 ff ff       	call   c0102b38 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010331d:	e8 9f 08 00 00       	call   c0103bc1 <check_boot_pgdir>

    print_pgdir();
c0103322:	e8 24 0d 00 00       	call   c010404b <print_pgdir>

}
c0103327:	90                   	nop
c0103328:	c9                   	leave  
c0103329:	c3                   	ret    

c010332a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010332a:	f3 0f 1e fb          	endbr32 
c010332e:	55                   	push   %ebp
c010332f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0103331:	90                   	nop
c0103332:	5d                   	pop    %ebp
c0103333:	c3                   	ret    

c0103334 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103334:	f3 0f 1e fb          	endbr32 
c0103338:	55                   	push   %ebp
c0103339:	89 e5                	mov    %esp,%ebp
c010333b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010333e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103345:	00 
c0103346:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103349:	89 44 24 04          	mov    %eax,0x4(%esp)
c010334d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103350:	89 04 24             	mov    %eax,(%esp)
c0103353:	e8 d2 ff ff ff       	call   c010332a <get_pte>
c0103358:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010335b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010335f:	74 08                	je     c0103369 <get_page+0x35>
        *ptep_store = ptep;
c0103361:	8b 45 10             	mov    0x10(%ebp),%eax
c0103364:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103367:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010336d:	74 1b                	je     c010338a <get_page+0x56>
c010336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103372:	8b 00                	mov    (%eax),%eax
c0103374:	83 e0 01             	and    $0x1,%eax
c0103377:	85 c0                	test   %eax,%eax
c0103379:	74 0f                	je     c010338a <get_page+0x56>
        return pte2page(*ptep);
c010337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337e:	8b 00                	mov    (%eax),%eax
c0103380:	89 04 24             	mov    %eax,(%esp)
c0103383:	e8 9c f6 ff ff       	call   c0102a24 <pte2page>
c0103388:	eb 05                	jmp    c010338f <get_page+0x5b>
    }
    return NULL;
c010338a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010338f:	c9                   	leave  
c0103390:	c3                   	ret    

c0103391 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103391:	55                   	push   %ebp
c0103392:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103394:	90                   	nop
c0103395:	5d                   	pop    %ebp
c0103396:	c3                   	ret    

c0103397 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103397:	f3 0f 1e fb          	endbr32 
c010339b:	55                   	push   %ebp
c010339c:	89 e5                	mov    %esp,%ebp
c010339e:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01033a8:	00 
c01033a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b3:	89 04 24             	mov    %eax,(%esp)
c01033b6:	e8 6f ff ff ff       	call   c010332a <get_pte>
c01033bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01033be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01033c2:	74 19                	je     c01033dd <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c01033c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033c7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d5:	89 04 24             	mov    %eax,(%esp)
c01033d8:	e8 b4 ff ff ff       	call   c0103391 <page_remove_pte>
    }
}
c01033dd:	90                   	nop
c01033de:	c9                   	leave  
c01033df:	c3                   	ret    

c01033e0 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01033e0:	f3 0f 1e fb          	endbr32 
c01033e4:	55                   	push   %ebp
c01033e5:	89 e5                	mov    %esp,%ebp
c01033e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01033ea:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01033f1:	00 
c01033f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01033f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033fc:	89 04 24             	mov    %eax,(%esp)
c01033ff:	e8 26 ff ff ff       	call   c010332a <get_pte>
c0103404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010340b:	75 0a                	jne    c0103417 <page_insert+0x37>
        return -E_NO_MEM;
c010340d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103412:	e9 84 00 00 00       	jmp    c010349b <page_insert+0xbb>
    }
    page_ref_inc(page);
c0103417:	8b 45 0c             	mov    0xc(%ebp),%eax
c010341a:	89 04 24             	mov    %eax,(%esp)
c010341d:	e8 62 f6 ff ff       	call   c0102a84 <page_ref_inc>
    if (*ptep & PTE_P) {
c0103422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103425:	8b 00                	mov    (%eax),%eax
c0103427:	83 e0 01             	and    $0x1,%eax
c010342a:	85 c0                	test   %eax,%eax
c010342c:	74 3e                	je     c010346c <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c010342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103431:	8b 00                	mov    (%eax),%eax
c0103433:	89 04 24             	mov    %eax,(%esp)
c0103436:	e8 e9 f5 ff ff       	call   c0102a24 <pte2page>
c010343b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103441:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103444:	75 0d                	jne    c0103453 <page_insert+0x73>
            page_ref_dec(page);
c0103446:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103449:	89 04 24             	mov    %eax,(%esp)
c010344c:	e8 4a f6 ff ff       	call   c0102a9b <page_ref_dec>
c0103451:	eb 19                	jmp    c010346c <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103456:	89 44 24 08          	mov    %eax,0x8(%esp)
c010345a:	8b 45 10             	mov    0x10(%ebp),%eax
c010345d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103461:	8b 45 08             	mov    0x8(%ebp),%eax
c0103464:	89 04 24             	mov    %eax,(%esp)
c0103467:	e8 25 ff ff ff       	call   c0103391 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010346c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010346f:	89 04 24             	mov    %eax,(%esp)
c0103472:	e8 f4 f4 ff ff       	call   c010296b <page2pa>
c0103477:	0b 45 14             	or     0x14(%ebp),%eax
c010347a:	83 c8 01             	or     $0x1,%eax
c010347d:	89 c2                	mov    %eax,%edx
c010347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103482:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103484:	8b 45 10             	mov    0x10(%ebp),%eax
c0103487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010348b:	8b 45 08             	mov    0x8(%ebp),%eax
c010348e:	89 04 24             	mov    %eax,(%esp)
c0103491:	e8 07 00 00 00       	call   c010349d <tlb_invalidate>
    return 0;
c0103496:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010349b:	c9                   	leave  
c010349c:	c3                   	ret    

c010349d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010349d:	f3 0f 1e fb          	endbr32 
c01034a1:	55                   	push   %ebp
c01034a2:	89 e5                	mov    %esp,%ebp
c01034a4:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01034a7:	0f 20 d8             	mov    %cr3,%eax
c01034aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01034ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01034b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034b6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01034bd:	77 23                	ja     c01034e2 <tlb_invalidate+0x45>
c01034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034c6:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c01034cd:	c0 
c01034ce:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c01034d5:	00 
c01034d6:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01034dd:	e8 44 cf ff ff       	call   c0100426 <__panic>
c01034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e5:	05 00 00 00 40       	add    $0x40000000,%eax
c01034ea:	39 d0                	cmp    %edx,%eax
c01034ec:	75 0d                	jne    c01034fb <tlb_invalidate+0x5e>
        invlpg((void *)la);
c01034ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034f7:	0f 01 38             	invlpg (%eax)
}
c01034fa:	90                   	nop
    }
}
c01034fb:	90                   	nop
c01034fc:	c9                   	leave  
c01034fd:	c3                   	ret    

c01034fe <check_alloc_page>:

static void
check_alloc_page(void) {
c01034fe:	f3 0f 1e fb          	endbr32 
c0103502:	55                   	push   %ebp
c0103503:	89 e5                	mov    %esp,%ebp
c0103505:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103508:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c010350d:	8b 40 18             	mov    0x18(%eax),%eax
c0103510:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103512:	c7 04 24 a8 67 10 c0 	movl   $0xc01067a8,(%esp)
c0103519:	e8 9c cd ff ff       	call   c01002ba <cprintf>
}
c010351e:	90                   	nop
c010351f:	c9                   	leave  
c0103520:	c3                   	ret    

c0103521 <check_pgdir>:

static void
check_pgdir(void) {
c0103521:	f3 0f 1e fb          	endbr32 
c0103525:	55                   	push   %ebp
c0103526:	89 e5                	mov    %esp,%ebp
c0103528:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010352b:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103530:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103535:	76 24                	jbe    c010355b <check_pgdir+0x3a>
c0103537:	c7 44 24 0c c7 67 10 	movl   $0xc01067c7,0xc(%esp)
c010353e:	c0 
c010353f:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103546:	c0 
c0103547:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c010354e:	00 
c010354f:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103556:	e8 cb ce ff ff       	call   c0100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010355b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103560:	85 c0                	test   %eax,%eax
c0103562:	74 0e                	je     c0103572 <check_pgdir+0x51>
c0103564:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103569:	25 ff 0f 00 00       	and    $0xfff,%eax
c010356e:	85 c0                	test   %eax,%eax
c0103570:	74 24                	je     c0103596 <check_pgdir+0x75>
c0103572:	c7 44 24 0c e4 67 10 	movl   $0xc01067e4,0xc(%esp)
c0103579:	c0 
c010357a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103581:	c0 
c0103582:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0103589:	00 
c010358a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103591:	e8 90 ce ff ff       	call   c0100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103596:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010359b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035a2:	00 
c01035a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01035aa:	00 
c01035ab:	89 04 24             	mov    %eax,(%esp)
c01035ae:	e8 81 fd ff ff       	call   c0103334 <get_page>
c01035b3:	85 c0                	test   %eax,%eax
c01035b5:	74 24                	je     c01035db <check_pgdir+0xba>
c01035b7:	c7 44 24 0c 1c 68 10 	movl   $0xc010681c,0xc(%esp)
c01035be:	c0 
c01035bf:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01035c6:	c0 
c01035c7:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c01035ce:	00 
c01035cf:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01035d6:	e8 4b ce ff ff       	call   c0100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01035db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035e2:	e8 9b f6 ff ff       	call   c0102c82 <alloc_pages>
c01035e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01035ea:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01035ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01035f6:	00 
c01035f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035fe:	00 
c01035ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103602:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103606:	89 04 24             	mov    %eax,(%esp)
c0103609:	e8 d2 fd ff ff       	call   c01033e0 <page_insert>
c010360e:	85 c0                	test   %eax,%eax
c0103610:	74 24                	je     c0103636 <check_pgdir+0x115>
c0103612:	c7 44 24 0c 44 68 10 	movl   $0xc0106844,0xc(%esp)
c0103619:	c0 
c010361a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103621:	c0 
c0103622:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c0103629:	00 
c010362a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103631:	e8 f0 cd ff ff       	call   c0100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103636:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010363b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103642:	00 
c0103643:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010364a:	00 
c010364b:	89 04 24             	mov    %eax,(%esp)
c010364e:	e8 d7 fc ff ff       	call   c010332a <get_pte>
c0103653:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103656:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010365a:	75 24                	jne    c0103680 <check_pgdir+0x15f>
c010365c:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c0103663:	c0 
c0103664:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010366b:	c0 
c010366c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0103673:	00 
c0103674:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010367b:	e8 a6 cd ff ff       	call   c0100426 <__panic>
    assert(pte2page(*ptep) == p1);
c0103680:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103683:	8b 00                	mov    (%eax),%eax
c0103685:	89 04 24             	mov    %eax,(%esp)
c0103688:	e8 97 f3 ff ff       	call   c0102a24 <pte2page>
c010368d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103690:	74 24                	je     c01036b6 <check_pgdir+0x195>
c0103692:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103699:	c0 
c010369a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01036a1:	c0 
c01036a2:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c01036a9:	00 
c01036aa:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01036b1:	e8 70 cd ff ff       	call   c0100426 <__panic>
    assert(page_ref(p1) == 1);
c01036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b9:	89 04 24             	mov    %eax,(%esp)
c01036bc:	e8 b9 f3 ff ff       	call   c0102a7a <page_ref>
c01036c1:	83 f8 01             	cmp    $0x1,%eax
c01036c4:	74 24                	je     c01036ea <check_pgdir+0x1c9>
c01036c6:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c01036cd:	c0 
c01036ce:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01036d5:	c0 
c01036d6:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c01036dd:	00 
c01036de:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01036e5:	e8 3c cd ff ff       	call   c0100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01036ea:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01036ef:	8b 00                	mov    (%eax),%eax
c01036f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01036f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01036f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036fc:	c1 e8 0c             	shr    $0xc,%eax
c01036ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103702:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103707:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010370a:	72 23                	jb     c010372f <check_pgdir+0x20e>
c010370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010370f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103713:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c010371a:	c0 
c010371b:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0103722:	00 
c0103723:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010372a:	e8 f7 cc ff ff       	call   c0100426 <__panic>
c010372f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103732:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103737:	83 c0 04             	add    $0x4,%eax
c010373a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010373d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103742:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103749:	00 
c010374a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103751:	00 
c0103752:	89 04 24             	mov    %eax,(%esp)
c0103755:	e8 d0 fb ff ff       	call   c010332a <get_pte>
c010375a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010375d:	74 24                	je     c0103783 <check_pgdir+0x262>
c010375f:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c0103766:	c0 
c0103767:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010376e:	c0 
c010376f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0103776:	00 
c0103777:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010377e:	e8 a3 cc ff ff       	call   c0100426 <__panic>

    p2 = alloc_page();
c0103783:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010378a:	e8 f3 f4 ff ff       	call   c0102c82 <alloc_pages>
c010378f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103792:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103797:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010379e:	00 
c010379f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01037a6:	00 
c01037a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01037aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01037ae:	89 04 24             	mov    %eax,(%esp)
c01037b1:	e8 2a fc ff ff       	call   c01033e0 <page_insert>
c01037b6:	85 c0                	test   %eax,%eax
c01037b8:	74 24                	je     c01037de <check_pgdir+0x2bd>
c01037ba:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01037c1:	c0 
c01037c2:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01037c9:	c0 
c01037ca:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c01037d1:	00 
c01037d2:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01037d9:	e8 48 cc ff ff       	call   c0100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01037de:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037ea:	00 
c01037eb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037f2:	00 
c01037f3:	89 04 24             	mov    %eax,(%esp)
c01037f6:	e8 2f fb ff ff       	call   c010332a <get_pte>
c01037fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103802:	75 24                	jne    c0103828 <check_pgdir+0x307>
c0103804:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c010380b:	c0 
c010380c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103813:	c0 
c0103814:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c010381b:	00 
c010381c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103823:	e8 fe cb ff ff       	call   c0100426 <__panic>
    assert(*ptep & PTE_U);
c0103828:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010382b:	8b 00                	mov    (%eax),%eax
c010382d:	83 e0 04             	and    $0x4,%eax
c0103830:	85 c0                	test   %eax,%eax
c0103832:	75 24                	jne    c0103858 <check_pgdir+0x337>
c0103834:	c7 44 24 0c 58 69 10 	movl   $0xc0106958,0xc(%esp)
c010383b:	c0 
c010383c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103843:	c0 
c0103844:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c010384b:	00 
c010384c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103853:	e8 ce cb ff ff       	call   c0100426 <__panic>
    assert(*ptep & PTE_W);
c0103858:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010385b:	8b 00                	mov    (%eax),%eax
c010385d:	83 e0 02             	and    $0x2,%eax
c0103860:	85 c0                	test   %eax,%eax
c0103862:	75 24                	jne    c0103888 <check_pgdir+0x367>
c0103864:	c7 44 24 0c 66 69 10 	movl   $0xc0106966,0xc(%esp)
c010386b:	c0 
c010386c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103873:	c0 
c0103874:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c010387b:	00 
c010387c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103883:	e8 9e cb ff ff       	call   c0100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103888:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010388d:	8b 00                	mov    (%eax),%eax
c010388f:	83 e0 04             	and    $0x4,%eax
c0103892:	85 c0                	test   %eax,%eax
c0103894:	75 24                	jne    c01038ba <check_pgdir+0x399>
c0103896:	c7 44 24 0c 74 69 10 	movl   $0xc0106974,0xc(%esp)
c010389d:	c0 
c010389e:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038a5:	c0 
c01038a6:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01038ad:	00 
c01038ae:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038b5:	e8 6c cb ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 1);
c01038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038bd:	89 04 24             	mov    %eax,(%esp)
c01038c0:	e8 b5 f1 ff ff       	call   c0102a7a <page_ref>
c01038c5:	83 f8 01             	cmp    $0x1,%eax
c01038c8:	74 24                	je     c01038ee <check_pgdir+0x3cd>
c01038ca:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c01038d1:	c0 
c01038d2:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038d9:	c0 
c01038da:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01038e1:	00 
c01038e2:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038e9:	e8 38 cb ff ff       	call   c0100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01038ee:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01038fa:	00 
c01038fb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103902:	00 
c0103903:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103906:	89 54 24 04          	mov    %edx,0x4(%esp)
c010390a:	89 04 24             	mov    %eax,(%esp)
c010390d:	e8 ce fa ff ff       	call   c01033e0 <page_insert>
c0103912:	85 c0                	test   %eax,%eax
c0103914:	74 24                	je     c010393a <check_pgdir+0x419>
c0103916:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c010391d:	c0 
c010391e:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103925:	c0 
c0103926:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c010392d:	00 
c010392e:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103935:	e8 ec ca ff ff       	call   c0100426 <__panic>
    assert(page_ref(p1) == 2);
c010393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010393d:	89 04 24             	mov    %eax,(%esp)
c0103940:	e8 35 f1 ff ff       	call   c0102a7a <page_ref>
c0103945:	83 f8 02             	cmp    $0x2,%eax
c0103948:	74 24                	je     c010396e <check_pgdir+0x44d>
c010394a:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c0103951:	c0 
c0103952:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103959:	c0 
c010395a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103961:	00 
c0103962:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103969:	e8 b8 ca ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c010396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103971:	89 04 24             	mov    %eax,(%esp)
c0103974:	e8 01 f1 ff ff       	call   c0102a7a <page_ref>
c0103979:	85 c0                	test   %eax,%eax
c010397b:	74 24                	je     c01039a1 <check_pgdir+0x480>
c010397d:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103984:	c0 
c0103985:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010398c:	c0 
c010398d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103994:	00 
c0103995:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010399c:	e8 85 ca ff ff       	call   c0100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01039a1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01039a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039ad:	00 
c01039ae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01039b5:	00 
c01039b6:	89 04 24             	mov    %eax,(%esp)
c01039b9:	e8 6c f9 ff ff       	call   c010332a <get_pte>
c01039be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039c5:	75 24                	jne    c01039eb <check_pgdir+0x4ca>
c01039c7:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c01039ce:	c0 
c01039cf:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01039d6:	c0 
c01039d7:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01039de:	00 
c01039df:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01039e6:	e8 3b ca ff ff       	call   c0100426 <__panic>
    assert(pte2page(*ptep) == p1);
c01039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ee:	8b 00                	mov    (%eax),%eax
c01039f0:	89 04 24             	mov    %eax,(%esp)
c01039f3:	e8 2c f0 ff ff       	call   c0102a24 <pte2page>
c01039f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01039fb:	74 24                	je     c0103a21 <check_pgdir+0x500>
c01039fd:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103a04:	c0 
c0103a05:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a0c:	c0 
c0103a0d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103a14:	00 
c0103a15:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a1c:	e8 05 ca ff ff       	call   c0100426 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a24:	8b 00                	mov    (%eax),%eax
c0103a26:	83 e0 04             	and    $0x4,%eax
c0103a29:	85 c0                	test   %eax,%eax
c0103a2b:	74 24                	je     c0103a51 <check_pgdir+0x530>
c0103a2d:	c7 44 24 0c ec 69 10 	movl   $0xc01069ec,0xc(%esp)
c0103a34:	c0 
c0103a35:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a3c:	c0 
c0103a3d:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103a44:	00 
c0103a45:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a4c:	e8 d5 c9 ff ff       	call   c0100426 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103a51:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a5d:	00 
c0103a5e:	89 04 24             	mov    %eax,(%esp)
c0103a61:	e8 31 f9 ff ff       	call   c0103397 <page_remove>
    assert(page_ref(p1) == 1);
c0103a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a69:	89 04 24             	mov    %eax,(%esp)
c0103a6c:	e8 09 f0 ff ff       	call   c0102a7a <page_ref>
c0103a71:	83 f8 01             	cmp    $0x1,%eax
c0103a74:	74 24                	je     c0103a9a <check_pgdir+0x579>
c0103a76:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c0103a7d:	c0 
c0103a7e:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a85:	c0 
c0103a86:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103a8d:	00 
c0103a8e:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a95:	e8 8c c9 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c0103a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a9d:	89 04 24             	mov    %eax,(%esp)
c0103aa0:	e8 d5 ef ff ff       	call   c0102a7a <page_ref>
c0103aa5:	85 c0                	test   %eax,%eax
c0103aa7:	74 24                	je     c0103acd <check_pgdir+0x5ac>
c0103aa9:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103ab0:	c0 
c0103ab1:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ab8:	c0 
c0103ab9:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103ac0:	00 
c0103ac1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103ac8:	e8 59 c9 ff ff       	call   c0100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103acd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ad2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103ad9:	00 
c0103ada:	89 04 24             	mov    %eax,(%esp)
c0103add:	e8 b5 f8 ff ff       	call   c0103397 <page_remove>
    assert(page_ref(p1) == 0);
c0103ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae5:	89 04 24             	mov    %eax,(%esp)
c0103ae8:	e8 8d ef ff ff       	call   c0102a7a <page_ref>
c0103aed:	85 c0                	test   %eax,%eax
c0103aef:	74 24                	je     c0103b15 <check_pgdir+0x5f4>
c0103af1:	c7 44 24 0c 01 6a 10 	movl   $0xc0106a01,0xc(%esp)
c0103af8:	c0 
c0103af9:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b00:	c0 
c0103b01:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103b08:	00 
c0103b09:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b10:	e8 11 c9 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p2) == 0);
c0103b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b18:	89 04 24             	mov    %eax,(%esp)
c0103b1b:	e8 5a ef ff ff       	call   c0102a7a <page_ref>
c0103b20:	85 c0                	test   %eax,%eax
c0103b22:	74 24                	je     c0103b48 <check_pgdir+0x627>
c0103b24:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103b2b:	c0 
c0103b2c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b33:	c0 
c0103b34:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103b3b:	00 
c0103b3c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b43:	e8 de c8 ff ff       	call   c0100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103b48:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b4d:	8b 00                	mov    (%eax),%eax
c0103b4f:	89 04 24             	mov    %eax,(%esp)
c0103b52:	e8 0b ef ff ff       	call   c0102a62 <pde2page>
c0103b57:	89 04 24             	mov    %eax,(%esp)
c0103b5a:	e8 1b ef ff ff       	call   c0102a7a <page_ref>
c0103b5f:	83 f8 01             	cmp    $0x1,%eax
c0103b62:	74 24                	je     c0103b88 <check_pgdir+0x667>
c0103b64:	c7 44 24 0c 14 6a 10 	movl   $0xc0106a14,0xc(%esp)
c0103b6b:	c0 
c0103b6c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b73:	c0 
c0103b74:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103b7b:	00 
c0103b7c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b83:	e8 9e c8 ff ff       	call   c0100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103b88:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b8d:	8b 00                	mov    (%eax),%eax
c0103b8f:	89 04 24             	mov    %eax,(%esp)
c0103b92:	e8 cb ee ff ff       	call   c0102a62 <pde2page>
c0103b97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b9e:	00 
c0103b9f:	89 04 24             	mov    %eax,(%esp)
c0103ba2:	e8 17 f1 ff ff       	call   c0102cbe <free_pages>
    boot_pgdir[0] = 0;
c0103ba7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103bb2:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103bb9:	e8 fc c6 ff ff       	call   c01002ba <cprintf>
}
c0103bbe:	90                   	nop
c0103bbf:	c9                   	leave  
c0103bc0:	c3                   	ret    

c0103bc1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103bc1:	f3 0f 1e fb          	endbr32 
c0103bc5:	55                   	push   %ebp
c0103bc6:	89 e5                	mov    %esp,%ebp
c0103bc8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103bd2:	e9 ca 00 00 00       	jmp    c0103ca1 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103be0:	c1 e8 0c             	shr    $0xc,%eax
c0103be3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103be6:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103beb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103bee:	72 23                	jb     c0103c13 <check_boot_pgdir+0x52>
c0103bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103bf7:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0103bfe:	c0 
c0103bff:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103c06:	00 
c0103c07:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c0e:	e8 13 c8 ff ff       	call   c0100426 <__panic>
c0103c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c16:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c1b:	89 c2                	mov    %eax,%edx
c0103c1d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c29:	00 
c0103c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c2e:	89 04 24             	mov    %eax,(%esp)
c0103c31:	e8 f4 f6 ff ff       	call   c010332a <get_pte>
c0103c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103c3d:	75 24                	jne    c0103c63 <check_boot_pgdir+0xa2>
c0103c3f:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c0103c46:	c0 
c0103c47:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103c4e:	c0 
c0103c4f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103c56:	00 
c0103c57:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c5e:	e8 c3 c7 ff ff       	call   c0100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c66:	8b 00                	mov    (%eax),%eax
c0103c68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c6d:	89 c2                	mov    %eax,%edx
c0103c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c72:	39 c2                	cmp    %eax,%edx
c0103c74:	74 24                	je     c0103c9a <check_boot_pgdir+0xd9>
c0103c76:	c7 44 24 0c 95 6a 10 	movl   $0xc0106a95,0xc(%esp)
c0103c7d:	c0 
c0103c7e:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103c8d:	00 
c0103c8e:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c95:	e8 8c c7 ff ff       	call   c0100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103c9a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103ca4:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103ca9:	39 c2                	cmp    %eax,%edx
c0103cab:	0f 82 26 ff ff ff    	jb     c0103bd7 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103cb1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103cb6:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103cbb:	8b 00                	mov    (%eax),%eax
c0103cbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cc2:	89 c2                	mov    %eax,%edx
c0103cc4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ccc:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103cd3:	77 23                	ja     c0103cf8 <check_boot_pgdir+0x137>
c0103cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103cdc:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103ce3:	c0 
c0103ce4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103ceb:	00 
c0103cec:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103cf3:	e8 2e c7 ff ff       	call   c0100426 <__panic>
c0103cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cfb:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d00:	39 d0                	cmp    %edx,%eax
c0103d02:	74 24                	je     c0103d28 <check_boot_pgdir+0x167>
c0103d04:	c7 44 24 0c ac 6a 10 	movl   $0xc0106aac,0xc(%esp)
c0103d0b:	c0 
c0103d0c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103d13:	c0 
c0103d14:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103d1b:	00 
c0103d1c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d23:	e8 fe c6 ff ff       	call   c0100426 <__panic>

    assert(boot_pgdir[0] == 0);
c0103d28:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d2d:	8b 00                	mov    (%eax),%eax
c0103d2f:	85 c0                	test   %eax,%eax
c0103d31:	74 24                	je     c0103d57 <check_boot_pgdir+0x196>
c0103d33:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c0103d3a:	c0 
c0103d3b:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103d42:	c0 
c0103d43:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103d4a:	00 
c0103d4b:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d52:	e8 cf c6 ff ff       	call   c0100426 <__panic>

    struct Page *p;
    p = alloc_page();
c0103d57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d5e:	e8 1f ef ff ff       	call   c0102c82 <alloc_pages>
c0103d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d66:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d6b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103d72:	00 
c0103d73:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103d7a:	00 
c0103d7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103d7e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d82:	89 04 24             	mov    %eax,(%esp)
c0103d85:	e8 56 f6 ff ff       	call   c01033e0 <page_insert>
c0103d8a:	85 c0                	test   %eax,%eax
c0103d8c:	74 24                	je     c0103db2 <check_boot_pgdir+0x1f1>
c0103d8e:	c7 44 24 0c f4 6a 10 	movl   $0xc0106af4,0xc(%esp)
c0103d95:	c0 
c0103d96:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103d9d:	c0 
c0103d9e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103da5:	00 
c0103da6:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103dad:	e8 74 c6 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p) == 1);
c0103db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103db5:	89 04 24             	mov    %eax,(%esp)
c0103db8:	e8 bd ec ff ff       	call   c0102a7a <page_ref>
c0103dbd:	83 f8 01             	cmp    $0x1,%eax
c0103dc0:	74 24                	je     c0103de6 <check_boot_pgdir+0x225>
c0103dc2:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c0103dc9:	c0 
c0103dca:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103dd1:	c0 
c0103dd2:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103dd9:	00 
c0103dda:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103de1:	e8 40 c6 ff ff       	call   c0100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103de6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103deb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103df2:	00 
c0103df3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103dfa:	00 
c0103dfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103dfe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e02:	89 04 24             	mov    %eax,(%esp)
c0103e05:	e8 d6 f5 ff ff       	call   c01033e0 <page_insert>
c0103e0a:	85 c0                	test   %eax,%eax
c0103e0c:	74 24                	je     c0103e32 <check_boot_pgdir+0x271>
c0103e0e:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0103e15:	c0 
c0103e16:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e1d:	c0 
c0103e1e:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103e25:	00 
c0103e26:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e2d:	e8 f4 c5 ff ff       	call   c0100426 <__panic>
    assert(page_ref(p) == 2);
c0103e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e35:	89 04 24             	mov    %eax,(%esp)
c0103e38:	e8 3d ec ff ff       	call   c0102a7a <page_ref>
c0103e3d:	83 f8 02             	cmp    $0x2,%eax
c0103e40:	74 24                	je     c0103e66 <check_boot_pgdir+0x2a5>
c0103e42:	c7 44 24 0c 6b 6b 10 	movl   $0xc0106b6b,0xc(%esp)
c0103e49:	c0 
c0103e4a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e51:	c0 
c0103e52:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103e59:	00 
c0103e5a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e61:	e8 c0 c5 ff ff       	call   c0100426 <__panic>

    const char *str = "ucore: Hello world!!";
c0103e66:	c7 45 e8 7c 6b 10 c0 	movl   $0xc0106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e74:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103e7b:	e8 b4 15 00 00       	call   c0105434 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103e80:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103e87:	00 
c0103e88:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103e8f:	e8 1e 16 00 00       	call   c01054b2 <strcmp>
c0103e94:	85 c0                	test   %eax,%eax
c0103e96:	74 24                	je     c0103ebc <check_boot_pgdir+0x2fb>
c0103e98:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0103e9f:	c0 
c0103ea0:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ea7:	c0 
c0103ea8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103eaf:	00 
c0103eb0:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103eb7:	e8 6a c5 ff ff       	call   c0100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ebf:	89 04 24             	mov    %eax,(%esp)
c0103ec2:	e8 09 eb ff ff       	call   c01029d0 <page2kva>
c0103ec7:	05 00 01 00 00       	add    $0x100,%eax
c0103ecc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103ecf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103ed6:	e8 fb 14 00 00       	call   c01053d6 <strlen>
c0103edb:	85 c0                	test   %eax,%eax
c0103edd:	74 24                	je     c0103f03 <check_boot_pgdir+0x342>
c0103edf:	c7 44 24 0c cc 6b 10 	movl   $0xc0106bcc,0xc(%esp)
c0103ee6:	c0 
c0103ee7:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103eee:	c0 
c0103eef:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103ef6:	00 
c0103ef7:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103efe:	e8 23 c5 ff ff       	call   c0100426 <__panic>

    free_page(p);
c0103f03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f0a:	00 
c0103f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f0e:	89 04 24             	mov    %eax,(%esp)
c0103f11:	e8 a8 ed ff ff       	call   c0102cbe <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103f16:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f1b:	8b 00                	mov    (%eax),%eax
c0103f1d:	89 04 24             	mov    %eax,(%esp)
c0103f20:	e8 3d eb ff ff       	call   c0102a62 <pde2page>
c0103f25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f2c:	00 
c0103f2d:	89 04 24             	mov    %eax,(%esp)
c0103f30:	e8 89 ed ff ff       	call   c0102cbe <free_pages>
    boot_pgdir[0] = 0;
c0103f35:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103f40:	c7 04 24 f0 6b 10 c0 	movl   $0xc0106bf0,(%esp)
c0103f47:	e8 6e c3 ff ff       	call   c01002ba <cprintf>
}
c0103f4c:	90                   	nop
c0103f4d:	c9                   	leave  
c0103f4e:	c3                   	ret    

c0103f4f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103f4f:	f3 0f 1e fb          	endbr32 
c0103f53:	55                   	push   %ebp
c0103f54:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f59:	83 e0 04             	and    $0x4,%eax
c0103f5c:	85 c0                	test   %eax,%eax
c0103f5e:	74 04                	je     c0103f64 <perm2str+0x15>
c0103f60:	b0 75                	mov    $0x75,%al
c0103f62:	eb 02                	jmp    c0103f66 <perm2str+0x17>
c0103f64:	b0 2d                	mov    $0x2d,%al
c0103f66:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0103f6b:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f75:	83 e0 02             	and    $0x2,%eax
c0103f78:	85 c0                	test   %eax,%eax
c0103f7a:	74 04                	je     c0103f80 <perm2str+0x31>
c0103f7c:	b0 77                	mov    $0x77,%al
c0103f7e:	eb 02                	jmp    c0103f82 <perm2str+0x33>
c0103f80:	b0 2d                	mov    $0x2d,%al
c0103f82:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c0103f87:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c0103f8e:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c0103f93:	5d                   	pop    %ebp
c0103f94:	c3                   	ret    

c0103f95 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f95:	f3 0f 1e fb          	endbr32 
c0103f99:	55                   	push   %ebp
c0103f9a:	89 e5                	mov    %esp,%ebp
c0103f9c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f9f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fa2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fa5:	72 0d                	jb     c0103fb4 <get_pgtable_items+0x1f>
        return 0;
c0103fa7:	b8 00 00 00 00       	mov    $0x0,%eax
c0103fac:	e9 98 00 00 00       	jmp    c0104049 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103fb1:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0103fb4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fba:	73 18                	jae    c0103fd4 <get_pgtable_items+0x3f>
c0103fbc:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103fc6:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fc9:	01 d0                	add    %edx,%eax
c0103fcb:	8b 00                	mov    (%eax),%eax
c0103fcd:	83 e0 01             	and    $0x1,%eax
c0103fd0:	85 c0                	test   %eax,%eax
c0103fd2:	74 dd                	je     c0103fb1 <get_pgtable_items+0x1c>
    }
    if (start < right) {
c0103fd4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103fda:	73 68                	jae    c0104044 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0103fdc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103fe0:	74 08                	je     c0103fea <get_pgtable_items+0x55>
            *left_store = start;
c0103fe2:	8b 45 18             	mov    0x18(%ebp),%eax
c0103fe5:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fe8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103fea:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fed:	8d 50 01             	lea    0x1(%eax),%edx
c0103ff0:	89 55 10             	mov    %edx,0x10(%ebp)
c0103ff3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ffa:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ffd:	01 d0                	add    %edx,%eax
c0103fff:	8b 00                	mov    (%eax),%eax
c0104001:	83 e0 07             	and    $0x7,%eax
c0104004:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104007:	eb 03                	jmp    c010400c <get_pgtable_items+0x77>
            start ++;
c0104009:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010400c:	8b 45 10             	mov    0x10(%ebp),%eax
c010400f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104012:	73 1d                	jae    c0104031 <get_pgtable_items+0x9c>
c0104014:	8b 45 10             	mov    0x10(%ebp),%eax
c0104017:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010401e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104021:	01 d0                	add    %edx,%eax
c0104023:	8b 00                	mov    (%eax),%eax
c0104025:	83 e0 07             	and    $0x7,%eax
c0104028:	89 c2                	mov    %eax,%edx
c010402a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010402d:	39 c2                	cmp    %eax,%edx
c010402f:	74 d8                	je     c0104009 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c0104031:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104035:	74 08                	je     c010403f <get_pgtable_items+0xaa>
            *right_store = start;
c0104037:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010403a:	8b 55 10             	mov    0x10(%ebp),%edx
c010403d:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010403f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104042:	eb 05                	jmp    c0104049 <get_pgtable_items+0xb4>
    }
    return 0;
c0104044:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104049:	c9                   	leave  
c010404a:	c3                   	ret    

c010404b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010404b:	f3 0f 1e fb          	endbr32 
c010404f:	55                   	push   %ebp
c0104050:	89 e5                	mov    %esp,%ebp
c0104052:	57                   	push   %edi
c0104053:	56                   	push   %esi
c0104054:	53                   	push   %ebx
c0104055:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104058:	c7 04 24 10 6c 10 c0 	movl   $0xc0106c10,(%esp)
c010405f:	e8 56 c2 ff ff       	call   c01002ba <cprintf>
    size_t left, right = 0, perm;
c0104064:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010406b:	e9 fa 00 00 00       	jmp    c010416a <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104073:	89 04 24             	mov    %eax,(%esp)
c0104076:	e8 d4 fe ff ff       	call   c0103f4f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010407b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010407e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104081:	29 d1                	sub    %edx,%ecx
c0104083:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104085:	89 d6                	mov    %edx,%esi
c0104087:	c1 e6 16             	shl    $0x16,%esi
c010408a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010408d:	89 d3                	mov    %edx,%ebx
c010408f:	c1 e3 16             	shl    $0x16,%ebx
c0104092:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104095:	89 d1                	mov    %edx,%ecx
c0104097:	c1 e1 16             	shl    $0x16,%ecx
c010409a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010409d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040a0:	29 d7                	sub    %edx,%edi
c01040a2:	89 fa                	mov    %edi,%edx
c01040a4:	89 44 24 14          	mov    %eax,0x14(%esp)
c01040a8:	89 74 24 10          	mov    %esi,0x10(%esp)
c01040ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01040b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01040b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040b8:	c7 04 24 41 6c 10 c0 	movl   $0xc0106c41,(%esp)
c01040bf:	e8 f6 c1 ff ff       	call   c01002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
c01040c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040c7:	c1 e0 0a             	shl    $0xa,%eax
c01040ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01040cd:	eb 54                	jmp    c0104123 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01040cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040d2:	89 04 24             	mov    %eax,(%esp)
c01040d5:	e8 75 fe ff ff       	call   c0103f4f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01040da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01040dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040e0:	29 d1                	sub    %edx,%ecx
c01040e2:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01040e4:	89 d6                	mov    %edx,%esi
c01040e6:	c1 e6 0c             	shl    $0xc,%esi
c01040e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040ec:	89 d3                	mov    %edx,%ebx
c01040ee:	c1 e3 0c             	shl    $0xc,%ebx
c01040f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040f4:	89 d1                	mov    %edx,%ecx
c01040f6:	c1 e1 0c             	shl    $0xc,%ecx
c01040f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01040fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040ff:	29 d7                	sub    %edx,%edi
c0104101:	89 fa                	mov    %edi,%edx
c0104103:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104107:	89 74 24 10          	mov    %esi,0x10(%esp)
c010410b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010410f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104113:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104117:	c7 04 24 60 6c 10 c0 	movl   $0xc0106c60,(%esp)
c010411e:	e8 97 c1 ff ff       	call   c01002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104123:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104128:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010412b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010412e:	89 d3                	mov    %edx,%ebx
c0104130:	c1 e3 0a             	shl    $0xa,%ebx
c0104133:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104136:	89 d1                	mov    %edx,%ecx
c0104138:	c1 e1 0a             	shl    $0xa,%ecx
c010413b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010413e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104142:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104145:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104149:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010414d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104151:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104155:	89 0c 24             	mov    %ecx,(%esp)
c0104158:	e8 38 fe ff ff       	call   c0103f95 <get_pgtable_items>
c010415d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104160:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104164:	0f 85 65 ff ff ff    	jne    c01040cf <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010416a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010416f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104172:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104175:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104179:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010417c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104180:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104184:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104188:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010418f:	00 
c0104190:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104197:	e8 f9 fd ff ff       	call   c0103f95 <get_pgtable_items>
c010419c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010419f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041a3:	0f 85 c7 fe ff ff    	jne    c0104070 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01041a9:	c7 04 24 84 6c 10 c0 	movl   $0xc0106c84,(%esp)
c01041b0:	e8 05 c1 ff ff       	call   c01002ba <cprintf>
}
c01041b5:	90                   	nop
c01041b6:	83 c4 4c             	add    $0x4c,%esp
c01041b9:	5b                   	pop    %ebx
c01041ba:	5e                   	pop    %esi
c01041bb:	5f                   	pop    %edi
c01041bc:	5d                   	pop    %ebp
c01041bd:	c3                   	ret    

c01041be <page2ppn>:
page2ppn(struct Page *page) {
c01041be:	55                   	push   %ebp
c01041bf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01041c1:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c01041c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01041c9:	29 c2                	sub    %eax,%edx
c01041cb:	89 d0                	mov    %edx,%eax
c01041cd:	c1 f8 02             	sar    $0x2,%eax
c01041d0:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01041d6:	5d                   	pop    %ebp
c01041d7:	c3                   	ret    

c01041d8 <page2pa>:
page2pa(struct Page *page) {
c01041d8:	55                   	push   %ebp
c01041d9:	89 e5                	mov    %esp,%ebp
c01041db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01041de:	8b 45 08             	mov    0x8(%ebp),%eax
c01041e1:	89 04 24             	mov    %eax,(%esp)
c01041e4:	e8 d5 ff ff ff       	call   c01041be <page2ppn>
c01041e9:	c1 e0 0c             	shl    $0xc,%eax
}
c01041ec:	c9                   	leave  
c01041ed:	c3                   	ret    

c01041ee <page_ref>:
page_ref(struct Page *page) {
c01041ee:	55                   	push   %ebp
c01041ef:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01041f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01041f4:	8b 00                	mov    (%eax),%eax
}
c01041f6:	5d                   	pop    %ebp
c01041f7:	c3                   	ret    

c01041f8 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01041f8:	55                   	push   %ebp
c01041f9:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01041fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01041fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104201:	89 10                	mov    %edx,(%eax)
}
c0104203:	90                   	nop
c0104204:	5d                   	pop    %ebp
c0104205:	c3                   	ret    

c0104206 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104206:	f3 0f 1e fb          	endbr32 
c010420a:	55                   	push   %ebp
c010420b:	89 e5                	mov    %esp,%ebp
c010420d:	83 ec 10             	sub    $0x10,%esp
c0104210:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104217:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010421a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010421d:	89 50 04             	mov    %edx,0x4(%eax)
c0104220:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104223:	8b 50 04             	mov    0x4(%eax),%edx
c0104226:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104229:	89 10                	mov    %edx,(%eax)
}
c010422b:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c010422c:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104233:	00 00 00 
}
c0104236:	90                   	nop
c0104237:	c9                   	leave  
c0104238:	c3                   	ret    

c0104239 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104239:	f3 0f 1e fb          	endbr32 
c010423d:	55                   	push   %ebp
c010423e:	89 e5                	mov    %esp,%ebp
c0104240:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104243:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104247:	75 24                	jne    c010426d <default_init_memmap+0x34>
c0104249:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c0104250:	c0 
c0104251:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104258:	c0 
c0104259:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104260:	00 
c0104261:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104268:	e8 b9 c1 ff ff       	call   c0100426 <__panic>
    struct Page *p = base;
c010426d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104273:	eb 7d                	jmp    c01042f2 <default_init_memmap+0xb9>
        assert(PageReserved(p));
c0104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104278:	83 c0 04             	add    $0x4,%eax
c010427b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104282:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104285:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104288:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010428b:	0f a3 10             	bt     %edx,(%eax)
c010428e:	19 c0                	sbb    %eax,%eax
c0104290:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104297:	0f 95 c0             	setne  %al
c010429a:	0f b6 c0             	movzbl %al,%eax
c010429d:	85 c0                	test   %eax,%eax
c010429f:	75 24                	jne    c01042c5 <default_init_memmap+0x8c>
c01042a1:	c7 44 24 0c e9 6c 10 	movl   $0xc0106ce9,0xc(%esp)
c01042a8:	c0 
c01042a9:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01042b0:	c0 
c01042b1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01042b8:	00 
c01042b9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01042c0:	e8 61 c1 ff ff       	call   c0100426 <__panic>
        p->flags = p->property = 0;
c01042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01042cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d2:	8b 50 08             	mov    0x8(%eax),%edx
c01042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d8:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01042db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01042e2:	00 
c01042e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042e6:	89 04 24             	mov    %eax,(%esp)
c01042e9:	e8 0a ff ff ff       	call   c01041f8 <set_page_ref>
    for (; p != base + n; p ++) {
c01042ee:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01042f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042f5:	89 d0                	mov    %edx,%eax
c01042f7:	c1 e0 02             	shl    $0x2,%eax
c01042fa:	01 d0                	add    %edx,%eax
c01042fc:	c1 e0 02             	shl    $0x2,%eax
c01042ff:	89 c2                	mov    %eax,%edx
c0104301:	8b 45 08             	mov    0x8(%ebp),%eax
c0104304:	01 d0                	add    %edx,%eax
c0104306:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104309:	0f 85 66 ff ff ff    	jne    c0104275 <default_init_memmap+0x3c>
    }
    base->property = n;
c010430f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104312:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104315:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104318:	8b 45 08             	mov    0x8(%ebp),%eax
c010431b:	83 c0 04             	add    $0x4,%eax
c010431e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104325:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104328:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010432b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010432e:	0f ab 10             	bts    %edx,(%eax)
}
c0104331:	90                   	nop
    nr_free += n;
c0104332:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c0104338:	8b 45 0c             	mov    0xc(%ebp),%eax
c010433b:	01 d0                	add    %edx,%eax
c010433d:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    list_add(&free_list, &(base->page_link));
c0104342:	8b 45 08             	mov    0x8(%ebp),%eax
c0104345:	83 c0 0c             	add    $0xc,%eax
c0104348:	c7 45 e4 1c cf 11 c0 	movl   $0xc011cf1c,-0x1c(%ebp)
c010434f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104355:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104358:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010435b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010435e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104361:	8b 40 04             	mov    0x4(%eax),%eax
c0104364:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104367:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010436a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010436d:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104370:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104373:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104379:	89 10                	mov    %edx,(%eax)
c010437b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010437e:	8b 10                	mov    (%eax),%edx
c0104380:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104383:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104389:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010438c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010438f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104392:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104395:	89 10                	mov    %edx,(%eax)
}
c0104397:	90                   	nop
}
c0104398:	90                   	nop
}
c0104399:	90                   	nop
}
c010439a:	90                   	nop
c010439b:	c9                   	leave  
c010439c:	c3                   	ret    

c010439d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010439d:	f3 0f 1e fb          	endbr32 
c01043a1:	55                   	push   %ebp
c01043a2:	89 e5                	mov    %esp,%ebp
c01043a4:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01043a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01043ab:	75 24                	jne    c01043d1 <default_alloc_pages+0x34>
c01043ad:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c01043b4:	c0 
c01043b5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01043bc:	c0 
c01043bd:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01043c4:	00 
c01043c5:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01043cc:	e8 55 c0 ff ff       	call   c0100426 <__panic>
    if (n > nr_free) {
c01043d1:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01043d6:	39 45 08             	cmp    %eax,0x8(%ebp)
c01043d9:	76 0a                	jbe    c01043e5 <default_alloc_pages+0x48>
        return NULL;
c01043db:	b8 00 00 00 00       	mov    $0x0,%eax
c01043e0:	e9 4e 01 00 00       	jmp    c0104533 <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c01043e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01043ec:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01043f3:	eb 1c                	jmp    c0104411 <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c01043f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043f8:	83 e8 0c             	sub    $0xc,%eax
c01043fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01043fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104401:	8b 40 08             	mov    0x8(%eax),%eax
c0104404:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104407:	77 08                	ja     c0104411 <default_alloc_pages+0x74>
            page = p;
c0104409:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010440c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010440f:	eb 18                	jmp    c0104429 <default_alloc_pages+0x8c>
c0104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010441d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104420:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c0104427:	75 cc                	jne    c01043f5 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c0104429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010442d:	0f 84 fd 00 00 00    	je     c0104530 <default_alloc_pages+0x193>
        list_del(&(page->page_link));
c0104433:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104436:	83 c0 0c             	add    $0xc,%eax
c0104439:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c010443c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010443f:	8b 40 04             	mov    0x4(%eax),%eax
c0104442:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104445:	8b 12                	mov    (%edx),%edx
c0104447:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010444a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010444d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104450:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104453:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104456:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104459:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010445c:	89 10                	mov    %edx,(%eax)
}
c010445e:	90                   	nop
}
c010445f:	90                   	nop
        if (page->property > n) {
c0104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104463:	8b 40 08             	mov    0x8(%eax),%eax
c0104466:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104469:	0f 83 9a 00 00 00    	jae    c0104509 <default_alloc_pages+0x16c>
            struct Page *p = page + n;
c010446f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104472:	89 d0                	mov    %edx,%eax
c0104474:	c1 e0 02             	shl    $0x2,%eax
c0104477:	01 d0                	add    %edx,%eax
c0104479:	c1 e0 02             	shl    $0x2,%eax
c010447c:	89 c2                	mov    %eax,%edx
c010447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104481:	01 d0                	add    %edx,%eax
c0104483:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104486:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104489:	8b 40 08             	mov    0x8(%eax),%eax
c010448c:	2b 45 08             	sub    0x8(%ebp),%eax
c010448f:	89 c2                	mov    %eax,%edx
c0104491:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104494:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104497:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010449a:	83 c0 04             	add    $0x4,%eax
c010449d:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01044a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01044aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01044ad:	0f ab 10             	bts    %edx,(%eax)
}
c01044b0:	90                   	nop
            list_add(&free_list, &(p->page_link));
c01044b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044b4:	83 c0 0c             	add    $0xc,%eax
c01044b7:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
c01044be:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01044c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01044c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01044c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c01044cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01044d0:	8b 40 04             	mov    0x4(%eax),%eax
c01044d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01044d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01044d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01044dc:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01044df:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c01044e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01044e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01044e8:	89 10                	mov    %edx,(%eax)
c01044ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01044ed:	8b 10                	mov    (%eax),%edx
c01044ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01044f2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01044f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01044f8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01044fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01044fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104501:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104504:	89 10                	mov    %edx,(%eax)
}
c0104506:	90                   	nop
}
c0104507:	90                   	nop
}
c0104508:	90                   	nop
        }
        nr_free -= n;
c0104509:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c010450e:	2b 45 08             	sub    0x8(%ebp),%eax
c0104511:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c0104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104519:	83 c0 04             	add    $0x4,%eax
c010451c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104523:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104526:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104529:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010452c:	0f b3 10             	btr    %edx,(%eax)
}
c010452f:	90                   	nop
    }
    return page;
c0104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104533:	c9                   	leave  
c0104534:	c3                   	ret    

c0104535 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104535:	f3 0f 1e fb          	endbr32 
c0104539:	55                   	push   %ebp
c010453a:	89 e5                	mov    %esp,%ebp
c010453c:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104546:	75 24                	jne    c010456c <default_free_pages+0x37>
c0104548:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c010454f:	c0 
c0104550:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104557:	c0 
c0104558:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c010455f:	00 
c0104560:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104567:	e8 ba be ff ff       	call   c0100426 <__panic>
    struct Page *p = base;
c010456c:	8b 45 08             	mov    0x8(%ebp),%eax
c010456f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104572:	e9 9d 00 00 00       	jmp    c0104614 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c0104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457a:	83 c0 04             	add    $0x4,%eax
c010457d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104584:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104587:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010458a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010458d:	0f a3 10             	bt     %edx,(%eax)
c0104590:	19 c0                	sbb    %eax,%eax
c0104592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104595:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104599:	0f 95 c0             	setne  %al
c010459c:	0f b6 c0             	movzbl %al,%eax
c010459f:	85 c0                	test   %eax,%eax
c01045a1:	75 2c                	jne    c01045cf <default_free_pages+0x9a>
c01045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a6:	83 c0 04             	add    $0x4,%eax
c01045a9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01045b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045b9:	0f a3 10             	bt     %edx,(%eax)
c01045bc:	19 c0                	sbb    %eax,%eax
c01045be:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01045c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01045c5:	0f 95 c0             	setne  %al
c01045c8:	0f b6 c0             	movzbl %al,%eax
c01045cb:	85 c0                	test   %eax,%eax
c01045cd:	74 24                	je     c01045f3 <default_free_pages+0xbe>
c01045cf:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c01045d6:	c0 
c01045d7:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01045de:	c0 
c01045df:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01045e6:	00 
c01045e7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01045ee:	e8 33 be ff ff       	call   c0100426 <__panic>
        p->flags = 0;
c01045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01045fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104604:	00 
c0104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104608:	89 04 24             	mov    %eax,(%esp)
c010460b:	e8 e8 fb ff ff       	call   c01041f8 <set_page_ref>
    for (; p != base + n; p ++) {
c0104610:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104614:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104617:	89 d0                	mov    %edx,%eax
c0104619:	c1 e0 02             	shl    $0x2,%eax
c010461c:	01 d0                	add    %edx,%eax
c010461e:	c1 e0 02             	shl    $0x2,%eax
c0104621:	89 c2                	mov    %eax,%edx
c0104623:	8b 45 08             	mov    0x8(%ebp),%eax
c0104626:	01 d0                	add    %edx,%eax
c0104628:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010462b:	0f 85 46 ff ff ff    	jne    c0104577 <default_free_pages+0x42>
    }
    base->property = n;
c0104631:	8b 45 08             	mov    0x8(%ebp),%eax
c0104634:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104637:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010463a:	8b 45 08             	mov    0x8(%ebp),%eax
c010463d:	83 c0 04             	add    $0x4,%eax
c0104640:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104647:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010464a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010464d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104650:	0f ab 10             	bts    %edx,(%eax)
}
c0104653:	90                   	nop
c0104654:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
    return listelm->next;
c010465b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010465e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104661:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104664:	e9 0e 01 00 00       	jmp    c0104777 <default_free_pages+0x242>
        p = le2page(le, page_link);
c0104669:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010466c:	83 e8 0c             	sub    $0xc,%eax
c010466f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104672:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104675:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104678:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010467b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010467e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104681:	8b 45 08             	mov    0x8(%ebp),%eax
c0104684:	8b 50 08             	mov    0x8(%eax),%edx
c0104687:	89 d0                	mov    %edx,%eax
c0104689:	c1 e0 02             	shl    $0x2,%eax
c010468c:	01 d0                	add    %edx,%eax
c010468e:	c1 e0 02             	shl    $0x2,%eax
c0104691:	89 c2                	mov    %eax,%edx
c0104693:	8b 45 08             	mov    0x8(%ebp),%eax
c0104696:	01 d0                	add    %edx,%eax
c0104698:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010469b:	75 5d                	jne    c01046fa <default_free_pages+0x1c5>
            base->property += p->property;
c010469d:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a0:	8b 50 08             	mov    0x8(%eax),%edx
c01046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a6:	8b 40 08             	mov    0x8(%eax),%eax
c01046a9:	01 c2                	add    %eax,%edx
c01046ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ae:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01046b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b4:	83 c0 04             	add    $0x4,%eax
c01046b7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01046be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01046c4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01046c7:	0f b3 10             	btr    %edx,(%eax)
}
c01046ca:	90                   	nop
            list_del(&(p->page_link));
c01046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ce:	83 c0 0c             	add    $0xc,%eax
c01046d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01046d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01046d7:	8b 40 04             	mov    0x4(%eax),%eax
c01046da:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01046dd:	8b 12                	mov    (%edx),%edx
c01046df:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01046e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01046e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01046e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01046eb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046ee:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01046f1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01046f4:	89 10                	mov    %edx,(%eax)
}
c01046f6:	90                   	nop
}
c01046f7:	90                   	nop
c01046f8:	eb 7d                	jmp    c0104777 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
c01046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046fd:	8b 50 08             	mov    0x8(%eax),%edx
c0104700:	89 d0                	mov    %edx,%eax
c0104702:	c1 e0 02             	shl    $0x2,%eax
c0104705:	01 d0                	add    %edx,%eax
c0104707:	c1 e0 02             	shl    $0x2,%eax
c010470a:	89 c2                	mov    %eax,%edx
c010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470f:	01 d0                	add    %edx,%eax
c0104711:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104714:	75 61                	jne    c0104777 <default_free_pages+0x242>
            p->property += base->property;
c0104716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104719:	8b 50 08             	mov    0x8(%eax),%edx
c010471c:	8b 45 08             	mov    0x8(%ebp),%eax
c010471f:	8b 40 08             	mov    0x8(%eax),%eax
c0104722:	01 c2                	add    %eax,%edx
c0104724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104727:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010472a:	8b 45 08             	mov    0x8(%ebp),%eax
c010472d:	83 c0 04             	add    $0x4,%eax
c0104730:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104737:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010473a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010473d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104740:	0f b3 10             	btr    %edx,(%eax)
}
c0104743:	90                   	nop
            base = p;
c0104744:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104747:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010474d:	83 c0 0c             	add    $0xc,%eax
c0104750:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104753:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104756:	8b 40 04             	mov    0x4(%eax),%eax
c0104759:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010475c:	8b 12                	mov    (%edx),%edx
c010475e:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104761:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104764:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104767:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010476a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010476d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104770:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104773:	89 10                	mov    %edx,(%eax)
}
c0104775:	90                   	nop
}
c0104776:	90                   	nop
    while (le != &free_list) {
c0104777:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c010477e:	0f 85 e5 fe ff ff    	jne    c0104669 <default_free_pages+0x134>
        }
    }
    nr_free += n;
c0104784:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010478a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010478d:	01 d0                	add    %edx,%eax
c010478f:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
c0104794:	c7 45 9c 1c cf 11 c0 	movl   $0xc011cf1c,-0x64(%ebp)
    return listelm->next;
c010479b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010479e:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(&free_list);
c01047a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
c01047a4:	eb 34                	jmp    c01047da <default_free_pages+0x2a5>
        p = le2page(le, page_link);
c01047a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a9:	83 e8 0c             	sub    $0xc,%eax
c01047ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(base + base->property <= p){
c01047af:	8b 45 08             	mov    0x8(%ebp),%eax
c01047b2:	8b 50 08             	mov    0x8(%eax),%edx
c01047b5:	89 d0                	mov    %edx,%eax
c01047b7:	c1 e0 02             	shl    $0x2,%eax
c01047ba:	01 d0                	add    %edx,%eax
c01047bc:	c1 e0 02             	shl    $0x2,%eax
c01047bf:	89 c2                	mov    %eax,%edx
c01047c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c4:	01 d0                	add    %edx,%eax
c01047c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01047c9:	73 1a                	jae    c01047e5 <default_free_pages+0x2b0>
c01047cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ce:	89 45 98             	mov    %eax,-0x68(%ebp)
c01047d1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01047d4:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01047d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list){
c01047da:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01047e1:	75 c3                	jne    c01047a6 <default_free_pages+0x271>
c01047e3:	eb 01                	jmp    c01047e6 <default_free_pages+0x2b1>
            break;
c01047e5:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01047e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e9:	8d 50 0c             	lea    0xc(%eax),%edx
c01047ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ef:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01047f2:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01047f5:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01047f8:	8b 00                	mov    (%eax),%eax
c01047fa:	8b 55 90             	mov    -0x70(%ebp),%edx
c01047fd:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104800:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104803:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104806:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104809:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010480c:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010480f:	89 10                	mov    %edx,(%eax)
c0104811:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104814:	8b 10                	mov    (%eax),%edx
c0104816:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104819:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010481c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010481f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104822:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104825:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104828:	8b 55 88             	mov    -0x78(%ebp),%edx
c010482b:	89 10                	mov    %edx,(%eax)
}
c010482d:	90                   	nop
}
c010482e:	90                   	nop
}
c010482f:	90                   	nop
c0104830:	c9                   	leave  
c0104831:	c3                   	ret    

c0104832 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104832:	f3 0f 1e fb          	endbr32 
c0104836:	55                   	push   %ebp
c0104837:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104839:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c010483e:	5d                   	pop    %ebp
c010483f:	c3                   	ret    

c0104840 <basic_check>:

static void
basic_check(void) {
c0104840:	f3 0f 1e fb          	endbr32 
c0104844:	55                   	push   %ebp
c0104845:	89 e5                	mov    %esp,%ebp
c0104847:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010484a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104851:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104854:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104857:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010485d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104864:	e8 19 e4 ff ff       	call   c0102c82 <alloc_pages>
c0104869:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010486c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104870:	75 24                	jne    c0104896 <basic_check+0x56>
c0104872:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0104879:	c0 
c010487a:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104881:	c0 
c0104882:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104889:	00 
c010488a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104891:	e8 90 bb ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104896:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010489d:	e8 e0 e3 ff ff       	call   c0102c82 <alloc_pages>
c01048a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048a9:	75 24                	jne    c01048cf <basic_check+0x8f>
c01048ab:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c01048b2:	c0 
c01048b3:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01048ba:	c0 
c01048bb:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c01048c2:	00 
c01048c3:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01048ca:	e8 57 bb ff ff       	call   c0100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048d6:	e8 a7 e3 ff ff       	call   c0102c82 <alloc_pages>
c01048db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048e2:	75 24                	jne    c0104908 <basic_check+0xc8>
c01048e4:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c01048eb:	c0 
c01048ec:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01048f3:	c0 
c01048f4:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01048fb:	00 
c01048fc:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104903:	e8 1e bb ff ff       	call   c0100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104908:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010490b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010490e:	74 10                	je     c0104920 <basic_check+0xe0>
c0104910:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104913:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104916:	74 08                	je     c0104920 <basic_check+0xe0>
c0104918:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010491b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010491e:	75 24                	jne    c0104944 <basic_check+0x104>
c0104920:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0104927:	c0 
c0104928:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010492f:	c0 
c0104930:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104937:	00 
c0104938:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010493f:	e8 e2 ba ff ff       	call   c0100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104947:	89 04 24             	mov    %eax,(%esp)
c010494a:	e8 9f f8 ff ff       	call   c01041ee <page_ref>
c010494f:	85 c0                	test   %eax,%eax
c0104951:	75 1e                	jne    c0104971 <basic_check+0x131>
c0104953:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104956:	89 04 24             	mov    %eax,(%esp)
c0104959:	e8 90 f8 ff ff       	call   c01041ee <page_ref>
c010495e:	85 c0                	test   %eax,%eax
c0104960:	75 0f                	jne    c0104971 <basic_check+0x131>
c0104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104965:	89 04 24             	mov    %eax,(%esp)
c0104968:	e8 81 f8 ff ff       	call   c01041ee <page_ref>
c010496d:	85 c0                	test   %eax,%eax
c010496f:	74 24                	je     c0104995 <basic_check+0x155>
c0104971:	c7 44 24 0c 9c 6d 10 	movl   $0xc0106d9c,0xc(%esp)
c0104978:	c0 
c0104979:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104980:	c0 
c0104981:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104988:	00 
c0104989:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104990:	e8 91 ba ff ff       	call   c0100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104998:	89 04 24             	mov    %eax,(%esp)
c010499b:	e8 38 f8 ff ff       	call   c01041d8 <page2pa>
c01049a0:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01049a6:	c1 e2 0c             	shl    $0xc,%edx
c01049a9:	39 d0                	cmp    %edx,%eax
c01049ab:	72 24                	jb     c01049d1 <basic_check+0x191>
c01049ad:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c01049b4:	c0 
c01049b5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01049bc:	c0 
c01049bd:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01049c4:	00 
c01049c5:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01049cc:	e8 55 ba ff ff       	call   c0100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01049d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d4:	89 04 24             	mov    %eax,(%esp)
c01049d7:	e8 fc f7 ff ff       	call   c01041d8 <page2pa>
c01049dc:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01049e2:	c1 e2 0c             	shl    $0xc,%edx
c01049e5:	39 d0                	cmp    %edx,%eax
c01049e7:	72 24                	jb     c0104a0d <basic_check+0x1cd>
c01049e9:	c7 44 24 0c f5 6d 10 	movl   $0xc0106df5,0xc(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01049f8:	c0 
c01049f9:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104a00:	00 
c0104a01:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a08:	e8 19 ba ff ff       	call   c0100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a10:	89 04 24             	mov    %eax,(%esp)
c0104a13:	e8 c0 f7 ff ff       	call   c01041d8 <page2pa>
c0104a18:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104a1e:	c1 e2 0c             	shl    $0xc,%edx
c0104a21:	39 d0                	cmp    %edx,%eax
c0104a23:	72 24                	jb     c0104a49 <basic_check+0x209>
c0104a25:	c7 44 24 0c 12 6e 10 	movl   $0xc0106e12,0xc(%esp)
c0104a2c:	c0 
c0104a2d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a34:	c0 
c0104a35:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104a3c:	00 
c0104a3d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a44:	e8 dd b9 ff ff       	call   c0100426 <__panic>

    list_entry_t free_list_store = free_list;
c0104a49:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104a4e:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104a54:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a57:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a5a:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a64:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a67:	89 50 04             	mov    %edx,0x4(%eax)
c0104a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a6d:	8b 50 04             	mov    0x4(%eax),%edx
c0104a70:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a73:	89 10                	mov    %edx,(%eax)
}
c0104a75:	90                   	nop
c0104a76:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a80:	8b 40 04             	mov    0x4(%eax),%eax
c0104a83:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104a86:	0f 94 c0             	sete   %al
c0104a89:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104a8c:	85 c0                	test   %eax,%eax
c0104a8e:	75 24                	jne    c0104ab4 <basic_check+0x274>
c0104a90:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104a97:	c0 
c0104a98:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a9f:	c0 
c0104aa0:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0104aa7:	00 
c0104aa8:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104aaf:	e8 72 b9 ff ff       	call   c0100426 <__panic>

    unsigned int nr_free_store = nr_free;
c0104ab4:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104ab9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104abc:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104ac3:	00 00 00 

    assert(alloc_page() == NULL);
c0104ac6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104acd:	e8 b0 e1 ff ff       	call   c0102c82 <alloc_pages>
c0104ad2:	85 c0                	test   %eax,%eax
c0104ad4:	74 24                	je     c0104afa <basic_check+0x2ba>
c0104ad6:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104add:	c0 
c0104ade:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ae5:	c0 
c0104ae6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0104aed:	00 
c0104aee:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104af5:	e8 2c b9 ff ff       	call   c0100426 <__panic>

    free_page(p0);
c0104afa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b01:	00 
c0104b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b05:	89 04 24             	mov    %eax,(%esp)
c0104b08:	e8 b1 e1 ff ff       	call   c0102cbe <free_pages>
    free_page(p1);
c0104b0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b14:	00 
c0104b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b18:	89 04 24             	mov    %eax,(%esp)
c0104b1b:	e8 9e e1 ff ff       	call   c0102cbe <free_pages>
    free_page(p2);
c0104b20:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b27:	00 
c0104b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b2b:	89 04 24             	mov    %eax,(%esp)
c0104b2e:	e8 8b e1 ff ff       	call   c0102cbe <free_pages>
    assert(nr_free == 3);
c0104b33:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104b38:	83 f8 03             	cmp    $0x3,%eax
c0104b3b:	74 24                	je     c0104b61 <basic_check+0x321>
c0104b3d:	c7 44 24 0c 5b 6e 10 	movl   $0xc0106e5b,0xc(%esp)
c0104b44:	c0 
c0104b45:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b4c:	c0 
c0104b4d:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104b54:	00 
c0104b55:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b5c:	e8 c5 b8 ff ff       	call   c0100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104b61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b68:	e8 15 e1 ff ff       	call   c0102c82 <alloc_pages>
c0104b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b74:	75 24                	jne    c0104b9a <basic_check+0x35a>
c0104b76:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0104b7d:	c0 
c0104b7e:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b85:	c0 
c0104b86:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0104b8d:	00 
c0104b8e:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b95:	e8 8c b8 ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104b9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ba1:	e8 dc e0 ff ff       	call   c0102c82 <alloc_pages>
c0104ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bad:	75 24                	jne    c0104bd3 <basic_check+0x393>
c0104baf:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c0104bb6:	c0 
c0104bb7:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104bbe:	c0 
c0104bbf:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104bc6:	00 
c0104bc7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104bce:	e8 53 b8 ff ff       	call   c0100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104bd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bda:	e8 a3 e0 ff ff       	call   c0102c82 <alloc_pages>
c0104bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104be6:	75 24                	jne    c0104c0c <basic_check+0x3cc>
c0104be8:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c0104bef:	c0 
c0104bf0:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104bf7:	c0 
c0104bf8:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104bff:	00 
c0104c00:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c07:	e8 1a b8 ff ff       	call   c0100426 <__panic>

    assert(alloc_page() == NULL);
c0104c0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c13:	e8 6a e0 ff ff       	call   c0102c82 <alloc_pages>
c0104c18:	85 c0                	test   %eax,%eax
c0104c1a:	74 24                	je     c0104c40 <basic_check+0x400>
c0104c1c:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104c23:	c0 
c0104c24:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c2b:	c0 
c0104c2c:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104c33:	00 
c0104c34:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c3b:	e8 e6 b7 ff ff       	call   c0100426 <__panic>

    free_page(p0);
c0104c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c47:	00 
c0104c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c4b:	89 04 24             	mov    %eax,(%esp)
c0104c4e:	e8 6b e0 ff ff       	call   c0102cbe <free_pages>
c0104c53:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104c5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c5d:	8b 40 04             	mov    0x4(%eax),%eax
c0104c60:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104c63:	0f 94 c0             	sete   %al
c0104c66:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104c69:	85 c0                	test   %eax,%eax
c0104c6b:	74 24                	je     c0104c91 <basic_check+0x451>
c0104c6d:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104c74:	c0 
c0104c75:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c7c:	c0 
c0104c7d:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104c84:	00 
c0104c85:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c8c:	e8 95 b7 ff ff       	call   c0100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104c91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c98:	e8 e5 df ff ff       	call   c0102c82 <alloc_pages>
c0104c9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ca3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104ca6:	74 24                	je     c0104ccc <basic_check+0x48c>
c0104ca8:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104caf:	c0 
c0104cb0:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104cb7:	c0 
c0104cb8:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104cbf:	00 
c0104cc0:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104cc7:	e8 5a b7 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0104ccc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cd3:	e8 aa df ff ff       	call   c0102c82 <alloc_pages>
c0104cd8:	85 c0                	test   %eax,%eax
c0104cda:	74 24                	je     c0104d00 <basic_check+0x4c0>
c0104cdc:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104ce3:	c0 
c0104ce4:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ceb:	c0 
c0104cec:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104cf3:	00 
c0104cf4:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104cfb:	e8 26 b7 ff ff       	call   c0100426 <__panic>

    assert(nr_free == 0);
c0104d00:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104d05:	85 c0                	test   %eax,%eax
c0104d07:	74 24                	je     c0104d2d <basic_check+0x4ed>
c0104d09:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104d10:	c0 
c0104d11:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104d20:	00 
c0104d21:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104d28:	e8 f9 b6 ff ff       	call   c0100426 <__panic>
    free_list = free_list_store;
c0104d2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d33:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104d38:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d41:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104d46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d4d:	00 
c0104d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d51:	89 04 24             	mov    %eax,(%esp)
c0104d54:	e8 65 df ff ff       	call   c0102cbe <free_pages>
    free_page(p1);
c0104d59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d60:	00 
c0104d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d64:	89 04 24             	mov    %eax,(%esp)
c0104d67:	e8 52 df ff ff       	call   c0102cbe <free_pages>
    free_page(p2);
c0104d6c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d73:	00 
c0104d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d77:	89 04 24             	mov    %eax,(%esp)
c0104d7a:	e8 3f df ff ff       	call   c0102cbe <free_pages>
}
c0104d7f:	90                   	nop
c0104d80:	c9                   	leave  
c0104d81:	c3                   	ret    

c0104d82 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104d82:	f3 0f 1e fb          	endbr32 
c0104d86:	55                   	push   %ebp
c0104d87:	89 e5                	mov    %esp,%ebp
c0104d89:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104d9d:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104da4:	eb 6a                	jmp    c0104e10 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c0104da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104da9:	83 e8 0c             	sub    $0xc,%eax
c0104dac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104daf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104db2:	83 c0 04             	add    $0x4,%eax
c0104db5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104dbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104dc2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104dc5:	0f a3 10             	bt     %edx,(%eax)
c0104dc8:	19 c0                	sbb    %eax,%eax
c0104dca:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104dcd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104dd1:	0f 95 c0             	setne  %al
c0104dd4:	0f b6 c0             	movzbl %al,%eax
c0104dd7:	85 c0                	test   %eax,%eax
c0104dd9:	75 24                	jne    c0104dff <default_check+0x7d>
c0104ddb:	c7 44 24 0c a6 6e 10 	movl   $0xc0106ea6,0xc(%esp)
c0104de2:	c0 
c0104de3:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104dea:	c0 
c0104deb:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104df2:	00 
c0104df3:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104dfa:	e8 27 b6 ff ff       	call   c0100426 <__panic>
        count ++, total += p->property;
c0104dff:	ff 45 f4             	incl   -0xc(%ebp)
c0104e02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e05:	8b 50 08             	mov    0x8(%eax),%edx
c0104e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e0b:	01 d0                	add    %edx,%eax
c0104e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e13:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104e16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e19:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104e1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e1f:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0104e26:	0f 85 7a ff ff ff    	jne    c0104da6 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0104e2c:	e8 c4 de ff ff       	call   c0102cf5 <nr_free_pages>
c0104e31:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104e34:	39 d0                	cmp    %edx,%eax
c0104e36:	74 24                	je     c0104e5c <default_check+0xda>
c0104e38:	c7 44 24 0c b6 6e 10 	movl   $0xc0106eb6,0xc(%esp)
c0104e3f:	c0 
c0104e40:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e47:	c0 
c0104e48:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0104e4f:	00 
c0104e50:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e57:	e8 ca b5 ff ff       	call   c0100426 <__panic>

    basic_check();
c0104e5c:	e8 df f9 ff ff       	call   c0104840 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104e61:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104e68:	e8 15 de ff ff       	call   c0102c82 <alloc_pages>
c0104e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104e70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e74:	75 24                	jne    c0104e9a <default_check+0x118>
c0104e76:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0104e7d:	c0 
c0104e7e:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e85:	c0 
c0104e86:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104e8d:	00 
c0104e8e:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e95:	e8 8c b5 ff ff       	call   c0100426 <__panic>
    assert(!PageProperty(p0));
c0104e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e9d:	83 c0 04             	add    $0x4,%eax
c0104ea0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104ea7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104eaa:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ead:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104eb0:	0f a3 10             	bt     %edx,(%eax)
c0104eb3:	19 c0                	sbb    %eax,%eax
c0104eb5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104eb8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104ebc:	0f 95 c0             	setne  %al
c0104ebf:	0f b6 c0             	movzbl %al,%eax
c0104ec2:	85 c0                	test   %eax,%eax
c0104ec4:	74 24                	je     c0104eea <default_check+0x168>
c0104ec6:	c7 44 24 0c da 6e 10 	movl   $0xc0106eda,0xc(%esp)
c0104ecd:	c0 
c0104ece:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ed5:	c0 
c0104ed6:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104edd:	00 
c0104ede:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104ee5:	e8 3c b5 ff ff       	call   c0100426 <__panic>

    list_entry_t free_list_store = free_list;
c0104eea:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104eef:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104ef5:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104ef8:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104efb:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104f02:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f05:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104f08:	89 50 04             	mov    %edx,0x4(%eax)
c0104f0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f0e:	8b 50 04             	mov    0x4(%eax),%edx
c0104f11:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f14:	89 10                	mov    %edx,(%eax)
}
c0104f16:	90                   	nop
c0104f17:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c0104f1e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f21:	8b 40 04             	mov    0x4(%eax),%eax
c0104f24:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104f27:	0f 94 c0             	sete   %al
c0104f2a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104f2d:	85 c0                	test   %eax,%eax
c0104f2f:	75 24                	jne    c0104f55 <default_check+0x1d3>
c0104f31:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104f38:	c0 
c0104f39:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f40:	c0 
c0104f41:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104f48:	00 
c0104f49:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f50:	e8 d1 b4 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c0104f55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f5c:	e8 21 dd ff ff       	call   c0102c82 <alloc_pages>
c0104f61:	85 c0                	test   %eax,%eax
c0104f63:	74 24                	je     c0104f89 <default_check+0x207>
c0104f65:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104f6c:	c0 
c0104f6d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f74:	c0 
c0104f75:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104f7c:	00 
c0104f7d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f84:	e8 9d b4 ff ff       	call   c0100426 <__panic>

    unsigned int nr_free_store = nr_free;
c0104f89:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104f8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104f91:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104f98:	00 00 00 

    free_pages(p0 + 2, 3);
c0104f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f9e:	83 c0 28             	add    $0x28,%eax
c0104fa1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104fa8:	00 
c0104fa9:	89 04 24             	mov    %eax,(%esp)
c0104fac:	e8 0d dd ff ff       	call   c0102cbe <free_pages>
    assert(alloc_pages(4) == NULL);
c0104fb1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104fb8:	e8 c5 dc ff ff       	call   c0102c82 <alloc_pages>
c0104fbd:	85 c0                	test   %eax,%eax
c0104fbf:	74 24                	je     c0104fe5 <default_check+0x263>
c0104fc1:	c7 44 24 0c ec 6e 10 	movl   $0xc0106eec,0xc(%esp)
c0104fc8:	c0 
c0104fc9:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104fd0:	c0 
c0104fd1:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104fd8:	00 
c0104fd9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104fe0:	e8 41 b4 ff ff       	call   c0100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fe8:	83 c0 28             	add    $0x28,%eax
c0104feb:	83 c0 04             	add    $0x4,%eax
c0104fee:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104ff5:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ff8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104ffb:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104ffe:	0f a3 10             	bt     %edx,(%eax)
c0105001:	19 c0                	sbb    %eax,%eax
c0105003:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105006:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010500a:	0f 95 c0             	setne  %al
c010500d:	0f b6 c0             	movzbl %al,%eax
c0105010:	85 c0                	test   %eax,%eax
c0105012:	74 0e                	je     c0105022 <default_check+0x2a0>
c0105014:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105017:	83 c0 28             	add    $0x28,%eax
c010501a:	8b 40 08             	mov    0x8(%eax),%eax
c010501d:	83 f8 03             	cmp    $0x3,%eax
c0105020:	74 24                	je     c0105046 <default_check+0x2c4>
c0105022:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0105029:	c0 
c010502a:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105031:	c0 
c0105032:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0105039:	00 
c010503a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105041:	e8 e0 b3 ff ff       	call   c0100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105046:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010504d:	e8 30 dc ff ff       	call   c0102c82 <alloc_pages>
c0105052:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105055:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105059:	75 24                	jne    c010507f <default_check+0x2fd>
c010505b:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0105062:	c0 
c0105063:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010506a:	c0 
c010506b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105072:	00 
c0105073:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010507a:	e8 a7 b3 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c010507f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105086:	e8 f7 db ff ff       	call   c0102c82 <alloc_pages>
c010508b:	85 c0                	test   %eax,%eax
c010508d:	74 24                	je     c01050b3 <default_check+0x331>
c010508f:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0105096:	c0 
c0105097:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010509e:	c0 
c010509f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01050a6:	00 
c01050a7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01050ae:	e8 73 b3 ff ff       	call   c0100426 <__panic>
    assert(p0 + 2 == p1);
c01050b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050b6:	83 c0 28             	add    $0x28,%eax
c01050b9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01050bc:	74 24                	je     c01050e2 <default_check+0x360>
c01050be:	c7 44 24 0c 4e 6f 10 	movl   $0xc0106f4e,0xc(%esp)
c01050c5:	c0 
c01050c6:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01050cd:	c0 
c01050ce:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01050d5:	00 
c01050d6:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01050dd:	e8 44 b3 ff ff       	call   c0100426 <__panic>

    p2 = p0 + 1;
c01050e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050e5:	83 c0 14             	add    $0x14,%eax
c01050e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01050eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050f2:	00 
c01050f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050f6:	89 04 24             	mov    %eax,(%esp)
c01050f9:	e8 c0 db ff ff       	call   c0102cbe <free_pages>
    free_pages(p1, 3);
c01050fe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105105:	00 
c0105106:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105109:	89 04 24             	mov    %eax,(%esp)
c010510c:	e8 ad db ff ff       	call   c0102cbe <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105111:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105114:	83 c0 04             	add    $0x4,%eax
c0105117:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010511e:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105121:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105124:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105127:	0f a3 10             	bt     %edx,(%eax)
c010512a:	19 c0                	sbb    %eax,%eax
c010512c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010512f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105133:	0f 95 c0             	setne  %al
c0105136:	0f b6 c0             	movzbl %al,%eax
c0105139:	85 c0                	test   %eax,%eax
c010513b:	74 0b                	je     c0105148 <default_check+0x3c6>
c010513d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105140:	8b 40 08             	mov    0x8(%eax),%eax
c0105143:	83 f8 01             	cmp    $0x1,%eax
c0105146:	74 24                	je     c010516c <default_check+0x3ea>
c0105148:	c7 44 24 0c 5c 6f 10 	movl   $0xc0106f5c,0xc(%esp)
c010514f:	c0 
c0105150:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105157:	c0 
c0105158:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c010515f:	00 
c0105160:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105167:	e8 ba b2 ff ff       	call   c0100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010516c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010516f:	83 c0 04             	add    $0x4,%eax
c0105172:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105179:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010517c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010517f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105182:	0f a3 10             	bt     %edx,(%eax)
c0105185:	19 c0                	sbb    %eax,%eax
c0105187:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010518a:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010518e:	0f 95 c0             	setne  %al
c0105191:	0f b6 c0             	movzbl %al,%eax
c0105194:	85 c0                	test   %eax,%eax
c0105196:	74 0b                	je     c01051a3 <default_check+0x421>
c0105198:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010519b:	8b 40 08             	mov    0x8(%eax),%eax
c010519e:	83 f8 03             	cmp    $0x3,%eax
c01051a1:	74 24                	je     c01051c7 <default_check+0x445>
c01051a3:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c01051aa:	c0 
c01051ab:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01051b2:	c0 
c01051b3:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01051ba:	00 
c01051bb:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01051c2:	e8 5f b2 ff ff       	call   c0100426 <__panic>
    
    assert((p0 = alloc_page()) == p2 - 1);
c01051c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051ce:	e8 af da ff ff       	call   c0102c82 <alloc_pages>
c01051d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051d9:	83 e8 14             	sub    $0x14,%eax
c01051dc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01051df:	74 24                	je     c0105205 <default_check+0x483>
c01051e1:	c7 44 24 0c aa 6f 10 	movl   $0xc0106faa,0xc(%esp)
c01051e8:	c0 
c01051e9:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01051f0:	c0 
c01051f1:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01051f8:	00 
c01051f9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105200:	e8 21 b2 ff ff       	call   c0100426 <__panic>
    free_page(p0);
c0105205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010520c:	00 
c010520d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105210:	89 04 24             	mov    %eax,(%esp)
c0105213:	e8 a6 da ff ff       	call   c0102cbe <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105218:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010521f:	e8 5e da ff ff       	call   c0102c82 <alloc_pages>
c0105224:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105227:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010522a:	83 c0 14             	add    $0x14,%eax
c010522d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105230:	74 24                	je     c0105256 <default_check+0x4d4>
c0105232:	c7 44 24 0c c8 6f 10 	movl   $0xc0106fc8,0xc(%esp)
c0105239:	c0 
c010523a:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105241:	c0 
c0105242:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0105249:	00 
c010524a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105251:	e8 d0 b1 ff ff       	call   c0100426 <__panic>

    free_pages(p0, 2);
c0105256:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010525d:	00 
c010525e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105261:	89 04 24             	mov    %eax,(%esp)
c0105264:	e8 55 da ff ff       	call   c0102cbe <free_pages>
    free_page(p2);
c0105269:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105270:	00 
c0105271:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105274:	89 04 24             	mov    %eax,(%esp)
c0105277:	e8 42 da ff ff       	call   c0102cbe <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010527c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105283:	e8 fa d9 ff ff       	call   c0102c82 <alloc_pages>
c0105288:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010528b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010528f:	75 24                	jne    c01052b5 <default_check+0x533>
c0105291:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0105298:	c0 
c0105299:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052a0:	c0 
c01052a1:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c01052a8:	00 
c01052a9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052b0:	e8 71 b1 ff ff       	call   c0100426 <__panic>
    assert(alloc_page() == NULL);
c01052b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052bc:	e8 c1 d9 ff ff       	call   c0102c82 <alloc_pages>
c01052c1:	85 c0                	test   %eax,%eax
c01052c3:	74 24                	je     c01052e9 <default_check+0x567>
c01052c5:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c01052cc:	c0 
c01052cd:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052d4:	c0 
c01052d5:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c01052dc:	00 
c01052dd:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052e4:	e8 3d b1 ff ff       	call   c0100426 <__panic>

    assert(nr_free == 0);
c01052e9:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01052ee:	85 c0                	test   %eax,%eax
c01052f0:	74 24                	je     c0105316 <default_check+0x594>
c01052f2:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c01052f9:	c0 
c01052fa:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105301:	c0 
c0105302:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0105309:	00 
c010530a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105311:	e8 10 b1 ff ff       	call   c0100426 <__panic>
    nr_free = nr_free_store;
c0105316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105319:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c010531e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105321:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105324:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0105329:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c010532f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105336:	00 
c0105337:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010533a:	89 04 24             	mov    %eax,(%esp)
c010533d:	e8 7c d9 ff ff       	call   c0102cbe <free_pages>

    le = &free_list;
c0105342:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105349:	eb 1c                	jmp    c0105367 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c010534b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010534e:	83 e8 0c             	sub    $0xc,%eax
c0105351:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105354:	ff 4d f4             	decl   -0xc(%ebp)
c0105357:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010535a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010535d:	8b 40 08             	mov    0x8(%eax),%eax
c0105360:	29 c2                	sub    %eax,%edx
c0105362:	89 d0                	mov    %edx,%eax
c0105364:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105367:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010536a:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010536d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105370:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105373:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105376:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c010537d:	75 cc                	jne    c010534b <default_check+0x5c9>
    }
    assert(count == 0);
c010537f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105383:	74 24                	je     c01053a9 <default_check+0x627>
c0105385:	c7 44 24 0c 06 70 10 	movl   $0xc0107006,0xc(%esp)
c010538c:	c0 
c010538d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105394:	c0 
c0105395:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010539c:	00 
c010539d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01053a4:	e8 7d b0 ff ff       	call   c0100426 <__panic>
    assert(total == 0);
c01053a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053ad:	74 24                	je     c01053d3 <default_check+0x651>
c01053af:	c7 44 24 0c 11 70 10 	movl   $0xc0107011,0xc(%esp)
c01053b6:	c0 
c01053b7:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01053be:	c0 
c01053bf:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01053c6:	00 
c01053c7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01053ce:	e8 53 b0 ff ff       	call   c0100426 <__panic>
}
c01053d3:	90                   	nop
c01053d4:	c9                   	leave  
c01053d5:	c3                   	ret    

c01053d6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01053d6:	f3 0f 1e fb          	endbr32 
c01053da:	55                   	push   %ebp
c01053db:	89 e5                	mov    %esp,%ebp
c01053dd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01053e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01053e7:	eb 03                	jmp    c01053ec <strlen+0x16>
        cnt ++;
c01053e9:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01053ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ef:	8d 50 01             	lea    0x1(%eax),%edx
c01053f2:	89 55 08             	mov    %edx,0x8(%ebp)
c01053f5:	0f b6 00             	movzbl (%eax),%eax
c01053f8:	84 c0                	test   %al,%al
c01053fa:	75 ed                	jne    c01053e9 <strlen+0x13>
    }
    return cnt;
c01053fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01053ff:	c9                   	leave  
c0105400:	c3                   	ret    

c0105401 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105401:	f3 0f 1e fb          	endbr32 
c0105405:	55                   	push   %ebp
c0105406:	89 e5                	mov    %esp,%ebp
c0105408:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010540b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105412:	eb 03                	jmp    c0105417 <strnlen+0x16>
        cnt ++;
c0105414:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105417:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010541a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010541d:	73 10                	jae    c010542f <strnlen+0x2e>
c010541f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105422:	8d 50 01             	lea    0x1(%eax),%edx
c0105425:	89 55 08             	mov    %edx,0x8(%ebp)
c0105428:	0f b6 00             	movzbl (%eax),%eax
c010542b:	84 c0                	test   %al,%al
c010542d:	75 e5                	jne    c0105414 <strnlen+0x13>
    }
    return cnt;
c010542f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105432:	c9                   	leave  
c0105433:	c3                   	ret    

c0105434 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105434:	f3 0f 1e fb          	endbr32 
c0105438:	55                   	push   %ebp
c0105439:	89 e5                	mov    %esp,%ebp
c010543b:	57                   	push   %edi
c010543c:	56                   	push   %esi
c010543d:	83 ec 20             	sub    $0x20,%esp
c0105440:	8b 45 08             	mov    0x8(%ebp),%eax
c0105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105446:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105449:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010544c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105452:	89 d1                	mov    %edx,%ecx
c0105454:	89 c2                	mov    %eax,%edx
c0105456:	89 ce                	mov    %ecx,%esi
c0105458:	89 d7                	mov    %edx,%edi
c010545a:	ac                   	lods   %ds:(%esi),%al
c010545b:	aa                   	stos   %al,%es:(%edi)
c010545c:	84 c0                	test   %al,%al
c010545e:	75 fa                	jne    c010545a <strcpy+0x26>
c0105460:	89 fa                	mov    %edi,%edx
c0105462:	89 f1                	mov    %esi,%ecx
c0105464:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105467:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010546a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010546d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105470:	83 c4 20             	add    $0x20,%esp
c0105473:	5e                   	pop    %esi
c0105474:	5f                   	pop    %edi
c0105475:	5d                   	pop    %ebp
c0105476:	c3                   	ret    

c0105477 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105477:	f3 0f 1e fb          	endbr32 
c010547b:	55                   	push   %ebp
c010547c:	89 e5                	mov    %esp,%ebp
c010547e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105481:	8b 45 08             	mov    0x8(%ebp),%eax
c0105484:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105487:	eb 1e                	jmp    c01054a7 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c0105489:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548c:	0f b6 10             	movzbl (%eax),%edx
c010548f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105492:	88 10                	mov    %dl,(%eax)
c0105494:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105497:	0f b6 00             	movzbl (%eax),%eax
c010549a:	84 c0                	test   %al,%al
c010549c:	74 03                	je     c01054a1 <strncpy+0x2a>
            src ++;
c010549e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01054a1:	ff 45 fc             	incl   -0x4(%ebp)
c01054a4:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01054a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054ab:	75 dc                	jne    c0105489 <strncpy+0x12>
    }
    return dst;
c01054ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01054b0:	c9                   	leave  
c01054b1:	c3                   	ret    

c01054b2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01054b2:	f3 0f 1e fb          	endbr32 
c01054b6:	55                   	push   %ebp
c01054b7:	89 e5                	mov    %esp,%ebp
c01054b9:	57                   	push   %edi
c01054ba:	56                   	push   %esi
c01054bb:	83 ec 20             	sub    $0x20,%esp
c01054be:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01054ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d0:	89 d1                	mov    %edx,%ecx
c01054d2:	89 c2                	mov    %eax,%edx
c01054d4:	89 ce                	mov    %ecx,%esi
c01054d6:	89 d7                	mov    %edx,%edi
c01054d8:	ac                   	lods   %ds:(%esi),%al
c01054d9:	ae                   	scas   %es:(%edi),%al
c01054da:	75 08                	jne    c01054e4 <strcmp+0x32>
c01054dc:	84 c0                	test   %al,%al
c01054de:	75 f8                	jne    c01054d8 <strcmp+0x26>
c01054e0:	31 c0                	xor    %eax,%eax
c01054e2:	eb 04                	jmp    c01054e8 <strcmp+0x36>
c01054e4:	19 c0                	sbb    %eax,%eax
c01054e6:	0c 01                	or     $0x1,%al
c01054e8:	89 fa                	mov    %edi,%edx
c01054ea:	89 f1                	mov    %esi,%ecx
c01054ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054ef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01054f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01054f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01054f8:	83 c4 20             	add    $0x20,%esp
c01054fb:	5e                   	pop    %esi
c01054fc:	5f                   	pop    %edi
c01054fd:	5d                   	pop    %ebp
c01054fe:	c3                   	ret    

c01054ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01054ff:	f3 0f 1e fb          	endbr32 
c0105503:	55                   	push   %ebp
c0105504:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105506:	eb 09                	jmp    c0105511 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0105508:	ff 4d 10             	decl   0x10(%ebp)
c010550b:	ff 45 08             	incl   0x8(%ebp)
c010550e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105511:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105515:	74 1a                	je     c0105531 <strncmp+0x32>
c0105517:	8b 45 08             	mov    0x8(%ebp),%eax
c010551a:	0f b6 00             	movzbl (%eax),%eax
c010551d:	84 c0                	test   %al,%al
c010551f:	74 10                	je     c0105531 <strncmp+0x32>
c0105521:	8b 45 08             	mov    0x8(%ebp),%eax
c0105524:	0f b6 10             	movzbl (%eax),%edx
c0105527:	8b 45 0c             	mov    0xc(%ebp),%eax
c010552a:	0f b6 00             	movzbl (%eax),%eax
c010552d:	38 c2                	cmp    %al,%dl
c010552f:	74 d7                	je     c0105508 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105531:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105535:	74 18                	je     c010554f <strncmp+0x50>
c0105537:	8b 45 08             	mov    0x8(%ebp),%eax
c010553a:	0f b6 00             	movzbl (%eax),%eax
c010553d:	0f b6 d0             	movzbl %al,%edx
c0105540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105543:	0f b6 00             	movzbl (%eax),%eax
c0105546:	0f b6 c0             	movzbl %al,%eax
c0105549:	29 c2                	sub    %eax,%edx
c010554b:	89 d0                	mov    %edx,%eax
c010554d:	eb 05                	jmp    c0105554 <strncmp+0x55>
c010554f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105554:	5d                   	pop    %ebp
c0105555:	c3                   	ret    

c0105556 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105556:	f3 0f 1e fb          	endbr32 
c010555a:	55                   	push   %ebp
c010555b:	89 e5                	mov    %esp,%ebp
c010555d:	83 ec 04             	sub    $0x4,%esp
c0105560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105563:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105566:	eb 13                	jmp    c010557b <strchr+0x25>
        if (*s == c) {
c0105568:	8b 45 08             	mov    0x8(%ebp),%eax
c010556b:	0f b6 00             	movzbl (%eax),%eax
c010556e:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105571:	75 05                	jne    c0105578 <strchr+0x22>
            return (char *)s;
c0105573:	8b 45 08             	mov    0x8(%ebp),%eax
c0105576:	eb 12                	jmp    c010558a <strchr+0x34>
        }
        s ++;
c0105578:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010557b:	8b 45 08             	mov    0x8(%ebp),%eax
c010557e:	0f b6 00             	movzbl (%eax),%eax
c0105581:	84 c0                	test   %al,%al
c0105583:	75 e3                	jne    c0105568 <strchr+0x12>
    }
    return NULL;
c0105585:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010558a:	c9                   	leave  
c010558b:	c3                   	ret    

c010558c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010558c:	f3 0f 1e fb          	endbr32 
c0105590:	55                   	push   %ebp
c0105591:	89 e5                	mov    %esp,%ebp
c0105593:	83 ec 04             	sub    $0x4,%esp
c0105596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105599:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010559c:	eb 0e                	jmp    c01055ac <strfind+0x20>
        if (*s == c) {
c010559e:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a1:	0f b6 00             	movzbl (%eax),%eax
c01055a4:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01055a7:	74 0f                	je     c01055b8 <strfind+0x2c>
            break;
        }
        s ++;
c01055a9:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01055af:	0f b6 00             	movzbl (%eax),%eax
c01055b2:	84 c0                	test   %al,%al
c01055b4:	75 e8                	jne    c010559e <strfind+0x12>
c01055b6:	eb 01                	jmp    c01055b9 <strfind+0x2d>
            break;
c01055b8:	90                   	nop
    }
    return (char *)s;
c01055b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055bc:	c9                   	leave  
c01055bd:	c3                   	ret    

c01055be <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01055be:	f3 0f 1e fb          	endbr32 
c01055c2:	55                   	push   %ebp
c01055c3:	89 e5                	mov    %esp,%ebp
c01055c5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01055c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01055cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01055d6:	eb 03                	jmp    c01055db <strtol+0x1d>
        s ++;
c01055d8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01055db:	8b 45 08             	mov    0x8(%ebp),%eax
c01055de:	0f b6 00             	movzbl (%eax),%eax
c01055e1:	3c 20                	cmp    $0x20,%al
c01055e3:	74 f3                	je     c01055d8 <strtol+0x1a>
c01055e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e8:	0f b6 00             	movzbl (%eax),%eax
c01055eb:	3c 09                	cmp    $0x9,%al
c01055ed:	74 e9                	je     c01055d8 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c01055ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f2:	0f b6 00             	movzbl (%eax),%eax
c01055f5:	3c 2b                	cmp    $0x2b,%al
c01055f7:	75 05                	jne    c01055fe <strtol+0x40>
        s ++;
c01055f9:	ff 45 08             	incl   0x8(%ebp)
c01055fc:	eb 14                	jmp    c0105612 <strtol+0x54>
    }
    else if (*s == '-') {
c01055fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105601:	0f b6 00             	movzbl (%eax),%eax
c0105604:	3c 2d                	cmp    $0x2d,%al
c0105606:	75 0a                	jne    c0105612 <strtol+0x54>
        s ++, neg = 1;
c0105608:	ff 45 08             	incl   0x8(%ebp)
c010560b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105612:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105616:	74 06                	je     c010561e <strtol+0x60>
c0105618:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010561c:	75 22                	jne    c0105640 <strtol+0x82>
c010561e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105621:	0f b6 00             	movzbl (%eax),%eax
c0105624:	3c 30                	cmp    $0x30,%al
c0105626:	75 18                	jne    c0105640 <strtol+0x82>
c0105628:	8b 45 08             	mov    0x8(%ebp),%eax
c010562b:	40                   	inc    %eax
c010562c:	0f b6 00             	movzbl (%eax),%eax
c010562f:	3c 78                	cmp    $0x78,%al
c0105631:	75 0d                	jne    c0105640 <strtol+0x82>
        s += 2, base = 16;
c0105633:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105637:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010563e:	eb 29                	jmp    c0105669 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0105640:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105644:	75 16                	jne    c010565c <strtol+0x9e>
c0105646:	8b 45 08             	mov    0x8(%ebp),%eax
c0105649:	0f b6 00             	movzbl (%eax),%eax
c010564c:	3c 30                	cmp    $0x30,%al
c010564e:	75 0c                	jne    c010565c <strtol+0x9e>
        s ++, base = 8;
c0105650:	ff 45 08             	incl   0x8(%ebp)
c0105653:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010565a:	eb 0d                	jmp    c0105669 <strtol+0xab>
    }
    else if (base == 0) {
c010565c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105660:	75 07                	jne    c0105669 <strtol+0xab>
        base = 10;
c0105662:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105669:	8b 45 08             	mov    0x8(%ebp),%eax
c010566c:	0f b6 00             	movzbl (%eax),%eax
c010566f:	3c 2f                	cmp    $0x2f,%al
c0105671:	7e 1b                	jle    c010568e <strtol+0xd0>
c0105673:	8b 45 08             	mov    0x8(%ebp),%eax
c0105676:	0f b6 00             	movzbl (%eax),%eax
c0105679:	3c 39                	cmp    $0x39,%al
c010567b:	7f 11                	jg     c010568e <strtol+0xd0>
            dig = *s - '0';
c010567d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105680:	0f b6 00             	movzbl (%eax),%eax
c0105683:	0f be c0             	movsbl %al,%eax
c0105686:	83 e8 30             	sub    $0x30,%eax
c0105689:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010568c:	eb 48                	jmp    c01056d6 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010568e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105691:	0f b6 00             	movzbl (%eax),%eax
c0105694:	3c 60                	cmp    $0x60,%al
c0105696:	7e 1b                	jle    c01056b3 <strtol+0xf5>
c0105698:	8b 45 08             	mov    0x8(%ebp),%eax
c010569b:	0f b6 00             	movzbl (%eax),%eax
c010569e:	3c 7a                	cmp    $0x7a,%al
c01056a0:	7f 11                	jg     c01056b3 <strtol+0xf5>
            dig = *s - 'a' + 10;
c01056a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a5:	0f b6 00             	movzbl (%eax),%eax
c01056a8:	0f be c0             	movsbl %al,%eax
c01056ab:	83 e8 57             	sub    $0x57,%eax
c01056ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056b1:	eb 23                	jmp    c01056d6 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01056b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b6:	0f b6 00             	movzbl (%eax),%eax
c01056b9:	3c 40                	cmp    $0x40,%al
c01056bb:	7e 3b                	jle    c01056f8 <strtol+0x13a>
c01056bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c0:	0f b6 00             	movzbl (%eax),%eax
c01056c3:	3c 5a                	cmp    $0x5a,%al
c01056c5:	7f 31                	jg     c01056f8 <strtol+0x13a>
            dig = *s - 'A' + 10;
c01056c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ca:	0f b6 00             	movzbl (%eax),%eax
c01056cd:	0f be c0             	movsbl %al,%eax
c01056d0:	83 e8 37             	sub    $0x37,%eax
c01056d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01056d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d9:	3b 45 10             	cmp    0x10(%ebp),%eax
c01056dc:	7d 19                	jge    c01056f7 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c01056de:	ff 45 08             	incl   0x8(%ebp)
c01056e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056e4:	0f af 45 10          	imul   0x10(%ebp),%eax
c01056e8:	89 c2                	mov    %eax,%edx
c01056ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ed:	01 d0                	add    %edx,%eax
c01056ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01056f2:	e9 72 ff ff ff       	jmp    c0105669 <strtol+0xab>
            break;
c01056f7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01056f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056fc:	74 08                	je     c0105706 <strtol+0x148>
        *endptr = (char *) s;
c01056fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105701:	8b 55 08             	mov    0x8(%ebp),%edx
c0105704:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105706:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010570a:	74 07                	je     c0105713 <strtol+0x155>
c010570c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010570f:	f7 d8                	neg    %eax
c0105711:	eb 03                	jmp    c0105716 <strtol+0x158>
c0105713:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105716:	c9                   	leave  
c0105717:	c3                   	ret    

c0105718 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105718:	f3 0f 1e fb          	endbr32 
c010571c:	55                   	push   %ebp
c010571d:	89 e5                	mov    %esp,%ebp
c010571f:	57                   	push   %edi
c0105720:	83 ec 24             	sub    $0x24,%esp
c0105723:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105726:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105729:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c010572d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105730:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105733:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105736:	8b 45 10             	mov    0x10(%ebp),%eax
c0105739:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010573c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010573f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105743:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105746:	89 d7                	mov    %edx,%edi
c0105748:	f3 aa                	rep stos %al,%es:(%edi)
c010574a:	89 fa                	mov    %edi,%edx
c010574c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010574f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105752:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105755:	83 c4 24             	add    $0x24,%esp
c0105758:	5f                   	pop    %edi
c0105759:	5d                   	pop    %ebp
c010575a:	c3                   	ret    

c010575b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010575b:	f3 0f 1e fb          	endbr32 
c010575f:	55                   	push   %ebp
c0105760:	89 e5                	mov    %esp,%ebp
c0105762:	57                   	push   %edi
c0105763:	56                   	push   %esi
c0105764:	53                   	push   %ebx
c0105765:	83 ec 30             	sub    $0x30,%esp
c0105768:	8b 45 08             	mov    0x8(%ebp),%eax
c010576b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010576e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105771:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105774:	8b 45 10             	mov    0x10(%ebp),%eax
c0105777:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010577a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010577d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105780:	73 42                	jae    c01057c4 <memmove+0x69>
c0105782:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105788:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010578b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010578e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105791:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105794:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105797:	c1 e8 02             	shr    $0x2,%eax
c010579a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010579c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010579f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057a2:	89 d7                	mov    %edx,%edi
c01057a4:	89 c6                	mov    %eax,%esi
c01057a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01057a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01057ab:	83 e1 03             	and    $0x3,%ecx
c01057ae:	74 02                	je     c01057b2 <memmove+0x57>
c01057b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057b2:	89 f0                	mov    %esi,%eax
c01057b4:	89 fa                	mov    %edi,%edx
c01057b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01057b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01057bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01057bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01057c2:	eb 36                	jmp    c01057fa <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01057c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057cd:	01 c2                	add    %eax,%edx
c01057cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057d2:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01057db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057de:	89 c1                	mov    %eax,%ecx
c01057e0:	89 d8                	mov    %ebx,%eax
c01057e2:	89 d6                	mov    %edx,%esi
c01057e4:	89 c7                	mov    %eax,%edi
c01057e6:	fd                   	std    
c01057e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057e9:	fc                   	cld    
c01057ea:	89 f8                	mov    %edi,%eax
c01057ec:	89 f2                	mov    %esi,%edx
c01057ee:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01057f1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01057f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01057f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01057fa:	83 c4 30             	add    $0x30,%esp
c01057fd:	5b                   	pop    %ebx
c01057fe:	5e                   	pop    %esi
c01057ff:	5f                   	pop    %edi
c0105800:	5d                   	pop    %ebp
c0105801:	c3                   	ret    

c0105802 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105802:	f3 0f 1e fb          	endbr32 
c0105806:	55                   	push   %ebp
c0105807:	89 e5                	mov    %esp,%ebp
c0105809:	57                   	push   %edi
c010580a:	56                   	push   %esi
c010580b:	83 ec 20             	sub    $0x20,%esp
c010580e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105811:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105814:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105817:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010581a:	8b 45 10             	mov    0x10(%ebp),%eax
c010581d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105820:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105823:	c1 e8 02             	shr    $0x2,%eax
c0105826:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105828:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010582b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010582e:	89 d7                	mov    %edx,%edi
c0105830:	89 c6                	mov    %eax,%esi
c0105832:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105834:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105837:	83 e1 03             	and    $0x3,%ecx
c010583a:	74 02                	je     c010583e <memcpy+0x3c>
c010583c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010583e:	89 f0                	mov    %esi,%eax
c0105840:	89 fa                	mov    %edi,%edx
c0105842:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105845:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105848:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010584b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010584e:	83 c4 20             	add    $0x20,%esp
c0105851:	5e                   	pop    %esi
c0105852:	5f                   	pop    %edi
c0105853:	5d                   	pop    %ebp
c0105854:	c3                   	ret    

c0105855 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105855:	f3 0f 1e fb          	endbr32 
c0105859:	55                   	push   %ebp
c010585a:	89 e5                	mov    %esp,%ebp
c010585c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010585f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105862:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105865:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105868:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010586b:	eb 2e                	jmp    c010589b <memcmp+0x46>
        if (*s1 != *s2) {
c010586d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105870:	0f b6 10             	movzbl (%eax),%edx
c0105873:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105876:	0f b6 00             	movzbl (%eax),%eax
c0105879:	38 c2                	cmp    %al,%dl
c010587b:	74 18                	je     c0105895 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010587d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105880:	0f b6 00             	movzbl (%eax),%eax
c0105883:	0f b6 d0             	movzbl %al,%edx
c0105886:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105889:	0f b6 00             	movzbl (%eax),%eax
c010588c:	0f b6 c0             	movzbl %al,%eax
c010588f:	29 c2                	sub    %eax,%edx
c0105891:	89 d0                	mov    %edx,%eax
c0105893:	eb 18                	jmp    c01058ad <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0105895:	ff 45 fc             	incl   -0x4(%ebp)
c0105898:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010589b:	8b 45 10             	mov    0x10(%ebp),%eax
c010589e:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058a1:	89 55 10             	mov    %edx,0x10(%ebp)
c01058a4:	85 c0                	test   %eax,%eax
c01058a6:	75 c5                	jne    c010586d <memcmp+0x18>
    }
    return 0;
c01058a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01058ad:	c9                   	leave  
c01058ae:	c3                   	ret    

c01058af <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01058af:	f3 0f 1e fb          	endbr32 
c01058b3:	55                   	push   %ebp
c01058b4:	89 e5                	mov    %esp,%ebp
c01058b6:	83 ec 58             	sub    $0x58,%esp
c01058b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01058bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01058bf:	8b 45 14             	mov    0x14(%ebp),%eax
c01058c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01058c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01058d1:	8b 45 18             	mov    0x18(%ebp),%eax
c01058d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058da:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01058dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058e0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01058e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058ed:	74 1c                	je     c010590b <printnum+0x5c>
c01058ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f2:	ba 00 00 00 00       	mov    $0x0,%edx
c01058f7:	f7 75 e4             	divl   -0x1c(%ebp)
c01058fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01058fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105900:	ba 00 00 00 00       	mov    $0x0,%edx
c0105905:	f7 75 e4             	divl   -0x1c(%ebp)
c0105908:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010590e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105911:	f7 75 e4             	divl   -0x1c(%ebp)
c0105914:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105917:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010591a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010591d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105920:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105923:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105929:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010592c:	8b 45 18             	mov    0x18(%ebp),%eax
c010592f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105934:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105937:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010593a:	19 d1                	sbb    %edx,%ecx
c010593c:	72 4c                	jb     c010598a <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c010593e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105941:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105944:	8b 45 20             	mov    0x20(%ebp),%eax
c0105947:	89 44 24 18          	mov    %eax,0x18(%esp)
c010594b:	89 54 24 14          	mov    %edx,0x14(%esp)
c010594f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105952:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105956:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105959:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010595c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105960:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105964:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105967:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596b:	8b 45 08             	mov    0x8(%ebp),%eax
c010596e:	89 04 24             	mov    %eax,(%esp)
c0105971:	e8 39 ff ff ff       	call   c01058af <printnum>
c0105976:	eb 1b                	jmp    c0105993 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105978:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010597f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105982:	89 04 24             	mov    %eax,(%esp)
c0105985:	8b 45 08             	mov    0x8(%ebp),%eax
c0105988:	ff d0                	call   *%eax
        while (-- width > 0)
c010598a:	ff 4d 1c             	decl   0x1c(%ebp)
c010598d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105991:	7f e5                	jg     c0105978 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105993:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105996:	05 cc 70 10 c0       	add    $0xc01070cc,%eax
c010599b:	0f b6 00             	movzbl (%eax),%eax
c010599e:	0f be c0             	movsbl %al,%eax
c01059a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059a8:	89 04 24             	mov    %eax,(%esp)
c01059ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ae:	ff d0                	call   *%eax
}
c01059b0:	90                   	nop
c01059b1:	c9                   	leave  
c01059b2:	c3                   	ret    

c01059b3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01059b3:	f3 0f 1e fb          	endbr32 
c01059b7:	55                   	push   %ebp
c01059b8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01059ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01059be:	7e 14                	jle    c01059d4 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c01059c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c3:	8b 00                	mov    (%eax),%eax
c01059c5:	8d 48 08             	lea    0x8(%eax),%ecx
c01059c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01059cb:	89 0a                	mov    %ecx,(%edx)
c01059cd:	8b 50 04             	mov    0x4(%eax),%edx
c01059d0:	8b 00                	mov    (%eax),%eax
c01059d2:	eb 30                	jmp    c0105a04 <getuint+0x51>
    }
    else if (lflag) {
c01059d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059d8:	74 16                	je     c01059f0 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c01059da:	8b 45 08             	mov    0x8(%ebp),%eax
c01059dd:	8b 00                	mov    (%eax),%eax
c01059df:	8d 48 04             	lea    0x4(%eax),%ecx
c01059e2:	8b 55 08             	mov    0x8(%ebp),%edx
c01059e5:	89 0a                	mov    %ecx,(%edx)
c01059e7:	8b 00                	mov    (%eax),%eax
c01059e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01059ee:	eb 14                	jmp    c0105a04 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	8b 00                	mov    (%eax),%eax
c01059f5:	8d 48 04             	lea    0x4(%eax),%ecx
c01059f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01059fb:	89 0a                	mov    %ecx,(%edx)
c01059fd:	8b 00                	mov    (%eax),%eax
c01059ff:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105a04:	5d                   	pop    %ebp
c0105a05:	c3                   	ret    

c0105a06 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105a06:	f3 0f 1e fb          	endbr32 
c0105a0a:	55                   	push   %ebp
c0105a0b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105a0d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105a11:	7e 14                	jle    c0105a27 <getint+0x21>
        return va_arg(*ap, long long);
c0105a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a16:	8b 00                	mov    (%eax),%eax
c0105a18:	8d 48 08             	lea    0x8(%eax),%ecx
c0105a1b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a1e:	89 0a                	mov    %ecx,(%edx)
c0105a20:	8b 50 04             	mov    0x4(%eax),%edx
c0105a23:	8b 00                	mov    (%eax),%eax
c0105a25:	eb 28                	jmp    c0105a4f <getint+0x49>
    }
    else if (lflag) {
c0105a27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a2b:	74 12                	je     c0105a3f <getint+0x39>
        return va_arg(*ap, long);
c0105a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a30:	8b 00                	mov    (%eax),%eax
c0105a32:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a35:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a38:	89 0a                	mov    %ecx,(%edx)
c0105a3a:	8b 00                	mov    (%eax),%eax
c0105a3c:	99                   	cltd   
c0105a3d:	eb 10                	jmp    c0105a4f <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0105a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a42:	8b 00                	mov    (%eax),%eax
c0105a44:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a47:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a4a:	89 0a                	mov    %ecx,(%edx)
c0105a4c:	8b 00                	mov    (%eax),%eax
c0105a4e:	99                   	cltd   
    }
}
c0105a4f:	5d                   	pop    %ebp
c0105a50:	c3                   	ret    

c0105a51 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105a51:	f3 0f 1e fb          	endbr32 
c0105a55:	55                   	push   %ebp
c0105a56:	89 e5                	mov    %esp,%ebp
c0105a58:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105a5b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a68:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a79:	89 04 24             	mov    %eax,(%esp)
c0105a7c:	e8 03 00 00 00       	call   c0105a84 <vprintfmt>
    va_end(ap);
}
c0105a81:	90                   	nop
c0105a82:	c9                   	leave  
c0105a83:	c3                   	ret    

c0105a84 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105a84:	f3 0f 1e fb          	endbr32 
c0105a88:	55                   	push   %ebp
c0105a89:	89 e5                	mov    %esp,%ebp
c0105a8b:	56                   	push   %esi
c0105a8c:	53                   	push   %ebx
c0105a8d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a90:	eb 17                	jmp    c0105aa9 <vprintfmt+0x25>
            if (ch == '\0') {
c0105a92:	85 db                	test   %ebx,%ebx
c0105a94:	0f 84 c0 03 00 00    	je     c0105e5a <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c0105a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa1:	89 1c 24             	mov    %ebx,(%esp)
c0105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa7:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105aa9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aac:	8d 50 01             	lea    0x1(%eax),%edx
c0105aaf:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ab2:	0f b6 00             	movzbl (%eax),%eax
c0105ab5:	0f b6 d8             	movzbl %al,%ebx
c0105ab8:	83 fb 25             	cmp    $0x25,%ebx
c0105abb:	75 d5                	jne    c0105a92 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105abd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105ac1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105acb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105ace:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105ad5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105adb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ade:	8d 50 01             	lea    0x1(%eax),%edx
c0105ae1:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ae4:	0f b6 00             	movzbl (%eax),%eax
c0105ae7:	0f b6 d8             	movzbl %al,%ebx
c0105aea:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105aed:	83 f8 55             	cmp    $0x55,%eax
c0105af0:	0f 87 38 03 00 00    	ja     c0105e2e <vprintfmt+0x3aa>
c0105af6:	8b 04 85 f0 70 10 c0 	mov    -0x3fef8f10(,%eax,4),%eax
c0105afd:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105b00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105b04:	eb d5                	jmp    c0105adb <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105b06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105b0a:	eb cf                	jmp    c0105adb <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105b0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105b13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b16:	89 d0                	mov    %edx,%eax
c0105b18:	c1 e0 02             	shl    $0x2,%eax
c0105b1b:	01 d0                	add    %edx,%eax
c0105b1d:	01 c0                	add    %eax,%eax
c0105b1f:	01 d8                	add    %ebx,%eax
c0105b21:	83 e8 30             	sub    $0x30,%eax
c0105b24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105b27:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b2a:	0f b6 00             	movzbl (%eax),%eax
c0105b2d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105b30:	83 fb 2f             	cmp    $0x2f,%ebx
c0105b33:	7e 38                	jle    c0105b6d <vprintfmt+0xe9>
c0105b35:	83 fb 39             	cmp    $0x39,%ebx
c0105b38:	7f 33                	jg     c0105b6d <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0105b3a:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105b3d:	eb d4                	jmp    c0105b13 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105b3f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b42:	8d 50 04             	lea    0x4(%eax),%edx
c0105b45:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b48:	8b 00                	mov    (%eax),%eax
c0105b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105b4d:	eb 1f                	jmp    c0105b6e <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0105b4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b53:	79 86                	jns    c0105adb <vprintfmt+0x57>
                width = 0;
c0105b55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105b5c:	e9 7a ff ff ff       	jmp    c0105adb <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0105b61:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105b68:	e9 6e ff ff ff       	jmp    c0105adb <vprintfmt+0x57>
            goto process_precision;
c0105b6d:	90                   	nop

        process_precision:
            if (width < 0)
c0105b6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b72:	0f 89 63 ff ff ff    	jns    c0105adb <vprintfmt+0x57>
                width = precision, precision = -1;
c0105b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105b85:	e9 51 ff ff ff       	jmp    c0105adb <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105b8a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105b8d:	e9 49 ff ff ff       	jmp    c0105adb <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105b92:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b95:	8d 50 04             	lea    0x4(%eax),%edx
c0105b98:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b9b:	8b 00                	mov    (%eax),%eax
c0105b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ba4:	89 04 24             	mov    %eax,(%esp)
c0105ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baa:	ff d0                	call   *%eax
            break;
c0105bac:	e9 a4 02 00 00       	jmp    c0105e55 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105bb1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bb4:	8d 50 04             	lea    0x4(%eax),%edx
c0105bb7:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bba:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105bbc:	85 db                	test   %ebx,%ebx
c0105bbe:	79 02                	jns    c0105bc2 <vprintfmt+0x13e>
                err = -err;
c0105bc0:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105bc2:	83 fb 06             	cmp    $0x6,%ebx
c0105bc5:	7f 0b                	jg     c0105bd2 <vprintfmt+0x14e>
c0105bc7:	8b 34 9d b0 70 10 c0 	mov    -0x3fef8f50(,%ebx,4),%esi
c0105bce:	85 f6                	test   %esi,%esi
c0105bd0:	75 23                	jne    c0105bf5 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0105bd2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105bd6:	c7 44 24 08 dd 70 10 	movl   $0xc01070dd,0x8(%esp)
c0105bdd:	c0 
c0105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be8:	89 04 24             	mov    %eax,(%esp)
c0105beb:	e8 61 fe ff ff       	call   c0105a51 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105bf0:	e9 60 02 00 00       	jmp    c0105e55 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0105bf5:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105bf9:	c7 44 24 08 e6 70 10 	movl   $0xc01070e6,0x8(%esp)
c0105c00:	c0 
c0105c01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0b:	89 04 24             	mov    %eax,(%esp)
c0105c0e:	e8 3e fe ff ff       	call   c0105a51 <printfmt>
            break;
c0105c13:	e9 3d 02 00 00       	jmp    c0105e55 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105c18:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c1b:	8d 50 04             	lea    0x4(%eax),%edx
c0105c1e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c21:	8b 30                	mov    (%eax),%esi
c0105c23:	85 f6                	test   %esi,%esi
c0105c25:	75 05                	jne    c0105c2c <vprintfmt+0x1a8>
                p = "(null)";
c0105c27:	be e9 70 10 c0       	mov    $0xc01070e9,%esi
            }
            if (width > 0 && padc != '-') {
c0105c2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c30:	7e 76                	jle    c0105ca8 <vprintfmt+0x224>
c0105c32:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105c36:	74 70                	je     c0105ca8 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c3f:	89 34 24             	mov    %esi,(%esp)
c0105c42:	e8 ba f7 ff ff       	call   c0105401 <strnlen>
c0105c47:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c4a:	29 c2                	sub    %eax,%edx
c0105c4c:	89 d0                	mov    %edx,%eax
c0105c4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c51:	eb 16                	jmp    c0105c69 <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0105c53:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105c57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c5a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c5e:	89 04 24             	mov    %eax,(%esp)
c0105c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c64:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c66:	ff 4d e8             	decl   -0x18(%ebp)
c0105c69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c6d:	7f e4                	jg     c0105c53 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105c6f:	eb 37                	jmp    c0105ca8 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105c75:	74 1f                	je     c0105c96 <vprintfmt+0x212>
c0105c77:	83 fb 1f             	cmp    $0x1f,%ebx
c0105c7a:	7e 05                	jle    c0105c81 <vprintfmt+0x1fd>
c0105c7c:	83 fb 7e             	cmp    $0x7e,%ebx
c0105c7f:	7e 15                	jle    c0105c96 <vprintfmt+0x212>
                    putch('?', putdat);
c0105c81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c88:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c92:	ff d0                	call   *%eax
c0105c94:	eb 0f                	jmp    c0105ca5 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0105c96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c9d:	89 1c 24             	mov    %ebx,(%esp)
c0105ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca3:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ca5:	ff 4d e8             	decl   -0x18(%ebp)
c0105ca8:	89 f0                	mov    %esi,%eax
c0105caa:	8d 70 01             	lea    0x1(%eax),%esi
c0105cad:	0f b6 00             	movzbl (%eax),%eax
c0105cb0:	0f be d8             	movsbl %al,%ebx
c0105cb3:	85 db                	test   %ebx,%ebx
c0105cb5:	74 27                	je     c0105cde <vprintfmt+0x25a>
c0105cb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cbb:	78 b4                	js     c0105c71 <vprintfmt+0x1ed>
c0105cbd:	ff 4d e4             	decl   -0x1c(%ebp)
c0105cc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cc4:	79 ab                	jns    c0105c71 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0105cc6:	eb 16                	jmp    c0105cde <vprintfmt+0x25a>
                putch(' ', putdat);
c0105cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ccf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd9:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105cdb:	ff 4d e8             	decl   -0x18(%ebp)
c0105cde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ce2:	7f e4                	jg     c0105cc8 <vprintfmt+0x244>
            }
            break;
c0105ce4:	e9 6c 01 00 00       	jmp    c0105e55 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cf0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105cf3:	89 04 24             	mov    %eax,(%esp)
c0105cf6:	e8 0b fd ff ff       	call   c0105a06 <getint>
c0105cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d07:	85 d2                	test   %edx,%edx
c0105d09:	79 26                	jns    c0105d31 <vprintfmt+0x2ad>
                putch('-', putdat);
c0105d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d12:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1c:	ff d0                	call   *%eax
                num = -(long long)num;
c0105d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d24:	f7 d8                	neg    %eax
c0105d26:	83 d2 00             	adc    $0x0,%edx
c0105d29:	f7 da                	neg    %edx
c0105d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105d31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d38:	e9 a8 00 00 00       	jmp    c0105de5 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d44:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d47:	89 04 24             	mov    %eax,(%esp)
c0105d4a:	e8 64 fc ff ff       	call   c01059b3 <getuint>
c0105d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d52:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105d55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d5c:	e9 84 00 00 00       	jmp    c0105de5 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d68:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d6b:	89 04 24             	mov    %eax,(%esp)
c0105d6e:	e8 40 fc ff ff       	call   c01059b3 <getuint>
c0105d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105d79:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105d80:	eb 63                	jmp    c0105de5 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0105d82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d89:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105d90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d93:	ff d0                	call   *%eax
            putch('x', putdat);
c0105d95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d9c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105da3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105da8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dab:	8d 50 04             	lea    0x4(%eax),%edx
c0105dae:	89 55 14             	mov    %edx,0x14(%ebp)
c0105db1:	8b 00                	mov    (%eax),%eax
c0105db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105dbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105dc4:	eb 1f                	jmp    c0105de5 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dcd:	8d 45 14             	lea    0x14(%ebp),%eax
c0105dd0:	89 04 24             	mov    %eax,(%esp)
c0105dd3:	e8 db fb ff ff       	call   c01059b3 <getuint>
c0105dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105dde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105de5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dec:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105df0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105df3:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105df7:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e01:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e05:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e13:	89 04 24             	mov    %eax,(%esp)
c0105e16:	e8 94 fa ff ff       	call   c01058af <printnum>
            break;
c0105e1b:	eb 38                	jmp    c0105e55 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e24:	89 1c 24             	mov    %ebx,(%esp)
c0105e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2a:	ff d0                	call   *%eax
            break;
c0105e2c:	eb 27                	jmp    c0105e55 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e35:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105e41:	ff 4d 10             	decl   0x10(%ebp)
c0105e44:	eb 03                	jmp    c0105e49 <vprintfmt+0x3c5>
c0105e46:	ff 4d 10             	decl   0x10(%ebp)
c0105e49:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e4c:	48                   	dec    %eax
c0105e4d:	0f b6 00             	movzbl (%eax),%eax
c0105e50:	3c 25                	cmp    $0x25,%al
c0105e52:	75 f2                	jne    c0105e46 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c0105e54:	90                   	nop
    while (1) {
c0105e55:	e9 36 fc ff ff       	jmp    c0105a90 <vprintfmt+0xc>
                return;
c0105e5a:	90                   	nop
        }
    }
}
c0105e5b:	83 c4 40             	add    $0x40,%esp
c0105e5e:	5b                   	pop    %ebx
c0105e5f:	5e                   	pop    %esi
c0105e60:	5d                   	pop    %ebp
c0105e61:	c3                   	ret    

c0105e62 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105e62:	f3 0f 1e fb          	endbr32 
c0105e66:	55                   	push   %ebp
c0105e67:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105e69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e6c:	8b 40 08             	mov    0x8(%eax),%eax
c0105e6f:	8d 50 01             	lea    0x1(%eax),%edx
c0105e72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e75:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7b:	8b 10                	mov    (%eax),%edx
c0105e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e80:	8b 40 04             	mov    0x4(%eax),%eax
c0105e83:	39 c2                	cmp    %eax,%edx
c0105e85:	73 12                	jae    c0105e99 <sprintputch+0x37>
        *b->buf ++ = ch;
c0105e87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e8a:	8b 00                	mov    (%eax),%eax
c0105e8c:	8d 48 01             	lea    0x1(%eax),%ecx
c0105e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e92:	89 0a                	mov    %ecx,(%edx)
c0105e94:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e97:	88 10                	mov    %dl,(%eax)
    }
}
c0105e99:	90                   	nop
c0105e9a:	5d                   	pop    %ebp
c0105e9b:	c3                   	ret    

c0105e9c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105e9c:	f3 0f 1e fb          	endbr32 
c0105ea0:	55                   	push   %ebp
c0105ea1:	89 e5                	mov    %esp,%ebp
c0105ea3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105ea6:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105eb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eb6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105eba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ec1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec4:	89 04 24             	mov    %eax,(%esp)
c0105ec7:	e8 08 00 00 00       	call   c0105ed4 <vsnprintf>
c0105ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ed2:	c9                   	leave  
c0105ed3:	c3                   	ret    

c0105ed4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ed4:	f3 0f 1e fb          	endbr32 
c0105ed8:	55                   	push   %ebp
c0105ed9:	89 e5                	mov    %esp,%ebp
c0105edb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ee7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eed:	01 d0                	add    %edx,%eax
c0105eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105ef9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105efd:	74 0a                	je     c0105f09 <vsnprintf+0x35>
c0105eff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f05:	39 c2                	cmp    %eax,%edx
c0105f07:	76 07                	jbe    c0105f10 <vsnprintf+0x3c>
        return -E_INVAL;
c0105f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105f0e:	eb 2a                	jmp    c0105f3a <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105f10:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f13:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f17:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f1a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105f21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f25:	c7 04 24 62 5e 10 c0 	movl   $0xc0105e62,(%esp)
c0105f2c:	e8 53 fb ff ff       	call   c0105a84 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f34:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f3a:	c9                   	leave  
c0105f3b:	c3                   	ret    
