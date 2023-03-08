
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	35e58593          	addi	a1,a1,862 # 1370 <malloc+0x122>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e0a080e7          	jalr	-502(ra) # e26 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bc6080e7          	jalr	-1082(ra) # bf0 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c0a080e7          	jalr	-1014(ra) # c40 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
      46:	40a0053b          	negw	a0,a0
    return -1;
  return 0;
}
      4a:	2501                	sext.w	a0,a0
      4c:	60e2                	ld	ra,24(sp)
      4e:	6442                	ld	s0,16(sp)
      50:	64a2                	ld	s1,8(sp)
      52:	6902                	ld	s2,0(sp)
      54:	6105                	addi	sp,sp,32
      56:	8082                	ret

0000000000000058 <panic>:
  exit(0);
}

void
panic(char *s)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
  fprintf(2, "%s\n", s);
      60:	862a                	mv	a2,a0
      62:	00001597          	auipc	a1,0x1
      66:	31658593          	addi	a1,a1,790 # 1378 <malloc+0x12a>
      6a:	4509                	li	a0,2
      6c:	00001097          	auipc	ra,0x1
      70:	0f4080e7          	jalr	244(ra) # 1160 <fprintf>
  exit(1);
      74:	4505                	li	a0,1
      76:	00001097          	auipc	ra,0x1
      7a:	d90080e7          	jalr	-624(ra) # e06 <exit>

000000000000007e <fork1>:
}

int
fork1(void)
{
      7e:	1141                	addi	sp,sp,-16
      80:	e406                	sd	ra,8(sp)
      82:	e022                	sd	s0,0(sp)
      84:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      86:	00001097          	auipc	ra,0x1
      8a:	d78080e7          	jalr	-648(ra) # dfe <fork>
  if(pid == -1)
      8e:	57fd                	li	a5,-1
      90:	00f50663          	beq	a0,a5,9c <fork1+0x1e>
    panic("fork");
  return pid;
}
      94:	60a2                	ld	ra,8(sp)
      96:	6402                	ld	s0,0(sp)
      98:	0141                	addi	sp,sp,16
      9a:	8082                	ret
    panic("fork");
      9c:	00001517          	auipc	a0,0x1
      a0:	2e450513          	addi	a0,a0,740 # 1380 <malloc+0x132>
      a4:	00000097          	auipc	ra,0x0
      a8:	fb4080e7          	jalr	-76(ra) # 58 <panic>

00000000000000ac <runcmd>:
{
      ac:	7179                	addi	sp,sp,-48
      ae:	f406                	sd	ra,40(sp)
      b0:	f022                	sd	s0,32(sp)
      b2:	ec26                	sd	s1,24(sp)
      b4:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b6:	c10d                	beqz	a0,d8 <runcmd+0x2c>
      b8:	84aa                	mv	s1,a0
  switch(cmd->type){
      ba:	4118                	lw	a4,0(a0)
      bc:	4795                	li	a5,5
      be:	02e7e263          	bltu	a5,a4,e2 <runcmd+0x36>
      c2:	00056783          	lwu	a5,0(a0)
      c6:	078a                	slli	a5,a5,0x2
      c8:	00001717          	auipc	a4,0x1
      cc:	27870713          	addi	a4,a4,632 # 1340 <malloc+0xf2>
      d0:	97ba                	add	a5,a5,a4
      d2:	439c                	lw	a5,0(a5)
      d4:	97ba                	add	a5,a5,a4
      d6:	8782                	jr	a5
    exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	d2c080e7          	jalr	-724(ra) # e06 <exit>
    panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	2a650513          	addi	a0,a0,678 # 1388 <malloc+0x13a>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6e080e7          	jalr	-146(ra) # 58 <panic>
    if(ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	d44080e7          	jalr	-700(ra) # e3e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	28c58593          	addi	a1,a1,652 # 1390 <malloc+0x142>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	052080e7          	jalr	82(ra) # 1160 <fprintf>
  exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	cee080e7          	jalr	-786(ra) # e06 <exit>
      exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	ce4080e7          	jalr	-796(ra) # e06 <exit>
    close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	d02080e7          	jalr	-766(ra) # e2e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	d0e080e7          	jalr	-754(ra) # e46 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa2>
    runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f66080e7          	jalr	-154(ra) # ac <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	25058593          	addi	a1,a1,592 # 13a0 <malloc+0x152>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	006080e7          	jalr	6(ra) # 1160 <fprintf>
      exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	ca2080e7          	jalr	-862(ra) # e06 <exit>
    if(fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f12080e7          	jalr	-238(ra) # 7e <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd4>
      runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f34080e7          	jalr	-204(ra) # ac <runcmd>
    wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	c8c080e7          	jalr	-884(ra) # e0e <wait>
    runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f20080e7          	jalr	-224(ra) # ac <runcmd>
    if(pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	c7e080e7          	jalr	-898(ra) # e16 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13a>
    if(fork1() == 0){
     1a4:	00000097          	auipc	ra,0x0
     1a8:	eda080e7          	jalr	-294(ra) # 7e <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14a>
      close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	c7e080e7          	jalr	-898(ra) # e2e <close>
      dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	cc2080e7          	jalr	-830(ra) # e7e <dup>
      close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	c66080e7          	jalr	-922(ra) # e2e <close>
      close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	c5a080e7          	jalr	-934(ra) # e2e <close>
      runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ece080e7          	jalr	-306(ra) # ac <runcmd>
      panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	1ca50513          	addi	a0,a0,458 # 13b0 <malloc+0x162>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e6a080e7          	jalr	-406(ra) # 58 <panic>
    if(fork1() == 0){
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e88080e7          	jalr	-376(ra) # 7e <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18a>
      close(0);
     200:	00001097          	auipc	ra,0x1
     204:	c2e080e7          	jalr	-978(ra) # e2e <close>
      dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	c72080e7          	jalr	-910(ra) # e7e <dup>
      close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	c16080e7          	jalr	-1002(ra) # e2e <close>
      close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	c0a080e7          	jalr	-1014(ra) # e2e <close>
      runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7e080e7          	jalr	-386(ra) # ac <runcmd>
    close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	bf4080e7          	jalr	-1036(ra) # e2e <close>
    close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	be8080e7          	jalr	-1048(ra) # e2e <close>
    wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	bbe080e7          	jalr	-1090(ra) # e0e <wait>
    wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	bb4080e7          	jalr	-1100(ra) # e0e <wait>
    break;
     262:	bd55                	j	116 <runcmd+0x6a>
    if(fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e1a080e7          	jalr	-486(ra) # 7e <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e3a080e7          	jalr	-454(ra) # ac <runcmd>

000000000000027a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	fc6080e7          	jalr	-58(ra) # 124e <malloc>
     290:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	958080e7          	jalr	-1704(ra) # bf0 <memset>
  cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	f7c080e7          	jalr	-132(ra) # 124e <malloc>
     2da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	90e080e7          	jalr	-1778(ra) # bf0 <memset>
  cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	f22080e7          	jalr	-222(ra) # 124e <malloc>
     334:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	8b6080e7          	jalr	-1866(ra) # bf0 <memset>
  cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	edc080e7          	jalr	-292(ra) # 124e <malloc>
     37a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	870080e7          	jalr	-1936(ra) # bf0 <memset>
  cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	e9a080e7          	jalr	-358(ra) # 124e <malloc>
     3bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	82e080e7          	jalr	-2002(ra) # bf0 <memset>
  cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fc:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	c0a98993          	addi	s3,s3,-1014 # 2008 <whitespace>
     406:	00b4fd63          	bleu	a1,s1,420 <gettoken+0x40>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	806080e7          	jalr	-2042(ra) # c16 <strchr>
     418:	c501                	beqz	a0,420 <gettoken+0x40>
    s++;
     41a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x48>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	02900713          	li	a4,41
     434:	08f76f63          	bltu	a4,a5,4d2 <gettoken+0xf2>
     438:	02800713          	li	a4,40
     43c:	0ae7f863          	bleu	a4,a5,4ec <gettoken+0x10c>
     440:	e3b9                	bnez	a5,486 <gettoken+0xa6>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     442:	000b0463          	beqz	s6,44a <gettoken+0x6a>
    *eq = s;
     446:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     44a:	00002997          	auipc	s3,0x2
     44e:	bbe98993          	addi	s3,s3,-1090 # 2008 <whitespace>
     452:	0124fd63          	bleu	s2,s1,46c <gettoken+0x8c>
     456:	0004c583          	lbu	a1,0(s1)
     45a:	854e                	mv	a0,s3
     45c:	00000097          	auipc	ra,0x0
     460:	7ba080e7          	jalr	1978(ra) # c16 <strchr>
     464:	c501                	beqz	a0,46c <gettoken+0x8c>
    s++;
     466:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     468:	fe9917e3          	bne	s2,s1,456 <gettoken+0x76>
  *ps = s;
     46c:	009a3023          	sd	s1,0(s4)
  return ret;
}
     470:	8556                	mv	a0,s5
     472:	70e2                	ld	ra,56(sp)
     474:	7442                	ld	s0,48(sp)
     476:	74a2                	ld	s1,40(sp)
     478:	7902                	ld	s2,32(sp)
     47a:	69e2                	ld	s3,24(sp)
     47c:	6a42                	ld	s4,16(sp)
     47e:	6aa2                	ld	s5,8(sp)
     480:	6b02                	ld	s6,0(sp)
     482:	6121                	addi	sp,sp,64
     484:	8082                	ret
  switch(*s){
     486:	02600713          	li	a4,38
     48a:	06e78163          	beq	a5,a4,4ec <gettoken+0x10c>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     48e:	00002997          	auipc	s3,0x2
     492:	b7a98993          	addi	s3,s3,-1158 # 2008 <whitespace>
     496:	00002a97          	auipc	s5,0x2
     49a:	b6aa8a93          	addi	s5,s5,-1174 # 2000 <symbols>
     49e:	0324f563          	bleu	s2,s1,4c8 <gettoken+0xe8>
     4a2:	0004c583          	lbu	a1,0(s1)
     4a6:	854e                	mv	a0,s3
     4a8:	00000097          	auipc	ra,0x0
     4ac:	76e080e7          	jalr	1902(ra) # c16 <strchr>
     4b0:	e53d                	bnez	a0,51e <gettoken+0x13e>
     4b2:	0004c583          	lbu	a1,0(s1)
     4b6:	8556                	mv	a0,s5
     4b8:	00000097          	auipc	ra,0x0
     4bc:	75e080e7          	jalr	1886(ra) # c16 <strchr>
     4c0:	ed21                	bnez	a0,518 <gettoken+0x138>
      s++;
     4c2:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c4:	fc991fe3          	bne	s2,s1,4a2 <gettoken+0xc2>
  if(eq)
     4c8:	06100a93          	li	s5,97
     4cc:	f60b1de3          	bnez	s6,446 <gettoken+0x66>
     4d0:	bf71                	j	46c <gettoken+0x8c>
  switch(*s){
     4d2:	03e00713          	li	a4,62
     4d6:	02e78263          	beq	a5,a4,4fa <gettoken+0x11a>
     4da:	00f76b63          	bltu	a4,a5,4f0 <gettoken+0x110>
     4de:	fc57879b          	addiw	a5,a5,-59
     4e2:	0ff7f793          	andi	a5,a5,255
     4e6:	4705                	li	a4,1
     4e8:	faf763e3          	bltu	a4,a5,48e <gettoken+0xae>
    s++;
     4ec:	0485                	addi	s1,s1,1
    break;
     4ee:	bf91                	j	442 <gettoken+0x62>
  switch(*s){
     4f0:	07c00713          	li	a4,124
     4f4:	fee78ce3          	beq	a5,a4,4ec <gettoken+0x10c>
     4f8:	bf59                	j	48e <gettoken+0xae>
    s++;
     4fa:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4fe:	0014c703          	lbu	a4,1(s1)
     502:	03e00793          	li	a5,62
      s++;
     506:	0489                	addi	s1,s1,2
      ret = '+';
     508:	02b00a93          	li	s5,43
    if(*s == '>'){
     50c:	f2f70be3          	beq	a4,a5,442 <gettoken+0x62>
    s++;
     510:	84b6                	mv	s1,a3
  ret = *s;
     512:	03e00a93          	li	s5,62
     516:	b735                	j	442 <gettoken+0x62>
    ret = 'a';
     518:	06100a93          	li	s5,97
     51c:	b71d                	j	442 <gettoken+0x62>
     51e:	06100a93          	li	s5,97
     522:	b705                	j	442 <gettoken+0x62>

0000000000000524 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     524:	7139                	addi	sp,sp,-64
     526:	fc06                	sd	ra,56(sp)
     528:	f822                	sd	s0,48(sp)
     52a:	f426                	sd	s1,40(sp)
     52c:	f04a                	sd	s2,32(sp)
     52e:	ec4e                	sd	s3,24(sp)
     530:	e852                	sd	s4,16(sp)
     532:	e456                	sd	s5,8(sp)
     534:	0080                	addi	s0,sp,64
     536:	8a2a                	mv	s4,a0
     538:	892e                	mv	s2,a1
     53a:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     53c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     53e:	00002997          	auipc	s3,0x2
     542:	aca98993          	addi	s3,s3,-1334 # 2008 <whitespace>
     546:	00b4fd63          	bleu	a1,s1,560 <peek+0x3c>
     54a:	0004c583          	lbu	a1,0(s1)
     54e:	854e                	mv	a0,s3
     550:	00000097          	auipc	ra,0x0
     554:	6c6080e7          	jalr	1734(ra) # c16 <strchr>
     558:	c501                	beqz	a0,560 <peek+0x3c>
    s++;
     55a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     55c:	fe9917e3          	bne	s2,s1,54a <peek+0x26>
  *ps = s;
     560:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     564:	0004c583          	lbu	a1,0(s1)
     568:	4501                	li	a0,0
     56a:	e991                	bnez	a1,57e <peek+0x5a>
}
     56c:	70e2                	ld	ra,56(sp)
     56e:	7442                	ld	s0,48(sp)
     570:	74a2                	ld	s1,40(sp)
     572:	7902                	ld	s2,32(sp)
     574:	69e2                	ld	s3,24(sp)
     576:	6a42                	ld	s4,16(sp)
     578:	6aa2                	ld	s5,8(sp)
     57a:	6121                	addi	sp,sp,64
     57c:	8082                	ret
  return *s && strchr(toks, *s);
     57e:	8556                	mv	a0,s5
     580:	00000097          	auipc	ra,0x0
     584:	696080e7          	jalr	1686(ra) # c16 <strchr>
     588:	00a03533          	snez	a0,a0
     58c:	b7c5                	j	56c <peek+0x48>

000000000000058e <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     58e:	7159                	addi	sp,sp,-112
     590:	f486                	sd	ra,104(sp)
     592:	f0a2                	sd	s0,96(sp)
     594:	eca6                	sd	s1,88(sp)
     596:	e8ca                	sd	s2,80(sp)
     598:	e4ce                	sd	s3,72(sp)
     59a:	e0d2                	sd	s4,64(sp)
     59c:	fc56                	sd	s5,56(sp)
     59e:	f85a                	sd	s6,48(sp)
     5a0:	f45e                	sd	s7,40(sp)
     5a2:	f062                	sd	s8,32(sp)
     5a4:	ec66                	sd	s9,24(sp)
     5a6:	1880                	addi	s0,sp,112
     5a8:	8b2a                	mv	s6,a0
     5aa:	89ae                	mv	s3,a1
     5ac:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5ae:	00001b97          	auipc	s7,0x1
     5b2:	e2ab8b93          	addi	s7,s7,-470 # 13d8 <malloc+0x18a>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5b6:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5ba:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5be:	a02d                	j	5e8 <parseredirs+0x5a>
      panic("missing file for redirection");
     5c0:	00001517          	auipc	a0,0x1
     5c4:	df850513          	addi	a0,a0,-520 # 13b8 <malloc+0x16a>
     5c8:	00000097          	auipc	ra,0x0
     5cc:	a90080e7          	jalr	-1392(ra) # 58 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d0:	4701                	li	a4,0
     5d2:	4681                	li	a3,0
     5d4:	f9043603          	ld	a2,-112(s0)
     5d8:	f9843583          	ld	a1,-104(s0)
     5dc:	855a                	mv	a0,s6
     5de:	00000097          	auipc	ra,0x0
     5e2:	cd2080e7          	jalr	-814(ra) # 2b0 <redircmd>
     5e6:	8b2a                	mv	s6,a0
    switch(tok){
     5e8:	03e00a93          	li	s5,62
     5ec:	02b00a13          	li	s4,43
  while(peek(ps, es, "<>")){
     5f0:	865e                	mv	a2,s7
     5f2:	85ca                	mv	a1,s2
     5f4:	854e                	mv	a0,s3
     5f6:	00000097          	auipc	ra,0x0
     5fa:	f2e080e7          	jalr	-210(ra) # 524 <peek>
     5fe:	c925                	beqz	a0,66e <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     600:	4681                	li	a3,0
     602:	4601                	li	a2,0
     604:	85ca                	mv	a1,s2
     606:	854e                	mv	a0,s3
     608:	00000097          	auipc	ra,0x0
     60c:	dd8080e7          	jalr	-552(ra) # 3e0 <gettoken>
     610:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     612:	f9040693          	addi	a3,s0,-112
     616:	f9840613          	addi	a2,s0,-104
     61a:	85ca                	mv	a1,s2
     61c:	854e                	mv	a0,s3
     61e:	00000097          	auipc	ra,0x0
     622:	dc2080e7          	jalr	-574(ra) # 3e0 <gettoken>
     626:	f9851de3          	bne	a0,s8,5c0 <parseredirs+0x32>
    switch(tok){
     62a:	fb9483e3          	beq	s1,s9,5d0 <parseredirs+0x42>
     62e:	03548263          	beq	s1,s5,652 <parseredirs+0xc4>
     632:	fb449fe3          	bne	s1,s4,5f0 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     636:	4705                	li	a4,1
     638:	20100693          	li	a3,513
     63c:	f9043603          	ld	a2,-112(s0)
     640:	f9843583          	ld	a1,-104(s0)
     644:	855a                	mv	a0,s6
     646:	00000097          	auipc	ra,0x0
     64a:	c6a080e7          	jalr	-918(ra) # 2b0 <redircmd>
     64e:	8b2a                	mv	s6,a0
      break;
     650:	bf61                	j	5e8 <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     652:	4705                	li	a4,1
     654:	60100693          	li	a3,1537
     658:	f9043603          	ld	a2,-112(s0)
     65c:	f9843583          	ld	a1,-104(s0)
     660:	855a                	mv	a0,s6
     662:	00000097          	auipc	ra,0x0
     666:	c4e080e7          	jalr	-946(ra) # 2b0 <redircmd>
     66a:	8b2a                	mv	s6,a0
      break;
     66c:	bfb5                	j	5e8 <parseredirs+0x5a>
    }
  }
  return cmd;
}
     66e:	855a                	mv	a0,s6
     670:	70a6                	ld	ra,104(sp)
     672:	7406                	ld	s0,96(sp)
     674:	64e6                	ld	s1,88(sp)
     676:	6946                	ld	s2,80(sp)
     678:	69a6                	ld	s3,72(sp)
     67a:	6a06                	ld	s4,64(sp)
     67c:	7ae2                	ld	s5,56(sp)
     67e:	7b42                	ld	s6,48(sp)
     680:	7ba2                	ld	s7,40(sp)
     682:	7c02                	ld	s8,32(sp)
     684:	6ce2                	ld	s9,24(sp)
     686:	6165                	addi	sp,sp,112
     688:	8082                	ret

000000000000068a <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     68a:	7159                	addi	sp,sp,-112
     68c:	f486                	sd	ra,104(sp)
     68e:	f0a2                	sd	s0,96(sp)
     690:	eca6                	sd	s1,88(sp)
     692:	e8ca                	sd	s2,80(sp)
     694:	e4ce                	sd	s3,72(sp)
     696:	e0d2                	sd	s4,64(sp)
     698:	fc56                	sd	s5,56(sp)
     69a:	f85a                	sd	s6,48(sp)
     69c:	f45e                	sd	s7,40(sp)
     69e:	f062                	sd	s8,32(sp)
     6a0:	ec66                	sd	s9,24(sp)
     6a2:	1880                	addi	s0,sp,112
     6a4:	89aa                	mv	s3,a0
     6a6:	8a2e                	mv	s4,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6a8:	00001617          	auipc	a2,0x1
     6ac:	d3860613          	addi	a2,a2,-712 # 13e0 <malloc+0x192>
     6b0:	00000097          	auipc	ra,0x0
     6b4:	e74080e7          	jalr	-396(ra) # 524 <peek>
     6b8:	e905                	bnez	a0,6e8 <parseexec+0x5e>
     6ba:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     6bc:	00000097          	auipc	ra,0x0
     6c0:	bbe080e7          	jalr	-1090(ra) # 27a <execcmd>
     6c4:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c6:	8652                	mv	a2,s4
     6c8:	85ce                	mv	a1,s3
     6ca:	00000097          	auipc	ra,0x0
     6ce:	ec4080e7          	jalr	-316(ra) # 58e <parseredirs>
     6d2:	8aaa                	mv	s5,a0
  while(!peek(ps, es, "|)&;")){
     6d4:	008c0493          	addi	s1,s8,8
     6d8:	00001b17          	auipc	s6,0x1
     6dc:	d28b0b13          	addi	s6,s6,-728 # 1400 <malloc+0x1b2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e0:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e4:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e6:	a0b1                	j	732 <parseexec+0xa8>
    return parseblock(ps, es);
     6e8:	85d2                	mv	a1,s4
     6ea:	854e                	mv	a0,s3
     6ec:	00000097          	auipc	ra,0x0
     6f0:	1b8080e7          	jalr	440(ra) # 8a4 <parseblock>
     6f4:	8aaa                	mv	s5,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f6:	8556                	mv	a0,s5
     6f8:	70a6                	ld	ra,104(sp)
     6fa:	7406                	ld	s0,96(sp)
     6fc:	64e6                	ld	s1,88(sp)
     6fe:	6946                	ld	s2,80(sp)
     700:	69a6                	ld	s3,72(sp)
     702:	6a06                	ld	s4,64(sp)
     704:	7ae2                	ld	s5,56(sp)
     706:	7b42                	ld	s6,48(sp)
     708:	7ba2                	ld	s7,40(sp)
     70a:	7c02                	ld	s8,32(sp)
     70c:	6ce2                	ld	s9,24(sp)
     70e:	6165                	addi	sp,sp,112
     710:	8082                	ret
      panic("syntax");
     712:	00001517          	auipc	a0,0x1
     716:	cd650513          	addi	a0,a0,-810 # 13e8 <malloc+0x19a>
     71a:	00000097          	auipc	ra,0x0
     71e:	93e080e7          	jalr	-1730(ra) # 58 <panic>
    ret = parseredirs(ret, ps, es);
     722:	8652                	mv	a2,s4
     724:	85ce                	mv	a1,s3
     726:	8556                	mv	a0,s5
     728:	00000097          	auipc	ra,0x0
     72c:	e66080e7          	jalr	-410(ra) # 58e <parseredirs>
     730:	8aaa                	mv	s5,a0
  while(!peek(ps, es, "|)&;")){
     732:	865a                	mv	a2,s6
     734:	85d2                	mv	a1,s4
     736:	854e                	mv	a0,s3
     738:	00000097          	auipc	ra,0x0
     73c:	dec080e7          	jalr	-532(ra) # 524 <peek>
     740:	e121                	bnez	a0,780 <parseexec+0xf6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     742:	f9040693          	addi	a3,s0,-112
     746:	f9840613          	addi	a2,s0,-104
     74a:	85d2                	mv	a1,s4
     74c:	854e                	mv	a0,s3
     74e:	00000097          	auipc	ra,0x0
     752:	c92080e7          	jalr	-878(ra) # 3e0 <gettoken>
     756:	c50d                	beqz	a0,780 <parseexec+0xf6>
    if(tok != 'a')
     758:	fb951de3          	bne	a0,s9,712 <parseexec+0x88>
    cmd->argv[argc] = q;
     75c:	f9843783          	ld	a5,-104(s0)
     760:	e09c                	sd	a5,0(s1)
    cmd->eargv[argc] = eq;
     762:	f9043783          	ld	a5,-112(s0)
     766:	e8bc                	sd	a5,80(s1)
    argc++;
     768:	2905                	addiw	s2,s2,1
    if(argc >= MAXARGS)
     76a:	04a1                	addi	s1,s1,8
     76c:	fb791be3          	bne	s2,s7,722 <parseexec+0x98>
      panic("too many args");
     770:	00001517          	auipc	a0,0x1
     774:	c8050513          	addi	a0,a0,-896 # 13f0 <malloc+0x1a2>
     778:	00000097          	auipc	ra,0x0
     77c:	8e0080e7          	jalr	-1824(ra) # 58 <panic>
  cmd->argv[argc] = 0;
     780:	090e                	slli	s2,s2,0x3
     782:	9962                	add	s2,s2,s8
     784:	00093423          	sd	zero,8(s2)
  cmd->eargv[argc] = 0;
     788:	04093c23          	sd	zero,88(s2)
  return ret;
     78c:	b7ad                	j	6f6 <parseexec+0x6c>

000000000000078e <parsepipe>:
{
     78e:	7179                	addi	sp,sp,-48
     790:	f406                	sd	ra,40(sp)
     792:	f022                	sd	s0,32(sp)
     794:	ec26                	sd	s1,24(sp)
     796:	e84a                	sd	s2,16(sp)
     798:	e44e                	sd	s3,8(sp)
     79a:	1800                	addi	s0,sp,48
     79c:	892a                	mv	s2,a0
     79e:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a0:	00000097          	auipc	ra,0x0
     7a4:	eea080e7          	jalr	-278(ra) # 68a <parseexec>
     7a8:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7aa:	00001617          	auipc	a2,0x1
     7ae:	c5e60613          	addi	a2,a2,-930 # 1408 <malloc+0x1ba>
     7b2:	85ce                	mv	a1,s3
     7b4:	854a                	mv	a0,s2
     7b6:	00000097          	auipc	ra,0x0
     7ba:	d6e080e7          	jalr	-658(ra) # 524 <peek>
     7be:	e909                	bnez	a0,7d0 <parsepipe+0x42>
}
     7c0:	8526                	mv	a0,s1
     7c2:	70a2                	ld	ra,40(sp)
     7c4:	7402                	ld	s0,32(sp)
     7c6:	64e2                	ld	s1,24(sp)
     7c8:	6942                	ld	s2,16(sp)
     7ca:	69a2                	ld	s3,8(sp)
     7cc:	6145                	addi	sp,sp,48
     7ce:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d0:	4681                	li	a3,0
     7d2:	4601                	li	a2,0
     7d4:	85ce                	mv	a1,s3
     7d6:	854a                	mv	a0,s2
     7d8:	00000097          	auipc	ra,0x0
     7dc:	c08080e7          	jalr	-1016(ra) # 3e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e0:	85ce                	mv	a1,s3
     7e2:	854a                	mv	a0,s2
     7e4:	00000097          	auipc	ra,0x0
     7e8:	faa080e7          	jalr	-86(ra) # 78e <parsepipe>
     7ec:	85aa                	mv	a1,a0
     7ee:	8526                	mv	a0,s1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	b28080e7          	jalr	-1240(ra) # 318 <pipecmd>
     7f8:	84aa                	mv	s1,a0
  return cmd;
     7fa:	b7d9                	j	7c0 <parsepipe+0x32>

00000000000007fc <parseline>:
{
     7fc:	7179                	addi	sp,sp,-48
     7fe:	f406                	sd	ra,40(sp)
     800:	f022                	sd	s0,32(sp)
     802:	ec26                	sd	s1,24(sp)
     804:	e84a                	sd	s2,16(sp)
     806:	e44e                	sd	s3,8(sp)
     808:	e052                	sd	s4,0(sp)
     80a:	1800                	addi	s0,sp,48
     80c:	84aa                	mv	s1,a0
     80e:	892e                	mv	s2,a1
  cmd = parsepipe(ps, es);
     810:	00000097          	auipc	ra,0x0
     814:	f7e080e7          	jalr	-130(ra) # 78e <parsepipe>
     818:	89aa                	mv	s3,a0
  while(peek(ps, es, "&")){
     81a:	00001a17          	auipc	s4,0x1
     81e:	bf6a0a13          	addi	s4,s4,-1034 # 1410 <malloc+0x1c2>
     822:	8652                	mv	a2,s4
     824:	85ca                	mv	a1,s2
     826:	8526                	mv	a0,s1
     828:	00000097          	auipc	ra,0x0
     82c:	cfc080e7          	jalr	-772(ra) # 524 <peek>
     830:	c105                	beqz	a0,850 <parseline+0x54>
    gettoken(ps, es, 0, 0);
     832:	4681                	li	a3,0
     834:	4601                	li	a2,0
     836:	85ca                	mv	a1,s2
     838:	8526                	mv	a0,s1
     83a:	00000097          	auipc	ra,0x0
     83e:	ba6080e7          	jalr	-1114(ra) # 3e0 <gettoken>
    cmd = backcmd(cmd);
     842:	854e                	mv	a0,s3
     844:	00000097          	auipc	ra,0x0
     848:	b60080e7          	jalr	-1184(ra) # 3a4 <backcmd>
     84c:	89aa                	mv	s3,a0
     84e:	bfd1                	j	822 <parseline+0x26>
  if(peek(ps, es, ";")){
     850:	00001617          	auipc	a2,0x1
     854:	bc860613          	addi	a2,a2,-1080 # 1418 <malloc+0x1ca>
     858:	85ca                	mv	a1,s2
     85a:	8526                	mv	a0,s1
     85c:	00000097          	auipc	ra,0x0
     860:	cc8080e7          	jalr	-824(ra) # 524 <peek>
     864:	e911                	bnez	a0,878 <parseline+0x7c>
}
     866:	854e                	mv	a0,s3
     868:	70a2                	ld	ra,40(sp)
     86a:	7402                	ld	s0,32(sp)
     86c:	64e2                	ld	s1,24(sp)
     86e:	6942                	ld	s2,16(sp)
     870:	69a2                	ld	s3,8(sp)
     872:	6a02                	ld	s4,0(sp)
     874:	6145                	addi	sp,sp,48
     876:	8082                	ret
    gettoken(ps, es, 0, 0);
     878:	4681                	li	a3,0
     87a:	4601                	li	a2,0
     87c:	85ca                	mv	a1,s2
     87e:	8526                	mv	a0,s1
     880:	00000097          	auipc	ra,0x0
     884:	b60080e7          	jalr	-1184(ra) # 3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     888:	85ca                	mv	a1,s2
     88a:	8526                	mv	a0,s1
     88c:	00000097          	auipc	ra,0x0
     890:	f70080e7          	jalr	-144(ra) # 7fc <parseline>
     894:	85aa                	mv	a1,a0
     896:	854e                	mv	a0,s3
     898:	00000097          	auipc	ra,0x0
     89c:	ac6080e7          	jalr	-1338(ra) # 35e <listcmd>
     8a0:	89aa                	mv	s3,a0
  return cmd;
     8a2:	b7d1                	j	866 <parseline+0x6a>

00000000000008a4 <parseblock>:
{
     8a4:	7179                	addi	sp,sp,-48
     8a6:	f406                	sd	ra,40(sp)
     8a8:	f022                	sd	s0,32(sp)
     8aa:	ec26                	sd	s1,24(sp)
     8ac:	e84a                	sd	s2,16(sp)
     8ae:	e44e                	sd	s3,8(sp)
     8b0:	1800                	addi	s0,sp,48
     8b2:	84aa                	mv	s1,a0
     8b4:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8b6:	00001617          	auipc	a2,0x1
     8ba:	b2a60613          	addi	a2,a2,-1238 # 13e0 <malloc+0x192>
     8be:	00000097          	auipc	ra,0x0
     8c2:	c66080e7          	jalr	-922(ra) # 524 <peek>
     8c6:	c12d                	beqz	a0,928 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8c8:	4681                	li	a3,0
     8ca:	4601                	li	a2,0
     8cc:	85ca                	mv	a1,s2
     8ce:	8526                	mv	a0,s1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	b10080e7          	jalr	-1264(ra) # 3e0 <gettoken>
  cmd = parseline(ps, es);
     8d8:	85ca                	mv	a1,s2
     8da:	8526                	mv	a0,s1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	f20080e7          	jalr	-224(ra) # 7fc <parseline>
     8e4:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8e6:	00001617          	auipc	a2,0x1
     8ea:	b4a60613          	addi	a2,a2,-1206 # 1430 <malloc+0x1e2>
     8ee:	85ca                	mv	a1,s2
     8f0:	8526                	mv	a0,s1
     8f2:	00000097          	auipc	ra,0x0
     8f6:	c32080e7          	jalr	-974(ra) # 524 <peek>
     8fa:	cd1d                	beqz	a0,938 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8fc:	4681                	li	a3,0
     8fe:	4601                	li	a2,0
     900:	85ca                	mv	a1,s2
     902:	8526                	mv	a0,s1
     904:	00000097          	auipc	ra,0x0
     908:	adc080e7          	jalr	-1316(ra) # 3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     90c:	864a                	mv	a2,s2
     90e:	85a6                	mv	a1,s1
     910:	854e                	mv	a0,s3
     912:	00000097          	auipc	ra,0x0
     916:	c7c080e7          	jalr	-900(ra) # 58e <parseredirs>
}
     91a:	70a2                	ld	ra,40(sp)
     91c:	7402                	ld	s0,32(sp)
     91e:	64e2                	ld	s1,24(sp)
     920:	6942                	ld	s2,16(sp)
     922:	69a2                	ld	s3,8(sp)
     924:	6145                	addi	sp,sp,48
     926:	8082                	ret
    panic("parseblock");
     928:	00001517          	auipc	a0,0x1
     92c:	af850513          	addi	a0,a0,-1288 # 1420 <malloc+0x1d2>
     930:	fffff097          	auipc	ra,0xfffff
     934:	728080e7          	jalr	1832(ra) # 58 <panic>
    panic("syntax - missing )");
     938:	00001517          	auipc	a0,0x1
     93c:	b0050513          	addi	a0,a0,-1280 # 1438 <malloc+0x1ea>
     940:	fffff097          	auipc	ra,0xfffff
     944:	718080e7          	jalr	1816(ra) # 58 <panic>

0000000000000948 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     948:	1101                	addi	sp,sp,-32
     94a:	ec06                	sd	ra,24(sp)
     94c:	e822                	sd	s0,16(sp)
     94e:	e426                	sd	s1,8(sp)
     950:	1000                	addi	s0,sp,32
     952:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     954:	c521                	beqz	a0,99c <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     956:	4118                	lw	a4,0(a0)
     958:	4795                	li	a5,5
     95a:	04e7e163          	bltu	a5,a4,99c <nulterminate+0x54>
     95e:	00056783          	lwu	a5,0(a0)
     962:	078a                	slli	a5,a5,0x2
     964:	00001717          	auipc	a4,0x1
     968:	9f470713          	addi	a4,a4,-1548 # 1358 <malloc+0x10a>
     96c:	97ba                	add	a5,a5,a4
     96e:	439c                	lw	a5,0(a5)
     970:	97ba                	add	a5,a5,a4
     972:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     974:	651c                	ld	a5,8(a0)
     976:	c39d                	beqz	a5,99c <nulterminate+0x54>
     978:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     97c:	67b8                	ld	a4,72(a5)
     97e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     982:	07a1                	addi	a5,a5,8
     984:	ff87b703          	ld	a4,-8(a5)
     988:	fb75                	bnez	a4,97c <nulterminate+0x34>
     98a:	a809                	j	99c <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     98c:	6508                	ld	a0,8(a0)
     98e:	00000097          	auipc	ra,0x0
     992:	fba080e7          	jalr	-70(ra) # 948 <nulterminate>
    *rcmd->efile = 0;
     996:	6c9c                	ld	a5,24(s1)
     998:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     99c:	8526                	mv	a0,s1
     99e:	60e2                	ld	ra,24(sp)
     9a0:	6442                	ld	s0,16(sp)
     9a2:	64a2                	ld	s1,8(sp)
     9a4:	6105                	addi	sp,sp,32
     9a6:	8082                	ret
    nulterminate(pcmd->left);
     9a8:	6508                	ld	a0,8(a0)
     9aa:	00000097          	auipc	ra,0x0
     9ae:	f9e080e7          	jalr	-98(ra) # 948 <nulterminate>
    nulterminate(pcmd->right);
     9b2:	6888                	ld	a0,16(s1)
     9b4:	00000097          	auipc	ra,0x0
     9b8:	f94080e7          	jalr	-108(ra) # 948 <nulterminate>
    break;
     9bc:	b7c5                	j	99c <nulterminate+0x54>
    nulterminate(lcmd->left);
     9be:	6508                	ld	a0,8(a0)
     9c0:	00000097          	auipc	ra,0x0
     9c4:	f88080e7          	jalr	-120(ra) # 948 <nulterminate>
    nulterminate(lcmd->right);
     9c8:	6888                	ld	a0,16(s1)
     9ca:	00000097          	auipc	ra,0x0
     9ce:	f7e080e7          	jalr	-130(ra) # 948 <nulterminate>
    break;
     9d2:	b7e9                	j	99c <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9d4:	6508                	ld	a0,8(a0)
     9d6:	00000097          	auipc	ra,0x0
     9da:	f72080e7          	jalr	-142(ra) # 948 <nulterminate>
    break;
     9de:	bf7d                	j	99c <nulterminate+0x54>

00000000000009e0 <parsecmd>:
{
     9e0:	7179                	addi	sp,sp,-48
     9e2:	f406                	sd	ra,40(sp)
     9e4:	f022                	sd	s0,32(sp)
     9e6:	ec26                	sd	s1,24(sp)
     9e8:	e84a                	sd	s2,16(sp)
     9ea:	1800                	addi	s0,sp,48
     9ec:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f0:	84aa                	mv	s1,a0
     9f2:	00000097          	auipc	ra,0x0
     9f6:	1d4080e7          	jalr	468(ra) # bc6 <strlen>
     9fa:	1502                	slli	a0,a0,0x20
     9fc:	9101                	srli	a0,a0,0x20
     9fe:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a00:	85a6                	mv	a1,s1
     a02:	fd840513          	addi	a0,s0,-40
     a06:	00000097          	auipc	ra,0x0
     a0a:	df6080e7          	jalr	-522(ra) # 7fc <parseline>
     a0e:	892a                	mv	s2,a0
  peek(&s, es, "");
     a10:	00001617          	auipc	a2,0x1
     a14:	a4060613          	addi	a2,a2,-1472 # 1450 <malloc+0x202>
     a18:	85a6                	mv	a1,s1
     a1a:	fd840513          	addi	a0,s0,-40
     a1e:	00000097          	auipc	ra,0x0
     a22:	b06080e7          	jalr	-1274(ra) # 524 <peek>
  if(s != es){
     a26:	fd843603          	ld	a2,-40(s0)
     a2a:	00961e63          	bne	a2,s1,a46 <parsecmd+0x66>
  nulterminate(cmd);
     a2e:	854a                	mv	a0,s2
     a30:	00000097          	auipc	ra,0x0
     a34:	f18080e7          	jalr	-232(ra) # 948 <nulterminate>
}
     a38:	854a                	mv	a0,s2
     a3a:	70a2                	ld	ra,40(sp)
     a3c:	7402                	ld	s0,32(sp)
     a3e:	64e2                	ld	s1,24(sp)
     a40:	6942                	ld	s2,16(sp)
     a42:	6145                	addi	sp,sp,48
     a44:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a46:	00001597          	auipc	a1,0x1
     a4a:	a1258593          	addi	a1,a1,-1518 # 1458 <malloc+0x20a>
     a4e:	4509                	li	a0,2
     a50:	00000097          	auipc	ra,0x0
     a54:	710080e7          	jalr	1808(ra) # 1160 <fprintf>
    panic("syntax");
     a58:	00001517          	auipc	a0,0x1
     a5c:	99050513          	addi	a0,a0,-1648 # 13e8 <malloc+0x19a>
     a60:	fffff097          	auipc	ra,0xfffff
     a64:	5f8080e7          	jalr	1528(ra) # 58 <panic>

0000000000000a68 <main>:
{
     a68:	7139                	addi	sp,sp,-64
     a6a:	fc06                	sd	ra,56(sp)
     a6c:	f822                	sd	s0,48(sp)
     a6e:	f426                	sd	s1,40(sp)
     a70:	f04a                	sd	s2,32(sp)
     a72:	ec4e                	sd	s3,24(sp)
     a74:	e852                	sd	s4,16(sp)
     a76:	e456                	sd	s5,8(sp)
     a78:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a7a:	00001497          	auipc	s1,0x1
     a7e:	9ee48493          	addi	s1,s1,-1554 # 1468 <malloc+0x21a>
     a82:	4589                	li	a1,2
     a84:	8526                	mv	a0,s1
     a86:	00000097          	auipc	ra,0x0
     a8a:	3c0080e7          	jalr	960(ra) # e46 <open>
     a8e:	00054963          	bltz	a0,aa0 <main+0x38>
    if(fd >= 3){
     a92:	4789                	li	a5,2
     a94:	fea7d7e3          	ble	a0,a5,a82 <main+0x1a>
      close(fd);
     a98:	00000097          	auipc	ra,0x0
     a9c:	396080e7          	jalr	918(ra) # e2e <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa0:	00001497          	auipc	s1,0x1
     aa4:	58048493          	addi	s1,s1,1408 # 2020 <buf.1159>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aa8:	06300913          	li	s2,99
     aac:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     ab0:	00001a17          	auipc	s4,0x1
     ab4:	573a0a13          	addi	s4,s4,1395 # 2023 <buf.1159+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     ab8:	00001a97          	auipc	s5,0x1
     abc:	9b8a8a93          	addi	s5,s5,-1608 # 1470 <malloc+0x222>
     ac0:	a819                	j	ad6 <main+0x6e>
    if(fork1() == 0)
     ac2:	fffff097          	auipc	ra,0xfffff
     ac6:	5bc080e7          	jalr	1468(ra) # 7e <fork1>
     aca:	c925                	beqz	a0,b3a <main+0xd2>
    wait(0);
     acc:	4501                	li	a0,0
     ace:	00000097          	auipc	ra,0x0
     ad2:	340080e7          	jalr	832(ra) # e0e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ad6:	06400593          	li	a1,100
     ada:	8526                	mv	a0,s1
     adc:	fffff097          	auipc	ra,0xfffff
     ae0:	524080e7          	jalr	1316(ra) # 0 <getcmd>
     ae4:	06054763          	bltz	a0,b52 <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae8:	0004c783          	lbu	a5,0(s1)
     aec:	fd279be3          	bne	a5,s2,ac2 <main+0x5a>
     af0:	0014c703          	lbu	a4,1(s1)
     af4:	06400793          	li	a5,100
     af8:	fcf715e3          	bne	a4,a5,ac2 <main+0x5a>
     afc:	0024c783          	lbu	a5,2(s1)
     b00:	fd3791e3          	bne	a5,s3,ac2 <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     b04:	8526                	mv	a0,s1
     b06:	00000097          	auipc	ra,0x0
     b0a:	0c0080e7          	jalr	192(ra) # bc6 <strlen>
     b0e:	fff5079b          	addiw	a5,a0,-1
     b12:	1782                	slli	a5,a5,0x20
     b14:	9381                	srli	a5,a5,0x20
     b16:	97a6                	add	a5,a5,s1
     b18:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b1c:	8552                	mv	a0,s4
     b1e:	00000097          	auipc	ra,0x0
     b22:	358080e7          	jalr	856(ra) # e76 <chdir>
     b26:	fa0558e3          	bgez	a0,ad6 <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2a:	8652                	mv	a2,s4
     b2c:	85d6                	mv	a1,s5
     b2e:	4509                	li	a0,2
     b30:	00000097          	auipc	ra,0x0
     b34:	630080e7          	jalr	1584(ra) # 1160 <fprintf>
     b38:	bf79                	j	ad6 <main+0x6e>
      runcmd(parsecmd(buf));
     b3a:	00001517          	auipc	a0,0x1
     b3e:	4e650513          	addi	a0,a0,1254 # 2020 <buf.1159>
     b42:	00000097          	auipc	ra,0x0
     b46:	e9e080e7          	jalr	-354(ra) # 9e0 <parsecmd>
     b4a:	fffff097          	auipc	ra,0xfffff
     b4e:	562080e7          	jalr	1378(ra) # ac <runcmd>
  exit(0);
     b52:	4501                	li	a0,0
     b54:	00000097          	auipc	ra,0x0
     b58:	2b2080e7          	jalr	690(ra) # e06 <exit>

0000000000000b5c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e406                	sd	ra,8(sp)
     b60:	e022                	sd	s0,0(sp)
     b62:	0800                	addi	s0,sp,16
  extern int main();
  main();
     b64:	00000097          	auipc	ra,0x0
     b68:	f04080e7          	jalr	-252(ra) # a68 <main>
  exit(0);
     b6c:	4501                	li	a0,0
     b6e:	00000097          	auipc	ra,0x0
     b72:	298080e7          	jalr	664(ra) # e06 <exit>

0000000000000b76 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e422                	sd	s0,8(sp)
     b7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b7c:	87aa                	mv	a5,a0
     b7e:	0585                	addi	a1,a1,1
     b80:	0785                	addi	a5,a5,1
     b82:	fff5c703          	lbu	a4,-1(a1)
     b86:	fee78fa3          	sb	a4,-1(a5)
     b8a:	fb75                	bnez	a4,b7e <strcpy+0x8>
    ;
  return os;
}
     b8c:	6422                	ld	s0,8(sp)
     b8e:	0141                	addi	sp,sp,16
     b90:	8082                	ret

0000000000000b92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b92:	1141                	addi	sp,sp,-16
     b94:	e422                	sd	s0,8(sp)
     b96:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b98:	00054783          	lbu	a5,0(a0)
     b9c:	cf91                	beqz	a5,bb8 <strcmp+0x26>
     b9e:	0005c703          	lbu	a4,0(a1)
     ba2:	00f71b63          	bne	a4,a5,bb8 <strcmp+0x26>
    p++, q++;
     ba6:	0505                	addi	a0,a0,1
     ba8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     baa:	00054783          	lbu	a5,0(a0)
     bae:	c789                	beqz	a5,bb8 <strcmp+0x26>
     bb0:	0005c703          	lbu	a4,0(a1)
     bb4:	fef709e3          	beq	a4,a5,ba6 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     bb8:	0005c503          	lbu	a0,0(a1)
}
     bbc:	40a7853b          	subw	a0,a5,a0
     bc0:	6422                	ld	s0,8(sp)
     bc2:	0141                	addi	sp,sp,16
     bc4:	8082                	ret

0000000000000bc6 <strlen>:

uint
strlen(const char *s)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e422                	sd	s0,8(sp)
     bca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bcc:	00054783          	lbu	a5,0(a0)
     bd0:	cf91                	beqz	a5,bec <strlen+0x26>
     bd2:	0505                	addi	a0,a0,1
     bd4:	87aa                	mv	a5,a0
     bd6:	4685                	li	a3,1
     bd8:	9e89                	subw	a3,a3,a0
     bda:	00f6853b          	addw	a0,a3,a5
     bde:	0785                	addi	a5,a5,1
     be0:	fff7c703          	lbu	a4,-1(a5)
     be4:	fb7d                	bnez	a4,bda <strlen+0x14>
    ;
  return n;
}
     be6:	6422                	ld	s0,8(sp)
     be8:	0141                	addi	sp,sp,16
     bea:	8082                	ret
  for(n = 0; s[n]; n++)
     bec:	4501                	li	a0,0
     bee:	bfe5                	j	be6 <strlen+0x20>

0000000000000bf0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bf6:	ce09                	beqz	a2,c10 <memset+0x20>
     bf8:	87aa                	mv	a5,a0
     bfa:	fff6071b          	addiw	a4,a2,-1
     bfe:	1702                	slli	a4,a4,0x20
     c00:	9301                	srli	a4,a4,0x20
     c02:	0705                	addi	a4,a4,1
     c04:	972a                	add	a4,a4,a0
    cdst[i] = c;
     c06:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c0a:	0785                	addi	a5,a5,1
     c0c:	fee79de3          	bne	a5,a4,c06 <memset+0x16>
  }
  return dst;
}
     c10:	6422                	ld	s0,8(sp)
     c12:	0141                	addi	sp,sp,16
     c14:	8082                	ret

0000000000000c16 <strchr>:

char*
strchr(const char *s, char c)
{
     c16:	1141                	addi	sp,sp,-16
     c18:	e422                	sd	s0,8(sp)
     c1a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c1c:	00054783          	lbu	a5,0(a0)
     c20:	cf91                	beqz	a5,c3c <strchr+0x26>
    if(*s == c)
     c22:	00f58a63          	beq	a1,a5,c36 <strchr+0x20>
  for(; *s; s++)
     c26:	0505                	addi	a0,a0,1
     c28:	00054783          	lbu	a5,0(a0)
     c2c:	c781                	beqz	a5,c34 <strchr+0x1e>
    if(*s == c)
     c2e:	feb79ce3          	bne	a5,a1,c26 <strchr+0x10>
     c32:	a011                	j	c36 <strchr+0x20>
      return (char*)s;
  return 0;
     c34:	4501                	li	a0,0
}
     c36:	6422                	ld	s0,8(sp)
     c38:	0141                	addi	sp,sp,16
     c3a:	8082                	ret
  return 0;
     c3c:	4501                	li	a0,0
     c3e:	bfe5                	j	c36 <strchr+0x20>

0000000000000c40 <gets>:

char*
gets(char *buf, int max)
{
     c40:	711d                	addi	sp,sp,-96
     c42:	ec86                	sd	ra,88(sp)
     c44:	e8a2                	sd	s0,80(sp)
     c46:	e4a6                	sd	s1,72(sp)
     c48:	e0ca                	sd	s2,64(sp)
     c4a:	fc4e                	sd	s3,56(sp)
     c4c:	f852                	sd	s4,48(sp)
     c4e:	f456                	sd	s5,40(sp)
     c50:	f05a                	sd	s6,32(sp)
     c52:	ec5e                	sd	s7,24(sp)
     c54:	1080                	addi	s0,sp,96
     c56:	8baa                	mv	s7,a0
     c58:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c5a:	892a                	mv	s2,a0
     c5c:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c5e:	4aa9                	li	s5,10
     c60:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c62:	0019849b          	addiw	s1,s3,1
     c66:	0344d863          	ble	s4,s1,c96 <gets+0x56>
    cc = read(0, &c, 1);
     c6a:	4605                	li	a2,1
     c6c:	faf40593          	addi	a1,s0,-81
     c70:	4501                	li	a0,0
     c72:	00000097          	auipc	ra,0x0
     c76:	1ac080e7          	jalr	428(ra) # e1e <read>
    if(cc < 1)
     c7a:	00a05e63          	blez	a0,c96 <gets+0x56>
    buf[i++] = c;
     c7e:	faf44783          	lbu	a5,-81(s0)
     c82:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c86:	01578763          	beq	a5,s5,c94 <gets+0x54>
     c8a:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
     c8c:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
     c8e:	fd679ae3          	bne	a5,s6,c62 <gets+0x22>
     c92:	a011                	j	c96 <gets+0x56>
  for(i=0; i+1 < max; ){
     c94:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c96:	99de                	add	s3,s3,s7
     c98:	00098023          	sb	zero,0(s3)
  return buf;
}
     c9c:	855e                	mv	a0,s7
     c9e:	60e6                	ld	ra,88(sp)
     ca0:	6446                	ld	s0,80(sp)
     ca2:	64a6                	ld	s1,72(sp)
     ca4:	6906                	ld	s2,64(sp)
     ca6:	79e2                	ld	s3,56(sp)
     ca8:	7a42                	ld	s4,48(sp)
     caa:	7aa2                	ld	s5,40(sp)
     cac:	7b02                	ld	s6,32(sp)
     cae:	6be2                	ld	s7,24(sp)
     cb0:	6125                	addi	sp,sp,96
     cb2:	8082                	ret

0000000000000cb4 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb4:	1101                	addi	sp,sp,-32
     cb6:	ec06                	sd	ra,24(sp)
     cb8:	e822                	sd	s0,16(sp)
     cba:	e426                	sd	s1,8(sp)
     cbc:	e04a                	sd	s2,0(sp)
     cbe:	1000                	addi	s0,sp,32
     cc0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cc2:	4581                	li	a1,0
     cc4:	00000097          	auipc	ra,0x0
     cc8:	182080e7          	jalr	386(ra) # e46 <open>
  if(fd < 0)
     ccc:	02054563          	bltz	a0,cf6 <stat+0x42>
     cd0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cd2:	85ca                	mv	a1,s2
     cd4:	00000097          	auipc	ra,0x0
     cd8:	18a080e7          	jalr	394(ra) # e5e <fstat>
     cdc:	892a                	mv	s2,a0
  close(fd);
     cde:	8526                	mv	a0,s1
     ce0:	00000097          	auipc	ra,0x0
     ce4:	14e080e7          	jalr	334(ra) # e2e <close>
  return r;
}
     ce8:	854a                	mv	a0,s2
     cea:	60e2                	ld	ra,24(sp)
     cec:	6442                	ld	s0,16(sp)
     cee:	64a2                	ld	s1,8(sp)
     cf0:	6902                	ld	s2,0(sp)
     cf2:	6105                	addi	sp,sp,32
     cf4:	8082                	ret
    return -1;
     cf6:	597d                	li	s2,-1
     cf8:	bfc5                	j	ce8 <stat+0x34>

0000000000000cfa <atoi>:

int
atoi(const char *s)
{
     cfa:	1141                	addi	sp,sp,-16
     cfc:	e422                	sd	s0,8(sp)
     cfe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d00:	00054683          	lbu	a3,0(a0)
     d04:	fd06879b          	addiw	a5,a3,-48
     d08:	0ff7f793          	andi	a5,a5,255
     d0c:	4725                	li	a4,9
     d0e:	02f76963          	bltu	a4,a5,d40 <atoi+0x46>
     d12:	862a                	mv	a2,a0
  n = 0;
     d14:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d16:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d18:	0605                	addi	a2,a2,1
     d1a:	0025179b          	slliw	a5,a0,0x2
     d1e:	9fa9                	addw	a5,a5,a0
     d20:	0017979b          	slliw	a5,a5,0x1
     d24:	9fb5                	addw	a5,a5,a3
     d26:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d2a:	00064683          	lbu	a3,0(a2)
     d2e:	fd06871b          	addiw	a4,a3,-48
     d32:	0ff77713          	andi	a4,a4,255
     d36:	fee5f1e3          	bleu	a4,a1,d18 <atoi+0x1e>
  return n;
}
     d3a:	6422                	ld	s0,8(sp)
     d3c:	0141                	addi	sp,sp,16
     d3e:	8082                	ret
  n = 0;
     d40:	4501                	li	a0,0
     d42:	bfe5                	j	d3a <atoi+0x40>

0000000000000d44 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d44:	1141                	addi	sp,sp,-16
     d46:	e422                	sd	s0,8(sp)
     d48:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d4a:	02b57663          	bleu	a1,a0,d76 <memmove+0x32>
    while(n-- > 0)
     d4e:	02c05163          	blez	a2,d70 <memmove+0x2c>
     d52:	fff6079b          	addiw	a5,a2,-1
     d56:	1782                	slli	a5,a5,0x20
     d58:	9381                	srli	a5,a5,0x20
     d5a:	0785                	addi	a5,a5,1
     d5c:	97aa                	add	a5,a5,a0
  dst = vdst;
     d5e:	872a                	mv	a4,a0
      *dst++ = *src++;
     d60:	0585                	addi	a1,a1,1
     d62:	0705                	addi	a4,a4,1
     d64:	fff5c683          	lbu	a3,-1(a1)
     d68:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d6c:	fee79ae3          	bne	a5,a4,d60 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d70:	6422                	ld	s0,8(sp)
     d72:	0141                	addi	sp,sp,16
     d74:	8082                	ret
    dst += n;
     d76:	00c50733          	add	a4,a0,a2
    src += n;
     d7a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d7c:	fec05ae3          	blez	a2,d70 <memmove+0x2c>
     d80:	fff6079b          	addiw	a5,a2,-1
     d84:	1782                	slli	a5,a5,0x20
     d86:	9381                	srli	a5,a5,0x20
     d88:	fff7c793          	not	a5,a5
     d8c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d8e:	15fd                	addi	a1,a1,-1
     d90:	177d                	addi	a4,a4,-1
     d92:	0005c683          	lbu	a3,0(a1)
     d96:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d9a:	fef71ae3          	bne	a4,a5,d8e <memmove+0x4a>
     d9e:	bfc9                	j	d70 <memmove+0x2c>

0000000000000da0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     da0:	1141                	addi	sp,sp,-16
     da2:	e422                	sd	s0,8(sp)
     da4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     da6:	ce15                	beqz	a2,de2 <memcmp+0x42>
     da8:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
     dac:	00054783          	lbu	a5,0(a0)
     db0:	0005c703          	lbu	a4,0(a1)
     db4:	02e79063          	bne	a5,a4,dd4 <memcmp+0x34>
     db8:	1682                	slli	a3,a3,0x20
     dba:	9281                	srli	a3,a3,0x20
     dbc:	0685                	addi	a3,a3,1
     dbe:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
     dc0:	0505                	addi	a0,a0,1
    p2++;
     dc2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dc4:	00d50d63          	beq	a0,a3,dde <memcmp+0x3e>
    if (*p1 != *p2) {
     dc8:	00054783          	lbu	a5,0(a0)
     dcc:	0005c703          	lbu	a4,0(a1)
     dd0:	fee788e3          	beq	a5,a4,dc0 <memcmp+0x20>
      return *p1 - *p2;
     dd4:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
     dd8:	6422                	ld	s0,8(sp)
     dda:	0141                	addi	sp,sp,16
     ddc:	8082                	ret
  return 0;
     dde:	4501                	li	a0,0
     de0:	bfe5                	j	dd8 <memcmp+0x38>
     de2:	4501                	li	a0,0
     de4:	bfd5                	j	dd8 <memcmp+0x38>

0000000000000de6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     de6:	1141                	addi	sp,sp,-16
     de8:	e406                	sd	ra,8(sp)
     dea:	e022                	sd	s0,0(sp)
     dec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     dee:	00000097          	auipc	ra,0x0
     df2:	f56080e7          	jalr	-170(ra) # d44 <memmove>
}
     df6:	60a2                	ld	ra,8(sp)
     df8:	6402                	ld	s0,0(sp)
     dfa:	0141                	addi	sp,sp,16
     dfc:	8082                	ret

0000000000000dfe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dfe:	4885                	li	a7,1
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e06:	4889                	li	a7,2
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <wait>:
.global wait
wait:
 li a7, SYS_wait
     e0e:	488d                	li	a7,3
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e16:	4891                	li	a7,4
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <read>:
.global read
read:
 li a7, SYS_read
     e1e:	4895                	li	a7,5
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <write>:
.global write
write:
 li a7, SYS_write
     e26:	48c1                	li	a7,16
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <close>:
.global close
close:
 li a7, SYS_close
     e2e:	48d5                	li	a7,21
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e36:	4899                	li	a7,6
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e3e:	489d                	li	a7,7
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <open>:
.global open
open:
 li a7, SYS_open
     e46:	48bd                	li	a7,15
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e4e:	48c5                	li	a7,17
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e56:	48c9                	li	a7,18
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e5e:	48a1                	li	a7,8
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <link>:
.global link
link:
 li a7, SYS_link
     e66:	48cd                	li	a7,19
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e6e:	48d1                	li	a7,20
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e76:	48a5                	li	a7,9
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e7e:	48a9                	li	a7,10
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e86:	48ad                	li	a7,11
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e8e:	48b1                	li	a7,12
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e96:	48b5                	li	a7,13
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e9e:	48b9                	li	a7,14
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <trace>:
.global trace
trace:
 li a7, SYS_trace
     ea6:	48d9                	li	a7,22
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
     eae:	48dd                	li	a7,23
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     eb6:	1101                	addi	sp,sp,-32
     eb8:	ec06                	sd	ra,24(sp)
     eba:	e822                	sd	s0,16(sp)
     ebc:	1000                	addi	s0,sp,32
     ebe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ec2:	4605                	li	a2,1
     ec4:	fef40593          	addi	a1,s0,-17
     ec8:	00000097          	auipc	ra,0x0
     ecc:	f5e080e7          	jalr	-162(ra) # e26 <write>
}
     ed0:	60e2                	ld	ra,24(sp)
     ed2:	6442                	ld	s0,16(sp)
     ed4:	6105                	addi	sp,sp,32
     ed6:	8082                	ret

0000000000000ed8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ed8:	7139                	addi	sp,sp,-64
     eda:	fc06                	sd	ra,56(sp)
     edc:	f822                	sd	s0,48(sp)
     ede:	f426                	sd	s1,40(sp)
     ee0:	f04a                	sd	s2,32(sp)
     ee2:	ec4e                	sd	s3,24(sp)
     ee4:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ee6:	c299                	beqz	a3,eec <printint+0x14>
     ee8:	0005cd63          	bltz	a1,f02 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     eec:	2581                	sext.w	a1,a1
  neg = 0;
     eee:	4301                	li	t1,0
     ef0:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
     ef4:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
     ef6:	2601                	sext.w	a2,a2
     ef8:	00000897          	auipc	a7,0x0
     efc:	58888893          	addi	a7,a7,1416 # 1480 <digits>
     f00:	a801                	j	f10 <printint+0x38>
    x = -xx;
     f02:	40b005bb          	negw	a1,a1
     f06:	2581                	sext.w	a1,a1
    neg = 1;
     f08:	4305                	li	t1,1
    x = -xx;
     f0a:	b7dd                	j	ef0 <printint+0x18>
  }while((x /= base) != 0);
     f0c:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
     f0e:	8836                	mv	a6,a3
     f10:	0018069b          	addiw	a3,a6,1
     f14:	02c5f7bb          	remuw	a5,a1,a2
     f18:	1782                	slli	a5,a5,0x20
     f1a:	9381                	srli	a5,a5,0x20
     f1c:	97c6                	add	a5,a5,a7
     f1e:	0007c783          	lbu	a5,0(a5)
     f22:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
     f26:	0705                	addi	a4,a4,1
     f28:	02c5d7bb          	divuw	a5,a1,a2
     f2c:	fec5f0e3          	bleu	a2,a1,f0c <printint+0x34>
  if(neg)
     f30:	00030b63          	beqz	t1,f46 <printint+0x6e>
    buf[i++] = '-';
     f34:	fd040793          	addi	a5,s0,-48
     f38:	96be                	add	a3,a3,a5
     f3a:	02d00793          	li	a5,45
     f3e:	fef68823          	sb	a5,-16(a3)
     f42:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
     f46:	02d05963          	blez	a3,f78 <printint+0xa0>
     f4a:	89aa                	mv	s3,a0
     f4c:	fc040793          	addi	a5,s0,-64
     f50:	00d784b3          	add	s1,a5,a3
     f54:	fff78913          	addi	s2,a5,-1
     f58:	9936                	add	s2,s2,a3
     f5a:	36fd                	addiw	a3,a3,-1
     f5c:	1682                	slli	a3,a3,0x20
     f5e:	9281                	srli	a3,a3,0x20
     f60:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
     f64:	fff4c583          	lbu	a1,-1(s1)
     f68:	854e                	mv	a0,s3
     f6a:	00000097          	auipc	ra,0x0
     f6e:	f4c080e7          	jalr	-180(ra) # eb6 <putc>
  while(--i >= 0)
     f72:	14fd                	addi	s1,s1,-1
     f74:	ff2498e3          	bne	s1,s2,f64 <printint+0x8c>
}
     f78:	70e2                	ld	ra,56(sp)
     f7a:	7442                	ld	s0,48(sp)
     f7c:	74a2                	ld	s1,40(sp)
     f7e:	7902                	ld	s2,32(sp)
     f80:	69e2                	ld	s3,24(sp)
     f82:	6121                	addi	sp,sp,64
     f84:	8082                	ret

0000000000000f86 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f86:	7119                	addi	sp,sp,-128
     f88:	fc86                	sd	ra,120(sp)
     f8a:	f8a2                	sd	s0,112(sp)
     f8c:	f4a6                	sd	s1,104(sp)
     f8e:	f0ca                	sd	s2,96(sp)
     f90:	ecce                	sd	s3,88(sp)
     f92:	e8d2                	sd	s4,80(sp)
     f94:	e4d6                	sd	s5,72(sp)
     f96:	e0da                	sd	s6,64(sp)
     f98:	fc5e                	sd	s7,56(sp)
     f9a:	f862                	sd	s8,48(sp)
     f9c:	f466                	sd	s9,40(sp)
     f9e:	f06a                	sd	s10,32(sp)
     fa0:	ec6e                	sd	s11,24(sp)
     fa2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fa4:	0005c483          	lbu	s1,0(a1)
     fa8:	18048d63          	beqz	s1,1142 <vprintf+0x1bc>
     fac:	8aaa                	mv	s5,a0
     fae:	8b32                	mv	s6,a2
     fb0:	00158913          	addi	s2,a1,1
  state = 0;
     fb4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fb6:	02500a13          	li	s4,37
      if(c == 'd'){
     fba:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     fbe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     fc2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     fc6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fca:	00000b97          	auipc	s7,0x0
     fce:	4b6b8b93          	addi	s7,s7,1206 # 1480 <digits>
     fd2:	a839                	j	ff0 <vprintf+0x6a>
        putc(fd, c);
     fd4:	85a6                	mv	a1,s1
     fd6:	8556                	mv	a0,s5
     fd8:	00000097          	auipc	ra,0x0
     fdc:	ede080e7          	jalr	-290(ra) # eb6 <putc>
     fe0:	a019                	j	fe6 <vprintf+0x60>
    } else if(state == '%'){
     fe2:	01498f63          	beq	s3,s4,1000 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     fe6:	0905                	addi	s2,s2,1
     fe8:	fff94483          	lbu	s1,-1(s2)
     fec:	14048b63          	beqz	s1,1142 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
     ff0:	0004879b          	sext.w	a5,s1
    if(state == 0){
     ff4:	fe0997e3          	bnez	s3,fe2 <vprintf+0x5c>
      if(c == '%'){
     ff8:	fd479ee3          	bne	a5,s4,fd4 <vprintf+0x4e>
        state = '%';
     ffc:	89be                	mv	s3,a5
     ffe:	b7e5                	j	fe6 <vprintf+0x60>
      if(c == 'd'){
    1000:	05878063          	beq	a5,s8,1040 <vprintf+0xba>
      } else if(c == 'l') {
    1004:	05978c63          	beq	a5,s9,105c <vprintf+0xd6>
      } else if(c == 'x') {
    1008:	07a78863          	beq	a5,s10,1078 <vprintf+0xf2>
      } else if(c == 'p') {
    100c:	09b78463          	beq	a5,s11,1094 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1010:	07300713          	li	a4,115
    1014:	0ce78563          	beq	a5,a4,10de <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1018:	06300713          	li	a4,99
    101c:	0ee78c63          	beq	a5,a4,1114 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1020:	11478663          	beq	a5,s4,112c <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1024:	85d2                	mv	a1,s4
    1026:	8556                	mv	a0,s5
    1028:	00000097          	auipc	ra,0x0
    102c:	e8e080e7          	jalr	-370(ra) # eb6 <putc>
        putc(fd, c);
    1030:	85a6                	mv	a1,s1
    1032:	8556                	mv	a0,s5
    1034:	00000097          	auipc	ra,0x0
    1038:	e82080e7          	jalr	-382(ra) # eb6 <putc>
      }
      state = 0;
    103c:	4981                	li	s3,0
    103e:	b765                	j	fe6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1040:	008b0493          	addi	s1,s6,8
    1044:	4685                	li	a3,1
    1046:	4629                	li	a2,10
    1048:	000b2583          	lw	a1,0(s6)
    104c:	8556                	mv	a0,s5
    104e:	00000097          	auipc	ra,0x0
    1052:	e8a080e7          	jalr	-374(ra) # ed8 <printint>
    1056:	8b26                	mv	s6,s1
      state = 0;
    1058:	4981                	li	s3,0
    105a:	b771                	j	fe6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    105c:	008b0493          	addi	s1,s6,8
    1060:	4681                	li	a3,0
    1062:	4629                	li	a2,10
    1064:	000b2583          	lw	a1,0(s6)
    1068:	8556                	mv	a0,s5
    106a:	00000097          	auipc	ra,0x0
    106e:	e6e080e7          	jalr	-402(ra) # ed8 <printint>
    1072:	8b26                	mv	s6,s1
      state = 0;
    1074:	4981                	li	s3,0
    1076:	bf85                	j	fe6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1078:	008b0493          	addi	s1,s6,8
    107c:	4681                	li	a3,0
    107e:	4641                	li	a2,16
    1080:	000b2583          	lw	a1,0(s6)
    1084:	8556                	mv	a0,s5
    1086:	00000097          	auipc	ra,0x0
    108a:	e52080e7          	jalr	-430(ra) # ed8 <printint>
    108e:	8b26                	mv	s6,s1
      state = 0;
    1090:	4981                	li	s3,0
    1092:	bf91                	j	fe6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1094:	008b0793          	addi	a5,s6,8
    1098:	f8f43423          	sd	a5,-120(s0)
    109c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10a0:	03000593          	li	a1,48
    10a4:	8556                	mv	a0,s5
    10a6:	00000097          	auipc	ra,0x0
    10aa:	e10080e7          	jalr	-496(ra) # eb6 <putc>
  putc(fd, 'x');
    10ae:	85ea                	mv	a1,s10
    10b0:	8556                	mv	a0,s5
    10b2:	00000097          	auipc	ra,0x0
    10b6:	e04080e7          	jalr	-508(ra) # eb6 <putc>
    10ba:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10bc:	03c9d793          	srli	a5,s3,0x3c
    10c0:	97de                	add	a5,a5,s7
    10c2:	0007c583          	lbu	a1,0(a5)
    10c6:	8556                	mv	a0,s5
    10c8:	00000097          	auipc	ra,0x0
    10cc:	dee080e7          	jalr	-530(ra) # eb6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10d0:	0992                	slli	s3,s3,0x4
    10d2:	34fd                	addiw	s1,s1,-1
    10d4:	f4e5                	bnez	s1,10bc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    10d6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10da:	4981                	li	s3,0
    10dc:	b729                	j	fe6 <vprintf+0x60>
        s = va_arg(ap, char*);
    10de:	008b0993          	addi	s3,s6,8
    10e2:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    10e6:	c085                	beqz	s1,1106 <vprintf+0x180>
        while(*s != 0){
    10e8:	0004c583          	lbu	a1,0(s1)
    10ec:	c9a1                	beqz	a1,113c <vprintf+0x1b6>
          putc(fd, *s);
    10ee:	8556                	mv	a0,s5
    10f0:	00000097          	auipc	ra,0x0
    10f4:	dc6080e7          	jalr	-570(ra) # eb6 <putc>
          s++;
    10f8:	0485                	addi	s1,s1,1
        while(*s != 0){
    10fa:	0004c583          	lbu	a1,0(s1)
    10fe:	f9e5                	bnez	a1,10ee <vprintf+0x168>
        s = va_arg(ap, char*);
    1100:	8b4e                	mv	s6,s3
      state = 0;
    1102:	4981                	li	s3,0
    1104:	b5cd                	j	fe6 <vprintf+0x60>
          s = "(null)";
    1106:	00000497          	auipc	s1,0x0
    110a:	39248493          	addi	s1,s1,914 # 1498 <digits+0x18>
        while(*s != 0){
    110e:	02800593          	li	a1,40
    1112:	bff1                	j	10ee <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    1114:	008b0493          	addi	s1,s6,8
    1118:	000b4583          	lbu	a1,0(s6)
    111c:	8556                	mv	a0,s5
    111e:	00000097          	auipc	ra,0x0
    1122:	d98080e7          	jalr	-616(ra) # eb6 <putc>
    1126:	8b26                	mv	s6,s1
      state = 0;
    1128:	4981                	li	s3,0
    112a:	bd75                	j	fe6 <vprintf+0x60>
        putc(fd, c);
    112c:	85d2                	mv	a1,s4
    112e:	8556                	mv	a0,s5
    1130:	00000097          	auipc	ra,0x0
    1134:	d86080e7          	jalr	-634(ra) # eb6 <putc>
      state = 0;
    1138:	4981                	li	s3,0
    113a:	b575                	j	fe6 <vprintf+0x60>
        s = va_arg(ap, char*);
    113c:	8b4e                	mv	s6,s3
      state = 0;
    113e:	4981                	li	s3,0
    1140:	b55d                	j	fe6 <vprintf+0x60>
    }
  }
}
    1142:	70e6                	ld	ra,120(sp)
    1144:	7446                	ld	s0,112(sp)
    1146:	74a6                	ld	s1,104(sp)
    1148:	7906                	ld	s2,96(sp)
    114a:	69e6                	ld	s3,88(sp)
    114c:	6a46                	ld	s4,80(sp)
    114e:	6aa6                	ld	s5,72(sp)
    1150:	6b06                	ld	s6,64(sp)
    1152:	7be2                	ld	s7,56(sp)
    1154:	7c42                	ld	s8,48(sp)
    1156:	7ca2                	ld	s9,40(sp)
    1158:	7d02                	ld	s10,32(sp)
    115a:	6de2                	ld	s11,24(sp)
    115c:	6109                	addi	sp,sp,128
    115e:	8082                	ret

0000000000001160 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1160:	715d                	addi	sp,sp,-80
    1162:	ec06                	sd	ra,24(sp)
    1164:	e822                	sd	s0,16(sp)
    1166:	1000                	addi	s0,sp,32
    1168:	e010                	sd	a2,0(s0)
    116a:	e414                	sd	a3,8(s0)
    116c:	e818                	sd	a4,16(s0)
    116e:	ec1c                	sd	a5,24(s0)
    1170:	03043023          	sd	a6,32(s0)
    1174:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1178:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    117c:	8622                	mv	a2,s0
    117e:	00000097          	auipc	ra,0x0
    1182:	e08080e7          	jalr	-504(ra) # f86 <vprintf>
}
    1186:	60e2                	ld	ra,24(sp)
    1188:	6442                	ld	s0,16(sp)
    118a:	6161                	addi	sp,sp,80
    118c:	8082                	ret

000000000000118e <printf>:

void
printf(const char *fmt, ...)
{
    118e:	711d                	addi	sp,sp,-96
    1190:	ec06                	sd	ra,24(sp)
    1192:	e822                	sd	s0,16(sp)
    1194:	1000                	addi	s0,sp,32
    1196:	e40c                	sd	a1,8(s0)
    1198:	e810                	sd	a2,16(s0)
    119a:	ec14                	sd	a3,24(s0)
    119c:	f018                	sd	a4,32(s0)
    119e:	f41c                	sd	a5,40(s0)
    11a0:	03043823          	sd	a6,48(s0)
    11a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11a8:	00840613          	addi	a2,s0,8
    11ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11b0:	85aa                	mv	a1,a0
    11b2:	4505                	li	a0,1
    11b4:	00000097          	auipc	ra,0x0
    11b8:	dd2080e7          	jalr	-558(ra) # f86 <vprintf>
}
    11bc:	60e2                	ld	ra,24(sp)
    11be:	6442                	ld	s0,16(sp)
    11c0:	6125                	addi	sp,sp,96
    11c2:	8082                	ret

00000000000011c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11c4:	1141                	addi	sp,sp,-16
    11c6:	e422                	sd	s0,8(sp)
    11c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ce:	00001797          	auipc	a5,0x1
    11d2:	e4278793          	addi	a5,a5,-446 # 2010 <freep>
    11d6:	639c                	ld	a5,0(a5)
    11d8:	a805                	j	1208 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11da:	4618                	lw	a4,8(a2)
    11dc:	9db9                	addw	a1,a1,a4
    11de:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11e2:	6398                	ld	a4,0(a5)
    11e4:	6318                	ld	a4,0(a4)
    11e6:	fee53823          	sd	a4,-16(a0)
    11ea:	a091                	j	122e <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11ec:	ff852703          	lw	a4,-8(a0)
    11f0:	9e39                	addw	a2,a2,a4
    11f2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    11f4:	ff053703          	ld	a4,-16(a0)
    11f8:	e398                	sd	a4,0(a5)
    11fa:	a099                	j	1240 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11fc:	6398                	ld	a4,0(a5)
    11fe:	00e7e463          	bltu	a5,a4,1206 <free+0x42>
    1202:	00e6ea63          	bltu	a3,a4,1216 <free+0x52>
{
    1206:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1208:	fed7fae3          	bleu	a3,a5,11fc <free+0x38>
    120c:	6398                	ld	a4,0(a5)
    120e:	00e6e463          	bltu	a3,a4,1216 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1212:	fee7eae3          	bltu	a5,a4,1206 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    1216:	ff852583          	lw	a1,-8(a0)
    121a:	6390                	ld	a2,0(a5)
    121c:	02059713          	slli	a4,a1,0x20
    1220:	9301                	srli	a4,a4,0x20
    1222:	0712                	slli	a4,a4,0x4
    1224:	9736                	add	a4,a4,a3
    1226:	fae60ae3          	beq	a2,a4,11da <free+0x16>
    bp->s.ptr = p->s.ptr;
    122a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    122e:	4790                	lw	a2,8(a5)
    1230:	02061713          	slli	a4,a2,0x20
    1234:	9301                	srli	a4,a4,0x20
    1236:	0712                	slli	a4,a4,0x4
    1238:	973e                	add	a4,a4,a5
    123a:	fae689e3          	beq	a3,a4,11ec <free+0x28>
  } else
    p->s.ptr = bp;
    123e:	e394                	sd	a3,0(a5)
  freep = p;
    1240:	00001717          	auipc	a4,0x1
    1244:	dcf73823          	sd	a5,-560(a4) # 2010 <freep>
}
    1248:	6422                	ld	s0,8(sp)
    124a:	0141                	addi	sp,sp,16
    124c:	8082                	ret

000000000000124e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    124e:	7139                	addi	sp,sp,-64
    1250:	fc06                	sd	ra,56(sp)
    1252:	f822                	sd	s0,48(sp)
    1254:	f426                	sd	s1,40(sp)
    1256:	f04a                	sd	s2,32(sp)
    1258:	ec4e                	sd	s3,24(sp)
    125a:	e852                	sd	s4,16(sp)
    125c:	e456                	sd	s5,8(sp)
    125e:	e05a                	sd	s6,0(sp)
    1260:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1262:	02051993          	slli	s3,a0,0x20
    1266:	0209d993          	srli	s3,s3,0x20
    126a:	09bd                	addi	s3,s3,15
    126c:	0049d993          	srli	s3,s3,0x4
    1270:	2985                	addiw	s3,s3,1
    1272:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    1276:	00001797          	auipc	a5,0x1
    127a:	d9a78793          	addi	a5,a5,-614 # 2010 <freep>
    127e:	6388                	ld	a0,0(a5)
    1280:	c515                	beqz	a0,12ac <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1282:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1284:	4798                	lw	a4,8(a5)
    1286:	03277f63          	bleu	s2,a4,12c4 <malloc+0x76>
    128a:	8a4e                	mv	s4,s3
    128c:	0009871b          	sext.w	a4,s3
    1290:	6685                	lui	a3,0x1
    1292:	00d77363          	bleu	a3,a4,1298 <malloc+0x4a>
    1296:	6a05                	lui	s4,0x1
    1298:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    129c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12a0:	00001497          	auipc	s1,0x1
    12a4:	d7048493          	addi	s1,s1,-656 # 2010 <freep>
  if(p == (char*)-1)
    12a8:	5b7d                	li	s6,-1
    12aa:	a885                	j	131a <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    12ac:	00001797          	auipc	a5,0x1
    12b0:	ddc78793          	addi	a5,a5,-548 # 2088 <base>
    12b4:	00001717          	auipc	a4,0x1
    12b8:	d4f73e23          	sd	a5,-676(a4) # 2010 <freep>
    12bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12c2:	b7e1                	j	128a <malloc+0x3c>
      if(p->s.size == nunits)
    12c4:	02e90b63          	beq	s2,a4,12fa <malloc+0xac>
        p->s.size -= nunits;
    12c8:	4137073b          	subw	a4,a4,s3
    12cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12ce:	1702                	slli	a4,a4,0x20
    12d0:	9301                	srli	a4,a4,0x20
    12d2:	0712                	slli	a4,a4,0x4
    12d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12da:	00001717          	auipc	a4,0x1
    12de:	d2a73b23          	sd	a0,-714(a4) # 2010 <freep>
      return (void*)(p + 1);
    12e2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12e6:	70e2                	ld	ra,56(sp)
    12e8:	7442                	ld	s0,48(sp)
    12ea:	74a2                	ld	s1,40(sp)
    12ec:	7902                	ld	s2,32(sp)
    12ee:	69e2                	ld	s3,24(sp)
    12f0:	6a42                	ld	s4,16(sp)
    12f2:	6aa2                	ld	s5,8(sp)
    12f4:	6b02                	ld	s6,0(sp)
    12f6:	6121                	addi	sp,sp,64
    12f8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12fa:	6398                	ld	a4,0(a5)
    12fc:	e118                	sd	a4,0(a0)
    12fe:	bff1                	j	12da <malloc+0x8c>
  hp->s.size = nu;
    1300:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    1304:	0541                	addi	a0,a0,16
    1306:	00000097          	auipc	ra,0x0
    130a:	ebe080e7          	jalr	-322(ra) # 11c4 <free>
  return freep;
    130e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1310:	d979                	beqz	a0,12e6 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1312:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1314:	4798                	lw	a4,8(a5)
    1316:	fb2777e3          	bleu	s2,a4,12c4 <malloc+0x76>
    if(p == freep)
    131a:	6098                	ld	a4,0(s1)
    131c:	853e                	mv	a0,a5
    131e:	fef71ae3          	bne	a4,a5,1312 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    1322:	8552                	mv	a0,s4
    1324:	00000097          	auipc	ra,0x0
    1328:	b6a080e7          	jalr	-1174(ra) # e8e <sbrk>
  if(p == (char*)-1)
    132c:	fd651ae3          	bne	a0,s6,1300 <malloc+0xb2>
        return 0;
    1330:	4501                	li	a0,0
    1332:	bf55                	j	12e6 <malloc+0x98>
