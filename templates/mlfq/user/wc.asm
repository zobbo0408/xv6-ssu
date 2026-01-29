
user/_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1e:	be 00 00 00 00       	mov    $0x0,%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	eb 4d                	jmp    72 <wc+0x72>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
  25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  29:	75 0b                	jne    36 <wc+0x36>
        w++;
  2b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
  2f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  36:	83 c3 01             	add    $0x1,%ebx
  39:	39 df                	cmp    %ebx,%edi
  3b:	74 32                	je     6f <wc+0x6f>
      if(buf[i] == '\n')
  3d:	0f b6 83 80 0a 00 00 	movzbl 0xa80(%ebx),%eax
        l++;
  44:	3c 0a                	cmp    $0xa,%al
  46:	0f 94 c2             	sete   %dl
  49:	0f b6 d2             	movzbl %dl,%edx
  4c:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
  4e:	83 ec 08             	sub    $0x8,%esp
  51:	0f be c0             	movsbl %al,%eax
  54:	50                   	push   %eax
  55:	68 70 07 00 00       	push   $0x770
  5a:	e8 92 01 00 00       	call   1f1 <strchr>
  5f:	83 c4 10             	add    $0x10,%esp
  62:	85 c0                	test   %eax,%eax
  64:	74 bf                	je     25 <wc+0x25>
        inword = 0;
  66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6d:	eb c7                	jmp    36 <wc+0x36>
  6f:	01 5d dc             	add    %ebx,-0x24(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	83 ec 04             	sub    $0x4,%esp
  75:	68 00 02 00 00       	push   $0x200
  7a:	68 80 0a 00 00       	push   $0xa80
  7f:	ff 75 08             	pushl  0x8(%ebp)
  82:	e8 b8 02 00 00       	call   33f <read>
  87:	89 c7                	mov    %eax,%edi
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	7e 07                	jle    97 <wc+0x97>
    for(i=0; i<n; i++){
  90:	bb 00 00 00 00       	mov    $0x0,%ebx
  95:	eb a6                	jmp    3d <wc+0x3d>
      }
    }
  }
  if(n < 0){
  97:	85 c0                	test   %eax,%eax
  99:	78 24                	js     bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	ff 75 0c             	pushl  0xc(%ebp)
  a1:	ff 75 dc             	pushl  -0x24(%ebp)
  a4:	ff 75 e0             	pushl  -0x20(%ebp)
  a7:	56                   	push   %esi
  a8:	68 86 07 00 00       	push   $0x786
  ad:	6a 01                	push   $0x1
  af:	e8 a5 03 00 00       	call   459 <printf>
}
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ba:	5b                   	pop    %ebx
  bb:	5e                   	pop    %esi
  bc:	5f                   	pop    %edi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
    printf(1, "wc: read error\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 76 07 00 00       	push   $0x776
  c7:	6a 01                	push   $0x1
  c9:	e8 8b 03 00 00       	call   459 <printf>
    exit();
  ce:	e8 54 02 00 00       	call   327 <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d7:	83 e4 f0             	and    $0xfffffff0,%esp
  da:	ff 71 fc             	pushl  -0x4(%ecx)
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	57                   	push   %edi
  e1:	56                   	push   %esi
  e2:	53                   	push   %ebx
  e3:	51                   	push   %ecx
  e4:	83 ec 18             	sub    $0x18,%esp
  e7:	8b 01                	mov    (%ecx),%eax
  e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ec:	8b 59 04             	mov    0x4(%ecx),%ebx
  ef:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f2:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  f7:	83 f8 01             	cmp    $0x1,%eax
  fa:	7e 3e                	jle    13a <main+0x67>
    if((fd = open(argv[i], 0)) < 0){
  fc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	6a 00                	push   $0x0
 104:	ff 33                	pushl  (%ebx)
 106:	e8 5c 02 00 00       	call   367 <open>
 10b:	89 c6                	mov    %eax,%esi
 10d:	83 c4 10             	add    $0x10,%esp
 110:	85 c0                	test   %eax,%eax
 112:	78 3a                	js     14e <main+0x7b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 114:	83 ec 08             	sub    $0x8,%esp
 117:	ff 33                	pushl  (%ebx)
 119:	50                   	push   %eax
 11a:	e8 e1 fe ff ff       	call   0 <wc>
    close(fd);
 11f:	89 34 24             	mov    %esi,(%esp)
 122:	e8 28 02 00 00       	call   34f <close>
  for(i = 1; i < argc; i++){
 127:	83 c7 01             	add    $0x1,%edi
 12a:	83 c3 04             	add    $0x4,%ebx
 12d:	83 c4 10             	add    $0x10,%esp
 130:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 133:	75 c7                	jne    fc <main+0x29>
  }
  exit();
 135:	e8 ed 01 00 00       	call   327 <exit>
    wc(0, "");
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	68 85 07 00 00       	push   $0x785
 142:	6a 00                	push   $0x0
 144:	e8 b7 fe ff ff       	call   0 <wc>
    exit();
 149:	e8 d9 01 00 00       	call   327 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 e0             	mov    -0x20(%ebp),%eax
 154:	ff 30                	pushl  (%eax)
 156:	68 93 07 00 00       	push   $0x793
 15b:	6a 01                	push   $0x1
 15d:	e8 f7 02 00 00       	call   459 <printf>
      exit();
 162:	e8 c0 01 00 00       	call   327 <exit>

00000167 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	53                   	push   %ebx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 171:	89 c2                	mov    %eax,%edx
 173:	83 c1 01             	add    $0x1,%ecx
 176:	83 c2 01             	add    $0x1,%edx
 179:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 17d:	88 5a ff             	mov    %bl,-0x1(%edx)
 180:	84 db                	test   %bl,%bl
 182:	75 ef                	jne    173 <strcpy+0xc>
    ;
  return os;
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    

00000187 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 190:	0f b6 01             	movzbl (%ecx),%eax
 193:	84 c0                	test   %al,%al
 195:	74 15                	je     1ac <strcmp+0x25>
 197:	3a 02                	cmp    (%edx),%al
 199:	75 11                	jne    1ac <strcmp+0x25>
    p++, q++;
 19b:	83 c1 01             	add    $0x1,%ecx
 19e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 04                	je     1ac <strcmp+0x25>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	74 ef                	je     19b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1ac:	0f b6 c0             	movzbl %al,%eax
 1af:	0f b6 12             	movzbl (%edx),%edx
 1b2:	29 d0                	sub    %edx,%eax
}
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret    

000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1bc:	80 39 00             	cmpb   $0x0,(%ecx)
 1bf:	74 12                	je     1d3 <strlen+0x1d>
 1c1:	ba 00 00 00 00       	mov    $0x0,%edx
 1c6:	83 c2 01             	add    $0x1,%edx
 1c9:	89 d0                	mov    %edx,%eax
 1cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1cf:	75 f5                	jne    1c6 <strlen+0x10>
    ;
  return n;
}
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1d8:	eb f7                	jmp    1d1 <strlen+0x1b>

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	57                   	push   %edi
 1de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e1:	89 d7                	mov    %edx,%edi
 1e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	fc                   	cld    
 1ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1ec:	89 d0                	mov    %edx,%eax
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <strchr>:

char*
strchr(const char *s, char c)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	53                   	push   %ebx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 1e                	je     220 <strchr+0x2f>
 202:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 204:	38 d3                	cmp    %dl,%bl
 206:	74 15                	je     21d <strchr+0x2c>
  for(; *s; s++)
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 06                	je     218 <strchr+0x27>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	75 f2                	jne    208 <strchr+0x17>
 216:	eb 05                	jmp    21d <strchr+0x2c>
      return (char*)s;
  return 0;
 218:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21d:	5b                   	pop    %ebx
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  return 0;
 220:	b8 00 00 00 00       	mov    $0x0,%eax
 225:	eb f6                	jmp    21d <strchr+0x2c>

00000227 <gets>:

char*
gets(char *buf, int max)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	57                   	push   %edi
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
 22d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 235:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 238:	8d 5e 01             	lea    0x1(%esi),%ebx
 23b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23e:	7d 2b                	jge    26b <gets+0x44>
    cc = read(0, &c, 1);
 240:	83 ec 04             	sub    $0x4,%esp
 243:	6a 01                	push   $0x1
 245:	57                   	push   %edi
 246:	6a 00                	push   $0x0
 248:	e8 f2 00 00 00       	call   33f <read>
    if(cc < 1)
 24d:	83 c4 10             	add    $0x10,%esp
 250:	85 c0                	test   %eax,%eax
 252:	7e 17                	jle    26b <gets+0x44>
      break;
    buf[i++] = c;
 254:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 258:	8b 55 08             	mov    0x8(%ebp),%edx
 25b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 25f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 261:	3c 0a                	cmp    $0xa,%al
 263:	74 04                	je     269 <gets+0x42>
 265:	3c 0d                	cmp    $0xd,%al
 267:	75 cf                	jne    238 <gets+0x11>
  for(i=0; i+1 < max; ){
 269:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 272:	8d 65 f4             	lea    -0xc(%ebp),%esp
 275:	5b                   	pop    %ebx
 276:	5e                   	pop    %esi
 277:	5f                   	pop    %edi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    

0000027a <stat>:

int
stat(const char *n, struct stat *st)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	56                   	push   %esi
 27e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 db 00 00 00       	call   367 <open>
  if(fd < 0)
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	85 c0                	test   %eax,%eax
 291:	78 24                	js     2b7 <stat+0x3d>
 293:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	ff 75 0c             	pushl  0xc(%ebp)
 29b:	50                   	push   %eax
 29c:	e8 de 00 00 00       	call   37f <fstat>
 2a1:	89 c6                	mov    %eax,%esi
  close(fd);
 2a3:	89 1c 24             	mov    %ebx,(%esp)
 2a6:	e8 a4 00 00 00       	call   34f <close>
  return r;
 2ab:	83 c4 10             	add    $0x10,%esp
}
 2ae:	89 f0                	mov    %esi,%eax
 2b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b3:	5b                   	pop    %ebx
 2b4:	5e                   	pop    %esi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
    return -1;
 2b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2bc:	eb f0                	jmp    2ae <stat+0x34>

000002be <atoi>:

int
atoi(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	53                   	push   %ebx
 2c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c5:	0f b6 11             	movzbl (%ecx),%edx
 2c8:	8d 42 d0             	lea    -0x30(%edx),%eax
 2cb:	3c 09                	cmp    $0x9,%al
 2cd:	77 20                	ja     2ef <atoi+0x31>
  n = 0;
 2cf:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2d4:	83 c1 01             	add    $0x1,%ecx
 2d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2da:	0f be d2             	movsbl %dl,%edx
 2dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2e1:	0f b6 11             	movzbl (%ecx),%edx
 2e4:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2e7:	80 fb 09             	cmp    $0x9,%bl
 2ea:	76 e8                	jbe    2d4 <atoi+0x16>
  return n;
}
 2ec:	5b                   	pop    %ebx
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
  n = 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 2f4:	eb f6                	jmp    2ec <atoi+0x2e>

000002f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	56                   	push   %esi
 2fa:	53                   	push   %ebx
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	8b 75 0c             	mov    0xc(%ebp),%esi
 301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 304:	85 db                	test   %ebx,%ebx
 306:	7e 13                	jle    31b <memmove+0x25>
 308:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 30d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 311:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 314:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 317:	39 d3                	cmp    %edx,%ebx
 319:	75 f2                	jne    30d <memmove+0x17>
  return vdst;
}
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    

0000031f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31f:	b8 01 00 00 00       	mov    $0x1,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <exit>:
SYSCALL(exit)
 327:	b8 02 00 00 00       	mov    $0x2,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <wait>:
SYSCALL(wait)
 32f:	b8 03 00 00 00       	mov    $0x3,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <pipe>:
SYSCALL(pipe)
 337:	b8 04 00 00 00       	mov    $0x4,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <read>:
SYSCALL(read)
 33f:	b8 05 00 00 00       	mov    $0x5,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <write>:
SYSCALL(write)
 347:	b8 10 00 00 00       	mov    $0x10,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <close>:
SYSCALL(close)
 34f:	b8 15 00 00 00       	mov    $0x15,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <kill>:
SYSCALL(kill)
 357:	b8 06 00 00 00       	mov    $0x6,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <exec>:
SYSCALL(exec)
 35f:	b8 07 00 00 00       	mov    $0x7,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <open>:
SYSCALL(open)
 367:	b8 0f 00 00 00       	mov    $0xf,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <mknod>:
SYSCALL(mknod)
 36f:	b8 11 00 00 00       	mov    $0x11,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <unlink>:
SYSCALL(unlink)
 377:	b8 12 00 00 00       	mov    $0x12,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <fstat>:
SYSCALL(fstat)
 37f:	b8 08 00 00 00       	mov    $0x8,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <link>:
SYSCALL(link)
 387:	b8 13 00 00 00       	mov    $0x13,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <mkdir>:
SYSCALL(mkdir)
 38f:	b8 14 00 00 00       	mov    $0x14,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <chdir>:
SYSCALL(chdir)
 397:	b8 09 00 00 00       	mov    $0x9,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <dup>:
SYSCALL(dup)
 39f:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <getpid>:
SYSCALL(getpid)
 3a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sbrk>:
SYSCALL(sbrk)
 3af:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <sleep>:
SYSCALL(sleep)
 3b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <uptime>:
SYSCALL(uptime)
 3bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <getlevel>:
SYSCALL(getlevel)
 3c7:	b8 16 00 00 00       	mov    $0x16,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	57                   	push   %edi
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	83 ec 3c             	sub    $0x3c,%esp
 3d8:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3de:	74 14                	je     3f4 <printint+0x25>
 3e0:	85 d2                	test   %edx,%edx
 3e2:	79 10                	jns    3f4 <printint+0x25>
    neg = 1;
    x = -xx;
 3e4:	f7 da                	neg    %edx
    neg = 1;
 3e6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3ed:	bf 00 00 00 00       	mov    $0x0,%edi
 3f2:	eb 0b                	jmp    3ff <printint+0x30>
  neg = 0;
 3f4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3fb:	eb f0                	jmp    3ed <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3fd:	89 df                	mov    %ebx,%edi
 3ff:	8d 5f 01             	lea    0x1(%edi),%ebx
 402:	89 d0                	mov    %edx,%eax
 404:	ba 00 00 00 00       	mov    $0x0,%edx
 409:	f7 f1                	div    %ecx
 40b:	0f b6 92 b0 07 00 00 	movzbl 0x7b0(%edx),%edx
 412:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 416:	89 c2                	mov    %eax,%edx
 418:	85 c0                	test   %eax,%eax
 41a:	75 e1                	jne    3fd <printint+0x2e>
  if(neg)
 41c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 420:	74 08                	je     42a <printint+0x5b>
    buf[i++] = '-';
 422:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 427:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 42a:	83 eb 01             	sub    $0x1,%ebx
 42d:	78 22                	js     451 <printint+0x82>
  write(fd, &c, 1);
 42f:	8d 7d d7             	lea    -0x29(%ebp),%edi
 432:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 437:	88 45 d7             	mov    %al,-0x29(%ebp)
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	6a 01                	push   $0x1
 43f:	57                   	push   %edi
 440:	56                   	push   %esi
 441:	e8 01 ff ff ff       	call   347 <write>
  while(--i >= 0)
 446:	83 eb 01             	sub    $0x1,%ebx
 449:	83 c4 10             	add    $0x10,%esp
 44c:	83 fb ff             	cmp    $0xffffffff,%ebx
 44f:	75 e1                	jne    432 <printint+0x63>
    putc(fd, buf[i]);
}
 451:	8d 65 f4             	lea    -0xc(%ebp),%esp
 454:	5b                   	pop    %ebx
 455:	5e                   	pop    %esi
 456:	5f                   	pop    %edi
 457:	5d                   	pop    %ebp
 458:	c3                   	ret    

00000459 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 459:	55                   	push   %ebp
 45a:	89 e5                	mov    %esp,%ebp
 45c:	57                   	push   %edi
 45d:	56                   	push   %esi
 45e:	53                   	push   %ebx
 45f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 462:	8b 75 0c             	mov    0xc(%ebp),%esi
 465:	0f b6 1e             	movzbl (%esi),%ebx
 468:	84 db                	test   %bl,%bl
 46a:	0f 84 b1 01 00 00    	je     621 <printf+0x1c8>
 470:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 473:	8d 45 10             	lea    0x10(%ebp),%eax
 476:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 479:	bf 00 00 00 00       	mov    $0x0,%edi
 47e:	eb 2d                	jmp    4ad <printf+0x54>
 480:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 483:	83 ec 04             	sub    $0x4,%esp
 486:	6a 01                	push   $0x1
 488:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 48b:	50                   	push   %eax
 48c:	ff 75 08             	pushl  0x8(%ebp)
 48f:	e8 b3 fe ff ff       	call   347 <write>
 494:	83 c4 10             	add    $0x10,%esp
 497:	eb 05                	jmp    49e <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 499:	83 ff 25             	cmp    $0x25,%edi
 49c:	74 22                	je     4c0 <printf+0x67>
 49e:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4a1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4a5:	84 db                	test   %bl,%bl
 4a7:	0f 84 74 01 00 00    	je     621 <printf+0x1c8>
    c = fmt[i] & 0xff;
 4ad:	0f be d3             	movsbl %bl,%edx
 4b0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4b3:	85 ff                	test   %edi,%edi
 4b5:	75 e2                	jne    499 <printf+0x40>
      if(c == '%'){
 4b7:	83 f8 25             	cmp    $0x25,%eax
 4ba:	75 c4                	jne    480 <printf+0x27>
        state = '%';
 4bc:	89 c7                	mov    %eax,%edi
 4be:	eb de                	jmp    49e <printf+0x45>
      if(c == 'd'){
 4c0:	83 f8 64             	cmp    $0x64,%eax
 4c3:	74 59                	je     51e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c5:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4cb:	83 fa 70             	cmp    $0x70,%edx
 4ce:	74 7a                	je     54a <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d0:	83 f8 73             	cmp    $0x73,%eax
 4d3:	0f 84 9d 00 00 00    	je     576 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d9:	83 f8 63             	cmp    $0x63,%eax
 4dc:	0f 84 f2 00 00 00    	je     5d4 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e2:	83 f8 25             	cmp    $0x25,%eax
 4e5:	0f 84 15 01 00 00    	je     600 <printf+0x1a7>
 4eb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4ef:	83 ec 04             	sub    $0x4,%esp
 4f2:	6a 01                	push   $0x1
 4f4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f7:	50                   	push   %eax
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 47 fe ff ff       	call   347 <write>
 500:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 503:	83 c4 0c             	add    $0xc,%esp
 506:	6a 01                	push   $0x1
 508:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 33 fe ff ff       	call   347 <write>
 514:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 517:	bf 00 00 00 00       	mov    $0x0,%edi
 51c:	eb 80                	jmp    49e <printf+0x45>
        printint(fd, *ap, 10, 1);
 51e:	83 ec 0c             	sub    $0xc,%esp
 521:	6a 01                	push   $0x1
 523:	b9 0a 00 00 00       	mov    $0xa,%ecx
 528:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52b:	8b 17                	mov    (%edi),%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 9a fe ff ff       	call   3cf <printint>
        ap++;
 535:	89 f8                	mov    %edi,%eax
 537:	83 c0 04             	add    $0x4,%eax
 53a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 540:	bf 00 00 00 00       	mov    $0x0,%edi
 545:	e9 54 ff ff ff       	jmp    49e <printf+0x45>
        printint(fd, *ap, 16, 0);
 54a:	83 ec 0c             	sub    $0xc,%esp
 54d:	6a 00                	push   $0x0
 54f:	b9 10 00 00 00       	mov    $0x10,%ecx
 554:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 557:	8b 17                	mov    (%edi),%edx
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	e8 6e fe ff ff       	call   3cf <printint>
        ap++;
 561:	89 f8                	mov    %edi,%eax
 563:	83 c0 04             	add    $0x4,%eax
 566:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 569:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56c:	bf 00 00 00 00       	mov    $0x0,%edi
 571:	e9 28 ff ff ff       	jmp    49e <printf+0x45>
        s = (char*)*ap;
 576:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 579:	8b 01                	mov    (%ecx),%eax
        ap++;
 57b:	83 c1 04             	add    $0x4,%ecx
 57e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 581:	85 c0                	test   %eax,%eax
 583:	74 13                	je     598 <printf+0x13f>
        s = (char*)*ap;
 585:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 587:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 58a:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 58f:	84 c0                	test   %al,%al
 591:	75 0f                	jne    5a2 <printf+0x149>
 593:	e9 06 ff ff ff       	jmp    49e <printf+0x45>
          s = "(null)";
 598:	bb a7 07 00 00       	mov    $0x7a7,%ebx
        while(*s != 0){
 59d:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 5a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5a5:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5a8:	8b 75 08             	mov    0x8(%ebp),%esi
 5ab:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5ae:	83 ec 04             	sub    $0x4,%esp
 5b1:	6a 01                	push   $0x1
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	e8 8d fd ff ff       	call   347 <write>
          s++;
 5ba:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 5bd:	0f b6 03             	movzbl (%ebx),%eax
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	84 c0                	test   %al,%al
 5c5:	75 e4                	jne    5ab <printf+0x152>
 5c7:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5ca:	bf 00 00 00 00       	mov    $0x0,%edi
 5cf:	e9 ca fe ff ff       	jmp    49e <printf+0x45>
        putc(fd, *ap);
 5d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5d7:	8b 07                	mov    (%edi),%eax
 5d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5dc:	83 ec 04             	sub    $0x4,%esp
 5df:	6a 01                	push   $0x1
 5e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 5a fd ff ff       	call   347 <write>
        ap++;
 5ed:	83 c7 04             	add    $0x4,%edi
 5f0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5f6:	bf 00 00 00 00       	mov    $0x0,%edi
 5fb:	e9 9e fe ff ff       	jmp    49e <printf+0x45>
 600:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	6a 01                	push   $0x1
 608:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 33 fd ff ff       	call   347 <write>
 614:	83 c4 10             	add    $0x10,%esp
      state = 0;
 617:	bf 00 00 00 00       	mov    $0x0,%edi
 61c:	e9 7d fe ff ff       	jmp    49e <printf+0x45>
    }
  }
}
 621:	8d 65 f4             	lea    -0xc(%ebp),%esp
 624:	5b                   	pop    %ebx
 625:	5e                   	pop    %esi
 626:	5f                   	pop    %edi
 627:	5d                   	pop    %ebp
 628:	c3                   	ret    

00000629 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 629:	55                   	push   %ebp
 62a:	89 e5                	mov    %esp,%ebp
 62c:	57                   	push   %edi
 62d:	56                   	push   %esi
 62e:	53                   	push   %ebx
 62f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 632:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 635:	a1 60 0a 00 00       	mov    0xa60,%eax
 63a:	eb 0c                	jmp    648 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	8b 10                	mov    (%eax),%edx
 63e:	39 c2                	cmp    %eax,%edx
 640:	77 04                	ja     646 <free+0x1d>
 642:	39 ca                	cmp    %ecx,%edx
 644:	77 10                	ja     656 <free+0x2d>
{
 646:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	39 c8                	cmp    %ecx,%eax
 64a:	73 f0                	jae    63c <free+0x13>
 64c:	8b 10                	mov    (%eax),%edx
 64e:	39 ca                	cmp    %ecx,%edx
 650:	77 04                	ja     656 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 652:	39 c2                	cmp    %eax,%edx
 654:	77 f0                	ja     646 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 656:	8b 73 fc             	mov    -0x4(%ebx),%esi
 659:	8b 10                	mov    (%eax),%edx
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 fa                	cmp    %edi,%edx
 660:	74 19                	je     67b <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 662:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66b:	39 f1                	cmp    %esi,%ecx
 66d:	74 1b                	je     68a <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 66f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 671:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 676:	5b                   	pop    %ebx
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 67b:	03 72 04             	add    0x4(%edx),%esi
 67e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 681:	8b 10                	mov    (%eax),%edx
 683:	8b 12                	mov    (%edx),%edx
 685:	89 53 f8             	mov    %edx,-0x8(%ebx)
 688:	eb db                	jmp    665 <free+0x3c>
    p->s.size += bp->s.size;
 68a:	03 53 fc             	add    -0x4(%ebx),%edx
 68d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 690:	8b 53 f8             	mov    -0x8(%ebx),%edx
 693:	89 10                	mov    %edx,(%eax)
 695:	eb da                	jmp    671 <free+0x48>

00000697 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	57                   	push   %edi
 69b:	56                   	push   %esi
 69c:	53                   	push   %ebx
 69d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	8d 58 07             	lea    0x7(%eax),%ebx
 6a6:	c1 eb 03             	shr    $0x3,%ebx
 6a9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6ac:	8b 15 60 0a 00 00    	mov    0xa60,%edx
 6b2:	85 d2                	test   %edx,%edx
 6b4:	74 20                	je     6d6 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b8:	8b 48 04             	mov    0x4(%eax),%ecx
 6bb:	39 cb                	cmp    %ecx,%ebx
 6bd:	76 3c                	jbe    6fb <malloc+0x64>
 6bf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6c5:	be 00 10 00 00       	mov    $0x1000,%esi
 6ca:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6cd:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6d4:	eb 70                	jmp    746 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6d6:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6dd:	0a 00 00 
 6e0:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6e7:	0a 00 00 
    base.s.size = 0;
 6ea:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6f1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6f4:	ba 64 0a 00 00       	mov    $0xa64,%edx
 6f9:	eb bb                	jmp    6b6 <malloc+0x1f>
      if(p->s.size == nunits)
 6fb:	39 cb                	cmp    %ecx,%ebx
 6fd:	74 1c                	je     71b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ff:	29 d9                	sub    %ebx,%ecx
 701:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 704:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 707:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 70a:	89 15 60 0a 00 00    	mov    %edx,0xa60
      return (void*)(p + 1);
 710:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 713:	8d 65 f4             	lea    -0xc(%ebp),%esp
 716:	5b                   	pop    %ebx
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 71b:	8b 08                	mov    (%eax),%ecx
 71d:	89 0a                	mov    %ecx,(%edx)
 71f:	eb e9                	jmp    70a <malloc+0x73>
  hp->s.size = nu;
 721:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 724:	83 ec 0c             	sub    $0xc,%esp
 727:	83 c0 08             	add    $0x8,%eax
 72a:	50                   	push   %eax
 72b:	e8 f9 fe ff ff       	call   629 <free>
  return freep;
 730:	8b 15 60 0a 00 00    	mov    0xa60,%edx
      if((p = morecore(nunits)) == 0)
 736:	83 c4 10             	add    $0x10,%esp
 739:	85 d2                	test   %edx,%edx
 73b:	74 2b                	je     768 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 73f:	8b 48 04             	mov    0x4(%eax),%ecx
 742:	39 d9                	cmp    %ebx,%ecx
 744:	73 b5                	jae    6fb <malloc+0x64>
 746:	89 c2                	mov    %eax,%edx
    if(p == freep)
 748:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 74e:	75 ed                	jne    73d <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	57                   	push   %edi
 754:	e8 56 fc ff ff       	call   3af <sbrk>
  if(p == (char*)-1)
 759:	83 c4 10             	add    $0x10,%esp
 75c:	83 f8 ff             	cmp    $0xffffffff,%eax
 75f:	75 c0                	jne    721 <malloc+0x8a>
        return 0;
 761:	b8 00 00 00 00       	mov    $0x0,%eax
 766:	eb ab                	jmp    713 <malloc+0x7c>
 768:	b8 00 00 00 00       	mov    $0x0,%eax
 76d:	eb a4                	jmp    713 <malloc+0x7c>
