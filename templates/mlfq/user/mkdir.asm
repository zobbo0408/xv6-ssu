
user/_mkdir:     file format elf32-i386


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
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	83 c3 04             	add    $0x4,%ebx
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  1c:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7e 20                	jle    46 <main+0x46>
    if(mkdir(argv[i]) < 0){
  26:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	ff 33                	pushl  (%ebx)
  2e:	e8 6b 02 00 00       	call   29e <mkdir>
  33:	83 c4 10             	add    $0x10,%esp
  36:	85 c0                	test   %eax,%eax
  38:	78 20                	js     5a <main+0x5a>
  for(i = 1; i < argc; i++){
  3a:	83 c6 01             	add    $0x1,%esi
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	39 f7                	cmp    %esi,%edi
  42:	75 e2                	jne    26 <main+0x26>
  44:	eb 2b                	jmp    71 <main+0x71>
    printf(2, "Usage: mkdir files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 80 06 00 00       	push   $0x680
  4e:	6a 02                	push   $0x2
  50:	e8 13 03 00 00       	call   368 <printf>
    exit();
  55:	e8 dc 01 00 00       	call   236 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  60:	ff 30                	pushl  (%eax)
  62:	68 97 06 00 00       	push   $0x697
  67:	6a 02                	push   $0x2
  69:	e8 fa 02 00 00       	call   368 <printf>
      break;
  6e:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  71:	e8 c0 01 00 00       	call   236 <exit>

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	53                   	push   %ebx
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	89 c2                	mov    %eax,%edx
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  88:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	84 db                	test   %bl,%bl
  91:	75 ef                	jne    82 <strcpy+0xc>
    ;
  return os;
}
  93:	5b                   	pop    %ebx
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 15                	je     bb <strcmp+0x25>
  a6:	3a 02                	cmp    (%edx),%al
  a8:	75 11                	jne    bb <strcmp+0x25>
    p++, q++;
  aa:	83 c1 01             	add    $0x1,%ecx
  ad:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b0:	0f b6 01             	movzbl (%ecx),%eax
  b3:	84 c0                	test   %al,%al
  b5:	74 04                	je     bb <strcmp+0x25>
  b7:	3a 02                	cmp    (%edx),%al
  b9:	74 ef                	je     aa <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	29 d0                	sub    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(const char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  cb:	80 39 00             	cmpb   $0x0,(%ecx)
  ce:	74 12                	je     e2 <strlen+0x1d>
  d0:	ba 00 00 00 00       	mov    $0x0,%edx
  d5:	83 c2 01             	add    $0x1,%edx
  d8:	89 d0                	mov    %edx,%eax
  da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  de:	75 f5                	jne    d5 <strlen+0x10>
    ;
  return n;
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  e7:	eb f7                	jmp    e0 <strlen+0x1b>

000000e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	89 d7                	mov    %edx,%edi
  f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	fc                   	cld    
  f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fb:	89 d0                	mov    %edx,%eax
  fd:	5f                   	pop    %edi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	74 1e                	je     12f <strchr+0x2f>
 111:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 113:	38 d3                	cmp    %dl,%bl
 115:	74 15                	je     12c <strchr+0x2c>
  for(; *s; s++)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	74 06                	je     127 <strchr+0x27>
    if(*s == c)
 121:	38 ca                	cmp    %cl,%dl
 123:	75 f2                	jne    117 <strchr+0x17>
 125:	eb 05                	jmp    12c <strchr+0x2c>
      return (char*)s;
  return 0;
 127:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12c:	5b                   	pop    %ebx
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
  return 0;
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb f6                	jmp    12c <strchr+0x2c>

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	57                   	push   %edi
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
 13c:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 144:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 147:	8d 5e 01             	lea    0x1(%esi),%ebx
 14a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14d:	7d 2b                	jge    17a <gets+0x44>
    cc = read(0, &c, 1);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	6a 01                	push   $0x1
 154:	57                   	push   %edi
 155:	6a 00                	push   $0x0
 157:	e8 f2 00 00 00       	call   24e <read>
    if(cc < 1)
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	85 c0                	test   %eax,%eax
 161:	7e 17                	jle    17a <gets+0x44>
      break;
    buf[i++] = c;
 163:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 167:	8b 55 08             	mov    0x8(%ebp),%edx
 16a:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 16e:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 170:	3c 0a                	cmp    $0xa,%al
 172:	74 04                	je     178 <gets+0x42>
 174:	3c 0d                	cmp    $0xd,%al
 176:	75 cf                	jne    147 <gets+0x11>
  for(i=0; i+1 < max; ){
 178:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 181:	8d 65 f4             	lea    -0xc(%ebp),%esp
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5f                   	pop    %edi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    

00000189 <stat>:

int
stat(const char *n, struct stat *st)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	6a 00                	push   $0x0
 193:	ff 75 08             	pushl  0x8(%ebp)
 196:	e8 db 00 00 00       	call   276 <open>
  if(fd < 0)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	78 24                	js     1c6 <stat+0x3d>
 1a2:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	ff 75 0c             	pushl  0xc(%ebp)
 1aa:	50                   	push   %eax
 1ab:	e8 de 00 00 00       	call   28e <fstat>
 1b0:	89 c6                	mov    %eax,%esi
  close(fd);
 1b2:	89 1c 24             	mov    %ebx,(%esp)
 1b5:	e8 a4 00 00 00       	call   25e <close>
  return r;
 1ba:	83 c4 10             	add    $0x10,%esp
}
 1bd:	89 f0                	mov    %esi,%eax
 1bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c2:	5b                   	pop    %ebx
 1c3:	5e                   	pop    %esi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
    return -1;
 1c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cb:	eb f0                	jmp    1bd <stat+0x34>

000001cd <atoi>:

int
atoi(const char *s)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	53                   	push   %ebx
 1d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d4:	0f b6 11             	movzbl (%ecx),%edx
 1d7:	8d 42 d0             	lea    -0x30(%edx),%eax
 1da:	3c 09                	cmp    $0x9,%al
 1dc:	77 20                	ja     1fe <atoi+0x31>
  n = 0;
 1de:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1e3:	83 c1 01             	add    $0x1,%ecx
 1e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1e9:	0f be d2             	movsbl %dl,%edx
 1ec:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1f0:	0f b6 11             	movzbl (%ecx),%edx
 1f3:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1f6:	80 fb 09             	cmp    $0x9,%bl
 1f9:	76 e8                	jbe    1e3 <atoi+0x16>
  return n;
}
 1fb:	5b                   	pop    %ebx
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    
  n = 0;
 1fe:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 203:	eb f6                	jmp    1fb <atoi+0x2e>

00000205 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	56                   	push   %esi
 209:	53                   	push   %ebx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	8b 75 0c             	mov    0xc(%ebp),%esi
 210:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 213:	85 db                	test   %ebx,%ebx
 215:	7e 13                	jle    22a <memmove+0x25>
 217:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 21c:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 220:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 223:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 226:	39 d3                	cmp    %edx,%ebx
 228:	75 f2                	jne    21c <memmove+0x17>
  return vdst;
}
 22a:	5b                   	pop    %ebx
 22b:	5e                   	pop    %esi
 22c:	5d                   	pop    %ebp
 22d:	c3                   	ret    

0000022e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22e:	b8 01 00 00 00       	mov    $0x1,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <exit>:
SYSCALL(exit)
 236:	b8 02 00 00 00       	mov    $0x2,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <wait>:
SYSCALL(wait)
 23e:	b8 03 00 00 00       	mov    $0x3,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <pipe>:
SYSCALL(pipe)
 246:	b8 04 00 00 00       	mov    $0x4,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <read>:
SYSCALL(read)
 24e:	b8 05 00 00 00       	mov    $0x5,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <write>:
SYSCALL(write)
 256:	b8 10 00 00 00       	mov    $0x10,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <close>:
SYSCALL(close)
 25e:	b8 15 00 00 00       	mov    $0x15,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <kill>:
SYSCALL(kill)
 266:	b8 06 00 00 00       	mov    $0x6,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <exec>:
SYSCALL(exec)
 26e:	b8 07 00 00 00       	mov    $0x7,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <open>:
SYSCALL(open)
 276:	b8 0f 00 00 00       	mov    $0xf,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <mknod>:
SYSCALL(mknod)
 27e:	b8 11 00 00 00       	mov    $0x11,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <unlink>:
SYSCALL(unlink)
 286:	b8 12 00 00 00       	mov    $0x12,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <fstat>:
SYSCALL(fstat)
 28e:	b8 08 00 00 00       	mov    $0x8,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <link>:
SYSCALL(link)
 296:	b8 13 00 00 00       	mov    $0x13,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <mkdir>:
SYSCALL(mkdir)
 29e:	b8 14 00 00 00       	mov    $0x14,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <chdir>:
SYSCALL(chdir)
 2a6:	b8 09 00 00 00       	mov    $0x9,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <dup>:
SYSCALL(dup)
 2ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <getpid>:
SYSCALL(getpid)
 2b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <sbrk>:
SYSCALL(sbrk)
 2be:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <sleep>:
SYSCALL(sleep)
 2c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <uptime>:
SYSCALL(uptime)
 2ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <getlevel>:
SYSCALL(getlevel)
 2d6:	b8 16 00 00 00       	mov    $0x16,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	57                   	push   %edi
 2e2:	56                   	push   %esi
 2e3:	53                   	push   %ebx
 2e4:	83 ec 3c             	sub    $0x3c,%esp
 2e7:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2ed:	74 14                	je     303 <printint+0x25>
 2ef:	85 d2                	test   %edx,%edx
 2f1:	79 10                	jns    303 <printint+0x25>
    neg = 1;
    x = -xx;
 2f3:	f7 da                	neg    %edx
    neg = 1;
 2f5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fc:	bf 00 00 00 00       	mov    $0x0,%edi
 301:	eb 0b                	jmp    30e <printint+0x30>
  neg = 0;
 303:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 30a:	eb f0                	jmp    2fc <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 30c:	89 df                	mov    %ebx,%edi
 30e:	8d 5f 01             	lea    0x1(%edi),%ebx
 311:	89 d0                	mov    %edx,%eax
 313:	ba 00 00 00 00       	mov    $0x0,%edx
 318:	f7 f1                	div    %ecx
 31a:	0f b6 92 bc 06 00 00 	movzbl 0x6bc(%edx),%edx
 321:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 325:	89 c2                	mov    %eax,%edx
 327:	85 c0                	test   %eax,%eax
 329:	75 e1                	jne    30c <printint+0x2e>
  if(neg)
 32b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 32f:	74 08                	je     339 <printint+0x5b>
    buf[i++] = '-';
 331:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 336:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 339:	83 eb 01             	sub    $0x1,%ebx
 33c:	78 22                	js     360 <printint+0x82>
  write(fd, &c, 1);
 33e:	8d 7d d7             	lea    -0x29(%ebp),%edi
 341:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 346:	88 45 d7             	mov    %al,-0x29(%ebp)
 349:	83 ec 04             	sub    $0x4,%esp
 34c:	6a 01                	push   $0x1
 34e:	57                   	push   %edi
 34f:	56                   	push   %esi
 350:	e8 01 ff ff ff       	call   256 <write>
  while(--i >= 0)
 355:	83 eb 01             	sub    $0x1,%ebx
 358:	83 c4 10             	add    $0x10,%esp
 35b:	83 fb ff             	cmp    $0xffffffff,%ebx
 35e:	75 e1                	jne    341 <printint+0x63>
    putc(fd, buf[i]);
}
 360:	8d 65 f4             	lea    -0xc(%ebp),%esp
 363:	5b                   	pop    %ebx
 364:	5e                   	pop    %esi
 365:	5f                   	pop    %edi
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 371:	8b 75 0c             	mov    0xc(%ebp),%esi
 374:	0f b6 1e             	movzbl (%esi),%ebx
 377:	84 db                	test   %bl,%bl
 379:	0f 84 b1 01 00 00    	je     530 <printf+0x1c8>
 37f:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 382:	8d 45 10             	lea    0x10(%ebp),%eax
 385:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 388:	bf 00 00 00 00       	mov    $0x0,%edi
 38d:	eb 2d                	jmp    3bc <printf+0x54>
 38f:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 392:	83 ec 04             	sub    $0x4,%esp
 395:	6a 01                	push   $0x1
 397:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 39a:	50                   	push   %eax
 39b:	ff 75 08             	pushl  0x8(%ebp)
 39e:	e8 b3 fe ff ff       	call   256 <write>
 3a3:	83 c4 10             	add    $0x10,%esp
 3a6:	eb 05                	jmp    3ad <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3a8:	83 ff 25             	cmp    $0x25,%edi
 3ab:	74 22                	je     3cf <printf+0x67>
 3ad:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 3b0:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3b4:	84 db                	test   %bl,%bl
 3b6:	0f 84 74 01 00 00    	je     530 <printf+0x1c8>
    c = fmt[i] & 0xff;
 3bc:	0f be d3             	movsbl %bl,%edx
 3bf:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c2:	85 ff                	test   %edi,%edi
 3c4:	75 e2                	jne    3a8 <printf+0x40>
      if(c == '%'){
 3c6:	83 f8 25             	cmp    $0x25,%eax
 3c9:	75 c4                	jne    38f <printf+0x27>
        state = '%';
 3cb:	89 c7                	mov    %eax,%edi
 3cd:	eb de                	jmp    3ad <printf+0x45>
      if(c == 'd'){
 3cf:	83 f8 64             	cmp    $0x64,%eax
 3d2:	74 59                	je     42d <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3d4:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3da:	83 fa 70             	cmp    $0x70,%edx
 3dd:	74 7a                	je     459 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3df:	83 f8 73             	cmp    $0x73,%eax
 3e2:	0f 84 9d 00 00 00    	je     485 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e8:	83 f8 63             	cmp    $0x63,%eax
 3eb:	0f 84 f2 00 00 00    	je     4e3 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3f1:	83 f8 25             	cmp    $0x25,%eax
 3f4:	0f 84 15 01 00 00    	je     50f <printf+0x1a7>
 3fa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3fe:	83 ec 04             	sub    $0x4,%esp
 401:	6a 01                	push   $0x1
 403:	8d 45 e7             	lea    -0x19(%ebp),%eax
 406:	50                   	push   %eax
 407:	ff 75 08             	pushl  0x8(%ebp)
 40a:	e8 47 fe ff ff       	call   256 <write>
 40f:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 412:	83 c4 0c             	add    $0xc,%esp
 415:	6a 01                	push   $0x1
 417:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 41a:	50                   	push   %eax
 41b:	ff 75 08             	pushl  0x8(%ebp)
 41e:	e8 33 fe ff ff       	call   256 <write>
 423:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 426:	bf 00 00 00 00       	mov    $0x0,%edi
 42b:	eb 80                	jmp    3ad <printf+0x45>
        printint(fd, *ap, 10, 1);
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	6a 01                	push   $0x1
 432:	b9 0a 00 00 00       	mov    $0xa,%ecx
 437:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 43a:	8b 17                	mov    (%edi),%edx
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	e8 9a fe ff ff       	call   2de <printint>
        ap++;
 444:	89 f8                	mov    %edi,%eax
 446:	83 c0 04             	add    $0x4,%eax
 449:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 44c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44f:	bf 00 00 00 00       	mov    $0x0,%edi
 454:	e9 54 ff ff ff       	jmp    3ad <printf+0x45>
        printint(fd, *ap, 16, 0);
 459:	83 ec 0c             	sub    $0xc,%esp
 45c:	6a 00                	push   $0x0
 45e:	b9 10 00 00 00       	mov    $0x10,%ecx
 463:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 466:	8b 17                	mov    (%edi),%edx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	e8 6e fe ff ff       	call   2de <printint>
        ap++;
 470:	89 f8                	mov    %edi,%eax
 472:	83 c0 04             	add    $0x4,%eax
 475:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 478:	83 c4 10             	add    $0x10,%esp
      state = 0;
 47b:	bf 00 00 00 00       	mov    $0x0,%edi
 480:	e9 28 ff ff ff       	jmp    3ad <printf+0x45>
        s = (char*)*ap;
 485:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 488:	8b 01                	mov    (%ecx),%eax
        ap++;
 48a:	83 c1 04             	add    $0x4,%ecx
 48d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 490:	85 c0                	test   %eax,%eax
 492:	74 13                	je     4a7 <printf+0x13f>
        s = (char*)*ap;
 494:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 496:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 499:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 49e:	84 c0                	test   %al,%al
 4a0:	75 0f                	jne    4b1 <printf+0x149>
 4a2:	e9 06 ff ff ff       	jmp    3ad <printf+0x45>
          s = "(null)";
 4a7:	bb b3 06 00 00       	mov    $0x6b3,%ebx
        while(*s != 0){
 4ac:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 4b1:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4b4:	89 75 d0             	mov    %esi,-0x30(%ebp)
 4b7:	8b 75 08             	mov    0x8(%ebp),%esi
 4ba:	88 45 e3             	mov    %al,-0x1d(%ebp)
 4bd:	83 ec 04             	sub    $0x4,%esp
 4c0:	6a 01                	push   $0x1
 4c2:	57                   	push   %edi
 4c3:	56                   	push   %esi
 4c4:	e8 8d fd ff ff       	call   256 <write>
          s++;
 4c9:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 4cc:	0f b6 03             	movzbl (%ebx),%eax
 4cf:	83 c4 10             	add    $0x10,%esp
 4d2:	84 c0                	test   %al,%al
 4d4:	75 e4                	jne    4ba <printf+0x152>
 4d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 4d9:	bf 00 00 00 00       	mov    $0x0,%edi
 4de:	e9 ca fe ff ff       	jmp    3ad <printf+0x45>
        putc(fd, *ap);
 4e3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4e6:	8b 07                	mov    (%edi),%eax
 4e8:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4eb:	83 ec 04             	sub    $0x4,%esp
 4ee:	6a 01                	push   $0x1
 4f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4f3:	50                   	push   %eax
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 5a fd ff ff       	call   256 <write>
        ap++;
 4fc:	83 c7 04             	add    $0x4,%edi
 4ff:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 502:	83 c4 10             	add    $0x10,%esp
      state = 0;
 505:	bf 00 00 00 00       	mov    $0x0,%edi
 50a:	e9 9e fe ff ff       	jmp    3ad <printf+0x45>
 50f:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 512:	83 ec 04             	sub    $0x4,%esp
 515:	6a 01                	push   $0x1
 517:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 51a:	50                   	push   %eax
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 33 fd ff ff       	call   256 <write>
 523:	83 c4 10             	add    $0x10,%esp
      state = 0;
 526:	bf 00 00 00 00       	mov    $0x0,%edi
 52b:	e9 7d fe ff ff       	jmp    3ad <printf+0x45>
    }
  }
}
 530:	8d 65 f4             	lea    -0xc(%ebp),%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    

00000538 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 538:	55                   	push   %ebp
 539:	89 e5                	mov    %esp,%ebp
 53b:	57                   	push   %edi
 53c:	56                   	push   %esi
 53d:	53                   	push   %ebx
 53e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 541:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 544:	a1 30 09 00 00       	mov    0x930,%eax
 549:	eb 0c                	jmp    557 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 54b:	8b 10                	mov    (%eax),%edx
 54d:	39 c2                	cmp    %eax,%edx
 54f:	77 04                	ja     555 <free+0x1d>
 551:	39 ca                	cmp    %ecx,%edx
 553:	77 10                	ja     565 <free+0x2d>
{
 555:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 557:	39 c8                	cmp    %ecx,%eax
 559:	73 f0                	jae    54b <free+0x13>
 55b:	8b 10                	mov    (%eax),%edx
 55d:	39 ca                	cmp    %ecx,%edx
 55f:	77 04                	ja     565 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 561:	39 c2                	cmp    %eax,%edx
 563:	77 f0                	ja     555 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 565:	8b 73 fc             	mov    -0x4(%ebx),%esi
 568:	8b 10                	mov    (%eax),%edx
 56a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56d:	39 fa                	cmp    %edi,%edx
 56f:	74 19                	je     58a <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 571:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 574:	8b 50 04             	mov    0x4(%eax),%edx
 577:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 57a:	39 f1                	cmp    %esi,%ecx
 57c:	74 1b                	je     599 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 57e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 580:	a3 30 09 00 00       	mov    %eax,0x930
}
 585:	5b                   	pop    %ebx
 586:	5e                   	pop    %esi
 587:	5f                   	pop    %edi
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 58a:	03 72 04             	add    0x4(%edx),%esi
 58d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 590:	8b 10                	mov    (%eax),%edx
 592:	8b 12                	mov    (%edx),%edx
 594:	89 53 f8             	mov    %edx,-0x8(%ebx)
 597:	eb db                	jmp    574 <free+0x3c>
    p->s.size += bp->s.size;
 599:	03 53 fc             	add    -0x4(%ebx),%edx
 59c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 59f:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5a2:	89 10                	mov    %edx,(%eax)
 5a4:	eb da                	jmp    580 <free+0x48>

000005a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5a6:	55                   	push   %ebp
 5a7:	89 e5                	mov    %esp,%ebp
 5a9:	57                   	push   %edi
 5aa:	56                   	push   %esi
 5ab:	53                   	push   %ebx
 5ac:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	8d 58 07             	lea    0x7(%eax),%ebx
 5b5:	c1 eb 03             	shr    $0x3,%ebx
 5b8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5bb:	8b 15 30 09 00 00    	mov    0x930,%edx
 5c1:	85 d2                	test   %edx,%edx
 5c3:	74 20                	je     5e5 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c7:	8b 48 04             	mov    0x4(%eax),%ecx
 5ca:	39 cb                	cmp    %ecx,%ebx
 5cc:	76 3c                	jbe    60a <malloc+0x64>
 5ce:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5d4:	be 00 10 00 00       	mov    $0x1000,%esi
 5d9:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 5dc:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 5e3:	eb 70                	jmp    655 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 5e5:	c7 05 30 09 00 00 34 	movl   $0x934,0x930
 5ec:	09 00 00 
 5ef:	c7 05 34 09 00 00 34 	movl   $0x934,0x934
 5f6:	09 00 00 
    base.s.size = 0;
 5f9:	c7 05 38 09 00 00 00 	movl   $0x0,0x938
 600:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 603:	ba 34 09 00 00       	mov    $0x934,%edx
 608:	eb bb                	jmp    5c5 <malloc+0x1f>
      if(p->s.size == nunits)
 60a:	39 cb                	cmp    %ecx,%ebx
 60c:	74 1c                	je     62a <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 60e:	29 d9                	sub    %ebx,%ecx
 610:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 613:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 616:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 619:	89 15 30 09 00 00    	mov    %edx,0x930
      return (void*)(p + 1);
 61f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 622:	8d 65 f4             	lea    -0xc(%ebp),%esp
 625:	5b                   	pop    %ebx
 626:	5e                   	pop    %esi
 627:	5f                   	pop    %edi
 628:	5d                   	pop    %ebp
 629:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 62a:	8b 08                	mov    (%eax),%ecx
 62c:	89 0a                	mov    %ecx,(%edx)
 62e:	eb e9                	jmp    619 <malloc+0x73>
  hp->s.size = nu;
 630:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	83 c0 08             	add    $0x8,%eax
 639:	50                   	push   %eax
 63a:	e8 f9 fe ff ff       	call   538 <free>
  return freep;
 63f:	8b 15 30 09 00 00    	mov    0x930,%edx
      if((p = morecore(nunits)) == 0)
 645:	83 c4 10             	add    $0x10,%esp
 648:	85 d2                	test   %edx,%edx
 64a:	74 2b                	je     677 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 64e:	8b 48 04             	mov    0x4(%eax),%ecx
 651:	39 d9                	cmp    %ebx,%ecx
 653:	73 b5                	jae    60a <malloc+0x64>
 655:	89 c2                	mov    %eax,%edx
    if(p == freep)
 657:	39 05 30 09 00 00    	cmp    %eax,0x930
 65d:	75 ed                	jne    64c <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 65f:	83 ec 0c             	sub    $0xc,%esp
 662:	57                   	push   %edi
 663:	e8 56 fc ff ff       	call   2be <sbrk>
  if(p == (char*)-1)
 668:	83 c4 10             	add    $0x10,%esp
 66b:	83 f8 ff             	cmp    $0xffffffff,%eax
 66e:	75 c0                	jne    630 <malloc+0x8a>
        return 0;
 670:	b8 00 00 00 00       	mov    $0x0,%eax
 675:	eb ab                	jmp    622 <malloc+0x7c>
 677:	b8 00 00 00 00       	mov    $0x0,%eax
 67c:	eb a4                	jmp    622 <malloc+0x7c>
