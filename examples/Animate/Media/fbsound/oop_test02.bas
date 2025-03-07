#include "tests-common.bi"

#include once "fbsound/fbsound_oop.bi"

fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' Sound.Volume 

var Device  = SoundDevice()
var Samples = SampleBuffer("../data/jimi.mod")
var Sound   = SoundBuffer(Samples)
Sound.Volume = 0.8
Sound.Play

print "play time: " & Samples.Length & " seconds"
print "press any key ..."
sleep
