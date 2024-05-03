'  ##############################
' # fbs_stream_mp3_preview.bas #
'##############################

#include "tests-common.bi"

' example of:
' fbs_End_MP3Stream()

' scan the whole data folder for wav and mp3 files 
' and play it as short preview
const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim   as integer nfiles,i,nSeconds
redim as string  files()
dim   as string  filename,key

' get all *.mp3
filename=dir(data_path & "*.mp3")
while len(filename)
  redim preserve files(nFiles)
  files(nFiles)=data_path & filename
  nFiles+=1
  filename=dir()
wend

if nFiles<1 then
  ? "No files found !"
  beep:sleep:end 1
end if

dim as boolean ok
ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_Get_PlugError()
  beep : sleep : end 1
end if

for i=0 to nFiles-1
  ? "straeming: " & files(i) 
  ok=fbs_Create_MP3Stream(files(i))
  if ok=true then
    ok=fbs_Play_MP3Stream()
    if ok=true then 
      while fbs_Get_PlayingStreams()=0:sleep 10:wend
    end if
  end if

  if ok=true then
     nSeconds=30 ' 30 * 0.1 = 3 seconds
    ? "wait while preview MP3 stream playing 3 seconds file " & Str(i+1) & " from " & Str(nFiles) & " files."
    Do
      Key=Inkey()
      Sleep 100
      nSeconds-=1
      ? "*";
    Loop While (fbs_Get_PlayingStreams()<>0) and (nSeconds>0) and (Key<>Chr(27))
    ?
    fbs_End_MP3Stream()
  end if
  sleep 100
  if Key=chr(27) then exit for
next

