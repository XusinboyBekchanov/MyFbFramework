#include "tests-common.bi"

#include once "fbsound/fbsound_oop.bi"

'FBS_Set_PlugPath( FBSOUND_DLL_PATH )

' Sound.Volume 
Dim As WString * 256 FileName
FileName = "../data/jimi.mod"
FileName = "../data/010.mp3"
FileName = "../data/legends.mp3"
'FileName = "../data/atem.wav"
Var Device  = SoundDevice()
Var Samples = SampleBuffer(FileName)

'Var Samples = SampleBuffer("../data/010.mp3")
Var Sound   = SoundBuffer(Samples)
Sound.Volume = 0.8
Sound.Play

Print "play time: " & Samples.Length & " seconds"
Print "press any key ..."
Sleep