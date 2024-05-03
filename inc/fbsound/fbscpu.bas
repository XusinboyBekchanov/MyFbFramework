'  ##############
' # fbscpu.bas #
'##############
' Copyright 2005-2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

'' always export, even when building a static lib
'' if the end user builds everything static, then
'' it doesn't really matter and if this module is
'' built in to static lib then we want the exports
'' if it is later built in to a shared library 
#define API_EXPORT EXPORT

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"
#include once "fbsound/fbscpu.bi"
#include once "fbsound/plug-cdtor.bi"

'' !!!FIXME!!! namespacing

'' ASM fill n bytes with 0
private _
sub _ZeroAsm(byval d as any ptr, _ ' destination
             byval n as integer)   ' n bytes
  asm
#ifndef __FB_64BIT__  
    mov    edi,[d]
    mov    ecx,[n]
    xor    eax,eax
    shr    ecx,1
    jnc    zeroasm_2
    stosb

  zeroasm_2:
    shr    ecx,1
    jnc    zeroasm_4
    stosw

  zeroasm_4:
    jecxz  zeroasm_end

  zeroasm_loop:
    stosd
    dec    ecx
    jnz    zeroasm_loop
  
#else

    mov    rdi,[d]
    mov    rcx,[n]
    xor    rax,rax
    shr    rcx,1
    jnc    zeroasm_2
    stosb

  zeroasm_2:
    shr    rcx,1
    jnc    zeroasm_4
    stosw

  zeroasm_4:
    shr    rcx,1
    jnc    zeroasm_8
    stosd

  zeroasm_8:
    jrcxz  zeroasm_end

  zeroasm_loop:
    stosq
    dec    rcx
    jnz    zeroasm_loop
#endif
  
  zeroasm_end:
  end asm
end sub

private _
sub _ZeroBufferAsm(byval s as any ptr    , _ ' pStart
                   byval p as any ptr ptr, _ ' @pPlay
                   byval e as any ptr    , _ ' pEnd
                   byval n as integer)       ' nBytes
  asm
#ifndef __FB_64BIT__
  mov esi,[p]
  mov edi,[esi]                         ' pos = *pPlay
  mov ecx,[n]
  mov ebx,[s]
  mov edx,[e]
  xor eax,eax
  
zerobuffer_set: 
  mov [edi],al                          ' [pos]=byte
  inc edi                               ' pos += 1
  cmp edi,edx                          
  jge zerobuffer_reset                  ' if pos>=pEnd then goto zerobuffer_reset
  dec ecx                               ' n-=1
  jnz zerobuffer_set 
  jmp zerobuffer_end

zerobuffer_reset:
  mov edi,ebx                           ' pos = pStart
  dec ecx                               ' n-=1
  jnz zerobuffer_set

zerobuffer_end:
  mov [esi],edi                         ' *pPlay = pos

#else

  mov rsi,[p]
  mov rdi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]
  mov rbx,[s]
  mov rdx,[e]
  xor rax,rax
  
zerobuffer_set:
  mov [rdi],al                          ' [pos]=byte
  inc rdi                               ' pos += 1
  cmp rdi,rdx                          
  jge zerobuffer_reset                  ' if pos>=pEnd then goto zerobuffer_reset
  dec rcx
  jnz zerobuffer_set
  jmp zerobuffer_end

zerobuffer_reset:
  mov rdi,rbx                           ' pos = pStart
  dec rcx
  jnz zerobuffer_set

zerobuffer_end:
  mov [rsi],rdi                         ' *pPlay = pos
#endif  
  end asm
end sub

' ASM copy n bytes
private _
sub _CopyAsm(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  asm
#ifndef __FB_64BIT__  
  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]

  shr    ecx,1
  jnc    copyasm_2
  movsb
  jecxz  copyasm_end

copyasm_2:
  shr    ecx,1
  jnc    copyasm_4
  movsw

copyasm_4:
  jecxz  copyasm_end

copyasm_loop:
  movsd
  dec    ecx
  jnz    copyasm_loop
#else
  mov    rdi,[d]
  mov    rsi,[s]
  mov    rcx,[n]

  shr    ecx,1
  jnc    copyasm_2
  movsb
  jrcxz  copyasm_end

copyasm_2:
  shr    rcx,1
  jnc    copyasm_4
  movsw

copyasm_4:
  shr    rcx,1
  jnc    copyasm_8
  movsd

copyasm_8:
  jrcxz  copyasm_end

copyasm_loop:
  movsq
  dec    rcx
  jnz    copyasm_loop
#endif  
copyasm_end:
  end asm
end sub

' ASM MMX copy n bytes
private _
sub _CopyMmx(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  asm
#ifndef __FB_64BIT__  
  mov   edi,[d]
  mov   esi,[s]
  mov   ecx,[n]

  shr   ecx,1
  jnc   copymmx_2
  movsb

copymmx_2:
  shr   ecx,1
  jnc   copymmx_4
  movsw

copymmx_4:
  shr   ecx,1
  jnc   copymmx_8
  movsd

copymmx_8:
  shr   ecx,1
  jnc   copymmx_16
  movq  mm0,[esi]
  movq  [edi],mm0
  add   esi,8
  add   edi,8

copymmx_16:
  shr   ecx,1
  jnc   copymmx_32
  movq  mm0,[esi]
  movq  [edi],mm0
  movq  mm0,[esi+8]
  movq  [edi+8],mm0
  lea   esi,[esi+16]
  lea   edi,[edi+16]

copymmx_32:
  shr   ecx,1
  jnc   copymmx_64
  movq  mm0,[esi]
  movq  [edi],mm0
  movq  mm0,[esi+8]
  movq  [edi+8],mm0
  movq  mm0,[esi+16]
  movq  [edi+16],mm0
  movq  mm0,[esi+24]
  movq  [edi+24],mm0
  lea   esi,[esi+32]
  lea   edi,[edi+32]

copymmx_64:
  jecxz copymmx_end

  copymmx_loop:
    movq   mm0,[esi]
    movq   [edi   ],mm0
    movq   mm1,[esi+ 8]
    movq   [edi+ 8],mm1
    movq   mm2,[esi+16]
    movq   [edi+16],mm2
    movq   mm3,[esi+24]
    movq   [edi+24],mm3
    movq   mm4,[esi+32]
    movq   [edi+32],mm4
    movq   mm5,[esi+40]
    movq   [edi+40],mm5
    movq   mm6,[esi+48]
    movq   [edi+48],mm6
    movq   mm7,[esi+56]
    movq   [edi+56],mm7
    lea    esi,[esi+64]
    lea    edi,[edi+64]
    dec ecx
  jnz copymmx_loop

#else

  mov   rdi,[d]
  mov   rsi,[s]
  mov   rcx,[n]

  shr   rcx,1
  jnc   copymmx_2
  movsb

copymmx_2:
  shr   rcx,1
  jnc   copymmx_4
  movsw

copymmx_4:
  shr   rcx,1
  jnc   copymmx_8
  movsd

copymmx_8:
  shr   rcx,1
  jnc   copymmx_16
  movq  mm0,[rsi]
  movq  [rdi],mm0
  add   rsi,8
  add   rdi,8

copymmx_16:
  shr   rcx,1
  jnc   copymmx_32
  movq  mm0,[rsi]
  movq  [rdi],mm0
  movq  mm0,[rsi+8]
  movq  [rdi+8],mm0
  lea   rsi,[rsi+16]
  lea   rdi,[rdi+16]

copymmx_32:
  shr   rcx,1
  jnc   copymmx_64
  movq  mm0,[rsi]
  movq  [rdi],mm0
  movq  mm0,[rsi+8]
  movq  [rdi+8],mm0
  movq  mm0,[rsi+16]
  movq  [rdi+16],mm0
  movq  mm0,[rsi+24]
  movq  [rdi+24],mm0
  lea   rsi,[rsi+32]
  lea   rdi,[rdi+32]

copymmx_64:
  jecxz copymmx_end

  copymmx_loop:
    movq   mm0,[rsi]
    movq   [rdi   ],mm0
    movq   mm1,[rsi+ 8]
    movq   [rdi+ 8],mm1
    movq   mm2,[rsi+16]
    movq   [rdi+16],mm2
    movq   mm3,[rsi+24]
    movq   [rdi+24],mm3
    movq   mm4,[rsi+32]
    movq   [rdi+32],mm4
    movq   mm5,[rsi+40]
    movq   [rdi+40],mm5
    movq   mm6,[rsi+48]
    movq   [rdi+48],mm6
    movq   mm7,[rsi+56]
    movq   [rdi+56],mm7
    lea    rsi,[rsi+64]
    lea    rdi,[rdi+64]
    dec rcx
  jnz copymmx_loop
#endif
  copymmx_end:
  emms
  end asm
end sub

' ASM SSE copy n bytes
private _
sub _CopySse(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  asm
#ifndef __FB_64BIT__
  mov   edi,[d]
  mov   esi,[s]
  mov   ecx,[n]

  shr   ecx,1
  jnc   copysse_2
  movsb

copysse_2:
  shr   ecx,1
  jnc   copysse_4
  movsw

copysse_4:
  shr   ecx,1
  jnc   copysse_8
  movsd

copysse_8:
  shr   ecx,1
  jnc   copysse_16
  movq  mm0,[esi  ]
  movq  [edi],mm0
  lea   esi,[esi+8]
  lea   edi,[edi+8]

copysse_16:
  shr   ecx,1
  jnc   copysse_32
  movq  mm0,[esi   ]
  movq  [edi  ],mm0
  movq  mm0,[esi+ 8]
  movq  [edi+8],mm0
  lea   esi,[esi+16]
  lea   edi,[edi+16]

copysse_32:
  shr   ecx,1
  jnc   copysse_64
  movq  mm0,[esi   ]
  movq  [edi  ],mm0
  movq  mm0,[esi+ 8]
  movq  [edi+8],mm0
  movq  mm0,[esi+16]
  movq  [edi+16],mm0
  movq  mm0,[esi+24]
  movq  [edi+24],mm0
  lea   esi,[esi+32]
  lea   edi,[edi+32]

copysse_64:
  jecxz copysse_end
  copysse_loop:
    movq   mm0,[esi+ 0]
    movntq [edi+ 0],mm0
    movq   mm1,[esi+ 8]
    movntq [edi+ 8],mm1
    movq   mm2,[esi+16]
    movntq [edi+16],mm2
    movq   mm3,[esi+24]
    movntq [edi+24],mm3
    movq   mm4,[esi+32]
    movntq [edi+32],mm4
    movq   mm5,[esi+40]
    movntq [edi+40],mm5
    movq   mm6,[esi+48]
    movntq [edi+48],mm6
    movq   mm7,[esi+56]
    movntq [edi+56],mm7
    lea    esi,[esi+64]
    lea    edi,[edi+64]
    dec ecx
  jnz copysse_loop

#else

  mov   rdi,[d]
  mov   rsi,[s]
  mov   rcx,[n]

  shr   rcx,1
  jnc   copysse_2
  movsb

copysse_2:
  shr   rcx,1
  jnc   copysse_4
  movsw

copysse_4:
  shr   rcx,1
  jnc   copysse_8
  movsd

copysse_8:
  shr   rcx,1
  jnc   copysse_16
  movq  mm0,[rsi  ]
  movq  [rdi],mm0
  lea   rsi,[rsi+8]
  lea   rdi,[rdi+8]

copysse_16:
  shr   rcx,1
  jnc   copysse_32
  movq  mm0,[rsi   ]
  movq  [rdi  ],mm0
  movq  mm0,[rsi+ 8]
  movq  [rdi+8],mm0
  lea   rsi,[rsi+16]
  lea   rdi,[rdi+16]

copysse_32:
  shr   ecx,1
  jnc   copysse_64
  movq  mm0,[rsi   ]
  movq  [rdi  ],mm0
  movq  mm0,[rsi+ 8]
  movq  [rdi+8],mm0
  movq  mm0,[rsi+16]
  movq  [rdi+16],mm0
  movq  mm0,[rsi+24]
  movq  [rdi+24],mm0
  lea   rsi,[rsi+32]
  lea   rdi,[rdi+32]

copysse_64:
  jecxz copysse_end
  copysse_loop:
    movq   mm0,[rsi+ 0]
    movntq [rdi+ 0],mm0
    movq   mm1,[rsi+ 8]
    movntq [rdi+ 8],mm1
    movq   mm2,[rsi+16]
    movntq [rdi+16],mm2
    movq   mm3,[rsi+24]
    movntq [rdi+24],mm3
    movq   mm4,[rsi+32]
    movntq [rdi+32],mm4
    movq   mm5,[rsi+40]
    movntq [rdi+40],mm5
    movq   mm6,[rsi+48]
    movntq [rdi+48],mm6
    movq   mm7,[rsi+56]
    movntq [rdi+56],mm7
    lea    rsi,[rsi+64]
    lea    rdi,[rdi+64]
    dec rcx
  jnz copysse_loop

#endif
  copysse_end:
  emms
  end asm
end sub

' ASM mix two mono channels
private _
sub _mixAsm16(byval d as any ptr, _ ' destination
              byval a as any ptr, _ ' channel a
              byval b as any ptr, _ ' channel b
              byval n as integer)   ' n samples
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]
  mov esi,[a]
  mov ebx,[b]
  mov ecx,[n]
  xor edx,edx

mixasm16loop:
  mov ax, word ptr [esi+edx] ' chna
  add ax, word ptr [ebx+edx] ' chnb
  jo mixasm16testc
  mov word ptr [edi+edx],ax
  add edx,2
  cmp edx,ecx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16testc:
  jc  mixasm16savemin
  mov word ptr [edi+edx],&H7FFF ' +32767
  add edx,2
  cmp edx,ecx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16savemin:
  mov word ptr [edi+edx],&H8000 ' -32768
  add edx,2
  cmp edx,ecx
  jb mixasm16loop

#else

  mov rdi,[d]
  mov rsi,[a]
  mov rbx,[b]
  mov rcx,[n]
  xor rdx,rdx

mixasm16loop:
  mov ax, word ptr [rsi+rdx] ' chna
  add ax, word ptr [rbx+rdx] ' chnb
  jo mixasm16testc
  mov word ptr [rdi+rdx],ax
  add rdx,2
  cmp rdx,rcx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16testc:
  jc  mixasm16savemin
  mov word ptr [rdi+rdx],&H7FFF ' +32767
  add rdx,2
  cmp rdx,rcx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16savemin:
  mov word ptr [rdi+rdx],&H8000 ' -32768
  add rdx,2
  cmp rdx,rcx
  jb mixasm16loop
#endif  
mixasm16end:
  end asm
end sub

' ASM MMX mix two mono channels
private _
sub _mixMmx16(byval d as any ptr, _ ' destination
              byval a as any ptr, _ ' channel a
              byval b as any ptr, _ ' channel b
              byval n as integer)   ' n samples
  asm
#ifndef __FB_64BIT__
  mov  edi,[d]
  mov  esi,[a]
  mov  ebx,[b]
  mov  ecx,[n]
  sub  ecx,8
  xor  edx,edx
  jmp  mixmmx16loop

mixmmx16add:
  add    edx, 8
mixmmx16loop:
  movq   mm0, [esi+edx] '     chna 4 words
  paddsw mm0, [ebx+edx] ' add chnb 4 words
  movq   [edi + edx], mm0
  cmp    edx, ecx
  jb     mixmmx16add
  
#else

  mov  rdi,[d]
  mov  rsi,[a]
  mov  rbx,[b]
  mov  rcx,[n]
  sub  rcx,8
  xor  rdx,rdx
  jmp  mixmmx16loop

mixmmx16add:
  add    rdx, 8
mixmmx16loop:
  movq   mm0, [rsi+rdx] '     chna 4 samples
  paddsw mm0, [rbx+rdx] ' add chnb 4 samples
  movq   [rdi + rdx], mm0
  cmp    rdx, rcx
  jb     mixmmx16add
#endif  
  emms
  end asm
end sub

' ASM scale a mono channels
private _
sub _ScaleAsm16(byval d as any ptr, _ ' destination
                byval s as any ptr, _ ' source
                byval v as single , _ ' volume
                byval n as integer)   ' n samples
  dim mul32 as long = (1 shl 16) ' !!! changed to long !!!
  asm
  
#ifndef __FB_64BIT__
  fild   dword ptr [mul32]
  fld    dword ptr [v]
  fmulp
  fistp  dword ptr [mul32]

  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,2

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    scaleasm16_start

scaleasm16_add:
  add    ebx,2
scaleasm16_start:
  movsx  eax,word ptr [esi+ebx]
  imul   ebp
  jo     scaleasm16_min
  shr    eax,16
  mov    word ptr [edi+ebx],ax
  cmp    ebx,ecx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_min:
  and    edx,edx
  jz     scaleasm16_max
  mov    word ptr [edi+ebx],&H8000 ' -32768
  cmp    ebx,ecx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_max:
  mov    word ptr [edi+ebx],&H7fff ' +32767
  cmp    ebx,ecx
  jb     scaleasm16_add

scaleasm16_end:
  pop ebp
  
#else

  fild   dword ptr [mul32]
  fld    dword ptr [v]
  fmulp
  fistp  dword ptr [mul32]

  mov    rdi,[d]
  mov    rsi,[s]
  mov    rcx,[n]
  sub    rcx,2                          ' nSamples = nBytes\2 (bytes -> words)

  push   rbp
  mov    ebp,dword ptr [mul32]
  xor    rbx,rbx
  jmp    scaleasm16_start

scaleasm16_add:
  add    rbx,2
scaleasm16_start:
  movsx  eax,word ptr [rsi+rbx]
  imul   ebp
  jo     scaleasm16_min
  shr    eax,16
  mov    word ptr [rdi+rbx],ax
  cmp    rbx,rcx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_min:
  and    edx,edx
  jz     scaleasm16_max
  mov    word ptr [rdi+rbx],&H8000 ' -32768
  cmp    rbx,rcx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_max:
  mov    word ptr [rdi+rbx],&H7fff ' +32767
  cmp    rbx,rcx
  jb     scaleasm16_add

scaleasm16_end:
  pop rbp
#endif
  end asm
end sub

private _
sub _PanLeftAsm16(byval d as any ptr, _ ' destination
                  byval s as any ptr, _ ' source
                  byval l as single , _ ' left paning
                  byval n as integer)   ' n samples
  dim as long mul32 = l*(1 shl 16) ' !!! changed to long !!!
  asm
#ifndef __FB_64BIT__  
  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,4

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    panleftasm16_start

panleftasm16_add:
  add    ebx,4
panleftasm16_start:
  movsx  eax,word ptr [esi+ebx] ' get left
  imul   ebp                    ' scale left
  jo     panleftasm16_min
  shr    eax,16
  mov    [edi+ebx],ax           ' set left
  mov    ax,[esi+ebx+2]         ' get right  
  mov    [edi+ebx+2],ax         ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_min:
  and    edx,edx
  jz     panleftasm16_max
  mov    word ptr [edi+ebx],&H8000 ' -32768 set left
  mov    ax,[esi+ebx+2]            ' get right  
  mov    [edi+ebx+2],ax            ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_max:
  mov    word ptr [edi+ebx],&H7fff ' +32767 set left
  mov    ax,[esi+ebx+2]            ' get right  
  mov    [edi+ebx+2],ax            ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add

panleftasm16_end:
  pop ebp
  
#else

  mov    rdi,[d]
  mov    rsi,[s]
  mov    rcx,[n]
  sub    rcx,4

  push   rbp
  mov    ebp,dword ptr [mul32]
  xor    rbx,rbx
  jmp    panleftasm16_start

panleftasm16_add:
  add    rbx,4
panleftasm16_start:
  movsx  eax,word ptr [esi+ebx] ' get left
  imul   ebp                    ' scale left
  jo     panleftasm16_min
  shr    eax,16
  mov    [rdi+rbx],ax           ' set left
  mov    ax,[rsi+rbx+2]         ' get right  
  mov    [rdi+rbx+2],ax         ' set right
  cmp    rbx,rcx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_min:
  and    edx,edx
  jz     panleftasm16_max
  mov    word ptr [rdi+rbx],&H8000 ' -32768 set left
  mov    ax,[rsi+rbx+2]            ' get right  
  mov    [rdi+rbx+2],ax            ' set right
  cmp    rbx,rcx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_max:
  mov    word ptr [rdi+rbx],&H7fff ' +32767 set left
  mov    ax,[rsi+rbx+2]            ' get right  
  mov    [rdi+rbx+2],ax            ' set right
  cmp    rbx,rcx
  jb     panleftasm16_add

panleftasm16_end:
  pop rbp
#endif  
  end asm
end sub

private _
sub _PanRightAsm16(byval d as any ptr, _ ' destination
                   byval s as any ptr, _ ' source
                   byval r as single,  _ ' right paning
                   byval n as integer)   ' n samples
  dim mul32 as integer = r*(1 shl 16)
  asm
#ifndef __FB_64BIT__
  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,4

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    panrightasm16_start

panrightasm16_add:
  add    ebx,4
panrightasm16_start:
  movsx  eax,word ptr [esi+ebx+2] ' get right
  imul   ebp                    ' scale right
  jo     panrightasm16_min
  
  shr    eax,16
  mov    [edi+ebx+2],ax         ' set right
  mov    ax,[esi+ebx]           ' get left  
  mov    [edi+ebx],ax           ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_min:
  and    edx,edx
  jz     panrightasm16_max
  mov    word ptr [edi+ebx+2],&H8000 ' -32768 set right
  mov    ax,[esi+ebx]            ' get left  
  mov    [edi+ebx],ax            ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_max:
  mov    word ptr [edi+ebx+2],&H7fff ' +32767 set right
  mov    ax,[esi+ebx]            ' get left  
  mov    [edi+ebx],ax            ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add

panrightasm16_end:
  pop ebp
  
#else

  mov    rdi,[d]
  mov    rsi,[s]
  mov    rcx,[n]
  sub    rcx,4

  push   rbp
  mov    ebp,dword ptr [mul32]
  xor    rbx,rbx
  jmp    panrightasm16_start

panrightasm16_add:
  add    rbx,4
panrightasm16_start:
  movsx  eax,word ptr [rsi+rbx+2] ' get right
  imul   ebp                    ' scale right
  jo     panrightasm16_min
  
  shr    eax,16
  mov    [rdi+rbx+2],ax         ' set right
  mov    ax,[rsi+rbx]           ' get left  
  mov    [rdi+rbx],ax           ' set left
  cmp    rbx,rcx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_min:
  and    edx,edx
  jz     panrightasm16_max
  mov    word ptr [rdi+rbx+2],&H8000 ' -32768 set right
  mov    ax,[rsi+rbx]            ' get left  
  mov    [rdi+rbx],ax            ' set left
  cmp    rbx,rcx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_max:
  mov    word ptr [rdi+rbx+2],&H7fff ' +32767 set right
  mov    ax,[rsi+rbx]            ' get left  
  mov    [rdi+rbx],ax            ' set left
  cmp    rbx,rcx
  jb     panrightasm16_add

panrightasm16_end:
  pop rbp
#endif
  
  end asm
end sub

'  ###############
' # 16 bit mono #
'###############
' copy samples and move the play pointer (speed is 1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopyRightAsm16(byval d as any ptr    , _ ' copy to destination
                    byval s as any ptr    , _ ' start of first sample
                    byval p as any ptr ptr, _ ' byref play pointer
                    byval e as any ptr    , _ ' end pointer
                    byval l as integer ptr, _ ' byref loop pointer
                    byval n as integer)       ' n bytes
  dim as integer loops
  asm
#ifndef __FB_64BIT__  
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi]
  mov [loops],esi                       ' loops = *pLoops 
  mov esi,[p]
  mov esi,[esi]                         ' pos = *pPlay
  mov ecx,[n]
  shr ecx,1                             ' nSamples = nBytes\2 (bytes to words)
  mov ebx,[s]
  mov edx,[e]
  and edx,&HFFFFFFFE

  copy_right_asm16_get:
  mov ax,[esi]
  mov [edi],ax
  add edi,2
  add esi,2                           ' pos += 2
  cmp esi,edx
  jge copy_right_asm16_reset          ' if pos pEnd then goto reset 
  dec ecx
  jnz copy_right_asm16_get
  jmp copy_right_asm16_end

  copy_right_asm16_reset:
  dec dword ptr [loops]               ' loops -= 1
  jz  copy_right_asm16_fill           ' if loops = 0 then  goto fill_rest_of_buffer with silence 
  sub esi,edx                         ' pos -= pEnd
  add esi,ebx                         ' pos += pStart  
  dec ecx                             ' nSamples -= 1 
  jnz copy_right_asm16_get
  jmp copy_right_asm16_end

  copy_right_asm16_fill:
  xor ax,ax                             ' silence
  copy_right_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx                               ' nSamples -= 1
  jnz copy_right_asm16_fillloop

 copy_right_asm16_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                          ' pLoops = loops
  
#else

  mov rdi,[d] 
  mov rsi,[l]
  mov rsi,[rsi]                      
  mov [loops],rsi                       ' loops = *pLoops 
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]
  shr rcx,1                             ' nSamples = nBytes\2 (bytes to words)
  mov rbx,[s]
  mov rdx,[e]
  and rdx,&HFFFFFFFFFFFFFFFE

  copy_right_asm16_get:
  mov ax,[rsi]
  mov [rdi],ax                        ' *d=[pos]
  add rsi,2                           ' pos += 2  
  add rdi,2                           ' d += 2
  cmp rsi,rdx
  jge copy_right_asm16_reset          ' if pos >= pEnd then goto reset 
  dec rcx                             ' nSamples -= 1
  jnz copy_right_asm16_get
  jmp copy_right_asm16_end

  copy_right_asm16_reset:
  dec qword ptr [loops]               ' loops -= 1
  jz  copy_right_asm16_fill 
  sub rsi,rdx                         ' pos -= pEnd
  add rsi,rbx                         ' pos += pStart
  dec rcx                             ' nSamples -= 1 
  jnz copy_right_asm16_get
  jmp copy_right_asm16_end

  copy_right_asm16_fill:
  xor ax,ax
  copy_right_asm16_fillloop:
  mov [rdi],ax
  add rdi,2
  dec rcx
  jnz copy_right_asm16_fillloop

  copy_right_asm16_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],eax                         ' pLoops = loops
#endif  
  end asm
end sub

' move only the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveRightAsm16(byval s as any ptr    , _ ' start of first sample
                    byval p as any ptr ptr, _ ' byref play pointer
                    byval e as any ptr    , _ ' end pointer
                    byval l as integer ptr, _ ' byref loop pointer
                    byval n as integer)       ' n bytes
  dim as integer loops
  asm
#ifndef __FB_64BIT__  
  mov esi,[l]
  mov edi,[esi] ' *l
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov ebx,[s]
  mov edx,[e]
  and edx,&HFFFFFFFE

  move_right_asm16_get:
  add esi,2
  cmp esi,edx
  jge move_right_asm16_reset
  dec ecx
  jnz move_right_asm16_get
  jmp move_right_asm16_end

  move_right_asm16_reset:
  dec edi
  jz  move_right_asm16_end 
  sub esi,edx
  add esi,ebx
  dec ecx
  jnz move_right_asm16_get

move_right_asm16_end:
  mov eax,[p]
  mov [eax],esi
  mov eax,[l]
  mov [eax],edi
  
#else

  mov rsi,[l]
  mov rdi,[rsi] ' *l
  mov rsi,[p]
  mov rsi,[rsi] ' *p
  mov rcx,[n]
  shr rcx,1 ' bytes to words
  mov rbx,[s]
  mov rdx,[e]
  and rdx,&HFFFFFFFFFFFFFFFE

  move_right_asm16_get:
  add rsi,2                             ' pos += 2
  cmp rsi,rdx                           
  jge move_right_asm16_reset            ' if pos >= pEnd then goto reset
  dec rcx                               ' nSamples -= 1
  jnz move_right_asm16_get
  jmp move_right_asm16_end

  move_right_asm16_reset:
  dec rdi                               ' loops-=1
  jz  move_right_asm16_end              ' if loops=0 then goto reset
  sub rsi,rdx                           ' pos -= pEnd
  add rsi,rbx                           ' pos += pStart
  dec rcx
  jnz move_right_asm16_get

move_right_asm16_end:
  mov rax,[p]
  mov [rax],rsi                         ' *pPlay = pos
  mov rax,[l]
  mov [rax],rdi                         ' *pLoop = loops
#endif  
  end asm
end sub

' copy samples and move the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceRightAsm16(byval d as any ptr    , _ ' copy to destination
                         byval s as any ptr    , _ ' start of first sample
                         byval p as any ptr ptr, _ ' byref play pointer 
                         byval e as any ptr    , _ ' end pointer
                         byval l as integer ptr, _ ' byref loop pointer
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' n bytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
#ifndef __FB_64BIT__  
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi]                         
  mov [loops],esi                       ' loops = *pLoops
  mov esi,[p]  
  mov esi,[esi]                         ' pos = *pPlay
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  xor ebx,ebx                           ' var value = 0

  copy_sliceright_asm16_get:
  mov ax,[esi]
  copy_sliceright_asm16_set:
  mov [edi],ax
  add edi,2
  add ebx,dword ptr [speed]             ' value += step
  mov edx,ebx                           ' tmp = value
  and ebx,&HFFFF                        ' value and = &HFFFF
  shr edx,15     ' words                ' tmp shr = 15 
  and edx,&HFFFE                        ' tmp and = &HFFFE 
  jnz copy_sliceright_asm16_add
  dec ecx
  jnz copy_sliceright_asm16_set
  jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_add:
  add esi,edx                           ' pos+= only N*2 (words)
  mov eax,[e]
  and eax,&HFFFFFFFE
  cmp esi,eax                          
  jge copy_sliceright_asm16_reset       ' pos >= pEnd then goto reset  
  dec ecx
  jnz copy_sliceright_asm16_get
  jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_reset:
  dec dword ptr [loops]                 ' loops-=1
  jz  copy_sliceright_asm16_fill        ' if loops=0 then fill rest of buffer with zero
  sub esi,eax                           ' pos -= pEnd
  add esi,dword ptr [s]                 ' pos += pStart
  dec ecx
  jnz copy_sliceright_asm16_get
  jmp copy_sliceright_asm16_end

copy_sliceright_asm16_fill:
  xor ax,ax                              ' left + right channel 0
copy_sliceright_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx
  jnz copy_sliceright_asm16_fillloop

copy_sliceright_asm16_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                         ' *pLoops = loops
  
#else

  mov rdi,[d] 
  mov rsi,[l]
  mov rsi,[rsi] ' *l
  mov [loops],rsi
  mov rsi,[p]
  mov rsi,[esi] ' *p
  mov rcx,[n]
  shr rcx,1 ' bytes to words
  xor rbx,rbx

  copy_sliceright_asm16_get:
    mov ax,[rsi]
  copy_sliceright_asm16_set:
    mov [rdi],ax
    add rdi,2
    add ebx,dword ptr [speed] ' !!! 32 bit onyl !!! value+=step
    mov rdx,rbx
    and rbx,&HFFFF
    shr rdx,15     ' words
    and rdx,&HFFFE
    jnz copy_sliceright_asm16_add
    dec rcx
    jnz copy_sliceright_asm16_set
    jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_add:
    add rsi,rdx    ' add only N*2 (words)
    mov rax,[e]
    and rax,&HFFFFFFFFFFFFFFFE
    cmp rsi,rax       
    jge copy_sliceright_asm16_reset     ' if pos>=pEnd then goto reset
    dec rcx
    jnz copy_sliceright_asm16_get
    jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_reset:
    dec qword ptr [loops]                ' loops-=1
    jz  copy_sliceright_asm16_fill 
    sub rsi,rax                          ' pos -= pEnd
    add rsi, qword ptr [s]               ' pos += pStart
    dec rcx
    jnz copy_sliceright_asm16_get
    jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_fill:
    xor ax,ax
  copy_sliceright_asm16_fillloop:
    mov [rdi],ax
    add rdi,2
    dec rcx
    jnz copy_sliceright_asm16_fillloop

  copy_sliceright_asm16_end:
    mov rdi,[p]
    mov [rdi],rsi                       ' pPlay = pos
    mov rdi,[l]
    mov rax,[loops]
    mov [rdi],rax                       ' pLoops = loops
#endif  
  end asm
end sub

' copy samples and move the play pointer in reverse direction (speed is <>1.0)
' if the play pointer reached the start of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceLeftAsm16(byval d as any ptr    , _ ' copy to destination
                        byval s as any ptr    , _ ' start of first sample
                        byval p as any ptr ptr, _ ' byref play pointer
                        byval e as any ptr    , _ ' end pointer
                        byval l as integer ptr, _ ' byref loop pointer
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' n bytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
#ifndef __FB_64BIT__  
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  xor ebx,ebx

  copy_sliceleft_asm16_get:
  mov ax,[esi]
  copy_sliceleft_asm16_set:
  mov [edi],ax
  add edi,2
  add ebx,dword ptr [speed] ' value+=step
  mov edx,ebx
  and ebx,&HFFFF
  shr edx,15     ' words
  and edx,&HFFFE
  jnz copy_sliceleft_asm16_sub
  dec ecx
  jnz copy_sliceleft_asm16_set
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_sub:    
  sub esi,edx    ' sub only N*4 (dwords)
  mov eax,[s]
  and eax,&HFFFFFFFE
  cmp esi,eax
  jle copy_sliceleft_asm16_reset
  dec ecx
  jnz copy_sliceleft_asm16_get
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_reset:
  dec dword ptr [loops]
  jz  copy_sliceleft_asm16_fill 
  sub esi,eax
  add esi,dword ptr [e]
  dec ecx
  jnz copy_sliceleft_asm16_get
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_fill:
  xor ax,ax
  copy_sliceleft_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx
  jnz copy_sliceleft_asm16_fillloop

  copy_sliceleft_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  
#else

  mov rdi,[d] 
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi                       ' loops = *pLoops
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]
  shr rcx,1                             ' nSamples = nBytes\2 (bytes to words)
  xor rbx,rbx
  xor rdx,rdx ' !!! added !!!

  copy_sliceleft_asm16_get:
  mov ax,[rsi]                          ' ax = [pos]
  copy_sliceleft_asm16_set:
  mov [rdi],ax                          ' d[rdi] = ax
  add rdi,2                             ' rdi += 2  
  add ebx,dword ptr [speed]             ' value+=step !!! 32 bit only !!! 
  mov rdx,rbx
  and ebx,&HFFFF
  shr edx,15                            ' 16: bytes 15: words 14 dwords
  and edx,&HFFFE
  jnz copy_sliceleft_asm16_sub
  dec rcx
  jnz copy_sliceleft_asm16_set
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_sub:    
  sub rsi,rdx                           ' pos -= 16:16 and &HFFFE (sub only N*4 dwords)
  mov rax,[s]
  and rax,&HFFFFFFFFFFFFFFFE
  cmp rsi,rax
  jle copy_sliceleft_asm16_reset        ' if pos <= pStart then goto reset
  dec rcx
  jnz copy_sliceleft_asm16_get
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_reset:
  dec qword ptr [loops]                 ' loops -= 1 
  jz  copy_sliceleft_asm16_fill         ' if loops <= 0 then goto fill_rest_of_buffer_with_silence 
  sub rsi,rax                           ' pos -= pStart
  add rsi,qword ptr [e]                 ' pos += pEnd
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceleft_asm16_get
  jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_fill:
  xor ax,ax
  copy_sliceleft_asm16_fillloop:
  mov [rdi],ax
  add edi,2
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceleft_asm16_fillloop

  copy_sliceleft_asm16_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                         ' *pLoops = loops 
#endif  
  end asm
end sub

' only move the play pointer (speed is <>1.0)
' if the play pointer reached the end pointer
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceRightAsm16(byval s as any ptr    , _ ' start of first sample
                         byval p as any ptr ptr, _ ' byref play pointer
                         byval e as any ptr    , _ ' end pointer
                         byval l as integer ptr, _ ' byref loop pointer
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' n bytes
  dim as integer loops
  dim as long  speed                               ' !!! changed to long !!!
  speed=abs(v*(1 shl 16))
  asm
#ifndef __FB_64BIT__  
  mov edi,[e]
  and edi,&HFFFFFFFE 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov edx,[speed]
  xor ebx,ebx

  move_sliceright_asm16_get:
  add ebx,edx
  mov eax,ebx
  and ebx,&HFFFF
  shr eax,15     ' words
  and eax,&HFFFE
  jnz move_sliceright_asm16_add
  dec ecx
  jnz move_sliceright_asm16_get
  jmp move_sliceright_asm16_end

  move_sliceright_asm16_add:    
  add esi,eax    ' add only N*2 (words)
  cmp esi,edi
  jge move_sliceright_asm16_reset
  dec ecx
  jnz move_sliceright_asm16_get
  jmp move_sliceright_asm16_end

  move_sliceright_asm16_reset:
  dec dword ptr [loops]
  jz  move_sliceright_asm16_end 
  sub esi,edi
  add esi,dword ptr [s]
  dec ecx
  jnz move_sliceright_asm16_get

move_sliceright_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  
#else

  mov rdi,[e]
  and rdi,&HFFFFFFFFFFFFFFFE 
  mov rsi,[l]
  mov rsi,[rsi] ' *l
  mov [loops],rsi
  mov rsi,[p]
  mov rsi,[rsi] ' *p
  mov rcx,[n]
  shr rcx,1 ' bytes to words
  
  xor rdx,rdx ' !!! added !!!
  xor rbx,rbx
  
  mov edx, dword ptr [speed]
  
  move_sliceright_asm16_get:
  add ebx,edx
  mov rax,rbx
  and ebx,&HFFFF
  shr eax,15                            ' 16:bytes 15:words 14:dwords
  and eax,&HFFFE
  jnz move_sliceright_asm16_add
  dec rcx
  jnz move_sliceright_asm16_get
  jmp move_sliceright_asm16_end

  move_sliceright_asm16_add:    
  add rsi,rax                           ' pos += 16:16 and &HFFFE (add only N*2 words)
  cmp rsi,rdi
  jge move_sliceright_asm16_reset       ' if pos >= pEnd then goto reset
  dec rcx
  jnz move_sliceright_asm16_get
  jmp move_sliceright_asm16_end

  move_sliceright_asm16_reset:
  dec qword ptr [loops]                 ' loops -= 1 
  jz  move_sliceright_asm16_end         ' if loops=0 then goto asm16_end
  sub rsi,rdi                           ' pos -= pEnd 
  add rsi, qword ptr [s]                ' pos += pStart
  dec rcx                               ' nSamples -= 1
  jnz move_sliceright_asm16_get

move_sliceright_asm16_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],eax                         ' *pLoops = loops
#endif  
  end asm
end sub

' only move the play pointer in reverse direction (speed is <>1.0)
' if the play pointer reached the start pointer
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceLeftAsm16(byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops
  dim as long speed = abs(v*(1 shl 16))   ' !!! changed to long !!!
  asm
#ifndef __FB_64BIT__  
  mov edi,[s]
  and edi,&HFFFFFFFE
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov edx,[speed]
  xor ebx,ebx

  move_sliceleft_asm16_get:
    add ebx,edx ' value+=step
    mov eax,ebx
    and ebx,&HFFFF
    shr eax,15     ' words
    and eax,&HFFFE
    jnz move_sliceleft_asm16_sub
    dec ecx
    jnz move_sliceleft_asm16_get
    jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_sub:    
    sub esi,eax    ' sub only N*2 (words)
    cmp esi,edi
    jle move_sliceleft_asm16_reset
    dec ecx
    jnz move_sliceleft_asm16_get
    jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_reset:
    dec dword ptr [loops]
    jz  move_sliceleft_asm16_end 
    sub esi,edi
    add esi,dword ptr [e]
    dec ecx
    jnz move_sliceleft_asm16_get

move_sliceleft_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  
#else

  mov rdi,[s]
  and rdi,&HFFFFFFFFFFFFFFFE
  mov rsi,[l]
  mov rsi,[rsi] ' *l
  mov [loops],rsi
  mov rsi,[p]
  mov rsi,[rsi] ' *p
  mov rcx,[n]
  shr rcx,1 ' bytes to words
  xor rdx,rdx                           ' !!! added !!!
  mov edx, dword ptr [speed]            ' !!! 32bit only
  xor rbx,rbx

  move_sliceleft_asm16_get:
  add ebx,edx                         ' value+=step
  mov rax,rbx
  and ebx,&HFFFF
  shr rax,15                          ' 16: bytes 15:words 14:dwords
  and rax,&HFFFE
  jnz move_sliceleft_asm16_sub
  dec rcx
  jnz move_sliceleft_asm16_get
  jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_sub:    
  sub rsi,rax                           ' pos -= 16:16 (sub only N*2 words)
  cmp rsi,rdi
  jle move_sliceleft_asm16_reset        ' if pos <= pStart then goto reset
  dec rcx
  jnz move_sliceleft_asm16_get
  jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_reset:
  dec qword ptr [loops]                 ' loops -= 1    
  jz  move_sliceleft_asm16_end 
  sub rsi,rdi                           ' pos -= pStart
  add rsi,qword ptr [e]                 ' pos += pEnd
  dec rcx                               ' nSamples -= 1   
  jnz move_sliceleft_asm16_get

  move_sliceleft_asm16_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                         ' *pLoops = loops
#endif  
  end asm
end sub

'  #################
' # 16 bit stereo #
'#################
' Copy samples from left and right channel (32bits) 
' to the current play position and move the play pointer (speed is 1.0)
' If the play pointer reached the end of samples (pEnd)
' decrement the loop counter and set play pointer to pStart.
'
'  pseudo code:
'
'  loops = *pLoops
'  while nSamples>0
'    *pDestination = *pPlay
'    nSamples-=1 : pDestionation += 1 : pPlay+=1
'    if pPlay >= pEnd then
'      pPlay = pStart : loops-=1
'      if loops=0 then exit while
'    end if
'  wend
'  *pLoops = loops
private _
sub _CopyRightAsm32(byval d as any ptr    , _ ' pDestination
                    byval s as any ptr    , _ ' pStart
                    byval p as any ptr ptr, _ ' @pPlay
                    byval e as any ptr    , _ ' pEnd
                    byval l as integer ptr, _ ' @nLoops
                    byval n as integer)       ' nBytes
  dim as integer loops
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]                   ' pDestination
  mov esi,[l]
  mov esi,[esi]
  mov [loops],esi               ' loops = *pLoops
  mov esi,[p]
  mov esi,[esi]                 ' position = *pPlay
  mov ecx,[n]                   ' nSamples = nBytes
  shr ecx,2                     ' nSamples\=4 (bytes to dwords)
  mov ebx,[s]                   ' pStart 
  mov edx,[e]                   ' pEnd

  copy_right_asm32_get:
  mov eax,[esi]
  mov [edi],eax               ' pDestionation = *pPlay 
  add edi,4                   ' pDestionation+=1 
  add esi,4                   ' pPlay+=1 
  cmp esi,edx                 ' if pPlay>=pEnd then ...
  jge copy_right_asm32_reset
  dec ecx
  jnz copy_right_asm32_get    ' more samples 
  jmp copy_right_asm32_end

  copy_right_asm32_reset:       ' ....
  dec dword ptr [loops]       ' loops-=1
  jz  copy_right_asm32_fill   ' if last loop fill rest of buffer with 0
  mov esi,ebx                 ' pPlay = pStart
  dec ecx
  jnz copy_right_asm32_get
  jmp copy_right_asm32_end

  copy_right_asm32_fill:
  xor eax,eax
  copy_right_asm32_fillloop:
  mov [edi],eax
  add edi,4
  dec ecx
  jnz copy_right_asm32_fillloop

  copy_right_asm32_end:
  mov edi,[p]
  mov [edi],esi               ' *pPlay = current pPlay
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax               ' *nLoops=loops
#else

  mov rdi,[d]                   ' pDestination
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi               ' loops = *pLoops
  mov rsi,[p]
  mov rsi,[rsi]                 ' position = *pPlay
  mov rcx,[n]                   ' nSamples = nBytes
  shr rcx,2                     ' nSamples\=4 (bytes to dwords)
  mov rbx,[s]                   ' pStart 
  mov rdx,[e]                   ' pEnd

  copy_right_asm32_get:
  mov eax, dword ptr [rsi]                ' !!! 32bit only
  mov dword ptr [rdi],eax                ' *pDestionation = eax
  add rdi,4                              ' pDestionation += 1 
  add rsi,4                              ' pos += 
  cmp rsi,rdx                          
  jge copy_right_asm32_reset             ' if pos >= pEnd then goto reset
  dec rcx
  jnz copy_right_asm32_get
  jmp copy_right_asm32_end

  copy_right_asm32_reset:
  dec qword ptr [loops]                 ' loops -= 1
  jz  copy_right_asm32_fill             ' if loops=0 then goto fill_rest_of_buffer_with  silene
  mov rsi,rbx                           ' pPlay = pStart
  dec rcx                               ' nSamples -= 1
  jnz copy_right_asm32_get
  jmp copy_right_asm32_end

  copy_right_asm32_fill:
  xor eax,eax
  copy_right_asm32_fillloop:
  mov dword ptr [rdi],eax
  add rdi,4
  dec rcx                               ' nSamples -= 1
  jnz copy_right_asm32_fillloop

  copy_right_asm32_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                         ' *nLoops = loops
#endif
  end asm
end sub

' move only the play pointer (speed is 1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveRightAsm32(byval s as any ptr    , _ ' pStart
                    byval p as any ptr ptr, _ ' @pPlay
                    byval e as any ptr    , _ ' pEnd
                    byval l as integer ptr, _ ' @nLoops
                    byval n as integer)       ' nBytes
  ' dim as integer loops
  asm
#ifndef __FB_64BIT__  
  mov esi,[l]
  mov edi,[esi]                         ' *pLoops
  mov esi,[p]
  mov esi,[esi]                         ' *pPlay
  mov ecx,[n]                           ' nBytes  
  shr ecx,2                             ' bytes to dwords
  mov ebx,[s]                           ' pStart
  mov edx,[e]                           ' pEnd
  and edx,&HFFFFFFFC

  move_right_asm32_get:
  add esi,4                            ' pos += 1
  cmp esi,edx
  jge move_right_asm32_reset           ' if pos >= pEnd then reset
  dec ecx                              ' nSamples -= 1
  jnz move_right_asm32_get      
  jmp move_right_asm32_end             ' if nSamples=0 then goto move_right_asm32_end

  move_right_asm32_reset:
  dec edi                              ' nLoops -= 1
  jz  move_right_asm32_end             ' if nLoops=0 then goto move_right_asm32_end
  mov esi,ebx                          ' pPlay = pStart 
  dec ecx                              ' nSamples -= 1  
  jnz move_right_asm32_get             ' if nSamples>0 then goto move_right_asm32_get

  move_right_asm32_end:
  mov eax,[p]
  mov [eax],esi                        ' *pPlay = pos
  mov eax,[l]
  mov [eax],edi                        ' *pLoop = loops
  
#else

  mov rsi,[l]
  mov rdi,[rsi]                         ' loops = *pLoops
  mov rsi,[p]                           ' pPlay
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]                           ' nBytes  
  shr rcx,2                             ' nSamples = nBytes\=4 (bytes to dwords)
  mov rbx,[s]                           ' pStart
  mov rdx,[e]                           ' pEnd
  and rdx,&HFFFFFFFFFFFFFFFC

  move_right_asm32_get:
  add rsi,4                            ' pos += 1
  cmp rsi,rdx
  jge move_right_asm32_reset           ' if pos >= pEnd then reset
  dec rcx                              ' nSamples -= 1
  jnz move_right_asm32_get      
  jmp move_right_asm32_end             ' if nSamples=0 then goto move_right_asm32_end

  move_right_asm32_reset:
  dec rdi                              ' nLoops -= 1
  jz  move_right_asm32_end             ' if nLoops=0 then goto move_right_asm32_end
  mov rsi,rbx                          ' pPlay = pStart 
  dec rcx                              ' nSamples -= 1  
  jnz move_right_asm32_get             ' if nSamples>0 then goto move_right_asm32_get

  move_right_asm32_end:
  mov rax,[p]
  mov [rax],rsi                        ' *pPlay = pos
  mov rax,[l]
  mov [rax],rdi                        ' *pLoop = loops
#endif
  end asm
end sub

' copy STEREO samples and move the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceRightAsm32(byval d as any ptr    , _ ' pDestination
                         byval s as any ptr    , _ ' pStart
                         byval p as any ptr ptr, _ ' @pPlay
                         byval e as any ptr    , _ ' pEnd
                         byval l as integer ptr, _ ' @nLoops
                         byval v as single     , _ ' value of speed
                         byval n as integer    )   ' nBytes
  dim as integer loops
  dim as long speed = abs(v*(1 shl 16)) ' !!changed to long !!! single to fixrd point 16:16
  asm
#ifndef  __FB_64BIT__
  mov edi,[d]                           ' destination buffer 
  mov esi,[l]                           ' ppLoops
  mov esi,[esi]                         ' *pLoops get nLoops from ptr
  mov [loops],esi                       ' save in local var loops
  mov esi,[p]                           ' pPlay
  mov esi,[esi]                         ' esi = *pPlay
  mov ecx,[n]                           ' nBytes
  shr ecx,2                             ' bytes to dwords
  xor ebx,ebx                           ' var value=0

  copy_sliceright_asm32_get:
  mov eax,[esi]                         ' get left and right channel from wave buffer
    
  copy_sliceright_asm32_set:
  mov [edi],eax                         ' *cptr(long ptr,esi)=samples
  add edi,4                             ' edi += 4
  add ebx,dword ptr [speed]             ' value += step
  mov edx,ebx                           ' save value
  and ebx,&HFFFF                        ' value and= 0000:FFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz copy_sliceright_asm32_add
    
  dec ecx                               ' nSamples -= 1 
  jnz copy_sliceright_asm32_set
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_add:
  add esi,edx                           ' add only N*4 (dwords)
  mov eax,[e]
  and eax,&HFFFFFFFC
  cmp esi,eax                 
  jge copy_sliceright_asm32_reset       ' if pPlay > pEnd then reset
    
  dec ecx
  jnz copy_sliceright_asm32_get
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_reset:
  dec dword ptr [loops]                 ' nLoops -= 1 
  jz  copy_sliceright_asm32_fill        ' if nLoops=0 then fill rest of buffer with 0
  sub esi,eax                           ' pPlay -= pEnd
  add esi,dword ptr [s]                 ' pPlay += pStart
  dec ecx
  jnz copy_sliceright_asm32_get
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_fill:
  xor eax,eax
  copy_sliceright_asm32_fillloop:
  mov [edi],eax
  add edi,4
  dec ecx
  jnz copy_sliceright_asm32_fillloop

  copy_sliceright_asm32_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                         ' *pLoops = loops
  
#else

  mov rdi,[d]                           ' destination buffer 
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi                       ' loops = *pLoops
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]                           ' nBytes
  shr rcx,2                             ' nSamples = nBytes\=4 (bytes to dwords)
  xor rbx,rbx                           ' var value=0
  xor rdx,rdx                           ' !!! added !!!
  
  copy_sliceright_asm32_get:
  mov eax, dword ptr [rsi]               ' get 32bit (left + right channel) from wave buffer
    
  copy_sliceright_asm32_set:
  mov dword ptr [rdi],eax               ' *cptr(long ptr,rdi)=samples
  add rdi,4                             ' rdi += 4
  add ebx, dword ptr [speed]            ' value += step !!! 32bit only !!!
  mov edx,ebx                           ' save value
  and ebx,&HFFFF                        ' value and= 0000:FFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz copy_sliceright_asm32_add
    
  dec ecx                               ' nSamples -= 1 
  jnz copy_sliceright_asm32_set
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_add:
  add rsi,rdx                           ' pos += 16:16 )add only N*4 dwords)
  mov rax,[e]
  and rax,&HFFFFFFFFFFFFFFFC
  cmp rsi,rax                 
  jge copy_sliceright_asm32_reset       ' if pos > pEnd then reset
    
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceright_asm32_get
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_reset:
  dec qword ptr [loops]                 ' nLoops -= 1 
  jz  copy_sliceright_asm32_fill        ' if nLoops=0 then fill_rest_of_buffer with silence
  sub rsi,rax                           ' pPlay -= pEnd
  add rsi, qword ptr [s]                ' pPlay += pStart
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceright_asm32_get
  jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_fill:
  xor eax,eax
  copy_sliceright_asm32_fillloop:
  mov dword ptr [rdi],eax                ' !!! 32bit only !!!
  add rdi,4
  dec rcx                                ' nSamples -= 1
  jnz copy_sliceright_asm32_fillloop

  copy_sliceright_asm32_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                         ' *pLoops = loops
#endif  
  end asm
end sub

' copy samples and move the play pointer in reverse direction (speed is < 0.0)
' if the play pointer reached the start of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceLeftasm32(byval d as any ptr    , _ ' copy to destination
                        byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops
  dim as long speed = abs(v*(1 shl 16))  ' !!! changed to long !!!
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]
  mov esi,[l]
  mov esi,[esi]
  mov [loops],esi                       ' loops = *pLoops
  mov esi,[p]
  mov esi,[esi]                         ' pos = *pPlay
  mov ecx,[n]                           ' nBytes
  shr ecx,2                             ' nSamples = nBytes\4 (bytes to dwords)
  xor ebx,ebx                           ' var value=0

  copy_sliceleft_asm32_get:
  mov eax,[esi]
  copy_sliceleft_asm32_set:
  mov [edi],eax
  add edi,4
  add ebx,dword ptr [speed]             ' value += step
  mov edx,ebx
  and ebx,&HFFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz copy_sliceleft_asm32_sub
  dec ecx
  jnz copy_sliceleft_asm32_set
  jmp copy_sliceleft_asm32_end

  copy_sliceleft_asm32_sub:
  sub esi,edx                           ' pos -= step subtract only N*4 (dwords)
  mov eax,[s]
  and eax,&HFFFFFFFC
  cmp esi,eax
  jle copy_sliceleft_asm32_reset        ' if pos <= pStart then goto reset
    
  dec ecx                               ' nSamples -= 1
  jnz copy_sliceleft_asm32_get          ' if nSamples > 0 then goto get_next_sample
  jmp copy_sliceleft_asm32_end          ' if nSamples = 0 then goto asm_end

  copy_sliceleft_asm32_reset:
  dec dword ptr [loops]                 ' loops -= 1
  jz  copy_sliceleft_asm32_fill         ' if loops=0 then goto fill_rest_of_buffer_with_zero (silent)
  sub esi,eax                           ' pos -= pStart 
  add esi,dword ptr [e]                 ' pos += pEnd
  dec ecx                               ' nSamples -= 1
  jnz copy_sliceleft_asm32_get          ' if nSamples > 0 then goto get_next_sample
  jmp copy_sliceleft_asm32_end          ' if nSamples = 0 then goto asm_end

  copy_sliceleft_asm32_fill:
  xor eax,eax
  
  copy_sliceleft_asm32_fillloop:
  mov [edi],eax                         ' fill with silent
  add edi,4
  dec ecx
  jnz copy_sliceleft_asm32_fillloop

  copy_sliceleft_asm32_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                          ' pLoops = loops
  
#else

  mov rdi,[d]
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi                       ' loops = *pLoops
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]                           ' nBytes
  shr rcx,2                             ' nSamples = nBytes\4 (bytes to dwords)
  xor rbx,rbx                           ' var value=0
  xor rdx,rdx                           ' !!! added !!! 
  
  copy_sliceleft_asm32_get:
  mov eax, dword ptr [rsi]              ' !!! 32 bit only !!!
  
  copy_sliceleft_asm32_set:
  mov dword ptr [rdi],eax
  add edi,4
  add ebx, dword ptr [speed]            ' value += step ' !!! 32 bit only !!!
  mov edx,ebx
  and ebx,&HFFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz copy_sliceleft_asm32_sub
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceleft_asm32_set
  jmp copy_sliceleft_asm32_end

  copy_sliceleft_asm32_sub:
  sub rsi,rdx                           ' pos -= 16:16 (subtract only N*4 dwords)
  mov rax,[s]
  and rax,&HFFFFFFFFFFFFFFFC
  cmp rsi,rax
  jle copy_sliceleft_asm32_reset        ' if pos <= pStart then goto reset
    
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceleft_asm32_get          ' if nSamples > 0 then goto get_next_sample
  jmp copy_sliceleft_asm32_end          ' if nSamples = 0 then goto asm_end

  copy_sliceleft_asm32_reset:
  dec qword ptr [loops]                 ' loops -= 1
  jz  copy_sliceleft_asm32_fill         ' if loops=0 then goto fill_rest_of_buffer with silence
  sub rsi,rax                           ' pos -= pStart 
  add rsi, qword ptr [e]                ' pos += pEnd
  dec rcx                               ' nSamples -= 1
  jnz copy_sliceleft_asm32_get          ' if nSamples > 0 then goto get_next_sample
  jmp copy_sliceleft_asm32_end          ' if nSamples = 0 then goto asm_end

  copy_sliceleft_asm32_fill:
  xor eax,eax
  
  copy_sliceleft_asm32_fillloop:
  mov dword ptr [rdi],eax               ' fill with silent
  add rdi,4
  dec rcx
  jnz copy_sliceleft_asm32_fillloop

  copy_sliceleft_asm32_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                          ' pLoops = loops
#endif  
  end asm
end sub

' Only move the play pointer to the right (speed is >0.0).
' If the play pointer reached the end of samples,
' the loop counter will be decremented,
' and the play pointer must be new calculated
private _
sub _MoveSliceRightasm32(byval s as any ptr    , _ ' pStart
                         byval p as any ptr ptr, _ ' @pPlay
                         byval e as any ptr    , _ ' pEnd
                         byval l as integer ptr, _ ' @nLoops
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' nBytes
  dim as integer loops
  dim as long speed = v*(1 shl 16)      ' fixed point 16:16  
  asm
#ifndef __FB_64BIT__
  mov edi,[e]
  and edi,&HFFFFFFFC                    ' pEnd 4 byte aligned
  mov esi,[l]
  mov esi,[esi]
  mov [loops],esi                       ' loops = *pLoops
  mov esi,[p]
  mov esi,[esi]                         ' pos = *pPlay
  mov ecx,[n]                           ' nBytes
  shr ecx,2                             ' nSamples = nBytes\4 (bytes to dwords)

  mov edx,[speed]                       ' steedstep = 16:16
  xor ebx,ebx                           ' var s = 0

  move_sliceright_asm32_get:            ' while nSamples > 0
  add ebx,edx                           '   s += steppstep
  mov eax,ebx                           '   eax = s
  and ebx,&HFFFF                        '   s and= 16:FFFF
  shr eax,14                            '   16:bytes 15:words 14:dwords
  and eax,&HFFFC                        '   eax and= 16:FFFC (multiply of 4 bytes = dwords)
  jnz move_sliceright_asm32_add         '   if eax<>0 then add eax as offset to pos
  dec ecx                               '   nSamples -= 1
  jnz move_sliceright_asm32_get         ' wend
  jmp move_sliceright_asm32_end          

  move_sliceright_asm32_add:
  add esi,eax                           ' pos += offset (multiply of 4 bytes dwords)
  cmp esi,edi
  jge move_sliceright_asm32_reset       ' if pos >= pEnd then goto reset
  dec ecx
  jnz move_sliceright_asm32_get
  jmp move_sliceright_asm32_end

  move_sliceright_asm32_reset:
  dec dword ptr [loops]                 ' loops-=1
  jz  move_sliceright_asm32_end         ' if loops=0 then goto end 
  sub esi,edi                           ' pos -= pEnd 
  add esi,dword ptr [s]                 ' pos += pStart
  dec ecx                               ' nSamples-=1
  jnz move_sliceright_asm32_get

  move_sliceright_asm32_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                         ' *pLoop = loops
  
#else

  mov rdi,[e]
  and rdi,&HFFFFFFFFFFFFFFFC            ' pEnd 4 byte aligned
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi                       ' loops = *pLoops
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]                           ' nBytes
  shr rcx,2                             ' nSamples = nBytes\4 (bytes -> dwords)
  xor rdx,rdx                           ' !!! added !!!
  xor rax,rax                           ' !!! added !!!
  xor rbx,rbx                           ' var s = 0
  
  mov edx, dword ptr[speed]             ' steedstep = 16:16 !!! 32bit only !!!
  
  move_sliceright_asm32_get:            ' while nSamples > 0
  add ebx,edx                           '   s += steppstep
  mov eax,ebx                           '   eax = s
  and ebx,&HFFFF                        '   s and= 16:FFFFF
  shr eax,14                            '   16:bytes 15:words 14:dwords
  and eax,&HFFFC                        '   eax and= 16:FFFC (multiply of 4 bytes = dwords)
  jnz move_sliceright_asm32_add         '   if eax<>0 then add eax as offset to pos
  dec rcx                               '   nSamples -= 1
  jnz move_sliceright_asm32_get         ' wend
  jmp move_sliceright_asm32_end

  move_sliceright_asm32_add:
  add rsi,rax                           ' pos += offset (multiply of 4 bytes dwords)
  cmp rsi,rdi
  jge move_sliceright_asm32_reset       ' if pos >= pEnd then goto reset
  dec rcx                               ' nSamples -= 1 
  jnz move_sliceright_asm32_get
  jmp move_sliceright_asm32_end         

  move_sliceright_asm32_reset:
  dec qword ptr [loops]                 ' loops-=1
  jz  move_sliceright_asm32_end         ' if loops=0 then goto asm32_end 
  sub rsi,rdi                           ' pos -= pEnd 
  add rsi, qword ptr [s]                ' pos += pStart
  dec rcx                               ' nSamples-=1
  jnz move_sliceright_asm32_get

  move_sliceright_asm32_end:
  mov rdi,[p]
  mov [rdi],rsi                       ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                       ' *pLoop = loops
#endif  
  end asm
end sub

' Only move the play pointer in reverse left direction (speed is <0.0).
' If the play pointer reached the start of samples,
' the loop counter will be decremented
' and the play pointer must be new calculated.
private _
sub _MoveSliceLeftasm32(byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops
  dim as long speed = abs(v*(1 shl 16)) ' !!! changed to long !!!
  asm
#ifndef __FB_64BIT__  
  mov edi,[s]
  and edi,&HFFFFFFFC                    ' pStart dword aligned
  mov esi,[l]
  mov esi,[esi]
  mov [loops],esi                       ' loops = *pLoops  
  mov esi,[p]
  mov esi,[esi]                         ' pos = *pPlay
  mov ecx,[n]                
  shr ecx,2                             ' nSamples = nBytes\4 (bytes to dwords)
  mov edx,[speed]                       ' speedstep = 16:16
  xor ebx,ebx                           ' var s = 0

  move_sliceleft_asm32_get:             ' while nSamples>0
  add ebx,edx                           '   s += speedstep
  mov eax,ebx                           '   offset = s   
  and ebx,&HFFFF                        '   s and= xxxx:FFFF
  shr eax,14                            '   16:bytes 15:words 14:dwords
  and eax,&HFFFC                        '   offset = dword aligned 
  jnz move_sliceleft_asm32_sub          '   if offset<>0 then subtract offset from pos
  dec ecx                               '   nSamples -= 1
  jnz move_sliceleft_asm32_get          ' wend
  jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_sub:    
  sub esi,eax                           ' pPlay -= offset (multiply of 4 = dwords)
  cmp esi,edi
  jle move_sliceleft_asm32_reset        ' if pPlay <= pStart then goto move_sliceleft_asm32_reset
  dec ecx
  jnz move_sliceleft_asm32_get
  jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_reset:
  dec dword ptr [loops]                 ' loops-=1
  jz  move_sliceleft_asm32_end          ' if loops=0 then goto move_sliceleft_asm32_end
  sub esi,edi                           ' pos -= pStart 
  add esi,dword ptr [e]                 ' pos += pEnd
  dec ecx
  jnz move_sliceleft_asm32_get

  move_sliceleft_asm32_end:
  mov edi,[p]
  mov [edi],esi                         ' *pPlay = pos
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax                         ' *pLoop = loops
  
#else

  mov rdi,[s]
  and rdi,&HFFFFFFFFFFFFFFFC            ' pStart dword aligned
  mov rsi,[l]
  mov rsi,[rsi]
  mov [loops],rsi                       ' loops = *pLoops  
  mov rsi,[p]
  mov rsi,[rsi]                         ' pos = *pPlay
  mov rcx,[n]                
  shr rcx,2                             ' nSamples = nBytes\4 (bytes -> dword)
  
  xor rbx,rbx                           ' var = 0
  
  mov edx,dword ptr [speed]             ' speedstep = 16:16
  
  move_sliceleft_asm32_get:
  add ebx,edx                           ' var += step
  mov rax,rbx                           ' clears high part of rax also important ! 
  and rbx,&HFFFF
  shr eax,14                            ' 16:bytes 15:words 14:dwords
  and eax,&HFFFC
  jnz move_sliceleft_asm32_sub
  dec rcx
  jnz move_sliceleft_asm32_get
  jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_sub:    
  sub rsi,rax                           ' pPlay -= 16:16 subtract only N*4 (dwords)
  cmp rsi,rdi
  jle move_sliceleft_asm32_reset        ' if pPlay <= pStart then goto move_sliceleft_asm32_reset
  dec rcx
  jnz move_sliceleft_asm32_get
  jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_reset:
  dec qword ptr [loops]                 ' loops-=1
  jz  move_sliceleft_asm32_end          ' if loops=0 then goto move_sliceleft_asm32_end
  sub rsi,rdi                           ' pos -= pStart 
  add rsi, qword ptr [e]                ' pos += pEnd
  dec rcx
  jnz move_sliceleft_asm32_get

  move_sliceleft_asm32_end:
  mov rdi,[p]
  mov [rdi],rsi                         ' *pPlay = pos
  mov rdi,[l]
  mov rax,[loops]
  mov [rdi],rax                         ' *pLoop = loops
#endif    
  end asm
end sub

#ifndef NO_MP3

' copy samples from MP3 STEREO stream to the current play pointer (speed is 1.0)
' move the play pointer if it reached the end, reset it
private _
sub _CopyMP3FrameAsm(byval pStart   as any ptr    , _ ' pStart
                     byval pPlay    as any ptr ptr, _ ' @pPlay
                     byval pEnd     as any ptr    , _ ' pEnd
                     byval pSamples as any ptr    , _
                     byval nBytes   as integer)
  asm
#ifndef __FB_64BIT__  
  mov esi,[pSamples]
  mov edi,[pPlay]
  mov edi,[edi]                         ' pos = *pPlay 
  mov ecx,[nBytes]
  shr ecx,2                             ' bytes to nSamples (dwords stereo 16bit)   
  mov ebx,[pStart]
  mov edx,[pEnd]  

  copy_mp3frame_get:
  mov eax,[esi]
  mov [edi],eax
  add edi,4
  add esi,4
  cmp edi,edx                 
  jge copy_mp3frame_reset               ' if pos >= pEnd then goto copy_mp3frame_reset
  dec ecx
  jnz copy_mp3frame_get
  jmp copy_mp3frame_end

  copy_mp3frame_reset:
  mov edi,ebx                           ' pos = pStart  
  dec ecx
  jnz copy_mp3frame_get

  copy_mp3frame_end:
  mov esi,[pPlay]
  mov [esi],edi                         ' *pPlay = pos
  
#else

  mov rsi,[pSamples]
  mov rdi,[pPlay]
  mov rdi,[rdi]                         ' pos = *pPlay 
  mov rcx,[nBytes]
  shr rcx,2                             ' nSamples = nBytes\4 (bytes -> dwords)   
  mov rbx,[pStart]
  mov rdx,[pEnd]  

  copy_mp3frame_get:
  mov eax,[rsi]                         ' !!! only 32bit !!!
  mov [rdi],eax
  add rsi,4
  add rdi,4
  
  cmp rdi,rdx                 
  jge copy_mp3frame_reset               ' if pos >= pEnd then goto copy_mp3frame_reset
  
  dec rcx
  jnz copy_mp3frame_get
  
  jmp copy_mp3frame_end

  copy_mp3frame_reset:
  mov rdi,rbx                           ' pos = pStart  
  dec rcx
  jnz copy_mp3frame_get

  copy_mp3frame_end:
  mov rsi,[pPlay]
  mov [rsi],rdi                         ' *pPlay = pos  
#endif
  end asm
end sub

' Copy samples from MP3 STEREO stream to the current play pointer (speed<>1.0).
' Move the play pointer if it reached the end reset it.
private _
sub _CopySliceMP3FrameAsm32(byval pStart   as any ptr    , _ ' start of first sample
                            byval pPlay    as any ptr ptr, _ ' @pPlay
                            byval pEnd     as any ptr    , _ ' last sample
                            byval pSamples as any ptr    , _ ' source of mp3 samples
                            byval v        as single     , _ ' value of speed
                            byval nBytes   as integer  )     ' n bytes
  dim as long speed=v*(1 shl 16)        ' !!! changed to long !!! single to fixed point 16:16
  asm
#ifndef __FB_64BIT__  
  mov edi,[pPlay] 
  mov edi,[edi]                         ' pos = *pPlay
  mov esi,[pSamples]
  mov ecx,[nBytes] 
  shr ecx,2                             ' nSamples=nBytes\4 (bytes -> dwords)
  xor ebx,ebx                           ' var value=0

  CopySliceStream32_get:
  mov eax,[esi]                         ' eax=*wavebuffer get stereo 16bit samples

  CopySliceStream32_set:
  mov [edi],eax                         ' *cptr(ulong ptr,pos) = eax
  add edi,4                             ' pos += 4
  cmp edi,dword ptr [pEnd]
  jge CopySliceStream32_reset           ' if pos >= pEnd then reset

  CopySliceStream32_calc:
  dec ecx                               ' nSamples -= 1
  jz  CopySliceStream32_end             ' if nSamples = 0 then goto end sub

  add ebx,dword ptr [speed]             ' value += step
  mov edx,ebx                           ' save value
  and ebx,&HFFFF                        ' value and = 0000:FFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz CopySliceStream32_add
  jmp CopySliceStream32_set

  CopySliceStream32_add:    
  add esi,edx                           ' add only N*4 (dwords)
  jmp CopySliceStream32_get

  CopySliceStream32_reset:
  mov edi,[pStart]                      ' pos = pStart  
  jmp CopySliceStream32_calc

  CopySliceStream32_end:
  mov esi,[pPlay]             
  mov [esi],edi                         ' *pPlay = pos
  
#else

  mov rdi,[pPlay] 
  mov rdi,[rdi]                         ' pos = *pPlay
  mov rsi,[pSamples]
  mov rcx,[nBytes] 
  shr rcx,2                             ' nSamples=nBy<tes\4 (bytes -> dwords)
  xor ebx,ebx                           ' var value=0
  xor edx,edx                           ' !!! added !!! 
  
  CopySliceStream32_get:
  mov eax,dword ptr [rsi]               ' !!! 32 bit only !!! eax=*wavebuffer get stereo 16bit samples

  CopySliceStream32_set:
  mov dword ptr [rdi],eax               ' !!! 32 bit only !!! *cptr(ulong ptr,pos) = eax
  add rdi,4                             ' pos += 4
  cmp rdi, qword ptr [pEnd]
  jge CopySliceStream32_reset           ' if pos >= pEnd then reset

  CopySliceStream32_calc:
  dec rcx                               ' nSamples -= 1
  jz  CopySliceStream32_end             ' if nSamples = 0 then goto end sub

  add ebx, dword ptr [speed]            ' !!! 32 bit only !!! value += step
  mov edx,ebx                           ' save value
  and ebx,&HFFFF                        ' value and = 0000:FFFF
  shr edx,14                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFC
  jnz CopySliceStream32_add
  jmp CopySliceStream32_set

  CopySliceStream32_add:    
  add rsi,rdx                           ' pos += 16:16 (add only N*4 dwords)
  jmp CopySliceStream32_get

  CopySliceStream32_reset:
  mov rdi,[pStart]                      ' pos = pStart  
  jmp CopySliceStream32_calc

  CopySliceStream32_end:
  mov rsi,[pPlay]             
  mov [rsi],rdi                         ' *pPlay = pos
#endif 
  end asm
end sub

' copy samples from MP3 MONO stream to the current play pointer (speed<>1.0)
' move the play pointer if it reached the end reset it
private _
sub _CopySliceMP3FrameAsm16(byval pStart   as any ptr    , _ ' first sample
                            byval pPlay    as any ptr ptr, _ ' @pPlay
                            byval pEnd     as any ptr    , _ ' last sample
                            byval pSamples as any ptr    , _ ' source of MP3 samples
                            byval v        as single     , _ ' value of speed 
                            byval nBytes   as integer  )     ' nBytes
  dim as long speed=v*(1 shl 16)        ' !!! changed to long !!! single to fixed point 16.16
  asm
#ifndef __FB_64BIT__  
  mov edi,[pPlay] 
  mov edi,[edi]                         ' pos = *pPlay
  mov esi,[pSamples]
  mov ecx,[nBytes]                      ' nBytes 
  shr ecx,1                             ' nSamples = nBytes\2 (bytes -> words)
  xor ebx,ebx                           ' var value=0

  CopySliceMP3Frame16_get:
  mov ax,[esi]                          ' ax = *pSamples (16 bit mono)

  CopySliceMP3Frame16_set:
  mov [edi],ax                          ' *ctr(word ptr,pos) = ax
  add  edi,2                            ' pos += 2
  cmp edi, dword ptr [pEnd]             ' if pos >= pEnd then reset  
  jge CopySliceMP3Frame16_reset

  CopySliceMP3Frame16_calc:
  dec ecx                                ' nSamples-=1
  jz  CopySliceMP3Frame16_end            ' if nSamples=0 then goto frame16_end

  add ebx,dword ptr [speed]              ' value+=step
  mov edx,ebx                            ' save value
  and ebx,&HFFFF                         ' value and= 0000:FFFF
  shr edx,15                             ' 16:bytes 15:words 14:dwords
  and edx,&HFFFE                         ' new address are a multiply of 2 (word)
  jnz CopySliceMP3Frame16_add
  jmp CopySliceMP3Frame16_set

  CopySliceMP3Frame16_add:    
  add esi,edx                           ' add only N*2 (words)
  jmp CopySliceMP3Frame16_get

  CopySliceMP3Frame16_reset:
  mov edi,[pStart]                      ' pos = pStart
  jmp CopySliceMP3Frame16_calc

  CopySliceMP3Frame16_end:
  mov esi,[pPlay]
  mov [esi],edi                         ' *pPlay = pos
  
#else

  mov rdi,[pPlay] 
  mov rdi,[rdi]                         ' pos = *pPlay
  mov rsi,[pSamples]
  mov rcx,[nBytes]                      ' nBytes 
  shr rcx,1                             ' nSamples = nBytes\2 (bytes -> words)
  xor rbx,rbx                           ' var value=0
  xor rdx,rdx                           ' !!! added !!!
  
  CopySliceMP3Frame16_get:
  mov ax, word ptr [rsi]                ' ax = *pSamples (16 bit mono)

  CopySliceMP3Frame16_set:
  mov word ptr [rdi],ax                 ' *ctr(word ptr,pos) = ax
  add rdi,2                             ' pos += 2
  
  cmp rdi, qword ptr [pEnd]             ' if pos >= pEnd then reset  
  jge CopySliceMP3Frame16_reset

  CopySliceMP3Frame16_calc:
  dec rcx                               ' nSamples-=1
  jz  CopySliceMP3Frame16_end           ' if nSamples=0 then goto frame16_end

  add ebx, dword ptr [speed]            ' !!! 32 bit only !!! value+=step
  mov edx,ebx                           ' save value
  and ebx,&HFFFF                        ' value and= 0000:FFFF
  shr edx,15                            ' 16:bytes 15:words 14:dwords
  and edx,&HFFFE                        ' new address are a multiply of 2 (word)
  jnz CopySliceMP3Frame16_add
  jmp CopySliceMP3Frame16_set

  CopySliceMP3Frame16_add:    
  add rsi,rdx                           ' pos += 16:16 (add only N*2 words)
  jmp CopySliceMP3Frame16_get

  CopySliceMP3Frame16_reset:
  mov rdi,[pStart]                      ' pos = pStart
  jmp CopySliceMP3Frame16_calc

  CopySliceMP3Frame16_end:
  mov rsi,[pPlay]
  mov [rsi],rdi                         ' *pPlay = pos
#endif  
  end asm
end sub

#undef MAD_F_ONE
#undef MAD_F_MIN
#undef MAD_F_MAX

#define MAD_F_ONE  &H10000000
#define MAD_F_MIN -MAD_F_ONE
#define MAD_F_MAX  MAD_F_ONE - 1

' fixed point 32 bit stereo to stereo interleaved 16 bit
#define MP3_SHIFTS 13
private  _
sub _ScaleMP3Frame_22_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval s2 as any ptr , _
                            byval n as integer  )
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]
  mov esi,[s1]
  mov ebx,[s2]
  mov ecx,[n]

  ScaleMP3Frame_22_16_get_left:
  mov eax,[esi]                         ' get 32bit from left channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_22_16_test_lmin
    
  mov word ptr [edi],&H7FFF
  jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_test_lmin:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_22_16_shift_left
  mov word ptr [edi],&H8000
  jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_shift_left:
  shr eax,MP3_SHIFTS                            ' !!! 13 mad fixed point value to 16:bit
  mov [edi],ax

  ScaleMP3Frame_22_16_get_right:
  mov eax,[ebx]                         ' get 32bit from right channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_22_16_test_rmin  
  mov word ptr [edi+2],&H7FFF     
  jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_test_rmin:  
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_22_16_shift_right  
  mov word ptr [edi+2],&H8000
  jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_shift_right:
  shr eax,MP3_SHIFTS                            ' !!! 13 mad fixed point value to 16:bit 
  mov [edi+2],ax

  ScaleMP3Frame_22_16_get_next:
  add esi,4 ' next dword left channel
  add ebx,4 ' next dword right channel
  add edi,4 ' next 16bit stereo sample
  dec ecx
  jnz ScaleMP3Frame_22_16_get_left
  
#else

  mov rdi,[d]
  mov rsi,[s1]
  mov rbx,[s2]
  mov rcx,[n]

  ScaleMP3Frame_22_16_get_left:
  mov eax, dword ptr [rsi] ' left channel
  cmp eax, MAD_F_MAX
  jng ScaleMP3Frame_22_16_test_lmin
    
  mov word ptr [rdi],&H7FFF
  jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_test_lmin:
  cmp eax, MAD_F_MIN
  jnl ScaleMP3Frame_22_16_shift_left
  
  mov word ptr [rdi],&H8000
  jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_shift_left:
  shr eax,MP3_SHIFTS                            ' !!! 13 mad fixed point value to 16:bit
  mov [rdi],ax                          ' samples[p]=ax

  ScaleMP3Frame_22_16_get_right:
  mov eax, dword ptr [rbx]              ' right channel
  cmp eax, MAD_F_MAX
  jng ScaleMP3Frame_22_16_test_rmin  
  
  mov word ptr [rdi+2],&H7FFF     
  jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_test_rmin:  
  cmp eax, MAD_F_MIN
  jnl ScaleMP3Frame_22_16_shift_right  
  
  mov word ptr [rdi+2],&H8000
  jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_shift_right:
  shr eax,MP3_SHIFTS                            ' !!! 13 mad fixed point value to 16:bit 
  mov [rdi+2],ax

  ScaleMP3Frame_22_16_get_next:
  add rsi,4 ' next dword left channel
  add rbx,4 ' next dword right channel
  add rdi,4 ' next stero channel (2*16bit)
  dec rcx
  jnz ScaleMP3Frame_22_16_get_left
#endif  
  end asm
end sub

' fixed point 32 bit stereo to mono 16 bit
private _
sub _ScaleMP3Frame_21_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval s2 as any ptr , _
                            byval n  as integer)
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]
  mov esi,[s1]
  mov ebx,[s2]
  mov ecx,[n]

  ScaleMP3Frame_21_16_get_L:
  mov edx,[esi]               ' edx = left channel
  cmp eax,MAD_F_MAX            ' !!! why not edx !!! 
  jng ScaleMP3Frame_21_16_test_left_min
  mov edx,&H7fff
  jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_test_left_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_21_16_shift_left
  mov edx,&H8000
  jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_shift_left:
  shr edx,MP3_SHIFTS                            ' !!! 13

  ScaleMP3Frame_21_16_get_R:
  mov eax,[ebx]               ' eax = right channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_21_16_test_right_min
  mov eax,&H7fff
  jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_test_right_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_21_16_shift_right
  mov eax,&H8000
  jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_shift_right:
  shr eax,MP3_SHIFTS                            ' !!! 13

  ScaleMP3Frame_21_16_get_next:
  add eax,edx                 ' 
  shr eax,2                   '  ax = (left + right)\2
  mov [edi],ax
  add edi,2
  add esi,4
  add ebx,4
  dec ecx
  jnz ScaleMP3Frame_21_16_get_L
  
#else

  mov rdi,[d]
  mov rsi,[s1]
  mov rbx,[s2]
  mov rcx,[n]
  
  ScaleMP3Frame_21_16_get_L:
  mov edx, dword ptr [rsi]              ' edx = left channel
  cmp edx,MAD_F_MAX
  jng ScaleMP3Frame_21_16_test_left_min
  mov edx,&H7fff
  jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_test_left_min:
  cmp edx,MAD_F_MIN
  jnl ScaleMP3Frame_21_16_shift_left
  mov edx,&H8000
  jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_shift_left:
  shr edx,MP3_SHIFTS                             ' !!! 13

  ScaleMP3Frame_21_16_get_R:
  mov eax, dword ptr [rbx]               ' eax = right channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_21_16_test_right_min
  mov eax,&H7fff
  jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_test_right_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_21_16_shift_right
  mov eax,&H8000
  jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_shift_right:
  shr eax,MP3_SHIFTS                            ' !!! 13 

  ScaleMP3Frame_21_16_get_next:
  add eax,edx
  shr eax,2                             '  ax = (left + right)\2
  mov [rdi],ax
  add rdi,2
  add rsi,4
  add rbx,4
  dec rcx
  jnz ScaleMP3Frame_21_16_get_L
#endif  
  end asm
end sub

' fixed point 32 bit mono to stereo 16 bit
private _
sub _ScaleMP3Frame_12_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval n  as integer)
  asm
#ifndef __FB_64BIT__  
  mov edi,[d]
  mov esi,[s1]
  mov ecx,[n]
  mov ebx,&H80008000
  mov edx,&H7FFF7FFF

  ScaleMP3Frame_12_16_get:
  mov eax,[esi]                         ' 32 bit fixed mono channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_12_16_test_min
  mov [edi],edx
  add edi,4
  add esi,4
  dec ecx
  jnz ScaleMP3Frame_12_16_get
  jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_test_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_12_16_shift
  mov [edi],ebx
  add edi,4
  add esi,4
  dec ecx
  jnz ScaleMP3Frame_12_16_get
  jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_shift:
  shr eax,MP3_SHIFTS                            ' !!! 13    
  mov [edi  ],ax
  mov [edi+2],ax
  add edi,4
  add esi,4
  dec ecx
  jnz ScaleMP3Frame_12_16_get
  
#else

  mov rdi,[d]
  mov rsi,[s1]
  mov rcx,[n]
  mov ebx,&H80008000
  mov edx,&H7FFF7FFF

  ScaleMP3Frame_12_16_get:
  mov eax, dword ptr [rsi]               ' 32 bit fixed mono channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_12_16_test_min
  
  mov [rdi],edx ' &H7FFF7FFF
  add rdi,4
  add rsi,4
  dec rcx
  jnz ScaleMP3Frame_12_16_get
  jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_test_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_12_16_shift
  mov [rdi],ebx ' &H80008000
  add rdi,4
  add rsi,4
  dec rcx
  jnz ScaleMP3Frame_12_16_get
  jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_shift:
  shr eax,MP3_SHIFTS                            ' !!! 13  
  mov [rdi  ],ax
  mov [rdi+2],ax
  add rdi,4
  add rsi,4
  dec rcx
  jnz ScaleMP3Frame_12_16_get
#endif
  ScaleMP3Frame_12_16_end:
  end asm
end sub

' fixed point 32 bit mono to mono 16 bit
private _
sub _ScaleMP3Frame_11_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval n  as integer)
  asm
#ifndef __FB_64BIT__
  mov edi,[d]
  mov esi,[s1]
  mov ecx,[n]
  
  mov bx,&H8000
  mov dx,&H7Fff   
  
  ScaleMP3Frame_11_16_get:
  mov eax,[esi]               ' 32 bit fixed point mono channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_11_16_test_min
  mov [edi],dx
  add esi,4
  add edi,2
  dec ecx
  jnz ScaleMP3Frame_11_16_get
  jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_test_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_11_16_shift
  mov [edi],bx
  add edi,2
  add esi,4
  dec ecx
  jnz ScaleMP3Frame_11_16_get
  jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_shift:
  shr eax,MP3_SHIFTS                            ' !!! 13
  mov [edi],ax
  add edi,2
  add esi,4
  dec ecx
  jnz ScaleMP3Frame_11_16_get

#else

  mov rdi,[d]
  mov rsi,[s1]
  mov rcx,[n]
  
  mov bx,&H8000
  mov dx,&H7Fff   
  
  ScaleMP3Frame_11_16_get:
  mov eax, dword ptr [rsi]               ' 32 bit fixed point mono channel
  cmp eax,MAD_F_MAX
  jng ScaleMP3Frame_11_16_test_min
  mov [rdi],dx ' &H7Fff
  add rsi,4
  add rdi,2
  dec rcx
  jnz ScaleMP3Frame_11_16_get
  jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_test_min:
  cmp eax,MAD_F_MIN
  jnl ScaleMP3Frame_11_16_shift
  mov [rdi],bx ' &H8000
  add rdi,2
  add rsi,4
  dec rcx
  jnz ScaleMP3Frame_11_16_get
  jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_shift:
  shr eax,MP3_SHIFTS                            ' !!! 13
  mov [rdi],ax
  add rsi,4
  add rdi,2
  dec rcx
  jnz ScaleMP3Frame_11_16_get  
#endif  
  ScaleMP3Frame_11_16_end:
  end asm
end sub
#endif

#undef MP3_SHIFTS

'  ##################
' # init cpu layer #
'##################
dim shared as FBS_CPU me


private _
function _ReadEFLAG() as integer
  asm
#ifndef __FB_64BIT__
   pushfd  'eflag on stack
   pop eax 'in eax
   mov [function],eax
#else  
   pushfq
   pop rax 'in rax
   mov [function],rax
#endif  
  end asm
end function

private _
sub _WriteEFLAG(byval v as integer)
  asm
#ifndef __FB_64BIT__
  mov eax,[v]  
  push eax
  popfd
#else
  'xor rax,rax
  mov rax,[v]
  push rax
  popfq
#endif  
  end asm
end sub

private _
function _IsCPUID() as boolean
  dim as integer o,n
  o = _ReadEFLAG()
  n = o xor (1 shl 21) ' change bit 21
  _WriteEFLAG(n)
  n = _ReadEFLAG()
  _WriteEFLAG(o)        ' restore old value
  return (o<>n)
end function 


private _
function _CPUID_EAX(byval nr as long) as long
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],eax
end function 

private _
function _CPUID_EBX(byval nr as long) as long
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],ebx
end function

private _
function _CPUID_ECX(byval nr as long) as long
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],ecx
end function

private _
function _CPUID_EDX(byval nr as long) as long
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],edx
end function 


#ifndef __FB_64BIT__
private _
function _ReadTSC() as longint
  static as longint r
  dim as long ptr p = cptr(long ptr,@r)
  asm
    rdtsc
    mov edi,[p]
    mov [edi],eax
    mov [edi+4],edx
  end asm
  return r
end function
#else
private _
function _ReadTSC() as longint
  asm
    rdtsc
    shl rdx, 32
    or  rax, rdx
    mov [function],rax
  end asm
end function
#endif

private _
function _IsFPU() as boolean 'FPU aviable
  dim as ushort tmp
  tmp = &HFFFF
  asm fninit         ' try FPU init
  asm fnstsw [tmp]   ' store statusword
  if tmp=0 then      ' is it really 0
    asm fnstcw [tmp] ' store control
    if tmp=&H37F then function = true
  end if
end function 

private _
sub fbscpu_init cdecl () FBS_GLOBAL_CTOR
  dim as string   msg
  dim as long  ct,r
  dim as longint c1,c2,cd
  dim as double t1,t2,td
  dprint("cpu:()")
  
  me.fpu = _IsFPU()
  
  if me.fpu then 
   
    me.cpuid = _IsCPUID()
    if me.cpuid then
      dim as ulong ptr p=cptr(ulong ptr, strptr(me.Vendor))
      p[0]=_CPUID_EBX(0)
      p[1]=_CPUID_EDX(0)
      p[2]=_CPUID_ECX(0)
      msg = me.Vendor
            
      #ifndef __FB_64BIT__
        msg &= ", X86"
      #else
        msg &= ", X86_64"   
        me.x86_64=true
      #endif
      
      r=_CPUID_EBX(1)
      me.nCores = (r shr 16) and &HFF
      if (me.Vendor = "GenuineIntel") then
        r=_CPUID_EDX(4)
        var nCores =  (r shr 26) and &H3F 
        if nCores then me.nCores=nCores+1
      elseif (me.Vendor = "AuthenticAMD") then
        r=_CPUID_ECX(( (1 shl 31) or (1 shl 3) ))
        var nCores = r and &HFF 
       if nCores then me.nCores=nCores+1
      end if
      if me.nCores then msg &= ", "  & me.nCores & " cpu cores"
        
      msg &= ", CPUID"   
       
      r=_CPUID_EDX(1)
      if (r and (1 shl  4)) then me.tsc =true
      if (r and (1 shl 15)) then me.cmov=true
      if (r and (1 shl 23)) then me.mmx =true
      if (r and (1 shl 25)) then
        me.sse=true
        if (r and (1 shl 26)) then me.sse2=true
      end if  

      r=_CPUID_ECX(1)
      if me.sse then
        if (r and (1 shl 9)) then
          me.sse3 =true
          if (r and (1 shl 19)) then
            me.sse41=true
            if (r and (1 shl 20)) then me.sse42=true   
          end if
        end if
      end if
      
      r=_CPUID_EAX(1 shl 31)
      if (r and (1 shl 31)) andalso (r and &HFF) then 
        r=_CPUID_EDX((1 shl 31) or (1 shl 0))
        if me.mmx then
          if (r and (1 shl 20)) then me.mmx2=true
        end if  
        if (r and (1 shl 31)) then
          me.n3d=true
          if me.n3d then
            if (r and (1 shl 30)) then me.n3d2=true
          end if  
        end if  
      end if
    end if ' me.cpuid
  end if ' me.fpu 
    
  if me.fpu  then msg &= ", FPU"
  if me.tsc  then msg &= ", RDTSC"
  if me.cmov then msg &= ", CMOVxx, FCMOVxx"
  
  if me.mmx then 
    msg &= ", MMX I"
    if me.mmx2 then msg &= ",II"
  end if

  if me.n3d then
    msg &= ", 3D NOW 1"
    if me.mmx2 then msg &= ",2"
  end if    

  if me.sse  then
    msg &= ", SSE"
    if me.sse2 then
      msg &= ",2"
      if me.sse3 then
        msg &= ",3"
        if me.sse41 then
          msg &= ",4.1"
          if me.sse42 then
            msg &= ",4.2"
          end if
        end if
      end if
    end if
  end if ' SSE         


  if me.tsc=true then
    t1=timer()
    c1=_ReadTSC()
    while td<1.0:t2=timer:td=t2-t1:wend
    c2=_ReadTSC()
    cd=c2-c1
    cd\=1000000
    me.MHz=cd*td
    msg &= " ~" & str(me.Mhz) & " MHz"
    
    me.CPUCounter=@_ReadTSC
    
  else  
    ct=1000000/2.25*100
    t1=timer()
    asm
    mov ecx,[ct]
    _tsc_loop:
      dec ecx
      cmp ecx,0
      jg _tsc_loop
    end asm
    t2=timer()
    td=t2-t1
    me.mhz=int(100.0/td)
    msg &= " ~" & str(me.Mhz) & " MHz"  
    
    me.CPUCounter=@_SoftCounter
    
  end if
  
  dprint(msg)

  if me.sse=true then 
    me.copy=@_copysse ': dprint("copy(SSE)")
  elseif me.mmx=true then
    me.copy=@_copymmx ': dprint("copy(MMX)")
  else
    me.copy=@_copyasm ': dprint("copy(ASM)")
  end if



  if me.mmx=true then
    'dprint("mixer(MMX)")
    me.mix16=@_mixmmx16
  else
    'dprint("mixer(ASM)")
    me.mix16=@_mixasm16
  end if

me.copy=@_copyAsm
me.mix16=@_mixAsm16

    
  'dprint("zero, scale, shift, pan, dsp(ASM)")
  me.zero        =@_ZeroAsm   
  me.zerobuffer  =@_ZeroBufferAsm   
  me.scale16     =@_ScaleAsm16

  me.panleft16   =@_panleftasm16
  me.panright16  =@_panrightasm16

  me.copyright16 =@_copyrightasm16
  me.copyright32 =@_copyrightasm32
  me.moveright16 =@_moverightasm16
  me.moveright32 =@_moverightasm32

  me.copysliceright16 =@_copyslicerightasm16
  me.copysliceright32 =@_copyslicerightasm32
  me.movesliceright16 =@_moveslicerightasm16
  me.movesliceright32 =@_moveslicerightasm32

  me.copysliceleft16 =@_copysliceleftasm16
  me.copysliceleft32 =@_copysliceleftasm32
  me.movesliceleft16 =@_movesliceleftasm16
  me.movesliceleft32 =@_movesliceleftasm32

#ifndef NO_MP3
  me.CopyMP3Frame        =@_CopyMP3FrameASM
  ' copy frame and convert playback rate to stereo output
  me.CopySliceMP3Frame32 =@_CopySliceMP3FrameASM32
  ' copy frame and convert playback rate to mono output
  me.CopySliceMP3Frame16 =@_CopySliceMP3FrameASM16
  ' scale stereo frame to 16bit stereo output
  me.ScaleMP3Frame_22_16 =@_ScaleMP3Frame_22_asm16
  ' scale stereo frame to 16bit mono output
  me.ScaleMP3Frame_21_16 =@_ScaleMP3Frame_21_asm16
  ' scale mono frame to 16bit stereo output
  me.ScaleMP3Frame_12_16 =@_ScaleMP3Frame_12_asm16
  ' scale mono frame to 16bit mono output
  me.ScaleMP3Frame_11_16 =@_ScaleMP3Frame_11_asm16
#endif

end sub

private _
sub fbscpu_exit cdecl () FBS_GLOBAL_DTOR
  dprint("cpu:~")
end sub

private _
function _SoftCounter() as longint
  return me.mhz*timer()*1000000.0
end function 

function IsX86_64() as boolean
  return me.X86_64
end function 

function IsFPU()  as boolean 
  return me.fpu
end function 

function IsTSC()  as boolean 
  return me.tsc
end function 

function IsCMOV() as boolean 
  return me.cmov
end function 

function IsMMX()  as boolean 
  return me.mmx
end function 

function IsMMX2() as boolean 
  return me.mmx
end function 

function Is3DNOW() as boolean 
  return me.n3d
end function 

function Is3DNOW2() as boolean 
  return me.n3d2
end function 

function IsSSE()  as boolean 
  return me.sse
end function 

function IsSSE2() as boolean 
  return me.sse2
end function 

function IsSSE3() as boolean 
  return me.sse3
end function

function IsSSE41() as boolean 
  return me.sse41
end function 

function IsSSE42() as boolean 
  return me.sse42
end function

function MHz() as integer 
  return me.mHz
end function 

function CPUCores() as integer 
  return me.nCores
end function 

function CPUCounter() as longint 
  return me.CPUCounter()
end function 

sub Zero(byval d as any ptr, _
         byval n as integer) 
  if (n>1) and (d<>0) then me.zero(d,n):exit sub
  dprint("cpu: Zero wrong param!")
end sub

sub ZeroBuffer(byval s as any ptr , _
               byval p as any ptr ptr, _
               byval e as any ptr , _
               byval n as integer  ) 
  if (n>0) and (s<>0) then me.zerobuffer(s,p,e,n):exit sub
  dprint("cpu: ZeroBuffer wrong param!")
end sub

sub Copy(byval d as any ptr, _
         byval s as any ptr, _
         byval n as integer ) 
  if (n>1) and (d<>0) and (s<>0) then me.copy(d,s,n):exit sub
  dprint("cpu: Copy wrong param!")
end sub

sub Mix16(byval d as any ptr, _
          byval a as any ptr, _
          byval b as any ptr, _
          byval n as integer ) 
  if (n>1) andalso (d<>0) andalso (a<>0) andalso (b<>0) andalso ((n and 1)=0) then me.Mix16(d,a,b,n):exit sub
  dprint("cpu: Mix16 wrong param!")
end sub

sub Scale16(byval d as any ptr, _
            byval s as any ptr, _
            byval v as single , _
            byval n as integer ) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso ((n and 1)=0) then me.scale16(d,s,v,n):exit sub
  dprint("cpu: Scale16 wrong param!")
end sub 

sub Pan16 (byval d as any ptr, _
           byval s as any ptr, _
           byval l as single , _
           byval r as single , _
           byval n as integer ) 
  if (n>0) andalso (d<>0) andalso (s<>0) andalso ((n and 1)=0)  andalso ((l=1) or (r=1))  then 
    if (l=1) then 
      me.panright16(d,s,r,n):exit sub
    else
      me.panleft16(d,s,l,n):exit sub  
    end if
  end if  
  dprint("cpu: Pan16 wrong param!")
end sub

sub CopyRight16(byval d as any ptr , _
                byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer  ) 
 if (n>0) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (s<>e) andalso (l<>0) andalso ((n and 1)=0) then me.copyright16(d,s,p,e,l,n) : exit sub
 dprint("cpu: CopyRight16 wrong param!")
end sub

sub CopyRight32(byval d as any ptr , _
                byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer  ) 
 if (n>0) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) then me.copyright32(d,s,p,e,l,n) : exit sub
 dprint("cpu: CopyRight32 wrong param!")
end sub

sub MoveRight16(byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer  ) 
 if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0)  andalso (l<>0) andalso ((n and 1)=0) then me.moveright16(s,p,e,l,n):exit sub
 dprint("cpu: MoveRight16 wrong param!")
end sub

sub MoveRight32(byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer) 
 if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) then me.moveright32(s,p,e,l,n):exit sub
 dprint("cpu: MoveRight32 wrong param!" & str(n))
end sub

sub CopySliceRight16(byval d as any ptr , _
                     byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v>0.0) then me.copysliceright16(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceRight16 wrong param!")
end sub

sub CopySliceRight32(byval d as any ptr , _
                     byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>3) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v>0.0) then me.copysliceright32(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceRight32 wrong param!")
end sub

sub CopySliceLeft16(byval d as any ptr , _
                    byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v<0.0) then me.copysliceleft16(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceLeft16 wrong param!")
end sub

' copy and slice stereo samples left to stereo
sub CopySliceLeft32(byval d as any ptr , _
                    byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer) 
  if (n>3) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) and (v<0.0) then me.copysliceleft32(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceLeft32 wrong param!")
end sub

' move and slice stereo samples right to mono
sub MoveSliceRight16(byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer) 
  if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v>0.0) then me.movesliceright16(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceRight16 wrong param!")
end sub
' move and slice stereo samples right to stereo
sub MoveSliceRight32(byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>3) andalso (s<>0) andalso (p<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v>0.0) then me.movesliceright32(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceRight32 wrong param!")
end sub
' move and slice stereo samples left to mono
sub MoveSliceLeft16(byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer  ) 
  if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v<0.0) then me.movesliceleft16(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceLeft16 wrong param!")
end sub

' move and slice stereo samples left to stereo
sub MoveSliceLeft32(byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer  ) 
  if (n>3) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v<0.0) then me.movesliceleft32(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceLeft32 wrong param!")
end sub

#ifndef NO_MP3

' copy MP3 frame with same samerate as output device
sub CopyMP3Frame(byval s as any ptr , _
                 byval p as any ptr ptr, _
                 byval e as any ptr , _
                 byval f as any ptr , _ 
                 byval n as integer  ) 
  me.CopyMP3Frame(s,p,e,f,n)
end sub

' stereo output
sub CopySliceMP3Frame32(byval s as any ptr , _
                        byval p as any ptr ptr, _
                        byval e as any ptr , _
                        byval f as any ptr , _
                        byval v as single  , _ 
                        byval n as integer  ) 
  me.CopySliceMP3Frame32(s,p,e,f,v,n)
end sub
' mono output
sub CopySliceMP3Frame16(byval s as any ptr , _
                        byval p as any ptr ptr, _
                        byval e as any ptr , _
                        byval f as any ptr , _
                        byval v as single  , _ 
                        byval n as integer  ) 
  me.CopySliceMP3Frame16(s,p,e,f,v,n)
end sub

' scale stereo frame to stereo output 
sub ScaleMP3Frame_22_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval s2 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_22_16(d,s1,s2,n)
end sub

' scale stereo frame to mono output
sub ScaleMP3Frame_21_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval s2 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_21_16(d,s1,s2,n)
end sub

' scale mono frame to stereo output
sub ScaleMP3Frame_12_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_12_16(d,s1,n)
end sub

' scale mono frame to mono output
sub ScaleMP3Frame_11_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_11_16(d,s1,n)
end sub
#endif
