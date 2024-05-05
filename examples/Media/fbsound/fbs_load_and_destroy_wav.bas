'  ################################
' # fbs_load_and_destroy_wav.bas #
'################################

#include "tests-common.bi"

' simple speed test
' loading and reloading WAV files.

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )


dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  beep:sleep:end 1
end if

dim as integer hWave

? "any key = quit"
while inkey=""
  ? "loading      : ";
  fbs_Load_WAVFile(data_path & "atem.wav",@hWave)
  ? "ok"
  ? "wait on start: ";
  fbs_Play_Wave(hWave)
  while fbs_Get_PlayingSounds()=0:sleep 10:wend
  ? "ok "
  ? "wait on end  : ";
  while fbs_Get_PlayingSounds()>0:sleep 10:wend
  ? "ok":?
  ' !!! don't add more sounds in the pool of waves !!!
  fbs_Destroy_Wave(@hWave)
  sleep 100
wend  
end

