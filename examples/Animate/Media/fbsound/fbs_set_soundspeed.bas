'  ##########################
' # fbs_set_soundspeed.bas #
'##########################

#include "tests-common.bi"

' example of:
' fbs_Set_SoundSpeed() !!!

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

'
' main
'
dim as integer ox,oy,mx,my
screenres 640,480

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_get_plugerror()
  beep:sleep:end 1
end if

dim as integer hWave
ok=fbs_Load_MP3File(data_path & "rnb_loop.mp3",@hWave)
if ok=false then
  ? "error: fbs_Load_MP3File() !"
  beep:sleep:end 1
end if

dim as integer hSound
dim as single  speed=1.0

'play wave endless and create new sound object from wave object
ok=fbs_Play_Wave(hWave,-1,,,,@hSound)
if ok=false then
  ? "error: fbs_Play_Wave() !"
  beep:sleep:end 1
end if



ox=480:oy=240
while (mx<>ox) and (my<>oy)
  setmouse ox,oy
  sleep 100
  getmouse mx,my
wend

? "change playback speed with the mouse."
? "!!!!!!!!!!! -2.0 to +2.0 !!!!!!!!!!!!" 
? "[any key] = quit"

dim k as string
while len(inkey)=0
  if getmouse(mx,my)=0 then
    if ox<>mx then 
      speed=(mx-320)*(2/320)
      fbs_Set_SoundSpeed(hSound,speed)
      ox=mx
      locate 4,3:print "speed=> " + str(speed) + "< " +str(fbs_Get_Plugrate()*speed) + " Hz.       "
    end if
  end if
  sleep 50
wend
end
