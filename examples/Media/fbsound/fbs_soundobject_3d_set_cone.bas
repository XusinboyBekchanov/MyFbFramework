'  ###################################
' # fbs_soundobject_3d_set_cone.bas #
'###################################

#include "tests-common.bi"

#include "fbsound/fbs3d.bi"

' test of:
' fbs_Set_Cone

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

sub DrawObject(byref o as FBS_SOUNDOBJECT, _
               byval t as string         , _
               byval c as integer)
  dim as integer w,h,x,y
  if screenptr=0  then exit sub
  screeninfo w,h
  w shr=1:h shr=1
  x=w + o.pos.x
  y=h - o.pos.z
  circle (x,y),30,c,,,,f
  circle (x,y),30,7
  draw string step (-len(t)*4,-4),t 
  if o.maxrange>0.0 then 
    if (o.penumbra>0.0) then
       
      line (x,y)-step( o.dir.x*o.maxrange, _
                      -o.dir.z*o.maxrange),3
      draw string step(0-len("maxrange")*4,0),"maxrange"
      line (x,y)-(x+cos(o.rot.y-1.57-o.penumbra)*o.maxrange, _
                  y+sin(o.rot.y-1.57-o.penumbra)*o.maxrange),15
      line (x,y)-(x+cos(o.rot.y-1.57+o.penumbra)*o.maxrange, _
                  y+sin(o.rot.y-1.57+o.penumbra)*o.maxrange),15
      draw string step(0-len("penumbra")*4,0),"penumbra"
      line (x,y)-(x+cos(o.rot.y-1.57-o.umbra)*o.maxrange, _
                  y+sin(o.rot.y-1.57-o.umbra)*o.maxrange),7
      line (x,y)-(x+cos(o.rot.y-1.57+o.umbra)*o.maxrange, _
                  y+sin(o.rot.y-1.57+o.umbra)*o.maxrange),7
      draw string step(0-len("umbra")*4,0),"umbra"
    else
      circle (x,y),o.maxrange,15
    end if
  end if
end sub

'
' main
'
dim as FBS_SOUNDOBJECT  listner
dim as FBS_SOUNDOBJECT  source
dim as single           volume,pan,oldVolume,oldPan,w
dim as integer          hWave,hSound,i
screenres 640,480
fbs_Init()
fbs_Load_WAVFile   (data_path & "pcar.wav",@hWave)
fbs_Create_Sound   (hWave,@hSound)
fbs_Set_SoundVolume(hSound,OldVolume)
fbs_Set_SoundPan   (hSound,OldPan)
fbs_Play_Sound     (hSound,1000)

fbs_Set_MaxRange(source,300)
fbs_Set_Cone(source,160*Deg2Rad,90*Deg2Rad)


i=-320
while inkey()=""
  fbs_Set_Rotation(source,0,w*3,0)
  fbs_Set_Position(source,cos(w)*100,0,sin(w)*200)
  screenlock:cls
    DrawObject(listner,"listner",1)
    DrawObject(source ,"source" ,2)
  screenunlock
  fbs_Get_VolumePan(@Volume,@Pan,listner,source)
  if (Volume<>OldVolume) or (Pan<>OldPan) then 
    if Volume<0.01 then Volume=0.01
    if (Volume<>OldVolume) then fbs_Set_SoundVolume(hSound,Volume)
    if (Pan   <>OldPan   ) then fbs_Set_SoundPan   (hSound,Pan   )
    OldVolume=Volume:OldPan=Pan
  end if
  sleep 50
  w+=0.01:i+=2
wend

