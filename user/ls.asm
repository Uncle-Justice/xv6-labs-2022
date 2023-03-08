
user/_ls：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	33a080e7          	jalr	826(ra) # 34a <strlen>
  18:	1502                	slli	a0,a0,0x20
  1a:	9101                	srli	a0,a0,0x20
  1c:	9526                	add	a0,a0,s1
  1e:	02956163          	bltu	a0,s1,40 <fmtname+0x40>
  22:	00054703          	lbu	a4,0(a0)
  26:	02f00793          	li	a5,47
  2a:	00f70b63          	beq	a4,a5,40 <fmtname+0x40>
  2e:	02f00713          	li	a4,47
  32:	157d                	addi	a0,a0,-1
  34:	00956663          	bltu	a0,s1,40 <fmtname+0x40>
  38:	00054783          	lbu	a5,0(a0)
  3c:	fee79be3          	bne	a5,a4,32 <fmtname+0x32>
    ;
  p++;
  40:	00150493          	addi	s1,a0,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  44:	8526                	mv	a0,s1
  46:	00000097          	auipc	ra,0x0
  4a:	304080e7          	jalr	772(ra) # 34a <strlen>
  4e:	2501                	sext.w	a0,a0
  50:	47b5                	li	a5,13
  52:	00a7fa63          	bleu	a0,a5,66 <fmtname+0x66>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  56:	8526                	mv	a0,s1
  58:	70a2                	ld	ra,40(sp)
  5a:	7402                	ld	s0,32(sp)
  5c:	64e2                	ld	s1,24(sp)
  5e:	6942                	ld	s2,16(sp)
  60:	69a2                	ld	s3,8(sp)
  62:	6145                	addi	sp,sp,48
  64:	8082                	ret
  memmove(buf, p, strlen(p));
  66:	8526                	mv	a0,s1
  68:	00000097          	auipc	ra,0x0
  6c:	2e2080e7          	jalr	738(ra) # 34a <strlen>
  70:	00001917          	auipc	s2,0x1
  74:	fa090913          	addi	s2,s2,-96 # 1010 <buf.1131>
  78:	0005061b          	sext.w	a2,a0
  7c:	85a6                	mv	a1,s1
  7e:	854a                	mv	a0,s2
  80:	00000097          	auipc	ra,0x0
  84:	448080e7          	jalr	1096(ra) # 4c8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2c0080e7          	jalr	704(ra) # 34a <strlen>
  92:	0005099b          	sext.w	s3,a0
  96:	8526                	mv	a0,s1
  98:	00000097          	auipc	ra,0x0
  9c:	2b2080e7          	jalr	690(ra) # 34a <strlen>
  a0:	1982                	slli	s3,s3,0x20
  a2:	0209d993          	srli	s3,s3,0x20
  a6:	4639                	li	a2,14
  a8:	9e09                	subw	a2,a2,a0
  aa:	02000593          	li	a1,32
  ae:	01390533          	add	a0,s2,s3
  b2:	00000097          	auipc	ra,0x0
  b6:	2c2080e7          	jalr	706(ra) # 374 <memset>
  return buf;
  ba:	84ca                	mv	s1,s2
  bc:	bf69                	j	56 <fmtname+0x56>

00000000000000be <ls>:

void
ls(char *path)
{
  be:	d9010113          	addi	sp,sp,-624
  c2:	26113423          	sd	ra,616(sp)
  c6:	26813023          	sd	s0,608(sp)
  ca:	24913c23          	sd	s1,600(sp)
  ce:	25213823          	sd	s2,592(sp)
  d2:	25313423          	sd	s3,584(sp)
  d6:	25413023          	sd	s4,576(sp)
  da:	23513c23          	sd	s5,568(sp)
  de:	1c80                	addi	s0,sp,624
  e0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  e2:	4581                	li	a1,0
  e4:	00000097          	auipc	ra,0x0
  e8:	4e6080e7          	jalr	1254(ra) # 5ca <open>
  ec:	08054163          	bltz	a0,16e <ls+0xb0>
  f0:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  f2:	d9840593          	addi	a1,s0,-616
  f6:	00000097          	auipc	ra,0x0
  fa:	4ec080e7          	jalr	1260(ra) # 5e2 <fstat>
  fe:	08054363          	bltz	a0,184 <ls+0xc6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 102:	da041783          	lh	a5,-608(s0)
 106:	0007869b          	sext.w	a3,a5
 10a:	4705                	li	a4,1
 10c:	08e68c63          	beq	a3,a4,1a4 <ls+0xe6>
 110:	02d05963          	blez	a3,142 <ls+0x84>
 114:	470d                	li	a4,3
 116:	02d74663          	blt	a4,a3,142 <ls+0x84>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 11a:	854a                	mv	a0,s2
 11c:	00000097          	auipc	ra,0x0
 120:	ee4080e7          	jalr	-284(ra) # 0 <fmtname>
 124:	da843703          	ld	a4,-600(s0)
 128:	d9c42683          	lw	a3,-612(s0)
 12c:	da041603          	lh	a2,-608(s0)
 130:	85aa                	mv	a1,a0
 132:	00001517          	auipc	a0,0x1
 136:	9be50513          	addi	a0,a0,-1602 # af0 <malloc+0x11e>
 13a:	00000097          	auipc	ra,0x0
 13e:	7d8080e7          	jalr	2008(ra) # 912 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 142:	8526                	mv	a0,s1
 144:	00000097          	auipc	ra,0x0
 148:	46e080e7          	jalr	1134(ra) # 5b2 <close>
}
 14c:	26813083          	ld	ra,616(sp)
 150:	26013403          	ld	s0,608(sp)
 154:	25813483          	ld	s1,600(sp)
 158:	25013903          	ld	s2,592(sp)
 15c:	24813983          	ld	s3,584(sp)
 160:	24013a03          	ld	s4,576(sp)
 164:	23813a83          	ld	s5,568(sp)
 168:	27010113          	addi	sp,sp,624
 16c:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 16e:	864a                	mv	a2,s2
 170:	00001597          	auipc	a1,0x1
 174:	95058593          	addi	a1,a1,-1712 # ac0 <malloc+0xee>
 178:	4509                	li	a0,2
 17a:	00000097          	auipc	ra,0x0
 17e:	76a080e7          	jalr	1898(ra) # 8e4 <fprintf>
    return;
 182:	b7e9                	j	14c <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 184:	864a                	mv	a2,s2
 186:	00001597          	auipc	a1,0x1
 18a:	95258593          	addi	a1,a1,-1710 # ad8 <malloc+0x106>
 18e:	4509                	li	a0,2
 190:	00000097          	auipc	ra,0x0
 194:	754080e7          	jalr	1876(ra) # 8e4 <fprintf>
    close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	418080e7          	jalr	1048(ra) # 5b2 <close>
    return;
 1a2:	b76d                	j	14c <ls+0x8e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a4:	854a                	mv	a0,s2
 1a6:	00000097          	auipc	ra,0x0
 1aa:	1a4080e7          	jalr	420(ra) # 34a <strlen>
 1ae:	2541                	addiw	a0,a0,16
 1b0:	20000793          	li	a5,512
 1b4:	00a7fb63          	bleu	a0,a5,1ca <ls+0x10c>
      printf("ls: path too long\n");
 1b8:	00001517          	auipc	a0,0x1
 1bc:	94850513          	addi	a0,a0,-1720 # b00 <malloc+0x12e>
 1c0:	00000097          	auipc	ra,0x0
 1c4:	752080e7          	jalr	1874(ra) # 912 <printf>
      break;
 1c8:	bfad                	j	142 <ls+0x84>
    strcpy(buf, path);
 1ca:	85ca                	mv	a1,s2
 1cc:	dc040513          	addi	a0,s0,-576
 1d0:	00000097          	auipc	ra,0x0
 1d4:	12a080e7          	jalr	298(ra) # 2fa <strcpy>
    p = buf+strlen(buf);
 1d8:	dc040513          	addi	a0,s0,-576
 1dc:	00000097          	auipc	ra,0x0
 1e0:	16e080e7          	jalr	366(ra) # 34a <strlen>
 1e4:	1502                	slli	a0,a0,0x20
 1e6:	9101                	srli	a0,a0,0x20
 1e8:	dc040793          	addi	a5,s0,-576
 1ec:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1f0:	00190993          	addi	s3,s2,1
 1f4:	02f00793          	li	a5,47
 1f8:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1fc:	00001a17          	auipc	s4,0x1
 200:	91ca0a13          	addi	s4,s4,-1764 # b18 <malloc+0x146>
        printf("ls: cannot stat %s\n", buf);
 204:	00001a97          	auipc	s5,0x1
 208:	8d4a8a93          	addi	s5,s5,-1836 # ad8 <malloc+0x106>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20c:	a01d                	j	232 <ls+0x174>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 20e:	dc040513          	addi	a0,s0,-576
 212:	00000097          	auipc	ra,0x0
 216:	dee080e7          	jalr	-530(ra) # 0 <fmtname>
 21a:	da843703          	ld	a4,-600(s0)
 21e:	d9c42683          	lw	a3,-612(s0)
 222:	da041603          	lh	a2,-608(s0)
 226:	85aa                	mv	a1,a0
 228:	8552                	mv	a0,s4
 22a:	00000097          	auipc	ra,0x0
 22e:	6e8080e7          	jalr	1768(ra) # 912 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 232:	4641                	li	a2,16
 234:	db040593          	addi	a1,s0,-592
 238:	8526                	mv	a0,s1
 23a:	00000097          	auipc	ra,0x0
 23e:	368080e7          	jalr	872(ra) # 5a2 <read>
 242:	47c1                	li	a5,16
 244:	eef51fe3          	bne	a0,a5,142 <ls+0x84>
      if(de.inum == 0)
 248:	db045783          	lhu	a5,-592(s0)
 24c:	d3fd                	beqz	a5,232 <ls+0x174>
      memmove(p, de.name, DIRSIZ);
 24e:	4639                	li	a2,14
 250:	db240593          	addi	a1,s0,-590
 254:	854e                	mv	a0,s3
 256:	00000097          	auipc	ra,0x0
 25a:	272080e7          	jalr	626(ra) # 4c8 <memmove>
      p[DIRSIZ] = 0;
 25e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 262:	d9840593          	addi	a1,s0,-616
 266:	dc040513          	addi	a0,s0,-576
 26a:	00000097          	auipc	ra,0x0
 26e:	1ce080e7          	jalr	462(ra) # 438 <stat>
 272:	f8055ee3          	bgez	a0,20e <ls+0x150>
        printf("ls: cannot stat %s\n", buf);
 276:	dc040593          	addi	a1,s0,-576
 27a:	8556                	mv	a0,s5
 27c:	00000097          	auipc	ra,0x0
 280:	696080e7          	jalr	1686(ra) # 912 <printf>
        continue;
 284:	b77d                	j	232 <ls+0x174>

0000000000000286 <main>:

int
main(int argc, char *argv[])
{
 286:	1101                	addi	sp,sp,-32
 288:	ec06                	sd	ra,24(sp)
 28a:	e822                	sd	s0,16(sp)
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 292:	4785                	li	a5,1
 294:	02a7d963          	ble	a0,a5,2c6 <main+0x40>
 298:	00858493          	addi	s1,a1,8
 29c:	ffe5091b          	addiw	s2,a0,-2
 2a0:	1902                	slli	s2,s2,0x20
 2a2:	02095913          	srli	s2,s2,0x20
 2a6:	090e                	slli	s2,s2,0x3
 2a8:	05c1                	addi	a1,a1,16
 2aa:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2ac:	6088                	ld	a0,0(s1)
 2ae:	00000097          	auipc	ra,0x0
 2b2:	e10080e7          	jalr	-496(ra) # be <ls>
  for(i=1; i<argc; i++)
 2b6:	04a1                	addi	s1,s1,8
 2b8:	ff249ae3          	bne	s1,s2,2ac <main+0x26>
  exit(0);
 2bc:	4501                	li	a0,0
 2be:	00000097          	auipc	ra,0x0
 2c2:	2cc080e7          	jalr	716(ra) # 58a <exit>
    ls(".");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	86250513          	addi	a0,a0,-1950 # b28 <malloc+0x156>
 2ce:	00000097          	auipc	ra,0x0
 2d2:	df0080e7          	jalr	-528(ra) # be <ls>
    exit(0);
 2d6:	4501                	li	a0,0
 2d8:	00000097          	auipc	ra,0x0
 2dc:	2b2080e7          	jalr	690(ra) # 58a <exit>

00000000000002e0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f9e080e7          	jalr	-98(ra) # 286 <main>
  exit(0);
 2f0:	4501                	li	a0,0
 2f2:	00000097          	auipc	ra,0x0
 2f6:	298080e7          	jalr	664(ra) # 58a <exit>

00000000000002fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 300:	87aa                	mv	a5,a0
 302:	0585                	addi	a1,a1,1
 304:	0785                	addi	a5,a5,1
 306:	fff5c703          	lbu	a4,-1(a1)
 30a:	fee78fa3          	sb	a4,-1(a5)
 30e:	fb75                	bnez	a4,302 <strcpy+0x8>
    ;
  return os;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 31c:	00054783          	lbu	a5,0(a0)
 320:	cf91                	beqz	a5,33c <strcmp+0x26>
 322:	0005c703          	lbu	a4,0(a1)
 326:	00f71b63          	bne	a4,a5,33c <strcmp+0x26>
    p++, q++;
 32a:	0505                	addi	a0,a0,1
 32c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 32e:	00054783          	lbu	a5,0(a0)
 332:	c789                	beqz	a5,33c <strcmp+0x26>
 334:	0005c703          	lbu	a4,0(a1)
 338:	fef709e3          	beq	a4,a5,32a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 33c:	0005c503          	lbu	a0,0(a1)
}
 340:	40a7853b          	subw	a0,a5,a0
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <strlen>:

uint
strlen(const char *s)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 350:	00054783          	lbu	a5,0(a0)
 354:	cf91                	beqz	a5,370 <strlen+0x26>
 356:	0505                	addi	a0,a0,1
 358:	87aa                	mv	a5,a0
 35a:	4685                	li	a3,1
 35c:	9e89                	subw	a3,a3,a0
 35e:	00f6853b          	addw	a0,a3,a5
 362:	0785                	addi	a5,a5,1
 364:	fff7c703          	lbu	a4,-1(a5)
 368:	fb7d                	bnez	a4,35e <strlen+0x14>
    ;
  return n;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  for(n = 0; s[n]; n++)
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <strlen+0x20>

0000000000000374 <memset>:

void*
memset(void *dst, int c, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 37a:	ce09                	beqz	a2,394 <memset+0x20>
 37c:	87aa                	mv	a5,a0
 37e:	fff6071b          	addiw	a4,a2,-1
 382:	1702                	slli	a4,a4,0x20
 384:	9301                	srli	a4,a4,0x20
 386:	0705                	addi	a4,a4,1
 388:	972a                	add	a4,a4,a0
    cdst[i] = c;
 38a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 38e:	0785                	addi	a5,a5,1
 390:	fee79de3          	bne	a5,a4,38a <memset+0x16>
  }
  return dst;
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <strchr>:

char*
strchr(const char *s, char c)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	cf91                	beqz	a5,3c0 <strchr+0x26>
    if(*s == c)
 3a6:	00f58a63          	beq	a1,a5,3ba <strchr+0x20>
  for(; *s; s++)
 3aa:	0505                	addi	a0,a0,1
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	c781                	beqz	a5,3b8 <strchr+0x1e>
    if(*s == c)
 3b2:	feb79ce3          	bne	a5,a1,3aa <strchr+0x10>
 3b6:	a011                	j	3ba <strchr+0x20>
      return (char*)s;
  return 0;
 3b8:	4501                	li	a0,0
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	bfe5                	j	3ba <strchr+0x20>

00000000000003c4 <gets>:

char*
gets(char *buf, int max)
{
 3c4:	711d                	addi	sp,sp,-96
 3c6:	ec86                	sd	ra,88(sp)
 3c8:	e8a2                	sd	s0,80(sp)
 3ca:	e4a6                	sd	s1,72(sp)
 3cc:	e0ca                	sd	s2,64(sp)
 3ce:	fc4e                	sd	s3,56(sp)
 3d0:	f852                	sd	s4,48(sp)
 3d2:	f456                	sd	s5,40(sp)
 3d4:	f05a                	sd	s6,32(sp)
 3d6:	ec5e                	sd	s7,24(sp)
 3d8:	1080                	addi	s0,sp,96
 3da:	8baa                	mv	s7,a0
 3dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3de:	892a                	mv	s2,a0
 3e0:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e2:	4aa9                	li	s5,10
 3e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e6:	0019849b          	addiw	s1,s3,1
 3ea:	0344d863          	ble	s4,s1,41a <gets+0x56>
    cc = read(0, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	faf40593          	addi	a1,s0,-81
 3f4:	4501                	li	a0,0
 3f6:	00000097          	auipc	ra,0x0
 3fa:	1ac080e7          	jalr	428(ra) # 5a2 <read>
    if(cc < 1)
 3fe:	00a05e63          	blez	a0,41a <gets+0x56>
    buf[i++] = c;
 402:	faf44783          	lbu	a5,-81(s0)
 406:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40a:	01578763          	beq	a5,s5,418 <gets+0x54>
 40e:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 410:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 412:	fd679ae3          	bne	a5,s6,3e6 <gets+0x22>
 416:	a011                	j	41a <gets+0x56>
  for(i=0; i+1 < max; ){
 418:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41a:	99de                	add	s3,s3,s7
 41c:	00098023          	sb	zero,0(s3)
  return buf;
}
 420:	855e                	mv	a0,s7
 422:	60e6                	ld	ra,88(sp)
 424:	6446                	ld	s0,80(sp)
 426:	64a6                	ld	s1,72(sp)
 428:	6906                	ld	s2,64(sp)
 42a:	79e2                	ld	s3,56(sp)
 42c:	7a42                	ld	s4,48(sp)
 42e:	7aa2                	ld	s5,40(sp)
 430:	7b02                	ld	s6,32(sp)
 432:	6be2                	ld	s7,24(sp)
 434:	6125                	addi	sp,sp,96
 436:	8082                	ret

0000000000000438 <stat>:

int
stat(const char *n, struct stat *st)
{
 438:	1101                	addi	sp,sp,-32
 43a:	ec06                	sd	ra,24(sp)
 43c:	e822                	sd	s0,16(sp)
 43e:	e426                	sd	s1,8(sp)
 440:	e04a                	sd	s2,0(sp)
 442:	1000                	addi	s0,sp,32
 444:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 446:	4581                	li	a1,0
 448:	00000097          	auipc	ra,0x0
 44c:	182080e7          	jalr	386(ra) # 5ca <open>
  if(fd < 0)
 450:	02054563          	bltz	a0,47a <stat+0x42>
 454:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 456:	85ca                	mv	a1,s2
 458:	00000097          	auipc	ra,0x0
 45c:	18a080e7          	jalr	394(ra) # 5e2 <fstat>
 460:	892a                	mv	s2,a0
  close(fd);
 462:	8526                	mv	a0,s1
 464:	00000097          	auipc	ra,0x0
 468:	14e080e7          	jalr	334(ra) # 5b2 <close>
  return r;
}
 46c:	854a                	mv	a0,s2
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	64a2                	ld	s1,8(sp)
 474:	6902                	ld	s2,0(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret
    return -1;
 47a:	597d                	li	s2,-1
 47c:	bfc5                	j	46c <stat+0x34>

000000000000047e <atoi>:

int
atoi(const char *s)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 484:	00054683          	lbu	a3,0(a0)
 488:	fd06879b          	addiw	a5,a3,-48
 48c:	0ff7f793          	andi	a5,a5,255
 490:	4725                	li	a4,9
 492:	02f76963          	bltu	a4,a5,4c4 <atoi+0x46>
 496:	862a                	mv	a2,a0
  n = 0;
 498:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 49a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 49c:	0605                	addi	a2,a2,1
 49e:	0025179b          	slliw	a5,a0,0x2
 4a2:	9fa9                	addw	a5,a5,a0
 4a4:	0017979b          	slliw	a5,a5,0x1
 4a8:	9fb5                	addw	a5,a5,a3
 4aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4ae:	00064683          	lbu	a3,0(a2)
 4b2:	fd06871b          	addiw	a4,a3,-48
 4b6:	0ff77713          	andi	a4,a4,255
 4ba:	fee5f1e3          	bleu	a4,a1,49c <atoi+0x1e>
  return n;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
  n = 0;
 4c4:	4501                	li	a0,0
 4c6:	bfe5                	j	4be <atoi+0x40>

00000000000004c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ce:	02b57663          	bleu	a1,a0,4fa <memmove+0x32>
    while(n-- > 0)
 4d2:	02c05163          	blez	a2,4f4 <memmove+0x2c>
 4d6:	fff6079b          	addiw	a5,a2,-1
 4da:	1782                	slli	a5,a5,0x20
 4dc:	9381                	srli	a5,a5,0x20
 4de:	0785                	addi	a5,a5,1
 4e0:	97aa                	add	a5,a5,a0
  dst = vdst;
 4e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e4:	0585                	addi	a1,a1,1
 4e6:	0705                	addi	a4,a4,1
 4e8:	fff5c683          	lbu	a3,-1(a1)
 4ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4f0:	fee79ae3          	bne	a5,a4,4e4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f4:	6422                	ld	s0,8(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret
    dst += n;
 4fa:	00c50733          	add	a4,a0,a2
    src += n;
 4fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 500:	fec05ae3          	blez	a2,4f4 <memmove+0x2c>
 504:	fff6079b          	addiw	a5,a2,-1
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	fff7c793          	not	a5,a5
 510:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 512:	15fd                	addi	a1,a1,-1
 514:	177d                	addi	a4,a4,-1
 516:	0005c683          	lbu	a3,0(a1)
 51a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 51e:	fef71ae3          	bne	a4,a5,512 <memmove+0x4a>
 522:	bfc9                	j	4f4 <memmove+0x2c>

0000000000000524 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 524:	1141                	addi	sp,sp,-16
 526:	e422                	sd	s0,8(sp)
 528:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 52a:	ce15                	beqz	a2,566 <memcmp+0x42>
 52c:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 530:	00054783          	lbu	a5,0(a0)
 534:	0005c703          	lbu	a4,0(a1)
 538:	02e79063          	bne	a5,a4,558 <memcmp+0x34>
 53c:	1682                	slli	a3,a3,0x20
 53e:	9281                	srli	a3,a3,0x20
 540:	0685                	addi	a3,a3,1
 542:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 544:	0505                	addi	a0,a0,1
    p2++;
 546:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 548:	00d50d63          	beq	a0,a3,562 <memcmp+0x3e>
    if (*p1 != *p2) {
 54c:	00054783          	lbu	a5,0(a0)
 550:	0005c703          	lbu	a4,0(a1)
 554:	fee788e3          	beq	a5,a4,544 <memcmp+0x20>
      return *p1 - *p2;
 558:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 55c:	6422                	ld	s0,8(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret
  return 0;
 562:	4501                	li	a0,0
 564:	bfe5                	j	55c <memcmp+0x38>
 566:	4501                	li	a0,0
 568:	bfd5                	j	55c <memcmp+0x38>

000000000000056a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 56a:	1141                	addi	sp,sp,-16
 56c:	e406                	sd	ra,8(sp)
 56e:	e022                	sd	s0,0(sp)
 570:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 572:	00000097          	auipc	ra,0x0
 576:	f56080e7          	jalr	-170(ra) # 4c8 <memmove>
}
 57a:	60a2                	ld	ra,8(sp)
 57c:	6402                	ld	s0,0(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret

0000000000000582 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 582:	4885                	li	a7,1
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <exit>:
.global exit
exit:
 li a7, SYS_exit
 58a:	4889                	li	a7,2
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <wait>:
.global wait
wait:
 li a7, SYS_wait
 592:	488d                	li	a7,3
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 59a:	4891                	li	a7,4
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <read>:
.global read
read:
 li a7, SYS_read
 5a2:	4895                	li	a7,5
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <write>:
.global write
write:
 li a7, SYS_write
 5aa:	48c1                	li	a7,16
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <close>:
.global close
close:
 li a7, SYS_close
 5b2:	48d5                	li	a7,21
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ba:	4899                	li	a7,6
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c2:	489d                	li	a7,7
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <open>:
.global open
open:
 li a7, SYS_open
 5ca:	48bd                	li	a7,15
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d2:	48c5                	li	a7,17
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5da:	48c9                	li	a7,18
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e2:	48a1                	li	a7,8
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <link>:
.global link
link:
 li a7, SYS_link
 5ea:	48cd                	li	a7,19
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f2:	48d1                	li	a7,20
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fa:	48a5                	li	a7,9
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <dup>:
.global dup
dup:
 li a7, SYS_dup
 602:	48a9                	li	a7,10
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60a:	48ad                	li	a7,11
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 612:	48b1                	li	a7,12
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 61a:	48b5                	li	a7,13
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 622:	48b9                	li	a7,14
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <trace>:
.global trace
trace:
 li a7, SYS_trace
 62a:	48d9                	li	a7,22
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 632:	48dd                	li	a7,23
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63a:	1101                	addi	sp,sp,-32
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 646:	4605                	li	a2,1
 648:	fef40593          	addi	a1,s0,-17
 64c:	00000097          	auipc	ra,0x0
 650:	f5e080e7          	jalr	-162(ra) # 5aa <write>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret

000000000000065c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65c:	7139                	addi	sp,sp,-64
 65e:	fc06                	sd	ra,56(sp)
 660:	f822                	sd	s0,48(sp)
 662:	f426                	sd	s1,40(sp)
 664:	f04a                	sd	s2,32(sp)
 666:	ec4e                	sd	s3,24(sp)
 668:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x14>
 66c:	0005cd63          	bltz	a1,686 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 670:	2581                	sext.w	a1,a1
  neg = 0;
 672:	4301                	li	t1,0
 674:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 678:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 67a:	2601                	sext.w	a2,a2
 67c:	00000897          	auipc	a7,0x0
 680:	4b488893          	addi	a7,a7,1204 # b30 <digits>
 684:	a801                	j	694 <printint+0x38>
    x = -xx;
 686:	40b005bb          	negw	a1,a1
 68a:	2581                	sext.w	a1,a1
    neg = 1;
 68c:	4305                	li	t1,1
    x = -xx;
 68e:	b7dd                	j	674 <printint+0x18>
  }while((x /= base) != 0);
 690:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 692:	8836                	mv	a6,a3
 694:	0018069b          	addiw	a3,a6,1
 698:	02c5f7bb          	remuw	a5,a1,a2
 69c:	1782                	slli	a5,a5,0x20
 69e:	9381                	srli	a5,a5,0x20
 6a0:	97c6                	add	a5,a5,a7
 6a2:	0007c783          	lbu	a5,0(a5)
 6a6:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 6aa:	0705                	addi	a4,a4,1
 6ac:	02c5d7bb          	divuw	a5,a1,a2
 6b0:	fec5f0e3          	bleu	a2,a1,690 <printint+0x34>
  if(neg)
 6b4:	00030b63          	beqz	t1,6ca <printint+0x6e>
    buf[i++] = '-';
 6b8:	fd040793          	addi	a5,s0,-48
 6bc:	96be                	add	a3,a3,a5
 6be:	02d00793          	li	a5,45
 6c2:	fef68823          	sb	a5,-16(a3)
 6c6:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 6ca:	02d05963          	blez	a3,6fc <printint+0xa0>
 6ce:	89aa                	mv	s3,a0
 6d0:	fc040793          	addi	a5,s0,-64
 6d4:	00d784b3          	add	s1,a5,a3
 6d8:	fff78913          	addi	s2,a5,-1
 6dc:	9936                	add	s2,s2,a3
 6de:	36fd                	addiw	a3,a3,-1
 6e0:	1682                	slli	a3,a3,0x20
 6e2:	9281                	srli	a3,a3,0x20
 6e4:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 6e8:	fff4c583          	lbu	a1,-1(s1)
 6ec:	854e                	mv	a0,s3
 6ee:	00000097          	auipc	ra,0x0
 6f2:	f4c080e7          	jalr	-180(ra) # 63a <putc>
  while(--i >= 0)
 6f6:	14fd                	addi	s1,s1,-1
 6f8:	ff2498e3          	bne	s1,s2,6e8 <printint+0x8c>
}
 6fc:	70e2                	ld	ra,56(sp)
 6fe:	7442                	ld	s0,48(sp)
 700:	74a2                	ld	s1,40(sp)
 702:	7902                	ld	s2,32(sp)
 704:	69e2                	ld	s3,24(sp)
 706:	6121                	addi	sp,sp,64
 708:	8082                	ret

000000000000070a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70a:	7119                	addi	sp,sp,-128
 70c:	fc86                	sd	ra,120(sp)
 70e:	f8a2                	sd	s0,112(sp)
 710:	f4a6                	sd	s1,104(sp)
 712:	f0ca                	sd	s2,96(sp)
 714:	ecce                	sd	s3,88(sp)
 716:	e8d2                	sd	s4,80(sp)
 718:	e4d6                	sd	s5,72(sp)
 71a:	e0da                	sd	s6,64(sp)
 71c:	fc5e                	sd	s7,56(sp)
 71e:	f862                	sd	s8,48(sp)
 720:	f466                	sd	s9,40(sp)
 722:	f06a                	sd	s10,32(sp)
 724:	ec6e                	sd	s11,24(sp)
 726:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 728:	0005c483          	lbu	s1,0(a1)
 72c:	18048d63          	beqz	s1,8c6 <vprintf+0x1bc>
 730:	8aaa                	mv	s5,a0
 732:	8b32                	mv	s6,a2
 734:	00158913          	addi	s2,a1,1
  state = 0;
 738:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 73a:	02500a13          	li	s4,37
      if(c == 'd'){
 73e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 742:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 746:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 74a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74e:	00000b97          	auipc	s7,0x0
 752:	3e2b8b93          	addi	s7,s7,994 # b30 <digits>
 756:	a839                	j	774 <vprintf+0x6a>
        putc(fd, c);
 758:	85a6                	mv	a1,s1
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	ede080e7          	jalr	-290(ra) # 63a <putc>
 764:	a019                	j	76a <vprintf+0x60>
    } else if(state == '%'){
 766:	01498f63          	beq	s3,s4,784 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 76a:	0905                	addi	s2,s2,1
 76c:	fff94483          	lbu	s1,-1(s2)
 770:	14048b63          	beqz	s1,8c6 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 774:	0004879b          	sext.w	a5,s1
    if(state == 0){
 778:	fe0997e3          	bnez	s3,766 <vprintf+0x5c>
      if(c == '%'){
 77c:	fd479ee3          	bne	a5,s4,758 <vprintf+0x4e>
        state = '%';
 780:	89be                	mv	s3,a5
 782:	b7e5                	j	76a <vprintf+0x60>
      if(c == 'd'){
 784:	05878063          	beq	a5,s8,7c4 <vprintf+0xba>
      } else if(c == 'l') {
 788:	05978c63          	beq	a5,s9,7e0 <vprintf+0xd6>
      } else if(c == 'x') {
 78c:	07a78863          	beq	a5,s10,7fc <vprintf+0xf2>
      } else if(c == 'p') {
 790:	09b78463          	beq	a5,s11,818 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 794:	07300713          	li	a4,115
 798:	0ce78563          	beq	a5,a4,862 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79c:	06300713          	li	a4,99
 7a0:	0ee78c63          	beq	a5,a4,898 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7a4:	11478663          	beq	a5,s4,8b0 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a8:	85d2                	mv	a1,s4
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e8e080e7          	jalr	-370(ra) # 63a <putc>
        putc(fd, c);
 7b4:	85a6                	mv	a1,s1
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e82080e7          	jalr	-382(ra) # 63a <putc>
      }
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b765                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7c4:	008b0493          	addi	s1,s6,8
 7c8:	4685                	li	a3,1
 7ca:	4629                	li	a2,10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e8a080e7          	jalr	-374(ra) # 65c <printint>
 7da:	8b26                	mv	s6,s1
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b771                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	008b0493          	addi	s1,s6,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e6e080e7          	jalr	-402(ra) # 65c <printint>
 7f6:	8b26                	mv	s6,s1
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf85                	j	76a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7fc:	008b0493          	addi	s1,s6,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000b2583          	lw	a1,0(s6)
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	e52080e7          	jalr	-430(ra) # 65c <printint>
 812:	8b26                	mv	s6,s1
      state = 0;
 814:	4981                	li	s3,0
 816:	bf91                	j	76a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 818:	008b0793          	addi	a5,s6,8
 81c:	f8f43423          	sd	a5,-120(s0)
 820:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 824:	03000593          	li	a1,48
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	e10080e7          	jalr	-496(ra) # 63a <putc>
  putc(fd, 'x');
 832:	85ea                	mv	a1,s10
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	e04080e7          	jalr	-508(ra) # 63a <putc>
 83e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	dee080e7          	jalr	-530(ra) # 63a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 854:	0992                	slli	s3,s3,0x4
 856:	34fd                	addiw	s1,s1,-1
 858:	f4e5                	bnez	s1,840 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 85a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85e:	4981                	li	s3,0
 860:	b729                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 862:	008b0993          	addi	s3,s6,8
 866:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 86a:	c085                	beqz	s1,88a <vprintf+0x180>
        while(*s != 0){
 86c:	0004c583          	lbu	a1,0(s1)
 870:	c9a1                	beqz	a1,8c0 <vprintf+0x1b6>
          putc(fd, *s);
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	dc6080e7          	jalr	-570(ra) # 63a <putc>
          s++;
 87c:	0485                	addi	s1,s1,1
        while(*s != 0){
 87e:	0004c583          	lbu	a1,0(s1)
 882:	f9e5                	bnez	a1,872 <vprintf+0x168>
        s = va_arg(ap, char*);
 884:	8b4e                	mv	s6,s3
      state = 0;
 886:	4981                	li	s3,0
 888:	b5cd                	j	76a <vprintf+0x60>
          s = "(null)";
 88a:	00000497          	auipc	s1,0x0
 88e:	2be48493          	addi	s1,s1,702 # b48 <digits+0x18>
        while(*s != 0){
 892:	02800593          	li	a1,40
 896:	bff1                	j	872 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 898:	008b0493          	addi	s1,s6,8
 89c:	000b4583          	lbu	a1,0(s6)
 8a0:	8556                	mv	a0,s5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	d98080e7          	jalr	-616(ra) # 63a <putc>
 8aa:	8b26                	mv	s6,s1
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bd75                	j	76a <vprintf+0x60>
        putc(fd, c);
 8b0:	85d2                	mv	a1,s4
 8b2:	8556                	mv	a0,s5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	d86080e7          	jalr	-634(ra) # 63a <putc>
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	b575                	j	76a <vprintf+0x60>
        s = va_arg(ap, char*);
 8c0:	8b4e                	mv	s6,s3
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b55d                	j	76a <vprintf+0x60>
    }
  }
}
 8c6:	70e6                	ld	ra,120(sp)
 8c8:	7446                	ld	s0,112(sp)
 8ca:	74a6                	ld	s1,104(sp)
 8cc:	7906                	ld	s2,96(sp)
 8ce:	69e6                	ld	s3,88(sp)
 8d0:	6a46                	ld	s4,80(sp)
 8d2:	6aa6                	ld	s5,72(sp)
 8d4:	6b06                	ld	s6,64(sp)
 8d6:	7be2                	ld	s7,56(sp)
 8d8:	7c42                	ld	s8,48(sp)
 8da:	7ca2                	ld	s9,40(sp)
 8dc:	7d02                	ld	s10,32(sp)
 8de:	6de2                	ld	s11,24(sp)
 8e0:	6109                	addi	sp,sp,128
 8e2:	8082                	ret

00000000000008e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e4:	715d                	addi	sp,sp,-80
 8e6:	ec06                	sd	ra,24(sp)
 8e8:	e822                	sd	s0,16(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	e010                	sd	a2,0(s0)
 8ee:	e414                	sd	a3,8(s0)
 8f0:	e818                	sd	a4,16(s0)
 8f2:	ec1c                	sd	a5,24(s0)
 8f4:	03043023          	sd	a6,32(s0)
 8f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 900:	8622                	mv	a2,s0
 902:	00000097          	auipc	ra,0x0
 906:	e08080e7          	jalr	-504(ra) # 70a <vprintf>
}
 90a:	60e2                	ld	ra,24(sp)
 90c:	6442                	ld	s0,16(sp)
 90e:	6161                	addi	sp,sp,80
 910:	8082                	ret

0000000000000912 <printf>:

void
printf(const char *fmt, ...)
{
 912:	711d                	addi	sp,sp,-96
 914:	ec06                	sd	ra,24(sp)
 916:	e822                	sd	s0,16(sp)
 918:	1000                	addi	s0,sp,32
 91a:	e40c                	sd	a1,8(s0)
 91c:	e810                	sd	a2,16(s0)
 91e:	ec14                	sd	a3,24(s0)
 920:	f018                	sd	a4,32(s0)
 922:	f41c                	sd	a5,40(s0)
 924:	03043823          	sd	a6,48(s0)
 928:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92c:	00840613          	addi	a2,s0,8
 930:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 934:	85aa                	mv	a1,a0
 936:	4505                	li	a0,1
 938:	00000097          	auipc	ra,0x0
 93c:	dd2080e7          	jalr	-558(ra) # 70a <vprintf>
}
 940:	60e2                	ld	ra,24(sp)
 942:	6442                	ld	s0,16(sp)
 944:	6125                	addi	sp,sp,96
 946:	8082                	ret

0000000000000948 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 948:	1141                	addi	sp,sp,-16
 94a:	e422                	sd	s0,8(sp)
 94c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	00000797          	auipc	a5,0x0
 956:	6ae78793          	addi	a5,a5,1710 # 1000 <freep>
 95a:	639c                	ld	a5,0(a5)
 95c:	a805                	j	98c <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95e:	4618                	lw	a4,8(a2)
 960:	9db9                	addw	a1,a1,a4
 962:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	6318                	ld	a4,0(a4)
 96a:	fee53823          	sd	a4,-16(a0)
 96e:	a091                	j	9b2 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 970:	ff852703          	lw	a4,-8(a0)
 974:	9e39                	addw	a2,a2,a4
 976:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 978:	ff053703          	ld	a4,-16(a0)
 97c:	e398                	sd	a4,0(a5)
 97e:	a099                	j	9c4 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	6398                	ld	a4,0(a5)
 982:	00e7e463          	bltu	a5,a4,98a <free+0x42>
 986:	00e6ea63          	bltu	a3,a4,99a <free+0x52>
{
 98a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	fed7fae3          	bleu	a3,a5,980 <free+0x38>
 990:	6398                	ld	a4,0(a5)
 992:	00e6e463          	bltu	a3,a4,99a <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	fee7eae3          	bltu	a5,a4,98a <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 99a:	ff852583          	lw	a1,-8(a0)
 99e:	6390                	ld	a2,0(a5)
 9a0:	02059713          	slli	a4,a1,0x20
 9a4:	9301                	srli	a4,a4,0x20
 9a6:	0712                	slli	a4,a4,0x4
 9a8:	9736                	add	a4,a4,a3
 9aa:	fae60ae3          	beq	a2,a4,95e <free+0x16>
    bp->s.ptr = p->s.ptr;
 9ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b2:	4790                	lw	a2,8(a5)
 9b4:	02061713          	slli	a4,a2,0x20
 9b8:	9301                	srli	a4,a4,0x20
 9ba:	0712                	slli	a4,a4,0x4
 9bc:	973e                	add	a4,a4,a5
 9be:	fae689e3          	beq	a3,a4,970 <free+0x28>
  } else
    p->s.ptr = bp;
 9c2:	e394                	sd	a3,0(a5)
  freep = p;
 9c4:	00000717          	auipc	a4,0x0
 9c8:	62f73e23          	sd	a5,1596(a4) # 1000 <freep>
}
 9cc:	6422                	ld	s0,8(sp)
 9ce:	0141                	addi	sp,sp,16
 9d0:	8082                	ret

00000000000009d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d2:	7139                	addi	sp,sp,-64
 9d4:	fc06                	sd	ra,56(sp)
 9d6:	f822                	sd	s0,48(sp)
 9d8:	f426                	sd	s1,40(sp)
 9da:	f04a                	sd	s2,32(sp)
 9dc:	ec4e                	sd	s3,24(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
 9e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e6:	02051993          	slli	s3,a0,0x20
 9ea:	0209d993          	srli	s3,s3,0x20
 9ee:	09bd                	addi	s3,s3,15
 9f0:	0049d993          	srli	s3,s3,0x4
 9f4:	2985                	addiw	s3,s3,1
 9f6:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 9fa:	00000797          	auipc	a5,0x0
 9fe:	60678793          	addi	a5,a5,1542 # 1000 <freep>
 a02:	6388                	ld	a0,0(a5)
 a04:	c515                	beqz	a0,a30 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a08:	4798                	lw	a4,8(a5)
 a0a:	03277f63          	bleu	s2,a4,a48 <malloc+0x76>
 a0e:	8a4e                	mv	s4,s3
 a10:	0009871b          	sext.w	a4,s3
 a14:	6685                	lui	a3,0x1
 a16:	00d77363          	bleu	a3,a4,a1c <malloc+0x4a>
 a1a:	6a05                	lui	s4,0x1
 a1c:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 a20:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a24:	00000497          	auipc	s1,0x0
 a28:	5dc48493          	addi	s1,s1,1500 # 1000 <freep>
  if(p == (char*)-1)
 a2c:	5b7d                	li	s6,-1
 a2e:	a885                	j	a9e <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 a30:	00000797          	auipc	a5,0x0
 a34:	5f078793          	addi	a5,a5,1520 # 1020 <base>
 a38:	00000717          	auipc	a4,0x0
 a3c:	5cf73423          	sd	a5,1480(a4) # 1000 <freep>
 a40:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a42:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a46:	b7e1                	j	a0e <malloc+0x3c>
      if(p->s.size == nunits)
 a48:	02e90b63          	beq	s2,a4,a7e <malloc+0xac>
        p->s.size -= nunits;
 a4c:	4137073b          	subw	a4,a4,s3
 a50:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a52:	1702                	slli	a4,a4,0x20
 a54:	9301                	srli	a4,a4,0x20
 a56:	0712                	slli	a4,a4,0x4
 a58:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a5a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5e:	00000717          	auipc	a4,0x0
 a62:	5aa73123          	sd	a0,1442(a4) # 1000 <freep>
      return (void*)(p + 1);
 a66:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a6a:	70e2                	ld	ra,56(sp)
 a6c:	7442                	ld	s0,48(sp)
 a6e:	74a2                	ld	s1,40(sp)
 a70:	7902                	ld	s2,32(sp)
 a72:	69e2                	ld	s3,24(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	6121                	addi	sp,sp,64
 a7c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a7e:	6398                	ld	a4,0(a5)
 a80:	e118                	sd	a4,0(a0)
 a82:	bff1                	j	a5e <malloc+0x8c>
  hp->s.size = nu;
 a84:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a88:	0541                	addi	a0,a0,16
 a8a:	00000097          	auipc	ra,0x0
 a8e:	ebe080e7          	jalr	-322(ra) # 948 <free>
  return freep;
 a92:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a94:	d979                	beqz	a0,a6a <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a98:	4798                	lw	a4,8(a5)
 a9a:	fb2777e3          	bleu	s2,a4,a48 <malloc+0x76>
    if(p == freep)
 a9e:	6098                	ld	a4,0(s1)
 aa0:	853e                	mv	a0,a5
 aa2:	fef71ae3          	bne	a4,a5,a96 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 aa6:	8552                	mv	a0,s4
 aa8:	00000097          	auipc	ra,0x0
 aac:	b6a080e7          	jalr	-1174(ra) # 612 <sbrk>
  if(p == (char*)-1)
 ab0:	fd651ae3          	bne	a0,s6,a84 <malloc+0xb2>
        return 0;
 ab4:	4501                	li	a0,0
 ab6:	bf55                	j	a6a <malloc+0x98>
