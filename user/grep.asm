
user/_grep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	89aa                	mv	s3,a0
 138:	8c2e                	mv	s8,a1
  m = 0;
 13a:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00b93          	li	s7,1023
 140:	00001b17          	auipc	s6,0x1
 144:	ed0b0b13          	addi	s6,s6,-304 # 1010 <buf>
    p = buf;
 148:	8d5a                	mv	s10,s6
        *q = '\n';
 14a:	4aa9                	li	s5,10
    p = buf;
 14c:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14e:	a099                	j	194 <grep+0x7a>
        *q = '\n';
 150:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 154:	00148613          	addi	a2,s1,1
 158:	4126063b          	subw	a2,a2,s2
 15c:	85ca                	mv	a1,s2
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	414080e7          	jalr	1044(ra) # 574 <write>
      p = q+1;
 168:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 16c:	45a9                	li	a1,10
 16e:	854a                	mv	a0,s2
 170:	00000097          	auipc	ra,0x0
 174:	1f4080e7          	jalr	500(ra) # 364 <strchr>
 178:	84aa                	mv	s1,a0
 17a:	c919                	beqz	a0,190 <grep+0x76>
      *q = 0;
 17c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 180:	85ca                	mv	a1,s2
 182:	854e                	mv	a0,s3
 184:	00000097          	auipc	ra,0x0
 188:	f48080e7          	jalr	-184(ra) # cc <match>
 18c:	dd71                	beqz	a0,168 <grep+0x4e>
 18e:	b7c9                	j	150 <grep+0x36>
    if(m > 0){
 190:	03404563          	bgtz	s4,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 194:	414b863b          	subw	a2,s7,s4
 198:	014b05b3          	add	a1,s6,s4
 19c:	8562                	mv	a0,s8
 19e:	00000097          	auipc	ra,0x0
 1a2:	3ce080e7          	jalr	974(ra) # 56c <read>
 1a6:	02a05663          	blez	a0,1d2 <grep+0xb8>
    m += n;
 1aa:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1ae:	014b07b3          	add	a5,s6,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf55                	j	16c <grep+0x52>
      m -= p - buf;
 1ba:	416907b3          	sub	a5,s2,s6
 1be:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1c2:	8652                	mv	a2,s4
 1c4:	85ca                	mv	a1,s2
 1c6:	856a                	mv	a0,s10
 1c8:	00000097          	auipc	ra,0x0
 1cc:	2ca080e7          	jalr	714(ra) # 492 <memmove>
 1d0:	b7d1                	j	194 <grep+0x7a>
}
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6ca2                	ld	s9,8(sp)
 1e8:	6d02                	ld	s10,0(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <main>:
{
 1ee:	7139                	addi	sp,sp,-64
 1f0:	fc06                	sd	ra,56(sp)
 1f2:	f822                	sd	s0,48(sp)
 1f4:	f426                	sd	s1,40(sp)
 1f6:	f04a                	sd	s2,32(sp)
 1f8:	ec4e                	sd	s3,24(sp)
 1fa:	e852                	sd	s4,16(sp)
 1fc:	e456                	sd	s5,8(sp)
 1fe:	0080                	addi	s0,sp,64
  if(argc <= 1){
 200:	4785                	li	a5,1
 202:	04a7dd63          	ble	a0,a5,25c <main+0x6e>
  pattern = argv[1];
 206:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20a:	4789                	li	a5,2
 20c:	06a7d663          	ble	a0,a5,278 <main+0x8a>
 210:	01058493          	addi	s1,a1,16
 214:	ffd5099b          	addiw	s3,a0,-3
 218:	1982                	slli	s3,s3,0x20
 21a:	0209d993          	srli	s3,s3,0x20
 21e:	098e                	slli	s3,s3,0x3
 220:	05e1                	addi	a1,a1,24
 222:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 224:	4581                	li	a1,0
 226:	6088                	ld	a0,0(s1)
 228:	00000097          	auipc	ra,0x0
 22c:	36c080e7          	jalr	876(ra) # 594 <open>
 230:	892a                	mv	s2,a0
 232:	04054e63          	bltz	a0,28e <main+0xa0>
    grep(pattern, fd);
 236:	85aa                	mv	a1,a0
 238:	8552                	mv	a0,s4
 23a:	00000097          	auipc	ra,0x0
 23e:	ee0080e7          	jalr	-288(ra) # 11a <grep>
    close(fd);
 242:	854a                	mv	a0,s2
 244:	00000097          	auipc	ra,0x0
 248:	338080e7          	jalr	824(ra) # 57c <close>
  for(i = 2; i < argc; i++){
 24c:	04a1                	addi	s1,s1,8
 24e:	fd349be3          	bne	s1,s3,224 <main+0x36>
  exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	300080e7          	jalr	768(ra) # 554 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25c:	00001597          	auipc	a1,0x1
 260:	83458593          	addi	a1,a1,-1996 # a90 <malloc+0xf4>
 264:	4509                	li	a0,2
 266:	00000097          	auipc	ra,0x0
 26a:	648080e7          	jalr	1608(ra) # 8ae <fprintf>
    exit(1);
 26e:	4505                	li	a0,1
 270:	00000097          	auipc	ra,0x0
 274:	2e4080e7          	jalr	740(ra) # 554 <exit>
    grep(pattern, 0);
 278:	4581                	li	a1,0
 27a:	8552                	mv	a0,s4
 27c:	00000097          	auipc	ra,0x0
 280:	e9e080e7          	jalr	-354(ra) # 11a <grep>
    exit(0);
 284:	4501                	li	a0,0
 286:	00000097          	auipc	ra,0x0
 28a:	2ce080e7          	jalr	718(ra) # 554 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28e:	608c                	ld	a1,0(s1)
 290:	00001517          	auipc	a0,0x1
 294:	82050513          	addi	a0,a0,-2016 # ab0 <malloc+0x114>
 298:	00000097          	auipc	ra,0x0
 29c:	644080e7          	jalr	1604(ra) # 8dc <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	2b2080e7          	jalr	690(ra) # 554 <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3c080e7          	jalr	-196(ra) # 1ee <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	298080e7          	jalr	664(ra) # 554 <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	addi	a1,a1,1
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cf91                	beqz	a5,306 <strcmp+0x26>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71b63          	bne	a4,a5,306 <strcmp+0x26>
    p++, q++;
 2f4:	0505                	addi	a0,a0,1
 2f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	c789                	beqz	a5,306 <strcmp+0x26>
 2fe:	0005c703          	lbu	a4,0(a1)
 302:	fef709e3          	beq	a4,a5,2f4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 306:	0005c503          	lbu	a0,0(a1)
}
 30a:	40a7853b          	subw	a0,a5,a0
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <strlen>:

uint
strlen(const char *s)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31a:	00054783          	lbu	a5,0(a0)
 31e:	cf91                	beqz	a5,33a <strlen+0x26>
 320:	0505                	addi	a0,a0,1
 322:	87aa                	mv	a5,a0
 324:	4685                	li	a3,1
 326:	9e89                	subw	a3,a3,a0
 328:	00f6853b          	addw	a0,a3,a5
 32c:	0785                	addi	a5,a5,1
 32e:	fff7c703          	lbu	a4,-1(a5)
 332:	fb7d                	bnez	a4,328 <strlen+0x14>
    ;
  return n;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  for(n = 0; s[n]; n++)
 33a:	4501                	li	a0,0
 33c:	bfe5                	j	334 <strlen+0x20>

000000000000033e <memset>:

void*
memset(void *dst, int c, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 344:	ce09                	beqz	a2,35e <memset+0x20>
 346:	87aa                	mv	a5,a0
 348:	fff6071b          	addiw	a4,a2,-1
 34c:	1702                	slli	a4,a4,0x20
 34e:	9301                	srli	a4,a4,0x20
 350:	0705                	addi	a4,a4,1
 352:	972a                	add	a4,a4,a0
    cdst[i] = c;
 354:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 358:	0785                	addi	a5,a5,1
 35a:	fee79de3          	bne	a5,a4,354 <memset+0x16>
  }
  return dst;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <strchr>:

char*
strchr(const char *s, char c)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  for(; *s; s++)
 36a:	00054783          	lbu	a5,0(a0)
 36e:	cf91                	beqz	a5,38a <strchr+0x26>
    if(*s == c)
 370:	00f58a63          	beq	a1,a5,384 <strchr+0x20>
  for(; *s; s++)
 374:	0505                	addi	a0,a0,1
 376:	00054783          	lbu	a5,0(a0)
 37a:	c781                	beqz	a5,382 <strchr+0x1e>
    if(*s == c)
 37c:	feb79ce3          	bne	a5,a1,374 <strchr+0x10>
 380:	a011                	j	384 <strchr+0x20>
      return (char*)s;
  return 0;
 382:	4501                	li	a0,0
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret
  return 0;
 38a:	4501                	li	a0,0
 38c:	bfe5                	j	384 <strchr+0x20>

000000000000038e <gets>:

char*
gets(char *buf, int max)
{
 38e:	711d                	addi	sp,sp,-96
 390:	ec86                	sd	ra,88(sp)
 392:	e8a2                	sd	s0,80(sp)
 394:	e4a6                	sd	s1,72(sp)
 396:	e0ca                	sd	s2,64(sp)
 398:	fc4e                	sd	s3,56(sp)
 39a:	f852                	sd	s4,48(sp)
 39c:	f456                	sd	s5,40(sp)
 39e:	f05a                	sd	s6,32(sp)
 3a0:	ec5e                	sd	s7,24(sp)
 3a2:	1080                	addi	s0,sp,96
 3a4:	8baa                	mv	s7,a0
 3a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a8:	892a                	mv	s2,a0
 3aa:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ac:	4aa9                	li	s5,10
 3ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b0:	0019849b          	addiw	s1,s3,1
 3b4:	0344d863          	ble	s4,s1,3e4 <gets+0x56>
    cc = read(0, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	faf40593          	addi	a1,s0,-81
 3be:	4501                	li	a0,0
 3c0:	00000097          	auipc	ra,0x0
 3c4:	1ac080e7          	jalr	428(ra) # 56c <read>
    if(cc < 1)
 3c8:	00a05e63          	blez	a0,3e4 <gets+0x56>
    buf[i++] = c;
 3cc:	faf44783          	lbu	a5,-81(s0)
 3d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d4:	01578763          	beq	a5,s5,3e2 <gets+0x54>
 3d8:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 3da:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 3dc:	fd679ae3          	bne	a5,s6,3b0 <gets+0x22>
 3e0:	a011                	j	3e4 <gets+0x56>
  for(i=0; i+1 < max; ){
 3e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e4:	99de                	add	s3,s3,s7
 3e6:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ea:	855e                	mv	a0,s7
 3ec:	60e6                	ld	ra,88(sp)
 3ee:	6446                	ld	s0,80(sp)
 3f0:	64a6                	ld	s1,72(sp)
 3f2:	6906                	ld	s2,64(sp)
 3f4:	79e2                	ld	s3,56(sp)
 3f6:	7a42                	ld	s4,48(sp)
 3f8:	7aa2                	ld	s5,40(sp)
 3fa:	7b02                	ld	s6,32(sp)
 3fc:	6be2                	ld	s7,24(sp)
 3fe:	6125                	addi	sp,sp,96
 400:	8082                	ret

0000000000000402 <stat>:

int
stat(const char *n, struct stat *st)
{
 402:	1101                	addi	sp,sp,-32
 404:	ec06                	sd	ra,24(sp)
 406:	e822                	sd	s0,16(sp)
 408:	e426                	sd	s1,8(sp)
 40a:	e04a                	sd	s2,0(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 410:	4581                	li	a1,0
 412:	00000097          	auipc	ra,0x0
 416:	182080e7          	jalr	386(ra) # 594 <open>
  if(fd < 0)
 41a:	02054563          	bltz	a0,444 <stat+0x42>
 41e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 420:	85ca                	mv	a1,s2
 422:	00000097          	auipc	ra,0x0
 426:	18a080e7          	jalr	394(ra) # 5ac <fstat>
 42a:	892a                	mv	s2,a0
  close(fd);
 42c:	8526                	mv	a0,s1
 42e:	00000097          	auipc	ra,0x0
 432:	14e080e7          	jalr	334(ra) # 57c <close>
  return r;
}
 436:	854a                	mv	a0,s2
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	64a2                	ld	s1,8(sp)
 43e:	6902                	ld	s2,0(sp)
 440:	6105                	addi	sp,sp,32
 442:	8082                	ret
    return -1;
 444:	597d                	li	s2,-1
 446:	bfc5                	j	436 <stat+0x34>

0000000000000448 <atoi>:

int
atoi(const char *s)
{
 448:	1141                	addi	sp,sp,-16
 44a:	e422                	sd	s0,8(sp)
 44c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44e:	00054683          	lbu	a3,0(a0)
 452:	fd06879b          	addiw	a5,a3,-48
 456:	0ff7f793          	andi	a5,a5,255
 45a:	4725                	li	a4,9
 45c:	02f76963          	bltu	a4,a5,48e <atoi+0x46>
 460:	862a                	mv	a2,a0
  n = 0;
 462:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 464:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 466:	0605                	addi	a2,a2,1
 468:	0025179b          	slliw	a5,a0,0x2
 46c:	9fa9                	addw	a5,a5,a0
 46e:	0017979b          	slliw	a5,a5,0x1
 472:	9fb5                	addw	a5,a5,a3
 474:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 478:	00064683          	lbu	a3,0(a2)
 47c:	fd06871b          	addiw	a4,a3,-48
 480:	0ff77713          	andi	a4,a4,255
 484:	fee5f1e3          	bleu	a4,a1,466 <atoi+0x1e>
  return n;
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  n = 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <atoi+0x40>

0000000000000492 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 498:	02b57663          	bleu	a1,a0,4c4 <memmove+0x32>
    while(n-- > 0)
 49c:	02c05163          	blez	a2,4be <memmove+0x2c>
 4a0:	fff6079b          	addiw	a5,a2,-1
 4a4:	1782                	slli	a5,a5,0x20
 4a6:	9381                	srli	a5,a5,0x20
 4a8:	0785                	addi	a5,a5,1
 4aa:	97aa                	add	a5,a5,a0
  dst = vdst;
 4ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 4ae:	0585                	addi	a1,a1,1
 4b0:	0705                	addi	a4,a4,1
 4b2:	fff5c683          	lbu	a3,-1(a1)
 4b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ba:	fee79ae3          	bne	a5,a4,4ae <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
    dst += n;
 4c4:	00c50733          	add	a4,a0,a2
    src += n;
 4c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ca:	fec05ae3          	blez	a2,4be <memmove+0x2c>
 4ce:	fff6079b          	addiw	a5,a2,-1
 4d2:	1782                	slli	a5,a5,0x20
 4d4:	9381                	srli	a5,a5,0x20
 4d6:	fff7c793          	not	a5,a5
 4da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4dc:	15fd                	addi	a1,a1,-1
 4de:	177d                	addi	a4,a4,-1
 4e0:	0005c683          	lbu	a3,0(a1)
 4e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e8:	fef71ae3          	bne	a4,a5,4dc <memmove+0x4a>
 4ec:	bfc9                	j	4be <memmove+0x2c>

00000000000004ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f4:	ce15                	beqz	a2,530 <memcmp+0x42>
 4f6:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 4fa:	00054783          	lbu	a5,0(a0)
 4fe:	0005c703          	lbu	a4,0(a1)
 502:	02e79063          	bne	a5,a4,522 <memcmp+0x34>
 506:	1682                	slli	a3,a3,0x20
 508:	9281                	srli	a3,a3,0x20
 50a:	0685                	addi	a3,a3,1
 50c:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 50e:	0505                	addi	a0,a0,1
    p2++;
 510:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 512:	00d50d63          	beq	a0,a3,52c <memcmp+0x3e>
    if (*p1 != *p2) {
 516:	00054783          	lbu	a5,0(a0)
 51a:	0005c703          	lbu	a4,0(a1)
 51e:	fee788e3          	beq	a5,a4,50e <memcmp+0x20>
      return *p1 - *p2;
 522:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret
  return 0;
 52c:	4501                	li	a0,0
 52e:	bfe5                	j	526 <memcmp+0x38>
 530:	4501                	li	a0,0
 532:	bfd5                	j	526 <memcmp+0x38>

0000000000000534 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 534:	1141                	addi	sp,sp,-16
 536:	e406                	sd	ra,8(sp)
 538:	e022                	sd	s0,0(sp)
 53a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 53c:	00000097          	auipc	ra,0x0
 540:	f56080e7          	jalr	-170(ra) # 492 <memmove>
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54c:	4885                	li	a7,1
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <exit>:
.global exit
exit:
 li a7, SYS_exit
 554:	4889                	li	a7,2
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <wait>:
.global wait
wait:
 li a7, SYS_wait
 55c:	488d                	li	a7,3
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 564:	4891                	li	a7,4
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <read>:
.global read
read:
 li a7, SYS_read
 56c:	4895                	li	a7,5
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <write>:
.global write
write:
 li a7, SYS_write
 574:	48c1                	li	a7,16
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <close>:
.global close
close:
 li a7, SYS_close
 57c:	48d5                	li	a7,21
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <kill>:
.global kill
kill:
 li a7, SYS_kill
 584:	4899                	li	a7,6
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exec>:
.global exec
exec:
 li a7, SYS_exec
 58c:	489d                	li	a7,7
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <open>:
.global open
open:
 li a7, SYS_open
 594:	48bd                	li	a7,15
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59c:	48c5                	li	a7,17
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a4:	48c9                	li	a7,18
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ac:	48a1                	li	a7,8
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <link>:
.global link
link:
 li a7, SYS_link
 5b4:	48cd                	li	a7,19
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5bc:	48d1                	li	a7,20
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c4:	48a5                	li	a7,9
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5cc:	48a9                	li	a7,10
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d4:	48ad                	li	a7,11
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5dc:	48b1                	li	a7,12
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e4:	48b5                	li	a7,13
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ec:	48b9                	li	a7,14
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5f4:	48d9                	li	a7,22
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5fc:	48dd                	li	a7,23
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 604:	1101                	addi	sp,sp,-32
 606:	ec06                	sd	ra,24(sp)
 608:	e822                	sd	s0,16(sp)
 60a:	1000                	addi	s0,sp,32
 60c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 610:	4605                	li	a2,1
 612:	fef40593          	addi	a1,s0,-17
 616:	00000097          	auipc	ra,0x0
 61a:	f5e080e7          	jalr	-162(ra) # 574 <write>
}
 61e:	60e2                	ld	ra,24(sp)
 620:	6442                	ld	s0,16(sp)
 622:	6105                	addi	sp,sp,32
 624:	8082                	ret

0000000000000626 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 626:	7139                	addi	sp,sp,-64
 628:	fc06                	sd	ra,56(sp)
 62a:	f822                	sd	s0,48(sp)
 62c:	f426                	sd	s1,40(sp)
 62e:	f04a                	sd	s2,32(sp)
 630:	ec4e                	sd	s3,24(sp)
 632:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 634:	c299                	beqz	a3,63a <printint+0x14>
 636:	0005cd63          	bltz	a1,650 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 63a:	2581                	sext.w	a1,a1
  neg = 0;
 63c:	4301                	li	t1,0
 63e:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 642:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 644:	2601                	sext.w	a2,a2
 646:	00000897          	auipc	a7,0x0
 64a:	48288893          	addi	a7,a7,1154 # ac8 <digits>
 64e:	a801                	j	65e <printint+0x38>
    x = -xx;
 650:	40b005bb          	negw	a1,a1
 654:	2581                	sext.w	a1,a1
    neg = 1;
 656:	4305                	li	t1,1
    x = -xx;
 658:	b7dd                	j	63e <printint+0x18>
  }while((x /= base) != 0);
 65a:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 65c:	8836                	mv	a6,a3
 65e:	0018069b          	addiw	a3,a6,1
 662:	02c5f7bb          	remuw	a5,a1,a2
 666:	1782                	slli	a5,a5,0x20
 668:	9381                	srli	a5,a5,0x20
 66a:	97c6                	add	a5,a5,a7
 66c:	0007c783          	lbu	a5,0(a5)
 670:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 674:	0705                	addi	a4,a4,1
 676:	02c5d7bb          	divuw	a5,a1,a2
 67a:	fec5f0e3          	bleu	a2,a1,65a <printint+0x34>
  if(neg)
 67e:	00030b63          	beqz	t1,694 <printint+0x6e>
    buf[i++] = '-';
 682:	fd040793          	addi	a5,s0,-48
 686:	96be                	add	a3,a3,a5
 688:	02d00793          	li	a5,45
 68c:	fef68823          	sb	a5,-16(a3)
 690:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 694:	02d05963          	blez	a3,6c6 <printint+0xa0>
 698:	89aa                	mv	s3,a0
 69a:	fc040793          	addi	a5,s0,-64
 69e:	00d784b3          	add	s1,a5,a3
 6a2:	fff78913          	addi	s2,a5,-1
 6a6:	9936                	add	s2,s2,a3
 6a8:	36fd                	addiw	a3,a3,-1
 6aa:	1682                	slli	a3,a3,0x20
 6ac:	9281                	srli	a3,a3,0x20
 6ae:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 6b2:	fff4c583          	lbu	a1,-1(s1)
 6b6:	854e                	mv	a0,s3
 6b8:	00000097          	auipc	ra,0x0
 6bc:	f4c080e7          	jalr	-180(ra) # 604 <putc>
  while(--i >= 0)
 6c0:	14fd                	addi	s1,s1,-1
 6c2:	ff2498e3          	bne	s1,s2,6b2 <printint+0x8c>
}
 6c6:	70e2                	ld	ra,56(sp)
 6c8:	7442                	ld	s0,48(sp)
 6ca:	74a2                	ld	s1,40(sp)
 6cc:	7902                	ld	s2,32(sp)
 6ce:	69e2                	ld	s3,24(sp)
 6d0:	6121                	addi	sp,sp,64
 6d2:	8082                	ret

00000000000006d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d4:	7119                	addi	sp,sp,-128
 6d6:	fc86                	sd	ra,120(sp)
 6d8:	f8a2                	sd	s0,112(sp)
 6da:	f4a6                	sd	s1,104(sp)
 6dc:	f0ca                	sd	s2,96(sp)
 6de:	ecce                	sd	s3,88(sp)
 6e0:	e8d2                	sd	s4,80(sp)
 6e2:	e4d6                	sd	s5,72(sp)
 6e4:	e0da                	sd	s6,64(sp)
 6e6:	fc5e                	sd	s7,56(sp)
 6e8:	f862                	sd	s8,48(sp)
 6ea:	f466                	sd	s9,40(sp)
 6ec:	f06a                	sd	s10,32(sp)
 6ee:	ec6e                	sd	s11,24(sp)
 6f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f2:	0005c483          	lbu	s1,0(a1)
 6f6:	18048d63          	beqz	s1,890 <vprintf+0x1bc>
 6fa:	8aaa                	mv	s5,a0
 6fc:	8b32                	mv	s6,a2
 6fe:	00158913          	addi	s2,a1,1
  state = 0;
 702:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 704:	02500a13          	li	s4,37
      if(c == 'd'){
 708:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 70c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 710:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 714:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 718:	00000b97          	auipc	s7,0x0
 71c:	3b0b8b93          	addi	s7,s7,944 # ac8 <digits>
 720:	a839                	j	73e <vprintf+0x6a>
        putc(fd, c);
 722:	85a6                	mv	a1,s1
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	ede080e7          	jalr	-290(ra) # 604 <putc>
 72e:	a019                	j	734 <vprintf+0x60>
    } else if(state == '%'){
 730:	01498f63          	beq	s3,s4,74e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 734:	0905                	addi	s2,s2,1
 736:	fff94483          	lbu	s1,-1(s2)
 73a:	14048b63          	beqz	s1,890 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 73e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 742:	fe0997e3          	bnez	s3,730 <vprintf+0x5c>
      if(c == '%'){
 746:	fd479ee3          	bne	a5,s4,722 <vprintf+0x4e>
        state = '%';
 74a:	89be                	mv	s3,a5
 74c:	b7e5                	j	734 <vprintf+0x60>
      if(c == 'd'){
 74e:	05878063          	beq	a5,s8,78e <vprintf+0xba>
      } else if(c == 'l') {
 752:	05978c63          	beq	a5,s9,7aa <vprintf+0xd6>
      } else if(c == 'x') {
 756:	07a78863          	beq	a5,s10,7c6 <vprintf+0xf2>
      } else if(c == 'p') {
 75a:	09b78463          	beq	a5,s11,7e2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 75e:	07300713          	li	a4,115
 762:	0ce78563          	beq	a5,a4,82c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 766:	06300713          	li	a4,99
 76a:	0ee78c63          	beq	a5,a4,862 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 76e:	11478663          	beq	a5,s4,87a <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 772:	85d2                	mv	a1,s4
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e8e080e7          	jalr	-370(ra) # 604 <putc>
        putc(fd, c);
 77e:	85a6                	mv	a1,s1
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e82080e7          	jalr	-382(ra) # 604 <putc>
      }
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b765                	j	734 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 78e:	008b0493          	addi	s1,s6,8
 792:	4685                	li	a3,1
 794:	4629                	li	a2,10
 796:	000b2583          	lw	a1,0(s6)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e8a080e7          	jalr	-374(ra) # 626 <printint>
 7a4:	8b26                	mv	s6,s1
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b771                	j	734 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7aa:	008b0493          	addi	s1,s6,8
 7ae:	4681                	li	a3,0
 7b0:	4629                	li	a2,10
 7b2:	000b2583          	lw	a1,0(s6)
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e6e080e7          	jalr	-402(ra) # 626 <printint>
 7c0:	8b26                	mv	s6,s1
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bf85                	j	734 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7c6:	008b0493          	addi	s1,s6,8
 7ca:	4681                	li	a3,0
 7cc:	4641                	li	a2,16
 7ce:	000b2583          	lw	a1,0(s6)
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e52080e7          	jalr	-430(ra) # 626 <printint>
 7dc:	8b26                	mv	s6,s1
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bf91                	j	734 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7e2:	008b0793          	addi	a5,s6,8
 7e6:	f8f43423          	sd	a5,-120(s0)
 7ea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7ee:	03000593          	li	a1,48
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e10080e7          	jalr	-496(ra) # 604 <putc>
  putc(fd, 'x');
 7fc:	85ea                	mv	a1,s10
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e04080e7          	jalr	-508(ra) # 604 <putc>
 808:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80a:	03c9d793          	srli	a5,s3,0x3c
 80e:	97de                	add	a5,a5,s7
 810:	0007c583          	lbu	a1,0(a5)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	dee080e7          	jalr	-530(ra) # 604 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81e:	0992                	slli	s3,s3,0x4
 820:	34fd                	addiw	s1,s1,-1
 822:	f4e5                	bnez	s1,80a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 824:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 828:	4981                	li	s3,0
 82a:	b729                	j	734 <vprintf+0x60>
        s = va_arg(ap, char*);
 82c:	008b0993          	addi	s3,s6,8
 830:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 834:	c085                	beqz	s1,854 <vprintf+0x180>
        while(*s != 0){
 836:	0004c583          	lbu	a1,0(s1)
 83a:	c9a1                	beqz	a1,88a <vprintf+0x1b6>
          putc(fd, *s);
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	dc6080e7          	jalr	-570(ra) # 604 <putc>
          s++;
 846:	0485                	addi	s1,s1,1
        while(*s != 0){
 848:	0004c583          	lbu	a1,0(s1)
 84c:	f9e5                	bnez	a1,83c <vprintf+0x168>
        s = va_arg(ap, char*);
 84e:	8b4e                	mv	s6,s3
      state = 0;
 850:	4981                	li	s3,0
 852:	b5cd                	j	734 <vprintf+0x60>
          s = "(null)";
 854:	00000497          	auipc	s1,0x0
 858:	28c48493          	addi	s1,s1,652 # ae0 <digits+0x18>
        while(*s != 0){
 85c:	02800593          	li	a1,40
 860:	bff1                	j	83c <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 862:	008b0493          	addi	s1,s6,8
 866:	000b4583          	lbu	a1,0(s6)
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	d98080e7          	jalr	-616(ra) # 604 <putc>
 874:	8b26                	mv	s6,s1
      state = 0;
 876:	4981                	li	s3,0
 878:	bd75                	j	734 <vprintf+0x60>
        putc(fd, c);
 87a:	85d2                	mv	a1,s4
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	d86080e7          	jalr	-634(ra) # 604 <putc>
      state = 0;
 886:	4981                	li	s3,0
 888:	b575                	j	734 <vprintf+0x60>
        s = va_arg(ap, char*);
 88a:	8b4e                	mv	s6,s3
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b55d                	j	734 <vprintf+0x60>
    }
  }
}
 890:	70e6                	ld	ra,120(sp)
 892:	7446                	ld	s0,112(sp)
 894:	74a6                	ld	s1,104(sp)
 896:	7906                	ld	s2,96(sp)
 898:	69e6                	ld	s3,88(sp)
 89a:	6a46                	ld	s4,80(sp)
 89c:	6aa6                	ld	s5,72(sp)
 89e:	6b06                	ld	s6,64(sp)
 8a0:	7be2                	ld	s7,56(sp)
 8a2:	7c42                	ld	s8,48(sp)
 8a4:	7ca2                	ld	s9,40(sp)
 8a6:	7d02                	ld	s10,32(sp)
 8a8:	6de2                	ld	s11,24(sp)
 8aa:	6109                	addi	sp,sp,128
 8ac:	8082                	ret

00000000000008ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ae:	715d                	addi	sp,sp,-80
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e010                	sd	a2,0(s0)
 8b8:	e414                	sd	a3,8(s0)
 8ba:	e818                	sd	a4,16(s0)
 8bc:	ec1c                	sd	a5,24(s0)
 8be:	03043023          	sd	a6,32(s0)
 8c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ca:	8622                	mv	a2,s0
 8cc:	00000097          	auipc	ra,0x0
 8d0:	e08080e7          	jalr	-504(ra) # 6d4 <vprintf>
}
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6161                	addi	sp,sp,80
 8da:	8082                	ret

00000000000008dc <printf>:

void
printf(const char *fmt, ...)
{
 8dc:	711d                	addi	sp,sp,-96
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	e40c                	sd	a1,8(s0)
 8e6:	e810                	sd	a2,16(s0)
 8e8:	ec14                	sd	a3,24(s0)
 8ea:	f018                	sd	a4,32(s0)
 8ec:	f41c                	sd	a5,40(s0)
 8ee:	03043823          	sd	a6,48(s0)
 8f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f6:	00840613          	addi	a2,s0,8
 8fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fe:	85aa                	mv	a1,a0
 900:	4505                	li	a0,1
 902:	00000097          	auipc	ra,0x0
 906:	dd2080e7          	jalr	-558(ra) # 6d4 <vprintf>
}
 90a:	60e2                	ld	ra,24(sp)
 90c:	6442                	ld	s0,16(sp)
 90e:	6125                	addi	sp,sp,96
 910:	8082                	ret

0000000000000912 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 912:	1141                	addi	sp,sp,-16
 914:	e422                	sd	s0,8(sp)
 916:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 918:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	00000797          	auipc	a5,0x0
 920:	6e478793          	addi	a5,a5,1764 # 1000 <freep>
 924:	639c                	ld	a5,0(a5)
 926:	a805                	j	956 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 928:	4618                	lw	a4,8(a2)
 92a:	9db9                	addw	a1,a1,a4
 92c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	6318                	ld	a4,0(a4)
 934:	fee53823          	sd	a4,-16(a0)
 938:	a091                	j	97c <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 93a:	ff852703          	lw	a4,-8(a0)
 93e:	9e39                	addw	a2,a2,a4
 940:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 942:	ff053703          	ld	a4,-16(a0)
 946:	e398                	sd	a4,0(a5)
 948:	a099                	j	98e <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	6398                	ld	a4,0(a5)
 94c:	00e7e463          	bltu	a5,a4,954 <free+0x42>
 950:	00e6ea63          	bltu	a3,a4,964 <free+0x52>
{
 954:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	fed7fae3          	bleu	a3,a5,94a <free+0x38>
 95a:	6398                	ld	a4,0(a5)
 95c:	00e6e463          	bltu	a3,a4,964 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 960:	fee7eae3          	bltu	a5,a4,954 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 964:	ff852583          	lw	a1,-8(a0)
 968:	6390                	ld	a2,0(a5)
 96a:	02059713          	slli	a4,a1,0x20
 96e:	9301                	srli	a4,a4,0x20
 970:	0712                	slli	a4,a4,0x4
 972:	9736                	add	a4,a4,a3
 974:	fae60ae3          	beq	a2,a4,928 <free+0x16>
    bp->s.ptr = p->s.ptr;
 978:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 97c:	4790                	lw	a2,8(a5)
 97e:	02061713          	slli	a4,a2,0x20
 982:	9301                	srli	a4,a4,0x20
 984:	0712                	slli	a4,a4,0x4
 986:	973e                	add	a4,a4,a5
 988:	fae689e3          	beq	a3,a4,93a <free+0x28>
  } else
    p->s.ptr = bp;
 98c:	e394                	sd	a3,0(a5)
  freep = p;
 98e:	00000717          	auipc	a4,0x0
 992:	66f73923          	sd	a5,1650(a4) # 1000 <freep>
}
 996:	6422                	ld	s0,8(sp)
 998:	0141                	addi	sp,sp,16
 99a:	8082                	ret

000000000000099c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 99c:	7139                	addi	sp,sp,-64
 99e:	fc06                	sd	ra,56(sp)
 9a0:	f822                	sd	s0,48(sp)
 9a2:	f426                	sd	s1,40(sp)
 9a4:	f04a                	sd	s2,32(sp)
 9a6:	ec4e                	sd	s3,24(sp)
 9a8:	e852                	sd	s4,16(sp)
 9aa:	e456                	sd	s5,8(sp)
 9ac:	e05a                	sd	s6,0(sp)
 9ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b0:	02051993          	slli	s3,a0,0x20
 9b4:	0209d993          	srli	s3,s3,0x20
 9b8:	09bd                	addi	s3,s3,15
 9ba:	0049d993          	srli	s3,s3,0x4
 9be:	2985                	addiw	s3,s3,1
 9c0:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 9c4:	00000797          	auipc	a5,0x0
 9c8:	63c78793          	addi	a5,a5,1596 # 1000 <freep>
 9cc:	6388                	ld	a0,0(a5)
 9ce:	c515                	beqz	a0,9fa <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d2:	4798                	lw	a4,8(a5)
 9d4:	03277f63          	bleu	s2,a4,a12 <malloc+0x76>
 9d8:	8a4e                	mv	s4,s3
 9da:	0009871b          	sext.w	a4,s3
 9de:	6685                	lui	a3,0x1
 9e0:	00d77363          	bleu	a3,a4,9e6 <malloc+0x4a>
 9e4:	6a05                	lui	s4,0x1
 9e6:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 9ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ee:	00000497          	auipc	s1,0x0
 9f2:	61248493          	addi	s1,s1,1554 # 1000 <freep>
  if(p == (char*)-1)
 9f6:	5b7d                	li	s6,-1
 9f8:	a885                	j	a68 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 9fa:	00001797          	auipc	a5,0x1
 9fe:	a1678793          	addi	a5,a5,-1514 # 1410 <base>
 a02:	00000717          	auipc	a4,0x0
 a06:	5ef73f23          	sd	a5,1534(a4) # 1000 <freep>
 a0a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a0c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a10:	b7e1                	j	9d8 <malloc+0x3c>
      if(p->s.size == nunits)
 a12:	02e90b63          	beq	s2,a4,a48 <malloc+0xac>
        p->s.size -= nunits;
 a16:	4137073b          	subw	a4,a4,s3
 a1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1c:	1702                	slli	a4,a4,0x20
 a1e:	9301                	srli	a4,a4,0x20
 a20:	0712                	slli	a4,a4,0x4
 a22:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a24:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a28:	00000717          	auipc	a4,0x0
 a2c:	5ca73c23          	sd	a0,1496(a4) # 1000 <freep>
      return (void*)(p + 1);
 a30:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a34:	70e2                	ld	ra,56(sp)
 a36:	7442                	ld	s0,48(sp)
 a38:	74a2                	ld	s1,40(sp)
 a3a:	7902                	ld	s2,32(sp)
 a3c:	69e2                	ld	s3,24(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
 a44:	6121                	addi	sp,sp,64
 a46:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a48:	6398                	ld	a4,0(a5)
 a4a:	e118                	sd	a4,0(a0)
 a4c:	bff1                	j	a28 <malloc+0x8c>
  hp->s.size = nu;
 a4e:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a52:	0541                	addi	a0,a0,16
 a54:	00000097          	auipc	ra,0x0
 a58:	ebe080e7          	jalr	-322(ra) # 912 <free>
  return freep;
 a5c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a5e:	d979                	beqz	a0,a34 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a62:	4798                	lw	a4,8(a5)
 a64:	fb2777e3          	bleu	s2,a4,a12 <malloc+0x76>
    if(p == freep)
 a68:	6098                	ld	a4,0(s1)
 a6a:	853e                	mv	a0,a5
 a6c:	fef71ae3          	bne	a4,a5,a60 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 a70:	8552                	mv	a0,s4
 a72:	00000097          	auipc	ra,0x0
 a76:	b6a080e7          	jalr	-1174(ra) # 5dc <sbrk>
  if(p == (char*)-1)
 a7a:	fd651ae3          	bne	a0,s6,a4e <malloc+0xb2>
        return 0;
 a7e:	4501                	li	a0,0
 a80:	bf55                	j	a34 <malloc+0x98>
