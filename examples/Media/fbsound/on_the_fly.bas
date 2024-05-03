'  ######################
' # fbs_on_the_fly.bas #
'######################

#include "tests-common.bi"

fbs_Set_PlugPath( FBSOUND_DLL_PATH )

sub MyCallback(byval pSamples as FBS_SAMPLE ptr, _
               byval nChannels as integer, _
               byval nSamples  as integer)
  const as double PISTEP = PI2/44100.0
  static as FBS_SAMPLE sinus(44100-1)
  static as integer Hz(127) 
  static as boolean bInit = false
  static as integer frequence=440,wave_index=0
  static as integer old_played_seconds=0,played_samples=0
  
  if bInit=false then
    ' fill the array only once
    for i as integer=0 to ubound(sinus)
      sinus(i)=sin(i*PISTEP)*8000
    next  
    dim as integer a = 440 ' A is 440 hz...
    for x as integer = 0 to 127
      HZ(x) = (a / 32) * (2 ^ ((x - 9) / 12))
    next
    bInit=true
  end if
  
  
  dim as integer iLeft,iRight=1
  for i as integer=0 to nSamples-1
    pSamples[iLeft] = sinus(wave_index)
    pSamples[iRight] = pSamples[iLeft]*-1
    wave_index=(wave_index+frequence) mod 44100
    iLeft+=2
    iRight+=2
  next  
  
  played_samples+=nSamples
  
  dim as integer played_seconds = played_samples\44100
  if played_seconds<>old_played_seconds then
    old_played_seconds=played_seconds
    dim as integer note = 56+rnd*24 ' two octaves
    frequence=Hz(note)
    windowtitle "note: " & note & " frq: " & frequence
  end if  

  dim as integer n,index,x,max_x=511
  nSamples-=1
  if nSamples<max_x then max_x=nSamples

  cls
  pset(0,240+pSamples[index] shr 5):index+=nChannels
  for x=1 to max_x
    line -(x,240 + (pSamples[index] shr 5)),2
    index+=nChannels
  next
  if nChannels=2 then
    index=1
    pset(0,240+pSamples[index] shr 5):index+=2
    for x=1 to max_x
      line -(x,240 + (pSamples[index] shr 5)),4
      index+=2
    next
  end if
  flip
end sub

'
' main
'
dim as integer key

if fbs_Init()=false then
  print "error: fbs_Init() " & fbs_Get_PlugError()
  beep : sleep: end 1
end if

screenres 512,512,8,2
screenset 1,0
windowtitle "[esc]=quit"

fbs_Set_MasterCallback(@MyCallback)
fbs_Enable_MasterCallback()
'
' main loop
'
while (key<>27)
  key=asc(inkey)
  if key=27 then fbs_Disable_MasterCallback()
  sleep 100
wend

