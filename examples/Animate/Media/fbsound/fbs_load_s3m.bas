'  ####################
' # fbs_load_s3m.bas #
'####################

#include "tests-common.bi"

' short test for:
' fbs_Load_MODFile("*.s3m")

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
fbs_Set_PlugPath( FBSOUND_DLL_PATH )

dim as integer hWave

if fbs_Init() then
  print "load: flshdanc.s3m" 
  if fbs_Load_MODFile(data_path & "flshdanc.s3m",@hWave) then
    dim as integer ms
    fbs_Get_WaveLength(hWave,@ms)
    print "length of 'flshdanc.s3m' = " & ms/1000 & " seconds" 
    if fbs_Play_Wave(hWave) then
      while fbs_Get_PlayingSounds()=0:sleep 10:wend
      print "wait on end of sound or press any key ..."
      while inkey()="" and fbs_Get_PlayingSounds()
        sleep 100
      wend
    end if
  end if
end if
