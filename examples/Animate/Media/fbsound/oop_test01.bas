#include "tests-common.bi"

#include once "fbsound/fbsound_oop.bi"

fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' Sound.Play([nLoops])
' Samples.Length 

var Device  = SoundDevice()
var Samples = SampleBuffer("../data/jimi.mod")
var Sound   = SoundBuffer(Samples)
Sound.Play
print "play time: " & Samples.Length & " seconds"
print "press any key ..."
sleep
