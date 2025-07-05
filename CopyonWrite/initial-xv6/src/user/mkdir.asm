
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	340080e7          	jalr	832(ra) # 368 <mkdir>
  30:	02054663          	bltz	a0,5c <main+0x5c>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a81d                	j	70 <main+0x70>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00000597          	auipc	a1,0x0
  44:	7f058593          	addi	a1,a1,2032 # 830 <malloc+0x108>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	5f8080e7          	jalr	1528(ra) # 642 <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	2ac080e7          	jalr	684(ra) # 300 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5c:	6090                	ld	a2,0(s1)
  5e:	00000597          	auipc	a1,0x0
  62:	7ea58593          	addi	a1,a1,2026 # 848 <malloc+0x120>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	5da080e7          	jalr	1498(ra) # 642 <fprintf>
      break;
    }
  }

  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	28e080e7          	jalr	654(ra) # 300 <exit>

000000000000007a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	00000097          	auipc	ra,0x0
  86:	f7e080e7          	jalr	-130(ra) # 0 <main>
  exit(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	274080e7          	jalr	628(ra) # 300 <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x1e>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x1e>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf91                	beqz	a5,102 <strlen+0x26>
  e8:	0505                	addi	a0,a0,1
  ea:	87aa                	mv	a5,a0
  ec:	86be                	mv	a3,a5
  ee:	0785                	addi	a5,a5,1
  f0:	fff7c703          	lbu	a4,-1(a5)
  f4:	ff65                	bnez	a4,ec <strlen+0x10>
  f6:	40a6853b          	subw	a0,a3,a0
  fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  for(n = 0; s[n]; n++)
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strlen+0x20>

0000000000000106 <memset>:

void*
memset(void *dst, int c, uint n)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1c>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x12>
  }
  return dst;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb99                	beqz	a5,148 <strchr+0x20>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1a>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xc>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strchr+0x1a>

000000000000014c <gets>:

char*
gets(char *buf, int max)
{
 14c:	711d                	addi	sp,sp,-96
 14e:	ec86                	sd	ra,88(sp)
 150:	e8a2                	sd	s0,80(sp)
 152:	e4a6                	sd	s1,72(sp)
 154:	e0ca                	sd	s2,64(sp)
 156:	fc4e                	sd	s3,56(sp)
 158:	f852                	sd	s4,48(sp)
 15a:	f456                	sd	s5,40(sp)
 15c:	f05a                	sd	s6,32(sp)
 15e:	ec5e                	sd	s7,24(sp)
 160:	1080                	addi	s0,sp,96
 162:	8baa                	mv	s7,a0
 164:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	892a                	mv	s2,a0
 168:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4aa9                	li	s5,10
 16c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	2485                	addiw	s1,s1,1
 172:	0344d863          	bge	s1,s4,1a2 <gets+0x56>
    cc = read(0, &c, 1);
 176:	4605                	li	a2,1
 178:	faf40593          	addi	a1,s0,-81
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	19a080e7          	jalr	410(ra) # 318 <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x56>
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01578763          	beq	a5,s5,1a0 <gets+0x54>
 196:	0905                	addi	s2,s2,1
 198:	fd679be3          	bne	a5,s6,16e <gets+0x22>
    buf[i++] = c;
 19c:	89a6                	mv	s3,s1
 19e:	a011                	j	1a2 <gets+0x56>
 1a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a2:	99de                	add	s3,s3,s7
 1a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a8:	855e                	mv	a0,s7
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	172080e7          	jalr	370(ra) # 340 <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	178080e7          	jalr	376(ra) # 358 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	13c080e7          	jalr	316(ra) # 328 <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	597d                	li	s2,-1
 204:	bfcd                	j	1f6 <stat+0x36>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20c:	00054683          	lbu	a3,0(a0)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	4625                	li	a2,9
 21a:	02f66863          	bltu	a2,a5,24a <atoi+0x44>
 21e:	872a                	mv	a4,a0
  n = 0;
 220:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 222:	0705                	addi	a4,a4,1
 224:	0025179b          	slliw	a5,a0,0x2
 228:	9fa9                	addw	a5,a5,a0
 22a:	0017979b          	slliw	a5,a5,0x1
 22e:	9fb5                	addw	a5,a5,a3
 230:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 234:	00074683          	lbu	a3,0(a4)
 238:	fd06879b          	addiw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	fef671e3          	bgeu	a2,a5,222 <atoi+0x1c>
  return n;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <atoi+0x3e>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57463          	bgeu	a0,a1,27c <memmove+0x2e>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x28>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x28>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x46>
 2a4:	bfc9                	j	276 <memmove+0x28>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f66080e7          	jalr	-154(ra) # 24e <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3a0:	48d9                	li	a7,22
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	1000                	addi	s0,sp,32
 3b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b4:	4605                	li	a2,1
 3b6:	fef40593          	addi	a1,s0,-17
 3ba:	00000097          	auipc	ra,0x0
 3be:	f66080e7          	jalr	-154(ra) # 320 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ca:	7139                	addi	sp,sp,-64
 3cc:	fc06                	sd	ra,56(sp)
 3ce:	f822                	sd	s0,48(sp)
 3d0:	f426                	sd	s1,40(sp)
 3d2:	0080                	addi	s0,sp,64
 3d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d6:	c299                	beqz	a3,3dc <printint+0x12>
 3d8:	0805cb63          	bltz	a1,46e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3dc:	2581                	sext.w	a1,a1
  neg = 0;
 3de:	4881                	li	a7,0
 3e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e6:	2601                	sext.w	a2,a2
 3e8:	00000517          	auipc	a0,0x0
 3ec:	4e050513          	addi	a0,a0,1248 # 8c8 <digits>
 3f0:	883a                	mv	a6,a4
 3f2:	2705                	addiw	a4,a4,1
 3f4:	02c5f7bb          	remuw	a5,a1,a2
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	97aa                	add	a5,a5,a0
 3fe:	0007c783          	lbu	a5,0(a5)
 402:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 406:	0005879b          	sext.w	a5,a1
 40a:	02c5d5bb          	divuw	a1,a1,a2
 40e:	0685                	addi	a3,a3,1
 410:	fec7f0e3          	bgeu	a5,a2,3f0 <printint+0x26>
  if(neg)
 414:	00088c63          	beqz	a7,42c <printint+0x62>
    buf[i++] = '-';
 418:	fd070793          	addi	a5,a4,-48
 41c:	00878733          	add	a4,a5,s0
 420:	02d00793          	li	a5,45
 424:	fef70823          	sb	a5,-16(a4)
 428:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 42c:	02e05c63          	blez	a4,464 <printint+0x9a>
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	fc040793          	addi	a5,s0,-64
 438:	00e78933          	add	s2,a5,a4
 43c:	fff78993          	addi	s3,a5,-1
 440:	99ba                	add	s3,s3,a4
 442:	377d                	addiw	a4,a4,-1
 444:	1702                	slli	a4,a4,0x20
 446:	9301                	srli	a4,a4,0x20
 448:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44c:	fff94583          	lbu	a1,-1(s2)
 450:	8526                	mv	a0,s1
 452:	00000097          	auipc	ra,0x0
 456:	f56080e7          	jalr	-170(ra) # 3a8 <putc>
  while(--i >= 0)
 45a:	197d                	addi	s2,s2,-1
 45c:	ff3918e3          	bne	s2,s3,44c <printint+0x82>
 460:	7902                	ld	s2,32(sp)
 462:	69e2                	ld	s3,24(sp)
}
 464:	70e2                	ld	ra,56(sp)
 466:	7442                	ld	s0,48(sp)
 468:	74a2                	ld	s1,40(sp)
 46a:	6121                	addi	sp,sp,64
 46c:	8082                	ret
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4885                	li	a7,1
    x = -xx;
 474:	b7b5                	j	3e0 <printint+0x16>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	715d                	addi	sp,sp,-80
 478:	e486                	sd	ra,72(sp)
 47a:	e0a2                	sd	s0,64(sp)
 47c:	f84a                	sd	s2,48(sp)
 47e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c903          	lbu	s2,0(a1)
 484:	1a090a63          	beqz	s2,638 <vprintf+0x1c2>
 488:	fc26                	sd	s1,56(sp)
 48a:	f44e                	sd	s3,40(sp)
 48c:	f052                	sd	s4,32(sp)
 48e:	ec56                	sd	s5,24(sp)
 490:	e85a                	sd	s6,16(sp)
 492:	e45e                	sd	s7,8(sp)
 494:	8aaa                	mv	s5,a0
 496:	8bb2                	mv	s7,a2
 498:	00158493          	addi	s1,a1,1
  state = 0;
 49c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49e:	02500a13          	li	s4,37
 4a2:	4b55                	li	s6,21
 4a4:	a839                	j	4c2 <vprintf+0x4c>
        putc(fd, c);
 4a6:	85ca                	mv	a1,s2
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	efe080e7          	jalr	-258(ra) # 3a8 <putc>
 4b2:	a019                	j	4b8 <vprintf+0x42>
    } else if(state == '%'){
 4b4:	01498d63          	beq	s3,s4,4ce <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b8:	0485                	addi	s1,s1,1
 4ba:	fff4c903          	lbu	s2,-1(s1)
 4be:	16090763          	beqz	s2,62c <vprintf+0x1b6>
    if(state == 0){
 4c2:	fe0999e3          	bnez	s3,4b4 <vprintf+0x3e>
      if(c == '%'){
 4c6:	ff4910e3          	bne	s2,s4,4a6 <vprintf+0x30>
        state = '%';
 4ca:	89d2                	mv	s3,s4
 4cc:	b7f5                	j	4b8 <vprintf+0x42>
      if(c == 'd'){
 4ce:	13490463          	beq	s2,s4,5f6 <vprintf+0x180>
 4d2:	f9d9079b          	addiw	a5,s2,-99
 4d6:	0ff7f793          	zext.b	a5,a5
 4da:	12fb6763          	bltu	s6,a5,608 <vprintf+0x192>
 4de:	f9d9079b          	addiw	a5,s2,-99
 4e2:	0ff7f713          	zext.b	a4,a5
 4e6:	12eb6163          	bltu	s6,a4,608 <vprintf+0x192>
 4ea:	00271793          	slli	a5,a4,0x2
 4ee:	00000717          	auipc	a4,0x0
 4f2:	38270713          	addi	a4,a4,898 # 870 <malloc+0x148>
 4f6:	97ba                	add	a5,a5,a4
 4f8:	439c                	lw	a5,0(a5)
 4fa:	97ba                	add	a5,a5,a4
 4fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b8913          	addi	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ebe080e7          	jalr	-322(ra) # 3ca <printint>
 514:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 516:	4981                	li	s3,0
 518:	b745                	j	4b8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51a:	008b8913          	addi	s2,s7,8
 51e:	4681                	li	a3,0
 520:	4629                	li	a2,10
 522:	000ba583          	lw	a1,0(s7)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	ea2080e7          	jalr	-350(ra) # 3ca <printint>
 530:	8bca                	mv	s7,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	b751                	j	4b8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 536:	008b8913          	addi	s2,s7,8
 53a:	4681                	li	a3,0
 53c:	4641                	li	a2,16
 53e:	000ba583          	lw	a1,0(s7)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e86080e7          	jalr	-378(ra) # 3ca <printint>
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	b7a5                	j	4b8 <vprintf+0x42>
 552:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 554:	008b8c13          	addi	s8,s7,8
 558:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 55c:	03000593          	li	a1,48
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e46080e7          	jalr	-442(ra) # 3a8 <putc>
  putc(fd, 'x');
 56a:	07800593          	li	a1,120
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e38080e7          	jalr	-456(ra) # 3a8 <putc>
 578:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	00000b97          	auipc	s7,0x0
 57e:	34eb8b93          	addi	s7,s7,846 # 8c8 <digits>
 582:	03c9d793          	srli	a5,s3,0x3c
 586:	97de                	add	a5,a5,s7
 588:	0007c583          	lbu	a1,0(a5)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e1a080e7          	jalr	-486(ra) # 3a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 596:	0992                	slli	s3,s3,0x4
 598:	397d                	addiw	s2,s2,-1
 59a:	fe0914e3          	bnez	s2,582 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 59e:	8be2                	mv	s7,s8
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	6c02                	ld	s8,0(sp)
 5a4:	bf11                	j	4b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 5a6:	008b8993          	addi	s3,s7,8
 5aa:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ae:	02090163          	beqz	s2,5d0 <vprintf+0x15a>
        while(*s != 0){
 5b2:	00094583          	lbu	a1,0(s2)
 5b6:	c9a5                	beqz	a1,626 <vprintf+0x1b0>
          putc(fd, *s);
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dee080e7          	jalr	-530(ra) # 3a8 <putc>
          s++;
 5c2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c4:	00094583          	lbu	a1,0(s2)
 5c8:	f9e5                	bnez	a1,5b8 <vprintf+0x142>
        s = va_arg(ap, char*);
 5ca:	8bce                	mv	s7,s3
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b5ed                	j	4b8 <vprintf+0x42>
          s = "(null)";
 5d0:	00000917          	auipc	s2,0x0
 5d4:	29890913          	addi	s2,s2,664 # 868 <malloc+0x140>
        while(*s != 0){
 5d8:	02800593          	li	a1,40
 5dc:	bff1                	j	5b8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5de:	008b8913          	addi	s2,s7,8
 5e2:	000bc583          	lbu	a1,0(s7)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	dc0080e7          	jalr	-576(ra) # 3a8 <putc>
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b5d1                	j	4b8 <vprintf+0x42>
        putc(fd, c);
 5f6:	02500593          	li	a1,37
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	dac080e7          	jalr	-596(ra) # 3a8 <putc>
      state = 0;
 604:	4981                	li	s3,0
 606:	bd4d                	j	4b8 <vprintf+0x42>
        putc(fd, '%');
 608:	02500593          	li	a1,37
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	d9a080e7          	jalr	-614(ra) # 3a8 <putc>
        putc(fd, c);
 616:	85ca                	mv	a1,s2
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	d8e080e7          	jalr	-626(ra) # 3a8 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	bd51                	j	4b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 626:	8bce                	mv	s7,s3
      state = 0;
 628:	4981                	li	s3,0
 62a:	b579                	j	4b8 <vprintf+0x42>
 62c:	74e2                	ld	s1,56(sp)
 62e:	79a2                	ld	s3,40(sp)
 630:	7a02                	ld	s4,32(sp)
 632:	6ae2                	ld	s5,24(sp)
 634:	6b42                	ld	s6,16(sp)
 636:	6ba2                	ld	s7,8(sp)
    }
  }
}
 638:	60a6                	ld	ra,72(sp)
 63a:	6406                	ld	s0,64(sp)
 63c:	7942                	ld	s2,48(sp)
 63e:	6161                	addi	sp,sp,80
 640:	8082                	ret

0000000000000642 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 642:	715d                	addi	sp,sp,-80
 644:	ec06                	sd	ra,24(sp)
 646:	e822                	sd	s0,16(sp)
 648:	1000                	addi	s0,sp,32
 64a:	e010                	sd	a2,0(s0)
 64c:	e414                	sd	a3,8(s0)
 64e:	e818                	sd	a4,16(s0)
 650:	ec1c                	sd	a5,24(s0)
 652:	03043023          	sd	a6,32(s0)
 656:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65e:	8622                	mv	a2,s0
 660:	00000097          	auipc	ra,0x0
 664:	e16080e7          	jalr	-490(ra) # 476 <vprintf>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6161                	addi	sp,sp,80
 66e:	8082                	ret

0000000000000670 <printf>:

void
printf(const char *fmt, ...)
{
 670:	711d                	addi	sp,sp,-96
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	e40c                	sd	a1,8(s0)
 67a:	e810                	sd	a2,16(s0)
 67c:	ec14                	sd	a3,24(s0)
 67e:	f018                	sd	a4,32(s0)
 680:	f41c                	sd	a5,40(s0)
 682:	03043823          	sd	a6,48(s0)
 686:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68a:	00840613          	addi	a2,s0,8
 68e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 692:	85aa                	mv	a1,a0
 694:	4505                	li	a0,1
 696:	00000097          	auipc	ra,0x0
 69a:	de0080e7          	jalr	-544(ra) # 476 <vprintf>
}
 69e:	60e2                	ld	ra,24(sp)
 6a0:	6442                	ld	s0,16(sp)
 6a2:	6125                	addi	sp,sp,96
 6a4:	8082                	ret

00000000000006a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	00001797          	auipc	a5,0x1
 6b4:	9507b783          	ld	a5,-1712(a5) # 1000 <freep>
 6b8:	a02d                	j	6e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ba:	4618                	lw	a4,8(a2)
 6bc:	9f2d                	addw	a4,a4,a1
 6be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	6398                	ld	a4,0(a5)
 6c4:	6310                	ld	a2,0(a4)
 6c6:	a83d                	j	704 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c8:	ff852703          	lw	a4,-8(a0)
 6cc:	9f31                	addw	a4,a4,a2
 6ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d0:	ff053683          	ld	a3,-16(a0)
 6d4:	a091                	j	718 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d6:	6398                	ld	a4,0(a5)
 6d8:	00e7e463          	bltu	a5,a4,6e0 <free+0x3a>
 6dc:	00e6ea63          	bltu	a3,a4,6f0 <free+0x4a>
{
 6e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	fed7fae3          	bgeu	a5,a3,6d6 <free+0x30>
 6e6:	6398                	ld	a4,0(a5)
 6e8:	00e6e463          	bltu	a3,a4,6f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	fee7eae3          	bltu	a5,a4,6e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6f0:	ff852583          	lw	a1,-8(a0)
 6f4:	6390                	ld	a2,0(a5)
 6f6:	02059813          	slli	a6,a1,0x20
 6fa:	01c85713          	srli	a4,a6,0x1c
 6fe:	9736                	add	a4,a4,a3
 700:	fae60de3          	beq	a2,a4,6ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 708:	4790                	lw	a2,8(a5)
 70a:	02061593          	slli	a1,a2,0x20
 70e:	01c5d713          	srli	a4,a1,0x1c
 712:	973e                	add	a4,a4,a5
 714:	fae68ae3          	beq	a3,a4,6c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 718:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 71a:	00001717          	auipc	a4,0x1
 71e:	8ef73323          	sd	a5,-1818(a4) # 1000 <freep>
}
 722:	6422                	ld	s0,8(sp)
 724:	0141                	addi	sp,sp,16
 726:	8082                	ret

0000000000000728 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	f426                	sd	s1,40(sp)
 730:	ec4e                	sd	s3,24(sp)
 732:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 734:	02051493          	slli	s1,a0,0x20
 738:	9081                	srli	s1,s1,0x20
 73a:	04bd                	addi	s1,s1,15
 73c:	8091                	srli	s1,s1,0x4
 73e:	0014899b          	addiw	s3,s1,1
 742:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 744:	00001517          	auipc	a0,0x1
 748:	8bc53503          	ld	a0,-1860(a0) # 1000 <freep>
 74c:	c915                	beqz	a0,780 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 750:	4798                	lw	a4,8(a5)
 752:	08977e63          	bgeu	a4,s1,7ee <malloc+0xc6>
 756:	f04a                	sd	s2,32(sp)
 758:	e852                	sd	s4,16(sp)
 75a:	e456                	sd	s5,8(sp)
 75c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 75e:	8a4e                	mv	s4,s3
 760:	0009871b          	sext.w	a4,s3
 764:	6685                	lui	a3,0x1
 766:	00d77363          	bgeu	a4,a3,76c <malloc+0x44>
 76a:	6a05                	lui	s4,0x1
 76c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 770:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 774:	00001917          	auipc	s2,0x1
 778:	88c90913          	addi	s2,s2,-1908 # 1000 <freep>
  if(p == (char*)-1)
 77c:	5afd                	li	s5,-1
 77e:	a091                	j	7c2 <malloc+0x9a>
 780:	f04a                	sd	s2,32(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 788:	00001797          	auipc	a5,0x1
 78c:	88878793          	addi	a5,a5,-1912 # 1010 <base>
 790:	00001717          	auipc	a4,0x1
 794:	86f73823          	sd	a5,-1936(a4) # 1000 <freep>
 798:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 79e:	b7c1                	j	75e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	e118                	sd	a4,0(a0)
 7a4:	a08d                	j	806 <malloc+0xde>
  hp->s.size = nu;
 7a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7aa:	0541                	addi	a0,a0,16
 7ac:	00000097          	auipc	ra,0x0
 7b0:	efa080e7          	jalr	-262(ra) # 6a6 <free>
  return freep;
 7b4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b8:	c13d                	beqz	a0,81e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7bc:	4798                	lw	a4,8(a5)
 7be:	02977463          	bgeu	a4,s1,7e6 <malloc+0xbe>
    if(p == freep)
 7c2:	00093703          	ld	a4,0(s2)
 7c6:	853e                	mv	a0,a5
 7c8:	fef719e3          	bne	a4,a5,7ba <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7cc:	8552                	mv	a0,s4
 7ce:	00000097          	auipc	ra,0x0
 7d2:	bba080e7          	jalr	-1094(ra) # 388 <sbrk>
  if(p == (char*)-1)
 7d6:	fd5518e3          	bne	a0,s5,7a6 <malloc+0x7e>
        return 0;
 7da:	4501                	li	a0,0
 7dc:	7902                	ld	s2,32(sp)
 7de:	6a42                	ld	s4,16(sp)
 7e0:	6aa2                	ld	s5,8(sp)
 7e2:	6b02                	ld	s6,0(sp)
 7e4:	a03d                	j	812 <malloc+0xea>
 7e6:	7902                	ld	s2,32(sp)
 7e8:	6a42                	ld	s4,16(sp)
 7ea:	6aa2                	ld	s5,8(sp)
 7ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ee:	fae489e3          	beq	s1,a4,7a0 <malloc+0x78>
        p->s.size -= nunits;
 7f2:	4137073b          	subw	a4,a4,s3
 7f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f8:	02071693          	slli	a3,a4,0x20
 7fc:	01c6d713          	srli	a4,a3,0x1c
 800:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 802:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 806:	00000717          	auipc	a4,0x0
 80a:	7ea73d23          	sd	a0,2042(a4) # 1000 <freep>
      return (void*)(p + 1);
 80e:	01078513          	addi	a0,a5,16
  }
}
 812:	70e2                	ld	ra,56(sp)
 814:	7442                	ld	s0,48(sp)
 816:	74a2                	ld	s1,40(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6121                	addi	sp,sp,64
 81c:	8082                	ret
 81e:	7902                	ld	s2,32(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	b7f5                	j	812 <malloc+0xea>
