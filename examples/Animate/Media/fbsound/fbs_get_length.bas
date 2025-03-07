'  ######################
' # fbs_get_length.bas #
'######################

#include "tests-common.bi"

' short test for 
' fbs_Get_WaveLength(hWave,@MS)
' fbs_Get_SoundLength(hSound,@MS)

' fbs_Get_WaveLength 
' returns playback length in 1/1000 seconds 
' indepent from curentplayback speed and number of loops

' fbs_Get_SoundLength
' returns playback length in 1/1000 seconds 
' dependently on playback speed and number of loops

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

const last_number = 9
dim as integer hWave,hSound,SoundLength,WaveLength

fbs_Init()
fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
fbs_Create_Sound(hWave,@hSound)

fbs_Get_WaveLength (hWave ,@WaveLength)
fbs_Get_SoundLength(hSound,@SoundLength)
? "before playing:"
? "wave  length=" & wavelength *0.001 & " sec."
? "sound length=" & soundlength*0.001 & " sec."
?
fbs_Set_SoundSpeed(hSound,0.5) ' halfspeed
fbs_Play_Wave     (hWave,4)    ' 4 times
fbs_Play_Sound    (hSound,2)   ' 2 times
fbs_Get_WaveLength(hWave,@WaveLength)
fbs_Get_SoundLength(hSound,@SoundLength)

? "while playing:"
? "wave length indepent of speed and loops=" & WaveLength*0.001 & " sec."
? "sound length depently of speed and loops=" & SoundLength*0.001 & " sec."
?
? "press any key ..."
sleep
