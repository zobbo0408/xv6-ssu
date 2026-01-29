
user/_test_mlfq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
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
	int pid = getpid();
  13:	e8 6d 04 00 00       	call   485 <getpid>
	float dummy = 0;
	int i,j;
	printf(1, "=== TEST START ===\n");
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	68 50 08 00 00       	push   $0x850
  20:	6a 01                	push   $0x1
  22:	e8 10 05 00 00       	call   537 <printf>
	pid = fork();
  27:	e8 d1 03 00 00       	call   3fd <fork>
	if (pid == 0)	/* [P2] Child  */
  2c:	83 c4 10             	add    $0x10,%esp
			exit();
		}
	} 
	else	/* [P1] Parent */
	{
		for (i=0; i<STOP_POINT; i++)    // 0~ 19 loop
  2f:	bb 00 00 00 00       	mov    $0x0,%ebx
	float dummy = 0;
  34:	d9 ee                	fldz   
  36:	d9 5d e0             	fstps  -0x20(%ebp)
	if (pid == 0)	/* [P2] Child  */
  39:	85 c0                	test   %eax,%eax
  3b:	0f 84 d4 00 00 00    	je     115 <main+0x115>
		{
			for (j=0; j<INNER_LOOP; j++)
  41:	b8 00 00 00 00       	mov    $0x0,%eax
				dummy += PI*j;
  46:	dd 05 08 09 00 00    	fldl   0x908
  4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  4f:	db 45 dc             	fildl  -0x24(%ebp)
  52:	d8 c9                	fmul   %st(1),%st
  54:	d8 45 e0             	fadds  -0x20(%ebp)
  57:	d9 5d e0             	fstps  -0x20(%ebp)
			for (j=0; j<INNER_LOOP; j++)
  5a:	83 c0 01             	add    $0x1,%eax
  5d:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
  62:	75 e8                	jne    4c <main+0x4c>
  64:	dd d8                	fstp   %st(0)
			int lev = getlevel();
  66:	e8 3a 04 00 00       	call   4a5 <getlevel>

			printf(1, "P1 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
  6b:	83 ec 10             	sub    $0x10,%esp
  6e:	d9 45 e0             	flds   -0x20(%ebp)
  71:	dd 1c 24             	fstpl  (%esp)
  74:	53                   	push   %ebx
  75:	ff 34 85 88 0b 00 00 	pushl  0xb88(,%eax,4)
  7c:	68 9e 08 00 00       	push   $0x89e
  81:	6a 01                	push   $0x1
  83:	e8 af 04 00 00       	call   537 <printf>
		for (i=0; i<STOP_POINT; i++)    // 0~ 19 loop
  88:	83 c3 01             	add    $0x1,%ebx
  8b:	83 c4 20             	add    $0x20,%esp
  8e:	83 fb 14             	cmp    $0x14,%ebx
  91:	75 ae                	jne    41 <main+0x41>
		}
	
		pid = fork();
  93:	e8 65 03 00 00       	call   3fd <fork>
  98:	89 c6                	mov    %eax,%esi
		if(pid == 0){                       /* [P4] child --> high level queue (MLFQ)*/
  9a:	85 c0                	test   %eax,%eax
  9c:	0f 84 3b 01 00 00    	je     1dd <main+0x1dd>
			exit();
		}

		else{
			for (i=STOP_POINT; i< OUTER_LOOP; i++){    // p1: 20 ~
				for (j=0; j<INNER_LOOP; j++)
  a2:	b8 00 00 00 00       	mov    $0x0,%eax
					dummy += PI*j;
  a7:	dd 05 08 09 00 00    	fldl   0x908
  ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  b0:	db 45 dc             	fildl  -0x24(%ebp)
  b3:	d8 c9                	fmul   %st(1),%st
  b5:	d8 45 e0             	fadds  -0x20(%ebp)
  b8:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
  bb:	83 c0 01             	add    $0x1,%eax
  be:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
  c3:	75 e8                	jne    ad <main+0xad>
  c5:	dd d8                	fstp   %st(0)
				int lev = getlevel();
  c7:	e8 d9 03 00 00       	call   4a5 <getlevel>
				
				printf(1, "P1 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
  cc:	83 ec 10             	sub    $0x10,%esp
  cf:	d9 45 e0             	flds   -0x20(%ebp)
  d2:	dd 1c 24             	fstpl  (%esp)
  d5:	53                   	push   %ebx
  d6:	ff 34 85 88 0b 00 00 	pushl  0xb88(,%eax,4)
  dd:	68 9e 08 00 00       	push   $0x89e
  e2:	6a 01                	push   $0x1
  e4:	e8 4e 04 00 00       	call   537 <printf>
			for (i=STOP_POINT; i< OUTER_LOOP; i++){    // p1: 20 ~
  e9:	83 c3 01             	add    $0x1,%ebx
  ec:	83 c4 20             	add    $0x20,%esp
  ef:	83 fb 1e             	cmp    $0x1e,%ebx
  f2:	75 ae                	jne    a2 <main+0xa2>
			}
			wait();
  f4:	e8 14 03 00 00       	call   40d <wait>
		}
		
		wait();
  f9:	e8 0f 03 00 00       	call   40d <wait>
		printf(1, "=== TEST DONE ===\n");
  fe:	83 ec 08             	sub    $0x8,%esp
 101:	68 e4 08 00 00       	push   $0x8e4
 106:	6a 01                	push   $0x1
 108:	e8 2a 04 00 00       	call   537 <printf>
 10d:	83 c4 10             	add    $0x10,%esp
	}
	exit();
 110:	e8 f0 02 00 00       	call   405 <exit>
 115:	89 c6                	mov    %eax,%esi
		pid = fork();
 117:	e8 e1 02 00 00       	call   3fd <fork>
 11c:	89 c3                	mov    %eax,%ebx
		if (pid == 0) /* [P3] child-of-child */
 11e:	85 c0                	test   %eax,%eax
 120:	74 60                	je     182 <main+0x182>
			for (i=0; i<OUTER_LOOP; i++) // 0 ~ 30
 122:	89 f3                	mov    %esi,%ebx
	float dummy = 0;
 124:	d9 ee                	fldz   
 126:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
 129:	89 f0                	mov    %esi,%eax
					dummy += PI*j;
 12b:	dd 05 08 09 00 00    	fldl   0x908
 131:	89 45 dc             	mov    %eax,-0x24(%ebp)
 134:	db 45 dc             	fildl  -0x24(%ebp)
 137:	d8 c9                	fmul   %st(1),%st
 139:	d8 45 e0             	fadds  -0x20(%ebp)
 13c:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
 13f:	83 c0 01             	add    $0x1,%eax
 142:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
 147:	75 e8                	jne    131 <main+0x131>
 149:	dd d8                	fstp   %st(0)
				int lev = getlevel();
 14b:	e8 55 03 00 00       	call   4a5 <getlevel>
				printf(1, "P2 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
 150:	83 ec 10             	sub    $0x10,%esp
 153:	d9 45 e0             	flds   -0x20(%ebp)
 156:	dd 1c 24             	fstpl  (%esp)
 159:	53                   	push   %ebx
 15a:	ff 34 85 88 0b 00 00 	pushl  0xb88(,%eax,4)
 161:	68 81 08 00 00       	push   $0x881
 166:	6a 01                	push   $0x1
 168:	e8 ca 03 00 00       	call   537 <printf>
			for (i=0; i<OUTER_LOOP; i++) // 0 ~ 30
 16d:	83 c3 01             	add    $0x1,%ebx
 170:	83 c4 20             	add    $0x20,%esp
 173:	83 fb 1e             	cmp    $0x1e,%ebx
 176:	75 b1                	jne    129 <main+0x129>
			wait();
 178:	e8 90 02 00 00       	call   40d <wait>
			exit();
 17d:	e8 83 02 00 00       	call   405 <exit>
			for (i=0; i<OUTER_LOOP; i++)
 182:	89 c6                	mov    %eax,%esi
	float dummy = 0;
 184:	d9 ee                	fldz   
 186:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
 189:	89 d8                	mov    %ebx,%eax
					dummy += PI*j;
 18b:	dd 05 08 09 00 00    	fldl   0x908
 191:	89 45 dc             	mov    %eax,-0x24(%ebp)
 194:	db 45 dc             	fildl  -0x24(%ebp)
 197:	d8 c9                	fmul   %st(1),%st
 199:	d8 45 e0             	fadds  -0x20(%ebp)
 19c:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
 19f:	83 c0 01             	add    $0x1,%eax
 1a2:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
 1a7:	75 e8                	jne    191 <main+0x191>
 1a9:	dd d8                	fstp   %st(0)
				int lev = getlevel();
 1ab:	e8 f5 02 00 00       	call   4a5 <getlevel>
				printf(1, "P3 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
 1b0:	83 ec 10             	sub    $0x10,%esp
 1b3:	d9 45 e0             	flds   -0x20(%ebp)
 1b6:	dd 1c 24             	fstpl  (%esp)
 1b9:	56                   	push   %esi
 1ba:	ff 34 85 88 0b 00 00 	pushl  0xb88(,%eax,4)
 1c1:	68 64 08 00 00       	push   $0x864
 1c6:	6a 01                	push   $0x1
 1c8:	e8 6a 03 00 00       	call   537 <printf>
			for (i=0; i<OUTER_LOOP; i++)
 1cd:	83 c6 01             	add    $0x1,%esi
 1d0:	83 c4 20             	add    $0x20,%esp
 1d3:	83 fe 1e             	cmp    $0x1e,%esi
 1d6:	75 b1                	jne    189 <main+0x189>
 1d8:	e9 33 ff ff ff       	jmp    110 <main+0x110>
			printf(1,"P4 ARRIVED\n");
 1dd:	83 ec 08             	sub    $0x8,%esp
 1e0:	68 bb 08 00 00       	push   $0x8bb
 1e5:	6a 01                	push   $0x1
 1e7:	e8 4b 03 00 00       	call   537 <printf>
 1ec:	83 c4 10             	add    $0x10,%esp
			for (i=0; i<OUTER_LOOP; i++)
 1ef:	89 f3                	mov    %esi,%ebx
				for (j=0; j<INNER_LOOP; j++)
 1f1:	89 f0                	mov    %esi,%eax
					dummy += PI*j;
 1f3:	dd 05 08 09 00 00    	fldl   0x908
 1f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
 1fc:	db 45 dc             	fildl  -0x24(%ebp)
 1ff:	d8 c9                	fmul   %st(1),%st
 201:	d8 45 e0             	fadds  -0x20(%ebp)
 204:	d9 5d e0             	fstps  -0x20(%ebp)
				for (j=0; j<INNER_LOOP; j++)
 207:	83 c0 01             	add    $0x1,%eax
 20a:	3d 40 42 0f 00       	cmp    $0xf4240,%eax
 20f:	75 e8                	jne    1f9 <main+0x1f9>
 211:	dd d8                	fstp   %st(0)
				int lev = getlevel();
 213:	e8 8d 02 00 00       	call   4a5 <getlevel>
				printf(1, "P4 (%s), i = %d, dummy = %x\n", level[lev], i, dummy);
 218:	83 ec 10             	sub    $0x10,%esp
 21b:	d9 45 e0             	flds   -0x20(%ebp)
 21e:	dd 1c 24             	fstpl  (%esp)
 221:	53                   	push   %ebx
 222:	ff 34 85 88 0b 00 00 	pushl  0xb88(,%eax,4)
 229:	68 c7 08 00 00       	push   $0x8c7
 22e:	6a 01                	push   $0x1
 230:	e8 02 03 00 00       	call   537 <printf>
			for (i=0; i<OUTER_LOOP; i++)
 235:	83 c3 01             	add    $0x1,%ebx
 238:	83 c4 20             	add    $0x20,%esp
 23b:	83 fb 1e             	cmp    $0x1e,%ebx
 23e:	75 b1                	jne    1f1 <main+0x1f1>
			exit();
 240:	e8 c0 01 00 00       	call   405 <exit>

00000245 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	53                   	push   %ebx
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24f:	89 c2                	mov    %eax,%edx
 251:	83 c1 01             	add    $0x1,%ecx
 254:	83 c2 01             	add    $0x1,%edx
 257:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 25b:	88 5a ff             	mov    %bl,-0x1(%edx)
 25e:	84 db                	test   %bl,%bl
 260:	75 ef                	jne    251 <strcpy+0xc>
    ;
  return os;
}
 262:	5b                   	pop    %ebx
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    

00000265 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	8b 4d 08             	mov    0x8(%ebp),%ecx
 26b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 26e:	0f b6 01             	movzbl (%ecx),%eax
 271:	84 c0                	test   %al,%al
 273:	74 15                	je     28a <strcmp+0x25>
 275:	3a 02                	cmp    (%edx),%al
 277:	75 11                	jne    28a <strcmp+0x25>
    p++, q++;
 279:	83 c1 01             	add    $0x1,%ecx
 27c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 27f:	0f b6 01             	movzbl (%ecx),%eax
 282:	84 c0                	test   %al,%al
 284:	74 04                	je     28a <strcmp+0x25>
 286:	3a 02                	cmp    (%edx),%al
 288:	74 ef                	je     279 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 28a:	0f b6 c0             	movzbl %al,%eax
 28d:	0f b6 12             	movzbl (%edx),%edx
 290:	29 d0                	sub    %edx,%eax
}
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    

00000294 <strlen>:

uint
strlen(const char *s)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 29a:	80 39 00             	cmpb   $0x0,(%ecx)
 29d:	74 12                	je     2b1 <strlen+0x1d>
 29f:	ba 00 00 00 00       	mov    $0x0,%edx
 2a4:	83 c2 01             	add    $0x1,%edx
 2a7:	89 d0                	mov    %edx,%eax
 2a9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2ad:	75 f5                	jne    2a4 <strlen+0x10>
    ;
  return n;
}
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    
  for(n = 0; s[n]; n++)
 2b1:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 2b6:	eb f7                	jmp    2af <strlen+0x1b>

000002b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	57                   	push   %edi
 2bc:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2bf:	89 d7                	mov    %edx,%edi
 2c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	fc                   	cld    
 2c8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2ca:	89 d0                	mov    %edx,%eax
 2cc:	5f                   	pop    %edi
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    

000002cf <strchr>:

char*
strchr(const char *s, char c)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	53                   	push   %ebx
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2d9:	0f b6 10             	movzbl (%eax),%edx
 2dc:	84 d2                	test   %dl,%dl
 2de:	74 1e                	je     2fe <strchr+0x2f>
 2e0:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 2e2:	38 d3                	cmp    %dl,%bl
 2e4:	74 15                	je     2fb <strchr+0x2c>
  for(; *s; s++)
 2e6:	83 c0 01             	add    $0x1,%eax
 2e9:	0f b6 10             	movzbl (%eax),%edx
 2ec:	84 d2                	test   %dl,%dl
 2ee:	74 06                	je     2f6 <strchr+0x27>
    if(*s == c)
 2f0:	38 ca                	cmp    %cl,%dl
 2f2:	75 f2                	jne    2e6 <strchr+0x17>
 2f4:	eb 05                	jmp    2fb <strchr+0x2c>
      return (char*)s;
  return 0;
 2f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fb:	5b                   	pop    %ebx
 2fc:	5d                   	pop    %ebp
 2fd:	c3                   	ret    
  return 0;
 2fe:	b8 00 00 00 00       	mov    $0x0,%eax
 303:	eb f6                	jmp    2fb <strchr+0x2c>

00000305 <gets>:

char*
gets(char *buf, int max)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
 308:	57                   	push   %edi
 309:	56                   	push   %esi
 30a:	53                   	push   %ebx
 30b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30e:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 313:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 316:	8d 5e 01             	lea    0x1(%esi),%ebx
 319:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 31c:	7d 2b                	jge    349 <gets+0x44>
    cc = read(0, &c, 1);
 31e:	83 ec 04             	sub    $0x4,%esp
 321:	6a 01                	push   $0x1
 323:	57                   	push   %edi
 324:	6a 00                	push   $0x0
 326:	e8 f2 00 00 00       	call   41d <read>
    if(cc < 1)
 32b:	83 c4 10             	add    $0x10,%esp
 32e:	85 c0                	test   %eax,%eax
 330:	7e 17                	jle    349 <gets+0x44>
      break;
    buf[i++] = c;
 332:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 336:	8b 55 08             	mov    0x8(%ebp),%edx
 339:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 33d:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 33f:	3c 0a                	cmp    $0xa,%al
 341:	74 04                	je     347 <gets+0x42>
 343:	3c 0d                	cmp    $0xd,%al
 345:	75 cf                	jne    316 <gets+0x11>
  for(i=0; i+1 < max; ){
 347:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 350:	8d 65 f4             	lea    -0xc(%ebp),%esp
 353:	5b                   	pop    %ebx
 354:	5e                   	pop    %esi
 355:	5f                   	pop    %edi
 356:	5d                   	pop    %ebp
 357:	c3                   	ret    

00000358 <stat>:

int
stat(const char *n, struct stat *st)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	56                   	push   %esi
 35c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35d:	83 ec 08             	sub    $0x8,%esp
 360:	6a 00                	push   $0x0
 362:	ff 75 08             	pushl  0x8(%ebp)
 365:	e8 db 00 00 00       	call   445 <open>
  if(fd < 0)
 36a:	83 c4 10             	add    $0x10,%esp
 36d:	85 c0                	test   %eax,%eax
 36f:	78 24                	js     395 <stat+0x3d>
 371:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 373:	83 ec 08             	sub    $0x8,%esp
 376:	ff 75 0c             	pushl  0xc(%ebp)
 379:	50                   	push   %eax
 37a:	e8 de 00 00 00       	call   45d <fstat>
 37f:	89 c6                	mov    %eax,%esi
  close(fd);
 381:	89 1c 24             	mov    %ebx,(%esp)
 384:	e8 a4 00 00 00       	call   42d <close>
  return r;
 389:	83 c4 10             	add    $0x10,%esp
}
 38c:	89 f0                	mov    %esi,%eax
 38e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 391:	5b                   	pop    %ebx
 392:	5e                   	pop    %esi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret    
    return -1;
 395:	be ff ff ff ff       	mov    $0xffffffff,%esi
 39a:	eb f0                	jmp    38c <stat+0x34>

0000039c <atoi>:

int
atoi(const char *s)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	53                   	push   %ebx
 3a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a3:	0f b6 11             	movzbl (%ecx),%edx
 3a6:	8d 42 d0             	lea    -0x30(%edx),%eax
 3a9:	3c 09                	cmp    $0x9,%al
 3ab:	77 20                	ja     3cd <atoi+0x31>
  n = 0;
 3ad:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 3b2:	83 c1 01             	add    $0x1,%ecx
 3b5:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3b8:	0f be d2             	movsbl %dl,%edx
 3bb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 3bf:	0f b6 11             	movzbl (%ecx),%edx
 3c2:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3c5:	80 fb 09             	cmp    $0x9,%bl
 3c8:	76 e8                	jbe    3b2 <atoi+0x16>
  return n;
}
 3ca:	5b                   	pop    %ebx
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
  n = 0;
 3cd:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 3d2:	eb f6                	jmp    3ca <atoi+0x2e>

000003d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	56                   	push   %esi
 3d8:	53                   	push   %ebx
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	8b 75 0c             	mov    0xc(%ebp),%esi
 3df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e2:	85 db                	test   %ebx,%ebx
 3e4:	7e 13                	jle    3f9 <memmove+0x25>
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 3eb:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ef:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3f2:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3f5:	39 d3                	cmp    %edx,%ebx
 3f7:	75 f2                	jne    3eb <memmove+0x17>
  return vdst;
}
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    

000003fd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fd:	b8 01 00 00 00       	mov    $0x1,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <exit>:
SYSCALL(exit)
 405:	b8 02 00 00 00       	mov    $0x2,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <wait>:
SYSCALL(wait)
 40d:	b8 03 00 00 00       	mov    $0x3,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <pipe>:
SYSCALL(pipe)
 415:	b8 04 00 00 00       	mov    $0x4,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <read>:
SYSCALL(read)
 41d:	b8 05 00 00 00       	mov    $0x5,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <write>:
SYSCALL(write)
 425:	b8 10 00 00 00       	mov    $0x10,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <close>:
SYSCALL(close)
 42d:	b8 15 00 00 00       	mov    $0x15,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <kill>:
SYSCALL(kill)
 435:	b8 06 00 00 00       	mov    $0x6,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <exec>:
SYSCALL(exec)
 43d:	b8 07 00 00 00       	mov    $0x7,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <open>:
SYSCALL(open)
 445:	b8 0f 00 00 00       	mov    $0xf,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <mknod>:
SYSCALL(mknod)
 44d:	b8 11 00 00 00       	mov    $0x11,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <unlink>:
SYSCALL(unlink)
 455:	b8 12 00 00 00       	mov    $0x12,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <fstat>:
SYSCALL(fstat)
 45d:	b8 08 00 00 00       	mov    $0x8,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <link>:
SYSCALL(link)
 465:	b8 13 00 00 00       	mov    $0x13,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <mkdir>:
SYSCALL(mkdir)
 46d:	b8 14 00 00 00       	mov    $0x14,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <chdir>:
SYSCALL(chdir)
 475:	b8 09 00 00 00       	mov    $0x9,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <dup>:
SYSCALL(dup)
 47d:	b8 0a 00 00 00       	mov    $0xa,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <getpid>:
SYSCALL(getpid)
 485:	b8 0b 00 00 00       	mov    $0xb,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <sbrk>:
SYSCALL(sbrk)
 48d:	b8 0c 00 00 00       	mov    $0xc,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <sleep>:
SYSCALL(sleep)
 495:	b8 0d 00 00 00       	mov    $0xd,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <uptime>:
SYSCALL(uptime)
 49d:	b8 0e 00 00 00       	mov    $0xe,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <getlevel>:
SYSCALL(getlevel)
 4a5:	b8 16 00 00 00       	mov    $0x16,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4ad:	55                   	push   %ebp
 4ae:	89 e5                	mov    %esp,%ebp
 4b0:	57                   	push   %edi
 4b1:	56                   	push   %esi
 4b2:	53                   	push   %ebx
 4b3:	83 ec 3c             	sub    $0x3c,%esp
 4b6:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4bc:	74 14                	je     4d2 <printint+0x25>
 4be:	85 d2                	test   %edx,%edx
 4c0:	79 10                	jns    4d2 <printint+0x25>
    neg = 1;
    x = -xx;
 4c2:	f7 da                	neg    %edx
    neg = 1;
 4c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4cb:	bf 00 00 00 00       	mov    $0x0,%edi
 4d0:	eb 0b                	jmp    4dd <printint+0x30>
  neg = 0;
 4d2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4d9:	eb f0                	jmp    4cb <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 4db:	89 df                	mov    %ebx,%edi
 4dd:	8d 5f 01             	lea    0x1(%edi),%ebx
 4e0:	89 d0                	mov    %edx,%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 f1                	div    %ecx
 4e9:	0f b6 92 18 09 00 00 	movzbl 0x918(%edx),%edx
 4f0:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 4f4:	89 c2                	mov    %eax,%edx
 4f6:	85 c0                	test   %eax,%eax
 4f8:	75 e1                	jne    4db <printint+0x2e>
  if(neg)
 4fa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 4fe:	74 08                	je     508 <printint+0x5b>
    buf[i++] = '-';
 500:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 505:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 508:	83 eb 01             	sub    $0x1,%ebx
 50b:	78 22                	js     52f <printint+0x82>
  write(fd, &c, 1);
 50d:	8d 7d d7             	lea    -0x29(%ebp),%edi
 510:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 515:	88 45 d7             	mov    %al,-0x29(%ebp)
 518:	83 ec 04             	sub    $0x4,%esp
 51b:	6a 01                	push   $0x1
 51d:	57                   	push   %edi
 51e:	56                   	push   %esi
 51f:	e8 01 ff ff ff       	call   425 <write>
  while(--i >= 0)
 524:	83 eb 01             	sub    $0x1,%ebx
 527:	83 c4 10             	add    $0x10,%esp
 52a:	83 fb ff             	cmp    $0xffffffff,%ebx
 52d:	75 e1                	jne    510 <printint+0x63>
    putc(fd, buf[i]);
}
 52f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 532:	5b                   	pop    %ebx
 533:	5e                   	pop    %esi
 534:	5f                   	pop    %edi
 535:	5d                   	pop    %ebp
 536:	c3                   	ret    

00000537 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 537:	55                   	push   %ebp
 538:	89 e5                	mov    %esp,%ebp
 53a:	57                   	push   %edi
 53b:	56                   	push   %esi
 53c:	53                   	push   %ebx
 53d:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 540:	8b 75 0c             	mov    0xc(%ebp),%esi
 543:	0f b6 1e             	movzbl (%esi),%ebx
 546:	84 db                	test   %bl,%bl
 548:	0f 84 b1 01 00 00    	je     6ff <printf+0x1c8>
 54e:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 551:	8d 45 10             	lea    0x10(%ebp),%eax
 554:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 557:	bf 00 00 00 00       	mov    $0x0,%edi
 55c:	eb 2d                	jmp    58b <printf+0x54>
 55e:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 561:	83 ec 04             	sub    $0x4,%esp
 564:	6a 01                	push   $0x1
 566:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 569:	50                   	push   %eax
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 b3 fe ff ff       	call   425 <write>
 572:	83 c4 10             	add    $0x10,%esp
 575:	eb 05                	jmp    57c <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 577:	83 ff 25             	cmp    $0x25,%edi
 57a:	74 22                	je     59e <printf+0x67>
 57c:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 57f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 583:	84 db                	test   %bl,%bl
 585:	0f 84 74 01 00 00    	je     6ff <printf+0x1c8>
    c = fmt[i] & 0xff;
 58b:	0f be d3             	movsbl %bl,%edx
 58e:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 591:	85 ff                	test   %edi,%edi
 593:	75 e2                	jne    577 <printf+0x40>
      if(c == '%'){
 595:	83 f8 25             	cmp    $0x25,%eax
 598:	75 c4                	jne    55e <printf+0x27>
        state = '%';
 59a:	89 c7                	mov    %eax,%edi
 59c:	eb de                	jmp    57c <printf+0x45>
      if(c == 'd'){
 59e:	83 f8 64             	cmp    $0x64,%eax
 5a1:	74 59                	je     5fc <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5a3:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 5a9:	83 fa 70             	cmp    $0x70,%edx
 5ac:	74 7a                	je     628 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5ae:	83 f8 73             	cmp    $0x73,%eax
 5b1:	0f 84 9d 00 00 00    	je     654 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b7:	83 f8 63             	cmp    $0x63,%eax
 5ba:	0f 84 f2 00 00 00    	je     6b2 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5c0:	83 f8 25             	cmp    $0x25,%eax
 5c3:	0f 84 15 01 00 00    	je     6de <printf+0x1a7>
 5c9:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5cd:	83 ec 04             	sub    $0x4,%esp
 5d0:	6a 01                	push   $0x1
 5d2:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5d5:	50                   	push   %eax
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 47 fe ff ff       	call   425 <write>
 5de:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5e1:	83 c4 0c             	add    $0xc,%esp
 5e4:	6a 01                	push   $0x1
 5e6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 33 fe ff ff       	call   425 <write>
 5f2:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f5:	bf 00 00 00 00       	mov    $0x0,%edi
 5fa:	eb 80                	jmp    57c <printf+0x45>
        printint(fd, *ap, 10, 1);
 5fc:	83 ec 0c             	sub    $0xc,%esp
 5ff:	6a 01                	push   $0x1
 601:	b9 0a 00 00 00       	mov    $0xa,%ecx
 606:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 609:	8b 17                	mov    (%edi),%edx
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	e8 9a fe ff ff       	call   4ad <printint>
        ap++;
 613:	89 f8                	mov    %edi,%eax
 615:	83 c0 04             	add    $0x4,%eax
 618:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 61b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61e:	bf 00 00 00 00       	mov    $0x0,%edi
 623:	e9 54 ff ff ff       	jmp    57c <printf+0x45>
        printint(fd, *ap, 16, 0);
 628:	83 ec 0c             	sub    $0xc,%esp
 62b:	6a 00                	push   $0x0
 62d:	b9 10 00 00 00       	mov    $0x10,%ecx
 632:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 635:	8b 17                	mov    (%edi),%edx
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	e8 6e fe ff ff       	call   4ad <printint>
        ap++;
 63f:	89 f8                	mov    %edi,%eax
 641:	83 c0 04             	add    $0x4,%eax
 644:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 647:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64a:	bf 00 00 00 00       	mov    $0x0,%edi
 64f:	e9 28 ff ff ff       	jmp    57c <printf+0x45>
        s = (char*)*ap;
 654:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 657:	8b 01                	mov    (%ecx),%eax
        ap++;
 659:	83 c1 04             	add    $0x4,%ecx
 65c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 65f:	85 c0                	test   %eax,%eax
 661:	74 13                	je     676 <printf+0x13f>
        s = (char*)*ap;
 663:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 665:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 668:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 66d:	84 c0                	test   %al,%al
 66f:	75 0f                	jne    680 <printf+0x149>
 671:	e9 06 ff ff ff       	jmp    57c <printf+0x45>
          s = "(null)";
 676:	bb 10 09 00 00       	mov    $0x910,%ebx
        while(*s != 0){
 67b:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 680:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 683:	89 75 d0             	mov    %esi,-0x30(%ebp)
 686:	8b 75 08             	mov    0x8(%ebp),%esi
 689:	88 45 e3             	mov    %al,-0x1d(%ebp)
 68c:	83 ec 04             	sub    $0x4,%esp
 68f:	6a 01                	push   $0x1
 691:	57                   	push   %edi
 692:	56                   	push   %esi
 693:	e8 8d fd ff ff       	call   425 <write>
          s++;
 698:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 69b:	0f b6 03             	movzbl (%ebx),%eax
 69e:	83 c4 10             	add    $0x10,%esp
 6a1:	84 c0                	test   %al,%al
 6a3:	75 e4                	jne    689 <printf+0x152>
 6a5:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6a8:	bf 00 00 00 00       	mov    $0x0,%edi
 6ad:	e9 ca fe ff ff       	jmp    57c <printf+0x45>
        putc(fd, *ap);
 6b2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6b5:	8b 07                	mov    (%edi),%eax
 6b7:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6ba:	83 ec 04             	sub    $0x4,%esp
 6bd:	6a 01                	push   $0x1
 6bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6c2:	50                   	push   %eax
 6c3:	ff 75 08             	pushl  0x8(%ebp)
 6c6:	e8 5a fd ff ff       	call   425 <write>
        ap++;
 6cb:	83 c7 04             	add    $0x4,%edi
 6ce:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d4:	bf 00 00 00 00       	mov    $0x0,%edi
 6d9:	e9 9e fe ff ff       	jmp    57c <printf+0x45>
 6de:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 6e1:	83 ec 04             	sub    $0x4,%esp
 6e4:	6a 01                	push   $0x1
 6e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6e9:	50                   	push   %eax
 6ea:	ff 75 08             	pushl  0x8(%ebp)
 6ed:	e8 33 fd ff ff       	call   425 <write>
 6f2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f5:	bf 00 00 00 00       	mov    $0x0,%edi
 6fa:	e9 7d fe ff ff       	jmp    57c <printf+0x45>
    }
  }
}
 6ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 702:	5b                   	pop    %ebx
 703:	5e                   	pop    %esi
 704:	5f                   	pop    %edi
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    

00000707 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 707:	55                   	push   %ebp
 708:	89 e5                	mov    %esp,%ebp
 70a:	57                   	push   %edi
 70b:	56                   	push   %esi
 70c:	53                   	push   %ebx
 70d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 713:	a1 94 0b 00 00       	mov    0xb94,%eax
 718:	eb 0c                	jmp    726 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	8b 10                	mov    (%eax),%edx
 71c:	39 c2                	cmp    %eax,%edx
 71e:	77 04                	ja     724 <free+0x1d>
 720:	39 ca                	cmp    %ecx,%edx
 722:	77 10                	ja     734 <free+0x2d>
{
 724:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	39 c8                	cmp    %ecx,%eax
 728:	73 f0                	jae    71a <free+0x13>
 72a:	8b 10                	mov    (%eax),%edx
 72c:	39 ca                	cmp    %ecx,%edx
 72e:	77 04                	ja     734 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 c2                	cmp    %eax,%edx
 732:	77 f0                	ja     724 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 734:	8b 73 fc             	mov    -0x4(%ebx),%esi
 737:	8b 10                	mov    (%eax),%edx
 739:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73c:	39 fa                	cmp    %edi,%edx
 73e:	74 19                	je     759 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 740:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 749:	39 f1                	cmp    %esi,%ecx
 74b:	74 1b                	je     768 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 74d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 74f:	a3 94 0b 00 00       	mov    %eax,0xb94
}
 754:	5b                   	pop    %ebx
 755:	5e                   	pop    %esi
 756:	5f                   	pop    %edi
 757:	5d                   	pop    %ebp
 758:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 759:	03 72 04             	add    0x4(%edx),%esi
 75c:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 75f:	8b 10                	mov    (%eax),%edx
 761:	8b 12                	mov    (%edx),%edx
 763:	89 53 f8             	mov    %edx,-0x8(%ebx)
 766:	eb db                	jmp    743 <free+0x3c>
    p->s.size += bp->s.size;
 768:	03 53 fc             	add    -0x4(%ebx),%edx
 76b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 771:	89 10                	mov    %edx,(%eax)
 773:	eb da                	jmp    74f <free+0x48>

00000775 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	8d 58 07             	lea    0x7(%eax),%ebx
 784:	c1 eb 03             	shr    $0x3,%ebx
 787:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 78a:	8b 15 94 0b 00 00    	mov    0xb94,%edx
 790:	85 d2                	test   %edx,%edx
 792:	74 20                	je     7b4 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 796:	8b 48 04             	mov    0x4(%eax),%ecx
 799:	39 cb                	cmp    %ecx,%ebx
 79b:	76 3c                	jbe    7d9 <malloc+0x64>
 79d:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7a3:	be 00 10 00 00       	mov    $0x1000,%esi
 7a8:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 7ab:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 7b2:	eb 70                	jmp    824 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 7b4:	c7 05 94 0b 00 00 98 	movl   $0xb98,0xb94
 7bb:	0b 00 00 
 7be:	c7 05 98 0b 00 00 98 	movl   $0xb98,0xb98
 7c5:	0b 00 00 
    base.s.size = 0;
 7c8:	c7 05 9c 0b 00 00 00 	movl   $0x0,0xb9c
 7cf:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7d2:	ba 98 0b 00 00       	mov    $0xb98,%edx
 7d7:	eb bb                	jmp    794 <malloc+0x1f>
      if(p->s.size == nunits)
 7d9:	39 cb                	cmp    %ecx,%ebx
 7db:	74 1c                	je     7f9 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7dd:	29 d9                	sub    %ebx,%ecx
 7df:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7e2:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7e5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7e8:	89 15 94 0b 00 00    	mov    %edx,0xb94
      return (void*)(p + 1);
 7ee:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7f4:	5b                   	pop    %ebx
 7f5:	5e                   	pop    %esi
 7f6:	5f                   	pop    %edi
 7f7:	5d                   	pop    %ebp
 7f8:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7f9:	8b 08                	mov    (%eax),%ecx
 7fb:	89 0a                	mov    %ecx,(%edx)
 7fd:	eb e9                	jmp    7e8 <malloc+0x73>
  hp->s.size = nu;
 7ff:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 802:	83 ec 0c             	sub    $0xc,%esp
 805:	83 c0 08             	add    $0x8,%eax
 808:	50                   	push   %eax
 809:	e8 f9 fe ff ff       	call   707 <free>
  return freep;
 80e:	8b 15 94 0b 00 00    	mov    0xb94,%edx
      if((p = morecore(nunits)) == 0)
 814:	83 c4 10             	add    $0x10,%esp
 817:	85 d2                	test   %edx,%edx
 819:	74 2b                	je     846 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 81d:	8b 48 04             	mov    0x4(%eax),%ecx
 820:	39 d9                	cmp    %ebx,%ecx
 822:	73 b5                	jae    7d9 <malloc+0x64>
 824:	89 c2                	mov    %eax,%edx
    if(p == freep)
 826:	39 05 94 0b 00 00    	cmp    %eax,0xb94
 82c:	75 ed                	jne    81b <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 82e:	83 ec 0c             	sub    $0xc,%esp
 831:	57                   	push   %edi
 832:	e8 56 fc ff ff       	call   48d <sbrk>
  if(p == (char*)-1)
 837:	83 c4 10             	add    $0x10,%esp
 83a:	83 f8 ff             	cmp    $0xffffffff,%eax
 83d:	75 c0                	jne    7ff <malloc+0x8a>
        return 0;
 83f:	b8 00 00 00 00       	mov    $0x0,%eax
 844:	eb ab                	jmp    7f1 <malloc+0x7c>
 846:	b8 00 00 00 00       	mov    $0x0,%eax
 84b:	eb a4                	jmp    7f1 <malloc+0x7c>
