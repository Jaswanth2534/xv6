
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a2010113          	addi	sp,sp,-1504 # 80008a20 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	89070713          	addi	a4,a4,-1904 # 800088e0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	2be78793          	addi	a5,a5,702 # 80006320 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbc697>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	f4478793          	addi	a5,a5,-188 # 80000ff0 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	6c4080e7          	jalr	1732(ra) # 800027ee <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00011517          	auipc	a0,0x11
    80000190:	89450513          	addi	a0,a0,-1900 # 80010a20 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	bc2080e7          	jalr	-1086(ra) # 80000d56 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00011497          	auipc	s1,0x11
    800001a0:	88448493          	addi	s1,s1,-1916 # 80010a20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00011917          	auipc	s2,0x11
    800001a8:	91490913          	addi	s2,s2,-1772 # 80010ab8 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	b0a080e7          	jalr	-1270(ra) # 80001cc6 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	474080e7          	jalr	1140(ra) # 80002638 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	1b2080e7          	jalr	434(ra) # 80002384 <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00011717          	auipc	a4,0x11
    800001ec:	83870713          	addi	a4,a4,-1992 # 80010a20 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	57e080e7          	jalr	1406(ra) # 80002798 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	addi	s4,s4,1
    --n;
    8000022a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00010517          	auipc	a0,0x10
    8000023a:	7ea50513          	addi	a0,a0,2026 # 80010a20 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	bcc080e7          	jalr	-1076(ra) # 80000e0a <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00011717          	auipc	a4,0x11
    80000268:	84f72a23          	sw	a5,-1964(a4) # 80010ab8 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00010517          	auipc	a0,0x10
    8000027e:	7a650513          	addi	a0,a0,1958 # 80010a20 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	b88080e7          	jalr	-1144(ra) # 80000e0a <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00010517          	auipc	a0,0x10
    800002e6:	73e50513          	addi	a0,a0,1854 # 80010a20 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	a6c080e7          	jalr	-1428(ra) # 80000d56 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	53c080e7          	jalr	1340(ra) # 80002844 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00010517          	auipc	a0,0x10
    80000314:	71050513          	addi	a0,a0,1808 # 80010a20 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	af2080e7          	jalr	-1294(ra) # 80000e0a <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
  switch(c){
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000332:	00010717          	auipc	a4,0x10
    80000336:	6ee70713          	addi	a4,a4,1774 # 80010a20 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
      consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00010797          	auipc	a5,0x10
    80000360:	6c478793          	addi	a5,a5,1732 # 80010a20 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00010797          	auipc	a5,0x10
    8000038e:	72e7a783          	lw	a5,1838(a5) # 80010ab8 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a0:	00010717          	auipc	a4,0x10
    800003a4:	68070713          	addi	a4,a4,1664 # 80010a20 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b0:	00010497          	auipc	s1,0x10
    800003b4:	67048493          	addi	s1,s1,1648 # 80010a20 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f6:	00010717          	auipc	a4,0x10
    800003fa:	62a70713          	addi	a4,a4,1578 # 80010a20 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
      cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00010717          	auipc	a4,0x10
    80000410:	6af72a23          	sw	a5,1716(a4) # 80010ac0 <cons+0xa0>
      consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
      consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00010797          	auipc	a5,0x10
    80000436:	5ee78793          	addi	a5,a5,1518 # 80010a20 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000456:	00010797          	auipc	a5,0x10
    8000045a:	66c7a323          	sw	a2,1638(a5) # 80010abc <cons+0x9c>
        wakeup(&cons.r);
    8000045e:	00010517          	auipc	a0,0x10
    80000462:	65a50513          	addi	a0,a0,1626 # 80010ab8 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	f82080e7          	jalr	-126(ra) # 800023e8 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void
consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00010517          	auipc	a0,0x10
    80000484:	5a050513          	addi	a0,a0,1440 # 80010a20 <cons>
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	83e080e7          	jalr	-1986(ra) # 80000cc6 <initlock>

  uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000498:	00041797          	auipc	a5,0x41
    8000049c:	b3878793          	addi	a5,a5,-1224 # 80040fd0 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	25a60613          	addi	a2,a2,602 # 80008730 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00010797          	auipc	a5,0x10
    80000570:	5607aa23          	sw	zero,1396(a5) # 80010ae0 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	00008717          	auipc	a4,0x8
    800005a4:	30f72023          	sw	a5,768(a4) # 800088a0 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d17          	auipc	s10,0x10
    800005ce:	516d2d03          	lw	s10,1302(s10) # 80010ae0 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	128a8a93          	addi	s5,s5,296 # 80008730 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00010517          	auipc	a0,0x10
    8000061e:	4ae50513          	addi	a0,a0,1198 # 80010ac8 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	734080e7          	jalr	1844(ra) # 80000d56 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00010517          	auipc	a0,0x10
    800007a4:	32850513          	addi	a0,a0,808 # 80010ac8 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	662080e7          	jalr	1634(ra) # 80000e0a <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00010497          	auipc	s1,0x10
    800007c0:	30c48493          	addi	s1,s1,780 # 80010ac8 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	4f8080e7          	jalr	1272(ra) # 80000cc6 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00010517          	auipc	a0,0x10
    8000082c:	2c050513          	addi	a0,a0,704 # 80010ae8 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	496080e7          	jalr	1174(ra) # 80000cc6 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	4be080e7          	jalr	1214(ra) # 80000d0a <push_off>

  if(panicked){
    80000854:	00008797          	auipc	a5,0x8
    80000858:	04c7a783          	lw	a5,76(a5) # 800088a0 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	530080e7          	jalr	1328(ra) # 80000daa <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	00008797          	auipc	a5,0x8
    80000892:	01a7b783          	ld	a5,26(a5) # 800088a8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	01a73703          	ld	a4,26(a4) # 800088b0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00010a97          	auipc	s5,0x10
    800008c0:	22ca8a93          	addi	s5,s5,556 # 80010ae8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	fe448493          	addi	s1,s1,-28 # 800088a8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	fe098993          	addi	s3,s3,-32 # 800088b0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	af6080e7          	jalr	-1290(ra) # 800023e8 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00010517          	auipc	a0,0x10
    80000934:	1b850513          	addi	a0,a0,440 # 80010ae8 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	41e080e7          	jalr	1054(ra) # 80000d56 <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	f607a783          	lw	a5,-160(a5) # 800088a0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	f6673703          	ld	a4,-154(a4) # 800088b0 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	f567b783          	ld	a5,-170(a5) # 800088a8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	18a98993          	addi	s3,s3,394 # 80010ae8 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	f4248493          	addi	s1,s1,-190 # 800088a8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	f4290913          	addi	s2,s2,-190 # 800088b0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	a06080e7          	jalr	-1530(ra) # 80002384 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	15448493          	addi	s1,s1,340 # 80010ae8 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	f0e7b423          	sd	a4,-248(a5) # 800088b0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	450080e7          	jalr	1104(ra) # 80000e0a <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00010497          	auipc	s1,0x10
    80000a20:	0cc48493          	addi	s1,s1,204 # 80010ae8 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	330080e7          	jalr	816(ra) # 80000d56 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	3d2080e7          	jalr	978(ra) # 80000e0a <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000a4a:	7179                	addi	sp,sp,-48
    80000a4c:	f406                	sd	ra,40(sp)
    80000a4e:	f022                	sd	s0,32(sp)
    80000a50:	ec26                	sd	s1,24(sp)
    80000a52:	1800                	addi	s0,sp,48
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a54:	03451793          	slli	a5,a0,0x34
    80000a58:	eba5                	bnez	a5,80000ac8 <kfree+0x7e>
    80000a5a:	84aa                	mv	s1,a0
    80000a5c:	00041797          	auipc	a5,0x41
    80000a60:	70c78793          	addi	a5,a5,1804 # 80042168 <end>
    80000a64:	06f56263          	bltu	a0,a5,80000ac8 <kfree+0x7e>
    80000a68:	47c5                	li	a5,17
    80000a6a:	07ee                	slli	a5,a5,0x1b
    80000a6c:	04f57e63          	bgeu	a0,a5,80000ac8 <kfree+0x7e>
    panic("kfree");

  acquire(&reflock);
    80000a70:	00010517          	auipc	a0,0x10
    80000a74:	0b050513          	addi	a0,a0,176 # 80010b20 <reflock>
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	2de080e7          	jalr	734(ra) # 80000d56 <acquire>
  if (ref_count[((uint64)pa - KERNBASE) / PGSIZE] > 1)
    80000a80:	800007b7          	lui	a5,0x80000
    80000a84:	97a6                	add	a5,a5,s1
    80000a86:	83b1                	srli	a5,a5,0xc
    80000a88:	00279693          	slli	a3,a5,0x2
    80000a8c:	00010717          	auipc	a4,0x10
    80000a90:	0cc70713          	addi	a4,a4,204 # 80010b58 <ref_count>
    80000a94:	9736                	add	a4,a4,a3
    80000a96:	4318                	lw	a4,0(a4)
    80000a98:	4685                	li	a3,1
    80000a9a:	04e6d163          	bge	a3,a4,80000adc <kfree+0x92>
  {
    ref_count[((uint64)pa - KERNBASE) / PGSIZE] -= 1;
    80000a9e:	078a                	slli	a5,a5,0x2
    80000aa0:	00010697          	auipc	a3,0x10
    80000aa4:	0b868693          	addi	a3,a3,184 # 80010b58 <ref_count>
    80000aa8:	97b6                	add	a5,a5,a3
    80000aaa:	377d                	addiw	a4,a4,-1
    80000aac:	c398                	sw	a4,0(a5)
    release(&reflock);
    80000aae:	00010517          	auipc	a0,0x10
    80000ab2:	07250513          	addi	a0,a0,114 # 80010b20 <reflock>
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	354080e7          	jalr	852(ra) # 80000e0a <release>
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
}
    80000abe:	70a2                	ld	ra,40(sp)
    80000ac0:	7402                	ld	s0,32(sp)
    80000ac2:	64e2                	ld	s1,24(sp)
    80000ac4:	6145                	addi	sp,sp,48
    80000ac6:	8082                	ret
    80000ac8:	e84a                	sd	s2,16(sp)
    80000aca:	e44e                	sd	s3,8(sp)
    panic("kfree");
    80000acc:	00007517          	auipc	a0,0x7
    80000ad0:	57450513          	addi	a0,a0,1396 # 80008040 <etext+0x40>
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	a8c080e7          	jalr	-1396(ra) # 80000560 <panic>
    80000adc:	e84a                	sd	s2,16(sp)
    80000ade:	e44e                	sd	s3,8(sp)
    ref_count[((uint64)pa - KERNBASE) / PGSIZE] = 0;
    80000ae0:	078a                	slli	a5,a5,0x2
    80000ae2:	00010717          	auipc	a4,0x10
    80000ae6:	07670713          	addi	a4,a4,118 # 80010b58 <ref_count>
    80000aea:	97ba                	add	a5,a5,a4
    80000aec:	0007a023          	sw	zero,0(a5) # ffffffff80000000 <end+0xfffffffefffbde98>
    release(&reflock);
    80000af0:	00010917          	auipc	s2,0x10
    80000af4:	03090913          	addi	s2,s2,48 # 80010b20 <reflock>
    80000af8:	854a                	mv	a0,s2
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	310080e7          	jalr	784(ra) # 80000e0a <release>
    memset(pa, 1, PGSIZE);
    80000b02:	6605                	lui	a2,0x1
    80000b04:	4585                	li	a1,1
    80000b06:	8526                	mv	a0,s1
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	34a080e7          	jalr	842(ra) # 80000e52 <memset>
    acquire(&kmem.lock);
    80000b10:	00010997          	auipc	s3,0x10
    80000b14:	02898993          	addi	s3,s3,40 # 80010b38 <kmem>
    80000b18:	854e                	mv	a0,s3
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	23c080e7          	jalr	572(ra) # 80000d56 <acquire>
    r->next = kmem.freelist;
    80000b22:	03093783          	ld	a5,48(s2)
    80000b26:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000b28:	02993823          	sd	s1,48(s2)
    release(&kmem.lock);
    80000b2c:	854e                	mv	a0,s3
    80000b2e:	00000097          	auipc	ra,0x0
    80000b32:	2dc080e7          	jalr	732(ra) # 80000e0a <release>
    80000b36:	6942                	ld	s2,16(sp)
    80000b38:	69a2                	ld	s3,8(sp)
}
    80000b3a:	b751                	j	80000abe <kfree+0x74>

0000000080000b3c <freerange>:
{
    80000b3c:	715d                	addi	sp,sp,-80
    80000b3e:	e486                	sd	ra,72(sp)
    80000b40:	e0a2                	sd	s0,64(sp)
    80000b42:	fc26                	sd	s1,56(sp)
    80000b44:	0880                	addi	s0,sp,80
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000b46:	6785                	lui	a5,0x1
    80000b48:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b4c:	00e504b3          	add	s1,a0,a4
    80000b50:	777d                	lui	a4,0xfffff
    80000b52:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b54:	94be                	add	s1,s1,a5
    80000b56:	0695ea63          	bltu	a1,s1,80000bca <freerange+0x8e>
    80000b5a:	f84a                	sd	s2,48(sp)
    80000b5c:	f44e                	sd	s3,40(sp)
    80000b5e:	f052                	sd	s4,32(sp)
    80000b60:	ec56                	sd	s5,24(sp)
    80000b62:	e85a                	sd	s6,16(sp)
    80000b64:	e45e                	sd	s7,8(sp)
    80000b66:	e062                	sd	s8,0(sp)
    80000b68:	8a2e                	mv	s4,a1
    acquire(&reflock);
    80000b6a:	00010917          	auipc	s2,0x10
    80000b6e:	fb690913          	addi	s2,s2,-74 # 80010b20 <reflock>
    ref_count[((uint64)p - KERNBASE) / PGSIZE] = 1;
    80000b72:	00010c17          	auipc	s8,0x10
    80000b76:	fe6c0c13          	addi	s8,s8,-26 # 80010b58 <ref_count>
    80000b7a:	fff809b7          	lui	s3,0xfff80
    80000b7e:	19fd                	addi	s3,s3,-1 # fffffffffff7ffff <end+0xffffffff7ff3de97>
    80000b80:	09b2                	slli	s3,s3,0xc
    80000b82:	4b85                	li	s7,1
    kfree(p);
    80000b84:	7b7d                	lui	s6,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b86:	6a85                	lui	s5,0x1
    acquire(&reflock);
    80000b88:	854a                	mv	a0,s2
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	1cc080e7          	jalr	460(ra) # 80000d56 <acquire>
    ref_count[((uint64)p - KERNBASE) / PGSIZE] = 1;
    80000b92:	013487b3          	add	a5,s1,s3
    80000b96:	83b1                	srli	a5,a5,0xc
    80000b98:	078a                	slli	a5,a5,0x2
    80000b9a:	97e2                	add	a5,a5,s8
    80000b9c:	0177a023          	sw	s7,0(a5)
    release(&reflock);
    80000ba0:	854a                	mv	a0,s2
    80000ba2:	00000097          	auipc	ra,0x0
    80000ba6:	268080e7          	jalr	616(ra) # 80000e0a <release>
    kfree(p);
    80000baa:	01648533          	add	a0,s1,s6
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	e9c080e7          	jalr	-356(ra) # 80000a4a <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000bb6:	94d6                	add	s1,s1,s5
    80000bb8:	fc9a78e3          	bgeu	s4,s1,80000b88 <freerange+0x4c>
    80000bbc:	7942                	ld	s2,48(sp)
    80000bbe:	79a2                	ld	s3,40(sp)
    80000bc0:	7a02                	ld	s4,32(sp)
    80000bc2:	6ae2                	ld	s5,24(sp)
    80000bc4:	6b42                	ld	s6,16(sp)
    80000bc6:	6ba2                	ld	s7,8(sp)
    80000bc8:	6c02                	ld	s8,0(sp)
}
    80000bca:	60a6                	ld	ra,72(sp)
    80000bcc:	6406                	ld	s0,64(sp)
    80000bce:	74e2                	ld	s1,56(sp)
    80000bd0:	6161                	addi	sp,sp,80
    80000bd2:	8082                	ret

0000000080000bd4 <kinit>:
{
    80000bd4:	1141                	addi	sp,sp,-16
    80000bd6:	e406                	sd	ra,8(sp)
    80000bd8:	e022                	sd	s0,0(sp)
    80000bda:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bdc:	00007597          	auipc	a1,0x7
    80000be0:	46c58593          	addi	a1,a1,1132 # 80008048 <etext+0x48>
    80000be4:	00010517          	auipc	a0,0x10
    80000be8:	f5450513          	addi	a0,a0,-172 # 80010b38 <kmem>
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	0da080e7          	jalr	218(ra) # 80000cc6 <initlock>
  initlock(&reflock,"reflock");
    80000bf4:	00007597          	auipc	a1,0x7
    80000bf8:	45c58593          	addi	a1,a1,1116 # 80008050 <etext+0x50>
    80000bfc:	00010517          	auipc	a0,0x10
    80000c00:	f2450513          	addi	a0,a0,-220 # 80010b20 <reflock>
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	0c2080e7          	jalr	194(ra) # 80000cc6 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000c0c:	45c5                	li	a1,17
    80000c0e:	05ee                	slli	a1,a1,0x1b
    80000c10:	00041517          	auipc	a0,0x41
    80000c14:	55850513          	addi	a0,a0,1368 # 80042168 <end>
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	f24080e7          	jalr	-220(ra) # 80000b3c <freerange>
}
    80000c20:	60a2                	ld	ra,8(sp)
    80000c22:	6402                	ld	s0,0(sp)
    80000c24:	0141                	addi	sp,sp,16
    80000c26:	8082                	ret

0000000080000c28 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c32:	00010517          	auipc	a0,0x10
    80000c36:	f0650513          	addi	a0,a0,-250 # 80010b38 <kmem>
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	11c080e7          	jalr	284(ra) # 80000d56 <acquire>
  r = kmem.freelist;
    80000c42:	00010497          	auipc	s1,0x10
    80000c46:	f0e4b483          	ld	s1,-242(s1) # 80010b50 <kmem+0x18>
  if (r)
    80000c4a:	c4ad                	beqz	s1,80000cb4 <kalloc+0x8c>
    80000c4c:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    80000c4e:	609c                	ld	a5,0(s1)
    80000c50:	00010917          	auipc	s2,0x10
    80000c54:	ed090913          	addi	s2,s2,-304 # 80010b20 <reflock>
    80000c58:	02f93823          	sd	a5,48(s2)
  release(&kmem.lock);
    80000c5c:	00010517          	auipc	a0,0x10
    80000c60:	edc50513          	addi	a0,a0,-292 # 80010b38 <kmem>
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	1a6080e7          	jalr	422(ra) # 80000e0a <release>

  if (r)
  {
    memset((char *)r, 5, PGSIZE);
    80000c6c:	6605                	lui	a2,0x1
    80000c6e:	4595                	li	a1,5
    80000c70:	8526                	mv	a0,s1
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	1e0080e7          	jalr	480(ra) # 80000e52 <memset>
    acquire(&reflock);
    80000c7a:	854a                	mv	a0,s2
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	0da080e7          	jalr	218(ra) # 80000d56 <acquire>
    ref_count[((uint64)r - KERNBASE) / PGSIZE] = 1;
    80000c84:	800007b7          	lui	a5,0x80000
    80000c88:	97a6                	add	a5,a5,s1
    80000c8a:	83b1                	srli	a5,a5,0xc
    80000c8c:	078a                	slli	a5,a5,0x2
    80000c8e:	00010717          	auipc	a4,0x10
    80000c92:	eca70713          	addi	a4,a4,-310 # 80010b58 <ref_count>
    80000c96:	97ba                	add	a5,a5,a4
    80000c98:	4705                	li	a4,1
    80000c9a:	c398                	sw	a4,0(a5)
    release(&reflock);
    80000c9c:	854a                	mv	a0,s2
    80000c9e:	00000097          	auipc	ra,0x0
    80000ca2:	16c080e7          	jalr	364(ra) # 80000e0a <release>
  }
  return (void *)r;
    80000ca6:	6902                	ld	s2,0(sp)
    80000ca8:	8526                	mv	a0,s1
    80000caa:	60e2                	ld	ra,24(sp)
    80000cac:	6442                	ld	s0,16(sp)
    80000cae:	64a2                	ld	s1,8(sp)
    80000cb0:	6105                	addi	sp,sp,32
    80000cb2:	8082                	ret
  release(&kmem.lock);
    80000cb4:	00010517          	auipc	a0,0x10
    80000cb8:	e8450513          	addi	a0,a0,-380 # 80010b38 <kmem>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	14e080e7          	jalr	334(ra) # 80000e0a <release>
  if (r)
    80000cc4:	b7d5                	j	80000ca8 <kalloc+0x80>

0000000080000cc6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000cc6:	1141                	addi	sp,sp,-16
    80000cc8:	e422                	sd	s0,8(sp)
    80000cca:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ccc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000cce:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000cd2:	00053823          	sd	zero,16(a0)
}
    80000cd6:	6422                	ld	s0,8(sp)
    80000cd8:	0141                	addi	sp,sp,16
    80000cda:	8082                	ret

0000000080000cdc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cdc:	411c                	lw	a5,0(a0)
    80000cde:	e399                	bnez	a5,80000ce4 <holding+0x8>
    80000ce0:	4501                	li	a0,0
  return r;
}
    80000ce2:	8082                	ret
{
    80000ce4:	1101                	addi	sp,sp,-32
    80000ce6:	ec06                	sd	ra,24(sp)
    80000ce8:	e822                	sd	s0,16(sp)
    80000cea:	e426                	sd	s1,8(sp)
    80000cec:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cee:	6904                	ld	s1,16(a0)
    80000cf0:	00001097          	auipc	ra,0x1
    80000cf4:	fba080e7          	jalr	-70(ra) # 80001caa <mycpu>
    80000cf8:	40a48533          	sub	a0,s1,a0
    80000cfc:	00153513          	seqz	a0,a0
}
    80000d00:	60e2                	ld	ra,24(sp)
    80000d02:	6442                	ld	s0,16(sp)
    80000d04:	64a2                	ld	s1,8(sp)
    80000d06:	6105                	addi	sp,sp,32
    80000d08:	8082                	ret

0000000080000d0a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d0a:	1101                	addi	sp,sp,-32
    80000d0c:	ec06                	sd	ra,24(sp)
    80000d0e:	e822                	sd	s0,16(sp)
    80000d10:	e426                	sd	s1,8(sp)
    80000d12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d14:	100024f3          	csrr	s1,sstatus
    80000d18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d1e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d22:	00001097          	auipc	ra,0x1
    80000d26:	f88080e7          	jalr	-120(ra) # 80001caa <mycpu>
    80000d2a:	5d3c                	lw	a5,120(a0)
    80000d2c:	cf89                	beqz	a5,80000d46 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d2e:	00001097          	auipc	ra,0x1
    80000d32:	f7c080e7          	jalr	-132(ra) # 80001caa <mycpu>
    80000d36:	5d3c                	lw	a5,120(a0)
    80000d38:	2785                	addiw	a5,a5,1 # ffffffff80000001 <end+0xfffffffefffbde99>
    80000d3a:	dd3c                	sw	a5,120(a0)
}
    80000d3c:	60e2                	ld	ra,24(sp)
    80000d3e:	6442                	ld	s0,16(sp)
    80000d40:	64a2                	ld	s1,8(sp)
    80000d42:	6105                	addi	sp,sp,32
    80000d44:	8082                	ret
    mycpu()->intena = old;
    80000d46:	00001097          	auipc	ra,0x1
    80000d4a:	f64080e7          	jalr	-156(ra) # 80001caa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d4e:	8085                	srli	s1,s1,0x1
    80000d50:	8885                	andi	s1,s1,1
    80000d52:	dd64                	sw	s1,124(a0)
    80000d54:	bfe9                	j	80000d2e <push_off+0x24>

0000000080000d56 <acquire>:
{
    80000d56:	1101                	addi	sp,sp,-32
    80000d58:	ec06                	sd	ra,24(sp)
    80000d5a:	e822                	sd	s0,16(sp)
    80000d5c:	e426                	sd	s1,8(sp)
    80000d5e:	1000                	addi	s0,sp,32
    80000d60:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	fa8080e7          	jalr	-88(ra) # 80000d0a <push_off>
  if(holding(lk))
    80000d6a:	8526                	mv	a0,s1
    80000d6c:	00000097          	auipc	ra,0x0
    80000d70:	f70080e7          	jalr	-144(ra) # 80000cdc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d74:	4705                	li	a4,1
  if(holding(lk))
    80000d76:	e115                	bnez	a0,80000d9a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d78:	87ba                	mv	a5,a4
    80000d7a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d7e:	2781                	sext.w	a5,a5
    80000d80:	ffe5                	bnez	a5,80000d78 <acquire+0x22>
  __sync_synchronize();
    80000d82:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d86:	00001097          	auipc	ra,0x1
    80000d8a:	f24080e7          	jalr	-220(ra) # 80001caa <mycpu>
    80000d8e:	e888                	sd	a0,16(s1)
}
    80000d90:	60e2                	ld	ra,24(sp)
    80000d92:	6442                	ld	s0,16(sp)
    80000d94:	64a2                	ld	s1,8(sp)
    80000d96:	6105                	addi	sp,sp,32
    80000d98:	8082                	ret
    panic("acquire");
    80000d9a:	00007517          	auipc	a0,0x7
    80000d9e:	2be50513          	addi	a0,a0,702 # 80008058 <etext+0x58>
    80000da2:	fffff097          	auipc	ra,0xfffff
    80000da6:	7be080e7          	jalr	1982(ra) # 80000560 <panic>

0000000080000daa <pop_off>:

void
pop_off(void)
{
    80000daa:	1141                	addi	sp,sp,-16
    80000dac:	e406                	sd	ra,8(sp)
    80000dae:	e022                	sd	s0,0(sp)
    80000db0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000db2:	00001097          	auipc	ra,0x1
    80000db6:	ef8080e7          	jalr	-264(ra) # 80001caa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000dba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000dbe:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000dc0:	e78d                	bnez	a5,80000dea <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000dc2:	5d3c                	lw	a5,120(a0)
    80000dc4:	02f05b63          	blez	a5,80000dfa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000dc8:	37fd                	addiw	a5,a5,-1
    80000dca:	0007871b          	sext.w	a4,a5
    80000dce:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000dd0:	eb09                	bnez	a4,80000de2 <pop_off+0x38>
    80000dd2:	5d7c                	lw	a5,124(a0)
    80000dd4:	c799                	beqz	a5,80000de2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000dd6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000dda:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000dde:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000de2:	60a2                	ld	ra,8(sp)
    80000de4:	6402                	ld	s0,0(sp)
    80000de6:	0141                	addi	sp,sp,16
    80000de8:	8082                	ret
    panic("pop_off - interruptible");
    80000dea:	00007517          	auipc	a0,0x7
    80000dee:	27650513          	addi	a0,a0,630 # 80008060 <etext+0x60>
    80000df2:	fffff097          	auipc	ra,0xfffff
    80000df6:	76e080e7          	jalr	1902(ra) # 80000560 <panic>
    panic("pop_off");
    80000dfa:	00007517          	auipc	a0,0x7
    80000dfe:	27e50513          	addi	a0,a0,638 # 80008078 <etext+0x78>
    80000e02:	fffff097          	auipc	ra,0xfffff
    80000e06:	75e080e7          	jalr	1886(ra) # 80000560 <panic>

0000000080000e0a <release>:
{
    80000e0a:	1101                	addi	sp,sp,-32
    80000e0c:	ec06                	sd	ra,24(sp)
    80000e0e:	e822                	sd	s0,16(sp)
    80000e10:	e426                	sd	s1,8(sp)
    80000e12:	1000                	addi	s0,sp,32
    80000e14:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000e16:	00000097          	auipc	ra,0x0
    80000e1a:	ec6080e7          	jalr	-314(ra) # 80000cdc <holding>
    80000e1e:	c115                	beqz	a0,80000e42 <release+0x38>
  lk->cpu = 0;
    80000e20:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e24:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e28:	0f50000f          	fence	iorw,ow
    80000e2c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e30:	00000097          	auipc	ra,0x0
    80000e34:	f7a080e7          	jalr	-134(ra) # 80000daa <pop_off>
}
    80000e38:	60e2                	ld	ra,24(sp)
    80000e3a:	6442                	ld	s0,16(sp)
    80000e3c:	64a2                	ld	s1,8(sp)
    80000e3e:	6105                	addi	sp,sp,32
    80000e40:	8082                	ret
    panic("release");
    80000e42:	00007517          	auipc	a0,0x7
    80000e46:	23e50513          	addi	a0,a0,574 # 80008080 <etext+0x80>
    80000e4a:	fffff097          	auipc	ra,0xfffff
    80000e4e:	716080e7          	jalr	1814(ra) # 80000560 <panic>

0000000080000e52 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e422                	sd	s0,8(sp)
    80000e56:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e58:	ca19                	beqz	a2,80000e6e <memset+0x1c>
    80000e5a:	87aa                	mv	a5,a0
    80000e5c:	1602                	slli	a2,a2,0x20
    80000e5e:	9201                	srli	a2,a2,0x20
    80000e60:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e64:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fee79de3          	bne	a5,a4,80000e64 <memset+0x12>
  }
  return dst;
}
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret

0000000080000e74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e74:	1141                	addi	sp,sp,-16
    80000e76:	e422                	sd	s0,8(sp)
    80000e78:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e7a:	ca05                	beqz	a2,80000eaa <memcmp+0x36>
    80000e7c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e80:	1682                	slli	a3,a3,0x20
    80000e82:	9281                	srli	a3,a3,0x20
    80000e84:	0685                	addi	a3,a3,1
    80000e86:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e88:	00054783          	lbu	a5,0(a0)
    80000e8c:	0005c703          	lbu	a4,0(a1)
    80000e90:	00e79863          	bne	a5,a4,80000ea0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e94:	0505                	addi	a0,a0,1
    80000e96:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e98:	fed518e3          	bne	a0,a3,80000e88 <memcmp+0x14>
  }

  return 0;
    80000e9c:	4501                	li	a0,0
    80000e9e:	a019                	j	80000ea4 <memcmp+0x30>
      return *s1 - *s2;
    80000ea0:	40e7853b          	subw	a0,a5,a4
}
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  return 0;
    80000eaa:	4501                	li	a0,0
    80000eac:	bfe5                	j	80000ea4 <memcmp+0x30>

0000000080000eae <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e422                	sd	s0,8(sp)
    80000eb2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000eb4:	c205                	beqz	a2,80000ed4 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000eb6:	02a5e263          	bltu	a1,a0,80000eda <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000eba:	1602                	slli	a2,a2,0x20
    80000ebc:	9201                	srli	a2,a2,0x20
    80000ebe:	00c587b3          	add	a5,a1,a2
{
    80000ec2:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ec4:	0585                	addi	a1,a1,1
    80000ec6:	0705                	addi	a4,a4,1
    80000ec8:	fff5c683          	lbu	a3,-1(a1)
    80000ecc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000ed0:	feb79ae3          	bne	a5,a1,80000ec4 <memmove+0x16>

  return dst;
}
    80000ed4:	6422                	ld	s0,8(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret
  if(s < d && s + n > d){
    80000eda:	02061693          	slli	a3,a2,0x20
    80000ede:	9281                	srli	a3,a3,0x20
    80000ee0:	00d58733          	add	a4,a1,a3
    80000ee4:	fce57be3          	bgeu	a0,a4,80000eba <memmove+0xc>
    d += n;
    80000ee8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000eea:	fff6079b          	addiw	a5,a2,-1
    80000eee:	1782                	slli	a5,a5,0x20
    80000ef0:	9381                	srli	a5,a5,0x20
    80000ef2:	fff7c793          	not	a5,a5
    80000ef6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000ef8:	177d                	addi	a4,a4,-1
    80000efa:	16fd                	addi	a3,a3,-1
    80000efc:	00074603          	lbu	a2,0(a4)
    80000f00:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000f04:	fef71ae3          	bne	a4,a5,80000ef8 <memmove+0x4a>
    80000f08:	b7f1                	j	80000ed4 <memmove+0x26>

0000000080000f0a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f0a:	1141                	addi	sp,sp,-16
    80000f0c:	e406                	sd	ra,8(sp)
    80000f0e:	e022                	sd	s0,0(sp)
    80000f10:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	f9c080e7          	jalr	-100(ra) # 80000eae <memmove>
}
    80000f1a:	60a2                	ld	ra,8(sp)
    80000f1c:	6402                	ld	s0,0(sp)
    80000f1e:	0141                	addi	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f28:	ce11                	beqz	a2,80000f44 <strncmp+0x22>
    80000f2a:	00054783          	lbu	a5,0(a0)
    80000f2e:	cf89                	beqz	a5,80000f48 <strncmp+0x26>
    80000f30:	0005c703          	lbu	a4,0(a1)
    80000f34:	00f71a63          	bne	a4,a5,80000f48 <strncmp+0x26>
    n--, p++, q++;
    80000f38:	367d                	addiw	a2,a2,-1
    80000f3a:	0505                	addi	a0,a0,1
    80000f3c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f3e:	f675                	bnez	a2,80000f2a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f40:	4501                	li	a0,0
    80000f42:	a801                	j	80000f52 <strncmp+0x30>
    80000f44:	4501                	li	a0,0
    80000f46:	a031                	j	80000f52 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000f48:	00054503          	lbu	a0,0(a0)
    80000f4c:	0005c783          	lbu	a5,0(a1)
    80000f50:	9d1d                	subw	a0,a0,a5
}
    80000f52:	6422                	ld	s0,8(sp)
    80000f54:	0141                	addi	sp,sp,16
    80000f56:	8082                	ret

0000000080000f58 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f58:	1141                	addi	sp,sp,-16
    80000f5a:	e422                	sd	s0,8(sp)
    80000f5c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f5e:	87aa                	mv	a5,a0
    80000f60:	86b2                	mv	a3,a2
    80000f62:	367d                	addiw	a2,a2,-1
    80000f64:	02d05563          	blez	a3,80000f8e <strncpy+0x36>
    80000f68:	0785                	addi	a5,a5,1
    80000f6a:	0005c703          	lbu	a4,0(a1)
    80000f6e:	fee78fa3          	sb	a4,-1(a5)
    80000f72:	0585                	addi	a1,a1,1
    80000f74:	f775                	bnez	a4,80000f60 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f76:	873e                	mv	a4,a5
    80000f78:	9fb5                	addw	a5,a5,a3
    80000f7a:	37fd                	addiw	a5,a5,-1
    80000f7c:	00c05963          	blez	a2,80000f8e <strncpy+0x36>
    *s++ = 0;
    80000f80:	0705                	addi	a4,a4,1
    80000f82:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f86:	40e786bb          	subw	a3,a5,a4
    80000f8a:	fed04be3          	bgtz	a3,80000f80 <strncpy+0x28>
  return os;
}
    80000f8e:	6422                	ld	s0,8(sp)
    80000f90:	0141                	addi	sp,sp,16
    80000f92:	8082                	ret

0000000080000f94 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f94:	1141                	addi	sp,sp,-16
    80000f96:	e422                	sd	s0,8(sp)
    80000f98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f9a:	02c05363          	blez	a2,80000fc0 <safestrcpy+0x2c>
    80000f9e:	fff6069b          	addiw	a3,a2,-1
    80000fa2:	1682                	slli	a3,a3,0x20
    80000fa4:	9281                	srli	a3,a3,0x20
    80000fa6:	96ae                	add	a3,a3,a1
    80000fa8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000faa:	00d58963          	beq	a1,a3,80000fbc <safestrcpy+0x28>
    80000fae:	0585                	addi	a1,a1,1
    80000fb0:	0785                	addi	a5,a5,1
    80000fb2:	fff5c703          	lbu	a4,-1(a1)
    80000fb6:	fee78fa3          	sb	a4,-1(a5)
    80000fba:	fb65                	bnez	a4,80000faa <safestrcpy+0x16>
    ;
  *s = 0;
    80000fbc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000fc0:	6422                	ld	s0,8(sp)
    80000fc2:	0141                	addi	sp,sp,16
    80000fc4:	8082                	ret

0000000080000fc6 <strlen>:

int
strlen(const char *s)
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fcc:	00054783          	lbu	a5,0(a0)
    80000fd0:	cf91                	beqz	a5,80000fec <strlen+0x26>
    80000fd2:	0505                	addi	a0,a0,1
    80000fd4:	87aa                	mv	a5,a0
    80000fd6:	86be                	mv	a3,a5
    80000fd8:	0785                	addi	a5,a5,1
    80000fda:	fff7c703          	lbu	a4,-1(a5)
    80000fde:	ff65                	bnez	a4,80000fd6 <strlen+0x10>
    80000fe0:	40a6853b          	subw	a0,a3,a0
    80000fe4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000fe6:	6422                	ld	s0,8(sp)
    80000fe8:	0141                	addi	sp,sp,16
    80000fea:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fec:	4501                	li	a0,0
    80000fee:	bfe5                	j	80000fe6 <strlen+0x20>

0000000080000ff0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e406                	sd	ra,8(sp)
    80000ff4:	e022                	sd	s0,0(sp)
    80000ff6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ff8:	00001097          	auipc	ra,0x1
    80000ffc:	ca2080e7          	jalr	-862(ra) # 80001c9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001000:	00008717          	auipc	a4,0x8
    80001004:	8b870713          	addi	a4,a4,-1864 # 800088b8 <started>
  if(cpuid() == 0){
    80001008:	c139                	beqz	a0,8000104e <main+0x5e>
    while(started == 0)
    8000100a:	431c                	lw	a5,0(a4)
    8000100c:	2781                	sext.w	a5,a5
    8000100e:	dff5                	beqz	a5,8000100a <main+0x1a>
      ;
    __sync_synchronize();
    80001010:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001014:	00001097          	auipc	ra,0x1
    80001018:	c86080e7          	jalr	-890(ra) # 80001c9a <cpuid>
    8000101c:	85aa                	mv	a1,a0
    8000101e:	00007517          	auipc	a0,0x7
    80001022:	08250513          	addi	a0,a0,130 # 800080a0 <etext+0xa0>
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	584080e7          	jalr	1412(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	0d8080e7          	jalr	216(ra) # 80001106 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001036:	00002097          	auipc	ra,0x2
    8000103a:	afa080e7          	jalr	-1286(ra) # 80002b30 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	326080e7          	jalr	806(ra) # 80006364 <plicinithart>
  }

  scheduler();        
    80001046:	00001097          	auipc	ra,0x1
    8000104a:	18c080e7          	jalr	396(ra) # 800021d2 <scheduler>
    consoleinit();
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	422080e7          	jalr	1058(ra) # 80000470 <consoleinit>
    printfinit();
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	75c080e7          	jalr	1884(ra) # 800007b2 <printfinit>
    printf("\n");
    8000105e:	00007517          	auipc	a0,0x7
    80001062:	fb250513          	addi	a0,a0,-78 # 80008010 <etext+0x10>
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	544080e7          	jalr	1348(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    8000106e:	00007517          	auipc	a0,0x7
    80001072:	01a50513          	addi	a0,a0,26 # 80008088 <etext+0x88>
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	534080e7          	jalr	1332(ra) # 800005aa <printf>
    printf("\n");
    8000107e:	00007517          	auipc	a0,0x7
    80001082:	f9250513          	addi	a0,a0,-110 # 80008010 <etext+0x10>
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	524080e7          	jalr	1316(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	b46080e7          	jalr	-1210(ra) # 80000bd4 <kinit>
    kvminit();       // create kernel page table
    80001096:	00000097          	auipc	ra,0x0
    8000109a:	326080e7          	jalr	806(ra) # 800013bc <kvminit>
    kvminithart();   // turn on paging
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	068080e7          	jalr	104(ra) # 80001106 <kvminithart>
    procinit();      // process table
    800010a6:	00001097          	auipc	ra,0x1
    800010aa:	b32080e7          	jalr	-1230(ra) # 80001bd8 <procinit>
    trapinit();      // trap vectors
    800010ae:	00002097          	auipc	ra,0x2
    800010b2:	a5a080e7          	jalr	-1446(ra) # 80002b08 <trapinit>
    trapinithart();  // install kernel trap vector
    800010b6:	00002097          	auipc	ra,0x2
    800010ba:	a7a080e7          	jalr	-1414(ra) # 80002b30 <trapinithart>
    plicinit();      // set up interrupt controller
    800010be:	00005097          	auipc	ra,0x5
    800010c2:	28c080e7          	jalr	652(ra) # 8000634a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	29e080e7          	jalr	670(ra) # 80006364 <plicinithart>
    binit();         // buffer cache
    800010ce:	00002097          	auipc	ra,0x2
    800010d2:	35e080e7          	jalr	862(ra) # 8000342c <binit>
    iinit();         // inode table
    800010d6:	00003097          	auipc	ra,0x3
    800010da:	a14080e7          	jalr	-1516(ra) # 80003aea <iinit>
    fileinit();      // file table
    800010de:	00004097          	auipc	ra,0x4
    800010e2:	9c4080e7          	jalr	-1596(ra) # 80004aa2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010e6:	00005097          	auipc	ra,0x5
    800010ea:	386080e7          	jalr	902(ra) # 8000646c <virtio_disk_init>
    userinit();      // first user process
    800010ee:	00001097          	auipc	ra,0x1
    800010f2:	ec4080e7          	jalr	-316(ra) # 80001fb2 <userinit>
    __sync_synchronize();
    800010f6:	0ff0000f          	fence
    started = 1;
    800010fa:	4785                	li	a5,1
    800010fc:	00007717          	auipc	a4,0x7
    80001100:	7af72e23          	sw	a5,1980(a4) # 800088b8 <started>
    80001104:	b789                	j	80001046 <main+0x56>

0000000080001106 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001106:	1141                	addi	sp,sp,-16
    80001108:	e422                	sd	s0,8(sp)
    8000110a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000110c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001110:	00007797          	auipc	a5,0x7
    80001114:	7b07b783          	ld	a5,1968(a5) # 800088c0 <kernel_pagetable>
    80001118:	83b1                	srli	a5,a5,0xc
    8000111a:	577d                	li	a4,-1
    8000111c:	177e                	slli	a4,a4,0x3f
    8000111e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001120:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001124:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001128:	6422                	ld	s0,8(sp)
    8000112a:	0141                	addi	sp,sp,16
    8000112c:	8082                	ret

000000008000112e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000112e:	7139                	addi	sp,sp,-64
    80001130:	fc06                	sd	ra,56(sp)
    80001132:	f822                	sd	s0,48(sp)
    80001134:	f426                	sd	s1,40(sp)
    80001136:	f04a                	sd	s2,32(sp)
    80001138:	ec4e                	sd	s3,24(sp)
    8000113a:	e852                	sd	s4,16(sp)
    8000113c:	e456                	sd	s5,8(sp)
    8000113e:	e05a                	sd	s6,0(sp)
    80001140:	0080                	addi	s0,sp,64
    80001142:	84aa                	mv	s1,a0
    80001144:	89ae                	mv	s3,a1
    80001146:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001148:	57fd                	li	a5,-1
    8000114a:	83e9                	srli	a5,a5,0x1a
    8000114c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000114e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001150:	04b7f263          	bgeu	a5,a1,80001194 <walk+0x66>
    panic("walk");
    80001154:	00007517          	auipc	a0,0x7
    80001158:	f6450513          	addi	a0,a0,-156 # 800080b8 <etext+0xb8>
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	404080e7          	jalr	1028(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001164:	060a8663          	beqz	s5,800011d0 <walk+0xa2>
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	ac0080e7          	jalr	-1344(ra) # 80000c28 <kalloc>
    80001170:	84aa                	mv	s1,a0
    80001172:	c529                	beqz	a0,800011bc <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001174:	6605                	lui	a2,0x1
    80001176:	4581                	li	a1,0
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	cda080e7          	jalr	-806(ra) # 80000e52 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001180:	00c4d793          	srli	a5,s1,0xc
    80001184:	07aa                	slli	a5,a5,0xa
    80001186:	0017e793          	ori	a5,a5,1
    8000118a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000118e:	3a5d                	addiw	s4,s4,-9
    80001190:	036a0063          	beq	s4,s6,800011b0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001194:	0149d933          	srl	s2,s3,s4
    80001198:	1ff97913          	andi	s2,s2,511
    8000119c:	090e                	slli	s2,s2,0x3
    8000119e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800011a0:	00093483          	ld	s1,0(s2)
    800011a4:	0014f793          	andi	a5,s1,1
    800011a8:	dfd5                	beqz	a5,80001164 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011aa:	80a9                	srli	s1,s1,0xa
    800011ac:	04b2                	slli	s1,s1,0xc
    800011ae:	b7c5                	j	8000118e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800011b0:	00c9d513          	srli	a0,s3,0xc
    800011b4:	1ff57513          	andi	a0,a0,511
    800011b8:	050e                	slli	a0,a0,0x3
    800011ba:	9526                	add	a0,a0,s1
}
    800011bc:	70e2                	ld	ra,56(sp)
    800011be:	7442                	ld	s0,48(sp)
    800011c0:	74a2                	ld	s1,40(sp)
    800011c2:	7902                	ld	s2,32(sp)
    800011c4:	69e2                	ld	s3,24(sp)
    800011c6:	6a42                	ld	s4,16(sp)
    800011c8:	6aa2                	ld	s5,8(sp)
    800011ca:	6b02                	ld	s6,0(sp)
    800011cc:	6121                	addi	sp,sp,64
    800011ce:	8082                	ret
        return 0;
    800011d0:	4501                	li	a0,0
    800011d2:	b7ed                	j	800011bc <walk+0x8e>

00000000800011d4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011d4:	57fd                	li	a5,-1
    800011d6:	83e9                	srli	a5,a5,0x1a
    800011d8:	00b7f463          	bgeu	a5,a1,800011e0 <walkaddr+0xc>
    return 0;
    800011dc:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011de:	8082                	ret
{
    800011e0:	1141                	addi	sp,sp,-16
    800011e2:	e406                	sd	ra,8(sp)
    800011e4:	e022                	sd	s0,0(sp)
    800011e6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011e8:	4601                	li	a2,0
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	f44080e7          	jalr	-188(ra) # 8000112e <walk>
  if(pte == 0)
    800011f2:	c105                	beqz	a0,80001212 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011f4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011f6:	0117f693          	andi	a3,a5,17
    800011fa:	4745                	li	a4,17
    return 0;
    800011fc:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011fe:	00e68663          	beq	a3,a4,8000120a <walkaddr+0x36>
}
    80001202:	60a2                	ld	ra,8(sp)
    80001204:	6402                	ld	s0,0(sp)
    80001206:	0141                	addi	sp,sp,16
    80001208:	8082                	ret
  pa = PTE2PA(*pte);
    8000120a:	83a9                	srli	a5,a5,0xa
    8000120c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001210:	bfcd                	j	80001202 <walkaddr+0x2e>
    return 0;
    80001212:	4501                	li	a0,0
    80001214:	b7fd                	j	80001202 <walkaddr+0x2e>

0000000080001216 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001216:	715d                	addi	sp,sp,-80
    80001218:	e486                	sd	ra,72(sp)
    8000121a:	e0a2                	sd	s0,64(sp)
    8000121c:	fc26                	sd	s1,56(sp)
    8000121e:	f84a                	sd	s2,48(sp)
    80001220:	f44e                	sd	s3,40(sp)
    80001222:	f052                	sd	s4,32(sp)
    80001224:	ec56                	sd	s5,24(sp)
    80001226:	e85a                	sd	s6,16(sp)
    80001228:	e45e                	sd	s7,8(sp)
    8000122a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000122c:	c639                	beqz	a2,8000127a <mappages+0x64>
    8000122e:	8aaa                	mv	s5,a0
    80001230:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001232:	777d                	lui	a4,0xfffff
    80001234:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001238:	fff58993          	addi	s3,a1,-1
    8000123c:	99b2                	add	s3,s3,a2
    8000123e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001242:	893e                	mv	s2,a5
    80001244:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001248:	6b85                	lui	s7,0x1
    8000124a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000124e:	4605                	li	a2,1
    80001250:	85ca                	mv	a1,s2
    80001252:	8556                	mv	a0,s5
    80001254:	00000097          	auipc	ra,0x0
    80001258:	eda080e7          	jalr	-294(ra) # 8000112e <walk>
    8000125c:	cd1d                	beqz	a0,8000129a <mappages+0x84>
    if(*pte & PTE_V)
    8000125e:	611c                	ld	a5,0(a0)
    80001260:	8b85                	andi	a5,a5,1
    80001262:	e785                	bnez	a5,8000128a <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001264:	80b1                	srli	s1,s1,0xc
    80001266:	04aa                	slli	s1,s1,0xa
    80001268:	0164e4b3          	or	s1,s1,s6
    8000126c:	0014e493          	ori	s1,s1,1
    80001270:	e104                	sd	s1,0(a0)
    if(a == last)
    80001272:	05390063          	beq	s2,s3,800012b2 <mappages+0x9c>
    a += PGSIZE;
    80001276:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001278:	bfc9                	j	8000124a <mappages+0x34>
    panic("mappages: size");
    8000127a:	00007517          	auipc	a0,0x7
    8000127e:	e4650513          	addi	a0,a0,-442 # 800080c0 <etext+0xc0>
    80001282:	fffff097          	auipc	ra,0xfffff
    80001286:	2de080e7          	jalr	734(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000128a:	00007517          	auipc	a0,0x7
    8000128e:	e4650513          	addi	a0,a0,-442 # 800080d0 <etext+0xd0>
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	2ce080e7          	jalr	718(ra) # 80000560 <panic>
      return -1;
    8000129a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000129c:	60a6                	ld	ra,72(sp)
    8000129e:	6406                	ld	s0,64(sp)
    800012a0:	74e2                	ld	s1,56(sp)
    800012a2:	7942                	ld	s2,48(sp)
    800012a4:	79a2                	ld	s3,40(sp)
    800012a6:	7a02                	ld	s4,32(sp)
    800012a8:	6ae2                	ld	s5,24(sp)
    800012aa:	6b42                	ld	s6,16(sp)
    800012ac:	6ba2                	ld	s7,8(sp)
    800012ae:	6161                	addi	sp,sp,80
    800012b0:	8082                	ret
  return 0;
    800012b2:	4501                	li	a0,0
    800012b4:	b7e5                	j	8000129c <mappages+0x86>

00000000800012b6 <kvmmap>:
{
    800012b6:	1141                	addi	sp,sp,-16
    800012b8:	e406                	sd	ra,8(sp)
    800012ba:	e022                	sd	s0,0(sp)
    800012bc:	0800                	addi	s0,sp,16
    800012be:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800012c0:	86b2                	mv	a3,a2
    800012c2:	863e                	mv	a2,a5
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f52080e7          	jalr	-174(ra) # 80001216 <mappages>
    800012cc:	e509                	bnez	a0,800012d6 <kvmmap+0x20>
}
    800012ce:	60a2                	ld	ra,8(sp)
    800012d0:	6402                	ld	s0,0(sp)
    800012d2:	0141                	addi	sp,sp,16
    800012d4:	8082                	ret
    panic("kvmmap");
    800012d6:	00007517          	auipc	a0,0x7
    800012da:	e0a50513          	addi	a0,a0,-502 # 800080e0 <etext+0xe0>
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	282080e7          	jalr	642(ra) # 80000560 <panic>

00000000800012e6 <kvmmake>:
{
    800012e6:	1101                	addi	sp,sp,-32
    800012e8:	ec06                	sd	ra,24(sp)
    800012ea:	e822                	sd	s0,16(sp)
    800012ec:	e426                	sd	s1,8(sp)
    800012ee:	e04a                	sd	s2,0(sp)
    800012f0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	936080e7          	jalr	-1738(ra) # 80000c28 <kalloc>
    800012fa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012fc:	6605                	lui	a2,0x1
    800012fe:	4581                	li	a1,0
    80001300:	00000097          	auipc	ra,0x0
    80001304:	b52080e7          	jalr	-1198(ra) # 80000e52 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001308:	4719                	li	a4,6
    8000130a:	6685                	lui	a3,0x1
    8000130c:	10000637          	lui	a2,0x10000
    80001310:	100005b7          	lui	a1,0x10000
    80001314:	8526                	mv	a0,s1
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	fa0080e7          	jalr	-96(ra) # 800012b6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000131e:	4719                	li	a4,6
    80001320:	6685                	lui	a3,0x1
    80001322:	10001637          	lui	a2,0x10001
    80001326:	100015b7          	lui	a1,0x10001
    8000132a:	8526                	mv	a0,s1
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	f8a080e7          	jalr	-118(ra) # 800012b6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001334:	4719                	li	a4,6
    80001336:	004006b7          	lui	a3,0x400
    8000133a:	0c000637          	lui	a2,0xc000
    8000133e:	0c0005b7          	lui	a1,0xc000
    80001342:	8526                	mv	a0,s1
    80001344:	00000097          	auipc	ra,0x0
    80001348:	f72080e7          	jalr	-142(ra) # 800012b6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000134c:	00007917          	auipc	s2,0x7
    80001350:	cb490913          	addi	s2,s2,-844 # 80008000 <etext>
    80001354:	4729                	li	a4,10
    80001356:	80007697          	auipc	a3,0x80007
    8000135a:	caa68693          	addi	a3,a3,-854 # 8000 <_entry-0x7fff8000>
    8000135e:	4605                	li	a2,1
    80001360:	067e                	slli	a2,a2,0x1f
    80001362:	85b2                	mv	a1,a2
    80001364:	8526                	mv	a0,s1
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	f50080e7          	jalr	-176(ra) # 800012b6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000136e:	46c5                	li	a3,17
    80001370:	06ee                	slli	a3,a3,0x1b
    80001372:	4719                	li	a4,6
    80001374:	412686b3          	sub	a3,a3,s2
    80001378:	864a                	mv	a2,s2
    8000137a:	85ca                	mv	a1,s2
    8000137c:	8526                	mv	a0,s1
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	f38080e7          	jalr	-200(ra) # 800012b6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001386:	4729                	li	a4,10
    80001388:	6685                	lui	a3,0x1
    8000138a:	00006617          	auipc	a2,0x6
    8000138e:	c7660613          	addi	a2,a2,-906 # 80007000 <_trampoline>
    80001392:	040005b7          	lui	a1,0x4000
    80001396:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001398:	05b2                	slli	a1,a1,0xc
    8000139a:	8526                	mv	a0,s1
    8000139c:	00000097          	auipc	ra,0x0
    800013a0:	f1a080e7          	jalr	-230(ra) # 800012b6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00000097          	auipc	ra,0x0
    800013aa:	78e080e7          	jalr	1934(ra) # 80001b34 <proc_mapstacks>
}
    800013ae:	8526                	mv	a0,s1
    800013b0:	60e2                	ld	ra,24(sp)
    800013b2:	6442                	ld	s0,16(sp)
    800013b4:	64a2                	ld	s1,8(sp)
    800013b6:	6902                	ld	s2,0(sp)
    800013b8:	6105                	addi	sp,sp,32
    800013ba:	8082                	ret

00000000800013bc <kvminit>:
{
    800013bc:	1141                	addi	sp,sp,-16
    800013be:	e406                	sd	ra,8(sp)
    800013c0:	e022                	sd	s0,0(sp)
    800013c2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	f22080e7          	jalr	-222(ra) # 800012e6 <kvmmake>
    800013cc:	00007797          	auipc	a5,0x7
    800013d0:	4ea7ba23          	sd	a0,1268(a5) # 800088c0 <kernel_pagetable>
}
    800013d4:	60a2                	ld	ra,8(sp)
    800013d6:	6402                	ld	s0,0(sp)
    800013d8:	0141                	addi	sp,sp,16
    800013da:	8082                	ret

00000000800013dc <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013dc:	715d                	addi	sp,sp,-80
    800013de:	e486                	sd	ra,72(sp)
    800013e0:	e0a2                	sd	s0,64(sp)
    800013e2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013e4:	03459793          	slli	a5,a1,0x34
    800013e8:	e39d                	bnez	a5,8000140e <uvmunmap+0x32>
    800013ea:	f84a                	sd	s2,48(sp)
    800013ec:	f44e                	sd	s3,40(sp)
    800013ee:	f052                	sd	s4,32(sp)
    800013f0:	ec56                	sd	s5,24(sp)
    800013f2:	e85a                	sd	s6,16(sp)
    800013f4:	e45e                	sd	s7,8(sp)
    800013f6:	8a2a                	mv	s4,a0
    800013f8:	892e                	mv	s2,a1
    800013fa:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013fc:	0632                	slli	a2,a2,0xc
    800013fe:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001402:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001404:	6b05                	lui	s6,0x1
    80001406:	0935fb63          	bgeu	a1,s3,8000149c <uvmunmap+0xc0>
    8000140a:	fc26                	sd	s1,56(sp)
    8000140c:	a8a9                	j	80001466 <uvmunmap+0x8a>
    8000140e:	fc26                	sd	s1,56(sp)
    80001410:	f84a                	sd	s2,48(sp)
    80001412:	f44e                	sd	s3,40(sp)
    80001414:	f052                	sd	s4,32(sp)
    80001416:	ec56                	sd	s5,24(sp)
    80001418:	e85a                	sd	s6,16(sp)
    8000141a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000141c:	00007517          	auipc	a0,0x7
    80001420:	ccc50513          	addi	a0,a0,-820 # 800080e8 <etext+0xe8>
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	13c080e7          	jalr	316(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000142c:	00007517          	auipc	a0,0x7
    80001430:	cd450513          	addi	a0,a0,-812 # 80008100 <etext+0x100>
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	12c080e7          	jalr	300(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000143c:	00007517          	auipc	a0,0x7
    80001440:	cd450513          	addi	a0,a0,-812 # 80008110 <etext+0x110>
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	11c080e7          	jalr	284(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000144c:	00007517          	auipc	a0,0x7
    80001450:	cdc50513          	addi	a0,a0,-804 # 80008128 <etext+0x128>
    80001454:	fffff097          	auipc	ra,0xfffff
    80001458:	10c080e7          	jalr	268(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000145c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001460:	995a                	add	s2,s2,s6
    80001462:	03397c63          	bgeu	s2,s3,8000149a <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001466:	4601                	li	a2,0
    80001468:	85ca                	mv	a1,s2
    8000146a:	8552                	mv	a0,s4
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	cc2080e7          	jalr	-830(ra) # 8000112e <walk>
    80001474:	84aa                	mv	s1,a0
    80001476:	d95d                	beqz	a0,8000142c <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001478:	6108                	ld	a0,0(a0)
    8000147a:	00157793          	andi	a5,a0,1
    8000147e:	dfdd                	beqz	a5,8000143c <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001480:	3ff57793          	andi	a5,a0,1023
    80001484:	fd7784e3          	beq	a5,s7,8000144c <uvmunmap+0x70>
    if(do_free){
    80001488:	fc0a8ae3          	beqz	s5,8000145c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000148c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000148e:	0532                	slli	a0,a0,0xc
    80001490:	fffff097          	auipc	ra,0xfffff
    80001494:	5ba080e7          	jalr	1466(ra) # 80000a4a <kfree>
    80001498:	b7d1                	j	8000145c <uvmunmap+0x80>
    8000149a:	74e2                	ld	s1,56(sp)
    8000149c:	7942                	ld	s2,48(sp)
    8000149e:	79a2                	ld	s3,40(sp)
    800014a0:	7a02                	ld	s4,32(sp)
    800014a2:	6ae2                	ld	s5,24(sp)
    800014a4:	6b42                	ld	s6,16(sp)
    800014a6:	6ba2                	ld	s7,8(sp)
  }
}
    800014a8:	60a6                	ld	ra,72(sp)
    800014aa:	6406                	ld	s0,64(sp)
    800014ac:	6161                	addi	sp,sp,80
    800014ae:	8082                	ret

00000000800014b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800014b0:	1101                	addi	sp,sp,-32
    800014b2:	ec06                	sd	ra,24(sp)
    800014b4:	e822                	sd	s0,16(sp)
    800014b6:	e426                	sd	s1,8(sp)
    800014b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800014ba:	fffff097          	auipc	ra,0xfffff
    800014be:	76e080e7          	jalr	1902(ra) # 80000c28 <kalloc>
    800014c2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800014c4:	c519                	beqz	a0,800014d2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014c6:	6605                	lui	a2,0x1
    800014c8:	4581                	li	a1,0
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	988080e7          	jalr	-1656(ra) # 80000e52 <memset>
  return pagetable;
}
    800014d2:	8526                	mv	a0,s1
    800014d4:	60e2                	ld	ra,24(sp)
    800014d6:	6442                	ld	s0,16(sp)
    800014d8:	64a2                	ld	s1,8(sp)
    800014da:	6105                	addi	sp,sp,32
    800014dc:	8082                	ret

00000000800014de <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014de:	7179                	addi	sp,sp,-48
    800014e0:	f406                	sd	ra,40(sp)
    800014e2:	f022                	sd	s0,32(sp)
    800014e4:	ec26                	sd	s1,24(sp)
    800014e6:	e84a                	sd	s2,16(sp)
    800014e8:	e44e                	sd	s3,8(sp)
    800014ea:	e052                	sd	s4,0(sp)
    800014ec:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800014ee:	6785                	lui	a5,0x1
    800014f0:	04f67863          	bgeu	a2,a5,80001540 <uvmfirst+0x62>
    800014f4:	8a2a                	mv	s4,a0
    800014f6:	89ae                	mv	s3,a1
    800014f8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800014fa:	fffff097          	auipc	ra,0xfffff
    800014fe:	72e080e7          	jalr	1838(ra) # 80000c28 <kalloc>
    80001502:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001504:	6605                	lui	a2,0x1
    80001506:	4581                	li	a1,0
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	94a080e7          	jalr	-1718(ra) # 80000e52 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001510:	4779                	li	a4,30
    80001512:	86ca                	mv	a3,s2
    80001514:	6605                	lui	a2,0x1
    80001516:	4581                	li	a1,0
    80001518:	8552                	mv	a0,s4
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	cfc080e7          	jalr	-772(ra) # 80001216 <mappages>
  memmove(mem, src, sz);
    80001522:	8626                	mv	a2,s1
    80001524:	85ce                	mv	a1,s3
    80001526:	854a                	mv	a0,s2
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	986080e7          	jalr	-1658(ra) # 80000eae <memmove>
}
    80001530:	70a2                	ld	ra,40(sp)
    80001532:	7402                	ld	s0,32(sp)
    80001534:	64e2                	ld	s1,24(sp)
    80001536:	6942                	ld	s2,16(sp)
    80001538:	69a2                	ld	s3,8(sp)
    8000153a:	6a02                	ld	s4,0(sp)
    8000153c:	6145                	addi	sp,sp,48
    8000153e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c0050513          	addi	a0,a0,-1024 # 80008140 <etext+0x140>
    80001548:	fffff097          	auipc	ra,0xfffff
    8000154c:	018080e7          	jalr	24(ra) # 80000560 <panic>

0000000080001550 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001550:	1101                	addi	sp,sp,-32
    80001552:	ec06                	sd	ra,24(sp)
    80001554:	e822                	sd	s0,16(sp)
    80001556:	e426                	sd	s1,8(sp)
    80001558:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000155a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000155c:	00b67d63          	bgeu	a2,a1,80001576 <uvmdealloc+0x26>
    80001560:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001562:	6785                	lui	a5,0x1
    80001564:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001566:	00f60733          	add	a4,a2,a5
    8000156a:	76fd                	lui	a3,0xfffff
    8000156c:	8f75                	and	a4,a4,a3
    8000156e:	97ae                	add	a5,a5,a1
    80001570:	8ff5                	and	a5,a5,a3
    80001572:	00f76863          	bltu	a4,a5,80001582 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001576:	8526                	mv	a0,s1
    80001578:	60e2                	ld	ra,24(sp)
    8000157a:	6442                	ld	s0,16(sp)
    8000157c:	64a2                	ld	s1,8(sp)
    8000157e:	6105                	addi	sp,sp,32
    80001580:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001582:	8f99                	sub	a5,a5,a4
    80001584:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001586:	4685                	li	a3,1
    80001588:	0007861b          	sext.w	a2,a5
    8000158c:	85ba                	mv	a1,a4
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	e4e080e7          	jalr	-434(ra) # 800013dc <uvmunmap>
    80001596:	b7c5                	j	80001576 <uvmdealloc+0x26>

0000000080001598 <uvmalloc>:
  if(newsz < oldsz)
    80001598:	0ab66b63          	bltu	a2,a1,8000164e <uvmalloc+0xb6>
{
    8000159c:	7139                	addi	sp,sp,-64
    8000159e:	fc06                	sd	ra,56(sp)
    800015a0:	f822                	sd	s0,48(sp)
    800015a2:	ec4e                	sd	s3,24(sp)
    800015a4:	e852                	sd	s4,16(sp)
    800015a6:	e456                	sd	s5,8(sp)
    800015a8:	0080                	addi	s0,sp,64
    800015aa:	8aaa                	mv	s5,a0
    800015ac:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800015ae:	6785                	lui	a5,0x1
    800015b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015b2:	95be                	add	a1,a1,a5
    800015b4:	77fd                	lui	a5,0xfffff
    800015b6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015ba:	08c9fc63          	bgeu	s3,a2,80001652 <uvmalloc+0xba>
    800015be:	f426                	sd	s1,40(sp)
    800015c0:	f04a                	sd	s2,32(sp)
    800015c2:	e05a                	sd	s6,0(sp)
    800015c4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015c6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	65e080e7          	jalr	1630(ra) # 80000c28 <kalloc>
    800015d2:	84aa                	mv	s1,a0
    if(mem == 0){
    800015d4:	c915                	beqz	a0,80001608 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800015d6:	6605                	lui	a2,0x1
    800015d8:	4581                	li	a1,0
    800015da:	00000097          	auipc	ra,0x0
    800015de:	878080e7          	jalr	-1928(ra) # 80000e52 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015e2:	875a                	mv	a4,s6
    800015e4:	86a6                	mv	a3,s1
    800015e6:	6605                	lui	a2,0x1
    800015e8:	85ca                	mv	a1,s2
    800015ea:	8556                	mv	a0,s5
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	c2a080e7          	jalr	-982(ra) # 80001216 <mappages>
    800015f4:	ed05                	bnez	a0,8000162c <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015f6:	6785                	lui	a5,0x1
    800015f8:	993e                	add	s2,s2,a5
    800015fa:	fd4968e3          	bltu	s2,s4,800015ca <uvmalloc+0x32>
  return newsz;
    800015fe:	8552                	mv	a0,s4
    80001600:	74a2                	ld	s1,40(sp)
    80001602:	7902                	ld	s2,32(sp)
    80001604:	6b02                	ld	s6,0(sp)
    80001606:	a821                	j	8000161e <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80001608:	864e                	mv	a2,s3
    8000160a:	85ca                	mv	a1,s2
    8000160c:	8556                	mv	a0,s5
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	f42080e7          	jalr	-190(ra) # 80001550 <uvmdealloc>
      return 0;
    80001616:	4501                	li	a0,0
    80001618:	74a2                	ld	s1,40(sp)
    8000161a:	7902                	ld	s2,32(sp)
    8000161c:	6b02                	ld	s6,0(sp)
}
    8000161e:	70e2                	ld	ra,56(sp)
    80001620:	7442                	ld	s0,48(sp)
    80001622:	69e2                	ld	s3,24(sp)
    80001624:	6a42                	ld	s4,16(sp)
    80001626:	6aa2                	ld	s5,8(sp)
    80001628:	6121                	addi	sp,sp,64
    8000162a:	8082                	ret
      kfree(mem);
    8000162c:	8526                	mv	a0,s1
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	41c080e7          	jalr	1052(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001636:	864e                	mv	a2,s3
    80001638:	85ca                	mv	a1,s2
    8000163a:	8556                	mv	a0,s5
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	f14080e7          	jalr	-236(ra) # 80001550 <uvmdealloc>
      return 0;
    80001644:	4501                	li	a0,0
    80001646:	74a2                	ld	s1,40(sp)
    80001648:	7902                	ld	s2,32(sp)
    8000164a:	6b02                	ld	s6,0(sp)
    8000164c:	bfc9                	j	8000161e <uvmalloc+0x86>
    return oldsz;
    8000164e:	852e                	mv	a0,a1
}
    80001650:	8082                	ret
  return newsz;
    80001652:	8532                	mv	a0,a2
    80001654:	b7e9                	j	8000161e <uvmalloc+0x86>

0000000080001656 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001656:	7179                	addi	sp,sp,-48
    80001658:	f406                	sd	ra,40(sp)
    8000165a:	f022                	sd	s0,32(sp)
    8000165c:	ec26                	sd	s1,24(sp)
    8000165e:	e84a                	sd	s2,16(sp)
    80001660:	e44e                	sd	s3,8(sp)
    80001662:	e052                	sd	s4,0(sp)
    80001664:	1800                	addi	s0,sp,48
    80001666:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001668:	84aa                	mv	s1,a0
    8000166a:	6905                	lui	s2,0x1
    8000166c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000166e:	4985                	li	s3,1
    80001670:	a829                	j	8000168a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001672:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001674:	00c79513          	slli	a0,a5,0xc
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	fde080e7          	jalr	-34(ra) # 80001656 <freewalk>
      pagetable[i] = 0;
    80001680:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001684:	04a1                	addi	s1,s1,8
    80001686:	03248163          	beq	s1,s2,800016a8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000168a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000168c:	00f7f713          	andi	a4,a5,15
    80001690:	ff3701e3          	beq	a4,s3,80001672 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001694:	8b85                	andi	a5,a5,1
    80001696:	d7fd                	beqz	a5,80001684 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001698:	00007517          	auipc	a0,0x7
    8000169c:	ac850513          	addi	a0,a0,-1336 # 80008160 <etext+0x160>
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	ec0080e7          	jalr	-320(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800016a8:	8552                	mv	a0,s4
    800016aa:	fffff097          	auipc	ra,0xfffff
    800016ae:	3a0080e7          	jalr	928(ra) # 80000a4a <kfree>
}
    800016b2:	70a2                	ld	ra,40(sp)
    800016b4:	7402                	ld	s0,32(sp)
    800016b6:	64e2                	ld	s1,24(sp)
    800016b8:	6942                	ld	s2,16(sp)
    800016ba:	69a2                	ld	s3,8(sp)
    800016bc:	6a02                	ld	s4,0(sp)
    800016be:	6145                	addi	sp,sp,48
    800016c0:	8082                	ret

00000000800016c2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800016c2:	1101                	addi	sp,sp,-32
    800016c4:	ec06                	sd	ra,24(sp)
    800016c6:	e822                	sd	s0,16(sp)
    800016c8:	e426                	sd	s1,8(sp)
    800016ca:	1000                	addi	s0,sp,32
    800016cc:	84aa                	mv	s1,a0
  if(sz > 0)
    800016ce:	e999                	bnez	a1,800016e4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800016d0:	8526                	mv	a0,s1
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	f84080e7          	jalr	-124(ra) # 80001656 <freewalk>
}
    800016da:	60e2                	ld	ra,24(sp)
    800016dc:	6442                	ld	s0,16(sp)
    800016de:	64a2                	ld	s1,8(sp)
    800016e0:	6105                	addi	sp,sp,32
    800016e2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800016e4:	6785                	lui	a5,0x1
    800016e6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016e8:	95be                	add	a1,a1,a5
    800016ea:	4685                	li	a3,1
    800016ec:	00c5d613          	srli	a2,a1,0xc
    800016f0:	4581                	li	a1,0
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	cea080e7          	jalr	-790(ra) # 800013dc <uvmunmap>
    800016fa:	bfd9                	j	800016d0 <uvmfree+0xe>

00000000800016fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char* mem;

  for (i = 0; i < sz; i += PGSIZE)
    800016fc:	10060863          	beqz	a2,8000180c <uvmcopy+0x110>
{
    80001700:	711d                	addi	sp,sp,-96
    80001702:	ec86                	sd	ra,88(sp)
    80001704:	e8a2                	sd	s0,80(sp)
    80001706:	e4a6                	sd	s1,72(sp)
    80001708:	e0ca                	sd	s2,64(sp)
    8000170a:	fc4e                	sd	s3,56(sp)
    8000170c:	f852                	sd	s4,48(sp)
    8000170e:	f456                	sd	s5,40(sp)
    80001710:	f05a                	sd	s6,32(sp)
    80001712:	ec5e                	sd	s7,24(sp)
    80001714:	e862                	sd	s8,16(sp)
    80001716:	e466                	sd	s9,8(sp)
    80001718:	1080                	addi	s0,sp,96
    8000171a:	8a2a                	mv	s4,a0
    8000171c:	8b2e                	mv	s6,a1
    8000171e:	8bb2                	mv	s7,a2
  for (i = 0; i < sz; i += PGSIZE)
    80001720:	4901                	li	s2,0
    flags &= ~PTE_W;
    flags |= PTE_COW;

    pa = PTE2PA(*pte);

    acquire(&reflock);
    80001722:	0000fa97          	auipc	s5,0xf
    80001726:	3fea8a93          	addi	s5,s5,1022 # 80010b20 <reflock>
    ref_count[(pa - KERNBASE) / PGSIZE] += 1;
    8000172a:	80000cb7          	lui	s9,0x80000
    8000172e:	0000fc17          	auipc	s8,0xf
    80001732:	42ac0c13          	addi	s8,s8,1066 # 80010b58 <ref_count>
    if ((pte = walk(old, i, 0)) == 0)
    80001736:	4601                	li	a2,0
    80001738:	85ca                	mv	a1,s2
    8000173a:	8552                	mv	a0,s4
    8000173c:	00000097          	auipc	ra,0x0
    80001740:	9f2080e7          	jalr	-1550(ra) # 8000112e <walk>
    80001744:	cd2d                	beqz	a0,800017be <uvmcopy+0xc2>
    if ((*pte & PTE_V) == 0)
    80001746:	6104                	ld	s1,0(a0)
    80001748:	0014f793          	andi	a5,s1,1
    8000174c:	c3c9                	beqz	a5,800017ce <uvmcopy+0xd2>
    flags &= ~PTE_W;
    8000174e:	3fb4f993          	andi	s3,s1,1019
    pa = PTE2PA(*pte);
    80001752:	80a9                	srli	s1,s1,0xa
    80001754:	04b2                	slli	s1,s1,0xc
    acquire(&reflock);
    80001756:	8556                	mv	a0,s5
    80001758:	fffff097          	auipc	ra,0xfffff
    8000175c:	5fe080e7          	jalr	1534(ra) # 80000d56 <acquire>
    ref_count[(pa - KERNBASE) / PGSIZE] += 1;
    80001760:	019487b3          	add	a5,s1,s9
    80001764:	83a9                	srli	a5,a5,0xa
    80001766:	97e2                	add	a5,a5,s8
    80001768:	4398                	lw	a4,0(a5)
    8000176a:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffbce99>
    8000176c:	c398                	sw	a4,0(a5)
    release(&reflock);
    8000176e:	8556                	mv	a0,s5
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	69a080e7          	jalr	1690(ra) # 80000e0a <release>

    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80001778:	1009e993          	ori	s3,s3,256
    8000177c:	874e                	mv	a4,s3
    8000177e:	86a6                	mv	a3,s1
    80001780:	6605                	lui	a2,0x1
    80001782:	85ca                	mv	a1,s2
    80001784:	855a                	mv	a0,s6
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	a90080e7          	jalr	-1392(ra) # 80001216 <mappages>
    8000178e:	e921                	bnez	a0,800017de <uvmcopy+0xe2>
    {
      // kfree(mem);
      goto err;
    }

    uvmunmap(old, i, 1, 0);
    80001790:	4681                	li	a3,0
    80001792:	4605                	li	a2,1
    80001794:	85ca                	mv	a1,s2
    80001796:	8552                	mv	a0,s4
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	c44080e7          	jalr	-956(ra) # 800013dc <uvmunmap>
    if (mappages(old, i, PGSIZE, pa, flags) != 0)
    800017a0:	874e                	mv	a4,s3
    800017a2:	86a6                	mv	a3,s1
    800017a4:	6605                	lui	a2,0x1
    800017a6:	85ca                	mv	a1,s2
    800017a8:	8552                	mv	a0,s4
    800017aa:	00000097          	auipc	ra,0x0
    800017ae:	a6c080e7          	jalr	-1428(ra) # 80001216 <mappages>
    800017b2:	e515                	bnez	a0,800017de <uvmcopy+0xe2>
  for (i = 0; i < sz; i += PGSIZE)
    800017b4:	6785                	lui	a5,0x1
    800017b6:	993e                	add	s2,s2,a5
    800017b8:	f7796fe3          	bltu	s2,s7,80001736 <uvmcopy+0x3a>
    800017bc:	a81d                	j	800017f2 <uvmcopy+0xf6>
      panic("uvmcopy: pte should exist");
    800017be:	00007517          	auipc	a0,0x7
    800017c2:	9b250513          	addi	a0,a0,-1614 # 80008170 <etext+0x170>
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	d9a080e7          	jalr	-614(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    800017ce:	00007517          	auipc	a0,0x7
    800017d2:	9c250513          	addi	a0,a0,-1598 # 80008190 <etext+0x190>
    800017d6:	fffff097          	auipc	ra,0xfffff
    800017da:	d8a080e7          	jalr	-630(ra) # 80000560 <panic>

  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800017de:	4685                	li	a3,1
    800017e0:	00c95613          	srli	a2,s2,0xc
    800017e4:	4581                	li	a1,0
    800017e6:	855a                	mv	a0,s6
    800017e8:	00000097          	auipc	ra,0x0
    800017ec:	bf4080e7          	jalr	-1036(ra) # 800013dc <uvmunmap>
  return -1;
    800017f0:	557d                	li	a0,-1
}
    800017f2:	60e6                	ld	ra,88(sp)
    800017f4:	6446                	ld	s0,80(sp)
    800017f6:	64a6                	ld	s1,72(sp)
    800017f8:	6906                	ld	s2,64(sp)
    800017fa:	79e2                	ld	s3,56(sp)
    800017fc:	7a42                	ld	s4,48(sp)
    800017fe:	7aa2                	ld	s5,40(sp)
    80001800:	7b02                	ld	s6,32(sp)
    80001802:	6be2                	ld	s7,24(sp)
    80001804:	6c42                	ld	s8,16(sp)
    80001806:	6ca2                	ld	s9,8(sp)
    80001808:	6125                	addi	sp,sp,96
    8000180a:	8082                	ret
  return 0;
    8000180c:	4501                	li	a0,0
}
    8000180e:	8082                	ret

0000000080001810 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001810:	1141                	addi	sp,sp,-16
    80001812:	e406                	sd	ra,8(sp)
    80001814:	e022                	sd	s0,0(sp)
    80001816:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001818:	4601                	li	a2,0
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	914080e7          	jalr	-1772(ra) # 8000112e <walk>
  if(pte == 0)
    80001822:	c901                	beqz	a0,80001832 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001824:	611c                	ld	a5,0(a0)
    80001826:	9bbd                	andi	a5,a5,-17
    80001828:	e11c                	sd	a5,0(a0)
}
    8000182a:	60a2                	ld	ra,8(sp)
    8000182c:	6402                	ld	s0,0(sp)
    8000182e:	0141                	addi	sp,sp,16
    80001830:	8082                	ret
    panic("uvmclear");
    80001832:	00007517          	auipc	a0,0x7
    80001836:	97e50513          	addi	a0,a0,-1666 # 800081b0 <etext+0x1b0>
    8000183a:	fffff097          	auipc	ra,0xfffff
    8000183e:	d26080e7          	jalr	-730(ra) # 80000560 <panic>

0000000080001842 <copyout>:
int 
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80001842:	12068063          	beqz	a3,80001962 <copyout+0x120>
{
    80001846:	7119                	addi	sp,sp,-128
    80001848:	fc86                	sd	ra,120(sp)
    8000184a:	f8a2                	sd	s0,112(sp)
    8000184c:	f4a6                	sd	s1,104(sp)
    8000184e:	ecce                	sd	s3,88(sp)
    80001850:	e4d6                	sd	s5,72(sp)
    80001852:	fc5e                	sd	s7,56(sp)
    80001854:	f862                	sd	s8,48(sp)
    80001856:	0100                	addi	s0,sp,128
    80001858:	8baa                	mv	s7,a0
    8000185a:	89ae                	mv	s3,a1
    8000185c:	8c32                	mv	s8,a2
    8000185e:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80001860:	74fd                	lui	s1,0xfffff
    80001862:	8ced                	and	s1,s1,a1

    if (va0 >= MAXVA)
    80001864:	57fd                	li	a5,-1
    80001866:	83e9                	srli	a5,a5,0x1a
    80001868:	0e97ef63          	bltu	a5,s1,80001966 <copyout+0x124>
    8000186c:	f0ca                	sd	s2,96(sp)
    8000186e:	e8d2                	sd	s4,80(sp)
    80001870:	e0da                	sd	s6,64(sp)
    80001872:	f466                	sd	s9,40(sp)
    80001874:	f06a                	sd	s10,32(sp)
    80001876:	ec6e                	sd	s11,24(sp)
    80001878:	6d05                	lui	s10,0x1

    pte_t *pte = walk(pagetable, va0, 0);
    if (va0 == 0)
    return -1;

    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    8000187a:	4dc5                	li	s11,17
    if (va0 >= MAXVA)
    8000187c:	57fd                	li	a5,-1
    8000187e:	83e9                	srli	a5,a5,0x1a
    80001880:	f8f43423          	sd	a5,-120(s0)
    80001884:	a82d                	j	800018be <copyout+0x7c>
      }

      kfree((char *)pa);
    }

    pa0 = walkaddr(pagetable, va0);
    80001886:	85a6                	mv	a1,s1
    80001888:	855e                	mv	a0,s7
    8000188a:	00000097          	auipc	ra,0x0
    8000188e:	94a080e7          	jalr	-1718(ra) # 800011d4 <walkaddr>
    if(pa0 == 0)
    80001892:	14050463          	beqz	a0,800019da <copyout+0x198>
    return -1;

    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001896:	409b0b33          	sub	s6,s6,s1
    8000189a:	000a061b          	sext.w	a2,s4
    8000189e:	85e2                	mv	a1,s8
    800018a0:	955a                	add	a0,a0,s6
    800018a2:	fffff097          	auipc	ra,0xfffff
    800018a6:	60c080e7          	jalr	1548(ra) # 80000eae <memmove>

    len -= n;
    800018aa:	414a8ab3          	sub	s5,s5,s4
    src += n;
    800018ae:	9c52                	add	s8,s8,s4
  while (len > 0)
    800018b0:	0a0a8163          	beqz	s5,80001952 <copyout+0x110>
    if (va0 >= MAXVA)
    800018b4:	f8843783          	ld	a5,-120(s0)
    800018b8:	0b37e963          	bltu	a5,s3,8000196a <copyout+0x128>
    800018bc:	84ce                	mv	s1,s3
    n = PGSIZE - (dstva - va0);
    800018be:	8b4e                	mv	s6,s3
    800018c0:	01a489b3          	add	s3,s1,s10
    800018c4:	41698a33          	sub	s4,s3,s6
    if (n > len)
    800018c8:	014af363          	bgeu	s5,s4,800018ce <copyout+0x8c>
    800018cc:	8a56                	mv	s4,s5
    pte_t *pte = walk(pagetable, va0, 0);
    800018ce:	4601                	li	a2,0
    800018d0:	85a6                	mv	a1,s1
    800018d2:	855e                	mv	a0,s7
    800018d4:	00000097          	auipc	ra,0x0
    800018d8:	85a080e7          	jalr	-1958(ra) # 8000112e <walk>
    if (va0 == 0)
    800018dc:	ccd9                	beqz	s1,8000197a <copyout+0x138>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    800018de:	cd55                	beqz	a0,8000199a <copyout+0x158>
    800018e0:	00053903          	ld	s2,0(a0)
    800018e4:	01197793          	andi	a5,s2,17
    800018e8:	0db79163          	bne	a5,s11,800019aa <copyout+0x168>
    flags = PTE_FLAGS(*pte);
    800018ec:	0009079b          	sext.w	a5,s2
    if (flags & PTE_COW)
    800018f0:	10097713          	andi	a4,s2,256
    800018f4:	db49                	beqz	a4,80001886 <copyout+0x44>
      flags &= ~PTE_COW; 
    800018f6:	2ff7f793          	andi	a5,a5,767
    800018fa:	0047e793          	ori	a5,a5,4
    800018fe:	f8f43023          	sd	a5,-128(s0)
      uint64 pa = PTE2PA(*pte);
    80001902:	00a95913          	srli	s2,s2,0xa
    80001906:	0932                	slli	s2,s2,0xc
      char* mem = kalloc();
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	320080e7          	jalr	800(ra) # 80000c28 <kalloc>
    80001910:	8caa                	mv	s9,a0
      if(mem == 0)
    80001912:	c545                	beqz	a0,800019ba <copyout+0x178>
      memmove(mem, (char *)pa, PGSIZE);
    80001914:	866a                	mv	a2,s10
    80001916:	85ca                	mv	a1,s2
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	596080e7          	jalr	1430(ra) # 80000eae <memmove>
      uvmunmap(pagetable, va0, 1, 0);
    80001920:	4681                	li	a3,0
    80001922:	4605                	li	a2,1
    80001924:	85a6                	mv	a1,s1
    80001926:	855e                	mv	a0,s7
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	ab4080e7          	jalr	-1356(ra) # 800013dc <uvmunmap>
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, flags) != 0)
    80001930:	f8043703          	ld	a4,-128(s0)
    80001934:	86e6                	mv	a3,s9
    80001936:	866a                	mv	a2,s10
    80001938:	85a6                	mv	a1,s1
    8000193a:	855e                	mv	a0,s7
    8000193c:	00000097          	auipc	ra,0x0
    80001940:	8da080e7          	jalr	-1830(ra) # 80001216 <mappages>
    80001944:	e159                	bnez	a0,800019ca <copyout+0x188>
      kfree((char *)pa);
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	102080e7          	jalr	258(ra) # 80000a4a <kfree>
    80001950:	bf1d                	j	80001886 <copyout+0x44>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80001952:	4501                	li	a0,0
    80001954:	7906                	ld	s2,96(sp)
    80001956:	6a46                	ld	s4,80(sp)
    80001958:	6b06                	ld	s6,64(sp)
    8000195a:	7ca2                	ld	s9,40(sp)
    8000195c:	7d02                	ld	s10,32(sp)
    8000195e:	6de2                	ld	s11,24(sp)
    80001960:	a025                	j	80001988 <copyout+0x146>
    80001962:	4501                	li	a0,0
}
    80001964:	8082                	ret
    return -1;
    80001966:	557d                	li	a0,-1
    80001968:	a005                	j	80001988 <copyout+0x146>
    8000196a:	557d                	li	a0,-1
    8000196c:	7906                	ld	s2,96(sp)
    8000196e:	6a46                	ld	s4,80(sp)
    80001970:	6b06                	ld	s6,64(sp)
    80001972:	7ca2                	ld	s9,40(sp)
    80001974:	7d02                	ld	s10,32(sp)
    80001976:	6de2                	ld	s11,24(sp)
    80001978:	a801                	j	80001988 <copyout+0x146>
    return -1;
    8000197a:	557d                	li	a0,-1
    8000197c:	7906                	ld	s2,96(sp)
    8000197e:	6a46                	ld	s4,80(sp)
    80001980:	6b06                	ld	s6,64(sp)
    80001982:	7ca2                	ld	s9,40(sp)
    80001984:	7d02                	ld	s10,32(sp)
    80001986:	6de2                	ld	s11,24(sp)
}
    80001988:	70e6                	ld	ra,120(sp)
    8000198a:	7446                	ld	s0,112(sp)
    8000198c:	74a6                	ld	s1,104(sp)
    8000198e:	69e6                	ld	s3,88(sp)
    80001990:	6aa6                	ld	s5,72(sp)
    80001992:	7be2                	ld	s7,56(sp)
    80001994:	7c42                	ld	s8,48(sp)
    80001996:	6109                	addi	sp,sp,128
    80001998:	8082                	ret
    return -1;
    8000199a:	557d                	li	a0,-1
    8000199c:	7906                	ld	s2,96(sp)
    8000199e:	6a46                	ld	s4,80(sp)
    800019a0:	6b06                	ld	s6,64(sp)
    800019a2:	7ca2                	ld	s9,40(sp)
    800019a4:	7d02                	ld	s10,32(sp)
    800019a6:	6de2                	ld	s11,24(sp)
    800019a8:	b7c5                	j	80001988 <copyout+0x146>
    800019aa:	557d                	li	a0,-1
    800019ac:	7906                	ld	s2,96(sp)
    800019ae:	6a46                	ld	s4,80(sp)
    800019b0:	6b06                	ld	s6,64(sp)
    800019b2:	7ca2                	ld	s9,40(sp)
    800019b4:	7d02                	ld	s10,32(sp)
    800019b6:	6de2                	ld	s11,24(sp)
    800019b8:	bfc1                	j	80001988 <copyout+0x146>
      return -1;
    800019ba:	557d                	li	a0,-1
    800019bc:	7906                	ld	s2,96(sp)
    800019be:	6a46                	ld	s4,80(sp)
    800019c0:	6b06                	ld	s6,64(sp)
    800019c2:	7ca2                	ld	s9,40(sp)
    800019c4:	7d02                	ld	s10,32(sp)
    800019c6:	6de2                	ld	s11,24(sp)
    800019c8:	b7c1                	j	80001988 <copyout+0x146>
        return -1;
    800019ca:	557d                	li	a0,-1
    800019cc:	7906                	ld	s2,96(sp)
    800019ce:	6a46                	ld	s4,80(sp)
    800019d0:	6b06                	ld	s6,64(sp)
    800019d2:	7ca2                	ld	s9,40(sp)
    800019d4:	7d02                	ld	s10,32(sp)
    800019d6:	6de2                	ld	s11,24(sp)
    800019d8:	bf45                	j	80001988 <copyout+0x146>
    return -1;
    800019da:	557d                	li	a0,-1
    800019dc:	7906                	ld	s2,96(sp)
    800019de:	6a46                	ld	s4,80(sp)
    800019e0:	6b06                	ld	s6,64(sp)
    800019e2:	7ca2                	ld	s9,40(sp)
    800019e4:	7d02                	ld	s10,32(sp)
    800019e6:	6de2                	ld	s11,24(sp)
    800019e8:	b745                	j	80001988 <copyout+0x146>

00000000800019ea <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800019ea:	caa5                	beqz	a3,80001a5a <copyin+0x70>
{
    800019ec:	715d                	addi	sp,sp,-80
    800019ee:	e486                	sd	ra,72(sp)
    800019f0:	e0a2                	sd	s0,64(sp)
    800019f2:	fc26                	sd	s1,56(sp)
    800019f4:	f84a                	sd	s2,48(sp)
    800019f6:	f44e                	sd	s3,40(sp)
    800019f8:	f052                	sd	s4,32(sp)
    800019fa:	ec56                	sd	s5,24(sp)
    800019fc:	e85a                	sd	s6,16(sp)
    800019fe:	e45e                	sd	s7,8(sp)
    80001a00:	e062                	sd	s8,0(sp)
    80001a02:	0880                	addi	s0,sp,80
    80001a04:	8b2a                	mv	s6,a0
    80001a06:	8a2e                	mv	s4,a1
    80001a08:	8c32                	mv	s8,a2
    80001a0a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a0c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a0e:	6a85                	lui	s5,0x1
    80001a10:	a01d                	j	80001a36 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a12:	018505b3          	add	a1,a0,s8
    80001a16:	0004861b          	sext.w	a2,s1
    80001a1a:	412585b3          	sub	a1,a1,s2
    80001a1e:	8552                	mv	a0,s4
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	48e080e7          	jalr	1166(ra) # 80000eae <memmove>

    len -= n;
    80001a28:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a2c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a2e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a32:	02098263          	beqz	s3,80001a56 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a36:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	855a                	mv	a0,s6
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	796080e7          	jalr	1942(ra) # 800011d4 <walkaddr>
    if(pa0 == 0)
    80001a46:	cd01                	beqz	a0,80001a5e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a48:	418904b3          	sub	s1,s2,s8
    80001a4c:	94d6                	add	s1,s1,s5
    if(n > len)
    80001a4e:	fc99f2e3          	bgeu	s3,s1,80001a12 <copyin+0x28>
    80001a52:	84ce                	mv	s1,s3
    80001a54:	bf7d                	j	80001a12 <copyin+0x28>
  }
  return 0;
    80001a56:	4501                	li	a0,0
    80001a58:	a021                	j	80001a60 <copyin+0x76>
    80001a5a:	4501                	li	a0,0
}
    80001a5c:	8082                	ret
      return -1;
    80001a5e:	557d                	li	a0,-1
}
    80001a60:	60a6                	ld	ra,72(sp)
    80001a62:	6406                	ld	s0,64(sp)
    80001a64:	74e2                	ld	s1,56(sp)
    80001a66:	7942                	ld	s2,48(sp)
    80001a68:	79a2                	ld	s3,40(sp)
    80001a6a:	7a02                	ld	s4,32(sp)
    80001a6c:	6ae2                	ld	s5,24(sp)
    80001a6e:	6b42                	ld	s6,16(sp)
    80001a70:	6ba2                	ld	s7,8(sp)
    80001a72:	6c02                	ld	s8,0(sp)
    80001a74:	6161                	addi	sp,sp,80
    80001a76:	8082                	ret

0000000080001a78 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001a78:	cacd                	beqz	a3,80001b2a <copyinstr+0xb2>
{
    80001a7a:	715d                	addi	sp,sp,-80
    80001a7c:	e486                	sd	ra,72(sp)
    80001a7e:	e0a2                	sd	s0,64(sp)
    80001a80:	fc26                	sd	s1,56(sp)
    80001a82:	f84a                	sd	s2,48(sp)
    80001a84:	f44e                	sd	s3,40(sp)
    80001a86:	f052                	sd	s4,32(sp)
    80001a88:	ec56                	sd	s5,24(sp)
    80001a8a:	e85a                	sd	s6,16(sp)
    80001a8c:	e45e                	sd	s7,8(sp)
    80001a8e:	0880                	addi	s0,sp,80
    80001a90:	8a2a                	mv	s4,a0
    80001a92:	8b2e                	mv	s6,a1
    80001a94:	8bb2                	mv	s7,a2
    80001a96:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001a98:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a9a:	6985                	lui	s3,0x1
    80001a9c:	a825                	j	80001ad4 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001a9e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001aa2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001aa4:	37fd                	addiw	a5,a5,-1
    80001aa6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001aaa:	60a6                	ld	ra,72(sp)
    80001aac:	6406                	ld	s0,64(sp)
    80001aae:	74e2                	ld	s1,56(sp)
    80001ab0:	7942                	ld	s2,48(sp)
    80001ab2:	79a2                	ld	s3,40(sp)
    80001ab4:	7a02                	ld	s4,32(sp)
    80001ab6:	6ae2                	ld	s5,24(sp)
    80001ab8:	6b42                	ld	s6,16(sp)
    80001aba:	6ba2                	ld	s7,8(sp)
    80001abc:	6161                	addi	sp,sp,80
    80001abe:	8082                	ret
    80001ac0:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001ac4:	9742                	add	a4,a4,a6
      --max;
    80001ac6:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001aca:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001ace:	04e58663          	beq	a1,a4,80001b1a <copyinstr+0xa2>
{
    80001ad2:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001ad4:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001ad8:	85a6                	mv	a1,s1
    80001ada:	8552                	mv	a0,s4
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	6f8080e7          	jalr	1784(ra) # 800011d4 <walkaddr>
    if(pa0 == 0)
    80001ae4:	cd0d                	beqz	a0,80001b1e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001ae6:	417486b3          	sub	a3,s1,s7
    80001aea:	96ce                	add	a3,a3,s3
    if(n > max)
    80001aec:	00d97363          	bgeu	s2,a3,80001af2 <copyinstr+0x7a>
    80001af0:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001af2:	955e                	add	a0,a0,s7
    80001af4:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001af6:	c695                	beqz	a3,80001b22 <copyinstr+0xaa>
    80001af8:	87da                	mv	a5,s6
    80001afa:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001afc:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001b00:	96da                	add	a3,a3,s6
    80001b02:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001b04:	00f60733          	add	a4,a2,a5
    80001b08:	00074703          	lbu	a4,0(a4)
    80001b0c:	db49                	beqz	a4,80001a9e <copyinstr+0x26>
        *dst = *p;
    80001b0e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001b12:	0785                	addi	a5,a5,1
    while(n > 0){
    80001b14:	fed797e3          	bne	a5,a3,80001b02 <copyinstr+0x8a>
    80001b18:	b765                	j	80001ac0 <copyinstr+0x48>
    80001b1a:	4781                	li	a5,0
    80001b1c:	b761                	j	80001aa4 <copyinstr+0x2c>
      return -1;
    80001b1e:	557d                	li	a0,-1
    80001b20:	b769                	j	80001aaa <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001b22:	6b85                	lui	s7,0x1
    80001b24:	9ba6                	add	s7,s7,s1
    80001b26:	87da                	mv	a5,s6
    80001b28:	b76d                	j	80001ad2 <copyinstr+0x5a>
  int got_null = 0;
    80001b2a:	4781                	li	a5,0
  if(got_null){
    80001b2c:	37fd                	addiw	a5,a5,-1
    80001b2e:	0007851b          	sext.w	a0,a5
}
    80001b32:	8082                	ret

0000000080001b34 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001b34:	7139                	addi	sp,sp,-64
    80001b36:	fc06                	sd	ra,56(sp)
    80001b38:	f822                	sd	s0,48(sp)
    80001b3a:	f426                	sd	s1,40(sp)
    80001b3c:	f04a                	sd	s2,32(sp)
    80001b3e:	ec4e                	sd	s3,24(sp)
    80001b40:	e852                	sd	s4,16(sp)
    80001b42:	e456                	sd	s5,8(sp)
    80001b44:	e05a                	sd	s6,0(sp)
    80001b46:	0080                	addi	s0,sp,64
    80001b48:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001b4a:	0002f497          	auipc	s1,0x2f
    80001b4e:	43e48493          	addi	s1,s1,1086 # 80030f88 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001b52:	8b26                	mv	s6,s1
    80001b54:	00a36937          	lui	s2,0xa36
    80001b58:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001b5c:	0932                	slli	s2,s2,0xc
    80001b5e:	46d90913          	addi	s2,s2,1133
    80001b62:	0936                	slli	s2,s2,0xd
    80001b64:	df590913          	addi	s2,s2,-523
    80001b68:	093a                	slli	s2,s2,0xe
    80001b6a:	6cf90913          	addi	s2,s2,1743
    80001b6e:	040009b7          	lui	s3,0x4000
    80001b72:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b74:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b76:	00035a97          	auipc	s5,0x35
    80001b7a:	212a8a93          	addi	s5,s5,530 # 80036d88 <tickslock>
    char *pa = kalloc();
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	0aa080e7          	jalr	170(ra) # 80000c28 <kalloc>
    80001b86:	862a                	mv	a2,a0
    if (pa == 0)
    80001b88:	c121                	beqz	a0,80001bc8 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80001b8a:	416485b3          	sub	a1,s1,s6
    80001b8e:	858d                	srai	a1,a1,0x3
    80001b90:	032585b3          	mul	a1,a1,s2
    80001b94:	2585                	addiw	a1,a1,1
    80001b96:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b9a:	4719                	li	a4,6
    80001b9c:	6685                	lui	a3,0x1
    80001b9e:	40b985b3          	sub	a1,s3,a1
    80001ba2:	8552                	mv	a0,s4
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	712080e7          	jalr	1810(ra) # 800012b6 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001bac:	17848493          	addi	s1,s1,376
    80001bb0:	fd5497e3          	bne	s1,s5,80001b7e <proc_mapstacks+0x4a>
  }
}
    80001bb4:	70e2                	ld	ra,56(sp)
    80001bb6:	7442                	ld	s0,48(sp)
    80001bb8:	74a2                	ld	s1,40(sp)
    80001bba:	7902                	ld	s2,32(sp)
    80001bbc:	69e2                	ld	s3,24(sp)
    80001bbe:	6a42                	ld	s4,16(sp)
    80001bc0:	6aa2                	ld	s5,8(sp)
    80001bc2:	6b02                	ld	s6,0(sp)
    80001bc4:	6121                	addi	sp,sp,64
    80001bc6:	8082                	ret
      panic("kalloc");
    80001bc8:	00006517          	auipc	a0,0x6
    80001bcc:	5f850513          	addi	a0,a0,1528 # 800081c0 <etext+0x1c0>
    80001bd0:	fffff097          	auipc	ra,0xfffff
    80001bd4:	990080e7          	jalr	-1648(ra) # 80000560 <panic>

0000000080001bd8 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001bd8:	7139                	addi	sp,sp,-64
    80001bda:	fc06                	sd	ra,56(sp)
    80001bdc:	f822                	sd	s0,48(sp)
    80001bde:	f426                	sd	s1,40(sp)
    80001be0:	f04a                	sd	s2,32(sp)
    80001be2:	ec4e                	sd	s3,24(sp)
    80001be4:	e852                	sd	s4,16(sp)
    80001be6:	e456                	sd	s5,8(sp)
    80001be8:	e05a                	sd	s6,0(sp)
    80001bea:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001bec:	00006597          	auipc	a1,0x6
    80001bf0:	5dc58593          	addi	a1,a1,1500 # 800081c8 <etext+0x1c8>
    80001bf4:	0002f517          	auipc	a0,0x2f
    80001bf8:	f6450513          	addi	a0,a0,-156 # 80030b58 <pid_lock>
    80001bfc:	fffff097          	auipc	ra,0xfffff
    80001c00:	0ca080e7          	jalr	202(ra) # 80000cc6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001c04:	00006597          	auipc	a1,0x6
    80001c08:	5cc58593          	addi	a1,a1,1484 # 800081d0 <etext+0x1d0>
    80001c0c:	0002f517          	auipc	a0,0x2f
    80001c10:	f6450513          	addi	a0,a0,-156 # 80030b70 <wait_lock>
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	0b2080e7          	jalr	178(ra) # 80000cc6 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001c1c:	0002f497          	auipc	s1,0x2f
    80001c20:	36c48493          	addi	s1,s1,876 # 80030f88 <proc>
  {
    initlock(&p->lock, "proc");
    80001c24:	00006b17          	auipc	s6,0x6
    80001c28:	5bcb0b13          	addi	s6,s6,1468 # 800081e0 <etext+0x1e0>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001c2c:	8aa6                	mv	s5,s1
    80001c2e:	00a36937          	lui	s2,0xa36
    80001c32:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001c36:	0932                	slli	s2,s2,0xc
    80001c38:	46d90913          	addi	s2,s2,1133
    80001c3c:	0936                	slli	s2,s2,0xd
    80001c3e:	df590913          	addi	s2,s2,-523
    80001c42:	093a                	slli	s2,s2,0xe
    80001c44:	6cf90913          	addi	s2,s2,1743
    80001c48:	040009b7          	lui	s3,0x4000
    80001c4c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c4e:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001c50:	00035a17          	auipc	s4,0x35
    80001c54:	138a0a13          	addi	s4,s4,312 # 80036d88 <tickslock>
    initlock(&p->lock, "proc");
    80001c58:	85da                	mv	a1,s6
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	06a080e7          	jalr	106(ra) # 80000cc6 <initlock>
    p->state = UNUSED;
    80001c64:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001c68:	415487b3          	sub	a5,s1,s5
    80001c6c:	878d                	srai	a5,a5,0x3
    80001c6e:	032787b3          	mul	a5,a5,s2
    80001c72:	2785                	addiw	a5,a5,1
    80001c74:	00d7979b          	slliw	a5,a5,0xd
    80001c78:	40f987b3          	sub	a5,s3,a5
    80001c7c:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001c7e:	17848493          	addi	s1,s1,376
    80001c82:	fd449be3          	bne	s1,s4,80001c58 <procinit+0x80>
  }
}
    80001c86:	70e2                	ld	ra,56(sp)
    80001c88:	7442                	ld	s0,48(sp)
    80001c8a:	74a2                	ld	s1,40(sp)
    80001c8c:	7902                	ld	s2,32(sp)
    80001c8e:	69e2                	ld	s3,24(sp)
    80001c90:	6a42                	ld	s4,16(sp)
    80001c92:	6aa2                	ld	s5,8(sp)
    80001c94:	6b02                	ld	s6,0(sp)
    80001c96:	6121                	addi	sp,sp,64
    80001c98:	8082                	ret

0000000080001c9a <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001c9a:	1141                	addi	sp,sp,-16
    80001c9c:	e422                	sd	s0,8(sp)
    80001c9e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ca0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ca2:	2501                	sext.w	a0,a0
    80001ca4:	6422                	ld	s0,8(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e422                	sd	s0,8(sp)
    80001cae:	0800                	addi	s0,sp,16
    80001cb0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001cb2:	2781                	sext.w	a5,a5
    80001cb4:	079e                	slli	a5,a5,0x7
  return c;
}
    80001cb6:	0002f517          	auipc	a0,0x2f
    80001cba:	ed250513          	addi	a0,a0,-302 # 80030b88 <cpus>
    80001cbe:	953e                	add	a0,a0,a5
    80001cc0:	6422                	ld	s0,8(sp)
    80001cc2:	0141                	addi	sp,sp,16
    80001cc4:	8082                	ret

0000000080001cc6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001cc6:	1101                	addi	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	1000                	addi	s0,sp,32
  push_off();
    80001cd0:	fffff097          	auipc	ra,0xfffff
    80001cd4:	03a080e7          	jalr	58(ra) # 80000d0a <push_off>
    80001cd8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001cda:	2781                	sext.w	a5,a5
    80001cdc:	079e                	slli	a5,a5,0x7
    80001cde:	0002f717          	auipc	a4,0x2f
    80001ce2:	e7a70713          	addi	a4,a4,-390 # 80030b58 <pid_lock>
    80001ce6:	97ba                	add	a5,a5,a4
    80001ce8:	7b84                	ld	s1,48(a5)
  pop_off();
    80001cea:	fffff097          	auipc	ra,0xfffff
    80001cee:	0c0080e7          	jalr	192(ra) # 80000daa <pop_off>
  return p;
}
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	60e2                	ld	ra,24(sp)
    80001cf6:	6442                	ld	s0,16(sp)
    80001cf8:	64a2                	ld	s1,8(sp)
    80001cfa:	6105                	addi	sp,sp,32
    80001cfc:	8082                	ret

0000000080001cfe <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001cfe:	1141                	addi	sp,sp,-16
    80001d00:	e406                	sd	ra,8(sp)
    80001d02:	e022                	sd	s0,0(sp)
    80001d04:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	fc0080e7          	jalr	-64(ra) # 80001cc6 <myproc>
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	0fc080e7          	jalr	252(ra) # 80000e0a <release>

  if (first)
    80001d16:	00007797          	auipc	a5,0x7
    80001d1a:	b3a7a783          	lw	a5,-1222(a5) # 80008850 <first.1>
    80001d1e:	eb89                	bnez	a5,80001d30 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001d20:	00001097          	auipc	ra,0x1
    80001d24:	e28080e7          	jalr	-472(ra) # 80002b48 <usertrapret>
}
    80001d28:	60a2                	ld	ra,8(sp)
    80001d2a:	6402                	ld	s0,0(sp)
    80001d2c:	0141                	addi	sp,sp,16
    80001d2e:	8082                	ret
    first = 0;
    80001d30:	00007797          	auipc	a5,0x7
    80001d34:	b207a023          	sw	zero,-1248(a5) # 80008850 <first.1>
    fsinit(ROOTDEV);
    80001d38:	4505                	li	a0,1
    80001d3a:	00002097          	auipc	ra,0x2
    80001d3e:	d30080e7          	jalr	-720(ra) # 80003a6a <fsinit>
    80001d42:	bff9                	j	80001d20 <forkret+0x22>

0000000080001d44 <allocpid>:
{
    80001d44:	1101                	addi	sp,sp,-32
    80001d46:	ec06                	sd	ra,24(sp)
    80001d48:	e822                	sd	s0,16(sp)
    80001d4a:	e426                	sd	s1,8(sp)
    80001d4c:	e04a                	sd	s2,0(sp)
    80001d4e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d50:	0002f917          	auipc	s2,0x2f
    80001d54:	e0890913          	addi	s2,s2,-504 # 80030b58 <pid_lock>
    80001d58:	854a                	mv	a0,s2
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	ffc080e7          	jalr	-4(ra) # 80000d56 <acquire>
  pid = nextpid;
    80001d62:	00007797          	auipc	a5,0x7
    80001d66:	af278793          	addi	a5,a5,-1294 # 80008854 <nextpid>
    80001d6a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d6c:	0014871b          	addiw	a4,s1,1
    80001d70:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d72:	854a                	mv	a0,s2
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	096080e7          	jalr	150(ra) # 80000e0a <release>
}
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	64a2                	ld	s1,8(sp)
    80001d84:	6902                	ld	s2,0(sp)
    80001d86:	6105                	addi	sp,sp,32
    80001d88:	8082                	ret

0000000080001d8a <proc_pagetable>:
{
    80001d8a:	1101                	addi	sp,sp,-32
    80001d8c:	ec06                	sd	ra,24(sp)
    80001d8e:	e822                	sd	s0,16(sp)
    80001d90:	e426                	sd	s1,8(sp)
    80001d92:	e04a                	sd	s2,0(sp)
    80001d94:	1000                	addi	s0,sp,32
    80001d96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	718080e7          	jalr	1816(ra) # 800014b0 <uvmcreate>
    80001da0:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001da2:	c121                	beqz	a0,80001de2 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001da4:	4729                	li	a4,10
    80001da6:	00005697          	auipc	a3,0x5
    80001daa:	25a68693          	addi	a3,a3,602 # 80007000 <_trampoline>
    80001dae:	6605                	lui	a2,0x1
    80001db0:	040005b7          	lui	a1,0x4000
    80001db4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001db6:	05b2                	slli	a1,a1,0xc
    80001db8:	fffff097          	auipc	ra,0xfffff
    80001dbc:	45e080e7          	jalr	1118(ra) # 80001216 <mappages>
    80001dc0:	02054863          	bltz	a0,80001df0 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001dc4:	4719                	li	a4,6
    80001dc6:	05893683          	ld	a3,88(s2)
    80001dca:	6605                	lui	a2,0x1
    80001dcc:	020005b7          	lui	a1,0x2000
    80001dd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001dd2:	05b6                	slli	a1,a1,0xd
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	440080e7          	jalr	1088(ra) # 80001216 <mappages>
    80001dde:	02054163          	bltz	a0,80001e00 <proc_pagetable+0x76>
}
    80001de2:	8526                	mv	a0,s1
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	64a2                	ld	s1,8(sp)
    80001dea:	6902                	ld	s2,0(sp)
    80001dec:	6105                	addi	sp,sp,32
    80001dee:	8082                	ret
    uvmfree(pagetable, 0);
    80001df0:	4581                	li	a1,0
    80001df2:	8526                	mv	a0,s1
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	8ce080e7          	jalr	-1842(ra) # 800016c2 <uvmfree>
    return 0;
    80001dfc:	4481                	li	s1,0
    80001dfe:	b7d5                	j	80001de2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e00:	4681                	li	a3,0
    80001e02:	4605                	li	a2,1
    80001e04:	040005b7          	lui	a1,0x4000
    80001e08:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e0a:	05b2                	slli	a1,a1,0xc
    80001e0c:	8526                	mv	a0,s1
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	5ce080e7          	jalr	1486(ra) # 800013dc <uvmunmap>
    uvmfree(pagetable, 0);
    80001e16:	4581                	li	a1,0
    80001e18:	8526                	mv	a0,s1
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	8a8080e7          	jalr	-1880(ra) # 800016c2 <uvmfree>
    return 0;
    80001e22:	4481                	li	s1,0
    80001e24:	bf7d                	j	80001de2 <proc_pagetable+0x58>

0000000080001e26 <proc_freepagetable>:
{
    80001e26:	1101                	addi	sp,sp,-32
    80001e28:	ec06                	sd	ra,24(sp)
    80001e2a:	e822                	sd	s0,16(sp)
    80001e2c:	e426                	sd	s1,8(sp)
    80001e2e:	e04a                	sd	s2,0(sp)
    80001e30:	1000                	addi	s0,sp,32
    80001e32:	84aa                	mv	s1,a0
    80001e34:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e36:	4681                	li	a3,0
    80001e38:	4605                	li	a2,1
    80001e3a:	040005b7          	lui	a1,0x4000
    80001e3e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e40:	05b2                	slli	a1,a1,0xc
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	59a080e7          	jalr	1434(ra) # 800013dc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e4a:	4681                	li	a3,0
    80001e4c:	4605                	li	a2,1
    80001e4e:	020005b7          	lui	a1,0x2000
    80001e52:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e54:	05b6                	slli	a1,a1,0xd
    80001e56:	8526                	mv	a0,s1
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	584080e7          	jalr	1412(ra) # 800013dc <uvmunmap>
  uvmfree(pagetable, sz);
    80001e60:	85ca                	mv	a1,s2
    80001e62:	8526                	mv	a0,s1
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	85e080e7          	jalr	-1954(ra) # 800016c2 <uvmfree>
}
    80001e6c:	60e2                	ld	ra,24(sp)
    80001e6e:	6442                	ld	s0,16(sp)
    80001e70:	64a2                	ld	s1,8(sp)
    80001e72:	6902                	ld	s2,0(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <freeproc>:
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
    80001e82:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001e84:	6d28                	ld	a0,88(a0)
    80001e86:	c509                	beqz	a0,80001e90 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	bc2080e7          	jalr	-1086(ra) # 80000a4a <kfree>
  p->trapframe = 0;
    80001e90:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001e94:	68a8                	ld	a0,80(s1)
    80001e96:	c511                	beqz	a0,80001ea2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e98:	64ac                	ld	a1,72(s1)
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	f8c080e7          	jalr	-116(ra) # 80001e26 <proc_freepagetable>
  p->pagetable = 0;
    80001ea2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ea6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001eaa:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001eae:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001eb2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001eb6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001eba:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ebe:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ec2:	0004ac23          	sw	zero,24(s1)
}
    80001ec6:	60e2                	ld	ra,24(sp)
    80001ec8:	6442                	ld	s0,16(sp)
    80001eca:	64a2                	ld	s1,8(sp)
    80001ecc:	6105                	addi	sp,sp,32
    80001ece:	8082                	ret

0000000080001ed0 <allocproc>:
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	e04a                	sd	s2,0(sp)
    80001eda:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001edc:	0002f497          	auipc	s1,0x2f
    80001ee0:	0ac48493          	addi	s1,s1,172 # 80030f88 <proc>
    80001ee4:	00035917          	auipc	s2,0x35
    80001ee8:	ea490913          	addi	s2,s2,-348 # 80036d88 <tickslock>
    acquire(&p->lock);
    80001eec:	8526                	mv	a0,s1
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	e68080e7          	jalr	-408(ra) # 80000d56 <acquire>
    if (p->state == UNUSED)
    80001ef6:	4c9c                	lw	a5,24(s1)
    80001ef8:	cf81                	beqz	a5,80001f10 <allocproc+0x40>
      release(&p->lock);
    80001efa:	8526                	mv	a0,s1
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	f0e080e7          	jalr	-242(ra) # 80000e0a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001f04:	17848493          	addi	s1,s1,376
    80001f08:	ff2492e3          	bne	s1,s2,80001eec <allocproc+0x1c>
  return 0;
    80001f0c:	4481                	li	s1,0
    80001f0e:	a09d                	j	80001f74 <allocproc+0xa4>
  p->pid = allocpid();
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	e34080e7          	jalr	-460(ra) # 80001d44 <allocpid>
    80001f18:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001f1a:	4785                	li	a5,1
    80001f1c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	d0a080e7          	jalr	-758(ra) # 80000c28 <kalloc>
    80001f26:	892a                	mv	s2,a0
    80001f28:	eca8                	sd	a0,88(s1)
    80001f2a:	cd21                	beqz	a0,80001f82 <allocproc+0xb2>
  p->pagetable = proc_pagetable(p);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	e5c080e7          	jalr	-420(ra) # 80001d8a <proc_pagetable>
    80001f36:	892a                	mv	s2,a0
    80001f38:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001f3a:	c125                	beqz	a0,80001f9a <allocproc+0xca>
  memset(&p->context, 0, sizeof(p->context));
    80001f3c:	07000613          	li	a2,112
    80001f40:	4581                	li	a1,0
    80001f42:	06048513          	addi	a0,s1,96
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	f0c080e7          	jalr	-244(ra) # 80000e52 <memset>
  p->context.ra = (uint64)forkret;
    80001f4e:	00000797          	auipc	a5,0x0
    80001f52:	db078793          	addi	a5,a5,-592 # 80001cfe <forkret>
    80001f56:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f58:	60bc                	ld	a5,64(s1)
    80001f5a:	6705                	lui	a4,0x1
    80001f5c:	97ba                	add	a5,a5,a4
    80001f5e:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001f60:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001f64:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001f68:	00007797          	auipc	a5,0x7
    80001f6c:	9687a783          	lw	a5,-1688(a5) # 800088d0 <ticks>
    80001f70:	16f4a623          	sw	a5,364(s1)
}
    80001f74:	8526                	mv	a0,s1
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6902                	ld	s2,0(sp)
    80001f7e:	6105                	addi	sp,sp,32
    80001f80:	8082                	ret
    freeproc(p);
    80001f82:	8526                	mv	a0,s1
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	ef4080e7          	jalr	-268(ra) # 80001e78 <freeproc>
    release(&p->lock);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	e7c080e7          	jalr	-388(ra) # 80000e0a <release>
    return 0;
    80001f96:	84ca                	mv	s1,s2
    80001f98:	bff1                	j	80001f74 <allocproc+0xa4>
    freeproc(p);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	edc080e7          	jalr	-292(ra) # 80001e78 <freeproc>
    release(&p->lock);
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	e64080e7          	jalr	-412(ra) # 80000e0a <release>
    return 0;
    80001fae:	84ca                	mv	s1,s2
    80001fb0:	b7d1                	j	80001f74 <allocproc+0xa4>

0000000080001fb2 <userinit>:
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	1000                	addi	s0,sp,32
  p = allocproc();
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	f14080e7          	jalr	-236(ra) # 80001ed0 <allocproc>
    80001fc4:	84aa                	mv	s1,a0
  initproc = p;
    80001fc6:	00007797          	auipc	a5,0x7
    80001fca:	90a7b123          	sd	a0,-1790(a5) # 800088c8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001fce:	03400613          	li	a2,52
    80001fd2:	00007597          	auipc	a1,0x7
    80001fd6:	88e58593          	addi	a1,a1,-1906 # 80008860 <initcode>
    80001fda:	6928                	ld	a0,80(a0)
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	502080e7          	jalr	1282(ra) # 800014de <uvmfirst>
  p->sz = PGSIZE;
    80001fe4:	6785                	lui	a5,0x1
    80001fe6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001fe8:	6cb8                	ld	a4,88(s1)
    80001fea:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001fee:	6cb8                	ld	a4,88(s1)
    80001ff0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ff2:	4641                	li	a2,16
    80001ff4:	00006597          	auipc	a1,0x6
    80001ff8:	1f458593          	addi	a1,a1,500 # 800081e8 <etext+0x1e8>
    80001ffc:	15848513          	addi	a0,s1,344
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	f94080e7          	jalr	-108(ra) # 80000f94 <safestrcpy>
  p->cwd = namei("/");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	1f050513          	addi	a0,a0,496 # 800081f8 <etext+0x1f8>
    80002010:	00002097          	auipc	ra,0x2
    80002014:	4ac080e7          	jalr	1196(ra) # 800044bc <namei>
    80002018:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000201c:	478d                	li	a5,3
    8000201e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002020:	8526                	mv	a0,s1
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	de8080e7          	jalr	-536(ra) # 80000e0a <release>
}
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	64a2                	ld	s1,8(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret

0000000080002034 <growproc>:
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002042:	00000097          	auipc	ra,0x0
    80002046:	c84080e7          	jalr	-892(ra) # 80001cc6 <myproc>
    8000204a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000204c:	652c                	ld	a1,72(a0)
  if (n > 0)
    8000204e:	01204c63          	bgtz	s2,80002066 <growproc+0x32>
  else if (n < 0)
    80002052:	02094663          	bltz	s2,8000207e <growproc+0x4a>
  p->sz = sz;
    80002056:	e4ac                	sd	a1,72(s1)
  return 0;
    80002058:	4501                	li	a0,0
}
    8000205a:	60e2                	ld	ra,24(sp)
    8000205c:	6442                	ld	s0,16(sp)
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	6902                	ld	s2,0(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002066:	4691                	li	a3,4
    80002068:	00b90633          	add	a2,s2,a1
    8000206c:	6928                	ld	a0,80(a0)
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	52a080e7          	jalr	1322(ra) # 80001598 <uvmalloc>
    80002076:	85aa                	mv	a1,a0
    80002078:	fd79                	bnez	a0,80002056 <growproc+0x22>
      return -1;
    8000207a:	557d                	li	a0,-1
    8000207c:	bff9                	j	8000205a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000207e:	00b90633          	add	a2,s2,a1
    80002082:	6928                	ld	a0,80(a0)
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	4cc080e7          	jalr	1228(ra) # 80001550 <uvmdealloc>
    8000208c:	85aa                	mv	a1,a0
    8000208e:	b7e1                	j	80002056 <growproc+0x22>

0000000080002090 <fork>:
{
    80002090:	7139                	addi	sp,sp,-64
    80002092:	fc06                	sd	ra,56(sp)
    80002094:	f822                	sd	s0,48(sp)
    80002096:	f04a                	sd	s2,32(sp)
    80002098:	e456                	sd	s5,8(sp)
    8000209a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000209c:	00000097          	auipc	ra,0x0
    800020a0:	c2a080e7          	jalr	-982(ra) # 80001cc6 <myproc>
    800020a4:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	e2a080e7          	jalr	-470(ra) # 80001ed0 <allocproc>
    800020ae:	12050063          	beqz	a0,800021ce <fork+0x13e>
    800020b2:	e852                	sd	s4,16(sp)
    800020b4:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800020b6:	048ab603          	ld	a2,72(s5)
    800020ba:	692c                	ld	a1,80(a0)
    800020bc:	050ab503          	ld	a0,80(s5)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	63c080e7          	jalr	1596(ra) # 800016fc <uvmcopy>
    800020c8:	04054a63          	bltz	a0,8000211c <fork+0x8c>
    800020cc:	f426                	sd	s1,40(sp)
    800020ce:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800020d0:	048ab783          	ld	a5,72(s5)
    800020d4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800020d8:	058ab683          	ld	a3,88(s5)
    800020dc:	87b6                	mv	a5,a3
    800020de:	058a3703          	ld	a4,88(s4)
    800020e2:	12068693          	addi	a3,a3,288
    800020e6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800020ea:	6788                	ld	a0,8(a5)
    800020ec:	6b8c                	ld	a1,16(a5)
    800020ee:	6f90                	ld	a2,24(a5)
    800020f0:	01073023          	sd	a6,0(a4)
    800020f4:	e708                	sd	a0,8(a4)
    800020f6:	eb0c                	sd	a1,16(a4)
    800020f8:	ef10                	sd	a2,24(a4)
    800020fa:	02078793          	addi	a5,a5,32
    800020fe:	02070713          	addi	a4,a4,32
    80002102:	fed792e3          	bne	a5,a3,800020e6 <fork+0x56>
  np->trapframe->a0 = 0;
    80002106:	058a3783          	ld	a5,88(s4)
    8000210a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000210e:	0d0a8493          	addi	s1,s5,208
    80002112:	0d0a0913          	addi	s2,s4,208
    80002116:	150a8993          	addi	s3,s5,336
    8000211a:	a015                	j	8000213e <fork+0xae>
    freeproc(np);
    8000211c:	8552                	mv	a0,s4
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	d5a080e7          	jalr	-678(ra) # 80001e78 <freeproc>
    release(&np->lock);
    80002126:	8552                	mv	a0,s4
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	ce2080e7          	jalr	-798(ra) # 80000e0a <release>
    return -1;
    80002130:	597d                	li	s2,-1
    80002132:	6a42                	ld	s4,16(sp)
    80002134:	a071                	j	800021c0 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80002136:	04a1                	addi	s1,s1,8
    80002138:	0921                	addi	s2,s2,8
    8000213a:	01348b63          	beq	s1,s3,80002150 <fork+0xc0>
    if (p->ofile[i])
    8000213e:	6088                	ld	a0,0(s1)
    80002140:	d97d                	beqz	a0,80002136 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80002142:	00003097          	auipc	ra,0x3
    80002146:	9f2080e7          	jalr	-1550(ra) # 80004b34 <filedup>
    8000214a:	00a93023          	sd	a0,0(s2)
    8000214e:	b7e5                	j	80002136 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80002150:	150ab503          	ld	a0,336(s5)
    80002154:	00002097          	auipc	ra,0x2
    80002158:	b5c080e7          	jalr	-1188(ra) # 80003cb0 <idup>
    8000215c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002160:	4641                	li	a2,16
    80002162:	158a8593          	addi	a1,s5,344
    80002166:	158a0513          	addi	a0,s4,344
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	e2a080e7          	jalr	-470(ra) # 80000f94 <safestrcpy>
  pid = np->pid;
    80002172:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002176:	8552                	mv	a0,s4
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	c92080e7          	jalr	-878(ra) # 80000e0a <release>
  acquire(&wait_lock);
    80002180:	0002f497          	auipc	s1,0x2f
    80002184:	9f048493          	addi	s1,s1,-1552 # 80030b70 <wait_lock>
    80002188:	8526                	mv	a0,s1
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	bcc080e7          	jalr	-1076(ra) # 80000d56 <acquire>
  np->parent = p;
    80002192:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002196:	8526                	mv	a0,s1
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	c72080e7          	jalr	-910(ra) # 80000e0a <release>
  acquire(&np->lock);
    800021a0:	8552                	mv	a0,s4
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	bb4080e7          	jalr	-1100(ra) # 80000d56 <acquire>
  np->state = RUNNABLE;
    800021aa:	478d                	li	a5,3
    800021ac:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800021b0:	8552                	mv	a0,s4
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	c58080e7          	jalr	-936(ra) # 80000e0a <release>
  return pid;
    800021ba:	74a2                	ld	s1,40(sp)
    800021bc:	69e2                	ld	s3,24(sp)
    800021be:	6a42                	ld	s4,16(sp)
}
    800021c0:	854a                	mv	a0,s2
    800021c2:	70e2                	ld	ra,56(sp)
    800021c4:	7442                	ld	s0,48(sp)
    800021c6:	7902                	ld	s2,32(sp)
    800021c8:	6aa2                	ld	s5,8(sp)
    800021ca:	6121                	addi	sp,sp,64
    800021cc:	8082                	ret
    return -1;
    800021ce:	597d                	li	s2,-1
    800021d0:	bfc5                	j	800021c0 <fork+0x130>

00000000800021d2 <scheduler>:
{
    800021d2:	7139                	addi	sp,sp,-64
    800021d4:	fc06                	sd	ra,56(sp)
    800021d6:	f822                	sd	s0,48(sp)
    800021d8:	f426                	sd	s1,40(sp)
    800021da:	f04a                	sd	s2,32(sp)
    800021dc:	ec4e                	sd	s3,24(sp)
    800021de:	e852                	sd	s4,16(sp)
    800021e0:	e456                	sd	s5,8(sp)
    800021e2:	e05a                	sd	s6,0(sp)
    800021e4:	0080                	addi	s0,sp,64
    800021e6:	8792                	mv	a5,tp
  int id = r_tp();
    800021e8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800021ea:	00779a93          	slli	s5,a5,0x7
    800021ee:	0002f717          	auipc	a4,0x2f
    800021f2:	96a70713          	addi	a4,a4,-1686 # 80030b58 <pid_lock>
    800021f6:	9756                	add	a4,a4,s5
    800021f8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800021fc:	0002f717          	auipc	a4,0x2f
    80002200:	99470713          	addi	a4,a4,-1644 # 80030b90 <cpus+0x8>
    80002204:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    80002206:	498d                	li	s3,3
        p->state = RUNNING;
    80002208:	4b11                	li	s6,4
        c->proc = p;
    8000220a:	079e                	slli	a5,a5,0x7
    8000220c:	0002fa17          	auipc	s4,0x2f
    80002210:	94ca0a13          	addi	s4,s4,-1716 # 80030b58 <pid_lock>
    80002214:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80002216:	00035917          	auipc	s2,0x35
    8000221a:	b7290913          	addi	s2,s2,-1166 # 80036d88 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000221e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002222:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002226:	10079073          	csrw	sstatus,a5
    8000222a:	0002f497          	auipc	s1,0x2f
    8000222e:	d5e48493          	addi	s1,s1,-674 # 80030f88 <proc>
    80002232:	a811                	j	80002246 <scheduler+0x74>
      release(&p->lock);
    80002234:	8526                	mv	a0,s1
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	bd4080e7          	jalr	-1068(ra) # 80000e0a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000223e:	17848493          	addi	s1,s1,376
    80002242:	fd248ee3          	beq	s1,s2,8000221e <scheduler+0x4c>
      acquire(&p->lock);
    80002246:	8526                	mv	a0,s1
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	b0e080e7          	jalr	-1266(ra) # 80000d56 <acquire>
      if (p->state == RUNNABLE)
    80002250:	4c9c                	lw	a5,24(s1)
    80002252:	ff3791e3          	bne	a5,s3,80002234 <scheduler+0x62>
        p->state = RUNNING;
    80002256:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000225a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000225e:	06048593          	addi	a1,s1,96
    80002262:	8556                	mv	a0,s5
    80002264:	00001097          	auipc	ra,0x1
    80002268:	83a080e7          	jalr	-1990(ra) # 80002a9e <swtch>
        c->proc = 0;
    8000226c:	020a3823          	sd	zero,48(s4)
    80002270:	b7d1                	j	80002234 <scheduler+0x62>

0000000080002272 <sched>:
{
    80002272:	7179                	addi	sp,sp,-48
    80002274:	f406                	sd	ra,40(sp)
    80002276:	f022                	sd	s0,32(sp)
    80002278:	ec26                	sd	s1,24(sp)
    8000227a:	e84a                	sd	s2,16(sp)
    8000227c:	e44e                	sd	s3,8(sp)
    8000227e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002280:	00000097          	auipc	ra,0x0
    80002284:	a46080e7          	jalr	-1466(ra) # 80001cc6 <myproc>
    80002288:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	a52080e7          	jalr	-1454(ra) # 80000cdc <holding>
    80002292:	c93d                	beqz	a0,80002308 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002294:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002296:	2781                	sext.w	a5,a5
    80002298:	079e                	slli	a5,a5,0x7
    8000229a:	0002f717          	auipc	a4,0x2f
    8000229e:	8be70713          	addi	a4,a4,-1858 # 80030b58 <pid_lock>
    800022a2:	97ba                	add	a5,a5,a4
    800022a4:	0a87a703          	lw	a4,168(a5)
    800022a8:	4785                	li	a5,1
    800022aa:	06f71763          	bne	a4,a5,80002318 <sched+0xa6>
  if (p->state == RUNNING)
    800022ae:	4c98                	lw	a4,24(s1)
    800022b0:	4791                	li	a5,4
    800022b2:	06f70b63          	beq	a4,a5,80002328 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800022ba:	8b89                	andi	a5,a5,2
  if (intr_get())
    800022bc:	efb5                	bnez	a5,80002338 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022be:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022c0:	0002f917          	auipc	s2,0x2f
    800022c4:	89890913          	addi	s2,s2,-1896 # 80030b58 <pid_lock>
    800022c8:	2781                	sext.w	a5,a5
    800022ca:	079e                	slli	a5,a5,0x7
    800022cc:	97ca                	add	a5,a5,s2
    800022ce:	0ac7a983          	lw	s3,172(a5)
    800022d2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800022d4:	2781                	sext.w	a5,a5
    800022d6:	079e                	slli	a5,a5,0x7
    800022d8:	0002f597          	auipc	a1,0x2f
    800022dc:	8b858593          	addi	a1,a1,-1864 # 80030b90 <cpus+0x8>
    800022e0:	95be                	add	a1,a1,a5
    800022e2:	06048513          	addi	a0,s1,96
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	7b8080e7          	jalr	1976(ra) # 80002a9e <swtch>
    800022ee:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800022f0:	2781                	sext.w	a5,a5
    800022f2:	079e                	slli	a5,a5,0x7
    800022f4:	993e                	add	s2,s2,a5
    800022f6:	0b392623          	sw	s3,172(s2)
}
    800022fa:	70a2                	ld	ra,40(sp)
    800022fc:	7402                	ld	s0,32(sp)
    800022fe:	64e2                	ld	s1,24(sp)
    80002300:	6942                	ld	s2,16(sp)
    80002302:	69a2                	ld	s3,8(sp)
    80002304:	6145                	addi	sp,sp,48
    80002306:	8082                	ret
    panic("sched p->lock");
    80002308:	00006517          	auipc	a0,0x6
    8000230c:	ef850513          	addi	a0,a0,-264 # 80008200 <etext+0x200>
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	250080e7          	jalr	592(ra) # 80000560 <panic>
    panic("sched locks");
    80002318:	00006517          	auipc	a0,0x6
    8000231c:	ef850513          	addi	a0,a0,-264 # 80008210 <etext+0x210>
    80002320:	ffffe097          	auipc	ra,0xffffe
    80002324:	240080e7          	jalr	576(ra) # 80000560 <panic>
    panic("sched running");
    80002328:	00006517          	auipc	a0,0x6
    8000232c:	ef850513          	addi	a0,a0,-264 # 80008220 <etext+0x220>
    80002330:	ffffe097          	auipc	ra,0xffffe
    80002334:	230080e7          	jalr	560(ra) # 80000560 <panic>
    panic("sched interruptible");
    80002338:	00006517          	auipc	a0,0x6
    8000233c:	ef850513          	addi	a0,a0,-264 # 80008230 <etext+0x230>
    80002340:	ffffe097          	auipc	ra,0xffffe
    80002344:	220080e7          	jalr	544(ra) # 80000560 <panic>

0000000080002348 <yield>:
{
    80002348:	1101                	addi	sp,sp,-32
    8000234a:	ec06                	sd	ra,24(sp)
    8000234c:	e822                	sd	s0,16(sp)
    8000234e:	e426                	sd	s1,8(sp)
    80002350:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002352:	00000097          	auipc	ra,0x0
    80002356:	974080e7          	jalr	-1676(ra) # 80001cc6 <myproc>
    8000235a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000235c:	fffff097          	auipc	ra,0xfffff
    80002360:	9fa080e7          	jalr	-1542(ra) # 80000d56 <acquire>
  p->state = RUNNABLE;
    80002364:	478d                	li	a5,3
    80002366:	cc9c                	sw	a5,24(s1)
  sched();
    80002368:	00000097          	auipc	ra,0x0
    8000236c:	f0a080e7          	jalr	-246(ra) # 80002272 <sched>
  release(&p->lock);
    80002370:	8526                	mv	a0,s1
    80002372:	fffff097          	auipc	ra,0xfffff
    80002376:	a98080e7          	jalr	-1384(ra) # 80000e0a <release>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret

0000000080002384 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002384:	7179                	addi	sp,sp,-48
    80002386:	f406                	sd	ra,40(sp)
    80002388:	f022                	sd	s0,32(sp)
    8000238a:	ec26                	sd	s1,24(sp)
    8000238c:	e84a                	sd	s2,16(sp)
    8000238e:	e44e                	sd	s3,8(sp)
    80002390:	1800                	addi	s0,sp,48
    80002392:	89aa                	mv	s3,a0
    80002394:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002396:	00000097          	auipc	ra,0x0
    8000239a:	930080e7          	jalr	-1744(ra) # 80001cc6 <myproc>
    8000239e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	9b6080e7          	jalr	-1610(ra) # 80000d56 <acquire>
  release(lk);
    800023a8:	854a                	mv	a0,s2
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	a60080e7          	jalr	-1440(ra) # 80000e0a <release>

  // Go to sleep.
  p->chan = chan;
    800023b2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800023b6:	4789                	li	a5,2
    800023b8:	cc9c                	sw	a5,24(s1)

  sched();
    800023ba:	00000097          	auipc	ra,0x0
    800023be:	eb8080e7          	jalr	-328(ra) # 80002272 <sched>

  // Tidy up.
  p->chan = 0;
    800023c2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800023c6:	8526                	mv	a0,s1
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	a42080e7          	jalr	-1470(ra) # 80000e0a <release>
  acquire(lk);
    800023d0:	854a                	mv	a0,s2
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	984080e7          	jalr	-1660(ra) # 80000d56 <acquire>
}
    800023da:	70a2                	ld	ra,40(sp)
    800023dc:	7402                	ld	s0,32(sp)
    800023de:	64e2                	ld	s1,24(sp)
    800023e0:	6942                	ld	s2,16(sp)
    800023e2:	69a2                	ld	s3,8(sp)
    800023e4:	6145                	addi	sp,sp,48
    800023e6:	8082                	ret

00000000800023e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800023e8:	7139                	addi	sp,sp,-64
    800023ea:	fc06                	sd	ra,56(sp)
    800023ec:	f822                	sd	s0,48(sp)
    800023ee:	f426                	sd	s1,40(sp)
    800023f0:	f04a                	sd	s2,32(sp)
    800023f2:	ec4e                	sd	s3,24(sp)
    800023f4:	e852                	sd	s4,16(sp)
    800023f6:	e456                	sd	s5,8(sp)
    800023f8:	0080                	addi	s0,sp,64
    800023fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800023fc:	0002f497          	auipc	s1,0x2f
    80002400:	b8c48493          	addi	s1,s1,-1140 # 80030f88 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002404:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002406:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002408:	00035917          	auipc	s2,0x35
    8000240c:	98090913          	addi	s2,s2,-1664 # 80036d88 <tickslock>
    80002410:	a811                	j	80002424 <wakeup+0x3c>
      }
      release(&p->lock);
    80002412:	8526                	mv	a0,s1
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	9f6080e7          	jalr	-1546(ra) # 80000e0a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000241c:	17848493          	addi	s1,s1,376
    80002420:	03248663          	beq	s1,s2,8000244c <wakeup+0x64>
    if (p != myproc())
    80002424:	00000097          	auipc	ra,0x0
    80002428:	8a2080e7          	jalr	-1886(ra) # 80001cc6 <myproc>
    8000242c:	fea488e3          	beq	s1,a0,8000241c <wakeup+0x34>
      acquire(&p->lock);
    80002430:	8526                	mv	a0,s1
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	924080e7          	jalr	-1756(ra) # 80000d56 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000243a:	4c9c                	lw	a5,24(s1)
    8000243c:	fd379be3          	bne	a5,s3,80002412 <wakeup+0x2a>
    80002440:	709c                	ld	a5,32(s1)
    80002442:	fd4798e3          	bne	a5,s4,80002412 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002446:	0154ac23          	sw	s5,24(s1)
    8000244a:	b7e1                	j	80002412 <wakeup+0x2a>
    }
  }
}
    8000244c:	70e2                	ld	ra,56(sp)
    8000244e:	7442                	ld	s0,48(sp)
    80002450:	74a2                	ld	s1,40(sp)
    80002452:	7902                	ld	s2,32(sp)
    80002454:	69e2                	ld	s3,24(sp)
    80002456:	6a42                	ld	s4,16(sp)
    80002458:	6aa2                	ld	s5,8(sp)
    8000245a:	6121                	addi	sp,sp,64
    8000245c:	8082                	ret

000000008000245e <reparent>:
{
    8000245e:	7179                	addi	sp,sp,-48
    80002460:	f406                	sd	ra,40(sp)
    80002462:	f022                	sd	s0,32(sp)
    80002464:	ec26                	sd	s1,24(sp)
    80002466:	e84a                	sd	s2,16(sp)
    80002468:	e44e                	sd	s3,8(sp)
    8000246a:	e052                	sd	s4,0(sp)
    8000246c:	1800                	addi	s0,sp,48
    8000246e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002470:	0002f497          	auipc	s1,0x2f
    80002474:	b1848493          	addi	s1,s1,-1256 # 80030f88 <proc>
      pp->parent = initproc;
    80002478:	00006a17          	auipc	s4,0x6
    8000247c:	450a0a13          	addi	s4,s4,1104 # 800088c8 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002480:	00035997          	auipc	s3,0x35
    80002484:	90898993          	addi	s3,s3,-1784 # 80036d88 <tickslock>
    80002488:	a029                	j	80002492 <reparent+0x34>
    8000248a:	17848493          	addi	s1,s1,376
    8000248e:	01348d63          	beq	s1,s3,800024a8 <reparent+0x4a>
    if (pp->parent == p)
    80002492:	7c9c                	ld	a5,56(s1)
    80002494:	ff279be3          	bne	a5,s2,8000248a <reparent+0x2c>
      pp->parent = initproc;
    80002498:	000a3503          	ld	a0,0(s4)
    8000249c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000249e:	00000097          	auipc	ra,0x0
    800024a2:	f4a080e7          	jalr	-182(ra) # 800023e8 <wakeup>
    800024a6:	b7d5                	j	8000248a <reparent+0x2c>
}
    800024a8:	70a2                	ld	ra,40(sp)
    800024aa:	7402                	ld	s0,32(sp)
    800024ac:	64e2                	ld	s1,24(sp)
    800024ae:	6942                	ld	s2,16(sp)
    800024b0:	69a2                	ld	s3,8(sp)
    800024b2:	6a02                	ld	s4,0(sp)
    800024b4:	6145                	addi	sp,sp,48
    800024b6:	8082                	ret

00000000800024b8 <exit>:
{
    800024b8:	7179                	addi	sp,sp,-48
    800024ba:	f406                	sd	ra,40(sp)
    800024bc:	f022                	sd	s0,32(sp)
    800024be:	ec26                	sd	s1,24(sp)
    800024c0:	e84a                	sd	s2,16(sp)
    800024c2:	e44e                	sd	s3,8(sp)
    800024c4:	e052                	sd	s4,0(sp)
    800024c6:	1800                	addi	s0,sp,48
    800024c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	7fc080e7          	jalr	2044(ra) # 80001cc6 <myproc>
    800024d2:	89aa                	mv	s3,a0
  if (p == initproc)
    800024d4:	00006797          	auipc	a5,0x6
    800024d8:	3f47b783          	ld	a5,1012(a5) # 800088c8 <initproc>
    800024dc:	0d050493          	addi	s1,a0,208
    800024e0:	15050913          	addi	s2,a0,336
    800024e4:	02a79363          	bne	a5,a0,8000250a <exit+0x52>
    panic("init exiting");
    800024e8:	00006517          	auipc	a0,0x6
    800024ec:	d6050513          	addi	a0,a0,-672 # 80008248 <etext+0x248>
    800024f0:	ffffe097          	auipc	ra,0xffffe
    800024f4:	070080e7          	jalr	112(ra) # 80000560 <panic>
      fileclose(f);
    800024f8:	00002097          	auipc	ra,0x2
    800024fc:	68e080e7          	jalr	1678(ra) # 80004b86 <fileclose>
      p->ofile[fd] = 0;
    80002500:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002504:	04a1                	addi	s1,s1,8
    80002506:	01248563          	beq	s1,s2,80002510 <exit+0x58>
    if (p->ofile[fd])
    8000250a:	6088                	ld	a0,0(s1)
    8000250c:	f575                	bnez	a0,800024f8 <exit+0x40>
    8000250e:	bfdd                	j	80002504 <exit+0x4c>
  begin_op();
    80002510:	00002097          	auipc	ra,0x2
    80002514:	1ac080e7          	jalr	428(ra) # 800046bc <begin_op>
  iput(p->cwd);
    80002518:	1509b503          	ld	a0,336(s3)
    8000251c:	00002097          	auipc	ra,0x2
    80002520:	990080e7          	jalr	-1648(ra) # 80003eac <iput>
  end_op();
    80002524:	00002097          	auipc	ra,0x2
    80002528:	212080e7          	jalr	530(ra) # 80004736 <end_op>
  p->cwd = 0;
    8000252c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002530:	0002e497          	auipc	s1,0x2e
    80002534:	64048493          	addi	s1,s1,1600 # 80030b70 <wait_lock>
    80002538:	8526                	mv	a0,s1
    8000253a:	fffff097          	auipc	ra,0xfffff
    8000253e:	81c080e7          	jalr	-2020(ra) # 80000d56 <acquire>
  reparent(p);
    80002542:	854e                	mv	a0,s3
    80002544:	00000097          	auipc	ra,0x0
    80002548:	f1a080e7          	jalr	-230(ra) # 8000245e <reparent>
  wakeup(p->parent);
    8000254c:	0389b503          	ld	a0,56(s3)
    80002550:	00000097          	auipc	ra,0x0
    80002554:	e98080e7          	jalr	-360(ra) # 800023e8 <wakeup>
  acquire(&p->lock);
    80002558:	854e                	mv	a0,s3
    8000255a:	ffffe097          	auipc	ra,0xffffe
    8000255e:	7fc080e7          	jalr	2044(ra) # 80000d56 <acquire>
  p->xstate = status;
    80002562:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002566:	4795                	li	a5,5
    80002568:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    8000256c:	00006797          	auipc	a5,0x6
    80002570:	3647a783          	lw	a5,868(a5) # 800088d0 <ticks>
    80002574:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    80002578:	8526                	mv	a0,s1
    8000257a:	fffff097          	auipc	ra,0xfffff
    8000257e:	890080e7          	jalr	-1904(ra) # 80000e0a <release>
  sched();
    80002582:	00000097          	auipc	ra,0x0
    80002586:	cf0080e7          	jalr	-784(ra) # 80002272 <sched>
  panic("zombie exit");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	cce50513          	addi	a0,a0,-818 # 80008258 <etext+0x258>
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	fce080e7          	jalr	-50(ra) # 80000560 <panic>

000000008000259a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000259a:	7179                	addi	sp,sp,-48
    8000259c:	f406                	sd	ra,40(sp)
    8000259e:	f022                	sd	s0,32(sp)
    800025a0:	ec26                	sd	s1,24(sp)
    800025a2:	e84a                	sd	s2,16(sp)
    800025a4:	e44e                	sd	s3,8(sp)
    800025a6:	1800                	addi	s0,sp,48
    800025a8:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800025aa:	0002f497          	auipc	s1,0x2f
    800025ae:	9de48493          	addi	s1,s1,-1570 # 80030f88 <proc>
    800025b2:	00034997          	auipc	s3,0x34
    800025b6:	7d698993          	addi	s3,s3,2006 # 80036d88 <tickslock>
  {
    acquire(&p->lock);
    800025ba:	8526                	mv	a0,s1
    800025bc:	ffffe097          	auipc	ra,0xffffe
    800025c0:	79a080e7          	jalr	1946(ra) # 80000d56 <acquire>
    if (p->pid == pid)
    800025c4:	589c                	lw	a5,48(s1)
    800025c6:	01278d63          	beq	a5,s2,800025e0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800025ca:	8526                	mv	a0,s1
    800025cc:	fffff097          	auipc	ra,0xfffff
    800025d0:	83e080e7          	jalr	-1986(ra) # 80000e0a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800025d4:	17848493          	addi	s1,s1,376
    800025d8:	ff3491e3          	bne	s1,s3,800025ba <kill+0x20>
  }
  return -1;
    800025dc:	557d                	li	a0,-1
    800025de:	a829                	j	800025f8 <kill+0x5e>
      p->killed = 1;
    800025e0:	4785                	li	a5,1
    800025e2:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800025e4:	4c98                	lw	a4,24(s1)
    800025e6:	4789                	li	a5,2
    800025e8:	00f70f63          	beq	a4,a5,80002606 <kill+0x6c>
      release(&p->lock);
    800025ec:	8526                	mv	a0,s1
    800025ee:	fffff097          	auipc	ra,0xfffff
    800025f2:	81c080e7          	jalr	-2020(ra) # 80000e0a <release>
      return 0;
    800025f6:	4501                	li	a0,0
}
    800025f8:	70a2                	ld	ra,40(sp)
    800025fa:	7402                	ld	s0,32(sp)
    800025fc:	64e2                	ld	s1,24(sp)
    800025fe:	6942                	ld	s2,16(sp)
    80002600:	69a2                	ld	s3,8(sp)
    80002602:	6145                	addi	sp,sp,48
    80002604:	8082                	ret
        p->state = RUNNABLE;
    80002606:	478d                	li	a5,3
    80002608:	cc9c                	sw	a5,24(s1)
    8000260a:	b7cd                	j	800025ec <kill+0x52>

000000008000260c <setkilled>:

void setkilled(struct proc *p)
{
    8000260c:	1101                	addi	sp,sp,-32
    8000260e:	ec06                	sd	ra,24(sp)
    80002610:	e822                	sd	s0,16(sp)
    80002612:	e426                	sd	s1,8(sp)
    80002614:	1000                	addi	s0,sp,32
    80002616:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	73e080e7          	jalr	1854(ra) # 80000d56 <acquire>
  p->killed = 1;
    80002620:	4785                	li	a5,1
    80002622:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002624:	8526                	mv	a0,s1
    80002626:	ffffe097          	auipc	ra,0xffffe
    8000262a:	7e4080e7          	jalr	2020(ra) # 80000e0a <release>
}
    8000262e:	60e2                	ld	ra,24(sp)
    80002630:	6442                	ld	s0,16(sp)
    80002632:	64a2                	ld	s1,8(sp)
    80002634:	6105                	addi	sp,sp,32
    80002636:	8082                	ret

0000000080002638 <killed>:

int killed(struct proc *p)
{
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	e04a                	sd	s2,0(sp)
    80002642:	1000                	addi	s0,sp,32
    80002644:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002646:	ffffe097          	auipc	ra,0xffffe
    8000264a:	710080e7          	jalr	1808(ra) # 80000d56 <acquire>
  k = p->killed;
    8000264e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002652:	8526                	mv	a0,s1
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	7b6080e7          	jalr	1974(ra) # 80000e0a <release>
  return k;
}
    8000265c:	854a                	mv	a0,s2
    8000265e:	60e2                	ld	ra,24(sp)
    80002660:	6442                	ld	s0,16(sp)
    80002662:	64a2                	ld	s1,8(sp)
    80002664:	6902                	ld	s2,0(sp)
    80002666:	6105                	addi	sp,sp,32
    80002668:	8082                	ret

000000008000266a <wait>:
{
    8000266a:	715d                	addi	sp,sp,-80
    8000266c:	e486                	sd	ra,72(sp)
    8000266e:	e0a2                	sd	s0,64(sp)
    80002670:	fc26                	sd	s1,56(sp)
    80002672:	f84a                	sd	s2,48(sp)
    80002674:	f44e                	sd	s3,40(sp)
    80002676:	f052                	sd	s4,32(sp)
    80002678:	ec56                	sd	s5,24(sp)
    8000267a:	e85a                	sd	s6,16(sp)
    8000267c:	e45e                	sd	s7,8(sp)
    8000267e:	e062                	sd	s8,0(sp)
    80002680:	0880                	addi	s0,sp,80
    80002682:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002684:	fffff097          	auipc	ra,0xfffff
    80002688:	642080e7          	jalr	1602(ra) # 80001cc6 <myproc>
    8000268c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000268e:	0002e517          	auipc	a0,0x2e
    80002692:	4e250513          	addi	a0,a0,1250 # 80030b70 <wait_lock>
    80002696:	ffffe097          	auipc	ra,0xffffe
    8000269a:	6c0080e7          	jalr	1728(ra) # 80000d56 <acquire>
    havekids = 0;
    8000269e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800026a0:	4a15                	li	s4,5
        havekids = 1;
    800026a2:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800026a4:	00034997          	auipc	s3,0x34
    800026a8:	6e498993          	addi	s3,s3,1764 # 80036d88 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800026ac:	0002ec17          	auipc	s8,0x2e
    800026b0:	4c4c0c13          	addi	s8,s8,1220 # 80030b70 <wait_lock>
    800026b4:	a0d1                	j	80002778 <wait+0x10e>
          pid = pp->pid;
    800026b6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800026ba:	000b0e63          	beqz	s6,800026d6 <wait+0x6c>
    800026be:	4691                	li	a3,4
    800026c0:	02c48613          	addi	a2,s1,44
    800026c4:	85da                	mv	a1,s6
    800026c6:	05093503          	ld	a0,80(s2)
    800026ca:	fffff097          	auipc	ra,0xfffff
    800026ce:	178080e7          	jalr	376(ra) # 80001842 <copyout>
    800026d2:	04054163          	bltz	a0,80002714 <wait+0xaa>
          freeproc(pp);
    800026d6:	8526                	mv	a0,s1
    800026d8:	fffff097          	auipc	ra,0xfffff
    800026dc:	7a0080e7          	jalr	1952(ra) # 80001e78 <freeproc>
          release(&pp->lock);
    800026e0:	8526                	mv	a0,s1
    800026e2:	ffffe097          	auipc	ra,0xffffe
    800026e6:	728080e7          	jalr	1832(ra) # 80000e0a <release>
          release(&wait_lock);
    800026ea:	0002e517          	auipc	a0,0x2e
    800026ee:	48650513          	addi	a0,a0,1158 # 80030b70 <wait_lock>
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	718080e7          	jalr	1816(ra) # 80000e0a <release>
}
    800026fa:	854e                	mv	a0,s3
    800026fc:	60a6                	ld	ra,72(sp)
    800026fe:	6406                	ld	s0,64(sp)
    80002700:	74e2                	ld	s1,56(sp)
    80002702:	7942                	ld	s2,48(sp)
    80002704:	79a2                	ld	s3,40(sp)
    80002706:	7a02                	ld	s4,32(sp)
    80002708:	6ae2                	ld	s5,24(sp)
    8000270a:	6b42                	ld	s6,16(sp)
    8000270c:	6ba2                	ld	s7,8(sp)
    8000270e:	6c02                	ld	s8,0(sp)
    80002710:	6161                	addi	sp,sp,80
    80002712:	8082                	ret
            release(&pp->lock);
    80002714:	8526                	mv	a0,s1
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	6f4080e7          	jalr	1780(ra) # 80000e0a <release>
            release(&wait_lock);
    8000271e:	0002e517          	auipc	a0,0x2e
    80002722:	45250513          	addi	a0,a0,1106 # 80030b70 <wait_lock>
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	6e4080e7          	jalr	1764(ra) # 80000e0a <release>
            return -1;
    8000272e:	59fd                	li	s3,-1
    80002730:	b7e9                	j	800026fa <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002732:	17848493          	addi	s1,s1,376
    80002736:	03348463          	beq	s1,s3,8000275e <wait+0xf4>
      if (pp->parent == p)
    8000273a:	7c9c                	ld	a5,56(s1)
    8000273c:	ff279be3          	bne	a5,s2,80002732 <wait+0xc8>
        acquire(&pp->lock);
    80002740:	8526                	mv	a0,s1
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	614080e7          	jalr	1556(ra) # 80000d56 <acquire>
        if (pp->state == ZOMBIE)
    8000274a:	4c9c                	lw	a5,24(s1)
    8000274c:	f74785e3          	beq	a5,s4,800026b6 <wait+0x4c>
        release(&pp->lock);
    80002750:	8526                	mv	a0,s1
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	6b8080e7          	jalr	1720(ra) # 80000e0a <release>
        havekids = 1;
    8000275a:	8756                	mv	a4,s5
    8000275c:	bfd9                	j	80002732 <wait+0xc8>
    if (!havekids || killed(p))
    8000275e:	c31d                	beqz	a4,80002784 <wait+0x11a>
    80002760:	854a                	mv	a0,s2
    80002762:	00000097          	auipc	ra,0x0
    80002766:	ed6080e7          	jalr	-298(ra) # 80002638 <killed>
    8000276a:	ed09                	bnez	a0,80002784 <wait+0x11a>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000276c:	85e2                	mv	a1,s8
    8000276e:	854a                	mv	a0,s2
    80002770:	00000097          	auipc	ra,0x0
    80002774:	c14080e7          	jalr	-1004(ra) # 80002384 <sleep>
    havekids = 0;
    80002778:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000277a:	0002f497          	auipc	s1,0x2f
    8000277e:	80e48493          	addi	s1,s1,-2034 # 80030f88 <proc>
    80002782:	bf65                	j	8000273a <wait+0xd0>
      release(&wait_lock);
    80002784:	0002e517          	auipc	a0,0x2e
    80002788:	3ec50513          	addi	a0,a0,1004 # 80030b70 <wait_lock>
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	67e080e7          	jalr	1662(ra) # 80000e0a <release>
      return -1;
    80002794:	59fd                	li	s3,-1
    80002796:	b795                	j	800026fa <wait+0x90>

0000000080002798 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002798:	7179                	addi	sp,sp,-48
    8000279a:	f406                	sd	ra,40(sp)
    8000279c:	f022                	sd	s0,32(sp)
    8000279e:	ec26                	sd	s1,24(sp)
    800027a0:	e84a                	sd	s2,16(sp)
    800027a2:	e44e                	sd	s3,8(sp)
    800027a4:	e052                	sd	s4,0(sp)
    800027a6:	1800                	addi	s0,sp,48
    800027a8:	84aa                	mv	s1,a0
    800027aa:	892e                	mv	s2,a1
    800027ac:	89b2                	mv	s3,a2
    800027ae:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800027b0:	fffff097          	auipc	ra,0xfffff
    800027b4:	516080e7          	jalr	1302(ra) # 80001cc6 <myproc>
  if (user_dst)
    800027b8:	c08d                	beqz	s1,800027da <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    800027ba:	86d2                	mv	a3,s4
    800027bc:	864e                	mv	a2,s3
    800027be:	85ca                	mv	a1,s2
    800027c0:	6928                	ld	a0,80(a0)
    800027c2:	fffff097          	auipc	ra,0xfffff
    800027c6:	080080e7          	jalr	128(ra) # 80001842 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800027ca:	70a2                	ld	ra,40(sp)
    800027cc:	7402                	ld	s0,32(sp)
    800027ce:	64e2                	ld	s1,24(sp)
    800027d0:	6942                	ld	s2,16(sp)
    800027d2:	69a2                	ld	s3,8(sp)
    800027d4:	6a02                	ld	s4,0(sp)
    800027d6:	6145                	addi	sp,sp,48
    800027d8:	8082                	ret
    memmove((char *)dst, src, len);
    800027da:	000a061b          	sext.w	a2,s4
    800027de:	85ce                	mv	a1,s3
    800027e0:	854a                	mv	a0,s2
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	6cc080e7          	jalr	1740(ra) # 80000eae <memmove>
    return 0;
    800027ea:	8526                	mv	a0,s1
    800027ec:	bff9                	j	800027ca <either_copyout+0x32>

00000000800027ee <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	e44e                	sd	s3,8(sp)
    800027fa:	e052                	sd	s4,0(sp)
    800027fc:	1800                	addi	s0,sp,48
    800027fe:	892a                	mv	s2,a0
    80002800:	84ae                	mv	s1,a1
    80002802:	89b2                	mv	s3,a2
    80002804:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002806:	fffff097          	auipc	ra,0xfffff
    8000280a:	4c0080e7          	jalr	1216(ra) # 80001cc6 <myproc>
  if (user_src)
    8000280e:	c08d                	beqz	s1,80002830 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002810:	86d2                	mv	a3,s4
    80002812:	864e                	mv	a2,s3
    80002814:	85ca                	mv	a1,s2
    80002816:	6928                	ld	a0,80(a0)
    80002818:	fffff097          	auipc	ra,0xfffff
    8000281c:	1d2080e7          	jalr	466(ra) # 800019ea <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002820:	70a2                	ld	ra,40(sp)
    80002822:	7402                	ld	s0,32(sp)
    80002824:	64e2                	ld	s1,24(sp)
    80002826:	6942                	ld	s2,16(sp)
    80002828:	69a2                	ld	s3,8(sp)
    8000282a:	6a02                	ld	s4,0(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret
    memmove(dst, (char *)src, len);
    80002830:	000a061b          	sext.w	a2,s4
    80002834:	85ce                	mv	a1,s3
    80002836:	854a                	mv	a0,s2
    80002838:	ffffe097          	auipc	ra,0xffffe
    8000283c:	676080e7          	jalr	1654(ra) # 80000eae <memmove>
    return 0;
    80002840:	8526                	mv	a0,s1
    80002842:	bff9                	j	80002820 <either_copyin+0x32>

0000000080002844 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002844:	715d                	addi	sp,sp,-80
    80002846:	e486                	sd	ra,72(sp)
    80002848:	e0a2                	sd	s0,64(sp)
    8000284a:	fc26                	sd	s1,56(sp)
    8000284c:	f84a                	sd	s2,48(sp)
    8000284e:	f44e                	sd	s3,40(sp)
    80002850:	f052                	sd	s4,32(sp)
    80002852:	ec56                	sd	s5,24(sp)
    80002854:	e85a                	sd	s6,16(sp)
    80002856:	e45e                	sd	s7,8(sp)
    80002858:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    8000285a:	00005517          	auipc	a0,0x5
    8000285e:	7b650513          	addi	a0,a0,1974 # 80008010 <etext+0x10>
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	d48080e7          	jalr	-696(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    8000286a:	0002f497          	auipc	s1,0x2f
    8000286e:	87648493          	addi	s1,s1,-1930 # 800310e0 <proc+0x158>
    80002872:	00034917          	auipc	s2,0x34
    80002876:	66e90913          	addi	s2,s2,1646 # 80036ee0 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000287a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000287c:	00006997          	auipc	s3,0x6
    80002880:	9ec98993          	addi	s3,s3,-1556 # 80008268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80002884:	00006a97          	auipc	s5,0x6
    80002888:	9eca8a93          	addi	s5,s5,-1556 # 80008270 <etext+0x270>
    printf("\n");
    8000288c:	00005a17          	auipc	s4,0x5
    80002890:	784a0a13          	addi	s4,s4,1924 # 80008010 <etext+0x10>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002894:	00006b97          	auipc	s7,0x6
    80002898:	eb4b8b93          	addi	s7,s7,-332 # 80008748 <states.0>
    8000289c:	a00d                	j	800028be <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000289e:	ed86a583          	lw	a1,-296(a3)
    800028a2:	8556                	mv	a0,s5
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	d06080e7          	jalr	-762(ra) # 800005aa <printf>
    printf("\n");
    800028ac:	8552                	mv	a0,s4
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	cfc080e7          	jalr	-772(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800028b6:	17848493          	addi	s1,s1,376
    800028ba:	03248263          	beq	s1,s2,800028de <procdump+0x9a>
    if (p->state == UNUSED)
    800028be:	86a6                	mv	a3,s1
    800028c0:	ec04a783          	lw	a5,-320(s1)
    800028c4:	dbed                	beqz	a5,800028b6 <procdump+0x72>
      state = "???";
    800028c6:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028c8:	fcfb6be3          	bltu	s6,a5,8000289e <procdump+0x5a>
    800028cc:	02079713          	slli	a4,a5,0x20
    800028d0:	01d75793          	srli	a5,a4,0x1d
    800028d4:	97de                	add	a5,a5,s7
    800028d6:	6390                	ld	a2,0(a5)
    800028d8:	f279                	bnez	a2,8000289e <procdump+0x5a>
      state = "???";
    800028da:	864e                	mv	a2,s3
    800028dc:	b7c9                	j	8000289e <procdump+0x5a>
  }
}
    800028de:	60a6                	ld	ra,72(sp)
    800028e0:	6406                	ld	s0,64(sp)
    800028e2:	74e2                	ld	s1,56(sp)
    800028e4:	7942                	ld	s2,48(sp)
    800028e6:	79a2                	ld	s3,40(sp)
    800028e8:	7a02                	ld	s4,32(sp)
    800028ea:	6ae2                	ld	s5,24(sp)
    800028ec:	6b42                	ld	s6,16(sp)
    800028ee:	6ba2                	ld	s7,8(sp)
    800028f0:	6161                	addi	sp,sp,80
    800028f2:	8082                	ret

00000000800028f4 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    800028f4:	711d                	addi	sp,sp,-96
    800028f6:	ec86                	sd	ra,88(sp)
    800028f8:	e8a2                	sd	s0,80(sp)
    800028fa:	e4a6                	sd	s1,72(sp)
    800028fc:	e0ca                	sd	s2,64(sp)
    800028fe:	fc4e                	sd	s3,56(sp)
    80002900:	f852                	sd	s4,48(sp)
    80002902:	f456                	sd	s5,40(sp)
    80002904:	f05a                	sd	s6,32(sp)
    80002906:	ec5e                	sd	s7,24(sp)
    80002908:	e862                	sd	s8,16(sp)
    8000290a:	e466                	sd	s9,8(sp)
    8000290c:	e06a                	sd	s10,0(sp)
    8000290e:	1080                	addi	s0,sp,96
    80002910:	8b2a                	mv	s6,a0
    80002912:	8bae                	mv	s7,a1
    80002914:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002916:	fffff097          	auipc	ra,0xfffff
    8000291a:	3b0080e7          	jalr	944(ra) # 80001cc6 <myproc>
    8000291e:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002920:	0002e517          	auipc	a0,0x2e
    80002924:	25050513          	addi	a0,a0,592 # 80030b70 <wait_lock>
    80002928:	ffffe097          	auipc	ra,0xffffe
    8000292c:	42e080e7          	jalr	1070(ra) # 80000d56 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002930:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002932:	4a15                	li	s4,5
        havekids = 1;
    80002934:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002936:	00034997          	auipc	s3,0x34
    8000293a:	45298993          	addi	s3,s3,1106 # 80036d88 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000293e:	0002ed17          	auipc	s10,0x2e
    80002942:	232d0d13          	addi	s10,s10,562 # 80030b70 <wait_lock>
    80002946:	a8e9                	j	80002a20 <waitx+0x12c>
          pid = np->pid;
    80002948:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    8000294c:	1684a783          	lw	a5,360(s1)
    80002950:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002954:	16c4a703          	lw	a4,364(s1)
    80002958:	9f3d                	addw	a4,a4,a5
    8000295a:	1704a783          	lw	a5,368(s1)
    8000295e:	9f99                	subw	a5,a5,a4
    80002960:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002964:	000b0e63          	beqz	s6,80002980 <waitx+0x8c>
    80002968:	4691                	li	a3,4
    8000296a:	02c48613          	addi	a2,s1,44
    8000296e:	85da                	mv	a1,s6
    80002970:	05093503          	ld	a0,80(s2)
    80002974:	fffff097          	auipc	ra,0xfffff
    80002978:	ece080e7          	jalr	-306(ra) # 80001842 <copyout>
    8000297c:	04054363          	bltz	a0,800029c2 <waitx+0xce>
          freeproc(np);
    80002980:	8526                	mv	a0,s1
    80002982:	fffff097          	auipc	ra,0xfffff
    80002986:	4f6080e7          	jalr	1270(ra) # 80001e78 <freeproc>
          release(&np->lock);
    8000298a:	8526                	mv	a0,s1
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	47e080e7          	jalr	1150(ra) # 80000e0a <release>
          release(&wait_lock);
    80002994:	0002e517          	auipc	a0,0x2e
    80002998:	1dc50513          	addi	a0,a0,476 # 80030b70 <wait_lock>
    8000299c:	ffffe097          	auipc	ra,0xffffe
    800029a0:	46e080e7          	jalr	1134(ra) # 80000e0a <release>
  }
}
    800029a4:	854e                	mv	a0,s3
    800029a6:	60e6                	ld	ra,88(sp)
    800029a8:	6446                	ld	s0,80(sp)
    800029aa:	64a6                	ld	s1,72(sp)
    800029ac:	6906                	ld	s2,64(sp)
    800029ae:	79e2                	ld	s3,56(sp)
    800029b0:	7a42                	ld	s4,48(sp)
    800029b2:	7aa2                	ld	s5,40(sp)
    800029b4:	7b02                	ld	s6,32(sp)
    800029b6:	6be2                	ld	s7,24(sp)
    800029b8:	6c42                	ld	s8,16(sp)
    800029ba:	6ca2                	ld	s9,8(sp)
    800029bc:	6d02                	ld	s10,0(sp)
    800029be:	6125                	addi	sp,sp,96
    800029c0:	8082                	ret
            release(&np->lock);
    800029c2:	8526                	mv	a0,s1
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	446080e7          	jalr	1094(ra) # 80000e0a <release>
            release(&wait_lock);
    800029cc:	0002e517          	auipc	a0,0x2e
    800029d0:	1a450513          	addi	a0,a0,420 # 80030b70 <wait_lock>
    800029d4:	ffffe097          	auipc	ra,0xffffe
    800029d8:	436080e7          	jalr	1078(ra) # 80000e0a <release>
            return -1;
    800029dc:	59fd                	li	s3,-1
    800029de:	b7d9                	j	800029a4 <waitx+0xb0>
    for (np = proc; np < &proc[NPROC]; np++)
    800029e0:	17848493          	addi	s1,s1,376
    800029e4:	03348463          	beq	s1,s3,80002a0c <waitx+0x118>
      if (np->parent == p)
    800029e8:	7c9c                	ld	a5,56(s1)
    800029ea:	ff279be3          	bne	a5,s2,800029e0 <waitx+0xec>
        acquire(&np->lock);
    800029ee:	8526                	mv	a0,s1
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	366080e7          	jalr	870(ra) # 80000d56 <acquire>
        if (np->state == ZOMBIE)
    800029f8:	4c9c                	lw	a5,24(s1)
    800029fa:	f54787e3          	beq	a5,s4,80002948 <waitx+0x54>
        release(&np->lock);
    800029fe:	8526                	mv	a0,s1
    80002a00:	ffffe097          	auipc	ra,0xffffe
    80002a04:	40a080e7          	jalr	1034(ra) # 80000e0a <release>
        havekids = 1;
    80002a08:	8756                	mv	a4,s5
    80002a0a:	bfd9                	j	800029e0 <waitx+0xec>
    if (!havekids || p->killed)
    80002a0c:	c305                	beqz	a4,80002a2c <waitx+0x138>
    80002a0e:	02892783          	lw	a5,40(s2)
    80002a12:	ef89                	bnez	a5,80002a2c <waitx+0x138>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002a14:	85ea                	mv	a1,s10
    80002a16:	854a                	mv	a0,s2
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	96c080e7          	jalr	-1684(ra) # 80002384 <sleep>
    havekids = 0;
    80002a20:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002a22:	0002e497          	auipc	s1,0x2e
    80002a26:	56648493          	addi	s1,s1,1382 # 80030f88 <proc>
    80002a2a:	bf7d                	j	800029e8 <waitx+0xf4>
      release(&wait_lock);
    80002a2c:	0002e517          	auipc	a0,0x2e
    80002a30:	14450513          	addi	a0,a0,324 # 80030b70 <wait_lock>
    80002a34:	ffffe097          	auipc	ra,0xffffe
    80002a38:	3d6080e7          	jalr	982(ra) # 80000e0a <release>
      return -1;
    80002a3c:	59fd                	li	s3,-1
    80002a3e:	b79d                	j	800029a4 <waitx+0xb0>

0000000080002a40 <update_time>:

void update_time()
{
    80002a40:	7179                	addi	sp,sp,-48
    80002a42:	f406                	sd	ra,40(sp)
    80002a44:	f022                	sd	s0,32(sp)
    80002a46:	ec26                	sd	s1,24(sp)
    80002a48:	e84a                	sd	s2,16(sp)
    80002a4a:	e44e                	sd	s3,8(sp)
    80002a4c:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002a4e:	0002e497          	auipc	s1,0x2e
    80002a52:	53a48493          	addi	s1,s1,1338 # 80030f88 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002a56:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002a58:	00034917          	auipc	s2,0x34
    80002a5c:	33090913          	addi	s2,s2,816 # 80036d88 <tickslock>
    80002a60:	a811                	j	80002a74 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002a62:	8526                	mv	a0,s1
    80002a64:	ffffe097          	auipc	ra,0xffffe
    80002a68:	3a6080e7          	jalr	934(ra) # 80000e0a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002a6c:	17848493          	addi	s1,s1,376
    80002a70:	03248063          	beq	s1,s2,80002a90 <update_time+0x50>
    acquire(&p->lock);
    80002a74:	8526                	mv	a0,s1
    80002a76:	ffffe097          	auipc	ra,0xffffe
    80002a7a:	2e0080e7          	jalr	736(ra) # 80000d56 <acquire>
    if (p->state == RUNNING)
    80002a7e:	4c9c                	lw	a5,24(s1)
    80002a80:	ff3791e3          	bne	a5,s3,80002a62 <update_time+0x22>
      p->rtime++;
    80002a84:	1684a783          	lw	a5,360(s1)
    80002a88:	2785                	addiw	a5,a5,1
    80002a8a:	16f4a423          	sw	a5,360(s1)
    80002a8e:	bfd1                	j	80002a62 <update_time+0x22>
  }
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret

0000000080002a9e <swtch>:
    80002a9e:	00153023          	sd	ra,0(a0)
    80002aa2:	00253423          	sd	sp,8(a0)
    80002aa6:	e900                	sd	s0,16(a0)
    80002aa8:	ed04                	sd	s1,24(a0)
    80002aaa:	03253023          	sd	s2,32(a0)
    80002aae:	03353423          	sd	s3,40(a0)
    80002ab2:	03453823          	sd	s4,48(a0)
    80002ab6:	03553c23          	sd	s5,56(a0)
    80002aba:	05653023          	sd	s6,64(a0)
    80002abe:	05753423          	sd	s7,72(a0)
    80002ac2:	05853823          	sd	s8,80(a0)
    80002ac6:	05953c23          	sd	s9,88(a0)
    80002aca:	07a53023          	sd	s10,96(a0)
    80002ace:	07b53423          	sd	s11,104(a0)
    80002ad2:	0005b083          	ld	ra,0(a1)
    80002ad6:	0085b103          	ld	sp,8(a1)
    80002ada:	6980                	ld	s0,16(a1)
    80002adc:	6d84                	ld	s1,24(a1)
    80002ade:	0205b903          	ld	s2,32(a1)
    80002ae2:	0285b983          	ld	s3,40(a1)
    80002ae6:	0305ba03          	ld	s4,48(a1)
    80002aea:	0385ba83          	ld	s5,56(a1)
    80002aee:	0405bb03          	ld	s6,64(a1)
    80002af2:	0485bb83          	ld	s7,72(a1)
    80002af6:	0505bc03          	ld	s8,80(a1)
    80002afa:	0585bc83          	ld	s9,88(a1)
    80002afe:	0605bd03          	ld	s10,96(a1)
    80002b02:	0685bd83          	ld	s11,104(a1)
    80002b06:	8082                	ret

0000000080002b08 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b08:	1141                	addi	sp,sp,-16
    80002b0a:	e406                	sd	ra,8(sp)
    80002b0c:	e022                	sd	s0,0(sp)
    80002b0e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b10:	00005597          	auipc	a1,0x5
    80002b14:	7a058593          	addi	a1,a1,1952 # 800082b0 <etext+0x2b0>
    80002b18:	00034517          	auipc	a0,0x34
    80002b1c:	27050513          	addi	a0,a0,624 # 80036d88 <tickslock>
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	1a6080e7          	jalr	422(ra) # 80000cc6 <initlock>
}
    80002b28:	60a2                	ld	ra,8(sp)
    80002b2a:	6402                	ld	s0,0(sp)
    80002b2c:	0141                	addi	sp,sp,16
    80002b2e:	8082                	ret

0000000080002b30 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002b30:	1141                	addi	sp,sp,-16
    80002b32:	e422                	sd	s0,8(sp)
    80002b34:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b36:	00003797          	auipc	a5,0x3
    80002b3a:	75a78793          	addi	a5,a5,1882 # 80006290 <kernelvec>
    80002b3e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b42:	6422                	ld	s0,8(sp)
    80002b44:	0141                	addi	sp,sp,16
    80002b46:	8082                	ret

0000000080002b48 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b48:	1141                	addi	sp,sp,-16
    80002b4a:	e406                	sd	ra,8(sp)
    80002b4c:	e022                	sd	s0,0(sp)
    80002b4e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b50:	fffff097          	auipc	ra,0xfffff
    80002b54:	176080e7          	jalr	374(ra) # 80001cc6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b5c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b5e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b62:	00004697          	auipc	a3,0x4
    80002b66:	49e68693          	addi	a3,a3,1182 # 80007000 <_trampoline>
    80002b6a:	00004717          	auipc	a4,0x4
    80002b6e:	49670713          	addi	a4,a4,1174 # 80007000 <_trampoline>
    80002b72:	8f15                	sub	a4,a4,a3
    80002b74:	040007b7          	lui	a5,0x4000
    80002b78:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b7a:	07b2                	slli	a5,a5,0xc
    80002b7c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b7e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b82:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002b84:	18002673          	csrr	a2,satp
    80002b88:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b8a:	6d30                	ld	a2,88(a0)
    80002b8c:	6138                	ld	a4,64(a0)
    80002b8e:	6585                	lui	a1,0x1
    80002b90:	972e                	add	a4,a4,a1
    80002b92:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b94:	6d38                	ld	a4,88(a0)
    80002b96:	00000617          	auipc	a2,0x0
    80002b9a:	14660613          	addi	a2,a2,326 # 80002cdc <usertrap>
    80002b9e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002ba0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ba2:	8612                	mv	a2,tp
    80002ba4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002baa:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bae:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bb2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bb6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bb8:	6f18                	ld	a4,24(a4)
    80002bba:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bbe:	6928                	ld	a0,80(a0)
    80002bc0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002bc2:	00004717          	auipc	a4,0x4
    80002bc6:	4da70713          	addi	a4,a4,1242 # 8000709c <userret>
    80002bca:	8f15                	sub	a4,a4,a3
    80002bcc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002bce:	577d                	li	a4,-1
    80002bd0:	177e                	slli	a4,a4,0x3f
    80002bd2:	8d59                	or	a0,a0,a4
    80002bd4:	9782                	jalr	a5
}
    80002bd6:	60a2                	ld	ra,8(sp)
    80002bd8:	6402                	ld	s0,0(sp)
    80002bda:	0141                	addi	sp,sp,16
    80002bdc:	8082                	ret

0000000080002bde <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002bde:	1101                	addi	sp,sp,-32
    80002be0:	ec06                	sd	ra,24(sp)
    80002be2:	e822                	sd	s0,16(sp)
    80002be4:	e426                	sd	s1,8(sp)
    80002be6:	e04a                	sd	s2,0(sp)
    80002be8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002bea:	00034917          	auipc	s2,0x34
    80002bee:	19e90913          	addi	s2,s2,414 # 80036d88 <tickslock>
    80002bf2:	854a                	mv	a0,s2
    80002bf4:	ffffe097          	auipc	ra,0xffffe
    80002bf8:	162080e7          	jalr	354(ra) # 80000d56 <acquire>
  ticks++;
    80002bfc:	00006497          	auipc	s1,0x6
    80002c00:	cd448493          	addi	s1,s1,-812 # 800088d0 <ticks>
    80002c04:	409c                	lw	a5,0(s1)
    80002c06:	2785                	addiw	a5,a5,1
    80002c08:	c09c                	sw	a5,0(s1)
  update_time();
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	e36080e7          	jalr	-458(ra) # 80002a40 <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002c12:	8526                	mv	a0,s1
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	7d4080e7          	jalr	2004(ra) # 800023e8 <wakeup>
  release(&tickslock);
    80002c1c:	854a                	mv	a0,s2
    80002c1e:	ffffe097          	auipc	ra,0xffffe
    80002c22:	1ec080e7          	jalr	492(ra) # 80000e0a <release>
}
    80002c26:	60e2                	ld	ra,24(sp)
    80002c28:	6442                	ld	s0,16(sp)
    80002c2a:	64a2                	ld	s1,8(sp)
    80002c2c:	6902                	ld	s2,0(sp)
    80002c2e:	6105                	addi	sp,sp,32
    80002c30:	8082                	ret

0000000080002c32 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c32:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002c36:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002c38:	0a07d163          	bgez	a5,80002cda <devintr+0xa8>
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80002c44:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002c48:	46a5                	li	a3,9
    80002c4a:	00d70c63          	beq	a4,a3,80002c62 <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80002c4e:	577d                	li	a4,-1
    80002c50:	177e                	slli	a4,a4,0x3f
    80002c52:	0705                	addi	a4,a4,1
    return 0;
    80002c54:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002c56:	06e78163          	beq	a5,a4,80002cb8 <devintr+0x86>
  }
}
    80002c5a:	60e2                	ld	ra,24(sp)
    80002c5c:	6442                	ld	s0,16(sp)
    80002c5e:	6105                	addi	sp,sp,32
    80002c60:	8082                	ret
    80002c62:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002c64:	00003097          	auipc	ra,0x3
    80002c68:	738080e7          	jalr	1848(ra) # 8000639c <plic_claim>
    80002c6c:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002c6e:	47a9                	li	a5,10
    80002c70:	00f50963          	beq	a0,a5,80002c82 <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80002c74:	4785                	li	a5,1
    80002c76:	00f50b63          	beq	a0,a5,80002c8c <devintr+0x5a>
    return 1;
    80002c7a:	4505                	li	a0,1
    else if (irq)
    80002c7c:	ec89                	bnez	s1,80002c96 <devintr+0x64>
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	bfe9                	j	80002c5a <devintr+0x28>
      uartintr();
    80002c82:	ffffe097          	auipc	ra,0xffffe
    80002c86:	d78080e7          	jalr	-648(ra) # 800009fa <uartintr>
    if (irq)
    80002c8a:	a839                	j	80002ca8 <devintr+0x76>
      virtio_disk_intr();
    80002c8c:	00004097          	auipc	ra,0x4
    80002c90:	c3a080e7          	jalr	-966(ra) # 800068c6 <virtio_disk_intr>
    if (irq)
    80002c94:	a811                	j	80002ca8 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c96:	85a6                	mv	a1,s1
    80002c98:	00005517          	auipc	a0,0x5
    80002c9c:	62050513          	addi	a0,a0,1568 # 800082b8 <etext+0x2b8>
    80002ca0:	ffffe097          	auipc	ra,0xffffe
    80002ca4:	90a080e7          	jalr	-1782(ra) # 800005aa <printf>
      plic_complete(irq);
    80002ca8:	8526                	mv	a0,s1
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	716080e7          	jalr	1814(ra) # 800063c0 <plic_complete>
    return 1;
    80002cb2:	4505                	li	a0,1
    80002cb4:	64a2                	ld	s1,8(sp)
    80002cb6:	b755                	j	80002c5a <devintr+0x28>
    if (cpuid() == 0)
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	fe2080e7          	jalr	-30(ra) # 80001c9a <cpuid>
    80002cc0:	c901                	beqz	a0,80002cd0 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cc2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cc8:	14479073          	csrw	sip,a5
    return 2;
    80002ccc:	4509                	li	a0,2
    80002cce:	b771                	j	80002c5a <devintr+0x28>
      clockintr();
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	f0e080e7          	jalr	-242(ra) # 80002bde <clockintr>
    80002cd8:	b7ed                	j	80002cc2 <devintr+0x90>
}
    80002cda:	8082                	ret

0000000080002cdc <usertrap>:
{
    80002cdc:	7139                	addi	sp,sp,-64
    80002cde:	fc06                	sd	ra,56(sp)
    80002ce0:	f822                	sd	s0,48(sp)
    80002ce2:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ce4:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002ce8:	1007f793          	andi	a5,a5,256
    80002cec:	ebd5                	bnez	a5,80002da0 <usertrap+0xc4>
    80002cee:	f426                	sd	s1,40(sp)
    80002cf0:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cf2:	00003797          	auipc	a5,0x3
    80002cf6:	59e78793          	addi	a5,a5,1438 # 80006290 <kernelvec>
    80002cfa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	fc8080e7          	jalr	-56(ra) # 80001cc6 <myproc>
    80002d06:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d08:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d0a:	14102773          	csrr	a4,sepc
    80002d0e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d10:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002d14:	47a1                	li	a5,8
    80002d16:	0af70263          	beq	a4,a5,80002dba <usertrap+0xde>
  else if ((which_dev = devintr()) != 0)
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	f18080e7          	jalr	-232(ra) # 80002c32 <devintr>
    80002d22:	892a                	mv	s2,a0
    80002d24:	1a051463          	bnez	a0,80002ecc <usertrap+0x1f0>
    80002d28:	14202773          	csrr	a4,scause
  else if(r_scause() == 15)
    80002d2c:	47bd                	li	a5,15
    80002d2e:	16f71263          	bne	a4,a5,80002e92 <usertrap+0x1b6>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d32:	14302973          	csrr	s2,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002d36:	77fd                	lui	a5,0xfffff
    80002d38:	00f97933          	and	s2,s2,a5
    if (va >= MAXVA)
    80002d3c:	57fd                	li	a5,-1
    80002d3e:	83e9                	srli	a5,a5,0x1a
    80002d40:	0d27e663          	bltu	a5,s2,80002e0c <usertrap+0x130>
    if (va == 0)
    80002d44:	0c090c63          	beqz	s2,80002e1c <usertrap+0x140>
    pte_t *pte = walk(p->pagetable, va, 0);
    80002d48:	4601                	li	a2,0
    80002d4a:	85ca                	mv	a1,s2
    80002d4c:	68a8                	ld	a0,80(s1)
    80002d4e:	ffffe097          	auipc	ra,0xffffe
    80002d52:	3e0080e7          	jalr	992(ra) # 8000112e <walk>
    uint64 pa = PTE2PA(*pte);
    80002d56:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_COW) != 0)
    80002d58:	1007f713          	andi	a4,a5,256
    80002d5c:	c351                	beqz	a4,80002de0 <usertrap+0x104>
    80002d5e:	ec4e                	sd	s3,24(sp)
    80002d60:	e852                	sd	s4,16(sp)
    uint64 pa = PTE2PA(*pte);
    80002d62:	00a7da13          	srli	s4,a5,0xa
    80002d66:	0a32                	slli	s4,s4,0xc
      flags &= ~PTE_COW; 
    80002d68:	2ff7f993          	andi	s3,a5,767
      flags |= PTE_W;
    80002d6c:	0049e993          	ori	s3,s3,4
      if (ref_count[(pa - KERNBASE) / PGSIZE] != 1)
    80002d70:	80000737          	lui	a4,0x80000
    80002d74:	9752                	add	a4,a4,s4
    80002d76:	8329                	srli	a4,a4,0xa
    80002d78:	0000e697          	auipc	a3,0xe
    80002d7c:	de068693          	addi	a3,a3,-544 # 80010b58 <ref_count>
    80002d80:	9736                	add	a4,a4,a3
    80002d82:	4314                	lw	a3,0(a4)
    80002d84:	4705                	li	a4,1
    80002d86:	0ae69163          	bne	a3,a4,80002e28 <usertrap+0x14c>
        *pte |= flags;
    80002d8a:	00f9e9b3          	or	s3,s3,a5
    80002d8e:	01353023          	sd	s3,0(a0)
      p->trapframe->epc = r_sepc();
    80002d92:	6cbc                	ld	a5,88(s1)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d94:	14102773          	csrr	a4,sepc
    80002d98:	ef98                	sd	a4,24(a5)
    80002d9a:	69e2                	ld	s3,24(sp)
    80002d9c:	6a42                	ld	s4,16(sp)
    80002d9e:	a089                	j	80002de0 <usertrap+0x104>
    80002da0:	f426                	sd	s1,40(sp)
    80002da2:	f04a                	sd	s2,32(sp)
    80002da4:	ec4e                	sd	s3,24(sp)
    80002da6:	e852                	sd	s4,16(sp)
    80002da8:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	52e50513          	addi	a0,a0,1326 # 800082d8 <etext+0x2d8>
    80002db2:	ffffd097          	auipc	ra,0xffffd
    80002db6:	7ae080e7          	jalr	1966(ra) # 80000560 <panic>
    if (killed(p))
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	87e080e7          	jalr	-1922(ra) # 80002638 <killed>
    80002dc2:	ed1d                	bnez	a0,80002e00 <usertrap+0x124>
    p->trapframe->epc += 4;
    80002dc4:	6cb8                	ld	a4,88(s1)
    80002dc6:	6f1c                	ld	a5,24(a4)
    80002dc8:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffbce9c>
    80002dca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002dd0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dd4:	10079073          	csrw	sstatus,a5
    syscall();
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	368080e7          	jalr	872(ra) # 80003140 <syscall>
  if (killed(p))
    80002de0:	8526                	mv	a0,s1
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	856080e7          	jalr	-1962(ra) # 80002638 <killed>
    80002dea:	e965                	bnez	a0,80002eda <usertrap+0x1fe>
  usertrapret();
    80002dec:	00000097          	auipc	ra,0x0
    80002df0:	d5c080e7          	jalr	-676(ra) # 80002b48 <usertrapret>
    80002df4:	74a2                	ld	s1,40(sp)
    80002df6:	7902                	ld	s2,32(sp)
}
    80002df8:	70e2                	ld	ra,56(sp)
    80002dfa:	7442                	ld	s0,48(sp)
    80002dfc:	6121                	addi	sp,sp,64
    80002dfe:	8082                	ret
      exit(-1);
    80002e00:	557d                	li	a0,-1
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	6b6080e7          	jalr	1718(ra) # 800024b8 <exit>
    80002e0a:	bf6d                	j	80002dc4 <usertrap+0xe8>
      p->killed = 1;
    80002e0c:	4785                	li	a5,1
    80002e0e:	d49c                	sw	a5,40(s1)
      exit(-1);
    80002e10:	557d                	li	a0,-1
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	6a6080e7          	jalr	1702(ra) # 800024b8 <exit>
    if (va == 0)
    80002e1a:	b73d                	j	80002d48 <usertrap+0x6c>
      exit(-1);
    80002e1c:	557d                	li	a0,-1
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	69a080e7          	jalr	1690(ra) # 800024b8 <exit>
    80002e26:	b70d                	j	80002d48 <usertrap+0x6c>
    80002e28:	e456                	sd	s5,8(sp)
        char *mem = kalloc();
    80002e2a:	ffffe097          	auipc	ra,0xffffe
    80002e2e:	dfe080e7          	jalr	-514(ra) # 80000c28 <kalloc>
    80002e32:	8aaa                	mv	s5,a0
        if (mem == 0)
    80002e34:	c129                	beqz	a0,80002e76 <usertrap+0x19a>
        memmove(mem, (char *)pa, PGSIZE);
    80002e36:	6605                	lui	a2,0x1
    80002e38:	85d2                	mv	a1,s4
    80002e3a:	8556                	mv	a0,s5
    80002e3c:	ffffe097          	auipc	ra,0xffffe
    80002e40:	072080e7          	jalr	114(ra) # 80000eae <memmove>
        uvmunmap(p->pagetable, va, 1, 0);
    80002e44:	4681                	li	a3,0
    80002e46:	4605                	li	a2,1
    80002e48:	85ca                	mv	a1,s2
    80002e4a:	68a8                	ld	a0,80(s1)
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	590080e7          	jalr	1424(ra) # 800013dc <uvmunmap>
        if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, flags) != 0)
    80002e54:	874e                	mv	a4,s3
    80002e56:	86d6                	mv	a3,s5
    80002e58:	6605                	lui	a2,0x1
    80002e5a:	85ca                	mv	a1,s2
    80002e5c:	68a8                	ld	a0,80(s1)
    80002e5e:	ffffe097          	auipc	ra,0xffffe
    80002e62:	3b8080e7          	jalr	952(ra) # 80001216 <mappages>
    80002e66:	e105                	bnez	a0,80002e86 <usertrap+0x1aa>
        kfree((char *)pa);
    80002e68:	8552                	mv	a0,s4
    80002e6a:	ffffe097          	auipc	ra,0xffffe
    80002e6e:	be0080e7          	jalr	-1056(ra) # 80000a4a <kfree>
    80002e72:	6aa2                	ld	s5,8(sp)
    80002e74:	bf39                	j	80002d92 <usertrap+0xb6>
          p->killed = 1;
    80002e76:	4785                	li	a5,1
    80002e78:	d49c                	sw	a5,40(s1)
          exit(-1);
    80002e7a:	557d                	li	a0,-1
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	63c080e7          	jalr	1596(ra) # 800024b8 <exit>
    80002e84:	bf4d                	j	80002e36 <usertrap+0x15a>
          exit(-1);
    80002e86:	557d                	li	a0,-1
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	630080e7          	jalr	1584(ra) # 800024b8 <exit>
    80002e90:	bfe1                	j	80002e68 <usertrap+0x18c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e92:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e96:	5890                	lw	a2,48(s1)
    80002e98:	00005517          	auipc	a0,0x5
    80002e9c:	46050513          	addi	a0,a0,1120 # 800082f8 <etext+0x2f8>
    80002ea0:	ffffd097          	auipc	ra,0xffffd
    80002ea4:	70a080e7          	jalr	1802(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ea8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eac:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002eb0:	00005517          	auipc	a0,0x5
    80002eb4:	47850513          	addi	a0,a0,1144 # 80008328 <etext+0x328>
    80002eb8:	ffffd097          	auipc	ra,0xffffd
    80002ebc:	6f2080e7          	jalr	1778(ra) # 800005aa <printf>
    setkilled(p);
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	74a080e7          	jalr	1866(ra) # 8000260c <setkilled>
    80002eca:	bf19                	j	80002de0 <usertrap+0x104>
  if (killed(p))
    80002ecc:	8526                	mv	a0,s1
    80002ece:	fffff097          	auipc	ra,0xfffff
    80002ed2:	76a080e7          	jalr	1898(ra) # 80002638 <killed>
    80002ed6:	c901                	beqz	a0,80002ee6 <usertrap+0x20a>
    80002ed8:	a011                	j	80002edc <usertrap+0x200>
    80002eda:	4901                	li	s2,0
    exit(-1);
    80002edc:	557d                	li	a0,-1
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	5da080e7          	jalr	1498(ra) # 800024b8 <exit>
  if (which_dev == 2)
    80002ee6:	4789                	li	a5,2
    80002ee8:	f0f912e3          	bne	s2,a5,80002dec <usertrap+0x110>
    yield();
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	45c080e7          	jalr	1116(ra) # 80002348 <yield>
    80002ef4:	bde5                	j	80002dec <usertrap+0x110>

0000000080002ef6 <kerneltrap>:
{
    80002ef6:	7179                	addi	sp,sp,-48
    80002ef8:	f406                	sd	ra,40(sp)
    80002efa:	f022                	sd	s0,32(sp)
    80002efc:	ec26                	sd	s1,24(sp)
    80002efe:	e84a                	sd	s2,16(sp)
    80002f00:	e44e                	sd	s3,8(sp)
    80002f02:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f0c:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002f10:	1004f793          	andi	a5,s1,256
    80002f14:	cb85                	beqz	a5,80002f44 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f1a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002f1c:	ef85                	bnez	a5,80002f54 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	d14080e7          	jalr	-748(ra) # 80002c32 <devintr>
    80002f26:	cd1d                	beqz	a0,80002f64 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f28:	4789                	li	a5,2
    80002f2a:	06f50a63          	beq	a0,a5,80002f9e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f32:	10049073          	csrw	sstatus,s1
}
    80002f36:	70a2                	ld	ra,40(sp)
    80002f38:	7402                	ld	s0,32(sp)
    80002f3a:	64e2                	ld	s1,24(sp)
    80002f3c:	6942                	ld	s2,16(sp)
    80002f3e:	69a2                	ld	s3,8(sp)
    80002f40:	6145                	addi	sp,sp,48
    80002f42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f44:	00005517          	auipc	a0,0x5
    80002f48:	40450513          	addi	a0,a0,1028 # 80008348 <etext+0x348>
    80002f4c:	ffffd097          	auipc	ra,0xffffd
    80002f50:	614080e7          	jalr	1556(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002f54:	00005517          	auipc	a0,0x5
    80002f58:	41c50513          	addi	a0,a0,1052 # 80008370 <etext+0x370>
    80002f5c:	ffffd097          	auipc	ra,0xffffd
    80002f60:	604080e7          	jalr	1540(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002f64:	85ce                	mv	a1,s3
    80002f66:	00005517          	auipc	a0,0x5
    80002f6a:	42a50513          	addi	a0,a0,1066 # 80008390 <etext+0x390>
    80002f6e:	ffffd097          	auipc	ra,0xffffd
    80002f72:	63c080e7          	jalr	1596(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f76:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f7a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f7e:	00005517          	auipc	a0,0x5
    80002f82:	42250513          	addi	a0,a0,1058 # 800083a0 <etext+0x3a0>
    80002f86:	ffffd097          	auipc	ra,0xffffd
    80002f8a:	624080e7          	jalr	1572(ra) # 800005aa <printf>
    panic("kerneltrap");
    80002f8e:	00005517          	auipc	a0,0x5
    80002f92:	42a50513          	addi	a0,a0,1066 # 800083b8 <etext+0x3b8>
    80002f96:	ffffd097          	auipc	ra,0xffffd
    80002f9a:	5ca080e7          	jalr	1482(ra) # 80000560 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	d28080e7          	jalr	-728(ra) # 80001cc6 <myproc>
    80002fa6:	d541                	beqz	a0,80002f2e <kerneltrap+0x38>
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	d1e080e7          	jalr	-738(ra) # 80001cc6 <myproc>
    80002fb0:	4d18                	lw	a4,24(a0)
    80002fb2:	4791                	li	a5,4
    80002fb4:	f6f71de3          	bne	a4,a5,80002f2e <kerneltrap+0x38>
    yield();
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	390080e7          	jalr	912(ra) # 80002348 <yield>
    80002fc0:	b7bd                	j	80002f2e <kerneltrap+0x38>

0000000080002fc2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	1000                	addi	s0,sp,32
    80002fcc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	cf8080e7          	jalr	-776(ra) # 80001cc6 <myproc>
  switch (n) {
    80002fd6:	4795                	li	a5,5
    80002fd8:	0497e163          	bltu	a5,s1,8000301a <argraw+0x58>
    80002fdc:	048a                	slli	s1,s1,0x2
    80002fde:	00005717          	auipc	a4,0x5
    80002fe2:	79a70713          	addi	a4,a4,1946 # 80008778 <states.0+0x30>
    80002fe6:	94ba                	add	s1,s1,a4
    80002fe8:	409c                	lw	a5,0(s1)
    80002fea:	97ba                	add	a5,a5,a4
    80002fec:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002fee:	6d3c                	ld	a5,88(a0)
    80002ff0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6105                	addi	sp,sp,32
    80002ffa:	8082                	ret
    return p->trapframe->a1;
    80002ffc:	6d3c                	ld	a5,88(a0)
    80002ffe:	7fa8                	ld	a0,120(a5)
    80003000:	bfcd                	j	80002ff2 <argraw+0x30>
    return p->trapframe->a2;
    80003002:	6d3c                	ld	a5,88(a0)
    80003004:	63c8                	ld	a0,128(a5)
    80003006:	b7f5                	j	80002ff2 <argraw+0x30>
    return p->trapframe->a3;
    80003008:	6d3c                	ld	a5,88(a0)
    8000300a:	67c8                	ld	a0,136(a5)
    8000300c:	b7dd                	j	80002ff2 <argraw+0x30>
    return p->trapframe->a4;
    8000300e:	6d3c                	ld	a5,88(a0)
    80003010:	6bc8                	ld	a0,144(a5)
    80003012:	b7c5                	j	80002ff2 <argraw+0x30>
    return p->trapframe->a5;
    80003014:	6d3c                	ld	a5,88(a0)
    80003016:	6fc8                	ld	a0,152(a5)
    80003018:	bfe9                	j	80002ff2 <argraw+0x30>
  panic("argraw");
    8000301a:	00005517          	auipc	a0,0x5
    8000301e:	3ae50513          	addi	a0,a0,942 # 800083c8 <etext+0x3c8>
    80003022:	ffffd097          	auipc	ra,0xffffd
    80003026:	53e080e7          	jalr	1342(ra) # 80000560 <panic>

000000008000302a <fetchaddr>:
{
    8000302a:	1101                	addi	sp,sp,-32
    8000302c:	ec06                	sd	ra,24(sp)
    8000302e:	e822                	sd	s0,16(sp)
    80003030:	e426                	sd	s1,8(sp)
    80003032:	e04a                	sd	s2,0(sp)
    80003034:	1000                	addi	s0,sp,32
    80003036:	84aa                	mv	s1,a0
    80003038:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	c8c080e7          	jalr	-884(ra) # 80001cc6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003042:	653c                	ld	a5,72(a0)
    80003044:	02f4f863          	bgeu	s1,a5,80003074 <fetchaddr+0x4a>
    80003048:	00848713          	addi	a4,s1,8
    8000304c:	02e7e663          	bltu	a5,a4,80003078 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003050:	46a1                	li	a3,8
    80003052:	8626                	mv	a2,s1
    80003054:	85ca                	mv	a1,s2
    80003056:	6928                	ld	a0,80(a0)
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	992080e7          	jalr	-1646(ra) # 800019ea <copyin>
    80003060:	00a03533          	snez	a0,a0
    80003064:	40a00533          	neg	a0,a0
}
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6902                	ld	s2,0(sp)
    80003070:	6105                	addi	sp,sp,32
    80003072:	8082                	ret
    return -1;
    80003074:	557d                	li	a0,-1
    80003076:	bfcd                	j	80003068 <fetchaddr+0x3e>
    80003078:	557d                	li	a0,-1
    8000307a:	b7fd                	j	80003068 <fetchaddr+0x3e>

000000008000307c <fetchstr>:
{
    8000307c:	7179                	addi	sp,sp,-48
    8000307e:	f406                	sd	ra,40(sp)
    80003080:	f022                	sd	s0,32(sp)
    80003082:	ec26                	sd	s1,24(sp)
    80003084:	e84a                	sd	s2,16(sp)
    80003086:	e44e                	sd	s3,8(sp)
    80003088:	1800                	addi	s0,sp,48
    8000308a:	892a                	mv	s2,a0
    8000308c:	84ae                	mv	s1,a1
    8000308e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	c36080e7          	jalr	-970(ra) # 80001cc6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003098:	86ce                	mv	a3,s3
    8000309a:	864a                	mv	a2,s2
    8000309c:	85a6                	mv	a1,s1
    8000309e:	6928                	ld	a0,80(a0)
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	9d8080e7          	jalr	-1576(ra) # 80001a78 <copyinstr>
    800030a8:	00054e63          	bltz	a0,800030c4 <fetchstr+0x48>
  return strlen(buf);
    800030ac:	8526                	mv	a0,s1
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	f18080e7          	jalr	-232(ra) # 80000fc6 <strlen>
}
    800030b6:	70a2                	ld	ra,40(sp)
    800030b8:	7402                	ld	s0,32(sp)
    800030ba:	64e2                	ld	s1,24(sp)
    800030bc:	6942                	ld	s2,16(sp)
    800030be:	69a2                	ld	s3,8(sp)
    800030c0:	6145                	addi	sp,sp,48
    800030c2:	8082                	ret
    return -1;
    800030c4:	557d                	li	a0,-1
    800030c6:	bfc5                	j	800030b6 <fetchstr+0x3a>

00000000800030c8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800030c8:	1101                	addi	sp,sp,-32
    800030ca:	ec06                	sd	ra,24(sp)
    800030cc:	e822                	sd	s0,16(sp)
    800030ce:	e426                	sd	s1,8(sp)
    800030d0:	1000                	addi	s0,sp,32
    800030d2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	eee080e7          	jalr	-274(ra) # 80002fc2 <argraw>
    800030dc:	c088                	sw	a0,0(s1)
}
    800030de:	60e2                	ld	ra,24(sp)
    800030e0:	6442                	ld	s0,16(sp)
    800030e2:	64a2                	ld	s1,8(sp)
    800030e4:	6105                	addi	sp,sp,32
    800030e6:	8082                	ret

00000000800030e8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800030e8:	1101                	addi	sp,sp,-32
    800030ea:	ec06                	sd	ra,24(sp)
    800030ec:	e822                	sd	s0,16(sp)
    800030ee:	e426                	sd	s1,8(sp)
    800030f0:	1000                	addi	s0,sp,32
    800030f2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	ece080e7          	jalr	-306(ra) # 80002fc2 <argraw>
    800030fc:	e088                	sd	a0,0(s1)
}
    800030fe:	60e2                	ld	ra,24(sp)
    80003100:	6442                	ld	s0,16(sp)
    80003102:	64a2                	ld	s1,8(sp)
    80003104:	6105                	addi	sp,sp,32
    80003106:	8082                	ret

0000000080003108 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003108:	7179                	addi	sp,sp,-48
    8000310a:	f406                	sd	ra,40(sp)
    8000310c:	f022                	sd	s0,32(sp)
    8000310e:	ec26                	sd	s1,24(sp)
    80003110:	e84a                	sd	s2,16(sp)
    80003112:	1800                	addi	s0,sp,48
    80003114:	84ae                	mv	s1,a1
    80003116:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003118:	fd840593          	addi	a1,s0,-40
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	fcc080e7          	jalr	-52(ra) # 800030e8 <argaddr>
  return fetchstr(addr, buf, max);
    80003124:	864a                	mv	a2,s2
    80003126:	85a6                	mv	a1,s1
    80003128:	fd843503          	ld	a0,-40(s0)
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	f50080e7          	jalr	-176(ra) # 8000307c <fetchstr>
}
    80003134:	70a2                	ld	ra,40(sp)
    80003136:	7402                	ld	s0,32(sp)
    80003138:	64e2                	ld	s1,24(sp)
    8000313a:	6942                	ld	s2,16(sp)
    8000313c:	6145                	addi	sp,sp,48
    8000313e:	8082                	ret

0000000080003140 <syscall>:
[SYS_waitx]   sys_waitx,
};

void
syscall(void)
{
    80003140:	1101                	addi	sp,sp,-32
    80003142:	ec06                	sd	ra,24(sp)
    80003144:	e822                	sd	s0,16(sp)
    80003146:	e426                	sd	s1,8(sp)
    80003148:	e04a                	sd	s2,0(sp)
    8000314a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	b7a080e7          	jalr	-1158(ra) # 80001cc6 <myproc>
    80003154:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003156:	05853903          	ld	s2,88(a0)
    8000315a:	0a893783          	ld	a5,168(s2)
    8000315e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003162:	37fd                	addiw	a5,a5,-1
    80003164:	4755                	li	a4,21
    80003166:	00f76f63          	bltu	a4,a5,80003184 <syscall+0x44>
    8000316a:	00369713          	slli	a4,a3,0x3
    8000316e:	00005797          	auipc	a5,0x5
    80003172:	62278793          	addi	a5,a5,1570 # 80008790 <syscalls>
    80003176:	97ba                	add	a5,a5,a4
    80003178:	639c                	ld	a5,0(a5)
    8000317a:	c789                	beqz	a5,80003184 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000317c:	9782                	jalr	a5
    8000317e:	06a93823          	sd	a0,112(s2)
    80003182:	a839                	j	800031a0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003184:	15848613          	addi	a2,s1,344
    80003188:	588c                	lw	a1,48(s1)
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	24650513          	addi	a0,a0,582 # 800083d0 <etext+0x3d0>
    80003192:	ffffd097          	auipc	ra,0xffffd
    80003196:	418080e7          	jalr	1048(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000319a:	6cbc                	ld	a5,88(s1)
    8000319c:	577d                	li	a4,-1
    8000319e:	fbb8                	sd	a4,112(a5)
  }
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6902                	ld	s2,0(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret

00000000800031ac <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800031ac:	1101                	addi	sp,sp,-32
    800031ae:	ec06                	sd	ra,24(sp)
    800031b0:	e822                	sd	s0,16(sp)
    800031b2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800031b4:	fec40593          	addi	a1,s0,-20
    800031b8:	4501                	li	a0,0
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	f0e080e7          	jalr	-242(ra) # 800030c8 <argint>
  exit(n);
    800031c2:	fec42503          	lw	a0,-20(s0)
    800031c6:	fffff097          	auipc	ra,0xfffff
    800031ca:	2f2080e7          	jalr	754(ra) # 800024b8 <exit>
  return 0; // not reached
}
    800031ce:	4501                	li	a0,0
    800031d0:	60e2                	ld	ra,24(sp)
    800031d2:	6442                	ld	s0,16(sp)
    800031d4:	6105                	addi	sp,sp,32
    800031d6:	8082                	ret

00000000800031d8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800031d8:	1141                	addi	sp,sp,-16
    800031da:	e406                	sd	ra,8(sp)
    800031dc:	e022                	sd	s0,0(sp)
    800031de:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	ae6080e7          	jalr	-1306(ra) # 80001cc6 <myproc>
}
    800031e8:	5908                	lw	a0,48(a0)
    800031ea:	60a2                	ld	ra,8(sp)
    800031ec:	6402                	ld	s0,0(sp)
    800031ee:	0141                	addi	sp,sp,16
    800031f0:	8082                	ret

00000000800031f2 <sys_fork>:

uint64
sys_fork(void)
{
    800031f2:	1141                	addi	sp,sp,-16
    800031f4:	e406                	sd	ra,8(sp)
    800031f6:	e022                	sd	s0,0(sp)
    800031f8:	0800                	addi	s0,sp,16
  return fork();
    800031fa:	fffff097          	auipc	ra,0xfffff
    800031fe:	e96080e7          	jalr	-362(ra) # 80002090 <fork>
}
    80003202:	60a2                	ld	ra,8(sp)
    80003204:	6402                	ld	s0,0(sp)
    80003206:	0141                	addi	sp,sp,16
    80003208:	8082                	ret

000000008000320a <sys_wait>:

uint64
sys_wait(void)
{
    8000320a:	1101                	addi	sp,sp,-32
    8000320c:	ec06                	sd	ra,24(sp)
    8000320e:	e822                	sd	s0,16(sp)
    80003210:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003212:	fe840593          	addi	a1,s0,-24
    80003216:	4501                	li	a0,0
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	ed0080e7          	jalr	-304(ra) # 800030e8 <argaddr>
  return wait(p);
    80003220:	fe843503          	ld	a0,-24(s0)
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	446080e7          	jalr	1094(ra) # 8000266a <wait>
}
    8000322c:	60e2                	ld	ra,24(sp)
    8000322e:	6442                	ld	s0,16(sp)
    80003230:	6105                	addi	sp,sp,32
    80003232:	8082                	ret

0000000080003234 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003234:	7179                	addi	sp,sp,-48
    80003236:	f406                	sd	ra,40(sp)
    80003238:	f022                	sd	s0,32(sp)
    8000323a:	ec26                	sd	s1,24(sp)
    8000323c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000323e:	fdc40593          	addi	a1,s0,-36
    80003242:	4501                	li	a0,0
    80003244:	00000097          	auipc	ra,0x0
    80003248:	e84080e7          	jalr	-380(ra) # 800030c8 <argint>
  addr = myproc()->sz;
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	a7a080e7          	jalr	-1414(ra) # 80001cc6 <myproc>
    80003254:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    80003256:	fdc42503          	lw	a0,-36(s0)
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	dda080e7          	jalr	-550(ra) # 80002034 <growproc>
    80003262:	00054863          	bltz	a0,80003272 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003266:	8526                	mv	a0,s1
    80003268:	70a2                	ld	ra,40(sp)
    8000326a:	7402                	ld	s0,32(sp)
    8000326c:	64e2                	ld	s1,24(sp)
    8000326e:	6145                	addi	sp,sp,48
    80003270:	8082                	ret
    return -1;
    80003272:	54fd                	li	s1,-1
    80003274:	bfcd                	j	80003266 <sys_sbrk+0x32>

0000000080003276 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003276:	7139                	addi	sp,sp,-64
    80003278:	fc06                	sd	ra,56(sp)
    8000327a:	f822                	sd	s0,48(sp)
    8000327c:	f04a                	sd	s2,32(sp)
    8000327e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003280:	fcc40593          	addi	a1,s0,-52
    80003284:	4501                	li	a0,0
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	e42080e7          	jalr	-446(ra) # 800030c8 <argint>
  acquire(&tickslock);
    8000328e:	00034517          	auipc	a0,0x34
    80003292:	afa50513          	addi	a0,a0,-1286 # 80036d88 <tickslock>
    80003296:	ffffe097          	auipc	ra,0xffffe
    8000329a:	ac0080e7          	jalr	-1344(ra) # 80000d56 <acquire>
  ticks0 = ticks;
    8000329e:	00005917          	auipc	s2,0x5
    800032a2:	63292903          	lw	s2,1586(s2) # 800088d0 <ticks>
  while (ticks - ticks0 < n)
    800032a6:	fcc42783          	lw	a5,-52(s0)
    800032aa:	c3b9                	beqz	a5,800032f0 <sys_sleep+0x7a>
    800032ac:	f426                	sd	s1,40(sp)
    800032ae:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800032b0:	00034997          	auipc	s3,0x34
    800032b4:	ad898993          	addi	s3,s3,-1320 # 80036d88 <tickslock>
    800032b8:	00005497          	auipc	s1,0x5
    800032bc:	61848493          	addi	s1,s1,1560 # 800088d0 <ticks>
    if (killed(myproc()))
    800032c0:	fffff097          	auipc	ra,0xfffff
    800032c4:	a06080e7          	jalr	-1530(ra) # 80001cc6 <myproc>
    800032c8:	fffff097          	auipc	ra,0xfffff
    800032cc:	370080e7          	jalr	880(ra) # 80002638 <killed>
    800032d0:	ed15                	bnez	a0,8000330c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800032d2:	85ce                	mv	a1,s3
    800032d4:	8526                	mv	a0,s1
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	0ae080e7          	jalr	174(ra) # 80002384 <sleep>
  while (ticks - ticks0 < n)
    800032de:	409c                	lw	a5,0(s1)
    800032e0:	412787bb          	subw	a5,a5,s2
    800032e4:	fcc42703          	lw	a4,-52(s0)
    800032e8:	fce7ece3          	bltu	a5,a4,800032c0 <sys_sleep+0x4a>
    800032ec:	74a2                	ld	s1,40(sp)
    800032ee:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800032f0:	00034517          	auipc	a0,0x34
    800032f4:	a9850513          	addi	a0,a0,-1384 # 80036d88 <tickslock>
    800032f8:	ffffe097          	auipc	ra,0xffffe
    800032fc:	b12080e7          	jalr	-1262(ra) # 80000e0a <release>
  return 0;
    80003300:	4501                	li	a0,0
}
    80003302:	70e2                	ld	ra,56(sp)
    80003304:	7442                	ld	s0,48(sp)
    80003306:	7902                	ld	s2,32(sp)
    80003308:	6121                	addi	sp,sp,64
    8000330a:	8082                	ret
      release(&tickslock);
    8000330c:	00034517          	auipc	a0,0x34
    80003310:	a7c50513          	addi	a0,a0,-1412 # 80036d88 <tickslock>
    80003314:	ffffe097          	auipc	ra,0xffffe
    80003318:	af6080e7          	jalr	-1290(ra) # 80000e0a <release>
      return -1;
    8000331c:	557d                	li	a0,-1
    8000331e:	74a2                	ld	s1,40(sp)
    80003320:	69e2                	ld	s3,24(sp)
    80003322:	b7c5                	j	80003302 <sys_sleep+0x8c>

0000000080003324 <sys_kill>:

uint64
sys_kill(void)
{
    80003324:	1101                	addi	sp,sp,-32
    80003326:	ec06                	sd	ra,24(sp)
    80003328:	e822                	sd	s0,16(sp)
    8000332a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000332c:	fec40593          	addi	a1,s0,-20
    80003330:	4501                	li	a0,0
    80003332:	00000097          	auipc	ra,0x0
    80003336:	d96080e7          	jalr	-618(ra) # 800030c8 <argint>
  return kill(pid);
    8000333a:	fec42503          	lw	a0,-20(s0)
    8000333e:	fffff097          	auipc	ra,0xfffff
    80003342:	25c080e7          	jalr	604(ra) # 8000259a <kill>
}
    80003346:	60e2                	ld	ra,24(sp)
    80003348:	6442                	ld	s0,16(sp)
    8000334a:	6105                	addi	sp,sp,32
    8000334c:	8082                	ret

000000008000334e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000334e:	1101                	addi	sp,sp,-32
    80003350:	ec06                	sd	ra,24(sp)
    80003352:	e822                	sd	s0,16(sp)
    80003354:	e426                	sd	s1,8(sp)
    80003356:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003358:	00034517          	auipc	a0,0x34
    8000335c:	a3050513          	addi	a0,a0,-1488 # 80036d88 <tickslock>
    80003360:	ffffe097          	auipc	ra,0xffffe
    80003364:	9f6080e7          	jalr	-1546(ra) # 80000d56 <acquire>
  xticks = ticks;
    80003368:	00005497          	auipc	s1,0x5
    8000336c:	5684a483          	lw	s1,1384(s1) # 800088d0 <ticks>
  release(&tickslock);
    80003370:	00034517          	auipc	a0,0x34
    80003374:	a1850513          	addi	a0,a0,-1512 # 80036d88 <tickslock>
    80003378:	ffffe097          	auipc	ra,0xffffe
    8000337c:	a92080e7          	jalr	-1390(ra) # 80000e0a <release>
  return xticks;
}
    80003380:	02049513          	slli	a0,s1,0x20
    80003384:	9101                	srli	a0,a0,0x20
    80003386:	60e2                	ld	ra,24(sp)
    80003388:	6442                	ld	s0,16(sp)
    8000338a:	64a2                	ld	s1,8(sp)
    8000338c:	6105                	addi	sp,sp,32
    8000338e:	8082                	ret

0000000080003390 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003390:	7139                	addi	sp,sp,-64
    80003392:	fc06                	sd	ra,56(sp)
    80003394:	f822                	sd	s0,48(sp)
    80003396:	f426                	sd	s1,40(sp)
    80003398:	f04a                	sd	s2,32(sp)
    8000339a:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000339c:	fd840593          	addi	a1,s0,-40
    800033a0:	4501                	li	a0,0
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	d46080e7          	jalr	-698(ra) # 800030e8 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    800033aa:	fd040593          	addi	a1,s0,-48
    800033ae:	4505                	li	a0,1
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	d38080e7          	jalr	-712(ra) # 800030e8 <argaddr>
  argaddr(2, &addr2);
    800033b8:	fc840593          	addi	a1,s0,-56
    800033bc:	4509                	li	a0,2
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	d2a080e7          	jalr	-726(ra) # 800030e8 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    800033c6:	fc040613          	addi	a2,s0,-64
    800033ca:	fc440593          	addi	a1,s0,-60
    800033ce:	fd843503          	ld	a0,-40(s0)
    800033d2:	fffff097          	auipc	ra,0xfffff
    800033d6:	522080e7          	jalr	1314(ra) # 800028f4 <waitx>
    800033da:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	8ea080e7          	jalr	-1814(ra) # 80001cc6 <myproc>
    800033e4:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800033e6:	4691                	li	a3,4
    800033e8:	fc440613          	addi	a2,s0,-60
    800033ec:	fd043583          	ld	a1,-48(s0)
    800033f0:	6928                	ld	a0,80(a0)
    800033f2:	ffffe097          	auipc	ra,0xffffe
    800033f6:	450080e7          	jalr	1104(ra) # 80001842 <copyout>
    return -1;
    800033fa:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800033fc:	00054f63          	bltz	a0,8000341a <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003400:	4691                	li	a3,4
    80003402:	fc040613          	addi	a2,s0,-64
    80003406:	fc843583          	ld	a1,-56(s0)
    8000340a:	68a8                	ld	a0,80(s1)
    8000340c:	ffffe097          	auipc	ra,0xffffe
    80003410:	436080e7          	jalr	1078(ra) # 80001842 <copyout>
    80003414:	00054a63          	bltz	a0,80003428 <sys_waitx+0x98>
    return -1;
  return ret;
    80003418:	87ca                	mv	a5,s2
    8000341a:	853e                	mv	a0,a5
    8000341c:	70e2                	ld	ra,56(sp)
    8000341e:	7442                	ld	s0,48(sp)
    80003420:	74a2                	ld	s1,40(sp)
    80003422:	7902                	ld	s2,32(sp)
    80003424:	6121                	addi	sp,sp,64
    80003426:	8082                	ret
    return -1;
    80003428:	57fd                	li	a5,-1
    8000342a:	bfc5                	j	8000341a <sys_waitx+0x8a>

000000008000342c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000342c:	7179                	addi	sp,sp,-48
    8000342e:	f406                	sd	ra,40(sp)
    80003430:	f022                	sd	s0,32(sp)
    80003432:	ec26                	sd	s1,24(sp)
    80003434:	e84a                	sd	s2,16(sp)
    80003436:	e44e                	sd	s3,8(sp)
    80003438:	e052                	sd	s4,0(sp)
    8000343a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000343c:	00005597          	auipc	a1,0x5
    80003440:	fb458593          	addi	a1,a1,-76 # 800083f0 <etext+0x3f0>
    80003444:	00034517          	auipc	a0,0x34
    80003448:	95c50513          	addi	a0,a0,-1700 # 80036da0 <bcache>
    8000344c:	ffffe097          	auipc	ra,0xffffe
    80003450:	87a080e7          	jalr	-1926(ra) # 80000cc6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003454:	0003c797          	auipc	a5,0x3c
    80003458:	94c78793          	addi	a5,a5,-1716 # 8003eda0 <bcache+0x8000>
    8000345c:	0003c717          	auipc	a4,0x3c
    80003460:	bac70713          	addi	a4,a4,-1108 # 8003f008 <bcache+0x8268>
    80003464:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003468:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000346c:	00034497          	auipc	s1,0x34
    80003470:	94c48493          	addi	s1,s1,-1716 # 80036db8 <bcache+0x18>
    b->next = bcache.head.next;
    80003474:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003476:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003478:	00005a17          	auipc	s4,0x5
    8000347c:	f80a0a13          	addi	s4,s4,-128 # 800083f8 <etext+0x3f8>
    b->next = bcache.head.next;
    80003480:	2b893783          	ld	a5,696(s2)
    80003484:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003486:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000348a:	85d2                	mv	a1,s4
    8000348c:	01048513          	addi	a0,s1,16
    80003490:	00001097          	auipc	ra,0x1
    80003494:	4e8080e7          	jalr	1256(ra) # 80004978 <initsleeplock>
    bcache.head.next->prev = b;
    80003498:	2b893783          	ld	a5,696(s2)
    8000349c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000349e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034a2:	45848493          	addi	s1,s1,1112
    800034a6:	fd349de3          	bne	s1,s3,80003480 <binit+0x54>
  }
}
    800034aa:	70a2                	ld	ra,40(sp)
    800034ac:	7402                	ld	s0,32(sp)
    800034ae:	64e2                	ld	s1,24(sp)
    800034b0:	6942                	ld	s2,16(sp)
    800034b2:	69a2                	ld	s3,8(sp)
    800034b4:	6a02                	ld	s4,0(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret

00000000800034ba <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034ba:	7179                	addi	sp,sp,-48
    800034bc:	f406                	sd	ra,40(sp)
    800034be:	f022                	sd	s0,32(sp)
    800034c0:	ec26                	sd	s1,24(sp)
    800034c2:	e84a                	sd	s2,16(sp)
    800034c4:	e44e                	sd	s3,8(sp)
    800034c6:	1800                	addi	s0,sp,48
    800034c8:	892a                	mv	s2,a0
    800034ca:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034cc:	00034517          	auipc	a0,0x34
    800034d0:	8d450513          	addi	a0,a0,-1836 # 80036da0 <bcache>
    800034d4:	ffffe097          	auipc	ra,0xffffe
    800034d8:	882080e7          	jalr	-1918(ra) # 80000d56 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034dc:	0003c497          	auipc	s1,0x3c
    800034e0:	b7c4b483          	ld	s1,-1156(s1) # 8003f058 <bcache+0x82b8>
    800034e4:	0003c797          	auipc	a5,0x3c
    800034e8:	b2478793          	addi	a5,a5,-1244 # 8003f008 <bcache+0x8268>
    800034ec:	02f48f63          	beq	s1,a5,8000352a <bread+0x70>
    800034f0:	873e                	mv	a4,a5
    800034f2:	a021                	j	800034fa <bread+0x40>
    800034f4:	68a4                	ld	s1,80(s1)
    800034f6:	02e48a63          	beq	s1,a4,8000352a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800034fa:	449c                	lw	a5,8(s1)
    800034fc:	ff279ce3          	bne	a5,s2,800034f4 <bread+0x3a>
    80003500:	44dc                	lw	a5,12(s1)
    80003502:	ff3799e3          	bne	a5,s3,800034f4 <bread+0x3a>
      b->refcnt++;
    80003506:	40bc                	lw	a5,64(s1)
    80003508:	2785                	addiw	a5,a5,1
    8000350a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000350c:	00034517          	auipc	a0,0x34
    80003510:	89450513          	addi	a0,a0,-1900 # 80036da0 <bcache>
    80003514:	ffffe097          	auipc	ra,0xffffe
    80003518:	8f6080e7          	jalr	-1802(ra) # 80000e0a <release>
      acquiresleep(&b->lock);
    8000351c:	01048513          	addi	a0,s1,16
    80003520:	00001097          	auipc	ra,0x1
    80003524:	492080e7          	jalr	1170(ra) # 800049b2 <acquiresleep>
      return b;
    80003528:	a8b9                	j	80003586 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000352a:	0003c497          	auipc	s1,0x3c
    8000352e:	b264b483          	ld	s1,-1242(s1) # 8003f050 <bcache+0x82b0>
    80003532:	0003c797          	auipc	a5,0x3c
    80003536:	ad678793          	addi	a5,a5,-1322 # 8003f008 <bcache+0x8268>
    8000353a:	00f48863          	beq	s1,a5,8000354a <bread+0x90>
    8000353e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003540:	40bc                	lw	a5,64(s1)
    80003542:	cf81                	beqz	a5,8000355a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003544:	64a4                	ld	s1,72(s1)
    80003546:	fee49de3          	bne	s1,a4,80003540 <bread+0x86>
  panic("bget: no buffers");
    8000354a:	00005517          	auipc	a0,0x5
    8000354e:	eb650513          	addi	a0,a0,-330 # 80008400 <etext+0x400>
    80003552:	ffffd097          	auipc	ra,0xffffd
    80003556:	00e080e7          	jalr	14(ra) # 80000560 <panic>
      b->dev = dev;
    8000355a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000355e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003562:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003566:	4785                	li	a5,1
    80003568:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000356a:	00034517          	auipc	a0,0x34
    8000356e:	83650513          	addi	a0,a0,-1994 # 80036da0 <bcache>
    80003572:	ffffe097          	auipc	ra,0xffffe
    80003576:	898080e7          	jalr	-1896(ra) # 80000e0a <release>
      acquiresleep(&b->lock);
    8000357a:	01048513          	addi	a0,s1,16
    8000357e:	00001097          	auipc	ra,0x1
    80003582:	434080e7          	jalr	1076(ra) # 800049b2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003586:	409c                	lw	a5,0(s1)
    80003588:	cb89                	beqz	a5,8000359a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000358a:	8526                	mv	a0,s1
    8000358c:	70a2                	ld	ra,40(sp)
    8000358e:	7402                	ld	s0,32(sp)
    80003590:	64e2                	ld	s1,24(sp)
    80003592:	6942                	ld	s2,16(sp)
    80003594:	69a2                	ld	s3,8(sp)
    80003596:	6145                	addi	sp,sp,48
    80003598:	8082                	ret
    virtio_disk_rw(b, 0);
    8000359a:	4581                	li	a1,0
    8000359c:	8526                	mv	a0,s1
    8000359e:	00003097          	auipc	ra,0x3
    800035a2:	0fa080e7          	jalr	250(ra) # 80006698 <virtio_disk_rw>
    b->valid = 1;
    800035a6:	4785                	li	a5,1
    800035a8:	c09c                	sw	a5,0(s1)
  return b;
    800035aa:	b7c5                	j	8000358a <bread+0xd0>

00000000800035ac <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035ac:	1101                	addi	sp,sp,-32
    800035ae:	ec06                	sd	ra,24(sp)
    800035b0:	e822                	sd	s0,16(sp)
    800035b2:	e426                	sd	s1,8(sp)
    800035b4:	1000                	addi	s0,sp,32
    800035b6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035b8:	0541                	addi	a0,a0,16
    800035ba:	00001097          	auipc	ra,0x1
    800035be:	492080e7          	jalr	1170(ra) # 80004a4c <holdingsleep>
    800035c2:	cd01                	beqz	a0,800035da <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035c4:	4585                	li	a1,1
    800035c6:	8526                	mv	a0,s1
    800035c8:	00003097          	auipc	ra,0x3
    800035cc:	0d0080e7          	jalr	208(ra) # 80006698 <virtio_disk_rw>
}
    800035d0:	60e2                	ld	ra,24(sp)
    800035d2:	6442                	ld	s0,16(sp)
    800035d4:	64a2                	ld	s1,8(sp)
    800035d6:	6105                	addi	sp,sp,32
    800035d8:	8082                	ret
    panic("bwrite");
    800035da:	00005517          	auipc	a0,0x5
    800035de:	e3e50513          	addi	a0,a0,-450 # 80008418 <etext+0x418>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	f7e080e7          	jalr	-130(ra) # 80000560 <panic>

00000000800035ea <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035ea:	1101                	addi	sp,sp,-32
    800035ec:	ec06                	sd	ra,24(sp)
    800035ee:	e822                	sd	s0,16(sp)
    800035f0:	e426                	sd	s1,8(sp)
    800035f2:	e04a                	sd	s2,0(sp)
    800035f4:	1000                	addi	s0,sp,32
    800035f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035f8:	01050913          	addi	s2,a0,16
    800035fc:	854a                	mv	a0,s2
    800035fe:	00001097          	auipc	ra,0x1
    80003602:	44e080e7          	jalr	1102(ra) # 80004a4c <holdingsleep>
    80003606:	c925                	beqz	a0,80003676 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003608:	854a                	mv	a0,s2
    8000360a:	00001097          	auipc	ra,0x1
    8000360e:	3fe080e7          	jalr	1022(ra) # 80004a08 <releasesleep>

  acquire(&bcache.lock);
    80003612:	00033517          	auipc	a0,0x33
    80003616:	78e50513          	addi	a0,a0,1934 # 80036da0 <bcache>
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	73c080e7          	jalr	1852(ra) # 80000d56 <acquire>
  b->refcnt--;
    80003622:	40bc                	lw	a5,64(s1)
    80003624:	37fd                	addiw	a5,a5,-1
    80003626:	0007871b          	sext.w	a4,a5
    8000362a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000362c:	e71d                	bnez	a4,8000365a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000362e:	68b8                	ld	a4,80(s1)
    80003630:	64bc                	ld	a5,72(s1)
    80003632:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003634:	68b8                	ld	a4,80(s1)
    80003636:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003638:	0003b797          	auipc	a5,0x3b
    8000363c:	76878793          	addi	a5,a5,1896 # 8003eda0 <bcache+0x8000>
    80003640:	2b87b703          	ld	a4,696(a5)
    80003644:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003646:	0003c717          	auipc	a4,0x3c
    8000364a:	9c270713          	addi	a4,a4,-1598 # 8003f008 <bcache+0x8268>
    8000364e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003650:	2b87b703          	ld	a4,696(a5)
    80003654:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003656:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000365a:	00033517          	auipc	a0,0x33
    8000365e:	74650513          	addi	a0,a0,1862 # 80036da0 <bcache>
    80003662:	ffffd097          	auipc	ra,0xffffd
    80003666:	7a8080e7          	jalr	1960(ra) # 80000e0a <release>
}
    8000366a:	60e2                	ld	ra,24(sp)
    8000366c:	6442                	ld	s0,16(sp)
    8000366e:	64a2                	ld	s1,8(sp)
    80003670:	6902                	ld	s2,0(sp)
    80003672:	6105                	addi	sp,sp,32
    80003674:	8082                	ret
    panic("brelse");
    80003676:	00005517          	auipc	a0,0x5
    8000367a:	daa50513          	addi	a0,a0,-598 # 80008420 <etext+0x420>
    8000367e:	ffffd097          	auipc	ra,0xffffd
    80003682:	ee2080e7          	jalr	-286(ra) # 80000560 <panic>

0000000080003686 <bpin>:

void
bpin(struct buf *b) {
    80003686:	1101                	addi	sp,sp,-32
    80003688:	ec06                	sd	ra,24(sp)
    8000368a:	e822                	sd	s0,16(sp)
    8000368c:	e426                	sd	s1,8(sp)
    8000368e:	1000                	addi	s0,sp,32
    80003690:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003692:	00033517          	auipc	a0,0x33
    80003696:	70e50513          	addi	a0,a0,1806 # 80036da0 <bcache>
    8000369a:	ffffd097          	auipc	ra,0xffffd
    8000369e:	6bc080e7          	jalr	1724(ra) # 80000d56 <acquire>
  b->refcnt++;
    800036a2:	40bc                	lw	a5,64(s1)
    800036a4:	2785                	addiw	a5,a5,1
    800036a6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036a8:	00033517          	auipc	a0,0x33
    800036ac:	6f850513          	addi	a0,a0,1784 # 80036da0 <bcache>
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	75a080e7          	jalr	1882(ra) # 80000e0a <release>
}
    800036b8:	60e2                	ld	ra,24(sp)
    800036ba:	6442                	ld	s0,16(sp)
    800036bc:	64a2                	ld	s1,8(sp)
    800036be:	6105                	addi	sp,sp,32
    800036c0:	8082                	ret

00000000800036c2 <bunpin>:

void
bunpin(struct buf *b) {
    800036c2:	1101                	addi	sp,sp,-32
    800036c4:	ec06                	sd	ra,24(sp)
    800036c6:	e822                	sd	s0,16(sp)
    800036c8:	e426                	sd	s1,8(sp)
    800036ca:	1000                	addi	s0,sp,32
    800036cc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036ce:	00033517          	auipc	a0,0x33
    800036d2:	6d250513          	addi	a0,a0,1746 # 80036da0 <bcache>
    800036d6:	ffffd097          	auipc	ra,0xffffd
    800036da:	680080e7          	jalr	1664(ra) # 80000d56 <acquire>
  b->refcnt--;
    800036de:	40bc                	lw	a5,64(s1)
    800036e0:	37fd                	addiw	a5,a5,-1
    800036e2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036e4:	00033517          	auipc	a0,0x33
    800036e8:	6bc50513          	addi	a0,a0,1724 # 80036da0 <bcache>
    800036ec:	ffffd097          	auipc	ra,0xffffd
    800036f0:	71e080e7          	jalr	1822(ra) # 80000e0a <release>
}
    800036f4:	60e2                	ld	ra,24(sp)
    800036f6:	6442                	ld	s0,16(sp)
    800036f8:	64a2                	ld	s1,8(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036fe:	1101                	addi	sp,sp,-32
    80003700:	ec06                	sd	ra,24(sp)
    80003702:	e822                	sd	s0,16(sp)
    80003704:	e426                	sd	s1,8(sp)
    80003706:	e04a                	sd	s2,0(sp)
    80003708:	1000                	addi	s0,sp,32
    8000370a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000370c:	00d5d59b          	srliw	a1,a1,0xd
    80003710:	0003c797          	auipc	a5,0x3c
    80003714:	d6c7a783          	lw	a5,-660(a5) # 8003f47c <sb+0x1c>
    80003718:	9dbd                	addw	a1,a1,a5
    8000371a:	00000097          	auipc	ra,0x0
    8000371e:	da0080e7          	jalr	-608(ra) # 800034ba <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003722:	0074f713          	andi	a4,s1,7
    80003726:	4785                	li	a5,1
    80003728:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000372c:	14ce                	slli	s1,s1,0x33
    8000372e:	90d9                	srli	s1,s1,0x36
    80003730:	00950733          	add	a4,a0,s1
    80003734:	05874703          	lbu	a4,88(a4)
    80003738:	00e7f6b3          	and	a3,a5,a4
    8000373c:	c69d                	beqz	a3,8000376a <bfree+0x6c>
    8000373e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003740:	94aa                	add	s1,s1,a0
    80003742:	fff7c793          	not	a5,a5
    80003746:	8f7d                	and	a4,a4,a5
    80003748:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000374c:	00001097          	auipc	ra,0x1
    80003750:	148080e7          	jalr	328(ra) # 80004894 <log_write>
  brelse(bp);
    80003754:	854a                	mv	a0,s2
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	e94080e7          	jalr	-364(ra) # 800035ea <brelse>
}
    8000375e:	60e2                	ld	ra,24(sp)
    80003760:	6442                	ld	s0,16(sp)
    80003762:	64a2                	ld	s1,8(sp)
    80003764:	6902                	ld	s2,0(sp)
    80003766:	6105                	addi	sp,sp,32
    80003768:	8082                	ret
    panic("freeing free block");
    8000376a:	00005517          	auipc	a0,0x5
    8000376e:	cbe50513          	addi	a0,a0,-834 # 80008428 <etext+0x428>
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	dee080e7          	jalr	-530(ra) # 80000560 <panic>

000000008000377a <balloc>:
{
    8000377a:	711d                	addi	sp,sp,-96
    8000377c:	ec86                	sd	ra,88(sp)
    8000377e:	e8a2                	sd	s0,80(sp)
    80003780:	e4a6                	sd	s1,72(sp)
    80003782:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003784:	0003c797          	auipc	a5,0x3c
    80003788:	ce07a783          	lw	a5,-800(a5) # 8003f464 <sb+0x4>
    8000378c:	10078f63          	beqz	a5,800038aa <balloc+0x130>
    80003790:	e0ca                	sd	s2,64(sp)
    80003792:	fc4e                	sd	s3,56(sp)
    80003794:	f852                	sd	s4,48(sp)
    80003796:	f456                	sd	s5,40(sp)
    80003798:	f05a                	sd	s6,32(sp)
    8000379a:	ec5e                	sd	s7,24(sp)
    8000379c:	e862                	sd	s8,16(sp)
    8000379e:	e466                	sd	s9,8(sp)
    800037a0:	8baa                	mv	s7,a0
    800037a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800037a4:	0003cb17          	auipc	s6,0x3c
    800037a8:	cbcb0b13          	addi	s6,s6,-836 # 8003f460 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800037ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037b2:	6c89                	lui	s9,0x2
    800037b4:	a061                	j	8000383c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037b6:	97ca                	add	a5,a5,s2
    800037b8:	8e55                	or	a2,a2,a3
    800037ba:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800037be:	854a                	mv	a0,s2
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	0d4080e7          	jalr	212(ra) # 80004894 <log_write>
        brelse(bp);
    800037c8:	854a                	mv	a0,s2
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	e20080e7          	jalr	-480(ra) # 800035ea <brelse>
  bp = bread(dev, bno);
    800037d2:	85a6                	mv	a1,s1
    800037d4:	855e                	mv	a0,s7
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	ce4080e7          	jalr	-796(ra) # 800034ba <bread>
    800037de:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037e0:	40000613          	li	a2,1024
    800037e4:	4581                	li	a1,0
    800037e6:	05850513          	addi	a0,a0,88
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	668080e7          	jalr	1640(ra) # 80000e52 <memset>
  log_write(bp);
    800037f2:	854a                	mv	a0,s2
    800037f4:	00001097          	auipc	ra,0x1
    800037f8:	0a0080e7          	jalr	160(ra) # 80004894 <log_write>
  brelse(bp);
    800037fc:	854a                	mv	a0,s2
    800037fe:	00000097          	auipc	ra,0x0
    80003802:	dec080e7          	jalr	-532(ra) # 800035ea <brelse>
}
    80003806:	6906                	ld	s2,64(sp)
    80003808:	79e2                	ld	s3,56(sp)
    8000380a:	7a42                	ld	s4,48(sp)
    8000380c:	7aa2                	ld	s5,40(sp)
    8000380e:	7b02                	ld	s6,32(sp)
    80003810:	6be2                	ld	s7,24(sp)
    80003812:	6c42                	ld	s8,16(sp)
    80003814:	6ca2                	ld	s9,8(sp)
}
    80003816:	8526                	mv	a0,s1
    80003818:	60e6                	ld	ra,88(sp)
    8000381a:	6446                	ld	s0,80(sp)
    8000381c:	64a6                	ld	s1,72(sp)
    8000381e:	6125                	addi	sp,sp,96
    80003820:	8082                	ret
    brelse(bp);
    80003822:	854a                	mv	a0,s2
    80003824:	00000097          	auipc	ra,0x0
    80003828:	dc6080e7          	jalr	-570(ra) # 800035ea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000382c:	015c87bb          	addw	a5,s9,s5
    80003830:	00078a9b          	sext.w	s5,a5
    80003834:	004b2703          	lw	a4,4(s6)
    80003838:	06eaf163          	bgeu	s5,a4,8000389a <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    8000383c:	41fad79b          	sraiw	a5,s5,0x1f
    80003840:	0137d79b          	srliw	a5,a5,0x13
    80003844:	015787bb          	addw	a5,a5,s5
    80003848:	40d7d79b          	sraiw	a5,a5,0xd
    8000384c:	01cb2583          	lw	a1,28(s6)
    80003850:	9dbd                	addw	a1,a1,a5
    80003852:	855e                	mv	a0,s7
    80003854:	00000097          	auipc	ra,0x0
    80003858:	c66080e7          	jalr	-922(ra) # 800034ba <bread>
    8000385c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000385e:	004b2503          	lw	a0,4(s6)
    80003862:	000a849b          	sext.w	s1,s5
    80003866:	8762                	mv	a4,s8
    80003868:	faa4fde3          	bgeu	s1,a0,80003822 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000386c:	00777693          	andi	a3,a4,7
    80003870:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003874:	41f7579b          	sraiw	a5,a4,0x1f
    80003878:	01d7d79b          	srliw	a5,a5,0x1d
    8000387c:	9fb9                	addw	a5,a5,a4
    8000387e:	4037d79b          	sraiw	a5,a5,0x3
    80003882:	00f90633          	add	a2,s2,a5
    80003886:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000388a:	00c6f5b3          	and	a1,a3,a2
    8000388e:	d585                	beqz	a1,800037b6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003890:	2705                	addiw	a4,a4,1
    80003892:	2485                	addiw	s1,s1,1
    80003894:	fd471ae3          	bne	a4,s4,80003868 <balloc+0xee>
    80003898:	b769                	j	80003822 <balloc+0xa8>
    8000389a:	6906                	ld	s2,64(sp)
    8000389c:	79e2                	ld	s3,56(sp)
    8000389e:	7a42                	ld	s4,48(sp)
    800038a0:	7aa2                	ld	s5,40(sp)
    800038a2:	7b02                	ld	s6,32(sp)
    800038a4:	6be2                	ld	s7,24(sp)
    800038a6:	6c42                	ld	s8,16(sp)
    800038a8:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800038aa:	00005517          	auipc	a0,0x5
    800038ae:	b9650513          	addi	a0,a0,-1130 # 80008440 <etext+0x440>
    800038b2:	ffffd097          	auipc	ra,0xffffd
    800038b6:	cf8080e7          	jalr	-776(ra) # 800005aa <printf>
  return 0;
    800038ba:	4481                	li	s1,0
    800038bc:	bfa9                	j	80003816 <balloc+0x9c>

00000000800038be <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800038be:	7179                	addi	sp,sp,-48
    800038c0:	f406                	sd	ra,40(sp)
    800038c2:	f022                	sd	s0,32(sp)
    800038c4:	ec26                	sd	s1,24(sp)
    800038c6:	e84a                	sd	s2,16(sp)
    800038c8:	e44e                	sd	s3,8(sp)
    800038ca:	1800                	addi	s0,sp,48
    800038cc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038ce:	47ad                	li	a5,11
    800038d0:	02b7e863          	bltu	a5,a1,80003900 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800038d4:	02059793          	slli	a5,a1,0x20
    800038d8:	01e7d593          	srli	a1,a5,0x1e
    800038dc:	00b504b3          	add	s1,a0,a1
    800038e0:	0504a903          	lw	s2,80(s1)
    800038e4:	08091263          	bnez	s2,80003968 <bmap+0xaa>
      addr = balloc(ip->dev);
    800038e8:	4108                	lw	a0,0(a0)
    800038ea:	00000097          	auipc	ra,0x0
    800038ee:	e90080e7          	jalr	-368(ra) # 8000377a <balloc>
    800038f2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800038f6:	06090963          	beqz	s2,80003968 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    800038fa:	0524a823          	sw	s2,80(s1)
    800038fe:	a0ad                	j	80003968 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003900:	ff45849b          	addiw	s1,a1,-12
    80003904:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003908:	0ff00793          	li	a5,255
    8000390c:	08e7e863          	bltu	a5,a4,8000399c <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003910:	08052903          	lw	s2,128(a0)
    80003914:	00091f63          	bnez	s2,80003932 <bmap+0x74>
      addr = balloc(ip->dev);
    80003918:	4108                	lw	a0,0(a0)
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	e60080e7          	jalr	-416(ra) # 8000377a <balloc>
    80003922:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003926:	04090163          	beqz	s2,80003968 <bmap+0xaa>
    8000392a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000392c:	0929a023          	sw	s2,128(s3)
    80003930:	a011                	j	80003934 <bmap+0x76>
    80003932:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003934:	85ca                	mv	a1,s2
    80003936:	0009a503          	lw	a0,0(s3)
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	b80080e7          	jalr	-1152(ra) # 800034ba <bread>
    80003942:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003944:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003948:	02049713          	slli	a4,s1,0x20
    8000394c:	01e75593          	srli	a1,a4,0x1e
    80003950:	00b784b3          	add	s1,a5,a1
    80003954:	0004a903          	lw	s2,0(s1)
    80003958:	02090063          	beqz	s2,80003978 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000395c:	8552                	mv	a0,s4
    8000395e:	00000097          	auipc	ra,0x0
    80003962:	c8c080e7          	jalr	-884(ra) # 800035ea <brelse>
    return addr;
    80003966:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003968:	854a                	mv	a0,s2
    8000396a:	70a2                	ld	ra,40(sp)
    8000396c:	7402                	ld	s0,32(sp)
    8000396e:	64e2                	ld	s1,24(sp)
    80003970:	6942                	ld	s2,16(sp)
    80003972:	69a2                	ld	s3,8(sp)
    80003974:	6145                	addi	sp,sp,48
    80003976:	8082                	ret
      addr = balloc(ip->dev);
    80003978:	0009a503          	lw	a0,0(s3)
    8000397c:	00000097          	auipc	ra,0x0
    80003980:	dfe080e7          	jalr	-514(ra) # 8000377a <balloc>
    80003984:	0005091b          	sext.w	s2,a0
      if(addr){
    80003988:	fc090ae3          	beqz	s2,8000395c <bmap+0x9e>
        a[bn] = addr;
    8000398c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003990:	8552                	mv	a0,s4
    80003992:	00001097          	auipc	ra,0x1
    80003996:	f02080e7          	jalr	-254(ra) # 80004894 <log_write>
    8000399a:	b7c9                	j	8000395c <bmap+0x9e>
    8000399c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000399e:	00005517          	auipc	a0,0x5
    800039a2:	aba50513          	addi	a0,a0,-1350 # 80008458 <etext+0x458>
    800039a6:	ffffd097          	auipc	ra,0xffffd
    800039aa:	bba080e7          	jalr	-1094(ra) # 80000560 <panic>

00000000800039ae <iget>:
{
    800039ae:	7179                	addi	sp,sp,-48
    800039b0:	f406                	sd	ra,40(sp)
    800039b2:	f022                	sd	s0,32(sp)
    800039b4:	ec26                	sd	s1,24(sp)
    800039b6:	e84a                	sd	s2,16(sp)
    800039b8:	e44e                	sd	s3,8(sp)
    800039ba:	e052                	sd	s4,0(sp)
    800039bc:	1800                	addi	s0,sp,48
    800039be:	89aa                	mv	s3,a0
    800039c0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800039c2:	0003c517          	auipc	a0,0x3c
    800039c6:	abe50513          	addi	a0,a0,-1346 # 8003f480 <itable>
    800039ca:	ffffd097          	auipc	ra,0xffffd
    800039ce:	38c080e7          	jalr	908(ra) # 80000d56 <acquire>
  empty = 0;
    800039d2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039d4:	0003c497          	auipc	s1,0x3c
    800039d8:	ac448493          	addi	s1,s1,-1340 # 8003f498 <itable+0x18>
    800039dc:	0003d697          	auipc	a3,0x3d
    800039e0:	54c68693          	addi	a3,a3,1356 # 80040f28 <log>
    800039e4:	a039                	j	800039f2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039e6:	02090b63          	beqz	s2,80003a1c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039ea:	08848493          	addi	s1,s1,136
    800039ee:	02d48a63          	beq	s1,a3,80003a22 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039f2:	449c                	lw	a5,8(s1)
    800039f4:	fef059e3          	blez	a5,800039e6 <iget+0x38>
    800039f8:	4098                	lw	a4,0(s1)
    800039fa:	ff3716e3          	bne	a4,s3,800039e6 <iget+0x38>
    800039fe:	40d8                	lw	a4,4(s1)
    80003a00:	ff4713e3          	bne	a4,s4,800039e6 <iget+0x38>
      ip->ref++;
    80003a04:	2785                	addiw	a5,a5,1
    80003a06:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003a08:	0003c517          	auipc	a0,0x3c
    80003a0c:	a7850513          	addi	a0,a0,-1416 # 8003f480 <itable>
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	3fa080e7          	jalr	1018(ra) # 80000e0a <release>
      return ip;
    80003a18:	8926                	mv	s2,s1
    80003a1a:	a03d                	j	80003a48 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a1c:	f7f9                	bnez	a5,800039ea <iget+0x3c>
      empty = ip;
    80003a1e:	8926                	mv	s2,s1
    80003a20:	b7e9                	j	800039ea <iget+0x3c>
  if(empty == 0)
    80003a22:	02090c63          	beqz	s2,80003a5a <iget+0xac>
  ip->dev = dev;
    80003a26:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003a2a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003a2e:	4785                	li	a5,1
    80003a30:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003a34:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003a38:	0003c517          	auipc	a0,0x3c
    80003a3c:	a4850513          	addi	a0,a0,-1464 # 8003f480 <itable>
    80003a40:	ffffd097          	auipc	ra,0xffffd
    80003a44:	3ca080e7          	jalr	970(ra) # 80000e0a <release>
}
    80003a48:	854a                	mv	a0,s2
    80003a4a:	70a2                	ld	ra,40(sp)
    80003a4c:	7402                	ld	s0,32(sp)
    80003a4e:	64e2                	ld	s1,24(sp)
    80003a50:	6942                	ld	s2,16(sp)
    80003a52:	69a2                	ld	s3,8(sp)
    80003a54:	6a02                	ld	s4,0(sp)
    80003a56:	6145                	addi	sp,sp,48
    80003a58:	8082                	ret
    panic("iget: no inodes");
    80003a5a:	00005517          	auipc	a0,0x5
    80003a5e:	a1650513          	addi	a0,a0,-1514 # 80008470 <etext+0x470>
    80003a62:	ffffd097          	auipc	ra,0xffffd
    80003a66:	afe080e7          	jalr	-1282(ra) # 80000560 <panic>

0000000080003a6a <fsinit>:
fsinit(int dev) {
    80003a6a:	7179                	addi	sp,sp,-48
    80003a6c:	f406                	sd	ra,40(sp)
    80003a6e:	f022                	sd	s0,32(sp)
    80003a70:	ec26                	sd	s1,24(sp)
    80003a72:	e84a                	sd	s2,16(sp)
    80003a74:	e44e                	sd	s3,8(sp)
    80003a76:	1800                	addi	s0,sp,48
    80003a78:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a7a:	4585                	li	a1,1
    80003a7c:	00000097          	auipc	ra,0x0
    80003a80:	a3e080e7          	jalr	-1474(ra) # 800034ba <bread>
    80003a84:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a86:	0003c997          	auipc	s3,0x3c
    80003a8a:	9da98993          	addi	s3,s3,-1574 # 8003f460 <sb>
    80003a8e:	02000613          	li	a2,32
    80003a92:	05850593          	addi	a1,a0,88
    80003a96:	854e                	mv	a0,s3
    80003a98:	ffffd097          	auipc	ra,0xffffd
    80003a9c:	416080e7          	jalr	1046(ra) # 80000eae <memmove>
  brelse(bp);
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	b48080e7          	jalr	-1208(ra) # 800035ea <brelse>
  if(sb.magic != FSMAGIC)
    80003aaa:	0009a703          	lw	a4,0(s3)
    80003aae:	102037b7          	lui	a5,0x10203
    80003ab2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003ab6:	02f71263          	bne	a4,a5,80003ada <fsinit+0x70>
  initlog(dev, &sb);
    80003aba:	0003c597          	auipc	a1,0x3c
    80003abe:	9a658593          	addi	a1,a1,-1626 # 8003f460 <sb>
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	00001097          	auipc	ra,0x1
    80003ac8:	b60080e7          	jalr	-1184(ra) # 80004624 <initlog>
}
    80003acc:	70a2                	ld	ra,40(sp)
    80003ace:	7402                	ld	s0,32(sp)
    80003ad0:	64e2                	ld	s1,24(sp)
    80003ad2:	6942                	ld	s2,16(sp)
    80003ad4:	69a2                	ld	s3,8(sp)
    80003ad6:	6145                	addi	sp,sp,48
    80003ad8:	8082                	ret
    panic("invalid file system");
    80003ada:	00005517          	auipc	a0,0x5
    80003ade:	9a650513          	addi	a0,a0,-1626 # 80008480 <etext+0x480>
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	a7e080e7          	jalr	-1410(ra) # 80000560 <panic>

0000000080003aea <iinit>:
{
    80003aea:	7179                	addi	sp,sp,-48
    80003aec:	f406                	sd	ra,40(sp)
    80003aee:	f022                	sd	s0,32(sp)
    80003af0:	ec26                	sd	s1,24(sp)
    80003af2:	e84a                	sd	s2,16(sp)
    80003af4:	e44e                	sd	s3,8(sp)
    80003af6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003af8:	00005597          	auipc	a1,0x5
    80003afc:	9a058593          	addi	a1,a1,-1632 # 80008498 <etext+0x498>
    80003b00:	0003c517          	auipc	a0,0x3c
    80003b04:	98050513          	addi	a0,a0,-1664 # 8003f480 <itable>
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	1be080e7          	jalr	446(ra) # 80000cc6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b10:	0003c497          	auipc	s1,0x3c
    80003b14:	99848493          	addi	s1,s1,-1640 # 8003f4a8 <itable+0x28>
    80003b18:	0003d997          	auipc	s3,0x3d
    80003b1c:	42098993          	addi	s3,s3,1056 # 80040f38 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b20:	00005917          	auipc	s2,0x5
    80003b24:	98090913          	addi	s2,s2,-1664 # 800084a0 <etext+0x4a0>
    80003b28:	85ca                	mv	a1,s2
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	00001097          	auipc	ra,0x1
    80003b30:	e4c080e7          	jalr	-436(ra) # 80004978 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b34:	08848493          	addi	s1,s1,136
    80003b38:	ff3498e3          	bne	s1,s3,80003b28 <iinit+0x3e>
}
    80003b3c:	70a2                	ld	ra,40(sp)
    80003b3e:	7402                	ld	s0,32(sp)
    80003b40:	64e2                	ld	s1,24(sp)
    80003b42:	6942                	ld	s2,16(sp)
    80003b44:	69a2                	ld	s3,8(sp)
    80003b46:	6145                	addi	sp,sp,48
    80003b48:	8082                	ret

0000000080003b4a <ialloc>:
{
    80003b4a:	7139                	addi	sp,sp,-64
    80003b4c:	fc06                	sd	ra,56(sp)
    80003b4e:	f822                	sd	s0,48(sp)
    80003b50:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b52:	0003c717          	auipc	a4,0x3c
    80003b56:	91a72703          	lw	a4,-1766(a4) # 8003f46c <sb+0xc>
    80003b5a:	4785                	li	a5,1
    80003b5c:	06e7f463          	bgeu	a5,a4,80003bc4 <ialloc+0x7a>
    80003b60:	f426                	sd	s1,40(sp)
    80003b62:	f04a                	sd	s2,32(sp)
    80003b64:	ec4e                	sd	s3,24(sp)
    80003b66:	e852                	sd	s4,16(sp)
    80003b68:	e456                	sd	s5,8(sp)
    80003b6a:	e05a                	sd	s6,0(sp)
    80003b6c:	8aaa                	mv	s5,a0
    80003b6e:	8b2e                	mv	s6,a1
    80003b70:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b72:	0003ca17          	auipc	s4,0x3c
    80003b76:	8eea0a13          	addi	s4,s4,-1810 # 8003f460 <sb>
    80003b7a:	00495593          	srli	a1,s2,0x4
    80003b7e:	018a2783          	lw	a5,24(s4)
    80003b82:	9dbd                	addw	a1,a1,a5
    80003b84:	8556                	mv	a0,s5
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	934080e7          	jalr	-1740(ra) # 800034ba <bread>
    80003b8e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b90:	05850993          	addi	s3,a0,88
    80003b94:	00f97793          	andi	a5,s2,15
    80003b98:	079a                	slli	a5,a5,0x6
    80003b9a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b9c:	00099783          	lh	a5,0(s3)
    80003ba0:	cf9d                	beqz	a5,80003bde <ialloc+0x94>
    brelse(bp);
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	a48080e7          	jalr	-1464(ra) # 800035ea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003baa:	0905                	addi	s2,s2,1
    80003bac:	00ca2703          	lw	a4,12(s4)
    80003bb0:	0009079b          	sext.w	a5,s2
    80003bb4:	fce7e3e3          	bltu	a5,a4,80003b7a <ialloc+0x30>
    80003bb8:	74a2                	ld	s1,40(sp)
    80003bba:	7902                	ld	s2,32(sp)
    80003bbc:	69e2                	ld	s3,24(sp)
    80003bbe:	6a42                	ld	s4,16(sp)
    80003bc0:	6aa2                	ld	s5,8(sp)
    80003bc2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003bc4:	00005517          	auipc	a0,0x5
    80003bc8:	8e450513          	addi	a0,a0,-1820 # 800084a8 <etext+0x4a8>
    80003bcc:	ffffd097          	auipc	ra,0xffffd
    80003bd0:	9de080e7          	jalr	-1570(ra) # 800005aa <printf>
  return 0;
    80003bd4:	4501                	li	a0,0
}
    80003bd6:	70e2                	ld	ra,56(sp)
    80003bd8:	7442                	ld	s0,48(sp)
    80003bda:	6121                	addi	sp,sp,64
    80003bdc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bde:	04000613          	li	a2,64
    80003be2:	4581                	li	a1,0
    80003be4:	854e                	mv	a0,s3
    80003be6:	ffffd097          	auipc	ra,0xffffd
    80003bea:	26c080e7          	jalr	620(ra) # 80000e52 <memset>
      dip->type = type;
    80003bee:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003bf2:	8526                	mv	a0,s1
    80003bf4:	00001097          	auipc	ra,0x1
    80003bf8:	ca0080e7          	jalr	-864(ra) # 80004894 <log_write>
      brelse(bp);
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	9ec080e7          	jalr	-1556(ra) # 800035ea <brelse>
      return iget(dev, inum);
    80003c06:	0009059b          	sext.w	a1,s2
    80003c0a:	8556                	mv	a0,s5
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	da2080e7          	jalr	-606(ra) # 800039ae <iget>
    80003c14:	74a2                	ld	s1,40(sp)
    80003c16:	7902                	ld	s2,32(sp)
    80003c18:	69e2                	ld	s3,24(sp)
    80003c1a:	6a42                	ld	s4,16(sp)
    80003c1c:	6aa2                	ld	s5,8(sp)
    80003c1e:	6b02                	ld	s6,0(sp)
    80003c20:	bf5d                	j	80003bd6 <ialloc+0x8c>

0000000080003c22 <iupdate>:
{
    80003c22:	1101                	addi	sp,sp,-32
    80003c24:	ec06                	sd	ra,24(sp)
    80003c26:	e822                	sd	s0,16(sp)
    80003c28:	e426                	sd	s1,8(sp)
    80003c2a:	e04a                	sd	s2,0(sp)
    80003c2c:	1000                	addi	s0,sp,32
    80003c2e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c30:	415c                	lw	a5,4(a0)
    80003c32:	0047d79b          	srliw	a5,a5,0x4
    80003c36:	0003c597          	auipc	a1,0x3c
    80003c3a:	8425a583          	lw	a1,-1982(a1) # 8003f478 <sb+0x18>
    80003c3e:	9dbd                	addw	a1,a1,a5
    80003c40:	4108                	lw	a0,0(a0)
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	878080e7          	jalr	-1928(ra) # 800034ba <bread>
    80003c4a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c4c:	05850793          	addi	a5,a0,88
    80003c50:	40d8                	lw	a4,4(s1)
    80003c52:	8b3d                	andi	a4,a4,15
    80003c54:	071a                	slli	a4,a4,0x6
    80003c56:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c58:	04449703          	lh	a4,68(s1)
    80003c5c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c60:	04649703          	lh	a4,70(s1)
    80003c64:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c68:	04849703          	lh	a4,72(s1)
    80003c6c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c70:	04a49703          	lh	a4,74(s1)
    80003c74:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c78:	44f8                	lw	a4,76(s1)
    80003c7a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c7c:	03400613          	li	a2,52
    80003c80:	05048593          	addi	a1,s1,80
    80003c84:	00c78513          	addi	a0,a5,12
    80003c88:	ffffd097          	auipc	ra,0xffffd
    80003c8c:	226080e7          	jalr	550(ra) # 80000eae <memmove>
  log_write(bp);
    80003c90:	854a                	mv	a0,s2
    80003c92:	00001097          	auipc	ra,0x1
    80003c96:	c02080e7          	jalr	-1022(ra) # 80004894 <log_write>
  brelse(bp);
    80003c9a:	854a                	mv	a0,s2
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	94e080e7          	jalr	-1714(ra) # 800035ea <brelse>
}
    80003ca4:	60e2                	ld	ra,24(sp)
    80003ca6:	6442                	ld	s0,16(sp)
    80003ca8:	64a2                	ld	s1,8(sp)
    80003caa:	6902                	ld	s2,0(sp)
    80003cac:	6105                	addi	sp,sp,32
    80003cae:	8082                	ret

0000000080003cb0 <idup>:
{
    80003cb0:	1101                	addi	sp,sp,-32
    80003cb2:	ec06                	sd	ra,24(sp)
    80003cb4:	e822                	sd	s0,16(sp)
    80003cb6:	e426                	sd	s1,8(sp)
    80003cb8:	1000                	addi	s0,sp,32
    80003cba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cbc:	0003b517          	auipc	a0,0x3b
    80003cc0:	7c450513          	addi	a0,a0,1988 # 8003f480 <itable>
    80003cc4:	ffffd097          	auipc	ra,0xffffd
    80003cc8:	092080e7          	jalr	146(ra) # 80000d56 <acquire>
  ip->ref++;
    80003ccc:	449c                	lw	a5,8(s1)
    80003cce:	2785                	addiw	a5,a5,1
    80003cd0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cd2:	0003b517          	auipc	a0,0x3b
    80003cd6:	7ae50513          	addi	a0,a0,1966 # 8003f480 <itable>
    80003cda:	ffffd097          	auipc	ra,0xffffd
    80003cde:	130080e7          	jalr	304(ra) # 80000e0a <release>
}
    80003ce2:	8526                	mv	a0,s1
    80003ce4:	60e2                	ld	ra,24(sp)
    80003ce6:	6442                	ld	s0,16(sp)
    80003ce8:	64a2                	ld	s1,8(sp)
    80003cea:	6105                	addi	sp,sp,32
    80003cec:	8082                	ret

0000000080003cee <ilock>:
{
    80003cee:	1101                	addi	sp,sp,-32
    80003cf0:	ec06                	sd	ra,24(sp)
    80003cf2:	e822                	sd	s0,16(sp)
    80003cf4:	e426                	sd	s1,8(sp)
    80003cf6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003cf8:	c10d                	beqz	a0,80003d1a <ilock+0x2c>
    80003cfa:	84aa                	mv	s1,a0
    80003cfc:	451c                	lw	a5,8(a0)
    80003cfe:	00f05e63          	blez	a5,80003d1a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003d02:	0541                	addi	a0,a0,16
    80003d04:	00001097          	auipc	ra,0x1
    80003d08:	cae080e7          	jalr	-850(ra) # 800049b2 <acquiresleep>
  if(ip->valid == 0){
    80003d0c:	40bc                	lw	a5,64(s1)
    80003d0e:	cf99                	beqz	a5,80003d2c <ilock+0x3e>
}
    80003d10:	60e2                	ld	ra,24(sp)
    80003d12:	6442                	ld	s0,16(sp)
    80003d14:	64a2                	ld	s1,8(sp)
    80003d16:	6105                	addi	sp,sp,32
    80003d18:	8082                	ret
    80003d1a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d1c:	00004517          	auipc	a0,0x4
    80003d20:	7a450513          	addi	a0,a0,1956 # 800084c0 <etext+0x4c0>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	83c080e7          	jalr	-1988(ra) # 80000560 <panic>
    80003d2c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d2e:	40dc                	lw	a5,4(s1)
    80003d30:	0047d79b          	srliw	a5,a5,0x4
    80003d34:	0003b597          	auipc	a1,0x3b
    80003d38:	7445a583          	lw	a1,1860(a1) # 8003f478 <sb+0x18>
    80003d3c:	9dbd                	addw	a1,a1,a5
    80003d3e:	4088                	lw	a0,0(s1)
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	77a080e7          	jalr	1914(ra) # 800034ba <bread>
    80003d48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d4a:	05850593          	addi	a1,a0,88
    80003d4e:	40dc                	lw	a5,4(s1)
    80003d50:	8bbd                	andi	a5,a5,15
    80003d52:	079a                	slli	a5,a5,0x6
    80003d54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d56:	00059783          	lh	a5,0(a1)
    80003d5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d5e:	00259783          	lh	a5,2(a1)
    80003d62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d66:	00459783          	lh	a5,4(a1)
    80003d6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d6e:	00659783          	lh	a5,6(a1)
    80003d72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d76:	459c                	lw	a5,8(a1)
    80003d78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d7a:	03400613          	li	a2,52
    80003d7e:	05b1                	addi	a1,a1,12
    80003d80:	05048513          	addi	a0,s1,80
    80003d84:	ffffd097          	auipc	ra,0xffffd
    80003d88:	12a080e7          	jalr	298(ra) # 80000eae <memmove>
    brelse(bp);
    80003d8c:	854a                	mv	a0,s2
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	85c080e7          	jalr	-1956(ra) # 800035ea <brelse>
    ip->valid = 1;
    80003d96:	4785                	li	a5,1
    80003d98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d9a:	04449783          	lh	a5,68(s1)
    80003d9e:	c399                	beqz	a5,80003da4 <ilock+0xb6>
    80003da0:	6902                	ld	s2,0(sp)
    80003da2:	b7bd                	j	80003d10 <ilock+0x22>
      panic("ilock: no type");
    80003da4:	00004517          	auipc	a0,0x4
    80003da8:	72450513          	addi	a0,a0,1828 # 800084c8 <etext+0x4c8>
    80003dac:	ffffc097          	auipc	ra,0xffffc
    80003db0:	7b4080e7          	jalr	1972(ra) # 80000560 <panic>

0000000080003db4 <iunlock>:
{
    80003db4:	1101                	addi	sp,sp,-32
    80003db6:	ec06                	sd	ra,24(sp)
    80003db8:	e822                	sd	s0,16(sp)
    80003dba:	e426                	sd	s1,8(sp)
    80003dbc:	e04a                	sd	s2,0(sp)
    80003dbe:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003dc0:	c905                	beqz	a0,80003df0 <iunlock+0x3c>
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	01050913          	addi	s2,a0,16
    80003dc8:	854a                	mv	a0,s2
    80003dca:	00001097          	auipc	ra,0x1
    80003dce:	c82080e7          	jalr	-894(ra) # 80004a4c <holdingsleep>
    80003dd2:	cd19                	beqz	a0,80003df0 <iunlock+0x3c>
    80003dd4:	449c                	lw	a5,8(s1)
    80003dd6:	00f05d63          	blez	a5,80003df0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003dda:	854a                	mv	a0,s2
    80003ddc:	00001097          	auipc	ra,0x1
    80003de0:	c2c080e7          	jalr	-980(ra) # 80004a08 <releasesleep>
}
    80003de4:	60e2                	ld	ra,24(sp)
    80003de6:	6442                	ld	s0,16(sp)
    80003de8:	64a2                	ld	s1,8(sp)
    80003dea:	6902                	ld	s2,0(sp)
    80003dec:	6105                	addi	sp,sp,32
    80003dee:	8082                	ret
    panic("iunlock");
    80003df0:	00004517          	auipc	a0,0x4
    80003df4:	6e850513          	addi	a0,a0,1768 # 800084d8 <etext+0x4d8>
    80003df8:	ffffc097          	auipc	ra,0xffffc
    80003dfc:	768080e7          	jalr	1896(ra) # 80000560 <panic>

0000000080003e00 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e00:	7179                	addi	sp,sp,-48
    80003e02:	f406                	sd	ra,40(sp)
    80003e04:	f022                	sd	s0,32(sp)
    80003e06:	ec26                	sd	s1,24(sp)
    80003e08:	e84a                	sd	s2,16(sp)
    80003e0a:	e44e                	sd	s3,8(sp)
    80003e0c:	1800                	addi	s0,sp,48
    80003e0e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e10:	05050493          	addi	s1,a0,80
    80003e14:	08050913          	addi	s2,a0,128
    80003e18:	a021                	j	80003e20 <itrunc+0x20>
    80003e1a:	0491                	addi	s1,s1,4
    80003e1c:	01248d63          	beq	s1,s2,80003e36 <itrunc+0x36>
    if(ip->addrs[i]){
    80003e20:	408c                	lw	a1,0(s1)
    80003e22:	dde5                	beqz	a1,80003e1a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e24:	0009a503          	lw	a0,0(s3)
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	8d6080e7          	jalr	-1834(ra) # 800036fe <bfree>
      ip->addrs[i] = 0;
    80003e30:	0004a023          	sw	zero,0(s1)
    80003e34:	b7dd                	j	80003e1a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e36:	0809a583          	lw	a1,128(s3)
    80003e3a:	ed99                	bnez	a1,80003e58 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e3c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e40:	854e                	mv	a0,s3
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	de0080e7          	jalr	-544(ra) # 80003c22 <iupdate>
}
    80003e4a:	70a2                	ld	ra,40(sp)
    80003e4c:	7402                	ld	s0,32(sp)
    80003e4e:	64e2                	ld	s1,24(sp)
    80003e50:	6942                	ld	s2,16(sp)
    80003e52:	69a2                	ld	s3,8(sp)
    80003e54:	6145                	addi	sp,sp,48
    80003e56:	8082                	ret
    80003e58:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e5a:	0009a503          	lw	a0,0(s3)
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	65c080e7          	jalr	1628(ra) # 800034ba <bread>
    80003e66:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e68:	05850493          	addi	s1,a0,88
    80003e6c:	45850913          	addi	s2,a0,1112
    80003e70:	a021                	j	80003e78 <itrunc+0x78>
    80003e72:	0491                	addi	s1,s1,4
    80003e74:	01248b63          	beq	s1,s2,80003e8a <itrunc+0x8a>
      if(a[j])
    80003e78:	408c                	lw	a1,0(s1)
    80003e7a:	dde5                	beqz	a1,80003e72 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e7c:	0009a503          	lw	a0,0(s3)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	87e080e7          	jalr	-1922(ra) # 800036fe <bfree>
    80003e88:	b7ed                	j	80003e72 <itrunc+0x72>
    brelse(bp);
    80003e8a:	8552                	mv	a0,s4
    80003e8c:	fffff097          	auipc	ra,0xfffff
    80003e90:	75e080e7          	jalr	1886(ra) # 800035ea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e94:	0809a583          	lw	a1,128(s3)
    80003e98:	0009a503          	lw	a0,0(s3)
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	862080e7          	jalr	-1950(ra) # 800036fe <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ea4:	0809a023          	sw	zero,128(s3)
    80003ea8:	6a02                	ld	s4,0(sp)
    80003eaa:	bf49                	j	80003e3c <itrunc+0x3c>

0000000080003eac <iput>:
{
    80003eac:	1101                	addi	sp,sp,-32
    80003eae:	ec06                	sd	ra,24(sp)
    80003eb0:	e822                	sd	s0,16(sp)
    80003eb2:	e426                	sd	s1,8(sp)
    80003eb4:	1000                	addi	s0,sp,32
    80003eb6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003eb8:	0003b517          	auipc	a0,0x3b
    80003ebc:	5c850513          	addi	a0,a0,1480 # 8003f480 <itable>
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	e96080e7          	jalr	-362(ra) # 80000d56 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ec8:	4498                	lw	a4,8(s1)
    80003eca:	4785                	li	a5,1
    80003ecc:	02f70263          	beq	a4,a5,80003ef0 <iput+0x44>
  ip->ref--;
    80003ed0:	449c                	lw	a5,8(s1)
    80003ed2:	37fd                	addiw	a5,a5,-1
    80003ed4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ed6:	0003b517          	auipc	a0,0x3b
    80003eda:	5aa50513          	addi	a0,a0,1450 # 8003f480 <itable>
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	f2c080e7          	jalr	-212(ra) # 80000e0a <release>
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	64a2                	ld	s1,8(sp)
    80003eec:	6105                	addi	sp,sp,32
    80003eee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ef0:	40bc                	lw	a5,64(s1)
    80003ef2:	dff9                	beqz	a5,80003ed0 <iput+0x24>
    80003ef4:	04a49783          	lh	a5,74(s1)
    80003ef8:	ffe1                	bnez	a5,80003ed0 <iput+0x24>
    80003efa:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003efc:	01048913          	addi	s2,s1,16
    80003f00:	854a                	mv	a0,s2
    80003f02:	00001097          	auipc	ra,0x1
    80003f06:	ab0080e7          	jalr	-1360(ra) # 800049b2 <acquiresleep>
    release(&itable.lock);
    80003f0a:	0003b517          	auipc	a0,0x3b
    80003f0e:	57650513          	addi	a0,a0,1398 # 8003f480 <itable>
    80003f12:	ffffd097          	auipc	ra,0xffffd
    80003f16:	ef8080e7          	jalr	-264(ra) # 80000e0a <release>
    itrunc(ip);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	ee4080e7          	jalr	-284(ra) # 80003e00 <itrunc>
    ip->type = 0;
    80003f24:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	cf8080e7          	jalr	-776(ra) # 80003c22 <iupdate>
    ip->valid = 0;
    80003f32:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f36:	854a                	mv	a0,s2
    80003f38:	00001097          	auipc	ra,0x1
    80003f3c:	ad0080e7          	jalr	-1328(ra) # 80004a08 <releasesleep>
    acquire(&itable.lock);
    80003f40:	0003b517          	auipc	a0,0x3b
    80003f44:	54050513          	addi	a0,a0,1344 # 8003f480 <itable>
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	e0e080e7          	jalr	-498(ra) # 80000d56 <acquire>
    80003f50:	6902                	ld	s2,0(sp)
    80003f52:	bfbd                	j	80003ed0 <iput+0x24>

0000000080003f54 <iunlockput>:
{
    80003f54:	1101                	addi	sp,sp,-32
    80003f56:	ec06                	sd	ra,24(sp)
    80003f58:	e822                	sd	s0,16(sp)
    80003f5a:	e426                	sd	s1,8(sp)
    80003f5c:	1000                	addi	s0,sp,32
    80003f5e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	e54080e7          	jalr	-428(ra) # 80003db4 <iunlock>
  iput(ip);
    80003f68:	8526                	mv	a0,s1
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	f42080e7          	jalr	-190(ra) # 80003eac <iput>
}
    80003f72:	60e2                	ld	ra,24(sp)
    80003f74:	6442                	ld	s0,16(sp)
    80003f76:	64a2                	ld	s1,8(sp)
    80003f78:	6105                	addi	sp,sp,32
    80003f7a:	8082                	ret

0000000080003f7c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f7c:	1141                	addi	sp,sp,-16
    80003f7e:	e422                	sd	s0,8(sp)
    80003f80:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f82:	411c                	lw	a5,0(a0)
    80003f84:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f86:	415c                	lw	a5,4(a0)
    80003f88:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f8a:	04451783          	lh	a5,68(a0)
    80003f8e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f92:	04a51783          	lh	a5,74(a0)
    80003f96:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f9a:	04c56783          	lwu	a5,76(a0)
    80003f9e:	e99c                	sd	a5,16(a1)
}
    80003fa0:	6422                	ld	s0,8(sp)
    80003fa2:	0141                	addi	sp,sp,16
    80003fa4:	8082                	ret

0000000080003fa6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fa6:	457c                	lw	a5,76(a0)
    80003fa8:	10d7e563          	bltu	a5,a3,800040b2 <readi+0x10c>
{
    80003fac:	7159                	addi	sp,sp,-112
    80003fae:	f486                	sd	ra,104(sp)
    80003fb0:	f0a2                	sd	s0,96(sp)
    80003fb2:	eca6                	sd	s1,88(sp)
    80003fb4:	e0d2                	sd	s4,64(sp)
    80003fb6:	fc56                	sd	s5,56(sp)
    80003fb8:	f85a                	sd	s6,48(sp)
    80003fba:	f45e                	sd	s7,40(sp)
    80003fbc:	1880                	addi	s0,sp,112
    80003fbe:	8b2a                	mv	s6,a0
    80003fc0:	8bae                	mv	s7,a1
    80003fc2:	8a32                	mv	s4,a2
    80003fc4:	84b6                	mv	s1,a3
    80003fc6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003fc8:	9f35                	addw	a4,a4,a3
    return 0;
    80003fca:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fcc:	0cd76a63          	bltu	a4,a3,800040a0 <readi+0xfa>
    80003fd0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fd2:	00e7f463          	bgeu	a5,a4,80003fda <readi+0x34>
    n = ip->size - off;
    80003fd6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fda:	0a0a8963          	beqz	s5,8000408c <readi+0xe6>
    80003fde:	e8ca                	sd	s2,80(sp)
    80003fe0:	f062                	sd	s8,32(sp)
    80003fe2:	ec66                	sd	s9,24(sp)
    80003fe4:	e86a                	sd	s10,16(sp)
    80003fe6:	e46e                	sd	s11,8(sp)
    80003fe8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fea:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003fee:	5c7d                	li	s8,-1
    80003ff0:	a82d                	j	8000402a <readi+0x84>
    80003ff2:	020d1d93          	slli	s11,s10,0x20
    80003ff6:	020ddd93          	srli	s11,s11,0x20
    80003ffa:	05890613          	addi	a2,s2,88
    80003ffe:	86ee                	mv	a3,s11
    80004000:	963a                	add	a2,a2,a4
    80004002:	85d2                	mv	a1,s4
    80004004:	855e                	mv	a0,s7
    80004006:	ffffe097          	auipc	ra,0xffffe
    8000400a:	792080e7          	jalr	1938(ra) # 80002798 <either_copyout>
    8000400e:	05850d63          	beq	a0,s8,80004068 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004012:	854a                	mv	a0,s2
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	5d6080e7          	jalr	1494(ra) # 800035ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000401c:	013d09bb          	addw	s3,s10,s3
    80004020:	009d04bb          	addw	s1,s10,s1
    80004024:	9a6e                	add	s4,s4,s11
    80004026:	0559fd63          	bgeu	s3,s5,80004080 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    8000402a:	00a4d59b          	srliw	a1,s1,0xa
    8000402e:	855a                	mv	a0,s6
    80004030:	00000097          	auipc	ra,0x0
    80004034:	88e080e7          	jalr	-1906(ra) # 800038be <bmap>
    80004038:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000403c:	c9b1                	beqz	a1,80004090 <readi+0xea>
    bp = bread(ip->dev, addr);
    8000403e:	000b2503          	lw	a0,0(s6)
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	478080e7          	jalr	1144(ra) # 800034ba <bread>
    8000404a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000404c:	3ff4f713          	andi	a4,s1,1023
    80004050:	40ec87bb          	subw	a5,s9,a4
    80004054:	413a86bb          	subw	a3,s5,s3
    80004058:	8d3e                	mv	s10,a5
    8000405a:	2781                	sext.w	a5,a5
    8000405c:	0006861b          	sext.w	a2,a3
    80004060:	f8f679e3          	bgeu	a2,a5,80003ff2 <readi+0x4c>
    80004064:	8d36                	mv	s10,a3
    80004066:	b771                	j	80003ff2 <readi+0x4c>
      brelse(bp);
    80004068:	854a                	mv	a0,s2
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	580080e7          	jalr	1408(ra) # 800035ea <brelse>
      tot = -1;
    80004072:	59fd                	li	s3,-1
      break;
    80004074:	6946                	ld	s2,80(sp)
    80004076:	7c02                	ld	s8,32(sp)
    80004078:	6ce2                	ld	s9,24(sp)
    8000407a:	6d42                	ld	s10,16(sp)
    8000407c:	6da2                	ld	s11,8(sp)
    8000407e:	a831                	j	8000409a <readi+0xf4>
    80004080:	6946                	ld	s2,80(sp)
    80004082:	7c02                	ld	s8,32(sp)
    80004084:	6ce2                	ld	s9,24(sp)
    80004086:	6d42                	ld	s10,16(sp)
    80004088:	6da2                	ld	s11,8(sp)
    8000408a:	a801                	j	8000409a <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000408c:	89d6                	mv	s3,s5
    8000408e:	a031                	j	8000409a <readi+0xf4>
    80004090:	6946                	ld	s2,80(sp)
    80004092:	7c02                	ld	s8,32(sp)
    80004094:	6ce2                	ld	s9,24(sp)
    80004096:	6d42                	ld	s10,16(sp)
    80004098:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000409a:	0009851b          	sext.w	a0,s3
    8000409e:	69a6                	ld	s3,72(sp)
}
    800040a0:	70a6                	ld	ra,104(sp)
    800040a2:	7406                	ld	s0,96(sp)
    800040a4:	64e6                	ld	s1,88(sp)
    800040a6:	6a06                	ld	s4,64(sp)
    800040a8:	7ae2                	ld	s5,56(sp)
    800040aa:	7b42                	ld	s6,48(sp)
    800040ac:	7ba2                	ld	s7,40(sp)
    800040ae:	6165                	addi	sp,sp,112
    800040b0:	8082                	ret
    return 0;
    800040b2:	4501                	li	a0,0
}
    800040b4:	8082                	ret

00000000800040b6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040b6:	457c                	lw	a5,76(a0)
    800040b8:	10d7ee63          	bltu	a5,a3,800041d4 <writei+0x11e>
{
    800040bc:	7159                	addi	sp,sp,-112
    800040be:	f486                	sd	ra,104(sp)
    800040c0:	f0a2                	sd	s0,96(sp)
    800040c2:	e8ca                	sd	s2,80(sp)
    800040c4:	e0d2                	sd	s4,64(sp)
    800040c6:	fc56                	sd	s5,56(sp)
    800040c8:	f85a                	sd	s6,48(sp)
    800040ca:	f45e                	sd	s7,40(sp)
    800040cc:	1880                	addi	s0,sp,112
    800040ce:	8aaa                	mv	s5,a0
    800040d0:	8bae                	mv	s7,a1
    800040d2:	8a32                	mv	s4,a2
    800040d4:	8936                	mv	s2,a3
    800040d6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040d8:	00e687bb          	addw	a5,a3,a4
    800040dc:	0ed7ee63          	bltu	a5,a3,800041d8 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040e0:	00043737          	lui	a4,0x43
    800040e4:	0ef76c63          	bltu	a4,a5,800041dc <writei+0x126>
    800040e8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ea:	0c0b0d63          	beqz	s6,800041c4 <writei+0x10e>
    800040ee:	eca6                	sd	s1,88(sp)
    800040f0:	f062                	sd	s8,32(sp)
    800040f2:	ec66                	sd	s9,24(sp)
    800040f4:	e86a                	sd	s10,16(sp)
    800040f6:	e46e                	sd	s11,8(sp)
    800040f8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800040fa:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800040fe:	5c7d                	li	s8,-1
    80004100:	a091                	j	80004144 <writei+0x8e>
    80004102:	020d1d93          	slli	s11,s10,0x20
    80004106:	020ddd93          	srli	s11,s11,0x20
    8000410a:	05848513          	addi	a0,s1,88
    8000410e:	86ee                	mv	a3,s11
    80004110:	8652                	mv	a2,s4
    80004112:	85de                	mv	a1,s7
    80004114:	953a                	add	a0,a0,a4
    80004116:	ffffe097          	auipc	ra,0xffffe
    8000411a:	6d8080e7          	jalr	1752(ra) # 800027ee <either_copyin>
    8000411e:	07850263          	beq	a0,s8,80004182 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004122:	8526                	mv	a0,s1
    80004124:	00000097          	auipc	ra,0x0
    80004128:	770080e7          	jalr	1904(ra) # 80004894 <log_write>
    brelse(bp);
    8000412c:	8526                	mv	a0,s1
    8000412e:	fffff097          	auipc	ra,0xfffff
    80004132:	4bc080e7          	jalr	1212(ra) # 800035ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004136:	013d09bb          	addw	s3,s10,s3
    8000413a:	012d093b          	addw	s2,s10,s2
    8000413e:	9a6e                	add	s4,s4,s11
    80004140:	0569f663          	bgeu	s3,s6,8000418c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004144:	00a9559b          	srliw	a1,s2,0xa
    80004148:	8556                	mv	a0,s5
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	774080e7          	jalr	1908(ra) # 800038be <bmap>
    80004152:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004156:	c99d                	beqz	a1,8000418c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004158:	000aa503          	lw	a0,0(s5)
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	35e080e7          	jalr	862(ra) # 800034ba <bread>
    80004164:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004166:	3ff97713          	andi	a4,s2,1023
    8000416a:	40ec87bb          	subw	a5,s9,a4
    8000416e:	413b06bb          	subw	a3,s6,s3
    80004172:	8d3e                	mv	s10,a5
    80004174:	2781                	sext.w	a5,a5
    80004176:	0006861b          	sext.w	a2,a3
    8000417a:	f8f674e3          	bgeu	a2,a5,80004102 <writei+0x4c>
    8000417e:	8d36                	mv	s10,a3
    80004180:	b749                	j	80004102 <writei+0x4c>
      brelse(bp);
    80004182:	8526                	mv	a0,s1
    80004184:	fffff097          	auipc	ra,0xfffff
    80004188:	466080e7          	jalr	1126(ra) # 800035ea <brelse>
  }

  if(off > ip->size)
    8000418c:	04caa783          	lw	a5,76(s5)
    80004190:	0327fc63          	bgeu	a5,s2,800041c8 <writei+0x112>
    ip->size = off;
    80004194:	052aa623          	sw	s2,76(s5)
    80004198:	64e6                	ld	s1,88(sp)
    8000419a:	7c02                	ld	s8,32(sp)
    8000419c:	6ce2                	ld	s9,24(sp)
    8000419e:	6d42                	ld	s10,16(sp)
    800041a0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800041a2:	8556                	mv	a0,s5
    800041a4:	00000097          	auipc	ra,0x0
    800041a8:	a7e080e7          	jalr	-1410(ra) # 80003c22 <iupdate>

  return tot;
    800041ac:	0009851b          	sext.w	a0,s3
    800041b0:	69a6                	ld	s3,72(sp)
}
    800041b2:	70a6                	ld	ra,104(sp)
    800041b4:	7406                	ld	s0,96(sp)
    800041b6:	6946                	ld	s2,80(sp)
    800041b8:	6a06                	ld	s4,64(sp)
    800041ba:	7ae2                	ld	s5,56(sp)
    800041bc:	7b42                	ld	s6,48(sp)
    800041be:	7ba2                	ld	s7,40(sp)
    800041c0:	6165                	addi	sp,sp,112
    800041c2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041c4:	89da                	mv	s3,s6
    800041c6:	bff1                	j	800041a2 <writei+0xec>
    800041c8:	64e6                	ld	s1,88(sp)
    800041ca:	7c02                	ld	s8,32(sp)
    800041cc:	6ce2                	ld	s9,24(sp)
    800041ce:	6d42                	ld	s10,16(sp)
    800041d0:	6da2                	ld	s11,8(sp)
    800041d2:	bfc1                	j	800041a2 <writei+0xec>
    return -1;
    800041d4:	557d                	li	a0,-1
}
    800041d6:	8082                	ret
    return -1;
    800041d8:	557d                	li	a0,-1
    800041da:	bfe1                	j	800041b2 <writei+0xfc>
    return -1;
    800041dc:	557d                	li	a0,-1
    800041de:	bfd1                	j	800041b2 <writei+0xfc>

00000000800041e0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041e0:	1141                	addi	sp,sp,-16
    800041e2:	e406                	sd	ra,8(sp)
    800041e4:	e022                	sd	s0,0(sp)
    800041e6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041e8:	4639                	li	a2,14
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	d38080e7          	jalr	-712(ra) # 80000f22 <strncmp>
}
    800041f2:	60a2                	ld	ra,8(sp)
    800041f4:	6402                	ld	s0,0(sp)
    800041f6:	0141                	addi	sp,sp,16
    800041f8:	8082                	ret

00000000800041fa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041fa:	7139                	addi	sp,sp,-64
    800041fc:	fc06                	sd	ra,56(sp)
    800041fe:	f822                	sd	s0,48(sp)
    80004200:	f426                	sd	s1,40(sp)
    80004202:	f04a                	sd	s2,32(sp)
    80004204:	ec4e                	sd	s3,24(sp)
    80004206:	e852                	sd	s4,16(sp)
    80004208:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000420a:	04451703          	lh	a4,68(a0)
    8000420e:	4785                	li	a5,1
    80004210:	00f71a63          	bne	a4,a5,80004224 <dirlookup+0x2a>
    80004214:	892a                	mv	s2,a0
    80004216:	89ae                	mv	s3,a1
    80004218:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000421a:	457c                	lw	a5,76(a0)
    8000421c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000421e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004220:	e79d                	bnez	a5,8000424e <dirlookup+0x54>
    80004222:	a8a5                	j	8000429a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004224:	00004517          	auipc	a0,0x4
    80004228:	2bc50513          	addi	a0,a0,700 # 800084e0 <etext+0x4e0>
    8000422c:	ffffc097          	auipc	ra,0xffffc
    80004230:	334080e7          	jalr	820(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004234:	00004517          	auipc	a0,0x4
    80004238:	2c450513          	addi	a0,a0,708 # 800084f8 <etext+0x4f8>
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	324080e7          	jalr	804(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004244:	24c1                	addiw	s1,s1,16
    80004246:	04c92783          	lw	a5,76(s2)
    8000424a:	04f4f763          	bgeu	s1,a5,80004298 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000424e:	4741                	li	a4,16
    80004250:	86a6                	mv	a3,s1
    80004252:	fc040613          	addi	a2,s0,-64
    80004256:	4581                	li	a1,0
    80004258:	854a                	mv	a0,s2
    8000425a:	00000097          	auipc	ra,0x0
    8000425e:	d4c080e7          	jalr	-692(ra) # 80003fa6 <readi>
    80004262:	47c1                	li	a5,16
    80004264:	fcf518e3          	bne	a0,a5,80004234 <dirlookup+0x3a>
    if(de.inum == 0)
    80004268:	fc045783          	lhu	a5,-64(s0)
    8000426c:	dfe1                	beqz	a5,80004244 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000426e:	fc240593          	addi	a1,s0,-62
    80004272:	854e                	mv	a0,s3
    80004274:	00000097          	auipc	ra,0x0
    80004278:	f6c080e7          	jalr	-148(ra) # 800041e0 <namecmp>
    8000427c:	f561                	bnez	a0,80004244 <dirlookup+0x4a>
      if(poff)
    8000427e:	000a0463          	beqz	s4,80004286 <dirlookup+0x8c>
        *poff = off;
    80004282:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004286:	fc045583          	lhu	a1,-64(s0)
    8000428a:	00092503          	lw	a0,0(s2)
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	720080e7          	jalr	1824(ra) # 800039ae <iget>
    80004296:	a011                	j	8000429a <dirlookup+0xa0>
  return 0;
    80004298:	4501                	li	a0,0
}
    8000429a:	70e2                	ld	ra,56(sp)
    8000429c:	7442                	ld	s0,48(sp)
    8000429e:	74a2                	ld	s1,40(sp)
    800042a0:	7902                	ld	s2,32(sp)
    800042a2:	69e2                	ld	s3,24(sp)
    800042a4:	6a42                	ld	s4,16(sp)
    800042a6:	6121                	addi	sp,sp,64
    800042a8:	8082                	ret

00000000800042aa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800042aa:	711d                	addi	sp,sp,-96
    800042ac:	ec86                	sd	ra,88(sp)
    800042ae:	e8a2                	sd	s0,80(sp)
    800042b0:	e4a6                	sd	s1,72(sp)
    800042b2:	e0ca                	sd	s2,64(sp)
    800042b4:	fc4e                	sd	s3,56(sp)
    800042b6:	f852                	sd	s4,48(sp)
    800042b8:	f456                	sd	s5,40(sp)
    800042ba:	f05a                	sd	s6,32(sp)
    800042bc:	ec5e                	sd	s7,24(sp)
    800042be:	e862                	sd	s8,16(sp)
    800042c0:	e466                	sd	s9,8(sp)
    800042c2:	1080                	addi	s0,sp,96
    800042c4:	84aa                	mv	s1,a0
    800042c6:	8b2e                	mv	s6,a1
    800042c8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800042ca:	00054703          	lbu	a4,0(a0)
    800042ce:	02f00793          	li	a5,47
    800042d2:	02f70263          	beq	a4,a5,800042f6 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042d6:	ffffe097          	auipc	ra,0xffffe
    800042da:	9f0080e7          	jalr	-1552(ra) # 80001cc6 <myproc>
    800042de:	15053503          	ld	a0,336(a0)
    800042e2:	00000097          	auipc	ra,0x0
    800042e6:	9ce080e7          	jalr	-1586(ra) # 80003cb0 <idup>
    800042ea:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042ec:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800042f0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042f2:	4b85                	li	s7,1
    800042f4:	a875                	j	800043b0 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800042f6:	4585                	li	a1,1
    800042f8:	4505                	li	a0,1
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	6b4080e7          	jalr	1716(ra) # 800039ae <iget>
    80004302:	8a2a                	mv	s4,a0
    80004304:	b7e5                	j	800042ec <namex+0x42>
      iunlockput(ip);
    80004306:	8552                	mv	a0,s4
    80004308:	00000097          	auipc	ra,0x0
    8000430c:	c4c080e7          	jalr	-948(ra) # 80003f54 <iunlockput>
      return 0;
    80004310:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004312:	8552                	mv	a0,s4
    80004314:	60e6                	ld	ra,88(sp)
    80004316:	6446                	ld	s0,80(sp)
    80004318:	64a6                	ld	s1,72(sp)
    8000431a:	6906                	ld	s2,64(sp)
    8000431c:	79e2                	ld	s3,56(sp)
    8000431e:	7a42                	ld	s4,48(sp)
    80004320:	7aa2                	ld	s5,40(sp)
    80004322:	7b02                	ld	s6,32(sp)
    80004324:	6be2                	ld	s7,24(sp)
    80004326:	6c42                	ld	s8,16(sp)
    80004328:	6ca2                	ld	s9,8(sp)
    8000432a:	6125                	addi	sp,sp,96
    8000432c:	8082                	ret
      iunlock(ip);
    8000432e:	8552                	mv	a0,s4
    80004330:	00000097          	auipc	ra,0x0
    80004334:	a84080e7          	jalr	-1404(ra) # 80003db4 <iunlock>
      return ip;
    80004338:	bfe9                	j	80004312 <namex+0x68>
      iunlockput(ip);
    8000433a:	8552                	mv	a0,s4
    8000433c:	00000097          	auipc	ra,0x0
    80004340:	c18080e7          	jalr	-1000(ra) # 80003f54 <iunlockput>
      return 0;
    80004344:	8a4e                	mv	s4,s3
    80004346:	b7f1                	j	80004312 <namex+0x68>
  len = path - s;
    80004348:	40998633          	sub	a2,s3,s1
    8000434c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004350:	099c5863          	bge	s8,s9,800043e0 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004354:	4639                	li	a2,14
    80004356:	85a6                	mv	a1,s1
    80004358:	8556                	mv	a0,s5
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	b54080e7          	jalr	-1196(ra) # 80000eae <memmove>
    80004362:	84ce                	mv	s1,s3
  while(*path == '/')
    80004364:	0004c783          	lbu	a5,0(s1)
    80004368:	01279763          	bne	a5,s2,80004376 <namex+0xcc>
    path++;
    8000436c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000436e:	0004c783          	lbu	a5,0(s1)
    80004372:	ff278de3          	beq	a5,s2,8000436c <namex+0xc2>
    ilock(ip);
    80004376:	8552                	mv	a0,s4
    80004378:	00000097          	auipc	ra,0x0
    8000437c:	976080e7          	jalr	-1674(ra) # 80003cee <ilock>
    if(ip->type != T_DIR){
    80004380:	044a1783          	lh	a5,68(s4)
    80004384:	f97791e3          	bne	a5,s7,80004306 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004388:	000b0563          	beqz	s6,80004392 <namex+0xe8>
    8000438c:	0004c783          	lbu	a5,0(s1)
    80004390:	dfd9                	beqz	a5,8000432e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004392:	4601                	li	a2,0
    80004394:	85d6                	mv	a1,s5
    80004396:	8552                	mv	a0,s4
    80004398:	00000097          	auipc	ra,0x0
    8000439c:	e62080e7          	jalr	-414(ra) # 800041fa <dirlookup>
    800043a0:	89aa                	mv	s3,a0
    800043a2:	dd41                	beqz	a0,8000433a <namex+0x90>
    iunlockput(ip);
    800043a4:	8552                	mv	a0,s4
    800043a6:	00000097          	auipc	ra,0x0
    800043aa:	bae080e7          	jalr	-1106(ra) # 80003f54 <iunlockput>
    ip = next;
    800043ae:	8a4e                	mv	s4,s3
  while(*path == '/')
    800043b0:	0004c783          	lbu	a5,0(s1)
    800043b4:	01279763          	bne	a5,s2,800043c2 <namex+0x118>
    path++;
    800043b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043ba:	0004c783          	lbu	a5,0(s1)
    800043be:	ff278de3          	beq	a5,s2,800043b8 <namex+0x10e>
  if(*path == 0)
    800043c2:	cb9d                	beqz	a5,800043f8 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800043c4:	0004c783          	lbu	a5,0(s1)
    800043c8:	89a6                	mv	s3,s1
  len = path - s;
    800043ca:	4c81                	li	s9,0
    800043cc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800043ce:	01278963          	beq	a5,s2,800043e0 <namex+0x136>
    800043d2:	dbbd                	beqz	a5,80004348 <namex+0x9e>
    path++;
    800043d4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800043d6:	0009c783          	lbu	a5,0(s3)
    800043da:	ff279ce3          	bne	a5,s2,800043d2 <namex+0x128>
    800043de:	b7ad                	j	80004348 <namex+0x9e>
    memmove(name, s, len);
    800043e0:	2601                	sext.w	a2,a2
    800043e2:	85a6                	mv	a1,s1
    800043e4:	8556                	mv	a0,s5
    800043e6:	ffffd097          	auipc	ra,0xffffd
    800043ea:	ac8080e7          	jalr	-1336(ra) # 80000eae <memmove>
    name[len] = 0;
    800043ee:	9cd6                	add	s9,s9,s5
    800043f0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800043f4:	84ce                	mv	s1,s3
    800043f6:	b7bd                	j	80004364 <namex+0xba>
  if(nameiparent){
    800043f8:	f00b0de3          	beqz	s6,80004312 <namex+0x68>
    iput(ip);
    800043fc:	8552                	mv	a0,s4
    800043fe:	00000097          	auipc	ra,0x0
    80004402:	aae080e7          	jalr	-1362(ra) # 80003eac <iput>
    return 0;
    80004406:	4a01                	li	s4,0
    80004408:	b729                	j	80004312 <namex+0x68>

000000008000440a <dirlink>:
{
    8000440a:	7139                	addi	sp,sp,-64
    8000440c:	fc06                	sd	ra,56(sp)
    8000440e:	f822                	sd	s0,48(sp)
    80004410:	f04a                	sd	s2,32(sp)
    80004412:	ec4e                	sd	s3,24(sp)
    80004414:	e852                	sd	s4,16(sp)
    80004416:	0080                	addi	s0,sp,64
    80004418:	892a                	mv	s2,a0
    8000441a:	8a2e                	mv	s4,a1
    8000441c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000441e:	4601                	li	a2,0
    80004420:	00000097          	auipc	ra,0x0
    80004424:	dda080e7          	jalr	-550(ra) # 800041fa <dirlookup>
    80004428:	ed25                	bnez	a0,800044a0 <dirlink+0x96>
    8000442a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000442c:	04c92483          	lw	s1,76(s2)
    80004430:	c49d                	beqz	s1,8000445e <dirlink+0x54>
    80004432:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004434:	4741                	li	a4,16
    80004436:	86a6                	mv	a3,s1
    80004438:	fc040613          	addi	a2,s0,-64
    8000443c:	4581                	li	a1,0
    8000443e:	854a                	mv	a0,s2
    80004440:	00000097          	auipc	ra,0x0
    80004444:	b66080e7          	jalr	-1178(ra) # 80003fa6 <readi>
    80004448:	47c1                	li	a5,16
    8000444a:	06f51163          	bne	a0,a5,800044ac <dirlink+0xa2>
    if(de.inum == 0)
    8000444e:	fc045783          	lhu	a5,-64(s0)
    80004452:	c791                	beqz	a5,8000445e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004454:	24c1                	addiw	s1,s1,16
    80004456:	04c92783          	lw	a5,76(s2)
    8000445a:	fcf4ede3          	bltu	s1,a5,80004434 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000445e:	4639                	li	a2,14
    80004460:	85d2                	mv	a1,s4
    80004462:	fc240513          	addi	a0,s0,-62
    80004466:	ffffd097          	auipc	ra,0xffffd
    8000446a:	af2080e7          	jalr	-1294(ra) # 80000f58 <strncpy>
  de.inum = inum;
    8000446e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004472:	4741                	li	a4,16
    80004474:	86a6                	mv	a3,s1
    80004476:	fc040613          	addi	a2,s0,-64
    8000447a:	4581                	li	a1,0
    8000447c:	854a                	mv	a0,s2
    8000447e:	00000097          	auipc	ra,0x0
    80004482:	c38080e7          	jalr	-968(ra) # 800040b6 <writei>
    80004486:	1541                	addi	a0,a0,-16
    80004488:	00a03533          	snez	a0,a0
    8000448c:	40a00533          	neg	a0,a0
    80004490:	74a2                	ld	s1,40(sp)
}
    80004492:	70e2                	ld	ra,56(sp)
    80004494:	7442                	ld	s0,48(sp)
    80004496:	7902                	ld	s2,32(sp)
    80004498:	69e2                	ld	s3,24(sp)
    8000449a:	6a42                	ld	s4,16(sp)
    8000449c:	6121                	addi	sp,sp,64
    8000449e:	8082                	ret
    iput(ip);
    800044a0:	00000097          	auipc	ra,0x0
    800044a4:	a0c080e7          	jalr	-1524(ra) # 80003eac <iput>
    return -1;
    800044a8:	557d                	li	a0,-1
    800044aa:	b7e5                	j	80004492 <dirlink+0x88>
      panic("dirlink read");
    800044ac:	00004517          	auipc	a0,0x4
    800044b0:	05c50513          	addi	a0,a0,92 # 80008508 <etext+0x508>
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	0ac080e7          	jalr	172(ra) # 80000560 <panic>

00000000800044bc <namei>:

struct inode*
namei(char *path)
{
    800044bc:	1101                	addi	sp,sp,-32
    800044be:	ec06                	sd	ra,24(sp)
    800044c0:	e822                	sd	s0,16(sp)
    800044c2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044c4:	fe040613          	addi	a2,s0,-32
    800044c8:	4581                	li	a1,0
    800044ca:	00000097          	auipc	ra,0x0
    800044ce:	de0080e7          	jalr	-544(ra) # 800042aa <namex>
}
    800044d2:	60e2                	ld	ra,24(sp)
    800044d4:	6442                	ld	s0,16(sp)
    800044d6:	6105                	addi	sp,sp,32
    800044d8:	8082                	ret

00000000800044da <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044da:	1141                	addi	sp,sp,-16
    800044dc:	e406                	sd	ra,8(sp)
    800044de:	e022                	sd	s0,0(sp)
    800044e0:	0800                	addi	s0,sp,16
    800044e2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044e4:	4585                	li	a1,1
    800044e6:	00000097          	auipc	ra,0x0
    800044ea:	dc4080e7          	jalr	-572(ra) # 800042aa <namex>
}
    800044ee:	60a2                	ld	ra,8(sp)
    800044f0:	6402                	ld	s0,0(sp)
    800044f2:	0141                	addi	sp,sp,16
    800044f4:	8082                	ret

00000000800044f6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044f6:	1101                	addi	sp,sp,-32
    800044f8:	ec06                	sd	ra,24(sp)
    800044fa:	e822                	sd	s0,16(sp)
    800044fc:	e426                	sd	s1,8(sp)
    800044fe:	e04a                	sd	s2,0(sp)
    80004500:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004502:	0003d917          	auipc	s2,0x3d
    80004506:	a2690913          	addi	s2,s2,-1498 # 80040f28 <log>
    8000450a:	01892583          	lw	a1,24(s2)
    8000450e:	02892503          	lw	a0,40(s2)
    80004512:	fffff097          	auipc	ra,0xfffff
    80004516:	fa8080e7          	jalr	-88(ra) # 800034ba <bread>
    8000451a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000451c:	02c92603          	lw	a2,44(s2)
    80004520:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004522:	00c05f63          	blez	a2,80004540 <write_head+0x4a>
    80004526:	0003d717          	auipc	a4,0x3d
    8000452a:	a3270713          	addi	a4,a4,-1486 # 80040f58 <log+0x30>
    8000452e:	87aa                	mv	a5,a0
    80004530:	060a                	slli	a2,a2,0x2
    80004532:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004534:	4314                	lw	a3,0(a4)
    80004536:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004538:	0711                	addi	a4,a4,4
    8000453a:	0791                	addi	a5,a5,4
    8000453c:	fec79ce3          	bne	a5,a2,80004534 <write_head+0x3e>
  }
  bwrite(buf);
    80004540:	8526                	mv	a0,s1
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	06a080e7          	jalr	106(ra) # 800035ac <bwrite>
  brelse(buf);
    8000454a:	8526                	mv	a0,s1
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	09e080e7          	jalr	158(ra) # 800035ea <brelse>
}
    80004554:	60e2                	ld	ra,24(sp)
    80004556:	6442                	ld	s0,16(sp)
    80004558:	64a2                	ld	s1,8(sp)
    8000455a:	6902                	ld	s2,0(sp)
    8000455c:	6105                	addi	sp,sp,32
    8000455e:	8082                	ret

0000000080004560 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004560:	0003d797          	auipc	a5,0x3d
    80004564:	9f47a783          	lw	a5,-1548(a5) # 80040f54 <log+0x2c>
    80004568:	0af05d63          	blez	a5,80004622 <install_trans+0xc2>
{
    8000456c:	7139                	addi	sp,sp,-64
    8000456e:	fc06                	sd	ra,56(sp)
    80004570:	f822                	sd	s0,48(sp)
    80004572:	f426                	sd	s1,40(sp)
    80004574:	f04a                	sd	s2,32(sp)
    80004576:	ec4e                	sd	s3,24(sp)
    80004578:	e852                	sd	s4,16(sp)
    8000457a:	e456                	sd	s5,8(sp)
    8000457c:	e05a                	sd	s6,0(sp)
    8000457e:	0080                	addi	s0,sp,64
    80004580:	8b2a                	mv	s6,a0
    80004582:	0003da97          	auipc	s5,0x3d
    80004586:	9d6a8a93          	addi	s5,s5,-1578 # 80040f58 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000458a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000458c:	0003d997          	auipc	s3,0x3d
    80004590:	99c98993          	addi	s3,s3,-1636 # 80040f28 <log>
    80004594:	a00d                	j	800045b6 <install_trans+0x56>
    brelse(lbuf);
    80004596:	854a                	mv	a0,s2
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	052080e7          	jalr	82(ra) # 800035ea <brelse>
    brelse(dbuf);
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	048080e7          	jalr	72(ra) # 800035ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045aa:	2a05                	addiw	s4,s4,1
    800045ac:	0a91                	addi	s5,s5,4
    800045ae:	02c9a783          	lw	a5,44(s3)
    800045b2:	04fa5e63          	bge	s4,a5,8000460e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045b6:	0189a583          	lw	a1,24(s3)
    800045ba:	014585bb          	addw	a1,a1,s4
    800045be:	2585                	addiw	a1,a1,1
    800045c0:	0289a503          	lw	a0,40(s3)
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	ef6080e7          	jalr	-266(ra) # 800034ba <bread>
    800045cc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045ce:	000aa583          	lw	a1,0(s5)
    800045d2:	0289a503          	lw	a0,40(s3)
    800045d6:	fffff097          	auipc	ra,0xfffff
    800045da:	ee4080e7          	jalr	-284(ra) # 800034ba <bread>
    800045de:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045e0:	40000613          	li	a2,1024
    800045e4:	05890593          	addi	a1,s2,88
    800045e8:	05850513          	addi	a0,a0,88
    800045ec:	ffffd097          	auipc	ra,0xffffd
    800045f0:	8c2080e7          	jalr	-1854(ra) # 80000eae <memmove>
    bwrite(dbuf);  // write dst to disk
    800045f4:	8526                	mv	a0,s1
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	fb6080e7          	jalr	-74(ra) # 800035ac <bwrite>
    if(recovering == 0)
    800045fe:	f80b1ce3          	bnez	s6,80004596 <install_trans+0x36>
      bunpin(dbuf);
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	0be080e7          	jalr	190(ra) # 800036c2 <bunpin>
    8000460c:	b769                	j	80004596 <install_trans+0x36>
}
    8000460e:	70e2                	ld	ra,56(sp)
    80004610:	7442                	ld	s0,48(sp)
    80004612:	74a2                	ld	s1,40(sp)
    80004614:	7902                	ld	s2,32(sp)
    80004616:	69e2                	ld	s3,24(sp)
    80004618:	6a42                	ld	s4,16(sp)
    8000461a:	6aa2                	ld	s5,8(sp)
    8000461c:	6b02                	ld	s6,0(sp)
    8000461e:	6121                	addi	sp,sp,64
    80004620:	8082                	ret
    80004622:	8082                	ret

0000000080004624 <initlog>:
{
    80004624:	7179                	addi	sp,sp,-48
    80004626:	f406                	sd	ra,40(sp)
    80004628:	f022                	sd	s0,32(sp)
    8000462a:	ec26                	sd	s1,24(sp)
    8000462c:	e84a                	sd	s2,16(sp)
    8000462e:	e44e                	sd	s3,8(sp)
    80004630:	1800                	addi	s0,sp,48
    80004632:	892a                	mv	s2,a0
    80004634:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004636:	0003d497          	auipc	s1,0x3d
    8000463a:	8f248493          	addi	s1,s1,-1806 # 80040f28 <log>
    8000463e:	00004597          	auipc	a1,0x4
    80004642:	eda58593          	addi	a1,a1,-294 # 80008518 <etext+0x518>
    80004646:	8526                	mv	a0,s1
    80004648:	ffffc097          	auipc	ra,0xffffc
    8000464c:	67e080e7          	jalr	1662(ra) # 80000cc6 <initlock>
  log.start = sb->logstart;
    80004650:	0149a583          	lw	a1,20(s3)
    80004654:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004656:	0109a783          	lw	a5,16(s3)
    8000465a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000465c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004660:	854a                	mv	a0,s2
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	e58080e7          	jalr	-424(ra) # 800034ba <bread>
  log.lh.n = lh->n;
    8000466a:	4d30                	lw	a2,88(a0)
    8000466c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000466e:	00c05f63          	blez	a2,8000468c <initlog+0x68>
    80004672:	87aa                	mv	a5,a0
    80004674:	0003d717          	auipc	a4,0x3d
    80004678:	8e470713          	addi	a4,a4,-1820 # 80040f58 <log+0x30>
    8000467c:	060a                	slli	a2,a2,0x2
    8000467e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004680:	4ff4                	lw	a3,92(a5)
    80004682:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004684:	0791                	addi	a5,a5,4
    80004686:	0711                	addi	a4,a4,4
    80004688:	fec79ce3          	bne	a5,a2,80004680 <initlog+0x5c>
  brelse(buf);
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	f5e080e7          	jalr	-162(ra) # 800035ea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004694:	4505                	li	a0,1
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	eca080e7          	jalr	-310(ra) # 80004560 <install_trans>
  log.lh.n = 0;
    8000469e:	0003d797          	auipc	a5,0x3d
    800046a2:	8a07ab23          	sw	zero,-1866(a5) # 80040f54 <log+0x2c>
  write_head(); // clear the log
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	e50080e7          	jalr	-432(ra) # 800044f6 <write_head>
}
    800046ae:	70a2                	ld	ra,40(sp)
    800046b0:	7402                	ld	s0,32(sp)
    800046b2:	64e2                	ld	s1,24(sp)
    800046b4:	6942                	ld	s2,16(sp)
    800046b6:	69a2                	ld	s3,8(sp)
    800046b8:	6145                	addi	sp,sp,48
    800046ba:	8082                	ret

00000000800046bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046bc:	1101                	addi	sp,sp,-32
    800046be:	ec06                	sd	ra,24(sp)
    800046c0:	e822                	sd	s0,16(sp)
    800046c2:	e426                	sd	s1,8(sp)
    800046c4:	e04a                	sd	s2,0(sp)
    800046c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046c8:	0003d517          	auipc	a0,0x3d
    800046cc:	86050513          	addi	a0,a0,-1952 # 80040f28 <log>
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	686080e7          	jalr	1670(ra) # 80000d56 <acquire>
  while(1){
    if(log.committing){
    800046d8:	0003d497          	auipc	s1,0x3d
    800046dc:	85048493          	addi	s1,s1,-1968 # 80040f28 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046e0:	4979                	li	s2,30
    800046e2:	a039                	j	800046f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800046e4:	85a6                	mv	a1,s1
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	c9c080e7          	jalr	-868(ra) # 80002384 <sleep>
    if(log.committing){
    800046f0:	50dc                	lw	a5,36(s1)
    800046f2:	fbed                	bnez	a5,800046e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046f4:	5098                	lw	a4,32(s1)
    800046f6:	2705                	addiw	a4,a4,1
    800046f8:	0027179b          	slliw	a5,a4,0x2
    800046fc:	9fb9                	addw	a5,a5,a4
    800046fe:	0017979b          	slliw	a5,a5,0x1
    80004702:	54d4                	lw	a3,44(s1)
    80004704:	9fb5                	addw	a5,a5,a3
    80004706:	00f95963          	bge	s2,a5,80004718 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000470a:	85a6                	mv	a1,s1
    8000470c:	8526                	mv	a0,s1
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	c76080e7          	jalr	-906(ra) # 80002384 <sleep>
    80004716:	bfe9                	j	800046f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004718:	0003d517          	auipc	a0,0x3d
    8000471c:	81050513          	addi	a0,a0,-2032 # 80040f28 <log>
    80004720:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004722:	ffffc097          	auipc	ra,0xffffc
    80004726:	6e8080e7          	jalr	1768(ra) # 80000e0a <release>
      break;
    }
  }
}
    8000472a:	60e2                	ld	ra,24(sp)
    8000472c:	6442                	ld	s0,16(sp)
    8000472e:	64a2                	ld	s1,8(sp)
    80004730:	6902                	ld	s2,0(sp)
    80004732:	6105                	addi	sp,sp,32
    80004734:	8082                	ret

0000000080004736 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004736:	7139                	addi	sp,sp,-64
    80004738:	fc06                	sd	ra,56(sp)
    8000473a:	f822                	sd	s0,48(sp)
    8000473c:	f426                	sd	s1,40(sp)
    8000473e:	f04a                	sd	s2,32(sp)
    80004740:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004742:	0003c497          	auipc	s1,0x3c
    80004746:	7e648493          	addi	s1,s1,2022 # 80040f28 <log>
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	60a080e7          	jalr	1546(ra) # 80000d56 <acquire>
  log.outstanding -= 1;
    80004754:	509c                	lw	a5,32(s1)
    80004756:	37fd                	addiw	a5,a5,-1
    80004758:	0007891b          	sext.w	s2,a5
    8000475c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000475e:	50dc                	lw	a5,36(s1)
    80004760:	e7b9                	bnez	a5,800047ae <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004762:	06091163          	bnez	s2,800047c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004766:	0003c497          	auipc	s1,0x3c
    8000476a:	7c248493          	addi	s1,s1,1986 # 80040f28 <log>
    8000476e:	4785                	li	a5,1
    80004770:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004772:	8526                	mv	a0,s1
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	696080e7          	jalr	1686(ra) # 80000e0a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000477c:	54dc                	lw	a5,44(s1)
    8000477e:	06f04763          	bgtz	a5,800047ec <end_op+0xb6>
    acquire(&log.lock);
    80004782:	0003c497          	auipc	s1,0x3c
    80004786:	7a648493          	addi	s1,s1,1958 # 80040f28 <log>
    8000478a:	8526                	mv	a0,s1
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	5ca080e7          	jalr	1482(ra) # 80000d56 <acquire>
    log.committing = 0;
    80004794:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004798:	8526                	mv	a0,s1
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	c4e080e7          	jalr	-946(ra) # 800023e8 <wakeup>
    release(&log.lock);
    800047a2:	8526                	mv	a0,s1
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	666080e7          	jalr	1638(ra) # 80000e0a <release>
}
    800047ac:	a815                	j	800047e0 <end_op+0xaa>
    800047ae:	ec4e                	sd	s3,24(sp)
    800047b0:	e852                	sd	s4,16(sp)
    800047b2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800047b4:	00004517          	auipc	a0,0x4
    800047b8:	d6c50513          	addi	a0,a0,-660 # 80008520 <etext+0x520>
    800047bc:	ffffc097          	auipc	ra,0xffffc
    800047c0:	da4080e7          	jalr	-604(ra) # 80000560 <panic>
    wakeup(&log);
    800047c4:	0003c497          	auipc	s1,0x3c
    800047c8:	76448493          	addi	s1,s1,1892 # 80040f28 <log>
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	c1a080e7          	jalr	-998(ra) # 800023e8 <wakeup>
  release(&log.lock);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	632080e7          	jalr	1586(ra) # 80000e0a <release>
}
    800047e0:	70e2                	ld	ra,56(sp)
    800047e2:	7442                	ld	s0,48(sp)
    800047e4:	74a2                	ld	s1,40(sp)
    800047e6:	7902                	ld	s2,32(sp)
    800047e8:	6121                	addi	sp,sp,64
    800047ea:	8082                	ret
    800047ec:	ec4e                	sd	s3,24(sp)
    800047ee:	e852                	sd	s4,16(sp)
    800047f0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800047f2:	0003ca97          	auipc	s5,0x3c
    800047f6:	766a8a93          	addi	s5,s5,1894 # 80040f58 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047fa:	0003ca17          	auipc	s4,0x3c
    800047fe:	72ea0a13          	addi	s4,s4,1838 # 80040f28 <log>
    80004802:	018a2583          	lw	a1,24(s4)
    80004806:	012585bb          	addw	a1,a1,s2
    8000480a:	2585                	addiw	a1,a1,1
    8000480c:	028a2503          	lw	a0,40(s4)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	caa080e7          	jalr	-854(ra) # 800034ba <bread>
    80004818:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000481a:	000aa583          	lw	a1,0(s5)
    8000481e:	028a2503          	lw	a0,40(s4)
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	c98080e7          	jalr	-872(ra) # 800034ba <bread>
    8000482a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000482c:	40000613          	li	a2,1024
    80004830:	05850593          	addi	a1,a0,88
    80004834:	05848513          	addi	a0,s1,88
    80004838:	ffffc097          	auipc	ra,0xffffc
    8000483c:	676080e7          	jalr	1654(ra) # 80000eae <memmove>
    bwrite(to);  // write the log
    80004840:	8526                	mv	a0,s1
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	d6a080e7          	jalr	-662(ra) # 800035ac <bwrite>
    brelse(from);
    8000484a:	854e                	mv	a0,s3
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	d9e080e7          	jalr	-610(ra) # 800035ea <brelse>
    brelse(to);
    80004854:	8526                	mv	a0,s1
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	d94080e7          	jalr	-620(ra) # 800035ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000485e:	2905                	addiw	s2,s2,1
    80004860:	0a91                	addi	s5,s5,4
    80004862:	02ca2783          	lw	a5,44(s4)
    80004866:	f8f94ee3          	blt	s2,a5,80004802 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000486a:	00000097          	auipc	ra,0x0
    8000486e:	c8c080e7          	jalr	-884(ra) # 800044f6 <write_head>
    install_trans(0); // Now install writes to home locations
    80004872:	4501                	li	a0,0
    80004874:	00000097          	auipc	ra,0x0
    80004878:	cec080e7          	jalr	-788(ra) # 80004560 <install_trans>
    log.lh.n = 0;
    8000487c:	0003c797          	auipc	a5,0x3c
    80004880:	6c07ac23          	sw	zero,1752(a5) # 80040f54 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004884:	00000097          	auipc	ra,0x0
    80004888:	c72080e7          	jalr	-910(ra) # 800044f6 <write_head>
    8000488c:	69e2                	ld	s3,24(sp)
    8000488e:	6a42                	ld	s4,16(sp)
    80004890:	6aa2                	ld	s5,8(sp)
    80004892:	bdc5                	j	80004782 <end_op+0x4c>

0000000080004894 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004894:	1101                	addi	sp,sp,-32
    80004896:	ec06                	sd	ra,24(sp)
    80004898:	e822                	sd	s0,16(sp)
    8000489a:	e426                	sd	s1,8(sp)
    8000489c:	e04a                	sd	s2,0(sp)
    8000489e:	1000                	addi	s0,sp,32
    800048a0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048a2:	0003c917          	auipc	s2,0x3c
    800048a6:	68690913          	addi	s2,s2,1670 # 80040f28 <log>
    800048aa:	854a                	mv	a0,s2
    800048ac:	ffffc097          	auipc	ra,0xffffc
    800048b0:	4aa080e7          	jalr	1194(ra) # 80000d56 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048b4:	02c92603          	lw	a2,44(s2)
    800048b8:	47f5                	li	a5,29
    800048ba:	06c7c563          	blt	a5,a2,80004924 <log_write+0x90>
    800048be:	0003c797          	auipc	a5,0x3c
    800048c2:	6867a783          	lw	a5,1670(a5) # 80040f44 <log+0x1c>
    800048c6:	37fd                	addiw	a5,a5,-1
    800048c8:	04f65e63          	bge	a2,a5,80004924 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048cc:	0003c797          	auipc	a5,0x3c
    800048d0:	67c7a783          	lw	a5,1660(a5) # 80040f48 <log+0x20>
    800048d4:	06f05063          	blez	a5,80004934 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048d8:	4781                	li	a5,0
    800048da:	06c05563          	blez	a2,80004944 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048de:	44cc                	lw	a1,12(s1)
    800048e0:	0003c717          	auipc	a4,0x3c
    800048e4:	67870713          	addi	a4,a4,1656 # 80040f58 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048e8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048ea:	4314                	lw	a3,0(a4)
    800048ec:	04b68c63          	beq	a3,a1,80004944 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800048f0:	2785                	addiw	a5,a5,1
    800048f2:	0711                	addi	a4,a4,4
    800048f4:	fef61be3          	bne	a2,a5,800048ea <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048f8:	0621                	addi	a2,a2,8
    800048fa:	060a                	slli	a2,a2,0x2
    800048fc:	0003c797          	auipc	a5,0x3c
    80004900:	62c78793          	addi	a5,a5,1580 # 80040f28 <log>
    80004904:	97b2                	add	a5,a5,a2
    80004906:	44d8                	lw	a4,12(s1)
    80004908:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000490a:	8526                	mv	a0,s1
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	d7a080e7          	jalr	-646(ra) # 80003686 <bpin>
    log.lh.n++;
    80004914:	0003c717          	auipc	a4,0x3c
    80004918:	61470713          	addi	a4,a4,1556 # 80040f28 <log>
    8000491c:	575c                	lw	a5,44(a4)
    8000491e:	2785                	addiw	a5,a5,1
    80004920:	d75c                	sw	a5,44(a4)
    80004922:	a82d                	j	8000495c <log_write+0xc8>
    panic("too big a transaction");
    80004924:	00004517          	auipc	a0,0x4
    80004928:	c0c50513          	addi	a0,a0,-1012 # 80008530 <etext+0x530>
    8000492c:	ffffc097          	auipc	ra,0xffffc
    80004930:	c34080e7          	jalr	-972(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004934:	00004517          	auipc	a0,0x4
    80004938:	c1450513          	addi	a0,a0,-1004 # 80008548 <etext+0x548>
    8000493c:	ffffc097          	auipc	ra,0xffffc
    80004940:	c24080e7          	jalr	-988(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004944:	00878693          	addi	a3,a5,8
    80004948:	068a                	slli	a3,a3,0x2
    8000494a:	0003c717          	auipc	a4,0x3c
    8000494e:	5de70713          	addi	a4,a4,1502 # 80040f28 <log>
    80004952:	9736                	add	a4,a4,a3
    80004954:	44d4                	lw	a3,12(s1)
    80004956:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004958:	faf609e3          	beq	a2,a5,8000490a <log_write+0x76>
  }
  release(&log.lock);
    8000495c:	0003c517          	auipc	a0,0x3c
    80004960:	5cc50513          	addi	a0,a0,1484 # 80040f28 <log>
    80004964:	ffffc097          	auipc	ra,0xffffc
    80004968:	4a6080e7          	jalr	1190(ra) # 80000e0a <release>
}
    8000496c:	60e2                	ld	ra,24(sp)
    8000496e:	6442                	ld	s0,16(sp)
    80004970:	64a2                	ld	s1,8(sp)
    80004972:	6902                	ld	s2,0(sp)
    80004974:	6105                	addi	sp,sp,32
    80004976:	8082                	ret

0000000080004978 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004978:	1101                	addi	sp,sp,-32
    8000497a:	ec06                	sd	ra,24(sp)
    8000497c:	e822                	sd	s0,16(sp)
    8000497e:	e426                	sd	s1,8(sp)
    80004980:	e04a                	sd	s2,0(sp)
    80004982:	1000                	addi	s0,sp,32
    80004984:	84aa                	mv	s1,a0
    80004986:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004988:	00004597          	auipc	a1,0x4
    8000498c:	be058593          	addi	a1,a1,-1056 # 80008568 <etext+0x568>
    80004990:	0521                	addi	a0,a0,8
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	334080e7          	jalr	820(ra) # 80000cc6 <initlock>
  lk->name = name;
    8000499a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000499e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049a2:	0204a423          	sw	zero,40(s1)
}
    800049a6:	60e2                	ld	ra,24(sp)
    800049a8:	6442                	ld	s0,16(sp)
    800049aa:	64a2                	ld	s1,8(sp)
    800049ac:	6902                	ld	s2,0(sp)
    800049ae:	6105                	addi	sp,sp,32
    800049b0:	8082                	ret

00000000800049b2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049b2:	1101                	addi	sp,sp,-32
    800049b4:	ec06                	sd	ra,24(sp)
    800049b6:	e822                	sd	s0,16(sp)
    800049b8:	e426                	sd	s1,8(sp)
    800049ba:	e04a                	sd	s2,0(sp)
    800049bc:	1000                	addi	s0,sp,32
    800049be:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049c0:	00850913          	addi	s2,a0,8
    800049c4:	854a                	mv	a0,s2
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	390080e7          	jalr	912(ra) # 80000d56 <acquire>
  while (lk->locked) {
    800049ce:	409c                	lw	a5,0(s1)
    800049d0:	cb89                	beqz	a5,800049e2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049d2:	85ca                	mv	a1,s2
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	9ae080e7          	jalr	-1618(ra) # 80002384 <sleep>
  while (lk->locked) {
    800049de:	409c                	lw	a5,0(s1)
    800049e0:	fbed                	bnez	a5,800049d2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049e2:	4785                	li	a5,1
    800049e4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049e6:	ffffd097          	auipc	ra,0xffffd
    800049ea:	2e0080e7          	jalr	736(ra) # 80001cc6 <myproc>
    800049ee:	591c                	lw	a5,48(a0)
    800049f0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049f2:	854a                	mv	a0,s2
    800049f4:	ffffc097          	auipc	ra,0xffffc
    800049f8:	416080e7          	jalr	1046(ra) # 80000e0a <release>
}
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	64a2                	ld	s1,8(sp)
    80004a02:	6902                	ld	s2,0(sp)
    80004a04:	6105                	addi	sp,sp,32
    80004a06:	8082                	ret

0000000080004a08 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a08:	1101                	addi	sp,sp,-32
    80004a0a:	ec06                	sd	ra,24(sp)
    80004a0c:	e822                	sd	s0,16(sp)
    80004a0e:	e426                	sd	s1,8(sp)
    80004a10:	e04a                	sd	s2,0(sp)
    80004a12:	1000                	addi	s0,sp,32
    80004a14:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a16:	00850913          	addi	s2,a0,8
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	33a080e7          	jalr	826(ra) # 80000d56 <acquire>
  lk->locked = 0;
    80004a24:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a28:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	9ba080e7          	jalr	-1606(ra) # 800023e8 <wakeup>
  release(&lk->lk);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	3d2080e7          	jalr	978(ra) # 80000e0a <release>
}
    80004a40:	60e2                	ld	ra,24(sp)
    80004a42:	6442                	ld	s0,16(sp)
    80004a44:	64a2                	ld	s1,8(sp)
    80004a46:	6902                	ld	s2,0(sp)
    80004a48:	6105                	addi	sp,sp,32
    80004a4a:	8082                	ret

0000000080004a4c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a4c:	7179                	addi	sp,sp,-48
    80004a4e:	f406                	sd	ra,40(sp)
    80004a50:	f022                	sd	s0,32(sp)
    80004a52:	ec26                	sd	s1,24(sp)
    80004a54:	e84a                	sd	s2,16(sp)
    80004a56:	1800                	addi	s0,sp,48
    80004a58:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a5a:	00850913          	addi	s2,a0,8
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	2f6080e7          	jalr	758(ra) # 80000d56 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a68:	409c                	lw	a5,0(s1)
    80004a6a:	ef91                	bnez	a5,80004a86 <holdingsleep+0x3a>
    80004a6c:	4481                	li	s1,0
  release(&lk->lk);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ffffc097          	auipc	ra,0xffffc
    80004a74:	39a080e7          	jalr	922(ra) # 80000e0a <release>
  return r;
}
    80004a78:	8526                	mv	a0,s1
    80004a7a:	70a2                	ld	ra,40(sp)
    80004a7c:	7402                	ld	s0,32(sp)
    80004a7e:	64e2                	ld	s1,24(sp)
    80004a80:	6942                	ld	s2,16(sp)
    80004a82:	6145                	addi	sp,sp,48
    80004a84:	8082                	ret
    80004a86:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a88:	0284a983          	lw	s3,40(s1)
    80004a8c:	ffffd097          	auipc	ra,0xffffd
    80004a90:	23a080e7          	jalr	570(ra) # 80001cc6 <myproc>
    80004a94:	5904                	lw	s1,48(a0)
    80004a96:	413484b3          	sub	s1,s1,s3
    80004a9a:	0014b493          	seqz	s1,s1
    80004a9e:	69a2                	ld	s3,8(sp)
    80004aa0:	b7f9                	j	80004a6e <holdingsleep+0x22>

0000000080004aa2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004aa2:	1141                	addi	sp,sp,-16
    80004aa4:	e406                	sd	ra,8(sp)
    80004aa6:	e022                	sd	s0,0(sp)
    80004aa8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004aaa:	00004597          	auipc	a1,0x4
    80004aae:	ace58593          	addi	a1,a1,-1330 # 80008578 <etext+0x578>
    80004ab2:	0003c517          	auipc	a0,0x3c
    80004ab6:	5be50513          	addi	a0,a0,1470 # 80041070 <ftable>
    80004aba:	ffffc097          	auipc	ra,0xffffc
    80004abe:	20c080e7          	jalr	524(ra) # 80000cc6 <initlock>
}
    80004ac2:	60a2                	ld	ra,8(sp)
    80004ac4:	6402                	ld	s0,0(sp)
    80004ac6:	0141                	addi	sp,sp,16
    80004ac8:	8082                	ret

0000000080004aca <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004aca:	1101                	addi	sp,sp,-32
    80004acc:	ec06                	sd	ra,24(sp)
    80004ace:	e822                	sd	s0,16(sp)
    80004ad0:	e426                	sd	s1,8(sp)
    80004ad2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ad4:	0003c517          	auipc	a0,0x3c
    80004ad8:	59c50513          	addi	a0,a0,1436 # 80041070 <ftable>
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	27a080e7          	jalr	634(ra) # 80000d56 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ae4:	0003c497          	auipc	s1,0x3c
    80004ae8:	5a448493          	addi	s1,s1,1444 # 80041088 <ftable+0x18>
    80004aec:	0003d717          	auipc	a4,0x3d
    80004af0:	53c70713          	addi	a4,a4,1340 # 80042028 <disk>
    if(f->ref == 0){
    80004af4:	40dc                	lw	a5,4(s1)
    80004af6:	cf99                	beqz	a5,80004b14 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004af8:	02848493          	addi	s1,s1,40
    80004afc:	fee49ce3          	bne	s1,a4,80004af4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b00:	0003c517          	auipc	a0,0x3c
    80004b04:	57050513          	addi	a0,a0,1392 # 80041070 <ftable>
    80004b08:	ffffc097          	auipc	ra,0xffffc
    80004b0c:	302080e7          	jalr	770(ra) # 80000e0a <release>
  return 0;
    80004b10:	4481                	li	s1,0
    80004b12:	a819                	j	80004b28 <filealloc+0x5e>
      f->ref = 1;
    80004b14:	4785                	li	a5,1
    80004b16:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b18:	0003c517          	auipc	a0,0x3c
    80004b1c:	55850513          	addi	a0,a0,1368 # 80041070 <ftable>
    80004b20:	ffffc097          	auipc	ra,0xffffc
    80004b24:	2ea080e7          	jalr	746(ra) # 80000e0a <release>
}
    80004b28:	8526                	mv	a0,s1
    80004b2a:	60e2                	ld	ra,24(sp)
    80004b2c:	6442                	ld	s0,16(sp)
    80004b2e:	64a2                	ld	s1,8(sp)
    80004b30:	6105                	addi	sp,sp,32
    80004b32:	8082                	ret

0000000080004b34 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b34:	1101                	addi	sp,sp,-32
    80004b36:	ec06                	sd	ra,24(sp)
    80004b38:	e822                	sd	s0,16(sp)
    80004b3a:	e426                	sd	s1,8(sp)
    80004b3c:	1000                	addi	s0,sp,32
    80004b3e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b40:	0003c517          	auipc	a0,0x3c
    80004b44:	53050513          	addi	a0,a0,1328 # 80041070 <ftable>
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	20e080e7          	jalr	526(ra) # 80000d56 <acquire>
  if(f->ref < 1)
    80004b50:	40dc                	lw	a5,4(s1)
    80004b52:	02f05263          	blez	a5,80004b76 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b56:	2785                	addiw	a5,a5,1
    80004b58:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b5a:	0003c517          	auipc	a0,0x3c
    80004b5e:	51650513          	addi	a0,a0,1302 # 80041070 <ftable>
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	2a8080e7          	jalr	680(ra) # 80000e0a <release>
  return f;
}
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	60e2                	ld	ra,24(sp)
    80004b6e:	6442                	ld	s0,16(sp)
    80004b70:	64a2                	ld	s1,8(sp)
    80004b72:	6105                	addi	sp,sp,32
    80004b74:	8082                	ret
    panic("filedup");
    80004b76:	00004517          	auipc	a0,0x4
    80004b7a:	a0a50513          	addi	a0,a0,-1526 # 80008580 <etext+0x580>
    80004b7e:	ffffc097          	auipc	ra,0xffffc
    80004b82:	9e2080e7          	jalr	-1566(ra) # 80000560 <panic>

0000000080004b86 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b86:	7139                	addi	sp,sp,-64
    80004b88:	fc06                	sd	ra,56(sp)
    80004b8a:	f822                	sd	s0,48(sp)
    80004b8c:	f426                	sd	s1,40(sp)
    80004b8e:	0080                	addi	s0,sp,64
    80004b90:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b92:	0003c517          	auipc	a0,0x3c
    80004b96:	4de50513          	addi	a0,a0,1246 # 80041070 <ftable>
    80004b9a:	ffffc097          	auipc	ra,0xffffc
    80004b9e:	1bc080e7          	jalr	444(ra) # 80000d56 <acquire>
  if(f->ref < 1)
    80004ba2:	40dc                	lw	a5,4(s1)
    80004ba4:	04f05c63          	blez	a5,80004bfc <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004ba8:	37fd                	addiw	a5,a5,-1
    80004baa:	0007871b          	sext.w	a4,a5
    80004bae:	c0dc                	sw	a5,4(s1)
    80004bb0:	06e04263          	bgtz	a4,80004c14 <fileclose+0x8e>
    80004bb4:	f04a                	sd	s2,32(sp)
    80004bb6:	ec4e                	sd	s3,24(sp)
    80004bb8:	e852                	sd	s4,16(sp)
    80004bba:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004bbc:	0004a903          	lw	s2,0(s1)
    80004bc0:	0094ca83          	lbu	s5,9(s1)
    80004bc4:	0104ba03          	ld	s4,16(s1)
    80004bc8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004bcc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bd0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bd4:	0003c517          	auipc	a0,0x3c
    80004bd8:	49c50513          	addi	a0,a0,1180 # 80041070 <ftable>
    80004bdc:	ffffc097          	auipc	ra,0xffffc
    80004be0:	22e080e7          	jalr	558(ra) # 80000e0a <release>

  if(ff.type == FD_PIPE){
    80004be4:	4785                	li	a5,1
    80004be6:	04f90463          	beq	s2,a5,80004c2e <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bea:	3979                	addiw	s2,s2,-2
    80004bec:	4785                	li	a5,1
    80004bee:	0527fb63          	bgeu	a5,s2,80004c44 <fileclose+0xbe>
    80004bf2:	7902                	ld	s2,32(sp)
    80004bf4:	69e2                	ld	s3,24(sp)
    80004bf6:	6a42                	ld	s4,16(sp)
    80004bf8:	6aa2                	ld	s5,8(sp)
    80004bfa:	a02d                	j	80004c24 <fileclose+0x9e>
    80004bfc:	f04a                	sd	s2,32(sp)
    80004bfe:	ec4e                	sd	s3,24(sp)
    80004c00:	e852                	sd	s4,16(sp)
    80004c02:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	98450513          	addi	a0,a0,-1660 # 80008588 <etext+0x588>
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	954080e7          	jalr	-1708(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004c14:	0003c517          	auipc	a0,0x3c
    80004c18:	45c50513          	addi	a0,a0,1116 # 80041070 <ftable>
    80004c1c:	ffffc097          	auipc	ra,0xffffc
    80004c20:	1ee080e7          	jalr	494(ra) # 80000e0a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c24:	70e2                	ld	ra,56(sp)
    80004c26:	7442                	ld	s0,48(sp)
    80004c28:	74a2                	ld	s1,40(sp)
    80004c2a:	6121                	addi	sp,sp,64
    80004c2c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c2e:	85d6                	mv	a1,s5
    80004c30:	8552                	mv	a0,s4
    80004c32:	00000097          	auipc	ra,0x0
    80004c36:	3a2080e7          	jalr	930(ra) # 80004fd4 <pipeclose>
    80004c3a:	7902                	ld	s2,32(sp)
    80004c3c:	69e2                	ld	s3,24(sp)
    80004c3e:	6a42                	ld	s4,16(sp)
    80004c40:	6aa2                	ld	s5,8(sp)
    80004c42:	b7cd                	j	80004c24 <fileclose+0x9e>
    begin_op();
    80004c44:	00000097          	auipc	ra,0x0
    80004c48:	a78080e7          	jalr	-1416(ra) # 800046bc <begin_op>
    iput(ff.ip);
    80004c4c:	854e                	mv	a0,s3
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	25e080e7          	jalr	606(ra) # 80003eac <iput>
    end_op();
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	ae0080e7          	jalr	-1312(ra) # 80004736 <end_op>
    80004c5e:	7902                	ld	s2,32(sp)
    80004c60:	69e2                	ld	s3,24(sp)
    80004c62:	6a42                	ld	s4,16(sp)
    80004c64:	6aa2                	ld	s5,8(sp)
    80004c66:	bf7d                	j	80004c24 <fileclose+0x9e>

0000000080004c68 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c68:	715d                	addi	sp,sp,-80
    80004c6a:	e486                	sd	ra,72(sp)
    80004c6c:	e0a2                	sd	s0,64(sp)
    80004c6e:	fc26                	sd	s1,56(sp)
    80004c70:	f44e                	sd	s3,40(sp)
    80004c72:	0880                	addi	s0,sp,80
    80004c74:	84aa                	mv	s1,a0
    80004c76:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	04e080e7          	jalr	78(ra) # 80001cc6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c80:	409c                	lw	a5,0(s1)
    80004c82:	37f9                	addiw	a5,a5,-2
    80004c84:	4705                	li	a4,1
    80004c86:	04f76863          	bltu	a4,a5,80004cd6 <filestat+0x6e>
    80004c8a:	f84a                	sd	s2,48(sp)
    80004c8c:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c8e:	6c88                	ld	a0,24(s1)
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	05e080e7          	jalr	94(ra) # 80003cee <ilock>
    stati(f->ip, &st);
    80004c98:	fb840593          	addi	a1,s0,-72
    80004c9c:	6c88                	ld	a0,24(s1)
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	2de080e7          	jalr	734(ra) # 80003f7c <stati>
    iunlock(f->ip);
    80004ca6:	6c88                	ld	a0,24(s1)
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	10c080e7          	jalr	268(ra) # 80003db4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004cb0:	46e1                	li	a3,24
    80004cb2:	fb840613          	addi	a2,s0,-72
    80004cb6:	85ce                	mv	a1,s3
    80004cb8:	05093503          	ld	a0,80(s2)
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	b86080e7          	jalr	-1146(ra) # 80001842 <copyout>
    80004cc4:	41f5551b          	sraiw	a0,a0,0x1f
    80004cc8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004cca:	60a6                	ld	ra,72(sp)
    80004ccc:	6406                	ld	s0,64(sp)
    80004cce:	74e2                	ld	s1,56(sp)
    80004cd0:	79a2                	ld	s3,40(sp)
    80004cd2:	6161                	addi	sp,sp,80
    80004cd4:	8082                	ret
  return -1;
    80004cd6:	557d                	li	a0,-1
    80004cd8:	bfcd                	j	80004cca <filestat+0x62>

0000000080004cda <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004cda:	7179                	addi	sp,sp,-48
    80004cdc:	f406                	sd	ra,40(sp)
    80004cde:	f022                	sd	s0,32(sp)
    80004ce0:	e84a                	sd	s2,16(sp)
    80004ce2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ce4:	00854783          	lbu	a5,8(a0)
    80004ce8:	cbc5                	beqz	a5,80004d98 <fileread+0xbe>
    80004cea:	ec26                	sd	s1,24(sp)
    80004cec:	e44e                	sd	s3,8(sp)
    80004cee:	84aa                	mv	s1,a0
    80004cf0:	89ae                	mv	s3,a1
    80004cf2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cf4:	411c                	lw	a5,0(a0)
    80004cf6:	4705                	li	a4,1
    80004cf8:	04e78963          	beq	a5,a4,80004d4a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cfc:	470d                	li	a4,3
    80004cfe:	04e78f63          	beq	a5,a4,80004d5c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d02:	4709                	li	a4,2
    80004d04:	08e79263          	bne	a5,a4,80004d88 <fileread+0xae>
    ilock(f->ip);
    80004d08:	6d08                	ld	a0,24(a0)
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	fe4080e7          	jalr	-28(ra) # 80003cee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d12:	874a                	mv	a4,s2
    80004d14:	5094                	lw	a3,32(s1)
    80004d16:	864e                	mv	a2,s3
    80004d18:	4585                	li	a1,1
    80004d1a:	6c88                	ld	a0,24(s1)
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	28a080e7          	jalr	650(ra) # 80003fa6 <readi>
    80004d24:	892a                	mv	s2,a0
    80004d26:	00a05563          	blez	a0,80004d30 <fileread+0x56>
      f->off += r;
    80004d2a:	509c                	lw	a5,32(s1)
    80004d2c:	9fa9                	addw	a5,a5,a0
    80004d2e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d30:	6c88                	ld	a0,24(s1)
    80004d32:	fffff097          	auipc	ra,0xfffff
    80004d36:	082080e7          	jalr	130(ra) # 80003db4 <iunlock>
    80004d3a:	64e2                	ld	s1,24(sp)
    80004d3c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d3e:	854a                	mv	a0,s2
    80004d40:	70a2                	ld	ra,40(sp)
    80004d42:	7402                	ld	s0,32(sp)
    80004d44:	6942                	ld	s2,16(sp)
    80004d46:	6145                	addi	sp,sp,48
    80004d48:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d4a:	6908                	ld	a0,16(a0)
    80004d4c:	00000097          	auipc	ra,0x0
    80004d50:	400080e7          	jalr	1024(ra) # 8000514c <piperead>
    80004d54:	892a                	mv	s2,a0
    80004d56:	64e2                	ld	s1,24(sp)
    80004d58:	69a2                	ld	s3,8(sp)
    80004d5a:	b7d5                	j	80004d3e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d5c:	02451783          	lh	a5,36(a0)
    80004d60:	03079693          	slli	a3,a5,0x30
    80004d64:	92c1                	srli	a3,a3,0x30
    80004d66:	4725                	li	a4,9
    80004d68:	02d76a63          	bltu	a4,a3,80004d9c <fileread+0xc2>
    80004d6c:	0792                	slli	a5,a5,0x4
    80004d6e:	0003c717          	auipc	a4,0x3c
    80004d72:	26270713          	addi	a4,a4,610 # 80040fd0 <devsw>
    80004d76:	97ba                	add	a5,a5,a4
    80004d78:	639c                	ld	a5,0(a5)
    80004d7a:	c78d                	beqz	a5,80004da4 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004d7c:	4505                	li	a0,1
    80004d7e:	9782                	jalr	a5
    80004d80:	892a                	mv	s2,a0
    80004d82:	64e2                	ld	s1,24(sp)
    80004d84:	69a2                	ld	s3,8(sp)
    80004d86:	bf65                	j	80004d3e <fileread+0x64>
    panic("fileread");
    80004d88:	00004517          	auipc	a0,0x4
    80004d8c:	81050513          	addi	a0,a0,-2032 # 80008598 <etext+0x598>
    80004d90:	ffffb097          	auipc	ra,0xffffb
    80004d94:	7d0080e7          	jalr	2000(ra) # 80000560 <panic>
    return -1;
    80004d98:	597d                	li	s2,-1
    80004d9a:	b755                	j	80004d3e <fileread+0x64>
      return -1;
    80004d9c:	597d                	li	s2,-1
    80004d9e:	64e2                	ld	s1,24(sp)
    80004da0:	69a2                	ld	s3,8(sp)
    80004da2:	bf71                	j	80004d3e <fileread+0x64>
    80004da4:	597d                	li	s2,-1
    80004da6:	64e2                	ld	s1,24(sp)
    80004da8:	69a2                	ld	s3,8(sp)
    80004daa:	bf51                	j	80004d3e <fileread+0x64>

0000000080004dac <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004dac:	00954783          	lbu	a5,9(a0)
    80004db0:	12078963          	beqz	a5,80004ee2 <filewrite+0x136>
{
    80004db4:	715d                	addi	sp,sp,-80
    80004db6:	e486                	sd	ra,72(sp)
    80004db8:	e0a2                	sd	s0,64(sp)
    80004dba:	f84a                	sd	s2,48(sp)
    80004dbc:	f052                	sd	s4,32(sp)
    80004dbe:	e85a                	sd	s6,16(sp)
    80004dc0:	0880                	addi	s0,sp,80
    80004dc2:	892a                	mv	s2,a0
    80004dc4:	8b2e                	mv	s6,a1
    80004dc6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004dc8:	411c                	lw	a5,0(a0)
    80004dca:	4705                	li	a4,1
    80004dcc:	02e78763          	beq	a5,a4,80004dfa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004dd0:	470d                	li	a4,3
    80004dd2:	02e78a63          	beq	a5,a4,80004e06 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dd6:	4709                	li	a4,2
    80004dd8:	0ee79863          	bne	a5,a4,80004ec8 <filewrite+0x11c>
    80004ddc:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004dde:	0cc05463          	blez	a2,80004ea6 <filewrite+0xfa>
    80004de2:	fc26                	sd	s1,56(sp)
    80004de4:	ec56                	sd	s5,24(sp)
    80004de6:	e45e                	sd	s7,8(sp)
    80004de8:	e062                	sd	s8,0(sp)
    int i = 0;
    80004dea:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004dec:	6b85                	lui	s7,0x1
    80004dee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004df2:	6c05                	lui	s8,0x1
    80004df4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004df8:	a851                	j	80004e8c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004dfa:	6908                	ld	a0,16(a0)
    80004dfc:	00000097          	auipc	ra,0x0
    80004e00:	248080e7          	jalr	584(ra) # 80005044 <pipewrite>
    80004e04:	a85d                	j	80004eba <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e06:	02451783          	lh	a5,36(a0)
    80004e0a:	03079693          	slli	a3,a5,0x30
    80004e0e:	92c1                	srli	a3,a3,0x30
    80004e10:	4725                	li	a4,9
    80004e12:	0cd76a63          	bltu	a4,a3,80004ee6 <filewrite+0x13a>
    80004e16:	0792                	slli	a5,a5,0x4
    80004e18:	0003c717          	auipc	a4,0x3c
    80004e1c:	1b870713          	addi	a4,a4,440 # 80040fd0 <devsw>
    80004e20:	97ba                	add	a5,a5,a4
    80004e22:	679c                	ld	a5,8(a5)
    80004e24:	c3f9                	beqz	a5,80004eea <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004e26:	4505                	li	a0,1
    80004e28:	9782                	jalr	a5
    80004e2a:	a841                	j	80004eba <filewrite+0x10e>
      if(n1 > max)
    80004e2c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004e30:	00000097          	auipc	ra,0x0
    80004e34:	88c080e7          	jalr	-1908(ra) # 800046bc <begin_op>
      ilock(f->ip);
    80004e38:	01893503          	ld	a0,24(s2)
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	eb2080e7          	jalr	-334(ra) # 80003cee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e44:	8756                	mv	a4,s5
    80004e46:	02092683          	lw	a3,32(s2)
    80004e4a:	01698633          	add	a2,s3,s6
    80004e4e:	4585                	li	a1,1
    80004e50:	01893503          	ld	a0,24(s2)
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	262080e7          	jalr	610(ra) # 800040b6 <writei>
    80004e5c:	84aa                	mv	s1,a0
    80004e5e:	00a05763          	blez	a0,80004e6c <filewrite+0xc0>
        f->off += r;
    80004e62:	02092783          	lw	a5,32(s2)
    80004e66:	9fa9                	addw	a5,a5,a0
    80004e68:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e6c:	01893503          	ld	a0,24(s2)
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	f44080e7          	jalr	-188(ra) # 80003db4 <iunlock>
      end_op();
    80004e78:	00000097          	auipc	ra,0x0
    80004e7c:	8be080e7          	jalr	-1858(ra) # 80004736 <end_op>

      if(r != n1){
    80004e80:	029a9563          	bne	s5,s1,80004eaa <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004e84:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e88:	0149da63          	bge	s3,s4,80004e9c <filewrite+0xf0>
      int n1 = n - i;
    80004e8c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004e90:	0004879b          	sext.w	a5,s1
    80004e94:	f8fbdce3          	bge	s7,a5,80004e2c <filewrite+0x80>
    80004e98:	84e2                	mv	s1,s8
    80004e9a:	bf49                	j	80004e2c <filewrite+0x80>
    80004e9c:	74e2                	ld	s1,56(sp)
    80004e9e:	6ae2                	ld	s5,24(sp)
    80004ea0:	6ba2                	ld	s7,8(sp)
    80004ea2:	6c02                	ld	s8,0(sp)
    80004ea4:	a039                	j	80004eb2 <filewrite+0x106>
    int i = 0;
    80004ea6:	4981                	li	s3,0
    80004ea8:	a029                	j	80004eb2 <filewrite+0x106>
    80004eaa:	74e2                	ld	s1,56(sp)
    80004eac:	6ae2                	ld	s5,24(sp)
    80004eae:	6ba2                	ld	s7,8(sp)
    80004eb0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004eb2:	033a1e63          	bne	s4,s3,80004eee <filewrite+0x142>
    80004eb6:	8552                	mv	a0,s4
    80004eb8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004eba:	60a6                	ld	ra,72(sp)
    80004ebc:	6406                	ld	s0,64(sp)
    80004ebe:	7942                	ld	s2,48(sp)
    80004ec0:	7a02                	ld	s4,32(sp)
    80004ec2:	6b42                	ld	s6,16(sp)
    80004ec4:	6161                	addi	sp,sp,80
    80004ec6:	8082                	ret
    80004ec8:	fc26                	sd	s1,56(sp)
    80004eca:	f44e                	sd	s3,40(sp)
    80004ecc:	ec56                	sd	s5,24(sp)
    80004ece:	e45e                	sd	s7,8(sp)
    80004ed0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004ed2:	00003517          	auipc	a0,0x3
    80004ed6:	6d650513          	addi	a0,a0,1750 # 800085a8 <etext+0x5a8>
    80004eda:	ffffb097          	auipc	ra,0xffffb
    80004ede:	686080e7          	jalr	1670(ra) # 80000560 <panic>
    return -1;
    80004ee2:	557d                	li	a0,-1
}
    80004ee4:	8082                	ret
      return -1;
    80004ee6:	557d                	li	a0,-1
    80004ee8:	bfc9                	j	80004eba <filewrite+0x10e>
    80004eea:	557d                	li	a0,-1
    80004eec:	b7f9                	j	80004eba <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004eee:	557d                	li	a0,-1
    80004ef0:	79a2                	ld	s3,40(sp)
    80004ef2:	b7e1                	j	80004eba <filewrite+0x10e>

0000000080004ef4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004ef4:	7179                	addi	sp,sp,-48
    80004ef6:	f406                	sd	ra,40(sp)
    80004ef8:	f022                	sd	s0,32(sp)
    80004efa:	ec26                	sd	s1,24(sp)
    80004efc:	e052                	sd	s4,0(sp)
    80004efe:	1800                	addi	s0,sp,48
    80004f00:	84aa                	mv	s1,a0
    80004f02:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f04:	0005b023          	sd	zero,0(a1)
    80004f08:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f0c:	00000097          	auipc	ra,0x0
    80004f10:	bbe080e7          	jalr	-1090(ra) # 80004aca <filealloc>
    80004f14:	e088                	sd	a0,0(s1)
    80004f16:	cd49                	beqz	a0,80004fb0 <pipealloc+0xbc>
    80004f18:	00000097          	auipc	ra,0x0
    80004f1c:	bb2080e7          	jalr	-1102(ra) # 80004aca <filealloc>
    80004f20:	00aa3023          	sd	a0,0(s4)
    80004f24:	c141                	beqz	a0,80004fa4 <pipealloc+0xb0>
    80004f26:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	d00080e7          	jalr	-768(ra) # 80000c28 <kalloc>
    80004f30:	892a                	mv	s2,a0
    80004f32:	c13d                	beqz	a0,80004f98 <pipealloc+0xa4>
    80004f34:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f36:	4985                	li	s3,1
    80004f38:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f3c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f40:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f44:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f48:	00003597          	auipc	a1,0x3
    80004f4c:	67058593          	addi	a1,a1,1648 # 800085b8 <etext+0x5b8>
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	d76080e7          	jalr	-650(ra) # 80000cc6 <initlock>
  (*f0)->type = FD_PIPE;
    80004f58:	609c                	ld	a5,0(s1)
    80004f5a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f5e:	609c                	ld	a5,0(s1)
    80004f60:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f64:	609c                	ld	a5,0(s1)
    80004f66:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f6a:	609c                	ld	a5,0(s1)
    80004f6c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f70:	000a3783          	ld	a5,0(s4)
    80004f74:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f78:	000a3783          	ld	a5,0(s4)
    80004f7c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f80:	000a3783          	ld	a5,0(s4)
    80004f84:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f88:	000a3783          	ld	a5,0(s4)
    80004f8c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f90:	4501                	li	a0,0
    80004f92:	6942                	ld	s2,16(sp)
    80004f94:	69a2                	ld	s3,8(sp)
    80004f96:	a03d                	j	80004fc4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f98:	6088                	ld	a0,0(s1)
    80004f9a:	c119                	beqz	a0,80004fa0 <pipealloc+0xac>
    80004f9c:	6942                	ld	s2,16(sp)
    80004f9e:	a029                	j	80004fa8 <pipealloc+0xb4>
    80004fa0:	6942                	ld	s2,16(sp)
    80004fa2:	a039                	j	80004fb0 <pipealloc+0xbc>
    80004fa4:	6088                	ld	a0,0(s1)
    80004fa6:	c50d                	beqz	a0,80004fd0 <pipealloc+0xdc>
    fileclose(*f0);
    80004fa8:	00000097          	auipc	ra,0x0
    80004fac:	bde080e7          	jalr	-1058(ra) # 80004b86 <fileclose>
  if(*f1)
    80004fb0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fb4:	557d                	li	a0,-1
  if(*f1)
    80004fb6:	c799                	beqz	a5,80004fc4 <pipealloc+0xd0>
    fileclose(*f1);
    80004fb8:	853e                	mv	a0,a5
    80004fba:	00000097          	auipc	ra,0x0
    80004fbe:	bcc080e7          	jalr	-1076(ra) # 80004b86 <fileclose>
  return -1;
    80004fc2:	557d                	li	a0,-1
}
    80004fc4:	70a2                	ld	ra,40(sp)
    80004fc6:	7402                	ld	s0,32(sp)
    80004fc8:	64e2                	ld	s1,24(sp)
    80004fca:	6a02                	ld	s4,0(sp)
    80004fcc:	6145                	addi	sp,sp,48
    80004fce:	8082                	ret
  return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	bfcd                	j	80004fc4 <pipealloc+0xd0>

0000000080004fd4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004fd4:	1101                	addi	sp,sp,-32
    80004fd6:	ec06                	sd	ra,24(sp)
    80004fd8:	e822                	sd	s0,16(sp)
    80004fda:	e426                	sd	s1,8(sp)
    80004fdc:	e04a                	sd	s2,0(sp)
    80004fde:	1000                	addi	s0,sp,32
    80004fe0:	84aa                	mv	s1,a0
    80004fe2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004fe4:	ffffc097          	auipc	ra,0xffffc
    80004fe8:	d72080e7          	jalr	-654(ra) # 80000d56 <acquire>
  if(writable){
    80004fec:	02090d63          	beqz	s2,80005026 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ff0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ff4:	21848513          	addi	a0,s1,536
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	3f0080e7          	jalr	1008(ra) # 800023e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005000:	2204b783          	ld	a5,544(s1)
    80005004:	eb95                	bnez	a5,80005038 <pipeclose+0x64>
    release(&pi->lock);
    80005006:	8526                	mv	a0,s1
    80005008:	ffffc097          	auipc	ra,0xffffc
    8000500c:	e02080e7          	jalr	-510(ra) # 80000e0a <release>
    kfree((char*)pi);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	a38080e7          	jalr	-1480(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    8000501a:	60e2                	ld	ra,24(sp)
    8000501c:	6442                	ld	s0,16(sp)
    8000501e:	64a2                	ld	s1,8(sp)
    80005020:	6902                	ld	s2,0(sp)
    80005022:	6105                	addi	sp,sp,32
    80005024:	8082                	ret
    pi->readopen = 0;
    80005026:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000502a:	21c48513          	addi	a0,s1,540
    8000502e:	ffffd097          	auipc	ra,0xffffd
    80005032:	3ba080e7          	jalr	954(ra) # 800023e8 <wakeup>
    80005036:	b7e9                	j	80005000 <pipeclose+0x2c>
    release(&pi->lock);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffc097          	auipc	ra,0xffffc
    8000503e:	dd0080e7          	jalr	-560(ra) # 80000e0a <release>
}
    80005042:	bfe1                	j	8000501a <pipeclose+0x46>

0000000080005044 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005044:	711d                	addi	sp,sp,-96
    80005046:	ec86                	sd	ra,88(sp)
    80005048:	e8a2                	sd	s0,80(sp)
    8000504a:	e4a6                	sd	s1,72(sp)
    8000504c:	e0ca                	sd	s2,64(sp)
    8000504e:	fc4e                	sd	s3,56(sp)
    80005050:	f852                	sd	s4,48(sp)
    80005052:	f456                	sd	s5,40(sp)
    80005054:	1080                	addi	s0,sp,96
    80005056:	84aa                	mv	s1,a0
    80005058:	8aae                	mv	s5,a1
    8000505a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000505c:	ffffd097          	auipc	ra,0xffffd
    80005060:	c6a080e7          	jalr	-918(ra) # 80001cc6 <myproc>
    80005064:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005066:	8526                	mv	a0,s1
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	cee080e7          	jalr	-786(ra) # 80000d56 <acquire>
  while(i < n){
    80005070:	0d405863          	blez	s4,80005140 <pipewrite+0xfc>
    80005074:	f05a                	sd	s6,32(sp)
    80005076:	ec5e                	sd	s7,24(sp)
    80005078:	e862                	sd	s8,16(sp)
  int i = 0;
    8000507a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000507c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000507e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005082:	21c48b93          	addi	s7,s1,540
    80005086:	a089                	j	800050c8 <pipewrite+0x84>
      release(&pi->lock);
    80005088:	8526                	mv	a0,s1
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	d80080e7          	jalr	-640(ra) # 80000e0a <release>
      return -1;
    80005092:	597d                	li	s2,-1
    80005094:	7b02                	ld	s6,32(sp)
    80005096:	6be2                	ld	s7,24(sp)
    80005098:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000509a:	854a                	mv	a0,s2
    8000509c:	60e6                	ld	ra,88(sp)
    8000509e:	6446                	ld	s0,80(sp)
    800050a0:	64a6                	ld	s1,72(sp)
    800050a2:	6906                	ld	s2,64(sp)
    800050a4:	79e2                	ld	s3,56(sp)
    800050a6:	7a42                	ld	s4,48(sp)
    800050a8:	7aa2                	ld	s5,40(sp)
    800050aa:	6125                	addi	sp,sp,96
    800050ac:	8082                	ret
      wakeup(&pi->nread);
    800050ae:	8562                	mv	a0,s8
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	338080e7          	jalr	824(ra) # 800023e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050b8:	85a6                	mv	a1,s1
    800050ba:	855e                	mv	a0,s7
    800050bc:	ffffd097          	auipc	ra,0xffffd
    800050c0:	2c8080e7          	jalr	712(ra) # 80002384 <sleep>
  while(i < n){
    800050c4:	05495f63          	bge	s2,s4,80005122 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800050c8:	2204a783          	lw	a5,544(s1)
    800050cc:	dfd5                	beqz	a5,80005088 <pipewrite+0x44>
    800050ce:	854e                	mv	a0,s3
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	568080e7          	jalr	1384(ra) # 80002638 <killed>
    800050d8:	f945                	bnez	a0,80005088 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050da:	2184a783          	lw	a5,536(s1)
    800050de:	21c4a703          	lw	a4,540(s1)
    800050e2:	2007879b          	addiw	a5,a5,512
    800050e6:	fcf704e3          	beq	a4,a5,800050ae <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050ea:	4685                	li	a3,1
    800050ec:	01590633          	add	a2,s2,s5
    800050f0:	faf40593          	addi	a1,s0,-81
    800050f4:	0509b503          	ld	a0,80(s3)
    800050f8:	ffffd097          	auipc	ra,0xffffd
    800050fc:	8f2080e7          	jalr	-1806(ra) # 800019ea <copyin>
    80005100:	05650263          	beq	a0,s6,80005144 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005104:	21c4a783          	lw	a5,540(s1)
    80005108:	0017871b          	addiw	a4,a5,1
    8000510c:	20e4ae23          	sw	a4,540(s1)
    80005110:	1ff7f793          	andi	a5,a5,511
    80005114:	97a6                	add	a5,a5,s1
    80005116:	faf44703          	lbu	a4,-81(s0)
    8000511a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000511e:	2905                	addiw	s2,s2,1
    80005120:	b755                	j	800050c4 <pipewrite+0x80>
    80005122:	7b02                	ld	s6,32(sp)
    80005124:	6be2                	ld	s7,24(sp)
    80005126:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005128:	21848513          	addi	a0,s1,536
    8000512c:	ffffd097          	auipc	ra,0xffffd
    80005130:	2bc080e7          	jalr	700(ra) # 800023e8 <wakeup>
  release(&pi->lock);
    80005134:	8526                	mv	a0,s1
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	cd4080e7          	jalr	-812(ra) # 80000e0a <release>
  return i;
    8000513e:	bfb1                	j	8000509a <pipewrite+0x56>
  int i = 0;
    80005140:	4901                	li	s2,0
    80005142:	b7dd                	j	80005128 <pipewrite+0xe4>
    80005144:	7b02                	ld	s6,32(sp)
    80005146:	6be2                	ld	s7,24(sp)
    80005148:	6c42                	ld	s8,16(sp)
    8000514a:	bff9                	j	80005128 <pipewrite+0xe4>

000000008000514c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000514c:	715d                	addi	sp,sp,-80
    8000514e:	e486                	sd	ra,72(sp)
    80005150:	e0a2                	sd	s0,64(sp)
    80005152:	fc26                	sd	s1,56(sp)
    80005154:	f84a                	sd	s2,48(sp)
    80005156:	f44e                	sd	s3,40(sp)
    80005158:	f052                	sd	s4,32(sp)
    8000515a:	ec56                	sd	s5,24(sp)
    8000515c:	0880                	addi	s0,sp,80
    8000515e:	84aa                	mv	s1,a0
    80005160:	892e                	mv	s2,a1
    80005162:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005164:	ffffd097          	auipc	ra,0xffffd
    80005168:	b62080e7          	jalr	-1182(ra) # 80001cc6 <myproc>
    8000516c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000516e:	8526                	mv	a0,s1
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	be6080e7          	jalr	-1050(ra) # 80000d56 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005178:	2184a703          	lw	a4,536(s1)
    8000517c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005180:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005184:	02f71963          	bne	a4,a5,800051b6 <piperead+0x6a>
    80005188:	2244a783          	lw	a5,548(s1)
    8000518c:	cf95                	beqz	a5,800051c8 <piperead+0x7c>
    if(killed(pr)){
    8000518e:	8552                	mv	a0,s4
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	4a8080e7          	jalr	1192(ra) # 80002638 <killed>
    80005198:	e10d                	bnez	a0,800051ba <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000519a:	85a6                	mv	a1,s1
    8000519c:	854e                	mv	a0,s3
    8000519e:	ffffd097          	auipc	ra,0xffffd
    800051a2:	1e6080e7          	jalr	486(ra) # 80002384 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051a6:	2184a703          	lw	a4,536(s1)
    800051aa:	21c4a783          	lw	a5,540(s1)
    800051ae:	fcf70de3          	beq	a4,a5,80005188 <piperead+0x3c>
    800051b2:	e85a                	sd	s6,16(sp)
    800051b4:	a819                	j	800051ca <piperead+0x7e>
    800051b6:	e85a                	sd	s6,16(sp)
    800051b8:	a809                	j	800051ca <piperead+0x7e>
      release(&pi->lock);
    800051ba:	8526                	mv	a0,s1
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	c4e080e7          	jalr	-946(ra) # 80000e0a <release>
      return -1;
    800051c4:	59fd                	li	s3,-1
    800051c6:	a0a5                	j	8000522e <piperead+0xe2>
    800051c8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051ca:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051cc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051ce:	05505463          	blez	s5,80005216 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800051d2:	2184a783          	lw	a5,536(s1)
    800051d6:	21c4a703          	lw	a4,540(s1)
    800051da:	02f70e63          	beq	a4,a5,80005216 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051de:	0017871b          	addiw	a4,a5,1
    800051e2:	20e4ac23          	sw	a4,536(s1)
    800051e6:	1ff7f793          	andi	a5,a5,511
    800051ea:	97a6                	add	a5,a5,s1
    800051ec:	0187c783          	lbu	a5,24(a5)
    800051f0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051f4:	4685                	li	a3,1
    800051f6:	fbf40613          	addi	a2,s0,-65
    800051fa:	85ca                	mv	a1,s2
    800051fc:	050a3503          	ld	a0,80(s4)
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	642080e7          	jalr	1602(ra) # 80001842 <copyout>
    80005208:	01650763          	beq	a0,s6,80005216 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000520c:	2985                	addiw	s3,s3,1
    8000520e:	0905                	addi	s2,s2,1
    80005210:	fd3a91e3          	bne	s5,s3,800051d2 <piperead+0x86>
    80005214:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005216:	21c48513          	addi	a0,s1,540
    8000521a:	ffffd097          	auipc	ra,0xffffd
    8000521e:	1ce080e7          	jalr	462(ra) # 800023e8 <wakeup>
  release(&pi->lock);
    80005222:	8526                	mv	a0,s1
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	be6080e7          	jalr	-1050(ra) # 80000e0a <release>
    8000522c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000522e:	854e                	mv	a0,s3
    80005230:	60a6                	ld	ra,72(sp)
    80005232:	6406                	ld	s0,64(sp)
    80005234:	74e2                	ld	s1,56(sp)
    80005236:	7942                	ld	s2,48(sp)
    80005238:	79a2                	ld	s3,40(sp)
    8000523a:	7a02                	ld	s4,32(sp)
    8000523c:	6ae2                	ld	s5,24(sp)
    8000523e:	6161                	addi	sp,sp,80
    80005240:	8082                	ret

0000000080005242 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005242:	1141                	addi	sp,sp,-16
    80005244:	e422                	sd	s0,8(sp)
    80005246:	0800                	addi	s0,sp,16
    80005248:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000524a:	8905                	andi	a0,a0,1
    8000524c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000524e:	8b89                	andi	a5,a5,2
    80005250:	c399                	beqz	a5,80005256 <flags2perm+0x14>
      perm |= PTE_W;
    80005252:	00456513          	ori	a0,a0,4
    return perm;
}
    80005256:	6422                	ld	s0,8(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret

000000008000525c <exec>:

int
exec(char *path, char **argv)
{
    8000525c:	df010113          	addi	sp,sp,-528
    80005260:	20113423          	sd	ra,520(sp)
    80005264:	20813023          	sd	s0,512(sp)
    80005268:	ffa6                	sd	s1,504(sp)
    8000526a:	fbca                	sd	s2,496(sp)
    8000526c:	0c00                	addi	s0,sp,528
    8000526e:	892a                	mv	s2,a0
    80005270:	dea43c23          	sd	a0,-520(s0)
    80005274:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005278:	ffffd097          	auipc	ra,0xffffd
    8000527c:	a4e080e7          	jalr	-1458(ra) # 80001cc6 <myproc>
    80005280:	84aa                	mv	s1,a0

  begin_op();
    80005282:	fffff097          	auipc	ra,0xfffff
    80005286:	43a080e7          	jalr	1082(ra) # 800046bc <begin_op>

  if((ip = namei(path)) == 0){
    8000528a:	854a                	mv	a0,s2
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	230080e7          	jalr	560(ra) # 800044bc <namei>
    80005294:	c135                	beqz	a0,800052f8 <exec+0x9c>
    80005296:	f3d2                	sd	s4,480(sp)
    80005298:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	a54080e7          	jalr	-1452(ra) # 80003cee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052a2:	04000713          	li	a4,64
    800052a6:	4681                	li	a3,0
    800052a8:	e5040613          	addi	a2,s0,-432
    800052ac:	4581                	li	a1,0
    800052ae:	8552                	mv	a0,s4
    800052b0:	fffff097          	auipc	ra,0xfffff
    800052b4:	cf6080e7          	jalr	-778(ra) # 80003fa6 <readi>
    800052b8:	04000793          	li	a5,64
    800052bc:	00f51a63          	bne	a0,a5,800052d0 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052c0:	e5042703          	lw	a4,-432(s0)
    800052c4:	464c47b7          	lui	a5,0x464c4
    800052c8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052cc:	02f70c63          	beq	a4,a5,80005304 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800052d0:	8552                	mv	a0,s4
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	c82080e7          	jalr	-894(ra) # 80003f54 <iunlockput>
    end_op();
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	45c080e7          	jalr	1116(ra) # 80004736 <end_op>
  }
  return -1;
    800052e2:	557d                	li	a0,-1
    800052e4:	7a1e                	ld	s4,480(sp)
}
    800052e6:	20813083          	ld	ra,520(sp)
    800052ea:	20013403          	ld	s0,512(sp)
    800052ee:	74fe                	ld	s1,504(sp)
    800052f0:	795e                	ld	s2,496(sp)
    800052f2:	21010113          	addi	sp,sp,528
    800052f6:	8082                	ret
    end_op();
    800052f8:	fffff097          	auipc	ra,0xfffff
    800052fc:	43e080e7          	jalr	1086(ra) # 80004736 <end_op>
    return -1;
    80005300:	557d                	li	a0,-1
    80005302:	b7d5                	j	800052e6 <exec+0x8a>
    80005304:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005306:	8526                	mv	a0,s1
    80005308:	ffffd097          	auipc	ra,0xffffd
    8000530c:	a82080e7          	jalr	-1406(ra) # 80001d8a <proc_pagetable>
    80005310:	8b2a                	mv	s6,a0
    80005312:	30050f63          	beqz	a0,80005630 <exec+0x3d4>
    80005316:	f7ce                	sd	s3,488(sp)
    80005318:	efd6                	sd	s5,472(sp)
    8000531a:	e7de                	sd	s7,456(sp)
    8000531c:	e3e2                	sd	s8,448(sp)
    8000531e:	ff66                	sd	s9,440(sp)
    80005320:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005322:	e7042d03          	lw	s10,-400(s0)
    80005326:	e8845783          	lhu	a5,-376(s0)
    8000532a:	14078d63          	beqz	a5,80005484 <exec+0x228>
    8000532e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005330:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005332:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005334:	6c85                	lui	s9,0x1
    80005336:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000533a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000533e:	6a85                	lui	s5,0x1
    80005340:	a0b5                	j	800053ac <exec+0x150>
      panic("loadseg: address should exist");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	27e50513          	addi	a0,a0,638 # 800085c0 <etext+0x5c0>
    8000534a:	ffffb097          	auipc	ra,0xffffb
    8000534e:	216080e7          	jalr	534(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005352:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005354:	8726                	mv	a4,s1
    80005356:	012c06bb          	addw	a3,s8,s2
    8000535a:	4581                	li	a1,0
    8000535c:	8552                	mv	a0,s4
    8000535e:	fffff097          	auipc	ra,0xfffff
    80005362:	c48080e7          	jalr	-952(ra) # 80003fa6 <readi>
    80005366:	2501                	sext.w	a0,a0
    80005368:	28a49863          	bne	s1,a0,800055f8 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000536c:	012a893b          	addw	s2,s5,s2
    80005370:	03397563          	bgeu	s2,s3,8000539a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005374:	02091593          	slli	a1,s2,0x20
    80005378:	9181                	srli	a1,a1,0x20
    8000537a:	95de                	add	a1,a1,s7
    8000537c:	855a                	mv	a0,s6
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	e56080e7          	jalr	-426(ra) # 800011d4 <walkaddr>
    80005386:	862a                	mv	a2,a0
    if(pa == 0)
    80005388:	dd4d                	beqz	a0,80005342 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000538a:	412984bb          	subw	s1,s3,s2
    8000538e:	0004879b          	sext.w	a5,s1
    80005392:	fcfcf0e3          	bgeu	s9,a5,80005352 <exec+0xf6>
    80005396:	84d6                	mv	s1,s5
    80005398:	bf6d                	j	80005352 <exec+0xf6>
    sz = sz1;
    8000539a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000539e:	2d85                	addiw	s11,s11,1
    800053a0:	038d0d1b          	addiw	s10,s10,56
    800053a4:	e8845783          	lhu	a5,-376(s0)
    800053a8:	08fdd663          	bge	s11,a5,80005434 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053ac:	2d01                	sext.w	s10,s10
    800053ae:	03800713          	li	a4,56
    800053b2:	86ea                	mv	a3,s10
    800053b4:	e1840613          	addi	a2,s0,-488
    800053b8:	4581                	li	a1,0
    800053ba:	8552                	mv	a0,s4
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	bea080e7          	jalr	-1046(ra) # 80003fa6 <readi>
    800053c4:	03800793          	li	a5,56
    800053c8:	20f51063          	bne	a0,a5,800055c8 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800053cc:	e1842783          	lw	a5,-488(s0)
    800053d0:	4705                	li	a4,1
    800053d2:	fce796e3          	bne	a5,a4,8000539e <exec+0x142>
    if(ph.memsz < ph.filesz)
    800053d6:	e4043483          	ld	s1,-448(s0)
    800053da:	e3843783          	ld	a5,-456(s0)
    800053de:	1ef4e963          	bltu	s1,a5,800055d0 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053e2:	e2843783          	ld	a5,-472(s0)
    800053e6:	94be                	add	s1,s1,a5
    800053e8:	1ef4e863          	bltu	s1,a5,800055d8 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800053ec:	df043703          	ld	a4,-528(s0)
    800053f0:	8ff9                	and	a5,a5,a4
    800053f2:	1e079763          	bnez	a5,800055e0 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800053f6:	e1c42503          	lw	a0,-484(s0)
    800053fa:	00000097          	auipc	ra,0x0
    800053fe:	e48080e7          	jalr	-440(ra) # 80005242 <flags2perm>
    80005402:	86aa                	mv	a3,a0
    80005404:	8626                	mv	a2,s1
    80005406:	85ca                	mv	a1,s2
    80005408:	855a                	mv	a0,s6
    8000540a:	ffffc097          	auipc	ra,0xffffc
    8000540e:	18e080e7          	jalr	398(ra) # 80001598 <uvmalloc>
    80005412:	e0a43423          	sd	a0,-504(s0)
    80005416:	1c050963          	beqz	a0,800055e8 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000541a:	e2843b83          	ld	s7,-472(s0)
    8000541e:	e2042c03          	lw	s8,-480(s0)
    80005422:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005426:	00098463          	beqz	s3,8000542e <exec+0x1d2>
    8000542a:	4901                	li	s2,0
    8000542c:	b7a1                	j	80005374 <exec+0x118>
    sz = sz1;
    8000542e:	e0843903          	ld	s2,-504(s0)
    80005432:	b7b5                	j	8000539e <exec+0x142>
    80005434:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005436:	8552                	mv	a0,s4
    80005438:	fffff097          	auipc	ra,0xfffff
    8000543c:	b1c080e7          	jalr	-1252(ra) # 80003f54 <iunlockput>
  end_op();
    80005440:	fffff097          	auipc	ra,0xfffff
    80005444:	2f6080e7          	jalr	758(ra) # 80004736 <end_op>
  p = myproc();
    80005448:	ffffd097          	auipc	ra,0xffffd
    8000544c:	87e080e7          	jalr	-1922(ra) # 80001cc6 <myproc>
    80005450:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005452:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80005456:	6985                	lui	s3,0x1
    80005458:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000545a:	99ca                	add	s3,s3,s2
    8000545c:	77fd                	lui	a5,0xfffff
    8000545e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005462:	4691                	li	a3,4
    80005464:	6609                	lui	a2,0x2
    80005466:	964e                	add	a2,a2,s3
    80005468:	85ce                	mv	a1,s3
    8000546a:	855a                	mv	a0,s6
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	12c080e7          	jalr	300(ra) # 80001598 <uvmalloc>
    80005474:	892a                	mv	s2,a0
    80005476:	e0a43423          	sd	a0,-504(s0)
    8000547a:	e519                	bnez	a0,80005488 <exec+0x22c>
  if(pagetable)
    8000547c:	e1343423          	sd	s3,-504(s0)
    80005480:	4a01                	li	s4,0
    80005482:	aaa5                	j	800055fa <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005484:	4901                	li	s2,0
    80005486:	bf45                	j	80005436 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005488:	75f9                	lui	a1,0xffffe
    8000548a:	95aa                	add	a1,a1,a0
    8000548c:	855a                	mv	a0,s6
    8000548e:	ffffc097          	auipc	ra,0xffffc
    80005492:	382080e7          	jalr	898(ra) # 80001810 <uvmclear>
  stackbase = sp - PGSIZE;
    80005496:	7bfd                	lui	s7,0xfffff
    80005498:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000549a:	e0043783          	ld	a5,-512(s0)
    8000549e:	6388                	ld	a0,0(a5)
    800054a0:	c52d                	beqz	a0,8000550a <exec+0x2ae>
    800054a2:	e9040993          	addi	s3,s0,-368
    800054a6:	f9040c13          	addi	s8,s0,-112
    800054aa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800054ac:	ffffc097          	auipc	ra,0xffffc
    800054b0:	b1a080e7          	jalr	-1254(ra) # 80000fc6 <strlen>
    800054b4:	0015079b          	addiw	a5,a0,1
    800054b8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800054bc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800054c0:	13796863          	bltu	s2,s7,800055f0 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800054c4:	e0043d03          	ld	s10,-512(s0)
    800054c8:	000d3a03          	ld	s4,0(s10)
    800054cc:	8552                	mv	a0,s4
    800054ce:	ffffc097          	auipc	ra,0xffffc
    800054d2:	af8080e7          	jalr	-1288(ra) # 80000fc6 <strlen>
    800054d6:	0015069b          	addiw	a3,a0,1
    800054da:	8652                	mv	a2,s4
    800054dc:	85ca                	mv	a1,s2
    800054de:	855a                	mv	a0,s6
    800054e0:	ffffc097          	auipc	ra,0xffffc
    800054e4:	362080e7          	jalr	866(ra) # 80001842 <copyout>
    800054e8:	10054663          	bltz	a0,800055f4 <exec+0x398>
    ustack[argc] = sp;
    800054ec:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800054f0:	0485                	addi	s1,s1,1
    800054f2:	008d0793          	addi	a5,s10,8
    800054f6:	e0f43023          	sd	a5,-512(s0)
    800054fa:	008d3503          	ld	a0,8(s10)
    800054fe:	c909                	beqz	a0,80005510 <exec+0x2b4>
    if(argc >= MAXARG)
    80005500:	09a1                	addi	s3,s3,8
    80005502:	fb8995e3          	bne	s3,s8,800054ac <exec+0x250>
  ip = 0;
    80005506:	4a01                	li	s4,0
    80005508:	a8cd                	j	800055fa <exec+0x39e>
  sp = sz;
    8000550a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000550e:	4481                	li	s1,0
  ustack[argc] = 0;
    80005510:	00349793          	slli	a5,s1,0x3
    80005514:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffbce28>
    80005518:	97a2                	add	a5,a5,s0
    8000551a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000551e:	00148693          	addi	a3,s1,1
    80005522:	068e                	slli	a3,a3,0x3
    80005524:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005528:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000552c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005530:	f57966e3          	bltu	s2,s7,8000547c <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005534:	e9040613          	addi	a2,s0,-368
    80005538:	85ca                	mv	a1,s2
    8000553a:	855a                	mv	a0,s6
    8000553c:	ffffc097          	auipc	ra,0xffffc
    80005540:	306080e7          	jalr	774(ra) # 80001842 <copyout>
    80005544:	0e054863          	bltz	a0,80005634 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005548:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000554c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005550:	df843783          	ld	a5,-520(s0)
    80005554:	0007c703          	lbu	a4,0(a5)
    80005558:	cf11                	beqz	a4,80005574 <exec+0x318>
    8000555a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000555c:	02f00693          	li	a3,47
    80005560:	a039                	j	8000556e <exec+0x312>
      last = s+1;
    80005562:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005566:	0785                	addi	a5,a5,1
    80005568:	fff7c703          	lbu	a4,-1(a5)
    8000556c:	c701                	beqz	a4,80005574 <exec+0x318>
    if(*s == '/')
    8000556e:	fed71ce3          	bne	a4,a3,80005566 <exec+0x30a>
    80005572:	bfc5                	j	80005562 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005574:	4641                	li	a2,16
    80005576:	df843583          	ld	a1,-520(s0)
    8000557a:	158a8513          	addi	a0,s5,344
    8000557e:	ffffc097          	auipc	ra,0xffffc
    80005582:	a16080e7          	jalr	-1514(ra) # 80000f94 <safestrcpy>
  oldpagetable = p->pagetable;
    80005586:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000558a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000558e:	e0843783          	ld	a5,-504(s0)
    80005592:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005596:	058ab783          	ld	a5,88(s5)
    8000559a:	e6843703          	ld	a4,-408(s0)
    8000559e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800055a0:	058ab783          	ld	a5,88(s5)
    800055a4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800055a8:	85e6                	mv	a1,s9
    800055aa:	ffffd097          	auipc	ra,0xffffd
    800055ae:	87c080e7          	jalr	-1924(ra) # 80001e26 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055b2:	0004851b          	sext.w	a0,s1
    800055b6:	79be                	ld	s3,488(sp)
    800055b8:	7a1e                	ld	s4,480(sp)
    800055ba:	6afe                	ld	s5,472(sp)
    800055bc:	6b5e                	ld	s6,464(sp)
    800055be:	6bbe                	ld	s7,456(sp)
    800055c0:	6c1e                	ld	s8,448(sp)
    800055c2:	7cfa                	ld	s9,440(sp)
    800055c4:	7d5a                	ld	s10,432(sp)
    800055c6:	b305                	j	800052e6 <exec+0x8a>
    800055c8:	e1243423          	sd	s2,-504(s0)
    800055cc:	7dba                	ld	s11,424(sp)
    800055ce:	a035                	j	800055fa <exec+0x39e>
    800055d0:	e1243423          	sd	s2,-504(s0)
    800055d4:	7dba                	ld	s11,424(sp)
    800055d6:	a015                	j	800055fa <exec+0x39e>
    800055d8:	e1243423          	sd	s2,-504(s0)
    800055dc:	7dba                	ld	s11,424(sp)
    800055de:	a831                	j	800055fa <exec+0x39e>
    800055e0:	e1243423          	sd	s2,-504(s0)
    800055e4:	7dba                	ld	s11,424(sp)
    800055e6:	a811                	j	800055fa <exec+0x39e>
    800055e8:	e1243423          	sd	s2,-504(s0)
    800055ec:	7dba                	ld	s11,424(sp)
    800055ee:	a031                	j	800055fa <exec+0x39e>
  ip = 0;
    800055f0:	4a01                	li	s4,0
    800055f2:	a021                	j	800055fa <exec+0x39e>
    800055f4:	4a01                	li	s4,0
  if(pagetable)
    800055f6:	a011                	j	800055fa <exec+0x39e>
    800055f8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800055fa:	e0843583          	ld	a1,-504(s0)
    800055fe:	855a                	mv	a0,s6
    80005600:	ffffd097          	auipc	ra,0xffffd
    80005604:	826080e7          	jalr	-2010(ra) # 80001e26 <proc_freepagetable>
  return -1;
    80005608:	557d                	li	a0,-1
  if(ip){
    8000560a:	000a1b63          	bnez	s4,80005620 <exec+0x3c4>
    8000560e:	79be                	ld	s3,488(sp)
    80005610:	7a1e                	ld	s4,480(sp)
    80005612:	6afe                	ld	s5,472(sp)
    80005614:	6b5e                	ld	s6,464(sp)
    80005616:	6bbe                	ld	s7,456(sp)
    80005618:	6c1e                	ld	s8,448(sp)
    8000561a:	7cfa                	ld	s9,440(sp)
    8000561c:	7d5a                	ld	s10,432(sp)
    8000561e:	b1e1                	j	800052e6 <exec+0x8a>
    80005620:	79be                	ld	s3,488(sp)
    80005622:	6afe                	ld	s5,472(sp)
    80005624:	6b5e                	ld	s6,464(sp)
    80005626:	6bbe                	ld	s7,456(sp)
    80005628:	6c1e                	ld	s8,448(sp)
    8000562a:	7cfa                	ld	s9,440(sp)
    8000562c:	7d5a                	ld	s10,432(sp)
    8000562e:	b14d                	j	800052d0 <exec+0x74>
    80005630:	6b5e                	ld	s6,464(sp)
    80005632:	b979                	j	800052d0 <exec+0x74>
  sz = sz1;
    80005634:	e0843983          	ld	s3,-504(s0)
    80005638:	b591                	j	8000547c <exec+0x220>

000000008000563a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000563a:	7179                	addi	sp,sp,-48
    8000563c:	f406                	sd	ra,40(sp)
    8000563e:	f022                	sd	s0,32(sp)
    80005640:	ec26                	sd	s1,24(sp)
    80005642:	e84a                	sd	s2,16(sp)
    80005644:	1800                	addi	s0,sp,48
    80005646:	892e                	mv	s2,a1
    80005648:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000564a:	fdc40593          	addi	a1,s0,-36
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	a7a080e7          	jalr	-1414(ra) # 800030c8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005656:	fdc42703          	lw	a4,-36(s0)
    8000565a:	47bd                	li	a5,15
    8000565c:	02e7eb63          	bltu	a5,a4,80005692 <argfd+0x58>
    80005660:	ffffc097          	auipc	ra,0xffffc
    80005664:	666080e7          	jalr	1638(ra) # 80001cc6 <myproc>
    80005668:	fdc42703          	lw	a4,-36(s0)
    8000566c:	01a70793          	addi	a5,a4,26
    80005670:	078e                	slli	a5,a5,0x3
    80005672:	953e                	add	a0,a0,a5
    80005674:	611c                	ld	a5,0(a0)
    80005676:	c385                	beqz	a5,80005696 <argfd+0x5c>
    return -1;
  if(pfd)
    80005678:	00090463          	beqz	s2,80005680 <argfd+0x46>
    *pfd = fd;
    8000567c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005680:	4501                	li	a0,0
  if(pf)
    80005682:	c091                	beqz	s1,80005686 <argfd+0x4c>
    *pf = f;
    80005684:	e09c                	sd	a5,0(s1)
}
    80005686:	70a2                	ld	ra,40(sp)
    80005688:	7402                	ld	s0,32(sp)
    8000568a:	64e2                	ld	s1,24(sp)
    8000568c:	6942                	ld	s2,16(sp)
    8000568e:	6145                	addi	sp,sp,48
    80005690:	8082                	ret
    return -1;
    80005692:	557d                	li	a0,-1
    80005694:	bfcd                	j	80005686 <argfd+0x4c>
    80005696:	557d                	li	a0,-1
    80005698:	b7fd                	j	80005686 <argfd+0x4c>

000000008000569a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000569a:	1101                	addi	sp,sp,-32
    8000569c:	ec06                	sd	ra,24(sp)
    8000569e:	e822                	sd	s0,16(sp)
    800056a0:	e426                	sd	s1,8(sp)
    800056a2:	1000                	addi	s0,sp,32
    800056a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800056a6:	ffffc097          	auipc	ra,0xffffc
    800056aa:	620080e7          	jalr	1568(ra) # 80001cc6 <myproc>
    800056ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056b0:	0d050793          	addi	a5,a0,208
    800056b4:	4501                	li	a0,0
    800056b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056b8:	6398                	ld	a4,0(a5)
    800056ba:	cb19                	beqz	a4,800056d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056bc:	2505                	addiw	a0,a0,1
    800056be:	07a1                	addi	a5,a5,8
    800056c0:	fed51ce3          	bne	a0,a3,800056b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056c4:	557d                	li	a0,-1
}
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	64a2                	ld	s1,8(sp)
    800056cc:	6105                	addi	sp,sp,32
    800056ce:	8082                	ret
      p->ofile[fd] = f;
    800056d0:	01a50793          	addi	a5,a0,26
    800056d4:	078e                	slli	a5,a5,0x3
    800056d6:	963e                	add	a2,a2,a5
    800056d8:	e204                	sd	s1,0(a2)
      return fd;
    800056da:	b7f5                	j	800056c6 <fdalloc+0x2c>

00000000800056dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056dc:	715d                	addi	sp,sp,-80
    800056de:	e486                	sd	ra,72(sp)
    800056e0:	e0a2                	sd	s0,64(sp)
    800056e2:	fc26                	sd	s1,56(sp)
    800056e4:	f84a                	sd	s2,48(sp)
    800056e6:	f44e                	sd	s3,40(sp)
    800056e8:	ec56                	sd	s5,24(sp)
    800056ea:	e85a                	sd	s6,16(sp)
    800056ec:	0880                	addi	s0,sp,80
    800056ee:	8b2e                	mv	s6,a1
    800056f0:	89b2                	mv	s3,a2
    800056f2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800056f4:	fb040593          	addi	a1,s0,-80
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	de2080e7          	jalr	-542(ra) # 800044da <nameiparent>
    80005700:	84aa                	mv	s1,a0
    80005702:	14050e63          	beqz	a0,8000585e <create+0x182>
    return 0;

  ilock(dp);
    80005706:	ffffe097          	auipc	ra,0xffffe
    8000570a:	5e8080e7          	jalr	1512(ra) # 80003cee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000570e:	4601                	li	a2,0
    80005710:	fb040593          	addi	a1,s0,-80
    80005714:	8526                	mv	a0,s1
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	ae4080e7          	jalr	-1308(ra) # 800041fa <dirlookup>
    8000571e:	8aaa                	mv	s5,a0
    80005720:	c539                	beqz	a0,8000576e <create+0x92>
    iunlockput(dp);
    80005722:	8526                	mv	a0,s1
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	830080e7          	jalr	-2000(ra) # 80003f54 <iunlockput>
    ilock(ip);
    8000572c:	8556                	mv	a0,s5
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	5c0080e7          	jalr	1472(ra) # 80003cee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005736:	4789                	li	a5,2
    80005738:	02fb1463          	bne	s6,a5,80005760 <create+0x84>
    8000573c:	044ad783          	lhu	a5,68(s5)
    80005740:	37f9                	addiw	a5,a5,-2
    80005742:	17c2                	slli	a5,a5,0x30
    80005744:	93c1                	srli	a5,a5,0x30
    80005746:	4705                	li	a4,1
    80005748:	00f76c63          	bltu	a4,a5,80005760 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000574c:	8556                	mv	a0,s5
    8000574e:	60a6                	ld	ra,72(sp)
    80005750:	6406                	ld	s0,64(sp)
    80005752:	74e2                	ld	s1,56(sp)
    80005754:	7942                	ld	s2,48(sp)
    80005756:	79a2                	ld	s3,40(sp)
    80005758:	6ae2                	ld	s5,24(sp)
    8000575a:	6b42                	ld	s6,16(sp)
    8000575c:	6161                	addi	sp,sp,80
    8000575e:	8082                	ret
    iunlockput(ip);
    80005760:	8556                	mv	a0,s5
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	7f2080e7          	jalr	2034(ra) # 80003f54 <iunlockput>
    return 0;
    8000576a:	4a81                	li	s5,0
    8000576c:	b7c5                	j	8000574c <create+0x70>
    8000576e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005770:	85da                	mv	a1,s6
    80005772:	4088                	lw	a0,0(s1)
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	3d6080e7          	jalr	982(ra) # 80003b4a <ialloc>
    8000577c:	8a2a                	mv	s4,a0
    8000577e:	c531                	beqz	a0,800057ca <create+0xee>
  ilock(ip);
    80005780:	ffffe097          	auipc	ra,0xffffe
    80005784:	56e080e7          	jalr	1390(ra) # 80003cee <ilock>
  ip->major = major;
    80005788:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000578c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005790:	4905                	li	s2,1
    80005792:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005796:	8552                	mv	a0,s4
    80005798:	ffffe097          	auipc	ra,0xffffe
    8000579c:	48a080e7          	jalr	1162(ra) # 80003c22 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057a0:	032b0d63          	beq	s6,s2,800057da <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800057a4:	004a2603          	lw	a2,4(s4)
    800057a8:	fb040593          	addi	a1,s0,-80
    800057ac:	8526                	mv	a0,s1
    800057ae:	fffff097          	auipc	ra,0xfffff
    800057b2:	c5c080e7          	jalr	-932(ra) # 8000440a <dirlink>
    800057b6:	08054163          	bltz	a0,80005838 <create+0x15c>
  iunlockput(dp);
    800057ba:	8526                	mv	a0,s1
    800057bc:	ffffe097          	auipc	ra,0xffffe
    800057c0:	798080e7          	jalr	1944(ra) # 80003f54 <iunlockput>
  return ip;
    800057c4:	8ad2                	mv	s5,s4
    800057c6:	7a02                	ld	s4,32(sp)
    800057c8:	b751                	j	8000574c <create+0x70>
    iunlockput(dp);
    800057ca:	8526                	mv	a0,s1
    800057cc:	ffffe097          	auipc	ra,0xffffe
    800057d0:	788080e7          	jalr	1928(ra) # 80003f54 <iunlockput>
    return 0;
    800057d4:	8ad2                	mv	s5,s4
    800057d6:	7a02                	ld	s4,32(sp)
    800057d8:	bf95                	j	8000574c <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057da:	004a2603          	lw	a2,4(s4)
    800057de:	00003597          	auipc	a1,0x3
    800057e2:	e0258593          	addi	a1,a1,-510 # 800085e0 <etext+0x5e0>
    800057e6:	8552                	mv	a0,s4
    800057e8:	fffff097          	auipc	ra,0xfffff
    800057ec:	c22080e7          	jalr	-990(ra) # 8000440a <dirlink>
    800057f0:	04054463          	bltz	a0,80005838 <create+0x15c>
    800057f4:	40d0                	lw	a2,4(s1)
    800057f6:	00003597          	auipc	a1,0x3
    800057fa:	df258593          	addi	a1,a1,-526 # 800085e8 <etext+0x5e8>
    800057fe:	8552                	mv	a0,s4
    80005800:	fffff097          	auipc	ra,0xfffff
    80005804:	c0a080e7          	jalr	-1014(ra) # 8000440a <dirlink>
    80005808:	02054863          	bltz	a0,80005838 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000580c:	004a2603          	lw	a2,4(s4)
    80005810:	fb040593          	addi	a1,s0,-80
    80005814:	8526                	mv	a0,s1
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	bf4080e7          	jalr	-1036(ra) # 8000440a <dirlink>
    8000581e:	00054d63          	bltz	a0,80005838 <create+0x15c>
    dp->nlink++;  // for ".."
    80005822:	04a4d783          	lhu	a5,74(s1)
    80005826:	2785                	addiw	a5,a5,1
    80005828:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000582c:	8526                	mv	a0,s1
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	3f4080e7          	jalr	1012(ra) # 80003c22 <iupdate>
    80005836:	b751                	j	800057ba <create+0xde>
  ip->nlink = 0;
    80005838:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000583c:	8552                	mv	a0,s4
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	3e4080e7          	jalr	996(ra) # 80003c22 <iupdate>
  iunlockput(ip);
    80005846:	8552                	mv	a0,s4
    80005848:	ffffe097          	auipc	ra,0xffffe
    8000584c:	70c080e7          	jalr	1804(ra) # 80003f54 <iunlockput>
  iunlockput(dp);
    80005850:	8526                	mv	a0,s1
    80005852:	ffffe097          	auipc	ra,0xffffe
    80005856:	702080e7          	jalr	1794(ra) # 80003f54 <iunlockput>
  return 0;
    8000585a:	7a02                	ld	s4,32(sp)
    8000585c:	bdc5                	j	8000574c <create+0x70>
    return 0;
    8000585e:	8aaa                	mv	s5,a0
    80005860:	b5f5                	j	8000574c <create+0x70>

0000000080005862 <sys_dup>:
{
    80005862:	7179                	addi	sp,sp,-48
    80005864:	f406                	sd	ra,40(sp)
    80005866:	f022                	sd	s0,32(sp)
    80005868:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000586a:	fd840613          	addi	a2,s0,-40
    8000586e:	4581                	li	a1,0
    80005870:	4501                	li	a0,0
    80005872:	00000097          	auipc	ra,0x0
    80005876:	dc8080e7          	jalr	-568(ra) # 8000563a <argfd>
    return -1;
    8000587a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000587c:	02054763          	bltz	a0,800058aa <sys_dup+0x48>
    80005880:	ec26                	sd	s1,24(sp)
    80005882:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005884:	fd843903          	ld	s2,-40(s0)
    80005888:	854a                	mv	a0,s2
    8000588a:	00000097          	auipc	ra,0x0
    8000588e:	e10080e7          	jalr	-496(ra) # 8000569a <fdalloc>
    80005892:	84aa                	mv	s1,a0
    return -1;
    80005894:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005896:	00054f63          	bltz	a0,800058b4 <sys_dup+0x52>
  filedup(f);
    8000589a:	854a                	mv	a0,s2
    8000589c:	fffff097          	auipc	ra,0xfffff
    800058a0:	298080e7          	jalr	664(ra) # 80004b34 <filedup>
  return fd;
    800058a4:	87a6                	mv	a5,s1
    800058a6:	64e2                	ld	s1,24(sp)
    800058a8:	6942                	ld	s2,16(sp)
}
    800058aa:	853e                	mv	a0,a5
    800058ac:	70a2                	ld	ra,40(sp)
    800058ae:	7402                	ld	s0,32(sp)
    800058b0:	6145                	addi	sp,sp,48
    800058b2:	8082                	ret
    800058b4:	64e2                	ld	s1,24(sp)
    800058b6:	6942                	ld	s2,16(sp)
    800058b8:	bfcd                	j	800058aa <sys_dup+0x48>

00000000800058ba <sys_read>:
{
    800058ba:	7179                	addi	sp,sp,-48
    800058bc:	f406                	sd	ra,40(sp)
    800058be:	f022                	sd	s0,32(sp)
    800058c0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058c2:	fd840593          	addi	a1,s0,-40
    800058c6:	4505                	li	a0,1
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	820080e7          	jalr	-2016(ra) # 800030e8 <argaddr>
  argint(2, &n);
    800058d0:	fe440593          	addi	a1,s0,-28
    800058d4:	4509                	li	a0,2
    800058d6:	ffffd097          	auipc	ra,0xffffd
    800058da:	7f2080e7          	jalr	2034(ra) # 800030c8 <argint>
  if(argfd(0, 0, &f) < 0)
    800058de:	fe840613          	addi	a2,s0,-24
    800058e2:	4581                	li	a1,0
    800058e4:	4501                	li	a0,0
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	d54080e7          	jalr	-684(ra) # 8000563a <argfd>
    800058ee:	87aa                	mv	a5,a0
    return -1;
    800058f0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058f2:	0007cc63          	bltz	a5,8000590a <sys_read+0x50>
  return fileread(f, p, n);
    800058f6:	fe442603          	lw	a2,-28(s0)
    800058fa:	fd843583          	ld	a1,-40(s0)
    800058fe:	fe843503          	ld	a0,-24(s0)
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	3d8080e7          	jalr	984(ra) # 80004cda <fileread>
}
    8000590a:	70a2                	ld	ra,40(sp)
    8000590c:	7402                	ld	s0,32(sp)
    8000590e:	6145                	addi	sp,sp,48
    80005910:	8082                	ret

0000000080005912 <sys_write>:
{
    80005912:	7179                	addi	sp,sp,-48
    80005914:	f406                	sd	ra,40(sp)
    80005916:	f022                	sd	s0,32(sp)
    80005918:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000591a:	fd840593          	addi	a1,s0,-40
    8000591e:	4505                	li	a0,1
    80005920:	ffffd097          	auipc	ra,0xffffd
    80005924:	7c8080e7          	jalr	1992(ra) # 800030e8 <argaddr>
  argint(2, &n);
    80005928:	fe440593          	addi	a1,s0,-28
    8000592c:	4509                	li	a0,2
    8000592e:	ffffd097          	auipc	ra,0xffffd
    80005932:	79a080e7          	jalr	1946(ra) # 800030c8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005936:	fe840613          	addi	a2,s0,-24
    8000593a:	4581                	li	a1,0
    8000593c:	4501                	li	a0,0
    8000593e:	00000097          	auipc	ra,0x0
    80005942:	cfc080e7          	jalr	-772(ra) # 8000563a <argfd>
    80005946:	87aa                	mv	a5,a0
    return -1;
    80005948:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000594a:	0007cc63          	bltz	a5,80005962 <sys_write+0x50>
  return filewrite(f, p, n);
    8000594e:	fe442603          	lw	a2,-28(s0)
    80005952:	fd843583          	ld	a1,-40(s0)
    80005956:	fe843503          	ld	a0,-24(s0)
    8000595a:	fffff097          	auipc	ra,0xfffff
    8000595e:	452080e7          	jalr	1106(ra) # 80004dac <filewrite>
}
    80005962:	70a2                	ld	ra,40(sp)
    80005964:	7402                	ld	s0,32(sp)
    80005966:	6145                	addi	sp,sp,48
    80005968:	8082                	ret

000000008000596a <sys_close>:
{
    8000596a:	1101                	addi	sp,sp,-32
    8000596c:	ec06                	sd	ra,24(sp)
    8000596e:	e822                	sd	s0,16(sp)
    80005970:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005972:	fe040613          	addi	a2,s0,-32
    80005976:	fec40593          	addi	a1,s0,-20
    8000597a:	4501                	li	a0,0
    8000597c:	00000097          	auipc	ra,0x0
    80005980:	cbe080e7          	jalr	-834(ra) # 8000563a <argfd>
    return -1;
    80005984:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005986:	02054463          	bltz	a0,800059ae <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000598a:	ffffc097          	auipc	ra,0xffffc
    8000598e:	33c080e7          	jalr	828(ra) # 80001cc6 <myproc>
    80005992:	fec42783          	lw	a5,-20(s0)
    80005996:	07e9                	addi	a5,a5,26
    80005998:	078e                	slli	a5,a5,0x3
    8000599a:	953e                	add	a0,a0,a5
    8000599c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800059a0:	fe043503          	ld	a0,-32(s0)
    800059a4:	fffff097          	auipc	ra,0xfffff
    800059a8:	1e2080e7          	jalr	482(ra) # 80004b86 <fileclose>
  return 0;
    800059ac:	4781                	li	a5,0
}
    800059ae:	853e                	mv	a0,a5
    800059b0:	60e2                	ld	ra,24(sp)
    800059b2:	6442                	ld	s0,16(sp)
    800059b4:	6105                	addi	sp,sp,32
    800059b6:	8082                	ret

00000000800059b8 <sys_fstat>:
{
    800059b8:	1101                	addi	sp,sp,-32
    800059ba:	ec06                	sd	ra,24(sp)
    800059bc:	e822                	sd	s0,16(sp)
    800059be:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059c0:	fe040593          	addi	a1,s0,-32
    800059c4:	4505                	li	a0,1
    800059c6:	ffffd097          	auipc	ra,0xffffd
    800059ca:	722080e7          	jalr	1826(ra) # 800030e8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059ce:	fe840613          	addi	a2,s0,-24
    800059d2:	4581                	li	a1,0
    800059d4:	4501                	li	a0,0
    800059d6:	00000097          	auipc	ra,0x0
    800059da:	c64080e7          	jalr	-924(ra) # 8000563a <argfd>
    800059de:	87aa                	mv	a5,a0
    return -1;
    800059e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059e2:	0007ca63          	bltz	a5,800059f6 <sys_fstat+0x3e>
  return filestat(f, st);
    800059e6:	fe043583          	ld	a1,-32(s0)
    800059ea:	fe843503          	ld	a0,-24(s0)
    800059ee:	fffff097          	auipc	ra,0xfffff
    800059f2:	27a080e7          	jalr	634(ra) # 80004c68 <filestat>
}
    800059f6:	60e2                	ld	ra,24(sp)
    800059f8:	6442                	ld	s0,16(sp)
    800059fa:	6105                	addi	sp,sp,32
    800059fc:	8082                	ret

00000000800059fe <sys_link>:
{
    800059fe:	7169                	addi	sp,sp,-304
    80005a00:	f606                	sd	ra,296(sp)
    80005a02:	f222                	sd	s0,288(sp)
    80005a04:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a06:	08000613          	li	a2,128
    80005a0a:	ed040593          	addi	a1,s0,-304
    80005a0e:	4501                	li	a0,0
    80005a10:	ffffd097          	auipc	ra,0xffffd
    80005a14:	6f8080e7          	jalr	1784(ra) # 80003108 <argstr>
    return -1;
    80005a18:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a1a:	12054663          	bltz	a0,80005b46 <sys_link+0x148>
    80005a1e:	08000613          	li	a2,128
    80005a22:	f5040593          	addi	a1,s0,-176
    80005a26:	4505                	li	a0,1
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	6e0080e7          	jalr	1760(ra) # 80003108 <argstr>
    return -1;
    80005a30:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a32:	10054a63          	bltz	a0,80005b46 <sys_link+0x148>
    80005a36:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	c84080e7          	jalr	-892(ra) # 800046bc <begin_op>
  if((ip = namei(old)) == 0){
    80005a40:	ed040513          	addi	a0,s0,-304
    80005a44:	fffff097          	auipc	ra,0xfffff
    80005a48:	a78080e7          	jalr	-1416(ra) # 800044bc <namei>
    80005a4c:	84aa                	mv	s1,a0
    80005a4e:	c949                	beqz	a0,80005ae0 <sys_link+0xe2>
  ilock(ip);
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	29e080e7          	jalr	670(ra) # 80003cee <ilock>
  if(ip->type == T_DIR){
    80005a58:	04449703          	lh	a4,68(s1)
    80005a5c:	4785                	li	a5,1
    80005a5e:	08f70863          	beq	a4,a5,80005aee <sys_link+0xf0>
    80005a62:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005a64:	04a4d783          	lhu	a5,74(s1)
    80005a68:	2785                	addiw	a5,a5,1
    80005a6a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a6e:	8526                	mv	a0,s1
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	1b2080e7          	jalr	434(ra) # 80003c22 <iupdate>
  iunlock(ip);
    80005a78:	8526                	mv	a0,s1
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	33a080e7          	jalr	826(ra) # 80003db4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a82:	fd040593          	addi	a1,s0,-48
    80005a86:	f5040513          	addi	a0,s0,-176
    80005a8a:	fffff097          	auipc	ra,0xfffff
    80005a8e:	a50080e7          	jalr	-1456(ra) # 800044da <nameiparent>
    80005a92:	892a                	mv	s2,a0
    80005a94:	cd35                	beqz	a0,80005b10 <sys_link+0x112>
  ilock(dp);
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	258080e7          	jalr	600(ra) # 80003cee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a9e:	00092703          	lw	a4,0(s2)
    80005aa2:	409c                	lw	a5,0(s1)
    80005aa4:	06f71163          	bne	a4,a5,80005b06 <sys_link+0x108>
    80005aa8:	40d0                	lw	a2,4(s1)
    80005aaa:	fd040593          	addi	a1,s0,-48
    80005aae:	854a                	mv	a0,s2
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	95a080e7          	jalr	-1702(ra) # 8000440a <dirlink>
    80005ab8:	04054763          	bltz	a0,80005b06 <sys_link+0x108>
  iunlockput(dp);
    80005abc:	854a                	mv	a0,s2
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	496080e7          	jalr	1174(ra) # 80003f54 <iunlockput>
  iput(ip);
    80005ac6:	8526                	mv	a0,s1
    80005ac8:	ffffe097          	auipc	ra,0xffffe
    80005acc:	3e4080e7          	jalr	996(ra) # 80003eac <iput>
  end_op();
    80005ad0:	fffff097          	auipc	ra,0xfffff
    80005ad4:	c66080e7          	jalr	-922(ra) # 80004736 <end_op>
  return 0;
    80005ad8:	4781                	li	a5,0
    80005ada:	64f2                	ld	s1,280(sp)
    80005adc:	6952                	ld	s2,272(sp)
    80005ade:	a0a5                	j	80005b46 <sys_link+0x148>
    end_op();
    80005ae0:	fffff097          	auipc	ra,0xfffff
    80005ae4:	c56080e7          	jalr	-938(ra) # 80004736 <end_op>
    return -1;
    80005ae8:	57fd                	li	a5,-1
    80005aea:	64f2                	ld	s1,280(sp)
    80005aec:	a8a9                	j	80005b46 <sys_link+0x148>
    iunlockput(ip);
    80005aee:	8526                	mv	a0,s1
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	464080e7          	jalr	1124(ra) # 80003f54 <iunlockput>
    end_op();
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	c3e080e7          	jalr	-962(ra) # 80004736 <end_op>
    return -1;
    80005b00:	57fd                	li	a5,-1
    80005b02:	64f2                	ld	s1,280(sp)
    80005b04:	a089                	j	80005b46 <sys_link+0x148>
    iunlockput(dp);
    80005b06:	854a                	mv	a0,s2
    80005b08:	ffffe097          	auipc	ra,0xffffe
    80005b0c:	44c080e7          	jalr	1100(ra) # 80003f54 <iunlockput>
  ilock(ip);
    80005b10:	8526                	mv	a0,s1
    80005b12:	ffffe097          	auipc	ra,0xffffe
    80005b16:	1dc080e7          	jalr	476(ra) # 80003cee <ilock>
  ip->nlink--;
    80005b1a:	04a4d783          	lhu	a5,74(s1)
    80005b1e:	37fd                	addiw	a5,a5,-1
    80005b20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b24:	8526                	mv	a0,s1
    80005b26:	ffffe097          	auipc	ra,0xffffe
    80005b2a:	0fc080e7          	jalr	252(ra) # 80003c22 <iupdate>
  iunlockput(ip);
    80005b2e:	8526                	mv	a0,s1
    80005b30:	ffffe097          	auipc	ra,0xffffe
    80005b34:	424080e7          	jalr	1060(ra) # 80003f54 <iunlockput>
  end_op();
    80005b38:	fffff097          	auipc	ra,0xfffff
    80005b3c:	bfe080e7          	jalr	-1026(ra) # 80004736 <end_op>
  return -1;
    80005b40:	57fd                	li	a5,-1
    80005b42:	64f2                	ld	s1,280(sp)
    80005b44:	6952                	ld	s2,272(sp)
}
    80005b46:	853e                	mv	a0,a5
    80005b48:	70b2                	ld	ra,296(sp)
    80005b4a:	7412                	ld	s0,288(sp)
    80005b4c:	6155                	addi	sp,sp,304
    80005b4e:	8082                	ret

0000000080005b50 <sys_unlink>:
{
    80005b50:	7151                	addi	sp,sp,-240
    80005b52:	f586                	sd	ra,232(sp)
    80005b54:	f1a2                	sd	s0,224(sp)
    80005b56:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b58:	08000613          	li	a2,128
    80005b5c:	f3040593          	addi	a1,s0,-208
    80005b60:	4501                	li	a0,0
    80005b62:	ffffd097          	auipc	ra,0xffffd
    80005b66:	5a6080e7          	jalr	1446(ra) # 80003108 <argstr>
    80005b6a:	1a054a63          	bltz	a0,80005d1e <sys_unlink+0x1ce>
    80005b6e:	eda6                	sd	s1,216(sp)
  begin_op();
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	b4c080e7          	jalr	-1204(ra) # 800046bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b78:	fb040593          	addi	a1,s0,-80
    80005b7c:	f3040513          	addi	a0,s0,-208
    80005b80:	fffff097          	auipc	ra,0xfffff
    80005b84:	95a080e7          	jalr	-1702(ra) # 800044da <nameiparent>
    80005b88:	84aa                	mv	s1,a0
    80005b8a:	cd71                	beqz	a0,80005c66 <sys_unlink+0x116>
  ilock(dp);
    80005b8c:	ffffe097          	auipc	ra,0xffffe
    80005b90:	162080e7          	jalr	354(ra) # 80003cee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b94:	00003597          	auipc	a1,0x3
    80005b98:	a4c58593          	addi	a1,a1,-1460 # 800085e0 <etext+0x5e0>
    80005b9c:	fb040513          	addi	a0,s0,-80
    80005ba0:	ffffe097          	auipc	ra,0xffffe
    80005ba4:	640080e7          	jalr	1600(ra) # 800041e0 <namecmp>
    80005ba8:	14050c63          	beqz	a0,80005d00 <sys_unlink+0x1b0>
    80005bac:	00003597          	auipc	a1,0x3
    80005bb0:	a3c58593          	addi	a1,a1,-1476 # 800085e8 <etext+0x5e8>
    80005bb4:	fb040513          	addi	a0,s0,-80
    80005bb8:	ffffe097          	auipc	ra,0xffffe
    80005bbc:	628080e7          	jalr	1576(ra) # 800041e0 <namecmp>
    80005bc0:	14050063          	beqz	a0,80005d00 <sys_unlink+0x1b0>
    80005bc4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005bc6:	f2c40613          	addi	a2,s0,-212
    80005bca:	fb040593          	addi	a1,s0,-80
    80005bce:	8526                	mv	a0,s1
    80005bd0:	ffffe097          	auipc	ra,0xffffe
    80005bd4:	62a080e7          	jalr	1578(ra) # 800041fa <dirlookup>
    80005bd8:	892a                	mv	s2,a0
    80005bda:	12050263          	beqz	a0,80005cfe <sys_unlink+0x1ae>
  ilock(ip);
    80005bde:	ffffe097          	auipc	ra,0xffffe
    80005be2:	110080e7          	jalr	272(ra) # 80003cee <ilock>
  if(ip->nlink < 1)
    80005be6:	04a91783          	lh	a5,74(s2)
    80005bea:	08f05563          	blez	a5,80005c74 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005bee:	04491703          	lh	a4,68(s2)
    80005bf2:	4785                	li	a5,1
    80005bf4:	08f70963          	beq	a4,a5,80005c86 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005bf8:	4641                	li	a2,16
    80005bfa:	4581                	li	a1,0
    80005bfc:	fc040513          	addi	a0,s0,-64
    80005c00:	ffffb097          	auipc	ra,0xffffb
    80005c04:	252080e7          	jalr	594(ra) # 80000e52 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c08:	4741                	li	a4,16
    80005c0a:	f2c42683          	lw	a3,-212(s0)
    80005c0e:	fc040613          	addi	a2,s0,-64
    80005c12:	4581                	li	a1,0
    80005c14:	8526                	mv	a0,s1
    80005c16:	ffffe097          	auipc	ra,0xffffe
    80005c1a:	4a0080e7          	jalr	1184(ra) # 800040b6 <writei>
    80005c1e:	47c1                	li	a5,16
    80005c20:	0af51b63          	bne	a0,a5,80005cd6 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005c24:	04491703          	lh	a4,68(s2)
    80005c28:	4785                	li	a5,1
    80005c2a:	0af70f63          	beq	a4,a5,80005ce8 <sys_unlink+0x198>
  iunlockput(dp);
    80005c2e:	8526                	mv	a0,s1
    80005c30:	ffffe097          	auipc	ra,0xffffe
    80005c34:	324080e7          	jalr	804(ra) # 80003f54 <iunlockput>
  ip->nlink--;
    80005c38:	04a95783          	lhu	a5,74(s2)
    80005c3c:	37fd                	addiw	a5,a5,-1
    80005c3e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c42:	854a                	mv	a0,s2
    80005c44:	ffffe097          	auipc	ra,0xffffe
    80005c48:	fde080e7          	jalr	-34(ra) # 80003c22 <iupdate>
  iunlockput(ip);
    80005c4c:	854a                	mv	a0,s2
    80005c4e:	ffffe097          	auipc	ra,0xffffe
    80005c52:	306080e7          	jalr	774(ra) # 80003f54 <iunlockput>
  end_op();
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	ae0080e7          	jalr	-1312(ra) # 80004736 <end_op>
  return 0;
    80005c5e:	4501                	li	a0,0
    80005c60:	64ee                	ld	s1,216(sp)
    80005c62:	694e                	ld	s2,208(sp)
    80005c64:	a84d                	j	80005d16 <sys_unlink+0x1c6>
    end_op();
    80005c66:	fffff097          	auipc	ra,0xfffff
    80005c6a:	ad0080e7          	jalr	-1328(ra) # 80004736 <end_op>
    return -1;
    80005c6e:	557d                	li	a0,-1
    80005c70:	64ee                	ld	s1,216(sp)
    80005c72:	a055                	j	80005d16 <sys_unlink+0x1c6>
    80005c74:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005c76:	00003517          	auipc	a0,0x3
    80005c7a:	97a50513          	addi	a0,a0,-1670 # 800085f0 <etext+0x5f0>
    80005c7e:	ffffb097          	auipc	ra,0xffffb
    80005c82:	8e2080e7          	jalr	-1822(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c86:	04c92703          	lw	a4,76(s2)
    80005c8a:	02000793          	li	a5,32
    80005c8e:	f6e7f5e3          	bgeu	a5,a4,80005bf8 <sys_unlink+0xa8>
    80005c92:	e5ce                	sd	s3,200(sp)
    80005c94:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c98:	4741                	li	a4,16
    80005c9a:	86ce                	mv	a3,s3
    80005c9c:	f1840613          	addi	a2,s0,-232
    80005ca0:	4581                	li	a1,0
    80005ca2:	854a                	mv	a0,s2
    80005ca4:	ffffe097          	auipc	ra,0xffffe
    80005ca8:	302080e7          	jalr	770(ra) # 80003fa6 <readi>
    80005cac:	47c1                	li	a5,16
    80005cae:	00f51c63          	bne	a0,a5,80005cc6 <sys_unlink+0x176>
    if(de.inum != 0)
    80005cb2:	f1845783          	lhu	a5,-232(s0)
    80005cb6:	e7b5                	bnez	a5,80005d22 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cb8:	29c1                	addiw	s3,s3,16
    80005cba:	04c92783          	lw	a5,76(s2)
    80005cbe:	fcf9ede3          	bltu	s3,a5,80005c98 <sys_unlink+0x148>
    80005cc2:	69ae                	ld	s3,200(sp)
    80005cc4:	bf15                	j	80005bf8 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005cc6:	00003517          	auipc	a0,0x3
    80005cca:	94250513          	addi	a0,a0,-1726 # 80008608 <etext+0x608>
    80005cce:	ffffb097          	auipc	ra,0xffffb
    80005cd2:	892080e7          	jalr	-1902(ra) # 80000560 <panic>
    80005cd6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005cd8:	00003517          	auipc	a0,0x3
    80005cdc:	94850513          	addi	a0,a0,-1720 # 80008620 <etext+0x620>
    80005ce0:	ffffb097          	auipc	ra,0xffffb
    80005ce4:	880080e7          	jalr	-1920(ra) # 80000560 <panic>
    dp->nlink--;
    80005ce8:	04a4d783          	lhu	a5,74(s1)
    80005cec:	37fd                	addiw	a5,a5,-1
    80005cee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005cf2:	8526                	mv	a0,s1
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	f2e080e7          	jalr	-210(ra) # 80003c22 <iupdate>
    80005cfc:	bf0d                	j	80005c2e <sys_unlink+0xde>
    80005cfe:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005d00:	8526                	mv	a0,s1
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	252080e7          	jalr	594(ra) # 80003f54 <iunlockput>
  end_op();
    80005d0a:	fffff097          	auipc	ra,0xfffff
    80005d0e:	a2c080e7          	jalr	-1492(ra) # 80004736 <end_op>
  return -1;
    80005d12:	557d                	li	a0,-1
    80005d14:	64ee                	ld	s1,216(sp)
}
    80005d16:	70ae                	ld	ra,232(sp)
    80005d18:	740e                	ld	s0,224(sp)
    80005d1a:	616d                	addi	sp,sp,240
    80005d1c:	8082                	ret
    return -1;
    80005d1e:	557d                	li	a0,-1
    80005d20:	bfdd                	j	80005d16 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005d22:	854a                	mv	a0,s2
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	230080e7          	jalr	560(ra) # 80003f54 <iunlockput>
    goto bad;
    80005d2c:	694e                	ld	s2,208(sp)
    80005d2e:	69ae                	ld	s3,200(sp)
    80005d30:	bfc1                	j	80005d00 <sys_unlink+0x1b0>

0000000080005d32 <sys_open>:

uint64
sys_open(void)
{
    80005d32:	7131                	addi	sp,sp,-192
    80005d34:	fd06                	sd	ra,184(sp)
    80005d36:	f922                	sd	s0,176(sp)
    80005d38:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d3a:	f4c40593          	addi	a1,s0,-180
    80005d3e:	4505                	li	a0,1
    80005d40:	ffffd097          	auipc	ra,0xffffd
    80005d44:	388080e7          	jalr	904(ra) # 800030c8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d48:	08000613          	li	a2,128
    80005d4c:	f5040593          	addi	a1,s0,-176
    80005d50:	4501                	li	a0,0
    80005d52:	ffffd097          	auipc	ra,0xffffd
    80005d56:	3b6080e7          	jalr	950(ra) # 80003108 <argstr>
    80005d5a:	87aa                	mv	a5,a0
    return -1;
    80005d5c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d5e:	0a07ce63          	bltz	a5,80005e1a <sys_open+0xe8>
    80005d62:	f526                	sd	s1,168(sp)

  begin_op();
    80005d64:	fffff097          	auipc	ra,0xfffff
    80005d68:	958080e7          	jalr	-1704(ra) # 800046bc <begin_op>

  if(omode & O_CREATE){
    80005d6c:	f4c42783          	lw	a5,-180(s0)
    80005d70:	2007f793          	andi	a5,a5,512
    80005d74:	cfd5                	beqz	a5,80005e30 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005d76:	4681                	li	a3,0
    80005d78:	4601                	li	a2,0
    80005d7a:	4589                	li	a1,2
    80005d7c:	f5040513          	addi	a0,s0,-176
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	95c080e7          	jalr	-1700(ra) # 800056dc <create>
    80005d88:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d8a:	cd41                	beqz	a0,80005e22 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d8c:	04449703          	lh	a4,68(s1)
    80005d90:	478d                	li	a5,3
    80005d92:	00f71763          	bne	a4,a5,80005da0 <sys_open+0x6e>
    80005d96:	0464d703          	lhu	a4,70(s1)
    80005d9a:	47a5                	li	a5,9
    80005d9c:	0ee7e163          	bltu	a5,a4,80005e7e <sys_open+0x14c>
    80005da0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005da2:	fffff097          	auipc	ra,0xfffff
    80005da6:	d28080e7          	jalr	-728(ra) # 80004aca <filealloc>
    80005daa:	892a                	mv	s2,a0
    80005dac:	c97d                	beqz	a0,80005ea2 <sys_open+0x170>
    80005dae:	ed4e                	sd	s3,152(sp)
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	8ea080e7          	jalr	-1814(ra) # 8000569a <fdalloc>
    80005db8:	89aa                	mv	s3,a0
    80005dba:	0c054e63          	bltz	a0,80005e96 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dbe:	04449703          	lh	a4,68(s1)
    80005dc2:	478d                	li	a5,3
    80005dc4:	0ef70c63          	beq	a4,a5,80005ebc <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dc8:	4789                	li	a5,2
    80005dca:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005dce:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005dd2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005dd6:	f4c42783          	lw	a5,-180(s0)
    80005dda:	0017c713          	xori	a4,a5,1
    80005dde:	8b05                	andi	a4,a4,1
    80005de0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005de4:	0037f713          	andi	a4,a5,3
    80005de8:	00e03733          	snez	a4,a4
    80005dec:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005df0:	4007f793          	andi	a5,a5,1024
    80005df4:	c791                	beqz	a5,80005e00 <sys_open+0xce>
    80005df6:	04449703          	lh	a4,68(s1)
    80005dfa:	4789                	li	a5,2
    80005dfc:	0cf70763          	beq	a4,a5,80005eca <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005e00:	8526                	mv	a0,s1
    80005e02:	ffffe097          	auipc	ra,0xffffe
    80005e06:	fb2080e7          	jalr	-78(ra) # 80003db4 <iunlock>
  end_op();
    80005e0a:	fffff097          	auipc	ra,0xfffff
    80005e0e:	92c080e7          	jalr	-1748(ra) # 80004736 <end_op>

  return fd;
    80005e12:	854e                	mv	a0,s3
    80005e14:	74aa                	ld	s1,168(sp)
    80005e16:	790a                	ld	s2,160(sp)
    80005e18:	69ea                	ld	s3,152(sp)
}
    80005e1a:	70ea                	ld	ra,184(sp)
    80005e1c:	744a                	ld	s0,176(sp)
    80005e1e:	6129                	addi	sp,sp,192
    80005e20:	8082                	ret
      end_op();
    80005e22:	fffff097          	auipc	ra,0xfffff
    80005e26:	914080e7          	jalr	-1772(ra) # 80004736 <end_op>
      return -1;
    80005e2a:	557d                	li	a0,-1
    80005e2c:	74aa                	ld	s1,168(sp)
    80005e2e:	b7f5                	j	80005e1a <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005e30:	f5040513          	addi	a0,s0,-176
    80005e34:	ffffe097          	auipc	ra,0xffffe
    80005e38:	688080e7          	jalr	1672(ra) # 800044bc <namei>
    80005e3c:	84aa                	mv	s1,a0
    80005e3e:	c90d                	beqz	a0,80005e70 <sys_open+0x13e>
    ilock(ip);
    80005e40:	ffffe097          	auipc	ra,0xffffe
    80005e44:	eae080e7          	jalr	-338(ra) # 80003cee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e48:	04449703          	lh	a4,68(s1)
    80005e4c:	4785                	li	a5,1
    80005e4e:	f2f71fe3          	bne	a4,a5,80005d8c <sys_open+0x5a>
    80005e52:	f4c42783          	lw	a5,-180(s0)
    80005e56:	d7a9                	beqz	a5,80005da0 <sys_open+0x6e>
      iunlockput(ip);
    80005e58:	8526                	mv	a0,s1
    80005e5a:	ffffe097          	auipc	ra,0xffffe
    80005e5e:	0fa080e7          	jalr	250(ra) # 80003f54 <iunlockput>
      end_op();
    80005e62:	fffff097          	auipc	ra,0xfffff
    80005e66:	8d4080e7          	jalr	-1836(ra) # 80004736 <end_op>
      return -1;
    80005e6a:	557d                	li	a0,-1
    80005e6c:	74aa                	ld	s1,168(sp)
    80005e6e:	b775                	j	80005e1a <sys_open+0xe8>
      end_op();
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	8c6080e7          	jalr	-1850(ra) # 80004736 <end_op>
      return -1;
    80005e78:	557d                	li	a0,-1
    80005e7a:	74aa                	ld	s1,168(sp)
    80005e7c:	bf79                	j	80005e1a <sys_open+0xe8>
    iunlockput(ip);
    80005e7e:	8526                	mv	a0,s1
    80005e80:	ffffe097          	auipc	ra,0xffffe
    80005e84:	0d4080e7          	jalr	212(ra) # 80003f54 <iunlockput>
    end_op();
    80005e88:	fffff097          	auipc	ra,0xfffff
    80005e8c:	8ae080e7          	jalr	-1874(ra) # 80004736 <end_op>
    return -1;
    80005e90:	557d                	li	a0,-1
    80005e92:	74aa                	ld	s1,168(sp)
    80005e94:	b759                	j	80005e1a <sys_open+0xe8>
      fileclose(f);
    80005e96:	854a                	mv	a0,s2
    80005e98:	fffff097          	auipc	ra,0xfffff
    80005e9c:	cee080e7          	jalr	-786(ra) # 80004b86 <fileclose>
    80005ea0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	ffffe097          	auipc	ra,0xffffe
    80005ea8:	0b0080e7          	jalr	176(ra) # 80003f54 <iunlockput>
    end_op();
    80005eac:	fffff097          	auipc	ra,0xfffff
    80005eb0:	88a080e7          	jalr	-1910(ra) # 80004736 <end_op>
    return -1;
    80005eb4:	557d                	li	a0,-1
    80005eb6:	74aa                	ld	s1,168(sp)
    80005eb8:	790a                	ld	s2,160(sp)
    80005eba:	b785                	j	80005e1a <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005ebc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005ec0:	04649783          	lh	a5,70(s1)
    80005ec4:	02f91223          	sh	a5,36(s2)
    80005ec8:	b729                	j	80005dd2 <sys_open+0xa0>
    itrunc(ip);
    80005eca:	8526                	mv	a0,s1
    80005ecc:	ffffe097          	auipc	ra,0xffffe
    80005ed0:	f34080e7          	jalr	-204(ra) # 80003e00 <itrunc>
    80005ed4:	b735                	j	80005e00 <sys_open+0xce>

0000000080005ed6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ed6:	7175                	addi	sp,sp,-144
    80005ed8:	e506                	sd	ra,136(sp)
    80005eda:	e122                	sd	s0,128(sp)
    80005edc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ede:	ffffe097          	auipc	ra,0xffffe
    80005ee2:	7de080e7          	jalr	2014(ra) # 800046bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ee6:	08000613          	li	a2,128
    80005eea:	f7040593          	addi	a1,s0,-144
    80005eee:	4501                	li	a0,0
    80005ef0:	ffffd097          	auipc	ra,0xffffd
    80005ef4:	218080e7          	jalr	536(ra) # 80003108 <argstr>
    80005ef8:	02054963          	bltz	a0,80005f2a <sys_mkdir+0x54>
    80005efc:	4681                	li	a3,0
    80005efe:	4601                	li	a2,0
    80005f00:	4585                	li	a1,1
    80005f02:	f7040513          	addi	a0,s0,-144
    80005f06:	fffff097          	auipc	ra,0xfffff
    80005f0a:	7d6080e7          	jalr	2006(ra) # 800056dc <create>
    80005f0e:	cd11                	beqz	a0,80005f2a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f10:	ffffe097          	auipc	ra,0xffffe
    80005f14:	044080e7          	jalr	68(ra) # 80003f54 <iunlockput>
  end_op();
    80005f18:	fffff097          	auipc	ra,0xfffff
    80005f1c:	81e080e7          	jalr	-2018(ra) # 80004736 <end_op>
  return 0;
    80005f20:	4501                	li	a0,0
}
    80005f22:	60aa                	ld	ra,136(sp)
    80005f24:	640a                	ld	s0,128(sp)
    80005f26:	6149                	addi	sp,sp,144
    80005f28:	8082                	ret
    end_op();
    80005f2a:	fffff097          	auipc	ra,0xfffff
    80005f2e:	80c080e7          	jalr	-2036(ra) # 80004736 <end_op>
    return -1;
    80005f32:	557d                	li	a0,-1
    80005f34:	b7fd                	j	80005f22 <sys_mkdir+0x4c>

0000000080005f36 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f36:	7135                	addi	sp,sp,-160
    80005f38:	ed06                	sd	ra,152(sp)
    80005f3a:	e922                	sd	s0,144(sp)
    80005f3c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f3e:	ffffe097          	auipc	ra,0xffffe
    80005f42:	77e080e7          	jalr	1918(ra) # 800046bc <begin_op>
  argint(1, &major);
    80005f46:	f6c40593          	addi	a1,s0,-148
    80005f4a:	4505                	li	a0,1
    80005f4c:	ffffd097          	auipc	ra,0xffffd
    80005f50:	17c080e7          	jalr	380(ra) # 800030c8 <argint>
  argint(2, &minor);
    80005f54:	f6840593          	addi	a1,s0,-152
    80005f58:	4509                	li	a0,2
    80005f5a:	ffffd097          	auipc	ra,0xffffd
    80005f5e:	16e080e7          	jalr	366(ra) # 800030c8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f62:	08000613          	li	a2,128
    80005f66:	f7040593          	addi	a1,s0,-144
    80005f6a:	4501                	li	a0,0
    80005f6c:	ffffd097          	auipc	ra,0xffffd
    80005f70:	19c080e7          	jalr	412(ra) # 80003108 <argstr>
    80005f74:	02054b63          	bltz	a0,80005faa <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f78:	f6841683          	lh	a3,-152(s0)
    80005f7c:	f6c41603          	lh	a2,-148(s0)
    80005f80:	458d                	li	a1,3
    80005f82:	f7040513          	addi	a0,s0,-144
    80005f86:	fffff097          	auipc	ra,0xfffff
    80005f8a:	756080e7          	jalr	1878(ra) # 800056dc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f8e:	cd11                	beqz	a0,80005faa <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f90:	ffffe097          	auipc	ra,0xffffe
    80005f94:	fc4080e7          	jalr	-60(ra) # 80003f54 <iunlockput>
  end_op();
    80005f98:	ffffe097          	auipc	ra,0xffffe
    80005f9c:	79e080e7          	jalr	1950(ra) # 80004736 <end_op>
  return 0;
    80005fa0:	4501                	li	a0,0
}
    80005fa2:	60ea                	ld	ra,152(sp)
    80005fa4:	644a                	ld	s0,144(sp)
    80005fa6:	610d                	addi	sp,sp,160
    80005fa8:	8082                	ret
    end_op();
    80005faa:	ffffe097          	auipc	ra,0xffffe
    80005fae:	78c080e7          	jalr	1932(ra) # 80004736 <end_op>
    return -1;
    80005fb2:	557d                	li	a0,-1
    80005fb4:	b7fd                	j	80005fa2 <sys_mknod+0x6c>

0000000080005fb6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fb6:	7135                	addi	sp,sp,-160
    80005fb8:	ed06                	sd	ra,152(sp)
    80005fba:	e922                	sd	s0,144(sp)
    80005fbc:	e14a                	sd	s2,128(sp)
    80005fbe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fc0:	ffffc097          	auipc	ra,0xffffc
    80005fc4:	d06080e7          	jalr	-762(ra) # 80001cc6 <myproc>
    80005fc8:	892a                	mv	s2,a0
  
  begin_op();
    80005fca:	ffffe097          	auipc	ra,0xffffe
    80005fce:	6f2080e7          	jalr	1778(ra) # 800046bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fd2:	08000613          	li	a2,128
    80005fd6:	f6040593          	addi	a1,s0,-160
    80005fda:	4501                	li	a0,0
    80005fdc:	ffffd097          	auipc	ra,0xffffd
    80005fe0:	12c080e7          	jalr	300(ra) # 80003108 <argstr>
    80005fe4:	04054d63          	bltz	a0,8000603e <sys_chdir+0x88>
    80005fe8:	e526                	sd	s1,136(sp)
    80005fea:	f6040513          	addi	a0,s0,-160
    80005fee:	ffffe097          	auipc	ra,0xffffe
    80005ff2:	4ce080e7          	jalr	1230(ra) # 800044bc <namei>
    80005ff6:	84aa                	mv	s1,a0
    80005ff8:	c131                	beqz	a0,8000603c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ffa:	ffffe097          	auipc	ra,0xffffe
    80005ffe:	cf4080e7          	jalr	-780(ra) # 80003cee <ilock>
  if(ip->type != T_DIR){
    80006002:	04449703          	lh	a4,68(s1)
    80006006:	4785                	li	a5,1
    80006008:	04f71163          	bne	a4,a5,8000604a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000600c:	8526                	mv	a0,s1
    8000600e:	ffffe097          	auipc	ra,0xffffe
    80006012:	da6080e7          	jalr	-602(ra) # 80003db4 <iunlock>
  iput(p->cwd);
    80006016:	15093503          	ld	a0,336(s2)
    8000601a:	ffffe097          	auipc	ra,0xffffe
    8000601e:	e92080e7          	jalr	-366(ra) # 80003eac <iput>
  end_op();
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	714080e7          	jalr	1812(ra) # 80004736 <end_op>
  p->cwd = ip;
    8000602a:	14993823          	sd	s1,336(s2)
  return 0;
    8000602e:	4501                	li	a0,0
    80006030:	64aa                	ld	s1,136(sp)
}
    80006032:	60ea                	ld	ra,152(sp)
    80006034:	644a                	ld	s0,144(sp)
    80006036:	690a                	ld	s2,128(sp)
    80006038:	610d                	addi	sp,sp,160
    8000603a:	8082                	ret
    8000603c:	64aa                	ld	s1,136(sp)
    end_op();
    8000603e:	ffffe097          	auipc	ra,0xffffe
    80006042:	6f8080e7          	jalr	1784(ra) # 80004736 <end_op>
    return -1;
    80006046:	557d                	li	a0,-1
    80006048:	b7ed                	j	80006032 <sys_chdir+0x7c>
    iunlockput(ip);
    8000604a:	8526                	mv	a0,s1
    8000604c:	ffffe097          	auipc	ra,0xffffe
    80006050:	f08080e7          	jalr	-248(ra) # 80003f54 <iunlockput>
    end_op();
    80006054:	ffffe097          	auipc	ra,0xffffe
    80006058:	6e2080e7          	jalr	1762(ra) # 80004736 <end_op>
    return -1;
    8000605c:	557d                	li	a0,-1
    8000605e:	64aa                	ld	s1,136(sp)
    80006060:	bfc9                	j	80006032 <sys_chdir+0x7c>

0000000080006062 <sys_exec>:

uint64
sys_exec(void)
{
    80006062:	7121                	addi	sp,sp,-448
    80006064:	ff06                	sd	ra,440(sp)
    80006066:	fb22                	sd	s0,432(sp)
    80006068:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000606a:	e4840593          	addi	a1,s0,-440
    8000606e:	4505                	li	a0,1
    80006070:	ffffd097          	auipc	ra,0xffffd
    80006074:	078080e7          	jalr	120(ra) # 800030e8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006078:	08000613          	li	a2,128
    8000607c:	f5040593          	addi	a1,s0,-176
    80006080:	4501                	li	a0,0
    80006082:	ffffd097          	auipc	ra,0xffffd
    80006086:	086080e7          	jalr	134(ra) # 80003108 <argstr>
    8000608a:	87aa                	mv	a5,a0
    return -1;
    8000608c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000608e:	0e07c263          	bltz	a5,80006172 <sys_exec+0x110>
    80006092:	f726                	sd	s1,424(sp)
    80006094:	f34a                	sd	s2,416(sp)
    80006096:	ef4e                	sd	s3,408(sp)
    80006098:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000609a:	10000613          	li	a2,256
    8000609e:	4581                	li	a1,0
    800060a0:	e5040513          	addi	a0,s0,-432
    800060a4:	ffffb097          	auipc	ra,0xffffb
    800060a8:	dae080e7          	jalr	-594(ra) # 80000e52 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060ac:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800060b0:	89a6                	mv	s3,s1
    800060b2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800060b4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060b8:	00391513          	slli	a0,s2,0x3
    800060bc:	e4040593          	addi	a1,s0,-448
    800060c0:	e4843783          	ld	a5,-440(s0)
    800060c4:	953e                	add	a0,a0,a5
    800060c6:	ffffd097          	auipc	ra,0xffffd
    800060ca:	f64080e7          	jalr	-156(ra) # 8000302a <fetchaddr>
    800060ce:	02054a63          	bltz	a0,80006102 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800060d2:	e4043783          	ld	a5,-448(s0)
    800060d6:	c7b9                	beqz	a5,80006124 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800060d8:	ffffb097          	auipc	ra,0xffffb
    800060dc:	b50080e7          	jalr	-1200(ra) # 80000c28 <kalloc>
    800060e0:	85aa                	mv	a1,a0
    800060e2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060e6:	cd11                	beqz	a0,80006102 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060e8:	6605                	lui	a2,0x1
    800060ea:	e4043503          	ld	a0,-448(s0)
    800060ee:	ffffd097          	auipc	ra,0xffffd
    800060f2:	f8e080e7          	jalr	-114(ra) # 8000307c <fetchstr>
    800060f6:	00054663          	bltz	a0,80006102 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800060fa:	0905                	addi	s2,s2,1
    800060fc:	09a1                	addi	s3,s3,8
    800060fe:	fb491de3          	bne	s2,s4,800060b8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006102:	f5040913          	addi	s2,s0,-176
    80006106:	6088                	ld	a0,0(s1)
    80006108:	c125                	beqz	a0,80006168 <sys_exec+0x106>
    kfree(argv[i]);
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	940080e7          	jalr	-1728(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006112:	04a1                	addi	s1,s1,8
    80006114:	ff2499e3          	bne	s1,s2,80006106 <sys_exec+0xa4>
  return -1;
    80006118:	557d                	li	a0,-1
    8000611a:	74ba                	ld	s1,424(sp)
    8000611c:	791a                	ld	s2,416(sp)
    8000611e:	69fa                	ld	s3,408(sp)
    80006120:	6a5a                	ld	s4,400(sp)
    80006122:	a881                	j	80006172 <sys_exec+0x110>
      argv[i] = 0;
    80006124:	0009079b          	sext.w	a5,s2
    80006128:	078e                	slli	a5,a5,0x3
    8000612a:	fd078793          	addi	a5,a5,-48
    8000612e:	97a2                	add	a5,a5,s0
    80006130:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006134:	e5040593          	addi	a1,s0,-432
    80006138:	f5040513          	addi	a0,s0,-176
    8000613c:	fffff097          	auipc	ra,0xfffff
    80006140:	120080e7          	jalr	288(ra) # 8000525c <exec>
    80006144:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006146:	f5040993          	addi	s3,s0,-176
    8000614a:	6088                	ld	a0,0(s1)
    8000614c:	c901                	beqz	a0,8000615c <sys_exec+0xfa>
    kfree(argv[i]);
    8000614e:	ffffb097          	auipc	ra,0xffffb
    80006152:	8fc080e7          	jalr	-1796(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006156:	04a1                	addi	s1,s1,8
    80006158:	ff3499e3          	bne	s1,s3,8000614a <sys_exec+0xe8>
  return ret;
    8000615c:	854a                	mv	a0,s2
    8000615e:	74ba                	ld	s1,424(sp)
    80006160:	791a                	ld	s2,416(sp)
    80006162:	69fa                	ld	s3,408(sp)
    80006164:	6a5a                	ld	s4,400(sp)
    80006166:	a031                	j	80006172 <sys_exec+0x110>
  return -1;
    80006168:	557d                	li	a0,-1
    8000616a:	74ba                	ld	s1,424(sp)
    8000616c:	791a                	ld	s2,416(sp)
    8000616e:	69fa                	ld	s3,408(sp)
    80006170:	6a5a                	ld	s4,400(sp)
}
    80006172:	70fa                	ld	ra,440(sp)
    80006174:	745a                	ld	s0,432(sp)
    80006176:	6139                	addi	sp,sp,448
    80006178:	8082                	ret

000000008000617a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000617a:	7139                	addi	sp,sp,-64
    8000617c:	fc06                	sd	ra,56(sp)
    8000617e:	f822                	sd	s0,48(sp)
    80006180:	f426                	sd	s1,40(sp)
    80006182:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006184:	ffffc097          	auipc	ra,0xffffc
    80006188:	b42080e7          	jalr	-1214(ra) # 80001cc6 <myproc>
    8000618c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000618e:	fd840593          	addi	a1,s0,-40
    80006192:	4501                	li	a0,0
    80006194:	ffffd097          	auipc	ra,0xffffd
    80006198:	f54080e7          	jalr	-172(ra) # 800030e8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000619c:	fc840593          	addi	a1,s0,-56
    800061a0:	fd040513          	addi	a0,s0,-48
    800061a4:	fffff097          	auipc	ra,0xfffff
    800061a8:	d50080e7          	jalr	-688(ra) # 80004ef4 <pipealloc>
    return -1;
    800061ac:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061ae:	0c054463          	bltz	a0,80006276 <sys_pipe+0xfc>
  fd0 = -1;
    800061b2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061b6:	fd043503          	ld	a0,-48(s0)
    800061ba:	fffff097          	auipc	ra,0xfffff
    800061be:	4e0080e7          	jalr	1248(ra) # 8000569a <fdalloc>
    800061c2:	fca42223          	sw	a0,-60(s0)
    800061c6:	08054b63          	bltz	a0,8000625c <sys_pipe+0xe2>
    800061ca:	fc843503          	ld	a0,-56(s0)
    800061ce:	fffff097          	auipc	ra,0xfffff
    800061d2:	4cc080e7          	jalr	1228(ra) # 8000569a <fdalloc>
    800061d6:	fca42023          	sw	a0,-64(s0)
    800061da:	06054863          	bltz	a0,8000624a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061de:	4691                	li	a3,4
    800061e0:	fc440613          	addi	a2,s0,-60
    800061e4:	fd843583          	ld	a1,-40(s0)
    800061e8:	68a8                	ld	a0,80(s1)
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	658080e7          	jalr	1624(ra) # 80001842 <copyout>
    800061f2:	02054063          	bltz	a0,80006212 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800061f6:	4691                	li	a3,4
    800061f8:	fc040613          	addi	a2,s0,-64
    800061fc:	fd843583          	ld	a1,-40(s0)
    80006200:	0591                	addi	a1,a1,4
    80006202:	68a8                	ld	a0,80(s1)
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	63e080e7          	jalr	1598(ra) # 80001842 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000620c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000620e:	06055463          	bgez	a0,80006276 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006212:	fc442783          	lw	a5,-60(s0)
    80006216:	07e9                	addi	a5,a5,26
    80006218:	078e                	slli	a5,a5,0x3
    8000621a:	97a6                	add	a5,a5,s1
    8000621c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006220:	fc042783          	lw	a5,-64(s0)
    80006224:	07e9                	addi	a5,a5,26
    80006226:	078e                	slli	a5,a5,0x3
    80006228:	94be                	add	s1,s1,a5
    8000622a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000622e:	fd043503          	ld	a0,-48(s0)
    80006232:	fffff097          	auipc	ra,0xfffff
    80006236:	954080e7          	jalr	-1708(ra) # 80004b86 <fileclose>
    fileclose(wf);
    8000623a:	fc843503          	ld	a0,-56(s0)
    8000623e:	fffff097          	auipc	ra,0xfffff
    80006242:	948080e7          	jalr	-1720(ra) # 80004b86 <fileclose>
    return -1;
    80006246:	57fd                	li	a5,-1
    80006248:	a03d                	j	80006276 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000624a:	fc442783          	lw	a5,-60(s0)
    8000624e:	0007c763          	bltz	a5,8000625c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006252:	07e9                	addi	a5,a5,26
    80006254:	078e                	slli	a5,a5,0x3
    80006256:	97a6                	add	a5,a5,s1
    80006258:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000625c:	fd043503          	ld	a0,-48(s0)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	926080e7          	jalr	-1754(ra) # 80004b86 <fileclose>
    fileclose(wf);
    80006268:	fc843503          	ld	a0,-56(s0)
    8000626c:	fffff097          	auipc	ra,0xfffff
    80006270:	91a080e7          	jalr	-1766(ra) # 80004b86 <fileclose>
    return -1;
    80006274:	57fd                	li	a5,-1
}
    80006276:	853e                	mv	a0,a5
    80006278:	70e2                	ld	ra,56(sp)
    8000627a:	7442                	ld	s0,48(sp)
    8000627c:	74a2                	ld	s1,40(sp)
    8000627e:	6121                	addi	sp,sp,64
    80006280:	8082                	ret
	...

0000000080006290 <kernelvec>:
    80006290:	7111                	addi	sp,sp,-256
    80006292:	e006                	sd	ra,0(sp)
    80006294:	e40a                	sd	sp,8(sp)
    80006296:	e80e                	sd	gp,16(sp)
    80006298:	ec12                	sd	tp,24(sp)
    8000629a:	f016                	sd	t0,32(sp)
    8000629c:	f41a                	sd	t1,40(sp)
    8000629e:	f81e                	sd	t2,48(sp)
    800062a0:	fc22                	sd	s0,56(sp)
    800062a2:	e0a6                	sd	s1,64(sp)
    800062a4:	e4aa                	sd	a0,72(sp)
    800062a6:	e8ae                	sd	a1,80(sp)
    800062a8:	ecb2                	sd	a2,88(sp)
    800062aa:	f0b6                	sd	a3,96(sp)
    800062ac:	f4ba                	sd	a4,104(sp)
    800062ae:	f8be                	sd	a5,112(sp)
    800062b0:	fcc2                	sd	a6,120(sp)
    800062b2:	e146                	sd	a7,128(sp)
    800062b4:	e54a                	sd	s2,136(sp)
    800062b6:	e94e                	sd	s3,144(sp)
    800062b8:	ed52                	sd	s4,152(sp)
    800062ba:	f156                	sd	s5,160(sp)
    800062bc:	f55a                	sd	s6,168(sp)
    800062be:	f95e                	sd	s7,176(sp)
    800062c0:	fd62                	sd	s8,184(sp)
    800062c2:	e1e6                	sd	s9,192(sp)
    800062c4:	e5ea                	sd	s10,200(sp)
    800062c6:	e9ee                	sd	s11,208(sp)
    800062c8:	edf2                	sd	t3,216(sp)
    800062ca:	f1f6                	sd	t4,224(sp)
    800062cc:	f5fa                	sd	t5,232(sp)
    800062ce:	f9fe                	sd	t6,240(sp)
    800062d0:	c27fc0ef          	jal	80002ef6 <kerneltrap>
    800062d4:	6082                	ld	ra,0(sp)
    800062d6:	6122                	ld	sp,8(sp)
    800062d8:	61c2                	ld	gp,16(sp)
    800062da:	7282                	ld	t0,32(sp)
    800062dc:	7322                	ld	t1,40(sp)
    800062de:	73c2                	ld	t2,48(sp)
    800062e0:	7462                	ld	s0,56(sp)
    800062e2:	6486                	ld	s1,64(sp)
    800062e4:	6526                	ld	a0,72(sp)
    800062e6:	65c6                	ld	a1,80(sp)
    800062e8:	6666                	ld	a2,88(sp)
    800062ea:	7686                	ld	a3,96(sp)
    800062ec:	7726                	ld	a4,104(sp)
    800062ee:	77c6                	ld	a5,112(sp)
    800062f0:	7866                	ld	a6,120(sp)
    800062f2:	688a                	ld	a7,128(sp)
    800062f4:	692a                	ld	s2,136(sp)
    800062f6:	69ca                	ld	s3,144(sp)
    800062f8:	6a6a                	ld	s4,152(sp)
    800062fa:	7a8a                	ld	s5,160(sp)
    800062fc:	7b2a                	ld	s6,168(sp)
    800062fe:	7bca                	ld	s7,176(sp)
    80006300:	7c6a                	ld	s8,184(sp)
    80006302:	6c8e                	ld	s9,192(sp)
    80006304:	6d2e                	ld	s10,200(sp)
    80006306:	6dce                	ld	s11,208(sp)
    80006308:	6e6e                	ld	t3,216(sp)
    8000630a:	7e8e                	ld	t4,224(sp)
    8000630c:	7f2e                	ld	t5,232(sp)
    8000630e:	7fce                	ld	t6,240(sp)
    80006310:	6111                	addi	sp,sp,256
    80006312:	10200073          	sret
    80006316:	00000013          	nop
    8000631a:	00000013          	nop
    8000631e:	0001                	nop

0000000080006320 <timervec>:
    80006320:	34051573          	csrrw	a0,mscratch,a0
    80006324:	e10c                	sd	a1,0(a0)
    80006326:	e510                	sd	a2,8(a0)
    80006328:	e914                	sd	a3,16(a0)
    8000632a:	6d0c                	ld	a1,24(a0)
    8000632c:	7110                	ld	a2,32(a0)
    8000632e:	6194                	ld	a3,0(a1)
    80006330:	96b2                	add	a3,a3,a2
    80006332:	e194                	sd	a3,0(a1)
    80006334:	4589                	li	a1,2
    80006336:	14459073          	csrw	sip,a1
    8000633a:	6914                	ld	a3,16(a0)
    8000633c:	6510                	ld	a2,8(a0)
    8000633e:	610c                	ld	a1,0(a0)
    80006340:	34051573          	csrrw	a0,mscratch,a0
    80006344:	30200073          	mret
	...

000000008000634a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000634a:	1141                	addi	sp,sp,-16
    8000634c:	e422                	sd	s0,8(sp)
    8000634e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006350:	0c0007b7          	lui	a5,0xc000
    80006354:	4705                	li	a4,1
    80006356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006358:	0c0007b7          	lui	a5,0xc000
    8000635c:	c3d8                	sw	a4,4(a5)
}
    8000635e:	6422                	ld	s0,8(sp)
    80006360:	0141                	addi	sp,sp,16
    80006362:	8082                	ret

0000000080006364 <plicinithart>:

void
plicinithart(void)
{
    80006364:	1141                	addi	sp,sp,-16
    80006366:	e406                	sd	ra,8(sp)
    80006368:	e022                	sd	s0,0(sp)
    8000636a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000636c:	ffffc097          	auipc	ra,0xffffc
    80006370:	92e080e7          	jalr	-1746(ra) # 80001c9a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006374:	0085171b          	slliw	a4,a0,0x8
    80006378:	0c0027b7          	lui	a5,0xc002
    8000637c:	97ba                	add	a5,a5,a4
    8000637e:	40200713          	li	a4,1026
    80006382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006386:	00d5151b          	slliw	a0,a0,0xd
    8000638a:	0c2017b7          	lui	a5,0xc201
    8000638e:	97aa                	add	a5,a5,a0
    80006390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006394:	60a2                	ld	ra,8(sp)
    80006396:	6402                	ld	s0,0(sp)
    80006398:	0141                	addi	sp,sp,16
    8000639a:	8082                	ret

000000008000639c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000639c:	1141                	addi	sp,sp,-16
    8000639e:	e406                	sd	ra,8(sp)
    800063a0:	e022                	sd	s0,0(sp)
    800063a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063a4:	ffffc097          	auipc	ra,0xffffc
    800063a8:	8f6080e7          	jalr	-1802(ra) # 80001c9a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063ac:	00d5151b          	slliw	a0,a0,0xd
    800063b0:	0c2017b7          	lui	a5,0xc201
    800063b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800063b6:	43c8                	lw	a0,4(a5)
    800063b8:	60a2                	ld	ra,8(sp)
    800063ba:	6402                	ld	s0,0(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret

00000000800063c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063c0:	1101                	addi	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	addi	s0,sp,32
    800063ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063cc:	ffffc097          	auipc	ra,0xffffc
    800063d0:	8ce080e7          	jalr	-1842(ra) # 80001c9a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063d4:	00d5151b          	slliw	a0,a0,0xd
    800063d8:	0c2017b7          	lui	a5,0xc201
    800063dc:	97aa                	add	a5,a5,a0
    800063de:	c3c4                	sw	s1,4(a5)
}
    800063e0:	60e2                	ld	ra,24(sp)
    800063e2:	6442                	ld	s0,16(sp)
    800063e4:	64a2                	ld	s1,8(sp)
    800063e6:	6105                	addi	sp,sp,32
    800063e8:	8082                	ret

00000000800063ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063ea:	1141                	addi	sp,sp,-16
    800063ec:	e406                	sd	ra,8(sp)
    800063ee:	e022                	sd	s0,0(sp)
    800063f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063f2:	479d                	li	a5,7
    800063f4:	04a7cc63          	blt	a5,a0,8000644c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063f8:	0003c797          	auipc	a5,0x3c
    800063fc:	c3078793          	addi	a5,a5,-976 # 80042028 <disk>
    80006400:	97aa                	add	a5,a5,a0
    80006402:	0187c783          	lbu	a5,24(a5)
    80006406:	ebb9                	bnez	a5,8000645c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006408:	00451693          	slli	a3,a0,0x4
    8000640c:	0003c797          	auipc	a5,0x3c
    80006410:	c1c78793          	addi	a5,a5,-996 # 80042028 <disk>
    80006414:	6398                	ld	a4,0(a5)
    80006416:	9736                	add	a4,a4,a3
    80006418:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000641c:	6398                	ld	a4,0(a5)
    8000641e:	9736                	add	a4,a4,a3
    80006420:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006424:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006428:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000642c:	97aa                	add	a5,a5,a0
    8000642e:	4705                	li	a4,1
    80006430:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006434:	0003c517          	auipc	a0,0x3c
    80006438:	c0c50513          	addi	a0,a0,-1012 # 80042040 <disk+0x18>
    8000643c:	ffffc097          	auipc	ra,0xffffc
    80006440:	fac080e7          	jalr	-84(ra) # 800023e8 <wakeup>
}
    80006444:	60a2                	ld	ra,8(sp)
    80006446:	6402                	ld	s0,0(sp)
    80006448:	0141                	addi	sp,sp,16
    8000644a:	8082                	ret
    panic("free_desc 1");
    8000644c:	00002517          	auipc	a0,0x2
    80006450:	1e450513          	addi	a0,a0,484 # 80008630 <etext+0x630>
    80006454:	ffffa097          	auipc	ra,0xffffa
    80006458:	10c080e7          	jalr	268(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000645c:	00002517          	auipc	a0,0x2
    80006460:	1e450513          	addi	a0,a0,484 # 80008640 <etext+0x640>
    80006464:	ffffa097          	auipc	ra,0xffffa
    80006468:	0fc080e7          	jalr	252(ra) # 80000560 <panic>

000000008000646c <virtio_disk_init>:
{
    8000646c:	1101                	addi	sp,sp,-32
    8000646e:	ec06                	sd	ra,24(sp)
    80006470:	e822                	sd	s0,16(sp)
    80006472:	e426                	sd	s1,8(sp)
    80006474:	e04a                	sd	s2,0(sp)
    80006476:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006478:	00002597          	auipc	a1,0x2
    8000647c:	1d858593          	addi	a1,a1,472 # 80008650 <etext+0x650>
    80006480:	0003c517          	auipc	a0,0x3c
    80006484:	cd050513          	addi	a0,a0,-816 # 80042150 <disk+0x128>
    80006488:	ffffb097          	auipc	ra,0xffffb
    8000648c:	83e080e7          	jalr	-1986(ra) # 80000cc6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006490:	100017b7          	lui	a5,0x10001
    80006494:	4398                	lw	a4,0(a5)
    80006496:	2701                	sext.w	a4,a4
    80006498:	747277b7          	lui	a5,0x74727
    8000649c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064a0:	18f71c63          	bne	a4,a5,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064a4:	100017b7          	lui	a5,0x10001
    800064a8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800064aa:	439c                	lw	a5,0(a5)
    800064ac:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064ae:	4709                	li	a4,2
    800064b0:	18e79463          	bne	a5,a4,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064b4:	100017b7          	lui	a5,0x10001
    800064b8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800064ba:	439c                	lw	a5,0(a5)
    800064bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064be:	16e79d63          	bne	a5,a4,80006638 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064c2:	100017b7          	lui	a5,0x10001
    800064c6:	47d8                	lw	a4,12(a5)
    800064c8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064ca:	554d47b7          	lui	a5,0x554d4
    800064ce:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064d2:	16f71363          	bne	a4,a5,80006638 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064d6:	100017b7          	lui	a5,0x10001
    800064da:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064de:	4705                	li	a4,1
    800064e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064e2:	470d                	li	a4,3
    800064e4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064e6:	10001737          	lui	a4,0x10001
    800064ea:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800064ec:	c7ffe737          	lui	a4,0xc7ffe
    800064f0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fbc5f7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064f4:	8ef9                	and	a3,a3,a4
    800064f6:	10001737          	lui	a4,0x10001
    800064fa:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064fc:	472d                	li	a4,11
    800064fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006500:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006504:	439c                	lw	a5,0(a5)
    80006506:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000650a:	8ba1                	andi	a5,a5,8
    8000650c:	12078e63          	beqz	a5,80006648 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006510:	100017b7          	lui	a5,0x10001
    80006514:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006518:	100017b7          	lui	a5,0x10001
    8000651c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006520:	439c                	lw	a5,0(a5)
    80006522:	2781                	sext.w	a5,a5
    80006524:	12079a63          	bnez	a5,80006658 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006528:	100017b7          	lui	a5,0x10001
    8000652c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006530:	439c                	lw	a5,0(a5)
    80006532:	2781                	sext.w	a5,a5
  if(max == 0)
    80006534:	12078a63          	beqz	a5,80006668 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006538:	471d                	li	a4,7
    8000653a:	12f77f63          	bgeu	a4,a5,80006678 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000653e:	ffffa097          	auipc	ra,0xffffa
    80006542:	6ea080e7          	jalr	1770(ra) # 80000c28 <kalloc>
    80006546:	0003c497          	auipc	s1,0x3c
    8000654a:	ae248493          	addi	s1,s1,-1310 # 80042028 <disk>
    8000654e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006550:	ffffa097          	auipc	ra,0xffffa
    80006554:	6d8080e7          	jalr	1752(ra) # 80000c28 <kalloc>
    80006558:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000655a:	ffffa097          	auipc	ra,0xffffa
    8000655e:	6ce080e7          	jalr	1742(ra) # 80000c28 <kalloc>
    80006562:	87aa                	mv	a5,a0
    80006564:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006566:	6088                	ld	a0,0(s1)
    80006568:	12050063          	beqz	a0,80006688 <virtio_disk_init+0x21c>
    8000656c:	0003c717          	auipc	a4,0x3c
    80006570:	ac473703          	ld	a4,-1340(a4) # 80042030 <disk+0x8>
    80006574:	10070a63          	beqz	a4,80006688 <virtio_disk_init+0x21c>
    80006578:	10078863          	beqz	a5,80006688 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000657c:	6605                	lui	a2,0x1
    8000657e:	4581                	li	a1,0
    80006580:	ffffb097          	auipc	ra,0xffffb
    80006584:	8d2080e7          	jalr	-1838(ra) # 80000e52 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006588:	0003c497          	auipc	s1,0x3c
    8000658c:	aa048493          	addi	s1,s1,-1376 # 80042028 <disk>
    80006590:	6605                	lui	a2,0x1
    80006592:	4581                	li	a1,0
    80006594:	6488                	ld	a0,8(s1)
    80006596:	ffffb097          	auipc	ra,0xffffb
    8000659a:	8bc080e7          	jalr	-1860(ra) # 80000e52 <memset>
  memset(disk.used, 0, PGSIZE);
    8000659e:	6605                	lui	a2,0x1
    800065a0:	4581                	li	a1,0
    800065a2:	6888                	ld	a0,16(s1)
    800065a4:	ffffb097          	auipc	ra,0xffffb
    800065a8:	8ae080e7          	jalr	-1874(ra) # 80000e52 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800065ac:	100017b7          	lui	a5,0x10001
    800065b0:	4721                	li	a4,8
    800065b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065b4:	4098                	lw	a4,0(s1)
    800065b6:	100017b7          	lui	a5,0x10001
    800065ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065be:	40d8                	lw	a4,4(s1)
    800065c0:	100017b7          	lui	a5,0x10001
    800065c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065c8:	649c                	ld	a5,8(s1)
    800065ca:	0007869b          	sext.w	a3,a5
    800065ce:	10001737          	lui	a4,0x10001
    800065d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800065d6:	9781                	srai	a5,a5,0x20
    800065d8:	10001737          	lui	a4,0x10001
    800065dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800065e0:	689c                	ld	a5,16(s1)
    800065e2:	0007869b          	sext.w	a3,a5
    800065e6:	10001737          	lui	a4,0x10001
    800065ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800065ee:	9781                	srai	a5,a5,0x20
    800065f0:	10001737          	lui	a4,0x10001
    800065f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800065f8:	10001737          	lui	a4,0x10001
    800065fc:	4785                	li	a5,1
    800065fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006600:	00f48c23          	sb	a5,24(s1)
    80006604:	00f48ca3          	sb	a5,25(s1)
    80006608:	00f48d23          	sb	a5,26(s1)
    8000660c:	00f48da3          	sb	a5,27(s1)
    80006610:	00f48e23          	sb	a5,28(s1)
    80006614:	00f48ea3          	sb	a5,29(s1)
    80006618:	00f48f23          	sb	a5,30(s1)
    8000661c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006620:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006624:	100017b7          	lui	a5,0x10001
    80006628:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000662c:	60e2                	ld	ra,24(sp)
    8000662e:	6442                	ld	s0,16(sp)
    80006630:	64a2                	ld	s1,8(sp)
    80006632:	6902                	ld	s2,0(sp)
    80006634:	6105                	addi	sp,sp,32
    80006636:	8082                	ret
    panic("could not find virtio disk");
    80006638:	00002517          	auipc	a0,0x2
    8000663c:	02850513          	addi	a0,a0,40 # 80008660 <etext+0x660>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f20080e7          	jalr	-224(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	03850513          	addi	a0,a0,56 # 80008680 <etext+0x680>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	f10080e7          	jalr	-240(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	04850513          	addi	a0,a0,72 # 800086a0 <etext+0x6a0>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	05850513          	addi	a0,a0,88 # 800086c0 <etext+0x6c0>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006678:	00002517          	auipc	a0,0x2
    8000667c:	06850513          	addi	a0,a0,104 # 800086e0 <etext+0x6e0>
    80006680:	ffffa097          	auipc	ra,0xffffa
    80006684:	ee0080e7          	jalr	-288(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	07850513          	addi	a0,a0,120 # 80008700 <etext+0x700>
    80006690:	ffffa097          	auipc	ra,0xffffa
    80006694:	ed0080e7          	jalr	-304(ra) # 80000560 <panic>

0000000080006698 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006698:	7159                	addi	sp,sp,-112
    8000669a:	f486                	sd	ra,104(sp)
    8000669c:	f0a2                	sd	s0,96(sp)
    8000669e:	eca6                	sd	s1,88(sp)
    800066a0:	e8ca                	sd	s2,80(sp)
    800066a2:	e4ce                	sd	s3,72(sp)
    800066a4:	e0d2                	sd	s4,64(sp)
    800066a6:	fc56                	sd	s5,56(sp)
    800066a8:	f85a                	sd	s6,48(sp)
    800066aa:	f45e                	sd	s7,40(sp)
    800066ac:	f062                	sd	s8,32(sp)
    800066ae:	ec66                	sd	s9,24(sp)
    800066b0:	1880                	addi	s0,sp,112
    800066b2:	8a2a                	mv	s4,a0
    800066b4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066b6:	00c52c83          	lw	s9,12(a0)
    800066ba:	001c9c9b          	slliw	s9,s9,0x1
    800066be:	1c82                	slli	s9,s9,0x20
    800066c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800066c4:	0003c517          	auipc	a0,0x3c
    800066c8:	a8c50513          	addi	a0,a0,-1396 # 80042150 <disk+0x128>
    800066cc:	ffffa097          	auipc	ra,0xffffa
    800066d0:	68a080e7          	jalr	1674(ra) # 80000d56 <acquire>
  for(int i = 0; i < 3; i++){
    800066d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800066d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066d8:	0003cb17          	auipc	s6,0x3c
    800066dc:	950b0b13          	addi	s6,s6,-1712 # 80042028 <disk>
  for(int i = 0; i < 3; i++){
    800066e0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066e2:	0003cc17          	auipc	s8,0x3c
    800066e6:	a6ec0c13          	addi	s8,s8,-1426 # 80042150 <disk+0x128>
    800066ea:	a0ad                	j	80006754 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800066ec:	00fb0733          	add	a4,s6,a5
    800066f0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800066f4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066f6:	0207c563          	bltz	a5,80006720 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800066fa:	2905                	addiw	s2,s2,1
    800066fc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800066fe:	05590f63          	beq	s2,s5,8000675c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006702:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006704:	0003c717          	auipc	a4,0x3c
    80006708:	92470713          	addi	a4,a4,-1756 # 80042028 <disk>
    8000670c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000670e:	01874683          	lbu	a3,24(a4)
    80006712:	fee9                	bnez	a3,800066ec <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006714:	2785                	addiw	a5,a5,1
    80006716:	0705                	addi	a4,a4,1
    80006718:	fe979be3          	bne	a5,s1,8000670e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000671c:	57fd                	li	a5,-1
    8000671e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006720:	03205163          	blez	s2,80006742 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006724:	f9042503          	lw	a0,-112(s0)
    80006728:	00000097          	auipc	ra,0x0
    8000672c:	cc2080e7          	jalr	-830(ra) # 800063ea <free_desc>
      for(int j = 0; j < i; j++)
    80006730:	4785                	li	a5,1
    80006732:	0127d863          	bge	a5,s2,80006742 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006736:	f9442503          	lw	a0,-108(s0)
    8000673a:	00000097          	auipc	ra,0x0
    8000673e:	cb0080e7          	jalr	-848(ra) # 800063ea <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006742:	85e2                	mv	a1,s8
    80006744:	0003c517          	auipc	a0,0x3c
    80006748:	8fc50513          	addi	a0,a0,-1796 # 80042040 <disk+0x18>
    8000674c:	ffffc097          	auipc	ra,0xffffc
    80006750:	c38080e7          	jalr	-968(ra) # 80002384 <sleep>
  for(int i = 0; i < 3; i++){
    80006754:	f9040613          	addi	a2,s0,-112
    80006758:	894e                	mv	s2,s3
    8000675a:	b765                	j	80006702 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000675c:	f9042503          	lw	a0,-112(s0)
    80006760:	00451693          	slli	a3,a0,0x4

  if(write)
    80006764:	0003c797          	auipc	a5,0x3c
    80006768:	8c478793          	addi	a5,a5,-1852 # 80042028 <disk>
    8000676c:	00a50713          	addi	a4,a0,10
    80006770:	0712                	slli	a4,a4,0x4
    80006772:	973e                	add	a4,a4,a5
    80006774:	01703633          	snez	a2,s7
    80006778:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000677a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000677e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006782:	6398                	ld	a4,0(a5)
    80006784:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006786:	0a868613          	addi	a2,a3,168
    8000678a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000678c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000678e:	6390                	ld	a2,0(a5)
    80006790:	00d605b3          	add	a1,a2,a3
    80006794:	4741                	li	a4,16
    80006796:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006798:	4805                	li	a6,1
    8000679a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000679e:	f9442703          	lw	a4,-108(s0)
    800067a2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800067a6:	0712                	slli	a4,a4,0x4
    800067a8:	963a                	add	a2,a2,a4
    800067aa:	058a0593          	addi	a1,s4,88
    800067ae:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067b0:	0007b883          	ld	a7,0(a5)
    800067b4:	9746                	add	a4,a4,a7
    800067b6:	40000613          	li	a2,1024
    800067ba:	c710                	sw	a2,8(a4)
  if(write)
    800067bc:	001bb613          	seqz	a2,s7
    800067c0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800067c4:	00166613          	ori	a2,a2,1
    800067c8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800067cc:	f9842583          	lw	a1,-104(s0)
    800067d0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067d4:	00250613          	addi	a2,a0,2
    800067d8:	0612                	slli	a2,a2,0x4
    800067da:	963e                	add	a2,a2,a5
    800067dc:	577d                	li	a4,-1
    800067de:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067e2:	0592                	slli	a1,a1,0x4
    800067e4:	98ae                	add	a7,a7,a1
    800067e6:	03068713          	addi	a4,a3,48
    800067ea:	973e                	add	a4,a4,a5
    800067ec:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800067f0:	6398                	ld	a4,0(a5)
    800067f2:	972e                	add	a4,a4,a1
    800067f4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067f8:	4689                	li	a3,2
    800067fa:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800067fe:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006802:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006806:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000680a:	6794                	ld	a3,8(a5)
    8000680c:	0026d703          	lhu	a4,2(a3)
    80006810:	8b1d                	andi	a4,a4,7
    80006812:	0706                	slli	a4,a4,0x1
    80006814:	96ba                	add	a3,a3,a4
    80006816:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000681a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000681e:	6798                	ld	a4,8(a5)
    80006820:	00275783          	lhu	a5,2(a4)
    80006824:	2785                	addiw	a5,a5,1
    80006826:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000682a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000682e:	100017b7          	lui	a5,0x10001
    80006832:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006836:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000683a:	0003c917          	auipc	s2,0x3c
    8000683e:	91690913          	addi	s2,s2,-1770 # 80042150 <disk+0x128>
  while(b->disk == 1) {
    80006842:	4485                	li	s1,1
    80006844:	01079c63          	bne	a5,a6,8000685c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006848:	85ca                	mv	a1,s2
    8000684a:	8552                	mv	a0,s4
    8000684c:	ffffc097          	auipc	ra,0xffffc
    80006850:	b38080e7          	jalr	-1224(ra) # 80002384 <sleep>
  while(b->disk == 1) {
    80006854:	004a2783          	lw	a5,4(s4)
    80006858:	fe9788e3          	beq	a5,s1,80006848 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000685c:	f9042903          	lw	s2,-112(s0)
    80006860:	00290713          	addi	a4,s2,2
    80006864:	0712                	slli	a4,a4,0x4
    80006866:	0003b797          	auipc	a5,0x3b
    8000686a:	7c278793          	addi	a5,a5,1986 # 80042028 <disk>
    8000686e:	97ba                	add	a5,a5,a4
    80006870:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006874:	0003b997          	auipc	s3,0x3b
    80006878:	7b498993          	addi	s3,s3,1972 # 80042028 <disk>
    8000687c:	00491713          	slli	a4,s2,0x4
    80006880:	0009b783          	ld	a5,0(s3)
    80006884:	97ba                	add	a5,a5,a4
    80006886:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000688a:	854a                	mv	a0,s2
    8000688c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006890:	00000097          	auipc	ra,0x0
    80006894:	b5a080e7          	jalr	-1190(ra) # 800063ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006898:	8885                	andi	s1,s1,1
    8000689a:	f0ed                	bnez	s1,8000687c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000689c:	0003c517          	auipc	a0,0x3c
    800068a0:	8b450513          	addi	a0,a0,-1868 # 80042150 <disk+0x128>
    800068a4:	ffffa097          	auipc	ra,0xffffa
    800068a8:	566080e7          	jalr	1382(ra) # 80000e0a <release>
}
    800068ac:	70a6                	ld	ra,104(sp)
    800068ae:	7406                	ld	s0,96(sp)
    800068b0:	64e6                	ld	s1,88(sp)
    800068b2:	6946                	ld	s2,80(sp)
    800068b4:	69a6                	ld	s3,72(sp)
    800068b6:	6a06                	ld	s4,64(sp)
    800068b8:	7ae2                	ld	s5,56(sp)
    800068ba:	7b42                	ld	s6,48(sp)
    800068bc:	7ba2                	ld	s7,40(sp)
    800068be:	7c02                	ld	s8,32(sp)
    800068c0:	6ce2                	ld	s9,24(sp)
    800068c2:	6165                	addi	sp,sp,112
    800068c4:	8082                	ret

00000000800068c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068c6:	1101                	addi	sp,sp,-32
    800068c8:	ec06                	sd	ra,24(sp)
    800068ca:	e822                	sd	s0,16(sp)
    800068cc:	e426                	sd	s1,8(sp)
    800068ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068d0:	0003b497          	auipc	s1,0x3b
    800068d4:	75848493          	addi	s1,s1,1880 # 80042028 <disk>
    800068d8:	0003c517          	auipc	a0,0x3c
    800068dc:	87850513          	addi	a0,a0,-1928 # 80042150 <disk+0x128>
    800068e0:	ffffa097          	auipc	ra,0xffffa
    800068e4:	476080e7          	jalr	1142(ra) # 80000d56 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068e8:	100017b7          	lui	a5,0x10001
    800068ec:	53b8                	lw	a4,96(a5)
    800068ee:	8b0d                	andi	a4,a4,3
    800068f0:	100017b7          	lui	a5,0x10001
    800068f4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800068f6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068fa:	689c                	ld	a5,16(s1)
    800068fc:	0204d703          	lhu	a4,32(s1)
    80006900:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006904:	04f70863          	beq	a4,a5,80006954 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006908:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000690c:	6898                	ld	a4,16(s1)
    8000690e:	0204d783          	lhu	a5,32(s1)
    80006912:	8b9d                	andi	a5,a5,7
    80006914:	078e                	slli	a5,a5,0x3
    80006916:	97ba                	add	a5,a5,a4
    80006918:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000691a:	00278713          	addi	a4,a5,2
    8000691e:	0712                	slli	a4,a4,0x4
    80006920:	9726                	add	a4,a4,s1
    80006922:	01074703          	lbu	a4,16(a4)
    80006926:	e721                	bnez	a4,8000696e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006928:	0789                	addi	a5,a5,2
    8000692a:	0792                	slli	a5,a5,0x4
    8000692c:	97a6                	add	a5,a5,s1
    8000692e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006930:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006934:	ffffc097          	auipc	ra,0xffffc
    80006938:	ab4080e7          	jalr	-1356(ra) # 800023e8 <wakeup>

    disk.used_idx += 1;
    8000693c:	0204d783          	lhu	a5,32(s1)
    80006940:	2785                	addiw	a5,a5,1
    80006942:	17c2                	slli	a5,a5,0x30
    80006944:	93c1                	srli	a5,a5,0x30
    80006946:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000694a:	6898                	ld	a4,16(s1)
    8000694c:	00275703          	lhu	a4,2(a4)
    80006950:	faf71ce3          	bne	a4,a5,80006908 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006954:	0003b517          	auipc	a0,0x3b
    80006958:	7fc50513          	addi	a0,a0,2044 # 80042150 <disk+0x128>
    8000695c:	ffffa097          	auipc	ra,0xffffa
    80006960:	4ae080e7          	jalr	1198(ra) # 80000e0a <release>
}
    80006964:	60e2                	ld	ra,24(sp)
    80006966:	6442                	ld	s0,16(sp)
    80006968:	64a2                	ld	s1,8(sp)
    8000696a:	6105                	addi	sp,sp,32
    8000696c:	8082                	ret
      panic("virtio_disk_intr status");
    8000696e:	00002517          	auipc	a0,0x2
    80006972:	daa50513          	addi	a0,a0,-598 # 80008718 <etext+0x718>
    80006976:	ffffa097          	auipc	ra,0xffffa
    8000697a:	bea080e7          	jalr	-1046(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
