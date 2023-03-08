
user/_rm：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	ble	a0,a5,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	348080e7          	jalr	840(ra) # 372 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	81258593          	addi	a1,a1,-2030 # 850 <malloc+0xe6>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	634080e7          	jalr	1588(ra) # 67c <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2d0080e7          	jalr	720(ra) # 322 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	80c58593          	addi	a1,a1,-2036 # 868 <malloc+0xfe>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	616080e7          	jalr	1558(ra) # 67c <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	2b2080e7          	jalr	690(ra) # 322 <exit>

0000000000000078 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	298080e7          	jalr	664(ra) # 322 <exit>

0000000000000092 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
    ;
  return os;
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strcmp+0x26>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71b63          	bne	a4,a5,d4 <strcmp+0x26>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	c789                	beqz	a5,d4 <strcmp+0x26>
  cc:	0005c703          	lbu	a4,0(a1)
  d0:	fef709e3          	beq	a4,a5,c2 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	addi	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	4685                	li	a3,1
  f4:	9e89                	subw	a3,a3,a0
  f6:	00f6853b          	addw	a0,a3,a5
  fa:	0785                	addi	a5,a5,1
  fc:	fff7c703          	lbu	a4,-1(a5)
 100:	fb7d                	bnez	a4,f6 <strlen+0x14>
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ce09                	beqz	a2,12c <memset+0x20>
 114:	87aa                	mv	a5,a0
 116:	fff6071b          	addiw	a4,a2,-1
 11a:	1702                	slli	a4,a4,0x20
 11c:	9301                	srli	a4,a4,0x20
 11e:	0705                	addi	a4,a4,1
 120:	972a                	add	a4,a4,a0
    cdst[i] = c;
 122:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 126:	0785                	addi	a5,a5,1
 128:	fee79de3          	bne	a5,a4,122 <memset+0x16>
  }
  return dst;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strchr>:

char*
strchr(const char *s, char c)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strchr+0x26>
    if(*s == c)
 13e:	00f58a63          	beq	a1,a5,152 <strchr+0x20>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	c781                	beqz	a5,150 <strchr+0x1e>
    if(*s == c)
 14a:	feb79ce3          	bne	a5,a1,142 <strchr+0x10>
 14e:	a011                	j	152 <strchr+0x20>
      return (char*)s;
  return 0;
 150:	4501                	li	a0,0
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  return 0;
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strchr+0x20>

000000000000015c <gets>:

char*
gets(char *buf, int max)
{
 15c:	711d                	addi	sp,sp,-96
 15e:	ec86                	sd	ra,88(sp)
 160:	e8a2                	sd	s0,80(sp)
 162:	e4a6                	sd	s1,72(sp)
 164:	e0ca                	sd	s2,64(sp)
 166:	fc4e                	sd	s3,56(sp)
 168:	f852                	sd	s4,48(sp)
 16a:	f456                	sd	s5,40(sp)
 16c:	f05a                	sd	s6,32(sp)
 16e:	ec5e                	sd	s7,24(sp)
 170:	1080                	addi	s0,sp,96
 172:	8baa                	mv	s7,a0
 174:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	892a                	mv	s2,a0
 178:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17a:	4aa9                	li	s5,10
 17c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17e:	0019849b          	addiw	s1,s3,1
 182:	0344d863          	ble	s4,s1,1b2 <gets+0x56>
    cc = read(0, &c, 1);
 186:	4605                	li	a2,1
 188:	faf40593          	addi	a1,s0,-81
 18c:	4501                	li	a0,0
 18e:	00000097          	auipc	ra,0x0
 192:	1ac080e7          	jalr	428(ra) # 33a <read>
    if(cc < 1)
 196:	00a05e63          	blez	a0,1b2 <gets+0x56>
    buf[i++] = c;
 19a:	faf44783          	lbu	a5,-81(s0)
 19e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a2:	01578763          	beq	a5,s5,1b0 <gets+0x54>
 1a6:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 1a8:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 1aa:	fd679ae3          	bne	a5,s6,17e <gets+0x22>
 1ae:	a011                	j	1b2 <gets+0x56>
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b2:	99de                	add	s3,s3,s7
 1b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b8:	855e                	mv	a0,s7
 1ba:	60e6                	ld	ra,88(sp)
 1bc:	6446                	ld	s0,80(sp)
 1be:	64a6                	ld	s1,72(sp)
 1c0:	6906                	ld	s2,64(sp)
 1c2:	79e2                	ld	s3,56(sp)
 1c4:	7a42                	ld	s4,48(sp)
 1c6:	7aa2                	ld	s5,40(sp)
 1c8:	7b02                	ld	s6,32(sp)
 1ca:	6be2                	ld	s7,24(sp)
 1cc:	6125                	addi	sp,sp,96
 1ce:	8082                	ret

00000000000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	1101                	addi	sp,sp,-32
 1d2:	ec06                	sd	ra,24(sp)
 1d4:	e822                	sd	s0,16(sp)
 1d6:	e426                	sd	s1,8(sp)
 1d8:	e04a                	sd	s2,0(sp)
 1da:	1000                	addi	s0,sp,32
 1dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1de:	4581                	li	a1,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	182080e7          	jalr	386(ra) # 362 <open>
  if(fd < 0)
 1e8:	02054563          	bltz	a0,212 <stat+0x42>
 1ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ee:	85ca                	mv	a1,s2
 1f0:	00000097          	auipc	ra,0x0
 1f4:	18a080e7          	jalr	394(ra) # 37a <fstat>
 1f8:	892a                	mv	s2,a0
  close(fd);
 1fa:	8526                	mv	a0,s1
 1fc:	00000097          	auipc	ra,0x0
 200:	14e080e7          	jalr	334(ra) # 34a <close>
  return r;
}
 204:	854a                	mv	a0,s2
 206:	60e2                	ld	ra,24(sp)
 208:	6442                	ld	s0,16(sp)
 20a:	64a2                	ld	s1,8(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	597d                	li	s2,-1
 214:	bfc5                	j	204 <stat+0x34>

0000000000000216 <atoi>:

int
atoi(const char *s)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21c:	00054683          	lbu	a3,0(a0)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	andi	a5,a5,255
 228:	4725                	li	a4,9
 22a:	02f76963          	bltu	a4,a5,25c <atoi+0x46>
 22e:	862a                	mv	a2,a0
  n = 0;
 230:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 232:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 234:	0605                	addi	a2,a2,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 246:	00064683          	lbu	a3,0(a2)
 24a:	fd06871b          	addiw	a4,a3,-48
 24e:	0ff77713          	andi	a4,a4,255
 252:	fee5f1e3          	bleu	a4,a1,234 <atoi+0x1e>
  return n;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  n = 0;
 25c:	4501                	li	a0,0
 25e:	bfe5                	j	256 <atoi+0x40>

0000000000000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 266:	02b57663          	bleu	a1,a0,292 <memmove+0x32>
    while(n-- > 0)
 26a:	02c05163          	blez	a2,28c <memmove+0x2c>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	0785                	addi	a5,a5,1
 278:	97aa                	add	a5,a5,a0
  dst = vdst;
 27a:	872a                	mv	a4,a0
      *dst++ = *src++;
 27c:	0585                	addi	a1,a1,1
 27e:	0705                	addi	a4,a4,1
 280:	fff5c683          	lbu	a3,-1(a1)
 284:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
    dst += n;
 292:	00c50733          	add	a4,a0,a2
    src += n;
 296:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 298:	fec05ae3          	blez	a2,28c <memmove+0x2c>
 29c:	fff6079b          	addiw	a5,a2,-1
 2a0:	1782                	slli	a5,a5,0x20
 2a2:	9381                	srli	a5,a5,0x20
 2a4:	fff7c793          	not	a5,a5
 2a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2aa:	15fd                	addi	a1,a1,-1
 2ac:	177d                	addi	a4,a4,-1
 2ae:	0005c683          	lbu	a3,0(a1)
 2b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b6:	fef71ae3          	bne	a4,a5,2aa <memmove+0x4a>
 2ba:	bfc9                	j	28c <memmove+0x2c>

00000000000002bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c2:	ce15                	beqz	a2,2fe <memcmp+0x42>
 2c4:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	02e79063          	bne	a5,a4,2f0 <memcmp+0x34>
 2d4:	1682                	slli	a3,a3,0x20
 2d6:	9281                	srli	a3,a3,0x20
 2d8:	0685                	addi	a3,a3,1
 2da:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2dc:	0505                	addi	a0,a0,1
    p2++;
 2de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e0:	00d50d63          	beq	a0,a3,2fa <memcmp+0x3e>
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	fee788e3          	beq	a5,a4,2dc <memcmp+0x20>
      return *p1 - *p2;
 2f0:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <memcmp+0x38>
 2fe:	4501                	li	a0,0
 300:	bfd5                	j	2f4 <memcmp+0x38>

0000000000000302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30a:	00000097          	auipc	ra,0x0
 30e:	f56080e7          	jalr	-170(ra) # 260 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f5e080e7          	jalr	-162(ra) # 342 <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 402:	c299                	beqz	a3,408 <printint+0x14>
 404:	0005cd63          	bltz	a1,41e <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 408:	2581                	sext.w	a1,a1
  neg = 0;
 40a:	4301                	li	t1,0
 40c:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 410:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 412:	2601                	sext.w	a2,a2
 414:	00000897          	auipc	a7,0x0
 418:	47488893          	addi	a7,a7,1140 # 888 <digits>
 41c:	a801                	j	42c <printint+0x38>
    x = -xx;
 41e:	40b005bb          	negw	a1,a1
 422:	2581                	sext.w	a1,a1
    neg = 1;
 424:	4305                	li	t1,1
    x = -xx;
 426:	b7dd                	j	40c <printint+0x18>
  }while((x /= base) != 0);
 428:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 42a:	8836                	mv	a6,a3
 42c:	0018069b          	addiw	a3,a6,1
 430:	02c5f7bb          	remuw	a5,a1,a2
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	97c6                	add	a5,a5,a7
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 442:	0705                	addi	a4,a4,1
 444:	02c5d7bb          	divuw	a5,a1,a2
 448:	fec5f0e3          	bleu	a2,a1,428 <printint+0x34>
  if(neg)
 44c:	00030b63          	beqz	t1,462 <printint+0x6e>
    buf[i++] = '-';
 450:	fd040793          	addi	a5,s0,-48
 454:	96be                	add	a3,a3,a5
 456:	02d00793          	li	a5,45
 45a:	fef68823          	sb	a5,-16(a3)
 45e:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 462:	02d05963          	blez	a3,494 <printint+0xa0>
 466:	89aa                	mv	s3,a0
 468:	fc040793          	addi	a5,s0,-64
 46c:	00d784b3          	add	s1,a5,a3
 470:	fff78913          	addi	s2,a5,-1
 474:	9936                	add	s2,s2,a3
 476:	36fd                	addiw	a3,a3,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 480:	fff4c583          	lbu	a1,-1(s1)
 484:	854e                	mv	a0,s3
 486:	00000097          	auipc	ra,0x0
 48a:	f4c080e7          	jalr	-180(ra) # 3d2 <putc>
  while(--i >= 0)
 48e:	14fd                	addi	s1,s1,-1
 490:	ff2498e3          	bne	s1,s2,480 <printint+0x8c>
}
 494:	70e2                	ld	ra,56(sp)
 496:	7442                	ld	s0,48(sp)
 498:	74a2                	ld	s1,40(sp)
 49a:	7902                	ld	s2,32(sp)
 49c:	69e2                	ld	s3,24(sp)
 49e:	6121                	addi	sp,sp,64
 4a0:	8082                	ret

00000000000004a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a2:	7119                	addi	sp,sp,-128
 4a4:	fc86                	sd	ra,120(sp)
 4a6:	f8a2                	sd	s0,112(sp)
 4a8:	f4a6                	sd	s1,104(sp)
 4aa:	f0ca                	sd	s2,96(sp)
 4ac:	ecce                	sd	s3,88(sp)
 4ae:	e8d2                	sd	s4,80(sp)
 4b0:	e4d6                	sd	s5,72(sp)
 4b2:	e0da                	sd	s6,64(sp)
 4b4:	fc5e                	sd	s7,56(sp)
 4b6:	f862                	sd	s8,48(sp)
 4b8:	f466                	sd	s9,40(sp)
 4ba:	f06a                	sd	s10,32(sp)
 4bc:	ec6e                	sd	s11,24(sp)
 4be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	18048d63          	beqz	s1,65e <vprintf+0x1bc>
 4c8:	8aaa                	mv	s5,a0
 4ca:	8b32                	mv	s6,a2
 4cc:	00158913          	addi	s2,a1,1
  state = 0;
 4d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d2:	02500a13          	li	s4,37
      if(c == 'd'){
 4d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e6:	00000b97          	auipc	s7,0x0
 4ea:	3a2b8b93          	addi	s7,s7,930 # 888 <digits>
 4ee:	a839                	j	50c <vprintf+0x6a>
        putc(fd, c);
 4f0:	85a6                	mv	a1,s1
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	ede080e7          	jalr	-290(ra) # 3d2 <putc>
 4fc:	a019                	j	502 <vprintf+0x60>
    } else if(state == '%'){
 4fe:	01498f63          	beq	s3,s4,51c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 502:	0905                	addi	s2,s2,1
 504:	fff94483          	lbu	s1,-1(s2)
 508:	14048b63          	beqz	s1,65e <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 50c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 510:	fe0997e3          	bnez	s3,4fe <vprintf+0x5c>
      if(c == '%'){
 514:	fd479ee3          	bne	a5,s4,4f0 <vprintf+0x4e>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7e5                	j	502 <vprintf+0x60>
      if(c == 'd'){
 51c:	05878063          	beq	a5,s8,55c <vprintf+0xba>
      } else if(c == 'l') {
 520:	05978c63          	beq	a5,s9,578 <vprintf+0xd6>
      } else if(c == 'x') {
 524:	07a78863          	beq	a5,s10,594 <vprintf+0xf2>
      } else if(c == 'p') {
 528:	09b78463          	beq	a5,s11,5b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 52c:	07300713          	li	a4,115
 530:	0ce78563          	beq	a5,a4,5fa <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 534:	06300713          	li	a4,99
 538:	0ee78c63          	beq	a5,a4,630 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 53c:	11478663          	beq	a5,s4,648 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 540:	85d2                	mv	a1,s4
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e8e080e7          	jalr	-370(ra) # 3d2 <putc>
        putc(fd, c);
 54c:	85a6                	mv	a1,s1
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e82080e7          	jalr	-382(ra) # 3d2 <putc>
      }
      state = 0;
 558:	4981                	li	s3,0
 55a:	b765                	j	502 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 55c:	008b0493          	addi	s1,s6,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000b2583          	lw	a1,0(s6)
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	e8a080e7          	jalr	-374(ra) # 3f4 <printint>
 572:	8b26                	mv	s6,s1
      state = 0;
 574:	4981                	li	s3,0
 576:	b771                	j	502 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	008b0493          	addi	s1,s6,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000b2583          	lw	a1,0(s6)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e6e080e7          	jalr	-402(ra) # 3f4 <printint>
 58e:	8b26                	mv	s6,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	bf85                	j	502 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 594:	008b0493          	addi	s1,s6,8
 598:	4681                	li	a3,0
 59a:	4641                	li	a2,16
 59c:	000b2583          	lw	a1,0(s6)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e52080e7          	jalr	-430(ra) # 3f4 <printint>
 5aa:	8b26                	mv	s6,s1
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bf91                	j	502 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5b0:	008b0793          	addi	a5,s6,8
 5b4:	f8f43423          	sd	a5,-120(s0)
 5b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5bc:	03000593          	li	a1,48
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e10080e7          	jalr	-496(ra) # 3d2 <putc>
  putc(fd, 'x');
 5ca:	85ea                	mv	a1,s10
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e04080e7          	jalr	-508(ra) # 3d2 <putc>
 5d6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d8:	03c9d793          	srli	a5,s3,0x3c
 5dc:	97de                	add	a5,a5,s7
 5de:	0007c583          	lbu	a1,0(a5)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	dee080e7          	jalr	-530(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ec:	0992                	slli	s3,s3,0x4
 5ee:	34fd                	addiw	s1,s1,-1
 5f0:	f4e5                	bnez	s1,5d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5f2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b729                	j	502 <vprintf+0x60>
        s = va_arg(ap, char*);
 5fa:	008b0993          	addi	s3,s6,8
 5fe:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 602:	c085                	beqz	s1,622 <vprintf+0x180>
        while(*s != 0){
 604:	0004c583          	lbu	a1,0(s1)
 608:	c9a1                	beqz	a1,658 <vprintf+0x1b6>
          putc(fd, *s);
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dc6080e7          	jalr	-570(ra) # 3d2 <putc>
          s++;
 614:	0485                	addi	s1,s1,1
        while(*s != 0){
 616:	0004c583          	lbu	a1,0(s1)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x168>
        s = va_arg(ap, char*);
 61c:	8b4e                	mv	s6,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	b5cd                	j	502 <vprintf+0x60>
          s = "(null)";
 622:	00000497          	auipc	s1,0x0
 626:	27e48493          	addi	s1,s1,638 # 8a0 <digits+0x18>
        while(*s != 0){
 62a:	02800593          	li	a1,40
 62e:	bff1                	j	60a <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 630:	008b0493          	addi	s1,s6,8
 634:	000b4583          	lbu	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	d98080e7          	jalr	-616(ra) # 3d2 <putc>
 642:	8b26                	mv	s6,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	bd75                	j	502 <vprintf+0x60>
        putc(fd, c);
 648:	85d2                	mv	a1,s4
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d86080e7          	jalr	-634(ra) # 3d2 <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	b575                	j	502 <vprintf+0x60>
        s = va_arg(ap, char*);
 658:	8b4e                	mv	s6,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b55d                	j	502 <vprintf+0x60>
    }
  }
}
 65e:	70e6                	ld	ra,120(sp)
 660:	7446                	ld	s0,112(sp)
 662:	74a6                	ld	s1,104(sp)
 664:	7906                	ld	s2,96(sp)
 666:	69e6                	ld	s3,88(sp)
 668:	6a46                	ld	s4,80(sp)
 66a:	6aa6                	ld	s5,72(sp)
 66c:	6b06                	ld	s6,64(sp)
 66e:	7be2                	ld	s7,56(sp)
 670:	7c42                	ld	s8,48(sp)
 672:	7ca2                	ld	s9,40(sp)
 674:	7d02                	ld	s10,32(sp)
 676:	6de2                	ld	s11,24(sp)
 678:	6109                	addi	sp,sp,128
 67a:	8082                	ret

000000000000067c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67c:	715d                	addi	sp,sp,-80
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	addi	s0,sp,32
 684:	e010                	sd	a2,0(s0)
 686:	e414                	sd	a3,8(s0)
 688:	e818                	sd	a4,16(s0)
 68a:	ec1c                	sd	a5,24(s0)
 68c:	03043023          	sd	a6,32(s0)
 690:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 694:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 698:	8622                	mv	a2,s0
 69a:	00000097          	auipc	ra,0x0
 69e:	e08080e7          	jalr	-504(ra) # 4a2 <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <printf>:

void
printf(const char *fmt, ...)
{
 6aa:	711d                	addi	sp,sp,-96
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e40c                	sd	a1,8(s0)
 6b4:	e810                	sd	a2,16(s0)
 6b6:	ec14                	sd	a3,24(s0)
 6b8:	f018                	sd	a4,32(s0)
 6ba:	f41c                	sd	a5,40(s0)
 6bc:	03043823          	sd	a6,48(s0)
 6c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	00840613          	addi	a2,s0,8
 6c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6cc:	85aa                	mv	a1,a0
 6ce:	4505                	li	a0,1
 6d0:	00000097          	auipc	ra,0x0
 6d4:	dd2080e7          	jalr	-558(ra) # 4a2 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e422                	sd	s0,8(sp)
 6e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	00001797          	auipc	a5,0x1
 6ee:	91678793          	addi	a5,a5,-1770 # 1000 <freep>
 6f2:	639c                	ld	a5,0(a5)
 6f4:	a805                	j	724 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f6:	4618                	lw	a4,8(a2)
 6f8:	9db9                	addw	a1,a1,a4
 6fa:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	6398                	ld	a4,0(a5)
 700:	6318                	ld	a4,0(a4)
 702:	fee53823          	sd	a4,-16(a0)
 706:	a091                	j	74a <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 708:	ff852703          	lw	a4,-8(a0)
 70c:	9e39                	addw	a2,a2,a4
 70e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 710:	ff053703          	ld	a4,-16(a0)
 714:	e398                	sd	a4,0(a5)
 716:	a099                	j	75c <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	6398                	ld	a4,0(a5)
 71a:	00e7e463          	bltu	a5,a4,722 <free+0x42>
 71e:	00e6ea63          	bltu	a3,a4,732 <free+0x52>
{
 722:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	fed7fae3          	bleu	a3,a5,718 <free+0x38>
 728:	6398                	ld	a4,0(a5)
 72a:	00e6e463          	bltu	a3,a4,732 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	fee7eae3          	bltu	a5,a4,722 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 732:	ff852583          	lw	a1,-8(a0)
 736:	6390                	ld	a2,0(a5)
 738:	02059713          	slli	a4,a1,0x20
 73c:	9301                	srli	a4,a4,0x20
 73e:	0712                	slli	a4,a4,0x4
 740:	9736                	add	a4,a4,a3
 742:	fae60ae3          	beq	a2,a4,6f6 <free+0x16>
    bp->s.ptr = p->s.ptr;
 746:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74a:	4790                	lw	a2,8(a5)
 74c:	02061713          	slli	a4,a2,0x20
 750:	9301                	srli	a4,a4,0x20
 752:	0712                	slli	a4,a4,0x4
 754:	973e                	add	a4,a4,a5
 756:	fae689e3          	beq	a3,a4,708 <free+0x28>
  } else
    p->s.ptr = bp;
 75a:	e394                	sd	a3,0(a5)
  freep = p;
 75c:	00001717          	auipc	a4,0x1
 760:	8af73223          	sd	a5,-1884(a4) # 1000 <freep>
}
 764:	6422                	ld	s0,8(sp)
 766:	0141                	addi	sp,sp,16
 768:	8082                	ret

000000000000076a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76a:	7139                	addi	sp,sp,-64
 76c:	fc06                	sd	ra,56(sp)
 76e:	f822                	sd	s0,48(sp)
 770:	f426                	sd	s1,40(sp)
 772:	f04a                	sd	s2,32(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	e852                	sd	s4,16(sp)
 778:	e456                	sd	s5,8(sp)
 77a:	e05a                	sd	s6,0(sp)
 77c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	02051993          	slli	s3,a0,0x20
 782:	0209d993          	srli	s3,s3,0x20
 786:	09bd                	addi	s3,s3,15
 788:	0049d993          	srli	s3,s3,0x4
 78c:	2985                	addiw	s3,s3,1
 78e:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 792:	00001797          	auipc	a5,0x1
 796:	86e78793          	addi	a5,a5,-1938 # 1000 <freep>
 79a:	6388                	ld	a0,0(a5)
 79c:	c515                	beqz	a0,7c8 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a0:	4798                	lw	a4,8(a5)
 7a2:	03277f63          	bleu	s2,a4,7e0 <malloc+0x76>
 7a6:	8a4e                	mv	s4,s3
 7a8:	0009871b          	sext.w	a4,s3
 7ac:	6685                	lui	a3,0x1
 7ae:	00d77363          	bleu	a3,a4,7b4 <malloc+0x4a>
 7b2:	6a05                	lui	s4,0x1
 7b4:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 7b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7bc:	00001497          	auipc	s1,0x1
 7c0:	84448493          	addi	s1,s1,-1980 # 1000 <freep>
  if(p == (char*)-1)
 7c4:	5b7d                	li	s6,-1
 7c6:	a885                	j	836 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7c8:	00001797          	auipc	a5,0x1
 7cc:	84878793          	addi	a5,a5,-1976 # 1010 <base>
 7d0:	00001717          	auipc	a4,0x1
 7d4:	82f73823          	sd	a5,-2000(a4) # 1000 <freep>
 7d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7de:	b7e1                	j	7a6 <malloc+0x3c>
      if(p->s.size == nunits)
 7e0:	02e90b63          	beq	s2,a4,816 <malloc+0xac>
        p->s.size -= nunits;
 7e4:	4137073b          	subw	a4,a4,s3
 7e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ea:	1702                	slli	a4,a4,0x20
 7ec:	9301                	srli	a4,a4,0x20
 7ee:	0712                	slli	a4,a4,0x4
 7f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80a73523          	sd	a0,-2038(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fe:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 802:	70e2                	ld	ra,56(sp)
 804:	7442                	ld	s0,48(sp)
 806:	74a2                	ld	s1,40(sp)
 808:	7902                	ld	s2,32(sp)
 80a:	69e2                	ld	s3,24(sp)
 80c:	6a42                	ld	s4,16(sp)
 80e:	6aa2                	ld	s5,8(sp)
 810:	6b02                	ld	s6,0(sp)
 812:	6121                	addi	sp,sp,64
 814:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	e118                	sd	a4,0(a0)
 81a:	bff1                	j	7f6 <malloc+0x8c>
  hp->s.size = nu;
 81c:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 820:	0541                	addi	a0,a0,16
 822:	00000097          	auipc	ra,0x0
 826:	ebe080e7          	jalr	-322(ra) # 6e0 <free>
  return freep;
 82a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82c:	d979                	beqz	a0,802 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 830:	4798                	lw	a4,8(a5)
 832:	fb2777e3          	bleu	s2,a4,7e0 <malloc+0x76>
    if(p == freep)
 836:	6098                	ld	a4,0(s1)
 838:	853e                	mv	a0,a5
 83a:	fef71ae3          	bne	a4,a5,82e <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 83e:	8552                	mv	a0,s4
 840:	00000097          	auipc	ra,0x0
 844:	b6a080e7          	jalr	-1174(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 848:	fd651ae3          	bne	a0,s6,81c <malloc+0xb2>
        return 0;
 84c:	4501                	li	a0,0
 84e:	bf55                	j	802 <malloc+0x98>
