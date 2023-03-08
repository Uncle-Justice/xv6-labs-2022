
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	938a0a13          	addi	s4,s4,-1736 # 970 <malloc+0xe8>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	20a080e7          	jalr	522(ra) # 250 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89de                	mv	s3,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	016d0d3b          	addw	s10,s10,s6
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3d6080e7          	jalr	982(ra) # 458 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050b1b          	sext.w	s6,a0
  9a:	fffb091b          	addiw	s2,s6,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86ea                	mv	a3,s10
  b2:	8666                	mv	a2,s9
  b4:	85e2                	mv	a1,s8
  b6:	00001517          	auipc	a0,0x1
  ba:	8d250513          	addi	a0,a0,-1838 # 988 <malloc+0x100>
  be:	00000097          	auipc	ra,0x0
  c2:	70a080e7          	jalr	1802(ra) # 7c8 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	89450513          	addi	a0,a0,-1900 # 978 <malloc+0xf0>
  ec:	00000097          	auipc	ra,0x0
  f0:	6dc080e7          	jalr	1756(ra) # 7c8 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	34a080e7          	jalr	842(ra) # 440 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	ble	a0,a5,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	354080e7          	jalr	852(ra) # 480 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	322080e7          	jalr	802(ra) # 468 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2ea080e7          	jalr	746(ra) # 440 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	83a58593          	addi	a1,a1,-1990 # 998 <malloc+0x110>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2ce080e7          	jalr	718(ra) # 440 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	82450513          	addi	a0,a0,-2012 # 9a0 <malloc+0x118>
 184:	00000097          	auipc	ra,0x0
 188:	644080e7          	jalr	1604(ra) # 7c8 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	2b2080e7          	jalr	690(ra) # 440 <exit>

0000000000000196 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f60080e7          	jalr	-160(ra) # fe <main>
  exit(0);
 1a6:	4501                	li	a0,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	298080e7          	jalr	664(ra) # 440 <exit>

00000000000001b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b6:	87aa                	mv	a5,a0
 1b8:	0585                	addi	a1,a1,1
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff5c703          	lbu	a4,-1(a1)
 1c0:	fee78fa3          	sb	a4,-1(a5)
 1c4:	fb75                	bnez	a4,1b8 <strcpy+0x8>
    ;
  return os;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cf91                	beqz	a5,1f2 <strcmp+0x26>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71b63          	bne	a4,a5,1f2 <strcmp+0x26>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	c789                	beqz	a5,1f2 <strcmp+0x26>
 1ea:	0005c703          	lbu	a4,0(a1)
 1ee:	fef709e3          	beq	a4,a5,1e0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1f2:	0005c503          	lbu	a0,0(a1)
}
 1f6:	40a7853b          	subw	a0,a5,a0
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret

0000000000000200 <strlen>:

uint
strlen(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cf91                	beqz	a5,226 <strlen+0x26>
 20c:	0505                	addi	a0,a0,1
 20e:	87aa                	mv	a5,a0
 210:	4685                	li	a3,1
 212:	9e89                	subw	a3,a3,a0
 214:	00f6853b          	addw	a0,a3,a5
 218:	0785                	addi	a5,a5,1
 21a:	fff7c703          	lbu	a4,-1(a5)
 21e:	fb7d                	bnez	a4,214 <strlen+0x14>
    ;
  return n;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  for(n = 0; s[n]; n++)
 226:	4501                	li	a0,0
 228:	bfe5                	j	220 <strlen+0x20>

000000000000022a <memset>:

void*
memset(void *dst, int c, uint n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 230:	ce09                	beqz	a2,24a <memset+0x20>
 232:	87aa                	mv	a5,a0
 234:	fff6071b          	addiw	a4,a2,-1
 238:	1702                	slli	a4,a4,0x20
 23a:	9301                	srli	a4,a4,0x20
 23c:	0705                	addi	a4,a4,1
 23e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 240:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 244:	0785                	addi	a5,a5,1
 246:	fee79de3          	bne	a5,a4,240 <memset+0x16>
  }
  return dst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret

0000000000000250 <strchr>:

char*
strchr(const char *s, char c)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  for(; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cf91                	beqz	a5,276 <strchr+0x26>
    if(*s == c)
 25c:	00f58a63          	beq	a1,a5,270 <strchr+0x20>
  for(; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	c781                	beqz	a5,26e <strchr+0x1e>
    if(*s == c)
 268:	feb79ce3          	bne	a5,a1,260 <strchr+0x10>
 26c:	a011                	j	270 <strchr+0x20>
      return (char*)s;
  return 0;
 26e:	4501                	li	a0,0
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  return 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <strchr+0x20>

000000000000027a <gets>:

char*
gets(char *buf, int max)
{
 27a:	711d                	addi	sp,sp,-96
 27c:	ec86                	sd	ra,88(sp)
 27e:	e8a2                	sd	s0,80(sp)
 280:	e4a6                	sd	s1,72(sp)
 282:	e0ca                	sd	s2,64(sp)
 284:	fc4e                	sd	s3,56(sp)
 286:	f852                	sd	s4,48(sp)
 288:	f456                	sd	s5,40(sp)
 28a:	f05a                	sd	s6,32(sp)
 28c:	ec5e                	sd	s7,24(sp)
 28e:	1080                	addi	s0,sp,96
 290:	8baa                	mv	s7,a0
 292:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 294:	892a                	mv	s2,a0
 296:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 298:	4aa9                	li	s5,10
 29a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0344d863          	ble	s4,s1,2d0 <gets+0x56>
    cc = read(0, &c, 1);
 2a4:	4605                	li	a2,1
 2a6:	faf40593          	addi	a1,s0,-81
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	1ac080e7          	jalr	428(ra) # 458 <read>
    if(cc < 1)
 2b4:	00a05e63          	blez	a0,2d0 <gets+0x56>
    buf[i++] = c;
 2b8:	faf44783          	lbu	a5,-81(s0)
 2bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c0:	01578763          	beq	a5,s5,2ce <gets+0x54>
 2c4:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 2c6:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 2c8:	fd679ae3          	bne	a5,s6,29c <gets+0x22>
 2cc:	a011                	j	2d0 <gets+0x56>
  for(i=0; i+1 < max; ){
 2ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d0:	99de                	add	s3,s3,s7
 2d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d6:	855e                	mv	a0,s7
 2d8:	60e6                	ld	ra,88(sp)
 2da:	6446                	ld	s0,80(sp)
 2dc:	64a6                	ld	s1,72(sp)
 2de:	6906                	ld	s2,64(sp)
 2e0:	79e2                	ld	s3,56(sp)
 2e2:	7a42                	ld	s4,48(sp)
 2e4:	7aa2                	ld	s5,40(sp)
 2e6:	7b02                	ld	s6,32(sp)
 2e8:	6be2                	ld	s7,24(sp)
 2ea:	6125                	addi	sp,sp,96
 2ec:	8082                	ret

00000000000002ee <stat>:

int
stat(const char *n, struct stat *st)
{
 2ee:	1101                	addi	sp,sp,-32
 2f0:	ec06                	sd	ra,24(sp)
 2f2:	e822                	sd	s0,16(sp)
 2f4:	e426                	sd	s1,8(sp)
 2f6:	e04a                	sd	s2,0(sp)
 2f8:	1000                	addi	s0,sp,32
 2fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fc:	4581                	li	a1,0
 2fe:	00000097          	auipc	ra,0x0
 302:	182080e7          	jalr	386(ra) # 480 <open>
  if(fd < 0)
 306:	02054563          	bltz	a0,330 <stat+0x42>
 30a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30c:	85ca                	mv	a1,s2
 30e:	00000097          	auipc	ra,0x0
 312:	18a080e7          	jalr	394(ra) # 498 <fstat>
 316:	892a                	mv	s2,a0
  close(fd);
 318:	8526                	mv	a0,s1
 31a:	00000097          	auipc	ra,0x0
 31e:	14e080e7          	jalr	334(ra) # 468 <close>
  return r;
}
 322:	854a                	mv	a0,s2
 324:	60e2                	ld	ra,24(sp)
 326:	6442                	ld	s0,16(sp)
 328:	64a2                	ld	s1,8(sp)
 32a:	6902                	ld	s2,0(sp)
 32c:	6105                	addi	sp,sp,32
 32e:	8082                	ret
    return -1;
 330:	597d                	li	s2,-1
 332:	bfc5                	j	322 <stat+0x34>

0000000000000334 <atoi>:

int
atoi(const char *s)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33a:	00054683          	lbu	a3,0(a0)
 33e:	fd06879b          	addiw	a5,a3,-48
 342:	0ff7f793          	andi	a5,a5,255
 346:	4725                	li	a4,9
 348:	02f76963          	bltu	a4,a5,37a <atoi+0x46>
 34c:	862a                	mv	a2,a0
  n = 0;
 34e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 350:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 352:	0605                	addi	a2,a2,1
 354:	0025179b          	slliw	a5,a0,0x2
 358:	9fa9                	addw	a5,a5,a0
 35a:	0017979b          	slliw	a5,a5,0x1
 35e:	9fb5                	addw	a5,a5,a3
 360:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 364:	00064683          	lbu	a3,0(a2)
 368:	fd06871b          	addiw	a4,a3,-48
 36c:	0ff77713          	andi	a4,a4,255
 370:	fee5f1e3          	bleu	a4,a1,352 <atoi+0x1e>
  return n;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  n = 0;
 37a:	4501                	li	a0,0
 37c:	bfe5                	j	374 <atoi+0x40>

000000000000037e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 384:	02b57663          	bleu	a1,a0,3b0 <memmove+0x32>
    while(n-- > 0)
 388:	02c05163          	blez	a2,3aa <memmove+0x2c>
 38c:	fff6079b          	addiw	a5,a2,-1
 390:	1782                	slli	a5,a5,0x20
 392:	9381                	srli	a5,a5,0x20
 394:	0785                	addi	a5,a5,1
 396:	97aa                	add	a5,a5,a0
  dst = vdst;
 398:	872a                	mv	a4,a0
      *dst++ = *src++;
 39a:	0585                	addi	a1,a1,1
 39c:	0705                	addi	a4,a4,1
 39e:	fff5c683          	lbu	a3,-1(a1)
 3a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a6:	fee79ae3          	bne	a5,a4,39a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret
    dst += n;
 3b0:	00c50733          	add	a4,a0,a2
    src += n;
 3b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b6:	fec05ae3          	blez	a2,3aa <memmove+0x2c>
 3ba:	fff6079b          	addiw	a5,a2,-1
 3be:	1782                	slli	a5,a5,0x20
 3c0:	9381                	srli	a5,a5,0x20
 3c2:	fff7c793          	not	a5,a5
 3c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c8:	15fd                	addi	a1,a1,-1
 3ca:	177d                	addi	a4,a4,-1
 3cc:	0005c683          	lbu	a3,0(a1)
 3d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d4:	fef71ae3          	bne	a4,a5,3c8 <memmove+0x4a>
 3d8:	bfc9                	j	3aa <memmove+0x2c>

00000000000003da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e0:	ce15                	beqz	a2,41c <memcmp+0x42>
 3e2:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	0005c703          	lbu	a4,0(a1)
 3ee:	02e79063          	bne	a5,a4,40e <memcmp+0x34>
 3f2:	1682                	slli	a3,a3,0x20
 3f4:	9281                	srli	a3,a3,0x20
 3f6:	0685                	addi	a3,a3,1
 3f8:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 3fa:	0505                	addi	a0,a0,1
    p2++;
 3fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3fe:	00d50d63          	beq	a0,a3,418 <memcmp+0x3e>
    if (*p1 != *p2) {
 402:	00054783          	lbu	a5,0(a0)
 406:	0005c703          	lbu	a4,0(a1)
 40a:	fee788e3          	beq	a5,a4,3fa <memcmp+0x20>
      return *p1 - *p2;
 40e:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret
  return 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <memcmp+0x38>
 41c:	4501                	li	a0,0
 41e:	bfd5                	j	412 <memcmp+0x38>

0000000000000420 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e406                	sd	ra,8(sp)
 424:	e022                	sd	s0,0(sp)
 426:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 428:	00000097          	auipc	ra,0x0
 42c:	f56080e7          	jalr	-170(ra) # 37e <memmove>
}
 430:	60a2                	ld	ra,8(sp)
 432:	6402                	ld	s0,0(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret

0000000000000438 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 438:	4885                	li	a7,1
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <exit>:
.global exit
exit:
 li a7, SYS_exit
 440:	4889                	li	a7,2
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <wait>:
.global wait
wait:
 li a7, SYS_wait
 448:	488d                	li	a7,3
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 450:	4891                	li	a7,4
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <read>:
.global read
read:
 li a7, SYS_read
 458:	4895                	li	a7,5
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <write>:
.global write
write:
 li a7, SYS_write
 460:	48c1                	li	a7,16
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <close>:
.global close
close:
 li a7, SYS_close
 468:	48d5                	li	a7,21
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <kill>:
.global kill
kill:
 li a7, SYS_kill
 470:	4899                	li	a7,6
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <exec>:
.global exec
exec:
 li a7, SYS_exec
 478:	489d                	li	a7,7
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <open>:
.global open
open:
 li a7, SYS_open
 480:	48bd                	li	a7,15
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 488:	48c5                	li	a7,17
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 490:	48c9                	li	a7,18
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 498:	48a1                	li	a7,8
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <link>:
.global link
link:
 li a7, SYS_link
 4a0:	48cd                	li	a7,19
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a8:	48d1                	li	a7,20
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b0:	48a5                	li	a7,9
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b8:	48a9                	li	a7,10
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c0:	48ad                	li	a7,11
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c8:	48b1                	li	a7,12
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d0:	48b5                	li	a7,13
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d8:	48b9                	li	a7,14
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4e0:	48d9                	li	a7,22
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4e8:	48dd                	li	a7,23
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	1000                	addi	s0,sp,32
 4f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fc:	4605                	li	a2,1
 4fe:	fef40593          	addi	a1,s0,-17
 502:	00000097          	auipc	ra,0x0
 506:	f5e080e7          	jalr	-162(ra) # 460 <write>
}
 50a:	60e2                	ld	ra,24(sp)
 50c:	6442                	ld	s0,16(sp)
 50e:	6105                	addi	sp,sp,32
 510:	8082                	ret

0000000000000512 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 512:	7139                	addi	sp,sp,-64
 514:	fc06                	sd	ra,56(sp)
 516:	f822                	sd	s0,48(sp)
 518:	f426                	sd	s1,40(sp)
 51a:	f04a                	sd	s2,32(sp)
 51c:	ec4e                	sd	s3,24(sp)
 51e:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 520:	c299                	beqz	a3,526 <printint+0x14>
 522:	0005cd63          	bltz	a1,53c <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 526:	2581                	sext.w	a1,a1
  neg = 0;
 528:	4301                	li	t1,0
 52a:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 52e:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 530:	2601                	sext.w	a2,a2
 532:	00000897          	auipc	a7,0x0
 536:	48688893          	addi	a7,a7,1158 # 9b8 <digits>
 53a:	a801                	j	54a <printint+0x38>
    x = -xx;
 53c:	40b005bb          	negw	a1,a1
 540:	2581                	sext.w	a1,a1
    neg = 1;
 542:	4305                	li	t1,1
    x = -xx;
 544:	b7dd                	j	52a <printint+0x18>
  }while((x /= base) != 0);
 546:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 548:	8836                	mv	a6,a3
 54a:	0018069b          	addiw	a3,a6,1
 54e:	02c5f7bb          	remuw	a5,a1,a2
 552:	1782                	slli	a5,a5,0x20
 554:	9381                	srli	a5,a5,0x20
 556:	97c6                	add	a5,a5,a7
 558:	0007c783          	lbu	a5,0(a5)
 55c:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 560:	0705                	addi	a4,a4,1
 562:	02c5d7bb          	divuw	a5,a1,a2
 566:	fec5f0e3          	bleu	a2,a1,546 <printint+0x34>
  if(neg)
 56a:	00030b63          	beqz	t1,580 <printint+0x6e>
    buf[i++] = '-';
 56e:	fd040793          	addi	a5,s0,-48
 572:	96be                	add	a3,a3,a5
 574:	02d00793          	li	a5,45
 578:	fef68823          	sb	a5,-16(a3)
 57c:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 580:	02d05963          	blez	a3,5b2 <printint+0xa0>
 584:	89aa                	mv	s3,a0
 586:	fc040793          	addi	a5,s0,-64
 58a:	00d784b3          	add	s1,a5,a3
 58e:	fff78913          	addi	s2,a5,-1
 592:	9936                	add	s2,s2,a3
 594:	36fd                	addiw	a3,a3,-1
 596:	1682                	slli	a3,a3,0x20
 598:	9281                	srli	a3,a3,0x20
 59a:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 59e:	fff4c583          	lbu	a1,-1(s1)
 5a2:	854e                	mv	a0,s3
 5a4:	00000097          	auipc	ra,0x0
 5a8:	f4c080e7          	jalr	-180(ra) # 4f0 <putc>
  while(--i >= 0)
 5ac:	14fd                	addi	s1,s1,-1
 5ae:	ff2498e3          	bne	s1,s2,59e <printint+0x8c>
}
 5b2:	70e2                	ld	ra,56(sp)
 5b4:	7442                	ld	s0,48(sp)
 5b6:	74a2                	ld	s1,40(sp)
 5b8:	7902                	ld	s2,32(sp)
 5ba:	69e2                	ld	s3,24(sp)
 5bc:	6121                	addi	sp,sp,64
 5be:	8082                	ret

00000000000005c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c0:	7119                	addi	sp,sp,-128
 5c2:	fc86                	sd	ra,120(sp)
 5c4:	f8a2                	sd	s0,112(sp)
 5c6:	f4a6                	sd	s1,104(sp)
 5c8:	f0ca                	sd	s2,96(sp)
 5ca:	ecce                	sd	s3,88(sp)
 5cc:	e8d2                	sd	s4,80(sp)
 5ce:	e4d6                	sd	s5,72(sp)
 5d0:	e0da                	sd	s6,64(sp)
 5d2:	fc5e                	sd	s7,56(sp)
 5d4:	f862                	sd	s8,48(sp)
 5d6:	f466                	sd	s9,40(sp)
 5d8:	f06a                	sd	s10,32(sp)
 5da:	ec6e                	sd	s11,24(sp)
 5dc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5de:	0005c483          	lbu	s1,0(a1)
 5e2:	18048d63          	beqz	s1,77c <vprintf+0x1bc>
 5e6:	8aaa                	mv	s5,a0
 5e8:	8b32                	mv	s6,a2
 5ea:	00158913          	addi	s2,a1,1
  state = 0;
 5ee:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f0:	02500a13          	li	s4,37
      if(c == 'd'){
 5f4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5f8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5fc:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 600:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	00000b97          	auipc	s7,0x0
 608:	3b4b8b93          	addi	s7,s7,948 # 9b8 <digits>
 60c:	a839                	j	62a <vprintf+0x6a>
        putc(fd, c);
 60e:	85a6                	mv	a1,s1
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	ede080e7          	jalr	-290(ra) # 4f0 <putc>
 61a:	a019                	j	620 <vprintf+0x60>
    } else if(state == '%'){
 61c:	01498f63          	beq	s3,s4,63a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 620:	0905                	addi	s2,s2,1
 622:	fff94483          	lbu	s1,-1(s2)
 626:	14048b63          	beqz	s1,77c <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 62a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 62e:	fe0997e3          	bnez	s3,61c <vprintf+0x5c>
      if(c == '%'){
 632:	fd479ee3          	bne	a5,s4,60e <vprintf+0x4e>
        state = '%';
 636:	89be                	mv	s3,a5
 638:	b7e5                	j	620 <vprintf+0x60>
      if(c == 'd'){
 63a:	05878063          	beq	a5,s8,67a <vprintf+0xba>
      } else if(c == 'l') {
 63e:	05978c63          	beq	a5,s9,696 <vprintf+0xd6>
      } else if(c == 'x') {
 642:	07a78863          	beq	a5,s10,6b2 <vprintf+0xf2>
      } else if(c == 'p') {
 646:	09b78463          	beq	a5,s11,6ce <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 64a:	07300713          	li	a4,115
 64e:	0ce78563          	beq	a5,a4,718 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 652:	06300713          	li	a4,99
 656:	0ee78c63          	beq	a5,a4,74e <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 65a:	11478663          	beq	a5,s4,766 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65e:	85d2                	mv	a1,s4
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e8e080e7          	jalr	-370(ra) # 4f0 <putc>
        putc(fd, c);
 66a:	85a6                	mv	a1,s1
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e82080e7          	jalr	-382(ra) # 4f0 <putc>
      }
      state = 0;
 676:	4981                	li	s3,0
 678:	b765                	j	620 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 67a:	008b0493          	addi	s1,s6,8
 67e:	4685                	li	a3,1
 680:	4629                	li	a2,10
 682:	000b2583          	lw	a1,0(s6)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e8a080e7          	jalr	-374(ra) # 512 <printint>
 690:	8b26                	mv	s6,s1
      state = 0;
 692:	4981                	li	s3,0
 694:	b771                	j	620 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b0493          	addi	s1,s6,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000b2583          	lw	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e6e080e7          	jalr	-402(ra) # 512 <printint>
 6ac:	8b26                	mv	s6,s1
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bf85                	j	620 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b2:	008b0493          	addi	s1,s6,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000b2583          	lw	a1,0(s6)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e52080e7          	jalr	-430(ra) # 512 <printint>
 6c8:	8b26                	mv	s6,s1
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bf91                	j	620 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ce:	008b0793          	addi	a5,s6,8
 6d2:	f8f43423          	sd	a5,-120(s0)
 6d6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6da:	03000593          	li	a1,48
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e10080e7          	jalr	-496(ra) # 4f0 <putc>
  putc(fd, 'x');
 6e8:	85ea                	mv	a1,s10
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e04080e7          	jalr	-508(ra) # 4f0 <putc>
 6f4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	03c9d793          	srli	a5,s3,0x3c
 6fa:	97de                	add	a5,a5,s7
 6fc:	0007c583          	lbu	a1,0(a5)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	dee080e7          	jalr	-530(ra) # 4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70a:	0992                	slli	s3,s3,0x4
 70c:	34fd                	addiw	s1,s1,-1
 70e:	f4e5                	bnez	s1,6f6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 710:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 714:	4981                	li	s3,0
 716:	b729                	j	620 <vprintf+0x60>
        s = va_arg(ap, char*);
 718:	008b0993          	addi	s3,s6,8
 71c:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 720:	c085                	beqz	s1,740 <vprintf+0x180>
        while(*s != 0){
 722:	0004c583          	lbu	a1,0(s1)
 726:	c9a1                	beqz	a1,776 <vprintf+0x1b6>
          putc(fd, *s);
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	dc6080e7          	jalr	-570(ra) # 4f0 <putc>
          s++;
 732:	0485                	addi	s1,s1,1
        while(*s != 0){
 734:	0004c583          	lbu	a1,0(s1)
 738:	f9e5                	bnez	a1,728 <vprintf+0x168>
        s = va_arg(ap, char*);
 73a:	8b4e                	mv	s6,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b5cd                	j	620 <vprintf+0x60>
          s = "(null)";
 740:	00000497          	auipc	s1,0x0
 744:	29048493          	addi	s1,s1,656 # 9d0 <digits+0x18>
        while(*s != 0){
 748:	02800593          	li	a1,40
 74c:	bff1                	j	728 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 74e:	008b0493          	addi	s1,s6,8
 752:	000b4583          	lbu	a1,0(s6)
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	d98080e7          	jalr	-616(ra) # 4f0 <putc>
 760:	8b26                	mv	s6,s1
      state = 0;
 762:	4981                	li	s3,0
 764:	bd75                	j	620 <vprintf+0x60>
        putc(fd, c);
 766:	85d2                	mv	a1,s4
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	d86080e7          	jalr	-634(ra) # 4f0 <putc>
      state = 0;
 772:	4981                	li	s3,0
 774:	b575                	j	620 <vprintf+0x60>
        s = va_arg(ap, char*);
 776:	8b4e                	mv	s6,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	b55d                	j	620 <vprintf+0x60>
    }
  }
}
 77c:	70e6                	ld	ra,120(sp)
 77e:	7446                	ld	s0,112(sp)
 780:	74a6                	ld	s1,104(sp)
 782:	7906                	ld	s2,96(sp)
 784:	69e6                	ld	s3,88(sp)
 786:	6a46                	ld	s4,80(sp)
 788:	6aa6                	ld	s5,72(sp)
 78a:	6b06                	ld	s6,64(sp)
 78c:	7be2                	ld	s7,56(sp)
 78e:	7c42                	ld	s8,48(sp)
 790:	7ca2                	ld	s9,40(sp)
 792:	7d02                	ld	s10,32(sp)
 794:	6de2                	ld	s11,24(sp)
 796:	6109                	addi	sp,sp,128
 798:	8082                	ret

000000000000079a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79a:	715d                	addi	sp,sp,-80
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e010                	sd	a2,0(s0)
 7a4:	e414                	sd	a3,8(s0)
 7a6:	e818                	sd	a4,16(s0)
 7a8:	ec1c                	sd	a5,24(s0)
 7aa:	03043023          	sd	a6,32(s0)
 7ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b6:	8622                	mv	a2,s0
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e08080e7          	jalr	-504(ra) # 5c0 <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6161                	addi	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <printf>:

void
printf(const char *fmt, ...)
{
 7c8:	711d                	addi	sp,sp,-96
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e40c                	sd	a1,8(s0)
 7d2:	e810                	sd	a2,16(s0)
 7d4:	ec14                	sd	a3,24(s0)
 7d6:	f018                	sd	a4,32(s0)
 7d8:	f41c                	sd	a5,40(s0)
 7da:	03043823          	sd	a6,48(s0)
 7de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	00840613          	addi	a2,s0,8
 7e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ea:	85aa                	mv	a1,a0
 7ec:	4505                	li	a0,1
 7ee:	00000097          	auipc	ra,0x0
 7f2:	dd2080e7          	jalr	-558(ra) # 5c0 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6125                	addi	sp,sp,96
 7fc:	8082                	ret

00000000000007fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fe:	1141                	addi	sp,sp,-16
 800:	e422                	sd	s0,8(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	7f878793          	addi	a5,a5,2040 # 1000 <freep>
 810:	639c                	ld	a5,0(a5)
 812:	a805                	j	842 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 814:	4618                	lw	a4,8(a2)
 816:	9db9                	addw	a1,a1,a4
 818:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6318                	ld	a4,0(a4)
 820:	fee53823          	sd	a4,-16(a0)
 824:	a091                	j	868 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9e39                	addw	a2,a2,a4
 82c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053703          	ld	a4,-16(a0)
 832:	e398                	sd	a4,0(a5)
 834:	a099                	j	87a <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x42>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x52>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bleu	a3,a5,836 <free+0x38>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059713          	slli	a4,a1,0x20
 85a:	9301                	srli	a4,a4,0x20
 85c:	0712                	slli	a4,a4,0x4
 85e:	9736                	add	a4,a4,a3
 860:	fae60ae3          	beq	a2,a4,814 <free+0x16>
    bp->s.ptr = p->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061713          	slli	a4,a2,0x20
 86e:	9301                	srli	a4,a4,0x20
 870:	0712                	slli	a4,a4,0x4
 872:	973e                	add	a4,a4,a5
 874:	fae689e3          	beq	a3,a4,826 <free+0x28>
  } else
    p->s.ptr = bp;
 878:	e394                	sd	a3,0(a5)
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73323          	sd	a5,1926(a4) # 1000 <freep>
}
 882:	6422                	ld	s0,8(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f426                	sd	s1,40(sp)
 890:	f04a                	sd	s2,32(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
 89a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89c:	02051993          	slli	s3,a0,0x20
 8a0:	0209d993          	srli	s3,s3,0x20
 8a4:	09bd                	addi	s3,s3,15
 8a6:	0049d993          	srli	s3,s3,0x4
 8aa:	2985                	addiw	s3,s3,1
 8ac:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 8b0:	00000797          	auipc	a5,0x0
 8b4:	75078793          	addi	a5,a5,1872 # 1000 <freep>
 8b8:	6388                	ld	a0,0(a5)
 8ba:	c515                	beqz	a0,8e6 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	03277f63          	bleu	s2,a4,8fe <malloc+0x76>
 8c4:	8a4e                	mv	s4,s3
 8c6:	0009871b          	sext.w	a4,s3
 8ca:	6685                	lui	a3,0x1
 8cc:	00d77363          	bleu	a3,a4,8d2 <malloc+0x4a>
 8d0:	6a05                	lui	s4,0x1
 8d2:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 8d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8da:	00000497          	auipc	s1,0x0
 8de:	72648493          	addi	s1,s1,1830 # 1000 <freep>
  if(p == (char*)-1)
 8e2:	5b7d                	li	s6,-1
 8e4:	a885                	j	954 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 8e6:	00001797          	auipc	a5,0x1
 8ea:	92a78793          	addi	a5,a5,-1750 # 1210 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7e1                	j	8c4 <malloc+0x3c>
      if(p->s.size == nunits)
 8fe:	02e90b63          	beq	s2,a4,934 <malloc+0xac>
        p->s.size -= nunits;
 902:	4137073b          	subw	a4,a4,s3
 906:	c798                	sw	a4,8(a5)
        p += p->s.size;
 908:	1702                	slli	a4,a4,0x20
 90a:	9301                	srli	a4,a4,0x20
 90c:	0712                	slli	a4,a4,0x4
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void*)(p + 1);
 91c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	74a2                	ld	s1,40(sp)
 926:	7902                	ld	s2,32(sp)
 928:	69e2                	ld	s3,24(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	6121                	addi	sp,sp,64
 932:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 934:	6398                	ld	a4,0(a5)
 936:	e118                	sd	a4,0(a0)
 938:	bff1                	j	914 <malloc+0x8c>
  hp->s.size = nu;
 93a:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 93e:	0541                	addi	a0,a0,16
 940:	00000097          	auipc	ra,0x0
 944:	ebe080e7          	jalr	-322(ra) # 7fe <free>
  return freep;
 948:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 94a:	d979                	beqz	a0,920 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94e:	4798                	lw	a4,8(a5)
 950:	fb2777e3          	bleu	s2,a4,8fe <malloc+0x76>
    if(p == freep)
 954:	6098                	ld	a4,0(s1)
 956:	853e                	mv	a0,a5
 958:	fef71ae3          	bne	a4,a5,94c <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 95c:	8552                	mv	a0,s4
 95e:	00000097          	auipc	ra,0x0
 962:	b6a080e7          	jalr	-1174(ra) # 4c8 <sbrk>
  if(p == (char*)-1)
 966:	fd651ae3          	bne	a0,s6,93a <malloc+0xb2>
        return 0;
 96a:	4501                	li	a0,0
 96c:	bf55                	j	920 <malloc+0x98>
