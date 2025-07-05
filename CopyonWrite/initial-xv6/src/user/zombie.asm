
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2a0080e7          	jalr	672(ra) # 2a8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	29a080e7          	jalr	666(ra) # 2b0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	320080e7          	jalr	800(ra) # 340 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	274080e7          	jalr	628(ra) # 2b0 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	19a080e7          	jalr	410(ra) # 2c8 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	172080e7          	jalr	370(ra) # 2f0 <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	178080e7          	jalr	376(ra) # 308 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	13c080e7          	jalr	316(ra) # 2d8 <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fef71ae3          	bne	a4,a5,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 358:	1101                	addi	sp,sp,-32
 35a:	ec06                	sd	ra,24(sp)
 35c:	e822                	sd	s0,16(sp)
 35e:	1000                	addi	s0,sp,32
 360:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 364:	4605                	li	a2,1
 366:	fef40593          	addi	a1,s0,-17
 36a:	00000097          	auipc	ra,0x0
 36e:	f66080e7          	jalr	-154(ra) # 2d0 <write>
}
 372:	60e2                	ld	ra,24(sp)
 374:	6442                	ld	s0,16(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret

000000000000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	7139                	addi	sp,sp,-64
 37c:	fc06                	sd	ra,56(sp)
 37e:	f822                	sd	s0,48(sp)
 380:	f426                	sd	s1,40(sp)
 382:	0080                	addi	s0,sp,64
 384:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 386:	c299                	beqz	a3,38c <printint+0x12>
 388:	0805cb63          	bltz	a1,41e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 38c:	2581                	sext.w	a1,a1
  neg = 0;
 38e:	4881                	li	a7,0
 390:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 394:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 396:	2601                	sext.w	a2,a2
 398:	00000517          	auipc	a0,0x0
 39c:	4a850513          	addi	a0,a0,1192 # 840 <digits>
 3a0:	883a                	mv	a6,a4
 3a2:	2705                	addiw	a4,a4,1
 3a4:	02c5f7bb          	remuw	a5,a1,a2
 3a8:	1782                	slli	a5,a5,0x20
 3aa:	9381                	srli	a5,a5,0x20
 3ac:	97aa                	add	a5,a5,a0
 3ae:	0007c783          	lbu	a5,0(a5)
 3b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b6:	0005879b          	sext.w	a5,a1
 3ba:	02c5d5bb          	divuw	a1,a1,a2
 3be:	0685                	addi	a3,a3,1
 3c0:	fec7f0e3          	bgeu	a5,a2,3a0 <printint+0x26>
  if(neg)
 3c4:	00088c63          	beqz	a7,3dc <printint+0x62>
    buf[i++] = '-';
 3c8:	fd070793          	addi	a5,a4,-48
 3cc:	00878733          	add	a4,a5,s0
 3d0:	02d00793          	li	a5,45
 3d4:	fef70823          	sb	a5,-16(a4)
 3d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3dc:	02e05c63          	blez	a4,414 <printint+0x9a>
 3e0:	f04a                	sd	s2,32(sp)
 3e2:	ec4e                	sd	s3,24(sp)
 3e4:	fc040793          	addi	a5,s0,-64
 3e8:	00e78933          	add	s2,a5,a4
 3ec:	fff78993          	addi	s3,a5,-1
 3f0:	99ba                	add	s3,s3,a4
 3f2:	377d                	addiw	a4,a4,-1
 3f4:	1702                	slli	a4,a4,0x20
 3f6:	9301                	srli	a4,a4,0x20
 3f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3fc:	fff94583          	lbu	a1,-1(s2)
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	f56080e7          	jalr	-170(ra) # 358 <putc>
  while(--i >= 0)
 40a:	197d                	addi	s2,s2,-1
 40c:	ff3918e3          	bne	s2,s3,3fc <printint+0x82>
 410:	7902                	ld	s2,32(sp)
 412:	69e2                	ld	s3,24(sp)
}
 414:	70e2                	ld	ra,56(sp)
 416:	7442                	ld	s0,48(sp)
 418:	74a2                	ld	s1,40(sp)
 41a:	6121                	addi	sp,sp,64
 41c:	8082                	ret
    x = -xx;
 41e:	40b005bb          	negw	a1,a1
    neg = 1;
 422:	4885                	li	a7,1
    x = -xx;
 424:	b7b5                	j	390 <printint+0x16>

0000000000000426 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 426:	715d                	addi	sp,sp,-80
 428:	e486                	sd	ra,72(sp)
 42a:	e0a2                	sd	s0,64(sp)
 42c:	f84a                	sd	s2,48(sp)
 42e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 430:	0005c903          	lbu	s2,0(a1)
 434:	1a090a63          	beqz	s2,5e8 <vprintf+0x1c2>
 438:	fc26                	sd	s1,56(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	f052                	sd	s4,32(sp)
 43e:	ec56                	sd	s5,24(sp)
 440:	e85a                	sd	s6,16(sp)
 442:	e45e                	sd	s7,8(sp)
 444:	8aaa                	mv	s5,a0
 446:	8bb2                	mv	s7,a2
 448:	00158493          	addi	s1,a1,1
  state = 0;
 44c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44e:	02500a13          	li	s4,37
 452:	4b55                	li	s6,21
 454:	a839                	j	472 <vprintf+0x4c>
        putc(fd, c);
 456:	85ca                	mv	a1,s2
 458:	8556                	mv	a0,s5
 45a:	00000097          	auipc	ra,0x0
 45e:	efe080e7          	jalr	-258(ra) # 358 <putc>
 462:	a019                	j	468 <vprintf+0x42>
    } else if(state == '%'){
 464:	01498d63          	beq	s3,s4,47e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 468:	0485                	addi	s1,s1,1
 46a:	fff4c903          	lbu	s2,-1(s1)
 46e:	16090763          	beqz	s2,5dc <vprintf+0x1b6>
    if(state == 0){
 472:	fe0999e3          	bnez	s3,464 <vprintf+0x3e>
      if(c == '%'){
 476:	ff4910e3          	bne	s2,s4,456 <vprintf+0x30>
        state = '%';
 47a:	89d2                	mv	s3,s4
 47c:	b7f5                	j	468 <vprintf+0x42>
      if(c == 'd'){
 47e:	13490463          	beq	s2,s4,5a6 <vprintf+0x180>
 482:	f9d9079b          	addiw	a5,s2,-99
 486:	0ff7f793          	zext.b	a5,a5
 48a:	12fb6763          	bltu	s6,a5,5b8 <vprintf+0x192>
 48e:	f9d9079b          	addiw	a5,s2,-99
 492:	0ff7f713          	zext.b	a4,a5
 496:	12eb6163          	bltu	s6,a4,5b8 <vprintf+0x192>
 49a:	00271793          	slli	a5,a4,0x2
 49e:	00000717          	auipc	a4,0x0
 4a2:	34a70713          	addi	a4,a4,842 # 7e8 <malloc+0x110>
 4a6:	97ba                	add	a5,a5,a4
 4a8:	439c                	lw	a5,0(a5)
 4aa:	97ba                	add	a5,a5,a4
 4ac:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4ae:	008b8913          	addi	s2,s7,8
 4b2:	4685                	li	a3,1
 4b4:	4629                	li	a2,10
 4b6:	000ba583          	lw	a1,0(s7)
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	ebe080e7          	jalr	-322(ra) # 37a <printint>
 4c4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c6:	4981                	li	s3,0
 4c8:	b745                	j	468 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ca:	008b8913          	addi	s2,s7,8
 4ce:	4681                	li	a3,0
 4d0:	4629                	li	a2,10
 4d2:	000ba583          	lw	a1,0(s7)
 4d6:	8556                	mv	a0,s5
 4d8:	00000097          	auipc	ra,0x0
 4dc:	ea2080e7          	jalr	-350(ra) # 37a <printint>
 4e0:	8bca                	mv	s7,s2
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	b751                	j	468 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4e6:	008b8913          	addi	s2,s7,8
 4ea:	4681                	li	a3,0
 4ec:	4641                	li	a2,16
 4ee:	000ba583          	lw	a1,0(s7)
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	e86080e7          	jalr	-378(ra) # 37a <printint>
 4fc:	8bca                	mv	s7,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	b7a5                	j	468 <vprintf+0x42>
 502:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 504:	008b8c13          	addi	s8,s7,8
 508:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 50c:	03000593          	li	a1,48
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e46080e7          	jalr	-442(ra) # 358 <putc>
  putc(fd, 'x');
 51a:	07800593          	li	a1,120
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e38080e7          	jalr	-456(ra) # 358 <putc>
 528:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52a:	00000b97          	auipc	s7,0x0
 52e:	316b8b93          	addi	s7,s7,790 # 840 <digits>
 532:	03c9d793          	srli	a5,s3,0x3c
 536:	97de                	add	a5,a5,s7
 538:	0007c583          	lbu	a1,0(a5)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e1a080e7          	jalr	-486(ra) # 358 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 546:	0992                	slli	s3,s3,0x4
 548:	397d                	addiw	s2,s2,-1
 54a:	fe0914e3          	bnez	s2,532 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 54e:	8be2                	mv	s7,s8
      state = 0;
 550:	4981                	li	s3,0
 552:	6c02                	ld	s8,0(sp)
 554:	bf11                	j	468 <vprintf+0x42>
        s = va_arg(ap, char*);
 556:	008b8993          	addi	s3,s7,8
 55a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 55e:	02090163          	beqz	s2,580 <vprintf+0x15a>
        while(*s != 0){
 562:	00094583          	lbu	a1,0(s2)
 566:	c9a5                	beqz	a1,5d6 <vprintf+0x1b0>
          putc(fd, *s);
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	dee080e7          	jalr	-530(ra) # 358 <putc>
          s++;
 572:	0905                	addi	s2,s2,1
        while(*s != 0){
 574:	00094583          	lbu	a1,0(s2)
 578:	f9e5                	bnez	a1,568 <vprintf+0x142>
        s = va_arg(ap, char*);
 57a:	8bce                	mv	s7,s3
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b5ed                	j	468 <vprintf+0x42>
          s = "(null)";
 580:	00000917          	auipc	s2,0x0
 584:	26090913          	addi	s2,s2,608 # 7e0 <malloc+0x108>
        while(*s != 0){
 588:	02800593          	li	a1,40
 58c:	bff1                	j	568 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 58e:	008b8913          	addi	s2,s7,8
 592:	000bc583          	lbu	a1,0(s7)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	dc0080e7          	jalr	-576(ra) # 358 <putc>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b5d1                	j	468 <vprintf+0x42>
        putc(fd, c);
 5a6:	02500593          	li	a1,37
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	dac080e7          	jalr	-596(ra) # 358 <putc>
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bd4d                	j	468 <vprintf+0x42>
        putc(fd, '%');
 5b8:	02500593          	li	a1,37
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	d9a080e7          	jalr	-614(ra) # 358 <putc>
        putc(fd, c);
 5c6:	85ca                	mv	a1,s2
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	d8e080e7          	jalr	-626(ra) # 358 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bd51                	j	468 <vprintf+0x42>
        s = va_arg(ap, char*);
 5d6:	8bce                	mv	s7,s3
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b579                	j	468 <vprintf+0x42>
 5dc:	74e2                	ld	s1,56(sp)
 5de:	79a2                	ld	s3,40(sp)
 5e0:	7a02                	ld	s4,32(sp)
 5e2:	6ae2                	ld	s5,24(sp)
 5e4:	6b42                	ld	s6,16(sp)
 5e6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5e8:	60a6                	ld	ra,72(sp)
 5ea:	6406                	ld	s0,64(sp)
 5ec:	7942                	ld	s2,48(sp)
 5ee:	6161                	addi	sp,sp,80
 5f0:	8082                	ret

00000000000005f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5f2:	715d                	addi	sp,sp,-80
 5f4:	ec06                	sd	ra,24(sp)
 5f6:	e822                	sd	s0,16(sp)
 5f8:	1000                	addi	s0,sp,32
 5fa:	e010                	sd	a2,0(s0)
 5fc:	e414                	sd	a3,8(s0)
 5fe:	e818                	sd	a4,16(s0)
 600:	ec1c                	sd	a5,24(s0)
 602:	03043023          	sd	a6,32(s0)
 606:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 60a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 60e:	8622                	mv	a2,s0
 610:	00000097          	auipc	ra,0x0
 614:	e16080e7          	jalr	-490(ra) # 426 <vprintf>
}
 618:	60e2                	ld	ra,24(sp)
 61a:	6442                	ld	s0,16(sp)
 61c:	6161                	addi	sp,sp,80
 61e:	8082                	ret

0000000000000620 <printf>:

void
printf(const char *fmt, ...)
{
 620:	711d                	addi	sp,sp,-96
 622:	ec06                	sd	ra,24(sp)
 624:	e822                	sd	s0,16(sp)
 626:	1000                	addi	s0,sp,32
 628:	e40c                	sd	a1,8(s0)
 62a:	e810                	sd	a2,16(s0)
 62c:	ec14                	sd	a3,24(s0)
 62e:	f018                	sd	a4,32(s0)
 630:	f41c                	sd	a5,40(s0)
 632:	03043823          	sd	a6,48(s0)
 636:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 63a:	00840613          	addi	a2,s0,8
 63e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 642:	85aa                	mv	a1,a0
 644:	4505                	li	a0,1
 646:	00000097          	auipc	ra,0x0
 64a:	de0080e7          	jalr	-544(ra) # 426 <vprintf>
}
 64e:	60e2                	ld	ra,24(sp)
 650:	6442                	ld	s0,16(sp)
 652:	6125                	addi	sp,sp,96
 654:	8082                	ret

0000000000000656 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 656:	1141                	addi	sp,sp,-16
 658:	e422                	sd	s0,8(sp)
 65a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 660:	00001797          	auipc	a5,0x1
 664:	9a07b783          	ld	a5,-1632(a5) # 1000 <freep>
 668:	a02d                	j	692 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 66a:	4618                	lw	a4,8(a2)
 66c:	9f2d                	addw	a4,a4,a1
 66e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 672:	6398                	ld	a4,0(a5)
 674:	6310                	ld	a2,0(a4)
 676:	a83d                	j	6b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 678:	ff852703          	lw	a4,-8(a0)
 67c:	9f31                	addw	a4,a4,a2
 67e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 680:	ff053683          	ld	a3,-16(a0)
 684:	a091                	j	6c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 686:	6398                	ld	a4,0(a5)
 688:	00e7e463          	bltu	a5,a4,690 <free+0x3a>
 68c:	00e6ea63          	bltu	a3,a4,6a0 <free+0x4a>
{
 690:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	fed7fae3          	bgeu	a5,a3,686 <free+0x30>
 696:	6398                	ld	a4,0(a5)
 698:	00e6e463          	bltu	a3,a4,6a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	fee7eae3          	bltu	a5,a4,690 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6a0:	ff852583          	lw	a1,-8(a0)
 6a4:	6390                	ld	a2,0(a5)
 6a6:	02059813          	slli	a6,a1,0x20
 6aa:	01c85713          	srli	a4,a6,0x1c
 6ae:	9736                	add	a4,a4,a3
 6b0:	fae60de3          	beq	a2,a4,66a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6b8:	4790                	lw	a2,8(a5)
 6ba:	02061593          	slli	a1,a2,0x20
 6be:	01c5d713          	srli	a4,a1,0x1c
 6c2:	973e                	add	a4,a4,a5
 6c4:	fae68ae3          	beq	a3,a4,678 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6ca:	00001717          	auipc	a4,0x1
 6ce:	92f73b23          	sd	a5,-1738(a4) # 1000 <freep>
}
 6d2:	6422                	ld	s0,8(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret

00000000000006d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d8:	7139                	addi	sp,sp,-64
 6da:	fc06                	sd	ra,56(sp)
 6dc:	f822                	sd	s0,48(sp)
 6de:	f426                	sd	s1,40(sp)
 6e0:	ec4e                	sd	s3,24(sp)
 6e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e4:	02051493          	slli	s1,a0,0x20
 6e8:	9081                	srli	s1,s1,0x20
 6ea:	04bd                	addi	s1,s1,15
 6ec:	8091                	srli	s1,s1,0x4
 6ee:	0014899b          	addiw	s3,s1,1
 6f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6f4:	00001517          	auipc	a0,0x1
 6f8:	90c53503          	ld	a0,-1780(a0) # 1000 <freep>
 6fc:	c915                	beqz	a0,730 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 700:	4798                	lw	a4,8(a5)
 702:	08977e63          	bgeu	a4,s1,79e <malloc+0xc6>
 706:	f04a                	sd	s2,32(sp)
 708:	e852                	sd	s4,16(sp)
 70a:	e456                	sd	s5,8(sp)
 70c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 70e:	8a4e                	mv	s4,s3
 710:	0009871b          	sext.w	a4,s3
 714:	6685                	lui	a3,0x1
 716:	00d77363          	bgeu	a4,a3,71c <malloc+0x44>
 71a:	6a05                	lui	s4,0x1
 71c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 720:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 724:	00001917          	auipc	s2,0x1
 728:	8dc90913          	addi	s2,s2,-1828 # 1000 <freep>
  if(p == (char*)-1)
 72c:	5afd                	li	s5,-1
 72e:	a091                	j	772 <malloc+0x9a>
 730:	f04a                	sd	s2,32(sp)
 732:	e852                	sd	s4,16(sp)
 734:	e456                	sd	s5,8(sp)
 736:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 738:	00001797          	auipc	a5,0x1
 73c:	8d878793          	addi	a5,a5,-1832 # 1010 <base>
 740:	00001717          	auipc	a4,0x1
 744:	8cf73023          	sd	a5,-1856(a4) # 1000 <freep>
 748:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 74e:	b7c1                	j	70e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 750:	6398                	ld	a4,0(a5)
 752:	e118                	sd	a4,0(a0)
 754:	a08d                	j	7b6 <malloc+0xde>
  hp->s.size = nu;
 756:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 75a:	0541                	addi	a0,a0,16
 75c:	00000097          	auipc	ra,0x0
 760:	efa080e7          	jalr	-262(ra) # 656 <free>
  return freep;
 764:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 768:	c13d                	beqz	a0,7ce <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76c:	4798                	lw	a4,8(a5)
 76e:	02977463          	bgeu	a4,s1,796 <malloc+0xbe>
    if(p == freep)
 772:	00093703          	ld	a4,0(s2)
 776:	853e                	mv	a0,a5
 778:	fef719e3          	bne	a4,a5,76a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 77c:	8552                	mv	a0,s4
 77e:	00000097          	auipc	ra,0x0
 782:	bba080e7          	jalr	-1094(ra) # 338 <sbrk>
  if(p == (char*)-1)
 786:	fd5518e3          	bne	a0,s5,756 <malloc+0x7e>
        return 0;
 78a:	4501                	li	a0,0
 78c:	7902                	ld	s2,32(sp)
 78e:	6a42                	ld	s4,16(sp)
 790:	6aa2                	ld	s5,8(sp)
 792:	6b02                	ld	s6,0(sp)
 794:	a03d                	j	7c2 <malloc+0xea>
 796:	7902                	ld	s2,32(sp)
 798:	6a42                	ld	s4,16(sp)
 79a:	6aa2                	ld	s5,8(sp)
 79c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 79e:	fae489e3          	beq	s1,a4,750 <malloc+0x78>
        p->s.size -= nunits;
 7a2:	4137073b          	subw	a4,a4,s3
 7a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a8:	02071693          	slli	a3,a4,0x20
 7ac:	01c6d713          	srli	a4,a3,0x1c
 7b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b6:	00001717          	auipc	a4,0x1
 7ba:	84a73523          	sd	a0,-1974(a4) # 1000 <freep>
      return (void*)(p + 1);
 7be:	01078513          	addi	a0,a5,16
  }
}
 7c2:	70e2                	ld	ra,56(sp)
 7c4:	7442                	ld	s0,48(sp)
 7c6:	74a2                	ld	s1,40(sp)
 7c8:	69e2                	ld	s3,24(sp)
 7ca:	6121                	addi	sp,sp,64
 7cc:	8082                	ret
 7ce:	7902                	ld	s2,32(sp)
 7d0:	6a42                	ld	s4,16(sp)
 7d2:	6aa2                	ld	s5,8(sp)
 7d4:	6b02                	ld	s6,0(sp)
 7d6:	b7f5                	j	7c2 <malloc+0xea>
