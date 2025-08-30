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

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
'FBS_Set_PlugPath( FBSOUND_DLL_PATH )

dim as integer hWave(10),i,soundn,maxsounds,new_nSounds,old_nSounds,hSound
dim as boolean ok

ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_Get_PlugError()
  beep:sleep:end 1
end if

dim as string filename
? "It will filename hundred sounds in realtime!"
?
? "loading 10 MP3 files in memory ..."
for i=0 to 9
  filename=data_path & "mixertest" & trim(str(i+1)) & ".mp3"
  if fbs_Load_MP3File(filename,@hWave(i))=false then
    ? "loading [" & filename & "] = false !"
    ? "error loading [" & filename & "] !"
  else
    ? "loading [" & filename & "] = true !"
  end if
next


fbs_Play_Wave(hWave(0))
while fbs_Get_PlayingSounds()=0:sleep 10:wend

'
' main loop
'
do
  if maxSounds<100 then
    SoundN=rnd*9
    ' play hWave(0-9) 2-5 times in random speed 0.5 to 1.5
    fbs_Play_Wave(hWave(SoundN),2+rnd*3,0.5+rnd)
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
