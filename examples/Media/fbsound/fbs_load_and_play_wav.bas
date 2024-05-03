'  #############################
' # fbs_load_and_play_wav.bas #
'#############################

#include "tests-common.bi"

' example of:
' fbs_Load_WAVFile()
' fbs_Play_Wave()

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? FBS_Get_PlugError()
  beep:sleep:end 1
end if

dim as integer hWave
ok=fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
if ok=false then
  ? "error: fbs_Load_WAVFile() !"
  beep:sleep:end 1
end if

'get next free playback channel or create one
ok=fbs_Play_Wave(hWave)
if ok=false then
  ? "error: fbs_Play_Wave() !"
  beep:sleep:end 1
end if

'
' main loop
'
? "[p]   = begin new playback (4 loops)"
? "[esc] = quit"

dim as integer KeyCode
while KeyCode<>27
  KeyCode=asc(Inkey())
  if KeyCode=asc("p") then
    fbs_Play_Wave(hWave,4) ' optional 4 times
  else
    sleep 100
  end if
wend
end
