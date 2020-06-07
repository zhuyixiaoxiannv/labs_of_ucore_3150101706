
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  10000f:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100027:	e8 cf 2b 00 00       	call   102bfb <memset>

    cons_init();                // init the console
  10002c:	e8 08 16 00 00       	call   101639 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 20 34 10 00 	movl   $0x103420,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 3c 34 10 00 	movl   $0x10343c,(%esp)
  100046:	e8 39 02 00 00       	call   100284 <cprintf>

    print_kerninfo();
  10004b:	e8 f7 08 00 00       	call   100947 <print_kerninfo>

    grade_backtrace();
  100050:	e8 95 00 00 00       	call   1000ea <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 50 28 00 00       	call   1028aa <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 2f 17 00 00       	call   10178e <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 af 18 00 00       	call   101913 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 55 0d 00 00       	call   100dbe <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 6c 18 00 00       	call   1018da <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	f3 0f 1e fb          	endbr32 
  100074:	55                   	push   %ebp
  100075:	89 e5                	mov    %esp,%ebp
  100077:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100081:	00 
  100082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100089:	00 
  10008a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100091:	e8 12 0d 00 00       	call   100da8 <mon_backtrace>
}
  100096:	90                   	nop
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	f3 0f 1e fb          	endbr32 
  10009d:	55                   	push   %ebp
  10009e:	89 e5                	mov    %esp,%ebp
  1000a0:	53                   	push   %ebx
  1000a1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a4:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000aa:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000bc:	89 04 24             	mov    %eax,(%esp)
  1000bf:	e8 ac ff ff ff       	call   100070 <grade_backtrace2>
}
  1000c4:	90                   	nop
  1000c5:	83 c4 14             	add    $0x14,%esp
  1000c8:	5b                   	pop    %ebx
  1000c9:	5d                   	pop    %ebp
  1000ca:	c3                   	ret    

001000cb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000cb:	f3 0f 1e fb          	endbr32 
  1000cf:	55                   	push   %ebp
  1000d0:	89 e5                	mov    %esp,%ebp
  1000d2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000df:	89 04 24             	mov    %eax,(%esp)
  1000e2:	e8 b2 ff ff ff       	call   100099 <grade_backtrace1>
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <grade_backtrace>:

void
grade_backtrace(void) {
  1000ea:	f3 0f 1e fb          	endbr32 
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f9:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100100:	ff 
  100101:	89 44 24 04          	mov    %eax,0x4(%esp)
  100105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10010c:	e8 ba ff ff ff       	call   1000cb <grade_backtrace0>
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100114:	f3 0f 1e fb          	endbr32 
  100118:	55                   	push   %ebp
  100119:	89 e5                	mov    %esp,%ebp
  10011b:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10011e:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100121:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100124:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100127:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10012e:	83 e0 03             	and    $0x3,%eax
  100131:	89 c2                	mov    %eax,%edx
  100133:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100138:	89 54 24 08          	mov    %edx,0x8(%esp)
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 41 34 10 00 	movl   $0x103441,(%esp)
  100147:	e8 38 01 00 00       	call   100284 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100150:	89 c2                	mov    %eax,%edx
  100152:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100157:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015f:	c7 04 24 4f 34 10 00 	movl   $0x10344f,(%esp)
  100166:	e8 19 01 00 00       	call   100284 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10016b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10016f:	89 c2                	mov    %eax,%edx
  100171:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100176:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017e:	c7 04 24 5d 34 10 00 	movl   $0x10345d,(%esp)
  100185:	e8 fa 00 00 00       	call   100284 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10018e:	89 c2                	mov    %eax,%edx
  100190:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100195:	89 54 24 08          	mov    %edx,0x8(%esp)
  100199:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019d:	c7 04 24 6b 34 10 00 	movl   $0x10346b,(%esp)
  1001a4:	e8 db 00 00 00       	call   100284 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001a9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ad:	89 c2                	mov    %eax,%edx
  1001af:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bc:	c7 04 24 79 34 10 00 	movl   $0x103479,(%esp)
  1001c3:	e8 bc 00 00 00       	call   100284 <cprintf>
    round ++;
  1001c8:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001cd:	40                   	inc    %eax
  1001ce:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001d3:	90                   	nop
  1001d4:	c9                   	leave  
  1001d5:	c3                   	ret    

001001d6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d6:	f3 0f 1e fb          	endbr32 
  1001da:	55                   	push   %ebp
  1001db:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001dd:	90                   	nop
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001e0:	f3 0f 1e fb          	endbr32 
  1001e4:	55                   	push   %ebp
  1001e5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001e7:	90                   	nop
  1001e8:	5d                   	pop    %ebp
  1001e9:	c3                   	ret    

001001ea <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ea:	f3 0f 1e fb          	endbr32 
  1001ee:	55                   	push   %ebp
  1001ef:	89 e5                	mov    %esp,%ebp
  1001f1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001f4:	e8 1b ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001f9:	c7 04 24 88 34 10 00 	movl   $0x103488,(%esp)
  100200:	e8 7f 00 00 00       	call   100284 <cprintf>
    lab1_switch_to_user();
  100205:	e8 cc ff ff ff       	call   1001d6 <lab1_switch_to_user>
    lab1_print_cur_status();
  10020a:	e8 05 ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10020f:	c7 04 24 a8 34 10 00 	movl   $0x1034a8,(%esp)
  100216:	e8 69 00 00 00       	call   100284 <cprintf>
    lab1_switch_to_kernel();
  10021b:	e8 c0 ff ff ff       	call   1001e0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100220:	e8 ef fe ff ff       	call   100114 <lab1_print_cur_status>
}
  100225:	90                   	nop
  100226:	c9                   	leave  
  100227:	c3                   	ret    

00100228 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100228:	f3 0f 1e fb          	endbr32 
  10022c:	55                   	push   %ebp
  10022d:	89 e5                	mov    %esp,%ebp
  10022f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100232:	8b 45 08             	mov    0x8(%ebp),%eax
  100235:	89 04 24             	mov    %eax,(%esp)
  100238:	e8 2d 14 00 00       	call   10166a <cons_putc>
    (*cnt) ++;
  10023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100240:	8b 00                	mov    (%eax),%eax
  100242:	8d 50 01             	lea    0x1(%eax),%edx
  100245:	8b 45 0c             	mov    0xc(%ebp),%eax
  100248:	89 10                	mov    %edx,(%eax)
}
  10024a:	90                   	nop
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10024d:	f3 0f 1e fb          	endbr32 
  100251:	55                   	push   %ebp
  100252:	89 e5                	mov    %esp,%ebp
  100254:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100265:	8b 45 08             	mov    0x8(%ebp),%eax
  100268:	89 44 24 08          	mov    %eax,0x8(%esp)
  10026c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100273:	c7 04 24 28 02 10 00 	movl   $0x100228,(%esp)
  10027a:	e8 e8 2c 00 00       	call   102f67 <vprintfmt>
    return cnt;
  10027f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100282:	c9                   	leave  
  100283:	c3                   	ret    

00100284 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100284:	f3 0f 1e fb          	endbr32 
  100288:	55                   	push   %ebp
  100289:	89 e5                	mov    %esp,%ebp
  10028b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10028e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100297:	89 44 24 04          	mov    %eax,0x4(%esp)
  10029b:	8b 45 08             	mov    0x8(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 a7 ff ff ff       	call   10024d <vcprintf>
  1002a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ac:	c9                   	leave  
  1002ad:	c3                   	ret    

001002ae <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ae:	f3 0f 1e fb          	endbr32 
  1002b2:	55                   	push   %ebp
  1002b3:	89 e5                	mov    %esp,%ebp
  1002b5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	89 04 24             	mov    %eax,(%esp)
  1002be:	e8 a7 13 00 00       	call   10166a <cons_putc>
}
  1002c3:	90                   	nop
  1002c4:	c9                   	leave  
  1002c5:	c3                   	ret    

001002c6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c6:	f3 0f 1e fb          	endbr32 
  1002ca:	55                   	push   %ebp
  1002cb:	89 e5                	mov    %esp,%ebp
  1002cd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d7:	eb 13                	jmp    1002ec <cputs+0x26>
        cputch(c, &cnt);
  1002d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002dd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 3c ff ff ff       	call   100228 <cputch>
    while ((c = *str ++) != '\0') {
  1002ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ef:	8d 50 01             	lea    0x1(%eax),%edx
  1002f2:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f5:	0f b6 00             	movzbl (%eax),%eax
  1002f8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fb:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ff:	75 d8                	jne    1002d9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100304:	89 44 24 04          	mov    %eax,0x4(%esp)
  100308:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030f:	e8 14 ff ff ff       	call   100228 <cputch>
    return cnt;
  100314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100317:	c9                   	leave  
  100318:	c3                   	ret    

00100319 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100319:	f3 0f 1e fb          	endbr32 
  10031d:	55                   	push   %ebp
  10031e:	89 e5                	mov    %esp,%ebp
  100320:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100323:	90                   	nop
  100324:	e8 6f 13 00 00       	call   101698 <cons_getc>
  100329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10032c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100330:	74 f2                	je     100324 <getchar+0xb>
        /* do nothing */;
    return c;
  100332:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100335:	c9                   	leave  
  100336:	c3                   	ret    

00100337 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100337:	f3 0f 1e fb          	endbr32 
  10033b:	55                   	push   %ebp
  10033c:	89 e5                	mov    %esp,%ebp
  10033e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100345:	74 13                	je     10035a <readline+0x23>
        cprintf("%s", prompt);
  100347:	8b 45 08             	mov    0x8(%ebp),%eax
  10034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034e:	c7 04 24 c7 34 10 00 	movl   $0x1034c7,(%esp)
  100355:	e8 2a ff ff ff       	call   100284 <cprintf>
    }
    int i = 0, c;
  10035a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100361:	e8 b3 ff ff ff       	call   100319 <getchar>
  100366:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10036d:	79 07                	jns    100376 <readline+0x3f>
            return NULL;
  10036f:	b8 00 00 00 00       	mov    $0x0,%eax
  100374:	eb 78                	jmp    1003ee <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100376:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10037a:	7e 28                	jle    1003a4 <readline+0x6d>
  10037c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100383:	7f 1f                	jg     1003a4 <readline+0x6d>
            cputchar(c);
  100385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 1e ff ff ff       	call   1002ae <cputchar>
            buf[i ++] = c;
  100390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100393:	8d 50 01             	lea    0x1(%eax),%edx
  100396:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10039c:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  1003a2:	eb 45                	jmp    1003e9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003a8:	75 16                	jne    1003c0 <readline+0x89>
  1003aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ae:	7e 10                	jle    1003c0 <readline+0x89>
            cputchar(c);
  1003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003b3:	89 04 24             	mov    %eax,(%esp)
  1003b6:	e8 f3 fe ff ff       	call   1002ae <cputchar>
            i --;
  1003bb:	ff 4d f4             	decl   -0xc(%ebp)
  1003be:	eb 29                	jmp    1003e9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003c0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003c4:	74 06                	je     1003cc <readline+0x95>
  1003c6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003ca:	75 95                	jne    100361 <readline+0x2a>
            cputchar(c);
  1003cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003cf:	89 04 24             	mov    %eax,(%esp)
  1003d2:	e8 d7 fe ff ff       	call   1002ae <cputchar>
            buf[i] = '\0';
  1003d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003da:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003e2:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003e7:	eb 05                	jmp    1003ee <readline+0xb7>
        c = getchar();
  1003e9:	e9 73 ff ff ff       	jmp    100361 <readline+0x2a>
        }
    }
}
  1003ee:	c9                   	leave  
  1003ef:	c3                   	ret    

001003f0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f0:	f3 0f 1e fb          	endbr32 
  1003f4:	55                   	push   %ebp
  1003f5:	89 e5                	mov    %esp,%ebp
  1003f7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003fa:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  1003ff:	85 c0                	test   %eax,%eax
  100401:	75 5b                	jne    10045e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100403:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  10040a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10040d:	8d 45 14             	lea    0x14(%ebp),%eax
  100410:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100413:	8b 45 0c             	mov    0xc(%ebp),%eax
  100416:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041a:	8b 45 08             	mov    0x8(%ebp),%eax
  10041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100421:	c7 04 24 ca 34 10 00 	movl   $0x1034ca,(%esp)
  100428:	e8 57 fe ff ff       	call   100284 <cprintf>
    vcprintf(fmt, ap);
  10042d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100430:	89 44 24 04          	mov    %eax,0x4(%esp)
  100434:	8b 45 10             	mov    0x10(%ebp),%eax
  100437:	89 04 24             	mov    %eax,(%esp)
  10043a:	e8 0e fe ff ff       	call   10024d <vcprintf>
    cprintf("\n");
  10043f:	c7 04 24 e6 34 10 00 	movl   $0x1034e6,(%esp)
  100446:	e8 39 fe ff ff       	call   100284 <cprintf>
    
    cprintf("stack trackback:\n");
  10044b:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  100452:	e8 2d fe ff ff       	call   100284 <cprintf>
    print_stackframe();
  100457:	e8 3d 06 00 00       	call   100a99 <print_stackframe>
  10045c:	eb 01                	jmp    10045f <__panic+0x6f>
        goto panic_dead;
  10045e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10045f:	e8 82 14 00 00       	call   1018e6 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10046b:	e8 5f 08 00 00       	call   100ccf <kmonitor>
  100470:	eb f2                	jmp    100464 <__panic+0x74>

00100472 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100472:	f3 0f 1e fb          	endbr32 
  100476:	55                   	push   %ebp
  100477:	89 e5                	mov    %esp,%ebp
  100479:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10047c:	8d 45 14             	lea    0x14(%ebp),%eax
  10047f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100482:	8b 45 0c             	mov    0xc(%ebp),%eax
  100485:	89 44 24 08          	mov    %eax,0x8(%esp)
  100489:	8b 45 08             	mov    0x8(%ebp),%eax
  10048c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100490:	c7 04 24 fa 34 10 00 	movl   $0x1034fa,(%esp)
  100497:	e8 e8 fd ff ff       	call   100284 <cprintf>
    vcprintf(fmt, ap);
  10049c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10049f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a6:	89 04 24             	mov    %eax,(%esp)
  1004a9:	e8 9f fd ff ff       	call   10024d <vcprintf>
    cprintf("\n");
  1004ae:	c7 04 24 e6 34 10 00 	movl   $0x1034e6,(%esp)
  1004b5:	e8 ca fd ff ff       	call   100284 <cprintf>
    va_end(ap);
}
  1004ba:	90                   	nop
  1004bb:	c9                   	leave  
  1004bc:	c3                   	ret    

001004bd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004bd:	f3 0f 1e fb          	endbr32 
  1004c1:	55                   	push   %ebp
  1004c2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004c4:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  1004c9:	5d                   	pop    %ebp
  1004ca:	c3                   	ret    

001004cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004cb:	f3 0f 1e fb          	endbr32 
  1004cf:	55                   	push   %ebp
  1004d0:	89 e5                	mov    %esp,%ebp
  1004d2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d8:	8b 00                	mov    (%eax),%eax
  1004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e0:	8b 00                	mov    (%eax),%eax
  1004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004ec:	e9 ca 00 00 00       	jmp    1005bb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  1004f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	89 c2                	mov    %eax,%edx
  1004fb:	c1 ea 1f             	shr    $0x1f,%edx
  1004fe:	01 d0                	add    %edx,%eax
  100500:	d1 f8                	sar    %eax
  100502:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100508:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10050b:	eb 03                	jmp    100510 <stab_binsearch+0x45>
            m --;
  10050d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100516:	7c 1f                	jl     100537 <stab_binsearch+0x6c>
  100518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051b:	89 d0                	mov    %edx,%eax
  10051d:	01 c0                	add    %eax,%eax
  10051f:	01 d0                	add    %edx,%eax
  100521:	c1 e0 02             	shl    $0x2,%eax
  100524:	89 c2                	mov    %eax,%edx
  100526:	8b 45 08             	mov    0x8(%ebp),%eax
  100529:	01 d0                	add    %edx,%eax
  10052b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052f:	0f b6 c0             	movzbl %al,%eax
  100532:	39 45 14             	cmp    %eax,0x14(%ebp)
  100535:	75 d6                	jne    10050d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10053d:	7d 09                	jge    100548 <stab_binsearch+0x7d>
            l = true_m + 1;
  10053f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100542:	40                   	inc    %eax
  100543:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100546:	eb 73                	jmp    1005bb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100548:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100552:	89 d0                	mov    %edx,%eax
  100554:	01 c0                	add    %eax,%eax
  100556:	01 d0                	add    %edx,%eax
  100558:	c1 e0 02             	shl    $0x2,%eax
  10055b:	89 c2                	mov    %eax,%edx
  10055d:	8b 45 08             	mov    0x8(%ebp),%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	8b 40 08             	mov    0x8(%eax),%eax
  100565:	39 45 18             	cmp    %eax,0x18(%ebp)
  100568:	76 11                	jbe    10057b <stab_binsearch+0xb0>
            *region_left = m;
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100570:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100575:	40                   	inc    %eax
  100576:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100579:	eb 40                	jmp    1005bb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10057b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057e:	89 d0                	mov    %edx,%eax
  100580:	01 c0                	add    %eax,%eax
  100582:	01 d0                	add    %edx,%eax
  100584:	c1 e0 02             	shl    $0x2,%eax
  100587:	89 c2                	mov    %eax,%edx
  100589:	8b 45 08             	mov    0x8(%ebp),%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	8b 40 08             	mov    0x8(%eax),%eax
  100591:	39 45 18             	cmp    %eax,0x18(%ebp)
  100594:	73 14                	jae    1005aa <stab_binsearch+0xdf>
            *region_right = m - 1;
  100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100599:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059c:	8b 45 10             	mov    0x10(%ebp),%eax
  10059f:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a4:	48                   	dec    %eax
  1005a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005a8:	eb 11                	jmp    1005bb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005b8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005c1:	0f 8e 2a ff ff ff    	jle    1004f1 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005cb:	75 0f                	jne    1005dc <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d0:	8b 00                	mov    (%eax),%eax
  1005d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005da:	eb 3e                	jmp    10061a <stab_binsearch+0x14f>
        l = *region_right;
  1005dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1005df:	8b 00                	mov    (%eax),%eax
  1005e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005e4:	eb 03                	jmp    1005e9 <stab_binsearch+0x11e>
  1005e6:	ff 4d fc             	decl   -0x4(%ebp)
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	8b 00                	mov    (%eax),%eax
  1005ee:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005f1:	7e 1f                	jle    100612 <stab_binsearch+0x147>
  1005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f6:	89 d0                	mov    %edx,%eax
  1005f8:	01 c0                	add    %eax,%eax
  1005fa:	01 d0                	add    %edx,%eax
  1005fc:	c1 e0 02             	shl    $0x2,%eax
  1005ff:	89 c2                	mov    %eax,%edx
  100601:	8b 45 08             	mov    0x8(%ebp),%eax
  100604:	01 d0                	add    %edx,%eax
  100606:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10060a:	0f b6 c0             	movzbl %al,%eax
  10060d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100610:	75 d4                	jne    1005e6 <stab_binsearch+0x11b>
        *region_left = l;
  100612:	8b 45 0c             	mov    0xc(%ebp),%eax
  100615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100618:	89 10                	mov    %edx,(%eax)
}
  10061a:	90                   	nop
  10061b:	c9                   	leave  
  10061c:	c3                   	ret    

0010061d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10061d:	f3 0f 1e fb          	endbr32 
  100621:	55                   	push   %ebp
  100622:	89 e5                	mov    %esp,%ebp
  100624:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100627:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062a:	c7 00 18 35 10 00    	movl   $0x103518,(%eax)
    info->eip_line = 0;
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063d:	c7 40 08 18 35 10 00 	movl   $0x103518,0x8(%eax)
    info->eip_fn_namelen = 9;
  100644:	8b 45 0c             	mov    0xc(%ebp),%eax
  100647:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100651:	8b 55 08             	mov    0x8(%ebp),%edx
  100654:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100661:	c7 45 f4 2c 3d 10 00 	movl   $0x103d2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100668:	c7 45 f0 e8 c8 10 00 	movl   $0x10c8e8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10066f:	c7 45 ec e9 c8 10 00 	movl   $0x10c8e9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100676:	c7 45 e8 dd e9 10 00 	movl   $0x10e9dd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100680:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100683:	76 0b                	jbe    100690 <debuginfo_eip+0x73>
  100685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100688:	48                   	dec    %eax
  100689:	0f b6 00             	movzbl (%eax),%eax
  10068c:	84 c0                	test   %al,%al
  10068e:	74 0a                	je     10069a <debuginfo_eip+0x7d>
        return -1;
  100690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100695:	e9 ab 02 00 00       	jmp    100945 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10069a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006a7:	c1 f8 02             	sar    $0x2,%eax
  1006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006b0:	48                   	dec    %eax
  1006b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006c2:	00 
  1006c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d4:	89 04 24             	mov    %eax,(%esp)
  1006d7:	e8 ef fd ff ff       	call   1004cb <stab_binsearch>
    if (lfile == 0)
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	85 c0                	test   %eax,%eax
  1006e1:	75 0a                	jne    1006ed <debuginfo_eip+0xd0>
        return -1;
  1006e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006e8:	e9 58 02 00 00       	jmp    100945 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100700:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100707:	00 
  100708:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10070b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100712:	89 44 24 04          	mov    %eax,0x4(%esp)
  100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100719:	89 04 24             	mov    %eax,(%esp)
  10071c:	e8 aa fd ff ff       	call   1004cb <stab_binsearch>

    if (lfun <= rfun) {
  100721:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100724:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100727:	39 c2                	cmp    %eax,%edx
  100729:	7f 78                	jg     1007a3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072e:	89 c2                	mov    %eax,%edx
  100730:	89 d0                	mov    %edx,%eax
  100732:	01 c0                	add    %eax,%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	c1 e0 02             	shl    $0x2,%eax
  100739:	89 c2                	mov    %eax,%edx
  10073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	8b 10                	mov    (%eax),%edx
  100742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100745:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100748:	39 c2                	cmp    %eax,%edx
  10074a:	73 22                	jae    10076e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10074c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074f:	89 c2                	mov    %eax,%edx
  100751:	89 d0                	mov    %edx,%eax
  100753:	01 c0                	add    %eax,%eax
  100755:	01 d0                	add    %edx,%eax
  100757:	c1 e0 02             	shl    $0x2,%eax
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075f:	01 d0                	add    %edx,%eax
  100761:	8b 10                	mov    (%eax),%edx
  100763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100766:	01 c2                	add    %eax,%edx
  100768:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10076e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100771:	89 c2                	mov    %eax,%edx
  100773:	89 d0                	mov    %edx,%eax
  100775:	01 c0                	add    %eax,%eax
  100777:	01 d0                	add    %edx,%eax
  100779:	c1 e0 02             	shl    $0x2,%eax
  10077c:	89 c2                	mov    %eax,%edx
  10077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100781:	01 d0                	add    %edx,%eax
  100783:	8b 50 08             	mov    0x8(%eax),%edx
  100786:	8b 45 0c             	mov    0xc(%ebp),%eax
  100789:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078f:	8b 40 10             	mov    0x10(%eax),%eax
  100792:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100795:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100798:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10079b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10079e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007a1:	eb 15                	jmp    1007b8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007a9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bb:	8b 40 08             	mov    0x8(%eax),%eax
  1007be:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007c5:	00 
  1007c6:	89 04 24             	mov    %eax,(%esp)
  1007c9:	e8 a1 22 00 00       	call   102a6f <strfind>
  1007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007d1:	8b 52 08             	mov    0x8(%edx),%edx
  1007d4:	29 d0                	sub    %edx,%eax
  1007d6:	89 c2                	mov    %eax,%edx
  1007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007db:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007de:	8b 45 08             	mov    0x8(%ebp),%eax
  1007e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007e5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ec:	00 
  1007ed:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007f4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fe:	89 04 24             	mov    %eax,(%esp)
  100801:	e8 c5 fc ff ff       	call   1004cb <stab_binsearch>
    if (lline <= rline) {
  100806:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100809:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10080c:	39 c2                	cmp    %eax,%edx
  10080e:	7f 23                	jg     100833 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100810:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100831:	eb 11                	jmp    100844 <debuginfo_eip+0x227>
        return -1;
  100833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100838:	e9 08 01 00 00       	jmp    100945 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10083d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100840:	48                   	dec    %eax
  100841:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100844:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084a:	39 c2                	cmp    %eax,%edx
  10084c:	7c 56                	jl     1008a4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10084e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100851:	89 c2                	mov    %eax,%edx
  100853:	89 d0                	mov    %edx,%eax
  100855:	01 c0                	add    %eax,%eax
  100857:	01 d0                	add    %edx,%eax
  100859:	c1 e0 02             	shl    $0x2,%eax
  10085c:	89 c2                	mov    %eax,%edx
  10085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100867:	3c 84                	cmp    $0x84,%al
  100869:	74 39                	je     1008a4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10086b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086e:	89 c2                	mov    %eax,%edx
  100870:	89 d0                	mov    %edx,%eax
  100872:	01 c0                	add    %eax,%eax
  100874:	01 d0                	add    %edx,%eax
  100876:	c1 e0 02             	shl    $0x2,%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100884:	3c 64                	cmp    $0x64,%al
  100886:	75 b5                	jne    10083d <debuginfo_eip+0x220>
  100888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088b:	89 c2                	mov    %eax,%edx
  10088d:	89 d0                	mov    %edx,%eax
  10088f:	01 c0                	add    %eax,%eax
  100891:	01 d0                	add    %edx,%eax
  100893:	c1 e0 02             	shl    $0x2,%eax
  100896:	89 c2                	mov    %eax,%edx
  100898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089b:	01 d0                	add    %edx,%eax
  10089d:	8b 40 08             	mov    0x8(%eax),%eax
  1008a0:	85 c0                	test   %eax,%eax
  1008a2:	74 99                	je     10083d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008aa:	39 c2                	cmp    %eax,%edx
  1008ac:	7c 42                	jl     1008f0 <debuginfo_eip+0x2d3>
  1008ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	89 d0                	mov    %edx,%eax
  1008b5:	01 c0                	add    %eax,%eax
  1008b7:	01 d0                	add    %edx,%eax
  1008b9:	c1 e0 02             	shl    $0x2,%eax
  1008bc:	89 c2                	mov    %eax,%edx
  1008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c1:	01 d0                	add    %edx,%eax
  1008c3:	8b 10                	mov    (%eax),%edx
  1008c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008cb:	39 c2                	cmp    %eax,%edx
  1008cd:	73 21                	jae    1008f0 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d2:	89 c2                	mov    %eax,%edx
  1008d4:	89 d0                	mov    %edx,%eax
  1008d6:	01 c0                	add    %eax,%eax
  1008d8:	01 d0                	add    %edx,%eax
  1008da:	c1 e0 02             	shl    $0x2,%eax
  1008dd:	89 c2                	mov    %eax,%edx
  1008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e2:	01 d0                	add    %edx,%eax
  1008e4:	8b 10                	mov    (%eax),%edx
  1008e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008e9:	01 c2                	add    %eax,%edx
  1008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ee:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008f6:	39 c2                	cmp    %eax,%edx
  1008f8:	7d 46                	jge    100940 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  1008fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008fd:	40                   	inc    %eax
  1008fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100901:	eb 16                	jmp    100919 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100903:	8b 45 0c             	mov    0xc(%ebp),%eax
  100906:	8b 40 14             	mov    0x14(%eax),%eax
  100909:	8d 50 01             	lea    0x1(%eax),%edx
  10090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10090f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100912:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100915:	40                   	inc    %eax
  100916:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100919:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10091c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10091f:	39 c2                	cmp    %eax,%edx
  100921:	7d 1d                	jge    100940 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100923:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100926:	89 c2                	mov    %eax,%edx
  100928:	89 d0                	mov    %edx,%eax
  10092a:	01 c0                	add    %eax,%eax
  10092c:	01 d0                	add    %edx,%eax
  10092e:	c1 e0 02             	shl    $0x2,%eax
  100931:	89 c2                	mov    %eax,%edx
  100933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100936:	01 d0                	add    %edx,%eax
  100938:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10093c:	3c a0                	cmp    $0xa0,%al
  10093e:	74 c3                	je     100903 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100945:	c9                   	leave  
  100946:	c3                   	ret    

00100947 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100947:	f3 0f 1e fb          	endbr32 
  10094b:	55                   	push   %ebp
  10094c:	89 e5                	mov    %esp,%ebp
  10094e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100951:	c7 04 24 22 35 10 00 	movl   $0x103522,(%esp)
  100958:	e8 27 f9 ff ff       	call   100284 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 3b 35 10 00 	movl   $0x10353b,(%esp)
  10096c:	e8 13 f9 ff ff       	call   100284 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100971:	c7 44 24 04 1f 34 10 	movl   $0x10341f,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 53 35 10 00 	movl   $0x103553,(%esp)
  100980:	e8 ff f8 ff ff       	call   100284 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100985:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  10098c:	00 
  10098d:	c7 04 24 6b 35 10 00 	movl   $0x10356b,(%esp)
  100994:	e8 eb f8 ff ff       	call   100284 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100999:	c7 44 24 04 20 0d 11 	movl   $0x110d20,0x4(%esp)
  1009a0:	00 
  1009a1:	c7 04 24 83 35 10 00 	movl   $0x103583,(%esp)
  1009a8:	e8 d7 f8 ff ff       	call   100284 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ad:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  1009b2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009b7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c2:	85 c0                	test   %eax,%eax
  1009c4:	0f 48 c2             	cmovs  %edx,%eax
  1009c7:	c1 f8 0a             	sar    $0xa,%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	c7 04 24 9c 35 10 00 	movl   $0x10359c,(%esp)
  1009d5:	e8 aa f8 ff ff       	call   100284 <cprintf>
}
  1009da:	90                   	nop
  1009db:	c9                   	leave  
  1009dc:	c3                   	ret    

001009dd <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009dd:	f3 0f 1e fb          	endbr32 
  1009e1:	55                   	push   %ebp
  1009e2:	89 e5                	mov    %esp,%ebp
  1009e4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f4:	89 04 24             	mov    %eax,(%esp)
  1009f7:	e8 21 fc ff ff       	call   10061d <debuginfo_eip>
  1009fc:	85 c0                	test   %eax,%eax
  1009fe:	74 15                	je     100a15 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a00:	8b 45 08             	mov    0x8(%ebp),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 c6 35 10 00 	movl   $0x1035c6,(%esp)
  100a0e:	e8 71 f8 ff ff       	call   100284 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a13:	eb 6c                	jmp    100a81 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a1c:	eb 1b                	jmp    100a39 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a24:	01 d0                	add    %edx,%eax
  100a26:	0f b6 10             	movzbl (%eax),%edx
  100a29:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a32:	01 c8                	add    %ecx,%eax
  100a34:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a36:	ff 45 f4             	incl   -0xc(%ebp)
  100a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a3f:	7c dd                	jl     100a1e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a41:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4a:	01 d0                	add    %edx,%eax
  100a4c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a52:	8b 55 08             	mov    0x8(%ebp),%edx
  100a55:	89 d1                	mov    %edx,%ecx
  100a57:	29 c1                	sub    %eax,%ecx
  100a59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a5f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a63:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a69:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a6d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a75:	c7 04 24 e2 35 10 00 	movl   $0x1035e2,(%esp)
  100a7c:	e8 03 f8 ff ff       	call   100284 <cprintf>
}
  100a81:	90                   	nop
  100a82:	c9                   	leave  
  100a83:	c3                   	ret    

00100a84 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a84:	f3 0f 1e fb          	endbr32 
  100a88:	55                   	push   %ebp
  100a89:	89 e5                	mov    %esp,%ebp
  100a8b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a8e:	8b 45 04             	mov    0x4(%ebp),%eax
  100a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a97:	c9                   	leave  
  100a98:	c3                   	ret    

00100a99 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a99:	f3 0f 1e fb          	endbr32 
  100a9d:	55                   	push   %ebp
  100a9e:	89 e5                	mov    %esp,%ebp
  100aa0:	53                   	push   %ebx
  100aa1:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100aa4:	89 e8                	mov    %ebp,%eax
  100aa6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t* curr_ebp=read_ebp();
  100aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t* curr_eip=read_eip();
  100aaf:	e8 d0 ff ff ff       	call   100a84 <read_eip>
  100ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (int i = 0 ; i < STACKFRAME_DEPTH ; ++i )
  100ab7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100abe:	e9 86 00 00 00       	jmp    100b49 <print_stackframe+0xb0>
    {
        cprintf("ebp:%08p eip:%08p ",curr_ebp,curr_eip);
  100ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac6:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad1:	c7 04 24 f4 35 10 00 	movl   $0x1035f4,(%esp)
  100ad8:	e8 a7 f7 ff ff       	call   100284 <cprintf>
        //cprintf("%08p %08p",*(curr_ebp),*(curr_ebp+1));
        cprintf("args:%08p %08p %08p %08p",*(curr_ebp+2),*(curr_ebp+3),*(curr_ebp+4),*(curr_ebp+5));
  100add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae0:	83 c0 14             	add    $0x14,%eax
  100ae3:	8b 18                	mov    (%eax),%ebx
  100ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae8:	83 c0 10             	add    $0x10,%eax
  100aeb:	8b 08                	mov    (%eax),%ecx
  100aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af0:	83 c0 0c             	add    $0xc,%eax
  100af3:	8b 10                	mov    (%eax),%edx
  100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af8:	83 c0 08             	add    $0x8,%eax
  100afb:	8b 00                	mov    (%eax),%eax
  100afd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b01:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b05:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0d:	c7 04 24 07 36 10 00 	movl   $0x103607,(%esp)
  100b14:	e8 6b f7 ff ff       	call   100284 <cprintf>
        cprintf("\n");
  100b19:	c7 04 24 20 36 10 00 	movl   $0x103620,(%esp)
  100b20:	e8 5f f7 ff ff       	call   100284 <cprintf>
        print_debuginfo(curr_eip-1);
  100b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b28:	83 e8 04             	sub    $0x4,%eax
  100b2b:	89 04 24             	mov    %eax,(%esp)
  100b2e:	e8 aa fe ff ff       	call   1009dd <print_debuginfo>
        curr_eip=*(curr_ebp+1);
  100b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b36:	83 c0 04             	add    $0x4,%eax
  100b39:	8b 00                	mov    (%eax),%eax
  100b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        curr_ebp=*(curr_ebp);
  100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b41:	8b 00                	mov    (%eax),%eax
  100b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0 ; i < STACKFRAME_DEPTH ; ++i )
  100b46:	ff 45 ec             	incl   -0x14(%ebp)
  100b49:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b4d:	0f 8e 70 ff ff ff    	jle    100ac3 <print_stackframe+0x2a>
    }
}
  100b53:	90                   	nop
  100b54:	90                   	nop
  100b55:	83 c4 34             	add    $0x34,%esp
  100b58:	5b                   	pop    %ebx
  100b59:	5d                   	pop    %ebp
  100b5a:	c3                   	ret    

00100b5b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b5b:	f3 0f 1e fb          	endbr32 
  100b5f:	55                   	push   %ebp
  100b60:	89 e5                	mov    %esp,%ebp
  100b62:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b6c:	eb 0c                	jmp    100b7a <parse+0x1f>
            *buf ++ = '\0';
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	8d 50 01             	lea    0x1(%eax),%edx
  100b74:	89 55 08             	mov    %edx,0x8(%ebp)
  100b77:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7d:	0f b6 00             	movzbl (%eax),%eax
  100b80:	84 c0                	test   %al,%al
  100b82:	74 1d                	je     100ba1 <parse+0x46>
  100b84:	8b 45 08             	mov    0x8(%ebp),%eax
  100b87:	0f b6 00             	movzbl (%eax),%eax
  100b8a:	0f be c0             	movsbl %al,%eax
  100b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b91:	c7 04 24 a4 36 10 00 	movl   $0x1036a4,(%esp)
  100b98:	e8 9c 1e 00 00       	call   102a39 <strchr>
  100b9d:	85 c0                	test   %eax,%eax
  100b9f:	75 cd                	jne    100b6e <parse+0x13>
        }
        if (*buf == '\0') {
  100ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba4:	0f b6 00             	movzbl (%eax),%eax
  100ba7:	84 c0                	test   %al,%al
  100ba9:	74 65                	je     100c10 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bab:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100baf:	75 14                	jne    100bc5 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bb1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bb8:	00 
  100bb9:	c7 04 24 a9 36 10 00 	movl   $0x1036a9,(%esp)
  100bc0:	e8 bf f6 ff ff       	call   100284 <cprintf>
        }
        argv[argc ++] = buf;
  100bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc8:	8d 50 01             	lea    0x1(%eax),%edx
  100bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bd8:	01 c2                	add    %eax,%edx
  100bda:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bdf:	eb 03                	jmp    100be4 <parse+0x89>
            buf ++;
  100be1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100be4:	8b 45 08             	mov    0x8(%ebp),%eax
  100be7:	0f b6 00             	movzbl (%eax),%eax
  100bea:	84 c0                	test   %al,%al
  100bec:	74 8c                	je     100b7a <parse+0x1f>
  100bee:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf1:	0f b6 00             	movzbl (%eax),%eax
  100bf4:	0f be c0             	movsbl %al,%eax
  100bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bfb:	c7 04 24 a4 36 10 00 	movl   $0x1036a4,(%esp)
  100c02:	e8 32 1e 00 00       	call   102a39 <strchr>
  100c07:	85 c0                	test   %eax,%eax
  100c09:	74 d6                	je     100be1 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c0b:	e9 6a ff ff ff       	jmp    100b7a <parse+0x1f>
            break;
  100c10:	90                   	nop
        }
    }
    return argc;
  100c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c14:	c9                   	leave  
  100c15:	c3                   	ret    

00100c16 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c16:	f3 0f 1e fb          	endbr32 
  100c1a:	55                   	push   %ebp
  100c1b:	89 e5                	mov    %esp,%ebp
  100c1d:	53                   	push   %ebx
  100c1e:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c21:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c28:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2b:	89 04 24             	mov    %eax,(%esp)
  100c2e:	e8 28 ff ff ff       	call   100b5b <parse>
  100c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c3a:	75 0a                	jne    100c46 <runcmd+0x30>
        return 0;
  100c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  100c41:	e9 83 00 00 00       	jmp    100cc9 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c4d:	eb 5a                	jmp    100ca9 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c4f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c55:	89 d0                	mov    %edx,%eax
  100c57:	01 c0                	add    %eax,%eax
  100c59:	01 d0                	add    %edx,%eax
  100c5b:	c1 e0 02             	shl    $0x2,%eax
  100c5e:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c63:	8b 00                	mov    (%eax),%eax
  100c65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c69:	89 04 24             	mov    %eax,(%esp)
  100c6c:	e8 24 1d 00 00       	call   102995 <strcmp>
  100c71:	85 c0                	test   %eax,%eax
  100c73:	75 31                	jne    100ca6 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c78:	89 d0                	mov    %edx,%eax
  100c7a:	01 c0                	add    %eax,%eax
  100c7c:	01 d0                	add    %edx,%eax
  100c7e:	c1 e0 02             	shl    $0x2,%eax
  100c81:	05 08 f0 10 00       	add    $0x10f008,%eax
  100c86:	8b 10                	mov    (%eax),%edx
  100c88:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c8b:	83 c0 04             	add    $0x4,%eax
  100c8e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c91:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9f:	89 1c 24             	mov    %ebx,(%esp)
  100ca2:	ff d2                	call   *%edx
  100ca4:	eb 23                	jmp    100cc9 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca6:	ff 45 f4             	incl   -0xc(%ebp)
  100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cac:	83 f8 02             	cmp    $0x2,%eax
  100caf:	76 9e                	jbe    100c4f <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cb1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb8:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  100cbf:	e8 c0 f5 ff ff       	call   100284 <cprintf>
    return 0;
  100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc9:	83 c4 64             	add    $0x64,%esp
  100ccc:	5b                   	pop    %ebx
  100ccd:	5d                   	pop    %ebp
  100cce:	c3                   	ret    

00100ccf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ccf:	f3 0f 1e fb          	endbr32 
  100cd3:	55                   	push   %ebp
  100cd4:	89 e5                	mov    %esp,%ebp
  100cd6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cd9:	c7 04 24 e0 36 10 00 	movl   $0x1036e0,(%esp)
  100ce0:	e8 9f f5 ff ff       	call   100284 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ce5:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  100cec:	e8 93 f5 ff ff       	call   100284 <cprintf>

    if (tf != NULL) {
  100cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cf5:	74 0b                	je     100d02 <kmonitor+0x33>
        print_trapframe(tf);
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 04 24             	mov    %eax,(%esp)
  100cfd:	e8 69 0c 00 00       	call   10196b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d02:	c7 04 24 2d 37 10 00 	movl   $0x10372d,(%esp)
  100d09:	e8 29 f6 ff ff       	call   100337 <readline>
  100d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d15:	74 eb                	je     100d02 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d17:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d21:	89 04 24             	mov    %eax,(%esp)
  100d24:	e8 ed fe ff ff       	call   100c16 <runcmd>
  100d29:	85 c0                	test   %eax,%eax
  100d2b:	78 02                	js     100d2f <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d2d:	eb d3                	jmp    100d02 <kmonitor+0x33>
                break;
  100d2f:	90                   	nop
            }
        }
    }
}
  100d30:	90                   	nop
  100d31:	c9                   	leave  
  100d32:	c3                   	ret    

00100d33 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d33:	f3 0f 1e fb          	endbr32 
  100d37:	55                   	push   %ebp
  100d38:	89 e5                	mov    %esp,%ebp
  100d3a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d44:	eb 3d                	jmp    100d83 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d49:	89 d0                	mov    %edx,%eax
  100d4b:	01 c0                	add    %eax,%eax
  100d4d:	01 d0                	add    %edx,%eax
  100d4f:	c1 e0 02             	shl    $0x2,%eax
  100d52:	05 04 f0 10 00       	add    $0x10f004,%eax
  100d57:	8b 08                	mov    (%eax),%ecx
  100d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d5c:	89 d0                	mov    %edx,%eax
  100d5e:	01 c0                	add    %eax,%eax
  100d60:	01 d0                	add    %edx,%eax
  100d62:	c1 e0 02             	shl    $0x2,%eax
  100d65:	05 00 f0 10 00       	add    $0x10f000,%eax
  100d6a:	8b 00                	mov    (%eax),%eax
  100d6c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d74:	c7 04 24 31 37 10 00 	movl   $0x103731,(%esp)
  100d7b:	e8 04 f5 ff ff       	call   100284 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d80:	ff 45 f4             	incl   -0xc(%ebp)
  100d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d86:	83 f8 02             	cmp    $0x2,%eax
  100d89:	76 bb                	jbe    100d46 <mon_help+0x13>
    }
    return 0;
  100d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d90:	c9                   	leave  
  100d91:	c3                   	ret    

00100d92 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d92:	f3 0f 1e fb          	endbr32 
  100d96:	55                   	push   %ebp
  100d97:	89 e5                	mov    %esp,%ebp
  100d99:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d9c:	e8 a6 fb ff ff       	call   100947 <print_kerninfo>
    return 0;
  100da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da6:	c9                   	leave  
  100da7:	c3                   	ret    

00100da8 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100da8:	f3 0f 1e fb          	endbr32 
  100dac:	55                   	push   %ebp
  100dad:	89 e5                	mov    %esp,%ebp
  100daf:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100db2:	e8 e2 fc ff ff       	call   100a99 <print_stackframe>
    return 0;
  100db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dbc:	c9                   	leave  
  100dbd:	c3                   	ret    

00100dbe <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dbe:	f3 0f 1e fb          	endbr32 
  100dc2:	55                   	push   %ebp
  100dc3:	89 e5                	mov    %esp,%ebp
  100dc5:	83 ec 28             	sub    $0x28,%esp
  100dc8:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dce:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dd2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dda:	ee                   	out    %al,(%dx)
}
  100ddb:	90                   	nop
  100ddc:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100de2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dee:	ee                   	out    %al,(%dx)
}
  100def:	90                   	nop
  100df0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100df6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dfa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dfe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e02:	ee                   	out    %al,(%dx)
}
  100e03:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e04:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100e0b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e0e:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100e15:	e8 6a f4 ff ff       	call   100284 <cprintf>
    pic_enable(IRQ_TIMER);
  100e1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e21:	e8 31 09 00 00       	call   101757 <pic_enable>
}
  100e26:	90                   	nop
  100e27:	c9                   	leave  
  100e28:	c3                   	ret    

00100e29 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e29:	f3 0f 1e fb          	endbr32 
  100e2d:	55                   	push   %ebp
  100e2e:	89 e5                	mov    %esp,%ebp
  100e30:	83 ec 10             	sub    $0x10,%esp
  100e33:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e39:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e3d:	89 c2                	mov    %eax,%edx
  100e3f:	ec                   	in     (%dx),%al
  100e40:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e43:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e49:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e53:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e59:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e63:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e69:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e73:	90                   	nop
  100e74:	c9                   	leave  
  100e75:	c3                   	ret    

00100e76 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e76:	f3 0f 1e fb          	endbr32 
  100e7a:	55                   	push   %ebp
  100e7b:	89 e5                	mov    %esp,%ebp
  100e7d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e80:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8a:	0f b7 00             	movzwl (%eax),%eax
  100e8d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e94:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9c:	0f b7 00             	movzwl (%eax),%eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ea7:	74 12                	je     100ebb <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ea9:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100eb0:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100eb7:	b4 03 
  100eb9:	eb 13                	jmp    100ece <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec2:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ec5:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100ecc:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ece:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ed9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100edd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ee5:	ee                   	out    %al,(%dx)
}
  100ee6:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ee7:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eee:	40                   	inc    %eax
  100eef:	0f b7 c0             	movzwl %ax,%eax
  100ef2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100efa:	89 c2                	mov    %eax,%edx
  100efc:	ec                   	in     (%dx),%al
  100efd:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f00:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f04:	0f b6 c0             	movzbl %al,%eax
  100f07:	c1 e0 08             	shl    $0x8,%eax
  100f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f0d:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f14:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f18:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f1c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f20:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f24:	ee                   	out    %al,(%dx)
}
  100f25:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f26:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f2d:	40                   	inc    %eax
  100f2e:	0f b7 c0             	movzwl %ax,%eax
  100f31:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f35:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f39:	89 c2                	mov    %eax,%edx
  100f3b:	ec                   	in     (%dx),%al
  100f3c:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f3f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f43:	0f b6 c0             	movzbl %al,%eax
  100f46:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f4c:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f54:	0f b7 c0             	movzwl %ax,%eax
  100f57:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f5d:	90                   	nop
  100f5e:	c9                   	leave  
  100f5f:	c3                   	ret    

00100f60 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f60:	f3 0f 1e fb          	endbr32 
  100f64:	55                   	push   %ebp
  100f65:	89 e5                	mov    %esp,%ebp
  100f67:	83 ec 48             	sub    $0x48,%esp
  100f6a:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f70:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f74:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f78:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
}
  100f7d:	90                   	nop
  100f7e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f84:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f88:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f8c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f90:	ee                   	out    %al,(%dx)
}
  100f91:	90                   	nop
  100f92:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f98:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f9c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fa0:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fa4:	ee                   	out    %al,(%dx)
}
  100fa5:	90                   	nop
  100fa6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fac:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fb8:	ee                   	out    %al,(%dx)
}
  100fb9:	90                   	nop
  100fba:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fc0:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
}
  100fcd:	90                   	nop
  100fce:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fd4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fe0:	ee                   	out    %al,(%dx)
}
  100fe1:	90                   	nop
  100fe2:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fe8:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fec:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ff0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ff4:	ee                   	out    %al,(%dx)
}
  100ff5:	90                   	nop
  100ff6:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ffc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101000:	89 c2                	mov    %eax,%edx
  101002:	ec                   	in     (%dx),%al
  101003:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101006:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10100a:	3c ff                	cmp    $0xff,%al
  10100c:	0f 95 c0             	setne  %al
  10100f:	0f b6 c0             	movzbl %al,%eax
  101012:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  101017:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10101d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101021:	89 c2                	mov    %eax,%edx
  101023:	ec                   	in     (%dx),%al
  101024:	88 45 f1             	mov    %al,-0xf(%ebp)
  101027:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10102d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101031:	89 c2                	mov    %eax,%edx
  101033:	ec                   	in     (%dx),%al
  101034:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101037:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10103c:	85 c0                	test   %eax,%eax
  10103e:	74 0c                	je     10104c <serial_init+0xec>
        pic_enable(IRQ_COM1);
  101040:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101047:	e8 0b 07 00 00       	call   101757 <pic_enable>
    }
}
  10104c:	90                   	nop
  10104d:	c9                   	leave  
  10104e:	c3                   	ret    

0010104f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10104f:	f3 0f 1e fb          	endbr32 
  101053:	55                   	push   %ebp
  101054:	89 e5                	mov    %esp,%ebp
  101056:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101060:	eb 08                	jmp    10106a <lpt_putc_sub+0x1b>
        delay();
  101062:	e8 c2 fd ff ff       	call   100e29 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101067:	ff 45 fc             	incl   -0x4(%ebp)
  10106a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101070:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101074:	89 c2                	mov    %eax,%edx
  101076:	ec                   	in     (%dx),%al
  101077:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10107a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10107e:	84 c0                	test   %al,%al
  101080:	78 09                	js     10108b <lpt_putc_sub+0x3c>
  101082:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101089:	7e d7                	jle    101062 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  10108b:	8b 45 08             	mov    0x8(%ebp),%eax
  10108e:	0f b6 c0             	movzbl %al,%eax
  101091:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101097:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10109a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10109e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a2:	ee                   	out    %al,(%dx)
}
  1010a3:	90                   	nop
  1010a4:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010aa:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010ae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010b2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010b6:	ee                   	out    %al,(%dx)
}
  1010b7:	90                   	nop
  1010b8:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010be:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010c6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ca:	ee                   	out    %al,(%dx)
}
  1010cb:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010cc:	90                   	nop
  1010cd:	c9                   	leave  
  1010ce:	c3                   	ret    

001010cf <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010cf:	f3 0f 1e fb          	endbr32 
  1010d3:	55                   	push   %ebp
  1010d4:	89 e5                	mov    %esp,%ebp
  1010d6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010d9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010dd:	74 0d                	je     1010ec <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010df:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e2:	89 04 24             	mov    %eax,(%esp)
  1010e5:	e8 65 ff ff ff       	call   10104f <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010ea:	eb 24                	jmp    101110 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f3:	e8 57 ff ff ff       	call   10104f <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ff:	e8 4b ff ff ff       	call   10104f <lpt_putc_sub>
        lpt_putc_sub('\b');
  101104:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110b:	e8 3f ff ff ff       	call   10104f <lpt_putc_sub>
}
  101110:	90                   	nop
  101111:	c9                   	leave  
  101112:	c3                   	ret    

00101113 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101113:	f3 0f 1e fb          	endbr32 
  101117:	55                   	push   %ebp
  101118:	89 e5                	mov    %esp,%ebp
  10111a:	53                   	push   %ebx
  10111b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10111e:	8b 45 08             	mov    0x8(%ebp),%eax
  101121:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101126:	85 c0                	test   %eax,%eax
  101128:	75 07                	jne    101131 <cga_putc+0x1e>
        c |= 0x0700;
  10112a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101131:	8b 45 08             	mov    0x8(%ebp),%eax
  101134:	0f b6 c0             	movzbl %al,%eax
  101137:	83 f8 0d             	cmp    $0xd,%eax
  10113a:	74 72                	je     1011ae <cga_putc+0x9b>
  10113c:	83 f8 0d             	cmp    $0xd,%eax
  10113f:	0f 8f a3 00 00 00    	jg     1011e8 <cga_putc+0xd5>
  101145:	83 f8 08             	cmp    $0x8,%eax
  101148:	74 0a                	je     101154 <cga_putc+0x41>
  10114a:	83 f8 0a             	cmp    $0xa,%eax
  10114d:	74 4c                	je     10119b <cga_putc+0x88>
  10114f:	e9 94 00 00 00       	jmp    1011e8 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101154:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10115b:	85 c0                	test   %eax,%eax
  10115d:	0f 84 af 00 00 00    	je     101212 <cga_putc+0xff>
            crt_pos --;
  101163:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10116a:	48                   	dec    %eax
  10116b:	0f b7 c0             	movzwl %ax,%eax
  10116e:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101174:	8b 45 08             	mov    0x8(%ebp),%eax
  101177:	98                   	cwtl   
  101178:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10117d:	98                   	cwtl   
  10117e:	83 c8 20             	or     $0x20,%eax
  101181:	98                   	cwtl   
  101182:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  101188:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  10118f:	01 c9                	add    %ecx,%ecx
  101191:	01 ca                	add    %ecx,%edx
  101193:	0f b7 c0             	movzwl %ax,%eax
  101196:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101199:	eb 77                	jmp    101212 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10119b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011a2:	83 c0 50             	add    $0x50,%eax
  1011a5:	0f b7 c0             	movzwl %ax,%eax
  1011a8:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011ae:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  1011b5:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  1011bc:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011c1:	89 c8                	mov    %ecx,%eax
  1011c3:	f7 e2                	mul    %edx
  1011c5:	c1 ea 06             	shr    $0x6,%edx
  1011c8:	89 d0                	mov    %edx,%eax
  1011ca:	c1 e0 02             	shl    $0x2,%eax
  1011cd:	01 d0                	add    %edx,%eax
  1011cf:	c1 e0 04             	shl    $0x4,%eax
  1011d2:	29 c1                	sub    %eax,%ecx
  1011d4:	89 c8                	mov    %ecx,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	29 c3                	sub    %eax,%ebx
  1011db:	89 d8                	mov    %ebx,%eax
  1011dd:	0f b7 c0             	movzwl %ax,%eax
  1011e0:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011e6:	eb 2b                	jmp    101213 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011e8:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011ee:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f5:	8d 50 01             	lea    0x1(%eax),%edx
  1011f8:	0f b7 d2             	movzwl %dx,%edx
  1011fb:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  101202:	01 c0                	add    %eax,%eax
  101204:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101207:	8b 45 08             	mov    0x8(%ebp),%eax
  10120a:	0f b7 c0             	movzwl %ax,%eax
  10120d:	66 89 02             	mov    %ax,(%edx)
        break;
  101210:	eb 01                	jmp    101213 <cga_putc+0x100>
        break;
  101212:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101213:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10121a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10121f:	76 5d                	jbe    10127e <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101221:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101226:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10122c:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101231:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101238:	00 
  101239:	89 54 24 04          	mov    %edx,0x4(%esp)
  10123d:	89 04 24             	mov    %eax,(%esp)
  101240:	e8 f9 19 00 00       	call   102c3e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101245:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10124c:	eb 14                	jmp    101262 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10124e:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101256:	01 d2                	add    %edx,%edx
  101258:	01 d0                	add    %edx,%eax
  10125a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10125f:	ff 45 f4             	incl   -0xc(%ebp)
  101262:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101269:	7e e3                	jle    10124e <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  10126b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101272:	83 e8 50             	sub    $0x50,%eax
  101275:	0f b7 c0             	movzwl %ax,%eax
  101278:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10127e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101285:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101289:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10128d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101291:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101295:	ee                   	out    %al,(%dx)
}
  101296:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101297:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10129e:	c1 e8 08             	shr    $0x8,%eax
  1012a1:	0f b7 c0             	movzwl %ax,%eax
  1012a4:	0f b6 c0             	movzbl %al,%eax
  1012a7:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012ae:	42                   	inc    %edx
  1012af:	0f b7 d2             	movzwl %dx,%edx
  1012b2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012b6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012bd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012c1:	ee                   	out    %al,(%dx)
}
  1012c2:	90                   	nop
    outb(addr_6845, 15);
  1012c3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1012ca:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012ce:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012d2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012d6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012da:	ee                   	out    %al,(%dx)
}
  1012db:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012dc:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012e3:	0f b6 c0             	movzbl %al,%eax
  1012e6:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012ed:	42                   	inc    %edx
  1012ee:	0f b7 d2             	movzwl %dx,%edx
  1012f1:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012f5:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012f8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012fc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101300:	ee                   	out    %al,(%dx)
}
  101301:	90                   	nop
}
  101302:	90                   	nop
  101303:	83 c4 34             	add    $0x34,%esp
  101306:	5b                   	pop    %ebx
  101307:	5d                   	pop    %ebp
  101308:	c3                   	ret    

00101309 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101309:	f3 0f 1e fb          	endbr32 
  10130d:	55                   	push   %ebp
  10130e:	89 e5                	mov    %esp,%ebp
  101310:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10131a:	eb 08                	jmp    101324 <serial_putc_sub+0x1b>
        delay();
  10131c:	e8 08 fb ff ff       	call   100e29 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101321:	ff 45 fc             	incl   -0x4(%ebp)
  101324:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10132e:	89 c2                	mov    %eax,%edx
  101330:	ec                   	in     (%dx),%al
  101331:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101334:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101338:	0f b6 c0             	movzbl %al,%eax
  10133b:	83 e0 20             	and    $0x20,%eax
  10133e:	85 c0                	test   %eax,%eax
  101340:	75 09                	jne    10134b <serial_putc_sub+0x42>
  101342:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101349:	7e d1                	jle    10131c <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  10134b:	8b 45 08             	mov    0x8(%ebp),%eax
  10134e:	0f b6 c0             	movzbl %al,%eax
  101351:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101357:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10135a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10135e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101362:	ee                   	out    %al,(%dx)
}
  101363:	90                   	nop
}
  101364:	90                   	nop
  101365:	c9                   	leave  
  101366:	c3                   	ret    

00101367 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101367:	f3 0f 1e fb          	endbr32 
  10136b:	55                   	push   %ebp
  10136c:	89 e5                	mov    %esp,%ebp
  10136e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101371:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101375:	74 0d                	je     101384 <serial_putc+0x1d>
        serial_putc_sub(c);
  101377:	8b 45 08             	mov    0x8(%ebp),%eax
  10137a:	89 04 24             	mov    %eax,(%esp)
  10137d:	e8 87 ff ff ff       	call   101309 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101382:	eb 24                	jmp    1013a8 <serial_putc+0x41>
        serial_putc_sub('\b');
  101384:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10138b:	e8 79 ff ff ff       	call   101309 <serial_putc_sub>
        serial_putc_sub(' ');
  101390:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101397:	e8 6d ff ff ff       	call   101309 <serial_putc_sub>
        serial_putc_sub('\b');
  10139c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013a3:	e8 61 ff ff ff       	call   101309 <serial_putc_sub>
}
  1013a8:	90                   	nop
  1013a9:	c9                   	leave  
  1013aa:	c3                   	ret    

001013ab <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013ab:	f3 0f 1e fb          	endbr32 
  1013af:	55                   	push   %ebp
  1013b0:	89 e5                	mov    %esp,%ebp
  1013b2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013b5:	eb 33                	jmp    1013ea <cons_intr+0x3f>
        if (c != 0) {
  1013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013bb:	74 2d                	je     1013ea <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013bd:	a1 84 00 11 00       	mov    0x110084,%eax
  1013c2:	8d 50 01             	lea    0x1(%eax),%edx
  1013c5:	89 15 84 00 11 00    	mov    %edx,0x110084
  1013cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ce:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013d4:	a1 84 00 11 00       	mov    0x110084,%eax
  1013d9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013de:	75 0a                	jne    1013ea <cons_intr+0x3f>
                cons.wpos = 0;
  1013e0:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013e7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ed:	ff d0                	call   *%eax
  1013ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013f6:	75 bf                	jne    1013b7 <cons_intr+0xc>
            }
        }
    }
}
  1013f8:	90                   	nop
  1013f9:	90                   	nop
  1013fa:	c9                   	leave  
  1013fb:	c3                   	ret    

001013fc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013fc:	f3 0f 1e fb          	endbr32 
  101400:	55                   	push   %ebp
  101401:	89 e5                	mov    %esp,%ebp
  101403:	83 ec 10             	sub    $0x10,%esp
  101406:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10140c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101410:	89 c2                	mov    %eax,%edx
  101412:	ec                   	in     (%dx),%al
  101413:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101416:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10141a:	0f b6 c0             	movzbl %al,%eax
  10141d:	83 e0 01             	and    $0x1,%eax
  101420:	85 c0                	test   %eax,%eax
  101422:	75 07                	jne    10142b <serial_proc_data+0x2f>
        return -1;
  101424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101429:	eb 2a                	jmp    101455 <serial_proc_data+0x59>
  10142b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101431:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101435:	89 c2                	mov    %eax,%edx
  101437:	ec                   	in     (%dx),%al
  101438:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10143b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10143f:	0f b6 c0             	movzbl %al,%eax
  101442:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101445:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101449:	75 07                	jne    101452 <serial_proc_data+0x56>
        c = '\b';
  10144b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101452:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101455:	c9                   	leave  
  101456:	c3                   	ret    

00101457 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101457:	f3 0f 1e fb          	endbr32 
  10145b:	55                   	push   %ebp
  10145c:	89 e5                	mov    %esp,%ebp
  10145e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101461:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101466:	85 c0                	test   %eax,%eax
  101468:	74 0c                	je     101476 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10146a:	c7 04 24 fc 13 10 00 	movl   $0x1013fc,(%esp)
  101471:	e8 35 ff ff ff       	call   1013ab <cons_intr>
    }
}
  101476:	90                   	nop
  101477:	c9                   	leave  
  101478:	c3                   	ret    

00101479 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101479:	f3 0f 1e fb          	endbr32 
  10147d:	55                   	push   %ebp
  10147e:	89 e5                	mov    %esp,%ebp
  101480:	83 ec 38             	sub    $0x38,%esp
  101483:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10148c:	89 c2                	mov    %eax,%edx
  10148e:	ec                   	in     (%dx),%al
  10148f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101492:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101496:	0f b6 c0             	movzbl %al,%eax
  101499:	83 e0 01             	and    $0x1,%eax
  10149c:	85 c0                	test   %eax,%eax
  10149e:	75 0a                	jne    1014aa <kbd_proc_data+0x31>
        return -1;
  1014a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a5:	e9 56 01 00 00       	jmp    101600 <kbd_proc_data+0x187>
  1014aa:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014b3:	89 c2                	mov    %eax,%edx
  1014b5:	ec                   	in     (%dx),%al
  1014b6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014b9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014bd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014c0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014c4:	75 17                	jne    1014dd <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014c6:	a1 88 00 11 00       	mov    0x110088,%eax
  1014cb:	83 c8 40             	or     $0x40,%eax
  1014ce:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d8:	e9 23 01 00 00       	jmp    101600 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e1:	84 c0                	test   %al,%al
  1014e3:	79 45                	jns    10152a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014e5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ea:	83 e0 40             	and    $0x40,%eax
  1014ed:	85 c0                	test   %eax,%eax
  1014ef:	75 08                	jne    1014f9 <kbd_proc_data+0x80>
  1014f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f5:	24 7f                	and    $0x7f,%al
  1014f7:	eb 04                	jmp    1014fd <kbd_proc_data+0x84>
  1014f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fd:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101500:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101504:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10150b:	0c 40                	or     $0x40,%al
  10150d:	0f b6 c0             	movzbl %al,%eax
  101510:	f7 d0                	not    %eax
  101512:	89 c2                	mov    %eax,%edx
  101514:	a1 88 00 11 00       	mov    0x110088,%eax
  101519:	21 d0                	and    %edx,%eax
  10151b:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101520:	b8 00 00 00 00       	mov    $0x0,%eax
  101525:	e9 d6 00 00 00       	jmp    101600 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10152a:	a1 88 00 11 00       	mov    0x110088,%eax
  10152f:	83 e0 40             	and    $0x40,%eax
  101532:	85 c0                	test   %eax,%eax
  101534:	74 11                	je     101547 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101536:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10153a:	a1 88 00 11 00       	mov    0x110088,%eax
  10153f:	83 e0 bf             	and    $0xffffffbf,%eax
  101542:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101547:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10154b:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101552:	0f b6 d0             	movzbl %al,%edx
  101555:	a1 88 00 11 00       	mov    0x110088,%eax
  10155a:	09 d0                	or     %edx,%eax
  10155c:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101565:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  10156c:	0f b6 d0             	movzbl %al,%edx
  10156f:	a1 88 00 11 00       	mov    0x110088,%eax
  101574:	31 d0                	xor    %edx,%eax
  101576:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  10157b:	a1 88 00 11 00       	mov    0x110088,%eax
  101580:	83 e0 03             	and    $0x3,%eax
  101583:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  10158a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158e:	01 d0                	add    %edx,%eax
  101590:	0f b6 00             	movzbl (%eax),%eax
  101593:	0f b6 c0             	movzbl %al,%eax
  101596:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101599:	a1 88 00 11 00       	mov    0x110088,%eax
  10159e:	83 e0 08             	and    $0x8,%eax
  1015a1:	85 c0                	test   %eax,%eax
  1015a3:	74 22                	je     1015c7 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015a5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015a9:	7e 0c                	jle    1015b7 <kbd_proc_data+0x13e>
  1015ab:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015af:	7f 06                	jg     1015b7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015b1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015b5:	eb 10                	jmp    1015c7 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015b7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015bb:	7e 0a                	jle    1015c7 <kbd_proc_data+0x14e>
  1015bd:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015c1:	7f 04                	jg     1015c7 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015c3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015c7:	a1 88 00 11 00       	mov    0x110088,%eax
  1015cc:	f7 d0                	not    %eax
  1015ce:	83 e0 06             	and    $0x6,%eax
  1015d1:	85 c0                	test   %eax,%eax
  1015d3:	75 28                	jne    1015fd <kbd_proc_data+0x184>
  1015d5:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015dc:	75 1f                	jne    1015fd <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015de:	c7 04 24 55 37 10 00 	movl   $0x103755,(%esp)
  1015e5:	e8 9a ec ff ff       	call   100284 <cprintf>
  1015ea:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015f0:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015fb:	ee                   	out    %al,(%dx)
}
  1015fc:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101600:	c9                   	leave  
  101601:	c3                   	ret    

00101602 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101602:	f3 0f 1e fb          	endbr32 
  101606:	55                   	push   %ebp
  101607:	89 e5                	mov    %esp,%ebp
  101609:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10160c:	c7 04 24 79 14 10 00 	movl   $0x101479,(%esp)
  101613:	e8 93 fd ff ff       	call   1013ab <cons_intr>
}
  101618:	90                   	nop
  101619:	c9                   	leave  
  10161a:	c3                   	ret    

0010161b <kbd_init>:

static void
kbd_init(void) {
  10161b:	f3 0f 1e fb          	endbr32 
  10161f:	55                   	push   %ebp
  101620:	89 e5                	mov    %esp,%ebp
  101622:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101625:	e8 d8 ff ff ff       	call   101602 <kbd_intr>
    pic_enable(IRQ_KBD);
  10162a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101631:	e8 21 01 00 00       	call   101757 <pic_enable>
}
  101636:	90                   	nop
  101637:	c9                   	leave  
  101638:	c3                   	ret    

00101639 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101639:	f3 0f 1e fb          	endbr32 
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101643:	e8 2e f8 ff ff       	call   100e76 <cga_init>
    serial_init();
  101648:	e8 13 f9 ff ff       	call   100f60 <serial_init>
    kbd_init();
  10164d:	e8 c9 ff ff ff       	call   10161b <kbd_init>
    if (!serial_exists) {
  101652:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101657:	85 c0                	test   %eax,%eax
  101659:	75 0c                	jne    101667 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10165b:	c7 04 24 61 37 10 00 	movl   $0x103761,(%esp)
  101662:	e8 1d ec ff ff       	call   100284 <cprintf>
    }
}
  101667:	90                   	nop
  101668:	c9                   	leave  
  101669:	c3                   	ret    

0010166a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10166a:	f3 0f 1e fb          	endbr32 
  10166e:	55                   	push   %ebp
  10166f:	89 e5                	mov    %esp,%ebp
  101671:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101674:	8b 45 08             	mov    0x8(%ebp),%eax
  101677:	89 04 24             	mov    %eax,(%esp)
  10167a:	e8 50 fa ff ff       	call   1010cf <lpt_putc>
    cga_putc(c);
  10167f:	8b 45 08             	mov    0x8(%ebp),%eax
  101682:	89 04 24             	mov    %eax,(%esp)
  101685:	e8 89 fa ff ff       	call   101113 <cga_putc>
    serial_putc(c);
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	89 04 24             	mov    %eax,(%esp)
  101690:	e8 d2 fc ff ff       	call   101367 <serial_putc>
}
  101695:	90                   	nop
  101696:	c9                   	leave  
  101697:	c3                   	ret    

00101698 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101698:	f3 0f 1e fb          	endbr32 
  10169c:	55                   	push   %ebp
  10169d:	89 e5                	mov    %esp,%ebp
  10169f:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016a2:	e8 b0 fd ff ff       	call   101457 <serial_intr>
    kbd_intr();
  1016a7:	e8 56 ff ff ff       	call   101602 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016ac:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1016b2:	a1 84 00 11 00       	mov    0x110084,%eax
  1016b7:	39 c2                	cmp    %eax,%edx
  1016b9:	74 36                	je     1016f1 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016bb:	a1 80 00 11 00       	mov    0x110080,%eax
  1016c0:	8d 50 01             	lea    0x1(%eax),%edx
  1016c3:	89 15 80 00 11 00    	mov    %edx,0x110080
  1016c9:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  1016d0:	0f b6 c0             	movzbl %al,%eax
  1016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016d6:	a1 80 00 11 00       	mov    0x110080,%eax
  1016db:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016e0:	75 0a                	jne    1016ec <cons_getc+0x54>
            cons.rpos = 0;
  1016e2:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1016e9:	00 00 00 
        }
        return c;
  1016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ef:	eb 05                	jmp    1016f6 <cons_getc+0x5e>
    }
    return 0;
  1016f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016f6:	c9                   	leave  
  1016f7:	c3                   	ret    

001016f8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016f8:	f3 0f 1e fb          	endbr32 
  1016fc:	55                   	push   %ebp
  1016fd:	89 e5                	mov    %esp,%ebp
  1016ff:	83 ec 14             	sub    $0x14,%esp
  101702:	8b 45 08             	mov    0x8(%ebp),%eax
  101705:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10170c:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101712:	a1 8c 00 11 00       	mov    0x11008c,%eax
  101717:	85 c0                	test   %eax,%eax
  101719:	74 39                	je     101754 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  10171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171e:	0f b6 c0             	movzbl %al,%eax
  101721:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101727:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10172a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10172e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
}
  101733:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101734:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101738:	c1 e8 08             	shr    $0x8,%eax
  10173b:	0f b7 c0             	movzwl %ax,%eax
  10173e:	0f b6 c0             	movzbl %al,%eax
  101741:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101747:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10174a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10174e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101752:	ee                   	out    %al,(%dx)
}
  101753:	90                   	nop
    }
}
  101754:	90                   	nop
  101755:	c9                   	leave  
  101756:	c3                   	ret    

00101757 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101757:	f3 0f 1e fb          	endbr32 
  10175b:	55                   	push   %ebp
  10175c:	89 e5                	mov    %esp,%ebp
  10175e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101761:	8b 45 08             	mov    0x8(%ebp),%eax
  101764:	ba 01 00 00 00       	mov    $0x1,%edx
  101769:	88 c1                	mov    %al,%cl
  10176b:	d3 e2                	shl    %cl,%edx
  10176d:	89 d0                	mov    %edx,%eax
  10176f:	98                   	cwtl   
  101770:	f7 d0                	not    %eax
  101772:	0f bf d0             	movswl %ax,%edx
  101775:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10177c:	98                   	cwtl   
  10177d:	21 d0                	and    %edx,%eax
  10177f:	98                   	cwtl   
  101780:	0f b7 c0             	movzwl %ax,%eax
  101783:	89 04 24             	mov    %eax,(%esp)
  101786:	e8 6d ff ff ff       	call   1016f8 <pic_setmask>
}
  10178b:	90                   	nop
  10178c:	c9                   	leave  
  10178d:	c3                   	ret    

0010178e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10178e:	f3 0f 1e fb          	endbr32 
  101792:	55                   	push   %ebp
  101793:	89 e5                	mov    %esp,%ebp
  101795:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101798:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10179f:	00 00 00 
  1017a2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017a8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ac:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017b0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017b4:	ee                   	out    %al,(%dx)
}
  1017b5:	90                   	nop
  1017b6:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017bc:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
}
  1017c9:	90                   	nop
  1017ca:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017d0:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017d8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
}
  1017dd:	90                   	nop
  1017de:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017e4:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017ec:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
}
  1017f1:	90                   	nop
  1017f2:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017f8:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101800:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101804:	ee                   	out    %al,(%dx)
}
  101805:	90                   	nop
  101806:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10180c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101810:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101814:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
}
  101819:	90                   	nop
  10181a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101820:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101824:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101828:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
}
  10182d:	90                   	nop
  10182e:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101834:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101838:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10183c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
}
  101841:	90                   	nop
  101842:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101848:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101850:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
}
  101855:	90                   	nop
  101856:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10185c:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101860:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101864:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101868:	ee                   	out    %al,(%dx)
}
  101869:	90                   	nop
  10186a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101870:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101874:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101878:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10187c:	ee                   	out    %al,(%dx)
}
  10187d:	90                   	nop
  10187e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101884:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101888:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10188c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101890:	ee                   	out    %al,(%dx)
}
  101891:	90                   	nop
  101892:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101898:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10189c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018a0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018a4:	ee                   	out    %al,(%dx)
}
  1018a5:	90                   	nop
  1018a6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018ac:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018b4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018b8:	ee                   	out    %al,(%dx)
}
  1018b9:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018ba:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018c1:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018c6:	74 0f                	je     1018d7 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018c8:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1018cf:	89 04 24             	mov    %eax,(%esp)
  1018d2:	e8 21 fe ff ff       	call   1016f8 <pic_setmask>
    }
}
  1018d7:	90                   	nop
  1018d8:	c9                   	leave  
  1018d9:	c3                   	ret    

001018da <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018da:	f3 0f 1e fb          	endbr32 
  1018de:	55                   	push   %ebp
  1018df:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018e1:	fb                   	sti    
}
  1018e2:	90                   	nop
    sti();
}
  1018e3:	90                   	nop
  1018e4:	5d                   	pop    %ebp
  1018e5:	c3                   	ret    

001018e6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018e6:	f3 0f 1e fb          	endbr32 
  1018ea:	55                   	push   %ebp
  1018eb:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018ed:	fa                   	cli    
}
  1018ee:	90                   	nop
    cli();
}
  1018ef:	90                   	nop
  1018f0:	5d                   	pop    %ebp
  1018f1:	c3                   	ret    

001018f2 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018f2:	f3 0f 1e fb          	endbr32 
  1018f6:	55                   	push   %ebp
  1018f7:	89 e5                	mov    %esp,%ebp
  1018f9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018fc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101903:	00 
  101904:	c7 04 24 80 37 10 00 	movl   $0x103780,(%esp)
  10190b:	e8 74 e9 ff ff       	call   100284 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101910:	90                   	nop
  101911:	c9                   	leave  
  101912:	c3                   	ret    

00101913 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101913:	f3 0f 1e fb          	endbr32 
  101917:	55                   	push   %ebp
  101918:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  10191a:	90                   	nop
  10191b:	5d                   	pop    %ebp
  10191c:	c3                   	ret    

0010191d <trapname>:

static const char *
trapname(int trapno) {
  10191d:	f3 0f 1e fb          	endbr32 
  101921:	55                   	push   %ebp
  101922:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101924:	8b 45 08             	mov    0x8(%ebp),%eax
  101927:	83 f8 13             	cmp    $0x13,%eax
  10192a:	77 0c                	ja     101938 <trapname+0x1b>
        return excnames[trapno];
  10192c:	8b 45 08             	mov    0x8(%ebp),%eax
  10192f:	8b 04 85 e0 3a 10 00 	mov    0x103ae0(,%eax,4),%eax
  101936:	eb 18                	jmp    101950 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101938:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10193c:	7e 0d                	jle    10194b <trapname+0x2e>
  10193e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101942:	7f 07                	jg     10194b <trapname+0x2e>
        return "Hardware Interrupt";
  101944:	b8 8a 37 10 00       	mov    $0x10378a,%eax
  101949:	eb 05                	jmp    101950 <trapname+0x33>
    }
    return "(unknown trap)";
  10194b:	b8 9d 37 10 00       	mov    $0x10379d,%eax
}
  101950:	5d                   	pop    %ebp
  101951:	c3                   	ret    

00101952 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101952:	f3 0f 1e fb          	endbr32 
  101956:	55                   	push   %ebp
  101957:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101959:	8b 45 08             	mov    0x8(%ebp),%eax
  10195c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101960:	83 f8 08             	cmp    $0x8,%eax
  101963:	0f 94 c0             	sete   %al
  101966:	0f b6 c0             	movzbl %al,%eax
}
  101969:	5d                   	pop    %ebp
  10196a:	c3                   	ret    

0010196b <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10196b:	f3 0f 1e fb          	endbr32 
  10196f:	55                   	push   %ebp
  101970:	89 e5                	mov    %esp,%ebp
  101972:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101975:	8b 45 08             	mov    0x8(%ebp),%eax
  101978:	89 44 24 04          	mov    %eax,0x4(%esp)
  10197c:	c7 04 24 de 37 10 00 	movl   $0x1037de,(%esp)
  101983:	e8 fc e8 ff ff       	call   100284 <cprintf>
    print_regs(&tf->tf_regs);
  101988:	8b 45 08             	mov    0x8(%ebp),%eax
  10198b:	89 04 24             	mov    %eax,(%esp)
  10198e:	e8 8d 01 00 00       	call   101b20 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101993:	8b 45 08             	mov    0x8(%ebp),%eax
  101996:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10199a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10199e:	c7 04 24 ef 37 10 00 	movl   $0x1037ef,(%esp)
  1019a5:	e8 da e8 ff ff       	call   100284 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ad:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b5:	c7 04 24 02 38 10 00 	movl   $0x103802,(%esp)
  1019bc:	e8 c3 e8 ff ff       	call   100284 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019cc:	c7 04 24 15 38 10 00 	movl   $0x103815,(%esp)
  1019d3:	e8 ac e8 ff ff       	call   100284 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019db:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e3:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  1019ea:	e8 95 e8 ff ff       	call   100284 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f2:	8b 40 30             	mov    0x30(%eax),%eax
  1019f5:	89 04 24             	mov    %eax,(%esp)
  1019f8:	e8 20 ff ff ff       	call   10191d <trapname>
  1019fd:	8b 55 08             	mov    0x8(%ebp),%edx
  101a00:	8b 52 30             	mov    0x30(%edx),%edx
  101a03:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a07:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a0b:	c7 04 24 3b 38 10 00 	movl   $0x10383b,(%esp)
  101a12:	e8 6d e8 ff ff       	call   100284 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a17:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1a:	8b 40 34             	mov    0x34(%eax),%eax
  101a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a21:	c7 04 24 4d 38 10 00 	movl   $0x10384d,(%esp)
  101a28:	e8 57 e8 ff ff       	call   100284 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a30:	8b 40 38             	mov    0x38(%eax),%eax
  101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a37:	c7 04 24 5c 38 10 00 	movl   $0x10385c,(%esp)
  101a3e:	e8 41 e8 ff ff       	call   100284 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4e:	c7 04 24 6b 38 10 00 	movl   $0x10386b,(%esp)
  101a55:	e8 2a e8 ff ff       	call   100284 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5d:	8b 40 40             	mov    0x40(%eax),%eax
  101a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a64:	c7 04 24 7e 38 10 00 	movl   $0x10387e,(%esp)
  101a6b:	e8 14 e8 ff ff       	call   100284 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a7e:	eb 3d                	jmp    101abd <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a80:	8b 45 08             	mov    0x8(%ebp),%eax
  101a83:	8b 50 40             	mov    0x40(%eax),%edx
  101a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a89:	21 d0                	and    %edx,%eax
  101a8b:	85 c0                	test   %eax,%eax
  101a8d:	74 28                	je     101ab7 <print_trapframe+0x14c>
  101a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a92:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101a99:	85 c0                	test   %eax,%eax
  101a9b:	74 1a                	je     101ab7 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aa0:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	c7 04 24 8d 38 10 00 	movl   $0x10388d,(%esp)
  101ab2:	e8 cd e7 ff ff       	call   100284 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ab7:	ff 45 f4             	incl   -0xc(%ebp)
  101aba:	d1 65 f0             	shll   -0x10(%ebp)
  101abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ac0:	83 f8 17             	cmp    $0x17,%eax
  101ac3:	76 bb                	jbe    101a80 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 40 40             	mov    0x40(%eax),%eax
  101acb:	c1 e8 0c             	shr    $0xc,%eax
  101ace:	83 e0 03             	and    $0x3,%eax
  101ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad5:	c7 04 24 91 38 10 00 	movl   $0x103891,(%esp)
  101adc:	e8 a3 e7 ff ff       	call   100284 <cprintf>

    if (!trap_in_kernel(tf)) {
  101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae4:	89 04 24             	mov    %eax,(%esp)
  101ae7:	e8 66 fe ff ff       	call   101952 <trap_in_kernel>
  101aec:	85 c0                	test   %eax,%eax
  101aee:	75 2d                	jne    101b1d <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	8b 40 44             	mov    0x44(%eax),%eax
  101af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afa:	c7 04 24 9a 38 10 00 	movl   $0x10389a,(%esp)
  101b01:	e8 7e e7 ff ff       	call   100284 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b11:	c7 04 24 a9 38 10 00 	movl   $0x1038a9,(%esp)
  101b18:	e8 67 e7 ff ff       	call   100284 <cprintf>
    }
}
  101b1d:	90                   	nop
  101b1e:	c9                   	leave  
  101b1f:	c3                   	ret    

00101b20 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b20:	f3 0f 1e fb          	endbr32 
  101b24:	55                   	push   %ebp
  101b25:	89 e5                	mov    %esp,%ebp
  101b27:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2d:	8b 00                	mov    (%eax),%eax
  101b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b33:	c7 04 24 bc 38 10 00 	movl   $0x1038bc,(%esp)
  101b3a:	e8 45 e7 ff ff       	call   100284 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	8b 40 04             	mov    0x4(%eax),%eax
  101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b49:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  101b50:	e8 2f e7 ff ff       	call   100284 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	8b 40 08             	mov    0x8(%eax),%eax
  101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5f:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  101b66:	e8 19 e7 ff ff       	call   100284 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6e:	8b 40 0c             	mov    0xc(%eax),%eax
  101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b75:	c7 04 24 e9 38 10 00 	movl   $0x1038e9,(%esp)
  101b7c:	e8 03 e7 ff ff       	call   100284 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	8b 40 10             	mov    0x10(%eax),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 f8 38 10 00 	movl   $0x1038f8,(%esp)
  101b92:	e8 ed e6 ff ff       	call   100284 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 40 14             	mov    0x14(%eax),%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 07 39 10 00 	movl   $0x103907,(%esp)
  101ba8:	e8 d7 e6 ff ff       	call   100284 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 40 18             	mov    0x18(%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 16 39 10 00 	movl   $0x103916,(%esp)
  101bbe:	e8 c1 e6 ff ff       	call   100284 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 25 39 10 00 	movl   $0x103925,(%esp)
  101bd4:	e8 ab e6 ff ff       	call   100284 <cprintf>
}
  101bd9:	90                   	nop
  101bda:	c9                   	leave  
  101bdb:	c3                   	ret    

00101bdc <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bdc:	f3 0f 1e fb          	endbr32 
  101be0:	55                   	push   %ebp
  101be1:	89 e5                	mov    %esp,%ebp
  101be3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101be6:	8b 45 08             	mov    0x8(%ebp),%eax
  101be9:	8b 40 30             	mov    0x30(%eax),%eax
  101bec:	83 f8 79             	cmp    $0x79,%eax
  101bef:	0f 87 99 00 00 00    	ja     101c8e <trap_dispatch+0xb2>
  101bf5:	83 f8 78             	cmp    $0x78,%eax
  101bf8:	73 78                	jae    101c72 <trap_dispatch+0x96>
  101bfa:	83 f8 2f             	cmp    $0x2f,%eax
  101bfd:	0f 87 8b 00 00 00    	ja     101c8e <trap_dispatch+0xb2>
  101c03:	83 f8 2e             	cmp    $0x2e,%eax
  101c06:	0f 83 b7 00 00 00    	jae    101cc3 <trap_dispatch+0xe7>
  101c0c:	83 f8 24             	cmp    $0x24,%eax
  101c0f:	74 15                	je     101c26 <trap_dispatch+0x4a>
  101c11:	83 f8 24             	cmp    $0x24,%eax
  101c14:	77 78                	ja     101c8e <trap_dispatch+0xb2>
  101c16:	83 f8 20             	cmp    $0x20,%eax
  101c19:	0f 84 a7 00 00 00    	je     101cc6 <trap_dispatch+0xea>
  101c1f:	83 f8 21             	cmp    $0x21,%eax
  101c22:	74 28                	je     101c4c <trap_dispatch+0x70>
  101c24:	eb 68                	jmp    101c8e <trap_dispatch+0xb2>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c26:	e8 6d fa ff ff       	call   101698 <cons_getc>
  101c2b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c2e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c32:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c36:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3e:	c7 04 24 34 39 10 00 	movl   $0x103934,(%esp)
  101c45:	e8 3a e6 ff ff       	call   100284 <cprintf>
        break;
  101c4a:	eb 7b                	jmp    101cc7 <trap_dispatch+0xeb>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c4c:	e8 47 fa ff ff       	call   101698 <cons_getc>
  101c51:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c54:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c58:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c5c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c64:	c7 04 24 46 39 10 00 	movl   $0x103946,(%esp)
  101c6b:	e8 14 e6 ff ff       	call   100284 <cprintf>
        break;
  101c70:	eb 55                	jmp    101cc7 <trap_dispatch+0xeb>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c72:	c7 44 24 08 55 39 10 	movl   $0x103955,0x8(%esp)
  101c79:	00 
  101c7a:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101c81:	00 
  101c82:	c7 04 24 65 39 10 00 	movl   $0x103965,(%esp)
  101c89:	e8 62 e7 ff ff       	call   1003f0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c95:	83 e0 03             	and    $0x3,%eax
  101c98:	85 c0                	test   %eax,%eax
  101c9a:	75 2b                	jne    101cc7 <trap_dispatch+0xeb>
            print_trapframe(tf);
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	89 04 24             	mov    %eax,(%esp)
  101ca2:	e8 c4 fc ff ff       	call   10196b <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ca7:	c7 44 24 08 76 39 10 	movl   $0x103976,0x8(%esp)
  101cae:	00 
  101caf:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101cb6:	00 
  101cb7:	c7 04 24 65 39 10 00 	movl   $0x103965,(%esp)
  101cbe:	e8 2d e7 ff ff       	call   1003f0 <__panic>
        break;
  101cc3:	90                   	nop
  101cc4:	eb 01                	jmp    101cc7 <trap_dispatch+0xeb>
        break;
  101cc6:	90                   	nop
        }
    }
}
  101cc7:	90                   	nop
  101cc8:	c9                   	leave  
  101cc9:	c3                   	ret    

00101cca <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101cca:	f3 0f 1e fb          	endbr32 
  101cce:	55                   	push   %ebp
  101ccf:	89 e5                	mov    %esp,%ebp
  101cd1:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	89 04 24             	mov    %eax,(%esp)
  101cda:	e8 fd fe ff ff       	call   101bdc <trap_dispatch>
}
  101cdf:	90                   	nop
  101ce0:	c9                   	leave  
  101ce1:	c3                   	ret    

00101ce2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ce2:	6a 00                	push   $0x0
  pushl $0
  101ce4:	6a 00                	push   $0x0
  jmp __alltraps
  101ce6:	e9 69 0a 00 00       	jmp    102754 <__alltraps>

00101ceb <vector1>:
.globl vector1
vector1:
  pushl $0
  101ceb:	6a 00                	push   $0x0
  pushl $1
  101ced:	6a 01                	push   $0x1
  jmp __alltraps
  101cef:	e9 60 0a 00 00       	jmp    102754 <__alltraps>

00101cf4 <vector2>:
.globl vector2
vector2:
  pushl $0
  101cf4:	6a 00                	push   $0x0
  pushl $2
  101cf6:	6a 02                	push   $0x2
  jmp __alltraps
  101cf8:	e9 57 0a 00 00       	jmp    102754 <__alltraps>

00101cfd <vector3>:
.globl vector3
vector3:
  pushl $0
  101cfd:	6a 00                	push   $0x0
  pushl $3
  101cff:	6a 03                	push   $0x3
  jmp __alltraps
  101d01:	e9 4e 0a 00 00       	jmp    102754 <__alltraps>

00101d06 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d06:	6a 00                	push   $0x0
  pushl $4
  101d08:	6a 04                	push   $0x4
  jmp __alltraps
  101d0a:	e9 45 0a 00 00       	jmp    102754 <__alltraps>

00101d0f <vector5>:
.globl vector5
vector5:
  pushl $0
  101d0f:	6a 00                	push   $0x0
  pushl $5
  101d11:	6a 05                	push   $0x5
  jmp __alltraps
  101d13:	e9 3c 0a 00 00       	jmp    102754 <__alltraps>

00101d18 <vector6>:
.globl vector6
vector6:
  pushl $0
  101d18:	6a 00                	push   $0x0
  pushl $6
  101d1a:	6a 06                	push   $0x6
  jmp __alltraps
  101d1c:	e9 33 0a 00 00       	jmp    102754 <__alltraps>

00101d21 <vector7>:
.globl vector7
vector7:
  pushl $0
  101d21:	6a 00                	push   $0x0
  pushl $7
  101d23:	6a 07                	push   $0x7
  jmp __alltraps
  101d25:	e9 2a 0a 00 00       	jmp    102754 <__alltraps>

00101d2a <vector8>:
.globl vector8
vector8:
  pushl $8
  101d2a:	6a 08                	push   $0x8
  jmp __alltraps
  101d2c:	e9 23 0a 00 00       	jmp    102754 <__alltraps>

00101d31 <vector9>:
.globl vector9
vector9:
  pushl $0
  101d31:	6a 00                	push   $0x0
  pushl $9
  101d33:	6a 09                	push   $0x9
  jmp __alltraps
  101d35:	e9 1a 0a 00 00       	jmp    102754 <__alltraps>

00101d3a <vector10>:
.globl vector10
vector10:
  pushl $10
  101d3a:	6a 0a                	push   $0xa
  jmp __alltraps
  101d3c:	e9 13 0a 00 00       	jmp    102754 <__alltraps>

00101d41 <vector11>:
.globl vector11
vector11:
  pushl $11
  101d41:	6a 0b                	push   $0xb
  jmp __alltraps
  101d43:	e9 0c 0a 00 00       	jmp    102754 <__alltraps>

00101d48 <vector12>:
.globl vector12
vector12:
  pushl $12
  101d48:	6a 0c                	push   $0xc
  jmp __alltraps
  101d4a:	e9 05 0a 00 00       	jmp    102754 <__alltraps>

00101d4f <vector13>:
.globl vector13
vector13:
  pushl $13
  101d4f:	6a 0d                	push   $0xd
  jmp __alltraps
  101d51:	e9 fe 09 00 00       	jmp    102754 <__alltraps>

00101d56 <vector14>:
.globl vector14
vector14:
  pushl $14
  101d56:	6a 0e                	push   $0xe
  jmp __alltraps
  101d58:	e9 f7 09 00 00       	jmp    102754 <__alltraps>

00101d5d <vector15>:
.globl vector15
vector15:
  pushl $0
  101d5d:	6a 00                	push   $0x0
  pushl $15
  101d5f:	6a 0f                	push   $0xf
  jmp __alltraps
  101d61:	e9 ee 09 00 00       	jmp    102754 <__alltraps>

00101d66 <vector16>:
.globl vector16
vector16:
  pushl $0
  101d66:	6a 00                	push   $0x0
  pushl $16
  101d68:	6a 10                	push   $0x10
  jmp __alltraps
  101d6a:	e9 e5 09 00 00       	jmp    102754 <__alltraps>

00101d6f <vector17>:
.globl vector17
vector17:
  pushl $17
  101d6f:	6a 11                	push   $0x11
  jmp __alltraps
  101d71:	e9 de 09 00 00       	jmp    102754 <__alltraps>

00101d76 <vector18>:
.globl vector18
vector18:
  pushl $0
  101d76:	6a 00                	push   $0x0
  pushl $18
  101d78:	6a 12                	push   $0x12
  jmp __alltraps
  101d7a:	e9 d5 09 00 00       	jmp    102754 <__alltraps>

00101d7f <vector19>:
.globl vector19
vector19:
  pushl $0
  101d7f:	6a 00                	push   $0x0
  pushl $19
  101d81:	6a 13                	push   $0x13
  jmp __alltraps
  101d83:	e9 cc 09 00 00       	jmp    102754 <__alltraps>

00101d88 <vector20>:
.globl vector20
vector20:
  pushl $0
  101d88:	6a 00                	push   $0x0
  pushl $20
  101d8a:	6a 14                	push   $0x14
  jmp __alltraps
  101d8c:	e9 c3 09 00 00       	jmp    102754 <__alltraps>

00101d91 <vector21>:
.globl vector21
vector21:
  pushl $0
  101d91:	6a 00                	push   $0x0
  pushl $21
  101d93:	6a 15                	push   $0x15
  jmp __alltraps
  101d95:	e9 ba 09 00 00       	jmp    102754 <__alltraps>

00101d9a <vector22>:
.globl vector22
vector22:
  pushl $0
  101d9a:	6a 00                	push   $0x0
  pushl $22
  101d9c:	6a 16                	push   $0x16
  jmp __alltraps
  101d9e:	e9 b1 09 00 00       	jmp    102754 <__alltraps>

00101da3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101da3:	6a 00                	push   $0x0
  pushl $23
  101da5:	6a 17                	push   $0x17
  jmp __alltraps
  101da7:	e9 a8 09 00 00       	jmp    102754 <__alltraps>

00101dac <vector24>:
.globl vector24
vector24:
  pushl $0
  101dac:	6a 00                	push   $0x0
  pushl $24
  101dae:	6a 18                	push   $0x18
  jmp __alltraps
  101db0:	e9 9f 09 00 00       	jmp    102754 <__alltraps>

00101db5 <vector25>:
.globl vector25
vector25:
  pushl $0
  101db5:	6a 00                	push   $0x0
  pushl $25
  101db7:	6a 19                	push   $0x19
  jmp __alltraps
  101db9:	e9 96 09 00 00       	jmp    102754 <__alltraps>

00101dbe <vector26>:
.globl vector26
vector26:
  pushl $0
  101dbe:	6a 00                	push   $0x0
  pushl $26
  101dc0:	6a 1a                	push   $0x1a
  jmp __alltraps
  101dc2:	e9 8d 09 00 00       	jmp    102754 <__alltraps>

00101dc7 <vector27>:
.globl vector27
vector27:
  pushl $0
  101dc7:	6a 00                	push   $0x0
  pushl $27
  101dc9:	6a 1b                	push   $0x1b
  jmp __alltraps
  101dcb:	e9 84 09 00 00       	jmp    102754 <__alltraps>

00101dd0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101dd0:	6a 00                	push   $0x0
  pushl $28
  101dd2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101dd4:	e9 7b 09 00 00       	jmp    102754 <__alltraps>

00101dd9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101dd9:	6a 00                	push   $0x0
  pushl $29
  101ddb:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ddd:	e9 72 09 00 00       	jmp    102754 <__alltraps>

00101de2 <vector30>:
.globl vector30
vector30:
  pushl $0
  101de2:	6a 00                	push   $0x0
  pushl $30
  101de4:	6a 1e                	push   $0x1e
  jmp __alltraps
  101de6:	e9 69 09 00 00       	jmp    102754 <__alltraps>

00101deb <vector31>:
.globl vector31
vector31:
  pushl $0
  101deb:	6a 00                	push   $0x0
  pushl $31
  101ded:	6a 1f                	push   $0x1f
  jmp __alltraps
  101def:	e9 60 09 00 00       	jmp    102754 <__alltraps>

00101df4 <vector32>:
.globl vector32
vector32:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $32
  101df6:	6a 20                	push   $0x20
  jmp __alltraps
  101df8:	e9 57 09 00 00       	jmp    102754 <__alltraps>

00101dfd <vector33>:
.globl vector33
vector33:
  pushl $0
  101dfd:	6a 00                	push   $0x0
  pushl $33
  101dff:	6a 21                	push   $0x21
  jmp __alltraps
  101e01:	e9 4e 09 00 00       	jmp    102754 <__alltraps>

00101e06 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $34
  101e08:	6a 22                	push   $0x22
  jmp __alltraps
  101e0a:	e9 45 09 00 00       	jmp    102754 <__alltraps>

00101e0f <vector35>:
.globl vector35
vector35:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $35
  101e11:	6a 23                	push   $0x23
  jmp __alltraps
  101e13:	e9 3c 09 00 00       	jmp    102754 <__alltraps>

00101e18 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $36
  101e1a:	6a 24                	push   $0x24
  jmp __alltraps
  101e1c:	e9 33 09 00 00       	jmp    102754 <__alltraps>

00101e21 <vector37>:
.globl vector37
vector37:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $37
  101e23:	6a 25                	push   $0x25
  jmp __alltraps
  101e25:	e9 2a 09 00 00       	jmp    102754 <__alltraps>

00101e2a <vector38>:
.globl vector38
vector38:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $38
  101e2c:	6a 26                	push   $0x26
  jmp __alltraps
  101e2e:	e9 21 09 00 00       	jmp    102754 <__alltraps>

00101e33 <vector39>:
.globl vector39
vector39:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $39
  101e35:	6a 27                	push   $0x27
  jmp __alltraps
  101e37:	e9 18 09 00 00       	jmp    102754 <__alltraps>

00101e3c <vector40>:
.globl vector40
vector40:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $40
  101e3e:	6a 28                	push   $0x28
  jmp __alltraps
  101e40:	e9 0f 09 00 00       	jmp    102754 <__alltraps>

00101e45 <vector41>:
.globl vector41
vector41:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $41
  101e47:	6a 29                	push   $0x29
  jmp __alltraps
  101e49:	e9 06 09 00 00       	jmp    102754 <__alltraps>

00101e4e <vector42>:
.globl vector42
vector42:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $42
  101e50:	6a 2a                	push   $0x2a
  jmp __alltraps
  101e52:	e9 fd 08 00 00       	jmp    102754 <__alltraps>

00101e57 <vector43>:
.globl vector43
vector43:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $43
  101e59:	6a 2b                	push   $0x2b
  jmp __alltraps
  101e5b:	e9 f4 08 00 00       	jmp    102754 <__alltraps>

00101e60 <vector44>:
.globl vector44
vector44:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $44
  101e62:	6a 2c                	push   $0x2c
  jmp __alltraps
  101e64:	e9 eb 08 00 00       	jmp    102754 <__alltraps>

00101e69 <vector45>:
.globl vector45
vector45:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $45
  101e6b:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e6d:	e9 e2 08 00 00       	jmp    102754 <__alltraps>

00101e72 <vector46>:
.globl vector46
vector46:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $46
  101e74:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e76:	e9 d9 08 00 00       	jmp    102754 <__alltraps>

00101e7b <vector47>:
.globl vector47
vector47:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $47
  101e7d:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e7f:	e9 d0 08 00 00       	jmp    102754 <__alltraps>

00101e84 <vector48>:
.globl vector48
vector48:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $48
  101e86:	6a 30                	push   $0x30
  jmp __alltraps
  101e88:	e9 c7 08 00 00       	jmp    102754 <__alltraps>

00101e8d <vector49>:
.globl vector49
vector49:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $49
  101e8f:	6a 31                	push   $0x31
  jmp __alltraps
  101e91:	e9 be 08 00 00       	jmp    102754 <__alltraps>

00101e96 <vector50>:
.globl vector50
vector50:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $50
  101e98:	6a 32                	push   $0x32
  jmp __alltraps
  101e9a:	e9 b5 08 00 00       	jmp    102754 <__alltraps>

00101e9f <vector51>:
.globl vector51
vector51:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $51
  101ea1:	6a 33                	push   $0x33
  jmp __alltraps
  101ea3:	e9 ac 08 00 00       	jmp    102754 <__alltraps>

00101ea8 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $52
  101eaa:	6a 34                	push   $0x34
  jmp __alltraps
  101eac:	e9 a3 08 00 00       	jmp    102754 <__alltraps>

00101eb1 <vector53>:
.globl vector53
vector53:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $53
  101eb3:	6a 35                	push   $0x35
  jmp __alltraps
  101eb5:	e9 9a 08 00 00       	jmp    102754 <__alltraps>

00101eba <vector54>:
.globl vector54
vector54:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $54
  101ebc:	6a 36                	push   $0x36
  jmp __alltraps
  101ebe:	e9 91 08 00 00       	jmp    102754 <__alltraps>

00101ec3 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $55
  101ec5:	6a 37                	push   $0x37
  jmp __alltraps
  101ec7:	e9 88 08 00 00       	jmp    102754 <__alltraps>

00101ecc <vector56>:
.globl vector56
vector56:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $56
  101ece:	6a 38                	push   $0x38
  jmp __alltraps
  101ed0:	e9 7f 08 00 00       	jmp    102754 <__alltraps>

00101ed5 <vector57>:
.globl vector57
vector57:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $57
  101ed7:	6a 39                	push   $0x39
  jmp __alltraps
  101ed9:	e9 76 08 00 00       	jmp    102754 <__alltraps>

00101ede <vector58>:
.globl vector58
vector58:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $58
  101ee0:	6a 3a                	push   $0x3a
  jmp __alltraps
  101ee2:	e9 6d 08 00 00       	jmp    102754 <__alltraps>

00101ee7 <vector59>:
.globl vector59
vector59:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $59
  101ee9:	6a 3b                	push   $0x3b
  jmp __alltraps
  101eeb:	e9 64 08 00 00       	jmp    102754 <__alltraps>

00101ef0 <vector60>:
.globl vector60
vector60:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $60
  101ef2:	6a 3c                	push   $0x3c
  jmp __alltraps
  101ef4:	e9 5b 08 00 00       	jmp    102754 <__alltraps>

00101ef9 <vector61>:
.globl vector61
vector61:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $61
  101efb:	6a 3d                	push   $0x3d
  jmp __alltraps
  101efd:	e9 52 08 00 00       	jmp    102754 <__alltraps>

00101f02 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $62
  101f04:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f06:	e9 49 08 00 00       	jmp    102754 <__alltraps>

00101f0b <vector63>:
.globl vector63
vector63:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $63
  101f0d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f0f:	e9 40 08 00 00       	jmp    102754 <__alltraps>

00101f14 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $64
  101f16:	6a 40                	push   $0x40
  jmp __alltraps
  101f18:	e9 37 08 00 00       	jmp    102754 <__alltraps>

00101f1d <vector65>:
.globl vector65
vector65:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $65
  101f1f:	6a 41                	push   $0x41
  jmp __alltraps
  101f21:	e9 2e 08 00 00       	jmp    102754 <__alltraps>

00101f26 <vector66>:
.globl vector66
vector66:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $66
  101f28:	6a 42                	push   $0x42
  jmp __alltraps
  101f2a:	e9 25 08 00 00       	jmp    102754 <__alltraps>

00101f2f <vector67>:
.globl vector67
vector67:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $67
  101f31:	6a 43                	push   $0x43
  jmp __alltraps
  101f33:	e9 1c 08 00 00       	jmp    102754 <__alltraps>

00101f38 <vector68>:
.globl vector68
vector68:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $68
  101f3a:	6a 44                	push   $0x44
  jmp __alltraps
  101f3c:	e9 13 08 00 00       	jmp    102754 <__alltraps>

00101f41 <vector69>:
.globl vector69
vector69:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $69
  101f43:	6a 45                	push   $0x45
  jmp __alltraps
  101f45:	e9 0a 08 00 00       	jmp    102754 <__alltraps>

00101f4a <vector70>:
.globl vector70
vector70:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $70
  101f4c:	6a 46                	push   $0x46
  jmp __alltraps
  101f4e:	e9 01 08 00 00       	jmp    102754 <__alltraps>

00101f53 <vector71>:
.globl vector71
vector71:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $71
  101f55:	6a 47                	push   $0x47
  jmp __alltraps
  101f57:	e9 f8 07 00 00       	jmp    102754 <__alltraps>

00101f5c <vector72>:
.globl vector72
vector72:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $72
  101f5e:	6a 48                	push   $0x48
  jmp __alltraps
  101f60:	e9 ef 07 00 00       	jmp    102754 <__alltraps>

00101f65 <vector73>:
.globl vector73
vector73:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $73
  101f67:	6a 49                	push   $0x49
  jmp __alltraps
  101f69:	e9 e6 07 00 00       	jmp    102754 <__alltraps>

00101f6e <vector74>:
.globl vector74
vector74:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $74
  101f70:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f72:	e9 dd 07 00 00       	jmp    102754 <__alltraps>

00101f77 <vector75>:
.globl vector75
vector75:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $75
  101f79:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f7b:	e9 d4 07 00 00       	jmp    102754 <__alltraps>

00101f80 <vector76>:
.globl vector76
vector76:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $76
  101f82:	6a 4c                	push   $0x4c
  jmp __alltraps
  101f84:	e9 cb 07 00 00       	jmp    102754 <__alltraps>

00101f89 <vector77>:
.globl vector77
vector77:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $77
  101f8b:	6a 4d                	push   $0x4d
  jmp __alltraps
  101f8d:	e9 c2 07 00 00       	jmp    102754 <__alltraps>

00101f92 <vector78>:
.globl vector78
vector78:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $78
  101f94:	6a 4e                	push   $0x4e
  jmp __alltraps
  101f96:	e9 b9 07 00 00       	jmp    102754 <__alltraps>

00101f9b <vector79>:
.globl vector79
vector79:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $79
  101f9d:	6a 4f                	push   $0x4f
  jmp __alltraps
  101f9f:	e9 b0 07 00 00       	jmp    102754 <__alltraps>

00101fa4 <vector80>:
.globl vector80
vector80:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $80
  101fa6:	6a 50                	push   $0x50
  jmp __alltraps
  101fa8:	e9 a7 07 00 00       	jmp    102754 <__alltraps>

00101fad <vector81>:
.globl vector81
vector81:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $81
  101faf:	6a 51                	push   $0x51
  jmp __alltraps
  101fb1:	e9 9e 07 00 00       	jmp    102754 <__alltraps>

00101fb6 <vector82>:
.globl vector82
vector82:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $82
  101fb8:	6a 52                	push   $0x52
  jmp __alltraps
  101fba:	e9 95 07 00 00       	jmp    102754 <__alltraps>

00101fbf <vector83>:
.globl vector83
vector83:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $83
  101fc1:	6a 53                	push   $0x53
  jmp __alltraps
  101fc3:	e9 8c 07 00 00       	jmp    102754 <__alltraps>

00101fc8 <vector84>:
.globl vector84
vector84:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $84
  101fca:	6a 54                	push   $0x54
  jmp __alltraps
  101fcc:	e9 83 07 00 00       	jmp    102754 <__alltraps>

00101fd1 <vector85>:
.globl vector85
vector85:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $85
  101fd3:	6a 55                	push   $0x55
  jmp __alltraps
  101fd5:	e9 7a 07 00 00       	jmp    102754 <__alltraps>

00101fda <vector86>:
.globl vector86
vector86:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $86
  101fdc:	6a 56                	push   $0x56
  jmp __alltraps
  101fde:	e9 71 07 00 00       	jmp    102754 <__alltraps>

00101fe3 <vector87>:
.globl vector87
vector87:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $87
  101fe5:	6a 57                	push   $0x57
  jmp __alltraps
  101fe7:	e9 68 07 00 00       	jmp    102754 <__alltraps>

00101fec <vector88>:
.globl vector88
vector88:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $88
  101fee:	6a 58                	push   $0x58
  jmp __alltraps
  101ff0:	e9 5f 07 00 00       	jmp    102754 <__alltraps>

00101ff5 <vector89>:
.globl vector89
vector89:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $89
  101ff7:	6a 59                	push   $0x59
  jmp __alltraps
  101ff9:	e9 56 07 00 00       	jmp    102754 <__alltraps>

00101ffe <vector90>:
.globl vector90
vector90:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $90
  102000:	6a 5a                	push   $0x5a
  jmp __alltraps
  102002:	e9 4d 07 00 00       	jmp    102754 <__alltraps>

00102007 <vector91>:
.globl vector91
vector91:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $91
  102009:	6a 5b                	push   $0x5b
  jmp __alltraps
  10200b:	e9 44 07 00 00       	jmp    102754 <__alltraps>

00102010 <vector92>:
.globl vector92
vector92:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $92
  102012:	6a 5c                	push   $0x5c
  jmp __alltraps
  102014:	e9 3b 07 00 00       	jmp    102754 <__alltraps>

00102019 <vector93>:
.globl vector93
vector93:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $93
  10201b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10201d:	e9 32 07 00 00       	jmp    102754 <__alltraps>

00102022 <vector94>:
.globl vector94
vector94:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $94
  102024:	6a 5e                	push   $0x5e
  jmp __alltraps
  102026:	e9 29 07 00 00       	jmp    102754 <__alltraps>

0010202b <vector95>:
.globl vector95
vector95:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $95
  10202d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10202f:	e9 20 07 00 00       	jmp    102754 <__alltraps>

00102034 <vector96>:
.globl vector96
vector96:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $96
  102036:	6a 60                	push   $0x60
  jmp __alltraps
  102038:	e9 17 07 00 00       	jmp    102754 <__alltraps>

0010203d <vector97>:
.globl vector97
vector97:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $97
  10203f:	6a 61                	push   $0x61
  jmp __alltraps
  102041:	e9 0e 07 00 00       	jmp    102754 <__alltraps>

00102046 <vector98>:
.globl vector98
vector98:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $98
  102048:	6a 62                	push   $0x62
  jmp __alltraps
  10204a:	e9 05 07 00 00       	jmp    102754 <__alltraps>

0010204f <vector99>:
.globl vector99
vector99:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $99
  102051:	6a 63                	push   $0x63
  jmp __alltraps
  102053:	e9 fc 06 00 00       	jmp    102754 <__alltraps>

00102058 <vector100>:
.globl vector100
vector100:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $100
  10205a:	6a 64                	push   $0x64
  jmp __alltraps
  10205c:	e9 f3 06 00 00       	jmp    102754 <__alltraps>

00102061 <vector101>:
.globl vector101
vector101:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $101
  102063:	6a 65                	push   $0x65
  jmp __alltraps
  102065:	e9 ea 06 00 00       	jmp    102754 <__alltraps>

0010206a <vector102>:
.globl vector102
vector102:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $102
  10206c:	6a 66                	push   $0x66
  jmp __alltraps
  10206e:	e9 e1 06 00 00       	jmp    102754 <__alltraps>

00102073 <vector103>:
.globl vector103
vector103:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $103
  102075:	6a 67                	push   $0x67
  jmp __alltraps
  102077:	e9 d8 06 00 00       	jmp    102754 <__alltraps>

0010207c <vector104>:
.globl vector104
vector104:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $104
  10207e:	6a 68                	push   $0x68
  jmp __alltraps
  102080:	e9 cf 06 00 00       	jmp    102754 <__alltraps>

00102085 <vector105>:
.globl vector105
vector105:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $105
  102087:	6a 69                	push   $0x69
  jmp __alltraps
  102089:	e9 c6 06 00 00       	jmp    102754 <__alltraps>

0010208e <vector106>:
.globl vector106
vector106:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $106
  102090:	6a 6a                	push   $0x6a
  jmp __alltraps
  102092:	e9 bd 06 00 00       	jmp    102754 <__alltraps>

00102097 <vector107>:
.globl vector107
vector107:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $107
  102099:	6a 6b                	push   $0x6b
  jmp __alltraps
  10209b:	e9 b4 06 00 00       	jmp    102754 <__alltraps>

001020a0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $108
  1020a2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1020a4:	e9 ab 06 00 00       	jmp    102754 <__alltraps>

001020a9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $109
  1020ab:	6a 6d                	push   $0x6d
  jmp __alltraps
  1020ad:	e9 a2 06 00 00       	jmp    102754 <__alltraps>

001020b2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $110
  1020b4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1020b6:	e9 99 06 00 00       	jmp    102754 <__alltraps>

001020bb <vector111>:
.globl vector111
vector111:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $111
  1020bd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1020bf:	e9 90 06 00 00       	jmp    102754 <__alltraps>

001020c4 <vector112>:
.globl vector112
vector112:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $112
  1020c6:	6a 70                	push   $0x70
  jmp __alltraps
  1020c8:	e9 87 06 00 00       	jmp    102754 <__alltraps>

001020cd <vector113>:
.globl vector113
vector113:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $113
  1020cf:	6a 71                	push   $0x71
  jmp __alltraps
  1020d1:	e9 7e 06 00 00       	jmp    102754 <__alltraps>

001020d6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $114
  1020d8:	6a 72                	push   $0x72
  jmp __alltraps
  1020da:	e9 75 06 00 00       	jmp    102754 <__alltraps>

001020df <vector115>:
.globl vector115
vector115:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $115
  1020e1:	6a 73                	push   $0x73
  jmp __alltraps
  1020e3:	e9 6c 06 00 00       	jmp    102754 <__alltraps>

001020e8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $116
  1020ea:	6a 74                	push   $0x74
  jmp __alltraps
  1020ec:	e9 63 06 00 00       	jmp    102754 <__alltraps>

001020f1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $117
  1020f3:	6a 75                	push   $0x75
  jmp __alltraps
  1020f5:	e9 5a 06 00 00       	jmp    102754 <__alltraps>

001020fa <vector118>:
.globl vector118
vector118:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $118
  1020fc:	6a 76                	push   $0x76
  jmp __alltraps
  1020fe:	e9 51 06 00 00       	jmp    102754 <__alltraps>

00102103 <vector119>:
.globl vector119
vector119:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $119
  102105:	6a 77                	push   $0x77
  jmp __alltraps
  102107:	e9 48 06 00 00       	jmp    102754 <__alltraps>

0010210c <vector120>:
.globl vector120
vector120:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $120
  10210e:	6a 78                	push   $0x78
  jmp __alltraps
  102110:	e9 3f 06 00 00       	jmp    102754 <__alltraps>

00102115 <vector121>:
.globl vector121
vector121:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $121
  102117:	6a 79                	push   $0x79
  jmp __alltraps
  102119:	e9 36 06 00 00       	jmp    102754 <__alltraps>

0010211e <vector122>:
.globl vector122
vector122:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $122
  102120:	6a 7a                	push   $0x7a
  jmp __alltraps
  102122:	e9 2d 06 00 00       	jmp    102754 <__alltraps>

00102127 <vector123>:
.globl vector123
vector123:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $123
  102129:	6a 7b                	push   $0x7b
  jmp __alltraps
  10212b:	e9 24 06 00 00       	jmp    102754 <__alltraps>

00102130 <vector124>:
.globl vector124
vector124:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $124
  102132:	6a 7c                	push   $0x7c
  jmp __alltraps
  102134:	e9 1b 06 00 00       	jmp    102754 <__alltraps>

00102139 <vector125>:
.globl vector125
vector125:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $125
  10213b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10213d:	e9 12 06 00 00       	jmp    102754 <__alltraps>

00102142 <vector126>:
.globl vector126
vector126:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $126
  102144:	6a 7e                	push   $0x7e
  jmp __alltraps
  102146:	e9 09 06 00 00       	jmp    102754 <__alltraps>

0010214b <vector127>:
.globl vector127
vector127:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $127
  10214d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10214f:	e9 00 06 00 00       	jmp    102754 <__alltraps>

00102154 <vector128>:
.globl vector128
vector128:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $128
  102156:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10215b:	e9 f4 05 00 00       	jmp    102754 <__alltraps>

00102160 <vector129>:
.globl vector129
vector129:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $129
  102162:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102167:	e9 e8 05 00 00       	jmp    102754 <__alltraps>

0010216c <vector130>:
.globl vector130
vector130:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $130
  10216e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102173:	e9 dc 05 00 00       	jmp    102754 <__alltraps>

00102178 <vector131>:
.globl vector131
vector131:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $131
  10217a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10217f:	e9 d0 05 00 00       	jmp    102754 <__alltraps>

00102184 <vector132>:
.globl vector132
vector132:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $132
  102186:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10218b:	e9 c4 05 00 00       	jmp    102754 <__alltraps>

00102190 <vector133>:
.globl vector133
vector133:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $133
  102192:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102197:	e9 b8 05 00 00       	jmp    102754 <__alltraps>

0010219c <vector134>:
.globl vector134
vector134:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $134
  10219e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1021a3:	e9 ac 05 00 00       	jmp    102754 <__alltraps>

001021a8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $135
  1021aa:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1021af:	e9 a0 05 00 00       	jmp    102754 <__alltraps>

001021b4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $136
  1021b6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1021bb:	e9 94 05 00 00       	jmp    102754 <__alltraps>

001021c0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $137
  1021c2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1021c7:	e9 88 05 00 00       	jmp    102754 <__alltraps>

001021cc <vector138>:
.globl vector138
vector138:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $138
  1021ce:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1021d3:	e9 7c 05 00 00       	jmp    102754 <__alltraps>

001021d8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $139
  1021da:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1021df:	e9 70 05 00 00       	jmp    102754 <__alltraps>

001021e4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $140
  1021e6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1021eb:	e9 64 05 00 00       	jmp    102754 <__alltraps>

001021f0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $141
  1021f2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1021f7:	e9 58 05 00 00       	jmp    102754 <__alltraps>

001021fc <vector142>:
.globl vector142
vector142:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $142
  1021fe:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102203:	e9 4c 05 00 00       	jmp    102754 <__alltraps>

00102208 <vector143>:
.globl vector143
vector143:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $143
  10220a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10220f:	e9 40 05 00 00       	jmp    102754 <__alltraps>

00102214 <vector144>:
.globl vector144
vector144:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $144
  102216:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10221b:	e9 34 05 00 00       	jmp    102754 <__alltraps>

00102220 <vector145>:
.globl vector145
vector145:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $145
  102222:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102227:	e9 28 05 00 00       	jmp    102754 <__alltraps>

0010222c <vector146>:
.globl vector146
vector146:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $146
  10222e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102233:	e9 1c 05 00 00       	jmp    102754 <__alltraps>

00102238 <vector147>:
.globl vector147
vector147:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $147
  10223a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10223f:	e9 10 05 00 00       	jmp    102754 <__alltraps>

00102244 <vector148>:
.globl vector148
vector148:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $148
  102246:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10224b:	e9 04 05 00 00       	jmp    102754 <__alltraps>

00102250 <vector149>:
.globl vector149
vector149:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $149
  102252:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102257:	e9 f8 04 00 00       	jmp    102754 <__alltraps>

0010225c <vector150>:
.globl vector150
vector150:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $150
  10225e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102263:	e9 ec 04 00 00       	jmp    102754 <__alltraps>

00102268 <vector151>:
.globl vector151
vector151:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $151
  10226a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10226f:	e9 e0 04 00 00       	jmp    102754 <__alltraps>

00102274 <vector152>:
.globl vector152
vector152:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $152
  102276:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10227b:	e9 d4 04 00 00       	jmp    102754 <__alltraps>

00102280 <vector153>:
.globl vector153
vector153:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $153
  102282:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102287:	e9 c8 04 00 00       	jmp    102754 <__alltraps>

0010228c <vector154>:
.globl vector154
vector154:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $154
  10228e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102293:	e9 bc 04 00 00       	jmp    102754 <__alltraps>

00102298 <vector155>:
.globl vector155
vector155:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $155
  10229a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10229f:	e9 b0 04 00 00       	jmp    102754 <__alltraps>

001022a4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $156
  1022a6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1022ab:	e9 a4 04 00 00       	jmp    102754 <__alltraps>

001022b0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $157
  1022b2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1022b7:	e9 98 04 00 00       	jmp    102754 <__alltraps>

001022bc <vector158>:
.globl vector158
vector158:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $158
  1022be:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1022c3:	e9 8c 04 00 00       	jmp    102754 <__alltraps>

001022c8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $159
  1022ca:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1022cf:	e9 80 04 00 00       	jmp    102754 <__alltraps>

001022d4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $160
  1022d6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1022db:	e9 74 04 00 00       	jmp    102754 <__alltraps>

001022e0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $161
  1022e2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1022e7:	e9 68 04 00 00       	jmp    102754 <__alltraps>

001022ec <vector162>:
.globl vector162
vector162:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $162
  1022ee:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1022f3:	e9 5c 04 00 00       	jmp    102754 <__alltraps>

001022f8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $163
  1022fa:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1022ff:	e9 50 04 00 00       	jmp    102754 <__alltraps>

00102304 <vector164>:
.globl vector164
vector164:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $164
  102306:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10230b:	e9 44 04 00 00       	jmp    102754 <__alltraps>

00102310 <vector165>:
.globl vector165
vector165:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $165
  102312:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102317:	e9 38 04 00 00       	jmp    102754 <__alltraps>

0010231c <vector166>:
.globl vector166
vector166:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $166
  10231e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102323:	e9 2c 04 00 00       	jmp    102754 <__alltraps>

00102328 <vector167>:
.globl vector167
vector167:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $167
  10232a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10232f:	e9 20 04 00 00       	jmp    102754 <__alltraps>

00102334 <vector168>:
.globl vector168
vector168:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $168
  102336:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10233b:	e9 14 04 00 00       	jmp    102754 <__alltraps>

00102340 <vector169>:
.globl vector169
vector169:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $169
  102342:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102347:	e9 08 04 00 00       	jmp    102754 <__alltraps>

0010234c <vector170>:
.globl vector170
vector170:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $170
  10234e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102353:	e9 fc 03 00 00       	jmp    102754 <__alltraps>

00102358 <vector171>:
.globl vector171
vector171:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $171
  10235a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10235f:	e9 f0 03 00 00       	jmp    102754 <__alltraps>

00102364 <vector172>:
.globl vector172
vector172:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $172
  102366:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10236b:	e9 e4 03 00 00       	jmp    102754 <__alltraps>

00102370 <vector173>:
.globl vector173
vector173:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $173
  102372:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102377:	e9 d8 03 00 00       	jmp    102754 <__alltraps>

0010237c <vector174>:
.globl vector174
vector174:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $174
  10237e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102383:	e9 cc 03 00 00       	jmp    102754 <__alltraps>

00102388 <vector175>:
.globl vector175
vector175:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $175
  10238a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10238f:	e9 c0 03 00 00       	jmp    102754 <__alltraps>

00102394 <vector176>:
.globl vector176
vector176:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $176
  102396:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10239b:	e9 b4 03 00 00       	jmp    102754 <__alltraps>

001023a0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $177
  1023a2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1023a7:	e9 a8 03 00 00       	jmp    102754 <__alltraps>

001023ac <vector178>:
.globl vector178
vector178:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $178
  1023ae:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1023b3:	e9 9c 03 00 00       	jmp    102754 <__alltraps>

001023b8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $179
  1023ba:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1023bf:	e9 90 03 00 00       	jmp    102754 <__alltraps>

001023c4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $180
  1023c6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1023cb:	e9 84 03 00 00       	jmp    102754 <__alltraps>

001023d0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $181
  1023d2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1023d7:	e9 78 03 00 00       	jmp    102754 <__alltraps>

001023dc <vector182>:
.globl vector182
vector182:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $182
  1023de:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1023e3:	e9 6c 03 00 00       	jmp    102754 <__alltraps>

001023e8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $183
  1023ea:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1023ef:	e9 60 03 00 00       	jmp    102754 <__alltraps>

001023f4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $184
  1023f6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1023fb:	e9 54 03 00 00       	jmp    102754 <__alltraps>

00102400 <vector185>:
.globl vector185
vector185:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $185
  102402:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102407:	e9 48 03 00 00       	jmp    102754 <__alltraps>

0010240c <vector186>:
.globl vector186
vector186:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $186
  10240e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102413:	e9 3c 03 00 00       	jmp    102754 <__alltraps>

00102418 <vector187>:
.globl vector187
vector187:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $187
  10241a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10241f:	e9 30 03 00 00       	jmp    102754 <__alltraps>

00102424 <vector188>:
.globl vector188
vector188:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $188
  102426:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10242b:	e9 24 03 00 00       	jmp    102754 <__alltraps>

00102430 <vector189>:
.globl vector189
vector189:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $189
  102432:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102437:	e9 18 03 00 00       	jmp    102754 <__alltraps>

0010243c <vector190>:
.globl vector190
vector190:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $190
  10243e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102443:	e9 0c 03 00 00       	jmp    102754 <__alltraps>

00102448 <vector191>:
.globl vector191
vector191:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $191
  10244a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10244f:	e9 00 03 00 00       	jmp    102754 <__alltraps>

00102454 <vector192>:
.globl vector192
vector192:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $192
  102456:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10245b:	e9 f4 02 00 00       	jmp    102754 <__alltraps>

00102460 <vector193>:
.globl vector193
vector193:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $193
  102462:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102467:	e9 e8 02 00 00       	jmp    102754 <__alltraps>

0010246c <vector194>:
.globl vector194
vector194:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $194
  10246e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102473:	e9 dc 02 00 00       	jmp    102754 <__alltraps>

00102478 <vector195>:
.globl vector195
vector195:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $195
  10247a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10247f:	e9 d0 02 00 00       	jmp    102754 <__alltraps>

00102484 <vector196>:
.globl vector196
vector196:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $196
  102486:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10248b:	e9 c4 02 00 00       	jmp    102754 <__alltraps>

00102490 <vector197>:
.globl vector197
vector197:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $197
  102492:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102497:	e9 b8 02 00 00       	jmp    102754 <__alltraps>

0010249c <vector198>:
.globl vector198
vector198:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $198
  10249e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1024a3:	e9 ac 02 00 00       	jmp    102754 <__alltraps>

001024a8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $199
  1024aa:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1024af:	e9 a0 02 00 00       	jmp    102754 <__alltraps>

001024b4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $200
  1024b6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1024bb:	e9 94 02 00 00       	jmp    102754 <__alltraps>

001024c0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $201
  1024c2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1024c7:	e9 88 02 00 00       	jmp    102754 <__alltraps>

001024cc <vector202>:
.globl vector202
vector202:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $202
  1024ce:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1024d3:	e9 7c 02 00 00       	jmp    102754 <__alltraps>

001024d8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $203
  1024da:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1024df:	e9 70 02 00 00       	jmp    102754 <__alltraps>

001024e4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $204
  1024e6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1024eb:	e9 64 02 00 00       	jmp    102754 <__alltraps>

001024f0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $205
  1024f2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1024f7:	e9 58 02 00 00       	jmp    102754 <__alltraps>

001024fc <vector206>:
.globl vector206
vector206:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $206
  1024fe:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102503:	e9 4c 02 00 00       	jmp    102754 <__alltraps>

00102508 <vector207>:
.globl vector207
vector207:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $207
  10250a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10250f:	e9 40 02 00 00       	jmp    102754 <__alltraps>

00102514 <vector208>:
.globl vector208
vector208:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $208
  102516:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10251b:	e9 34 02 00 00       	jmp    102754 <__alltraps>

00102520 <vector209>:
.globl vector209
vector209:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $209
  102522:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102527:	e9 28 02 00 00       	jmp    102754 <__alltraps>

0010252c <vector210>:
.globl vector210
vector210:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $210
  10252e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102533:	e9 1c 02 00 00       	jmp    102754 <__alltraps>

00102538 <vector211>:
.globl vector211
vector211:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $211
  10253a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10253f:	e9 10 02 00 00       	jmp    102754 <__alltraps>

00102544 <vector212>:
.globl vector212
vector212:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $212
  102546:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10254b:	e9 04 02 00 00       	jmp    102754 <__alltraps>

00102550 <vector213>:
.globl vector213
vector213:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $213
  102552:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102557:	e9 f8 01 00 00       	jmp    102754 <__alltraps>

0010255c <vector214>:
.globl vector214
vector214:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $214
  10255e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102563:	e9 ec 01 00 00       	jmp    102754 <__alltraps>

00102568 <vector215>:
.globl vector215
vector215:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $215
  10256a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10256f:	e9 e0 01 00 00       	jmp    102754 <__alltraps>

00102574 <vector216>:
.globl vector216
vector216:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $216
  102576:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10257b:	e9 d4 01 00 00       	jmp    102754 <__alltraps>

00102580 <vector217>:
.globl vector217
vector217:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $217
  102582:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102587:	e9 c8 01 00 00       	jmp    102754 <__alltraps>

0010258c <vector218>:
.globl vector218
vector218:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $218
  10258e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102593:	e9 bc 01 00 00       	jmp    102754 <__alltraps>

00102598 <vector219>:
.globl vector219
vector219:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $219
  10259a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10259f:	e9 b0 01 00 00       	jmp    102754 <__alltraps>

001025a4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $220
  1025a6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1025ab:	e9 a4 01 00 00       	jmp    102754 <__alltraps>

001025b0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $221
  1025b2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1025b7:	e9 98 01 00 00       	jmp    102754 <__alltraps>

001025bc <vector222>:
.globl vector222
vector222:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $222
  1025be:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1025c3:	e9 8c 01 00 00       	jmp    102754 <__alltraps>

001025c8 <vector223>:
.globl vector223
vector223:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $223
  1025ca:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1025cf:	e9 80 01 00 00       	jmp    102754 <__alltraps>

001025d4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $224
  1025d6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1025db:	e9 74 01 00 00       	jmp    102754 <__alltraps>

001025e0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $225
  1025e2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1025e7:	e9 68 01 00 00       	jmp    102754 <__alltraps>

001025ec <vector226>:
.globl vector226
vector226:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $226
  1025ee:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1025f3:	e9 5c 01 00 00       	jmp    102754 <__alltraps>

001025f8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $227
  1025fa:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1025ff:	e9 50 01 00 00       	jmp    102754 <__alltraps>

00102604 <vector228>:
.globl vector228
vector228:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $228
  102606:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10260b:	e9 44 01 00 00       	jmp    102754 <__alltraps>

00102610 <vector229>:
.globl vector229
vector229:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $229
  102612:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102617:	e9 38 01 00 00       	jmp    102754 <__alltraps>

0010261c <vector230>:
.globl vector230
vector230:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $230
  10261e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102623:	e9 2c 01 00 00       	jmp    102754 <__alltraps>

00102628 <vector231>:
.globl vector231
vector231:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $231
  10262a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10262f:	e9 20 01 00 00       	jmp    102754 <__alltraps>

00102634 <vector232>:
.globl vector232
vector232:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $232
  102636:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10263b:	e9 14 01 00 00       	jmp    102754 <__alltraps>

00102640 <vector233>:
.globl vector233
vector233:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $233
  102642:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102647:	e9 08 01 00 00       	jmp    102754 <__alltraps>

0010264c <vector234>:
.globl vector234
vector234:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $234
  10264e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102653:	e9 fc 00 00 00       	jmp    102754 <__alltraps>

00102658 <vector235>:
.globl vector235
vector235:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $235
  10265a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10265f:	e9 f0 00 00 00       	jmp    102754 <__alltraps>

00102664 <vector236>:
.globl vector236
vector236:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $236
  102666:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10266b:	e9 e4 00 00 00       	jmp    102754 <__alltraps>

00102670 <vector237>:
.globl vector237
vector237:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $237
  102672:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102677:	e9 d8 00 00 00       	jmp    102754 <__alltraps>

0010267c <vector238>:
.globl vector238
vector238:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $238
  10267e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102683:	e9 cc 00 00 00       	jmp    102754 <__alltraps>

00102688 <vector239>:
.globl vector239
vector239:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $239
  10268a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10268f:	e9 c0 00 00 00       	jmp    102754 <__alltraps>

00102694 <vector240>:
.globl vector240
vector240:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $240
  102696:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10269b:	e9 b4 00 00 00       	jmp    102754 <__alltraps>

001026a0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $241
  1026a2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1026a7:	e9 a8 00 00 00       	jmp    102754 <__alltraps>

001026ac <vector242>:
.globl vector242
vector242:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $242
  1026ae:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1026b3:	e9 9c 00 00 00       	jmp    102754 <__alltraps>

001026b8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $243
  1026ba:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1026bf:	e9 90 00 00 00       	jmp    102754 <__alltraps>

001026c4 <vector244>:
.globl vector244
vector244:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $244
  1026c6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1026cb:	e9 84 00 00 00       	jmp    102754 <__alltraps>

001026d0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $245
  1026d2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1026d7:	e9 78 00 00 00       	jmp    102754 <__alltraps>

001026dc <vector246>:
.globl vector246
vector246:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $246
  1026de:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1026e3:	e9 6c 00 00 00       	jmp    102754 <__alltraps>

001026e8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $247
  1026ea:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1026ef:	e9 60 00 00 00       	jmp    102754 <__alltraps>

001026f4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $248
  1026f6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1026fb:	e9 54 00 00 00       	jmp    102754 <__alltraps>

00102700 <vector249>:
.globl vector249
vector249:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $249
  102702:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102707:	e9 48 00 00 00       	jmp    102754 <__alltraps>

0010270c <vector250>:
.globl vector250
vector250:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $250
  10270e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102713:	e9 3c 00 00 00       	jmp    102754 <__alltraps>

00102718 <vector251>:
.globl vector251
vector251:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $251
  10271a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10271f:	e9 30 00 00 00       	jmp    102754 <__alltraps>

00102724 <vector252>:
.globl vector252
vector252:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $252
  102726:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10272b:	e9 24 00 00 00       	jmp    102754 <__alltraps>

00102730 <vector253>:
.globl vector253
vector253:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $253
  102732:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102737:	e9 18 00 00 00       	jmp    102754 <__alltraps>

0010273c <vector254>:
.globl vector254
vector254:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $254
  10273e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102743:	e9 0c 00 00 00       	jmp    102754 <__alltraps>

00102748 <vector255>:
.globl vector255
vector255:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $255
  10274a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10274f:	e9 00 00 00 00       	jmp    102754 <__alltraps>

00102754 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102754:	1e                   	push   %ds
    pushl %es
  102755:	06                   	push   %es
    pushl %fs
  102756:	0f a0                	push   %fs
    pushl %gs
  102758:	0f a8                	push   %gs
    pushal
  10275a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10275b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102760:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102762:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102764:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102765:	e8 60 f5 ff ff       	call   101cca <trap>

    # pop the pushed stack pointer
    popl %esp
  10276a:	5c                   	pop    %esp

0010276b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10276b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10276c:	0f a9                	pop    %gs
    popl %fs
  10276e:	0f a1                	pop    %fs
    popl %es
  102770:	07                   	pop    %es
    popl %ds
  102771:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102772:	83 c4 08             	add    $0x8,%esp
    iret
  102775:	cf                   	iret   

00102776 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102776:	55                   	push   %ebp
  102777:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102779:	8b 45 08             	mov    0x8(%ebp),%eax
  10277c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10277f:	b8 23 00 00 00       	mov    $0x23,%eax
  102784:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102786:	b8 23 00 00 00       	mov    $0x23,%eax
  10278b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10278d:	b8 10 00 00 00       	mov    $0x10,%eax
  102792:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102794:	b8 10 00 00 00       	mov    $0x10,%eax
  102799:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10279b:	b8 10 00 00 00       	mov    $0x10,%eax
  1027a0:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1027a2:	ea a9 27 10 00 08 00 	ljmp   $0x8,$0x1027a9
}
  1027a9:	90                   	nop
  1027aa:	5d                   	pop    %ebp
  1027ab:	c3                   	ret    

001027ac <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027ac:	f3 0f 1e fb          	endbr32 
  1027b0:	55                   	push   %ebp
  1027b1:	89 e5                	mov    %esp,%ebp
  1027b3:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027b6:	b8 20 09 11 00       	mov    $0x110920,%eax
  1027bb:	05 00 04 00 00       	add    $0x400,%eax
  1027c0:	a3 a4 08 11 00       	mov    %eax,0x1108a4
    ts.ts_ss0 = KERNEL_DS;
  1027c5:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  1027cc:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1027ce:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1027d5:	68 00 
  1027d7:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1027dc:	0f b7 c0             	movzwl %ax,%eax
  1027df:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1027e5:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  1027ea:	c1 e8 10             	shr    $0x10,%eax
  1027ed:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1027f2:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1027f9:	24 f0                	and    $0xf0,%al
  1027fb:	0c 09                	or     $0x9,%al
  1027fd:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102802:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102809:	0c 10                	or     $0x10,%al
  10280b:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102810:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102817:	24 9f                	and    $0x9f,%al
  102819:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  10281e:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102825:	0c 80                	or     $0x80,%al
  102827:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  10282c:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102833:	24 f0                	and    $0xf0,%al
  102835:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  10283a:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102841:	24 ef                	and    $0xef,%al
  102843:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102848:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10284f:	24 df                	and    $0xdf,%al
  102851:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102856:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10285d:	0c 40                	or     $0x40,%al
  10285f:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102864:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10286b:	24 7f                	and    $0x7f,%al
  10286d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102872:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102877:	c1 e8 18             	shr    $0x18,%eax
  10287a:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  10287f:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102886:	24 ef                	and    $0xef,%al
  102888:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10288d:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102894:	e8 dd fe ff ff       	call   102776 <lgdt>
  102899:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10289f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1028a3:	0f 00 d8             	ltr    %ax
}
  1028a6:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  1028a7:	90                   	nop
  1028a8:	c9                   	leave  
  1028a9:	c3                   	ret    

001028aa <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1028aa:	f3 0f 1e fb          	endbr32 
  1028ae:	55                   	push   %ebp
  1028af:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1028b1:	e8 f6 fe ff ff       	call   1027ac <gdt_init>
}
  1028b6:	90                   	nop
  1028b7:	5d                   	pop    %ebp
  1028b8:	c3                   	ret    

001028b9 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1028b9:	f3 0f 1e fb          	endbr32 
  1028bd:	55                   	push   %ebp
  1028be:	89 e5                	mov    %esp,%ebp
  1028c0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1028ca:	eb 03                	jmp    1028cf <strlen+0x16>
        cnt ++;
  1028cc:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d2:	8d 50 01             	lea    0x1(%eax),%edx
  1028d5:	89 55 08             	mov    %edx,0x8(%ebp)
  1028d8:	0f b6 00             	movzbl (%eax),%eax
  1028db:	84 c0                	test   %al,%al
  1028dd:	75 ed                	jne    1028cc <strlen+0x13>
    }
    return cnt;
  1028df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1028e2:	c9                   	leave  
  1028e3:	c3                   	ret    

001028e4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1028e4:	f3 0f 1e fb          	endbr32 
  1028e8:	55                   	push   %ebp
  1028e9:	89 e5                	mov    %esp,%ebp
  1028eb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1028f5:	eb 03                	jmp    1028fa <strnlen+0x16>
        cnt ++;
  1028f7:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1028fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102900:	73 10                	jae    102912 <strnlen+0x2e>
  102902:	8b 45 08             	mov    0x8(%ebp),%eax
  102905:	8d 50 01             	lea    0x1(%eax),%edx
  102908:	89 55 08             	mov    %edx,0x8(%ebp)
  10290b:	0f b6 00             	movzbl (%eax),%eax
  10290e:	84 c0                	test   %al,%al
  102910:	75 e5                	jne    1028f7 <strnlen+0x13>
    }
    return cnt;
  102912:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102915:	c9                   	leave  
  102916:	c3                   	ret    

00102917 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102917:	f3 0f 1e fb          	endbr32 
  10291b:	55                   	push   %ebp
  10291c:	89 e5                	mov    %esp,%ebp
  10291e:	57                   	push   %edi
  10291f:	56                   	push   %esi
  102920:	83 ec 20             	sub    $0x20,%esp
  102923:	8b 45 08             	mov    0x8(%ebp),%eax
  102926:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102929:	8b 45 0c             	mov    0xc(%ebp),%eax
  10292c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10292f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102935:	89 d1                	mov    %edx,%ecx
  102937:	89 c2                	mov    %eax,%edx
  102939:	89 ce                	mov    %ecx,%esi
  10293b:	89 d7                	mov    %edx,%edi
  10293d:	ac                   	lods   %ds:(%esi),%al
  10293e:	aa                   	stos   %al,%es:(%edi)
  10293f:	84 c0                	test   %al,%al
  102941:	75 fa                	jne    10293d <strcpy+0x26>
  102943:	89 fa                	mov    %edi,%edx
  102945:	89 f1                	mov    %esi,%ecx
  102947:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10294a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10294d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102950:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102953:	83 c4 20             	add    $0x20,%esp
  102956:	5e                   	pop    %esi
  102957:	5f                   	pop    %edi
  102958:	5d                   	pop    %ebp
  102959:	c3                   	ret    

0010295a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10295a:	f3 0f 1e fb          	endbr32 
  10295e:	55                   	push   %ebp
  10295f:	89 e5                	mov    %esp,%ebp
  102961:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102964:	8b 45 08             	mov    0x8(%ebp),%eax
  102967:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10296a:	eb 1e                	jmp    10298a <strncpy+0x30>
        if ((*p = *src) != '\0') {
  10296c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296f:	0f b6 10             	movzbl (%eax),%edx
  102972:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102975:	88 10                	mov    %dl,(%eax)
  102977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10297a:	0f b6 00             	movzbl (%eax),%eax
  10297d:	84 c0                	test   %al,%al
  10297f:	74 03                	je     102984 <strncpy+0x2a>
            src ++;
  102981:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102984:	ff 45 fc             	incl   -0x4(%ebp)
  102987:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  10298a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10298e:	75 dc                	jne    10296c <strncpy+0x12>
    }
    return dst;
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102993:	c9                   	leave  
  102994:	c3                   	ret    

00102995 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102995:	f3 0f 1e fb          	endbr32 
  102999:	55                   	push   %ebp
  10299a:	89 e5                	mov    %esp,%ebp
  10299c:	57                   	push   %edi
  10299d:	56                   	push   %esi
  10299e:	83 ec 20             	sub    $0x20,%esp
  1029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1029ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b3:	89 d1                	mov    %edx,%ecx
  1029b5:	89 c2                	mov    %eax,%edx
  1029b7:	89 ce                	mov    %ecx,%esi
  1029b9:	89 d7                	mov    %edx,%edi
  1029bb:	ac                   	lods   %ds:(%esi),%al
  1029bc:	ae                   	scas   %es:(%edi),%al
  1029bd:	75 08                	jne    1029c7 <strcmp+0x32>
  1029bf:	84 c0                	test   %al,%al
  1029c1:	75 f8                	jne    1029bb <strcmp+0x26>
  1029c3:	31 c0                	xor    %eax,%eax
  1029c5:	eb 04                	jmp    1029cb <strcmp+0x36>
  1029c7:	19 c0                	sbb    %eax,%eax
  1029c9:	0c 01                	or     $0x1,%al
  1029cb:	89 fa                	mov    %edi,%edx
  1029cd:	89 f1                	mov    %esi,%ecx
  1029cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1029d2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1029d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1029d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1029db:	83 c4 20             	add    $0x20,%esp
  1029de:	5e                   	pop    %esi
  1029df:	5f                   	pop    %edi
  1029e0:	5d                   	pop    %ebp
  1029e1:	c3                   	ret    

001029e2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1029e2:	f3 0f 1e fb          	endbr32 
  1029e6:	55                   	push   %ebp
  1029e7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029e9:	eb 09                	jmp    1029f4 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1029eb:	ff 4d 10             	decl   0x10(%ebp)
  1029ee:	ff 45 08             	incl   0x8(%ebp)
  1029f1:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f8:	74 1a                	je     102a14 <strncmp+0x32>
  1029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1029fd:	0f b6 00             	movzbl (%eax),%eax
  102a00:	84 c0                	test   %al,%al
  102a02:	74 10                	je     102a14 <strncmp+0x32>
  102a04:	8b 45 08             	mov    0x8(%ebp),%eax
  102a07:	0f b6 10             	movzbl (%eax),%edx
  102a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a0d:	0f b6 00             	movzbl (%eax),%eax
  102a10:	38 c2                	cmp    %al,%dl
  102a12:	74 d7                	je     1029eb <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102a14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a18:	74 18                	je     102a32 <strncmp+0x50>
  102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1d:	0f b6 00             	movzbl (%eax),%eax
  102a20:	0f b6 d0             	movzbl %al,%edx
  102a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a26:	0f b6 00             	movzbl (%eax),%eax
  102a29:	0f b6 c0             	movzbl %al,%eax
  102a2c:	29 c2                	sub    %eax,%edx
  102a2e:	89 d0                	mov    %edx,%eax
  102a30:	eb 05                	jmp    102a37 <strncmp+0x55>
  102a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a37:	5d                   	pop    %ebp
  102a38:	c3                   	ret    

00102a39 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102a39:	f3 0f 1e fb          	endbr32 
  102a3d:	55                   	push   %ebp
  102a3e:	89 e5                	mov    %esp,%ebp
  102a40:	83 ec 04             	sub    $0x4,%esp
  102a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a46:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a49:	eb 13                	jmp    102a5e <strchr+0x25>
        if (*s == c) {
  102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4e:	0f b6 00             	movzbl (%eax),%eax
  102a51:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102a54:	75 05                	jne    102a5b <strchr+0x22>
            return (char *)s;
  102a56:	8b 45 08             	mov    0x8(%ebp),%eax
  102a59:	eb 12                	jmp    102a6d <strchr+0x34>
        }
        s ++;
  102a5b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a61:	0f b6 00             	movzbl (%eax),%eax
  102a64:	84 c0                	test   %al,%al
  102a66:	75 e3                	jne    102a4b <strchr+0x12>
    }
    return NULL;
  102a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a6d:	c9                   	leave  
  102a6e:	c3                   	ret    

00102a6f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102a6f:	f3 0f 1e fb          	endbr32 
  102a73:	55                   	push   %ebp
  102a74:	89 e5                	mov    %esp,%ebp
  102a76:	83 ec 04             	sub    $0x4,%esp
  102a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a7c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a7f:	eb 0e                	jmp    102a8f <strfind+0x20>
        if (*s == c) {
  102a81:	8b 45 08             	mov    0x8(%ebp),%eax
  102a84:	0f b6 00             	movzbl (%eax),%eax
  102a87:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102a8a:	74 0f                	je     102a9b <strfind+0x2c>
            break;
        }
        s ++;
  102a8c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a92:	0f b6 00             	movzbl (%eax),%eax
  102a95:	84 c0                	test   %al,%al
  102a97:	75 e8                	jne    102a81 <strfind+0x12>
  102a99:	eb 01                	jmp    102a9c <strfind+0x2d>
            break;
  102a9b:	90                   	nop
    }
    return (char *)s;
  102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a9f:	c9                   	leave  
  102aa0:	c3                   	ret    

00102aa1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102aa1:	f3 0f 1e fb          	endbr32 
  102aa5:	55                   	push   %ebp
  102aa6:	89 e5                	mov    %esp,%ebp
  102aa8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102ab2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102ab9:	eb 03                	jmp    102abe <strtol+0x1d>
        s ++;
  102abb:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102abe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac1:	0f b6 00             	movzbl (%eax),%eax
  102ac4:	3c 20                	cmp    $0x20,%al
  102ac6:	74 f3                	je     102abb <strtol+0x1a>
  102ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  102acb:	0f b6 00             	movzbl (%eax),%eax
  102ace:	3c 09                	cmp    $0x9,%al
  102ad0:	74 e9                	je     102abb <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad5:	0f b6 00             	movzbl (%eax),%eax
  102ad8:	3c 2b                	cmp    $0x2b,%al
  102ada:	75 05                	jne    102ae1 <strtol+0x40>
        s ++;
  102adc:	ff 45 08             	incl   0x8(%ebp)
  102adf:	eb 14                	jmp    102af5 <strtol+0x54>
    }
    else if (*s == '-') {
  102ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae4:	0f b6 00             	movzbl (%eax),%eax
  102ae7:	3c 2d                	cmp    $0x2d,%al
  102ae9:	75 0a                	jne    102af5 <strtol+0x54>
        s ++, neg = 1;
  102aeb:	ff 45 08             	incl   0x8(%ebp)
  102aee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102af5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102af9:	74 06                	je     102b01 <strtol+0x60>
  102afb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102aff:	75 22                	jne    102b23 <strtol+0x82>
  102b01:	8b 45 08             	mov    0x8(%ebp),%eax
  102b04:	0f b6 00             	movzbl (%eax),%eax
  102b07:	3c 30                	cmp    $0x30,%al
  102b09:	75 18                	jne    102b23 <strtol+0x82>
  102b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0e:	40                   	inc    %eax
  102b0f:	0f b6 00             	movzbl (%eax),%eax
  102b12:	3c 78                	cmp    $0x78,%al
  102b14:	75 0d                	jne    102b23 <strtol+0x82>
        s += 2, base = 16;
  102b16:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102b1a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102b21:	eb 29                	jmp    102b4c <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102b23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b27:	75 16                	jne    102b3f <strtol+0x9e>
  102b29:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2c:	0f b6 00             	movzbl (%eax),%eax
  102b2f:	3c 30                	cmp    $0x30,%al
  102b31:	75 0c                	jne    102b3f <strtol+0x9e>
        s ++, base = 8;
  102b33:	ff 45 08             	incl   0x8(%ebp)
  102b36:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102b3d:	eb 0d                	jmp    102b4c <strtol+0xab>
    }
    else if (base == 0) {
  102b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b43:	75 07                	jne    102b4c <strtol+0xab>
        base = 10;
  102b45:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4f:	0f b6 00             	movzbl (%eax),%eax
  102b52:	3c 2f                	cmp    $0x2f,%al
  102b54:	7e 1b                	jle    102b71 <strtol+0xd0>
  102b56:	8b 45 08             	mov    0x8(%ebp),%eax
  102b59:	0f b6 00             	movzbl (%eax),%eax
  102b5c:	3c 39                	cmp    $0x39,%al
  102b5e:	7f 11                	jg     102b71 <strtol+0xd0>
            dig = *s - '0';
  102b60:	8b 45 08             	mov    0x8(%ebp),%eax
  102b63:	0f b6 00             	movzbl (%eax),%eax
  102b66:	0f be c0             	movsbl %al,%eax
  102b69:	83 e8 30             	sub    $0x30,%eax
  102b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b6f:	eb 48                	jmp    102bb9 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102b71:	8b 45 08             	mov    0x8(%ebp),%eax
  102b74:	0f b6 00             	movzbl (%eax),%eax
  102b77:	3c 60                	cmp    $0x60,%al
  102b79:	7e 1b                	jle    102b96 <strtol+0xf5>
  102b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7e:	0f b6 00             	movzbl (%eax),%eax
  102b81:	3c 7a                	cmp    $0x7a,%al
  102b83:	7f 11                	jg     102b96 <strtol+0xf5>
            dig = *s - 'a' + 10;
  102b85:	8b 45 08             	mov    0x8(%ebp),%eax
  102b88:	0f b6 00             	movzbl (%eax),%eax
  102b8b:	0f be c0             	movsbl %al,%eax
  102b8e:	83 e8 57             	sub    $0x57,%eax
  102b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b94:	eb 23                	jmp    102bb9 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102b96:	8b 45 08             	mov    0x8(%ebp),%eax
  102b99:	0f b6 00             	movzbl (%eax),%eax
  102b9c:	3c 40                	cmp    $0x40,%al
  102b9e:	7e 3b                	jle    102bdb <strtol+0x13a>
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	0f b6 00             	movzbl (%eax),%eax
  102ba6:	3c 5a                	cmp    $0x5a,%al
  102ba8:	7f 31                	jg     102bdb <strtol+0x13a>
            dig = *s - 'A' + 10;
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	0f b6 00             	movzbl (%eax),%eax
  102bb0:	0f be c0             	movsbl %al,%eax
  102bb3:	83 e8 37             	sub    $0x37,%eax
  102bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bbc:	3b 45 10             	cmp    0x10(%ebp),%eax
  102bbf:	7d 19                	jge    102bda <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102bc1:	ff 45 08             	incl   0x8(%ebp)
  102bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bc7:	0f af 45 10          	imul   0x10(%ebp),%eax
  102bcb:	89 c2                	mov    %eax,%edx
  102bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd0:	01 d0                	add    %edx,%eax
  102bd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102bd5:	e9 72 ff ff ff       	jmp    102b4c <strtol+0xab>
            break;
  102bda:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bdf:	74 08                	je     102be9 <strtol+0x148>
        *endptr = (char *) s;
  102be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102be4:	8b 55 08             	mov    0x8(%ebp),%edx
  102be7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102bed:	74 07                	je     102bf6 <strtol+0x155>
  102bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bf2:	f7 d8                	neg    %eax
  102bf4:	eb 03                	jmp    102bf9 <strtol+0x158>
  102bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102bf9:	c9                   	leave  
  102bfa:	c3                   	ret    

00102bfb <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102bfb:	f3 0f 1e fb          	endbr32 
  102bff:	55                   	push   %ebp
  102c00:	89 e5                	mov    %esp,%ebp
  102c02:	57                   	push   %edi
  102c03:	83 ec 24             	sub    $0x24,%esp
  102c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c09:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102c0c:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102c10:	8b 45 08             	mov    0x8(%ebp),%eax
  102c13:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102c16:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102c19:	8b 45 10             	mov    0x10(%ebp),%eax
  102c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102c1f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102c22:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102c26:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102c29:	89 d7                	mov    %edx,%edi
  102c2b:	f3 aa                	rep stos %al,%es:(%edi)
  102c2d:	89 fa                	mov    %edi,%edx
  102c2f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c32:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102c35:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102c38:	83 c4 24             	add    $0x24,%esp
  102c3b:	5f                   	pop    %edi
  102c3c:	5d                   	pop    %ebp
  102c3d:	c3                   	ret    

00102c3e <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102c3e:	f3 0f 1e fb          	endbr32 
  102c42:	55                   	push   %ebp
  102c43:	89 e5                	mov    %esp,%ebp
  102c45:	57                   	push   %edi
  102c46:	56                   	push   %esi
  102c47:	53                   	push   %ebx
  102c48:	83 ec 30             	sub    $0x30,%esp
  102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c57:	8b 45 10             	mov    0x10(%ebp),%eax
  102c5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102c63:	73 42                	jae    102ca7 <memmove+0x69>
  102c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c7a:	c1 e8 02             	shr    $0x2,%eax
  102c7d:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102c7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c85:	89 d7                	mov    %edx,%edi
  102c87:	89 c6                	mov    %eax,%esi
  102c89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102c8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102c8e:	83 e1 03             	and    $0x3,%ecx
  102c91:	74 02                	je     102c95 <memmove+0x57>
  102c93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c95:	89 f0                	mov    %esi,%eax
  102c97:	89 fa                	mov    %edi,%edx
  102c99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102c9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102ca5:	eb 36                	jmp    102cdd <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102caa:	8d 50 ff             	lea    -0x1(%eax),%edx
  102cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cb0:	01 c2                	add    %eax,%edx
  102cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cb5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cbb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cc1:	89 c1                	mov    %eax,%ecx
  102cc3:	89 d8                	mov    %ebx,%eax
  102cc5:	89 d6                	mov    %edx,%esi
  102cc7:	89 c7                	mov    %eax,%edi
  102cc9:	fd                   	std    
  102cca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ccc:	fc                   	cld    
  102ccd:	89 f8                	mov    %edi,%eax
  102ccf:	89 f2                	mov    %esi,%edx
  102cd1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102cd4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102cd7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102cdd:	83 c4 30             	add    $0x30,%esp
  102ce0:	5b                   	pop    %ebx
  102ce1:	5e                   	pop    %esi
  102ce2:	5f                   	pop    %edi
  102ce3:	5d                   	pop    %ebp
  102ce4:	c3                   	ret    

00102ce5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ce5:	f3 0f 1e fb          	endbr32 
  102ce9:	55                   	push   %ebp
  102cea:	89 e5                	mov    %esp,%ebp
  102cec:	57                   	push   %edi
  102ced:	56                   	push   %esi
  102cee:	83 ec 20             	sub    $0x20,%esp
  102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  102d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d06:	c1 e8 02             	shr    $0x2,%eax
  102d09:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d11:	89 d7                	mov    %edx,%edi
  102d13:	89 c6                	mov    %eax,%esi
  102d15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d17:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102d1a:	83 e1 03             	and    $0x3,%ecx
  102d1d:	74 02                	je     102d21 <memcpy+0x3c>
  102d1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d21:	89 f0                	mov    %esi,%eax
  102d23:	89 fa                	mov    %edi,%edx
  102d25:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102d31:	83 c4 20             	add    $0x20,%esp
  102d34:	5e                   	pop    %esi
  102d35:	5f                   	pop    %edi
  102d36:	5d                   	pop    %ebp
  102d37:	c3                   	ret    

00102d38 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102d38:	f3 0f 1e fb          	endbr32 
  102d3c:	55                   	push   %ebp
  102d3d:	89 e5                	mov    %esp,%ebp
  102d3f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102d42:	8b 45 08             	mov    0x8(%ebp),%eax
  102d45:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102d4e:	eb 2e                	jmp    102d7e <memcmp+0x46>
        if (*s1 != *s2) {
  102d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d53:	0f b6 10             	movzbl (%eax),%edx
  102d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d59:	0f b6 00             	movzbl (%eax),%eax
  102d5c:	38 c2                	cmp    %al,%dl
  102d5e:	74 18                	je     102d78 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d63:	0f b6 00             	movzbl (%eax),%eax
  102d66:	0f b6 d0             	movzbl %al,%edx
  102d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d6c:	0f b6 00             	movzbl (%eax),%eax
  102d6f:	0f b6 c0             	movzbl %al,%eax
  102d72:	29 c2                	sub    %eax,%edx
  102d74:	89 d0                	mov    %edx,%eax
  102d76:	eb 18                	jmp    102d90 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  102d78:	ff 45 fc             	incl   -0x4(%ebp)
  102d7b:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  102d81:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d84:	89 55 10             	mov    %edx,0x10(%ebp)
  102d87:	85 c0                	test   %eax,%eax
  102d89:	75 c5                	jne    102d50 <memcmp+0x18>
    }
    return 0;
  102d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d90:	c9                   	leave  
  102d91:	c3                   	ret    

00102d92 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102d92:	f3 0f 1e fb          	endbr32 
  102d96:	55                   	push   %ebp
  102d97:	89 e5                	mov    %esp,%ebp
  102d99:	83 ec 58             	sub    $0x58,%esp
  102d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  102d9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102da2:	8b 45 14             	mov    0x14(%ebp),%eax
  102da5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102da8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102dab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102dae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102db1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102db4:	8b 45 18             	mov    0x18(%ebp),%eax
  102db7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102dc3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102dd0:	74 1c                	je     102dee <printnum+0x5c>
  102dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  102dda:	f7 75 e4             	divl   -0x1c(%ebp)
  102ddd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de3:	ba 00 00 00 00       	mov    $0x0,%edx
  102de8:	f7 75 e4             	divl   -0x1c(%ebp)
  102deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102df4:	f7 75 e4             	divl   -0x1c(%ebp)
  102df7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102dfa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e03:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e06:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e0c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102e0f:	8b 45 18             	mov    0x18(%ebp),%eax
  102e12:	ba 00 00 00 00       	mov    $0x0,%edx
  102e17:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102e1a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102e1d:	19 d1                	sbb    %edx,%ecx
  102e1f:	72 4c                	jb     102e6d <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  102e21:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e27:	8b 45 20             	mov    0x20(%ebp),%eax
  102e2a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102e2e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e32:	8b 45 18             	mov    0x18(%ebp),%eax
  102e35:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e43:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e51:	89 04 24             	mov    %eax,(%esp)
  102e54:	e8 39 ff ff ff       	call   102d92 <printnum>
  102e59:	eb 1b                	jmp    102e76 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e62:	8b 45 20             	mov    0x20(%ebp),%eax
  102e65:	89 04 24             	mov    %eax,(%esp)
  102e68:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6b:	ff d0                	call   *%eax
        while (-- width > 0)
  102e6d:	ff 4d 1c             	decl   0x1c(%ebp)
  102e70:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102e74:	7f e5                	jg     102e5b <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102e76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102e79:	05 b0 3b 10 00       	add    $0x103bb0,%eax
  102e7e:	0f b6 00             	movzbl (%eax),%eax
  102e81:	0f be c0             	movsbl %al,%eax
  102e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e87:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e8b:	89 04 24             	mov    %eax,(%esp)
  102e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e91:	ff d0                	call   *%eax
}
  102e93:	90                   	nop
  102e94:	c9                   	leave  
  102e95:	c3                   	ret    

00102e96 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102e96:	f3 0f 1e fb          	endbr32 
  102e9a:	55                   	push   %ebp
  102e9b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102e9d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ea1:	7e 14                	jle    102eb7 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea6:	8b 00                	mov    (%eax),%eax
  102ea8:	8d 48 08             	lea    0x8(%eax),%ecx
  102eab:	8b 55 08             	mov    0x8(%ebp),%edx
  102eae:	89 0a                	mov    %ecx,(%edx)
  102eb0:	8b 50 04             	mov    0x4(%eax),%edx
  102eb3:	8b 00                	mov    (%eax),%eax
  102eb5:	eb 30                	jmp    102ee7 <getuint+0x51>
    }
    else if (lflag) {
  102eb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ebb:	74 16                	je     102ed3 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec0:	8b 00                	mov    (%eax),%eax
  102ec2:	8d 48 04             	lea    0x4(%eax),%ecx
  102ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ec8:	89 0a                	mov    %ecx,(%edx)
  102eca:	8b 00                	mov    (%eax),%eax
  102ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  102ed1:	eb 14                	jmp    102ee7 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed6:	8b 00                	mov    (%eax),%eax
  102ed8:	8d 48 04             	lea    0x4(%eax),%ecx
  102edb:	8b 55 08             	mov    0x8(%ebp),%edx
  102ede:	89 0a                	mov    %ecx,(%edx)
  102ee0:	8b 00                	mov    (%eax),%eax
  102ee2:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ee7:	5d                   	pop    %ebp
  102ee8:	c3                   	ret    

00102ee9 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ee9:	f3 0f 1e fb          	endbr32 
  102eed:	55                   	push   %ebp
  102eee:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ef0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ef4:	7e 14                	jle    102f0a <getint+0x21>
        return va_arg(*ap, long long);
  102ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef9:	8b 00                	mov    (%eax),%eax
  102efb:	8d 48 08             	lea    0x8(%eax),%ecx
  102efe:	8b 55 08             	mov    0x8(%ebp),%edx
  102f01:	89 0a                	mov    %ecx,(%edx)
  102f03:	8b 50 04             	mov    0x4(%eax),%edx
  102f06:	8b 00                	mov    (%eax),%eax
  102f08:	eb 28                	jmp    102f32 <getint+0x49>
    }
    else if (lflag) {
  102f0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f0e:	74 12                	je     102f22 <getint+0x39>
        return va_arg(*ap, long);
  102f10:	8b 45 08             	mov    0x8(%ebp),%eax
  102f13:	8b 00                	mov    (%eax),%eax
  102f15:	8d 48 04             	lea    0x4(%eax),%ecx
  102f18:	8b 55 08             	mov    0x8(%ebp),%edx
  102f1b:	89 0a                	mov    %ecx,(%edx)
  102f1d:	8b 00                	mov    (%eax),%eax
  102f1f:	99                   	cltd   
  102f20:	eb 10                	jmp    102f32 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  102f22:	8b 45 08             	mov    0x8(%ebp),%eax
  102f25:	8b 00                	mov    (%eax),%eax
  102f27:	8d 48 04             	lea    0x4(%eax),%ecx
  102f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2d:	89 0a                	mov    %ecx,(%edx)
  102f2f:	8b 00                	mov    (%eax),%eax
  102f31:	99                   	cltd   
    }
}
  102f32:	5d                   	pop    %ebp
  102f33:	c3                   	ret    

00102f34 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102f34:	f3 0f 1e fb          	endbr32 
  102f38:	55                   	push   %ebp
  102f39:	89 e5                	mov    %esp,%ebp
  102f3b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102f3e:	8d 45 14             	lea    0x14(%ebp),%eax
  102f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f59:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5c:	89 04 24             	mov    %eax,(%esp)
  102f5f:	e8 03 00 00 00       	call   102f67 <vprintfmt>
    va_end(ap);
}
  102f64:	90                   	nop
  102f65:	c9                   	leave  
  102f66:	c3                   	ret    

00102f67 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102f67:	f3 0f 1e fb          	endbr32 
  102f6b:	55                   	push   %ebp
  102f6c:	89 e5                	mov    %esp,%ebp
  102f6e:	56                   	push   %esi
  102f6f:	53                   	push   %ebx
  102f70:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f73:	eb 17                	jmp    102f8c <vprintfmt+0x25>
            if (ch == '\0') {
  102f75:	85 db                	test   %ebx,%ebx
  102f77:	0f 84 c0 03 00 00    	je     10333d <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  102f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f84:	89 1c 24             	mov    %ebx,(%esp)
  102f87:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8a:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f8f:	8d 50 01             	lea    0x1(%eax),%edx
  102f92:	89 55 10             	mov    %edx,0x10(%ebp)
  102f95:	0f b6 00             	movzbl (%eax),%eax
  102f98:	0f b6 d8             	movzbl %al,%ebx
  102f9b:	83 fb 25             	cmp    $0x25,%ebx
  102f9e:	75 d5                	jne    102f75 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102fa0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102fa4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fae:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102fb1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fbb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc1:	8d 50 01             	lea    0x1(%eax),%edx
  102fc4:	89 55 10             	mov    %edx,0x10(%ebp)
  102fc7:	0f b6 00             	movzbl (%eax),%eax
  102fca:	0f b6 d8             	movzbl %al,%ebx
  102fcd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102fd0:	83 f8 55             	cmp    $0x55,%eax
  102fd3:	0f 87 38 03 00 00    	ja     103311 <vprintfmt+0x3aa>
  102fd9:	8b 04 85 d4 3b 10 00 	mov    0x103bd4(,%eax,4),%eax
  102fe0:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102fe3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102fe7:	eb d5                	jmp    102fbe <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102fe9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102fed:	eb cf                	jmp    102fbe <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102fef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ff6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ff9:	89 d0                	mov    %edx,%eax
  102ffb:	c1 e0 02             	shl    $0x2,%eax
  102ffe:	01 d0                	add    %edx,%eax
  103000:	01 c0                	add    %eax,%eax
  103002:	01 d8                	add    %ebx,%eax
  103004:	83 e8 30             	sub    $0x30,%eax
  103007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10300a:	8b 45 10             	mov    0x10(%ebp),%eax
  10300d:	0f b6 00             	movzbl (%eax),%eax
  103010:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103013:	83 fb 2f             	cmp    $0x2f,%ebx
  103016:	7e 38                	jle    103050 <vprintfmt+0xe9>
  103018:	83 fb 39             	cmp    $0x39,%ebx
  10301b:	7f 33                	jg     103050 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  10301d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103020:	eb d4                	jmp    102ff6 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103022:	8b 45 14             	mov    0x14(%ebp),%eax
  103025:	8d 50 04             	lea    0x4(%eax),%edx
  103028:	89 55 14             	mov    %edx,0x14(%ebp)
  10302b:	8b 00                	mov    (%eax),%eax
  10302d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103030:	eb 1f                	jmp    103051 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103032:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103036:	79 86                	jns    102fbe <vprintfmt+0x57>
                width = 0;
  103038:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10303f:	e9 7a ff ff ff       	jmp    102fbe <vprintfmt+0x57>

        case '#':
            altflag = 1;
  103044:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10304b:	e9 6e ff ff ff       	jmp    102fbe <vprintfmt+0x57>
            goto process_precision;
  103050:	90                   	nop

        process_precision:
            if (width < 0)
  103051:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103055:	0f 89 63 ff ff ff    	jns    102fbe <vprintfmt+0x57>
                width = precision, precision = -1;
  10305b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10305e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103061:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103068:	e9 51 ff ff ff       	jmp    102fbe <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10306d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103070:	e9 49 ff ff ff       	jmp    102fbe <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103075:	8b 45 14             	mov    0x14(%ebp),%eax
  103078:	8d 50 04             	lea    0x4(%eax),%edx
  10307b:	89 55 14             	mov    %edx,0x14(%ebp)
  10307e:	8b 00                	mov    (%eax),%eax
  103080:	8b 55 0c             	mov    0xc(%ebp),%edx
  103083:	89 54 24 04          	mov    %edx,0x4(%esp)
  103087:	89 04 24             	mov    %eax,(%esp)
  10308a:	8b 45 08             	mov    0x8(%ebp),%eax
  10308d:	ff d0                	call   *%eax
            break;
  10308f:	e9 a4 02 00 00       	jmp    103338 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103094:	8b 45 14             	mov    0x14(%ebp),%eax
  103097:	8d 50 04             	lea    0x4(%eax),%edx
  10309a:	89 55 14             	mov    %edx,0x14(%ebp)
  10309d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10309f:	85 db                	test   %ebx,%ebx
  1030a1:	79 02                	jns    1030a5 <vprintfmt+0x13e>
                err = -err;
  1030a3:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1030a5:	83 fb 06             	cmp    $0x6,%ebx
  1030a8:	7f 0b                	jg     1030b5 <vprintfmt+0x14e>
  1030aa:	8b 34 9d 94 3b 10 00 	mov    0x103b94(,%ebx,4),%esi
  1030b1:	85 f6                	test   %esi,%esi
  1030b3:	75 23                	jne    1030d8 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1030b5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1030b9:	c7 44 24 08 c1 3b 10 	movl   $0x103bc1,0x8(%esp)
  1030c0:	00 
  1030c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030cb:	89 04 24             	mov    %eax,(%esp)
  1030ce:	e8 61 fe ff ff       	call   102f34 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1030d3:	e9 60 02 00 00       	jmp    103338 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1030d8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1030dc:	c7 44 24 08 ca 3b 10 	movl   $0x103bca,0x8(%esp)
  1030e3:	00 
  1030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	89 04 24             	mov    %eax,(%esp)
  1030f1:	e8 3e fe ff ff       	call   102f34 <printfmt>
            break;
  1030f6:	e9 3d 02 00 00       	jmp    103338 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1030fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1030fe:	8d 50 04             	lea    0x4(%eax),%edx
  103101:	89 55 14             	mov    %edx,0x14(%ebp)
  103104:	8b 30                	mov    (%eax),%esi
  103106:	85 f6                	test   %esi,%esi
  103108:	75 05                	jne    10310f <vprintfmt+0x1a8>
                p = "(null)";
  10310a:	be cd 3b 10 00       	mov    $0x103bcd,%esi
            }
            if (width > 0 && padc != '-') {
  10310f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103113:	7e 76                	jle    10318b <vprintfmt+0x224>
  103115:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103119:	74 70                	je     10318b <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10311e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103122:	89 34 24             	mov    %esi,(%esp)
  103125:	e8 ba f7 ff ff       	call   1028e4 <strnlen>
  10312a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10312d:	29 c2                	sub    %eax,%edx
  10312f:	89 d0                	mov    %edx,%eax
  103131:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103134:	eb 16                	jmp    10314c <vprintfmt+0x1e5>
                    putch(padc, putdat);
  103136:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10313a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10313d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103141:	89 04 24             	mov    %eax,(%esp)
  103144:	8b 45 08             	mov    0x8(%ebp),%eax
  103147:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103149:	ff 4d e8             	decl   -0x18(%ebp)
  10314c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103150:	7f e4                	jg     103136 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103152:	eb 37                	jmp    10318b <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  103154:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103158:	74 1f                	je     103179 <vprintfmt+0x212>
  10315a:	83 fb 1f             	cmp    $0x1f,%ebx
  10315d:	7e 05                	jle    103164 <vprintfmt+0x1fd>
  10315f:	83 fb 7e             	cmp    $0x7e,%ebx
  103162:	7e 15                	jle    103179 <vprintfmt+0x212>
                    putch('?', putdat);
  103164:	8b 45 0c             	mov    0xc(%ebp),%eax
  103167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10316b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103172:	8b 45 08             	mov    0x8(%ebp),%eax
  103175:	ff d0                	call   *%eax
  103177:	eb 0f                	jmp    103188 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  103179:	8b 45 0c             	mov    0xc(%ebp),%eax
  10317c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103180:	89 1c 24             	mov    %ebx,(%esp)
  103183:	8b 45 08             	mov    0x8(%ebp),%eax
  103186:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103188:	ff 4d e8             	decl   -0x18(%ebp)
  10318b:	89 f0                	mov    %esi,%eax
  10318d:	8d 70 01             	lea    0x1(%eax),%esi
  103190:	0f b6 00             	movzbl (%eax),%eax
  103193:	0f be d8             	movsbl %al,%ebx
  103196:	85 db                	test   %ebx,%ebx
  103198:	74 27                	je     1031c1 <vprintfmt+0x25a>
  10319a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10319e:	78 b4                	js     103154 <vprintfmt+0x1ed>
  1031a0:	ff 4d e4             	decl   -0x1c(%ebp)
  1031a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031a7:	79 ab                	jns    103154 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1031a9:	eb 16                	jmp    1031c1 <vprintfmt+0x25a>
                putch(' ', putdat);
  1031ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bc:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1031be:	ff 4d e8             	decl   -0x18(%ebp)
  1031c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031c5:	7f e4                	jg     1031ab <vprintfmt+0x244>
            }
            break;
  1031c7:	e9 6c 01 00 00       	jmp    103338 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1031cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031d3:	8d 45 14             	lea    0x14(%ebp),%eax
  1031d6:	89 04 24             	mov    %eax,(%esp)
  1031d9:	e8 0b fd ff ff       	call   102ee9 <getint>
  1031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031ea:	85 d2                	test   %edx,%edx
  1031ec:	79 26                	jns    103214 <vprintfmt+0x2ad>
                putch('-', putdat);
  1031ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ff:	ff d0                	call   *%eax
                num = -(long long)num;
  103201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103207:	f7 d8                	neg    %eax
  103209:	83 d2 00             	adc    $0x0,%edx
  10320c:	f7 da                	neg    %edx
  10320e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103211:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103214:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10321b:	e9 a8 00 00 00       	jmp    1032c8 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103223:	89 44 24 04          	mov    %eax,0x4(%esp)
  103227:	8d 45 14             	lea    0x14(%ebp),%eax
  10322a:	89 04 24             	mov    %eax,(%esp)
  10322d:	e8 64 fc ff ff       	call   102e96 <getuint>
  103232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103235:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103238:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10323f:	e9 84 00 00 00       	jmp    1032c8 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10324b:	8d 45 14             	lea    0x14(%ebp),%eax
  10324e:	89 04 24             	mov    %eax,(%esp)
  103251:	e8 40 fc ff ff       	call   102e96 <getuint>
  103256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103259:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10325c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103263:	eb 63                	jmp    1032c8 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  103265:	8b 45 0c             	mov    0xc(%ebp),%eax
  103268:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103273:	8b 45 08             	mov    0x8(%ebp),%eax
  103276:	ff d0                	call   *%eax
            putch('x', putdat);
  103278:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10327f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103286:	8b 45 08             	mov    0x8(%ebp),%eax
  103289:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10328b:	8b 45 14             	mov    0x14(%ebp),%eax
  10328e:	8d 50 04             	lea    0x4(%eax),%edx
  103291:	89 55 14             	mov    %edx,0x14(%ebp)
  103294:	8b 00                	mov    (%eax),%eax
  103296:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103299:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1032a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1032a7:	eb 1f                	jmp    1032c8 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1032a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b0:	8d 45 14             	lea    0x14(%ebp),%eax
  1032b3:	89 04 24             	mov    %eax,(%esp)
  1032b6:	e8 db fb ff ff       	call   102e96 <getuint>
  1032bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032be:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1032c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1032c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1032cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032cf:	89 54 24 18          	mov    %edx,0x18(%esp)
  1032d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1032d6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1032da:	89 44 24 10          	mov    %eax,0x10(%esp)
  1032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1032ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f6:	89 04 24             	mov    %eax,(%esp)
  1032f9:	e8 94 fa ff ff       	call   102d92 <printnum>
            break;
  1032fe:	eb 38                	jmp    103338 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103300:	8b 45 0c             	mov    0xc(%ebp),%eax
  103303:	89 44 24 04          	mov    %eax,0x4(%esp)
  103307:	89 1c 24             	mov    %ebx,(%esp)
  10330a:	8b 45 08             	mov    0x8(%ebp),%eax
  10330d:	ff d0                	call   *%eax
            break;
  10330f:	eb 27                	jmp    103338 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103311:	8b 45 0c             	mov    0xc(%ebp),%eax
  103314:	89 44 24 04          	mov    %eax,0x4(%esp)
  103318:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10331f:	8b 45 08             	mov    0x8(%ebp),%eax
  103322:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103324:	ff 4d 10             	decl   0x10(%ebp)
  103327:	eb 03                	jmp    10332c <vprintfmt+0x3c5>
  103329:	ff 4d 10             	decl   0x10(%ebp)
  10332c:	8b 45 10             	mov    0x10(%ebp),%eax
  10332f:	48                   	dec    %eax
  103330:	0f b6 00             	movzbl (%eax),%eax
  103333:	3c 25                	cmp    $0x25,%al
  103335:	75 f2                	jne    103329 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  103337:	90                   	nop
    while (1) {
  103338:	e9 36 fc ff ff       	jmp    102f73 <vprintfmt+0xc>
                return;
  10333d:	90                   	nop
        }
    }
}
  10333e:	83 c4 40             	add    $0x40,%esp
  103341:	5b                   	pop    %ebx
  103342:	5e                   	pop    %esi
  103343:	5d                   	pop    %ebp
  103344:	c3                   	ret    

00103345 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103345:	f3 0f 1e fb          	endbr32 
  103349:	55                   	push   %ebp
  10334a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10334c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334f:	8b 40 08             	mov    0x8(%eax),%eax
  103352:	8d 50 01             	lea    0x1(%eax),%edx
  103355:	8b 45 0c             	mov    0xc(%ebp),%eax
  103358:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10335b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335e:	8b 10                	mov    (%eax),%edx
  103360:	8b 45 0c             	mov    0xc(%ebp),%eax
  103363:	8b 40 04             	mov    0x4(%eax),%eax
  103366:	39 c2                	cmp    %eax,%edx
  103368:	73 12                	jae    10337c <sprintputch+0x37>
        *b->buf ++ = ch;
  10336a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336d:	8b 00                	mov    (%eax),%eax
  10336f:	8d 48 01             	lea    0x1(%eax),%ecx
  103372:	8b 55 0c             	mov    0xc(%ebp),%edx
  103375:	89 0a                	mov    %ecx,(%edx)
  103377:	8b 55 08             	mov    0x8(%ebp),%edx
  10337a:	88 10                	mov    %dl,(%eax)
    }
}
  10337c:	90                   	nop
  10337d:	5d                   	pop    %ebp
  10337e:	c3                   	ret    

0010337f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10337f:	f3 0f 1e fb          	endbr32 
  103383:	55                   	push   %ebp
  103384:	89 e5                	mov    %esp,%ebp
  103386:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103389:	8d 45 14             	lea    0x14(%ebp),%eax
  10338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10338f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103392:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103396:	8b 45 10             	mov    0x10(%ebp),%eax
  103399:	89 44 24 08          	mov    %eax,0x8(%esp)
  10339d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	89 04 24             	mov    %eax,(%esp)
  1033aa:	e8 08 00 00 00       	call   1033b7 <vsnprintf>
  1033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1033b5:	c9                   	leave  
  1033b6:	c3                   	ret    

001033b7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1033b7:	f3 0f 1e fb          	endbr32 
  1033bb:	55                   	push   %ebp
  1033bc:	89 e5                	mov    %esp,%ebp
  1033be:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d0:	01 d0                	add    %edx,%eax
  1033d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1033dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1033e0:	74 0a                	je     1033ec <vsnprintf+0x35>
  1033e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e8:	39 c2                	cmp    %eax,%edx
  1033ea:	76 07                	jbe    1033f3 <vsnprintf+0x3c>
        return -E_INVAL;
  1033ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1033f1:	eb 2a                	jmp    10341d <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1033f3:	8b 45 14             	mov    0x14(%ebp),%eax
  1033f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1033fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  103401:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103404:	89 44 24 04          	mov    %eax,0x4(%esp)
  103408:	c7 04 24 45 33 10 00 	movl   $0x103345,(%esp)
  10340f:	e8 53 fb ff ff       	call   102f67 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103417:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10341d:	c9                   	leave  
  10341e:	c3                   	ret    
