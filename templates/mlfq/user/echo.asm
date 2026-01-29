
user/_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 41                	jle    62 <main+0x62>
  21:	8d 5f 04             	lea    0x4(%edi),%ebx
  24:	8d 74 87 fc          	lea    -0x4(%edi,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	39 f3                	cmp    %esi,%ebx
  2a:	74 1b                	je     47 <main+0x47>
  2c:	68 70 06 00 00       	push   $0x670
  31:	ff 33                	pushl  (%ebx)
  33:	68 72 06 00 00       	push   $0x672
  38:	6a 01                	push   $0x1
  3a:	e8 1a 03 00 00       	call   359 <printf>
  3f:	83 c3 04             	add    $0x4,%ebx
  42:	83 c4 10             	add    $0x10,%esp
  45:	eb e1                	jmp    28 <main+0x28>
  47:	68 77 06 00 00       	push   $0x677
  4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  4f:	ff 74 87 fc          	pushl  -0x4(%edi,%eax,4)
  53:	68 72 06 00 00       	push   $0x672
  58:	6a 01                	push   $0x1
  5a:	e8 fa 02 00 00       	call   359 <printf>
  5f:	83 c4 10             	add    $0x10,%esp
  exit();
  62:	e8 c0 01 00 00       	call   227 <exit>

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	89 c2                	mov    %eax,%edx
  73:	83 c1 01             	add    $0x1,%ecx
  76:	83 c2 01             	add    $0x1,%edx
  79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  80:	84 db                	test   %bl,%bl
  82:	75 ef                	jne    73 <strcpy+0xc>
    ;
  return os;
}
  84:	5b                   	pop    %ebx
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    

00000087 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  90:	0f b6 01             	movzbl (%ecx),%eax
  93:	84 c0                	test   %al,%al
  95:	74 15                	je     ac <strcmp+0x25>
  97:	3a 02                	cmp    (%edx),%al
  99:	75 11                	jne    ac <strcmp+0x25>
    p++, q++;
  9b:	83 c1 01             	add    $0x1,%ecx
  9e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a1:	0f b6 01             	movzbl (%ecx),%eax
  a4:	84 c0                	test   %al,%al
  a6:	74 04                	je     ac <strcmp+0x25>
  a8:	3a 02                	cmp    (%edx),%al
  aa:	74 ef                	je     9b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ac:	0f b6 c0             	movzbl %al,%eax
  af:	0f b6 12             	movzbl (%edx),%edx
  b2:	29 d0                	sub    %edx,%eax
}
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strlen>:

uint
strlen(const char *s)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bc:	80 39 00             	cmpb   $0x0,(%ecx)
  bf:	74 12                	je     d3 <strlen+0x1d>
  c1:	ba 00 00 00 00       	mov    $0x0,%edx
  c6:	83 c2 01             	add    $0x1,%edx
  c9:	89 d0                	mov    %edx,%eax
  cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  cf:	75 f5                	jne    c6 <strlen+0x10>
    ;
  return n;
}
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  d8:	eb f7                	jmp    d1 <strlen+0x1b>

000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	57                   	push   %edi
  de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e1:	89 d7                	mov    %edx,%edi
  e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	fc                   	cld    
  ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ec:	89 d0                	mov    %edx,%eax
  ee:	5f                   	pop    %edi
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	53                   	push   %ebx
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  fb:	0f b6 10             	movzbl (%eax),%edx
  fe:	84 d2                	test   %dl,%dl
 100:	74 1e                	je     120 <strchr+0x2f>
 102:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 104:	38 d3                	cmp    %dl,%bl
 106:	74 15                	je     11d <strchr+0x2c>
  for(; *s; s++)
 108:	83 c0 01             	add    $0x1,%eax
 10b:	0f b6 10             	movzbl (%eax),%edx
 10e:	84 d2                	test   %dl,%dl
 110:	74 06                	je     118 <strchr+0x27>
    if(*s == c)
 112:	38 ca                	cmp    %cl,%dl
 114:	75 f2                	jne    108 <strchr+0x17>
 116:	eb 05                	jmp    11d <strchr+0x2c>
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	5b                   	pop    %ebx
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
 125:	eb f6                	jmp    11d <strchr+0x2c>

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	57                   	push   %edi
 12b:	56                   	push   %esi
 12c:	53                   	push   %ebx
 12d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 135:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 138:	8d 5e 01             	lea    0x1(%esi),%ebx
 13b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 13e:	7d 2b                	jge    16b <gets+0x44>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	57                   	push   %edi
 146:	6a 00                	push   $0x0
 148:	e8 f2 00 00 00       	call   23f <read>
    if(cc < 1)
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	7e 17                	jle    16b <gets+0x44>
      break;
    buf[i++] = c;
 154:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 158:	8b 55 08             	mov    0x8(%ebp),%edx
 15b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 15f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 161:	3c 0a                	cmp    $0xa,%al
 163:	74 04                	je     169 <gets+0x42>
 165:	3c 0d                	cmp    $0xd,%al
 167:	75 cf                	jne    138 <gets+0x11>
  for(i=0; i+1 < max; ){
 169:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    

0000017a <stat>:

int
stat(const char *n, struct stat *st)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	56                   	push   %esi
 17e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	6a 00                	push   $0x0
 184:	ff 75 08             	pushl  0x8(%ebp)
 187:	e8 db 00 00 00       	call   267 <open>
  if(fd < 0)
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	85 c0                	test   %eax,%eax
 191:	78 24                	js     1b7 <stat+0x3d>
 193:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	ff 75 0c             	pushl  0xc(%ebp)
 19b:	50                   	push   %eax
 19c:	e8 de 00 00 00       	call   27f <fstat>
 1a1:	89 c6                	mov    %eax,%esi
  close(fd);
 1a3:	89 1c 24             	mov    %ebx,(%esp)
 1a6:	e8 a4 00 00 00       	call   24f <close>
  return r;
 1ab:	83 c4 10             	add    $0x10,%esp
}
 1ae:	89 f0                	mov    %esi,%eax
 1b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b3:	5b                   	pop    %ebx
 1b4:	5e                   	pop    %esi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
    return -1;
 1b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bc:	eb f0                	jmp    1ae <stat+0x34>

000001be <atoi>:

int
atoi(const char *s)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	53                   	push   %ebx
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c5:	0f b6 11             	movzbl (%ecx),%edx
 1c8:	8d 42 d0             	lea    -0x30(%edx),%eax
 1cb:	3c 09                	cmp    $0x9,%al
 1cd:	77 20                	ja     1ef <atoi+0x31>
  n = 0;
 1cf:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1d4:	83 c1 01             	add    $0x1,%ecx
 1d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1da:	0f be d2             	movsbl %dl,%edx
 1dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1e1:	0f b6 11             	movzbl (%ecx),%edx
 1e4:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1e7:	80 fb 09             	cmp    $0x9,%bl
 1ea:	76 e8                	jbe    1d4 <atoi+0x16>
  return n;
}
 1ec:	5b                   	pop    %ebx
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret    
  n = 0;
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1f4:	eb f6                	jmp    1ec <atoi+0x2e>

000001f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	56                   	push   %esi
 1fa:	53                   	push   %ebx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	8b 75 0c             	mov    0xc(%ebp),%esi
 201:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 204:	85 db                	test   %ebx,%ebx
 206:	7e 13                	jle    21b <memmove+0x25>
 208:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 20d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 211:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 214:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 217:	39 d3                	cmp    %edx,%ebx
 219:	75 f2                	jne    20d <memmove+0x17>
  return vdst;
}
 21b:	5b                   	pop    %ebx
 21c:	5e                   	pop    %esi
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    

0000021f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <exit>:
SYSCALL(exit)
 227:	b8 02 00 00 00       	mov    $0x2,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <wait>:
SYSCALL(wait)
 22f:	b8 03 00 00 00       	mov    $0x3,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <pipe>:
SYSCALL(pipe)
 237:	b8 04 00 00 00       	mov    $0x4,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <read>:
SYSCALL(read)
 23f:	b8 05 00 00 00       	mov    $0x5,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <write>:
SYSCALL(write)
 247:	b8 10 00 00 00       	mov    $0x10,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <close>:
SYSCALL(close)
 24f:	b8 15 00 00 00       	mov    $0x15,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <kill>:
SYSCALL(kill)
 257:	b8 06 00 00 00       	mov    $0x6,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <exec>:
SYSCALL(exec)
 25f:	b8 07 00 00 00       	mov    $0x7,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <open>:
SYSCALL(open)
 267:	b8 0f 00 00 00       	mov    $0xf,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <mknod>:
SYSCALL(mknod)
 26f:	b8 11 00 00 00       	mov    $0x11,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <unlink>:
SYSCALL(unlink)
 277:	b8 12 00 00 00       	mov    $0x12,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <fstat>:
SYSCALL(fstat)
 27f:	b8 08 00 00 00       	mov    $0x8,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <link>:
SYSCALL(link)
 287:	b8 13 00 00 00       	mov    $0x13,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <mkdir>:
SYSCALL(mkdir)
 28f:	b8 14 00 00 00       	mov    $0x14,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <chdir>:
SYSCALL(chdir)
 297:	b8 09 00 00 00       	mov    $0x9,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <dup>:
SYSCALL(dup)
 29f:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <getpid>:
SYSCALL(getpid)
 2a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <sbrk>:
SYSCALL(sbrk)
 2af:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <sleep>:
SYSCALL(sleep)
 2b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <uptime>:
SYSCALL(uptime)
 2bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <getlevel>:
SYSCALL(getlevel)
 2c7:	b8 16 00 00 00       	mov    $0x16,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	57                   	push   %edi
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	83 ec 3c             	sub    $0x3c,%esp
 2d8:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2de:	74 14                	je     2f4 <printint+0x25>
 2e0:	85 d2                	test   %edx,%edx
 2e2:	79 10                	jns    2f4 <printint+0x25>
    neg = 1;
    x = -xx;
 2e4:	f7 da                	neg    %edx
    neg = 1;
 2e6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ed:	bf 00 00 00 00       	mov    $0x0,%edi
 2f2:	eb 0b                	jmp    2ff <printint+0x30>
  neg = 0;
 2f4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 2fb:	eb f0                	jmp    2ed <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 2fd:	89 df                	mov    %ebx,%edi
 2ff:	8d 5f 01             	lea    0x1(%edi),%ebx
 302:	89 d0                	mov    %edx,%eax
 304:	ba 00 00 00 00       	mov    $0x0,%edx
 309:	f7 f1                	div    %ecx
 30b:	0f b6 92 80 06 00 00 	movzbl 0x680(%edx),%edx
 312:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 316:	89 c2                	mov    %eax,%edx
 318:	85 c0                	test   %eax,%eax
 31a:	75 e1                	jne    2fd <printint+0x2e>
  if(neg)
 31c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 320:	74 08                	je     32a <printint+0x5b>
    buf[i++] = '-';
 322:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 327:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 32a:	83 eb 01             	sub    $0x1,%ebx
 32d:	78 22                	js     351 <printint+0x82>
  write(fd, &c, 1);
 32f:	8d 7d d7             	lea    -0x29(%ebp),%edi
 332:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 337:	88 45 d7             	mov    %al,-0x29(%ebp)
 33a:	83 ec 04             	sub    $0x4,%esp
 33d:	6a 01                	push   $0x1
 33f:	57                   	push   %edi
 340:	56                   	push   %esi
 341:	e8 01 ff ff ff       	call   247 <write>
  while(--i >= 0)
 346:	83 eb 01             	sub    $0x1,%ebx
 349:	83 c4 10             	add    $0x10,%esp
 34c:	83 fb ff             	cmp    $0xffffffff,%ebx
 34f:	75 e1                	jne    332 <printint+0x63>
    putc(fd, buf[i]);
}
 351:	8d 65 f4             	lea    -0xc(%ebp),%esp
 354:	5b                   	pop    %ebx
 355:	5e                   	pop    %esi
 356:	5f                   	pop    %edi
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    

00000359 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	57                   	push   %edi
 35d:	56                   	push   %esi
 35e:	53                   	push   %ebx
 35f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 362:	8b 75 0c             	mov    0xc(%ebp),%esi
 365:	0f b6 1e             	movzbl (%esi),%ebx
 368:	84 db                	test   %bl,%bl
 36a:	0f 84 b1 01 00 00    	je     521 <printf+0x1c8>
 370:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 373:	8d 45 10             	lea    0x10(%ebp),%eax
 376:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 379:	bf 00 00 00 00       	mov    $0x0,%edi
 37e:	eb 2d                	jmp    3ad <printf+0x54>
 380:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 383:	83 ec 04             	sub    $0x4,%esp
 386:	6a 01                	push   $0x1
 388:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 38b:	50                   	push   %eax
 38c:	ff 75 08             	pushl  0x8(%ebp)
 38f:	e8 b3 fe ff ff       	call   247 <write>
 394:	83 c4 10             	add    $0x10,%esp
 397:	eb 05                	jmp    39e <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 399:	83 ff 25             	cmp    $0x25,%edi
 39c:	74 22                	je     3c0 <printf+0x67>
 39e:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 3a1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3a5:	84 db                	test   %bl,%bl
 3a7:	0f 84 74 01 00 00    	je     521 <printf+0x1c8>
    c = fmt[i] & 0xff;
 3ad:	0f be d3             	movsbl %bl,%edx
 3b0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3b3:	85 ff                	test   %edi,%edi
 3b5:	75 e2                	jne    399 <printf+0x40>
      if(c == '%'){
 3b7:	83 f8 25             	cmp    $0x25,%eax
 3ba:	75 c4                	jne    380 <printf+0x27>
        state = '%';
 3bc:	89 c7                	mov    %eax,%edi
 3be:	eb de                	jmp    39e <printf+0x45>
      if(c == 'd'){
 3c0:	83 f8 64             	cmp    $0x64,%eax
 3c3:	74 59                	je     41e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3c5:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3cb:	83 fa 70             	cmp    $0x70,%edx
 3ce:	74 7a                	je     44a <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3d0:	83 f8 73             	cmp    $0x73,%eax
 3d3:	0f 84 9d 00 00 00    	je     476 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3d9:	83 f8 63             	cmp    $0x63,%eax
 3dc:	0f 84 f2 00 00 00    	je     4d4 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3e2:	83 f8 25             	cmp    $0x25,%eax
 3e5:	0f 84 15 01 00 00    	je     500 <printf+0x1a7>
 3eb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3ef:	83 ec 04             	sub    $0x4,%esp
 3f2:	6a 01                	push   $0x1
 3f4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3f7:	50                   	push   %eax
 3f8:	ff 75 08             	pushl  0x8(%ebp)
 3fb:	e8 47 fe ff ff       	call   247 <write>
 400:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 403:	83 c4 0c             	add    $0xc,%esp
 406:	6a 01                	push   $0x1
 408:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 40b:	50                   	push   %eax
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 33 fe ff ff       	call   247 <write>
 414:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 417:	bf 00 00 00 00       	mov    $0x0,%edi
 41c:	eb 80                	jmp    39e <printf+0x45>
        printint(fd, *ap, 10, 1);
 41e:	83 ec 0c             	sub    $0xc,%esp
 421:	6a 01                	push   $0x1
 423:	b9 0a 00 00 00       	mov    $0xa,%ecx
 428:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 42b:	8b 17                	mov    (%edi),%edx
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	e8 9a fe ff ff       	call   2cf <printint>
        ap++;
 435:	89 f8                	mov    %edi,%eax
 437:	83 c0 04             	add    $0x4,%eax
 43a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 43d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 440:	bf 00 00 00 00       	mov    $0x0,%edi
 445:	e9 54 ff ff ff       	jmp    39e <printf+0x45>
        printint(fd, *ap, 16, 0);
 44a:	83 ec 0c             	sub    $0xc,%esp
 44d:	6a 00                	push   $0x0
 44f:	b9 10 00 00 00       	mov    $0x10,%ecx
 454:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 457:	8b 17                	mov    (%edi),%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	e8 6e fe ff ff       	call   2cf <printint>
        ap++;
 461:	89 f8                	mov    %edi,%eax
 463:	83 c0 04             	add    $0x4,%eax
 466:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 469:	83 c4 10             	add    $0x10,%esp
      state = 0;
 46c:	bf 00 00 00 00       	mov    $0x0,%edi
 471:	e9 28 ff ff ff       	jmp    39e <printf+0x45>
        s = (char*)*ap;
 476:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 479:	8b 01                	mov    (%ecx),%eax
        ap++;
 47b:	83 c1 04             	add    $0x4,%ecx
 47e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 481:	85 c0                	test   %eax,%eax
 483:	74 13                	je     498 <printf+0x13f>
        s = (char*)*ap;
 485:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 487:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 48a:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 48f:	84 c0                	test   %al,%al
 491:	75 0f                	jne    4a2 <printf+0x149>
 493:	e9 06 ff ff ff       	jmp    39e <printf+0x45>
          s = "(null)";
 498:	bb 79 06 00 00       	mov    $0x679,%ebx
        while(*s != 0){
 49d:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 4a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4a5:	89 75 d0             	mov    %esi,-0x30(%ebp)
 4a8:	8b 75 08             	mov    0x8(%ebp),%esi
 4ab:	88 45 e3             	mov    %al,-0x1d(%ebp)
 4ae:	83 ec 04             	sub    $0x4,%esp
 4b1:	6a 01                	push   $0x1
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	e8 8d fd ff ff       	call   247 <write>
          s++;
 4ba:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4bd:	0f b6 03             	movzbl (%ebx),%eax
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	84 c0                	test   %al,%al
 4c5:	75 e4                	jne    4ab <printf+0x152>
 4c7:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 4ca:	bf 00 00 00 00       	mov    $0x0,%edi
 4cf:	e9 ca fe ff ff       	jmp    39e <printf+0x45>
        putc(fd, *ap);
 4d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d7:	8b 07                	mov    (%edi),%eax
 4d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4dc:	83 ec 04             	sub    $0x4,%esp
 4df:	6a 01                	push   $0x1
 4e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4e4:	50                   	push   %eax
 4e5:	ff 75 08             	pushl  0x8(%ebp)
 4e8:	e8 5a fd ff ff       	call   247 <write>
        ap++;
 4ed:	83 c7 04             	add    $0x4,%edi
 4f0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 4f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f6:	bf 00 00 00 00       	mov    $0x0,%edi
 4fb:	e9 9e fe ff ff       	jmp    39e <printf+0x45>
 500:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 503:	83 ec 04             	sub    $0x4,%esp
 506:	6a 01                	push   $0x1
 508:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 33 fd ff ff       	call   247 <write>
 514:	83 c4 10             	add    $0x10,%esp
      state = 0;
 517:	bf 00 00 00 00       	mov    $0x0,%edi
 51c:	e9 7d fe ff ff       	jmp    39e <printf+0x45>
    }
  }
}
 521:	8d 65 f4             	lea    -0xc(%ebp),%esp
 524:	5b                   	pop    %ebx
 525:	5e                   	pop    %esi
 526:	5f                   	pop    %edi
 527:	5d                   	pop    %ebp
 528:	c3                   	ret    

00000529 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 529:	55                   	push   %ebp
 52a:	89 e5                	mov    %esp,%ebp
 52c:	57                   	push   %edi
 52d:	56                   	push   %esi
 52e:	53                   	push   %ebx
 52f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 532:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 535:	a1 f4 08 00 00       	mov    0x8f4,%eax
 53a:	eb 0c                	jmp    548 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53c:	8b 10                	mov    (%eax),%edx
 53e:	39 c2                	cmp    %eax,%edx
 540:	77 04                	ja     546 <free+0x1d>
 542:	39 ca                	cmp    %ecx,%edx
 544:	77 10                	ja     556 <free+0x2d>
{
 546:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 548:	39 c8                	cmp    %ecx,%eax
 54a:	73 f0                	jae    53c <free+0x13>
 54c:	8b 10                	mov    (%eax),%edx
 54e:	39 ca                	cmp    %ecx,%edx
 550:	77 04                	ja     556 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 552:	39 c2                	cmp    %eax,%edx
 554:	77 f0                	ja     546 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 556:	8b 73 fc             	mov    -0x4(%ebx),%esi
 559:	8b 10                	mov    (%eax),%edx
 55b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 55e:	39 fa                	cmp    %edi,%edx
 560:	74 19                	je     57b <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 562:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 565:	8b 50 04             	mov    0x4(%eax),%edx
 568:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56b:	39 f1                	cmp    %esi,%ecx
 56d:	74 1b                	je     58a <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 56f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 571:	a3 f4 08 00 00       	mov    %eax,0x8f4
}
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 57b:	03 72 04             	add    0x4(%edx),%esi
 57e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 581:	8b 10                	mov    (%eax),%edx
 583:	8b 12                	mov    (%edx),%edx
 585:	89 53 f8             	mov    %edx,-0x8(%ebx)
 588:	eb db                	jmp    565 <free+0x3c>
    p->s.size += bp->s.size;
 58a:	03 53 fc             	add    -0x4(%ebx),%edx
 58d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 590:	8b 53 f8             	mov    -0x8(%ebx),%edx
 593:	89 10                	mov    %edx,(%eax)
 595:	eb da                	jmp    571 <free+0x48>

00000597 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp
 59a:	57                   	push   %edi
 59b:	56                   	push   %esi
 59c:	53                   	push   %ebx
 59d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	8d 58 07             	lea    0x7(%eax),%ebx
 5a6:	c1 eb 03             	shr    $0x3,%ebx
 5a9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ac:	8b 15 f4 08 00 00    	mov    0x8f4,%edx
 5b2:	85 d2                	test   %edx,%edx
 5b4:	74 20                	je     5d6 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5b8:	8b 48 04             	mov    0x4(%eax),%ecx
 5bb:	39 cb                	cmp    %ecx,%ebx
 5bd:	76 3c                	jbe    5fb <malloc+0x64>
 5bf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5c5:	be 00 10 00 00       	mov    $0x1000,%esi
 5ca:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5cd:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5d4:	eb 70                	jmp    646 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 5d6:	c7 05 f4 08 00 00 f8 	movl   $0x8f8,0x8f4
 5dd:	08 00 00 
 5e0:	c7 05 f8 08 00 00 f8 	movl   $0x8f8,0x8f8
 5e7:	08 00 00 
    base.s.size = 0;
 5ea:	c7 05 fc 08 00 00 00 	movl   $0x0,0x8fc
 5f1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5f4:	ba f8 08 00 00       	mov    $0x8f8,%edx
 5f9:	eb bb                	jmp    5b6 <malloc+0x1f>
      if(p->s.size == nunits)
 5fb:	39 cb                	cmp    %ecx,%ebx
 5fd:	74 1c                	je     61b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ff:	29 d9                	sub    %ebx,%ecx
 601:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 604:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 607:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 60a:	89 15 f4 08 00 00    	mov    %edx,0x8f4
      return (void*)(p + 1);
 610:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 613:	8d 65 f4             	lea    -0xc(%ebp),%esp
 616:	5b                   	pop    %ebx
 617:	5e                   	pop    %esi
 618:	5f                   	pop    %edi
 619:	5d                   	pop    %ebp
 61a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 61b:	8b 08                	mov    (%eax),%ecx
 61d:	89 0a                	mov    %ecx,(%edx)
 61f:	eb e9                	jmp    60a <malloc+0x73>
  hp->s.size = nu;
 621:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 624:	83 ec 0c             	sub    $0xc,%esp
 627:	83 c0 08             	add    $0x8,%eax
 62a:	50                   	push   %eax
 62b:	e8 f9 fe ff ff       	call   529 <free>
  return freep;
 630:	8b 15 f4 08 00 00    	mov    0x8f4,%edx
      if((p = morecore(nunits)) == 0)
 636:	83 c4 10             	add    $0x10,%esp
 639:	85 d2                	test   %edx,%edx
 63b:	74 2b                	je     668 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63f:	8b 48 04             	mov    0x4(%eax),%ecx
 642:	39 d9                	cmp    %ebx,%ecx
 644:	73 b5                	jae    5fb <malloc+0x64>
 646:	89 c2                	mov    %eax,%edx
    if(p == freep)
 648:	39 05 f4 08 00 00    	cmp    %eax,0x8f4
 64e:	75 ed                	jne    63d <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 650:	83 ec 0c             	sub    $0xc,%esp
 653:	57                   	push   %edi
 654:	e8 56 fc ff ff       	call   2af <sbrk>
  if(p == (char*)-1)
 659:	83 c4 10             	add    $0x10,%esp
 65c:	83 f8 ff             	cmp    $0xffffffff,%eax
 65f:	75 c0                	jne    621 <malloc+0x8a>
        return 0;
 661:	b8 00 00 00 00       	mov    $0x0,%eax
 666:	eb ab                	jmp    613 <malloc+0x7c>
 668:	b8 00 00 00 00       	mov    $0x0,%eax
 66d:	eb a4                	jmp    613 <malloc+0x7c>
