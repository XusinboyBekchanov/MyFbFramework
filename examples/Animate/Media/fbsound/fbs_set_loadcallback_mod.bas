'  ################################
' # fbs_set_loadcallback_mod.bas #
'################################

#include "tests-common.bi"

' example of:

' fbs_Set_LoadCallback()
' fbs_Load_MODFile()

const data_path = TESTS_DATA_PATH

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

' shared for the callback
dim shared as string CurFile

sub MyLoadCallback(byval percent as integer)
  locate 1,1
  print "loading " & CurFile & " " & percent & " % done"
end sub

dim as integer hWave
' in this example i use same sampleraste as the mp3 file!
if fbs_init()=true then
  
  if fbs_Set_LoadCallback(@MyLoadCallback)=true then
    fbs_Enable_LoadCallback()
  end if
  CurFile = "jimi.mod"
  if fbs_Load_MODFile(data_path & CurFile,@hWave)=true then
     'fbs_Play_Wave hWave,[loops],[speed],[volume],[pan],[@hSound]
     if fbs_Play_Wave(hWave)=false then
       ? "error: fbs_Play_Wave !"
       sleep:end 1
     else
       while fbs_Get_PlayingSounds=0:sleep 10:wend  
     end if
  else
    ? "error: fbs_Load_MODFile!"
    sleep:end 1
  end if
else
  ? "error fbs_Init()"
  beep:sleep:end 1
end if

? "playing ... press any key"
sleep
