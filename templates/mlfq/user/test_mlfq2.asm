
user/_test_mlfq2:     file format elf32-i386


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
  13:	e8 6b 03 00 00       	call   383 <getpid>
	float dummy = 0;
	int i,j,k;
	printf(1, "=== TEST START ===\n");
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	68 50 07 00 00       	push   $0x750
  20:	6a 01                	push   $0x1
  22:	e8 0e 04 00 00       	call   435 <printf>

	pid = fork();
  27:	e8 cf 02 00 00       	call   2fb <fork>
	if(pid == 0)
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	0f 85 97 00 00 00    	jne    ce <main+0xce>
  37:	bb 05 00 00 00       	mov    $0x5,%ebx
	{
			for(k=0; k<5; k++)
			{
				sleep(5);
  3c:	83 ec 0c             	sub    $0xc,%esp
  3f:	6a 05                	push   $0x5
  41:	e8 4d 03 00 00       	call   393 <sleep>
				pid = fork();
  46:	e8 b0 02 00 00       	call   2fb <fork>
  4b:	89 c6                	mov    %eax,%esi
				if(pid == 0)
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	74 0f                	je     63 <main+0x63>
						printf(1, "P2 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
					}
					exit();
				}
				else{
					wait();
  54:	e8 b2 02 00 00       	call   30b <wait>
			for(k=0; k<5; k++)
  59:	83 eb 01             	sub    $0x1,%ebx
  5c:	75 de                	jne    3c <main+0x3c>
				}
			}
			exit();
  5e:	e8 a0 02 00 00       	call   303 <exit>
					printf(1, "P2 ARRIVED\n");
  63:	83 ec 08             	sub    $0x8,%esp
  66:	68 64 07 00 00       	push   $0x764
  6b:	6a 01                	push   $0x1
  6d:	e8 c3 03 00 00       	call   435 <printf>
  72:	83 c4 10             	add    $0x10,%esp
					for(i=0; i<STOP_POINT; i++)
  75:	89 f3                	mov    %esi,%ebx
	float dummy = 0;
  77:	d9 ee                	fldz   
  79:	d9 5d e0             	fstps  -0x20(%ebp)
						for(j=0; j<STOP_POINT; j++)
  7c:	89 f0                	mov    %esi,%eax
								dummy += PI*j;
  7e:	dd 05 d0 07 00 00    	fldl   0x7d0
  84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  87:	db 45 dc             	fildl  -0x24(%ebp)
  8a:	d8 c9                	fmul   %st(1),%st
  8c:	d8 45 e0             	fadds  -0x20(%ebp)
  8f:	d9 5d e0             	fstps  -0x20(%ebp)
						for(j=0; j<STOP_POINT; j++)
  92:	83 c0 01             	add    $0x1,%eax
  95:	83 f8 14             	cmp    $0x14,%eax
  98:	75 ea                	jne    84 <main+0x84>
  9a:	dd d8                	fstp   %st(0)
						int lev = getlevel();
  9c:	e8 02 03 00 00       	call   3a3 <getlevel>
						printf(1, "P2 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
  a1:	83 ec 10             	sub    $0x10,%esp
  a4:	d9 45 e0             	flds   -0x20(%ebp)
  a7:	dd 1c 24             	fstpl  (%esp)
  aa:	53                   	push   %ebx
  ab:	ff 34 85 50 0a 00 00 	pushl  0xa50(,%eax,4)
  b2:	68 70 07 00 00       	push   $0x770
  b7:	6a 01                	push   $0x1
  b9:	e8 77 03 00 00       	call   435 <printf>
					for(i=0; i<STOP_POINT; i++)
  be:	83 c3 01             	add    $0x1,%ebx
  c1:	83 c4 20             	add    $0x20,%esp
  c4:	83 fb 14             	cmp    $0x14,%ebx
  c7:	75 b3                	jne    7c <main+0x7c>
					exit();
  c9:	e8 35 02 00 00       	call   303 <exit>
	}
	else
	{
		for (i=0; i< OUTER_LOOP; i++){    // p1: 20 ~ 30
  ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	float dummy = 0;
  d3:	d9 ee                	fldz   
  d5:	d9 5d e0             	fstps  -0x20(%ebp)
			for (j=0; j<INNER_LOOP; j++)
  d8:	b8 00 00 00 00       	mov    $0x0,%eax
					dummy += PI*j;
  dd:	dd 05 d0 07 00 00    	fldl   0x7d0
  e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  e6:	db 45 dc             	fildl  -0x24(%ebp)
  e9:	d8 c9                	fmul   %st(1),%st
  eb:	d8 45 e0             	fadds  -0x20(%ebp)
  ee:	d9 5d e0             	fstps  -0x20(%ebp)
			for (j=0; j<INNER_LOOP; j++)
  f1:	83 c0 01             	add    $0x1,%eax
  f4:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
  f9:	75 e8                	jne    e3 <main+0xe3>
  fb:	dd d8                	fstp   %st(0)
			int lev = getlevel();
  fd:	e8 a1 02 00 00       	call   3a3 <getlevel>
			printf(1, "P1 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
 102:	83 ec 10             	sub    $0x10,%esp
 105:	d9 45 e0             	flds   -0x20(%ebp)
 108:	dd 1c 24             	fstpl  (%esp)
 10b:	53                   	push   %ebx
 10c:	ff 34 85 50 0a 00 00 	pushl  0xa50(,%eax,4)
 113:	68 8d 07 00 00       	push   $0x78d
 118:	6a 01                	push   $0x1
 11a:	e8 16 03 00 00       	call   435 <printf>
		for (i=0; i< OUTER_LOOP; i++){    // p1: 20 ~ 30
 11f:	83 c3 01             	add    $0x1,%ebx
 122:	83 c4 20             	add    $0x20,%esp
 125:	83 fb 1e             	cmp    $0x1e,%ebx
 128:	75 ae                	jne    d8 <main+0xd8>
		}
		wait();
 12a:	e8 dc 01 00 00       	call   30b <wait>
		printf(1, "=== TEST DONE ===\n");
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	68 aa 07 00 00       	push   $0x7aa
 137:	6a 01                	push   $0x1
 139:	e8 f7 02 00 00       	call   435 <printf>
	}
	exit();
 13e:	e8 c0 01 00 00       	call   303 <exit>

00000143 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	53                   	push   %ebx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14d:	89 c2                	mov    %eax,%edx
 14f:	83 c1 01             	add    $0x1,%ecx
 152:	83 c2 01             	add    $0x1,%edx
 155:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 159:	88 5a ff             	mov    %bl,-0x1(%edx)
 15c:	84 db                	test   %bl,%bl
 15e:	75 ef                	jne    14f <strcpy+0xc>
    ;
  return os;
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	8b 4d 08             	mov    0x8(%ebp),%ecx
 169:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16c:	0f b6 01             	movzbl (%ecx),%eax
 16f:	84 c0                	test   %al,%al
 171:	74 15                	je     188 <strcmp+0x25>
 173:	3a 02                	cmp    (%edx),%al
 175:	75 11                	jne    188 <strcmp+0x25>
    p++, q++;
 177:	83 c1 01             	add    $0x1,%ecx
 17a:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 17d:	0f b6 01             	movzbl (%ecx),%eax
 180:	84 c0                	test   %al,%al
 182:	74 04                	je     188 <strcmp+0x25>
 184:	3a 02                	cmp    (%edx),%al
 186:	74 ef                	je     177 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 188:	0f b6 c0             	movzbl %al,%eax
 18b:	0f b6 12             	movzbl (%edx),%edx
 18e:	29 d0                	sub    %edx,%eax
}
 190:	5d                   	pop    %ebp
 191:	c3                   	ret    

00000192 <strlen>:

uint
strlen(const char *s)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 198:	80 39 00             	cmpb   $0x0,(%ecx)
 19b:	74 12                	je     1af <strlen+0x1d>
 19d:	ba 00 00 00 00       	mov    $0x0,%edx
 1a2:	83 c2 01             	add    $0x1,%edx
 1a5:	89 d0                	mov    %edx,%eax
 1a7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1ab:	75 f5                	jne    1a2 <strlen+0x10>
    ;
  return n;
}
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1af:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1b4:	eb f7                	jmp    1ad <strlen+0x1b>

000001b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	57                   	push   %edi
 1ba:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	fc                   	cld    
 1c6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c8:	89 d0                	mov    %edx,%eax
 1ca:	5f                   	pop    %edi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    

000001cd <strchr>:

char*
strchr(const char *s, char c)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	53                   	push   %ebx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1d7:	0f b6 10             	movzbl (%eax),%edx
 1da:	84 d2                	test   %dl,%dl
 1dc:	74 1e                	je     1fc <strchr+0x2f>
 1de:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 1e0:	38 d3                	cmp    %dl,%bl
 1e2:	74 15                	je     1f9 <strchr+0x2c>
  for(; *s; s++)
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	74 06                	je     1f4 <strchr+0x27>
    if(*s == c)
 1ee:	38 ca                	cmp    %cl,%dl
 1f0:	75 f2                	jne    1e4 <strchr+0x17>
 1f2:	eb 05                	jmp    1f9 <strchr+0x2c>
      return (char*)s;
  return 0;
 1f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f9:	5b                   	pop    %ebx
 1fa:	5d                   	pop    %ebp
 1fb:	c3                   	ret    
  return 0;
 1fc:	b8 00 00 00 00       	mov    $0x0,%eax
 201:	eb f6                	jmp    1f9 <strchr+0x2c>

00000203 <gets>:

char*
gets(char *buf, int max)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	57                   	push   %edi
 207:	56                   	push   %esi
 208:	53                   	push   %ebx
 209:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20c:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 211:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 214:	8d 5e 01             	lea    0x1(%esi),%ebx
 217:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21a:	7d 2b                	jge    247 <gets+0x44>
    cc = read(0, &c, 1);
 21c:	83 ec 04             	sub    $0x4,%esp
 21f:	6a 01                	push   $0x1
 221:	57                   	push   %edi
 222:	6a 00                	push   $0x0
 224:	e8 f2 00 00 00       	call   31b <read>
    if(cc < 1)
 229:	83 c4 10             	add    $0x10,%esp
 22c:	85 c0                	test   %eax,%eax
 22e:	7e 17                	jle    247 <gets+0x44>
      break;
    buf[i++] = c;
 230:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 234:	8b 55 08             	mov    0x8(%ebp),%edx
 237:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 23b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 23d:	3c 0a                	cmp    $0xa,%al
 23f:	74 04                	je     245 <gets+0x42>
 241:	3c 0d                	cmp    $0xd,%al
 243:	75 cf                	jne    214 <gets+0x11>
  for(i=0; i+1 < max; ){
 245:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 24e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 251:	5b                   	pop    %ebx
 252:	5e                   	pop    %esi
 253:	5f                   	pop    %edi
 254:	5d                   	pop    %ebp
 255:	c3                   	ret    

00000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	56                   	push   %esi
 25a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25b:	83 ec 08             	sub    $0x8,%esp
 25e:	6a 00                	push   $0x0
 260:	ff 75 08             	pushl  0x8(%ebp)
 263:	e8 db 00 00 00       	call   343 <open>
  if(fd < 0)
 268:	83 c4 10             	add    $0x10,%esp
 26b:	85 c0                	test   %eax,%eax
 26d:	78 24                	js     293 <stat+0x3d>
 26f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 271:	83 ec 08             	sub    $0x8,%esp
 274:	ff 75 0c             	pushl  0xc(%ebp)
 277:	50                   	push   %eax
 278:	e8 de 00 00 00       	call   35b <fstat>
 27d:	89 c6                	mov    %eax,%esi
  close(fd);
 27f:	89 1c 24             	mov    %ebx,(%esp)
 282:	e8 a4 00 00 00       	call   32b <close>
  return r;
 287:	83 c4 10             	add    $0x10,%esp
}
 28a:	89 f0                	mov    %esi,%eax
 28c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28f:	5b                   	pop    %ebx
 290:	5e                   	pop    %esi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
    return -1;
 293:	be ff ff ff ff       	mov    $0xffffffff,%esi
 298:	eb f0                	jmp    28a <stat+0x34>

0000029a <atoi>:

int
atoi(const char *s)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	53                   	push   %ebx
 29e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a1:	0f b6 11             	movzbl (%ecx),%edx
 2a4:	8d 42 d0             	lea    -0x30(%edx),%eax
 2a7:	3c 09                	cmp    $0x9,%al
 2a9:	77 20                	ja     2cb <atoi+0x31>
  n = 0;
 2ab:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2b0:	83 c1 01             	add    $0x1,%ecx
 2b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2b6:	0f be d2             	movsbl %dl,%edx
 2b9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2bd:	0f b6 11             	movzbl (%ecx),%edx
 2c0:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2c3:	80 fb 09             	cmp    $0x9,%bl
 2c6:	76 e8                	jbe    2b0 <atoi+0x16>
  return n;
}
 2c8:	5b                   	pop    %ebx
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
  n = 0;
 2cb:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 2d0:	eb f6                	jmp    2c8 <atoi+0x2e>

000002d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	56                   	push   %esi
 2d6:	53                   	push   %ebx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8b 75 0c             	mov    0xc(%ebp),%esi
 2dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e0:	85 db                	test   %ebx,%ebx
 2e2:	7e 13                	jle    2f7 <memmove+0x25>
 2e4:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2e9:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2f0:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2f3:	39 d3                	cmp    %edx,%ebx
 2f5:	75 f2                	jne    2e9 <memmove+0x17>
  return vdst;
}
 2f7:	5b                   	pop    %ebx
 2f8:	5e                   	pop    %esi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    

000002fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fb:	b8 01 00 00 00       	mov    $0x1,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exit>:
SYSCALL(exit)
 303:	b8 02 00 00 00       	mov    $0x2,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <wait>:
SYSCALL(wait)
 30b:	b8 03 00 00 00       	mov    $0x3,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <pipe>:
SYSCALL(pipe)
 313:	b8 04 00 00 00       	mov    $0x4,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <read>:
SYSCALL(read)
 31b:	b8 05 00 00 00       	mov    $0x5,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <write>:
SYSCALL(write)
 323:	b8 10 00 00 00       	mov    $0x10,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <close>:
SYSCALL(close)
 32b:	b8 15 00 00 00       	mov    $0x15,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <kill>:
SYSCALL(kill)
 333:	b8 06 00 00 00       	mov    $0x6,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <exec>:
SYSCALL(exec)
 33b:	b8 07 00 00 00       	mov    $0x7,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <open>:
SYSCALL(open)
 343:	b8 0f 00 00 00       	mov    $0xf,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <mknod>:
SYSCALL(mknod)
 34b:	b8 11 00 00 00       	mov    $0x11,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <unlink>:
SYSCALL(unlink)
 353:	b8 12 00 00 00       	mov    $0x12,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <fstat>:
SYSCALL(fstat)
 35b:	b8 08 00 00 00       	mov    $0x8,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <link>:
SYSCALL(link)
 363:	b8 13 00 00 00       	mov    $0x13,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mkdir>:
SYSCALL(mkdir)
 36b:	b8 14 00 00 00       	mov    $0x14,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <chdir>:
SYSCALL(chdir)
 373:	b8 09 00 00 00       	mov    $0x9,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <dup>:
SYSCALL(dup)
 37b:	b8 0a 00 00 00       	mov    $0xa,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getpid>:
SYSCALL(getpid)
 383:	b8 0b 00 00 00       	mov    $0xb,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sbrk>:
SYSCALL(sbrk)
 38b:	b8 0c 00 00 00       	mov    $0xc,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <sleep>:
SYSCALL(sleep)
 393:	b8 0d 00 00 00       	mov    $0xd,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <uptime>:
SYSCALL(uptime)
 39b:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getlevel>:
SYSCALL(getlevel)
 3a3:	b8 16 00 00 00       	mov    $0x16,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	57                   	push   %edi
 3af:	56                   	push   %esi
 3b0:	53                   	push   %ebx
 3b1:	83 ec 3c             	sub    $0x3c,%esp
 3b4:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ba:	74 14                	je     3d0 <printint+0x25>
 3bc:	85 d2                	test   %edx,%edx
 3be:	79 10                	jns    3d0 <printint+0x25>
    neg = 1;
    x = -xx;
 3c0:	f7 da                	neg    %edx
    neg = 1;
 3c2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c9:	bf 00 00 00 00       	mov    $0x0,%edi
 3ce:	eb 0b                	jmp    3db <printint+0x30>
  neg = 0;
 3d0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3d7:	eb f0                	jmp    3c9 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3d9:	89 df                	mov    %ebx,%edi
 3db:	8d 5f 01             	lea    0x1(%edi),%ebx
 3de:	89 d0                	mov    %edx,%eax
 3e0:	ba 00 00 00 00       	mov    $0x0,%edx
 3e5:	f7 f1                	div    %ecx
 3e7:	0f b6 92 e0 07 00 00 	movzbl 0x7e0(%edx),%edx
 3ee:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3f2:	89 c2                	mov    %eax,%edx
 3f4:	85 c0                	test   %eax,%eax
 3f6:	75 e1                	jne    3d9 <printint+0x2e>
  if(neg)
 3f8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3fc:	74 08                	je     406 <printint+0x5b>
    buf[i++] = '-';
 3fe:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 403:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 406:	83 eb 01             	sub    $0x1,%ebx
 409:	78 22                	js     42d <printint+0x82>
  write(fd, &c, 1);
 40b:	8d 7d d7             	lea    -0x29(%ebp),%edi
 40e:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 413:	88 45 d7             	mov    %al,-0x29(%ebp)
 416:	83 ec 04             	sub    $0x4,%esp
 419:	6a 01                	push   $0x1
 41b:	57                   	push   %edi
 41c:	56                   	push   %esi
 41d:	e8 01 ff ff ff       	call   323 <write>
  while(--i >= 0)
 422:	83 eb 01             	sub    $0x1,%ebx
 425:	83 c4 10             	add    $0x10,%esp
 428:	83 fb ff             	cmp    $0xffffffff,%ebx
 42b:	75 e1                	jne    40e <printint+0x63>
    putc(fd, buf[i]);
}
 42d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 430:	5b                   	pop    %ebx
 431:	5e                   	pop    %esi
 432:	5f                   	pop    %edi
 433:	5d                   	pop    %ebp
 434:	c3                   	ret    

00000435 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
 438:	57                   	push   %edi
 439:	56                   	push   %esi
 43a:	53                   	push   %ebx
 43b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 43e:	8b 75 0c             	mov    0xc(%ebp),%esi
 441:	0f b6 1e             	movzbl (%esi),%ebx
 444:	84 db                	test   %bl,%bl
 446:	0f 84 b1 01 00 00    	je     5fd <printf+0x1c8>
 44c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 44f:	8d 45 10             	lea    0x10(%ebp),%eax
 452:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 455:	bf 00 00 00 00       	mov    $0x0,%edi
 45a:	eb 2d                	jmp    489 <printf+0x54>
 45c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 45f:	83 ec 04             	sub    $0x4,%esp
 462:	6a 01                	push   $0x1
 464:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 467:	50                   	push   %eax
 468:	ff 75 08             	pushl  0x8(%ebp)
 46b:	e8 b3 fe ff ff       	call   323 <write>
 470:	83 c4 10             	add    $0x10,%esp
 473:	eb 05                	jmp    47a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 475:	83 ff 25             	cmp    $0x25,%edi
 478:	74 22                	je     49c <printf+0x67>
 47a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 47d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 481:	84 db                	test   %bl,%bl
 483:	0f 84 74 01 00 00    	je     5fd <printf+0x1c8>
    c = fmt[i] & 0xff;
 489:	0f be d3             	movsbl %bl,%edx
 48c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 48f:	85 ff                	test   %edi,%edi
 491:	75 e2                	jne    475 <printf+0x40>
      if(c == '%'){
 493:	83 f8 25             	cmp    $0x25,%eax
 496:	75 c4                	jne    45c <printf+0x27>
        state = '%';
 498:	89 c7                	mov    %eax,%edi
 49a:	eb de                	jmp    47a <printf+0x45>
      if(c == 'd'){
 49c:	83 f8 64             	cmp    $0x64,%eax
 49f:	74 59                	je     4fa <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a1:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4a7:	83 fa 70             	cmp    $0x70,%edx
 4aa:	74 7a                	je     526 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ac:	83 f8 73             	cmp    $0x73,%eax
 4af:	0f 84 9d 00 00 00    	je     552 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b5:	83 f8 63             	cmp    $0x63,%eax
 4b8:	0f 84 f2 00 00 00    	je     5b0 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4be:	83 f8 25             	cmp    $0x25,%eax
 4c1:	0f 84 15 01 00 00    	je     5dc <printf+0x1a7>
 4c7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	6a 01                	push   $0x1
 4d0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d3:	50                   	push   %eax
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 47 fe ff ff       	call   323 <write>
 4dc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4df:	83 c4 0c             	add    $0xc,%esp
 4e2:	6a 01                	push   $0x1
 4e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4e7:	50                   	push   %eax
 4e8:	ff 75 08             	pushl  0x8(%ebp)
 4eb:	e8 33 fe ff ff       	call   323 <write>
 4f0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f3:	bf 00 00 00 00       	mov    $0x0,%edi
 4f8:	eb 80                	jmp    47a <printf+0x45>
        printint(fd, *ap, 10, 1);
 4fa:	83 ec 0c             	sub    $0xc,%esp
 4fd:	6a 01                	push   $0x1
 4ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
 504:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 507:	8b 17                	mov    (%edi),%edx
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	e8 9a fe ff ff       	call   3ab <printint>
        ap++;
 511:	89 f8                	mov    %edi,%eax
 513:	83 c0 04             	add    $0x4,%eax
 516:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 519:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51c:	bf 00 00 00 00       	mov    $0x0,%edi
 521:	e9 54 ff ff ff       	jmp    47a <printf+0x45>
        printint(fd, *ap, 16, 0);
 526:	83 ec 0c             	sub    $0xc,%esp
 529:	6a 00                	push   $0x0
 52b:	b9 10 00 00 00       	mov    $0x10,%ecx
 530:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 533:	8b 17                	mov    (%edi),%edx
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	e8 6e fe ff ff       	call   3ab <printint>
        ap++;
 53d:	89 f8                	mov    %edi,%eax
 53f:	83 c0 04             	add    $0x4,%eax
 542:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 545:	83 c4 10             	add    $0x10,%esp
      state = 0;
 548:	bf 00 00 00 00       	mov    $0x0,%edi
 54d:	e9 28 ff ff ff       	jmp    47a <printf+0x45>
        s = (char*)*ap;
 552:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 555:	8b 01                	mov    (%ecx),%eax
        ap++;
 557:	83 c1 04             	add    $0x4,%ecx
 55a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 55d:	85 c0                	test   %eax,%eax
 55f:	74 13                	je     574 <printf+0x13f>
        s = (char*)*ap;
 561:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 563:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 566:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 56b:	84 c0                	test   %al,%al
 56d:	75 0f                	jne    57e <printf+0x149>
 56f:	e9 06 ff ff ff       	jmp    47a <printf+0x45>
          s = "(null)";
 574:	bb d8 07 00 00       	mov    $0x7d8,%ebx
        while(*s != 0){
 579:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 57e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 581:	89 75 d0             	mov    %esi,-0x30(%ebp)
 584:	8b 75 08             	mov    0x8(%ebp),%esi
 587:	88 45 e3             	mov    %al,-0x1d(%ebp)
 58a:	83 ec 04             	sub    $0x4,%esp
 58d:	6a 01                	push   $0x1
 58f:	57                   	push   %edi
 590:	56                   	push   %esi
 591:	e8 8d fd ff ff       	call   323 <write>
          s++;
 596:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 599:	0f b6 03             	movzbl (%ebx),%eax
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	84 c0                	test   %al,%al
 5a1:	75 e4                	jne    587 <printf+0x152>
 5a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5a6:	bf 00 00 00 00       	mov    $0x0,%edi
 5ab:	e9 ca fe ff ff       	jmp    47a <printf+0x45>
        putc(fd, *ap);
 5b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5b3:	8b 07                	mov    (%edi),%eax
 5b5:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5b8:	83 ec 04             	sub    $0x4,%esp
 5bb:	6a 01                	push   $0x1
 5bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 5a fd ff ff       	call   323 <write>
        ap++;
 5c9:	83 c7 04             	add    $0x4,%edi
 5cc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5cf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d2:	bf 00 00 00 00       	mov    $0x0,%edi
 5d7:	e9 9e fe ff ff       	jmp    47a <printf+0x45>
 5dc:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5df:	83 ec 04             	sub    $0x4,%esp
 5e2:	6a 01                	push   $0x1
 5e4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 33 fd ff ff       	call   323 <write>
 5f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5f3:	bf 00 00 00 00       	mov    $0x0,%edi
 5f8:	e9 7d fe ff ff       	jmp    47a <printf+0x45>
    }
  }
}
 5fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 600:	5b                   	pop    %ebx
 601:	5e                   	pop    %esi
 602:	5f                   	pop    %edi
 603:	5d                   	pop    %ebp
 604:	c3                   	ret    

00000605 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 605:	55                   	push   %ebp
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 616:	eb 0c                	jmp    624 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 618:	8b 10                	mov    (%eax),%edx
 61a:	39 c2                	cmp    %eax,%edx
 61c:	77 04                	ja     622 <free+0x1d>
 61e:	39 ca                	cmp    %ecx,%edx
 620:	77 10                	ja     632 <free+0x2d>
{
 622:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	39 c8                	cmp    %ecx,%eax
 626:	73 f0                	jae    618 <free+0x13>
 628:	8b 10                	mov    (%eax),%edx
 62a:	39 ca                	cmp    %ecx,%edx
 62c:	77 04                	ja     632 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	39 c2                	cmp    %eax,%edx
 630:	77 f0                	ja     622 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 632:	8b 73 fc             	mov    -0x4(%ebx),%esi
 635:	8b 10                	mov    (%eax),%edx
 637:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63a:	39 fa                	cmp    %edi,%edx
 63c:	74 19                	je     657 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 63e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 641:	8b 50 04             	mov    0x4(%eax),%edx
 644:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 647:	39 f1                	cmp    %esi,%ecx
 649:	74 1b                	je     666 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 64d:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 652:	5b                   	pop    %ebx
 653:	5e                   	pop    %esi
 654:	5f                   	pop    %edi
 655:	5d                   	pop    %ebp
 656:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 657:	03 72 04             	add    0x4(%edx),%esi
 65a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 65d:	8b 10                	mov    (%eax),%edx
 65f:	8b 12                	mov    (%edx),%edx
 661:	89 53 f8             	mov    %edx,-0x8(%ebx)
 664:	eb db                	jmp    641 <free+0x3c>
    p->s.size += bp->s.size;
 666:	03 53 fc             	add    -0x4(%ebx),%edx
 669:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 66c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 66f:	89 10                	mov    %edx,(%eax)
 671:	eb da                	jmp    64d <free+0x48>

00000673 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	57                   	push   %edi
 677:	56                   	push   %esi
 678:	53                   	push   %ebx
 679:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	8d 58 07             	lea    0x7(%eax),%ebx
 682:	c1 eb 03             	shr    $0x3,%ebx
 685:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 688:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
 68e:	85 d2                	test   %edx,%edx
 690:	74 20                	je     6b2 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 692:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 694:	8b 48 04             	mov    0x4(%eax),%ecx
 697:	39 cb                	cmp    %ecx,%ebx
 699:	76 3c                	jbe    6d7 <malloc+0x64>
 69b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6a1:	be 00 10 00 00       	mov    $0x1000,%esi
 6a6:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6a9:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6b0:	eb 70                	jmp    722 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6b2:	c7 05 5c 0a 00 00 60 	movl   $0xa60,0xa5c
 6b9:	0a 00 00 
 6bc:	c7 05 60 0a 00 00 60 	movl   $0xa60,0xa60
 6c3:	0a 00 00 
    base.s.size = 0;
 6c6:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 6cd:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6d0:	ba 60 0a 00 00       	mov    $0xa60,%edx
 6d5:	eb bb                	jmp    692 <malloc+0x1f>
      if(p->s.size == nunits)
 6d7:	39 cb                	cmp    %ecx,%ebx
 6d9:	74 1c                	je     6f7 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6db:	29 d9                	sub    %ebx,%ecx
 6dd:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6e0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6e3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6e6:	89 15 5c 0a 00 00    	mov    %edx,0xa5c
      return (void*)(p + 1);
 6ec:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f2:	5b                   	pop    %ebx
 6f3:	5e                   	pop    %esi
 6f4:	5f                   	pop    %edi
 6f5:	5d                   	pop    %ebp
 6f6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f7:	8b 08                	mov    (%eax),%ecx
 6f9:	89 0a                	mov    %ecx,(%edx)
 6fb:	eb e9                	jmp    6e6 <malloc+0x73>
  hp->s.size = nu;
 6fd:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	83 c0 08             	add    $0x8,%eax
 706:	50                   	push   %eax
 707:	e8 f9 fe ff ff       	call   605 <free>
  return freep;
 70c:	8b 15 5c 0a 00 00    	mov    0xa5c,%edx
      if((p = morecore(nunits)) == 0)
 712:	83 c4 10             	add    $0x10,%esp
 715:	85 d2                	test   %edx,%edx
 717:	74 2b                	je     744 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 719:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71b:	8b 48 04             	mov    0x4(%eax),%ecx
 71e:	39 d9                	cmp    %ebx,%ecx
 720:	73 b5                	jae    6d7 <malloc+0x64>
 722:	89 c2                	mov    %eax,%edx
    if(p == freep)
 724:	39 05 5c 0a 00 00    	cmp    %eax,0xa5c
 72a:	75 ed                	jne    719 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 72c:	83 ec 0c             	sub    $0xc,%esp
 72f:	57                   	push   %edi
 730:	e8 56 fc ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
 735:	83 c4 10             	add    $0x10,%esp
 738:	83 f8 ff             	cmp    $0xffffffff,%eax
 73b:	75 c0                	jne    6fd <malloc+0x8a>
        return 0;
 73d:	b8 00 00 00 00       	mov    $0x0,%eax
 742:	eb ab                	jmp    6ef <malloc+0x7c>
 744:	b8 00 00 00 00       	mov    $0x0,%eax
 749:	eb a4                	jmp    6ef <malloc+0x7c>
