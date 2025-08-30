#include "tests-common.bi"

#include once "fbsound/fbsound_oop.bi"

'FBS_Set_PlugPath( FBSOUND_DLL_PATH )

' device.volume

Var Device  = SoundDevice()
Var Samples = SampleBuffer("../data/fox.mp3")
Print "play time: " & Samples.Length & " seconds"
Var Sound   = SoundBuffer(Samples)
Sound.Play

Print "wait on end of playback or press any key ..."
Var w=0.0
While Inkey()="" AndAlso Sound.Playposition()<1.0
  Device.Volume = 0.6+Sin(w)*0.4 : w+=0.01
  Sleep 10,1
Wend