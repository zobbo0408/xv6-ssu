
user/_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 20 0a 00 00       	push   $0xa20
  15:	56                   	push   %esi
  16:	e8 b8 02 00 00       	call   2d3 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 20 0a 00 00       	push   $0xa20
  2d:	6a 01                	push   $0x1
  2f:	e8 a7 02 00 00       	call   2db <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 04 07 00 00       	push   $0x704
  43:	6a 01                	push   $0x1
  45:	e8 a3 03 00 00       	call   3ed <printf>
      exit();
  4a:	e8 6c 02 00 00       	call   2bb <exit>
    }
  }
  if(n < 0){
  4f:	85 c0                	test   %eax,%eax
  51:	78 07                	js     5a <cat+0x5a>
    printf(1, "cat: read error\n");
    exit();
  }
}
  53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  56:	5b                   	pop    %ebx
  57:	5e                   	pop    %esi
  58:	5d                   	pop    %ebp
  59:	c3                   	ret    
    printf(1, "cat: read error\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 16 07 00 00       	push   $0x716
  62:	6a 01                	push   $0x1
  64:	e8 84 03 00 00       	call   3ed <printf>
    exit();
  69:	e8 4d 02 00 00       	call   2bb <exit>

0000006e <main>:

int
main(int argc, char *argv[])
{
  6e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  72:	83 e4 f0             	and    $0xfffffff0,%esp
  75:	ff 71 fc             	pushl  -0x4(%ecx)
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	56                   	push   %esi
  7d:	53                   	push   %ebx
  7e:	51                   	push   %ecx
  7f:	83 ec 18             	sub    $0x18,%esp
  82:	8b 01                	mov    (%ecx),%eax
  84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  87:	8b 59 04             	mov    0x4(%ecx),%ebx
  8a:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  8d:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  92:	83 f8 01             	cmp    $0x1,%eax
  95:	7e 3c                	jle    d3 <main+0x65>
    if((fd = open(argv[i], 0)) < 0){
  97:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	6a 00                	push   $0x0
  9f:	ff 33                	pushl  (%ebx)
  a1:	e8 55 02 00 00       	call   2fb <open>
  a6:	89 c6                	mov    %eax,%esi
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	85 c0                	test   %eax,%eax
  ad:	78 33                	js     e2 <main+0x74>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	50                   	push   %eax
  b3:	e8 48 ff ff ff       	call   0 <cat>
    close(fd);
  b8:	89 34 24             	mov    %esi,(%esp)
  bb:	e8 23 02 00 00       	call   2e3 <close>
  for(i = 1; i < argc; i++){
  c0:	83 c7 01             	add    $0x1,%edi
  c3:	83 c3 04             	add    $0x4,%ebx
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  cc:	75 c9                	jne    97 <main+0x29>
  }
  exit();
  ce:	e8 e8 01 00 00       	call   2bb <exit>
    cat(0);
  d3:	83 ec 0c             	sub    $0xc,%esp
  d6:	6a 00                	push   $0x0
  d8:	e8 23 ff ff ff       	call   0 <cat>
    exit();
  dd:	e8 d9 01 00 00       	call   2bb <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e2:	83 ec 04             	sub    $0x4,%esp
  e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e8:	ff 30                	pushl  (%eax)
  ea:	68 27 07 00 00       	push   $0x727
  ef:	6a 01                	push   $0x1
  f1:	e8 f7 02 00 00       	call   3ed <printf>
      exit();
  f6:	e8 c0 01 00 00       	call   2bb <exit>

000000fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	53                   	push   %ebx
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 105:	89 c2                	mov    %eax,%edx
 107:	83 c1 01             	add    $0x1,%ecx
 10a:	83 c2 01             	add    $0x1,%edx
 10d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 111:	88 5a ff             	mov    %bl,-0x1(%edx)
 114:	84 db                	test   %bl,%bl
 116:	75 ef                	jne    107 <strcpy+0xc>
    ;
  return os;
}
 118:	5b                   	pop    %ebx
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 121:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 124:	0f b6 01             	movzbl (%ecx),%eax
 127:	84 c0                	test   %al,%al
 129:	74 15                	je     140 <strcmp+0x25>
 12b:	3a 02                	cmp    (%edx),%al
 12d:	75 11                	jne    140 <strcmp+0x25>
    p++, q++;
 12f:	83 c1 01             	add    $0x1,%ecx
 132:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 135:	0f b6 01             	movzbl (%ecx),%eax
 138:	84 c0                	test   %al,%al
 13a:	74 04                	je     140 <strcmp+0x25>
 13c:	3a 02                	cmp    (%edx),%al
 13e:	74 ef                	je     12f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 140:	0f b6 c0             	movzbl %al,%eax
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	29 d0                	sub    %edx,%eax
}
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 150:	80 39 00             	cmpb   $0x0,(%ecx)
 153:	74 12                	je     167 <strlen+0x1d>
 155:	ba 00 00 00 00       	mov    $0x0,%edx
 15a:	83 c2 01             	add    $0x1,%edx
 15d:	89 d0                	mov    %edx,%eax
 15f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 163:	75 f5                	jne    15a <strlen+0x10>
    ;
  return n;
}
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
  for(n = 0; s[n]; n++)
 167:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 16c:	eb f7                	jmp    165 <strlen+0x1b>

0000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	57                   	push   %edi
 172:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 175:	89 d7                	mov    %edx,%edi
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	fc                   	cld    
 17e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 180:	89 d0                	mov    %edx,%eax
 182:	5f                   	pop    %edi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <strchr>:

char*
strchr(const char *s, char c)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	53                   	push   %ebx
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 18f:	0f b6 10             	movzbl (%eax),%edx
 192:	84 d2                	test   %dl,%dl
 194:	74 1e                	je     1b4 <strchr+0x2f>
 196:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 198:	38 d3                	cmp    %dl,%bl
 19a:	74 15                	je     1b1 <strchr+0x2c>
  for(; *s; s++)
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	0f b6 10             	movzbl (%eax),%edx
 1a2:	84 d2                	test   %dl,%dl
 1a4:	74 06                	je     1ac <strchr+0x27>
    if(*s == c)
 1a6:	38 ca                	cmp    %cl,%dl
 1a8:	75 f2                	jne    19c <strchr+0x17>
 1aa:	eb 05                	jmp    1b1 <strchr+0x2c>
      return (char*)s;
  return 0;
 1ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b1:	5b                   	pop    %ebx
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
  return 0;
 1b4:	b8 00 00 00 00       	mov    $0x0,%eax
 1b9:	eb f6                	jmp    1b1 <strchr+0x2c>

000001bb <gets>:

char*
gets(char *buf, int max)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	57                   	push   %edi
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c4:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1c9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1cc:	8d 5e 01             	lea    0x1(%esi),%ebx
 1cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d2:	7d 2b                	jge    1ff <gets+0x44>
    cc = read(0, &c, 1);
 1d4:	83 ec 04             	sub    $0x4,%esp
 1d7:	6a 01                	push   $0x1
 1d9:	57                   	push   %edi
 1da:	6a 00                	push   $0x0
 1dc:	e8 f2 00 00 00       	call   2d3 <read>
    if(cc < 1)
 1e1:	83 c4 10             	add    $0x10,%esp
 1e4:	85 c0                	test   %eax,%eax
 1e6:	7e 17                	jle    1ff <gets+0x44>
      break;
    buf[i++] = c;
 1e8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ec:	8b 55 08             	mov    0x8(%ebp),%edx
 1ef:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1f3:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1f5:	3c 0a                	cmp    $0xa,%al
 1f7:	74 04                	je     1fd <gets+0x42>
 1f9:	3c 0d                	cmp    $0xd,%al
 1fb:	75 cf                	jne    1cc <gets+0x11>
  for(i=0; i+1 < max; ){
 1fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 206:	8d 65 f4             	lea    -0xc(%ebp),%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <stat>:

int
stat(const char *n, struct stat *st)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	56                   	push   %esi
 212:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 213:	83 ec 08             	sub    $0x8,%esp
 216:	6a 00                	push   $0x0
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 db 00 00 00       	call   2fb <open>
  if(fd < 0)
 220:	83 c4 10             	add    $0x10,%esp
 223:	85 c0                	test   %eax,%eax
 225:	78 24                	js     24b <stat+0x3d>
 227:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	pushl  0xc(%ebp)
 22f:	50                   	push   %eax
 230:	e8 de 00 00 00       	call   313 <fstat>
 235:	89 c6                	mov    %eax,%esi
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
 23a:	e8 a4 00 00 00       	call   2e3 <close>
  return r;
 23f:	83 c4 10             	add    $0x10,%esp
}
 242:	89 f0                	mov    %esi,%eax
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5d                   	pop    %ebp
 24a:	c3                   	ret    
    return -1;
 24b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 250:	eb f0                	jmp    242 <stat+0x34>

00000252 <atoi>:

int
atoi(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	53                   	push   %ebx
 256:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 259:	0f b6 11             	movzbl (%ecx),%edx
 25c:	8d 42 d0             	lea    -0x30(%edx),%eax
 25f:	3c 09                	cmp    $0x9,%al
 261:	77 20                	ja     283 <atoi+0x31>
  n = 0;
 263:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 268:	83 c1 01             	add    $0x1,%ecx
 26b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 26e:	0f be d2             	movsbl %dl,%edx
 271:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 275:	0f b6 11             	movzbl (%ecx),%edx
 278:	8d 5a d0             	lea    -0x30(%edx),%ebx
 27b:	80 fb 09             	cmp    $0x9,%bl
 27e:	76 e8                	jbe    268 <atoi+0x16>
  return n;
}
 280:	5b                   	pop    %ebx
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    
  n = 0;
 283:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 288:	eb f6                	jmp    280 <atoi+0x2e>

0000028a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	56                   	push   %esi
 28e:	53                   	push   %ebx
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	8b 75 0c             	mov    0xc(%ebp),%esi
 295:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 298:	85 db                	test   %ebx,%ebx
 29a:	7e 13                	jle    2af <memmove+0x25>
 29c:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2a1:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2a5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2a8:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2ab:	39 d3                	cmp    %edx,%ebx
 2ad:	75 f2                	jne    2a1 <memmove+0x17>
  return vdst;
}
 2af:	5b                   	pop    %ebx
 2b0:	5e                   	pop    %esi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b3:	b8 01 00 00 00       	mov    $0x1,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exit>:
SYSCALL(exit)
 2bb:	b8 02 00 00 00       	mov    $0x2,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <wait>:
SYSCALL(wait)
 2c3:	b8 03 00 00 00       	mov    $0x3,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <pipe>:
SYSCALL(pipe)
 2cb:	b8 04 00 00 00       	mov    $0x4,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <read>:
SYSCALL(read)
 2d3:	b8 05 00 00 00       	mov    $0x5,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <write>:
SYSCALL(write)
 2db:	b8 10 00 00 00       	mov    $0x10,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <close>:
SYSCALL(close)
 2e3:	b8 15 00 00 00       	mov    $0x15,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <kill>:
SYSCALL(kill)
 2eb:	b8 06 00 00 00       	mov    $0x6,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exec>:
SYSCALL(exec)
 2f3:	b8 07 00 00 00       	mov    $0x7,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <open>:
SYSCALL(open)
 2fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <mknod>:
SYSCALL(mknod)
 303:	b8 11 00 00 00       	mov    $0x11,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <unlink>:
SYSCALL(unlink)
 30b:	b8 12 00 00 00       	mov    $0x12,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <fstat>:
SYSCALL(fstat)
 313:	b8 08 00 00 00       	mov    $0x8,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <link>:
SYSCALL(link)
 31b:	b8 13 00 00 00       	mov    $0x13,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <mkdir>:
SYSCALL(mkdir)
 323:	b8 14 00 00 00       	mov    $0x14,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <chdir>:
SYSCALL(chdir)
 32b:	b8 09 00 00 00       	mov    $0x9,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <dup>:
SYSCALL(dup)
 333:	b8 0a 00 00 00       	mov    $0xa,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getpid>:
SYSCALL(getpid)
 33b:	b8 0b 00 00 00       	mov    $0xb,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sbrk>:
SYSCALL(sbrk)
 343:	b8 0c 00 00 00       	mov    $0xc,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sleep>:
SYSCALL(sleep)
 34b:	b8 0d 00 00 00       	mov    $0xd,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <uptime>:
SYSCALL(uptime)
 353:	b8 0e 00 00 00       	mov    $0xe,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <getlevel>:
SYSCALL(getlevel)
 35b:	b8 16 00 00 00       	mov    $0x16,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	57                   	push   %edi
 367:	56                   	push   %esi
 368:	53                   	push   %ebx
 369:	83 ec 3c             	sub    $0x3c,%esp
 36c:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 372:	74 14                	je     388 <printint+0x25>
 374:	85 d2                	test   %edx,%edx
 376:	79 10                	jns    388 <printint+0x25>
    neg = 1;
    x = -xx;
 378:	f7 da                	neg    %edx
    neg = 1;
 37a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 381:	bf 00 00 00 00       	mov    $0x0,%edi
 386:	eb 0b                	jmp    393 <printint+0x30>
  neg = 0;
 388:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 38f:	eb f0                	jmp    381 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 391:	89 df                	mov    %ebx,%edi
 393:	8d 5f 01             	lea    0x1(%edi),%ebx
 396:	89 d0                	mov    %edx,%eax
 398:	ba 00 00 00 00       	mov    $0x0,%edx
 39d:	f7 f1                	div    %ecx
 39f:	0f b6 92 44 07 00 00 	movzbl 0x744(%edx),%edx
 3a6:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3aa:	89 c2                	mov    %eax,%edx
 3ac:	85 c0                	test   %eax,%eax
 3ae:	75 e1                	jne    391 <printint+0x2e>
  if(neg)
 3b0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3b4:	74 08                	je     3be <printint+0x5b>
    buf[i++] = '-';
 3b6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3bb:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3be:	83 eb 01             	sub    $0x1,%ebx
 3c1:	78 22                	js     3e5 <printint+0x82>
  write(fd, &c, 1);
 3c3:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3c6:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3cb:	88 45 d7             	mov    %al,-0x29(%ebp)
 3ce:	83 ec 04             	sub    $0x4,%esp
 3d1:	6a 01                	push   $0x1
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	e8 01 ff ff ff       	call   2db <write>
  while(--i >= 0)
 3da:	83 eb 01             	sub    $0x1,%ebx
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	83 fb ff             	cmp    $0xffffffff,%ebx
 3e3:	75 e1                	jne    3c6 <printint+0x63>
    putc(fd, buf[i]);
}
 3e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e8:	5b                   	pop    %ebx
 3e9:	5e                   	pop    %esi
 3ea:	5f                   	pop    %edi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    

000003ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	57                   	push   %edi
 3f1:	56                   	push   %esi
 3f2:	53                   	push   %ebx
 3f3:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f6:	8b 75 0c             	mov    0xc(%ebp),%esi
 3f9:	0f b6 1e             	movzbl (%esi),%ebx
 3fc:	84 db                	test   %bl,%bl
 3fe:	0f 84 b1 01 00 00    	je     5b5 <printf+0x1c8>
 404:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 407:	8d 45 10             	lea    0x10(%ebp),%eax
 40a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 40d:	bf 00 00 00 00       	mov    $0x0,%edi
 412:	eb 2d                	jmp    441 <printf+0x54>
 414:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 417:	83 ec 04             	sub    $0x4,%esp
 41a:	6a 01                	push   $0x1
 41c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 41f:	50                   	push   %eax
 420:	ff 75 08             	pushl  0x8(%ebp)
 423:	e8 b3 fe ff ff       	call   2db <write>
 428:	83 c4 10             	add    $0x10,%esp
 42b:	eb 05                	jmp    432 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 42d:	83 ff 25             	cmp    $0x25,%edi
 430:	74 22                	je     454 <printf+0x67>
 432:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 435:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 439:	84 db                	test   %bl,%bl
 43b:	0f 84 74 01 00 00    	je     5b5 <printf+0x1c8>
    c = fmt[i] & 0xff;
 441:	0f be d3             	movsbl %bl,%edx
 444:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 447:	85 ff                	test   %edi,%edi
 449:	75 e2                	jne    42d <printf+0x40>
      if(c == '%'){
 44b:	83 f8 25             	cmp    $0x25,%eax
 44e:	75 c4                	jne    414 <printf+0x27>
        state = '%';
 450:	89 c7                	mov    %eax,%edi
 452:	eb de                	jmp    432 <printf+0x45>
      if(c == 'd'){
 454:	83 f8 64             	cmp    $0x64,%eax
 457:	74 59                	je     4b2 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 459:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 45f:	83 fa 70             	cmp    $0x70,%edx
 462:	74 7a                	je     4de <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 464:	83 f8 73             	cmp    $0x73,%eax
 467:	0f 84 9d 00 00 00    	je     50a <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46d:	83 f8 63             	cmp    $0x63,%eax
 470:	0f 84 f2 00 00 00    	je     568 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 476:	83 f8 25             	cmp    $0x25,%eax
 479:	0f 84 15 01 00 00    	je     594 <printf+0x1a7>
 47f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 483:	83 ec 04             	sub    $0x4,%esp
 486:	6a 01                	push   $0x1
 488:	8d 45 e7             	lea    -0x19(%ebp),%eax
 48b:	50                   	push   %eax
 48c:	ff 75 08             	pushl  0x8(%ebp)
 48f:	e8 47 fe ff ff       	call   2db <write>
 494:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 497:	83 c4 0c             	add    $0xc,%esp
 49a:	6a 01                	push   $0x1
 49c:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 49f:	50                   	push   %eax
 4a0:	ff 75 08             	pushl  0x8(%ebp)
 4a3:	e8 33 fe ff ff       	call   2db <write>
 4a8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ab:	bf 00 00 00 00       	mov    $0x0,%edi
 4b0:	eb 80                	jmp    432 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4b2:	83 ec 0c             	sub    $0xc,%esp
 4b5:	6a 01                	push   $0x1
 4b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4bc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4bf:	8b 17                	mov    (%edi),%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	e8 9a fe ff ff       	call   363 <printint>
        ap++;
 4c9:	89 f8                	mov    %edi,%eax
 4cb:	83 c0 04             	add    $0x4,%eax
 4ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d4:	bf 00 00 00 00       	mov    $0x0,%edi
 4d9:	e9 54 ff ff ff       	jmp    432 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4de:	83 ec 0c             	sub    $0xc,%esp
 4e1:	6a 00                	push   $0x0
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4eb:	8b 17                	mov    (%edi),%edx
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	e8 6e fe ff ff       	call   363 <printint>
        ap++;
 4f5:	89 f8                	mov    %edi,%eax
 4f7:	83 c0 04             	add    $0x4,%eax
 4fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4fd:	83 c4 10             	add    $0x10,%esp
      state = 0;
 500:	bf 00 00 00 00       	mov    $0x0,%edi
 505:	e9 28 ff ff ff       	jmp    432 <printf+0x45>
        s = (char*)*ap;
 50a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 50d:	8b 01                	mov    (%ecx),%eax
        ap++;
 50f:	83 c1 04             	add    $0x4,%ecx
 512:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 515:	85 c0                	test   %eax,%eax
 517:	74 13                	je     52c <printf+0x13f>
        s = (char*)*ap;
 519:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 51b:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 51e:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 523:	84 c0                	test   %al,%al
 525:	75 0f                	jne    536 <printf+0x149>
 527:	e9 06 ff ff ff       	jmp    432 <printf+0x45>
          s = "(null)";
 52c:	bb 3c 07 00 00       	mov    $0x73c,%ebx
        while(*s != 0){
 531:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 536:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 539:	89 75 d0             	mov    %esi,-0x30(%ebp)
 53c:	8b 75 08             	mov    0x8(%ebp),%esi
 53f:	88 45 e3             	mov    %al,-0x1d(%ebp)
 542:	83 ec 04             	sub    $0x4,%esp
 545:	6a 01                	push   $0x1
 547:	57                   	push   %edi
 548:	56                   	push   %esi
 549:	e8 8d fd ff ff       	call   2db <write>
          s++;
 54e:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 551:	0f b6 03             	movzbl (%ebx),%eax
 554:	83 c4 10             	add    $0x10,%esp
 557:	84 c0                	test   %al,%al
 559:	75 e4                	jne    53f <printf+0x152>
 55b:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 55e:	bf 00 00 00 00       	mov    $0x0,%edi
 563:	e9 ca fe ff ff       	jmp    432 <printf+0x45>
        putc(fd, *ap);
 568:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 56b:	8b 07                	mov    (%edi),%eax
 56d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	6a 01                	push   $0x1
 575:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 5a fd ff ff       	call   2db <write>
        ap++;
 581:	83 c7 04             	add    $0x4,%edi
 584:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 587:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58a:	bf 00 00 00 00       	mov    $0x0,%edi
 58f:	e9 9e fe ff ff       	jmp    432 <printf+0x45>
 594:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 597:	83 ec 04             	sub    $0x4,%esp
 59a:	6a 01                	push   $0x1
 59c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 33 fd ff ff       	call   2db <write>
 5a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ab:	bf 00 00 00 00       	mov    $0x0,%edi
 5b0:	e9 7d fe ff ff       	jmp    432 <printf+0x45>
    }
  }
}
 5b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b8:	5b                   	pop    %ebx
 5b9:	5e                   	pop    %esi
 5ba:	5f                   	pop    %edi
 5bb:	5d                   	pop    %ebp
 5bc:	c3                   	ret    

000005bd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	57                   	push   %edi
 5c1:	56                   	push   %esi
 5c2:	53                   	push   %ebx
 5c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c6:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c9:	a1 00 0a 00 00       	mov    0xa00,%eax
 5ce:	eb 0c                	jmp    5dc <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	8b 10                	mov    (%eax),%edx
 5d2:	39 c2                	cmp    %eax,%edx
 5d4:	77 04                	ja     5da <free+0x1d>
 5d6:	39 ca                	cmp    %ecx,%edx
 5d8:	77 10                	ja     5ea <free+0x2d>
{
 5da:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	73 f0                	jae    5d0 <free+0x13>
 5e0:	8b 10                	mov    (%eax),%edx
 5e2:	39 ca                	cmp    %ecx,%edx
 5e4:	77 04                	ja     5ea <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e6:	39 c2                	cmp    %eax,%edx
 5e8:	77 f0                	ja     5da <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ea:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ed:	8b 10                	mov    (%eax),%edx
 5ef:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5f2:	39 fa                	cmp    %edi,%edx
 5f4:	74 19                	je     60f <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5f6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f9:	8b 50 04             	mov    0x4(%eax),%edx
 5fc:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5ff:	39 f1                	cmp    %esi,%ecx
 601:	74 1b                	je     61e <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 603:	89 08                	mov    %ecx,(%eax)
  freep = p;
 605:	a3 00 0a 00 00       	mov    %eax,0xa00
}
 60a:	5b                   	pop    %ebx
 60b:	5e                   	pop    %esi
 60c:	5f                   	pop    %edi
 60d:	5d                   	pop    %ebp
 60e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 60f:	03 72 04             	add    0x4(%edx),%esi
 612:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 615:	8b 10                	mov    (%eax),%edx
 617:	8b 12                	mov    (%edx),%edx
 619:	89 53 f8             	mov    %edx,-0x8(%ebx)
 61c:	eb db                	jmp    5f9 <free+0x3c>
    p->s.size += bp->s.size;
 61e:	03 53 fc             	add    -0x4(%ebx),%edx
 621:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 624:	8b 53 f8             	mov    -0x8(%ebx),%edx
 627:	89 10                	mov    %edx,(%eax)
 629:	eb da                	jmp    605 <free+0x48>

0000062b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	57                   	push   %edi
 62f:	56                   	push   %esi
 630:	53                   	push   %ebx
 631:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	8d 58 07             	lea    0x7(%eax),%ebx
 63a:	c1 eb 03             	shr    $0x3,%ebx
 63d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 640:	8b 15 00 0a 00 00    	mov    0xa00,%edx
 646:	85 d2                	test   %edx,%edx
 648:	74 20                	je     66a <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 64c:	8b 48 04             	mov    0x4(%eax),%ecx
 64f:	39 cb                	cmp    %ecx,%ebx
 651:	76 3c                	jbe    68f <malloc+0x64>
 653:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 659:	be 00 10 00 00       	mov    $0x1000,%esi
 65e:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 661:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 668:	eb 70                	jmp    6da <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 66a:	c7 05 00 0a 00 00 04 	movl   $0xa04,0xa00
 671:	0a 00 00 
 674:	c7 05 04 0a 00 00 04 	movl   $0xa04,0xa04
 67b:	0a 00 00 
    base.s.size = 0;
 67e:	c7 05 08 0a 00 00 00 	movl   $0x0,0xa08
 685:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 688:	ba 04 0a 00 00       	mov    $0xa04,%edx
 68d:	eb bb                	jmp    64a <malloc+0x1f>
      if(p->s.size == nunits)
 68f:	39 cb                	cmp    %ecx,%ebx
 691:	74 1c                	je     6af <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 693:	29 d9                	sub    %ebx,%ecx
 695:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 698:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 69b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 69e:	89 15 00 0a 00 00    	mov    %edx,0xa00
      return (void*)(p + 1);
 6a4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6aa:	5b                   	pop    %ebx
 6ab:	5e                   	pop    %esi
 6ac:	5f                   	pop    %edi
 6ad:	5d                   	pop    %ebp
 6ae:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6af:	8b 08                	mov    (%eax),%ecx
 6b1:	89 0a                	mov    %ecx,(%edx)
 6b3:	eb e9                	jmp    69e <malloc+0x73>
  hp->s.size = nu;
 6b5:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	83 c0 08             	add    $0x8,%eax
 6be:	50                   	push   %eax
 6bf:	e8 f9 fe ff ff       	call   5bd <free>
  return freep;
 6c4:	8b 15 00 0a 00 00    	mov    0xa00,%edx
      if((p = morecore(nunits)) == 0)
 6ca:	83 c4 10             	add    $0x10,%esp
 6cd:	85 d2                	test   %edx,%edx
 6cf:	74 2b                	je     6fc <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d3:	8b 48 04             	mov    0x4(%eax),%ecx
 6d6:	39 d9                	cmp    %ebx,%ecx
 6d8:	73 b5                	jae    68f <malloc+0x64>
 6da:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6dc:	39 05 00 0a 00 00    	cmp    %eax,0xa00
 6e2:	75 ed                	jne    6d1 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6e4:	83 ec 0c             	sub    $0xc,%esp
 6e7:	57                   	push   %edi
 6e8:	e8 56 fc ff ff       	call   343 <sbrk>
  if(p == (char*)-1)
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f3:	75 c0                	jne    6b5 <malloc+0x8a>
        return 0;
 6f5:	b8 00 00 00 00       	mov    $0x0,%eax
 6fa:	eb ab                	jmp    6a7 <malloc+0x7c>
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb a4                	jmp    6a7 <malloc+0x7c>
