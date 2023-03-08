
user/_sysinfotest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	70a080e7          	jalr	1802(ra) # 712 <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	b9450513          	addi	a0,a0,-1132 # bb0 <malloc+0xfe>
  24:	00001097          	auipc	ra,0x1
  28:	9ce080e7          	jalr	-1586(ra) # 9f2 <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	63c080e7          	jalr	1596(ra) # 66a <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	6aa080e7          	jalr	1706(ra) # 6f2 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  58:	6505                	lui	a0,0x1
  5a:	00000097          	auipc	ra,0x0
  5e:	698080e7          	jalr	1688(ra) # 6f2 <sbrk>
  62:	01250563          	beq	a0,s2,6c <countfree+0x36>
    n += PGSIZE;
  66:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  6a:	b7fd                	j	58 <countfree+0x22>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	672080e7          	jalr	1650(ra) # 6f2 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	666080e7          	jalr	1638(ra) # 6f2 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	b2250513          	addi	a0,a0,-1246 # bc8 <malloc+0x116>
  ae:	00001097          	auipc	ra,0x1
  b2:	944080e7          	jalr	-1724(ra) # 9f2 <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	5b2080e7          	jalr	1458(ra) # 66a <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	606080e7          	jalr	1542(ra) # 6f2 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	5de080e7          	jalr	1502(ra) # 6f2 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	abc50513          	addi	a0,a0,-1348 # c00 <malloc+0x14e>
 14c:	00001097          	auipc	ra,0x1
 150:	8a6080e7          	jalr	-1882(ra) # 9f2 <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	514080e7          	jalr	1300(ra) # 66a <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	ad250513          	addi	a0,a0,-1326 # c30 <malloc+0x17e>
 166:	00001097          	auipc	ra,0x1
 16a:	88c080e7          	jalr	-1908(ra) # 9f2 <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	4fa080e7          	jalr	1274(ra) # 66a <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	a8850513          	addi	a0,a0,-1400 # c00 <malloc+0x14e>
 180:	00001097          	auipc	ra,0x1
 184:	872080e7          	jalr	-1934(ra) # 9f2 <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	4e0080e7          	jalr	1248(ra) # 66a <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	a9e50513          	addi	a0,a0,-1378 # c30 <malloc+0x17e>
 19a:	00001097          	auipc	ra,0x1
 19e:	858080e7          	jalr	-1960(ra) # 9f2 <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4c6080e7          	jalr	1222(ra) # 66a <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a5250513          	addi	a0,a0,-1454 # c00 <malloc+0x14e>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	83c080e7          	jalr	-1988(ra) # 9f2 <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	4aa080e7          	jalr	1194(ra) # 66a <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	53e080e7          	jalr	1342(ra) # 712 <sysinfo>
 1dc:	02054263          	bltz	a0,200 <testcall+0x38>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001797          	auipc	a5,0x1
 1e4:	9c078793          	addi	a5,a5,-1600 # ba0 <malloc+0xee>
 1e8:	6388                	ld	a0,0(a5)
 1ea:	00000097          	auipc	ra,0x0
 1ee:	528080e7          	jalr	1320(ra) # 712 <sysinfo>
 1f2:	57fd                	li	a5,-1
 1f4:	02f51363          	bne	a0,a5,21a <testcall+0x52>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 200:	00001517          	auipc	a0,0x1
 204:	a4050513          	addi	a0,a0,-1472 # c40 <malloc+0x18e>
 208:	00000097          	auipc	ra,0x0
 20c:	7ea080e7          	jalr	2026(ra) # 9f2 <printf>
    exit(1);
 210:	4505                	li	a0,1
 212:	00000097          	auipc	ra,0x0
 216:	458080e7          	jalr	1112(ra) # 66a <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	a3e50513          	addi	a0,a0,-1474 # c58 <malloc+0x1a6>
 222:	00000097          	auipc	ra,0x0
 226:	7d0080e7          	jalr	2000(ra) # 9f2 <printf>
    exit(1);
 22a:	4505                	li	a0,1
 22c:	00000097          	auipc	ra,0x0
 230:	43e080e7          	jalr	1086(ra) # 66a <exit>

0000000000000234 <testproc>:

void testproc() {
 234:	7139                	addi	sp,sp,-64
 236:	fc06                	sd	ra,56(sp)
 238:	f822                	sd	s0,48(sp)
 23a:	f426                	sd	s1,40(sp)
 23c:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23e:	fd040513          	addi	a0,s0,-48
 242:	00000097          	auipc	ra,0x0
 246:	dbe080e7          	jalr	-578(ra) # 0 <sinfo>
  nproc = info.nproc;
 24a:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24e:	00000097          	auipc	ra,0x0
 252:	414080e7          	jalr	1044(ra) # 662 <fork>
  if(pid < 0){
 256:	02054c63          	bltz	a0,28e <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 25a:	ed21                	bnez	a0,2b2 <testproc+0x7e>
    sinfo(&info);
 25c:	fd040513          	addi	a0,s0,-48
 260:	00000097          	auipc	ra,0x0
 264:	da0080e7          	jalr	-608(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 268:	fd843583          	ld	a1,-40(s0)
 26c:	00148613          	addi	a2,s1,1
 270:	02c58c63          	beq	a1,a2,2a8 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 274:	00001517          	auipc	a0,0x1
 278:	a3450513          	addi	a0,a0,-1484 # ca8 <malloc+0x1f6>
 27c:	00000097          	auipc	ra,0x0
 280:	776080e7          	jalr	1910(ra) # 9f2 <printf>
      exit(1);
 284:	4505                	li	a0,1
 286:	00000097          	auipc	ra,0x0
 28a:	3e4080e7          	jalr	996(ra) # 66a <exit>
    printf("sysinfotest: fork failed\n");
 28e:	00001517          	auipc	a0,0x1
 292:	9fa50513          	addi	a0,a0,-1542 # c88 <malloc+0x1d6>
 296:	00000097          	auipc	ra,0x0
 29a:	75c080e7          	jalr	1884(ra) # 9f2 <printf>
    exit(1);
 29e:	4505                	li	a0,1
 2a0:	00000097          	auipc	ra,0x0
 2a4:	3ca080e7          	jalr	970(ra) # 66a <exit>
    }
    exit(0);
 2a8:	4501                	li	a0,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	3c0080e7          	jalr	960(ra) # 66a <exit>
  }
  wait(&status);
 2b2:	fcc40513          	addi	a0,s0,-52
 2b6:	00000097          	auipc	ra,0x0
 2ba:	3bc080e7          	jalr	956(ra) # 672 <wait>
  sinfo(&info);
 2be:	fd040513          	addi	a0,s0,-48
 2c2:	00000097          	auipc	ra,0x0
 2c6:	d3e080e7          	jalr	-706(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2ca:	fd843583          	ld	a1,-40(s0)
 2ce:	00959763          	bne	a1,s1,2dc <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d2:	70e2                	ld	ra,56(sp)
 2d4:	7442                	ld	s0,48(sp)
 2d6:	74a2                	ld	s1,40(sp)
 2d8:	6121                	addi	sp,sp,64
 2da:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2dc:	8626                	mv	a2,s1
 2de:	00001517          	auipc	a0,0x1
 2e2:	9ca50513          	addi	a0,a0,-1590 # ca8 <malloc+0x1f6>
 2e6:	00000097          	auipc	ra,0x0
 2ea:	70c080e7          	jalr	1804(ra) # 9f2 <printf>
      exit(1);
 2ee:	4505                	li	a0,1
 2f0:	00000097          	auipc	ra,0x0
 2f4:	37a080e7          	jalr	890(ra) # 66a <exit>

00000000000002f8 <testbad>:

void testbad() {
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	1000                	addi	s0,sp,32
  int pid = fork();
 300:	00000097          	auipc	ra,0x0
 304:	362080e7          	jalr	866(ra) # 662 <fork>
  int xstatus;
  
  if(pid < 0){
 308:	00054c63          	bltz	a0,320 <testbad+0x28>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 30c:	e51d                	bnez	a0,33a <testbad+0x42>
      sinfo(0x0);
 30e:	00000097          	auipc	ra,0x0
 312:	cf2080e7          	jalr	-782(ra) # 0 <sinfo>
      exit(0);
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	352080e7          	jalr	850(ra) # 66a <exit>
    printf("sysinfotest: fork failed\n");
 320:	00001517          	auipc	a0,0x1
 324:	96850513          	addi	a0,a0,-1688 # c88 <malloc+0x1d6>
 328:	00000097          	auipc	ra,0x0
 32c:	6ca080e7          	jalr	1738(ra) # 9f2 <printf>
    exit(1);
 330:	4505                	li	a0,1
 332:	00000097          	auipc	ra,0x0
 336:	338080e7          	jalr	824(ra) # 66a <exit>
  }
  wait(&xstatus);
 33a:	fec40513          	addi	a0,s0,-20
 33e:	00000097          	auipc	ra,0x0
 342:	334080e7          	jalr	820(ra) # 672 <wait>
  if(xstatus == -1)  // kernel killed child?
 346:	fec42583          	lw	a1,-20(s0)
 34a:	57fd                	li	a5,-1
 34c:	02f58063          	beq	a1,a5,36c <testbad+0x74>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 350:	00001517          	auipc	a0,0x1
 354:	98850513          	addi	a0,a0,-1656 # cd8 <malloc+0x226>
 358:	00000097          	auipc	ra,0x0
 35c:	69a080e7          	jalr	1690(ra) # 9f2 <printf>
    exit(xstatus);
 360:	fec42503          	lw	a0,-20(s0)
 364:	00000097          	auipc	ra,0x0
 368:	306080e7          	jalr	774(ra) # 66a <exit>
    exit(0);
 36c:	4501                	li	a0,0
 36e:	00000097          	auipc	ra,0x0
 372:	2fc080e7          	jalr	764(ra) # 66a <exit>

0000000000000376 <main>:
  }
}

int
main(int argc, char *argv[])
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 37e:	00001517          	auipc	a0,0x1
 382:	98250513          	addi	a0,a0,-1662 # d00 <malloc+0x24e>
 386:	00000097          	auipc	ra,0x0
 38a:	66c080e7          	jalr	1644(ra) # 9f2 <printf>
  testcall();
 38e:	00000097          	auipc	ra,0x0
 392:	e3a080e7          	jalr	-454(ra) # 1c8 <testcall>
  testmem();
 396:	00000097          	auipc	ra,0x0
 39a:	d2a080e7          	jalr	-726(ra) # c0 <testmem>
  testproc();
 39e:	00000097          	auipc	ra,0x0
 3a2:	e96080e7          	jalr	-362(ra) # 234 <testproc>
  printf("sysinfotest: OK\n");
 3a6:	00001517          	auipc	a0,0x1
 3aa:	97250513          	addi	a0,a0,-1678 # d18 <malloc+0x266>
 3ae:	00000097          	auipc	ra,0x0
 3b2:	644080e7          	jalr	1604(ra) # 9f2 <printf>
  exit(0);
 3b6:	4501                	li	a0,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	2b2080e7          	jalr	690(ra) # 66a <exit>

00000000000003c0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c8:	00000097          	auipc	ra,0x0
 3cc:	fae080e7          	jalr	-82(ra) # 376 <main>
  exit(0);
 3d0:	4501                	li	a0,0
 3d2:	00000097          	auipc	ra,0x0
 3d6:	298080e7          	jalr	664(ra) # 66a <exit>

00000000000003da <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3e0:	87aa                	mv	a5,a0
 3e2:	0585                	addi	a1,a1,1
 3e4:	0785                	addi	a5,a5,1
 3e6:	fff5c703          	lbu	a4,-1(a1) # ffffffffffffefff <base+0xffffffffffffdfef>
 3ea:	fee78fa3          	sb	a4,-1(a5)
 3ee:	fb75                	bnez	a4,3e2 <strcpy+0x8>
    ;
  return os;
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e422                	sd	s0,8(sp)
 3fa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fc:	00054783          	lbu	a5,0(a0)
 400:	cf91                	beqz	a5,41c <strcmp+0x26>
 402:	0005c703          	lbu	a4,0(a1)
 406:	00f71b63          	bne	a4,a5,41c <strcmp+0x26>
    p++, q++;
 40a:	0505                	addi	a0,a0,1
 40c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40e:	00054783          	lbu	a5,0(a0)
 412:	c789                	beqz	a5,41c <strcmp+0x26>
 414:	0005c703          	lbu	a4,0(a1)
 418:	fef709e3          	beq	a4,a5,40a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 41c:	0005c503          	lbu	a0,0(a1)
}
 420:	40a7853b          	subw	a0,a5,a0
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret

000000000000042a <strlen>:

uint
strlen(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 430:	00054783          	lbu	a5,0(a0)
 434:	cf91                	beqz	a5,450 <strlen+0x26>
 436:	0505                	addi	a0,a0,1
 438:	87aa                	mv	a5,a0
 43a:	4685                	li	a3,1
 43c:	9e89                	subw	a3,a3,a0
 43e:	00f6853b          	addw	a0,a3,a5
 442:	0785                	addi	a5,a5,1
 444:	fff7c703          	lbu	a4,-1(a5)
 448:	fb7d                	bnez	a4,43e <strlen+0x14>
    ;
  return n;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret
  for(n = 0; s[n]; n++)
 450:	4501                	li	a0,0
 452:	bfe5                	j	44a <strlen+0x20>

0000000000000454 <memset>:

void*
memset(void *dst, int c, uint n)
{
 454:	1141                	addi	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45a:	ce09                	beqz	a2,474 <memset+0x20>
 45c:	87aa                	mv	a5,a0
 45e:	fff6071b          	addiw	a4,a2,-1
 462:	1702                	slli	a4,a4,0x20
 464:	9301                	srli	a4,a4,0x20
 466:	0705                	addi	a4,a4,1
 468:	972a                	add	a4,a4,a0
    cdst[i] = c;
 46a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 46e:	0785                	addi	a5,a5,1
 470:	fee79de3          	bne	a5,a4,46a <memset+0x16>
  }
  return dst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret

000000000000047a <strchr>:

char*
strchr(const char *s, char c)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 480:	00054783          	lbu	a5,0(a0)
 484:	cf91                	beqz	a5,4a0 <strchr+0x26>
    if(*s == c)
 486:	00f58a63          	beq	a1,a5,49a <strchr+0x20>
  for(; *s; s++)
 48a:	0505                	addi	a0,a0,1
 48c:	00054783          	lbu	a5,0(a0)
 490:	c781                	beqz	a5,498 <strchr+0x1e>
    if(*s == c)
 492:	feb79ce3          	bne	a5,a1,48a <strchr+0x10>
 496:	a011                	j	49a <strchr+0x20>
      return (char*)s;
  return 0;
 498:	4501                	li	a0,0
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
  return 0;
 4a0:	4501                	li	a0,0
 4a2:	bfe5                	j	49a <strchr+0x20>

00000000000004a4 <gets>:

char*
gets(char *buf, int max)
{
 4a4:	711d                	addi	sp,sp,-96
 4a6:	ec86                	sd	ra,88(sp)
 4a8:	e8a2                	sd	s0,80(sp)
 4aa:	e4a6                	sd	s1,72(sp)
 4ac:	e0ca                	sd	s2,64(sp)
 4ae:	fc4e                	sd	s3,56(sp)
 4b0:	f852                	sd	s4,48(sp)
 4b2:	f456                	sd	s5,40(sp)
 4b4:	f05a                	sd	s6,32(sp)
 4b6:	ec5e                	sd	s7,24(sp)
 4b8:	1080                	addi	s0,sp,96
 4ba:	8baa                	mv	s7,a0
 4bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4be:	892a                	mv	s2,a0
 4c0:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4c2:	4aa9                	li	s5,10
 4c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4c6:	0019849b          	addiw	s1,s3,1
 4ca:	0344d863          	ble	s4,s1,4fa <gets+0x56>
    cc = read(0, &c, 1);
 4ce:	4605                	li	a2,1
 4d0:	faf40593          	addi	a1,s0,-81
 4d4:	4501                	li	a0,0
 4d6:	00000097          	auipc	ra,0x0
 4da:	1ac080e7          	jalr	428(ra) # 682 <read>
    if(cc < 1)
 4de:	00a05e63          	blez	a0,4fa <gets+0x56>
    buf[i++] = c;
 4e2:	faf44783          	lbu	a5,-81(s0)
 4e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4ea:	01578763          	beq	a5,s5,4f8 <gets+0x54>
 4ee:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 4f0:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 4f2:	fd679ae3          	bne	a5,s6,4c6 <gets+0x22>
 4f6:	a011                	j	4fa <gets+0x56>
  for(i=0; i+1 < max; ){
 4f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4fa:	99de                	add	s3,s3,s7
 4fc:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 500:	855e                	mv	a0,s7
 502:	60e6                	ld	ra,88(sp)
 504:	6446                	ld	s0,80(sp)
 506:	64a6                	ld	s1,72(sp)
 508:	6906                	ld	s2,64(sp)
 50a:	79e2                	ld	s3,56(sp)
 50c:	7a42                	ld	s4,48(sp)
 50e:	7aa2                	ld	s5,40(sp)
 510:	7b02                	ld	s6,32(sp)
 512:	6be2                	ld	s7,24(sp)
 514:	6125                	addi	sp,sp,96
 516:	8082                	ret

0000000000000518 <stat>:

int
stat(const char *n, struct stat *st)
{
 518:	1101                	addi	sp,sp,-32
 51a:	ec06                	sd	ra,24(sp)
 51c:	e822                	sd	s0,16(sp)
 51e:	e426                	sd	s1,8(sp)
 520:	e04a                	sd	s2,0(sp)
 522:	1000                	addi	s0,sp,32
 524:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 526:	4581                	li	a1,0
 528:	00000097          	auipc	ra,0x0
 52c:	182080e7          	jalr	386(ra) # 6aa <open>
  if(fd < 0)
 530:	02054563          	bltz	a0,55a <stat+0x42>
 534:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 536:	85ca                	mv	a1,s2
 538:	00000097          	auipc	ra,0x0
 53c:	18a080e7          	jalr	394(ra) # 6c2 <fstat>
 540:	892a                	mv	s2,a0
  close(fd);
 542:	8526                	mv	a0,s1
 544:	00000097          	auipc	ra,0x0
 548:	14e080e7          	jalr	334(ra) # 692 <close>
  return r;
}
 54c:	854a                	mv	a0,s2
 54e:	60e2                	ld	ra,24(sp)
 550:	6442                	ld	s0,16(sp)
 552:	64a2                	ld	s1,8(sp)
 554:	6902                	ld	s2,0(sp)
 556:	6105                	addi	sp,sp,32
 558:	8082                	ret
    return -1;
 55a:	597d                	li	s2,-1
 55c:	bfc5                	j	54c <stat+0x34>

000000000000055e <atoi>:

int
atoi(const char *s)
{
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 564:	00054683          	lbu	a3,0(a0)
 568:	fd06879b          	addiw	a5,a3,-48
 56c:	0ff7f793          	andi	a5,a5,255
 570:	4725                	li	a4,9
 572:	02f76963          	bltu	a4,a5,5a4 <atoi+0x46>
 576:	862a                	mv	a2,a0
  n = 0;
 578:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 57a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 57c:	0605                	addi	a2,a2,1
 57e:	0025179b          	slliw	a5,a0,0x2
 582:	9fa9                	addw	a5,a5,a0
 584:	0017979b          	slliw	a5,a5,0x1
 588:	9fb5                	addw	a5,a5,a3
 58a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 58e:	00064683          	lbu	a3,0(a2)
 592:	fd06871b          	addiw	a4,a3,-48
 596:	0ff77713          	andi	a4,a4,255
 59a:	fee5f1e3          	bleu	a4,a1,57c <atoi+0x1e>
  return n;
}
 59e:	6422                	ld	s0,8(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret
  n = 0;
 5a4:	4501                	li	a0,0
 5a6:	bfe5                	j	59e <atoi+0x40>

00000000000005a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a8:	1141                	addi	sp,sp,-16
 5aa:	e422                	sd	s0,8(sp)
 5ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5ae:	02b57663          	bleu	a1,a0,5da <memmove+0x32>
    while(n-- > 0)
 5b2:	02c05163          	blez	a2,5d4 <memmove+0x2c>
 5b6:	fff6079b          	addiw	a5,a2,-1
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	0785                	addi	a5,a5,1
 5c0:	97aa                	add	a5,a5,a0
  dst = vdst;
 5c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5c4:	0585                	addi	a1,a1,1
 5c6:	0705                	addi	a4,a4,1
 5c8:	fff5c683          	lbu	a3,-1(a1)
 5cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5d0:	fee79ae3          	bne	a5,a4,5c4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5d4:	6422                	ld	s0,8(sp)
 5d6:	0141                	addi	sp,sp,16
 5d8:	8082                	ret
    dst += n;
 5da:	00c50733          	add	a4,a0,a2
    src += n;
 5de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5e0:	fec05ae3          	blez	a2,5d4 <memmove+0x2c>
 5e4:	fff6079b          	addiw	a5,a2,-1
 5e8:	1782                	slli	a5,a5,0x20
 5ea:	9381                	srli	a5,a5,0x20
 5ec:	fff7c793          	not	a5,a5
 5f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5f2:	15fd                	addi	a1,a1,-1
 5f4:	177d                	addi	a4,a4,-1
 5f6:	0005c683          	lbu	a3,0(a1)
 5fa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5fe:	fef71ae3          	bne	a4,a5,5f2 <memmove+0x4a>
 602:	bfc9                	j	5d4 <memmove+0x2c>

0000000000000604 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 604:	1141                	addi	sp,sp,-16
 606:	e422                	sd	s0,8(sp)
 608:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 60a:	ce15                	beqz	a2,646 <memcmp+0x42>
 60c:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 610:	00054783          	lbu	a5,0(a0)
 614:	0005c703          	lbu	a4,0(a1)
 618:	02e79063          	bne	a5,a4,638 <memcmp+0x34>
 61c:	1682                	slli	a3,a3,0x20
 61e:	9281                	srli	a3,a3,0x20
 620:	0685                	addi	a3,a3,1
 622:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 624:	0505                	addi	a0,a0,1
    p2++;
 626:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 628:	00d50d63          	beq	a0,a3,642 <memcmp+0x3e>
    if (*p1 != *p2) {
 62c:	00054783          	lbu	a5,0(a0)
 630:	0005c703          	lbu	a4,0(a1)
 634:	fee788e3          	beq	a5,a4,624 <memcmp+0x20>
      return *p1 - *p2;
 638:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 63c:	6422                	ld	s0,8(sp)
 63e:	0141                	addi	sp,sp,16
 640:	8082                	ret
  return 0;
 642:	4501                	li	a0,0
 644:	bfe5                	j	63c <memcmp+0x38>
 646:	4501                	li	a0,0
 648:	bfd5                	j	63c <memcmp+0x38>

000000000000064a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 64a:	1141                	addi	sp,sp,-16
 64c:	e406                	sd	ra,8(sp)
 64e:	e022                	sd	s0,0(sp)
 650:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 652:	00000097          	auipc	ra,0x0
 656:	f56080e7          	jalr	-170(ra) # 5a8 <memmove>
}
 65a:	60a2                	ld	ra,8(sp)
 65c:	6402                	ld	s0,0(sp)
 65e:	0141                	addi	sp,sp,16
 660:	8082                	ret

0000000000000662 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 662:	4885                	li	a7,1
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <exit>:
.global exit
exit:
 li a7, SYS_exit
 66a:	4889                	li	a7,2
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <wait>:
.global wait
wait:
 li a7, SYS_wait
 672:	488d                	li	a7,3
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 67a:	4891                	li	a7,4
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <read>:
.global read
read:
 li a7, SYS_read
 682:	4895                	li	a7,5
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <write>:
.global write
write:
 li a7, SYS_write
 68a:	48c1                	li	a7,16
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <close>:
.global close
close:
 li a7, SYS_close
 692:	48d5                	li	a7,21
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <kill>:
.global kill
kill:
 li a7, SYS_kill
 69a:	4899                	li	a7,6
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6a2:	489d                	li	a7,7
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <open>:
.global open
open:
 li a7, SYS_open
 6aa:	48bd                	li	a7,15
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6b2:	48c5                	li	a7,17
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6ba:	48c9                	li	a7,18
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6c2:	48a1                	li	a7,8
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <link>:
.global link
link:
 li a7, SYS_link
 6ca:	48cd                	li	a7,19
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6d2:	48d1                	li	a7,20
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6da:	48a5                	li	a7,9
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6e2:	48a9                	li	a7,10
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ea:	48ad                	li	a7,11
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6f2:	48b1                	li	a7,12
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6fa:	48b5                	li	a7,13
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 702:	48b9                	li	a7,14
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <trace>:
.global trace
trace:
 li a7, SYS_trace
 70a:	48d9                	li	a7,22
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 712:	48dd                	li	a7,23
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 71a:	1101                	addi	sp,sp,-32
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 726:	4605                	li	a2,1
 728:	fef40593          	addi	a1,s0,-17
 72c:	00000097          	auipc	ra,0x0
 730:	f5e080e7          	jalr	-162(ra) # 68a <write>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6105                	addi	sp,sp,32
 73a:	8082                	ret

000000000000073c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73c:	7139                	addi	sp,sp,-64
 73e:	fc06                	sd	ra,56(sp)
 740:	f822                	sd	s0,48(sp)
 742:	f426                	sd	s1,40(sp)
 744:	f04a                	sd	s2,32(sp)
 746:	ec4e                	sd	s3,24(sp)
 748:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 74a:	c299                	beqz	a3,750 <printint+0x14>
 74c:	0005cd63          	bltz	a1,766 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 750:	2581                	sext.w	a1,a1
  neg = 0;
 752:	4301                	li	t1,0
 754:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 758:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 75a:	2601                	sext.w	a2,a2
 75c:	00000897          	auipc	a7,0x0
 760:	5d488893          	addi	a7,a7,1492 # d30 <digits>
 764:	a801                	j	774 <printint+0x38>
    x = -xx;
 766:	40b005bb          	negw	a1,a1
 76a:	2581                	sext.w	a1,a1
    neg = 1;
 76c:	4305                	li	t1,1
    x = -xx;
 76e:	b7dd                	j	754 <printint+0x18>
  }while((x /= base) != 0);
 770:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 772:	8836                	mv	a6,a3
 774:	0018069b          	addiw	a3,a6,1
 778:	02c5f7bb          	remuw	a5,a1,a2
 77c:	1782                	slli	a5,a5,0x20
 77e:	9381                	srli	a5,a5,0x20
 780:	97c6                	add	a5,a5,a7
 782:	0007c783          	lbu	a5,0(a5)
 786:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 78a:	0705                	addi	a4,a4,1
 78c:	02c5d7bb          	divuw	a5,a1,a2
 790:	fec5f0e3          	bleu	a2,a1,770 <printint+0x34>
  if(neg)
 794:	00030b63          	beqz	t1,7aa <printint+0x6e>
    buf[i++] = '-';
 798:	fd040793          	addi	a5,s0,-48
 79c:	96be                	add	a3,a3,a5
 79e:	02d00793          	li	a5,45
 7a2:	fef68823          	sb	a5,-16(a3)
 7a6:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 7aa:	02d05963          	blez	a3,7dc <printint+0xa0>
 7ae:	89aa                	mv	s3,a0
 7b0:	fc040793          	addi	a5,s0,-64
 7b4:	00d784b3          	add	s1,a5,a3
 7b8:	fff78913          	addi	s2,a5,-1
 7bc:	9936                	add	s2,s2,a3
 7be:	36fd                	addiw	a3,a3,-1
 7c0:	1682                	slli	a3,a3,0x20
 7c2:	9281                	srli	a3,a3,0x20
 7c4:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 7c8:	fff4c583          	lbu	a1,-1(s1)
 7cc:	854e                	mv	a0,s3
 7ce:	00000097          	auipc	ra,0x0
 7d2:	f4c080e7          	jalr	-180(ra) # 71a <putc>
  while(--i >= 0)
 7d6:	14fd                	addi	s1,s1,-1
 7d8:	ff2498e3          	bne	s1,s2,7c8 <printint+0x8c>
}
 7dc:	70e2                	ld	ra,56(sp)
 7de:	7442                	ld	s0,48(sp)
 7e0:	74a2                	ld	s1,40(sp)
 7e2:	7902                	ld	s2,32(sp)
 7e4:	69e2                	ld	s3,24(sp)
 7e6:	6121                	addi	sp,sp,64
 7e8:	8082                	ret

00000000000007ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ea:	7119                	addi	sp,sp,-128
 7ec:	fc86                	sd	ra,120(sp)
 7ee:	f8a2                	sd	s0,112(sp)
 7f0:	f4a6                	sd	s1,104(sp)
 7f2:	f0ca                	sd	s2,96(sp)
 7f4:	ecce                	sd	s3,88(sp)
 7f6:	e8d2                	sd	s4,80(sp)
 7f8:	e4d6                	sd	s5,72(sp)
 7fa:	e0da                	sd	s6,64(sp)
 7fc:	fc5e                	sd	s7,56(sp)
 7fe:	f862                	sd	s8,48(sp)
 800:	f466                	sd	s9,40(sp)
 802:	f06a                	sd	s10,32(sp)
 804:	ec6e                	sd	s11,24(sp)
 806:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 808:	0005c483          	lbu	s1,0(a1)
 80c:	18048d63          	beqz	s1,9a6 <vprintf+0x1bc>
 810:	8aaa                	mv	s5,a0
 812:	8b32                	mv	s6,a2
 814:	00158913          	addi	s2,a1,1
  state = 0;
 818:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 81a:	02500a13          	li	s4,37
      if(c == 'd'){
 81e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 822:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 826:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 82a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82e:	00000b97          	auipc	s7,0x0
 832:	502b8b93          	addi	s7,s7,1282 # d30 <digits>
 836:	a839                	j	854 <vprintf+0x6a>
        putc(fd, c);
 838:	85a6                	mv	a1,s1
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	ede080e7          	jalr	-290(ra) # 71a <putc>
 844:	a019                	j	84a <vprintf+0x60>
    } else if(state == '%'){
 846:	01498f63          	beq	s3,s4,864 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 84a:	0905                	addi	s2,s2,1
 84c:	fff94483          	lbu	s1,-1(s2)
 850:	14048b63          	beqz	s1,9a6 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 854:	0004879b          	sext.w	a5,s1
    if(state == 0){
 858:	fe0997e3          	bnez	s3,846 <vprintf+0x5c>
      if(c == '%'){
 85c:	fd479ee3          	bne	a5,s4,838 <vprintf+0x4e>
        state = '%';
 860:	89be                	mv	s3,a5
 862:	b7e5                	j	84a <vprintf+0x60>
      if(c == 'd'){
 864:	05878063          	beq	a5,s8,8a4 <vprintf+0xba>
      } else if(c == 'l') {
 868:	05978c63          	beq	a5,s9,8c0 <vprintf+0xd6>
      } else if(c == 'x') {
 86c:	07a78863          	beq	a5,s10,8dc <vprintf+0xf2>
      } else if(c == 'p') {
 870:	09b78463          	beq	a5,s11,8f8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 874:	07300713          	li	a4,115
 878:	0ce78563          	beq	a5,a4,942 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 87c:	06300713          	li	a4,99
 880:	0ee78c63          	beq	a5,a4,978 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 884:	11478663          	beq	a5,s4,990 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 888:	85d2                	mv	a1,s4
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e8e080e7          	jalr	-370(ra) # 71a <putc>
        putc(fd, c);
 894:	85a6                	mv	a1,s1
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	e82080e7          	jalr	-382(ra) # 71a <putc>
      }
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b765                	j	84a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8a4:	008b0493          	addi	s1,s6,8
 8a8:	4685                	li	a3,1
 8aa:	4629                	li	a2,10
 8ac:	000b2583          	lw	a1,0(s6)
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	e8a080e7          	jalr	-374(ra) # 73c <printint>
 8ba:	8b26                	mv	s6,s1
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	b771                	j	84a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c0:	008b0493          	addi	s1,s6,8
 8c4:	4681                	li	a3,0
 8c6:	4629                	li	a2,10
 8c8:	000b2583          	lw	a1,0(s6)
 8cc:	8556                	mv	a0,s5
 8ce:	00000097          	auipc	ra,0x0
 8d2:	e6e080e7          	jalr	-402(ra) # 73c <printint>
 8d6:	8b26                	mv	s6,s1
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	bf85                	j	84a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8dc:	008b0493          	addi	s1,s6,8
 8e0:	4681                	li	a3,0
 8e2:	4641                	li	a2,16
 8e4:	000b2583          	lw	a1,0(s6)
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	e52080e7          	jalr	-430(ra) # 73c <printint>
 8f2:	8b26                	mv	s6,s1
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	bf91                	j	84a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8f8:	008b0793          	addi	a5,s6,8
 8fc:	f8f43423          	sd	a5,-120(s0)
 900:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 904:	03000593          	li	a1,48
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	e10080e7          	jalr	-496(ra) # 71a <putc>
  putc(fd, 'x');
 912:	85ea                	mv	a1,s10
 914:	8556                	mv	a0,s5
 916:	00000097          	auipc	ra,0x0
 91a:	e04080e7          	jalr	-508(ra) # 71a <putc>
 91e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 920:	03c9d793          	srli	a5,s3,0x3c
 924:	97de                	add	a5,a5,s7
 926:	0007c583          	lbu	a1,0(a5)
 92a:	8556                	mv	a0,s5
 92c:	00000097          	auipc	ra,0x0
 930:	dee080e7          	jalr	-530(ra) # 71a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 934:	0992                	slli	s3,s3,0x4
 936:	34fd                	addiw	s1,s1,-1
 938:	f4e5                	bnez	s1,920 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 93a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 93e:	4981                	li	s3,0
 940:	b729                	j	84a <vprintf+0x60>
        s = va_arg(ap, char*);
 942:	008b0993          	addi	s3,s6,8
 946:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 94a:	c085                	beqz	s1,96a <vprintf+0x180>
        while(*s != 0){
 94c:	0004c583          	lbu	a1,0(s1)
 950:	c9a1                	beqz	a1,9a0 <vprintf+0x1b6>
          putc(fd, *s);
 952:	8556                	mv	a0,s5
 954:	00000097          	auipc	ra,0x0
 958:	dc6080e7          	jalr	-570(ra) # 71a <putc>
          s++;
 95c:	0485                	addi	s1,s1,1
        while(*s != 0){
 95e:	0004c583          	lbu	a1,0(s1)
 962:	f9e5                	bnez	a1,952 <vprintf+0x168>
        s = va_arg(ap, char*);
 964:	8b4e                	mv	s6,s3
      state = 0;
 966:	4981                	li	s3,0
 968:	b5cd                	j	84a <vprintf+0x60>
          s = "(null)";
 96a:	00000497          	auipc	s1,0x0
 96e:	3de48493          	addi	s1,s1,990 # d48 <digits+0x18>
        while(*s != 0){
 972:	02800593          	li	a1,40
 976:	bff1                	j	952 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 978:	008b0493          	addi	s1,s6,8
 97c:	000b4583          	lbu	a1,0(s6)
 980:	8556                	mv	a0,s5
 982:	00000097          	auipc	ra,0x0
 986:	d98080e7          	jalr	-616(ra) # 71a <putc>
 98a:	8b26                	mv	s6,s1
      state = 0;
 98c:	4981                	li	s3,0
 98e:	bd75                	j	84a <vprintf+0x60>
        putc(fd, c);
 990:	85d2                	mv	a1,s4
 992:	8556                	mv	a0,s5
 994:	00000097          	auipc	ra,0x0
 998:	d86080e7          	jalr	-634(ra) # 71a <putc>
      state = 0;
 99c:	4981                	li	s3,0
 99e:	b575                	j	84a <vprintf+0x60>
        s = va_arg(ap, char*);
 9a0:	8b4e                	mv	s6,s3
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	b55d                	j	84a <vprintf+0x60>
    }
  }
}
 9a6:	70e6                	ld	ra,120(sp)
 9a8:	7446                	ld	s0,112(sp)
 9aa:	74a6                	ld	s1,104(sp)
 9ac:	7906                	ld	s2,96(sp)
 9ae:	69e6                	ld	s3,88(sp)
 9b0:	6a46                	ld	s4,80(sp)
 9b2:	6aa6                	ld	s5,72(sp)
 9b4:	6b06                	ld	s6,64(sp)
 9b6:	7be2                	ld	s7,56(sp)
 9b8:	7c42                	ld	s8,48(sp)
 9ba:	7ca2                	ld	s9,40(sp)
 9bc:	7d02                	ld	s10,32(sp)
 9be:	6de2                	ld	s11,24(sp)
 9c0:	6109                	addi	sp,sp,128
 9c2:	8082                	ret

00000000000009c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c4:	715d                	addi	sp,sp,-80
 9c6:	ec06                	sd	ra,24(sp)
 9c8:	e822                	sd	s0,16(sp)
 9ca:	1000                	addi	s0,sp,32
 9cc:	e010                	sd	a2,0(s0)
 9ce:	e414                	sd	a3,8(s0)
 9d0:	e818                	sd	a4,16(s0)
 9d2:	ec1c                	sd	a5,24(s0)
 9d4:	03043023          	sd	a6,32(s0)
 9d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9e0:	8622                	mv	a2,s0
 9e2:	00000097          	auipc	ra,0x0
 9e6:	e08080e7          	jalr	-504(ra) # 7ea <vprintf>
}
 9ea:	60e2                	ld	ra,24(sp)
 9ec:	6442                	ld	s0,16(sp)
 9ee:	6161                	addi	sp,sp,80
 9f0:	8082                	ret

00000000000009f2 <printf>:

void
printf(const char *fmt, ...)
{
 9f2:	711d                	addi	sp,sp,-96
 9f4:	ec06                	sd	ra,24(sp)
 9f6:	e822                	sd	s0,16(sp)
 9f8:	1000                	addi	s0,sp,32
 9fa:	e40c                	sd	a1,8(s0)
 9fc:	e810                	sd	a2,16(s0)
 9fe:	ec14                	sd	a3,24(s0)
 a00:	f018                	sd	a4,32(s0)
 a02:	f41c                	sd	a5,40(s0)
 a04:	03043823          	sd	a6,48(s0)
 a08:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a0c:	00840613          	addi	a2,s0,8
 a10:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a14:	85aa                	mv	a1,a0
 a16:	4505                	li	a0,1
 a18:	00000097          	auipc	ra,0x0
 a1c:	dd2080e7          	jalr	-558(ra) # 7ea <vprintf>
}
 a20:	60e2                	ld	ra,24(sp)
 a22:	6442                	ld	s0,16(sp)
 a24:	6125                	addi	sp,sp,96
 a26:	8082                	ret

0000000000000a28 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a28:	1141                	addi	sp,sp,-16
 a2a:	e422                	sd	s0,8(sp)
 a2c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a32:	00000797          	auipc	a5,0x0
 a36:	5ce78793          	addi	a5,a5,1486 # 1000 <freep>
 a3a:	639c                	ld	a5,0(a5)
 a3c:	a805                	j	a6c <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a3e:	4618                	lw	a4,8(a2)
 a40:	9db9                	addw	a1,a1,a4
 a42:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a46:	6398                	ld	a4,0(a5)
 a48:	6318                	ld	a4,0(a4)
 a4a:	fee53823          	sd	a4,-16(a0)
 a4e:	a091                	j	a92 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a50:	ff852703          	lw	a4,-8(a0)
 a54:	9e39                	addw	a2,a2,a4
 a56:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a58:	ff053703          	ld	a4,-16(a0)
 a5c:	e398                	sd	a4,0(a5)
 a5e:	a099                	j	aa4 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a60:	6398                	ld	a4,0(a5)
 a62:	00e7e463          	bltu	a5,a4,a6a <free+0x42>
 a66:	00e6ea63          	bltu	a3,a4,a7a <free+0x52>
{
 a6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6c:	fed7fae3          	bleu	a3,a5,a60 <free+0x38>
 a70:	6398                	ld	a4,0(a5)
 a72:	00e6e463          	bltu	a3,a4,a7a <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a76:	fee7eae3          	bltu	a5,a4,a6a <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 a7a:	ff852583          	lw	a1,-8(a0)
 a7e:	6390                	ld	a2,0(a5)
 a80:	02059713          	slli	a4,a1,0x20
 a84:	9301                	srli	a4,a4,0x20
 a86:	0712                	slli	a4,a4,0x4
 a88:	9736                	add	a4,a4,a3
 a8a:	fae60ae3          	beq	a2,a4,a3e <free+0x16>
    bp->s.ptr = p->s.ptr;
 a8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a92:	4790                	lw	a2,8(a5)
 a94:	02061713          	slli	a4,a2,0x20
 a98:	9301                	srli	a4,a4,0x20
 a9a:	0712                	slli	a4,a4,0x4
 a9c:	973e                	add	a4,a4,a5
 a9e:	fae689e3          	beq	a3,a4,a50 <free+0x28>
  } else
    p->s.ptr = bp;
 aa2:	e394                	sd	a3,0(a5)
  freep = p;
 aa4:	00000717          	auipc	a4,0x0
 aa8:	54f73e23          	sd	a5,1372(a4) # 1000 <freep>
}
 aac:	6422                	ld	s0,8(sp)
 aae:	0141                	addi	sp,sp,16
 ab0:	8082                	ret

0000000000000ab2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ab2:	7139                	addi	sp,sp,-64
 ab4:	fc06                	sd	ra,56(sp)
 ab6:	f822                	sd	s0,48(sp)
 ab8:	f426                	sd	s1,40(sp)
 aba:	f04a                	sd	s2,32(sp)
 abc:	ec4e                	sd	s3,24(sp)
 abe:	e852                	sd	s4,16(sp)
 ac0:	e456                	sd	s5,8(sp)
 ac2:	e05a                	sd	s6,0(sp)
 ac4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac6:	02051993          	slli	s3,a0,0x20
 aca:	0209d993          	srli	s3,s3,0x20
 ace:	09bd                	addi	s3,s3,15
 ad0:	0049d993          	srli	s3,s3,0x4
 ad4:	2985                	addiw	s3,s3,1
 ad6:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 ada:	00000797          	auipc	a5,0x0
 ade:	52678793          	addi	a5,a5,1318 # 1000 <freep>
 ae2:	6388                	ld	a0,0(a5)
 ae4:	c515                	beqz	a0,b10 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ae8:	4798                	lw	a4,8(a5)
 aea:	03277f63          	bleu	s2,a4,b28 <malloc+0x76>
 aee:	8a4e                	mv	s4,s3
 af0:	0009871b          	sext.w	a4,s3
 af4:	6685                	lui	a3,0x1
 af6:	00d77363          	bleu	a3,a4,afc <malloc+0x4a>
 afa:	6a05                	lui	s4,0x1
 afc:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 b00:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b04:	00000497          	auipc	s1,0x0
 b08:	4fc48493          	addi	s1,s1,1276 # 1000 <freep>
  if(p == (char*)-1)
 b0c:	5b7d                	li	s6,-1
 b0e:	a885                	j	b7e <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 b10:	00000797          	auipc	a5,0x0
 b14:	50078793          	addi	a5,a5,1280 # 1010 <base>
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ef73423          	sd	a5,1256(a4) # 1000 <freep>
 b20:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b22:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b26:	b7e1                	j	aee <malloc+0x3c>
      if(p->s.size == nunits)
 b28:	02e90b63          	beq	s2,a4,b5e <malloc+0xac>
        p->s.size -= nunits;
 b2c:	4137073b          	subw	a4,a4,s3
 b30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b32:	1702                	slli	a4,a4,0x20
 b34:	9301                	srli	a4,a4,0x20
 b36:	0712                	slli	a4,a4,0x4
 b38:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b3a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b3e:	00000717          	auipc	a4,0x0
 b42:	4ca73123          	sd	a0,1218(a4) # 1000 <freep>
      return (void*)(p + 1);
 b46:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b4a:	70e2                	ld	ra,56(sp)
 b4c:	7442                	ld	s0,48(sp)
 b4e:	74a2                	ld	s1,40(sp)
 b50:	7902                	ld	s2,32(sp)
 b52:	69e2                	ld	s3,24(sp)
 b54:	6a42                	ld	s4,16(sp)
 b56:	6aa2                	ld	s5,8(sp)
 b58:	6b02                	ld	s6,0(sp)
 b5a:	6121                	addi	sp,sp,64
 b5c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b5e:	6398                	ld	a4,0(a5)
 b60:	e118                	sd	a4,0(a0)
 b62:	bff1                	j	b3e <malloc+0x8c>
  hp->s.size = nu;
 b64:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 b68:	0541                	addi	a0,a0,16
 b6a:	00000097          	auipc	ra,0x0
 b6e:	ebe080e7          	jalr	-322(ra) # a28 <free>
  return freep;
 b72:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b74:	d979                	beqz	a0,b4a <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b78:	4798                	lw	a4,8(a5)
 b7a:	fb2777e3          	bleu	s2,a4,b28 <malloc+0x76>
    if(p == freep)
 b7e:	6098                	ld	a4,0(s1)
 b80:	853e                	mv	a0,a5
 b82:	fef71ae3          	bne	a4,a5,b76 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 b86:	8552                	mv	a0,s4
 b88:	00000097          	auipc	ra,0x0
 b8c:	b6a080e7          	jalr	-1174(ra) # 6f2 <sbrk>
  if(p == (char*)-1)
 b90:	fd651ae3          	bne	a0,s6,b64 <malloc+0xb2>
        return 0;
 b94:	4501                	li	a0,0
 b96:	bf55                	j	b4a <malloc+0x98>
