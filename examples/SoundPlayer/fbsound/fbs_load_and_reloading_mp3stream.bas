'  ########################################
' # fbs_load_and_reloading_mp3stream.bas #
'########################################

#include "tests-common.bi"

' simple speed test
' streaming decoding and reloading MP3.


Const data_path = TESTS_DATA_PATH

' only if not same as exe path
''FBS_Set_PlugPath( FBSOUND_DLL_PATH )

Dim As Boolean ok
ok=FBS_Init()
If ok=False Then
  ? "error: fbs_Init() !"
  Beep:Sleep:End 1
End If

? "any key = quit"
While Inkey=""
  ? "create stream: ";
  FBS_Create_MP3Stream(data_path & "atem.mp3")
  ? "ok"
  ? "wait on start: ";
  FBS_Play_MP3Stream()
  While FBS_Get_PlayingStreams()=0:Sleep 10:Wend
  ? "ok"
  ? "wait on end  : ";
  While FBS_Get_PlayingStreams()>0:Sleep 10:Wend
  ? "ok":?
  Sleep 100
Wend 
End


