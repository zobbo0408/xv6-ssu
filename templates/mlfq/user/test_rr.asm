
user/_test_rr:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define OUTER_LOOP 30
#define STOP_POINT 20
#define PI 3.14
const char *level[] = {"high", "mid", "low"};
int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
        int pid =getpid();
  13:	e8 ff 03 00 00       	call   417 <getpid>
        float dummy = 0;
        int i,j;
        printf(1, "=== TEST START ===\n");
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	68 e0 07 00 00       	push   $0x7e0
  20:	6a 01                	push   $0x1
  22:	e8 a2 04 00 00       	call   4c9 <printf>

        pid = fork();
  27:	e8 63 03 00 00       	call   38f <fork>
        if(pid == 0)
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	0f 85 09 01 00 00    	jne    140 <main+0x140>
  37:	89 c6                	mov    %eax,%esi
        {
            pid = fork();
  39:	e8 51 03 00 00       	call   38f <fork>
  3e:	89 c3                	mov    %eax,%ebx
            if(pid == 0)
  40:	85 c0                	test   %eax,%eax
  42:	75 7a                	jne    be <main+0xbe>
            {
                    printf(1, "P3 ARRIVED\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 f4 07 00 00       	push   $0x7f4
  4c:	6a 01                	push   $0x1
  4e:	e8 76 04 00 00       	call   4c9 <printf>
  53:	83 c4 10             	add    $0x10,%esp
                    for(i=0; i<STOP_POINT; i++)
  56:	89 de                	mov    %ebx,%esi
        float dummy = 0;
  58:	d9 ee                	fldz   
  5a:	d9 5d e0             	fstps  -0x20(%ebp)
                    {
                            for(j=0; j<STOP_POINT; j++)
  5d:	89 d8                	mov    %ebx,%eax
                                            dummy += PI*j;
  5f:	dd 05 b8 08 00 00    	fldl   0x8b8
  65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  68:	db 45 dc             	fildl  -0x24(%ebp)
  6b:	d8 c9                	fmul   %st(1),%st
  6d:	d8 45 e0             	fadds  -0x20(%ebp)
  70:	d9 5d e0             	fstps  -0x20(%ebp)
                            for(j=0; j<STOP_POINT; j++)
  73:	83 c0 01             	add    $0x1,%eax
  76:	83 f8 14             	cmp    $0x14,%eax
  79:	75 ea                	jne    65 <main+0x65>
  7b:	dd d8                	fstp   %st(0)
                            int lev = getlevel();
  7d:	e8 b5 03 00 00       	call   437 <getlevel>
                            printf(1, "P3 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
  82:	83 ec 10             	sub    $0x10,%esp
  85:	d9 45 e0             	flds   -0x20(%ebp)
  88:	dd 1c 24             	fstpl  (%esp)
  8b:	56                   	push   %esi
  8c:	ff 34 85 38 0b 00 00 	pushl  0xb38(,%eax,4)
  93:	68 00 08 00 00       	push   $0x800
  98:	6a 01                	push   $0x1
  9a:	e8 2a 04 00 00       	call   4c9 <printf>
                    for(i=0; i<STOP_POINT; i++)
  9f:	83 c6 01             	add    $0x1,%esi
  a2:	83 c4 20             	add    $0x20,%esp
  a5:	83 fe 14             	cmp    $0x14,%esi
  a8:	75 b3                	jne    5d <main+0x5d>
                    }
                    printf(1, "P3 RELEASED\n");
  aa:	83 ec 08             	sub    $0x8,%esp
  ad:	68 1d 08 00 00       	push   $0x81d
  b2:	6a 01                	push   $0x1
  b4:	e8 10 04 00 00       	call   4c9 <printf>
                    exit();
  b9:	e8 d9 02 00 00       	call   397 <exit>
            }
            else{   
                    printf(1, "P2 ARRIVED\n");
  be:	83 ec 08             	sub    $0x8,%esp
  c1:	68 2a 08 00 00       	push   $0x82a
  c6:	6a 01                	push   $0x1
  c8:	e8 fc 03 00 00       	call   4c9 <printf>
  cd:	83 c4 10             	add    $0x10,%esp
                    for(i=0; i<STOP_POINT; i++)
  d0:	89 f3                	mov    %esi,%ebx
        float dummy = 0;
  d2:	d9 ee                	fldz   
  d4:	d9 5d e0             	fstps  -0x20(%ebp)
                    {
                            for(j=0; j<STOP_POINT; j++)
  d7:	89 f0                	mov    %esi,%eax
                                            dummy += PI*j;
  d9:	dd 05 b8 08 00 00    	fldl   0x8b8
  df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  e2:	db 45 dc             	fildl  -0x24(%ebp)
  e5:	d8 c9                	fmul   %st(1),%st
  e7:	d8 45 e0             	fadds  -0x20(%ebp)
  ea:	d9 5d e0             	fstps  -0x20(%ebp)
                            for(j=0; j<STOP_POINT; j++)
  ed:	83 c0 01             	add    $0x1,%eax
  f0:	83 f8 14             	cmp    $0x14,%eax
  f3:	75 ea                	jne    df <main+0xdf>
  f5:	dd d8                	fstp   %st(0)
                            int lev = getlevel();
  f7:	e8 3b 03 00 00       	call   437 <getlevel>
                            printf(1, "P2 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
  fc:	83 ec 10             	sub    $0x10,%esp
  ff:	d9 45 e0             	flds   -0x20(%ebp)
 102:	dd 1c 24             	fstpl  (%esp)
 105:	53                   	push   %ebx
 106:	ff 34 85 38 0b 00 00 	pushl  0xb38(,%eax,4)
 10d:	68 36 08 00 00       	push   $0x836
 112:	6a 01                	push   $0x1
 114:	e8 b0 03 00 00       	call   4c9 <printf>
                    for(i=0; i<STOP_POINT; i++)
 119:	83 c3 01             	add    $0x1,%ebx
 11c:	83 c4 20             	add    $0x20,%esp
 11f:	83 fb 14             	cmp    $0x14,%ebx
 122:	75 b3                	jne    d7 <main+0xd7>
                    }
                    printf(1, "P2 RELEASED\n");
 124:	83 ec 08             	sub    $0x8,%esp
 127:	68 53 08 00 00       	push   $0x853
 12c:	6a 01                	push   $0x1
 12e:	e8 96 03 00 00       	call   4c9 <printf>
                    wait();
 133:	e8 67 02 00 00       	call   39f <wait>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	e9 92 00 00 00       	jmp    1d2 <main+0x1d2>
            }
                
        }
        else
        {       
            printf(1, "P1 ARRIVED\n");
 140:	83 ec 08             	sub    $0x8,%esp
 143:	68 60 08 00 00       	push   $0x860
 148:	6a 01                	push   $0x1
 14a:	e8 7a 03 00 00       	call   4c9 <printf>
 14f:	83 c4 10             	add    $0x10,%esp
            for (i=0; i< STOP_POINT; i++){    // p1: 20 ~ 30
 152:	bb 00 00 00 00       	mov    $0x0,%ebx
        float dummy = 0;
 157:	d9 ee                	fldz   
 159:	d9 5d e0             	fstps  -0x20(%ebp)
                    for (j=0; j<STOP_POINT; j++)
 15c:	b8 00 00 00 00       	mov    $0x0,%eax
                                    dummy += PI*j;
 161:	dd 05 b8 08 00 00    	fldl   0x8b8
 167:	89 45 dc             	mov    %eax,-0x24(%ebp)
 16a:	db 45 dc             	fildl  -0x24(%ebp)
 16d:	d8 c9                	fmul   %st(1),%st
 16f:	d8 45 e0             	fadds  -0x20(%ebp)
 172:	d9 5d e0             	fstps  -0x20(%ebp)
                    for (j=0; j<STOP_POINT; j++)
 175:	83 c0 01             	add    $0x1,%eax
 178:	83 f8 14             	cmp    $0x14,%eax
 17b:	75 ea                	jne    167 <main+0x167>
 17d:	dd d8                	fstp   %st(0)
                    int lev = getlevel();
 17f:	e8 b3 02 00 00       	call   437 <getlevel>
                    printf(1, "P1 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
 184:	83 ec 10             	sub    $0x10,%esp
 187:	d9 45 e0             	flds   -0x20(%ebp)
 18a:	dd 1c 24             	fstpl  (%esp)
 18d:	53                   	push   %ebx
 18e:	ff 34 85 38 0b 00 00 	pushl  0xb38(,%eax,4)
 195:	68 6c 08 00 00       	push   $0x86c
 19a:	6a 01                	push   $0x1
 19c:	e8 28 03 00 00       	call   4c9 <printf>
            for (i=0; i< STOP_POINT; i++){    // p1: 20 ~ 30
 1a1:	83 c3 01             	add    $0x1,%ebx
 1a4:	83 c4 20             	add    $0x20,%esp
 1a7:	83 fb 14             	cmp    $0x14,%ebx
 1aa:	75 b0                	jne    15c <main+0x15c>
            }
            printf(1, "P1 RELEASED\n");
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	68 89 08 00 00       	push   $0x889
 1b4:	6a 01                	push   $0x1
 1b6:	e8 0e 03 00 00       	call   4c9 <printf>
            wait();
 1bb:	e8 df 01 00 00       	call   39f <wait>
            printf(1, "=== TEST DONE ===\n");
 1c0:	83 c4 08             	add    $0x8,%esp
 1c3:	68 96 08 00 00       	push   $0x896
 1c8:	6a 01                	push   $0x1
 1ca:	e8 fa 02 00 00       	call   4c9 <printf>
 1cf:	83 c4 10             	add    $0x10,%esp
        }
        exit();
 1d2:	e8 c0 01 00 00       	call   397 <exit>

000001d7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	53                   	push   %ebx
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e1:	89 c2                	mov    %eax,%edx
 1e3:	83 c1 01             	add    $0x1,%ecx
 1e6:	83 c2 01             	add    $0x1,%edx
 1e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1ed:	88 5a ff             	mov    %bl,-0x1(%edx)
 1f0:	84 db                	test   %bl,%bl
 1f2:	75 ef                	jne    1e3 <strcpy+0xc>
    ;
  return os;
}
 1f4:	5b                   	pop    %ebx
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 200:	0f b6 01             	movzbl (%ecx),%eax
 203:	84 c0                	test   %al,%al
 205:	74 15                	je     21c <strcmp+0x25>
 207:	3a 02                	cmp    (%edx),%al
 209:	75 11                	jne    21c <strcmp+0x25>
    p++, q++;
 20b:	83 c1 01             	add    $0x1,%ecx
 20e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 211:	0f b6 01             	movzbl (%ecx),%eax
 214:	84 c0                	test   %al,%al
 216:	74 04                	je     21c <strcmp+0x25>
 218:	3a 02                	cmp    (%edx),%al
 21a:	74 ef                	je     20b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 21c:	0f b6 c0             	movzbl %al,%eax
 21f:	0f b6 12             	movzbl (%edx),%edx
 222:	29 d0                	sub    %edx,%eax
}
 224:	5d                   	pop    %ebp
 225:	c3                   	ret    

00000226 <strlen>:

uint
strlen(const char *s)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 22c:	80 39 00             	cmpb   $0x0,(%ecx)
 22f:	74 12                	je     243 <strlen+0x1d>
 231:	ba 00 00 00 00       	mov    $0x0,%edx
 236:	83 c2 01             	add    $0x1,%edx
 239:	89 d0                	mov    %edx,%eax
 23b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 23f:	75 f5                	jne    236 <strlen+0x10>
    ;
  return n;
}
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
  for(n = 0; s[n]; n++)
 243:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 248:	eb f7                	jmp    241 <strlen+0x1b>

0000024a <memset>:

void*
memset(void *dst, int c, uint n)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	57                   	push   %edi
 24e:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 251:	89 d7                	mov    %edx,%edi
 253:	8b 4d 10             	mov    0x10(%ebp),%ecx
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	fc                   	cld    
 25a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 25c:	89 d0                	mov    %edx,%eax
 25e:	5f                   	pop    %edi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    

00000261 <strchr>:

char*
strchr(const char *s, char c)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	53                   	push   %ebx
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 26b:	0f b6 10             	movzbl (%eax),%edx
 26e:	84 d2                	test   %dl,%dl
 270:	74 1e                	je     290 <strchr+0x2f>
 272:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 274:	38 d3                	cmp    %dl,%bl
 276:	74 15                	je     28d <strchr+0x2c>
  for(; *s; s++)
 278:	83 c0 01             	add    $0x1,%eax
 27b:	0f b6 10             	movzbl (%eax),%edx
 27e:	84 d2                	test   %dl,%dl
 280:	74 06                	je     288 <strchr+0x27>
    if(*s == c)
 282:	38 ca                	cmp    %cl,%dl
 284:	75 f2                	jne    278 <strchr+0x17>
 286:	eb 05                	jmp    28d <strchr+0x2c>
      return (char*)s;
  return 0;
 288:	b8 00 00 00 00       	mov    $0x0,%eax
}
 28d:	5b                   	pop    %ebx
 28e:	5d                   	pop    %ebp
 28f:	c3                   	ret    
  return 0;
 290:	b8 00 00 00 00       	mov    $0x0,%eax
 295:	eb f6                	jmp    28d <strchr+0x2c>

00000297 <gets>:

char*
gets(char *buf, int max)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	57                   	push   %edi
 29b:	56                   	push   %esi
 29c:	53                   	push   %ebx
 29d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a0:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 2a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 2a8:	8d 5e 01             	lea    0x1(%esi),%ebx
 2ab:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ae:	7d 2b                	jge    2db <gets+0x44>
    cc = read(0, &c, 1);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	6a 01                	push   $0x1
 2b5:	57                   	push   %edi
 2b6:	6a 00                	push   $0x0
 2b8:	e8 f2 00 00 00       	call   3af <read>
    if(cc < 1)
 2bd:	83 c4 10             	add    $0x10,%esp
 2c0:	85 c0                	test   %eax,%eax
 2c2:	7e 17                	jle    2db <gets+0x44>
      break;
    buf[i++] = c;
 2c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
 2cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 2cf:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 2d1:	3c 0a                	cmp    $0xa,%al
 2d3:	74 04                	je     2d9 <gets+0x42>
 2d5:	3c 0d                	cmp    $0xd,%al
 2d7:	75 cf                	jne    2a8 <gets+0x11>
  for(i=0; i+1 < max; ){
 2d9:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e5:	5b                   	pop    %ebx
 2e6:	5e                   	pop    %esi
 2e7:	5f                   	pop    %edi
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <stat>:

int
stat(const char *n, struct stat *st)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	56                   	push   %esi
 2ee:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	6a 00                	push   $0x0
 2f4:	ff 75 08             	pushl  0x8(%ebp)
 2f7:	e8 db 00 00 00       	call   3d7 <open>
  if(fd < 0)
 2fc:	83 c4 10             	add    $0x10,%esp
 2ff:	85 c0                	test   %eax,%eax
 301:	78 24                	js     327 <stat+0x3d>
 303:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 305:	83 ec 08             	sub    $0x8,%esp
 308:	ff 75 0c             	pushl  0xc(%ebp)
 30b:	50                   	push   %eax
 30c:	e8 de 00 00 00       	call   3ef <fstat>
 311:	89 c6                	mov    %eax,%esi
  close(fd);
 313:	89 1c 24             	mov    %ebx,(%esp)
 316:	e8 a4 00 00 00       	call   3bf <close>
  return r;
 31b:	83 c4 10             	add    $0x10,%esp
}
 31e:	89 f0                	mov    %esi,%eax
 320:	8d 65 f8             	lea    -0x8(%ebp),%esp
 323:	5b                   	pop    %ebx
 324:	5e                   	pop    %esi
 325:	5d                   	pop    %ebp
 326:	c3                   	ret    
    return -1;
 327:	be ff ff ff ff       	mov    $0xffffffff,%esi
 32c:	eb f0                	jmp    31e <stat+0x34>

0000032e <atoi>:

int
atoi(const char *s)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	53                   	push   %ebx
 332:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 335:	0f b6 11             	movzbl (%ecx),%edx
 338:	8d 42 d0             	lea    -0x30(%edx),%eax
 33b:	3c 09                	cmp    $0x9,%al
 33d:	77 20                	ja     35f <atoi+0x31>
  n = 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 344:	83 c1 01             	add    $0x1,%ecx
 347:	8d 04 80             	lea    (%eax,%eax,4),%eax
 34a:	0f be d2             	movsbl %dl,%edx
 34d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 351:	0f b6 11             	movzbl (%ecx),%edx
 354:	8d 5a d0             	lea    -0x30(%edx),%ebx
 357:	80 fb 09             	cmp    $0x9,%bl
 35a:	76 e8                	jbe    344 <atoi+0x16>
  return n;
}
 35c:	5b                   	pop    %ebx
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    
  n = 0;
 35f:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 364:	eb f6                	jmp    35c <atoi+0x2e>

00000366 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	56                   	push   %esi
 36a:	53                   	push   %ebx
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	8b 75 0c             	mov    0xc(%ebp),%esi
 371:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 374:	85 db                	test   %ebx,%ebx
 376:	7e 13                	jle    38b <memmove+0x25>
 378:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 37d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 381:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 384:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 387:	39 d3                	cmp    %edx,%ebx
 389:	75 f2                	jne    37d <memmove+0x17>
  return vdst;
}
 38b:	5b                   	pop    %ebx
 38c:	5e                   	pop    %esi
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret    

0000038f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38f:	b8 01 00 00 00       	mov    $0x1,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <exit>:
SYSCALL(exit)
 397:	b8 02 00 00 00       	mov    $0x2,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <wait>:
SYSCALL(wait)
 39f:	b8 03 00 00 00       	mov    $0x3,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <pipe>:
SYSCALL(pipe)
 3a7:	b8 04 00 00 00       	mov    $0x4,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <read>:
SYSCALL(read)
 3af:	b8 05 00 00 00       	mov    $0x5,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <write>:
SYSCALL(write)
 3b7:	b8 10 00 00 00       	mov    $0x10,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <close>:
SYSCALL(close)
 3bf:	b8 15 00 00 00       	mov    $0x15,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <kill>:
SYSCALL(kill)
 3c7:	b8 06 00 00 00       	mov    $0x6,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <exec>:
SYSCALL(exec)
 3cf:	b8 07 00 00 00       	mov    $0x7,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <open>:
SYSCALL(open)
 3d7:	b8 0f 00 00 00       	mov    $0xf,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <mknod>:
SYSCALL(mknod)
 3df:	b8 11 00 00 00       	mov    $0x11,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <unlink>:
SYSCALL(unlink)
 3e7:	b8 12 00 00 00       	mov    $0x12,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <fstat>:
SYSCALL(fstat)
 3ef:	b8 08 00 00 00       	mov    $0x8,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <link>:
SYSCALL(link)
 3f7:	b8 13 00 00 00       	mov    $0x13,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <mkdir>:
SYSCALL(mkdir)
 3ff:	b8 14 00 00 00       	mov    $0x14,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <chdir>:
SYSCALL(chdir)
 407:	b8 09 00 00 00       	mov    $0x9,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <dup>:
SYSCALL(dup)
 40f:	b8 0a 00 00 00       	mov    $0xa,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <getpid>:
SYSCALL(getpid)
 417:	b8 0b 00 00 00       	mov    $0xb,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sbrk>:
SYSCALL(sbrk)
 41f:	b8 0c 00 00 00       	mov    $0xc,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <sleep>:
SYSCALL(sleep)
 427:	b8 0d 00 00 00       	mov    $0xd,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <uptime>:
SYSCALL(uptime)
 42f:	b8 0e 00 00 00       	mov    $0xe,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <getlevel>:
SYSCALL(getlevel)
 437:	b8 16 00 00 00       	mov    $0x16,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	57                   	push   %edi
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
 445:	83 ec 3c             	sub    $0x3c,%esp
 448:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 44e:	74 14                	je     464 <printint+0x25>
 450:	85 d2                	test   %edx,%edx
 452:	79 10                	jns    464 <printint+0x25>
    neg = 1;
    x = -xx;
 454:	f7 da                	neg    %edx
    neg = 1;
 456:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 45d:	bf 00 00 00 00       	mov    $0x0,%edi
 462:	eb 0b                	jmp    46f <printint+0x30>
  neg = 0;
 464:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 46b:	eb f0                	jmp    45d <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 46d:	89 df                	mov    %ebx,%edi
 46f:	8d 5f 01             	lea    0x1(%edi),%ebx
 472:	89 d0                	mov    %edx,%eax
 474:	ba 00 00 00 00       	mov    $0x0,%edx
 479:	f7 f1                	div    %ecx
 47b:	0f b6 92 c8 08 00 00 	movzbl 0x8c8(%edx),%edx
 482:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 486:	89 c2                	mov    %eax,%edx
 488:	85 c0                	test   %eax,%eax
 48a:	75 e1                	jne    46d <printint+0x2e>
  if(neg)
 48c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 490:	74 08                	je     49a <printint+0x5b>
    buf[i++] = '-';
 492:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 497:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 49a:	83 eb 01             	sub    $0x1,%ebx
 49d:	78 22                	js     4c1 <printint+0x82>
  write(fd, &c, 1);
 49f:	8d 7d d7             	lea    -0x29(%ebp),%edi
 4a2:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 4a7:	88 45 d7             	mov    %al,-0x29(%ebp)
 4aa:	83 ec 04             	sub    $0x4,%esp
 4ad:	6a 01                	push   $0x1
 4af:	57                   	push   %edi
 4b0:	56                   	push   %esi
 4b1:	e8 01 ff ff ff       	call   3b7 <write>
  while(--i >= 0)
 4b6:	83 eb 01             	sub    $0x1,%ebx
 4b9:	83 c4 10             	add    $0x10,%esp
 4bc:	83 fb ff             	cmp    $0xffffffff,%ebx
 4bf:	75 e1                	jne    4a2 <printint+0x63>
    putc(fd, buf[i]);
}
 4c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c4:	5b                   	pop    %ebx
 4c5:	5e                   	pop    %esi
 4c6:	5f                   	pop    %edi
 4c7:	5d                   	pop    %ebp
 4c8:	c3                   	ret    

000004c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	57                   	push   %edi
 4cd:	56                   	push   %esi
 4ce:	53                   	push   %ebx
 4cf:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d2:	8b 75 0c             	mov    0xc(%ebp),%esi
 4d5:	0f b6 1e             	movzbl (%esi),%ebx
 4d8:	84 db                	test   %bl,%bl
 4da:	0f 84 b1 01 00 00    	je     691 <printf+0x1c8>
 4e0:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 4e3:	8d 45 10             	lea    0x10(%ebp),%eax
 4e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 4e9:	bf 00 00 00 00       	mov    $0x0,%edi
 4ee:	eb 2d                	jmp    51d <printf+0x54>
 4f0:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 4f3:	83 ec 04             	sub    $0x4,%esp
 4f6:	6a 01                	push   $0x1
 4f8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4fb:	50                   	push   %eax
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 b3 fe ff ff       	call   3b7 <write>
 504:	83 c4 10             	add    $0x10,%esp
 507:	eb 05                	jmp    50e <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 509:	83 ff 25             	cmp    $0x25,%edi
 50c:	74 22                	je     530 <printf+0x67>
 50e:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 511:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 515:	84 db                	test   %bl,%bl
 517:	0f 84 74 01 00 00    	je     691 <printf+0x1c8>
    c = fmt[i] & 0xff;
 51d:	0f be d3             	movsbl %bl,%edx
 520:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 523:	85 ff                	test   %edi,%edi
 525:	75 e2                	jne    509 <printf+0x40>
      if(c == '%'){
 527:	83 f8 25             	cmp    $0x25,%eax
 52a:	75 c4                	jne    4f0 <printf+0x27>
        state = '%';
 52c:	89 c7                	mov    %eax,%edi
 52e:	eb de                	jmp    50e <printf+0x45>
      if(c == 'd'){
 530:	83 f8 64             	cmp    $0x64,%eax
 533:	74 59                	je     58e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 535:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 53b:	83 fa 70             	cmp    $0x70,%edx
 53e:	74 7a                	je     5ba <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 540:	83 f8 73             	cmp    $0x73,%eax
 543:	0f 84 9d 00 00 00    	je     5e6 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 549:	83 f8 63             	cmp    $0x63,%eax
 54c:	0f 84 f2 00 00 00    	je     644 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 552:	83 f8 25             	cmp    $0x25,%eax
 555:	0f 84 15 01 00 00    	je     670 <printf+0x1a7>
 55b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 55f:	83 ec 04             	sub    $0x4,%esp
 562:	6a 01                	push   $0x1
 564:	8d 45 e7             	lea    -0x19(%ebp),%eax
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 47 fe ff ff       	call   3b7 <write>
 570:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 573:	83 c4 0c             	add    $0xc,%esp
 576:	6a 01                	push   $0x1
 578:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 33 fe ff ff       	call   3b7 <write>
 584:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 587:	bf 00 00 00 00       	mov    $0x0,%edi
 58c:	eb 80                	jmp    50e <printf+0x45>
        printint(fd, *ap, 10, 1);
 58e:	83 ec 0c             	sub    $0xc,%esp
 591:	6a 01                	push   $0x1
 593:	b9 0a 00 00 00       	mov    $0xa,%ecx
 598:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 59b:	8b 17                	mov    (%edi),%edx
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	e8 9a fe ff ff       	call   43f <printint>
        ap++;
 5a5:	89 f8                	mov    %edi,%eax
 5a7:	83 c0 04             	add    $0x4,%eax
 5aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5ad:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b0:	bf 00 00 00 00       	mov    $0x0,%edi
 5b5:	e9 54 ff ff ff       	jmp    50e <printf+0x45>
        printint(fd, *ap, 16, 0);
 5ba:	83 ec 0c             	sub    $0xc,%esp
 5bd:	6a 00                	push   $0x0
 5bf:	b9 10 00 00 00       	mov    $0x10,%ecx
 5c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5c7:	8b 17                	mov    (%edi),%edx
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	e8 6e fe ff ff       	call   43f <printint>
        ap++;
 5d1:	89 f8                	mov    %edi,%eax
 5d3:	83 c0 04             	add    $0x4,%eax
 5d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dc:	bf 00 00 00 00       	mov    $0x0,%edi
 5e1:	e9 28 ff ff ff       	jmp    50e <printf+0x45>
        s = (char*)*ap;
 5e6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 5e9:	8b 01                	mov    (%ecx),%eax
        ap++;
 5eb:	83 c1 04             	add    $0x4,%ecx
 5ee:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5f1:	85 c0                	test   %eax,%eax
 5f3:	74 13                	je     608 <printf+0x13f>
        s = (char*)*ap;
 5f5:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 5f7:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 5fa:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 5ff:	84 c0                	test   %al,%al
 601:	75 0f                	jne    612 <printf+0x149>
 603:	e9 06 ff ff ff       	jmp    50e <printf+0x45>
          s = "(null)";
 608:	bb c0 08 00 00       	mov    $0x8c0,%ebx
        while(*s != 0){
 60d:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 612:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 615:	89 75 d0             	mov    %esi,-0x30(%ebp)
 618:	8b 75 08             	mov    0x8(%ebp),%esi
 61b:	88 45 e3             	mov    %al,-0x1d(%ebp)
 61e:	83 ec 04             	sub    $0x4,%esp
 621:	6a 01                	push   $0x1
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	e8 8d fd ff ff       	call   3b7 <write>
          s++;
 62a:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 62d:	0f b6 03             	movzbl (%ebx),%eax
 630:	83 c4 10             	add    $0x10,%esp
 633:	84 c0                	test   %al,%al
 635:	75 e4                	jne    61b <printf+0x152>
 637:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 63a:	bf 00 00 00 00       	mov    $0x0,%edi
 63f:	e9 ca fe ff ff       	jmp    50e <printf+0x45>
        putc(fd, *ap);
 644:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 647:	8b 07                	mov    (%edi),%eax
 649:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 64c:	83 ec 04             	sub    $0x4,%esp
 64f:	6a 01                	push   $0x1
 651:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 5a fd ff ff       	call   3b7 <write>
        ap++;
 65d:	83 c7 04             	add    $0x4,%edi
 660:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 663:	83 c4 10             	add    $0x10,%esp
      state = 0;
 666:	bf 00 00 00 00       	mov    $0x0,%edi
 66b:	e9 9e fe ff ff       	jmp    50e <printf+0x45>
 670:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 673:	83 ec 04             	sub    $0x4,%esp
 676:	6a 01                	push   $0x1
 678:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 67b:	50                   	push   %eax
 67c:	ff 75 08             	pushl  0x8(%ebp)
 67f:	e8 33 fd ff ff       	call   3b7 <write>
 684:	83 c4 10             	add    $0x10,%esp
      state = 0;
 687:	bf 00 00 00 00       	mov    $0x0,%edi
 68c:	e9 7d fe ff ff       	jmp    50e <printf+0x45>
    }
  }
}
 691:	8d 65 f4             	lea    -0xc(%ebp),%esp
 694:	5b                   	pop    %ebx
 695:	5e                   	pop    %esi
 696:	5f                   	pop    %edi
 697:	5d                   	pop    %ebp
 698:	c3                   	ret    

00000699 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 699:	55                   	push   %ebp
 69a:	89 e5                	mov    %esp,%ebp
 69c:	57                   	push   %edi
 69d:	56                   	push   %esi
 69e:	53                   	push   %ebx
 69f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	a1 44 0b 00 00       	mov    0xb44,%eax
 6aa:	eb 0c                	jmp    6b8 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	8b 10                	mov    (%eax),%edx
 6ae:	39 c2                	cmp    %eax,%edx
 6b0:	77 04                	ja     6b6 <free+0x1d>
 6b2:	39 ca                	cmp    %ecx,%edx
 6b4:	77 10                	ja     6c6 <free+0x2d>
{
 6b6:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b8:	39 c8                	cmp    %ecx,%eax
 6ba:	73 f0                	jae    6ac <free+0x13>
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	39 ca                	cmp    %ecx,%edx
 6c0:	77 04                	ja     6c6 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	39 c2                	cmp    %eax,%edx
 6c4:	77 f0                	ja     6b6 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c9:	8b 10                	mov    (%eax),%edx
 6cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ce:	39 fa                	cmp    %edi,%edx
 6d0:	74 19                	je     6eb <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6db:	39 f1                	cmp    %esi,%ecx
 6dd:	74 1b                	je     6fa <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6df:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6e1:	a3 44 0b 00 00       	mov    %eax,0xb44
}
 6e6:	5b                   	pop    %ebx
 6e7:	5e                   	pop    %esi
 6e8:	5f                   	pop    %edi
 6e9:	5d                   	pop    %ebp
 6ea:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6eb:	03 72 04             	add    0x4(%edx),%esi
 6ee:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 12                	mov    (%edx),%edx
 6f5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6f8:	eb db                	jmp    6d5 <free+0x3c>
    p->s.size += bp->s.size;
 6fa:	03 53 fc             	add    -0x4(%ebx),%edx
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 53 f8             	mov    -0x8(%ebx),%edx
 703:	89 10                	mov    %edx,(%eax)
 705:	eb da                	jmp    6e1 <free+0x48>

00000707 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 707:	55                   	push   %ebp
 708:	89 e5                	mov    %esp,%ebp
 70a:	57                   	push   %edi
 70b:	56                   	push   %esi
 70c:	53                   	push   %ebx
 70d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	8d 58 07             	lea    0x7(%eax),%ebx
 716:	c1 eb 03             	shr    $0x3,%ebx
 719:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 71c:	8b 15 44 0b 00 00    	mov    0xb44,%edx
 722:	85 d2                	test   %edx,%edx
 724:	74 20                	je     746 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 726:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 728:	8b 48 04             	mov    0x4(%eax),%ecx
 72b:	39 cb                	cmp    %ecx,%ebx
 72d:	76 3c                	jbe    76b <malloc+0x64>
 72f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 735:	be 00 10 00 00       	mov    $0x1000,%esi
 73a:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 73d:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 744:	eb 70                	jmp    7b6 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 746:	c7 05 44 0b 00 00 48 	movl   $0xb48,0xb44
 74d:	0b 00 00 
 750:	c7 05 48 0b 00 00 48 	movl   $0xb48,0xb48
 757:	0b 00 00 
    base.s.size = 0;
 75a:	c7 05 4c 0b 00 00 00 	movl   $0x0,0xb4c
 761:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 764:	ba 48 0b 00 00       	mov    $0xb48,%edx
 769:	eb bb                	jmp    726 <malloc+0x1f>
      if(p->s.size == nunits)
 76b:	39 cb                	cmp    %ecx,%ebx
 76d:	74 1c                	je     78b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 76f:	29 d9                	sub    %ebx,%ecx
 771:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 774:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 777:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 77a:	89 15 44 0b 00 00    	mov    %edx,0xb44
      return (void*)(p + 1);
 780:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 783:	8d 65 f4             	lea    -0xc(%ebp),%esp
 786:	5b                   	pop    %ebx
 787:	5e                   	pop    %esi
 788:	5f                   	pop    %edi
 789:	5d                   	pop    %ebp
 78a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 78b:	8b 08                	mov    (%eax),%ecx
 78d:	89 0a                	mov    %ecx,(%edx)
 78f:	eb e9                	jmp    77a <malloc+0x73>
  hp->s.size = nu;
 791:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 794:	83 ec 0c             	sub    $0xc,%esp
 797:	83 c0 08             	add    $0x8,%eax
 79a:	50                   	push   %eax
 79b:	e8 f9 fe ff ff       	call   699 <free>
  return freep;
 7a0:	8b 15 44 0b 00 00    	mov    0xb44,%edx
      if((p = morecore(nunits)) == 0)
 7a6:	83 c4 10             	add    $0x10,%esp
 7a9:	85 d2                	test   %edx,%edx
 7ab:	74 2b                	je     7d8 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ad:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7af:	8b 48 04             	mov    0x4(%eax),%ecx
 7b2:	39 d9                	cmp    %ebx,%ecx
 7b4:	73 b5                	jae    76b <malloc+0x64>
 7b6:	89 c2                	mov    %eax,%edx
    if(p == freep)
 7b8:	39 05 44 0b 00 00    	cmp    %eax,0xb44
 7be:	75 ed                	jne    7ad <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	57                   	push   %edi
 7c4:	e8 56 fc ff ff       	call   41f <sbrk>
  if(p == (char*)-1)
 7c9:	83 c4 10             	add    $0x10,%esp
 7cc:	83 f8 ff             	cmp    $0xffffffff,%eax
 7cf:	75 c0                	jne    791 <malloc+0x8a>
        return 0;
 7d1:	b8 00 00 00 00       	mov    $0x0,%eax
 7d6:	eb ab                	jmp    783 <malloc+0x7c>
 7d8:	b8 00 00 00 00       	mov    $0x0,%eax
 7dd:	eb a4                	jmp    783 <malloc+0x7c>
