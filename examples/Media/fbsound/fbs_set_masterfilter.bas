'  ############################
' # fbs_set_masterfilter.bas #
'############################

#include "tests-common.bi"

' fbs_Volume_2_dB()
' fbs_Set_MasterFilter()
' fbs_Enable_MasterFilter()

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

screenres 640,480
windowTitle "[ESC]=quit move the mouse x,y"

dim as boolean ok
ok=fbs_Init()
if ok=False then
  ? "error: fbs_Init() !"
  ? fbs_Get_PlugError()
  beep:sleep:end 1
end if

dim as integer hWave
fbs_Load_MP3File(data_path & "fox.mp3",@hWave)

dim as single Volume=0.75,Hz=5040.0
fbs_Set_MasterFilter(0,Hz,fbs_Volume_2_dB(Volume))

fbs_Enable_MasterFilter(0)
fbs_Play_Wave(hWave,4) ' play it 4 times
while fbs_Get_PlayingSounds()=0:sleep 100:wend

'
' mainloop
'
dim as integer ox,oy,mx,my
ox=320:oy=240
setmouse ox,oy

while (asc(Inkey)<>27) and (fbs_Get_PlayingSounds()>0)
  if getmouse(mx,my)=0 then
    if (mx<>ox) or (my<>oy) then
       ox=mx:oy=my
       Hz=40+ (10000.0f/640.0f)*mx
       Volume=0.01 + (    1.5f/480.0f)*my
       locate 1,1
       ? str(Hz)     & " Hz.           "
       ? str(Volume) & " volume        "
       fbs_Set_MasterFilter(0,Hz,fbs_Volume_2_dB(Volume))
     end if
  end if
  sleep 10
wend
end
