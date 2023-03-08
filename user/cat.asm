
user/_cat：     文件格式 elf64-littleriscv


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
  24:	3bc080e7          	jalr	956(ra) # 3dc <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	3b0080e7          	jalr	944(ra) # 3e4 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	8c058593          	addi	a1,a1,-1856 # 900 <malloc+0xf4>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6d4080e7          	jalr	1748(ra) # 71e <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	370080e7          	jalr	880(ra) # 3c4 <exit>
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
  72:	8aa58593          	addi	a1,a1,-1878 # 918 <malloc+0x10c>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	6a6080e7          	jalr	1702(ra) # 71e <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	342080e7          	jalr	834(ra) # 3c4 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d663          	ble	a0,a5,e8 <main+0x5e>
  a0:	00858493          	addi	s1,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  b4:	4581                	li	a1,0
  b6:	6088                	ld	a0,0(s1)
  b8:	00000097          	auipc	ra,0x0
  bc:	34c080e7          	jalr	844(ra) # 404 <open>
  c0:	892a                	mv	s2,a0
  c2:	02054d63          	bltz	a0,fc <main+0x72>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	854a                	mv	a0,s2
  d0:	00000097          	auipc	ra,0x0
  d4:	31c080e7          	jalr	796(ra) # 3ec <close>
  for(i = 1; i < argc; i++){
  d8:	04a1                	addi	s1,s1,8
  da:	fd349de3          	bne	s1,s3,b4 <main+0x2a>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2e4080e7          	jalr	740(ra) # 3c4 <exit>
    cat(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	f16080e7          	jalr	-234(ra) # 0 <cat>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2d0080e7          	jalr	720(ra) # 3c4 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fc:	6090                	ld	a2,0(s1)
  fe:	00001597          	auipc	a1,0x1
 102:	83258593          	addi	a1,a1,-1998 # 930 <malloc+0x124>
 106:	4509                	li	a0,2
 108:	00000097          	auipc	ra,0x0
 10c:	616080e7          	jalr	1558(ra) # 71e <fprintf>
      exit(1);
 110:	4505                	li	a0,1
 112:	00000097          	auipc	ra,0x0
 116:	2b2080e7          	jalr	690(ra) # 3c4 <exit>

000000000000011a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  extern int main();
  main();
 122:	00000097          	auipc	ra,0x0
 126:	f68080e7          	jalr	-152(ra) # 8a <main>
  exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	298080e7          	jalr	664(ra) # 3c4 <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf91                	beqz	a5,176 <strcmp+0x26>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71b63          	bne	a4,a5,176 <strcmp+0x26>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	c789                	beqz	a5,176 <strcmp+0x26>
 16e:	0005c703          	lbu	a4,0(a1)
 172:	fef709e3          	beq	a4,a5,164 <strcmp+0x14>
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
 194:	4685                	li	a3,1
 196:	9e89                	subw	a3,a3,a0
 198:	00f6853b          	addw	a0,a3,a5
 19c:	0785                	addi	a5,a5,1
 19e:	fff7c703          	lbu	a4,-1(a5)
 1a2:	fb7d                	bnez	a4,198 <strlen+0x14>
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
 1b4:	ce09                	beqz	a2,1ce <memset+0x20>
 1b6:	87aa                	mv	a5,a0
 1b8:	fff6071b          	addiw	a4,a2,-1
 1bc:	1702                	slli	a4,a4,0x20
 1be:	9301                	srli	a4,a4,0x20
 1c0:	0705                	addi	a4,a4,1
 1c2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c8:	0785                	addi	a5,a5,1
 1ca:	fee79de3          	bne	a5,a4,1c4 <memset+0x16>
  }
  return dst;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf91                	beqz	a5,1fa <strchr+0x26>
    if(*s == c)
 1e0:	00f58a63          	beq	a1,a5,1f4 <strchr+0x20>
  for(; *s; s++)
 1e4:	0505                	addi	a0,a0,1
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	c781                	beqz	a5,1f2 <strchr+0x1e>
    if(*s == c)
 1ec:	feb79ce3          	bne	a5,a1,1e4 <strchr+0x10>
 1f0:	a011                	j	1f4 <strchr+0x20>
      return (char*)s;
  return 0;
 1f2:	4501                	li	a0,0
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  return 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strchr+0x20>

00000000000001fe <gets>:

char*
gets(char *buf, int max)
{
 1fe:	711d                	addi	sp,sp,-96
 200:	ec86                	sd	ra,88(sp)
 202:	e8a2                	sd	s0,80(sp)
 204:	e4a6                	sd	s1,72(sp)
 206:	e0ca                	sd	s2,64(sp)
 208:	fc4e                	sd	s3,56(sp)
 20a:	f852                	sd	s4,48(sp)
 20c:	f456                	sd	s5,40(sp)
 20e:	f05a                	sd	s6,32(sp)
 210:	ec5e                	sd	s7,24(sp)
 212:	1080                	addi	s0,sp,96
 214:	8baa                	mv	s7,a0
 216:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 218:	892a                	mv	s2,a0
 21a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21c:	4aa9                	li	s5,10
 21e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 220:	0019849b          	addiw	s1,s3,1
 224:	0344d863          	ble	s4,s1,254 <gets+0x56>
    cc = read(0, &c, 1);
 228:	4605                	li	a2,1
 22a:	faf40593          	addi	a1,s0,-81
 22e:	4501                	li	a0,0
 230:	00000097          	auipc	ra,0x0
 234:	1ac080e7          	jalr	428(ra) # 3dc <read>
    if(cc < 1)
 238:	00a05e63          	blez	a0,254 <gets+0x56>
    buf[i++] = c;
 23c:	faf44783          	lbu	a5,-81(s0)
 240:	00f90023          	sb	a5,0(s2) # 1010 <buf>
    if(c == '\n' || c == '\r')
 244:	01578763          	beq	a5,s5,252 <gets+0x54>
 248:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 24a:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 24c:	fd679ae3          	bne	a5,s6,220 <gets+0x22>
 250:	a011                	j	254 <gets+0x56>
  for(i=0; i+1 < max; ){
 252:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 254:	99de                	add	s3,s3,s7
 256:	00098023          	sb	zero,0(s3)
  return buf;
}
 25a:	855e                	mv	a0,s7
 25c:	60e6                	ld	ra,88(sp)
 25e:	6446                	ld	s0,80(sp)
 260:	64a6                	ld	s1,72(sp)
 262:	6906                	ld	s2,64(sp)
 264:	79e2                	ld	s3,56(sp)
 266:	7a42                	ld	s4,48(sp)
 268:	7aa2                	ld	s5,40(sp)
 26a:	7b02                	ld	s6,32(sp)
 26c:	6be2                	ld	s7,24(sp)
 26e:	6125                	addi	sp,sp,96
 270:	8082                	ret

0000000000000272 <stat>:

int
stat(const char *n, struct stat *st)
{
 272:	1101                	addi	sp,sp,-32
 274:	ec06                	sd	ra,24(sp)
 276:	e822                	sd	s0,16(sp)
 278:	e426                	sd	s1,8(sp)
 27a:	e04a                	sd	s2,0(sp)
 27c:	1000                	addi	s0,sp,32
 27e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 280:	4581                	li	a1,0
 282:	00000097          	auipc	ra,0x0
 286:	182080e7          	jalr	386(ra) # 404 <open>
  if(fd < 0)
 28a:	02054563          	bltz	a0,2b4 <stat+0x42>
 28e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 290:	85ca                	mv	a1,s2
 292:	00000097          	auipc	ra,0x0
 296:	18a080e7          	jalr	394(ra) # 41c <fstat>
 29a:	892a                	mv	s2,a0
  close(fd);
 29c:	8526                	mv	a0,s1
 29e:	00000097          	auipc	ra,0x0
 2a2:	14e080e7          	jalr	334(ra) # 3ec <close>
  return r;
}
 2a6:	854a                	mv	a0,s2
 2a8:	60e2                	ld	ra,24(sp)
 2aa:	6442                	ld	s0,16(sp)
 2ac:	64a2                	ld	s1,8(sp)
 2ae:	6902                	ld	s2,0(sp)
 2b0:	6105                	addi	sp,sp,32
 2b2:	8082                	ret
    return -1;
 2b4:	597d                	li	s2,-1
 2b6:	bfc5                	j	2a6 <stat+0x34>

00000000000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2be:	00054683          	lbu	a3,0(a0)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	andi	a5,a5,255
 2ca:	4725                	li	a4,9
 2cc:	02f76963          	bltu	a4,a5,2fe <atoi+0x46>
 2d0:	862a                	mv	a2,a0
  n = 0;
 2d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2d6:	0605                	addi	a2,a2,1
 2d8:	0025179b          	slliw	a5,a0,0x2
 2dc:	9fa9                	addw	a5,a5,a0
 2de:	0017979b          	slliw	a5,a5,0x1
 2e2:	9fb5                	addw	a5,a5,a3
 2e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e8:	00064683          	lbu	a3,0(a2)
 2ec:	fd06871b          	addiw	a4,a3,-48
 2f0:	0ff77713          	andi	a4,a4,255
 2f4:	fee5f1e3          	bleu	a4,a1,2d6 <atoi+0x1e>
  return n;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  n = 0;
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <atoi+0x40>

0000000000000302 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 308:	02b57663          	bleu	a1,a0,334 <memmove+0x32>
    while(n-- > 0)
 30c:	02c05163          	blez	a2,32e <memmove+0x2c>
 310:	fff6079b          	addiw	a5,a2,-1
 314:	1782                	slli	a5,a5,0x20
 316:	9381                	srli	a5,a5,0x20
 318:	0785                	addi	a5,a5,1
 31a:	97aa                	add	a5,a5,a0
  dst = vdst;
 31c:	872a                	mv	a4,a0
      *dst++ = *src++;
 31e:	0585                	addi	a1,a1,1
 320:	0705                	addi	a4,a4,1
 322:	fff5c683          	lbu	a3,-1(a1)
 326:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32a:	fee79ae3          	bne	a5,a4,31e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
    dst += n;
 334:	00c50733          	add	a4,a0,a2
    src += n;
 338:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33a:	fec05ae3          	blez	a2,32e <memmove+0x2c>
 33e:	fff6079b          	addiw	a5,a2,-1
 342:	1782                	slli	a5,a5,0x20
 344:	9381                	srli	a5,a5,0x20
 346:	fff7c793          	not	a5,a5
 34a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34c:	15fd                	addi	a1,a1,-1
 34e:	177d                	addi	a4,a4,-1
 350:	0005c683          	lbu	a3,0(a1)
 354:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 358:	fef71ae3          	bne	a4,a5,34c <memmove+0x4a>
 35c:	bfc9                	j	32e <memmove+0x2c>

000000000000035e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 364:	ce15                	beqz	a2,3a0 <memcmp+0x42>
 366:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	02e79063          	bne	a5,a4,392 <memcmp+0x34>
 376:	1682                	slli	a3,a3,0x20
 378:	9281                	srli	a3,a3,0x20
 37a:	0685                	addi	a3,a3,1
 37c:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 37e:	0505                	addi	a0,a0,1
    p2++;
 380:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 382:	00d50d63          	beq	a0,a3,39c <memcmp+0x3e>
    if (*p1 != *p2) {
 386:	00054783          	lbu	a5,0(a0)
 38a:	0005c703          	lbu	a4,0(a1)
 38e:	fee788e3          	beq	a5,a4,37e <memcmp+0x20>
      return *p1 - *p2;
 392:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
  return 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <memcmp+0x38>
 3a0:	4501                	li	a0,0
 3a2:	bfd5                	j	396 <memcmp+0x38>

00000000000003a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ac:	00000097          	auipc	ra,0x0
 3b0:	f56080e7          	jalr	-170(ra) # 302 <memmove>
}
 3b4:	60a2                	ld	ra,8(sp)
 3b6:	6402                	ld	s0,0(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3bc:	4885                	li	a7,1
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c4:	4889                	li	a7,2
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3cc:	488d                	li	a7,3
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d4:	4891                	li	a7,4
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <read>:
.global read
read:
 li a7, SYS_read
 3dc:	4895                	li	a7,5
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <write>:
.global write
write:
 li a7, SYS_write
 3e4:	48c1                	li	a7,16
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <close>:
.global close
close:
 li a7, SYS_close
 3ec:	48d5                	li	a7,21
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f4:	4899                	li	a7,6
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fc:	489d                	li	a7,7
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <open>:
.global open
open:
 li a7, SYS_open
 404:	48bd                	li	a7,15
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40c:	48c5                	li	a7,17
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 414:	48c9                	li	a7,18
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41c:	48a1                	li	a7,8
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <link>:
.global link
link:
 li a7, SYS_link
 424:	48cd                	li	a7,19
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42c:	48d1                	li	a7,20
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 434:	48a5                	li	a7,9
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <dup>:
.global dup
dup:
 li a7, SYS_dup
 43c:	48a9                	li	a7,10
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 444:	48ad                	li	a7,11
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44c:	48b1                	li	a7,12
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 454:	48b5                	li	a7,13
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45c:	48b9                	li	a7,14
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <trace>:
.global trace
trace:
 li a7, SYS_trace
 464:	48d9                	li	a7,22
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 46c:	48dd                	li	a7,23
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 474:	1101                	addi	sp,sp,-32
 476:	ec06                	sd	ra,24(sp)
 478:	e822                	sd	s0,16(sp)
 47a:	1000                	addi	s0,sp,32
 47c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 480:	4605                	li	a2,1
 482:	fef40593          	addi	a1,s0,-17
 486:	00000097          	auipc	ra,0x0
 48a:	f5e080e7          	jalr	-162(ra) # 3e4 <write>
}
 48e:	60e2                	ld	ra,24(sp)
 490:	6442                	ld	s0,16(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret

0000000000000496 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 496:	7139                	addi	sp,sp,-64
 498:	fc06                	sd	ra,56(sp)
 49a:	f822                	sd	s0,48(sp)
 49c:	f426                	sd	s1,40(sp)
 49e:	f04a                	sd	s2,32(sp)
 4a0:	ec4e                	sd	s3,24(sp)
 4a2:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x14>
 4a6:	0005cd63          	bltz	a1,4c0 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4301                	li	t1,0
 4ae:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 4b2:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00000897          	auipc	a7,0x0
 4ba:	49288893          	addi	a7,a7,1170 # 948 <digits>
 4be:	a801                	j	4ce <printint+0x38>
    x = -xx;
 4c0:	40b005bb          	negw	a1,a1
 4c4:	2581                	sext.w	a1,a1
    neg = 1;
 4c6:	4305                	li	t1,1
    x = -xx;
 4c8:	b7dd                	j	4ae <printint+0x18>
  }while((x /= base) != 0);
 4ca:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 4cc:	8836                	mv	a6,a3
 4ce:	0018069b          	addiw	a3,a6,1
 4d2:	02c5f7bb          	remuw	a5,a1,a2
 4d6:	1782                	slli	a5,a5,0x20
 4d8:	9381                	srli	a5,a5,0x20
 4da:	97c6                	add	a5,a5,a7
 4dc:	0007c783          	lbu	a5,0(a5)
 4e0:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 4e4:	0705                	addi	a4,a4,1
 4e6:	02c5d7bb          	divuw	a5,a1,a2
 4ea:	fec5f0e3          	bleu	a2,a1,4ca <printint+0x34>
  if(neg)
 4ee:	00030b63          	beqz	t1,504 <printint+0x6e>
    buf[i++] = '-';
 4f2:	fd040793          	addi	a5,s0,-48
 4f6:	96be                	add	a3,a3,a5
 4f8:	02d00793          	li	a5,45
 4fc:	fef68823          	sb	a5,-16(a3)
 500:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 504:	02d05963          	blez	a3,536 <printint+0xa0>
 508:	89aa                	mv	s3,a0
 50a:	fc040793          	addi	a5,s0,-64
 50e:	00d784b3          	add	s1,a5,a3
 512:	fff78913          	addi	s2,a5,-1
 516:	9936                	add	s2,s2,a3
 518:	36fd                	addiw	a3,a3,-1
 51a:	1682                	slli	a3,a3,0x20
 51c:	9281                	srli	a3,a3,0x20
 51e:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 522:	fff4c583          	lbu	a1,-1(s1)
 526:	854e                	mv	a0,s3
 528:	00000097          	auipc	ra,0x0
 52c:	f4c080e7          	jalr	-180(ra) # 474 <putc>
  while(--i >= 0)
 530:	14fd                	addi	s1,s1,-1
 532:	ff2498e3          	bne	s1,s2,522 <printint+0x8c>
}
 536:	70e2                	ld	ra,56(sp)
 538:	7442                	ld	s0,48(sp)
 53a:	74a2                	ld	s1,40(sp)
 53c:	7902                	ld	s2,32(sp)
 53e:	69e2                	ld	s3,24(sp)
 540:	6121                	addi	sp,sp,64
 542:	8082                	ret

0000000000000544 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 544:	7119                	addi	sp,sp,-128
 546:	fc86                	sd	ra,120(sp)
 548:	f8a2                	sd	s0,112(sp)
 54a:	f4a6                	sd	s1,104(sp)
 54c:	f0ca                	sd	s2,96(sp)
 54e:	ecce                	sd	s3,88(sp)
 550:	e8d2                	sd	s4,80(sp)
 552:	e4d6                	sd	s5,72(sp)
 554:	e0da                	sd	s6,64(sp)
 556:	fc5e                	sd	s7,56(sp)
 558:	f862                	sd	s8,48(sp)
 55a:	f466                	sd	s9,40(sp)
 55c:	f06a                	sd	s10,32(sp)
 55e:	ec6e                	sd	s11,24(sp)
 560:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 562:	0005c483          	lbu	s1,0(a1)
 566:	18048d63          	beqz	s1,700 <vprintf+0x1bc>
 56a:	8aaa                	mv	s5,a0
 56c:	8b32                	mv	s6,a2
 56e:	00158913          	addi	s2,a1,1
  state = 0;
 572:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 574:	02500a13          	li	s4,37
      if(c == 'd'){
 578:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 57c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 580:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 584:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 588:	00000b97          	auipc	s7,0x0
 58c:	3c0b8b93          	addi	s7,s7,960 # 948 <digits>
 590:	a839                	j	5ae <vprintf+0x6a>
        putc(fd, c);
 592:	85a6                	mv	a1,s1
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	ede080e7          	jalr	-290(ra) # 474 <putc>
 59e:	a019                	j	5a4 <vprintf+0x60>
    } else if(state == '%'){
 5a0:	01498f63          	beq	s3,s4,5be <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5a4:	0905                	addi	s2,s2,1
 5a6:	fff94483          	lbu	s1,-1(s2)
 5aa:	14048b63          	beqz	s1,700 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 5ae:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5b2:	fe0997e3          	bnez	s3,5a0 <vprintf+0x5c>
      if(c == '%'){
 5b6:	fd479ee3          	bne	a5,s4,592 <vprintf+0x4e>
        state = '%';
 5ba:	89be                	mv	s3,a5
 5bc:	b7e5                	j	5a4 <vprintf+0x60>
      if(c == 'd'){
 5be:	05878063          	beq	a5,s8,5fe <vprintf+0xba>
      } else if(c == 'l') {
 5c2:	05978c63          	beq	a5,s9,61a <vprintf+0xd6>
      } else if(c == 'x') {
 5c6:	07a78863          	beq	a5,s10,636 <vprintf+0xf2>
      } else if(c == 'p') {
 5ca:	09b78463          	beq	a5,s11,652 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5ce:	07300713          	li	a4,115
 5d2:	0ce78563          	beq	a5,a4,69c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d6:	06300713          	li	a4,99
 5da:	0ee78c63          	beq	a5,a4,6d2 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5de:	11478663          	beq	a5,s4,6ea <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e2:	85d2                	mv	a1,s4
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e8e080e7          	jalr	-370(ra) # 474 <putc>
        putc(fd, c);
 5ee:	85a6                	mv	a1,s1
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e82080e7          	jalr	-382(ra) # 474 <putc>
      }
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b765                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5fe:	008b0493          	addi	s1,s6,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000b2583          	lw	a1,0(s6)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e8a080e7          	jalr	-374(ra) # 496 <printint>
 614:	8b26                	mv	s6,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	b771                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b0493          	addi	s1,s6,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000b2583          	lw	a1,0(s6)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e6e080e7          	jalr	-402(ra) # 496 <printint>
 630:	8b26                	mv	s6,s1
      state = 0;
 632:	4981                	li	s3,0
 634:	bf85                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 636:	008b0493          	addi	s1,s6,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000b2583          	lw	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e52080e7          	jalr	-430(ra) # 496 <printint>
 64c:	8b26                	mv	s6,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	bf91                	j	5a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 652:	008b0793          	addi	a5,s6,8
 656:	f8f43423          	sd	a5,-120(s0)
 65a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 65e:	03000593          	li	a1,48
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e10080e7          	jalr	-496(ra) # 474 <putc>
  putc(fd, 'x');
 66c:	85ea                	mv	a1,s10
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e04080e7          	jalr	-508(ra) # 474 <putc>
 678:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	dee080e7          	jalr	-530(ra) # 474 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68e:	0992                	slli	s3,s3,0x4
 690:	34fd                	addiw	s1,s1,-1
 692:	f4e5                	bnez	s1,67a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 694:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 698:	4981                	li	s3,0
 69a:	b729                	j	5a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 69c:	008b0993          	addi	s3,s6,8
 6a0:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 6a4:	c085                	beqz	s1,6c4 <vprintf+0x180>
        while(*s != 0){
 6a6:	0004c583          	lbu	a1,0(s1)
 6aa:	c9a1                	beqz	a1,6fa <vprintf+0x1b6>
          putc(fd, *s);
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dc6080e7          	jalr	-570(ra) # 474 <putc>
          s++;
 6b6:	0485                	addi	s1,s1,1
        while(*s != 0){
 6b8:	0004c583          	lbu	a1,0(s1)
 6bc:	f9e5                	bnez	a1,6ac <vprintf+0x168>
        s = va_arg(ap, char*);
 6be:	8b4e                	mv	s6,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b5cd                	j	5a4 <vprintf+0x60>
          s = "(null)";
 6c4:	00000497          	auipc	s1,0x0
 6c8:	29c48493          	addi	s1,s1,668 # 960 <digits+0x18>
        while(*s != 0){
 6cc:	02800593          	li	a1,40
 6d0:	bff1                	j	6ac <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 6d2:	008b0493          	addi	s1,s6,8
 6d6:	000b4583          	lbu	a1,0(s6)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	d98080e7          	jalr	-616(ra) # 474 <putc>
 6e4:	8b26                	mv	s6,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd75                	j	5a4 <vprintf+0x60>
        putc(fd, c);
 6ea:	85d2                	mv	a1,s4
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d86080e7          	jalr	-634(ra) # 474 <putc>
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b575                	j	5a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fa:	8b4e                	mv	s6,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b55d                	j	5a4 <vprintf+0x60>
    }
  }
}
 700:	70e6                	ld	ra,120(sp)
 702:	7446                	ld	s0,112(sp)
 704:	74a6                	ld	s1,104(sp)
 706:	7906                	ld	s2,96(sp)
 708:	69e6                	ld	s3,88(sp)
 70a:	6a46                	ld	s4,80(sp)
 70c:	6aa6                	ld	s5,72(sp)
 70e:	6b06                	ld	s6,64(sp)
 710:	7be2                	ld	s7,56(sp)
 712:	7c42                	ld	s8,48(sp)
 714:	7ca2                	ld	s9,40(sp)
 716:	7d02                	ld	s10,32(sp)
 718:	6de2                	ld	s11,24(sp)
 71a:	6109                	addi	sp,sp,128
 71c:	8082                	ret

000000000000071e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71e:	715d                	addi	sp,sp,-80
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e010                	sd	a2,0(s0)
 728:	e414                	sd	a3,8(s0)
 72a:	e818                	sd	a4,16(s0)
 72c:	ec1c                	sd	a5,24(s0)
 72e:	03043023          	sd	a6,32(s0)
 732:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	8622                	mv	a2,s0
 73c:	00000097          	auipc	ra,0x0
 740:	e08080e7          	jalr	-504(ra) # 544 <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6161                	addi	sp,sp,80
 74a:	8082                	ret

000000000000074c <printf>:

void
printf(const char *fmt, ...)
{
 74c:	711d                	addi	sp,sp,-96
 74e:	ec06                	sd	ra,24(sp)
 750:	e822                	sd	s0,16(sp)
 752:	1000                	addi	s0,sp,32
 754:	e40c                	sd	a1,8(s0)
 756:	e810                	sd	a2,16(s0)
 758:	ec14                	sd	a3,24(s0)
 75a:	f018                	sd	a4,32(s0)
 75c:	f41c                	sd	a5,40(s0)
 75e:	03043823          	sd	a6,48(s0)
 762:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	00840613          	addi	a2,s0,8
 76a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76e:	85aa                	mv	a1,a0
 770:	4505                	li	a0,1
 772:	00000097          	auipc	ra,0x0
 776:	dd2080e7          	jalr	-558(ra) # 544 <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	87478793          	addi	a5,a5,-1932 # 1000 <freep>
 794:	639c                	ld	a5,0(a5)
 796:	a805                	j	7c6 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 798:	4618                	lw	a4,8(a2)
 79a:	9db9                	addw	a1,a1,a4
 79c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	6398                	ld	a4,0(a5)
 7a2:	6318                	ld	a4,0(a4)
 7a4:	fee53823          	sd	a4,-16(a0)
 7a8:	a091                	j	7ec <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9e39                	addw	a2,a2,a4
 7b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053703          	ld	a4,-16(a0)
 7b6:	e398                	sd	a4,0(a5)
 7b8:	a099                	j	7fe <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x42>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x52>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bleu	a3,a5,7ba <free+0x38>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059713          	slli	a4,a1,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60ae3          	beq	a2,a4,798 <free+0x16>
    bp->s.ptr = p->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061713          	slli	a4,a2,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	0712                	slli	a4,a4,0x4
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae689e3          	beq	a3,a4,7aa <free+0x28>
  } else
    p->s.ptr = bp;
 7fc:	e394                	sd	a3,0(a5)
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051993          	slli	s3,a0,0x20
 824:	0209d993          	srli	s3,s3,0x20
 828:	09bd                	addi	s3,s3,15
 82a:	0049d993          	srli	s3,s3,0x4
 82e:	2985                	addiw	s3,s3,1
 830:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 834:	00000797          	auipc	a5,0x0
 838:	7cc78793          	addi	a5,a5,1996 # 1000 <freep>
 83c:	6388                	ld	a0,0(a5)
 83e:	c515                	beqz	a0,86a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	03277f63          	bleu	s2,a4,882 <malloc+0x76>
 848:	8a4e                	mv	s4,s3
 84a:	0009871b          	sext.w	a4,s3
 84e:	6685                	lui	a3,0x1
 850:	00d77363          	bleu	a3,a4,856 <malloc+0x4a>
 854:	6a05                	lui	s4,0x1
 856:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 85a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85e:	00000497          	auipc	s1,0x0
 862:	7a248493          	addi	s1,s1,1954 # 1000 <freep>
  if(p == (char*)-1)
 866:	5b7d                	li	s6,-1
 868:	a885                	j	8d8 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 86a:	00001797          	auipc	a5,0x1
 86e:	9a678793          	addi	a5,a5,-1626 # 1210 <base>
 872:	00000717          	auipc	a4,0x0
 876:	78f73723          	sd	a5,1934(a4) # 1000 <freep>
 87a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 880:	b7e1                	j	848 <malloc+0x3c>
      if(p->s.size == nunits)
 882:	02e90b63          	beq	s2,a4,8b8 <malloc+0xac>
        p->s.size -= nunits;
 886:	4137073b          	subw	a4,a4,s3
 88a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88c:	1702                	slli	a4,a4,0x20
 88e:	9301                	srli	a4,a4,0x20
 890:	0712                	slli	a4,a4,0x4
 892:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 894:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 898:	00000717          	auipc	a4,0x0
 89c:	76a73423          	sd	a0,1896(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a4:	70e2                	ld	ra,56(sp)
 8a6:	7442                	ld	s0,48(sp)
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	7902                	ld	s2,32(sp)
 8ac:	69e2                	ld	s3,24(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
 8b4:	6121                	addi	sp,sp,64
 8b6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b8:	6398                	ld	a4,0(a5)
 8ba:	e118                	sd	a4,0(a0)
 8bc:	bff1                	j	898 <malloc+0x8c>
  hp->s.size = nu;
 8be:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 8c2:	0541                	addi	a0,a0,16
 8c4:	00000097          	auipc	ra,0x0
 8c8:	ebe080e7          	jalr	-322(ra) # 782 <free>
  return freep;
 8cc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ce:	d979                	beqz	a0,8a4 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d2:	4798                	lw	a4,8(a5)
 8d4:	fb2777e3          	bleu	s2,a4,882 <malloc+0x76>
    if(p == freep)
 8d8:	6098                	ld	a4,0(s1)
 8da:	853e                	mv	a0,a5
 8dc:	fef71ae3          	bne	a4,a5,8d0 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 8e0:	8552                	mv	a0,s4
 8e2:	00000097          	auipc	ra,0x0
 8e6:	b6a080e7          	jalr	-1174(ra) # 44c <sbrk>
  if(p == (char*)-1)
 8ea:	fd651ae3          	bne	a0,s6,8be <malloc+0xb2>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	bf55                	j	8a4 <malloc+0x98>
