
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 80 10 00       	mov    $0x108000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 a5 10 80       	mov    $0x8010a5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 8b 2a 10 80       	mov    $0x80102a8b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 80 65 10 80       	push   $0x80106580
80100040:	68 c0 a5 10 80       	push   $0x8010a5c0
80100045:	e8 d0 3b 00 00       	call   80103c1a <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 0c ed 10 80 bc 	movl   $0x8010ecbc,0x8010ed0c
80100051:	ec 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 10 ed 10 80 bc 	movl   $0x8010ecbc,0x8010ed10
8010005b:	ec 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb f4 a5 10 80       	mov    $0x8010a5f4,%ebx
    b->next = bcache.head.next;
80100066:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 bc ec 10 80 	movl   $0x8010ecbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 87 65 10 80       	push   $0x80106587
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 8a 3a 00 00       	call   80103b10 <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d 10 ed 10 80    	mov    %ebx,0x8010ed10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
801000a3:	72 c1                	jb     80100066 <binit+0x32>
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000b9:	68 c0 a5 10 80       	push   $0x8010a5c0
801000be:	e8 9f 3c 00 00       	call   80103d62 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d 10 ed 10 80    	mov    0x8010ed10,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
801000d2:	75 26                	jne    801000fa <bread+0x50>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000d4:	8b 1d 0c ed 10 80    	mov    0x8010ed0c,%ebx
801000da:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
801000e0:	75 4e                	jne    80100130 <bread+0x86>
  panic("bget: no buffers");
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 8e 65 10 80       	push   $0x8010658e
801000ea:	e8 55 02 00 00       	call   80100344 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ef:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000f2:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
801000f8:	74 da                	je     801000d4 <bread+0x2a>
    if(b->dev == dev && b->blockno == blockno){
801000fa:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fd:	75 f0                	jne    801000ef <bread+0x45>
801000ff:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100102:	75 eb                	jne    801000ef <bread+0x45>
      b->refcnt++;
80100104:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 c0 a5 10 80       	push   $0x8010a5c0
80100110:	e8 b4 3c 00 00       	call   80103dc9 <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 23 3a 00 00       	call   80103b43 <acquiresleep>
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	eb 44                	jmp    80100169 <bread+0xbf>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100125:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100128:	81 fb bc ec 10 80    	cmp    $0x8010ecbc,%ebx
8010012e:	74 b2                	je     801000e2 <bread+0x38>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100130:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80100134:	75 ef                	jne    80100125 <bread+0x7b>
80100136:	f6 03 04             	testb  $0x4,(%ebx)
80100139:	75 ea                	jne    80100125 <bread+0x7b>
      b->dev = dev;
8010013b:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010013e:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100147:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	68 c0 a5 10 80       	push   $0x8010a5c0
80100156:	e8 6e 3c 00 00       	call   80103dc9 <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 dd 39 00 00       	call   80103b43 <acquiresleep>
80100166:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100169:	f6 03 02             	testb  $0x2,(%ebx)
8010016c:	74 0a                	je     80100178 <bread+0xce>
    iderw(b);
  }
  return b;
}
8010016e:	89 d8                	mov    %ebx,%eax
80100170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100173:	5b                   	pop    %ebx
80100174:	5e                   	pop    %esi
80100175:	5f                   	pop    %edi
80100176:	5d                   	pop    %ebp
80100177:	c3                   	ret    
    iderw(b);
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	53                   	push   %ebx
8010017c:	e8 0e 1d 00 00       	call   80101e8f <iderw>
80100181:	83 c4 10             	add    $0x10,%esp
  return b;
80100184:	eb e8                	jmp    8010016e <bread+0xc4>

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 37 3a 00 00       	call   80103bd0 <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	74 14                	je     801001b4 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a3:	83 ec 0c             	sub    $0xc,%esp
801001a6:	53                   	push   %ebx
801001a7:	e8 e3 1c 00 00       	call   80101e8f <iderw>
}
801001ac:	83 c4 10             	add    $0x10,%esp
801001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    
    panic("bwrite");
801001b4:	83 ec 0c             	sub    $0xc,%esp
801001b7:	68 9f 65 10 80       	push   $0x8010659f
801001bc:	e8 83 01 00 00       	call   80100344 <panic>

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 fb 39 00 00       	call   80103bd0 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 b0 39 00 00       	call   80103b95 <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
801001ec:	e8 71 3b 00 00       	call   80103d62 <acquire>
  b->refcnt--;
801001f1:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f4:	83 e8 01             	sub    $0x1,%eax
801001f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001fa:	83 c4 10             	add    $0x10,%esp
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 2f                	jne    80100230 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100201:	8b 43 54             	mov    0x54(%ebx),%eax
80100204:	8b 53 50             	mov    0x50(%ebx),%edx
80100207:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010020a:	8b 43 50             	mov    0x50(%ebx),%eax
8010020d:	8b 53 54             	mov    0x54(%ebx),%edx
80100210:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100213:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
80100218:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010021b:	c7 43 50 bc ec 10 80 	movl   $0x8010ecbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100222:	a1 10 ed 10 80       	mov    0x8010ed10,%eax
80100227:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010022a:	89 1d 10 ed 10 80    	mov    %ebx,0x8010ed10
  }
  
  release(&bcache.lock);
80100230:	83 ec 0c             	sub    $0xc,%esp
80100233:	68 c0 a5 10 80       	push   $0x8010a5c0
80100238:	e8 8c 3b 00 00       	call   80103dc9 <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 a6 65 10 80       	push   $0x801065a6
8010024f:	e8 f0 00 00 00       	call   80100344 <panic>

80100254 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100260:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100263:	ff 75 08             	pushl  0x8(%ebp)
80100266:	e8 3d 13 00 00       	call   801015a8 <iunlock>
  target = n;
8010026b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010026e:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
80100275:	e8 e8 3a 00 00       	call   80103d62 <acquire>
  while(n > 0){
8010027a:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010027d:	bb 20 ef 10 80       	mov    $0x8010ef20,%ebx
  while(n > 0){
80100282:	85 f6                	test   %esi,%esi
80100284:	7e 68                	jle    801002ee <consoleread+0x9a>
    while(input.r == input.w){
80100286:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010028c:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100292:	75 2e                	jne    801002c2 <consoleread+0x6e>
      if(myproc()->killed){
80100294:	e8 9b 30 00 00       	call   80103334 <myproc>
80100299:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010029d:	75 71                	jne    80100310 <consoleread+0xbc>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
8010029f:	83 ec 08             	sub    $0x8,%esp
801002a2:	68 20 95 10 80       	push   $0x80109520
801002a7:	68 a0 ef 10 80       	push   $0x8010efa0
801002ac:	e8 2f 35 00 00       	call   801037e0 <sleep>
    while(input.r == input.w){
801002b1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801002b7:	83 c4 10             	add    $0x10,%esp
801002ba:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801002c0:	74 d2                	je     80100294 <consoleread+0x40>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002c2:	8d 50 01             	lea    0x1(%eax),%edx
801002c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
801002cb:	89 c2                	mov    %eax,%edx
801002cd:	83 e2 7f             	and    $0x7f,%edx
801002d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801002d4:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002d7:	83 fa 04             	cmp    $0x4,%edx
801002da:	74 5c                	je     80100338 <consoleread+0xe4>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002dc:	83 c7 01             	add    $0x1,%edi
801002df:	88 4f ff             	mov    %cl,-0x1(%edi)
    --n;
801002e2:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002e5:	83 fa 0a             	cmp    $0xa,%edx
801002e8:	74 04                	je     801002ee <consoleread+0x9a>
  while(n > 0){
801002ea:	85 f6                	test   %esi,%esi
801002ec:	75 98                	jne    80100286 <consoleread+0x32>
      break;
  }
  release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 95 10 80       	push   $0x80109520
801002f6:	e8 ce 3a 00 00       	call   80103dc9 <release>
  ilock(ip);
801002fb:	83 c4 04             	add    $0x4,%esp
801002fe:	ff 75 08             	pushl  0x8(%ebp)
80100301:	e8 e0 11 00 00       	call   801014e6 <ilock>

  return target - n;
80100306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100309:	29 f0                	sub    %esi,%eax
8010030b:	83 c4 10             	add    $0x10,%esp
8010030e:	eb 20                	jmp    80100330 <consoleread+0xdc>
        release(&cons.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 20 95 10 80       	push   $0x80109520
80100318:	e8 ac 3a 00 00       	call   80103dc9 <release>
        ilock(ip);
8010031d:	83 c4 04             	add    $0x4,%esp
80100320:	ff 75 08             	pushl  0x8(%ebp)
80100323:	e8 be 11 00 00       	call   801014e6 <ilock>
        return -1;
80100328:	83 c4 10             	add    $0x10,%esp
8010032b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100333:	5b                   	pop    %ebx
80100334:	5e                   	pop    %esi
80100335:	5f                   	pop    %edi
80100336:	5d                   	pop    %ebp
80100337:	c3                   	ret    
      if(n < target){
80100338:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010033b:	73 b1                	jae    801002ee <consoleread+0x9a>
        input.r--;
8010033d:	a3 a0 ef 10 80       	mov    %eax,0x8010efa0
80100342:	eb aa                	jmp    801002ee <consoleread+0x9a>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	56                   	push   %esi
80100348:	53                   	push   %ebx
80100349:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034c:	fa                   	cli    
  cons.locking = 0;
8010034d:	c7 05 54 95 10 80 00 	movl   $0x0,0x80109554
80100354:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100357:	e8 e4 20 00 00       	call   80102440 <lapicid>
8010035c:	83 ec 08             	sub    $0x8,%esp
8010035f:	50                   	push   %eax
80100360:	68 ad 65 10 80       	push   $0x801065ad
80100365:	e8 77 02 00 00       	call   801005e1 <cprintf>
  cprintf(s);
8010036a:	83 c4 04             	add    $0x4,%esp
8010036d:	ff 75 08             	pushl  0x8(%ebp)
80100370:	e8 6c 02 00 00       	call   801005e1 <cprintf>
  cprintf("\n");
80100375:	c7 04 24 fb 6e 10 80 	movl   $0x80106efb,(%esp)
8010037c:	e8 60 02 00 00       	call   801005e1 <cprintf>
  getcallerpcs(&s, pcs);
80100381:	83 c4 08             	add    $0x8,%esp
80100384:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100387:	53                   	push   %ebx
80100388:	8d 45 08             	lea    0x8(%ebp),%eax
8010038b:	50                   	push   %eax
8010038c:	e8 a4 38 00 00       	call   80103c35 <getcallerpcs>
80100391:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100394:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 33                	pushl  (%ebx)
8010039c:	68 c1 65 10 80       	push   $0x801065c1
801003a1:	e8 3b 02 00 00       	call   801005e1 <cprintf>
801003a6:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	39 f3                	cmp    %esi,%ebx
801003ae:	75 e7                	jne    80100397 <panic+0x53>
  panicked = 1; // freeze other CPU
801003b0:	c7 05 58 95 10 80 01 	movl   $0x1,0x80109558
801003b7:	00 00 00 
801003ba:	eb fe                	jmp    801003ba <panic+0x76>

801003bc <consputc>:
  if(panicked){
801003bc:	83 3d 58 95 10 80 00 	cmpl   $0x0,0x80109558
801003c3:	74 03                	je     801003c8 <consputc+0xc>
801003c5:	fa                   	cli    
801003c6:	eb fe                	jmp    801003c6 <consputc+0xa>
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	57                   	push   %edi
801003cc:	56                   	push   %esi
801003cd:	53                   	push   %ebx
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003d3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d8:	74 5f                	je     80100439 <consputc+0x7d>
    uartputc(c);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 ce 4d 00 00       	call   801051b1 <uartputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801003eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f0:	89 da                	mov    %ebx,%edx
801003f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003f8:	89 ca                	mov    %ecx,%edx
801003fa:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fb:	0f b6 c0             	movzbl %al,%eax
801003fe:	c1 e0 08             	shl    $0x8,%eax
80100401:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0f 00 00 00       	mov    $0xf,%eax
80100408:	89 da                	mov    %ebx,%edx
8010040a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040b:	89 ca                	mov    %ecx,%edx
8010040d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040e:	0f b6 d8             	movzbl %al,%ebx
80100411:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100413:	83 fe 0a             	cmp    $0xa,%esi
80100416:	74 48                	je     80100460 <consputc+0xa4>
  else if(c == BACKSPACE){
80100418:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041e:	0f 84 93 00 00 00    	je     801004b7 <consputc+0xfb>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100424:	89 f0                	mov    %esi,%eax
80100426:	0f b6 c0             	movzbl %al,%eax
80100429:	80 cc 07             	or     $0x7,%ah
8010042c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100433:	80 
80100434:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100437:	eb 35                	jmp    8010046e <consputc+0xb2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100439:	83 ec 0c             	sub    $0xc,%esp
8010043c:	6a 08                	push   $0x8
8010043e:	e8 6e 4d 00 00       	call   801051b1 <uartputc>
80100443:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010044a:	e8 62 4d 00 00       	call   801051b1 <uartputc>
8010044f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100456:	e8 56 4d 00 00       	call   801051b1 <uartputc>
8010045b:	83 c4 10             	add    $0x10,%esp
8010045e:	eb 86                	jmp    801003e6 <consputc+0x2a>
    pos += 80 - pos%80;
80100460:	b9 50 00 00 00       	mov    $0x50,%ecx
80100465:	89 d8                	mov    %ebx,%eax
80100467:	99                   	cltd   
80100468:	f7 f9                	idiv   %ecx
8010046a:	29 d1                	sub    %edx,%ecx
8010046c:	01 cb                	add    %ecx,%ebx
  if(pos < 0 || pos > 25*80)
8010046e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100474:	77 4a                	ja     801004c0 <consputc+0x104>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	7f 4f                	jg     801004cd <consputc+0x111>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100483:	b8 0e 00 00 00       	mov    $0xe,%eax
80100488:	89 f2                	mov    %esi,%edx
8010048a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010048b:	89 d8                	mov    %ebx,%eax
8010048d:	c1 f8 08             	sar    $0x8,%eax
80100490:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100495:	89 ca                	mov    %ecx,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049d:	89 f2                	mov    %esi,%edx
8010049f:	ee                   	out    %al,(%dx)
801004a0:	89 d8                	mov    %ebx,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a5:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
801004ac:	80 20 07 
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
    if(pos > 0) --pos;
801004b7:	85 db                	test   %ebx,%ebx
801004b9:	7e b3                	jle    8010046e <consputc+0xb2>
801004bb:	83 eb 01             	sub    $0x1,%ebx
801004be:	eb ae                	jmp    8010046e <consputc+0xb2>
    panic("pos under/overflow");
801004c0:	83 ec 0c             	sub    $0xc,%esp
801004c3:	68 c5 65 10 80       	push   $0x801065c5
801004c8:	e8 77 fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004cd:	83 ec 04             	sub    $0x4,%esp
801004d0:	68 60 0e 00 00       	push   $0xe60
801004d5:	68 a0 80 0b 80       	push   $0x800b80a0
801004da:	68 00 80 0b 80       	push   $0x800b8000
801004df:	e8 c1 39 00 00       	call   80103ea5 <memmove>
    pos -= 80;
801004e4:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e7:	83 c4 0c             	add    $0xc,%esp
801004ea:	b8 80 07 00 00       	mov    $0x780,%eax
801004ef:	29 d8                	sub    %ebx,%eax
801004f1:	01 c0                	add    %eax,%eax
801004f3:	50                   	push   %eax
801004f4:	6a 00                	push   $0x0
801004f6:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
801004f9:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801004fe:	50                   	push   %eax
801004ff:	e8 0c 39 00 00       	call   80103e10 <memset>
80100504:	83 c4 10             	add    $0x10,%esp
80100507:	e9 72 ff ff ff       	jmp    8010047e <consputc+0xc2>

8010050c <printint>:
{
8010050c:	55                   	push   %ebp
8010050d:	89 e5                	mov    %esp,%ebp
8010050f:	57                   	push   %edi
80100510:	56                   	push   %esi
80100511:	53                   	push   %ebx
80100512:	83 ec 1c             	sub    $0x1c,%esp
80100515:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
80100517:	85 c9                	test   %ecx,%ecx
80100519:	74 04                	je     8010051f <printint+0x13>
8010051b:	85 c0                	test   %eax,%eax
8010051d:	78 0e                	js     8010052d <printint+0x21>
    x = xx;
8010051f:	89 c2                	mov    %eax,%edx
80100521:	bf 00 00 00 00       	mov    $0x0,%edi
  i = 0;
80100526:	b9 00 00 00 00       	mov    $0x0,%ecx
8010052b:	eb 0d                	jmp    8010053a <printint+0x2e>
    x = -xx;
8010052d:	f7 d8                	neg    %eax
8010052f:	89 c2                	mov    %eax,%edx
  if(sign && (sign = xx < 0))
80100531:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
80100536:	eb ee                	jmp    80100526 <printint+0x1a>
    buf[i++] = digits[x % base];
80100538:	89 d9                	mov    %ebx,%ecx
8010053a:	8d 59 01             	lea    0x1(%ecx),%ebx
8010053d:	89 d0                	mov    %edx,%eax
8010053f:	ba 00 00 00 00       	mov    $0x0,%edx
80100544:	f7 f6                	div    %esi
80100546:	0f b6 92 f0 65 10 80 	movzbl -0x7fef9a10(%edx),%edx
8010054d:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100551:	89 c2                	mov    %eax,%edx
80100553:	85 c0                	test   %eax,%eax
80100555:	75 e1                	jne    80100538 <printint+0x2c>
  if(sign)
80100557:	85 ff                	test   %edi,%edi
80100559:	74 08                	je     80100563 <printint+0x57>
    buf[i++] = '-';
8010055b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100560:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	78 12                	js     8010057a <printint+0x6e>
    consputc(buf[i]);
80100568:	0f be 44 2b d8       	movsbl -0x28(%ebx,%ebp,1),%eax
8010056d:	e8 4a fe ff ff       	call   801003bc <consputc>
  while(--i >= 0)
80100572:	83 eb 01             	sub    $0x1,%ebx
80100575:	83 fb ff             	cmp    $0xffffffff,%ebx
80100578:	75 ee                	jne    80100568 <printint+0x5c>
}
8010057a:	83 c4 1c             	add    $0x1c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret    

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010058e:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	pushl  0x8(%ebp)
80100594:	e8 0f 10 00 00       	call   801015a8 <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
801005a0:	e8 bd 37 00 00       	call   80103d62 <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	85 ff                	test   %edi,%edi
801005aa:	7e 13                	jle    801005bf <consolewrite+0x3d>
801005ac:	89 f3                	mov    %esi,%ebx
801005ae:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005b0:	0f b6 03             	movzbl (%ebx),%eax
801005b3:	e8 04 fe ff ff       	call   801003bc <consputc>
801005b8:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < n; i++)
801005bb:	39 f3                	cmp    %esi,%ebx
801005bd:	75 f1                	jne    801005b0 <consolewrite+0x2e>
  release(&cons.lock);
801005bf:	83 ec 0c             	sub    $0xc,%esp
801005c2:	68 20 95 10 80       	push   $0x80109520
801005c7:	e8 fd 37 00 00       	call   80103dc9 <release>
  ilock(ip);
801005cc:	83 c4 04             	add    $0x4,%esp
801005cf:	ff 75 08             	pushl  0x8(%ebp)
801005d2:	e8 0f 0f 00 00       	call   801014e6 <ilock>

  return n;
}
801005d7:	89 f8                	mov    %edi,%eax
801005d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dc:	5b                   	pop    %ebx
801005dd:	5e                   	pop    %esi
801005de:	5f                   	pop    %edi
801005df:	5d                   	pop    %ebp
801005e0:	c3                   	ret    

801005e1 <cprintf>:
{
801005e1:	55                   	push   %ebp
801005e2:	89 e5                	mov    %esp,%ebp
801005e4:	57                   	push   %edi
801005e5:	56                   	push   %esi
801005e6:	53                   	push   %ebx
801005e7:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005ea:	a1 54 95 10 80       	mov    0x80109554,%eax
801005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f2:	85 c0                	test   %eax,%eax
801005f4:	75 2b                	jne    80100621 <cprintf+0x40>
  if (fmt == 0)
801005f6:	8b 7d 08             	mov    0x8(%ebp),%edi
801005f9:	85 ff                	test   %edi,%edi
801005fb:	74 36                	je     80100633 <cprintf+0x52>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100600:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100603:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100606:	bb 00 00 00 00       	mov    $0x0,%ebx
8010060b:	85 c0                	test   %eax,%eax
8010060d:	75 41                	jne    80100650 <cprintf+0x6f>
  if(locking)
8010060f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100613:	0f 85 0d 01 00 00    	jne    80100726 <cprintf+0x145>
}
80100619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
    acquire(&cons.lock);
80100621:	83 ec 0c             	sub    $0xc,%esp
80100624:	68 20 95 10 80       	push   $0x80109520
80100629:	e8 34 37 00 00       	call   80103d62 <acquire>
8010062e:	83 c4 10             	add    $0x10,%esp
80100631:	eb c3                	jmp    801005f6 <cprintf+0x15>
    panic("null fmt");
80100633:	83 ec 0c             	sub    $0xc,%esp
80100636:	68 df 65 10 80       	push   $0x801065df
8010063b:	e8 04 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100640:	e8 77 fd ff ff       	call   801003bc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100645:	83 c3 01             	add    $0x1,%ebx
80100648:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010064c:	85 c0                	test   %eax,%eax
8010064e:	74 bf                	je     8010060f <cprintf+0x2e>
    if(c != '%'){
80100650:	83 f8 25             	cmp    $0x25,%eax
80100653:	75 eb                	jne    80100640 <cprintf+0x5f>
    c = fmt[++i] & 0xff;
80100655:	83 c3 01             	add    $0x1,%ebx
80100658:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
8010065c:	85 f6                	test   %esi,%esi
8010065e:	74 af                	je     8010060f <cprintf+0x2e>
    switch(c){
80100660:	83 fe 70             	cmp    $0x70,%esi
80100663:	74 4c                	je     801006b1 <cprintf+0xd0>
80100665:	83 fe 70             	cmp    $0x70,%esi
80100668:	7f 2a                	jg     80100694 <cprintf+0xb3>
8010066a:	83 fe 25             	cmp    $0x25,%esi
8010066d:	0f 84 a4 00 00 00    	je     80100717 <cprintf+0x136>
80100673:	83 fe 64             	cmp    $0x64,%esi
80100676:	75 26                	jne    8010069e <cprintf+0xbd>
      printint(*argp++, 10, 1);
80100678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010067b:	8d 70 04             	lea    0x4(%eax),%esi
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	ba 0a 00 00 00       	mov    $0xa,%edx
80100688:	8b 00                	mov    (%eax),%eax
8010068a:	e8 7d fe ff ff       	call   8010050c <printint>
8010068f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
80100692:	eb b1                	jmp    80100645 <cprintf+0x64>
    switch(c){
80100694:	83 fe 73             	cmp    $0x73,%esi
80100697:	74 37                	je     801006d0 <cprintf+0xef>
80100699:	83 fe 78             	cmp    $0x78,%esi
8010069c:	74 13                	je     801006b1 <cprintf+0xd0>
      consputc('%');
8010069e:	b8 25 00 00 00       	mov    $0x25,%eax
801006a3:	e8 14 fd ff ff       	call   801003bc <consputc>
      consputc(c);
801006a8:	89 f0                	mov    %esi,%eax
801006aa:	e8 0d fd ff ff       	call   801003bc <consputc>
      break;
801006af:	eb 94                	jmp    80100645 <cprintf+0x64>
      printint(*argp++, 16, 0);
801006b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006b4:	8d 70 04             	lea    0x4(%eax),%esi
801006b7:	b9 00 00 00 00       	mov    $0x0,%ecx
801006bc:	ba 10 00 00 00       	mov    $0x10,%edx
801006c1:	8b 00                	mov    (%eax),%eax
801006c3:	e8 44 fe ff ff       	call   8010050c <printint>
801006c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006cb:	e9 75 ff ff ff       	jmp    80100645 <cprintf+0x64>
      if((s = (char*)*argp++) == 0)
801006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d3:	8d 50 04             	lea    0x4(%eax),%edx
801006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801006d9:	8b 00                	mov    (%eax),%eax
801006db:	85 c0                	test   %eax,%eax
801006dd:	74 11                	je     801006f0 <cprintf+0x10f>
801006df:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
801006e1:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
801006e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
801006e7:	84 c0                	test   %al,%al
801006e9:	75 0f                	jne    801006fa <cprintf+0x119>
801006eb:	e9 55 ff ff ff       	jmp    80100645 <cprintf+0x64>
        s = "(null)";
801006f0:	be d8 65 10 80       	mov    $0x801065d8,%esi
      for(; *s; s++)
801006f5:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
801006fa:	0f be c0             	movsbl %al,%eax
801006fd:	e8 ba fc ff ff       	call   801003bc <consputc>
      for(; *s; s++)
80100702:	83 c6 01             	add    $0x1,%esi
80100705:	0f b6 06             	movzbl (%esi),%eax
80100708:	84 c0                	test   %al,%al
8010070a:	75 ee                	jne    801006fa <cprintf+0x119>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	e9 2e ff ff ff       	jmp    80100645 <cprintf+0x64>
      consputc('%');
80100717:	b8 25 00 00 00       	mov    $0x25,%eax
8010071c:	e8 9b fc ff ff       	call   801003bc <consputc>
      break;
80100721:	e9 1f ff ff ff       	jmp    80100645 <cprintf+0x64>
    release(&cons.lock);
80100726:	83 ec 0c             	sub    $0xc,%esp
80100729:	68 20 95 10 80       	push   $0x80109520
8010072e:	e8 96 36 00 00       	call   80103dc9 <release>
80100733:	83 c4 10             	add    $0x10,%esp
}
80100736:	e9 de fe ff ff       	jmp    80100619 <cprintf+0x38>

8010073b <consoleintr>:
{
8010073b:	55                   	push   %ebp
8010073c:	89 e5                	mov    %esp,%ebp
8010073e:	57                   	push   %edi
8010073f:	56                   	push   %esi
80100740:	53                   	push   %ebx
80100741:	83 ec 28             	sub    $0x28,%esp
80100744:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100747:	68 20 95 10 80       	push   $0x80109520
8010074c:	e8 11 36 00 00       	call   80103d62 <acquire>
  while((c = getc()) >= 0){
80100751:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100754:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010075b:	bb 20 ef 10 80       	mov    $0x8010ef20,%ebx
  while((c = getc()) >= 0){
80100760:	e9 c2 00 00 00       	jmp    80100827 <consoleintr+0xec>
    switch(c){
80100765:	83 fe 08             	cmp    $0x8,%esi
80100768:	0f 84 dd 00 00 00    	je     8010084b <consoleintr+0x110>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010076e:	85 f6                	test   %esi,%esi
80100770:	0f 84 b1 00 00 00    	je     80100827 <consoleintr+0xec>
80100776:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010077c:	89 c2                	mov    %eax,%edx
8010077e:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
80100784:	83 fa 7f             	cmp    $0x7f,%edx
80100787:	0f 87 9a 00 00 00    	ja     80100827 <consoleintr+0xec>
        c = (c == '\r') ? '\n' : c;
8010078d:	83 fe 0d             	cmp    $0xd,%esi
80100790:	0f 84 fd 00 00 00    	je     80100893 <consoleintr+0x158>
        input.buf[input.e++ % INPUT_BUF] = c;
80100796:	8d 50 01             	lea    0x1(%eax),%edx
80100799:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010079f:	83 e0 7f             	and    $0x7f,%eax
801007a2:	89 f1                	mov    %esi,%ecx
801007a4:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        consputc(c);
801007a7:	89 f0                	mov    %esi,%eax
801007a9:	e8 0e fc ff ff       	call   801003bc <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ae:	83 fe 0a             	cmp    $0xa,%esi
801007b1:	0f 84 f6 00 00 00    	je     801008ad <consoleintr+0x172>
801007b7:	83 fe 04             	cmp    $0x4,%esi
801007ba:	0f 84 ed 00 00 00    	je     801008ad <consoleintr+0x172>
801007c0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 83 88 00 00 00    	cmp    %eax,0x88(%ebx)
801007cf:	75 56                	jne    80100827 <consoleintr+0xec>
801007d1:	e9 d7 00 00 00       	jmp    801008ad <consoleintr+0x172>
      while(input.e != input.w &&
801007d6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801007dc:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801007e2:	74 43                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007e4:	83 e8 01             	sub    $0x1,%eax
801007e7:	89 c2                	mov    %eax,%edx
801007e9:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007ec:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
801007f0:	74 35                	je     80100827 <consoleintr+0xec>
        input.e--;
801007f2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
801007f8:	b8 00 01 00 00       	mov    $0x100,%eax
801007fd:	e8 ba fb ff ff       	call   801003bc <consputc>
      while(input.e != input.w &&
80100802:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100808:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
8010080e:	74 17                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	83 e8 01             	sub    $0x1,%eax
80100813:	89 c2                	mov    %eax,%edx
80100815:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100818:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
8010081c:	75 d4                	jne    801007f2 <consoleintr+0xb7>
8010081e:	eb 07                	jmp    80100827 <consoleintr+0xec>
      doprocdump = 1;
80100820:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100827:	ff d7                	call   *%edi
80100829:	89 c6                	mov    %eax,%esi
8010082b:	85 c0                	test   %eax,%eax
8010082d:	78 3f                	js     8010086e <consoleintr+0x133>
    switch(c){
8010082f:	83 fe 10             	cmp    $0x10,%esi
80100832:	74 ec                	je     80100820 <consoleintr+0xe5>
80100834:	83 fe 10             	cmp    $0x10,%esi
80100837:	0f 8e 28 ff ff ff    	jle    80100765 <consoleintr+0x2a>
8010083d:	83 fe 15             	cmp    $0x15,%esi
80100840:	74 94                	je     801007d6 <consoleintr+0x9b>
80100842:	83 fe 7f             	cmp    $0x7f,%esi
80100845:	0f 85 23 ff ff ff    	jne    8010076e <consoleintr+0x33>
      if(input.e != input.w){
8010084b:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100851:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100857:	74 ce                	je     80100827 <consoleintr+0xec>
        input.e--;
80100859:	83 e8 01             	sub    $0x1,%eax
8010085c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
80100862:	b8 00 01 00 00       	mov    $0x100,%eax
80100867:	e8 50 fb ff ff       	call   801003bc <consputc>
8010086c:	eb b9                	jmp    80100827 <consoleintr+0xec>
  release(&cons.lock);
8010086e:	83 ec 0c             	sub    $0xc,%esp
80100871:	68 20 95 10 80       	push   $0x80109520
80100876:	e8 4e 35 00 00       	call   80103dc9 <release>
  if(doprocdump) {
8010087b:	83 c4 10             	add    $0x10,%esp
8010087e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100882:	75 08                	jne    8010088c <consoleintr+0x151>
}
80100884:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100887:	5b                   	pop    %ebx
80100888:	5e                   	pop    %esi
80100889:	5f                   	pop    %edi
8010088a:	5d                   	pop    %ebp
8010088b:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
8010088c:	e8 79 31 00 00       	call   80103a0a <procdump>
}
80100891:	eb f1                	jmp    80100884 <consoleintr+0x149>
        input.buf[input.e++ % INPUT_BUF] = c;
80100893:	8d 50 01             	lea    0x1(%eax),%edx
80100896:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010089c:	83 e0 7f             	and    $0x7f,%eax
8010089f:	c6 04 03 0a          	movb   $0xa,(%ebx,%eax,1)
        consputc(c);
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	e8 0f fb ff ff       	call   801003bc <consputc>
          input.w = input.e;
801008ad:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801008b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
          wakeup(&input.r);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 a0 ef 10 80       	push   $0x8010efa0
801008c1:	e8 9a 30 00 00       	call   80103960 <wakeup>
801008c6:	83 c4 10             	add    $0x10,%esp
801008c9:	e9 59 ff ff ff       	jmp    80100827 <consoleintr+0xec>

801008ce <consoleinit>:

void
consoleinit(void)
{
801008ce:	55                   	push   %ebp
801008cf:	89 e5                	mov    %esp,%ebp
801008d1:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008d4:	68 e8 65 10 80       	push   $0x801065e8
801008d9:	68 20 95 10 80       	push   $0x80109520
801008de:	e8 37 33 00 00       	call   80103c1a <initlock>

  devsw[CONSOLE].write = consolewrite;
801008e3:	c7 05 6c f9 10 80 82 	movl   $0x80100582,0x8010f96c
801008ea:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008ed:	c7 05 68 f9 10 80 54 	movl   $0x80100254,0x8010f968
801008f4:	02 10 80 
  cons.locking = 1;
801008f7:	c7 05 54 95 10 80 01 	movl   $0x1,0x80109554
801008fe:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100901:	83 c4 08             	add    $0x8,%esp
80100904:	6a 00                	push   $0x0
80100906:	6a 01                	push   $0x1
80100908:	e8 f9 16 00 00       	call   80102006 <ioapicenable>
}
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	c9                   	leave  
80100911:	c3                   	ret    

80100912 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100912:	55                   	push   %ebp
80100913:	89 e5                	mov    %esp,%ebp
80100915:	57                   	push   %edi
80100916:	56                   	push   %esi
80100917:	53                   	push   %ebx
80100918:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010091e:	e8 11 2a 00 00       	call   80103334 <myproc>
80100923:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100929:	e8 7f 1e 00 00       	call   801027ad <begin_op>

  if((ip = namei(path)) == 0){
8010092e:	83 ec 0c             	sub    $0xc,%esp
80100931:	ff 75 08             	pushl  0x8(%ebp)
80100934:	e8 4a 13 00 00       	call   80101c83 <namei>
80100939:	83 c4 10             	add    $0x10,%esp
8010093c:	85 c0                	test   %eax,%eax
8010093e:	74 42                	je     80100982 <exec+0x70>
80100940:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100942:	83 ec 0c             	sub    $0xc,%esp
80100945:	50                   	push   %eax
80100946:	e8 9b 0b 00 00       	call   801014e6 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010094b:	6a 34                	push   $0x34
8010094d:	6a 00                	push   $0x0
8010094f:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100955:	50                   	push   %eax
80100956:	53                   	push   %ebx
80100957:	e8 1e 0e 00 00       	call   8010177a <readi>
8010095c:	83 c4 20             	add    $0x20,%esp
8010095f:	83 f8 34             	cmp    $0x34,%eax
80100962:	74 3a                	je     8010099e <exec+0x8c>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	53                   	push   %ebx
80100968:	e8 c2 0d 00 00       	call   8010172f <iunlockput>
    end_op();
8010096d:	e8 b6 1e 00 00       	call   80102828 <end_op>
80100972:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097d:	5b                   	pop    %ebx
8010097e:	5e                   	pop    %esi
8010097f:	5f                   	pop    %edi
80100980:	5d                   	pop    %ebp
80100981:	c3                   	ret    
    end_op();
80100982:	e8 a1 1e 00 00       	call   80102828 <end_op>
    cprintf("exec: fail\n");
80100987:	83 ec 0c             	sub    $0xc,%esp
8010098a:	68 01 66 10 80       	push   $0x80106601
8010098f:	e8 4d fc ff ff       	call   801005e1 <cprintf>
    return -1;
80100994:	83 c4 10             	add    $0x10,%esp
80100997:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099c:	eb dc                	jmp    8010097a <exec+0x68>
  if(elf.magic != ELF_MAGIC)
8010099e:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801009a5:	45 4c 46 
801009a8:	75 ba                	jne    80100964 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
801009aa:	e8 73 59 00 00       	call   80106322 <setupkvm>
801009af:	89 c7                	mov    %eax,%edi
801009b1:	85 c0                	test   %eax,%eax
801009b3:	74 af                	je     80100964 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
801009bb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009c1:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801009c8:	00 
801009c9:	0f 84 bf 00 00 00    	je     80100a8e <exec+0x17c>
  sz = 0;
801009cf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
801009d6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009d9:	be 00 00 00 00       	mov    $0x0,%esi
801009de:	eb 12                	jmp    801009f2 <exec+0xe0>
801009e0:	83 c6 01             	add    $0x1,%esi
801009e3:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801009ea:	39 f0                	cmp    %esi,%eax
801009ec:	0f 8e a6 00 00 00    	jle    80100a98 <exec+0x186>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009f2:	6a 20                	push   $0x20
801009f4:	89 f0                	mov    %esi,%eax
801009f6:	c1 e0 05             	shl    $0x5,%eax
801009f9:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
801009ff:	50                   	push   %eax
80100a00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a06:	50                   	push   %eax
80100a07:	53                   	push   %ebx
80100a08:	e8 6d 0d 00 00       	call   8010177a <readi>
80100a0d:	83 c4 10             	add    $0x10,%esp
80100a10:	83 f8 20             	cmp    $0x20,%eax
80100a13:	0f 85 c2 00 00 00    	jne    80100adb <exec+0x1c9>
    if(ph.type != ELF_PROG_LOAD)
80100a19:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a20:	75 be                	jne    801009e0 <exec+0xce>
    if(ph.memsz < ph.filesz)
80100a22:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a28:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a2e:	0f 82 a7 00 00 00    	jb     80100adb <exec+0x1c9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a34:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a3a:	0f 82 9b 00 00 00    	jb     80100adb <exec+0x1c9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a40:	83 ec 04             	sub    $0x4,%esp
80100a43:	50                   	push   %eax
80100a44:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a4a:	57                   	push   %edi
80100a4b:	e8 71 57 00 00       	call   801061c1 <allocuvm>
80100a50:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a56:	83 c4 10             	add    $0x10,%esp
80100a59:	85 c0                	test   %eax,%eax
80100a5b:	74 7e                	je     80100adb <exec+0x1c9>
    if(ph.vaddr % PGSIZE != 0)
80100a5d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a68:	75 71                	jne    80100adb <exec+0x1c9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a6a:	83 ec 0c             	sub    $0xc,%esp
80100a6d:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a73:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a79:	53                   	push   %ebx
80100a7a:	50                   	push   %eax
80100a7b:	57                   	push   %edi
80100a7c:	e8 03 56 00 00       	call   80106084 <loaduvm>
80100a81:	83 c4 20             	add    $0x20,%esp
80100a84:	85 c0                	test   %eax,%eax
80100a86:	0f 89 54 ff ff ff    	jns    801009e0 <exec+0xce>
 bad:
80100a8c:	eb 4d                	jmp    80100adb <exec+0x1c9>
  sz = 0;
80100a8e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a95:	00 00 00 
  iunlockput(ip);
80100a98:	83 ec 0c             	sub    $0xc,%esp
80100a9b:	53                   	push   %ebx
80100a9c:	e8 8e 0c 00 00       	call   8010172f <iunlockput>
  end_op();
80100aa1:	e8 82 1d 00 00       	call   80102828 <end_op>
  sz = PGROUNDUP(sz);
80100aa6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100aac:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ab1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ab6:	89 c2                	mov    %eax,%edx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ab8:	83 c4 0c             	add    $0xc,%esp
80100abb:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
80100ac1:	50                   	push   %eax
80100ac2:	52                   	push   %edx
80100ac3:	57                   	push   %edi
80100ac4:	e8 f8 56 00 00       	call   801061c1 <allocuvm>
80100ac9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100acf:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100ad2:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	75 1e                	jne    80100af9 <exec+0x1e7>
    freevm(pgdir);
80100adb:	83 ec 0c             	sub    $0xc,%esp
80100ade:	57                   	push   %edi
80100adf:	e8 cb 57 00 00       	call   801062af <freevm>
  if(ip){
80100ae4:	83 c4 10             	add    $0x10,%esp
80100ae7:	85 db                	test   %ebx,%ebx
80100ae9:	0f 85 75 fe ff ff    	jne    80100964 <exec+0x52>
  return -1;
80100aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100af4:	e9 81 fe ff ff       	jmp    8010097a <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100af9:	83 ec 08             	sub    $0x8,%esp
80100afc:	89 c3                	mov    %eax,%ebx
80100afe:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b04:	50                   	push   %eax
80100b05:	57                   	push   %edi
80100b06:	e8 9c 58 00 00       	call   801063a7 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b0e:	8b 00                	mov    (%eax),%eax
80100b10:	83 c4 10             	add    $0x10,%esp
80100b13:	be 00 00 00 00       	mov    $0x0,%esi
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	74 5f                	je     80100b7b <exec+0x269>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	50                   	push   %eax
80100b20:	e8 ae 34 00 00       	call   80103fd3 <strlen>
80100b25:	f7 d0                	not    %eax
80100b27:	01 d8                	add    %ebx,%eax
80100b29:	83 e0 fc             	and    $0xfffffffc,%eax
80100b2c:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b2e:	83 c4 04             	add    $0x4,%esp
80100b31:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b34:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b37:	e8 97 34 00 00       	call   80103fd3 <strlen>
80100b3c:	83 c0 01             	add    $0x1,%eax
80100b3f:	50                   	push   %eax
80100b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b43:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b46:	53                   	push   %ebx
80100b47:	57                   	push   %edi
80100b48:	e8 a5 59 00 00       	call   801064f2 <copyout>
80100b4d:	83 c4 20             	add    $0x20,%esp
80100b50:	85 c0                	test   %eax,%eax
80100b52:	0f 88 f4 00 00 00    	js     80100c4c <exec+0x33a>
    ustack[3+argc] = sp;
80100b58:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b5f:	83 c6 01             	add    $0x1,%esi
80100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b65:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b68:	85 c0                	test   %eax,%eax
80100b6a:	74 15                	je     80100b81 <exec+0x26f>
    if(argc >= MAXARG)
80100b6c:	83 fe 20             	cmp    $0x20,%esi
80100b6f:	75 ab                	jne    80100b1c <exec+0x20a>
  ip = 0;
80100b71:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b76:	e9 60 ff ff ff       	jmp    80100adb <exec+0x1c9>
  sp = sz;
80100b7b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
  ustack[3+argc] = 0;
80100b81:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b88:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b8c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b93:	ff ff ff 
  ustack[1] = argc;
80100b96:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b9c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100ba3:	89 da                	mov    %ebx,%edx
80100ba5:	29 c2                	sub    %eax,%edx
80100ba7:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100bad:	83 c0 0c             	add    $0xc,%eax
80100bb0:	89 de                	mov    %ebx,%esi
80100bb2:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bb4:	50                   	push   %eax
80100bb5:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100bbb:	50                   	push   %eax
80100bbc:	56                   	push   %esi
80100bbd:	57                   	push   %edi
80100bbe:	e8 2f 59 00 00       	call   801064f2 <copyout>
80100bc3:	83 c4 10             	add    $0x10,%esp
80100bc6:	85 c0                	test   %eax,%eax
80100bc8:	0f 88 88 00 00 00    	js     80100c56 <exec+0x344>
  for(last=s=path; *s; s++)
80100bce:	8b 45 08             	mov    0x8(%ebp),%eax
80100bd1:	0f b6 10             	movzbl (%eax),%edx
80100bd4:	84 d2                	test   %dl,%dl
80100bd6:	74 1a                	je     80100bf2 <exec+0x2e0>
80100bd8:	83 c0 01             	add    $0x1,%eax
80100bdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100bde:	80 fa 2f             	cmp    $0x2f,%dl
80100be1:	0f 44 c8             	cmove  %eax,%ecx
80100be4:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100be7:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100beb:	84 d2                	test   %dl,%dl
80100bed:	75 ef                	jne    80100bde <exec+0x2cc>
80100bef:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bf2:	83 ec 04             	sub    $0x4,%esp
80100bf5:	6a 10                	push   $0x10
80100bf7:	ff 75 08             	pushl  0x8(%ebp)
80100bfa:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100c00:	89 d8                	mov    %ebx,%eax
80100c02:	83 c0 6c             	add    $0x6c,%eax
80100c05:	50                   	push   %eax
80100c06:	e8 94 33 00 00       	call   80103f9f <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c0b:	89 d8                	mov    %ebx,%eax
80100c0d:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c10:	89 78 04             	mov    %edi,0x4(%eax)
  curproc->sz = sz;
80100c13:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c19:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c1b:	89 c7                	mov    %eax,%edi
80100c1d:	8b 40 18             	mov    0x18(%eax),%eax
80100c20:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c26:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c29:	8b 47 18             	mov    0x18(%edi),%eax
80100c2c:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c2f:	89 3c 24             	mov    %edi,(%esp)
80100c32:	e8 e6 52 00 00       	call   80105f1d <switchuvm>
  freevm(oldpgdir);
80100c37:	89 1c 24             	mov    %ebx,(%esp)
80100c3a:	e8 70 56 00 00       	call   801062af <freevm>
  return 0;
80100c3f:	83 c4 10             	add    $0x10,%esp
80100c42:	b8 00 00 00 00       	mov    $0x0,%eax
80100c47:	e9 2e fd ff ff       	jmp    8010097a <exec+0x68>
  ip = 0;
80100c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c51:	e9 85 fe ff ff       	jmp    80100adb <exec+0x1c9>
80100c56:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c5b:	e9 7b fe ff ff       	jmp    80100adb <exec+0x1c9>

80100c60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c66:	68 0d 66 10 80       	push   $0x8010660d
80100c6b:	68 c0 ef 10 80       	push   $0x8010efc0
80100c70:	e8 a5 2f 00 00       	call   80103c1a <initlock>
}
80100c75:	83 c4 10             	add    $0x10,%esp
80100c78:	c9                   	leave  
80100c79:	c3                   	ret    

80100c7a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c7a:	55                   	push   %ebp
80100c7b:	89 e5                	mov    %esp,%ebp
80100c7d:	53                   	push   %ebx
80100c7e:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c81:	68 c0 ef 10 80       	push   $0x8010efc0
80100c86:	e8 d7 30 00 00       	call   80103d62 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	83 3d f8 ef 10 80 00 	cmpl   $0x0,0x8010eff8
80100c95:	74 2d                	je     80100cc4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c97:	bb 0c f0 10 80       	mov    $0x8010f00c,%ebx
    if(f->ref == 0){
80100c9c:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100ca0:	74 27                	je     80100cc9 <filealloc+0x4f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ca2:	83 c3 18             	add    $0x18,%ebx
80100ca5:	81 fb 54 f9 10 80    	cmp    $0x8010f954,%ebx
80100cab:	72 ef                	jb     80100c9c <filealloc+0x22>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100cad:	83 ec 0c             	sub    $0xc,%esp
80100cb0:	68 c0 ef 10 80       	push   $0x8010efc0
80100cb5:	e8 0f 31 00 00       	call   80103dc9 <release>
  return 0;
80100cba:	83 c4 10             	add    $0x10,%esp
80100cbd:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cc2:	eb 1c                	jmp    80100ce0 <filealloc+0x66>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cc4:	bb f4 ef 10 80       	mov    $0x8010eff4,%ebx
      f->ref = 1;
80100cc9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cd0:	83 ec 0c             	sub    $0xc,%esp
80100cd3:	68 c0 ef 10 80       	push   $0x8010efc0
80100cd8:	e8 ec 30 00 00       	call   80103dc9 <release>
      return f;
80100cdd:	83 c4 10             	add    $0x10,%esp
}
80100ce0:	89 d8                	mov    %ebx,%eax
80100ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ce5:	c9                   	leave  
80100ce6:	c3                   	ret    

80100ce7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ce7:	55                   	push   %ebp
80100ce8:	89 e5                	mov    %esp,%ebp
80100cea:	53                   	push   %ebx
80100ceb:	83 ec 10             	sub    $0x10,%esp
80100cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cf1:	68 c0 ef 10 80       	push   $0x8010efc0
80100cf6:	e8 67 30 00 00       	call   80103d62 <acquire>
  if(f->ref < 1)
80100cfb:	8b 43 04             	mov    0x4(%ebx),%eax
80100cfe:	83 c4 10             	add    $0x10,%esp
80100d01:	85 c0                	test   %eax,%eax
80100d03:	7e 1a                	jle    80100d1f <filedup+0x38>
    panic("filedup");
  f->ref++;
80100d05:	83 c0 01             	add    $0x1,%eax
80100d08:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d0b:	83 ec 0c             	sub    $0xc,%esp
80100d0e:	68 c0 ef 10 80       	push   $0x8010efc0
80100d13:	e8 b1 30 00 00       	call   80103dc9 <release>
  return f;
}
80100d18:	89 d8                	mov    %ebx,%eax
80100d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d1d:	c9                   	leave  
80100d1e:	c3                   	ret    
    panic("filedup");
80100d1f:	83 ec 0c             	sub    $0xc,%esp
80100d22:	68 14 66 10 80       	push   $0x80106614
80100d27:	e8 18 f6 ff ff       	call   80100344 <panic>

80100d2c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d2c:	55                   	push   %ebp
80100d2d:	89 e5                	mov    %esp,%ebp
80100d2f:	57                   	push   %edi
80100d30:	56                   	push   %esi
80100d31:	53                   	push   %ebx
80100d32:	83 ec 28             	sub    $0x28,%esp
80100d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d38:	68 c0 ef 10 80       	push   $0x8010efc0
80100d3d:	e8 20 30 00 00       	call   80103d62 <acquire>
  if(f->ref < 1)
80100d42:	8b 43 04             	mov    0x4(%ebx),%eax
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	85 c0                	test   %eax,%eax
80100d4a:	7e 22                	jle    80100d6e <fileclose+0x42>
    panic("fileclose");
  if(--f->ref > 0){
80100d4c:	83 e8 01             	sub    $0x1,%eax
80100d4f:	89 43 04             	mov    %eax,0x4(%ebx)
80100d52:	85 c0                	test   %eax,%eax
80100d54:	7e 25                	jle    80100d7b <fileclose+0x4f>
    release(&ftable.lock);
80100d56:	83 ec 0c             	sub    $0xc,%esp
80100d59:	68 c0 ef 10 80       	push   $0x8010efc0
80100d5e:	e8 66 30 00 00       	call   80103dc9 <release>
80100d63:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d69:	5b                   	pop    %ebx
80100d6a:	5e                   	pop    %esi
80100d6b:	5f                   	pop    %edi
80100d6c:	5d                   	pop    %ebp
80100d6d:	c3                   	ret    
    panic("fileclose");
80100d6e:	83 ec 0c             	sub    $0xc,%esp
80100d71:	68 1c 66 10 80       	push   $0x8010661c
80100d76:	e8 c9 f5 ff ff       	call   80100344 <panic>
  ff = *f;
80100d7b:	8b 33                	mov    (%ebx),%esi
80100d7d:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100d81:	88 45 e7             	mov    %al,-0x19(%ebp)
80100d84:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100d87:	8b 43 10             	mov    0x10(%ebx),%eax
80100d8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100d8d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d9a:	83 ec 0c             	sub    $0xc,%esp
80100d9d:	68 c0 ef 10 80       	push   $0x8010efc0
80100da2:	e8 22 30 00 00       	call   80103dc9 <release>
  if(ff.type == FD_PIPE)
80100da7:	83 c4 10             	add    $0x10,%esp
80100daa:	83 fe 01             	cmp    $0x1,%esi
80100dad:	74 1f                	je     80100dce <fileclose+0xa2>
  else if(ff.type == FD_INODE){
80100daf:	83 fe 02             	cmp    $0x2,%esi
80100db2:	75 b2                	jne    80100d66 <fileclose+0x3a>
    begin_op();
80100db4:	e8 f4 19 00 00       	call   801027ad <begin_op>
    iput(ff.ip);
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	ff 75 e0             	pushl  -0x20(%ebp)
80100dbf:	e8 29 08 00 00       	call   801015ed <iput>
    end_op();
80100dc4:	e8 5f 1a 00 00       	call   80102828 <end_op>
80100dc9:	83 c4 10             	add    $0x10,%esp
80100dcc:	eb 98                	jmp    80100d66 <fileclose+0x3a>
    pipeclose(ff.pipe, ff.writable);
80100dce:	83 ec 08             	sub    $0x8,%esp
80100dd1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100dd5:	50                   	push   %eax
80100dd6:	57                   	push   %edi
80100dd7:	e8 fe 20 00 00       	call   80102eda <pipeclose>
80100ddc:	83 c4 10             	add    $0x10,%esp
80100ddf:	eb 85                	jmp    80100d66 <fileclose+0x3a>

80100de1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100de1:	55                   	push   %ebp
80100de2:	89 e5                	mov    %esp,%ebp
80100de4:	53                   	push   %ebx
80100de5:	83 ec 04             	sub    $0x4,%esp
80100de8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100deb:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dee:	75 31                	jne    80100e21 <filestat+0x40>
    ilock(f->ip);
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	ff 73 10             	pushl  0x10(%ebx)
80100df6:	e8 eb 06 00 00       	call   801014e6 <ilock>
    stati(f->ip, st);
80100dfb:	83 c4 08             	add    $0x8,%esp
80100dfe:	ff 75 0c             	pushl  0xc(%ebp)
80100e01:	ff 73 10             	pushl  0x10(%ebx)
80100e04:	e8 46 09 00 00       	call   8010174f <stati>
    iunlock(f->ip);
80100e09:	83 c4 04             	add    $0x4,%esp
80100e0c:	ff 73 10             	pushl  0x10(%ebx)
80100e0f:	e8 94 07 00 00       	call   801015a8 <iunlock>
    return 0;
80100e14:	83 c4 10             	add    $0x10,%esp
80100e17:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e1f:	c9                   	leave  
80100e20:	c3                   	ret    
  return -1;
80100e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e26:	eb f4                	jmp    80100e1c <filestat+0x3b>

80100e28 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e28:	55                   	push   %ebp
80100e29:	89 e5                	mov    %esp,%ebp
80100e2b:	56                   	push   %esi
80100e2c:	53                   	push   %ebx
80100e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e30:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e34:	74 70                	je     80100ea6 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e36:	8b 03                	mov    (%ebx),%eax
80100e38:	83 f8 01             	cmp    $0x1,%eax
80100e3b:	74 44                	je     80100e81 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e3d:	83 f8 02             	cmp    $0x2,%eax
80100e40:	75 57                	jne    80100e99 <fileread+0x71>
    ilock(f->ip);
80100e42:	83 ec 0c             	sub    $0xc,%esp
80100e45:	ff 73 10             	pushl  0x10(%ebx)
80100e48:	e8 99 06 00 00       	call   801014e6 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e4d:	ff 75 10             	pushl  0x10(%ebp)
80100e50:	ff 73 14             	pushl  0x14(%ebx)
80100e53:	ff 75 0c             	pushl  0xc(%ebp)
80100e56:	ff 73 10             	pushl  0x10(%ebx)
80100e59:	e8 1c 09 00 00       	call   8010177a <readi>
80100e5e:	89 c6                	mov    %eax,%esi
80100e60:	83 c4 20             	add    $0x20,%esp
80100e63:	85 c0                	test   %eax,%eax
80100e65:	7e 03                	jle    80100e6a <fileread+0x42>
      f->off += r;
80100e67:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e6a:	83 ec 0c             	sub    $0xc,%esp
80100e6d:	ff 73 10             	pushl  0x10(%ebx)
80100e70:	e8 33 07 00 00       	call   801015a8 <iunlock>
    return r;
80100e75:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e78:	89 f0                	mov    %esi,%eax
80100e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e7d:	5b                   	pop    %ebx
80100e7e:	5e                   	pop    %esi
80100e7f:	5d                   	pop    %ebp
80100e80:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e81:	83 ec 04             	sub    $0x4,%esp
80100e84:	ff 75 10             	pushl  0x10(%ebp)
80100e87:	ff 75 0c             	pushl  0xc(%ebp)
80100e8a:	ff 73 0c             	pushl  0xc(%ebx)
80100e8d:	e8 cd 21 00 00       	call   8010305f <piperead>
80100e92:	89 c6                	mov    %eax,%esi
80100e94:	83 c4 10             	add    $0x10,%esp
80100e97:	eb df                	jmp    80100e78 <fileread+0x50>
  panic("fileread");
80100e99:	83 ec 0c             	sub    $0xc,%esp
80100e9c:	68 26 66 10 80       	push   $0x80106626
80100ea1:	e8 9e f4 ff ff       	call   80100344 <panic>
    return -1;
80100ea6:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100eab:	eb cb                	jmp    80100e78 <fileread+0x50>

80100ead <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ead:	55                   	push   %ebp
80100eae:	89 e5                	mov    %esp,%ebp
80100eb0:	57                   	push   %edi
80100eb1:	56                   	push   %esi
80100eb2:	53                   	push   %ebx
80100eb3:	83 ec 1c             	sub    $0x1c,%esp
80100eb6:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100eb9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100ebd:	0f 84 e8 00 00 00    	je     80100fab <filewrite+0xfe>
    return -1;
  if(f->type == FD_PIPE)
80100ec3:	8b 06                	mov    (%esi),%eax
80100ec5:	83 f8 01             	cmp    $0x1,%eax
80100ec8:	74 1a                	je     80100ee4 <filewrite+0x37>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eca:	83 f8 02             	cmp    $0x2,%eax
80100ecd:	0f 85 cb 00 00 00    	jne    80100f9e <filewrite+0xf1>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ed7:	0f 8e 9e 00 00 00    	jle    80100f7b <filewrite+0xce>
    int i = 0;
80100edd:	bf 00 00 00 00       	mov    $0x0,%edi
80100ee2:	eb 3f                	jmp    80100f23 <filewrite+0x76>
    return pipewrite(f->pipe, addr, n);
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	ff 75 10             	pushl  0x10(%ebp)
80100eea:	ff 75 0c             	pushl  0xc(%ebp)
80100eed:	ff 76 0c             	pushl  0xc(%esi)
80100ef0:	e8 71 20 00 00       	call   80102f66 <pipewrite>
80100ef5:	89 45 10             	mov    %eax,0x10(%ebp)
80100ef8:	83 c4 10             	add    $0x10,%esp
80100efb:	e9 93 00 00 00       	jmp    80100f93 <filewrite+0xe6>

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100f00:	83 ec 0c             	sub    $0xc,%esp
80100f03:	ff 76 10             	pushl  0x10(%esi)
80100f06:	e8 9d 06 00 00       	call   801015a8 <iunlock>
      end_op();
80100f0b:	e8 18 19 00 00       	call   80102828 <end_op>

      if(r < 0)
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	85 db                	test   %ebx,%ebx
80100f15:	78 6b                	js     80100f82 <filewrite+0xd5>
        break;
      if(r != n1)
80100f17:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100f1a:	75 4e                	jne    80100f6a <filewrite+0xbd>
        panic("short filewrite");
      i += r;
80100f1c:	01 df                	add    %ebx,%edi
    while(i < n){
80100f1e:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f21:	7e 54                	jle    80100f77 <filewrite+0xca>
      int n1 = n - i;
80100f23:	8b 45 10             	mov    0x10(%ebp),%eax
80100f26:	29 f8                	sub    %edi,%eax
80100f28:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f2d:	ba 00 06 00 00       	mov    $0x600,%edx
80100f32:	0f 4f c2             	cmovg  %edx,%eax
80100f35:	89 c3                	mov    %eax,%ebx
80100f37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      begin_op();
80100f3a:	e8 6e 18 00 00       	call   801027ad <begin_op>
      ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 76 10             	pushl  0x10(%esi)
80100f45:	e8 9c 05 00 00       	call   801014e6 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f4a:	53                   	push   %ebx
80100f4b:	ff 76 14             	pushl  0x14(%esi)
80100f4e:	89 f8                	mov    %edi,%eax
80100f50:	03 45 0c             	add    0xc(%ebp),%eax
80100f53:	50                   	push   %eax
80100f54:	ff 76 10             	pushl  0x10(%esi)
80100f57:	e8 1a 09 00 00       	call   80101876 <writei>
80100f5c:	89 c3                	mov    %eax,%ebx
80100f5e:	83 c4 20             	add    $0x20,%esp
80100f61:	85 c0                	test   %eax,%eax
80100f63:	7e 9b                	jle    80100f00 <filewrite+0x53>
        f->off += r;
80100f65:	01 46 14             	add    %eax,0x14(%esi)
80100f68:	eb 96                	jmp    80100f00 <filewrite+0x53>
        panic("short filewrite");
80100f6a:	83 ec 0c             	sub    $0xc,%esp
80100f6d:	68 2f 66 10 80       	push   $0x8010662f
80100f72:	e8 cd f3 ff ff       	call   80100344 <panic>
80100f77:	89 f8                	mov    %edi,%eax
80100f79:	eb 09                	jmp    80100f84 <filewrite+0xd7>
    int i = 0;
80100f7b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f80:	eb 02                	jmp    80100f84 <filewrite+0xd7>
80100f82:	89 f8                	mov    %edi,%eax
    }
    return i == n ? n : -1;
80100f84:	39 45 10             	cmp    %eax,0x10(%ebp)
80100f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f8c:	0f 44 45 10          	cmove  0x10(%ebp),%eax
80100f90:	89 45 10             	mov    %eax,0x10(%ebp)
  }
  panic("filewrite");
}
80100f93:	8b 45 10             	mov    0x10(%ebp),%eax
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
80100f9d:	c3                   	ret    
  panic("filewrite");
80100f9e:	83 ec 0c             	sub    $0xc,%esp
80100fa1:	68 35 66 10 80       	push   $0x80106635
80100fa6:	e8 99 f3 ff ff       	call   80100344 <panic>
    return -1;
80100fab:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
80100fb2:	eb df                	jmp    80100f93 <filewrite+0xe6>

80100fb4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	56                   	push   %esi
80100fb8:	53                   	push   %ebx
80100fb9:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80100fbb:	83 ec 08             	sub    $0x8,%esp
80100fbe:	c1 ea 0c             	shr    $0xc,%edx
80100fc1:	03 15 d8 f9 10 80    	add    0x8010f9d8,%edx
80100fc7:	52                   	push   %edx
80100fc8:	50                   	push   %eax
80100fc9:	e8 dc f0 ff ff       	call   801000aa <bread>
80100fce:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
80100fd0:	89 d9                	mov    %ebx,%ecx
80100fd2:	83 e1 07             	and    $0x7,%ecx
80100fd5:	b8 01 00 00 00       	mov    $0x1,%eax
80100fda:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
80100fdc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
80100fe2:	83 c4 10             	add    $0x10,%esp
80100fe5:	c1 fb 03             	sar    $0x3,%ebx
80100fe8:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
80100fed:	0f b6 ca             	movzbl %dl,%ecx
80100ff0:	85 c1                	test   %eax,%ecx
80100ff2:	74 23                	je     80101017 <bfree+0x63>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80100ff4:	f7 d0                	not    %eax
80100ff6:	21 d0                	and    %edx,%eax
80100ff8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80100ffc:	83 ec 0c             	sub    $0xc,%esp
80100fff:	56                   	push   %esi
80101000:	e8 68 19 00 00       	call   8010296d <log_write>
  brelse(bp);
80101005:	89 34 24             	mov    %esi,(%esp)
80101008:	e8 b4 f1 ff ff       	call   801001c1 <brelse>
}
8010100d:	83 c4 10             	add    $0x10,%esp
80101010:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101013:	5b                   	pop    %ebx
80101014:	5e                   	pop    %esi
80101015:	5d                   	pop    %ebp
80101016:	c3                   	ret    
    panic("freeing free block");
80101017:	83 ec 0c             	sub    $0xc,%esp
8010101a:	68 3f 66 10 80       	push   $0x8010663f
8010101f:	e8 20 f3 ff ff       	call   80100344 <panic>

80101024 <balloc>:
{
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	57                   	push   %edi
80101028:	56                   	push   %esi
80101029:	53                   	push   %ebx
8010102a:	83 ec 2c             	sub    $0x2c,%esp
8010102d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101030:	83 3d c0 f9 10 80 00 	cmpl   $0x0,0x8010f9c0
80101037:	0f 84 32 01 00 00    	je     8010116f <balloc+0x14b>
8010103d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80101044:	e9 8f 00 00 00       	jmp    801010d8 <balloc+0xb4>
80101049:	89 c3                	mov    %eax,%ebx
        bp->data[bi/8] |= m;  // Mark block in use.
8010104b:	09 ca                	or     %ecx,%edx
8010104d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101050:	88 54 03 5c          	mov    %dl,0x5c(%ebx,%eax,1)
        log_write(bp);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	53                   	push   %ebx
80101058:	e8 10 19 00 00       	call   8010296d <log_write>
        brelse(bp);
8010105d:	89 1c 24             	mov    %ebx,(%esp)
80101060:	e8 5c f1 ff ff       	call   801001c1 <brelse>
  bp = bread(dev, bno);
80101065:	83 c4 08             	add    $0x8,%esp
80101068:	ff 75 e4             	pushl  -0x1c(%ebp)
8010106b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010106e:	e8 37 f0 ff ff       	call   801000aa <bread>
80101073:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80101075:	83 c4 0c             	add    $0xc,%esp
80101078:	68 00 02 00 00       	push   $0x200
8010107d:	6a 00                	push   $0x0
8010107f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101082:	50                   	push   %eax
80101083:	e8 88 2d 00 00       	call   80103e10 <memset>
  log_write(bp);
80101088:	89 34 24             	mov    %esi,(%esp)
8010108b:	e8 dd 18 00 00       	call   8010296d <log_write>
  brelse(bp);
80101090:	89 34 24             	mov    %esi,(%esp)
80101093:	e8 29 f1 ff ff       	call   801001c1 <brelse>
}
80101098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109e:	5b                   	pop    %ebx
8010109f:	5e                   	pop    %esi
801010a0:	5f                   	pop    %edi
801010a1:	5d                   	pop    %ebp
801010a2:	c3                   	ret    
801010a3:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      m = 1 << (bi % 8);
801010a8:	b9 01 00 00 00       	mov    $0x1,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801010b4:	eb 95                	jmp    8010104b <balloc+0x27>
    brelse(bp);
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	50                   	push   %eax
801010ba:	e8 02 f1 ff ff       	call   801001c1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010bf:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
801010c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010c9:	83 c4 10             	add    $0x10,%esp
801010cc:	39 05 c0 f9 10 80    	cmp    %eax,0x8010f9c0
801010d2:	0f 86 97 00 00 00    	jbe    8010116f <balloc+0x14b>
    bp = bread(dev, BBLOCK(b, sb));
801010d8:	83 ec 08             	sub    $0x8,%esp
801010db:	8b 7d d8             	mov    -0x28(%ebp),%edi
801010de:	89 fb                	mov    %edi,%ebx
801010e0:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
801010e6:	85 ff                	test   %edi,%edi
801010e8:	0f 49 c7             	cmovns %edi,%eax
801010eb:	c1 f8 0c             	sar    $0xc,%eax
801010ee:	03 05 d8 f9 10 80    	add    0x8010f9d8,%eax
801010f4:	50                   	push   %eax
801010f5:	ff 75 d4             	pushl  -0x2c(%ebp)
801010f8:	e8 ad ef ff ff       	call   801000aa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010fd:	8b 0d c0 f9 10 80    	mov    0x8010f9c0,%ecx
80101103:	83 c4 10             	add    $0x10,%esp
80101106:	39 cf                	cmp    %ecx,%edi
80101108:	73 ac                	jae    801010b6 <balloc+0x92>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010110a:	0f b6 50 5c          	movzbl 0x5c(%eax),%edx
8010110e:	f6 c2 01             	test   $0x1,%dl
80101111:	74 90                	je     801010a3 <balloc+0x7f>
80101113:	29 f9                	sub    %edi,%ecx
80101115:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101118:	be 01 00 00 00       	mov    $0x1,%esi
8010111d:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
80101120:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101123:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101126:	74 8e                	je     801010b6 <balloc+0x92>
      m = 1 << (bi % 8);
80101128:	89 f2                	mov    %esi,%edx
8010112a:	c1 fa 1f             	sar    $0x1f,%edx
8010112d:	c1 ea 1d             	shr    $0x1d,%edx
80101130:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
80101133:	83 e1 07             	and    $0x7,%ecx
80101136:	29 d1                	sub    %edx,%ecx
80101138:	bf 01 00 00 00       	mov    $0x1,%edi
8010113d:	d3 e7                	shl    %cl,%edi
8010113f:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101141:	8d 56 07             	lea    0x7(%esi),%edx
80101144:	85 f6                	test   %esi,%esi
80101146:	0f 49 d6             	cmovns %esi,%edx
80101149:	c1 fa 03             	sar    $0x3,%edx
8010114c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010114f:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
80101154:	0f b6 fa             	movzbl %dl,%edi
80101157:	85 cf                	test   %ecx,%edi
80101159:	0f 84 ea fe ff ff    	je     80101049 <balloc+0x25>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010115f:	83 c6 01             	add    $0x1,%esi
80101162:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80101168:	75 b3                	jne    8010111d <balloc+0xf9>
8010116a:	e9 47 ff ff ff       	jmp    801010b6 <balloc+0x92>
  panic("balloc: out of blocks");
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	68 52 66 10 80       	push   $0x80106652
80101177:	e8 c8 f1 ff ff       	call   80100344 <panic>

8010117c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010117c:	55                   	push   %ebp
8010117d:	89 e5                	mov    %esp,%ebp
8010117f:	57                   	push   %edi
80101180:	56                   	push   %esi
80101181:	53                   	push   %ebx
80101182:	83 ec 1c             	sub    $0x1c,%esp
80101185:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101187:	83 fa 0b             	cmp    $0xb,%edx
8010118a:	77 18                	ja     801011a4 <bmap+0x28>
8010118c:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
8010118f:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101192:	85 db                	test   %ebx,%ebx
80101194:	75 49                	jne    801011df <bmap+0x63>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101196:	8b 00                	mov    (%eax),%eax
80101198:	e8 87 fe ff ff       	call   80101024 <balloc>
8010119d:	89 c3                	mov    %eax,%ebx
8010119f:	89 47 5c             	mov    %eax,0x5c(%edi)
801011a2:	eb 3b                	jmp    801011df <bmap+0x63>
    return addr;
  }
  bn -= NDIRECT;
801011a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801011a7:	83 fb 7f             	cmp    $0x7f,%ebx
801011aa:	77 68                	ja     80101214 <bmap+0x98>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801011ac:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011b2:	85 c0                	test   %eax,%eax
801011b4:	74 33                	je     801011e9 <bmap+0x6d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801011b6:	83 ec 08             	sub    $0x8,%esp
801011b9:	50                   	push   %eax
801011ba:	ff 36                	pushl  (%esi)
801011bc:	e8 e9 ee ff ff       	call   801000aa <bread>
801011c1:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801011c3:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
801011c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ca:	8b 18                	mov    (%eax),%ebx
801011cc:	83 c4 10             	add    $0x10,%esp
801011cf:	85 db                	test   %ebx,%ebx
801011d1:	74 25                	je     801011f8 <bmap+0x7c>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	57                   	push   %edi
801011d7:	e8 e5 ef ff ff       	call   801001c1 <brelse>
    return addr;
801011dc:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801011df:	89 d8                	mov    %ebx,%eax
801011e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e4:	5b                   	pop    %ebx
801011e5:	5e                   	pop    %esi
801011e6:	5f                   	pop    %edi
801011e7:	5d                   	pop    %ebp
801011e8:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011e9:	8b 06                	mov    (%esi),%eax
801011eb:	e8 34 fe ff ff       	call   80101024 <balloc>
801011f0:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801011f6:	eb be                	jmp    801011b6 <bmap+0x3a>
      a[bn] = addr = balloc(ip->dev);
801011f8:	8b 06                	mov    (%esi),%eax
801011fa:	e8 25 fe ff ff       	call   80101024 <balloc>
801011ff:	89 c3                	mov    %eax,%ebx
80101201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101204:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
80101206:	83 ec 0c             	sub    $0xc,%esp
80101209:	57                   	push   %edi
8010120a:	e8 5e 17 00 00       	call   8010296d <log_write>
8010120f:	83 c4 10             	add    $0x10,%esp
80101212:	eb bf                	jmp    801011d3 <bmap+0x57>
  panic("bmap: out of range");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 68 66 10 80       	push   $0x80106668
8010121c:	e8 23 f1 ff ff       	call   80100344 <panic>

80101221 <iget>:
{
80101221:	55                   	push   %ebp
80101222:	89 e5                	mov    %esp,%ebp
80101224:	57                   	push   %edi
80101225:	56                   	push   %esi
80101226:	53                   	push   %ebx
80101227:	83 ec 28             	sub    $0x28,%esp
8010122a:	89 c7                	mov    %eax,%edi
8010122c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010122f:	68 e0 f9 10 80       	push   $0x8010f9e0
80101234:	e8 29 2b 00 00       	call   80103d62 <acquire>
80101239:	83 c4 10             	add    $0x10,%esp
  empty = 0;
8010123c:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	bb 14 fa 10 80       	mov    $0x8010fa14,%ebx
80101246:	eb 1c                	jmp    80101264 <iget+0x43>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 c0                	test   %eax,%eax
8010124a:	75 0a                	jne    80101256 <iget+0x35>
8010124c:	85 f6                	test   %esi,%esi
8010124e:	0f 94 c0             	sete   %al
80101251:	84 c0                	test   %al,%al
80101253:	0f 45 f3             	cmovne %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101256:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010125c:	81 fb 34 16 11 80    	cmp    $0x80111634,%ebx
80101262:	73 2d                	jae    80101291 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101264:	8b 43 08             	mov    0x8(%ebx),%eax
80101267:	85 c0                	test   %eax,%eax
80101269:	7e dd                	jle    80101248 <iget+0x27>
8010126b:	39 3b                	cmp    %edi,(%ebx)
8010126d:	75 e7                	jne    80101256 <iget+0x35>
8010126f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101272:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101275:	75 df                	jne    80101256 <iget+0x35>
      ip->ref++;
80101277:	83 c0 01             	add    $0x1,%eax
8010127a:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010127d:	83 ec 0c             	sub    $0xc,%esp
80101280:	68 e0 f9 10 80       	push   $0x8010f9e0
80101285:	e8 3f 2b 00 00       	call   80103dc9 <release>
      return ip;
8010128a:	83 c4 10             	add    $0x10,%esp
8010128d:	89 de                	mov    %ebx,%esi
8010128f:	eb 2a                	jmp    801012bb <iget+0x9a>
  if(empty == 0)
80101291:	85 f6                	test   %esi,%esi
80101293:	74 30                	je     801012c5 <iget+0xa4>
  ip->dev = dev;
80101295:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010129a:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010129d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a4:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ab:	83 ec 0c             	sub    $0xc,%esp
801012ae:	68 e0 f9 10 80       	push   $0x8010f9e0
801012b3:	e8 11 2b 00 00       	call   80103dc9 <release>
  return ip;
801012b8:	83 c4 10             	add    $0x10,%esp
}
801012bb:	89 f0                	mov    %esi,%eax
801012bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c0:	5b                   	pop    %ebx
801012c1:	5e                   	pop    %esi
801012c2:	5f                   	pop    %edi
801012c3:	5d                   	pop    %ebp
801012c4:	c3                   	ret    
    panic("iget: no inodes");
801012c5:	83 ec 0c             	sub    $0xc,%esp
801012c8:	68 7b 66 10 80       	push   $0x8010667b
801012cd:	e8 72 f0 ff ff       	call   80100344 <panic>

801012d2 <readsb>:
{
801012d2:	55                   	push   %ebp
801012d3:	89 e5                	mov    %esp,%ebp
801012d5:	53                   	push   %ebx
801012d6:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012d9:	6a 01                	push   $0x1
801012db:	ff 75 08             	pushl  0x8(%ebp)
801012de:	e8 c7 ed ff ff       	call   801000aa <bread>
801012e3:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012e5:	83 c4 0c             	add    $0xc,%esp
801012e8:	6a 1c                	push   $0x1c
801012ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ed:	50                   	push   %eax
801012ee:	ff 75 0c             	pushl  0xc(%ebp)
801012f1:	e8 af 2b 00 00       	call   80103ea5 <memmove>
  brelse(bp);
801012f6:	89 1c 24             	mov    %ebx,(%esp)
801012f9:	e8 c3 ee ff ff       	call   801001c1 <brelse>
}
801012fe:	83 c4 10             	add    $0x10,%esp
80101301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101304:	c9                   	leave  
80101305:	c3                   	ret    

80101306 <iinit>:
{
80101306:	55                   	push   %ebp
80101307:	89 e5                	mov    %esp,%ebp
80101309:	56                   	push   %esi
8010130a:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
8010130b:	83 ec 08             	sub    $0x8,%esp
8010130e:	68 8b 66 10 80       	push   $0x8010668b
80101313:	68 e0 f9 10 80       	push   $0x8010f9e0
80101318:	e8 fd 28 00 00       	call   80103c1a <initlock>
8010131d:	bb 20 fa 10 80       	mov    $0x8010fa20,%ebx
80101322:	be 40 16 11 80       	mov    $0x80111640,%esi
80101327:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
8010132a:	83 ec 08             	sub    $0x8,%esp
8010132d:	68 92 66 10 80       	push   $0x80106692
80101332:	53                   	push   %ebx
80101333:	e8 d8 27 00 00       	call   80103b10 <initsleeplock>
80101338:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(i = 0; i < NINODE; i++) {
8010133e:	83 c4 10             	add    $0x10,%esp
80101341:	39 f3                	cmp    %esi,%ebx
80101343:	75 e5                	jne    8010132a <iinit+0x24>
  readsb(dev, &sb);
80101345:	83 ec 08             	sub    $0x8,%esp
80101348:	68 c0 f9 10 80       	push   $0x8010f9c0
8010134d:	ff 75 08             	pushl  0x8(%ebp)
80101350:	e8 7d ff ff ff       	call   801012d2 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101355:	ff 35 d8 f9 10 80    	pushl  0x8010f9d8
8010135b:	ff 35 d4 f9 10 80    	pushl  0x8010f9d4
80101361:	ff 35 d0 f9 10 80    	pushl  0x8010f9d0
80101367:	ff 35 cc f9 10 80    	pushl  0x8010f9cc
8010136d:	ff 35 c8 f9 10 80    	pushl  0x8010f9c8
80101373:	ff 35 c4 f9 10 80    	pushl  0x8010f9c4
80101379:	ff 35 c0 f9 10 80    	pushl  0x8010f9c0
8010137f:	68 f8 66 10 80       	push   $0x801066f8
80101384:	e8 58 f2 ff ff       	call   801005e1 <cprintf>
}
80101389:	83 c4 30             	add    $0x30,%esp
8010138c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010138f:	5b                   	pop    %ebx
80101390:	5e                   	pop    %esi
80101391:	5d                   	pop    %ebp
80101392:	c3                   	ret    

80101393 <ialloc>:
{
80101393:	55                   	push   %ebp
80101394:	89 e5                	mov    %esp,%ebp
80101396:	57                   	push   %edi
80101397:	56                   	push   %esi
80101398:	53                   	push   %ebx
80101399:	83 ec 1c             	sub    $0x1c,%esp
8010139c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010139f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013a2:	83 3d c8 f9 10 80 01 	cmpl   $0x1,0x8010f9c8
801013a9:	76 4d                	jbe    801013f8 <ialloc+0x65>
801013ab:	bb 01 00 00 00       	mov    $0x1,%ebx
801013b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
801013b3:	83 ec 08             	sub    $0x8,%esp
801013b6:	89 d8                	mov    %ebx,%eax
801013b8:	c1 e8 03             	shr    $0x3,%eax
801013bb:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
801013c1:	50                   	push   %eax
801013c2:	ff 75 08             	pushl  0x8(%ebp)
801013c5:	e8 e0 ec ff ff       	call   801000aa <bread>
801013ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013cc:	89 d8                	mov    %ebx,%eax
801013ce:	83 e0 07             	and    $0x7,%eax
801013d1:	c1 e0 06             	shl    $0x6,%eax
801013d4:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013d8:	83 c4 10             	add    $0x10,%esp
801013db:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013df:	74 24                	je     80101405 <ialloc+0x72>
    brelse(bp);
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	56                   	push   %esi
801013e5:	e8 d7 ed ff ff       	call   801001c1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013ea:	83 c3 01             	add    $0x1,%ebx
801013ed:	83 c4 10             	add    $0x10,%esp
801013f0:	39 1d c8 f9 10 80    	cmp    %ebx,0x8010f9c8
801013f6:	77 b8                	ja     801013b0 <ialloc+0x1d>
  panic("ialloc: no inodes");
801013f8:	83 ec 0c             	sub    $0xc,%esp
801013fb:	68 98 66 10 80       	push   $0x80106698
80101400:	e8 3f ef ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
80101405:	83 ec 04             	sub    $0x4,%esp
80101408:	6a 40                	push   $0x40
8010140a:	6a 00                	push   $0x0
8010140c:	57                   	push   %edi
8010140d:	e8 fe 29 00 00       	call   80103e10 <memset>
      dip->type = type;
80101412:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80101416:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101419:	89 34 24             	mov    %esi,(%esp)
8010141c:	e8 4c 15 00 00       	call   8010296d <log_write>
      brelse(bp);
80101421:	89 34 24             	mov    %esi,(%esp)
80101424:	e8 98 ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
80101429:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010142c:	8b 45 08             	mov    0x8(%ebp),%eax
8010142f:	e8 ed fd ff ff       	call   80101221 <iget>
}
80101434:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101437:	5b                   	pop    %ebx
80101438:	5e                   	pop    %esi
80101439:	5f                   	pop    %edi
8010143a:	5d                   	pop    %ebp
8010143b:	c3                   	ret    

8010143c <iupdate>:
{
8010143c:	55                   	push   %ebp
8010143d:	89 e5                	mov    %esp,%ebp
8010143f:	56                   	push   %esi
80101440:	53                   	push   %ebx
80101441:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101444:	83 ec 08             	sub    $0x8,%esp
80101447:	8b 43 04             	mov    0x4(%ebx),%eax
8010144a:	c1 e8 03             	shr    $0x3,%eax
8010144d:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
80101453:	50                   	push   %eax
80101454:	ff 33                	pushl  (%ebx)
80101456:	e8 4f ec ff ff       	call   801000aa <bread>
8010145b:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010145d:	8b 43 04             	mov    0x4(%ebx),%eax
80101460:	83 e0 07             	and    $0x7,%eax
80101463:	c1 e0 06             	shl    $0x6,%eax
80101466:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010146a:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
8010146e:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101471:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101475:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101479:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
8010147d:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101481:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101485:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101489:	8b 53 58             	mov    0x58(%ebx),%edx
8010148c:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010148f:	83 c4 0c             	add    $0xc,%esp
80101492:	6a 34                	push   $0x34
80101494:	83 c3 5c             	add    $0x5c,%ebx
80101497:	53                   	push   %ebx
80101498:	83 c0 0c             	add    $0xc,%eax
8010149b:	50                   	push   %eax
8010149c:	e8 04 2a 00 00       	call   80103ea5 <memmove>
  log_write(bp);
801014a1:	89 34 24             	mov    %esi,(%esp)
801014a4:	e8 c4 14 00 00       	call   8010296d <log_write>
  brelse(bp);
801014a9:	89 34 24             	mov    %esi,(%esp)
801014ac:	e8 10 ed ff ff       	call   801001c1 <brelse>
}
801014b1:	83 c4 10             	add    $0x10,%esp
801014b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b7:	5b                   	pop    %ebx
801014b8:	5e                   	pop    %esi
801014b9:	5d                   	pop    %ebp
801014ba:	c3                   	ret    

801014bb <idup>:
{
801014bb:	55                   	push   %ebp
801014bc:	89 e5                	mov    %esp,%ebp
801014be:	53                   	push   %ebx
801014bf:	83 ec 10             	sub    $0x10,%esp
801014c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801014c5:	68 e0 f9 10 80       	push   $0x8010f9e0
801014ca:	e8 93 28 00 00       	call   80103d62 <acquire>
  ip->ref++;
801014cf:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801014d3:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
801014da:	e8 ea 28 00 00       	call   80103dc9 <release>
}
801014df:	89 d8                	mov    %ebx,%eax
801014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e4:	c9                   	leave  
801014e5:	c3                   	ret    

801014e6 <ilock>:
{
801014e6:	55                   	push   %ebp
801014e7:	89 e5                	mov    %esp,%ebp
801014e9:	56                   	push   %esi
801014ea:	53                   	push   %ebx
801014eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801014ee:	85 db                	test   %ebx,%ebx
801014f0:	74 22                	je     80101514 <ilock+0x2e>
801014f2:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801014f6:	7e 1c                	jle    80101514 <ilock+0x2e>
  acquiresleep(&ip->lock);
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	8d 43 0c             	lea    0xc(%ebx),%eax
801014fe:	50                   	push   %eax
801014ff:	e8 3f 26 00 00       	call   80103b43 <acquiresleep>
  if(ip->valid == 0){
80101504:	83 c4 10             	add    $0x10,%esp
80101507:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010150b:	74 14                	je     80101521 <ilock+0x3b>
}
8010150d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101510:	5b                   	pop    %ebx
80101511:	5e                   	pop    %esi
80101512:	5d                   	pop    %ebp
80101513:	c3                   	ret    
    panic("ilock");
80101514:	83 ec 0c             	sub    $0xc,%esp
80101517:	68 aa 66 10 80       	push   $0x801066aa
8010151c:	e8 23 ee ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101521:	83 ec 08             	sub    $0x8,%esp
80101524:	8b 43 04             	mov    0x4(%ebx),%eax
80101527:	c1 e8 03             	shr    $0x3,%eax
8010152a:	03 05 d4 f9 10 80    	add    0x8010f9d4,%eax
80101530:	50                   	push   %eax
80101531:	ff 33                	pushl  (%ebx)
80101533:	e8 72 eb ff ff       	call   801000aa <bread>
80101538:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010153a:	8b 43 04             	mov    0x4(%ebx),%eax
8010153d:	83 e0 07             	and    $0x7,%eax
80101540:	c1 e0 06             	shl    $0x6,%eax
80101543:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101547:	0f b7 10             	movzwl (%eax),%edx
8010154a:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010154e:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101552:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101556:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010155a:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010155e:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101562:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101566:	8b 50 08             	mov    0x8(%eax),%edx
80101569:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010156c:	83 c4 0c             	add    $0xc,%esp
8010156f:	6a 34                	push   $0x34
80101571:	83 c0 0c             	add    $0xc,%eax
80101574:	50                   	push   %eax
80101575:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101578:	50                   	push   %eax
80101579:	e8 27 29 00 00       	call   80103ea5 <memmove>
    brelse(bp);
8010157e:	89 34 24             	mov    %esi,(%esp)
80101581:	e8 3b ec ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
80101586:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010158d:	83 c4 10             	add    $0x10,%esp
80101590:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101595:	0f 85 72 ff ff ff    	jne    8010150d <ilock+0x27>
      panic("ilock: no type");
8010159b:	83 ec 0c             	sub    $0xc,%esp
8010159e:	68 b0 66 10 80       	push   $0x801066b0
801015a3:	e8 9c ed ff ff       	call   80100344 <panic>

801015a8 <iunlock>:
{
801015a8:	55                   	push   %ebp
801015a9:	89 e5                	mov    %esp,%ebp
801015ab:	56                   	push   %esi
801015ac:	53                   	push   %ebx
801015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015b0:	85 db                	test   %ebx,%ebx
801015b2:	74 2c                	je     801015e0 <iunlock+0x38>
801015b4:	8d 73 0c             	lea    0xc(%ebx),%esi
801015b7:	83 ec 0c             	sub    $0xc,%esp
801015ba:	56                   	push   %esi
801015bb:	e8 10 26 00 00       	call   80103bd0 <holdingsleep>
801015c0:	83 c4 10             	add    $0x10,%esp
801015c3:	85 c0                	test   %eax,%eax
801015c5:	74 19                	je     801015e0 <iunlock+0x38>
801015c7:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015cb:	7e 13                	jle    801015e0 <iunlock+0x38>
  releasesleep(&ip->lock);
801015cd:	83 ec 0c             	sub    $0xc,%esp
801015d0:	56                   	push   %esi
801015d1:	e8 bf 25 00 00       	call   80103b95 <releasesleep>
}
801015d6:	83 c4 10             	add    $0x10,%esp
801015d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015dc:	5b                   	pop    %ebx
801015dd:	5e                   	pop    %esi
801015de:	5d                   	pop    %ebp
801015df:	c3                   	ret    
    panic("iunlock");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 bf 66 10 80       	push   $0x801066bf
801015e8:	e8 57 ed ff ff       	call   80100344 <panic>

801015ed <iput>:
{
801015ed:	55                   	push   %ebp
801015ee:	89 e5                	mov    %esp,%ebp
801015f0:	57                   	push   %edi
801015f1:	56                   	push   %esi
801015f2:	53                   	push   %ebx
801015f3:	83 ec 28             	sub    $0x28,%esp
801015f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801015f9:	8d 73 0c             	lea    0xc(%ebx),%esi
801015fc:	56                   	push   %esi
801015fd:	e8 41 25 00 00       	call   80103b43 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101602:	83 c4 10             	add    $0x10,%esp
80101605:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101609:	74 07                	je     80101612 <iput+0x25>
8010160b:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101610:	74 30                	je     80101642 <iput+0x55>
  releasesleep(&ip->lock);
80101612:	83 ec 0c             	sub    $0xc,%esp
80101615:	56                   	push   %esi
80101616:	e8 7a 25 00 00       	call   80103b95 <releasesleep>
  acquire(&icache.lock);
8010161b:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
80101622:	e8 3b 27 00 00       	call   80103d62 <acquire>
  ip->ref--;
80101627:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010162b:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
80101632:	e8 92 27 00 00       	call   80103dc9 <release>
}
80101637:	83 c4 10             	add    $0x10,%esp
8010163a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163d:	5b                   	pop    %ebx
8010163e:	5e                   	pop    %esi
8010163f:	5f                   	pop    %edi
80101640:	5d                   	pop    %ebp
80101641:	c3                   	ret    
    acquire(&icache.lock);
80101642:	83 ec 0c             	sub    $0xc,%esp
80101645:	68 e0 f9 10 80       	push   $0x8010f9e0
8010164a:	e8 13 27 00 00       	call   80103d62 <acquire>
    int r = ip->ref;
8010164f:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101652:	c7 04 24 e0 f9 10 80 	movl   $0x8010f9e0,(%esp)
80101659:	e8 6b 27 00 00       	call   80103dc9 <release>
    if(r == 1){
8010165e:	83 c4 10             	add    $0x10,%esp
80101661:	83 ff 01             	cmp    $0x1,%edi
80101664:	75 ac                	jne    80101612 <iput+0x25>
80101666:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80101669:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
8010166f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80101672:	89 c6                	mov    %eax,%esi
80101674:	eb 07                	jmp    8010167d <iput+0x90>
80101676:	83 c7 04             	add    $0x4,%edi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101679:	39 f7                	cmp    %esi,%edi
8010167b:	74 15                	je     80101692 <iput+0xa5>
    if(ip->addrs[i]){
8010167d:	8b 17                	mov    (%edi),%edx
8010167f:	85 d2                	test   %edx,%edx
80101681:	74 f3                	je     80101676 <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
80101683:	8b 03                	mov    (%ebx),%eax
80101685:	e8 2a f9 ff ff       	call   80100fb4 <bfree>
      ip->addrs[i] = 0;
8010168a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80101690:	eb e4                	jmp    80101676 <iput+0x89>
80101692:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101695:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010169b:	85 c0                	test   %eax,%eax
8010169d:	75 2d                	jne    801016cc <iput+0xdf>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010169f:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801016a6:	83 ec 0c             	sub    $0xc,%esp
801016a9:	53                   	push   %ebx
801016aa:	e8 8d fd ff ff       	call   8010143c <iupdate>
      ip->type = 0;
801016af:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 7f fd ff ff       	call   8010143c <iupdate>
      ip->valid = 0;
801016bd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016c4:	83 c4 10             	add    $0x10,%esp
801016c7:	e9 46 ff ff ff       	jmp    80101612 <iput+0x25>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801016cc:	83 ec 08             	sub    $0x8,%esp
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 d3 e9 ff ff       	call   801000aa <bread>
801016d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801016da:	8d 78 5c             	lea    0x5c(%eax),%edi
801016dd:	05 5c 02 00 00       	add    $0x25c,%eax
801016e2:	83 c4 10             	add    $0x10,%esp
801016e5:	89 75 e0             	mov    %esi,-0x20(%ebp)
801016e8:	89 c6                	mov    %eax,%esi
801016ea:	eb 07                	jmp    801016f3 <iput+0x106>
801016ec:	83 c7 04             	add    $0x4,%edi
    for(j = 0; j < NINDIRECT; j++){
801016ef:	39 fe                	cmp    %edi,%esi
801016f1:	74 0f                	je     80101702 <iput+0x115>
      if(a[j])
801016f3:	8b 17                	mov    (%edi),%edx
801016f5:	85 d2                	test   %edx,%edx
801016f7:	74 f3                	je     801016ec <iput+0xff>
        bfree(ip->dev, a[j]);
801016f9:	8b 03                	mov    (%ebx),%eax
801016fb:	e8 b4 f8 ff ff       	call   80100fb4 <bfree>
80101700:	eb ea                	jmp    801016ec <iput+0xff>
80101702:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101705:	83 ec 0c             	sub    $0xc,%esp
80101708:	ff 75 e4             	pushl  -0x1c(%ebp)
8010170b:	e8 b1 ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101710:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101716:	8b 03                	mov    (%ebx),%eax
80101718:	e8 97 f8 ff ff       	call   80100fb4 <bfree>
    ip->addrs[NDIRECT] = 0;
8010171d:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101724:	00 00 00 
80101727:	83 c4 10             	add    $0x10,%esp
8010172a:	e9 70 ff ff ff       	jmp    8010169f <iput+0xb2>

8010172f <iunlockput>:
{
8010172f:	55                   	push   %ebp
80101730:	89 e5                	mov    %esp,%ebp
80101732:	53                   	push   %ebx
80101733:	83 ec 10             	sub    $0x10,%esp
80101736:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101739:	53                   	push   %ebx
8010173a:	e8 69 fe ff ff       	call   801015a8 <iunlock>
  iput(ip);
8010173f:	89 1c 24             	mov    %ebx,(%esp)
80101742:	e8 a6 fe ff ff       	call   801015ed <iput>
}
80101747:	83 c4 10             	add    $0x10,%esp
8010174a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010174d:	c9                   	leave  
8010174e:	c3                   	ret    

8010174f <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
8010174f:	55                   	push   %ebp
80101750:	89 e5                	mov    %esp,%ebp
80101752:	8b 55 08             	mov    0x8(%ebp),%edx
80101755:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101758:	8b 0a                	mov    (%edx),%ecx
8010175a:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010175d:	8b 4a 04             	mov    0x4(%edx),%ecx
80101760:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101763:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101767:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010176a:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010176e:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101772:	8b 52 58             	mov    0x58(%edx),%edx
80101775:	89 50 10             	mov    %edx,0x10(%eax)
}
80101778:	5d                   	pop    %ebp
80101779:	c3                   	ret    

8010177a <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010177a:	55                   	push   %ebp
8010177b:	89 e5                	mov    %esp,%ebp
8010177d:	57                   	push   %edi
8010177e:	56                   	push   %esi
8010177f:	53                   	push   %ebx
80101780:	83 ec 1c             	sub    $0x1c,%esp
80101783:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101786:	8b 45 08             	mov    0x8(%ebp),%eax
80101789:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010178e:	0f 84 9d 00 00 00    	je     80101831 <readi+0xb7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	8b 40 58             	mov    0x58(%eax),%eax
8010179a:	39 f8                	cmp    %edi,%eax
8010179c:	0f 82 c6 00 00 00    	jb     80101868 <readi+0xee>
801017a2:	89 fa                	mov    %edi,%edx
801017a4:	03 55 14             	add    0x14(%ebp),%edx
801017a7:	0f 82 c2 00 00 00    	jb     8010186f <readi+0xf5>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801017ad:	89 c1                	mov    %eax,%ecx
801017af:	29 f9                	sub    %edi,%ecx
801017b1:	39 d0                	cmp    %edx,%eax
801017b3:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
801017b7:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017ba:	85 c9                	test   %ecx,%ecx
801017bc:	74 68                	je     80101826 <readi+0xac>
801017be:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017c3:	89 fa                	mov    %edi,%edx
801017c5:	c1 ea 09             	shr    $0x9,%edx
801017c8:	8b 45 08             	mov    0x8(%ebp),%eax
801017cb:	e8 ac f9 ff ff       	call   8010117c <bmap>
801017d0:	83 ec 08             	sub    $0x8,%esp
801017d3:	50                   	push   %eax
801017d4:	8b 45 08             	mov    0x8(%ebp),%eax
801017d7:	ff 30                	pushl  (%eax)
801017d9:	e8 cc e8 ff ff       	call   801000aa <bread>
801017de:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801017e0:	89 f8                	mov    %edi,%eax
801017e2:	25 ff 01 00 00       	and    $0x1ff,%eax
801017e7:	bb 00 02 00 00       	mov    $0x200,%ebx
801017ec:	29 c3                	sub    %eax,%ebx
801017ee:	8b 55 14             	mov    0x14(%ebp),%edx
801017f1:	29 f2                	sub    %esi,%edx
801017f3:	83 c4 0c             	add    $0xc,%esp
801017f6:	39 d3                	cmp    %edx,%ebx
801017f8:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801017fb:	53                   	push   %ebx
801017fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801017ff:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101803:	50                   	push   %eax
80101804:	ff 75 0c             	pushl  0xc(%ebp)
80101807:	e8 99 26 00 00       	call   80103ea5 <memmove>
    brelse(bp);
8010180c:	83 c4 04             	add    $0x4,%esp
8010180f:	ff 75 e4             	pushl  -0x1c(%ebp)
80101812:	e8 aa e9 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101817:	01 de                	add    %ebx,%esi
80101819:	01 df                	add    %ebx,%edi
8010181b:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010181e:	83 c4 10             	add    $0x10,%esp
80101821:	39 75 14             	cmp    %esi,0x14(%ebp)
80101824:	77 9d                	ja     801017c3 <readi+0x49>
  }
  return n;
80101826:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
80101830:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101831:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101835:	66 83 f8 09          	cmp    $0x9,%ax
80101839:	77 1f                	ja     8010185a <readi+0xe0>
8010183b:	98                   	cwtl   
8010183c:	8b 04 c5 60 f9 10 80 	mov    -0x7fef06a0(,%eax,8),%eax
80101843:	85 c0                	test   %eax,%eax
80101845:	74 1a                	je     80101861 <readi+0xe7>
    return devsw[ip->major].read(ip, dst, n);
80101847:	83 ec 04             	sub    $0x4,%esp
8010184a:	ff 75 14             	pushl  0x14(%ebp)
8010184d:	ff 75 0c             	pushl  0xc(%ebp)
80101850:	ff 75 08             	pushl  0x8(%ebp)
80101853:	ff d0                	call   *%eax
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	eb cf                	jmp    80101829 <readi+0xaf>
      return -1;
8010185a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010185f:	eb c8                	jmp    80101829 <readi+0xaf>
80101861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101866:	eb c1                	jmp    80101829 <readi+0xaf>
    return -1;
80101868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010186d:	eb ba                	jmp    80101829 <readi+0xaf>
8010186f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101874:	eb b3                	jmp    80101829 <readi+0xaf>

80101876 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101876:	55                   	push   %ebp
80101877:	89 e5                	mov    %esp,%ebp
80101879:	57                   	push   %edi
8010187a:	56                   	push   %esi
8010187b:	53                   	push   %ebx
8010187c:	83 ec 1c             	sub    $0x1c,%esp
8010187f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101882:	8b 45 08             	mov    0x8(%ebp),%eax
80101885:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010188a:	0f 84 ae 00 00 00    	je     8010193e <writei+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	39 70 58             	cmp    %esi,0x58(%eax)
80101896:	0f 82 ed 00 00 00    	jb     80101989 <writei+0x113>
8010189c:	89 f0                	mov    %esi,%eax
8010189e:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
801018a1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018a6:	0f 87 e4 00 00 00    	ja     80101990 <writei+0x11a>
801018ac:	39 f0                	cmp    %esi,%eax
801018ae:	0f 82 dc 00 00 00    	jb     80101990 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018b8:	74 79                	je     80101933 <writei+0xbd>
801018ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018c1:	89 f2                	mov    %esi,%edx
801018c3:	c1 ea 09             	shr    $0x9,%edx
801018c6:	8b 45 08             	mov    0x8(%ebp),%eax
801018c9:	e8 ae f8 ff ff       	call   8010117c <bmap>
801018ce:	83 ec 08             	sub    $0x8,%esp
801018d1:	50                   	push   %eax
801018d2:	8b 45 08             	mov    0x8(%ebp),%eax
801018d5:	ff 30                	pushl  (%eax)
801018d7:	e8 ce e7 ff ff       	call   801000aa <bread>
801018dc:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801018de:	89 f0                	mov    %esi,%eax
801018e0:	25 ff 01 00 00       	and    $0x1ff,%eax
801018e5:	bb 00 02 00 00       	mov    $0x200,%ebx
801018ea:	29 c3                	sub    %eax,%ebx
801018ec:	8b 55 14             	mov    0x14(%ebp),%edx
801018ef:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801018f2:	83 c4 0c             	add    $0xc,%esp
801018f5:	39 d3                	cmp    %edx,%ebx
801018f7:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801018fa:	53                   	push   %ebx
801018fb:	ff 75 0c             	pushl  0xc(%ebp)
801018fe:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101902:	50                   	push   %eax
80101903:	e8 9d 25 00 00       	call   80103ea5 <memmove>
    log_write(bp);
80101908:	89 3c 24             	mov    %edi,(%esp)
8010190b:	e8 5d 10 00 00       	call   8010296d <log_write>
    brelse(bp);
80101910:	89 3c 24             	mov    %edi,(%esp)
80101913:	e8 a9 e8 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101918:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010191b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010191e:	01 de                	add    %ebx,%esi
80101920:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	39 4d 14             	cmp    %ecx,0x14(%ebp)
80101929:	77 96                	ja     801018c1 <writei+0x4b>
  }

  if(n > 0 && off > ip->size){
8010192b:	8b 45 08             	mov    0x8(%ebp),%eax
8010192e:	39 70 58             	cmp    %esi,0x58(%eax)
80101931:	72 34                	jb     80101967 <writei+0xf1>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101933:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101939:	5b                   	pop    %ebx
8010193a:	5e                   	pop    %esi
8010193b:	5f                   	pop    %edi
8010193c:	5d                   	pop    %ebp
8010193d:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010193e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101942:	66 83 f8 09          	cmp    $0x9,%ax
80101946:	77 33                	ja     8010197b <writei+0x105>
80101948:	98                   	cwtl   
80101949:	8b 04 c5 64 f9 10 80 	mov    -0x7fef069c(,%eax,8),%eax
80101950:	85 c0                	test   %eax,%eax
80101952:	74 2e                	je     80101982 <writei+0x10c>
    return devsw[ip->major].write(ip, src, n);
80101954:	83 ec 04             	sub    $0x4,%esp
80101957:	ff 75 14             	pushl  0x14(%ebp)
8010195a:	ff 75 0c             	pushl  0xc(%ebp)
8010195d:	ff 75 08             	pushl  0x8(%ebp)
80101960:	ff d0                	call   *%eax
80101962:	83 c4 10             	add    $0x10,%esp
80101965:	eb cf                	jmp    80101936 <writei+0xc0>
    ip->size = off;
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
80101970:	50                   	push   %eax
80101971:	e8 c6 fa ff ff       	call   8010143c <iupdate>
80101976:	83 c4 10             	add    $0x10,%esp
80101979:	eb b8                	jmp    80101933 <writei+0xbd>
      return -1;
8010197b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101980:	eb b4                	jmp    80101936 <writei+0xc0>
80101982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101987:	eb ad                	jmp    80101936 <writei+0xc0>
    return -1;
80101989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010198e:	eb a6                	jmp    80101936 <writei+0xc0>
    return -1;
80101990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101995:	eb 9f                	jmp    80101936 <writei+0xc0>

80101997 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101997:	55                   	push   %ebp
80101998:	89 e5                	mov    %esp,%ebp
8010199a:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010199d:	6a 0e                	push   $0xe
8010199f:	ff 75 0c             	pushl  0xc(%ebp)
801019a2:	ff 75 08             	pushl  0x8(%ebp)
801019a5:	e8 5a 25 00 00       	call   80103f04 <strncmp>
}
801019aa:	c9                   	leave  
801019ab:	c3                   	ret    

801019ac <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801019ac:	55                   	push   %ebp
801019ad:	89 e5                	mov    %esp,%ebp
801019af:	57                   	push   %edi
801019b0:	56                   	push   %esi
801019b1:	53                   	push   %ebx
801019b2:	83 ec 1c             	sub    $0x1c,%esp
801019b5:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801019b8:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019bd:	75 15                	jne    801019d4 <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019bf:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019c4:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801019c7:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
801019cc:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
801019d0:	75 24                	jne    801019f6 <dirlookup+0x4a>
801019d2:	eb 6e                	jmp    80101a42 <dirlookup+0x96>
    panic("dirlookup not DIR");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 c7 66 10 80       	push   $0x801066c7
801019dc:	e8 63 e9 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
801019e1:	83 ec 0c             	sub    $0xc,%esp
801019e4:	68 d9 66 10 80       	push   $0x801066d9
801019e9:	e8 56 e9 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019ee:	83 c3 10             	add    $0x10,%ebx
801019f1:	39 5e 58             	cmp    %ebx,0x58(%esi)
801019f4:	76 47                	jbe    80101a3d <dirlookup+0x91>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019f6:	6a 10                	push   $0x10
801019f8:	53                   	push   %ebx
801019f9:	57                   	push   %edi
801019fa:	56                   	push   %esi
801019fb:	e8 7a fd ff ff       	call   8010177a <readi>
80101a00:	83 c4 10             	add    $0x10,%esp
80101a03:	83 f8 10             	cmp    $0x10,%eax
80101a06:	75 d9                	jne    801019e1 <dirlookup+0x35>
    if(de.inum == 0)
80101a08:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a0d:	74 df                	je     801019ee <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a15:	50                   	push   %eax
80101a16:	ff 75 0c             	pushl  0xc(%ebp)
80101a19:	e8 79 ff ff ff       	call   80101997 <namecmp>
80101a1e:	83 c4 10             	add    $0x10,%esp
80101a21:	85 c0                	test   %eax,%eax
80101a23:	75 c9                	jne    801019ee <dirlookup+0x42>
      if(poff)
80101a25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a29:	74 05                	je     80101a30 <dirlookup+0x84>
        *poff = off;
80101a2b:	8b 45 10             	mov    0x10(%ebp),%eax
80101a2e:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a30:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a34:	8b 06                	mov    (%esi),%eax
80101a36:	e8 e6 f7 ff ff       	call   80101221 <iget>
80101a3b:	eb 05                	jmp    80101a42 <dirlookup+0x96>
  return 0;
80101a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a45:	5b                   	pop    %ebx
80101a46:	5e                   	pop    %esi
80101a47:	5f                   	pop    %edi
80101a48:	5d                   	pop    %ebp
80101a49:	c3                   	ret    

80101a4a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a4a:	55                   	push   %ebp
80101a4b:	89 e5                	mov    %esp,%ebp
80101a4d:	57                   	push   %edi
80101a4e:	56                   	push   %esi
80101a4f:	53                   	push   %ebx
80101a50:	83 ec 1c             	sub    $0x1c,%esp
80101a53:	89 c6                	mov    %eax,%esi
80101a55:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a58:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a5b:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a5e:	74 1a                	je     80101a7a <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a60:	e8 cf 18 00 00       	call   80103334 <myproc>
80101a65:	83 ec 0c             	sub    $0xc,%esp
80101a68:	ff 70 68             	pushl  0x68(%eax)
80101a6b:	e8 4b fa ff ff       	call   801014bb <idup>
80101a70:	89 c7                	mov    %eax,%edi
80101a72:	83 c4 10             	add    $0x10,%esp
80101a75:	e9 d4 00 00 00       	jmp    80101b4e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
80101a7a:	ba 01 00 00 00       	mov    $0x1,%edx
80101a7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101a84:	e8 98 f7 ff ff       	call   80101221 <iget>
80101a89:	89 c7                	mov    %eax,%edi
80101a8b:	e9 be 00 00 00       	jmp    80101b4e <namex+0x104>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a90:	83 ec 0c             	sub    $0xc,%esp
80101a93:	57                   	push   %edi
80101a94:	e8 96 fc ff ff       	call   8010172f <iunlockput>
      return 0;
80101a99:	83 c4 10             	add    $0x10,%esp
80101a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101aa1:	89 f8                	mov    %edi,%eax
80101aa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa6:	5b                   	pop    %ebx
80101aa7:	5e                   	pop    %esi
80101aa8:	5f                   	pop    %edi
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
      iunlock(ip);
80101aab:	83 ec 0c             	sub    $0xc,%esp
80101aae:	57                   	push   %edi
80101aaf:	e8 f4 fa ff ff       	call   801015a8 <iunlock>
      return ip;
80101ab4:	83 c4 10             	add    $0x10,%esp
80101ab7:	eb e8                	jmp    80101aa1 <namex+0x57>
      iunlockput(ip);
80101ab9:	83 ec 0c             	sub    $0xc,%esp
80101abc:	57                   	push   %edi
80101abd:	e8 6d fc ff ff       	call   8010172f <iunlockput>
      return 0;
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	89 f7                	mov    %esi,%edi
80101ac7:	eb d8                	jmp    80101aa1 <namex+0x57>
  while(*path != '/' && *path != 0)
80101ac9:	89 f3                	mov    %esi,%ebx
  len = path - s;
80101acb:	89 d8                	mov    %ebx,%eax
80101acd:	29 f0                	sub    %esi,%eax
80101acf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101ad2:	83 f8 0d             	cmp    $0xd,%eax
80101ad5:	0f 8e b4 00 00 00    	jle    80101b8f <namex+0x145>
    memmove(name, s, DIRSIZ);
80101adb:	83 ec 04             	sub    $0x4,%esp
80101ade:	6a 0e                	push   $0xe
80101ae0:	56                   	push   %esi
80101ae1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ae4:	e8 bc 23 00 00       	call   80103ea5 <memmove>
80101ae9:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101aec:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101aef:	75 08                	jne    80101af9 <namex+0xaf>
    path++;
80101af1:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101af4:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101af7:	74 f8                	je     80101af1 <namex+0xa7>
  while((path = skipelem(path, name)) != 0){
80101af9:	85 db                	test   %ebx,%ebx
80101afb:	0f 84 ad 00 00 00    	je     80101bae <namex+0x164>
    ilock(ip);
80101b01:	83 ec 0c             	sub    $0xc,%esp
80101b04:	57                   	push   %edi
80101b05:	e8 dc f9 ff ff       	call   801014e6 <ilock>
    if(ip->type != T_DIR){
80101b0a:	83 c4 10             	add    $0x10,%esp
80101b0d:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101b12:	0f 85 78 ff ff ff    	jne    80101a90 <namex+0x46>
    if(nameiparent && *path == '\0'){
80101b18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101b1c:	74 05                	je     80101b23 <namex+0xd9>
80101b1e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b21:	74 88                	je     80101aab <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101b23:	83 ec 04             	sub    $0x4,%esp
80101b26:	6a 00                	push   $0x0
80101b28:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b2b:	57                   	push   %edi
80101b2c:	e8 7b fe ff ff       	call   801019ac <dirlookup>
80101b31:	89 c6                	mov    %eax,%esi
80101b33:	83 c4 10             	add    $0x10,%esp
80101b36:	85 c0                	test   %eax,%eax
80101b38:	0f 84 7b ff ff ff    	je     80101ab9 <namex+0x6f>
    iunlockput(ip);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	57                   	push   %edi
80101b42:	e8 e8 fb ff ff       	call   8010172f <iunlockput>
    ip = next;
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	89 f7                	mov    %esi,%edi
80101b4c:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101b4e:	0f b6 06             	movzbl (%esi),%eax
80101b51:	3c 2f                	cmp    $0x2f,%al
80101b53:	75 0a                	jne    80101b5f <namex+0x115>
    path++;
80101b55:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
80101b58:	0f b6 06             	movzbl (%esi),%eax
80101b5b:	3c 2f                	cmp    $0x2f,%al
80101b5d:	74 f6                	je     80101b55 <namex+0x10b>
  if(*path == 0)
80101b5f:	84 c0                	test   %al,%al
80101b61:	74 4b                	je     80101bae <namex+0x164>
  while(*path != '/' && *path != 0)
80101b63:	0f b6 06             	movzbl (%esi),%eax
80101b66:	3c 2f                	cmp    $0x2f,%al
80101b68:	0f 84 5b ff ff ff    	je     80101ac9 <namex+0x7f>
80101b6e:	84 c0                	test   %al,%al
80101b70:	0f 84 53 ff ff ff    	je     80101ac9 <namex+0x7f>
80101b76:	89 f3                	mov    %esi,%ebx
    path++;
80101b78:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101b7b:	0f b6 03             	movzbl (%ebx),%eax
80101b7e:	3c 2f                	cmp    $0x2f,%al
80101b80:	0f 84 45 ff ff ff    	je     80101acb <namex+0x81>
80101b86:	84 c0                	test   %al,%al
80101b88:	75 ee                	jne    80101b78 <namex+0x12e>
80101b8a:	e9 3c ff ff ff       	jmp    80101acb <namex+0x81>
    memmove(name, s, len);
80101b8f:	83 ec 04             	sub    $0x4,%esp
80101b92:	ff 75 e0             	pushl  -0x20(%ebp)
80101b95:	56                   	push   %esi
80101b96:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b99:	56                   	push   %esi
80101b9a:	e8 06 23 00 00       	call   80103ea5 <memmove>
    name[len] = 0;
80101b9f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ba2:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
80101ba6:	83 c4 10             	add    $0x10,%esp
80101ba9:	e9 3e ff ff ff       	jmp    80101aec <namex+0xa2>
  if(nameiparent){
80101bae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101bb2:	0f 84 e9 fe ff ff    	je     80101aa1 <namex+0x57>
    iput(ip);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	57                   	push   %edi
80101bbc:	e8 2c fa ff ff       	call   801015ed <iput>
    return 0;
80101bc1:	83 c4 10             	add    $0x10,%esp
80101bc4:	bf 00 00 00 00       	mov    $0x0,%edi
80101bc9:	e9 d3 fe ff ff       	jmp    80101aa1 <namex+0x57>

80101bce <dirlink>:
{
80101bce:	55                   	push   %ebp
80101bcf:	89 e5                	mov    %esp,%ebp
80101bd1:	57                   	push   %edi
80101bd2:	56                   	push   %esi
80101bd3:	53                   	push   %ebx
80101bd4:	83 ec 20             	sub    $0x20,%esp
80101bd7:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bda:	6a 00                	push   $0x0
80101bdc:	ff 75 0c             	pushl  0xc(%ebp)
80101bdf:	56                   	push   %esi
80101be0:	e8 c7 fd ff ff       	call   801019ac <dirlookup>
80101be5:	83 c4 10             	add    $0x10,%esp
80101be8:	85 c0                	test   %eax,%eax
80101bea:	75 6a                	jne    80101c56 <dirlink+0x88>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bec:	8b 5e 58             	mov    0x58(%esi),%ebx
80101bef:	85 db                	test   %ebx,%ebx
80101bf1:	74 29                	je     80101c1c <dirlink+0x4e>
80101bf3:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf8:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bfb:	6a 10                	push   $0x10
80101bfd:	53                   	push   %ebx
80101bfe:	57                   	push   %edi
80101bff:	56                   	push   %esi
80101c00:	e8 75 fb ff ff       	call   8010177a <readi>
80101c05:	83 c4 10             	add    $0x10,%esp
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 5c                	jne    80101c69 <dirlink+0x9b>
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 08                	je     80101c1c <dirlink+0x4e>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c14:	83 c3 10             	add    $0x10,%ebx
80101c17:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101c1a:	72 df                	jb     80101bfb <dirlink+0x2d>
  strncpy(de.name, name, DIRSIZ);
80101c1c:	83 ec 04             	sub    $0x4,%esp
80101c1f:	6a 0e                	push   $0xe
80101c21:	ff 75 0c             	pushl  0xc(%ebp)
80101c24:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c27:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c2a:	50                   	push   %eax
80101c2b:	e8 20 23 00 00       	call   80103f50 <strncpy>
  de.inum = inum;
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c37:	6a 10                	push   $0x10
80101c39:	53                   	push   %ebx
80101c3a:	57                   	push   %edi
80101c3b:	56                   	push   %esi
80101c3c:	e8 35 fc ff ff       	call   80101876 <writei>
80101c41:	83 c4 20             	add    $0x20,%esp
80101c44:	83 f8 10             	cmp    $0x10,%eax
80101c47:	75 2d                	jne    80101c76 <dirlink+0xa8>
  return 0;
80101c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c51:	5b                   	pop    %ebx
80101c52:	5e                   	pop    %esi
80101c53:	5f                   	pop    %edi
80101c54:	5d                   	pop    %ebp
80101c55:	c3                   	ret    
    iput(ip);
80101c56:	83 ec 0c             	sub    $0xc,%esp
80101c59:	50                   	push   %eax
80101c5a:	e8 8e f9 ff ff       	call   801015ed <iput>
    return -1;
80101c5f:	83 c4 10             	add    $0x10,%esp
80101c62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c67:	eb e5                	jmp    80101c4e <dirlink+0x80>
      panic("dirlink read");
80101c69:	83 ec 0c             	sub    $0xc,%esp
80101c6c:	68 e8 66 10 80       	push   $0x801066e8
80101c71:	e8 ce e6 ff ff       	call   80100344 <panic>
    panic("dirlink");
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	68 e2 6c 10 80       	push   $0x80106ce2
80101c7e:	e8 c1 e6 ff ff       	call   80100344 <panic>

80101c83 <namei>:

struct inode*
namei(char *path)
{
80101c83:	55                   	push   %ebp
80101c84:	89 e5                	mov    %esp,%ebp
80101c86:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c89:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c8c:	ba 00 00 00 00       	mov    $0x0,%edx
80101c91:	8b 45 08             	mov    0x8(%ebp),%eax
80101c94:	e8 b1 fd ff ff       	call   80101a4a <namex>
}
80101c99:	c9                   	leave  
80101c9a:	c3                   	ret    

80101c9b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c9b:	55                   	push   %ebp
80101c9c:	89 e5                	mov    %esp,%ebp
80101c9e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ca4:	ba 01 00 00 00       	mov    $0x1,%edx
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	e8 99 fd ff ff       	call   80101a4a <namex>
}
80101cb1:	c9                   	leave  
80101cb2:	c3                   	ret    

80101cb3 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cb3:	55                   	push   %ebp
80101cb4:	89 e5                	mov    %esp,%ebp
80101cb6:	56                   	push   %esi
80101cb7:	53                   	push   %ebx
  if(b == 0)
80101cb8:	85 c0                	test   %eax,%eax
80101cba:	0f 84 84 00 00 00    	je     80101d44 <idestart+0x91>
80101cc0:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cc2:	8b 58 08             	mov    0x8(%eax),%ebx
80101cc5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ccb:	0f 87 80 00 00 00    	ja     80101d51 <idestart+0x9e>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cd6:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101cd7:	83 e0 c0             	and    $0xffffffc0,%eax
80101cda:	3c 40                	cmp    $0x40,%al
80101cdc:	75 f8                	jne    80101cd6 <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cde:	b8 00 00 00 00       	mov    $0x0,%eax
80101ce3:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ce8:	ee                   	out    %al,(%dx)
80101ce9:	b8 01 00 00 00       	mov    $0x1,%eax
80101cee:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cf3:	ee                   	out    %al,(%dx)
80101cf4:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cf9:	89 d8                	mov    %ebx,%eax
80101cfb:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cfc:	89 d8                	mov    %ebx,%eax
80101cfe:	c1 f8 08             	sar    $0x8,%eax
80101d01:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d06:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d07:	89 d8                	mov    %ebx,%eax
80101d09:	c1 f8 10             	sar    $0x10,%eax
80101d0c:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d11:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d12:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d16:	c1 e0 04             	shl    $0x4,%eax
80101d19:	83 e0 10             	and    $0x10,%eax
80101d1c:	83 c8 e0             	or     $0xffffffe0,%eax
80101d1f:	c1 fb 18             	sar    $0x18,%ebx
80101d22:	83 e3 0f             	and    $0xf,%ebx
80101d25:	09 d8                	or     %ebx,%eax
80101d27:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d2c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d2d:	f6 06 04             	testb  $0x4,(%esi)
80101d30:	75 2c                	jne    80101d5e <idestart+0xab>
80101d32:	b8 20 00 00 00       	mov    $0x20,%eax
80101d37:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3c:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d40:	5b                   	pop    %ebx
80101d41:	5e                   	pop    %esi
80101d42:	5d                   	pop    %ebp
80101d43:	c3                   	ret    
    panic("idestart");
80101d44:	83 ec 0c             	sub    $0xc,%esp
80101d47:	68 4b 67 10 80       	push   $0x8010674b
80101d4c:	e8 f3 e5 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101d51:	83 ec 0c             	sub    $0xc,%esp
80101d54:	68 54 67 10 80       	push   $0x80106754
80101d59:	e8 e6 e5 ff ff       	call   80100344 <panic>
80101d5e:	b8 30 00 00 00       	mov    $0x30,%eax
80101d63:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d68:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101d69:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d6c:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d71:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d76:	fc                   	cld    
80101d77:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101d79:	eb c2                	jmp    80101d3d <idestart+0x8a>

80101d7b <ideinit>:
{
80101d7b:	55                   	push   %ebp
80101d7c:	89 e5                	mov    %esp,%ebp
80101d7e:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d81:	68 66 67 10 80       	push   $0x80106766
80101d86:	68 80 95 10 80       	push   $0x80109580
80101d8b:	e8 8a 1e 00 00       	call   80103c1a <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d90:	83 c4 08             	add    $0x8,%esp
80101d93:	a1 00 1d 11 80       	mov    0x80111d00,%eax
80101d98:	83 e8 01             	sub    $0x1,%eax
80101d9b:	50                   	push   %eax
80101d9c:	6a 0e                	push   $0xe
80101d9e:	e8 63 02 00 00       	call   80102006 <ioapicenable>
80101da3:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101da6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dab:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101dac:	83 e0 c0             	and    $0xffffffc0,%eax
80101daf:	3c 40                	cmp    $0x40,%al
80101db1:	75 f8                	jne    80101dab <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101db3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101db8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101dbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dbe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dc3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101dc4:	84 c0                	test   %al,%al
80101dc6:	75 11                	jne    80101dd9 <ideinit+0x5e>
80101dc8:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101dcd:	ec                   	in     (%dx),%al
80101dce:	84 c0                	test   %al,%al
80101dd0:	75 07                	jne    80101dd9 <ideinit+0x5e>
  for(i=0; i<1000; i++){
80101dd2:	83 e9 01             	sub    $0x1,%ecx
80101dd5:	75 f6                	jne    80101dcd <ideinit+0x52>
80101dd7:	eb 0a                	jmp    80101de3 <ideinit+0x68>
      havedisk1 = 1;
80101dd9:	c7 05 60 95 10 80 01 	movl   $0x1,0x80109560
80101de0:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101de3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101de8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ded:	ee                   	out    %al,(%dx)
}
80101dee:	c9                   	leave  
80101def:	c3                   	ret    

80101df0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101df5:	83 ec 0c             	sub    $0xc,%esp
80101df8:	68 80 95 10 80       	push   $0x80109580
80101dfd:	e8 60 1f 00 00       	call   80103d62 <acquire>

  if((b = idequeue) == 0){
80101e02:	8b 1d 64 95 10 80    	mov    0x80109564,%ebx
80101e08:	83 c4 10             	add    $0x10,%esp
80101e0b:	85 db                	test   %ebx,%ebx
80101e0d:	74 48                	je     80101e57 <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e0f:	8b 43 58             	mov    0x58(%ebx),%eax
80101e12:	a3 64 95 10 80       	mov    %eax,0x80109564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e17:	f6 03 04             	testb  $0x4,(%ebx)
80101e1a:	74 4d                	je     80101e69 <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101e1c:	8b 03                	mov    (%ebx),%eax
80101e1e:	83 e0 fb             	and    $0xfffffffb,%eax
80101e21:	83 c8 02             	or     $0x2,%eax
80101e24:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	53                   	push   %ebx
80101e2a:	e8 31 1b 00 00       	call   80103960 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e2f:	a1 64 95 10 80       	mov    0x80109564,%eax
80101e34:	83 c4 10             	add    $0x10,%esp
80101e37:	85 c0                	test   %eax,%eax
80101e39:	74 05                	je     80101e40 <ideintr+0x50>
    idestart(idequeue);
80101e3b:	e8 73 fe ff ff       	call   80101cb3 <idestart>

  release(&idelock);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	68 80 95 10 80       	push   $0x80109580
80101e48:	e8 7c 1f 00 00       	call   80103dc9 <release>
80101e4d:	83 c4 10             	add    $0x10,%esp
}
80101e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e53:	5b                   	pop    %ebx
80101e54:	5f                   	pop    %edi
80101e55:	5d                   	pop    %ebp
80101e56:	c3                   	ret    
    release(&idelock);
80101e57:	83 ec 0c             	sub    $0xc,%esp
80101e5a:	68 80 95 10 80       	push   $0x80109580
80101e5f:	e8 65 1f 00 00       	call   80103dc9 <release>
    return;
80101e64:	83 c4 10             	add    $0x10,%esp
80101e67:	eb e7                	jmp    80101e50 <ideintr+0x60>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e69:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e6e:	ec                   	in     (%dx),%al
80101e6f:	89 c1                	mov    %eax,%ecx
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e71:	83 e0 c0             	and    $0xffffffc0,%eax
80101e74:	3c 40                	cmp    $0x40,%al
80101e76:	75 f6                	jne    80101e6e <ideintr+0x7e>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e78:	f6 c1 21             	test   $0x21,%cl
80101e7b:	75 9f                	jne    80101e1c <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101e7d:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e80:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e85:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e8a:	fc                   	cld    
80101e8b:	f3 6d                	rep insl (%dx),%es:(%edi)
80101e8d:	eb 8d                	jmp    80101e1c <ideintr+0x2c>

80101e8f <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e8f:	55                   	push   %ebp
80101e90:	89 e5                	mov    %esp,%ebp
80101e92:	53                   	push   %ebx
80101e93:	83 ec 10             	sub    $0x10,%esp
80101e96:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e99:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e9c:	50                   	push   %eax
80101e9d:	e8 2e 1d 00 00       	call   80103bd0 <holdingsleep>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	85 c0                	test   %eax,%eax
80101ea7:	74 41                	je     80101eea <iderw+0x5b>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ea9:	8b 03                	mov    (%ebx),%eax
80101eab:	83 e0 06             	and    $0x6,%eax
80101eae:	83 f8 02             	cmp    $0x2,%eax
80101eb1:	74 44                	je     80101ef7 <iderw+0x68>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eb3:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101eb7:	74 09                	je     80101ec2 <iderw+0x33>
80101eb9:	83 3d 60 95 10 80 00 	cmpl   $0x0,0x80109560
80101ec0:	74 42                	je     80101f04 <iderw+0x75>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101ec2:	83 ec 0c             	sub    $0xc,%esp
80101ec5:	68 80 95 10 80       	push   $0x80109580
80101eca:	e8 93 1e 00 00       	call   80103d62 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101ecf:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ed6:	8b 15 64 95 10 80    	mov    0x80109564,%edx
80101edc:	83 c4 10             	add    $0x10,%esp
80101edf:	85 d2                	test   %edx,%edx
80101ee1:	75 30                	jne    80101f13 <iderw+0x84>
80101ee3:	ba 64 95 10 80       	mov    $0x80109564,%edx
80101ee8:	eb 33                	jmp    80101f1d <iderw+0x8e>
    panic("iderw: buf not locked");
80101eea:	83 ec 0c             	sub    $0xc,%esp
80101eed:	68 6a 67 10 80       	push   $0x8010676a
80101ef2:	e8 4d e4 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101ef7:	83 ec 0c             	sub    $0xc,%esp
80101efa:	68 80 67 10 80       	push   $0x80106780
80101eff:	e8 40 e4 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101f04:	83 ec 0c             	sub    $0xc,%esp
80101f07:	68 95 67 10 80       	push   $0x80106795
80101f0c:	e8 33 e4 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f11:	89 c2                	mov    %eax,%edx
80101f13:	8b 42 58             	mov    0x58(%edx),%eax
80101f16:	85 c0                	test   %eax,%eax
80101f18:	75 f7                	jne    80101f11 <iderw+0x82>
80101f1a:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101f1d:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f1f:	39 1d 64 95 10 80    	cmp    %ebx,0x80109564
80101f25:	74 3a                	je     80101f61 <iderw+0xd2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f27:	8b 03                	mov    (%ebx),%eax
80101f29:	83 e0 06             	and    $0x6,%eax
80101f2c:	83 f8 02             	cmp    $0x2,%eax
80101f2f:	74 1b                	je     80101f4c <iderw+0xbd>
    sleep(b, &idelock);
80101f31:	83 ec 08             	sub    $0x8,%esp
80101f34:	68 80 95 10 80       	push   $0x80109580
80101f39:	53                   	push   %ebx
80101f3a:	e8 a1 18 00 00       	call   801037e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f3f:	8b 03                	mov    (%ebx),%eax
80101f41:	83 e0 06             	and    $0x6,%eax
80101f44:	83 c4 10             	add    $0x10,%esp
80101f47:	83 f8 02             	cmp    $0x2,%eax
80101f4a:	75 e5                	jne    80101f31 <iderw+0xa2>
  }


  release(&idelock);
80101f4c:	83 ec 0c             	sub    $0xc,%esp
80101f4f:	68 80 95 10 80       	push   $0x80109580
80101f54:	e8 70 1e 00 00       	call   80103dc9 <release>
}
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f5f:	c9                   	leave  
80101f60:	c3                   	ret    
    idestart(b);
80101f61:	89 d8                	mov    %ebx,%eax
80101f63:	e8 4b fd ff ff       	call   80101cb3 <idestart>
80101f68:	eb bd                	jmp    80101f27 <iderw+0x98>

80101f6a <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101f6a:	55                   	push   %ebp
80101f6b:	89 e5                	mov    %esp,%ebp
80101f6d:	56                   	push   %esi
80101f6e:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f6f:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101f76:	00 c0 fe 
  ioapic->reg = reg;
80101f79:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101f80:	00 00 00 
  return ioapic->data;
80101f83:	a1 34 16 11 80       	mov    0x80111634,%eax
80101f88:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f8b:	c1 eb 10             	shr    $0x10,%ebx
80101f8e:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
80101f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80101f97:	a1 34 16 11 80       	mov    0x80111634,%eax
80101f9c:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80101f9f:	0f b6 15 60 17 11 80 	movzbl 0x80111760,%edx
  id = ioapicread(REG_ID) >> 24;
80101fa6:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fa9:	39 c2                	cmp    %eax,%edx
80101fab:	75 47                	jne    80101ff4 <ioapicinit+0x8a>
{
80101fad:	ba 10 00 00 00       	mov    $0x10,%edx
80101fb2:	b8 00 00 00 00       	mov    $0x0,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fb7:	8d 48 20             	lea    0x20(%eax),%ecx
80101fba:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
80101fc0:	8b 35 34 16 11 80    	mov    0x80111634,%esi
80101fc6:	89 16                	mov    %edx,(%esi)
  ioapic->data = data;
80101fc8:	8b 35 34 16 11 80    	mov    0x80111634,%esi
80101fce:	89 4e 10             	mov    %ecx,0x10(%esi)
80101fd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  ioapic->reg = reg;
80101fd4:	89 0e                	mov    %ecx,(%esi)
  ioapic->data = data;
80101fd6:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101fdc:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80101fe3:	83 c0 01             	add    $0x1,%eax
80101fe6:	83 c2 02             	add    $0x2,%edx
80101fe9:	39 c3                	cmp    %eax,%ebx
80101feb:	7d ca                	jge    80101fb7 <ioapicinit+0x4d>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80101fed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ff0:	5b                   	pop    %ebx
80101ff1:	5e                   	pop    %esi
80101ff2:	5d                   	pop    %ebp
80101ff3:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101ff4:	83 ec 0c             	sub    $0xc,%esp
80101ff7:	68 b4 67 10 80       	push   $0x801067b4
80101ffc:	e8 e0 e5 ff ff       	call   801005e1 <cprintf>
80102001:	83 c4 10             	add    $0x10,%esp
80102004:	eb a7                	jmp    80101fad <ioapicinit+0x43>

80102006 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102006:	55                   	push   %ebp
80102007:	89 e5                	mov    %esp,%ebp
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010200c:	8d 50 20             	lea    0x20(%eax),%edx
8010200f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102013:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102019:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010201b:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102021:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102024:	8b 55 0c             	mov    0xc(%ebp),%edx
80102027:	c1 e2 18             	shl    $0x18,%edx
8010202a:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
8010202d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010202f:	a1 34 16 11 80       	mov    0x80111634,%eax
80102034:	89 50 10             	mov    %edx,0x10(%eax)
}
80102037:	5d                   	pop    %ebp
80102038:	c3                   	ret    

80102039 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102039:	55                   	push   %ebp
8010203a:	89 e5                	mov    %esp,%ebp
8010203c:	53                   	push   %ebx
8010203d:	83 ec 04             	sub    $0x4,%esp
80102040:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102043:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102049:	75 4c                	jne    80102097 <kfree+0x5e>
8010204b:	81 fb a8 47 11 80    	cmp    $0x801147a8,%ebx
80102051:	72 44                	jb     80102097 <kfree+0x5e>
80102053:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102059:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010205e:	77 37                	ja     80102097 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102060:	83 ec 04             	sub    $0x4,%esp
80102063:	68 00 10 00 00       	push   $0x1000
80102068:	6a 01                	push   $0x1
8010206a:	53                   	push   %ebx
8010206b:	e8 a0 1d 00 00       	call   80103e10 <memset>

  if(kmem.use_lock)
80102070:	83 c4 10             	add    $0x10,%esp
80102073:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010207a:	75 28                	jne    801020a4 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010207c:	a1 78 16 11 80       	mov    0x80111678,%eax
80102081:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102083:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102089:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102090:	75 24                	jne    801020b6 <kfree+0x7d>
    release(&kmem.lock);
}
80102092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102095:	c9                   	leave  
80102096:	c3                   	ret    
    panic("kfree");
80102097:	83 ec 0c             	sub    $0xc,%esp
8010209a:	68 e6 67 10 80       	push   $0x801067e6
8010209f:	e8 a0 e2 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 40 16 11 80       	push   $0x80111640
801020ac:	e8 b1 1c 00 00       	call   80103d62 <acquire>
801020b1:	83 c4 10             	add    $0x10,%esp
801020b4:	eb c6                	jmp    8010207c <kfree+0x43>
    release(&kmem.lock);
801020b6:	83 ec 0c             	sub    $0xc,%esp
801020b9:	68 40 16 11 80       	push   $0x80111640
801020be:	e8 06 1d 00 00       	call   80103dc9 <release>
801020c3:	83 c4 10             	add    $0x10,%esp
}
801020c6:	eb ca                	jmp    80102092 <kfree+0x59>

801020c8 <freerange>:
{
801020c8:	55                   	push   %ebp
801020c9:	89 e5                	mov    %esp,%ebp
801020cb:	56                   	push   %esi
801020cc:	53                   	push   %ebx
801020cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801020d0:	8b 45 08             	mov    0x8(%ebp),%eax
801020d3:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801020d9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020e5:	39 de                	cmp    %ebx,%esi
801020e7:	72 1c                	jb     80102105 <freerange+0x3d>
    kfree(p);
801020e9:	83 ec 0c             	sub    $0xc,%esp
801020ec:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801020f2:	50                   	push   %eax
801020f3:	e8 41 ff ff ff       	call   80102039 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020fe:	83 c4 10             	add    $0x10,%esp
80102101:	39 f3                	cmp    %esi,%ebx
80102103:	76 e4                	jbe    801020e9 <freerange+0x21>
}
80102105:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102108:	5b                   	pop    %ebx
80102109:	5e                   	pop    %esi
8010210a:	5d                   	pop    %ebp
8010210b:	c3                   	ret    

8010210c <kinit1>:
{
8010210c:	55                   	push   %ebp
8010210d:	89 e5                	mov    %esp,%ebp
8010210f:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102112:	68 ec 67 10 80       	push   $0x801067ec
80102117:	68 40 16 11 80       	push   $0x80111640
8010211c:	e8 f9 1a 00 00       	call   80103c1a <initlock>
  kmem.use_lock = 0;
80102121:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102128:	00 00 00 
  freerange(vstart, vend);
8010212b:	83 c4 08             	add    $0x8,%esp
8010212e:	ff 75 0c             	pushl  0xc(%ebp)
80102131:	ff 75 08             	pushl  0x8(%ebp)
80102134:	e8 8f ff ff ff       	call   801020c8 <freerange>
}
80102139:	83 c4 10             	add    $0x10,%esp
8010213c:	c9                   	leave  
8010213d:	c3                   	ret    

8010213e <kinit2>:
{
8010213e:	55                   	push   %ebp
8010213f:	89 e5                	mov    %esp,%ebp
80102141:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102144:	ff 75 0c             	pushl  0xc(%ebp)
80102147:	ff 75 08             	pushl  0x8(%ebp)
8010214a:	e8 79 ff ff ff       	call   801020c8 <freerange>
  kmem.use_lock = 1;
8010214f:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
80102156:	00 00 00 
}
80102159:	83 c4 10             	add    $0x10,%esp
8010215c:	c9                   	leave  
8010215d:	c3                   	ret    

8010215e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010215e:	55                   	push   %ebp
8010215f:	89 e5                	mov    %esp,%ebp
80102161:	53                   	push   %ebx
80102162:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102165:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010216c:	75 21                	jne    8010218f <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010216e:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102174:	85 db                	test   %ebx,%ebx
80102176:	74 10                	je     80102188 <kalloc+0x2a>
    kmem.freelist = r->next;
80102178:	8b 03                	mov    (%ebx),%eax
8010217a:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
8010217f:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102186:	75 23                	jne    801021ab <kalloc+0x4d>
    release(&kmem.lock);
  return (char*)r;
}
80102188:	89 d8                	mov    %ebx,%eax
8010218a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010218d:	c9                   	leave  
8010218e:	c3                   	ret    
    acquire(&kmem.lock);
8010218f:	83 ec 0c             	sub    $0xc,%esp
80102192:	68 40 16 11 80       	push   $0x80111640
80102197:	e8 c6 1b 00 00       	call   80103d62 <acquire>
  r = kmem.freelist;
8010219c:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801021a2:	83 c4 10             	add    $0x10,%esp
801021a5:	85 db                	test   %ebx,%ebx
801021a7:	75 cf                	jne    80102178 <kalloc+0x1a>
801021a9:	eb d4                	jmp    8010217f <kalloc+0x21>
    release(&kmem.lock);
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	68 40 16 11 80       	push   $0x80111640
801021b3:	e8 11 1c 00 00       	call   80103dc9 <release>
801021b8:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021bb:	eb cb                	jmp    80102188 <kalloc+0x2a>

801021bd <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021bd:	ba 64 00 00 00       	mov    $0x64,%edx
801021c2:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021c3:	a8 01                	test   $0x1,%al
801021c5:	0f 84 bb 00 00 00    	je     80102286 <kbdgetc+0xc9>
801021cb:	ba 60 00 00 00       	mov    $0x60,%edx
801021d0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021d1:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021d4:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801021da:	74 5b                	je     80102237 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021dc:	84 c0                	test   %al,%al
801021de:	78 64                	js     80102244 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021e0:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
801021e6:	f6 c1 40             	test   $0x40,%cl
801021e9:	74 0f                	je     801021fa <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021eb:	83 c8 80             	or     $0xffffff80,%eax
801021ee:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
801021f1:	83 e1 bf             	and    $0xffffffbf,%ecx
801021f4:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  }

  shift |= shiftcode[data];
801021fa:	0f b6 8a 20 69 10 80 	movzbl -0x7fef96e0(%edx),%ecx
80102201:	0b 0d b4 95 10 80    	or     0x801095b4,%ecx
  shift ^= togglecode[data];
80102207:	0f b6 82 20 68 10 80 	movzbl -0x7fef97e0(%edx),%eax
8010220e:	31 c1                	xor    %eax,%ecx
80102210:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102216:	89 c8                	mov    %ecx,%eax
80102218:	83 e0 03             	and    $0x3,%eax
8010221b:	8b 04 85 00 68 10 80 	mov    -0x7fef9800(,%eax,4),%eax
80102222:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102226:	f6 c1 08             	test   $0x8,%cl
80102229:	74 61                	je     8010228c <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
8010222b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010222e:	83 fa 19             	cmp    $0x19,%edx
80102231:	77 46                	ja     80102279 <kbdgetc+0xbc>
      c += 'A' - 'a';
80102233:	83 e8 20             	sub    $0x20,%eax
80102236:	c3                   	ret    
    shift |= E0ESC;
80102237:	83 0d b4 95 10 80 40 	orl    $0x40,0x801095b4
    return 0;
8010223e:	b8 00 00 00 00       	mov    $0x0,%eax
80102243:	c3                   	ret    
{
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	53                   	push   %ebx
    data = (shift & E0ESC ? data : data & 0x7F);
80102248:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
8010224e:	89 cb                	mov    %ecx,%ebx
80102250:	83 e3 40             	and    $0x40,%ebx
80102253:	83 e0 7f             	and    $0x7f,%eax
80102256:	85 db                	test   %ebx,%ebx
80102258:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010225b:	0f b6 82 20 69 10 80 	movzbl -0x7fef96e0(%edx),%eax
80102262:	83 c8 40             	or     $0x40,%eax
80102265:	0f b6 c0             	movzbl %al,%eax
80102268:	f7 d0                	not    %eax
8010226a:	21 c8                	and    %ecx,%eax
8010226c:	a3 b4 95 10 80       	mov    %eax,0x801095b4
    return 0;
80102271:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102276:	5b                   	pop    %ebx
80102277:	5d                   	pop    %ebp
80102278:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102279:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010227c:	8d 50 20             	lea    0x20(%eax),%edx
8010227f:	83 f9 1a             	cmp    $0x1a,%ecx
80102282:	0f 42 c2             	cmovb  %edx,%eax
  return c;
80102285:	c3                   	ret    
    return -1;
80102286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010228b:	c3                   	ret    
}
8010228c:	f3 c3                	repz ret 

8010228e <kbdintr>:

void
kbdintr(void)
{
8010228e:	55                   	push   %ebp
8010228f:	89 e5                	mov    %esp,%ebp
80102291:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102294:	68 bd 21 10 80       	push   $0x801021bd
80102299:	e8 9d e4 ff ff       	call   8010073b <consoleintr>
}
8010229e:	83 c4 10             	add    $0x10,%esp
801022a1:	c9                   	leave  
801022a2:	c3                   	ret    

801022a3 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801022a3:	55                   	push   %ebp
801022a4:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801022a6:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
801022ac:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022af:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022b1:	a1 7c 16 11 80       	mov    0x8011167c,%eax
801022b6:	8b 40 20             	mov    0x20(%eax),%eax
}
801022b9:	5d                   	pop    %ebp
801022ba:	c3                   	ret    

801022bb <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801022bb:	55                   	push   %ebp
801022bc:	89 e5                	mov    %esp,%ebp
801022be:	56                   	push   %esi
801022bf:	53                   	push   %ebx
801022c0:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c2:	be 70 00 00 00       	mov    $0x70,%esi
801022c7:	b8 00 00 00 00       	mov    $0x0,%eax
801022cc:	89 f2                	mov    %esi,%edx
801022ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022cf:	b9 71 00 00 00       	mov    $0x71,%ecx
801022d4:	89 ca                	mov    %ecx,%edx
801022d6:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801022d7:	0f b6 c0             	movzbl %al,%eax
801022da:	89 03                	mov    %eax,(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022dc:	b8 02 00 00 00       	mov    $0x2,%eax
801022e1:	89 f2                	mov    %esi,%edx
801022e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e4:	89 ca                	mov    %ecx,%edx
801022e6:	ec                   	in     (%dx),%al
801022e7:	0f b6 c0             	movzbl %al,%eax
801022ea:	89 43 04             	mov    %eax,0x4(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ed:	b8 04 00 00 00       	mov    $0x4,%eax
801022f2:	89 f2                	mov    %esi,%edx
801022f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f5:	89 ca                	mov    %ecx,%edx
801022f7:	ec                   	in     (%dx),%al
801022f8:	0f b6 c0             	movzbl %al,%eax
801022fb:	89 43 08             	mov    %eax,0x8(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102303:	89 f2                	mov    %esi,%edx
80102305:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102306:	89 ca                	mov    %ecx,%edx
80102308:	ec                   	in     (%dx),%al
80102309:	0f b6 c0             	movzbl %al,%eax
8010230c:	89 43 0c             	mov    %eax,0xc(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010230f:	b8 08 00 00 00       	mov    $0x8,%eax
80102314:	89 f2                	mov    %esi,%edx
80102316:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102317:	89 ca                	mov    %ecx,%edx
80102319:	ec                   	in     (%dx),%al
8010231a:	0f b6 c0             	movzbl %al,%eax
8010231d:	89 43 10             	mov    %eax,0x10(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102320:	b8 09 00 00 00       	mov    $0x9,%eax
80102325:	89 f2                	mov    %esi,%edx
80102327:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102328:	89 ca                	mov    %ecx,%edx
8010232a:	ec                   	in     (%dx),%al
8010232b:	0f b6 c0             	movzbl %al,%eax
8010232e:	89 43 14             	mov    %eax,0x14(%ebx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102331:	5b                   	pop    %ebx
80102332:	5e                   	pop    %esi
80102333:	5d                   	pop    %ebp
80102334:	c3                   	ret    

80102335 <lapicinit>:
  if(!lapic)
80102335:	83 3d 7c 16 11 80 00 	cmpl   $0x0,0x8011167c
8010233c:	0f 84 fc 00 00 00    	je     8010243e <lapicinit+0x109>
{
80102342:	55                   	push   %ebp
80102343:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102345:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010234a:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010234f:	e8 4f ff ff ff       	call   801022a3 <lapicw>
  lapicw(TDCR, X1);
80102354:	ba 0b 00 00 00       	mov    $0xb,%edx
80102359:	b8 f8 00 00 00       	mov    $0xf8,%eax
8010235e:	e8 40 ff ff ff       	call   801022a3 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102363:	ba 20 00 02 00       	mov    $0x20020,%edx
80102368:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010236d:	e8 31 ff ff ff       	call   801022a3 <lapicw>
  lapicw(TICR, 10000000);
80102372:	ba 80 96 98 00       	mov    $0x989680,%edx
80102377:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010237c:	e8 22 ff ff ff       	call   801022a3 <lapicw>
  lapicw(LINT0, MASKED);
80102381:	ba 00 00 01 00       	mov    $0x10000,%edx
80102386:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010238b:	e8 13 ff ff ff       	call   801022a3 <lapicw>
  lapicw(LINT1, MASKED);
80102390:	ba 00 00 01 00       	mov    $0x10000,%edx
80102395:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010239a:	e8 04 ff ff ff       	call   801022a3 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010239f:	a1 7c 16 11 80       	mov    0x8011167c,%eax
801023a4:	8b 40 30             	mov    0x30(%eax),%eax
801023a7:	c1 e8 10             	shr    $0x10,%eax
801023aa:	3c 03                	cmp    $0x3,%al
801023ac:	77 7c                	ja     8010242a <lapicinit+0xf5>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023ae:	ba 33 00 00 00       	mov    $0x33,%edx
801023b3:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023b8:	e8 e6 fe ff ff       	call   801022a3 <lapicw>
  lapicw(ESR, 0);
801023bd:	ba 00 00 00 00       	mov    $0x0,%edx
801023c2:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023c7:	e8 d7 fe ff ff       	call   801022a3 <lapicw>
  lapicw(ESR, 0);
801023cc:	ba 00 00 00 00       	mov    $0x0,%edx
801023d1:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023d6:	e8 c8 fe ff ff       	call   801022a3 <lapicw>
  lapicw(EOI, 0);
801023db:	ba 00 00 00 00       	mov    $0x0,%edx
801023e0:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023e5:	e8 b9 fe ff ff       	call   801022a3 <lapicw>
  lapicw(ICRHI, 0);
801023ea:	ba 00 00 00 00       	mov    $0x0,%edx
801023ef:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023f4:	e8 aa fe ff ff       	call   801022a3 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801023f9:	ba 00 85 08 00       	mov    $0x88500,%edx
801023fe:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102403:	e8 9b fe ff ff       	call   801022a3 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102408:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010240e:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
80102414:	f6 c4 10             	test   $0x10,%ah
80102417:	75 f5                	jne    8010240e <lapicinit+0xd9>
  lapicw(TPR, 0);
80102419:	ba 00 00 00 00       	mov    $0x0,%edx
8010241e:	b8 20 00 00 00       	mov    $0x20,%eax
80102423:	e8 7b fe ff ff       	call   801022a3 <lapicw>
}
80102428:	5d                   	pop    %ebp
80102429:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010242a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010242f:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102434:	e8 6a fe ff ff       	call   801022a3 <lapicw>
80102439:	e9 70 ff ff ff       	jmp    801023ae <lapicinit+0x79>
8010243e:	f3 c3                	repz ret 

80102440 <lapicid>:
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102443:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
    return 0;
80102449:	b8 00 00 00 00       	mov    $0x0,%eax
  if (!lapic)
8010244e:	85 d2                	test   %edx,%edx
80102450:	74 06                	je     80102458 <lapicid+0x18>
  return lapic[ID] >> 24;
80102452:	8b 42 20             	mov    0x20(%edx),%eax
80102455:	c1 e8 18             	shr    $0x18,%eax
}
80102458:	5d                   	pop    %ebp
80102459:	c3                   	ret    

8010245a <lapiceoi>:
  if(lapic)
8010245a:	83 3d 7c 16 11 80 00 	cmpl   $0x0,0x8011167c
80102461:	74 14                	je     80102477 <lapiceoi+0x1d>
{
80102463:	55                   	push   %ebp
80102464:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
80102466:	ba 00 00 00 00       	mov    $0x0,%edx
8010246b:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102470:	e8 2e fe ff ff       	call   801022a3 <lapicw>
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	f3 c3                	repz ret 

80102479 <microdelay>:
{
80102479:	55                   	push   %ebp
8010247a:	89 e5                	mov    %esp,%ebp
}
8010247c:	5d                   	pop    %ebp
8010247d:	c3                   	ret    

8010247e <lapicstartap>:
{
8010247e:	55                   	push   %ebp
8010247f:	89 e5                	mov    %esp,%ebp
80102481:	56                   	push   %esi
80102482:	53                   	push   %ebx
80102483:	8b 75 08             	mov    0x8(%ebp),%esi
80102486:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102489:	b8 0f 00 00 00       	mov    $0xf,%eax
8010248e:	ba 70 00 00 00       	mov    $0x70,%edx
80102493:	ee                   	out    %al,(%dx)
80102494:	b8 0a 00 00 00       	mov    $0xa,%eax
80102499:	ba 71 00 00 00       	mov    $0x71,%edx
8010249e:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010249f:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024a6:	00 00 
  wrv[1] = addr >> 4;
801024a8:	89 d8                	mov    %ebx,%eax
801024aa:	c1 e8 04             	shr    $0x4,%eax
801024ad:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024b3:	c1 e6 18             	shl    $0x18,%esi
801024b6:	89 f2                	mov    %esi,%edx
801024b8:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024bd:	e8 e1 fd ff ff       	call   801022a3 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024c2:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024c7:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024cc:	e8 d2 fd ff ff       	call   801022a3 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024d1:	ba 00 85 00 00       	mov    $0x8500,%edx
801024d6:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024db:	e8 c3 fd ff ff       	call   801022a3 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024e0:	c1 eb 0c             	shr    $0xc,%ebx
801024e3:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
801024e6:	89 f2                	mov    %esi,%edx
801024e8:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024ed:	e8 b1 fd ff ff       	call   801022a3 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024f2:	89 da                	mov    %ebx,%edx
801024f4:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024f9:	e8 a5 fd ff ff       	call   801022a3 <lapicw>
    lapicw(ICRHI, apicid<<24);
801024fe:	89 f2                	mov    %esi,%edx
80102500:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102505:	e8 99 fd ff ff       	call   801022a3 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010250a:	89 da                	mov    %ebx,%edx
8010250c:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102511:	e8 8d fd ff ff       	call   801022a3 <lapicw>
}
80102516:	5b                   	pop    %ebx
80102517:	5e                   	pop    %esi
80102518:	5d                   	pop    %ebp
80102519:	c3                   	ret    

8010251a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010251a:	55                   	push   %ebp
8010251b:	89 e5                	mov    %esp,%ebp
8010251d:	57                   	push   %edi
8010251e:	56                   	push   %esi
8010251f:	53                   	push   %ebx
80102520:	83 ec 4c             	sub    $0x4c,%esp
80102523:	8b 7d 08             	mov    0x8(%ebp),%edi
80102526:	b8 0b 00 00 00       	mov    $0xb,%eax
8010252b:	ba 70 00 00 00       	mov    $0x70,%edx
80102530:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102531:	ba 71 00 00 00       	mov    $0x71,%edx
80102536:	ec                   	in     (%dx),%al
80102537:	83 e0 04             	and    $0x4,%eax
8010253a:	88 45 b7             	mov    %al,-0x49(%ebp)

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010253d:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102540:	89 f0                	mov    %esi,%eax
80102542:	e8 74 fd ff ff       	call   801022bb <fill_rtcdate>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102547:	ba 70 00 00 00       	mov    $0x70,%edx
8010254c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102551:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102552:	ba 71 00 00 00       	mov    $0x71,%edx
80102557:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102558:	84 c0                	test   %al,%al
8010255a:	78 e4                	js     80102540 <cmostime+0x26>
        continue;
    fill_rtcdate(&t2);
8010255c:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010255f:	89 d8                	mov    %ebx,%eax
80102561:	e8 55 fd ff ff       	call   801022bb <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102566:	83 ec 04             	sub    $0x4,%esp
80102569:	6a 18                	push   $0x18
8010256b:	53                   	push   %ebx
8010256c:	56                   	push   %esi
8010256d:	e8 e2 18 00 00       	call   80103e54 <memcmp>
80102572:	83 c4 10             	add    $0x10,%esp
80102575:	85 c0                	test   %eax,%eax
80102577:	75 c7                	jne    80102540 <cmostime+0x26>
      break;
  }

  // convert
  if(bcd) {
80102579:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
8010257d:	75 78                	jne    801025f7 <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010257f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102582:	89 c2                	mov    %eax,%edx
80102584:	c1 ea 04             	shr    $0x4,%edx
80102587:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010258a:	83 e0 0f             	and    $0xf,%eax
8010258d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102590:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102593:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102596:	89 c2                	mov    %eax,%edx
80102598:	c1 ea 04             	shr    $0x4,%edx
8010259b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259e:	83 e0 0f             	and    $0xf,%eax
801025a1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025aa:	89 c2                	mov    %eax,%edx
801025ac:	c1 ea 04             	shr    $0x4,%edx
801025af:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b2:	83 e0 0f             	and    $0xf,%eax
801025b5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025be:	89 c2                	mov    %eax,%edx
801025c0:	c1 ea 04             	shr    $0x4,%edx
801025c3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c6:	83 e0 0f             	and    $0xf,%eax
801025c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025d2:	89 c2                	mov    %eax,%edx
801025d4:	c1 ea 04             	shr    $0x4,%edx
801025d7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025da:	83 e0 0f             	and    $0xf,%eax
801025dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025e6:	89 c2                	mov    %eax,%edx
801025e8:	c1 ea 04             	shr    $0x4,%edx
801025eb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ee:	83 e0 0f             	and    $0xf,%eax
801025f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025fa:	89 07                	mov    %eax,(%edi)
801025fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025ff:	89 47 04             	mov    %eax,0x4(%edi)
80102602:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102605:	89 47 08             	mov    %eax,0x8(%edi)
80102608:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010260b:	89 47 0c             	mov    %eax,0xc(%edi)
8010260e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102611:	89 47 10             	mov    %eax,0x10(%edi)
80102614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102617:	89 47 14             	mov    %eax,0x14(%edi)
  r->year += 2000;
8010261a:	81 47 14 d0 07 00 00 	addl   $0x7d0,0x14(%edi)
}
80102621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102624:	5b                   	pop    %ebx
80102625:	5e                   	pop    %esi
80102626:	5f                   	pop    %edi
80102627:	5d                   	pop    %ebp
80102628:	c3                   	ret    

80102629 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102629:	83 3d c8 16 11 80 00 	cmpl   $0x0,0x801116c8
80102630:	0f 8e 84 00 00 00    	jle    801026ba <install_trans+0x91>
{
80102636:	55                   	push   %ebp
80102637:	89 e5                	mov    %esp,%ebp
80102639:	57                   	push   %edi
8010263a:	56                   	push   %esi
8010263b:	53                   	push   %ebx
8010263c:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010263f:	bb 00 00 00 00       	mov    $0x0,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102644:	be 80 16 11 80       	mov    $0x80111680,%esi
80102649:	83 ec 08             	sub    $0x8,%esp
8010264c:	89 d8                	mov    %ebx,%eax
8010264e:	03 46 34             	add    0x34(%esi),%eax
80102651:	83 c0 01             	add    $0x1,%eax
80102654:	50                   	push   %eax
80102655:	ff 76 44             	pushl  0x44(%esi)
80102658:	e8 4d da ff ff       	call   801000aa <bread>
8010265d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102660:	83 c4 08             	add    $0x8,%esp
80102663:	ff 34 9d cc 16 11 80 	pushl  -0x7feee934(,%ebx,4)
8010266a:	ff 76 44             	pushl  0x44(%esi)
8010266d:	e8 38 da ff ff       	call   801000aa <bread>
80102672:	89 c7                	mov    %eax,%edi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102674:	83 c4 0c             	add    $0xc,%esp
80102677:	68 00 02 00 00       	push   $0x200
8010267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010267f:	83 c0 5c             	add    $0x5c,%eax
80102682:	50                   	push   %eax
80102683:	8d 47 5c             	lea    0x5c(%edi),%eax
80102686:	50                   	push   %eax
80102687:	e8 19 18 00 00       	call   80103ea5 <memmove>
    bwrite(dbuf);  // write dst to disk
8010268c:	89 3c 24             	mov    %edi,(%esp)
8010268f:	e8 f2 da ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
80102694:	83 c4 04             	add    $0x4,%esp
80102697:	ff 75 e4             	pushl  -0x1c(%ebp)
8010269a:	e8 22 db ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
8010269f:	89 3c 24             	mov    %edi,(%esp)
801026a2:	e8 1a db ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026a7:	83 c3 01             	add    $0x1,%ebx
801026aa:	83 c4 10             	add    $0x10,%esp
801026ad:	39 5e 48             	cmp    %ebx,0x48(%esi)
801026b0:	7f 97                	jg     80102649 <install_trans+0x20>
  }
}
801026b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026b5:	5b                   	pop    %ebx
801026b6:	5e                   	pop    %esi
801026b7:	5f                   	pop    %edi
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	f3 c3                	repz ret 

801026bc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026bc:	55                   	push   %ebp
801026bd:	89 e5                	mov    %esp,%ebp
801026bf:	53                   	push   %ebx
801026c0:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026c3:	ff 35 b4 16 11 80    	pushl  0x801116b4
801026c9:	ff 35 c4 16 11 80    	pushl  0x801116c4
801026cf:	e8 d6 d9 ff ff       	call   801000aa <bread>
801026d4:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026d6:	8b 0d c8 16 11 80    	mov    0x801116c8,%ecx
801026dc:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026df:	83 c4 10             	add    $0x10,%esp
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	7e 19                	jle    801026ff <write_head+0x43>
801026e6:	c1 e1 02             	shl    $0x2,%ecx
801026e9:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
801026ee:	8b 90 cc 16 11 80    	mov    -0x7feee934(%eax),%edx
801026f4:	89 54 03 60          	mov    %edx,0x60(%ebx,%eax,1)
801026f8:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < log.lh.n; i++) {
801026fb:	39 c8                	cmp    %ecx,%eax
801026fd:	75 ef                	jne    801026ee <write_head+0x32>
  }
  bwrite(buf);
801026ff:	83 ec 0c             	sub    $0xc,%esp
80102702:	53                   	push   %ebx
80102703:	e8 7e da ff ff       	call   80100186 <bwrite>
  brelse(buf);
80102708:	89 1c 24             	mov    %ebx,(%esp)
8010270b:	e8 b1 da ff ff       	call   801001c1 <brelse>
}
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102716:	c9                   	leave  
80102717:	c3                   	ret    

80102718 <initlog>:
{
80102718:	55                   	push   %ebp
80102719:	89 e5                	mov    %esp,%ebp
8010271b:	53                   	push   %ebx
8010271c:	83 ec 2c             	sub    $0x2c,%esp
8010271f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102722:	68 20 6a 10 80       	push   $0x80106a20
80102727:	68 80 16 11 80       	push   $0x80111680
8010272c:	e8 e9 14 00 00       	call   80103c1a <initlock>
  readsb(dev, &sb);
80102731:	83 c4 08             	add    $0x8,%esp
80102734:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102737:	50                   	push   %eax
80102738:	53                   	push   %ebx
80102739:	e8 94 eb ff ff       	call   801012d2 <readsb>
  log.start = sb.logstart;
8010273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102741:	a3 b4 16 11 80       	mov    %eax,0x801116b4
  log.size = sb.nlog;
80102746:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102749:	89 15 b8 16 11 80    	mov    %edx,0x801116b8
  log.dev = dev;
8010274f:	89 1d c4 16 11 80    	mov    %ebx,0x801116c4
  struct buf *buf = bread(log.dev, log.start);
80102755:	83 c4 08             	add    $0x8,%esp
80102758:	50                   	push   %eax
80102759:	53                   	push   %ebx
8010275a:	e8 4b d9 ff ff       	call   801000aa <bread>
  log.lh.n = lh->n;
8010275f:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102762:	89 1d c8 16 11 80    	mov    %ebx,0x801116c8
  for (i = 0; i < log.lh.n; i++) {
80102768:	83 c4 10             	add    $0x10,%esp
8010276b:	85 db                	test   %ebx,%ebx
8010276d:	7e 19                	jle    80102788 <initlog+0x70>
8010276f:	c1 e3 02             	shl    $0x2,%ebx
80102772:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
80102777:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
8010277b:	89 8a cc 16 11 80    	mov    %ecx,-0x7feee934(%edx)
80102781:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102784:	39 d3                	cmp    %edx,%ebx
80102786:	75 ef                	jne    80102777 <initlog+0x5f>
  brelse(buf);
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	50                   	push   %eax
8010278c:	e8 30 da ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102791:	e8 93 fe ff ff       	call   80102629 <install_trans>
  log.lh.n = 0;
80102796:	c7 05 c8 16 11 80 00 	movl   $0x0,0x801116c8
8010279d:	00 00 00 
  write_head(); // clear the log
801027a0:	e8 17 ff ff ff       	call   801026bc <write_head>
}
801027a5:	83 c4 10             	add    $0x10,%esp
801027a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ab:	c9                   	leave  
801027ac:	c3                   	ret    

801027ad <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801027ad:	55                   	push   %ebp
801027ae:	89 e5                	mov    %esp,%ebp
801027b0:	53                   	push   %ebx
801027b1:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027b4:	68 80 16 11 80       	push   $0x80111680
801027b9:	e8 a4 15 00 00       	call   80103d62 <acquire>
801027be:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801027c1:	bb 80 16 11 80       	mov    $0x80111680,%ebx
801027c6:	eb 15                	jmp    801027dd <begin_op+0x30>
      sleep(&log, &log.lock);
801027c8:	83 ec 08             	sub    $0x8,%esp
801027cb:	68 80 16 11 80       	push   $0x80111680
801027d0:	68 80 16 11 80       	push   $0x80111680
801027d5:	e8 06 10 00 00       	call   801037e0 <sleep>
801027da:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027dd:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
801027e1:	75 e5                	jne    801027c8 <begin_op+0x1b>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027e3:	8b 43 3c             	mov    0x3c(%ebx),%eax
801027e6:	83 c0 01             	add    $0x1,%eax
801027e9:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027ec:	8b 53 48             	mov    0x48(%ebx),%edx
801027ef:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801027f2:	83 fa 1e             	cmp    $0x1e,%edx
801027f5:	7e 17                	jle    8010280e <begin_op+0x61>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801027f7:	83 ec 08             	sub    $0x8,%esp
801027fa:	68 80 16 11 80       	push   $0x80111680
801027ff:	68 80 16 11 80       	push   $0x80111680
80102804:	e8 d7 0f 00 00       	call   801037e0 <sleep>
80102809:	83 c4 10             	add    $0x10,%esp
8010280c:	eb cf                	jmp    801027dd <begin_op+0x30>
    } else {
      log.outstanding += 1;
8010280e:	a3 bc 16 11 80       	mov    %eax,0x801116bc
      release(&log.lock);
80102813:	83 ec 0c             	sub    $0xc,%esp
80102816:	68 80 16 11 80       	push   $0x80111680
8010281b:	e8 a9 15 00 00       	call   80103dc9 <release>
      break;
    }
  }
}
80102820:	83 c4 10             	add    $0x10,%esp
80102823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102826:	c9                   	leave  
80102827:	c3                   	ret    

80102828 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102828:	55                   	push   %ebp
80102829:	89 e5                	mov    %esp,%ebp
8010282b:	57                   	push   %edi
8010282c:	56                   	push   %esi
8010282d:	53                   	push   %ebx
8010282e:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102831:	68 80 16 11 80       	push   $0x80111680
80102836:	e8 27 15 00 00       	call   80103d62 <acquire>
  log.outstanding -= 1;
8010283b:	a1 bc 16 11 80       	mov    0x801116bc,%eax
80102840:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102843:	89 1d bc 16 11 80    	mov    %ebx,0x801116bc
  if(log.committing)
80102849:	83 c4 10             	add    $0x10,%esp
8010284c:	83 3d c0 16 11 80 00 	cmpl   $0x0,0x801116c0
80102853:	0f 85 e9 00 00 00    	jne    80102942 <end_op+0x11a>
    panic("log.committing");
  if(log.outstanding == 0){
80102859:	85 db                	test   %ebx,%ebx
8010285b:	0f 85 ee 00 00 00    	jne    8010294f <end_op+0x127>
    do_commit = 1;
    log.committing = 1;
80102861:	c7 05 c0 16 11 80 01 	movl   $0x1,0x801116c0
80102868:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010286b:	83 ec 0c             	sub    $0xc,%esp
8010286e:	68 80 16 11 80       	push   $0x80111680
80102873:	e8 51 15 00 00       	call   80103dc9 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102878:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010287b:	be 80 16 11 80       	mov    $0x80111680,%esi
  if (log.lh.n > 0) {
80102880:	83 3d c8 16 11 80 00 	cmpl   $0x0,0x801116c8
80102887:	7e 7f                	jle    80102908 <end_op+0xe0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102889:	83 ec 08             	sub    $0x8,%esp
8010288c:	89 d8                	mov    %ebx,%eax
8010288e:	03 46 34             	add    0x34(%esi),%eax
80102891:	83 c0 01             	add    $0x1,%eax
80102894:	50                   	push   %eax
80102895:	ff 76 44             	pushl  0x44(%esi)
80102898:	e8 0d d8 ff ff       	call   801000aa <bread>
8010289d:	89 c7                	mov    %eax,%edi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010289f:	83 c4 08             	add    $0x8,%esp
801028a2:	ff 34 9d cc 16 11 80 	pushl  -0x7feee934(,%ebx,4)
801028a9:	ff 76 44             	pushl  0x44(%esi)
801028ac:	e8 f9 d7 ff ff       	call   801000aa <bread>
    memmove(to->data, from->data, BSIZE);
801028b1:	83 c4 0c             	add    $0xc,%esp
801028b4:	68 00 02 00 00       	push   $0x200
801028b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801028bc:	83 c0 5c             	add    $0x5c,%eax
801028bf:	50                   	push   %eax
801028c0:	8d 47 5c             	lea    0x5c(%edi),%eax
801028c3:	50                   	push   %eax
801028c4:	e8 dc 15 00 00       	call   80103ea5 <memmove>
    bwrite(to);  // write the log
801028c9:	89 3c 24             	mov    %edi,(%esp)
801028cc:	e8 b5 d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
801028d1:	83 c4 04             	add    $0x4,%esp
801028d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801028d7:	e8 e5 d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
801028dc:	89 3c 24             	mov    %edi,(%esp)
801028df:	e8 dd d8 ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801028e4:	83 c3 01             	add    $0x1,%ebx
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	3b 5e 48             	cmp    0x48(%esi),%ebx
801028ed:	7c 9a                	jl     80102889 <end_op+0x61>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801028ef:	e8 c8 fd ff ff       	call   801026bc <write_head>
    install_trans(); // Now install writes to home locations
801028f4:	e8 30 fd ff ff       	call   80102629 <install_trans>
    log.lh.n = 0;
801028f9:	c7 05 c8 16 11 80 00 	movl   $0x0,0x801116c8
80102900:	00 00 00 
    write_head();    // Erase the transaction from the log
80102903:	e8 b4 fd ff ff       	call   801026bc <write_head>
    acquire(&log.lock);
80102908:	83 ec 0c             	sub    $0xc,%esp
8010290b:	68 80 16 11 80       	push   $0x80111680
80102910:	e8 4d 14 00 00       	call   80103d62 <acquire>
    log.committing = 0;
80102915:	c7 05 c0 16 11 80 00 	movl   $0x0,0x801116c0
8010291c:	00 00 00 
    wakeup(&log);
8010291f:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
80102926:	e8 35 10 00 00       	call   80103960 <wakeup>
    release(&log.lock);
8010292b:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
80102932:	e8 92 14 00 00       	call   80103dc9 <release>
80102937:	83 c4 10             	add    $0x10,%esp
}
8010293a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010293d:	5b                   	pop    %ebx
8010293e:	5e                   	pop    %esi
8010293f:	5f                   	pop    %edi
80102940:	5d                   	pop    %ebp
80102941:	c3                   	ret    
    panic("log.committing");
80102942:	83 ec 0c             	sub    $0xc,%esp
80102945:	68 24 6a 10 80       	push   $0x80106a24
8010294a:	e8 f5 d9 ff ff       	call   80100344 <panic>
    wakeup(&log);
8010294f:	83 ec 0c             	sub    $0xc,%esp
80102952:	68 80 16 11 80       	push   $0x80111680
80102957:	e8 04 10 00 00       	call   80103960 <wakeup>
  release(&log.lock);
8010295c:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
80102963:	e8 61 14 00 00       	call   80103dc9 <release>
80102968:	83 c4 10             	add    $0x10,%esp
8010296b:	eb cd                	jmp    8010293a <end_op+0x112>

8010296d <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010296d:	55                   	push   %ebp
8010296e:	89 e5                	mov    %esp,%ebp
80102970:	53                   	push   %ebx
80102971:	83 ec 04             	sub    $0x4,%esp
80102974:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102977:	8b 15 c8 16 11 80    	mov    0x801116c8,%edx
8010297d:	83 fa 1d             	cmp    $0x1d,%edx
80102980:	7f 6b                	jg     801029ed <log_write+0x80>
80102982:	a1 b8 16 11 80       	mov    0x801116b8,%eax
80102987:	83 e8 01             	sub    $0x1,%eax
8010298a:	39 c2                	cmp    %eax,%edx
8010298c:	7d 5f                	jge    801029ed <log_write+0x80>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010298e:	83 3d bc 16 11 80 00 	cmpl   $0x0,0x801116bc
80102995:	7e 63                	jle    801029fa <log_write+0x8d>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102997:	83 ec 0c             	sub    $0xc,%esp
8010299a:	68 80 16 11 80       	push   $0x80111680
8010299f:	e8 be 13 00 00       	call   80103d62 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029a4:	8b 15 c8 16 11 80    	mov    0x801116c8,%edx
801029aa:	83 c4 10             	add    $0x10,%esp
801029ad:	85 d2                	test   %edx,%edx
801029af:	7e 56                	jle    80102a07 <log_write+0x9a>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029b1:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029b4:	39 0d cc 16 11 80    	cmp    %ecx,0x801116cc
801029ba:	74 5b                	je     80102a17 <log_write+0xaa>
  for (i = 0; i < log.lh.n; i++) {
801029bc:	b8 00 00 00 00       	mov    $0x0,%eax
801029c1:	83 c0 01             	add    $0x1,%eax
801029c4:	39 d0                	cmp    %edx,%eax
801029c6:	74 56                	je     80102a1e <log_write+0xb1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029c8:	39 0c 85 cc 16 11 80 	cmp    %ecx,-0x7feee934(,%eax,4)
801029cf:	75 f0                	jne    801029c1 <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
801029d1:	89 0c 85 cc 16 11 80 	mov    %ecx,-0x7feee934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801029d8:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801029db:	83 ec 0c             	sub    $0xc,%esp
801029de:	68 80 16 11 80       	push   $0x80111680
801029e3:	e8 e1 13 00 00       	call   80103dc9 <release>
}
801029e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029eb:	c9                   	leave  
801029ec:	c3                   	ret    
    panic("too big a transaction");
801029ed:	83 ec 0c             	sub    $0xc,%esp
801029f0:	68 33 6a 10 80       	push   $0x80106a33
801029f5:	e8 4a d9 ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
801029fa:	83 ec 0c             	sub    $0xc,%esp
801029fd:	68 49 6a 10 80       	push   $0x80106a49
80102a02:	e8 3d d9 ff ff       	call   80100344 <panic>
  log.lh.block[i] = b->blockno;
80102a07:	8b 43 08             	mov    0x8(%ebx),%eax
80102a0a:	a3 cc 16 11 80       	mov    %eax,0x801116cc
  if (i == log.lh.n)
80102a0f:	85 d2                	test   %edx,%edx
80102a11:	75 c5                	jne    801029d8 <log_write+0x6b>
  for (i = 0; i < log.lh.n; i++) {
80102a13:	89 d0                	mov    %edx,%eax
80102a15:	eb 11                	jmp    80102a28 <log_write+0xbb>
80102a17:	b8 00 00 00 00       	mov    $0x0,%eax
80102a1c:	eb b3                	jmp    801029d1 <log_write+0x64>
  log.lh.block[i] = b->blockno;
80102a1e:	8b 53 08             	mov    0x8(%ebx),%edx
80102a21:	89 14 85 cc 16 11 80 	mov    %edx,-0x7feee934(,%eax,4)
    log.lh.n++;
80102a28:	83 c0 01             	add    $0x1,%eax
80102a2b:	a3 c8 16 11 80       	mov    %eax,0x801116c8
80102a30:	eb a6                	jmp    801029d8 <log_write+0x6b>

80102a32 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102a32:	55                   	push   %ebp
80102a33:	89 e5                	mov    %esp,%ebp
80102a35:	53                   	push   %ebx
80102a36:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a39:	e8 db 08 00 00       	call   80103319 <cpuid>
80102a3e:	89 c3                	mov    %eax,%ebx
80102a40:	e8 d4 08 00 00       	call   80103319 <cpuid>
80102a45:	83 ec 04             	sub    $0x4,%esp
80102a48:	53                   	push   %ebx
80102a49:	50                   	push   %eax
80102a4a:	68 64 6a 10 80       	push   $0x80106a64
80102a4f:	e8 8d db ff ff       	call   801005e1 <cprintf>
  idtinit();       // load idt register
80102a54:	e8 f2 24 00 00       	call   80104f4b <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a59:	e8 44 08 00 00       	call   801032a2 <mycpu>
80102a5e:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a60:	b8 01 00 00 00       	mov    $0x1,%eax
80102a65:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a6c:	e8 42 0b 00 00       	call   801035b3 <scheduler>

80102a71 <mpenter>:
{
80102a71:	55                   	push   %ebp
80102a72:	89 e5                	mov    %esp,%ebp
80102a74:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a77:	e8 8f 34 00 00       	call   80105f0b <switchkvm>
  seginit();
80102a7c:	e8 a3 33 00 00       	call   80105e24 <seginit>
  lapicinit();
80102a81:	e8 af f8 ff ff       	call   80102335 <lapicinit>
  mpmain();
80102a86:	e8 a7 ff ff ff       	call   80102a32 <mpmain>

80102a8b <main>:
{
80102a8b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a8f:	83 e4 f0             	and    $0xfffffff0,%esp
80102a92:	ff 71 fc             	pushl  -0x4(%ecx)
80102a95:	55                   	push   %ebp
80102a96:	89 e5                	mov    %esp,%ebp
80102a98:	53                   	push   %ebx
80102a99:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a9a:	83 ec 08             	sub    $0x8,%esp
80102a9d:	68 00 00 40 80       	push   $0x80400000
80102aa2:	68 a8 47 11 80       	push   $0x801147a8
80102aa7:	e8 60 f6 ff ff       	call   8010210c <kinit1>
  kvmalloc();      // kernel page table
80102aac:	e8 df 38 00 00       	call   80106390 <kvmalloc>
  mpinit();        // detect other processors
80102ab1:	e8 50 01 00 00       	call   80102c06 <mpinit>
  lapicinit();     // interrupt controller
80102ab6:	e8 7a f8 ff ff       	call   80102335 <lapicinit>
  seginit();       // segment descriptors
80102abb:	e8 64 33 00 00       	call   80105e24 <seginit>
  picinit();       // disable pic
80102ac0:	e8 01 03 00 00       	call   80102dc6 <picinit>
  ioapicinit();    // another interrupt controller
80102ac5:	e8 a0 f4 ff ff       	call   80101f6a <ioapicinit>
  consoleinit();   // console hardware
80102aca:	e8 ff dd ff ff       	call   801008ce <consoleinit>
  uartinit();      // serial port
80102acf:	e8 37 27 00 00       	call   8010520b <uartinit>
  pinit();         // process table
80102ad4:	e8 af 07 00 00       	call   80103288 <pinit>
  tvinit();        // trap vectors
80102ad9:	e8 e2 23 00 00       	call   80104ec0 <tvinit>
  binit();         // buffer cache
80102ade:	e8 51 d5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102ae3:	e8 78 e1 ff ff       	call   80100c60 <fileinit>
  ideinit();       // disk 
80102ae8:	e8 8e f2 ff ff       	call   80101d7b <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102aed:	83 c4 0c             	add    $0xc,%esp
80102af0:	68 8a 00 00 00       	push   $0x8a
80102af5:	68 8c 94 10 80       	push   $0x8010948c
80102afa:	68 00 70 00 80       	push   $0x80007000
80102aff:	e8 a1 13 00 00       	call   80103ea5 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b04:	69 05 00 1d 11 80 b0 	imul   $0xb0,0x80111d00,%eax
80102b0b:	00 00 00 
80102b0e:	05 80 17 11 80       	add    $0x80111780,%eax
80102b13:	83 c4 10             	add    $0x10,%esp
80102b16:	3d 80 17 11 80       	cmp    $0x80111780,%eax
80102b1b:	76 6c                	jbe    80102b89 <main+0xfe>
80102b1d:	bb 80 17 11 80       	mov    $0x80111780,%ebx
80102b22:	eb 19                	jmp    80102b3d <main+0xb2>
80102b24:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b2a:	69 05 00 1d 11 80 b0 	imul   $0xb0,0x80111d00,%eax
80102b31:	00 00 00 
80102b34:	05 80 17 11 80       	add    $0x80111780,%eax
80102b39:	39 c3                	cmp    %eax,%ebx
80102b3b:	73 4c                	jae    80102b89 <main+0xfe>
    if(c == mycpu())  // We've started already.
80102b3d:	e8 60 07 00 00       	call   801032a2 <mycpu>
80102b42:	39 d8                	cmp    %ebx,%eax
80102b44:	74 de                	je     80102b24 <main+0x99>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102b46:	e8 13 f6 ff ff       	call   8010215e <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102b4b:	05 00 10 00 00       	add    $0x1000,%eax
80102b50:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102b55:	c7 05 f8 6f 00 80 71 	movl   $0x80102a71,0x80006ff8
80102b5c:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102b5f:	c7 05 f4 6f 00 80 00 	movl   $0x108000,0x80006ff4
80102b66:	80 10 00 

    lapicstartap(c->apicid, V2P(code));
80102b69:	83 ec 08             	sub    $0x8,%esp
80102b6c:	68 00 70 00 00       	push   $0x7000
80102b71:	0f b6 03             	movzbl (%ebx),%eax
80102b74:	50                   	push   %eax
80102b75:	e8 04 f9 ff ff       	call   8010247e <lapicstartap>
80102b7a:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102b7d:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b83:	85 c0                	test   %eax,%eax
80102b85:	74 f6                	je     80102b7d <main+0xf2>
80102b87:	eb 9b                	jmp    80102b24 <main+0x99>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b89:	83 ec 08             	sub    $0x8,%esp
80102b8c:	68 00 00 00 8e       	push   $0x8e000000
80102b91:	68 00 00 40 80       	push   $0x80400000
80102b96:	e8 a3 f5 ff ff       	call   8010213e <kinit2>
  userinit();      // first user process
80102b9b:	e8 b8 07 00 00       	call   80103358 <userinit>
  mpmain();        // finish this processor's setup
80102ba0:	e8 8d fe ff ff       	call   80102a32 <mpmain>

80102ba5 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ba5:	55                   	push   %ebp
80102ba6:	89 e5                	mov    %esp,%ebp
80102ba8:	57                   	push   %edi
80102ba9:	56                   	push   %esi
80102baa:	53                   	push   %ebx
80102bab:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102bb4:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bb7:	39 f3                	cmp    %esi,%ebx
80102bb9:	72 12                	jb     80102bcd <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102bbb:	bb 00 00 00 00       	mov    $0x0,%ebx
80102bc0:	eb 3a                	jmp    80102bfc <mpsearch1+0x57>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bc2:	84 c0                	test   %al,%al
80102bc4:	74 36                	je     80102bfc <mpsearch1+0x57>
  for(p = addr; p < e; p += sizeof(struct mp))
80102bc6:	83 c3 10             	add    $0x10,%ebx
80102bc9:	39 de                	cmp    %ebx,%esi
80102bcb:	76 2a                	jbe    80102bf7 <mpsearch1+0x52>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bcd:	83 ec 04             	sub    $0x4,%esp
80102bd0:	6a 04                	push   $0x4
80102bd2:	68 78 6a 10 80       	push   $0x80106a78
80102bd7:	53                   	push   %ebx
80102bd8:	e8 77 12 00 00       	call   80103e54 <memcmp>
80102bdd:	83 c4 10             	add    $0x10,%esp
80102be0:	85 c0                	test   %eax,%eax
80102be2:	75 e2                	jne    80102bc6 <mpsearch1+0x21>
80102be4:	89 d9                	mov    %ebx,%ecx
80102be6:	8d 7b 10             	lea    0x10(%ebx),%edi
    sum += addr[i];
80102be9:	0f b6 11             	movzbl (%ecx),%edx
80102bec:	01 d0                	add    %edx,%eax
80102bee:	83 c1 01             	add    $0x1,%ecx
  for(i=0; i<len; i++)
80102bf1:	39 f9                	cmp    %edi,%ecx
80102bf3:	75 f4                	jne    80102be9 <mpsearch1+0x44>
80102bf5:	eb cb                	jmp    80102bc2 <mpsearch1+0x1d>
  return 0;
80102bf7:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102bfc:	89 d8                	mov    %ebx,%eax
80102bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c01:	5b                   	pop    %ebx
80102c02:	5e                   	pop    %esi
80102c03:	5f                   	pop    %edi
80102c04:	5d                   	pop    %ebp
80102c05:	c3                   	ret    

80102c06 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c06:	55                   	push   %ebp
80102c07:	89 e5                	mov    %esp,%ebp
80102c09:	57                   	push   %edi
80102c0a:	56                   	push   %esi
80102c0b:	53                   	push   %ebx
80102c0c:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c0f:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c16:	c1 e0 08             	shl    $0x8,%eax
80102c19:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c20:	09 d0                	or     %edx,%eax
80102c22:	c1 e0 04             	shl    $0x4,%eax
80102c25:	85 c0                	test   %eax,%eax
80102c27:	0f 84 b0 00 00 00    	je     80102cdd <mpinit+0xd7>
    if((mp = mpsearch1(p, 1024)))
80102c2d:	ba 00 04 00 00       	mov    $0x400,%edx
80102c32:	e8 6e ff ff ff       	call   80102ba5 <mpsearch1>
80102c37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c3a:	85 c0                	test   %eax,%eax
80102c3c:	0f 84 cb 00 00 00    	je     80102d0d <mpinit+0x107>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c45:	8b 58 04             	mov    0x4(%eax),%ebx
80102c48:	85 db                	test   %ebx,%ebx
80102c4a:	0f 84 d7 00 00 00    	je     80102d27 <mpinit+0x121>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c50:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c56:	83 ec 04             	sub    $0x4,%esp
80102c59:	6a 04                	push   $0x4
80102c5b:	68 7d 6a 10 80       	push   $0x80106a7d
80102c60:	56                   	push   %esi
80102c61:	e8 ee 11 00 00       	call   80103e54 <memcmp>
80102c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102c69:	83 c4 10             	add    $0x10,%esp
80102c6c:	85 c0                	test   %eax,%eax
80102c6e:	0f 85 b3 00 00 00    	jne    80102d27 <mpinit+0x121>
  if(conf->version != 1 && conf->version != 4)
80102c74:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102c7b:	3c 01                	cmp    $0x1,%al
80102c7d:	74 08                	je     80102c87 <mpinit+0x81>
80102c7f:	3c 04                	cmp    $0x4,%al
80102c81:	0f 85 a0 00 00 00    	jne    80102d27 <mpinit+0x121>
  if(sum((uchar*)conf, conf->length) != 0)
80102c87:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80102c8e:	66 85 d2             	test   %dx,%dx
80102c91:	74 1f                	je     80102cb2 <mpinit+0xac>
80102c93:	89 f0                	mov    %esi,%eax
80102c95:	0f b7 d2             	movzwl %dx,%edx
80102c98:	8d bc 13 00 00 00 80 	lea    -0x80000000(%ebx,%edx,1),%edi
  sum = 0;
80102c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    sum += addr[i];
80102ca2:	0f b6 08             	movzbl (%eax),%ecx
80102ca5:	01 ca                	add    %ecx,%edx
80102ca7:	83 c0 01             	add    $0x1,%eax
  for(i=0; i<len; i++)
80102caa:	39 c7                	cmp    %eax,%edi
80102cac:	75 f4                	jne    80102ca2 <mpinit+0x9c>
  if(sum((uchar*)conf, conf->length) != 0)
80102cae:	84 d2                	test   %dl,%dl
80102cb0:	75 75                	jne    80102d27 <mpinit+0x121>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102cb2:	85 f6                	test   %esi,%esi
80102cb4:	74 71                	je     80102d27 <mpinit+0x121>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102cb6:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102cbc:	a3 7c 16 11 80       	mov    %eax,0x8011167c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cc1:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102cc7:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102cce:	01 d6                	add    %edx,%esi
  ismp = 1;
80102cd0:	b9 01 00 00 00       	mov    $0x1,%ecx
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102cd5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cd8:	e9 88 00 00 00       	jmp    80102d65 <mpinit+0x15f>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cdd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ce4:	c1 e0 08             	shl    $0x8,%eax
80102ce7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cee:	09 d0                	or     %edx,%eax
80102cf0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cf3:	2d 00 04 00 00       	sub    $0x400,%eax
80102cf8:	ba 00 04 00 00       	mov    $0x400,%edx
80102cfd:	e8 a3 fe ff ff       	call   80102ba5 <mpsearch1>
80102d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d05:	85 c0                	test   %eax,%eax
80102d07:	0f 85 35 ff ff ff    	jne    80102c42 <mpinit+0x3c>
  return mpsearch1(0xF0000, 0x10000);
80102d0d:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d12:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d17:	e8 89 fe ff ff       	call   80102ba5 <mpsearch1>
80102d1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d1f:	85 c0                	test   %eax,%eax
80102d21:	0f 85 1b ff ff ff    	jne    80102c42 <mpinit+0x3c>
    panic("Expect to run on an SMP");
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 82 6a 10 80       	push   $0x80106a82
80102d2f:	e8 10 d6 ff ff       	call   80100344 <panic>
      ismp = 0;
80102d34:	89 f9                	mov    %edi,%ecx
80102d36:	eb 34                	jmp    80102d6c <mpinit+0x166>
      if(ncpu < NCPU) {
80102d38:	8b 15 00 1d 11 80    	mov    0x80111d00,%edx
80102d3e:	83 fa 07             	cmp    $0x7,%edx
80102d41:	7f 1f                	jg     80102d62 <mpinit+0x15c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d43:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102d46:	69 da b0 00 00 00    	imul   $0xb0,%edx,%ebx
80102d4c:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d50:	88 93 80 17 11 80    	mov    %dl,-0x7feee880(%ebx)
        ncpu++;
80102d56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102d59:	83 c2 01             	add    $0x1,%edx
80102d5c:	89 15 00 1d 11 80    	mov    %edx,0x80111d00
      p += sizeof(struct mpproc);
80102d62:	83 c0 14             	add    $0x14,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d65:	39 f0                	cmp    %esi,%eax
80102d67:	73 26                	jae    80102d8f <mpinit+0x189>
    switch(*p){
80102d69:	0f b6 10             	movzbl (%eax),%edx
80102d6c:	80 fa 04             	cmp    $0x4,%dl
80102d6f:	77 c3                	ja     80102d34 <mpinit+0x12e>
80102d71:	0f b6 d2             	movzbl %dl,%edx
80102d74:	ff 24 95 bc 6a 10 80 	jmp    *-0x7fef9544(,%edx,4)
      ioapicid = ioapic->apicno;
80102d7b:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d7f:	88 15 60 17 11 80    	mov    %dl,0x80111760
      p += sizeof(struct mpioapic);
80102d85:	83 c0 08             	add    $0x8,%eax
      continue;
80102d88:	eb db                	jmp    80102d65 <mpinit+0x15f>
      p += 8;
80102d8a:	83 c0 08             	add    $0x8,%eax
      continue;
80102d8d:	eb d6                	jmp    80102d65 <mpinit+0x15f>
      break;
    }
  }
  if(!ismp)
80102d8f:	85 c9                	test   %ecx,%ecx
80102d91:	74 26                	je     80102db9 <mpinit+0x1b3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d96:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d9a:	74 15                	je     80102db1 <mpinit+0x1ab>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9c:	b8 70 00 00 00       	mov    $0x70,%eax
80102da1:	ba 22 00 00 00       	mov    $0x22,%edx
80102da6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da7:	ba 23 00 00 00       	mov    $0x23,%edx
80102dac:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102dad:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db0:	ee                   	out    %al,(%dx)
  }
}
80102db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db4:	5b                   	pop    %ebx
80102db5:	5e                   	pop    %esi
80102db6:	5f                   	pop    %edi
80102db7:	5d                   	pop    %ebp
80102db8:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102db9:	83 ec 0c             	sub    $0xc,%esp
80102dbc:	68 9c 6a 10 80       	push   $0x80106a9c
80102dc1:	e8 7e d5 ff ff       	call   80100344 <panic>

80102dc6 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102dc6:	55                   	push   %ebp
80102dc7:	89 e5                	mov    %esp,%ebp
80102dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dce:	ba 21 00 00 00       	mov    $0x21,%edx
80102dd3:	ee                   	out    %al,(%dx)
80102dd4:	ba a1 00 00 00       	mov    $0xa1,%edx
80102dd9:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102dda:	5d                   	pop    %ebp
80102ddb:	c3                   	ret    

80102ddc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102ddc:	55                   	push   %ebp
80102ddd:	89 e5                	mov    %esp,%ebp
80102ddf:	57                   	push   %edi
80102de0:	56                   	push   %esi
80102de1:	53                   	push   %ebx
80102de2:	83 ec 0c             	sub    $0xc,%esp
80102de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102de8:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102deb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102df1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102df7:	e8 7e de ff ff       	call   80100c7a <filealloc>
80102dfc:	89 03                	mov    %eax,(%ebx)
80102dfe:	85 c0                	test   %eax,%eax
80102e00:	0f 84 a9 00 00 00    	je     80102eaf <pipealloc+0xd3>
80102e06:	e8 6f de ff ff       	call   80100c7a <filealloc>
80102e0b:	89 06                	mov    %eax,(%esi)
80102e0d:	85 c0                	test   %eax,%eax
80102e0f:	0f 84 88 00 00 00    	je     80102e9d <pipealloc+0xc1>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e15:	e8 44 f3 ff ff       	call   8010215e <kalloc>
80102e1a:	89 c7                	mov    %eax,%edi
80102e1c:	85 c0                	test   %eax,%eax
80102e1e:	75 0b                	jne    80102e2b <pipealloc+0x4f>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e20:	8b 03                	mov    (%ebx),%eax
80102e22:	85 c0                	test   %eax,%eax
80102e24:	75 7d                	jne    80102ea3 <pipealloc+0xc7>
80102e26:	e9 84 00 00 00       	jmp    80102eaf <pipealloc+0xd3>
  p->readopen = 1;
80102e2b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e32:	00 00 00 
  p->writeopen = 1;
80102e35:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e3c:	00 00 00 
  p->nwrite = 0;
80102e3f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e46:	00 00 00 
  p->nread = 0;
80102e49:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e50:	00 00 00 
  initlock(&p->lock, "pipe");
80102e53:	83 ec 08             	sub    $0x8,%esp
80102e56:	68 d0 6a 10 80       	push   $0x80106ad0
80102e5b:	50                   	push   %eax
80102e5c:	e8 b9 0d 00 00       	call   80103c1a <initlock>
  (*f0)->type = FD_PIPE;
80102e61:	8b 03                	mov    (%ebx),%eax
80102e63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e69:	8b 03                	mov    (%ebx),%eax
80102e6b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e6f:	8b 03                	mov    (%ebx),%eax
80102e71:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e75:	8b 03                	mov    (%ebx),%eax
80102e77:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e7a:	8b 06                	mov    (%esi),%eax
80102e7c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e82:	8b 06                	mov    (%esi),%eax
80102e84:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e88:	8b 06                	mov    (%esi),%eax
80102e8a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e8e:	8b 06                	mov    (%esi),%eax
80102e90:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e93:	83 c4 10             	add    $0x10,%esp
80102e96:	b8 00 00 00 00       	mov    $0x0,%eax
80102e9b:	eb 2e                	jmp    80102ecb <pipealloc+0xef>
  if(*f0)
80102e9d:	8b 03                	mov    (%ebx),%eax
80102e9f:	85 c0                	test   %eax,%eax
80102ea1:	74 30                	je     80102ed3 <pipealloc+0xf7>
    fileclose(*f0);
80102ea3:	83 ec 0c             	sub    $0xc,%esp
80102ea6:	50                   	push   %eax
80102ea7:	e8 80 de ff ff       	call   80100d2c <fileclose>
80102eac:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102eaf:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102eb6:	85 d2                	test   %edx,%edx
80102eb8:	74 11                	je     80102ecb <pipealloc+0xef>
    fileclose(*f1);
80102eba:	83 ec 0c             	sub    $0xc,%esp
80102ebd:	52                   	push   %edx
80102ebe:	e8 69 de ff ff       	call   80100d2c <fileclose>
80102ec3:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ece:	5b                   	pop    %ebx
80102ecf:	5e                   	pop    %esi
80102ed0:	5f                   	pop    %edi
80102ed1:	5d                   	pop    %ebp
80102ed2:	c3                   	ret    
  return -1;
80102ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ed8:	eb f1                	jmp    80102ecb <pipealloc+0xef>

80102eda <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	83 ec 10             	sub    $0x10,%esp
80102ee1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ee4:	53                   	push   %ebx
80102ee5:	e8 78 0e 00 00       	call   80103d62 <acquire>
  if(writable){
80102eea:	83 c4 10             	add    $0x10,%esp
80102eed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102ef1:	74 3f                	je     80102f32 <pipeclose+0x58>
    p->writeopen = 0;
80102ef3:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102efa:	00 00 00 
    wakeup(&p->nread);
80102efd:	83 ec 0c             	sub    $0xc,%esp
80102f00:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f06:	50                   	push   %eax
80102f07:	e8 54 0a 00 00       	call   80103960 <wakeup>
80102f0c:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f0f:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f16:	75 09                	jne    80102f21 <pipeclose+0x47>
80102f18:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f1f:	74 2f                	je     80102f50 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f21:	83 ec 0c             	sub    $0xc,%esp
80102f24:	53                   	push   %ebx
80102f25:	e8 9f 0e 00 00       	call   80103dc9 <release>
80102f2a:	83 c4 10             	add    $0x10,%esp
}
80102f2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f30:	c9                   	leave  
80102f31:	c3                   	ret    
    p->readopen = 0;
80102f32:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f39:	00 00 00 
    wakeup(&p->nwrite);
80102f3c:	83 ec 0c             	sub    $0xc,%esp
80102f3f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f45:	50                   	push   %eax
80102f46:	e8 15 0a 00 00       	call   80103960 <wakeup>
80102f4b:	83 c4 10             	add    $0x10,%esp
80102f4e:	eb bf                	jmp    80102f0f <pipeclose+0x35>
    release(&p->lock);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	53                   	push   %ebx
80102f54:	e8 70 0e 00 00       	call   80103dc9 <release>
    kfree((char*)p);
80102f59:	89 1c 24             	mov    %ebx,(%esp)
80102f5c:	e8 d8 f0 ff ff       	call   80102039 <kfree>
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	eb c7                	jmp    80102f2d <pipeclose+0x53>

80102f66 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f66:	55                   	push   %ebp
80102f67:	89 e5                	mov    %esp,%ebp
80102f69:	57                   	push   %edi
80102f6a:	56                   	push   %esi
80102f6b:	53                   	push   %ebx
80102f6c:	83 ec 28             	sub    $0x28,%esp
80102f6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f72:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102f75:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102f78:	53                   	push   %ebx
80102f79:	e8 e4 0d 00 00       	call   80103d62 <acquire>
  for(i = 0; i < n; i++){
80102f7e:	83 c4 10             	add    $0x10,%esp
80102f81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102f85:	0f 8e b5 00 00 00    	jle    80103040 <pipewrite+0xda>
80102f8b:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102f8e:	03 75 10             	add    0x10(%ebp),%esi
80102f91:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f94:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f9a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fa0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fa6:	05 00 02 00 00       	add    $0x200,%eax
80102fab:	39 c2                	cmp    %eax,%edx
80102fad:	75 69                	jne    80103018 <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80102faf:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102fb6:	74 47                	je     80102fff <pipewrite+0x99>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fb8:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
      if(p->readopen == 0 || myproc()->killed){
80102fbe:	e8 71 03 00 00       	call   80103334 <myproc>
80102fc3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fc7:	75 36                	jne    80102fff <pipewrite+0x99>
      wakeup(&p->nread);
80102fc9:	83 ec 0c             	sub    $0xc,%esp
80102fcc:	57                   	push   %edi
80102fcd:	e8 8e 09 00 00       	call   80103960 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fd2:	83 c4 08             	add    $0x8,%esp
80102fd5:	ff 75 e4             	pushl  -0x1c(%ebp)
80102fd8:	56                   	push   %esi
80102fd9:	e8 02 08 00 00       	call   801037e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fde:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fe4:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fea:	05 00 02 00 00       	add    $0x200,%eax
80102fef:	83 c4 10             	add    $0x10,%esp
80102ff2:	39 c2                	cmp    %eax,%edx
80102ff4:	75 22                	jne    80103018 <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80102ff6:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ffd:	75 bf                	jne    80102fbe <pipewrite+0x58>
        release(&p->lock);
80102fff:	83 ec 0c             	sub    $0xc,%esp
80103002:	53                   	push   %ebx
80103003:	e8 c1 0d 00 00       	call   80103dc9 <release>
        return -1;
80103008:	83 c4 10             	add    $0x10,%esp
8010300b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103013:	5b                   	pop    %ebx
80103014:	5e                   	pop    %esi
80103015:	5f                   	pop    %edi
80103016:	5d                   	pop    %ebp
80103017:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103018:	8d 42 01             	lea    0x1(%edx),%eax
8010301b:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103021:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103024:	0f b6 01             	movzbl (%ecx),%eax
80103027:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010302d:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80103031:	83 c1 01             	add    $0x1,%ecx
80103034:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; i < n; i++){
80103037:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
8010303a:	0f 85 5a ff ff ff    	jne    80102f9a <pipewrite+0x34>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103040:	83 ec 0c             	sub    $0xc,%esp
80103043:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103049:	50                   	push   %eax
8010304a:	e8 11 09 00 00       	call   80103960 <wakeup>
  release(&p->lock);
8010304f:	89 1c 24             	mov    %ebx,(%esp)
80103052:	e8 72 0d 00 00       	call   80103dc9 <release>
  return n;
80103057:	83 c4 10             	add    $0x10,%esp
8010305a:	8b 45 10             	mov    0x10(%ebp),%eax
8010305d:	eb b1                	jmp    80103010 <pipewrite+0xaa>

8010305f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010305f:	55                   	push   %ebp
80103060:	89 e5                	mov    %esp,%ebp
80103062:	57                   	push   %edi
80103063:	56                   	push   %esi
80103064:	53                   	push   %ebx
80103065:	83 ec 18             	sub    $0x18,%esp
80103068:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010306b:	53                   	push   %ebx
8010306c:	e8 f1 0c 00 00       	call   80103d62 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103071:	83 c4 10             	add    $0x10,%esp
80103074:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010307a:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103080:	75 7c                	jne    801030fe <piperead+0x9f>
80103082:	89 de                	mov    %ebx,%esi
80103084:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
8010308b:	74 35                	je     801030c2 <piperead+0x63>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010308d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    if(myproc()->killed){
80103093:	e8 9c 02 00 00       	call   80103334 <myproc>
80103098:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010309c:	75 4d                	jne    801030eb <piperead+0x8c>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010309e:	83 ec 08             	sub    $0x8,%esp
801030a1:	56                   	push   %esi
801030a2:	57                   	push   %edi
801030a3:	e8 38 07 00 00       	call   801037e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030a8:	83 c4 10             	add    $0x10,%esp
801030ab:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030b1:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030b7:	75 45                	jne    801030fe <piperead+0x9f>
801030b9:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
801030c0:	75 d1                	jne    80103093 <piperead+0x34>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030c2:	be 00 00 00 00       	mov    $0x0,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030c7:	83 ec 0c             	sub    $0xc,%esp
801030ca:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801030d0:	50                   	push   %eax
801030d1:	e8 8a 08 00 00       	call   80103960 <wakeup>
  release(&p->lock);
801030d6:	89 1c 24             	mov    %ebx,(%esp)
801030d9:	e8 eb 0c 00 00       	call   80103dc9 <release>
  return i;
801030de:	83 c4 10             	add    $0x10,%esp
}
801030e1:	89 f0                	mov    %esi,%eax
801030e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030e6:	5b                   	pop    %ebx
801030e7:	5e                   	pop    %esi
801030e8:	5f                   	pop    %edi
801030e9:	5d                   	pop    %ebp
801030ea:	c3                   	ret    
      release(&p->lock);
801030eb:	83 ec 0c             	sub    $0xc,%esp
801030ee:	53                   	push   %ebx
801030ef:	e8 d5 0c 00 00       	call   80103dc9 <release>
      return -1;
801030f4:	83 c4 10             	add    $0x10,%esp
801030f7:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030fc:	eb e3                	jmp    801030e1 <piperead+0x82>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103102:	7e 3c                	jle    80103140 <piperead+0xe1>
    if(p->nread == p->nwrite)
80103104:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010310a:	be 00 00 00 00       	mov    $0x0,%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010310f:	8d 50 01             	lea    0x1(%eax),%edx
80103112:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103118:	25 ff 01 00 00       	and    $0x1ff,%eax
8010311d:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103125:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103128:	83 c6 01             	add    $0x1,%esi
8010312b:	39 75 10             	cmp    %esi,0x10(%ebp)
8010312e:	74 97                	je     801030c7 <piperead+0x68>
    if(p->nread == p->nwrite)
80103130:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103136:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010313c:	75 d1                	jne    8010310f <piperead+0xb0>
8010313e:	eb 87                	jmp    801030c7 <piperead+0x68>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103140:	be 00 00 00 00       	mov    $0x0,%esi
80103145:	eb 80                	jmp    801030c7 <piperead+0x68>

80103147 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103147:	55                   	push   %ebp
80103148:	89 e5                	mov    %esp,%ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010314a:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
8010314f:	eb 0e                	jmp    8010315f <wakeup1+0x18>
80103151:	81 c2 88 00 00 00    	add    $0x88,%edx
80103157:	81 fa 54 3f 11 80    	cmp    $0x80113f54,%edx
8010315d:	73 14                	jae    80103173 <wakeup1+0x2c>
    if(p->state == SLEEPING && p->chan == chan)
8010315f:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103163:	75 ec                	jne    80103151 <wakeup1+0xa>
80103165:	39 42 20             	cmp    %eax,0x20(%edx)
80103168:	75 e7                	jne    80103151 <wakeup1+0xa>
      p->state = RUNNABLE;
8010316a:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103171:	eb de                	jmp    80103151 <wakeup1+0xa>
}
80103173:	5d                   	pop    %ebp
80103174:	c3                   	ret    

80103175 <allocproc>:
{
80103175:	55                   	push   %ebp
80103176:	89 e5                	mov    %esp,%ebp
80103178:	53                   	push   %ebx
80103179:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010317c:	68 20 1d 11 80       	push   $0x80111d20
80103181:	e8 dc 0b 00 00       	call   80103d62 <acquire>
    if(p->state == UNUSED)
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	83 3d 60 1d 11 80 00 	cmpl   $0x0,0x80111d60
80103190:	74 30                	je     801031c2 <allocproc+0x4d>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103192:	bb dc 1d 11 80       	mov    $0x80111ddc,%ebx
    if(p->state == UNUSED)
80103197:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
8010319b:	74 2a                	je     801031c7 <allocproc+0x52>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010319d:	81 c3 88 00 00 00    	add    $0x88,%ebx
801031a3:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801031a9:	72 ec                	jb     80103197 <allocproc+0x22>
  release(&ptable.lock);
801031ab:	83 ec 0c             	sub    $0xc,%esp
801031ae:	68 20 1d 11 80       	push   $0x80111d20
801031b3:	e8 11 0c 00 00       	call   80103dc9 <release>
  return 0;
801031b8:	83 c4 10             	add    $0x10,%esp
801031bb:	bb 00 00 00 00       	mov    $0x0,%ebx
801031c0:	eb 6e                	jmp    80103230 <allocproc+0xbb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031c2:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
  p->state = EMBRYO;
801031c7:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031ce:	a1 04 90 10 80       	mov    0x80109004,%eax
801031d3:	8d 50 01             	lea    0x1(%eax),%edx
801031d6:	89 15 04 90 10 80    	mov    %edx,0x80109004
801031dc:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801031df:	83 ec 0c             	sub    $0xc,%esp
801031e2:	68 20 1d 11 80       	push   $0x80111d20
801031e7:	e8 dd 0b 00 00       	call   80103dc9 <release>
  if((p->kstack = kalloc()) == 0){
801031ec:	e8 6d ef ff ff       	call   8010215e <kalloc>
801031f1:	89 43 08             	mov    %eax,0x8(%ebx)
801031f4:	83 c4 10             	add    $0x10,%esp
801031f7:	85 c0                	test   %eax,%eax
801031f9:	74 3c                	je     80103237 <allocproc+0xc2>
  sp -= sizeof *p->tf;
801031fb:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103201:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103204:	c7 80 b0 0f 00 00 b5 	movl   $0x80104eb5,0xfb0(%eax)
8010320b:	4e 10 80 
  sp -= sizeof *p->context;
8010320e:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103213:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	6a 14                	push   $0x14
8010321b:	6a 00                	push   $0x0
8010321d:	50                   	push   %eax
8010321e:	e8 ed 0b 00 00       	call   80103e10 <memset>
  p->context->eip = (uint)forkret;
80103223:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103226:	c7 40 10 45 32 10 80 	movl   $0x80103245,0x10(%eax)
  return p;
8010322d:	83 c4 10             	add    $0x10,%esp
}
80103230:	89 d8                	mov    %ebx,%eax
80103232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103235:	c9                   	leave  
80103236:	c3                   	ret    
    p->state = UNUSED;
80103237:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010323e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103243:	eb eb                	jmp    80103230 <allocproc+0xbb>

80103245 <forkret>:
{
80103245:	55                   	push   %ebp
80103246:	89 e5                	mov    %esp,%ebp
80103248:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
8010324b:	68 20 1d 11 80       	push   $0x80111d20
80103250:	e8 74 0b 00 00       	call   80103dc9 <release>
  if (first) {
80103255:	83 c4 10             	add    $0x10,%esp
80103258:	83 3d 00 90 10 80 00 	cmpl   $0x0,0x80109000
8010325f:	75 02                	jne    80103263 <forkret+0x1e>
}
80103261:	c9                   	leave  
80103262:	c3                   	ret    
    first = 0;
80103263:	c7 05 00 90 10 80 00 	movl   $0x0,0x80109000
8010326a:	00 00 00 
    iinit(ROOTDEV);
8010326d:	83 ec 0c             	sub    $0xc,%esp
80103270:	6a 01                	push   $0x1
80103272:	e8 8f e0 ff ff       	call   80101306 <iinit>
    initlog(ROOTDEV);
80103277:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010327e:	e8 95 f4 ff ff       	call   80102718 <initlog>
80103283:	83 c4 10             	add    $0x10,%esp
}
80103286:	eb d9                	jmp    80103261 <forkret+0x1c>

80103288 <pinit>:
{
80103288:	55                   	push   %ebp
80103289:	89 e5                	mov    %esp,%ebp
8010328b:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010328e:	68 d5 6a 10 80       	push   $0x80106ad5
80103293:	68 20 1d 11 80       	push   $0x80111d20
80103298:	e8 7d 09 00 00       	call   80103c1a <initlock>
}
8010329d:	83 c4 10             	add    $0x10,%esp
801032a0:	c9                   	leave  
801032a1:	c3                   	ret    

801032a2 <mycpu>:
{
801032a2:	55                   	push   %ebp
801032a3:	89 e5                	mov    %esp,%ebp
801032a5:	56                   	push   %esi
801032a6:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032a7:	9c                   	pushf  
801032a8:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032a9:	f6 c4 02             	test   $0x2,%ah
801032ac:	75 4a                	jne    801032f8 <mycpu+0x56>
  apicid = lapicid();
801032ae:	e8 8d f1 ff ff       	call   80102440 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032b3:	8b 35 00 1d 11 80    	mov    0x80111d00,%esi
801032b9:	85 f6                	test   %esi,%esi
801032bb:	7e 4f                	jle    8010330c <mycpu+0x6a>
    if (cpus[i].apicid == apicid)
801032bd:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
801032c4:	39 d0                	cmp    %edx,%eax
801032c6:	74 3d                	je     80103305 <mycpu+0x63>
801032c8:	b9 30 18 11 80       	mov    $0x80111830,%ecx
  for (i = 0; i < ncpu; ++i) {
801032cd:	ba 00 00 00 00       	mov    $0x0,%edx
801032d2:	83 c2 01             	add    $0x1,%edx
801032d5:	39 f2                	cmp    %esi,%edx
801032d7:	74 33                	je     8010330c <mycpu+0x6a>
    if (cpus[i].apicid == apicid)
801032d9:	0f b6 19             	movzbl (%ecx),%ebx
801032dc:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801032e2:	39 c3                	cmp    %eax,%ebx
801032e4:	75 ec                	jne    801032d2 <mycpu+0x30>
      return &cpus[i];
801032e6:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801032ec:	05 80 17 11 80       	add    $0x80111780,%eax
}
801032f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032f4:	5b                   	pop    %ebx
801032f5:	5e                   	pop    %esi
801032f6:	5d                   	pop    %ebp
801032f7:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
801032f8:	83 ec 0c             	sub    $0xc,%esp
801032fb:	68 b8 6b 10 80       	push   $0x80106bb8
80103300:	e8 3f d0 ff ff       	call   80100344 <panic>
  for (i = 0; i < ncpu; ++i) {
80103305:	ba 00 00 00 00       	mov    $0x0,%edx
8010330a:	eb da                	jmp    801032e6 <mycpu+0x44>
  panic("unknown apicid\n");
8010330c:	83 ec 0c             	sub    $0xc,%esp
8010330f:	68 dc 6a 10 80       	push   $0x80106adc
80103314:	e8 2b d0 ff ff       	call   80100344 <panic>

80103319 <cpuid>:
cpuid() {
80103319:	55                   	push   %ebp
8010331a:	89 e5                	mov    %esp,%ebp
8010331c:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010331f:	e8 7e ff ff ff       	call   801032a2 <mycpu>
80103324:	2d 80 17 11 80       	sub    $0x80111780,%eax
80103329:	c1 f8 04             	sar    $0x4,%eax
8010332c:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103332:	c9                   	leave  
80103333:	c3                   	ret    

80103334 <myproc>:
myproc(void) {
80103334:	55                   	push   %ebp
80103335:	89 e5                	mov    %esp,%ebp
80103337:	53                   	push   %ebx
80103338:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010333b:	e8 51 09 00 00       	call   80103c91 <pushcli>
  c = mycpu();
80103340:	e8 5d ff ff ff       	call   801032a2 <mycpu>
  p = c->proc;
80103345:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010334b:	e8 7e 09 00 00       	call   80103cce <popcli>
}
80103350:	89 d8                	mov    %ebx,%eax
80103352:	83 c4 04             	add    $0x4,%esp
80103355:	5b                   	pop    %ebx
80103356:	5d                   	pop    %ebp
80103357:	c3                   	ret    

80103358 <userinit>:
{
80103358:	55                   	push   %ebp
80103359:	89 e5                	mov    %esp,%ebp
8010335b:	53                   	push   %ebx
8010335c:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010335f:	e8 11 fe ff ff       	call   80103175 <allocproc>
80103364:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103366:	a3 b8 95 10 80       	mov    %eax,0x801095b8
  if((p->pgdir = setupkvm()) == 0)
8010336b:	e8 b2 2f 00 00       	call   80106322 <setupkvm>
80103370:	89 43 04             	mov    %eax,0x4(%ebx)
80103373:	85 c0                	test   %eax,%eax
80103375:	0f 84 b7 00 00 00    	je     80103432 <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010337b:	83 ec 04             	sub    $0x4,%esp
8010337e:	68 2c 00 00 00       	push   $0x2c
80103383:	68 60 94 10 80       	push   $0x80109460
80103388:	50                   	push   %eax
80103389:	e8 8d 2c 00 00       	call   8010601b <inituvm>
  p->sz = PGSIZE;
8010338e:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103394:	83 c4 0c             	add    $0xc,%esp
80103397:	6a 4c                	push   $0x4c
80103399:	6a 00                	push   $0x0
8010339b:	ff 73 18             	pushl  0x18(%ebx)
8010339e:	e8 6d 0a 00 00       	call   80103e10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033a3:	8b 43 18             	mov    0x18(%ebx),%eax
801033a6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033ac:	8b 43 18             	mov    0x18(%ebx),%eax
801033af:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033b5:	8b 43 18             	mov    0x18(%ebx),%eax
801033b8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033bc:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033c0:	8b 43 18             	mov    0x18(%ebx),%eax
801033c3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033c7:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033cb:	8b 43 18             	mov    0x18(%ebx),%eax
801033ce:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033d5:	8b 43 18             	mov    0x18(%ebx),%eax
801033d8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033df:	8b 43 18             	mov    0x18(%ebx),%eax
801033e2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033e9:	83 c4 0c             	add    $0xc,%esp
801033ec:	6a 10                	push   $0x10
801033ee:	68 05 6b 10 80       	push   $0x80106b05
801033f3:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033f6:	50                   	push   %eax
801033f7:	e8 a3 0b 00 00       	call   80103f9f <safestrcpy>
  p->cwd = namei("/");
801033fc:	c7 04 24 0e 6b 10 80 	movl   $0x80106b0e,(%esp)
80103403:	e8 7b e8 ff ff       	call   80101c83 <namei>
80103408:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010340b:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103412:	e8 4b 09 00 00       	call   80103d62 <acquire>
  p->state = RUNNABLE;
80103417:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010341e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103425:	e8 9f 09 00 00       	call   80103dc9 <release>
}
8010342a:	83 c4 10             	add    $0x10,%esp
8010342d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103430:	c9                   	leave  
80103431:	c3                   	ret    
    panic("userinit: out of memory?");
80103432:	83 ec 0c             	sub    $0xc,%esp
80103435:	68 ec 6a 10 80       	push   $0x80106aec
8010343a:	e8 05 cf ff ff       	call   80100344 <panic>

8010343f <growproc>:
{
8010343f:	55                   	push   %ebp
80103440:	89 e5                	mov    %esp,%ebp
80103442:	56                   	push   %esi
80103443:	53                   	push   %ebx
80103444:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103447:	e8 e8 fe ff ff       	call   80103334 <myproc>
8010344c:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
8010344e:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103450:	85 f6                	test   %esi,%esi
80103452:	7f 21                	jg     80103475 <growproc+0x36>
  } else if(n < 0){
80103454:	85 f6                	test   %esi,%esi
80103456:	79 33                	jns    8010348b <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103458:	83 ec 04             	sub    $0x4,%esp
8010345b:	01 c6                	add    %eax,%esi
8010345d:	56                   	push   %esi
8010345e:	50                   	push   %eax
8010345f:	ff 73 04             	pushl  0x4(%ebx)
80103462:	e8 cb 2c 00 00       	call   80106132 <deallocuvm>
80103467:	83 c4 10             	add    $0x10,%esp
8010346a:	85 c0                	test   %eax,%eax
8010346c:	75 1d                	jne    8010348b <growproc+0x4c>
      return -1;
8010346e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103473:	eb 29                	jmp    8010349e <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103475:	83 ec 04             	sub    $0x4,%esp
80103478:	01 c6                	add    %eax,%esi
8010347a:	56                   	push   %esi
8010347b:	50                   	push   %eax
8010347c:	ff 73 04             	pushl  0x4(%ebx)
8010347f:	e8 3d 2d 00 00       	call   801061c1 <allocuvm>
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 c0                	test   %eax,%eax
80103489:	74 1a                	je     801034a5 <growproc+0x66>
  curproc->sz = sz;
8010348b:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010348d:	83 ec 0c             	sub    $0xc,%esp
80103490:	53                   	push   %ebx
80103491:	e8 87 2a 00 00       	call   80105f1d <switchuvm>
  return 0;
80103496:	83 c4 10             	add    $0x10,%esp
80103499:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010349e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a1:	5b                   	pop    %ebx
801034a2:	5e                   	pop    %esi
801034a3:	5d                   	pop    %ebp
801034a4:	c3                   	ret    
      return -1;
801034a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034aa:	eb f2                	jmp    8010349e <growproc+0x5f>

801034ac <fork>:
{
801034ac:	55                   	push   %ebp
801034ad:	89 e5                	mov    %esp,%ebp
801034af:	57                   	push   %edi
801034b0:	56                   	push   %esi
801034b1:	53                   	push   %ebx
801034b2:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034b5:	e8 7a fe ff ff       	call   80103334 <myproc>
801034ba:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034bc:	e8 b4 fc ff ff       	call   80103175 <allocproc>
801034c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034c4:	85 c0                	test   %eax,%eax
801034c6:	0f 84 e0 00 00 00    	je     801035ac <fork+0x100>
801034cc:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034ce:	83 ec 08             	sub    $0x8,%esp
801034d1:	ff 33                	pushl  (%ebx)
801034d3:	ff 73 04             	pushl  0x4(%ebx)
801034d6:	e8 f8 2e 00 00       	call   801063d3 <copyuvm>
801034db:	89 47 04             	mov    %eax,0x4(%edi)
801034de:	83 c4 10             	add    $0x10,%esp
801034e1:	85 c0                	test   %eax,%eax
801034e3:	74 2a                	je     8010350f <fork+0x63>
  np->sz = curproc->sz;
801034e5:	8b 03                	mov    (%ebx),%eax
801034e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034ea:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801034ec:	89 c8                	mov    %ecx,%eax
801034ee:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801034f1:	8b 73 18             	mov    0x18(%ebx),%esi
801034f4:	8b 79 18             	mov    0x18(%ecx),%edi
801034f7:	b9 13 00 00 00       	mov    $0x13,%ecx
801034fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801034fe:	8b 40 18             	mov    0x18(%eax),%eax
80103501:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103508:	be 00 00 00 00       	mov    $0x0,%esi
8010350d:	eb 2e                	jmp    8010353d <fork+0x91>
    kfree(np->kstack);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103515:	ff 73 08             	pushl  0x8(%ebx)
80103518:	e8 1c eb ff ff       	call   80102039 <kfree>
    np->kstack = 0;
8010351d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103524:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010352b:	83 c4 10             	add    $0x10,%esp
8010352e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103533:	eb 6d                	jmp    801035a2 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
80103535:	83 c6 01             	add    $0x1,%esi
80103538:	83 fe 10             	cmp    $0x10,%esi
8010353b:	74 1d                	je     8010355a <fork+0xae>
    if(curproc->ofile[i])
8010353d:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103541:	85 c0                	test   %eax,%eax
80103543:	74 f0                	je     80103535 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103545:	83 ec 0c             	sub    $0xc,%esp
80103548:	50                   	push   %eax
80103549:	e8 99 d7 ff ff       	call   80100ce7 <filedup>
8010354e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103551:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	eb db                	jmp    80103535 <fork+0x89>
  np->cwd = idup(curproc->cwd);
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	ff 73 68             	pushl  0x68(%ebx)
80103560:	e8 56 df ff ff       	call   801014bb <idup>
80103565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103568:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010356b:	83 c4 0c             	add    $0xc,%esp
8010356e:	6a 10                	push   $0x10
80103570:	83 c3 6c             	add    $0x6c,%ebx
80103573:	53                   	push   %ebx
80103574:	8d 47 6c             	lea    0x6c(%edi),%eax
80103577:	50                   	push   %eax
80103578:	e8 22 0a 00 00       	call   80103f9f <safestrcpy>
  pid = np->pid;
8010357d:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103580:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103587:	e8 d6 07 00 00       	call   80103d62 <acquire>
  np->state = RUNNABLE;
8010358c:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103593:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010359a:	e8 2a 08 00 00       	call   80103dc9 <release>
  return pid;
8010359f:	83 c4 10             	add    $0x10,%esp
}
801035a2:	89 d8                	mov    %ebx,%eax
801035a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a7:	5b                   	pop    %ebx
801035a8:	5e                   	pop    %esi
801035a9:	5f                   	pop    %edi
801035aa:	5d                   	pop    %ebp
801035ab:	c3                   	ret    
    return -1;
801035ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035b1:	eb ef                	jmp    801035a2 <fork+0xf6>

801035b3 <scheduler>:
{
801035b3:	55                   	push   %ebp
801035b4:	89 e5                	mov    %esp,%ebp
801035b6:	57                   	push   %edi
801035b7:	56                   	push   %esi
801035b8:	53                   	push   %ebx
801035b9:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801035bc:	e8 e1 fc ff ff       	call   801032a2 <mycpu>
801035c1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801035c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801035ca:	00 00 00 
      swtch(&(c->scheduler), p->context);
801035cd:	8d 78 04             	lea    0x4(%eax),%edi
801035d0:	eb 5a                	jmp    8010362c <scheduler+0x79>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035d2:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035d8:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801035de:	73 3c                	jae    8010361c <scheduler+0x69>
      if(p->state != RUNNABLE)
801035e0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035e4:	75 ec                	jne    801035d2 <scheduler+0x1f>
      c->proc = p;
801035e6:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801035ec:	83 ec 0c             	sub    $0xc,%esp
801035ef:	53                   	push   %ebx
801035f0:	e8 28 29 00 00       	call   80105f1d <switchuvm>
      p->state = RUNNING;
801035f5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801035fc:	83 c4 08             	add    $0x8,%esp
801035ff:	ff 73 1c             	pushl  0x1c(%ebx)
80103602:	57                   	push   %edi
80103603:	e8 ed 09 00 00       	call   80103ff5 <swtch>
      switchkvm();
80103608:	e8 fe 28 00 00       	call   80105f0b <switchkvm>
      c->proc = 0;
8010360d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103614:	00 00 00 
80103617:	83 c4 10             	add    $0x10,%esp
8010361a:	eb b6                	jmp    801035d2 <scheduler+0x1f>
    release(&ptable.lock);
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	68 20 1d 11 80       	push   $0x80111d20
80103624:	e8 a0 07 00 00       	call   80103dc9 <release>
    sti();
80103629:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010362c:	fb                   	sti    
    acquire(&ptable.lock);
8010362d:	83 ec 0c             	sub    $0xc,%esp
80103630:	68 20 1d 11 80       	push   $0x80111d20
80103635:	e8 28 07 00 00       	call   80103d62 <acquire>
8010363a:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010363d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103642:	eb 9c                	jmp    801035e0 <scheduler+0x2d>

80103644 <sched>:
{
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	56                   	push   %esi
80103648:	53                   	push   %ebx
  struct proc *p = myproc();
80103649:	e8 e6 fc ff ff       	call   80103334 <myproc>
8010364e:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 20 1d 11 80       	push   $0x80111d20
80103658:	e8 d1 06 00 00       	call   80103d2e <holding>
8010365d:	83 c4 10             	add    $0x10,%esp
80103660:	85 c0                	test   %eax,%eax
80103662:	74 4f                	je     801036b3 <sched+0x6f>
  if(mycpu()->ncli != 1)
80103664:	e8 39 fc ff ff       	call   801032a2 <mycpu>
80103669:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103670:	75 4e                	jne    801036c0 <sched+0x7c>
  if(p->state == RUNNING)
80103672:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103676:	74 55                	je     801036cd <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103678:	9c                   	pushf  
80103679:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010367a:	f6 c4 02             	test   $0x2,%ah
8010367d:	75 5b                	jne    801036da <sched+0x96>
  intena = mycpu()->intena;
8010367f:	e8 1e fc ff ff       	call   801032a2 <mycpu>
80103684:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010368a:	e8 13 fc ff ff       	call   801032a2 <mycpu>
8010368f:	83 ec 08             	sub    $0x8,%esp
80103692:	ff 70 04             	pushl  0x4(%eax)
80103695:	83 c3 1c             	add    $0x1c,%ebx
80103698:	53                   	push   %ebx
80103699:	e8 57 09 00 00       	call   80103ff5 <swtch>
  mycpu()->intena = intena;
8010369e:	e8 ff fb ff ff       	call   801032a2 <mycpu>
801036a3:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036a9:	83 c4 10             	add    $0x10,%esp
801036ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036af:	5b                   	pop    %ebx
801036b0:	5e                   	pop    %esi
801036b1:	5d                   	pop    %ebp
801036b2:	c3                   	ret    
    panic("sched ptable.lock");
801036b3:	83 ec 0c             	sub    $0xc,%esp
801036b6:	68 10 6b 10 80       	push   $0x80106b10
801036bb:	e8 84 cc ff ff       	call   80100344 <panic>
    panic("sched locks");
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	68 22 6b 10 80       	push   $0x80106b22
801036c8:	e8 77 cc ff ff       	call   80100344 <panic>
    panic("sched running");
801036cd:	83 ec 0c             	sub    $0xc,%esp
801036d0:	68 2e 6b 10 80       	push   $0x80106b2e
801036d5:	e8 6a cc ff ff       	call   80100344 <panic>
    panic("sched interruptible");
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 3c 6b 10 80       	push   $0x80106b3c
801036e2:	e8 5d cc ff ff       	call   80100344 <panic>

801036e7 <exit>:
{
801036e7:	55                   	push   %ebp
801036e8:	89 e5                	mov    %esp,%ebp
801036ea:	57                   	push   %edi
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801036f0:	e8 3f fc ff ff       	call   80103334 <myproc>
801036f5:	89 c6                	mov    %eax,%esi
801036f7:	8d 58 28             	lea    0x28(%eax),%ebx
801036fa:	8d 78 68             	lea    0x68(%eax),%edi
  if(curproc == initproc)
801036fd:	39 05 b8 95 10 80    	cmp    %eax,0x801095b8
80103703:	75 14                	jne    80103719 <exit+0x32>
    panic("init exiting");
80103705:	83 ec 0c             	sub    $0xc,%esp
80103708:	68 50 6b 10 80       	push   $0x80106b50
8010370d:	e8 32 cc ff ff       	call   80100344 <panic>
80103712:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103715:	39 df                	cmp    %ebx,%edi
80103717:	74 1a                	je     80103733 <exit+0x4c>
    if(curproc->ofile[fd]){
80103719:	8b 03                	mov    (%ebx),%eax
8010371b:	85 c0                	test   %eax,%eax
8010371d:	74 f3                	je     80103712 <exit+0x2b>
      fileclose(curproc->ofile[fd]);
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	50                   	push   %eax
80103723:	e8 04 d6 ff ff       	call   80100d2c <fileclose>
      curproc->ofile[fd] = 0;
80103728:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010372e:	83 c4 10             	add    $0x10,%esp
80103731:	eb df                	jmp    80103712 <exit+0x2b>
  begin_op();
80103733:	e8 75 f0 ff ff       	call   801027ad <begin_op>
  iput(curproc->cwd);
80103738:	83 ec 0c             	sub    $0xc,%esp
8010373b:	ff 76 68             	pushl  0x68(%esi)
8010373e:	e8 aa de ff ff       	call   801015ed <iput>
  end_op();
80103743:	e8 e0 f0 ff ff       	call   80102828 <end_op>
  curproc->cwd = 0;
80103748:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010374f:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103756:	e8 07 06 00 00       	call   80103d62 <acquire>
  wakeup1(curproc->parent);
8010375b:	8b 46 14             	mov    0x14(%esi),%eax
8010375e:	e8 e4 f9 ff ff       	call   80103147 <wakeup1>
80103763:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103766:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010376b:	eb 0e                	jmp    8010377b <exit+0x94>
8010376d:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103773:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103779:	73 1a                	jae    80103795 <exit+0xae>
    if(p->parent == curproc){
8010377b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010377e:	75 ed                	jne    8010376d <exit+0x86>
      p->parent = initproc;
80103780:	a1 b8 95 10 80       	mov    0x801095b8,%eax
80103785:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103788:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010378c:	75 df                	jne    8010376d <exit+0x86>
        wakeup1(initproc);
8010378e:	e8 b4 f9 ff ff       	call   80103147 <wakeup1>
80103793:	eb d8                	jmp    8010376d <exit+0x86>
  curproc->state = ZOMBIE;
80103795:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010379c:	e8 a3 fe ff ff       	call   80103644 <sched>
  panic("zombie exit");
801037a1:	83 ec 0c             	sub    $0xc,%esp
801037a4:	68 5d 6b 10 80       	push   $0x80106b5d
801037a9:	e8 96 cb ff ff       	call   80100344 <panic>

801037ae <yield>:
{
801037ae:	55                   	push   %ebp
801037af:	89 e5                	mov    %esp,%ebp
801037b1:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037b4:	68 20 1d 11 80       	push   $0x80111d20
801037b9:	e8 a4 05 00 00       	call   80103d62 <acquire>
  myproc()->state = RUNNABLE;
801037be:	e8 71 fb ff ff       	call   80103334 <myproc>
801037c3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801037ca:	e8 75 fe ff ff       	call   80103644 <sched>
  release(&ptable.lock);
801037cf:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801037d6:	e8 ee 05 00 00       	call   80103dc9 <release>
}
801037db:	83 c4 10             	add    $0x10,%esp
801037de:	c9                   	leave  
801037df:	c3                   	ret    

801037e0 <sleep>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801037ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801037ef:	e8 40 fb ff ff       	call   80103334 <myproc>
  if(p == 0)
801037f4:	85 c0                	test   %eax,%eax
801037f6:	74 58                	je     80103850 <sleep+0x70>
801037f8:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801037fa:	85 f6                	test   %esi,%esi
801037fc:	74 5f                	je     8010385d <sleep+0x7d>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801037fe:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103804:	74 64                	je     8010386a <sleep+0x8a>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103806:	83 ec 0c             	sub    $0xc,%esp
80103809:	68 20 1d 11 80       	push   $0x80111d20
8010380e:	e8 4f 05 00 00       	call   80103d62 <acquire>
    release(lk);
80103813:	89 34 24             	mov    %esi,(%esp)
80103816:	e8 ae 05 00 00       	call   80103dc9 <release>
  p->chan = chan;
8010381b:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010381e:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103825:	e8 1a fe ff ff       	call   80103644 <sched>
  p->chan = 0;
8010382a:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103831:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103838:	e8 8c 05 00 00       	call   80103dc9 <release>
    acquire(lk);
8010383d:	89 34 24             	mov    %esi,(%esp)
80103840:	e8 1d 05 00 00       	call   80103d62 <acquire>
80103845:	83 c4 10             	add    $0x10,%esp
}
80103848:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010384b:	5b                   	pop    %ebx
8010384c:	5e                   	pop    %esi
8010384d:	5f                   	pop    %edi
8010384e:	5d                   	pop    %ebp
8010384f:	c3                   	ret    
    panic("sleep");
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	68 69 6b 10 80       	push   $0x80106b69
80103858:	e8 e7 ca ff ff       	call   80100344 <panic>
    panic("sleep without lk");
8010385d:	83 ec 0c             	sub    $0xc,%esp
80103860:	68 6f 6b 10 80       	push   $0x80106b6f
80103865:	e8 da ca ff ff       	call   80100344 <panic>
  p->chan = chan;
8010386a:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
8010386d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103874:	e8 cb fd ff ff       	call   80103644 <sched>
  p->chan = 0;
80103879:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103880:	eb c6                	jmp    80103848 <sleep+0x68>

80103882 <wait>:
{
80103882:	55                   	push   %ebp
80103883:	89 e5                	mov    %esp,%ebp
80103885:	57                   	push   %edi
80103886:	56                   	push   %esi
80103887:	53                   	push   %ebx
80103888:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
8010388b:	e8 a4 fa ff ff       	call   80103334 <myproc>
80103890:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	68 20 1d 11 80       	push   $0x80111d20
8010389a:	e8 c3 04 00 00       	call   80103d62 <acquire>
8010389f:	83 c4 10             	add    $0x10,%esp
      havekids = 1;
801038a2:	bf 01 00 00 00       	mov    $0x1,%edi
    havekids = 0;
801038a7:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ac:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801038b1:	eb 67                	jmp    8010391a <wait+0x98>
        pid = p->pid;
801038b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038b6:	83 ec 0c             	sub    $0xc,%esp
801038b9:	ff 73 08             	pushl  0x8(%ebx)
801038bc:	e8 78 e7 ff ff       	call   80102039 <kfree>
        p->kstack = 0;
801038c1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801038c8:	83 c4 04             	add    $0x4,%esp
801038cb:	ff 73 04             	pushl  0x4(%ebx)
801038ce:	e8 dc 29 00 00       	call   801062af <freevm>
        p->pid = 0;
801038d3:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801038da:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801038e1:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801038e5:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801038ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801038f3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801038fa:	e8 ca 04 00 00       	call   80103dc9 <release>
        return pid;
801038ff:	83 c4 10             	add    $0x10,%esp
}
80103902:	89 f0                	mov    %esi,%eax
80103904:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103907:	5b                   	pop    %ebx
80103908:	5e                   	pop    %esi
80103909:	5f                   	pop    %edi
8010390a:	5d                   	pop    %ebp
8010390b:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010390c:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103912:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103918:	73 0f                	jae    80103929 <wait+0xa7>
      if(p->parent != curproc)
8010391a:	39 73 14             	cmp    %esi,0x14(%ebx)
8010391d:	75 ed                	jne    8010390c <wait+0x8a>
      if(p->state == ZOMBIE){
8010391f:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103923:	74 8e                	je     801038b3 <wait+0x31>
      havekids = 1;
80103925:	89 f8                	mov    %edi,%eax
80103927:	eb e3                	jmp    8010390c <wait+0x8a>
    if(!havekids || curproc->killed){
80103929:	85 c0                	test   %eax,%eax
8010392b:	74 06                	je     80103933 <wait+0xb1>
8010392d:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103931:	74 17                	je     8010394a <wait+0xc8>
      release(&ptable.lock);
80103933:	83 ec 0c             	sub    $0xc,%esp
80103936:	68 20 1d 11 80       	push   $0x80111d20
8010393b:	e8 89 04 00 00       	call   80103dc9 <release>
      return -1;
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103948:	eb b8                	jmp    80103902 <wait+0x80>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010394a:	83 ec 08             	sub    $0x8,%esp
8010394d:	68 20 1d 11 80       	push   $0x80111d20
80103952:	56                   	push   %esi
80103953:	e8 88 fe ff ff       	call   801037e0 <sleep>
    havekids = 0;
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	e9 47 ff ff ff       	jmp    801038a7 <wait+0x25>

80103960 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103966:	68 20 1d 11 80       	push   $0x80111d20
8010396b:	e8 f2 03 00 00       	call   80103d62 <acquire>
  wakeup1(chan);
80103970:	8b 45 08             	mov    0x8(%ebp),%eax
80103973:	e8 cf f7 ff ff       	call   80103147 <wakeup1>
  release(&ptable.lock);
80103978:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010397f:	e8 45 04 00 00       	call   80103dc9 <release>
}
80103984:	83 c4 10             	add    $0x10,%esp
80103987:	c9                   	leave  
80103988:	c3                   	ret    

80103989 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103989:	55                   	push   %ebp
8010398a:	89 e5                	mov    %esp,%ebp
8010398c:	53                   	push   %ebx
8010398d:	83 ec 10             	sub    $0x10,%esp
80103990:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103993:	68 20 1d 11 80       	push   $0x80111d20
80103998:	e8 c5 03 00 00       	call   80103d62 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
8010399d:	83 c4 10             	add    $0x10,%esp
801039a0:	3b 1d 64 1d 11 80    	cmp    0x80111d64,%ebx
801039a6:	74 2d                	je     801039d5 <kill+0x4c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	b8 dc 1d 11 80       	mov    $0x80111ddc,%eax
    if(p->pid == pid){
801039ad:	39 58 10             	cmp    %ebx,0x10(%eax)
801039b0:	74 28                	je     801039da <kill+0x51>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b2:	05 88 00 00 00       	add    $0x88,%eax
801039b7:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
801039bc:	72 ef                	jb     801039ad <kill+0x24>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp
801039c1:	68 20 1d 11 80       	push   $0x80111d20
801039c6:	e8 fe 03 00 00       	call   80103dc9 <release>
  return -1;
801039cb:	83 c4 10             	add    $0x10,%esp
801039ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039d3:	eb 27                	jmp    801039fc <kill+0x73>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
      p->killed = 1;
801039da:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801039e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039e5:	74 1a                	je     80103a01 <kill+0x78>
      release(&ptable.lock);
801039e7:	83 ec 0c             	sub    $0xc,%esp
801039ea:	68 20 1d 11 80       	push   $0x80111d20
801039ef:	e8 d5 03 00 00       	call   80103dc9 <release>
      return 0;
801039f4:	83 c4 10             	add    $0x10,%esp
801039f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801039fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ff:	c9                   	leave  
80103a00:	c3                   	ret    
        p->state = RUNNABLE;
80103a01:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a08:	eb dd                	jmp    801039e7 <kill+0x5e>

80103a0a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a0a:	55                   	push   %ebp
80103a0b:	89 e5                	mov    %esp,%ebp
80103a0d:	57                   	push   %edi
80103a0e:	56                   	push   %esi
80103a0f:	53                   	push   %ebx
80103a10:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a13:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103a18:	8d 7d e8             	lea    -0x18(%ebp),%edi
80103a1b:	eb 39                	jmp    80103a56 <procdump+0x4c>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103a1d:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a20:	52                   	push   %edx
80103a21:	50                   	push   %eax
80103a22:	ff 73 10             	pushl  0x10(%ebx)
80103a25:	68 84 6b 10 80       	push   $0x80106b84
80103a2a:	e8 b2 cb ff ff       	call   801005e1 <cprintf>
    if(p->state == SLEEPING){
80103a2f:	83 c4 10             	add    $0x10,%esp
80103a32:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a36:	74 42                	je     80103a7a <procdump+0x70>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a38:	83 ec 0c             	sub    $0xc,%esp
80103a3b:	68 fb 6e 10 80       	push   $0x80106efb
80103a40:	e8 9c cb ff ff       	call   801005e1 <cprintf>
80103a45:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a48:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a4e:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103a54:	73 7b                	jae    80103ad1 <procdump+0xc7>
    if(p->state == UNUSED)
80103a56:	8b 53 0c             	mov    0xc(%ebx),%edx
80103a59:	85 d2                	test   %edx,%edx
80103a5b:	74 eb                	je     80103a48 <procdump+0x3e>
      state = "???";
80103a5d:	b8 80 6b 10 80       	mov    $0x80106b80,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a62:	83 fa 05             	cmp    $0x5,%edx
80103a65:	77 b6                	ja     80103a1d <procdump+0x13>
80103a67:	8b 04 95 e0 6b 10 80 	mov    -0x7fef9420(,%edx,4),%eax
80103a6e:	85 c0                	test   %eax,%eax
      state = "???";
80103a70:	ba 80 6b 10 80       	mov    $0x80106b80,%edx
80103a75:	0f 44 c2             	cmove  %edx,%eax
80103a78:	eb a3                	jmp    80103a1d <procdump+0x13>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a7a:	83 ec 08             	sub    $0x8,%esp
80103a7d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103a80:	50                   	push   %eax
80103a81:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a84:	8b 40 0c             	mov    0xc(%eax),%eax
80103a87:	83 c0 08             	add    $0x8,%eax
80103a8a:	50                   	push   %eax
80103a8b:	e8 a5 01 00 00       	call   80103c35 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a90:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103a93:	83 c4 10             	add    $0x10,%esp
80103a96:	85 c0                	test   %eax,%eax
80103a98:	74 9e                	je     80103a38 <procdump+0x2e>
        cprintf(" %p", pc[i]);
80103a9a:	83 ec 08             	sub    $0x8,%esp
80103a9d:	50                   	push   %eax
80103a9e:	68 c1 65 10 80       	push   $0x801065c1
80103aa3:	e8 39 cb ff ff       	call   801005e1 <cprintf>
80103aa8:	8d 75 c4             	lea    -0x3c(%ebp),%esi
80103aab:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80103aae:	8b 06                	mov    (%esi),%eax
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	74 84                	je     80103a38 <procdump+0x2e>
        cprintf(" %p", pc[i]);
80103ab4:	83 ec 08             	sub    $0x8,%esp
80103ab7:	50                   	push   %eax
80103ab8:	68 c1 65 10 80       	push   $0x801065c1
80103abd:	e8 1f cb ff ff       	call   801005e1 <cprintf>
80103ac2:	83 c6 04             	add    $0x4,%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	39 f7                	cmp    %esi,%edi
80103aca:	75 e2                	jne    80103aae <procdump+0xa4>
80103acc:	e9 67 ff ff ff       	jmp    80103a38 <procdump+0x2e>
  }
}
80103ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad4:	5b                   	pop    %ebx
80103ad5:	5e                   	pop    %esi
80103ad6:	5f                   	pop    %edi
80103ad7:	5d                   	pop    %ebp
80103ad8:	c3                   	ret    

80103ad9 <getlevel>:

// MLFQ debugging function provided
// Just debugging for Process's level in MLFQ test case
int getlevel(void)
{
80103ad9:	55                   	push   %ebp
80103ada:	89 e5                	mov    %esp,%ebp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if (p -> state == RUNNING)
80103adc:	83 3d 60 1d 11 80 04 	cmpl   $0x4,0x80111d60
80103ae3:	74 1e                	je     80103b03 <getlevel+0x2a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae5:	b8 dc 1d 11 80       	mov    $0x80111ddc,%eax
    if (p -> state == RUNNING)
80103aea:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103aee:	74 18                	je     80103b08 <getlevel+0x2f>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af0:	05 88 00 00 00       	add    $0x88,%eax
80103af5:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
80103afa:	72 ee                	jb     80103aea <getlevel+0x11>
      return p->level;
  }

  return -1;
80103afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b01:	eb 0b                	jmp    80103b0e <getlevel+0x35>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b03:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
      return p->level;
80103b08:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80103b0e:	5d                   	pop    %ebp
80103b0f:	c3                   	ret    

80103b10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 0c             	sub    $0xc,%esp
80103b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b1a:	68 f8 6b 10 80       	push   $0x80106bf8
80103b1f:	8d 43 04             	lea    0x4(%ebx),%eax
80103b22:	50                   	push   %eax
80103b23:	e8 f2 00 00 00       	call   80103c1a <initlock>
  lk->name = name;
80103b28:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b2b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b34:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b41:	c9                   	leave  
80103b42:	c3                   	ret    

80103b43 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b43:	55                   	push   %ebp
80103b44:	89 e5                	mov    %esp,%ebp
80103b46:	56                   	push   %esi
80103b47:	53                   	push   %ebx
80103b48:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b4b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	56                   	push   %esi
80103b52:	e8 0b 02 00 00       	call   80103d62 <acquire>
  while (lk->locked) {
80103b57:	83 c4 10             	add    $0x10,%esp
80103b5a:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b5d:	74 12                	je     80103b71 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103b5f:	83 ec 08             	sub    $0x8,%esp
80103b62:	56                   	push   %esi
80103b63:	53                   	push   %ebx
80103b64:	e8 77 fc ff ff       	call   801037e0 <sleep>
  while (lk->locked) {
80103b69:	83 c4 10             	add    $0x10,%esp
80103b6c:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b6f:	75 ee                	jne    80103b5f <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103b71:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b77:	e8 b8 f7 ff ff       	call   80103334 <myproc>
80103b7c:	8b 40 10             	mov    0x10(%eax),%eax
80103b7f:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b82:	83 ec 0c             	sub    $0xc,%esp
80103b85:	56                   	push   %esi
80103b86:	e8 3e 02 00 00       	call   80103dc9 <release>
}
80103b8b:	83 c4 10             	add    $0x10,%esp
80103b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b91:	5b                   	pop    %ebx
80103b92:	5e                   	pop    %esi
80103b93:	5d                   	pop    %ebp
80103b94:	c3                   	ret    

80103b95 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b95:	55                   	push   %ebp
80103b96:	89 e5                	mov    %esp,%ebp
80103b98:	56                   	push   %esi
80103b99:	53                   	push   %ebx
80103b9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b9d:	8d 73 04             	lea    0x4(%ebx),%esi
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	56                   	push   %esi
80103ba4:	e8 b9 01 00 00       	call   80103d62 <acquire>
  lk->locked = 0;
80103ba9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103baf:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103bb6:	89 1c 24             	mov    %ebx,(%esp)
80103bb9:	e8 a2 fd ff ff       	call   80103960 <wakeup>
  release(&lk->lk);
80103bbe:	89 34 24             	mov    %esi,(%esp)
80103bc1:	e8 03 02 00 00       	call   80103dc9 <release>
}
80103bc6:	83 c4 10             	add    $0x10,%esp
80103bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bcc:	5b                   	pop    %ebx
80103bcd:	5e                   	pop    %esi
80103bce:	5d                   	pop    %ebp
80103bcf:	c3                   	ret    

80103bd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 18             	sub    $0x18,%esp
80103bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103bdc:	8d 73 04             	lea    0x4(%ebx),%esi
80103bdf:	56                   	push   %esi
80103be0:	e8 7d 01 00 00       	call   80103d62 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	bf 00 00 00 00       	mov    $0x0,%edi
80103bed:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bf0:	75 13                	jne    80103c05 <holdingsleep+0x35>
  release(&lk->lk);
80103bf2:	83 ec 0c             	sub    $0xc,%esp
80103bf5:	56                   	push   %esi
80103bf6:	e8 ce 01 00 00       	call   80103dc9 <release>
  return r;
}
80103bfb:	89 f8                	mov    %edi,%eax
80103bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103c05:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103c08:	e8 27 f7 ff ff       	call   80103334 <myproc>
80103c0d:	39 58 10             	cmp    %ebx,0x10(%eax)
80103c10:	0f 94 c0             	sete   %al
80103c13:	0f b6 c0             	movzbl %al,%eax
80103c16:	89 c7                	mov    %eax,%edi
80103c18:	eb d8                	jmp    80103bf2 <holdingsleep+0x22>

80103c1a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c1a:	55                   	push   %ebp
80103c1b:	89 e5                	mov    %esp,%ebp
80103c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c20:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c23:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    

80103c35 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
80103c38:	53                   	push   %ebx
80103c39:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c3f:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103c45:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103c4b:	77 2d                	ja     80103c7a <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c4d:	8b 50 fc             	mov    -0x4(%eax),%edx
80103c50:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c52:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c55:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c5a:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c60:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c66:	77 17                	ja     80103c7f <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
80103c68:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c6b:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c6e:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c70:	83 c0 01             	add    $0x1,%eax
80103c73:	83 f8 0a             	cmp    $0xa,%eax
80103c76:	75 e2                	jne    80103c5a <getcallerpcs+0x25>
80103c78:	eb 14                	jmp    80103c8e <getcallerpcs+0x59>
80103c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103c7f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c86:	83 c0 01             	add    $0x1,%eax
80103c89:	83 f8 09             	cmp    $0x9,%eax
80103c8c:	7e f1                	jle    80103c7f <getcallerpcs+0x4a>
}
80103c8e:	5b                   	pop    %ebx
80103c8f:	5d                   	pop    %ebp
80103c90:	c3                   	ret    

80103c91 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c91:	55                   	push   %ebp
80103c92:	89 e5                	mov    %esp,%ebp
80103c94:	53                   	push   %ebx
80103c95:	83 ec 04             	sub    $0x4,%esp
80103c98:	9c                   	pushf  
80103c99:	5b                   	pop    %ebx
  asm volatile("cli");
80103c9a:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c9b:	e8 02 f6 ff ff       	call   801032a2 <mycpu>
80103ca0:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103ca7:	74 12                	je     80103cbb <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103ca9:	e8 f4 f5 ff ff       	call   801032a2 <mycpu>
80103cae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103cb5:	83 c4 04             	add    $0x4,%esp
80103cb8:	5b                   	pop    %ebx
80103cb9:	5d                   	pop    %ebp
80103cba:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103cbb:	e8 e2 f5 ff ff       	call   801032a2 <mycpu>
80103cc0:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103cc6:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103ccc:	eb db                	jmp    80103ca9 <pushcli+0x18>

80103cce <popcli>:

void
popcli(void)
{
80103cce:	55                   	push   %ebp
80103ccf:	89 e5                	mov    %esp,%ebp
80103cd1:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cd4:	9c                   	pushf  
80103cd5:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cd6:	f6 c4 02             	test   $0x2,%ah
80103cd9:	75 28                	jne    80103d03 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103cdb:	e8 c2 f5 ff ff       	call   801032a2 <mycpu>
80103ce0:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103ce6:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103ce9:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103cef:	85 d2                	test   %edx,%edx
80103cf1:	78 1d                	js     80103d10 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cf3:	e8 aa f5 ff ff       	call   801032a2 <mycpu>
80103cf8:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cff:	74 1c                	je     80103d1d <popcli+0x4f>
    sti();
}
80103d01:	c9                   	leave  
80103d02:	c3                   	ret    
    panic("popcli - interruptible");
80103d03:	83 ec 0c             	sub    $0xc,%esp
80103d06:	68 03 6c 10 80       	push   $0x80106c03
80103d0b:	e8 34 c6 ff ff       	call   80100344 <panic>
    panic("popcli");
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	68 1a 6c 10 80       	push   $0x80106c1a
80103d18:	e8 27 c6 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d1d:	e8 80 f5 ff ff       	call   801032a2 <mycpu>
80103d22:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d29:	74 d6                	je     80103d01 <popcli+0x33>
  asm volatile("sti");
80103d2b:	fb                   	sti    
}
80103d2c:	eb d3                	jmp    80103d01 <popcli+0x33>

80103d2e <holding>:
{
80103d2e:	55                   	push   %ebp
80103d2f:	89 e5                	mov    %esp,%ebp
80103d31:	56                   	push   %esi
80103d32:	53                   	push   %ebx
80103d33:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d36:	e8 56 ff ff ff       	call   80103c91 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d40:	83 3e 00             	cmpl   $0x0,(%esi)
80103d43:	75 0b                	jne    80103d50 <holding+0x22>
  popcli();
80103d45:	e8 84 ff ff ff       	call   80103cce <popcli>
}
80103d4a:	89 d8                	mov    %ebx,%eax
80103d4c:	5b                   	pop    %ebx
80103d4d:	5e                   	pop    %esi
80103d4e:	5d                   	pop    %ebp
80103d4f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103d50:	8b 5e 08             	mov    0x8(%esi),%ebx
80103d53:	e8 4a f5 ff ff       	call   801032a2 <mycpu>
80103d58:	39 c3                	cmp    %eax,%ebx
80103d5a:	0f 94 c3             	sete   %bl
80103d5d:	0f b6 db             	movzbl %bl,%ebx
80103d60:	eb e3                	jmp    80103d45 <holding+0x17>

80103d62 <acquire>:
{
80103d62:	55                   	push   %ebp
80103d63:	89 e5                	mov    %esp,%ebp
80103d65:	53                   	push   %ebx
80103d66:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103d69:	e8 23 ff ff ff       	call   80103c91 <pushcli>
  if(holding(lk))
80103d6e:	83 ec 0c             	sub    $0xc,%esp
80103d71:	ff 75 08             	pushl  0x8(%ebp)
80103d74:	e8 b5 ff ff ff       	call   80103d2e <holding>
80103d79:	83 c4 10             	add    $0x10,%esp
80103d7c:	85 c0                	test   %eax,%eax
80103d7e:	75 3c                	jne    80103dbc <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
80103d80:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103d85:	8b 55 08             	mov    0x8(%ebp),%edx
80103d88:	89 c8                	mov    %ecx,%eax
80103d8a:	f0 87 02             	lock xchg %eax,(%edx)
80103d8d:	85 c0                	test   %eax,%eax
80103d8f:	75 f4                	jne    80103d85 <acquire+0x23>
  __sync_synchronize();
80103d91:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d96:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d99:	e8 04 f5 ff ff       	call   801032a2 <mycpu>
80103d9e:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103da1:	83 ec 08             	sub    $0x8,%esp
80103da4:	8b 45 08             	mov    0x8(%ebp),%eax
80103da7:	83 c0 0c             	add    $0xc,%eax
80103daa:	50                   	push   %eax
80103dab:	8d 45 08             	lea    0x8(%ebp),%eax
80103dae:	50                   	push   %eax
80103daf:	e8 81 fe ff ff       	call   80103c35 <getcallerpcs>
}
80103db4:	83 c4 10             	add    $0x10,%esp
80103db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dba:	c9                   	leave  
80103dbb:	c3                   	ret    
    panic("acquire");
80103dbc:	83 ec 0c             	sub    $0xc,%esp
80103dbf:	68 21 6c 10 80       	push   $0x80106c21
80103dc4:	e8 7b c5 ff ff       	call   80100344 <panic>

80103dc9 <release>:
{
80103dc9:	55                   	push   %ebp
80103dca:	89 e5                	mov    %esp,%ebp
80103dcc:	53                   	push   %ebx
80103dcd:	83 ec 10             	sub    $0x10,%esp
80103dd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103dd3:	53                   	push   %ebx
80103dd4:	e8 55 ff ff ff       	call   80103d2e <holding>
80103dd9:	83 c4 10             	add    $0x10,%esp
80103ddc:	85 c0                	test   %eax,%eax
80103dde:	74 23                	je     80103e03 <release+0x3a>
  lk->pcs[0] = 0;
80103de0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103de7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103dee:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103df3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103df9:	e8 d0 fe ff ff       	call   80103cce <popcli>
}
80103dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e01:	c9                   	leave  
80103e02:	c3                   	ret    
    panic("release");
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	68 29 6c 10 80       	push   $0x80106c29
80103e0b:	e8 34 c5 ff ff       	call   80100344 <panic>

80103e10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	53                   	push   %ebx
80103e15:	8b 55 08             	mov    0x8(%ebp),%edx
80103e18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103e1b:	f6 c2 03             	test   $0x3,%dl
80103e1e:	75 05                	jne    80103e25 <memset+0x15>
80103e20:	f6 c1 03             	test   $0x3,%cl
80103e23:	74 0e                	je     80103e33 <memset+0x23>
  asm volatile("cld; rep stosb" :
80103e25:	89 d7                	mov    %edx,%edi
80103e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e2a:	fc                   	cld    
80103e2b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103e2d:	89 d0                	mov    %edx,%eax
80103e2f:	5b                   	pop    %ebx
80103e30:	5f                   	pop    %edi
80103e31:	5d                   	pop    %ebp
80103e32:	c3                   	ret    
    c &= 0xFF;
80103e33:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103e37:	c1 e9 02             	shr    $0x2,%ecx
80103e3a:	89 f8                	mov    %edi,%eax
80103e3c:	c1 e0 18             	shl    $0x18,%eax
80103e3f:	89 fb                	mov    %edi,%ebx
80103e41:	c1 e3 10             	shl    $0x10,%ebx
80103e44:	09 d8                	or     %ebx,%eax
80103e46:	09 f8                	or     %edi,%eax
80103e48:	c1 e7 08             	shl    $0x8,%edi
80103e4b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e4d:	89 d7                	mov    %edx,%edi
80103e4f:	fc                   	cld    
80103e50:	f3 ab                	rep stos %eax,%es:(%edi)
80103e52:	eb d9                	jmp    80103e2d <memset+0x1d>

80103e54 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	57                   	push   %edi
80103e58:	56                   	push   %esi
80103e59:	53                   	push   %ebx
80103e5a:	8b 75 08             	mov    0x8(%ebp),%esi
80103e5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103e60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103e63:	85 db                	test   %ebx,%ebx
80103e65:	74 37                	je     80103e9e <memcmp+0x4a>
    if(*s1 != *s2)
80103e67:	0f b6 16             	movzbl (%esi),%edx
80103e6a:	0f b6 0f             	movzbl (%edi),%ecx
80103e6d:	38 ca                	cmp    %cl,%dl
80103e6f:	75 19                	jne    80103e8a <memcmp+0x36>
80103e71:	b8 01 00 00 00       	mov    $0x1,%eax
  while(n-- > 0){
80103e76:	39 d8                	cmp    %ebx,%eax
80103e78:	74 1d                	je     80103e97 <memcmp+0x43>
    if(*s1 != *s2)
80103e7a:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80103e7e:	83 c0 01             	add    $0x1,%eax
80103e81:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80103e86:	38 ca                	cmp    %cl,%dl
80103e88:	74 ec                	je     80103e76 <memcmp+0x22>
      return *s1 - *s2;
80103e8a:	0f b6 c2             	movzbl %dl,%eax
80103e8d:	0f b6 c9             	movzbl %cl,%ecx
80103e90:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80103e92:	5b                   	pop    %ebx
80103e93:	5e                   	pop    %esi
80103e94:	5f                   	pop    %edi
80103e95:	5d                   	pop    %ebp
80103e96:	c3                   	ret    
  return 0;
80103e97:	b8 00 00 00 00       	mov    $0x0,%eax
80103e9c:	eb f4                	jmp    80103e92 <memcmp+0x3e>
80103e9e:	b8 00 00 00 00       	mov    $0x0,%eax
80103ea3:	eb ed                	jmp    80103e92 <memcmp+0x3e>

80103ea5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103ea5:	55                   	push   %ebp
80103ea6:	89 e5                	mov    %esp,%ebp
80103ea8:	56                   	push   %esi
80103ea9:	53                   	push   %ebx
80103eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80103ead:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103eb0:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103eb3:	39 c3                	cmp    %eax,%ebx
80103eb5:	72 1b                	jb     80103ed2 <memmove+0x2d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80103eb7:	ba 00 00 00 00       	mov    $0x0,%edx
80103ebc:	85 f6                	test   %esi,%esi
80103ebe:	74 0e                	je     80103ece <memmove+0x29>
      *d++ = *s++;
80103ec0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103ec4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80103ec7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80103eca:	39 d6                	cmp    %edx,%esi
80103ecc:	75 f2                	jne    80103ec0 <memmove+0x1b>

  return dst;
}
80103ece:	5b                   	pop    %ebx
80103ecf:	5e                   	pop    %esi
80103ed0:	5d                   	pop    %ebp
80103ed1:	c3                   	ret    
  if(s < d && s + n > d){
80103ed2:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80103ed5:	39 d0                	cmp    %edx,%eax
80103ed7:	73 de                	jae    80103eb7 <memmove+0x12>
    while(n-- > 0)
80103ed9:	8d 56 ff             	lea    -0x1(%esi),%edx
80103edc:	85 f6                	test   %esi,%esi
80103ede:	74 ee                	je     80103ece <memmove+0x29>
      *--d = *--s;
80103ee0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103ee4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80103ee7:	83 ea 01             	sub    $0x1,%edx
80103eea:	83 fa ff             	cmp    $0xffffffff,%edx
80103eed:	75 f1                	jne    80103ee0 <memmove+0x3b>
80103eef:	eb dd                	jmp    80103ece <memmove+0x29>

80103ef1 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103ef1:	55                   	push   %ebp
80103ef2:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80103ef4:	ff 75 10             	pushl  0x10(%ebp)
80103ef7:	ff 75 0c             	pushl  0xc(%ebp)
80103efa:	ff 75 08             	pushl  0x8(%ebp)
80103efd:	e8 a3 ff ff ff       	call   80103ea5 <memmove>
}
80103f02:	c9                   	leave  
80103f03:	c3                   	ret    

80103f04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	53                   	push   %ebx
80103f08:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80103f11:	85 db                	test   %ebx,%ebx
80103f13:	74 2d                	je     80103f42 <strncmp+0x3e>
80103f15:	0f b6 08             	movzbl (%eax),%ecx
80103f18:	84 c9                	test   %cl,%cl
80103f1a:	74 1b                	je     80103f37 <strncmp+0x33>
80103f1c:	3a 0a                	cmp    (%edx),%cl
80103f1e:	75 17                	jne    80103f37 <strncmp+0x33>
80103f20:	01 c3                	add    %eax,%ebx
    n--, p++, q++;
80103f22:	83 c0 01             	add    $0x1,%eax
80103f25:	83 c2 01             	add    $0x1,%edx
  while(n > 0 && *p && *p == *q)
80103f28:	39 d8                	cmp    %ebx,%eax
80103f2a:	74 1d                	je     80103f49 <strncmp+0x45>
80103f2c:	0f b6 08             	movzbl (%eax),%ecx
80103f2f:	84 c9                	test   %cl,%cl
80103f31:	74 04                	je     80103f37 <strncmp+0x33>
80103f33:	3a 0a                	cmp    (%edx),%cl
80103f35:	74 eb                	je     80103f22 <strncmp+0x1e>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80103f37:	0f b6 00             	movzbl (%eax),%eax
80103f3a:	0f b6 12             	movzbl (%edx),%edx
80103f3d:	29 d0                	sub    %edx,%eax
}
80103f3f:	5b                   	pop    %ebx
80103f40:	5d                   	pop    %ebp
80103f41:	c3                   	ret    
    return 0;
80103f42:	b8 00 00 00 00       	mov    $0x0,%eax
80103f47:	eb f6                	jmp    80103f3f <strncmp+0x3b>
80103f49:	b8 00 00 00 00       	mov    $0x0,%eax
80103f4e:	eb ef                	jmp    80103f3f <strncmp+0x3b>

80103f50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f5c:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f5f:	89 f9                	mov    %edi,%ecx
80103f61:	eb 02                	jmp    80103f65 <strncpy+0x15>
80103f63:	89 f2                	mov    %esi,%edx
80103f65:	8d 72 ff             	lea    -0x1(%edx),%esi
80103f68:	85 d2                	test   %edx,%edx
80103f6a:	7e 11                	jle    80103f7d <strncpy+0x2d>
80103f6c:	83 c3 01             	add    $0x1,%ebx
80103f6f:	83 c1 01             	add    $0x1,%ecx
80103f72:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80103f76:	88 41 ff             	mov    %al,-0x1(%ecx)
80103f79:	84 c0                	test   %al,%al
80103f7b:	75 e6                	jne    80103f63 <strncpy+0x13>
    ;
  while(n-- > 0)
80103f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103f82:	83 ea 01             	sub    $0x1,%edx
80103f85:	85 f6                	test   %esi,%esi
80103f87:	7e 0f                	jle    80103f98 <strncpy+0x48>
    *s++ = 0;
80103f89:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
80103f8d:	83 c3 01             	add    $0x1,%ebx
80103f90:	89 d6                	mov    %edx,%esi
80103f92:	29 de                	sub    %ebx,%esi
  while(n-- > 0)
80103f94:	85 f6                	test   %esi,%esi
80103f96:	7f f1                	jg     80103f89 <strncpy+0x39>
  return os;
}
80103f98:	89 f8                	mov    %edi,%eax
80103f9a:	5b                   	pop    %ebx
80103f9b:	5e                   	pop    %esi
80103f9c:	5f                   	pop    %edi
80103f9d:	5d                   	pop    %ebp
80103f9e:	c3                   	ret    

80103f9f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f9f:	55                   	push   %ebp
80103fa0:	89 e5                	mov    %esp,%ebp
80103fa2:	56                   	push   %esi
80103fa3:	53                   	push   %ebx
80103fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
80103faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80103fad:	85 c9                	test   %ecx,%ecx
80103faf:	7e 1e                	jle    80103fcf <safestrcpy+0x30>
80103fb1:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80103fb5:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103fb7:	39 f2                	cmp    %esi,%edx
80103fb9:	74 11                	je     80103fcc <safestrcpy+0x2d>
80103fbb:	83 c2 01             	add    $0x1,%edx
80103fbe:	83 c1 01             	add    $0x1,%ecx
80103fc1:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80103fc5:	88 59 ff             	mov    %bl,-0x1(%ecx)
80103fc8:	84 db                	test   %bl,%bl
80103fca:	75 eb                	jne    80103fb7 <safestrcpy+0x18>
    ;
  *s = 0;
80103fcc:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103fcf:	5b                   	pop    %ebx
80103fd0:	5e                   	pop    %esi
80103fd1:	5d                   	pop    %ebp
80103fd2:	c3                   	ret    

80103fd3 <strlen>:

int
strlen(const char *s)
{
80103fd3:	55                   	push   %ebp
80103fd4:	89 e5                	mov    %esp,%ebp
80103fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103fd9:	80 3a 00             	cmpb   $0x0,(%edx)
80103fdc:	74 10                	je     80103fee <strlen+0x1b>
80103fde:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe3:	83 c0 01             	add    $0x1,%eax
80103fe6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103fea:	75 f7                	jne    80103fe3 <strlen+0x10>
    ;
  return n;
}
80103fec:	5d                   	pop    %ebp
80103fed:	c3                   	ret    
  for(n = 0; s[n]; n++)
80103fee:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80103ff3:	eb f7                	jmp    80103fec <strlen+0x19>

80103ff5 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103ff5:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103ff9:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103ffd:	55                   	push   %ebp
  pushl %ebx
80103ffe:	53                   	push   %ebx
  pushl %esi
80103fff:	56                   	push   %esi
  pushl %edi
80104000:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104001:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104003:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104005:	5f                   	pop    %edi
  popl %esi
80104006:	5e                   	pop    %esi
  popl %ebx
80104007:	5b                   	pop    %ebx
  popl %ebp
80104008:	5d                   	pop    %ebp
  ret
80104009:	c3                   	ret    

8010400a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010400a:	55                   	push   %ebp
8010400b:	89 e5                	mov    %esp,%ebp
8010400d:	53                   	push   %ebx
8010400e:	83 ec 04             	sub    $0x4,%esp
80104011:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104014:	e8 1b f3 ff ff       	call   80103334 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104019:	8b 00                	mov    (%eax),%eax
8010401b:	39 d8                	cmp    %ebx,%eax
8010401d:	76 19                	jbe    80104038 <fetchint+0x2e>
8010401f:	8d 53 04             	lea    0x4(%ebx),%edx
80104022:	39 d0                	cmp    %edx,%eax
80104024:	72 19                	jb     8010403f <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
80104026:	8b 13                	mov    (%ebx),%edx
80104028:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402b:	89 10                	mov    %edx,(%eax)
  return 0;
8010402d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104032:	83 c4 04             	add    $0x4,%esp
80104035:	5b                   	pop    %ebx
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
    return -1;
80104038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010403d:	eb f3                	jmp    80104032 <fetchint+0x28>
8010403f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104044:	eb ec                	jmp    80104032 <fetchint+0x28>

80104046 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104046:	55                   	push   %ebp
80104047:	89 e5                	mov    %esp,%ebp
80104049:	53                   	push   %ebx
8010404a:	83 ec 04             	sub    $0x4,%esp
8010404d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104050:	e8 df f2 ff ff       	call   80103334 <myproc>

  if(addr >= curproc->sz)
80104055:	39 18                	cmp    %ebx,(%eax)
80104057:	76 2f                	jbe    80104088 <fetchstr+0x42>
    return -1;
  *pp = (char*)addr;
80104059:	89 da                	mov    %ebx,%edx
8010405b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010405e:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104060:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104062:	39 c3                	cmp    %eax,%ebx
80104064:	73 29                	jae    8010408f <fetchstr+0x49>
    if(*s == 0)
80104066:	80 3b 00             	cmpb   $0x0,(%ebx)
80104069:	74 0c                	je     80104077 <fetchstr+0x31>
  for(s = *pp; s < ep; s++){
8010406b:	83 c2 01             	add    $0x1,%edx
8010406e:	39 d0                	cmp    %edx,%eax
80104070:	76 0f                	jbe    80104081 <fetchstr+0x3b>
    if(*s == 0)
80104072:	80 3a 00             	cmpb   $0x0,(%edx)
80104075:	75 f4                	jne    8010406b <fetchstr+0x25>
      return s - *pp;
80104077:	89 d0                	mov    %edx,%eax
80104079:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
8010407b:	83 c4 04             	add    $0x4,%esp
8010407e:	5b                   	pop    %ebx
8010407f:	5d                   	pop    %ebp
80104080:	c3                   	ret    
  return -1;
80104081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104086:	eb f3                	jmp    8010407b <fetchstr+0x35>
    return -1;
80104088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010408d:	eb ec                	jmp    8010407b <fetchstr+0x35>
  return -1;
8010408f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104094:	eb e5                	jmp    8010407b <fetchstr+0x35>

80104096 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104096:	55                   	push   %ebp
80104097:	89 e5                	mov    %esp,%ebp
80104099:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010409c:	e8 93 f2 ff ff       	call   80103334 <myproc>
801040a1:	83 ec 08             	sub    $0x8,%esp
801040a4:	ff 75 0c             	pushl  0xc(%ebp)
801040a7:	8b 40 18             	mov    0x18(%eax),%eax
801040aa:	8b 40 44             	mov    0x44(%eax),%eax
801040ad:	8b 55 08             	mov    0x8(%ebp),%edx
801040b0:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
801040b4:	50                   	push   %eax
801040b5:	e8 50 ff ff ff       	call   8010400a <fetchint>
}
801040ba:	c9                   	leave  
801040bb:	c3                   	ret    

801040bc <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801040bc:	55                   	push   %ebp
801040bd:	89 e5                	mov    %esp,%ebp
801040bf:	56                   	push   %esi
801040c0:	53                   	push   %ebx
801040c1:	83 ec 10             	sub    $0x10,%esp
801040c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801040c7:	e8 68 f2 ff ff       	call   80103334 <myproc>
801040cc:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801040ce:	83 ec 08             	sub    $0x8,%esp
801040d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801040d4:	50                   	push   %eax
801040d5:	ff 75 08             	pushl  0x8(%ebp)
801040d8:	e8 b9 ff ff ff       	call   80104096 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801040dd:	83 c4 10             	add    $0x10,%esp
801040e0:	85 db                	test   %ebx,%ebx
801040e2:	78 24                	js     80104108 <argptr+0x4c>
801040e4:	85 c0                	test   %eax,%eax
801040e6:	78 20                	js     80104108 <argptr+0x4c>
801040e8:	8b 16                	mov    (%esi),%edx
801040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ed:	39 c2                	cmp    %eax,%edx
801040ef:	76 1e                	jbe    8010410f <argptr+0x53>
801040f1:	01 c3                	add    %eax,%ebx
801040f3:	39 da                	cmp    %ebx,%edx
801040f5:	72 1f                	jb     80104116 <argptr+0x5a>
    return -1;
  *pp = (char*)i;
801040f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801040fa:	89 02                	mov    %eax,(%edx)
  return 0;
801040fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104101:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104104:	5b                   	pop    %ebx
80104105:	5e                   	pop    %esi
80104106:	5d                   	pop    %ebp
80104107:	c3                   	ret    
    return -1;
80104108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010410d:	eb f2                	jmp    80104101 <argptr+0x45>
8010410f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104114:	eb eb                	jmp    80104101 <argptr+0x45>
80104116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010411b:	eb e4                	jmp    80104101 <argptr+0x45>

8010411d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010411d:	55                   	push   %ebp
8010411e:	89 e5                	mov    %esp,%ebp
80104120:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104123:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104126:	50                   	push   %eax
80104127:	ff 75 08             	pushl  0x8(%ebp)
8010412a:	e8 67 ff ff ff       	call   80104096 <argint>
8010412f:	83 c4 10             	add    $0x10,%esp
80104132:	85 c0                	test   %eax,%eax
80104134:	78 13                	js     80104149 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104136:	83 ec 08             	sub    $0x8,%esp
80104139:	ff 75 0c             	pushl  0xc(%ebp)
8010413c:	ff 75 f4             	pushl  -0xc(%ebp)
8010413f:	e8 02 ff ff ff       	call   80104046 <fetchstr>
80104144:	83 c4 10             	add    $0x10,%esp
}
80104147:	c9                   	leave  
80104148:	c3                   	ret    
    return -1;
80104149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010414e:	eb f7                	jmp    80104147 <argstr+0x2a>

80104150 <syscall>:
[SYS_getlevel] sys_getlevel,
};

void
syscall(void)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104157:	e8 d8 f1 ff ff       	call   80103334 <myproc>
8010415c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010415e:	8b 40 18             	mov    0x18(%eax),%eax
80104161:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104164:	8d 50 ff             	lea    -0x1(%eax),%edx
80104167:	83 fa 15             	cmp    $0x15,%edx
8010416a:	77 18                	ja     80104184 <syscall+0x34>
8010416c:	8b 14 85 60 6c 10 80 	mov    -0x7fef93a0(,%eax,4),%edx
80104173:	85 d2                	test   %edx,%edx
80104175:	74 0d                	je     80104184 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104177:	ff d2                	call   *%edx
80104179:	8b 53 18             	mov    0x18(%ebx),%edx
8010417c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010417f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104182:	c9                   	leave  
80104183:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
80104184:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104185:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104188:	50                   	push   %eax
80104189:	ff 73 10             	pushl  0x10(%ebx)
8010418c:	68 31 6c 10 80       	push   $0x80106c31
80104191:	e8 4b c4 ff ff       	call   801005e1 <cprintf>
    curproc->tf->eax = -1;
80104196:	8b 43 18             	mov    0x18(%ebx),%eax
80104199:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801041a0:	83 c4 10             	add    $0x10,%esp
}
801041a3:	eb da                	jmp    8010417f <syscall+0x2f>

801041a5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801041a5:	55                   	push   %ebp
801041a6:	89 e5                	mov    %esp,%ebp
801041a8:	56                   	push   %esi
801041a9:	53                   	push   %ebx
801041aa:	83 ec 18             	sub    $0x18,%esp
801041ad:	89 d6                	mov    %edx,%esi
801041af:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801041b1:	8d 55 f4             	lea    -0xc(%ebp),%edx
801041b4:	52                   	push   %edx
801041b5:	50                   	push   %eax
801041b6:	e8 db fe ff ff       	call   80104096 <argint>
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	85 c0                	test   %eax,%eax
801041c0:	78 2e                	js     801041f0 <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801041c2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801041c6:	77 2f                	ja     801041f7 <argfd+0x52>
801041c8:	e8 67 f1 ff ff       	call   80103334 <myproc>
801041cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801041d0:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
801041d4:	85 d2                	test   %edx,%edx
801041d6:	74 26                	je     801041fe <argfd+0x59>
    return -1;
  if(pfd)
801041d8:	85 f6                	test   %esi,%esi
801041da:	74 02                	je     801041de <argfd+0x39>
    *pfd = fd;
801041dc:	89 0e                	mov    %ecx,(%esi)
  if(pf)
    *pf = f;
  return 0;
801041de:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
801041e3:	85 db                	test   %ebx,%ebx
801041e5:	74 02                	je     801041e9 <argfd+0x44>
    *pf = f;
801041e7:	89 13                	mov    %edx,(%ebx)
}
801041e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ec:	5b                   	pop    %ebx
801041ed:	5e                   	pop    %esi
801041ee:	5d                   	pop    %ebp
801041ef:	c3                   	ret    
    return -1;
801041f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041f5:	eb f2                	jmp    801041e9 <argfd+0x44>
    return -1;
801041f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041fc:	eb eb                	jmp    801041e9 <argfd+0x44>
801041fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104203:	eb e4                	jmp    801041e9 <argfd+0x44>

80104205 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104205:	55                   	push   %ebp
80104206:	89 e5                	mov    %esp,%ebp
80104208:	53                   	push   %ebx
80104209:	83 ec 04             	sub    $0x4,%esp
8010420c:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010420e:	e8 21 f1 ff ff       	call   80103334 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104213:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
80104217:	74 1b                	je     80104234 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104219:	ba 01 00 00 00       	mov    $0x1,%edx
    if(curproc->ofile[fd] == 0){
8010421e:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
80104223:	74 14                	je     80104239 <fdalloc+0x34>
  for(fd = 0; fd < NOFILE; fd++){
80104225:	83 c2 01             	add    $0x1,%edx
80104228:	83 fa 10             	cmp    $0x10,%edx
8010422b:	75 f1                	jne    8010421e <fdalloc+0x19>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010422d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104232:	eb 09                	jmp    8010423d <fdalloc+0x38>
  for(fd = 0; fd < NOFILE; fd++){
80104234:	ba 00 00 00 00       	mov    $0x0,%edx
      curproc->ofile[fd] = f;
80104239:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
8010423d:	89 d0                	mov    %edx,%eax
8010423f:	83 c4 04             	add    $0x4,%esp
80104242:	5b                   	pop    %ebx
80104243:	5d                   	pop    %ebp
80104244:	c3                   	ret    

80104245 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104245:	55                   	push   %ebp
80104246:	89 e5                	mov    %esp,%ebp
80104248:	57                   	push   %edi
80104249:	56                   	push   %esi
8010424a:	53                   	push   %ebx
8010424b:	83 ec 34             	sub    $0x34,%esp
8010424e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104251:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104254:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104257:	8d 55 da             	lea    -0x26(%ebp),%edx
8010425a:	52                   	push   %edx
8010425b:	50                   	push   %eax
8010425c:	e8 3a da ff ff       	call   80101c9b <nameiparent>
80104261:	89 c6                	mov    %eax,%esi
80104263:	83 c4 10             	add    $0x10,%esp
80104266:	85 c0                	test   %eax,%eax
80104268:	0f 84 32 01 00 00    	je     801043a0 <create+0x15b>
    return 0;
  ilock(dp);
8010426e:	83 ec 0c             	sub    $0xc,%esp
80104271:	50                   	push   %eax
80104272:	e8 6f d2 ff ff       	call   801014e6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104277:	83 c4 0c             	add    $0xc,%esp
8010427a:	6a 00                	push   $0x0
8010427c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010427f:	50                   	push   %eax
80104280:	56                   	push   %esi
80104281:	e8 26 d7 ff ff       	call   801019ac <dirlookup>
80104286:	89 c3                	mov    %eax,%ebx
80104288:	83 c4 10             	add    $0x10,%esp
8010428b:	85 c0                	test   %eax,%eax
8010428d:	74 3f                	je     801042ce <create+0x89>
    iunlockput(dp);
8010428f:	83 ec 0c             	sub    $0xc,%esp
80104292:	56                   	push   %esi
80104293:	e8 97 d4 ff ff       	call   8010172f <iunlockput>
    ilock(ip);
80104298:	89 1c 24             	mov    %ebx,(%esp)
8010429b:	e8 46 d2 ff ff       	call   801014e6 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801042a8:	75 11                	jne    801042bb <create+0x76>
801042aa:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801042af:	75 0a                	jne    801042bb <create+0x76>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042b1:	89 d8                	mov    %ebx,%eax
801042b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b6:	5b                   	pop    %ebx
801042b7:	5e                   	pop    %esi
801042b8:	5f                   	pop    %edi
801042b9:	5d                   	pop    %ebp
801042ba:	c3                   	ret    
    iunlockput(ip);
801042bb:	83 ec 0c             	sub    $0xc,%esp
801042be:	53                   	push   %ebx
801042bf:	e8 6b d4 ff ff       	call   8010172f <iunlockput>
    return 0;
801042c4:	83 c4 10             	add    $0x10,%esp
801042c7:	bb 00 00 00 00       	mov    $0x0,%ebx
801042cc:	eb e3                	jmp    801042b1 <create+0x6c>
  if((ip = ialloc(dp->dev, type)) == 0)
801042ce:	83 ec 08             	sub    $0x8,%esp
801042d1:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801042d5:	50                   	push   %eax
801042d6:	ff 36                	pushl  (%esi)
801042d8:	e8 b6 d0 ff ff       	call   80101393 <ialloc>
801042dd:	89 c3                	mov    %eax,%ebx
801042df:	83 c4 10             	add    $0x10,%esp
801042e2:	85 c0                	test   %eax,%eax
801042e4:	74 55                	je     8010433b <create+0xf6>
  ilock(ip);
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	50                   	push   %eax
801042ea:	e8 f7 d1 ff ff       	call   801014e6 <ilock>
  ip->major = major;
801042ef:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801042f3:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801042f7:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801042fb:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104301:	89 1c 24             	mov    %ebx,(%esp)
80104304:	e8 33 d1 ff ff       	call   8010143c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104309:	83 c4 10             	add    $0x10,%esp
8010430c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104311:	74 35                	je     80104348 <create+0x103>
  if(dirlink(dp, name, ip->inum) < 0)
80104313:	83 ec 04             	sub    $0x4,%esp
80104316:	ff 73 04             	pushl  0x4(%ebx)
80104319:	8d 45 da             	lea    -0x26(%ebp),%eax
8010431c:	50                   	push   %eax
8010431d:	56                   	push   %esi
8010431e:	e8 ab d8 ff ff       	call   80101bce <dirlink>
80104323:	83 c4 10             	add    $0x10,%esp
80104326:	85 c0                	test   %eax,%eax
80104328:	78 69                	js     80104393 <create+0x14e>
  iunlockput(dp);
8010432a:	83 ec 0c             	sub    $0xc,%esp
8010432d:	56                   	push   %esi
8010432e:	e8 fc d3 ff ff       	call   8010172f <iunlockput>
  return ip;
80104333:	83 c4 10             	add    $0x10,%esp
80104336:	e9 76 ff ff ff       	jmp    801042b1 <create+0x6c>
    panic("create: ialloc");
8010433b:	83 ec 0c             	sub    $0xc,%esp
8010433e:	68 bc 6c 10 80       	push   $0x80106cbc
80104343:	e8 fc bf ff ff       	call   80100344 <panic>
    dp->nlink++;  // for ".."
80104348:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	56                   	push   %esi
80104351:	e8 e6 d0 ff ff       	call   8010143c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104356:	83 c4 0c             	add    $0xc,%esp
80104359:	ff 73 04             	pushl  0x4(%ebx)
8010435c:	68 cc 6c 10 80       	push   $0x80106ccc
80104361:	53                   	push   %ebx
80104362:	e8 67 d8 ff ff       	call   80101bce <dirlink>
80104367:	83 c4 10             	add    $0x10,%esp
8010436a:	85 c0                	test   %eax,%eax
8010436c:	78 18                	js     80104386 <create+0x141>
8010436e:	83 ec 04             	sub    $0x4,%esp
80104371:	ff 76 04             	pushl  0x4(%esi)
80104374:	68 cb 6c 10 80       	push   $0x80106ccb
80104379:	53                   	push   %ebx
8010437a:	e8 4f d8 ff ff       	call   80101bce <dirlink>
8010437f:	83 c4 10             	add    $0x10,%esp
80104382:	85 c0                	test   %eax,%eax
80104384:	79 8d                	jns    80104313 <create+0xce>
      panic("create dots");
80104386:	83 ec 0c             	sub    $0xc,%esp
80104389:	68 ce 6c 10 80       	push   $0x80106cce
8010438e:	e8 b1 bf ff ff       	call   80100344 <panic>
    panic("create: dirlink");
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	68 da 6c 10 80       	push   $0x80106cda
8010439b:	e8 a4 bf ff ff       	call   80100344 <panic>
    return 0;
801043a0:	89 c3                	mov    %eax,%ebx
801043a2:	e9 0a ff ff ff       	jmp    801042b1 <create+0x6c>

801043a7 <sys_dup>:
{
801043a7:	55                   	push   %ebp
801043a8:	89 e5                	mov    %esp,%ebp
801043aa:	53                   	push   %ebx
801043ab:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801043ae:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043b1:	ba 00 00 00 00       	mov    $0x0,%edx
801043b6:	b8 00 00 00 00       	mov    $0x0,%eax
801043bb:	e8 e5 fd ff ff       	call   801041a5 <argfd>
801043c0:	85 c0                	test   %eax,%eax
801043c2:	78 23                	js     801043e7 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
801043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c7:	e8 39 fe ff ff       	call   80104205 <fdalloc>
801043cc:	89 c3                	mov    %eax,%ebx
801043ce:	85 c0                	test   %eax,%eax
801043d0:	78 1c                	js     801043ee <sys_dup+0x47>
  filedup(f);
801043d2:	83 ec 0c             	sub    $0xc,%esp
801043d5:	ff 75 f4             	pushl  -0xc(%ebp)
801043d8:	e8 0a c9 ff ff       	call   80100ce7 <filedup>
  return fd;
801043dd:	83 c4 10             	add    $0x10,%esp
}
801043e0:	89 d8                	mov    %ebx,%eax
801043e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e5:	c9                   	leave  
801043e6:	c3                   	ret    
    return -1;
801043e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043ec:	eb f2                	jmp    801043e0 <sys_dup+0x39>
    return -1;
801043ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043f3:	eb eb                	jmp    801043e0 <sys_dup+0x39>

801043f5 <sys_read>:
{
801043f5:	55                   	push   %ebp
801043f6:	89 e5                	mov    %esp,%ebp
801043f8:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043fb:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043fe:	ba 00 00 00 00       	mov    $0x0,%edx
80104403:	b8 00 00 00 00       	mov    $0x0,%eax
80104408:	e8 98 fd ff ff       	call   801041a5 <argfd>
8010440d:	85 c0                	test   %eax,%eax
8010440f:	78 43                	js     80104454 <sys_read+0x5f>
80104411:	83 ec 08             	sub    $0x8,%esp
80104414:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104417:	50                   	push   %eax
80104418:	6a 02                	push   $0x2
8010441a:	e8 77 fc ff ff       	call   80104096 <argint>
8010441f:	83 c4 10             	add    $0x10,%esp
80104422:	85 c0                	test   %eax,%eax
80104424:	78 35                	js     8010445b <sys_read+0x66>
80104426:	83 ec 04             	sub    $0x4,%esp
80104429:	ff 75 f0             	pushl  -0x10(%ebp)
8010442c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010442f:	50                   	push   %eax
80104430:	6a 01                	push   $0x1
80104432:	e8 85 fc ff ff       	call   801040bc <argptr>
80104437:	83 c4 10             	add    $0x10,%esp
8010443a:	85 c0                	test   %eax,%eax
8010443c:	78 24                	js     80104462 <sys_read+0x6d>
  return fileread(f, p, n);
8010443e:	83 ec 04             	sub    $0x4,%esp
80104441:	ff 75 f0             	pushl  -0x10(%ebp)
80104444:	ff 75 ec             	pushl  -0x14(%ebp)
80104447:	ff 75 f4             	pushl  -0xc(%ebp)
8010444a:	e8 d9 c9 ff ff       	call   80100e28 <fileread>
8010444f:	83 c4 10             	add    $0x10,%esp
}
80104452:	c9                   	leave  
80104453:	c3                   	ret    
    return -1;
80104454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104459:	eb f7                	jmp    80104452 <sys_read+0x5d>
8010445b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104460:	eb f0                	jmp    80104452 <sys_read+0x5d>
80104462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104467:	eb e9                	jmp    80104452 <sys_read+0x5d>

80104469 <sys_write>:
{
80104469:	55                   	push   %ebp
8010446a:	89 e5                	mov    %esp,%ebp
8010446c:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010446f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104472:	ba 00 00 00 00       	mov    $0x0,%edx
80104477:	b8 00 00 00 00       	mov    $0x0,%eax
8010447c:	e8 24 fd ff ff       	call   801041a5 <argfd>
80104481:	85 c0                	test   %eax,%eax
80104483:	78 43                	js     801044c8 <sys_write+0x5f>
80104485:	83 ec 08             	sub    $0x8,%esp
80104488:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010448b:	50                   	push   %eax
8010448c:	6a 02                	push   $0x2
8010448e:	e8 03 fc ff ff       	call   80104096 <argint>
80104493:	83 c4 10             	add    $0x10,%esp
80104496:	85 c0                	test   %eax,%eax
80104498:	78 35                	js     801044cf <sys_write+0x66>
8010449a:	83 ec 04             	sub    $0x4,%esp
8010449d:	ff 75 f0             	pushl  -0x10(%ebp)
801044a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044a3:	50                   	push   %eax
801044a4:	6a 01                	push   $0x1
801044a6:	e8 11 fc ff ff       	call   801040bc <argptr>
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	85 c0                	test   %eax,%eax
801044b0:	78 24                	js     801044d6 <sys_write+0x6d>
  return filewrite(f, p, n);
801044b2:	83 ec 04             	sub    $0x4,%esp
801044b5:	ff 75 f0             	pushl  -0x10(%ebp)
801044b8:	ff 75 ec             	pushl  -0x14(%ebp)
801044bb:	ff 75 f4             	pushl  -0xc(%ebp)
801044be:	e8 ea c9 ff ff       	call   80100ead <filewrite>
801044c3:	83 c4 10             	add    $0x10,%esp
}
801044c6:	c9                   	leave  
801044c7:	c3                   	ret    
    return -1;
801044c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044cd:	eb f7                	jmp    801044c6 <sys_write+0x5d>
801044cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d4:	eb f0                	jmp    801044c6 <sys_write+0x5d>
801044d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044db:	eb e9                	jmp    801044c6 <sys_write+0x5d>

801044dd <sys_close>:
{
801044dd:	55                   	push   %ebp
801044de:	89 e5                	mov    %esp,%ebp
801044e0:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801044e3:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044e9:	b8 00 00 00 00       	mov    $0x0,%eax
801044ee:	e8 b2 fc ff ff       	call   801041a5 <argfd>
801044f3:	85 c0                	test   %eax,%eax
801044f5:	78 25                	js     8010451c <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801044f7:	e8 38 ee ff ff       	call   80103334 <myproc>
801044fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ff:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104506:	00 
  fileclose(f);
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	ff 75 f0             	pushl  -0x10(%ebp)
8010450d:	e8 1a c8 ff ff       	call   80100d2c <fileclose>
  return 0;
80104512:	83 c4 10             	add    $0x10,%esp
80104515:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010451a:	c9                   	leave  
8010451b:	c3                   	ret    
    return -1;
8010451c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104521:	eb f7                	jmp    8010451a <sys_close+0x3d>

80104523 <sys_fstat>:
{
80104523:	55                   	push   %ebp
80104524:	89 e5                	mov    %esp,%ebp
80104526:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104529:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010452c:	ba 00 00 00 00       	mov    $0x0,%edx
80104531:	b8 00 00 00 00       	mov    $0x0,%eax
80104536:	e8 6a fc ff ff       	call   801041a5 <argfd>
8010453b:	85 c0                	test   %eax,%eax
8010453d:	78 2a                	js     80104569 <sys_fstat+0x46>
8010453f:	83 ec 04             	sub    $0x4,%esp
80104542:	6a 14                	push   $0x14
80104544:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104547:	50                   	push   %eax
80104548:	6a 01                	push   $0x1
8010454a:	e8 6d fb ff ff       	call   801040bc <argptr>
8010454f:	83 c4 10             	add    $0x10,%esp
80104552:	85 c0                	test   %eax,%eax
80104554:	78 1a                	js     80104570 <sys_fstat+0x4d>
  return filestat(f, st);
80104556:	83 ec 08             	sub    $0x8,%esp
80104559:	ff 75 f0             	pushl  -0x10(%ebp)
8010455c:	ff 75 f4             	pushl  -0xc(%ebp)
8010455f:	e8 7d c8 ff ff       	call   80100de1 <filestat>
80104564:	83 c4 10             	add    $0x10,%esp
}
80104567:	c9                   	leave  
80104568:	c3                   	ret    
    return -1;
80104569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010456e:	eb f7                	jmp    80104567 <sys_fstat+0x44>
80104570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104575:	eb f0                	jmp    80104567 <sys_fstat+0x44>

80104577 <sys_link>:
{
80104577:	55                   	push   %ebp
80104578:	89 e5                	mov    %esp,%ebp
8010457a:	56                   	push   %esi
8010457b:	53                   	push   %ebx
8010457c:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010457f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104582:	50                   	push   %eax
80104583:	6a 00                	push   $0x0
80104585:	e8 93 fb ff ff       	call   8010411d <argstr>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	85 c0                	test   %eax,%eax
8010458f:	0f 88 26 01 00 00    	js     801046bb <sys_link+0x144>
80104595:	83 ec 08             	sub    $0x8,%esp
80104598:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010459b:	50                   	push   %eax
8010459c:	6a 01                	push   $0x1
8010459e:	e8 7a fb ff ff       	call   8010411d <argstr>
801045a3:	83 c4 10             	add    $0x10,%esp
801045a6:	85 c0                	test   %eax,%eax
801045a8:	0f 88 14 01 00 00    	js     801046c2 <sys_link+0x14b>
  begin_op();
801045ae:	e8 fa e1 ff ff       	call   801027ad <begin_op>
  if((ip = namei(old)) == 0){
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	ff 75 e0             	pushl  -0x20(%ebp)
801045b9:	e8 c5 d6 ff ff       	call   80101c83 <namei>
801045be:	89 c3                	mov    %eax,%ebx
801045c0:	83 c4 10             	add    $0x10,%esp
801045c3:	85 c0                	test   %eax,%eax
801045c5:	0f 84 93 00 00 00    	je     8010465e <sys_link+0xe7>
  ilock(ip);
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	50                   	push   %eax
801045cf:	e8 12 cf ff ff       	call   801014e6 <ilock>
  if(ip->type == T_DIR){
801045d4:	83 c4 10             	add    $0x10,%esp
801045d7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045dc:	0f 84 88 00 00 00    	je     8010466a <sys_link+0xf3>
  ip->nlink++;
801045e2:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801045e7:	83 ec 0c             	sub    $0xc,%esp
801045ea:	53                   	push   %ebx
801045eb:	e8 4c ce ff ff       	call   8010143c <iupdate>
  iunlock(ip);
801045f0:	89 1c 24             	mov    %ebx,(%esp)
801045f3:	e8 b0 cf ff ff       	call   801015a8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801045f8:	83 c4 08             	add    $0x8,%esp
801045fb:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045fe:	50                   	push   %eax
801045ff:	ff 75 e4             	pushl  -0x1c(%ebp)
80104602:	e8 94 d6 ff ff       	call   80101c9b <nameiparent>
80104607:	89 c6                	mov    %eax,%esi
80104609:	83 c4 10             	add    $0x10,%esp
8010460c:	85 c0                	test   %eax,%eax
8010460e:	74 7e                	je     8010468e <sys_link+0x117>
  ilock(dp);
80104610:	83 ec 0c             	sub    $0xc,%esp
80104613:	50                   	push   %eax
80104614:	e8 cd ce ff ff       	call   801014e6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104619:	83 c4 10             	add    $0x10,%esp
8010461c:	8b 03                	mov    (%ebx),%eax
8010461e:	39 06                	cmp    %eax,(%esi)
80104620:	75 60                	jne    80104682 <sys_link+0x10b>
80104622:	83 ec 04             	sub    $0x4,%esp
80104625:	ff 73 04             	pushl  0x4(%ebx)
80104628:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010462b:	50                   	push   %eax
8010462c:	56                   	push   %esi
8010462d:	e8 9c d5 ff ff       	call   80101bce <dirlink>
80104632:	83 c4 10             	add    $0x10,%esp
80104635:	85 c0                	test   %eax,%eax
80104637:	78 49                	js     80104682 <sys_link+0x10b>
  iunlockput(dp);
80104639:	83 ec 0c             	sub    $0xc,%esp
8010463c:	56                   	push   %esi
8010463d:	e8 ed d0 ff ff       	call   8010172f <iunlockput>
  iput(ip);
80104642:	89 1c 24             	mov    %ebx,(%esp)
80104645:	e8 a3 cf ff ff       	call   801015ed <iput>
  end_op();
8010464a:	e8 d9 e1 ff ff       	call   80102828 <end_op>
  return 0;
8010464f:	83 c4 10             	add    $0x10,%esp
80104652:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104657:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465a:	5b                   	pop    %ebx
8010465b:	5e                   	pop    %esi
8010465c:	5d                   	pop    %ebp
8010465d:	c3                   	ret    
    end_op();
8010465e:	e8 c5 e1 ff ff       	call   80102828 <end_op>
    return -1;
80104663:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104668:	eb ed                	jmp    80104657 <sys_link+0xe0>
    iunlockput(ip);
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	53                   	push   %ebx
8010466e:	e8 bc d0 ff ff       	call   8010172f <iunlockput>
    end_op();
80104673:	e8 b0 e1 ff ff       	call   80102828 <end_op>
    return -1;
80104678:	83 c4 10             	add    $0x10,%esp
8010467b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104680:	eb d5                	jmp    80104657 <sys_link+0xe0>
    iunlockput(dp);
80104682:	83 ec 0c             	sub    $0xc,%esp
80104685:	56                   	push   %esi
80104686:	e8 a4 d0 ff ff       	call   8010172f <iunlockput>
    goto bad;
8010468b:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	53                   	push   %ebx
80104692:	e8 4f ce ff ff       	call   801014e6 <ilock>
  ip->nlink--;
80104697:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010469c:	89 1c 24             	mov    %ebx,(%esp)
8010469f:	e8 98 cd ff ff       	call   8010143c <iupdate>
  iunlockput(ip);
801046a4:	89 1c 24             	mov    %ebx,(%esp)
801046a7:	e8 83 d0 ff ff       	call   8010172f <iunlockput>
  end_op();
801046ac:	e8 77 e1 ff ff       	call   80102828 <end_op>
  return -1;
801046b1:	83 c4 10             	add    $0x10,%esp
801046b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b9:	eb 9c                	jmp    80104657 <sys_link+0xe0>
    return -1;
801046bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c0:	eb 95                	jmp    80104657 <sys_link+0xe0>
801046c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c7:	eb 8e                	jmp    80104657 <sys_link+0xe0>

801046c9 <sys_unlink>:
{
801046c9:	55                   	push   %ebp
801046ca:	89 e5                	mov    %esp,%ebp
801046cc:	57                   	push   %edi
801046cd:	56                   	push   %esi
801046ce:	53                   	push   %ebx
801046cf:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801046d2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046d5:	50                   	push   %eax
801046d6:	6a 00                	push   $0x0
801046d8:	e8 40 fa ff ff       	call   8010411d <argstr>
801046dd:	83 c4 10             	add    $0x10,%esp
801046e0:	85 c0                	test   %eax,%eax
801046e2:	0f 88 81 01 00 00    	js     80104869 <sys_unlink+0x1a0>
  begin_op();
801046e8:	e8 c0 e0 ff ff       	call   801027ad <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801046ed:	83 ec 08             	sub    $0x8,%esp
801046f0:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046f3:	50                   	push   %eax
801046f4:	ff 75 c4             	pushl  -0x3c(%ebp)
801046f7:	e8 9f d5 ff ff       	call   80101c9b <nameiparent>
801046fc:	89 c7                	mov    %eax,%edi
801046fe:	83 c4 10             	add    $0x10,%esp
80104701:	85 c0                	test   %eax,%eax
80104703:	0f 84 df 00 00 00    	je     801047e8 <sys_unlink+0x11f>
  ilock(dp);
80104709:	83 ec 0c             	sub    $0xc,%esp
8010470c:	50                   	push   %eax
8010470d:	e8 d4 cd ff ff       	call   801014e6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104712:	83 c4 08             	add    $0x8,%esp
80104715:	68 cc 6c 10 80       	push   $0x80106ccc
8010471a:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010471d:	50                   	push   %eax
8010471e:	e8 74 d2 ff ff       	call   80101997 <namecmp>
80104723:	83 c4 10             	add    $0x10,%esp
80104726:	85 c0                	test   %eax,%eax
80104728:	0f 84 51 01 00 00    	je     8010487f <sys_unlink+0x1b6>
8010472e:	83 ec 08             	sub    $0x8,%esp
80104731:	68 cb 6c 10 80       	push   $0x80106ccb
80104736:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104739:	50                   	push   %eax
8010473a:	e8 58 d2 ff ff       	call   80101997 <namecmp>
8010473f:	83 c4 10             	add    $0x10,%esp
80104742:	85 c0                	test   %eax,%eax
80104744:	0f 84 35 01 00 00    	je     8010487f <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010474a:	83 ec 04             	sub    $0x4,%esp
8010474d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104750:	50                   	push   %eax
80104751:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104754:	50                   	push   %eax
80104755:	57                   	push   %edi
80104756:	e8 51 d2 ff ff       	call   801019ac <dirlookup>
8010475b:	89 c3                	mov    %eax,%ebx
8010475d:	83 c4 10             	add    $0x10,%esp
80104760:	85 c0                	test   %eax,%eax
80104762:	0f 84 17 01 00 00    	je     8010487f <sys_unlink+0x1b6>
  ilock(ip);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	50                   	push   %eax
8010476c:	e8 75 cd ff ff       	call   801014e6 <ilock>
  if(ip->nlink < 1)
80104771:	83 c4 10             	add    $0x10,%esp
80104774:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104779:	7e 79                	jle    801047f4 <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010477b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104780:	74 7f                	je     80104801 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104782:	83 ec 04             	sub    $0x4,%esp
80104785:	6a 10                	push   $0x10
80104787:	6a 00                	push   $0x0
80104789:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010478c:	56                   	push   %esi
8010478d:	e8 7e f6 ff ff       	call   80103e10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104792:	6a 10                	push   $0x10
80104794:	ff 75 c0             	pushl  -0x40(%ebp)
80104797:	56                   	push   %esi
80104798:	57                   	push   %edi
80104799:	e8 d8 d0 ff ff       	call   80101876 <writei>
8010479e:	83 c4 20             	add    $0x20,%esp
801047a1:	83 f8 10             	cmp    $0x10,%eax
801047a4:	0f 85 9c 00 00 00    	jne    80104846 <sys_unlink+0x17d>
  if(ip->type == T_DIR){
801047aa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047af:	0f 84 9e 00 00 00    	je     80104853 <sys_unlink+0x18a>
  iunlockput(dp);
801047b5:	83 ec 0c             	sub    $0xc,%esp
801047b8:	57                   	push   %edi
801047b9:	e8 71 cf ff ff       	call   8010172f <iunlockput>
  ip->nlink--;
801047be:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801047c3:	89 1c 24             	mov    %ebx,(%esp)
801047c6:	e8 71 cc ff ff       	call   8010143c <iupdate>
  iunlockput(ip);
801047cb:	89 1c 24             	mov    %ebx,(%esp)
801047ce:	e8 5c cf ff ff       	call   8010172f <iunlockput>
  end_op();
801047d3:	e8 50 e0 ff ff       	call   80102828 <end_op>
  return 0;
801047d8:	83 c4 10             	add    $0x10,%esp
801047db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047e3:	5b                   	pop    %ebx
801047e4:	5e                   	pop    %esi
801047e5:	5f                   	pop    %edi
801047e6:	5d                   	pop    %ebp
801047e7:	c3                   	ret    
    end_op();
801047e8:	e8 3b e0 ff ff       	call   80102828 <end_op>
    return -1;
801047ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f2:	eb ec                	jmp    801047e0 <sys_unlink+0x117>
    panic("unlink: nlink < 1");
801047f4:	83 ec 0c             	sub    $0xc,%esp
801047f7:	68 ea 6c 10 80       	push   $0x80106cea
801047fc:	e8 43 bb ff ff       	call   80100344 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104801:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104805:	0f 86 77 ff ff ff    	jbe    80104782 <sys_unlink+0xb9>
8010480b:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104810:	6a 10                	push   $0x10
80104812:	56                   	push   %esi
80104813:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104816:	50                   	push   %eax
80104817:	53                   	push   %ebx
80104818:	e8 5d cf ff ff       	call   8010177a <readi>
8010481d:	83 c4 10             	add    $0x10,%esp
80104820:	83 f8 10             	cmp    $0x10,%eax
80104823:	75 14                	jne    80104839 <sys_unlink+0x170>
    if(de.inum != 0)
80104825:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
8010482a:	75 47                	jne    80104873 <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010482c:	83 c6 10             	add    $0x10,%esi
8010482f:	3b 73 58             	cmp    0x58(%ebx),%esi
80104832:	72 dc                	jb     80104810 <sys_unlink+0x147>
80104834:	e9 49 ff ff ff       	jmp    80104782 <sys_unlink+0xb9>
      panic("isdirempty: readi");
80104839:	83 ec 0c             	sub    $0xc,%esp
8010483c:	68 fc 6c 10 80       	push   $0x80106cfc
80104841:	e8 fe ba ff ff       	call   80100344 <panic>
    panic("unlink: writei");
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	68 0e 6d 10 80       	push   $0x80106d0e
8010484e:	e8 f1 ba ff ff       	call   80100344 <panic>
    dp->nlink--;
80104853:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	57                   	push   %edi
8010485c:	e8 db cb ff ff       	call   8010143c <iupdate>
80104861:	83 c4 10             	add    $0x10,%esp
80104864:	e9 4c ff ff ff       	jmp    801047b5 <sys_unlink+0xec>
    return -1;
80104869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010486e:	e9 6d ff ff ff       	jmp    801047e0 <sys_unlink+0x117>
    iunlockput(ip);
80104873:	83 ec 0c             	sub    $0xc,%esp
80104876:	53                   	push   %ebx
80104877:	e8 b3 ce ff ff       	call   8010172f <iunlockput>
    goto bad;
8010487c:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	57                   	push   %edi
80104883:	e8 a7 ce ff ff       	call   8010172f <iunlockput>
  end_op();
80104888:	e8 9b df ff ff       	call   80102828 <end_op>
  return -1;
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104895:	e9 46 ff ff ff       	jmp    801047e0 <sys_unlink+0x117>

8010489a <sys_open>:

int
sys_open(void)
{
8010489a:	55                   	push   %ebp
8010489b:	89 e5                	mov    %esp,%ebp
8010489d:	57                   	push   %edi
8010489e:	56                   	push   %esi
8010489f:	53                   	push   %ebx
801048a0:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048a6:	50                   	push   %eax
801048a7:	6a 00                	push   $0x0
801048a9:	e8 6f f8 ff ff       	call   8010411d <argstr>
801048ae:	83 c4 10             	add    $0x10,%esp
801048b1:	85 c0                	test   %eax,%eax
801048b3:	0f 88 0b 01 00 00    	js     801049c4 <sys_open+0x12a>
801048b9:	83 ec 08             	sub    $0x8,%esp
801048bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048bf:	50                   	push   %eax
801048c0:	6a 01                	push   $0x1
801048c2:	e8 cf f7 ff ff       	call   80104096 <argint>
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	85 c0                	test   %eax,%eax
801048cc:	0f 88 f9 00 00 00    	js     801049cb <sys_open+0x131>
    return -1;

  begin_op();
801048d2:	e8 d6 de ff ff       	call   801027ad <begin_op>

  if(omode & O_CREATE){
801048d7:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801048db:	0f 84 8a 00 00 00    	je     8010496b <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	6a 00                	push   $0x0
801048e6:	b9 00 00 00 00       	mov    $0x0,%ecx
801048eb:	ba 02 00 00 00       	mov    $0x2,%edx
801048f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048f3:	e8 4d f9 ff ff       	call   80104245 <create>
801048f8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	85 c0                	test   %eax,%eax
801048ff:	74 5e                	je     8010495f <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104901:	e8 74 c3 ff ff       	call   80100c7a <filealloc>
80104906:	89 c3                	mov    %eax,%ebx
80104908:	85 c0                	test   %eax,%eax
8010490a:	0f 84 ce 00 00 00    	je     801049de <sys_open+0x144>
80104910:	e8 f0 f8 ff ff       	call   80104205 <fdalloc>
80104915:	89 c7                	mov    %eax,%edi
80104917:	85 c0                	test   %eax,%eax
80104919:	0f 88 b3 00 00 00    	js     801049d2 <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	56                   	push   %esi
80104923:	e8 80 cc ff ff       	call   801015a8 <iunlock>
  end_op();
80104928:	e8 fb de ff ff       	call   80102828 <end_op>

  f->type = FD_INODE;
8010492d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104933:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104936:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010493d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104940:	89 d0                	mov    %edx,%eax
80104942:	83 f0 01             	xor    $0x1,%eax
80104945:	83 e0 01             	and    $0x1,%eax
80104948:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010494b:	83 c4 10             	add    $0x10,%esp
8010494e:	f6 c2 03             	test   $0x3,%dl
80104951:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104955:	89 f8                	mov    %edi,%eax
80104957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010495a:	5b                   	pop    %ebx
8010495b:	5e                   	pop    %esi
8010495c:	5f                   	pop    %edi
8010495d:	5d                   	pop    %ebp
8010495e:	c3                   	ret    
      end_op();
8010495f:	e8 c4 de ff ff       	call   80102828 <end_op>
      return -1;
80104964:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104969:	eb ea                	jmp    80104955 <sys_open+0xbb>
    if((ip = namei(path)) == 0){
8010496b:	83 ec 0c             	sub    $0xc,%esp
8010496e:	ff 75 e4             	pushl  -0x1c(%ebp)
80104971:	e8 0d d3 ff ff       	call   80101c83 <namei>
80104976:	89 c6                	mov    %eax,%esi
80104978:	83 c4 10             	add    $0x10,%esp
8010497b:	85 c0                	test   %eax,%eax
8010497d:	74 39                	je     801049b8 <sys_open+0x11e>
    ilock(ip);
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	50                   	push   %eax
80104983:	e8 5e cb ff ff       	call   801014e6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104988:	83 c4 10             	add    $0x10,%esp
8010498b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104990:	0f 85 6b ff ff ff    	jne    80104901 <sys_open+0x67>
80104996:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010499a:	0f 84 61 ff ff ff    	je     80104901 <sys_open+0x67>
      iunlockput(ip);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	56                   	push   %esi
801049a4:	e8 86 cd ff ff       	call   8010172f <iunlockput>
      end_op();
801049a9:	e8 7a de ff ff       	call   80102828 <end_op>
      return -1;
801049ae:	83 c4 10             	add    $0x10,%esp
801049b1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049b6:	eb 9d                	jmp    80104955 <sys_open+0xbb>
      end_op();
801049b8:	e8 6b de ff ff       	call   80102828 <end_op>
      return -1;
801049bd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049c2:	eb 91                	jmp    80104955 <sys_open+0xbb>
    return -1;
801049c4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049c9:	eb 8a                	jmp    80104955 <sys_open+0xbb>
801049cb:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049d0:	eb 83                	jmp    80104955 <sys_open+0xbb>
      fileclose(f);
801049d2:	83 ec 0c             	sub    $0xc,%esp
801049d5:	53                   	push   %ebx
801049d6:	e8 51 c3 ff ff       	call   80100d2c <fileclose>
801049db:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801049de:	83 ec 0c             	sub    $0xc,%esp
801049e1:	56                   	push   %esi
801049e2:	e8 48 cd ff ff       	call   8010172f <iunlockput>
    end_op();
801049e7:	e8 3c de ff ff       	call   80102828 <end_op>
    return -1;
801049ec:	83 c4 10             	add    $0x10,%esp
801049ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049f4:	e9 5c ff ff ff       	jmp    80104955 <sys_open+0xbb>

801049f9 <sys_mkdir>:

int
sys_mkdir(void)
{
801049f9:	55                   	push   %ebp
801049fa:	89 e5                	mov    %esp,%ebp
801049fc:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801049ff:	e8 a9 dd ff ff       	call   801027ad <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a04:	83 ec 08             	sub    $0x8,%esp
80104a07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a0a:	50                   	push   %eax
80104a0b:	6a 00                	push   $0x0
80104a0d:	e8 0b f7 ff ff       	call   8010411d <argstr>
80104a12:	83 c4 10             	add    $0x10,%esp
80104a15:	85 c0                	test   %eax,%eax
80104a17:	78 36                	js     80104a4f <sys_mkdir+0x56>
80104a19:	83 ec 0c             	sub    $0xc,%esp
80104a1c:	6a 00                	push   $0x0
80104a1e:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a23:	ba 01 00 00 00       	mov    $0x1,%edx
80104a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2b:	e8 15 f8 ff ff       	call   80104245 <create>
80104a30:	83 c4 10             	add    $0x10,%esp
80104a33:	85 c0                	test   %eax,%eax
80104a35:	74 18                	je     80104a4f <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a37:	83 ec 0c             	sub    $0xc,%esp
80104a3a:	50                   	push   %eax
80104a3b:	e8 ef cc ff ff       	call   8010172f <iunlockput>
  end_op();
80104a40:	e8 e3 dd ff ff       	call   80102828 <end_op>
  return 0;
80104a45:	83 c4 10             	add    $0x10,%esp
80104a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a4d:	c9                   	leave  
80104a4e:	c3                   	ret    
    end_op();
80104a4f:	e8 d4 dd ff ff       	call   80102828 <end_op>
    return -1;
80104a54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a59:	eb f2                	jmp    80104a4d <sys_mkdir+0x54>

80104a5b <sys_mknod>:

int
sys_mknod(void)
{
80104a5b:	55                   	push   %ebp
80104a5c:	89 e5                	mov    %esp,%ebp
80104a5e:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a61:	e8 47 dd ff ff       	call   801027ad <begin_op>
  if((argstr(0, &path)) < 0 ||
80104a66:	83 ec 08             	sub    $0x8,%esp
80104a69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6c:	50                   	push   %eax
80104a6d:	6a 00                	push   $0x0
80104a6f:	e8 a9 f6 ff ff       	call   8010411d <argstr>
80104a74:	83 c4 10             	add    $0x10,%esp
80104a77:	85 c0                	test   %eax,%eax
80104a79:	78 62                	js     80104add <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104a7b:	83 ec 08             	sub    $0x8,%esp
80104a7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a81:	50                   	push   %eax
80104a82:	6a 01                	push   $0x1
80104a84:	e8 0d f6 ff ff       	call   80104096 <argint>
  if((argstr(0, &path)) < 0 ||
80104a89:	83 c4 10             	add    $0x10,%esp
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	78 4d                	js     80104add <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104a90:	83 ec 08             	sub    $0x8,%esp
80104a93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a96:	50                   	push   %eax
80104a97:	6a 02                	push   $0x2
80104a99:	e8 f8 f5 ff ff       	call   80104096 <argint>
     argint(1, &major) < 0 ||
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	85 c0                	test   %eax,%eax
80104aa3:	78 38                	js     80104add <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104aa5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80104aa9:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80104aac:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80104ab0:	50                   	push   %eax
80104ab1:	ba 03 00 00 00       	mov    $0x3,%edx
80104ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab9:	e8 87 f7 ff ff       	call   80104245 <create>
80104abe:	83 c4 10             	add    $0x10,%esp
80104ac1:	85 c0                	test   %eax,%eax
80104ac3:	74 18                	je     80104add <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ac5:	83 ec 0c             	sub    $0xc,%esp
80104ac8:	50                   	push   %eax
80104ac9:	e8 61 cc ff ff       	call   8010172f <iunlockput>
  end_op();
80104ace:	e8 55 dd ff ff       	call   80102828 <end_op>
  return 0;
80104ad3:	83 c4 10             	add    $0x10,%esp
80104ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104adb:	c9                   	leave  
80104adc:	c3                   	ret    
    end_op();
80104add:	e8 46 dd ff ff       	call   80102828 <end_op>
    return -1;
80104ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae7:	eb f2                	jmp    80104adb <sys_mknod+0x80>

80104ae9 <sys_chdir>:

int
sys_chdir(void)
{
80104ae9:	55                   	push   %ebp
80104aea:	89 e5                	mov    %esp,%ebp
80104aec:	56                   	push   %esi
80104aed:	53                   	push   %ebx
80104aee:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104af1:	e8 3e e8 ff ff       	call   80103334 <myproc>
80104af6:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104af8:	e8 b0 dc ff ff       	call   801027ad <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104afd:	83 ec 08             	sub    $0x8,%esp
80104b00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b03:	50                   	push   %eax
80104b04:	6a 00                	push   $0x0
80104b06:	e8 12 f6 ff ff       	call   8010411d <argstr>
80104b0b:	83 c4 10             	add    $0x10,%esp
80104b0e:	85 c0                	test   %eax,%eax
80104b10:	78 52                	js     80104b64 <sys_chdir+0x7b>
80104b12:	83 ec 0c             	sub    $0xc,%esp
80104b15:	ff 75 f4             	pushl  -0xc(%ebp)
80104b18:	e8 66 d1 ff ff       	call   80101c83 <namei>
80104b1d:	89 c3                	mov    %eax,%ebx
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	74 3e                	je     80104b64 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104b26:	83 ec 0c             	sub    $0xc,%esp
80104b29:	50                   	push   %eax
80104b2a:	e8 b7 c9 ff ff       	call   801014e6 <ilock>
  if(ip->type != T_DIR){
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b37:	75 37                	jne    80104b70 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b39:	83 ec 0c             	sub    $0xc,%esp
80104b3c:	53                   	push   %ebx
80104b3d:	e8 66 ca ff ff       	call   801015a8 <iunlock>
  iput(curproc->cwd);
80104b42:	83 c4 04             	add    $0x4,%esp
80104b45:	ff 76 68             	pushl  0x68(%esi)
80104b48:	e8 a0 ca ff ff       	call   801015ed <iput>
  end_op();
80104b4d:	e8 d6 dc ff ff       	call   80102828 <end_op>
  curproc->cwd = ip;
80104b52:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b55:	83 c4 10             	add    $0x10,%esp
80104b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b60:	5b                   	pop    %ebx
80104b61:	5e                   	pop    %esi
80104b62:	5d                   	pop    %ebp
80104b63:	c3                   	ret    
    end_op();
80104b64:	e8 bf dc ff ff       	call   80102828 <end_op>
    return -1;
80104b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b6e:	eb ed                	jmp    80104b5d <sys_chdir+0x74>
    iunlockput(ip);
80104b70:	83 ec 0c             	sub    $0xc,%esp
80104b73:	53                   	push   %ebx
80104b74:	e8 b6 cb ff ff       	call   8010172f <iunlockput>
    end_op();
80104b79:	e8 aa dc ff ff       	call   80102828 <end_op>
    return -1;
80104b7e:	83 c4 10             	add    $0x10,%esp
80104b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b86:	eb d5                	jmp    80104b5d <sys_chdir+0x74>

80104b88 <sys_exec>:

int
sys_exec(void)
{
80104b88:	55                   	push   %ebp
80104b89:	89 e5                	mov    %esp,%ebp
80104b8b:	57                   	push   %edi
80104b8c:	56                   	push   %esi
80104b8d:	53                   	push   %ebx
80104b8e:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104b97:	50                   	push   %eax
80104b98:	6a 00                	push   $0x0
80104b9a:	e8 7e f5 ff ff       	call   8010411d <argstr>
80104b9f:	83 c4 10             	add    $0x10,%esp
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	0f 88 b4 00 00 00    	js     80104c5e <sys_exec+0xd6>
80104baa:	83 ec 08             	sub    $0x8,%esp
80104bad:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104bb3:	50                   	push   %eax
80104bb4:	6a 01                	push   $0x1
80104bb6:	e8 db f4 ff ff       	call   80104096 <argint>
80104bbb:	83 c4 10             	add    $0x10,%esp
80104bbe:	85 c0                	test   %eax,%eax
80104bc0:	0f 88 9f 00 00 00    	js     80104c65 <sys_exec+0xdd>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bc6:	83 ec 04             	sub    $0x4,%esp
80104bc9:	68 80 00 00 00       	push   $0x80
80104bce:	6a 00                	push   $0x0
80104bd0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104bd6:	50                   	push   %eax
80104bd7:	e8 34 f2 ff ff       	call   80103e10 <memset>
80104bdc:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104bdf:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104be4:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104bea:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80104bf1:	83 ec 08             	sub    $0x8,%esp
80104bf4:	57                   	push   %edi
80104bf5:	89 d8                	mov    %ebx,%eax
80104bf7:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80104bfd:	50                   	push   %eax
80104bfe:	e8 07 f4 ff ff       	call   8010400a <fetchint>
80104c03:	83 c4 10             	add    $0x10,%esp
80104c06:	85 c0                	test   %eax,%eax
80104c08:	78 62                	js     80104c6c <sys_exec+0xe4>
      return -1;
    if(uarg == 0){
80104c0a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104c10:	85 c0                	test   %eax,%eax
80104c12:	74 28                	je     80104c3c <sys_exec+0xb4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104c14:	83 ec 08             	sub    $0x8,%esp
80104c17:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80104c1d:	01 d3                	add    %edx,%ebx
80104c1f:	53                   	push   %ebx
80104c20:	50                   	push   %eax
80104c21:	e8 20 f4 ff ff       	call   80104046 <fetchstr>
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	78 4c                	js     80104c79 <sys_exec+0xf1>
  for(i=0;; i++){
80104c2d:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80104c30:	83 fe 20             	cmp    $0x20,%esi
80104c33:	75 b5                	jne    80104bea <sys_exec+0x62>
      return -1;
80104c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3a:	eb 35                	jmp    80104c71 <sys_exec+0xe9>
      argv[i] = 0;
80104c3c:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80104c43:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
80104c47:	83 ec 08             	sub    $0x8,%esp
80104c4a:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104c50:	50                   	push   %eax
80104c51:	ff 75 e4             	pushl  -0x1c(%ebp)
80104c54:	e8 b9 bc ff ff       	call   80100912 <exec>
80104c59:	83 c4 10             	add    $0x10,%esp
80104c5c:	eb 13                	jmp    80104c71 <sys_exec+0xe9>
    return -1;
80104c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c63:	eb 0c                	jmp    80104c71 <sys_exec+0xe9>
80104c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c6a:	eb 05                	jmp    80104c71 <sys_exec+0xe9>
      return -1;
80104c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c74:	5b                   	pop    %ebx
80104c75:	5e                   	pop    %esi
80104c76:	5f                   	pop    %edi
80104c77:	5d                   	pop    %ebp
80104c78:	c3                   	ret    
      return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7e:	eb f1                	jmp    80104c71 <sys_exec+0xe9>

80104c80 <sys_pipe>:

int
sys_pipe(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c87:	6a 08                	push   $0x8
80104c89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c8c:	50                   	push   %eax
80104c8d:	6a 00                	push   $0x0
80104c8f:	e8 28 f4 ff ff       	call   801040bc <argptr>
80104c94:	83 c4 10             	add    $0x10,%esp
80104c97:	85 c0                	test   %eax,%eax
80104c99:	78 46                	js     80104ce1 <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c9b:	83 ec 08             	sub    $0x8,%esp
80104c9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ca1:	50                   	push   %eax
80104ca2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ca5:	50                   	push   %eax
80104ca6:	e8 31 e1 ff ff       	call   80102ddc <pipealloc>
80104cab:	83 c4 10             	add    $0x10,%esp
80104cae:	85 c0                	test   %eax,%eax
80104cb0:	78 36                	js     80104ce8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb5:	e8 4b f5 ff ff       	call   80104205 <fdalloc>
80104cba:	89 c3                	mov    %eax,%ebx
80104cbc:	85 c0                	test   %eax,%eax
80104cbe:	78 3c                	js     80104cfc <sys_pipe+0x7c>
80104cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cc3:	e8 3d f5 ff ff       	call   80104205 <fdalloc>
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	78 23                	js     80104cef <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccf:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cd4:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cdf:	c9                   	leave  
80104ce0:	c3                   	ret    
    return -1;
80104ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce6:	eb f4                	jmp    80104cdc <sys_pipe+0x5c>
    return -1;
80104ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ced:	eb ed                	jmp    80104cdc <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104cef:	e8 40 e6 ff ff       	call   80103334 <myproc>
80104cf4:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104cfb:	00 
    fileclose(rf);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	ff 75 f0             	pushl  -0x10(%ebp)
80104d02:	e8 25 c0 ff ff       	call   80100d2c <fileclose>
    fileclose(wf);
80104d07:	83 c4 04             	add    $0x4,%esp
80104d0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d0d:	e8 1a c0 ff ff       	call   80100d2c <fileclose>
    return -1;
80104d12:	83 c4 10             	add    $0x10,%esp
80104d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1a:	eb c0                	jmp    80104cdc <sys_pipe+0x5c>

80104d1c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104d1c:	55                   	push   %ebp
80104d1d:	89 e5                	mov    %esp,%ebp
80104d1f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d22:	e8 85 e7 ff ff       	call   801034ac <fork>
}
80104d27:	c9                   	leave  
80104d28:	c3                   	ret    

80104d29 <sys_exit>:

int
sys_exit(void)
{
80104d29:	55                   	push   %ebp
80104d2a:	89 e5                	mov    %esp,%ebp
80104d2c:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d2f:	e8 b3 e9 ff ff       	call   801036e7 <exit>
  return 0;  // not reached
}
80104d34:	b8 00 00 00 00       	mov    $0x0,%eax
80104d39:	c9                   	leave  
80104d3a:	c3                   	ret    

80104d3b <sys_wait>:

int
sys_wait(void)
{
80104d3b:	55                   	push   %ebp
80104d3c:	89 e5                	mov    %esp,%ebp
80104d3e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104d41:	e8 3c eb ff ff       	call   80103882 <wait>
}
80104d46:	c9                   	leave  
80104d47:	c3                   	ret    

80104d48 <sys_kill>:

int
sys_kill(void)
{
80104d48:	55                   	push   %ebp
80104d49:	89 e5                	mov    %esp,%ebp
80104d4b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d51:	50                   	push   %eax
80104d52:	6a 00                	push   $0x0
80104d54:	e8 3d f3 ff ff       	call   80104096 <argint>
80104d59:	83 c4 10             	add    $0x10,%esp
80104d5c:	85 c0                	test   %eax,%eax
80104d5e:	78 10                	js     80104d70 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	ff 75 f4             	pushl  -0xc(%ebp)
80104d66:	e8 1e ec ff ff       	call   80103989 <kill>
80104d6b:	83 c4 10             	add    $0x10,%esp
}
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d75:	eb f7                	jmp    80104d6e <sys_kill+0x26>

80104d77 <sys_getpid>:

int
sys_getpid(void)
{
80104d77:	55                   	push   %ebp
80104d78:	89 e5                	mov    %esp,%ebp
80104d7a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d7d:	e8 b2 e5 ff ff       	call   80103334 <myproc>
80104d82:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    

80104d87 <sys_sbrk>:

int
sys_sbrk(void)
{
80104d87:	55                   	push   %ebp
80104d88:	89 e5                	mov    %esp,%ebp
80104d8a:	53                   	push   %ebx
80104d8b:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104d8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d91:	50                   	push   %eax
80104d92:	6a 00                	push   $0x0
80104d94:	e8 fd f2 ff ff       	call   80104096 <argint>
80104d99:	83 c4 10             	add    $0x10,%esp
80104d9c:	85 c0                	test   %eax,%eax
80104d9e:	78 26                	js     80104dc6 <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
80104da0:	e8 8f e5 ff ff       	call   80103334 <myproc>
80104da5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104da7:	83 ec 0c             	sub    $0xc,%esp
80104daa:	ff 75 f4             	pushl  -0xc(%ebp)
80104dad:	e8 8d e6 ff ff       	call   8010343f <growproc>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	85 c0                	test   %eax,%eax
    return -1;
80104db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dbc:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80104dbf:	89 d8                	mov    %ebx,%eax
80104dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc4:	c9                   	leave  
80104dc5:	c3                   	ret    
    return -1;
80104dc6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104dcb:	eb f2                	jmp    80104dbf <sys_sbrk+0x38>

80104dcd <sys_sleep>:

int
sys_sleep(void)
{
80104dcd:	55                   	push   %ebp
80104dce:	89 e5                	mov    %esp,%ebp
80104dd0:	53                   	push   %ebx
80104dd1:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104dd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd7:	50                   	push   %eax
80104dd8:	6a 00                	push   $0x0
80104dda:	e8 b7 f2 ff ff       	call   80104096 <argint>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	78 79                	js     80104e5f <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	68 60 3f 11 80       	push   $0x80113f60
80104dee:	e8 6f ef ff ff       	call   80103d62 <acquire>
  ticks0 = ticks;
80104df3:	8b 1d a0 47 11 80    	mov    0x801147a0,%ebx
  while(ticks - ticks0 < n){
80104df9:	83 c4 10             	add    $0x10,%esp
80104dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e00:	74 2c                	je     80104e2e <sys_sleep+0x61>
    if(myproc()->killed){
80104e02:	e8 2d e5 ff ff       	call   80103334 <myproc>
80104e07:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e0b:	75 3b                	jne    80104e48 <sys_sleep+0x7b>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e0d:	83 ec 08             	sub    $0x8,%esp
80104e10:	68 60 3f 11 80       	push   $0x80113f60
80104e15:	68 a0 47 11 80       	push   $0x801147a0
80104e1a:	e8 c1 e9 ff ff       	call   801037e0 <sleep>
  while(ticks - ticks0 < n){
80104e1f:	a1 a0 47 11 80       	mov    0x801147a0,%eax
80104e24:	29 d8                	sub    %ebx,%eax
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e2c:	72 d4                	jb     80104e02 <sys_sleep+0x35>
  }
  release(&tickslock);
80104e2e:	83 ec 0c             	sub    $0xc,%esp
80104e31:	68 60 3f 11 80       	push   $0x80113f60
80104e36:	e8 8e ef ff ff       	call   80103dc9 <release>
  return 0;
80104e3b:	83 c4 10             	add    $0x10,%esp
80104e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e46:	c9                   	leave  
80104e47:	c3                   	ret    
      release(&tickslock);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 60 3f 11 80       	push   $0x80113f60
80104e50:	e8 74 ef ff ff       	call   80103dc9 <release>
      return -1;
80104e55:	83 c4 10             	add    $0x10,%esp
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e5d:	eb e4                	jmp    80104e43 <sys_sleep+0x76>
    return -1;
80104e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e64:	eb dd                	jmp    80104e43 <sys_sleep+0x76>

80104e66 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e66:	55                   	push   %ebp
80104e67:	89 e5                	mov    %esp,%ebp
80104e69:	53                   	push   %ebx
80104e6a:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104e6d:	68 60 3f 11 80       	push   $0x80113f60
80104e72:	e8 eb ee ff ff       	call   80103d62 <acquire>
  xticks = ticks;
80104e77:	8b 1d a0 47 11 80    	mov    0x801147a0,%ebx
  release(&tickslock);
80104e7d:	c7 04 24 60 3f 11 80 	movl   $0x80113f60,(%esp)
80104e84:	e8 40 ef ff ff       	call   80103dc9 <release>
  return xticks;
}
80104e89:	89 d8                	mov    %ebx,%eax
80104e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e8e:	c9                   	leave  
80104e8f:	c3                   	ret    

80104e90 <sys_getlevel>:

int
sys_getlevel(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	83 ec 08             	sub    $0x8,%esp
  return getlevel();
80104e96:	e8 3e ec ff ff       	call   80103ad9 <getlevel>
80104e9b:	c9                   	leave  
80104e9c:	c3                   	ret    

80104e9d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104e9d:	1e                   	push   %ds
  pushl %es
80104e9e:	06                   	push   %es
  pushl %fs
80104e9f:	0f a0                	push   %fs
  pushl %gs
80104ea1:	0f a8                	push   %gs
  pushal
80104ea3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ea4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104ea8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104eaa:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104eac:	54                   	push   %esp
  call trap
80104ead:	e8 bd 00 00 00       	call   80104f6f <trap>
  addl $4, %esp
80104eb2:	83 c4 04             	add    $0x4,%esp

80104eb5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104eb5:	61                   	popa   
  popl %gs
80104eb6:	0f a9                	pop    %gs
  popl %fs
80104eb8:	0f a1                	pop    %fs
  popl %es
80104eba:	07                   	pop    %es
  popl %ds
80104ebb:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104ebc:	83 c4 08             	add    $0x8,%esp
  iret
80104ebf:	cf                   	iret   

80104ec0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104ec6:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104ecb:	8b 14 85 08 90 10 80 	mov    -0x7fef6ff8(,%eax,4),%edx
80104ed2:	66 89 14 c5 a0 3f 11 	mov    %dx,-0x7feec060(,%eax,8)
80104ed9:	80 
80104eda:	66 c7 04 c5 a2 3f 11 	movw   $0x8,-0x7feec05e(,%eax,8)
80104ee1:	80 08 00 
80104ee4:	c6 04 c5 a4 3f 11 80 	movb   $0x0,-0x7feec05c(,%eax,8)
80104eeb:	00 
80104eec:	c6 04 c5 a5 3f 11 80 	movb   $0x8e,-0x7feec05b(,%eax,8)
80104ef3:	8e 
80104ef4:	c1 ea 10             	shr    $0x10,%edx
80104ef7:	66 89 14 c5 a6 3f 11 	mov    %dx,-0x7feec05a(,%eax,8)
80104efe:	80 
  for(i = 0; i < 256; i++)
80104eff:	83 c0 01             	add    $0x1,%eax
80104f02:	3d 00 01 00 00       	cmp    $0x100,%eax
80104f07:	75 c2                	jne    80104ecb <tvinit+0xb>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f09:	a1 08 91 10 80       	mov    0x80109108,%eax
80104f0e:	66 a3 a0 41 11 80    	mov    %ax,0x801141a0
80104f14:	66 c7 05 a2 41 11 80 	movw   $0x8,0x801141a2
80104f1b:	08 00 
80104f1d:	c6 05 a4 41 11 80 00 	movb   $0x0,0x801141a4
80104f24:	c6 05 a5 41 11 80 ef 	movb   $0xef,0x801141a5
80104f2b:	c1 e8 10             	shr    $0x10,%eax
80104f2e:	66 a3 a6 41 11 80    	mov    %ax,0x801141a6

  initlock(&tickslock, "time");
80104f34:	83 ec 08             	sub    $0x8,%esp
80104f37:	68 1d 6d 10 80       	push   $0x80106d1d
80104f3c:	68 60 3f 11 80       	push   $0x80113f60
80104f41:	e8 d4 ec ff ff       	call   80103c1a <initlock>
}
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    

80104f4b <idtinit>:

void
idtinit(void)
{
80104f4b:	55                   	push   %ebp
80104f4c:	89 e5                	mov    %esp,%ebp
80104f4e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104f51:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104f57:	b8 a0 3f 11 80       	mov    $0x80113fa0,%eax
80104f5c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f60:	c1 e8 10             	shr    $0x10,%eax
80104f63:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f67:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f6a:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104f6d:	c9                   	leave  
80104f6e:	c3                   	ret    

80104f6f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104f6f:	55                   	push   %ebp
80104f70:	89 e5                	mov    %esp,%ebp
80104f72:	57                   	push   %edi
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	83 ec 1c             	sub    $0x1c,%esp
80104f78:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80104f7b:	8b 47 30             	mov    0x30(%edi),%eax
80104f7e:	83 f8 40             	cmp    $0x40,%eax
80104f81:	74 13                	je     80104f96 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104f83:	83 e8 20             	sub    $0x20,%eax
80104f86:	83 f8 1f             	cmp    $0x1f,%eax
80104f89:	0f 87 37 01 00 00    	ja     801050c6 <trap+0x157>
80104f8f:	ff 24 85 c4 6d 10 80 	jmp    *-0x7fef923c(,%eax,4)
    if(myproc()->killed)
80104f96:	e8 99 e3 ff ff       	call   80103334 <myproc>
80104f9b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f9f:	75 1f                	jne    80104fc0 <trap+0x51>
    myproc()->tf = tf;
80104fa1:	e8 8e e3 ff ff       	call   80103334 <myproc>
80104fa6:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80104fa9:	e8 a2 f1 ff ff       	call   80104150 <syscall>
    if(myproc()->killed)
80104fae:	e8 81 e3 ff ff       	call   80103334 <myproc>
80104fb3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fb7:	74 7e                	je     80105037 <trap+0xc8>
      exit();
80104fb9:	e8 29 e7 ff ff       	call   801036e7 <exit>
80104fbe:	eb 77                	jmp    80105037 <trap+0xc8>
      exit();
80104fc0:	e8 22 e7 ff ff       	call   801036e7 <exit>
80104fc5:	eb da                	jmp    80104fa1 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104fc7:	e8 4d e3 ff ff       	call   80103319 <cpuid>
80104fcc:	85 c0                	test   %eax,%eax
80104fce:	74 6f                	je     8010503f <trap+0xd0>
      release(&tickslock);
    }
    /* ******************** */
    /* * WRITE YOUR CODE    */
    /* ******************** */
    lapiceoi();
80104fd0:	e8 85 d4 ff ff       	call   8010245a <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104fd5:	e8 5a e3 ff ff       	call   80103334 <myproc>
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	74 1c                	je     80104ffa <trap+0x8b>
80104fde:	e8 51 e3 ff ff       	call   80103334 <myproc>
80104fe3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fe7:	74 11                	je     80104ffa <trap+0x8b>
80104fe9:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80104fed:	83 e0 03             	and    $0x3,%eax
80104ff0:	66 83 f8 03          	cmp    $0x3,%ax
80104ff4:	0f 84 60 01 00 00    	je     8010515a <trap+0x1eb>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104ffa:	e8 35 e3 ff ff       	call   80103334 <myproc>
80104fff:	85 c0                	test   %eax,%eax
80105001:	74 0f                	je     80105012 <trap+0xa3>
80105003:	e8 2c e3 ff ff       	call   80103334 <myproc>
80105008:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010500c:	0f 84 52 01 00 00    	je     80105164 <trap+0x1f5>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105012:	e8 1d e3 ff ff       	call   80103334 <myproc>
80105017:	85 c0                	test   %eax,%eax
80105019:	74 1c                	je     80105037 <trap+0xc8>
8010501b:	e8 14 e3 ff ff       	call   80103334 <myproc>
80105020:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105024:	74 11                	je     80105037 <trap+0xc8>
80105026:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010502a:	83 e0 03             	and    $0x3,%eax
8010502d:	66 83 f8 03          	cmp    $0x3,%ax
80105031:	0f 84 41 01 00 00    	je     80105178 <trap+0x209>
    exit();
}
80105037:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503a:	5b                   	pop    %ebx
8010503b:	5e                   	pop    %esi
8010503c:	5f                   	pop    %edi
8010503d:	5d                   	pop    %ebp
8010503e:	c3                   	ret    
      acquire(&tickslock);
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 60 3f 11 80       	push   $0x80113f60
80105047:	e8 16 ed ff ff       	call   80103d62 <acquire>
      ticks++;
8010504c:	83 05 a0 47 11 80 01 	addl   $0x1,0x801147a0
      wakeup(&ticks);
80105053:	c7 04 24 a0 47 11 80 	movl   $0x801147a0,(%esp)
8010505a:	e8 01 e9 ff ff       	call   80103960 <wakeup>
      release(&tickslock);
8010505f:	c7 04 24 60 3f 11 80 	movl   $0x80113f60,(%esp)
80105066:	e8 5e ed ff ff       	call   80103dc9 <release>
8010506b:	83 c4 10             	add    $0x10,%esp
8010506e:	e9 5d ff ff ff       	jmp    80104fd0 <trap+0x61>
    ideintr();
80105073:	e8 78 cd ff ff       	call   80101df0 <ideintr>
    lapiceoi();
80105078:	e8 dd d3 ff ff       	call   8010245a <lapiceoi>
    break;
8010507d:	e9 53 ff ff ff       	jmp    80104fd5 <trap+0x66>
    kbdintr();
80105082:	e8 07 d2 ff ff       	call   8010228e <kbdintr>
    lapiceoi();
80105087:	e8 ce d3 ff ff       	call   8010245a <lapiceoi>
    break;
8010508c:	e9 44 ff ff ff       	jmp    80104fd5 <trap+0x66>
    uartintr();
80105091:	e8 1a 02 00 00       	call   801052b0 <uartintr>
    lapiceoi();
80105096:	e8 bf d3 ff ff       	call   8010245a <lapiceoi>
    break;
8010509b:	e9 35 ff ff ff       	jmp    80104fd5 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801050a0:	8b 77 38             	mov    0x38(%edi),%esi
801050a3:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801050a7:	e8 6d e2 ff ff       	call   80103319 <cpuid>
801050ac:	56                   	push   %esi
801050ad:	53                   	push   %ebx
801050ae:	50                   	push   %eax
801050af:	68 28 6d 10 80       	push   $0x80106d28
801050b4:	e8 28 b5 ff ff       	call   801005e1 <cprintf>
    lapiceoi();
801050b9:	e8 9c d3 ff ff       	call   8010245a <lapiceoi>
    break;
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	e9 0f ff ff ff       	jmp    80104fd5 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801050c6:	e8 69 e2 ff ff       	call   80103334 <myproc>
801050cb:	85 c0                	test   %eax,%eax
801050cd:	74 60                	je     8010512f <trap+0x1c0>
801050cf:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801050d3:	74 5a                	je     8010512f <trap+0x1c0>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050d5:	0f 20 d0             	mov    %cr2,%eax
801050d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050db:	8b 77 38             	mov    0x38(%edi),%esi
801050de:	e8 36 e2 ff ff       	call   80103319 <cpuid>
801050e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050e6:	8b 5f 34             	mov    0x34(%edi),%ebx
801050e9:	8b 4f 30             	mov    0x30(%edi),%ecx
801050ec:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801050ef:	e8 40 e2 ff ff       	call   80103334 <myproc>
801050f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801050f7:	e8 38 e2 ff ff       	call   80103334 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050fc:	ff 75 d8             	pushl  -0x28(%ebp)
801050ff:	56                   	push   %esi
80105100:	ff 75 e4             	pushl  -0x1c(%ebp)
80105103:	53                   	push   %ebx
80105104:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105107:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010510a:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010510d:	52                   	push   %edx
8010510e:	ff 70 10             	pushl  0x10(%eax)
80105111:	68 80 6d 10 80       	push   $0x80106d80
80105116:	e8 c6 b4 ff ff       	call   801005e1 <cprintf>
    myproc()->killed = 1;
8010511b:	83 c4 20             	add    $0x20,%esp
8010511e:	e8 11 e2 ff ff       	call   80103334 <myproc>
80105123:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010512a:	e9 a6 fe ff ff       	jmp    80104fd5 <trap+0x66>
8010512f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105132:	8b 5f 38             	mov    0x38(%edi),%ebx
80105135:	e8 df e1 ff ff       	call   80103319 <cpuid>
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	56                   	push   %esi
8010513e:	53                   	push   %ebx
8010513f:	50                   	push   %eax
80105140:	ff 77 30             	pushl  0x30(%edi)
80105143:	68 4c 6d 10 80       	push   $0x80106d4c
80105148:	e8 94 b4 ff ff       	call   801005e1 <cprintf>
      panic("trap");
8010514d:	83 c4 14             	add    $0x14,%esp
80105150:	68 22 6d 10 80       	push   $0x80106d22
80105155:	e8 ea b1 ff ff       	call   80100344 <panic>
    exit();
8010515a:	e8 88 e5 ff ff       	call   801036e7 <exit>
8010515f:	e9 96 fe ff ff       	jmp    80104ffa <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105164:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105168:	0f 85 a4 fe ff ff    	jne    80105012 <trap+0xa3>
    yield();
8010516e:	e8 3b e6 ff ff       	call   801037ae <yield>
80105173:	e9 9a fe ff ff       	jmp    80105012 <trap+0xa3>
    exit();
80105178:	e8 6a e5 ff ff       	call   801036e7 <exit>
8010517d:	e9 b5 fe ff ff       	jmp    80105037 <trap+0xc8>

80105182 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105182:	55                   	push   %ebp
80105183:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105185:	83 3d bc 95 10 80 00 	cmpl   $0x0,0x801095bc
8010518c:	74 15                	je     801051a3 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010518e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105193:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105194:	a8 01                	test   $0x1,%al
80105196:	74 12                	je     801051aa <uartgetc+0x28>
80105198:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010519d:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010519e:	0f b6 c0             	movzbl %al,%eax
}
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    
    return -1;
801051a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a8:	eb f7                	jmp    801051a1 <uartgetc+0x1f>
    return -1;
801051aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051af:	eb f0                	jmp    801051a1 <uartgetc+0x1f>

801051b1 <uartputc>:
  if(!uart)
801051b1:	83 3d bc 95 10 80 00 	cmpl   $0x0,0x801095bc
801051b8:	74 4f                	je     80105209 <uartputc+0x58>
{
801051ba:	55                   	push   %ebp
801051bb:	89 e5                	mov    %esp,%ebp
801051bd:	56                   	push   %esi
801051be:	53                   	push   %ebx
801051bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051c4:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051c5:	a8 20                	test   $0x20,%al
801051c7:	75 30                	jne    801051f9 <uartputc+0x48>
    microdelay(10);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	6a 0a                	push   $0xa
801051ce:	e8 a6 d2 ff ff       	call   80102479 <microdelay>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	bb 7f 00 00 00       	mov    $0x7f,%ebx
801051db:	be fd 03 00 00       	mov    $0x3fd,%esi
801051e0:	89 f2                	mov    %esi,%edx
801051e2:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051e3:	a8 20                	test   $0x20,%al
801051e5:	75 12                	jne    801051f9 <uartputc+0x48>
    microdelay(10);
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	6a 0a                	push   $0xa
801051ec:	e8 88 d2 ff ff       	call   80102479 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	83 eb 01             	sub    $0x1,%ebx
801051f7:	75 e7                	jne    801051e0 <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801051f9:	8b 45 08             	mov    0x8(%ebp),%eax
801051fc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105201:	ee                   	out    %al,(%dx)
}
80105202:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105205:	5b                   	pop    %ebx
80105206:	5e                   	pop    %esi
80105207:	5d                   	pop    %ebp
80105208:	c3                   	ret    
80105209:	f3 c3                	repz ret 

8010520b <uartinit>:
{
8010520b:	55                   	push   %ebp
8010520c:	89 e5                	mov    %esp,%ebp
8010520e:	56                   	push   %esi
8010520f:	53                   	push   %ebx
80105210:	b9 00 00 00 00       	mov    $0x0,%ecx
80105215:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010521a:	89 c8                	mov    %ecx,%eax
8010521c:	ee                   	out    %al,(%dx)
8010521d:	be fb 03 00 00       	mov    $0x3fb,%esi
80105222:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105227:	89 f2                	mov    %esi,%edx
80105229:	ee                   	out    %al,(%dx)
8010522a:	b8 0c 00 00 00       	mov    $0xc,%eax
8010522f:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105234:	ee                   	out    %al,(%dx)
80105235:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010523a:	89 c8                	mov    %ecx,%eax
8010523c:	89 da                	mov    %ebx,%edx
8010523e:	ee                   	out    %al,(%dx)
8010523f:	b8 03 00 00 00       	mov    $0x3,%eax
80105244:	89 f2                	mov    %esi,%edx
80105246:	ee                   	out    %al,(%dx)
80105247:	ba fc 03 00 00       	mov    $0x3fc,%edx
8010524c:	89 c8                	mov    %ecx,%eax
8010524e:	ee                   	out    %al,(%dx)
8010524f:	b8 01 00 00 00       	mov    $0x1,%eax
80105254:	89 da                	mov    %ebx,%edx
80105256:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105257:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010525c:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010525d:	3c ff                	cmp    $0xff,%al
8010525f:	74 48                	je     801052a9 <uartinit+0x9e>
  uart = 1;
80105261:	c7 05 bc 95 10 80 01 	movl   $0x1,0x801095bc
80105268:	00 00 00 
8010526b:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105270:	ec                   	in     (%dx),%al
80105271:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105276:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105277:	83 ec 08             	sub    $0x8,%esp
8010527a:	6a 00                	push   $0x0
8010527c:	6a 04                	push   $0x4
8010527e:	e8 83 cd ff ff       	call   80102006 <ioapicenable>
80105283:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105286:	bb 44 6e 10 80       	mov    $0x80106e44,%ebx
8010528b:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	0f be c0             	movsbl %al,%eax
80105296:	50                   	push   %eax
80105297:	e8 15 ff ff ff       	call   801051b1 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010529c:	83 c3 01             	add    $0x1,%ebx
8010529f:	0f b6 03             	movzbl (%ebx),%eax
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	84 c0                	test   %al,%al
801052a7:	75 e7                	jne    80105290 <uartinit+0x85>
}
801052a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ac:	5b                   	pop    %ebx
801052ad:	5e                   	pop    %esi
801052ae:	5d                   	pop    %ebp
801052af:	c3                   	ret    

801052b0 <uartintr>:

void
uartintr(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801052b6:	68 82 51 10 80       	push   $0x80105182
801052bb:	e8 7b b4 ff ff       	call   8010073b <consoleintr>
}
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	c9                   	leave  
801052c4:	c3                   	ret    

801052c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801052c5:	6a 00                	push   $0x0
  pushl $0
801052c7:	6a 00                	push   $0x0
  jmp alltraps
801052c9:	e9 cf fb ff ff       	jmp    80104e9d <alltraps>

801052ce <vector1>:
.globl vector1
vector1:
  pushl $0
801052ce:	6a 00                	push   $0x0
  pushl $1
801052d0:	6a 01                	push   $0x1
  jmp alltraps
801052d2:	e9 c6 fb ff ff       	jmp    80104e9d <alltraps>

801052d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801052d7:	6a 00                	push   $0x0
  pushl $2
801052d9:	6a 02                	push   $0x2
  jmp alltraps
801052db:	e9 bd fb ff ff       	jmp    80104e9d <alltraps>

801052e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801052e0:	6a 00                	push   $0x0
  pushl $3
801052e2:	6a 03                	push   $0x3
  jmp alltraps
801052e4:	e9 b4 fb ff ff       	jmp    80104e9d <alltraps>

801052e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801052e9:	6a 00                	push   $0x0
  pushl $4
801052eb:	6a 04                	push   $0x4
  jmp alltraps
801052ed:	e9 ab fb ff ff       	jmp    80104e9d <alltraps>

801052f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801052f2:	6a 00                	push   $0x0
  pushl $5
801052f4:	6a 05                	push   $0x5
  jmp alltraps
801052f6:	e9 a2 fb ff ff       	jmp    80104e9d <alltraps>

801052fb <vector6>:
.globl vector6
vector6:
  pushl $0
801052fb:	6a 00                	push   $0x0
  pushl $6
801052fd:	6a 06                	push   $0x6
  jmp alltraps
801052ff:	e9 99 fb ff ff       	jmp    80104e9d <alltraps>

80105304 <vector7>:
.globl vector7
vector7:
  pushl $0
80105304:	6a 00                	push   $0x0
  pushl $7
80105306:	6a 07                	push   $0x7
  jmp alltraps
80105308:	e9 90 fb ff ff       	jmp    80104e9d <alltraps>

8010530d <vector8>:
.globl vector8
vector8:
  pushl $8
8010530d:	6a 08                	push   $0x8
  jmp alltraps
8010530f:	e9 89 fb ff ff       	jmp    80104e9d <alltraps>

80105314 <vector9>:
.globl vector9
vector9:
  pushl $0
80105314:	6a 00                	push   $0x0
  pushl $9
80105316:	6a 09                	push   $0x9
  jmp alltraps
80105318:	e9 80 fb ff ff       	jmp    80104e9d <alltraps>

8010531d <vector10>:
.globl vector10
vector10:
  pushl $10
8010531d:	6a 0a                	push   $0xa
  jmp alltraps
8010531f:	e9 79 fb ff ff       	jmp    80104e9d <alltraps>

80105324 <vector11>:
.globl vector11
vector11:
  pushl $11
80105324:	6a 0b                	push   $0xb
  jmp alltraps
80105326:	e9 72 fb ff ff       	jmp    80104e9d <alltraps>

8010532b <vector12>:
.globl vector12
vector12:
  pushl $12
8010532b:	6a 0c                	push   $0xc
  jmp alltraps
8010532d:	e9 6b fb ff ff       	jmp    80104e9d <alltraps>

80105332 <vector13>:
.globl vector13
vector13:
  pushl $13
80105332:	6a 0d                	push   $0xd
  jmp alltraps
80105334:	e9 64 fb ff ff       	jmp    80104e9d <alltraps>

80105339 <vector14>:
.globl vector14
vector14:
  pushl $14
80105339:	6a 0e                	push   $0xe
  jmp alltraps
8010533b:	e9 5d fb ff ff       	jmp    80104e9d <alltraps>

80105340 <vector15>:
.globl vector15
vector15:
  pushl $0
80105340:	6a 00                	push   $0x0
  pushl $15
80105342:	6a 0f                	push   $0xf
  jmp alltraps
80105344:	e9 54 fb ff ff       	jmp    80104e9d <alltraps>

80105349 <vector16>:
.globl vector16
vector16:
  pushl $0
80105349:	6a 00                	push   $0x0
  pushl $16
8010534b:	6a 10                	push   $0x10
  jmp alltraps
8010534d:	e9 4b fb ff ff       	jmp    80104e9d <alltraps>

80105352 <vector17>:
.globl vector17
vector17:
  pushl $17
80105352:	6a 11                	push   $0x11
  jmp alltraps
80105354:	e9 44 fb ff ff       	jmp    80104e9d <alltraps>

80105359 <vector18>:
.globl vector18
vector18:
  pushl $0
80105359:	6a 00                	push   $0x0
  pushl $18
8010535b:	6a 12                	push   $0x12
  jmp alltraps
8010535d:	e9 3b fb ff ff       	jmp    80104e9d <alltraps>

80105362 <vector19>:
.globl vector19
vector19:
  pushl $0
80105362:	6a 00                	push   $0x0
  pushl $19
80105364:	6a 13                	push   $0x13
  jmp alltraps
80105366:	e9 32 fb ff ff       	jmp    80104e9d <alltraps>

8010536b <vector20>:
.globl vector20
vector20:
  pushl $0
8010536b:	6a 00                	push   $0x0
  pushl $20
8010536d:	6a 14                	push   $0x14
  jmp alltraps
8010536f:	e9 29 fb ff ff       	jmp    80104e9d <alltraps>

80105374 <vector21>:
.globl vector21
vector21:
  pushl $0
80105374:	6a 00                	push   $0x0
  pushl $21
80105376:	6a 15                	push   $0x15
  jmp alltraps
80105378:	e9 20 fb ff ff       	jmp    80104e9d <alltraps>

8010537d <vector22>:
.globl vector22
vector22:
  pushl $0
8010537d:	6a 00                	push   $0x0
  pushl $22
8010537f:	6a 16                	push   $0x16
  jmp alltraps
80105381:	e9 17 fb ff ff       	jmp    80104e9d <alltraps>

80105386 <vector23>:
.globl vector23
vector23:
  pushl $0
80105386:	6a 00                	push   $0x0
  pushl $23
80105388:	6a 17                	push   $0x17
  jmp alltraps
8010538a:	e9 0e fb ff ff       	jmp    80104e9d <alltraps>

8010538f <vector24>:
.globl vector24
vector24:
  pushl $0
8010538f:	6a 00                	push   $0x0
  pushl $24
80105391:	6a 18                	push   $0x18
  jmp alltraps
80105393:	e9 05 fb ff ff       	jmp    80104e9d <alltraps>

80105398 <vector25>:
.globl vector25
vector25:
  pushl $0
80105398:	6a 00                	push   $0x0
  pushl $25
8010539a:	6a 19                	push   $0x19
  jmp alltraps
8010539c:	e9 fc fa ff ff       	jmp    80104e9d <alltraps>

801053a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801053a1:	6a 00                	push   $0x0
  pushl $26
801053a3:	6a 1a                	push   $0x1a
  jmp alltraps
801053a5:	e9 f3 fa ff ff       	jmp    80104e9d <alltraps>

801053aa <vector27>:
.globl vector27
vector27:
  pushl $0
801053aa:	6a 00                	push   $0x0
  pushl $27
801053ac:	6a 1b                	push   $0x1b
  jmp alltraps
801053ae:	e9 ea fa ff ff       	jmp    80104e9d <alltraps>

801053b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801053b3:	6a 00                	push   $0x0
  pushl $28
801053b5:	6a 1c                	push   $0x1c
  jmp alltraps
801053b7:	e9 e1 fa ff ff       	jmp    80104e9d <alltraps>

801053bc <vector29>:
.globl vector29
vector29:
  pushl $0
801053bc:	6a 00                	push   $0x0
  pushl $29
801053be:	6a 1d                	push   $0x1d
  jmp alltraps
801053c0:	e9 d8 fa ff ff       	jmp    80104e9d <alltraps>

801053c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801053c5:	6a 00                	push   $0x0
  pushl $30
801053c7:	6a 1e                	push   $0x1e
  jmp alltraps
801053c9:	e9 cf fa ff ff       	jmp    80104e9d <alltraps>

801053ce <vector31>:
.globl vector31
vector31:
  pushl $0
801053ce:	6a 00                	push   $0x0
  pushl $31
801053d0:	6a 1f                	push   $0x1f
  jmp alltraps
801053d2:	e9 c6 fa ff ff       	jmp    80104e9d <alltraps>

801053d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801053d7:	6a 00                	push   $0x0
  pushl $32
801053d9:	6a 20                	push   $0x20
  jmp alltraps
801053db:	e9 bd fa ff ff       	jmp    80104e9d <alltraps>

801053e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801053e0:	6a 00                	push   $0x0
  pushl $33
801053e2:	6a 21                	push   $0x21
  jmp alltraps
801053e4:	e9 b4 fa ff ff       	jmp    80104e9d <alltraps>

801053e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801053e9:	6a 00                	push   $0x0
  pushl $34
801053eb:	6a 22                	push   $0x22
  jmp alltraps
801053ed:	e9 ab fa ff ff       	jmp    80104e9d <alltraps>

801053f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801053f2:	6a 00                	push   $0x0
  pushl $35
801053f4:	6a 23                	push   $0x23
  jmp alltraps
801053f6:	e9 a2 fa ff ff       	jmp    80104e9d <alltraps>

801053fb <vector36>:
.globl vector36
vector36:
  pushl $0
801053fb:	6a 00                	push   $0x0
  pushl $36
801053fd:	6a 24                	push   $0x24
  jmp alltraps
801053ff:	e9 99 fa ff ff       	jmp    80104e9d <alltraps>

80105404 <vector37>:
.globl vector37
vector37:
  pushl $0
80105404:	6a 00                	push   $0x0
  pushl $37
80105406:	6a 25                	push   $0x25
  jmp alltraps
80105408:	e9 90 fa ff ff       	jmp    80104e9d <alltraps>

8010540d <vector38>:
.globl vector38
vector38:
  pushl $0
8010540d:	6a 00                	push   $0x0
  pushl $38
8010540f:	6a 26                	push   $0x26
  jmp alltraps
80105411:	e9 87 fa ff ff       	jmp    80104e9d <alltraps>

80105416 <vector39>:
.globl vector39
vector39:
  pushl $0
80105416:	6a 00                	push   $0x0
  pushl $39
80105418:	6a 27                	push   $0x27
  jmp alltraps
8010541a:	e9 7e fa ff ff       	jmp    80104e9d <alltraps>

8010541f <vector40>:
.globl vector40
vector40:
  pushl $0
8010541f:	6a 00                	push   $0x0
  pushl $40
80105421:	6a 28                	push   $0x28
  jmp alltraps
80105423:	e9 75 fa ff ff       	jmp    80104e9d <alltraps>

80105428 <vector41>:
.globl vector41
vector41:
  pushl $0
80105428:	6a 00                	push   $0x0
  pushl $41
8010542a:	6a 29                	push   $0x29
  jmp alltraps
8010542c:	e9 6c fa ff ff       	jmp    80104e9d <alltraps>

80105431 <vector42>:
.globl vector42
vector42:
  pushl $0
80105431:	6a 00                	push   $0x0
  pushl $42
80105433:	6a 2a                	push   $0x2a
  jmp alltraps
80105435:	e9 63 fa ff ff       	jmp    80104e9d <alltraps>

8010543a <vector43>:
.globl vector43
vector43:
  pushl $0
8010543a:	6a 00                	push   $0x0
  pushl $43
8010543c:	6a 2b                	push   $0x2b
  jmp alltraps
8010543e:	e9 5a fa ff ff       	jmp    80104e9d <alltraps>

80105443 <vector44>:
.globl vector44
vector44:
  pushl $0
80105443:	6a 00                	push   $0x0
  pushl $44
80105445:	6a 2c                	push   $0x2c
  jmp alltraps
80105447:	e9 51 fa ff ff       	jmp    80104e9d <alltraps>

8010544c <vector45>:
.globl vector45
vector45:
  pushl $0
8010544c:	6a 00                	push   $0x0
  pushl $45
8010544e:	6a 2d                	push   $0x2d
  jmp alltraps
80105450:	e9 48 fa ff ff       	jmp    80104e9d <alltraps>

80105455 <vector46>:
.globl vector46
vector46:
  pushl $0
80105455:	6a 00                	push   $0x0
  pushl $46
80105457:	6a 2e                	push   $0x2e
  jmp alltraps
80105459:	e9 3f fa ff ff       	jmp    80104e9d <alltraps>

8010545e <vector47>:
.globl vector47
vector47:
  pushl $0
8010545e:	6a 00                	push   $0x0
  pushl $47
80105460:	6a 2f                	push   $0x2f
  jmp alltraps
80105462:	e9 36 fa ff ff       	jmp    80104e9d <alltraps>

80105467 <vector48>:
.globl vector48
vector48:
  pushl $0
80105467:	6a 00                	push   $0x0
  pushl $48
80105469:	6a 30                	push   $0x30
  jmp alltraps
8010546b:	e9 2d fa ff ff       	jmp    80104e9d <alltraps>

80105470 <vector49>:
.globl vector49
vector49:
  pushl $0
80105470:	6a 00                	push   $0x0
  pushl $49
80105472:	6a 31                	push   $0x31
  jmp alltraps
80105474:	e9 24 fa ff ff       	jmp    80104e9d <alltraps>

80105479 <vector50>:
.globl vector50
vector50:
  pushl $0
80105479:	6a 00                	push   $0x0
  pushl $50
8010547b:	6a 32                	push   $0x32
  jmp alltraps
8010547d:	e9 1b fa ff ff       	jmp    80104e9d <alltraps>

80105482 <vector51>:
.globl vector51
vector51:
  pushl $0
80105482:	6a 00                	push   $0x0
  pushl $51
80105484:	6a 33                	push   $0x33
  jmp alltraps
80105486:	e9 12 fa ff ff       	jmp    80104e9d <alltraps>

8010548b <vector52>:
.globl vector52
vector52:
  pushl $0
8010548b:	6a 00                	push   $0x0
  pushl $52
8010548d:	6a 34                	push   $0x34
  jmp alltraps
8010548f:	e9 09 fa ff ff       	jmp    80104e9d <alltraps>

80105494 <vector53>:
.globl vector53
vector53:
  pushl $0
80105494:	6a 00                	push   $0x0
  pushl $53
80105496:	6a 35                	push   $0x35
  jmp alltraps
80105498:	e9 00 fa ff ff       	jmp    80104e9d <alltraps>

8010549d <vector54>:
.globl vector54
vector54:
  pushl $0
8010549d:	6a 00                	push   $0x0
  pushl $54
8010549f:	6a 36                	push   $0x36
  jmp alltraps
801054a1:	e9 f7 f9 ff ff       	jmp    80104e9d <alltraps>

801054a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801054a6:	6a 00                	push   $0x0
  pushl $55
801054a8:	6a 37                	push   $0x37
  jmp alltraps
801054aa:	e9 ee f9 ff ff       	jmp    80104e9d <alltraps>

801054af <vector56>:
.globl vector56
vector56:
  pushl $0
801054af:	6a 00                	push   $0x0
  pushl $56
801054b1:	6a 38                	push   $0x38
  jmp alltraps
801054b3:	e9 e5 f9 ff ff       	jmp    80104e9d <alltraps>

801054b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801054b8:	6a 00                	push   $0x0
  pushl $57
801054ba:	6a 39                	push   $0x39
  jmp alltraps
801054bc:	e9 dc f9 ff ff       	jmp    80104e9d <alltraps>

801054c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801054c1:	6a 00                	push   $0x0
  pushl $58
801054c3:	6a 3a                	push   $0x3a
  jmp alltraps
801054c5:	e9 d3 f9 ff ff       	jmp    80104e9d <alltraps>

801054ca <vector59>:
.globl vector59
vector59:
  pushl $0
801054ca:	6a 00                	push   $0x0
  pushl $59
801054cc:	6a 3b                	push   $0x3b
  jmp alltraps
801054ce:	e9 ca f9 ff ff       	jmp    80104e9d <alltraps>

801054d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801054d3:	6a 00                	push   $0x0
  pushl $60
801054d5:	6a 3c                	push   $0x3c
  jmp alltraps
801054d7:	e9 c1 f9 ff ff       	jmp    80104e9d <alltraps>

801054dc <vector61>:
.globl vector61
vector61:
  pushl $0
801054dc:	6a 00                	push   $0x0
  pushl $61
801054de:	6a 3d                	push   $0x3d
  jmp alltraps
801054e0:	e9 b8 f9 ff ff       	jmp    80104e9d <alltraps>

801054e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801054e5:	6a 00                	push   $0x0
  pushl $62
801054e7:	6a 3e                	push   $0x3e
  jmp alltraps
801054e9:	e9 af f9 ff ff       	jmp    80104e9d <alltraps>

801054ee <vector63>:
.globl vector63
vector63:
  pushl $0
801054ee:	6a 00                	push   $0x0
  pushl $63
801054f0:	6a 3f                	push   $0x3f
  jmp alltraps
801054f2:	e9 a6 f9 ff ff       	jmp    80104e9d <alltraps>

801054f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801054f7:	6a 00                	push   $0x0
  pushl $64
801054f9:	6a 40                	push   $0x40
  jmp alltraps
801054fb:	e9 9d f9 ff ff       	jmp    80104e9d <alltraps>

80105500 <vector65>:
.globl vector65
vector65:
  pushl $0
80105500:	6a 00                	push   $0x0
  pushl $65
80105502:	6a 41                	push   $0x41
  jmp alltraps
80105504:	e9 94 f9 ff ff       	jmp    80104e9d <alltraps>

80105509 <vector66>:
.globl vector66
vector66:
  pushl $0
80105509:	6a 00                	push   $0x0
  pushl $66
8010550b:	6a 42                	push   $0x42
  jmp alltraps
8010550d:	e9 8b f9 ff ff       	jmp    80104e9d <alltraps>

80105512 <vector67>:
.globl vector67
vector67:
  pushl $0
80105512:	6a 00                	push   $0x0
  pushl $67
80105514:	6a 43                	push   $0x43
  jmp alltraps
80105516:	e9 82 f9 ff ff       	jmp    80104e9d <alltraps>

8010551b <vector68>:
.globl vector68
vector68:
  pushl $0
8010551b:	6a 00                	push   $0x0
  pushl $68
8010551d:	6a 44                	push   $0x44
  jmp alltraps
8010551f:	e9 79 f9 ff ff       	jmp    80104e9d <alltraps>

80105524 <vector69>:
.globl vector69
vector69:
  pushl $0
80105524:	6a 00                	push   $0x0
  pushl $69
80105526:	6a 45                	push   $0x45
  jmp alltraps
80105528:	e9 70 f9 ff ff       	jmp    80104e9d <alltraps>

8010552d <vector70>:
.globl vector70
vector70:
  pushl $0
8010552d:	6a 00                	push   $0x0
  pushl $70
8010552f:	6a 46                	push   $0x46
  jmp alltraps
80105531:	e9 67 f9 ff ff       	jmp    80104e9d <alltraps>

80105536 <vector71>:
.globl vector71
vector71:
  pushl $0
80105536:	6a 00                	push   $0x0
  pushl $71
80105538:	6a 47                	push   $0x47
  jmp alltraps
8010553a:	e9 5e f9 ff ff       	jmp    80104e9d <alltraps>

8010553f <vector72>:
.globl vector72
vector72:
  pushl $0
8010553f:	6a 00                	push   $0x0
  pushl $72
80105541:	6a 48                	push   $0x48
  jmp alltraps
80105543:	e9 55 f9 ff ff       	jmp    80104e9d <alltraps>

80105548 <vector73>:
.globl vector73
vector73:
  pushl $0
80105548:	6a 00                	push   $0x0
  pushl $73
8010554a:	6a 49                	push   $0x49
  jmp alltraps
8010554c:	e9 4c f9 ff ff       	jmp    80104e9d <alltraps>

80105551 <vector74>:
.globl vector74
vector74:
  pushl $0
80105551:	6a 00                	push   $0x0
  pushl $74
80105553:	6a 4a                	push   $0x4a
  jmp alltraps
80105555:	e9 43 f9 ff ff       	jmp    80104e9d <alltraps>

8010555a <vector75>:
.globl vector75
vector75:
  pushl $0
8010555a:	6a 00                	push   $0x0
  pushl $75
8010555c:	6a 4b                	push   $0x4b
  jmp alltraps
8010555e:	e9 3a f9 ff ff       	jmp    80104e9d <alltraps>

80105563 <vector76>:
.globl vector76
vector76:
  pushl $0
80105563:	6a 00                	push   $0x0
  pushl $76
80105565:	6a 4c                	push   $0x4c
  jmp alltraps
80105567:	e9 31 f9 ff ff       	jmp    80104e9d <alltraps>

8010556c <vector77>:
.globl vector77
vector77:
  pushl $0
8010556c:	6a 00                	push   $0x0
  pushl $77
8010556e:	6a 4d                	push   $0x4d
  jmp alltraps
80105570:	e9 28 f9 ff ff       	jmp    80104e9d <alltraps>

80105575 <vector78>:
.globl vector78
vector78:
  pushl $0
80105575:	6a 00                	push   $0x0
  pushl $78
80105577:	6a 4e                	push   $0x4e
  jmp alltraps
80105579:	e9 1f f9 ff ff       	jmp    80104e9d <alltraps>

8010557e <vector79>:
.globl vector79
vector79:
  pushl $0
8010557e:	6a 00                	push   $0x0
  pushl $79
80105580:	6a 4f                	push   $0x4f
  jmp alltraps
80105582:	e9 16 f9 ff ff       	jmp    80104e9d <alltraps>

80105587 <vector80>:
.globl vector80
vector80:
  pushl $0
80105587:	6a 00                	push   $0x0
  pushl $80
80105589:	6a 50                	push   $0x50
  jmp alltraps
8010558b:	e9 0d f9 ff ff       	jmp    80104e9d <alltraps>

80105590 <vector81>:
.globl vector81
vector81:
  pushl $0
80105590:	6a 00                	push   $0x0
  pushl $81
80105592:	6a 51                	push   $0x51
  jmp alltraps
80105594:	e9 04 f9 ff ff       	jmp    80104e9d <alltraps>

80105599 <vector82>:
.globl vector82
vector82:
  pushl $0
80105599:	6a 00                	push   $0x0
  pushl $82
8010559b:	6a 52                	push   $0x52
  jmp alltraps
8010559d:	e9 fb f8 ff ff       	jmp    80104e9d <alltraps>

801055a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801055a2:	6a 00                	push   $0x0
  pushl $83
801055a4:	6a 53                	push   $0x53
  jmp alltraps
801055a6:	e9 f2 f8 ff ff       	jmp    80104e9d <alltraps>

801055ab <vector84>:
.globl vector84
vector84:
  pushl $0
801055ab:	6a 00                	push   $0x0
  pushl $84
801055ad:	6a 54                	push   $0x54
  jmp alltraps
801055af:	e9 e9 f8 ff ff       	jmp    80104e9d <alltraps>

801055b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801055b4:	6a 00                	push   $0x0
  pushl $85
801055b6:	6a 55                	push   $0x55
  jmp alltraps
801055b8:	e9 e0 f8 ff ff       	jmp    80104e9d <alltraps>

801055bd <vector86>:
.globl vector86
vector86:
  pushl $0
801055bd:	6a 00                	push   $0x0
  pushl $86
801055bf:	6a 56                	push   $0x56
  jmp alltraps
801055c1:	e9 d7 f8 ff ff       	jmp    80104e9d <alltraps>

801055c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801055c6:	6a 00                	push   $0x0
  pushl $87
801055c8:	6a 57                	push   $0x57
  jmp alltraps
801055ca:	e9 ce f8 ff ff       	jmp    80104e9d <alltraps>

801055cf <vector88>:
.globl vector88
vector88:
  pushl $0
801055cf:	6a 00                	push   $0x0
  pushl $88
801055d1:	6a 58                	push   $0x58
  jmp alltraps
801055d3:	e9 c5 f8 ff ff       	jmp    80104e9d <alltraps>

801055d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801055d8:	6a 00                	push   $0x0
  pushl $89
801055da:	6a 59                	push   $0x59
  jmp alltraps
801055dc:	e9 bc f8 ff ff       	jmp    80104e9d <alltraps>

801055e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801055e1:	6a 00                	push   $0x0
  pushl $90
801055e3:	6a 5a                	push   $0x5a
  jmp alltraps
801055e5:	e9 b3 f8 ff ff       	jmp    80104e9d <alltraps>

801055ea <vector91>:
.globl vector91
vector91:
  pushl $0
801055ea:	6a 00                	push   $0x0
  pushl $91
801055ec:	6a 5b                	push   $0x5b
  jmp alltraps
801055ee:	e9 aa f8 ff ff       	jmp    80104e9d <alltraps>

801055f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801055f3:	6a 00                	push   $0x0
  pushl $92
801055f5:	6a 5c                	push   $0x5c
  jmp alltraps
801055f7:	e9 a1 f8 ff ff       	jmp    80104e9d <alltraps>

801055fc <vector93>:
.globl vector93
vector93:
  pushl $0
801055fc:	6a 00                	push   $0x0
  pushl $93
801055fe:	6a 5d                	push   $0x5d
  jmp alltraps
80105600:	e9 98 f8 ff ff       	jmp    80104e9d <alltraps>

80105605 <vector94>:
.globl vector94
vector94:
  pushl $0
80105605:	6a 00                	push   $0x0
  pushl $94
80105607:	6a 5e                	push   $0x5e
  jmp alltraps
80105609:	e9 8f f8 ff ff       	jmp    80104e9d <alltraps>

8010560e <vector95>:
.globl vector95
vector95:
  pushl $0
8010560e:	6a 00                	push   $0x0
  pushl $95
80105610:	6a 5f                	push   $0x5f
  jmp alltraps
80105612:	e9 86 f8 ff ff       	jmp    80104e9d <alltraps>

80105617 <vector96>:
.globl vector96
vector96:
  pushl $0
80105617:	6a 00                	push   $0x0
  pushl $96
80105619:	6a 60                	push   $0x60
  jmp alltraps
8010561b:	e9 7d f8 ff ff       	jmp    80104e9d <alltraps>

80105620 <vector97>:
.globl vector97
vector97:
  pushl $0
80105620:	6a 00                	push   $0x0
  pushl $97
80105622:	6a 61                	push   $0x61
  jmp alltraps
80105624:	e9 74 f8 ff ff       	jmp    80104e9d <alltraps>

80105629 <vector98>:
.globl vector98
vector98:
  pushl $0
80105629:	6a 00                	push   $0x0
  pushl $98
8010562b:	6a 62                	push   $0x62
  jmp alltraps
8010562d:	e9 6b f8 ff ff       	jmp    80104e9d <alltraps>

80105632 <vector99>:
.globl vector99
vector99:
  pushl $0
80105632:	6a 00                	push   $0x0
  pushl $99
80105634:	6a 63                	push   $0x63
  jmp alltraps
80105636:	e9 62 f8 ff ff       	jmp    80104e9d <alltraps>

8010563b <vector100>:
.globl vector100
vector100:
  pushl $0
8010563b:	6a 00                	push   $0x0
  pushl $100
8010563d:	6a 64                	push   $0x64
  jmp alltraps
8010563f:	e9 59 f8 ff ff       	jmp    80104e9d <alltraps>

80105644 <vector101>:
.globl vector101
vector101:
  pushl $0
80105644:	6a 00                	push   $0x0
  pushl $101
80105646:	6a 65                	push   $0x65
  jmp alltraps
80105648:	e9 50 f8 ff ff       	jmp    80104e9d <alltraps>

8010564d <vector102>:
.globl vector102
vector102:
  pushl $0
8010564d:	6a 00                	push   $0x0
  pushl $102
8010564f:	6a 66                	push   $0x66
  jmp alltraps
80105651:	e9 47 f8 ff ff       	jmp    80104e9d <alltraps>

80105656 <vector103>:
.globl vector103
vector103:
  pushl $0
80105656:	6a 00                	push   $0x0
  pushl $103
80105658:	6a 67                	push   $0x67
  jmp alltraps
8010565a:	e9 3e f8 ff ff       	jmp    80104e9d <alltraps>

8010565f <vector104>:
.globl vector104
vector104:
  pushl $0
8010565f:	6a 00                	push   $0x0
  pushl $104
80105661:	6a 68                	push   $0x68
  jmp alltraps
80105663:	e9 35 f8 ff ff       	jmp    80104e9d <alltraps>

80105668 <vector105>:
.globl vector105
vector105:
  pushl $0
80105668:	6a 00                	push   $0x0
  pushl $105
8010566a:	6a 69                	push   $0x69
  jmp alltraps
8010566c:	e9 2c f8 ff ff       	jmp    80104e9d <alltraps>

80105671 <vector106>:
.globl vector106
vector106:
  pushl $0
80105671:	6a 00                	push   $0x0
  pushl $106
80105673:	6a 6a                	push   $0x6a
  jmp alltraps
80105675:	e9 23 f8 ff ff       	jmp    80104e9d <alltraps>

8010567a <vector107>:
.globl vector107
vector107:
  pushl $0
8010567a:	6a 00                	push   $0x0
  pushl $107
8010567c:	6a 6b                	push   $0x6b
  jmp alltraps
8010567e:	e9 1a f8 ff ff       	jmp    80104e9d <alltraps>

80105683 <vector108>:
.globl vector108
vector108:
  pushl $0
80105683:	6a 00                	push   $0x0
  pushl $108
80105685:	6a 6c                	push   $0x6c
  jmp alltraps
80105687:	e9 11 f8 ff ff       	jmp    80104e9d <alltraps>

8010568c <vector109>:
.globl vector109
vector109:
  pushl $0
8010568c:	6a 00                	push   $0x0
  pushl $109
8010568e:	6a 6d                	push   $0x6d
  jmp alltraps
80105690:	e9 08 f8 ff ff       	jmp    80104e9d <alltraps>

80105695 <vector110>:
.globl vector110
vector110:
  pushl $0
80105695:	6a 00                	push   $0x0
  pushl $110
80105697:	6a 6e                	push   $0x6e
  jmp alltraps
80105699:	e9 ff f7 ff ff       	jmp    80104e9d <alltraps>

8010569e <vector111>:
.globl vector111
vector111:
  pushl $0
8010569e:	6a 00                	push   $0x0
  pushl $111
801056a0:	6a 6f                	push   $0x6f
  jmp alltraps
801056a2:	e9 f6 f7 ff ff       	jmp    80104e9d <alltraps>

801056a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801056a7:	6a 00                	push   $0x0
  pushl $112
801056a9:	6a 70                	push   $0x70
  jmp alltraps
801056ab:	e9 ed f7 ff ff       	jmp    80104e9d <alltraps>

801056b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801056b0:	6a 00                	push   $0x0
  pushl $113
801056b2:	6a 71                	push   $0x71
  jmp alltraps
801056b4:	e9 e4 f7 ff ff       	jmp    80104e9d <alltraps>

801056b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801056b9:	6a 00                	push   $0x0
  pushl $114
801056bb:	6a 72                	push   $0x72
  jmp alltraps
801056bd:	e9 db f7 ff ff       	jmp    80104e9d <alltraps>

801056c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801056c2:	6a 00                	push   $0x0
  pushl $115
801056c4:	6a 73                	push   $0x73
  jmp alltraps
801056c6:	e9 d2 f7 ff ff       	jmp    80104e9d <alltraps>

801056cb <vector116>:
.globl vector116
vector116:
  pushl $0
801056cb:	6a 00                	push   $0x0
  pushl $116
801056cd:	6a 74                	push   $0x74
  jmp alltraps
801056cf:	e9 c9 f7 ff ff       	jmp    80104e9d <alltraps>

801056d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801056d4:	6a 00                	push   $0x0
  pushl $117
801056d6:	6a 75                	push   $0x75
  jmp alltraps
801056d8:	e9 c0 f7 ff ff       	jmp    80104e9d <alltraps>

801056dd <vector118>:
.globl vector118
vector118:
  pushl $0
801056dd:	6a 00                	push   $0x0
  pushl $118
801056df:	6a 76                	push   $0x76
  jmp alltraps
801056e1:	e9 b7 f7 ff ff       	jmp    80104e9d <alltraps>

801056e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801056e6:	6a 00                	push   $0x0
  pushl $119
801056e8:	6a 77                	push   $0x77
  jmp alltraps
801056ea:	e9 ae f7 ff ff       	jmp    80104e9d <alltraps>

801056ef <vector120>:
.globl vector120
vector120:
  pushl $0
801056ef:	6a 00                	push   $0x0
  pushl $120
801056f1:	6a 78                	push   $0x78
  jmp alltraps
801056f3:	e9 a5 f7 ff ff       	jmp    80104e9d <alltraps>

801056f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801056f8:	6a 00                	push   $0x0
  pushl $121
801056fa:	6a 79                	push   $0x79
  jmp alltraps
801056fc:	e9 9c f7 ff ff       	jmp    80104e9d <alltraps>

80105701 <vector122>:
.globl vector122
vector122:
  pushl $0
80105701:	6a 00                	push   $0x0
  pushl $122
80105703:	6a 7a                	push   $0x7a
  jmp alltraps
80105705:	e9 93 f7 ff ff       	jmp    80104e9d <alltraps>

8010570a <vector123>:
.globl vector123
vector123:
  pushl $0
8010570a:	6a 00                	push   $0x0
  pushl $123
8010570c:	6a 7b                	push   $0x7b
  jmp alltraps
8010570e:	e9 8a f7 ff ff       	jmp    80104e9d <alltraps>

80105713 <vector124>:
.globl vector124
vector124:
  pushl $0
80105713:	6a 00                	push   $0x0
  pushl $124
80105715:	6a 7c                	push   $0x7c
  jmp alltraps
80105717:	e9 81 f7 ff ff       	jmp    80104e9d <alltraps>

8010571c <vector125>:
.globl vector125
vector125:
  pushl $0
8010571c:	6a 00                	push   $0x0
  pushl $125
8010571e:	6a 7d                	push   $0x7d
  jmp alltraps
80105720:	e9 78 f7 ff ff       	jmp    80104e9d <alltraps>

80105725 <vector126>:
.globl vector126
vector126:
  pushl $0
80105725:	6a 00                	push   $0x0
  pushl $126
80105727:	6a 7e                	push   $0x7e
  jmp alltraps
80105729:	e9 6f f7 ff ff       	jmp    80104e9d <alltraps>

8010572e <vector127>:
.globl vector127
vector127:
  pushl $0
8010572e:	6a 00                	push   $0x0
  pushl $127
80105730:	6a 7f                	push   $0x7f
  jmp alltraps
80105732:	e9 66 f7 ff ff       	jmp    80104e9d <alltraps>

80105737 <vector128>:
.globl vector128
vector128:
  pushl $0
80105737:	6a 00                	push   $0x0
  pushl $128
80105739:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010573e:	e9 5a f7 ff ff       	jmp    80104e9d <alltraps>

80105743 <vector129>:
.globl vector129
vector129:
  pushl $0
80105743:	6a 00                	push   $0x0
  pushl $129
80105745:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010574a:	e9 4e f7 ff ff       	jmp    80104e9d <alltraps>

8010574f <vector130>:
.globl vector130
vector130:
  pushl $0
8010574f:	6a 00                	push   $0x0
  pushl $130
80105751:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105756:	e9 42 f7 ff ff       	jmp    80104e9d <alltraps>

8010575b <vector131>:
.globl vector131
vector131:
  pushl $0
8010575b:	6a 00                	push   $0x0
  pushl $131
8010575d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105762:	e9 36 f7 ff ff       	jmp    80104e9d <alltraps>

80105767 <vector132>:
.globl vector132
vector132:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $132
80105769:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010576e:	e9 2a f7 ff ff       	jmp    80104e9d <alltraps>

80105773 <vector133>:
.globl vector133
vector133:
  pushl $0
80105773:	6a 00                	push   $0x0
  pushl $133
80105775:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010577a:	e9 1e f7 ff ff       	jmp    80104e9d <alltraps>

8010577f <vector134>:
.globl vector134
vector134:
  pushl $0
8010577f:	6a 00                	push   $0x0
  pushl $134
80105781:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105786:	e9 12 f7 ff ff       	jmp    80104e9d <alltraps>

8010578b <vector135>:
.globl vector135
vector135:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $135
8010578d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105792:	e9 06 f7 ff ff       	jmp    80104e9d <alltraps>

80105797 <vector136>:
.globl vector136
vector136:
  pushl $0
80105797:	6a 00                	push   $0x0
  pushl $136
80105799:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010579e:	e9 fa f6 ff ff       	jmp    80104e9d <alltraps>

801057a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801057a3:	6a 00                	push   $0x0
  pushl $137
801057a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801057aa:	e9 ee f6 ff ff       	jmp    80104e9d <alltraps>

801057af <vector138>:
.globl vector138
vector138:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $138
801057b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801057b6:	e9 e2 f6 ff ff       	jmp    80104e9d <alltraps>

801057bb <vector139>:
.globl vector139
vector139:
  pushl $0
801057bb:	6a 00                	push   $0x0
  pushl $139
801057bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801057c2:	e9 d6 f6 ff ff       	jmp    80104e9d <alltraps>

801057c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801057c7:	6a 00                	push   $0x0
  pushl $140
801057c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801057ce:	e9 ca f6 ff ff       	jmp    80104e9d <alltraps>

801057d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $141
801057d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801057da:	e9 be f6 ff ff       	jmp    80104e9d <alltraps>

801057df <vector142>:
.globl vector142
vector142:
  pushl $0
801057df:	6a 00                	push   $0x0
  pushl $142
801057e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801057e6:	e9 b2 f6 ff ff       	jmp    80104e9d <alltraps>

801057eb <vector143>:
.globl vector143
vector143:
  pushl $0
801057eb:	6a 00                	push   $0x0
  pushl $143
801057ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801057f2:	e9 a6 f6 ff ff       	jmp    80104e9d <alltraps>

801057f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $144
801057f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801057fe:	e9 9a f6 ff ff       	jmp    80104e9d <alltraps>

80105803 <vector145>:
.globl vector145
vector145:
  pushl $0
80105803:	6a 00                	push   $0x0
  pushl $145
80105805:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010580a:	e9 8e f6 ff ff       	jmp    80104e9d <alltraps>

8010580f <vector146>:
.globl vector146
vector146:
  pushl $0
8010580f:	6a 00                	push   $0x0
  pushl $146
80105811:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105816:	e9 82 f6 ff ff       	jmp    80104e9d <alltraps>

8010581b <vector147>:
.globl vector147
vector147:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $147
8010581d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105822:	e9 76 f6 ff ff       	jmp    80104e9d <alltraps>

80105827 <vector148>:
.globl vector148
vector148:
  pushl $0
80105827:	6a 00                	push   $0x0
  pushl $148
80105829:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010582e:	e9 6a f6 ff ff       	jmp    80104e9d <alltraps>

80105833 <vector149>:
.globl vector149
vector149:
  pushl $0
80105833:	6a 00                	push   $0x0
  pushl $149
80105835:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010583a:	e9 5e f6 ff ff       	jmp    80104e9d <alltraps>

8010583f <vector150>:
.globl vector150
vector150:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $150
80105841:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105846:	e9 52 f6 ff ff       	jmp    80104e9d <alltraps>

8010584b <vector151>:
.globl vector151
vector151:
  pushl $0
8010584b:	6a 00                	push   $0x0
  pushl $151
8010584d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105852:	e9 46 f6 ff ff       	jmp    80104e9d <alltraps>

80105857 <vector152>:
.globl vector152
vector152:
  pushl $0
80105857:	6a 00                	push   $0x0
  pushl $152
80105859:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010585e:	e9 3a f6 ff ff       	jmp    80104e9d <alltraps>

80105863 <vector153>:
.globl vector153
vector153:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $153
80105865:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010586a:	e9 2e f6 ff ff       	jmp    80104e9d <alltraps>

8010586f <vector154>:
.globl vector154
vector154:
  pushl $0
8010586f:	6a 00                	push   $0x0
  pushl $154
80105871:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105876:	e9 22 f6 ff ff       	jmp    80104e9d <alltraps>

8010587b <vector155>:
.globl vector155
vector155:
  pushl $0
8010587b:	6a 00                	push   $0x0
  pushl $155
8010587d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105882:	e9 16 f6 ff ff       	jmp    80104e9d <alltraps>

80105887 <vector156>:
.globl vector156
vector156:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $156
80105889:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010588e:	e9 0a f6 ff ff       	jmp    80104e9d <alltraps>

80105893 <vector157>:
.globl vector157
vector157:
  pushl $0
80105893:	6a 00                	push   $0x0
  pushl $157
80105895:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010589a:	e9 fe f5 ff ff       	jmp    80104e9d <alltraps>

8010589f <vector158>:
.globl vector158
vector158:
  pushl $0
8010589f:	6a 00                	push   $0x0
  pushl $158
801058a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801058a6:	e9 f2 f5 ff ff       	jmp    80104e9d <alltraps>

801058ab <vector159>:
.globl vector159
vector159:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $159
801058ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801058b2:	e9 e6 f5 ff ff       	jmp    80104e9d <alltraps>

801058b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801058b7:	6a 00                	push   $0x0
  pushl $160
801058b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801058be:	e9 da f5 ff ff       	jmp    80104e9d <alltraps>

801058c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801058c3:	6a 00                	push   $0x0
  pushl $161
801058c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801058ca:	e9 ce f5 ff ff       	jmp    80104e9d <alltraps>

801058cf <vector162>:
.globl vector162
vector162:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $162
801058d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801058d6:	e9 c2 f5 ff ff       	jmp    80104e9d <alltraps>

801058db <vector163>:
.globl vector163
vector163:
  pushl $0
801058db:	6a 00                	push   $0x0
  pushl $163
801058dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801058e2:	e9 b6 f5 ff ff       	jmp    80104e9d <alltraps>

801058e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801058e7:	6a 00                	push   $0x0
  pushl $164
801058e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801058ee:	e9 aa f5 ff ff       	jmp    80104e9d <alltraps>

801058f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $165
801058f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801058fa:	e9 9e f5 ff ff       	jmp    80104e9d <alltraps>

801058ff <vector166>:
.globl vector166
vector166:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $166
80105901:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105906:	e9 92 f5 ff ff       	jmp    80104e9d <alltraps>

8010590b <vector167>:
.globl vector167
vector167:
  pushl $0
8010590b:	6a 00                	push   $0x0
  pushl $167
8010590d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105912:	e9 86 f5 ff ff       	jmp    80104e9d <alltraps>

80105917 <vector168>:
.globl vector168
vector168:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $168
80105919:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010591e:	e9 7a f5 ff ff       	jmp    80104e9d <alltraps>

80105923 <vector169>:
.globl vector169
vector169:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $169
80105925:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010592a:	e9 6e f5 ff ff       	jmp    80104e9d <alltraps>

8010592f <vector170>:
.globl vector170
vector170:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $170
80105931:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105936:	e9 62 f5 ff ff       	jmp    80104e9d <alltraps>

8010593b <vector171>:
.globl vector171
vector171:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $171
8010593d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105942:	e9 56 f5 ff ff       	jmp    80104e9d <alltraps>

80105947 <vector172>:
.globl vector172
vector172:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $172
80105949:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010594e:	e9 4a f5 ff ff       	jmp    80104e9d <alltraps>

80105953 <vector173>:
.globl vector173
vector173:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $173
80105955:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010595a:	e9 3e f5 ff ff       	jmp    80104e9d <alltraps>

8010595f <vector174>:
.globl vector174
vector174:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $174
80105961:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105966:	e9 32 f5 ff ff       	jmp    80104e9d <alltraps>

8010596b <vector175>:
.globl vector175
vector175:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $175
8010596d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105972:	e9 26 f5 ff ff       	jmp    80104e9d <alltraps>

80105977 <vector176>:
.globl vector176
vector176:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $176
80105979:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010597e:	e9 1a f5 ff ff       	jmp    80104e9d <alltraps>

80105983 <vector177>:
.globl vector177
vector177:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $177
80105985:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010598a:	e9 0e f5 ff ff       	jmp    80104e9d <alltraps>

8010598f <vector178>:
.globl vector178
vector178:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $178
80105991:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105996:	e9 02 f5 ff ff       	jmp    80104e9d <alltraps>

8010599b <vector179>:
.globl vector179
vector179:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $179
8010599d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801059a2:	e9 f6 f4 ff ff       	jmp    80104e9d <alltraps>

801059a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $180
801059a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801059ae:	e9 ea f4 ff ff       	jmp    80104e9d <alltraps>

801059b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $181
801059b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801059ba:	e9 de f4 ff ff       	jmp    80104e9d <alltraps>

801059bf <vector182>:
.globl vector182
vector182:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $182
801059c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801059c6:	e9 d2 f4 ff ff       	jmp    80104e9d <alltraps>

801059cb <vector183>:
.globl vector183
vector183:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $183
801059cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801059d2:	e9 c6 f4 ff ff       	jmp    80104e9d <alltraps>

801059d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $184
801059d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801059de:	e9 ba f4 ff ff       	jmp    80104e9d <alltraps>

801059e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $185
801059e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801059ea:	e9 ae f4 ff ff       	jmp    80104e9d <alltraps>

801059ef <vector186>:
.globl vector186
vector186:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $186
801059f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801059f6:	e9 a2 f4 ff ff       	jmp    80104e9d <alltraps>

801059fb <vector187>:
.globl vector187
vector187:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $187
801059fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105a02:	e9 96 f4 ff ff       	jmp    80104e9d <alltraps>

80105a07 <vector188>:
.globl vector188
vector188:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $188
80105a09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105a0e:	e9 8a f4 ff ff       	jmp    80104e9d <alltraps>

80105a13 <vector189>:
.globl vector189
vector189:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $189
80105a15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105a1a:	e9 7e f4 ff ff       	jmp    80104e9d <alltraps>

80105a1f <vector190>:
.globl vector190
vector190:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $190
80105a21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a26:	e9 72 f4 ff ff       	jmp    80104e9d <alltraps>

80105a2b <vector191>:
.globl vector191
vector191:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $191
80105a2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105a32:	e9 66 f4 ff ff       	jmp    80104e9d <alltraps>

80105a37 <vector192>:
.globl vector192
vector192:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $192
80105a39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105a3e:	e9 5a f4 ff ff       	jmp    80104e9d <alltraps>

80105a43 <vector193>:
.globl vector193
vector193:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $193
80105a45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105a4a:	e9 4e f4 ff ff       	jmp    80104e9d <alltraps>

80105a4f <vector194>:
.globl vector194
vector194:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $194
80105a51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105a56:	e9 42 f4 ff ff       	jmp    80104e9d <alltraps>

80105a5b <vector195>:
.globl vector195
vector195:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $195
80105a5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105a62:	e9 36 f4 ff ff       	jmp    80104e9d <alltraps>

80105a67 <vector196>:
.globl vector196
vector196:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $196
80105a69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105a6e:	e9 2a f4 ff ff       	jmp    80104e9d <alltraps>

80105a73 <vector197>:
.globl vector197
vector197:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $197
80105a75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105a7a:	e9 1e f4 ff ff       	jmp    80104e9d <alltraps>

80105a7f <vector198>:
.globl vector198
vector198:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $198
80105a81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105a86:	e9 12 f4 ff ff       	jmp    80104e9d <alltraps>

80105a8b <vector199>:
.globl vector199
vector199:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $199
80105a8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105a92:	e9 06 f4 ff ff       	jmp    80104e9d <alltraps>

80105a97 <vector200>:
.globl vector200
vector200:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $200
80105a99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105a9e:	e9 fa f3 ff ff       	jmp    80104e9d <alltraps>

80105aa3 <vector201>:
.globl vector201
vector201:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $201
80105aa5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105aaa:	e9 ee f3 ff ff       	jmp    80104e9d <alltraps>

80105aaf <vector202>:
.globl vector202
vector202:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $202
80105ab1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105ab6:	e9 e2 f3 ff ff       	jmp    80104e9d <alltraps>

80105abb <vector203>:
.globl vector203
vector203:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $203
80105abd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105ac2:	e9 d6 f3 ff ff       	jmp    80104e9d <alltraps>

80105ac7 <vector204>:
.globl vector204
vector204:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $204
80105ac9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105ace:	e9 ca f3 ff ff       	jmp    80104e9d <alltraps>

80105ad3 <vector205>:
.globl vector205
vector205:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $205
80105ad5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105ada:	e9 be f3 ff ff       	jmp    80104e9d <alltraps>

80105adf <vector206>:
.globl vector206
vector206:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $206
80105ae1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105ae6:	e9 b2 f3 ff ff       	jmp    80104e9d <alltraps>

80105aeb <vector207>:
.globl vector207
vector207:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $207
80105aed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105af2:	e9 a6 f3 ff ff       	jmp    80104e9d <alltraps>

80105af7 <vector208>:
.globl vector208
vector208:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $208
80105af9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105afe:	e9 9a f3 ff ff       	jmp    80104e9d <alltraps>

80105b03 <vector209>:
.globl vector209
vector209:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $209
80105b05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b0a:	e9 8e f3 ff ff       	jmp    80104e9d <alltraps>

80105b0f <vector210>:
.globl vector210
vector210:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $210
80105b11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105b16:	e9 82 f3 ff ff       	jmp    80104e9d <alltraps>

80105b1b <vector211>:
.globl vector211
vector211:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $211
80105b1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b22:	e9 76 f3 ff ff       	jmp    80104e9d <alltraps>

80105b27 <vector212>:
.globl vector212
vector212:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $212
80105b29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105b2e:	e9 6a f3 ff ff       	jmp    80104e9d <alltraps>

80105b33 <vector213>:
.globl vector213
vector213:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $213
80105b35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105b3a:	e9 5e f3 ff ff       	jmp    80104e9d <alltraps>

80105b3f <vector214>:
.globl vector214
vector214:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $214
80105b41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105b46:	e9 52 f3 ff ff       	jmp    80104e9d <alltraps>

80105b4b <vector215>:
.globl vector215
vector215:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $215
80105b4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105b52:	e9 46 f3 ff ff       	jmp    80104e9d <alltraps>

80105b57 <vector216>:
.globl vector216
vector216:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $216
80105b59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105b5e:	e9 3a f3 ff ff       	jmp    80104e9d <alltraps>

80105b63 <vector217>:
.globl vector217
vector217:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $217
80105b65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105b6a:	e9 2e f3 ff ff       	jmp    80104e9d <alltraps>

80105b6f <vector218>:
.globl vector218
vector218:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $218
80105b71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105b76:	e9 22 f3 ff ff       	jmp    80104e9d <alltraps>

80105b7b <vector219>:
.globl vector219
vector219:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $219
80105b7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105b82:	e9 16 f3 ff ff       	jmp    80104e9d <alltraps>

80105b87 <vector220>:
.globl vector220
vector220:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $220
80105b89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105b8e:	e9 0a f3 ff ff       	jmp    80104e9d <alltraps>

80105b93 <vector221>:
.globl vector221
vector221:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $221
80105b95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105b9a:	e9 fe f2 ff ff       	jmp    80104e9d <alltraps>

80105b9f <vector222>:
.globl vector222
vector222:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $222
80105ba1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105ba6:	e9 f2 f2 ff ff       	jmp    80104e9d <alltraps>

80105bab <vector223>:
.globl vector223
vector223:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $223
80105bad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105bb2:	e9 e6 f2 ff ff       	jmp    80104e9d <alltraps>

80105bb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $224
80105bb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105bbe:	e9 da f2 ff ff       	jmp    80104e9d <alltraps>

80105bc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $225
80105bc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105bca:	e9 ce f2 ff ff       	jmp    80104e9d <alltraps>

80105bcf <vector226>:
.globl vector226
vector226:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $226
80105bd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105bd6:	e9 c2 f2 ff ff       	jmp    80104e9d <alltraps>

80105bdb <vector227>:
.globl vector227
vector227:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $227
80105bdd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105be2:	e9 b6 f2 ff ff       	jmp    80104e9d <alltraps>

80105be7 <vector228>:
.globl vector228
vector228:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $228
80105be9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105bee:	e9 aa f2 ff ff       	jmp    80104e9d <alltraps>

80105bf3 <vector229>:
.globl vector229
vector229:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $229
80105bf5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105bfa:	e9 9e f2 ff ff       	jmp    80104e9d <alltraps>

80105bff <vector230>:
.globl vector230
vector230:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $230
80105c01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105c06:	e9 92 f2 ff ff       	jmp    80104e9d <alltraps>

80105c0b <vector231>:
.globl vector231
vector231:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $231
80105c0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105c12:	e9 86 f2 ff ff       	jmp    80104e9d <alltraps>

80105c17 <vector232>:
.globl vector232
vector232:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $232
80105c19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c1e:	e9 7a f2 ff ff       	jmp    80104e9d <alltraps>

80105c23 <vector233>:
.globl vector233
vector233:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $233
80105c25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c2a:	e9 6e f2 ff ff       	jmp    80104e9d <alltraps>

80105c2f <vector234>:
.globl vector234
vector234:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $234
80105c31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105c36:	e9 62 f2 ff ff       	jmp    80104e9d <alltraps>

80105c3b <vector235>:
.globl vector235
vector235:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $235
80105c3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105c42:	e9 56 f2 ff ff       	jmp    80104e9d <alltraps>

80105c47 <vector236>:
.globl vector236
vector236:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $236
80105c49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105c4e:	e9 4a f2 ff ff       	jmp    80104e9d <alltraps>

80105c53 <vector237>:
.globl vector237
vector237:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $237
80105c55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105c5a:	e9 3e f2 ff ff       	jmp    80104e9d <alltraps>

80105c5f <vector238>:
.globl vector238
vector238:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $238
80105c61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105c66:	e9 32 f2 ff ff       	jmp    80104e9d <alltraps>

80105c6b <vector239>:
.globl vector239
vector239:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $239
80105c6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105c72:	e9 26 f2 ff ff       	jmp    80104e9d <alltraps>

80105c77 <vector240>:
.globl vector240
vector240:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $240
80105c79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105c7e:	e9 1a f2 ff ff       	jmp    80104e9d <alltraps>

80105c83 <vector241>:
.globl vector241
vector241:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $241
80105c85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105c8a:	e9 0e f2 ff ff       	jmp    80104e9d <alltraps>

80105c8f <vector242>:
.globl vector242
vector242:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $242
80105c91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105c96:	e9 02 f2 ff ff       	jmp    80104e9d <alltraps>

80105c9b <vector243>:
.globl vector243
vector243:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $243
80105c9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105ca2:	e9 f6 f1 ff ff       	jmp    80104e9d <alltraps>

80105ca7 <vector244>:
.globl vector244
vector244:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $244
80105ca9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105cae:	e9 ea f1 ff ff       	jmp    80104e9d <alltraps>

80105cb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $245
80105cb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105cba:	e9 de f1 ff ff       	jmp    80104e9d <alltraps>

80105cbf <vector246>:
.globl vector246
vector246:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $246
80105cc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105cc6:	e9 d2 f1 ff ff       	jmp    80104e9d <alltraps>

80105ccb <vector247>:
.globl vector247
vector247:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $247
80105ccd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105cd2:	e9 c6 f1 ff ff       	jmp    80104e9d <alltraps>

80105cd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $248
80105cd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105cde:	e9 ba f1 ff ff       	jmp    80104e9d <alltraps>

80105ce3 <vector249>:
.globl vector249
vector249:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $249
80105ce5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105cea:	e9 ae f1 ff ff       	jmp    80104e9d <alltraps>

80105cef <vector250>:
.globl vector250
vector250:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $250
80105cf1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105cf6:	e9 a2 f1 ff ff       	jmp    80104e9d <alltraps>

80105cfb <vector251>:
.globl vector251
vector251:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $251
80105cfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105d02:	e9 96 f1 ff ff       	jmp    80104e9d <alltraps>

80105d07 <vector252>:
.globl vector252
vector252:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $252
80105d09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105d0e:	e9 8a f1 ff ff       	jmp    80104e9d <alltraps>

80105d13 <vector253>:
.globl vector253
vector253:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $253
80105d15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105d1a:	e9 7e f1 ff ff       	jmp    80104e9d <alltraps>

80105d1f <vector254>:
.globl vector254
vector254:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $254
80105d21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d26:	e9 72 f1 ff ff       	jmp    80104e9d <alltraps>

80105d2b <vector255>:
.globl vector255
vector255:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $255
80105d2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105d32:	e9 66 f1 ff ff       	jmp    80104e9d <alltraps>

80105d37 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105d37:	55                   	push   %ebp
80105d38:	89 e5                	mov    %esp,%ebp
80105d3a:	57                   	push   %edi
80105d3b:	56                   	push   %esi
80105d3c:	53                   	push   %ebx
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d42:	c1 ea 16             	shr    $0x16,%edx
80105d45:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105d48:	8b 1f                	mov    (%edi),%ebx
80105d4a:	f6 c3 01             	test   $0x1,%bl
80105d4d:	74 21                	je     80105d70 <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105d4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105d55:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d5b:	c1 ee 0a             	shr    $0xa,%esi
80105d5e:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105d64:	01 f3                	add    %esi,%ebx
}
80105d66:	89 d8                	mov    %ebx,%eax
80105d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6b:	5b                   	pop    %ebx
80105d6c:	5e                   	pop    %esi
80105d6d:	5f                   	pop    %edi
80105d6e:	5d                   	pop    %ebp
80105d6f:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105d70:	85 c9                	test   %ecx,%ecx
80105d72:	74 2b                	je     80105d9f <walkpgdir+0x68>
80105d74:	e8 e5 c3 ff ff       	call   8010215e <kalloc>
80105d79:	89 c3                	mov    %eax,%ebx
80105d7b:	85 c0                	test   %eax,%eax
80105d7d:	74 e7                	je     80105d66 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80105d7f:	83 ec 04             	sub    $0x4,%esp
80105d82:	68 00 10 00 00       	push   $0x1000
80105d87:	6a 00                	push   $0x0
80105d89:	50                   	push   %eax
80105d8a:	e8 81 e0 ff ff       	call   80103e10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105d8f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105d95:	83 c8 07             	or     $0x7,%eax
80105d98:	89 07                	mov    %eax,(%edi)
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	eb bc                	jmp    80105d5b <walkpgdir+0x24>
      return 0;
80105d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
80105da4:	eb c0                	jmp    80105d66 <walkpgdir+0x2f>

80105da6 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105da6:	55                   	push   %ebp
80105da7:	89 e5                	mov    %esp,%ebp
80105da9:	57                   	push   %edi
80105daa:	56                   	push   %esi
80105dab:	53                   	push   %ebx
80105dac:	83 ec 1c             	sub    $0x1c,%esp
80105daf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105db2:	89 d0                	mov    %edx,%eax
80105db4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105db9:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105dbb:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80105dbf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105dc5:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105dc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80105dcb:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80105dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dd0:	83 c8 01             	or     $0x1,%eax
80105dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dd6:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105dd9:	b9 01 00 00 00       	mov    $0x1,%ecx
80105dde:	89 da                	mov    %ebx,%edx
80105de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105de3:	e8 4f ff ff ff       	call   80105d37 <walkpgdir>
80105de8:	85 c0                	test   %eax,%eax
80105dea:	74 24                	je     80105e10 <mappages+0x6a>
    if(*pte & PTE_P)
80105dec:	f6 00 01             	testb  $0x1,(%eax)
80105def:	75 12                	jne    80105e03 <mappages+0x5d>
    *pte = pa | perm | PTE_P;
80105df1:	0b 75 dc             	or     -0x24(%ebp),%esi
80105df4:	89 30                	mov    %esi,(%eax)
    if(a == last)
80105df6:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80105df9:	74 22                	je     80105e1d <mappages+0x77>
      break;
    a += PGSIZE;
80105dfb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e01:	eb d3                	jmp    80105dd6 <mappages+0x30>
      panic("remap");
80105e03:	83 ec 0c             	sub    $0xc,%esp
80105e06:	68 4c 6e 10 80       	push   $0x80106e4c
80105e0b:	e8 34 a5 ff ff       	call   80100344 <panic>
      return -1;
80105e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e18:	5b                   	pop    %ebx
80105e19:	5e                   	pop    %esi
80105e1a:	5f                   	pop    %edi
80105e1b:	5d                   	pop    %ebp
80105e1c:	c3                   	ret    
  return 0;
80105e1d:	b8 00 00 00 00       	mov    $0x0,%eax
80105e22:	eb f1                	jmp    80105e15 <mappages+0x6f>

80105e24 <seginit>:
{
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105e2a:	e8 ea d4 ff ff       	call   80103319 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e2f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105e35:	66 c7 80 f8 17 11 80 	movw   $0xffff,-0x7feee808(%eax)
80105e3c:	ff ff 
80105e3e:	66 c7 80 fa 17 11 80 	movw   $0x0,-0x7feee806(%eax)
80105e45:	00 00 
80105e47:	c6 80 fc 17 11 80 00 	movb   $0x0,-0x7feee804(%eax)
80105e4e:	c6 80 fd 17 11 80 9a 	movb   $0x9a,-0x7feee803(%eax)
80105e55:	c6 80 fe 17 11 80 cf 	movb   $0xcf,-0x7feee802(%eax)
80105e5c:	c6 80 ff 17 11 80 00 	movb   $0x0,-0x7feee801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105e63:	66 c7 80 00 18 11 80 	movw   $0xffff,-0x7feee800(%eax)
80105e6a:	ff ff 
80105e6c:	66 c7 80 02 18 11 80 	movw   $0x0,-0x7feee7fe(%eax)
80105e73:	00 00 
80105e75:	c6 80 04 18 11 80 00 	movb   $0x0,-0x7feee7fc(%eax)
80105e7c:	c6 80 05 18 11 80 92 	movb   $0x92,-0x7feee7fb(%eax)
80105e83:	c6 80 06 18 11 80 cf 	movb   $0xcf,-0x7feee7fa(%eax)
80105e8a:	c6 80 07 18 11 80 00 	movb   $0x0,-0x7feee7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105e91:	66 c7 80 08 18 11 80 	movw   $0xffff,-0x7feee7f8(%eax)
80105e98:	ff ff 
80105e9a:	66 c7 80 0a 18 11 80 	movw   $0x0,-0x7feee7f6(%eax)
80105ea1:	00 00 
80105ea3:	c6 80 0c 18 11 80 00 	movb   $0x0,-0x7feee7f4(%eax)
80105eaa:	c6 80 0d 18 11 80 fa 	movb   $0xfa,-0x7feee7f3(%eax)
80105eb1:	c6 80 0e 18 11 80 cf 	movb   $0xcf,-0x7feee7f2(%eax)
80105eb8:	c6 80 0f 18 11 80 00 	movb   $0x0,-0x7feee7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105ebf:	66 c7 80 10 18 11 80 	movw   $0xffff,-0x7feee7f0(%eax)
80105ec6:	ff ff 
80105ec8:	66 c7 80 12 18 11 80 	movw   $0x0,-0x7feee7ee(%eax)
80105ecf:	00 00 
80105ed1:	c6 80 14 18 11 80 00 	movb   $0x0,-0x7feee7ec(%eax)
80105ed8:	c6 80 15 18 11 80 f2 	movb   $0xf2,-0x7feee7eb(%eax)
80105edf:	c6 80 16 18 11 80 cf 	movb   $0xcf,-0x7feee7ea(%eax)
80105ee6:	c6 80 17 18 11 80 00 	movb   $0x0,-0x7feee7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105eed:	05 f0 17 11 80       	add    $0x801117f0,%eax
  pd[0] = size-1;
80105ef2:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105ef8:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105efc:	c1 e8 10             	shr    $0x10,%eax
80105eff:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105f03:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105f06:	0f 01 10             	lgdtl  (%eax)
}
80105f09:	c9                   	leave  
80105f0a:	c3                   	ret    

80105f0b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105f0b:	55                   	push   %ebp
80105f0c:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105f0e:	a1 a4 47 11 80       	mov    0x801147a4,%eax
80105f13:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f18:	0f 22 d8             	mov    %eax,%cr3
}
80105f1b:	5d                   	pop    %ebp
80105f1c:	c3                   	ret    

80105f1d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105f1d:	55                   	push   %ebp
80105f1e:	89 e5                	mov    %esp,%ebp
80105f20:	57                   	push   %edi
80105f21:	56                   	push   %esi
80105f22:	53                   	push   %ebx
80105f23:	83 ec 1c             	sub    $0x1c,%esp
80105f26:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105f29:	85 f6                	test   %esi,%esi
80105f2b:	0f 84 c3 00 00 00    	je     80105ff4 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105f31:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105f35:	0f 84 c6 00 00 00    	je     80106001 <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105f3b:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105f3f:	0f 84 c9 00 00 00    	je     8010600e <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80105f45:	e8 47 dd ff ff       	call   80103c91 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105f4a:	e8 53 d3 ff ff       	call   801032a2 <mycpu>
80105f4f:	89 c3                	mov    %eax,%ebx
80105f51:	e8 4c d3 ff ff       	call   801032a2 <mycpu>
80105f56:	89 c7                	mov    %eax,%edi
80105f58:	e8 45 d3 ff ff       	call   801032a2 <mycpu>
80105f5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f60:	e8 3d d3 ff ff       	call   801032a2 <mycpu>
80105f65:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105f6c:	67 00 
80105f6e:	83 c7 08             	add    $0x8,%edi
80105f71:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105f78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105f7b:	83 c2 08             	add    $0x8,%edx
80105f7e:	c1 ea 10             	shr    $0x10,%edx
80105f81:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80105f87:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80105f8e:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105f95:	83 c0 08             	add    $0x8,%eax
80105f98:	c1 e8 18             	shr    $0x18,%eax
80105f9b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105fa1:	e8 fc d2 ff ff       	call   801032a2 <mycpu>
80105fa6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105fad:	e8 f0 d2 ff ff       	call   801032a2 <mycpu>
80105fb2:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105fb8:	8b 5e 08             	mov    0x8(%esi),%ebx
80105fbb:	e8 e2 d2 ff ff       	call   801032a2 <mycpu>
80105fc0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105fc6:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80105fc9:	e8 d4 d2 ff ff       	call   801032a2 <mycpu>
80105fce:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80105fd4:	b8 28 00 00 00       	mov    $0x28,%eax
80105fd9:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80105fdc:	8b 46 04             	mov    0x4(%esi),%eax
80105fdf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105fe4:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80105fe7:	e8 e2 dc ff ff       	call   80103cce <popcli>
}
80105fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fef:	5b                   	pop    %ebx
80105ff0:	5e                   	pop    %esi
80105ff1:	5f                   	pop    %edi
80105ff2:	5d                   	pop    %ebp
80105ff3:	c3                   	ret    
    panic("switchuvm: no process");
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	68 52 6e 10 80       	push   $0x80106e52
80105ffc:	e8 43 a3 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
80106001:	83 ec 0c             	sub    $0xc,%esp
80106004:	68 68 6e 10 80       	push   $0x80106e68
80106009:	e8 36 a3 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
8010600e:	83 ec 0c             	sub    $0xc,%esp
80106011:	68 7d 6e 10 80       	push   $0x80106e7d
80106016:	e8 29 a3 ff ff       	call   80100344 <panic>

8010601b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010601b:	55                   	push   %ebp
8010601c:	89 e5                	mov    %esp,%ebp
8010601e:	56                   	push   %esi
8010601f:	53                   	push   %ebx
80106020:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106023:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106029:	77 4c                	ja     80106077 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
8010602b:	e8 2e c1 ff ff       	call   8010215e <kalloc>
80106030:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106032:	83 ec 04             	sub    $0x4,%esp
80106035:	68 00 10 00 00       	push   $0x1000
8010603a:	6a 00                	push   $0x0
8010603c:	50                   	push   %eax
8010603d:	e8 ce dd ff ff       	call   80103e10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106042:	83 c4 08             	add    $0x8,%esp
80106045:	6a 06                	push   $0x6
80106047:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010604d:	50                   	push   %eax
8010604e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106053:	ba 00 00 00 00       	mov    $0x0,%edx
80106058:	8b 45 08             	mov    0x8(%ebp),%eax
8010605b:	e8 46 fd ff ff       	call   80105da6 <mappages>
  memmove(mem, init, sz);
80106060:	83 c4 0c             	add    $0xc,%esp
80106063:	56                   	push   %esi
80106064:	ff 75 0c             	pushl  0xc(%ebp)
80106067:	53                   	push   %ebx
80106068:	e8 38 de ff ff       	call   80103ea5 <memmove>
}
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106073:	5b                   	pop    %ebx
80106074:	5e                   	pop    %esi
80106075:	5d                   	pop    %ebp
80106076:	c3                   	ret    
    panic("inituvm: more than a page");
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	68 91 6e 10 80       	push   $0x80106e91
8010607f:	e8 c0 a2 ff ff       	call   80100344 <panic>

80106084 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	57                   	push   %edi
80106088:	56                   	push   %esi
80106089:	53                   	push   %ebx
8010608a:	83 ec 1c             	sub    $0x1c,%esp
8010608d:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106093:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106098:	75 71                	jne    8010610b <loaduvm+0x87>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010609a:	8b 75 18             	mov    0x18(%ebp),%esi
8010609d:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801060a2:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
801060a7:	85 f6                	test   %esi,%esi
801060a9:	74 7f                	je     8010612a <loaduvm+0xa6>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801060ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060ae:	8d 14 18             	lea    (%eax,%ebx,1),%edx
801060b1:	b9 00 00 00 00       	mov    $0x0,%ecx
801060b6:	8b 45 08             	mov    0x8(%ebp),%eax
801060b9:	e8 79 fc ff ff       	call   80105d37 <walkpgdir>
801060be:	85 c0                	test   %eax,%eax
801060c0:	74 56                	je     80106118 <loaduvm+0x94>
    pa = PTE_ADDR(*pte);
801060c2:	8b 00                	mov    (%eax),%eax
801060c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
801060c9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801060cf:	bf 00 10 00 00       	mov    $0x1000,%edi
801060d4:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801060d7:	57                   	push   %edi
801060d8:	89 da                	mov    %ebx,%edx
801060da:	03 55 14             	add    0x14(%ebp),%edx
801060dd:	52                   	push   %edx
801060de:	05 00 00 00 80       	add    $0x80000000,%eax
801060e3:	50                   	push   %eax
801060e4:	ff 75 10             	pushl  0x10(%ebp)
801060e7:	e8 8e b6 ff ff       	call   8010177a <readi>
801060ec:	83 c4 10             	add    $0x10,%esp
801060ef:	39 f8                	cmp    %edi,%eax
801060f1:	75 32                	jne    80106125 <loaduvm+0xa1>
  for(i = 0; i < sz; i += PGSIZE){
801060f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801060f9:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801060ff:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106102:	77 a7                	ja     801060ab <loaduvm+0x27>
  return 0;
80106104:	b8 00 00 00 00       	mov    $0x0,%eax
80106109:	eb 1f                	jmp    8010612a <loaduvm+0xa6>
    panic("loaduvm: addr must be page aligned");
8010610b:	83 ec 0c             	sub    $0xc,%esp
8010610e:	68 4c 6f 10 80       	push   $0x80106f4c
80106113:	e8 2c a2 ff ff       	call   80100344 <panic>
      panic("loaduvm: address should exist");
80106118:	83 ec 0c             	sub    $0xc,%esp
8010611b:	68 ab 6e 10 80       	push   $0x80106eab
80106120:	e8 1f a2 ff ff       	call   80100344 <panic>
      return -1;
80106125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010612d:	5b                   	pop    %ebx
8010612e:	5e                   	pop    %esi
8010612f:	5f                   	pop    %edi
80106130:	5d                   	pop    %ebp
80106131:	c3                   	ret    

80106132 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106132:	55                   	push   %ebp
80106133:	89 e5                	mov    %esp,%ebp
80106135:	57                   	push   %edi
80106136:	56                   	push   %esi
80106137:	53                   	push   %ebx
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
8010613e:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
80106140:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106143:	73 16                	jae    8010615b <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
80106145:	8b 45 10             	mov    0x10(%ebp),%eax
80106148:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010614e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106154:	39 df                	cmp    %ebx,%edi
80106156:	77 21                	ja     80106179 <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106158:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010615b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010615e:	5b                   	pop    %ebx
8010615f:	5e                   	pop    %esi
80106160:	5f                   	pop    %edi
80106161:	5d                   	pop    %ebp
80106162:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106163:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106169:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010616f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106175:	39 df                	cmp    %ebx,%edi
80106177:	76 df                	jbe    80106158 <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106179:	b9 00 00 00 00       	mov    $0x0,%ecx
8010617e:	89 da                	mov    %ebx,%edx
80106180:	8b 45 08             	mov    0x8(%ebp),%eax
80106183:	e8 af fb ff ff       	call   80105d37 <walkpgdir>
80106188:	89 c6                	mov    %eax,%esi
    if(!pte)
8010618a:	85 c0                	test   %eax,%eax
8010618c:	74 d5                	je     80106163 <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
8010618e:	8b 00                	mov    (%eax),%eax
80106190:	a8 01                	test   $0x1,%al
80106192:	74 db                	je     8010616f <deallocuvm+0x3d>
      if(pa == 0)
80106194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106199:	74 19                	je     801061b4 <deallocuvm+0x82>
      kfree(v);
8010619b:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010619e:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801061a3:	50                   	push   %eax
801061a4:	e8 90 be ff ff       	call   80102039 <kfree>
      *pte = 0;
801061a9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	eb bb                	jmp    8010616f <deallocuvm+0x3d>
        panic("kfree");
801061b4:	83 ec 0c             	sub    $0xc,%esp
801061b7:	68 e6 67 10 80       	push   $0x801067e6
801061bc:	e8 83 a1 ff ff       	call   80100344 <panic>

801061c1 <allocuvm>:
{
801061c1:	55                   	push   %ebp
801061c2:	89 e5                	mov    %esp,%ebp
801061c4:	57                   	push   %edi
801061c5:	56                   	push   %esi
801061c6:	53                   	push   %ebx
801061c7:	83 ec 1c             	sub    $0x1c,%esp
801061ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801061cd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801061d0:	85 ff                	test   %edi,%edi
801061d2:	0f 88 c5 00 00 00    	js     8010629d <allocuvm+0xdc>
  if(newsz < oldsz)
801061d8:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801061db:	72 60                	jb     8010623d <allocuvm+0x7c>
  a = PGROUNDUP(oldsz);
801061dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801061e0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801061e6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801061ec:	39 df                	cmp    %ebx,%edi
801061ee:	0f 86 b0 00 00 00    	jbe    801062a4 <allocuvm+0xe3>
    mem = kalloc();
801061f4:	e8 65 bf ff ff       	call   8010215e <kalloc>
801061f9:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801061fb:	85 c0                	test   %eax,%eax
801061fd:	74 46                	je     80106245 <allocuvm+0x84>
    memset(mem, 0, PGSIZE);
801061ff:	83 ec 04             	sub    $0x4,%esp
80106202:	68 00 10 00 00       	push   $0x1000
80106207:	6a 00                	push   $0x0
80106209:	50                   	push   %eax
8010620a:	e8 01 dc ff ff       	call   80103e10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010620f:	83 c4 08             	add    $0x8,%esp
80106212:	6a 06                	push   $0x6
80106214:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010621a:	50                   	push   %eax
8010621b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106220:	89 da                	mov    %ebx,%edx
80106222:	8b 45 08             	mov    0x8(%ebp),%eax
80106225:	e8 7c fb ff ff       	call   80105da6 <mappages>
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	85 c0                	test   %eax,%eax
8010622f:	78 3c                	js     8010626d <allocuvm+0xac>
  for(; a < newsz; a += PGSIZE){
80106231:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106237:	39 df                	cmp    %ebx,%edi
80106239:	77 b9                	ja     801061f4 <allocuvm+0x33>
8010623b:	eb 67                	jmp    801062a4 <allocuvm+0xe3>
    return oldsz;
8010623d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106243:	eb 5f                	jmp    801062a4 <allocuvm+0xe3>
      cprintf("allocuvm out of memory\n");
80106245:	83 ec 0c             	sub    $0xc,%esp
80106248:	68 c9 6e 10 80       	push   $0x80106ec9
8010624d:	e8 8f a3 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106252:	83 c4 0c             	add    $0xc,%esp
80106255:	ff 75 0c             	pushl  0xc(%ebp)
80106258:	57                   	push   %edi
80106259:	ff 75 08             	pushl  0x8(%ebp)
8010625c:	e8 d1 fe ff ff       	call   80106132 <deallocuvm>
      return 0;
80106261:	83 c4 10             	add    $0x10,%esp
80106264:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010626b:	eb 37                	jmp    801062a4 <allocuvm+0xe3>
      cprintf("allocuvm out of memory (2)\n");
8010626d:	83 ec 0c             	sub    $0xc,%esp
80106270:	68 e1 6e 10 80       	push   $0x80106ee1
80106275:	e8 67 a3 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010627a:	83 c4 0c             	add    $0xc,%esp
8010627d:	ff 75 0c             	pushl  0xc(%ebp)
80106280:	57                   	push   %edi
80106281:	ff 75 08             	pushl  0x8(%ebp)
80106284:	e8 a9 fe ff ff       	call   80106132 <deallocuvm>
      kfree(mem);
80106289:	89 34 24             	mov    %esi,(%esp)
8010628c:	e8 a8 bd ff ff       	call   80102039 <kfree>
      return 0;
80106291:	83 c4 10             	add    $0x10,%esp
80106294:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010629b:	eb 07                	jmp    801062a4 <allocuvm+0xe3>
    return 0;
8010629d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801062a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062aa:	5b                   	pop    %ebx
801062ab:	5e                   	pop    %esi
801062ac:	5f                   	pop    %edi
801062ad:	5d                   	pop    %ebp
801062ae:	c3                   	ret    

801062af <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801062af:	55                   	push   %ebp
801062b0:	89 e5                	mov    %esp,%ebp
801062b2:	57                   	push   %edi
801062b3:	56                   	push   %esi
801062b4:	53                   	push   %ebx
801062b5:	83 ec 0c             	sub    $0xc,%esp
801062b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
801062bb:	85 ff                	test   %edi,%edi
801062bd:	74 1d                	je     801062dc <freevm+0x2d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801062bf:	83 ec 04             	sub    $0x4,%esp
801062c2:	6a 00                	push   $0x0
801062c4:	68 00 00 00 80       	push   $0x80000000
801062c9:	57                   	push   %edi
801062ca:	e8 63 fe ff ff       	call   80106132 <deallocuvm>
801062cf:	89 fb                	mov    %edi,%ebx
801062d1:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
801062d7:	83 c4 10             	add    $0x10,%esp
801062da:	eb 14                	jmp    801062f0 <freevm+0x41>
    panic("freevm: no pgdir");
801062dc:	83 ec 0c             	sub    $0xc,%esp
801062df:	68 fd 6e 10 80       	push   $0x80106efd
801062e4:	e8 5b a0 ff ff       	call   80100344 <panic>
801062e9:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801062ec:	39 f3                	cmp    %esi,%ebx
801062ee:	74 1e                	je     8010630e <freevm+0x5f>
    if(pgdir[i] & PTE_P){
801062f0:	8b 03                	mov    (%ebx),%eax
801062f2:	a8 01                	test   $0x1,%al
801062f4:	74 f3                	je     801062e9 <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801062f6:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801062f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801062fe:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106303:	50                   	push   %eax
80106304:	e8 30 bd ff ff       	call   80102039 <kfree>
80106309:	83 c4 10             	add    $0x10,%esp
8010630c:	eb db                	jmp    801062e9 <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
8010630e:	83 ec 0c             	sub    $0xc,%esp
80106311:	57                   	push   %edi
80106312:	e8 22 bd ff ff       	call   80102039 <kfree>
}
80106317:	83 c4 10             	add    $0x10,%esp
8010631a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010631d:	5b                   	pop    %ebx
8010631e:	5e                   	pop    %esi
8010631f:	5f                   	pop    %edi
80106320:	5d                   	pop    %ebp
80106321:	c3                   	ret    

80106322 <setupkvm>:
{
80106322:	55                   	push   %ebp
80106323:	89 e5                	mov    %esp,%ebp
80106325:	56                   	push   %esi
80106326:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106327:	e8 32 be ff ff       	call   8010215e <kalloc>
8010632c:	89 c6                	mov    %eax,%esi
8010632e:	85 c0                	test   %eax,%eax
80106330:	74 42                	je     80106374 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106332:	83 ec 04             	sub    $0x4,%esp
80106335:	68 00 10 00 00       	push   $0x1000
8010633a:	6a 00                	push   $0x0
8010633c:	50                   	push   %eax
8010633d:	e8 ce da ff ff       	call   80103e10 <memset>
80106342:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106345:	bb 20 94 10 80       	mov    $0x80109420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010634a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010634d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106350:	29 c1                	sub    %eax,%ecx
80106352:	83 ec 08             	sub    $0x8,%esp
80106355:	ff 73 0c             	pushl  0xc(%ebx)
80106358:	50                   	push   %eax
80106359:	8b 13                	mov    (%ebx),%edx
8010635b:	89 f0                	mov    %esi,%eax
8010635d:	e8 44 fa ff ff       	call   80105da6 <mappages>
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	78 14                	js     8010637d <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106369:	83 c3 10             	add    $0x10,%ebx
8010636c:	81 fb 60 94 10 80    	cmp    $0x80109460,%ebx
80106372:	75 d6                	jne    8010634a <setupkvm+0x28>
}
80106374:	89 f0                	mov    %esi,%eax
80106376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106379:	5b                   	pop    %ebx
8010637a:	5e                   	pop    %esi
8010637b:	5d                   	pop    %ebp
8010637c:	c3                   	ret    
      freevm(pgdir);
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	56                   	push   %esi
80106381:	e8 29 ff ff ff       	call   801062af <freevm>
      return 0;
80106386:	83 c4 10             	add    $0x10,%esp
80106389:	be 00 00 00 00       	mov    $0x0,%esi
8010638e:	eb e4                	jmp    80106374 <setupkvm+0x52>

80106390 <kvmalloc>:
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106396:	e8 87 ff ff ff       	call   80106322 <setupkvm>
8010639b:	a3 a4 47 11 80       	mov    %eax,0x801147a4
  switchkvm();
801063a0:	e8 66 fb ff ff       	call   80105f0b <switchkvm>
}
801063a5:	c9                   	leave  
801063a6:	c3                   	ret    

801063a7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801063a7:	55                   	push   %ebp
801063a8:	89 e5                	mov    %esp,%ebp
801063aa:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801063ad:	b9 00 00 00 00       	mov    $0x0,%ecx
801063b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801063b5:	8b 45 08             	mov    0x8(%ebp),%eax
801063b8:	e8 7a f9 ff ff       	call   80105d37 <walkpgdir>
  if(pte == 0)
801063bd:	85 c0                	test   %eax,%eax
801063bf:	74 05                	je     801063c6 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801063c1:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801063c4:	c9                   	leave  
801063c5:	c3                   	ret    
    panic("clearpteu");
801063c6:	83 ec 0c             	sub    $0xc,%esp
801063c9:	68 0e 6f 10 80       	push   $0x80106f0e
801063ce:	e8 71 9f ff ff       	call   80100344 <panic>

801063d3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801063d3:	55                   	push   %ebp
801063d4:	89 e5                	mov    %esp,%ebp
801063d6:	57                   	push   %edi
801063d7:	56                   	push   %esi
801063d8:	53                   	push   %ebx
801063d9:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801063dc:	e8 41 ff ff ff       	call   80106322 <setupkvm>
801063e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063e4:	85 c0                	test   %eax,%eax
801063e6:	0f 84 c7 00 00 00    	je     801064b3 <copyuvm+0xe0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801063ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801063f0:	0f 84 bd 00 00 00    	je     801064b3 <copyuvm+0xe0>
801063f6:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801063fb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801063fe:	b9 00 00 00 00       	mov    $0x0,%ecx
80106403:	89 fa                	mov    %edi,%edx
80106405:	8b 45 08             	mov    0x8(%ebp),%eax
80106408:	e8 2a f9 ff ff       	call   80105d37 <walkpgdir>
8010640d:	85 c0                	test   %eax,%eax
8010640f:	74 67                	je     80106478 <copyuvm+0xa5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106411:	8b 00                	mov    (%eax),%eax
80106413:	a8 01                	test   $0x1,%al
80106415:	74 6e                	je     80106485 <copyuvm+0xb2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106417:	89 c6                	mov    %eax,%esi
80106419:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010641f:	25 ff 0f 00 00       	and    $0xfff,%eax
80106424:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106427:	e8 32 bd ff ff       	call   8010215e <kalloc>
8010642c:	89 c3                	mov    %eax,%ebx
8010642e:	85 c0                	test   %eax,%eax
80106430:	74 6c                	je     8010649e <copyuvm+0xcb>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106432:	83 ec 04             	sub    $0x4,%esp
80106435:	68 00 10 00 00       	push   $0x1000
8010643a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106440:	56                   	push   %esi
80106441:	50                   	push   %eax
80106442:	e8 5e da ff ff       	call   80103ea5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106447:	83 c4 08             	add    $0x8,%esp
8010644a:	ff 75 e0             	pushl  -0x20(%ebp)
8010644d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106453:	50                   	push   %eax
80106454:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106459:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010645c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010645f:	e8 42 f9 ff ff       	call   80105da6 <mappages>
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	85 c0                	test   %eax,%eax
80106469:	78 27                	js     80106492 <copyuvm+0xbf>
  for(i = 0; i < sz; i += PGSIZE){
8010646b:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106471:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106474:	77 85                	ja     801063fb <copyuvm+0x28>
80106476:	eb 3b                	jmp    801064b3 <copyuvm+0xe0>
      panic("copyuvm: pte should exist");
80106478:	83 ec 0c             	sub    $0xc,%esp
8010647b:	68 18 6f 10 80       	push   $0x80106f18
80106480:	e8 bf 9e ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
80106485:	83 ec 0c             	sub    $0xc,%esp
80106488:	68 32 6f 10 80       	push   $0x80106f32
8010648d:	e8 b2 9e ff ff       	call   80100344 <panic>
      kfree(mem);
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	53                   	push   %ebx
80106496:	e8 9e bb ff ff       	call   80102039 <kfree>
      goto bad;
8010649b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
8010649e:	83 ec 0c             	sub    $0xc,%esp
801064a1:	ff 75 dc             	pushl  -0x24(%ebp)
801064a4:	e8 06 fe ff ff       	call   801062af <freevm>
  return 0;
801064a9:	83 c4 10             	add    $0x10,%esp
801064ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801064b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b9:	5b                   	pop    %ebx
801064ba:	5e                   	pop    %esi
801064bb:	5f                   	pop    %edi
801064bc:	5d                   	pop    %ebp
801064bd:	c3                   	ret    

801064be <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801064be:	55                   	push   %ebp
801064bf:	89 e5                	mov    %esp,%ebp
801064c1:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801064c4:	b9 00 00 00 00       	mov    $0x0,%ecx
801064c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801064cc:	8b 45 08             	mov    0x8(%ebp),%eax
801064cf:	e8 63 f8 ff ff       	call   80105d37 <walkpgdir>
  if((*pte & PTE_P) == 0)
801064d4:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801064d6:	89 c2                	mov    %eax,%edx
801064d8:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801064db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064e0:	05 00 00 00 80       	add    $0x80000000,%eax
801064e5:	83 fa 05             	cmp    $0x5,%edx
801064e8:	ba 00 00 00 00       	mov    $0x0,%edx
801064ed:	0f 45 c2             	cmovne %edx,%eax
}
801064f0:	c9                   	leave  
801064f1:	c3                   	ret    

801064f2 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801064f2:	55                   	push   %ebp
801064f3:	89 e5                	mov    %esp,%ebp
801064f5:	57                   	push   %edi
801064f6:	56                   	push   %esi
801064f7:	53                   	push   %ebx
801064f8:	83 ec 0c             	sub    $0xc,%esp
801064fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801064fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80106502:	74 55                	je     80106559 <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
80106504:	89 df                	mov    %ebx,%edi
80106506:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010650c:	83 ec 08             	sub    $0x8,%esp
8010650f:	57                   	push   %edi
80106510:	ff 75 08             	pushl  0x8(%ebp)
80106513:	e8 a6 ff ff ff       	call   801064be <uva2ka>
    if(pa0 == 0)
80106518:	83 c4 10             	add    $0x10,%esp
8010651b:	85 c0                	test   %eax,%eax
8010651d:	74 41                	je     80106560 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
8010651f:	89 fe                	mov    %edi,%esi
80106521:	29 de                	sub    %ebx,%esi
80106523:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106529:	3b 75 14             	cmp    0x14(%ebp),%esi
8010652c:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106530:	83 ec 04             	sub    $0x4,%esp
80106533:	56                   	push   %esi
80106534:	ff 75 10             	pushl  0x10(%ebp)
80106537:	29 fb                	sub    %edi,%ebx
80106539:	01 d8                	add    %ebx,%eax
8010653b:	50                   	push   %eax
8010653c:	e8 64 d9 ff ff       	call   80103ea5 <memmove>
    len -= n;
    buf += n;
80106541:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
80106544:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
  while(len > 0){
8010654a:	83 c4 10             	add    $0x10,%esp
8010654d:	29 75 14             	sub    %esi,0x14(%ebp)
80106550:	75 b2                	jne    80106504 <copyout+0x12>
  }
  return 0;
80106552:	b8 00 00 00 00       	mov    $0x0,%eax
80106557:	eb 0c                	jmp    80106565 <copyout+0x73>
80106559:	b8 00 00 00 00       	mov    $0x0,%eax
8010655e:	eb 05                	jmp    80106565 <copyout+0x73>
      return -1;
80106560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106568:	5b                   	pop    %ebx
80106569:	5e                   	pop    %esi
8010656a:	5f                   	pop    %edi
8010656b:	5d                   	pop    %ebp
8010656c:	c3                   	ret    
