'  ###########################
' # fbs_play_sid_stream.bas #
'###########################

#include "tests-common.bi"

#ifdef NOSID
 #error 666: sorry no SID decoder !
#endif

' example of:
' fbs_Create_SIDStream()
' fbs_Play_SIDStream()
' fbs_Get_PlayingStreams()
' fbs_Get_SIDTitle()
' fbs_Get_SIDAuthor()
' fbs_Get_SIDInfo()
' fbs_Set_SIDStreamVolume()
' fbs_End_SIDStream()

const MEDIA = TESTS_DATA_PATH
const FILE  = "comic_bakery.sid"
const PATH  = MEDIA & FILE
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )


dim as boolean ok

ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_Get_PlugError()
  beep:sleep:end 1
end if

ok=FBS_Create_SIDStream(PATH)
if ok=false then
  ? "error: fbs_Create_SIDStream( '" & PATH & "') !"
  beep:sleep:end 1  
end if

ok=FBS_Play_SIDStream()
if ok=false then
  ? "error: fbs_Play_SIDStream() !"
  beep:sleep:end 1  
end if

print "SID title : " & FBS_Get_SIDTitle()
print "SID author: " & FBS_Get_SIDAuthor()
print "SID info  : " & FBS_Get_SIDInfo()
print
print "playing " & PATH
print "press any key ..."
sleep
if fbs_Get_PlayingStreams()>0 then
  print "fade out and quit !"
  dim as single volume=1.0
  while volume>0.025
    volume*=0.95
    fbs_Set_SIDStreamVolume(volume)
    sleep 30,1
  wend
end if
fbs_End_SIDStream()
