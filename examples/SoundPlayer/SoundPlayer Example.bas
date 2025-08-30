#include "tests-common.bi"
'#define FBSOUND_USE_DYNAMIC
#define FBSOUND_USE_STATIC
#include once "mff/SoundPlayer.bi"
Dim As WString * 260 FileName
FileName= "../Resources/" & "country.mp3"
Var Sound2 = SoundPlayer(FileName)
Sound2.Play
Print "play time: " & Sound.Length & " seconds"
Sleep(1000)
Dim as SoundPlayer SoundPlayer1
SoundPlayer1.LoadFile(FileName)
SoundPlayer1.Play
Print "press any key ..."
Sleep(8000)
End
