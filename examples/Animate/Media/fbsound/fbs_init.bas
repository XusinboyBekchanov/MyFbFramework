'  ################
' # fbs_init.bas #
'################

#include "tests-common.bi"

' example of: 
fbs_Set_PlugPath( FBSOUND_DLL_PATH )
' fbs_Init()
' fbs_Get_PlugError()

const data_path = TESTS_DATA_PATH
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./path_of_plugins")

' FBS_Init( [playbackrate in Hz.] optional default 44100
'          ,[number of channels]  optional default 2
'          ,[number of buffers]   optional default 3
'          ,[frames per buffer]   optional default 2048
'          ,[nPlugIndex]          optional default 0 = first
'          ,[nDeviceIndex]        optional default 0 = first) as boolean

dim as boolean ok=fbs_Init()
' FBS_Init() will try to use your values
' but if it can't set this values it will try other setups too.
' it is not save that all values from FBS_Init() are the same as yours
if ok=true then
  ? "Plugout                : ";FBS_Get_PlugName()
  ? "Hardware output device : ";FBS_Get_PlugDevice()
  ? "Samplerate             :";FBS_Get_PlugRate()
  ? "Bits per sample        :";FBS_Get_PlugBits()
  ? "Number of channels     :";FBS_Get_PlugChannels()
  ?
  ? "Internal Buffersettings"
  ? "Number of Buffers      :";FBS_Get_PlugBuffers()
  ? "Buffersize in bytes    :";FBS_Get_PlugBuffersize()
  ? "Number of Frames       :";FBS_Get_PlugFrames()
  ? "Framesize in bytes     :";FBS_Get_PlugFramesize()
  ?
  ? "[any key] =  quit"
else
  ? "error: fbs_Init() !"
  ? FBS_Get_PlugError()
  beep : sleep : end 1
end if
sleep


