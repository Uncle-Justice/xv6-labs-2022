
user/_grind：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	eba080e7          	jalr	-326(ra) # f4a <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	35650513          	addi	a0,a0,854 # 13f0 <malloc+0xe6>
      a2:	00001097          	auipc	ra,0x1
      a6:	e88080e7          	jalr	-376(ra) # f2a <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	34650513          	addi	a0,a0,838 # 13f0 <malloc+0xe6>
      b2:	00001097          	auipc	ra,0x1
      b6:	e80080e7          	jalr	-384(ra) # f32 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	33c50513          	addi	a0,a0,828 # 13f8 <malloc+0xee>
      c4:	00001097          	auipc	ra,0x1
      c8:	186080e7          	jalr	390(ra) # 124a <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	df4080e7          	jalr	-524(ra) # ec2 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	34250513          	addi	a0,a0,834 # 1418 <malloc+0x10e>
      de:	00001097          	auipc	ra,0x1
      e2:	e54080e7          	jalr	-428(ra) # f32 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001917          	auipc	s2,0x1
      ea:	34290913          	addi	s2,s2,834 # 1428 <malloc+0x11e>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001917          	auipc	s2,0x1
      f4:	33090913          	addi	s2,s2,816 # 1420 <malloc+0x116>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	59fd                	li	s3,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00002a17          	auipc	s4,0x2
     100:	f24a0a13          	addi	s4,s4,-220 # 2020 <buf.1258>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	32650513          	addi	a0,a0,806 # 1430 <malloc+0x126>
     112:	00001097          	auipc	ra,0x1
     116:	df0080e7          	jalr	-528(ra) # f02 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	dd0080e7          	jalr	-560(ra) # eea <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ca                	mv	a1,s2
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	dae080e7          	jalr	-594(ra) # ee2 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50b63          	beq	a0,a5,2e8 <go+0x270>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50763          	beq	a0,a5,306 <go+0x28e>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50d63          	beq	a0,a5,318 <go+0x2a0>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	20f50163          	beq	a0,a5,366 <go+0x2ee>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50f63          	beq	a0,a5,388 <go+0x310>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50d63          	beq	a0,a5,3aa <go+0x332>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	24f50363          	beq	a0,a5,3bc <go+0x344>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50963          	beq	a0,a5,3ce <go+0x356>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	28f50563          	beq	a0,a5,40c <go+0x394>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2cf50163          	beq	a0,a5,44a <go+0x3d2>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2ef50363          	beq	a0,a5,474 <go+0x3fc>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	30f50563          	beq	a0,a5,49e <go+0x426>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	34f50063          	beq	a0,a5,4da <go+0x462>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	38f50463          	beq	a0,a5,528 <go+0x4b0>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50963          	beq	a0,a5,538 <go+0x4c0>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50963          	beq	a0,a5,55e <go+0x4e6>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50f63          	beq	a0,a5,5f0 <go+0x578>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	48f50363          	beq	a0,a5,63e <go+0x5c6>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	56f50463          	beq	a0,a5,726 <go+0x6ae>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	60f50263          	beq	a0,a5,7c8 <go+0x750>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	d00080e7          	jalr	-768(ra) # ed2 <pipe>
     1da:	6e054b63          	bltz	a0,8d0 <go+0x858>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	cf0080e7          	jalr	-784(ra) # ed2 <pipe>
     1ea:	70054163          	bltz	a0,8ec <go+0x874>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	ccc080e7          	jalr	-820(ra) # eba <fork>
      if(pid1 == 0){
     1f6:	70050963          	beqz	a0,908 <go+0x890>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7c054163          	bltz	a0,9bc <go+0x944>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	cbc080e7          	jalr	-836(ra) # eba <fork>
      if(pid2 == 0){
     206:	7c050963          	beqz	a0,9d8 <go+0x960>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	0a0545e3          	bltz	a0,ab4 <go+0xa3c>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	cd8080e7          	jalr	-808(ra) # eea <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	ccc080e7          	jalr	-820(ra) # eea <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	cc0080e7          	jalr	-832(ra) # eea <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8040823          	sb	zero,-112(s0)
     236:	f80408a3          	sb	zero,-111(s0)
     23a:	f8040923          	sb	zero,-110(s0)
     23e:	f80409a3          	sb	zero,-109(s0)
      read(bb[0], buf+0, 1);
     242:	4605                	li	a2,1
     244:	f9040593          	addi	a1,s0,-112
     248:	fa042503          	lw	a0,-96(s0)
     24c:	00001097          	auipc	ra,0x1
     250:	c8e080e7          	jalr	-882(ra) # eda <read>
      read(bb[0], buf+1, 1);
     254:	4605                	li	a2,1
     256:	f9140593          	addi	a1,s0,-111
     25a:	fa042503          	lw	a0,-96(s0)
     25e:	00001097          	auipc	ra,0x1
     262:	c7c080e7          	jalr	-900(ra) # eda <read>
      read(bb[0], buf+2, 1);
     266:	4605                	li	a2,1
     268:	f9240593          	addi	a1,s0,-110
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	c6a080e7          	jalr	-918(ra) # eda <read>
      close(bb[0]);
     278:	fa042503          	lw	a0,-96(s0)
     27c:	00001097          	auipc	ra,0x1
     280:	c6e080e7          	jalr	-914(ra) # eea <close>
      int st1, st2;
      wait(&st1);
     284:	f9440513          	addi	a0,s0,-108
     288:	00001097          	auipc	ra,0x1
     28c:	c42080e7          	jalr	-958(ra) # eca <wait>
      wait(&st2);
     290:	fa840513          	addi	a0,s0,-88
     294:	00001097          	auipc	ra,0x1
     298:	c36080e7          	jalr	-970(ra) # eca <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     29c:	f9442783          	lw	a5,-108(s0)
     2a0:	fa842703          	lw	a4,-88(s0)
     2a4:	8fd9                	or	a5,a5,a4
     2a6:	2781                	sext.w	a5,a5
     2a8:	ef89                	bnez	a5,2c2 <go+0x24a>
     2aa:	00001597          	auipc	a1,0x1
     2ae:	3fe58593          	addi	a1,a1,1022 # 16a8 <malloc+0x39e>
     2b2:	f9040513          	addi	a0,s0,-112
     2b6:	00001097          	auipc	ra,0x1
     2ba:	998080e7          	jalr	-1640(ra) # c4e <strcmp>
     2be:	e60502e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2c2:	f9040693          	addi	a3,s0,-112
     2c6:	fa842603          	lw	a2,-88(s0)
     2ca:	f9442583          	lw	a1,-108(s0)
     2ce:	00001517          	auipc	a0,0x1
     2d2:	3e250513          	addi	a0,a0,994 # 16b0 <malloc+0x3a6>
     2d6:	00001097          	auipc	ra,0x1
     2da:	f74080e7          	jalr	-140(ra) # 124a <printf>
        exit(1);
     2de:	4505                	li	a0,1
     2e0:	00001097          	auipc	ra,0x1
     2e4:	be2080e7          	jalr	-1054(ra) # ec2 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2e8:	20200593          	li	a1,514
     2ec:	00001517          	auipc	a0,0x1
     2f0:	15450513          	addi	a0,a0,340 # 1440 <malloc+0x136>
     2f4:	00001097          	auipc	ra,0x1
     2f8:	c0e080e7          	jalr	-1010(ra) # f02 <open>
     2fc:	00001097          	auipc	ra,0x1
     300:	bee080e7          	jalr	-1042(ra) # eea <close>
     304:	bd39                	j	122 <go+0xaa>
      unlink("grindir/../a");
     306:	00001517          	auipc	a0,0x1
     30a:	12a50513          	addi	a0,a0,298 # 1430 <malloc+0x126>
     30e:	00001097          	auipc	ra,0x1
     312:	c04080e7          	jalr	-1020(ra) # f12 <unlink>
     316:	b531                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     318:	00001517          	auipc	a0,0x1
     31c:	0d850513          	addi	a0,a0,216 # 13f0 <malloc+0xe6>
     320:	00001097          	auipc	ra,0x1
     324:	c12080e7          	jalr	-1006(ra) # f32 <chdir>
     328:	e115                	bnez	a0,34c <go+0x2d4>
      unlink("../b");
     32a:	00001517          	auipc	a0,0x1
     32e:	12e50513          	addi	a0,a0,302 # 1458 <malloc+0x14e>
     332:	00001097          	auipc	ra,0x1
     336:	be0080e7          	jalr	-1056(ra) # f12 <unlink>
      chdir("/");
     33a:	00001517          	auipc	a0,0x1
     33e:	0de50513          	addi	a0,a0,222 # 1418 <malloc+0x10e>
     342:	00001097          	auipc	ra,0x1
     346:	bf0080e7          	jalr	-1040(ra) # f32 <chdir>
     34a:	bbe1                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     34c:	00001517          	auipc	a0,0x1
     350:	0ac50513          	addi	a0,a0,172 # 13f8 <malloc+0xee>
     354:	00001097          	auipc	ra,0x1
     358:	ef6080e7          	jalr	-266(ra) # 124a <printf>
        exit(1);
     35c:	4505                	li	a0,1
     35e:	00001097          	auipc	ra,0x1
     362:	b64080e7          	jalr	-1180(ra) # ec2 <exit>
      close(fd);
     366:	854e                	mv	a0,s3
     368:	00001097          	auipc	ra,0x1
     36c:	b82080e7          	jalr	-1150(ra) # eea <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     370:	20200593          	li	a1,514
     374:	00001517          	auipc	a0,0x1
     378:	0ec50513          	addi	a0,a0,236 # 1460 <malloc+0x156>
     37c:	00001097          	auipc	ra,0x1
     380:	b86080e7          	jalr	-1146(ra) # f02 <open>
     384:	89aa                	mv	s3,a0
     386:	bb71                	j	122 <go+0xaa>
      close(fd);
     388:	854e                	mv	a0,s3
     38a:	00001097          	auipc	ra,0x1
     38e:	b60080e7          	jalr	-1184(ra) # eea <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     392:	20200593          	li	a1,514
     396:	00001517          	auipc	a0,0x1
     39a:	0da50513          	addi	a0,a0,218 # 1470 <malloc+0x166>
     39e:	00001097          	auipc	ra,0x1
     3a2:	b64080e7          	jalr	-1180(ra) # f02 <open>
     3a6:	89aa                	mv	s3,a0
     3a8:	bbad                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     3aa:	3e700613          	li	a2,999
     3ae:	85d2                	mv	a1,s4
     3b0:	854e                	mv	a0,s3
     3b2:	00001097          	auipc	ra,0x1
     3b6:	b30080e7          	jalr	-1232(ra) # ee2 <write>
     3ba:	b3a5                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3bc:	3e700613          	li	a2,999
     3c0:	85d2                	mv	a1,s4
     3c2:	854e                	mv	a0,s3
     3c4:	00001097          	auipc	ra,0x1
     3c8:	b16080e7          	jalr	-1258(ra) # eda <read>
     3cc:	bb99                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3ce:	00001517          	auipc	a0,0x1
     3d2:	06250513          	addi	a0,a0,98 # 1430 <malloc+0x126>
     3d6:	00001097          	auipc	ra,0x1
     3da:	b54080e7          	jalr	-1196(ra) # f2a <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	0a650513          	addi	a0,a0,166 # 1488 <malloc+0x17e>
     3ea:	00001097          	auipc	ra,0x1
     3ee:	b18080e7          	jalr	-1256(ra) # f02 <open>
     3f2:	00001097          	auipc	ra,0x1
     3f6:	af8080e7          	jalr	-1288(ra) # eea <close>
      unlink("a/a");
     3fa:	00001517          	auipc	a0,0x1
     3fe:	09e50513          	addi	a0,a0,158 # 1498 <malloc+0x18e>
     402:	00001097          	auipc	ra,0x1
     406:	b10080e7          	jalr	-1264(ra) # f12 <unlink>
     40a:	bb21                	j	122 <go+0xaa>
      mkdir("/../b");
     40c:	00001517          	auipc	a0,0x1
     410:	09450513          	addi	a0,a0,148 # 14a0 <malloc+0x196>
     414:	00001097          	auipc	ra,0x1
     418:	b16080e7          	jalr	-1258(ra) # f2a <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     41c:	20200593          	li	a1,514
     420:	00001517          	auipc	a0,0x1
     424:	08850513          	addi	a0,a0,136 # 14a8 <malloc+0x19e>
     428:	00001097          	auipc	ra,0x1
     42c:	ada080e7          	jalr	-1318(ra) # f02 <open>
     430:	00001097          	auipc	ra,0x1
     434:	aba080e7          	jalr	-1350(ra) # eea <close>
      unlink("b/b");
     438:	00001517          	auipc	a0,0x1
     43c:	08050513          	addi	a0,a0,128 # 14b8 <malloc+0x1ae>
     440:	00001097          	auipc	ra,0x1
     444:	ad2080e7          	jalr	-1326(ra) # f12 <unlink>
     448:	b9e9                	j	122 <go+0xaa>
      unlink("b");
     44a:	00001517          	auipc	a0,0x1
     44e:	03650513          	addi	a0,a0,54 # 1480 <malloc+0x176>
     452:	00001097          	auipc	ra,0x1
     456:	ac0080e7          	jalr	-1344(ra) # f12 <unlink>
      link("../grindir/./../a", "../b");
     45a:	00001597          	auipc	a1,0x1
     45e:	ffe58593          	addi	a1,a1,-2 # 1458 <malloc+0x14e>
     462:	00001517          	auipc	a0,0x1
     466:	05e50513          	addi	a0,a0,94 # 14c0 <malloc+0x1b6>
     46a:	00001097          	auipc	ra,0x1
     46e:	ab8080e7          	jalr	-1352(ra) # f22 <link>
     472:	b945                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     474:	00001517          	auipc	a0,0x1
     478:	06450513          	addi	a0,a0,100 # 14d8 <malloc+0x1ce>
     47c:	00001097          	auipc	ra,0x1
     480:	a96080e7          	jalr	-1386(ra) # f12 <unlink>
      link(".././b", "/grindir/../a");
     484:	00001597          	auipc	a1,0x1
     488:	fdc58593          	addi	a1,a1,-36 # 1460 <malloc+0x156>
     48c:	00001517          	auipc	a0,0x1
     490:	05c50513          	addi	a0,a0,92 # 14e8 <malloc+0x1de>
     494:	00001097          	auipc	ra,0x1
     498:	a8e080e7          	jalr	-1394(ra) # f22 <link>
     49c:	b159                	j	122 <go+0xaa>
      int pid = fork();
     49e:	00001097          	auipc	ra,0x1
     4a2:	a1c080e7          	jalr	-1508(ra) # eba <fork>
      if(pid == 0){
     4a6:	c909                	beqz	a0,4b8 <go+0x440>
      } else if(pid < 0){
     4a8:	00054c63          	bltz	a0,4c0 <go+0x448>
      wait(0);
     4ac:	4501                	li	a0,0
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a1c080e7          	jalr	-1508(ra) # eca <wait>
     4b6:	b1b5                	j	122 <go+0xaa>
        exit(0);
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a0a080e7          	jalr	-1526(ra) # ec2 <exit>
        printf("grind: fork failed\n");
     4c0:	00001517          	auipc	a0,0x1
     4c4:	03050513          	addi	a0,a0,48 # 14f0 <malloc+0x1e6>
     4c8:	00001097          	auipc	ra,0x1
     4cc:	d82080e7          	jalr	-638(ra) # 124a <printf>
        exit(1);
     4d0:	4505                	li	a0,1
     4d2:	00001097          	auipc	ra,0x1
     4d6:	9f0080e7          	jalr	-1552(ra) # ec2 <exit>
      int pid = fork();
     4da:	00001097          	auipc	ra,0x1
     4de:	9e0080e7          	jalr	-1568(ra) # eba <fork>
      if(pid == 0){
     4e2:	c909                	beqz	a0,4f4 <go+0x47c>
      } else if(pid < 0){
     4e4:	02054563          	bltz	a0,50e <go+0x496>
      wait(0);
     4e8:	4501                	li	a0,0
     4ea:	00001097          	auipc	ra,0x1
     4ee:	9e0080e7          	jalr	-1568(ra) # eca <wait>
     4f2:	b905                	j	122 <go+0xaa>
        fork();
     4f4:	00001097          	auipc	ra,0x1
     4f8:	9c6080e7          	jalr	-1594(ra) # eba <fork>
        fork();
     4fc:	00001097          	auipc	ra,0x1
     500:	9be080e7          	jalr	-1602(ra) # eba <fork>
        exit(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	9bc080e7          	jalr	-1604(ra) # ec2 <exit>
        printf("grind: fork failed\n");
     50e:	00001517          	auipc	a0,0x1
     512:	fe250513          	addi	a0,a0,-30 # 14f0 <malloc+0x1e6>
     516:	00001097          	auipc	ra,0x1
     51a:	d34080e7          	jalr	-716(ra) # 124a <printf>
        exit(1);
     51e:	4505                	li	a0,1
     520:	00001097          	auipc	ra,0x1
     524:	9a2080e7          	jalr	-1630(ra) # ec2 <exit>
      sbrk(6011);
     528:	6505                	lui	a0,0x1
     52a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0xa3>
     52e:	00001097          	auipc	ra,0x1
     532:	a1c080e7          	jalr	-1508(ra) # f4a <sbrk>
     536:	b6f5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     538:	4501                	li	a0,0
     53a:	00001097          	auipc	ra,0x1
     53e:	a10080e7          	jalr	-1520(ra) # f4a <sbrk>
     542:	beaaf0e3          	bleu	a0,s5,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	a02080e7          	jalr	-1534(ra) # f4a <sbrk>
     550:	40aa853b          	subw	a0,s5,a0
     554:	00001097          	auipc	ra,0x1
     558:	9f6080e7          	jalr	-1546(ra) # f4a <sbrk>
     55c:	b6d9                	j	122 <go+0xaa>
      int pid = fork();
     55e:	00001097          	auipc	ra,0x1
     562:	95c080e7          	jalr	-1700(ra) # eba <fork>
     566:	8b2a                	mv	s6,a0
      if(pid == 0){
     568:	c51d                	beqz	a0,596 <go+0x51e>
      } else if(pid < 0){
     56a:	04054963          	bltz	a0,5bc <go+0x544>
      if(chdir("../grindir/..") != 0){
     56e:	00001517          	auipc	a0,0x1
     572:	f9a50513          	addi	a0,a0,-102 # 1508 <malloc+0x1fe>
     576:	00001097          	auipc	ra,0x1
     57a:	9bc080e7          	jalr	-1604(ra) # f32 <chdir>
     57e:	ed21                	bnez	a0,5d6 <go+0x55e>
      kill(pid);
     580:	855a                	mv	a0,s6
     582:	00001097          	auipc	ra,0x1
     586:	970080e7          	jalr	-1680(ra) # ef2 <kill>
      wait(0);
     58a:	4501                	li	a0,0
     58c:	00001097          	auipc	ra,0x1
     590:	93e080e7          	jalr	-1730(ra) # eca <wait>
     594:	b679                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     596:	20200593          	li	a1,514
     59a:	00001517          	auipc	a0,0x1
     59e:	f3650513          	addi	a0,a0,-202 # 14d0 <malloc+0x1c6>
     5a2:	00001097          	auipc	ra,0x1
     5a6:	960080e7          	jalr	-1696(ra) # f02 <open>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	940080e7          	jalr	-1728(ra) # eea <close>
        exit(0);
     5b2:	4501                	li	a0,0
     5b4:	00001097          	auipc	ra,0x1
     5b8:	90e080e7          	jalr	-1778(ra) # ec2 <exit>
        printf("grind: fork failed\n");
     5bc:	00001517          	auipc	a0,0x1
     5c0:	f3450513          	addi	a0,a0,-204 # 14f0 <malloc+0x1e6>
     5c4:	00001097          	auipc	ra,0x1
     5c8:	c86080e7          	jalr	-890(ra) # 124a <printf>
        exit(1);
     5cc:	4505                	li	a0,1
     5ce:	00001097          	auipc	ra,0x1
     5d2:	8f4080e7          	jalr	-1804(ra) # ec2 <exit>
        printf("grind: chdir failed\n");
     5d6:	00001517          	auipc	a0,0x1
     5da:	f4250513          	addi	a0,a0,-190 # 1518 <malloc+0x20e>
     5de:	00001097          	auipc	ra,0x1
     5e2:	c6c080e7          	jalr	-916(ra) # 124a <printf>
        exit(1);
     5e6:	4505                	li	a0,1
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8da080e7          	jalr	-1830(ra) # ec2 <exit>
      int pid = fork();
     5f0:	00001097          	auipc	ra,0x1
     5f4:	8ca080e7          	jalr	-1846(ra) # eba <fork>
      if(pid == 0){
     5f8:	c909                	beqz	a0,60a <go+0x592>
      } else if(pid < 0){
     5fa:	02054563          	bltz	a0,624 <go+0x5ac>
      wait(0);
     5fe:	4501                	li	a0,0
     600:	00001097          	auipc	ra,0x1
     604:	8ca080e7          	jalr	-1846(ra) # eca <wait>
     608:	be29                	j	122 <go+0xaa>
        kill(getpid());
     60a:	00001097          	auipc	ra,0x1
     60e:	938080e7          	jalr	-1736(ra) # f42 <getpid>
     612:	00001097          	auipc	ra,0x1
     616:	8e0080e7          	jalr	-1824(ra) # ef2 <kill>
        exit(0);
     61a:	4501                	li	a0,0
     61c:	00001097          	auipc	ra,0x1
     620:	8a6080e7          	jalr	-1882(ra) # ec2 <exit>
        printf("grind: fork failed\n");
     624:	00001517          	auipc	a0,0x1
     628:	ecc50513          	addi	a0,a0,-308 # 14f0 <malloc+0x1e6>
     62c:	00001097          	auipc	ra,0x1
     630:	c1e080e7          	jalr	-994(ra) # 124a <printf>
        exit(1);
     634:	4505                	li	a0,1
     636:	00001097          	auipc	ra,0x1
     63a:	88c080e7          	jalr	-1908(ra) # ec2 <exit>
      if(pipe(fds) < 0){
     63e:	fa840513          	addi	a0,s0,-88
     642:	00001097          	auipc	ra,0x1
     646:	890080e7          	jalr	-1904(ra) # ed2 <pipe>
     64a:	02054b63          	bltz	a0,680 <go+0x608>
      int pid = fork();
     64e:	00001097          	auipc	ra,0x1
     652:	86c080e7          	jalr	-1940(ra) # eba <fork>
      if(pid == 0){
     656:	c131                	beqz	a0,69a <go+0x622>
      } else if(pid < 0){
     658:	0a054a63          	bltz	a0,70c <go+0x694>
      close(fds[0]);
     65c:	fa842503          	lw	a0,-88(s0)
     660:	00001097          	auipc	ra,0x1
     664:	88a080e7          	jalr	-1910(ra) # eea <close>
      close(fds[1]);
     668:	fac42503          	lw	a0,-84(s0)
     66c:	00001097          	auipc	ra,0x1
     670:	87e080e7          	jalr	-1922(ra) # eea <close>
      wait(0);
     674:	4501                	li	a0,0
     676:	00001097          	auipc	ra,0x1
     67a:	854080e7          	jalr	-1964(ra) # eca <wait>
     67e:	b455                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     680:	00001517          	auipc	a0,0x1
     684:	eb050513          	addi	a0,a0,-336 # 1530 <malloc+0x226>
     688:	00001097          	auipc	ra,0x1
     68c:	bc2080e7          	jalr	-1086(ra) # 124a <printf>
        exit(1);
     690:	4505                	li	a0,1
     692:	00001097          	auipc	ra,0x1
     696:	830080e7          	jalr	-2000(ra) # ec2 <exit>
        fork();
     69a:	00001097          	auipc	ra,0x1
     69e:	820080e7          	jalr	-2016(ra) # eba <fork>
        fork();
     6a2:	00001097          	auipc	ra,0x1
     6a6:	818080e7          	jalr	-2024(ra) # eba <fork>
        if(write(fds[1], "x", 1) != 1)
     6aa:	4605                	li	a2,1
     6ac:	00001597          	auipc	a1,0x1
     6b0:	e9c58593          	addi	a1,a1,-356 # 1548 <malloc+0x23e>
     6b4:	fac42503          	lw	a0,-84(s0)
     6b8:	00001097          	auipc	ra,0x1
     6bc:	82a080e7          	jalr	-2006(ra) # ee2 <write>
     6c0:	4785                	li	a5,1
     6c2:	02f51363          	bne	a0,a5,6e8 <go+0x670>
        if(read(fds[0], &c, 1) != 1)
     6c6:	4605                	li	a2,1
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	fa842503          	lw	a0,-88(s0)
     6d0:	00001097          	auipc	ra,0x1
     6d4:	80a080e7          	jalr	-2038(ra) # eda <read>
     6d8:	4785                	li	a5,1
     6da:	02f51063          	bne	a0,a5,6fa <go+0x682>
        exit(0);
     6de:	4501                	li	a0,0
     6e0:	00000097          	auipc	ra,0x0
     6e4:	7e2080e7          	jalr	2018(ra) # ec2 <exit>
          printf("grind: pipe write failed\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	e6850513          	addi	a0,a0,-408 # 1550 <malloc+0x246>
     6f0:	00001097          	auipc	ra,0x1
     6f4:	b5a080e7          	jalr	-1190(ra) # 124a <printf>
     6f8:	b7f9                	j	6c6 <go+0x64e>
          printf("grind: pipe read failed\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	e7650513          	addi	a0,a0,-394 # 1570 <malloc+0x266>
     702:	00001097          	auipc	ra,0x1
     706:	b48080e7          	jalr	-1208(ra) # 124a <printf>
     70a:	bfd1                	j	6de <go+0x666>
        printf("grind: fork failed\n");
     70c:	00001517          	auipc	a0,0x1
     710:	de450513          	addi	a0,a0,-540 # 14f0 <malloc+0x1e6>
     714:	00001097          	auipc	ra,0x1
     718:	b36080e7          	jalr	-1226(ra) # 124a <printf>
        exit(1);
     71c:	4505                	li	a0,1
     71e:	00000097          	auipc	ra,0x0
     722:	7a4080e7          	jalr	1956(ra) # ec2 <exit>
      int pid = fork();
     726:	00000097          	auipc	ra,0x0
     72a:	794080e7          	jalr	1940(ra) # eba <fork>
      if(pid == 0){
     72e:	c909                	beqz	a0,740 <go+0x6c8>
      } else if(pid < 0){
     730:	06054f63          	bltz	a0,7ae <go+0x736>
      wait(0);
     734:	4501                	li	a0,0
     736:	00000097          	auipc	ra,0x0
     73a:	794080e7          	jalr	1940(ra) # eca <wait>
     73e:	b2d5                	j	122 <go+0xaa>
        unlink("a");
     740:	00001517          	auipc	a0,0x1
     744:	d9050513          	addi	a0,a0,-624 # 14d0 <malloc+0x1c6>
     748:	00000097          	auipc	ra,0x0
     74c:	7ca080e7          	jalr	1994(ra) # f12 <unlink>
        mkdir("a");
     750:	00001517          	auipc	a0,0x1
     754:	d8050513          	addi	a0,a0,-640 # 14d0 <malloc+0x1c6>
     758:	00000097          	auipc	ra,0x0
     75c:	7d2080e7          	jalr	2002(ra) # f2a <mkdir>
        chdir("a");
     760:	00001517          	auipc	a0,0x1
     764:	d7050513          	addi	a0,a0,-656 # 14d0 <malloc+0x1c6>
     768:	00000097          	auipc	ra,0x0
     76c:	7ca080e7          	jalr	1994(ra) # f32 <chdir>
        unlink("../a");
     770:	00001517          	auipc	a0,0x1
     774:	cc850513          	addi	a0,a0,-824 # 1438 <malloc+0x12e>
     778:	00000097          	auipc	ra,0x0
     77c:	79a080e7          	jalr	1946(ra) # f12 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     780:	20200593          	li	a1,514
     784:	00001517          	auipc	a0,0x1
     788:	dc450513          	addi	a0,a0,-572 # 1548 <malloc+0x23e>
     78c:	00000097          	auipc	ra,0x0
     790:	776080e7          	jalr	1910(ra) # f02 <open>
        unlink("x");
     794:	00001517          	auipc	a0,0x1
     798:	db450513          	addi	a0,a0,-588 # 1548 <malloc+0x23e>
     79c:	00000097          	auipc	ra,0x0
     7a0:	776080e7          	jalr	1910(ra) # f12 <unlink>
        exit(0);
     7a4:	4501                	li	a0,0
     7a6:	00000097          	auipc	ra,0x0
     7aa:	71c080e7          	jalr	1820(ra) # ec2 <exit>
        printf("grind: fork failed\n");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	d4250513          	addi	a0,a0,-702 # 14f0 <malloc+0x1e6>
     7b6:	00001097          	auipc	ra,0x1
     7ba:	a94080e7          	jalr	-1388(ra) # 124a <printf>
        exit(1);
     7be:	4505                	li	a0,1
     7c0:	00000097          	auipc	ra,0x0
     7c4:	702080e7          	jalr	1794(ra) # ec2 <exit>
      unlink("c");
     7c8:	00001517          	auipc	a0,0x1
     7cc:	dc850513          	addi	a0,a0,-568 # 1590 <malloc+0x286>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	742080e7          	jalr	1858(ra) # f12 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7d8:	20200593          	li	a1,514
     7dc:	00001517          	auipc	a0,0x1
     7e0:	db450513          	addi	a0,a0,-588 # 1590 <malloc+0x286>
     7e4:	00000097          	auipc	ra,0x0
     7e8:	71e080e7          	jalr	1822(ra) # f02 <open>
     7ec:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7ee:	04054f63          	bltz	a0,84c <go+0x7d4>
      if(write(fd1, "x", 1) != 1){
     7f2:	4605                	li	a2,1
     7f4:	00001597          	auipc	a1,0x1
     7f8:	d5458593          	addi	a1,a1,-684 # 1548 <malloc+0x23e>
     7fc:	00000097          	auipc	ra,0x0
     800:	6e6080e7          	jalr	1766(ra) # ee2 <write>
     804:	4785                	li	a5,1
     806:	06f51063          	bne	a0,a5,866 <go+0x7ee>
      if(fstat(fd1, &st) != 0){
     80a:	fa840593          	addi	a1,s0,-88
     80e:	855a                	mv	a0,s6
     810:	00000097          	auipc	ra,0x0
     814:	70a080e7          	jalr	1802(ra) # f1a <fstat>
     818:	e525                	bnez	a0,880 <go+0x808>
      if(st.size != 1){
     81a:	fb843583          	ld	a1,-72(s0)
     81e:	4785                	li	a5,1
     820:	06f59d63          	bne	a1,a5,89a <go+0x822>
      if(st.ino > 200){
     824:	fac42583          	lw	a1,-84(s0)
     828:	0c800793          	li	a5,200
     82c:	08b7e563          	bltu	a5,a1,8b6 <go+0x83e>
      close(fd1);
     830:	855a                	mv	a0,s6
     832:	00000097          	auipc	ra,0x0
     836:	6b8080e7          	jalr	1720(ra) # eea <close>
      unlink("c");
     83a:	00001517          	auipc	a0,0x1
     83e:	d5650513          	addi	a0,a0,-682 # 1590 <malloc+0x286>
     842:	00000097          	auipc	ra,0x0
     846:	6d0080e7          	jalr	1744(ra) # f12 <unlink>
     84a:	b8e1                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     84c:	00001517          	auipc	a0,0x1
     850:	d4c50513          	addi	a0,a0,-692 # 1598 <malloc+0x28e>
     854:	00001097          	auipc	ra,0x1
     858:	9f6080e7          	jalr	-1546(ra) # 124a <printf>
        exit(1);
     85c:	4505                	li	a0,1
     85e:	00000097          	auipc	ra,0x0
     862:	664080e7          	jalr	1636(ra) # ec2 <exit>
        printf("grind: write c failed\n");
     866:	00001517          	auipc	a0,0x1
     86a:	d4a50513          	addi	a0,a0,-694 # 15b0 <malloc+0x2a6>
     86e:	00001097          	auipc	ra,0x1
     872:	9dc080e7          	jalr	-1572(ra) # 124a <printf>
        exit(1);
     876:	4505                	li	a0,1
     878:	00000097          	auipc	ra,0x0
     87c:	64a080e7          	jalr	1610(ra) # ec2 <exit>
        printf("grind: fstat failed\n");
     880:	00001517          	auipc	a0,0x1
     884:	d4850513          	addi	a0,a0,-696 # 15c8 <malloc+0x2be>
     888:	00001097          	auipc	ra,0x1
     88c:	9c2080e7          	jalr	-1598(ra) # 124a <printf>
        exit(1);
     890:	4505                	li	a0,1
     892:	00000097          	auipc	ra,0x0
     896:	630080e7          	jalr	1584(ra) # ec2 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     89a:	2581                	sext.w	a1,a1
     89c:	00001517          	auipc	a0,0x1
     8a0:	d4450513          	addi	a0,a0,-700 # 15e0 <malloc+0x2d6>
     8a4:	00001097          	auipc	ra,0x1
     8a8:	9a6080e7          	jalr	-1626(ra) # 124a <printf>
        exit(1);
     8ac:	4505                	li	a0,1
     8ae:	00000097          	auipc	ra,0x0
     8b2:	614080e7          	jalr	1556(ra) # ec2 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8b6:	00001517          	auipc	a0,0x1
     8ba:	d5250513          	addi	a0,a0,-686 # 1608 <malloc+0x2fe>
     8be:	00001097          	auipc	ra,0x1
     8c2:	98c080e7          	jalr	-1652(ra) # 124a <printf>
        exit(1);
     8c6:	4505                	li	a0,1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	5fa080e7          	jalr	1530(ra) # ec2 <exit>
        fprintf(2, "grind: pipe failed\n");
     8d0:	00001597          	auipc	a1,0x1
     8d4:	c6058593          	addi	a1,a1,-928 # 1530 <malloc+0x226>
     8d8:	4509                	li	a0,2
     8da:	00001097          	auipc	ra,0x1
     8de:	942080e7          	jalr	-1726(ra) # 121c <fprintf>
        exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00000097          	auipc	ra,0x0
     8e8:	5de080e7          	jalr	1502(ra) # ec2 <exit>
        fprintf(2, "grind: pipe failed\n");
     8ec:	00001597          	auipc	a1,0x1
     8f0:	c4458593          	addi	a1,a1,-956 # 1530 <malloc+0x226>
     8f4:	4509                	li	a0,2
     8f6:	00001097          	auipc	ra,0x1
     8fa:	926080e7          	jalr	-1754(ra) # 121c <fprintf>
        exit(1);
     8fe:	4505                	li	a0,1
     900:	00000097          	auipc	ra,0x0
     904:	5c2080e7          	jalr	1474(ra) # ec2 <exit>
        close(bb[0]);
     908:	fa042503          	lw	a0,-96(s0)
     90c:	00000097          	auipc	ra,0x0
     910:	5de080e7          	jalr	1502(ra) # eea <close>
        close(bb[1]);
     914:	fa442503          	lw	a0,-92(s0)
     918:	00000097          	auipc	ra,0x0
     91c:	5d2080e7          	jalr	1490(ra) # eea <close>
        close(aa[0]);
     920:	f9842503          	lw	a0,-104(s0)
     924:	00000097          	auipc	ra,0x0
     928:	5c6080e7          	jalr	1478(ra) # eea <close>
        close(1);
     92c:	4505                	li	a0,1
     92e:	00000097          	auipc	ra,0x0
     932:	5bc080e7          	jalr	1468(ra) # eea <close>
        if(dup(aa[1]) != 1){
     936:	f9c42503          	lw	a0,-100(s0)
     93a:	00000097          	auipc	ra,0x0
     93e:	600080e7          	jalr	1536(ra) # f3a <dup>
     942:	4785                	li	a5,1
     944:	02f50063          	beq	a0,a5,964 <go+0x8ec>
          fprintf(2, "grind: dup failed\n");
     948:	00001597          	auipc	a1,0x1
     94c:	ce858593          	addi	a1,a1,-792 # 1630 <malloc+0x326>
     950:	4509                	li	a0,2
     952:	00001097          	auipc	ra,0x1
     956:	8ca080e7          	jalr	-1846(ra) # 121c <fprintf>
          exit(1);
     95a:	4505                	li	a0,1
     95c:	00000097          	auipc	ra,0x0
     960:	566080e7          	jalr	1382(ra) # ec2 <exit>
        close(aa[1]);
     964:	f9c42503          	lw	a0,-100(s0)
     968:	00000097          	auipc	ra,0x0
     96c:	582080e7          	jalr	1410(ra) # eea <close>
        char *args[3] = { "echo", "hi", 0 };
     970:	00001797          	auipc	a5,0x1
     974:	cd878793          	addi	a5,a5,-808 # 1648 <malloc+0x33e>
     978:	faf43423          	sd	a5,-88(s0)
     97c:	00001797          	auipc	a5,0x1
     980:	cd478793          	addi	a5,a5,-812 # 1650 <malloc+0x346>
     984:	faf43823          	sd	a5,-80(s0)
     988:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     98c:	fa840593          	addi	a1,s0,-88
     990:	00001517          	auipc	a0,0x1
     994:	cc850513          	addi	a0,a0,-824 # 1658 <malloc+0x34e>
     998:	00000097          	auipc	ra,0x0
     99c:	562080e7          	jalr	1378(ra) # efa <exec>
        fprintf(2, "grind: echo: not found\n");
     9a0:	00001597          	auipc	a1,0x1
     9a4:	cc858593          	addi	a1,a1,-824 # 1668 <malloc+0x35e>
     9a8:	4509                	li	a0,2
     9aa:	00001097          	auipc	ra,0x1
     9ae:	872080e7          	jalr	-1934(ra) # 121c <fprintf>
        exit(2);
     9b2:	4509                	li	a0,2
     9b4:	00000097          	auipc	ra,0x0
     9b8:	50e080e7          	jalr	1294(ra) # ec2 <exit>
        fprintf(2, "grind: fork failed\n");
     9bc:	00001597          	auipc	a1,0x1
     9c0:	b3458593          	addi	a1,a1,-1228 # 14f0 <malloc+0x1e6>
     9c4:	4509                	li	a0,2
     9c6:	00001097          	auipc	ra,0x1
     9ca:	856080e7          	jalr	-1962(ra) # 121c <fprintf>
        exit(3);
     9ce:	450d                	li	a0,3
     9d0:	00000097          	auipc	ra,0x0
     9d4:	4f2080e7          	jalr	1266(ra) # ec2 <exit>
        close(aa[1]);
     9d8:	f9c42503          	lw	a0,-100(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	50e080e7          	jalr	1294(ra) # eea <close>
        close(bb[0]);
     9e4:	fa042503          	lw	a0,-96(s0)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	502080e7          	jalr	1282(ra) # eea <close>
        close(0);
     9f0:	4501                	li	a0,0
     9f2:	00000097          	auipc	ra,0x0
     9f6:	4f8080e7          	jalr	1272(ra) # eea <close>
        if(dup(aa[0]) != 0){
     9fa:	f9842503          	lw	a0,-104(s0)
     9fe:	00000097          	auipc	ra,0x0
     a02:	53c080e7          	jalr	1340(ra) # f3a <dup>
     a06:	cd19                	beqz	a0,a24 <go+0x9ac>
          fprintf(2, "grind: dup failed\n");
     a08:	00001597          	auipc	a1,0x1
     a0c:	c2858593          	addi	a1,a1,-984 # 1630 <malloc+0x326>
     a10:	4509                	li	a0,2
     a12:	00001097          	auipc	ra,0x1
     a16:	80a080e7          	jalr	-2038(ra) # 121c <fprintf>
          exit(4);
     a1a:	4511                	li	a0,4
     a1c:	00000097          	auipc	ra,0x0
     a20:	4a6080e7          	jalr	1190(ra) # ec2 <exit>
        close(aa[0]);
     a24:	f9842503          	lw	a0,-104(s0)
     a28:	00000097          	auipc	ra,0x0
     a2c:	4c2080e7          	jalr	1218(ra) # eea <close>
        close(1);
     a30:	4505                	li	a0,1
     a32:	00000097          	auipc	ra,0x0
     a36:	4b8080e7          	jalr	1208(ra) # eea <close>
        if(dup(bb[1]) != 1){
     a3a:	fa442503          	lw	a0,-92(s0)
     a3e:	00000097          	auipc	ra,0x0
     a42:	4fc080e7          	jalr	1276(ra) # f3a <dup>
     a46:	4785                	li	a5,1
     a48:	02f50063          	beq	a0,a5,a68 <go+0x9f0>
          fprintf(2, "grind: dup failed\n");
     a4c:	00001597          	auipc	a1,0x1
     a50:	be458593          	addi	a1,a1,-1052 # 1630 <malloc+0x326>
     a54:	4509                	li	a0,2
     a56:	00000097          	auipc	ra,0x0
     a5a:	7c6080e7          	jalr	1990(ra) # 121c <fprintf>
          exit(5);
     a5e:	4515                	li	a0,5
     a60:	00000097          	auipc	ra,0x0
     a64:	462080e7          	jalr	1122(ra) # ec2 <exit>
        close(bb[1]);
     a68:	fa442503          	lw	a0,-92(s0)
     a6c:	00000097          	auipc	ra,0x0
     a70:	47e080e7          	jalr	1150(ra) # eea <close>
        char *args[2] = { "cat", 0 };
     a74:	00001797          	auipc	a5,0x1
     a78:	c0c78793          	addi	a5,a5,-1012 # 1680 <malloc+0x376>
     a7c:	faf43423          	sd	a5,-88(s0)
     a80:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a84:	fa840593          	addi	a1,s0,-88
     a88:	00001517          	auipc	a0,0x1
     a8c:	c0050513          	addi	a0,a0,-1024 # 1688 <malloc+0x37e>
     a90:	00000097          	auipc	ra,0x0
     a94:	46a080e7          	jalr	1130(ra) # efa <exec>
        fprintf(2, "grind: cat: not found\n");
     a98:	00001597          	auipc	a1,0x1
     a9c:	bf858593          	addi	a1,a1,-1032 # 1690 <malloc+0x386>
     aa0:	4509                	li	a0,2
     aa2:	00000097          	auipc	ra,0x0
     aa6:	77a080e7          	jalr	1914(ra) # 121c <fprintf>
        exit(6);
     aaa:	4519                	li	a0,6
     aac:	00000097          	auipc	ra,0x0
     ab0:	416080e7          	jalr	1046(ra) # ec2 <exit>
        fprintf(2, "grind: fork failed\n");
     ab4:	00001597          	auipc	a1,0x1
     ab8:	a3c58593          	addi	a1,a1,-1476 # 14f0 <malloc+0x1e6>
     abc:	4509                	li	a0,2
     abe:	00000097          	auipc	ra,0x0
     ac2:	75e080e7          	jalr	1886(ra) # 121c <fprintf>
        exit(7);
     ac6:	451d                	li	a0,7
     ac8:	00000097          	auipc	ra,0x0
     acc:	3fa080e7          	jalr	1018(ra) # ec2 <exit>

0000000000000ad0 <iter>:
  }
}

void
iter()
{
     ad0:	7179                	addi	sp,sp,-48
     ad2:	f406                	sd	ra,40(sp)
     ad4:	f022                	sd	s0,32(sp)
     ad6:	ec26                	sd	s1,24(sp)
     ad8:	e84a                	sd	s2,16(sp)
     ada:	1800                	addi	s0,sp,48
  unlink("a");
     adc:	00001517          	auipc	a0,0x1
     ae0:	9f450513          	addi	a0,a0,-1548 # 14d0 <malloc+0x1c6>
     ae4:	00000097          	auipc	ra,0x0
     ae8:	42e080e7          	jalr	1070(ra) # f12 <unlink>
  unlink("b");
     aec:	00001517          	auipc	a0,0x1
     af0:	99450513          	addi	a0,a0,-1644 # 1480 <malloc+0x176>
     af4:	00000097          	auipc	ra,0x0
     af8:	41e080e7          	jalr	1054(ra) # f12 <unlink>
  
  int pid1 = fork();
     afc:	00000097          	auipc	ra,0x0
     b00:	3be080e7          	jalr	958(ra) # eba <fork>
  if(pid1 < 0){
     b04:	02054163          	bltz	a0,b26 <iter+0x56>
     b08:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b0a:	e91d                	bnez	a0,b40 <iter+0x70>
    rand_next ^= 31;
     b0c:	00001717          	auipc	a4,0x1
     b10:	4f470713          	addi	a4,a4,1268 # 2000 <rand_next>
     b14:	631c                	ld	a5,0(a4)
     b16:	01f7c793          	xori	a5,a5,31
     b1a:	e31c                	sd	a5,0(a4)
    go(0);
     b1c:	4501                	li	a0,0
     b1e:	fffff097          	auipc	ra,0xfffff
     b22:	55a080e7          	jalr	1370(ra) # 78 <go>
    printf("grind: fork failed\n");
     b26:	00001517          	auipc	a0,0x1
     b2a:	9ca50513          	addi	a0,a0,-1590 # 14f0 <malloc+0x1e6>
     b2e:	00000097          	auipc	ra,0x0
     b32:	71c080e7          	jalr	1820(ra) # 124a <printf>
    exit(1);
     b36:	4505                	li	a0,1
     b38:	00000097          	auipc	ra,0x0
     b3c:	38a080e7          	jalr	906(ra) # ec2 <exit>
    exit(0);
  }

  int pid2 = fork();
     b40:	00000097          	auipc	ra,0x0
     b44:	37a080e7          	jalr	890(ra) # eba <fork>
     b48:	892a                	mv	s2,a0
  if(pid2 < 0){
     b4a:	02054263          	bltz	a0,b6e <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b4e:	ed0d                	bnez	a0,b88 <iter+0xb8>
    rand_next ^= 7177;
     b50:	00001697          	auipc	a3,0x1
     b54:	4b068693          	addi	a3,a3,1200 # 2000 <rand_next>
     b58:	629c                	ld	a5,0(a3)
     b5a:	6709                	lui	a4,0x2
     b5c:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x531>
     b60:	8fb9                	xor	a5,a5,a4
     b62:	e29c                	sd	a5,0(a3)
    go(1);
     b64:	4505                	li	a0,1
     b66:	fffff097          	auipc	ra,0xfffff
     b6a:	512080e7          	jalr	1298(ra) # 78 <go>
    printf("grind: fork failed\n");
     b6e:	00001517          	auipc	a0,0x1
     b72:	98250513          	addi	a0,a0,-1662 # 14f0 <malloc+0x1e6>
     b76:	00000097          	auipc	ra,0x0
     b7a:	6d4080e7          	jalr	1748(ra) # 124a <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00000097          	auipc	ra,0x0
     b84:	342080e7          	jalr	834(ra) # ec2 <exit>
    exit(0);
  }

  int st1 = -1;
     b88:	57fd                	li	a5,-1
     b8a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b8e:	fdc40513          	addi	a0,s0,-36
     b92:	00000097          	auipc	ra,0x0
     b96:	338080e7          	jalr	824(ra) # eca <wait>
  if(st1 != 0){
     b9a:	fdc42783          	lw	a5,-36(s0)
     b9e:	ef99                	bnez	a5,bbc <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     ba0:	57fd                	li	a5,-1
     ba2:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     ba6:	fd840513          	addi	a0,s0,-40
     baa:	00000097          	auipc	ra,0x0
     bae:	320080e7          	jalr	800(ra) # eca <wait>

  exit(0);
     bb2:	4501                	li	a0,0
     bb4:	00000097          	auipc	ra,0x0
     bb8:	30e080e7          	jalr	782(ra) # ec2 <exit>
    kill(pid1);
     bbc:	8526                	mv	a0,s1
     bbe:	00000097          	auipc	ra,0x0
     bc2:	334080e7          	jalr	820(ra) # ef2 <kill>
    kill(pid2);
     bc6:	854a                	mv	a0,s2
     bc8:	00000097          	auipc	ra,0x0
     bcc:	32a080e7          	jalr	810(ra) # ef2 <kill>
     bd0:	bfc1                	j	ba0 <iter+0xd0>

0000000000000bd2 <main>:
}

int
main()
{
     bd2:	1101                	addi	sp,sp,-32
     bd4:	ec06                	sd	ra,24(sp)
     bd6:	e822                	sd	s0,16(sp)
     bd8:	e426                	sd	s1,8(sp)
     bda:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     bdc:	00001497          	auipc	s1,0x1
     be0:	42448493          	addi	s1,s1,1060 # 2000 <rand_next>
     be4:	a829                	j	bfe <main+0x2c>
      iter();
     be6:	00000097          	auipc	ra,0x0
     bea:	eea080e7          	jalr	-278(ra) # ad0 <iter>
    sleep(20);
     bee:	4551                	li	a0,20
     bf0:	00000097          	auipc	ra,0x0
     bf4:	362080e7          	jalr	866(ra) # f52 <sleep>
    rand_next += 1;
     bf8:	609c                	ld	a5,0(s1)
     bfa:	0785                	addi	a5,a5,1
     bfc:	e09c                	sd	a5,0(s1)
    int pid = fork();
     bfe:	00000097          	auipc	ra,0x0
     c02:	2bc080e7          	jalr	700(ra) # eba <fork>
    if(pid == 0){
     c06:	d165                	beqz	a0,be6 <main+0x14>
    if(pid > 0){
     c08:	fea053e3          	blez	a0,bee <main+0x1c>
      wait(0);
     c0c:	4501                	li	a0,0
     c0e:	00000097          	auipc	ra,0x0
     c12:	2bc080e7          	jalr	700(ra) # eca <wait>
     c16:	bfe1                	j	bee <main+0x1c>

0000000000000c18 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c18:	1141                	addi	sp,sp,-16
     c1a:	e406                	sd	ra,8(sp)
     c1c:	e022                	sd	s0,0(sp)
     c1e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c20:	00000097          	auipc	ra,0x0
     c24:	fb2080e7          	jalr	-78(ra) # bd2 <main>
  exit(0);
     c28:	4501                	li	a0,0
     c2a:	00000097          	auipc	ra,0x0
     c2e:	298080e7          	jalr	664(ra) # ec2 <exit>

0000000000000c32 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c32:	1141                	addi	sp,sp,-16
     c34:	e422                	sd	s0,8(sp)
     c36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c38:	87aa                	mv	a5,a0
     c3a:	0585                	addi	a1,a1,1
     c3c:	0785                	addi	a5,a5,1
     c3e:	fff5c703          	lbu	a4,-1(a1)
     c42:	fee78fa3          	sb	a4,-1(a5)
     c46:	fb75                	bnez	a4,c3a <strcpy+0x8>
    ;
  return os;
}
     c48:	6422                	ld	s0,8(sp)
     c4a:	0141                	addi	sp,sp,16
     c4c:	8082                	ret

0000000000000c4e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c4e:	1141                	addi	sp,sp,-16
     c50:	e422                	sd	s0,8(sp)
     c52:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c54:	00054783          	lbu	a5,0(a0)
     c58:	cf91                	beqz	a5,c74 <strcmp+0x26>
     c5a:	0005c703          	lbu	a4,0(a1)
     c5e:	00f71b63          	bne	a4,a5,c74 <strcmp+0x26>
    p++, q++;
     c62:	0505                	addi	a0,a0,1
     c64:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c66:	00054783          	lbu	a5,0(a0)
     c6a:	c789                	beqz	a5,c74 <strcmp+0x26>
     c6c:	0005c703          	lbu	a4,0(a1)
     c70:	fef709e3          	beq	a4,a5,c62 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     c74:	0005c503          	lbu	a0,0(a1)
}
     c78:	40a7853b          	subw	a0,a5,a0
     c7c:	6422                	ld	s0,8(sp)
     c7e:	0141                	addi	sp,sp,16
     c80:	8082                	ret

0000000000000c82 <strlen>:

uint
strlen(const char *s)
{
     c82:	1141                	addi	sp,sp,-16
     c84:	e422                	sd	s0,8(sp)
     c86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c88:	00054783          	lbu	a5,0(a0)
     c8c:	cf91                	beqz	a5,ca8 <strlen+0x26>
     c8e:	0505                	addi	a0,a0,1
     c90:	87aa                	mv	a5,a0
     c92:	4685                	li	a3,1
     c94:	9e89                	subw	a3,a3,a0
     c96:	00f6853b          	addw	a0,a3,a5
     c9a:	0785                	addi	a5,a5,1
     c9c:	fff7c703          	lbu	a4,-1(a5)
     ca0:	fb7d                	bnez	a4,c96 <strlen+0x14>
    ;
  return n;
}
     ca2:	6422                	ld	s0,8(sp)
     ca4:	0141                	addi	sp,sp,16
     ca6:	8082                	ret
  for(n = 0; s[n]; n++)
     ca8:	4501                	li	a0,0
     caa:	bfe5                	j	ca2 <strlen+0x20>

0000000000000cac <memset>:

void*
memset(void *dst, int c, uint n)
{
     cac:	1141                	addi	sp,sp,-16
     cae:	e422                	sd	s0,8(sp)
     cb0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cb2:	ce09                	beqz	a2,ccc <memset+0x20>
     cb4:	87aa                	mv	a5,a0
     cb6:	fff6071b          	addiw	a4,a2,-1
     cba:	1702                	slli	a4,a4,0x20
     cbc:	9301                	srli	a4,a4,0x20
     cbe:	0705                	addi	a4,a4,1
     cc0:	972a                	add	a4,a4,a0
    cdst[i] = c;
     cc2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cc6:	0785                	addi	a5,a5,1
     cc8:	fee79de3          	bne	a5,a4,cc2 <memset+0x16>
  }
  return dst;
}
     ccc:	6422                	ld	s0,8(sp)
     cce:	0141                	addi	sp,sp,16
     cd0:	8082                	ret

0000000000000cd2 <strchr>:

char*
strchr(const char *s, char c)
{
     cd2:	1141                	addi	sp,sp,-16
     cd4:	e422                	sd	s0,8(sp)
     cd6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     cd8:	00054783          	lbu	a5,0(a0)
     cdc:	cf91                	beqz	a5,cf8 <strchr+0x26>
    if(*s == c)
     cde:	00f58a63          	beq	a1,a5,cf2 <strchr+0x20>
  for(; *s; s++)
     ce2:	0505                	addi	a0,a0,1
     ce4:	00054783          	lbu	a5,0(a0)
     ce8:	c781                	beqz	a5,cf0 <strchr+0x1e>
    if(*s == c)
     cea:	feb79ce3          	bne	a5,a1,ce2 <strchr+0x10>
     cee:	a011                	j	cf2 <strchr+0x20>
      return (char*)s;
  return 0;
     cf0:	4501                	li	a0,0
}
     cf2:	6422                	ld	s0,8(sp)
     cf4:	0141                	addi	sp,sp,16
     cf6:	8082                	ret
  return 0;
     cf8:	4501                	li	a0,0
     cfa:	bfe5                	j	cf2 <strchr+0x20>

0000000000000cfc <gets>:

char*
gets(char *buf, int max)
{
     cfc:	711d                	addi	sp,sp,-96
     cfe:	ec86                	sd	ra,88(sp)
     d00:	e8a2                	sd	s0,80(sp)
     d02:	e4a6                	sd	s1,72(sp)
     d04:	e0ca                	sd	s2,64(sp)
     d06:	fc4e                	sd	s3,56(sp)
     d08:	f852                	sd	s4,48(sp)
     d0a:	f456                	sd	s5,40(sp)
     d0c:	f05a                	sd	s6,32(sp)
     d0e:	ec5e                	sd	s7,24(sp)
     d10:	1080                	addi	s0,sp,96
     d12:	8baa                	mv	s7,a0
     d14:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d16:	892a                	mv	s2,a0
     d18:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d1a:	4aa9                	li	s5,10
     d1c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     d1e:	0019849b          	addiw	s1,s3,1
     d22:	0344d863          	ble	s4,s1,d52 <gets+0x56>
    cc = read(0, &c, 1);
     d26:	4605                	li	a2,1
     d28:	faf40593          	addi	a1,s0,-81
     d2c:	4501                	li	a0,0
     d2e:	00000097          	auipc	ra,0x0
     d32:	1ac080e7          	jalr	428(ra) # eda <read>
    if(cc < 1)
     d36:	00a05e63          	blez	a0,d52 <gets+0x56>
    buf[i++] = c;
     d3a:	faf44783          	lbu	a5,-81(s0)
     d3e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d42:	01578763          	beq	a5,s5,d50 <gets+0x54>
     d46:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
     d48:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
     d4a:	fd679ae3          	bne	a5,s6,d1e <gets+0x22>
     d4e:	a011                	j	d52 <gets+0x56>
  for(i=0; i+1 < max; ){
     d50:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d52:	99de                	add	s3,s3,s7
     d54:	00098023          	sb	zero,0(s3)
  return buf;
}
     d58:	855e                	mv	a0,s7
     d5a:	60e6                	ld	ra,88(sp)
     d5c:	6446                	ld	s0,80(sp)
     d5e:	64a6                	ld	s1,72(sp)
     d60:	6906                	ld	s2,64(sp)
     d62:	79e2                	ld	s3,56(sp)
     d64:	7a42                	ld	s4,48(sp)
     d66:	7aa2                	ld	s5,40(sp)
     d68:	7b02                	ld	s6,32(sp)
     d6a:	6be2                	ld	s7,24(sp)
     d6c:	6125                	addi	sp,sp,96
     d6e:	8082                	ret

0000000000000d70 <stat>:

int
stat(const char *n, struct stat *st)
{
     d70:	1101                	addi	sp,sp,-32
     d72:	ec06                	sd	ra,24(sp)
     d74:	e822                	sd	s0,16(sp)
     d76:	e426                	sd	s1,8(sp)
     d78:	e04a                	sd	s2,0(sp)
     d7a:	1000                	addi	s0,sp,32
     d7c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d7e:	4581                	li	a1,0
     d80:	00000097          	auipc	ra,0x0
     d84:	182080e7          	jalr	386(ra) # f02 <open>
  if(fd < 0)
     d88:	02054563          	bltz	a0,db2 <stat+0x42>
     d8c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d8e:	85ca                	mv	a1,s2
     d90:	00000097          	auipc	ra,0x0
     d94:	18a080e7          	jalr	394(ra) # f1a <fstat>
     d98:	892a                	mv	s2,a0
  close(fd);
     d9a:	8526                	mv	a0,s1
     d9c:	00000097          	auipc	ra,0x0
     da0:	14e080e7          	jalr	334(ra) # eea <close>
  return r;
}
     da4:	854a                	mv	a0,s2
     da6:	60e2                	ld	ra,24(sp)
     da8:	6442                	ld	s0,16(sp)
     daa:	64a2                	ld	s1,8(sp)
     dac:	6902                	ld	s2,0(sp)
     dae:	6105                	addi	sp,sp,32
     db0:	8082                	ret
    return -1;
     db2:	597d                	li	s2,-1
     db4:	bfc5                	j	da4 <stat+0x34>

0000000000000db6 <atoi>:

int
atoi(const char *s)
{
     db6:	1141                	addi	sp,sp,-16
     db8:	e422                	sd	s0,8(sp)
     dba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dbc:	00054683          	lbu	a3,0(a0)
     dc0:	fd06879b          	addiw	a5,a3,-48
     dc4:	0ff7f793          	andi	a5,a5,255
     dc8:	4725                	li	a4,9
     dca:	02f76963          	bltu	a4,a5,dfc <atoi+0x46>
     dce:	862a                	mv	a2,a0
  n = 0;
     dd0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     dd2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     dd4:	0605                	addi	a2,a2,1
     dd6:	0025179b          	slliw	a5,a0,0x2
     dda:	9fa9                	addw	a5,a5,a0
     ddc:	0017979b          	slliw	a5,a5,0x1
     de0:	9fb5                	addw	a5,a5,a3
     de2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     de6:	00064683          	lbu	a3,0(a2)
     dea:	fd06871b          	addiw	a4,a3,-48
     dee:	0ff77713          	andi	a4,a4,255
     df2:	fee5f1e3          	bleu	a4,a1,dd4 <atoi+0x1e>
  return n;
}
     df6:	6422                	ld	s0,8(sp)
     df8:	0141                	addi	sp,sp,16
     dfa:	8082                	ret
  n = 0;
     dfc:	4501                	li	a0,0
     dfe:	bfe5                	j	df6 <atoi+0x40>

0000000000000e00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e00:	1141                	addi	sp,sp,-16
     e02:	e422                	sd	s0,8(sp)
     e04:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e06:	02b57663          	bleu	a1,a0,e32 <memmove+0x32>
    while(n-- > 0)
     e0a:	02c05163          	blez	a2,e2c <memmove+0x2c>
     e0e:	fff6079b          	addiw	a5,a2,-1
     e12:	1782                	slli	a5,a5,0x20
     e14:	9381                	srli	a5,a5,0x20
     e16:	0785                	addi	a5,a5,1
     e18:	97aa                	add	a5,a5,a0
  dst = vdst;
     e1a:	872a                	mv	a4,a0
      *dst++ = *src++;
     e1c:	0585                	addi	a1,a1,1
     e1e:	0705                	addi	a4,a4,1
     e20:	fff5c683          	lbu	a3,-1(a1)
     e24:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e28:	fee79ae3          	bne	a5,a4,e1c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e2c:	6422                	ld	s0,8(sp)
     e2e:	0141                	addi	sp,sp,16
     e30:	8082                	ret
    dst += n;
     e32:	00c50733          	add	a4,a0,a2
    src += n;
     e36:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e38:	fec05ae3          	blez	a2,e2c <memmove+0x2c>
     e3c:	fff6079b          	addiw	a5,a2,-1
     e40:	1782                	slli	a5,a5,0x20
     e42:	9381                	srli	a5,a5,0x20
     e44:	fff7c793          	not	a5,a5
     e48:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e4a:	15fd                	addi	a1,a1,-1
     e4c:	177d                	addi	a4,a4,-1
     e4e:	0005c683          	lbu	a3,0(a1)
     e52:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e56:	fef71ae3          	bne	a4,a5,e4a <memmove+0x4a>
     e5a:	bfc9                	j	e2c <memmove+0x2c>

0000000000000e5c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e5c:	1141                	addi	sp,sp,-16
     e5e:	e422                	sd	s0,8(sp)
     e60:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e62:	ce15                	beqz	a2,e9e <memcmp+0x42>
     e64:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
     e68:	00054783          	lbu	a5,0(a0)
     e6c:	0005c703          	lbu	a4,0(a1)
     e70:	02e79063          	bne	a5,a4,e90 <memcmp+0x34>
     e74:	1682                	slli	a3,a3,0x20
     e76:	9281                	srli	a3,a3,0x20
     e78:	0685                	addi	a3,a3,1
     e7a:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
     e7c:	0505                	addi	a0,a0,1
    p2++;
     e7e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e80:	00d50d63          	beq	a0,a3,e9a <memcmp+0x3e>
    if (*p1 != *p2) {
     e84:	00054783          	lbu	a5,0(a0)
     e88:	0005c703          	lbu	a4,0(a1)
     e8c:	fee788e3          	beq	a5,a4,e7c <memcmp+0x20>
      return *p1 - *p2;
     e90:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
     e94:	6422                	ld	s0,8(sp)
     e96:	0141                	addi	sp,sp,16
     e98:	8082                	ret
  return 0;
     e9a:	4501                	li	a0,0
     e9c:	bfe5                	j	e94 <memcmp+0x38>
     e9e:	4501                	li	a0,0
     ea0:	bfd5                	j	e94 <memcmp+0x38>

0000000000000ea2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ea2:	1141                	addi	sp,sp,-16
     ea4:	e406                	sd	ra,8(sp)
     ea6:	e022                	sd	s0,0(sp)
     ea8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     eaa:	00000097          	auipc	ra,0x0
     eae:	f56080e7          	jalr	-170(ra) # e00 <memmove>
}
     eb2:	60a2                	ld	ra,8(sp)
     eb4:	6402                	ld	s0,0(sp)
     eb6:	0141                	addi	sp,sp,16
     eb8:	8082                	ret

0000000000000eba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     eba:	4885                	li	a7,1
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ec2:	4889                	li	a7,2
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <wait>:
.global wait
wait:
 li a7, SYS_wait
     eca:	488d                	li	a7,3
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ed2:	4891                	li	a7,4
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <read>:
.global read
read:
 li a7, SYS_read
     eda:	4895                	li	a7,5
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <write>:
.global write
write:
 li a7, SYS_write
     ee2:	48c1                	li	a7,16
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <close>:
.global close
close:
 li a7, SYS_close
     eea:	48d5                	li	a7,21
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ef2:	4899                	li	a7,6
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <exec>:
.global exec
exec:
 li a7, SYS_exec
     efa:	489d                	li	a7,7
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <open>:
.global open
open:
 li a7, SYS_open
     f02:	48bd                	li	a7,15
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f0a:	48c5                	li	a7,17
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f12:	48c9                	li	a7,18
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f1a:	48a1                	li	a7,8
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <link>:
.global link
link:
 li a7, SYS_link
     f22:	48cd                	li	a7,19
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f2a:	48d1                	li	a7,20
 ecall
     f2c:	00000073          	ecall
 ret
     f30:	8082                	ret

0000000000000f32 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f32:	48a5                	li	a7,9
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <dup>:
.global dup
dup:
 li a7, SYS_dup
     f3a:	48a9                	li	a7,10
 ecall
     f3c:	00000073          	ecall
 ret
     f40:	8082                	ret

0000000000000f42 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f42:	48ad                	li	a7,11
 ecall
     f44:	00000073          	ecall
 ret
     f48:	8082                	ret

0000000000000f4a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f4a:	48b1                	li	a7,12
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	8082                	ret

0000000000000f52 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f52:	48b5                	li	a7,13
 ecall
     f54:	00000073          	ecall
 ret
     f58:	8082                	ret

0000000000000f5a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f5a:	48b9                	li	a7,14
 ecall
     f5c:	00000073          	ecall
 ret
     f60:	8082                	ret

0000000000000f62 <trace>:
.global trace
trace:
 li a7, SYS_trace
     f62:	48d9                	li	a7,22
 ecall
     f64:	00000073          	ecall
 ret
     f68:	8082                	ret

0000000000000f6a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
     f6a:	48dd                	li	a7,23
 ecall
     f6c:	00000073          	ecall
 ret
     f70:	8082                	ret

0000000000000f72 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f72:	1101                	addi	sp,sp,-32
     f74:	ec06                	sd	ra,24(sp)
     f76:	e822                	sd	s0,16(sp)
     f78:	1000                	addi	s0,sp,32
     f7a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f7e:	4605                	li	a2,1
     f80:	fef40593          	addi	a1,s0,-17
     f84:	00000097          	auipc	ra,0x0
     f88:	f5e080e7          	jalr	-162(ra) # ee2 <write>
}
     f8c:	60e2                	ld	ra,24(sp)
     f8e:	6442                	ld	s0,16(sp)
     f90:	6105                	addi	sp,sp,32
     f92:	8082                	ret

0000000000000f94 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f94:	7139                	addi	sp,sp,-64
     f96:	fc06                	sd	ra,56(sp)
     f98:	f822                	sd	s0,48(sp)
     f9a:	f426                	sd	s1,40(sp)
     f9c:	f04a                	sd	s2,32(sp)
     f9e:	ec4e                	sd	s3,24(sp)
     fa0:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     fa2:	c299                	beqz	a3,fa8 <printint+0x14>
     fa4:	0005cd63          	bltz	a1,fbe <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     fa8:	2581                	sext.w	a1,a1
  neg = 0;
     faa:	4301                	li	t1,0
     fac:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
     fb0:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
     fb2:	2601                	sext.w	a2,a2
     fb4:	00000897          	auipc	a7,0x0
     fb8:	72488893          	addi	a7,a7,1828 # 16d8 <digits>
     fbc:	a801                	j	fcc <printint+0x38>
    x = -xx;
     fbe:	40b005bb          	negw	a1,a1
     fc2:	2581                	sext.w	a1,a1
    neg = 1;
     fc4:	4305                	li	t1,1
    x = -xx;
     fc6:	b7dd                	j	fac <printint+0x18>
  }while((x /= base) != 0);
     fc8:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
     fca:	8836                	mv	a6,a3
     fcc:	0018069b          	addiw	a3,a6,1
     fd0:	02c5f7bb          	remuw	a5,a1,a2
     fd4:	1782                	slli	a5,a5,0x20
     fd6:	9381                	srli	a5,a5,0x20
     fd8:	97c6                	add	a5,a5,a7
     fda:	0007c783          	lbu	a5,0(a5)
     fde:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
     fe2:	0705                	addi	a4,a4,1
     fe4:	02c5d7bb          	divuw	a5,a1,a2
     fe8:	fec5f0e3          	bleu	a2,a1,fc8 <printint+0x34>
  if(neg)
     fec:	00030b63          	beqz	t1,1002 <printint+0x6e>
    buf[i++] = '-';
     ff0:	fd040793          	addi	a5,s0,-48
     ff4:	96be                	add	a3,a3,a5
     ff6:	02d00793          	li	a5,45
     ffa:	fef68823          	sb	a5,-16(a3)
     ffe:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
    1002:	02d05963          	blez	a3,1034 <printint+0xa0>
    1006:	89aa                	mv	s3,a0
    1008:	fc040793          	addi	a5,s0,-64
    100c:	00d784b3          	add	s1,a5,a3
    1010:	fff78913          	addi	s2,a5,-1
    1014:	9936                	add	s2,s2,a3
    1016:	36fd                	addiw	a3,a3,-1
    1018:	1682                	slli	a3,a3,0x20
    101a:	9281                	srli	a3,a3,0x20
    101c:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
    1020:	fff4c583          	lbu	a1,-1(s1)
    1024:	854e                	mv	a0,s3
    1026:	00000097          	auipc	ra,0x0
    102a:	f4c080e7          	jalr	-180(ra) # f72 <putc>
  while(--i >= 0)
    102e:	14fd                	addi	s1,s1,-1
    1030:	ff2498e3          	bne	s1,s2,1020 <printint+0x8c>
}
    1034:	70e2                	ld	ra,56(sp)
    1036:	7442                	ld	s0,48(sp)
    1038:	74a2                	ld	s1,40(sp)
    103a:	7902                	ld	s2,32(sp)
    103c:	69e2                	ld	s3,24(sp)
    103e:	6121                	addi	sp,sp,64
    1040:	8082                	ret

0000000000001042 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1042:	7119                	addi	sp,sp,-128
    1044:	fc86                	sd	ra,120(sp)
    1046:	f8a2                	sd	s0,112(sp)
    1048:	f4a6                	sd	s1,104(sp)
    104a:	f0ca                	sd	s2,96(sp)
    104c:	ecce                	sd	s3,88(sp)
    104e:	e8d2                	sd	s4,80(sp)
    1050:	e4d6                	sd	s5,72(sp)
    1052:	e0da                	sd	s6,64(sp)
    1054:	fc5e                	sd	s7,56(sp)
    1056:	f862                	sd	s8,48(sp)
    1058:	f466                	sd	s9,40(sp)
    105a:	f06a                	sd	s10,32(sp)
    105c:	ec6e                	sd	s11,24(sp)
    105e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1060:	0005c483          	lbu	s1,0(a1)
    1064:	18048d63          	beqz	s1,11fe <vprintf+0x1bc>
    1068:	8aaa                	mv	s5,a0
    106a:	8b32                	mv	s6,a2
    106c:	00158913          	addi	s2,a1,1
  state = 0;
    1070:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1072:	02500a13          	li	s4,37
      if(c == 'd'){
    1076:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    107a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    107e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1082:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1086:	00000b97          	auipc	s7,0x0
    108a:	652b8b93          	addi	s7,s7,1618 # 16d8 <digits>
    108e:	a839                	j	10ac <vprintf+0x6a>
        putc(fd, c);
    1090:	85a6                	mv	a1,s1
    1092:	8556                	mv	a0,s5
    1094:	00000097          	auipc	ra,0x0
    1098:	ede080e7          	jalr	-290(ra) # f72 <putc>
    109c:	a019                	j	10a2 <vprintf+0x60>
    } else if(state == '%'){
    109e:	01498f63          	beq	s3,s4,10bc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    10a2:	0905                	addi	s2,s2,1
    10a4:	fff94483          	lbu	s1,-1(s2)
    10a8:	14048b63          	beqz	s1,11fe <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    10ac:	0004879b          	sext.w	a5,s1
    if(state == 0){
    10b0:	fe0997e3          	bnez	s3,109e <vprintf+0x5c>
      if(c == '%'){
    10b4:	fd479ee3          	bne	a5,s4,1090 <vprintf+0x4e>
        state = '%';
    10b8:	89be                	mv	s3,a5
    10ba:	b7e5                	j	10a2 <vprintf+0x60>
      if(c == 'd'){
    10bc:	05878063          	beq	a5,s8,10fc <vprintf+0xba>
      } else if(c == 'l') {
    10c0:	05978c63          	beq	a5,s9,1118 <vprintf+0xd6>
      } else if(c == 'x') {
    10c4:	07a78863          	beq	a5,s10,1134 <vprintf+0xf2>
      } else if(c == 'p') {
    10c8:	09b78463          	beq	a5,s11,1150 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    10cc:	07300713          	li	a4,115
    10d0:	0ce78563          	beq	a5,a4,119a <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10d4:	06300713          	li	a4,99
    10d8:	0ee78c63          	beq	a5,a4,11d0 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    10dc:	11478663          	beq	a5,s4,11e8 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10e0:	85d2                	mv	a1,s4
    10e2:	8556                	mv	a0,s5
    10e4:	00000097          	auipc	ra,0x0
    10e8:	e8e080e7          	jalr	-370(ra) # f72 <putc>
        putc(fd, c);
    10ec:	85a6                	mv	a1,s1
    10ee:	8556                	mv	a0,s5
    10f0:	00000097          	auipc	ra,0x0
    10f4:	e82080e7          	jalr	-382(ra) # f72 <putc>
      }
      state = 0;
    10f8:	4981                	li	s3,0
    10fa:	b765                	j	10a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10fc:	008b0493          	addi	s1,s6,8
    1100:	4685                	li	a3,1
    1102:	4629                	li	a2,10
    1104:	000b2583          	lw	a1,0(s6)
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	e8a080e7          	jalr	-374(ra) # f94 <printint>
    1112:	8b26                	mv	s6,s1
      state = 0;
    1114:	4981                	li	s3,0
    1116:	b771                	j	10a2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1118:	008b0493          	addi	s1,s6,8
    111c:	4681                	li	a3,0
    111e:	4629                	li	a2,10
    1120:	000b2583          	lw	a1,0(s6)
    1124:	8556                	mv	a0,s5
    1126:	00000097          	auipc	ra,0x0
    112a:	e6e080e7          	jalr	-402(ra) # f94 <printint>
    112e:	8b26                	mv	s6,s1
      state = 0;
    1130:	4981                	li	s3,0
    1132:	bf85                	j	10a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1134:	008b0493          	addi	s1,s6,8
    1138:	4681                	li	a3,0
    113a:	4641                	li	a2,16
    113c:	000b2583          	lw	a1,0(s6)
    1140:	8556                	mv	a0,s5
    1142:	00000097          	auipc	ra,0x0
    1146:	e52080e7          	jalr	-430(ra) # f94 <printint>
    114a:	8b26                	mv	s6,s1
      state = 0;
    114c:	4981                	li	s3,0
    114e:	bf91                	j	10a2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1150:	008b0793          	addi	a5,s6,8
    1154:	f8f43423          	sd	a5,-120(s0)
    1158:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    115c:	03000593          	li	a1,48
    1160:	8556                	mv	a0,s5
    1162:	00000097          	auipc	ra,0x0
    1166:	e10080e7          	jalr	-496(ra) # f72 <putc>
  putc(fd, 'x');
    116a:	85ea                	mv	a1,s10
    116c:	8556                	mv	a0,s5
    116e:	00000097          	auipc	ra,0x0
    1172:	e04080e7          	jalr	-508(ra) # f72 <putc>
    1176:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1178:	03c9d793          	srli	a5,s3,0x3c
    117c:	97de                	add	a5,a5,s7
    117e:	0007c583          	lbu	a1,0(a5)
    1182:	8556                	mv	a0,s5
    1184:	00000097          	auipc	ra,0x0
    1188:	dee080e7          	jalr	-530(ra) # f72 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    118c:	0992                	slli	s3,s3,0x4
    118e:	34fd                	addiw	s1,s1,-1
    1190:	f4e5                	bnez	s1,1178 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1192:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1196:	4981                	li	s3,0
    1198:	b729                	j	10a2 <vprintf+0x60>
        s = va_arg(ap, char*);
    119a:	008b0993          	addi	s3,s6,8
    119e:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    11a2:	c085                	beqz	s1,11c2 <vprintf+0x180>
        while(*s != 0){
    11a4:	0004c583          	lbu	a1,0(s1)
    11a8:	c9a1                	beqz	a1,11f8 <vprintf+0x1b6>
          putc(fd, *s);
    11aa:	8556                	mv	a0,s5
    11ac:	00000097          	auipc	ra,0x0
    11b0:	dc6080e7          	jalr	-570(ra) # f72 <putc>
          s++;
    11b4:	0485                	addi	s1,s1,1
        while(*s != 0){
    11b6:	0004c583          	lbu	a1,0(s1)
    11ba:	f9e5                	bnez	a1,11aa <vprintf+0x168>
        s = va_arg(ap, char*);
    11bc:	8b4e                	mv	s6,s3
      state = 0;
    11be:	4981                	li	s3,0
    11c0:	b5cd                	j	10a2 <vprintf+0x60>
          s = "(null)";
    11c2:	00000497          	auipc	s1,0x0
    11c6:	52e48493          	addi	s1,s1,1326 # 16f0 <digits+0x18>
        while(*s != 0){
    11ca:	02800593          	li	a1,40
    11ce:	bff1                	j	11aa <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    11d0:	008b0493          	addi	s1,s6,8
    11d4:	000b4583          	lbu	a1,0(s6)
    11d8:	8556                	mv	a0,s5
    11da:	00000097          	auipc	ra,0x0
    11de:	d98080e7          	jalr	-616(ra) # f72 <putc>
    11e2:	8b26                	mv	s6,s1
      state = 0;
    11e4:	4981                	li	s3,0
    11e6:	bd75                	j	10a2 <vprintf+0x60>
        putc(fd, c);
    11e8:	85d2                	mv	a1,s4
    11ea:	8556                	mv	a0,s5
    11ec:	00000097          	auipc	ra,0x0
    11f0:	d86080e7          	jalr	-634(ra) # f72 <putc>
      state = 0;
    11f4:	4981                	li	s3,0
    11f6:	b575                	j	10a2 <vprintf+0x60>
        s = va_arg(ap, char*);
    11f8:	8b4e                	mv	s6,s3
      state = 0;
    11fa:	4981                	li	s3,0
    11fc:	b55d                	j	10a2 <vprintf+0x60>
    }
  }
}
    11fe:	70e6                	ld	ra,120(sp)
    1200:	7446                	ld	s0,112(sp)
    1202:	74a6                	ld	s1,104(sp)
    1204:	7906                	ld	s2,96(sp)
    1206:	69e6                	ld	s3,88(sp)
    1208:	6a46                	ld	s4,80(sp)
    120a:	6aa6                	ld	s5,72(sp)
    120c:	6b06                	ld	s6,64(sp)
    120e:	7be2                	ld	s7,56(sp)
    1210:	7c42                	ld	s8,48(sp)
    1212:	7ca2                	ld	s9,40(sp)
    1214:	7d02                	ld	s10,32(sp)
    1216:	6de2                	ld	s11,24(sp)
    1218:	6109                	addi	sp,sp,128
    121a:	8082                	ret

000000000000121c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    121c:	715d                	addi	sp,sp,-80
    121e:	ec06                	sd	ra,24(sp)
    1220:	e822                	sd	s0,16(sp)
    1222:	1000                	addi	s0,sp,32
    1224:	e010                	sd	a2,0(s0)
    1226:	e414                	sd	a3,8(s0)
    1228:	e818                	sd	a4,16(s0)
    122a:	ec1c                	sd	a5,24(s0)
    122c:	03043023          	sd	a6,32(s0)
    1230:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1234:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1238:	8622                	mv	a2,s0
    123a:	00000097          	auipc	ra,0x0
    123e:	e08080e7          	jalr	-504(ra) # 1042 <vprintf>
}
    1242:	60e2                	ld	ra,24(sp)
    1244:	6442                	ld	s0,16(sp)
    1246:	6161                	addi	sp,sp,80
    1248:	8082                	ret

000000000000124a <printf>:

void
printf(const char *fmt, ...)
{
    124a:	711d                	addi	sp,sp,-96
    124c:	ec06                	sd	ra,24(sp)
    124e:	e822                	sd	s0,16(sp)
    1250:	1000                	addi	s0,sp,32
    1252:	e40c                	sd	a1,8(s0)
    1254:	e810                	sd	a2,16(s0)
    1256:	ec14                	sd	a3,24(s0)
    1258:	f018                	sd	a4,32(s0)
    125a:	f41c                	sd	a5,40(s0)
    125c:	03043823          	sd	a6,48(s0)
    1260:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1264:	00840613          	addi	a2,s0,8
    1268:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    126c:	85aa                	mv	a1,a0
    126e:	4505                	li	a0,1
    1270:	00000097          	auipc	ra,0x0
    1274:	dd2080e7          	jalr	-558(ra) # 1042 <vprintf>
}
    1278:	60e2                	ld	ra,24(sp)
    127a:	6442                	ld	s0,16(sp)
    127c:	6125                	addi	sp,sp,96
    127e:	8082                	ret

0000000000001280 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1280:	1141                	addi	sp,sp,-16
    1282:	e422                	sd	s0,8(sp)
    1284:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1286:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    128a:	00001797          	auipc	a5,0x1
    128e:	d8678793          	addi	a5,a5,-634 # 2010 <freep>
    1292:	639c                	ld	a5,0(a5)
    1294:	a805                	j	12c4 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1296:	4618                	lw	a4,8(a2)
    1298:	9db9                	addw	a1,a1,a4
    129a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    129e:	6398                	ld	a4,0(a5)
    12a0:	6318                	ld	a4,0(a4)
    12a2:	fee53823          	sd	a4,-16(a0)
    12a6:	a091                	j	12ea <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12a8:	ff852703          	lw	a4,-8(a0)
    12ac:	9e39                	addw	a2,a2,a4
    12ae:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    12b0:	ff053703          	ld	a4,-16(a0)
    12b4:	e398                	sd	a4,0(a5)
    12b6:	a099                	j	12fc <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b8:	6398                	ld	a4,0(a5)
    12ba:	00e7e463          	bltu	a5,a4,12c2 <free+0x42>
    12be:	00e6ea63          	bltu	a3,a4,12d2 <free+0x52>
{
    12c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12c4:	fed7fae3          	bleu	a3,a5,12b8 <free+0x38>
    12c8:	6398                	ld	a4,0(a5)
    12ca:	00e6e463          	bltu	a3,a4,12d2 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12ce:	fee7eae3          	bltu	a5,a4,12c2 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    12d2:	ff852583          	lw	a1,-8(a0)
    12d6:	6390                	ld	a2,0(a5)
    12d8:	02059713          	slli	a4,a1,0x20
    12dc:	9301                	srli	a4,a4,0x20
    12de:	0712                	slli	a4,a4,0x4
    12e0:	9736                	add	a4,a4,a3
    12e2:	fae60ae3          	beq	a2,a4,1296 <free+0x16>
    bp->s.ptr = p->s.ptr;
    12e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12ea:	4790                	lw	a2,8(a5)
    12ec:	02061713          	slli	a4,a2,0x20
    12f0:	9301                	srli	a4,a4,0x20
    12f2:	0712                	slli	a4,a4,0x4
    12f4:	973e                	add	a4,a4,a5
    12f6:	fae689e3          	beq	a3,a4,12a8 <free+0x28>
  } else
    p->s.ptr = bp;
    12fa:	e394                	sd	a3,0(a5)
  freep = p;
    12fc:	00001717          	auipc	a4,0x1
    1300:	d0f73a23          	sd	a5,-748(a4) # 2010 <freep>
}
    1304:	6422                	ld	s0,8(sp)
    1306:	0141                	addi	sp,sp,16
    1308:	8082                	ret

000000000000130a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    130a:	7139                	addi	sp,sp,-64
    130c:	fc06                	sd	ra,56(sp)
    130e:	f822                	sd	s0,48(sp)
    1310:	f426                	sd	s1,40(sp)
    1312:	f04a                	sd	s2,32(sp)
    1314:	ec4e                	sd	s3,24(sp)
    1316:	e852                	sd	s4,16(sp)
    1318:	e456                	sd	s5,8(sp)
    131a:	e05a                	sd	s6,0(sp)
    131c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    131e:	02051993          	slli	s3,a0,0x20
    1322:	0209d993          	srli	s3,s3,0x20
    1326:	09bd                	addi	s3,s3,15
    1328:	0049d993          	srli	s3,s3,0x4
    132c:	2985                	addiw	s3,s3,1
    132e:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    1332:	00001797          	auipc	a5,0x1
    1336:	cde78793          	addi	a5,a5,-802 # 2010 <freep>
    133a:	6388                	ld	a0,0(a5)
    133c:	c515                	beqz	a0,1368 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    133e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1340:	4798                	lw	a4,8(a5)
    1342:	03277f63          	bleu	s2,a4,1380 <malloc+0x76>
    1346:	8a4e                	mv	s4,s3
    1348:	0009871b          	sext.w	a4,s3
    134c:	6685                	lui	a3,0x1
    134e:	00d77363          	bleu	a3,a4,1354 <malloc+0x4a>
    1352:	6a05                	lui	s4,0x1
    1354:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    1358:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    135c:	00001497          	auipc	s1,0x1
    1360:	cb448493          	addi	s1,s1,-844 # 2010 <freep>
  if(p == (char*)-1)
    1364:	5b7d                	li	s6,-1
    1366:	a885                	j	13d6 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    1368:	00001797          	auipc	a5,0x1
    136c:	0a078793          	addi	a5,a5,160 # 2408 <base>
    1370:	00001717          	auipc	a4,0x1
    1374:	caf73023          	sd	a5,-864(a4) # 2010 <freep>
    1378:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    137a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    137e:	b7e1                	j	1346 <malloc+0x3c>
      if(p->s.size == nunits)
    1380:	02e90b63          	beq	s2,a4,13b6 <malloc+0xac>
        p->s.size -= nunits;
    1384:	4137073b          	subw	a4,a4,s3
    1388:	c798                	sw	a4,8(a5)
        p += p->s.size;
    138a:	1702                	slli	a4,a4,0x20
    138c:	9301                	srli	a4,a4,0x20
    138e:	0712                	slli	a4,a4,0x4
    1390:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1392:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1396:	00001717          	auipc	a4,0x1
    139a:	c6a73d23          	sd	a0,-902(a4) # 2010 <freep>
      return (void*)(p + 1);
    139e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    13a2:	70e2                	ld	ra,56(sp)
    13a4:	7442                	ld	s0,48(sp)
    13a6:	74a2                	ld	s1,40(sp)
    13a8:	7902                	ld	s2,32(sp)
    13aa:	69e2                	ld	s3,24(sp)
    13ac:	6a42                	ld	s4,16(sp)
    13ae:	6aa2                	ld	s5,8(sp)
    13b0:	6b02                	ld	s6,0(sp)
    13b2:	6121                	addi	sp,sp,64
    13b4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    13b6:	6398                	ld	a4,0(a5)
    13b8:	e118                	sd	a4,0(a0)
    13ba:	bff1                	j	1396 <malloc+0x8c>
  hp->s.size = nu;
    13bc:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    13c0:	0541                	addi	a0,a0,16
    13c2:	00000097          	auipc	ra,0x0
    13c6:	ebe080e7          	jalr	-322(ra) # 1280 <free>
  return freep;
    13ca:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13cc:	d979                	beqz	a0,13a2 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13d0:	4798                	lw	a4,8(a5)
    13d2:	fb2777e3          	bleu	s2,a4,1380 <malloc+0x76>
    if(p == freep)
    13d6:	6098                	ld	a4,0(s1)
    13d8:	853e                	mv	a0,a5
    13da:	fef71ae3          	bne	a4,a5,13ce <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    13de:	8552                	mv	a0,s4
    13e0:	00000097          	auipc	ra,0x0
    13e4:	b6a080e7          	jalr	-1174(ra) # f4a <sbrk>
  if(p == (char*)-1)
    13e8:	fd651ae3          	bne	a0,s6,13bc <malloc+0xb2>
        return 0;
    13ec:	4501                	li	a0,0
    13ee:	bf55                	j	13a2 <malloc+0x98>
