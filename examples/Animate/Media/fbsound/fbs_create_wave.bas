'  #######################
' # fbs_create_wave.bas #
'#######################

#include "tests-common.bi"

' example of:
' fbs_Create_Wave(nSamples,@hWAve,@lpSamples)

const data_path = TESTS_DATA_PATH

chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

if fbs_Init()=false then
  print "error: FBS_INIT() " & FBS_Get_PlugError()
  beep : sleep : end 1
end if


dim as integer nSamples = 44100
dim as integer hWave,hSound
dim as double  w,wstep=PI2/44100.0 * 400.0
dim as FBS_SAMPLE ptr pSamples
dim as FBS_SAMPLE ptr pS,pP,pE

' !!! create window before init fbsound !!!
dim as integer sw=640,sh=480
screenres sw,sh



fbs_Create_Wave(nSamples,@hWave,@pSamples)
for i as integer=0 to nSamples-1
  ' right channel
  pSamples[i*2  ]=sin(w   )*4000:w+=wstep
  ' left channel
  pSamples[i*2+1]=sin(w+PI)*4000:w+=wstep
next
fbs_Create_Sound(hWave,@hSound)
fbs_Get_SoundPointers(hSound,@pS,@pP,@pE)

sw\=2
sh\=2
for x as integer=0 to sw-1
  ' right channel
  pset (x   ,sh+pE[-sw*2+x*2  ]*0.01),3 ' end of samples
  pset (sw+x,sh+pS[      x*2  ]*0.01),4 ' start of samples
  ' left channel
  pset (x   ,sh+pE[-sw*2+x*2+1]*0.01),5 ' end of samples
  pset (sw+x,sh+pS[      x*2+1]*0.01),6 ' start of samples
next

fbs_Play_Sound(hSound,-1) ' loop endless
print "playing clean sin wave endless"
sleep
end
