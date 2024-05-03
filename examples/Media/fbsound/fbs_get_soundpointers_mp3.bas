'  #################################
' # fbs_get_soundpointers_mp3.bas #
'#################################

#include "tests-common.bi"

' example for:
' fbs_Get_WavePointers(hWave,[@lpStart],[@lpEnd],[@nChannels])
' fbs_Get_SoundPointers(hSound,[@lpStart],[@lpPlay],[@lpEnd])

' see "fbs_set_soundpointers.bas" for:
' fbs_Set_SoundPointers(hSound,[@lpStart],[@lpPlay],[@lpEnd])



const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim shared as long xMax

' get load status in percent 0-100%
sub MP3LoadCB(byval percent as integer)
  dim as single boxSize = percent/100*xMax
  locate 1,1
  ? "wait while decode whole MP3 in memory."
  line (0,10)-step(xMax,15),7,B
  line (0,11)-step(boxSize,13),15,BF
  flip
end sub

dim as integer nSamples
screeninfo xMax : xMax *=0.75
screenres xMax,512,8,2
screenset 1,0

fbs_Init()


dim as integer hWave,hSound,nChannels,nFrames

fbs_Set_LoadCallback(@MP3LoadCB)
fbs_Enable_LoadCallback()
fbs_Load_MP3File(data_path & "legends.mp3",@hWave)

' get Number of Channels from loaded WAV/MP3
fbs_Get_WavePointers(hWave,,,@nChannels)

' create sound object from wave object
fbs_Create_Sound(hWave,@hSound)
nSamples = fbs_Get_PlugFrames()\nChannels
' start hSound
fbs_Play_Sound(hSound)
while fbs_Get_PlayingSounds()=0:sleep 10: wend

dim as short ptr pStart,pEnd,pOld,pPlay
dim as integer   index,lMax,rMax
dim as integer   frames,old_rMax,old_lMax
dim as single    x,xStep=xMax/nSamples
xMax-=1
while inkey<>chr(27) andalso fbs_Get_PlayingSounds()>0
  ' get current play pointer
  if fbs_Get_SoundPointers(hSound,,@pPlay)=true then
    ' draw only new samples
    if (pOld <> pPlay) then
      cls
      line (xMax,128)-(0,128),7
      index = 0 : x=0
      dim as integer lMaxAll
      for i as integer = 0 to nSamples-1
        var l = pPlay[index]:index+=nChannels
        lMaxAll += iif(l<0,-l,l)
        l shr=6
        line -(x,128+l),1+8 : x+=xStep
      next
      lMax = lMaxAll/13372*xStep
      line (0,0)-step(lMax,31),1,bf
      if lMax>old_lMax then old_lMax=lMax
      if old_lMax then circle (old_lMax,16),16,1+8,,,,F
      
      if nChannels>1 then
        index=1 : x=0 
        line (xMax,384)-(0,384),7
        dim as integer rMaxAll
        for i as integer = 0 to nSamples-1
          var r = pPlay[index] : index += 2
          rMaxAll += iif(r<0,-r,r)
          r shr= 6
          line -(x,384+r),4+8 : x += xStep
        next
        rMax = rMaxAll/13372*xStep
        line (0,511-32)-step(rMax,31),4,bf
        if rMax>old_rMax then old_rMax=rMax
        if old_rMax then circle (old_rMax,511-16),16,4+8,,,,F
      end if
      flip
      old_lMax -= 3 : old_rMax -= 3
      pOld = pPlay
    else
      ' no new samples wait a litle bit
      sleep 1
    end if
  else
    sleep 10
  end if  
wend
