
user/_stressfs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	90a78793          	addi	a5,a5,-1782 # 920 <malloc+0x122>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8c450513          	addi	a0,a0,-1852 # 8f0 <malloc+0xf2>
  34:	00000097          	auipc	ra,0x0
  38:	70a080e7          	jalr	1802(ra) # 73e <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	158080e7          	jalr	344(ra) # 1a0 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	35a080e7          	jalr	858(ra) # 3ae <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	8a050513          	addi	a0,a0,-1888 # 908 <malloc+0x10a>
  70:	00000097          	auipc	ra,0x0
  74:	6ce080e7          	jalr	1742(ra) # 73e <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	36c080e7          	jalr	876(ra) # 3f6 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	336080e7          	jalr	822(ra) # 3d6 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	330080e7          	jalr	816(ra) # 3de <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	86250513          	addi	a0,a0,-1950 # 918 <malloc+0x11a>
  be:	00000097          	auipc	ra,0x0
  c2:	680080e7          	jalr	1664(ra) # 73e <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	32a080e7          	jalr	810(ra) # 3f6 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2ec080e7          	jalr	748(ra) # 3ce <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ee080e7          	jalr	750(ra) # 3de <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2c4080e7          	jalr	708(ra) # 3be <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	2b2080e7          	jalr	690(ra) # 3b6 <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	298080e7          	jalr	664(ra) # 3b6 <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf91                	beqz	a5,168 <strcmp+0x26>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71b63          	bne	a4,a5,168 <strcmp+0x26>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	c789                	beqz	a5,168 <strcmp+0x26>
 160:	0005c703          	lbu	a4,0(a1)
 164:	fef709e3          	beq	a4,a5,156 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 168:	0005c503          	lbu	a0,0(a1)
}
 16c:	40a7853b          	subw	a0,a5,a0
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strlen>:

uint
strlen(const char *s)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	cf91                	beqz	a5,19c <strlen+0x26>
 182:	0505                	addi	a0,a0,1
 184:	87aa                	mv	a5,a0
 186:	4685                	li	a3,1
 188:	9e89                	subw	a3,a3,a0
 18a:	00f6853b          	addw	a0,a3,a5
 18e:	0785                	addi	a5,a5,1
 190:	fff7c703          	lbu	a4,-1(a5)
 194:	fb7d                	bnez	a4,18a <strlen+0x14>
    ;
  return n;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  for(n = 0; s[n]; n++)
 19c:	4501                	li	a0,0
 19e:	bfe5                	j	196 <strlen+0x20>

00000000000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a6:	ce09                	beqz	a2,1c0 <memset+0x20>
 1a8:	87aa                	mv	a5,a0
 1aa:	fff6071b          	addiw	a4,a2,-1
 1ae:	1702                	slli	a4,a4,0x20
 1b0:	9301                	srli	a4,a4,0x20
 1b2:	0705                	addi	a4,a4,1
 1b4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ba:	0785                	addi	a5,a5,1
 1bc:	fee79de3          	bne	a5,a4,1b6 <memset+0x16>
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
 1d0:	cf91                	beqz	a5,1ec <strchr+0x26>
    if(*s == c)
 1d2:	00f58a63          	beq	a1,a5,1e6 <strchr+0x20>
  for(; *s; s++)
 1d6:	0505                	addi	a0,a0,1
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	c781                	beqz	a5,1e4 <strchr+0x1e>
    if(*s == c)
 1de:	feb79ce3          	bne	a5,a1,1d6 <strchr+0x10>
 1e2:	a011                	j	1e6 <strchr+0x20>
      return (char*)s;
  return 0;
 1e4:	4501                	li	a0,0
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  return 0;
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strchr+0x20>

00000000000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	711d                	addi	sp,sp,-96
 1f2:	ec86                	sd	ra,88(sp)
 1f4:	e8a2                	sd	s0,80(sp)
 1f6:	e4a6                	sd	s1,72(sp)
 1f8:	e0ca                	sd	s2,64(sp)
 1fa:	fc4e                	sd	s3,56(sp)
 1fc:	f852                	sd	s4,48(sp)
 1fe:	f456                	sd	s5,40(sp)
 200:	f05a                	sd	s6,32(sp)
 202:	ec5e                	sd	s7,24(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	892a                	mv	s2,a0
 20c:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20e:	4aa9                	li	s5,10
 210:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 212:	0019849b          	addiw	s1,s3,1
 216:	0344d863          	ble	s4,s1,246 <gets+0x56>
    cc = read(0, &c, 1);
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	1ac080e7          	jalr	428(ra) # 3ce <read>
    if(cc < 1)
 22a:	00a05e63          	blez	a0,246 <gets+0x56>
    buf[i++] = c;
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 236:	01578763          	beq	a5,s5,244 <gets+0x54>
 23a:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 23e:	fd679ae3          	bne	a5,s6,212 <gets+0x22>
 242:	a011                	j	246 <gets+0x56>
  for(i=0; i+1 < max; ){
 244:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
  return buf;
}
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e426                	sd	s1,8(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	182080e7          	jalr	386(ra) # 3f6 <open>
  if(fd < 0)
 27c:	02054563          	bltz	a0,2a6 <stat+0x42>
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	00000097          	auipc	ra,0x0
 288:	18a080e7          	jalr	394(ra) # 40e <fstat>
 28c:	892a                	mv	s2,a0
  close(fd);
 28e:	8526                	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	14e080e7          	jalr	334(ra) # 3de <close>
  return r;
}
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x34>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	andi	a5,a5,255
 2bc:	4725                	li	a4,9
 2be:	02f76963          	bltu	a4,a5,2f0 <atoi+0x46>
 2c2:	862a                	mv	a2,a0
  n = 0;
 2c4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2c6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2c8:	0605                	addi	a2,a2,1
 2ca:	0025179b          	slliw	a5,a0,0x2
 2ce:	9fa9                	addw	a5,a5,a0
 2d0:	0017979b          	slliw	a5,a5,0x1
 2d4:	9fb5                	addw	a5,a5,a3
 2d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2da:	00064683          	lbu	a3,0(a2)
 2de:	fd06871b          	addiw	a4,a3,-48
 2e2:	0ff77713          	andi	a4,a4,255
 2e6:	fee5f1e3          	bleu	a4,a1,2c8 <atoi+0x1e>
  return n;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  n = 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <atoi+0x40>

00000000000002f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fa:	02b57663          	bleu	a1,a0,326 <memmove+0x32>
    while(n-- > 0)
 2fe:	02c05163          	blez	a2,320 <memmove+0x2c>
 302:	fff6079b          	addiw	a5,a2,-1
 306:	1782                	slli	a5,a5,0x20
 308:	9381                	srli	a5,a5,0x20
 30a:	0785                	addi	a5,a5,1
 30c:	97aa                	add	a5,a5,a0
  dst = vdst;
 30e:	872a                	mv	a4,a0
      *dst++ = *src++;
 310:	0585                	addi	a1,a1,1
 312:	0705                	addi	a4,a4,1
 314:	fff5c683          	lbu	a3,-1(a1)
 318:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31c:	fee79ae3          	bne	a5,a4,310 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
    dst += n;
 326:	00c50733          	add	a4,a0,a2
    src += n;
 32a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32c:	fec05ae3          	blez	a2,320 <memmove+0x2c>
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	fff7c793          	not	a5,a5
 33c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33e:	15fd                	addi	a1,a1,-1
 340:	177d                	addi	a4,a4,-1
 342:	0005c683          	lbu	a3,0(a1)
 346:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34a:	fef71ae3          	bne	a4,a5,33e <memmove+0x4a>
 34e:	bfc9                	j	320 <memmove+0x2c>

0000000000000350 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 356:	ce15                	beqz	a2,392 <memcmp+0x42>
 358:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	02e79063          	bne	a5,a4,384 <memcmp+0x34>
 368:	1682                	slli	a3,a3,0x20
 36a:	9281                	srli	a3,a3,0x20
 36c:	0685                	addi	a3,a3,1
 36e:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 370:	0505                	addi	a0,a0,1
    p2++;
 372:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 374:	00d50d63          	beq	a0,a3,38e <memcmp+0x3e>
    if (*p1 != *p2) {
 378:	00054783          	lbu	a5,0(a0)
 37c:	0005c703          	lbu	a4,0(a1)
 380:	fee788e3          	beq	a5,a4,370 <memcmp+0x20>
      return *p1 - *p2;
 384:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <memcmp+0x38>
 392:	4501                	li	a0,0
 394:	bfd5                	j	388 <memcmp+0x38>

0000000000000396 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39e:	00000097          	auipc	ra,0x0
 3a2:	f56080e7          	jalr	-170(ra) # 2f4 <memmove>
}
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ae:	4885                	li	a7,1
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b6:	4889                	li	a7,2
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <wait>:
.global wait
wait:
 li a7, SYS_wait
 3be:	488d                	li	a7,3
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c6:	4891                	li	a7,4
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <read>:
.global read
read:
 li a7, SYS_read
 3ce:	4895                	li	a7,5
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <write>:
.global write
write:
 li a7, SYS_write
 3d6:	48c1                	li	a7,16
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <close>:
.global close
close:
 li a7, SYS_close
 3de:	48d5                	li	a7,21
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e6:	4899                	li	a7,6
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ee:	489d                	li	a7,7
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <open>:
.global open
open:
 li a7, SYS_open
 3f6:	48bd                	li	a7,15
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fe:	48c5                	li	a7,17
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 406:	48c9                	li	a7,18
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40e:	48a1                	li	a7,8
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <link>:
.global link
link:
 li a7, SYS_link
 416:	48cd                	li	a7,19
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41e:	48d1                	li	a7,20
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 426:	48a5                	li	a7,9
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <dup>:
.global dup
dup:
 li a7, SYS_dup
 42e:	48a9                	li	a7,10
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 436:	48ad                	li	a7,11
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43e:	48b1                	li	a7,12
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 446:	48b5                	li	a7,13
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44e:	48b9                	li	a7,14
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <trace>:
.global trace
trace:
 li a7, SYS_trace
 456:	48d9                	li	a7,22
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 45e:	48dd                	li	a7,23
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
 47c:	f5e080e7          	jalr	-162(ra) # 3d6 <write>
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
 490:	f04a                	sd	s2,32(sp)
 492:	ec4e                	sd	s3,24(sp)
 494:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 496:	c299                	beqz	a3,49c <printint+0x14>
 498:	0005cd63          	bltz	a1,4b2 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49c:	2581                	sext.w	a1,a1
  neg = 0;
 49e:	4301                	li	t1,0
 4a0:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 4a4:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 4a6:	2601                	sext.w	a2,a2
 4a8:	00000897          	auipc	a7,0x0
 4ac:	48888893          	addi	a7,a7,1160 # 930 <digits>
 4b0:	a801                	j	4c0 <printint+0x38>
    x = -xx;
 4b2:	40b005bb          	negw	a1,a1
 4b6:	2581                	sext.w	a1,a1
    neg = 1;
 4b8:	4305                	li	t1,1
    x = -xx;
 4ba:	b7dd                	j	4a0 <printint+0x18>
  }while((x /= base) != 0);
 4bc:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 4be:	8836                	mv	a6,a3
 4c0:	0018069b          	addiw	a3,a6,1
 4c4:	02c5f7bb          	remuw	a5,a1,a2
 4c8:	1782                	slli	a5,a5,0x20
 4ca:	9381                	srli	a5,a5,0x20
 4cc:	97c6                	add	a5,a5,a7
 4ce:	0007c783          	lbu	a5,0(a5)
 4d2:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 4d6:	0705                	addi	a4,a4,1
 4d8:	02c5d7bb          	divuw	a5,a1,a2
 4dc:	fec5f0e3          	bleu	a2,a1,4bc <printint+0x34>
  if(neg)
 4e0:	00030b63          	beqz	t1,4f6 <printint+0x6e>
    buf[i++] = '-';
 4e4:	fd040793          	addi	a5,s0,-48
 4e8:	96be                	add	a3,a3,a5
 4ea:	02d00793          	li	a5,45
 4ee:	fef68823          	sb	a5,-16(a3)
 4f2:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 4f6:	02d05963          	blez	a3,528 <printint+0xa0>
 4fa:	89aa                	mv	s3,a0
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00d784b3          	add	s1,a5,a3
 504:	fff78913          	addi	s2,a5,-1
 508:	9936                	add	s2,s2,a3
 50a:	36fd                	addiw	a3,a3,-1
 50c:	1682                	slli	a3,a3,0x20
 50e:	9281                	srli	a3,a3,0x20
 510:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 514:	fff4c583          	lbu	a1,-1(s1)
 518:	854e                	mv	a0,s3
 51a:	00000097          	auipc	ra,0x0
 51e:	f4c080e7          	jalr	-180(ra) # 466 <putc>
  while(--i >= 0)
 522:	14fd                	addi	s1,s1,-1
 524:	ff2498e3          	bne	s1,s2,514 <printint+0x8c>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret

0000000000000536 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 536:	7119                	addi	sp,sp,-128
 538:	fc86                	sd	ra,120(sp)
 53a:	f8a2                	sd	s0,112(sp)
 53c:	f4a6                	sd	s1,104(sp)
 53e:	f0ca                	sd	s2,96(sp)
 540:	ecce                	sd	s3,88(sp)
 542:	e8d2                	sd	s4,80(sp)
 544:	e4d6                	sd	s5,72(sp)
 546:	e0da                	sd	s6,64(sp)
 548:	fc5e                	sd	s7,56(sp)
 54a:	f862                	sd	s8,48(sp)
 54c:	f466                	sd	s9,40(sp)
 54e:	f06a                	sd	s10,32(sp)
 550:	ec6e                	sd	s11,24(sp)
 552:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 554:	0005c483          	lbu	s1,0(a1)
 558:	18048d63          	beqz	s1,6f2 <vprintf+0x1bc>
 55c:	8aaa                	mv	s5,a0
 55e:	8b32                	mv	s6,a2
 560:	00158913          	addi	s2,a1,1
  state = 0;
 564:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 566:	02500a13          	li	s4,37
      if(c == 'd'){
 56a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 56e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 572:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 576:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	00000b97          	auipc	s7,0x0
 57e:	3b6b8b93          	addi	s7,s7,950 # 930 <digits>
 582:	a839                	j	5a0 <vprintf+0x6a>
        putc(fd, c);
 584:	85a6                	mv	a1,s1
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	ede080e7          	jalr	-290(ra) # 466 <putc>
 590:	a019                	j	596 <vprintf+0x60>
    } else if(state == '%'){
 592:	01498f63          	beq	s3,s4,5b0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 596:	0905                	addi	s2,s2,1
 598:	fff94483          	lbu	s1,-1(s2)
 59c:	14048b63          	beqz	s1,6f2 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 5a0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5a4:	fe0997e3          	bnez	s3,592 <vprintf+0x5c>
      if(c == '%'){
 5a8:	fd479ee3          	bne	a5,s4,584 <vprintf+0x4e>
        state = '%';
 5ac:	89be                	mv	s3,a5
 5ae:	b7e5                	j	596 <vprintf+0x60>
      if(c == 'd'){
 5b0:	05878063          	beq	a5,s8,5f0 <vprintf+0xba>
      } else if(c == 'l') {
 5b4:	05978c63          	beq	a5,s9,60c <vprintf+0xd6>
      } else if(c == 'x') {
 5b8:	07a78863          	beq	a5,s10,628 <vprintf+0xf2>
      } else if(c == 'p') {
 5bc:	09b78463          	beq	a5,s11,644 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5c0:	07300713          	li	a4,115
 5c4:	0ce78563          	beq	a5,a4,68e <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c8:	06300713          	li	a4,99
 5cc:	0ee78c63          	beq	a5,a4,6c4 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5d0:	11478663          	beq	a5,s4,6dc <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d4:	85d2                	mv	a1,s4
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e8e080e7          	jalr	-370(ra) # 466 <putc>
        putc(fd, c);
 5e0:	85a6                	mv	a1,s1
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e82080e7          	jalr	-382(ra) # 466 <putc>
      }
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b765                	j	596 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5f0:	008b0493          	addi	s1,s6,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e8a080e7          	jalr	-374(ra) # 488 <printint>
 606:	8b26                	mv	s6,s1
      state = 0;
 608:	4981                	li	s3,0
 60a:	b771                	j	596 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	008b0493          	addi	s1,s6,8
 610:	4681                	li	a3,0
 612:	4629                	li	a2,10
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e6e080e7          	jalr	-402(ra) # 488 <printint>
 622:	8b26                	mv	s6,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	bf85                	j	596 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 628:	008b0493          	addi	s1,s6,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000b2583          	lw	a1,0(s6)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e52080e7          	jalr	-430(ra) # 488 <printint>
 63e:	8b26                	mv	s6,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	bf91                	j	596 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 644:	008b0793          	addi	a5,s6,8
 648:	f8f43423          	sd	a5,-120(s0)
 64c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 650:	03000593          	li	a1,48
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e10080e7          	jalr	-496(ra) # 466 <putc>
  putc(fd, 'x');
 65e:	85ea                	mv	a1,s10
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e04080e7          	jalr	-508(ra) # 466 <putc>
 66a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	03c9d793          	srli	a5,s3,0x3c
 670:	97de                	add	a5,a5,s7
 672:	0007c583          	lbu	a1,0(a5)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	dee080e7          	jalr	-530(ra) # 466 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 680:	0992                	slli	s3,s3,0x4
 682:	34fd                	addiw	s1,s1,-1
 684:	f4e5                	bnez	s1,66c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 686:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b729                	j	596 <vprintf+0x60>
        s = va_arg(ap, char*);
 68e:	008b0993          	addi	s3,s6,8
 692:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 696:	c085                	beqz	s1,6b6 <vprintf+0x180>
        while(*s != 0){
 698:	0004c583          	lbu	a1,0(s1)
 69c:	c9a1                	beqz	a1,6ec <vprintf+0x1b6>
          putc(fd, *s);
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	dc6080e7          	jalr	-570(ra) # 466 <putc>
          s++;
 6a8:	0485                	addi	s1,s1,1
        while(*s != 0){
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	f9e5                	bnez	a1,69e <vprintf+0x168>
        s = va_arg(ap, char*);
 6b0:	8b4e                	mv	s6,s3
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b5cd                	j	596 <vprintf+0x60>
          s = "(null)";
 6b6:	00000497          	auipc	s1,0x0
 6ba:	29248493          	addi	s1,s1,658 # 948 <digits+0x18>
        while(*s != 0){
 6be:	02800593          	li	a1,40
 6c2:	bff1                	j	69e <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 6c4:	008b0493          	addi	s1,s6,8
 6c8:	000b4583          	lbu	a1,0(s6)
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	d98080e7          	jalr	-616(ra) # 466 <putc>
 6d6:	8b26                	mv	s6,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd75                	j	596 <vprintf+0x60>
        putc(fd, c);
 6dc:	85d2                	mv	a1,s4
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	d86080e7          	jalr	-634(ra) # 466 <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b575                	j	596 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ec:	8b4e                	mv	s6,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b55d                	j	596 <vprintf+0x60>
    }
  }
}
 6f2:	70e6                	ld	ra,120(sp)
 6f4:	7446                	ld	s0,112(sp)
 6f6:	74a6                	ld	s1,104(sp)
 6f8:	7906                	ld	s2,96(sp)
 6fa:	69e6                	ld	s3,88(sp)
 6fc:	6a46                	ld	s4,80(sp)
 6fe:	6aa6                	ld	s5,72(sp)
 700:	6b06                	ld	s6,64(sp)
 702:	7be2                	ld	s7,56(sp)
 704:	7c42                	ld	s8,48(sp)
 706:	7ca2                	ld	s9,40(sp)
 708:	7d02                	ld	s10,32(sp)
 70a:	6de2                	ld	s11,24(sp)
 70c:	6109                	addi	sp,sp,128
 70e:	8082                	ret

0000000000000710 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 710:	715d                	addi	sp,sp,-80
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	addi	s0,sp,32
 718:	e010                	sd	a2,0(s0)
 71a:	e414                	sd	a3,8(s0)
 71c:	e818                	sd	a4,16(s0)
 71e:	ec1c                	sd	a5,24(s0)
 720:	03043023          	sd	a6,32(s0)
 724:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72c:	8622                	mv	a2,s0
 72e:	00000097          	auipc	ra,0x0
 732:	e08080e7          	jalr	-504(ra) # 536 <vprintf>
}
 736:	60e2                	ld	ra,24(sp)
 738:	6442                	ld	s0,16(sp)
 73a:	6161                	addi	sp,sp,80
 73c:	8082                	ret

000000000000073e <printf>:

void
printf(const char *fmt, ...)
{
 73e:	711d                	addi	sp,sp,-96
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	e40c                	sd	a1,8(s0)
 748:	e810                	sd	a2,16(s0)
 74a:	ec14                	sd	a3,24(s0)
 74c:	f018                	sd	a4,32(s0)
 74e:	f41c                	sd	a5,40(s0)
 750:	03043823          	sd	a6,48(s0)
 754:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	00840613          	addi	a2,s0,8
 75c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 760:	85aa                	mv	a1,a0
 762:	4505                	li	a0,1
 764:	00000097          	auipc	ra,0x0
 768:	dd2080e7          	jalr	-558(ra) # 536 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6125                	addi	sp,sp,96
 772:	8082                	ret

0000000000000774 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 774:	1141                	addi	sp,sp,-16
 776:	e422                	sd	s0,8(sp)
 778:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	00001797          	auipc	a5,0x1
 782:	88278793          	addi	a5,a5,-1918 # 1000 <freep>
 786:	639c                	ld	a5,0(a5)
 788:	a805                	j	7b8 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78a:	4618                	lw	a4,8(a2)
 78c:	9db9                	addw	a1,a1,a4
 78e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	6398                	ld	a4,0(a5)
 794:	6318                	ld	a4,0(a4)
 796:	fee53823          	sd	a4,-16(a0)
 79a:	a091                	j	7de <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79c:	ff852703          	lw	a4,-8(a0)
 7a0:	9e39                	addw	a2,a2,a4
 7a2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7a4:	ff053703          	ld	a4,-16(a0)
 7a8:	e398                	sd	a4,0(a5)
 7aa:	a099                	j	7f0 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e7e463          	bltu	a5,a4,7b6 <free+0x42>
 7b2:	00e6ea63          	bltu	a3,a4,7c6 <free+0x52>
{
 7b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	fed7fae3          	bleu	a3,a5,7ac <free+0x38>
 7bc:	6398                	ld	a4,0(a5)
 7be:	00e6e463          	bltu	a3,a4,7c6 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	fee7eae3          	bltu	a5,a4,7b6 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 7c6:	ff852583          	lw	a1,-8(a0)
 7ca:	6390                	ld	a2,0(a5)
 7cc:	02059713          	slli	a4,a1,0x20
 7d0:	9301                	srli	a4,a4,0x20
 7d2:	0712                	slli	a4,a4,0x4
 7d4:	9736                	add	a4,a4,a3
 7d6:	fae60ae3          	beq	a2,a4,78a <free+0x16>
    bp->s.ptr = p->s.ptr;
 7da:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7de:	4790                	lw	a2,8(a5)
 7e0:	02061713          	slli	a4,a2,0x20
 7e4:	9301                	srli	a4,a4,0x20
 7e6:	0712                	slli	a4,a4,0x4
 7e8:	973e                	add	a4,a4,a5
 7ea:	fae689e3          	beq	a3,a4,79c <free+0x28>
  } else
    p->s.ptr = bp;
 7ee:	e394                	sd	a3,0(a5)
  freep = p;
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
}
 7f8:	6422                	ld	s0,8(sp)
 7fa:	0141                	addi	sp,sp,16
 7fc:	8082                	ret

00000000000007fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f426                	sd	s1,40(sp)
 806:	f04a                	sd	s2,32(sp)
 808:	ec4e                	sd	s3,24(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
 810:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	02051993          	slli	s3,a0,0x20
 816:	0209d993          	srli	s3,s3,0x20
 81a:	09bd                	addi	s3,s3,15
 81c:	0049d993          	srli	s3,s3,0x4
 820:	2985                	addiw	s3,s3,1
 822:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 826:	00000797          	auipc	a5,0x0
 82a:	7da78793          	addi	a5,a5,2010 # 1000 <freep>
 82e:	6388                	ld	a0,0(a5)
 830:	c515                	beqz	a0,85c <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	03277f63          	bleu	s2,a4,874 <malloc+0x76>
 83a:	8a4e                	mv	s4,s3
 83c:	0009871b          	sext.w	a4,s3
 840:	6685                	lui	a3,0x1
 842:	00d77363          	bleu	a3,a4,848 <malloc+0x4a>
 846:	6a05                	lui	s4,0x1
 848:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 850:	00000497          	auipc	s1,0x0
 854:	7b048493          	addi	s1,s1,1968 # 1000 <freep>
  if(p == (char*)-1)
 858:	5b7d                	li	s6,-1
 85a:	a885                	j	8ca <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 85c:	00000797          	auipc	a5,0x0
 860:	7b478793          	addi	a5,a5,1972 # 1010 <base>
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
 86c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 872:	b7e1                	j	83a <malloc+0x3c>
      if(p->s.size == nunits)
 874:	02e90b63          	beq	s2,a4,8aa <malloc+0xac>
        p->s.size -= nunits;
 878:	4137073b          	subw	a4,a4,s3
 87c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87e:	1702                	slli	a4,a4,0x20
 880:	9301                	srli	a4,a4,0x20
 882:	0712                	slli	a4,a4,0x4
 884:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 886:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88a:	00000717          	auipc	a4,0x0
 88e:	76a73b23          	sd	a0,1910(a4) # 1000 <freep>
      return (void*)(p + 1);
 892:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 896:	70e2                	ld	ra,56(sp)
 898:	7442                	ld	s0,48(sp)
 89a:	74a2                	ld	s1,40(sp)
 89c:	7902                	ld	s2,32(sp)
 89e:	69e2                	ld	s3,24(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	6121                	addi	sp,sp,64
 8a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	e118                	sd	a4,0(a0)
 8ae:	bff1                	j	88a <malloc+0x8c>
  hp->s.size = nu;
 8b0:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 8b4:	0541                	addi	a0,a0,16
 8b6:	00000097          	auipc	ra,0x0
 8ba:	ebe080e7          	jalr	-322(ra) # 774 <free>
  return freep;
 8be:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c0:	d979                	beqz	a0,896 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	fb2777e3          	bleu	s2,a4,874 <malloc+0x76>
    if(p == freep)
 8ca:	6098                	ld	a4,0(s1)
 8cc:	853e                	mv	a0,a5
 8ce:	fef71ae3          	bne	a4,a5,8c2 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	00000097          	auipc	ra,0x0
 8d8:	b6a080e7          	jalr	-1174(ra) # 43e <sbrk>
  if(p == (char*)-1)
 8dc:	fd651ae3          	bne	a0,s6,8b0 <malloc+0xb2>
        return 0;
 8e0:	4501                	li	a0,0
 8e2:	bf55                	j	896 <malloc+0x98>
