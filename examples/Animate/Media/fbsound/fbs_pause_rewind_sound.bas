'  ##############################
' # fbs_pause_rewind_sound.bas #
'##############################

#include "tests-common.bi"

' short test for 
' fbs_PauseRewindSound()

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

sub fbs_PauseRewindSound(byval hSound as integer)
  dim as short ptr pStart
  ' stop playback
  fbs_Set_SoundPaused(hSound,True)
  ' get start position
  fbs_Get_SoundPointers(hSound,@pStart)
  ' set it as current play postion
  fbs_Set_SoundPointers(hSound,,pStart)
end sub

dim as integer   hWave,hSound
fbs_Init()
print "please wait while decode 'legends.ogg' in memory!"
fbs_Load_OGGFile(data_path & "legends.ogg",@hWave)
fbs_Create_Sound(hWave,@hSound)
fbs_Play_Sound(hSound)
print "playing for 5 seconds"
sleep 5000
print "restart sound"
' pause and rewind
fbs_PauseRewindSound(hSound)
' restart the sound
fbs_Set_SoundPaused(hSound,False)
sleep
