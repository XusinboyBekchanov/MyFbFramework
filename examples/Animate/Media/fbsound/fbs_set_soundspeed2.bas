'  ###########################
' # fbs_set_soundspeed2.bas #
'###########################

#include "tests-common.bi"

' example of:
' fbs_Set_SoundSpeed()

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

'
' main
'
dim as integer ox,mx,oy,my,ob,mb
dim as boolean muted,paused

screenres 640,480

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_get_plugerror()
  beep:sleep:end 1
end if

dim as integer hWave
ok=fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
if ok=false then
  ? "error: fbs_Load_WAVFile !"
  beep:sleep:end 1
end if

dim as integer hSound,Loops=-1 ' = endless
dim as single  Volume=1.0,Pan=0.0,Speed=1.0

line (320-16,240)-step(32,0),3
line (320,240-16)-step(0,32),3
ox=320:oy=240
while (mx<>ox) and (my<>oy)
  setmouse ox,oy
  sleep 100
  getmouse mx,my
wend

? "change playback pan   with the mouse (x)."
? "change playback speed with the mouse (y)."
? "left  button= togle pause"
? "right button= togle mute"
? "[any key] = quit"

'play and create an new sound from hWave
fbs_Play_Wave(hWave,Loops,Speed,Volume,Pan,@hSound)

while len(inkey)=0
  ' is mouse in window
  if getmouse(mx,my,,mb)=0 then
    if ob<>mb then
      ' left mouse button
      if (mb and 1)=1 then
        fbs_Get_SoundPaused(hSound,@paused)
        paused = not paused ' toggle
        fbs_Set_SoundPaused(hSound, paused)
      end if
      ' right mouse button
      if (mb and 2)=2 then
        fbs_Get_SoundMuted(hSound,@muted)
        muted = not muted ' toggle
        fbs_Set_SoundMuted(hSound, muted)
      end if
      ob=mb
      locate 6,1: print "pause: " + str(paused) + " mute: " + str(muted)
    end if
    ' x mouse
    if ox<>mx then
      pan=(mx-320)*(1.0/320.0)
      fbs_Set_SoundPan(hSound,Pan)
      ox=mx
      locate 7,1:print "pan  => " + str(pan) + "<               "
    end if
    ' y mouse
    if oy<>my then
      Speed=1.0+(my-240)*(2/240)
      fbs_Set_SoundSpeed(hSound,Speed)
      oy=my
      locate 8,1:print "speed=> " + str(speed) + "< " +str(fbs_Get_PlugRate()*speed) + " Hz.             "
    end if
  end if
  sleep 50
wend
end
