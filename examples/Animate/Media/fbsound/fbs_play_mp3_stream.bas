'  ###########################
' # fbs_play_mp3_stream.bas #
'###########################

#include "tests-common.bi"

' example of:

' fbs_Create_MP3Stream()
' fbs_Play_MP3Stream()
' fbs_End_MP3Stream()
' fbs_Set_MP3StreamVolume()

const MEDIA = TESTS_DATA_PATH
const FILE  = "legends.mp3"  
const PATH  = MEDIA & FILE

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

fbs_Init()
fbs_Create_MP3Stream(PATH)
fbs_Play_MP3Stream()
print "playing " & PATH & " press any key ..."
sleep
if fbs_Get_PlayingStreams()>0 then
  print "fade out and quit !"
  dim as single volume=1.0
  while volume>0.025
    volume*=0.95
    fbs_Set_MP3StreamVolume(volume)
    sleep 20,1
  wend
end if
fbs_End_MP3Stream()