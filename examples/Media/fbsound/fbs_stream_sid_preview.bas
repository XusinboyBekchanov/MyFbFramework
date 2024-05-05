'  ##############################
' # fbs_stream_sid_preview.bas #
'##############################

#include "tests-common.bi"

' example of get number of tunes in a SID file:
' fbs_Create_SIDStream(filename ,[PlayTune=0],[@nTunes])

chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

fbs_Init()

const DataPath = TESTS_DATA_PATH
const SIDFile  = "comic_bakery.sid"
const FilePath = DataPath & SIDFile

dim as integer nTunes,PlayTune=0

' play the first [tune=0] and optional get the number of tunes stored in a SID file.
if fbs_Create_SIDStream(FilePath,PlayTune,@nTunes)=false then
  ? "error: fbs_Create_SIDStream( '" & FilePath & "') !"
  beep : sleep : end 1  
end if

fbs_Play_SIDStream() ' start first tune

print "SID title  : " & fbs_Get_SIDTitle()
print "SID author : " & fbs_Get_SIDAuthor()
print "SID info   : " & fbs_Get_SIDInfo()
print
print "playing    ; " & SIDFile
print

' if more than one tune play it as preview's
if nTunes>1 then
  for PlayTune as integer=1 to nTunes-1
    print "play preview tune " & PlayTune & "/" & nTunes & " for 3 seconds"
    sleep 3000,1
    fbs_End_SIDStream()
    fbs_Create_SIDStream(FilePath, PlayTune)
    fbs_Play_SIDStream()
    if asc(inkey())=27 then exit for
  next  
else
  
end if

print "press any key ..."
sleep
fbs_End_SIDStream()
