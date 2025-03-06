#include "tests-common.bi"

#include once "fbsound/fbsound_oop.bi"

fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' Sound.PlayPosition
' Sound.Pan

var Device  = SoundDevice()
var Samples = SampleBuffer("../data/fox.mp3")
var Sound   = SoundBuffer(Samples)
var w=0.0
Sound.Play
print "play time: " & Samples.Length & " seconds"
print "wait on end of playback or press any key ..."
while inkey()="" andalso Sound.PlayPosition()<1.0
  Sound.Pan = sin(w) : w+=0.01
  sleep 10,1
wend
