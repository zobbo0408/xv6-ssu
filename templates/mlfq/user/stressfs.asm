
user/_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1e:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  25:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2b:	68 1c 07 00 00       	push   $0x71c
  30:	6a 01                	push   $0x1
  32:	e8 cc 03 00 00       	call   403 <printf>
  memset(data, 'a', sizeof(data));
  37:	83 c4 0c             	add    $0xc,%esp
  3a:	68 00 02 00 00       	push   $0x200
  3f:	6a 61                	push   $0x61
  41:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  47:	50                   	push   %eax
  48:	e8 37 01 00 00       	call   184 <memset>
  4d:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  50:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(fork() > 0)
  55:	e8 6f 02 00 00       	call   2c9 <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 08                	jg     66 <main+0x66>
  for(i = 0; i < 4; i++)
  5e:	83 c3 01             	add    $0x1,%ebx
  61:	83 fb 04             	cmp    $0x4,%ebx
  64:	75 ef                	jne    55 <main+0x55>
      break;

  printf(1, "write %d\n", i);
  66:	83 ec 04             	sub    $0x4,%esp
  69:	53                   	push   %ebx
  6a:	68 2f 07 00 00       	push   $0x72f
  6f:	6a 01                	push   $0x1
  71:	e8 8d 03 00 00       	call   403 <printf>

  path[8] += i;
  76:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  79:	83 c4 08             	add    $0x8,%esp
  7c:	68 02 02 00 00       	push   $0x202
  81:	8d 45 de             	lea    -0x22(%ebp),%eax
  84:	50                   	push   %eax
  85:	e8 87 02 00 00       	call   311 <open>
  8a:	89 c6                	mov    %eax,%esi
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	68 00 02 00 00       	push   $0x200
  a2:	57                   	push   %edi
  a3:	56                   	push   %esi
  a4:	e8 48 02 00 00       	call   2f1 <write>
  for(i = 0; i < 20; i++)
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	83 eb 01             	sub    $0x1,%ebx
  af:	75 e9                	jne    9a <main+0x9a>
  close(fd);
  b1:	83 ec 0c             	sub    $0xc,%esp
  b4:	56                   	push   %esi
  b5:	e8 3f 02 00 00       	call   2f9 <close>

  printf(1, "read\n");
  ba:	83 c4 08             	add    $0x8,%esp
  bd:	68 39 07 00 00       	push   $0x739
  c2:	6a 01                	push   $0x1
  c4:	e8 3a 03 00 00       	call   403 <printf>

  fd = open(path, O_RDONLY);
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	6a 00                	push   $0x0
  ce:	8d 45 de             	lea    -0x22(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	e8 3a 02 00 00       	call   311 <open>
  d7:	89 c6                	mov    %eax,%esi
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e1:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	68 00 02 00 00       	push   $0x200
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	e8 f3 01 00 00       	call   2e9 <read>
  for (i = 0; i < 20; i++)
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	83 eb 01             	sub    $0x1,%ebx
  fc:	75 e9                	jne    e7 <main+0xe7>
  close(fd);
  fe:	83 ec 0c             	sub    $0xc,%esp
 101:	56                   	push   %esi
 102:	e8 f2 01 00 00       	call   2f9 <close>

  wait();
 107:	e8 cd 01 00 00       	call   2d9 <wait>

  exit();
 10c:	e8 c0 01 00 00       	call   2d1 <exit>

00000111 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	53                   	push   %ebx
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11b:	89 c2                	mov    %eax,%edx
 11d:	83 c1 01             	add    $0x1,%ecx
 120:	83 c2 01             	add    $0x1,%edx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	88 5a ff             	mov    %bl,-0x1(%edx)
 12a:	84 db                	test   %bl,%bl
 12c:	75 ef                	jne    11d <strcpy+0xc>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	8b 4d 08             	mov    0x8(%ebp),%ecx
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13a:	0f b6 01             	movzbl (%ecx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	74 15                	je     156 <strcmp+0x25>
 141:	3a 02                	cmp    (%edx),%al
 143:	75 11                	jne    156 <strcmp+0x25>
    p++, q++;
 145:	83 c1 01             	add    $0x1,%ecx
 148:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 14b:	0f b6 01             	movzbl (%ecx),%eax
 14e:	84 c0                	test   %al,%al
 150:	74 04                	je     156 <strcmp+0x25>
 152:	3a 02                	cmp    (%edx),%al
 154:	74 ef                	je     145 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 156:	0f b6 c0             	movzbl %al,%eax
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	29 d0                	sub    %edx,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 12                	je     17d <strlen+0x1d>
 16b:	ba 00 00 00 00       	mov    $0x0,%edx
 170:	83 c2 01             	add    $0x1,%edx
 173:	89 d0                	mov    %edx,%eax
 175:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 182:	eb f7                	jmp    17b <strlen+0x1b>

00000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18b:	89 d7                	mov    %edx,%edi
 18d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	fc                   	cld    
 194:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 196:	89 d0                	mov    %edx,%eax
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strchr>:

char*
strchr(const char *s, char c)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	53                   	push   %ebx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1a5:	0f b6 10             	movzbl (%eax),%edx
 1a8:	84 d2                	test   %dl,%dl
 1aa:	74 1e                	je     1ca <strchr+0x2f>
 1ac:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 1ae:	38 d3                	cmp    %dl,%bl
 1b0:	74 15                	je     1c7 <strchr+0x2c>
  for(; *s; s++)
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	0f b6 10             	movzbl (%eax),%edx
 1b8:	84 d2                	test   %dl,%dl
 1ba:	74 06                	je     1c2 <strchr+0x27>
    if(*s == c)
 1bc:	38 ca                	cmp    %cl,%dl
 1be:	75 f2                	jne    1b2 <strchr+0x17>
 1c0:	eb 05                	jmp    1c7 <strchr+0x2c>
      return (char*)s;
  return 0;
 1c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c7:	5b                   	pop    %ebx
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
  return 0;
 1ca:	b8 00 00 00 00       	mov    $0x0,%eax
 1cf:	eb f6                	jmp    1c7 <strchr+0x2c>

000001d1 <gets>:

char*
gets(char *buf, int max)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1df:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e2:	8d 5e 01             	lea    0x1(%esi),%ebx
 1e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e8:	7d 2b                	jge    215 <gets+0x44>
    cc = read(0, &c, 1);
 1ea:	83 ec 04             	sub    $0x4,%esp
 1ed:	6a 01                	push   $0x1
 1ef:	57                   	push   %edi
 1f0:	6a 00                	push   $0x0
 1f2:	e8 f2 00 00 00       	call   2e9 <read>
    if(cc < 1)
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	85 c0                	test   %eax,%eax
 1fc:	7e 17                	jle    215 <gets+0x44>
      break;
    buf[i++] = c;
 1fe:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 202:	8b 55 08             	mov    0x8(%ebp),%edx
 205:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 209:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 20b:	3c 0a                	cmp    $0xa,%al
 20d:	74 04                	je     213 <gets+0x42>
 20f:	3c 0d                	cmp    $0xd,%al
 211:	75 cf                	jne    1e2 <gets+0x11>
  for(i=0; i+1 < max; ){
 213:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 21c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21f:	5b                   	pop    %ebx
 220:	5e                   	pop    %esi
 221:	5f                   	pop    %edi
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    

00000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	56                   	push   %esi
 228:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	6a 00                	push   $0x0
 22e:	ff 75 08             	pushl  0x8(%ebp)
 231:	e8 db 00 00 00       	call   311 <open>
  if(fd < 0)
 236:	83 c4 10             	add    $0x10,%esp
 239:	85 c0                	test   %eax,%eax
 23b:	78 24                	js     261 <stat+0x3d>
 23d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	ff 75 0c             	pushl  0xc(%ebp)
 245:	50                   	push   %eax
 246:	e8 de 00 00 00       	call   329 <fstat>
 24b:	89 c6                	mov    %eax,%esi
  close(fd);
 24d:	89 1c 24             	mov    %ebx,(%esp)
 250:	e8 a4 00 00 00       	call   2f9 <close>
  return r;
 255:	83 c4 10             	add    $0x10,%esp
}
 258:	89 f0                	mov    %esi,%eax
 25a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 25d:	5b                   	pop    %ebx
 25e:	5e                   	pop    %esi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
    return -1;
 261:	be ff ff ff ff       	mov    $0xffffffff,%esi
 266:	eb f0                	jmp    258 <stat+0x34>

00000268 <atoi>:

int
atoi(const char *s)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	53                   	push   %ebx
 26c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26f:	0f b6 11             	movzbl (%ecx),%edx
 272:	8d 42 d0             	lea    -0x30(%edx),%eax
 275:	3c 09                	cmp    $0x9,%al
 277:	77 20                	ja     299 <atoi+0x31>
  n = 0;
 279:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 27e:	83 c1 01             	add    $0x1,%ecx
 281:	8d 04 80             	lea    (%eax,%eax,4),%eax
 284:	0f be d2             	movsbl %dl,%edx
 287:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 28b:	0f b6 11             	movzbl (%ecx),%edx
 28e:	8d 5a d0             	lea    -0x30(%edx),%ebx
 291:	80 fb 09             	cmp    $0x9,%bl
 294:	76 e8                	jbe    27e <atoi+0x16>
  return n;
}
 296:	5b                   	pop    %ebx
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    
  n = 0;
 299:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 29e:	eb f6                	jmp    296 <atoi+0x2e>

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 db                	test   %ebx,%ebx
 2b0:	7e 13                	jle    2c5 <memmove+0x25>
 2b2:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2b7:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2be:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c1:	39 d3                	cmp    %edx,%ebx
 2c3:	75 f2                	jne    2b7 <memmove+0x17>
  return vdst;
}
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <exit>:
SYSCALL(exit)
 2d1:	b8 02 00 00 00       	mov    $0x2,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <wait>:
SYSCALL(wait)
 2d9:	b8 03 00 00 00       	mov    $0x3,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <pipe>:
SYSCALL(pipe)
 2e1:	b8 04 00 00 00       	mov    $0x4,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <read>:
SYSCALL(read)
 2e9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <write>:
SYSCALL(write)
 2f1:	b8 10 00 00 00       	mov    $0x10,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <close>:
SYSCALL(close)
 2f9:	b8 15 00 00 00       	mov    $0x15,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <kill>:
SYSCALL(kill)
 301:	b8 06 00 00 00       	mov    $0x6,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <exec>:
SYSCALL(exec)
 309:	b8 07 00 00 00       	mov    $0x7,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <open>:
SYSCALL(open)
 311:	b8 0f 00 00 00       	mov    $0xf,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mknod>:
SYSCALL(mknod)
 319:	b8 11 00 00 00       	mov    $0x11,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <unlink>:
SYSCALL(unlink)
 321:	b8 12 00 00 00       	mov    $0x12,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <fstat>:
SYSCALL(fstat)
 329:	b8 08 00 00 00       	mov    $0x8,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <link>:
SYSCALL(link)
 331:	b8 13 00 00 00       	mov    $0x13,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mkdir>:
SYSCALL(mkdir)
 339:	b8 14 00 00 00       	mov    $0x14,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <chdir>:
SYSCALL(chdir)
 341:	b8 09 00 00 00       	mov    $0x9,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <dup>:
SYSCALL(dup)
 349:	b8 0a 00 00 00       	mov    $0xa,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <getpid>:
SYSCALL(getpid)
 351:	b8 0b 00 00 00       	mov    $0xb,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sbrk>:
SYSCALL(sbrk)
 359:	b8 0c 00 00 00       	mov    $0xc,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <sleep>:
SYSCALL(sleep)
 361:	b8 0d 00 00 00       	mov    $0xd,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <uptime>:
SYSCALL(uptime)
 369:	b8 0e 00 00 00       	mov    $0xe,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getlevel>:
SYSCALL(getlevel)
 371:	b8 16 00 00 00       	mov    $0x16,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	57                   	push   %edi
 37d:	56                   	push   %esi
 37e:	53                   	push   %ebx
 37f:	83 ec 3c             	sub    $0x3c,%esp
 382:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 388:	74 14                	je     39e <printint+0x25>
 38a:	85 d2                	test   %edx,%edx
 38c:	79 10                	jns    39e <printint+0x25>
    neg = 1;
    x = -xx;
 38e:	f7 da                	neg    %edx
    neg = 1;
 390:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 397:	bf 00 00 00 00       	mov    $0x0,%edi
 39c:	eb 0b                	jmp    3a9 <printint+0x30>
  neg = 0;
 39e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3a5:	eb f0                	jmp    397 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3a7:	89 df                	mov    %ebx,%edi
 3a9:	8d 5f 01             	lea    0x1(%edi),%ebx
 3ac:	89 d0                	mov    %edx,%eax
 3ae:	ba 00 00 00 00       	mov    $0x0,%edx
 3b3:	f7 f1                	div    %ecx
 3b5:	0f b6 92 48 07 00 00 	movzbl 0x748(%edx),%edx
 3bc:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3c0:	89 c2                	mov    %eax,%edx
 3c2:	85 c0                	test   %eax,%eax
 3c4:	75 e1                	jne    3a7 <printint+0x2e>
  if(neg)
 3c6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3ca:	74 08                	je     3d4 <printint+0x5b>
    buf[i++] = '-';
 3cc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3d1:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3d4:	83 eb 01             	sub    $0x1,%ebx
 3d7:	78 22                	js     3fb <printint+0x82>
  write(fd, &c, 1);
 3d9:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3dc:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3e1:	88 45 d7             	mov    %al,-0x29(%ebp)
 3e4:	83 ec 04             	sub    $0x4,%esp
 3e7:	6a 01                	push   $0x1
 3e9:	57                   	push   %edi
 3ea:	56                   	push   %esi
 3eb:	e8 01 ff ff ff       	call   2f1 <write>
  while(--i >= 0)
 3f0:	83 eb 01             	sub    $0x1,%ebx
 3f3:	83 c4 10             	add    $0x10,%esp
 3f6:	83 fb ff             	cmp    $0xffffffff,%ebx
 3f9:	75 e1                	jne    3dc <printint+0x63>
    putc(fd, buf[i]);
}
 3fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fe:	5b                   	pop    %ebx
 3ff:	5e                   	pop    %esi
 400:	5f                   	pop    %edi
 401:	5d                   	pop    %ebp
 402:	c3                   	ret    

00000403 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	57                   	push   %edi
 407:	56                   	push   %esi
 408:	53                   	push   %ebx
 409:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 40c:	8b 75 0c             	mov    0xc(%ebp),%esi
 40f:	0f b6 1e             	movzbl (%esi),%ebx
 412:	84 db                	test   %bl,%bl
 414:	0f 84 b1 01 00 00    	je     5cb <printf+0x1c8>
 41a:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 41d:	8d 45 10             	lea    0x10(%ebp),%eax
 420:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 423:	bf 00 00 00 00       	mov    $0x0,%edi
 428:	eb 2d                	jmp    457 <printf+0x54>
 42a:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 42d:	83 ec 04             	sub    $0x4,%esp
 430:	6a 01                	push   $0x1
 432:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 435:	50                   	push   %eax
 436:	ff 75 08             	pushl  0x8(%ebp)
 439:	e8 b3 fe ff ff       	call   2f1 <write>
 43e:	83 c4 10             	add    $0x10,%esp
 441:	eb 05                	jmp    448 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 443:	83 ff 25             	cmp    $0x25,%edi
 446:	74 22                	je     46a <printf+0x67>
 448:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 44b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 44f:	84 db                	test   %bl,%bl
 451:	0f 84 74 01 00 00    	je     5cb <printf+0x1c8>
    c = fmt[i] & 0xff;
 457:	0f be d3             	movsbl %bl,%edx
 45a:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45d:	85 ff                	test   %edi,%edi
 45f:	75 e2                	jne    443 <printf+0x40>
      if(c == '%'){
 461:	83 f8 25             	cmp    $0x25,%eax
 464:	75 c4                	jne    42a <printf+0x27>
        state = '%';
 466:	89 c7                	mov    %eax,%edi
 468:	eb de                	jmp    448 <printf+0x45>
      if(c == 'd'){
 46a:	83 f8 64             	cmp    $0x64,%eax
 46d:	74 59                	je     4c8 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46f:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 475:	83 fa 70             	cmp    $0x70,%edx
 478:	74 7a                	je     4f4 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 47a:	83 f8 73             	cmp    $0x73,%eax
 47d:	0f 84 9d 00 00 00    	je     520 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 483:	83 f8 63             	cmp    $0x63,%eax
 486:	0f 84 f2 00 00 00    	je     57e <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 48c:	83 f8 25             	cmp    $0x25,%eax
 48f:	0f 84 15 01 00 00    	je     5aa <printf+0x1a7>
 495:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 499:	83 ec 04             	sub    $0x4,%esp
 49c:	6a 01                	push   $0x1
 49e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a1:	50                   	push   %eax
 4a2:	ff 75 08             	pushl  0x8(%ebp)
 4a5:	e8 47 fe ff ff       	call   2f1 <write>
 4aa:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4ad:	83 c4 0c             	add    $0xc,%esp
 4b0:	6a 01                	push   $0x1
 4b2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 33 fe ff ff       	call   2f1 <write>
 4be:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c1:	bf 00 00 00 00       	mov    $0x0,%edi
 4c6:	eb 80                	jmp    448 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4c8:	83 ec 0c             	sub    $0xc,%esp
 4cb:	6a 01                	push   $0x1
 4cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d5:	8b 17                	mov    (%edi),%edx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	e8 9a fe ff ff       	call   379 <printint>
        ap++;
 4df:	89 f8                	mov    %edi,%eax
 4e1:	83 c0 04             	add    $0x4,%eax
 4e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4e7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ea:	bf 00 00 00 00       	mov    $0x0,%edi
 4ef:	e9 54 ff ff ff       	jmp    448 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4f4:	83 ec 0c             	sub    $0xc,%esp
 4f7:	6a 00                	push   $0x0
 4f9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fe:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 501:	8b 17                	mov    (%edi),%edx
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	e8 6e fe ff ff       	call   379 <printint>
        ap++;
 50b:	89 f8                	mov    %edi,%eax
 50d:	83 c0 04             	add    $0x4,%eax
 510:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 513:	83 c4 10             	add    $0x10,%esp
      state = 0;
 516:	bf 00 00 00 00       	mov    $0x0,%edi
 51b:	e9 28 ff ff ff       	jmp    448 <printf+0x45>
        s = (char*)*ap;
 520:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 523:	8b 01                	mov    (%ecx),%eax
        ap++;
 525:	83 c1 04             	add    $0x4,%ecx
 528:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 52b:	85 c0                	test   %eax,%eax
 52d:	74 13                	je     542 <printf+0x13f>
        s = (char*)*ap;
 52f:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 531:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 534:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 539:	84 c0                	test   %al,%al
 53b:	75 0f                	jne    54c <printf+0x149>
 53d:	e9 06 ff ff ff       	jmp    448 <printf+0x45>
          s = "(null)";
 542:	bb 3f 07 00 00       	mov    $0x73f,%ebx
        while(*s != 0){
 547:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 54c:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 54f:	89 75 d0             	mov    %esi,-0x30(%ebp)
 552:	8b 75 08             	mov    0x8(%ebp),%esi
 555:	88 45 e3             	mov    %al,-0x1d(%ebp)
 558:	83 ec 04             	sub    $0x4,%esp
 55b:	6a 01                	push   $0x1
 55d:	57                   	push   %edi
 55e:	56                   	push   %esi
 55f:	e8 8d fd ff ff       	call   2f1 <write>
          s++;
 564:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 567:	0f b6 03             	movzbl (%ebx),%eax
 56a:	83 c4 10             	add    $0x10,%esp
 56d:	84 c0                	test   %al,%al
 56f:	75 e4                	jne    555 <printf+0x152>
 571:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 574:	bf 00 00 00 00       	mov    $0x0,%edi
 579:	e9 ca fe ff ff       	jmp    448 <printf+0x45>
        putc(fd, *ap);
 57e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 581:	8b 07                	mov    (%edi),%eax
 583:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 586:	83 ec 04             	sub    $0x4,%esp
 589:	6a 01                	push   $0x1
 58b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 58e:	50                   	push   %eax
 58f:	ff 75 08             	pushl  0x8(%ebp)
 592:	e8 5a fd ff ff       	call   2f1 <write>
        ap++;
 597:	83 c7 04             	add    $0x4,%edi
 59a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 59d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a0:	bf 00 00 00 00       	mov    $0x0,%edi
 5a5:	e9 9e fe ff ff       	jmp    448 <printf+0x45>
 5aa:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5ad:	83 ec 04             	sub    $0x4,%esp
 5b0:	6a 01                	push   $0x1
 5b2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 33 fd ff ff       	call   2f1 <write>
 5be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c1:	bf 00 00 00 00       	mov    $0x0,%edi
 5c6:	e9 7d fe ff ff       	jmp    448 <printf+0x45>
    }
  }
}
 5cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ce:	5b                   	pop    %ebx
 5cf:	5e                   	pop    %esi
 5d0:	5f                   	pop    %edi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret    

000005d3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d3:	55                   	push   %ebp
 5d4:	89 e5                	mov    %esp,%ebp
 5d6:	57                   	push   %edi
 5d7:	56                   	push   %esi
 5d8:	53                   	push   %ebx
 5d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5dc:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5df:	a1 bc 09 00 00       	mov    0x9bc,%eax
 5e4:	eb 0c                	jmp    5f2 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	39 c2                	cmp    %eax,%edx
 5ea:	77 04                	ja     5f0 <free+0x1d>
 5ec:	39 ca                	cmp    %ecx,%edx
 5ee:	77 10                	ja     600 <free+0x2d>
{
 5f0:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f2:	39 c8                	cmp    %ecx,%eax
 5f4:	73 f0                	jae    5e6 <free+0x13>
 5f6:	8b 10                	mov    (%eax),%edx
 5f8:	39 ca                	cmp    %ecx,%edx
 5fa:	77 04                	ja     600 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fc:	39 c2                	cmp    %eax,%edx
 5fe:	77 f0                	ja     5f0 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 600:	8b 73 fc             	mov    -0x4(%ebx),%esi
 603:	8b 10                	mov    (%eax),%edx
 605:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 608:	39 fa                	cmp    %edi,%edx
 60a:	74 19                	je     625 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 60c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 60f:	8b 50 04             	mov    0x4(%eax),%edx
 612:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 615:	39 f1                	cmp    %esi,%ecx
 617:	74 1b                	je     634 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 619:	89 08                	mov    %ecx,(%eax)
  freep = p;
 61b:	a3 bc 09 00 00       	mov    %eax,0x9bc
}
 620:	5b                   	pop    %ebx
 621:	5e                   	pop    %esi
 622:	5f                   	pop    %edi
 623:	5d                   	pop    %ebp
 624:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 625:	03 72 04             	add    0x4(%edx),%esi
 628:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 62b:	8b 10                	mov    (%eax),%edx
 62d:	8b 12                	mov    (%edx),%edx
 62f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 632:	eb db                	jmp    60f <free+0x3c>
    p->s.size += bp->s.size;
 634:	03 53 fc             	add    -0x4(%ebx),%edx
 637:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 63a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 63d:	89 10                	mov    %edx,(%eax)
 63f:	eb da                	jmp    61b <free+0x48>

00000641 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	57                   	push   %edi
 645:	56                   	push   %esi
 646:	53                   	push   %ebx
 647:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
 64d:	8d 58 07             	lea    0x7(%eax),%ebx
 650:	c1 eb 03             	shr    $0x3,%ebx
 653:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 656:	8b 15 bc 09 00 00    	mov    0x9bc,%edx
 65c:	85 d2                	test   %edx,%edx
 65e:	74 20                	je     680 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 660:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 662:	8b 48 04             	mov    0x4(%eax),%ecx
 665:	39 cb                	cmp    %ecx,%ebx
 667:	76 3c                	jbe    6a5 <malloc+0x64>
 669:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 66f:	be 00 10 00 00       	mov    $0x1000,%esi
 674:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 677:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 67e:	eb 70                	jmp    6f0 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 680:	c7 05 bc 09 00 00 c0 	movl   $0x9c0,0x9bc
 687:	09 00 00 
 68a:	c7 05 c0 09 00 00 c0 	movl   $0x9c0,0x9c0
 691:	09 00 00 
    base.s.size = 0;
 694:	c7 05 c4 09 00 00 00 	movl   $0x0,0x9c4
 69b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 69e:	ba c0 09 00 00       	mov    $0x9c0,%edx
 6a3:	eb bb                	jmp    660 <malloc+0x1f>
      if(p->s.size == nunits)
 6a5:	39 cb                	cmp    %ecx,%ebx
 6a7:	74 1c                	je     6c5 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6a9:	29 d9                	sub    %ebx,%ecx
 6ab:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ae:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6b1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6b4:	89 15 bc 09 00 00    	mov    %edx,0x9bc
      return (void*)(p + 1);
 6ba:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c0:	5b                   	pop    %ebx
 6c1:	5e                   	pop    %esi
 6c2:	5f                   	pop    %edi
 6c3:	5d                   	pop    %ebp
 6c4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6c5:	8b 08                	mov    (%eax),%ecx
 6c7:	89 0a                	mov    %ecx,(%edx)
 6c9:	eb e9                	jmp    6b4 <malloc+0x73>
  hp->s.size = nu;
 6cb:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6ce:	83 ec 0c             	sub    $0xc,%esp
 6d1:	83 c0 08             	add    $0x8,%eax
 6d4:	50                   	push   %eax
 6d5:	e8 f9 fe ff ff       	call   5d3 <free>
  return freep;
 6da:	8b 15 bc 09 00 00    	mov    0x9bc,%edx
      if((p = morecore(nunits)) == 0)
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	85 d2                	test   %edx,%edx
 6e5:	74 2b                	je     712 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6e9:	8b 48 04             	mov    0x4(%eax),%ecx
 6ec:	39 d9                	cmp    %ebx,%ecx
 6ee:	73 b5                	jae    6a5 <malloc+0x64>
 6f0:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6f2:	39 05 bc 09 00 00    	cmp    %eax,0x9bc
 6f8:	75 ed                	jne    6e7 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6fa:	83 ec 0c             	sub    $0xc,%esp
 6fd:	57                   	push   %edi
 6fe:	e8 56 fc ff ff       	call   359 <sbrk>
  if(p == (char*)-1)
 703:	83 c4 10             	add    $0x10,%esp
 706:	83 f8 ff             	cmp    $0xffffffff,%eax
 709:	75 c0                	jne    6cb <malloc+0x8a>
        return 0;
 70b:	b8 00 00 00 00       	mov    $0x0,%eax
 710:	eb ab                	jmp    6bd <malloc+0x7c>
 712:	b8 00 00 00 00       	mov    $0x0,%eax
 717:	eb a4                	jmp    6bd <malloc+0x7c>
