'  ##############################
' # fbs_load_mp3file_mixer.bas #
'##############################

#include "tests-common.bi"

#ifdef NOMP3
print "sorry no mp3 loader ! ..."
sleep : end
#else

' example of:
' fbs_Set_PlugPath()
' fbs_Init()
' fbs_Get_PlugError()
' fbs_Load_MP3File()
' fbs_Play_hWave()
' fbs_Get_PlayingSounds()

Const data_path = TESTS_DATA_PATH
ChDir(ExePath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

Dim As Integer hWave(10),i,soundn,maxsounds,new_nSounds,old_nSounds,hSound
Dim As Boolean ok

ok=FBS_Init()
If ok=False Then
  ? "error: fbs_Init() !"
  ? FBS_Get_PlugError()
  Beep:Sleep:End 1
End If

Dim As String filename
? "It will filename hundred sounds in realtime!"
?
? "loading 10 MP3 files in memory ..."
for i=0 to 9
  filename=data_path & "mixertest" & Trim(Str(i+1)) & ".mp3"
  If FBS_Load_MP3File(filename,@hWave(i))=False Then
    ? "loading [" & filename & "] = false !"
    ? "error loading [" & filename & "] !"
  Else
    ? "loading [" & filename & "] = true !"
  End If
Next


FBS_Play_Wave(hWave(0))
While FBS_Get_PlayingSounds()=0:Sleep 10:Wend

'
' main loop
'
Do
  If maxsounds<100 Then
    soundn=Rnd*9
    ' play hWave(0-9) 2-5 times in random speed 0.5 to 1.5
    FBS_Play_Wave(hWave(soundn),2+Rnd*3,0.5+Rnd)
    sleep 20
  end if
  new_nSounds=fbs_Get_PlayingSounds()
  if (new_nSounds <> old_nSounds) then
    if new_nSounds>maxsounds then maxSounds=new_nSounds
    print "Active playing sounds =" + str(new_nSounds)
    old_nSounds = new_nSounds
  end if
  sleep 10
  if inkey=chr(27) then exit do
loop while (old_nSounds>0)

#endif
