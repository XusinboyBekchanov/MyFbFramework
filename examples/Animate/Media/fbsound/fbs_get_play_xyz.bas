'  ########################
' # fbs_get_play_xyz.bas #
'########################

#include "tests-common.bi"

' example of:
' fbs_Get_PlayTime()
' fbs_Get_PlayedSamples()
' fbs_Get_PlayedBytes()

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

chdir(exepath())

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? FBS_Get_PlugError()
  beep:sleep:end 1
end if

dim as integer hWave
ok=fbs_Load_MP3File(data_path & "rnb_loop.mp3",@hWave)
if ok=false then
  ? "erro: fbs_LoadMP3File() !"
  beep:sleep:end 1
end if


ok=fbs_PLay_Wave(hWave,16) ' loop 16 times
if ok=false then
  ? "error: fbs_Play_Wave() !"
  beep:sleep:end 1
end if

'
' main loop
'
dim as boolean Status
dim as integer KeyCode

? "[s]  = togle printing status on/off"
? "[p]  = play it again or parallel"
? "[esc]= quit"


while (KeyCode<>27)
  KeyCode=asc(Inkey()) 
	if KeyCode=asc("s") then
	  Status xor = True ' togle printing on/off
	elseif KeyCode=asc("p") then 
	  fbs_PLay_Wave(hWave,16)
  end if
  if Status=True then
    cls
    ? "playtime in sec. =" & str(fbs_Get_PlayTime())
    ? "played samples   =" & str(fbs_Get_PlayedSamples())
    ? "played bytes     =" & str(fbs_Get_PlayedBytes())
    ? "[s]  = togle printing status on/off"
    ? "[p]  = play it again or parallel"
    ? "[esc]= quit"
	end if
  sleep 100	
wend
