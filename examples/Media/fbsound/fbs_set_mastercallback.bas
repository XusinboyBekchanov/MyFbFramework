'  ##############################
' # fbs_set_mastercallback.bas #
'##############################

#include "tests-common.bi"

' Example for user defined MASTER callbacks:

' fbs_Set_MasterCallback
' fbs_Enable_MasterCallback
' fbs_Disable_MasterCallback

' In this example i use the MasterBuffer callback
' It is the Buffer with samples after the filenameer pipeline.

' all callbacks in FBSOUND are from type BUFFERCALLBACK
' defined in "fbstypes.bi"


const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' !!! gfx screen must be on !!!
sub MyCallback(byval lpSamples as FBS_SAMPLE ptr, _
               byval nChannels as integer, _
               byval nSamples  as integer)
  static as integer counter
  dim as integer n,index,x,max_x=511
  dim as FBS_SAMPLE l,r

  nSamples-=1
  if nSamples<max_x then max_x=nSamples

  cls
  index=0
  pset(0,240+lpSamples[index] shr 5):index+=nChannels
  for x=1 to max_x
    line -(x,240 + (lpSamples[index] shr 5)),2
    index+=nChannels
  next
  if nChannels=2 then
    index=1
    pset(0,240+lpSamples[index] shr 5):index+=2
    for x=1 to max_x
      line -(x,240 + (lpSamples[index] shr 5)),4
      index+=2
    next
  end if
end sub

'
' main
'
dim as integer hWave,hSound,key
dim as boolean ok,Callback

screenres 512,512
windowtitle "[esc]=quit [c]=togle callback on/off"

fbs_Init()
fbs_Set_MasterCallback(@MyCallback)
fbs_Load_MP3File(data_path & "rnb_loop.mp3",@hWave)
fbs_Create_Sound(hWave,@hSound)
fbs_Play_Sound(hSound,-1) ' play it endless



' screen must be on for the callback
fbs_Enable_MasterCallback()
callback=true

' wait on first sample
while fbs_Get_PlayingSounds()=0:sleep 10:wend

'
' main loop
'
while (key<>27) and (fbs_Get_PlayingSounds>0)
  key=asc(inkey)
  if key=asc("c") then
    Callback xor=True ' togle callback on/off
    if Callback=true then 
      fbs_Enable_MasterCallback()
    else 
      fbs_Disable_MasterCallback()
    end if
    WindowTitle "[esc]=quit [c]=" & str(Callback)
  elseif key=27 then
    fbs_Disable_MasterCallback()
  end if
  sleep 100 ' time for WindowTitle and keyboards events
wend
end
