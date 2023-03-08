
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a1013103          	ld	sp,-1520(sp) # 80008a10 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	163050ef          	jal	ra,80005978 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	6785                	lui	a5,0x1
    8000002a:	17fd                	addi	a5,a5,-1
    8000002c:	8fe9                	and	a5,a5,a0
    8000002e:	ebb9                	bnez	a5,80000084 <kfree+0x68>
    80000030:	84aa                	mv	s1,a0
    80000032:	00022797          	auipc	a5,0x22
    80000036:	09e78793          	addi	a5,a5,158 # 800220d0 <end>
    8000003a:	04f56563          	bltu	a0,a5,80000084 <kfree+0x68>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57163          	bleu	a5,a0,80000084 <kfree+0x68>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000046:	6605                	lui	a2,0x1
    80000048:	4585                	li	a1,1
    8000004a:	00000097          	auipc	ra,0x0
    8000004e:	15a080e7          	jalr	346(ra) # 800001a4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000052:	00009917          	auipc	s2,0x9
    80000056:	a0e90913          	addi	s2,s2,-1522 # 80008a60 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	00006097          	auipc	ra,0x6
    80000060:	368080e7          	jalr	872(ra) # 800063c4 <acquire>
  r->next = kmem.freelist;
    80000064:	01893783          	ld	a5,24(s2)
    80000068:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000006a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006e:	854a                	mv	a0,s2
    80000070:	00006097          	auipc	ra,0x6
    80000074:	408080e7          	jalr	1032(ra) # 80006478 <release>
}
    80000078:	60e2                	ld	ra,24(sp)
    8000007a:	6442                	ld	s0,16(sp)
    8000007c:	64a2                	ld	s1,8(sp)
    8000007e:	6902                	ld	s2,0(sp)
    80000080:	6105                	addi	sp,sp,32
    80000082:	8082                	ret
    panic("kfree");
    80000084:	00008517          	auipc	a0,0x8
    80000088:	f8c50513          	addi	a0,a0,-116 # 80008010 <etext+0x10>
    8000008c:	00006097          	auipc	ra,0x6
    80000090:	dcc080e7          	jalr	-564(ra) # 80005e58 <panic>

0000000080000094 <freerange>:
{
    80000094:	7179                	addi	sp,sp,-48
    80000096:	f406                	sd	ra,40(sp)
    80000098:	f022                	sd	s0,32(sp)
    8000009a:	ec26                	sd	s1,24(sp)
    8000009c:	e84a                	sd	s2,16(sp)
    8000009e:	e44e                	sd	s3,8(sp)
    800000a0:	e052                	sd	s4,0(sp)
    800000a2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a4:	6705                	lui	a4,0x1
    800000a6:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    800000aa:	00f504b3          	add	s1,a0,a5
    800000ae:	77fd                	lui	a5,0xfffff
    800000b0:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b2:	94ba                	add	s1,s1,a4
    800000b4:	0095ee63          	bltu	a1,s1,800000d0 <freerange+0x3c>
    800000b8:	892e                	mv	s2,a1
    kfree(p);
    800000ba:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000bc:	6985                	lui	s3,0x1
    kfree(p);
    800000be:	01448533          	add	a0,s1,s4
    800000c2:	00000097          	auipc	ra,0x0
    800000c6:	f5a080e7          	jalr	-166(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ca:	94ce                	add	s1,s1,s3
    800000cc:	fe9979e3          	bleu	s1,s2,800000be <freerange+0x2a>
}
    800000d0:	70a2                	ld	ra,40(sp)
    800000d2:	7402                	ld	s0,32(sp)
    800000d4:	64e2                	ld	s1,24(sp)
    800000d6:	6942                	ld	s2,16(sp)
    800000d8:	69a2                	ld	s3,8(sp)
    800000da:	6a02                	ld	s4,0(sp)
    800000dc:	6145                	addi	sp,sp,48
    800000de:	8082                	ret

00000000800000e0 <kinit>:
{
    800000e0:	1141                	addi	sp,sp,-16
    800000e2:	e406                	sd	ra,8(sp)
    800000e4:	e022                	sd	s0,0(sp)
    800000e6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e8:	00008597          	auipc	a1,0x8
    800000ec:	f3058593          	addi	a1,a1,-208 # 80008018 <etext+0x18>
    800000f0:	00009517          	auipc	a0,0x9
    800000f4:	97050513          	addi	a0,a0,-1680 # 80008a60 <kmem>
    800000f8:	00006097          	auipc	ra,0x6
    800000fc:	23c080e7          	jalr	572(ra) # 80006334 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000100:	45c5                	li	a1,17
    80000102:	05ee                	slli	a1,a1,0x1b
    80000104:	00022517          	auipc	a0,0x22
    80000108:	fcc50513          	addi	a0,a0,-52 # 800220d0 <end>
    8000010c:	00000097          	auipc	ra,0x0
    80000110:	f88080e7          	jalr	-120(ra) # 80000094 <freerange>
}
    80000114:	60a2                	ld	ra,8(sp)
    80000116:	6402                	ld	s0,0(sp)
    80000118:	0141                	addi	sp,sp,16
    8000011a:	8082                	ret

000000008000011c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011c:	1101                	addi	sp,sp,-32
    8000011e:	ec06                	sd	ra,24(sp)
    80000120:	e822                	sd	s0,16(sp)
    80000122:	e426                	sd	s1,8(sp)
    80000124:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000126:	00009497          	auipc	s1,0x9
    8000012a:	93a48493          	addi	s1,s1,-1734 # 80008a60 <kmem>
    8000012e:	8526                	mv	a0,s1
    80000130:	00006097          	auipc	ra,0x6
    80000134:	294080e7          	jalr	660(ra) # 800063c4 <acquire>
  r = kmem.freelist;
    80000138:	6c84                	ld	s1,24(s1)
  if(r)
    8000013a:	c885                	beqz	s1,8000016a <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013c:	609c                	ld	a5,0(s1)
    8000013e:	00009517          	auipc	a0,0x9
    80000142:	92250513          	addi	a0,a0,-1758 # 80008a60 <kmem>
    80000146:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000148:	00006097          	auipc	ra,0x6
    8000014c:	330080e7          	jalr	816(ra) # 80006478 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000150:	6605                	lui	a2,0x1
    80000152:	4595                	li	a1,5
    80000154:	8526                	mv	a0,s1
    80000156:	00000097          	auipc	ra,0x0
    8000015a:	04e080e7          	jalr	78(ra) # 800001a4 <memset>
  return (void*)r;
}
    8000015e:	8526                	mv	a0,s1
    80000160:	60e2                	ld	ra,24(sp)
    80000162:	6442                	ld	s0,16(sp)
    80000164:	64a2                	ld	s1,8(sp)
    80000166:	6105                	addi	sp,sp,32
    80000168:	8082                	ret
  release(&kmem.lock);
    8000016a:	00009517          	auipc	a0,0x9
    8000016e:	8f650513          	addi	a0,a0,-1802 # 80008a60 <kmem>
    80000172:	00006097          	auipc	ra,0x6
    80000176:	306080e7          	jalr	774(ra) # 80006478 <release>
  if(r)
    8000017a:	b7d5                	j	8000015e <kalloc+0x42>

000000008000017c <getFreeMemorySize>:

int getFreeMemorySize(){
    8000017c:	1141                	addi	sp,sp,-16
    8000017e:	e422                	sd	s0,8(sp)
    80000180:	0800                	addi	s0,sp,16
  uint64 size = 0;
  struct run *r;
  r = kmem.freelist;
    80000182:	00009797          	auipc	a5,0x9
    80000186:	8de78793          	addi	a5,a5,-1826 # 80008a60 <kmem>
    8000018a:	6f9c                	ld	a5,24(a5)
  while(r){
    8000018c:	cb91                	beqz	a5,800001a0 <getFreeMemorySize+0x24>
  uint64 size = 0;
    8000018e:	4501                	li	a0,0
    size++;
    80000190:	0505                	addi	a0,a0,1
    r = r->next;
    80000192:	639c                	ld	a5,0(a5)
  while(r){
    80000194:	fff5                	bnez	a5,80000190 <getFreeMemorySize+0x14>
  }
  return size * PGSIZE;
    80000196:	00c5151b          	slliw	a0,a0,0xc
    8000019a:	6422                	ld	s0,8(sp)
    8000019c:	0141                	addi	sp,sp,16
    8000019e:	8082                	ret
  uint64 size = 0;
    800001a0:	4501                	li	a0,0
    800001a2:	bfd5                	j	80000196 <getFreeMemorySize+0x1a>

00000000800001a4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001a4:	1141                	addi	sp,sp,-16
    800001a6:	e422                	sd	s0,8(sp)
    800001a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001aa:	ce09                	beqz	a2,800001c4 <memset+0x20>
    800001ac:	87aa                	mv	a5,a0
    800001ae:	fff6071b          	addiw	a4,a2,-1
    800001b2:	1702                	slli	a4,a4,0x20
    800001b4:	9301                	srli	a4,a4,0x20
    800001b6:	0705                	addi	a4,a4,1
    800001b8:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001be:	0785                	addi	a5,a5,1
    800001c0:	fee79de3          	bne	a5,a4,800001ba <memset+0x16>
  }
  return dst;
}
    800001c4:	6422                	ld	s0,8(sp)
    800001c6:	0141                	addi	sp,sp,16
    800001c8:	8082                	ret

00000000800001ca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001ca:	1141                	addi	sp,sp,-16
    800001cc:	e422                	sd	s0,8(sp)
    800001ce:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001d0:	ce15                	beqz	a2,8000020c <memcmp+0x42>
    800001d2:	fff6069b          	addiw	a3,a2,-1
    if(*s1 != *s2)
    800001d6:	00054783          	lbu	a5,0(a0)
    800001da:	0005c703          	lbu	a4,0(a1)
    800001de:	02e79063          	bne	a5,a4,800001fe <memcmp+0x34>
    800001e2:	1682                	slli	a3,a3,0x20
    800001e4:	9281                	srli	a3,a3,0x20
    800001e6:	0685                	addi	a3,a3,1
    800001e8:	96aa                	add	a3,a3,a0
      return *s1 - *s2;
    s1++, s2++;
    800001ea:	0505                	addi	a0,a0,1
    800001ec:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001ee:	00d50d63          	beq	a0,a3,80000208 <memcmp+0x3e>
    if(*s1 != *s2)
    800001f2:	00054783          	lbu	a5,0(a0)
    800001f6:	0005c703          	lbu	a4,0(a1)
    800001fa:	fee788e3          	beq	a5,a4,800001ea <memcmp+0x20>
      return *s1 - *s2;
    800001fe:	40e7853b          	subw	a0,a5,a4
  }

  return 0;
}
    80000202:	6422                	ld	s0,8(sp)
    80000204:	0141                	addi	sp,sp,16
    80000206:	8082                	ret
  return 0;
    80000208:	4501                	li	a0,0
    8000020a:	bfe5                	j	80000202 <memcmp+0x38>
    8000020c:	4501                	li	a0,0
    8000020e:	bfd5                	j	80000202 <memcmp+0x38>

0000000080000210 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000210:	1141                	addi	sp,sp,-16
    80000212:	e422                	sd	s0,8(sp)
    80000214:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000216:	ca0d                	beqz	a2,80000248 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000218:	00a5f963          	bleu	a0,a1,8000022a <memmove+0x1a>
    8000021c:	02061693          	slli	a3,a2,0x20
    80000220:	9281                	srli	a3,a3,0x20
    80000222:	00d58733          	add	a4,a1,a3
    80000226:	02e56463          	bltu	a0,a4,8000024e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022a:	fff6079b          	addiw	a5,a2,-1
    8000022e:	1782                	slli	a5,a5,0x20
    80000230:	9381                	srli	a5,a5,0x20
    80000232:	0785                	addi	a5,a5,1
    80000234:	97ae                	add	a5,a5,a1
    80000236:	872a                	mv	a4,a0
      *d++ = *s++;
    80000238:	0585                	addi	a1,a1,1
    8000023a:	0705                	addi	a4,a4,1
    8000023c:	fff5c683          	lbu	a3,-1(a1)
    80000240:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000244:	fef59ae3          	bne	a1,a5,80000238 <memmove+0x28>

  return dst;
}
    80000248:	6422                	ld	s0,8(sp)
    8000024a:	0141                	addi	sp,sp,16
    8000024c:	8082                	ret
    d += n;
    8000024e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000250:	fff6079b          	addiw	a5,a2,-1
    80000254:	1782                	slli	a5,a5,0x20
    80000256:	9381                	srli	a5,a5,0x20
    80000258:	fff7c793          	not	a5,a5
    8000025c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000025e:	177d                	addi	a4,a4,-1
    80000260:	16fd                	addi	a3,a3,-1
    80000262:	00074603          	lbu	a2,0(a4)
    80000266:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000026a:	fee79ae3          	bne	a5,a4,8000025e <memmove+0x4e>
    8000026e:	bfe9                	j	80000248 <memmove+0x38>

0000000080000270 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000270:	1141                	addi	sp,sp,-16
    80000272:	e406                	sd	ra,8(sp)
    80000274:	e022                	sd	s0,0(sp)
    80000276:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	f98080e7          	jalr	-104(ra) # 80000210 <memmove>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret

0000000080000288 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e422                	sd	s0,8(sp)
    8000028c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000028e:	c229                	beqz	a2,800002d0 <strncmp+0x48>
    80000290:	00054783          	lbu	a5,0(a0)
    80000294:	c795                	beqz	a5,800002c0 <strncmp+0x38>
    80000296:	0005c703          	lbu	a4,0(a1)
    8000029a:	02f71363          	bne	a4,a5,800002c0 <strncmp+0x38>
    8000029e:	fff6071b          	addiw	a4,a2,-1
    800002a2:	1702                	slli	a4,a4,0x20
    800002a4:	9301                	srli	a4,a4,0x20
    800002a6:	0705                	addi	a4,a4,1
    800002a8:	972a                	add	a4,a4,a0
    n--, p++, q++;
    800002aa:	0505                	addi	a0,a0,1
    800002ac:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002ae:	02e50363          	beq	a0,a4,800002d4 <strncmp+0x4c>
    800002b2:	00054783          	lbu	a5,0(a0)
    800002b6:	c789                	beqz	a5,800002c0 <strncmp+0x38>
    800002b8:	0005c683          	lbu	a3,0(a1)
    800002bc:	fef687e3          	beq	a3,a5,800002aa <strncmp+0x22>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
    800002c0:	00054503          	lbu	a0,0(a0)
    800002c4:	0005c783          	lbu	a5,0(a1)
    800002c8:	9d1d                	subw	a0,a0,a5
}
    800002ca:	6422                	ld	s0,8(sp)
    800002cc:	0141                	addi	sp,sp,16
    800002ce:	8082                	ret
    return 0;
    800002d0:	4501                	li	a0,0
    800002d2:	bfe5                	j	800002ca <strncmp+0x42>
    800002d4:	4501                	li	a0,0
    800002d6:	bfd5                	j	800002ca <strncmp+0x42>

00000000800002d8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d8:	1141                	addi	sp,sp,-16
    800002da:	e422                	sd	s0,8(sp)
    800002dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002de:	872a                	mv	a4,a0
    800002e0:	a011                	j	800002e4 <strncpy+0xc>
    800002e2:	8636                	mv	a2,a3
    800002e4:	fff6069b          	addiw	a3,a2,-1
    800002e8:	00c05963          	blez	a2,800002fa <strncpy+0x22>
    800002ec:	0705                	addi	a4,a4,1
    800002ee:	0005c783          	lbu	a5,0(a1)
    800002f2:	fef70fa3          	sb	a5,-1(a4)
    800002f6:	0585                	addi	a1,a1,1
    800002f8:	f7ed                	bnez	a5,800002e2 <strncpy+0xa>
    ;
  while(n-- > 0)
    800002fa:	00d05c63          	blez	a3,80000312 <strncpy+0x3a>
    800002fe:	86ba                	mv	a3,a4
    *s++ = 0;
    80000300:	0685                	addi	a3,a3,1
    80000302:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000306:	fff6c793          	not	a5,a3
    8000030a:	9fb9                	addw	a5,a5,a4
    8000030c:	9fb1                	addw	a5,a5,a2
    8000030e:	fef049e3          	bgtz	a5,80000300 <strncpy+0x28>
  return os;
}
    80000312:	6422                	ld	s0,8(sp)
    80000314:	0141                	addi	sp,sp,16
    80000316:	8082                	ret

0000000080000318 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e422                	sd	s0,8(sp)
    8000031c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031e:	02c05363          	blez	a2,80000344 <safestrcpy+0x2c>
    80000322:	fff6069b          	addiw	a3,a2,-1
    80000326:	1682                	slli	a3,a3,0x20
    80000328:	9281                	srli	a3,a3,0x20
    8000032a:	96ae                	add	a3,a3,a1
    8000032c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032e:	00d58963          	beq	a1,a3,80000340 <safestrcpy+0x28>
    80000332:	0585                	addi	a1,a1,1
    80000334:	0785                	addi	a5,a5,1
    80000336:	fff5c703          	lbu	a4,-1(a1)
    8000033a:	fee78fa3          	sb	a4,-1(a5)
    8000033e:	fb65                	bnez	a4,8000032e <safestrcpy+0x16>
    ;
  *s = 0;
    80000340:	00078023          	sb	zero,0(a5)
  return os;
}
    80000344:	6422                	ld	s0,8(sp)
    80000346:	0141                	addi	sp,sp,16
    80000348:	8082                	ret

000000008000034a <strlen>:

int
strlen(const char *s)
{
    8000034a:	1141                	addi	sp,sp,-16
    8000034c:	e422                	sd	s0,8(sp)
    8000034e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000350:	00054783          	lbu	a5,0(a0)
    80000354:	cf91                	beqz	a5,80000370 <strlen+0x26>
    80000356:	0505                	addi	a0,a0,1
    80000358:	87aa                	mv	a5,a0
    8000035a:	4685                	li	a3,1
    8000035c:	9e89                	subw	a3,a3,a0
    8000035e:	00f6853b          	addw	a0,a3,a5
    80000362:	0785                	addi	a5,a5,1
    80000364:	fff7c703          	lbu	a4,-1(a5)
    80000368:	fb7d                	bnez	a4,8000035e <strlen+0x14>
    ;
  return n;
}
    8000036a:	6422                	ld	s0,8(sp)
    8000036c:	0141                	addi	sp,sp,16
    8000036e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000370:	4501                	li	a0,0
    80000372:	bfe5                	j	8000036a <strlen+0x20>

0000000080000374 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000374:	1141                	addi	sp,sp,-16
    80000376:	e406                	sd	ra,8(sp)
    80000378:	e022                	sd	s0,0(sp)
    8000037a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	b16080e7          	jalr	-1258(ra) # 80000e92 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000384:	00008717          	auipc	a4,0x8
    80000388:	6ac70713          	addi	a4,a4,1708 # 80008a30 <started>
  if(cpuid() == 0){
    8000038c:	c139                	beqz	a0,800003d2 <main+0x5e>
    while(started == 0)
    8000038e:	431c                	lw	a5,0(a4)
    80000390:	2781                	sext.w	a5,a5
    80000392:	dff5                	beqz	a5,8000038e <main+0x1a>
      ;
    __sync_synchronize();
    80000394:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000398:	00001097          	auipc	ra,0x1
    8000039c:	afa080e7          	jalr	-1286(ra) # 80000e92 <cpuid>
    800003a0:	85aa                	mv	a1,a0
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c9650513          	addi	a0,a0,-874 # 80008038 <etext+0x38>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	af8080e7          	jalr	-1288(ra) # 80005ea2 <printf>
    kvminithart();    // turn on paging
    800003b2:	00000097          	auipc	ra,0x0
    800003b6:	0d8080e7          	jalr	216(ra) # 8000048a <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ba:	00001097          	auipc	ra,0x1
    800003be:	7dc080e7          	jalr	2012(ra) # 80001b96 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003c2:	00005097          	auipc	ra,0x5
    800003c6:	efe080e7          	jalr	-258(ra) # 800052c0 <plicinithart>
  }

  scheduler();        
    800003ca:	00001097          	auipc	ra,0x1
    800003ce:	ff0080e7          	jalr	-16(ra) # 800013ba <scheduler>
    consoleinit();
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	994080e7          	jalr	-1644(ra) # 80005d66 <consoleinit>
    printfinit();
    800003da:	00006097          	auipc	ra,0x6
    800003de:	cae080e7          	jalr	-850(ra) # 80006088 <printfinit>
    printf("\n");
    800003e2:	00008517          	auipc	a0,0x8
    800003e6:	c6650513          	addi	a0,a0,-922 # 80008048 <etext+0x48>
    800003ea:	00006097          	auipc	ra,0x6
    800003ee:	ab8080e7          	jalr	-1352(ra) # 80005ea2 <printf>
    printf("xv6 kernel is booting\n");
    800003f2:	00008517          	auipc	a0,0x8
    800003f6:	c2e50513          	addi	a0,a0,-978 # 80008020 <etext+0x20>
    800003fa:	00006097          	auipc	ra,0x6
    800003fe:	aa8080e7          	jalr	-1368(ra) # 80005ea2 <printf>
    printf("\n");
    80000402:	00008517          	auipc	a0,0x8
    80000406:	c4650513          	addi	a0,a0,-954 # 80008048 <etext+0x48>
    8000040a:	00006097          	auipc	ra,0x6
    8000040e:	a98080e7          	jalr	-1384(ra) # 80005ea2 <printf>
    kinit();         // physical page allocator
    80000412:	00000097          	auipc	ra,0x0
    80000416:	cce080e7          	jalr	-818(ra) # 800000e0 <kinit>
    kvminit();       // create kernel page table
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	326080e7          	jalr	806(ra) # 80000740 <kvminit>
    kvminithart();   // turn on paging
    80000422:	00000097          	auipc	ra,0x0
    80000426:	068080e7          	jalr	104(ra) # 8000048a <kvminithart>
    procinit();      // process table
    8000042a:	00001097          	auipc	ra,0x1
    8000042e:	9b4080e7          	jalr	-1612(ra) # 80000dde <procinit>
    trapinit();      // trap vectors
    80000432:	00001097          	auipc	ra,0x1
    80000436:	73c080e7          	jalr	1852(ra) # 80001b6e <trapinit>
    trapinithart();  // install kernel trap vector
    8000043a:	00001097          	auipc	ra,0x1
    8000043e:	75c080e7          	jalr	1884(ra) # 80001b96 <trapinithart>
    plicinit();      // set up interrupt controller
    80000442:	00005097          	auipc	ra,0x5
    80000446:	e68080e7          	jalr	-408(ra) # 800052aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000044a:	00005097          	auipc	ra,0x5
    8000044e:	e76080e7          	jalr	-394(ra) # 800052c0 <plicinithart>
    binit();         // buffer cache
    80000452:	00002097          	auipc	ra,0x2
    80000456:	f5e080e7          	jalr	-162(ra) # 800023b0 <binit>
    iinit();         // inode table
    8000045a:	00002097          	auipc	ra,0x2
    8000045e:	642080e7          	jalr	1602(ra) # 80002a9c <iinit>
    fileinit();      // file table
    80000462:	00003097          	auipc	ra,0x3
    80000466:	60c080e7          	jalr	1548(ra) # 80003a6e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000046a:	00005097          	auipc	ra,0x5
    8000046e:	f5e080e7          	jalr	-162(ra) # 800053c8 <virtio_disk_init>
    userinit();      // first user process
    80000472:	00001097          	auipc	ra,0x1
    80000476:	d26080e7          	jalr	-730(ra) # 80001198 <userinit>
    __sync_synchronize();
    8000047a:	0ff0000f          	fence
    started = 1;
    8000047e:	4785                	li	a5,1
    80000480:	00008717          	auipc	a4,0x8
    80000484:	5af72823          	sw	a5,1456(a4) # 80008a30 <started>
    80000488:	b789                	j	800003ca <main+0x56>

000000008000048a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000048a:	1141                	addi	sp,sp,-16
    8000048c:	e422                	sd	s0,8(sp)
    8000048e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000490:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000494:	00008797          	auipc	a5,0x8
    80000498:	5a478793          	addi	a5,a5,1444 # 80008a38 <kernel_pagetable>
    8000049c:	639c                	ld	a5,0(a5)
    8000049e:	83b1                	srli	a5,a5,0xc
    800004a0:	577d                	li	a4,-1
    800004a2:	177e                	slli	a4,a4,0x3f
    800004a4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004a6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004aa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004ae:	6422                	ld	s0,8(sp)
    800004b0:	0141                	addi	sp,sp,16
    800004b2:	8082                	ret

00000000800004b4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004b4:	7139                	addi	sp,sp,-64
    800004b6:	fc06                	sd	ra,56(sp)
    800004b8:	f822                	sd	s0,48(sp)
    800004ba:	f426                	sd	s1,40(sp)
    800004bc:	f04a                	sd	s2,32(sp)
    800004be:	ec4e                	sd	s3,24(sp)
    800004c0:	e852                	sd	s4,16(sp)
    800004c2:	e456                	sd	s5,8(sp)
    800004c4:	e05a                	sd	s6,0(sp)
    800004c6:	0080                	addi	s0,sp,64
    800004c8:	84aa                	mv	s1,a0
    800004ca:	89ae                	mv	s3,a1
    800004cc:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    800004ce:	57fd                	li	a5,-1
    800004d0:	83e9                	srli	a5,a5,0x1a
    800004d2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004d4:	4ab1                	li	s5,12
  if(va >= MAXVA)
    800004d6:	04b7f263          	bleu	a1,a5,8000051a <walk+0x66>
    panic("walk");
    800004da:	00008517          	auipc	a0,0x8
    800004de:	b7650513          	addi	a0,a0,-1162 # 80008050 <etext+0x50>
    800004e2:	00006097          	auipc	ra,0x6
    800004e6:	976080e7          	jalr	-1674(ra) # 80005e58 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004ea:	060b0663          	beqz	s6,80000556 <walk+0xa2>
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	c2e080e7          	jalr	-978(ra) # 8000011c <kalloc>
    800004f6:	84aa                	mv	s1,a0
    800004f8:	c529                	beqz	a0,80000542 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004fa:	6605                	lui	a2,0x1
    800004fc:	4581                	li	a1,0
    800004fe:	00000097          	auipc	ra,0x0
    80000502:	ca6080e7          	jalr	-858(ra) # 800001a4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000506:	00c4d793          	srli	a5,s1,0xc
    8000050a:	07aa                	slli	a5,a5,0xa
    8000050c:	0017e793          	ori	a5,a5,1
    80000510:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000514:	3a5d                	addiw	s4,s4,-9
    80000516:	035a0063          	beq	s4,s5,80000536 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000051a:	0149d933          	srl	s2,s3,s4
    8000051e:	1ff97913          	andi	s2,s2,511
    80000522:	090e                	slli	s2,s2,0x3
    80000524:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000526:	00093483          	ld	s1,0(s2)
    8000052a:	0014f793          	andi	a5,s1,1
    8000052e:	dfd5                	beqz	a5,800004ea <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000530:	80a9                	srli	s1,s1,0xa
    80000532:	04b2                	slli	s1,s1,0xc
    80000534:	b7c5                	j	80000514 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000536:	00c9d513          	srli	a0,s3,0xc
    8000053a:	1ff57513          	andi	a0,a0,511
    8000053e:	050e                	slli	a0,a0,0x3
    80000540:	9526                	add	a0,a0,s1
}
    80000542:	70e2                	ld	ra,56(sp)
    80000544:	7442                	ld	s0,48(sp)
    80000546:	74a2                	ld	s1,40(sp)
    80000548:	7902                	ld	s2,32(sp)
    8000054a:	69e2                	ld	s3,24(sp)
    8000054c:	6a42                	ld	s4,16(sp)
    8000054e:	6aa2                	ld	s5,8(sp)
    80000550:	6b02                	ld	s6,0(sp)
    80000552:	6121                	addi	sp,sp,64
    80000554:	8082                	ret
        return 0;
    80000556:	4501                	li	a0,0
    80000558:	b7ed                	j	80000542 <walk+0x8e>

000000008000055a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000055a:	57fd                	li	a5,-1
    8000055c:	83e9                	srli	a5,a5,0x1a
    8000055e:	00b7f463          	bleu	a1,a5,80000566 <walkaddr+0xc>
    return 0;
    80000562:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000564:	8082                	ret
{
    80000566:	1141                	addi	sp,sp,-16
    80000568:	e406                	sd	ra,8(sp)
    8000056a:	e022                	sd	s0,0(sp)
    8000056c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000056e:	4601                	li	a2,0
    80000570:	00000097          	auipc	ra,0x0
    80000574:	f44080e7          	jalr	-188(ra) # 800004b4 <walk>
  if(pte == 0)
    80000578:	c105                	beqz	a0,80000598 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000057a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000057c:	0117f693          	andi	a3,a5,17
    80000580:	4745                	li	a4,17
    return 0;
    80000582:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000584:	00e68663          	beq	a3,a4,80000590 <walkaddr+0x36>
}
    80000588:	60a2                	ld	ra,8(sp)
    8000058a:	6402                	ld	s0,0(sp)
    8000058c:	0141                	addi	sp,sp,16
    8000058e:	8082                	ret
  pa = PTE2PA(*pte);
    80000590:	00a7d513          	srli	a0,a5,0xa
    80000594:	0532                	slli	a0,a0,0xc
  return pa;
    80000596:	bfcd                	j	80000588 <walkaddr+0x2e>
    return 0;
    80000598:	4501                	li	a0,0
    8000059a:	b7fd                	j	80000588 <walkaddr+0x2e>

000000008000059c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000059c:	715d                	addi	sp,sp,-80
    8000059e:	e486                	sd	ra,72(sp)
    800005a0:	e0a2                	sd	s0,64(sp)
    800005a2:	fc26                	sd	s1,56(sp)
    800005a4:	f84a                	sd	s2,48(sp)
    800005a6:	f44e                	sd	s3,40(sp)
    800005a8:	f052                	sd	s4,32(sp)
    800005aa:	ec56                	sd	s5,24(sp)
    800005ac:	e85a                	sd	s6,16(sp)
    800005ae:	e45e                	sd	s7,8(sp)
    800005b0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005b2:	ce19                	beqz	a2,800005d0 <mappages+0x34>
    800005b4:	8aaa                	mv	s5,a0
    800005b6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005b8:	79fd                	lui	s3,0xfffff
    800005ba:	0135f7b3          	and	a5,a1,s3
  last = PGROUNDDOWN(va + size - 1);
    800005be:	15fd                	addi	a1,a1,-1
    800005c0:	95b2                	add	a1,a1,a2
    800005c2:	0135f9b3          	and	s3,a1,s3
  a = PGROUNDDOWN(va);
    800005c6:	893e                	mv	s2,a5
    800005c8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005cc:	6b85                	lui	s7,0x1
    800005ce:	a015                	j	800005f2 <mappages+0x56>
    panic("mappages: size");
    800005d0:	00008517          	auipc	a0,0x8
    800005d4:	a8850513          	addi	a0,a0,-1400 # 80008058 <etext+0x58>
    800005d8:	00006097          	auipc	ra,0x6
    800005dc:	880080e7          	jalr	-1920(ra) # 80005e58 <panic>
      panic("mappages: remap");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a8850513          	addi	a0,a0,-1400 # 80008068 <etext+0x68>
    800005e8:	00006097          	auipc	ra,0x6
    800005ec:	870080e7          	jalr	-1936(ra) # 80005e58 <panic>
    a += PGSIZE;
    800005f0:	995e                	add	s2,s2,s7
  for(;;){
    800005f2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f6:	4605                	li	a2,1
    800005f8:	85ca                	mv	a1,s2
    800005fa:	8556                	mv	a0,s5
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	eb8080e7          	jalr	-328(ra) # 800004b4 <walk>
    80000604:	cd19                	beqz	a0,80000622 <mappages+0x86>
    if(*pte & PTE_V)
    80000606:	611c                	ld	a5,0(a0)
    80000608:	8b85                	andi	a5,a5,1
    8000060a:	fbf9                	bnez	a5,800005e0 <mappages+0x44>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000060c:	80b1                	srli	s1,s1,0xc
    8000060e:	04aa                	slli	s1,s1,0xa
    80000610:	0164e4b3          	or	s1,s1,s6
    80000614:	0014e493          	ori	s1,s1,1
    80000618:	e104                	sd	s1,0(a0)
    if(a == last)
    8000061a:	fd391be3          	bne	s2,s3,800005f0 <mappages+0x54>
    pa += PGSIZE;
  }
  return 0;
    8000061e:	4501                	li	a0,0
    80000620:	a011                	j	80000624 <mappages+0x88>
      return -1;
    80000622:	557d                	li	a0,-1
}
    80000624:	60a6                	ld	ra,72(sp)
    80000626:	6406                	ld	s0,64(sp)
    80000628:	74e2                	ld	s1,56(sp)
    8000062a:	7942                	ld	s2,48(sp)
    8000062c:	79a2                	ld	s3,40(sp)
    8000062e:	7a02                	ld	s4,32(sp)
    80000630:	6ae2                	ld	s5,24(sp)
    80000632:	6b42                	ld	s6,16(sp)
    80000634:	6ba2                	ld	s7,8(sp)
    80000636:	6161                	addi	sp,sp,80
    80000638:	8082                	ret

000000008000063a <kvmmap>:
{
    8000063a:	1141                	addi	sp,sp,-16
    8000063c:	e406                	sd	ra,8(sp)
    8000063e:	e022                	sd	s0,0(sp)
    80000640:	0800                	addi	s0,sp,16
    80000642:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000644:	86b2                	mv	a3,a2
    80000646:	863e                	mv	a2,a5
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	f54080e7          	jalr	-172(ra) # 8000059c <mappages>
    80000650:	e509                	bnez	a0,8000065a <kvmmap+0x20>
}
    80000652:	60a2                	ld	ra,8(sp)
    80000654:	6402                	ld	s0,0(sp)
    80000656:	0141                	addi	sp,sp,16
    80000658:	8082                	ret
    panic("kvmmap");
    8000065a:	00008517          	auipc	a0,0x8
    8000065e:	a1e50513          	addi	a0,a0,-1506 # 80008078 <etext+0x78>
    80000662:	00005097          	auipc	ra,0x5
    80000666:	7f6080e7          	jalr	2038(ra) # 80005e58 <panic>

000000008000066a <kvmmake>:
{
    8000066a:	1101                	addi	sp,sp,-32
    8000066c:	ec06                	sd	ra,24(sp)
    8000066e:	e822                	sd	s0,16(sp)
    80000670:	e426                	sd	s1,8(sp)
    80000672:	e04a                	sd	s2,0(sp)
    80000674:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	aa6080e7          	jalr	-1370(ra) # 8000011c <kalloc>
    8000067e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000680:	6605                	lui	a2,0x1
    80000682:	4581                	li	a1,0
    80000684:	00000097          	auipc	ra,0x0
    80000688:	b20080e7          	jalr	-1248(ra) # 800001a4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10000637          	lui	a2,0x10000
    80000694:	100005b7          	lui	a1,0x10000
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	fa0080e7          	jalr	-96(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	6685                	lui	a3,0x1
    800006a6:	10001637          	lui	a2,0x10001
    800006aa:	100015b7          	lui	a1,0x10001
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f8a080e7          	jalr	-118(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b8:	4719                	li	a4,6
    800006ba:	004006b7          	lui	a3,0x400
    800006be:	0c000637          	lui	a2,0xc000
    800006c2:	0c0005b7          	lui	a1,0xc000
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f72080e7          	jalr	-142(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006d0:	00008917          	auipc	s2,0x8
    800006d4:	93090913          	addi	s2,s2,-1744 # 80008000 <etext>
    800006d8:	4729                	li	a4,10
    800006da:	80008697          	auipc	a3,0x80008
    800006de:	92668693          	addi	a3,a3,-1754 # 8000 <_entry-0x7fff8000>
    800006e2:	4605                	li	a2,1
    800006e4:	067e                	slli	a2,a2,0x1f
    800006e6:	85b2                	mv	a1,a2
    800006e8:	8526                	mv	a0,s1
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f50080e7          	jalr	-176(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006f2:	4719                	li	a4,6
    800006f4:	46c5                	li	a3,17
    800006f6:	06ee                	slli	a3,a3,0x1b
    800006f8:	412686b3          	sub	a3,a3,s2
    800006fc:	864a                	mv	a2,s2
    800006fe:	85ca                	mv	a1,s2
    80000700:	8526                	mv	a0,s1
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f38080e7          	jalr	-200(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000070a:	4729                	li	a4,10
    8000070c:	6685                	lui	a3,0x1
    8000070e:	00007617          	auipc	a2,0x7
    80000712:	8f260613          	addi	a2,a2,-1806 # 80007000 <_trampoline>
    80000716:	040005b7          	lui	a1,0x4000
    8000071a:	15fd                	addi	a1,a1,-1
    8000071c:	05b2                	slli	a1,a1,0xc
    8000071e:	8526                	mv	a0,s1
    80000720:	00000097          	auipc	ra,0x0
    80000724:	f1a080e7          	jalr	-230(ra) # 8000063a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	61e080e7          	jalr	1566(ra) # 80000d48 <proc_mapstacks>
}
    80000732:	8526                	mv	a0,s1
    80000734:	60e2                	ld	ra,24(sp)
    80000736:	6442                	ld	s0,16(sp)
    80000738:	64a2                	ld	s1,8(sp)
    8000073a:	6902                	ld	s2,0(sp)
    8000073c:	6105                	addi	sp,sp,32
    8000073e:	8082                	ret

0000000080000740 <kvminit>:
{
    80000740:	1141                	addi	sp,sp,-16
    80000742:	e406                	sd	ra,8(sp)
    80000744:	e022                	sd	s0,0(sp)
    80000746:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	f22080e7          	jalr	-222(ra) # 8000066a <kvmmake>
    80000750:	00008797          	auipc	a5,0x8
    80000754:	2ea7b423          	sd	a0,744(a5) # 80008a38 <kernel_pagetable>
}
    80000758:	60a2                	ld	ra,8(sp)
    8000075a:	6402                	ld	s0,0(sp)
    8000075c:	0141                	addi	sp,sp,16
    8000075e:	8082                	ret

0000000080000760 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000760:	715d                	addi	sp,sp,-80
    80000762:	e486                	sd	ra,72(sp)
    80000764:	e0a2                	sd	s0,64(sp)
    80000766:	fc26                	sd	s1,56(sp)
    80000768:	f84a                	sd	s2,48(sp)
    8000076a:	f44e                	sd	s3,40(sp)
    8000076c:	f052                	sd	s4,32(sp)
    8000076e:	ec56                	sd	s5,24(sp)
    80000770:	e85a                	sd	s6,16(sp)
    80000772:	e45e                	sd	s7,8(sp)
    80000774:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000776:	6785                	lui	a5,0x1
    80000778:	17fd                	addi	a5,a5,-1
    8000077a:	8fed                	and	a5,a5,a1
    8000077c:	e795                	bnez	a5,800007a8 <uvmunmap+0x48>
    8000077e:	8a2a                	mv	s4,a0
    80000780:	84ae                	mv	s1,a1
    80000782:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	0632                	slli	a2,a2,0xc
    80000786:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000078a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000078c:	6b05                	lui	s6,0x1
    8000078e:	0735e863          	bltu	a1,s3,800007fe <uvmunmap+0x9e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000792:	60a6                	ld	ra,72(sp)
    80000794:	6406                	ld	s0,64(sp)
    80000796:	74e2                	ld	s1,56(sp)
    80000798:	7942                	ld	s2,48(sp)
    8000079a:	79a2                	ld	s3,40(sp)
    8000079c:	7a02                	ld	s4,32(sp)
    8000079e:	6ae2                	ld	s5,24(sp)
    800007a0:	6b42                	ld	s6,16(sp)
    800007a2:	6ba2                	ld	s7,8(sp)
    800007a4:	6161                	addi	sp,sp,80
    800007a6:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	8d850513          	addi	a0,a0,-1832 # 80008080 <etext+0x80>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	6a8080e7          	jalr	1704(ra) # 80005e58 <panic>
      panic("uvmunmap: walk");
    800007b8:	00008517          	auipc	a0,0x8
    800007bc:	8e050513          	addi	a0,a0,-1824 # 80008098 <etext+0x98>
    800007c0:	00005097          	auipc	ra,0x5
    800007c4:	698080e7          	jalr	1688(ra) # 80005e58 <panic>
      panic("uvmunmap: not mapped");
    800007c8:	00008517          	auipc	a0,0x8
    800007cc:	8e050513          	addi	a0,a0,-1824 # 800080a8 <etext+0xa8>
    800007d0:	00005097          	auipc	ra,0x5
    800007d4:	688080e7          	jalr	1672(ra) # 80005e58 <panic>
      panic("uvmunmap: not a leaf");
    800007d8:	00008517          	auipc	a0,0x8
    800007dc:	8e850513          	addi	a0,a0,-1816 # 800080c0 <etext+0xc0>
    800007e0:	00005097          	auipc	ra,0x5
    800007e4:	678080e7          	jalr	1656(ra) # 80005e58 <panic>
      uint64 pa = PTE2PA(*pte);
    800007e8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007ea:	0532                	slli	a0,a0,0xc
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	830080e7          	jalr	-2000(ra) # 8000001c <kfree>
    *pte = 0;
    800007f4:	00093023          	sd	zero,0(s2)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f8:	94da                	add	s1,s1,s6
    800007fa:	f934fce3          	bleu	s3,s1,80000792 <uvmunmap+0x32>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fe:	4601                	li	a2,0
    80000800:	85a6                	mv	a1,s1
    80000802:	8552                	mv	a0,s4
    80000804:	00000097          	auipc	ra,0x0
    80000808:	cb0080e7          	jalr	-848(ra) # 800004b4 <walk>
    8000080c:	892a                	mv	s2,a0
    8000080e:	d54d                	beqz	a0,800007b8 <uvmunmap+0x58>
    if((*pte & PTE_V) == 0)
    80000810:	6108                	ld	a0,0(a0)
    80000812:	00157793          	andi	a5,a0,1
    80000816:	dbcd                	beqz	a5,800007c8 <uvmunmap+0x68>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000818:	3ff57793          	andi	a5,a0,1023
    8000081c:	fb778ee3          	beq	a5,s7,800007d8 <uvmunmap+0x78>
    if(do_free){
    80000820:	fc0a8ae3          	beqz	s5,800007f4 <uvmunmap+0x94>
    80000824:	b7d1                	j	800007e8 <uvmunmap+0x88>

0000000080000826 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000826:	1101                	addi	sp,sp,-32
    80000828:	ec06                	sd	ra,24(sp)
    8000082a:	e822                	sd	s0,16(sp)
    8000082c:	e426                	sd	s1,8(sp)
    8000082e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000830:	00000097          	auipc	ra,0x0
    80000834:	8ec080e7          	jalr	-1812(ra) # 8000011c <kalloc>
    80000838:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000083a:	c519                	beqz	a0,80000848 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000083c:	6605                	lui	a2,0x1
    8000083e:	4581                	li	a1,0
    80000840:	00000097          	auipc	ra,0x0
    80000844:	964080e7          	jalr	-1692(ra) # 800001a4 <memset>
  return pagetable;
}
    80000848:	8526                	mv	a0,s1
    8000084a:	60e2                	ld	ra,24(sp)
    8000084c:	6442                	ld	s0,16(sp)
    8000084e:	64a2                	ld	s1,8(sp)
    80000850:	6105                	addi	sp,sp,32
    80000852:	8082                	ret

0000000080000854 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000854:	7179                	addi	sp,sp,-48
    80000856:	f406                	sd	ra,40(sp)
    80000858:	f022                	sd	s0,32(sp)
    8000085a:	ec26                	sd	s1,24(sp)
    8000085c:	e84a                	sd	s2,16(sp)
    8000085e:	e44e                	sd	s3,8(sp)
    80000860:	e052                	sd	s4,0(sp)
    80000862:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000864:	6785                	lui	a5,0x1
    80000866:	04f67863          	bleu	a5,a2,800008b6 <uvmfirst+0x62>
    8000086a:	8a2a                	mv	s4,a0
    8000086c:	89ae                	mv	s3,a1
    8000086e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000870:	00000097          	auipc	ra,0x0
    80000874:	8ac080e7          	jalr	-1876(ra) # 8000011c <kalloc>
    80000878:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000087a:	6605                	lui	a2,0x1
    8000087c:	4581                	li	a1,0
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	926080e7          	jalr	-1754(ra) # 800001a4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000886:	4779                	li	a4,30
    80000888:	86ca                	mv	a3,s2
    8000088a:	6605                	lui	a2,0x1
    8000088c:	4581                	li	a1,0
    8000088e:	8552                	mv	a0,s4
    80000890:	00000097          	auipc	ra,0x0
    80000894:	d0c080e7          	jalr	-756(ra) # 8000059c <mappages>
  memmove(mem, src, sz);
    80000898:	8626                	mv	a2,s1
    8000089a:	85ce                	mv	a1,s3
    8000089c:	854a                	mv	a0,s2
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	972080e7          	jalr	-1678(ra) # 80000210 <memmove>
}
    800008a6:	70a2                	ld	ra,40(sp)
    800008a8:	7402                	ld	s0,32(sp)
    800008aa:	64e2                	ld	s1,24(sp)
    800008ac:	6942                	ld	s2,16(sp)
    800008ae:	69a2                	ld	s3,8(sp)
    800008b0:	6a02                	ld	s4,0(sp)
    800008b2:	6145                	addi	sp,sp,48
    800008b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800008b6:	00008517          	auipc	a0,0x8
    800008ba:	82250513          	addi	a0,a0,-2014 # 800080d8 <etext+0xd8>
    800008be:	00005097          	auipc	ra,0x5
    800008c2:	59a080e7          	jalr	1434(ra) # 80005e58 <panic>

00000000800008c6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c6:	1101                	addi	sp,sp,-32
    800008c8:	ec06                	sd	ra,24(sp)
    800008ca:	e822                	sd	s0,16(sp)
    800008cc:	e426                	sd	s1,8(sp)
    800008ce:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d2:	00b67d63          	bleu	a1,a2,800008ec <uvmdealloc+0x26>
    800008d6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d8:	6605                	lui	a2,0x1
    800008da:	167d                	addi	a2,a2,-1
    800008dc:	00c487b3          	add	a5,s1,a2
    800008e0:	777d                	lui	a4,0xfffff
    800008e2:	8ff9                	and	a5,a5,a4
    800008e4:	962e                	add	a2,a2,a1
    800008e6:	8e79                	and	a2,a2,a4
    800008e8:	00c7e863          	bltu	a5,a2,800008f8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ec:	8526                	mv	a0,s1
    800008ee:	60e2                	ld	ra,24(sp)
    800008f0:	6442                	ld	s0,16(sp)
    800008f2:	64a2                	ld	s1,8(sp)
    800008f4:	6105                	addi	sp,sp,32
    800008f6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f8:	8e1d                	sub	a2,a2,a5
    800008fa:	8231                	srli	a2,a2,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008fc:	4685                	li	a3,1
    800008fe:	2601                	sext.w	a2,a2
    80000900:	85be                	mv	a1,a5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	e5e080e7          	jalr	-418(ra) # 80000760 <uvmunmap>
    8000090a:	b7cd                	j	800008ec <uvmdealloc+0x26>

000000008000090c <uvmalloc>:
  if(newsz < oldsz)
    8000090c:	0ab66563          	bltu	a2,a1,800009b6 <uvmalloc+0xaa>
{
    80000910:	7139                	addi	sp,sp,-64
    80000912:	fc06                	sd	ra,56(sp)
    80000914:	f822                	sd	s0,48(sp)
    80000916:	f426                	sd	s1,40(sp)
    80000918:	f04a                	sd	s2,32(sp)
    8000091a:	ec4e                	sd	s3,24(sp)
    8000091c:	e852                	sd	s4,16(sp)
    8000091e:	e456                	sd	s5,8(sp)
    80000920:	e05a                	sd	s6,0(sp)
    80000922:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    80000924:	6a85                	lui	s5,0x1
    80000926:	1afd                	addi	s5,s5,-1
    80000928:	95d6                	add	a1,a1,s5
    8000092a:	7afd                	lui	s5,0xfffff
    8000092c:	0155fab3          	and	s5,a1,s5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000930:	08caf563          	bleu	a2,s5,800009ba <uvmalloc+0xae>
    80000934:	89b2                	mv	s3,a2
    80000936:	8b2a                	mv	s6,a0
    80000938:	8956                	mv	s2,s5
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000093a:	0126ea13          	ori	s4,a3,18
    mem = kalloc();
    8000093e:	fffff097          	auipc	ra,0xfffff
    80000942:	7de080e7          	jalr	2014(ra) # 8000011c <kalloc>
    80000946:	84aa                	mv	s1,a0
    if(mem == 0){
    80000948:	c51d                	beqz	a0,80000976 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000094a:	6605                	lui	a2,0x1
    8000094c:	4581                	li	a1,0
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	856080e7          	jalr	-1962(ra) # 800001a4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000956:	8752                	mv	a4,s4
    80000958:	86a6                	mv	a3,s1
    8000095a:	6605                	lui	a2,0x1
    8000095c:	85ca                	mv	a1,s2
    8000095e:	855a                	mv	a0,s6
    80000960:	00000097          	auipc	ra,0x0
    80000964:	c3c080e7          	jalr	-964(ra) # 8000059c <mappages>
    80000968:	e90d                	bnez	a0,8000099a <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000096a:	6785                	lui	a5,0x1
    8000096c:	993e                	add	s2,s2,a5
    8000096e:	fd3968e3          	bltu	s2,s3,8000093e <uvmalloc+0x32>
  return newsz;
    80000972:	854e                	mv	a0,s3
    80000974:	a809                	j	80000986 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000976:	8656                	mv	a2,s5
    80000978:	85ca                	mv	a1,s2
    8000097a:	855a                	mv	a0,s6
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	f4a080e7          	jalr	-182(ra) # 800008c6 <uvmdealloc>
      return 0;
    80000984:	4501                	li	a0,0
}
    80000986:	70e2                	ld	ra,56(sp)
    80000988:	7442                	ld	s0,48(sp)
    8000098a:	74a2                	ld	s1,40(sp)
    8000098c:	7902                	ld	s2,32(sp)
    8000098e:	69e2                	ld	s3,24(sp)
    80000990:	6a42                	ld	s4,16(sp)
    80000992:	6aa2                	ld	s5,8(sp)
    80000994:	6b02                	ld	s6,0(sp)
    80000996:	6121                	addi	sp,sp,64
    80000998:	8082                	ret
      kfree(mem);
    8000099a:	8526                	mv	a0,s1
    8000099c:	fffff097          	auipc	ra,0xfffff
    800009a0:	680080e7          	jalr	1664(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a4:	8656                	mv	a2,s5
    800009a6:	85ca                	mv	a1,s2
    800009a8:	855a                	mv	a0,s6
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	f1c080e7          	jalr	-228(ra) # 800008c6 <uvmdealloc>
      return 0;
    800009b2:	4501                	li	a0,0
    800009b4:	bfc9                	j	80000986 <uvmalloc+0x7a>
    return oldsz;
    800009b6:	852e                	mv	a0,a1
}
    800009b8:	8082                	ret
  return newsz;
    800009ba:	8532                	mv	a0,a2
    800009bc:	b7e9                	j	80000986 <uvmalloc+0x7a>

00000000800009be <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009be:	7179                	addi	sp,sp,-48
    800009c0:	f406                	sd	ra,40(sp)
    800009c2:	f022                	sd	s0,32(sp)
    800009c4:	ec26                	sd	s1,24(sp)
    800009c6:	e84a                	sd	s2,16(sp)
    800009c8:	e44e                	sd	s3,8(sp)
    800009ca:	e052                	sd	s4,0(sp)
    800009cc:	1800                	addi	s0,sp,48
    800009ce:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009d0:	84aa                	mv	s1,a0
    800009d2:	6905                	lui	s2,0x1
    800009d4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d6:	4985                	li	s3,1
    800009d8:	a821                	j	800009f0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009da:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009dc:	0532                	slli	a0,a0,0xc
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	fe0080e7          	jalr	-32(ra) # 800009be <freewalk>
      pagetable[i] = 0;
    800009e6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ea:	04a1                	addi	s1,s1,8
    800009ec:	03248163          	beq	s1,s2,80000a0e <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009f0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009f2:	00f57793          	andi	a5,a0,15
    800009f6:	ff3782e3          	beq	a5,s3,800009da <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009fa:	8905                	andi	a0,a0,1
    800009fc:	d57d                	beqz	a0,800009ea <freewalk+0x2c>
      panic("freewalk: leaf");
    800009fe:	00007517          	auipc	a0,0x7
    80000a02:	6fa50513          	addi	a0,a0,1786 # 800080f8 <etext+0xf8>
    80000a06:	00005097          	auipc	ra,0x5
    80000a0a:	452080e7          	jalr	1106(ra) # 80005e58 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0e:	8552                	mv	a0,s4
    80000a10:	fffff097          	auipc	ra,0xfffff
    80000a14:	60c080e7          	jalr	1548(ra) # 8000001c <kfree>
}
    80000a18:	70a2                	ld	ra,40(sp)
    80000a1a:	7402                	ld	s0,32(sp)
    80000a1c:	64e2                	ld	s1,24(sp)
    80000a1e:	6942                	ld	s2,16(sp)
    80000a20:	69a2                	ld	s3,8(sp)
    80000a22:	6a02                	ld	s4,0(sp)
    80000a24:	6145                	addi	sp,sp,48
    80000a26:	8082                	ret

0000000080000a28 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a28:	1101                	addi	sp,sp,-32
    80000a2a:	ec06                	sd	ra,24(sp)
    80000a2c:	e822                	sd	s0,16(sp)
    80000a2e:	e426                	sd	s1,8(sp)
    80000a30:	1000                	addi	s0,sp,32
    80000a32:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a34:	e999                	bnez	a1,80000a4a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	f86080e7          	jalr	-122(ra) # 800009be <freewalk>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a4a:	6605                	lui	a2,0x1
    80000a4c:	167d                	addi	a2,a2,-1
    80000a4e:	962e                	add	a2,a2,a1
    80000a50:	4685                	li	a3,1
    80000a52:	8231                	srli	a2,a2,0xc
    80000a54:	4581                	li	a1,0
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	d0a080e7          	jalr	-758(ra) # 80000760 <uvmunmap>
    80000a5e:	bfe1                	j	80000a36 <uvmfree+0xe>

0000000080000a60 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a60:	c679                	beqz	a2,80000b2e <uvmcopy+0xce>
{
    80000a62:	715d                	addi	sp,sp,-80
    80000a64:	e486                	sd	ra,72(sp)
    80000a66:	e0a2                	sd	s0,64(sp)
    80000a68:	fc26                	sd	s1,56(sp)
    80000a6a:	f84a                	sd	s2,48(sp)
    80000a6c:	f44e                	sd	s3,40(sp)
    80000a6e:	f052                	sd	s4,32(sp)
    80000a70:	ec56                	sd	s5,24(sp)
    80000a72:	e85a                	sd	s6,16(sp)
    80000a74:	e45e                	sd	s7,8(sp)
    80000a76:	0880                	addi	s0,sp,80
    80000a78:	8ab2                	mv	s5,a2
    80000a7a:	8b2e                	mv	s6,a1
    80000a7c:	8baa                	mv	s7,a0
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    80000a80:	4601                	li	a2,0
    80000a82:	85ca                	mv	a1,s2
    80000a84:	855e                	mv	a0,s7
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	a2e080e7          	jalr	-1490(ra) # 800004b4 <walk>
    80000a8e:	c531                	beqz	a0,80000ada <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a90:	6118                	ld	a4,0(a0)
    80000a92:	00177793          	andi	a5,a4,1
    80000a96:	cbb1                	beqz	a5,80000aea <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a98:	00a75593          	srli	a1,a4,0xa
    80000a9c:	00c59993          	slli	s3,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aa0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	678080e7          	jalr	1656(ra) # 8000011c <kalloc>
    80000aac:	8a2a                	mv	s4,a0
    80000aae:	c939                	beqz	a0,80000b04 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	75c080e7          	jalr	1884(ra) # 80000210 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000abc:	8726                	mv	a4,s1
    80000abe:	86d2                	mv	a3,s4
    80000ac0:	6605                	lui	a2,0x1
    80000ac2:	85ca                	mv	a1,s2
    80000ac4:	855a                	mv	a0,s6
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	ad6080e7          	jalr	-1322(ra) # 8000059c <mappages>
    80000ace:	e515                	bnez	a0,80000afa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ad0:	6785                	lui	a5,0x1
    80000ad2:	993e                	add	s2,s2,a5
    80000ad4:	fb5966e3          	bltu	s2,s5,80000a80 <uvmcopy+0x20>
    80000ad8:	a081                	j	80000b18 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	62e50513          	addi	a0,a0,1582 # 80008108 <etext+0x108>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	376080e7          	jalr	886(ra) # 80005e58 <panic>
      panic("uvmcopy: page not present");
    80000aea:	00007517          	auipc	a0,0x7
    80000aee:	63e50513          	addi	a0,a0,1598 # 80008128 <etext+0x128>
    80000af2:	00005097          	auipc	ra,0x5
    80000af6:	366080e7          	jalr	870(ra) # 80005e58 <panic>
      kfree(mem);
    80000afa:	8552                	mv	a0,s4
    80000afc:	fffff097          	auipc	ra,0xfffff
    80000b00:	520080e7          	jalr	1312(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b04:	4685                	li	a3,1
    80000b06:	00c95613          	srli	a2,s2,0xc
    80000b0a:	4581                	li	a1,0
    80000b0c:	855a                	mv	a0,s6
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	c52080e7          	jalr	-942(ra) # 80000760 <uvmunmap>
  return -1;
    80000b16:	557d                	li	a0,-1
}
    80000b18:	60a6                	ld	ra,72(sp)
    80000b1a:	6406                	ld	s0,64(sp)
    80000b1c:	74e2                	ld	s1,56(sp)
    80000b1e:	7942                	ld	s2,48(sp)
    80000b20:	79a2                	ld	s3,40(sp)
    80000b22:	7a02                	ld	s4,32(sp)
    80000b24:	6ae2                	ld	s5,24(sp)
    80000b26:	6b42                	ld	s6,16(sp)
    80000b28:	6ba2                	ld	s7,8(sp)
    80000b2a:	6161                	addi	sp,sp,80
    80000b2c:	8082                	ret
  return 0;
    80000b2e:	4501                	li	a0,0
}
    80000b30:	8082                	ret

0000000080000b32 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e406                	sd	ra,8(sp)
    80000b36:	e022                	sd	s0,0(sp)
    80000b38:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b3a:	4601                	li	a2,0
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	978080e7          	jalr	-1672(ra) # 800004b4 <walk>
  if(pte == 0)
    80000b44:	c901                	beqz	a0,80000b54 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b46:	611c                	ld	a5,0(a0)
    80000b48:	9bbd                	andi	a5,a5,-17
    80000b4a:	e11c                	sd	a5,0(a0)
}
    80000b4c:	60a2                	ld	ra,8(sp)
    80000b4e:	6402                	ld	s0,0(sp)
    80000b50:	0141                	addi	sp,sp,16
    80000b52:	8082                	ret
    panic("uvmclear");
    80000b54:	00007517          	auipc	a0,0x7
    80000b58:	5f450513          	addi	a0,a0,1524 # 80008148 <etext+0x148>
    80000b5c:	00005097          	auipc	ra,0x5
    80000b60:	2fc080e7          	jalr	764(ra) # 80005e58 <panic>

0000000080000b64 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b64:	c6bd                	beqz	a3,80000bd2 <copyout+0x6e>
{
    80000b66:	715d                	addi	sp,sp,-80
    80000b68:	e486                	sd	ra,72(sp)
    80000b6a:	e0a2                	sd	s0,64(sp)
    80000b6c:	fc26                	sd	s1,56(sp)
    80000b6e:	f84a                	sd	s2,48(sp)
    80000b70:	f44e                	sd	s3,40(sp)
    80000b72:	f052                	sd	s4,32(sp)
    80000b74:	ec56                	sd	s5,24(sp)
    80000b76:	e85a                	sd	s6,16(sp)
    80000b78:	e45e                	sd	s7,8(sp)
    80000b7a:	e062                	sd	s8,0(sp)
    80000b7c:	0880                	addi	s0,sp,80
    80000b7e:	8baa                	mv	s7,a0
    80000b80:	8a2e                	mv	s4,a1
    80000b82:	8ab2                	mv	s5,a2
    80000b84:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b86:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b88:	6b05                	lui	s6,0x1
    80000b8a:	a015                	j	80000bae <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8c:	9552                	add	a0,a0,s4
    80000b8e:	0004861b          	sext.w	a2,s1
    80000b92:	85d6                	mv	a1,s5
    80000b94:	41250533          	sub	a0,a0,s2
    80000b98:	fffff097          	auipc	ra,0xfffff
    80000b9c:	678080e7          	jalr	1656(ra) # 80000210 <memmove>

    len -= n;
    80000ba0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba4:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000ba6:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80000baa:	02098263          	beqz	s3,80000bce <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bae:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    80000bb2:	85ca                	mv	a1,s2
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	9a4080e7          	jalr	-1628(ra) # 8000055a <walkaddr>
    if(pa0 == 0)
    80000bbe:	cd01                	beqz	a0,80000bd6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bc0:	414904b3          	sub	s1,s2,s4
    80000bc4:	94da                	add	s1,s1,s6
    if(n > len)
    80000bc6:	fc99f3e3          	bleu	s1,s3,80000b8c <copyout+0x28>
    80000bca:	84ce                	mv	s1,s3
    80000bcc:	b7c1                	j	80000b8c <copyout+0x28>
  }
  return 0;
    80000bce:	4501                	li	a0,0
    80000bd0:	a021                	j	80000bd8 <copyout+0x74>
    80000bd2:	4501                	li	a0,0
}
    80000bd4:	8082                	ret
      return -1;
    80000bd6:	557d                	li	a0,-1
}
    80000bd8:	60a6                	ld	ra,72(sp)
    80000bda:	6406                	ld	s0,64(sp)
    80000bdc:	74e2                	ld	s1,56(sp)
    80000bde:	7942                	ld	s2,48(sp)
    80000be0:	79a2                	ld	s3,40(sp)
    80000be2:	7a02                	ld	s4,32(sp)
    80000be4:	6ae2                	ld	s5,24(sp)
    80000be6:	6b42                	ld	s6,16(sp)
    80000be8:	6ba2                	ld	s7,8(sp)
    80000bea:	6c02                	ld	s8,0(sp)
    80000bec:	6161                	addi	sp,sp,80
    80000bee:	8082                	ret

0000000080000bf0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf0:	caa5                	beqz	a3,80000c60 <copyin+0x70>
{
    80000bf2:	715d                	addi	sp,sp,-80
    80000bf4:	e486                	sd	ra,72(sp)
    80000bf6:	e0a2                	sd	s0,64(sp)
    80000bf8:	fc26                	sd	s1,56(sp)
    80000bfa:	f84a                	sd	s2,48(sp)
    80000bfc:	f44e                	sd	s3,40(sp)
    80000bfe:	f052                	sd	s4,32(sp)
    80000c00:	ec56                	sd	s5,24(sp)
    80000c02:	e85a                	sd	s6,16(sp)
    80000c04:	e45e                	sd	s7,8(sp)
    80000c06:	e062                	sd	s8,0(sp)
    80000c08:	0880                	addi	s0,sp,80
    80000c0a:	8baa                	mv	s7,a0
    80000c0c:	8aae                	mv	s5,a1
    80000c0e:	8a32                	mv	s4,a2
    80000c10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c12:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c14:	6b05                	lui	s6,0x1
    80000c16:	a01d                	j	80000c3c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c18:	014505b3          	add	a1,a0,s4
    80000c1c:	0004861b          	sext.w	a2,s1
    80000c20:	412585b3          	sub	a1,a1,s2
    80000c24:	8556                	mv	a0,s5
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	5ea080e7          	jalr	1514(ra) # 80000210 <memmove>

    len -= n;
    80000c2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c32:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000c34:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80000c38:	02098263          	beqz	s3,80000c5c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    80000c40:	85ca                	mv	a1,s2
    80000c42:	855e                	mv	a0,s7
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	916080e7          	jalr	-1770(ra) # 8000055a <walkaddr>
    if(pa0 == 0)
    80000c4c:	cd01                	beqz	a0,80000c64 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4e:	414904b3          	sub	s1,s2,s4
    80000c52:	94da                	add	s1,s1,s6
    if(n > len)
    80000c54:	fc99f2e3          	bleu	s1,s3,80000c18 <copyin+0x28>
    80000c58:	84ce                	mv	s1,s3
    80000c5a:	bf7d                	j	80000c18 <copyin+0x28>
  }
  return 0;
    80000c5c:	4501                	li	a0,0
    80000c5e:	a021                	j	80000c66 <copyin+0x76>
    80000c60:	4501                	li	a0,0
}
    80000c62:	8082                	ret
      return -1;
    80000c64:	557d                	li	a0,-1
}
    80000c66:	60a6                	ld	ra,72(sp)
    80000c68:	6406                	ld	s0,64(sp)
    80000c6a:	74e2                	ld	s1,56(sp)
    80000c6c:	7942                	ld	s2,48(sp)
    80000c6e:	79a2                	ld	s3,40(sp)
    80000c70:	7a02                	ld	s4,32(sp)
    80000c72:	6ae2                	ld	s5,24(sp)
    80000c74:	6b42                	ld	s6,16(sp)
    80000c76:	6ba2                	ld	s7,8(sp)
    80000c78:	6c02                	ld	s8,0(sp)
    80000c7a:	6161                	addi	sp,sp,80
    80000c7c:	8082                	ret

0000000080000c7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7e:	ced5                	beqz	a3,80000d3a <copyinstr+0xbc>
{
    80000c80:	715d                	addi	sp,sp,-80
    80000c82:	e486                	sd	ra,72(sp)
    80000c84:	e0a2                	sd	s0,64(sp)
    80000c86:	fc26                	sd	s1,56(sp)
    80000c88:	f84a                	sd	s2,48(sp)
    80000c8a:	f44e                	sd	s3,40(sp)
    80000c8c:	f052                	sd	s4,32(sp)
    80000c8e:	ec56                	sd	s5,24(sp)
    80000c90:	e85a                	sd	s6,16(sp)
    80000c92:	e45e                	sd	s7,8(sp)
    80000c94:	e062                	sd	s8,0(sp)
    80000c96:	0880                	addi	s0,sp,80
    80000c98:	8aaa                	mv	s5,a0
    80000c9a:	84ae                	mv	s1,a1
    80000c9c:	8c32                	mv	s8,a2
    80000c9e:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca0:	7a7d                	lui	s4,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca2:	6985                	lui	s3,0x1
    80000ca4:	4b05                	li	s6,1
    80000ca6:	a801                	j	80000cb6 <copyinstr+0x38>
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
    80000ca8:	87a6                	mv	a5,s1
    80000caa:	a085                	j	80000d0a <copyinstr+0x8c>
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    80000cac:	84b2                	mv	s1,a2
    }

    srcva = va0 + PGSIZE;
    80000cae:	01390c33          	add	s8,s2,s3
  while(got_null == 0 && max > 0){
    80000cb2:	080b8063          	beqz	s7,80000d32 <copyinstr+0xb4>
    va0 = PGROUNDDOWN(srcva);
    80000cb6:	014c7933          	and	s2,s8,s4
    pa0 = walkaddr(pagetable, va0);
    80000cba:	85ca                	mv	a1,s2
    80000cbc:	8556                	mv	a0,s5
    80000cbe:	00000097          	auipc	ra,0x0
    80000cc2:	89c080e7          	jalr	-1892(ra) # 8000055a <walkaddr>
    if(pa0 == 0)
    80000cc6:	c925                	beqz	a0,80000d36 <copyinstr+0xb8>
    n = PGSIZE - (srcva - va0);
    80000cc8:	41890633          	sub	a2,s2,s8
    80000ccc:	964e                	add	a2,a2,s3
    if(n > max)
    80000cce:	00cbf363          	bleu	a2,s7,80000cd4 <copyinstr+0x56>
    80000cd2:	865e                	mv	a2,s7
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd4:	9562                	add	a0,a0,s8
    80000cd6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cda:	da71                	beqz	a2,80000cae <copyinstr+0x30>
      if(*p == '\0'){
    80000cdc:	00054703          	lbu	a4,0(a0)
    80000ce0:	d761                	beqz	a4,80000ca8 <copyinstr+0x2a>
    80000ce2:	9626                	add	a2,a2,s1
    80000ce4:	87a6                	mv	a5,s1
    80000ce6:	1bfd                	addi	s7,s7,-1
    80000ce8:	009b86b3          	add	a3,s7,s1
    80000cec:	409b04b3          	sub	s1,s6,s1
    80000cf0:	94aa                	add	s1,s1,a0
        *dst = *p;
    80000cf2:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
      --max;
    80000cf6:	40f68bb3          	sub	s7,a3,a5
      p++;
    80000cfa:	00f48733          	add	a4,s1,a5
      dst++;
    80000cfe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d00:	faf606e3          	beq	a2,a5,80000cac <copyinstr+0x2e>
      if(*p == '\0'){
    80000d04:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf30>
    80000d08:	f76d                	bnez	a4,80000cf2 <copyinstr+0x74>
        *dst = '\0';
    80000d0a:	00078023          	sb	zero,0(a5)
    80000d0e:	4785                	li	a5,1
  }
  if(got_null){
    80000d10:	0017b513          	seqz	a0,a5
    80000d14:	40a0053b          	negw	a0,a0
    80000d18:	2501                	sext.w	a0,a0
    return 0;
  } else {
    return -1;
  }
}
    80000d1a:	60a6                	ld	ra,72(sp)
    80000d1c:	6406                	ld	s0,64(sp)
    80000d1e:	74e2                	ld	s1,56(sp)
    80000d20:	7942                	ld	s2,48(sp)
    80000d22:	79a2                	ld	s3,40(sp)
    80000d24:	7a02                	ld	s4,32(sp)
    80000d26:	6ae2                	ld	s5,24(sp)
    80000d28:	6b42                	ld	s6,16(sp)
    80000d2a:	6ba2                	ld	s7,8(sp)
    80000d2c:	6c02                	ld	s8,0(sp)
    80000d2e:	6161                	addi	sp,sp,80
    80000d30:	8082                	ret
    80000d32:	4781                	li	a5,0
    80000d34:	bff1                	j	80000d10 <copyinstr+0x92>
      return -1;
    80000d36:	557d                	li	a0,-1
    80000d38:	b7cd                	j	80000d1a <copyinstr+0x9c>
  int got_null = 0;
    80000d3a:	4781                	li	a5,0
  if(got_null){
    80000d3c:	0017b513          	seqz	a0,a5
    80000d40:	40a0053b          	negw	a0,a0
    80000d44:	2501                	sext.w	a0,a0
}
    80000d46:	8082                	ret

0000000080000d48 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d48:	7139                	addi	sp,sp,-64
    80000d4a:	fc06                	sd	ra,56(sp)
    80000d4c:	f822                	sd	s0,48(sp)
    80000d4e:	f426                	sd	s1,40(sp)
    80000d50:	f04a                	sd	s2,32(sp)
    80000d52:	ec4e                	sd	s3,24(sp)
    80000d54:	e852                	sd	s4,16(sp)
    80000d56:	e456                	sd	s5,8(sp)
    80000d58:	e05a                	sd	s6,0(sp)
    80000d5a:	0080                	addi	s0,sp,64
    80000d5c:	8b2a                	mv	s6,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5e:	00008497          	auipc	s1,0x8
    80000d62:	15248493          	addi	s1,s1,338 # 80008eb0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d66:	8aa6                	mv	s5,s1
    80000d68:	00007a17          	auipc	s4,0x7
    80000d6c:	298a0a13          	addi	s4,s4,664 # 80008000 <etext>
    80000d70:	04000937          	lui	s2,0x4000
    80000d74:	197d                	addi	s2,s2,-1
    80000d76:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d78:	0000e997          	auipc	s3,0xe
    80000d7c:	d3898993          	addi	s3,s3,-712 # 8000eab0 <tickslock>
    char *pa = kalloc();
    80000d80:	fffff097          	auipc	ra,0xfffff
    80000d84:	39c080e7          	jalr	924(ra) # 8000011c <kalloc>
    80000d88:	862a                	mv	a2,a0
    if(pa == 0)
    80000d8a:	c131                	beqz	a0,80000dce <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d8c:	415485b3          	sub	a1,s1,s5
    80000d90:	8591                	srai	a1,a1,0x4
    80000d92:	000a3783          	ld	a5,0(s4)
    80000d96:	02f585b3          	mul	a1,a1,a5
    80000d9a:	2585                	addiw	a1,a1,1
    80000d9c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000da0:	4719                	li	a4,6
    80000da2:	6685                	lui	a3,0x1
    80000da4:	40b905b3          	sub	a1,s2,a1
    80000da8:	855a                	mv	a0,s6
    80000daa:	00000097          	auipc	ra,0x0
    80000dae:	890080e7          	jalr	-1904(ra) # 8000063a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db2:	17048493          	addi	s1,s1,368
    80000db6:	fd3495e3          	bne	s1,s3,80000d80 <proc_mapstacks+0x38>
  }
}
    80000dba:	70e2                	ld	ra,56(sp)
    80000dbc:	7442                	ld	s0,48(sp)
    80000dbe:	74a2                	ld	s1,40(sp)
    80000dc0:	7902                	ld	s2,32(sp)
    80000dc2:	69e2                	ld	s3,24(sp)
    80000dc4:	6a42                	ld	s4,16(sp)
    80000dc6:	6aa2                	ld	s5,8(sp)
    80000dc8:	6b02                	ld	s6,0(sp)
    80000dca:	6121                	addi	sp,sp,64
    80000dcc:	8082                	ret
      panic("kalloc");
    80000dce:	00007517          	auipc	a0,0x7
    80000dd2:	3ba50513          	addi	a0,a0,954 # 80008188 <states.1745+0x30>
    80000dd6:	00005097          	auipc	ra,0x5
    80000dda:	082080e7          	jalr	130(ra) # 80005e58 <panic>

0000000080000dde <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dde:	7139                	addi	sp,sp,-64
    80000de0:	fc06                	sd	ra,56(sp)
    80000de2:	f822                	sd	s0,48(sp)
    80000de4:	f426                	sd	s1,40(sp)
    80000de6:	f04a                	sd	s2,32(sp)
    80000de8:	ec4e                	sd	s3,24(sp)
    80000dea:	e852                	sd	s4,16(sp)
    80000dec:	e456                	sd	s5,8(sp)
    80000dee:	e05a                	sd	s6,0(sp)
    80000df0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000df2:	00007597          	auipc	a1,0x7
    80000df6:	39e58593          	addi	a1,a1,926 # 80008190 <states.1745+0x38>
    80000dfa:	00008517          	auipc	a0,0x8
    80000dfe:	c8650513          	addi	a0,a0,-890 # 80008a80 <pid_lock>
    80000e02:	00005097          	auipc	ra,0x5
    80000e06:	532080e7          	jalr	1330(ra) # 80006334 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e0a:	00007597          	auipc	a1,0x7
    80000e0e:	38e58593          	addi	a1,a1,910 # 80008198 <states.1745+0x40>
    80000e12:	00008517          	auipc	a0,0x8
    80000e16:	c8650513          	addi	a0,a0,-890 # 80008a98 <wait_lock>
    80000e1a:	00005097          	auipc	ra,0x5
    80000e1e:	51a080e7          	jalr	1306(ra) # 80006334 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	00008497          	auipc	s1,0x8
    80000e26:	08e48493          	addi	s1,s1,142 # 80008eb0 <proc>
      initlock(&p->lock, "proc");
    80000e2a:	00007b17          	auipc	s6,0x7
    80000e2e:	37eb0b13          	addi	s6,s6,894 # 800081a8 <states.1745+0x50>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e32:	8aa6                	mv	s5,s1
    80000e34:	00007a17          	auipc	s4,0x7
    80000e38:	1cca0a13          	addi	s4,s4,460 # 80008000 <etext>
    80000e3c:	04000937          	lui	s2,0x4000
    80000e40:	197d                	addi	s2,s2,-1
    80000e42:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e44:	0000e997          	auipc	s3,0xe
    80000e48:	c6c98993          	addi	s3,s3,-916 # 8000eab0 <tickslock>
      initlock(&p->lock, "proc");
    80000e4c:	85da                	mv	a1,s6
    80000e4e:	8526                	mv	a0,s1
    80000e50:	00005097          	auipc	ra,0x5
    80000e54:	4e4080e7          	jalr	1252(ra) # 80006334 <initlock>
      p->state = UNUSED;
    80000e58:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e5c:	415487b3          	sub	a5,s1,s5
    80000e60:	8791                	srai	a5,a5,0x4
    80000e62:	000a3703          	ld	a4,0(s4)
    80000e66:	02e787b3          	mul	a5,a5,a4
    80000e6a:	2785                	addiw	a5,a5,1
    80000e6c:	00d7979b          	slliw	a5,a5,0xd
    80000e70:	40f907b3          	sub	a5,s2,a5
    80000e74:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e76:	17048493          	addi	s1,s1,368
    80000e7a:	fd3499e3          	bne	s1,s3,80000e4c <procinit+0x6e>
  }
}
    80000e7e:	70e2                	ld	ra,56(sp)
    80000e80:	7442                	ld	s0,48(sp)
    80000e82:	74a2                	ld	s1,40(sp)
    80000e84:	7902                	ld	s2,32(sp)
    80000e86:	69e2                	ld	s3,24(sp)
    80000e88:	6a42                	ld	s4,16(sp)
    80000e8a:	6aa2                	ld	s5,8(sp)
    80000e8c:	6b02                	ld	s6,0(sp)
    80000e8e:	6121                	addi	sp,sp,64
    80000e90:	8082                	ret

0000000080000e92 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e92:	1141                	addi	sp,sp,-16
    80000e94:	e422                	sd	s0,8(sp)
    80000e96:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e98:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e9a:	2501                	sext.w	a0,a0
    80000e9c:	6422                	ld	s0,8(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret

0000000080000ea2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000ea2:	1141                	addi	sp,sp,-16
    80000ea4:	e422                	sd	s0,8(sp)
    80000ea6:	0800                	addi	s0,sp,16
    80000ea8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000eaa:	2781                	sext.w	a5,a5
    80000eac:	079e                	slli	a5,a5,0x7
  return c;
}
    80000eae:	00008517          	auipc	a0,0x8
    80000eb2:	c0250513          	addi	a0,a0,-1022 # 80008ab0 <cpus>
    80000eb6:	953e                	add	a0,a0,a5
    80000eb8:	6422                	ld	s0,8(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret

0000000080000ebe <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ebe:	1101                	addi	sp,sp,-32
    80000ec0:	ec06                	sd	ra,24(sp)
    80000ec2:	e822                	sd	s0,16(sp)
    80000ec4:	e426                	sd	s1,8(sp)
    80000ec6:	1000                	addi	s0,sp,32
  push_off();
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	4b0080e7          	jalr	1200(ra) # 80006378 <push_off>
    80000ed0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ed2:	2781                	sext.w	a5,a5
    80000ed4:	079e                	slli	a5,a5,0x7
    80000ed6:	00008717          	auipc	a4,0x8
    80000eda:	baa70713          	addi	a4,a4,-1110 # 80008a80 <pid_lock>
    80000ede:	97ba                	add	a5,a5,a4
    80000ee0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ee2:	00005097          	auipc	ra,0x5
    80000ee6:	536080e7          	jalr	1334(ra) # 80006418 <pop_off>
  return p;
}
    80000eea:	8526                	mv	a0,s1
    80000eec:	60e2                	ld	ra,24(sp)
    80000eee:	6442                	ld	s0,16(sp)
    80000ef0:	64a2                	ld	s1,8(sp)
    80000ef2:	6105                	addi	sp,sp,32
    80000ef4:	8082                	ret

0000000080000ef6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e406                	sd	ra,8(sp)
    80000efa:	e022                	sd	s0,0(sp)
    80000efc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000efe:	00000097          	auipc	ra,0x0
    80000f02:	fc0080e7          	jalr	-64(ra) # 80000ebe <myproc>
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	572080e7          	jalr	1394(ra) # 80006478 <release>

  if (first) {
    80000f0e:	00008797          	auipc	a5,0x8
    80000f12:	ab278793          	addi	a5,a5,-1358 # 800089c0 <first.1701>
    80000f16:	439c                	lw	a5,0(a5)
    80000f18:	eb89                	bnez	a5,80000f2a <forkret+0x34>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f1a:	00001097          	auipc	ra,0x1
    80000f1e:	c94080e7          	jalr	-876(ra) # 80001bae <usertrapret>
}
    80000f22:	60a2                	ld	ra,8(sp)
    80000f24:	6402                	ld	s0,0(sp)
    80000f26:	0141                	addi	sp,sp,16
    80000f28:	8082                	ret
    first = 0;
    80000f2a:	00008797          	auipc	a5,0x8
    80000f2e:	a807ab23          	sw	zero,-1386(a5) # 800089c0 <first.1701>
    fsinit(ROOTDEV);
    80000f32:	4505                	li	a0,1
    80000f34:	00002097          	auipc	ra,0x2
    80000f38:	aea080e7          	jalr	-1302(ra) # 80002a1e <fsinit>
    80000f3c:	bff9                	j	80000f1a <forkret+0x24>

0000000080000f3e <allocpid>:
{
    80000f3e:	1101                	addi	sp,sp,-32
    80000f40:	ec06                	sd	ra,24(sp)
    80000f42:	e822                	sd	s0,16(sp)
    80000f44:	e426                	sd	s1,8(sp)
    80000f46:	e04a                	sd	s2,0(sp)
    80000f48:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f4a:	00008917          	auipc	s2,0x8
    80000f4e:	b3690913          	addi	s2,s2,-1226 # 80008a80 <pid_lock>
    80000f52:	854a                	mv	a0,s2
    80000f54:	00005097          	auipc	ra,0x5
    80000f58:	470080e7          	jalr	1136(ra) # 800063c4 <acquire>
  pid = nextpid;
    80000f5c:	00008797          	auipc	a5,0x8
    80000f60:	a6878793          	addi	a5,a5,-1432 # 800089c4 <nextpid>
    80000f64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f66:	0014871b          	addiw	a4,s1,1
    80000f6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f6c:	854a                	mv	a0,s2
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	50a080e7          	jalr	1290(ra) # 80006478 <release>
}
    80000f76:	8526                	mv	a0,s1
    80000f78:	60e2                	ld	ra,24(sp)
    80000f7a:	6442                	ld	s0,16(sp)
    80000f7c:	64a2                	ld	s1,8(sp)
    80000f7e:	6902                	ld	s2,0(sp)
    80000f80:	6105                	addi	sp,sp,32
    80000f82:	8082                	ret

0000000080000f84 <proc_pagetable>:
{
    80000f84:	1101                	addi	sp,sp,-32
    80000f86:	ec06                	sd	ra,24(sp)
    80000f88:	e822                	sd	s0,16(sp)
    80000f8a:	e426                	sd	s1,8(sp)
    80000f8c:	e04a                	sd	s2,0(sp)
    80000f8e:	1000                	addi	s0,sp,32
    80000f90:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	894080e7          	jalr	-1900(ra) # 80000826 <uvmcreate>
    80000f9a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f9c:	c121                	beqz	a0,80000fdc <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f9e:	4729                	li	a4,10
    80000fa0:	00006697          	auipc	a3,0x6
    80000fa4:	06068693          	addi	a3,a3,96 # 80007000 <_trampoline>
    80000fa8:	6605                	lui	a2,0x1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	fffff097          	auipc	ra,0xfffff
    80000fb6:	5ea080e7          	jalr	1514(ra) # 8000059c <mappages>
    80000fba:	02054863          	bltz	a0,80000fea <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fbe:	4719                	li	a4,6
    80000fc0:	05893683          	ld	a3,88(s2)
    80000fc4:	6605                	lui	a2,0x1
    80000fc6:	020005b7          	lui	a1,0x2000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b6                	slli	a1,a1,0xd
    80000fce:	8526                	mv	a0,s1
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	5cc080e7          	jalr	1484(ra) # 8000059c <mappages>
    80000fd8:	02054163          	bltz	a0,80000ffa <proc_pagetable+0x76>
}
    80000fdc:	8526                	mv	a0,s1
    80000fde:	60e2                	ld	ra,24(sp)
    80000fe0:	6442                	ld	s0,16(sp)
    80000fe2:	64a2                	ld	s1,8(sp)
    80000fe4:	6902                	ld	s2,0(sp)
    80000fe6:	6105                	addi	sp,sp,32
    80000fe8:	8082                	ret
    uvmfree(pagetable, 0);
    80000fea:	4581                	li	a1,0
    80000fec:	8526                	mv	a0,s1
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	a3a080e7          	jalr	-1478(ra) # 80000a28 <uvmfree>
    return 0;
    80000ff6:	4481                	li	s1,0
    80000ff8:	b7d5                	j	80000fdc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffa:	4681                	li	a3,0
    80000ffc:	4605                	li	a2,1
    80000ffe:	040005b7          	lui	a1,0x4000
    80001002:	15fd                	addi	a1,a1,-1
    80001004:	05b2                	slli	a1,a1,0xc
    80001006:	8526                	mv	a0,s1
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	758080e7          	jalr	1880(ra) # 80000760 <uvmunmap>
    uvmfree(pagetable, 0);
    80001010:	4581                	li	a1,0
    80001012:	8526                	mv	a0,s1
    80001014:	00000097          	auipc	ra,0x0
    80001018:	a14080e7          	jalr	-1516(ra) # 80000a28 <uvmfree>
    return 0;
    8000101c:	4481                	li	s1,0
    8000101e:	bf7d                	j	80000fdc <proc_pagetable+0x58>

0000000080001020 <proc_freepagetable>:
{
    80001020:	1101                	addi	sp,sp,-32
    80001022:	ec06                	sd	ra,24(sp)
    80001024:	e822                	sd	s0,16(sp)
    80001026:	e426                	sd	s1,8(sp)
    80001028:	e04a                	sd	s2,0(sp)
    8000102a:	1000                	addi	s0,sp,32
    8000102c:	84aa                	mv	s1,a0
    8000102e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001030:	4681                	li	a3,0
    80001032:	4605                	li	a2,1
    80001034:	040005b7          	lui	a1,0x4000
    80001038:	15fd                	addi	a1,a1,-1
    8000103a:	05b2                	slli	a1,a1,0xc
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	724080e7          	jalr	1828(ra) # 80000760 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	020005b7          	lui	a1,0x2000
    8000104c:	15fd                	addi	a1,a1,-1
    8000104e:	05b6                	slli	a1,a1,0xd
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	70e080e7          	jalr	1806(ra) # 80000760 <uvmunmap>
  uvmfree(pagetable, sz);
    8000105a:	85ca                	mv	a1,s2
    8000105c:	8526                	mv	a0,s1
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	9ca080e7          	jalr	-1590(ra) # 80000a28 <uvmfree>
}
    80001066:	60e2                	ld	ra,24(sp)
    80001068:	6442                	ld	s0,16(sp)
    8000106a:	64a2                	ld	s1,8(sp)
    8000106c:	6902                	ld	s2,0(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <freeproc>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	1000                	addi	s0,sp,32
    8000107c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000107e:	6d28                	ld	a0,88(a0)
    80001080:	c509                	beqz	a0,8000108a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	f9a080e7          	jalr	-102(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000108a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000108e:	68a8                	ld	a0,80(s1)
    80001090:	c511                	beqz	a0,8000109c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001092:	64ac                	ld	a1,72(s1)
    80001094:	00000097          	auipc	ra,0x0
    80001098:	f8c080e7          	jalr	-116(ra) # 80001020 <proc_freepagetable>
  p->pagetable = 0;
    8000109c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010a0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010a4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010a8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010ac:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010b0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010b4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010b8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010bc:	0004ac23          	sw	zero,24(s1)
}
    800010c0:	60e2                	ld	ra,24(sp)
    800010c2:	6442                	ld	s0,16(sp)
    800010c4:	64a2                	ld	s1,8(sp)
    800010c6:	6105                	addi	sp,sp,32
    800010c8:	8082                	ret

00000000800010ca <allocproc>:
{
    800010ca:	1101                	addi	sp,sp,-32
    800010cc:	ec06                	sd	ra,24(sp)
    800010ce:	e822                	sd	s0,16(sp)
    800010d0:	e426                	sd	s1,8(sp)
    800010d2:	e04a                	sd	s2,0(sp)
    800010d4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d6:	00008497          	auipc	s1,0x8
    800010da:	dda48493          	addi	s1,s1,-550 # 80008eb0 <proc>
    800010de:	0000e917          	auipc	s2,0xe
    800010e2:	9d290913          	addi	s2,s2,-1582 # 8000eab0 <tickslock>
    acquire(&p->lock);
    800010e6:	8526                	mv	a0,s1
    800010e8:	00005097          	auipc	ra,0x5
    800010ec:	2dc080e7          	jalr	732(ra) # 800063c4 <acquire>
    if(p->state == UNUSED) {
    800010f0:	4c9c                	lw	a5,24(s1)
    800010f2:	cf81                	beqz	a5,8000110a <allocproc+0x40>
      release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	382080e7          	jalr	898(ra) # 80006478 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010fe:	17048493          	addi	s1,s1,368
    80001102:	ff2492e3          	bne	s1,s2,800010e6 <allocproc+0x1c>
  return 0;
    80001106:	4481                	li	s1,0
    80001108:	a889                	j	8000115a <allocproc+0x90>
  p->pid = allocpid();
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	e34080e7          	jalr	-460(ra) # 80000f3e <allocpid>
    80001112:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001114:	4785                	li	a5,1
    80001116:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001118:	fffff097          	auipc	ra,0xfffff
    8000111c:	004080e7          	jalr	4(ra) # 8000011c <kalloc>
    80001120:	892a                	mv	s2,a0
    80001122:	eca8                	sd	a0,88(s1)
    80001124:	c131                	beqz	a0,80001168 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001126:	8526                	mv	a0,s1
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	e5c080e7          	jalr	-420(ra) # 80000f84 <proc_pagetable>
    80001130:	892a                	mv	s2,a0
    80001132:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001134:	c531                	beqz	a0,80001180 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001136:	07000613          	li	a2,112
    8000113a:	4581                	li	a1,0
    8000113c:	06048513          	addi	a0,s1,96
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	064080e7          	jalr	100(ra) # 800001a4 <memset>
  p->context.ra = (uint64)forkret;
    80001148:	00000797          	auipc	a5,0x0
    8000114c:	dae78793          	addi	a5,a5,-594 # 80000ef6 <forkret>
    80001150:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001152:	60bc                	ld	a5,64(s1)
    80001154:	6705                	lui	a4,0x1
    80001156:	97ba                	add	a5,a5,a4
    80001158:	f4bc                	sd	a5,104(s1)
}
    8000115a:	8526                	mv	a0,s1
    8000115c:	60e2                	ld	ra,24(sp)
    8000115e:	6442                	ld	s0,16(sp)
    80001160:	64a2                	ld	s1,8(sp)
    80001162:	6902                	ld	s2,0(sp)
    80001164:	6105                	addi	sp,sp,32
    80001166:	8082                	ret
    freeproc(p);
    80001168:	8526                	mv	a0,s1
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	f08080e7          	jalr	-248(ra) # 80001072 <freeproc>
    release(&p->lock);
    80001172:	8526                	mv	a0,s1
    80001174:	00005097          	auipc	ra,0x5
    80001178:	304080e7          	jalr	772(ra) # 80006478 <release>
    return 0;
    8000117c:	84ca                	mv	s1,s2
    8000117e:	bff1                	j	8000115a <allocproc+0x90>
    freeproc(p);
    80001180:	8526                	mv	a0,s1
    80001182:	00000097          	auipc	ra,0x0
    80001186:	ef0080e7          	jalr	-272(ra) # 80001072 <freeproc>
    release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	2ec080e7          	jalr	748(ra) # 80006478 <release>
    return 0;
    80001194:	84ca                	mv	s1,s2
    80001196:	b7d1                	j	8000115a <allocproc+0x90>

0000000080001198 <userinit>:
{
    80001198:	1101                	addi	sp,sp,-32
    8000119a:	ec06                	sd	ra,24(sp)
    8000119c:	e822                	sd	s0,16(sp)
    8000119e:	e426                	sd	s1,8(sp)
    800011a0:	1000                	addi	s0,sp,32
  p = allocproc();
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	f28080e7          	jalr	-216(ra) # 800010ca <allocproc>
    800011aa:	84aa                	mv	s1,a0
  initproc = p;
    800011ac:	00008797          	auipc	a5,0x8
    800011b0:	88a7ba23          	sd	a0,-1900(a5) # 80008a40 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011b4:	03400613          	li	a2,52
    800011b8:	00008597          	auipc	a1,0x8
    800011bc:	81858593          	addi	a1,a1,-2024 # 800089d0 <initcode>
    800011c0:	6928                	ld	a0,80(a0)
    800011c2:	fffff097          	auipc	ra,0xfffff
    800011c6:	692080e7          	jalr	1682(ra) # 80000854 <uvmfirst>
  p->sz = PGSIZE;
    800011ca:	6785                	lui	a5,0x1
    800011cc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ce:	6cb8                	ld	a4,88(s1)
    800011d0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011d4:	6cb8                	ld	a4,88(s1)
    800011d6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011d8:	4641                	li	a2,16
    800011da:	00007597          	auipc	a1,0x7
    800011de:	fd658593          	addi	a1,a1,-42 # 800081b0 <states.1745+0x58>
    800011e2:	15848513          	addi	a0,s1,344
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	132080e7          	jalr	306(ra) # 80000318 <safestrcpy>
  p->cwd = namei("/");
    800011ee:	00007517          	auipc	a0,0x7
    800011f2:	fd250513          	addi	a0,a0,-46 # 800081c0 <states.1745+0x68>
    800011f6:	00002097          	auipc	ra,0x2
    800011fa:	258080e7          	jalr	600(ra) # 8000344e <namei>
    800011fe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001202:	478d                	li	a5,3
    80001204:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	270080e7          	jalr	624(ra) # 80006478 <release>
}
    80001210:	60e2                	ld	ra,24(sp)
    80001212:	6442                	ld	s0,16(sp)
    80001214:	64a2                	ld	s1,8(sp)
    80001216:	6105                	addi	sp,sp,32
    80001218:	8082                	ret

000000008000121a <growproc>:
{
    8000121a:	1101                	addi	sp,sp,-32
    8000121c:	ec06                	sd	ra,24(sp)
    8000121e:	e822                	sd	s0,16(sp)
    80001220:	e426                	sd	s1,8(sp)
    80001222:	e04a                	sd	s2,0(sp)
    80001224:	1000                	addi	s0,sp,32
    80001226:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c96080e7          	jalr	-874(ra) # 80000ebe <myproc>
    80001230:	84aa                	mv	s1,a0
  sz = p->sz;
    80001232:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001234:	01204c63          	bgtz	s2,8000124c <growproc+0x32>
  } else if(n < 0){
    80001238:	02094663          	bltz	s2,80001264 <growproc+0x4a>
  p->sz = sz;
    8000123c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000123e:	4501                	li	a0,0
}
    80001240:	60e2                	ld	ra,24(sp)
    80001242:	6442                	ld	s0,16(sp)
    80001244:	64a2                	ld	s1,8(sp)
    80001246:	6902                	ld	s2,0(sp)
    80001248:	6105                	addi	sp,sp,32
    8000124a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000124c:	4691                	li	a3,4
    8000124e:	00b90633          	add	a2,s2,a1
    80001252:	6928                	ld	a0,80(a0)
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	6b8080e7          	jalr	1720(ra) # 8000090c <uvmalloc>
    8000125c:	85aa                	mv	a1,a0
    8000125e:	fd79                	bnez	a0,8000123c <growproc+0x22>
      return -1;
    80001260:	557d                	li	a0,-1
    80001262:	bff9                	j	80001240 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001264:	00b90633          	add	a2,s2,a1
    80001268:	6928                	ld	a0,80(a0)
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	65c080e7          	jalr	1628(ra) # 800008c6 <uvmdealloc>
    80001272:	85aa                	mv	a1,a0
    80001274:	b7e1                	j	8000123c <growproc+0x22>

0000000080001276 <fork>:
{
    80001276:	7179                	addi	sp,sp,-48
    80001278:	f406                	sd	ra,40(sp)
    8000127a:	f022                	sd	s0,32(sp)
    8000127c:	ec26                	sd	s1,24(sp)
    8000127e:	e84a                	sd	s2,16(sp)
    80001280:	e44e                	sd	s3,8(sp)
    80001282:	e052                	sd	s4,0(sp)
    80001284:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	c38080e7          	jalr	-968(ra) # 80000ebe <myproc>
    8000128e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001290:	00000097          	auipc	ra,0x0
    80001294:	e3a080e7          	jalr	-454(ra) # 800010ca <allocproc>
    80001298:	10050f63          	beqz	a0,800013b6 <fork+0x140>
    8000129c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000129e:	04893603          	ld	a2,72(s2)
    800012a2:	692c                	ld	a1,80(a0)
    800012a4:	05093503          	ld	a0,80(s2)
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	7b8080e7          	jalr	1976(ra) # 80000a60 <uvmcopy>
    800012b0:	04054a63          	bltz	a0,80001304 <fork+0x8e>
  np->sz = p->sz;
    800012b4:	04893783          	ld	a5,72(s2)
    800012b8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012bc:	05893683          	ld	a3,88(s2)
    800012c0:	87b6                	mv	a5,a3
    800012c2:	0589b703          	ld	a4,88(s3)
    800012c6:	12068693          	addi	a3,a3,288
    800012ca:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ce:	6788                	ld	a0,8(a5)
    800012d0:	6b8c                	ld	a1,16(a5)
    800012d2:	6f90                	ld	a2,24(a5)
    800012d4:	01073023          	sd	a6,0(a4)
    800012d8:	e708                	sd	a0,8(a4)
    800012da:	eb0c                	sd	a1,16(a4)
    800012dc:	ef10                	sd	a2,24(a4)
    800012de:	02078793          	addi	a5,a5,32
    800012e2:	02070713          	addi	a4,a4,32
    800012e6:	fed792e3          	bne	a5,a3,800012ca <fork+0x54>
  np->trapframe->a0 = 0;
    800012ea:	0589b783          	ld	a5,88(s3)
    800012ee:	0607b823          	sd	zero,112(a5)
  np->syscallnummask = p->syscallnummask;
    800012f2:	16893783          	ld	a5,360(s2)
    800012f6:	16f9b423          	sd	a5,360(s3)
    800012fa:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012fe:	15000a13          	li	s4,336
    80001302:	a03d                	j	80001330 <fork+0xba>
    freeproc(np);
    80001304:	854e                	mv	a0,s3
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	d6c080e7          	jalr	-660(ra) # 80001072 <freeproc>
    release(&np->lock);
    8000130e:	854e                	mv	a0,s3
    80001310:	00005097          	auipc	ra,0x5
    80001314:	168080e7          	jalr	360(ra) # 80006478 <release>
    return -1;
    80001318:	5a7d                	li	s4,-1
    8000131a:	a069                	j	800013a4 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131c:	00002097          	auipc	ra,0x2
    80001320:	7f8080e7          	jalr	2040(ra) # 80003b14 <filedup>
    80001324:	009987b3          	add	a5,s3,s1
    80001328:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000132a:	04a1                	addi	s1,s1,8
    8000132c:	01448763          	beq	s1,s4,8000133a <fork+0xc4>
    if(p->ofile[i])
    80001330:	009907b3          	add	a5,s2,s1
    80001334:	6388                	ld	a0,0(a5)
    80001336:	f17d                	bnez	a0,8000131c <fork+0xa6>
    80001338:	bfcd                	j	8000132a <fork+0xb4>
  np->cwd = idup(p->cwd);
    8000133a:	15093503          	ld	a0,336(s2)
    8000133e:	00002097          	auipc	ra,0x2
    80001342:	920080e7          	jalr	-1760(ra) # 80002c5e <idup>
    80001346:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000134a:	4641                	li	a2,16
    8000134c:	15890593          	addi	a1,s2,344
    80001350:	15898513          	addi	a0,s3,344
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	fc4080e7          	jalr	-60(ra) # 80000318 <safestrcpy>
  pid = np->pid;
    8000135c:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001360:	854e                	mv	a0,s3
    80001362:	00005097          	auipc	ra,0x5
    80001366:	116080e7          	jalr	278(ra) # 80006478 <release>
  acquire(&wait_lock);
    8000136a:	00007497          	auipc	s1,0x7
    8000136e:	72e48493          	addi	s1,s1,1838 # 80008a98 <wait_lock>
    80001372:	8526                	mv	a0,s1
    80001374:	00005097          	auipc	ra,0x5
    80001378:	050080e7          	jalr	80(ra) # 800063c4 <acquire>
  np->parent = p;
    8000137c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001380:	8526                	mv	a0,s1
    80001382:	00005097          	auipc	ra,0x5
    80001386:	0f6080e7          	jalr	246(ra) # 80006478 <release>
  acquire(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	038080e7          	jalr	56(ra) # 800063c4 <acquire>
  np->state = RUNNABLE;
    80001394:	478d                	li	a5,3
    80001396:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000139a:	854e                	mv	a0,s3
    8000139c:	00005097          	auipc	ra,0x5
    800013a0:	0dc080e7          	jalr	220(ra) # 80006478 <release>
}
    800013a4:	8552                	mv	a0,s4
    800013a6:	70a2                	ld	ra,40(sp)
    800013a8:	7402                	ld	s0,32(sp)
    800013aa:	64e2                	ld	s1,24(sp)
    800013ac:	6942                	ld	s2,16(sp)
    800013ae:	69a2                	ld	s3,8(sp)
    800013b0:	6a02                	ld	s4,0(sp)
    800013b2:	6145                	addi	sp,sp,48
    800013b4:	8082                	ret
    return -1;
    800013b6:	5a7d                	li	s4,-1
    800013b8:	b7f5                	j	800013a4 <fork+0x12e>

00000000800013ba <scheduler>:
{
    800013ba:	7139                	addi	sp,sp,-64
    800013bc:	fc06                	sd	ra,56(sp)
    800013be:	f822                	sd	s0,48(sp)
    800013c0:	f426                	sd	s1,40(sp)
    800013c2:	f04a                	sd	s2,32(sp)
    800013c4:	ec4e                	sd	s3,24(sp)
    800013c6:	e852                	sd	s4,16(sp)
    800013c8:	e456                	sd	s5,8(sp)
    800013ca:	e05a                	sd	s6,0(sp)
    800013cc:	0080                	addi	s0,sp,64
    800013ce:	8792                	mv	a5,tp
  int id = r_tp();
    800013d0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013d2:	00779a93          	slli	s5,a5,0x7
    800013d6:	00007717          	auipc	a4,0x7
    800013da:	6aa70713          	addi	a4,a4,1706 # 80008a80 <pid_lock>
    800013de:	9756                	add	a4,a4,s5
    800013e0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013e4:	00007717          	auipc	a4,0x7
    800013e8:	6d470713          	addi	a4,a4,1748 # 80008ab8 <cpus+0x8>
    800013ec:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ee:	498d                	li	s3,3
        p->state = RUNNING;
    800013f0:	4b11                	li	s6,4
        c->proc = p;
    800013f2:	079e                	slli	a5,a5,0x7
    800013f4:	00007a17          	auipc	s4,0x7
    800013f8:	68ca0a13          	addi	s4,s4,1676 # 80008a80 <pid_lock>
    800013fc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	0000d917          	auipc	s2,0xd
    80001402:	6b290913          	addi	s2,s2,1714 # 8000eab0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001406:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000140a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000140e:	10079073          	csrw	sstatus,a5
    80001412:	00008497          	auipc	s1,0x8
    80001416:	a9e48493          	addi	s1,s1,-1378 # 80008eb0 <proc>
    8000141a:	a03d                	j	80001448 <scheduler+0x8e>
        p->state = RUNNING;
    8000141c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001420:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001424:	06048593          	addi	a1,s1,96
    80001428:	8556                	mv	a0,s5
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	6da080e7          	jalr	1754(ra) # 80001b04 <swtch>
        c->proc = 0;
    80001432:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001436:	8526                	mv	a0,s1
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	040080e7          	jalr	64(ra) # 80006478 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001440:	17048493          	addi	s1,s1,368
    80001444:	fd2481e3          	beq	s1,s2,80001406 <scheduler+0x4c>
      acquire(&p->lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	f7a080e7          	jalr	-134(ra) # 800063c4 <acquire>
      if(p->state == RUNNABLE) {
    80001452:	4c9c                	lw	a5,24(s1)
    80001454:	ff3791e3          	bne	a5,s3,80001436 <scheduler+0x7c>
    80001458:	b7d1                	j	8000141c <scheduler+0x62>

000000008000145a <sched>:
{
    8000145a:	7179                	addi	sp,sp,-48
    8000145c:	f406                	sd	ra,40(sp)
    8000145e:	f022                	sd	s0,32(sp)
    80001460:	ec26                	sd	s1,24(sp)
    80001462:	e84a                	sd	s2,16(sp)
    80001464:	e44e                	sd	s3,8(sp)
    80001466:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	a56080e7          	jalr	-1450(ra) # 80000ebe <myproc>
    80001470:	892a                	mv	s2,a0
  if(!holding(&p->lock))
    80001472:	00005097          	auipc	ra,0x5
    80001476:	ed8080e7          	jalr	-296(ra) # 8000634a <holding>
    8000147a:	cd25                	beqz	a0,800014f2 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	00007717          	auipc	a4,0x7
    80001486:	5fe70713          	addi	a4,a4,1534 # 80008a80 <pid_lock>
    8000148a:	97ba                	add	a5,a5,a4
    8000148c:	0a87a703          	lw	a4,168(a5)
    80001490:	4785                	li	a5,1
    80001492:	06f71863          	bne	a4,a5,80001502 <sched+0xa8>
  if(p->state == RUNNING)
    80001496:	01892703          	lw	a4,24(s2)
    8000149a:	4791                	li	a5,4
    8000149c:	06f70b63          	beq	a4,a5,80001512 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014a4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014a6:	efb5                	bnez	a5,80001522 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014aa:	00007497          	auipc	s1,0x7
    800014ae:	5d648493          	addi	s1,s1,1494 # 80008a80 <pid_lock>
    800014b2:	2781                	sext.w	a5,a5
    800014b4:	079e                	slli	a5,a5,0x7
    800014b6:	97a6                	add	a5,a5,s1
    800014b8:	0ac7a983          	lw	s3,172(a5)
    800014bc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014be:	2781                	sext.w	a5,a5
    800014c0:	079e                	slli	a5,a5,0x7
    800014c2:	00007597          	auipc	a1,0x7
    800014c6:	5f658593          	addi	a1,a1,1526 # 80008ab8 <cpus+0x8>
    800014ca:	95be                	add	a1,a1,a5
    800014cc:	06090513          	addi	a0,s2,96
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	634080e7          	jalr	1588(ra) # 80001b04 <swtch>
    800014d8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014da:	2781                	sext.w	a5,a5
    800014dc:	079e                	slli	a5,a5,0x7
    800014de:	97a6                	add	a5,a5,s1
    800014e0:	0b37a623          	sw	s3,172(a5)
}
    800014e4:	70a2                	ld	ra,40(sp)
    800014e6:	7402                	ld	s0,32(sp)
    800014e8:	64e2                	ld	s1,24(sp)
    800014ea:	6942                	ld	s2,16(sp)
    800014ec:	69a2                	ld	s3,8(sp)
    800014ee:	6145                	addi	sp,sp,48
    800014f0:	8082                	ret
    panic("sched p->lock");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	cd650513          	addi	a0,a0,-810 # 800081c8 <states.1745+0x70>
    800014fa:	00005097          	auipc	ra,0x5
    800014fe:	95e080e7          	jalr	-1698(ra) # 80005e58 <panic>
    panic("sched locks");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	cd650513          	addi	a0,a0,-810 # 800081d8 <states.1745+0x80>
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	94e080e7          	jalr	-1714(ra) # 80005e58 <panic>
    panic("sched running");
    80001512:	00007517          	auipc	a0,0x7
    80001516:	cd650513          	addi	a0,a0,-810 # 800081e8 <states.1745+0x90>
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	93e080e7          	jalr	-1730(ra) # 80005e58 <panic>
    panic("sched interruptible");
    80001522:	00007517          	auipc	a0,0x7
    80001526:	cd650513          	addi	a0,a0,-810 # 800081f8 <states.1745+0xa0>
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	92e080e7          	jalr	-1746(ra) # 80005e58 <panic>

0000000080001532 <yield>:
{
    80001532:	1101                	addi	sp,sp,-32
    80001534:	ec06                	sd	ra,24(sp)
    80001536:	e822                	sd	s0,16(sp)
    80001538:	e426                	sd	s1,8(sp)
    8000153a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	982080e7          	jalr	-1662(ra) # 80000ebe <myproc>
    80001544:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	e7e080e7          	jalr	-386(ra) # 800063c4 <acquire>
  p->state = RUNNABLE;
    8000154e:	478d                	li	a5,3
    80001550:	cc9c                	sw	a5,24(s1)
  sched();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	f08080e7          	jalr	-248(ra) # 8000145a <sched>
  release(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	f1c080e7          	jalr	-228(ra) # 80006478 <release>
}
    80001564:	60e2                	ld	ra,24(sp)
    80001566:	6442                	ld	s0,16(sp)
    80001568:	64a2                	ld	s1,8(sp)
    8000156a:	6105                	addi	sp,sp,32
    8000156c:	8082                	ret

000000008000156e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000156e:	7179                	addi	sp,sp,-48
    80001570:	f406                	sd	ra,40(sp)
    80001572:	f022                	sd	s0,32(sp)
    80001574:	ec26                	sd	s1,24(sp)
    80001576:	e84a                	sd	s2,16(sp)
    80001578:	e44e                	sd	s3,8(sp)
    8000157a:	1800                	addi	s0,sp,48
    8000157c:	89aa                	mv	s3,a0
    8000157e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	93e080e7          	jalr	-1730(ra) # 80000ebe <myproc>
    80001588:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	e3a080e7          	jalr	-454(ra) # 800063c4 <acquire>
  release(lk);
    80001592:	854a                	mv	a0,s2
    80001594:	00005097          	auipc	ra,0x5
    80001598:	ee4080e7          	jalr	-284(ra) # 80006478 <release>

  // Go to sleep.
  p->chan = chan;
    8000159c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015a0:	4789                	li	a5,2
    800015a2:	cc9c                	sw	a5,24(s1)

  sched();
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	eb6080e7          	jalr	-330(ra) # 8000145a <sched>

  // Tidy up.
  p->chan = 0;
    800015ac:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015b0:	8526                	mv	a0,s1
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	ec6080e7          	jalr	-314(ra) # 80006478 <release>
  acquire(lk);
    800015ba:	854a                	mv	a0,s2
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	e08080e7          	jalr	-504(ra) # 800063c4 <acquire>
}
    800015c4:	70a2                	ld	ra,40(sp)
    800015c6:	7402                	ld	s0,32(sp)
    800015c8:	64e2                	ld	s1,24(sp)
    800015ca:	6942                	ld	s2,16(sp)
    800015cc:	69a2                	ld	s3,8(sp)
    800015ce:	6145                	addi	sp,sp,48
    800015d0:	8082                	ret

00000000800015d2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015d2:	7139                	addi	sp,sp,-64
    800015d4:	fc06                	sd	ra,56(sp)
    800015d6:	f822                	sd	s0,48(sp)
    800015d8:	f426                	sd	s1,40(sp)
    800015da:	f04a                	sd	s2,32(sp)
    800015dc:	ec4e                	sd	s3,24(sp)
    800015de:	e852                	sd	s4,16(sp)
    800015e0:	e456                	sd	s5,8(sp)
    800015e2:	0080                	addi	s0,sp,64
    800015e4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015e6:	00008497          	auipc	s1,0x8
    800015ea:	8ca48493          	addi	s1,s1,-1846 # 80008eb0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015ee:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015f0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015f2:	0000d917          	auipc	s2,0xd
    800015f6:	4be90913          	addi	s2,s2,1214 # 8000eab0 <tickslock>
    800015fa:	a821                	j	80001612 <wakeup+0x40>
        p->state = RUNNABLE;
    800015fc:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	e76080e7          	jalr	-394(ra) # 80006478 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000160a:	17048493          	addi	s1,s1,368
    8000160e:	03248463          	beq	s1,s2,80001636 <wakeup+0x64>
    if(p != myproc()){
    80001612:	00000097          	auipc	ra,0x0
    80001616:	8ac080e7          	jalr	-1876(ra) # 80000ebe <myproc>
    8000161a:	fea488e3          	beq	s1,a0,8000160a <wakeup+0x38>
      acquire(&p->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	00005097          	auipc	ra,0x5
    80001624:	da4080e7          	jalr	-604(ra) # 800063c4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001628:	4c9c                	lw	a5,24(s1)
    8000162a:	fd379be3          	bne	a5,s3,80001600 <wakeup+0x2e>
    8000162e:	709c                	ld	a5,32(s1)
    80001630:	fd4798e3          	bne	a5,s4,80001600 <wakeup+0x2e>
    80001634:	b7e1                	j	800015fc <wakeup+0x2a>
    }
  }
}
    80001636:	70e2                	ld	ra,56(sp)
    80001638:	7442                	ld	s0,48(sp)
    8000163a:	74a2                	ld	s1,40(sp)
    8000163c:	7902                	ld	s2,32(sp)
    8000163e:	69e2                	ld	s3,24(sp)
    80001640:	6a42                	ld	s4,16(sp)
    80001642:	6aa2                	ld	s5,8(sp)
    80001644:	6121                	addi	sp,sp,64
    80001646:	8082                	ret

0000000080001648 <reparent>:
{
    80001648:	7179                	addi	sp,sp,-48
    8000164a:	f406                	sd	ra,40(sp)
    8000164c:	f022                	sd	s0,32(sp)
    8000164e:	ec26                	sd	s1,24(sp)
    80001650:	e84a                	sd	s2,16(sp)
    80001652:	e44e                	sd	s3,8(sp)
    80001654:	e052                	sd	s4,0(sp)
    80001656:	1800                	addi	s0,sp,48
    80001658:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000165a:	00008497          	auipc	s1,0x8
    8000165e:	85648493          	addi	s1,s1,-1962 # 80008eb0 <proc>
      pp->parent = initproc;
    80001662:	00007a17          	auipc	s4,0x7
    80001666:	3dea0a13          	addi	s4,s4,990 # 80008a40 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000166a:	0000d917          	auipc	s2,0xd
    8000166e:	44690913          	addi	s2,s2,1094 # 8000eab0 <tickslock>
    80001672:	a029                	j	8000167c <reparent+0x34>
    80001674:	17048493          	addi	s1,s1,368
    80001678:	01248d63          	beq	s1,s2,80001692 <reparent+0x4a>
    if(pp->parent == p){
    8000167c:	7c9c                	ld	a5,56(s1)
    8000167e:	ff379be3          	bne	a5,s3,80001674 <reparent+0x2c>
      pp->parent = initproc;
    80001682:	000a3503          	ld	a0,0(s4)
    80001686:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	f4a080e7          	jalr	-182(ra) # 800015d2 <wakeup>
    80001690:	b7d5                	j	80001674 <reparent+0x2c>
}
    80001692:	70a2                	ld	ra,40(sp)
    80001694:	7402                	ld	s0,32(sp)
    80001696:	64e2                	ld	s1,24(sp)
    80001698:	6942                	ld	s2,16(sp)
    8000169a:	69a2                	ld	s3,8(sp)
    8000169c:	6a02                	ld	s4,0(sp)
    8000169e:	6145                	addi	sp,sp,48
    800016a0:	8082                	ret

00000000800016a2 <exit>:
{
    800016a2:	7179                	addi	sp,sp,-48
    800016a4:	f406                	sd	ra,40(sp)
    800016a6:	f022                	sd	s0,32(sp)
    800016a8:	ec26                	sd	s1,24(sp)
    800016aa:	e84a                	sd	s2,16(sp)
    800016ac:	e44e                	sd	s3,8(sp)
    800016ae:	e052                	sd	s4,0(sp)
    800016b0:	1800                	addi	s0,sp,48
    800016b2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	80a080e7          	jalr	-2038(ra) # 80000ebe <myproc>
    800016bc:	89aa                	mv	s3,a0
  if(p == initproc)
    800016be:	00007797          	auipc	a5,0x7
    800016c2:	38278793          	addi	a5,a5,898 # 80008a40 <initproc>
    800016c6:	639c                	ld	a5,0(a5)
    800016c8:	0d050493          	addi	s1,a0,208
    800016cc:	15050913          	addi	s2,a0,336
    800016d0:	02a79363          	bne	a5,a0,800016f6 <exit+0x54>
    panic("init exiting");
    800016d4:	00007517          	auipc	a0,0x7
    800016d8:	b3c50513          	addi	a0,a0,-1220 # 80008210 <states.1745+0xb8>
    800016dc:	00004097          	auipc	ra,0x4
    800016e0:	77c080e7          	jalr	1916(ra) # 80005e58 <panic>
      fileclose(f);
    800016e4:	00002097          	auipc	ra,0x2
    800016e8:	482080e7          	jalr	1154(ra) # 80003b66 <fileclose>
      p->ofile[fd] = 0;
    800016ec:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016f0:	04a1                	addi	s1,s1,8
    800016f2:	01248563          	beq	s1,s2,800016fc <exit+0x5a>
    if(p->ofile[fd]){
    800016f6:	6088                	ld	a0,0(s1)
    800016f8:	f575                	bnez	a0,800016e4 <exit+0x42>
    800016fa:	bfdd                	j	800016f0 <exit+0x4e>
  begin_op();
    800016fc:	00002097          	auipc	ra,0x2
    80001700:	f70080e7          	jalr	-144(ra) # 8000366c <begin_op>
  iput(p->cwd);
    80001704:	1509b503          	ld	a0,336(s3)
    80001708:	00001097          	auipc	ra,0x1
    8000170c:	750080e7          	jalr	1872(ra) # 80002e58 <iput>
  end_op();
    80001710:	00002097          	auipc	ra,0x2
    80001714:	fdc080e7          	jalr	-36(ra) # 800036ec <end_op>
  p->cwd = 0;
    80001718:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000171c:	00007497          	auipc	s1,0x7
    80001720:	37c48493          	addi	s1,s1,892 # 80008a98 <wait_lock>
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	c9e080e7          	jalr	-866(ra) # 800063c4 <acquire>
  reparent(p);
    8000172e:	854e                	mv	a0,s3
    80001730:	00000097          	auipc	ra,0x0
    80001734:	f18080e7          	jalr	-232(ra) # 80001648 <reparent>
  wakeup(p->parent);
    80001738:	0389b503          	ld	a0,56(s3)
    8000173c:	00000097          	auipc	ra,0x0
    80001740:	e96080e7          	jalr	-362(ra) # 800015d2 <wakeup>
  acquire(&p->lock);
    80001744:	854e                	mv	a0,s3
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	c7e080e7          	jalr	-898(ra) # 800063c4 <acquire>
  p->xstate = status;
    8000174e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001752:	4795                	li	a5,5
    80001754:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	d1e080e7          	jalr	-738(ra) # 80006478 <release>
  sched();
    80001762:	00000097          	auipc	ra,0x0
    80001766:	cf8080e7          	jalr	-776(ra) # 8000145a <sched>
  panic("zombie exit");
    8000176a:	00007517          	auipc	a0,0x7
    8000176e:	ab650513          	addi	a0,a0,-1354 # 80008220 <states.1745+0xc8>
    80001772:	00004097          	auipc	ra,0x4
    80001776:	6e6080e7          	jalr	1766(ra) # 80005e58 <panic>

000000008000177a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000177a:	7179                	addi	sp,sp,-48
    8000177c:	f406                	sd	ra,40(sp)
    8000177e:	f022                	sd	s0,32(sp)
    80001780:	ec26                	sd	s1,24(sp)
    80001782:	e84a                	sd	s2,16(sp)
    80001784:	e44e                	sd	s3,8(sp)
    80001786:	1800                	addi	s0,sp,48
    80001788:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000178a:	00007497          	auipc	s1,0x7
    8000178e:	72648493          	addi	s1,s1,1830 # 80008eb0 <proc>
    80001792:	0000d997          	auipc	s3,0xd
    80001796:	31e98993          	addi	s3,s3,798 # 8000eab0 <tickslock>
    acquire(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	c28080e7          	jalr	-984(ra) # 800063c4 <acquire>
    if(p->pid == pid){
    800017a4:	589c                	lw	a5,48(s1)
    800017a6:	01278d63          	beq	a5,s2,800017c0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	ccc080e7          	jalr	-820(ra) # 80006478 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b4:	17048493          	addi	s1,s1,368
    800017b8:	ff3491e3          	bne	s1,s3,8000179a <kill+0x20>
  }
  return -1;
    800017bc:	557d                	li	a0,-1
    800017be:	a829                	j	800017d8 <kill+0x5e>
      p->killed = 1;
    800017c0:	4785                	li	a5,1
    800017c2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017c4:	4c98                	lw	a4,24(s1)
    800017c6:	4789                	li	a5,2
    800017c8:	00f70f63          	beq	a4,a5,800017e6 <kill+0x6c>
      release(&p->lock);
    800017cc:	8526                	mv	a0,s1
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	caa080e7          	jalr	-854(ra) # 80006478 <release>
      return 0;
    800017d6:	4501                	li	a0,0
}
    800017d8:	70a2                	ld	ra,40(sp)
    800017da:	7402                	ld	s0,32(sp)
    800017dc:	64e2                	ld	s1,24(sp)
    800017de:	6942                	ld	s2,16(sp)
    800017e0:	69a2                	ld	s3,8(sp)
    800017e2:	6145                	addi	sp,sp,48
    800017e4:	8082                	ret
        p->state = RUNNABLE;
    800017e6:	478d                	li	a5,3
    800017e8:	cc9c                	sw	a5,24(s1)
    800017ea:	b7cd                	j	800017cc <kill+0x52>

00000000800017ec <setkilled>:

void
setkilled(struct proc *p)
{
    800017ec:	1101                	addi	sp,sp,-32
    800017ee:	ec06                	sd	ra,24(sp)
    800017f0:	e822                	sd	s0,16(sp)
    800017f2:	e426                	sd	s1,8(sp)
    800017f4:	1000                	addi	s0,sp,32
    800017f6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	bcc080e7          	jalr	-1076(ra) # 800063c4 <acquire>
  p->killed = 1;
    80001800:	4785                	li	a5,1
    80001802:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001804:	8526                	mv	a0,s1
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	c72080e7          	jalr	-910(ra) # 80006478 <release>
}
    8000180e:	60e2                	ld	ra,24(sp)
    80001810:	6442                	ld	s0,16(sp)
    80001812:	64a2                	ld	s1,8(sp)
    80001814:	6105                	addi	sp,sp,32
    80001816:	8082                	ret

0000000080001818 <killed>:

int
killed(struct proc *p)
{
    80001818:	1101                	addi	sp,sp,-32
    8000181a:	ec06                	sd	ra,24(sp)
    8000181c:	e822                	sd	s0,16(sp)
    8000181e:	e426                	sd	s1,8(sp)
    80001820:	e04a                	sd	s2,0(sp)
    80001822:	1000                	addi	s0,sp,32
    80001824:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001826:	00005097          	auipc	ra,0x5
    8000182a:	b9e080e7          	jalr	-1122(ra) # 800063c4 <acquire>
  k = p->killed;
    8000182e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	c44080e7          	jalr	-956(ra) # 80006478 <release>
  return k;
}
    8000183c:	854a                	mv	a0,s2
    8000183e:	60e2                	ld	ra,24(sp)
    80001840:	6442                	ld	s0,16(sp)
    80001842:	64a2                	ld	s1,8(sp)
    80001844:	6902                	ld	s2,0(sp)
    80001846:	6105                	addi	sp,sp,32
    80001848:	8082                	ret

000000008000184a <wait>:
{
    8000184a:	715d                	addi	sp,sp,-80
    8000184c:	e486                	sd	ra,72(sp)
    8000184e:	e0a2                	sd	s0,64(sp)
    80001850:	fc26                	sd	s1,56(sp)
    80001852:	f84a                	sd	s2,48(sp)
    80001854:	f44e                	sd	s3,40(sp)
    80001856:	f052                	sd	s4,32(sp)
    80001858:	ec56                	sd	s5,24(sp)
    8000185a:	e85a                	sd	s6,16(sp)
    8000185c:	e45e                	sd	s7,8(sp)
    8000185e:	e062                	sd	s8,0(sp)
    80001860:	0880                	addi	s0,sp,80
    80001862:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001864:	fffff097          	auipc	ra,0xfffff
    80001868:	65a080e7          	jalr	1626(ra) # 80000ebe <myproc>
    8000186c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000186e:	00007517          	auipc	a0,0x7
    80001872:	22a50513          	addi	a0,a0,554 # 80008a98 <wait_lock>
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	b4e080e7          	jalr	-1202(ra) # 800063c4 <acquire>
    havekids = 0;
    8000187e:	4b01                	li	s6,0
        if(pp->state == ZOMBIE){
    80001880:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001882:	0000d997          	auipc	s3,0xd
    80001886:	22e98993          	addi	s3,s3,558 # 8000eab0 <tickslock>
        havekids = 1;
    8000188a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000188c:	00007c17          	auipc	s8,0x7
    80001890:	20cc0c13          	addi	s8,s8,524 # 80008a98 <wait_lock>
    havekids = 0;
    80001894:	875a                	mv	a4,s6
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001896:	00007497          	auipc	s1,0x7
    8000189a:	61a48493          	addi	s1,s1,1562 # 80008eb0 <proc>
    8000189e:	a0bd                	j	8000190c <wait+0xc2>
          pid = pp->pid;
    800018a0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018a4:	000b8e63          	beqz	s7,800018c0 <wait+0x76>
    800018a8:	4691                	li	a3,4
    800018aa:	02c48613          	addi	a2,s1,44
    800018ae:	85de                	mv	a1,s7
    800018b0:	05093503          	ld	a0,80(s2)
    800018b4:	fffff097          	auipc	ra,0xfffff
    800018b8:	2b0080e7          	jalr	688(ra) # 80000b64 <copyout>
    800018bc:	02054563          	bltz	a0,800018e6 <wait+0x9c>
          freeproc(pp);
    800018c0:	8526                	mv	a0,s1
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	7b0080e7          	jalr	1968(ra) # 80001072 <freeproc>
          release(&pp->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	bac080e7          	jalr	-1108(ra) # 80006478 <release>
          release(&wait_lock);
    800018d4:	00007517          	auipc	a0,0x7
    800018d8:	1c450513          	addi	a0,a0,452 # 80008a98 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	b9c080e7          	jalr	-1124(ra) # 80006478 <release>
          return pid;
    800018e4:	a0b5                	j	80001950 <wait+0x106>
            release(&pp->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	b90080e7          	jalr	-1136(ra) # 80006478 <release>
            release(&wait_lock);
    800018f0:	00007517          	auipc	a0,0x7
    800018f4:	1a850513          	addi	a0,a0,424 # 80008a98 <wait_lock>
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	b80080e7          	jalr	-1152(ra) # 80006478 <release>
            return -1;
    80001900:	59fd                	li	s3,-1
    80001902:	a0b9                	j	80001950 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001904:	17048493          	addi	s1,s1,368
    80001908:	03348463          	beq	s1,s3,80001930 <wait+0xe6>
      if(pp->parent == p){
    8000190c:	7c9c                	ld	a5,56(s1)
    8000190e:	ff279be3          	bne	a5,s2,80001904 <wait+0xba>
        acquire(&pp->lock);
    80001912:	8526                	mv	a0,s1
    80001914:	00005097          	auipc	ra,0x5
    80001918:	ab0080e7          	jalr	-1360(ra) # 800063c4 <acquire>
        if(pp->state == ZOMBIE){
    8000191c:	4c9c                	lw	a5,24(s1)
    8000191e:	f94781e3          	beq	a5,s4,800018a0 <wait+0x56>
        release(&pp->lock);
    80001922:	8526                	mv	a0,s1
    80001924:	00005097          	auipc	ra,0x5
    80001928:	b54080e7          	jalr	-1196(ra) # 80006478 <release>
        havekids = 1;
    8000192c:	8756                	mv	a4,s5
    8000192e:	bfd9                	j	80001904 <wait+0xba>
    if(!havekids || killed(p)){
    80001930:	c719                	beqz	a4,8000193e <wait+0xf4>
    80001932:	854a                	mv	a0,s2
    80001934:	00000097          	auipc	ra,0x0
    80001938:	ee4080e7          	jalr	-284(ra) # 80001818 <killed>
    8000193c:	c51d                	beqz	a0,8000196a <wait+0x120>
      release(&wait_lock);
    8000193e:	00007517          	auipc	a0,0x7
    80001942:	15a50513          	addi	a0,a0,346 # 80008a98 <wait_lock>
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	b32080e7          	jalr	-1230(ra) # 80006478 <release>
      return -1;
    8000194e:	59fd                	li	s3,-1
}
    80001950:	854e                	mv	a0,s3
    80001952:	60a6                	ld	ra,72(sp)
    80001954:	6406                	ld	s0,64(sp)
    80001956:	74e2                	ld	s1,56(sp)
    80001958:	7942                	ld	s2,48(sp)
    8000195a:	79a2                	ld	s3,40(sp)
    8000195c:	7a02                	ld	s4,32(sp)
    8000195e:	6ae2                	ld	s5,24(sp)
    80001960:	6b42                	ld	s6,16(sp)
    80001962:	6ba2                	ld	s7,8(sp)
    80001964:	6c02                	ld	s8,0(sp)
    80001966:	6161                	addi	sp,sp,80
    80001968:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000196a:	85e2                	mv	a1,s8
    8000196c:	854a                	mv	a0,s2
    8000196e:	00000097          	auipc	ra,0x0
    80001972:	c00080e7          	jalr	-1024(ra) # 8000156e <sleep>
    havekids = 0;
    80001976:	bf39                	j	80001894 <wait+0x4a>

0000000080001978 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001978:	7179                	addi	sp,sp,-48
    8000197a:	f406                	sd	ra,40(sp)
    8000197c:	f022                	sd	s0,32(sp)
    8000197e:	ec26                	sd	s1,24(sp)
    80001980:	e84a                	sd	s2,16(sp)
    80001982:	e44e                	sd	s3,8(sp)
    80001984:	e052                	sd	s4,0(sp)
    80001986:	1800                	addi	s0,sp,48
    80001988:	84aa                	mv	s1,a0
    8000198a:	892e                	mv	s2,a1
    8000198c:	89b2                	mv	s3,a2
    8000198e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	52e080e7          	jalr	1326(ra) # 80000ebe <myproc>
  if(user_dst){
    80001998:	c08d                	beqz	s1,800019ba <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000199a:	86d2                	mv	a3,s4
    8000199c:	864e                	mv	a2,s3
    8000199e:	85ca                	mv	a1,s2
    800019a0:	6928                	ld	a0,80(a0)
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	1c2080e7          	jalr	450(ra) # 80000b64 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019aa:	70a2                	ld	ra,40(sp)
    800019ac:	7402                	ld	s0,32(sp)
    800019ae:	64e2                	ld	s1,24(sp)
    800019b0:	6942                	ld	s2,16(sp)
    800019b2:	69a2                	ld	s3,8(sp)
    800019b4:	6a02                	ld	s4,0(sp)
    800019b6:	6145                	addi	sp,sp,48
    800019b8:	8082                	ret
    memmove((char *)dst, src, len);
    800019ba:	000a061b          	sext.w	a2,s4
    800019be:	85ce                	mv	a1,s3
    800019c0:	854a                	mv	a0,s2
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	84e080e7          	jalr	-1970(ra) # 80000210 <memmove>
    return 0;
    800019ca:	8526                	mv	a0,s1
    800019cc:	bff9                	j	800019aa <either_copyout+0x32>

00000000800019ce <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019ce:	7179                	addi	sp,sp,-48
    800019d0:	f406                	sd	ra,40(sp)
    800019d2:	f022                	sd	s0,32(sp)
    800019d4:	ec26                	sd	s1,24(sp)
    800019d6:	e84a                	sd	s2,16(sp)
    800019d8:	e44e                	sd	s3,8(sp)
    800019da:	e052                	sd	s4,0(sp)
    800019dc:	1800                	addi	s0,sp,48
    800019de:	892a                	mv	s2,a0
    800019e0:	84ae                	mv	s1,a1
    800019e2:	89b2                	mv	s3,a2
    800019e4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	4d8080e7          	jalr	1240(ra) # 80000ebe <myproc>
  if(user_src){
    800019ee:	c08d                	beqz	s1,80001a10 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019f0:	86d2                	mv	a3,s4
    800019f2:	864e                	mv	a2,s3
    800019f4:	85ca                	mv	a1,s2
    800019f6:	6928                	ld	a0,80(a0)
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	1f8080e7          	jalr	504(ra) # 80000bf0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a00:	70a2                	ld	ra,40(sp)
    80001a02:	7402                	ld	s0,32(sp)
    80001a04:	64e2                	ld	s1,24(sp)
    80001a06:	6942                	ld	s2,16(sp)
    80001a08:	69a2                	ld	s3,8(sp)
    80001a0a:	6a02                	ld	s4,0(sp)
    80001a0c:	6145                	addi	sp,sp,48
    80001a0e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a10:	000a061b          	sext.w	a2,s4
    80001a14:	85ce                	mv	a1,s3
    80001a16:	854a                	mv	a0,s2
    80001a18:	ffffe097          	auipc	ra,0xffffe
    80001a1c:	7f8080e7          	jalr	2040(ra) # 80000210 <memmove>
    return 0;
    80001a20:	8526                	mv	a0,s1
    80001a22:	bff9                	j	80001a00 <either_copyin+0x32>

0000000080001a24 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a24:	715d                	addi	sp,sp,-80
    80001a26:	e486                	sd	ra,72(sp)
    80001a28:	e0a2                	sd	s0,64(sp)
    80001a2a:	fc26                	sd	s1,56(sp)
    80001a2c:	f84a                	sd	s2,48(sp)
    80001a2e:	f44e                	sd	s3,40(sp)
    80001a30:	f052                	sd	s4,32(sp)
    80001a32:	ec56                	sd	s5,24(sp)
    80001a34:	e85a                	sd	s6,16(sp)
    80001a36:	e45e                	sd	s7,8(sp)
    80001a38:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a3a:	00006517          	auipc	a0,0x6
    80001a3e:	60e50513          	addi	a0,a0,1550 # 80008048 <etext+0x48>
    80001a42:	00004097          	auipc	ra,0x4
    80001a46:	460080e7          	jalr	1120(ra) # 80005ea2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a4a:	00007497          	auipc	s1,0x7
    80001a4e:	5be48493          	addi	s1,s1,1470 # 80009008 <proc+0x158>
    80001a52:	0000d917          	auipc	s2,0xd
    80001a56:	1b690913          	addi	s2,s2,438 # 8000ec08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a5c:	00006997          	auipc	s3,0x6
    80001a60:	7d498993          	addi	s3,s3,2004 # 80008230 <states.1745+0xd8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a64:	00006a97          	auipc	s5,0x6
    80001a68:	7d4a8a93          	addi	s5,s5,2004 # 80008238 <states.1745+0xe0>
    printf("\n");
    80001a6c:	00006a17          	auipc	s4,0x6
    80001a70:	5dca0a13          	addi	s4,s4,1500 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a74:	00006b97          	auipc	s7,0x6
    80001a78:	6e4b8b93          	addi	s7,s7,1764 # 80008158 <states.1745>
    80001a7c:	a015                	j	80001aa0 <procdump+0x7c>
    printf("%d %s %s", p->pid, state, p->name);
    80001a7e:	86ba                	mv	a3,a4
    80001a80:	ed872583          	lw	a1,-296(a4)
    80001a84:	8556                	mv	a0,s5
    80001a86:	00004097          	auipc	ra,0x4
    80001a8a:	41c080e7          	jalr	1052(ra) # 80005ea2 <printf>
    printf("\n");
    80001a8e:	8552                	mv	a0,s4
    80001a90:	00004097          	auipc	ra,0x4
    80001a94:	412080e7          	jalr	1042(ra) # 80005ea2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a98:	17048493          	addi	s1,s1,368
    80001a9c:	03248163          	beq	s1,s2,80001abe <procdump+0x9a>
    if(p->state == UNUSED)
    80001aa0:	8726                	mv	a4,s1
    80001aa2:	ec04a783          	lw	a5,-320(s1)
    80001aa6:	dbed                	beqz	a5,80001a98 <procdump+0x74>
      state = "???";
    80001aa8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aaa:	fcfb6ae3          	bltu	s6,a5,80001a7e <procdump+0x5a>
    80001aae:	1782                	slli	a5,a5,0x20
    80001ab0:	9381                	srli	a5,a5,0x20
    80001ab2:	078e                	slli	a5,a5,0x3
    80001ab4:	97de                	add	a5,a5,s7
    80001ab6:	6390                	ld	a2,0(a5)
    80001ab8:	f279                	bnez	a2,80001a7e <procdump+0x5a>
      state = "???";
    80001aba:	864e                	mv	a2,s3
    80001abc:	b7c9                	j	80001a7e <procdump+0x5a>
  }
}
    80001abe:	60a6                	ld	ra,72(sp)
    80001ac0:	6406                	ld	s0,64(sp)
    80001ac2:	74e2                	ld	s1,56(sp)
    80001ac4:	7942                	ld	s2,48(sp)
    80001ac6:	79a2                	ld	s3,40(sp)
    80001ac8:	7a02                	ld	s4,32(sp)
    80001aca:	6ae2                	ld	s5,24(sp)
    80001acc:	6b42                	ld	s6,16(sp)
    80001ace:	6ba2                	ld	s7,8(sp)
    80001ad0:	6161                	addi	sp,sp,80
    80001ad2:	8082                	ret

0000000080001ad4 <getnproc>:

// return number of   
int getnproc(){
    80001ad4:	1141                	addi	sp,sp,-16
    80001ad6:	e422                	sd	s0,8(sp)
    80001ad8:	0800                	addi	s0,sp,16
  uint64 size = 0;
    struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ada:	00007797          	auipc	a5,0x7
    80001ade:	3d678793          	addi	a5,a5,982 # 80008eb0 <proc>
  uint64 size = 0;
    80001ae2:	4501                	li	a0,0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ae4:	0000d697          	auipc	a3,0xd
    80001ae8:	fcc68693          	addi	a3,a3,-52 # 8000eab0 <tickslock>
    if(p->state!=UNUSED){
    80001aec:	4f98                	lw	a4,24(a5)
      size++;
    80001aee:	00e03733          	snez	a4,a4
    80001af2:	953a                	add	a0,a0,a4
  for(p = proc; p < &proc[NPROC]; p++) {
    80001af4:	17078793          	addi	a5,a5,368
    80001af8:	fed79ae3          	bne	a5,a3,80001aec <getnproc+0x18>
    }
  }
  return size;
    80001afc:	2501                	sext.w	a0,a0
    80001afe:	6422                	ld	s0,8(sp)
    80001b00:	0141                	addi	sp,sp,16
    80001b02:	8082                	ret

0000000080001b04 <swtch>:
    80001b04:	00153023          	sd	ra,0(a0)
    80001b08:	00253423          	sd	sp,8(a0)
    80001b0c:	e900                	sd	s0,16(a0)
    80001b0e:	ed04                	sd	s1,24(a0)
    80001b10:	03253023          	sd	s2,32(a0)
    80001b14:	03353423          	sd	s3,40(a0)
    80001b18:	03453823          	sd	s4,48(a0)
    80001b1c:	03553c23          	sd	s5,56(a0)
    80001b20:	05653023          	sd	s6,64(a0)
    80001b24:	05753423          	sd	s7,72(a0)
    80001b28:	05853823          	sd	s8,80(a0)
    80001b2c:	05953c23          	sd	s9,88(a0)
    80001b30:	07a53023          	sd	s10,96(a0)
    80001b34:	07b53423          	sd	s11,104(a0)
    80001b38:	0005b083          	ld	ra,0(a1)
    80001b3c:	0085b103          	ld	sp,8(a1)
    80001b40:	6980                	ld	s0,16(a1)
    80001b42:	6d84                	ld	s1,24(a1)
    80001b44:	0205b903          	ld	s2,32(a1)
    80001b48:	0285b983          	ld	s3,40(a1)
    80001b4c:	0305ba03          	ld	s4,48(a1)
    80001b50:	0385ba83          	ld	s5,56(a1)
    80001b54:	0405bb03          	ld	s6,64(a1)
    80001b58:	0485bb83          	ld	s7,72(a1)
    80001b5c:	0505bc03          	ld	s8,80(a1)
    80001b60:	0585bc83          	ld	s9,88(a1)
    80001b64:	0605bd03          	ld	s10,96(a1)
    80001b68:	0685bd83          	ld	s11,104(a1)
    80001b6c:	8082                	ret

0000000080001b6e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b6e:	1141                	addi	sp,sp,-16
    80001b70:	e406                	sd	ra,8(sp)
    80001b72:	e022                	sd	s0,0(sp)
    80001b74:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b76:	00006597          	auipc	a1,0x6
    80001b7a:	70258593          	addi	a1,a1,1794 # 80008278 <states.1745+0x120>
    80001b7e:	0000d517          	auipc	a0,0xd
    80001b82:	f3250513          	addi	a0,a0,-206 # 8000eab0 <tickslock>
    80001b86:	00004097          	auipc	ra,0x4
    80001b8a:	7ae080e7          	jalr	1966(ra) # 80006334 <initlock>
}
    80001b8e:	60a2                	ld	ra,8(sp)
    80001b90:	6402                	ld	s0,0(sp)
    80001b92:	0141                	addi	sp,sp,16
    80001b94:	8082                	ret

0000000080001b96 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b96:	1141                	addi	sp,sp,-16
    80001b98:	e422                	sd	s0,8(sp)
    80001b9a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9c:	00003797          	auipc	a5,0x3
    80001ba0:	65478793          	addi	a5,a5,1620 # 800051f0 <kernelvec>
    80001ba4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ba8:	6422                	ld	s0,8(sp)
    80001baa:	0141                	addi	sp,sp,16
    80001bac:	8082                	ret

0000000080001bae <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bae:	1141                	addi	sp,sp,-16
    80001bb0:	e406                	sd	ra,8(sp)
    80001bb2:	e022                	sd	s0,0(sp)
    80001bb4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	308080e7          	jalr	776(ra) # 80000ebe <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bc2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bc8:	00005617          	auipc	a2,0x5
    80001bcc:	43860613          	addi	a2,a2,1080 # 80007000 <_trampoline>
    80001bd0:	00005697          	auipc	a3,0x5
    80001bd4:	43068693          	addi	a3,a3,1072 # 80007000 <_trampoline>
    80001bd8:	8e91                	sub	a3,a3,a2
    80001bda:	040007b7          	lui	a5,0x4000
    80001bde:	17fd                	addi	a5,a5,-1
    80001be0:	07b2                	slli	a5,a5,0xc
    80001be2:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001be4:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001be8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bea:	180026f3          	csrr	a3,satp
    80001bee:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bf0:	6d38                	ld	a4,88(a0)
    80001bf2:	6134                	ld	a3,64(a0)
    80001bf4:	6585                	lui	a1,0x1
    80001bf6:	96ae                	add	a3,a3,a1
    80001bf8:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bfa:	6d38                	ld	a4,88(a0)
    80001bfc:	00000697          	auipc	a3,0x0
    80001c00:	13068693          	addi	a3,a3,304 # 80001d2c <usertrap>
    80001c04:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c06:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c08:	8692                	mv	a3,tp
    80001c0a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c0c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c10:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c14:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c18:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c1c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c1e:	6f18                	ld	a4,24(a4)
    80001c20:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c24:	6928                	ld	a0,80(a0)
    80001c26:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c28:	00005717          	auipc	a4,0x5
    80001c2c:	47870713          	addi	a4,a4,1144 # 800070a0 <userret>
    80001c30:	8f11                	sub	a4,a4,a2
    80001c32:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c34:	577d                	li	a4,-1
    80001c36:	177e                	slli	a4,a4,0x3f
    80001c38:	8d59                	or	a0,a0,a4
    80001c3a:	9782                	jalr	a5
}
    80001c3c:	60a2                	ld	ra,8(sp)
    80001c3e:	6402                	ld	s0,0(sp)
    80001c40:	0141                	addi	sp,sp,16
    80001c42:	8082                	ret

0000000080001c44 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c44:	1101                	addi	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c4e:	0000d497          	auipc	s1,0xd
    80001c52:	e6248493          	addi	s1,s1,-414 # 8000eab0 <tickslock>
    80001c56:	8526                	mv	a0,s1
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	76c080e7          	jalr	1900(ra) # 800063c4 <acquire>
  ticks++;
    80001c60:	00007517          	auipc	a0,0x7
    80001c64:	de850513          	addi	a0,a0,-536 # 80008a48 <ticks>
    80001c68:	411c                	lw	a5,0(a0)
    80001c6a:	2785                	addiw	a5,a5,1
    80001c6c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	964080e7          	jalr	-1692(ra) # 800015d2 <wakeup>
  release(&tickslock);
    80001c76:	8526                	mv	a0,s1
    80001c78:	00005097          	auipc	ra,0x5
    80001c7c:	800080e7          	jalr	-2048(ra) # 80006478 <release>
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6105                	addi	sp,sp,32
    80001c88:	8082                	ret

0000000080001c8a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c94:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c98:	00074d63          	bltz	a4,80001cb2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c9c:	57fd                	li	a5,-1
    80001c9e:	17fe                	slli	a5,a5,0x3f
    80001ca0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ca2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ca4:	06f70363          	beq	a4,a5,80001d0a <devintr+0x80>
  }
}
    80001ca8:	60e2                	ld	ra,24(sp)
    80001caa:	6442                	ld	s0,16(sp)
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret
     (scause & 0xff) == 9){
    80001cb2:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cb6:	46a5                	li	a3,9
    80001cb8:	fed792e3          	bne	a5,a3,80001c9c <devintr+0x12>
    int irq = plic_claim();
    80001cbc:	00003097          	auipc	ra,0x3
    80001cc0:	63c080e7          	jalr	1596(ra) # 800052f8 <plic_claim>
    80001cc4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cc6:	47a9                	li	a5,10
    80001cc8:	02f50763          	beq	a0,a5,80001cf6 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ccc:	4785                	li	a5,1
    80001cce:	02f50963          	beq	a0,a5,80001d00 <devintr+0x76>
    return 1;
    80001cd2:	4505                	li	a0,1
    } else if(irq){
    80001cd4:	d8f1                	beqz	s1,80001ca8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cd6:	85a6                	mv	a1,s1
    80001cd8:	00006517          	auipc	a0,0x6
    80001cdc:	5a850513          	addi	a0,a0,1448 # 80008280 <states.1745+0x128>
    80001ce0:	00004097          	auipc	ra,0x4
    80001ce4:	1c2080e7          	jalr	450(ra) # 80005ea2 <printf>
      plic_complete(irq);
    80001ce8:	8526                	mv	a0,s1
    80001cea:	00003097          	auipc	ra,0x3
    80001cee:	632080e7          	jalr	1586(ra) # 8000531c <plic_complete>
    return 1;
    80001cf2:	4505                	li	a0,1
    80001cf4:	bf55                	j	80001ca8 <devintr+0x1e>
      uartintr();
    80001cf6:	00004097          	auipc	ra,0x4
    80001cfa:	5ee080e7          	jalr	1518(ra) # 800062e4 <uartintr>
    80001cfe:	b7ed                	j	80001ce8 <devintr+0x5e>
      virtio_disk_intr();
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	b54080e7          	jalr	-1196(ra) # 80005854 <virtio_disk_intr>
    80001d08:	b7c5                	j	80001ce8 <devintr+0x5e>
    if(cpuid() == 0){
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	188080e7          	jalr	392(ra) # 80000e92 <cpuid>
    80001d12:	c901                	beqz	a0,80001d22 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d14:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d1a:	14479073          	csrw	sip,a5
    return 2;
    80001d1e:	4509                	li	a0,2
    80001d20:	b761                	j	80001ca8 <devintr+0x1e>
      clockintr();
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	f22080e7          	jalr	-222(ra) # 80001c44 <clockintr>
    80001d2a:	b7ed                	j	80001d14 <devintr+0x8a>

0000000080001d2c <usertrap>:
{
    80001d2c:	1101                	addi	sp,sp,-32
    80001d2e:	ec06                	sd	ra,24(sp)
    80001d30:	e822                	sd	s0,16(sp)
    80001d32:	e426                	sd	s1,8(sp)
    80001d34:	e04a                	sd	s2,0(sp)
    80001d36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d3c:	1007f793          	andi	a5,a5,256
    80001d40:	e3b1                	bnez	a5,80001d84 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d42:	00003797          	auipc	a5,0x3
    80001d46:	4ae78793          	addi	a5,a5,1198 # 800051f0 <kernelvec>
    80001d4a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	170080e7          	jalr	368(ra) # 80000ebe <myproc>
    80001d56:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d58:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d5a:	14102773          	csrr	a4,sepc
    80001d5e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d60:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d64:	47a1                	li	a5,8
    80001d66:	02f70763          	beq	a4,a5,80001d94 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	f20080e7          	jalr	-224(ra) # 80001c8a <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c151                	beqz	a0,80001df8 <usertrap+0xcc>
  if(killed(p))
    80001d76:	8526                	mv	a0,s1
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	aa0080e7          	jalr	-1376(ra) # 80001818 <killed>
    80001d80:	c929                	beqz	a0,80001dd2 <usertrap+0xa6>
    80001d82:	a099                	j	80001dc8 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	51c50513          	addi	a0,a0,1308 # 800082a0 <states.1745+0x148>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	0cc080e7          	jalr	204(ra) # 80005e58 <panic>
    if(killed(p))
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	a84080e7          	jalr	-1404(ra) # 80001818 <killed>
    80001d9c:	e921                	bnez	a0,80001dec <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d9e:	6cb8                	ld	a4,88(s1)
    80001da0:	6f1c                	ld	a5,24(a4)
    80001da2:	0791                	addi	a5,a5,4
    80001da4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001daa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dae:	10079073          	csrw	sstatus,a5
    syscall();
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	2da080e7          	jalr	730(ra) # 8000208c <syscall>
  if(killed(p))
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	a5c080e7          	jalr	-1444(ra) # 80001818 <killed>
    80001dc4:	c911                	beqz	a0,80001dd8 <usertrap+0xac>
    80001dc6:	4901                	li	s2,0
    exit(-1);
    80001dc8:	557d                	li	a0,-1
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	8d8080e7          	jalr	-1832(ra) # 800016a2 <exit>
  if(which_dev == 2)
    80001dd2:	4789                	li	a5,2
    80001dd4:	04f90f63          	beq	s2,a5,80001e32 <usertrap+0x106>
  usertrapret();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	dd6080e7          	jalr	-554(ra) # 80001bae <usertrapret>
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6902                	ld	s2,0(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret
      exit(-1);
    80001dec:	557d                	li	a0,-1
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	8b4080e7          	jalr	-1868(ra) # 800016a2 <exit>
    80001df6:	b765                	j	80001d9e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dfc:	5890                	lw	a2,48(s1)
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	4c250513          	addi	a0,a0,1218 # 800082c0 <states.1745+0x168>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	09c080e7          	jalr	156(ra) # 80005ea2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e12:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	4da50513          	addi	a0,a0,1242 # 800082f0 <states.1745+0x198>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	084080e7          	jalr	132(ra) # 80005ea2 <printf>
    setkilled(p);
    80001e26:	8526                	mv	a0,s1
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	9c4080e7          	jalr	-1596(ra) # 800017ec <setkilled>
    80001e30:	b769                	j	80001dba <usertrap+0x8e>
    yield();
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	700080e7          	jalr	1792(ra) # 80001532 <yield>
    80001e3a:	bf79                	j	80001dd8 <usertrap+0xac>

0000000080001e3c <kerneltrap>:
{
    80001e3c:	7179                	addi	sp,sp,-48
    80001e3e:	f406                	sd	ra,40(sp)
    80001e40:	f022                	sd	s0,32(sp)
    80001e42:	ec26                	sd	s1,24(sp)
    80001e44:	e84a                	sd	s2,16(sp)
    80001e46:	e44e                	sd	s3,8(sp)
    80001e48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e52:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e56:	1004f793          	andi	a5,s1,256
    80001e5a:	cb85                	beqz	a5,80001e8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e60:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e62:	ef85                	bnez	a5,80001e9a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e26080e7          	jalr	-474(ra) # 80001c8a <devintr>
    80001e6c:	cd1d                	beqz	a0,80001eaa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e6e:	4789                	li	a5,2
    80001e70:	06f50a63          	beq	a0,a5,80001ee4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e78:	10049073          	csrw	sstatus,s1
}
    80001e7c:	70a2                	ld	ra,40(sp)
    80001e7e:	7402                	ld	s0,32(sp)
    80001e80:	64e2                	ld	s1,24(sp)
    80001e82:	6942                	ld	s2,16(sp)
    80001e84:	69a2                	ld	s3,8(sp)
    80001e86:	6145                	addi	sp,sp,48
    80001e88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	48650513          	addi	a0,a0,1158 # 80008310 <states.1745+0x1b8>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	fc6080e7          	jalr	-58(ra) # 80005e58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	49e50513          	addi	a0,a0,1182 # 80008338 <states.1745+0x1e0>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	fb6080e7          	jalr	-74(ra) # 80005e58 <panic>
    printf("scause %p\n", scause);
    80001eaa:	85ce                	mv	a1,s3
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	4ac50513          	addi	a0,a0,1196 # 80008358 <states.1745+0x200>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	fee080e7          	jalr	-18(ra) # 80005ea2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ebc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	4a450513          	addi	a0,a0,1188 # 80008368 <states.1745+0x210>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	fd6080e7          	jalr	-42(ra) # 80005ea2 <printf>
    panic("kerneltrap");
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	4ac50513          	addi	a0,a0,1196 # 80008380 <states.1745+0x228>
    80001edc:	00004097          	auipc	ra,0x4
    80001ee0:	f7c080e7          	jalr	-132(ra) # 80005e58 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	fda080e7          	jalr	-38(ra) # 80000ebe <myproc>
    80001eec:	d541                	beqz	a0,80001e74 <kerneltrap+0x38>
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	fd0080e7          	jalr	-48(ra) # 80000ebe <myproc>
    80001ef6:	4d18                	lw	a4,24(a0)
    80001ef8:	4791                	li	a5,4
    80001efa:	f6f71de3          	bne	a4,a5,80001e74 <kerneltrap+0x38>
    yield();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	634080e7          	jalr	1588(ra) # 80001532 <yield>
    80001f06:	b7bd                	j	80001e74 <kerneltrap+0x38>

0000000080001f08 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f08:	1101                	addi	sp,sp,-32
    80001f0a:	ec06                	sd	ra,24(sp)
    80001f0c:	e822                	sd	s0,16(sp)
    80001f0e:	e426                	sd	s1,8(sp)
    80001f10:	1000                	addi	s0,sp,32
    80001f12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	faa080e7          	jalr	-86(ra) # 80000ebe <myproc>
  switch (n) {
    80001f1c:	4795                	li	a5,5
    80001f1e:	0497e363          	bltu	a5,s1,80001f64 <argraw+0x5c>
    80001f22:	1482                	slli	s1,s1,0x20
    80001f24:	9081                	srli	s1,s1,0x20
    80001f26:	048a                	slli	s1,s1,0x2
    80001f28:	00006717          	auipc	a4,0x6
    80001f2c:	46870713          	addi	a4,a4,1128 # 80008390 <states.1745+0x238>
    80001f30:	94ba                	add	s1,s1,a4
    80001f32:	409c                	lw	a5,0(s1)
    80001f34:	97ba                	add	a5,a5,a4
    80001f36:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f38:	6d3c                	ld	a5,88(a0)
    80001f3a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret
    return p->trapframe->a1;
    80001f46:	6d3c                	ld	a5,88(a0)
    80001f48:	7fa8                	ld	a0,120(a5)
    80001f4a:	bfcd                	j	80001f3c <argraw+0x34>
    return p->trapframe->a2;
    80001f4c:	6d3c                	ld	a5,88(a0)
    80001f4e:	63c8                	ld	a0,128(a5)
    80001f50:	b7f5                	j	80001f3c <argraw+0x34>
    return p->trapframe->a3;
    80001f52:	6d3c                	ld	a5,88(a0)
    80001f54:	67c8                	ld	a0,136(a5)
    80001f56:	b7dd                	j	80001f3c <argraw+0x34>
    return p->trapframe->a4;
    80001f58:	6d3c                	ld	a5,88(a0)
    80001f5a:	6bc8                	ld	a0,144(a5)
    80001f5c:	b7c5                	j	80001f3c <argraw+0x34>
    return p->trapframe->a5;
    80001f5e:	6d3c                	ld	a5,88(a0)
    80001f60:	6fc8                	ld	a0,152(a5)
    80001f62:	bfe9                	j	80001f3c <argraw+0x34>
  panic("argraw");
    80001f64:	00006517          	auipc	a0,0x6
    80001f68:	5bc50513          	addi	a0,a0,1468 # 80008520 <syscall_name_list+0xb8>
    80001f6c:	00004097          	auipc	ra,0x4
    80001f70:	eec080e7          	jalr	-276(ra) # 80005e58 <panic>

0000000080001f74 <fetchaddr>:
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	e04a                	sd	s2,0(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84aa                	mv	s1,a0
    80001f82:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	f3a080e7          	jalr	-198(ra) # 80000ebe <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f8c:	653c                	ld	a5,72(a0)
    80001f8e:	02f4f963          	bleu	a5,s1,80001fc0 <fetchaddr+0x4c>
    80001f92:	00848713          	addi	a4,s1,8
    80001f96:	02e7e763          	bltu	a5,a4,80001fc4 <fetchaddr+0x50>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f9a:	46a1                	li	a3,8
    80001f9c:	8626                	mv	a2,s1
    80001f9e:	85ca                	mv	a1,s2
    80001fa0:	6928                	ld	a0,80(a0)
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	c4e080e7          	jalr	-946(ra) # 80000bf0 <copyin>
    80001faa:	00a03533          	snez	a0,a0
    80001fae:	40a0053b          	negw	a0,a0
    80001fb2:	2501                	sext.w	a0,a0
}
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	64a2                	ld	s1,8(sp)
    80001fba:	6902                	ld	s2,0(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret
    return -1;
    80001fc0:	557d                	li	a0,-1
    80001fc2:	bfcd                	j	80001fb4 <fetchaddr+0x40>
    80001fc4:	557d                	li	a0,-1
    80001fc6:	b7fd                	j	80001fb4 <fetchaddr+0x40>

0000000080001fc8 <fetchstr>:
{
    80001fc8:	7179                	addi	sp,sp,-48
    80001fca:	f406                	sd	ra,40(sp)
    80001fcc:	f022                	sd	s0,32(sp)
    80001fce:	ec26                	sd	s1,24(sp)
    80001fd0:	e84a                	sd	s2,16(sp)
    80001fd2:	e44e                	sd	s3,8(sp)
    80001fd4:	1800                	addi	s0,sp,48
    80001fd6:	892a                	mv	s2,a0
    80001fd8:	84ae                	mv	s1,a1
    80001fda:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	ee2080e7          	jalr	-286(ra) # 80000ebe <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fe4:	86ce                	mv	a3,s3
    80001fe6:	864a                	mv	a2,s2
    80001fe8:	85a6                	mv	a1,s1
    80001fea:	6928                	ld	a0,80(a0)
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	c92080e7          	jalr	-878(ra) # 80000c7e <copyinstr>
    80001ff4:	00054e63          	bltz	a0,80002010 <fetchstr+0x48>
  return strlen(buf);
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	ffffe097          	auipc	ra,0xffffe
    80001ffe:	350080e7          	jalr	848(ra) # 8000034a <strlen>
}
    80002002:	70a2                	ld	ra,40(sp)
    80002004:	7402                	ld	s0,32(sp)
    80002006:	64e2                	ld	s1,24(sp)
    80002008:	6942                	ld	s2,16(sp)
    8000200a:	69a2                	ld	s3,8(sp)
    8000200c:	6145                	addi	sp,sp,48
    8000200e:	8082                	ret
    return -1;
    80002010:	557d                	li	a0,-1
    80002012:	bfc5                	j	80002002 <fetchstr+0x3a>

0000000080002014 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002014:	1101                	addi	sp,sp,-32
    80002016:	ec06                	sd	ra,24(sp)
    80002018:	e822                	sd	s0,16(sp)
    8000201a:	e426                	sd	s1,8(sp)
    8000201c:	1000                	addi	s0,sp,32
    8000201e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002020:	00000097          	auipc	ra,0x0
    80002024:	ee8080e7          	jalr	-280(ra) # 80001f08 <argraw>
    80002028:	c088                	sw	a0,0(s1)
}
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	64a2                	ld	s1,8(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret

0000000080002034 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	1000                	addi	s0,sp,32
    8000203e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002040:	00000097          	auipc	ra,0x0
    80002044:	ec8080e7          	jalr	-312(ra) # 80001f08 <argraw>
    80002048:	e088                	sd	a0,0(s1)
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret

0000000080002054 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	1800                	addi	s0,sp,48
    80002060:	84ae                	mv	s1,a1
    80002062:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002064:	fd840593          	addi	a1,s0,-40
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	fcc080e7          	jalr	-52(ra) # 80002034 <argaddr>
  return fetchstr(addr, buf, max);
    80002070:	864a                	mv	a2,s2
    80002072:	85a6                	mv	a1,s1
    80002074:	fd843503          	ld	a0,-40(s0)
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	f50080e7          	jalr	-176(ra) # 80001fc8 <fetchstr>
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	6145                	addi	sp,sp,48
    8000208a:	8082                	ret

000000008000208c <syscall>:
"trace"
};

void
syscall(void)
{
    8000208c:	7179                	addi	sp,sp,-48
    8000208e:	f406                	sd	ra,40(sp)
    80002090:	f022                	sd	s0,32(sp)
    80002092:	ec26                	sd	s1,24(sp)
    80002094:	e84a                	sd	s2,16(sp)
    80002096:	e44e                	sd	s3,8(sp)
    80002098:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	e24080e7          	jalr	-476(ra) # 80000ebe <myproc>
    800020a2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020a4:	05853983          	ld	s3,88(a0)
    800020a8:	0a89b783          	ld	a5,168(s3)
    800020ac:	0007891b          	sext.w	s2,a5
  // num = * (int *) 0;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020b0:	37fd                	addiw	a5,a5,-1
    800020b2:	4759                	li	a4,22
    800020b4:	04f76963          	bltu	a4,a5,80002106 <syscall+0x7a>
    800020b8:	00391713          	slli	a4,s2,0x3
    800020bc:	00006797          	auipc	a5,0x6
    800020c0:	2ec78793          	addi	a5,a5,748 # 800083a8 <syscalls>
    800020c4:	97ba                	add	a5,a5,a4
    800020c6:	639c                	ld	a5,0(a5)
    800020c8:	cf9d                	beqz	a5,80002106 <syscall+0x7a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020ca:	9782                	jalr	a5
    800020cc:	06a9b823          	sd	a0,112(s3)

    if(((1<<num) & p->syscallnummask) != 0){
    800020d0:	4785                	li	a5,1
    800020d2:	012797bb          	sllw	a5,a5,s2
    800020d6:	1684b703          	ld	a4,360(s1)
    800020da:	8ff9                	and	a5,a5,a4
    800020dc:	c7a1                	beqz	a5,80002124 <syscall+0x98>
      printf("%d: syscall %s -> %d\n", p->pid, syscall_name_list[num], p->trapframe->a0);
    800020de:	6cb8                	ld	a4,88(s1)
    800020e0:	090e                	slli	s2,s2,0x3
    800020e2:	00006797          	auipc	a5,0x6
    800020e6:	2c678793          	addi	a5,a5,710 # 800083a8 <syscalls>
    800020ea:	993e                	add	s2,s2,a5
    800020ec:	7b34                	ld	a3,112(a4)
    800020ee:	0c093603          	ld	a2,192(s2)
    800020f2:	588c                	lw	a1,48(s1)
    800020f4:	00006517          	auipc	a0,0x6
    800020f8:	43450513          	addi	a0,a0,1076 # 80008528 <syscall_name_list+0xc0>
    800020fc:	00004097          	auipc	ra,0x4
    80002100:	da6080e7          	jalr	-602(ra) # 80005ea2 <printf>
    80002104:	a005                	j	80002124 <syscall+0x98>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002106:	86ca                	mv	a3,s2
    80002108:	15848613          	addi	a2,s1,344
    8000210c:	588c                	lw	a1,48(s1)
    8000210e:	00006517          	auipc	a0,0x6
    80002112:	43250513          	addi	a0,a0,1074 # 80008540 <syscall_name_list+0xd8>
    80002116:	00004097          	auipc	ra,0x4
    8000211a:	d8c080e7          	jalr	-628(ra) # 80005ea2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000211e:	6cbc                	ld	a5,88(s1)
    80002120:	577d                	li	a4,-1
    80002122:	fbb8                	sd	a4,112(a5)
  }
}
    80002124:	70a2                	ld	ra,40(sp)
    80002126:	7402                	ld	s0,32(sp)
    80002128:	64e2                	ld	s1,24(sp)
    8000212a:	6942                	ld	s2,16(sp)
    8000212c:	69a2                	ld	s3,8(sp)
    8000212e:	6145                	addi	sp,sp,48
    80002130:	8082                	ret

0000000080002132 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002132:	1101                	addi	sp,sp,-32
    80002134:	ec06                	sd	ra,24(sp)
    80002136:	e822                	sd	s0,16(sp)
    80002138:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000213a:	fec40593          	addi	a1,s0,-20
    8000213e:	4501                	li	a0,0
    80002140:	00000097          	auipc	ra,0x0
    80002144:	ed4080e7          	jalr	-300(ra) # 80002014 <argint>
  exit(n);
    80002148:	fec42503          	lw	a0,-20(s0)
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	556080e7          	jalr	1366(ra) # 800016a2 <exit>
  return 0;  // not reached
}
    80002154:	4501                	li	a0,0
    80002156:	60e2                	ld	ra,24(sp)
    80002158:	6442                	ld	s0,16(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret

000000008000215e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000215e:	1141                	addi	sp,sp,-16
    80002160:	e406                	sd	ra,8(sp)
    80002162:	e022                	sd	s0,0(sp)
    80002164:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	d58080e7          	jalr	-680(ra) # 80000ebe <myproc>
}
    8000216e:	5908                	lw	a0,48(a0)
    80002170:	60a2                	ld	ra,8(sp)
    80002172:	6402                	ld	s0,0(sp)
    80002174:	0141                	addi	sp,sp,16
    80002176:	8082                	ret

0000000080002178 <sys_fork>:

uint64
sys_fork(void)
{
    80002178:	1141                	addi	sp,sp,-16
    8000217a:	e406                	sd	ra,8(sp)
    8000217c:	e022                	sd	s0,0(sp)
    8000217e:	0800                	addi	s0,sp,16
  return fork();
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	0f6080e7          	jalr	246(ra) # 80001276 <fork>
}
    80002188:	60a2                	ld	ra,8(sp)
    8000218a:	6402                	ld	s0,0(sp)
    8000218c:	0141                	addi	sp,sp,16
    8000218e:	8082                	ret

0000000080002190 <sys_wait>:

uint64
sys_wait(void)
{
    80002190:	1101                	addi	sp,sp,-32
    80002192:	ec06                	sd	ra,24(sp)
    80002194:	e822                	sd	s0,16(sp)
    80002196:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002198:	fe840593          	addi	a1,s0,-24
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e96080e7          	jalr	-362(ra) # 80002034 <argaddr>
  return wait(p);
    800021a6:	fe843503          	ld	a0,-24(s0)
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	6a0080e7          	jalr	1696(ra) # 8000184a <wait>
}
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021ba:	7179                	addi	sp,sp,-48
    800021bc:	f406                	sd	ra,40(sp)
    800021be:	f022                	sd	s0,32(sp)
    800021c0:	ec26                	sd	s1,24(sp)
    800021c2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021c4:	fdc40593          	addi	a1,s0,-36
    800021c8:	4501                	li	a0,0
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	e4a080e7          	jalr	-438(ra) # 80002014 <argint>
  addr = myproc()->sz;
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	cec080e7          	jalr	-788(ra) # 80000ebe <myproc>
    800021da:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021dc:	fdc42503          	lw	a0,-36(s0)
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	03a080e7          	jalr	58(ra) # 8000121a <growproc>
    800021e8:	00054863          	bltz	a0,800021f8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021ec:	8526                	mv	a0,s1
    800021ee:	70a2                	ld	ra,40(sp)
    800021f0:	7402                	ld	s0,32(sp)
    800021f2:	64e2                	ld	s1,24(sp)
    800021f4:	6145                	addi	sp,sp,48
    800021f6:	8082                	ret
    return -1;
    800021f8:	54fd                	li	s1,-1
    800021fa:	bfcd                	j	800021ec <sys_sbrk+0x32>

00000000800021fc <sys_sleep>:

uint64
sys_sleep(void)
{
    800021fc:	7139                	addi	sp,sp,-64
    800021fe:	fc06                	sd	ra,56(sp)
    80002200:	f822                	sd	s0,48(sp)
    80002202:	f426                	sd	s1,40(sp)
    80002204:	f04a                	sd	s2,32(sp)
    80002206:	ec4e                	sd	s3,24(sp)
    80002208:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000220a:	fcc40593          	addi	a1,s0,-52
    8000220e:	4501                	li	a0,0
    80002210:	00000097          	auipc	ra,0x0
    80002214:	e04080e7          	jalr	-508(ra) # 80002014 <argint>
  if(n < 0)
    80002218:	fcc42783          	lw	a5,-52(s0)
    8000221c:	0807c163          	bltz	a5,8000229e <sys_sleep+0xa2>
    n = 0;
  acquire(&tickslock);
    80002220:	0000d517          	auipc	a0,0xd
    80002224:	89050513          	addi	a0,a0,-1904 # 8000eab0 <tickslock>
    80002228:	00004097          	auipc	ra,0x4
    8000222c:	19c080e7          	jalr	412(ra) # 800063c4 <acquire>
  ticks0 = ticks;
    80002230:	00007797          	auipc	a5,0x7
    80002234:	81878793          	addi	a5,a5,-2024 # 80008a48 <ticks>
    80002238:	0007a903          	lw	s2,0(a5)
  while(ticks - ticks0 < n){
    8000223c:	fcc42783          	lw	a5,-52(s0)
    80002240:	cf9d                	beqz	a5,8000227e <sys_sleep+0x82>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002242:	0000d997          	auipc	s3,0xd
    80002246:	86e98993          	addi	s3,s3,-1938 # 8000eab0 <tickslock>
    8000224a:	00006497          	auipc	s1,0x6
    8000224e:	7fe48493          	addi	s1,s1,2046 # 80008a48 <ticks>
    if(killed(myproc())){
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	c6c080e7          	jalr	-916(ra) # 80000ebe <myproc>
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	5be080e7          	jalr	1470(ra) # 80001818 <killed>
    80002262:	e129                	bnez	a0,800022a4 <sys_sleep+0xa8>
    sleep(&ticks, &tickslock);
    80002264:	85ce                	mv	a1,s3
    80002266:	8526                	mv	a0,s1
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	306080e7          	jalr	774(ra) # 8000156e <sleep>
  while(ticks - ticks0 < n){
    80002270:	409c                	lw	a5,0(s1)
    80002272:	412787bb          	subw	a5,a5,s2
    80002276:	fcc42703          	lw	a4,-52(s0)
    8000227a:	fce7ece3          	bltu	a5,a4,80002252 <sys_sleep+0x56>
  }
  release(&tickslock);
    8000227e:	0000d517          	auipc	a0,0xd
    80002282:	83250513          	addi	a0,a0,-1998 # 8000eab0 <tickslock>
    80002286:	00004097          	auipc	ra,0x4
    8000228a:	1f2080e7          	jalr	498(ra) # 80006478 <release>
  return 0;
    8000228e:	4501                	li	a0,0
}
    80002290:	70e2                	ld	ra,56(sp)
    80002292:	7442                	ld	s0,48(sp)
    80002294:	74a2                	ld	s1,40(sp)
    80002296:	7902                	ld	s2,32(sp)
    80002298:	69e2                	ld	s3,24(sp)
    8000229a:	6121                	addi	sp,sp,64
    8000229c:	8082                	ret
    n = 0;
    8000229e:	fc042623          	sw	zero,-52(s0)
    800022a2:	bfbd                	j	80002220 <sys_sleep+0x24>
      release(&tickslock);
    800022a4:	0000d517          	auipc	a0,0xd
    800022a8:	80c50513          	addi	a0,a0,-2036 # 8000eab0 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	1cc080e7          	jalr	460(ra) # 80006478 <release>
      return -1;
    800022b4:	557d                	li	a0,-1
    800022b6:	bfe9                	j	80002290 <sys_sleep+0x94>

00000000800022b8 <sys_kill>:

uint64
sys_kill(void)
{
    800022b8:	1101                	addi	sp,sp,-32
    800022ba:	ec06                	sd	ra,24(sp)
    800022bc:	e822                	sd	s0,16(sp)
    800022be:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022c0:	fec40593          	addi	a1,s0,-20
    800022c4:	4501                	li	a0,0
    800022c6:	00000097          	auipc	ra,0x0
    800022ca:	d4e080e7          	jalr	-690(ra) # 80002014 <argint>
  return kill(pid);
    800022ce:	fec42503          	lw	a0,-20(s0)
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	4a8080e7          	jalr	1192(ra) # 8000177a <kill>
}
    800022da:	60e2                	ld	ra,24(sp)
    800022dc:	6442                	ld	s0,16(sp)
    800022de:	6105                	addi	sp,sp,32
    800022e0:	8082                	ret

00000000800022e2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022e2:	1101                	addi	sp,sp,-32
    800022e4:	ec06                	sd	ra,24(sp)
    800022e6:	e822                	sd	s0,16(sp)
    800022e8:	e426                	sd	s1,8(sp)
    800022ea:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022ec:	0000c517          	auipc	a0,0xc
    800022f0:	7c450513          	addi	a0,a0,1988 # 8000eab0 <tickslock>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	0d0080e7          	jalr	208(ra) # 800063c4 <acquire>
  xticks = ticks;
    800022fc:	00006797          	auipc	a5,0x6
    80002300:	74c78793          	addi	a5,a5,1868 # 80008a48 <ticks>
    80002304:	4384                	lw	s1,0(a5)
  release(&tickslock);
    80002306:	0000c517          	auipc	a0,0xc
    8000230a:	7aa50513          	addi	a0,a0,1962 # 8000eab0 <tickslock>
    8000230e:	00004097          	auipc	ra,0x4
    80002312:	16a080e7          	jalr	362(ra) # 80006478 <release>
  return xticks;
}
    80002316:	02049513          	slli	a0,s1,0x20
    8000231a:	9101                	srli	a0,a0,0x20
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	64a2                	ld	s1,8(sp)
    80002322:	6105                	addi	sp,sp,32
    80002324:	8082                	ret

0000000080002326 <sys_trace>:


uint64
sys_trace(void)
{
    80002326:	1101                	addi	sp,sp,-32
    80002328:	ec06                	sd	ra,24(sp)
    8000232a:	e822                	sd	s0,16(sp)
    8000232c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000232e:	fe840593          	addi	a1,s0,-24
    80002332:	4501                	li	a0,0
    80002334:	00000097          	auipc	ra,0x0
    80002338:	d00080e7          	jalr	-768(ra) # 80002034 <argaddr>
  myproc()->syscallnummask = p;
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	b82080e7          	jalr	-1150(ra) # 80000ebe <myproc>
    80002344:	fe843783          	ld	a5,-24(s0)
    80002348:	16f53423          	sd	a5,360(a0)
  return 0;
}
    8000234c:	4501                	li	a0,0
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	6105                	addi	sp,sp,32
    80002354:	8082                	ret

0000000080002356 <sys_sysinfo>:

uint64 sys_sysinfo(void){
    80002356:	7139                	addi	sp,sp,-64
    80002358:	fc06                	sd	ra,56(sp)
    8000235a:	f822                	sd	s0,48(sp)
    8000235c:	f426                	sd	s1,40(sp)
    8000235e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	b5e080e7          	jalr	-1186(ra) # 80000ebe <myproc>
    80002368:	84aa                	mv	s1,a0
    struct sysinfo info;
    uint64 addr;
    argaddr(0,&addr);
    8000236a:	fc840593          	addi	a1,s0,-56
    8000236e:	4501                	li	a0,0
    80002370:	00000097          	auipc	ra,0x0
    80002374:	cc4080e7          	jalr	-828(ra) # 80002034 <argaddr>
    info.freemem = getFreeMemorySize();
    80002378:	ffffe097          	auipc	ra,0xffffe
    8000237c:	e04080e7          	jalr	-508(ra) # 8000017c <getFreeMemorySize>
    80002380:	fca43823          	sd	a0,-48(s0)
    info.nproc = getnproc();
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	750080e7          	jalr	1872(ra) # 80001ad4 <getnproc>
    8000238c:	fca43c23          	sd	a0,-40(s0)
    if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002390:	46c1                	li	a3,16
    80002392:	fd040613          	addi	a2,s0,-48
    80002396:	fc843583          	ld	a1,-56(s0)
    8000239a:	68a8                	ld	a0,80(s1)
    8000239c:	ffffe097          	auipc	ra,0xffffe
    800023a0:	7c8080e7          	jalr	1992(ra) # 80000b64 <copyout>
      return -1;
    return 0;
    800023a4:	957d                	srai	a0,a0,0x3f
    800023a6:	70e2                	ld	ra,56(sp)
    800023a8:	7442                	ld	s0,48(sp)
    800023aa:	74a2                	ld	s1,40(sp)
    800023ac:	6121                	addi	sp,sp,64
    800023ae:	8082                	ret

00000000800023b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023b0:	7179                	addi	sp,sp,-48
    800023b2:	f406                	sd	ra,40(sp)
    800023b4:	f022                	sd	s0,32(sp)
    800023b6:	ec26                	sd	s1,24(sp)
    800023b8:	e84a                	sd	s2,16(sp)
    800023ba:	e44e                	sd	s3,8(sp)
    800023bc:	e052                	sd	s4,0(sp)
    800023be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023c0:	00006597          	auipc	a1,0x6
    800023c4:	24858593          	addi	a1,a1,584 # 80008608 <syscall_name_list+0x1a0>
    800023c8:	0000c517          	auipc	a0,0xc
    800023cc:	70050513          	addi	a0,a0,1792 # 8000eac8 <bcache>
    800023d0:	00004097          	auipc	ra,0x4
    800023d4:	f64080e7          	jalr	-156(ra) # 80006334 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023d8:	00014797          	auipc	a5,0x14
    800023dc:	6f078793          	addi	a5,a5,1776 # 80016ac8 <bcache+0x8000>
    800023e0:	00015717          	auipc	a4,0x15
    800023e4:	95070713          	addi	a4,a4,-1712 # 80016d30 <bcache+0x8268>
    800023e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023f0:	0000c497          	auipc	s1,0xc
    800023f4:	6f048493          	addi	s1,s1,1776 # 8000eae0 <bcache+0x18>
    b->next = bcache.head.next;
    800023f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023fc:	00006a17          	auipc	s4,0x6
    80002400:	214a0a13          	addi	s4,s4,532 # 80008610 <syscall_name_list+0x1a8>
    b->next = bcache.head.next;
    80002404:	2b893783          	ld	a5,696(s2)
    80002408:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000240a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000240e:	85d2                	mv	a1,s4
    80002410:	01048513          	addi	a0,s1,16
    80002414:	00001097          	auipc	ra,0x1
    80002418:	530080e7          	jalr	1328(ra) # 80003944 <initsleeplock>
    bcache.head.next->prev = b;
    8000241c:	2b893783          	ld	a5,696(s2)
    80002420:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002422:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002426:	45848493          	addi	s1,s1,1112
    8000242a:	fd349de3          	bne	s1,s3,80002404 <binit+0x54>
  }
}
    8000242e:	70a2                	ld	ra,40(sp)
    80002430:	7402                	ld	s0,32(sp)
    80002432:	64e2                	ld	s1,24(sp)
    80002434:	6942                	ld	s2,16(sp)
    80002436:	69a2                	ld	s3,8(sp)
    80002438:	6a02                	ld	s4,0(sp)
    8000243a:	6145                	addi	sp,sp,48
    8000243c:	8082                	ret

000000008000243e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000243e:	7179                	addi	sp,sp,-48
    80002440:	f406                	sd	ra,40(sp)
    80002442:	f022                	sd	s0,32(sp)
    80002444:	ec26                	sd	s1,24(sp)
    80002446:	e84a                	sd	s2,16(sp)
    80002448:	e44e                	sd	s3,8(sp)
    8000244a:	1800                	addi	s0,sp,48
    8000244c:	89aa                	mv	s3,a0
    8000244e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002450:	0000c517          	auipc	a0,0xc
    80002454:	67850513          	addi	a0,a0,1656 # 8000eac8 <bcache>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	f6c080e7          	jalr	-148(ra) # 800063c4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002460:	00014797          	auipc	a5,0x14
    80002464:	66878793          	addi	a5,a5,1640 # 80016ac8 <bcache+0x8000>
    80002468:	2b87b483          	ld	s1,696(a5)
    8000246c:	00015797          	auipc	a5,0x15
    80002470:	8c478793          	addi	a5,a5,-1852 # 80016d30 <bcache+0x8268>
    80002474:	02f48f63          	beq	s1,a5,800024b2 <bread+0x74>
    80002478:	873e                	mv	a4,a5
    8000247a:	a021                	j	80002482 <bread+0x44>
    8000247c:	68a4                	ld	s1,80(s1)
    8000247e:	02e48a63          	beq	s1,a4,800024b2 <bread+0x74>
    if(b->dev == dev && b->blockno == blockno){
    80002482:	449c                	lw	a5,8(s1)
    80002484:	ff379ce3          	bne	a5,s3,8000247c <bread+0x3e>
    80002488:	44dc                	lw	a5,12(s1)
    8000248a:	ff2799e3          	bne	a5,s2,8000247c <bread+0x3e>
      b->refcnt++;
    8000248e:	40bc                	lw	a5,64(s1)
    80002490:	2785                	addiw	a5,a5,1
    80002492:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002494:	0000c517          	auipc	a0,0xc
    80002498:	63450513          	addi	a0,a0,1588 # 8000eac8 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	fdc080e7          	jalr	-36(ra) # 80006478 <release>
      acquiresleep(&b->lock);
    800024a4:	01048513          	addi	a0,s1,16
    800024a8:	00001097          	auipc	ra,0x1
    800024ac:	4d6080e7          	jalr	1238(ra) # 8000397e <acquiresleep>
      return b;
    800024b0:	a8b1                	j	8000250c <bread+0xce>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024b2:	00014797          	auipc	a5,0x14
    800024b6:	61678793          	addi	a5,a5,1558 # 80016ac8 <bcache+0x8000>
    800024ba:	2b07b483          	ld	s1,688(a5)
    800024be:	00015797          	auipc	a5,0x15
    800024c2:	87278793          	addi	a5,a5,-1934 # 80016d30 <bcache+0x8268>
    800024c6:	04f48d63          	beq	s1,a5,80002520 <bread+0xe2>
    if(b->refcnt == 0) {
    800024ca:	40bc                	lw	a5,64(s1)
    800024cc:	cb91                	beqz	a5,800024e0 <bread+0xa2>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ce:	00015717          	auipc	a4,0x15
    800024d2:	86270713          	addi	a4,a4,-1950 # 80016d30 <bcache+0x8268>
    800024d6:	64a4                	ld	s1,72(s1)
    800024d8:	04e48463          	beq	s1,a4,80002520 <bread+0xe2>
    if(b->refcnt == 0) {
    800024dc:	40bc                	lw	a5,64(s1)
    800024de:	ffe5                	bnez	a5,800024d6 <bread+0x98>
      b->dev = dev;
    800024e0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024e4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024e8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024ec:	4785                	li	a5,1
    800024ee:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024f0:	0000c517          	auipc	a0,0xc
    800024f4:	5d850513          	addi	a0,a0,1496 # 8000eac8 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	f80080e7          	jalr	-128(ra) # 80006478 <release>
      acquiresleep(&b->lock);
    80002500:	01048513          	addi	a0,s1,16
    80002504:	00001097          	auipc	ra,0x1
    80002508:	47a080e7          	jalr	1146(ra) # 8000397e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000250c:	409c                	lw	a5,0(s1)
    8000250e:	c38d                	beqz	a5,80002530 <bread+0xf2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002510:	8526                	mv	a0,s1
    80002512:	70a2                	ld	ra,40(sp)
    80002514:	7402                	ld	s0,32(sp)
    80002516:	64e2                	ld	s1,24(sp)
    80002518:	6942                	ld	s2,16(sp)
    8000251a:	69a2                	ld	s3,8(sp)
    8000251c:	6145                	addi	sp,sp,48
    8000251e:	8082                	ret
  panic("bget: no buffers");
    80002520:	00006517          	auipc	a0,0x6
    80002524:	0f850513          	addi	a0,a0,248 # 80008618 <syscall_name_list+0x1b0>
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	930080e7          	jalr	-1744(ra) # 80005e58 <panic>
    virtio_disk_rw(b, 0);
    80002530:	4581                	li	a1,0
    80002532:	8526                	mv	a0,s1
    80002534:	00003097          	auipc	ra,0x3
    80002538:	07e080e7          	jalr	126(ra) # 800055b2 <virtio_disk_rw>
    b->valid = 1;
    8000253c:	4785                	li	a5,1
    8000253e:	c09c                	sw	a5,0(s1)
  return b;
    80002540:	bfc1                	j	80002510 <bread+0xd2>

0000000080002542 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002542:	1101                	addi	sp,sp,-32
    80002544:	ec06                	sd	ra,24(sp)
    80002546:	e822                	sd	s0,16(sp)
    80002548:	e426                	sd	s1,8(sp)
    8000254a:	1000                	addi	s0,sp,32
    8000254c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254e:	0541                	addi	a0,a0,16
    80002550:	00001097          	auipc	ra,0x1
    80002554:	4c8080e7          	jalr	1224(ra) # 80003a18 <holdingsleep>
    80002558:	cd01                	beqz	a0,80002570 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000255a:	4585                	li	a1,1
    8000255c:	8526                	mv	a0,s1
    8000255e:	00003097          	auipc	ra,0x3
    80002562:	054080e7          	jalr	84(ra) # 800055b2 <virtio_disk_rw>
}
    80002566:	60e2                	ld	ra,24(sp)
    80002568:	6442                	ld	s0,16(sp)
    8000256a:	64a2                	ld	s1,8(sp)
    8000256c:	6105                	addi	sp,sp,32
    8000256e:	8082                	ret
    panic("bwrite");
    80002570:	00006517          	auipc	a0,0x6
    80002574:	0c050513          	addi	a0,a0,192 # 80008630 <syscall_name_list+0x1c8>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	8e0080e7          	jalr	-1824(ra) # 80005e58 <panic>

0000000080002580 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002580:	1101                	addi	sp,sp,-32
    80002582:	ec06                	sd	ra,24(sp)
    80002584:	e822                	sd	s0,16(sp)
    80002586:	e426                	sd	s1,8(sp)
    80002588:	e04a                	sd	s2,0(sp)
    8000258a:	1000                	addi	s0,sp,32
    8000258c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000258e:	01050913          	addi	s2,a0,16
    80002592:	854a                	mv	a0,s2
    80002594:	00001097          	auipc	ra,0x1
    80002598:	484080e7          	jalr	1156(ra) # 80003a18 <holdingsleep>
    8000259c:	c92d                	beqz	a0,8000260e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000259e:	854a                	mv	a0,s2
    800025a0:	00001097          	auipc	ra,0x1
    800025a4:	434080e7          	jalr	1076(ra) # 800039d4 <releasesleep>

  acquire(&bcache.lock);
    800025a8:	0000c517          	auipc	a0,0xc
    800025ac:	52050513          	addi	a0,a0,1312 # 8000eac8 <bcache>
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	e14080e7          	jalr	-492(ra) # 800063c4 <acquire>
  b->refcnt--;
    800025b8:	40bc                	lw	a5,64(s1)
    800025ba:	37fd                	addiw	a5,a5,-1
    800025bc:	0007871b          	sext.w	a4,a5
    800025c0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025c2:	eb05                	bnez	a4,800025f2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025c4:	68bc                	ld	a5,80(s1)
    800025c6:	64b8                	ld	a4,72(s1)
    800025c8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025ca:	64bc                	ld	a5,72(s1)
    800025cc:	68b8                	ld	a4,80(s1)
    800025ce:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025d0:	00014797          	auipc	a5,0x14
    800025d4:	4f878793          	addi	a5,a5,1272 # 80016ac8 <bcache+0x8000>
    800025d8:	2b87b703          	ld	a4,696(a5)
    800025dc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025de:	00014717          	auipc	a4,0x14
    800025e2:	75270713          	addi	a4,a4,1874 # 80016d30 <bcache+0x8268>
    800025e6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025e8:	2b87b703          	ld	a4,696(a5)
    800025ec:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ee:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025f2:	0000c517          	auipc	a0,0xc
    800025f6:	4d650513          	addi	a0,a0,1238 # 8000eac8 <bcache>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	e7e080e7          	jalr	-386(ra) # 80006478 <release>
}
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6902                	ld	s2,0(sp)
    8000260a:	6105                	addi	sp,sp,32
    8000260c:	8082                	ret
    panic("brelse");
    8000260e:	00006517          	auipc	a0,0x6
    80002612:	02a50513          	addi	a0,a0,42 # 80008638 <syscall_name_list+0x1d0>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	842080e7          	jalr	-1982(ra) # 80005e58 <panic>

000000008000261e <bpin>:

void
bpin(struct buf *b) {
    8000261e:	1101                	addi	sp,sp,-32
    80002620:	ec06                	sd	ra,24(sp)
    80002622:	e822                	sd	s0,16(sp)
    80002624:	e426                	sd	s1,8(sp)
    80002626:	1000                	addi	s0,sp,32
    80002628:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000262a:	0000c517          	auipc	a0,0xc
    8000262e:	49e50513          	addi	a0,a0,1182 # 8000eac8 <bcache>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	d92080e7          	jalr	-622(ra) # 800063c4 <acquire>
  b->refcnt++;
    8000263a:	40bc                	lw	a5,64(s1)
    8000263c:	2785                	addiw	a5,a5,1
    8000263e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002640:	0000c517          	auipc	a0,0xc
    80002644:	48850513          	addi	a0,a0,1160 # 8000eac8 <bcache>
    80002648:	00004097          	auipc	ra,0x4
    8000264c:	e30080e7          	jalr	-464(ra) # 80006478 <release>
}
    80002650:	60e2                	ld	ra,24(sp)
    80002652:	6442                	ld	s0,16(sp)
    80002654:	64a2                	ld	s1,8(sp)
    80002656:	6105                	addi	sp,sp,32
    80002658:	8082                	ret

000000008000265a <bunpin>:

void
bunpin(struct buf *b) {
    8000265a:	1101                	addi	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	1000                	addi	s0,sp,32
    80002664:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002666:	0000c517          	auipc	a0,0xc
    8000266a:	46250513          	addi	a0,a0,1122 # 8000eac8 <bcache>
    8000266e:	00004097          	auipc	ra,0x4
    80002672:	d56080e7          	jalr	-682(ra) # 800063c4 <acquire>
  b->refcnt--;
    80002676:	40bc                	lw	a5,64(s1)
    80002678:	37fd                	addiw	a5,a5,-1
    8000267a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000267c:	0000c517          	auipc	a0,0xc
    80002680:	44c50513          	addi	a0,a0,1100 # 8000eac8 <bcache>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	df4080e7          	jalr	-524(ra) # 80006478 <release>
}
    8000268c:	60e2                	ld	ra,24(sp)
    8000268e:	6442                	ld	s0,16(sp)
    80002690:	64a2                	ld	s1,8(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret

0000000080002696 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002696:	1101                	addi	sp,sp,-32
    80002698:	ec06                	sd	ra,24(sp)
    8000269a:	e822                	sd	s0,16(sp)
    8000269c:	e426                	sd	s1,8(sp)
    8000269e:	e04a                	sd	s2,0(sp)
    800026a0:	1000                	addi	s0,sp,32
    800026a2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026a4:	00d5d59b          	srliw	a1,a1,0xd
    800026a8:	00015797          	auipc	a5,0x15
    800026ac:	ae078793          	addi	a5,a5,-1312 # 80017188 <sb>
    800026b0:	4fdc                	lw	a5,28(a5)
    800026b2:	9dbd                	addw	a1,a1,a5
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	d8a080e7          	jalr	-630(ra) # 8000243e <bread>
  bi = b % BPB;
    800026bc:	2481                	sext.w	s1,s1
  m = 1 << (bi % 8);
    800026be:	0074f793          	andi	a5,s1,7
    800026c2:	4705                	li	a4,1
    800026c4:	00f7173b          	sllw	a4,a4,a5
  bi = b % BPB;
    800026c8:	6789                	lui	a5,0x2
    800026ca:	17fd                	addi	a5,a5,-1
    800026cc:	8cfd                	and	s1,s1,a5
  if((bp->data[bi/8] & m) == 0)
    800026ce:	41f4d79b          	sraiw	a5,s1,0x1f
    800026d2:	01d7d79b          	srliw	a5,a5,0x1d
    800026d6:	9fa5                	addw	a5,a5,s1
    800026d8:	4037d79b          	sraiw	a5,a5,0x3
    800026dc:	00f506b3          	add	a3,a0,a5
    800026e0:	0586c683          	lbu	a3,88(a3)
    800026e4:	00d77633          	and	a2,a4,a3
    800026e8:	c61d                	beqz	a2,80002716 <bfree+0x80>
    800026ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ec:	97aa                	add	a5,a5,a0
    800026ee:	fff74713          	not	a4,a4
    800026f2:	8f75                	and	a4,a4,a3
    800026f4:	04e78c23          	sb	a4,88(a5) # 2058 <_entry-0x7fffdfa8>
  log_write(bp);
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	152080e7          	jalr	338(ra) # 8000384a <log_write>
  brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00000097          	auipc	ra,0x0
    80002706:	e7e080e7          	jalr	-386(ra) # 80002580 <brelse>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6902                	ld	s2,0(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret
    panic("freeing free block");
    80002716:	00006517          	auipc	a0,0x6
    8000271a:	f2a50513          	addi	a0,a0,-214 # 80008640 <syscall_name_list+0x1d8>
    8000271e:	00003097          	auipc	ra,0x3
    80002722:	73a080e7          	jalr	1850(ra) # 80005e58 <panic>

0000000080002726 <balloc>:
{
    80002726:	711d                	addi	sp,sp,-96
    80002728:	ec86                	sd	ra,88(sp)
    8000272a:	e8a2                	sd	s0,80(sp)
    8000272c:	e4a6                	sd	s1,72(sp)
    8000272e:	e0ca                	sd	s2,64(sp)
    80002730:	fc4e                	sd	s3,56(sp)
    80002732:	f852                	sd	s4,48(sp)
    80002734:	f456                	sd	s5,40(sp)
    80002736:	f05a                	sd	s6,32(sp)
    80002738:	ec5e                	sd	s7,24(sp)
    8000273a:	e862                	sd	s8,16(sp)
    8000273c:	e466                	sd	s9,8(sp)
    8000273e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002740:	00015797          	auipc	a5,0x15
    80002744:	a4878793          	addi	a5,a5,-1464 # 80017188 <sb>
    80002748:	43dc                	lw	a5,4(a5)
    8000274a:	10078e63          	beqz	a5,80002866 <balloc+0x140>
    8000274e:	8baa                	mv	s7,a0
    80002750:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002752:	00015b17          	auipc	s6,0x15
    80002756:	a36b0b13          	addi	s6,s6,-1482 # 80017188 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275a:	4c05                	li	s8,1
      m = 1 << (bi % 8);
    8000275c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002760:	6c89                	lui	s9,0x2
    80002762:	a079                	j	800027f0 <balloc+0xca>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002764:	8942                	mv	s2,a6
      m = 1 << (bi % 8);
    80002766:	4705                	li	a4,1
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002768:	4681                	li	a3,0
        bp->data[bi/8] |= m;  // Mark block in use.
    8000276a:	96a6                	add	a3,a3,s1
    8000276c:	8f51                	or	a4,a4,a2
    8000276e:	04e68c23          	sb	a4,88(a3)
        log_write(bp);
    80002772:	8526                	mv	a0,s1
    80002774:	00001097          	auipc	ra,0x1
    80002778:	0d6080e7          	jalr	214(ra) # 8000384a <log_write>
        brelse(bp);
    8000277c:	8526                	mv	a0,s1
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	e02080e7          	jalr	-510(ra) # 80002580 <brelse>
  bp = bread(dev, bno);
    80002786:	85ca                	mv	a1,s2
    80002788:	855e                	mv	a0,s7
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	cb4080e7          	jalr	-844(ra) # 8000243e <bread>
    80002792:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    80002794:	40000613          	li	a2,1024
    80002798:	4581                	li	a1,0
    8000279a:	05850513          	addi	a0,a0,88
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	a06080e7          	jalr	-1530(ra) # 800001a4 <memset>
  log_write(bp);
    800027a6:	8526                	mv	a0,s1
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	0a2080e7          	jalr	162(ra) # 8000384a <log_write>
  brelse(bp);
    800027b0:	8526                	mv	a0,s1
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	dce080e7          	jalr	-562(ra) # 80002580 <brelse>
}
    800027ba:	854a                	mv	a0,s2
    800027bc:	60e6                	ld	ra,88(sp)
    800027be:	6446                	ld	s0,80(sp)
    800027c0:	64a6                	ld	s1,72(sp)
    800027c2:	6906                	ld	s2,64(sp)
    800027c4:	79e2                	ld	s3,56(sp)
    800027c6:	7a42                	ld	s4,48(sp)
    800027c8:	7aa2                	ld	s5,40(sp)
    800027ca:	7b02                	ld	s6,32(sp)
    800027cc:	6be2                	ld	s7,24(sp)
    800027ce:	6c42                	ld	s8,16(sp)
    800027d0:	6ca2                	ld	s9,8(sp)
    800027d2:	6125                	addi	sp,sp,96
    800027d4:	8082                	ret
    brelse(bp);
    800027d6:	8526                	mv	a0,s1
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	da8080e7          	jalr	-600(ra) # 80002580 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027e0:	015c87bb          	addw	a5,s9,s5
    800027e4:	00078a9b          	sext.w	s5,a5
    800027e8:	004b2703          	lw	a4,4(s6)
    800027ec:	06eafd63          	bleu	a4,s5,80002866 <balloc+0x140>
    bp = bread(dev, BBLOCK(b, sb));
    800027f0:	41fad79b          	sraiw	a5,s5,0x1f
    800027f4:	0137d79b          	srliw	a5,a5,0x13
    800027f8:	015787bb          	addw	a5,a5,s5
    800027fc:	40d7d79b          	sraiw	a5,a5,0xd
    80002800:	01cb2583          	lw	a1,28(s6)
    80002804:	9dbd                	addw	a1,a1,a5
    80002806:	855e                	mv	a0,s7
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	c36080e7          	jalr	-970(ra) # 8000243e <bread>
    80002810:	84aa                	mv	s1,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002812:	000a881b          	sext.w	a6,s5
    80002816:	004b2503          	lw	a0,4(s6)
    8000281a:	faa87ee3          	bleu	a0,a6,800027d6 <balloc+0xb0>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000281e:	0584c603          	lbu	a2,88(s1)
    80002822:	00167793          	andi	a5,a2,1
    80002826:	df9d                	beqz	a5,80002764 <balloc+0x3e>
    80002828:	4105053b          	subw	a0,a0,a6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000282c:	87e2                	mv	a5,s8
    8000282e:	0107893b          	addw	s2,a5,a6
    80002832:	faa782e3          	beq	a5,a0,800027d6 <balloc+0xb0>
      m = 1 << (bi % 8);
    80002836:	41f7d71b          	sraiw	a4,a5,0x1f
    8000283a:	01d7561b          	srliw	a2,a4,0x1d
    8000283e:	00f606bb          	addw	a3,a2,a5
    80002842:	0076f713          	andi	a4,a3,7
    80002846:	9f11                	subw	a4,a4,a2
    80002848:	00e9973b          	sllw	a4,s3,a4
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000284c:	4036d69b          	sraiw	a3,a3,0x3
    80002850:	00d48633          	add	a2,s1,a3
    80002854:	05864603          	lbu	a2,88(a2)
    80002858:	00c775b3          	and	a1,a4,a2
    8000285c:	d599                	beqz	a1,8000276a <balloc+0x44>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000285e:	2785                	addiw	a5,a5,1
    80002860:	fd4797e3          	bne	a5,s4,8000282e <balloc+0x108>
    80002864:	bf8d                	j	800027d6 <balloc+0xb0>
  printf("balloc: out of blocks\n");
    80002866:	00006517          	auipc	a0,0x6
    8000286a:	df250513          	addi	a0,a0,-526 # 80008658 <syscall_name_list+0x1f0>
    8000286e:	00003097          	auipc	ra,0x3
    80002872:	634080e7          	jalr	1588(ra) # 80005ea2 <printf>
  return 0;
    80002876:	4901                	li	s2,0
    80002878:	b789                	j	800027ba <balloc+0x94>

000000008000287a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000287a:	7179                	addi	sp,sp,-48
    8000287c:	f406                	sd	ra,40(sp)
    8000287e:	f022                	sd	s0,32(sp)
    80002880:	ec26                	sd	s1,24(sp)
    80002882:	e84a                	sd	s2,16(sp)
    80002884:	e44e                	sd	s3,8(sp)
    80002886:	e052                	sd	s4,0(sp)
    80002888:	1800                	addi	s0,sp,48
    8000288a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000288c:	47ad                	li	a5,11
    8000288e:	02b7e763          	bltu	a5,a1,800028bc <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002892:	02059493          	slli	s1,a1,0x20
    80002896:	9081                	srli	s1,s1,0x20
    80002898:	048a                	slli	s1,s1,0x2
    8000289a:	94aa                	add	s1,s1,a0
    8000289c:	0504a903          	lw	s2,80(s1)
    800028a0:	06091e63          	bnez	s2,8000291c <bmap+0xa2>
      addr = balloc(ip->dev);
    800028a4:	4108                	lw	a0,0(a0)
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	e80080e7          	jalr	-384(ra) # 80002726 <balloc>
    800028ae:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028b2:	06090563          	beqz	s2,8000291c <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800028b6:	0524a823          	sw	s2,80(s1)
    800028ba:	a08d                	j	8000291c <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028bc:	ff45849b          	addiw	s1,a1,-12
    800028c0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028c4:	0ff00793          	li	a5,255
    800028c8:	08e7e563          	bltu	a5,a4,80002952 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028cc:	08052903          	lw	s2,128(a0)
    800028d0:	00091d63          	bnez	s2,800028ea <bmap+0x70>
      addr = balloc(ip->dev);
    800028d4:	4108                	lw	a0,0(a0)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e50080e7          	jalr	-432(ra) # 80002726 <balloc>
    800028de:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028e2:	02090d63          	beqz	s2,8000291c <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028e6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028ea:	85ca                	mv	a1,s2
    800028ec:	0009a503          	lw	a0,0(s3)
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	b4e080e7          	jalr	-1202(ra) # 8000243e <bread>
    800028f8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028fa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028fe:	02049593          	slli	a1,s1,0x20
    80002902:	9181                	srli	a1,a1,0x20
    80002904:	058a                	slli	a1,a1,0x2
    80002906:	00b784b3          	add	s1,a5,a1
    8000290a:	0004a903          	lw	s2,0(s1)
    8000290e:	02090063          	beqz	s2,8000292e <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002912:	8552                	mv	a0,s4
    80002914:	00000097          	auipc	ra,0x0
    80002918:	c6c080e7          	jalr	-916(ra) # 80002580 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000291c:	854a                	mv	a0,s2
    8000291e:	70a2                	ld	ra,40(sp)
    80002920:	7402                	ld	s0,32(sp)
    80002922:	64e2                	ld	s1,24(sp)
    80002924:	6942                	ld	s2,16(sp)
    80002926:	69a2                	ld	s3,8(sp)
    80002928:	6a02                	ld	s4,0(sp)
    8000292a:	6145                	addi	sp,sp,48
    8000292c:	8082                	ret
      addr = balloc(ip->dev);
    8000292e:	0009a503          	lw	a0,0(s3)
    80002932:	00000097          	auipc	ra,0x0
    80002936:	df4080e7          	jalr	-524(ra) # 80002726 <balloc>
    8000293a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000293e:	fc090ae3          	beqz	s2,80002912 <bmap+0x98>
        a[bn] = addr;
    80002942:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002946:	8552                	mv	a0,s4
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	f02080e7          	jalr	-254(ra) # 8000384a <log_write>
    80002950:	b7c9                	j	80002912 <bmap+0x98>
  panic("bmap: out of range");
    80002952:	00006517          	auipc	a0,0x6
    80002956:	d1e50513          	addi	a0,a0,-738 # 80008670 <syscall_name_list+0x208>
    8000295a:	00003097          	auipc	ra,0x3
    8000295e:	4fe080e7          	jalr	1278(ra) # 80005e58 <panic>

0000000080002962 <iget>:
{
    80002962:	7179                	addi	sp,sp,-48
    80002964:	f406                	sd	ra,40(sp)
    80002966:	f022                	sd	s0,32(sp)
    80002968:	ec26                	sd	s1,24(sp)
    8000296a:	e84a                	sd	s2,16(sp)
    8000296c:	e44e                	sd	s3,8(sp)
    8000296e:	e052                	sd	s4,0(sp)
    80002970:	1800                	addi	s0,sp,48
    80002972:	89aa                	mv	s3,a0
    80002974:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002976:	00015517          	auipc	a0,0x15
    8000297a:	83250513          	addi	a0,a0,-1998 # 800171a8 <itable>
    8000297e:	00004097          	auipc	ra,0x4
    80002982:	a46080e7          	jalr	-1466(ra) # 800063c4 <acquire>
  empty = 0;
    80002986:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002988:	00015497          	auipc	s1,0x15
    8000298c:	83848493          	addi	s1,s1,-1992 # 800171c0 <itable+0x18>
    80002990:	00016697          	auipc	a3,0x16
    80002994:	2c068693          	addi	a3,a3,704 # 80018c50 <log>
    80002998:	a039                	j	800029a6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000299a:	02090b63          	beqz	s2,800029d0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299e:	08848493          	addi	s1,s1,136
    800029a2:	02d48a63          	beq	s1,a3,800029d6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029a6:	449c                	lw	a5,8(s1)
    800029a8:	fef059e3          	blez	a5,8000299a <iget+0x38>
    800029ac:	4098                	lw	a4,0(s1)
    800029ae:	ff3716e3          	bne	a4,s3,8000299a <iget+0x38>
    800029b2:	40d8                	lw	a4,4(s1)
    800029b4:	ff4713e3          	bne	a4,s4,8000299a <iget+0x38>
      ip->ref++;
    800029b8:	2785                	addiw	a5,a5,1
    800029ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029bc:	00014517          	auipc	a0,0x14
    800029c0:	7ec50513          	addi	a0,a0,2028 # 800171a8 <itable>
    800029c4:	00004097          	auipc	ra,0x4
    800029c8:	ab4080e7          	jalr	-1356(ra) # 80006478 <release>
      return ip;
    800029cc:	8926                	mv	s2,s1
    800029ce:	a03d                	j	800029fc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d0:	f7f9                	bnez	a5,8000299e <iget+0x3c>
    800029d2:	8926                	mv	s2,s1
    800029d4:	b7e9                	j	8000299e <iget+0x3c>
  if(empty == 0)
    800029d6:	02090c63          	beqz	s2,80002a0e <iget+0xac>
  ip->dev = dev;
    800029da:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029de:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029e2:	4785                	li	a5,1
    800029e4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029e8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029ec:	00014517          	auipc	a0,0x14
    800029f0:	7bc50513          	addi	a0,a0,1980 # 800171a8 <itable>
    800029f4:	00004097          	auipc	ra,0x4
    800029f8:	a84080e7          	jalr	-1404(ra) # 80006478 <release>
}
    800029fc:	854a                	mv	a0,s2
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
    panic("iget: no inodes");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	c7a50513          	addi	a0,a0,-902 # 80008688 <syscall_name_list+0x220>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	442080e7          	jalr	1090(ra) # 80005e58 <panic>

0000000080002a1e <fsinit>:
fsinit(int dev) {
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	addi	s0,sp,48
    80002a2c:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    80002a2e:	4585                	li	a1,1
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	a0e080e7          	jalr	-1522(ra) # 8000243e <bread>
    80002a38:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a3a:	00014497          	auipc	s1,0x14
    80002a3e:	74e48493          	addi	s1,s1,1870 # 80017188 <sb>
    80002a42:	02000613          	li	a2,32
    80002a46:	05850593          	addi	a1,a0,88
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	ffffd097          	auipc	ra,0xffffd
    80002a50:	7c4080e7          	jalr	1988(ra) # 80000210 <memmove>
  brelse(bp);
    80002a54:	854a                	mv	a0,s2
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	b2a080e7          	jalr	-1238(ra) # 80002580 <brelse>
  if(sb.magic != FSMAGIC)
    80002a5e:	4098                	lw	a4,0(s1)
    80002a60:	102037b7          	lui	a5,0x10203
    80002a64:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a68:	02f71263          	bne	a4,a5,80002a8c <fsinit+0x6e>
  initlog(dev, &sb);
    80002a6c:	00014597          	auipc	a1,0x14
    80002a70:	71c58593          	addi	a1,a1,1820 # 80017188 <sb>
    80002a74:	854e                	mv	a0,s3
    80002a76:	00001097          	auipc	ra,0x1
    80002a7a:	b52080e7          	jalr	-1198(ra) # 800035c8 <initlog>
}
    80002a7e:	70a2                	ld	ra,40(sp)
    80002a80:	7402                	ld	s0,32(sp)
    80002a82:	64e2                	ld	s1,24(sp)
    80002a84:	6942                	ld	s2,16(sp)
    80002a86:	69a2                	ld	s3,8(sp)
    80002a88:	6145                	addi	sp,sp,48
    80002a8a:	8082                	ret
    panic("invalid file system");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	c0c50513          	addi	a0,a0,-1012 # 80008698 <syscall_name_list+0x230>
    80002a94:	00003097          	auipc	ra,0x3
    80002a98:	3c4080e7          	jalr	964(ra) # 80005e58 <panic>

0000000080002a9c <iinit>:
{
    80002a9c:	7179                	addi	sp,sp,-48
    80002a9e:	f406                	sd	ra,40(sp)
    80002aa0:	f022                	sd	s0,32(sp)
    80002aa2:	ec26                	sd	s1,24(sp)
    80002aa4:	e84a                	sd	s2,16(sp)
    80002aa6:	e44e                	sd	s3,8(sp)
    80002aa8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aaa:	00006597          	auipc	a1,0x6
    80002aae:	c0658593          	addi	a1,a1,-1018 # 800086b0 <syscall_name_list+0x248>
    80002ab2:	00014517          	auipc	a0,0x14
    80002ab6:	6f650513          	addi	a0,a0,1782 # 800171a8 <itable>
    80002aba:	00004097          	auipc	ra,0x4
    80002abe:	87a080e7          	jalr	-1926(ra) # 80006334 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ac2:	00014497          	auipc	s1,0x14
    80002ac6:	70e48493          	addi	s1,s1,1806 # 800171d0 <itable+0x28>
    80002aca:	00016997          	auipc	s3,0x16
    80002ace:	19698993          	addi	s3,s3,406 # 80018c60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ad2:	00006917          	auipc	s2,0x6
    80002ad6:	be690913          	addi	s2,s2,-1050 # 800086b8 <syscall_name_list+0x250>
    80002ada:	85ca                	mv	a1,s2
    80002adc:	8526                	mv	a0,s1
    80002ade:	00001097          	auipc	ra,0x1
    80002ae2:	e66080e7          	jalr	-410(ra) # 80003944 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ae6:	08848493          	addi	s1,s1,136
    80002aea:	ff3498e3          	bne	s1,s3,80002ada <iinit+0x3e>
}
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6145                	addi	sp,sp,48
    80002afa:	8082                	ret

0000000080002afc <ialloc>:
{
    80002afc:	715d                	addi	sp,sp,-80
    80002afe:	e486                	sd	ra,72(sp)
    80002b00:	e0a2                	sd	s0,64(sp)
    80002b02:	fc26                	sd	s1,56(sp)
    80002b04:	f84a                	sd	s2,48(sp)
    80002b06:	f44e                	sd	s3,40(sp)
    80002b08:	f052                	sd	s4,32(sp)
    80002b0a:	ec56                	sd	s5,24(sp)
    80002b0c:	e85a                	sd	s6,16(sp)
    80002b0e:	e45e                	sd	s7,8(sp)
    80002b10:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b12:	00014797          	auipc	a5,0x14
    80002b16:	67678793          	addi	a5,a5,1654 # 80017188 <sb>
    80002b1a:	47d8                	lw	a4,12(a5)
    80002b1c:	4785                	li	a5,1
    80002b1e:	04e7fa63          	bleu	a4,a5,80002b72 <ialloc+0x76>
    80002b22:	8a2a                	mv	s4,a0
    80002b24:	8b2e                	mv	s6,a1
    80002b26:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b28:	00014997          	auipc	s3,0x14
    80002b2c:	66098993          	addi	s3,s3,1632 # 80017188 <sb>
    80002b30:	00048a9b          	sext.w	s5,s1
    80002b34:	0044d593          	srli	a1,s1,0x4
    80002b38:	0189a783          	lw	a5,24(s3)
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	8552                	mv	a0,s4
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	8fe080e7          	jalr	-1794(ra) # 8000243e <bread>
    80002b48:	8baa                	mv	s7,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b4a:	05850913          	addi	s2,a0,88
    80002b4e:	00f4f793          	andi	a5,s1,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	993e                	add	s2,s2,a5
    if(dip->type == 0){  // a free inode
    80002b56:	00091783          	lh	a5,0(s2)
    80002b5a:	c3a1                	beqz	a5,80002b9a <ialloc+0x9e>
    brelse(bp);
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	a24080e7          	jalr	-1500(ra) # 80002580 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b64:	0485                	addi	s1,s1,1
    80002b66:	00c9a703          	lw	a4,12(s3)
    80002b6a:	0004879b          	sext.w	a5,s1
    80002b6e:	fce7e1e3          	bltu	a5,a4,80002b30 <ialloc+0x34>
  printf("ialloc: no inodes\n");
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	b4e50513          	addi	a0,a0,-1202 # 800086c0 <syscall_name_list+0x258>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	328080e7          	jalr	808(ra) # 80005ea2 <printf>
  return 0;
    80002b82:	4501                	li	a0,0
}
    80002b84:	60a6                	ld	ra,72(sp)
    80002b86:	6406                	ld	s0,64(sp)
    80002b88:	74e2                	ld	s1,56(sp)
    80002b8a:	7942                	ld	s2,48(sp)
    80002b8c:	79a2                	ld	s3,40(sp)
    80002b8e:	7a02                	ld	s4,32(sp)
    80002b90:	6ae2                	ld	s5,24(sp)
    80002b92:	6b42                	ld	s6,16(sp)
    80002b94:	6ba2                	ld	s7,8(sp)
    80002b96:	6161                	addi	sp,sp,80
    80002b98:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b9a:	04000613          	li	a2,64
    80002b9e:	4581                	li	a1,0
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	ffffd097          	auipc	ra,0xffffd
    80002ba6:	602080e7          	jalr	1538(ra) # 800001a4 <memset>
      dip->type = type;
    80002baa:	01691023          	sh	s6,0(s2)
      log_write(bp);   // mark it allocated on the disk
    80002bae:	855e                	mv	a0,s7
    80002bb0:	00001097          	auipc	ra,0x1
    80002bb4:	c9a080e7          	jalr	-870(ra) # 8000384a <log_write>
      brelse(bp);
    80002bb8:	855e                	mv	a0,s7
    80002bba:	00000097          	auipc	ra,0x0
    80002bbe:	9c6080e7          	jalr	-1594(ra) # 80002580 <brelse>
      return iget(dev, inum);
    80002bc2:	85d6                	mv	a1,s5
    80002bc4:	8552                	mv	a0,s4
    80002bc6:	00000097          	auipc	ra,0x0
    80002bca:	d9c080e7          	jalr	-612(ra) # 80002962 <iget>
    80002bce:	bf5d                	j	80002b84 <ialloc+0x88>

0000000080002bd0 <iupdate>:
{
    80002bd0:	1101                	addi	sp,sp,-32
    80002bd2:	ec06                	sd	ra,24(sp)
    80002bd4:	e822                	sd	s0,16(sp)
    80002bd6:	e426                	sd	s1,8(sp)
    80002bd8:	e04a                	sd	s2,0(sp)
    80002bda:	1000                	addi	s0,sp,32
    80002bdc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bde:	415c                	lw	a5,4(a0)
    80002be0:	0047d79b          	srliw	a5,a5,0x4
    80002be4:	00014717          	auipc	a4,0x14
    80002be8:	5a470713          	addi	a4,a4,1444 # 80017188 <sb>
    80002bec:	4f0c                	lw	a1,24(a4)
    80002bee:	9dbd                	addw	a1,a1,a5
    80002bf0:	4108                	lw	a0,0(a0)
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	84c080e7          	jalr	-1972(ra) # 8000243e <bread>
    80002bfa:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bfc:	05850513          	addi	a0,a0,88
    80002c00:	40dc                	lw	a5,4(s1)
    80002c02:	8bbd                	andi	a5,a5,15
    80002c04:	079a                	slli	a5,a5,0x6
    80002c06:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c08:	04449783          	lh	a5,68(s1)
    80002c0c:	00f51023          	sh	a5,0(a0)
  dip->major = ip->major;
    80002c10:	04649783          	lh	a5,70(s1)
    80002c14:	00f51123          	sh	a5,2(a0)
  dip->minor = ip->minor;
    80002c18:	04849783          	lh	a5,72(s1)
    80002c1c:	00f51223          	sh	a5,4(a0)
  dip->nlink = ip->nlink;
    80002c20:	04a49783          	lh	a5,74(s1)
    80002c24:	00f51323          	sh	a5,6(a0)
  dip->size = ip->size;
    80002c28:	44fc                	lw	a5,76(s1)
    80002c2a:	c51c                	sw	a5,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c2c:	03400613          	li	a2,52
    80002c30:	05048593          	addi	a1,s1,80
    80002c34:	0531                	addi	a0,a0,12
    80002c36:	ffffd097          	auipc	ra,0xffffd
    80002c3a:	5da080e7          	jalr	1498(ra) # 80000210 <memmove>
  log_write(bp);
    80002c3e:	854a                	mv	a0,s2
    80002c40:	00001097          	auipc	ra,0x1
    80002c44:	c0a080e7          	jalr	-1014(ra) # 8000384a <log_write>
  brelse(bp);
    80002c48:	854a                	mv	a0,s2
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	936080e7          	jalr	-1738(ra) # 80002580 <brelse>
}
    80002c52:	60e2                	ld	ra,24(sp)
    80002c54:	6442                	ld	s0,16(sp)
    80002c56:	64a2                	ld	s1,8(sp)
    80002c58:	6902                	ld	s2,0(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret

0000000080002c5e <idup>:
{
    80002c5e:	1101                	addi	sp,sp,-32
    80002c60:	ec06                	sd	ra,24(sp)
    80002c62:	e822                	sd	s0,16(sp)
    80002c64:	e426                	sd	s1,8(sp)
    80002c66:	1000                	addi	s0,sp,32
    80002c68:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c6a:	00014517          	auipc	a0,0x14
    80002c6e:	53e50513          	addi	a0,a0,1342 # 800171a8 <itable>
    80002c72:	00003097          	auipc	ra,0x3
    80002c76:	752080e7          	jalr	1874(ra) # 800063c4 <acquire>
  ip->ref++;
    80002c7a:	449c                	lw	a5,8(s1)
    80002c7c:	2785                	addiw	a5,a5,1
    80002c7e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c80:	00014517          	auipc	a0,0x14
    80002c84:	52850513          	addi	a0,a0,1320 # 800171a8 <itable>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	7f0080e7          	jalr	2032(ra) # 80006478 <release>
}
    80002c90:	8526                	mv	a0,s1
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret

0000000080002c9c <ilock>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ca8:	c115                	beqz	a0,80002ccc <ilock+0x30>
    80002caa:	84aa                	mv	s1,a0
    80002cac:	451c                	lw	a5,8(a0)
    80002cae:	00f05f63          	blez	a5,80002ccc <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cb2:	0541                	addi	a0,a0,16
    80002cb4:	00001097          	auipc	ra,0x1
    80002cb8:	cca080e7          	jalr	-822(ra) # 8000397e <acquiresleep>
  if(ip->valid == 0){
    80002cbc:	40bc                	lw	a5,64(s1)
    80002cbe:	cf99                	beqz	a5,80002cdc <ilock+0x40>
}
    80002cc0:	60e2                	ld	ra,24(sp)
    80002cc2:	6442                	ld	s0,16(sp)
    80002cc4:	64a2                	ld	s1,8(sp)
    80002cc6:	6902                	ld	s2,0(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret
    panic("ilock");
    80002ccc:	00006517          	auipc	a0,0x6
    80002cd0:	a0c50513          	addi	a0,a0,-1524 # 800086d8 <syscall_name_list+0x270>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	184080e7          	jalr	388(ra) # 80005e58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cdc:	40dc                	lw	a5,4(s1)
    80002cde:	0047d79b          	srliw	a5,a5,0x4
    80002ce2:	00014717          	auipc	a4,0x14
    80002ce6:	4a670713          	addi	a4,a4,1190 # 80017188 <sb>
    80002cea:	4f0c                	lw	a1,24(a4)
    80002cec:	9dbd                	addw	a1,a1,a5
    80002cee:	4088                	lw	a0,0(s1)
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	74e080e7          	jalr	1870(ra) # 8000243e <bread>
    80002cf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cfa:	05850593          	addi	a1,a0,88
    80002cfe:	40dc                	lw	a5,4(s1)
    80002d00:	8bbd                	andi	a5,a5,15
    80002d02:	079a                	slli	a5,a5,0x6
    80002d04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d06:	00059783          	lh	a5,0(a1)
    80002d0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d0e:	00259783          	lh	a5,2(a1)
    80002d12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d16:	00459783          	lh	a5,4(a1)
    80002d1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d1e:	00659783          	lh	a5,6(a1)
    80002d22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d26:	459c                	lw	a5,8(a1)
    80002d28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d2a:	03400613          	li	a2,52
    80002d2e:	05b1                	addi	a1,a1,12
    80002d30:	05048513          	addi	a0,s1,80
    80002d34:	ffffd097          	auipc	ra,0xffffd
    80002d38:	4dc080e7          	jalr	1244(ra) # 80000210 <memmove>
    brelse(bp);
    80002d3c:	854a                	mv	a0,s2
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	842080e7          	jalr	-1982(ra) # 80002580 <brelse>
    ip->valid = 1;
    80002d46:	4785                	li	a5,1
    80002d48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d4a:	04449783          	lh	a5,68(s1)
    80002d4e:	fbad                	bnez	a5,80002cc0 <ilock+0x24>
      panic("ilock: no type");
    80002d50:	00006517          	auipc	a0,0x6
    80002d54:	99050513          	addi	a0,a0,-1648 # 800086e0 <syscall_name_list+0x278>
    80002d58:	00003097          	auipc	ra,0x3
    80002d5c:	100080e7          	jalr	256(ra) # 80005e58 <panic>

0000000080002d60 <iunlock>:
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	e04a                	sd	s2,0(sp)
    80002d6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d6c:	c905                	beqz	a0,80002d9c <iunlock+0x3c>
    80002d6e:	84aa                	mv	s1,a0
    80002d70:	01050913          	addi	s2,a0,16
    80002d74:	854a                	mv	a0,s2
    80002d76:	00001097          	auipc	ra,0x1
    80002d7a:	ca2080e7          	jalr	-862(ra) # 80003a18 <holdingsleep>
    80002d7e:	cd19                	beqz	a0,80002d9c <iunlock+0x3c>
    80002d80:	449c                	lw	a5,8(s1)
    80002d82:	00f05d63          	blez	a5,80002d9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d86:	854a                	mv	a0,s2
    80002d88:	00001097          	auipc	ra,0x1
    80002d8c:	c4c080e7          	jalr	-948(ra) # 800039d4 <releasesleep>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6902                	ld	s2,0(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret
    panic("iunlock");
    80002d9c:	00006517          	auipc	a0,0x6
    80002da0:	95450513          	addi	a0,a0,-1708 # 800086f0 <syscall_name_list+0x288>
    80002da4:	00003097          	auipc	ra,0x3
    80002da8:	0b4080e7          	jalr	180(ra) # 80005e58 <panic>

0000000080002dac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dac:	7179                	addi	sp,sp,-48
    80002dae:	f406                	sd	ra,40(sp)
    80002db0:	f022                	sd	s0,32(sp)
    80002db2:	ec26                	sd	s1,24(sp)
    80002db4:	e84a                	sd	s2,16(sp)
    80002db6:	e44e                	sd	s3,8(sp)
    80002db8:	e052                	sd	s4,0(sp)
    80002dba:	1800                	addi	s0,sp,48
    80002dbc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dbe:	05050493          	addi	s1,a0,80
    80002dc2:	08050913          	addi	s2,a0,128
    80002dc6:	a821                	j	80002dde <itrunc+0x32>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80002dc8:	0009a503          	lw	a0,0(s3)
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	8ca080e7          	jalr	-1846(ra) # 80002696 <bfree>
      ip->addrs[i] = 0;
    80002dd4:	0004a023          	sw	zero,0(s1)
  for(i = 0; i < NDIRECT; i++){
    80002dd8:	0491                	addi	s1,s1,4
    80002dda:	01248563          	beq	s1,s2,80002de4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dde:	408c                	lw	a1,0(s1)
    80002de0:	dde5                	beqz	a1,80002dd8 <itrunc+0x2c>
    80002de2:	b7dd                	j	80002dc8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002de4:	0809a583          	lw	a1,128(s3)
    80002de8:	e185                	bnez	a1,80002e08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dee:	854e                	mv	a0,s3
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	de0080e7          	jalr	-544(ra) # 80002bd0 <iupdate>
}
    80002df8:	70a2                	ld	ra,40(sp)
    80002dfa:	7402                	ld	s0,32(sp)
    80002dfc:	64e2                	ld	s1,24(sp)
    80002dfe:	6942                	ld	s2,16(sp)
    80002e00:	69a2                	ld	s3,8(sp)
    80002e02:	6a02                	ld	s4,0(sp)
    80002e04:	6145                	addi	sp,sp,48
    80002e06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e08:	0009a503          	lw	a0,0(s3)
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	632080e7          	jalr	1586(ra) # 8000243e <bread>
    80002e14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e16:	05850493          	addi	s1,a0,88
    80002e1a:	45850913          	addi	s2,a0,1112
    80002e1e:	a811                	j	80002e32 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e20:	0009a503          	lw	a0,0(s3)
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	872080e7          	jalr	-1934(ra) # 80002696 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e2c:	0491                	addi	s1,s1,4
    80002e2e:	01248563          	beq	s1,s2,80002e38 <itrunc+0x8c>
      if(a[j])
    80002e32:	408c                	lw	a1,0(s1)
    80002e34:	dde5                	beqz	a1,80002e2c <itrunc+0x80>
    80002e36:	b7ed                	j	80002e20 <itrunc+0x74>
    brelse(bp);
    80002e38:	8552                	mv	a0,s4
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	746080e7          	jalr	1862(ra) # 80002580 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e42:	0809a583          	lw	a1,128(s3)
    80002e46:	0009a503          	lw	a0,0(s3)
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	84c080e7          	jalr	-1972(ra) # 80002696 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e52:	0809a023          	sw	zero,128(s3)
    80002e56:	bf51                	j	80002dea <itrunc+0x3e>

0000000080002e58 <iput>:
{
    80002e58:	1101                	addi	sp,sp,-32
    80002e5a:	ec06                	sd	ra,24(sp)
    80002e5c:	e822                	sd	s0,16(sp)
    80002e5e:	e426                	sd	s1,8(sp)
    80002e60:	e04a                	sd	s2,0(sp)
    80002e62:	1000                	addi	s0,sp,32
    80002e64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e66:	00014517          	auipc	a0,0x14
    80002e6a:	34250513          	addi	a0,a0,834 # 800171a8 <itable>
    80002e6e:	00003097          	auipc	ra,0x3
    80002e72:	556080e7          	jalr	1366(ra) # 800063c4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e76:	4498                	lw	a4,8(s1)
    80002e78:	4785                	li	a5,1
    80002e7a:	02f70363          	beq	a4,a5,80002ea0 <iput+0x48>
  ip->ref--;
    80002e7e:	449c                	lw	a5,8(s1)
    80002e80:	37fd                	addiw	a5,a5,-1
    80002e82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e84:	00014517          	auipc	a0,0x14
    80002e88:	32450513          	addi	a0,a0,804 # 800171a8 <itable>
    80002e8c:	00003097          	auipc	ra,0x3
    80002e90:	5ec080e7          	jalr	1516(ra) # 80006478 <release>
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	64a2                	ld	s1,8(sp)
    80002e9a:	6902                	ld	s2,0(sp)
    80002e9c:	6105                	addi	sp,sp,32
    80002e9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ea0:	40bc                	lw	a5,64(s1)
    80002ea2:	dff1                	beqz	a5,80002e7e <iput+0x26>
    80002ea4:	04a49783          	lh	a5,74(s1)
    80002ea8:	fbf9                	bnez	a5,80002e7e <iput+0x26>
    acquiresleep(&ip->lock);
    80002eaa:	01048913          	addi	s2,s1,16
    80002eae:	854a                	mv	a0,s2
    80002eb0:	00001097          	auipc	ra,0x1
    80002eb4:	ace080e7          	jalr	-1330(ra) # 8000397e <acquiresleep>
    release(&itable.lock);
    80002eb8:	00014517          	auipc	a0,0x14
    80002ebc:	2f050513          	addi	a0,a0,752 # 800171a8 <itable>
    80002ec0:	00003097          	auipc	ra,0x3
    80002ec4:	5b8080e7          	jalr	1464(ra) # 80006478 <release>
    itrunc(ip);
    80002ec8:	8526                	mv	a0,s1
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	ee2080e7          	jalr	-286(ra) # 80002dac <itrunc>
    ip->type = 0;
    80002ed2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ed6:	8526                	mv	a0,s1
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	cf8080e7          	jalr	-776(ra) # 80002bd0 <iupdate>
    ip->valid = 0;
    80002ee0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00001097          	auipc	ra,0x1
    80002eea:	aee080e7          	jalr	-1298(ra) # 800039d4 <releasesleep>
    acquire(&itable.lock);
    80002eee:	00014517          	auipc	a0,0x14
    80002ef2:	2ba50513          	addi	a0,a0,698 # 800171a8 <itable>
    80002ef6:	00003097          	auipc	ra,0x3
    80002efa:	4ce080e7          	jalr	1230(ra) # 800063c4 <acquire>
    80002efe:	b741                	j	80002e7e <iput+0x26>

0000000080002f00 <iunlockput>:
{
    80002f00:	1101                	addi	sp,sp,-32
    80002f02:	ec06                	sd	ra,24(sp)
    80002f04:	e822                	sd	s0,16(sp)
    80002f06:	e426                	sd	s1,8(sp)
    80002f08:	1000                	addi	s0,sp,32
    80002f0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	e54080e7          	jalr	-428(ra) # 80002d60 <iunlock>
  iput(ip);
    80002f14:	8526                	mv	a0,s1
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	f42080e7          	jalr	-190(ra) # 80002e58 <iput>
}
    80002f1e:	60e2                	ld	ra,24(sp)
    80002f20:	6442                	ld	s0,16(sp)
    80002f22:	64a2                	ld	s1,8(sp)
    80002f24:	6105                	addi	sp,sp,32
    80002f26:	8082                	ret

0000000080002f28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f28:	1141                	addi	sp,sp,-16
    80002f2a:	e422                	sd	s0,8(sp)
    80002f2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f2e:	411c                	lw	a5,0(a0)
    80002f30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f32:	415c                	lw	a5,4(a0)
    80002f34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f36:	04451783          	lh	a5,68(a0)
    80002f3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f3e:	04a51783          	lh	a5,74(a0)
    80002f42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f46:	04c56783          	lwu	a5,76(a0)
    80002f4a:	e99c                	sd	a5,16(a1)
}
    80002f4c:	6422                	ld	s0,8(sp)
    80002f4e:	0141                	addi	sp,sp,16
    80002f50:	8082                	ret

0000000080002f52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f52:	457c                	lw	a5,76(a0)
    80002f54:	0ed7e963          	bltu	a5,a3,80003046 <readi+0xf4>
{
    80002f58:	7159                	addi	sp,sp,-112
    80002f5a:	f486                	sd	ra,104(sp)
    80002f5c:	f0a2                	sd	s0,96(sp)
    80002f5e:	eca6                	sd	s1,88(sp)
    80002f60:	e8ca                	sd	s2,80(sp)
    80002f62:	e4ce                	sd	s3,72(sp)
    80002f64:	e0d2                	sd	s4,64(sp)
    80002f66:	fc56                	sd	s5,56(sp)
    80002f68:	f85a                	sd	s6,48(sp)
    80002f6a:	f45e                	sd	s7,40(sp)
    80002f6c:	f062                	sd	s8,32(sp)
    80002f6e:	ec66                	sd	s9,24(sp)
    80002f70:	e86a                	sd	s10,16(sp)
    80002f72:	e46e                	sd	s11,8(sp)
    80002f74:	1880                	addi	s0,sp,112
    80002f76:	8baa                	mv	s7,a0
    80002f78:	8c2e                	mv	s8,a1
    80002f7a:	8a32                	mv	s4,a2
    80002f7c:	84b6                	mv	s1,a3
    80002f7e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f80:	9f35                	addw	a4,a4,a3
    return 0;
    80002f82:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f84:	0ad76063          	bltu	a4,a3,80003024 <readi+0xd2>
  if(off + n > ip->size)
    80002f88:	00e7f463          	bleu	a4,a5,80002f90 <readi+0x3e>
    n = ip->size - off;
    80002f8c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f90:	0a0b0963          	beqz	s6,80003042 <readi+0xf0>
    80002f94:	4901                	li	s2,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f96:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f9a:	5cfd                	li	s9,-1
    80002f9c:	a82d                	j	80002fd6 <readi+0x84>
    80002f9e:	02099d93          	slli	s11,s3,0x20
    80002fa2:	020ddd93          	srli	s11,s11,0x20
    80002fa6:	058a8613          	addi	a2,s5,88
    80002faa:	86ee                	mv	a3,s11
    80002fac:	963a                	add	a2,a2,a4
    80002fae:	85d2                	mv	a1,s4
    80002fb0:	8562                	mv	a0,s8
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	9c6080e7          	jalr	-1594(ra) # 80001978 <either_copyout>
    80002fba:	05950d63          	beq	a0,s9,80003014 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fbe:	8556                	mv	a0,s5
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	5c0080e7          	jalr	1472(ra) # 80002580 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc8:	0129893b          	addw	s2,s3,s2
    80002fcc:	009984bb          	addw	s1,s3,s1
    80002fd0:	9a6e                	add	s4,s4,s11
    80002fd2:	05697763          	bleu	s6,s2,80003020 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fd6:	00a4d59b          	srliw	a1,s1,0xa
    80002fda:	855e                	mv	a0,s7
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	89e080e7          	jalr	-1890(ra) # 8000287a <bmap>
    80002fe4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fe8:	cd85                	beqz	a1,80003020 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fea:	000ba503          	lw	a0,0(s7)
    80002fee:	fffff097          	auipc	ra,0xfffff
    80002ff2:	450080e7          	jalr	1104(ra) # 8000243e <bread>
    80002ff6:	8aaa                	mv	s5,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff8:	3ff4f713          	andi	a4,s1,1023
    80002ffc:	40ed07bb          	subw	a5,s10,a4
    80003000:	412b06bb          	subw	a3,s6,s2
    80003004:	89be                	mv	s3,a5
    80003006:	2781                	sext.w	a5,a5
    80003008:	0006861b          	sext.w	a2,a3
    8000300c:	f8f679e3          	bleu	a5,a2,80002f9e <readi+0x4c>
    80003010:	89b6                	mv	s3,a3
    80003012:	b771                	j	80002f9e <readi+0x4c>
      brelse(bp);
    80003014:	8556                	mv	a0,s5
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	56a080e7          	jalr	1386(ra) # 80002580 <brelse>
      tot = -1;
    8000301e:	597d                	li	s2,-1
  }
  return tot;
    80003020:	0009051b          	sext.w	a0,s2
}
    80003024:	70a6                	ld	ra,104(sp)
    80003026:	7406                	ld	s0,96(sp)
    80003028:	64e6                	ld	s1,88(sp)
    8000302a:	6946                	ld	s2,80(sp)
    8000302c:	69a6                	ld	s3,72(sp)
    8000302e:	6a06                	ld	s4,64(sp)
    80003030:	7ae2                	ld	s5,56(sp)
    80003032:	7b42                	ld	s6,48(sp)
    80003034:	7ba2                	ld	s7,40(sp)
    80003036:	7c02                	ld	s8,32(sp)
    80003038:	6ce2                	ld	s9,24(sp)
    8000303a:	6d42                	ld	s10,16(sp)
    8000303c:	6da2                	ld	s11,8(sp)
    8000303e:	6165                	addi	sp,sp,112
    80003040:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003042:	895a                	mv	s2,s6
    80003044:	bff1                	j	80003020 <readi+0xce>
    return 0;
    80003046:	4501                	li	a0,0
}
    80003048:	8082                	ret

000000008000304a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000304a:	457c                	lw	a5,76(a0)
    8000304c:	10d7e863          	bltu	a5,a3,8000315c <writei+0x112>
{
    80003050:	7159                	addi	sp,sp,-112
    80003052:	f486                	sd	ra,104(sp)
    80003054:	f0a2                	sd	s0,96(sp)
    80003056:	eca6                	sd	s1,88(sp)
    80003058:	e8ca                	sd	s2,80(sp)
    8000305a:	e4ce                	sd	s3,72(sp)
    8000305c:	e0d2                	sd	s4,64(sp)
    8000305e:	fc56                	sd	s5,56(sp)
    80003060:	f85a                	sd	s6,48(sp)
    80003062:	f45e                	sd	s7,40(sp)
    80003064:	f062                	sd	s8,32(sp)
    80003066:	ec66                	sd	s9,24(sp)
    80003068:	e86a                	sd	s10,16(sp)
    8000306a:	e46e                	sd	s11,8(sp)
    8000306c:	1880                	addi	s0,sp,112
    8000306e:	8b2a                	mv	s6,a0
    80003070:	8c2e                	mv	s8,a1
    80003072:	8ab2                	mv	s5,a2
    80003074:	84b6                	mv	s1,a3
    80003076:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003078:	00e687bb          	addw	a5,a3,a4
    8000307c:	0ed7e263          	bltu	a5,a3,80003160 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003080:	00043737          	lui	a4,0x43
    80003084:	0ef76063          	bltu	a4,a5,80003164 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003088:	0c0b8863          	beqz	s7,80003158 <writei+0x10e>
    8000308c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003092:	5cfd                	li	s9,-1
    80003094:	a091                	j	800030d8 <writei+0x8e>
    80003096:	02091d93          	slli	s11,s2,0x20
    8000309a:	020ddd93          	srli	s11,s11,0x20
    8000309e:	058a0513          	addi	a0,s4,88 # 2058 <_entry-0x7fffdfa8>
    800030a2:	86ee                	mv	a3,s11
    800030a4:	8656                	mv	a2,s5
    800030a6:	85e2                	mv	a1,s8
    800030a8:	953a                	add	a0,a0,a4
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	924080e7          	jalr	-1756(ra) # 800019ce <either_copyin>
    800030b2:	07950263          	beq	a0,s9,80003116 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030b6:	8552                	mv	a0,s4
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	792080e7          	jalr	1938(ra) # 8000384a <log_write>
    brelse(bp);
    800030c0:	8552                	mv	a0,s4
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	4be080e7          	jalr	1214(ra) # 80002580 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ca:	013909bb          	addw	s3,s2,s3
    800030ce:	009904bb          	addw	s1,s2,s1
    800030d2:	9aee                	add	s5,s5,s11
    800030d4:	0579f663          	bleu	s7,s3,80003120 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030d8:	00a4d59b          	srliw	a1,s1,0xa
    800030dc:	855a                	mv	a0,s6
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	79c080e7          	jalr	1948(ra) # 8000287a <bmap>
    800030e6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030ea:	c99d                	beqz	a1,80003120 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030ec:	000b2503          	lw	a0,0(s6)
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	34e080e7          	jalr	846(ra) # 8000243e <bread>
    800030f8:	8a2a                	mv	s4,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fa:	3ff4f713          	andi	a4,s1,1023
    800030fe:	40ed07bb          	subw	a5,s10,a4
    80003102:	413b86bb          	subw	a3,s7,s3
    80003106:	893e                	mv	s2,a5
    80003108:	2781                	sext.w	a5,a5
    8000310a:	0006861b          	sext.w	a2,a3
    8000310e:	f8f674e3          	bleu	a5,a2,80003096 <writei+0x4c>
    80003112:	8936                	mv	s2,a3
    80003114:	b749                	j	80003096 <writei+0x4c>
      brelse(bp);
    80003116:	8552                	mv	a0,s4
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	468080e7          	jalr	1128(ra) # 80002580 <brelse>
  }

  if(off > ip->size)
    80003120:	04cb2783          	lw	a5,76(s6)
    80003124:	0097f463          	bleu	s1,a5,8000312c <writei+0xe2>
    ip->size = off;
    80003128:	049b2623          	sw	s1,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000312c:	855a                	mv	a0,s6
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	aa2080e7          	jalr	-1374(ra) # 80002bd0 <iupdate>

  return tot;
    80003136:	0009851b          	sext.w	a0,s3
}
    8000313a:	70a6                	ld	ra,104(sp)
    8000313c:	7406                	ld	s0,96(sp)
    8000313e:	64e6                	ld	s1,88(sp)
    80003140:	6946                	ld	s2,80(sp)
    80003142:	69a6                	ld	s3,72(sp)
    80003144:	6a06                	ld	s4,64(sp)
    80003146:	7ae2                	ld	s5,56(sp)
    80003148:	7b42                	ld	s6,48(sp)
    8000314a:	7ba2                	ld	s7,40(sp)
    8000314c:	7c02                	ld	s8,32(sp)
    8000314e:	6ce2                	ld	s9,24(sp)
    80003150:	6d42                	ld	s10,16(sp)
    80003152:	6da2                	ld	s11,8(sp)
    80003154:	6165                	addi	sp,sp,112
    80003156:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003158:	89de                	mv	s3,s7
    8000315a:	bfc9                	j	8000312c <writei+0xe2>
    return -1;
    8000315c:	557d                	li	a0,-1
}
    8000315e:	8082                	ret
    return -1;
    80003160:	557d                	li	a0,-1
    80003162:	bfe1                	j	8000313a <writei+0xf0>
    return -1;
    80003164:	557d                	li	a0,-1
    80003166:	bfd1                	j	8000313a <writei+0xf0>

0000000080003168 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003168:	1141                	addi	sp,sp,-16
    8000316a:	e406                	sd	ra,8(sp)
    8000316c:	e022                	sd	s0,0(sp)
    8000316e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003170:	4639                	li	a2,14
    80003172:	ffffd097          	auipc	ra,0xffffd
    80003176:	116080e7          	jalr	278(ra) # 80000288 <strncmp>
}
    8000317a:	60a2                	ld	ra,8(sp)
    8000317c:	6402                	ld	s0,0(sp)
    8000317e:	0141                	addi	sp,sp,16
    80003180:	8082                	ret

0000000080003182 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003182:	7139                	addi	sp,sp,-64
    80003184:	fc06                	sd	ra,56(sp)
    80003186:	f822                	sd	s0,48(sp)
    80003188:	f426                	sd	s1,40(sp)
    8000318a:	f04a                	sd	s2,32(sp)
    8000318c:	ec4e                	sd	s3,24(sp)
    8000318e:	e852                	sd	s4,16(sp)
    80003190:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003192:	04451703          	lh	a4,68(a0)
    80003196:	4785                	li	a5,1
    80003198:	00f71a63          	bne	a4,a5,800031ac <dirlookup+0x2a>
    8000319c:	892a                	mv	s2,a0
    8000319e:	89ae                	mv	s3,a1
    800031a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a2:	457c                	lw	a5,76(a0)
    800031a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a8:	e79d                	bnez	a5,800031d6 <dirlookup+0x54>
    800031aa:	a8a5                	j	80003222 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031ac:	00005517          	auipc	a0,0x5
    800031b0:	54c50513          	addi	a0,a0,1356 # 800086f8 <syscall_name_list+0x290>
    800031b4:	00003097          	auipc	ra,0x3
    800031b8:	ca4080e7          	jalr	-860(ra) # 80005e58 <panic>
      panic("dirlookup read");
    800031bc:	00005517          	auipc	a0,0x5
    800031c0:	55450513          	addi	a0,a0,1364 # 80008710 <syscall_name_list+0x2a8>
    800031c4:	00003097          	auipc	ra,0x3
    800031c8:	c94080e7          	jalr	-876(ra) # 80005e58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031cc:	24c1                	addiw	s1,s1,16
    800031ce:	04c92783          	lw	a5,76(s2)
    800031d2:	04f4f763          	bleu	a5,s1,80003220 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031d6:	4741                	li	a4,16
    800031d8:	86a6                	mv	a3,s1
    800031da:	fc040613          	addi	a2,s0,-64
    800031de:	4581                	li	a1,0
    800031e0:	854a                	mv	a0,s2
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	d70080e7          	jalr	-656(ra) # 80002f52 <readi>
    800031ea:	47c1                	li	a5,16
    800031ec:	fcf518e3          	bne	a0,a5,800031bc <dirlookup+0x3a>
    if(de.inum == 0)
    800031f0:	fc045783          	lhu	a5,-64(s0)
    800031f4:	dfe1                	beqz	a5,800031cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031f6:	fc240593          	addi	a1,s0,-62
    800031fa:	854e                	mv	a0,s3
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	f6c080e7          	jalr	-148(ra) # 80003168 <namecmp>
    80003204:	f561                	bnez	a0,800031cc <dirlookup+0x4a>
      if(poff)
    80003206:	000a0463          	beqz	s4,8000320e <dirlookup+0x8c>
        *poff = off;
    8000320a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000320e:	fc045583          	lhu	a1,-64(s0)
    80003212:	00092503          	lw	a0,0(s2)
    80003216:	fffff097          	auipc	ra,0xfffff
    8000321a:	74c080e7          	jalr	1868(ra) # 80002962 <iget>
    8000321e:	a011                	j	80003222 <dirlookup+0xa0>
  return 0;
    80003220:	4501                	li	a0,0
}
    80003222:	70e2                	ld	ra,56(sp)
    80003224:	7442                	ld	s0,48(sp)
    80003226:	74a2                	ld	s1,40(sp)
    80003228:	7902                	ld	s2,32(sp)
    8000322a:	69e2                	ld	s3,24(sp)
    8000322c:	6a42                	ld	s4,16(sp)
    8000322e:	6121                	addi	sp,sp,64
    80003230:	8082                	ret

0000000080003232 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003232:	711d                	addi	sp,sp,-96
    80003234:	ec86                	sd	ra,88(sp)
    80003236:	e8a2                	sd	s0,80(sp)
    80003238:	e4a6                	sd	s1,72(sp)
    8000323a:	e0ca                	sd	s2,64(sp)
    8000323c:	fc4e                	sd	s3,56(sp)
    8000323e:	f852                	sd	s4,48(sp)
    80003240:	f456                	sd	s5,40(sp)
    80003242:	f05a                	sd	s6,32(sp)
    80003244:	ec5e                	sd	s7,24(sp)
    80003246:	e862                	sd	s8,16(sp)
    80003248:	e466                	sd	s9,8(sp)
    8000324a:	1080                	addi	s0,sp,96
    8000324c:	84aa                	mv	s1,a0
    8000324e:	8bae                	mv	s7,a1
    80003250:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003252:	00054703          	lbu	a4,0(a0)
    80003256:	02f00793          	li	a5,47
    8000325a:	02f70363          	beq	a4,a5,80003280 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000325e:	ffffe097          	auipc	ra,0xffffe
    80003262:	c60080e7          	jalr	-928(ra) # 80000ebe <myproc>
    80003266:	15053503          	ld	a0,336(a0)
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	9f4080e7          	jalr	-1548(ra) # 80002c5e <idup>
    80003272:	89aa                	mv	s3,a0
  while(*path == '/')
    80003274:	02f00913          	li	s2,47
  len = path - s;
    80003278:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000327a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000327c:	4c05                	li	s8,1
    8000327e:	a865                	j	80003336 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003280:	4585                	li	a1,1
    80003282:	4505                	li	a0,1
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	6de080e7          	jalr	1758(ra) # 80002962 <iget>
    8000328c:	89aa                	mv	s3,a0
    8000328e:	b7dd                	j	80003274 <namex+0x42>
      iunlockput(ip);
    80003290:	854e                	mv	a0,s3
    80003292:	00000097          	auipc	ra,0x0
    80003296:	c6e080e7          	jalr	-914(ra) # 80002f00 <iunlockput>
      return 0;
    8000329a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000329c:	854e                	mv	a0,s3
    8000329e:	60e6                	ld	ra,88(sp)
    800032a0:	6446                	ld	s0,80(sp)
    800032a2:	64a6                	ld	s1,72(sp)
    800032a4:	6906                	ld	s2,64(sp)
    800032a6:	79e2                	ld	s3,56(sp)
    800032a8:	7a42                	ld	s4,48(sp)
    800032aa:	7aa2                	ld	s5,40(sp)
    800032ac:	7b02                	ld	s6,32(sp)
    800032ae:	6be2                	ld	s7,24(sp)
    800032b0:	6c42                	ld	s8,16(sp)
    800032b2:	6ca2                	ld	s9,8(sp)
    800032b4:	6125                	addi	sp,sp,96
    800032b6:	8082                	ret
      iunlock(ip);
    800032b8:	854e                	mv	a0,s3
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	aa6080e7          	jalr	-1370(ra) # 80002d60 <iunlock>
      return ip;
    800032c2:	bfe9                	j	8000329c <namex+0x6a>
      iunlockput(ip);
    800032c4:	854e                	mv	a0,s3
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	c3a080e7          	jalr	-966(ra) # 80002f00 <iunlockput>
      return 0;
    800032ce:	89d2                	mv	s3,s4
    800032d0:	b7f1                	j	8000329c <namex+0x6a>
  len = path - s;
    800032d2:	40b48633          	sub	a2,s1,a1
    800032d6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032da:	094cd663          	ble	s4,s9,80003366 <namex+0x134>
    memmove(name, s, DIRSIZ);
    800032de:	4639                	li	a2,14
    800032e0:	8556                	mv	a0,s5
    800032e2:	ffffd097          	auipc	ra,0xffffd
    800032e6:	f2e080e7          	jalr	-210(ra) # 80000210 <memmove>
  while(*path == '/')
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	01279763          	bne	a5,s2,800032fc <namex+0xca>
    path++;
    800032f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	ff278de3          	beq	a5,s2,800032f2 <namex+0xc0>
    ilock(ip);
    800032fc:	854e                	mv	a0,s3
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	99e080e7          	jalr	-1634(ra) # 80002c9c <ilock>
    if(ip->type != T_DIR){
    80003306:	04499783          	lh	a5,68(s3)
    8000330a:	f98793e3          	bne	a5,s8,80003290 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000330e:	000b8563          	beqz	s7,80003318 <namex+0xe6>
    80003312:	0004c783          	lbu	a5,0(s1)
    80003316:	d3cd                	beqz	a5,800032b8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003318:	865a                	mv	a2,s6
    8000331a:	85d6                	mv	a1,s5
    8000331c:	854e                	mv	a0,s3
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	e64080e7          	jalr	-412(ra) # 80003182 <dirlookup>
    80003326:	8a2a                	mv	s4,a0
    80003328:	dd51                	beqz	a0,800032c4 <namex+0x92>
    iunlockput(ip);
    8000332a:	854e                	mv	a0,s3
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	bd4080e7          	jalr	-1068(ra) # 80002f00 <iunlockput>
    ip = next;
    80003334:	89d2                	mv	s3,s4
  while(*path == '/')
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	05279d63          	bne	a5,s2,80003394 <namex+0x162>
    path++;
    8000333e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003340:	0004c783          	lbu	a5,0(s1)
    80003344:	ff278de3          	beq	a5,s2,8000333e <namex+0x10c>
  if(*path == 0)
    80003348:	cf8d                	beqz	a5,80003382 <namex+0x150>
  while(*path != '/' && *path != 0)
    8000334a:	01278b63          	beq	a5,s2,80003360 <namex+0x12e>
    8000334e:	c795                	beqz	a5,8000337a <namex+0x148>
    path++;
    80003350:	85a6                	mv	a1,s1
    path++;
    80003352:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003354:	0004c783          	lbu	a5,0(s1)
    80003358:	f7278de3          	beq	a5,s2,800032d2 <namex+0xa0>
    8000335c:	fbfd                	bnez	a5,80003352 <namex+0x120>
    8000335e:	bf95                	j	800032d2 <namex+0xa0>
    80003360:	85a6                	mv	a1,s1
  len = path - s;
    80003362:	8a5a                	mv	s4,s6
    80003364:	865a                	mv	a2,s6
    memmove(name, s, len);
    80003366:	2601                	sext.w	a2,a2
    80003368:	8556                	mv	a0,s5
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	ea6080e7          	jalr	-346(ra) # 80000210 <memmove>
    name[len] = 0;
    80003372:	9a56                	add	s4,s4,s5
    80003374:	000a0023          	sb	zero,0(s4)
    80003378:	bf8d                	j	800032ea <namex+0xb8>
  while(*path != '/' && *path != 0)
    8000337a:	85a6                	mv	a1,s1
  len = path - s;
    8000337c:	8a5a                	mv	s4,s6
    8000337e:	865a                	mv	a2,s6
    80003380:	b7dd                	j	80003366 <namex+0x134>
  if(nameiparent){
    80003382:	f00b8de3          	beqz	s7,8000329c <namex+0x6a>
    iput(ip);
    80003386:	854e                	mv	a0,s3
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	ad0080e7          	jalr	-1328(ra) # 80002e58 <iput>
    return 0;
    80003390:	4981                	li	s3,0
    80003392:	b729                	j	8000329c <namex+0x6a>
  if(*path == 0)
    80003394:	d7fd                	beqz	a5,80003382 <namex+0x150>
    80003396:	85a6                	mv	a1,s1
    80003398:	bf6d                	j	80003352 <namex+0x120>

000000008000339a <dirlink>:
{
    8000339a:	7139                	addi	sp,sp,-64
    8000339c:	fc06                	sd	ra,56(sp)
    8000339e:	f822                	sd	s0,48(sp)
    800033a0:	f426                	sd	s1,40(sp)
    800033a2:	f04a                	sd	s2,32(sp)
    800033a4:	ec4e                	sd	s3,24(sp)
    800033a6:	e852                	sd	s4,16(sp)
    800033a8:	0080                	addi	s0,sp,64
    800033aa:	892a                	mv	s2,a0
    800033ac:	8a2e                	mv	s4,a1
    800033ae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033b0:	4601                	li	a2,0
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	dd0080e7          	jalr	-560(ra) # 80003182 <dirlookup>
    800033ba:	ed25                	bnez	a0,80003432 <dirlink+0x98>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033bc:	04c92483          	lw	s1,76(s2)
    800033c0:	c49d                	beqz	s1,800033ee <dirlink+0x54>
    800033c2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c4:	4741                	li	a4,16
    800033c6:	86a6                	mv	a3,s1
    800033c8:	fc040613          	addi	a2,s0,-64
    800033cc:	4581                	li	a1,0
    800033ce:	854a                	mv	a0,s2
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	b82080e7          	jalr	-1150(ra) # 80002f52 <readi>
    800033d8:	47c1                	li	a5,16
    800033da:	06f51263          	bne	a0,a5,8000343e <dirlink+0xa4>
    if(de.inum == 0)
    800033de:	fc045783          	lhu	a5,-64(s0)
    800033e2:	c791                	beqz	a5,800033ee <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e4:	24c1                	addiw	s1,s1,16
    800033e6:	04c92783          	lw	a5,76(s2)
    800033ea:	fcf4ede3          	bltu	s1,a5,800033c4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033ee:	4639                	li	a2,14
    800033f0:	85d2                	mv	a1,s4
    800033f2:	fc240513          	addi	a0,s0,-62
    800033f6:	ffffd097          	auipc	ra,0xffffd
    800033fa:	ee2080e7          	jalr	-286(ra) # 800002d8 <strncpy>
  de.inum = inum;
    800033fe:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003402:	4741                	li	a4,16
    80003404:	86a6                	mv	a3,s1
    80003406:	fc040613          	addi	a2,s0,-64
    8000340a:	4581                	li	a1,0
    8000340c:	854a                	mv	a0,s2
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	c3c080e7          	jalr	-964(ra) # 8000304a <writei>
    80003416:	1541                	addi	a0,a0,-16
    80003418:	00a03533          	snez	a0,a0
    8000341c:	40a0053b          	negw	a0,a0
    80003420:	2501                	sext.w	a0,a0
}
    80003422:	70e2                	ld	ra,56(sp)
    80003424:	7442                	ld	s0,48(sp)
    80003426:	74a2                	ld	s1,40(sp)
    80003428:	7902                	ld	s2,32(sp)
    8000342a:	69e2                	ld	s3,24(sp)
    8000342c:	6a42                	ld	s4,16(sp)
    8000342e:	6121                	addi	sp,sp,64
    80003430:	8082                	ret
    iput(ip);
    80003432:	00000097          	auipc	ra,0x0
    80003436:	a26080e7          	jalr	-1498(ra) # 80002e58 <iput>
    return -1;
    8000343a:	557d                	li	a0,-1
    8000343c:	b7dd                	j	80003422 <dirlink+0x88>
      panic("dirlink read");
    8000343e:	00005517          	auipc	a0,0x5
    80003442:	2e250513          	addi	a0,a0,738 # 80008720 <syscall_name_list+0x2b8>
    80003446:	00003097          	auipc	ra,0x3
    8000344a:	a12080e7          	jalr	-1518(ra) # 80005e58 <panic>

000000008000344e <namei>:

struct inode*
namei(char *path)
{
    8000344e:	1101                	addi	sp,sp,-32
    80003450:	ec06                	sd	ra,24(sp)
    80003452:	e822                	sd	s0,16(sp)
    80003454:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003456:	fe040613          	addi	a2,s0,-32
    8000345a:	4581                	li	a1,0
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	dd6080e7          	jalr	-554(ra) # 80003232 <namex>
}
    80003464:	60e2                	ld	ra,24(sp)
    80003466:	6442                	ld	s0,16(sp)
    80003468:	6105                	addi	sp,sp,32
    8000346a:	8082                	ret

000000008000346c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000346c:	1141                	addi	sp,sp,-16
    8000346e:	e406                	sd	ra,8(sp)
    80003470:	e022                	sd	s0,0(sp)
    80003472:	0800                	addi	s0,sp,16
  return namex(path, 1, name);
    80003474:	862e                	mv	a2,a1
    80003476:	4585                	li	a1,1
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	dba080e7          	jalr	-582(ra) # 80003232 <namex>
}
    80003480:	60a2                	ld	ra,8(sp)
    80003482:	6402                	ld	s0,0(sp)
    80003484:	0141                	addi	sp,sp,16
    80003486:	8082                	ret

0000000080003488 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	e426                	sd	s1,8(sp)
    80003490:	e04a                	sd	s2,0(sp)
    80003492:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003494:	00015917          	auipc	s2,0x15
    80003498:	7bc90913          	addi	s2,s2,1980 # 80018c50 <log>
    8000349c:	01892583          	lw	a1,24(s2)
    800034a0:	02892503          	lw	a0,40(s2)
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	f9a080e7          	jalr	-102(ra) # 8000243e <bread>
    800034ac:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ae:	02c92683          	lw	a3,44(s2)
    800034b2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034b4:	02d05763          	blez	a3,800034e2 <write_head+0x5a>
    800034b8:	00015797          	auipc	a5,0x15
    800034bc:	7c878793          	addi	a5,a5,1992 # 80018c80 <log+0x30>
    800034c0:	05c50713          	addi	a4,a0,92
    800034c4:	36fd                	addiw	a3,a3,-1
    800034c6:	1682                	slli	a3,a3,0x20
    800034c8:	9281                	srli	a3,a3,0x20
    800034ca:	068a                	slli	a3,a3,0x2
    800034cc:	00015617          	auipc	a2,0x15
    800034d0:	7b860613          	addi	a2,a2,1976 # 80018c84 <log+0x34>
    800034d4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034d6:	4390                	lw	a2,0(a5)
    800034d8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034da:	0791                	addi	a5,a5,4
    800034dc:	0711                	addi	a4,a4,4
    800034de:	fed79ce3          	bne	a5,a3,800034d6 <write_head+0x4e>
  }
  bwrite(buf);
    800034e2:	8526                	mv	a0,s1
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	05e080e7          	jalr	94(ra) # 80002542 <bwrite>
  brelse(buf);
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	092080e7          	jalr	146(ra) # 80002580 <brelse>
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6902                	ld	s2,0(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret

0000000080003502 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003502:	00015797          	auipc	a5,0x15
    80003506:	74e78793          	addi	a5,a5,1870 # 80018c50 <log>
    8000350a:	57dc                	lw	a5,44(a5)
    8000350c:	0af05d63          	blez	a5,800035c6 <install_trans+0xc4>
{
    80003510:	7139                	addi	sp,sp,-64
    80003512:	fc06                	sd	ra,56(sp)
    80003514:	f822                	sd	s0,48(sp)
    80003516:	f426                	sd	s1,40(sp)
    80003518:	f04a                	sd	s2,32(sp)
    8000351a:	ec4e                	sd	s3,24(sp)
    8000351c:	e852                	sd	s4,16(sp)
    8000351e:	e456                	sd	s5,8(sp)
    80003520:	e05a                	sd	s6,0(sp)
    80003522:	0080                	addi	s0,sp,64
    80003524:	8b2a                	mv	s6,a0
    80003526:	00015a17          	auipc	s4,0x15
    8000352a:	75aa0a13          	addi	s4,s4,1882 # 80018c80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352e:	4981                	li	s3,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003530:	00015917          	auipc	s2,0x15
    80003534:	72090913          	addi	s2,s2,1824 # 80018c50 <log>
    80003538:	a035                	j	80003564 <install_trans+0x62>
      bunpin(dbuf);
    8000353a:	8526                	mv	a0,s1
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	11e080e7          	jalr	286(ra) # 8000265a <bunpin>
    brelse(lbuf);
    80003544:	8556                	mv	a0,s5
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	03a080e7          	jalr	58(ra) # 80002580 <brelse>
    brelse(dbuf);
    8000354e:	8526                	mv	a0,s1
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	030080e7          	jalr	48(ra) # 80002580 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003558:	2985                	addiw	s3,s3,1
    8000355a:	0a11                	addi	s4,s4,4
    8000355c:	02c92783          	lw	a5,44(s2)
    80003560:	04f9d963          	ble	a5,s3,800035b2 <install_trans+0xb0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003564:	01892583          	lw	a1,24(s2)
    80003568:	013585bb          	addw	a1,a1,s3
    8000356c:	2585                	addiw	a1,a1,1
    8000356e:	02892503          	lw	a0,40(s2)
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	ecc080e7          	jalr	-308(ra) # 8000243e <bread>
    8000357a:	8aaa                	mv	s5,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000357c:	000a2583          	lw	a1,0(s4)
    80003580:	02892503          	lw	a0,40(s2)
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	eba080e7          	jalr	-326(ra) # 8000243e <bread>
    8000358c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000358e:	40000613          	li	a2,1024
    80003592:	058a8593          	addi	a1,s5,88
    80003596:	05850513          	addi	a0,a0,88
    8000359a:	ffffd097          	auipc	ra,0xffffd
    8000359e:	c76080e7          	jalr	-906(ra) # 80000210 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035a2:	8526                	mv	a0,s1
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	f9e080e7          	jalr	-98(ra) # 80002542 <bwrite>
    if(recovering == 0)
    800035ac:	f80b1ce3          	bnez	s6,80003544 <install_trans+0x42>
    800035b0:	b769                	j	8000353a <install_trans+0x38>
}
    800035b2:	70e2                	ld	ra,56(sp)
    800035b4:	7442                	ld	s0,48(sp)
    800035b6:	74a2                	ld	s1,40(sp)
    800035b8:	7902                	ld	s2,32(sp)
    800035ba:	69e2                	ld	s3,24(sp)
    800035bc:	6a42                	ld	s4,16(sp)
    800035be:	6aa2                	ld	s5,8(sp)
    800035c0:	6b02                	ld	s6,0(sp)
    800035c2:	6121                	addi	sp,sp,64
    800035c4:	8082                	ret
    800035c6:	8082                	ret

00000000800035c8 <initlog>:
{
    800035c8:	7179                	addi	sp,sp,-48
    800035ca:	f406                	sd	ra,40(sp)
    800035cc:	f022                	sd	s0,32(sp)
    800035ce:	ec26                	sd	s1,24(sp)
    800035d0:	e84a                	sd	s2,16(sp)
    800035d2:	e44e                	sd	s3,8(sp)
    800035d4:	1800                	addi	s0,sp,48
    800035d6:	892a                	mv	s2,a0
    800035d8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035da:	00015497          	auipc	s1,0x15
    800035de:	67648493          	addi	s1,s1,1654 # 80018c50 <log>
    800035e2:	00005597          	auipc	a1,0x5
    800035e6:	14e58593          	addi	a1,a1,334 # 80008730 <syscall_name_list+0x2c8>
    800035ea:	8526                	mv	a0,s1
    800035ec:	00003097          	auipc	ra,0x3
    800035f0:	d48080e7          	jalr	-696(ra) # 80006334 <initlock>
  log.start = sb->logstart;
    800035f4:	0149a583          	lw	a1,20(s3)
    800035f8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035fa:	0109a783          	lw	a5,16(s3)
    800035fe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003600:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003604:	854a                	mv	a0,s2
    80003606:	fffff097          	auipc	ra,0xfffff
    8000360a:	e38080e7          	jalr	-456(ra) # 8000243e <bread>
  log.lh.n = lh->n;
    8000360e:	4d3c                	lw	a5,88(a0)
    80003610:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003612:	02f05563          	blez	a5,8000363c <initlog+0x74>
    80003616:	05c50713          	addi	a4,a0,92
    8000361a:	00015697          	auipc	a3,0x15
    8000361e:	66668693          	addi	a3,a3,1638 # 80018c80 <log+0x30>
    80003622:	37fd                	addiw	a5,a5,-1
    80003624:	1782                	slli	a5,a5,0x20
    80003626:	9381                	srli	a5,a5,0x20
    80003628:	078a                	slli	a5,a5,0x2
    8000362a:	06050613          	addi	a2,a0,96
    8000362e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003630:	4310                	lw	a2,0(a4)
    80003632:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003634:	0711                	addi	a4,a4,4
    80003636:	0691                	addi	a3,a3,4
    80003638:	fef71ce3          	bne	a4,a5,80003630 <initlog+0x68>
  brelse(buf);
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	f44080e7          	jalr	-188(ra) # 80002580 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003644:	4505                	li	a0,1
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	ebc080e7          	jalr	-324(ra) # 80003502 <install_trans>
  log.lh.n = 0;
    8000364e:	00015797          	auipc	a5,0x15
    80003652:	6207a723          	sw	zero,1582(a5) # 80018c7c <log+0x2c>
  write_head(); // clear the log
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	e32080e7          	jalr	-462(ra) # 80003488 <write_head>
}
    8000365e:	70a2                	ld	ra,40(sp)
    80003660:	7402                	ld	s0,32(sp)
    80003662:	64e2                	ld	s1,24(sp)
    80003664:	6942                	ld	s2,16(sp)
    80003666:	69a2                	ld	s3,8(sp)
    80003668:	6145                	addi	sp,sp,48
    8000366a:	8082                	ret

000000008000366c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000366c:	1101                	addi	sp,sp,-32
    8000366e:	ec06                	sd	ra,24(sp)
    80003670:	e822                	sd	s0,16(sp)
    80003672:	e426                	sd	s1,8(sp)
    80003674:	e04a                	sd	s2,0(sp)
    80003676:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003678:	00015517          	auipc	a0,0x15
    8000367c:	5d850513          	addi	a0,a0,1496 # 80018c50 <log>
    80003680:	00003097          	auipc	ra,0x3
    80003684:	d44080e7          	jalr	-700(ra) # 800063c4 <acquire>
  while(1){
    if(log.committing){
    80003688:	00015497          	auipc	s1,0x15
    8000368c:	5c848493          	addi	s1,s1,1480 # 80018c50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003690:	4979                	li	s2,30
    80003692:	a039                	j	800036a0 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003694:	85a6                	mv	a1,s1
    80003696:	8526                	mv	a0,s1
    80003698:	ffffe097          	auipc	ra,0xffffe
    8000369c:	ed6080e7          	jalr	-298(ra) # 8000156e <sleep>
    if(log.committing){
    800036a0:	50dc                	lw	a5,36(s1)
    800036a2:	fbed                	bnez	a5,80003694 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a4:	509c                	lw	a5,32(s1)
    800036a6:	0017871b          	addiw	a4,a5,1
    800036aa:	0007069b          	sext.w	a3,a4
    800036ae:	0027179b          	slliw	a5,a4,0x2
    800036b2:	9fb9                	addw	a5,a5,a4
    800036b4:	0017979b          	slliw	a5,a5,0x1
    800036b8:	54d8                	lw	a4,44(s1)
    800036ba:	9fb9                	addw	a5,a5,a4
    800036bc:	00f95963          	ble	a5,s2,800036ce <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036c0:	85a6                	mv	a1,s1
    800036c2:	8526                	mv	a0,s1
    800036c4:	ffffe097          	auipc	ra,0xffffe
    800036c8:	eaa080e7          	jalr	-342(ra) # 8000156e <sleep>
    800036cc:	bfd1                	j	800036a0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ce:	00015517          	auipc	a0,0x15
    800036d2:	58250513          	addi	a0,a0,1410 # 80018c50 <log>
    800036d6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	da0080e7          	jalr	-608(ra) # 80006478 <release>
      break;
    }
  }
}
    800036e0:	60e2                	ld	ra,24(sp)
    800036e2:	6442                	ld	s0,16(sp)
    800036e4:	64a2                	ld	s1,8(sp)
    800036e6:	6902                	ld	s2,0(sp)
    800036e8:	6105                	addi	sp,sp,32
    800036ea:	8082                	ret

00000000800036ec <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036ec:	7139                	addi	sp,sp,-64
    800036ee:	fc06                	sd	ra,56(sp)
    800036f0:	f822                	sd	s0,48(sp)
    800036f2:	f426                	sd	s1,40(sp)
    800036f4:	f04a                	sd	s2,32(sp)
    800036f6:	ec4e                	sd	s3,24(sp)
    800036f8:	e852                	sd	s4,16(sp)
    800036fa:	e456                	sd	s5,8(sp)
    800036fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036fe:	00015917          	auipc	s2,0x15
    80003702:	55290913          	addi	s2,s2,1362 # 80018c50 <log>
    80003706:	854a                	mv	a0,s2
    80003708:	00003097          	auipc	ra,0x3
    8000370c:	cbc080e7          	jalr	-836(ra) # 800063c4 <acquire>
  log.outstanding -= 1;
    80003710:	02092783          	lw	a5,32(s2)
    80003714:	37fd                	addiw	a5,a5,-1
    80003716:	0007849b          	sext.w	s1,a5
    8000371a:	02f92023          	sw	a5,32(s2)
  if(log.committing)
    8000371e:	02492783          	lw	a5,36(s2)
    80003722:	eba1                	bnez	a5,80003772 <end_op+0x86>
    panic("log.committing");
  if(log.outstanding == 0){
    80003724:	ecb9                	bnez	s1,80003782 <end_op+0x96>
    do_commit = 1;
    log.committing = 1;
    80003726:	00015917          	auipc	s2,0x15
    8000372a:	52a90913          	addi	s2,s2,1322 # 80018c50 <log>
    8000372e:	4785                	li	a5,1
    80003730:	02f92223          	sw	a5,36(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003734:	854a                	mv	a0,s2
    80003736:	00003097          	auipc	ra,0x3
    8000373a:	d42080e7          	jalr	-702(ra) # 80006478 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000373e:	02c92783          	lw	a5,44(s2)
    80003742:	06f04763          	bgtz	a5,800037b0 <end_op+0xc4>
    acquire(&log.lock);
    80003746:	00015497          	auipc	s1,0x15
    8000374a:	50a48493          	addi	s1,s1,1290 # 80018c50 <log>
    8000374e:	8526                	mv	a0,s1
    80003750:	00003097          	auipc	ra,0x3
    80003754:	c74080e7          	jalr	-908(ra) # 800063c4 <acquire>
    log.committing = 0;
    80003758:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	e74080e7          	jalr	-396(ra) # 800015d2 <wakeup>
    release(&log.lock);
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	d10080e7          	jalr	-752(ra) # 80006478 <release>
}
    80003770:	a03d                	j	8000379e <end_op+0xb2>
    panic("log.committing");
    80003772:	00005517          	auipc	a0,0x5
    80003776:	fc650513          	addi	a0,a0,-58 # 80008738 <syscall_name_list+0x2d0>
    8000377a:	00002097          	auipc	ra,0x2
    8000377e:	6de080e7          	jalr	1758(ra) # 80005e58 <panic>
    wakeup(&log);
    80003782:	00015497          	auipc	s1,0x15
    80003786:	4ce48493          	addi	s1,s1,1230 # 80018c50 <log>
    8000378a:	8526                	mv	a0,s1
    8000378c:	ffffe097          	auipc	ra,0xffffe
    80003790:	e46080e7          	jalr	-442(ra) # 800015d2 <wakeup>
  release(&log.lock);
    80003794:	8526                	mv	a0,s1
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	ce2080e7          	jalr	-798(ra) # 80006478 <release>
}
    8000379e:	70e2                	ld	ra,56(sp)
    800037a0:	7442                	ld	s0,48(sp)
    800037a2:	74a2                	ld	s1,40(sp)
    800037a4:	7902                	ld	s2,32(sp)
    800037a6:	69e2                	ld	s3,24(sp)
    800037a8:	6a42                	ld	s4,16(sp)
    800037aa:	6aa2                	ld	s5,8(sp)
    800037ac:	6121                	addi	sp,sp,64
    800037ae:	8082                	ret
    800037b0:	00015a17          	auipc	s4,0x15
    800037b4:	4d0a0a13          	addi	s4,s4,1232 # 80018c80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037b8:	00015917          	auipc	s2,0x15
    800037bc:	49890913          	addi	s2,s2,1176 # 80018c50 <log>
    800037c0:	01892583          	lw	a1,24(s2)
    800037c4:	9da5                	addw	a1,a1,s1
    800037c6:	2585                	addiw	a1,a1,1
    800037c8:	02892503          	lw	a0,40(s2)
    800037cc:	fffff097          	auipc	ra,0xfffff
    800037d0:	c72080e7          	jalr	-910(ra) # 8000243e <bread>
    800037d4:	89aa                	mv	s3,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037d6:	000a2583          	lw	a1,0(s4)
    800037da:	02892503          	lw	a0,40(s2)
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	c60080e7          	jalr	-928(ra) # 8000243e <bread>
    800037e6:	8aaa                	mv	s5,a0
    memmove(to->data, from->data, BSIZE);
    800037e8:	40000613          	li	a2,1024
    800037ec:	05850593          	addi	a1,a0,88
    800037f0:	05898513          	addi	a0,s3,88
    800037f4:	ffffd097          	auipc	ra,0xffffd
    800037f8:	a1c080e7          	jalr	-1508(ra) # 80000210 <memmove>
    bwrite(to);  // write the log
    800037fc:	854e                	mv	a0,s3
    800037fe:	fffff097          	auipc	ra,0xfffff
    80003802:	d44080e7          	jalr	-700(ra) # 80002542 <bwrite>
    brelse(from);
    80003806:	8556                	mv	a0,s5
    80003808:	fffff097          	auipc	ra,0xfffff
    8000380c:	d78080e7          	jalr	-648(ra) # 80002580 <brelse>
    brelse(to);
    80003810:	854e                	mv	a0,s3
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	d6e080e7          	jalr	-658(ra) # 80002580 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000381a:	2485                	addiw	s1,s1,1
    8000381c:	0a11                	addi	s4,s4,4
    8000381e:	02c92783          	lw	a5,44(s2)
    80003822:	f8f4cfe3          	blt	s1,a5,800037c0 <end_op+0xd4>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	c62080e7          	jalr	-926(ra) # 80003488 <write_head>
    install_trans(0); // Now install writes to home locations
    8000382e:	4501                	li	a0,0
    80003830:	00000097          	auipc	ra,0x0
    80003834:	cd2080e7          	jalr	-814(ra) # 80003502 <install_trans>
    log.lh.n = 0;
    80003838:	00015797          	auipc	a5,0x15
    8000383c:	4407a223          	sw	zero,1092(a5) # 80018c7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003840:	00000097          	auipc	ra,0x0
    80003844:	c48080e7          	jalr	-952(ra) # 80003488 <write_head>
    80003848:	bdfd                	j	80003746 <end_op+0x5a>

000000008000384a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000384a:	1101                	addi	sp,sp,-32
    8000384c:	ec06                	sd	ra,24(sp)
    8000384e:	e822                	sd	s0,16(sp)
    80003850:	e426                	sd	s1,8(sp)
    80003852:	e04a                	sd	s2,0(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	892a                	mv	s2,a0
  int i;

  acquire(&log.lock);
    80003858:	00015497          	auipc	s1,0x15
    8000385c:	3f848493          	addi	s1,s1,1016 # 80018c50 <log>
    80003860:	8526                	mv	a0,s1
    80003862:	00003097          	auipc	ra,0x3
    80003866:	b62080e7          	jalr	-1182(ra) # 800063c4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000386a:	54d0                	lw	a2,44(s1)
    8000386c:	47f5                	li	a5,29
    8000386e:	06c7ca63          	blt	a5,a2,800038e2 <log_write+0x98>
    80003872:	4cdc                	lw	a5,28(s1)
    80003874:	37fd                	addiw	a5,a5,-1
    80003876:	06f65663          	ble	a5,a2,800038e2 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000387a:	00015797          	auipc	a5,0x15
    8000387e:	3d678793          	addi	a5,a5,982 # 80018c50 <log>
    80003882:	539c                	lw	a5,32(a5)
    80003884:	06f05763          	blez	a5,800038f2 <log_write+0xa8>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003888:	0ac05463          	blez	a2,80003930 <log_write+0xe6>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000388c:	00c92583          	lw	a1,12(s2)
    80003890:	00015797          	auipc	a5,0x15
    80003894:	3c078793          	addi	a5,a5,960 # 80018c50 <log>
    80003898:	5b9c                	lw	a5,48(a5)
    8000389a:	0ab78363          	beq	a5,a1,80003940 <log_write+0xf6>
    8000389e:	00015717          	auipc	a4,0x15
    800038a2:	3e670713          	addi	a4,a4,998 # 80018c84 <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    800038a6:	4781                	li	a5,0
    800038a8:	2785                	addiw	a5,a5,1
    800038aa:	04f60c63          	beq	a2,a5,80003902 <log_write+0xb8>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ae:	4314                	lw	a3,0(a4)
    800038b0:	0711                	addi	a4,a4,4
    800038b2:	feb69be3          	bne	a3,a1,800038a8 <log_write+0x5e>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038b6:	07a1                	addi	a5,a5,8
    800038b8:	078a                	slli	a5,a5,0x2
    800038ba:	00015717          	auipc	a4,0x15
    800038be:	39670713          	addi	a4,a4,918 # 80018c50 <log>
    800038c2:	97ba                	add	a5,a5,a4
    800038c4:	cb8c                	sw	a1,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
    800038c6:	00015517          	auipc	a0,0x15
    800038ca:	38a50513          	addi	a0,a0,906 # 80018c50 <log>
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	baa080e7          	jalr	-1110(ra) # 80006478 <release>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret
    panic("too big a transaction");
    800038e2:	00005517          	auipc	a0,0x5
    800038e6:	e6650513          	addi	a0,a0,-410 # 80008748 <syscall_name_list+0x2e0>
    800038ea:	00002097          	auipc	ra,0x2
    800038ee:	56e080e7          	jalr	1390(ra) # 80005e58 <panic>
    panic("log_write outside of trans");
    800038f2:	00005517          	auipc	a0,0x5
    800038f6:	e6e50513          	addi	a0,a0,-402 # 80008760 <syscall_name_list+0x2f8>
    800038fa:	00002097          	auipc	ra,0x2
    800038fe:	55e080e7          	jalr	1374(ra) # 80005e58 <panic>
  log.lh.block[i] = b->blockno;
    80003902:	0621                	addi	a2,a2,8
    80003904:	060a                	slli	a2,a2,0x2
    80003906:	00015797          	auipc	a5,0x15
    8000390a:	34a78793          	addi	a5,a5,842 # 80018c50 <log>
    8000390e:	963e                	add	a2,a2,a5
    80003910:	00c92783          	lw	a5,12(s2)
    80003914:	ca1c                	sw	a5,16(a2)
    bpin(b);
    80003916:	854a                	mv	a0,s2
    80003918:	fffff097          	auipc	ra,0xfffff
    8000391c:	d06080e7          	jalr	-762(ra) # 8000261e <bpin>
    log.lh.n++;
    80003920:	00015717          	auipc	a4,0x15
    80003924:	33070713          	addi	a4,a4,816 # 80018c50 <log>
    80003928:	575c                	lw	a5,44(a4)
    8000392a:	2785                	addiw	a5,a5,1
    8000392c:	d75c                	sw	a5,44(a4)
    8000392e:	bf61                	j	800038c6 <log_write+0x7c>
  log.lh.block[i] = b->blockno;
    80003930:	00c92783          	lw	a5,12(s2)
    80003934:	00015717          	auipc	a4,0x15
    80003938:	34f72623          	sw	a5,844(a4) # 80018c80 <log+0x30>
  if (i == log.lh.n) {  // Add new block to log?
    8000393c:	f649                	bnez	a2,800038c6 <log_write+0x7c>
    8000393e:	bfe1                	j	80003916 <log_write+0xcc>
  for (i = 0; i < log.lh.n; i++) {
    80003940:	4781                	li	a5,0
    80003942:	bf95                	j	800038b6 <log_write+0x6c>

0000000080003944 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003944:	1101                	addi	sp,sp,-32
    80003946:	ec06                	sd	ra,24(sp)
    80003948:	e822                	sd	s0,16(sp)
    8000394a:	e426                	sd	s1,8(sp)
    8000394c:	e04a                	sd	s2,0(sp)
    8000394e:	1000                	addi	s0,sp,32
    80003950:	84aa                	mv	s1,a0
    80003952:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003954:	00005597          	auipc	a1,0x5
    80003958:	e2c58593          	addi	a1,a1,-468 # 80008780 <syscall_name_list+0x318>
    8000395c:	0521                	addi	a0,a0,8
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	9d6080e7          	jalr	-1578(ra) # 80006334 <initlock>
  lk->name = name;
    80003966:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000396a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000396e:	0204a423          	sw	zero,40(s1)
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000397e:	1101                	addi	sp,sp,-32
    80003980:	ec06                	sd	ra,24(sp)
    80003982:	e822                	sd	s0,16(sp)
    80003984:	e426                	sd	s1,8(sp)
    80003986:	e04a                	sd	s2,0(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000398c:	00850913          	addi	s2,a0,8
    80003990:	854a                	mv	a0,s2
    80003992:	00003097          	auipc	ra,0x3
    80003996:	a32080e7          	jalr	-1486(ra) # 800063c4 <acquire>
  while (lk->locked) {
    8000399a:	409c                	lw	a5,0(s1)
    8000399c:	cb89                	beqz	a5,800039ae <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000399e:	85ca                	mv	a1,s2
    800039a0:	8526                	mv	a0,s1
    800039a2:	ffffe097          	auipc	ra,0xffffe
    800039a6:	bcc080e7          	jalr	-1076(ra) # 8000156e <sleep>
  while (lk->locked) {
    800039aa:	409c                	lw	a5,0(s1)
    800039ac:	fbed                	bnez	a5,8000399e <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ae:	4785                	li	a5,1
    800039b0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039b2:	ffffd097          	auipc	ra,0xffffd
    800039b6:	50c080e7          	jalr	1292(ra) # 80000ebe <myproc>
    800039ba:	591c                	lw	a5,48(a0)
    800039bc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039be:	854a                	mv	a0,s2
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	ab8080e7          	jalr	-1352(ra) # 80006478 <release>
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	e04a                	sd	s2,0(sp)
    800039de:	1000                	addi	s0,sp,32
    800039e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e2:	00850913          	addi	s2,a0,8
    800039e6:	854a                	mv	a0,s2
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	9dc080e7          	jalr	-1572(ra) # 800063c4 <acquire>
  lk->locked = 0;
    800039f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039f4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039f8:	8526                	mv	a0,s1
    800039fa:	ffffe097          	auipc	ra,0xffffe
    800039fe:	bd8080e7          	jalr	-1064(ra) # 800015d2 <wakeup>
  release(&lk->lk);
    80003a02:	854a                	mv	a0,s2
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	a74080e7          	jalr	-1420(ra) # 80006478 <release>
}
    80003a0c:	60e2                	ld	ra,24(sp)
    80003a0e:	6442                	ld	s0,16(sp)
    80003a10:	64a2                	ld	s1,8(sp)
    80003a12:	6902                	ld	s2,0(sp)
    80003a14:	6105                	addi	sp,sp,32
    80003a16:	8082                	ret

0000000080003a18 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a18:	7179                	addi	sp,sp,-48
    80003a1a:	f406                	sd	ra,40(sp)
    80003a1c:	f022                	sd	s0,32(sp)
    80003a1e:	ec26                	sd	s1,24(sp)
    80003a20:	e84a                	sd	s2,16(sp)
    80003a22:	e44e                	sd	s3,8(sp)
    80003a24:	1800                	addi	s0,sp,48
    80003a26:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a28:	00850913          	addi	s2,a0,8
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	996080e7          	jalr	-1642(ra) # 800063c4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a36:	409c                	lw	a5,0(s1)
    80003a38:	ef99                	bnez	a5,80003a56 <holdingsleep+0x3e>
    80003a3a:	4481                	li	s1,0
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	a3a080e7          	jalr	-1478(ra) # 80006478 <release>
  return r;
}
    80003a46:	8526                	mv	a0,s1
    80003a48:	70a2                	ld	ra,40(sp)
    80003a4a:	7402                	ld	s0,32(sp)
    80003a4c:	64e2                	ld	s1,24(sp)
    80003a4e:	6942                	ld	s2,16(sp)
    80003a50:	69a2                	ld	s3,8(sp)
    80003a52:	6145                	addi	sp,sp,48
    80003a54:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a56:	0284a983          	lw	s3,40(s1)
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	464080e7          	jalr	1124(ra) # 80000ebe <myproc>
    80003a62:	5904                	lw	s1,48(a0)
    80003a64:	413484b3          	sub	s1,s1,s3
    80003a68:	0014b493          	seqz	s1,s1
    80003a6c:	bfc1                	j	80003a3c <holdingsleep+0x24>

0000000080003a6e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a6e:	1141                	addi	sp,sp,-16
    80003a70:	e406                	sd	ra,8(sp)
    80003a72:	e022                	sd	s0,0(sp)
    80003a74:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a76:	00005597          	auipc	a1,0x5
    80003a7a:	d1a58593          	addi	a1,a1,-742 # 80008790 <syscall_name_list+0x328>
    80003a7e:	00015517          	auipc	a0,0x15
    80003a82:	31a50513          	addi	a0,a0,794 # 80018d98 <ftable>
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	8ae080e7          	jalr	-1874(ra) # 80006334 <initlock>
}
    80003a8e:	60a2                	ld	ra,8(sp)
    80003a90:	6402                	ld	s0,0(sp)
    80003a92:	0141                	addi	sp,sp,16
    80003a94:	8082                	ret

0000000080003a96 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a96:	1101                	addi	sp,sp,-32
    80003a98:	ec06                	sd	ra,24(sp)
    80003a9a:	e822                	sd	s0,16(sp)
    80003a9c:	e426                	sd	s1,8(sp)
    80003a9e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aa0:	00015517          	auipc	a0,0x15
    80003aa4:	2f850513          	addi	a0,a0,760 # 80018d98 <ftable>
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	91c080e7          	jalr	-1764(ra) # 800063c4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
    80003ab0:	00015797          	auipc	a5,0x15
    80003ab4:	2e878793          	addi	a5,a5,744 # 80018d98 <ftable>
    80003ab8:	4fdc                	lw	a5,28(a5)
    80003aba:	cb8d                	beqz	a5,80003aec <filealloc+0x56>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003abc:	00015497          	auipc	s1,0x15
    80003ac0:	31c48493          	addi	s1,s1,796 # 80018dd8 <ftable+0x40>
    80003ac4:	00016717          	auipc	a4,0x16
    80003ac8:	28c70713          	addi	a4,a4,652 # 80019d50 <disk>
    if(f->ref == 0){
    80003acc:	40dc                	lw	a5,4(s1)
    80003ace:	c39d                	beqz	a5,80003af4 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ad0:	02848493          	addi	s1,s1,40
    80003ad4:	fee49ce3          	bne	s1,a4,80003acc <filealloc+0x36>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ad8:	00015517          	auipc	a0,0x15
    80003adc:	2c050513          	addi	a0,a0,704 # 80018d98 <ftable>
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	998080e7          	jalr	-1640(ra) # 80006478 <release>
  return 0;
    80003ae8:	4481                	li	s1,0
    80003aea:	a839                	j	80003b08 <filealloc+0x72>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aec:	00015497          	auipc	s1,0x15
    80003af0:	2c448493          	addi	s1,s1,708 # 80018db0 <ftable+0x18>
      f->ref = 1;
    80003af4:	4785                	li	a5,1
    80003af6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003af8:	00015517          	auipc	a0,0x15
    80003afc:	2a050513          	addi	a0,a0,672 # 80018d98 <ftable>
    80003b00:	00003097          	auipc	ra,0x3
    80003b04:	978080e7          	jalr	-1672(ra) # 80006478 <release>
}
    80003b08:	8526                	mv	a0,s1
    80003b0a:	60e2                	ld	ra,24(sp)
    80003b0c:	6442                	ld	s0,16(sp)
    80003b0e:	64a2                	ld	s1,8(sp)
    80003b10:	6105                	addi	sp,sp,32
    80003b12:	8082                	ret

0000000080003b14 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b14:	1101                	addi	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	1000                	addi	s0,sp,32
    80003b1e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b20:	00015517          	auipc	a0,0x15
    80003b24:	27850513          	addi	a0,a0,632 # 80018d98 <ftable>
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	89c080e7          	jalr	-1892(ra) # 800063c4 <acquire>
  if(f->ref < 1)
    80003b30:	40dc                	lw	a5,4(s1)
    80003b32:	02f05263          	blez	a5,80003b56 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b36:	2785                	addiw	a5,a5,1
    80003b38:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b3a:	00015517          	auipc	a0,0x15
    80003b3e:	25e50513          	addi	a0,a0,606 # 80018d98 <ftable>
    80003b42:	00003097          	auipc	ra,0x3
    80003b46:	936080e7          	jalr	-1738(ra) # 80006478 <release>
  return f;
}
    80003b4a:	8526                	mv	a0,s1
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	64a2                	ld	s1,8(sp)
    80003b52:	6105                	addi	sp,sp,32
    80003b54:	8082                	ret
    panic("filedup");
    80003b56:	00005517          	auipc	a0,0x5
    80003b5a:	c4250513          	addi	a0,a0,-958 # 80008798 <syscall_name_list+0x330>
    80003b5e:	00002097          	auipc	ra,0x2
    80003b62:	2fa080e7          	jalr	762(ra) # 80005e58 <panic>

0000000080003b66 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b66:	7139                	addi	sp,sp,-64
    80003b68:	fc06                	sd	ra,56(sp)
    80003b6a:	f822                	sd	s0,48(sp)
    80003b6c:	f426                	sd	s1,40(sp)
    80003b6e:	f04a                	sd	s2,32(sp)
    80003b70:	ec4e                	sd	s3,24(sp)
    80003b72:	e852                	sd	s4,16(sp)
    80003b74:	e456                	sd	s5,8(sp)
    80003b76:	0080                	addi	s0,sp,64
    80003b78:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b7a:	00015517          	auipc	a0,0x15
    80003b7e:	21e50513          	addi	a0,a0,542 # 80018d98 <ftable>
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	842080e7          	jalr	-1982(ra) # 800063c4 <acquire>
  if(f->ref < 1)
    80003b8a:	40dc                	lw	a5,4(s1)
    80003b8c:	06f05163          	blez	a5,80003bee <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b90:	37fd                	addiw	a5,a5,-1
    80003b92:	0007871b          	sext.w	a4,a5
    80003b96:	c0dc                	sw	a5,4(s1)
    80003b98:	06e04363          	bgtz	a4,80003bfe <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b9c:	0004a903          	lw	s2,0(s1)
    80003ba0:	0094ca83          	lbu	s5,9(s1)
    80003ba4:	0104ba03          	ld	s4,16(s1)
    80003ba8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bac:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bb0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bb4:	00015517          	auipc	a0,0x15
    80003bb8:	1e450513          	addi	a0,a0,484 # 80018d98 <ftable>
    80003bbc:	00003097          	auipc	ra,0x3
    80003bc0:	8bc080e7          	jalr	-1860(ra) # 80006478 <release>

  if(ff.type == FD_PIPE){
    80003bc4:	4785                	li	a5,1
    80003bc6:	04f90d63          	beq	s2,a5,80003c20 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bca:	3979                	addiw	s2,s2,-2
    80003bcc:	4785                	li	a5,1
    80003bce:	0527e063          	bltu	a5,s2,80003c0e <fileclose+0xa8>
    begin_op();
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	a9a080e7          	jalr	-1382(ra) # 8000366c <begin_op>
    iput(ff.ip);
    80003bda:	854e                	mv	a0,s3
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	27c080e7          	jalr	636(ra) # 80002e58 <iput>
    end_op();
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	b08080e7          	jalr	-1272(ra) # 800036ec <end_op>
    80003bec:	a00d                	j	80003c0e <fileclose+0xa8>
    panic("fileclose");
    80003bee:	00005517          	auipc	a0,0x5
    80003bf2:	bb250513          	addi	a0,a0,-1102 # 800087a0 <syscall_name_list+0x338>
    80003bf6:	00002097          	auipc	ra,0x2
    80003bfa:	262080e7          	jalr	610(ra) # 80005e58 <panic>
    release(&ftable.lock);
    80003bfe:	00015517          	auipc	a0,0x15
    80003c02:	19a50513          	addi	a0,a0,410 # 80018d98 <ftable>
    80003c06:	00003097          	auipc	ra,0x3
    80003c0a:	872080e7          	jalr	-1934(ra) # 80006478 <release>
  }
}
    80003c0e:	70e2                	ld	ra,56(sp)
    80003c10:	7442                	ld	s0,48(sp)
    80003c12:	74a2                	ld	s1,40(sp)
    80003c14:	7902                	ld	s2,32(sp)
    80003c16:	69e2                	ld	s3,24(sp)
    80003c18:	6a42                	ld	s4,16(sp)
    80003c1a:	6aa2                	ld	s5,8(sp)
    80003c1c:	6121                	addi	sp,sp,64
    80003c1e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c20:	85d6                	mv	a1,s5
    80003c22:	8552                	mv	a0,s4
    80003c24:	00000097          	auipc	ra,0x0
    80003c28:	340080e7          	jalr	832(ra) # 80003f64 <pipeclose>
    80003c2c:	b7cd                	j	80003c0e <fileclose+0xa8>

0000000080003c2e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c2e:	715d                	addi	sp,sp,-80
    80003c30:	e486                	sd	ra,72(sp)
    80003c32:	e0a2                	sd	s0,64(sp)
    80003c34:	fc26                	sd	s1,56(sp)
    80003c36:	f84a                	sd	s2,48(sp)
    80003c38:	f44e                	sd	s3,40(sp)
    80003c3a:	0880                	addi	s0,sp,80
    80003c3c:	84aa                	mv	s1,a0
    80003c3e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c40:	ffffd097          	auipc	ra,0xffffd
    80003c44:	27e080e7          	jalr	638(ra) # 80000ebe <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c48:	409c                	lw	a5,0(s1)
    80003c4a:	37f9                	addiw	a5,a5,-2
    80003c4c:	4705                	li	a4,1
    80003c4e:	04f76763          	bltu	a4,a5,80003c9c <filestat+0x6e>
    80003c52:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c54:	6c88                	ld	a0,24(s1)
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	046080e7          	jalr	70(ra) # 80002c9c <ilock>
    stati(f->ip, &st);
    80003c5e:	fb840593          	addi	a1,s0,-72
    80003c62:	6c88                	ld	a0,24(s1)
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	2c4080e7          	jalr	708(ra) # 80002f28 <stati>
    iunlock(f->ip);
    80003c6c:	6c88                	ld	a0,24(s1)
    80003c6e:	fffff097          	auipc	ra,0xfffff
    80003c72:	0f2080e7          	jalr	242(ra) # 80002d60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c76:	46e1                	li	a3,24
    80003c78:	fb840613          	addi	a2,s0,-72
    80003c7c:	85ce                	mv	a1,s3
    80003c7e:	05093503          	ld	a0,80(s2)
    80003c82:	ffffd097          	auipc	ra,0xffffd
    80003c86:	ee2080e7          	jalr	-286(ra) # 80000b64 <copyout>
    80003c8a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c8e:	60a6                	ld	ra,72(sp)
    80003c90:	6406                	ld	s0,64(sp)
    80003c92:	74e2                	ld	s1,56(sp)
    80003c94:	7942                	ld	s2,48(sp)
    80003c96:	79a2                	ld	s3,40(sp)
    80003c98:	6161                	addi	sp,sp,80
    80003c9a:	8082                	ret
  return -1;
    80003c9c:	557d                	li	a0,-1
    80003c9e:	bfc5                	j	80003c8e <filestat+0x60>

0000000080003ca0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ca0:	7179                	addi	sp,sp,-48
    80003ca2:	f406                	sd	ra,40(sp)
    80003ca4:	f022                	sd	s0,32(sp)
    80003ca6:	ec26                	sd	s1,24(sp)
    80003ca8:	e84a                	sd	s2,16(sp)
    80003caa:	e44e                	sd	s3,8(sp)
    80003cac:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cae:	00854783          	lbu	a5,8(a0)
    80003cb2:	c3d5                	beqz	a5,80003d56 <fileread+0xb6>
    80003cb4:	89b2                	mv	s3,a2
    80003cb6:	892e                	mv	s2,a1
    80003cb8:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    80003cba:	411c                	lw	a5,0(a0)
    80003cbc:	4705                	li	a4,1
    80003cbe:	04e78963          	beq	a5,a4,80003d10 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc2:	470d                	li	a4,3
    80003cc4:	04e78d63          	beq	a5,a4,80003d1e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cc8:	4709                	li	a4,2
    80003cca:	06e79e63          	bne	a5,a4,80003d46 <fileread+0xa6>
    ilock(f->ip);
    80003cce:	6d08                	ld	a0,24(a0)
    80003cd0:	fffff097          	auipc	ra,0xfffff
    80003cd4:	fcc080e7          	jalr	-52(ra) # 80002c9c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cd8:	874e                	mv	a4,s3
    80003cda:	5094                	lw	a3,32(s1)
    80003cdc:	864a                	mv	a2,s2
    80003cde:	4585                	li	a1,1
    80003ce0:	6c88                	ld	a0,24(s1)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	270080e7          	jalr	624(ra) # 80002f52 <readi>
    80003cea:	892a                	mv	s2,a0
    80003cec:	00a05563          	blez	a0,80003cf6 <fileread+0x56>
      f->off += r;
    80003cf0:	509c                	lw	a5,32(s1)
    80003cf2:	9fa9                	addw	a5,a5,a0
    80003cf4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cf6:	6c88                	ld	a0,24(s1)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	068080e7          	jalr	104(ra) # 80002d60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d00:	854a                	mv	a0,s2
    80003d02:	70a2                	ld	ra,40(sp)
    80003d04:	7402                	ld	s0,32(sp)
    80003d06:	64e2                	ld	s1,24(sp)
    80003d08:	6942                	ld	s2,16(sp)
    80003d0a:	69a2                	ld	s3,8(sp)
    80003d0c:	6145                	addi	sp,sp,48
    80003d0e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d10:	6908                	ld	a0,16(a0)
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	3c8080e7          	jalr	968(ra) # 800040da <piperead>
    80003d1a:	892a                	mv	s2,a0
    80003d1c:	b7d5                	j	80003d00 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d1e:	02451783          	lh	a5,36(a0)
    80003d22:	03079693          	slli	a3,a5,0x30
    80003d26:	92c1                	srli	a3,a3,0x30
    80003d28:	4725                	li	a4,9
    80003d2a:	02d76863          	bltu	a4,a3,80003d5a <fileread+0xba>
    80003d2e:	0792                	slli	a5,a5,0x4
    80003d30:	00015717          	auipc	a4,0x15
    80003d34:	fc870713          	addi	a4,a4,-56 # 80018cf8 <devsw>
    80003d38:	97ba                	add	a5,a5,a4
    80003d3a:	639c                	ld	a5,0(a5)
    80003d3c:	c38d                	beqz	a5,80003d5e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d3e:	4505                	li	a0,1
    80003d40:	9782                	jalr	a5
    80003d42:	892a                	mv	s2,a0
    80003d44:	bf75                	j	80003d00 <fileread+0x60>
    panic("fileread");
    80003d46:	00005517          	auipc	a0,0x5
    80003d4a:	a6a50513          	addi	a0,a0,-1430 # 800087b0 <syscall_name_list+0x348>
    80003d4e:	00002097          	auipc	ra,0x2
    80003d52:	10a080e7          	jalr	266(ra) # 80005e58 <panic>
    return -1;
    80003d56:	597d                	li	s2,-1
    80003d58:	b765                	j	80003d00 <fileread+0x60>
      return -1;
    80003d5a:	597d                	li	s2,-1
    80003d5c:	b755                	j	80003d00 <fileread+0x60>
    80003d5e:	597d                	li	s2,-1
    80003d60:	b745                	j	80003d00 <fileread+0x60>

0000000080003d62 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d62:	715d                	addi	sp,sp,-80
    80003d64:	e486                	sd	ra,72(sp)
    80003d66:	e0a2                	sd	s0,64(sp)
    80003d68:	fc26                	sd	s1,56(sp)
    80003d6a:	f84a                	sd	s2,48(sp)
    80003d6c:	f44e                	sd	s3,40(sp)
    80003d6e:	f052                	sd	s4,32(sp)
    80003d70:	ec56                	sd	s5,24(sp)
    80003d72:	e85a                	sd	s6,16(sp)
    80003d74:	e45e                	sd	s7,8(sp)
    80003d76:	e062                	sd	s8,0(sp)
    80003d78:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d7a:	00954783          	lbu	a5,9(a0)
    80003d7e:	10078063          	beqz	a5,80003e7e <filewrite+0x11c>
    80003d82:	84aa                	mv	s1,a0
    80003d84:	8bae                	mv	s7,a1
    80003d86:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d88:	411c                	lw	a5,0(a0)
    80003d8a:	4705                	li	a4,1
    80003d8c:	02e78263          	beq	a5,a4,80003db0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d90:	470d                	li	a4,3
    80003d92:	02e78663          	beq	a5,a4,80003dbe <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d96:	4709                	li	a4,2
    80003d98:	0ce79b63          	bne	a5,a4,80003e6e <filewrite+0x10c>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d9c:	0ac05763          	blez	a2,80003e4a <filewrite+0xe8>
    int i = 0;
    80003da0:	4901                	li	s2,0
    80003da2:	6b05                	lui	s6,0x1
    80003da4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003da8:	6c05                	lui	s8,0x1
    80003daa:	c00c0c1b          	addiw	s8,s8,-1024
    80003dae:	a071                	j	80003e3a <filewrite+0xd8>
    ret = pipewrite(f->pipe, addr, n);
    80003db0:	6908                	ld	a0,16(a0)
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	222080e7          	jalr	546(ra) # 80003fd4 <pipewrite>
    80003dba:	8aaa                	mv	s5,a0
    80003dbc:	a851                	j	80003e50 <filewrite+0xee>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dbe:	02451783          	lh	a5,36(a0)
    80003dc2:	03079693          	slli	a3,a5,0x30
    80003dc6:	92c1                	srli	a3,a3,0x30
    80003dc8:	4725                	li	a4,9
    80003dca:	0ad76c63          	bltu	a4,a3,80003e82 <filewrite+0x120>
    80003dce:	0792                	slli	a5,a5,0x4
    80003dd0:	00015717          	auipc	a4,0x15
    80003dd4:	f2870713          	addi	a4,a4,-216 # 80018cf8 <devsw>
    80003dd8:	97ba                	add	a5,a5,a4
    80003dda:	679c                	ld	a5,8(a5)
    80003ddc:	c7cd                	beqz	a5,80003e86 <filewrite+0x124>
    ret = devsw[f->major].write(1, addr, n);
    80003dde:	4505                	li	a0,1
    80003de0:	9782                	jalr	a5
    80003de2:	8aaa                	mv	s5,a0
    80003de4:	a0b5                	j	80003e50 <filewrite+0xee>
    80003de6:	00098a1b          	sext.w	s4,s3
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	882080e7          	jalr	-1918(ra) # 8000366c <begin_op>
      ilock(f->ip);
    80003df2:	6c88                	ld	a0,24(s1)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	ea8080e7          	jalr	-344(ra) # 80002c9c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dfc:	8752                	mv	a4,s4
    80003dfe:	5094                	lw	a3,32(s1)
    80003e00:	01790633          	add	a2,s2,s7
    80003e04:	4585                	li	a1,1
    80003e06:	6c88                	ld	a0,24(s1)
    80003e08:	fffff097          	auipc	ra,0xfffff
    80003e0c:	242080e7          	jalr	578(ra) # 8000304a <writei>
    80003e10:	89aa                	mv	s3,a0
    80003e12:	00a05563          	blez	a0,80003e1c <filewrite+0xba>
        f->off += r;
    80003e16:	509c                	lw	a5,32(s1)
    80003e18:	9fa9                	addw	a5,a5,a0
    80003e1a:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80003e1c:	6c88                	ld	a0,24(s1)
    80003e1e:	fffff097          	auipc	ra,0xfffff
    80003e22:	f42080e7          	jalr	-190(ra) # 80002d60 <iunlock>
      end_op();
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	8c6080e7          	jalr	-1850(ra) # 800036ec <end_op>

      if(r != n1){
    80003e2e:	01499f63          	bne	s3,s4,80003e4c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003e32:	012a093b          	addw	s2,s4,s2
    while(i < n){
    80003e36:	01595b63          	ble	s5,s2,80003e4c <filewrite+0xea>
      int n1 = n - i;
    80003e3a:	412a87bb          	subw	a5,s5,s2
      if(n1 > max)
    80003e3e:	89be                	mv	s3,a5
    80003e40:	2781                	sext.w	a5,a5
    80003e42:	fafb52e3          	ble	a5,s6,80003de6 <filewrite+0x84>
    80003e46:	89e2                	mv	s3,s8
    80003e48:	bf79                	j	80003de6 <filewrite+0x84>
    int i = 0;
    80003e4a:	4901                	li	s2,0
    }
    ret = (i == n ? n : -1);
    80003e4c:	012a9f63          	bne	s5,s2,80003e6a <filewrite+0x108>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e50:	8556                	mv	a0,s5
    80003e52:	60a6                	ld	ra,72(sp)
    80003e54:	6406                	ld	s0,64(sp)
    80003e56:	74e2                	ld	s1,56(sp)
    80003e58:	7942                	ld	s2,48(sp)
    80003e5a:	79a2                	ld	s3,40(sp)
    80003e5c:	7a02                	ld	s4,32(sp)
    80003e5e:	6ae2                	ld	s5,24(sp)
    80003e60:	6b42                	ld	s6,16(sp)
    80003e62:	6ba2                	ld	s7,8(sp)
    80003e64:	6c02                	ld	s8,0(sp)
    80003e66:	6161                	addi	sp,sp,80
    80003e68:	8082                	ret
    ret = (i == n ? n : -1);
    80003e6a:	5afd                	li	s5,-1
    80003e6c:	b7d5                	j	80003e50 <filewrite+0xee>
    panic("filewrite");
    80003e6e:	00005517          	auipc	a0,0x5
    80003e72:	95250513          	addi	a0,a0,-1710 # 800087c0 <syscall_name_list+0x358>
    80003e76:	00002097          	auipc	ra,0x2
    80003e7a:	fe2080e7          	jalr	-30(ra) # 80005e58 <panic>
    return -1;
    80003e7e:	5afd                	li	s5,-1
    80003e80:	bfc1                	j	80003e50 <filewrite+0xee>
      return -1;
    80003e82:	5afd                	li	s5,-1
    80003e84:	b7f1                	j	80003e50 <filewrite+0xee>
    80003e86:	5afd                	li	s5,-1
    80003e88:	b7e1                	j	80003e50 <filewrite+0xee>

0000000080003e8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e8a:	7179                	addi	sp,sp,-48
    80003e8c:	f406                	sd	ra,40(sp)
    80003e8e:	f022                	sd	s0,32(sp)
    80003e90:	ec26                	sd	s1,24(sp)
    80003e92:	e84a                	sd	s2,16(sp)
    80003e94:	e44e                	sd	s3,8(sp)
    80003e96:	e052                	sd	s4,0(sp)
    80003e98:	1800                	addi	s0,sp,48
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9e:	0005b023          	sd	zero,0(a1)
    80003ea2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	bf0080e7          	jalr	-1040(ra) # 80003a96 <filealloc>
    80003eae:	e088                	sd	a0,0(s1)
    80003eb0:	c551                	beqz	a0,80003f3c <pipealloc+0xb2>
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	be4080e7          	jalr	-1052(ra) # 80003a96 <filealloc>
    80003eba:	00a93023          	sd	a0,0(s2)
    80003ebe:	c92d                	beqz	a0,80003f30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ec0:	ffffc097          	auipc	ra,0xffffc
    80003ec4:	25c080e7          	jalr	604(ra) # 8000011c <kalloc>
    80003ec8:	89aa                	mv	s3,a0
    80003eca:	c125                	beqz	a0,80003f2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ecc:	4a05                	li	s4,1
    80003ece:	23452023          	sw	s4,544(a0)
  pi->writeopen = 1;
    80003ed2:	23452223          	sw	s4,548(a0)
  pi->nwrite = 0;
    80003ed6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ede:	00004597          	auipc	a1,0x4
    80003ee2:	69a58593          	addi	a1,a1,1690 # 80008578 <syscall_name_list+0x110>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	44e080e7          	jalr	1102(ra) # 80006334 <initlock>
  (*f0)->type = FD_PIPE;
    80003eee:	609c                	ld	a5,0(s1)
    80003ef0:	0147a023          	sw	s4,0(a5)
  (*f0)->readable = 1;
    80003ef4:	609c                	ld	a5,0(s1)
    80003ef6:	01478423          	sb	s4,8(a5)
  (*f0)->writable = 0;
    80003efa:	609c                	ld	a5,0(s1)
    80003efc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f00:	609c                	ld	a5,0(s1)
    80003f02:	0137b823          	sd	s3,16(a5)
  (*f1)->type = FD_PIPE;
    80003f06:	00093783          	ld	a5,0(s2)
    80003f0a:	0147a023          	sw	s4,0(a5)
  (*f1)->readable = 0;
    80003f0e:	00093783          	ld	a5,0(s2)
    80003f12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f16:	00093783          	ld	a5,0(s2)
    80003f1a:	014784a3          	sb	s4,9(a5)
  (*f1)->pipe = pi;
    80003f1e:	00093783          	ld	a5,0(s2)
    80003f22:	0137b823          	sd	s3,16(a5)
  return 0;
    80003f26:	4501                	li	a0,0
    80003f28:	a025                	j	80003f50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f2a:	6088                	ld	a0,0(s1)
    80003f2c:	e501                	bnez	a0,80003f34 <pipealloc+0xaa>
    80003f2e:	a039                	j	80003f3c <pipealloc+0xb2>
    80003f30:	6088                	ld	a0,0(s1)
    80003f32:	c51d                	beqz	a0,80003f60 <pipealloc+0xd6>
    fileclose(*f0);
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	c32080e7          	jalr	-974(ra) # 80003b66 <fileclose>
  if(*f1)
    80003f3c:	00093783          	ld	a5,0(s2)
    fileclose(*f1);
  return -1;
    80003f40:	557d                	li	a0,-1
  if(*f1)
    80003f42:	c799                	beqz	a5,80003f50 <pipealloc+0xc6>
    fileclose(*f1);
    80003f44:	853e                	mv	a0,a5
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	c20080e7          	jalr	-992(ra) # 80003b66 <fileclose>
  return -1;
    80003f4e:	557d                	li	a0,-1
}
    80003f50:	70a2                	ld	ra,40(sp)
    80003f52:	7402                	ld	s0,32(sp)
    80003f54:	64e2                	ld	s1,24(sp)
    80003f56:	6942                	ld	s2,16(sp)
    80003f58:	69a2                	ld	s3,8(sp)
    80003f5a:	6a02                	ld	s4,0(sp)
    80003f5c:	6145                	addi	sp,sp,48
    80003f5e:	8082                	ret
  return -1;
    80003f60:	557d                	li	a0,-1
    80003f62:	b7fd                	j	80003f50 <pipealloc+0xc6>

0000000080003f64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f64:	1101                	addi	sp,sp,-32
    80003f66:	ec06                	sd	ra,24(sp)
    80003f68:	e822                	sd	s0,16(sp)
    80003f6a:	e426                	sd	s1,8(sp)
    80003f6c:	e04a                	sd	s2,0(sp)
    80003f6e:	1000                	addi	s0,sp,32
    80003f70:	84aa                	mv	s1,a0
    80003f72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	450080e7          	jalr	1104(ra) # 800063c4 <acquire>
  if(writable){
    80003f7c:	02090d63          	beqz	s2,80003fb6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f84:	21848513          	addi	a0,s1,536
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	64a080e7          	jalr	1610(ra) # 800015d2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f90:	2204b783          	ld	a5,544(s1)
    80003f94:	eb95                	bnez	a5,80003fc8 <pipeclose+0x64>
    release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	4e0080e7          	jalr	1248(ra) # 80006478 <release>
    kfree((char*)pi);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	ffffc097          	auipc	ra,0xffffc
    80003fa6:	07a080e7          	jalr	122(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003faa:	60e2                	ld	ra,24(sp)
    80003fac:	6442                	ld	s0,16(sp)
    80003fae:	64a2                	ld	s1,8(sp)
    80003fb0:	6902                	ld	s2,0(sp)
    80003fb2:	6105                	addi	sp,sp,32
    80003fb4:	8082                	ret
    pi->readopen = 0;
    80003fb6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fba:	21c48513          	addi	a0,s1,540
    80003fbe:	ffffd097          	auipc	ra,0xffffd
    80003fc2:	614080e7          	jalr	1556(ra) # 800015d2 <wakeup>
    80003fc6:	b7e9                	j	80003f90 <pipeclose+0x2c>
    release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	4ae080e7          	jalr	1198(ra) # 80006478 <release>
}
    80003fd2:	bfe1                	j	80003faa <pipeclose+0x46>

0000000080003fd4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fd4:	7159                	addi	sp,sp,-112
    80003fd6:	f486                	sd	ra,104(sp)
    80003fd8:	f0a2                	sd	s0,96(sp)
    80003fda:	eca6                	sd	s1,88(sp)
    80003fdc:	e8ca                	sd	s2,80(sp)
    80003fde:	e4ce                	sd	s3,72(sp)
    80003fe0:	e0d2                	sd	s4,64(sp)
    80003fe2:	fc56                	sd	s5,56(sp)
    80003fe4:	f85a                	sd	s6,48(sp)
    80003fe6:	f45e                	sd	s7,40(sp)
    80003fe8:	f062                	sd	s8,32(sp)
    80003fea:	ec66                	sd	s9,24(sp)
    80003fec:	1880                	addi	s0,sp,112
    80003fee:	84aa                	mv	s1,a0
    80003ff0:	8aae                	mv	s5,a1
    80003ff2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	eca080e7          	jalr	-310(ra) # 80000ebe <myproc>
    80003ffc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00002097          	auipc	ra,0x2
    80004004:	3c4080e7          	jalr	964(ra) # 800063c4 <acquire>
  while(i < n){
    80004008:	0d405763          	blez	s4,800040d6 <pipewrite+0x102>
    8000400c:	8ba6                	mv	s7,s1
    if(pi->readopen == 0 || killed(pr)){
    8000400e:	2204a783          	lw	a5,544(s1)
    80004012:	cb81                	beqz	a5,80004022 <pipewrite+0x4e>
  int i = 0;
    80004014:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004016:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004018:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000401c:	21c48c13          	addi	s8,s1,540
    80004020:	a0a5                	j	80004088 <pipewrite+0xb4>
      release(&pi->lock);
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	454080e7          	jalr	1108(ra) # 80006478 <release>
      return -1;
    8000402c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000402e:	854a                	mv	a0,s2
    80004030:	70a6                	ld	ra,104(sp)
    80004032:	7406                	ld	s0,96(sp)
    80004034:	64e6                	ld	s1,88(sp)
    80004036:	6946                	ld	s2,80(sp)
    80004038:	69a6                	ld	s3,72(sp)
    8000403a:	6a06                	ld	s4,64(sp)
    8000403c:	7ae2                	ld	s5,56(sp)
    8000403e:	7b42                	ld	s6,48(sp)
    80004040:	7ba2                	ld	s7,40(sp)
    80004042:	7c02                	ld	s8,32(sp)
    80004044:	6ce2                	ld	s9,24(sp)
    80004046:	6165                	addi	sp,sp,112
    80004048:	8082                	ret
      wakeup(&pi->nread);
    8000404a:	8566                	mv	a0,s9
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	586080e7          	jalr	1414(ra) # 800015d2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004054:	85de                	mv	a1,s7
    80004056:	8562                	mv	a0,s8
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	516080e7          	jalr	1302(ra) # 8000156e <sleep>
    80004060:	a839                	j	8000407e <pipewrite+0xaa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004062:	21c4a783          	lw	a5,540(s1)
    80004066:	0017871b          	addiw	a4,a5,1
    8000406a:	20e4ae23          	sw	a4,540(s1)
    8000406e:	1ff7f793          	andi	a5,a5,511
    80004072:	97a6                	add	a5,a5,s1
    80004074:	f9f44703          	lbu	a4,-97(s0)
    80004078:	00e78c23          	sb	a4,24(a5)
      i++;
    8000407c:	2905                	addiw	s2,s2,1
  while(i < n){
    8000407e:	05495063          	ble	s4,s2,800040be <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80004082:	2204a783          	lw	a5,544(s1)
    80004086:	dfd1                	beqz	a5,80004022 <pipewrite+0x4e>
    80004088:	854e                	mv	a0,s3
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	78e080e7          	jalr	1934(ra) # 80001818 <killed>
    80004092:	f941                	bnez	a0,80004022 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004094:	2184a783          	lw	a5,536(s1)
    80004098:	21c4a703          	lw	a4,540(s1)
    8000409c:	2007879b          	addiw	a5,a5,512
    800040a0:	faf705e3          	beq	a4,a5,8000404a <pipewrite+0x76>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040a4:	4685                	li	a3,1
    800040a6:	01590633          	add	a2,s2,s5
    800040aa:	f9f40593          	addi	a1,s0,-97
    800040ae:	0509b503          	ld	a0,80(s3)
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	b3e080e7          	jalr	-1218(ra) # 80000bf0 <copyin>
    800040ba:	fb6514e3          	bne	a0,s6,80004062 <pipewrite+0x8e>
  wakeup(&pi->nread);
    800040be:	21848513          	addi	a0,s1,536
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	510080e7          	jalr	1296(ra) # 800015d2 <wakeup>
  release(&pi->lock);
    800040ca:	8526                	mv	a0,s1
    800040cc:	00002097          	auipc	ra,0x2
    800040d0:	3ac080e7          	jalr	940(ra) # 80006478 <release>
  return i;
    800040d4:	bfa9                	j	8000402e <pipewrite+0x5a>
  int i = 0;
    800040d6:	4901                	li	s2,0
    800040d8:	b7dd                	j	800040be <pipewrite+0xea>

00000000800040da <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040da:	715d                	addi	sp,sp,-80
    800040dc:	e486                	sd	ra,72(sp)
    800040de:	e0a2                	sd	s0,64(sp)
    800040e0:	fc26                	sd	s1,56(sp)
    800040e2:	f84a                	sd	s2,48(sp)
    800040e4:	f44e                	sd	s3,40(sp)
    800040e6:	f052                	sd	s4,32(sp)
    800040e8:	ec56                	sd	s5,24(sp)
    800040ea:	e85a                	sd	s6,16(sp)
    800040ec:	0880                	addi	s0,sp,80
    800040ee:	84aa                	mv	s1,a0
    800040f0:	89ae                	mv	s3,a1
    800040f2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	dca080e7          	jalr	-566(ra) # 80000ebe <myproc>
    800040fc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	2c4080e7          	jalr	708(ra) # 800063c4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004108:	2184a703          	lw	a4,536(s1)
    8000410c:	21c4a783          	lw	a5,540(s1)
    80004110:	06f71b63          	bne	a4,a5,80004186 <piperead+0xac>
    80004114:	8926                	mv	s2,s1
    80004116:	2244a783          	lw	a5,548(s1)
    8000411a:	cb85                	beqz	a5,8000414a <piperead+0x70>
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000411c:	21848b13          	addi	s6,s1,536
    if(killed(pr)){
    80004120:	8552                	mv	a0,s4
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	6f6080e7          	jalr	1782(ra) # 80001818 <killed>
    8000412a:	e539                	bnez	a0,80004178 <piperead+0x9e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000412c:	85ca                	mv	a1,s2
    8000412e:	855a                	mv	a0,s6
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	43e080e7          	jalr	1086(ra) # 8000156e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004138:	2184a703          	lw	a4,536(s1)
    8000413c:	21c4a783          	lw	a5,540(s1)
    80004140:	04f71363          	bne	a4,a5,80004186 <piperead+0xac>
    80004144:	2244a783          	lw	a5,548(s1)
    80004148:	ffe1                	bnez	a5,80004120 <piperead+0x46>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
    8000414a:	4901                	li	s2,0
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000414c:	21c48513          	addi	a0,s1,540
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	482080e7          	jalr	1154(ra) # 800015d2 <wakeup>
  release(&pi->lock);
    80004158:	8526                	mv	a0,s1
    8000415a:	00002097          	auipc	ra,0x2
    8000415e:	31e080e7          	jalr	798(ra) # 80006478 <release>
  return i;
}
    80004162:	854a                	mv	a0,s2
    80004164:	60a6                	ld	ra,72(sp)
    80004166:	6406                	ld	s0,64(sp)
    80004168:	74e2                	ld	s1,56(sp)
    8000416a:	7942                	ld	s2,48(sp)
    8000416c:	79a2                	ld	s3,40(sp)
    8000416e:	7a02                	ld	s4,32(sp)
    80004170:	6ae2                	ld	s5,24(sp)
    80004172:	6b42                	ld	s6,16(sp)
    80004174:	6161                	addi	sp,sp,80
    80004176:	8082                	ret
      release(&pi->lock);
    80004178:	8526                	mv	a0,s1
    8000417a:	00002097          	auipc	ra,0x2
    8000417e:	2fe080e7          	jalr	766(ra) # 80006478 <release>
      return -1;
    80004182:	597d                	li	s2,-1
    80004184:	bff9                	j	80004162 <piperead+0x88>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004186:	4901                	li	s2,0
    80004188:	fd5052e3          	blez	s5,8000414c <piperead+0x72>
    if(pi->nread == pi->nwrite)
    8000418c:	2184a783          	lw	a5,536(s1)
    80004190:	4901                	li	s2,0
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004192:	5b7d                	li	s6,-1
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004194:	0017871b          	addiw	a4,a5,1
    80004198:	20e4ac23          	sw	a4,536(s1)
    8000419c:	1ff7f793          	andi	a5,a5,511
    800041a0:	97a6                	add	a5,a5,s1
    800041a2:	0187c783          	lbu	a5,24(a5)
    800041a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041aa:	4685                	li	a3,1
    800041ac:	fbf40613          	addi	a2,s0,-65
    800041b0:	85ce                	mv	a1,s3
    800041b2:	050a3503          	ld	a0,80(s4)
    800041b6:	ffffd097          	auipc	ra,0xffffd
    800041ba:	9ae080e7          	jalr	-1618(ra) # 80000b64 <copyout>
    800041be:	f96507e3          	beq	a0,s6,8000414c <piperead+0x72>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c2:	2905                	addiw	s2,s2,1
    800041c4:	f92a84e3          	beq	s5,s2,8000414c <piperead+0x72>
    if(pi->nread == pi->nwrite)
    800041c8:	2184a783          	lw	a5,536(s1)
    800041cc:	0985                	addi	s3,s3,1
    800041ce:	21c4a703          	lw	a4,540(s1)
    800041d2:	fcf711e3          	bne	a4,a5,80004194 <piperead+0xba>
    800041d6:	bf9d                	j	8000414c <piperead+0x72>

00000000800041d8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041d8:	1141                	addi	sp,sp,-16
    800041da:	e422                	sd	s0,8(sp)
    800041dc:	0800                	addi	s0,sp,16
    800041de:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041e0:	8905                	andi	a0,a0,1
    800041e2:	c111                	beqz	a0,800041e6 <flags2perm+0xe>
      perm = PTE_X;
    800041e4:	4521                	li	a0,8
    if(flags & 0x2)
    800041e6:	8b89                	andi	a5,a5,2
    800041e8:	c399                	beqz	a5,800041ee <flags2perm+0x16>
      perm |= PTE_W;
    800041ea:	00456513          	ori	a0,a0,4
    return perm;
}
    800041ee:	6422                	ld	s0,8(sp)
    800041f0:	0141                	addi	sp,sp,16
    800041f2:	8082                	ret

00000000800041f4 <exec>:

int
exec(char *path, char **argv)
{
    800041f4:	de010113          	addi	sp,sp,-544
    800041f8:	20113c23          	sd	ra,536(sp)
    800041fc:	20813823          	sd	s0,528(sp)
    80004200:	20913423          	sd	s1,520(sp)
    80004204:	21213023          	sd	s2,512(sp)
    80004208:	ffce                	sd	s3,504(sp)
    8000420a:	fbd2                	sd	s4,496(sp)
    8000420c:	f7d6                	sd	s5,488(sp)
    8000420e:	f3da                	sd	s6,480(sp)
    80004210:	efde                	sd	s7,472(sp)
    80004212:	ebe2                	sd	s8,464(sp)
    80004214:	e7e6                	sd	s9,456(sp)
    80004216:	e3ea                	sd	s10,448(sp)
    80004218:	ff6e                	sd	s11,440(sp)
    8000421a:	1400                	addi	s0,sp,544
    8000421c:	892a                	mv	s2,a0
    8000421e:	dea43823          	sd	a0,-528(s0)
    80004222:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	c98080e7          	jalr	-872(ra) # 80000ebe <myproc>
    8000422e:	84aa                	mv	s1,a0

  begin_op();
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	43c080e7          	jalr	1084(ra) # 8000366c <begin_op>

  if((ip = namei(path)) == 0){
    80004238:	854a                	mv	a0,s2
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	214080e7          	jalr	532(ra) # 8000344e <namei>
    80004242:	c93d                	beqz	a0,800042b8 <exec+0xc4>
    80004244:	892a                	mv	s2,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	a56080e7          	jalr	-1450(ra) # 80002c9c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000424e:	04000713          	li	a4,64
    80004252:	4681                	li	a3,0
    80004254:	e5040613          	addi	a2,s0,-432
    80004258:	4581                	li	a1,0
    8000425a:	854a                	mv	a0,s2
    8000425c:	fffff097          	auipc	ra,0xfffff
    80004260:	cf6080e7          	jalr	-778(ra) # 80002f52 <readi>
    80004264:	04000793          	li	a5,64
    80004268:	00f51a63          	bne	a0,a5,8000427c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000426c:	e5042703          	lw	a4,-432(s0)
    80004270:	464c47b7          	lui	a5,0x464c4
    80004274:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004278:	04f70663          	beq	a4,a5,800042c4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000427c:	854a                	mv	a0,s2
    8000427e:	fffff097          	auipc	ra,0xfffff
    80004282:	c82080e7          	jalr	-894(ra) # 80002f00 <iunlockput>
    end_op();
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	466080e7          	jalr	1126(ra) # 800036ec <end_op>
  }
  return -1;
    8000428e:	557d                	li	a0,-1
}
    80004290:	21813083          	ld	ra,536(sp)
    80004294:	21013403          	ld	s0,528(sp)
    80004298:	20813483          	ld	s1,520(sp)
    8000429c:	20013903          	ld	s2,512(sp)
    800042a0:	79fe                	ld	s3,504(sp)
    800042a2:	7a5e                	ld	s4,496(sp)
    800042a4:	7abe                	ld	s5,488(sp)
    800042a6:	7b1e                	ld	s6,480(sp)
    800042a8:	6bfe                	ld	s7,472(sp)
    800042aa:	6c5e                	ld	s8,464(sp)
    800042ac:	6cbe                	ld	s9,456(sp)
    800042ae:	6d1e                	ld	s10,448(sp)
    800042b0:	7dfa                	ld	s11,440(sp)
    800042b2:	22010113          	addi	sp,sp,544
    800042b6:	8082                	ret
    end_op();
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	434080e7          	jalr	1076(ra) # 800036ec <end_op>
    return -1;
    800042c0:	557d                	li	a0,-1
    800042c2:	b7f9                	j	80004290 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042c4:	8526                	mv	a0,s1
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	cbe080e7          	jalr	-834(ra) # 80000f84 <proc_pagetable>
    800042ce:	e0a43423          	sd	a0,-504(s0)
    800042d2:	d54d                	beqz	a0,8000427c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d4:	e7042983          	lw	s3,-400(s0)
    800042d8:	e8845783          	lhu	a5,-376(s0)
    800042dc:	c7ad                	beqz	a5,80004346 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042de:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e0:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800042e2:	6c05                	lui	s8,0x1
    800042e4:	fffc0793          	addi	a5,s8,-1 # fff <_entry-0x7ffff001>
    800042e8:	def43423          	sd	a5,-536(s0)
    800042ec:	7cfd                	lui	s9,0xfffff
    800042ee:	a481                	j	8000452e <exec+0x33a>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042f0:	00004517          	auipc	a0,0x4
    800042f4:	4e050513          	addi	a0,a0,1248 # 800087d0 <syscall_name_list+0x368>
    800042f8:	00002097          	auipc	ra,0x2
    800042fc:	b60080e7          	jalr	-1184(ra) # 80005e58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004300:	8756                	mv	a4,s5
    80004302:	009d86bb          	addw	a3,s11,s1
    80004306:	4581                	li	a1,0
    80004308:	854a                	mv	a0,s2
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	c48080e7          	jalr	-952(ra) # 80002f52 <readi>
    80004312:	2501                	sext.w	a0,a0
    80004314:	1caa9063          	bne	s5,a0,800044d4 <exec+0x2e0>
  for(i = 0; i < sz; i += PGSIZE){
    80004318:	6785                	lui	a5,0x1
    8000431a:	9cbd                	addw	s1,s1,a5
    8000431c:	014c8a3b          	addw	s4,s9,s4
    80004320:	1f74fe63          	bleu	s7,s1,8000451c <exec+0x328>
    pa = walkaddr(pagetable, va + i);
    80004324:	02049593          	slli	a1,s1,0x20
    80004328:	9181                	srli	a1,a1,0x20
    8000432a:	95ea                	add	a1,a1,s10
    8000432c:	e0843503          	ld	a0,-504(s0)
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	22a080e7          	jalr	554(ra) # 8000055a <walkaddr>
    80004338:	862a                	mv	a2,a0
    if(pa == 0)
    8000433a:	d95d                	beqz	a0,800042f0 <exec+0xfc>
      n = PGSIZE;
    8000433c:	8ae2                	mv	s5,s8
    if(sz - i < PGSIZE)
    8000433e:	fd8a71e3          	bleu	s8,s4,80004300 <exec+0x10c>
      n = sz - i;
    80004342:	8ad2                	mv	s5,s4
    80004344:	bf75                	j	80004300 <exec+0x10c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004346:	4a01                	li	s4,0
  iunlockput(ip);
    80004348:	854a                	mv	a0,s2
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	bb6080e7          	jalr	-1098(ra) # 80002f00 <iunlockput>
  end_op();
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	39a080e7          	jalr	922(ra) # 800036ec <end_op>
  p = myproc();
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	b64080e7          	jalr	-1180(ra) # 80000ebe <myproc>
    80004362:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004364:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004368:	6785                	lui	a5,0x1
    8000436a:	17fd                	addi	a5,a5,-1
    8000436c:	9a3e                	add	s4,s4,a5
    8000436e:	77fd                	lui	a5,0xfffff
    80004370:	00fa77b3          	and	a5,s4,a5
    80004374:	e0f43023          	sd	a5,-512(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004378:	4691                	li	a3,4
    8000437a:	6609                	lui	a2,0x2
    8000437c:	963e                	add	a2,a2,a5
    8000437e:	85be                	mv	a1,a5
    80004380:	e0843483          	ld	s1,-504(s0)
    80004384:	8526                	mv	a0,s1
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	586080e7          	jalr	1414(ra) # 8000090c <uvmalloc>
    8000438e:	8b2a                	mv	s6,a0
  ip = 0;
    80004390:	4901                	li	s2,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004392:	14050163          	beqz	a0,800044d4 <exec+0x2e0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004396:	75f9                	lui	a1,0xffffe
    80004398:	95aa                	add	a1,a1,a0
    8000439a:	8526                	mv	a0,s1
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	796080e7          	jalr	1942(ra) # 80000b32 <uvmclear>
  stackbase = sp - PGSIZE;
    800043a4:	7bfd                	lui	s7,0xfffff
    800043a6:	9bda                	add	s7,s7,s6
  for(argc = 0; argv[argc]; argc++) {
    800043a8:	df843783          	ld	a5,-520(s0)
    800043ac:	6388                	ld	a0,0(a5)
    800043ae:	c925                	beqz	a0,8000441e <exec+0x22a>
    800043b0:	e9040993          	addi	s3,s0,-368
    800043b4:	f9040c13          	addi	s8,s0,-112
  sp = sz;
    800043b8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ba:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043bc:	ffffc097          	auipc	ra,0xffffc
    800043c0:	f8e080e7          	jalr	-114(ra) # 8000034a <strlen>
    800043c4:	2505                	addiw	a0,a0,1
    800043c6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ca:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043ce:	13796b63          	bltu	s2,s7,80004504 <exec+0x310>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d2:	df843c83          	ld	s9,-520(s0)
    800043d6:	000cba03          	ld	s4,0(s9) # fffffffffffff000 <end+0xffffffff7ffdcf30>
    800043da:	8552                	mv	a0,s4
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f6e080e7          	jalr	-146(ra) # 8000034a <strlen>
    800043e4:	0015069b          	addiw	a3,a0,1
    800043e8:	8652                	mv	a2,s4
    800043ea:	85ca                	mv	a1,s2
    800043ec:	e0843503          	ld	a0,-504(s0)
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	774080e7          	jalr	1908(ra) # 80000b64 <copyout>
    800043f8:	10054a63          	bltz	a0,8000450c <exec+0x318>
    ustack[argc] = sp;
    800043fc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004400:	0485                	addi	s1,s1,1
    80004402:	008c8793          	addi	a5,s9,8
    80004406:	def43c23          	sd	a5,-520(s0)
    8000440a:	008cb503          	ld	a0,8(s9)
    8000440e:	c911                	beqz	a0,80004422 <exec+0x22e>
    if(argc >= MAXARG)
    80004410:	09a1                	addi	s3,s3,8
    80004412:	fb8995e3          	bne	s3,s8,800043bc <exec+0x1c8>
  sz = sz1;
    80004416:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    8000441a:	4901                	li	s2,0
    8000441c:	a865                	j	800044d4 <exec+0x2e0>
  sp = sz;
    8000441e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004420:	4481                	li	s1,0
  ustack[argc] = 0;
    80004422:	00349793          	slli	a5,s1,0x3
    80004426:	f9040713          	addi	a4,s0,-112
    8000442a:	97ba                	add	a5,a5,a4
    8000442c:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdce30>
  sp -= (argc+1) * sizeof(uint64);
    80004430:	00148693          	addi	a3,s1,1
    80004434:	068e                	slli	a3,a3,0x3
    80004436:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000443a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000443e:	01797663          	bleu	s7,s2,8000444a <exec+0x256>
  sz = sz1;
    80004442:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004446:	4901                	li	s2,0
    80004448:	a071                	j	800044d4 <exec+0x2e0>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000444a:	e9040613          	addi	a2,s0,-368
    8000444e:	85ca                	mv	a1,s2
    80004450:	e0843503          	ld	a0,-504(s0)
    80004454:	ffffc097          	auipc	ra,0xffffc
    80004458:	710080e7          	jalr	1808(ra) # 80000b64 <copyout>
    8000445c:	0a054c63          	bltz	a0,80004514 <exec+0x320>
  p->trapframe->a1 = sp;
    80004460:	058ab783          	ld	a5,88(s5)
    80004464:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004468:	df043783          	ld	a5,-528(s0)
    8000446c:	0007c703          	lbu	a4,0(a5)
    80004470:	cf11                	beqz	a4,8000448c <exec+0x298>
    80004472:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004474:	02f00693          	li	a3,47
    80004478:	a039                	j	80004486 <exec+0x292>
      last = s+1;
    8000447a:	def43823          	sd	a5,-528(s0)
  for(last=s=path; *s; s++)
    8000447e:	0785                	addi	a5,a5,1
    80004480:	fff7c703          	lbu	a4,-1(a5)
    80004484:	c701                	beqz	a4,8000448c <exec+0x298>
    if(*s == '/')
    80004486:	fed71ce3          	bne	a4,a3,8000447e <exec+0x28a>
    8000448a:	bfc5                	j	8000447a <exec+0x286>
  safestrcpy(p->name, last, sizeof(p->name));
    8000448c:	4641                	li	a2,16
    8000448e:	df043583          	ld	a1,-528(s0)
    80004492:	158a8513          	addi	a0,s5,344
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	e82080e7          	jalr	-382(ra) # 80000318 <safestrcpy>
  oldpagetable = p->pagetable;
    8000449e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044a2:	e0843783          	ld	a5,-504(s0)
    800044a6:	04fab823          	sd	a5,80(s5)
  p->sz = sz;
    800044aa:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044ae:	058ab783          	ld	a5,88(s5)
    800044b2:	e6843703          	ld	a4,-408(s0)
    800044b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044b8:	058ab783          	ld	a5,88(s5)
    800044bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c0:	85ea                	mv	a1,s10
    800044c2:	ffffd097          	auipc	ra,0xffffd
    800044c6:	b5e080e7          	jalr	-1186(ra) # 80001020 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ca:	0004851b          	sext.w	a0,s1
    800044ce:	b3c9                	j	80004290 <exec+0x9c>
    800044d0:	e1443023          	sd	s4,-512(s0)
    proc_freepagetable(pagetable, sz);
    800044d4:	e0043583          	ld	a1,-512(s0)
    800044d8:	e0843503          	ld	a0,-504(s0)
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	b44080e7          	jalr	-1212(ra) # 80001020 <proc_freepagetable>
  if(ip){
    800044e4:	d8091ce3          	bnez	s2,8000427c <exec+0x88>
  return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	b35d                	j	80004290 <exec+0x9c>
    800044ec:	e1443023          	sd	s4,-512(s0)
    800044f0:	b7d5                	j	800044d4 <exec+0x2e0>
    800044f2:	e1443023          	sd	s4,-512(s0)
    800044f6:	bff9                	j	800044d4 <exec+0x2e0>
    800044f8:	e1443023          	sd	s4,-512(s0)
    800044fc:	bfe1                	j	800044d4 <exec+0x2e0>
    800044fe:	e1443023          	sd	s4,-512(s0)
    80004502:	bfc9                	j	800044d4 <exec+0x2e0>
  sz = sz1;
    80004504:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004508:	4901                	li	s2,0
    8000450a:	b7e9                	j	800044d4 <exec+0x2e0>
  sz = sz1;
    8000450c:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004510:	4901                	li	s2,0
    80004512:	b7c9                	j	800044d4 <exec+0x2e0>
  sz = sz1;
    80004514:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004518:	4901                	li	s2,0
    8000451a:	bf6d                	j	800044d4 <exec+0x2e0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000451c:	e0043a03          	ld	s4,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004520:	2b05                	addiw	s6,s6,1
    80004522:	0389899b          	addiw	s3,s3,56
    80004526:	e8845783          	lhu	a5,-376(s0)
    8000452a:	e0fb5fe3          	ble	a5,s6,80004348 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000452e:	2981                	sext.w	s3,s3
    80004530:	03800713          	li	a4,56
    80004534:	86ce                	mv	a3,s3
    80004536:	e1840613          	addi	a2,s0,-488
    8000453a:	4581                	li	a1,0
    8000453c:	854a                	mv	a0,s2
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	a14080e7          	jalr	-1516(ra) # 80002f52 <readi>
    80004546:	03800793          	li	a5,56
    8000454a:	f8f513e3          	bne	a0,a5,800044d0 <exec+0x2dc>
    if(ph.type != ELF_PROG_LOAD)
    8000454e:	e1842783          	lw	a5,-488(s0)
    80004552:	4705                	li	a4,1
    80004554:	fce796e3          	bne	a5,a4,80004520 <exec+0x32c>
    if(ph.memsz < ph.filesz)
    80004558:	e4043483          	ld	s1,-448(s0)
    8000455c:	e3843783          	ld	a5,-456(s0)
    80004560:	f8f4e6e3          	bltu	s1,a5,800044ec <exec+0x2f8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004564:	e2843783          	ld	a5,-472(s0)
    80004568:	94be                	add	s1,s1,a5
    8000456a:	f8f4e4e3          	bltu	s1,a5,800044f2 <exec+0x2fe>
    if(ph.vaddr % PGSIZE != 0)
    8000456e:	de843703          	ld	a4,-536(s0)
    80004572:	8ff9                	and	a5,a5,a4
    80004574:	f3d1                	bnez	a5,800044f8 <exec+0x304>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004576:	e1c42503          	lw	a0,-484(s0)
    8000457a:	00000097          	auipc	ra,0x0
    8000457e:	c5e080e7          	jalr	-930(ra) # 800041d8 <flags2perm>
    80004582:	86aa                	mv	a3,a0
    80004584:	8626                	mv	a2,s1
    80004586:	85d2                	mv	a1,s4
    80004588:	e0843503          	ld	a0,-504(s0)
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	380080e7          	jalr	896(ra) # 8000090c <uvmalloc>
    80004594:	e0a43023          	sd	a0,-512(s0)
    80004598:	d13d                	beqz	a0,800044fe <exec+0x30a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000459a:	e2843d03          	ld	s10,-472(s0)
    8000459e:	e2042d83          	lw	s11,-480(s0)
    800045a2:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045a6:	f60b8be3          	beqz	s7,8000451c <exec+0x328>
    800045aa:	8a5e                	mv	s4,s7
    800045ac:	4481                	li	s1,0
    800045ae:	bb9d                	j	80004324 <exec+0x130>

00000000800045b0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045b0:	7179                	addi	sp,sp,-48
    800045b2:	f406                	sd	ra,40(sp)
    800045b4:	f022                	sd	s0,32(sp)
    800045b6:	ec26                	sd	s1,24(sp)
    800045b8:	e84a                	sd	s2,16(sp)
    800045ba:	1800                	addi	s0,sp,48
    800045bc:	892e                	mv	s2,a1
    800045be:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045c0:	fdc40593          	addi	a1,s0,-36
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	a50080e7          	jalr	-1456(ra) # 80002014 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045cc:	fdc42703          	lw	a4,-36(s0)
    800045d0:	47bd                	li	a5,15
    800045d2:	02e7eb63          	bltu	a5,a4,80004608 <argfd+0x58>
    800045d6:	ffffd097          	auipc	ra,0xffffd
    800045da:	8e8080e7          	jalr	-1816(ra) # 80000ebe <myproc>
    800045de:	fdc42703          	lw	a4,-36(s0)
    800045e2:	01a70793          	addi	a5,a4,26
    800045e6:	078e                	slli	a5,a5,0x3
    800045e8:	953e                	add	a0,a0,a5
    800045ea:	611c                	ld	a5,0(a0)
    800045ec:	c385                	beqz	a5,8000460c <argfd+0x5c>
    return -1;
  if(pfd)
    800045ee:	00090463          	beqz	s2,800045f6 <argfd+0x46>
    *pfd = fd;
    800045f2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045f6:	4501                	li	a0,0
  if(pf)
    800045f8:	c091                	beqz	s1,800045fc <argfd+0x4c>
    *pf = f;
    800045fa:	e09c                	sd	a5,0(s1)
}
    800045fc:	70a2                	ld	ra,40(sp)
    800045fe:	7402                	ld	s0,32(sp)
    80004600:	64e2                	ld	s1,24(sp)
    80004602:	6942                	ld	s2,16(sp)
    80004604:	6145                	addi	sp,sp,48
    80004606:	8082                	ret
    return -1;
    80004608:	557d                	li	a0,-1
    8000460a:	bfcd                	j	800045fc <argfd+0x4c>
    8000460c:	557d                	li	a0,-1
    8000460e:	b7fd                	j	800045fc <argfd+0x4c>

0000000080004610 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004610:	1101                	addi	sp,sp,-32
    80004612:	ec06                	sd	ra,24(sp)
    80004614:	e822                	sd	s0,16(sp)
    80004616:	e426                	sd	s1,8(sp)
    80004618:	1000                	addi	s0,sp,32
    8000461a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000461c:	ffffd097          	auipc	ra,0xffffd
    80004620:	8a2080e7          	jalr	-1886(ra) # 80000ebe <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
    80004624:	697c                	ld	a5,208(a0)
    80004626:	c395                	beqz	a5,8000464a <fdalloc+0x3a>
    80004628:	0d850713          	addi	a4,a0,216
  for(fd = 0; fd < NOFILE; fd++){
    8000462c:	4785                	li	a5,1
    8000462e:	4641                	li	a2,16
    if(p->ofile[fd] == 0){
    80004630:	6314                	ld	a3,0(a4)
    80004632:	ce89                	beqz	a3,8000464c <fdalloc+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
    80004634:	2785                	addiw	a5,a5,1
    80004636:	0721                	addi	a4,a4,8
    80004638:	fec79ce3          	bne	a5,a2,80004630 <fdalloc+0x20>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000463c:	57fd                	li	a5,-1
}
    8000463e:	853e                	mv	a0,a5
    80004640:	60e2                	ld	ra,24(sp)
    80004642:	6442                	ld	s0,16(sp)
    80004644:	64a2                	ld	s1,8(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret
  for(fd = 0; fd < NOFILE; fd++){
    8000464a:	4781                	li	a5,0
      p->ofile[fd] = f;
    8000464c:	01a78713          	addi	a4,a5,26
    80004650:	070e                	slli	a4,a4,0x3
    80004652:	953a                	add	a0,a0,a4
    80004654:	e104                	sd	s1,0(a0)
      return fd;
    80004656:	b7e5                	j	8000463e <fdalloc+0x2e>

0000000080004658 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004658:	715d                	addi	sp,sp,-80
    8000465a:	e486                	sd	ra,72(sp)
    8000465c:	e0a2                	sd	s0,64(sp)
    8000465e:	fc26                	sd	s1,56(sp)
    80004660:	f84a                	sd	s2,48(sp)
    80004662:	f44e                	sd	s3,40(sp)
    80004664:	f052                	sd	s4,32(sp)
    80004666:	ec56                	sd	s5,24(sp)
    80004668:	e85a                	sd	s6,16(sp)
    8000466a:	0880                	addi	s0,sp,80
    8000466c:	89ae                	mv	s3,a1
    8000466e:	8b32                	mv	s6,a2
    80004670:	8ab6                	mv	s5,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004672:	fb040593          	addi	a1,s0,-80
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	df6080e7          	jalr	-522(ra) # 8000346c <nameiparent>
    8000467e:	84aa                	mv	s1,a0
    80004680:	14050e63          	beqz	a0,800047dc <create+0x184>
    return 0;

  ilock(dp);
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	618080e7          	jalr	1560(ra) # 80002c9c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000468c:	4601                	li	a2,0
    8000468e:	fb040593          	addi	a1,s0,-80
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	aee080e7          	jalr	-1298(ra) # 80003182 <dirlookup>
    8000469c:	892a                	mv	s2,a0
    8000469e:	c929                	beqz	a0,800046f0 <create+0x98>
    iunlockput(dp);
    800046a0:	8526                	mv	a0,s1
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	85e080e7          	jalr	-1954(ra) # 80002f00 <iunlockput>
    ilock(ip);
    800046aa:	854a                	mv	a0,s2
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	5f0080e7          	jalr	1520(ra) # 80002c9c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b4:	2981                	sext.w	s3,s3
    800046b6:	4789                	li	a5,2
    800046b8:	02f99563          	bne	s3,a5,800046e2 <create+0x8a>
    800046bc:	04495783          	lhu	a5,68(s2)
    800046c0:	37f9                	addiw	a5,a5,-2
    800046c2:	17c2                	slli	a5,a5,0x30
    800046c4:	93c1                	srli	a5,a5,0x30
    800046c6:	4705                	li	a4,1
    800046c8:	00f76d63          	bltu	a4,a5,800046e2 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046cc:	854a                	mv	a0,s2
    800046ce:	60a6                	ld	ra,72(sp)
    800046d0:	6406                	ld	s0,64(sp)
    800046d2:	74e2                	ld	s1,56(sp)
    800046d4:	7942                	ld	s2,48(sp)
    800046d6:	79a2                	ld	s3,40(sp)
    800046d8:	7a02                	ld	s4,32(sp)
    800046da:	6ae2                	ld	s5,24(sp)
    800046dc:	6b42                	ld	s6,16(sp)
    800046de:	6161                	addi	sp,sp,80
    800046e0:	8082                	ret
    iunlockput(ip);
    800046e2:	854a                	mv	a0,s2
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	81c080e7          	jalr	-2020(ra) # 80002f00 <iunlockput>
    return 0;
    800046ec:	4901                	li	s2,0
    800046ee:	bff9                	j	800046cc <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046f0:	85ce                	mv	a1,s3
    800046f2:	4088                	lw	a0,0(s1)
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	408080e7          	jalr	1032(ra) # 80002afc <ialloc>
    800046fc:	8a2a                	mv	s4,a0
    800046fe:	c539                	beqz	a0,8000474c <create+0xf4>
  ilock(ip);
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	59c080e7          	jalr	1436(ra) # 80002c9c <ilock>
  ip->major = major;
    80004708:	056a1323          	sh	s6,70(s4)
  ip->minor = minor;
    8000470c:	055a1423          	sh	s5,72(s4)
  ip->nlink = 1;
    80004710:	4785                	li	a5,1
    80004712:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004716:	8552                	mv	a0,s4
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	4b8080e7          	jalr	1208(ra) # 80002bd0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004720:	2981                	sext.w	s3,s3
    80004722:	4785                	li	a5,1
    80004724:	02f98b63          	beq	s3,a5,8000475a <create+0x102>
  if(dirlink(dp, name, ip->inum) < 0)
    80004728:	004a2603          	lw	a2,4(s4)
    8000472c:	fb040593          	addi	a1,s0,-80
    80004730:	8526                	mv	a0,s1
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	c68080e7          	jalr	-920(ra) # 8000339a <dirlink>
    8000473a:	06054f63          	bltz	a0,800047b8 <create+0x160>
  iunlockput(dp);
    8000473e:	8526                	mv	a0,s1
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	7c0080e7          	jalr	1984(ra) # 80002f00 <iunlockput>
  return ip;
    80004748:	8952                	mv	s2,s4
    8000474a:	b749                	j	800046cc <create+0x74>
    iunlockput(dp);
    8000474c:	8526                	mv	a0,s1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	7b2080e7          	jalr	1970(ra) # 80002f00 <iunlockput>
    return 0;
    80004756:	8952                	mv	s2,s4
    80004758:	bf95                	j	800046cc <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000475a:	004a2603          	lw	a2,4(s4)
    8000475e:	00004597          	auipc	a1,0x4
    80004762:	09258593          	addi	a1,a1,146 # 800087f0 <syscall_name_list+0x388>
    80004766:	8552                	mv	a0,s4
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	c32080e7          	jalr	-974(ra) # 8000339a <dirlink>
    80004770:	04054463          	bltz	a0,800047b8 <create+0x160>
    80004774:	40d0                	lw	a2,4(s1)
    80004776:	00004597          	auipc	a1,0x4
    8000477a:	08258593          	addi	a1,a1,130 # 800087f8 <syscall_name_list+0x390>
    8000477e:	8552                	mv	a0,s4
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	c1a080e7          	jalr	-998(ra) # 8000339a <dirlink>
    80004788:	02054863          	bltz	a0,800047b8 <create+0x160>
  if(dirlink(dp, name, ip->inum) < 0)
    8000478c:	004a2603          	lw	a2,4(s4)
    80004790:	fb040593          	addi	a1,s0,-80
    80004794:	8526                	mv	a0,s1
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	c04080e7          	jalr	-1020(ra) # 8000339a <dirlink>
    8000479e:	00054d63          	bltz	a0,800047b8 <create+0x160>
    dp->nlink++;  // for ".."
    800047a2:	04a4d783          	lhu	a5,74(s1)
    800047a6:	2785                	addiw	a5,a5,1
    800047a8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047ac:	8526                	mv	a0,s1
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	422080e7          	jalr	1058(ra) # 80002bd0 <iupdate>
    800047b6:	b761                	j	8000473e <create+0xe6>
  ip->nlink = 0;
    800047b8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047bc:	8552                	mv	a0,s4
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	412080e7          	jalr	1042(ra) # 80002bd0 <iupdate>
  iunlockput(ip);
    800047c6:	8552                	mv	a0,s4
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	738080e7          	jalr	1848(ra) # 80002f00 <iunlockput>
  iunlockput(dp);
    800047d0:	8526                	mv	a0,s1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	72e080e7          	jalr	1838(ra) # 80002f00 <iunlockput>
  return 0;
    800047da:	bdcd                	j	800046cc <create+0x74>
    return 0;
    800047dc:	892a                	mv	s2,a0
    800047de:	b5fd                	j	800046cc <create+0x74>

00000000800047e0 <sys_dup>:
{
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	ec26                	sd	s1,24(sp)
    800047e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047ea:	fd840613          	addi	a2,s0,-40
    800047ee:	4581                	li	a1,0
    800047f0:	4501                	li	a0,0
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	dbe080e7          	jalr	-578(ra) # 800045b0 <argfd>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047fc:	02054363          	bltz	a0,80004822 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004800:	fd843503          	ld	a0,-40(s0)
    80004804:	00000097          	auipc	ra,0x0
    80004808:	e0c080e7          	jalr	-500(ra) # 80004610 <fdalloc>
    8000480c:	84aa                	mv	s1,a0
    return -1;
    8000480e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004810:	00054963          	bltz	a0,80004822 <sys_dup+0x42>
  filedup(f);
    80004814:	fd843503          	ld	a0,-40(s0)
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	2fc080e7          	jalr	764(ra) # 80003b14 <filedup>
  return fd;
    80004820:	87a6                	mv	a5,s1
}
    80004822:	853e                	mv	a0,a5
    80004824:	70a2                	ld	ra,40(sp)
    80004826:	7402                	ld	s0,32(sp)
    80004828:	64e2                	ld	s1,24(sp)
    8000482a:	6145                	addi	sp,sp,48
    8000482c:	8082                	ret

000000008000482e <sys_read>:
{
    8000482e:	7179                	addi	sp,sp,-48
    80004830:	f406                	sd	ra,40(sp)
    80004832:	f022                	sd	s0,32(sp)
    80004834:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004836:	fd840593          	addi	a1,s0,-40
    8000483a:	4505                	li	a0,1
    8000483c:	ffffd097          	auipc	ra,0xffffd
    80004840:	7f8080e7          	jalr	2040(ra) # 80002034 <argaddr>
  argint(2, &n);
    80004844:	fe440593          	addi	a1,s0,-28
    80004848:	4509                	li	a0,2
    8000484a:	ffffd097          	auipc	ra,0xffffd
    8000484e:	7ca080e7          	jalr	1994(ra) # 80002014 <argint>
  if(argfd(0, 0, &f) < 0)
    80004852:	fe840613          	addi	a2,s0,-24
    80004856:	4581                	li	a1,0
    80004858:	4501                	li	a0,0
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	d56080e7          	jalr	-682(ra) # 800045b0 <argfd>
    return -1;
    80004862:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004864:	00054d63          	bltz	a0,8000487e <sys_read+0x50>
  return fileread(f, p, n);
    80004868:	fe442603          	lw	a2,-28(s0)
    8000486c:	fd843583          	ld	a1,-40(s0)
    80004870:	fe843503          	ld	a0,-24(s0)
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	42c080e7          	jalr	1068(ra) # 80003ca0 <fileread>
    8000487c:	87aa                	mv	a5,a0
}
    8000487e:	853e                	mv	a0,a5
    80004880:	70a2                	ld	ra,40(sp)
    80004882:	7402                	ld	s0,32(sp)
    80004884:	6145                	addi	sp,sp,48
    80004886:	8082                	ret

0000000080004888 <sys_write>:
{
    80004888:	7179                	addi	sp,sp,-48
    8000488a:	f406                	sd	ra,40(sp)
    8000488c:	f022                	sd	s0,32(sp)
    8000488e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004890:	fd840593          	addi	a1,s0,-40
    80004894:	4505                	li	a0,1
    80004896:	ffffd097          	auipc	ra,0xffffd
    8000489a:	79e080e7          	jalr	1950(ra) # 80002034 <argaddr>
  argint(2, &n);
    8000489e:	fe440593          	addi	a1,s0,-28
    800048a2:	4509                	li	a0,2
    800048a4:	ffffd097          	auipc	ra,0xffffd
    800048a8:	770080e7          	jalr	1904(ra) # 80002014 <argint>
  if(argfd(0, 0, &f) < 0)
    800048ac:	fe840613          	addi	a2,s0,-24
    800048b0:	4581                	li	a1,0
    800048b2:	4501                	li	a0,0
    800048b4:	00000097          	auipc	ra,0x0
    800048b8:	cfc080e7          	jalr	-772(ra) # 800045b0 <argfd>
    return -1;
    800048bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048be:	00054d63          	bltz	a0,800048d8 <sys_write+0x50>
  return filewrite(f, p, n);
    800048c2:	fe442603          	lw	a2,-28(s0)
    800048c6:	fd843583          	ld	a1,-40(s0)
    800048ca:	fe843503          	ld	a0,-24(s0)
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	494080e7          	jalr	1172(ra) # 80003d62 <filewrite>
    800048d6:	87aa                	mv	a5,a0
}
    800048d8:	853e                	mv	a0,a5
    800048da:	70a2                	ld	ra,40(sp)
    800048dc:	7402                	ld	s0,32(sp)
    800048de:	6145                	addi	sp,sp,48
    800048e0:	8082                	ret

00000000800048e2 <sys_close>:
{
    800048e2:	1101                	addi	sp,sp,-32
    800048e4:	ec06                	sd	ra,24(sp)
    800048e6:	e822                	sd	s0,16(sp)
    800048e8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ea:	fe040613          	addi	a2,s0,-32
    800048ee:	fec40593          	addi	a1,s0,-20
    800048f2:	4501                	li	a0,0
    800048f4:	00000097          	auipc	ra,0x0
    800048f8:	cbc080e7          	jalr	-836(ra) # 800045b0 <argfd>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048fe:	02054463          	bltz	a0,80004926 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004902:	ffffc097          	auipc	ra,0xffffc
    80004906:	5bc080e7          	jalr	1468(ra) # 80000ebe <myproc>
    8000490a:	fec42783          	lw	a5,-20(s0)
    8000490e:	07e9                	addi	a5,a5,26
    80004910:	078e                	slli	a5,a5,0x3
    80004912:	953e                	add	a0,a0,a5
    80004914:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004918:	fe043503          	ld	a0,-32(s0)
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	24a080e7          	jalr	586(ra) # 80003b66 <fileclose>
  return 0;
    80004924:	4781                	li	a5,0
}
    80004926:	853e                	mv	a0,a5
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	6105                	addi	sp,sp,32
    8000492e:	8082                	ret

0000000080004930 <sys_fstat>:
{
    80004930:	1101                	addi	sp,sp,-32
    80004932:	ec06                	sd	ra,24(sp)
    80004934:	e822                	sd	s0,16(sp)
    80004936:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004938:	fe040593          	addi	a1,s0,-32
    8000493c:	4505                	li	a0,1
    8000493e:	ffffd097          	auipc	ra,0xffffd
    80004942:	6f6080e7          	jalr	1782(ra) # 80002034 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004946:	fe840613          	addi	a2,s0,-24
    8000494a:	4581                	li	a1,0
    8000494c:	4501                	li	a0,0
    8000494e:	00000097          	auipc	ra,0x0
    80004952:	c62080e7          	jalr	-926(ra) # 800045b0 <argfd>
    return -1;
    80004956:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004958:	00054b63          	bltz	a0,8000496e <sys_fstat+0x3e>
  return filestat(f, st);
    8000495c:	fe043583          	ld	a1,-32(s0)
    80004960:	fe843503          	ld	a0,-24(s0)
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	2ca080e7          	jalr	714(ra) # 80003c2e <filestat>
    8000496c:	87aa                	mv	a5,a0
}
    8000496e:	853e                	mv	a0,a5
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	6105                	addi	sp,sp,32
    80004976:	8082                	ret

0000000080004978 <sys_link>:
{
    80004978:	7169                	addi	sp,sp,-304
    8000497a:	f606                	sd	ra,296(sp)
    8000497c:	f222                	sd	s0,288(sp)
    8000497e:	ee26                	sd	s1,280(sp)
    80004980:	ea4a                	sd	s2,272(sp)
    80004982:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004984:	08000613          	li	a2,128
    80004988:	ed040593          	addi	a1,s0,-304
    8000498c:	4501                	li	a0,0
    8000498e:	ffffd097          	auipc	ra,0xffffd
    80004992:	6c6080e7          	jalr	1734(ra) # 80002054 <argstr>
    return -1;
    80004996:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004998:	10054e63          	bltz	a0,80004ab4 <sys_link+0x13c>
    8000499c:	08000613          	li	a2,128
    800049a0:	f5040593          	addi	a1,s0,-176
    800049a4:	4505                	li	a0,1
    800049a6:	ffffd097          	auipc	ra,0xffffd
    800049aa:	6ae080e7          	jalr	1710(ra) # 80002054 <argstr>
    return -1;
    800049ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b0:	10054263          	bltz	a0,80004ab4 <sys_link+0x13c>
  begin_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	cb8080e7          	jalr	-840(ra) # 8000366c <begin_op>
  if((ip = namei(old)) == 0){
    800049bc:	ed040513          	addi	a0,s0,-304
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	a8e080e7          	jalr	-1394(ra) # 8000344e <namei>
    800049c8:	84aa                	mv	s1,a0
    800049ca:	c551                	beqz	a0,80004a56 <sys_link+0xde>
  ilock(ip);
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	2d0080e7          	jalr	720(ra) # 80002c9c <ilock>
  if(ip->type == T_DIR){
    800049d4:	04449703          	lh	a4,68(s1)
    800049d8:	4785                	li	a5,1
    800049da:	08f70463          	beq	a4,a5,80004a62 <sys_link+0xea>
  ip->nlink++;
    800049de:	04a4d783          	lhu	a5,74(s1)
    800049e2:	2785                	addiw	a5,a5,1
    800049e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	1e6080e7          	jalr	486(ra) # 80002bd0 <iupdate>
  iunlock(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	36c080e7          	jalr	876(ra) # 80002d60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fc:	fd040593          	addi	a1,s0,-48
    80004a00:	f5040513          	addi	a0,s0,-176
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	a68080e7          	jalr	-1432(ra) # 8000346c <nameiparent>
    80004a0c:	892a                	mv	s2,a0
    80004a0e:	c935                	beqz	a0,80004a82 <sys_link+0x10a>
  ilock(dp);
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	28c080e7          	jalr	652(ra) # 80002c9c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a18:	00092703          	lw	a4,0(s2)
    80004a1c:	409c                	lw	a5,0(s1)
    80004a1e:	04f71d63          	bne	a4,a5,80004a78 <sys_link+0x100>
    80004a22:	40d0                	lw	a2,4(s1)
    80004a24:	fd040593          	addi	a1,s0,-48
    80004a28:	854a                	mv	a0,s2
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	970080e7          	jalr	-1680(ra) # 8000339a <dirlink>
    80004a32:	04054363          	bltz	a0,80004a78 <sys_link+0x100>
  iunlockput(dp);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	4c8080e7          	jalr	1224(ra) # 80002f00 <iunlockput>
  iput(ip);
    80004a40:	8526                	mv	a0,s1
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	416080e7          	jalr	1046(ra) # 80002e58 <iput>
  end_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	ca2080e7          	jalr	-862(ra) # 800036ec <end_op>
  return 0;
    80004a52:	4781                	li	a5,0
    80004a54:	a085                	j	80004ab4 <sys_link+0x13c>
    end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	c96080e7          	jalr	-874(ra) # 800036ec <end_op>
    return -1;
    80004a5e:	57fd                	li	a5,-1
    80004a60:	a891                	j	80004ab4 <sys_link+0x13c>
    iunlockput(ip);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	49c080e7          	jalr	1180(ra) # 80002f00 <iunlockput>
    end_op();
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	c80080e7          	jalr	-896(ra) # 800036ec <end_op>
    return -1;
    80004a74:	57fd                	li	a5,-1
    80004a76:	a83d                	j	80004ab4 <sys_link+0x13c>
    iunlockput(dp);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	486080e7          	jalr	1158(ra) # 80002f00 <iunlockput>
  ilock(ip);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	218080e7          	jalr	536(ra) # 80002c9c <ilock>
  ip->nlink--;
    80004a8c:	04a4d783          	lhu	a5,74(s1)
    80004a90:	37fd                	addiw	a5,a5,-1
    80004a92:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	138080e7          	jalr	312(ra) # 80002bd0 <iupdate>
  iunlockput(ip);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	45e080e7          	jalr	1118(ra) # 80002f00 <iunlockput>
  end_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	c42080e7          	jalr	-958(ra) # 800036ec <end_op>
  return -1;
    80004ab2:	57fd                	li	a5,-1
}
    80004ab4:	853e                	mv	a0,a5
    80004ab6:	70b2                	ld	ra,296(sp)
    80004ab8:	7412                	ld	s0,288(sp)
    80004aba:	64f2                	ld	s1,280(sp)
    80004abc:	6952                	ld	s2,272(sp)
    80004abe:	6155                	addi	sp,sp,304
    80004ac0:	8082                	ret

0000000080004ac2 <sys_unlink>:
{
    80004ac2:	7151                	addi	sp,sp,-240
    80004ac4:	f586                	sd	ra,232(sp)
    80004ac6:	f1a2                	sd	s0,224(sp)
    80004ac8:	eda6                	sd	s1,216(sp)
    80004aca:	e9ca                	sd	s2,208(sp)
    80004acc:	e5ce                	sd	s3,200(sp)
    80004ace:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ad0:	08000613          	li	a2,128
    80004ad4:	f3040593          	addi	a1,s0,-208
    80004ad8:	4501                	li	a0,0
    80004ada:	ffffd097          	auipc	ra,0xffffd
    80004ade:	57a080e7          	jalr	1402(ra) # 80002054 <argstr>
    80004ae2:	16054f63          	bltz	a0,80004c60 <sys_unlink+0x19e>
  begin_op();
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	b86080e7          	jalr	-1146(ra) # 8000366c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aee:	fb040593          	addi	a1,s0,-80
    80004af2:	f3040513          	addi	a0,s0,-208
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	976080e7          	jalr	-1674(ra) # 8000346c <nameiparent>
    80004afe:	89aa                	mv	s3,a0
    80004b00:	c979                	beqz	a0,80004bd6 <sys_unlink+0x114>
  ilock(dp);
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	19a080e7          	jalr	410(ra) # 80002c9c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b0a:	00004597          	auipc	a1,0x4
    80004b0e:	ce658593          	addi	a1,a1,-794 # 800087f0 <syscall_name_list+0x388>
    80004b12:	fb040513          	addi	a0,s0,-80
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	652080e7          	jalr	1618(ra) # 80003168 <namecmp>
    80004b1e:	14050863          	beqz	a0,80004c6e <sys_unlink+0x1ac>
    80004b22:	00004597          	auipc	a1,0x4
    80004b26:	cd658593          	addi	a1,a1,-810 # 800087f8 <syscall_name_list+0x390>
    80004b2a:	fb040513          	addi	a0,s0,-80
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	63a080e7          	jalr	1594(ra) # 80003168 <namecmp>
    80004b36:	12050c63          	beqz	a0,80004c6e <sys_unlink+0x1ac>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b3a:	f2c40613          	addi	a2,s0,-212
    80004b3e:	fb040593          	addi	a1,s0,-80
    80004b42:	854e                	mv	a0,s3
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	63e080e7          	jalr	1598(ra) # 80003182 <dirlookup>
    80004b4c:	84aa                	mv	s1,a0
    80004b4e:	12050063          	beqz	a0,80004c6e <sys_unlink+0x1ac>
  ilock(ip);
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	14a080e7          	jalr	330(ra) # 80002c9c <ilock>
  if(ip->nlink < 1)
    80004b5a:	04a49783          	lh	a5,74(s1)
    80004b5e:	08f05263          	blez	a5,80004be2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b62:	04449703          	lh	a4,68(s1)
    80004b66:	4785                	li	a5,1
    80004b68:	08f70563          	beq	a4,a5,80004bf2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b6c:	4641                	li	a2,16
    80004b6e:	4581                	li	a1,0
    80004b70:	fc040513          	addi	a0,s0,-64
    80004b74:	ffffb097          	auipc	ra,0xffffb
    80004b78:	630080e7          	jalr	1584(ra) # 800001a4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7c:	4741                	li	a4,16
    80004b7e:	f2c42683          	lw	a3,-212(s0)
    80004b82:	fc040613          	addi	a2,s0,-64
    80004b86:	4581                	li	a1,0
    80004b88:	854e                	mv	a0,s3
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	4c0080e7          	jalr	1216(ra) # 8000304a <writei>
    80004b92:	47c1                	li	a5,16
    80004b94:	0af51363          	bne	a0,a5,80004c3a <sys_unlink+0x178>
  if(ip->type == T_DIR){
    80004b98:	04449703          	lh	a4,68(s1)
    80004b9c:	4785                	li	a5,1
    80004b9e:	0af70663          	beq	a4,a5,80004c4a <sys_unlink+0x188>
  iunlockput(dp);
    80004ba2:	854e                	mv	a0,s3
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	35c080e7          	jalr	860(ra) # 80002f00 <iunlockput>
  ip->nlink--;
    80004bac:	04a4d783          	lhu	a5,74(s1)
    80004bb0:	37fd                	addiw	a5,a5,-1
    80004bb2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	018080e7          	jalr	24(ra) # 80002bd0 <iupdate>
  iunlockput(ip);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	33e080e7          	jalr	830(ra) # 80002f00 <iunlockput>
  end_op();
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	b22080e7          	jalr	-1246(ra) # 800036ec <end_op>
  return 0;
    80004bd2:	4501                	li	a0,0
    80004bd4:	a07d                	j	80004c82 <sys_unlink+0x1c0>
    end_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	b16080e7          	jalr	-1258(ra) # 800036ec <end_op>
    return -1;
    80004bde:	557d                	li	a0,-1
    80004be0:	a04d                	j	80004c82 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80004be2:	00004517          	auipc	a0,0x4
    80004be6:	c1e50513          	addi	a0,a0,-994 # 80008800 <syscall_name_list+0x398>
    80004bea:	00001097          	auipc	ra,0x1
    80004bee:	26e080e7          	jalr	622(ra) # 80005e58 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf2:	44f8                	lw	a4,76(s1)
    80004bf4:	02000793          	li	a5,32
    80004bf8:	f6e7fae3          	bleu	a4,a5,80004b6c <sys_unlink+0xaa>
    80004bfc:	02000913          	li	s2,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86ca                	mv	a3,s2
    80004c04:	f1840613          	addi	a2,s0,-232
    80004c08:	4581                	li	a1,0
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	346080e7          	jalr	838(ra) # 80002f52 <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	00f51a63          	bne	a0,a5,80004c2a <sys_unlink+0x168>
    if(de.inum != 0)
    80004c1a:	f1845783          	lhu	a5,-232(s0)
    80004c1e:	e3b9                	bnez	a5,80004c64 <sys_unlink+0x1a2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c20:	2941                	addiw	s2,s2,16
    80004c22:	44fc                	lw	a5,76(s1)
    80004c24:	fcf96ee3          	bltu	s2,a5,80004c00 <sys_unlink+0x13e>
    80004c28:	b791                	j	80004b6c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	bee50513          	addi	a0,a0,-1042 # 80008818 <syscall_name_list+0x3b0>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	226080e7          	jalr	550(ra) # 80005e58 <panic>
    panic("unlink: writei");
    80004c3a:	00004517          	auipc	a0,0x4
    80004c3e:	bf650513          	addi	a0,a0,-1034 # 80008830 <syscall_name_list+0x3c8>
    80004c42:	00001097          	auipc	ra,0x1
    80004c46:	216080e7          	jalr	534(ra) # 80005e58 <panic>
    dp->nlink--;
    80004c4a:	04a9d783          	lhu	a5,74(s3)
    80004c4e:	37fd                	addiw	a5,a5,-1
    80004c50:	04f99523          	sh	a5,74(s3)
    iupdate(dp);
    80004c54:	854e                	mv	a0,s3
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	f7a080e7          	jalr	-134(ra) # 80002bd0 <iupdate>
    80004c5e:	b791                	j	80004ba2 <sys_unlink+0xe0>
    return -1;
    80004c60:	557d                	li	a0,-1
    80004c62:	a005                	j	80004c82 <sys_unlink+0x1c0>
    iunlockput(ip);
    80004c64:	8526                	mv	a0,s1
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	29a080e7          	jalr	666(ra) # 80002f00 <iunlockput>
  iunlockput(dp);
    80004c6e:	854e                	mv	a0,s3
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	290080e7          	jalr	656(ra) # 80002f00 <iunlockput>
  end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	a74080e7          	jalr	-1420(ra) # 800036ec <end_op>
  return -1;
    80004c80:	557d                	li	a0,-1
}
    80004c82:	70ae                	ld	ra,232(sp)
    80004c84:	740e                	ld	s0,224(sp)
    80004c86:	64ee                	ld	s1,216(sp)
    80004c88:	694e                	ld	s2,208(sp)
    80004c8a:	69ae                	ld	s3,200(sp)
    80004c8c:	616d                	addi	sp,sp,240
    80004c8e:	8082                	ret

0000000080004c90 <sys_open>:

uint64
sys_open(void)
{
    80004c90:	7131                	addi	sp,sp,-192
    80004c92:	fd06                	sd	ra,184(sp)
    80004c94:	f922                	sd	s0,176(sp)
    80004c96:	f526                	sd	s1,168(sp)
    80004c98:	f14a                	sd	s2,160(sp)
    80004c9a:	ed4e                	sd	s3,152(sp)
    80004c9c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c9e:	f4c40593          	addi	a1,s0,-180
    80004ca2:	4505                	li	a0,1
    80004ca4:	ffffd097          	auipc	ra,0xffffd
    80004ca8:	370080e7          	jalr	880(ra) # 80002014 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cac:	08000613          	li	a2,128
    80004cb0:	f5040593          	addi	a1,s0,-176
    80004cb4:	4501                	li	a0,0
    80004cb6:	ffffd097          	auipc	ra,0xffffd
    80004cba:	39e080e7          	jalr	926(ra) # 80002054 <argstr>
    return -1;
    80004cbe:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cc0:	0a054863          	bltz	a0,80004d70 <sys_open+0xe0>

  begin_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	9a8080e7          	jalr	-1624(ra) # 8000366c <begin_op>

  if(omode & O_CREATE){
    80004ccc:	f4c42783          	lw	a5,-180(s0)
    80004cd0:	2007f793          	andi	a5,a5,512
    80004cd4:	cbdd                	beqz	a5,80004d8a <sys_open+0xfa>
    ip = create(path, T_FILE, 0, 0);
    80004cd6:	4681                	li	a3,0
    80004cd8:	4601                	li	a2,0
    80004cda:	4589                	li	a1,2
    80004cdc:	f5040513          	addi	a0,s0,-176
    80004ce0:	00000097          	auipc	ra,0x0
    80004ce4:	978080e7          	jalr	-1672(ra) # 80004658 <create>
    80004ce8:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cea:	c959                	beqz	a0,80004d80 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cec:	04449703          	lh	a4,68(s1)
    80004cf0:	478d                	li	a5,3
    80004cf2:	00f71763          	bne	a4,a5,80004d00 <sys_open+0x70>
    80004cf6:	0464d703          	lhu	a4,70(s1)
    80004cfa:	47a5                	li	a5,9
    80004cfc:	0ce7ec63          	bltu	a5,a4,80004dd4 <sys_open+0x144>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	d96080e7          	jalr	-618(ra) # 80003a96 <filealloc>
    80004d08:	89aa                	mv	s3,a0
    80004d0a:	10050263          	beqz	a0,80004e0e <sys_open+0x17e>
    80004d0e:	00000097          	auipc	ra,0x0
    80004d12:	902080e7          	jalr	-1790(ra) # 80004610 <fdalloc>
    80004d16:	892a                	mv	s2,a0
    80004d18:	0e054663          	bltz	a0,80004e04 <sys_open+0x174>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d1c:	04449703          	lh	a4,68(s1)
    80004d20:	478d                	li	a5,3
    80004d22:	0cf70463          	beq	a4,a5,80004dea <sys_open+0x15a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d26:	4789                	li	a5,2
    80004d28:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d2c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d30:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d34:	f4c42783          	lw	a5,-180(s0)
    80004d38:	0017c713          	xori	a4,a5,1
    80004d3c:	8b05                	andi	a4,a4,1
    80004d3e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d42:	0037f713          	andi	a4,a5,3
    80004d46:	00e03733          	snez	a4,a4
    80004d4a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d4e:	4007f793          	andi	a5,a5,1024
    80004d52:	c791                	beqz	a5,80004d5e <sys_open+0xce>
    80004d54:	04449703          	lh	a4,68(s1)
    80004d58:	4789                	li	a5,2
    80004d5a:	08f70f63          	beq	a4,a5,80004df8 <sys_open+0x168>
    itrunc(ip);
  }

  iunlock(ip);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	000080e7          	jalr	ra # 80002d60 <iunlock>
  end_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	984080e7          	jalr	-1660(ra) # 800036ec <end_op>

  return fd;
}
    80004d70:	854a                	mv	a0,s2
    80004d72:	70ea                	ld	ra,184(sp)
    80004d74:	744a                	ld	s0,176(sp)
    80004d76:	74aa                	ld	s1,168(sp)
    80004d78:	790a                	ld	s2,160(sp)
    80004d7a:	69ea                	ld	s3,152(sp)
    80004d7c:	6129                	addi	sp,sp,192
    80004d7e:	8082                	ret
      end_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	96c080e7          	jalr	-1684(ra) # 800036ec <end_op>
      return -1;
    80004d88:	b7e5                	j	80004d70 <sys_open+0xe0>
    if((ip = namei(path)) == 0){
    80004d8a:	f5040513          	addi	a0,s0,-176
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	6c0080e7          	jalr	1728(ra) # 8000344e <namei>
    80004d96:	84aa                	mv	s1,a0
    80004d98:	c905                	beqz	a0,80004dc8 <sys_open+0x138>
    ilock(ip);
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	f02080e7          	jalr	-254(ra) # 80002c9c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da2:	04449703          	lh	a4,68(s1)
    80004da6:	4785                	li	a5,1
    80004da8:	f4f712e3          	bne	a4,a5,80004cec <sys_open+0x5c>
    80004dac:	f4c42783          	lw	a5,-180(s0)
    80004db0:	dba1                	beqz	a5,80004d00 <sys_open+0x70>
      iunlockput(ip);
    80004db2:	8526                	mv	a0,s1
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	14c080e7          	jalr	332(ra) # 80002f00 <iunlockput>
      end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	930080e7          	jalr	-1744(ra) # 800036ec <end_op>
      return -1;
    80004dc4:	597d                	li	s2,-1
    80004dc6:	b76d                	j	80004d70 <sys_open+0xe0>
      end_op();
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	924080e7          	jalr	-1756(ra) # 800036ec <end_op>
      return -1;
    80004dd0:	597d                	li	s2,-1
    80004dd2:	bf79                	j	80004d70 <sys_open+0xe0>
    iunlockput(ip);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	12a080e7          	jalr	298(ra) # 80002f00 <iunlockput>
    end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	90e080e7          	jalr	-1778(ra) # 800036ec <end_op>
    return -1;
    80004de6:	597d                	li	s2,-1
    80004de8:	b761                	j	80004d70 <sys_open+0xe0>
    f->type = FD_DEVICE;
    80004dea:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dee:	04649783          	lh	a5,70(s1)
    80004df2:	02f99223          	sh	a5,36(s3)
    80004df6:	bf2d                	j	80004d30 <sys_open+0xa0>
    itrunc(ip);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	fb2080e7          	jalr	-78(ra) # 80002dac <itrunc>
    80004e02:	bfb1                	j	80004d5e <sys_open+0xce>
      fileclose(f);
    80004e04:	854e                	mv	a0,s3
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	d60080e7          	jalr	-672(ra) # 80003b66 <fileclose>
    iunlockput(ip);
    80004e0e:	8526                	mv	a0,s1
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	0f0080e7          	jalr	240(ra) # 80002f00 <iunlockput>
    end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	8d4080e7          	jalr	-1836(ra) # 800036ec <end_op>
    return -1;
    80004e20:	597d                	li	s2,-1
    80004e22:	b7b9                	j	80004d70 <sys_open+0xe0>

0000000080004e24 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e24:	7175                	addi	sp,sp,-144
    80004e26:	e506                	sd	ra,136(sp)
    80004e28:	e122                	sd	s0,128(sp)
    80004e2a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	840080e7          	jalr	-1984(ra) # 8000366c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e34:	08000613          	li	a2,128
    80004e38:	f7040593          	addi	a1,s0,-144
    80004e3c:	4501                	li	a0,0
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	216080e7          	jalr	534(ra) # 80002054 <argstr>
    80004e46:	02054963          	bltz	a0,80004e78 <sys_mkdir+0x54>
    80004e4a:	4681                	li	a3,0
    80004e4c:	4601                	li	a2,0
    80004e4e:	4585                	li	a1,1
    80004e50:	f7040513          	addi	a0,s0,-144
    80004e54:	00000097          	auipc	ra,0x0
    80004e58:	804080e7          	jalr	-2044(ra) # 80004658 <create>
    80004e5c:	cd11                	beqz	a0,80004e78 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	0a2080e7          	jalr	162(ra) # 80002f00 <iunlockput>
  end_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	886080e7          	jalr	-1914(ra) # 800036ec <end_op>
  return 0;
    80004e6e:	4501                	li	a0,0
}
    80004e70:	60aa                	ld	ra,136(sp)
    80004e72:	640a                	ld	s0,128(sp)
    80004e74:	6149                	addi	sp,sp,144
    80004e76:	8082                	ret
    end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	874080e7          	jalr	-1932(ra) # 800036ec <end_op>
    return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b7fd                	j	80004e70 <sys_mkdir+0x4c>

0000000080004e84 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e84:	7135                	addi	sp,sp,-160
    80004e86:	ed06                	sd	ra,152(sp)
    80004e88:	e922                	sd	s0,144(sp)
    80004e8a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	7e0080e7          	jalr	2016(ra) # 8000366c <begin_op>
  argint(1, &major);
    80004e94:	f6c40593          	addi	a1,s0,-148
    80004e98:	4505                	li	a0,1
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	17a080e7          	jalr	378(ra) # 80002014 <argint>
  argint(2, &minor);
    80004ea2:	f6840593          	addi	a1,s0,-152
    80004ea6:	4509                	li	a0,2
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	16c080e7          	jalr	364(ra) # 80002014 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb0:	08000613          	li	a2,128
    80004eb4:	f7040593          	addi	a1,s0,-144
    80004eb8:	4501                	li	a0,0
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	19a080e7          	jalr	410(ra) # 80002054 <argstr>
    80004ec2:	02054b63          	bltz	a0,80004ef8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ec6:	f6841683          	lh	a3,-152(s0)
    80004eca:	f6c41603          	lh	a2,-148(s0)
    80004ece:	458d                	li	a1,3
    80004ed0:	f7040513          	addi	a0,s0,-144
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	784080e7          	jalr	1924(ra) # 80004658 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004edc:	cd11                	beqz	a0,80004ef8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	022080e7          	jalr	34(ra) # 80002f00 <iunlockput>
  end_op();
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	806080e7          	jalr	-2042(ra) # 800036ec <end_op>
  return 0;
    80004eee:	4501                	li	a0,0
}
    80004ef0:	60ea                	ld	ra,152(sp)
    80004ef2:	644a                	ld	s0,144(sp)
    80004ef4:	610d                	addi	sp,sp,160
    80004ef6:	8082                	ret
    end_op();
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	7f4080e7          	jalr	2036(ra) # 800036ec <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	b7fd                	j	80004ef0 <sys_mknod+0x6c>

0000000080004f04 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f04:	7135                	addi	sp,sp,-160
    80004f06:	ed06                	sd	ra,152(sp)
    80004f08:	e922                	sd	s0,144(sp)
    80004f0a:	e526                	sd	s1,136(sp)
    80004f0c:	e14a                	sd	s2,128(sp)
    80004f0e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f10:	ffffc097          	auipc	ra,0xffffc
    80004f14:	fae080e7          	jalr	-82(ra) # 80000ebe <myproc>
    80004f18:	892a                	mv	s2,a0
  
  begin_op();
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	752080e7          	jalr	1874(ra) # 8000366c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f22:	08000613          	li	a2,128
    80004f26:	f6040593          	addi	a1,s0,-160
    80004f2a:	4501                	li	a0,0
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	128080e7          	jalr	296(ra) # 80002054 <argstr>
    80004f34:	04054b63          	bltz	a0,80004f8a <sys_chdir+0x86>
    80004f38:	f6040513          	addi	a0,s0,-160
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	512080e7          	jalr	1298(ra) # 8000344e <namei>
    80004f44:	84aa                	mv	s1,a0
    80004f46:	c131                	beqz	a0,80004f8a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	d54080e7          	jalr	-684(ra) # 80002c9c <ilock>
  if(ip->type != T_DIR){
    80004f50:	04449703          	lh	a4,68(s1)
    80004f54:	4785                	li	a5,1
    80004f56:	04f71063          	bne	a4,a5,80004f96 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f5a:	8526                	mv	a0,s1
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	e04080e7          	jalr	-508(ra) # 80002d60 <iunlock>
  iput(p->cwd);
    80004f64:	15093503          	ld	a0,336(s2)
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	ef0080e7          	jalr	-272(ra) # 80002e58 <iput>
  end_op();
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	77c080e7          	jalr	1916(ra) # 800036ec <end_op>
  p->cwd = ip;
    80004f78:	14993823          	sd	s1,336(s2)
  return 0;
    80004f7c:	4501                	li	a0,0
}
    80004f7e:	60ea                	ld	ra,152(sp)
    80004f80:	644a                	ld	s0,144(sp)
    80004f82:	64aa                	ld	s1,136(sp)
    80004f84:	690a                	ld	s2,128(sp)
    80004f86:	610d                	addi	sp,sp,160
    80004f88:	8082                	ret
    end_op();
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	762080e7          	jalr	1890(ra) # 800036ec <end_op>
    return -1;
    80004f92:	557d                	li	a0,-1
    80004f94:	b7ed                	j	80004f7e <sys_chdir+0x7a>
    iunlockput(ip);
    80004f96:	8526                	mv	a0,s1
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	f68080e7          	jalr	-152(ra) # 80002f00 <iunlockput>
    end_op();
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	74c080e7          	jalr	1868(ra) # 800036ec <end_op>
    return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	bfd1                	j	80004f7e <sys_chdir+0x7a>

0000000080004fac <sys_exec>:

uint64
sys_exec(void)
{
    80004fac:	7145                	addi	sp,sp,-464
    80004fae:	e786                	sd	ra,456(sp)
    80004fb0:	e3a2                	sd	s0,448(sp)
    80004fb2:	ff26                	sd	s1,440(sp)
    80004fb4:	fb4a                	sd	s2,432(sp)
    80004fb6:	f74e                	sd	s3,424(sp)
    80004fb8:	f352                	sd	s4,416(sp)
    80004fba:	ef56                	sd	s5,408(sp)
    80004fbc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fbe:	e3840593          	addi	a1,s0,-456
    80004fc2:	4505                	li	a0,1
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	070080e7          	jalr	112(ra) # 80002034 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fcc:	08000613          	li	a2,128
    80004fd0:	f4040593          	addi	a1,s0,-192
    80004fd4:	4501                	li	a0,0
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	07e080e7          	jalr	126(ra) # 80002054 <argstr>
    return -1;
    80004fde:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fe0:	0e054363          	bltz	a0,800050c6 <sys_exec+0x11a>
  }
  memset(argv, 0, sizeof(argv));
    80004fe4:	e4040913          	addi	s2,s0,-448
    80004fe8:	10000613          	li	a2,256
    80004fec:	4581                	li	a1,0
    80004fee:	854a                	mv	a0,s2
    80004ff0:	ffffb097          	auipc	ra,0xffffb
    80004ff4:	1b4080e7          	jalr	436(ra) # 800001a4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ff8:	89ca                	mv	s3,s2
  memset(argv, 0, sizeof(argv));
    80004ffa:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80004ffc:	02000a93          	li	s5,32
    80005000:	00048a1b          	sext.w	s4,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005004:	00349513          	slli	a0,s1,0x3
    80005008:	e3040593          	addi	a1,s0,-464
    8000500c:	e3843783          	ld	a5,-456(s0)
    80005010:	953e                	add	a0,a0,a5
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	f62080e7          	jalr	-158(ra) # 80001f74 <fetchaddr>
    8000501a:	02054a63          	bltz	a0,8000504e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    8000501e:	e3043783          	ld	a5,-464(s0)
    80005022:	cfa9                	beqz	a5,8000507c <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	0f8080e7          	jalr	248(ra) # 8000011c <kalloc>
    8000502c:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80005030:	cd19                	beqz	a0,8000504e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005032:	6605                	lui	a2,0x1
    80005034:	85aa                	mv	a1,a0
    80005036:	e3043503          	ld	a0,-464(s0)
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	f8e080e7          	jalr	-114(ra) # 80001fc8 <fetchstr>
    80005042:	00054663          	bltz	a0,8000504e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005046:	0485                	addi	s1,s1,1
    80005048:	0921                	addi	s2,s2,8
    8000504a:	fb549be3          	bne	s1,s5,80005000 <sys_exec+0x54>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504e:	e4043503          	ld	a0,-448(s0)
    kfree(argv[i]);
  return -1;
    80005052:	597d                	li	s2,-1
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005054:	c92d                	beqz	a0,800050c6 <sys_exec+0x11a>
    kfree(argv[i]);
    80005056:	ffffb097          	auipc	ra,0xffffb
    8000505a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	e4840493          	addi	s1,s0,-440
    80005062:	10098993          	addi	s3,s3,256
    80005066:	6088                	ld	a0,0(s1)
    80005068:	cd31                	beqz	a0,800050c4 <sys_exec+0x118>
    kfree(argv[i]);
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	fb2080e7          	jalr	-78(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005072:	04a1                	addi	s1,s1,8
    80005074:	ff3499e3          	bne	s1,s3,80005066 <sys_exec+0xba>
  return -1;
    80005078:	597d                	li	s2,-1
    8000507a:	a0b1                	j	800050c6 <sys_exec+0x11a>
      argv[i] = 0;
    8000507c:	0a0e                	slli	s4,s4,0x3
    8000507e:	fc040793          	addi	a5,s0,-64
    80005082:	9a3e                	add	s4,s4,a5
    80005084:	e80a3023          	sd	zero,-384(s4)
  int ret = exec(path, argv);
    80005088:	e4040593          	addi	a1,s0,-448
    8000508c:	f4040513          	addi	a0,s0,-192
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	164080e7          	jalr	356(ra) # 800041f4 <exec>
    80005098:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509a:	e4043503          	ld	a0,-448(s0)
    8000509e:	c505                	beqz	a0,800050c6 <sys_exec+0x11a>
    kfree(argv[i]);
    800050a0:	ffffb097          	auipc	ra,0xffffb
    800050a4:	f7c080e7          	jalr	-132(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a8:	e4840493          	addi	s1,s0,-440
    800050ac:	10098993          	addi	s3,s3,256
    800050b0:	6088                	ld	a0,0(s1)
    800050b2:	c911                	beqz	a0,800050c6 <sys_exec+0x11a>
    kfree(argv[i]);
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	f68080e7          	jalr	-152(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050bc:	04a1                	addi	s1,s1,8
    800050be:	ff3499e3          	bne	s1,s3,800050b0 <sys_exec+0x104>
    800050c2:	a011                	j	800050c6 <sys_exec+0x11a>
  return -1;
    800050c4:	597d                	li	s2,-1
}
    800050c6:	854a                	mv	a0,s2
    800050c8:	60be                	ld	ra,456(sp)
    800050ca:	641e                	ld	s0,448(sp)
    800050cc:	74fa                	ld	s1,440(sp)
    800050ce:	795a                	ld	s2,432(sp)
    800050d0:	79ba                	ld	s3,424(sp)
    800050d2:	7a1a                	ld	s4,416(sp)
    800050d4:	6afa                	ld	s5,408(sp)
    800050d6:	6179                	addi	sp,sp,464
    800050d8:	8082                	ret

00000000800050da <sys_pipe>:

uint64
sys_pipe(void)
{
    800050da:	7139                	addi	sp,sp,-64
    800050dc:	fc06                	sd	ra,56(sp)
    800050de:	f822                	sd	s0,48(sp)
    800050e0:	f426                	sd	s1,40(sp)
    800050e2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	dda080e7          	jalr	-550(ra) # 80000ebe <myproc>
    800050ec:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050ee:	fd840593          	addi	a1,s0,-40
    800050f2:	4501                	li	a0,0
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	f40080e7          	jalr	-192(ra) # 80002034 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050fc:	fc840593          	addi	a1,s0,-56
    80005100:	fd040513          	addi	a0,s0,-48
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	d86080e7          	jalr	-634(ra) # 80003e8a <pipealloc>
    return -1;
    8000510c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000510e:	0c054463          	bltz	a0,800051d6 <sys_pipe+0xfc>
  fd0 = -1;
    80005112:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005116:	fd043503          	ld	a0,-48(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	4f6080e7          	jalr	1270(ra) # 80004610 <fdalloc>
    80005122:	fca42223          	sw	a0,-60(s0)
    80005126:	08054b63          	bltz	a0,800051bc <sys_pipe+0xe2>
    8000512a:	fc843503          	ld	a0,-56(s0)
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	4e2080e7          	jalr	1250(ra) # 80004610 <fdalloc>
    80005136:	fca42023          	sw	a0,-64(s0)
    8000513a:	06054863          	bltz	a0,800051aa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513e:	4691                	li	a3,4
    80005140:	fc440613          	addi	a2,s0,-60
    80005144:	fd843583          	ld	a1,-40(s0)
    80005148:	68a8                	ld	a0,80(s1)
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	a1a080e7          	jalr	-1510(ra) # 80000b64 <copyout>
    80005152:	02054063          	bltz	a0,80005172 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005156:	4691                	li	a3,4
    80005158:	fc040613          	addi	a2,s0,-64
    8000515c:	fd843583          	ld	a1,-40(s0)
    80005160:	0591                	addi	a1,a1,4
    80005162:	68a8                	ld	a0,80(s1)
    80005164:	ffffc097          	auipc	ra,0xffffc
    80005168:	a00080e7          	jalr	-1536(ra) # 80000b64 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000516c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516e:	06055463          	bgez	a0,800051d6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005172:	fc442783          	lw	a5,-60(s0)
    80005176:	07e9                	addi	a5,a5,26
    80005178:	078e                	slli	a5,a5,0x3
    8000517a:	97a6                	add	a5,a5,s1
    8000517c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005180:	fc042783          	lw	a5,-64(s0)
    80005184:	07e9                	addi	a5,a5,26
    80005186:	078e                	slli	a5,a5,0x3
    80005188:	94be                	add	s1,s1,a5
    8000518a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000518e:	fd043503          	ld	a0,-48(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	9d4080e7          	jalr	-1580(ra) # 80003b66 <fileclose>
    fileclose(wf);
    8000519a:	fc843503          	ld	a0,-56(s0)
    8000519e:	fffff097          	auipc	ra,0xfffff
    800051a2:	9c8080e7          	jalr	-1592(ra) # 80003b66 <fileclose>
    return -1;
    800051a6:	57fd                	li	a5,-1
    800051a8:	a03d                	j	800051d6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051aa:	fc442783          	lw	a5,-60(s0)
    800051ae:	0007c763          	bltz	a5,800051bc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051b2:	07e9                	addi	a5,a5,26
    800051b4:	078e                	slli	a5,a5,0x3
    800051b6:	94be                	add	s1,s1,a5
    800051b8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051bc:	fd043503          	ld	a0,-48(s0)
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	9a6080e7          	jalr	-1626(ra) # 80003b66 <fileclose>
    fileclose(wf);
    800051c8:	fc843503          	ld	a0,-56(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	99a080e7          	jalr	-1638(ra) # 80003b66 <fileclose>
    return -1;
    800051d4:	57fd                	li	a5,-1
}
    800051d6:	853e                	mv	a0,a5
    800051d8:	70e2                	ld	ra,56(sp)
    800051da:	7442                	ld	s0,48(sp)
    800051dc:	74a2                	ld	s1,40(sp)
    800051de:	6121                	addi	sp,sp,64
    800051e0:	8082                	ret
	...

00000000800051f0 <kernelvec>:
    800051f0:	7111                	addi	sp,sp,-256
    800051f2:	e006                	sd	ra,0(sp)
    800051f4:	e40a                	sd	sp,8(sp)
    800051f6:	e80e                	sd	gp,16(sp)
    800051f8:	ec12                	sd	tp,24(sp)
    800051fa:	f016                	sd	t0,32(sp)
    800051fc:	f41a                	sd	t1,40(sp)
    800051fe:	f81e                	sd	t2,48(sp)
    80005200:	fc22                	sd	s0,56(sp)
    80005202:	e0a6                	sd	s1,64(sp)
    80005204:	e4aa                	sd	a0,72(sp)
    80005206:	e8ae                	sd	a1,80(sp)
    80005208:	ecb2                	sd	a2,88(sp)
    8000520a:	f0b6                	sd	a3,96(sp)
    8000520c:	f4ba                	sd	a4,104(sp)
    8000520e:	f8be                	sd	a5,112(sp)
    80005210:	fcc2                	sd	a6,120(sp)
    80005212:	e146                	sd	a7,128(sp)
    80005214:	e54a                	sd	s2,136(sp)
    80005216:	e94e                	sd	s3,144(sp)
    80005218:	ed52                	sd	s4,152(sp)
    8000521a:	f156                	sd	s5,160(sp)
    8000521c:	f55a                	sd	s6,168(sp)
    8000521e:	f95e                	sd	s7,176(sp)
    80005220:	fd62                	sd	s8,184(sp)
    80005222:	e1e6                	sd	s9,192(sp)
    80005224:	e5ea                	sd	s10,200(sp)
    80005226:	e9ee                	sd	s11,208(sp)
    80005228:	edf2                	sd	t3,216(sp)
    8000522a:	f1f6                	sd	t4,224(sp)
    8000522c:	f5fa                	sd	t5,232(sp)
    8000522e:	f9fe                	sd	t6,240(sp)
    80005230:	c0dfc0ef          	jal	ra,80001e3c <kerneltrap>
    80005234:	6082                	ld	ra,0(sp)
    80005236:	6122                	ld	sp,8(sp)
    80005238:	61c2                	ld	gp,16(sp)
    8000523a:	7282                	ld	t0,32(sp)
    8000523c:	7322                	ld	t1,40(sp)
    8000523e:	73c2                	ld	t2,48(sp)
    80005240:	7462                	ld	s0,56(sp)
    80005242:	6486                	ld	s1,64(sp)
    80005244:	6526                	ld	a0,72(sp)
    80005246:	65c6                	ld	a1,80(sp)
    80005248:	6666                	ld	a2,88(sp)
    8000524a:	7686                	ld	a3,96(sp)
    8000524c:	7726                	ld	a4,104(sp)
    8000524e:	77c6                	ld	a5,112(sp)
    80005250:	7866                	ld	a6,120(sp)
    80005252:	688a                	ld	a7,128(sp)
    80005254:	692a                	ld	s2,136(sp)
    80005256:	69ca                	ld	s3,144(sp)
    80005258:	6a6a                	ld	s4,152(sp)
    8000525a:	7a8a                	ld	s5,160(sp)
    8000525c:	7b2a                	ld	s6,168(sp)
    8000525e:	7bca                	ld	s7,176(sp)
    80005260:	7c6a                	ld	s8,184(sp)
    80005262:	6c8e                	ld	s9,192(sp)
    80005264:	6d2e                	ld	s10,200(sp)
    80005266:	6dce                	ld	s11,208(sp)
    80005268:	6e6e                	ld	t3,216(sp)
    8000526a:	7e8e                	ld	t4,224(sp)
    8000526c:	7f2e                	ld	t5,232(sp)
    8000526e:	7fce                	ld	t6,240(sp)
    80005270:	6111                	addi	sp,sp,256
    80005272:	10200073          	sret
    80005276:	00000013          	nop
    8000527a:	00000013          	nop
    8000527e:	0001                	nop

0000000080005280 <timervec>:
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	e10c                	sd	a1,0(a0)
    80005286:	e510                	sd	a2,8(a0)
    80005288:	e914                	sd	a3,16(a0)
    8000528a:	6d0c                	ld	a1,24(a0)
    8000528c:	7110                	ld	a2,32(a0)
    8000528e:	6194                	ld	a3,0(a1)
    80005290:	96b2                	add	a3,a3,a2
    80005292:	e194                	sd	a3,0(a1)
    80005294:	4589                	li	a1,2
    80005296:	14459073          	csrw	sip,a1
    8000529a:	6914                	ld	a3,16(a0)
    8000529c:	6510                	ld	a2,8(a0)
    8000529e:	610c                	ld	a1,0(a0)
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	30200073          	mret
	...

00000000800052aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052aa:	1141                	addi	sp,sp,-16
    800052ac:	e422                	sd	s0,8(sp)
    800052ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052b0:	0c0007b7          	lui	a5,0xc000
    800052b4:	4705                	li	a4,1
    800052b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052b8:	c3d8                	sw	a4,4(a5)
}
    800052ba:	6422                	ld	s0,8(sp)
    800052bc:	0141                	addi	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <plicinithart>:

void
plicinithart(void)
{
    800052c0:	1141                	addi	sp,sp,-16
    800052c2:	e406                	sd	ra,8(sp)
    800052c4:	e022                	sd	s0,0(sp)
    800052c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	bca080e7          	jalr	-1078(ra) # 80000e92 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052d0:	0085171b          	slliw	a4,a0,0x8
    800052d4:	0c0027b7          	lui	a5,0xc002
    800052d8:	97ba                	add	a5,a5,a4
    800052da:	40200713          	li	a4,1026
    800052de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052e2:	00d5151b          	slliw	a0,a0,0xd
    800052e6:	0c2017b7          	lui	a5,0xc201
    800052ea:	953e                	add	a0,a0,a5
    800052ec:	00052023          	sw	zero,0(a0)
}
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	addi	sp,sp,16
    800052f6:	8082                	ret

00000000800052f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052f8:	1141                	addi	sp,sp,-16
    800052fa:	e406                	sd	ra,8(sp)
    800052fc:	e022                	sd	s0,0(sp)
    800052fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	b92080e7          	jalr	-1134(ra) # 80000e92 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005308:	00d5151b          	slliw	a0,a0,0xd
    8000530c:	0c2017b7          	lui	a5,0xc201
    80005310:	97aa                	add	a5,a5,a0
  return irq;
}
    80005312:	43c8                	lw	a0,4(a5)
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000531c:	1101                	addi	sp,sp,-32
    8000531e:	ec06                	sd	ra,24(sp)
    80005320:	e822                	sd	s0,16(sp)
    80005322:	e426                	sd	s1,8(sp)
    80005324:	1000                	addi	s0,sp,32
    80005326:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	b6a080e7          	jalr	-1174(ra) # 80000e92 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005330:	00d5151b          	slliw	a0,a0,0xd
    80005334:	0c2017b7          	lui	a5,0xc201
    80005338:	97aa                	add	a5,a5,a0
    8000533a:	c3c4                	sw	s1,4(a5)
}
    8000533c:	60e2                	ld	ra,24(sp)
    8000533e:	6442                	ld	s0,16(sp)
    80005340:	64a2                	ld	s1,8(sp)
    80005342:	6105                	addi	sp,sp,32
    80005344:	8082                	ret

0000000080005346 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005346:	1141                	addi	sp,sp,-16
    80005348:	e406                	sd	ra,8(sp)
    8000534a:	e022                	sd	s0,0(sp)
    8000534c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000534e:	479d                	li	a5,7
    80005350:	04a7cc63          	blt	a5,a0,800053a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005354:	00015797          	auipc	a5,0x15
    80005358:	9fc78793          	addi	a5,a5,-1540 # 80019d50 <disk>
    8000535c:	97aa                	add	a5,a5,a0
    8000535e:	0187c783          	lbu	a5,24(a5)
    80005362:	ebb9                	bnez	a5,800053b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005364:	00451613          	slli	a2,a0,0x4
    80005368:	00015797          	auipc	a5,0x15
    8000536c:	9e878793          	addi	a5,a5,-1560 # 80019d50 <disk>
    80005370:	6394                	ld	a3,0(a5)
    80005372:	96b2                	add	a3,a3,a2
    80005374:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005378:	6398                	ld	a4,0(a5)
    8000537a:	9732                	add	a4,a4,a2
    8000537c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005380:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005384:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005388:	97aa                	add	a5,a5,a0
    8000538a:	4705                	li	a4,1
    8000538c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005390:	00015517          	auipc	a0,0x15
    80005394:	9d850513          	addi	a0,a0,-1576 # 80019d68 <disk+0x18>
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	23a080e7          	jalr	570(ra) # 800015d2 <wakeup>
}
    800053a0:	60a2                	ld	ra,8(sp)
    800053a2:	6402                	ld	s0,0(sp)
    800053a4:	0141                	addi	sp,sp,16
    800053a6:	8082                	ret
    panic("free_desc 1");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	49850513          	addi	a0,a0,1176 # 80008840 <syscall_name_list+0x3d8>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	aa8080e7          	jalr	-1368(ra) # 80005e58 <panic>
    panic("free_desc 2");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	49850513          	addi	a0,a0,1176 # 80008850 <syscall_name_list+0x3e8>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	a98080e7          	jalr	-1384(ra) # 80005e58 <panic>

00000000800053c8 <virtio_disk_init>:
{
    800053c8:	1101                	addi	sp,sp,-32
    800053ca:	ec06                	sd	ra,24(sp)
    800053cc:	e822                	sd	s0,16(sp)
    800053ce:	e426                	sd	s1,8(sp)
    800053d0:	e04a                	sd	s2,0(sp)
    800053d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053d4:	00003597          	auipc	a1,0x3
    800053d8:	48c58593          	addi	a1,a1,1164 # 80008860 <syscall_name_list+0x3f8>
    800053dc:	00015517          	auipc	a0,0x15
    800053e0:	a9c50513          	addi	a0,a0,-1380 # 80019e78 <disk+0x128>
    800053e4:	00001097          	auipc	ra,0x1
    800053e8:	f50080e7          	jalr	-176(ra) # 80006334 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053ec:	100017b7          	lui	a5,0x10001
    800053f0:	4398                	lw	a4,0(a5)
    800053f2:	2701                	sext.w	a4,a4
    800053f4:	747277b7          	lui	a5,0x74727
    800053f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053fc:	14f71b63          	bne	a4,a5,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005400:	100017b7          	lui	a5,0x10001
    80005404:	43dc                	lw	a5,4(a5)
    80005406:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005408:	4709                	li	a4,2
    8000540a:	14e79463          	bne	a5,a4,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	479c                	lw	a5,8(a5)
    80005414:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005416:	12e79e63          	bne	a5,a4,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000541a:	100017b7          	lui	a5,0x10001
    8000541e:	47d8                	lw	a4,12(a5)
    80005420:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005422:	554d47b7          	lui	a5,0x554d4
    80005426:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000542a:	12f71463          	bne	a4,a5,80005552 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	4705                	li	a4,1
    80005438:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543a:	470d                	li	a4,3
    8000543c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000543e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005440:	c7ffe737          	lui	a4,0xc7ffe
    80005444:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc68f>
    80005448:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000544a:	2701                	sext.w	a4,a4
    8000544c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544e:	472d                	li	a4,11
    80005450:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005452:	0707a903          	lw	s2,112(a5)
    80005456:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005458:	00897793          	andi	a5,s2,8
    8000545c:	10078363          	beqz	a5,80005562 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005460:	100017b7          	lui	a5,0x10001
    80005464:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005468:	43fc                	lw	a5,68(a5)
    8000546a:	2781                	sext.w	a5,a5
    8000546c:	10079363          	bnez	a5,80005572 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005470:	100017b7          	lui	a5,0x10001
    80005474:	5bdc                	lw	a5,52(a5)
    80005476:	2781                	sext.w	a5,a5
  if(max == 0)
    80005478:	10078563          	beqz	a5,80005582 <virtio_disk_init+0x1ba>
  if(max < NUM)
    8000547c:	471d                	li	a4,7
    8000547e:	10f77a63          	bleu	a5,a4,80005592 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005482:	ffffb097          	auipc	ra,0xffffb
    80005486:	c9a080e7          	jalr	-870(ra) # 8000011c <kalloc>
    8000548a:	00015497          	auipc	s1,0x15
    8000548e:	8c648493          	addi	s1,s1,-1850 # 80019d50 <disk>
    80005492:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005494:	ffffb097          	auipc	ra,0xffffb
    80005498:	c88080e7          	jalr	-888(ra) # 8000011c <kalloc>
    8000549c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	c7e080e7          	jalr	-898(ra) # 8000011c <kalloc>
    800054a6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054a8:	609c                	ld	a5,0(s1)
    800054aa:	cfe5                	beqz	a5,800055a2 <virtio_disk_init+0x1da>
    800054ac:	6498                	ld	a4,8(s1)
    800054ae:	cb75                	beqz	a4,800055a2 <virtio_disk_init+0x1da>
    800054b0:	c96d                	beqz	a0,800055a2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800054b2:	6605                	lui	a2,0x1
    800054b4:	4581                	li	a1,0
    800054b6:	853e                	mv	a0,a5
    800054b8:	ffffb097          	auipc	ra,0xffffb
    800054bc:	cec080e7          	jalr	-788(ra) # 800001a4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800054c0:	00015497          	auipc	s1,0x15
    800054c4:	89048493          	addi	s1,s1,-1904 # 80019d50 <disk>
    800054c8:	6605                	lui	a2,0x1
    800054ca:	4581                	li	a1,0
    800054cc:	6488                	ld	a0,8(s1)
    800054ce:	ffffb097          	auipc	ra,0xffffb
    800054d2:	cd6080e7          	jalr	-810(ra) # 800001a4 <memset>
  memset(disk.used, 0, PGSIZE);
    800054d6:	6605                	lui	a2,0x1
    800054d8:	4581                	li	a1,0
    800054da:	6888                	ld	a0,16(s1)
    800054dc:	ffffb097          	auipc	ra,0xffffb
    800054e0:	cc8080e7          	jalr	-824(ra) # 800001a4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054e4:	100017b7          	lui	a5,0x10001
    800054e8:	4721                	li	a4,8
    800054ea:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054ec:	4098                	lw	a4,0(s1)
    800054ee:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054f2:	40d8                	lw	a4,4(s1)
    800054f4:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054f8:	6498                	ld	a4,8(s1)
    800054fa:	0007069b          	sext.w	a3,a4
    800054fe:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005502:	9701                	srai	a4,a4,0x20
    80005504:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005508:	6898                	ld	a4,16(s1)
    8000550a:	0007069b          	sext.w	a3,a4
    8000550e:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005512:	9701                	srai	a4,a4,0x20
    80005514:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005518:	4685                	li	a3,1
    8000551a:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    8000551c:	4705                	li	a4,1
    8000551e:	00d48c23          	sb	a3,24(s1)
    80005522:	00e48ca3          	sb	a4,25(s1)
    80005526:	00e48d23          	sb	a4,26(s1)
    8000552a:	00e48da3          	sb	a4,27(s1)
    8000552e:	00e48e23          	sb	a4,28(s1)
    80005532:	00e48ea3          	sb	a4,29(s1)
    80005536:	00e48f23          	sb	a4,30(s1)
    8000553a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000553e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005542:	0727a823          	sw	s2,112(a5)
}
    80005546:	60e2                	ld	ra,24(sp)
    80005548:	6442                	ld	s0,16(sp)
    8000554a:	64a2                	ld	s1,8(sp)
    8000554c:	6902                	ld	s2,0(sp)
    8000554e:	6105                	addi	sp,sp,32
    80005550:	8082                	ret
    panic("could not find virtio disk");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	31e50513          	addi	a0,a0,798 # 80008870 <syscall_name_list+0x408>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	8fe080e7          	jalr	-1794(ra) # 80005e58 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	32e50513          	addi	a0,a0,814 # 80008890 <syscall_name_list+0x428>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	8ee080e7          	jalr	-1810(ra) # 80005e58 <panic>
    panic("virtio disk should not be ready");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	33e50513          	addi	a0,a0,830 # 800088b0 <syscall_name_list+0x448>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	8de080e7          	jalr	-1826(ra) # 80005e58 <panic>
    panic("virtio disk has no queue 0");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	34e50513          	addi	a0,a0,846 # 800088d0 <syscall_name_list+0x468>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	8ce080e7          	jalr	-1842(ra) # 80005e58 <panic>
    panic("virtio disk max queue too short");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	35e50513          	addi	a0,a0,862 # 800088f0 <syscall_name_list+0x488>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	8be080e7          	jalr	-1858(ra) # 80005e58 <panic>
    panic("virtio disk kalloc");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	36e50513          	addi	a0,a0,878 # 80008910 <syscall_name_list+0x4a8>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	8ae080e7          	jalr	-1874(ra) # 80005e58 <panic>

00000000800055b2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055b2:	7159                	addi	sp,sp,-112
    800055b4:	f486                	sd	ra,104(sp)
    800055b6:	f0a2                	sd	s0,96(sp)
    800055b8:	eca6                	sd	s1,88(sp)
    800055ba:	e8ca                	sd	s2,80(sp)
    800055bc:	e4ce                	sd	s3,72(sp)
    800055be:	e0d2                	sd	s4,64(sp)
    800055c0:	fc56                	sd	s5,56(sp)
    800055c2:	f85a                	sd	s6,48(sp)
    800055c4:	f45e                	sd	s7,40(sp)
    800055c6:	f062                	sd	s8,32(sp)
    800055c8:	ec66                	sd	s9,24(sp)
    800055ca:	e86a                	sd	s10,16(sp)
    800055cc:	1880                	addi	s0,sp,112
    800055ce:	892a                	mv	s2,a0
    800055d0:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055d2:	00c52c03          	lw	s8,12(a0)
    800055d6:	001c1c1b          	slliw	s8,s8,0x1
    800055da:	1c02                	slli	s8,s8,0x20
    800055dc:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800055e0:	00015517          	auipc	a0,0x15
    800055e4:	89850513          	addi	a0,a0,-1896 # 80019e78 <disk+0x128>
    800055e8:	00001097          	auipc	ra,0x1
    800055ec:	ddc080e7          	jalr	-548(ra) # 800063c4 <acquire>
    if(disk.free[i]){
    800055f0:	00014997          	auipc	s3,0x14
    800055f4:	76098993          	addi	s3,s3,1888 # 80019d50 <disk>
  for(int i = 0; i < NUM; i++){
    800055f8:	4d05                	li	s10,1
    800055fa:	4b21                	li	s6,8
  for(int i = 0; i < 3; i++){
    800055fc:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055fe:	8a6a                	mv	s4,s10
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005600:	00015b97          	auipc	s7,0x15
    80005604:	878b8b93          	addi	s7,s7,-1928 # 80019e78 <disk+0x128>
    80005608:	a049                	j	8000568a <virtio_disk_rw+0xd8>
      disk.free[i] = 0;
    8000560a:	00f986b3          	add	a3,s3,a5
    8000560e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005612:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005614:	0207c963          	bltz	a5,80005646 <virtio_disk_rw+0x94>
  for(int i = 0; i < 3; i++){
    80005618:	2485                	addiw	s1,s1,1
    8000561a:	0711                	addi	a4,a4,4
    8000561c:	1f548f63          	beq	s1,s5,8000581a <virtio_disk_rw+0x268>
    idx[i] = alloc_desc();
    80005620:	863a                	mv	a2,a4
    if(disk.free[i]){
    80005622:	0189c783          	lbu	a5,24(s3)
    80005626:	22079263          	bnez	a5,8000584a <virtio_disk_rw+0x298>
    8000562a:	00014697          	auipc	a3,0x14
    8000562e:	72668693          	addi	a3,a3,1830 # 80019d50 <disk>
  for(int i = 0; i < NUM; i++){
    80005632:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005634:	0196c583          	lbu	a1,25(a3)
    80005638:	f9e9                	bnez	a1,8000560a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    8000563a:	2785                	addiw	a5,a5,1
    8000563c:	0685                	addi	a3,a3,1
    8000563e:	ff679be3          	bne	a5,s6,80005634 <virtio_disk_rw+0x82>
    idx[i] = alloc_desc();
    80005642:	57fd                	li	a5,-1
    80005644:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005646:	02905963          	blez	s1,80005678 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    8000564a:	f9042503          	lw	a0,-112(s0)
    8000564e:	00000097          	auipc	ra,0x0
    80005652:	cf8080e7          	jalr	-776(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    80005656:	029d5163          	ble	s1,s10,80005678 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    8000565a:	f9442503          	lw	a0,-108(s0)
    8000565e:	00000097          	auipc	ra,0x0
    80005662:	ce8080e7          	jalr	-792(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    80005666:	4789                	li	a5,2
    80005668:	0097d863          	ble	s1,a5,80005678 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    8000566c:	f9842503          	lw	a0,-104(s0)
    80005670:	00000097          	auipc	ra,0x0
    80005674:	cd6080e7          	jalr	-810(ra) # 80005346 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005678:	85de                	mv	a1,s7
    8000567a:	00014517          	auipc	a0,0x14
    8000567e:	6ee50513          	addi	a0,a0,1774 # 80019d68 <disk+0x18>
    80005682:	ffffc097          	auipc	ra,0xffffc
    80005686:	eec080e7          	jalr	-276(ra) # 8000156e <sleep>
  for(int i = 0; i < 3; i++){
    8000568a:	f9040713          	addi	a4,s0,-112
    8000568e:	4481                	li	s1,0
    80005690:	bf41                	j	80005620 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005692:	00a70793          	addi	a5,a4,10
    80005696:	00479613          	slli	a2,a5,0x4
    8000569a:	00014797          	auipc	a5,0x14
    8000569e:	6b678793          	addi	a5,a5,1718 # 80019d50 <disk>
    800056a2:	97b2                	add	a5,a5,a2
    800056a4:	4605                	li	a2,1
    800056a6:	c790                	sw	a2,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056a8:	00014617          	auipc	a2,0x14
    800056ac:	6a860613          	addi	a2,a2,1704 # 80019d50 <disk>
    800056b0:	00a70793          	addi	a5,a4,10
    800056b4:	0792                	slli	a5,a5,0x4
    800056b6:	97b2                	add	a5,a5,a2
    800056b8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800056bc:	0187b823          	sd	s8,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056c0:	621c                	ld	a5,0(a2)
    800056c2:	96be                	add	a3,a3,a5
    800056c4:	f6b6b023          	sd	a1,-160(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056c8:	620c                	ld	a1,0(a2)
    800056ca:	00471693          	slli	a3,a4,0x4
    800056ce:	00d58533          	add	a0,a1,a3
    800056d2:	47c1                	li	a5,16
    800056d4:	c51c                	sw	a5,8(a0)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056d6:	4785                	li	a5,1
    800056d8:	00f51623          	sh	a5,12(a0)
  disk.desc[idx[0]].next = idx[1];
    800056dc:	f9442783          	lw	a5,-108(s0)
    800056e0:	00f51723          	sh	a5,14(a0)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056e4:	0792                	slli	a5,a5,0x4
    800056e6:	95be                	add	a1,a1,a5
    800056e8:	05890513          	addi	a0,s2,88
    800056ec:	e188                	sd	a0,0(a1)
  disk.desc[idx[1]].len = BSIZE;
    800056ee:	6208                	ld	a0,0(a2)
    800056f0:	97aa                	add	a5,a5,a0
    800056f2:	40000613          	li	a2,1024
    800056f6:	c790                	sw	a2,8(a5)
  if(write)
    800056f8:	100c8d63          	beqz	s9,80005812 <virtio_disk_rw+0x260>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056fc:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005700:	00c7d603          	lhu	a2,12(a5)
    80005704:	00166613          	ori	a2,a2,1
    80005708:	00c79623          	sh	a2,12(a5)
  disk.desc[idx[1]].next = idx[2];
    8000570c:	f9842583          	lw	a1,-104(s0)
    80005710:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005714:	00014617          	auipc	a2,0x14
    80005718:	63c60613          	addi	a2,a2,1596 # 80019d50 <disk>
    8000571c:	00270793          	addi	a5,a4,2
    80005720:	0792                	slli	a5,a5,0x4
    80005722:	97b2                	add	a5,a5,a2
    80005724:	587d                	li	a6,-1
    80005726:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000572a:	0592                	slli	a1,a1,0x4
    8000572c:	952e                	add	a0,a0,a1
    8000572e:	03068693          	addi	a3,a3,48
    80005732:	96b2                	add	a3,a3,a2
    80005734:	e114                	sd	a3,0(a0)
  disk.desc[idx[2]].len = 1;
    80005736:	6214                	ld	a3,0(a2)
    80005738:	96ae                	add	a3,a3,a1
    8000573a:	4585                	li	a1,1
    8000573c:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000573e:	4509                	li	a0,2
    80005740:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005744:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005748:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    8000574c:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005750:	6614                	ld	a3,8(a2)
    80005752:	0026d783          	lhu	a5,2(a3)
    80005756:	8b9d                	andi	a5,a5,7
    80005758:	0786                	slli	a5,a5,0x1
    8000575a:	97b6                	add	a5,a5,a3
    8000575c:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    80005760:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005764:	6618                	ld	a4,8(a2)
    80005766:	00275783          	lhu	a5,2(a4)
    8000576a:	2785                	addiw	a5,a5,1
    8000576c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005770:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005774:	100017b7          	lui	a5,0x10001
    80005778:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000577c:	00492703          	lw	a4,4(s2)
    80005780:	4785                	li	a5,1
    80005782:	02f71163          	bne	a4,a5,800057a4 <virtio_disk_rw+0x1f2>
    sleep(b, &disk.vdisk_lock);
    80005786:	00014997          	auipc	s3,0x14
    8000578a:	6f298993          	addi	s3,s3,1778 # 80019e78 <disk+0x128>
  while(b->disk == 1) {
    8000578e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005790:	85ce                	mv	a1,s3
    80005792:	854a                	mv	a0,s2
    80005794:	ffffc097          	auipc	ra,0xffffc
    80005798:	dda080e7          	jalr	-550(ra) # 8000156e <sleep>
  while(b->disk == 1) {
    8000579c:	00492783          	lw	a5,4(s2)
    800057a0:	fe9788e3          	beq	a5,s1,80005790 <virtio_disk_rw+0x1de>
  }

  disk.info[idx[0]].b = 0;
    800057a4:	f9042503          	lw	a0,-112(s0)
    800057a8:	00250793          	addi	a5,a0,2
    800057ac:	00479713          	slli	a4,a5,0x4
    800057b0:	00014797          	auipc	a5,0x14
    800057b4:	5a078793          	addi	a5,a5,1440 # 80019d50 <disk>
    800057b8:	97ba                	add	a5,a5,a4
    800057ba:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057be:	00014997          	auipc	s3,0x14
    800057c2:	59298993          	addi	s3,s3,1426 # 80019d50 <disk>
    800057c6:	00451713          	slli	a4,a0,0x4
    800057ca:	0009b783          	ld	a5,0(s3)
    800057ce:	97ba                	add	a5,a5,a4
    800057d0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057d4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057d8:	00000097          	auipc	ra,0x0
    800057dc:	b6e080e7          	jalr	-1170(ra) # 80005346 <free_desc>
      i = nxt;
    800057e0:	854a                	mv	a0,s2
    if(flag & VRING_DESC_F_NEXT)
    800057e2:	8885                	andi	s1,s1,1
    800057e4:	f0ed                	bnez	s1,800057c6 <virtio_disk_rw+0x214>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057e6:	00014517          	auipc	a0,0x14
    800057ea:	69250513          	addi	a0,a0,1682 # 80019e78 <disk+0x128>
    800057ee:	00001097          	auipc	ra,0x1
    800057f2:	c8a080e7          	jalr	-886(ra) # 80006478 <release>
}
    800057f6:	70a6                	ld	ra,104(sp)
    800057f8:	7406                	ld	s0,96(sp)
    800057fa:	64e6                	ld	s1,88(sp)
    800057fc:	6946                	ld	s2,80(sp)
    800057fe:	69a6                	ld	s3,72(sp)
    80005800:	6a06                	ld	s4,64(sp)
    80005802:	7ae2                	ld	s5,56(sp)
    80005804:	7b42                	ld	s6,48(sp)
    80005806:	7ba2                	ld	s7,40(sp)
    80005808:	7c02                	ld	s8,32(sp)
    8000580a:	6ce2                	ld	s9,24(sp)
    8000580c:	6d42                	ld	s10,16(sp)
    8000580e:	6165                	addi	sp,sp,112
    80005810:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005812:	4609                	li	a2,2
    80005814:	00c79623          	sh	a2,12(a5)
    80005818:	b5e5                	j	80005700 <virtio_disk_rw+0x14e>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000581a:	f9042703          	lw	a4,-112(s0)
    8000581e:	00a70693          	addi	a3,a4,10
    80005822:	0692                	slli	a3,a3,0x4
    80005824:	00014597          	auipc	a1,0x14
    80005828:	53458593          	addi	a1,a1,1332 # 80019d58 <disk+0x8>
    8000582c:	95b6                	add	a1,a1,a3
  if(write)
    8000582e:	e60c92e3          	bnez	s9,80005692 <virtio_disk_rw+0xe0>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005832:	00a70793          	addi	a5,a4,10
    80005836:	00479613          	slli	a2,a5,0x4
    8000583a:	00014797          	auipc	a5,0x14
    8000583e:	51678793          	addi	a5,a5,1302 # 80019d50 <disk>
    80005842:	97b2                	add	a5,a5,a2
    80005844:	0007a423          	sw	zero,8(a5)
    80005848:	b585                	j	800056a8 <virtio_disk_rw+0xf6>
      disk.free[i] = 0;
    8000584a:	00098c23          	sb	zero,24(s3)
    idx[i] = alloc_desc();
    8000584e:	00072023          	sw	zero,0(a4)
    if(idx[i] < 0){
    80005852:	b3d9                	j	80005618 <virtio_disk_rw+0x66>

0000000080005854 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005854:	1101                	addi	sp,sp,-32
    80005856:	ec06                	sd	ra,24(sp)
    80005858:	e822                	sd	s0,16(sp)
    8000585a:	e426                	sd	s1,8(sp)
    8000585c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000585e:	00014497          	auipc	s1,0x14
    80005862:	4f248493          	addi	s1,s1,1266 # 80019d50 <disk>
    80005866:	00014517          	auipc	a0,0x14
    8000586a:	61250513          	addi	a0,a0,1554 # 80019e78 <disk+0x128>
    8000586e:	00001097          	auipc	ra,0x1
    80005872:	b56080e7          	jalr	-1194(ra) # 800063c4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005876:	10001737          	lui	a4,0x10001
    8000587a:	533c                	lw	a5,96(a4)
    8000587c:	8b8d                	andi	a5,a5,3
    8000587e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005880:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005884:	689c                	ld	a5,16(s1)
    80005886:	0204d703          	lhu	a4,32(s1)
    8000588a:	0027d783          	lhu	a5,2(a5)
    8000588e:	04f70863          	beq	a4,a5,800058de <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005892:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005896:	6898                	ld	a4,16(s1)
    80005898:	0204d783          	lhu	a5,32(s1)
    8000589c:	8b9d                	andi	a5,a5,7
    8000589e:	078e                	slli	a5,a5,0x3
    800058a0:	97ba                	add	a5,a5,a4
    800058a2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058a4:	00278713          	addi	a4,a5,2
    800058a8:	0712                	slli	a4,a4,0x4
    800058aa:	9726                	add	a4,a4,s1
    800058ac:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058b0:	e721                	bnez	a4,800058f8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058b2:	0789                	addi	a5,a5,2
    800058b4:	0792                	slli	a5,a5,0x4
    800058b6:	97a6                	add	a5,a5,s1
    800058b8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058ba:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058be:	ffffc097          	auipc	ra,0xffffc
    800058c2:	d14080e7          	jalr	-748(ra) # 800015d2 <wakeup>

    disk.used_idx += 1;
    800058c6:	0204d783          	lhu	a5,32(s1)
    800058ca:	2785                	addiw	a5,a5,1
    800058cc:	17c2                	slli	a5,a5,0x30
    800058ce:	93c1                	srli	a5,a5,0x30
    800058d0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058d4:	6898                	ld	a4,16(s1)
    800058d6:	00275703          	lhu	a4,2(a4)
    800058da:	faf71ce3          	bne	a4,a5,80005892 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058de:	00014517          	auipc	a0,0x14
    800058e2:	59a50513          	addi	a0,a0,1434 # 80019e78 <disk+0x128>
    800058e6:	00001097          	auipc	ra,0x1
    800058ea:	b92080e7          	jalr	-1134(ra) # 80006478 <release>
}
    800058ee:	60e2                	ld	ra,24(sp)
    800058f0:	6442                	ld	s0,16(sp)
    800058f2:	64a2                	ld	s1,8(sp)
    800058f4:	6105                	addi	sp,sp,32
    800058f6:	8082                	ret
      panic("virtio_disk_intr status");
    800058f8:	00003517          	auipc	a0,0x3
    800058fc:	03050513          	addi	a0,a0,48 # 80008928 <syscall_name_list+0x4c0>
    80005900:	00000097          	auipc	ra,0x0
    80005904:	558080e7          	jalr	1368(ra) # 80005e58 <panic>

0000000080005908 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005908:	1141                	addi	sp,sp,-16
    8000590a:	e422                	sd	s0,8(sp)
    8000590c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000590e:	f1402773          	csrr	a4,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005912:	2701                	sext.w	a4,a4

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005914:	0037161b          	slliw	a2,a4,0x3
    80005918:	020047b7          	lui	a5,0x2004
    8000591c:	963e                	add	a2,a2,a5
    8000591e:	0200c7b7          	lui	a5,0x200c
    80005922:	ff87b783          	ld	a5,-8(a5) # 200bff8 <_entry-0x7dff4008>
    80005926:	000f46b7          	lui	a3,0xf4
    8000592a:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000592e:	97b6                	add	a5,a5,a3
    80005930:	e21c                	sd	a5,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005932:	00271793          	slli	a5,a4,0x2
    80005936:	97ba                	add	a5,a5,a4
    80005938:	00379713          	slli	a4,a5,0x3
    8000593c:	00014797          	auipc	a5,0x14
    80005940:	55478793          	addi	a5,a5,1364 # 80019e90 <timer_scratch>
    80005944:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005946:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005948:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000594a:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000594e:	00000797          	auipc	a5,0x0
    80005952:	93278793          	addi	a5,a5,-1742 # 80005280 <timervec>
    80005956:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000595a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000595e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005962:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005966:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000596a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000596e:	30479073          	csrw	mie,a5
}
    80005972:	6422                	ld	s0,8(sp)
    80005974:	0141                	addi	sp,sp,16
    80005976:	8082                	ret

0000000080005978 <start>:
{
    80005978:	1141                	addi	sp,sp,-16
    8000597a:	e406                	sd	ra,8(sp)
    8000597c:	e022                	sd	s0,0(sp)
    8000597e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005980:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005984:	7779                	lui	a4,0xffffe
    80005986:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc72f>
    8000598a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000598c:	6705                	lui	a4,0x1
    8000598e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005992:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005994:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005998:	ffffb797          	auipc	a5,0xffffb
    8000599c:	9dc78793          	addi	a5,a5,-1572 # 80000374 <main>
    800059a0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059a4:	4781                	li	a5,0
    800059a6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059aa:	67c1                	lui	a5,0x10
    800059ac:	17fd                	addi	a5,a5,-1
    800059ae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059b2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059b6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059ba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059be:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059c2:	57fd                	li	a5,-1
    800059c4:	83a9                	srli	a5,a5,0xa
    800059c6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ca:	47bd                	li	a5,15
    800059cc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	f38080e7          	jalr	-200(ra) # 80005908 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059dc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059de:	823e                	mv	tp,a5
  asm volatile("mret");
    800059e0:	30200073          	mret
}
    800059e4:	60a2                	ld	ra,8(sp)
    800059e6:	6402                	ld	s0,0(sp)
    800059e8:	0141                	addi	sp,sp,16
    800059ea:	8082                	ret

00000000800059ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059ec:	715d                	addi	sp,sp,-80
    800059ee:	e486                	sd	ra,72(sp)
    800059f0:	e0a2                	sd	s0,64(sp)
    800059f2:	fc26                	sd	s1,56(sp)
    800059f4:	f84a                	sd	s2,48(sp)
    800059f6:	f44e                	sd	s3,40(sp)
    800059f8:	f052                	sd	s4,32(sp)
    800059fa:	ec56                	sd	s5,24(sp)
    800059fc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059fe:	04c05663          	blez	a2,80005a4a <consolewrite+0x5e>
    80005a02:	8a2a                	mv	s4,a0
    80005a04:	892e                	mv	s2,a1
    80005a06:	89b2                	mv	s3,a2
    80005a08:	4481                	li	s1,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a0a:	5afd                	li	s5,-1
    80005a0c:	4685                	li	a3,1
    80005a0e:	864a                	mv	a2,s2
    80005a10:	85d2                	mv	a1,s4
    80005a12:	fbf40513          	addi	a0,s0,-65
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	fb8080e7          	jalr	-72(ra) # 800019ce <either_copyin>
    80005a1e:	01550c63          	beq	a0,s5,80005a36 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a22:	fbf44503          	lbu	a0,-65(s0)
    80005a26:	00000097          	auipc	ra,0x0
    80005a2a:	7d8080e7          	jalr	2008(ra) # 800061fe <uartputc>
  for(i = 0; i < n; i++){
    80005a2e:	2485                	addiw	s1,s1,1
    80005a30:	0905                	addi	s2,s2,1
    80005a32:	fc999de3          	bne	s3,s1,80005a0c <consolewrite+0x20>
  }

  return i;
}
    80005a36:	8526                	mv	a0,s1
    80005a38:	60a6                	ld	ra,72(sp)
    80005a3a:	6406                	ld	s0,64(sp)
    80005a3c:	74e2                	ld	s1,56(sp)
    80005a3e:	7942                	ld	s2,48(sp)
    80005a40:	79a2                	ld	s3,40(sp)
    80005a42:	7a02                	ld	s4,32(sp)
    80005a44:	6ae2                	ld	s5,24(sp)
    80005a46:	6161                	addi	sp,sp,80
    80005a48:	8082                	ret
  for(i = 0; i < n; i++){
    80005a4a:	4481                	li	s1,0
    80005a4c:	b7ed                	j	80005a36 <consolewrite+0x4a>

0000000080005a4e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a4e:	7119                	addi	sp,sp,-128
    80005a50:	fc86                	sd	ra,120(sp)
    80005a52:	f8a2                	sd	s0,112(sp)
    80005a54:	f4a6                	sd	s1,104(sp)
    80005a56:	f0ca                	sd	s2,96(sp)
    80005a58:	ecce                	sd	s3,88(sp)
    80005a5a:	e8d2                	sd	s4,80(sp)
    80005a5c:	e4d6                	sd	s5,72(sp)
    80005a5e:	e0da                	sd	s6,64(sp)
    80005a60:	fc5e                	sd	s7,56(sp)
    80005a62:	f862                	sd	s8,48(sp)
    80005a64:	f466                	sd	s9,40(sp)
    80005a66:	f06a                	sd	s10,32(sp)
    80005a68:	ec6e                	sd	s11,24(sp)
    80005a6a:	0100                	addi	s0,sp,128
    80005a6c:	8caa                	mv	s9,a0
    80005a6e:	8aae                	mv	s5,a1
    80005a70:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a72:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a76:	0001c517          	auipc	a0,0x1c
    80005a7a:	55a50513          	addi	a0,a0,1370 # 80021fd0 <cons>
    80005a7e:	00001097          	auipc	ra,0x1
    80005a82:	946080e7          	jalr	-1722(ra) # 800063c4 <acquire>
  while(n > 0){
    80005a86:	09405963          	blez	s4,80005b18 <consoleread+0xca>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a8a:	0001c497          	auipc	s1,0x1c
    80005a8e:	54648493          	addi	s1,s1,1350 # 80021fd0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a92:	89a6                	mv	s3,s1
    80005a94:	0001c917          	auipc	s2,0x1c
    80005a98:	5d490913          	addi	s2,s2,1492 # 80022068 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a9c:	4c11                	li	s8,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a9e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005aa0:	4da9                	li	s11,10
    while(cons.r == cons.w){
    80005aa2:	0984a783          	lw	a5,152(s1)
    80005aa6:	09c4a703          	lw	a4,156(s1)
    80005aaa:	02f71763          	bne	a4,a5,80005ad8 <consoleread+0x8a>
      if(killed(myproc())){
    80005aae:	ffffb097          	auipc	ra,0xffffb
    80005ab2:	410080e7          	jalr	1040(ra) # 80000ebe <myproc>
    80005ab6:	ffffc097          	auipc	ra,0xffffc
    80005aba:	d62080e7          	jalr	-670(ra) # 80001818 <killed>
    80005abe:	e925                	bnez	a0,80005b2e <consoleread+0xe0>
      sleep(&cons.r, &cons.lock);
    80005ac0:	85ce                	mv	a1,s3
    80005ac2:	854a                	mv	a0,s2
    80005ac4:	ffffc097          	auipc	ra,0xffffc
    80005ac8:	aaa080e7          	jalr	-1366(ra) # 8000156e <sleep>
    while(cons.r == cons.w){
    80005acc:	0984a783          	lw	a5,152(s1)
    80005ad0:	09c4a703          	lw	a4,156(s1)
    80005ad4:	fcf70de3          	beq	a4,a5,80005aae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005ad8:	0017871b          	addiw	a4,a5,1
    80005adc:	08e4ac23          	sw	a4,152(s1)
    80005ae0:	07f7f713          	andi	a4,a5,127
    80005ae4:	9726                	add	a4,a4,s1
    80005ae6:	01874703          	lbu	a4,24(a4)
    80005aea:	00070b9b          	sext.w	s7,a4
    if(c == C('D')){  // end-of-file
    80005aee:	078b8863          	beq	s7,s8,80005b5e <consoleread+0x110>
    cbuf = c;
    80005af2:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005af6:	4685                	li	a3,1
    80005af8:	f8f40613          	addi	a2,s0,-113
    80005afc:	85d6                	mv	a1,s5
    80005afe:	8566                	mv	a0,s9
    80005b00:	ffffc097          	auipc	ra,0xffffc
    80005b04:	e78080e7          	jalr	-392(ra) # 80001978 <either_copyout>
    80005b08:	01a50863          	beq	a0,s10,80005b18 <consoleread+0xca>
    dst++;
    80005b0c:	0a85                	addi	s5,s5,1
    --n;
    80005b0e:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b10:	01bb8463          	beq	s7,s11,80005b18 <consoleread+0xca>
  while(n > 0){
    80005b14:	f80a17e3          	bnez	s4,80005aa2 <consoleread+0x54>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b18:	0001c517          	auipc	a0,0x1c
    80005b1c:	4b850513          	addi	a0,a0,1208 # 80021fd0 <cons>
    80005b20:	00001097          	auipc	ra,0x1
    80005b24:	958080e7          	jalr	-1704(ra) # 80006478 <release>

  return target - n;
    80005b28:	414b053b          	subw	a0,s6,s4
    80005b2c:	a811                	j	80005b40 <consoleread+0xf2>
        release(&cons.lock);
    80005b2e:	0001c517          	auipc	a0,0x1c
    80005b32:	4a250513          	addi	a0,a0,1186 # 80021fd0 <cons>
    80005b36:	00001097          	auipc	ra,0x1
    80005b3a:	942080e7          	jalr	-1726(ra) # 80006478 <release>
        return -1;
    80005b3e:	557d                	li	a0,-1
}
    80005b40:	70e6                	ld	ra,120(sp)
    80005b42:	7446                	ld	s0,112(sp)
    80005b44:	74a6                	ld	s1,104(sp)
    80005b46:	7906                	ld	s2,96(sp)
    80005b48:	69e6                	ld	s3,88(sp)
    80005b4a:	6a46                	ld	s4,80(sp)
    80005b4c:	6aa6                	ld	s5,72(sp)
    80005b4e:	6b06                	ld	s6,64(sp)
    80005b50:	7be2                	ld	s7,56(sp)
    80005b52:	7c42                	ld	s8,48(sp)
    80005b54:	7ca2                	ld	s9,40(sp)
    80005b56:	7d02                	ld	s10,32(sp)
    80005b58:	6de2                	ld	s11,24(sp)
    80005b5a:	6109                	addi	sp,sp,128
    80005b5c:	8082                	ret
      if(n < target){
    80005b5e:	000a071b          	sext.w	a4,s4
    80005b62:	fb677be3          	bleu	s6,a4,80005b18 <consoleread+0xca>
        cons.r--;
    80005b66:	0001c717          	auipc	a4,0x1c
    80005b6a:	50f72123          	sw	a5,1282(a4) # 80022068 <cons+0x98>
    80005b6e:	b76d                	j	80005b18 <consoleread+0xca>

0000000080005b70 <consputc>:
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b78:	10000793          	li	a5,256
    80005b7c:	00f50a63          	beq	a0,a5,80005b90 <consputc+0x20>
    uartputc_sync(c);
    80005b80:	00000097          	auipc	ra,0x0
    80005b84:	58a080e7          	jalr	1418(ra) # 8000610a <uartputc_sync>
}
    80005b88:	60a2                	ld	ra,8(sp)
    80005b8a:	6402                	ld	s0,0(sp)
    80005b8c:	0141                	addi	sp,sp,16
    80005b8e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b90:	4521                	li	a0,8
    80005b92:	00000097          	auipc	ra,0x0
    80005b96:	578080e7          	jalr	1400(ra) # 8000610a <uartputc_sync>
    80005b9a:	02000513          	li	a0,32
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	56c080e7          	jalr	1388(ra) # 8000610a <uartputc_sync>
    80005ba6:	4521                	li	a0,8
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	562080e7          	jalr	1378(ra) # 8000610a <uartputc_sync>
    80005bb0:	bfe1                	j	80005b88 <consputc+0x18>

0000000080005bb2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bb2:	1101                	addi	sp,sp,-32
    80005bb4:	ec06                	sd	ra,24(sp)
    80005bb6:	e822                	sd	s0,16(sp)
    80005bb8:	e426                	sd	s1,8(sp)
    80005bba:	e04a                	sd	s2,0(sp)
    80005bbc:	1000                	addi	s0,sp,32
    80005bbe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bc0:	0001c517          	auipc	a0,0x1c
    80005bc4:	41050513          	addi	a0,a0,1040 # 80021fd0 <cons>
    80005bc8:	00000097          	auipc	ra,0x0
    80005bcc:	7fc080e7          	jalr	2044(ra) # 800063c4 <acquire>

  switch(c){
    80005bd0:	47c1                	li	a5,16
    80005bd2:	12f48463          	beq	s1,a5,80005cfa <consoleintr+0x148>
    80005bd6:	0297df63          	ble	s1,a5,80005c14 <consoleintr+0x62>
    80005bda:	47d5                	li	a5,21
    80005bdc:	0af48863          	beq	s1,a5,80005c8c <consoleintr+0xda>
    80005be0:	07f00793          	li	a5,127
    80005be4:	02f49b63          	bne	s1,a5,80005c1a <consoleintr+0x68>
      consputc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
    80005be8:	0001c717          	auipc	a4,0x1c
    80005bec:	3e870713          	addi	a4,a4,1000 # 80021fd0 <cons>
    80005bf0:	0a072783          	lw	a5,160(a4)
    80005bf4:	09c72703          	lw	a4,156(a4)
    80005bf8:	10f70563          	beq	a4,a5,80005d02 <consoleintr+0x150>
      cons.e--;
    80005bfc:	37fd                	addiw	a5,a5,-1
    80005bfe:	0001c717          	auipc	a4,0x1c
    80005c02:	46f72923          	sw	a5,1138(a4) # 80022070 <cons+0xa0>
      consputc(BACKSPACE);
    80005c06:	10000513          	li	a0,256
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	f66080e7          	jalr	-154(ra) # 80005b70 <consputc>
    80005c12:	a8c5                	j	80005d02 <consoleintr+0x150>
  switch(c){
    80005c14:	47a1                	li	a5,8
    80005c16:	fcf489e3          	beq	s1,a5,80005be8 <consoleintr+0x36>
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c1a:	c4e5                	beqz	s1,80005d02 <consoleintr+0x150>
    80005c1c:	0001c717          	auipc	a4,0x1c
    80005c20:	3b470713          	addi	a4,a4,948 # 80021fd0 <cons>
    80005c24:	0a072783          	lw	a5,160(a4)
    80005c28:	09872703          	lw	a4,152(a4)
    80005c2c:	9f99                	subw	a5,a5,a4
    80005c2e:	07f00713          	li	a4,127
    80005c32:	0cf76863          	bltu	a4,a5,80005d02 <consoleintr+0x150>
      c = (c == '\r') ? '\n' : c;
    80005c36:	47b5                	li	a5,13
    80005c38:	0ef48363          	beq	s1,a5,80005d1e <consoleintr+0x16c>

      // echo back to the user.
      consputc(c);
    80005c3c:	8526                	mv	a0,s1
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	f32080e7          	jalr	-206(ra) # 80005b70 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c46:	0001c797          	auipc	a5,0x1c
    80005c4a:	38a78793          	addi	a5,a5,906 # 80021fd0 <cons>
    80005c4e:	0a07a683          	lw	a3,160(a5)
    80005c52:	0016871b          	addiw	a4,a3,1
    80005c56:	0007061b          	sext.w	a2,a4
    80005c5a:	0ae7a023          	sw	a4,160(a5)
    80005c5e:	07f6f693          	andi	a3,a3,127
    80005c62:	97b6                	add	a5,a5,a3
    80005c64:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c68:	47a9                	li	a5,10
    80005c6a:	0ef48163          	beq	s1,a5,80005d4c <consoleintr+0x19a>
    80005c6e:	4791                	li	a5,4
    80005c70:	0cf48e63          	beq	s1,a5,80005d4c <consoleintr+0x19a>
    80005c74:	0001c797          	auipc	a5,0x1c
    80005c78:	35c78793          	addi	a5,a5,860 # 80021fd0 <cons>
    80005c7c:	0987a783          	lw	a5,152(a5)
    80005c80:	9f1d                	subw	a4,a4,a5
    80005c82:	08000793          	li	a5,128
    80005c86:	06f71e63          	bne	a4,a5,80005d02 <consoleintr+0x150>
    80005c8a:	a0c9                	j	80005d4c <consoleintr+0x19a>
    while(cons.e != cons.w &&
    80005c8c:	0001c717          	auipc	a4,0x1c
    80005c90:	34470713          	addi	a4,a4,836 # 80021fd0 <cons>
    80005c94:	0a072783          	lw	a5,160(a4)
    80005c98:	09c72703          	lw	a4,156(a4)
    80005c9c:	06f70363          	beq	a4,a5,80005d02 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ca0:	37fd                	addiw	a5,a5,-1
    80005ca2:	0007871b          	sext.w	a4,a5
    80005ca6:	07f7f793          	andi	a5,a5,127
    80005caa:	0001c697          	auipc	a3,0x1c
    80005cae:	32668693          	addi	a3,a3,806 # 80021fd0 <cons>
    80005cb2:	97b6                	add	a5,a5,a3
    while(cons.e != cons.w &&
    80005cb4:	0187c683          	lbu	a3,24(a5)
    80005cb8:	47a9                	li	a5,10
      cons.e--;
    80005cba:	0001c497          	auipc	s1,0x1c
    80005cbe:	31648493          	addi	s1,s1,790 # 80021fd0 <cons>
    while(cons.e != cons.w &&
    80005cc2:	4929                	li	s2,10
    80005cc4:	02f68f63          	beq	a3,a5,80005d02 <consoleintr+0x150>
      cons.e--;
    80005cc8:	0ae4a023          	sw	a4,160(s1)
      consputc(BACKSPACE);
    80005ccc:	10000513          	li	a0,256
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	ea0080e7          	jalr	-352(ra) # 80005b70 <consputc>
    while(cons.e != cons.w &&
    80005cd8:	0a04a783          	lw	a5,160(s1)
    80005cdc:	09c4a703          	lw	a4,156(s1)
    80005ce0:	02f70163          	beq	a4,a5,80005d02 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ce4:	37fd                	addiw	a5,a5,-1
    80005ce6:	0007871b          	sext.w	a4,a5
    80005cea:	07f7f793          	andi	a5,a5,127
    80005cee:	97a6                	add	a5,a5,s1
    while(cons.e != cons.w &&
    80005cf0:	0187c783          	lbu	a5,24(a5)
    80005cf4:	fd279ae3          	bne	a5,s2,80005cc8 <consoleintr+0x116>
    80005cf8:	a029                	j	80005d02 <consoleintr+0x150>
    procdump();
    80005cfa:	ffffc097          	auipc	ra,0xffffc
    80005cfe:	d2a080e7          	jalr	-726(ra) # 80001a24 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d02:	0001c517          	auipc	a0,0x1c
    80005d06:	2ce50513          	addi	a0,a0,718 # 80021fd0 <cons>
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	76e080e7          	jalr	1902(ra) # 80006478 <release>
}
    80005d12:	60e2                	ld	ra,24(sp)
    80005d14:	6442                	ld	s0,16(sp)
    80005d16:	64a2                	ld	s1,8(sp)
    80005d18:	6902                	ld	s2,0(sp)
    80005d1a:	6105                	addi	sp,sp,32
    80005d1c:	8082                	ret
      consputc(c);
    80005d1e:	4529                	li	a0,10
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	e50080e7          	jalr	-432(ra) # 80005b70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d28:	0001c797          	auipc	a5,0x1c
    80005d2c:	2a878793          	addi	a5,a5,680 # 80021fd0 <cons>
    80005d30:	0a07a703          	lw	a4,160(a5)
    80005d34:	0017069b          	addiw	a3,a4,1
    80005d38:	0006861b          	sext.w	a2,a3
    80005d3c:	0ad7a023          	sw	a3,160(a5)
    80005d40:	07f77713          	andi	a4,a4,127
    80005d44:	97ba                	add	a5,a5,a4
    80005d46:	4729                	li	a4,10
    80005d48:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d4c:	0001c797          	auipc	a5,0x1c
    80005d50:	32c7a023          	sw	a2,800(a5) # 8002206c <cons+0x9c>
        wakeup(&cons.r);
    80005d54:	0001c517          	auipc	a0,0x1c
    80005d58:	31450513          	addi	a0,a0,788 # 80022068 <cons+0x98>
    80005d5c:	ffffc097          	auipc	ra,0xffffc
    80005d60:	876080e7          	jalr	-1930(ra) # 800015d2 <wakeup>
    80005d64:	bf79                	j	80005d02 <consoleintr+0x150>

0000000080005d66 <consoleinit>:

void
consoleinit(void)
{
    80005d66:	1141                	addi	sp,sp,-16
    80005d68:	e406                	sd	ra,8(sp)
    80005d6a:	e022                	sd	s0,0(sp)
    80005d6c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d6e:	00003597          	auipc	a1,0x3
    80005d72:	bd258593          	addi	a1,a1,-1070 # 80008940 <syscall_name_list+0x4d8>
    80005d76:	0001c517          	auipc	a0,0x1c
    80005d7a:	25a50513          	addi	a0,a0,602 # 80021fd0 <cons>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	5b6080e7          	jalr	1462(ra) # 80006334 <initlock>

  uartinit();
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	334080e7          	jalr	820(ra) # 800060ba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d8e:	00013797          	auipc	a5,0x13
    80005d92:	f6a78793          	addi	a5,a5,-150 # 80018cf8 <devsw>
    80005d96:	00000717          	auipc	a4,0x0
    80005d9a:	cb870713          	addi	a4,a4,-840 # 80005a4e <consoleread>
    80005d9e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005da0:	00000717          	auipc	a4,0x0
    80005da4:	c4c70713          	addi	a4,a4,-948 # 800059ec <consolewrite>
    80005da8:	ef98                	sd	a4,24(a5)
}
    80005daa:	60a2                	ld	ra,8(sp)
    80005dac:	6402                	ld	s0,0(sp)
    80005dae:	0141                	addi	sp,sp,16
    80005db0:	8082                	ret

0000000080005db2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005db2:	7179                	addi	sp,sp,-48
    80005db4:	f406                	sd	ra,40(sp)
    80005db6:	f022                	sd	s0,32(sp)
    80005db8:	ec26                	sd	s1,24(sp)
    80005dba:	e84a                	sd	s2,16(sp)
    80005dbc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dbe:	c219                	beqz	a2,80005dc4 <printint+0x12>
    80005dc0:	00054d63          	bltz	a0,80005dda <printint+0x28>
    x = -xx;
  else
    x = xx;
    80005dc4:	2501                	sext.w	a0,a0
    80005dc6:	4881                	li	a7,0
    80005dc8:	fd040713          	addi	a4,s0,-48

  i = 0;
    80005dcc:	4601                	li	a2,0
  do {
    buf[i++] = digits[x % base];
    80005dce:	2581                	sext.w	a1,a1
    80005dd0:	00003817          	auipc	a6,0x3
    80005dd4:	b7880813          	addi	a6,a6,-1160 # 80008948 <digits>
    80005dd8:	a801                	j	80005de8 <printint+0x36>
    x = -xx;
    80005dda:	40a0053b          	negw	a0,a0
    80005dde:	2501                	sext.w	a0,a0
  if(sign && (sign = xx < 0))
    80005de0:	4885                	li	a7,1
    x = -xx;
    80005de2:	b7dd                	j	80005dc8 <printint+0x16>
  } while((x /= base) != 0);
    80005de4:	853e                	mv	a0,a5
    buf[i++] = digits[x % base];
    80005de6:	8636                	mv	a2,a3
    80005de8:	0016069b          	addiw	a3,a2,1
    80005dec:	02b577bb          	remuw	a5,a0,a1
    80005df0:	1782                	slli	a5,a5,0x20
    80005df2:	9381                	srli	a5,a5,0x20
    80005df4:	97c2                	add	a5,a5,a6
    80005df6:	0007c783          	lbu	a5,0(a5)
    80005dfa:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005dfe:	0705                	addi	a4,a4,1
    80005e00:	02b557bb          	divuw	a5,a0,a1
    80005e04:	feb570e3          	bleu	a1,a0,80005de4 <printint+0x32>

  if(sign)
    80005e08:	00088b63          	beqz	a7,80005e1e <printint+0x6c>
    buf[i++] = '-';
    80005e0c:	fe040793          	addi	a5,s0,-32
    80005e10:	96be                	add	a3,a3,a5
    80005e12:	02d00793          	li	a5,45
    80005e16:	fef68823          	sb	a5,-16(a3)
    80005e1a:	0026069b          	addiw	a3,a2,2

  while(--i >= 0)
    80005e1e:	02d05763          	blez	a3,80005e4c <printint+0x9a>
    80005e22:	fd040793          	addi	a5,s0,-48
    80005e26:	00d784b3          	add	s1,a5,a3
    80005e2a:	fff78913          	addi	s2,a5,-1
    80005e2e:	9936                	add	s2,s2,a3
    80005e30:	36fd                	addiw	a3,a3,-1
    80005e32:	1682                	slli	a3,a3,0x20
    80005e34:	9281                	srli	a3,a3,0x20
    80005e36:	40d90933          	sub	s2,s2,a3
    consputc(buf[i]);
    80005e3a:	fff4c503          	lbu	a0,-1(s1)
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	d32080e7          	jalr	-718(ra) # 80005b70 <consputc>
  while(--i >= 0)
    80005e46:	14fd                	addi	s1,s1,-1
    80005e48:	ff2499e3          	bne	s1,s2,80005e3a <printint+0x88>
}
    80005e4c:	70a2                	ld	ra,40(sp)
    80005e4e:	7402                	ld	s0,32(sp)
    80005e50:	64e2                	ld	s1,24(sp)
    80005e52:	6942                	ld	s2,16(sp)
    80005e54:	6145                	addi	sp,sp,48
    80005e56:	8082                	ret

0000000080005e58 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e58:	1101                	addi	sp,sp,-32
    80005e5a:	ec06                	sd	ra,24(sp)
    80005e5c:	e822                	sd	s0,16(sp)
    80005e5e:	e426                	sd	s1,8(sp)
    80005e60:	1000                	addi	s0,sp,32
    80005e62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e64:	0001c797          	auipc	a5,0x1c
    80005e68:	2207a623          	sw	zero,556(a5) # 80022090 <pr+0x18>
  printf("panic: ");
    80005e6c:	00003517          	auipc	a0,0x3
    80005e70:	af450513          	addi	a0,a0,-1292 # 80008960 <digits+0x18>
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	02e080e7          	jalr	46(ra) # 80005ea2 <printf>
  printf(s);
    80005e7c:	8526                	mv	a0,s1
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	024080e7          	jalr	36(ra) # 80005ea2 <printf>
  printf("\n");
    80005e86:	00002517          	auipc	a0,0x2
    80005e8a:	1c250513          	addi	a0,a0,450 # 80008048 <etext+0x48>
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	014080e7          	jalr	20(ra) # 80005ea2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e96:	4785                	li	a5,1
    80005e98:	00003717          	auipc	a4,0x3
    80005e9c:	baf72a23          	sw	a5,-1100(a4) # 80008a4c <panicked>
  for(;;)
    80005ea0:	a001                	j	80005ea0 <panic+0x48>

0000000080005ea2 <printf>:
{
    80005ea2:	7131                	addi	sp,sp,-192
    80005ea4:	fc86                	sd	ra,120(sp)
    80005ea6:	f8a2                	sd	s0,112(sp)
    80005ea8:	f4a6                	sd	s1,104(sp)
    80005eaa:	f0ca                	sd	s2,96(sp)
    80005eac:	ecce                	sd	s3,88(sp)
    80005eae:	e8d2                	sd	s4,80(sp)
    80005eb0:	e4d6                	sd	s5,72(sp)
    80005eb2:	e0da                	sd	s6,64(sp)
    80005eb4:	fc5e                	sd	s7,56(sp)
    80005eb6:	f862                	sd	s8,48(sp)
    80005eb8:	f466                	sd	s9,40(sp)
    80005eba:	f06a                	sd	s10,32(sp)
    80005ebc:	ec6e                	sd	s11,24(sp)
    80005ebe:	0100                	addi	s0,sp,128
    80005ec0:	8aaa                	mv	s5,a0
    80005ec2:	e40c                	sd	a1,8(s0)
    80005ec4:	e810                	sd	a2,16(s0)
    80005ec6:	ec14                	sd	a3,24(s0)
    80005ec8:	f018                	sd	a4,32(s0)
    80005eca:	f41c                	sd	a5,40(s0)
    80005ecc:	03043823          	sd	a6,48(s0)
    80005ed0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ed4:	0001c797          	auipc	a5,0x1c
    80005ed8:	1a478793          	addi	a5,a5,420 # 80022078 <pr>
    80005edc:	0187ad83          	lw	s11,24(a5)
  if(locking)
    80005ee0:	020d9b63          	bnez	s11,80005f16 <printf+0x74>
  if (fmt == 0)
    80005ee4:	020a8f63          	beqz	s5,80005f22 <printf+0x80>
  va_start(ap, fmt);
    80005ee8:	00840793          	addi	a5,s0,8
    80005eec:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ef0:	000ac503          	lbu	a0,0(s5)
    80005ef4:	16050063          	beqz	a0,80006054 <printf+0x1b2>
    80005ef8:	4481                	li	s1,0
    if(c != '%'){
    80005efa:	02500a13          	li	s4,37
    switch(c){
    80005efe:	07000b13          	li	s6,112
  consputc('x');
    80005f02:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	00003b97          	auipc	s7,0x3
    80005f08:	a44b8b93          	addi	s7,s7,-1468 # 80008948 <digits>
    switch(c){
    80005f0c:	07300c93          	li	s9,115
    80005f10:	06400c13          	li	s8,100
    80005f14:	a815                	j	80005f48 <printf+0xa6>
    acquire(&pr.lock);
    80005f16:	853e                	mv	a0,a5
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	4ac080e7          	jalr	1196(ra) # 800063c4 <acquire>
    80005f20:	b7d1                	j	80005ee4 <printf+0x42>
    panic("null fmt");
    80005f22:	00003517          	auipc	a0,0x3
    80005f26:	a4e50513          	addi	a0,a0,-1458 # 80008970 <digits+0x28>
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	f2e080e7          	jalr	-210(ra) # 80005e58 <panic>
      consputc(c);
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	c3e080e7          	jalr	-962(ra) # 80005b70 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f3a:	2485                	addiw	s1,s1,1
    80005f3c:	009a87b3          	add	a5,s5,s1
    80005f40:	0007c503          	lbu	a0,0(a5)
    80005f44:	10050863          	beqz	a0,80006054 <printf+0x1b2>
    if(c != '%'){
    80005f48:	ff4515e3          	bne	a0,s4,80005f32 <printf+0x90>
    c = fmt[++i] & 0xff;
    80005f4c:	2485                	addiw	s1,s1,1
    80005f4e:	009a87b3          	add	a5,s5,s1
    80005f52:	0007c783          	lbu	a5,0(a5)
    80005f56:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f5a:	0e090d63          	beqz	s2,80006054 <printf+0x1b2>
    switch(c){
    80005f5e:	05678a63          	beq	a5,s6,80005fb2 <printf+0x110>
    80005f62:	02fb7663          	bleu	a5,s6,80005f8e <printf+0xec>
    80005f66:	09978963          	beq	a5,s9,80005ff8 <printf+0x156>
    80005f6a:	07800713          	li	a4,120
    80005f6e:	0ce79863          	bne	a5,a4,8000603e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f72:	f8843783          	ld	a5,-120(s0)
    80005f76:	00878713          	addi	a4,a5,8
    80005f7a:	f8e43423          	sd	a4,-120(s0)
    80005f7e:	4605                	li	a2,1
    80005f80:	85ea                	mv	a1,s10
    80005f82:	4388                	lw	a0,0(a5)
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	e2e080e7          	jalr	-466(ra) # 80005db2 <printint>
      break;
    80005f8c:	b77d                	j	80005f3a <printf+0x98>
    switch(c){
    80005f8e:	0b478263          	beq	a5,s4,80006032 <printf+0x190>
    80005f92:	0b879663          	bne	a5,s8,8000603e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f96:	f8843783          	ld	a5,-120(s0)
    80005f9a:	00878713          	addi	a4,a5,8
    80005f9e:	f8e43423          	sd	a4,-120(s0)
    80005fa2:	4605                	li	a2,1
    80005fa4:	45a9                	li	a1,10
    80005fa6:	4388                	lw	a0,0(a5)
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	e0a080e7          	jalr	-502(ra) # 80005db2 <printint>
      break;
    80005fb0:	b769                	j	80005f3a <printf+0x98>
      printptr(va_arg(ap, uint64));
    80005fb2:	f8843783          	ld	a5,-120(s0)
    80005fb6:	00878713          	addi	a4,a5,8
    80005fba:	f8e43423          	sd	a4,-120(s0)
    80005fbe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fc2:	03000513          	li	a0,48
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	baa080e7          	jalr	-1110(ra) # 80005b70 <consputc>
  consputc('x');
    80005fce:	07800513          	li	a0,120
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	b9e080e7          	jalr	-1122(ra) # 80005b70 <consputc>
    80005fda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fdc:	03c9d793          	srli	a5,s3,0x3c
    80005fe0:	97de                	add	a5,a5,s7
    80005fe2:	0007c503          	lbu	a0,0(a5)
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	b8a080e7          	jalr	-1142(ra) # 80005b70 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fee:	0992                	slli	s3,s3,0x4
    80005ff0:	397d                	addiw	s2,s2,-1
    80005ff2:	fe0915e3          	bnez	s2,80005fdc <printf+0x13a>
    80005ff6:	b791                	j	80005f3a <printf+0x98>
      if((s = va_arg(ap, char*)) == 0)
    80005ff8:	f8843783          	ld	a5,-120(s0)
    80005ffc:	00878713          	addi	a4,a5,8
    80006000:	f8e43423          	sd	a4,-120(s0)
    80006004:	0007b903          	ld	s2,0(a5)
    80006008:	00090e63          	beqz	s2,80006024 <printf+0x182>
      for(; *s; s++)
    8000600c:	00094503          	lbu	a0,0(s2)
    80006010:	d50d                	beqz	a0,80005f3a <printf+0x98>
        consputc(*s);
    80006012:	00000097          	auipc	ra,0x0
    80006016:	b5e080e7          	jalr	-1186(ra) # 80005b70 <consputc>
      for(; *s; s++)
    8000601a:	0905                	addi	s2,s2,1
    8000601c:	00094503          	lbu	a0,0(s2)
    80006020:	f96d                	bnez	a0,80006012 <printf+0x170>
    80006022:	bf21                	j	80005f3a <printf+0x98>
        s = "(null)";
    80006024:	00003917          	auipc	s2,0x3
    80006028:	94490913          	addi	s2,s2,-1724 # 80008968 <digits+0x20>
      for(; *s; s++)
    8000602c:	02800513          	li	a0,40
    80006030:	b7cd                	j	80006012 <printf+0x170>
      consputc('%');
    80006032:	8552                	mv	a0,s4
    80006034:	00000097          	auipc	ra,0x0
    80006038:	b3c080e7          	jalr	-1220(ra) # 80005b70 <consputc>
      break;
    8000603c:	bdfd                	j	80005f3a <printf+0x98>
      consputc('%');
    8000603e:	8552                	mv	a0,s4
    80006040:	00000097          	auipc	ra,0x0
    80006044:	b30080e7          	jalr	-1232(ra) # 80005b70 <consputc>
      consputc(c);
    80006048:	854a                	mv	a0,s2
    8000604a:	00000097          	auipc	ra,0x0
    8000604e:	b26080e7          	jalr	-1242(ra) # 80005b70 <consputc>
      break;
    80006052:	b5e5                	j	80005f3a <printf+0x98>
  if(locking)
    80006054:	020d9163          	bnez	s11,80006076 <printf+0x1d4>
}
    80006058:	70e6                	ld	ra,120(sp)
    8000605a:	7446                	ld	s0,112(sp)
    8000605c:	74a6                	ld	s1,104(sp)
    8000605e:	7906                	ld	s2,96(sp)
    80006060:	69e6                	ld	s3,88(sp)
    80006062:	6a46                	ld	s4,80(sp)
    80006064:	6aa6                	ld	s5,72(sp)
    80006066:	6b06                	ld	s6,64(sp)
    80006068:	7be2                	ld	s7,56(sp)
    8000606a:	7c42                	ld	s8,48(sp)
    8000606c:	7ca2                	ld	s9,40(sp)
    8000606e:	7d02                	ld	s10,32(sp)
    80006070:	6de2                	ld	s11,24(sp)
    80006072:	6129                	addi	sp,sp,192
    80006074:	8082                	ret
    release(&pr.lock);
    80006076:	0001c517          	auipc	a0,0x1c
    8000607a:	00250513          	addi	a0,a0,2 # 80022078 <pr>
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	3fa080e7          	jalr	1018(ra) # 80006478 <release>
}
    80006086:	bfc9                	j	80006058 <printf+0x1b6>

0000000080006088 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006088:	1101                	addi	sp,sp,-32
    8000608a:	ec06                	sd	ra,24(sp)
    8000608c:	e822                	sd	s0,16(sp)
    8000608e:	e426                	sd	s1,8(sp)
    80006090:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006092:	0001c497          	auipc	s1,0x1c
    80006096:	fe648493          	addi	s1,s1,-26 # 80022078 <pr>
    8000609a:	00003597          	auipc	a1,0x3
    8000609e:	8e658593          	addi	a1,a1,-1818 # 80008980 <digits+0x38>
    800060a2:	8526                	mv	a0,s1
    800060a4:	00000097          	auipc	ra,0x0
    800060a8:	290080e7          	jalr	656(ra) # 80006334 <initlock>
  pr.locking = 1;
    800060ac:	4785                	li	a5,1
    800060ae:	cc9c                	sw	a5,24(s1)
}
    800060b0:	60e2                	ld	ra,24(sp)
    800060b2:	6442                	ld	s0,16(sp)
    800060b4:	64a2                	ld	s1,8(sp)
    800060b6:	6105                	addi	sp,sp,32
    800060b8:	8082                	ret

00000000800060ba <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060ba:	1141                	addi	sp,sp,-16
    800060bc:	e406                	sd	ra,8(sp)
    800060be:	e022                	sd	s0,0(sp)
    800060c0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060c2:	100007b7          	lui	a5,0x10000
    800060c6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060ca:	f8000713          	li	a4,-128
    800060ce:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060d2:	470d                	li	a4,3
    800060d4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060d8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060dc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060e0:	469d                	li	a3,7
    800060e2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060e6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060ea:	00003597          	auipc	a1,0x3
    800060ee:	89e58593          	addi	a1,a1,-1890 # 80008988 <digits+0x40>
    800060f2:	0001c517          	auipc	a0,0x1c
    800060f6:	fa650513          	addi	a0,a0,-90 # 80022098 <uart_tx_lock>
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	23a080e7          	jalr	570(ra) # 80006334 <initlock>
}
    80006102:	60a2                	ld	ra,8(sp)
    80006104:	6402                	ld	s0,0(sp)
    80006106:	0141                	addi	sp,sp,16
    80006108:	8082                	ret

000000008000610a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000610a:	1101                	addi	sp,sp,-32
    8000610c:	ec06                	sd	ra,24(sp)
    8000610e:	e822                	sd	s0,16(sp)
    80006110:	e426                	sd	s1,8(sp)
    80006112:	1000                	addi	s0,sp,32
    80006114:	84aa                	mv	s1,a0
  push_off();
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	262080e7          	jalr	610(ra) # 80006378 <push_off>

  if(panicked){
    8000611e:	00003797          	auipc	a5,0x3
    80006122:	92e78793          	addi	a5,a5,-1746 # 80008a4c <panicked>
    80006126:	439c                	lw	a5,0(a5)
    80006128:	2781                	sext.w	a5,a5
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000612a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000612e:	c391                	beqz	a5,80006132 <uartputc_sync+0x28>
    for(;;)
    80006130:	a001                	j	80006130 <uartputc_sync+0x26>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006132:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006136:	0ff7f793          	andi	a5,a5,255
    8000613a:	0207f793          	andi	a5,a5,32
    8000613e:	dbf5                	beqz	a5,80006132 <uartputc_sync+0x28>
    ;
  WriteReg(THR, c);
    80006140:	0ff4f793          	andi	a5,s1,255
    80006144:	10000737          	lui	a4,0x10000
    80006148:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	2cc080e7          	jalr	716(ra) # 80006418 <pop_off>
}
    80006154:	60e2                	ld	ra,24(sp)
    80006156:	6442                	ld	s0,16(sp)
    80006158:	64a2                	ld	s1,8(sp)
    8000615a:	6105                	addi	sp,sp,32
    8000615c:	8082                	ret

000000008000615e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000615e:	00003797          	auipc	a5,0x3
    80006162:	8f278793          	addi	a5,a5,-1806 # 80008a50 <uart_tx_r>
    80006166:	639c                	ld	a5,0(a5)
    80006168:	00003717          	auipc	a4,0x3
    8000616c:	8f070713          	addi	a4,a4,-1808 # 80008a58 <uart_tx_w>
    80006170:	6318                	ld	a4,0(a4)
    80006172:	08f70563          	beq	a4,a5,800061fc <uartstart+0x9e>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006176:	10000737          	lui	a4,0x10000
    8000617a:	00574703          	lbu	a4,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000617e:	0ff77713          	andi	a4,a4,255
    80006182:	02077713          	andi	a4,a4,32
    80006186:	cb3d                	beqz	a4,800061fc <uartstart+0x9e>
{
    80006188:	7139                	addi	sp,sp,-64
    8000618a:	fc06                	sd	ra,56(sp)
    8000618c:	f822                	sd	s0,48(sp)
    8000618e:	f426                	sd	s1,40(sp)
    80006190:	f04a                	sd	s2,32(sp)
    80006192:	ec4e                	sd	s3,24(sp)
    80006194:	e852                	sd	s4,16(sp)
    80006196:	e456                	sd	s5,8(sp)
    80006198:	0080                	addi	s0,sp,64
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000619a:	0001ca17          	auipc	s4,0x1c
    8000619e:	efea0a13          	addi	s4,s4,-258 # 80022098 <uart_tx_lock>
    uart_tx_r += 1;
    800061a2:	00003497          	auipc	s1,0x3
    800061a6:	8ae48493          	addi	s1,s1,-1874 # 80008a50 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800061aa:	10000937          	lui	s2,0x10000
    if(uart_tx_w == uart_tx_r){
    800061ae:	00003997          	auipc	s3,0x3
    800061b2:	8aa98993          	addi	s3,s3,-1878 # 80008a58 <uart_tx_w>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b6:	01f7f713          	andi	a4,a5,31
    800061ba:	9752                	add	a4,a4,s4
    800061bc:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800061c0:	0785                	addi	a5,a5,1
    800061c2:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800061c4:	8526                	mv	a0,s1
    800061c6:	ffffb097          	auipc	ra,0xffffb
    800061ca:	40c080e7          	jalr	1036(ra) # 800015d2 <wakeup>
    WriteReg(THR, c);
    800061ce:	01590023          	sb	s5,0(s2) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800061d2:	609c                	ld	a5,0(s1)
    800061d4:	0009b703          	ld	a4,0(s3)
    800061d8:	00f70963          	beq	a4,a5,800061ea <uartstart+0x8c>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061dc:	00594703          	lbu	a4,5(s2)
    800061e0:	0ff77713          	andi	a4,a4,255
    800061e4:	02077713          	andi	a4,a4,32
    800061e8:	f779                	bnez	a4,800061b6 <uartstart+0x58>
  }
}
    800061ea:	70e2                	ld	ra,56(sp)
    800061ec:	7442                	ld	s0,48(sp)
    800061ee:	74a2                	ld	s1,40(sp)
    800061f0:	7902                	ld	s2,32(sp)
    800061f2:	69e2                	ld	s3,24(sp)
    800061f4:	6a42                	ld	s4,16(sp)
    800061f6:	6aa2                	ld	s5,8(sp)
    800061f8:	6121                	addi	sp,sp,64
    800061fa:	8082                	ret
    800061fc:	8082                	ret

00000000800061fe <uartputc>:
{
    800061fe:	7179                	addi	sp,sp,-48
    80006200:	f406                	sd	ra,40(sp)
    80006202:	f022                	sd	s0,32(sp)
    80006204:	ec26                	sd	s1,24(sp)
    80006206:	e84a                	sd	s2,16(sp)
    80006208:	e44e                	sd	s3,8(sp)
    8000620a:	e052                	sd	s4,0(sp)
    8000620c:	1800                	addi	s0,sp,48
    8000620e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006210:	0001c517          	auipc	a0,0x1c
    80006214:	e8850513          	addi	a0,a0,-376 # 80022098 <uart_tx_lock>
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	1ac080e7          	jalr	428(ra) # 800063c4 <acquire>
  if(panicked){
    80006220:	00003797          	auipc	a5,0x3
    80006224:	82c78793          	addi	a5,a5,-2004 # 80008a4c <panicked>
    80006228:	439c                	lw	a5,0(a5)
    8000622a:	2781                	sext.w	a5,a5
    8000622c:	e7d9                	bnez	a5,800062ba <uartputc+0xbc>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622e:	00003797          	auipc	a5,0x3
    80006232:	82a78793          	addi	a5,a5,-2006 # 80008a58 <uart_tx_w>
    80006236:	639c                	ld	a5,0(a5)
    80006238:	00003717          	auipc	a4,0x3
    8000623c:	81870713          	addi	a4,a4,-2024 # 80008a50 <uart_tx_r>
    80006240:	6318                	ld	a4,0(a4)
    80006242:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006246:	0001ca17          	auipc	s4,0x1c
    8000624a:	e52a0a13          	addi	s4,s4,-430 # 80022098 <uart_tx_lock>
    8000624e:	00003497          	auipc	s1,0x3
    80006252:	80248493          	addi	s1,s1,-2046 # 80008a50 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006256:	00003917          	auipc	s2,0x3
    8000625a:	80290913          	addi	s2,s2,-2046 # 80008a58 <uart_tx_w>
    8000625e:	00f71f63          	bne	a4,a5,8000627c <uartputc+0x7e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006262:	85d2                	mv	a1,s4
    80006264:	8526                	mv	a0,s1
    80006266:	ffffb097          	auipc	ra,0xffffb
    8000626a:	308080e7          	jalr	776(ra) # 8000156e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000626e:	00093783          	ld	a5,0(s2)
    80006272:	6098                	ld	a4,0(s1)
    80006274:	02070713          	addi	a4,a4,32
    80006278:	fef705e3          	beq	a4,a5,80006262 <uartputc+0x64>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000627c:	0001c497          	auipc	s1,0x1c
    80006280:	e1c48493          	addi	s1,s1,-484 # 80022098 <uart_tx_lock>
    80006284:	01f7f713          	andi	a4,a5,31
    80006288:	9726                	add	a4,a4,s1
    8000628a:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    8000628e:	0785                	addi	a5,a5,1
    80006290:	00002717          	auipc	a4,0x2
    80006294:	7cf73423          	sd	a5,1992(a4) # 80008a58 <uart_tx_w>
  uartstart();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	ec6080e7          	jalr	-314(ra) # 8000615e <uartstart>
  release(&uart_tx_lock);
    800062a0:	8526                	mv	a0,s1
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	1d6080e7          	jalr	470(ra) # 80006478 <release>
}
    800062aa:	70a2                	ld	ra,40(sp)
    800062ac:	7402                	ld	s0,32(sp)
    800062ae:	64e2                	ld	s1,24(sp)
    800062b0:	6942                	ld	s2,16(sp)
    800062b2:	69a2                	ld	s3,8(sp)
    800062b4:	6a02                	ld	s4,0(sp)
    800062b6:	6145                	addi	sp,sp,48
    800062b8:	8082                	ret
    for(;;)
    800062ba:	a001                	j	800062ba <uartputc+0xbc>

00000000800062bc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062bc:	1141                	addi	sp,sp,-16
    800062be:	e422                	sd	s0,8(sp)
    800062c0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062c2:	100007b7          	lui	a5,0x10000
    800062c6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062ca:	8b85                	andi	a5,a5,1
    800062cc:	cb91                	beqz	a5,800062e0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062ce:	100007b7          	lui	a5,0x10000
    800062d2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062d6:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062da:	6422                	ld	s0,8(sp)
    800062dc:	0141                	addi	sp,sp,16
    800062de:	8082                	ret
    return -1;
    800062e0:	557d                	li	a0,-1
    800062e2:	bfe5                	j	800062da <uartgetc+0x1e>

00000000800062e4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062e4:	1101                	addi	sp,sp,-32
    800062e6:	ec06                	sd	ra,24(sp)
    800062e8:	e822                	sd	s0,16(sp)
    800062ea:	e426                	sd	s1,8(sp)
    800062ec:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062ee:	54fd                	li	s1,-1
    int c = uartgetc();
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	fcc080e7          	jalr	-52(ra) # 800062bc <uartgetc>
    if(c == -1)
    800062f8:	00950763          	beq	a0,s1,80006306 <uartintr+0x22>
      break;
    consoleintr(c);
    800062fc:	00000097          	auipc	ra,0x0
    80006300:	8b6080e7          	jalr	-1866(ra) # 80005bb2 <consoleintr>
  while(1){
    80006304:	b7f5                	j	800062f0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006306:	0001c497          	auipc	s1,0x1c
    8000630a:	d9248493          	addi	s1,s1,-622 # 80022098 <uart_tx_lock>
    8000630e:	8526                	mv	a0,s1
    80006310:	00000097          	auipc	ra,0x0
    80006314:	0b4080e7          	jalr	180(ra) # 800063c4 <acquire>
  uartstart();
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	e46080e7          	jalr	-442(ra) # 8000615e <uartstart>
  release(&uart_tx_lock);
    80006320:	8526                	mv	a0,s1
    80006322:	00000097          	auipc	ra,0x0
    80006326:	156080e7          	jalr	342(ra) # 80006478 <release>
}
    8000632a:	60e2                	ld	ra,24(sp)
    8000632c:	6442                	ld	s0,16(sp)
    8000632e:	64a2                	ld	s1,8(sp)
    80006330:	6105                	addi	sp,sp,32
    80006332:	8082                	ret

0000000080006334 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006334:	1141                	addi	sp,sp,-16
    80006336:	e422                	sd	s0,8(sp)
    80006338:	0800                	addi	s0,sp,16
  lk->name = name;
    8000633a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000633c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006340:	00053823          	sd	zero,16(a0)
}
    80006344:	6422                	ld	s0,8(sp)
    80006346:	0141                	addi	sp,sp,16
    80006348:	8082                	ret

000000008000634a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000634a:	411c                	lw	a5,0(a0)
    8000634c:	e399                	bnez	a5,80006352 <holding+0x8>
    8000634e:	4501                	li	a0,0
  return r;
}
    80006350:	8082                	ret
{
    80006352:	1101                	addi	sp,sp,-32
    80006354:	ec06                	sd	ra,24(sp)
    80006356:	e822                	sd	s0,16(sp)
    80006358:	e426                	sd	s1,8(sp)
    8000635a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000635c:	6904                	ld	s1,16(a0)
    8000635e:	ffffb097          	auipc	ra,0xffffb
    80006362:	b44080e7          	jalr	-1212(ra) # 80000ea2 <mycpu>
    80006366:	40a48533          	sub	a0,s1,a0
    8000636a:	00153513          	seqz	a0,a0
}
    8000636e:	60e2                	ld	ra,24(sp)
    80006370:	6442                	ld	s0,16(sp)
    80006372:	64a2                	ld	s1,8(sp)
    80006374:	6105                	addi	sp,sp,32
    80006376:	8082                	ret

0000000080006378 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006378:	1101                	addi	sp,sp,-32
    8000637a:	ec06                	sd	ra,24(sp)
    8000637c:	e822                	sd	s0,16(sp)
    8000637e:	e426                	sd	s1,8(sp)
    80006380:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006382:	100024f3          	csrr	s1,sstatus
    80006386:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000638a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000638c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	b12080e7          	jalr	-1262(ra) # 80000ea2 <mycpu>
    80006398:	5d3c                	lw	a5,120(a0)
    8000639a:	cf89                	beqz	a5,800063b4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000639c:	ffffb097          	auipc	ra,0xffffb
    800063a0:	b06080e7          	jalr	-1274(ra) # 80000ea2 <mycpu>
    800063a4:	5d3c                	lw	a5,120(a0)
    800063a6:	2785                	addiw	a5,a5,1
    800063a8:	dd3c                	sw	a5,120(a0)
}
    800063aa:	60e2                	ld	ra,24(sp)
    800063ac:	6442                	ld	s0,16(sp)
    800063ae:	64a2                	ld	s1,8(sp)
    800063b0:	6105                	addi	sp,sp,32
    800063b2:	8082                	ret
    mycpu()->intena = old;
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	aee080e7          	jalr	-1298(ra) # 80000ea2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063bc:	8085                	srli	s1,s1,0x1
    800063be:	8885                	andi	s1,s1,1
    800063c0:	dd64                	sw	s1,124(a0)
    800063c2:	bfe9                	j	8000639c <push_off+0x24>

00000000800063c4 <acquire>:
{
    800063c4:	1101                	addi	sp,sp,-32
    800063c6:	ec06                	sd	ra,24(sp)
    800063c8:	e822                	sd	s0,16(sp)
    800063ca:	e426                	sd	s1,8(sp)
    800063cc:	1000                	addi	s0,sp,32
    800063ce:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	fa8080e7          	jalr	-88(ra) # 80006378 <push_off>
  if(holding(lk))
    800063d8:	8526                	mv	a0,s1
    800063da:	00000097          	auipc	ra,0x0
    800063de:	f70080e7          	jalr	-144(ra) # 8000634a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063e2:	4705                	li	a4,1
  if(holding(lk))
    800063e4:	e115                	bnez	a0,80006408 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063e6:	87ba                	mv	a5,a4
    800063e8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063ec:	2781                	sext.w	a5,a5
    800063ee:	ffe5                	bnez	a5,800063e6 <acquire+0x22>
  __sync_synchronize();
    800063f0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063f4:	ffffb097          	auipc	ra,0xffffb
    800063f8:	aae080e7          	jalr	-1362(ra) # 80000ea2 <mycpu>
    800063fc:	e888                	sd	a0,16(s1)
}
    800063fe:	60e2                	ld	ra,24(sp)
    80006400:	6442                	ld	s0,16(sp)
    80006402:	64a2                	ld	s1,8(sp)
    80006404:	6105                	addi	sp,sp,32
    80006406:	8082                	ret
    panic("acquire");
    80006408:	00002517          	auipc	a0,0x2
    8000640c:	58850513          	addi	a0,a0,1416 # 80008990 <digits+0x48>
    80006410:	00000097          	auipc	ra,0x0
    80006414:	a48080e7          	jalr	-1464(ra) # 80005e58 <panic>

0000000080006418 <pop_off>:

void
pop_off(void)
{
    80006418:	1141                	addi	sp,sp,-16
    8000641a:	e406                	sd	ra,8(sp)
    8000641c:	e022                	sd	s0,0(sp)
    8000641e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006420:	ffffb097          	auipc	ra,0xffffb
    80006424:	a82080e7          	jalr	-1406(ra) # 80000ea2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006428:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000642c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000642e:	e78d                	bnez	a5,80006458 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006430:	5d3c                	lw	a5,120(a0)
    80006432:	02f05b63          	blez	a5,80006468 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006436:	37fd                	addiw	a5,a5,-1
    80006438:	0007871b          	sext.w	a4,a5
    8000643c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000643e:	eb09                	bnez	a4,80006450 <pop_off+0x38>
    80006440:	5d7c                	lw	a5,124(a0)
    80006442:	c799                	beqz	a5,80006450 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006444:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006448:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000644c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006450:	60a2                	ld	ra,8(sp)
    80006452:	6402                	ld	s0,0(sp)
    80006454:	0141                	addi	sp,sp,16
    80006456:	8082                	ret
    panic("pop_off - interruptible");
    80006458:	00002517          	auipc	a0,0x2
    8000645c:	54050513          	addi	a0,a0,1344 # 80008998 <digits+0x50>
    80006460:	00000097          	auipc	ra,0x0
    80006464:	9f8080e7          	jalr	-1544(ra) # 80005e58 <panic>
    panic("pop_off");
    80006468:	00002517          	auipc	a0,0x2
    8000646c:	54850513          	addi	a0,a0,1352 # 800089b0 <digits+0x68>
    80006470:	00000097          	auipc	ra,0x0
    80006474:	9e8080e7          	jalr	-1560(ra) # 80005e58 <panic>

0000000080006478 <release>:
{
    80006478:	1101                	addi	sp,sp,-32
    8000647a:	ec06                	sd	ra,24(sp)
    8000647c:	e822                	sd	s0,16(sp)
    8000647e:	e426                	sd	s1,8(sp)
    80006480:	1000                	addi	s0,sp,32
    80006482:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006484:	00000097          	auipc	ra,0x0
    80006488:	ec6080e7          	jalr	-314(ra) # 8000634a <holding>
    8000648c:	c115                	beqz	a0,800064b0 <release+0x38>
  lk->cpu = 0;
    8000648e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006492:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006496:	0f50000f          	fence	iorw,ow
    8000649a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000649e:	00000097          	auipc	ra,0x0
    800064a2:	f7a080e7          	jalr	-134(ra) # 80006418 <pop_off>
}
    800064a6:	60e2                	ld	ra,24(sp)
    800064a8:	6442                	ld	s0,16(sp)
    800064aa:	64a2                	ld	s1,8(sp)
    800064ac:	6105                	addi	sp,sp,32
    800064ae:	8082                	ret
    panic("release");
    800064b0:	00002517          	auipc	a0,0x2
    800064b4:	50850513          	addi	a0,a0,1288 # 800089b8 <digits+0x70>
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	9a0080e7          	jalr	-1632(ra) # 80005e58 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	fff5051b          	addiw	a0,a0,-1
    8000700c:	00d51513          	slli	a0,a0,0xd
    80007010:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007014:	02253823          	sd	sp,48(a0)
    80007018:	02353c23          	sd	gp,56(a0)
    8000701c:	04453023          	sd	tp,64(a0)
    80007020:	04553423          	sd	t0,72(a0)
    80007024:	04653823          	sd	t1,80(a0)
    80007028:	04753c23          	sd	t2,88(a0)
    8000702c:	f120                	sd	s0,96(a0)
    8000702e:	f524                	sd	s1,104(a0)
    80007030:	fd2c                	sd	a1,120(a0)
    80007032:	e150                	sd	a2,128(a0)
    80007034:	e554                	sd	a3,136(a0)
    80007036:	e958                	sd	a4,144(a0)
    80007038:	ed5c                	sd	a5,152(a0)
    8000703a:	0b053023          	sd	a6,160(a0)
    8000703e:	0b153423          	sd	a7,168(a0)
    80007042:	0b253823          	sd	s2,176(a0)
    80007046:	0b353c23          	sd	s3,184(a0)
    8000704a:	0d453023          	sd	s4,192(a0)
    8000704e:	0d553423          	sd	s5,200(a0)
    80007052:	0d653823          	sd	s6,208(a0)
    80007056:	0d753c23          	sd	s7,216(a0)
    8000705a:	0f853023          	sd	s8,224(a0)
    8000705e:	0f953423          	sd	s9,232(a0)
    80007062:	0fa53823          	sd	s10,240(a0)
    80007066:	0fb53c23          	sd	s11,248(a0)
    8000706a:	11c53023          	sd	t3,256(a0)
    8000706e:	11d53423          	sd	t4,264(a0)
    80007072:	11e53823          	sd	t5,272(a0)
    80007076:	11f53c23          	sd	t6,280(a0)
    8000707a:	140022f3          	csrr	t0,sscratch
    8000707e:	06553823          	sd	t0,112(a0)
    80007082:	00853103          	ld	sp,8(a0)
    80007086:	02053203          	ld	tp,32(a0)
    8000708a:	01053283          	ld	t0,16(a0)
    8000708e:	00053303          	ld	t1,0(a0)
    80007092:	12000073          	sfence.vma
    80007096:	18031073          	csrw	satp,t1
    8000709a:	12000073          	sfence.vma
    8000709e:	8282                	jr	t0

00000000800070a0 <userret>:
    800070a0:	12000073          	sfence.vma
    800070a4:	18051073          	csrw	satp,a0
    800070a8:	12000073          	sfence.vma
    800070ac:	02000537          	lui	a0,0x2000
    800070b0:	fff5051b          	addiw	a0,a0,-1
    800070b4:	00d51513          	slli	a0,a0,0xd
    800070b8:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070bc:	03053103          	ld	sp,48(a0)
    800070c0:	03853183          	ld	gp,56(a0)
    800070c4:	04053203          	ld	tp,64(a0)
    800070c8:	04853283          	ld	t0,72(a0)
    800070cc:	05053303          	ld	t1,80(a0)
    800070d0:	05853383          	ld	t2,88(a0)
    800070d4:	7120                	ld	s0,96(a0)
    800070d6:	7524                	ld	s1,104(a0)
    800070d8:	7d2c                	ld	a1,120(a0)
    800070da:	6150                	ld	a2,128(a0)
    800070dc:	6554                	ld	a3,136(a0)
    800070de:	6958                	ld	a4,144(a0)
    800070e0:	6d5c                	ld	a5,152(a0)
    800070e2:	0a053803          	ld	a6,160(a0)
    800070e6:	0a853883          	ld	a7,168(a0)
    800070ea:	0b053903          	ld	s2,176(a0)
    800070ee:	0b853983          	ld	s3,184(a0)
    800070f2:	0c053a03          	ld	s4,192(a0)
    800070f6:	0c853a83          	ld	s5,200(a0)
    800070fa:	0d053b03          	ld	s6,208(a0)
    800070fe:	0d853b83          	ld	s7,216(a0)
    80007102:	0e053c03          	ld	s8,224(a0)
    80007106:	0e853c83          	ld	s9,232(a0)
    8000710a:	0f053d03          	ld	s10,240(a0)
    8000710e:	0f853d83          	ld	s11,248(a0)
    80007112:	10053e03          	ld	t3,256(a0)
    80007116:	10853e83          	ld	t4,264(a0)
    8000711a:	11053f03          	ld	t5,272(a0)
    8000711e:	11853f83          	ld	t6,280(a0)
    80007122:	7928                	ld	a0,112(a0)
    80007124:	10200073          	sret
	...
