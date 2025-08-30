#include "tests-common.bi"
'#define FBSOUND_USE_DYNAMIC
#define FBSOUND_USE_STATIC
#include once "mff/SoundPlayer.bi"
Dim As WString * 260 FileName
FileName= "../../Resources/" & "country.mp3"
Var Sound  =  SoundPlayer(FileName)
'Var Device  = SoundDevice()
'Var Samples = SampleBuffer(FileName)
'Var Sound   = SoundPlayer(Samples)
Sound.Play
Print "play time: " & Sound.Length & " seconds"
Print "press any key ..."
Sleep(8000)
End
