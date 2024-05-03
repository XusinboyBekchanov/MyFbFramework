'  ##################################
' # fbs_set_sound_paused_muted.bas #
'##################################

#include "tests-common.bi"

' example of:

' fbs_Get_SoundPaused(hSound,@paused)
' fbs_Set_SoundPaused(hSound, paused)
' fbs_Get_SoundMuted (hSound,@muted )
' fbs_Set_SoundMuted (hSound, muted )

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim as integer hWave,hSound,keycode
dim as boolean ok,paused,muted

ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  beep:sleep:end 1
end if

ok=fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
if ok=false then
  ? "error: fbs_Load_WaveFile() !"
  beep:sleep:end 1
end if

ok=fbs_Create_Sound(hWave,@hSound)
if ok=false then
  ? "error: fbs_Create_Sound() !"
  beep:sleep:end 1
end if

ok=fbs_Play_Sound(hSound,16) ' 16 times
if ok=false then
  ? "error: fbc_Play_Sound() !"
  beep:sleep:end 1
else
  while fbs_Get_PlayingSounds()=0:sleep 10:wend
end if

? "[esc]=quit [p]=pause on/off [m]=muting on/off"
while (KeyCode<>27)
  KeyCode=asc(Inkey)
  if KeyCode=asc("p") then
    fbs_Get_SoundPaused(hSound,@paused)
    paused xor = True ' togle pause on/off
    fbs_Set_SoundPaused(hSound, paused)
    ? "[esc]=quit [p]=" & str(paused) & " [m]=" & str(muted)
  elseif KeyCode=asc("m") then
    fbs_Get_SoundMuted(hSound,@muted)
    muted xor = True ' togle muting on/off
    fbs_Set_SoundMuted(hSound, muted)
    ? "[esc]=quit [p]=" & str(paused) & " [m]=" & str(muted)
  end if
  sleep 50
wend
end
