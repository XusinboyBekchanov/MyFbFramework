#ifndef __FBSOUND_DYNAMIC_BI__
#define __FBSOUND_DYNAMIC_BI__

'  ######################
' # fbsound_dynamic.bi #
'######################
' FBSound V1.2 Copyright 2005 - 2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

'#define NO_MP3       ' no MP3 sound and stream 
'#define NO_OOG       ' no Vorbis sound
'#define NO_MOD       ' no tracker modules
'#define NO_SID       ' no SID stream
'#define NO_CALLBACK  ' no load or buffer callbacks
'#define NO_DSP       ' no EQS Filter
#define NO_PITCHSHIFT ' no realtime pitch shifter

'#define DEBUG

#ifndef DEBUG 
 #if __FB_DEBUG__ ' -g has priority
  #define DEBUG
 #endif 
#endif
 
#ifdef DEBUG
  #define dprint(msg) open err for output as #99 : print #99,"debug: " & msg : close #99
#else
  #define dprint(msg) :
#endif

#ifndef NULL
 #define NULL cptr(any ptr,0)
#endif


const PI         as double = atn(1)*4
const PI2        as double = atn(1)*8
const rad2deg    as double = 180.0/PI
const deg2rad    as double = PI/180.0

#ifndef NO_CALLBACK
type FBS_SAMPLE    as short
type MONO_SAMPLE   as FBS_SAMPLE
type STEREO_SAMPLE field=1
  as MONO_SAMPLE   l,r
end type
' master,sound,stream callbacks
type tFBS_BUFFERCALLBACK as sub (byval pSamples  as FBS_SAMPLE ptr, _
                                 byval nChannels as integer       , _
                                 byval nSamples  as integer)
' load callback                                
type tFBS_LOADCALLBACK as sub (byval Percent as integer)
#endif

type tFBS_Init as function(byval nRate        as integer=44100, _
                           byval nChannels    as integer=    2, _
                           byval nBuffers     as integer=    3, _
                           byval nFrames      as integer= 2048, _
                           byval nPlugIndex   as integer=    0, _
                           byval nDeviceIndex as integer=    0) as boolean

' now fbs will start,stop and exit by it self
type tFBS_Start              as function () as boolean
type tFBS_Stop               as function () as boolean
type tFBS_Exit               as function () as boolean

type tFBS_Get_PlugPath       as function () as string
type tFBS_Set_PlugPath       as sub (byval NewPath as string)

type tFBS_Get_NumOfPlugouts  as function () as integer
type tFBS_Get_PlugName       as function () as string
type tFBS_Get_PlugDevice     as function () as string
type tFBS_Get_PlugError      as function () as string
type tFBS_Get_PlugRate       as function () as integer ' 6000Hz-96000Hz
type tFBS_Get_PlugBits       as function () as integer ' signed 16 bit
type tFBS_Get_PlugChannels   as function () as integer ' 1=mono 2=stereo
type tFBS_Get_PlugBuffers    as function () as integer ' 2 to N N<=64
type tFBS_Get_PlugBuffersize as function () as integer ' same as FrameSize*Frames
type tFBS_Get_PlugFrames     as function () as integer ' same as BufferSize\FrameSize
type tFBS_Get_PlugFramesize  as function () as integer ' same as BufferSize\Frames
type tFBS_Get_PlugRunning    as function () as boolean

type tFBS_Get_PlayingSounds  as function () as integer
type tFBS_Get_PlayingStreams as function () as integer

type tFBS_Get_PlayedBytes    as function () as integer
type tFBS_Get_PlayedSamples  as function () as integer
type tFBS_Get_PlayTime       as function () as double

type tFBS_Get_MasterVolume as function (byval pVolume as single ptr) as boolean
type tFBS_Set_MasterVolume as function (byval Volume   as single ) as boolean

type tFBS_Rad2Deg      as function (byval r as double) as double
type tFBS_Deg2Rad      as function (byval d as double) as double
type tFBS_Volume_2_DB  as function (byval v as single) as single
type tFBS_DB_2_Volume  as function (byval d as single) as single 
type tFBS_Pow          as function (byval x as double, byval y as double) as double

#ifndef NO_DSP
type tFBS_Set_MasterFilter as function (byval nFilter as integer, _
                                        byval Center  as single, _
                                        byval dB      as single, _
                                        byval Octave  as single = 1.0, _
                                        byval OnOff   as boolean = True) as boolean
type tFBS_Enable_MasterFilter  as function (byval nFilter as integer) as boolean
type tFBS_Disable_MasterFilter as function (byval nFilter as integer) as boolean                                        
 #ifndef NO_PITCHSHIFT
type tFBS_PitchShift as sub (byval d as short ptr, _
                             byval s as short ptr, _
                             byval v as single   , _
                             byval n as integer  )
 #endif
#endif

type tFBS_Get_MaxChannels as function (byval nChannels as integer ptr) as boolean
type tFBS_Set_MaxChannels as function (byval nChannels as integer ) as boolean

#ifndef NO_CALLBACK
type tFBS_Set_LoadCallback as function (byval cb as tFBS_LOADCALLBACK) as boolean
type tFBS_Enable_LoadCallback as function () as boolean
type tFBS_Disable_LoadCallback as function () as boolean

type tFBS_Set_MasterCallback as function (byval cb as tFBS_BUFFERCALLBACK) as boolean
type tFBS_Enable_MasterCallback as function () as boolean
type tFBS_Disable_MasterCallback as function () as boolean
#endif

' create or load wave objects in the pool of Waves as function ()

' create hWave from *.wav file
type tFBS_Load_WAVFile as function (byref Filename as string , _
                                    byval phWave   as integer ptr) as boolean
#ifndef NO_MP3
' create hWave from *.mp3,*.mp2,*.mp file
type tFBS_Load_MP3File as function (byref Filename as string      , _
                                    byval phWave   as integer ptr , _
                                    byref tmpPath  as string = "") as boolean
#endif

#ifndef NO_MOD
' create hWave from *.it *.xm *.sm3 or *.mod file
type tFBS_Load_MODFile as function (byref Filename as string       , _
                                    byval phWave  as integer ptr) as boolean
#endif

#ifndef NO_OOG
' create hWave from *.ogg file
type tFBS_Load_OGGFile as function (byref Filename as string      , _
                                    byval lphWave  as integer ptr , _
                                    byref tmpPath  as string ="") as boolean
#endif
' create hWave with nSamples in memory
type tFBS_Create_Wave as function (byval nSamples as integer     , _
                                   byval phWave   as integer ptr , _
                                   byval ppWave   as any ptr ptr) as boolean
' get playtime in MS
type tFBS_Get_WaveLength as function (byval hWave as integer, _
                                      byval pMS   as integer ptr) as boolean

' play any wave as sound from the pool of Waves()
' optional number of loops, playbackspeed, volume and pan
' if you need to change any param while playing use an hSound object
type tFBS_Play_Wave as function (byval hWave    as integer        , _
                                 byval nLoops   as integer = 1   , _
                                 byval Speed    as single  = 1.0 , _
                                 byval Volume   as single  = 1.0 , _
                                 byval Pan      as single  = 0.0 , _
                                 byval phSound  as integer ptr = NULL) as boolean

'create an playable sound object "hSound" from any "hWave" object
type tFBS_Create_Sound as function (byval hWave   as integer        , _
                                    byval phSound as integer ptr = NULL) as boolean


' [optinal] destroy/free created hSound's and hWave's
type tFBS_Destroy_Wave  as function (byval phWave  as integer ptr) as boolean
type tFBS_Destroy_Sound as function (byval phSound as integer ptr) as boolean

' play an hSound object
type tFBS_Play_Sound as function (byval hSound as integer , _
                                  byval nLoops as integer = 1) as boolean
' play time in MS
type tFBS_Get_SoundLength as function (byval hSound as integer , _
                                       byval pMS    as integer ptr) as boolean


' get and set any params from playing hSound
type tFBS_Set_SoundSpeed as function (byval hSound as integer , _
                                      byval Speed  as single) as boolean
type tFBS_Get_SoundSpeed as function (byval hSound as integer , _
                                      byval pSpeed as single ptr) as boolean

type tFBS_Set_SoundVolume as function (byval hSound as integer , _
                                       byval Volume as single) as boolean
type tFBS_Get_SoundVolume as function (byval hSound as integer, _
                                       byval pVolume as single ptr) as boolean

type tFBS_Set_SoundPan as function (byval hSound as integer, _
                                    byval Pan    as single) as boolean
type tFBS_Get_SoundPan as function (byval hSound as integer        , _
                                    byval pPan   as single ptr) as boolean

type tFBS_Set_SoundLoops as function (byval hSound as integer , _
                                      byval nLoops as integer) as boolean
type tFBS_Get_SoundLoops as function (byval hSound  as integer , _
                                      byval pnLoops as integer ptr) as boolean
' togle hearing
type tFBS_Set_SoundMuted as function (byval hSound as integer , _
                                      byval muted  as boolean) as boolean
type tFBS_Get_SoundMuted as function (byval hSound as integer , _
                                      byval pMuted as boolean ptr ) as boolean
' togle playing
type tFBS_Set_SoundPaused as function (byval hSound as integer , _
                                       byval Paused as boolean) as boolean
type tFBS_Get_SoundPaused as function (byval hSound as integer        , _
                                       byval pPaused as boolean ptr ) as boolean

type tFBS_Get_WavePointers as function (byval hWave       as integer            , _
                                        byval ppWaveStart as short ptr ptr=NULL , _
                                        byval ppWaveEnd   as short ptr ptr=NULL , _
                                        byval pnChannels  as integer ptr  =NULL ) as boolean

type tFBS_Get_SoundPointers as function (byval hSound  as integer       , _
                                         byval ppStart as short ptr ptr=NULL , _
                                         byval ppPlay  as short ptr ptr=NULL , _
                                         byval ppEnd   as short ptr ptr=NULL) as boolean

type tFBS_Set_SoundPointers as function (byval hSound    as integer , _
                                         byval pNewStart as short ptr=NULL, _
                                         byval pNewPlay  as short ptr=NULL, _
                                         byval pNewEnd   as short ptr=NULL) as boolean

' position 0.0-1.0
type tFBS_Get_SoundPosition as function (byval hSound as integer, _
                                         byval pPosition as single ptr) as boolean

#ifndef NO_CALLBACK
type tFBS_Set_SoundCallback as function (byval hSound as integer      , _
                                         byval cb     as tFBS_BUFFERCALLBACK)  as boolean
type tFBS_Enable_SoundCallback as function (byval hSound as integer) as boolean
type tFBS_Disable_SoundCallback as function (byval hSound as integer) as boolean
#endif

#ifndef NO_MP3
type tFBS_Create_MP3Stream as function (byref Filename as string) as boolean
type tFBS_Play_MP3Stream as function (byval Volume as single=1.0, _
                                      byval Pan    as single=0.0) as boolean
type tFBS_End_MP3Stream as function () as boolean
type tFBS_Set_MP3StreamVolume as function (byval Volume as single) as boolean
type tFBS_Get_MP3StreamVolume as function (byval pVolume as single ptr   ) as boolean
type tFBS_Set_MP3StreamPan as function (byval Pan as single) as boolean
type tFBS_Get_MP3StreamPan as function (byval pPan as single ptr) as boolean

type tFBS_Get_MP3StreamBuffer as function (byval ppBuffer   as short ptr ptr , _
                                           byval pChannels as integer ptr   , _
                                           byval pnSamples as integer ptr) as boolean
 #ifndef NO_CALLBACK
type tFBS_Set_MP3StreamCallback as function (byval cb as tFBS_BUFFERCALLBACK)  as boolean
type tFBS_Enable_MP3StreamCallback as function () as boolean
type tFBS_Disable_MP3StreamCallback as function () as boolean
 #endif
#endif ' MP3

#ifndef NO_SID
type tFBS_Create_SIDStream as function (byref Filename as string, _
                                        byval PlayTune as integer=0, _
                                        byval pTunes   as integer ptr=0) as boolean
type tFBS_Play_SIDStream as function (byval Volume as single=1.0, _
                                      byval Pan    as single=0.0) as boolean
type tFBS_End_SIDStream as function () as boolean
type tFBS_Set_SIDStreamVolume as function (byval Volume as single) as boolean
type tFBS_Get_SIDStreamVolume as function (byval pVolume as single ptr   ) as boolean
type tFBS_Set_SIDStreamPan as function (byval Pan as single) as boolean
type tFBS_Get_SIDStreamPan as function (byval pPan as single ptr) as boolean

type tFBS_Get_SIDStreamBuffer as function (byval ppBuffer  as short ptr ptr , _
                                           byval pChannels as integer ptr   , _
                                           byval pnSamples as integer ptr) as boolean
type tFBS_Get_SIDAuthor as function () as string
type tFBS_Get_SIDInfo   as function () as string
type tFBS_Get_SIDTitle  as function () as string                                           
 #ifndef NO_CALLBACK
type tFBS_Set_SIDStreamCallback as function (byval cb as tFBS_BUFFERCALLBACK)  as boolean
type tFBS_Enable_SIDStreamCallback as function () as boolean
type tFBS_Disable_SIDStreamCallback as function () as boolean
 #endif ' NO_CALLBACK
#endif ' SID

#define fbs_declare(_NAME_) dim shared as t##_NAME_ _NAME_
fbs_declare(FBS_Init)
fbs_declare(FBS_Start)
fbs_declare(FBS_Stop)
fbs_declare(FBS_Exit)

fbs_declare(FBS_Get_PlugPath)
fbs_declare(FBS_Set_PlugPath)
fbs_declare(FBS_Get_NumOfPlugouts)
fbs_declare(FBS_Get_PlugName)
fbs_declare(FBS_Get_PlugDevice)
fbs_declare(FBS_Get_PlugError)
fbs_declare(FBS_Get_PlugRate)
fbs_declare(FBS_Get_PlugBits)
fbs_declare(FBS_Get_PlugChannels)
fbs_declare(FBS_Get_PlugBuffers)
fbs_declare(FBS_Get_PlugBuffersize)
fbs_declare(FBS_Get_PlugFrames)
fbs_declare(FBS_Get_PlugFramesize)
fbs_declare(FBS_Get_PlugRunning)

fbs_declare(FBS_Get_PlayingSounds)
fbs_declare(FBS_Get_PlayingStreams)
fbs_declare(FBS_Get_PlayedBytes)
fbs_declare(FBS_Get_PlayedSamples)
fbs_declare(FBS_Get_PlayTime)

fbs_declare(FBS_Get_MasterVolume)
fbs_declare(FBS_Set_MasterVolume)

fbs_declare(FBS_Rad2Deg)
fbs_declare(FBS_Deg2Rad)
fbs_declare(FBS_Volume_2_DB)
fbs_declare(FBS_DB_2_Volume)
fbs_declare(FBS_Pow)

#ifndef NO_DSP
fbs_declare(FBS_Set_MasterFilter)
fbs_declare(FBS_Enable_MasterFilter)
fbs_declare(FBS_Disable_MasterFilter)
 #ifndef NO_PITCHSHIFT
fbs_declare(FBS_PitchShift)
 #endif
#endif

fbs_declare(FBS_Get_MaxChannels)
fbs_declare(FBS_Set_MaxChannels)

#ifndef NO_CALLBACK
fbs_declare(FBS_Set_LoadCallback)
fbs_declare(FBS_Enable_LoadCallback)
fbs_declare(FBS_Disable_LoadCallback)
fbs_declare(FBS_Set_MasterCallback)
fbs_declare(FBS_Enable_MasterCallback)
fbs_declare(FBS_Disable_MasterCallback)
#endif

fbs_declare(FBS_Load_WAVFile)

#ifndef NO_MP3
fbs_declare(FBS_Load_MP3File)
#endif

#ifndef NO_MOD
fbs_declare(FBS_Load_MODFile)
#endif

#ifndef NO_OOG
fbs_declare(FBS_Load_OGGFile)
#endif

fbs_declare(FBS_Create_Wave)
fbs_declare(FBS_Destroy_Wave)
fbs_declare(FBS_Play_Wave)
fbs_declare(FBS_Get_WaveLength)
fbs_declare(FBS_Get_WavePointers)

fbs_declare(FBS_Create_Sound)
fbs_declare(FBS_Destroy_Sound)
fbs_declare(FBS_Play_Sound)
fbs_declare(FBS_Get_SoundLength)
fbs_declare(FBS_Set_SoundSpeed)
fbs_declare(FBS_Get_SoundSpeed)
fbs_declare(FBS_Set_SoundVolume)
fbs_declare(FBS_Get_SoundVolume)
fbs_declare(FBS_Set_SoundPan)
fbs_declare(FBS_Get_SoundPan)
fbs_declare(FBS_Set_SoundLoops)
fbs_declare(FBS_Get_SoundLoops)
fbs_declare(FBS_Set_SoundMuted)
fbs_declare(FBS_Get_SoundMuted)
fbs_declare(FBS_Set_SoundPaused)
fbs_declare(FBS_Get_SoundPaused)
fbs_declare(FBS_Get_SoundPointers)
fbs_declare(FBS_Set_SoundPointers)
fbs_declare(FBS_Get_SoundPosition)

#ifndef NO_CALLBACK
fbs_declare(FBS_Set_SoundCallback)
fbs_declare(FBS_Enable_SoundCallback)
fbs_declare(FBS_Disable_SoundCallback)
#endif

#ifndef NO_MP3
fbs_declare(FBS_Create_MP3Stream)
fbs_declare(FBS_Play_MP3Stream)
fbs_declare(FBS_End_MP3Stream)
fbs_declare(FBS_Set_MP3StreamVolume)
fbs_declare(FBS_Get_MP3StreamVolume)
fbs_declare(FBS_Set_MP3StreamPan)
fbs_declare(FBS_Get_MP3StreamPan)
fbs_declare(FBS_Get_MP3StreamBuffer)
 #ifndef NO_CALLBACK
fbs_declare(FBS_Set_MP3StreamCallback)
fbs_declare(FBS_Enable_MP3StreamCallback)
fbs_declare(FBS_Disable_MP3StreamCallback)
 #endif
#endif ' MP3

#ifndef NO_SID
fbs_declare(FBS_Create_SIDStream)
fbs_declare(FBS_Play_SIDStream)
fbs_declare(FBS_End_SIDStream)
fbs_declare(FBS_Set_SIDStreamVolume)
fbs_declare(FBS_Get_SIDStreamVolume)
fbs_declare(FBS_Set_SIDStreamPan)
fbs_declare(FBS_Get_SIDStreamPan)
fbs_declare(FBS_Get_SIDStreamBuffer)
fbs_declare(FBS_Get_SIDAuthor)
fbs_declare(FBS_Get_SIDInfo)
fbs_declare(FBS_Get_SIDTitle)
 #ifndef NO_CALLBACK
fbs_declare(FBS_Set_SIDStreamCallback)
fbs_declare(FBS_Enable_SIDStreamCallback)
fbs_declare(FBS_Disable_SIDStreamCallback)
 #endif
#endif ' SID

#undef fbs_declare

dim shared as any ptr hFBS

function FBSLoaded as boolean
  return (hFBS<>0)
end function

Sub RuntimeLoad Constructor
  dprint("fbsound-1.2 RuntimeLoad Constructor")
  if hFBS<>0 then exit sub
#ifndef __FB_64BIT__
  dprint("DyLibLoad( 'fbsound-32' )")
  hFBS = DyLibLoad( "fbsound-32" )
  if hFBS=0 then
    dprint("error: lib fbsound-32 not loaded !")
    exit sub
  end if  
#else
  dprint("DyLibLoad( 'fbsound-64' )") 
  hFBS = DyLibLoad( "fbsound-64" )
  if hFBS=0 then
    dprint("error: lib fbsound-64 not loaded !")
    exit sub
  end if  
#endif

  #define fbs_load(_NAME_) _NAME_ = DyLibSymbol(hFBS,ucase(#_NAME_)) : if _NAME_ = 0 then print "error: can't resolve " & #_NAME_  : beep : sleep : end 1 
  fbs_load(FBS_Init)
  fbs_load(FBS_Start)
  fbs_load(FBS_Stop)
  fbs_load(FBS_Exit)
  
  fbs_load(FBS_Get_PlugPath)
  fbs_load(FBS_Set_PlugPath)
  
  fbs_load(FBS_Get_NumOfPlugouts)
  fbs_load(FBS_Get_PlugName)
  fbs_load(FBS_Get_PlugDevice)
  fbs_load(FBS_Get_PlugError)
  
  fbs_load(FBS_Get_PlugRate)
  fbs_load(FBS_Get_PlugBits)
  fbs_load(FBS_Get_PlugChannels)
  fbs_load(FBS_Get_PlugBuffers)
  fbs_load(FBS_Get_PlugBuffersize)
  fbs_load(FBS_Get_PlugFrames)
  fbs_load(FBS_Get_PlugFramesize)
  fbs_load(FBS_Get_PlugRunning)
  
  fbs_load(FBS_Get_MaxChannels)
  fbs_load(FBS_Set_MaxChannels)
    
  fbs_load(FBS_Get_PlayingSounds)
  fbs_load(FBS_Get_PlayingStreams)
  fbs_load(FBS_Get_PlayedBytes)
  fbs_load(FBS_Get_PlayedSamples)
  fbs_load(FBS_Get_PlayTime)
  
  fbs_load(FBS_Get_MasterVolume)
  fbs_load(FBS_Set_MasterVolume)
  
  fbs_load(FBS_Rad2Deg)
  fbs_load(FBS_Deg2Rad)
  fbs_load(FBS_Volume_2_DB)
  fbs_load(FBS_DB_2_Volume)
  fbs_load(FBS_Pow)
  
#ifndef NO_DSP  
  fbs_load(FBS_Set_MasterFilter)
  fbs_load(FBS_Enable_MasterFilter)
  fbs_load(FBS_Disable_MasterFilter)
 #ifndef NO_PITCHSHIFT
  fbs_load(FBS_PitchShift)
 #endif  
#endif
  
#ifndef NO_CALLBACK  
  fbs_load(FBS_Set_LoadCallback)
  fbs_load(FBS_Enable_LoadCallback)
  fbs_load(FBS_Disable_LoadCallback)
  fbs_load(FBS_Set_MasterCallback)
  fbs_load(FBS_Enable_MasterCallback)
  fbs_load(FBS_Disable_MasterCallback)
#endif  
  fbs_load(FBS_Load_WAVFile)

#ifndef NO_MP3  
  fbs_load(FBS_Load_MP3File)
#endif

#ifndef NO_MOD
  fbs_load(FBS_Load_MODFile)
#endif  

#ifndef NO_OGG
  fbs_load(FBS_Load_OGGFile)
#endif  
  
  fbs_load(FBS_Create_Wave)
  fbs_load(FBS_Destroy_Wave)
  fbs_load(FBS_Play_Wave)
  fbs_load(FBS_Get_WaveLength)
  fbs_load(FBS_Get_WavePointers)
    
  fbs_load(FBS_Create_Sound)
  fbs_load(FBS_Destroy_Sound)
  fbs_load(FBS_Play_Sound)
  fbs_load(FBS_Get_SoundLength)
  fbs_load(FBS_Set_SoundSpeed)
  fbs_load(FBS_Get_SoundSpeed)
  fbs_load(FBS_Set_SoundVolume)
  fbs_load(FBS_Get_SoundVolume)
  fbs_load(FBS_Set_SoundPan)
  fbs_load(FBS_Get_SoundPan)
  fbs_load(FBS_Set_SoundLoops)
  fbs_load(FBS_Get_SoundLoops)
  fbs_load(FBS_Set_SoundMuted)
  fbs_load(FBS_Get_SoundMuted)
  fbs_load(FBS_Set_SoundPaused)
  fbs_load(FBS_Get_SoundPaused)
  fbs_load(FBS_Get_SoundPointers)
  fbs_load(FBS_Set_SoundPointers)
  fbs_load(FBS_Get_SoundPosition)

#ifndef NO_CALLBACK  
  fbs_load(FBS_Set_SoundCallback)
  fbs_load(FBS_Enable_SoundCallback)
  fbs_load(FBS_Disable_SoundCallback)
#endif  
  
#ifndef NO_MP3  
  fbs_load(FBS_Create_MP3Stream)
  fbs_load(FBS_Play_MP3Stream)
  fbs_load(FBS_End_MP3Stream)
  fbs_load(FBS_Set_MP3StreamVolume)
  fbs_load(FBS_Get_MP3StreamVolume)
  fbs_load(FBS_Set_MP3StreamPan)
  fbs_load(FBS_Get_MP3StreamPan)
  fbs_load(FBS_Get_MP3StreamBuffer)
 #ifndef NO_CALLBACK  
  fbs_load(FBS_Set_MP3StreamCallback)
  fbs_load(FBS_Enable_MP3StreamCallback)
  fbs_load(FBS_Disable_MP3StreamCallback)
 #endif  
#endif ' MP3

#ifndef NO_SID
  fbs_load(FBS_Create_SIDStream)
  fbs_load(FBS_Play_SIDStream)
  fbs_load(FBS_End_SIDStream)
  fbs_load(FBS_Set_SIDStreamVolume)
  fbs_load(FBS_Get_SIDStreamVolume)
  fbs_load(FBS_Set_SIDStreamPan)
  fbs_load(FBS_Get_SIDStreamPan)
  fbs_load(FBS_Get_SIDStreamBuffer)
  fbs_load(FBS_Get_SIDAuthor)
  fbs_load(FBS_Get_SIDInfo)
  fbs_load(FBS_Get_SIDTitle)
 #ifndef NO_CALLBACK 
  fbs_load(FBS_Set_SIDStreamCallback)
  fbs_load(FBS_Enable_SIDStreamCallback)
  fbs_load(FBS_Disable_SIDStreamCallback)
 #endif 
#endif ' SID
  
#undef fbs_load
  
End Sub

sub RuntimeUnload Destructor
  dprint("fbsound-1.2 RuntimeUnload Destructor")
  if hFBS=0 then exit sub

  if FBS_Get_PlugRunning() then
    dprint("fbsound-1.2 RuntimeUnload Destructor call FBS_Stop()")
    FBS_Stop()
  end if  
  dprint("fbsound-1.2 RuntimeUnload Destructor call FBS_Exit()")
  FBS_Exit()

  dprint("fbsound-1.2 RuntimeUnload Destructor call DyLibFree()")
  'DyLibFree(hFBS)
  hFBS=0
end sub


#endif ' __FBSOUND_DYNAMIC_BI__

