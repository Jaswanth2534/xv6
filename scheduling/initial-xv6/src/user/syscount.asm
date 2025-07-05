
user/_syscount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find_name>:
    "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write",
    "mknod", "unlink", "link", "mkdir", "close", "waitx", "getSysCount",
    "sigalarm", "sigreturn", "settickets"};

char *find_name(int mask)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    int ind = 0;
    while (mask > 1)
   6:	4785                	li	a5,1
   8:	02a7d463          	bge	a5,a0,30 <find_name+0x30>
    int ind = 0;
   c:	4781                	li	a5,0
    while (mask > 1)
   e:	4705                	li	a4,1
    {
        mask = mask >> 1;
  10:	4015551b          	sraiw	a0,a0,0x1
        ind++;
  14:	2785                	addiw	a5,a5,1
    while (mask > 1)
  16:	fea74de3          	blt	a4,a0,10 <find_name+0x10>
    }

    return syscall_names[ind - 1];
  1a:	37fd                	addiw	a5,a5,-1
  1c:	078e                	slli	a5,a5,0x3
  1e:	00001717          	auipc	a4,0x1
  22:	40270713          	addi	a4,a4,1026 # 1420 <syscall_names>
  26:	97ba                	add	a5,a5,a4
}
  28:	6388                	ld	a0,0(a5)
  2a:	6422                	ld	s0,8(sp)
  2c:	0141                	addi	sp,sp,16
  2e:	8082                	ret
    int ind = 0;
  30:	4781                	li	a5,0
  32:	b7e5                	j	1a <find_name+0x1a>

0000000000000034 <main>:

int main(int argc, char *argv[])
{
  34:	7179                	addi	sp,sp,-48
  36:	f406                	sd	ra,40(sp)
  38:	f022                	sd	s0,32(sp)
  3a:	ec26                	sd	s1,24(sp)
  3c:	e84a                	sd	s2,16(sp)
  3e:	e44e                	sd	s3,8(sp)
  40:	1800                	addi	s0,sp,48
  42:	89aa                	mv	s3,a0
  44:	892e                	mv	s2,a1
    int mask = atoi(argv[1]);
  46:	6588                	ld	a0,8(a1)
  48:	00000097          	auipc	ra,0x0
  4c:	25c080e7          	jalr	604(ra) # 2a4 <atoi>
    if (mask == 0)
  50:	c505                	beqz	a0,78 <main+0x44>
  52:	84aa                	mv	s1,a0
    {
        printf("Invalid mask\n");
        exit(1);
    }

    int pid = fork();
  54:	00000097          	auipc	ra,0x0
  58:	342080e7          	jalr	834(ra) # 396 <fork>
    if (pid < 0)
  5c:	02054b63          	bltz	a0,92 <main+0x5e>
    {
        printf("Fork failed\n");
        exit(1);
    }
    else if (pid == 0)
  60:	e93d                	bnez	a0,d6 <main+0xa2>
    {
        if (argc > 2)
  62:	4789                	li	a5,2
  64:	0537c463          	blt	a5,s3,ac <main+0x78>
        int count = getsyscount(mask);
        printf("PID %d called %s %d times.\n", getpid(), find_name(mask), count);
    }

    return 0;
}
  68:	4501                	li	a0,0
  6a:	70a2                	ld	ra,40(sp)
  6c:	7402                	ld	s0,32(sp)
  6e:	64e2                	ld	s1,24(sp)
  70:	6942                	ld	s2,16(sp)
  72:	69a2                	ld	s3,8(sp)
  74:	6145                	addi	sp,sp,48
  76:	8082                	ret
        printf("Invalid mask\n");
  78:	00001517          	auipc	a0,0x1
  7c:	87850513          	addi	a0,a0,-1928 # 8f0 <malloc+0x10a>
  80:	00000097          	auipc	ra,0x0
  84:	6ae080e7          	jalr	1710(ra) # 72e <printf>
        exit(1);
  88:	4505                	li	a0,1
  8a:	00000097          	auipc	ra,0x0
  8e:	314080e7          	jalr	788(ra) # 39e <exit>
        printf("Fork failed\n");
  92:	00001517          	auipc	a0,0x1
  96:	87650513          	addi	a0,a0,-1930 # 908 <malloc+0x122>
  9a:	00000097          	auipc	ra,0x0
  9e:	694080e7          	jalr	1684(ra) # 72e <printf>
        exit(1);
  a2:	4505                	li	a0,1
  a4:	00000097          	auipc	ra,0x0
  a8:	2fa080e7          	jalr	762(ra) # 39e <exit>
            exec(argv[2], &argv[2]);
  ac:	01090593          	addi	a1,s2,16
  b0:	01093503          	ld	a0,16(s2)
  b4:	00000097          	auipc	ra,0x0
  b8:	322080e7          	jalr	802(ra) # 3d6 <exec>
            printf("Exec failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	85c50513          	addi	a0,a0,-1956 # 918 <malloc+0x132>
  c4:	00000097          	auipc	ra,0x0
  c8:	66a080e7          	jalr	1642(ra) # 72e <printf>
            exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	2d0080e7          	jalr	720(ra) # 39e <exit>
        wait(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	2ce080e7          	jalr	718(ra) # 3a6 <wait>
        int count = getsyscount(mask);
  e0:	8526                	mv	a0,s1
  e2:	00000097          	auipc	ra,0x0
  e6:	364080e7          	jalr	868(ra) # 446 <getsyscount>
  ea:	89aa                	mv	s3,a0
        printf("PID %d called %s %d times.\n", getpid(), find_name(mask), count);
  ec:	00000097          	auipc	ra,0x0
  f0:	332080e7          	jalr	818(ra) # 41e <getpid>
  f4:	892a                	mv	s2,a0
  f6:	8526                	mv	a0,s1
  f8:	00000097          	auipc	ra,0x0
  fc:	f08080e7          	jalr	-248(ra) # 0 <find_name>
 100:	862a                	mv	a2,a0
 102:	86ce                	mv	a3,s3
 104:	85ca                	mv	a1,s2
 106:	00001517          	auipc	a0,0x1
 10a:	82250513          	addi	a0,a0,-2014 # 928 <malloc+0x142>
 10e:	00000097          	auipc	ra,0x0
 112:	620080e7          	jalr	1568(ra) # 72e <printf>
 116:	bf89                	j	68 <main+0x34>

0000000000000118 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 120:	00000097          	auipc	ra,0x0
 124:	f14080e7          	jalr	-236(ra) # 34 <main>
  exit(0);
 128:	4501                	li	a0,0
 12a:	00000097          	auipc	ra,0x0
 12e:	274080e7          	jalr	628(ra) # 39e <exit>

0000000000000132 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 138:	87aa                	mv	a5,a0
 13a:	0585                	addi	a1,a1,1
 13c:	0785                	addi	a5,a5,1
 13e:	fff5c703          	lbu	a4,-1(a1)
 142:	fee78fa3          	sb	a4,-1(a5)
 146:	fb75                	bnez	a4,13a <strcpy+0x8>
    ;
  return os;
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e422                	sd	s0,8(sp)
 152:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 154:	00054783          	lbu	a5,0(a0)
 158:	cb91                	beqz	a5,16c <strcmp+0x1e>
 15a:	0005c703          	lbu	a4,0(a1)
 15e:	00f71763          	bne	a4,a5,16c <strcmp+0x1e>
    p++, q++;
 162:	0505                	addi	a0,a0,1
 164:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 166:	00054783          	lbu	a5,0(a0)
 16a:	fbe5                	bnez	a5,15a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16c:	0005c503          	lbu	a0,0(a1)
}
 170:	40a7853b          	subw	a0,a5,a0
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strlen>:

uint
strlen(const char *s)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 180:	00054783          	lbu	a5,0(a0)
 184:	cf91                	beqz	a5,1a0 <strlen+0x26>
 186:	0505                	addi	a0,a0,1
 188:	87aa                	mv	a5,a0
 18a:	86be                	mv	a3,a5
 18c:	0785                	addi	a5,a5,1
 18e:	fff7c703          	lbu	a4,-1(a5)
 192:	ff65                	bnez	a4,18a <strlen+0x10>
 194:	40a6853b          	subw	a0,a3,a0
 198:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  for(n = 0; s[n]; n++)
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strlen+0x20>

00000000000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1aa:	ca19                	beqz	a2,1c0 <memset+0x1c>
 1ac:	87aa                	mv	a5,a0
 1ae:	1602                	slli	a2,a2,0x20
 1b0:	9201                	srli	a2,a2,0x20
 1b2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ba:	0785                	addi	a5,a5,1
 1bc:	fee79de3          	bne	a5,a4,1b6 <memset+0x12>
  }
  return dst;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strchr>:

char*
strchr(const char *s, char c)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb99                	beqz	a5,1e6 <strchr+0x20>
    if(*s == c)
 1d2:	00f58763          	beq	a1,a5,1e0 <strchr+0x1a>
  for(; *s; s++)
 1d6:	0505                	addi	a0,a0,1
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbfd                	bnez	a5,1d2 <strchr+0xc>
      return (char*)s;
  return 0;
 1de:	4501                	li	a0,0
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  return 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <strchr+0x1a>

00000000000001ea <gets>:

char*
gets(char *buf, int max)
{
 1ea:	711d                	addi	sp,sp,-96
 1ec:	ec86                	sd	ra,88(sp)
 1ee:	e8a2                	sd	s0,80(sp)
 1f0:	e4a6                	sd	s1,72(sp)
 1f2:	e0ca                	sd	s2,64(sp)
 1f4:	fc4e                	sd	s3,56(sp)
 1f6:	f852                	sd	s4,48(sp)
 1f8:	f456                	sd	s5,40(sp)
 1fa:	f05a                	sd	s6,32(sp)
 1fc:	ec5e                	sd	s7,24(sp)
 1fe:	1080                	addi	s0,sp,96
 200:	8baa                	mv	s7,a0
 202:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	892a                	mv	s2,a0
 206:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 208:	4aa9                	li	s5,10
 20a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20c:	89a6                	mv	s3,s1
 20e:	2485                	addiw	s1,s1,1
 210:	0344d863          	bge	s1,s4,240 <gets+0x56>
    cc = read(0, &c, 1);
 214:	4605                	li	a2,1
 216:	faf40593          	addi	a1,s0,-81
 21a:	4501                	li	a0,0
 21c:	00000097          	auipc	ra,0x0
 220:	19a080e7          	jalr	410(ra) # 3b6 <read>
    if(cc < 1)
 224:	00a05e63          	blez	a0,240 <gets+0x56>
    buf[i++] = c;
 228:	faf44783          	lbu	a5,-81(s0)
 22c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 230:	01578763          	beq	a5,s5,23e <gets+0x54>
 234:	0905                	addi	s2,s2,1
 236:	fd679be3          	bne	a5,s6,20c <gets+0x22>
    buf[i++] = c;
 23a:	89a6                	mv	s3,s1
 23c:	a011                	j	240 <gets+0x56>
 23e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 240:	99de                	add	s3,s3,s7
 242:	00098023          	sb	zero,0(s3)
  return buf;
}
 246:	855e                	mv	a0,s7
 248:	60e6                	ld	ra,88(sp)
 24a:	6446                	ld	s0,80(sp)
 24c:	64a6                	ld	s1,72(sp)
 24e:	6906                	ld	s2,64(sp)
 250:	79e2                	ld	s3,56(sp)
 252:	7a42                	ld	s4,48(sp)
 254:	7aa2                	ld	s5,40(sp)
 256:	7b02                	ld	s6,32(sp)
 258:	6be2                	ld	s7,24(sp)
 25a:	6125                	addi	sp,sp,96
 25c:	8082                	ret

000000000000025e <stat>:

int
stat(const char *n, struct stat *st)
{
 25e:	1101                	addi	sp,sp,-32
 260:	ec06                	sd	ra,24(sp)
 262:	e822                	sd	s0,16(sp)
 264:	e04a                	sd	s2,0(sp)
 266:	1000                	addi	s0,sp,32
 268:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	4581                	li	a1,0
 26c:	00000097          	auipc	ra,0x0
 270:	172080e7          	jalr	370(ra) # 3de <open>
  if(fd < 0)
 274:	02054663          	bltz	a0,2a0 <stat+0x42>
 278:	e426                	sd	s1,8(sp)
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	00000097          	auipc	ra,0x0
 282:	178080e7          	jalr	376(ra) # 3f6 <fstat>
 286:	892a                	mv	s2,a0
  close(fd);
 288:	8526                	mv	a0,s1
 28a:	00000097          	auipc	ra,0x0
 28e:	13c080e7          	jalr	316(ra) # 3c6 <close>
  return r;
 292:	64a2                	ld	s1,8(sp)
}
 294:	854a                	mv	a0,s2
 296:	60e2                	ld	ra,24(sp)
 298:	6442                	ld	s0,16(sp)
 29a:	6902                	ld	s2,0(sp)
 29c:	6105                	addi	sp,sp,32
 29e:	8082                	ret
    return -1;
 2a0:	597d                	li	s2,-1
 2a2:	bfcd                	j	294 <stat+0x36>

00000000000002a4 <atoi>:

int
atoi(const char *s)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2aa:	00054683          	lbu	a3,0(a0)
 2ae:	fd06879b          	addiw	a5,a3,-48
 2b2:	0ff7f793          	zext.b	a5,a5
 2b6:	4625                	li	a2,9
 2b8:	02f66863          	bltu	a2,a5,2e8 <atoi+0x44>
 2bc:	872a                	mv	a4,a0
  n = 0;
 2be:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c0:	0705                	addi	a4,a4,1
 2c2:	0025179b          	slliw	a5,a0,0x2
 2c6:	9fa9                	addw	a5,a5,a0
 2c8:	0017979b          	slliw	a5,a5,0x1
 2cc:	9fb5                	addw	a5,a5,a3
 2ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d2:	00074683          	lbu	a3,0(a4)
 2d6:	fd06879b          	addiw	a5,a3,-48
 2da:	0ff7f793          	zext.b	a5,a5
 2de:	fef671e3          	bgeu	a2,a5,2c0 <atoi+0x1c>
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  n = 0;
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <atoi+0x3e>

00000000000002ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f2:	02b57463          	bgeu	a0,a1,31a <memmove+0x2e>
    while(n-- > 0)
 2f6:	00c05f63          	blez	a2,314 <memmove+0x28>
 2fa:	1602                	slli	a2,a2,0x20
 2fc:	9201                	srli	a2,a2,0x20
 2fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 302:	872a                	mv	a4,a0
      *dst++ = *src++;
 304:	0585                	addi	a1,a1,1
 306:	0705                	addi	a4,a4,1
 308:	fff5c683          	lbu	a3,-1(a1)
 30c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 310:	fef71ae3          	bne	a4,a5,304 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
    dst += n;
 31a:	00c50733          	add	a4,a0,a2
    src += n;
 31e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 320:	fec05ae3          	blez	a2,314 <memmove+0x28>
 324:	fff6079b          	addiw	a5,a2,-1
 328:	1782                	slli	a5,a5,0x20
 32a:	9381                	srli	a5,a5,0x20
 32c:	fff7c793          	not	a5,a5
 330:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 332:	15fd                	addi	a1,a1,-1
 334:	177d                	addi	a4,a4,-1
 336:	0005c683          	lbu	a3,0(a1)
 33a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33e:	fee79ae3          	bne	a5,a4,332 <memmove+0x46>
 342:	bfc9                	j	314 <memmove+0x28>

0000000000000344 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34a:	ca05                	beqz	a2,37a <memcmp+0x36>
 34c:	fff6069b          	addiw	a3,a2,-1
 350:	1682                	slli	a3,a3,0x20
 352:	9281                	srli	a3,a3,0x20
 354:	0685                	addi	a3,a3,1
 356:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 358:	00054783          	lbu	a5,0(a0)
 35c:	0005c703          	lbu	a4,0(a1)
 360:	00e79863          	bne	a5,a4,370 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 364:	0505                	addi	a0,a0,1
    p2++;
 366:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 368:	fed518e3          	bne	a0,a3,358 <memcmp+0x14>
  }
  return 0;
 36c:	4501                	li	a0,0
 36e:	a019                	j	374 <memcmp+0x30>
      return *p1 - *p2;
 370:	40e7853b          	subw	a0,a5,a4
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  return 0;
 37a:	4501                	li	a0,0
 37c:	bfe5                	j	374 <memcmp+0x30>

000000000000037e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 386:	00000097          	auipc	ra,0x0
 38a:	f66080e7          	jalr	-154(ra) # 2ec <memmove>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 43e:	48d9                	li	a7,22
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 446:	48dd                	li	a7,23
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 44e:	48e1                	li	a7,24
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 456:	48e5                	li	a7,25
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 45e:	48e9                	li	a7,26
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 466:	1101                	addi	sp,sp,-32
 468:	ec06                	sd	ra,24(sp)
 46a:	e822                	sd	s0,16(sp)
 46c:	1000                	addi	s0,sp,32
 46e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 472:	4605                	li	a2,1
 474:	fef40593          	addi	a1,s0,-17
 478:	00000097          	auipc	ra,0x0
 47c:	f46080e7          	jalr	-186(ra) # 3be <write>
}
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	6105                	addi	sp,sp,32
 486:	8082                	ret

0000000000000488 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 488:	7139                	addi	sp,sp,-64
 48a:	fc06                	sd	ra,56(sp)
 48c:	f822                	sd	s0,48(sp)
 48e:	f426                	sd	s1,40(sp)
 490:	0080                	addi	s0,sp,64
 492:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 494:	c299                	beqz	a3,49a <printint+0x12>
 496:	0805cb63          	bltz	a1,52c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49a:	2581                	sext.w	a1,a1
  neg = 0;
 49c:	4881                	li	a7,0
 49e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a4:	2601                	sext.w	a2,a2
 4a6:	00000517          	auipc	a0,0x0
 4aa:	5f250513          	addi	a0,a0,1522 # a98 <digits>
 4ae:	883a                	mv	a6,a4
 4b0:	2705                	addiw	a4,a4,1
 4b2:	02c5f7bb          	remuw	a5,a1,a2
 4b6:	1782                	slli	a5,a5,0x20
 4b8:	9381                	srli	a5,a5,0x20
 4ba:	97aa                	add	a5,a5,a0
 4bc:	0007c783          	lbu	a5,0(a5)
 4c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c4:	0005879b          	sext.w	a5,a1
 4c8:	02c5d5bb          	divuw	a1,a1,a2
 4cc:	0685                	addi	a3,a3,1
 4ce:	fec7f0e3          	bgeu	a5,a2,4ae <printint+0x26>
  if(neg)
 4d2:	00088c63          	beqz	a7,4ea <printint+0x62>
    buf[i++] = '-';
 4d6:	fd070793          	addi	a5,a4,-48
 4da:	00878733          	add	a4,a5,s0
 4de:	02d00793          	li	a5,45
 4e2:	fef70823          	sb	a5,-16(a4)
 4e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ea:	02e05c63          	blez	a4,522 <printint+0x9a>
 4ee:	f04a                	sd	s2,32(sp)
 4f0:	ec4e                	sd	s3,24(sp)
 4f2:	fc040793          	addi	a5,s0,-64
 4f6:	00e78933          	add	s2,a5,a4
 4fa:	fff78993          	addi	s3,a5,-1
 4fe:	99ba                	add	s3,s3,a4
 500:	377d                	addiw	a4,a4,-1
 502:	1702                	slli	a4,a4,0x20
 504:	9301                	srli	a4,a4,0x20
 506:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50a:	fff94583          	lbu	a1,-1(s2)
 50e:	8526                	mv	a0,s1
 510:	00000097          	auipc	ra,0x0
 514:	f56080e7          	jalr	-170(ra) # 466 <putc>
  while(--i >= 0)
 518:	197d                	addi	s2,s2,-1
 51a:	ff3918e3          	bne	s2,s3,50a <printint+0x82>
 51e:	7902                	ld	s2,32(sp)
 520:	69e2                	ld	s3,24(sp)
}
 522:	70e2                	ld	ra,56(sp)
 524:	7442                	ld	s0,48(sp)
 526:	74a2                	ld	s1,40(sp)
 528:	6121                	addi	sp,sp,64
 52a:	8082                	ret
    x = -xx;
 52c:	40b005bb          	negw	a1,a1
    neg = 1;
 530:	4885                	li	a7,1
    x = -xx;
 532:	b7b5                	j	49e <printint+0x16>

0000000000000534 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 534:	715d                	addi	sp,sp,-80
 536:	e486                	sd	ra,72(sp)
 538:	e0a2                	sd	s0,64(sp)
 53a:	f84a                	sd	s2,48(sp)
 53c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53e:	0005c903          	lbu	s2,0(a1)
 542:	1a090a63          	beqz	s2,6f6 <vprintf+0x1c2>
 546:	fc26                	sd	s1,56(sp)
 548:	f44e                	sd	s3,40(sp)
 54a:	f052                	sd	s4,32(sp)
 54c:	ec56                	sd	s5,24(sp)
 54e:	e85a                	sd	s6,16(sp)
 550:	e45e                	sd	s7,8(sp)
 552:	8aaa                	mv	s5,a0
 554:	8bb2                	mv	s7,a2
 556:	00158493          	addi	s1,a1,1
  state = 0;
 55a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55c:	02500a13          	li	s4,37
 560:	4b55                	li	s6,21
 562:	a839                	j	580 <vprintf+0x4c>
        putc(fd, c);
 564:	85ca                	mv	a1,s2
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	efe080e7          	jalr	-258(ra) # 466 <putc>
 570:	a019                	j	576 <vprintf+0x42>
    } else if(state == '%'){
 572:	01498d63          	beq	s3,s4,58c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 576:	0485                	addi	s1,s1,1
 578:	fff4c903          	lbu	s2,-1(s1)
 57c:	16090763          	beqz	s2,6ea <vprintf+0x1b6>
    if(state == 0){
 580:	fe0999e3          	bnez	s3,572 <vprintf+0x3e>
      if(c == '%'){
 584:	ff4910e3          	bne	s2,s4,564 <vprintf+0x30>
        state = '%';
 588:	89d2                	mv	s3,s4
 58a:	b7f5                	j	576 <vprintf+0x42>
      if(c == 'd'){
 58c:	13490463          	beq	s2,s4,6b4 <vprintf+0x180>
 590:	f9d9079b          	addiw	a5,s2,-99
 594:	0ff7f793          	zext.b	a5,a5
 598:	12fb6763          	bltu	s6,a5,6c6 <vprintf+0x192>
 59c:	f9d9079b          	addiw	a5,s2,-99
 5a0:	0ff7f713          	zext.b	a4,a5
 5a4:	12eb6163          	bltu	s6,a4,6c6 <vprintf+0x192>
 5a8:	00271793          	slli	a5,a4,0x2
 5ac:	00000717          	auipc	a4,0x0
 5b0:	49470713          	addi	a4,a4,1172 # a40 <malloc+0x25a>
 5b4:	97ba                	add	a5,a5,a4
 5b6:	439c                	lw	a5,0(a5)
 5b8:	97ba                	add	a5,a5,a4
 5ba:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ebe080e7          	jalr	-322(ra) # 488 <printint>
 5d2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b745                	j	576 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4629                	li	a2,10
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	ea2080e7          	jalr	-350(ra) # 488 <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b751                	j	576 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000ba583          	lw	a1,0(s7)
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e86080e7          	jalr	-378(ra) # 488 <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b7a5                	j	576 <vprintf+0x42>
 610:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 612:	008b8c13          	addi	s8,s7,8
 616:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61a:	03000593          	li	a1,48
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e46080e7          	jalr	-442(ra) # 466 <putc>
  putc(fd, 'x');
 628:	07800593          	li	a1,120
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e38080e7          	jalr	-456(ra) # 466 <putc>
 636:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 638:	00000b97          	auipc	s7,0x0
 63c:	460b8b93          	addi	s7,s7,1120 # a98 <digits>
 640:	03c9d793          	srli	a5,s3,0x3c
 644:	97de                	add	a5,a5,s7
 646:	0007c583          	lbu	a1,0(a5)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e1a080e7          	jalr	-486(ra) # 466 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 654:	0992                	slli	s3,s3,0x4
 656:	397d                	addiw	s2,s2,-1
 658:	fe0914e3          	bnez	s2,640 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 65c:	8be2                	mv	s7,s8
      state = 0;
 65e:	4981                	li	s3,0
 660:	6c02                	ld	s8,0(sp)
 662:	bf11                	j	576 <vprintf+0x42>
        s = va_arg(ap, char*);
 664:	008b8993          	addi	s3,s7,8
 668:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 66c:	02090163          	beqz	s2,68e <vprintf+0x15a>
        while(*s != 0){
 670:	00094583          	lbu	a1,0(s2)
 674:	c9a5                	beqz	a1,6e4 <vprintf+0x1b0>
          putc(fd, *s);
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	dee080e7          	jalr	-530(ra) # 466 <putc>
          s++;
 680:	0905                	addi	s2,s2,1
        while(*s != 0){
 682:	00094583          	lbu	a1,0(s2)
 686:	f9e5                	bnez	a1,676 <vprintf+0x142>
        s = va_arg(ap, char*);
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b5ed                	j	576 <vprintf+0x42>
          s = "(null)";
 68e:	00000917          	auipc	s2,0x0
 692:	3aa90913          	addi	s2,s2,938 # a38 <malloc+0x252>
        while(*s != 0){
 696:	02800593          	li	a1,40
 69a:	bff1                	j	676 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 69c:	008b8913          	addi	s2,s7,8
 6a0:	000bc583          	lbu	a1,0(s7)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dc0080e7          	jalr	-576(ra) # 466 <putc>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b5d1                	j	576 <vprintf+0x42>
        putc(fd, c);
 6b4:	02500593          	li	a1,37
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	dac080e7          	jalr	-596(ra) # 466 <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bd4d                	j	576 <vprintf+0x42>
        putc(fd, '%');
 6c6:	02500593          	li	a1,37
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	d9a080e7          	jalr	-614(ra) # 466 <putc>
        putc(fd, c);
 6d4:	85ca                	mv	a1,s2
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	d8e080e7          	jalr	-626(ra) # 466 <putc>
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bd51                	j	576 <vprintf+0x42>
        s = va_arg(ap, char*);
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b579                	j	576 <vprintf+0x42>
 6ea:	74e2                	ld	s1,56(sp)
 6ec:	79a2                	ld	s3,40(sp)
 6ee:	7a02                	ld	s4,32(sp)
 6f0:	6ae2                	ld	s5,24(sp)
 6f2:	6b42                	ld	s6,16(sp)
 6f4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6f6:	60a6                	ld	ra,72(sp)
 6f8:	6406                	ld	s0,64(sp)
 6fa:	7942                	ld	s2,48(sp)
 6fc:	6161                	addi	sp,sp,80
 6fe:	8082                	ret

0000000000000700 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 700:	715d                	addi	sp,sp,-80
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e010                	sd	a2,0(s0)
 70a:	e414                	sd	a3,8(s0)
 70c:	e818                	sd	a4,16(s0)
 70e:	ec1c                	sd	a5,24(s0)
 710:	03043023          	sd	a6,32(s0)
 714:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71c:	8622                	mv	a2,s0
 71e:	00000097          	auipc	ra,0x0
 722:	e16080e7          	jalr	-490(ra) # 534 <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6161                	addi	sp,sp,80
 72c:	8082                	ret

000000000000072e <printf>:

void
printf(const char *fmt, ...)
{
 72e:	711d                	addi	sp,sp,-96
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e40c                	sd	a1,8(s0)
 738:	e810                	sd	a2,16(s0)
 73a:	ec14                	sd	a3,24(s0)
 73c:	f018                	sd	a4,32(s0)
 73e:	f41c                	sd	a5,40(s0)
 740:	03043823          	sd	a6,48(s0)
 744:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	00840613          	addi	a2,s0,8
 74c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 750:	85aa                	mv	a1,a0
 752:	4505                	li	a0,1
 754:	00000097          	auipc	ra,0x0
 758:	de0080e7          	jalr	-544(ra) # 534 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 764:	1141                	addi	sp,sp,-16
 766:	e422                	sd	s0,8(sp)
 768:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	00001797          	auipc	a5,0x1
 772:	d827b783          	ld	a5,-638(a5) # 14f0 <freep>
 776:	a02d                	j	7a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 778:	4618                	lw	a4,8(a2)
 77a:	9f2d                	addw	a4,a4,a1
 77c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	6398                	ld	a4,0(a5)
 782:	6310                	ld	a2,0(a4)
 784:	a83d                	j	7c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 786:	ff852703          	lw	a4,-8(a0)
 78a:	9f31                	addw	a4,a4,a2
 78c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78e:	ff053683          	ld	a3,-16(a0)
 792:	a091                	j	7d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	6398                	ld	a4,0(a5)
 796:	00e7e463          	bltu	a5,a4,79e <free+0x3a>
 79a:	00e6ea63          	bltu	a3,a4,7ae <free+0x4a>
{
 79e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	fed7fae3          	bgeu	a5,a3,794 <free+0x30>
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e6e463          	bltu	a3,a4,7ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7aa:	fee7eae3          	bltu	a5,a4,79e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7ae:	ff852583          	lw	a1,-8(a0)
 7b2:	6390                	ld	a2,0(a5)
 7b4:	02059813          	slli	a6,a1,0x20
 7b8:	01c85713          	srli	a4,a6,0x1c
 7bc:	9736                	add	a4,a4,a3
 7be:	fae60de3          	beq	a2,a4,778 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c6:	4790                	lw	a2,8(a5)
 7c8:	02061593          	slli	a1,a2,0x20
 7cc:	01c5d713          	srli	a4,a1,0x1c
 7d0:	973e                	add	a4,a4,a5
 7d2:	fae68ae3          	beq	a3,a4,786 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d8:	00001717          	auipc	a4,0x1
 7dc:	d0f73c23          	sd	a5,-744(a4) # 14f0 <freep>
}
 7e0:	6422                	ld	s0,8(sp)
 7e2:	0141                	addi	sp,sp,16
 7e4:	8082                	ret

00000000000007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e6:	7139                	addi	sp,sp,-64
 7e8:	fc06                	sd	ra,56(sp)
 7ea:	f822                	sd	s0,48(sp)
 7ec:	f426                	sd	s1,40(sp)
 7ee:	ec4e                	sd	s3,24(sp)
 7f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	02051493          	slli	s1,a0,0x20
 7f6:	9081                	srli	s1,s1,0x20
 7f8:	04bd                	addi	s1,s1,15
 7fa:	8091                	srli	s1,s1,0x4
 7fc:	0014899b          	addiw	s3,s1,1
 800:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 802:	00001517          	auipc	a0,0x1
 806:	cee53503          	ld	a0,-786(a0) # 14f0 <freep>
 80a:	c915                	beqz	a0,83e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	08977e63          	bgeu	a4,s1,8ac <malloc+0xc6>
 814:	f04a                	sd	s2,32(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81c:	8a4e                	mv	s4,s3
 81e:	0009871b          	sext.w	a4,s3
 822:	6685                	lui	a3,0x1
 824:	00d77363          	bgeu	a4,a3,82a <malloc+0x44>
 828:	6a05                	lui	s4,0x1
 82a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 832:	00001917          	auipc	s2,0x1
 836:	cbe90913          	addi	s2,s2,-834 # 14f0 <freep>
  if(p == (char*)-1)
 83a:	5afd                	li	s5,-1
 83c:	a091                	j	880 <malloc+0x9a>
 83e:	f04a                	sd	s2,32(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 846:	00001797          	auipc	a5,0x1
 84a:	cba78793          	addi	a5,a5,-838 # 1500 <base>
 84e:	00001717          	auipc	a4,0x1
 852:	caf73123          	sd	a5,-862(a4) # 14f0 <freep>
 856:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 858:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85c:	b7c1                	j	81c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 85e:	6398                	ld	a4,0(a5)
 860:	e118                	sd	a4,0(a0)
 862:	a08d                	j	8c4 <malloc+0xde>
  hp->s.size = nu;
 864:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 868:	0541                	addi	a0,a0,16
 86a:	00000097          	auipc	ra,0x0
 86e:	efa080e7          	jalr	-262(ra) # 764 <free>
  return freep;
 872:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 876:	c13d                	beqz	a0,8dc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87a:	4798                	lw	a4,8(a5)
 87c:	02977463          	bgeu	a4,s1,8a4 <malloc+0xbe>
    if(p == freep)
 880:	00093703          	ld	a4,0(s2)
 884:	853e                	mv	a0,a5
 886:	fef719e3          	bne	a4,a5,878 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 88a:	8552                	mv	a0,s4
 88c:	00000097          	auipc	ra,0x0
 890:	b9a080e7          	jalr	-1126(ra) # 426 <sbrk>
  if(p == (char*)-1)
 894:	fd5518e3          	bne	a0,s5,864 <malloc+0x7e>
        return 0;
 898:	4501                	li	a0,0
 89a:	7902                	ld	s2,32(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	a03d                	j	8d0 <malloc+0xea>
 8a4:	7902                	ld	s2,32(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ac:	fae489e3          	beq	s1,a4,85e <malloc+0x78>
        p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	02071693          	slli	a3,a4,0x20
 8ba:	01c6d713          	srli	a4,a3,0x1c
 8be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c4:	00001717          	auipc	a4,0x1
 8c8:	c2a73623          	sd	a0,-980(a4) # 14f0 <freep>
      return (void*)(p + 1);
 8cc:	01078513          	addi	a0,a5,16
  }
}
 8d0:	70e2                	ld	ra,56(sp)
 8d2:	7442                	ld	s0,48(sp)
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6121                	addi	sp,sp,64
 8da:	8082                	ret
 8dc:	7902                	ld	s2,32(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	b7f5                	j	8d0 <malloc+0xea>
