'  ########################
' # fbs_destroy_wave.bas #
'########################

#include "tests-common.bi"

' example of: 
' fbs_Destroy_Wave(@hWave)

' scan the whole data folder for wav and mp3 files 
' and play it as short preview

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim   as integer nfiles,i,hWave,nSeconds
redim as string  files()
dim   as string  filename,key

' get all media files
filename=dir(data_path & "*.*")
while len(filename)
  redim preserve Files(nFiles)
  Files(nFiles)=data_path & filename
  nFiles+=1
  filename=dir()
wend

if nFiles<1 then
  ? "No media files in folder " & data_path
  beep:sleep:end 1
end if

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_get_plugerror()
  beep:sleep:end 1
end if

for i=0 to nFiles-1
  ? "loading " & files(i)
  if instr(files(i),".wav") then 
    ok=fbs_Load_WAVFile(files(i),@hWave)
  elseif instr(files(i),".mp3") then
    ok=fbs_Load_MP3File(files(i),@hWave)
  elseif instr(files(i),".ogg") then 
    ok=fbs_Load_OGGFile(files(i),@hWave)
  elseif instr(files(i),".mod") then 
    ok=fbs_Load_MODFile(files(i),@hWave)
  elseif instr(files(i),".it") then 
    ok=fbs_Load_MODFile(files(i),@hWave)
  elseif instr(files(i),".xm") then 
    ok=fbs_Load_MODFile(files(i),@hWave)
  elseif instr(files(i),".s3m") then 
    ok=fbs_Load_MODFile(files(i),@hWave)
  end if

  if ok=true then
    ok=fbs_Play_Wave(hWave)
    if ok=true then
      nSeconds=30 ' 30 * 0.1 = 3 seconds
      ? "wait while preview playing 3 seconds file " & Str(i+1) & " from " & Str(nFiles) & " files."
      Do
        Key=Inkey()
        Sleep 100
        nSeconds-=1
        ? "*";
      Loop While (fbs_Get_PlayingSounds()>0) and (nSeconds>0) and (Key<>Chr(27))
      ?
    end if  
    ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ' dont' add more and more files in the pool of waves
    ' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if fbs_Destroy_Wave(@hWave)=false then
      ? "error: can't destroy hWave"
    end if
  end if
  sleep 100
  if Key=chr(27) then exit for
next
