'  ############################
' # fbs_set_get_pointers.bas #
'############################

#include "tests-common.bi"

' short test for 
' fbs_Get_WavePointers (hWave ,[@lpStart],[@lpEnd] ,[@nChannels])
' fbs_Get_SoundPointers(hSound,[@lpStart],[@lpPlay],[@lpEnd])
' fbs_Set_SoundPointers(hSound,[lpStart] ,[lpPlay] ,[lpEnd])

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim as integer   hWave,hSound,nSamples,nChannels
dim as short ptr lpWaveStart,lpWaveEnd
dim as short ptr lpSoundStart,lpSoundPlay,lpSoundEnd

fbs_Init()
fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
fbs_Create_Sound(hWave,@hSound)
' Get start,end and number of channels from wave object
fbs_Get_WavePointers(hWave,@lpWaveStart,@lpWaveEnd,@nChannels)
nSamples=(lpWaveEnd-lpWaveStart)/(2*nChannels)

' begin = start of the wave
lpSoundPlay = lpWaveStart
' any begin of playback region
lpSoundStart=lpWaveStart+(nSamples\32)*31
' any end of playback region
lpSoundEnd  =lpWaveEnd
fbs_Set_SoundPointers(hSound,lpSoundStart,lpSoundPlay,lpSoundEnd)

fbs_Play_Sound(hSound,4) ' 4 times
' wait on first sample
while fbs_Get_PlayingSounds()=0:sleep 10:wend

while fbs_Get_PlayingSounds() and inkey()=""
  sleep 100
wend
'end


