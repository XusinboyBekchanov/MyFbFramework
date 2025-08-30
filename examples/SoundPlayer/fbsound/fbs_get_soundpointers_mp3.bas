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
'FBS_Set_PlugPath( FBSOUND_DLL_PATH )

Dim Shared As Long xMax

' get load status in percent 0-100%
Sub MP3LoadCB(ByVal percent As Integer)
  Dim As Single boxSize = percent/100*xMax
  Locate 1,1
  ? "wait while decode whole MP3 in memory."
  Line (0,10)-Step(xMax,15),7,B
  Line (0,11)-Step(boxSize,13),15,BF
  Flip
End Sub

Dim As Integer nSamples
ScreenInfo xMax : xMax *=0.75
ScreenRes xMax,512,8,2
ScreenSet 1,0

FBS_Init()


Dim As Integer hWave,hSound,nChannels,nFrames

FBS_Set_LoadCallback(@MP3LoadCB)
FBS_Enable_LoadCallback()
fbs_Load_MP3File(data_path & "legends.mp3",@hWave)

' get Number of Channels from loaded WAV/MP3
FBS_Get_WavePointers(hWave,,,@nChannels)

' create sound object from wave object
FBS_Create_Sound(hWave,@hSound)
nSamples = FBS_Get_PlugFrames()\nChannels
' start hSound
FBS_Play_Sound(hSound)
While FBS_Get_PlayingSounds()=0:Sleep 10: Wend

Dim As Short Ptr pStart,pEnd,pOld,pPlay
Dim As Integer   index,lMax,rMax
Dim As Integer   frames,old_rMax,old_lMax
Dim As Single    x,xStep=xMax/nSamples
xMax-=1
While Inkey<>Chr(27) AndAlso FBS_Get_PlayingSounds()>0
  ' get current play pointer
  If FBS_Get_SoundPointers(hSound,,@pPlay)=True Then
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