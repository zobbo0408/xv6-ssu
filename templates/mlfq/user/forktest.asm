
user/_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <print>:

#define N  1000

void
print(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 33 01 00 00       	call   143 <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	pushl  0x8(%ebp)
  18:	e8 b7 02 00 00       	call   2d4 <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  print(1, "fork test\n");
  2c:	68 fc 06 00 00       	push   $0x6fc
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <print>
  38:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
  40:	e8 67 02 00 00       	call   2ac <fork>
    if(pid < 0)
  45:	85 c0                	test   %eax,%eax
  47:	78 2d                	js     76 <forktest+0x51>
      break;
    if(pid == 0)
  49:	85 c0                	test   %eax,%eax
  4b:	74 24                	je     71 <forktest+0x4c>
  for(n=0; n<N; n++){
  4d:	83 c3 01             	add    $0x1,%ebx
  50:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  56:	75 e8                	jne    40 <forktest+0x1b>
      exit();
  }

  if(n == N){
    print(1, "fork claimed to work N times!\n", N);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	68 e8 03 00 00       	push   $0x3e8
  60:	68 3c 07 00 00       	push   $0x73c
  65:	6a 01                	push   $0x1
  67:	e8 94 ff ff ff       	call   0 <print>
    exit();
  6c:	e8 43 02 00 00       	call   2b4 <exit>
      exit();
  71:	e8 3e 02 00 00       	call   2b4 <exit>
  if(n == N){
  76:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  7c:	74 da                	je     58 <forktest+0x33>
  }

  for(; n > 0; n--){
  7e:	85 db                	test   %ebx,%ebx
  80:	7e 0e                	jle    90 <forktest+0x6b>
    if(wait() < 0){
  82:	e8 35 02 00 00       	call   2bc <wait>
  87:	85 c0                	test   %eax,%eax
  89:	78 26                	js     b1 <forktest+0x8c>
  for(; n > 0; n--){
  8b:	83 eb 01             	sub    $0x1,%ebx
  8e:	75 f2                	jne    82 <forktest+0x5d>
      print(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  90:	e8 27 02 00 00       	call   2bc <wait>
  95:	83 f8 ff             	cmp    $0xffffffff,%eax
  98:	75 2b                	jne    c5 <forktest+0xa0>
    print(1, "wait got too many\n");
    exit();
  }

  print(1, "fork test OK\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 2e 07 00 00       	push   $0x72e
  a2:	6a 01                	push   $0x1
  a4:	e8 57 ff ff ff       	call   0 <print>
}
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  af:	c9                   	leave  
  b0:	c3                   	ret    
      print(1, "wait stopped early\n");
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	68 07 07 00 00       	push   $0x707
  b9:	6a 01                	push   $0x1
  bb:	e8 40 ff ff ff       	call   0 <print>
      exit();
  c0:	e8 ef 01 00 00       	call   2b4 <exit>
    print(1, "wait got too many\n");
  c5:	83 ec 08             	sub    $0x8,%esp
  c8:	68 1b 07 00 00       	push   $0x71b
  cd:	6a 01                	push   $0x1
  cf:	e8 2c ff ff ff       	call   0 <print>
    exit();
  d4:	e8 db 01 00 00       	call   2b4 <exit>

000000d9 <main>:

int
main(void)
{
  d9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  dd:	83 e4 f0             	and    $0xfffffff0,%esp
  e0:	ff 71 fc             	pushl  -0x4(%ecx)
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	51                   	push   %ecx
  e7:	83 ec 04             	sub    $0x4,%esp
  forktest();
  ea:	e8 36 ff ff ff       	call   25 <forktest>
  exit();
  ef:	e8 c0 01 00 00       	call   2b4 <exit>

000000f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	53                   	push   %ebx
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	89 c2                	mov    %eax,%edx
 100:	83 c1 01             	add    $0x1,%ecx
 103:	83 c2 01             	add    $0x1,%edx
 106:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 10a:	88 5a ff             	mov    %bl,-0x1(%edx)
 10d:	84 db                	test   %bl,%bl
 10f:	75 ef                	jne    100 <strcpy+0xc>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 11d:	0f b6 01             	movzbl (%ecx),%eax
 120:	84 c0                	test   %al,%al
 122:	74 15                	je     139 <strcmp+0x25>
 124:	3a 02                	cmp    (%edx),%al
 126:	75 11                	jne    139 <strcmp+0x25>
    p++, q++;
 128:	83 c1 01             	add    $0x1,%ecx
 12b:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 12e:	0f b6 01             	movzbl (%ecx),%eax
 131:	84 c0                	test   %al,%al
 133:	74 04                	je     139 <strcmp+0x25>
 135:	3a 02                	cmp    (%edx),%al
 137:	74 ef                	je     128 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 139:	0f b6 c0             	movzbl %al,%eax
 13c:	0f b6 12             	movzbl (%edx),%edx
 13f:	29 d0                	sub    %edx,%eax
}
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <strlen>:

uint
strlen(const char *s)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 149:	80 39 00             	cmpb   $0x0,(%ecx)
 14c:	74 12                	je     160 <strlen+0x1d>
 14e:	ba 00 00 00 00       	mov    $0x0,%edx
 153:	83 c2 01             	add    $0x1,%edx
 156:	89 d0                	mov    %edx,%eax
 158:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 15c:	75 f5                	jne    153 <strlen+0x10>
    ;
  return n;
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    
  for(n = 0; s[n]; n++)
 160:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 165:	eb f7                	jmp    15e <strlen+0x1b>

00000167 <memset>:

void*
memset(void *dst, int c, uint n)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	57                   	push   %edi
 16b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 16e:	89 d7                	mov    %edx,%edi
 170:	8b 4d 10             	mov    0x10(%ebp),%ecx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	fc                   	cld    
 177:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 179:	89 d0                	mov    %edx,%eax
 17b:	5f                   	pop    %edi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    

0000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	53                   	push   %ebx
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 188:	0f b6 10             	movzbl (%eax),%edx
 18b:	84 d2                	test   %dl,%dl
 18d:	74 1e                	je     1ad <strchr+0x2f>
 18f:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	74 15                	je     1aa <strchr+0x2c>
  for(; *s; s++)
 195:	83 c0 01             	add    $0x1,%eax
 198:	0f b6 10             	movzbl (%eax),%edx
 19b:	84 d2                	test   %dl,%dl
 19d:	74 06                	je     1a5 <strchr+0x27>
    if(*s == c)
 19f:	38 ca                	cmp    %cl,%dl
 1a1:	75 f2                	jne    195 <strchr+0x17>
 1a3:	eb 05                	jmp    1aa <strchr+0x2c>
      return (char*)s;
  return 0;
 1a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1aa:	5b                   	pop    %ebx
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
  return 0;
 1ad:	b8 00 00 00 00       	mov    $0x0,%eax
 1b2:	eb f6                	jmp    1aa <strchr+0x2c>

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bd:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1c2:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c5:	8d 5e 01             	lea    0x1(%esi),%ebx
 1c8:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cb:	7d 2b                	jge    1f8 <gets+0x44>
    cc = read(0, &c, 1);
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	6a 01                	push   $0x1
 1d2:	57                   	push   %edi
 1d3:	6a 00                	push   $0x0
 1d5:	e8 f2 00 00 00       	call   2cc <read>
    if(cc < 1)
 1da:	83 c4 10             	add    $0x10,%esp
 1dd:	85 c0                	test   %eax,%eax
 1df:	7e 17                	jle    1f8 <gets+0x44>
      break;
    buf[i++] = c;
 1e1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e5:	8b 55 08             	mov    0x8(%ebp),%edx
 1e8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1ec:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1ee:	3c 0a                	cmp    $0xa,%al
 1f0:	74 04                	je     1f6 <gets+0x42>
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	75 cf                	jne    1c5 <gets+0x11>
  for(i=0; i+1 < max; ){
 1f6:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 202:	5b                   	pop    %ebx
 203:	5e                   	pop    %esi
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    

00000207 <stat>:

int
stat(const char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	56                   	push   %esi
 20b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 db 00 00 00       	call   2f4 <open>
  if(fd < 0)
 219:	83 c4 10             	add    $0x10,%esp
 21c:	85 c0                	test   %eax,%eax
 21e:	78 24                	js     244 <stat+0x3d>
 220:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 222:	83 ec 08             	sub    $0x8,%esp
 225:	ff 75 0c             	pushl  0xc(%ebp)
 228:	50                   	push   %eax
 229:	e8 de 00 00 00       	call   30c <fstat>
 22e:	89 c6                	mov    %eax,%esi
  close(fd);
 230:	89 1c 24             	mov    %ebx,(%esp)
 233:	e8 a4 00 00 00       	call   2dc <close>
  return r;
 238:	83 c4 10             	add    $0x10,%esp
}
 23b:	89 f0                	mov    %esi,%eax
 23d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
    return -1;
 244:	be ff ff ff ff       	mov    $0xffffffff,%esi
 249:	eb f0                	jmp    23b <stat+0x34>

0000024b <atoi>:

int
atoi(const char *s)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	53                   	push   %ebx
 24f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	0f b6 11             	movzbl (%ecx),%edx
 255:	8d 42 d0             	lea    -0x30(%edx),%eax
 258:	3c 09                	cmp    $0x9,%al
 25a:	77 20                	ja     27c <atoi+0x31>
  n = 0;
 25c:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 261:	83 c1 01             	add    $0x1,%ecx
 264:	8d 04 80             	lea    (%eax,%eax,4),%eax
 267:	0f be d2             	movsbl %dl,%edx
 26a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 26e:	0f b6 11             	movzbl (%ecx),%edx
 271:	8d 5a d0             	lea    -0x30(%edx),%ebx
 274:	80 fb 09             	cmp    $0x9,%bl
 277:	76 e8                	jbe    261 <atoi+0x16>
  return n;
}
 279:	5b                   	pop    %ebx
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    
  n = 0;
 27c:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 281:	eb f6                	jmp    279 <atoi+0x2e>

00000283 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	56                   	push   %esi
 287:	53                   	push   %ebx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
 28e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 291:	85 db                	test   %ebx,%ebx
 293:	7e 13                	jle    2a8 <memmove+0x25>
 295:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 29a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2a1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a4:	39 d3                	cmp    %edx,%ebx
 2a6:	75 f2                	jne    29a <memmove+0x17>
  return vdst;
}
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5d                   	pop    %ebp
 2ab:	c3                   	ret    

000002ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ac:	b8 01 00 00 00       	mov    $0x1,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <exit>:
SYSCALL(exit)
 2b4:	b8 02 00 00 00       	mov    $0x2,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <wait>:
SYSCALL(wait)
 2bc:	b8 03 00 00 00       	mov    $0x3,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <pipe>:
SYSCALL(pipe)
 2c4:	b8 04 00 00 00       	mov    $0x4,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <read>:
SYSCALL(read)
 2cc:	b8 05 00 00 00       	mov    $0x5,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <write>:
SYSCALL(write)
 2d4:	b8 10 00 00 00       	mov    $0x10,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <close>:
SYSCALL(close)
 2dc:	b8 15 00 00 00       	mov    $0x15,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <kill>:
SYSCALL(kill)
 2e4:	b8 06 00 00 00       	mov    $0x6,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <exec>:
SYSCALL(exec)
 2ec:	b8 07 00 00 00       	mov    $0x7,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <open>:
SYSCALL(open)
 2f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <mknod>:
SYSCALL(mknod)
 2fc:	b8 11 00 00 00       	mov    $0x11,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <unlink>:
SYSCALL(unlink)
 304:	b8 12 00 00 00       	mov    $0x12,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <fstat>:
SYSCALL(fstat)
 30c:	b8 08 00 00 00       	mov    $0x8,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <link>:
SYSCALL(link)
 314:	b8 13 00 00 00       	mov    $0x13,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mkdir>:
SYSCALL(mkdir)
 31c:	b8 14 00 00 00       	mov    $0x14,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <chdir>:
SYSCALL(chdir)
 324:	b8 09 00 00 00       	mov    $0x9,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <dup>:
SYSCALL(dup)
 32c:	b8 0a 00 00 00       	mov    $0xa,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <getpid>:
SYSCALL(getpid)
 334:	b8 0b 00 00 00       	mov    $0xb,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <sbrk>:
SYSCALL(sbrk)
 33c:	b8 0c 00 00 00       	mov    $0xc,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sleep>:
SYSCALL(sleep)
 344:	b8 0d 00 00 00       	mov    $0xd,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <uptime>:
SYSCALL(uptime)
 34c:	b8 0e 00 00 00       	mov    $0xe,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getlevel>:
SYSCALL(getlevel)
 354:	b8 16 00 00 00       	mov    $0x16,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 3c             	sub    $0x3c,%esp
 365:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 36b:	74 14                	je     381 <printint+0x25>
 36d:	85 d2                	test   %edx,%edx
 36f:	79 10                	jns    381 <printint+0x25>
    neg = 1;
    x = -xx;
 371:	f7 da                	neg    %edx
    neg = 1;
 373:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37a:	bf 00 00 00 00       	mov    $0x0,%edi
 37f:	eb 0b                	jmp    38c <printint+0x30>
  neg = 0;
 381:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 388:	eb f0                	jmp    37a <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 38a:	89 df                	mov    %ebx,%edi
 38c:	8d 5f 01             	lea    0x1(%edi),%ebx
 38f:	89 d0                	mov    %edx,%eax
 391:	ba 00 00 00 00       	mov    $0x0,%edx
 396:	f7 f1                	div    %ecx
 398:	0f b6 92 64 07 00 00 	movzbl 0x764(%edx),%edx
 39f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3a3:	89 c2                	mov    %eax,%edx
 3a5:	85 c0                	test   %eax,%eax
 3a7:	75 e1                	jne    38a <printint+0x2e>
  if(neg)
 3a9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3ad:	74 08                	je     3b7 <printint+0x5b>
    buf[i++] = '-';
 3af:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3b4:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3b7:	83 eb 01             	sub    $0x1,%ebx
 3ba:	78 22                	js     3de <printint+0x82>
  write(fd, &c, 1);
 3bc:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3bf:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3c4:	88 45 d7             	mov    %al,-0x29(%ebp)
 3c7:	83 ec 04             	sub    $0x4,%esp
 3ca:	6a 01                	push   $0x1
 3cc:	57                   	push   %edi
 3cd:	56                   	push   %esi
 3ce:	e8 01 ff ff ff       	call   2d4 <write>
  while(--i >= 0)
 3d3:	83 eb 01             	sub    $0x1,%ebx
 3d6:	83 c4 10             	add    $0x10,%esp
 3d9:	83 fb ff             	cmp    $0xffffffff,%ebx
 3dc:	75 e1                	jne    3bf <printint+0x63>
    putc(fd, buf[i]);
}
 3de:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e1:	5b                   	pop    %ebx
 3e2:	5e                   	pop    %esi
 3e3:	5f                   	pop    %edi
 3e4:	5d                   	pop    %ebp
 3e5:	c3                   	ret    

000003e6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	57                   	push   %edi
 3ea:	56                   	push   %esi
 3eb:	53                   	push   %ebx
 3ec:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ef:	8b 75 0c             	mov    0xc(%ebp),%esi
 3f2:	0f b6 1e             	movzbl (%esi),%ebx
 3f5:	84 db                	test   %bl,%bl
 3f7:	0f 84 b1 01 00 00    	je     5ae <printf+0x1c8>
 3fd:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 400:	8d 45 10             	lea    0x10(%ebp),%eax
 403:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 406:	bf 00 00 00 00       	mov    $0x0,%edi
 40b:	eb 2d                	jmp    43a <printf+0x54>
 40d:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 410:	83 ec 04             	sub    $0x4,%esp
 413:	6a 01                	push   $0x1
 415:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 418:	50                   	push   %eax
 419:	ff 75 08             	pushl  0x8(%ebp)
 41c:	e8 b3 fe ff ff       	call   2d4 <write>
 421:	83 c4 10             	add    $0x10,%esp
 424:	eb 05                	jmp    42b <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 426:	83 ff 25             	cmp    $0x25,%edi
 429:	74 22                	je     44d <printf+0x67>
 42b:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 42e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 432:	84 db                	test   %bl,%bl
 434:	0f 84 74 01 00 00    	je     5ae <printf+0x1c8>
    c = fmt[i] & 0xff;
 43a:	0f be d3             	movsbl %bl,%edx
 43d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 440:	85 ff                	test   %edi,%edi
 442:	75 e2                	jne    426 <printf+0x40>
      if(c == '%'){
 444:	83 f8 25             	cmp    $0x25,%eax
 447:	75 c4                	jne    40d <printf+0x27>
        state = '%';
 449:	89 c7                	mov    %eax,%edi
 44b:	eb de                	jmp    42b <printf+0x45>
      if(c == 'd'){
 44d:	83 f8 64             	cmp    $0x64,%eax
 450:	74 59                	je     4ab <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 452:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 458:	83 fa 70             	cmp    $0x70,%edx
 45b:	74 7a                	je     4d7 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 45d:	83 f8 73             	cmp    $0x73,%eax
 460:	0f 84 9d 00 00 00    	je     503 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 466:	83 f8 63             	cmp    $0x63,%eax
 469:	0f 84 f2 00 00 00    	je     561 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 46f:	83 f8 25             	cmp    $0x25,%eax
 472:	0f 84 15 01 00 00    	je     58d <printf+0x1a7>
 478:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	6a 01                	push   $0x1
 481:	8d 45 e7             	lea    -0x19(%ebp),%eax
 484:	50                   	push   %eax
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 47 fe ff ff       	call   2d4 <write>
 48d:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 490:	83 c4 0c             	add    $0xc,%esp
 493:	6a 01                	push   $0x1
 495:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 498:	50                   	push   %eax
 499:	ff 75 08             	pushl  0x8(%ebp)
 49c:	e8 33 fe ff ff       	call   2d4 <write>
 4a1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a4:	bf 00 00 00 00       	mov    $0x0,%edi
 4a9:	eb 80                	jmp    42b <printf+0x45>
        printint(fd, *ap, 10, 1);
 4ab:	83 ec 0c             	sub    $0xc,%esp
 4ae:	6a 01                	push   $0x1
 4b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b8:	8b 17                	mov    (%edi),%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 9a fe ff ff       	call   35c <printint>
        ap++;
 4c2:	89 f8                	mov    %edi,%eax
 4c4:	83 c0 04             	add    $0x4,%eax
 4c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cd:	bf 00 00 00 00       	mov    $0x0,%edi
 4d2:	e9 54 ff ff ff       	jmp    42b <printf+0x45>
        printint(fd, *ap, 16, 0);
 4d7:	83 ec 0c             	sub    $0xc,%esp
 4da:	6a 00                	push   $0x0
 4dc:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4e4:	8b 17                	mov    (%edi),%edx
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	e8 6e fe ff ff       	call   35c <printint>
        ap++;
 4ee:	89 f8                	mov    %edi,%eax
 4f0:	83 c0 04             	add    $0x4,%eax
 4f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4f6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f9:	bf 00 00 00 00       	mov    $0x0,%edi
 4fe:	e9 28 ff ff ff       	jmp    42b <printf+0x45>
        s = (char*)*ap;
 503:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 506:	8b 01                	mov    (%ecx),%eax
        ap++;
 508:	83 c1 04             	add    $0x4,%ecx
 50b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 50e:	85 c0                	test   %eax,%eax
 510:	74 13                	je     525 <printf+0x13f>
        s = (char*)*ap;
 512:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 514:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 517:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 51c:	84 c0                	test   %al,%al
 51e:	75 0f                	jne    52f <printf+0x149>
 520:	e9 06 ff ff ff       	jmp    42b <printf+0x45>
          s = "(null)";
 525:	bb 5c 07 00 00       	mov    $0x75c,%ebx
        while(*s != 0){
 52a:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 52f:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 532:	89 75 d0             	mov    %esi,-0x30(%ebp)
 535:	8b 75 08             	mov    0x8(%ebp),%esi
 538:	88 45 e3             	mov    %al,-0x1d(%ebp)
 53b:	83 ec 04             	sub    $0x4,%esp
 53e:	6a 01                	push   $0x1
 540:	57                   	push   %edi
 541:	56                   	push   %esi
 542:	e8 8d fd ff ff       	call   2d4 <write>
          s++;
 547:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 54a:	0f b6 03             	movzbl (%ebx),%eax
 54d:	83 c4 10             	add    $0x10,%esp
 550:	84 c0                	test   %al,%al
 552:	75 e4                	jne    538 <printf+0x152>
 554:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 557:	bf 00 00 00 00       	mov    $0x0,%edi
 55c:	e9 ca fe ff ff       	jmp    42b <printf+0x45>
        putc(fd, *ap);
 561:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 564:	8b 07                	mov    (%edi),%eax
 566:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 569:	83 ec 04             	sub    $0x4,%esp
 56c:	6a 01                	push   $0x1
 56e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 571:	50                   	push   %eax
 572:	ff 75 08             	pushl  0x8(%ebp)
 575:	e8 5a fd ff ff       	call   2d4 <write>
        ap++;
 57a:	83 c7 04             	add    $0x4,%edi
 57d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 580:	83 c4 10             	add    $0x10,%esp
      state = 0;
 583:	bf 00 00 00 00       	mov    $0x0,%edi
 588:	e9 9e fe ff ff       	jmp    42b <printf+0x45>
 58d:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	6a 01                	push   $0x1
 595:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 33 fd ff ff       	call   2d4 <write>
 5a1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a4:	bf 00 00 00 00       	mov    $0x0,%edi
 5a9:	e9 7d fe ff ff       	jmp    42b <printf+0x45>
    }
  }
}
 5ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b1:	5b                   	pop    %ebx
 5b2:	5e                   	pop    %esi
 5b3:	5f                   	pop    %edi
 5b4:	5d                   	pop    %ebp
 5b5:	c3                   	ret    

000005b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	57                   	push   %edi
 5ba:	56                   	push   %esi
 5bb:	53                   	push   %ebx
 5bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5bf:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c2:	a1 18 0a 00 00       	mov    0xa18,%eax
 5c7:	eb 0c                	jmp    5d5 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c9:	8b 10                	mov    (%eax),%edx
 5cb:	39 c2                	cmp    %eax,%edx
 5cd:	77 04                	ja     5d3 <free+0x1d>
 5cf:	39 ca                	cmp    %ecx,%edx
 5d1:	77 10                	ja     5e3 <free+0x2d>
{
 5d3:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d5:	39 c8                	cmp    %ecx,%eax
 5d7:	73 f0                	jae    5c9 <free+0x13>
 5d9:	8b 10                	mov    (%eax),%edx
 5db:	39 ca                	cmp    %ecx,%edx
 5dd:	77 04                	ja     5e3 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5df:	39 c2                	cmp    %eax,%edx
 5e1:	77 f0                	ja     5d3 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5eb:	39 fa                	cmp    %edi,%edx
 5ed:	74 19                	je     608 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ef:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f2:	8b 50 04             	mov    0x4(%eax),%edx
 5f5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f8:	39 f1                	cmp    %esi,%ecx
 5fa:	74 1b                	je     617 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5fc:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5fe:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 608:	03 72 04             	add    0x4(%edx),%esi
 60b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 10                	mov    (%eax),%edx
 610:	8b 12                	mov    (%edx),%edx
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
 615:	eb db                	jmp    5f2 <free+0x3c>
    p->s.size += bp->s.size;
 617:	03 53 fc             	add    -0x4(%ebx),%edx
 61a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 61d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 620:	89 10                	mov    %edx,(%eax)
 622:	eb da                	jmp    5fe <free+0x48>

00000624 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	57                   	push   %edi
 628:	56                   	push   %esi
 629:	53                   	push   %ebx
 62a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	8d 58 07             	lea    0x7(%eax),%ebx
 633:	c1 eb 03             	shr    $0x3,%ebx
 636:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 639:	8b 15 18 0a 00 00    	mov    0xa18,%edx
 63f:	85 d2                	test   %edx,%edx
 641:	74 20                	je     663 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 643:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 645:	8b 48 04             	mov    0x4(%eax),%ecx
 648:	39 cb                	cmp    %ecx,%ebx
 64a:	76 3c                	jbe    688 <malloc+0x64>
 64c:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 652:	be 00 10 00 00       	mov    $0x1000,%esi
 657:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 65a:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 661:	eb 70                	jmp    6d3 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 663:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 66a:	0a 00 00 
 66d:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 674:	0a 00 00 
    base.s.size = 0;
 677:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 67e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 681:	ba 1c 0a 00 00       	mov    $0xa1c,%edx
 686:	eb bb                	jmp    643 <malloc+0x1f>
      if(p->s.size == nunits)
 688:	39 cb                	cmp    %ecx,%ebx
 68a:	74 1c                	je     6a8 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 68c:	29 d9                	sub    %ebx,%ecx
 68e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 691:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 694:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 697:	89 15 18 0a 00 00    	mov    %edx,0xa18
      return (void*)(p + 1);
 69d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a3:	5b                   	pop    %ebx
 6a4:	5e                   	pop    %esi
 6a5:	5f                   	pop    %edi
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6a8:	8b 08                	mov    (%eax),%ecx
 6aa:	89 0a                	mov    %ecx,(%edx)
 6ac:	eb e9                	jmp    697 <malloc+0x73>
  hp->s.size = nu;
 6ae:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6b1:	83 ec 0c             	sub    $0xc,%esp
 6b4:	83 c0 08             	add    $0x8,%eax
 6b7:	50                   	push   %eax
 6b8:	e8 f9 fe ff ff       	call   5b6 <free>
  return freep;
 6bd:	8b 15 18 0a 00 00    	mov    0xa18,%edx
      if((p = morecore(nunits)) == 0)
 6c3:	83 c4 10             	add    $0x10,%esp
 6c6:	85 d2                	test   %edx,%edx
 6c8:	74 2b                	je     6f5 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ca:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6cc:	8b 48 04             	mov    0x4(%eax),%ecx
 6cf:	39 d9                	cmp    %ebx,%ecx
 6d1:	73 b5                	jae    688 <malloc+0x64>
 6d3:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6d5:	39 05 18 0a 00 00    	cmp    %eax,0xa18
 6db:	75 ed                	jne    6ca <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6dd:	83 ec 0c             	sub    $0xc,%esp
 6e0:	57                   	push   %edi
 6e1:	e8 56 fc ff ff       	call   33c <sbrk>
  if(p == (char*)-1)
 6e6:	83 c4 10             	add    $0x10,%esp
 6e9:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ec:	75 c0                	jne    6ae <malloc+0x8a>
        return 0;
 6ee:	b8 00 00 00 00       	mov    $0x0,%eax
 6f3:	eb ab                	jmp    6a0 <malloc+0x7c>
 6f5:	b8 00 00 00 00       	mov    $0x0,%eax
 6fa:	eb a4                	jmp    6a0 <malloc+0x7c>
