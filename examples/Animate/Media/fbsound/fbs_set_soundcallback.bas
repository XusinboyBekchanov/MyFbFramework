'  #############################
' # fbs_set_soundcallback.bas #
'#############################

#include "tests-common.bi"

' Example for user defined SOUND callback:

' fbs_Set_SoundCallback
' fbs_Enable_SoundCallback
' fbs_Disable_SoundCallback

' In this example i use the SoundBuffer callback
' It is the Buffer with samples before the mixer pileline

' This is a very simple phase shift and only an "how to" use callbacks.
' Better and advanced sound FXs are in the DSP section of FBSOUND.

' all callbacks in FBSOUND are from type BUFFERCALLBACK
' defined in "fbstypes.bi"

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim shared as boolean InCallback,PhaseShift 'global to read inside the callback
' !!! gfx screen must be on !!!
sub MyCallback(byval lpSamples as FBS_SAMPLE ptr, _
               byval nChannels as integer, _
               byval nSamples  as integer)
  dim as integer n,index,x,max_x=511
  dim as FBS_SAMPLE l,r
  InCallback=true
  nSamples-=1
  if nSamples<max_x then max_x=nSamples
  cls
  ' effekt=on
  if PhaseShift=true then
    for n=0 to nSamples
      lpsamples[index]*=-1
      index+=2
    next
  end if

  index=0
  pset(0,240+lpSamples[index]):index+=nChannels
  for x=1 to max_x
    line -(x,240 + (lpSamples[index] shr 5)),2
    index+=nChannels
  next
  if nChannels=2 then
    index=1
    pset(0,240+lpSamples[index]):index+=nChannels
    for x=1 to max_x
      line -(x,240 + (lpSamples[index] shr 5)),4
      index+=nChannels
    next
  end if
  InCallback=false
end sub

'
' main
'
dim as integer hWave,hSound,key,index,nFrames
dim as boolean ok,MonoFile
screenres 512,512
windowtitle "[esc]=quit [space]=togle PhaseShift on/off"

MonoFile=True ' test False too

ok=fbs_Init() 
if ok=false then
  ? "error: fbs_Init !"
  beep:sleep:end 1
end if

if MonoFile=true then
  ok=fbs_Load_MP3File(data_path & "rnb_loop.mp3",@hWave)
else
  ok=fbs_Load_MP3File(data_path & "atem.mp3",@hWave)
end if
if ok=false then
  ? "error: fbs_Load_MP3File !"
  beep:sleep:end 1
end if

fbs_Create_Sound(hWave,@hSound)
fbs_Set_SoundCallback(hSound,@MyCallback)
' screen must be on for the callback
fbs_Enable_SoundCallback(hSound)
fbs_Play_Sound(hSound,-1) ' play it endless
' wait on first sample
while fbs_Get_PlayingSounds()=0:sleep 10:wend

'
' main loop
'
while (key<>27) and (fbs_Get_PlayingSounds>0)
  key=asc(inkey)
  if (key=32) then
    if InCallback=false then
      PhaseShift xor=True ' togle PhaseShift on/off
      WindowTitle "[esc]=quit PhaseShift=" & str(PhaseShift)
    end if
  elseif (key=27) then
    if InCallback=false then
      fbs_Disable_SoundCallback(hSound)
    end if
  end if
  sleep 100 ' time for windowtitle and keyboard events
wend
end
