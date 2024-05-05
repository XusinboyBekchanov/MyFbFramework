'  ########################
' # fbs_load_oggfile.bas #
'########################

#include "tests-common.bi"

' short test for libogg,libvorbis and libvorbisfile
' fbs_Load_OGGFile()

const data_path = TESTS_DATA_PATH
chdir(exepath())
' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim as integer   hWave,hSound
dim as double    t1,t2

fbs_Init()
print "please wait while decode 'legends.ogg' in memory!"
print
t1=timer
fbs_Load_OGGFile(data_path & "legends.ogg",@hWave)
t2=int(timer-t1)
print "done in " & t2 & " seconds"
print

print "create sound object from wave file"
print
fbs_Create_Sound(hWave,@hSound)
print "play sound object"
print
fbs_Play_Sound(hSound)
' wait on first sample
while fbs_Get_PlayingSounds()=0:sleep 10:wend

print "press any key for quit ...!"
while fbs_Get_PlayingSounds() and inkey()=""
  sleep 100
wend
end

