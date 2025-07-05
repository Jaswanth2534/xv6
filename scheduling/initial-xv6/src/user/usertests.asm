
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bbe080e7          	jalr	-1090(ra) # 5bce <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bac080e7          	jalr	-1108(ra) # 5bce <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0a250513          	addi	a0,a0,162 # 60e0 <malloc+0x10a>
      46:	00006097          	auipc	ra,0x6
      4a:	ed8080e7          	jalr	-296(ra) # 5f1e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b3e080e7          	jalr	-1218(ra) # 5b8e <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000c797          	auipc	a5,0xc
      5c:	86078793          	addi	a5,a5,-1952 # b8b8 <uninit>
      60:	0000e697          	auipc	a3,0xe
      64:	f6868693          	addi	a3,a3,-152 # dfc8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	08050513          	addi	a0,a0,128 # 6100 <malloc+0x12a>
      88:	00006097          	auipc	ra,0x6
      8c:	e96080e7          	jalr	-362(ra) # 5f1e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	afc080e7          	jalr	-1284(ra) # 5b8e <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	07050513          	addi	a0,a0,112 # 6118 <malloc+0x142>
      b0:	00006097          	auipc	ra,0x6
      b4:	b1e080e7          	jalr	-1250(ra) # 5bce <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	afa080e7          	jalr	-1286(ra) # 5bb6 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	07250513          	addi	a0,a0,114 # 6138 <malloc+0x162>
      ce:	00006097          	auipc	ra,0x6
      d2:	b00080e7          	jalr	-1280(ra) # 5bce <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	03a50513          	addi	a0,a0,58 # 6120 <malloc+0x14a>
      ee:	00006097          	auipc	ra,0x6
      f2:	e30080e7          	jalr	-464(ra) # 5f1e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	a96080e7          	jalr	-1386(ra) # 5b8e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	04650513          	addi	a0,a0,70 # 6148 <malloc+0x172>
     10a:	00006097          	auipc	ra,0x6
     10e:	e14080e7          	jalr	-492(ra) # 5f1e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a7a080e7          	jalr	-1414(ra) # 5b8e <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	04450513          	addi	a0,a0,68 # 6170 <malloc+0x19a>
     134:	00006097          	auipc	ra,0x6
     138:	aaa080e7          	jalr	-1366(ra) # 5bde <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	03050513          	addi	a0,a0,48 # 6170 <malloc+0x19a>
     148:	00006097          	auipc	ra,0x6
     14c:	a86080e7          	jalr	-1402(ra) # 5bce <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	02c58593          	addi	a1,a1,44 # 6180 <malloc+0x1aa>
     15c:	00006097          	auipc	ra,0x6
     160:	a52080e7          	jalr	-1454(ra) # 5bae <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	00850513          	addi	a0,a0,8 # 6170 <malloc+0x19a>
     170:	00006097          	auipc	ra,0x6
     174:	a5e080e7          	jalr	-1442(ra) # 5bce <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	00c58593          	addi	a1,a1,12 # 6188 <malloc+0x1b2>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a28080e7          	jalr	-1496(ra) # 5bae <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fdc50513          	addi	a0,a0,-36 # 6170 <malloc+0x19a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a42080e7          	jalr	-1470(ra) # 5bde <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a10080e7          	jalr	-1520(ra) # 5bb6 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a06080e7          	jalr	-1530(ra) # 5bb6 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fc650513          	addi	a0,a0,-58 # 6190 <malloc+0x1ba>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d4c080e7          	jalr	-692(ra) # 5f1e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9b2080e7          	jalr	-1614(ra) # 5b8e <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9be080e7          	jalr	-1602(ra) # 5bce <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	99e080e7          	jalr	-1634(ra) # 5bb6 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	998080e7          	jalr	-1640(ra) # 5bde <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f3c50513          	addi	a0,a0,-196 # 61b8 <malloc+0x1e2>
     284:	00006097          	auipc	ra,0x6
     288:	95a080e7          	jalr	-1702(ra) # 5bde <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f28a8a93          	addi	s5,s5,-216 # 61b8 <malloc+0x1e2>
      int cc = write(fd, buf, sz);
     298:	0000ea17          	auipc	s4,0xe
     29c:	d30a0a13          	addi	s4,s4,-720 # dfc8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x21>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	922080e7          	jalr	-1758(ra) # 5bce <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	8f0080e7          	jalr	-1808(ra) # 5bae <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	8dc080e7          	jalr	-1828(ra) # 5bae <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	8d6080e7          	jalr	-1834(ra) # 5bb6 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	8f4080e7          	jalr	-1804(ra) # 5bde <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	eb650513          	addi	a0,a0,-330 # 61c8 <malloc+0x1f2>
     31a:	00006097          	auipc	ra,0x6
     31e:	c04080e7          	jalr	-1020(ra) # 5f1e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	86a080e7          	jalr	-1942(ra) # 5b8e <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	eb450513          	addi	a0,a0,-332 # 61e8 <malloc+0x212>
     33c:	00006097          	auipc	ra,0x6
     340:	be2080e7          	jalr	-1054(ra) # 5f1e <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	848080e7          	jalr	-1976(ra) # 5b8e <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	ea250513          	addi	a0,a0,-350 # 6200 <malloc+0x22a>
     366:	00006097          	auipc	ra,0x6
     36a:	878080e7          	jalr	-1928(ra) # 5bde <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e8e98993          	addi	s3,s3,-370 # 6200 <malloc+0x22a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	848080e7          	jalr	-1976(ra) # 5bce <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	816080e7          	jalr	-2026(ra) # 5bae <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	814080e7          	jalr	-2028(ra) # 5bb6 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	832080e7          	jalr	-1998(ra) # 5bde <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e4250513          	addi	a0,a0,-446 # 6200 <malloc+0x22a>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	808080e7          	jalr	-2040(ra) # 5bce <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	db258593          	addi	a1,a1,-590 # 6188 <malloc+0x1b2>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7d0080e7          	jalr	2000(ra) # 5bae <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e3450513          	addi	a0,a0,-460 # 6220 <malloc+0x24a>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b2a080e7          	jalr	-1238(ra) # 5f1e <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	790080e7          	jalr	1936(ra) # 5b8e <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e0250513          	addi	a0,a0,-510 # 6208 <malloc+0x232>
     40e:	00006097          	auipc	ra,0x6
     412:	b10080e7          	jalr	-1264(ra) # 5f1e <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	776080e7          	jalr	1910(ra) # 5b8e <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	de850513          	addi	a0,a0,-536 # 6208 <malloc+0x232>
     428:	00006097          	auipc	ra,0x6
     42c:	af6080e7          	jalr	-1290(ra) # 5f1e <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	75c080e7          	jalr	1884(ra) # 5b8e <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	77a080e7          	jalr	1914(ra) # 5bb6 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	dbc50513          	addi	a0,a0,-580 # 6200 <malloc+0x22a>
     44c:	00005097          	auipc	ra,0x5
     450:	792080e7          	jalr	1938(ra) # 5bde <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	738080e7          	jalr	1848(ra) # 5b8e <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	734080e7          	jalr	1844(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	714080e7          	jalr	1812(ra) # 5bce <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	6f0080e7          	jalr	1776(ra) # 5bb6 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6cc080e7          	jalr	1740(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	ce0a0a13          	addi	s4,s4,-800 # 6230 <malloc+0x25a>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	66c080e7          	jalr	1644(ra) # 5bce <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	63a080e7          	jalr	1594(ra) # 5bae <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	634080e7          	jalr	1588(ra) # 5bb6 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	652080e7          	jalr	1618(ra) # 5bde <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	614080e7          	jalr	1556(ra) # 5bae <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	5f4080e7          	jalr	1524(ra) # 5b9e <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	5f0080e7          	jalr	1520(ra) # 5bae <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	5e8080e7          	jalr	1512(ra) # 5bb6 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	5dc080e7          	jalr	1500(ra) # 5bb6 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c3c50513          	addi	a0,a0,-964 # 6238 <malloc+0x262>
     604:	00006097          	auipc	ra,0x6
     608:	91a080e7          	jalr	-1766(ra) # 5f1e <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	580080e7          	jalr	1408(ra) # 5b8e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c3650513          	addi	a0,a0,-970 # 6250 <malloc+0x27a>
     622:	00006097          	auipc	ra,0x6
     626:	8fc080e7          	jalr	-1796(ra) # 5f1e <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	562080e7          	jalr	1378(ra) # 5b8e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c4850513          	addi	a0,a0,-952 # 6280 <malloc+0x2aa>
     640:	00006097          	auipc	ra,0x6
     644:	8de080e7          	jalr	-1826(ra) # 5f1e <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	544080e7          	jalr	1348(ra) # 5b8e <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c5e50513          	addi	a0,a0,-930 # 62b0 <malloc+0x2da>
     65a:	00006097          	auipc	ra,0x6
     65e:	8c4080e7          	jalr	-1852(ra) # 5f1e <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	52a080e7          	jalr	1322(ra) # 5b8e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c5050513          	addi	a0,a0,-944 # 62c0 <malloc+0x2ea>
     678:	00006097          	auipc	ra,0x6
     67c:	8a6080e7          	jalr	-1882(ra) # 5f1e <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	50c080e7          	jalr	1292(ra) # 5b8e <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c42a0a13          	addi	s4,s4,-958 # 62f0 <malloc+0x31a>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	ad2a8a93          	addi	s5,s5,-1326 # 6188 <malloc+0x1b2>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	508080e7          	jalr	1288(ra) # 5bce <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	4ce080e7          	jalr	1230(ra) # 5ba6 <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	4d0080e7          	jalr	1232(ra) # 5bb6 <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4ac080e7          	jalr	1196(ra) # 5b9e <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4a8080e7          	jalr	1192(ra) # 5bae <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	48a080e7          	jalr	1162(ra) # 5ba6 <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	48a080e7          	jalr	1162(ra) # 5bb6 <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	47e080e7          	jalr	1150(ra) # 5bb6 <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	b9c50513          	addi	a0,a0,-1124 # 62f8 <malloc+0x322>
     764:	00005097          	auipc	ra,0x5
     768:	7ba080e7          	jalr	1978(ra) # 5f1e <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	420080e7          	jalr	1056(ra) # 5b8e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	b9650513          	addi	a0,a0,-1130 # 6310 <malloc+0x33a>
     782:	00005097          	auipc	ra,0x5
     786:	79c080e7          	jalr	1948(ra) # 5f1e <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	402080e7          	jalr	1026(ra) # 5b8e <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	b1c50513          	addi	a0,a0,-1252 # 62b0 <malloc+0x2da>
     79c:	00005097          	auipc	ra,0x5
     7a0:	782080e7          	jalr	1922(ra) # 5f1e <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	3e8080e7          	jalr	1000(ra) # 5b8e <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	b9250513          	addi	a0,a0,-1134 # 6340 <malloc+0x36a>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	768080e7          	jalr	1896(ra) # 5f1e <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	3ce080e7          	jalr	974(ra) # 5b8e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b8c50513          	addi	a0,a0,-1140 # 6358 <malloc+0x382>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	74a080e7          	jalr	1866(ra) # 5f1e <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3b0080e7          	jalr	944(ra) # 5b8e <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	97650513          	addi	a0,a0,-1674 # 6170 <malloc+0x19a>
     802:	00005097          	auipc	ra,0x5
     806:	3dc080e7          	jalr	988(ra) # 5bde <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	96250513          	addi	a0,a0,-1694 # 6170 <malloc+0x19a>
     816:	00005097          	auipc	ra,0x5
     81a:	3b8080e7          	jalr	952(ra) # 5bce <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	95e58593          	addi	a1,a1,-1698 # 6180 <malloc+0x1aa>
     82a:	00005097          	auipc	ra,0x5
     82e:	384080e7          	jalr	900(ra) # 5bae <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	382080e7          	jalr	898(ra) # 5bb6 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	93250513          	addi	a0,a0,-1742 # 6170 <malloc+0x19a>
     846:	00005097          	auipc	ra,0x5
     84a:	388080e7          	jalr	904(ra) # 5bce <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	34e080e7          	jalr	846(ra) # 5ba6 <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	90650513          	addi	a0,a0,-1786 # 6170 <malloc+0x19a>
     872:	00005097          	auipc	ra,0x5
     876:	35c080e7          	jalr	860(ra) # 5bce <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	8f250513          	addi	a0,a0,-1806 # 6170 <malloc+0x19a>
     886:	00005097          	auipc	ra,0x5
     88a:	348080e7          	jalr	840(ra) # 5bce <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	30e080e7          	jalr	782(ra) # 5ba6 <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	2f8080e7          	jalr	760(ra) # 5ba6 <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	b2c58593          	addi	a1,a1,-1236 # 63e8 <malloc+0x412>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	2e8080e7          	jalr	744(ra) # 5bae <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	2ce080e7          	jalr	718(ra) # 5ba6 <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2b6080e7          	jalr	694(ra) # 5ba6 <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	87250513          	addi	a0,a0,-1934 # 6170 <malloc+0x19a>
     906:	00005097          	auipc	ra,0x5
     90a:	2d8080e7          	jalr	728(ra) # 5bde <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2a6080e7          	jalr	678(ra) # 5bb6 <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	29c080e7          	jalr	668(ra) # 5bb6 <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	292080e7          	jalr	658(ra) # 5bb6 <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a4650513          	addi	a0,a0,-1466 # 6388 <malloc+0x3b2>
     94a:	00005097          	auipc	ra,0x5
     94e:	5d4080e7          	jalr	1492(ra) # 5f1e <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	23a080e7          	jalr	570(ra) # 5b8e <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a4a50513          	addi	a0,a0,-1462 # 63a8 <malloc+0x3d2>
     966:	00005097          	auipc	ra,0x5
     96a:	5b8080e7          	jalr	1464(ra) # 5f1e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a4650513          	addi	a0,a0,-1466 # 63b8 <malloc+0x3e2>
     97a:	00005097          	auipc	ra,0x5
     97e:	5a4080e7          	jalr	1444(ra) # 5f1e <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	20a080e7          	jalr	522(ra) # 5b8e <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a4a50513          	addi	a0,a0,-1462 # 63d8 <malloc+0x402>
     996:	00005097          	auipc	ra,0x5
     99a:	588080e7          	jalr	1416(ra) # 5f1e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a1650513          	addi	a0,a0,-1514 # 63b8 <malloc+0x3e2>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	574080e7          	jalr	1396(ra) # 5f1e <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	1da080e7          	jalr	474(ra) # 5b8e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a3050513          	addi	a0,a0,-1488 # 63f0 <malloc+0x41a>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	556080e7          	jalr	1366(ra) # 5f1e <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1bc080e7          	jalr	444(ra) # 5b8e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a3250513          	addi	a0,a0,-1486 # 6410 <malloc+0x43a>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	538080e7          	jalr	1336(ra) # 5f1e <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	19e080e7          	jalr	414(ra) # 5b8e <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	a1e50513          	addi	a0,a0,-1506 # 6430 <malloc+0x45a>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1b4080e7          	jalr	436(ra) # 5bce <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	a2e98993          	addi	s3,s3,-1490 # 6458 <malloc+0x482>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	a5ea8a93          	addi	s5,s5,-1442 # 6490 <malloc+0x4ba>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	16a080e7          	jalr	362(ra) # 5bae <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	156080e7          	jalr	342(ra) # 5bae <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	148080e7          	jalr	328(ra) # 5bb6 <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	9b850513          	addi	a0,a0,-1608 # 6430 <malloc+0x45a>
     a80:	00005097          	auipc	ra,0x5
     a84:	14e080e7          	jalr	334(ra) # 5bce <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000d597          	auipc	a1,0xd
     a96:	53658593          	addi	a1,a1,1334 # dfc8 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	10c080e7          	jalr	268(ra) # 5ba6 <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	10a080e7          	jalr	266(ra) # 5bb6 <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	97c50513          	addi	a0,a0,-1668 # 6430 <malloc+0x45a>
     abc:	00005097          	auipc	ra,0x5
     ac0:	122080e7          	jalr	290(ra) # 5bde <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	95a50513          	addi	a0,a0,-1702 # 6438 <malloc+0x462>
     ae6:	00005097          	auipc	ra,0x5
     aea:	438080e7          	jalr	1080(ra) # 5f1e <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	09e080e7          	jalr	158(ra) # 5b8e <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	96c50513          	addi	a0,a0,-1684 # 6468 <malloc+0x492>
     b04:	00005097          	auipc	ra,0x5
     b08:	41a080e7          	jalr	1050(ra) # 5f1e <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	080080e7          	jalr	128(ra) # 5b8e <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	98650513          	addi	a0,a0,-1658 # 64a0 <malloc+0x4ca>
     b22:	00005097          	auipc	ra,0x5
     b26:	3fc080e7          	jalr	1020(ra) # 5f1e <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	062080e7          	jalr	98(ra) # 5b8e <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	99250513          	addi	a0,a0,-1646 # 64c8 <malloc+0x4f2>
     b3e:	00005097          	auipc	ra,0x5
     b42:	3e0080e7          	jalr	992(ra) # 5f1e <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	046080e7          	jalr	70(ra) # 5b8e <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	99650513          	addi	a0,a0,-1642 # 64e8 <malloc+0x512>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3c4080e7          	jalr	964(ra) # 5f1e <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	02a080e7          	jalr	42(ra) # 5b8e <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	99250513          	addi	a0,a0,-1646 # 6500 <malloc+0x52a>
     b76:	00005097          	auipc	ra,0x5
     b7a:	3a8080e7          	jalr	936(ra) # 5f1e <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	00e080e7          	jalr	14(ra) # 5b8e <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	98050513          	addi	a0,a0,-1664 # 6520 <malloc+0x54a>
     ba8:	00005097          	auipc	ra,0x5
     bac:	026080e7          	jalr	38(ra) # 5bce <open>
     bb0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb4:	0000d917          	auipc	s2,0xd
     bb8:	41490913          	addi	s2,s2,1044 # dfc8 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbc:	10c00a13          	li	s4,268
  if(fd < 0){
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	fde080e7          	jalr	-34(ra) # 5bae <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	fce080e7          	jalr	-50(ra) # 5bb6 <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	92e50513          	addi	a0,a0,-1746 # 6520 <malloc+0x54a>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	fd4080e7          	jalr	-44(ra) # 5bce <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000d917          	auipc	s2,0xd
     c0a:	3c290913          	addi	s2,s2,962 # dfc8 <buf>
  if(fd < 0){
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	f8c080e7          	jalr	-116(ra) # 5ba6 <read>
    if(i == 0){
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if(i != BSIZE){
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	8ee50513          	addi	a0,a0,-1810 # 6528 <malloc+0x552>
     c42:	00005097          	auipc	ra,0x5
     c46:	2dc080e7          	jalr	732(ra) # 5f1e <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	f42080e7          	jalr	-190(ra) # 5b8e <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	8f050513          	addi	a0,a0,-1808 # 6548 <malloc+0x572>
     c60:	00005097          	auipc	ra,0x5
     c64:	2be080e7          	jalr	702(ra) # 5f1e <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	f24080e7          	jalr	-220(ra) # 5b8e <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	8fc50513          	addi	a0,a0,-1796 # 6570 <malloc+0x59a>
     c7c:	00005097          	auipc	ra,0x5
     c80:	2a2080e7          	jalr	674(ra) # 5f1e <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f08080e7          	jalr	-248(ra) # 5b8e <exit>
      if(n == MAXFILE - 1){
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	f1e080e7          	jalr	-226(ra) # 5bb6 <close>
  if(unlink("big") < 0){
     ca0:	00006517          	auipc	a0,0x6
     ca4:	88050513          	addi	a0,a0,-1920 # 6520 <malloc+0x54a>
     ca8:	00005097          	auipc	ra,0x5
     cac:	f36080e7          	jalr	-202(ra) # 5bde <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	8c450513          	addi	a0,a0,-1852 # 6590 <malloc+0x5ba>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	24a080e7          	jalr	586(ra) # 5f1e <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	eb0080e7          	jalr	-336(ra) # 5b8e <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	8ce50513          	addi	a0,a0,-1842 # 65b8 <malloc+0x5e2>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	22c080e7          	jalr	556(ra) # 5f1e <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	e92080e7          	jalr	-366(ra) # 5b8e <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	8c850513          	addi	a0,a0,-1848 # 65d0 <malloc+0x5fa>
     d10:	00005097          	auipc	ra,0x5
     d14:	20e080e7          	jalr	526(ra) # 5f1e <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	e74080e7          	jalr	-396(ra) # 5b8e <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	8d450513          	addi	a0,a0,-1836 # 65f8 <malloc+0x622>
     d2c:	00005097          	auipc	ra,0x5
     d30:	1f2080e7          	jalr	498(ra) # 5f1e <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	e58080e7          	jalr	-424(ra) # 5b8e <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	8be50513          	addi	a0,a0,-1858 # 6610 <malloc+0x63a>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	e74080e7          	jalr	-396(ra) # 5bce <open>
  if(fd < 0){
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	8d658593          	addi	a1,a1,-1834 # 6640 <malloc+0x66a>
     d72:	00005097          	auipc	ra,0x5
     d76:	e3c080e7          	jalr	-452(ra) # 5bae <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	e3a080e7          	jalr	-454(ra) # 5bb6 <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	88a50513          	addi	a0,a0,-1910 # 6610 <malloc+0x63a>
     d8e:	00005097          	auipc	ra,0x5
     d92:	e40080e7          	jalr	-448(ra) # 5bce <open>
     d96:	84aa                	mv	s1,a0
  if(fd < 0){
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9c:	00006517          	auipc	a0,0x6
     da0:	87450513          	addi	a0,a0,-1932 # 6610 <malloc+0x63a>
     da4:	00005097          	auipc	ra,0x5
     da8:	e3a080e7          	jalr	-454(ra) # 5bde <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	85e50513          	addi	a0,a0,-1954 # 6610 <malloc+0x63a>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e14080e7          	jalr	-492(ra) # 5bce <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	8c258593          	addi	a1,a1,-1854 # 6688 <malloc+0x6b2>
     dce:	00005097          	auipc	ra,0x5
     dd2:	de0080e7          	jalr	-544(ra) # 5bae <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	dde080e7          	jalr	-546(ra) # 5bb6 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000d597          	auipc	a1,0xd
     de6:	1e658593          	addi	a1,a1,486 # dfc8 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	dba080e7          	jalr	-582(ra) # 5ba6 <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfa:	0000d717          	auipc	a4,0xd
     dfe:	1ce74703          	lbu	a4,462(a4) # dfc8 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0a:	4629                	li	a2,10
     e0c:	0000d597          	auipc	a1,0xd
     e10:	1bc58593          	addi	a1,a1,444 # dfc8 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	d98080e7          	jalr	-616(ra) # 5bae <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	d90080e7          	jalr	-624(ra) # 5bb6 <close>
  unlink("unlinkread");
     e2e:	00005517          	auipc	a0,0x5
     e32:	7e250513          	addi	a0,a0,2018 # 6610 <malloc+0x63a>
     e36:	00005097          	auipc	ra,0x5
     e3a:	da8080e7          	jalr	-600(ra) # 5bde <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00005517          	auipc	a0,0x5
     e52:	7d250513          	addi	a0,a0,2002 # 6620 <malloc+0x64a>
     e56:	00005097          	auipc	ra,0x5
     e5a:	0c8080e7          	jalr	200(ra) # 5f1e <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	d2e080e7          	jalr	-722(ra) # 5b8e <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00005517          	auipc	a0,0x5
     e6e:	7de50513          	addi	a0,a0,2014 # 6648 <malloc+0x672>
     e72:	00005097          	auipc	ra,0x5
     e76:	0ac080e7          	jalr	172(ra) # 5f1e <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d12080e7          	jalr	-750(ra) # 5b8e <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00005517          	auipc	a0,0x5
     e8a:	7e250513          	addi	a0,a0,2018 # 6668 <malloc+0x692>
     e8e:	00005097          	auipc	ra,0x5
     e92:	090080e7          	jalr	144(ra) # 5f1e <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	cf6080e7          	jalr	-778(ra) # 5b8e <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00005517          	auipc	a0,0x5
     ea6:	7ee50513          	addi	a0,a0,2030 # 6690 <malloc+0x6ba>
     eaa:	00005097          	auipc	ra,0x5
     eae:	074080e7          	jalr	116(ra) # 5f1e <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	cda080e7          	jalr	-806(ra) # 5b8e <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00005517          	auipc	a0,0x5
     ec2:	7f250513          	addi	a0,a0,2034 # 66b0 <malloc+0x6da>
     ec6:	00005097          	auipc	ra,0x5
     eca:	058080e7          	jalr	88(ra) # 5f1e <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	cbe080e7          	jalr	-834(ra) # 5b8e <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00005517          	auipc	a0,0x5
     ede:	7f650513          	addi	a0,a0,2038 # 66d0 <malloc+0x6fa>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	03c080e7          	jalr	60(ra) # 5f1e <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	ca2080e7          	jalr	-862(ra) # 5b8e <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00005517          	auipc	a0,0x5
     f06:	7ee50513          	addi	a0,a0,2030 # 66f0 <malloc+0x71a>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	cd4080e7          	jalr	-812(ra) # 5bde <unlink>
  unlink("lf2");
     f12:	00005517          	auipc	a0,0x5
     f16:	7e650513          	addi	a0,a0,2022 # 66f8 <malloc+0x722>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	cc4080e7          	jalr	-828(ra) # 5bde <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00005517          	auipc	a0,0x5
     f2a:	7ca50513          	addi	a0,a0,1994 # 66f0 <malloc+0x71a>
     f2e:	00005097          	auipc	ra,0x5
     f32:	ca0080e7          	jalr	-864(ra) # 5bce <open>
  if(fd < 0){
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	70258593          	addi	a1,a1,1794 # 6640 <malloc+0x66a>
     f46:	00005097          	auipc	ra,0x5
     f4a:	c68080e7          	jalr	-920(ra) # 5bae <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	c60080e7          	jalr	-928(ra) # 5bb6 <close>
  if(link("lf1", "lf2") < 0){
     f5e:	00005597          	auipc	a1,0x5
     f62:	79a58593          	addi	a1,a1,1946 # 66f8 <malloc+0x722>
     f66:	00005517          	auipc	a0,0x5
     f6a:	78a50513          	addi	a0,a0,1930 # 66f0 <malloc+0x71a>
     f6e:	00005097          	auipc	ra,0x5
     f72:	c80080e7          	jalr	-896(ra) # 5bee <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	77650513          	addi	a0,a0,1910 # 66f0 <malloc+0x71a>
     f82:	00005097          	auipc	ra,0x5
     f86:	c5c080e7          	jalr	-932(ra) # 5bde <unlink>
  if(open("lf1", 0) >= 0){
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	76450513          	addi	a0,a0,1892 # 66f0 <malloc+0x71a>
     f94:	00005097          	auipc	ra,0x5
     f98:	c3a080e7          	jalr	-966(ra) # 5bce <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	75650513          	addi	a0,a0,1878 # 66f8 <malloc+0x722>
     faa:	00005097          	auipc	ra,0x5
     fae:	c24080e7          	jalr	-988(ra) # 5bce <open>
     fb2:	84aa                	mv	s1,a0
  if(fd < 0){
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fb8:	660d                	lui	a2,0x3
     fba:	0000d597          	auipc	a1,0xd
     fbe:	00e58593          	addi	a1,a1,14 # dfc8 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	be4080e7          	jalr	-1052(ra) # 5ba6 <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	be4080e7          	jalr	-1052(ra) # 5bb6 <close>
  if(link("lf2", "lf2") >= 0){
     fda:	00005597          	auipc	a1,0x5
     fde:	71e58593          	addi	a1,a1,1822 # 66f8 <malloc+0x722>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c0a080e7          	jalr	-1014(ra) # 5bee <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	70850513          	addi	a0,a0,1800 # 66f8 <malloc+0x722>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	be6080e7          	jalr	-1050(ra) # 5bde <unlink>
  if(link("lf2", "lf1") >= 0){
    1000:	00005597          	auipc	a1,0x5
    1004:	6f058593          	addi	a1,a1,1776 # 66f0 <malloc+0x71a>
    1008:	00005517          	auipc	a0,0x5
    100c:	6f050513          	addi	a0,a0,1776 # 66f8 <malloc+0x722>
    1010:	00005097          	auipc	ra,0x5
    1014:	bde080e7          	jalr	-1058(ra) # 5bee <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101c:	00005597          	auipc	a1,0x5
    1020:	6d458593          	addi	a1,a1,1748 # 66f0 <malloc+0x71a>
    1024:	00005517          	auipc	a0,0x5
    1028:	7dc50513          	addi	a0,a0,2012 # 6800 <malloc+0x82a>
    102c:	00005097          	auipc	ra,0x5
    1030:	bc2080e7          	jalr	-1086(ra) # 5bee <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	6ba50513          	addi	a0,a0,1722 # 6700 <malloc+0x72a>
    104e:	00005097          	auipc	ra,0x5
    1052:	ed0080e7          	jalr	-304(ra) # 5f1e <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	b36080e7          	jalr	-1226(ra) # 5b8e <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	6b650513          	addi	a0,a0,1718 # 6718 <malloc+0x742>
    106a:	00005097          	auipc	ra,0x5
    106e:	eb4080e7          	jalr	-332(ra) # 5f1e <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	b1a080e7          	jalr	-1254(ra) # 5b8e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	6b250513          	addi	a0,a0,1714 # 6730 <malloc+0x75a>
    1086:	00005097          	auipc	ra,0x5
    108a:	e98080e7          	jalr	-360(ra) # 5f1e <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	afe080e7          	jalr	-1282(ra) # 5b8e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	6b650513          	addi	a0,a0,1718 # 6750 <malloc+0x77a>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	e7c080e7          	jalr	-388(ra) # 5f1e <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	ae2080e7          	jalr	-1310(ra) # 5b8e <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	6ca50513          	addi	a0,a0,1738 # 6780 <malloc+0x7aa>
    10be:	00005097          	auipc	ra,0x5
    10c2:	e60080e7          	jalr	-416(ra) # 5f1e <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	ac6080e7          	jalr	-1338(ra) # 5b8e <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	6c650513          	addi	a0,a0,1734 # 6798 <malloc+0x7c2>
    10da:	00005097          	auipc	ra,0x5
    10de:	e44080e7          	jalr	-444(ra) # 5f1e <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	aaa080e7          	jalr	-1366(ra) # 5b8e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	6c250513          	addi	a0,a0,1730 # 67b0 <malloc+0x7da>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	e28080e7          	jalr	-472(ra) # 5f1e <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	a8e080e7          	jalr	-1394(ra) # 5b8e <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	6ce50513          	addi	a0,a0,1742 # 67d8 <malloc+0x802>
    1112:	00005097          	auipc	ra,0x5
    1116:	e0c080e7          	jalr	-500(ra) # 5f1e <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	a72080e7          	jalr	-1422(ra) # 5b8e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	6e250513          	addi	a0,a0,1762 # 6808 <malloc+0x832>
    112e:	00005097          	auipc	ra,0x5
    1132:	df0080e7          	jalr	-528(ra) # 5f1e <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	a56080e7          	jalr	-1450(ra) # 5b8e <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	addi	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1156:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1158:	00005997          	auipc	s3,0x5
    115c:	6d098993          	addi	s3,s3,1744 # 6828 <malloc+0x852>
    1160:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	a82080e7          	jalr	-1406(ra) # 5bee <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	addi	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	6a450513          	addi	a0,a0,1700 # 6838 <malloc+0x862>
    119c:	00005097          	auipc	ra,0x5
    11a0:	d82080e7          	jalr	-638(ra) # 5f1e <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	9e8080e7          	jalr	-1560(ra) # 5b8e <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	addi	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	addi	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	69450513          	addi	a0,a0,1684 # 6858 <malloc+0x882>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	a12080e7          	jalr	-1518(ra) # 5bde <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	68050513          	addi	a0,a0,1664 # 6858 <malloc+0x882>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	9ee080e7          	jalr	-1554(ra) # 5bce <open>
  if(fd < 0){
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	9ca080e7          	jalr	-1590(ra) # 5bb6 <close>
  for(i = 0; i < N; i++){
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	65ea0a13          	addi	s4,s4,1630 # 6858 <malloc+0x882>
  for(i = 0; i < N; i++){
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraiw	a4,s2,0x1f
    120e:	01a7571b          	srliw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraiw	a3,a5,0x6
    121a:	0306869b          	addiw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	andi	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addiw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1234:	fb040593          	addi	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	9b4080e7          	jalr	-1612(ra) # 5bee <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1246:	2905                	addiw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	60c50513          	addi	a0,a0,1548 # 6858 <malloc+0x882>
    1254:	00005097          	auipc	ra,0x5
    1258:	98a080e7          	jalr	-1654(ra) # 5bde <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraiw	a4,s1,0x1f
    126c:	01a7571b          	srliw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraiw	a3,a5,0x6
    1278:	0306869b          	addiw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	andi	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addiw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1292:	fb040513          	addi	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	948080e7          	jalr	-1720(ra) # 5bde <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a0:	2485                	addiw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	addi	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	5a450513          	addi	a0,a0,1444 # 6860 <malloc+0x88a>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	c5a080e7          	jalr	-934(ra) # 5f1e <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	8c0080e7          	jalr	-1856(ra) # 5b8e <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	addi	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	5a450513          	addi	a0,a0,1444 # 6880 <malloc+0x8aa>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	c3a080e7          	jalr	-966(ra) # 5f1e <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	8a0080e7          	jalr	-1888(ra) # 5b8e <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	5a850513          	addi	a0,a0,1448 # 68a0 <malloc+0x8ca>
    1300:	00005097          	auipc	ra,0x5
    1304:	c1e080e7          	jalr	-994(ra) # 5f1e <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	884080e7          	jalr	-1916(ra) # 5b8e <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	addi	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00009497          	auipc	s1,0x9
    1324:	04048493          	addi	s1,s1,64 # a360 <big>
    1328:	fd840593          	addi	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	898080e7          	jalr	-1896(ra) # 5bc6 <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	866080e7          	jalr	-1946(ra) # 5b9e <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	84c080e7          	jalr	-1972(ra) # 5b8e <exit>

000000000000134a <badarg>:
{
    134a:	7139                	addi	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	addi	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	addi	s1,s1,848 # c350 <uninit+0xa98>
    argv[0] = (char*)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	db498993          	addi	s3,s3,-588 # 6118 <malloc+0x142>
    argv[0] = (char*)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	addi	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	84c080e7          	jalr	-1972(ra) # 5bc6 <exec>
  for(int i = 0; i < 50000; i++){
    1382:	34fd                	addiw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	806080e7          	jalr	-2042(ra) # 5b8e <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	addi	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	addi	a5,s0,-152
    139c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13a8:	0785                	addi	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	addi	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	828080e7          	jalr	-2008(ra) # 5bde <unlink>
  if(ret != -1){
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	addi	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	802080e7          	jalr	-2046(ra) # 5bce <open>
  if(fd != -1){
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	addi	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	80e080e7          	jalr	-2034(ra) # 5bee <link>
  if(ret != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13ee:	00006797          	auipc	a5,0x6
    13f2:	70a78793          	addi	a5,a5,1802 # 7af8 <malloc+0x1b22>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	addi	a1,s0,-168
    1402:	f6840513          	addi	a0,s0,-152
    1406:	00004097          	auipc	ra,0x4
    140a:	7c0080e7          	jalr	1984(ra) # 5bc6 <exec>
  if(ret != -1){
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	772080e7          	jalr	1906(ra) # 5b86 <fork>
  if(pid < 0){
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if(pid == 0){
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00009797          	auipc	a5,0x9
    1428:	48c78793          	addi	a5,a5,1164 # a8b0 <big.0>
    142c:	0000a697          	auipc	a3,0xa
    1430:	48468693          	addi	a3,a3,1156 # b8b0 <big.0+0x1000>
      big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143c:	0785                	addi	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	0000a797          	auipc	a5,0xa
    1446:	46078723          	sb	zero,1134(a5) # b8b0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144a:	00007797          	auipc	a5,0x7
    144e:	0e678793          	addi	a5,a5,230 # 8530 <malloc+0x255a>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	addi	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	caa50513          	addi	a0,a0,-854 # 6118 <malloc+0x142>
    1476:	00004097          	auipc	ra,0x4
    147a:	750080e7          	jalr	1872(ra) # 5bc6 <exec>
    if(ret != -1){
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	4c250513          	addi	a0,a0,1218 # 6948 <malloc+0x972>
    148e:	00005097          	auipc	ra,0x5
    1492:	a90080e7          	jalr	-1392(ra) # 5f1e <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	6f6080e7          	jalr	1782(ra) # 5b8e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	addi	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	41a50513          	addi	a0,a0,1050 # 68c0 <malloc+0x8ea>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	a70080e7          	jalr	-1424(ra) # 5f1e <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	6d6080e7          	jalr	1750(ra) # 5b8e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	addi	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	41a50513          	addi	a0,a0,1050 # 68e0 <malloc+0x90a>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	a50080e7          	jalr	-1456(ra) # 5f1e <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	6b6080e7          	jalr	1718(ra) # 5b8e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	addi	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	41850513          	addi	a0,a0,1048 # 6900 <malloc+0x92a>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	a2e080e7          	jalr	-1490(ra) # 5f1e <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	694080e7          	jalr	1684(ra) # 5b8e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	addi	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	42050513          	addi	a0,a0,1056 # 6928 <malloc+0x952>
    1510:	00005097          	auipc	ra,0x5
    1514:	a0e080e7          	jalr	-1522(ra) # 5f1e <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	674080e7          	jalr	1652(ra) # 5b8e <exit>
    printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	88650513          	addi	a0,a0,-1914 # 6da8 <malloc+0xdd2>
    152a:	00005097          	auipc	ra,0x5
    152e:	9f4080e7          	jalr	-1548(ra) # 5f1e <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	65a080e7          	jalr	1626(ra) # 5b8e <exit>
    exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	64e080e7          	jalr	1614(ra) # 5b8e <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	addi	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	646080e7          	jalr	1606(ra) # 5b96 <wait>
  if(st != 747){
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	addi	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	40450513          	addi	a0,a0,1028 # 6970 <malloc+0x99a>
    1574:	00005097          	auipc	ra,0x5
    1578:	9aa080e7          	jalr	-1622(ra) # 5f1e <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	610080e7          	jalr	1552(ra) # 5b8e <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	addi	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	e8ca                	sd	s2,80(sp)
    158e:	1880                	addi	s0,sp,112
    1590:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1592:	60100593          	li	a1,1537
    1596:	00005517          	auipc	a0,0x5
    159a:	bda50513          	addi	a0,a0,-1062 # 6170 <malloc+0x19a>
    159e:	00004097          	auipc	ra,0x4
    15a2:	630080e7          	jalr	1584(ra) # 5bce <open>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	610080e7          	jalr	1552(ra) # 5bb6 <close>
  pid = fork();
    15ae:	00004097          	auipc	ra,0x4
    15b2:	5d8080e7          	jalr	1496(ra) # 5b86 <fork>
  if(pid < 0){
    15b6:	08054463          	bltz	a0,163e <truncate3+0xb8>
  if(pid == 0){
    15ba:	e16d                	bnez	a0,169c <truncate3+0x116>
    15bc:	eca6                	sd	s1,88(sp)
    15be:	e4ce                	sd	s3,72(sp)
    15c0:	e0d2                	sd	s4,64(sp)
    15c2:	fc56                	sd	s5,56(sp)
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	ba8a0a13          	addi	s4,s4,-1112 # 6170 <malloc+0x19a>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	400a8a93          	addi	s5,s5,1024 # 69d0 <malloc+0x9fa>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	5f2080e7          	jalr	1522(ra) # 5bce <open>
    15e4:	84aa                	mv	s1,a0
      if(fd < 0){
    15e6:	06054e63          	bltz	a0,1662 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	5c0080e7          	jalr	1472(ra) # 5bae <write>
      if(n != 10){
    15f6:	47a9                	li	a5,10
    15f8:	08f51363          	bne	a0,a5,167e <truncate3+0xf8>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	5b8080e7          	jalr	1464(ra) # 5bb6 <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	5c4080e7          	jalr	1476(ra) # 5bce <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	addi	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	58a080e7          	jalr	1418(ra) # 5ba6 <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	590080e7          	jalr	1424(ra) # 5bb6 <close>
    for(int i = 0; i < 100; i++){
    162e:	39fd                	addiw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	558080e7          	jalr	1368(ra) # 5b8e <exit>
    163e:	eca6                	sd	s1,88(sp)
    1640:	e4ce                	sd	s3,72(sp)
    1642:	e0d2                	sd	s4,64(sp)
    1644:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	35850513          	addi	a0,a0,856 # 69a0 <malloc+0x9ca>
    1650:	00005097          	auipc	ra,0x5
    1654:	8ce080e7          	jalr	-1842(ra) # 5f1e <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	534080e7          	jalr	1332(ra) # 5b8e <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	35450513          	addi	a0,a0,852 # 69b8 <malloc+0x9e2>
    166c:	00005097          	auipc	ra,0x5
    1670:	8b2080e7          	jalr	-1870(ra) # 5f1e <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	518080e7          	jalr	1304(ra) # 5b8e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	35e50513          	addi	a0,a0,862 # 69e0 <malloc+0xa0a>
    168a:	00005097          	auipc	ra,0x5
    168e:	894080e7          	jalr	-1900(ra) # 5f1e <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	4fa080e7          	jalr	1274(ra) # 5b8e <exit>
    169c:	eca6                	sd	s1,88(sp)
    169e:	e4ce                	sd	s3,72(sp)
    16a0:	e0d2                	sd	s4,64(sp)
    16a2:	fc56                	sd	s5,56(sp)
    16a4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a8:	00005a17          	auipc	s4,0x5
    16ac:	ac8a0a13          	addi	s4,s4,-1336 # 6170 <malloc+0x19a>
    int n = write(fd, "xxx", 3);
    16b0:	00005a97          	auipc	s5,0x5
    16b4:	350a8a93          	addi	s5,s5,848 # 6a00 <malloc+0xa2a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b8:	60100593          	li	a1,1537
    16bc:	8552                	mv	a0,s4
    16be:	00004097          	auipc	ra,0x4
    16c2:	510080e7          	jalr	1296(ra) # 5bce <open>
    16c6:	84aa                	mv	s1,a0
    if(fd < 0){
    16c8:	04054763          	bltz	a0,1716 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16cc:	460d                	li	a2,3
    16ce:	85d6                	mv	a1,s5
    16d0:	00004097          	auipc	ra,0x4
    16d4:	4de080e7          	jalr	1246(ra) # 5bae <write>
    if(n != 3){
    16d8:	478d                	li	a5,3
    16da:	04f51c63          	bne	a0,a5,1732 <truncate3+0x1ac>
    close(fd);
    16de:	8526                	mv	a0,s1
    16e0:	00004097          	auipc	ra,0x4
    16e4:	4d6080e7          	jalr	1238(ra) # 5bb6 <close>
  for(int i = 0; i < 150; i++){
    16e8:	39fd                	addiw	s3,s3,-1
    16ea:	fc0997e3          	bnez	s3,16b8 <truncate3+0x132>
  wait(&xstatus);
    16ee:	fbc40513          	addi	a0,s0,-68
    16f2:	00004097          	auipc	ra,0x4
    16f6:	4a4080e7          	jalr	1188(ra) # 5b96 <wait>
  unlink("truncfile");
    16fa:	00005517          	auipc	a0,0x5
    16fe:	a7650513          	addi	a0,a0,-1418 # 6170 <malloc+0x19a>
    1702:	00004097          	auipc	ra,0x4
    1706:	4dc080e7          	jalr	1244(ra) # 5bde <unlink>
  exit(xstatus);
    170a:	fbc42503          	lw	a0,-68(s0)
    170e:	00004097          	auipc	ra,0x4
    1712:	480080e7          	jalr	1152(ra) # 5b8e <exit>
      printf("%s: open failed\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	2a050513          	addi	a0,a0,672 # 69b8 <malloc+0x9e2>
    1720:	00004097          	auipc	ra,0x4
    1724:	7fe080e7          	jalr	2046(ra) # 5f1e <printf>
      exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	464080e7          	jalr	1124(ra) # 5b8e <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1732:	862a                	mv	a2,a0
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	2d250513          	addi	a0,a0,722 # 6a08 <malloc+0xa32>
    173e:	00004097          	auipc	ra,0x4
    1742:	7e0080e7          	jalr	2016(ra) # 5f1e <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	446080e7          	jalr	1094(ra) # 5b8e <exit>

0000000000001750 <exectest>:
{
    1750:	715d                	addi	sp,sp,-80
    1752:	e486                	sd	ra,72(sp)
    1754:	e0a2                	sd	s0,64(sp)
    1756:	f84a                	sd	s2,48(sp)
    1758:	0880                	addi	s0,sp,80
    175a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175c:	00005797          	auipc	a5,0x5
    1760:	9bc78793          	addi	a5,a5,-1604 # 6118 <malloc+0x142>
    1764:	fcf43023          	sd	a5,-64(s0)
    1768:	00005797          	auipc	a5,0x5
    176c:	2c078793          	addi	a5,a5,704 # 6a28 <malloc+0xa52>
    1770:	fcf43423          	sd	a5,-56(s0)
    1774:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1778:	00005517          	auipc	a0,0x5
    177c:	2b850513          	addi	a0,a0,696 # 6a30 <malloc+0xa5a>
    1780:	00004097          	auipc	ra,0x4
    1784:	45e080e7          	jalr	1118(ra) # 5bde <unlink>
  pid = fork();
    1788:	00004097          	auipc	ra,0x4
    178c:	3fe080e7          	jalr	1022(ra) # 5b86 <fork>
  if(pid < 0) {
    1790:	04054763          	bltz	a0,17de <exectest+0x8e>
    1794:	fc26                	sd	s1,56(sp)
    1796:	84aa                	mv	s1,a0
  if(pid == 0) {
    1798:	ed41                	bnez	a0,1830 <exectest+0xe0>
    close(1);
    179a:	4505                	li	a0,1
    179c:	00004097          	auipc	ra,0x4
    17a0:	41a080e7          	jalr	1050(ra) # 5bb6 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a4:	20100593          	li	a1,513
    17a8:	00005517          	auipc	a0,0x5
    17ac:	28850513          	addi	a0,a0,648 # 6a30 <malloc+0xa5a>
    17b0:	00004097          	auipc	ra,0x4
    17b4:	41e080e7          	jalr	1054(ra) # 5bce <open>
    if(fd < 0) {
    17b8:	04054263          	bltz	a0,17fc <exectest+0xac>
    if(fd != 1) {
    17bc:	4785                	li	a5,1
    17be:	04f50d63          	beq	a0,a5,1818 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c2:	85ca                	mv	a1,s2
    17c4:	00005517          	auipc	a0,0x5
    17c8:	28c50513          	addi	a0,a0,652 # 6a50 <malloc+0xa7a>
    17cc:	00004097          	auipc	ra,0x4
    17d0:	752080e7          	jalr	1874(ra) # 5f1e <printf>
      exit(1);
    17d4:	4505                	li	a0,1
    17d6:	00004097          	auipc	ra,0x4
    17da:	3b8080e7          	jalr	952(ra) # 5b8e <exit>
    17de:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e0:	85ca                	mv	a1,s2
    17e2:	00005517          	auipc	a0,0x5
    17e6:	1be50513          	addi	a0,a0,446 # 69a0 <malloc+0x9ca>
    17ea:	00004097          	auipc	ra,0x4
    17ee:	734080e7          	jalr	1844(ra) # 5f1e <printf>
     exit(1);
    17f2:	4505                	li	a0,1
    17f4:	00004097          	auipc	ra,0x4
    17f8:	39a080e7          	jalr	922(ra) # 5b8e <exit>
      printf("%s: create failed\n", s);
    17fc:	85ca                	mv	a1,s2
    17fe:	00005517          	auipc	a0,0x5
    1802:	23a50513          	addi	a0,a0,570 # 6a38 <malloc+0xa62>
    1806:	00004097          	auipc	ra,0x4
    180a:	718080e7          	jalr	1816(ra) # 5f1e <printf>
      exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	37e080e7          	jalr	894(ra) # 5b8e <exit>
    if(exec("echo", echoargv) < 0){
    1818:	fc040593          	addi	a1,s0,-64
    181c:	00005517          	auipc	a0,0x5
    1820:	8fc50513          	addi	a0,a0,-1796 # 6118 <malloc+0x142>
    1824:	00004097          	auipc	ra,0x4
    1828:	3a2080e7          	jalr	930(ra) # 5bc6 <exec>
    182c:	02054163          	bltz	a0,184e <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1830:	fdc40513          	addi	a0,s0,-36
    1834:	00004097          	auipc	ra,0x4
    1838:	362080e7          	jalr	866(ra) # 5b96 <wait>
    183c:	02951763          	bne	a0,s1,186a <exectest+0x11a>
  if(xstatus != 0)
    1840:	fdc42503          	lw	a0,-36(s0)
    1844:	cd0d                	beqz	a0,187e <exectest+0x12e>
    exit(xstatus);
    1846:	00004097          	auipc	ra,0x4
    184a:	348080e7          	jalr	840(ra) # 5b8e <exit>
      printf("%s: exec echo failed\n", s);
    184e:	85ca                	mv	a1,s2
    1850:	00005517          	auipc	a0,0x5
    1854:	21050513          	addi	a0,a0,528 # 6a60 <malloc+0xa8a>
    1858:	00004097          	auipc	ra,0x4
    185c:	6c6080e7          	jalr	1734(ra) # 5f1e <printf>
      exit(1);
    1860:	4505                	li	a0,1
    1862:	00004097          	auipc	ra,0x4
    1866:	32c080e7          	jalr	812(ra) # 5b8e <exit>
    printf("%s: wait failed!\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00005517          	auipc	a0,0x5
    1870:	20c50513          	addi	a0,a0,524 # 6a78 <malloc+0xaa2>
    1874:	00004097          	auipc	ra,0x4
    1878:	6aa080e7          	jalr	1706(ra) # 5f1e <printf>
    187c:	b7d1                	j	1840 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    187e:	4581                	li	a1,0
    1880:	00005517          	auipc	a0,0x5
    1884:	1b050513          	addi	a0,a0,432 # 6a30 <malloc+0xa5a>
    1888:	00004097          	auipc	ra,0x4
    188c:	346080e7          	jalr	838(ra) # 5bce <open>
  if(fd < 0) {
    1890:	02054a63          	bltz	a0,18c4 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1894:	4609                	li	a2,2
    1896:	fb840593          	addi	a1,s0,-72
    189a:	00004097          	auipc	ra,0x4
    189e:	30c080e7          	jalr	780(ra) # 5ba6 <read>
    18a2:	4789                	li	a5,2
    18a4:	02f50e63          	beq	a0,a5,18e0 <exectest+0x190>
    printf("%s: read failed\n", s);
    18a8:	85ca                	mv	a1,s2
    18aa:	00005517          	auipc	a0,0x5
    18ae:	c3e50513          	addi	a0,a0,-962 # 64e8 <malloc+0x512>
    18b2:	00004097          	auipc	ra,0x4
    18b6:	66c080e7          	jalr	1644(ra) # 5f1e <printf>
    exit(1);
    18ba:	4505                	li	a0,1
    18bc:	00004097          	auipc	ra,0x4
    18c0:	2d2080e7          	jalr	722(ra) # 5b8e <exit>
    printf("%s: open failed\n", s);
    18c4:	85ca                	mv	a1,s2
    18c6:	00005517          	auipc	a0,0x5
    18ca:	0f250513          	addi	a0,a0,242 # 69b8 <malloc+0x9e2>
    18ce:	00004097          	auipc	ra,0x4
    18d2:	650080e7          	jalr	1616(ra) # 5f1e <printf>
    exit(1);
    18d6:	4505                	li	a0,1
    18d8:	00004097          	auipc	ra,0x4
    18dc:	2b6080e7          	jalr	694(ra) # 5b8e <exit>
  unlink("echo-ok");
    18e0:	00005517          	auipc	a0,0x5
    18e4:	15050513          	addi	a0,a0,336 # 6a30 <malloc+0xa5a>
    18e8:	00004097          	auipc	ra,0x4
    18ec:	2f6080e7          	jalr	758(ra) # 5bde <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f0:	fb844703          	lbu	a4,-72(s0)
    18f4:	04f00793          	li	a5,79
    18f8:	00f71863          	bne	a4,a5,1908 <exectest+0x1b8>
    18fc:	fb944703          	lbu	a4,-71(s0)
    1900:	04b00793          	li	a5,75
    1904:	02f70063          	beq	a4,a5,1924 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00005517          	auipc	a0,0x5
    190e:	18650513          	addi	a0,a0,390 # 6a90 <malloc+0xaba>
    1912:	00004097          	auipc	ra,0x4
    1916:	60c080e7          	jalr	1548(ra) # 5f1e <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00004097          	auipc	ra,0x4
    1920:	272080e7          	jalr	626(ra) # 5b8e <exit>
    exit(0);
    1924:	4501                	li	a0,0
    1926:	00004097          	auipc	ra,0x4
    192a:	268080e7          	jalr	616(ra) # 5b8e <exit>

000000000000192e <pipe1>:
{
    192e:	711d                	addi	sp,sp,-96
    1930:	ec86                	sd	ra,88(sp)
    1932:	e8a2                	sd	s0,80(sp)
    1934:	fc4e                	sd	s3,56(sp)
    1936:	1080                	addi	s0,sp,96
    1938:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193a:	fa840513          	addi	a0,s0,-88
    193e:	00004097          	auipc	ra,0x4
    1942:	260080e7          	jalr	608(ra) # 5b9e <pipe>
    1946:	ed3d                	bnez	a0,19c4 <pipe1+0x96>
    1948:	e4a6                	sd	s1,72(sp)
    194a:	f852                	sd	s4,48(sp)
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	238080e7          	jalr	568(ra) # 5b86 <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c951                	beqz	a0,19ec <pipe1+0xbe>
  } else if(pid > 0){
    195a:	18a05b63          	blez	a0,1af0 <pipe1+0x1c2>
    195e:	e0ca                	sd	s2,64(sp)
    1960:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1962:	fac42503          	lw	a0,-84(s0)
    1966:	00004097          	auipc	ra,0x4
    196a:	250080e7          	jalr	592(ra) # 5bb6 <close>
    total = 0;
    196e:	8a26                	mv	s4,s1
    cc = 1;
    1970:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1972:	0000ca97          	auipc	s5,0xc
    1976:	656a8a93          	addi	s5,s5,1622 # dfc8 <buf>
    197a:	864a                	mv	a2,s2
    197c:	85d6                	mv	a1,s5
    197e:	fa842503          	lw	a0,-88(s0)
    1982:	00004097          	auipc	ra,0x4
    1986:	224080e7          	jalr	548(ra) # 5ba6 <read>
    198a:	10a05a63          	blez	a0,1a9e <pipe1+0x170>
      for(i = 0; i < n; i++){
    198e:	0000c717          	auipc	a4,0xc
    1992:	63a70713          	addi	a4,a4,1594 # dfc8 <buf>
    1996:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199a:	00074683          	lbu	a3,0(a4)
    199e:	0ff4f793          	zext.b	a5,s1
    19a2:	2485                	addiw	s1,s1,1
    19a4:	0cf69b63          	bne	a3,a5,1a7a <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19a8:	0705                	addi	a4,a4,1
    19aa:	fec498e3          	bne	s1,a2,199a <pipe1+0x6c>
      total += n;
    19ae:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b2:	0019179b          	slliw	a5,s2,0x1
    19b6:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19ba:	670d                	lui	a4,0x3
    19bc:	fb277fe3          	bgeu	a4,s2,197a <pipe1+0x4c>
        cc = sizeof(buf);
    19c0:	690d                	lui	s2,0x3
    19c2:	bf65                	j	197a <pipe1+0x4c>
    19c4:	e4a6                	sd	s1,72(sp)
    19c6:	e0ca                	sd	s2,64(sp)
    19c8:	f852                	sd	s4,48(sp)
    19ca:	f456                	sd	s5,40(sp)
    19cc:	f05a                	sd	s6,32(sp)
    19ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d0:	85ce                	mv	a1,s3
    19d2:	00005517          	auipc	a0,0x5
    19d6:	0d650513          	addi	a0,a0,214 # 6aa8 <malloc+0xad2>
    19da:	00004097          	auipc	ra,0x4
    19de:	544080e7          	jalr	1348(ra) # 5f1e <printf>
    exit(1);
    19e2:	4505                	li	a0,1
    19e4:	00004097          	auipc	ra,0x4
    19e8:	1aa080e7          	jalr	426(ra) # 5b8e <exit>
    19ec:	e0ca                	sd	s2,64(sp)
    19ee:	f456                	sd	s5,40(sp)
    19f0:	f05a                	sd	s6,32(sp)
    19f2:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f4:	fa842503          	lw	a0,-88(s0)
    19f8:	00004097          	auipc	ra,0x4
    19fc:	1be080e7          	jalr	446(ra) # 5bb6 <close>
    for(n = 0; n < N; n++){
    1a00:	0000cb17          	auipc	s6,0xc
    1a04:	5c8b0b13          	addi	s6,s6,1480 # dfc8 <buf>
    1a08:	416004bb          	negw	s1,s6
    1a0c:	0ff4f493          	zext.b	s1,s1
    1a10:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a14:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a16:	6a85                	lui	s5,0x1
    1a18:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    1a1c:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a1e:	0097873b          	addw	a4,a5,s1
    1a22:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a26:	0785                	addi	a5,a5,1
    1a28:	ff279be3          	bne	a5,s2,1a1e <pipe1+0xf0>
    1a2c:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a30:	40900613          	li	a2,1033
    1a34:	85de                	mv	a1,s7
    1a36:	fac42503          	lw	a0,-84(s0)
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	174080e7          	jalr	372(ra) # 5bae <write>
    1a42:	40900793          	li	a5,1033
    1a46:	00f51c63          	bne	a0,a5,1a5e <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4a:	24a5                	addiw	s1,s1,9
    1a4c:	0ff4f493          	zext.b	s1,s1
    1a50:	fd5a16e3          	bne	s4,s5,1a1c <pipe1+0xee>
    exit(0);
    1a54:	4501                	li	a0,0
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	138080e7          	jalr	312(ra) # 5b8e <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a5e:	85ce                	mv	a1,s3
    1a60:	00005517          	auipc	a0,0x5
    1a64:	06050513          	addi	a0,a0,96 # 6ac0 <malloc+0xaea>
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	4b6080e7          	jalr	1206(ra) # 5f1e <printf>
        exit(1);
    1a70:	4505                	li	a0,1
    1a72:	00004097          	auipc	ra,0x4
    1a76:	11c080e7          	jalr	284(ra) # 5b8e <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	05c50513          	addi	a0,a0,92 # 6ad8 <malloc+0xb02>
    1a84:	00004097          	auipc	ra,0x4
    1a88:	49a080e7          	jalr	1178(ra) # 5f1e <printf>
          return;
    1a8c:	64a6                	ld	s1,72(sp)
    1a8e:	6906                	ld	s2,64(sp)
    1a90:	7a42                	ld	s4,48(sp)
    1a92:	7aa2                	ld	s5,40(sp)
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	79e2                	ld	s3,56(sp)
    1a9a:	6125                	addi	sp,sp,96
    1a9c:	8082                	ret
    if(total != N * SZ){
    1a9e:	6785                	lui	a5,0x1
    1aa0:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1aa4:	02fa0263          	beq	s4,a5,1ac8 <pipe1+0x19a>
    1aa8:	f05a                	sd	s6,32(sp)
    1aaa:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aac:	85d2                	mv	a1,s4
    1aae:	00005517          	auipc	a0,0x5
    1ab2:	04250513          	addi	a0,a0,66 # 6af0 <malloc+0xb1a>
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	468080e7          	jalr	1128(ra) # 5f1e <printf>
      exit(1);
    1abe:	4505                	li	a0,1
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	0ce080e7          	jalr	206(ra) # 5b8e <exit>
    1ac8:	f05a                	sd	s6,32(sp)
    1aca:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1acc:	fa842503          	lw	a0,-88(s0)
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	0e6080e7          	jalr	230(ra) # 5bb6 <close>
    wait(&xstatus);
    1ad8:	fa440513          	addi	a0,s0,-92
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	0ba080e7          	jalr	186(ra) # 5b96 <wait>
    exit(xstatus);
    1ae4:	fa442503          	lw	a0,-92(s0)
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	0a6080e7          	jalr	166(ra) # 5b8e <exit>
    1af0:	e0ca                	sd	s2,64(sp)
    1af2:	f456                	sd	s5,40(sp)
    1af4:	f05a                	sd	s6,32(sp)
    1af6:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1af8:	85ce                	mv	a1,s3
    1afa:	00005517          	auipc	a0,0x5
    1afe:	01650513          	addi	a0,a0,22 # 6b10 <malloc+0xb3a>
    1b02:	00004097          	auipc	ra,0x4
    1b06:	41c080e7          	jalr	1052(ra) # 5f1e <printf>
    exit(1);
    1b0a:	4505                	li	a0,1
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	082080e7          	jalr	130(ra) # 5b8e <exit>

0000000000001b14 <exitwait>:
{
    1b14:	7139                	addi	sp,sp,-64
    1b16:	fc06                	sd	ra,56(sp)
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f426                	sd	s1,40(sp)
    1b1c:	f04a                	sd	s2,32(sp)
    1b1e:	ec4e                	sd	s3,24(sp)
    1b20:	e852                	sd	s4,16(sp)
    1b22:	0080                	addi	s0,sp,64
    1b24:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b26:	4901                	li	s2,0
    1b28:	06400993          	li	s3,100
    pid = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	05a080e7          	jalr	90(ra) # 5b86 <fork>
    1b34:	84aa                	mv	s1,a0
    if(pid < 0){
    1b36:	02054a63          	bltz	a0,1b6a <exitwait+0x56>
    if(pid){
    1b3a:	c151                	beqz	a0,1bbe <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3c:	fcc40513          	addi	a0,s0,-52
    1b40:	00004097          	auipc	ra,0x4
    1b44:	056080e7          	jalr	86(ra) # 5b96 <wait>
    1b48:	02951f63          	bne	a0,s1,1b86 <exitwait+0x72>
      if(i != xstate) {
    1b4c:	fcc42783          	lw	a5,-52(s0)
    1b50:	05279963          	bne	a5,s2,1ba2 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b54:	2905                	addiw	s2,s2,1 # 3001 <execout+0xc1>
    1b56:	fd391be3          	bne	s2,s3,1b2c <exitwait+0x18>
}
    1b5a:	70e2                	ld	ra,56(sp)
    1b5c:	7442                	ld	s0,48(sp)
    1b5e:	74a2                	ld	s1,40(sp)
    1b60:	7902                	ld	s2,32(sp)
    1b62:	69e2                	ld	s3,24(sp)
    1b64:	6a42                	ld	s4,16(sp)
    1b66:	6121                	addi	sp,sp,64
    1b68:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6a:	85d2                	mv	a1,s4
    1b6c:	00005517          	auipc	a0,0x5
    1b70:	e3450513          	addi	a0,a0,-460 # 69a0 <malloc+0x9ca>
    1b74:	00004097          	auipc	ra,0x4
    1b78:	3aa080e7          	jalr	938(ra) # 5f1e <printf>
      exit(1);
    1b7c:	4505                	li	a0,1
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	010080e7          	jalr	16(ra) # 5b8e <exit>
        printf("%s: wait wrong pid\n", s);
    1b86:	85d2                	mv	a1,s4
    1b88:	00005517          	auipc	a0,0x5
    1b8c:	fa050513          	addi	a0,a0,-96 # 6b28 <malloc+0xb52>
    1b90:	00004097          	auipc	ra,0x4
    1b94:	38e080e7          	jalr	910(ra) # 5f1e <printf>
        exit(1);
    1b98:	4505                	li	a0,1
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	ff4080e7          	jalr	-12(ra) # 5b8e <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba2:	85d2                	mv	a1,s4
    1ba4:	00005517          	auipc	a0,0x5
    1ba8:	f9c50513          	addi	a0,a0,-100 # 6b40 <malloc+0xb6a>
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	372080e7          	jalr	882(ra) # 5f1e <printf>
        exit(1);
    1bb4:	4505                	li	a0,1
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	fd8080e7          	jalr	-40(ra) # 5b8e <exit>
      exit(i);
    1bbe:	854a                	mv	a0,s2
    1bc0:	00004097          	auipc	ra,0x4
    1bc4:	fce080e7          	jalr	-50(ra) # 5b8e <exit>

0000000000001bc8 <twochildren>:
{
    1bc8:	1101                	addi	sp,sp,-32
    1bca:	ec06                	sd	ra,24(sp)
    1bcc:	e822                	sd	s0,16(sp)
    1bce:	e426                	sd	s1,8(sp)
    1bd0:	e04a                	sd	s2,0(sp)
    1bd2:	1000                	addi	s0,sp,32
    1bd4:	892a                	mv	s2,a0
    1bd6:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bda:	00004097          	auipc	ra,0x4
    1bde:	fac080e7          	jalr	-84(ra) # 5b86 <fork>
    if(pid1 < 0){
    1be2:	02054c63          	bltz	a0,1c1a <twochildren+0x52>
    if(pid1 == 0){
    1be6:	c921                	beqz	a0,1c36 <twochildren+0x6e>
      int pid2 = fork();
    1be8:	00004097          	auipc	ra,0x4
    1bec:	f9e080e7          	jalr	-98(ra) # 5b86 <fork>
      if(pid2 < 0){
    1bf0:	04054763          	bltz	a0,1c3e <twochildren+0x76>
      if(pid2 == 0){
    1bf4:	c13d                	beqz	a0,1c5a <twochildren+0x92>
        wait(0);
    1bf6:	4501                	li	a0,0
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	f9e080e7          	jalr	-98(ra) # 5b96 <wait>
        wait(0);
    1c00:	4501                	li	a0,0
    1c02:	00004097          	auipc	ra,0x4
    1c06:	f94080e7          	jalr	-108(ra) # 5b96 <wait>
  for(int i = 0; i < 1000; i++){
    1c0a:	34fd                	addiw	s1,s1,-1
    1c0c:	f4f9                	bnez	s1,1bda <twochildren+0x12>
}
    1c0e:	60e2                	ld	ra,24(sp)
    1c10:	6442                	ld	s0,16(sp)
    1c12:	64a2                	ld	s1,8(sp)
    1c14:	6902                	ld	s2,0(sp)
    1c16:	6105                	addi	sp,sp,32
    1c18:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1a:	85ca                	mv	a1,s2
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	d8450513          	addi	a0,a0,-636 # 69a0 <malloc+0x9ca>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	2fa080e7          	jalr	762(ra) # 5f1e <printf>
      exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	f60080e7          	jalr	-160(ra) # 5b8e <exit>
      exit(0);
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	f58080e7          	jalr	-168(ra) # 5b8e <exit>
        printf("%s: fork failed\n", s);
    1c3e:	85ca                	mv	a1,s2
    1c40:	00005517          	auipc	a0,0x5
    1c44:	d6050513          	addi	a0,a0,-672 # 69a0 <malloc+0x9ca>
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	2d6080e7          	jalr	726(ra) # 5f1e <printf>
        exit(1);
    1c50:	4505                	li	a0,1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	f3c080e7          	jalr	-196(ra) # 5b8e <exit>
        exit(0);
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	f34080e7          	jalr	-204(ra) # 5b8e <exit>

0000000000001c62 <forkfork>:
{
    1c62:	7179                	addi	sp,sp,-48
    1c64:	f406                	sd	ra,40(sp)
    1c66:	f022                	sd	s0,32(sp)
    1c68:	ec26                	sd	s1,24(sp)
    1c6a:	1800                	addi	s0,sp,48
    1c6c:	84aa                	mv	s1,a0
    int pid = fork();
    1c6e:	00004097          	auipc	ra,0x4
    1c72:	f18080e7          	jalr	-232(ra) # 5b86 <fork>
    if(pid < 0){
    1c76:	04054163          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c7a:	cd29                	beqz	a0,1cd4 <forkfork+0x72>
    int pid = fork();
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	f0a080e7          	jalr	-246(ra) # 5b86 <fork>
    if(pid < 0){
    1c84:	02054a63          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c88:	c531                	beqz	a0,1cd4 <forkfork+0x72>
    wait(&xstatus);
    1c8a:	fdc40513          	addi	a0,s0,-36
    1c8e:	00004097          	auipc	ra,0x4
    1c92:	f08080e7          	jalr	-248(ra) # 5b96 <wait>
    if(xstatus != 0) {
    1c96:	fdc42783          	lw	a5,-36(s0)
    1c9a:	ebbd                	bnez	a5,1d10 <forkfork+0xae>
    wait(&xstatus);
    1c9c:	fdc40513          	addi	a0,s0,-36
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	ef6080e7          	jalr	-266(ra) # 5b96 <wait>
    if(xstatus != 0) {
    1ca8:	fdc42783          	lw	a5,-36(s0)
    1cac:	e3b5                	bnez	a5,1d10 <forkfork+0xae>
}
    1cae:	70a2                	ld	ra,40(sp)
    1cb0:	7402                	ld	s0,32(sp)
    1cb2:	64e2                	ld	s1,24(sp)
    1cb4:	6145                	addi	sp,sp,48
    1cb6:	8082                	ret
      printf("%s: fork failed", s);
    1cb8:	85a6                	mv	a1,s1
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	ea650513          	addi	a0,a0,-346 # 6b60 <malloc+0xb8a>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	25c080e7          	jalr	604(ra) # 5f1e <printf>
      exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	ec2080e7          	jalr	-318(ra) # 5b8e <exit>
{
    1cd4:	0c800493          	li	s1,200
        int pid1 = fork();
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	eae080e7          	jalr	-338(ra) # 5b86 <fork>
        if(pid1 < 0){
    1ce0:	00054f63          	bltz	a0,1cfe <forkfork+0x9c>
        if(pid1 == 0){
    1ce4:	c115                	beqz	a0,1d08 <forkfork+0xa6>
        wait(0);
    1ce6:	4501                	li	a0,0
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	eae080e7          	jalr	-338(ra) # 5b96 <wait>
      for(int j = 0; j < 200; j++){
    1cf0:	34fd                	addiw	s1,s1,-1
    1cf2:	f0fd                	bnez	s1,1cd8 <forkfork+0x76>
      exit(0);
    1cf4:	4501                	li	a0,0
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	e98080e7          	jalr	-360(ra) # 5b8e <exit>
          exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00004097          	auipc	ra,0x4
    1d04:	e8e080e7          	jalr	-370(ra) # 5b8e <exit>
          exit(0);
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	e86080e7          	jalr	-378(ra) # 5b8e <exit>
      printf("%s: fork in child failed", s);
    1d10:	85a6                	mv	a1,s1
    1d12:	00005517          	auipc	a0,0x5
    1d16:	e5e50513          	addi	a0,a0,-418 # 6b70 <malloc+0xb9a>
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	204080e7          	jalr	516(ra) # 5f1e <printf>
      exit(1);
    1d22:	4505                	li	a0,1
    1d24:	00004097          	auipc	ra,0x4
    1d28:	e6a080e7          	jalr	-406(ra) # 5b8e <exit>

0000000000001d2c <reparent2>:
{
    1d2c:	1101                	addi	sp,sp,-32
    1d2e:	ec06                	sd	ra,24(sp)
    1d30:	e822                	sd	s0,16(sp)
    1d32:	e426                	sd	s1,8(sp)
    1d34:	1000                	addi	s0,sp,32
    1d36:	32000493          	li	s1,800
    int pid1 = fork();
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	e4c080e7          	jalr	-436(ra) # 5b86 <fork>
    if(pid1 < 0){
    1d42:	00054f63          	bltz	a0,1d60 <reparent2+0x34>
    if(pid1 == 0){
    1d46:	c915                	beqz	a0,1d7a <reparent2+0x4e>
    wait(0);
    1d48:	4501                	li	a0,0
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	e4c080e7          	jalr	-436(ra) # 5b96 <wait>
  for(int i = 0; i < 800; i++){
    1d52:	34fd                	addiw	s1,s1,-1
    1d54:	f0fd                	bnez	s1,1d3a <reparent2+0xe>
  exit(0);
    1d56:	4501                	li	a0,0
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e36080e7          	jalr	-458(ra) # 5b8e <exit>
      printf("fork failed\n");
    1d60:	00005517          	auipc	a0,0x5
    1d64:	04850513          	addi	a0,a0,72 # 6da8 <malloc+0xdd2>
    1d68:	00004097          	auipc	ra,0x4
    1d6c:	1b6080e7          	jalr	438(ra) # 5f1e <printf>
      exit(1);
    1d70:	4505                	li	a0,1
    1d72:	00004097          	auipc	ra,0x4
    1d76:	e1c080e7          	jalr	-484(ra) # 5b8e <exit>
      fork();
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	e0c080e7          	jalr	-500(ra) # 5b86 <fork>
      fork();
    1d82:	00004097          	auipc	ra,0x4
    1d86:	e04080e7          	jalr	-508(ra) # 5b86 <fork>
      exit(0);
    1d8a:	4501                	li	a0,0
    1d8c:	00004097          	auipc	ra,0x4
    1d90:	e02080e7          	jalr	-510(ra) # 5b8e <exit>

0000000000001d94 <createdelete>:
{
    1d94:	7175                	addi	sp,sp,-144
    1d96:	e506                	sd	ra,136(sp)
    1d98:	e122                	sd	s0,128(sp)
    1d9a:	fca6                	sd	s1,120(sp)
    1d9c:	f8ca                	sd	s2,112(sp)
    1d9e:	f4ce                	sd	s3,104(sp)
    1da0:	f0d2                	sd	s4,96(sp)
    1da2:	ecd6                	sd	s5,88(sp)
    1da4:	e8da                	sd	s6,80(sp)
    1da6:	e4de                	sd	s7,72(sp)
    1da8:	e0e2                	sd	s8,64(sp)
    1daa:	fc66                	sd	s9,56(sp)
    1dac:	0900                	addi	s0,sp,144
    1dae:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    pid = fork();
    1db4:	00004097          	auipc	ra,0x4
    1db8:	dd2080e7          	jalr	-558(ra) # 5b86 <fork>
    1dbc:	84aa                	mv	s1,a0
    if(pid < 0){
    1dbe:	02054f63          	bltz	a0,1dfc <createdelete+0x68>
    if(pid == 0){
    1dc2:	c939                	beqz	a0,1e18 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc4:	2905                	addiw	s2,s2,1
    1dc6:	ff3917e3          	bne	s2,s3,1db4 <createdelete+0x20>
    1dca:	4491                	li	s1,4
    wait(&xstatus);
    1dcc:	f7c40513          	addi	a0,s0,-132
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	dc6080e7          	jalr	-570(ra) # 5b96 <wait>
    if(xstatus != 0)
    1dd8:	f7c42903          	lw	s2,-132(s0)
    1ddc:	0e091263          	bnez	s2,1ec0 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de0:	34fd                	addiw	s1,s1,-1
    1de2:	f4ed                	bnez	s1,1dcc <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de4:	f8040123          	sb	zero,-126(s0)
    1de8:	03000993          	li	s3,48
    1dec:	5a7d                	li	s4,-1
    1dee:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df2:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df6:	07400a93          	li	s5,116
    1dfa:	a28d                	j	1f5c <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	faa50513          	addi	a0,a0,-86 # 6da8 <malloc+0xdd2>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	118080e7          	jalr	280(ra) # 5f1e <printf>
      exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	d7e080e7          	jalr	-642(ra) # 5b8e <exit>
      name[0] = 'p' + pi;
    1e18:	0709091b          	addiw	s2,s2,112
    1e1c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e20:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e24:	4951                	li	s2,20
    1e26:	a015                	j	1e4a <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e28:	85e6                	mv	a1,s9
    1e2a:	00005517          	auipc	a0,0x5
    1e2e:	c0e50513          	addi	a0,a0,-1010 # 6a38 <malloc+0xa62>
    1e32:	00004097          	auipc	ra,0x4
    1e36:	0ec080e7          	jalr	236(ra) # 5f1e <printf>
          exit(1);
    1e3a:	4505                	li	a0,1
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	d52080e7          	jalr	-686(ra) # 5b8e <exit>
      for(i = 0; i < N; i++){
    1e44:	2485                	addiw	s1,s1,1
    1e46:	07248863          	beq	s1,s2,1eb6 <createdelete+0x122>
        name[1] = '0' + i;
    1e4a:	0304879b          	addiw	a5,s1,48
    1e4e:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	f8040513          	addi	a0,s0,-128
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	d74080e7          	jalr	-652(ra) # 5bce <open>
        if(fd < 0){
    1e62:	fc0543e3          	bltz	a0,1e28 <createdelete+0x94>
        close(fd);
    1e66:	00004097          	auipc	ra,0x4
    1e6a:	d50080e7          	jalr	-688(ra) # 5bb6 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e6e:	12905763          	blez	s1,1f9c <createdelete+0x208>
    1e72:	0014f793          	andi	a5,s1,1
    1e76:	f7f9                	bnez	a5,1e44 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e78:	01f4d79b          	srliw	a5,s1,0x1f
    1e7c:	9fa5                	addw	a5,a5,s1
    1e7e:	4017d79b          	sraiw	a5,a5,0x1
    1e82:	0307879b          	addiw	a5,a5,48
    1e86:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8a:	f8040513          	addi	a0,s0,-128
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	d50080e7          	jalr	-688(ra) # 5bde <unlink>
    1e96:	fa0557e3          	bgez	a0,1e44 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9a:	85e6                	mv	a1,s9
    1e9c:	00005517          	auipc	a0,0x5
    1ea0:	cf450513          	addi	a0,a0,-780 # 6b90 <malloc+0xbba>
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	07a080e7          	jalr	122(ra) # 5f1e <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	ce0080e7          	jalr	-800(ra) # 5b8e <exit>
      exit(0);
    1eb6:	4501                	li	a0,0
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	cd6080e7          	jalr	-810(ra) # 5b8e <exit>
      exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	ccc080e7          	jalr	-820(ra) # 5b8e <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eca:	f8040613          	addi	a2,s0,-128
    1ece:	85e6                	mv	a1,s9
    1ed0:	00005517          	auipc	a0,0x5
    1ed4:	cd850513          	addi	a0,a0,-808 # 6ba8 <malloc+0xbd2>
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	046080e7          	jalr	70(ra) # 5f1e <printf>
        exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	cac080e7          	jalr	-852(ra) # 5b8e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eea:	034bff63          	bgeu	s7,s4,1f28 <createdelete+0x194>
      if(fd >= 0)
    1eee:	02055863          	bgez	a0,1f1e <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef2:	2485                	addiw	s1,s1,1
    1ef4:	0ff4f493          	zext.b	s1,s1
    1ef8:	05548a63          	beq	s1,s5,1f4c <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f00:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f04:	4581                	li	a1,0
    1f06:	f8040513          	addi	a0,s0,-128
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	cc4080e7          	jalr	-828(ra) # 5bce <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f12:	00090463          	beqz	s2,1f1a <createdelete+0x186>
    1f16:	fd2b5ae3          	bge	s6,s2,1eea <createdelete+0x156>
    1f1a:	fa0548e3          	bltz	a0,1eca <createdelete+0x136>
        close(fd);
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	c98080e7          	jalr	-872(ra) # 5bb6 <close>
    1f26:	b7f1                	j	1ef2 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f28:	fc0545e3          	bltz	a0,1ef2 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2c:	f8040613          	addi	a2,s0,-128
    1f30:	85e6                	mv	a1,s9
    1f32:	00005517          	auipc	a0,0x5
    1f36:	c9e50513          	addi	a0,a0,-866 # 6bd0 <malloc+0xbfa>
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	fe4080e7          	jalr	-28(ra) # 5f1e <printf>
        exit(1);
    1f42:	4505                	li	a0,1
    1f44:	00004097          	auipc	ra,0x4
    1f48:	c4a080e7          	jalr	-950(ra) # 5b8e <exit>
  for(i = 0; i < N; i++){
    1f4c:	2905                	addiw	s2,s2,1
    1f4e:	2a05                	addiw	s4,s4,1
    1f50:	2985                	addiw	s3,s3,1
    1f52:	0ff9f993          	zext.b	s3,s3
    1f56:	47d1                	li	a5,20
    1f58:	02f90a63          	beq	s2,a5,1f8c <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5c:	84e2                	mv	s1,s8
    1f5e:	bf79                	j	1efc <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f60:	2905                	addiw	s2,s2,1
    1f62:	0ff97913          	zext.b	s2,s2
    1f66:	2985                	addiw	s3,s3,1
    1f68:	0ff9f993          	zext.b	s3,s3
    1f6c:	03490a63          	beq	s2,s4,1fa0 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f70:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f72:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f76:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7a:	f8040513          	addi	a0,s0,-128
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	c60080e7          	jalr	-928(ra) # 5bde <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f86:	34fd                	addiw	s1,s1,-1
    1f88:	f4ed                	bnez	s1,1f72 <createdelete+0x1de>
    1f8a:	bfd9                	j	1f60 <createdelete+0x1cc>
    1f8c:	03000993          	li	s3,48
    1f90:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f94:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f96:	08400a13          	li	s4,132
    1f9a:	bfd9                	j	1f70 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9c:	2485                	addiw	s1,s1,1
    1f9e:	b575                	j	1e4a <createdelete+0xb6>
}
    1fa0:	60aa                	ld	ra,136(sp)
    1fa2:	640a                	ld	s0,128(sp)
    1fa4:	74e6                	ld	s1,120(sp)
    1fa6:	7946                	ld	s2,112(sp)
    1fa8:	79a6                	ld	s3,104(sp)
    1faa:	7a06                	ld	s4,96(sp)
    1fac:	6ae6                	ld	s5,88(sp)
    1fae:	6b46                	ld	s6,80(sp)
    1fb0:	6ba6                	ld	s7,72(sp)
    1fb2:	6c06                	ld	s8,64(sp)
    1fb4:	7ce2                	ld	s9,56(sp)
    1fb6:	6149                	addi	sp,sp,144
    1fb8:	8082                	ret

0000000000001fba <linkunlink>:
{
    1fba:	711d                	addi	sp,sp,-96
    1fbc:	ec86                	sd	ra,88(sp)
    1fbe:	e8a2                	sd	s0,80(sp)
    1fc0:	e4a6                	sd	s1,72(sp)
    1fc2:	e0ca                	sd	s2,64(sp)
    1fc4:	fc4e                	sd	s3,56(sp)
    1fc6:	f852                	sd	s4,48(sp)
    1fc8:	f456                	sd	s5,40(sp)
    1fca:	f05a                	sd	s6,32(sp)
    1fcc:	ec5e                	sd	s7,24(sp)
    1fce:	e862                	sd	s8,16(sp)
    1fd0:	e466                	sd	s9,8(sp)
    1fd2:	1080                	addi	s0,sp,96
    1fd4:	84aa                	mv	s1,a0
  unlink("x");
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	1b250513          	addi	a0,a0,434 # 6188 <malloc+0x1b2>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	c00080e7          	jalr	-1024(ra) # 5bde <unlink>
  pid = fork();
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	ba0080e7          	jalr	-1120(ra) # 5b86 <fork>
  if(pid < 0){
    1fee:	02054b63          	bltz	a0,2024 <linkunlink+0x6a>
    1ff2:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff4:	06100913          	li	s2,97
    1ff8:	c111                	beqz	a0,1ffc <linkunlink+0x42>
    1ffa:	4905                	li	s2,1
    1ffc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2000:	41c65a37          	lui	s4,0x41c65
    2004:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c53ea5>
    2008:	698d                	lui	s3,0x3
    200a:	0399899b          	addiw	s3,s3,57 # 3039 <fourteen+0x35>
    if((x % 3) == 0){
    200e:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2010:	4b85                	li	s7,1
      unlink("x");
    2012:	00004b17          	auipc	s6,0x4
    2016:	176b0b13          	addi	s6,s6,374 # 6188 <malloc+0x1b2>
      link("cat", "x");
    201a:	00005c17          	auipc	s8,0x5
    201e:	bdec0c13          	addi	s8,s8,-1058 # 6bf8 <malloc+0xc22>
    2022:	a825                	j	205a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	97a50513          	addi	a0,a0,-1670 # 69a0 <malloc+0x9ca>
    202e:	00004097          	auipc	ra,0x4
    2032:	ef0080e7          	jalr	-272(ra) # 5f1e <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00004097          	auipc	ra,0x4
    203c:	b56080e7          	jalr	-1194(ra) # 5b8e <exit>
      close(open("x", O_RDWR | O_CREATE));
    2040:	20200593          	li	a1,514
    2044:	855a                	mv	a0,s6
    2046:	00004097          	auipc	ra,0x4
    204a:	b88080e7          	jalr	-1144(ra) # 5bce <open>
    204e:	00004097          	auipc	ra,0x4
    2052:	b68080e7          	jalr	-1176(ra) # 5bb6 <close>
  for(i = 0; i < 100; i++){
    2056:	34fd                	addiw	s1,s1,-1
    2058:	c895                	beqz	s1,208c <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205a:	034907bb          	mulw	a5,s2,s4
    205e:	013787bb          	addw	a5,a5,s3
    2062:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2066:	0357f7bb          	remuw	a5,a5,s5
    206a:	2781                	sext.w	a5,a5
    206c:	dbf1                	beqz	a5,2040 <linkunlink+0x86>
    } else if((x % 3) == 1){
    206e:	01778863          	beq	a5,s7,207e <linkunlink+0xc4>
      unlink("x");
    2072:	855a                	mv	a0,s6
    2074:	00004097          	auipc	ra,0x4
    2078:	b6a080e7          	jalr	-1174(ra) # 5bde <unlink>
    207c:	bfe9                	j	2056 <linkunlink+0x9c>
      link("cat", "x");
    207e:	85da                	mv	a1,s6
    2080:	8562                	mv	a0,s8
    2082:	00004097          	auipc	ra,0x4
    2086:	b6c080e7          	jalr	-1172(ra) # 5bee <link>
    208a:	b7f1                	j	2056 <linkunlink+0x9c>
  if(pid)
    208c:	020c8463          	beqz	s9,20b4 <linkunlink+0xfa>
    wait(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	b04080e7          	jalr	-1276(ra) # 5b96 <wait>
}
    209a:	60e6                	ld	ra,88(sp)
    209c:	6446                	ld	s0,80(sp)
    209e:	64a6                	ld	s1,72(sp)
    20a0:	6906                	ld	s2,64(sp)
    20a2:	79e2                	ld	s3,56(sp)
    20a4:	7a42                	ld	s4,48(sp)
    20a6:	7aa2                	ld	s5,40(sp)
    20a8:	7b02                	ld	s6,32(sp)
    20aa:	6be2                	ld	s7,24(sp)
    20ac:	6c42                	ld	s8,16(sp)
    20ae:	6ca2                	ld	s9,8(sp)
    20b0:	6125                	addi	sp,sp,96
    20b2:	8082                	ret
    exit(0);
    20b4:	4501                	li	a0,0
    20b6:	00004097          	auipc	ra,0x4
    20ba:	ad8080e7          	jalr	-1320(ra) # 5b8e <exit>

00000000000020be <forktest>:
{
    20be:	7179                	addi	sp,sp,-48
    20c0:	f406                	sd	ra,40(sp)
    20c2:	f022                	sd	s0,32(sp)
    20c4:	ec26                	sd	s1,24(sp)
    20c6:	e84a                	sd	s2,16(sp)
    20c8:	e44e                	sd	s3,8(sp)
    20ca:	1800                	addi	s0,sp,48
    20cc:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20ce:	4481                	li	s1,0
    20d0:	3e800913          	li	s2,1000
    pid = fork();
    20d4:	00004097          	auipc	ra,0x4
    20d8:	ab2080e7          	jalr	-1358(ra) # 5b86 <fork>
    if(pid < 0)
    20dc:	08054263          	bltz	a0,2160 <forktest+0xa2>
    if(pid == 0)
    20e0:	c115                	beqz	a0,2104 <forktest+0x46>
  for(n=0; n<N; n++){
    20e2:	2485                	addiw	s1,s1,1
    20e4:	ff2498e3          	bne	s1,s2,20d4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20e8:	85ce                	mv	a1,s3
    20ea:	00005517          	auipc	a0,0x5
    20ee:	b5e50513          	addi	a0,a0,-1186 # 6c48 <malloc+0xc72>
    20f2:	00004097          	auipc	ra,0x4
    20f6:	e2c080e7          	jalr	-468(ra) # 5f1e <printf>
    exit(1);
    20fa:	4505                	li	a0,1
    20fc:	00004097          	auipc	ra,0x4
    2100:	a92080e7          	jalr	-1390(ra) # 5b8e <exit>
      exit(0);
    2104:	00004097          	auipc	ra,0x4
    2108:	a8a080e7          	jalr	-1398(ra) # 5b8e <exit>
    printf("%s: no fork at all!\n", s);
    210c:	85ce                	mv	a1,s3
    210e:	00005517          	auipc	a0,0x5
    2112:	af250513          	addi	a0,a0,-1294 # 6c00 <malloc+0xc2a>
    2116:	00004097          	auipc	ra,0x4
    211a:	e08080e7          	jalr	-504(ra) # 5f1e <printf>
    exit(1);
    211e:	4505                	li	a0,1
    2120:	00004097          	auipc	ra,0x4
    2124:	a6e080e7          	jalr	-1426(ra) # 5b8e <exit>
      printf("%s: wait stopped early\n", s);
    2128:	85ce                	mv	a1,s3
    212a:	00005517          	auipc	a0,0x5
    212e:	aee50513          	addi	a0,a0,-1298 # 6c18 <malloc+0xc42>
    2132:	00004097          	auipc	ra,0x4
    2136:	dec080e7          	jalr	-532(ra) # 5f1e <printf>
      exit(1);
    213a:	4505                	li	a0,1
    213c:	00004097          	auipc	ra,0x4
    2140:	a52080e7          	jalr	-1454(ra) # 5b8e <exit>
    printf("%s: wait got too many\n", s);
    2144:	85ce                	mv	a1,s3
    2146:	00005517          	auipc	a0,0x5
    214a:	aea50513          	addi	a0,a0,-1302 # 6c30 <malloc+0xc5a>
    214e:	00004097          	auipc	ra,0x4
    2152:	dd0080e7          	jalr	-560(ra) # 5f1e <printf>
    exit(1);
    2156:	4505                	li	a0,1
    2158:	00004097          	auipc	ra,0x4
    215c:	a36080e7          	jalr	-1482(ra) # 5b8e <exit>
  if (n == 0) {
    2160:	d4d5                	beqz	s1,210c <forktest+0x4e>
  for(; n > 0; n--){
    2162:	00905b63          	blez	s1,2178 <forktest+0xba>
    if(wait(0) < 0){
    2166:	4501                	li	a0,0
    2168:	00004097          	auipc	ra,0x4
    216c:	a2e080e7          	jalr	-1490(ra) # 5b96 <wait>
    2170:	fa054ce3          	bltz	a0,2128 <forktest+0x6a>
  for(; n > 0; n--){
    2174:	34fd                	addiw	s1,s1,-1
    2176:	f8e5                	bnez	s1,2166 <forktest+0xa8>
  if(wait(0) != -1){
    2178:	4501                	li	a0,0
    217a:	00004097          	auipc	ra,0x4
    217e:	a1c080e7          	jalr	-1508(ra) # 5b96 <wait>
    2182:	57fd                	li	a5,-1
    2184:	fcf510e3          	bne	a0,a5,2144 <forktest+0x86>
}
    2188:	70a2                	ld	ra,40(sp)
    218a:	7402                	ld	s0,32(sp)
    218c:	64e2                	ld	s1,24(sp)
    218e:	6942                	ld	s2,16(sp)
    2190:	69a2                	ld	s3,8(sp)
    2192:	6145                	addi	sp,sp,48
    2194:	8082                	ret

0000000000002196 <kernmem>:
{
    2196:	715d                	addi	sp,sp,-80
    2198:	e486                	sd	ra,72(sp)
    219a:	e0a2                	sd	s0,64(sp)
    219c:	fc26                	sd	s1,56(sp)
    219e:	f84a                	sd	s2,48(sp)
    21a0:	f44e                	sd	s3,40(sp)
    21a2:	f052                	sd	s4,32(sp)
    21a4:	ec56                	sd	s5,24(sp)
    21a6:	0880                	addi	s0,sp,80
    21a8:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21aa:	4485                	li	s1,1
    21ac:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21ae:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b0:	69b1                	lui	s3,0xc
    21b2:	35098993          	addi	s3,s3,848 # c350 <uninit+0xa98>
    21b6:	1003d937          	lui	s2,0x1003d
    21ba:	090e                	slli	s2,s2,0x3
    21bc:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c4b8>
    pid = fork();
    21c0:	00004097          	auipc	ra,0x4
    21c4:	9c6080e7          	jalr	-1594(ra) # 5b86 <fork>
    if(pid < 0){
    21c8:	02054963          	bltz	a0,21fa <kernmem+0x64>
    if(pid == 0){
    21cc:	c529                	beqz	a0,2216 <kernmem+0x80>
    wait(&xstatus);
    21ce:	fbc40513          	addi	a0,s0,-68
    21d2:	00004097          	auipc	ra,0x4
    21d6:	9c4080e7          	jalr	-1596(ra) # 5b96 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21da:	fbc42783          	lw	a5,-68(s0)
    21de:	05479d63          	bne	a5,s4,2238 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e2:	94ce                	add	s1,s1,s3
    21e4:	fd249ee3          	bne	s1,s2,21c0 <kernmem+0x2a>
}
    21e8:	60a6                	ld	ra,72(sp)
    21ea:	6406                	ld	s0,64(sp)
    21ec:	74e2                	ld	s1,56(sp)
    21ee:	7942                	ld	s2,48(sp)
    21f0:	79a2                	ld	s3,40(sp)
    21f2:	7a02                	ld	s4,32(sp)
    21f4:	6ae2                	ld	s5,24(sp)
    21f6:	6161                	addi	sp,sp,80
    21f8:	8082                	ret
      printf("%s: fork failed\n", s);
    21fa:	85d6                	mv	a1,s5
    21fc:	00004517          	auipc	a0,0x4
    2200:	7a450513          	addi	a0,a0,1956 # 69a0 <malloc+0x9ca>
    2204:	00004097          	auipc	ra,0x4
    2208:	d1a080e7          	jalr	-742(ra) # 5f1e <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	980080e7          	jalr	-1664(ra) # 5b8e <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2216:	0004c683          	lbu	a3,0(s1)
    221a:	8626                	mv	a2,s1
    221c:	85d6                	mv	a1,s5
    221e:	00005517          	auipc	a0,0x5
    2222:	a5250513          	addi	a0,a0,-1454 # 6c70 <malloc+0xc9a>
    2226:	00004097          	auipc	ra,0x4
    222a:	cf8080e7          	jalr	-776(ra) # 5f1e <printf>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00004097          	auipc	ra,0x4
    2234:	95e080e7          	jalr	-1698(ra) # 5b8e <exit>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00004097          	auipc	ra,0x4
    223e:	954080e7          	jalr	-1708(ra) # 5b8e <exit>

0000000000002242 <MAXVAplus>:
{
    2242:	7179                	addi	sp,sp,-48
    2244:	f406                	sd	ra,40(sp)
    2246:	f022                	sd	s0,32(sp)
    2248:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    224a:	4785                	li	a5,1
    224c:	179a                	slli	a5,a5,0x26
    224e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2252:	fd843783          	ld	a5,-40(s0)
    2256:	c3a1                	beqz	a5,2296 <MAXVAplus+0x54>
    2258:	ec26                	sd	s1,24(sp)
    225a:	e84a                	sd	s2,16(sp)
    225c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    225e:	54fd                	li	s1,-1
    pid = fork();
    2260:	00004097          	auipc	ra,0x4
    2264:	926080e7          	jalr	-1754(ra) # 5b86 <fork>
    if(pid < 0){
    2268:	02054b63          	bltz	a0,229e <MAXVAplus+0x5c>
    if(pid == 0){
    226c:	c539                	beqz	a0,22ba <MAXVAplus+0x78>
    wait(&xstatus);
    226e:	fd440513          	addi	a0,s0,-44
    2272:	00004097          	auipc	ra,0x4
    2276:	924080e7          	jalr	-1756(ra) # 5b96 <wait>
    if(xstatus != -1)  // did kernel kill child?
    227a:	fd442783          	lw	a5,-44(s0)
    227e:	06979463          	bne	a5,s1,22e6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2282:	fd843783          	ld	a5,-40(s0)
    2286:	0786                	slli	a5,a5,0x1
    2288:	fcf43c23          	sd	a5,-40(s0)
    228c:	fd843783          	ld	a5,-40(s0)
    2290:	fbe1                	bnez	a5,2260 <MAXVAplus+0x1e>
    2292:	64e2                	ld	s1,24(sp)
    2294:	6942                	ld	s2,16(sp)
}
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret
      printf("%s: fork failed\n", s);
    229e:	85ca                	mv	a1,s2
    22a0:	00004517          	auipc	a0,0x4
    22a4:	70050513          	addi	a0,a0,1792 # 69a0 <malloc+0x9ca>
    22a8:	00004097          	auipc	ra,0x4
    22ac:	c76080e7          	jalr	-906(ra) # 5f1e <printf>
      exit(1);
    22b0:	4505                	li	a0,1
    22b2:	00004097          	auipc	ra,0x4
    22b6:	8dc080e7          	jalr	-1828(ra) # 5b8e <exit>
      *(char*)a = 99;
    22ba:	fd843783          	ld	a5,-40(s0)
    22be:	06300713          	li	a4,99
    22c2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c6:	fd843603          	ld	a2,-40(s0)
    22ca:	85ca                	mv	a1,s2
    22cc:	00005517          	auipc	a0,0x5
    22d0:	9c450513          	addi	a0,a0,-1596 # 6c90 <malloc+0xcba>
    22d4:	00004097          	auipc	ra,0x4
    22d8:	c4a080e7          	jalr	-950(ra) # 5f1e <printf>
      exit(1);
    22dc:	4505                	li	a0,1
    22de:	00004097          	auipc	ra,0x4
    22e2:	8b0080e7          	jalr	-1872(ra) # 5b8e <exit>
      exit(1);
    22e6:	4505                	li	a0,1
    22e8:	00004097          	auipc	ra,0x4
    22ec:	8a6080e7          	jalr	-1882(ra) # 5b8e <exit>

00000000000022f0 <bigargtest>:
{
    22f0:	7179                	addi	sp,sp,-48
    22f2:	f406                	sd	ra,40(sp)
    22f4:	f022                	sd	s0,32(sp)
    22f6:	ec26                	sd	s1,24(sp)
    22f8:	1800                	addi	s0,sp,48
    22fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fc:	00005517          	auipc	a0,0x5
    2300:	9ac50513          	addi	a0,a0,-1620 # 6ca8 <malloc+0xcd2>
    2304:	00004097          	auipc	ra,0x4
    2308:	8da080e7          	jalr	-1830(ra) # 5bde <unlink>
  pid = fork();
    230c:	00004097          	auipc	ra,0x4
    2310:	87a080e7          	jalr	-1926(ra) # 5b86 <fork>
  if(pid == 0){
    2314:	c121                	beqz	a0,2354 <bigargtest+0x64>
  } else if(pid < 0){
    2316:	0a054063          	bltz	a0,23b6 <bigargtest+0xc6>
  wait(&xstatus);
    231a:	fdc40513          	addi	a0,s0,-36
    231e:	00004097          	auipc	ra,0x4
    2322:	878080e7          	jalr	-1928(ra) # 5b96 <wait>
  if(xstatus != 0)
    2326:	fdc42503          	lw	a0,-36(s0)
    232a:	e545                	bnez	a0,23d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232c:	4581                	li	a1,0
    232e:	00005517          	auipc	a0,0x5
    2332:	97a50513          	addi	a0,a0,-1670 # 6ca8 <malloc+0xcd2>
    2336:	00004097          	auipc	ra,0x4
    233a:	898080e7          	jalr	-1896(ra) # 5bce <open>
  if(fd < 0){
    233e:	08054e63          	bltz	a0,23da <bigargtest+0xea>
  close(fd);
    2342:	00004097          	auipc	ra,0x4
    2346:	874080e7          	jalr	-1932(ra) # 5bb6 <close>
}
    234a:	70a2                	ld	ra,40(sp)
    234c:	7402                	ld	s0,32(sp)
    234e:	64e2                	ld	s1,24(sp)
    2350:	6145                	addi	sp,sp,48
    2352:	8082                	ret
    2354:	00008797          	auipc	a5,0x8
    2358:	45c78793          	addi	a5,a5,1116 # a7b0 <args.1>
    235c:	00008697          	auipc	a3,0x8
    2360:	54c68693          	addi	a3,a3,1356 # a8a8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2364:	00005717          	auipc	a4,0x5
    2368:	95470713          	addi	a4,a4,-1708 # 6cb8 <malloc+0xce2>
    236c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    236e:	07a1                	addi	a5,a5,8
    2370:	fed79ee3          	bne	a5,a3,236c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2374:	00008597          	auipc	a1,0x8
    2378:	43c58593          	addi	a1,a1,1084 # a7b0 <args.1>
    237c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2380:	00004517          	auipc	a0,0x4
    2384:	d9850513          	addi	a0,a0,-616 # 6118 <malloc+0x142>
    2388:	00004097          	auipc	ra,0x4
    238c:	83e080e7          	jalr	-1986(ra) # 5bc6 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2390:	20000593          	li	a1,512
    2394:	00005517          	auipc	a0,0x5
    2398:	91450513          	addi	a0,a0,-1772 # 6ca8 <malloc+0xcd2>
    239c:	00004097          	auipc	ra,0x4
    23a0:	832080e7          	jalr	-1998(ra) # 5bce <open>
    close(fd);
    23a4:	00004097          	auipc	ra,0x4
    23a8:	812080e7          	jalr	-2030(ra) # 5bb6 <close>
    exit(0);
    23ac:	4501                	li	a0,0
    23ae:	00003097          	auipc	ra,0x3
    23b2:	7e0080e7          	jalr	2016(ra) # 5b8e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	9e050513          	addi	a0,a0,-1568 # 6d98 <malloc+0xdc2>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	b5e080e7          	jalr	-1186(ra) # 5f1e <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	7c4080e7          	jalr	1988(ra) # 5b8e <exit>
    exit(xstatus);
    23d2:	00003097          	auipc	ra,0x3
    23d6:	7bc080e7          	jalr	1980(ra) # 5b8e <exit>
    printf("%s: bigarg test failed!\n", s);
    23da:	85a6                	mv	a1,s1
    23dc:	00005517          	auipc	a0,0x5
    23e0:	9dc50513          	addi	a0,a0,-1572 # 6db8 <malloc+0xde2>
    23e4:	00004097          	auipc	ra,0x4
    23e8:	b3a080e7          	jalr	-1222(ra) # 5f1e <printf>
    exit(1);
    23ec:	4505                	li	a0,1
    23ee:	00003097          	auipc	ra,0x3
    23f2:	7a0080e7          	jalr	1952(ra) # 5b8e <exit>

00000000000023f6 <stacktest>:
{
    23f6:	7179                	addi	sp,sp,-48
    23f8:	f406                	sd	ra,40(sp)
    23fa:	f022                	sd	s0,32(sp)
    23fc:	ec26                	sd	s1,24(sp)
    23fe:	1800                	addi	s0,sp,48
    2400:	84aa                	mv	s1,a0
  pid = fork();
    2402:	00003097          	auipc	ra,0x3
    2406:	784080e7          	jalr	1924(ra) # 5b86 <fork>
  if(pid == 0) {
    240a:	c115                	beqz	a0,242e <stacktest+0x38>
  } else if(pid < 0){
    240c:	04054463          	bltz	a0,2454 <stacktest+0x5e>
  wait(&xstatus);
    2410:	fdc40513          	addi	a0,s0,-36
    2414:	00003097          	auipc	ra,0x3
    2418:	782080e7          	jalr	1922(ra) # 5b96 <wait>
  if(xstatus == -1)  // kernel killed child?
    241c:	fdc42503          	lw	a0,-36(s0)
    2420:	57fd                	li	a5,-1
    2422:	04f50763          	beq	a0,a5,2470 <stacktest+0x7a>
    exit(xstatus);
    2426:	00003097          	auipc	ra,0x3
    242a:	768080e7          	jalr	1896(ra) # 5b8e <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    242e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2430:	77fd                	lui	a5,0xfffff
    2432:	97ba                	add	a5,a5,a4
    2434:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee038>
    2438:	85a6                	mv	a1,s1
    243a:	00005517          	auipc	a0,0x5
    243e:	99e50513          	addi	a0,a0,-1634 # 6dd8 <malloc+0xe02>
    2442:	00004097          	auipc	ra,0x4
    2446:	adc080e7          	jalr	-1316(ra) # 5f1e <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	742080e7          	jalr	1858(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    2454:	85a6                	mv	a1,s1
    2456:	00004517          	auipc	a0,0x4
    245a:	54a50513          	addi	a0,a0,1354 # 69a0 <malloc+0x9ca>
    245e:	00004097          	auipc	ra,0x4
    2462:	ac0080e7          	jalr	-1344(ra) # 5f1e <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	00003097          	auipc	ra,0x3
    246c:	726080e7          	jalr	1830(ra) # 5b8e <exit>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	71c080e7          	jalr	1820(ra) # 5b8e <exit>

000000000000247a <manywrites>:
{
    247a:	711d                	addi	sp,sp,-96
    247c:	ec86                	sd	ra,88(sp)
    247e:	e8a2                	sd	s0,80(sp)
    2480:	e4a6                	sd	s1,72(sp)
    2482:	e0ca                	sd	s2,64(sp)
    2484:	fc4e                	sd	s3,56(sp)
    2486:	f456                	sd	s5,40(sp)
    2488:	1080                	addi	s0,sp,96
    248a:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    248c:	4981                	li	s3,0
    248e:	4911                	li	s2,4
    int pid = fork();
    2490:	00003097          	auipc	ra,0x3
    2494:	6f6080e7          	jalr	1782(ra) # 5b86 <fork>
    2498:	84aa                	mv	s1,a0
    if(pid < 0){
    249a:	02054d63          	bltz	a0,24d4 <manywrites+0x5a>
    if(pid == 0){
    249e:	c939                	beqz	a0,24f4 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    24a0:	2985                	addiw	s3,s3,1
    24a2:	ff2997e3          	bne	s3,s2,2490 <manywrites+0x16>
    24a6:	f852                	sd	s4,48(sp)
    24a8:	f05a                	sd	s6,32(sp)
    24aa:	ec5e                	sd	s7,24(sp)
    24ac:	4491                	li	s1,4
    int st = 0;
    24ae:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24b2:	fa840513          	addi	a0,s0,-88
    24b6:	00003097          	auipc	ra,0x3
    24ba:	6e0080e7          	jalr	1760(ra) # 5b96 <wait>
    if(st != 0)
    24be:	fa842503          	lw	a0,-88(s0)
    24c2:	10051463          	bnez	a0,25ca <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    24c6:	34fd                	addiw	s1,s1,-1
    24c8:	f0fd                	bnez	s1,24ae <manywrites+0x34>
  exit(0);
    24ca:	4501                	li	a0,0
    24cc:	00003097          	auipc	ra,0x3
    24d0:	6c2080e7          	jalr	1730(ra) # 5b8e <exit>
    24d4:	f852                	sd	s4,48(sp)
    24d6:	f05a                	sd	s6,32(sp)
    24d8:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    24da:	00005517          	auipc	a0,0x5
    24de:	8ce50513          	addi	a0,a0,-1842 # 6da8 <malloc+0xdd2>
    24e2:	00004097          	auipc	ra,0x4
    24e6:	a3c080e7          	jalr	-1476(ra) # 5f1e <printf>
      exit(1);
    24ea:	4505                	li	a0,1
    24ec:	00003097          	auipc	ra,0x3
    24f0:	6a2080e7          	jalr	1698(ra) # 5b8e <exit>
    24f4:	f852                	sd	s4,48(sp)
    24f6:	f05a                	sd	s6,32(sp)
    24f8:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    24fa:	06200793          	li	a5,98
    24fe:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2502:	0619879b          	addiw	a5,s3,97
    2506:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    250a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    250e:	fa840513          	addi	a0,s0,-88
    2512:	00003097          	auipc	ra,0x3
    2516:	6cc080e7          	jalr	1740(ra) # 5bde <unlink>
    251a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    251c:	0000cb17          	auipc	s6,0xc
    2520:	aacb0b13          	addi	s6,s6,-1364 # dfc8 <buf>
        for(int i = 0; i < ci+1; i++){
    2524:	8a26                	mv	s4,s1
    2526:	0209ce63          	bltz	s3,2562 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    252a:	20200593          	li	a1,514
    252e:	fa840513          	addi	a0,s0,-88
    2532:	00003097          	auipc	ra,0x3
    2536:	69c080e7          	jalr	1692(ra) # 5bce <open>
    253a:	892a                	mv	s2,a0
          if(fd < 0){
    253c:	04054763          	bltz	a0,258a <manywrites+0x110>
          int cc = write(fd, buf, sz);
    2540:	660d                	lui	a2,0x3
    2542:	85da                	mv	a1,s6
    2544:	00003097          	auipc	ra,0x3
    2548:	66a080e7          	jalr	1642(ra) # 5bae <write>
          if(cc != sz){
    254c:	678d                	lui	a5,0x3
    254e:	04f51e63          	bne	a0,a5,25aa <manywrites+0x130>
          close(fd);
    2552:	854a                	mv	a0,s2
    2554:	00003097          	auipc	ra,0x3
    2558:	662080e7          	jalr	1634(ra) # 5bb6 <close>
        for(int i = 0; i < ci+1; i++){
    255c:	2a05                	addiw	s4,s4,1
    255e:	fd49d6e3          	bge	s3,s4,252a <manywrites+0xb0>
        unlink(name);
    2562:	fa840513          	addi	a0,s0,-88
    2566:	00003097          	auipc	ra,0x3
    256a:	678080e7          	jalr	1656(ra) # 5bde <unlink>
      for(int iters = 0; iters < howmany; iters++){
    256e:	3bfd                	addiw	s7,s7,-1
    2570:	fa0b9ae3          	bnez	s7,2524 <manywrites+0xaa>
      unlink(name);
    2574:	fa840513          	addi	a0,s0,-88
    2578:	00003097          	auipc	ra,0x3
    257c:	666080e7          	jalr	1638(ra) # 5bde <unlink>
      exit(0);
    2580:	4501                	li	a0,0
    2582:	00003097          	auipc	ra,0x3
    2586:	60c080e7          	jalr	1548(ra) # 5b8e <exit>
            printf("%s: cannot create %s\n", s, name);
    258a:	fa840613          	addi	a2,s0,-88
    258e:	85d6                	mv	a1,s5
    2590:	00005517          	auipc	a0,0x5
    2594:	87050513          	addi	a0,a0,-1936 # 6e00 <malloc+0xe2a>
    2598:	00004097          	auipc	ra,0x4
    259c:	986080e7          	jalr	-1658(ra) # 5f1e <printf>
            exit(1);
    25a0:	4505                	li	a0,1
    25a2:	00003097          	auipc	ra,0x3
    25a6:	5ec080e7          	jalr	1516(ra) # 5b8e <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25aa:	86aa                	mv	a3,a0
    25ac:	660d                	lui	a2,0x3
    25ae:	85d6                	mv	a1,s5
    25b0:	00004517          	auipc	a0,0x4
    25b4:	c3850513          	addi	a0,a0,-968 # 61e8 <malloc+0x212>
    25b8:	00004097          	auipc	ra,0x4
    25bc:	966080e7          	jalr	-1690(ra) # 5f1e <printf>
            exit(1);
    25c0:	4505                	li	a0,1
    25c2:	00003097          	auipc	ra,0x3
    25c6:	5cc080e7          	jalr	1484(ra) # 5b8e <exit>
      exit(st);
    25ca:	00003097          	auipc	ra,0x3
    25ce:	5c4080e7          	jalr	1476(ra) # 5b8e <exit>

00000000000025d2 <copyinstr3>:
{
    25d2:	7179                	addi	sp,sp,-48
    25d4:	f406                	sd	ra,40(sp)
    25d6:	f022                	sd	s0,32(sp)
    25d8:	ec26                	sd	s1,24(sp)
    25da:	1800                	addi	s0,sp,48
  sbrk(8192);
    25dc:	6509                	lui	a0,0x2
    25de:	00003097          	auipc	ra,0x3
    25e2:	638080e7          	jalr	1592(ra) # 5c16 <sbrk>
  uint64 top = (uint64) sbrk(0);
    25e6:	4501                	li	a0,0
    25e8:	00003097          	auipc	ra,0x3
    25ec:	62e080e7          	jalr	1582(ra) # 5c16 <sbrk>
  if((top % PGSIZE) != 0){
    25f0:	03451793          	slli	a5,a0,0x34
    25f4:	e3c9                	bnez	a5,2676 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    25f6:	4501                	li	a0,0
    25f8:	00003097          	auipc	ra,0x3
    25fc:	61e080e7          	jalr	1566(ra) # 5c16 <sbrk>
  if(top % PGSIZE){
    2600:	03451793          	slli	a5,a0,0x34
    2604:	e3d9                	bnez	a5,268a <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2606:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x45>
  *b = 'x';
    260a:	07800793          	li	a5,120
    260e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2612:	8526                	mv	a0,s1
    2614:	00003097          	auipc	ra,0x3
    2618:	5ca080e7          	jalr	1482(ra) # 5bde <unlink>
  if(ret != -1){
    261c:	57fd                	li	a5,-1
    261e:	08f51363          	bne	a0,a5,26a4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2622:	20100593          	li	a1,513
    2626:	8526                	mv	a0,s1
    2628:	00003097          	auipc	ra,0x3
    262c:	5a6080e7          	jalr	1446(ra) # 5bce <open>
  if(fd != -1){
    2630:	57fd                	li	a5,-1
    2632:	08f51863          	bne	a0,a5,26c2 <copyinstr3+0xf0>
  ret = link(b, b);
    2636:	85a6                	mv	a1,s1
    2638:	8526                	mv	a0,s1
    263a:	00003097          	auipc	ra,0x3
    263e:	5b4080e7          	jalr	1460(ra) # 5bee <link>
  if(ret != -1){
    2642:	57fd                	li	a5,-1
    2644:	08f51e63          	bne	a0,a5,26e0 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2648:	00005797          	auipc	a5,0x5
    264c:	4b078793          	addi	a5,a5,1200 # 7af8 <malloc+0x1b22>
    2650:	fcf43823          	sd	a5,-48(s0)
    2654:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2658:	fd040593          	addi	a1,s0,-48
    265c:	8526                	mv	a0,s1
    265e:	00003097          	auipc	ra,0x3
    2662:	568080e7          	jalr	1384(ra) # 5bc6 <exec>
  if(ret != -1){
    2666:	57fd                	li	a5,-1
    2668:	08f51c63          	bne	a0,a5,2700 <copyinstr3+0x12e>
}
    266c:	70a2                	ld	ra,40(sp)
    266e:	7402                	ld	s0,32(sp)
    2670:	64e2                	ld	s1,24(sp)
    2672:	6145                	addi	sp,sp,48
    2674:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2676:	0347d513          	srli	a0,a5,0x34
    267a:	6785                	lui	a5,0x1
    267c:	40a7853b          	subw	a0,a5,a0
    2680:	00003097          	auipc	ra,0x3
    2684:	596080e7          	jalr	1430(ra) # 5c16 <sbrk>
    2688:	b7bd                	j	25f6 <copyinstr3+0x24>
    printf("oops\n");
    268a:	00004517          	auipc	a0,0x4
    268e:	78e50513          	addi	a0,a0,1934 # 6e18 <malloc+0xe42>
    2692:	00004097          	auipc	ra,0x4
    2696:	88c080e7          	jalr	-1908(ra) # 5f1e <printf>
    exit(1);
    269a:	4505                	li	a0,1
    269c:	00003097          	auipc	ra,0x3
    26a0:	4f2080e7          	jalr	1266(ra) # 5b8e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26a4:	862a                	mv	a2,a0
    26a6:	85a6                	mv	a1,s1
    26a8:	00004517          	auipc	a0,0x4
    26ac:	21850513          	addi	a0,a0,536 # 68c0 <malloc+0x8ea>
    26b0:	00004097          	auipc	ra,0x4
    26b4:	86e080e7          	jalr	-1938(ra) # 5f1e <printf>
    exit(1);
    26b8:	4505                	li	a0,1
    26ba:	00003097          	auipc	ra,0x3
    26be:	4d4080e7          	jalr	1236(ra) # 5b8e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26c2:	862a                	mv	a2,a0
    26c4:	85a6                	mv	a1,s1
    26c6:	00004517          	auipc	a0,0x4
    26ca:	21a50513          	addi	a0,a0,538 # 68e0 <malloc+0x90a>
    26ce:	00004097          	auipc	ra,0x4
    26d2:	850080e7          	jalr	-1968(ra) # 5f1e <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	4b6080e7          	jalr	1206(ra) # 5b8e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    26e0:	86aa                	mv	a3,a0
    26e2:	8626                	mv	a2,s1
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	21a50513          	addi	a0,a0,538 # 6900 <malloc+0x92a>
    26ee:	00004097          	auipc	ra,0x4
    26f2:	830080e7          	jalr	-2000(ra) # 5f1e <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	00003097          	auipc	ra,0x3
    26fc:	496080e7          	jalr	1174(ra) # 5b8e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2700:	567d                	li	a2,-1
    2702:	85a6                	mv	a1,s1
    2704:	00004517          	auipc	a0,0x4
    2708:	22450513          	addi	a0,a0,548 # 6928 <malloc+0x952>
    270c:	00004097          	auipc	ra,0x4
    2710:	812080e7          	jalr	-2030(ra) # 5f1e <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	478080e7          	jalr	1144(ra) # 5b8e <exit>

000000000000271e <rwsbrk>:
{
    271e:	1101                	addi	sp,sp,-32
    2720:	ec06                	sd	ra,24(sp)
    2722:	e822                	sd	s0,16(sp)
    2724:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2726:	6509                	lui	a0,0x2
    2728:	00003097          	auipc	ra,0x3
    272c:	4ee080e7          	jalr	1262(ra) # 5c16 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2730:	57fd                	li	a5,-1
    2732:	06f50463          	beq	a0,a5,279a <rwsbrk+0x7c>
    2736:	e426                	sd	s1,8(sp)
    2738:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    273a:	7579                	lui	a0,0xffffe
    273c:	00003097          	auipc	ra,0x3
    2740:	4da080e7          	jalr	1242(ra) # 5c16 <sbrk>
    2744:	57fd                	li	a5,-1
    2746:	06f50963          	beq	a0,a5,27b8 <rwsbrk+0x9a>
    274a:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    274c:	20100593          	li	a1,513
    2750:	00004517          	auipc	a0,0x4
    2754:	70850513          	addi	a0,a0,1800 # 6e58 <malloc+0xe82>
    2758:	00003097          	auipc	ra,0x3
    275c:	476080e7          	jalr	1142(ra) # 5bce <open>
    2760:	892a                	mv	s2,a0
  if(fd < 0){
    2762:	06054963          	bltz	a0,27d4 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    2766:	6785                	lui	a5,0x1
    2768:	94be                	add	s1,s1,a5
    276a:	40000613          	li	a2,1024
    276e:	85a6                	mv	a1,s1
    2770:	00003097          	auipc	ra,0x3
    2774:	43e080e7          	jalr	1086(ra) # 5bae <write>
    2778:	862a                	mv	a2,a0
  if(n >= 0){
    277a:	06054a63          	bltz	a0,27ee <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    277e:	85a6                	mv	a1,s1
    2780:	00004517          	auipc	a0,0x4
    2784:	6f850513          	addi	a0,a0,1784 # 6e78 <malloc+0xea2>
    2788:	00003097          	auipc	ra,0x3
    278c:	796080e7          	jalr	1942(ra) # 5f1e <printf>
    exit(1);
    2790:	4505                	li	a0,1
    2792:	00003097          	auipc	ra,0x3
    2796:	3fc080e7          	jalr	1020(ra) # 5b8e <exit>
    279a:	e426                	sd	s1,8(sp)
    279c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    279e:	00004517          	auipc	a0,0x4
    27a2:	68250513          	addi	a0,a0,1666 # 6e20 <malloc+0xe4a>
    27a6:	00003097          	auipc	ra,0x3
    27aa:	778080e7          	jalr	1912(ra) # 5f1e <printf>
    exit(1);
    27ae:	4505                	li	a0,1
    27b0:	00003097          	auipc	ra,0x3
    27b4:	3de080e7          	jalr	990(ra) # 5b8e <exit>
    27b8:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    27ba:	00004517          	auipc	a0,0x4
    27be:	67e50513          	addi	a0,a0,1662 # 6e38 <malloc+0xe62>
    27c2:	00003097          	auipc	ra,0x3
    27c6:	75c080e7          	jalr	1884(ra) # 5f1e <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00003097          	auipc	ra,0x3
    27d0:	3c2080e7          	jalr	962(ra) # 5b8e <exit>
    printf("open(rwsbrk) failed\n");
    27d4:	00004517          	auipc	a0,0x4
    27d8:	68c50513          	addi	a0,a0,1676 # 6e60 <malloc+0xe8a>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	742080e7          	jalr	1858(ra) # 5f1e <printf>
    exit(1);
    27e4:	4505                	li	a0,1
    27e6:	00003097          	auipc	ra,0x3
    27ea:	3a8080e7          	jalr	936(ra) # 5b8e <exit>
  close(fd);
    27ee:	854a                	mv	a0,s2
    27f0:	00003097          	auipc	ra,0x3
    27f4:	3c6080e7          	jalr	966(ra) # 5bb6 <close>
  unlink("rwsbrk");
    27f8:	00004517          	auipc	a0,0x4
    27fc:	66050513          	addi	a0,a0,1632 # 6e58 <malloc+0xe82>
    2800:	00003097          	auipc	ra,0x3
    2804:	3de080e7          	jalr	990(ra) # 5bde <unlink>
  fd = open("README", O_RDONLY);
    2808:	4581                	li	a1,0
    280a:	00004517          	auipc	a0,0x4
    280e:	ae650513          	addi	a0,a0,-1306 # 62f0 <malloc+0x31a>
    2812:	00003097          	auipc	ra,0x3
    2816:	3bc080e7          	jalr	956(ra) # 5bce <open>
    281a:	892a                	mv	s2,a0
  if(fd < 0){
    281c:	02054963          	bltz	a0,284e <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2820:	4629                	li	a2,10
    2822:	85a6                	mv	a1,s1
    2824:	00003097          	auipc	ra,0x3
    2828:	382080e7          	jalr	898(ra) # 5ba6 <read>
    282c:	862a                	mv	a2,a0
  if(n >= 0){
    282e:	02054d63          	bltz	a0,2868 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2832:	85a6                	mv	a1,s1
    2834:	00004517          	auipc	a0,0x4
    2838:	67450513          	addi	a0,a0,1652 # 6ea8 <malloc+0xed2>
    283c:	00003097          	auipc	ra,0x3
    2840:	6e2080e7          	jalr	1762(ra) # 5f1e <printf>
    exit(1);
    2844:	4505                	li	a0,1
    2846:	00003097          	auipc	ra,0x3
    284a:	348080e7          	jalr	840(ra) # 5b8e <exit>
    printf("open(rwsbrk) failed\n");
    284e:	00004517          	auipc	a0,0x4
    2852:	61250513          	addi	a0,a0,1554 # 6e60 <malloc+0xe8a>
    2856:	00003097          	auipc	ra,0x3
    285a:	6c8080e7          	jalr	1736(ra) # 5f1e <printf>
    exit(1);
    285e:	4505                	li	a0,1
    2860:	00003097          	auipc	ra,0x3
    2864:	32e080e7          	jalr	814(ra) # 5b8e <exit>
  close(fd);
    2868:	854a                	mv	a0,s2
    286a:	00003097          	auipc	ra,0x3
    286e:	34c080e7          	jalr	844(ra) # 5bb6 <close>
  exit(0);
    2872:	4501                	li	a0,0
    2874:	00003097          	auipc	ra,0x3
    2878:	31a080e7          	jalr	794(ra) # 5b8e <exit>

000000000000287c <sbrkbasic>:
{
    287c:	7139                	addi	sp,sp,-64
    287e:	fc06                	sd	ra,56(sp)
    2880:	f822                	sd	s0,48(sp)
    2882:	ec4e                	sd	s3,24(sp)
    2884:	0080                	addi	s0,sp,64
    2886:	89aa                	mv	s3,a0
  pid = fork();
    2888:	00003097          	auipc	ra,0x3
    288c:	2fe080e7          	jalr	766(ra) # 5b86 <fork>
  if(pid < 0){
    2890:	02054f63          	bltz	a0,28ce <sbrkbasic+0x52>
  if(pid == 0){
    2894:	e52d                	bnez	a0,28fe <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2896:	40000537          	lui	a0,0x40000
    289a:	00003097          	auipc	ra,0x3
    289e:	37c080e7          	jalr	892(ra) # 5c16 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28a2:	57fd                	li	a5,-1
    28a4:	04f50563          	beq	a0,a5,28ee <sbrkbasic+0x72>
    28a8:	f426                	sd	s1,40(sp)
    28aa:	f04a                	sd	s2,32(sp)
    28ac:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ae:	400007b7          	lui	a5,0x40000
    28b2:	97aa                	add	a5,a5,a0
      *b = 99;
    28b4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28b8:	6705                	lui	a4,0x1
      *b = 99;
    28ba:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef038>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28be:	953a                	add	a0,a0,a4
    28c0:	fef51de3          	bne	a0,a5,28ba <sbrkbasic+0x3e>
    exit(1);
    28c4:	4505                	li	a0,1
    28c6:	00003097          	auipc	ra,0x3
    28ca:	2c8080e7          	jalr	712(ra) # 5b8e <exit>
    28ce:	f426                	sd	s1,40(sp)
    28d0:	f04a                	sd	s2,32(sp)
    28d2:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    28d4:	00004517          	auipc	a0,0x4
    28d8:	5fc50513          	addi	a0,a0,1532 # 6ed0 <malloc+0xefa>
    28dc:	00003097          	auipc	ra,0x3
    28e0:	642080e7          	jalr	1602(ra) # 5f1e <printf>
    exit(1);
    28e4:	4505                	li	a0,1
    28e6:	00003097          	auipc	ra,0x3
    28ea:	2a8080e7          	jalr	680(ra) # 5b8e <exit>
    28ee:	f426                	sd	s1,40(sp)
    28f0:	f04a                	sd	s2,32(sp)
    28f2:	e852                	sd	s4,16(sp)
      exit(0);
    28f4:	4501                	li	a0,0
    28f6:	00003097          	auipc	ra,0x3
    28fa:	298080e7          	jalr	664(ra) # 5b8e <exit>
  wait(&xstatus);
    28fe:	fcc40513          	addi	a0,s0,-52
    2902:	00003097          	auipc	ra,0x3
    2906:	294080e7          	jalr	660(ra) # 5b96 <wait>
  if(xstatus == 1){
    290a:	fcc42703          	lw	a4,-52(s0)
    290e:	4785                	li	a5,1
    2910:	02f70063          	beq	a4,a5,2930 <sbrkbasic+0xb4>
    2914:	f426                	sd	s1,40(sp)
    2916:	f04a                	sd	s2,32(sp)
    2918:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    291a:	4501                	li	a0,0
    291c:	00003097          	auipc	ra,0x3
    2920:	2fa080e7          	jalr	762(ra) # 5c16 <sbrk>
    2924:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2926:	4901                	li	s2,0
    2928:	6a05                	lui	s4,0x1
    292a:	388a0a13          	addi	s4,s4,904 # 1388 <badarg+0x3e>
    292e:	a01d                	j	2954 <sbrkbasic+0xd8>
    2930:	f426                	sd	s1,40(sp)
    2932:	f04a                	sd	s2,32(sp)
    2934:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2936:	85ce                	mv	a1,s3
    2938:	00004517          	auipc	a0,0x4
    293c:	5b850513          	addi	a0,a0,1464 # 6ef0 <malloc+0xf1a>
    2940:	00003097          	auipc	ra,0x3
    2944:	5de080e7          	jalr	1502(ra) # 5f1e <printf>
    exit(1);
    2948:	4505                	li	a0,1
    294a:	00003097          	auipc	ra,0x3
    294e:	244080e7          	jalr	580(ra) # 5b8e <exit>
    2952:	84be                	mv	s1,a5
    b = sbrk(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	2c0080e7          	jalr	704(ra) # 5c16 <sbrk>
    if(b != a){
    295e:	04951c63          	bne	a0,s1,29b6 <sbrkbasic+0x13a>
    *b = 1;
    2962:	4785                	li	a5,1
    2964:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2968:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    296c:	2905                	addiw	s2,s2,1
    296e:	ff4912e3          	bne	s2,s4,2952 <sbrkbasic+0xd6>
  pid = fork();
    2972:	00003097          	auipc	ra,0x3
    2976:	214080e7          	jalr	532(ra) # 5b86 <fork>
    297a:	892a                	mv	s2,a0
  if(pid < 0){
    297c:	04054e63          	bltz	a0,29d8 <sbrkbasic+0x15c>
  c = sbrk(1);
    2980:	4505                	li	a0,1
    2982:	00003097          	auipc	ra,0x3
    2986:	294080e7          	jalr	660(ra) # 5c16 <sbrk>
  c = sbrk(1);
    298a:	4505                	li	a0,1
    298c:	00003097          	auipc	ra,0x3
    2990:	28a080e7          	jalr	650(ra) # 5c16 <sbrk>
  if(c != a + 1){
    2994:	0489                	addi	s1,s1,2
    2996:	04a48f63          	beq	s1,a0,29f4 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	5b450513          	addi	a0,a0,1460 # 6f50 <malloc+0xf7a>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	57a080e7          	jalr	1402(ra) # 5f1e <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	1e0080e7          	jalr	480(ra) # 5b8e <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29b6:	872a                	mv	a4,a0
    29b8:	86a6                	mv	a3,s1
    29ba:	864a                	mv	a2,s2
    29bc:	85ce                	mv	a1,s3
    29be:	00004517          	auipc	a0,0x4
    29c2:	55250513          	addi	a0,a0,1362 # 6f10 <malloc+0xf3a>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	558080e7          	jalr	1368(ra) # 5f1e <printf>
      exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	1be080e7          	jalr	446(ra) # 5b8e <exit>
    printf("%s: sbrk test fork failed\n", s);
    29d8:	85ce                	mv	a1,s3
    29da:	00004517          	auipc	a0,0x4
    29de:	55650513          	addi	a0,a0,1366 # 6f30 <malloc+0xf5a>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	53c080e7          	jalr	1340(ra) # 5f1e <printf>
    exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	1a2080e7          	jalr	418(ra) # 5b8e <exit>
  if(pid == 0)
    29f4:	00091763          	bnez	s2,2a02 <sbrkbasic+0x186>
    exit(0);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	194080e7          	jalr	404(ra) # 5b8e <exit>
  wait(&xstatus);
    2a02:	fcc40513          	addi	a0,s0,-52
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	190080e7          	jalr	400(ra) # 5b96 <wait>
  exit(xstatus);
    2a0e:	fcc42503          	lw	a0,-52(s0)
    2a12:	00003097          	auipc	ra,0x3
    2a16:	17c080e7          	jalr	380(ra) # 5b8e <exit>

0000000000002a1a <sbrkmuch>:
{
    2a1a:	7179                	addi	sp,sp,-48
    2a1c:	f406                	sd	ra,40(sp)
    2a1e:	f022                	sd	s0,32(sp)
    2a20:	ec26                	sd	s1,24(sp)
    2a22:	e84a                	sd	s2,16(sp)
    2a24:	e44e                	sd	s3,8(sp)
    2a26:	e052                	sd	s4,0(sp)
    2a28:	1800                	addi	s0,sp,48
    2a2a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a2c:	4501                	li	a0,0
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	1e8080e7          	jalr	488(ra) # 5c16 <sbrk>
    2a36:	892a                	mv	s2,a0
  a = sbrk(0);
    2a38:	4501                	li	a0,0
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	1dc080e7          	jalr	476(ra) # 5c16 <sbrk>
    2a42:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a44:	06400537          	lui	a0,0x6400
    2a48:	9d05                	subw	a0,a0,s1
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	1cc080e7          	jalr	460(ra) # 5c16 <sbrk>
  if (p != a) {
    2a52:	0ca49863          	bne	s1,a0,2b22 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a56:	4501                	li	a0,0
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	1be080e7          	jalr	446(ra) # 5c16 <sbrk>
    2a60:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a62:	00a4f963          	bgeu	s1,a0,2a74 <sbrkmuch+0x5a>
    *pp = 1;
    2a66:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a68:	6705                	lui	a4,0x1
    *pp = 1;
    2a6a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a6e:	94ba                	add	s1,s1,a4
    2a70:	fef4ede3          	bltu	s1,a5,2a6a <sbrkmuch+0x50>
  *lastaddr = 99;
    2a74:	064007b7          	lui	a5,0x6400
    2a78:	06300713          	li	a4,99
    2a7c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef037>
  a = sbrk(0);
    2a80:	4501                	li	a0,0
    2a82:	00003097          	auipc	ra,0x3
    2a86:	194080e7          	jalr	404(ra) # 5c16 <sbrk>
    2a8a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2a8c:	757d                	lui	a0,0xfffff
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	188080e7          	jalr	392(ra) # 5c16 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2a96:	57fd                	li	a5,-1
    2a98:	0af50363          	beq	a0,a5,2b3e <sbrkmuch+0x124>
  c = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	178080e7          	jalr	376(ra) # 5c16 <sbrk>
  if(c != a - PGSIZE){
    2aa6:	77fd                	lui	a5,0xfffff
    2aa8:	97a6                	add	a5,a5,s1
    2aaa:	0af51863          	bne	a0,a5,2b5a <sbrkmuch+0x140>
  a = sbrk(0);
    2aae:	4501                	li	a0,0
    2ab0:	00003097          	auipc	ra,0x3
    2ab4:	166080e7          	jalr	358(ra) # 5c16 <sbrk>
    2ab8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2aba:	6505                	lui	a0,0x1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	15a080e7          	jalr	346(ra) # 5c16 <sbrk>
    2ac4:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ac6:	0aa49a63          	bne	s1,a0,2b7a <sbrkmuch+0x160>
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	14a080e7          	jalr	330(ra) # 5c16 <sbrk>
    2ad4:	6785                	lui	a5,0x1
    2ad6:	97a6                	add	a5,a5,s1
    2ad8:	0af51163          	bne	a0,a5,2b7a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2adc:	064007b7          	lui	a5,0x6400
    2ae0:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef037>
    2ae4:	06300793          	li	a5,99
    2ae8:	0af70963          	beq	a4,a5,2b9a <sbrkmuch+0x180>
  a = sbrk(0);
    2aec:	4501                	li	a0,0
    2aee:	00003097          	auipc	ra,0x3
    2af2:	128080e7          	jalr	296(ra) # 5c16 <sbrk>
    2af6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2af8:	4501                	li	a0,0
    2afa:	00003097          	auipc	ra,0x3
    2afe:	11c080e7          	jalr	284(ra) # 5c16 <sbrk>
    2b02:	40a9053b          	subw	a0,s2,a0
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	110080e7          	jalr	272(ra) # 5c16 <sbrk>
  if(c != a){
    2b0e:	0aa49463          	bne	s1,a0,2bb6 <sbrkmuch+0x19c>
}
    2b12:	70a2                	ld	ra,40(sp)
    2b14:	7402                	ld	s0,32(sp)
    2b16:	64e2                	ld	s1,24(sp)
    2b18:	6942                	ld	s2,16(sp)
    2b1a:	69a2                	ld	s3,8(sp)
    2b1c:	6a02                	ld	s4,0(sp)
    2b1e:	6145                	addi	sp,sp,48
    2b20:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b22:	85ce                	mv	a1,s3
    2b24:	00004517          	auipc	a0,0x4
    2b28:	44c50513          	addi	a0,a0,1100 # 6f70 <malloc+0xf9a>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	3f2080e7          	jalr	1010(ra) # 5f1e <printf>
    exit(1);
    2b34:	4505                	li	a0,1
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	058080e7          	jalr	88(ra) # 5b8e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b3e:	85ce                	mv	a1,s3
    2b40:	00004517          	auipc	a0,0x4
    2b44:	47850513          	addi	a0,a0,1144 # 6fb8 <malloc+0xfe2>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	3d6080e7          	jalr	982(ra) # 5f1e <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	03c080e7          	jalr	60(ra) # 5b8e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b5a:	86aa                	mv	a3,a0
    2b5c:	8626                	mv	a2,s1
    2b5e:	85ce                	mv	a1,s3
    2b60:	00004517          	auipc	a0,0x4
    2b64:	47850513          	addi	a0,a0,1144 # 6fd8 <malloc+0x1002>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	3b6080e7          	jalr	950(ra) # 5f1e <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	00003097          	auipc	ra,0x3
    2b76:	01c080e7          	jalr	28(ra) # 5b8e <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b7a:	86d2                	mv	a3,s4
    2b7c:	8626                	mv	a2,s1
    2b7e:	85ce                	mv	a1,s3
    2b80:	00004517          	auipc	a0,0x4
    2b84:	49850513          	addi	a0,a0,1176 # 7018 <malloc+0x1042>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	396080e7          	jalr	918(ra) # 5f1e <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	ffc080e7          	jalr	-4(ra) # 5b8e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2b9a:	85ce                	mv	a1,s3
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	4ac50513          	addi	a0,a0,1196 # 7048 <malloc+0x1072>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	37a080e7          	jalr	890(ra) # 5f1e <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	fe0080e7          	jalr	-32(ra) # 5b8e <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bb6:	86aa                	mv	a3,a0
    2bb8:	8626                	mv	a2,s1
    2bba:	85ce                	mv	a1,s3
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	4c450513          	addi	a0,a0,1220 # 7080 <malloc+0x10aa>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	35a080e7          	jalr	858(ra) # 5f1e <printf>
    exit(1);
    2bcc:	4505                	li	a0,1
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	fc0080e7          	jalr	-64(ra) # 5b8e <exit>

0000000000002bd6 <sbrkarg>:
{
    2bd6:	7179                	addi	sp,sp,-48
    2bd8:	f406                	sd	ra,40(sp)
    2bda:	f022                	sd	s0,32(sp)
    2bdc:	ec26                	sd	s1,24(sp)
    2bde:	e84a                	sd	s2,16(sp)
    2be0:	e44e                	sd	s3,8(sp)
    2be2:	1800                	addi	s0,sp,48
    2be4:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2be6:	6505                	lui	a0,0x1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	02e080e7          	jalr	46(ra) # 5c16 <sbrk>
    2bf0:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2bf2:	20100593          	li	a1,513
    2bf6:	00004517          	auipc	a0,0x4
    2bfa:	4b250513          	addi	a0,a0,1202 # 70a8 <malloc+0x10d2>
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	fd0080e7          	jalr	-48(ra) # 5bce <open>
    2c06:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	4a050513          	addi	a0,a0,1184 # 70a8 <malloc+0x10d2>
    2c10:	00003097          	auipc	ra,0x3
    2c14:	fce080e7          	jalr	-50(ra) # 5bde <unlink>
  if(fd < 0)  {
    2c18:	0404c163          	bltz	s1,2c5a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c1c:	6605                	lui	a2,0x1
    2c1e:	85ca                	mv	a1,s2
    2c20:	8526                	mv	a0,s1
    2c22:	00003097          	auipc	ra,0x3
    2c26:	f8c080e7          	jalr	-116(ra) # 5bae <write>
    2c2a:	04054663          	bltz	a0,2c76 <sbrkarg+0xa0>
  close(fd);
    2c2e:	8526                	mv	a0,s1
    2c30:	00003097          	auipc	ra,0x3
    2c34:	f86080e7          	jalr	-122(ra) # 5bb6 <close>
  a = sbrk(PGSIZE);
    2c38:	6505                	lui	a0,0x1
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	fdc080e7          	jalr	-36(ra) # 5c16 <sbrk>
  if(pipe((int *) a) != 0){
    2c42:	00003097          	auipc	ra,0x3
    2c46:	f5c080e7          	jalr	-164(ra) # 5b9e <pipe>
    2c4a:	e521                	bnez	a0,2c92 <sbrkarg+0xbc>
}
    2c4c:	70a2                	ld	ra,40(sp)
    2c4e:	7402                	ld	s0,32(sp)
    2c50:	64e2                	ld	s1,24(sp)
    2c52:	6942                	ld	s2,16(sp)
    2c54:	69a2                	ld	s3,8(sp)
    2c56:	6145                	addi	sp,sp,48
    2c58:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c5a:	85ce                	mv	a1,s3
    2c5c:	00004517          	auipc	a0,0x4
    2c60:	45450513          	addi	a0,a0,1108 # 70b0 <malloc+0x10da>
    2c64:	00003097          	auipc	ra,0x3
    2c68:	2ba080e7          	jalr	698(ra) # 5f1e <printf>
    exit(1);
    2c6c:	4505                	li	a0,1
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	f20080e7          	jalr	-224(ra) # 5b8e <exit>
    printf("%s: write sbrk failed\n", s);
    2c76:	85ce                	mv	a1,s3
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	45050513          	addi	a0,a0,1104 # 70c8 <malloc+0x10f2>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	29e080e7          	jalr	670(ra) # 5f1e <printf>
    exit(1);
    2c88:	4505                	li	a0,1
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f04080e7          	jalr	-252(ra) # 5b8e <exit>
    printf("%s: pipe() failed\n", s);
    2c92:	85ce                	mv	a1,s3
    2c94:	00004517          	auipc	a0,0x4
    2c98:	e1450513          	addi	a0,a0,-492 # 6aa8 <malloc+0xad2>
    2c9c:	00003097          	auipc	ra,0x3
    2ca0:	282080e7          	jalr	642(ra) # 5f1e <printf>
    exit(1);
    2ca4:	4505                	li	a0,1
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	ee8080e7          	jalr	-280(ra) # 5b8e <exit>

0000000000002cae <argptest>:
{
    2cae:	1101                	addi	sp,sp,-32
    2cb0:	ec06                	sd	ra,24(sp)
    2cb2:	e822                	sd	s0,16(sp)
    2cb4:	e426                	sd	s1,8(sp)
    2cb6:	e04a                	sd	s2,0(sp)
    2cb8:	1000                	addi	s0,sp,32
    2cba:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cbc:	4581                	li	a1,0
    2cbe:	00004517          	auipc	a0,0x4
    2cc2:	42250513          	addi	a0,a0,1058 # 70e0 <malloc+0x110a>
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	f08080e7          	jalr	-248(ra) # 5bce <open>
  if (fd < 0) {
    2cce:	02054b63          	bltz	a0,2d04 <argptest+0x56>
    2cd2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cd4:	4501                	li	a0,0
    2cd6:	00003097          	auipc	ra,0x3
    2cda:	f40080e7          	jalr	-192(ra) # 5c16 <sbrk>
    2cde:	567d                	li	a2,-1
    2ce0:	fff50593          	addi	a1,a0,-1
    2ce4:	8526                	mv	a0,s1
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	ec0080e7          	jalr	-320(ra) # 5ba6 <read>
  close(fd);
    2cee:	8526                	mv	a0,s1
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	ec6080e7          	jalr	-314(ra) # 5bb6 <close>
}
    2cf8:	60e2                	ld	ra,24(sp)
    2cfa:	6442                	ld	s0,16(sp)
    2cfc:	64a2                	ld	s1,8(sp)
    2cfe:	6902                	ld	s2,0(sp)
    2d00:	6105                	addi	sp,sp,32
    2d02:	8082                	ret
    printf("%s: open failed\n", s);
    2d04:	85ca                	mv	a1,s2
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	cb250513          	addi	a0,a0,-846 # 69b8 <malloc+0x9e2>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	210080e7          	jalr	528(ra) # 5f1e <printf>
    exit(1);
    2d16:	4505                	li	a0,1
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	e76080e7          	jalr	-394(ra) # 5b8e <exit>

0000000000002d20 <sbrkbugs>:
{
    2d20:	1141                	addi	sp,sp,-16
    2d22:	e406                	sd	ra,8(sp)
    2d24:	e022                	sd	s0,0(sp)
    2d26:	0800                	addi	s0,sp,16
  int pid = fork();
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	e5e080e7          	jalr	-418(ra) # 5b86 <fork>
  if(pid < 0){
    2d30:	02054263          	bltz	a0,2d54 <sbrkbugs+0x34>
  if(pid == 0){
    2d34:	ed0d                	bnez	a0,2d6e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	ee0080e7          	jalr	-288(ra) # 5c16 <sbrk>
    sbrk(-sz);
    2d3e:	40a0053b          	negw	a0,a0
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ed4080e7          	jalr	-300(ra) # 5c16 <sbrk>
    exit(0);
    2d4a:	4501                	li	a0,0
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	e42080e7          	jalr	-446(ra) # 5b8e <exit>
    printf("fork failed\n");
    2d54:	00004517          	auipc	a0,0x4
    2d58:	05450513          	addi	a0,a0,84 # 6da8 <malloc+0xdd2>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	1c2080e7          	jalr	450(ra) # 5f1e <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	e28080e7          	jalr	-472(ra) # 5b8e <exit>
  wait(0);
    2d6e:	4501                	li	a0,0
    2d70:	00003097          	auipc	ra,0x3
    2d74:	e26080e7          	jalr	-474(ra) # 5b96 <wait>
  pid = fork();
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	e0e080e7          	jalr	-498(ra) # 5b86 <fork>
  if(pid < 0){
    2d80:	02054563          	bltz	a0,2daa <sbrkbugs+0x8a>
  if(pid == 0){
    2d84:	e121                	bnez	a0,2dc4 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	e90080e7          	jalr	-368(ra) # 5c16 <sbrk>
    sbrk(-(sz - 3500));
    2d8e:	6785                	lui	a5,0x1
    2d90:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2d94:	40a7853b          	subw	a0,a5,a0
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e7e080e7          	jalr	-386(ra) # 5c16 <sbrk>
    exit(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	dec080e7          	jalr	-532(ra) # 5b8e <exit>
    printf("fork failed\n");
    2daa:	00004517          	auipc	a0,0x4
    2dae:	ffe50513          	addi	a0,a0,-2 # 6da8 <malloc+0xdd2>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	16c080e7          	jalr	364(ra) # 5f1e <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	dd2080e7          	jalr	-558(ra) # 5b8e <exit>
  wait(0);
    2dc4:	4501                	li	a0,0
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	dd0080e7          	jalr	-560(ra) # 5b96 <wait>
  pid = fork();
    2dce:	00003097          	auipc	ra,0x3
    2dd2:	db8080e7          	jalr	-584(ra) # 5b86 <fork>
  if(pid < 0){
    2dd6:	02054a63          	bltz	a0,2e0a <sbrkbugs+0xea>
  if(pid == 0){
    2dda:	e529                	bnez	a0,2e24 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2ddc:	00003097          	auipc	ra,0x3
    2de0:	e3a080e7          	jalr	-454(ra) # 5c16 <sbrk>
    2de4:	67ad                	lui	a5,0xb
    2de6:	8007879b          	addiw	a5,a5,-2048 # a800 <args.1+0x50>
    2dea:	40a7853b          	subw	a0,a5,a0
    2dee:	00003097          	auipc	ra,0x3
    2df2:	e28080e7          	jalr	-472(ra) # 5c16 <sbrk>
    sbrk(-10);
    2df6:	5559                	li	a0,-10
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	e1e080e7          	jalr	-482(ra) # 5c16 <sbrk>
    exit(0);
    2e00:	4501                	li	a0,0
    2e02:	00003097          	auipc	ra,0x3
    2e06:	d8c080e7          	jalr	-628(ra) # 5b8e <exit>
    printf("fork failed\n");
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	f9e50513          	addi	a0,a0,-98 # 6da8 <malloc+0xdd2>
    2e12:	00003097          	auipc	ra,0x3
    2e16:	10c080e7          	jalr	268(ra) # 5f1e <printf>
    exit(1);
    2e1a:	4505                	li	a0,1
    2e1c:	00003097          	auipc	ra,0x3
    2e20:	d72080e7          	jalr	-654(ra) # 5b8e <exit>
  wait(0);
    2e24:	4501                	li	a0,0
    2e26:	00003097          	auipc	ra,0x3
    2e2a:	d70080e7          	jalr	-656(ra) # 5b96 <wait>
  exit(0);
    2e2e:	4501                	li	a0,0
    2e30:	00003097          	auipc	ra,0x3
    2e34:	d5e080e7          	jalr	-674(ra) # 5b8e <exit>

0000000000002e38 <sbrklast>:
{
    2e38:	7179                	addi	sp,sp,-48
    2e3a:	f406                	sd	ra,40(sp)
    2e3c:	f022                	sd	s0,32(sp)
    2e3e:	ec26                	sd	s1,24(sp)
    2e40:	e84a                	sd	s2,16(sp)
    2e42:	e44e                	sd	s3,8(sp)
    2e44:	e052                	sd	s4,0(sp)
    2e46:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e48:	4501                	li	a0,0
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	dcc080e7          	jalr	-564(ra) # 5c16 <sbrk>
  if((top % 4096) != 0)
    2e52:	03451793          	slli	a5,a0,0x34
    2e56:	ebd9                	bnez	a5,2eec <sbrklast+0xb4>
  sbrk(4096);
    2e58:	6505                	lui	a0,0x1
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	dbc080e7          	jalr	-580(ra) # 5c16 <sbrk>
  sbrk(10);
    2e62:	4529                	li	a0,10
    2e64:	00003097          	auipc	ra,0x3
    2e68:	db2080e7          	jalr	-590(ra) # 5c16 <sbrk>
  sbrk(-20);
    2e6c:	5531                	li	a0,-20
    2e6e:	00003097          	auipc	ra,0x3
    2e72:	da8080e7          	jalr	-600(ra) # 5c16 <sbrk>
  top = (uint64) sbrk(0);
    2e76:	4501                	li	a0,0
    2e78:	00003097          	auipc	ra,0x3
    2e7c:	d9e080e7          	jalr	-610(ra) # 5c16 <sbrk>
    2e80:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2e82:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2e86:	07800a13          	li	s4,120
    2e8a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2e8e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2e92:	20200593          	li	a1,514
    2e96:	854a                	mv	a0,s2
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	d36080e7          	jalr	-714(ra) # 5bce <open>
    2ea0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ea2:	4605                	li	a2,1
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00003097          	auipc	ra,0x3
    2eaa:	d08080e7          	jalr	-760(ra) # 5bae <write>
  close(fd);
    2eae:	854e                	mv	a0,s3
    2eb0:	00003097          	auipc	ra,0x3
    2eb4:	d06080e7          	jalr	-762(ra) # 5bb6 <close>
  fd = open(p, O_RDWR);
    2eb8:	4589                	li	a1,2
    2eba:	854a                	mv	a0,s2
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	d12080e7          	jalr	-750(ra) # 5bce <open>
  p[0] = '\0';
    2ec4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ec8:	4605                	li	a2,1
    2eca:	85ca                	mv	a1,s2
    2ecc:	00003097          	auipc	ra,0x3
    2ed0:	cda080e7          	jalr	-806(ra) # 5ba6 <read>
  if(p[0] != 'x')
    2ed4:	fc04c783          	lbu	a5,-64(s1)
    2ed8:	03479463          	bne	a5,s4,2f00 <sbrklast+0xc8>
}
    2edc:	70a2                	ld	ra,40(sp)
    2ede:	7402                	ld	s0,32(sp)
    2ee0:	64e2                	ld	s1,24(sp)
    2ee2:	6942                	ld	s2,16(sp)
    2ee4:	69a2                	ld	s3,8(sp)
    2ee6:	6a02                	ld	s4,0(sp)
    2ee8:	6145                	addi	sp,sp,48
    2eea:	8082                	ret
    sbrk(4096 - (top % 4096));
    2eec:	0347d513          	srli	a0,a5,0x34
    2ef0:	6785                	lui	a5,0x1
    2ef2:	40a7853b          	subw	a0,a5,a0
    2ef6:	00003097          	auipc	ra,0x3
    2efa:	d20080e7          	jalr	-736(ra) # 5c16 <sbrk>
    2efe:	bfa9                	j	2e58 <sbrklast+0x20>
    exit(1);
    2f00:	4505                	li	a0,1
    2f02:	00003097          	auipc	ra,0x3
    2f06:	c8c080e7          	jalr	-884(ra) # 5b8e <exit>

0000000000002f0a <sbrk8000>:
{
    2f0a:	1141                	addi	sp,sp,-16
    2f0c:	e406                	sd	ra,8(sp)
    2f0e:	e022                	sd	s0,0(sp)
    2f10:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f12:	80000537          	lui	a0,0x80000
    2f16:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef03c>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	cfe080e7          	jalr	-770(ra) # 5c16 <sbrk>
  volatile char *top = sbrk(0);
    2f20:	4501                	li	a0,0
    2f22:	00003097          	auipc	ra,0x3
    2f26:	cf4080e7          	jalr	-780(ra) # 5c16 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f2a:	fff54783          	lbu	a5,-1(a0)
    2f2e:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    2f30:	0ff7f793          	zext.b	a5,a5
    2f34:	fef50fa3          	sb	a5,-1(a0)
}
    2f38:	60a2                	ld	ra,8(sp)
    2f3a:	6402                	ld	s0,0(sp)
    2f3c:	0141                	addi	sp,sp,16
    2f3e:	8082                	ret

0000000000002f40 <execout>:
{
    2f40:	715d                	addi	sp,sp,-80
    2f42:	e486                	sd	ra,72(sp)
    2f44:	e0a2                	sd	s0,64(sp)
    2f46:	fc26                	sd	s1,56(sp)
    2f48:	f84a                	sd	s2,48(sp)
    2f4a:	f44e                	sd	s3,40(sp)
    2f4c:	f052                	sd	s4,32(sp)
    2f4e:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f50:	4901                	li	s2,0
    2f52:	49bd                	li	s3,15
    int pid = fork();
    2f54:	00003097          	auipc	ra,0x3
    2f58:	c32080e7          	jalr	-974(ra) # 5b86 <fork>
    2f5c:	84aa                	mv	s1,a0
    if(pid < 0){
    2f5e:	02054063          	bltz	a0,2f7e <execout+0x3e>
    } else if(pid == 0){
    2f62:	c91d                	beqz	a0,2f98 <execout+0x58>
      wait((int*)0);
    2f64:	4501                	li	a0,0
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	c30080e7          	jalr	-976(ra) # 5b96 <wait>
  for(int avail = 0; avail < 15; avail++){
    2f6e:	2905                	addiw	s2,s2,1
    2f70:	ff3912e3          	bne	s2,s3,2f54 <execout+0x14>
  exit(0);
    2f74:	4501                	li	a0,0
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	c18080e7          	jalr	-1000(ra) # 5b8e <exit>
      printf("fork failed\n");
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	e2a50513          	addi	a0,a0,-470 # 6da8 <malloc+0xdd2>
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	f98080e7          	jalr	-104(ra) # 5f1e <printf>
      exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	00003097          	auipc	ra,0x3
    2f94:	bfe080e7          	jalr	-1026(ra) # 5b8e <exit>
        if(a == 0xffffffffffffffffLL)
    2f98:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2f9a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2f9c:	6505                	lui	a0,0x1
    2f9e:	00003097          	auipc	ra,0x3
    2fa2:	c78080e7          	jalr	-904(ra) # 5c16 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fa6:	01350763          	beq	a0,s3,2fb4 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2faa:	6785                	lui	a5,0x1
    2fac:	97aa                	add	a5,a5,a0
    2fae:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while(1){
    2fb2:	b7ed                	j	2f9c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fb4:	01205a63          	blez	s2,2fc8 <execout+0x88>
        sbrk(-4096);
    2fb8:	757d                	lui	a0,0xfffff
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	c5c080e7          	jalr	-932(ra) # 5c16 <sbrk>
      for(int i = 0; i < avail; i++)
    2fc2:	2485                	addiw	s1,s1,1
    2fc4:	ff249ae3          	bne	s1,s2,2fb8 <execout+0x78>
      close(1);
    2fc8:	4505                	li	a0,1
    2fca:	00003097          	auipc	ra,0x3
    2fce:	bec080e7          	jalr	-1044(ra) # 5bb6 <close>
      char *args[] = { "echo", "x", 0 };
    2fd2:	00003517          	auipc	a0,0x3
    2fd6:	14650513          	addi	a0,a0,326 # 6118 <malloc+0x142>
    2fda:	faa43c23          	sd	a0,-72(s0)
    2fde:	00003797          	auipc	a5,0x3
    2fe2:	1aa78793          	addi	a5,a5,426 # 6188 <malloc+0x1b2>
    2fe6:	fcf43023          	sd	a5,-64(s0)
    2fea:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2fee:	fb840593          	addi	a1,s0,-72
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	bd4080e7          	jalr	-1068(ra) # 5bc6 <exec>
      exit(0);
    2ffa:	4501                	li	a0,0
    2ffc:	00003097          	auipc	ra,0x3
    3000:	b92080e7          	jalr	-1134(ra) # 5b8e <exit>

0000000000003004 <fourteen>:
{
    3004:	1101                	addi	sp,sp,-32
    3006:	ec06                	sd	ra,24(sp)
    3008:	e822                	sd	s0,16(sp)
    300a:	e426                	sd	s1,8(sp)
    300c:	1000                	addi	s0,sp,32
    300e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3010:	00004517          	auipc	a0,0x4
    3014:	2a850513          	addi	a0,a0,680 # 72b8 <malloc+0x12e2>
    3018:	00003097          	auipc	ra,0x3
    301c:	bde080e7          	jalr	-1058(ra) # 5bf6 <mkdir>
    3020:	e165                	bnez	a0,3100 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3022:	00004517          	auipc	a0,0x4
    3026:	0ee50513          	addi	a0,a0,238 # 7110 <malloc+0x113a>
    302a:	00003097          	auipc	ra,0x3
    302e:	bcc080e7          	jalr	-1076(ra) # 5bf6 <mkdir>
    3032:	e56d                	bnez	a0,311c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3034:	20000593          	li	a1,512
    3038:	00004517          	auipc	a0,0x4
    303c:	13050513          	addi	a0,a0,304 # 7168 <malloc+0x1192>
    3040:	00003097          	auipc	ra,0x3
    3044:	b8e080e7          	jalr	-1138(ra) # 5bce <open>
  if(fd < 0){
    3048:	0e054863          	bltz	a0,3138 <fourteen+0x134>
  close(fd);
    304c:	00003097          	auipc	ra,0x3
    3050:	b6a080e7          	jalr	-1174(ra) # 5bb6 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3054:	4581                	li	a1,0
    3056:	00004517          	auipc	a0,0x4
    305a:	18a50513          	addi	a0,a0,394 # 71e0 <malloc+0x120a>
    305e:	00003097          	auipc	ra,0x3
    3062:	b70080e7          	jalr	-1168(ra) # 5bce <open>
  if(fd < 0){
    3066:	0e054763          	bltz	a0,3154 <fourteen+0x150>
  close(fd);
    306a:	00003097          	auipc	ra,0x3
    306e:	b4c080e7          	jalr	-1204(ra) # 5bb6 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3072:	00004517          	auipc	a0,0x4
    3076:	1de50513          	addi	a0,a0,478 # 7250 <malloc+0x127a>
    307a:	00003097          	auipc	ra,0x3
    307e:	b7c080e7          	jalr	-1156(ra) # 5bf6 <mkdir>
    3082:	c57d                	beqz	a0,3170 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    3084:	00004517          	auipc	a0,0x4
    3088:	22450513          	addi	a0,a0,548 # 72a8 <malloc+0x12d2>
    308c:	00003097          	auipc	ra,0x3
    3090:	b6a080e7          	jalr	-1174(ra) # 5bf6 <mkdir>
    3094:	cd65                	beqz	a0,318c <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3096:	00004517          	auipc	a0,0x4
    309a:	21250513          	addi	a0,a0,530 # 72a8 <malloc+0x12d2>
    309e:	00003097          	auipc	ra,0x3
    30a2:	b40080e7          	jalr	-1216(ra) # 5bde <unlink>
  unlink("12345678901234/12345678901234");
    30a6:	00004517          	auipc	a0,0x4
    30aa:	1aa50513          	addi	a0,a0,426 # 7250 <malloc+0x127a>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	b30080e7          	jalr	-1232(ra) # 5bde <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30b6:	00004517          	auipc	a0,0x4
    30ba:	12a50513          	addi	a0,a0,298 # 71e0 <malloc+0x120a>
    30be:	00003097          	auipc	ra,0x3
    30c2:	b20080e7          	jalr	-1248(ra) # 5bde <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30c6:	00004517          	auipc	a0,0x4
    30ca:	0a250513          	addi	a0,a0,162 # 7168 <malloc+0x1192>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	b10080e7          	jalr	-1264(ra) # 5bde <unlink>
  unlink("12345678901234/123456789012345");
    30d6:	00004517          	auipc	a0,0x4
    30da:	03a50513          	addi	a0,a0,58 # 7110 <malloc+0x113a>
    30de:	00003097          	auipc	ra,0x3
    30e2:	b00080e7          	jalr	-1280(ra) # 5bde <unlink>
  unlink("12345678901234");
    30e6:	00004517          	auipc	a0,0x4
    30ea:	1d250513          	addi	a0,a0,466 # 72b8 <malloc+0x12e2>
    30ee:	00003097          	auipc	ra,0x3
    30f2:	af0080e7          	jalr	-1296(ra) # 5bde <unlink>
}
    30f6:	60e2                	ld	ra,24(sp)
    30f8:	6442                	ld	s0,16(sp)
    30fa:	64a2                	ld	s1,8(sp)
    30fc:	6105                	addi	sp,sp,32
    30fe:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3100:	85a6                	mv	a1,s1
    3102:	00004517          	auipc	a0,0x4
    3106:	fe650513          	addi	a0,a0,-26 # 70e8 <malloc+0x1112>
    310a:	00003097          	auipc	ra,0x3
    310e:	e14080e7          	jalr	-492(ra) # 5f1e <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	00003097          	auipc	ra,0x3
    3118:	a7a080e7          	jalr	-1414(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    311c:	85a6                	mv	a1,s1
    311e:	00004517          	auipc	a0,0x4
    3122:	01250513          	addi	a0,a0,18 # 7130 <malloc+0x115a>
    3126:	00003097          	auipc	ra,0x3
    312a:	df8080e7          	jalr	-520(ra) # 5f1e <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00003097          	auipc	ra,0x3
    3134:	a5e080e7          	jalr	-1442(ra) # 5b8e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3138:	85a6                	mv	a1,s1
    313a:	00004517          	auipc	a0,0x4
    313e:	05e50513          	addi	a0,a0,94 # 7198 <malloc+0x11c2>
    3142:	00003097          	auipc	ra,0x3
    3146:	ddc080e7          	jalr	-548(ra) # 5f1e <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00003097          	auipc	ra,0x3
    3150:	a42080e7          	jalr	-1470(ra) # 5b8e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3154:	85a6                	mv	a1,s1
    3156:	00004517          	auipc	a0,0x4
    315a:	0ba50513          	addi	a0,a0,186 # 7210 <malloc+0x123a>
    315e:	00003097          	auipc	ra,0x3
    3162:	dc0080e7          	jalr	-576(ra) # 5f1e <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00003097          	auipc	ra,0x3
    316c:	a26080e7          	jalr	-1498(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	0fe50513          	addi	a0,a0,254 # 7270 <malloc+0x129a>
    317a:	00003097          	auipc	ra,0x3
    317e:	da4080e7          	jalr	-604(ra) # 5f1e <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	a0a080e7          	jalr	-1526(ra) # 5b8e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	13a50513          	addi	a0,a0,314 # 72c8 <malloc+0x12f2>
    3196:	00003097          	auipc	ra,0x3
    319a:	d88080e7          	jalr	-632(ra) # 5f1e <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	9ee080e7          	jalr	-1554(ra) # 5b8e <exit>

00000000000031a8 <diskfull>:
{
    31a8:	b9010113          	addi	sp,sp,-1136
    31ac:	46113423          	sd	ra,1128(sp)
    31b0:	46813023          	sd	s0,1120(sp)
    31b4:	44913c23          	sd	s1,1112(sp)
    31b8:	45213823          	sd	s2,1104(sp)
    31bc:	45313423          	sd	s3,1096(sp)
    31c0:	45413023          	sd	s4,1088(sp)
    31c4:	43513c23          	sd	s5,1080(sp)
    31c8:	43613823          	sd	s6,1072(sp)
    31cc:	43713423          	sd	s7,1064(sp)
    31d0:	43813023          	sd	s8,1056(sp)
    31d4:	47010413          	addi	s0,sp,1136
    31d8:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31da:	00004517          	auipc	a0,0x4
    31de:	12650513          	addi	a0,a0,294 # 7300 <malloc+0x132a>
    31e2:	00003097          	auipc	ra,0x3
    31e6:	9fc080e7          	jalr	-1540(ra) # 5bde <unlink>
  for(fi = 0; done == 0; fi++){
    31ea:	4a01                	li	s4,0
    name[0] = 'b';
    31ec:	06200b13          	li	s6,98
    name[1] = 'i';
    31f0:	06900a93          	li	s5,105
    name[2] = 'g';
    31f4:	06700993          	li	s3,103
    31f8:	10c00b93          	li	s7,268
    31fc:	aabd                	j	337a <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    31fe:	b9040613          	addi	a2,s0,-1136
    3202:	85e2                	mv	a1,s8
    3204:	00004517          	auipc	a0,0x4
    3208:	10c50513          	addi	a0,a0,268 # 7310 <malloc+0x133a>
    320c:	00003097          	auipc	ra,0x3
    3210:	d12080e7          	jalr	-750(ra) # 5f1e <printf>
      break;
    3214:	a821                	j	322c <diskfull+0x84>
        close(fd);
    3216:	854a                	mv	a0,s2
    3218:	00003097          	auipc	ra,0x3
    321c:	99e080e7          	jalr	-1634(ra) # 5bb6 <close>
    close(fd);
    3220:	854a                	mv	a0,s2
    3222:	00003097          	auipc	ra,0x3
    3226:	994080e7          	jalr	-1644(ra) # 5bb6 <close>
  for(fi = 0; done == 0; fi++){
    322a:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    322c:	4481                	li	s1,0
    name[0] = 'z';
    322e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3232:	08000993          	li	s3,128
    name[0] = 'z';
    3236:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    323a:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    323e:	41f4d71b          	sraiw	a4,s1,0x1f
    3242:	01b7571b          	srliw	a4,a4,0x1b
    3246:	009707bb          	addw	a5,a4,s1
    324a:	4057d69b          	sraiw	a3,a5,0x5
    324e:	0306869b          	addiw	a3,a3,48
    3252:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3256:	8bfd                	andi	a5,a5,31
    3258:	9f99                	subw	a5,a5,a4
    325a:	0307879b          	addiw	a5,a5,48
    325e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3262:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3266:	bb040513          	addi	a0,s0,-1104
    326a:	00003097          	auipc	ra,0x3
    326e:	974080e7          	jalr	-1676(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3272:	60200593          	li	a1,1538
    3276:	bb040513          	addi	a0,s0,-1104
    327a:	00003097          	auipc	ra,0x3
    327e:	954080e7          	jalr	-1708(ra) # 5bce <open>
    if(fd < 0)
    3282:	00054963          	bltz	a0,3294 <diskfull+0xec>
    close(fd);
    3286:	00003097          	auipc	ra,0x3
    328a:	930080e7          	jalr	-1744(ra) # 5bb6 <close>
  for(int i = 0; i < nzz; i++){
    328e:	2485                	addiw	s1,s1,1
    3290:	fb3493e3          	bne	s1,s3,3236 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3294:	00004517          	auipc	a0,0x4
    3298:	06c50513          	addi	a0,a0,108 # 7300 <malloc+0x132a>
    329c:	00003097          	auipc	ra,0x3
    32a0:	95a080e7          	jalr	-1702(ra) # 5bf6 <mkdir>
    32a4:	12050963          	beqz	a0,33d6 <diskfull+0x22e>
  unlink("diskfulldir");
    32a8:	00004517          	auipc	a0,0x4
    32ac:	05850513          	addi	a0,a0,88 # 7300 <malloc+0x132a>
    32b0:	00003097          	auipc	ra,0x3
    32b4:	92e080e7          	jalr	-1746(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
    32b8:	4481                	li	s1,0
    name[0] = 'z';
    32ba:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32be:	08000993          	li	s3,128
    name[0] = 'z';
    32c2:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32c6:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ca:	41f4d71b          	sraiw	a4,s1,0x1f
    32ce:	01b7571b          	srliw	a4,a4,0x1b
    32d2:	009707bb          	addw	a5,a4,s1
    32d6:	4057d69b          	sraiw	a3,a5,0x5
    32da:	0306869b          	addiw	a3,a3,48
    32de:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    32e2:	8bfd                	andi	a5,a5,31
    32e4:	9f99                	subw	a5,a5,a4
    32e6:	0307879b          	addiw	a5,a5,48
    32ea:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32ee:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32f2:	bb040513          	addi	a0,s0,-1104
    32f6:	00003097          	auipc	ra,0x3
    32fa:	8e8080e7          	jalr	-1816(ra) # 5bde <unlink>
  for(int i = 0; i < nzz; i++){
    32fe:	2485                	addiw	s1,s1,1
    3300:	fd3491e3          	bne	s1,s3,32c2 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3304:	03405e63          	blez	s4,3340 <diskfull+0x198>
    3308:	4481                	li	s1,0
    name[0] = 'b';
    330a:	06200a93          	li	s5,98
    name[1] = 'i';
    330e:	06900993          	li	s3,105
    name[2] = 'g';
    3312:	06700913          	li	s2,103
    name[0] = 'b';
    3316:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    331a:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    331e:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3322:	0304879b          	addiw	a5,s1,48
    3326:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    332a:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    332e:	bb040513          	addi	a0,s0,-1104
    3332:	00003097          	auipc	ra,0x3
    3336:	8ac080e7          	jalr	-1876(ra) # 5bde <unlink>
  for(int i = 0; i < fi; i++){
    333a:	2485                	addiw	s1,s1,1
    333c:	fd449de3          	bne	s1,s4,3316 <diskfull+0x16e>
}
    3340:	46813083          	ld	ra,1128(sp)
    3344:	46013403          	ld	s0,1120(sp)
    3348:	45813483          	ld	s1,1112(sp)
    334c:	45013903          	ld	s2,1104(sp)
    3350:	44813983          	ld	s3,1096(sp)
    3354:	44013a03          	ld	s4,1088(sp)
    3358:	43813a83          	ld	s5,1080(sp)
    335c:	43013b03          	ld	s6,1072(sp)
    3360:	42813b83          	ld	s7,1064(sp)
    3364:	42013c03          	ld	s8,1056(sp)
    3368:	47010113          	addi	sp,sp,1136
    336c:	8082                	ret
    close(fd);
    336e:	854a                	mv	a0,s2
    3370:	00003097          	auipc	ra,0x3
    3374:	846080e7          	jalr	-1978(ra) # 5bb6 <close>
  for(fi = 0; done == 0; fi++){
    3378:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    337a:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    337e:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3382:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3386:	030a079b          	addiw	a5,s4,48
    338a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    338e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3392:	b9040513          	addi	a0,s0,-1136
    3396:	00003097          	auipc	ra,0x3
    339a:	848080e7          	jalr	-1976(ra) # 5bde <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    339e:	60200593          	li	a1,1538
    33a2:	b9040513          	addi	a0,s0,-1136
    33a6:	00003097          	auipc	ra,0x3
    33aa:	828080e7          	jalr	-2008(ra) # 5bce <open>
    33ae:	892a                	mv	s2,a0
    if(fd < 0){
    33b0:	e40547e3          	bltz	a0,31fe <diskfull+0x56>
    33b4:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33b6:	40000613          	li	a2,1024
    33ba:	bb040593          	addi	a1,s0,-1104
    33be:	854a                	mv	a0,s2
    33c0:	00002097          	auipc	ra,0x2
    33c4:	7ee080e7          	jalr	2030(ra) # 5bae <write>
    33c8:	40000793          	li	a5,1024
    33cc:	e4f515e3          	bne	a0,a5,3216 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    33d0:	34fd                	addiw	s1,s1,-1
    33d2:	f0f5                	bnez	s1,33b6 <diskfull+0x20e>
    33d4:	bf69                	j	336e <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33d6:	00004517          	auipc	a0,0x4
    33da:	f5a50513          	addi	a0,a0,-166 # 7330 <malloc+0x135a>
    33de:	00003097          	auipc	ra,0x3
    33e2:	b40080e7          	jalr	-1216(ra) # 5f1e <printf>
    33e6:	b5c9                	j	32a8 <diskfull+0x100>

00000000000033e8 <iputtest>:
{
    33e8:	1101                	addi	sp,sp,-32
    33ea:	ec06                	sd	ra,24(sp)
    33ec:	e822                	sd	s0,16(sp)
    33ee:	e426                	sd	s1,8(sp)
    33f0:	1000                	addi	s0,sp,32
    33f2:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    33f4:	00004517          	auipc	a0,0x4
    33f8:	f6c50513          	addi	a0,a0,-148 # 7360 <malloc+0x138a>
    33fc:	00002097          	auipc	ra,0x2
    3400:	7fa080e7          	jalr	2042(ra) # 5bf6 <mkdir>
    3404:	04054563          	bltz	a0,344e <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3408:	00004517          	auipc	a0,0x4
    340c:	f5850513          	addi	a0,a0,-168 # 7360 <malloc+0x138a>
    3410:	00002097          	auipc	ra,0x2
    3414:	7ee080e7          	jalr	2030(ra) # 5bfe <chdir>
    3418:	04054963          	bltz	a0,346a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    341c:	00004517          	auipc	a0,0x4
    3420:	f8450513          	addi	a0,a0,-124 # 73a0 <malloc+0x13ca>
    3424:	00002097          	auipc	ra,0x2
    3428:	7ba080e7          	jalr	1978(ra) # 5bde <unlink>
    342c:	04054d63          	bltz	a0,3486 <iputtest+0x9e>
  if(chdir("/") < 0){
    3430:	00004517          	auipc	a0,0x4
    3434:	fa050513          	addi	a0,a0,-96 # 73d0 <malloc+0x13fa>
    3438:	00002097          	auipc	ra,0x2
    343c:	7c6080e7          	jalr	1990(ra) # 5bfe <chdir>
    3440:	06054163          	bltz	a0,34a2 <iputtest+0xba>
}
    3444:	60e2                	ld	ra,24(sp)
    3446:	6442                	ld	s0,16(sp)
    3448:	64a2                	ld	s1,8(sp)
    344a:	6105                	addi	sp,sp,32
    344c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    344e:	85a6                	mv	a1,s1
    3450:	00004517          	auipc	a0,0x4
    3454:	f1850513          	addi	a0,a0,-232 # 7368 <malloc+0x1392>
    3458:	00003097          	auipc	ra,0x3
    345c:	ac6080e7          	jalr	-1338(ra) # 5f1e <printf>
    exit(1);
    3460:	4505                	li	a0,1
    3462:	00002097          	auipc	ra,0x2
    3466:	72c080e7          	jalr	1836(ra) # 5b8e <exit>
    printf("%s: chdir iputdir failed\n", s);
    346a:	85a6                	mv	a1,s1
    346c:	00004517          	auipc	a0,0x4
    3470:	f1450513          	addi	a0,a0,-236 # 7380 <malloc+0x13aa>
    3474:	00003097          	auipc	ra,0x3
    3478:	aaa080e7          	jalr	-1366(ra) # 5f1e <printf>
    exit(1);
    347c:	4505                	li	a0,1
    347e:	00002097          	auipc	ra,0x2
    3482:	710080e7          	jalr	1808(ra) # 5b8e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3486:	85a6                	mv	a1,s1
    3488:	00004517          	auipc	a0,0x4
    348c:	f2850513          	addi	a0,a0,-216 # 73b0 <malloc+0x13da>
    3490:	00003097          	auipc	ra,0x3
    3494:	a8e080e7          	jalr	-1394(ra) # 5f1e <printf>
    exit(1);
    3498:	4505                	li	a0,1
    349a:	00002097          	auipc	ra,0x2
    349e:	6f4080e7          	jalr	1780(ra) # 5b8e <exit>
    printf("%s: chdir / failed\n", s);
    34a2:	85a6                	mv	a1,s1
    34a4:	00004517          	auipc	a0,0x4
    34a8:	f3450513          	addi	a0,a0,-204 # 73d8 <malloc+0x1402>
    34ac:	00003097          	auipc	ra,0x3
    34b0:	a72080e7          	jalr	-1422(ra) # 5f1e <printf>
    exit(1);
    34b4:	4505                	li	a0,1
    34b6:	00002097          	auipc	ra,0x2
    34ba:	6d8080e7          	jalr	1752(ra) # 5b8e <exit>

00000000000034be <exitiputtest>:
{
    34be:	7179                	addi	sp,sp,-48
    34c0:	f406                	sd	ra,40(sp)
    34c2:	f022                	sd	s0,32(sp)
    34c4:	ec26                	sd	s1,24(sp)
    34c6:	1800                	addi	s0,sp,48
    34c8:	84aa                	mv	s1,a0
  pid = fork();
    34ca:	00002097          	auipc	ra,0x2
    34ce:	6bc080e7          	jalr	1724(ra) # 5b86 <fork>
  if(pid < 0){
    34d2:	04054663          	bltz	a0,351e <exitiputtest+0x60>
  if(pid == 0){
    34d6:	ed45                	bnez	a0,358e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34d8:	00004517          	auipc	a0,0x4
    34dc:	e8850513          	addi	a0,a0,-376 # 7360 <malloc+0x138a>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	716080e7          	jalr	1814(ra) # 5bf6 <mkdir>
    34e8:	04054963          	bltz	a0,353a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    34ec:	00004517          	auipc	a0,0x4
    34f0:	e7450513          	addi	a0,a0,-396 # 7360 <malloc+0x138a>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	70a080e7          	jalr	1802(ra) # 5bfe <chdir>
    34fc:	04054d63          	bltz	a0,3556 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3500:	00004517          	auipc	a0,0x4
    3504:	ea050513          	addi	a0,a0,-352 # 73a0 <malloc+0x13ca>
    3508:	00002097          	auipc	ra,0x2
    350c:	6d6080e7          	jalr	1750(ra) # 5bde <unlink>
    3510:	06054163          	bltz	a0,3572 <exitiputtest+0xb4>
    exit(0);
    3514:	4501                	li	a0,0
    3516:	00002097          	auipc	ra,0x2
    351a:	678080e7          	jalr	1656(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    351e:	85a6                	mv	a1,s1
    3520:	00003517          	auipc	a0,0x3
    3524:	48050513          	addi	a0,a0,1152 # 69a0 <malloc+0x9ca>
    3528:	00003097          	auipc	ra,0x3
    352c:	9f6080e7          	jalr	-1546(ra) # 5f1e <printf>
    exit(1);
    3530:	4505                	li	a0,1
    3532:	00002097          	auipc	ra,0x2
    3536:	65c080e7          	jalr	1628(ra) # 5b8e <exit>
      printf("%s: mkdir failed\n", s);
    353a:	85a6                	mv	a1,s1
    353c:	00004517          	auipc	a0,0x4
    3540:	e2c50513          	addi	a0,a0,-468 # 7368 <malloc+0x1392>
    3544:	00003097          	auipc	ra,0x3
    3548:	9da080e7          	jalr	-1574(ra) # 5f1e <printf>
      exit(1);
    354c:	4505                	li	a0,1
    354e:	00002097          	auipc	ra,0x2
    3552:	640080e7          	jalr	1600(ra) # 5b8e <exit>
      printf("%s: child chdir failed\n", s);
    3556:	85a6                	mv	a1,s1
    3558:	00004517          	auipc	a0,0x4
    355c:	e9850513          	addi	a0,a0,-360 # 73f0 <malloc+0x141a>
    3560:	00003097          	auipc	ra,0x3
    3564:	9be080e7          	jalr	-1602(ra) # 5f1e <printf>
      exit(1);
    3568:	4505                	li	a0,1
    356a:	00002097          	auipc	ra,0x2
    356e:	624080e7          	jalr	1572(ra) # 5b8e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3572:	85a6                	mv	a1,s1
    3574:	00004517          	auipc	a0,0x4
    3578:	e3c50513          	addi	a0,a0,-452 # 73b0 <malloc+0x13da>
    357c:	00003097          	auipc	ra,0x3
    3580:	9a2080e7          	jalr	-1630(ra) # 5f1e <printf>
      exit(1);
    3584:	4505                	li	a0,1
    3586:	00002097          	auipc	ra,0x2
    358a:	608080e7          	jalr	1544(ra) # 5b8e <exit>
  wait(&xstatus);
    358e:	fdc40513          	addi	a0,s0,-36
    3592:	00002097          	auipc	ra,0x2
    3596:	604080e7          	jalr	1540(ra) # 5b96 <wait>
  exit(xstatus);
    359a:	fdc42503          	lw	a0,-36(s0)
    359e:	00002097          	auipc	ra,0x2
    35a2:	5f0080e7          	jalr	1520(ra) # 5b8e <exit>

00000000000035a6 <dirtest>:
{
    35a6:	1101                	addi	sp,sp,-32
    35a8:	ec06                	sd	ra,24(sp)
    35aa:	e822                	sd	s0,16(sp)
    35ac:	e426                	sd	s1,8(sp)
    35ae:	1000                	addi	s0,sp,32
    35b0:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35b2:	00004517          	auipc	a0,0x4
    35b6:	e5650513          	addi	a0,a0,-426 # 7408 <malloc+0x1432>
    35ba:	00002097          	auipc	ra,0x2
    35be:	63c080e7          	jalr	1596(ra) # 5bf6 <mkdir>
    35c2:	04054563          	bltz	a0,360c <dirtest+0x66>
  if(chdir("dir0") < 0){
    35c6:	00004517          	auipc	a0,0x4
    35ca:	e4250513          	addi	a0,a0,-446 # 7408 <malloc+0x1432>
    35ce:	00002097          	auipc	ra,0x2
    35d2:	630080e7          	jalr	1584(ra) # 5bfe <chdir>
    35d6:	04054963          	bltz	a0,3628 <dirtest+0x82>
  if(chdir("..") < 0){
    35da:	00004517          	auipc	a0,0x4
    35de:	e4e50513          	addi	a0,a0,-434 # 7428 <malloc+0x1452>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	61c080e7          	jalr	1564(ra) # 5bfe <chdir>
    35ea:	04054d63          	bltz	a0,3644 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    35ee:	00004517          	auipc	a0,0x4
    35f2:	e1a50513          	addi	a0,a0,-486 # 7408 <malloc+0x1432>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	5e8080e7          	jalr	1512(ra) # 5bde <unlink>
    35fe:	06054163          	bltz	a0,3660 <dirtest+0xba>
}
    3602:	60e2                	ld	ra,24(sp)
    3604:	6442                	ld	s0,16(sp)
    3606:	64a2                	ld	s1,8(sp)
    3608:	6105                	addi	sp,sp,32
    360a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    360c:	85a6                	mv	a1,s1
    360e:	00004517          	auipc	a0,0x4
    3612:	d5a50513          	addi	a0,a0,-678 # 7368 <malloc+0x1392>
    3616:	00003097          	auipc	ra,0x3
    361a:	908080e7          	jalr	-1784(ra) # 5f1e <printf>
    exit(1);
    361e:	4505                	li	a0,1
    3620:	00002097          	auipc	ra,0x2
    3624:	56e080e7          	jalr	1390(ra) # 5b8e <exit>
    printf("%s: chdir dir0 failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00004517          	auipc	a0,0x4
    362e:	de650513          	addi	a0,a0,-538 # 7410 <malloc+0x143a>
    3632:	00003097          	auipc	ra,0x3
    3636:	8ec080e7          	jalr	-1812(ra) # 5f1e <printf>
    exit(1);
    363a:	4505                	li	a0,1
    363c:	00002097          	auipc	ra,0x2
    3640:	552080e7          	jalr	1362(ra) # 5b8e <exit>
    printf("%s: chdir .. failed\n", s);
    3644:	85a6                	mv	a1,s1
    3646:	00004517          	auipc	a0,0x4
    364a:	dea50513          	addi	a0,a0,-534 # 7430 <malloc+0x145a>
    364e:	00003097          	auipc	ra,0x3
    3652:	8d0080e7          	jalr	-1840(ra) # 5f1e <printf>
    exit(1);
    3656:	4505                	li	a0,1
    3658:	00002097          	auipc	ra,0x2
    365c:	536080e7          	jalr	1334(ra) # 5b8e <exit>
    printf("%s: unlink dir0 failed\n", s);
    3660:	85a6                	mv	a1,s1
    3662:	00004517          	auipc	a0,0x4
    3666:	de650513          	addi	a0,a0,-538 # 7448 <malloc+0x1472>
    366a:	00003097          	auipc	ra,0x3
    366e:	8b4080e7          	jalr	-1868(ra) # 5f1e <printf>
    exit(1);
    3672:	4505                	li	a0,1
    3674:	00002097          	auipc	ra,0x2
    3678:	51a080e7          	jalr	1306(ra) # 5b8e <exit>

000000000000367c <subdir>:
{
    367c:	1101                	addi	sp,sp,-32
    367e:	ec06                	sd	ra,24(sp)
    3680:	e822                	sd	s0,16(sp)
    3682:	e426                	sd	s1,8(sp)
    3684:	e04a                	sd	s2,0(sp)
    3686:	1000                	addi	s0,sp,32
    3688:	892a                	mv	s2,a0
  unlink("ff");
    368a:	00004517          	auipc	a0,0x4
    368e:	f0650513          	addi	a0,a0,-250 # 7590 <malloc+0x15ba>
    3692:	00002097          	auipc	ra,0x2
    3696:	54c080e7          	jalr	1356(ra) # 5bde <unlink>
  if(mkdir("dd") != 0){
    369a:	00004517          	auipc	a0,0x4
    369e:	dc650513          	addi	a0,a0,-570 # 7460 <malloc+0x148a>
    36a2:	00002097          	auipc	ra,0x2
    36a6:	554080e7          	jalr	1364(ra) # 5bf6 <mkdir>
    36aa:	38051663          	bnez	a0,3a36 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36ae:	20200593          	li	a1,514
    36b2:	00004517          	auipc	a0,0x4
    36b6:	dce50513          	addi	a0,a0,-562 # 7480 <malloc+0x14aa>
    36ba:	00002097          	auipc	ra,0x2
    36be:	514080e7          	jalr	1300(ra) # 5bce <open>
    36c2:	84aa                	mv	s1,a0
  if(fd < 0){
    36c4:	38054763          	bltz	a0,3a52 <subdir+0x3d6>
  write(fd, "ff", 2);
    36c8:	4609                	li	a2,2
    36ca:	00004597          	auipc	a1,0x4
    36ce:	ec658593          	addi	a1,a1,-314 # 7590 <malloc+0x15ba>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	4dc080e7          	jalr	1244(ra) # 5bae <write>
  close(fd);
    36da:	8526                	mv	a0,s1
    36dc:	00002097          	auipc	ra,0x2
    36e0:	4da080e7          	jalr	1242(ra) # 5bb6 <close>
  if(unlink("dd") >= 0){
    36e4:	00004517          	auipc	a0,0x4
    36e8:	d7c50513          	addi	a0,a0,-644 # 7460 <malloc+0x148a>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	4f2080e7          	jalr	1266(ra) # 5bde <unlink>
    36f4:	36055d63          	bgez	a0,3a6e <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    36f8:	00004517          	auipc	a0,0x4
    36fc:	de050513          	addi	a0,a0,-544 # 74d8 <malloc+0x1502>
    3700:	00002097          	auipc	ra,0x2
    3704:	4f6080e7          	jalr	1270(ra) # 5bf6 <mkdir>
    3708:	38051163          	bnez	a0,3a8a <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    370c:	20200593          	li	a1,514
    3710:	00004517          	auipc	a0,0x4
    3714:	df050513          	addi	a0,a0,-528 # 7500 <malloc+0x152a>
    3718:	00002097          	auipc	ra,0x2
    371c:	4b6080e7          	jalr	1206(ra) # 5bce <open>
    3720:	84aa                	mv	s1,a0
  if(fd < 0){
    3722:	38054263          	bltz	a0,3aa6 <subdir+0x42a>
  write(fd, "FF", 2);
    3726:	4609                	li	a2,2
    3728:	00004597          	auipc	a1,0x4
    372c:	e0858593          	addi	a1,a1,-504 # 7530 <malloc+0x155a>
    3730:	00002097          	auipc	ra,0x2
    3734:	47e080e7          	jalr	1150(ra) # 5bae <write>
  close(fd);
    3738:	8526                	mv	a0,s1
    373a:	00002097          	auipc	ra,0x2
    373e:	47c080e7          	jalr	1148(ra) # 5bb6 <close>
  fd = open("dd/dd/../ff", 0);
    3742:	4581                	li	a1,0
    3744:	00004517          	auipc	a0,0x4
    3748:	df450513          	addi	a0,a0,-524 # 7538 <malloc+0x1562>
    374c:	00002097          	auipc	ra,0x2
    3750:	482080e7          	jalr	1154(ra) # 5bce <open>
    3754:	84aa                	mv	s1,a0
  if(fd < 0){
    3756:	36054663          	bltz	a0,3ac2 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    375a:	660d                	lui	a2,0x3
    375c:	0000b597          	auipc	a1,0xb
    3760:	86c58593          	addi	a1,a1,-1940 # dfc8 <buf>
    3764:	00002097          	auipc	ra,0x2
    3768:	442080e7          	jalr	1090(ra) # 5ba6 <read>
  if(cc != 2 || buf[0] != 'f'){
    376c:	4789                	li	a5,2
    376e:	36f51863          	bne	a0,a5,3ade <subdir+0x462>
    3772:	0000b717          	auipc	a4,0xb
    3776:	85674703          	lbu	a4,-1962(a4) # dfc8 <buf>
    377a:	06600793          	li	a5,102
    377e:	36f71063          	bne	a4,a5,3ade <subdir+0x462>
  close(fd);
    3782:	8526                	mv	a0,s1
    3784:	00002097          	auipc	ra,0x2
    3788:	432080e7          	jalr	1074(ra) # 5bb6 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    378c:	00004597          	auipc	a1,0x4
    3790:	dfc58593          	addi	a1,a1,-516 # 7588 <malloc+0x15b2>
    3794:	00004517          	auipc	a0,0x4
    3798:	d6c50513          	addi	a0,a0,-660 # 7500 <malloc+0x152a>
    379c:	00002097          	auipc	ra,0x2
    37a0:	452080e7          	jalr	1106(ra) # 5bee <link>
    37a4:	34051b63          	bnez	a0,3afa <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37a8:	00004517          	auipc	a0,0x4
    37ac:	d5850513          	addi	a0,a0,-680 # 7500 <malloc+0x152a>
    37b0:	00002097          	auipc	ra,0x2
    37b4:	42e080e7          	jalr	1070(ra) # 5bde <unlink>
    37b8:	34051f63          	bnez	a0,3b16 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37bc:	4581                	li	a1,0
    37be:	00004517          	auipc	a0,0x4
    37c2:	d4250513          	addi	a0,a0,-702 # 7500 <malloc+0x152a>
    37c6:	00002097          	auipc	ra,0x2
    37ca:	408080e7          	jalr	1032(ra) # 5bce <open>
    37ce:	36055263          	bgez	a0,3b32 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37d2:	00004517          	auipc	a0,0x4
    37d6:	c8e50513          	addi	a0,a0,-882 # 7460 <malloc+0x148a>
    37da:	00002097          	auipc	ra,0x2
    37de:	424080e7          	jalr	1060(ra) # 5bfe <chdir>
    37e2:	36051663          	bnez	a0,3b4e <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    37e6:	00004517          	auipc	a0,0x4
    37ea:	e3a50513          	addi	a0,a0,-454 # 7620 <malloc+0x164a>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	410080e7          	jalr	1040(ra) # 5bfe <chdir>
    37f6:	36051a63          	bnez	a0,3b6a <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    37fa:	00004517          	auipc	a0,0x4
    37fe:	e5650513          	addi	a0,a0,-426 # 7650 <malloc+0x167a>
    3802:	00002097          	auipc	ra,0x2
    3806:	3fc080e7          	jalr	1020(ra) # 5bfe <chdir>
    380a:	36051e63          	bnez	a0,3b86 <subdir+0x50a>
  if(chdir("./..") != 0){
    380e:	00004517          	auipc	a0,0x4
    3812:	e7250513          	addi	a0,a0,-398 # 7680 <malloc+0x16aa>
    3816:	00002097          	auipc	ra,0x2
    381a:	3e8080e7          	jalr	1000(ra) # 5bfe <chdir>
    381e:	38051263          	bnez	a0,3ba2 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3822:	4581                	li	a1,0
    3824:	00004517          	auipc	a0,0x4
    3828:	d6450513          	addi	a0,a0,-668 # 7588 <malloc+0x15b2>
    382c:	00002097          	auipc	ra,0x2
    3830:	3a2080e7          	jalr	930(ra) # 5bce <open>
    3834:	84aa                	mv	s1,a0
  if(fd < 0){
    3836:	38054463          	bltz	a0,3bbe <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    383a:	660d                	lui	a2,0x3
    383c:	0000a597          	auipc	a1,0xa
    3840:	78c58593          	addi	a1,a1,1932 # dfc8 <buf>
    3844:	00002097          	auipc	ra,0x2
    3848:	362080e7          	jalr	866(ra) # 5ba6 <read>
    384c:	4789                	li	a5,2
    384e:	38f51663          	bne	a0,a5,3bda <subdir+0x55e>
  close(fd);
    3852:	8526                	mv	a0,s1
    3854:	00002097          	auipc	ra,0x2
    3858:	362080e7          	jalr	866(ra) # 5bb6 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    385c:	4581                	li	a1,0
    385e:	00004517          	auipc	a0,0x4
    3862:	ca250513          	addi	a0,a0,-862 # 7500 <malloc+0x152a>
    3866:	00002097          	auipc	ra,0x2
    386a:	368080e7          	jalr	872(ra) # 5bce <open>
    386e:	38055463          	bgez	a0,3bf6 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3872:	20200593          	li	a1,514
    3876:	00004517          	auipc	a0,0x4
    387a:	e9a50513          	addi	a0,a0,-358 # 7710 <malloc+0x173a>
    387e:	00002097          	auipc	ra,0x2
    3882:	350080e7          	jalr	848(ra) # 5bce <open>
    3886:	38055663          	bgez	a0,3c12 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    388a:	20200593          	li	a1,514
    388e:	00004517          	auipc	a0,0x4
    3892:	eb250513          	addi	a0,a0,-334 # 7740 <malloc+0x176a>
    3896:	00002097          	auipc	ra,0x2
    389a:	338080e7          	jalr	824(ra) # 5bce <open>
    389e:	38055863          	bgez	a0,3c2e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38a2:	20000593          	li	a1,512
    38a6:	00004517          	auipc	a0,0x4
    38aa:	bba50513          	addi	a0,a0,-1094 # 7460 <malloc+0x148a>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	320080e7          	jalr	800(ra) # 5bce <open>
    38b6:	38055a63          	bgez	a0,3c4a <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38ba:	4589                	li	a1,2
    38bc:	00004517          	auipc	a0,0x4
    38c0:	ba450513          	addi	a0,a0,-1116 # 7460 <malloc+0x148a>
    38c4:	00002097          	auipc	ra,0x2
    38c8:	30a080e7          	jalr	778(ra) # 5bce <open>
    38cc:	38055d63          	bgez	a0,3c66 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38d0:	4585                	li	a1,1
    38d2:	00004517          	auipc	a0,0x4
    38d6:	b8e50513          	addi	a0,a0,-1138 # 7460 <malloc+0x148a>
    38da:	00002097          	auipc	ra,0x2
    38de:	2f4080e7          	jalr	756(ra) # 5bce <open>
    38e2:	3a055063          	bgez	a0,3c82 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    38e6:	00004597          	auipc	a1,0x4
    38ea:	eea58593          	addi	a1,a1,-278 # 77d0 <malloc+0x17fa>
    38ee:	00004517          	auipc	a0,0x4
    38f2:	e2250513          	addi	a0,a0,-478 # 7710 <malloc+0x173a>
    38f6:	00002097          	auipc	ra,0x2
    38fa:	2f8080e7          	jalr	760(ra) # 5bee <link>
    38fe:	3a050063          	beqz	a0,3c9e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3902:	00004597          	auipc	a1,0x4
    3906:	ece58593          	addi	a1,a1,-306 # 77d0 <malloc+0x17fa>
    390a:	00004517          	auipc	a0,0x4
    390e:	e3650513          	addi	a0,a0,-458 # 7740 <malloc+0x176a>
    3912:	00002097          	auipc	ra,0x2
    3916:	2dc080e7          	jalr	732(ra) # 5bee <link>
    391a:	3a050063          	beqz	a0,3cba <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    391e:	00004597          	auipc	a1,0x4
    3922:	c6a58593          	addi	a1,a1,-918 # 7588 <malloc+0x15b2>
    3926:	00004517          	auipc	a0,0x4
    392a:	b5a50513          	addi	a0,a0,-1190 # 7480 <malloc+0x14aa>
    392e:	00002097          	auipc	ra,0x2
    3932:	2c0080e7          	jalr	704(ra) # 5bee <link>
    3936:	3a050063          	beqz	a0,3cd6 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    393a:	00004517          	auipc	a0,0x4
    393e:	dd650513          	addi	a0,a0,-554 # 7710 <malloc+0x173a>
    3942:	00002097          	auipc	ra,0x2
    3946:	2b4080e7          	jalr	692(ra) # 5bf6 <mkdir>
    394a:	3a050463          	beqz	a0,3cf2 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    394e:	00004517          	auipc	a0,0x4
    3952:	df250513          	addi	a0,a0,-526 # 7740 <malloc+0x176a>
    3956:	00002097          	auipc	ra,0x2
    395a:	2a0080e7          	jalr	672(ra) # 5bf6 <mkdir>
    395e:	3a050863          	beqz	a0,3d0e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3962:	00004517          	auipc	a0,0x4
    3966:	c2650513          	addi	a0,a0,-986 # 7588 <malloc+0x15b2>
    396a:	00002097          	auipc	ra,0x2
    396e:	28c080e7          	jalr	652(ra) # 5bf6 <mkdir>
    3972:	3a050c63          	beqz	a0,3d2a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3976:	00004517          	auipc	a0,0x4
    397a:	dca50513          	addi	a0,a0,-566 # 7740 <malloc+0x176a>
    397e:	00002097          	auipc	ra,0x2
    3982:	260080e7          	jalr	608(ra) # 5bde <unlink>
    3986:	3c050063          	beqz	a0,3d46 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    398a:	00004517          	auipc	a0,0x4
    398e:	d8650513          	addi	a0,a0,-634 # 7710 <malloc+0x173a>
    3992:	00002097          	auipc	ra,0x2
    3996:	24c080e7          	jalr	588(ra) # 5bde <unlink>
    399a:	3c050463          	beqz	a0,3d62 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    399e:	00004517          	auipc	a0,0x4
    39a2:	ae250513          	addi	a0,a0,-1310 # 7480 <malloc+0x14aa>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	258080e7          	jalr	600(ra) # 5bfe <chdir>
    39ae:	3c050863          	beqz	a0,3d7e <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39b2:	00004517          	auipc	a0,0x4
    39b6:	f6e50513          	addi	a0,a0,-146 # 7920 <malloc+0x194a>
    39ba:	00002097          	auipc	ra,0x2
    39be:	244080e7          	jalr	580(ra) # 5bfe <chdir>
    39c2:	3c050c63          	beqz	a0,3d9a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39c6:	00004517          	auipc	a0,0x4
    39ca:	bc250513          	addi	a0,a0,-1086 # 7588 <malloc+0x15b2>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	210080e7          	jalr	528(ra) # 5bde <unlink>
    39d6:	3e051063          	bnez	a0,3db6 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	aa650513          	addi	a0,a0,-1370 # 7480 <malloc+0x14aa>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	1fc080e7          	jalr	508(ra) # 5bde <unlink>
    39ea:	3e051463          	bnez	a0,3dd2 <subdir+0x756>
  if(unlink("dd") == 0){
    39ee:	00004517          	auipc	a0,0x4
    39f2:	a7250513          	addi	a0,a0,-1422 # 7460 <malloc+0x148a>
    39f6:	00002097          	auipc	ra,0x2
    39fa:	1e8080e7          	jalr	488(ra) # 5bde <unlink>
    39fe:	3e050863          	beqz	a0,3dee <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a02:	00004517          	auipc	a0,0x4
    3a06:	f8e50513          	addi	a0,a0,-114 # 7990 <malloc+0x19ba>
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	1d4080e7          	jalr	468(ra) # 5bde <unlink>
    3a12:	3e054c63          	bltz	a0,3e0a <subdir+0x78e>
  if(unlink("dd") < 0){
    3a16:	00004517          	auipc	a0,0x4
    3a1a:	a4a50513          	addi	a0,a0,-1462 # 7460 <malloc+0x148a>
    3a1e:	00002097          	auipc	ra,0x2
    3a22:	1c0080e7          	jalr	448(ra) # 5bde <unlink>
    3a26:	40054063          	bltz	a0,3e26 <subdir+0x7aa>
}
    3a2a:	60e2                	ld	ra,24(sp)
    3a2c:	6442                	ld	s0,16(sp)
    3a2e:	64a2                	ld	s1,8(sp)
    3a30:	6902                	ld	s2,0(sp)
    3a32:	6105                	addi	sp,sp,32
    3a34:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a36:	85ca                	mv	a1,s2
    3a38:	00004517          	auipc	a0,0x4
    3a3c:	a3050513          	addi	a0,a0,-1488 # 7468 <malloc+0x1492>
    3a40:	00002097          	auipc	ra,0x2
    3a44:	4de080e7          	jalr	1246(ra) # 5f1e <printf>
    exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	144080e7          	jalr	324(ra) # 5b8e <exit>
    printf("%s: create dd/ff failed\n", s);
    3a52:	85ca                	mv	a1,s2
    3a54:	00004517          	auipc	a0,0x4
    3a58:	a3450513          	addi	a0,a0,-1484 # 7488 <malloc+0x14b2>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	4c2080e7          	jalr	1218(ra) # 5f1e <printf>
    exit(1);
    3a64:	4505                	li	a0,1
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	128080e7          	jalr	296(ra) # 5b8e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a6e:	85ca                	mv	a1,s2
    3a70:	00004517          	auipc	a0,0x4
    3a74:	a3850513          	addi	a0,a0,-1480 # 74a8 <malloc+0x14d2>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	4a6080e7          	jalr	1190(ra) # 5f1e <printf>
    exit(1);
    3a80:	4505                	li	a0,1
    3a82:	00002097          	auipc	ra,0x2
    3a86:	10c080e7          	jalr	268(ra) # 5b8e <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3a8a:	85ca                	mv	a1,s2
    3a8c:	00004517          	auipc	a0,0x4
    3a90:	a5450513          	addi	a0,a0,-1452 # 74e0 <malloc+0x150a>
    3a94:	00002097          	auipc	ra,0x2
    3a98:	48a080e7          	jalr	1162(ra) # 5f1e <printf>
    exit(1);
    3a9c:	4505                	li	a0,1
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	0f0080e7          	jalr	240(ra) # 5b8e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3aa6:	85ca                	mv	a1,s2
    3aa8:	00004517          	auipc	a0,0x4
    3aac:	a6850513          	addi	a0,a0,-1432 # 7510 <malloc+0x153a>
    3ab0:	00002097          	auipc	ra,0x2
    3ab4:	46e080e7          	jalr	1134(ra) # 5f1e <printf>
    exit(1);
    3ab8:	4505                	li	a0,1
    3aba:	00002097          	auipc	ra,0x2
    3abe:	0d4080e7          	jalr	212(ra) # 5b8e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ac2:	85ca                	mv	a1,s2
    3ac4:	00004517          	auipc	a0,0x4
    3ac8:	a8450513          	addi	a0,a0,-1404 # 7548 <malloc+0x1572>
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	452080e7          	jalr	1106(ra) # 5f1e <printf>
    exit(1);
    3ad4:	4505                	li	a0,1
    3ad6:	00002097          	auipc	ra,0x2
    3ada:	0b8080e7          	jalr	184(ra) # 5b8e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3ade:	85ca                	mv	a1,s2
    3ae0:	00004517          	auipc	a0,0x4
    3ae4:	a8850513          	addi	a0,a0,-1400 # 7568 <malloc+0x1592>
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	436080e7          	jalr	1078(ra) # 5f1e <printf>
    exit(1);
    3af0:	4505                	li	a0,1
    3af2:	00002097          	auipc	ra,0x2
    3af6:	09c080e7          	jalr	156(ra) # 5b8e <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3afa:	85ca                	mv	a1,s2
    3afc:	00004517          	auipc	a0,0x4
    3b00:	a9c50513          	addi	a0,a0,-1380 # 7598 <malloc+0x15c2>
    3b04:	00002097          	auipc	ra,0x2
    3b08:	41a080e7          	jalr	1050(ra) # 5f1e <printf>
    exit(1);
    3b0c:	4505                	li	a0,1
    3b0e:	00002097          	auipc	ra,0x2
    3b12:	080080e7          	jalr	128(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b16:	85ca                	mv	a1,s2
    3b18:	00004517          	auipc	a0,0x4
    3b1c:	aa850513          	addi	a0,a0,-1368 # 75c0 <malloc+0x15ea>
    3b20:	00002097          	auipc	ra,0x2
    3b24:	3fe080e7          	jalr	1022(ra) # 5f1e <printf>
    exit(1);
    3b28:	4505                	li	a0,1
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	064080e7          	jalr	100(ra) # 5b8e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b32:	85ca                	mv	a1,s2
    3b34:	00004517          	auipc	a0,0x4
    3b38:	aac50513          	addi	a0,a0,-1364 # 75e0 <malloc+0x160a>
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	3e2080e7          	jalr	994(ra) # 5f1e <printf>
    exit(1);
    3b44:	4505                	li	a0,1
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	048080e7          	jalr	72(ra) # 5b8e <exit>
    printf("%s: chdir dd failed\n", s);
    3b4e:	85ca                	mv	a1,s2
    3b50:	00004517          	auipc	a0,0x4
    3b54:	ab850513          	addi	a0,a0,-1352 # 7608 <malloc+0x1632>
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	3c6080e7          	jalr	966(ra) # 5f1e <printf>
    exit(1);
    3b60:	4505                	li	a0,1
    3b62:	00002097          	auipc	ra,0x2
    3b66:	02c080e7          	jalr	44(ra) # 5b8e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b6a:	85ca                	mv	a1,s2
    3b6c:	00004517          	auipc	a0,0x4
    3b70:	ac450513          	addi	a0,a0,-1340 # 7630 <malloc+0x165a>
    3b74:	00002097          	auipc	ra,0x2
    3b78:	3aa080e7          	jalr	938(ra) # 5f1e <printf>
    exit(1);
    3b7c:	4505                	li	a0,1
    3b7e:	00002097          	auipc	ra,0x2
    3b82:	010080e7          	jalr	16(ra) # 5b8e <exit>
    printf("chdir dd/../../dd failed\n", s);
    3b86:	85ca                	mv	a1,s2
    3b88:	00004517          	auipc	a0,0x4
    3b8c:	ad850513          	addi	a0,a0,-1320 # 7660 <malloc+0x168a>
    3b90:	00002097          	auipc	ra,0x2
    3b94:	38e080e7          	jalr	910(ra) # 5f1e <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00002097          	auipc	ra,0x2
    3b9e:	ff4080e7          	jalr	-12(ra) # 5b8e <exit>
    printf("%s: chdir ./.. failed\n", s);
    3ba2:	85ca                	mv	a1,s2
    3ba4:	00004517          	auipc	a0,0x4
    3ba8:	ae450513          	addi	a0,a0,-1308 # 7688 <malloc+0x16b2>
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	372080e7          	jalr	882(ra) # 5f1e <printf>
    exit(1);
    3bb4:	4505                	li	a0,1
    3bb6:	00002097          	auipc	ra,0x2
    3bba:	fd8080e7          	jalr	-40(ra) # 5b8e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bbe:	85ca                	mv	a1,s2
    3bc0:	00004517          	auipc	a0,0x4
    3bc4:	ae050513          	addi	a0,a0,-1312 # 76a0 <malloc+0x16ca>
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	356080e7          	jalr	854(ra) # 5f1e <printf>
    exit(1);
    3bd0:	4505                	li	a0,1
    3bd2:	00002097          	auipc	ra,0x2
    3bd6:	fbc080e7          	jalr	-68(ra) # 5b8e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bda:	85ca                	mv	a1,s2
    3bdc:	00004517          	auipc	a0,0x4
    3be0:	ae450513          	addi	a0,a0,-1308 # 76c0 <malloc+0x16ea>
    3be4:	00002097          	auipc	ra,0x2
    3be8:	33a080e7          	jalr	826(ra) # 5f1e <printf>
    exit(1);
    3bec:	4505                	li	a0,1
    3bee:	00002097          	auipc	ra,0x2
    3bf2:	fa0080e7          	jalr	-96(ra) # 5b8e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3bf6:	85ca                	mv	a1,s2
    3bf8:	00004517          	auipc	a0,0x4
    3bfc:	ae850513          	addi	a0,a0,-1304 # 76e0 <malloc+0x170a>
    3c00:	00002097          	auipc	ra,0x2
    3c04:	31e080e7          	jalr	798(ra) # 5f1e <printf>
    exit(1);
    3c08:	4505                	li	a0,1
    3c0a:	00002097          	auipc	ra,0x2
    3c0e:	f84080e7          	jalr	-124(ra) # 5b8e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c12:	85ca                	mv	a1,s2
    3c14:	00004517          	auipc	a0,0x4
    3c18:	b0c50513          	addi	a0,a0,-1268 # 7720 <malloc+0x174a>
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	302080e7          	jalr	770(ra) # 5f1e <printf>
    exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00002097          	auipc	ra,0x2
    3c2a:	f68080e7          	jalr	-152(ra) # 5b8e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c2e:	85ca                	mv	a1,s2
    3c30:	00004517          	auipc	a0,0x4
    3c34:	b2050513          	addi	a0,a0,-1248 # 7750 <malloc+0x177a>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	2e6080e7          	jalr	742(ra) # 5f1e <printf>
    exit(1);
    3c40:	4505                	li	a0,1
    3c42:	00002097          	auipc	ra,0x2
    3c46:	f4c080e7          	jalr	-180(ra) # 5b8e <exit>
    printf("%s: create dd succeeded!\n", s);
    3c4a:	85ca                	mv	a1,s2
    3c4c:	00004517          	auipc	a0,0x4
    3c50:	b2450513          	addi	a0,a0,-1244 # 7770 <malloc+0x179a>
    3c54:	00002097          	auipc	ra,0x2
    3c58:	2ca080e7          	jalr	714(ra) # 5f1e <printf>
    exit(1);
    3c5c:	4505                	li	a0,1
    3c5e:	00002097          	auipc	ra,0x2
    3c62:	f30080e7          	jalr	-208(ra) # 5b8e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c66:	85ca                	mv	a1,s2
    3c68:	00004517          	auipc	a0,0x4
    3c6c:	b2850513          	addi	a0,a0,-1240 # 7790 <malloc+0x17ba>
    3c70:	00002097          	auipc	ra,0x2
    3c74:	2ae080e7          	jalr	686(ra) # 5f1e <printf>
    exit(1);
    3c78:	4505                	li	a0,1
    3c7a:	00002097          	auipc	ra,0x2
    3c7e:	f14080e7          	jalr	-236(ra) # 5b8e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3c82:	85ca                	mv	a1,s2
    3c84:	00004517          	auipc	a0,0x4
    3c88:	b2c50513          	addi	a0,a0,-1236 # 77b0 <malloc+0x17da>
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	292080e7          	jalr	658(ra) # 5f1e <printf>
    exit(1);
    3c94:	4505                	li	a0,1
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	ef8080e7          	jalr	-264(ra) # 5b8e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3c9e:	85ca                	mv	a1,s2
    3ca0:	00004517          	auipc	a0,0x4
    3ca4:	b4050513          	addi	a0,a0,-1216 # 77e0 <malloc+0x180a>
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	276080e7          	jalr	630(ra) # 5f1e <printf>
    exit(1);
    3cb0:	4505                	li	a0,1
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	edc080e7          	jalr	-292(ra) # 5b8e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cba:	85ca                	mv	a1,s2
    3cbc:	00004517          	auipc	a0,0x4
    3cc0:	b4c50513          	addi	a0,a0,-1204 # 7808 <malloc+0x1832>
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	25a080e7          	jalr	602(ra) # 5f1e <printf>
    exit(1);
    3ccc:	4505                	li	a0,1
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	ec0080e7          	jalr	-320(ra) # 5b8e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cd6:	85ca                	mv	a1,s2
    3cd8:	00004517          	auipc	a0,0x4
    3cdc:	b5850513          	addi	a0,a0,-1192 # 7830 <malloc+0x185a>
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	23e080e7          	jalr	574(ra) # 5f1e <printf>
    exit(1);
    3ce8:	4505                	li	a0,1
    3cea:	00002097          	auipc	ra,0x2
    3cee:	ea4080e7          	jalr	-348(ra) # 5b8e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3cf2:	85ca                	mv	a1,s2
    3cf4:	00004517          	auipc	a0,0x4
    3cf8:	b6450513          	addi	a0,a0,-1180 # 7858 <malloc+0x1882>
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	222080e7          	jalr	546(ra) # 5f1e <printf>
    exit(1);
    3d04:	4505                	li	a0,1
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	e88080e7          	jalr	-376(ra) # 5b8e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d0e:	85ca                	mv	a1,s2
    3d10:	00004517          	auipc	a0,0x4
    3d14:	b6850513          	addi	a0,a0,-1176 # 7878 <malloc+0x18a2>
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	206080e7          	jalr	518(ra) # 5f1e <printf>
    exit(1);
    3d20:	4505                	li	a0,1
    3d22:	00002097          	auipc	ra,0x2
    3d26:	e6c080e7          	jalr	-404(ra) # 5b8e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d2a:	85ca                	mv	a1,s2
    3d2c:	00004517          	auipc	a0,0x4
    3d30:	b6c50513          	addi	a0,a0,-1172 # 7898 <malloc+0x18c2>
    3d34:	00002097          	auipc	ra,0x2
    3d38:	1ea080e7          	jalr	490(ra) # 5f1e <printf>
    exit(1);
    3d3c:	4505                	li	a0,1
    3d3e:	00002097          	auipc	ra,0x2
    3d42:	e50080e7          	jalr	-432(ra) # 5b8e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d46:	85ca                	mv	a1,s2
    3d48:	00004517          	auipc	a0,0x4
    3d4c:	b7850513          	addi	a0,a0,-1160 # 78c0 <malloc+0x18ea>
    3d50:	00002097          	auipc	ra,0x2
    3d54:	1ce080e7          	jalr	462(ra) # 5f1e <printf>
    exit(1);
    3d58:	4505                	li	a0,1
    3d5a:	00002097          	auipc	ra,0x2
    3d5e:	e34080e7          	jalr	-460(ra) # 5b8e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d62:	85ca                	mv	a1,s2
    3d64:	00004517          	auipc	a0,0x4
    3d68:	b7c50513          	addi	a0,a0,-1156 # 78e0 <malloc+0x190a>
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	1b2080e7          	jalr	434(ra) # 5f1e <printf>
    exit(1);
    3d74:	4505                	li	a0,1
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	e18080e7          	jalr	-488(ra) # 5b8e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d7e:	85ca                	mv	a1,s2
    3d80:	00004517          	auipc	a0,0x4
    3d84:	b8050513          	addi	a0,a0,-1152 # 7900 <malloc+0x192a>
    3d88:	00002097          	auipc	ra,0x2
    3d8c:	196080e7          	jalr	406(ra) # 5f1e <printf>
    exit(1);
    3d90:	4505                	li	a0,1
    3d92:	00002097          	auipc	ra,0x2
    3d96:	dfc080e7          	jalr	-516(ra) # 5b8e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3d9a:	85ca                	mv	a1,s2
    3d9c:	00004517          	auipc	a0,0x4
    3da0:	b8c50513          	addi	a0,a0,-1140 # 7928 <malloc+0x1952>
    3da4:	00002097          	auipc	ra,0x2
    3da8:	17a080e7          	jalr	378(ra) # 5f1e <printf>
    exit(1);
    3dac:	4505                	li	a0,1
    3dae:	00002097          	auipc	ra,0x2
    3db2:	de0080e7          	jalr	-544(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3db6:	85ca                	mv	a1,s2
    3db8:	00004517          	auipc	a0,0x4
    3dbc:	80850513          	addi	a0,a0,-2040 # 75c0 <malloc+0x15ea>
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	15e080e7          	jalr	350(ra) # 5f1e <printf>
    exit(1);
    3dc8:	4505                	li	a0,1
    3dca:	00002097          	auipc	ra,0x2
    3dce:	dc4080e7          	jalr	-572(ra) # 5b8e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3dd2:	85ca                	mv	a1,s2
    3dd4:	00004517          	auipc	a0,0x4
    3dd8:	b7450513          	addi	a0,a0,-1164 # 7948 <malloc+0x1972>
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	142080e7          	jalr	322(ra) # 5f1e <printf>
    exit(1);
    3de4:	4505                	li	a0,1
    3de6:	00002097          	auipc	ra,0x2
    3dea:	da8080e7          	jalr	-600(ra) # 5b8e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3dee:	85ca                	mv	a1,s2
    3df0:	00004517          	auipc	a0,0x4
    3df4:	b7850513          	addi	a0,a0,-1160 # 7968 <malloc+0x1992>
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	126080e7          	jalr	294(ra) # 5f1e <printf>
    exit(1);
    3e00:	4505                	li	a0,1
    3e02:	00002097          	auipc	ra,0x2
    3e06:	d8c080e7          	jalr	-628(ra) # 5b8e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e0a:	85ca                	mv	a1,s2
    3e0c:	00004517          	auipc	a0,0x4
    3e10:	b8c50513          	addi	a0,a0,-1140 # 7998 <malloc+0x19c2>
    3e14:	00002097          	auipc	ra,0x2
    3e18:	10a080e7          	jalr	266(ra) # 5f1e <printf>
    exit(1);
    3e1c:	4505                	li	a0,1
    3e1e:	00002097          	auipc	ra,0x2
    3e22:	d70080e7          	jalr	-656(ra) # 5b8e <exit>
    printf("%s: unlink dd failed\n", s);
    3e26:	85ca                	mv	a1,s2
    3e28:	00004517          	auipc	a0,0x4
    3e2c:	b9050513          	addi	a0,a0,-1136 # 79b8 <malloc+0x19e2>
    3e30:	00002097          	auipc	ra,0x2
    3e34:	0ee080e7          	jalr	238(ra) # 5f1e <printf>
    exit(1);
    3e38:	4505                	li	a0,1
    3e3a:	00002097          	auipc	ra,0x2
    3e3e:	d54080e7          	jalr	-684(ra) # 5b8e <exit>

0000000000003e42 <rmdot>:
{
    3e42:	1101                	addi	sp,sp,-32
    3e44:	ec06                	sd	ra,24(sp)
    3e46:	e822                	sd	s0,16(sp)
    3e48:	e426                	sd	s1,8(sp)
    3e4a:	1000                	addi	s0,sp,32
    3e4c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e4e:	00004517          	auipc	a0,0x4
    3e52:	b8250513          	addi	a0,a0,-1150 # 79d0 <malloc+0x19fa>
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	da0080e7          	jalr	-608(ra) # 5bf6 <mkdir>
    3e5e:	e549                	bnez	a0,3ee8 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e60:	00004517          	auipc	a0,0x4
    3e64:	b7050513          	addi	a0,a0,-1168 # 79d0 <malloc+0x19fa>
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	d96080e7          	jalr	-618(ra) # 5bfe <chdir>
    3e70:	e951                	bnez	a0,3f04 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e72:	00003517          	auipc	a0,0x3
    3e76:	98e50513          	addi	a0,a0,-1650 # 6800 <malloc+0x82a>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	d64080e7          	jalr	-668(ra) # 5bde <unlink>
    3e82:	cd59                	beqz	a0,3f20 <rmdot+0xde>
  if(unlink("..") == 0){
    3e84:	00003517          	auipc	a0,0x3
    3e88:	5a450513          	addi	a0,a0,1444 # 7428 <malloc+0x1452>
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	d52080e7          	jalr	-686(ra) # 5bde <unlink>
    3e94:	c545                	beqz	a0,3f3c <rmdot+0xfa>
  if(chdir("/") != 0){
    3e96:	00003517          	auipc	a0,0x3
    3e9a:	53a50513          	addi	a0,a0,1338 # 73d0 <malloc+0x13fa>
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	d60080e7          	jalr	-672(ra) # 5bfe <chdir>
    3ea6:	e94d                	bnez	a0,3f58 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ea8:	00004517          	auipc	a0,0x4
    3eac:	b9050513          	addi	a0,a0,-1136 # 7a38 <malloc+0x1a62>
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	d2e080e7          	jalr	-722(ra) # 5bde <unlink>
    3eb8:	cd55                	beqz	a0,3f74 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3eba:	00004517          	auipc	a0,0x4
    3ebe:	ba650513          	addi	a0,a0,-1114 # 7a60 <malloc+0x1a8a>
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	d1c080e7          	jalr	-740(ra) # 5bde <unlink>
    3eca:	c179                	beqz	a0,3f90 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	b0450513          	addi	a0,a0,-1276 # 79d0 <malloc+0x19fa>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	d0a080e7          	jalr	-758(ra) # 5bde <unlink>
    3edc:	e961                	bnez	a0,3fac <rmdot+0x16a>
}
    3ede:	60e2                	ld	ra,24(sp)
    3ee0:	6442                	ld	s0,16(sp)
    3ee2:	64a2                	ld	s1,8(sp)
    3ee4:	6105                	addi	sp,sp,32
    3ee6:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3ee8:	85a6                	mv	a1,s1
    3eea:	00004517          	auipc	a0,0x4
    3eee:	aee50513          	addi	a0,a0,-1298 # 79d8 <malloc+0x1a02>
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	02c080e7          	jalr	44(ra) # 5f1e <printf>
    exit(1);
    3efa:	4505                	li	a0,1
    3efc:	00002097          	auipc	ra,0x2
    3f00:	c92080e7          	jalr	-878(ra) # 5b8e <exit>
    printf("%s: chdir dots failed\n", s);
    3f04:	85a6                	mv	a1,s1
    3f06:	00004517          	auipc	a0,0x4
    3f0a:	aea50513          	addi	a0,a0,-1302 # 79f0 <malloc+0x1a1a>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	010080e7          	jalr	16(ra) # 5f1e <printf>
    exit(1);
    3f16:	4505                	li	a0,1
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	c76080e7          	jalr	-906(ra) # 5b8e <exit>
    printf("%s: rm . worked!\n", s);
    3f20:	85a6                	mv	a1,s1
    3f22:	00004517          	auipc	a0,0x4
    3f26:	ae650513          	addi	a0,a0,-1306 # 7a08 <malloc+0x1a32>
    3f2a:	00002097          	auipc	ra,0x2
    3f2e:	ff4080e7          	jalr	-12(ra) # 5f1e <printf>
    exit(1);
    3f32:	4505                	li	a0,1
    3f34:	00002097          	auipc	ra,0x2
    3f38:	c5a080e7          	jalr	-934(ra) # 5b8e <exit>
    printf("%s: rm .. worked!\n", s);
    3f3c:	85a6                	mv	a1,s1
    3f3e:	00004517          	auipc	a0,0x4
    3f42:	ae250513          	addi	a0,a0,-1310 # 7a20 <malloc+0x1a4a>
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	fd8080e7          	jalr	-40(ra) # 5f1e <printf>
    exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	00002097          	auipc	ra,0x2
    3f54:	c3e080e7          	jalr	-962(ra) # 5b8e <exit>
    printf("%s: chdir / failed\n", s);
    3f58:	85a6                	mv	a1,s1
    3f5a:	00003517          	auipc	a0,0x3
    3f5e:	47e50513          	addi	a0,a0,1150 # 73d8 <malloc+0x1402>
    3f62:	00002097          	auipc	ra,0x2
    3f66:	fbc080e7          	jalr	-68(ra) # 5f1e <printf>
    exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	00002097          	auipc	ra,0x2
    3f70:	c22080e7          	jalr	-990(ra) # 5b8e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f74:	85a6                	mv	a1,s1
    3f76:	00004517          	auipc	a0,0x4
    3f7a:	aca50513          	addi	a0,a0,-1334 # 7a40 <malloc+0x1a6a>
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	fa0080e7          	jalr	-96(ra) # 5f1e <printf>
    exit(1);
    3f86:	4505                	li	a0,1
    3f88:	00002097          	auipc	ra,0x2
    3f8c:	c06080e7          	jalr	-1018(ra) # 5b8e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3f90:	85a6                	mv	a1,s1
    3f92:	00004517          	auipc	a0,0x4
    3f96:	ad650513          	addi	a0,a0,-1322 # 7a68 <malloc+0x1a92>
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	f84080e7          	jalr	-124(ra) # 5f1e <printf>
    exit(1);
    3fa2:	4505                	li	a0,1
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	bea080e7          	jalr	-1046(ra) # 5b8e <exit>
    printf("%s: unlink dots failed!\n", s);
    3fac:	85a6                	mv	a1,s1
    3fae:	00004517          	auipc	a0,0x4
    3fb2:	ada50513          	addi	a0,a0,-1318 # 7a88 <malloc+0x1ab2>
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	f68080e7          	jalr	-152(ra) # 5f1e <printf>
    exit(1);
    3fbe:	4505                	li	a0,1
    3fc0:	00002097          	auipc	ra,0x2
    3fc4:	bce080e7          	jalr	-1074(ra) # 5b8e <exit>

0000000000003fc8 <dirfile>:
{
    3fc8:	1101                	addi	sp,sp,-32
    3fca:	ec06                	sd	ra,24(sp)
    3fcc:	e822                	sd	s0,16(sp)
    3fce:	e426                	sd	s1,8(sp)
    3fd0:	e04a                	sd	s2,0(sp)
    3fd2:	1000                	addi	s0,sp,32
    3fd4:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3fd6:	20000593          	li	a1,512
    3fda:	00004517          	auipc	a0,0x4
    3fde:	ace50513          	addi	a0,a0,-1330 # 7aa8 <malloc+0x1ad2>
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	bec080e7          	jalr	-1044(ra) # 5bce <open>
  if(fd < 0){
    3fea:	0e054d63          	bltz	a0,40e4 <dirfile+0x11c>
  close(fd);
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	bc8080e7          	jalr	-1080(ra) # 5bb6 <close>
  if(chdir("dirfile") == 0){
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	ab250513          	addi	a0,a0,-1358 # 7aa8 <malloc+0x1ad2>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	c00080e7          	jalr	-1024(ra) # 5bfe <chdir>
    4006:	cd6d                	beqz	a0,4100 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4008:	4581                	li	a1,0
    400a:	00004517          	auipc	a0,0x4
    400e:	ae650513          	addi	a0,a0,-1306 # 7af0 <malloc+0x1b1a>
    4012:	00002097          	auipc	ra,0x2
    4016:	bbc080e7          	jalr	-1092(ra) # 5bce <open>
  if(fd >= 0){
    401a:	10055163          	bgez	a0,411c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    401e:	20000593          	li	a1,512
    4022:	00004517          	auipc	a0,0x4
    4026:	ace50513          	addi	a0,a0,-1330 # 7af0 <malloc+0x1b1a>
    402a:	00002097          	auipc	ra,0x2
    402e:	ba4080e7          	jalr	-1116(ra) # 5bce <open>
  if(fd >= 0){
    4032:	10055363          	bgez	a0,4138 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4036:	00004517          	auipc	a0,0x4
    403a:	aba50513          	addi	a0,a0,-1350 # 7af0 <malloc+0x1b1a>
    403e:	00002097          	auipc	ra,0x2
    4042:	bb8080e7          	jalr	-1096(ra) # 5bf6 <mkdir>
    4046:	10050763          	beqz	a0,4154 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    404a:	00004517          	auipc	a0,0x4
    404e:	aa650513          	addi	a0,a0,-1370 # 7af0 <malloc+0x1b1a>
    4052:	00002097          	auipc	ra,0x2
    4056:	b8c080e7          	jalr	-1140(ra) # 5bde <unlink>
    405a:	10050b63          	beqz	a0,4170 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    405e:	00004597          	auipc	a1,0x4
    4062:	a9258593          	addi	a1,a1,-1390 # 7af0 <malloc+0x1b1a>
    4066:	00002517          	auipc	a0,0x2
    406a:	28a50513          	addi	a0,a0,650 # 62f0 <malloc+0x31a>
    406e:	00002097          	auipc	ra,0x2
    4072:	b80080e7          	jalr	-1152(ra) # 5bee <link>
    4076:	10050b63          	beqz	a0,418c <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    407a:	00004517          	auipc	a0,0x4
    407e:	a2e50513          	addi	a0,a0,-1490 # 7aa8 <malloc+0x1ad2>
    4082:	00002097          	auipc	ra,0x2
    4086:	b5c080e7          	jalr	-1188(ra) # 5bde <unlink>
    408a:	10051f63          	bnez	a0,41a8 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    408e:	4589                	li	a1,2
    4090:	00002517          	auipc	a0,0x2
    4094:	77050513          	addi	a0,a0,1904 # 6800 <malloc+0x82a>
    4098:	00002097          	auipc	ra,0x2
    409c:	b36080e7          	jalr	-1226(ra) # 5bce <open>
  if(fd >= 0){
    40a0:	12055263          	bgez	a0,41c4 <dirfile+0x1fc>
  fd = open(".", 0);
    40a4:	4581                	li	a1,0
    40a6:	00002517          	auipc	a0,0x2
    40aa:	75a50513          	addi	a0,a0,1882 # 6800 <malloc+0x82a>
    40ae:	00002097          	auipc	ra,0x2
    40b2:	b20080e7          	jalr	-1248(ra) # 5bce <open>
    40b6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40b8:	4605                	li	a2,1
    40ba:	00002597          	auipc	a1,0x2
    40be:	0ce58593          	addi	a1,a1,206 # 6188 <malloc+0x1b2>
    40c2:	00002097          	auipc	ra,0x2
    40c6:	aec080e7          	jalr	-1300(ra) # 5bae <write>
    40ca:	10a04b63          	bgtz	a0,41e0 <dirfile+0x218>
  close(fd);
    40ce:	8526                	mv	a0,s1
    40d0:	00002097          	auipc	ra,0x2
    40d4:	ae6080e7          	jalr	-1306(ra) # 5bb6 <close>
}
    40d8:	60e2                	ld	ra,24(sp)
    40da:	6442                	ld	s0,16(sp)
    40dc:	64a2                	ld	s1,8(sp)
    40de:	6902                	ld	s2,0(sp)
    40e0:	6105                	addi	sp,sp,32
    40e2:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    40e4:	85ca                	mv	a1,s2
    40e6:	00004517          	auipc	a0,0x4
    40ea:	9ca50513          	addi	a0,a0,-1590 # 7ab0 <malloc+0x1ada>
    40ee:	00002097          	auipc	ra,0x2
    40f2:	e30080e7          	jalr	-464(ra) # 5f1e <printf>
    exit(1);
    40f6:	4505                	li	a0,1
    40f8:	00002097          	auipc	ra,0x2
    40fc:	a96080e7          	jalr	-1386(ra) # 5b8e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4100:	85ca                	mv	a1,s2
    4102:	00004517          	auipc	a0,0x4
    4106:	9ce50513          	addi	a0,a0,-1586 # 7ad0 <malloc+0x1afa>
    410a:	00002097          	auipc	ra,0x2
    410e:	e14080e7          	jalr	-492(ra) # 5f1e <printf>
    exit(1);
    4112:	4505                	li	a0,1
    4114:	00002097          	auipc	ra,0x2
    4118:	a7a080e7          	jalr	-1414(ra) # 5b8e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    411c:	85ca                	mv	a1,s2
    411e:	00004517          	auipc	a0,0x4
    4122:	9e250513          	addi	a0,a0,-1566 # 7b00 <malloc+0x1b2a>
    4126:	00002097          	auipc	ra,0x2
    412a:	df8080e7          	jalr	-520(ra) # 5f1e <printf>
    exit(1);
    412e:	4505                	li	a0,1
    4130:	00002097          	auipc	ra,0x2
    4134:	a5e080e7          	jalr	-1442(ra) # 5b8e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4138:	85ca                	mv	a1,s2
    413a:	00004517          	auipc	a0,0x4
    413e:	9c650513          	addi	a0,a0,-1594 # 7b00 <malloc+0x1b2a>
    4142:	00002097          	auipc	ra,0x2
    4146:	ddc080e7          	jalr	-548(ra) # 5f1e <printf>
    exit(1);
    414a:	4505                	li	a0,1
    414c:	00002097          	auipc	ra,0x2
    4150:	a42080e7          	jalr	-1470(ra) # 5b8e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4154:	85ca                	mv	a1,s2
    4156:	00004517          	auipc	a0,0x4
    415a:	9d250513          	addi	a0,a0,-1582 # 7b28 <malloc+0x1b52>
    415e:	00002097          	auipc	ra,0x2
    4162:	dc0080e7          	jalr	-576(ra) # 5f1e <printf>
    exit(1);
    4166:	4505                	li	a0,1
    4168:	00002097          	auipc	ra,0x2
    416c:	a26080e7          	jalr	-1498(ra) # 5b8e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4170:	85ca                	mv	a1,s2
    4172:	00004517          	auipc	a0,0x4
    4176:	9de50513          	addi	a0,a0,-1570 # 7b50 <malloc+0x1b7a>
    417a:	00002097          	auipc	ra,0x2
    417e:	da4080e7          	jalr	-604(ra) # 5f1e <printf>
    exit(1);
    4182:	4505                	li	a0,1
    4184:	00002097          	auipc	ra,0x2
    4188:	a0a080e7          	jalr	-1526(ra) # 5b8e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    418c:	85ca                	mv	a1,s2
    418e:	00004517          	auipc	a0,0x4
    4192:	9ea50513          	addi	a0,a0,-1558 # 7b78 <malloc+0x1ba2>
    4196:	00002097          	auipc	ra,0x2
    419a:	d88080e7          	jalr	-632(ra) # 5f1e <printf>
    exit(1);
    419e:	4505                	li	a0,1
    41a0:	00002097          	auipc	ra,0x2
    41a4:	9ee080e7          	jalr	-1554(ra) # 5b8e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41a8:	85ca                	mv	a1,s2
    41aa:	00004517          	auipc	a0,0x4
    41ae:	9f650513          	addi	a0,a0,-1546 # 7ba0 <malloc+0x1bca>
    41b2:	00002097          	auipc	ra,0x2
    41b6:	d6c080e7          	jalr	-660(ra) # 5f1e <printf>
    exit(1);
    41ba:	4505                	li	a0,1
    41bc:	00002097          	auipc	ra,0x2
    41c0:	9d2080e7          	jalr	-1582(ra) # 5b8e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41c4:	85ca                	mv	a1,s2
    41c6:	00004517          	auipc	a0,0x4
    41ca:	9fa50513          	addi	a0,a0,-1542 # 7bc0 <malloc+0x1bea>
    41ce:	00002097          	auipc	ra,0x2
    41d2:	d50080e7          	jalr	-688(ra) # 5f1e <printf>
    exit(1);
    41d6:	4505                	li	a0,1
    41d8:	00002097          	auipc	ra,0x2
    41dc:	9b6080e7          	jalr	-1610(ra) # 5b8e <exit>
    printf("%s: write . succeeded!\n", s);
    41e0:	85ca                	mv	a1,s2
    41e2:	00004517          	auipc	a0,0x4
    41e6:	a0650513          	addi	a0,a0,-1530 # 7be8 <malloc+0x1c12>
    41ea:	00002097          	auipc	ra,0x2
    41ee:	d34080e7          	jalr	-716(ra) # 5f1e <printf>
    exit(1);
    41f2:	4505                	li	a0,1
    41f4:	00002097          	auipc	ra,0x2
    41f8:	99a080e7          	jalr	-1638(ra) # 5b8e <exit>

00000000000041fc <iref>:
{
    41fc:	7139                	addi	sp,sp,-64
    41fe:	fc06                	sd	ra,56(sp)
    4200:	f822                	sd	s0,48(sp)
    4202:	f426                	sd	s1,40(sp)
    4204:	f04a                	sd	s2,32(sp)
    4206:	ec4e                	sd	s3,24(sp)
    4208:	e852                	sd	s4,16(sp)
    420a:	e456                	sd	s5,8(sp)
    420c:	e05a                	sd	s6,0(sp)
    420e:	0080                	addi	s0,sp,64
    4210:	8b2a                	mv	s6,a0
    4212:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4216:	00004a17          	auipc	s4,0x4
    421a:	9eaa0a13          	addi	s4,s4,-1558 # 7c00 <malloc+0x1c2a>
    mkdir("");
    421e:	00003497          	auipc	s1,0x3
    4222:	4ea48493          	addi	s1,s1,1258 # 7708 <malloc+0x1732>
    link("README", "");
    4226:	00002a97          	auipc	s5,0x2
    422a:	0caa8a93          	addi	s5,s5,202 # 62f0 <malloc+0x31a>
    fd = open("xx", O_CREATE);
    422e:	00004997          	auipc	s3,0x4
    4232:	8ca98993          	addi	s3,s3,-1846 # 7af8 <malloc+0x1b22>
    4236:	a891                	j	428a <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4238:	85da                	mv	a1,s6
    423a:	00004517          	auipc	a0,0x4
    423e:	9ce50513          	addi	a0,a0,-1586 # 7c08 <malloc+0x1c32>
    4242:	00002097          	auipc	ra,0x2
    4246:	cdc080e7          	jalr	-804(ra) # 5f1e <printf>
      exit(1);
    424a:	4505                	li	a0,1
    424c:	00002097          	auipc	ra,0x2
    4250:	942080e7          	jalr	-1726(ra) # 5b8e <exit>
      printf("%s: chdir irefd failed\n", s);
    4254:	85da                	mv	a1,s6
    4256:	00004517          	auipc	a0,0x4
    425a:	9ca50513          	addi	a0,a0,-1590 # 7c20 <malloc+0x1c4a>
    425e:	00002097          	auipc	ra,0x2
    4262:	cc0080e7          	jalr	-832(ra) # 5f1e <printf>
      exit(1);
    4266:	4505                	li	a0,1
    4268:	00002097          	auipc	ra,0x2
    426c:	926080e7          	jalr	-1754(ra) # 5b8e <exit>
      close(fd);
    4270:	00002097          	auipc	ra,0x2
    4274:	946080e7          	jalr	-1722(ra) # 5bb6 <close>
    4278:	a889                	j	42ca <iref+0xce>
    unlink("xx");
    427a:	854e                	mv	a0,s3
    427c:	00002097          	auipc	ra,0x2
    4280:	962080e7          	jalr	-1694(ra) # 5bde <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4284:	397d                	addiw	s2,s2,-1
    4286:	06090063          	beqz	s2,42e6 <iref+0xea>
    if(mkdir("irefd") != 0){
    428a:	8552                	mv	a0,s4
    428c:	00002097          	auipc	ra,0x2
    4290:	96a080e7          	jalr	-1686(ra) # 5bf6 <mkdir>
    4294:	f155                	bnez	a0,4238 <iref+0x3c>
    if(chdir("irefd") != 0){
    4296:	8552                	mv	a0,s4
    4298:	00002097          	auipc	ra,0x2
    429c:	966080e7          	jalr	-1690(ra) # 5bfe <chdir>
    42a0:	f955                	bnez	a0,4254 <iref+0x58>
    mkdir("");
    42a2:	8526                	mv	a0,s1
    42a4:	00002097          	auipc	ra,0x2
    42a8:	952080e7          	jalr	-1710(ra) # 5bf6 <mkdir>
    link("README", "");
    42ac:	85a6                	mv	a1,s1
    42ae:	8556                	mv	a0,s5
    42b0:	00002097          	auipc	ra,0x2
    42b4:	93e080e7          	jalr	-1730(ra) # 5bee <link>
    fd = open("", O_CREATE);
    42b8:	20000593          	li	a1,512
    42bc:	8526                	mv	a0,s1
    42be:	00002097          	auipc	ra,0x2
    42c2:	910080e7          	jalr	-1776(ra) # 5bce <open>
    if(fd >= 0)
    42c6:	fa0555e3          	bgez	a0,4270 <iref+0x74>
    fd = open("xx", O_CREATE);
    42ca:	20000593          	li	a1,512
    42ce:	854e                	mv	a0,s3
    42d0:	00002097          	auipc	ra,0x2
    42d4:	8fe080e7          	jalr	-1794(ra) # 5bce <open>
    if(fd >= 0)
    42d8:	fa0541e3          	bltz	a0,427a <iref+0x7e>
      close(fd);
    42dc:	00002097          	auipc	ra,0x2
    42e0:	8da080e7          	jalr	-1830(ra) # 5bb6 <close>
    42e4:	bf59                	j	427a <iref+0x7e>
    42e6:	03300493          	li	s1,51
    chdir("..");
    42ea:	00003997          	auipc	s3,0x3
    42ee:	13e98993          	addi	s3,s3,318 # 7428 <malloc+0x1452>
    unlink("irefd");
    42f2:	00004917          	auipc	s2,0x4
    42f6:	90e90913          	addi	s2,s2,-1778 # 7c00 <malloc+0x1c2a>
    chdir("..");
    42fa:	854e                	mv	a0,s3
    42fc:	00002097          	auipc	ra,0x2
    4300:	902080e7          	jalr	-1790(ra) # 5bfe <chdir>
    unlink("irefd");
    4304:	854a                	mv	a0,s2
    4306:	00002097          	auipc	ra,0x2
    430a:	8d8080e7          	jalr	-1832(ra) # 5bde <unlink>
  for(i = 0; i < NINODE + 1; i++){
    430e:	34fd                	addiw	s1,s1,-1
    4310:	f4ed                	bnez	s1,42fa <iref+0xfe>
  chdir("/");
    4312:	00003517          	auipc	a0,0x3
    4316:	0be50513          	addi	a0,a0,190 # 73d0 <malloc+0x13fa>
    431a:	00002097          	auipc	ra,0x2
    431e:	8e4080e7          	jalr	-1820(ra) # 5bfe <chdir>
}
    4322:	70e2                	ld	ra,56(sp)
    4324:	7442                	ld	s0,48(sp)
    4326:	74a2                	ld	s1,40(sp)
    4328:	7902                	ld	s2,32(sp)
    432a:	69e2                	ld	s3,24(sp)
    432c:	6a42                	ld	s4,16(sp)
    432e:	6aa2                	ld	s5,8(sp)
    4330:	6b02                	ld	s6,0(sp)
    4332:	6121                	addi	sp,sp,64
    4334:	8082                	ret

0000000000004336 <openiputtest>:
{
    4336:	7179                	addi	sp,sp,-48
    4338:	f406                	sd	ra,40(sp)
    433a:	f022                	sd	s0,32(sp)
    433c:	ec26                	sd	s1,24(sp)
    433e:	1800                	addi	s0,sp,48
    4340:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4342:	00004517          	auipc	a0,0x4
    4346:	8f650513          	addi	a0,a0,-1802 # 7c38 <malloc+0x1c62>
    434a:	00002097          	auipc	ra,0x2
    434e:	8ac080e7          	jalr	-1876(ra) # 5bf6 <mkdir>
    4352:	04054263          	bltz	a0,4396 <openiputtest+0x60>
  pid = fork();
    4356:	00002097          	auipc	ra,0x2
    435a:	830080e7          	jalr	-2000(ra) # 5b86 <fork>
  if(pid < 0){
    435e:	04054a63          	bltz	a0,43b2 <openiputtest+0x7c>
  if(pid == 0){
    4362:	e93d                	bnez	a0,43d8 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4364:	4589                	li	a1,2
    4366:	00004517          	auipc	a0,0x4
    436a:	8d250513          	addi	a0,a0,-1838 # 7c38 <malloc+0x1c62>
    436e:	00002097          	auipc	ra,0x2
    4372:	860080e7          	jalr	-1952(ra) # 5bce <open>
    if(fd >= 0){
    4376:	04054c63          	bltz	a0,43ce <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    437a:	85a6                	mv	a1,s1
    437c:	00004517          	auipc	a0,0x4
    4380:	8dc50513          	addi	a0,a0,-1828 # 7c58 <malloc+0x1c82>
    4384:	00002097          	auipc	ra,0x2
    4388:	b9a080e7          	jalr	-1126(ra) # 5f1e <printf>
      exit(1);
    438c:	4505                	li	a0,1
    438e:	00002097          	auipc	ra,0x2
    4392:	800080e7          	jalr	-2048(ra) # 5b8e <exit>
    printf("%s: mkdir oidir failed\n", s);
    4396:	85a6                	mv	a1,s1
    4398:	00004517          	auipc	a0,0x4
    439c:	8a850513          	addi	a0,a0,-1880 # 7c40 <malloc+0x1c6a>
    43a0:	00002097          	auipc	ra,0x2
    43a4:	b7e080e7          	jalr	-1154(ra) # 5f1e <printf>
    exit(1);
    43a8:	4505                	li	a0,1
    43aa:	00001097          	auipc	ra,0x1
    43ae:	7e4080e7          	jalr	2020(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    43b2:	85a6                	mv	a1,s1
    43b4:	00002517          	auipc	a0,0x2
    43b8:	5ec50513          	addi	a0,a0,1516 # 69a0 <malloc+0x9ca>
    43bc:	00002097          	auipc	ra,0x2
    43c0:	b62080e7          	jalr	-1182(ra) # 5f1e <printf>
    exit(1);
    43c4:	4505                	li	a0,1
    43c6:	00001097          	auipc	ra,0x1
    43ca:	7c8080e7          	jalr	1992(ra) # 5b8e <exit>
    exit(0);
    43ce:	4501                	li	a0,0
    43d0:	00001097          	auipc	ra,0x1
    43d4:	7be080e7          	jalr	1982(ra) # 5b8e <exit>
  sleep(1);
    43d8:	4505                	li	a0,1
    43da:	00002097          	auipc	ra,0x2
    43de:	844080e7          	jalr	-1980(ra) # 5c1e <sleep>
  if(unlink("oidir") != 0){
    43e2:	00004517          	auipc	a0,0x4
    43e6:	85650513          	addi	a0,a0,-1962 # 7c38 <malloc+0x1c62>
    43ea:	00001097          	auipc	ra,0x1
    43ee:	7f4080e7          	jalr	2036(ra) # 5bde <unlink>
    43f2:	cd19                	beqz	a0,4410 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    43f4:	85a6                	mv	a1,s1
    43f6:	00002517          	auipc	a0,0x2
    43fa:	79a50513          	addi	a0,a0,1946 # 6b90 <malloc+0xbba>
    43fe:	00002097          	auipc	ra,0x2
    4402:	b20080e7          	jalr	-1248(ra) # 5f1e <printf>
    exit(1);
    4406:	4505                	li	a0,1
    4408:	00001097          	auipc	ra,0x1
    440c:	786080e7          	jalr	1926(ra) # 5b8e <exit>
  wait(&xstatus);
    4410:	fdc40513          	addi	a0,s0,-36
    4414:	00001097          	auipc	ra,0x1
    4418:	782080e7          	jalr	1922(ra) # 5b96 <wait>
  exit(xstatus);
    441c:	fdc42503          	lw	a0,-36(s0)
    4420:	00001097          	auipc	ra,0x1
    4424:	76e080e7          	jalr	1902(ra) # 5b8e <exit>

0000000000004428 <forkforkfork>:
{
    4428:	1101                	addi	sp,sp,-32
    442a:	ec06                	sd	ra,24(sp)
    442c:	e822                	sd	s0,16(sp)
    442e:	e426                	sd	s1,8(sp)
    4430:	1000                	addi	s0,sp,32
    4432:	84aa                	mv	s1,a0
  unlink("stopforking");
    4434:	00004517          	auipc	a0,0x4
    4438:	84c50513          	addi	a0,a0,-1972 # 7c80 <malloc+0x1caa>
    443c:	00001097          	auipc	ra,0x1
    4440:	7a2080e7          	jalr	1954(ra) # 5bde <unlink>
  int pid = fork();
    4444:	00001097          	auipc	ra,0x1
    4448:	742080e7          	jalr	1858(ra) # 5b86 <fork>
  if(pid < 0){
    444c:	04054563          	bltz	a0,4496 <forkforkfork+0x6e>
  if(pid == 0){
    4450:	c12d                	beqz	a0,44b2 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4452:	4551                	li	a0,20
    4454:	00001097          	auipc	ra,0x1
    4458:	7ca080e7          	jalr	1994(ra) # 5c1e <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    445c:	20200593          	li	a1,514
    4460:	00004517          	auipc	a0,0x4
    4464:	82050513          	addi	a0,a0,-2016 # 7c80 <malloc+0x1caa>
    4468:	00001097          	auipc	ra,0x1
    446c:	766080e7          	jalr	1894(ra) # 5bce <open>
    4470:	00001097          	auipc	ra,0x1
    4474:	746080e7          	jalr	1862(ra) # 5bb6 <close>
  wait(0);
    4478:	4501                	li	a0,0
    447a:	00001097          	auipc	ra,0x1
    447e:	71c080e7          	jalr	1820(ra) # 5b96 <wait>
  sleep(10); // one second
    4482:	4529                	li	a0,10
    4484:	00001097          	auipc	ra,0x1
    4488:	79a080e7          	jalr	1946(ra) # 5c1e <sleep>
}
    448c:	60e2                	ld	ra,24(sp)
    448e:	6442                	ld	s0,16(sp)
    4490:	64a2                	ld	s1,8(sp)
    4492:	6105                	addi	sp,sp,32
    4494:	8082                	ret
    printf("%s: fork failed", s);
    4496:	85a6                	mv	a1,s1
    4498:	00002517          	auipc	a0,0x2
    449c:	6c850513          	addi	a0,a0,1736 # 6b60 <malloc+0xb8a>
    44a0:	00002097          	auipc	ra,0x2
    44a4:	a7e080e7          	jalr	-1410(ra) # 5f1e <printf>
    exit(1);
    44a8:	4505                	li	a0,1
    44aa:	00001097          	auipc	ra,0x1
    44ae:	6e4080e7          	jalr	1764(ra) # 5b8e <exit>
      int fd = open("stopforking", 0);
    44b2:	00003497          	auipc	s1,0x3
    44b6:	7ce48493          	addi	s1,s1,1998 # 7c80 <malloc+0x1caa>
    44ba:	4581                	li	a1,0
    44bc:	8526                	mv	a0,s1
    44be:	00001097          	auipc	ra,0x1
    44c2:	710080e7          	jalr	1808(ra) # 5bce <open>
      if(fd >= 0){
    44c6:	02055763          	bgez	a0,44f4 <forkforkfork+0xcc>
      if(fork() < 0){
    44ca:	00001097          	auipc	ra,0x1
    44ce:	6bc080e7          	jalr	1724(ra) # 5b86 <fork>
    44d2:	fe0554e3          	bgez	a0,44ba <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44d6:	20200593          	li	a1,514
    44da:	00003517          	auipc	a0,0x3
    44de:	7a650513          	addi	a0,a0,1958 # 7c80 <malloc+0x1caa>
    44e2:	00001097          	auipc	ra,0x1
    44e6:	6ec080e7          	jalr	1772(ra) # 5bce <open>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	6cc080e7          	jalr	1740(ra) # 5bb6 <close>
    44f2:	b7e1                	j	44ba <forkforkfork+0x92>
        exit(0);
    44f4:	4501                	li	a0,0
    44f6:	00001097          	auipc	ra,0x1
    44fa:	698080e7          	jalr	1688(ra) # 5b8e <exit>

00000000000044fe <killstatus>:
{
    44fe:	7139                	addi	sp,sp,-64
    4500:	fc06                	sd	ra,56(sp)
    4502:	f822                	sd	s0,48(sp)
    4504:	f426                	sd	s1,40(sp)
    4506:	f04a                	sd	s2,32(sp)
    4508:	ec4e                	sd	s3,24(sp)
    450a:	e852                	sd	s4,16(sp)
    450c:	0080                	addi	s0,sp,64
    450e:	8a2a                	mv	s4,a0
    4510:	06400913          	li	s2,100
    if(xst != -1) {
    4514:	59fd                	li	s3,-1
    int pid1 = fork();
    4516:	00001097          	auipc	ra,0x1
    451a:	670080e7          	jalr	1648(ra) # 5b86 <fork>
    451e:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4520:	02054f63          	bltz	a0,455e <killstatus+0x60>
    if(pid1 == 0){
    4524:	c939                	beqz	a0,457a <killstatus+0x7c>
    sleep(1);
    4526:	4505                	li	a0,1
    4528:	00001097          	auipc	ra,0x1
    452c:	6f6080e7          	jalr	1782(ra) # 5c1e <sleep>
    kill(pid1);
    4530:	8526                	mv	a0,s1
    4532:	00001097          	auipc	ra,0x1
    4536:	68c080e7          	jalr	1676(ra) # 5bbe <kill>
    wait(&xst);
    453a:	fcc40513          	addi	a0,s0,-52
    453e:	00001097          	auipc	ra,0x1
    4542:	658080e7          	jalr	1624(ra) # 5b96 <wait>
    if(xst != -1) {
    4546:	fcc42783          	lw	a5,-52(s0)
    454a:	03379d63          	bne	a5,s3,4584 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    454e:	397d                	addiw	s2,s2,-1
    4550:	fc0913e3          	bnez	s2,4516 <killstatus+0x18>
  exit(0);
    4554:	4501                	li	a0,0
    4556:	00001097          	auipc	ra,0x1
    455a:	638080e7          	jalr	1592(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    455e:	85d2                	mv	a1,s4
    4560:	00002517          	auipc	a0,0x2
    4564:	44050513          	addi	a0,a0,1088 # 69a0 <malloc+0x9ca>
    4568:	00002097          	auipc	ra,0x2
    456c:	9b6080e7          	jalr	-1610(ra) # 5f1e <printf>
      exit(1);
    4570:	4505                	li	a0,1
    4572:	00001097          	auipc	ra,0x1
    4576:	61c080e7          	jalr	1564(ra) # 5b8e <exit>
        getpid();
    457a:	00001097          	auipc	ra,0x1
    457e:	694080e7          	jalr	1684(ra) # 5c0e <getpid>
      while(1) {
    4582:	bfe5                	j	457a <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4584:	85d2                	mv	a1,s4
    4586:	00003517          	auipc	a0,0x3
    458a:	70a50513          	addi	a0,a0,1802 # 7c90 <malloc+0x1cba>
    458e:	00002097          	auipc	ra,0x2
    4592:	990080e7          	jalr	-1648(ra) # 5f1e <printf>
       exit(1);
    4596:	4505                	li	a0,1
    4598:	00001097          	auipc	ra,0x1
    459c:	5f6080e7          	jalr	1526(ra) # 5b8e <exit>

00000000000045a0 <preempt>:
{
    45a0:	7139                	addi	sp,sp,-64
    45a2:	fc06                	sd	ra,56(sp)
    45a4:	f822                	sd	s0,48(sp)
    45a6:	f426                	sd	s1,40(sp)
    45a8:	f04a                	sd	s2,32(sp)
    45aa:	ec4e                	sd	s3,24(sp)
    45ac:	e852                	sd	s4,16(sp)
    45ae:	0080                	addi	s0,sp,64
    45b0:	892a                	mv	s2,a0
  pid1 = fork();
    45b2:	00001097          	auipc	ra,0x1
    45b6:	5d4080e7          	jalr	1492(ra) # 5b86 <fork>
  if(pid1 < 0) {
    45ba:	00054563          	bltz	a0,45c4 <preempt+0x24>
    45be:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45c0:	e105                	bnez	a0,45e0 <preempt+0x40>
    for(;;)
    45c2:	a001                	j	45c2 <preempt+0x22>
    printf("%s: fork failed", s);
    45c4:	85ca                	mv	a1,s2
    45c6:	00002517          	auipc	a0,0x2
    45ca:	59a50513          	addi	a0,a0,1434 # 6b60 <malloc+0xb8a>
    45ce:	00002097          	auipc	ra,0x2
    45d2:	950080e7          	jalr	-1712(ra) # 5f1e <printf>
    exit(1);
    45d6:	4505                	li	a0,1
    45d8:	00001097          	auipc	ra,0x1
    45dc:	5b6080e7          	jalr	1462(ra) # 5b8e <exit>
  pid2 = fork();
    45e0:	00001097          	auipc	ra,0x1
    45e4:	5a6080e7          	jalr	1446(ra) # 5b86 <fork>
    45e8:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    45ea:	00054463          	bltz	a0,45f2 <preempt+0x52>
  if(pid2 == 0)
    45ee:	e105                	bnez	a0,460e <preempt+0x6e>
    for(;;)
    45f0:	a001                	j	45f0 <preempt+0x50>
    printf("%s: fork failed\n", s);
    45f2:	85ca                	mv	a1,s2
    45f4:	00002517          	auipc	a0,0x2
    45f8:	3ac50513          	addi	a0,a0,940 # 69a0 <malloc+0x9ca>
    45fc:	00002097          	auipc	ra,0x2
    4600:	922080e7          	jalr	-1758(ra) # 5f1e <printf>
    exit(1);
    4604:	4505                	li	a0,1
    4606:	00001097          	auipc	ra,0x1
    460a:	588080e7          	jalr	1416(ra) # 5b8e <exit>
  pipe(pfds);
    460e:	fc840513          	addi	a0,s0,-56
    4612:	00001097          	auipc	ra,0x1
    4616:	58c080e7          	jalr	1420(ra) # 5b9e <pipe>
  pid3 = fork();
    461a:	00001097          	auipc	ra,0x1
    461e:	56c080e7          	jalr	1388(ra) # 5b86 <fork>
    4622:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4624:	02054e63          	bltz	a0,4660 <preempt+0xc0>
  if(pid3 == 0){
    4628:	e525                	bnez	a0,4690 <preempt+0xf0>
    close(pfds[0]);
    462a:	fc842503          	lw	a0,-56(s0)
    462e:	00001097          	auipc	ra,0x1
    4632:	588080e7          	jalr	1416(ra) # 5bb6 <close>
    if(write(pfds[1], "x", 1) != 1)
    4636:	4605                	li	a2,1
    4638:	00002597          	auipc	a1,0x2
    463c:	b5058593          	addi	a1,a1,-1200 # 6188 <malloc+0x1b2>
    4640:	fcc42503          	lw	a0,-52(s0)
    4644:	00001097          	auipc	ra,0x1
    4648:	56a080e7          	jalr	1386(ra) # 5bae <write>
    464c:	4785                	li	a5,1
    464e:	02f51763          	bne	a0,a5,467c <preempt+0xdc>
    close(pfds[1]);
    4652:	fcc42503          	lw	a0,-52(s0)
    4656:	00001097          	auipc	ra,0x1
    465a:	560080e7          	jalr	1376(ra) # 5bb6 <close>
    for(;;)
    465e:	a001                	j	465e <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4660:	85ca                	mv	a1,s2
    4662:	00002517          	auipc	a0,0x2
    4666:	33e50513          	addi	a0,a0,830 # 69a0 <malloc+0x9ca>
    466a:	00002097          	auipc	ra,0x2
    466e:	8b4080e7          	jalr	-1868(ra) # 5f1e <printf>
     exit(1);
    4672:	4505                	li	a0,1
    4674:	00001097          	auipc	ra,0x1
    4678:	51a080e7          	jalr	1306(ra) # 5b8e <exit>
      printf("%s: preempt write error", s);
    467c:	85ca                	mv	a1,s2
    467e:	00003517          	auipc	a0,0x3
    4682:	63250513          	addi	a0,a0,1586 # 7cb0 <malloc+0x1cda>
    4686:	00002097          	auipc	ra,0x2
    468a:	898080e7          	jalr	-1896(ra) # 5f1e <printf>
    468e:	b7d1                	j	4652 <preempt+0xb2>
  close(pfds[1]);
    4690:	fcc42503          	lw	a0,-52(s0)
    4694:	00001097          	auipc	ra,0x1
    4698:	522080e7          	jalr	1314(ra) # 5bb6 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    469c:	660d                	lui	a2,0x3
    469e:	0000a597          	auipc	a1,0xa
    46a2:	92a58593          	addi	a1,a1,-1750 # dfc8 <buf>
    46a6:	fc842503          	lw	a0,-56(s0)
    46aa:	00001097          	auipc	ra,0x1
    46ae:	4fc080e7          	jalr	1276(ra) # 5ba6 <read>
    46b2:	4785                	li	a5,1
    46b4:	02f50363          	beq	a0,a5,46da <preempt+0x13a>
    printf("%s: preempt read error", s);
    46b8:	85ca                	mv	a1,s2
    46ba:	00003517          	auipc	a0,0x3
    46be:	60e50513          	addi	a0,a0,1550 # 7cc8 <malloc+0x1cf2>
    46c2:	00002097          	auipc	ra,0x2
    46c6:	85c080e7          	jalr	-1956(ra) # 5f1e <printf>
}
    46ca:	70e2                	ld	ra,56(sp)
    46cc:	7442                	ld	s0,48(sp)
    46ce:	74a2                	ld	s1,40(sp)
    46d0:	7902                	ld	s2,32(sp)
    46d2:	69e2                	ld	s3,24(sp)
    46d4:	6a42                	ld	s4,16(sp)
    46d6:	6121                	addi	sp,sp,64
    46d8:	8082                	ret
  close(pfds[0]);
    46da:	fc842503          	lw	a0,-56(s0)
    46de:	00001097          	auipc	ra,0x1
    46e2:	4d8080e7          	jalr	1240(ra) # 5bb6 <close>
  printf("kill... ");
    46e6:	00003517          	auipc	a0,0x3
    46ea:	5fa50513          	addi	a0,a0,1530 # 7ce0 <malloc+0x1d0a>
    46ee:	00002097          	auipc	ra,0x2
    46f2:	830080e7          	jalr	-2000(ra) # 5f1e <printf>
  kill(pid1);
    46f6:	8526                	mv	a0,s1
    46f8:	00001097          	auipc	ra,0x1
    46fc:	4c6080e7          	jalr	1222(ra) # 5bbe <kill>
  kill(pid2);
    4700:	854e                	mv	a0,s3
    4702:	00001097          	auipc	ra,0x1
    4706:	4bc080e7          	jalr	1212(ra) # 5bbe <kill>
  kill(pid3);
    470a:	8552                	mv	a0,s4
    470c:	00001097          	auipc	ra,0x1
    4710:	4b2080e7          	jalr	1202(ra) # 5bbe <kill>
  printf("wait... ");
    4714:	00003517          	auipc	a0,0x3
    4718:	5dc50513          	addi	a0,a0,1500 # 7cf0 <malloc+0x1d1a>
    471c:	00002097          	auipc	ra,0x2
    4720:	802080e7          	jalr	-2046(ra) # 5f1e <printf>
  wait(0);
    4724:	4501                	li	a0,0
    4726:	00001097          	auipc	ra,0x1
    472a:	470080e7          	jalr	1136(ra) # 5b96 <wait>
  wait(0);
    472e:	4501                	li	a0,0
    4730:	00001097          	auipc	ra,0x1
    4734:	466080e7          	jalr	1126(ra) # 5b96 <wait>
  wait(0);
    4738:	4501                	li	a0,0
    473a:	00001097          	auipc	ra,0x1
    473e:	45c080e7          	jalr	1116(ra) # 5b96 <wait>
    4742:	b761                	j	46ca <preempt+0x12a>

0000000000004744 <reparent>:
{
    4744:	7179                	addi	sp,sp,-48
    4746:	f406                	sd	ra,40(sp)
    4748:	f022                	sd	s0,32(sp)
    474a:	ec26                	sd	s1,24(sp)
    474c:	e84a                	sd	s2,16(sp)
    474e:	e44e                	sd	s3,8(sp)
    4750:	e052                	sd	s4,0(sp)
    4752:	1800                	addi	s0,sp,48
    4754:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4756:	00001097          	auipc	ra,0x1
    475a:	4b8080e7          	jalr	1208(ra) # 5c0e <getpid>
    475e:	8a2a                	mv	s4,a0
    4760:	0c800913          	li	s2,200
    int pid = fork();
    4764:	00001097          	auipc	ra,0x1
    4768:	422080e7          	jalr	1058(ra) # 5b86 <fork>
    476c:	84aa                	mv	s1,a0
    if(pid < 0){
    476e:	02054263          	bltz	a0,4792 <reparent+0x4e>
    if(pid){
    4772:	cd21                	beqz	a0,47ca <reparent+0x86>
      if(wait(0) != pid){
    4774:	4501                	li	a0,0
    4776:	00001097          	auipc	ra,0x1
    477a:	420080e7          	jalr	1056(ra) # 5b96 <wait>
    477e:	02951863          	bne	a0,s1,47ae <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4782:	397d                	addiw	s2,s2,-1
    4784:	fe0910e3          	bnez	s2,4764 <reparent+0x20>
  exit(0);
    4788:	4501                	li	a0,0
    478a:	00001097          	auipc	ra,0x1
    478e:	404080e7          	jalr	1028(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    4792:	85ce                	mv	a1,s3
    4794:	00002517          	auipc	a0,0x2
    4798:	20c50513          	addi	a0,a0,524 # 69a0 <malloc+0x9ca>
    479c:	00001097          	auipc	ra,0x1
    47a0:	782080e7          	jalr	1922(ra) # 5f1e <printf>
      exit(1);
    47a4:	4505                	li	a0,1
    47a6:	00001097          	auipc	ra,0x1
    47aa:	3e8080e7          	jalr	1000(ra) # 5b8e <exit>
        printf("%s: wait wrong pid\n", s);
    47ae:	85ce                	mv	a1,s3
    47b0:	00002517          	auipc	a0,0x2
    47b4:	37850513          	addi	a0,a0,888 # 6b28 <malloc+0xb52>
    47b8:	00001097          	auipc	ra,0x1
    47bc:	766080e7          	jalr	1894(ra) # 5f1e <printf>
        exit(1);
    47c0:	4505                	li	a0,1
    47c2:	00001097          	auipc	ra,0x1
    47c6:	3cc080e7          	jalr	972(ra) # 5b8e <exit>
      int pid2 = fork();
    47ca:	00001097          	auipc	ra,0x1
    47ce:	3bc080e7          	jalr	956(ra) # 5b86 <fork>
      if(pid2 < 0){
    47d2:	00054763          	bltz	a0,47e0 <reparent+0x9c>
      exit(0);
    47d6:	4501                	li	a0,0
    47d8:	00001097          	auipc	ra,0x1
    47dc:	3b6080e7          	jalr	950(ra) # 5b8e <exit>
        kill(master_pid);
    47e0:	8552                	mv	a0,s4
    47e2:	00001097          	auipc	ra,0x1
    47e6:	3dc080e7          	jalr	988(ra) # 5bbe <kill>
        exit(1);
    47ea:	4505                	li	a0,1
    47ec:	00001097          	auipc	ra,0x1
    47f0:	3a2080e7          	jalr	930(ra) # 5b8e <exit>

00000000000047f4 <sbrkfail>:
{
    47f4:	7119                	addi	sp,sp,-128
    47f6:	fc86                	sd	ra,120(sp)
    47f8:	f8a2                	sd	s0,112(sp)
    47fa:	f4a6                	sd	s1,104(sp)
    47fc:	f0ca                	sd	s2,96(sp)
    47fe:	ecce                	sd	s3,88(sp)
    4800:	e8d2                	sd	s4,80(sp)
    4802:	e4d6                	sd	s5,72(sp)
    4804:	0100                	addi	s0,sp,128
    4806:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4808:	fb040513          	addi	a0,s0,-80
    480c:	00001097          	auipc	ra,0x1
    4810:	392080e7          	jalr	914(ra) # 5b9e <pipe>
    4814:	e901                	bnez	a0,4824 <sbrkfail+0x30>
    4816:	f8040493          	addi	s1,s0,-128
    481a:	fa840993          	addi	s3,s0,-88
    481e:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4820:	5a7d                	li	s4,-1
    4822:	a085                	j	4882 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4824:	85d6                	mv	a1,s5
    4826:	00002517          	auipc	a0,0x2
    482a:	28250513          	addi	a0,a0,642 # 6aa8 <malloc+0xad2>
    482e:	00001097          	auipc	ra,0x1
    4832:	6f0080e7          	jalr	1776(ra) # 5f1e <printf>
    exit(1);
    4836:	4505                	li	a0,1
    4838:	00001097          	auipc	ra,0x1
    483c:	356080e7          	jalr	854(ra) # 5b8e <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4840:	00001097          	auipc	ra,0x1
    4844:	3d6080e7          	jalr	982(ra) # 5c16 <sbrk>
    4848:	064007b7          	lui	a5,0x6400
    484c:	40a7853b          	subw	a0,a5,a0
    4850:	00001097          	auipc	ra,0x1
    4854:	3c6080e7          	jalr	966(ra) # 5c16 <sbrk>
      write(fds[1], "x", 1);
    4858:	4605                	li	a2,1
    485a:	00002597          	auipc	a1,0x2
    485e:	92e58593          	addi	a1,a1,-1746 # 6188 <malloc+0x1b2>
    4862:	fb442503          	lw	a0,-76(s0)
    4866:	00001097          	auipc	ra,0x1
    486a:	348080e7          	jalr	840(ra) # 5bae <write>
      for(;;) sleep(1000);
    486e:	3e800513          	li	a0,1000
    4872:	00001097          	auipc	ra,0x1
    4876:	3ac080e7          	jalr	940(ra) # 5c1e <sleep>
    487a:	bfd5                	j	486e <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    487c:	0911                	addi	s2,s2,4
    487e:	03390563          	beq	s2,s3,48a8 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4882:	00001097          	auipc	ra,0x1
    4886:	304080e7          	jalr	772(ra) # 5b86 <fork>
    488a:	00a92023          	sw	a0,0(s2)
    488e:	d94d                	beqz	a0,4840 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4890:	ff4506e3          	beq	a0,s4,487c <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4894:	4605                	li	a2,1
    4896:	faf40593          	addi	a1,s0,-81
    489a:	fb042503          	lw	a0,-80(s0)
    489e:	00001097          	auipc	ra,0x1
    48a2:	308080e7          	jalr	776(ra) # 5ba6 <read>
    48a6:	bfd9                	j	487c <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48a8:	6505                	lui	a0,0x1
    48aa:	00001097          	auipc	ra,0x1
    48ae:	36c080e7          	jalr	876(ra) # 5c16 <sbrk>
    48b2:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48b4:	597d                	li	s2,-1
    48b6:	a021                	j	48be <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b8:	0491                	addi	s1,s1,4
    48ba:	01348f63          	beq	s1,s3,48d8 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48be:	4088                	lw	a0,0(s1)
    48c0:	ff250ce3          	beq	a0,s2,48b8 <sbrkfail+0xc4>
    kill(pids[i]);
    48c4:	00001097          	auipc	ra,0x1
    48c8:	2fa080e7          	jalr	762(ra) # 5bbe <kill>
    wait(0);
    48cc:	4501                	li	a0,0
    48ce:	00001097          	auipc	ra,0x1
    48d2:	2c8080e7          	jalr	712(ra) # 5b96 <wait>
    48d6:	b7cd                	j	48b8 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48d8:	57fd                	li	a5,-1
    48da:	04fa0163          	beq	s4,a5,491c <sbrkfail+0x128>
  pid = fork();
    48de:	00001097          	auipc	ra,0x1
    48e2:	2a8080e7          	jalr	680(ra) # 5b86 <fork>
    48e6:	84aa                	mv	s1,a0
  if(pid < 0){
    48e8:	04054863          	bltz	a0,4938 <sbrkfail+0x144>
  if(pid == 0){
    48ec:	c525                	beqz	a0,4954 <sbrkfail+0x160>
  wait(&xstatus);
    48ee:	fbc40513          	addi	a0,s0,-68
    48f2:	00001097          	auipc	ra,0x1
    48f6:	2a4080e7          	jalr	676(ra) # 5b96 <wait>
  if(xstatus != -1 && xstatus != 2)
    48fa:	fbc42783          	lw	a5,-68(s0)
    48fe:	577d                	li	a4,-1
    4900:	00e78563          	beq	a5,a4,490a <sbrkfail+0x116>
    4904:	4709                	li	a4,2
    4906:	08e79d63          	bne	a5,a4,49a0 <sbrkfail+0x1ac>
}
    490a:	70e6                	ld	ra,120(sp)
    490c:	7446                	ld	s0,112(sp)
    490e:	74a6                	ld	s1,104(sp)
    4910:	7906                	ld	s2,96(sp)
    4912:	69e6                	ld	s3,88(sp)
    4914:	6a46                	ld	s4,80(sp)
    4916:	6aa6                	ld	s5,72(sp)
    4918:	6109                	addi	sp,sp,128
    491a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    491c:	85d6                	mv	a1,s5
    491e:	00003517          	auipc	a0,0x3
    4922:	3e250513          	addi	a0,a0,994 # 7d00 <malloc+0x1d2a>
    4926:	00001097          	auipc	ra,0x1
    492a:	5f8080e7          	jalr	1528(ra) # 5f1e <printf>
    exit(1);
    492e:	4505                	li	a0,1
    4930:	00001097          	auipc	ra,0x1
    4934:	25e080e7          	jalr	606(ra) # 5b8e <exit>
    printf("%s: fork failed\n", s);
    4938:	85d6                	mv	a1,s5
    493a:	00002517          	auipc	a0,0x2
    493e:	06650513          	addi	a0,a0,102 # 69a0 <malloc+0x9ca>
    4942:	00001097          	auipc	ra,0x1
    4946:	5dc080e7          	jalr	1500(ra) # 5f1e <printf>
    exit(1);
    494a:	4505                	li	a0,1
    494c:	00001097          	auipc	ra,0x1
    4950:	242080e7          	jalr	578(ra) # 5b8e <exit>
    a = sbrk(0);
    4954:	4501                	li	a0,0
    4956:	00001097          	auipc	ra,0x1
    495a:	2c0080e7          	jalr	704(ra) # 5c16 <sbrk>
    495e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4960:	3e800537          	lui	a0,0x3e800
    4964:	00001097          	auipc	ra,0x1
    4968:	2b2080e7          	jalr	690(ra) # 5c16 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    496c:	87ca                	mv	a5,s2
    496e:	3e800737          	lui	a4,0x3e800
    4972:	993a                	add	s2,s2,a4
    4974:	6705                	lui	a4,0x1
      n += *(a+i);
    4976:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63ef038>
    497a:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    497c:	97ba                	add	a5,a5,a4
    497e:	fef91ce3          	bne	s2,a5,4976 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4982:	8626                	mv	a2,s1
    4984:	85d6                	mv	a1,s5
    4986:	00003517          	auipc	a0,0x3
    498a:	39a50513          	addi	a0,a0,922 # 7d20 <malloc+0x1d4a>
    498e:	00001097          	auipc	ra,0x1
    4992:	590080e7          	jalr	1424(ra) # 5f1e <printf>
    exit(1);
    4996:	4505                	li	a0,1
    4998:	00001097          	auipc	ra,0x1
    499c:	1f6080e7          	jalr	502(ra) # 5b8e <exit>
    exit(1);
    49a0:	4505                	li	a0,1
    49a2:	00001097          	auipc	ra,0x1
    49a6:	1ec080e7          	jalr	492(ra) # 5b8e <exit>

00000000000049aa <mem>:
{
    49aa:	7139                	addi	sp,sp,-64
    49ac:	fc06                	sd	ra,56(sp)
    49ae:	f822                	sd	s0,48(sp)
    49b0:	f426                	sd	s1,40(sp)
    49b2:	f04a                	sd	s2,32(sp)
    49b4:	ec4e                	sd	s3,24(sp)
    49b6:	0080                	addi	s0,sp,64
    49b8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49ba:	00001097          	auipc	ra,0x1
    49be:	1cc080e7          	jalr	460(ra) # 5b86 <fork>
    m1 = 0;
    49c2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49c4:	6909                	lui	s2,0x2
    49c6:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x13f>
  if((pid = fork()) == 0){
    49ca:	c115                	beqz	a0,49ee <mem+0x44>
    wait(&xstatus);
    49cc:	fcc40513          	addi	a0,s0,-52
    49d0:	00001097          	auipc	ra,0x1
    49d4:	1c6080e7          	jalr	454(ra) # 5b96 <wait>
    if(xstatus == -1){
    49d8:	fcc42503          	lw	a0,-52(s0)
    49dc:	57fd                	li	a5,-1
    49de:	06f50363          	beq	a0,a5,4a44 <mem+0x9a>
    exit(xstatus);
    49e2:	00001097          	auipc	ra,0x1
    49e6:	1ac080e7          	jalr	428(ra) # 5b8e <exit>
      *(char**)m2 = m1;
    49ea:	e104                	sd	s1,0(a0)
      m1 = m2;
    49ec:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    49ee:	854a                	mv	a0,s2
    49f0:	00001097          	auipc	ra,0x1
    49f4:	5e6080e7          	jalr	1510(ra) # 5fd6 <malloc>
    49f8:	f96d                	bnez	a0,49ea <mem+0x40>
    while(m1){
    49fa:	c881                	beqz	s1,4a0a <mem+0x60>
      m2 = *(char**)m1;
    49fc:	8526                	mv	a0,s1
    49fe:	6084                	ld	s1,0(s1)
      free(m1);
    4a00:	00001097          	auipc	ra,0x1
    4a04:	554080e7          	jalr	1364(ra) # 5f54 <free>
    while(m1){
    4a08:	f8f5                	bnez	s1,49fc <mem+0x52>
    m1 = malloc(1024*20);
    4a0a:	6515                	lui	a0,0x5
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	5ca080e7          	jalr	1482(ra) # 5fd6 <malloc>
    if(m1 == 0){
    4a14:	c911                	beqz	a0,4a28 <mem+0x7e>
    free(m1);
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	53e080e7          	jalr	1342(ra) # 5f54 <free>
    exit(0);
    4a1e:	4501                	li	a0,0
    4a20:	00001097          	auipc	ra,0x1
    4a24:	16e080e7          	jalr	366(ra) # 5b8e <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a28:	85ce                	mv	a1,s3
    4a2a:	00003517          	auipc	a0,0x3
    4a2e:	32650513          	addi	a0,a0,806 # 7d50 <malloc+0x1d7a>
    4a32:	00001097          	auipc	ra,0x1
    4a36:	4ec080e7          	jalr	1260(ra) # 5f1e <printf>
      exit(1);
    4a3a:	4505                	li	a0,1
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	152080e7          	jalr	338(ra) # 5b8e <exit>
      exit(0);
    4a44:	4501                	li	a0,0
    4a46:	00001097          	auipc	ra,0x1
    4a4a:	148080e7          	jalr	328(ra) # 5b8e <exit>

0000000000004a4e <sharedfd>:
{
    4a4e:	7159                	addi	sp,sp,-112
    4a50:	f486                	sd	ra,104(sp)
    4a52:	f0a2                	sd	s0,96(sp)
    4a54:	e0d2                	sd	s4,64(sp)
    4a56:	1880                	addi	s0,sp,112
    4a58:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a5a:	00003517          	auipc	a0,0x3
    4a5e:	31650513          	addi	a0,a0,790 # 7d70 <malloc+0x1d9a>
    4a62:	00001097          	auipc	ra,0x1
    4a66:	17c080e7          	jalr	380(ra) # 5bde <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a6a:	20200593          	li	a1,514
    4a6e:	00003517          	auipc	a0,0x3
    4a72:	30250513          	addi	a0,a0,770 # 7d70 <malloc+0x1d9a>
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	158080e7          	jalr	344(ra) # 5bce <open>
  if(fd < 0){
    4a7e:	06054063          	bltz	a0,4ade <sharedfd+0x90>
    4a82:	eca6                	sd	s1,88(sp)
    4a84:	e8ca                	sd	s2,80(sp)
    4a86:	e4ce                	sd	s3,72(sp)
    4a88:	fc56                	sd	s5,56(sp)
    4a8a:	f85a                	sd	s6,48(sp)
    4a8c:	f45e                	sd	s7,40(sp)
    4a8e:	892a                	mv	s2,a0
  pid = fork();
    4a90:	00001097          	auipc	ra,0x1
    4a94:	0f6080e7          	jalr	246(ra) # 5b86 <fork>
    4a98:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4a9a:	07000593          	li	a1,112
    4a9e:	e119                	bnez	a0,4aa4 <sharedfd+0x56>
    4aa0:	06300593          	li	a1,99
    4aa4:	4629                	li	a2,10
    4aa6:	fa040513          	addi	a0,s0,-96
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	eea080e7          	jalr	-278(ra) # 5994 <memset>
    4ab2:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ab6:	4629                	li	a2,10
    4ab8:	fa040593          	addi	a1,s0,-96
    4abc:	854a                	mv	a0,s2
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	0f0080e7          	jalr	240(ra) # 5bae <write>
    4ac6:	47a9                	li	a5,10
    4ac8:	02f51f63          	bne	a0,a5,4b06 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4acc:	34fd                	addiw	s1,s1,-1
    4ace:	f4e5                	bnez	s1,4ab6 <sharedfd+0x68>
  if(pid == 0) {
    4ad0:	04099963          	bnez	s3,4b22 <sharedfd+0xd4>
    exit(0);
    4ad4:	4501                	li	a0,0
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	0b8080e7          	jalr	184(ra) # 5b8e <exit>
    4ade:	eca6                	sd	s1,88(sp)
    4ae0:	e8ca                	sd	s2,80(sp)
    4ae2:	e4ce                	sd	s3,72(sp)
    4ae4:	fc56                	sd	s5,56(sp)
    4ae6:	f85a                	sd	s6,48(sp)
    4ae8:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4aea:	85d2                	mv	a1,s4
    4aec:	00003517          	auipc	a0,0x3
    4af0:	29450513          	addi	a0,a0,660 # 7d80 <malloc+0x1daa>
    4af4:	00001097          	auipc	ra,0x1
    4af8:	42a080e7          	jalr	1066(ra) # 5f1e <printf>
    exit(1);
    4afc:	4505                	li	a0,1
    4afe:	00001097          	auipc	ra,0x1
    4b02:	090080e7          	jalr	144(ra) # 5b8e <exit>
      printf("%s: write sharedfd failed\n", s);
    4b06:	85d2                	mv	a1,s4
    4b08:	00003517          	auipc	a0,0x3
    4b0c:	2a050513          	addi	a0,a0,672 # 7da8 <malloc+0x1dd2>
    4b10:	00001097          	auipc	ra,0x1
    4b14:	40e080e7          	jalr	1038(ra) # 5f1e <printf>
      exit(1);
    4b18:	4505                	li	a0,1
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	074080e7          	jalr	116(ra) # 5b8e <exit>
    wait(&xstatus);
    4b22:	f9c40513          	addi	a0,s0,-100
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	070080e7          	jalr	112(ra) # 5b96 <wait>
    if(xstatus != 0)
    4b2e:	f9c42983          	lw	s3,-100(s0)
    4b32:	00098763          	beqz	s3,4b40 <sharedfd+0xf2>
      exit(xstatus);
    4b36:	854e                	mv	a0,s3
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	056080e7          	jalr	86(ra) # 5b8e <exit>
  close(fd);
    4b40:	854a                	mv	a0,s2
    4b42:	00001097          	auipc	ra,0x1
    4b46:	074080e7          	jalr	116(ra) # 5bb6 <close>
  fd = open("sharedfd", 0);
    4b4a:	4581                	li	a1,0
    4b4c:	00003517          	auipc	a0,0x3
    4b50:	22450513          	addi	a0,a0,548 # 7d70 <malloc+0x1d9a>
    4b54:	00001097          	auipc	ra,0x1
    4b58:	07a080e7          	jalr	122(ra) # 5bce <open>
    4b5c:	8baa                	mv	s7,a0
  nc = np = 0;
    4b5e:	8ace                	mv	s5,s3
  if(fd < 0){
    4b60:	02054563          	bltz	a0,4b8a <sharedfd+0x13c>
    4b64:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b68:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b6c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b70:	4629                	li	a2,10
    4b72:	fa040593          	addi	a1,s0,-96
    4b76:	855e                	mv	a0,s7
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	02e080e7          	jalr	46(ra) # 5ba6 <read>
    4b80:	02a05f63          	blez	a0,4bbe <sharedfd+0x170>
    4b84:	fa040793          	addi	a5,s0,-96
    4b88:	a01d                	j	4bae <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b8a:	85d2                	mv	a1,s4
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	23c50513          	addi	a0,a0,572 # 7dc8 <malloc+0x1df2>
    4b94:	00001097          	auipc	ra,0x1
    4b98:	38a080e7          	jalr	906(ra) # 5f1e <printf>
    exit(1);
    4b9c:	4505                	li	a0,1
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	ff0080e7          	jalr	-16(ra) # 5b8e <exit>
        nc++;
    4ba6:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4ba8:	0785                	addi	a5,a5,1
    4baa:	fd2783e3          	beq	a5,s2,4b70 <sharedfd+0x122>
      if(buf[i] == 'c')
    4bae:	0007c703          	lbu	a4,0(a5)
    4bb2:	fe970ae3          	beq	a4,s1,4ba6 <sharedfd+0x158>
      if(buf[i] == 'p')
    4bb6:	ff6719e3          	bne	a4,s6,4ba8 <sharedfd+0x15a>
        np++;
    4bba:	2a85                	addiw	s5,s5,1
    4bbc:	b7f5                	j	4ba8 <sharedfd+0x15a>
  close(fd);
    4bbe:	855e                	mv	a0,s7
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	ff6080e7          	jalr	-10(ra) # 5bb6 <close>
  unlink("sharedfd");
    4bc8:	00003517          	auipc	a0,0x3
    4bcc:	1a850513          	addi	a0,a0,424 # 7d70 <malloc+0x1d9a>
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	00e080e7          	jalr	14(ra) # 5bde <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bd8:	6789                	lui	a5,0x2
    4bda:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x13e>
    4bde:	00f99763          	bne	s3,a5,4bec <sharedfd+0x19e>
    4be2:	6789                	lui	a5,0x2
    4be4:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x13e>
    4be8:	02fa8063          	beq	s5,a5,4c08 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4bec:	85d2                	mv	a1,s4
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	20250513          	addi	a0,a0,514 # 7df0 <malloc+0x1e1a>
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	328080e7          	jalr	808(ra) # 5f1e <printf>
    exit(1);
    4bfe:	4505                	li	a0,1
    4c00:	00001097          	auipc	ra,0x1
    4c04:	f8e080e7          	jalr	-114(ra) # 5b8e <exit>
    exit(0);
    4c08:	4501                	li	a0,0
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	f84080e7          	jalr	-124(ra) # 5b8e <exit>

0000000000004c12 <fourfiles>:
{
    4c12:	7135                	addi	sp,sp,-160
    4c14:	ed06                	sd	ra,152(sp)
    4c16:	e922                	sd	s0,144(sp)
    4c18:	e526                	sd	s1,136(sp)
    4c1a:	e14a                	sd	s2,128(sp)
    4c1c:	fcce                	sd	s3,120(sp)
    4c1e:	f8d2                	sd	s4,112(sp)
    4c20:	f4d6                	sd	s5,104(sp)
    4c22:	f0da                	sd	s6,96(sp)
    4c24:	ecde                	sd	s7,88(sp)
    4c26:	e8e2                	sd	s8,80(sp)
    4c28:	e4e6                	sd	s9,72(sp)
    4c2a:	e0ea                	sd	s10,64(sp)
    4c2c:	fc6e                	sd	s11,56(sp)
    4c2e:	1100                	addi	s0,sp,160
    4c30:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c32:	00003797          	auipc	a5,0x3
    4c36:	1d678793          	addi	a5,a5,470 # 7e08 <malloc+0x1e32>
    4c3a:	f6f43823          	sd	a5,-144(s0)
    4c3e:	00003797          	auipc	a5,0x3
    4c42:	1d278793          	addi	a5,a5,466 # 7e10 <malloc+0x1e3a>
    4c46:	f6f43c23          	sd	a5,-136(s0)
    4c4a:	00003797          	auipc	a5,0x3
    4c4e:	1ce78793          	addi	a5,a5,462 # 7e18 <malloc+0x1e42>
    4c52:	f8f43023          	sd	a5,-128(s0)
    4c56:	00003797          	auipc	a5,0x3
    4c5a:	1ca78793          	addi	a5,a5,458 # 7e20 <malloc+0x1e4a>
    4c5e:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c62:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c66:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c68:	4481                	li	s1,0
    4c6a:	4a11                	li	s4,4
    fname = names[pi];
    4c6c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c70:	854e                	mv	a0,s3
    4c72:	00001097          	auipc	ra,0x1
    4c76:	f6c080e7          	jalr	-148(ra) # 5bde <unlink>
    pid = fork();
    4c7a:	00001097          	auipc	ra,0x1
    4c7e:	f0c080e7          	jalr	-244(ra) # 5b86 <fork>
    if(pid < 0){
    4c82:	04054063          	bltz	a0,4cc2 <fourfiles+0xb0>
    if(pid == 0){
    4c86:	cd21                	beqz	a0,4cde <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4c88:	2485                	addiw	s1,s1,1
    4c8a:	0921                	addi	s2,s2,8
    4c8c:	ff4490e3          	bne	s1,s4,4c6c <fourfiles+0x5a>
    4c90:	4491                	li	s1,4
    wait(&xstatus);
    4c92:	f6c40513          	addi	a0,s0,-148
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	f00080e7          	jalr	-256(ra) # 5b96 <wait>
    if(xstatus != 0)
    4c9e:	f6c42a83          	lw	s5,-148(s0)
    4ca2:	0c0a9863          	bnez	s5,4d72 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4ca6:	34fd                	addiw	s1,s1,-1
    4ca8:	f4ed                	bnez	s1,4c92 <fourfiles+0x80>
    4caa:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cae:	00009a17          	auipc	s4,0x9
    4cb2:	31aa0a13          	addi	s4,s4,794 # dfc8 <buf>
    if(total != N*SZ){
    4cb6:	6d05                	lui	s10,0x1
    4cb8:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x20>
  for(i = 0; i < NCHILD; i++){
    4cbc:	03400d93          	li	s11,52
    4cc0:	a22d                	j	4dea <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4cc2:	85e6                	mv	a1,s9
    4cc4:	00002517          	auipc	a0,0x2
    4cc8:	0e450513          	addi	a0,a0,228 # 6da8 <malloc+0xdd2>
    4ccc:	00001097          	auipc	ra,0x1
    4cd0:	252080e7          	jalr	594(ra) # 5f1e <printf>
      exit(1);
    4cd4:	4505                	li	a0,1
    4cd6:	00001097          	auipc	ra,0x1
    4cda:	eb8080e7          	jalr	-328(ra) # 5b8e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cde:	20200593          	li	a1,514
    4ce2:	854e                	mv	a0,s3
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	eea080e7          	jalr	-278(ra) # 5bce <open>
    4cec:	892a                	mv	s2,a0
      if(fd < 0){
    4cee:	04054763          	bltz	a0,4d3c <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4cf2:	1f400613          	li	a2,500
    4cf6:	0304859b          	addiw	a1,s1,48
    4cfa:	00009517          	auipc	a0,0x9
    4cfe:	2ce50513          	addi	a0,a0,718 # dfc8 <buf>
    4d02:	00001097          	auipc	ra,0x1
    4d06:	c92080e7          	jalr	-878(ra) # 5994 <memset>
    4d0a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d0c:	00009997          	auipc	s3,0x9
    4d10:	2bc98993          	addi	s3,s3,700 # dfc8 <buf>
    4d14:	1f400613          	li	a2,500
    4d18:	85ce                	mv	a1,s3
    4d1a:	854a                	mv	a0,s2
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	e92080e7          	jalr	-366(ra) # 5bae <write>
    4d24:	85aa                	mv	a1,a0
    4d26:	1f400793          	li	a5,500
    4d2a:	02f51763          	bne	a0,a5,4d58 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d2e:	34fd                	addiw	s1,s1,-1
    4d30:	f0f5                	bnez	s1,4d14 <fourfiles+0x102>
      exit(0);
    4d32:	4501                	li	a0,0
    4d34:	00001097          	auipc	ra,0x1
    4d38:	e5a080e7          	jalr	-422(ra) # 5b8e <exit>
        printf("create failed\n", s);
    4d3c:	85e6                	mv	a1,s9
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	0ea50513          	addi	a0,a0,234 # 7e28 <malloc+0x1e52>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	1d8080e7          	jalr	472(ra) # 5f1e <printf>
        exit(1);
    4d4e:	4505                	li	a0,1
    4d50:	00001097          	auipc	ra,0x1
    4d54:	e3e080e7          	jalr	-450(ra) # 5b8e <exit>
          printf("write failed %d\n", n);
    4d58:	00003517          	auipc	a0,0x3
    4d5c:	0e050513          	addi	a0,a0,224 # 7e38 <malloc+0x1e62>
    4d60:	00001097          	auipc	ra,0x1
    4d64:	1be080e7          	jalr	446(ra) # 5f1e <printf>
          exit(1);
    4d68:	4505                	li	a0,1
    4d6a:	00001097          	auipc	ra,0x1
    4d6e:	e24080e7          	jalr	-476(ra) # 5b8e <exit>
      exit(xstatus);
    4d72:	8556                	mv	a0,s5
    4d74:	00001097          	auipc	ra,0x1
    4d78:	e1a080e7          	jalr	-486(ra) # 5b8e <exit>
          printf("wrong char\n", s);
    4d7c:	85e6                	mv	a1,s9
    4d7e:	00003517          	auipc	a0,0x3
    4d82:	0d250513          	addi	a0,a0,210 # 7e50 <malloc+0x1e7a>
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	198080e7          	jalr	408(ra) # 5f1e <printf>
          exit(1);
    4d8e:	4505                	li	a0,1
    4d90:	00001097          	auipc	ra,0x1
    4d94:	dfe080e7          	jalr	-514(ra) # 5b8e <exit>
      total += n;
    4d98:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d9c:	660d                	lui	a2,0x3
    4d9e:	85d2                	mv	a1,s4
    4da0:	854e                	mv	a0,s3
    4da2:	00001097          	auipc	ra,0x1
    4da6:	e04080e7          	jalr	-508(ra) # 5ba6 <read>
    4daa:	02a05063          	blez	a0,4dca <fourfiles+0x1b8>
    4dae:	00009797          	auipc	a5,0x9
    4db2:	21a78793          	addi	a5,a5,538 # dfc8 <buf>
    4db6:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4dba:	0007c703          	lbu	a4,0(a5)
    4dbe:	fa971fe3          	bne	a4,s1,4d7c <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4dc2:	0785                	addi	a5,a5,1
    4dc4:	fed79be3          	bne	a5,a3,4dba <fourfiles+0x1a8>
    4dc8:	bfc1                	j	4d98 <fourfiles+0x186>
    close(fd);
    4dca:	854e                	mv	a0,s3
    4dcc:	00001097          	auipc	ra,0x1
    4dd0:	dea080e7          	jalr	-534(ra) # 5bb6 <close>
    if(total != N*SZ){
    4dd4:	03a91863          	bne	s2,s10,4e04 <fourfiles+0x1f2>
    unlink(fname);
    4dd8:	8562                	mv	a0,s8
    4dda:	00001097          	auipc	ra,0x1
    4dde:	e04080e7          	jalr	-508(ra) # 5bde <unlink>
  for(i = 0; i < NCHILD; i++){
    4de2:	0ba1                	addi	s7,s7,8
    4de4:	2b05                	addiw	s6,s6,1
    4de6:	03bb0d63          	beq	s6,s11,4e20 <fourfiles+0x20e>
    fname = names[i];
    4dea:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4dee:	4581                	li	a1,0
    4df0:	8562                	mv	a0,s8
    4df2:	00001097          	auipc	ra,0x1
    4df6:	ddc080e7          	jalr	-548(ra) # 5bce <open>
    4dfa:	89aa                	mv	s3,a0
    total = 0;
    4dfc:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4dfe:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e02:	bf69                	j	4d9c <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e04:	85ca                	mv	a1,s2
    4e06:	00003517          	auipc	a0,0x3
    4e0a:	05a50513          	addi	a0,a0,90 # 7e60 <malloc+0x1e8a>
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	110080e7          	jalr	272(ra) # 5f1e <printf>
      exit(1);
    4e16:	4505                	li	a0,1
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	d76080e7          	jalr	-650(ra) # 5b8e <exit>
}
    4e20:	60ea                	ld	ra,152(sp)
    4e22:	644a                	ld	s0,144(sp)
    4e24:	64aa                	ld	s1,136(sp)
    4e26:	690a                	ld	s2,128(sp)
    4e28:	79e6                	ld	s3,120(sp)
    4e2a:	7a46                	ld	s4,112(sp)
    4e2c:	7aa6                	ld	s5,104(sp)
    4e2e:	7b06                	ld	s6,96(sp)
    4e30:	6be6                	ld	s7,88(sp)
    4e32:	6c46                	ld	s8,80(sp)
    4e34:	6ca6                	ld	s9,72(sp)
    4e36:	6d06                	ld	s10,64(sp)
    4e38:	7de2                	ld	s11,56(sp)
    4e3a:	610d                	addi	sp,sp,160
    4e3c:	8082                	ret

0000000000004e3e <concreate>:
{
    4e3e:	7135                	addi	sp,sp,-160
    4e40:	ed06                	sd	ra,152(sp)
    4e42:	e922                	sd	s0,144(sp)
    4e44:	e526                	sd	s1,136(sp)
    4e46:	e14a                	sd	s2,128(sp)
    4e48:	fcce                	sd	s3,120(sp)
    4e4a:	f8d2                	sd	s4,112(sp)
    4e4c:	f4d6                	sd	s5,104(sp)
    4e4e:	f0da                	sd	s6,96(sp)
    4e50:	ecde                	sd	s7,88(sp)
    4e52:	1100                	addi	s0,sp,160
    4e54:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e56:	04300793          	li	a5,67
    4e5a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e5e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e62:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e64:	4b0d                	li	s6,3
    4e66:	4a85                	li	s5,1
      link("C0", file);
    4e68:	00003b97          	auipc	s7,0x3
    4e6c:	010b8b93          	addi	s7,s7,16 # 7e78 <malloc+0x1ea2>
  for(i = 0; i < N; i++){
    4e70:	02800a13          	li	s4,40
    4e74:	acc9                	j	5146 <concreate+0x308>
      link("C0", file);
    4e76:	fa840593          	addi	a1,s0,-88
    4e7a:	855e                	mv	a0,s7
    4e7c:	00001097          	auipc	ra,0x1
    4e80:	d72080e7          	jalr	-654(ra) # 5bee <link>
    if(pid == 0) {
    4e84:	a465                	j	512c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4e86:	4795                	li	a5,5
    4e88:	02f9693b          	remw	s2,s2,a5
    4e8c:	4785                	li	a5,1
    4e8e:	02f90b63          	beq	s2,a5,4ec4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4e92:	20200593          	li	a1,514
    4e96:	fa840513          	addi	a0,s0,-88
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	d34080e7          	jalr	-716(ra) # 5bce <open>
      if(fd < 0){
    4ea2:	26055c63          	bgez	a0,511a <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ea6:	fa840593          	addi	a1,s0,-88
    4eaa:	00003517          	auipc	a0,0x3
    4eae:	fd650513          	addi	a0,a0,-42 # 7e80 <malloc+0x1eaa>
    4eb2:	00001097          	auipc	ra,0x1
    4eb6:	06c080e7          	jalr	108(ra) # 5f1e <printf>
        exit(1);
    4eba:	4505                	li	a0,1
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	cd2080e7          	jalr	-814(ra) # 5b8e <exit>
      link("C0", file);
    4ec4:	fa840593          	addi	a1,s0,-88
    4ec8:	00003517          	auipc	a0,0x3
    4ecc:	fb050513          	addi	a0,a0,-80 # 7e78 <malloc+0x1ea2>
    4ed0:	00001097          	auipc	ra,0x1
    4ed4:	d1e080e7          	jalr	-738(ra) # 5bee <link>
      exit(0);
    4ed8:	4501                	li	a0,0
    4eda:	00001097          	auipc	ra,0x1
    4ede:	cb4080e7          	jalr	-844(ra) # 5b8e <exit>
        exit(1);
    4ee2:	4505                	li	a0,1
    4ee4:	00001097          	auipc	ra,0x1
    4ee8:	caa080e7          	jalr	-854(ra) # 5b8e <exit>
  memset(fa, 0, sizeof(fa));
    4eec:	02800613          	li	a2,40
    4ef0:	4581                	li	a1,0
    4ef2:	f8040513          	addi	a0,s0,-128
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	a9e080e7          	jalr	-1378(ra) # 5994 <memset>
  fd = open(".", 0);
    4efe:	4581                	li	a1,0
    4f00:	00002517          	auipc	a0,0x2
    4f04:	90050513          	addi	a0,a0,-1792 # 6800 <malloc+0x82a>
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	cc6080e7          	jalr	-826(ra) # 5bce <open>
    4f10:	892a                	mv	s2,a0
  n = 0;
    4f12:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f14:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f18:	02700b13          	li	s6,39
      fa[i] = 1;
    4f1c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f1e:	4641                	li	a2,16
    4f20:	f7040593          	addi	a1,s0,-144
    4f24:	854a                	mv	a0,s2
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	c80080e7          	jalr	-896(ra) # 5ba6 <read>
    4f2e:	08a05263          	blez	a0,4fb2 <concreate+0x174>
    if(de.inum == 0)
    4f32:	f7045783          	lhu	a5,-144(s0)
    4f36:	d7e5                	beqz	a5,4f1e <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f38:	f7244783          	lbu	a5,-142(s0)
    4f3c:	ff4791e3          	bne	a5,s4,4f1e <concreate+0xe0>
    4f40:	f7444783          	lbu	a5,-140(s0)
    4f44:	ffe9                	bnez	a5,4f1e <concreate+0xe0>
      i = de.name[1] - '0';
    4f46:	f7344783          	lbu	a5,-141(s0)
    4f4a:	fd07879b          	addiw	a5,a5,-48
    4f4e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f52:	02eb6063          	bltu	s6,a4,4f72 <concreate+0x134>
      if(fa[i]){
    4f56:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    4f5a:	97a2                	add	a5,a5,s0
    4f5c:	fd07c783          	lbu	a5,-48(a5)
    4f60:	eb8d                	bnez	a5,4f92 <concreate+0x154>
      fa[i] = 1;
    4f62:	fb070793          	addi	a5,a4,-80
    4f66:	00878733          	add	a4,a5,s0
    4f6a:	fd770823          	sb	s7,-48(a4)
      n++;
    4f6e:	2a85                	addiw	s5,s5,1
    4f70:	b77d                	j	4f1e <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f72:	f7240613          	addi	a2,s0,-142
    4f76:	85ce                	mv	a1,s3
    4f78:	00003517          	auipc	a0,0x3
    4f7c:	f2850513          	addi	a0,a0,-216 # 7ea0 <malloc+0x1eca>
    4f80:	00001097          	auipc	ra,0x1
    4f84:	f9e080e7          	jalr	-98(ra) # 5f1e <printf>
        exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	c04080e7          	jalr	-1020(ra) # 5b8e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4f92:	f7240613          	addi	a2,s0,-142
    4f96:	85ce                	mv	a1,s3
    4f98:	00003517          	auipc	a0,0x3
    4f9c:	f2850513          	addi	a0,a0,-216 # 7ec0 <malloc+0x1eea>
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	f7e080e7          	jalr	-130(ra) # 5f1e <printf>
        exit(1);
    4fa8:	4505                	li	a0,1
    4faa:	00001097          	auipc	ra,0x1
    4fae:	be4080e7          	jalr	-1052(ra) # 5b8e <exit>
  close(fd);
    4fb2:	854a                	mv	a0,s2
    4fb4:	00001097          	auipc	ra,0x1
    4fb8:	c02080e7          	jalr	-1022(ra) # 5bb6 <close>
  if(n != N){
    4fbc:	02800793          	li	a5,40
    4fc0:	00fa9763          	bne	s5,a5,4fce <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fc4:	4a8d                	li	s5,3
    4fc6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fc8:	02800a13          	li	s4,40
    4fcc:	a8c9                	j	509e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4fce:	85ce                	mv	a1,s3
    4fd0:	00003517          	auipc	a0,0x3
    4fd4:	f1850513          	addi	a0,a0,-232 # 7ee8 <malloc+0x1f12>
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	f46080e7          	jalr	-186(ra) # 5f1e <printf>
    exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	bac080e7          	jalr	-1108(ra) # 5b8e <exit>
      printf("%s: fork failed\n", s);
    4fea:	85ce                	mv	a1,s3
    4fec:	00002517          	auipc	a0,0x2
    4ff0:	9b450513          	addi	a0,a0,-1612 # 69a0 <malloc+0x9ca>
    4ff4:	00001097          	auipc	ra,0x1
    4ff8:	f2a080e7          	jalr	-214(ra) # 5f1e <printf>
      exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00001097          	auipc	ra,0x1
    5002:	b90080e7          	jalr	-1136(ra) # 5b8e <exit>
      close(open(file, 0));
    5006:	4581                	li	a1,0
    5008:	fa840513          	addi	a0,s0,-88
    500c:	00001097          	auipc	ra,0x1
    5010:	bc2080e7          	jalr	-1086(ra) # 5bce <open>
    5014:	00001097          	auipc	ra,0x1
    5018:	ba2080e7          	jalr	-1118(ra) # 5bb6 <close>
      close(open(file, 0));
    501c:	4581                	li	a1,0
    501e:	fa840513          	addi	a0,s0,-88
    5022:	00001097          	auipc	ra,0x1
    5026:	bac080e7          	jalr	-1108(ra) # 5bce <open>
    502a:	00001097          	auipc	ra,0x1
    502e:	b8c080e7          	jalr	-1140(ra) # 5bb6 <close>
      close(open(file, 0));
    5032:	4581                	li	a1,0
    5034:	fa840513          	addi	a0,s0,-88
    5038:	00001097          	auipc	ra,0x1
    503c:	b96080e7          	jalr	-1130(ra) # 5bce <open>
    5040:	00001097          	auipc	ra,0x1
    5044:	b76080e7          	jalr	-1162(ra) # 5bb6 <close>
      close(open(file, 0));
    5048:	4581                	li	a1,0
    504a:	fa840513          	addi	a0,s0,-88
    504e:	00001097          	auipc	ra,0x1
    5052:	b80080e7          	jalr	-1152(ra) # 5bce <open>
    5056:	00001097          	auipc	ra,0x1
    505a:	b60080e7          	jalr	-1184(ra) # 5bb6 <close>
      close(open(file, 0));
    505e:	4581                	li	a1,0
    5060:	fa840513          	addi	a0,s0,-88
    5064:	00001097          	auipc	ra,0x1
    5068:	b6a080e7          	jalr	-1174(ra) # 5bce <open>
    506c:	00001097          	auipc	ra,0x1
    5070:	b4a080e7          	jalr	-1206(ra) # 5bb6 <close>
      close(open(file, 0));
    5074:	4581                	li	a1,0
    5076:	fa840513          	addi	a0,s0,-88
    507a:	00001097          	auipc	ra,0x1
    507e:	b54080e7          	jalr	-1196(ra) # 5bce <open>
    5082:	00001097          	auipc	ra,0x1
    5086:	b34080e7          	jalr	-1228(ra) # 5bb6 <close>
    if(pid == 0)
    508a:	08090363          	beqz	s2,5110 <concreate+0x2d2>
      wait(0);
    508e:	4501                	li	a0,0
    5090:	00001097          	auipc	ra,0x1
    5094:	b06080e7          	jalr	-1274(ra) # 5b96 <wait>
  for(i = 0; i < N; i++){
    5098:	2485                	addiw	s1,s1,1
    509a:	0f448563          	beq	s1,s4,5184 <concreate+0x346>
    file[1] = '0' + i;
    509e:	0304879b          	addiw	a5,s1,48
    50a2:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50a6:	00001097          	auipc	ra,0x1
    50aa:	ae0080e7          	jalr	-1312(ra) # 5b86 <fork>
    50ae:	892a                	mv	s2,a0
    if(pid < 0){
    50b0:	f2054de3          	bltz	a0,4fea <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50b4:	0354e73b          	remw	a4,s1,s5
    50b8:	00a767b3          	or	a5,a4,a0
    50bc:	2781                	sext.w	a5,a5
    50be:	d7a1                	beqz	a5,5006 <concreate+0x1c8>
    50c0:	01671363          	bne	a4,s6,50c6 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50c4:	f129                	bnez	a0,5006 <concreate+0x1c8>
      unlink(file);
    50c6:	fa840513          	addi	a0,s0,-88
    50ca:	00001097          	auipc	ra,0x1
    50ce:	b14080e7          	jalr	-1260(ra) # 5bde <unlink>
      unlink(file);
    50d2:	fa840513          	addi	a0,s0,-88
    50d6:	00001097          	auipc	ra,0x1
    50da:	b08080e7          	jalr	-1272(ra) # 5bde <unlink>
      unlink(file);
    50de:	fa840513          	addi	a0,s0,-88
    50e2:	00001097          	auipc	ra,0x1
    50e6:	afc080e7          	jalr	-1284(ra) # 5bde <unlink>
      unlink(file);
    50ea:	fa840513          	addi	a0,s0,-88
    50ee:	00001097          	auipc	ra,0x1
    50f2:	af0080e7          	jalr	-1296(ra) # 5bde <unlink>
      unlink(file);
    50f6:	fa840513          	addi	a0,s0,-88
    50fa:	00001097          	auipc	ra,0x1
    50fe:	ae4080e7          	jalr	-1308(ra) # 5bde <unlink>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	ad8080e7          	jalr	-1320(ra) # 5bde <unlink>
    510e:	bfb5                	j	508a <concreate+0x24c>
      exit(0);
    5110:	4501                	li	a0,0
    5112:	00001097          	auipc	ra,0x1
    5116:	a7c080e7          	jalr	-1412(ra) # 5b8e <exit>
      close(fd);
    511a:	00001097          	auipc	ra,0x1
    511e:	a9c080e7          	jalr	-1380(ra) # 5bb6 <close>
    if(pid == 0) {
    5122:	bb5d                	j	4ed8 <concreate+0x9a>
      close(fd);
    5124:	00001097          	auipc	ra,0x1
    5128:	a92080e7          	jalr	-1390(ra) # 5bb6 <close>
      wait(&xstatus);
    512c:	f6c40513          	addi	a0,s0,-148
    5130:	00001097          	auipc	ra,0x1
    5134:	a66080e7          	jalr	-1434(ra) # 5b96 <wait>
      if(xstatus != 0)
    5138:	f6c42483          	lw	s1,-148(s0)
    513c:	da0493e3          	bnez	s1,4ee2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5140:	2905                	addiw	s2,s2,1
    5142:	db4905e3          	beq	s2,s4,4eec <concreate+0xae>
    file[1] = '0' + i;
    5146:	0309079b          	addiw	a5,s2,48
    514a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    514e:	fa840513          	addi	a0,s0,-88
    5152:	00001097          	auipc	ra,0x1
    5156:	a8c080e7          	jalr	-1396(ra) # 5bde <unlink>
    pid = fork();
    515a:	00001097          	auipc	ra,0x1
    515e:	a2c080e7          	jalr	-1492(ra) # 5b86 <fork>
    if(pid && (i % 3) == 1){
    5162:	d20502e3          	beqz	a0,4e86 <concreate+0x48>
    5166:	036967bb          	remw	a5,s2,s6
    516a:	d15786e3          	beq	a5,s5,4e76 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    516e:	20200593          	li	a1,514
    5172:	fa840513          	addi	a0,s0,-88
    5176:	00001097          	auipc	ra,0x1
    517a:	a58080e7          	jalr	-1448(ra) # 5bce <open>
      if(fd < 0){
    517e:	fa0553e3          	bgez	a0,5124 <concreate+0x2e6>
    5182:	b315                	j	4ea6 <concreate+0x68>
}
    5184:	60ea                	ld	ra,152(sp)
    5186:	644a                	ld	s0,144(sp)
    5188:	64aa                	ld	s1,136(sp)
    518a:	690a                	ld	s2,128(sp)
    518c:	79e6                	ld	s3,120(sp)
    518e:	7a46                	ld	s4,112(sp)
    5190:	7aa6                	ld	s5,104(sp)
    5192:	7b06                	ld	s6,96(sp)
    5194:	6be6                	ld	s7,88(sp)
    5196:	610d                	addi	sp,sp,160
    5198:	8082                	ret

000000000000519a <bigfile>:
{
    519a:	7139                	addi	sp,sp,-64
    519c:	fc06                	sd	ra,56(sp)
    519e:	f822                	sd	s0,48(sp)
    51a0:	f426                	sd	s1,40(sp)
    51a2:	f04a                	sd	s2,32(sp)
    51a4:	ec4e                	sd	s3,24(sp)
    51a6:	e852                	sd	s4,16(sp)
    51a8:	e456                	sd	s5,8(sp)
    51aa:	0080                	addi	s0,sp,64
    51ac:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51ae:	00003517          	auipc	a0,0x3
    51b2:	d7250513          	addi	a0,a0,-654 # 7f20 <malloc+0x1f4a>
    51b6:	00001097          	auipc	ra,0x1
    51ba:	a28080e7          	jalr	-1496(ra) # 5bde <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51be:	20200593          	li	a1,514
    51c2:	00003517          	auipc	a0,0x3
    51c6:	d5e50513          	addi	a0,a0,-674 # 7f20 <malloc+0x1f4a>
    51ca:	00001097          	auipc	ra,0x1
    51ce:	a04080e7          	jalr	-1532(ra) # 5bce <open>
    51d2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51d4:	4481                	li	s1,0
    memset(buf, i, SZ);
    51d6:	00009917          	auipc	s2,0x9
    51da:	df290913          	addi	s2,s2,-526 # dfc8 <buf>
  for(i = 0; i < N; i++){
    51de:	4a51                	li	s4,20
  if(fd < 0){
    51e0:	0a054063          	bltz	a0,5280 <bigfile+0xe6>
    memset(buf, i, SZ);
    51e4:	25800613          	li	a2,600
    51e8:	85a6                	mv	a1,s1
    51ea:	854a                	mv	a0,s2
    51ec:	00000097          	auipc	ra,0x0
    51f0:	7a8080e7          	jalr	1960(ra) # 5994 <memset>
    if(write(fd, buf, SZ) != SZ){
    51f4:	25800613          	li	a2,600
    51f8:	85ca                	mv	a1,s2
    51fa:	854e                	mv	a0,s3
    51fc:	00001097          	auipc	ra,0x1
    5200:	9b2080e7          	jalr	-1614(ra) # 5bae <write>
    5204:	25800793          	li	a5,600
    5208:	08f51a63          	bne	a0,a5,529c <bigfile+0x102>
  for(i = 0; i < N; i++){
    520c:	2485                	addiw	s1,s1,1
    520e:	fd449be3          	bne	s1,s4,51e4 <bigfile+0x4a>
  close(fd);
    5212:	854e                	mv	a0,s3
    5214:	00001097          	auipc	ra,0x1
    5218:	9a2080e7          	jalr	-1630(ra) # 5bb6 <close>
  fd = open("bigfile.dat", 0);
    521c:	4581                	li	a1,0
    521e:	00003517          	auipc	a0,0x3
    5222:	d0250513          	addi	a0,a0,-766 # 7f20 <malloc+0x1f4a>
    5226:	00001097          	auipc	ra,0x1
    522a:	9a8080e7          	jalr	-1624(ra) # 5bce <open>
    522e:	8a2a                	mv	s4,a0
  total = 0;
    5230:	4981                	li	s3,0
  for(i = 0; ; i++){
    5232:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5234:	00009917          	auipc	s2,0x9
    5238:	d9490913          	addi	s2,s2,-620 # dfc8 <buf>
  if(fd < 0){
    523c:	06054e63          	bltz	a0,52b8 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5240:	12c00613          	li	a2,300
    5244:	85ca                	mv	a1,s2
    5246:	8552                	mv	a0,s4
    5248:	00001097          	auipc	ra,0x1
    524c:	95e080e7          	jalr	-1698(ra) # 5ba6 <read>
    if(cc < 0){
    5250:	08054263          	bltz	a0,52d4 <bigfile+0x13a>
    if(cc == 0)
    5254:	c971                	beqz	a0,5328 <bigfile+0x18e>
    if(cc != SZ/2){
    5256:	12c00793          	li	a5,300
    525a:	08f51b63          	bne	a0,a5,52f0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    525e:	01f4d79b          	srliw	a5,s1,0x1f
    5262:	9fa5                	addw	a5,a5,s1
    5264:	4017d79b          	sraiw	a5,a5,0x1
    5268:	00094703          	lbu	a4,0(s2)
    526c:	0af71063          	bne	a4,a5,530c <bigfile+0x172>
    5270:	12b94703          	lbu	a4,299(s2)
    5274:	08f71c63          	bne	a4,a5,530c <bigfile+0x172>
    total += cc;
    5278:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    527c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    527e:	b7c9                	j	5240 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5280:	85d6                	mv	a1,s5
    5282:	00003517          	auipc	a0,0x3
    5286:	cae50513          	addi	a0,a0,-850 # 7f30 <malloc+0x1f5a>
    528a:	00001097          	auipc	ra,0x1
    528e:	c94080e7          	jalr	-876(ra) # 5f1e <printf>
    exit(1);
    5292:	4505                	li	a0,1
    5294:	00001097          	auipc	ra,0x1
    5298:	8fa080e7          	jalr	-1798(ra) # 5b8e <exit>
      printf("%s: write bigfile failed\n", s);
    529c:	85d6                	mv	a1,s5
    529e:	00003517          	auipc	a0,0x3
    52a2:	cb250513          	addi	a0,a0,-846 # 7f50 <malloc+0x1f7a>
    52a6:	00001097          	auipc	ra,0x1
    52aa:	c78080e7          	jalr	-904(ra) # 5f1e <printf>
      exit(1);
    52ae:	4505                	li	a0,1
    52b0:	00001097          	auipc	ra,0x1
    52b4:	8de080e7          	jalr	-1826(ra) # 5b8e <exit>
    printf("%s: cannot open bigfile\n", s);
    52b8:	85d6                	mv	a1,s5
    52ba:	00003517          	auipc	a0,0x3
    52be:	cb650513          	addi	a0,a0,-842 # 7f70 <malloc+0x1f9a>
    52c2:	00001097          	auipc	ra,0x1
    52c6:	c5c080e7          	jalr	-932(ra) # 5f1e <printf>
    exit(1);
    52ca:	4505                	li	a0,1
    52cc:	00001097          	auipc	ra,0x1
    52d0:	8c2080e7          	jalr	-1854(ra) # 5b8e <exit>
      printf("%s: read bigfile failed\n", s);
    52d4:	85d6                	mv	a1,s5
    52d6:	00003517          	auipc	a0,0x3
    52da:	cba50513          	addi	a0,a0,-838 # 7f90 <malloc+0x1fba>
    52de:	00001097          	auipc	ra,0x1
    52e2:	c40080e7          	jalr	-960(ra) # 5f1e <printf>
      exit(1);
    52e6:	4505                	li	a0,1
    52e8:	00001097          	auipc	ra,0x1
    52ec:	8a6080e7          	jalr	-1882(ra) # 5b8e <exit>
      printf("%s: short read bigfile\n", s);
    52f0:	85d6                	mv	a1,s5
    52f2:	00003517          	auipc	a0,0x3
    52f6:	cbe50513          	addi	a0,a0,-834 # 7fb0 <malloc+0x1fda>
    52fa:	00001097          	auipc	ra,0x1
    52fe:	c24080e7          	jalr	-988(ra) # 5f1e <printf>
      exit(1);
    5302:	4505                	li	a0,1
    5304:	00001097          	auipc	ra,0x1
    5308:	88a080e7          	jalr	-1910(ra) # 5b8e <exit>
      printf("%s: read bigfile wrong data\n", s);
    530c:	85d6                	mv	a1,s5
    530e:	00003517          	auipc	a0,0x3
    5312:	cba50513          	addi	a0,a0,-838 # 7fc8 <malloc+0x1ff2>
    5316:	00001097          	auipc	ra,0x1
    531a:	c08080e7          	jalr	-1016(ra) # 5f1e <printf>
      exit(1);
    531e:	4505                	li	a0,1
    5320:	00001097          	auipc	ra,0x1
    5324:	86e080e7          	jalr	-1938(ra) # 5b8e <exit>
  close(fd);
    5328:	8552                	mv	a0,s4
    532a:	00001097          	auipc	ra,0x1
    532e:	88c080e7          	jalr	-1908(ra) # 5bb6 <close>
  if(total != N*SZ){
    5332:	678d                	lui	a5,0x3
    5334:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0xa8>
    5338:	02f99363          	bne	s3,a5,535e <bigfile+0x1c4>
  unlink("bigfile.dat");
    533c:	00003517          	auipc	a0,0x3
    5340:	be450513          	addi	a0,a0,-1052 # 7f20 <malloc+0x1f4a>
    5344:	00001097          	auipc	ra,0x1
    5348:	89a080e7          	jalr	-1894(ra) # 5bde <unlink>
}
    534c:	70e2                	ld	ra,56(sp)
    534e:	7442                	ld	s0,48(sp)
    5350:	74a2                	ld	s1,40(sp)
    5352:	7902                	ld	s2,32(sp)
    5354:	69e2                	ld	s3,24(sp)
    5356:	6a42                	ld	s4,16(sp)
    5358:	6aa2                	ld	s5,8(sp)
    535a:	6121                	addi	sp,sp,64
    535c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    535e:	85d6                	mv	a1,s5
    5360:	00003517          	auipc	a0,0x3
    5364:	c8850513          	addi	a0,a0,-888 # 7fe8 <malloc+0x2012>
    5368:	00001097          	auipc	ra,0x1
    536c:	bb6080e7          	jalr	-1098(ra) # 5f1e <printf>
    exit(1);
    5370:	4505                	li	a0,1
    5372:	00001097          	auipc	ra,0x1
    5376:	81c080e7          	jalr	-2020(ra) # 5b8e <exit>

000000000000537a <fsfull>:
{
    537a:	7135                	addi	sp,sp,-160
    537c:	ed06                	sd	ra,152(sp)
    537e:	e922                	sd	s0,144(sp)
    5380:	e526                	sd	s1,136(sp)
    5382:	e14a                	sd	s2,128(sp)
    5384:	fcce                	sd	s3,120(sp)
    5386:	f8d2                	sd	s4,112(sp)
    5388:	f4d6                	sd	s5,104(sp)
    538a:	f0da                	sd	s6,96(sp)
    538c:	ecde                	sd	s7,88(sp)
    538e:	e8e2                	sd	s8,80(sp)
    5390:	e4e6                	sd	s9,72(sp)
    5392:	e0ea                	sd	s10,64(sp)
    5394:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    5396:	00003517          	auipc	a0,0x3
    539a:	c7250513          	addi	a0,a0,-910 # 8008 <malloc+0x2032>
    539e:	00001097          	auipc	ra,0x1
    53a2:	b80080e7          	jalr	-1152(ra) # 5f1e <printf>
  for(nfiles = 0; ; nfiles++){
    53a6:	4481                	li	s1,0
    name[0] = 'f';
    53a8:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53ac:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53b0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53b4:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53b6:	00003c97          	auipc	s9,0x3
    53ba:	c62c8c93          	addi	s9,s9,-926 # 8018 <malloc+0x2042>
    name[0] = 'f';
    53be:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53c2:	0384c7bb          	divw	a5,s1,s8
    53c6:	0307879b          	addiw	a5,a5,48
    53ca:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53ce:	0384e7bb          	remw	a5,s1,s8
    53d2:	0377c7bb          	divw	a5,a5,s7
    53d6:	0307879b          	addiw	a5,a5,48
    53da:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53de:	0374e7bb          	remw	a5,s1,s7
    53e2:	0367c7bb          	divw	a5,a5,s6
    53e6:	0307879b          	addiw	a5,a5,48
    53ea:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    53ee:	0364e7bb          	remw	a5,s1,s6
    53f2:	0307879b          	addiw	a5,a5,48
    53f6:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    53fa:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    53fe:	f6040593          	addi	a1,s0,-160
    5402:	8566                	mv	a0,s9
    5404:	00001097          	auipc	ra,0x1
    5408:	b1a080e7          	jalr	-1254(ra) # 5f1e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    540c:	20200593          	li	a1,514
    5410:	f6040513          	addi	a0,s0,-160
    5414:	00000097          	auipc	ra,0x0
    5418:	7ba080e7          	jalr	1978(ra) # 5bce <open>
    541c:	892a                	mv	s2,a0
    if(fd < 0){
    541e:	0a055563          	bgez	a0,54c8 <fsfull+0x14e>
      printf("open %s failed\n", name);
    5422:	f6040593          	addi	a1,s0,-160
    5426:	00003517          	auipc	a0,0x3
    542a:	c0250513          	addi	a0,a0,-1022 # 8028 <malloc+0x2052>
    542e:	00001097          	auipc	ra,0x1
    5432:	af0080e7          	jalr	-1296(ra) # 5f1e <printf>
  while(nfiles >= 0){
    5436:	0604c363          	bltz	s1,549c <fsfull+0x122>
    name[0] = 'f';
    543a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    543e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5442:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5446:	4929                	li	s2,10
  while(nfiles >= 0){
    5448:	5afd                	li	s5,-1
    name[0] = 'f';
    544a:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    544e:	0344c7bb          	divw	a5,s1,s4
    5452:	0307879b          	addiw	a5,a5,48
    5456:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    545a:	0344e7bb          	remw	a5,s1,s4
    545e:	0337c7bb          	divw	a5,a5,s3
    5462:	0307879b          	addiw	a5,a5,48
    5466:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    546a:	0334e7bb          	remw	a5,s1,s3
    546e:	0327c7bb          	divw	a5,a5,s2
    5472:	0307879b          	addiw	a5,a5,48
    5476:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    547a:	0324e7bb          	remw	a5,s1,s2
    547e:	0307879b          	addiw	a5,a5,48
    5482:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5486:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    548a:	f6040513          	addi	a0,s0,-160
    548e:	00000097          	auipc	ra,0x0
    5492:	750080e7          	jalr	1872(ra) # 5bde <unlink>
    nfiles--;
    5496:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5498:	fb5499e3          	bne	s1,s5,544a <fsfull+0xd0>
  printf("fsfull test finished\n");
    549c:	00003517          	auipc	a0,0x3
    54a0:	bac50513          	addi	a0,a0,-1108 # 8048 <malloc+0x2072>
    54a4:	00001097          	auipc	ra,0x1
    54a8:	a7a080e7          	jalr	-1414(ra) # 5f1e <printf>
}
    54ac:	60ea                	ld	ra,152(sp)
    54ae:	644a                	ld	s0,144(sp)
    54b0:	64aa                	ld	s1,136(sp)
    54b2:	690a                	ld	s2,128(sp)
    54b4:	79e6                	ld	s3,120(sp)
    54b6:	7a46                	ld	s4,112(sp)
    54b8:	7aa6                	ld	s5,104(sp)
    54ba:	7b06                	ld	s6,96(sp)
    54bc:	6be6                	ld	s7,88(sp)
    54be:	6c46                	ld	s8,80(sp)
    54c0:	6ca6                	ld	s9,72(sp)
    54c2:	6d06                	ld	s10,64(sp)
    54c4:	610d                	addi	sp,sp,160
    54c6:	8082                	ret
    int total = 0;
    54c8:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54ca:	00009a97          	auipc	s5,0x9
    54ce:	afea8a93          	addi	s5,s5,-1282 # dfc8 <buf>
      if(cc < BSIZE)
    54d2:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54d6:	40000613          	li	a2,1024
    54da:	85d6                	mv	a1,s5
    54dc:	854a                	mv	a0,s2
    54de:	00000097          	auipc	ra,0x0
    54e2:	6d0080e7          	jalr	1744(ra) # 5bae <write>
      if(cc < BSIZE)
    54e6:	00aa5563          	bge	s4,a0,54f0 <fsfull+0x176>
      total += cc;
    54ea:	00a989bb          	addw	s3,s3,a0
    while(1){
    54ee:	b7e5                	j	54d6 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    54f0:	85ce                	mv	a1,s3
    54f2:	00003517          	auipc	a0,0x3
    54f6:	b4650513          	addi	a0,a0,-1210 # 8038 <malloc+0x2062>
    54fa:	00001097          	auipc	ra,0x1
    54fe:	a24080e7          	jalr	-1500(ra) # 5f1e <printf>
    close(fd);
    5502:	854a                	mv	a0,s2
    5504:	00000097          	auipc	ra,0x0
    5508:	6b2080e7          	jalr	1714(ra) # 5bb6 <close>
    if(total == 0)
    550c:	f20985e3          	beqz	s3,5436 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5510:	2485                	addiw	s1,s1,1
    5512:	b575                	j	53be <fsfull+0x44>

0000000000005514 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5514:	7179                	addi	sp,sp,-48
    5516:	f406                	sd	ra,40(sp)
    5518:	f022                	sd	s0,32(sp)
    551a:	ec26                	sd	s1,24(sp)
    551c:	e84a                	sd	s2,16(sp)
    551e:	1800                	addi	s0,sp,48
    5520:	84aa                	mv	s1,a0
    5522:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5524:	00003517          	auipc	a0,0x3
    5528:	b3c50513          	addi	a0,a0,-1220 # 8060 <malloc+0x208a>
    552c:	00001097          	auipc	ra,0x1
    5530:	9f2080e7          	jalr	-1550(ra) # 5f1e <printf>
  if((pid = fork()) < 0) {
    5534:	00000097          	auipc	ra,0x0
    5538:	652080e7          	jalr	1618(ra) # 5b86 <fork>
    553c:	02054e63          	bltz	a0,5578 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5540:	c929                	beqz	a0,5592 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5542:	fdc40513          	addi	a0,s0,-36
    5546:	00000097          	auipc	ra,0x0
    554a:	650080e7          	jalr	1616(ra) # 5b96 <wait>
    if(xstatus != 0) 
    554e:	fdc42783          	lw	a5,-36(s0)
    5552:	c7b9                	beqz	a5,55a0 <run+0x8c>
      printf("FAILED\n");
    5554:	00003517          	auipc	a0,0x3
    5558:	b3450513          	addi	a0,a0,-1228 # 8088 <malloc+0x20b2>
    555c:	00001097          	auipc	ra,0x1
    5560:	9c2080e7          	jalr	-1598(ra) # 5f1e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5564:	fdc42503          	lw	a0,-36(s0)
  }
}
    5568:	00153513          	seqz	a0,a0
    556c:	70a2                	ld	ra,40(sp)
    556e:	7402                	ld	s0,32(sp)
    5570:	64e2                	ld	s1,24(sp)
    5572:	6942                	ld	s2,16(sp)
    5574:	6145                	addi	sp,sp,48
    5576:	8082                	ret
    printf("runtest: fork error\n");
    5578:	00003517          	auipc	a0,0x3
    557c:	af850513          	addi	a0,a0,-1288 # 8070 <malloc+0x209a>
    5580:	00001097          	auipc	ra,0x1
    5584:	99e080e7          	jalr	-1634(ra) # 5f1e <printf>
    exit(1);
    5588:	4505                	li	a0,1
    558a:	00000097          	auipc	ra,0x0
    558e:	604080e7          	jalr	1540(ra) # 5b8e <exit>
    f(s);
    5592:	854a                	mv	a0,s2
    5594:	9482                	jalr	s1
    exit(0);
    5596:	4501                	li	a0,0
    5598:	00000097          	auipc	ra,0x0
    559c:	5f6080e7          	jalr	1526(ra) # 5b8e <exit>
      printf("OK\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	af050513          	addi	a0,a0,-1296 # 8090 <malloc+0x20ba>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	976080e7          	jalr	-1674(ra) # 5f1e <printf>
    55b0:	bf55                	j	5564 <run+0x50>

00000000000055b2 <runtests>:

int
runtests(struct test *tests, char *justone) {
    55b2:	1101                	addi	sp,sp,-32
    55b4:	ec06                	sd	ra,24(sp)
    55b6:	e822                	sd	s0,16(sp)
    55b8:	e426                	sd	s1,8(sp)
    55ba:	e04a                	sd	s2,0(sp)
    55bc:	1000                	addi	s0,sp,32
    55be:	84aa                	mv	s1,a0
    55c0:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55c2:	6508                	ld	a0,8(a0)
    55c4:	ed09                	bnez	a0,55de <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55c6:	4501                	li	a0,0
    55c8:	a82d                	j	5602 <runtests+0x50>
      if(!run(t->f, t->s)){
    55ca:	648c                	ld	a1,8(s1)
    55cc:	6088                	ld	a0,0(s1)
    55ce:	00000097          	auipc	ra,0x0
    55d2:	f46080e7          	jalr	-186(ra) # 5514 <run>
    55d6:	cd09                	beqz	a0,55f0 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    55d8:	04c1                	addi	s1,s1,16
    55da:	6488                	ld	a0,8(s1)
    55dc:	c11d                	beqz	a0,5602 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55de:	fe0906e3          	beqz	s2,55ca <runtests+0x18>
    55e2:	85ca                	mv	a1,s2
    55e4:	00000097          	auipc	ra,0x0
    55e8:	35a080e7          	jalr	858(ra) # 593e <strcmp>
    55ec:	f575                	bnez	a0,55d8 <runtests+0x26>
    55ee:	bff1                	j	55ca <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    55f0:	00003517          	auipc	a0,0x3
    55f4:	aa850513          	addi	a0,a0,-1368 # 8098 <malloc+0x20c2>
    55f8:	00001097          	auipc	ra,0x1
    55fc:	926080e7          	jalr	-1754(ra) # 5f1e <printf>
        return 1;
    5600:	4505                	li	a0,1
}
    5602:	60e2                	ld	ra,24(sp)
    5604:	6442                	ld	s0,16(sp)
    5606:	64a2                	ld	s1,8(sp)
    5608:	6902                	ld	s2,0(sp)
    560a:	6105                	addi	sp,sp,32
    560c:	8082                	ret

000000000000560e <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    560e:	7139                	addi	sp,sp,-64
    5610:	fc06                	sd	ra,56(sp)
    5612:	f822                	sd	s0,48(sp)
    5614:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5616:	fc840513          	addi	a0,s0,-56
    561a:	00000097          	auipc	ra,0x0
    561e:	584080e7          	jalr	1412(ra) # 5b9e <pipe>
    5622:	06054a63          	bltz	a0,5696 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5626:	00000097          	auipc	ra,0x0
    562a:	560080e7          	jalr	1376(ra) # 5b86 <fork>

  if(pid < 0){
    562e:	08054463          	bltz	a0,56b6 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5632:	e55d                	bnez	a0,56e0 <countfree+0xd2>
    5634:	f426                	sd	s1,40(sp)
    5636:	f04a                	sd	s2,32(sp)
    5638:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    563a:	fc842503          	lw	a0,-56(s0)
    563e:	00000097          	auipc	ra,0x0
    5642:	578080e7          	jalr	1400(ra) # 5bb6 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5646:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5648:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    564a:	00001997          	auipc	s3,0x1
    564e:	b3e98993          	addi	s3,s3,-1218 # 6188 <malloc+0x1b2>
      uint64 a = (uint64) sbrk(4096);
    5652:	6505                	lui	a0,0x1
    5654:	00000097          	auipc	ra,0x0
    5658:	5c2080e7          	jalr	1474(ra) # 5c16 <sbrk>
      if(a == 0xffffffffffffffff){
    565c:	07250d63          	beq	a0,s2,56d6 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    5660:	6785                	lui	a5,0x1
    5662:	97aa                	add	a5,a5,a0
    5664:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if(write(fds[1], "x", 1) != 1){
    5668:	8626                	mv	a2,s1
    566a:	85ce                	mv	a1,s3
    566c:	fcc42503          	lw	a0,-52(s0)
    5670:	00000097          	auipc	ra,0x0
    5674:	53e080e7          	jalr	1342(ra) # 5bae <write>
    5678:	fc950de3          	beq	a0,s1,5652 <countfree+0x44>
        printf("write() failed in countfree()\n");
    567c:	00003517          	auipc	a0,0x3
    5680:	a7450513          	addi	a0,a0,-1420 # 80f0 <malloc+0x211a>
    5684:	00001097          	auipc	ra,0x1
    5688:	89a080e7          	jalr	-1894(ra) # 5f1e <printf>
        exit(1);
    568c:	4505                	li	a0,1
    568e:	00000097          	auipc	ra,0x0
    5692:	500080e7          	jalr	1280(ra) # 5b8e <exit>
    5696:	f426                	sd	s1,40(sp)
    5698:	f04a                	sd	s2,32(sp)
    569a:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    569c:	00003517          	auipc	a0,0x3
    56a0:	a1450513          	addi	a0,a0,-1516 # 80b0 <malloc+0x20da>
    56a4:	00001097          	auipc	ra,0x1
    56a8:	87a080e7          	jalr	-1926(ra) # 5f1e <printf>
    exit(1);
    56ac:	4505                	li	a0,1
    56ae:	00000097          	auipc	ra,0x0
    56b2:	4e0080e7          	jalr	1248(ra) # 5b8e <exit>
    56b6:	f426                	sd	s1,40(sp)
    56b8:	f04a                	sd	s2,32(sp)
    56ba:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    56bc:	00003517          	auipc	a0,0x3
    56c0:	a1450513          	addi	a0,a0,-1516 # 80d0 <malloc+0x20fa>
    56c4:	00001097          	auipc	ra,0x1
    56c8:	85a080e7          	jalr	-1958(ra) # 5f1e <printf>
    exit(1);
    56cc:	4505                	li	a0,1
    56ce:	00000097          	auipc	ra,0x0
    56d2:	4c0080e7          	jalr	1216(ra) # 5b8e <exit>
      }
    }

    exit(0);
    56d6:	4501                	li	a0,0
    56d8:	00000097          	auipc	ra,0x0
    56dc:	4b6080e7          	jalr	1206(ra) # 5b8e <exit>
    56e0:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    56e2:	fcc42503          	lw	a0,-52(s0)
    56e6:	00000097          	auipc	ra,0x0
    56ea:	4d0080e7          	jalr	1232(ra) # 5bb6 <close>

  int n = 0;
    56ee:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    56f0:	4605                	li	a2,1
    56f2:	fc740593          	addi	a1,s0,-57
    56f6:	fc842503          	lw	a0,-56(s0)
    56fa:	00000097          	auipc	ra,0x0
    56fe:	4ac080e7          	jalr	1196(ra) # 5ba6 <read>
    if(cc < 0){
    5702:	00054563          	bltz	a0,570c <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5706:	c115                	beqz	a0,572a <countfree+0x11c>
      break;
    n += 1;
    5708:	2485                	addiw	s1,s1,1
  while(1){
    570a:	b7dd                	j	56f0 <countfree+0xe2>
    570c:	f04a                	sd	s2,32(sp)
    570e:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    5710:	00003517          	auipc	a0,0x3
    5714:	a0050513          	addi	a0,a0,-1536 # 8110 <malloc+0x213a>
    5718:	00001097          	auipc	ra,0x1
    571c:	806080e7          	jalr	-2042(ra) # 5f1e <printf>
      exit(1);
    5720:	4505                	li	a0,1
    5722:	00000097          	auipc	ra,0x0
    5726:	46c080e7          	jalr	1132(ra) # 5b8e <exit>
  }

  close(fds[0]);
    572a:	fc842503          	lw	a0,-56(s0)
    572e:	00000097          	auipc	ra,0x0
    5732:	488080e7          	jalr	1160(ra) # 5bb6 <close>
  wait((int*)0);
    5736:	4501                	li	a0,0
    5738:	00000097          	auipc	ra,0x0
    573c:	45e080e7          	jalr	1118(ra) # 5b96 <wait>
  
  return n;
}
    5740:	8526                	mv	a0,s1
    5742:	74a2                	ld	s1,40(sp)
    5744:	70e2                	ld	ra,56(sp)
    5746:	7442                	ld	s0,48(sp)
    5748:	6121                	addi	sp,sp,64
    574a:	8082                	ret

000000000000574c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    574c:	711d                	addi	sp,sp,-96
    574e:	ec86                	sd	ra,88(sp)
    5750:	e8a2                	sd	s0,80(sp)
    5752:	e4a6                	sd	s1,72(sp)
    5754:	e0ca                	sd	s2,64(sp)
    5756:	fc4e                	sd	s3,56(sp)
    5758:	f852                	sd	s4,48(sp)
    575a:	f456                	sd	s5,40(sp)
    575c:	f05a                	sd	s6,32(sp)
    575e:	ec5e                	sd	s7,24(sp)
    5760:	e862                	sd	s8,16(sp)
    5762:	e466                	sd	s9,8(sp)
    5764:	e06a                	sd	s10,0(sp)
    5766:	1080                	addi	s0,sp,96
    5768:	8aaa                	mv	s5,a0
    576a:	89ae                	mv	s3,a1
    576c:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    576e:	00003b97          	auipc	s7,0x3
    5772:	9c2b8b93          	addi	s7,s7,-1598 # 8130 <malloc+0x215a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5776:	00005b17          	auipc	s6,0x5
    577a:	bfab0b13          	addi	s6,s6,-1030 # a370 <quicktests>
      if(continuous != 2) {
    577e:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5780:	00005c17          	auipc	s8,0x5
    5784:	fb0c0c13          	addi	s8,s8,-80 # a730 <slowtests>
        printf("usertests slow tests starting\n");
    5788:	00003d17          	auipc	s10,0x3
    578c:	9c0d0d13          	addi	s10,s10,-1600 # 8148 <malloc+0x2172>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5790:	00003c97          	auipc	s9,0x3
    5794:	9d8c8c93          	addi	s9,s9,-1576 # 8168 <malloc+0x2192>
    5798:	a839                	j	57b6 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    579a:	856a                	mv	a0,s10
    579c:	00000097          	auipc	ra,0x0
    57a0:	782080e7          	jalr	1922(ra) # 5f1e <printf>
    57a4:	a081                	j	57e4 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57a6:	00000097          	auipc	ra,0x0
    57aa:	e68080e7          	jalr	-408(ra) # 560e <countfree>
    57ae:	04954663          	blt	a0,s1,57fa <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57b2:	06098163          	beqz	s3,5814 <drivetests+0xc8>
    printf("usertests starting\n");
    57b6:	855e                	mv	a0,s7
    57b8:	00000097          	auipc	ra,0x0
    57bc:	766080e7          	jalr	1894(ra) # 5f1e <printf>
    int free0 = countfree();
    57c0:	00000097          	auipc	ra,0x0
    57c4:	e4e080e7          	jalr	-434(ra) # 560e <countfree>
    57c8:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57ca:	85ca                	mv	a1,s2
    57cc:	855a                	mv	a0,s6
    57ce:	00000097          	auipc	ra,0x0
    57d2:	de4080e7          	jalr	-540(ra) # 55b2 <runtests>
    57d6:	c119                	beqz	a0,57dc <drivetests+0x90>
      if(continuous != 2) {
    57d8:	03499c63          	bne	s3,s4,5810 <drivetests+0xc4>
    if(!quick) {
    57dc:	fc0a95e3          	bnez	s5,57a6 <drivetests+0x5a>
      if (justone == 0)
    57e0:	fa090de3          	beqz	s2,579a <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57e4:	85ca                	mv	a1,s2
    57e6:	8562                	mv	a0,s8
    57e8:	00000097          	auipc	ra,0x0
    57ec:	dca080e7          	jalr	-566(ra) # 55b2 <runtests>
    57f0:	d95d                	beqz	a0,57a6 <drivetests+0x5a>
        if(continuous != 2) {
    57f2:	fb498ae3          	beq	s3,s4,57a6 <drivetests+0x5a>
          return 1;
    57f6:	4505                	li	a0,1
    57f8:	a839                	j	5816 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57fa:	8626                	mv	a2,s1
    57fc:	85aa                	mv	a1,a0
    57fe:	8566                	mv	a0,s9
    5800:	00000097          	auipc	ra,0x0
    5804:	71e080e7          	jalr	1822(ra) # 5f1e <printf>
      if(continuous != 2) {
    5808:	fb4987e3          	beq	s3,s4,57b6 <drivetests+0x6a>
        return 1;
    580c:	4505                	li	a0,1
    580e:	a021                	j	5816 <drivetests+0xca>
        return 1;
    5810:	4505                	li	a0,1
    5812:	a011                	j	5816 <drivetests+0xca>
  return 0;
    5814:	854e                	mv	a0,s3
}
    5816:	60e6                	ld	ra,88(sp)
    5818:	6446                	ld	s0,80(sp)
    581a:	64a6                	ld	s1,72(sp)
    581c:	6906                	ld	s2,64(sp)
    581e:	79e2                	ld	s3,56(sp)
    5820:	7a42                	ld	s4,48(sp)
    5822:	7aa2                	ld	s5,40(sp)
    5824:	7b02                	ld	s6,32(sp)
    5826:	6be2                	ld	s7,24(sp)
    5828:	6c42                	ld	s8,16(sp)
    582a:	6ca2                	ld	s9,8(sp)
    582c:	6d02                	ld	s10,0(sp)
    582e:	6125                	addi	sp,sp,96
    5830:	8082                	ret

0000000000005832 <main>:

int
main(int argc, char *argv[])
{
    5832:	1101                	addi	sp,sp,-32
    5834:	ec06                	sd	ra,24(sp)
    5836:	e822                	sd	s0,16(sp)
    5838:	e426                	sd	s1,8(sp)
    583a:	e04a                	sd	s2,0(sp)
    583c:	1000                	addi	s0,sp,32
    583e:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5840:	4789                	li	a5,2
    5842:	02f50263          	beq	a0,a5,5866 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5846:	4785                	li	a5,1
    5848:	08a7c063          	blt	a5,a0,58c8 <main+0x96>
  char *justone = 0;
    584c:	4601                	li	a2,0
  int quick = 0;
    584e:	4501                	li	a0,0
  int continuous = 0;
    5850:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5852:	00000097          	auipc	ra,0x0
    5856:	efa080e7          	jalr	-262(ra) # 574c <drivetests>
    585a:	c951                	beqz	a0,58ee <main+0xbc>
    exit(1);
    585c:	4505                	li	a0,1
    585e:	00000097          	auipc	ra,0x0
    5862:	330080e7          	jalr	816(ra) # 5b8e <exit>
    5866:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5868:	00003597          	auipc	a1,0x3
    586c:	93058593          	addi	a1,a1,-1744 # 8198 <malloc+0x21c2>
    5870:	00893503          	ld	a0,8(s2)
    5874:	00000097          	auipc	ra,0x0
    5878:	0ca080e7          	jalr	202(ra) # 593e <strcmp>
    587c:	85aa                	mv	a1,a0
    587e:	e501                	bnez	a0,5886 <main+0x54>
  char *justone = 0;
    5880:	4601                	li	a2,0
    quick = 1;
    5882:	4505                	li	a0,1
    5884:	b7f9                	j	5852 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5886:	00003597          	auipc	a1,0x3
    588a:	91a58593          	addi	a1,a1,-1766 # 81a0 <malloc+0x21ca>
    588e:	00893503          	ld	a0,8(s2)
    5892:	00000097          	auipc	ra,0x0
    5896:	0ac080e7          	jalr	172(ra) # 593e <strcmp>
    589a:	c521                	beqz	a0,58e2 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    589c:	00003597          	auipc	a1,0x3
    58a0:	95458593          	addi	a1,a1,-1708 # 81f0 <malloc+0x221a>
    58a4:	00893503          	ld	a0,8(s2)
    58a8:	00000097          	auipc	ra,0x0
    58ac:	096080e7          	jalr	150(ra) # 593e <strcmp>
    58b0:	cd05                	beqz	a0,58e8 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    58b2:	00893603          	ld	a2,8(s2)
    58b6:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xc0>
    58ba:	02d00793          	li	a5,45
    58be:	00f70563          	beq	a4,a5,58c8 <main+0x96>
  int quick = 0;
    58c2:	4501                	li	a0,0
  int continuous = 0;
    58c4:	4581                	li	a1,0
    58c6:	b771                	j	5852 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58c8:	00003517          	auipc	a0,0x3
    58cc:	8e050513          	addi	a0,a0,-1824 # 81a8 <malloc+0x21d2>
    58d0:	00000097          	auipc	ra,0x0
    58d4:	64e080e7          	jalr	1614(ra) # 5f1e <printf>
    exit(1);
    58d8:	4505                	li	a0,1
    58da:	00000097          	auipc	ra,0x0
    58de:	2b4080e7          	jalr	692(ra) # 5b8e <exit>
  char *justone = 0;
    58e2:	4601                	li	a2,0
    continuous = 1;
    58e4:	4585                	li	a1,1
    58e6:	b7b5                	j	5852 <main+0x20>
    continuous = 2;
    58e8:	85a6                	mv	a1,s1
  char *justone = 0;
    58ea:	4601                	li	a2,0
    58ec:	b79d                	j	5852 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    58ee:	00003517          	auipc	a0,0x3
    58f2:	8ea50513          	addi	a0,a0,-1814 # 81d8 <malloc+0x2202>
    58f6:	00000097          	auipc	ra,0x0
    58fa:	628080e7          	jalr	1576(ra) # 5f1e <printf>
  exit(0);
    58fe:	4501                	li	a0,0
    5900:	00000097          	auipc	ra,0x0
    5904:	28e080e7          	jalr	654(ra) # 5b8e <exit>

0000000000005908 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5908:	1141                	addi	sp,sp,-16
    590a:	e406                	sd	ra,8(sp)
    590c:	e022                	sd	s0,0(sp)
    590e:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5910:	00000097          	auipc	ra,0x0
    5914:	f22080e7          	jalr	-222(ra) # 5832 <main>
  exit(0);
    5918:	4501                	li	a0,0
    591a:	00000097          	auipc	ra,0x0
    591e:	274080e7          	jalr	628(ra) # 5b8e <exit>

0000000000005922 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5922:	1141                	addi	sp,sp,-16
    5924:	e422                	sd	s0,8(sp)
    5926:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5928:	87aa                	mv	a5,a0
    592a:	0585                	addi	a1,a1,1
    592c:	0785                	addi	a5,a5,1
    592e:	fff5c703          	lbu	a4,-1(a1)
    5932:	fee78fa3          	sb	a4,-1(a5)
    5936:	fb75                	bnez	a4,592a <strcpy+0x8>
    ;
  return os;
}
    5938:	6422                	ld	s0,8(sp)
    593a:	0141                	addi	sp,sp,16
    593c:	8082                	ret

000000000000593e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    593e:	1141                	addi	sp,sp,-16
    5940:	e422                	sd	s0,8(sp)
    5942:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5944:	00054783          	lbu	a5,0(a0)
    5948:	cb91                	beqz	a5,595c <strcmp+0x1e>
    594a:	0005c703          	lbu	a4,0(a1)
    594e:	00f71763          	bne	a4,a5,595c <strcmp+0x1e>
    p++, q++;
    5952:	0505                	addi	a0,a0,1
    5954:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5956:	00054783          	lbu	a5,0(a0)
    595a:	fbe5                	bnez	a5,594a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    595c:	0005c503          	lbu	a0,0(a1)
}
    5960:	40a7853b          	subw	a0,a5,a0
    5964:	6422                	ld	s0,8(sp)
    5966:	0141                	addi	sp,sp,16
    5968:	8082                	ret

000000000000596a <strlen>:

uint
strlen(const char *s)
{
    596a:	1141                	addi	sp,sp,-16
    596c:	e422                	sd	s0,8(sp)
    596e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5970:	00054783          	lbu	a5,0(a0)
    5974:	cf91                	beqz	a5,5990 <strlen+0x26>
    5976:	0505                	addi	a0,a0,1
    5978:	87aa                	mv	a5,a0
    597a:	86be                	mv	a3,a5
    597c:	0785                	addi	a5,a5,1
    597e:	fff7c703          	lbu	a4,-1(a5)
    5982:	ff65                	bnez	a4,597a <strlen+0x10>
    5984:	40a6853b          	subw	a0,a3,a0
    5988:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    598a:	6422                	ld	s0,8(sp)
    598c:	0141                	addi	sp,sp,16
    598e:	8082                	ret
  for(n = 0; s[n]; n++)
    5990:	4501                	li	a0,0
    5992:	bfe5                	j	598a <strlen+0x20>

0000000000005994 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5994:	1141                	addi	sp,sp,-16
    5996:	e422                	sd	s0,8(sp)
    5998:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    599a:	ca19                	beqz	a2,59b0 <memset+0x1c>
    599c:	87aa                	mv	a5,a0
    599e:	1602                	slli	a2,a2,0x20
    59a0:	9201                	srli	a2,a2,0x20
    59a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59aa:	0785                	addi	a5,a5,1
    59ac:	fee79de3          	bne	a5,a4,59a6 <memset+0x12>
  }
  return dst;
}
    59b0:	6422                	ld	s0,8(sp)
    59b2:	0141                	addi	sp,sp,16
    59b4:	8082                	ret

00000000000059b6 <strchr>:

char*
strchr(const char *s, char c)
{
    59b6:	1141                	addi	sp,sp,-16
    59b8:	e422                	sd	s0,8(sp)
    59ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59bc:	00054783          	lbu	a5,0(a0)
    59c0:	cb99                	beqz	a5,59d6 <strchr+0x20>
    if(*s == c)
    59c2:	00f58763          	beq	a1,a5,59d0 <strchr+0x1a>
  for(; *s; s++)
    59c6:	0505                	addi	a0,a0,1
    59c8:	00054783          	lbu	a5,0(a0)
    59cc:	fbfd                	bnez	a5,59c2 <strchr+0xc>
      return (char*)s;
  return 0;
    59ce:	4501                	li	a0,0
}
    59d0:	6422                	ld	s0,8(sp)
    59d2:	0141                	addi	sp,sp,16
    59d4:	8082                	ret
  return 0;
    59d6:	4501                	li	a0,0
    59d8:	bfe5                	j	59d0 <strchr+0x1a>

00000000000059da <gets>:

char*
gets(char *buf, int max)
{
    59da:	711d                	addi	sp,sp,-96
    59dc:	ec86                	sd	ra,88(sp)
    59de:	e8a2                	sd	s0,80(sp)
    59e0:	e4a6                	sd	s1,72(sp)
    59e2:	e0ca                	sd	s2,64(sp)
    59e4:	fc4e                	sd	s3,56(sp)
    59e6:	f852                	sd	s4,48(sp)
    59e8:	f456                	sd	s5,40(sp)
    59ea:	f05a                	sd	s6,32(sp)
    59ec:	ec5e                	sd	s7,24(sp)
    59ee:	1080                	addi	s0,sp,96
    59f0:	8baa                	mv	s7,a0
    59f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    59f4:	892a                	mv	s2,a0
    59f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    59f8:	4aa9                	li	s5,10
    59fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    59fc:	89a6                	mv	s3,s1
    59fe:	2485                	addiw	s1,s1,1
    5a00:	0344d863          	bge	s1,s4,5a30 <gets+0x56>
    cc = read(0, &c, 1);
    5a04:	4605                	li	a2,1
    5a06:	faf40593          	addi	a1,s0,-81
    5a0a:	4501                	li	a0,0
    5a0c:	00000097          	auipc	ra,0x0
    5a10:	19a080e7          	jalr	410(ra) # 5ba6 <read>
    if(cc < 1)
    5a14:	00a05e63          	blez	a0,5a30 <gets+0x56>
    buf[i++] = c;
    5a18:	faf44783          	lbu	a5,-81(s0)
    5a1c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a20:	01578763          	beq	a5,s5,5a2e <gets+0x54>
    5a24:	0905                	addi	s2,s2,1
    5a26:	fd679be3          	bne	a5,s6,59fc <gets+0x22>
    buf[i++] = c;
    5a2a:	89a6                	mv	s3,s1
    5a2c:	a011                	j	5a30 <gets+0x56>
    5a2e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a30:	99de                	add	s3,s3,s7
    5a32:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a36:	855e                	mv	a0,s7
    5a38:	60e6                	ld	ra,88(sp)
    5a3a:	6446                	ld	s0,80(sp)
    5a3c:	64a6                	ld	s1,72(sp)
    5a3e:	6906                	ld	s2,64(sp)
    5a40:	79e2                	ld	s3,56(sp)
    5a42:	7a42                	ld	s4,48(sp)
    5a44:	7aa2                	ld	s5,40(sp)
    5a46:	7b02                	ld	s6,32(sp)
    5a48:	6be2                	ld	s7,24(sp)
    5a4a:	6125                	addi	sp,sp,96
    5a4c:	8082                	ret

0000000000005a4e <stat>:

int
stat(const char *n, struct stat *st)
{
    5a4e:	1101                	addi	sp,sp,-32
    5a50:	ec06                	sd	ra,24(sp)
    5a52:	e822                	sd	s0,16(sp)
    5a54:	e04a                	sd	s2,0(sp)
    5a56:	1000                	addi	s0,sp,32
    5a58:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a5a:	4581                	li	a1,0
    5a5c:	00000097          	auipc	ra,0x0
    5a60:	172080e7          	jalr	370(ra) # 5bce <open>
  if(fd < 0)
    5a64:	02054663          	bltz	a0,5a90 <stat+0x42>
    5a68:	e426                	sd	s1,8(sp)
    5a6a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a6c:	85ca                	mv	a1,s2
    5a6e:	00000097          	auipc	ra,0x0
    5a72:	178080e7          	jalr	376(ra) # 5be6 <fstat>
    5a76:	892a                	mv	s2,a0
  close(fd);
    5a78:	8526                	mv	a0,s1
    5a7a:	00000097          	auipc	ra,0x0
    5a7e:	13c080e7          	jalr	316(ra) # 5bb6 <close>
  return r;
    5a82:	64a2                	ld	s1,8(sp)
}
    5a84:	854a                	mv	a0,s2
    5a86:	60e2                	ld	ra,24(sp)
    5a88:	6442                	ld	s0,16(sp)
    5a8a:	6902                	ld	s2,0(sp)
    5a8c:	6105                	addi	sp,sp,32
    5a8e:	8082                	ret
    return -1;
    5a90:	597d                	li	s2,-1
    5a92:	bfcd                	j	5a84 <stat+0x36>

0000000000005a94 <atoi>:

int
atoi(const char *s)
{
    5a94:	1141                	addi	sp,sp,-16
    5a96:	e422                	sd	s0,8(sp)
    5a98:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5a9a:	00054683          	lbu	a3,0(a0)
    5a9e:	fd06879b          	addiw	a5,a3,-48
    5aa2:	0ff7f793          	zext.b	a5,a5
    5aa6:	4625                	li	a2,9
    5aa8:	02f66863          	bltu	a2,a5,5ad8 <atoi+0x44>
    5aac:	872a                	mv	a4,a0
  n = 0;
    5aae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ab0:	0705                	addi	a4,a4,1
    5ab2:	0025179b          	slliw	a5,a0,0x2
    5ab6:	9fa9                	addw	a5,a5,a0
    5ab8:	0017979b          	slliw	a5,a5,0x1
    5abc:	9fb5                	addw	a5,a5,a3
    5abe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ac2:	00074683          	lbu	a3,0(a4)
    5ac6:	fd06879b          	addiw	a5,a3,-48
    5aca:	0ff7f793          	zext.b	a5,a5
    5ace:	fef671e3          	bgeu	a2,a5,5ab0 <atoi+0x1c>
  return n;
}
    5ad2:	6422                	ld	s0,8(sp)
    5ad4:	0141                	addi	sp,sp,16
    5ad6:	8082                	ret
  n = 0;
    5ad8:	4501                	li	a0,0
    5ada:	bfe5                	j	5ad2 <atoi+0x3e>

0000000000005adc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5adc:	1141                	addi	sp,sp,-16
    5ade:	e422                	sd	s0,8(sp)
    5ae0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5ae2:	02b57463          	bgeu	a0,a1,5b0a <memmove+0x2e>
    while(n-- > 0)
    5ae6:	00c05f63          	blez	a2,5b04 <memmove+0x28>
    5aea:	1602                	slli	a2,a2,0x20
    5aec:	9201                	srli	a2,a2,0x20
    5aee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5af2:	872a                	mv	a4,a0
      *dst++ = *src++;
    5af4:	0585                	addi	a1,a1,1
    5af6:	0705                	addi	a4,a4,1
    5af8:	fff5c683          	lbu	a3,-1(a1)
    5afc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b00:	fef71ae3          	bne	a4,a5,5af4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b04:	6422                	ld	s0,8(sp)
    5b06:	0141                	addi	sp,sp,16
    5b08:	8082                	ret
    dst += n;
    5b0a:	00c50733          	add	a4,a0,a2
    src += n;
    5b0e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b10:	fec05ae3          	blez	a2,5b04 <memmove+0x28>
    5b14:	fff6079b          	addiw	a5,a2,-1
    5b18:	1782                	slli	a5,a5,0x20
    5b1a:	9381                	srli	a5,a5,0x20
    5b1c:	fff7c793          	not	a5,a5
    5b20:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b22:	15fd                	addi	a1,a1,-1
    5b24:	177d                	addi	a4,a4,-1
    5b26:	0005c683          	lbu	a3,0(a1)
    5b2a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b2e:	fee79ae3          	bne	a5,a4,5b22 <memmove+0x46>
    5b32:	bfc9                	j	5b04 <memmove+0x28>

0000000000005b34 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b34:	1141                	addi	sp,sp,-16
    5b36:	e422                	sd	s0,8(sp)
    5b38:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b3a:	ca05                	beqz	a2,5b6a <memcmp+0x36>
    5b3c:	fff6069b          	addiw	a3,a2,-1
    5b40:	1682                	slli	a3,a3,0x20
    5b42:	9281                	srli	a3,a3,0x20
    5b44:	0685                	addi	a3,a3,1
    5b46:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b48:	00054783          	lbu	a5,0(a0)
    5b4c:	0005c703          	lbu	a4,0(a1)
    5b50:	00e79863          	bne	a5,a4,5b60 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b54:	0505                	addi	a0,a0,1
    p2++;
    5b56:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b58:	fed518e3          	bne	a0,a3,5b48 <memcmp+0x14>
  }
  return 0;
    5b5c:	4501                	li	a0,0
    5b5e:	a019                	j	5b64 <memcmp+0x30>
      return *p1 - *p2;
    5b60:	40e7853b          	subw	a0,a5,a4
}
    5b64:	6422                	ld	s0,8(sp)
    5b66:	0141                	addi	sp,sp,16
    5b68:	8082                	ret
  return 0;
    5b6a:	4501                	li	a0,0
    5b6c:	bfe5                	j	5b64 <memcmp+0x30>

0000000000005b6e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b6e:	1141                	addi	sp,sp,-16
    5b70:	e406                	sd	ra,8(sp)
    5b72:	e022                	sd	s0,0(sp)
    5b74:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b76:	00000097          	auipc	ra,0x0
    5b7a:	f66080e7          	jalr	-154(ra) # 5adc <memmove>
}
    5b7e:	60a2                	ld	ra,8(sp)
    5b80:	6402                	ld	s0,0(sp)
    5b82:	0141                	addi	sp,sp,16
    5b84:	8082                	ret

0000000000005b86 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b86:	4885                	li	a7,1
 ecall
    5b88:	00000073          	ecall
 ret
    5b8c:	8082                	ret

0000000000005b8e <exit>:
.global exit
exit:
 li a7, SYS_exit
    5b8e:	4889                	li	a7,2
 ecall
    5b90:	00000073          	ecall
 ret
    5b94:	8082                	ret

0000000000005b96 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5b96:	488d                	li	a7,3
 ecall
    5b98:	00000073          	ecall
 ret
    5b9c:	8082                	ret

0000000000005b9e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5b9e:	4891                	li	a7,4
 ecall
    5ba0:	00000073          	ecall
 ret
    5ba4:	8082                	ret

0000000000005ba6 <read>:
.global read
read:
 li a7, SYS_read
    5ba6:	4895                	li	a7,5
 ecall
    5ba8:	00000073          	ecall
 ret
    5bac:	8082                	ret

0000000000005bae <write>:
.global write
write:
 li a7, SYS_write
    5bae:	48c1                	li	a7,16
 ecall
    5bb0:	00000073          	ecall
 ret
    5bb4:	8082                	ret

0000000000005bb6 <close>:
.global close
close:
 li a7, SYS_close
    5bb6:	48d5                	li	a7,21
 ecall
    5bb8:	00000073          	ecall
 ret
    5bbc:	8082                	ret

0000000000005bbe <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bbe:	4899                	li	a7,6
 ecall
    5bc0:	00000073          	ecall
 ret
    5bc4:	8082                	ret

0000000000005bc6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bc6:	489d                	li	a7,7
 ecall
    5bc8:	00000073          	ecall
 ret
    5bcc:	8082                	ret

0000000000005bce <open>:
.global open
open:
 li a7, SYS_open
    5bce:	48bd                	li	a7,15
 ecall
    5bd0:	00000073          	ecall
 ret
    5bd4:	8082                	ret

0000000000005bd6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bd6:	48c5                	li	a7,17
 ecall
    5bd8:	00000073          	ecall
 ret
    5bdc:	8082                	ret

0000000000005bde <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5bde:	48c9                	li	a7,18
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5be6:	48a1                	li	a7,8
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <link>:
.global link
link:
 li a7, SYS_link
    5bee:	48cd                	li	a7,19
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5bf6:	48d1                	li	a7,20
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5bfe:	48a5                	li	a7,9
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c06:	48a9                	li	a7,10
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c0e:	48ad                	li	a7,11
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c16:	48b1                	li	a7,12
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c1e:	48b5                	li	a7,13
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c26:	48b9                	li	a7,14
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c2e:	48d9                	li	a7,22
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
    5c36:	48dd                	li	a7,23
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c3e:	48e1                	li	a7,24
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c46:	48e5                	li	a7,25
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
    5c4e:	48e9                	li	a7,26
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c56:	1101                	addi	sp,sp,-32
    5c58:	ec06                	sd	ra,24(sp)
    5c5a:	e822                	sd	s0,16(sp)
    5c5c:	1000                	addi	s0,sp,32
    5c5e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c62:	4605                	li	a2,1
    5c64:	fef40593          	addi	a1,s0,-17
    5c68:	00000097          	auipc	ra,0x0
    5c6c:	f46080e7          	jalr	-186(ra) # 5bae <write>
}
    5c70:	60e2                	ld	ra,24(sp)
    5c72:	6442                	ld	s0,16(sp)
    5c74:	6105                	addi	sp,sp,32
    5c76:	8082                	ret

0000000000005c78 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c78:	7139                	addi	sp,sp,-64
    5c7a:	fc06                	sd	ra,56(sp)
    5c7c:	f822                	sd	s0,48(sp)
    5c7e:	f426                	sd	s1,40(sp)
    5c80:	0080                	addi	s0,sp,64
    5c82:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c84:	c299                	beqz	a3,5c8a <printint+0x12>
    5c86:	0805cb63          	bltz	a1,5d1c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c8a:	2581                	sext.w	a1,a1
  neg = 0;
    5c8c:	4881                	li	a7,0
    5c8e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5c92:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c94:	2601                	sext.w	a2,a2
    5c96:	00003517          	auipc	a0,0x3
    5c9a:	91250513          	addi	a0,a0,-1774 # 85a8 <digits>
    5c9e:	883a                	mv	a6,a4
    5ca0:	2705                	addiw	a4,a4,1
    5ca2:	02c5f7bb          	remuw	a5,a1,a2
    5ca6:	1782                	slli	a5,a5,0x20
    5ca8:	9381                	srli	a5,a5,0x20
    5caa:	97aa                	add	a5,a5,a0
    5cac:	0007c783          	lbu	a5,0(a5)
    5cb0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cb4:	0005879b          	sext.w	a5,a1
    5cb8:	02c5d5bb          	divuw	a1,a1,a2
    5cbc:	0685                	addi	a3,a3,1
    5cbe:	fec7f0e3          	bgeu	a5,a2,5c9e <printint+0x26>
  if(neg)
    5cc2:	00088c63          	beqz	a7,5cda <printint+0x62>
    buf[i++] = '-';
    5cc6:	fd070793          	addi	a5,a4,-48
    5cca:	00878733          	add	a4,a5,s0
    5cce:	02d00793          	li	a5,45
    5cd2:	fef70823          	sb	a5,-16(a4)
    5cd6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cda:	02e05c63          	blez	a4,5d12 <printint+0x9a>
    5cde:	f04a                	sd	s2,32(sp)
    5ce0:	ec4e                	sd	s3,24(sp)
    5ce2:	fc040793          	addi	a5,s0,-64
    5ce6:	00e78933          	add	s2,a5,a4
    5cea:	fff78993          	addi	s3,a5,-1
    5cee:	99ba                	add	s3,s3,a4
    5cf0:	377d                	addiw	a4,a4,-1
    5cf2:	1702                	slli	a4,a4,0x20
    5cf4:	9301                	srli	a4,a4,0x20
    5cf6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cfa:	fff94583          	lbu	a1,-1(s2)
    5cfe:	8526                	mv	a0,s1
    5d00:	00000097          	auipc	ra,0x0
    5d04:	f56080e7          	jalr	-170(ra) # 5c56 <putc>
  while(--i >= 0)
    5d08:	197d                	addi	s2,s2,-1
    5d0a:	ff3918e3          	bne	s2,s3,5cfa <printint+0x82>
    5d0e:	7902                	ld	s2,32(sp)
    5d10:	69e2                	ld	s3,24(sp)
}
    5d12:	70e2                	ld	ra,56(sp)
    5d14:	7442                	ld	s0,48(sp)
    5d16:	74a2                	ld	s1,40(sp)
    5d18:	6121                	addi	sp,sp,64
    5d1a:	8082                	ret
    x = -xx;
    5d1c:	40b005bb          	negw	a1,a1
    neg = 1;
    5d20:	4885                	li	a7,1
    x = -xx;
    5d22:	b7b5                	j	5c8e <printint+0x16>

0000000000005d24 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d24:	715d                	addi	sp,sp,-80
    5d26:	e486                	sd	ra,72(sp)
    5d28:	e0a2                	sd	s0,64(sp)
    5d2a:	f84a                	sd	s2,48(sp)
    5d2c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d2e:	0005c903          	lbu	s2,0(a1)
    5d32:	1a090a63          	beqz	s2,5ee6 <vprintf+0x1c2>
    5d36:	fc26                	sd	s1,56(sp)
    5d38:	f44e                	sd	s3,40(sp)
    5d3a:	f052                	sd	s4,32(sp)
    5d3c:	ec56                	sd	s5,24(sp)
    5d3e:	e85a                	sd	s6,16(sp)
    5d40:	e45e                	sd	s7,8(sp)
    5d42:	8aaa                	mv	s5,a0
    5d44:	8bb2                	mv	s7,a2
    5d46:	00158493          	addi	s1,a1,1
  state = 0;
    5d4a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d4c:	02500a13          	li	s4,37
    5d50:	4b55                	li	s6,21
    5d52:	a839                	j	5d70 <vprintf+0x4c>
        putc(fd, c);
    5d54:	85ca                	mv	a1,s2
    5d56:	8556                	mv	a0,s5
    5d58:	00000097          	auipc	ra,0x0
    5d5c:	efe080e7          	jalr	-258(ra) # 5c56 <putc>
    5d60:	a019                	j	5d66 <vprintf+0x42>
    } else if(state == '%'){
    5d62:	01498d63          	beq	s3,s4,5d7c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5d66:	0485                	addi	s1,s1,1
    5d68:	fff4c903          	lbu	s2,-1(s1)
    5d6c:	16090763          	beqz	s2,5eda <vprintf+0x1b6>
    if(state == 0){
    5d70:	fe0999e3          	bnez	s3,5d62 <vprintf+0x3e>
      if(c == '%'){
    5d74:	ff4910e3          	bne	s2,s4,5d54 <vprintf+0x30>
        state = '%';
    5d78:	89d2                	mv	s3,s4
    5d7a:	b7f5                	j	5d66 <vprintf+0x42>
      if(c == 'd'){
    5d7c:	13490463          	beq	s2,s4,5ea4 <vprintf+0x180>
    5d80:	f9d9079b          	addiw	a5,s2,-99
    5d84:	0ff7f793          	zext.b	a5,a5
    5d88:	12fb6763          	bltu	s6,a5,5eb6 <vprintf+0x192>
    5d8c:	f9d9079b          	addiw	a5,s2,-99
    5d90:	0ff7f713          	zext.b	a4,a5
    5d94:	12eb6163          	bltu	s6,a4,5eb6 <vprintf+0x192>
    5d98:	00271793          	slli	a5,a4,0x2
    5d9c:	00002717          	auipc	a4,0x2
    5da0:	7b470713          	addi	a4,a4,1972 # 8550 <malloc+0x257a>
    5da4:	97ba                	add	a5,a5,a4
    5da6:	439c                	lw	a5,0(a5)
    5da8:	97ba                	add	a5,a5,a4
    5daa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5dac:	008b8913          	addi	s2,s7,8
    5db0:	4685                	li	a3,1
    5db2:	4629                	li	a2,10
    5db4:	000ba583          	lw	a1,0(s7)
    5db8:	8556                	mv	a0,s5
    5dba:	00000097          	auipc	ra,0x0
    5dbe:	ebe080e7          	jalr	-322(ra) # 5c78 <printint>
    5dc2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5dc4:	4981                	li	s3,0
    5dc6:	b745                	j	5d66 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dc8:	008b8913          	addi	s2,s7,8
    5dcc:	4681                	li	a3,0
    5dce:	4629                	li	a2,10
    5dd0:	000ba583          	lw	a1,0(s7)
    5dd4:	8556                	mv	a0,s5
    5dd6:	00000097          	auipc	ra,0x0
    5dda:	ea2080e7          	jalr	-350(ra) # 5c78 <printint>
    5dde:	8bca                	mv	s7,s2
      state = 0;
    5de0:	4981                	li	s3,0
    5de2:	b751                	j	5d66 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5de4:	008b8913          	addi	s2,s7,8
    5de8:	4681                	li	a3,0
    5dea:	4641                	li	a2,16
    5dec:	000ba583          	lw	a1,0(s7)
    5df0:	8556                	mv	a0,s5
    5df2:	00000097          	auipc	ra,0x0
    5df6:	e86080e7          	jalr	-378(ra) # 5c78 <printint>
    5dfa:	8bca                	mv	s7,s2
      state = 0;
    5dfc:	4981                	li	s3,0
    5dfe:	b7a5                	j	5d66 <vprintf+0x42>
    5e00:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e02:	008b8c13          	addi	s8,s7,8
    5e06:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e0a:	03000593          	li	a1,48
    5e0e:	8556                	mv	a0,s5
    5e10:	00000097          	auipc	ra,0x0
    5e14:	e46080e7          	jalr	-442(ra) # 5c56 <putc>
  putc(fd, 'x');
    5e18:	07800593          	li	a1,120
    5e1c:	8556                	mv	a0,s5
    5e1e:	00000097          	auipc	ra,0x0
    5e22:	e38080e7          	jalr	-456(ra) # 5c56 <putc>
    5e26:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e28:	00002b97          	auipc	s7,0x2
    5e2c:	780b8b93          	addi	s7,s7,1920 # 85a8 <digits>
    5e30:	03c9d793          	srli	a5,s3,0x3c
    5e34:	97de                	add	a5,a5,s7
    5e36:	0007c583          	lbu	a1,0(a5)
    5e3a:	8556                	mv	a0,s5
    5e3c:	00000097          	auipc	ra,0x0
    5e40:	e1a080e7          	jalr	-486(ra) # 5c56 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e44:	0992                	slli	s3,s3,0x4
    5e46:	397d                	addiw	s2,s2,-1
    5e48:	fe0914e3          	bnez	s2,5e30 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5e4c:	8be2                	mv	s7,s8
      state = 0;
    5e4e:	4981                	li	s3,0
    5e50:	6c02                	ld	s8,0(sp)
    5e52:	bf11                	j	5d66 <vprintf+0x42>
        s = va_arg(ap, char*);
    5e54:	008b8993          	addi	s3,s7,8
    5e58:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5e5c:	02090163          	beqz	s2,5e7e <vprintf+0x15a>
        while(*s != 0){
    5e60:	00094583          	lbu	a1,0(s2)
    5e64:	c9a5                	beqz	a1,5ed4 <vprintf+0x1b0>
          putc(fd, *s);
    5e66:	8556                	mv	a0,s5
    5e68:	00000097          	auipc	ra,0x0
    5e6c:	dee080e7          	jalr	-530(ra) # 5c56 <putc>
          s++;
    5e70:	0905                	addi	s2,s2,1
        while(*s != 0){
    5e72:	00094583          	lbu	a1,0(s2)
    5e76:	f9e5                	bnez	a1,5e66 <vprintf+0x142>
        s = va_arg(ap, char*);
    5e78:	8bce                	mv	s7,s3
      state = 0;
    5e7a:	4981                	li	s3,0
    5e7c:	b5ed                	j	5d66 <vprintf+0x42>
          s = "(null)";
    5e7e:	00002917          	auipc	s2,0x2
    5e82:	6aa90913          	addi	s2,s2,1706 # 8528 <malloc+0x2552>
        while(*s != 0){
    5e86:	02800593          	li	a1,40
    5e8a:	bff1                	j	5e66 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5e8c:	008b8913          	addi	s2,s7,8
    5e90:	000bc583          	lbu	a1,0(s7)
    5e94:	8556                	mv	a0,s5
    5e96:	00000097          	auipc	ra,0x0
    5e9a:	dc0080e7          	jalr	-576(ra) # 5c56 <putc>
    5e9e:	8bca                	mv	s7,s2
      state = 0;
    5ea0:	4981                	li	s3,0
    5ea2:	b5d1                	j	5d66 <vprintf+0x42>
        putc(fd, c);
    5ea4:	02500593          	li	a1,37
    5ea8:	8556                	mv	a0,s5
    5eaa:	00000097          	auipc	ra,0x0
    5eae:	dac080e7          	jalr	-596(ra) # 5c56 <putc>
      state = 0;
    5eb2:	4981                	li	s3,0
    5eb4:	bd4d                	j	5d66 <vprintf+0x42>
        putc(fd, '%');
    5eb6:	02500593          	li	a1,37
    5eba:	8556                	mv	a0,s5
    5ebc:	00000097          	auipc	ra,0x0
    5ec0:	d9a080e7          	jalr	-614(ra) # 5c56 <putc>
        putc(fd, c);
    5ec4:	85ca                	mv	a1,s2
    5ec6:	8556                	mv	a0,s5
    5ec8:	00000097          	auipc	ra,0x0
    5ecc:	d8e080e7          	jalr	-626(ra) # 5c56 <putc>
      state = 0;
    5ed0:	4981                	li	s3,0
    5ed2:	bd51                	j	5d66 <vprintf+0x42>
        s = va_arg(ap, char*);
    5ed4:	8bce                	mv	s7,s3
      state = 0;
    5ed6:	4981                	li	s3,0
    5ed8:	b579                	j	5d66 <vprintf+0x42>
    5eda:	74e2                	ld	s1,56(sp)
    5edc:	79a2                	ld	s3,40(sp)
    5ede:	7a02                	ld	s4,32(sp)
    5ee0:	6ae2                	ld	s5,24(sp)
    5ee2:	6b42                	ld	s6,16(sp)
    5ee4:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5ee6:	60a6                	ld	ra,72(sp)
    5ee8:	6406                	ld	s0,64(sp)
    5eea:	7942                	ld	s2,48(sp)
    5eec:	6161                	addi	sp,sp,80
    5eee:	8082                	ret

0000000000005ef0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ef0:	715d                	addi	sp,sp,-80
    5ef2:	ec06                	sd	ra,24(sp)
    5ef4:	e822                	sd	s0,16(sp)
    5ef6:	1000                	addi	s0,sp,32
    5ef8:	e010                	sd	a2,0(s0)
    5efa:	e414                	sd	a3,8(s0)
    5efc:	e818                	sd	a4,16(s0)
    5efe:	ec1c                	sd	a5,24(s0)
    5f00:	03043023          	sd	a6,32(s0)
    5f04:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f08:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f0c:	8622                	mv	a2,s0
    5f0e:	00000097          	auipc	ra,0x0
    5f12:	e16080e7          	jalr	-490(ra) # 5d24 <vprintf>
}
    5f16:	60e2                	ld	ra,24(sp)
    5f18:	6442                	ld	s0,16(sp)
    5f1a:	6161                	addi	sp,sp,80
    5f1c:	8082                	ret

0000000000005f1e <printf>:

void
printf(const char *fmt, ...)
{
    5f1e:	711d                	addi	sp,sp,-96
    5f20:	ec06                	sd	ra,24(sp)
    5f22:	e822                	sd	s0,16(sp)
    5f24:	1000                	addi	s0,sp,32
    5f26:	e40c                	sd	a1,8(s0)
    5f28:	e810                	sd	a2,16(s0)
    5f2a:	ec14                	sd	a3,24(s0)
    5f2c:	f018                	sd	a4,32(s0)
    5f2e:	f41c                	sd	a5,40(s0)
    5f30:	03043823          	sd	a6,48(s0)
    5f34:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f38:	00840613          	addi	a2,s0,8
    5f3c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f40:	85aa                	mv	a1,a0
    5f42:	4505                	li	a0,1
    5f44:	00000097          	auipc	ra,0x0
    5f48:	de0080e7          	jalr	-544(ra) # 5d24 <vprintf>
}
    5f4c:	60e2                	ld	ra,24(sp)
    5f4e:	6442                	ld	s0,16(sp)
    5f50:	6125                	addi	sp,sp,96
    5f52:	8082                	ret

0000000000005f54 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f54:	1141                	addi	sp,sp,-16
    5f56:	e422                	sd	s0,8(sp)
    5f58:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f5a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f5e:	00005797          	auipc	a5,0x5
    5f62:	8427b783          	ld	a5,-1982(a5) # a7a0 <freep>
    5f66:	a02d                	j	5f90 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f68:	4618                	lw	a4,8(a2)
    5f6a:	9f2d                	addw	a4,a4,a1
    5f6c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f70:	6398                	ld	a4,0(a5)
    5f72:	6310                	ld	a2,0(a4)
    5f74:	a83d                	j	5fb2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f76:	ff852703          	lw	a4,-8(a0)
    5f7a:	9f31                	addw	a4,a4,a2
    5f7c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f7e:	ff053683          	ld	a3,-16(a0)
    5f82:	a091                	j	5fc6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f84:	6398                	ld	a4,0(a5)
    5f86:	00e7e463          	bltu	a5,a4,5f8e <free+0x3a>
    5f8a:	00e6ea63          	bltu	a3,a4,5f9e <free+0x4a>
{
    5f8e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f90:	fed7fae3          	bgeu	a5,a3,5f84 <free+0x30>
    5f94:	6398                	ld	a4,0(a5)
    5f96:	00e6e463          	bltu	a3,a4,5f9e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f9a:	fee7eae3          	bltu	a5,a4,5f8e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5f9e:	ff852583          	lw	a1,-8(a0)
    5fa2:	6390                	ld	a2,0(a5)
    5fa4:	02059813          	slli	a6,a1,0x20
    5fa8:	01c85713          	srli	a4,a6,0x1c
    5fac:	9736                	add	a4,a4,a3
    5fae:	fae60de3          	beq	a2,a4,5f68 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fb2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fb6:	4790                	lw	a2,8(a5)
    5fb8:	02061593          	slli	a1,a2,0x20
    5fbc:	01c5d713          	srli	a4,a1,0x1c
    5fc0:	973e                	add	a4,a4,a5
    5fc2:	fae68ae3          	beq	a3,a4,5f76 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fc6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fc8:	00004717          	auipc	a4,0x4
    5fcc:	7cf73c23          	sd	a5,2008(a4) # a7a0 <freep>
}
    5fd0:	6422                	ld	s0,8(sp)
    5fd2:	0141                	addi	sp,sp,16
    5fd4:	8082                	ret

0000000000005fd6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fd6:	7139                	addi	sp,sp,-64
    5fd8:	fc06                	sd	ra,56(sp)
    5fda:	f822                	sd	s0,48(sp)
    5fdc:	f426                	sd	s1,40(sp)
    5fde:	ec4e                	sd	s3,24(sp)
    5fe0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5fe2:	02051493          	slli	s1,a0,0x20
    5fe6:	9081                	srli	s1,s1,0x20
    5fe8:	04bd                	addi	s1,s1,15
    5fea:	8091                	srli	s1,s1,0x4
    5fec:	0014899b          	addiw	s3,s1,1
    5ff0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5ff2:	00004517          	auipc	a0,0x4
    5ff6:	7ae53503          	ld	a0,1966(a0) # a7a0 <freep>
    5ffa:	c915                	beqz	a0,602e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ffc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ffe:	4798                	lw	a4,8(a5)
    6000:	08977e63          	bgeu	a4,s1,609c <malloc+0xc6>
    6004:	f04a                	sd	s2,32(sp)
    6006:	e852                	sd	s4,16(sp)
    6008:	e456                	sd	s5,8(sp)
    600a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    600c:	8a4e                	mv	s4,s3
    600e:	0009871b          	sext.w	a4,s3
    6012:	6685                	lui	a3,0x1
    6014:	00d77363          	bgeu	a4,a3,601a <malloc+0x44>
    6018:	6a05                	lui	s4,0x1
    601a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    601e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6022:	00004917          	auipc	s2,0x4
    6026:	77e90913          	addi	s2,s2,1918 # a7a0 <freep>
  if(p == (char*)-1)
    602a:	5afd                	li	s5,-1
    602c:	a091                	j	6070 <malloc+0x9a>
    602e:	f04a                	sd	s2,32(sp)
    6030:	e852                	sd	s4,16(sp)
    6032:	e456                	sd	s5,8(sp)
    6034:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    6036:	0000b797          	auipc	a5,0xb
    603a:	f9278793          	addi	a5,a5,-110 # 10fc8 <base>
    603e:	00004717          	auipc	a4,0x4
    6042:	76f73123          	sd	a5,1890(a4) # a7a0 <freep>
    6046:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6048:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    604c:	b7c1                	j	600c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    604e:	6398                	ld	a4,0(a5)
    6050:	e118                	sd	a4,0(a0)
    6052:	a08d                	j	60b4 <malloc+0xde>
  hp->s.size = nu;
    6054:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6058:	0541                	addi	a0,a0,16
    605a:	00000097          	auipc	ra,0x0
    605e:	efa080e7          	jalr	-262(ra) # 5f54 <free>
  return freep;
    6062:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6066:	c13d                	beqz	a0,60cc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6068:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    606a:	4798                	lw	a4,8(a5)
    606c:	02977463          	bgeu	a4,s1,6094 <malloc+0xbe>
    if(p == freep)
    6070:	00093703          	ld	a4,0(s2)
    6074:	853e                	mv	a0,a5
    6076:	fef719e3          	bne	a4,a5,6068 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    607a:	8552                	mv	a0,s4
    607c:	00000097          	auipc	ra,0x0
    6080:	b9a080e7          	jalr	-1126(ra) # 5c16 <sbrk>
  if(p == (char*)-1)
    6084:	fd5518e3          	bne	a0,s5,6054 <malloc+0x7e>
        return 0;
    6088:	4501                	li	a0,0
    608a:	7902                	ld	s2,32(sp)
    608c:	6a42                	ld	s4,16(sp)
    608e:	6aa2                	ld	s5,8(sp)
    6090:	6b02                	ld	s6,0(sp)
    6092:	a03d                	j	60c0 <malloc+0xea>
    6094:	7902                	ld	s2,32(sp)
    6096:	6a42                	ld	s4,16(sp)
    6098:	6aa2                	ld	s5,8(sp)
    609a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    609c:	fae489e3          	beq	s1,a4,604e <malloc+0x78>
        p->s.size -= nunits;
    60a0:	4137073b          	subw	a4,a4,s3
    60a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60a6:	02071693          	slli	a3,a4,0x20
    60aa:	01c6d713          	srli	a4,a3,0x1c
    60ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60b4:	00004717          	auipc	a4,0x4
    60b8:	6ea73623          	sd	a0,1772(a4) # a7a0 <freep>
      return (void*)(p + 1);
    60bc:	01078513          	addi	a0,a5,16
  }
}
    60c0:	70e2                	ld	ra,56(sp)
    60c2:	7442                	ld	s0,48(sp)
    60c4:	74a2                	ld	s1,40(sp)
    60c6:	69e2                	ld	s3,24(sp)
    60c8:	6121                	addi	sp,sp,64
    60ca:	8082                	ret
    60cc:	7902                	ld	s2,32(sp)
    60ce:	6a42                	ld	s4,16(sp)
    60d0:	6aa2                	ld	s5,8(sp)
    60d2:	6b02                	ld	s6,0(sp)
    60d4:	b7f5                	j	60c0 <malloc+0xea>
