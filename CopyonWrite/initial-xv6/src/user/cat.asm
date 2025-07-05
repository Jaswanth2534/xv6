
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3a0080e7          	jalr	928(ra) # 3c0 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	394080e7          	jalr	916(ra) # 3c8 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	89058593          	addi	a1,a1,-1904 # 8d0 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6a0080e7          	jalr	1696(ra) # 6ea <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	354080e7          	jalr	852(ra) # 3a8 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	87a58593          	addi	a1,a1,-1926 # 8e8 <malloc+0x118>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	672080e7          	jalr	1650(ra) # 6ea <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	326080e7          	jalr	806(ra) # 3a8 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2) # 1010 <buf>
  b8:	00000097          	auipc	ra,0x0
  bc:	330080e7          	jalr	816(ra) # 3e8 <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	300080e7          	jalr	768(ra) # 3d0 <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c8080e7          	jalr	712(ra) # 3a8 <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2ae080e7          	jalr	686(ra) # 3a8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00000597          	auipc	a1,0x0
 10a:	7fa58593          	addi	a1,a1,2042 # 900 <malloc+0x130>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	5da080e7          	jalr	1498(ra) # 6ea <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	28e080e7          	jalr	654(ra) # 3a8 <exit>

0000000000000122 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	f60080e7          	jalr	-160(ra) # 8a <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	274080e7          	jalr	628(ra) # 3a8 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	19a080e7          	jalr	410(ra) # 3c0 <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	addi	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	172080e7          	jalr	370(ra) # 3e8 <open>
  if(fd < 0)
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	178080e7          	jalr	376(ra) # 400 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	13c080e7          	jalr	316(ra) # 3d0 <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfcd                	j	29e <stat+0x36>

00000000000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66863          	bltu	a2,a5,2f2 <atoi+0x44>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1c>
  return n;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  n = 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <atoi+0x3e>

00000000000002f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57463          	bgeu	a0,a1,324 <memmove+0x2e>
    while(n-- > 0)
 300:	00c05f63          	blez	a2,31e <memmove+0x28>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
      *dst++ = *src++;
 30e:	0585                	addi	a1,a1,1
 310:	0705                	addi	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
    dst += n;
 324:	00c50733          	add	a4,a0,a2
    src += n;
 328:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32a:	fec05ae3          	blez	a2,31e <memmove+0x28>
 32e:	fff6079b          	addiw	a5,a2,-1
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33c:	15fd                	addi	a1,a1,-1
 33e:	177d                	addi	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x46>
 34c:	bfc9                	j	31e <memmove+0x28>

000000000000034e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca05                	beqz	a2,384 <memcmp+0x36>
 356:	fff6069b          	addiw	a3,a2,-1
 35a:	1682                	slli	a3,a3,0x20
 35c:	9281                	srli	a3,a3,0x20
 35e:	0685                	addi	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x14>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x30>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <memcmp+0x30>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	00000097          	auipc	ra,0x0
 394:	f66080e7          	jalr	-154(ra) # 2f6 <memmove>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 448:	48d9                	li	a7,22
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	addi	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	addi	a1,s0,-17
 462:	00000097          	auipc	ra,0x0
 466:	f66080e7          	jalr	-154(ra) # 3c8 <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 472:	7139                	addi	sp,sp,-64
 474:	fc06                	sd	ra,56(sp)
 476:	f822                	sd	s0,48(sp)
 478:	f426                	sd	s1,40(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	c299                	beqz	a3,484 <printint+0x12>
 480:	0805cb63          	bltz	a1,516 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 484:	2581                	sext.w	a1,a1
  neg = 0;
 486:	4881                	li	a7,0
 488:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 48c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48e:	2601                	sext.w	a2,a2
 490:	00000517          	auipc	a0,0x0
 494:	4e850513          	addi	a0,a0,1256 # 978 <digits>
 498:	883a                	mv	a6,a4
 49a:	2705                	addiw	a4,a4,1
 49c:	02c5f7bb          	remuw	a5,a1,a2
 4a0:	1782                	slli	a5,a5,0x20
 4a2:	9381                	srli	a5,a5,0x20
 4a4:	97aa                	add	a5,a5,a0
 4a6:	0007c783          	lbu	a5,0(a5)
 4aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ae:	0005879b          	sext.w	a5,a1
 4b2:	02c5d5bb          	divuw	a1,a1,a2
 4b6:	0685                	addi	a3,a3,1
 4b8:	fec7f0e3          	bgeu	a5,a2,498 <printint+0x26>
  if(neg)
 4bc:	00088c63          	beqz	a7,4d4 <printint+0x62>
    buf[i++] = '-';
 4c0:	fd070793          	addi	a5,a4,-48
 4c4:	00878733          	add	a4,a5,s0
 4c8:	02d00793          	li	a5,45
 4cc:	fef70823          	sb	a5,-16(a4)
 4d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d4:	02e05c63          	blez	a4,50c <printint+0x9a>
 4d8:	f04a                	sd	s2,32(sp)
 4da:	ec4e                	sd	s3,24(sp)
 4dc:	fc040793          	addi	a5,s0,-64
 4e0:	00e78933          	add	s2,a5,a4
 4e4:	fff78993          	addi	s3,a5,-1
 4e8:	99ba                	add	s3,s3,a4
 4ea:	377d                	addiw	a4,a4,-1
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	fff94583          	lbu	a1,-1(s2)
 4f8:	8526                	mv	a0,s1
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f56080e7          	jalr	-170(ra) # 450 <putc>
  while(--i >= 0)
 502:	197d                	addi	s2,s2,-1
 504:	ff3918e3          	bne	s2,s3,4f4 <printint+0x82>
 508:	7902                	ld	s2,32(sp)
 50a:	69e2                	ld	s3,24(sp)
}
 50c:	70e2                	ld	ra,56(sp)
 50e:	7442                	ld	s0,48(sp)
 510:	74a2                	ld	s1,40(sp)
 512:	6121                	addi	sp,sp,64
 514:	8082                	ret
    x = -xx;
 516:	40b005bb          	negw	a1,a1
    neg = 1;
 51a:	4885                	li	a7,1
    x = -xx;
 51c:	b7b5                	j	488 <printint+0x16>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	715d                	addi	sp,sp,-80
 520:	e486                	sd	ra,72(sp)
 522:	e0a2                	sd	s0,64(sp)
 524:	f84a                	sd	s2,48(sp)
 526:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 528:	0005c903          	lbu	s2,0(a1)
 52c:	1a090a63          	beqz	s2,6e0 <vprintf+0x1c2>
 530:	fc26                	sd	s1,56(sp)
 532:	f44e                	sd	s3,40(sp)
 534:	f052                	sd	s4,32(sp)
 536:	ec56                	sd	s5,24(sp)
 538:	e85a                	sd	s6,16(sp)
 53a:	e45e                	sd	s7,8(sp)
 53c:	8aaa                	mv	s5,a0
 53e:	8bb2                	mv	s7,a2
 540:	00158493          	addi	s1,a1,1
  state = 0;
 544:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 546:	02500a13          	li	s4,37
 54a:	4b55                	li	s6,21
 54c:	a839                	j	56a <vprintf+0x4c>
        putc(fd, c);
 54e:	85ca                	mv	a1,s2
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	efe080e7          	jalr	-258(ra) # 450 <putc>
 55a:	a019                	j	560 <vprintf+0x42>
    } else if(state == '%'){
 55c:	01498d63          	beq	s3,s4,576 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 560:	0485                	addi	s1,s1,1
 562:	fff4c903          	lbu	s2,-1(s1)
 566:	16090763          	beqz	s2,6d4 <vprintf+0x1b6>
    if(state == 0){
 56a:	fe0999e3          	bnez	s3,55c <vprintf+0x3e>
      if(c == '%'){
 56e:	ff4910e3          	bne	s2,s4,54e <vprintf+0x30>
        state = '%';
 572:	89d2                	mv	s3,s4
 574:	b7f5                	j	560 <vprintf+0x42>
      if(c == 'd'){
 576:	13490463          	beq	s2,s4,69e <vprintf+0x180>
 57a:	f9d9079b          	addiw	a5,s2,-99
 57e:	0ff7f793          	zext.b	a5,a5
 582:	12fb6763          	bltu	s6,a5,6b0 <vprintf+0x192>
 586:	f9d9079b          	addiw	a5,s2,-99
 58a:	0ff7f713          	zext.b	a4,a5
 58e:	12eb6163          	bltu	s6,a4,6b0 <vprintf+0x192>
 592:	00271793          	slli	a5,a4,0x2
 596:	00000717          	auipc	a4,0x0
 59a:	38a70713          	addi	a4,a4,906 # 920 <malloc+0x150>
 59e:	97ba                	add	a5,a5,a4
 5a0:	439c                	lw	a5,0(a5)
 5a2:	97ba                	add	a5,a5,a4
 5a4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	ebe080e7          	jalr	-322(ra) # 472 <printint>
 5bc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b745                	j	560 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	ea2080e7          	jalr	-350(ra) # 472 <printint>
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b751                	j	560 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e86080e7          	jalr	-378(ra) # 472 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b7a5                	j	560 <vprintf+0x42>
 5fa:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5fc:	008b8c13          	addi	s8,s7,8
 600:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 604:	03000593          	li	a1,48
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e46080e7          	jalr	-442(ra) # 450 <putc>
  putc(fd, 'x');
 612:	07800593          	li	a1,120
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e38080e7          	jalr	-456(ra) # 450 <putc>
 620:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	356b8b93          	addi	s7,s7,854 # 978 <digits>
 62a:	03c9d793          	srli	a5,s3,0x3c
 62e:	97de                	add	a5,a5,s7
 630:	0007c583          	lbu	a1,0(a5)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e1a080e7          	jalr	-486(ra) # 450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63e:	0992                	slli	s3,s3,0x4
 640:	397d                	addiw	s2,s2,-1
 642:	fe0914e3          	bnez	s2,62a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 646:	8be2                	mv	s7,s8
      state = 0;
 648:	4981                	li	s3,0
 64a:	6c02                	ld	s8,0(sp)
 64c:	bf11                	j	560 <vprintf+0x42>
        s = va_arg(ap, char*);
 64e:	008b8993          	addi	s3,s7,8
 652:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 656:	02090163          	beqz	s2,678 <vprintf+0x15a>
        while(*s != 0){
 65a:	00094583          	lbu	a1,0(s2)
 65e:	c9a5                	beqz	a1,6ce <vprintf+0x1b0>
          putc(fd, *s);
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	dee080e7          	jalr	-530(ra) # 450 <putc>
          s++;
 66a:	0905                	addi	s2,s2,1
        while(*s != 0){
 66c:	00094583          	lbu	a1,0(s2)
 670:	f9e5                	bnez	a1,660 <vprintf+0x142>
        s = va_arg(ap, char*);
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b5ed                	j	560 <vprintf+0x42>
          s = "(null)";
 678:	00000917          	auipc	s2,0x0
 67c:	2a090913          	addi	s2,s2,672 # 918 <malloc+0x148>
        while(*s != 0){
 680:	02800593          	li	a1,40
 684:	bff1                	j	660 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 686:	008b8913          	addi	s2,s7,8
 68a:	000bc583          	lbu	a1,0(s7)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	dc0080e7          	jalr	-576(ra) # 450 <putc>
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b5d1                	j	560 <vprintf+0x42>
        putc(fd, c);
 69e:	02500593          	li	a1,37
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	dac080e7          	jalr	-596(ra) # 450 <putc>
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bd4d                	j	560 <vprintf+0x42>
        putc(fd, '%');
 6b0:	02500593          	li	a1,37
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d9a080e7          	jalr	-614(ra) # 450 <putc>
        putc(fd, c);
 6be:	85ca                	mv	a1,s2
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	d8e080e7          	jalr	-626(ra) # 450 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd51                	j	560 <vprintf+0x42>
        s = va_arg(ap, char*);
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b579                	j	560 <vprintf+0x42>
 6d4:	74e2                	ld	s1,56(sp)
 6d6:	79a2                	ld	s3,40(sp)
 6d8:	7a02                	ld	s4,32(sp)
 6da:	6ae2                	ld	s5,24(sp)
 6dc:	6b42                	ld	s6,16(sp)
 6de:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e0:	60a6                	ld	ra,72(sp)
 6e2:	6406                	ld	s0,64(sp)
 6e4:	7942                	ld	s2,48(sp)
 6e6:	6161                	addi	sp,sp,80
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	00000097          	auipc	ra,0x0
 70c:	e16080e7          	jalr	-490(ra) # 51e <vprintf>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6161                	addi	sp,sp,80
 716:	8082                	ret

0000000000000718 <printf>:

void
printf(const char *fmt, ...)
{
 718:	711d                	addi	sp,sp,-96
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	addi	s0,sp,32
 720:	e40c                	sd	a1,8(s0)
 722:	e810                	sd	a2,16(s0)
 724:	ec14                	sd	a3,24(s0)
 726:	f018                	sd	a4,32(s0)
 728:	f41c                	sd	a5,40(s0)
 72a:	03043823          	sd	a6,48(s0)
 72e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	00840613          	addi	a2,s0,8
 736:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73a:	85aa                	mv	a1,a0
 73c:	4505                	li	a0,1
 73e:	00000097          	auipc	ra,0x0
 742:	de0080e7          	jalr	-544(ra) # 51e <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret

000000000000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	1141                	addi	sp,sp,-16
 750:	e422                	sd	s0,8(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00001797          	auipc	a5,0x1
 75c:	8a87b783          	ld	a5,-1880(a5) # 1000 <freep>
 760:	a02d                	j	78a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 762:	4618                	lw	a4,8(a2)
 764:	9f2d                	addw	a4,a4,a1
 766:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	6398                	ld	a4,0(a5)
 76c:	6310                	ld	a2,0(a4)
 76e:	a83d                	j	7ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9f31                	addw	a4,a4,a2
 776:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053683          	ld	a3,-16(a0)
 77c:	a091                	j	7c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x3a>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x4a>
{
 788:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x30>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059813          	slli	a6,a1,0x20
 7a2:	01c85713          	srli	a4,a6,0x1c
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60de3          	beq	a2,a4,762 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061593          	slli	a1,a2,0x20
 7b6:	01c5d713          	srli	a4,a1,0x1c
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae68ae3          	beq	a3,a4,770 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
}
 7ca:	6422                	ld	s0,8(sp)
 7cc:	0141                	addi	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	ec4e                	sd	s3,24(sp)
 7da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dc:	02051493          	slli	s1,a0,0x20
 7e0:	9081                	srli	s1,s1,0x20
 7e2:	04bd                	addi	s1,s1,15
 7e4:	8091                	srli	s1,s1,0x4
 7e6:	0014899b          	addiw	s3,s1,1
 7ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ec:	00001517          	auipc	a0,0x1
 7f0:	81453503          	ld	a0,-2028(a0) # 1000 <freep>
 7f4:	c915                	beqz	a0,828 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	08977e63          	bgeu	a4,s1,896 <malloc+0xc6>
 7fe:	f04a                	sd	s2,32(sp)
 800:	e852                	sd	s4,16(sp)
 802:	e456                	sd	s5,8(sp)
 804:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 806:	8a4e                	mv	s4,s3
 808:	0009871b          	sext.w	a4,s3
 80c:	6685                	lui	a3,0x1
 80e:	00d77363          	bgeu	a4,a3,814 <malloc+0x44>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000917          	auipc	s2,0x0
 820:	7e490913          	addi	s2,s2,2020 # 1000 <freep>
  if(p == (char*)-1)
 824:	5afd                	li	s5,-1
 826:	a091                	j	86a <malloc+0x9a>
 828:	f04a                	sd	s2,32(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 830:	00001797          	auipc	a5,0x1
 834:	9e078793          	addi	a5,a5,-1568 # 1210 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7c1                	j	806 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	e118                	sd	a4,0(a0)
 84c:	a08d                	j	8ae <malloc+0xde>
  hp->s.size = nu;
 84e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 852:	0541                	addi	a0,a0,16
 854:	00000097          	auipc	ra,0x0
 858:	efa080e7          	jalr	-262(ra) # 74e <free>
  return freep;
 85c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 860:	c13d                	beqz	a0,8c6 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	02977463          	bgeu	a4,s1,88e <malloc+0xbe>
    if(p == freep)
 86a:	00093703          	ld	a4,0(s2)
 86e:	853e                	mv	a0,a5
 870:	fef719e3          	bne	a4,a5,862 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	00000097          	auipc	ra,0x0
 87a:	bba080e7          	jalr	-1094(ra) # 430 <sbrk>
  if(p == (char*)-1)
 87e:	fd5518e3          	bne	a0,s5,84e <malloc+0x7e>
        return 0;
 882:	4501                	li	a0,0
 884:	7902                	ld	s2,32(sp)
 886:	6a42                	ld	s4,16(sp)
 888:	6aa2                	ld	s5,8(sp)
 88a:	6b02                	ld	s6,0(sp)
 88c:	a03d                	j	8ba <malloc+0xea>
 88e:	7902                	ld	s2,32(sp)
 890:	6a42                	ld	s4,16(sp)
 892:	6aa2                	ld	s5,8(sp)
 894:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 896:	fae489e3          	beq	s1,a4,848 <malloc+0x78>
        p->s.size -= nunits;
 89a:	4137073b          	subw	a4,a4,s3
 89e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a0:	02071693          	slli	a3,a4,0x20
 8a4:	01c6d713          	srli	a4,a3,0x1c
 8a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ae:	00000717          	auipc	a4,0x0
 8b2:	74a73923          	sd	a0,1874(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b6:	01078513          	addi	a0,a5,16
  }
}
 8ba:	70e2                	ld	ra,56(sp)
 8bc:	7442                	ld	s0,48(sp)
 8be:	74a2                	ld	s1,40(sp)
 8c0:	69e2                	ld	s3,24(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
 8c6:	7902                	ld	s2,32(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
 8ce:	b7f5                	j	8ba <malloc+0xea>
