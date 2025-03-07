'  ################################
' # fbs_set_loadcallback_mp3.bas #
'################################

#include "tests-common.bi"

' example of:

' fbs_Set_LoadCallback()
' fbs_Enable_LoadCallback()
' fbs_Load_MP3File()

const Media = TESTS_DATA_PATH
const File  = "legends.mp3"  

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

sub MyLoadCallback(byval percent as integer)
  static as integer row=-1
  if row=-1 then row=CsrLin()+1
  locate row,1
  print "loading '" & Media & File & "' " & percent & " % done"
end sub

if fbs_Init()=false then
  ? "fatal error: can't init fbsound 1.2 !"
  beep : sleep : end 1
end if
fbs_Set_LoadCallback(@MyLoadCallback)
fbs_Enable_LoadCallback()

' decode MP3 as WAV file !
dim as integer hWave
fbs_Load_MP3File(Media & File, @hWave)
fbs_Play_Wave(hWave)
?
? "playing " & File
? "press any key ..."
sleep

