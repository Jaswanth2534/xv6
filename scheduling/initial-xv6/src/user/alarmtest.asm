
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <dummy_handler>:

//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void dummy_handler()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    sigalarm(0, 0);
   8:	4581                	li	a1,0
   a:	4501                	li	a0,0
   c:	00000097          	auipc	ra,0x0
  10:	7d0080e7          	jalr	2000(ra) # 7dc <sigalarm>
    sigreturn();
  14:	00000097          	auipc	ra,0x0
  18:	7d0080e7          	jalr	2000(ra) # 7e4 <sigreturn>
}
  1c:	60a2                	ld	ra,8(sp)
  1e:	6402                	ld	s0,0(sp)
  20:	0141                	addi	sp,sp,16
  22:	8082                	ret

0000000000000024 <periodic>:

void periodic()
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
    count = count + 1;
  2c:	00001797          	auipc	a5,0x1
  30:	5547a783          	lw	a5,1364(a5) # 1580 <count>
  34:	2785                	addiw	a5,a5,1
  36:	00001717          	auipc	a4,0x1
  3a:	54f72523          	sw	a5,1354(a4) # 1580 <count>
    printf("alarm!\n");
  3e:	00001517          	auipc	a0,0x1
  42:	c4250513          	addi	a0,a0,-958 # c80 <malloc+0x10c>
  46:	00001097          	auipc	ra,0x1
  4a:	a76080e7          	jalr	-1418(ra) # abc <printf>
    sigreturn();
  4e:	00000097          	auipc	ra,0x0
  52:	796080e7          	jalr	1942(ra) # 7e4 <sigreturn>
}
  56:	60a2                	ld	ra,8(sp)
  58:	6402                	ld	s0,0(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <slow_handler>:
    else
        printf("test3 passed\n");
}

void slow_handler()
{
  5e:	1101                	addi	sp,sp,-32
  60:	ec06                	sd	ra,24(sp)
  62:	e822                	sd	s0,16(sp)
  64:	e426                	sd	s1,8(sp)
  66:	1000                	addi	s0,sp,32
    count++;
  68:	00001497          	auipc	s1,0x1
  6c:	51848493          	addi	s1,s1,1304 # 1580 <count>
  70:	00001797          	auipc	a5,0x1
  74:	5107a783          	lw	a5,1296(a5) # 1580 <count>
  78:	2785                	addiw	a5,a5,1
  7a:	c09c                	sw	a5,0(s1)
    printf("alarm!\n");
  7c:	00001517          	auipc	a0,0x1
  80:	c0450513          	addi	a0,a0,-1020 # c80 <malloc+0x10c>
  84:	00001097          	auipc	ra,0x1
  88:	a38080e7          	jalr	-1480(ra) # abc <printf>
    if (count > 1)
  8c:	4098                	lw	a4,0(s1)
  8e:	2701                	sext.w	a4,a4
  90:	4685                	li	a3,1
  92:	1dcd67b7          	lui	a5,0x1dcd6
  96:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd4f70>
  9a:	02e6c463          	blt	a3,a4,c2 <slow_handler+0x64>
        exit(1);
    }

    for (int i = 0; i < 1000 * 500000; i++)
    {
        asm volatile("nop"); // avoid compiler optimizing away loop
  9e:	0001                	nop
    for (int i = 0; i < 1000 * 500000; i++)
  a0:	37fd                	addiw	a5,a5,-1
  a2:	fff5                	bnez	a5,9e <slow_handler+0x40>
    }
    sigalarm(0, 0);
  a4:	4581                	li	a1,0
  a6:	4501                	li	a0,0
  a8:	00000097          	auipc	ra,0x0
  ac:	734080e7          	jalr	1844(ra) # 7dc <sigalarm>
    sigreturn();
  b0:	00000097          	auipc	ra,0x0
  b4:	734080e7          	jalr	1844(ra) # 7e4 <sigreturn>
  b8:	60e2                	ld	ra,24(sp)
  ba:	6442                	ld	s0,16(sp)
  bc:	64a2                	ld	s1,8(sp)
  be:	6105                	addi	sp,sp,32
  c0:	8082                	ret
        printf("test2 failed: alarm handler called more than once\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	bc650513          	addi	a0,a0,-1082 # c88 <malloc+0x114>
  ca:	00001097          	auipc	ra,0x1
  ce:	9f2080e7          	jalr	-1550(ra) # abc <printf>
        exit(1);
  d2:	4505                	li	a0,1
  d4:	00000097          	auipc	ra,0x0
  d8:	658080e7          	jalr	1624(ra) # 72c <exit>

00000000000000dc <test0>:
{
  dc:	7139                	addi	sp,sp,-64
  de:	fc06                	sd	ra,56(sp)
  e0:	f822                	sd	s0,48(sp)
  e2:	f426                	sd	s1,40(sp)
  e4:	f04a                	sd	s2,32(sp)
  e6:	ec4e                	sd	s3,24(sp)
  e8:	e852                	sd	s4,16(sp)
  ea:	e456                	sd	s5,8(sp)
  ec:	0080                	addi	s0,sp,64
    printf("test0 start\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	bd250513          	addi	a0,a0,-1070 # cc0 <malloc+0x14c>
  f6:	00001097          	auipc	ra,0x1
  fa:	9c6080e7          	jalr	-1594(ra) # abc <printf>
    count = 0;
  fe:	00001797          	auipc	a5,0x1
 102:	4807a123          	sw	zero,1154(a5) # 1580 <count>
    printf("%p\n",periodic);
 106:	00000597          	auipc	a1,0x0
 10a:	f1e58593          	addi	a1,a1,-226 # 24 <periodic>
 10e:	00001517          	auipc	a0,0x1
 112:	bc250513          	addi	a0,a0,-1086 # cd0 <malloc+0x15c>
 116:	00001097          	auipc	ra,0x1
 11a:	9a6080e7          	jalr	-1626(ra) # abc <printf>
    sigalarm(2,periodic);
 11e:	00000597          	auipc	a1,0x0
 122:	f0658593          	addi	a1,a1,-250 # 24 <periodic>
 126:	4509                	li	a0,2
 128:	00000097          	auipc	ra,0x0
 12c:	6b4080e7          	jalr	1716(ra) # 7dc <sigalarm>
    for (i = 0; i < 1000 * 500000; i++)
 130:	4481                	li	s1,0
        if ((i % 1000000) == 0)
 132:	000f4937          	lui	s2,0xf4
 136:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf2cb0>
            write(2, ".", 1);
 13a:	00001a97          	auipc	s5,0x1
 13e:	b9ea8a93          	addi	s5,s5,-1122 # cd8 <malloc+0x164>
        if (count > 0)
 142:	00001a17          	auipc	s4,0x1
 146:	43ea0a13          	addi	s4,s4,1086 # 1580 <count>
    for (i = 0; i < 1000 * 500000; i++)
 14a:	1dcd69b7          	lui	s3,0x1dcd6
 14e:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd4f70>
 152:	a809                	j	164 <test0+0x88>
        if (count > 0)
 154:	000a2783          	lw	a5,0(s4)
 158:	2781                	sext.w	a5,a5
 15a:	02f04063          	bgtz	a5,17a <test0+0x9e>
    for (i = 0; i < 1000 * 500000; i++)
 15e:	2485                	addiw	s1,s1,1
 160:	01348d63          	beq	s1,s3,17a <test0+0x9e>
        if ((i % 1000000) == 0)
 164:	0324e7bb          	remw	a5,s1,s2
 168:	f7f5                	bnez	a5,154 <test0+0x78>
            write(2, ".", 1);
 16a:	4605                	li	a2,1
 16c:	85d6                	mv	a1,s5
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	5dc080e7          	jalr	1500(ra) # 74c <write>
 178:	bff1                	j	154 <test0+0x78>
    sigalarm(0, 0);
 17a:	4581                	li	a1,0
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	65e080e7          	jalr	1630(ra) # 7dc <sigalarm>
    if (count > 0)
 186:	00001797          	auipc	a5,0x1
 18a:	3fa7a783          	lw	a5,1018(a5) # 1580 <count>
 18e:	02f05363          	blez	a5,1b4 <test0+0xd8>
        printf("test0 passed\n");
 192:	00001517          	auipc	a0,0x1
 196:	b4e50513          	addi	a0,a0,-1202 # ce0 <malloc+0x16c>
 19a:	00001097          	auipc	ra,0x1
 19e:	922080e7          	jalr	-1758(ra) # abc <printf>
}
 1a2:	70e2                	ld	ra,56(sp)
 1a4:	7442                	ld	s0,48(sp)
 1a6:	74a2                	ld	s1,40(sp)
 1a8:	7902                	ld	s2,32(sp)
 1aa:	69e2                	ld	s3,24(sp)
 1ac:	6a42                	ld	s4,16(sp)
 1ae:	6aa2                	ld	s5,8(sp)
 1b0:	6121                	addi	sp,sp,64
 1b2:	8082                	ret
        printf("\ntest0 failed: the kernel never called the alarm handler\n");
 1b4:	00001517          	auipc	a0,0x1
 1b8:	b3c50513          	addi	a0,a0,-1220 # cf0 <malloc+0x17c>
 1bc:	00001097          	auipc	ra,0x1
 1c0:	900080e7          	jalr	-1792(ra) # abc <printf>
}
 1c4:	bff9                	j	1a2 <test0+0xc6>

00000000000001c6 <foo>:
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e426                	sd	s1,8(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	84ae                	mv	s1,a1
    if ((i % 2500000) == 0)
 1d2:	002627b7          	lui	a5,0x262
 1d6:	5a07879b          	addiw	a5,a5,1440 # 2625a0 <base+0x261010>
 1da:	02f5653b          	remw	a0,a0,a5
 1de:	c909                	beqz	a0,1f0 <foo+0x2a>
    *j += 1;
 1e0:	409c                	lw	a5,0(s1)
 1e2:	2785                	addiw	a5,a5,1
 1e4:	c09c                	sw	a5,0(s1)
}
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	64a2                	ld	s1,8(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
        write(2, ".", 1);
 1f0:	4605                	li	a2,1
 1f2:	00001597          	auipc	a1,0x1
 1f6:	ae658593          	addi	a1,a1,-1306 # cd8 <malloc+0x164>
 1fa:	4509                	li	a0,2
 1fc:	00000097          	auipc	ra,0x0
 200:	550080e7          	jalr	1360(ra) # 74c <write>
 204:	bff1                	j	1e0 <foo+0x1a>

0000000000000206 <test1>:
{
 206:	7139                	addi	sp,sp,-64
 208:	fc06                	sd	ra,56(sp)
 20a:	f822                	sd	s0,48(sp)
 20c:	f426                	sd	s1,40(sp)
 20e:	f04a                	sd	s2,32(sp)
 210:	ec4e                	sd	s3,24(sp)
 212:	e852                	sd	s4,16(sp)
 214:	0080                	addi	s0,sp,64
    printf("test1 start\n");
 216:	00001517          	auipc	a0,0x1
 21a:	b1a50513          	addi	a0,a0,-1254 # d30 <malloc+0x1bc>
 21e:	00001097          	auipc	ra,0x1
 222:	89e080e7          	jalr	-1890(ra) # abc <printf>
    count = 0;
 226:	00001797          	auipc	a5,0x1
 22a:	3407ad23          	sw	zero,858(a5) # 1580 <count>
    j = 0;
 22e:	fc042623          	sw	zero,-52(s0)
    printf("%p\n",periodic);
 232:	00000597          	auipc	a1,0x0
 236:	df258593          	addi	a1,a1,-526 # 24 <periodic>
 23a:	00001517          	auipc	a0,0x1
 23e:	a9650513          	addi	a0,a0,-1386 # cd0 <malloc+0x15c>
 242:	00001097          	auipc	ra,0x1
 246:	87a080e7          	jalr	-1926(ra) # abc <printf>
    sigalarm(2,periodic);
 24a:	00000597          	auipc	a1,0x0
 24e:	dda58593          	addi	a1,a1,-550 # 24 <periodic>
 252:	4509                	li	a0,2
 254:	00000097          	auipc	ra,0x0
 258:	588080e7          	jalr	1416(ra) # 7dc <sigalarm>
    for (i = 0; i < 500000000; i++)
 25c:	4481                	li	s1,0
        if (count >= 10)
 25e:	00001a17          	auipc	s4,0x1
 262:	322a0a13          	addi	s4,s4,802 # 1580 <count>
 266:	49a5                	li	s3,9
    for (i = 0; i < 500000000; i++)
 268:	1dcd6937          	lui	s2,0x1dcd6
 26c:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd4f70>
        if (count >= 10)
 270:	000a2783          	lw	a5,0(s4)
 274:	2781                	sext.w	a5,a5
 276:	00f9cc63          	blt	s3,a5,28e <test1+0x88>
        foo(i, &j);
 27a:	fcc40593          	addi	a1,s0,-52
 27e:	8526                	mv	a0,s1
 280:	00000097          	auipc	ra,0x0
 284:	f46080e7          	jalr	-186(ra) # 1c6 <foo>
    for (i = 0; i < 500000000; i++)
 288:	2485                	addiw	s1,s1,1
 28a:	ff2493e3          	bne	s1,s2,270 <test1+0x6a>
    if (count < 10)
 28e:	00001717          	auipc	a4,0x1
 292:	2f272703          	lw	a4,754(a4) # 1580 <count>
 296:	47a5                	li	a5,9
 298:	02e7d663          	bge	a5,a4,2c4 <test1+0xbe>
    else if (i != j)
 29c:	fcc42783          	lw	a5,-52(s0)
 2a0:	04978763          	beq	a5,s1,2ee <test1+0xe8>
        printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 2a4:	00001517          	auipc	a0,0x1
 2a8:	ad450513          	addi	a0,a0,-1324 # d78 <malloc+0x204>
 2ac:	00001097          	auipc	ra,0x1
 2b0:	810080e7          	jalr	-2032(ra) # abc <printf>
}
 2b4:	70e2                	ld	ra,56(sp)
 2b6:	7442                	ld	s0,48(sp)
 2b8:	74a2                	ld	s1,40(sp)
 2ba:	7902                	ld	s2,32(sp)
 2bc:	69e2                	ld	s3,24(sp)
 2be:	6a42                	ld	s4,16(sp)
 2c0:	6121                	addi	sp,sp,64
 2c2:	8082                	ret
        printf("%d\n", count);
 2c4:	00001597          	auipc	a1,0x1
 2c8:	2bc5a583          	lw	a1,700(a1) # 1580 <count>
 2cc:	00001517          	auipc	a0,0x1
 2d0:	a7450513          	addi	a0,a0,-1420 # d40 <malloc+0x1cc>
 2d4:	00000097          	auipc	ra,0x0
 2d8:	7e8080e7          	jalr	2024(ra) # abc <printf>
        printf("\ntest1 failed: too few calls to the handler\n");
 2dc:	00001517          	auipc	a0,0x1
 2e0:	a6c50513          	addi	a0,a0,-1428 # d48 <malloc+0x1d4>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	7d8080e7          	jalr	2008(ra) # abc <printf>
 2ec:	b7e1                	j	2b4 <test1+0xae>
        printf("test1 passed\n");
 2ee:	00001517          	auipc	a0,0x1
 2f2:	aca50513          	addi	a0,a0,-1334 # db8 <malloc+0x244>
 2f6:	00000097          	auipc	ra,0x0
 2fa:	7c6080e7          	jalr	1990(ra) # abc <printf>
}
 2fe:	bf5d                	j	2b4 <test1+0xae>

0000000000000300 <test2>:
{
 300:	715d                	addi	sp,sp,-80
 302:	e486                	sd	ra,72(sp)
 304:	e0a2                	sd	s0,64(sp)
 306:	0880                	addi	s0,sp,80
    printf("test2 start\n");
 308:	00001517          	auipc	a0,0x1
 30c:	ac050513          	addi	a0,a0,-1344 # dc8 <malloc+0x254>
 310:	00000097          	auipc	ra,0x0
 314:	7ac080e7          	jalr	1964(ra) # abc <printf>
    if ((pid = fork()) < 0)
 318:	00000097          	auipc	ra,0x0
 31c:	40c080e7          	jalr	1036(ra) # 724 <fork>
 320:	04054763          	bltz	a0,36e <test2+0x6e>
 324:	fc26                	sd	s1,56(sp)
 326:	84aa                	mv	s1,a0
    if (pid == 0)
 328:	e171                	bnez	a0,3ec <test2+0xec>
 32a:	f84a                	sd	s2,48(sp)
 32c:	f44e                	sd	s3,40(sp)
 32e:	f052                	sd	s4,32(sp)
 330:	ec56                	sd	s5,24(sp)
        count = 0;
 332:	00001797          	auipc	a5,0x1
 336:	2407a723          	sw	zero,590(a5) # 1580 <count>
        sigalarm(2, slow_handler);
 33a:	00000597          	auipc	a1,0x0
 33e:	d2458593          	addi	a1,a1,-732 # 5e <slow_handler>
 342:	4509                	li	a0,2
 344:	00000097          	auipc	ra,0x0
 348:	498080e7          	jalr	1176(ra) # 7dc <sigalarm>
            if ((i % 1000000) == 0)
 34c:	000f4937          	lui	s2,0xf4
 350:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf2cb0>
                write(2, ".", 1);
 354:	00001a97          	auipc	s5,0x1
 358:	984a8a93          	addi	s5,s5,-1660 # cd8 <malloc+0x164>
            if (count > 0)
 35c:	00001a17          	auipc	s4,0x1
 360:	224a0a13          	addi	s4,s4,548 # 1580 <count>
        for (i = 0; i < 1000 * 500000; i++)
 364:	1dcd69b7          	lui	s3,0x1dcd6
 368:	50098993          	addi	s3,s3,1280 # 1dcd6500 <base+0x1dcd4f70>
 36c:	a835                	j	3a8 <test2+0xa8>
        printf("test2: fork failed\n");
 36e:	00001517          	auipc	a0,0x1
 372:	a6a50513          	addi	a0,a0,-1430 # dd8 <malloc+0x264>
 376:	00000097          	auipc	ra,0x0
 37a:	746080e7          	jalr	1862(ra) # abc <printf>
    wait(&status);
 37e:	fbc40513          	addi	a0,s0,-68
 382:	00000097          	auipc	ra,0x0
 386:	3b2080e7          	jalr	946(ra) # 734 <wait>
    if (status == 0)
 38a:	fbc42783          	lw	a5,-68(s0)
 38e:	c3ad                	beqz	a5,3f0 <test2+0xf0>
}
 390:	60a6                	ld	ra,72(sp)
 392:	6406                	ld	s0,64(sp)
 394:	6161                	addi	sp,sp,80
 396:	8082                	ret
            if (count > 0)
 398:	000a2783          	lw	a5,0(s4)
 39c:	2781                	sext.w	a5,a5
 39e:	02f04063          	bgtz	a5,3be <test2+0xbe>
        for (i = 0; i < 1000 * 500000; i++)
 3a2:	2485                	addiw	s1,s1,1
 3a4:	01348d63          	beq	s1,s3,3be <test2+0xbe>
            if ((i % 1000000) == 0)
 3a8:	0324e7bb          	remw	a5,s1,s2
 3ac:	f7f5                	bnez	a5,398 <test2+0x98>
                write(2, ".", 1);
 3ae:	4605                	li	a2,1
 3b0:	85d6                	mv	a1,s5
 3b2:	4509                	li	a0,2
 3b4:	00000097          	auipc	ra,0x0
 3b8:	398080e7          	jalr	920(ra) # 74c <write>
 3bc:	bff1                	j	398 <test2+0x98>
        if (count == 0)
 3be:	00001797          	auipc	a5,0x1
 3c2:	1c27a783          	lw	a5,450(a5) # 1580 <count>
 3c6:	ef91                	bnez	a5,3e2 <test2+0xe2>
            printf("\ntest2 failed: alarm not called\n");
 3c8:	00001517          	auipc	a0,0x1
 3cc:	a2850513          	addi	a0,a0,-1496 # df0 <malloc+0x27c>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	6ec080e7          	jalr	1772(ra) # abc <printf>
            exit(1);
 3d8:	4505                	li	a0,1
 3da:	00000097          	auipc	ra,0x0
 3de:	352080e7          	jalr	850(ra) # 72c <exit>
        exit(0);
 3e2:	4501                	li	a0,0
 3e4:	00000097          	auipc	ra,0x0
 3e8:	348080e7          	jalr	840(ra) # 72c <exit>
 3ec:	74e2                	ld	s1,56(sp)
 3ee:	bf41                	j	37e <test2+0x7e>
        printf("test2 passed\n");
 3f0:	00001517          	auipc	a0,0x1
 3f4:	a2850513          	addi	a0,a0,-1496 # e18 <malloc+0x2a4>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	6c4080e7          	jalr	1732(ra) # abc <printf>
}
 400:	bf41                	j	390 <test2+0x90>

0000000000000402 <test3>:
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
    sigalarm(1, dummy_handler);
 40a:	00000597          	auipc	a1,0x0
 40e:	bf658593          	addi	a1,a1,-1034 # 0 <dummy_handler>
 412:	4505                	li	a0,1
 414:	00000097          	auipc	ra,0x0
 418:	3c8080e7          	jalr	968(ra) # 7dc <sigalarm>
    printf("test3 start\n");
 41c:	00001517          	auipc	a0,0x1
 420:	a0c50513          	addi	a0,a0,-1524 # e28 <malloc+0x2b4>
 424:	00000097          	auipc	ra,0x0
 428:	698080e7          	jalr	1688(ra) # abc <printf>
    asm volatile("lui a5, 0");
 42c:	000007b7          	lui	a5,0x0
    asm volatile("addi a0, a5, 0xac" : : : "a0");
 430:	0ac78513          	addi	a0,a5,172 # ac <slow_handler+0x4e>
 434:	1dcd67b7          	lui	a5,0x1dcd6
 438:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd4f70>
    for (int i = 0; i < 500000000; i++)
 43c:	37fd                	addiw	a5,a5,-1
 43e:	fffd                	bnez	a5,43c <test3+0x3a>
    asm volatile("mv %0, a0" : "=r"(a0));
 440:	872a                	mv	a4,a0
    if (a0 != 0xac)
 442:	0ac00793          	li	a5,172
 446:	00f70e63          	beq	a4,a5,462 <test3+0x60>
        printf("test3 failed: register a0 changed\n");
 44a:	00001517          	auipc	a0,0x1
 44e:	9ee50513          	addi	a0,a0,-1554 # e38 <malloc+0x2c4>
 452:	00000097          	auipc	ra,0x0
 456:	66a080e7          	jalr	1642(ra) # abc <printf>
}
 45a:	60a2                	ld	ra,8(sp)
 45c:	6402                	ld	s0,0(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret
        printf("test3 passed\n");
 462:	00001517          	auipc	a0,0x1
 466:	9fe50513          	addi	a0,a0,-1538 # e60 <malloc+0x2ec>
 46a:	00000097          	auipc	ra,0x0
 46e:	652080e7          	jalr	1618(ra) # abc <printf>
}
 472:	b7e5                	j	45a <test3+0x58>

0000000000000474 <main>:
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
    test0();
 47c:	00000097          	auipc	ra,0x0
 480:	c60080e7          	jalr	-928(ra) # dc <test0>
    test1();
 484:	00000097          	auipc	ra,0x0
 488:	d82080e7          	jalr	-638(ra) # 206 <test1>
    test2();
 48c:	00000097          	auipc	ra,0x0
 490:	e74080e7          	jalr	-396(ra) # 300 <test2>
    test3();
 494:	00000097          	auipc	ra,0x0
 498:	f6e080e7          	jalr	-146(ra) # 402 <test3>
    exit(0);
 49c:	4501                	li	a0,0
 49e:	00000097          	auipc	ra,0x0
 4a2:	28e080e7          	jalr	654(ra) # 72c <exit>

00000000000004a6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4ae:	00000097          	auipc	ra,0x0
 4b2:	fc6080e7          	jalr	-58(ra) # 474 <main>
  exit(0);
 4b6:	4501                	li	a0,0
 4b8:	00000097          	auipc	ra,0x0
 4bc:	274080e7          	jalr	628(ra) # 72c <exit>

00000000000004c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e422                	sd	s0,8(sp)
 4c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4c6:	87aa                	mv	a5,a0
 4c8:	0585                	addi	a1,a1,1
 4ca:	0785                	addi	a5,a5,1
 4cc:	fff5c703          	lbu	a4,-1(a1)
 4d0:	fee78fa3          	sb	a4,-1(a5)
 4d4:	fb75                	bnez	a4,4c8 <strcpy+0x8>
    ;
  return os;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	cb91                	beqz	a5,4fa <strcmp+0x1e>
 4e8:	0005c703          	lbu	a4,0(a1)
 4ec:	00f71763          	bne	a4,a5,4fa <strcmp+0x1e>
    p++, q++;
 4f0:	0505                	addi	a0,a0,1
 4f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4f4:	00054783          	lbu	a5,0(a0)
 4f8:	fbe5                	bnez	a5,4e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4fa:	0005c503          	lbu	a0,0(a1)
}
 4fe:	40a7853b          	subw	a0,a5,a0
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <strlen>:

uint
strlen(const char *s)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 50e:	00054783          	lbu	a5,0(a0)
 512:	cf91                	beqz	a5,52e <strlen+0x26>
 514:	0505                	addi	a0,a0,1
 516:	87aa                	mv	a5,a0
 518:	86be                	mv	a3,a5
 51a:	0785                	addi	a5,a5,1
 51c:	fff7c703          	lbu	a4,-1(a5)
 520:	ff65                	bnez	a4,518 <strlen+0x10>
 522:	40a6853b          	subw	a0,a3,a0
 526:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 528:	6422                	ld	s0,8(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
  for(n = 0; s[n]; n++)
 52e:	4501                	li	a0,0
 530:	bfe5                	j	528 <strlen+0x20>

0000000000000532 <memset>:

void*
memset(void *dst, int c, uint n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 538:	ca19                	beqz	a2,54e <memset+0x1c>
 53a:	87aa                	mv	a5,a0
 53c:	1602                	slli	a2,a2,0x20
 53e:	9201                	srli	a2,a2,0x20
 540:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 544:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 548:	0785                	addi	a5,a5,1
 54a:	fee79de3          	bne	a5,a4,544 <memset+0x12>
  }
  return dst;
}
 54e:	6422                	ld	s0,8(sp)
 550:	0141                	addi	sp,sp,16
 552:	8082                	ret

0000000000000554 <strchr>:

char*
strchr(const char *s, char c)
{
 554:	1141                	addi	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	addi	s0,sp,16
  for(; *s; s++)
 55a:	00054783          	lbu	a5,0(a0)
 55e:	cb99                	beqz	a5,574 <strchr+0x20>
    if(*s == c)
 560:	00f58763          	beq	a1,a5,56e <strchr+0x1a>
  for(; *s; s++)
 564:	0505                	addi	a0,a0,1
 566:	00054783          	lbu	a5,0(a0)
 56a:	fbfd                	bnez	a5,560 <strchr+0xc>
      return (char*)s;
  return 0;
 56c:	4501                	li	a0,0
}
 56e:	6422                	ld	s0,8(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret
  return 0;
 574:	4501                	li	a0,0
 576:	bfe5                	j	56e <strchr+0x1a>

0000000000000578 <gets>:

char*
gets(char *buf, int max)
{
 578:	711d                	addi	sp,sp,-96
 57a:	ec86                	sd	ra,88(sp)
 57c:	e8a2                	sd	s0,80(sp)
 57e:	e4a6                	sd	s1,72(sp)
 580:	e0ca                	sd	s2,64(sp)
 582:	fc4e                	sd	s3,56(sp)
 584:	f852                	sd	s4,48(sp)
 586:	f456                	sd	s5,40(sp)
 588:	f05a                	sd	s6,32(sp)
 58a:	ec5e                	sd	s7,24(sp)
 58c:	1080                	addi	s0,sp,96
 58e:	8baa                	mv	s7,a0
 590:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 592:	892a                	mv	s2,a0
 594:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 596:	4aa9                	li	s5,10
 598:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 59a:	89a6                	mv	s3,s1
 59c:	2485                	addiw	s1,s1,1
 59e:	0344d863          	bge	s1,s4,5ce <gets+0x56>
    cc = read(0, &c, 1);
 5a2:	4605                	li	a2,1
 5a4:	faf40593          	addi	a1,s0,-81
 5a8:	4501                	li	a0,0
 5aa:	00000097          	auipc	ra,0x0
 5ae:	19a080e7          	jalr	410(ra) # 744 <read>
    if(cc < 1)
 5b2:	00a05e63          	blez	a0,5ce <gets+0x56>
    buf[i++] = c;
 5b6:	faf44783          	lbu	a5,-81(s0)
 5ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5be:	01578763          	beq	a5,s5,5cc <gets+0x54>
 5c2:	0905                	addi	s2,s2,1
 5c4:	fd679be3          	bne	a5,s6,59a <gets+0x22>
    buf[i++] = c;
 5c8:	89a6                	mv	s3,s1
 5ca:	a011                	j	5ce <gets+0x56>
 5cc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5ce:	99de                	add	s3,s3,s7
 5d0:	00098023          	sb	zero,0(s3)
  return buf;
}
 5d4:	855e                	mv	a0,s7
 5d6:	60e6                	ld	ra,88(sp)
 5d8:	6446                	ld	s0,80(sp)
 5da:	64a6                	ld	s1,72(sp)
 5dc:	6906                	ld	s2,64(sp)
 5de:	79e2                	ld	s3,56(sp)
 5e0:	7a42                	ld	s4,48(sp)
 5e2:	7aa2                	ld	s5,40(sp)
 5e4:	7b02                	ld	s6,32(sp)
 5e6:	6be2                	ld	s7,24(sp)
 5e8:	6125                	addi	sp,sp,96
 5ea:	8082                	ret

00000000000005ec <stat>:

int
stat(const char *n, struct stat *st)
{
 5ec:	1101                	addi	sp,sp,-32
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	e04a                	sd	s2,0(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f8:	4581                	li	a1,0
 5fa:	00000097          	auipc	ra,0x0
 5fe:	172080e7          	jalr	370(ra) # 76c <open>
  if(fd < 0)
 602:	02054663          	bltz	a0,62e <stat+0x42>
 606:	e426                	sd	s1,8(sp)
 608:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 60a:	85ca                	mv	a1,s2
 60c:	00000097          	auipc	ra,0x0
 610:	178080e7          	jalr	376(ra) # 784 <fstat>
 614:	892a                	mv	s2,a0
  close(fd);
 616:	8526                	mv	a0,s1
 618:	00000097          	auipc	ra,0x0
 61c:	13c080e7          	jalr	316(ra) # 754 <close>
  return r;
 620:	64a2                	ld	s1,8(sp)
}
 622:	854a                	mv	a0,s2
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	6902                	ld	s2,0(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret
    return -1;
 62e:	597d                	li	s2,-1
 630:	bfcd                	j	622 <stat+0x36>

0000000000000632 <atoi>:

int
atoi(const char *s)
{
 632:	1141                	addi	sp,sp,-16
 634:	e422                	sd	s0,8(sp)
 636:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 638:	00054683          	lbu	a3,0(a0)
 63c:	fd06879b          	addiw	a5,a3,-48
 640:	0ff7f793          	zext.b	a5,a5
 644:	4625                	li	a2,9
 646:	02f66863          	bltu	a2,a5,676 <atoi+0x44>
 64a:	872a                	mv	a4,a0
  n = 0;
 64c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 64e:	0705                	addi	a4,a4,1
 650:	0025179b          	slliw	a5,a0,0x2
 654:	9fa9                	addw	a5,a5,a0
 656:	0017979b          	slliw	a5,a5,0x1
 65a:	9fb5                	addw	a5,a5,a3
 65c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 660:	00074683          	lbu	a3,0(a4)
 664:	fd06879b          	addiw	a5,a3,-48
 668:	0ff7f793          	zext.b	a5,a5
 66c:	fef671e3          	bgeu	a2,a5,64e <atoi+0x1c>
  return n;
}
 670:	6422                	ld	s0,8(sp)
 672:	0141                	addi	sp,sp,16
 674:	8082                	ret
  n = 0;
 676:	4501                	li	a0,0
 678:	bfe5                	j	670 <atoi+0x3e>

000000000000067a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 67a:	1141                	addi	sp,sp,-16
 67c:	e422                	sd	s0,8(sp)
 67e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 680:	02b57463          	bgeu	a0,a1,6a8 <memmove+0x2e>
    while(n-- > 0)
 684:	00c05f63          	blez	a2,6a2 <memmove+0x28>
 688:	1602                	slli	a2,a2,0x20
 68a:	9201                	srli	a2,a2,0x20
 68c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 690:	872a                	mv	a4,a0
      *dst++ = *src++;
 692:	0585                	addi	a1,a1,1
 694:	0705                	addi	a4,a4,1
 696:	fff5c683          	lbu	a3,-1(a1)
 69a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 69e:	fef71ae3          	bne	a4,a5,692 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6a2:	6422                	ld	s0,8(sp)
 6a4:	0141                	addi	sp,sp,16
 6a6:	8082                	ret
    dst += n;
 6a8:	00c50733          	add	a4,a0,a2
    src += n;
 6ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6ae:	fec05ae3          	blez	a2,6a2 <memmove+0x28>
 6b2:	fff6079b          	addiw	a5,a2,-1
 6b6:	1782                	slli	a5,a5,0x20
 6b8:	9381                	srli	a5,a5,0x20
 6ba:	fff7c793          	not	a5,a5
 6be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6c0:	15fd                	addi	a1,a1,-1
 6c2:	177d                	addi	a4,a4,-1
 6c4:	0005c683          	lbu	a3,0(a1)
 6c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6cc:	fee79ae3          	bne	a5,a4,6c0 <memmove+0x46>
 6d0:	bfc9                	j	6a2 <memmove+0x28>

00000000000006d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e422                	sd	s0,8(sp)
 6d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6d8:	ca05                	beqz	a2,708 <memcmp+0x36>
 6da:	fff6069b          	addiw	a3,a2,-1
 6de:	1682                	slli	a3,a3,0x20
 6e0:	9281                	srli	a3,a3,0x20
 6e2:	0685                	addi	a3,a3,1
 6e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6e6:	00054783          	lbu	a5,0(a0)
 6ea:	0005c703          	lbu	a4,0(a1)
 6ee:	00e79863          	bne	a5,a4,6fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6f2:	0505                	addi	a0,a0,1
    p2++;
 6f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6f6:	fed518e3          	bne	a0,a3,6e6 <memcmp+0x14>
  }
  return 0;
 6fa:	4501                	li	a0,0
 6fc:	a019                	j	702 <memcmp+0x30>
      return *p1 - *p2;
 6fe:	40e7853b          	subw	a0,a5,a4
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret
  return 0;
 708:	4501                	li	a0,0
 70a:	bfe5                	j	702 <memcmp+0x30>

000000000000070c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 70c:	1141                	addi	sp,sp,-16
 70e:	e406                	sd	ra,8(sp)
 710:	e022                	sd	s0,0(sp)
 712:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 714:	00000097          	auipc	ra,0x0
 718:	f66080e7          	jalr	-154(ra) # 67a <memmove>
}
 71c:	60a2                	ld	ra,8(sp)
 71e:	6402                	ld	s0,0(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 724:	4885                	li	a7,1
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <exit>:
.global exit
exit:
 li a7, SYS_exit
 72c:	4889                	li	a7,2
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <wait>:
.global wait
wait:
 li a7, SYS_wait
 734:	488d                	li	a7,3
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 73c:	4891                	li	a7,4
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <read>:
.global read
read:
 li a7, SYS_read
 744:	4895                	li	a7,5
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <write>:
.global write
write:
 li a7, SYS_write
 74c:	48c1                	li	a7,16
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <close>:
.global close
close:
 li a7, SYS_close
 754:	48d5                	li	a7,21
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <kill>:
.global kill
kill:
 li a7, SYS_kill
 75c:	4899                	li	a7,6
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <exec>:
.global exec
exec:
 li a7, SYS_exec
 764:	489d                	li	a7,7
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <open>:
.global open
open:
 li a7, SYS_open
 76c:	48bd                	li	a7,15
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 774:	48c5                	li	a7,17
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 77c:	48c9                	li	a7,18
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 784:	48a1                	li	a7,8
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <link>:
.global link
link:
 li a7, SYS_link
 78c:	48cd                	li	a7,19
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 794:	48d1                	li	a7,20
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 79c:	48a5                	li	a7,9
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7a4:	48a9                	li	a7,10
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ac:	48ad                	li	a7,11
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7b4:	48b1                	li	a7,12
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7bc:	48b5                	li	a7,13
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7c4:	48b9                	li	a7,14
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 7cc:	48d9                	li	a7,22
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 7d4:	48dd                	li	a7,23
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 7dc:	48e1                	li	a7,24
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 7e4:	48e5                	li	a7,25
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 7ec:	48e9                	li	a7,26
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7f4:	1101                	addi	sp,sp,-32
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 800:	4605                	li	a2,1
 802:	fef40593          	addi	a1,s0,-17
 806:	00000097          	auipc	ra,0x0
 80a:	f46080e7          	jalr	-186(ra) # 74c <write>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6105                	addi	sp,sp,32
 814:	8082                	ret

0000000000000816 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 816:	7139                	addi	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f426                	sd	s1,40(sp)
 81e:	0080                	addi	s0,sp,64
 820:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 822:	c299                	beqz	a3,828 <printint+0x12>
 824:	0805cb63          	bltz	a1,8ba <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 828:	2581                	sext.w	a1,a1
  neg = 0;
 82a:	4881                	li	a7,0
 82c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 830:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 832:	2601                	sext.w	a2,a2
 834:	00000517          	auipc	a0,0x0
 838:	69c50513          	addi	a0,a0,1692 # ed0 <digits>
 83c:	883a                	mv	a6,a4
 83e:	2705                	addiw	a4,a4,1
 840:	02c5f7bb          	remuw	a5,a1,a2
 844:	1782                	slli	a5,a5,0x20
 846:	9381                	srli	a5,a5,0x20
 848:	97aa                	add	a5,a5,a0
 84a:	0007c783          	lbu	a5,0(a5)
 84e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 852:	0005879b          	sext.w	a5,a1
 856:	02c5d5bb          	divuw	a1,a1,a2
 85a:	0685                	addi	a3,a3,1
 85c:	fec7f0e3          	bgeu	a5,a2,83c <printint+0x26>
  if(neg)
 860:	00088c63          	beqz	a7,878 <printint+0x62>
    buf[i++] = '-';
 864:	fd070793          	addi	a5,a4,-48
 868:	00878733          	add	a4,a5,s0
 86c:	02d00793          	li	a5,45
 870:	fef70823          	sb	a5,-16(a4)
 874:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 878:	02e05c63          	blez	a4,8b0 <printint+0x9a>
 87c:	f04a                	sd	s2,32(sp)
 87e:	ec4e                	sd	s3,24(sp)
 880:	fc040793          	addi	a5,s0,-64
 884:	00e78933          	add	s2,a5,a4
 888:	fff78993          	addi	s3,a5,-1
 88c:	99ba                	add	s3,s3,a4
 88e:	377d                	addiw	a4,a4,-1
 890:	1702                	slli	a4,a4,0x20
 892:	9301                	srli	a4,a4,0x20
 894:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 898:	fff94583          	lbu	a1,-1(s2)
 89c:	8526                	mv	a0,s1
 89e:	00000097          	auipc	ra,0x0
 8a2:	f56080e7          	jalr	-170(ra) # 7f4 <putc>
  while(--i >= 0)
 8a6:	197d                	addi	s2,s2,-1
 8a8:	ff3918e3          	bne	s2,s3,898 <printint+0x82>
 8ac:	7902                	ld	s2,32(sp)
 8ae:	69e2                	ld	s3,24(sp)
}
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	6121                	addi	sp,sp,64
 8b8:	8082                	ret
    x = -xx;
 8ba:	40b005bb          	negw	a1,a1
    neg = 1;
 8be:	4885                	li	a7,1
    x = -xx;
 8c0:	b7b5                	j	82c <printint+0x16>

00000000000008c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8c2:	715d                	addi	sp,sp,-80
 8c4:	e486                	sd	ra,72(sp)
 8c6:	e0a2                	sd	s0,64(sp)
 8c8:	f84a                	sd	s2,48(sp)
 8ca:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8cc:	0005c903          	lbu	s2,0(a1)
 8d0:	1a090a63          	beqz	s2,a84 <vprintf+0x1c2>
 8d4:	fc26                	sd	s1,56(sp)
 8d6:	f44e                	sd	s3,40(sp)
 8d8:	f052                	sd	s4,32(sp)
 8da:	ec56                	sd	s5,24(sp)
 8dc:	e85a                	sd	s6,16(sp)
 8de:	e45e                	sd	s7,8(sp)
 8e0:	8aaa                	mv	s5,a0
 8e2:	8bb2                	mv	s7,a2
 8e4:	00158493          	addi	s1,a1,1
  state = 0;
 8e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8ea:	02500a13          	li	s4,37
 8ee:	4b55                	li	s6,21
 8f0:	a839                	j	90e <vprintf+0x4c>
        putc(fd, c);
 8f2:	85ca                	mv	a1,s2
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	efe080e7          	jalr	-258(ra) # 7f4 <putc>
 8fe:	a019                	j	904 <vprintf+0x42>
    } else if(state == '%'){
 900:	01498d63          	beq	s3,s4,91a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 904:	0485                	addi	s1,s1,1
 906:	fff4c903          	lbu	s2,-1(s1)
 90a:	16090763          	beqz	s2,a78 <vprintf+0x1b6>
    if(state == 0){
 90e:	fe0999e3          	bnez	s3,900 <vprintf+0x3e>
      if(c == '%'){
 912:	ff4910e3          	bne	s2,s4,8f2 <vprintf+0x30>
        state = '%';
 916:	89d2                	mv	s3,s4
 918:	b7f5                	j	904 <vprintf+0x42>
      if(c == 'd'){
 91a:	13490463          	beq	s2,s4,a42 <vprintf+0x180>
 91e:	f9d9079b          	addiw	a5,s2,-99
 922:	0ff7f793          	zext.b	a5,a5
 926:	12fb6763          	bltu	s6,a5,a54 <vprintf+0x192>
 92a:	f9d9079b          	addiw	a5,s2,-99
 92e:	0ff7f713          	zext.b	a4,a5
 932:	12eb6163          	bltu	s6,a4,a54 <vprintf+0x192>
 936:	00271793          	slli	a5,a4,0x2
 93a:	00000717          	auipc	a4,0x0
 93e:	53e70713          	addi	a4,a4,1342 # e78 <malloc+0x304>
 942:	97ba                	add	a5,a5,a4
 944:	439c                	lw	a5,0(a5)
 946:	97ba                	add	a5,a5,a4
 948:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 94a:	008b8913          	addi	s2,s7,8
 94e:	4685                	li	a3,1
 950:	4629                	li	a2,10
 952:	000ba583          	lw	a1,0(s7)
 956:	8556                	mv	a0,s5
 958:	00000097          	auipc	ra,0x0
 95c:	ebe080e7          	jalr	-322(ra) # 816 <printint>
 960:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 962:	4981                	li	s3,0
 964:	b745                	j	904 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 966:	008b8913          	addi	s2,s7,8
 96a:	4681                	li	a3,0
 96c:	4629                	li	a2,10
 96e:	000ba583          	lw	a1,0(s7)
 972:	8556                	mv	a0,s5
 974:	00000097          	auipc	ra,0x0
 978:	ea2080e7          	jalr	-350(ra) # 816 <printint>
 97c:	8bca                	mv	s7,s2
      state = 0;
 97e:	4981                	li	s3,0
 980:	b751                	j	904 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 982:	008b8913          	addi	s2,s7,8
 986:	4681                	li	a3,0
 988:	4641                	li	a2,16
 98a:	000ba583          	lw	a1,0(s7)
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	e86080e7          	jalr	-378(ra) # 816 <printint>
 998:	8bca                	mv	s7,s2
      state = 0;
 99a:	4981                	li	s3,0
 99c:	b7a5                	j	904 <vprintf+0x42>
 99e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9a0:	008b8c13          	addi	s8,s7,8
 9a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9a8:	03000593          	li	a1,48
 9ac:	8556                	mv	a0,s5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e46080e7          	jalr	-442(ra) # 7f4 <putc>
  putc(fd, 'x');
 9b6:	07800593          	li	a1,120
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e38080e7          	jalr	-456(ra) # 7f4 <putc>
 9c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9c6:	00000b97          	auipc	s7,0x0
 9ca:	50ab8b93          	addi	s7,s7,1290 # ed0 <digits>
 9ce:	03c9d793          	srli	a5,s3,0x3c
 9d2:	97de                	add	a5,a5,s7
 9d4:	0007c583          	lbu	a1,0(a5)
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	e1a080e7          	jalr	-486(ra) # 7f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9e2:	0992                	slli	s3,s3,0x4
 9e4:	397d                	addiw	s2,s2,-1
 9e6:	fe0914e3          	bnez	s2,9ce <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 9ea:	8be2                	mv	s7,s8
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	6c02                	ld	s8,0(sp)
 9f0:	bf11                	j	904 <vprintf+0x42>
        s = va_arg(ap, char*);
 9f2:	008b8993          	addi	s3,s7,8
 9f6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 9fa:	02090163          	beqz	s2,a1c <vprintf+0x15a>
        while(*s != 0){
 9fe:	00094583          	lbu	a1,0(s2)
 a02:	c9a5                	beqz	a1,a72 <vprintf+0x1b0>
          putc(fd, *s);
 a04:	8556                	mv	a0,s5
 a06:	00000097          	auipc	ra,0x0
 a0a:	dee080e7          	jalr	-530(ra) # 7f4 <putc>
          s++;
 a0e:	0905                	addi	s2,s2,1
        while(*s != 0){
 a10:	00094583          	lbu	a1,0(s2)
 a14:	f9e5                	bnez	a1,a04 <vprintf+0x142>
        s = va_arg(ap, char*);
 a16:	8bce                	mv	s7,s3
      state = 0;
 a18:	4981                	li	s3,0
 a1a:	b5ed                	j	904 <vprintf+0x42>
          s = "(null)";
 a1c:	00000917          	auipc	s2,0x0
 a20:	45490913          	addi	s2,s2,1108 # e70 <malloc+0x2fc>
        while(*s != 0){
 a24:	02800593          	li	a1,40
 a28:	bff1                	j	a04 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 a2a:	008b8913          	addi	s2,s7,8
 a2e:	000bc583          	lbu	a1,0(s7)
 a32:	8556                	mv	a0,s5
 a34:	00000097          	auipc	ra,0x0
 a38:	dc0080e7          	jalr	-576(ra) # 7f4 <putc>
 a3c:	8bca                	mv	s7,s2
      state = 0;
 a3e:	4981                	li	s3,0
 a40:	b5d1                	j	904 <vprintf+0x42>
        putc(fd, c);
 a42:	02500593          	li	a1,37
 a46:	8556                	mv	a0,s5
 a48:	00000097          	auipc	ra,0x0
 a4c:	dac080e7          	jalr	-596(ra) # 7f4 <putc>
      state = 0;
 a50:	4981                	li	s3,0
 a52:	bd4d                	j	904 <vprintf+0x42>
        putc(fd, '%');
 a54:	02500593          	li	a1,37
 a58:	8556                	mv	a0,s5
 a5a:	00000097          	auipc	ra,0x0
 a5e:	d9a080e7          	jalr	-614(ra) # 7f4 <putc>
        putc(fd, c);
 a62:	85ca                	mv	a1,s2
 a64:	8556                	mv	a0,s5
 a66:	00000097          	auipc	ra,0x0
 a6a:	d8e080e7          	jalr	-626(ra) # 7f4 <putc>
      state = 0;
 a6e:	4981                	li	s3,0
 a70:	bd51                	j	904 <vprintf+0x42>
        s = va_arg(ap, char*);
 a72:	8bce                	mv	s7,s3
      state = 0;
 a74:	4981                	li	s3,0
 a76:	b579                	j	904 <vprintf+0x42>
 a78:	74e2                	ld	s1,56(sp)
 a7a:	79a2                	ld	s3,40(sp)
 a7c:	7a02                	ld	s4,32(sp)
 a7e:	6ae2                	ld	s5,24(sp)
 a80:	6b42                	ld	s6,16(sp)
 a82:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a84:	60a6                	ld	ra,72(sp)
 a86:	6406                	ld	s0,64(sp)
 a88:	7942                	ld	s2,48(sp)
 a8a:	6161                	addi	sp,sp,80
 a8c:	8082                	ret

0000000000000a8e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a8e:	715d                	addi	sp,sp,-80
 a90:	ec06                	sd	ra,24(sp)
 a92:	e822                	sd	s0,16(sp)
 a94:	1000                	addi	s0,sp,32
 a96:	e010                	sd	a2,0(s0)
 a98:	e414                	sd	a3,8(s0)
 a9a:	e818                	sd	a4,16(s0)
 a9c:	ec1c                	sd	a5,24(s0)
 a9e:	03043023          	sd	a6,32(s0)
 aa2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aa6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aaa:	8622                	mv	a2,s0
 aac:	00000097          	auipc	ra,0x0
 ab0:	e16080e7          	jalr	-490(ra) # 8c2 <vprintf>
}
 ab4:	60e2                	ld	ra,24(sp)
 ab6:	6442                	ld	s0,16(sp)
 ab8:	6161                	addi	sp,sp,80
 aba:	8082                	ret

0000000000000abc <printf>:

void
printf(const char *fmt, ...)
{
 abc:	711d                	addi	sp,sp,-96
 abe:	ec06                	sd	ra,24(sp)
 ac0:	e822                	sd	s0,16(sp)
 ac2:	1000                	addi	s0,sp,32
 ac4:	e40c                	sd	a1,8(s0)
 ac6:	e810                	sd	a2,16(s0)
 ac8:	ec14                	sd	a3,24(s0)
 aca:	f018                	sd	a4,32(s0)
 acc:	f41c                	sd	a5,40(s0)
 ace:	03043823          	sd	a6,48(s0)
 ad2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ad6:	00840613          	addi	a2,s0,8
 ada:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ade:	85aa                	mv	a1,a0
 ae0:	4505                	li	a0,1
 ae2:	00000097          	auipc	ra,0x0
 ae6:	de0080e7          	jalr	-544(ra) # 8c2 <vprintf>
}
 aea:	60e2                	ld	ra,24(sp)
 aec:	6442                	ld	s0,16(sp)
 aee:	6125                	addi	sp,sp,96
 af0:	8082                	ret

0000000000000af2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af2:	1141                	addi	sp,sp,-16
 af4:	e422                	sd	s0,8(sp)
 af6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afc:	00001797          	auipc	a5,0x1
 b00:	a8c7b783          	ld	a5,-1396(a5) # 1588 <freep>
 b04:	a02d                	j	b2e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b06:	4618                	lw	a4,8(a2)
 b08:	9f2d                	addw	a4,a4,a1
 b0a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b0e:	6398                	ld	a4,0(a5)
 b10:	6310                	ld	a2,0(a4)
 b12:	a83d                	j	b50 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b14:	ff852703          	lw	a4,-8(a0)
 b18:	9f31                	addw	a4,a4,a2
 b1a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b1c:	ff053683          	ld	a3,-16(a0)
 b20:	a091                	j	b64 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b22:	6398                	ld	a4,0(a5)
 b24:	00e7e463          	bltu	a5,a4,b2c <free+0x3a>
 b28:	00e6ea63          	bltu	a3,a4,b3c <free+0x4a>
{
 b2c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b2e:	fed7fae3          	bgeu	a5,a3,b22 <free+0x30>
 b32:	6398                	ld	a4,0(a5)
 b34:	00e6e463          	bltu	a3,a4,b3c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b38:	fee7eae3          	bltu	a5,a4,b2c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b3c:	ff852583          	lw	a1,-8(a0)
 b40:	6390                	ld	a2,0(a5)
 b42:	02059813          	slli	a6,a1,0x20
 b46:	01c85713          	srli	a4,a6,0x1c
 b4a:	9736                	add	a4,a4,a3
 b4c:	fae60de3          	beq	a2,a4,b06 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b50:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b54:	4790                	lw	a2,8(a5)
 b56:	02061593          	slli	a1,a2,0x20
 b5a:	01c5d713          	srli	a4,a1,0x1c
 b5e:	973e                	add	a4,a4,a5
 b60:	fae68ae3          	beq	a3,a4,b14 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b64:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b66:	00001717          	auipc	a4,0x1
 b6a:	a2f73123          	sd	a5,-1502(a4) # 1588 <freep>
}
 b6e:	6422                	ld	s0,8(sp)
 b70:	0141                	addi	sp,sp,16
 b72:	8082                	ret

0000000000000b74 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b74:	7139                	addi	sp,sp,-64
 b76:	fc06                	sd	ra,56(sp)
 b78:	f822                	sd	s0,48(sp)
 b7a:	f426                	sd	s1,40(sp)
 b7c:	ec4e                	sd	s3,24(sp)
 b7e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b80:	02051493          	slli	s1,a0,0x20
 b84:	9081                	srli	s1,s1,0x20
 b86:	04bd                	addi	s1,s1,15
 b88:	8091                	srli	s1,s1,0x4
 b8a:	0014899b          	addiw	s3,s1,1
 b8e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b90:	00001517          	auipc	a0,0x1
 b94:	9f853503          	ld	a0,-1544(a0) # 1588 <freep>
 b98:	c915                	beqz	a0,bcc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b9c:	4798                	lw	a4,8(a5)
 b9e:	08977e63          	bgeu	a4,s1,c3a <malloc+0xc6>
 ba2:	f04a                	sd	s2,32(sp)
 ba4:	e852                	sd	s4,16(sp)
 ba6:	e456                	sd	s5,8(sp)
 ba8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 baa:	8a4e                	mv	s4,s3
 bac:	0009871b          	sext.w	a4,s3
 bb0:	6685                	lui	a3,0x1
 bb2:	00d77363          	bgeu	a4,a3,bb8 <malloc+0x44>
 bb6:	6a05                	lui	s4,0x1
 bb8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bbc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bc0:	00001917          	auipc	s2,0x1
 bc4:	9c890913          	addi	s2,s2,-1592 # 1588 <freep>
  if(p == (char*)-1)
 bc8:	5afd                	li	s5,-1
 bca:	a091                	j	c0e <malloc+0x9a>
 bcc:	f04a                	sd	s2,32(sp)
 bce:	e852                	sd	s4,16(sp)
 bd0:	e456                	sd	s5,8(sp)
 bd2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bd4:	00001797          	auipc	a5,0x1
 bd8:	9bc78793          	addi	a5,a5,-1604 # 1590 <base>
 bdc:	00001717          	auipc	a4,0x1
 be0:	9af73623          	sd	a5,-1620(a4) # 1588 <freep>
 be4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 be6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bea:	b7c1                	j	baa <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 bec:	6398                	ld	a4,0(a5)
 bee:	e118                	sd	a4,0(a0)
 bf0:	a08d                	j	c52 <malloc+0xde>
  hp->s.size = nu;
 bf2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bf6:	0541                	addi	a0,a0,16
 bf8:	00000097          	auipc	ra,0x0
 bfc:	efa080e7          	jalr	-262(ra) # af2 <free>
  return freep;
 c00:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c04:	c13d                	beqz	a0,c6a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c08:	4798                	lw	a4,8(a5)
 c0a:	02977463          	bgeu	a4,s1,c32 <malloc+0xbe>
    if(p == freep)
 c0e:	00093703          	ld	a4,0(s2)
 c12:	853e                	mv	a0,a5
 c14:	fef719e3          	bne	a4,a5,c06 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 c18:	8552                	mv	a0,s4
 c1a:	00000097          	auipc	ra,0x0
 c1e:	b9a080e7          	jalr	-1126(ra) # 7b4 <sbrk>
  if(p == (char*)-1)
 c22:	fd5518e3          	bne	a0,s5,bf2 <malloc+0x7e>
        return 0;
 c26:	4501                	li	a0,0
 c28:	7902                	ld	s2,32(sp)
 c2a:	6a42                	ld	s4,16(sp)
 c2c:	6aa2                	ld	s5,8(sp)
 c2e:	6b02                	ld	s6,0(sp)
 c30:	a03d                	j	c5e <malloc+0xea>
 c32:	7902                	ld	s2,32(sp)
 c34:	6a42                	ld	s4,16(sp)
 c36:	6aa2                	ld	s5,8(sp)
 c38:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c3a:	fae489e3          	beq	s1,a4,bec <malloc+0x78>
        p->s.size -= nunits;
 c3e:	4137073b          	subw	a4,a4,s3
 c42:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c44:	02071693          	slli	a3,a4,0x20
 c48:	01c6d713          	srli	a4,a3,0x1c
 c4c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c4e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c52:	00001717          	auipc	a4,0x1
 c56:	92a73b23          	sd	a0,-1738(a4) # 1588 <freep>
      return (void*)(p + 1);
 c5a:	01078513          	addi	a0,a5,16
  }
}
 c5e:	70e2                	ld	ra,56(sp)
 c60:	7442                	ld	s0,48(sp)
 c62:	74a2                	ld	s1,40(sp)
 c64:	69e2                	ld	s3,24(sp)
 c66:	6121                	addi	sp,sp,64
 c68:	8082                	ret
 c6a:	7902                	ld	s2,32(sp)
 c6c:	6a42                	ld	s4,16(sp)
 c6e:	6aa2                	ld	s5,8(sp)
 c70:	6b02                	ld	s6,0(sp)
 c72:	b7f5                	j	c5e <malloc+0xea>
