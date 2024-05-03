'  #################################
' # fbs_set_sidstreamcallback.bas #
'#################################

#include "tests-common.bi"

' example of:
' fbs_Set_SIDStreamCallback()
' fbs_Enable_SIDStreamCallback()
' fbs_Disable_SIDStreamCallback()
' fbs_Set_SIDStreamVolume()

sub MyCallback(byval pSamples  as FBS_SAMPLE ptr, _
               byval nChannels as integer, _
               byval nSamples  as integer)
  dim as integer iWidth,iHeight,iBytes,iPitch,i,j,x,y
  dim as ubyte ptr row
  row=ScreenPtr() : if row = NULL then exit sub
  ScreenInfo iWidth,iHeight,,iBytes,iPitch
  if iBytes<>1 then exit sub
  screenlock
    line (0,0)-step(iWidth-1,iHeight-1),0,BF
    iHeight shr=1 
    pset(0,iHeight+pSamples[j] shr 7),16 : j+=8
    for i=1 to iWidth-1
      line -(i,iHeight+pSamples[j] shr 7),2 : j+=8
    next
  screenunlock
end sub


const MediaPath = TESTS_DATA_PATH
const Filename  = "comic_bakery.sid"
chdir(exepath())

fbs_Set_PlugPath( FBSOUND_DLL_PATH )
'
' main
'
if fbs_Init()=false then
  print "error: can't init fbsound !"
  print fbs_Get_PlugError()
  beep : sleep: end 1
end if
windowtitle fbs_Get_PlugName() & " : " & fbs_Get_PlugDevice()
ScreenRes FBS_Get_PlugFrames()\4,256,8

if fbs_Create_SIDStream(MediaPath & Filename)=false then
  print "error: can't load " & MediaPath & Filename & " !"
  beep : sleep: end 1
endif  



fbs_Set_SIDStreamCallback(@MyCallback)
fbs_Enable_SIDStreamCallback()
fbs_Play_SIDStream()
WindowTitle "play '" & Filename & "' [esc]=quit ..."

sleep
dim as single volume=1
while volume>0.025
  WindowTitle "fadeout " & volume
  volume*=0.9
  fbs_Set_SIDStreamVolume(volume)
  sleep 50
wend
fbs_Disable_SIDStreamCallback()
fbs_End_SIDStream()
