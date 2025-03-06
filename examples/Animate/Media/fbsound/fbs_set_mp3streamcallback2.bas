'  ##################################
' # fbs_set_mp3streamcallback2.bas #
'##################################

#include "tests-common.bi"

' Example2 for user defined STREAM callbacks:

' fbs_Set_MP3StreamCallback
' fbs_Enable_MP3StreamCallback
' fbs_Disable_MP3StreamCallback
' fbs_Get_PlayingStreams()
' fbs_Get_MP3StreamVolume()
' fbs_Set_MP3StreamVolume()

' In this example i use the StreamBuffer callback again
' It is the Buffer with samples before the mixer pipeline

' This is a very simple Stereo eXpander
' Better and advanced sound FXs are in the DSP section of FBSOUND.

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' shared = readable from inside of the callback
dim shared as boolean InCallback,xStereo

sub MyCallback(byval pSamples  as FBS_SAMPLE ptr, _
               byval nChannels  as integer, _
               byval nSamples   as integer)
  ' !!! must be stereo !!!
  if (nChannels=1)  then exit sub
  ' not active
  if (xStereo=false) then exit sub
  InCallback=true
    '--------------------------------
    '   a litle bit bit assembler
    '--------------------------------
    ' for all=0 to nSamples-1
    '   diff_in  =(left_in-right_in)
    '   left_out =left_in  +  diff_in
    '   right_out=right_in + -diff_in
    '   _out in range -32768 - +32767
    ' next
    '--------------------------------
    asm
  #ifndef __FB_64BIT__
    mov ecx,[nSamples]
    mov esi,[pSamples]
    push bp
    mov bp,&H8000
    mov di,&H7FFF
    eXtra_loop:
      mov ax,[esi  ] ' left_in
      mov dx,[esi+2] ' right_in
      mov bx,ax
      sub bx,dx      ' diff_in=(left_in-right_in)
      add_l:
      add ax,bx      ' left_out+=diff_in
      jo test_c_l
      jmp sub_r
      test_c_l:
      jc  min_l
      mov ax,di      ' if left_out>+32767 then left_out=+32767
      jmp sub_r
      min_l:
      mov ax,bp      ' if left_out<-32768 then left_out=-32768
      sub_r:
      shl eax,16     ' left_out:
      mov ax,dx
      neg bx
      add ax,bx      ' right_out-=diff_in
      jo test_c_r
      jmp eXtra_next
      test_c_r:
      jc min_r
      mov ax,di      ' if right_out>+32767 then right_out=+32767
      jmp eXtra_next
      min_r:
      mov ax,bp      ' if right_out<-32768 then right_out=-32768
      eXtra_next:
      mov [esi],eax  ' left_out:right_out
      add esi,4      ' next stereo sample
      dec ecx        ' lopcounter-=1
    jnz eXtra_loop   ' not the last repeat it
    pop bp
#else
    mov rcx,[nSamples]
    mov rsi,[pSamples]
    push bp
    mov bp,&H8000
    mov di,&H7FFF
    eXtra_loop:
      mov ax,[rsi  ] ' left_in
      mov dx,[rsi+2] ' right_in
      mov bx,ax
      sub bx,dx      ' diff_in=(left_in-right_in)
      add_l:
      add ax,bx      ' left_out+=diff_in
      jo test_c_l
      jmp sub_r
      test_c_l:
      jc  min_l
      mov ax,di      ' if left_out>+32767 then left_out=+32767
      jmp sub_r
      min_l:
      mov ax,bp      ' if left_out<-32768 then left_out=-32768
      sub_r:
      shl eax,16     ' left_out:
      mov ax,dx
      neg bx
      add ax,bx      ' right_out-=diff_in
      jo test_c_r
      jmp eXtra_next
      test_c_r:
      jc min_r
      mov ax,di      ' if right_out>+32767 then right_out=+32767
      jmp eXtra_next
      min_r:
      mov ax,bp      ' if right_out<-32768 then right_out=-32768
      eXtra_next:
      mov [rsi],eax  ' left_out:right_out
      add rsi,4      ' next stereo sample
      dec rcx        ' lopcounter-=1
    jnz eXtra_loop   ' not the last repeat it
    pop bp
#endif
    end asm
  InCallback=false
end sub

'
' main
'
dim as integer KeyCode,nFrames
dim as boolean blnExit,blnFadeOut
dim as single  StreamVolume

fbs_Init()

fbs_Create_MP3Stream(data_path & "legends.mp3")
fbs_Set_MP3StreamCallback(@MyCallback)
fbs_Play_MP3Stream()
' wait on first decoded samples
while fbs_Get_PlayingStreams()=0:sleep 10:wend
fbs_Get_MP3StreamVolume(@StreamVolume)

? "[esc]=fade out and quit [x]=eXtra Stereo"
fbs_Enable_MP3StreamCallback()


'
' main loop
'
while (blnExit=False)
  KeyCode=asc(inkey)
  if KeyCode=asc("x") then
     xStereo = not xStereo ' togle Stereo on/off
    ? "[esc]=fade out [x] eXtra Stereo=" & str(xStereo)
  elseif (KeyCode=27) then
    if blnFadeOut=false then
      blnFadeOut=True
      fbs_Disable_MP3StreamCallback()
      ? "fade out and quit"
    end if
  end if
  if blnFadeOut=true then
    if (fbs_Get_MP3StreamVolume(@StreamVolume)=False) or (StreamVolume<0.1) then blnExit=True
    if StreamVolume>0.1 then
      StreamVolume*=0.99:fbs_Set_MP3StreamVolume(StreamVolume)
    end if
  elseif fbs_Get_PlayingStreams()=0 then 
    ? "end of stream !"
    blnExit=true
  end if
  sleep 30 ' time for keyboards events
wend
