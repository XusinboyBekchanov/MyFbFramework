#ifndef __FBSOUND_BI__
#define __FBSOUND_BI__

'  ##############
' # fbsound.bi #
'##############
' Copyright 2005 - 2020 by D.J.Peters (Joshy)
' d.j.peters@web.de


#ifdef __FB_WIN32__
 #ifndef __FB_64BIT__
  #libpath "../lib/win32/"
 #else
  #libpath "../lib/win64/"
 #endif 
#else
 #ifdef  __FB_LINUX__
   #ifndef __FB_64BIT__
    #libpath "../lib/lin32/"
   #else
    #libpath "../lib/lin64/"
   #endif
 #else
   #error 666: Build target must be Windows or Linux !
 #endif
#endif

#include once "fbstypes.bi"

#include once "fbscpu.bi"

#include once "fbsdsp.bi"

#ifndef NO_MOD
 #include once "dumb.bi"
#endif

#ifndef NO_MP3
 #include once "mad.bi"
#endif

#ifndef NO_SID
 #include once "csid.bi"
#endif

#ifndef NO_OGG
 #include once "vorbis.bi"
#endif


declare function FBS_Init(byval nRate        as integer=44100, _
                          byval nChannels    as integer=    2, _
                          byval nBuffers     as integer=    3, _
                          byval nFrames      as integer= 2048, _
                          byval nPlugIndex   as integer=    0, _
                          byval nDeviceIndex as integer=    0) as boolean

' now fbs will start,stop and exit by it self
declare function FBS_Start() as boolean
declare function FBS_Stop() as boolean
declare function FBS_Exit() as boolean

declare function FBS_Get_PlugPath() as string
declare sub      FBS_Set_PlugPath(byval NewPath as string)

declare function FBS_Get_NumOfPlugouts() as integer
declare function FBS_Get_PlugName() as string
declare function FBS_Get_PlugDevice() as string
declare function FBS_Get_PlugError() as string
declare function FBS_Get_PlugRate() as integer       ' 6000Hz-96000Hz
declare function FBS_Get_PlugBits() as integer       ' signed 16 bit
declare function FBS_Get_PlugChannels() as integer   ' 1=mono 2=stereo
declare function FBS_Get_PlugBuffers() as integer    ' 2 to N N<=64
declare function FBS_Get_PlugBuffersize() as integer ' same as FrameSize*Frames
declare function FBS_Get_PlugFrames() as integer     ' same as BufferSize\FrameSize
declare function FBS_Get_PlugFramesize() as integer  ' same as BufferSize\Frames
declare function FBS_Get_PlugRunning() as boolean

declare function FBS_Get_PlayingSounds() as integer
declare function FBS_Get_PlayingStreams() as integer

declare function FBS_Get_PlayedBytes() as integer
declare function FBS_Get_PlayedSamples() as integer
declare function FBS_Get_PlayTime() as double

declare function FBS_Get_MasterVolume(byval lpVolume as single ptr) as boolean
declare function FBS_Set_MasterVolume(byval Volume   as single ) as boolean

#ifndef NO_DSP
declare function FBS_Set_MasterFilter(byval nFilter as integer, _
                                      byval Center  as single, _
                                      byval dB      as single, _
                                      byval Octave  as single = 1.0, _
                                      byval OnOff   as boolean = True) as boolean

declare function FBS_Enable_MasterFilter(byval nFilter as integer) as boolean
declare function FBS_Disable_MasterFilter(byval nFilter as integer) as boolean
 #ifndef NOPITCHSHIFT
declare sub      FBS_PitchShift(byval d as short ptr, _
                                byval s as short ptr, _
                                byval v as single   , _
                                byval n as integer  )
 #endif 
#endif

declare function FBS_Get_MaxChannels(byval pnChannels as integer ptr) as boolean
declare function FBS_Set_MaxChannels(byval nChannels  as integer ) as boolean

#ifndef NO_CALLBACK
declare function FBS_Set_LoadCallback(byval cb as FBS_LOADCALLBACK) as boolean
declare function FBS_Enable_LoadCallback() as boolean
declare function FBS_Disable_LoadCallback() as boolean

declare function FBS_Set_MasterCallback(byval pCallback as FBS_BUFFERCALLBACK) as boolean
declare function FBS_Enable_MasterCallback() as boolean
declare function FBS_Disable_MasterCallback() as boolean
#endif

' create or load wave objects in the pool of Waves()

' create hWave from *.wav file
declare function FBS_Load_WAVFile(byref Filename as string , _
                                  byval phWave   as integer ptr) as boolean
#ifndef NO_MP3
' create hWave from *.mp3,*.mp2,*.mp file
declare function FBS_Load_MP3File(byref Filename as string      , _
                                  byval phWave  as integer ptr , _
                                  byref _usertmpfile_  as string ="") as boolean
#endif

#ifndef NO_MOD
' create hWave from *.it *.xm *.sm3 or *.mod file
declare function FBS_Load_MODFile(byref Filename as string       , _
                                  byval phWave  as integer ptr) as boolean
#endif

#ifndef NO_OGG
' create hWave from *.ogg file
declare function FBS_Load_OGGFile(byref Filename as string      , _
                                  byval lphWave  as integer ptr , _
                                  byref _usertmpfile_  as string ="") as boolean
#endif
' create hWave with nSamples in memory
declare function FBS_Create_Wave(byval nSamples as integer     , _
                                 byval phWave   as integer ptr , _
                                 byval ppWave   as any ptr ptr) as boolean
' playtime in MS
declare function FBS_Get_WaveLength(byval hWave as integer, _
                                    byval pMS   as integer ptr) as boolean



' play any wave as sound from the pool of Waves()
' optional number of loops, playbackspeed,volume,pan
' if you need to change any param while playing use an hSound object
declare function FBS_Play_Wave(byval hWave    as integer        , _
                               byval nLoops   as integer  = 1   , _
                               byval Speed    as single  = 1.0 , _
                               byval Volume   as single  = 1.0 , _
                               byval Pan      as single  = 0.0 , _
                               byval phSound  as integer ptr = NULL) as boolean

'create an playable sound object "hSound" from any "hWave" object
declare function FBS_Create_Sound(byval hWave   as integer        , _
                                  byval phSound as integer ptr = NULL) as boolean


' [optinal] destroy/free created hSound's and hWave's
declare function FBS_Destroy_Wave(byval phWave  as integer ptr) as boolean
declare function FBS_Destroy_Sound(byval phSound as integer ptr) as boolean

' play an hSound object
declare function FBS_Play_Sound(byval hSound as integer , _
                                byval nLoops as integer = 1) as boolean
' play time in MS
declare function FBS_Get_SoundLength(byval hSound as integer , _
                                     byval lpMS   as integer ptr) as boolean


' get and set any params from playing hSound
declare function FBS_Set_SoundSpeed(byval hSound as integer , _
                                    byval Speed  as single) as boolean
declare function FBS_Get_SoundSpeed(byval hSound as integer , _
                                    byval pSpeed as single ptr) as boolean

declare function FBS_Set_SoundVolume(byval hSound as integer , _
                                     byval Volume as single) as boolean
declare function FBS_Get_SoundVolume(byval hSound as integer, _
                                     byval pVolume as single ptr) as boolean

declare function FBS_Set_SoundPan(byval hSound as integer, _
                                  byval Pan    as single) as boolean
declare function FBS_Get_SoundPan(byval hSound as integer        , _
                                  byval pPan   as single ptr     ) as boolean

declare function FBS_Set_SoundLoops(byval hSound as integer , _
                                    byval nLoops as integer) as boolean
declare function FBS_Get_SoundLoops(byval hSound  as integer , _
                                    byval pnLoops as integer ptr) as boolean
' togle hearing
declare function FBS_Set_SoundMuted(byval hSound as integer , _
                                    byval muted  as boolean) as boolean
declare function FBS_Get_SoundMuted(byval hSound as integer , _
                                    byval pMuted as boolean ptr ) as boolean
' togle playing
declare function FBS_Set_SoundPaused(byval hSound as integer , _
                                     byval Paused as boolean) as boolean
declare function FBS_Get_SoundPaused(byval hSound as integer        , _
                                     byval pPaused as boolean ptr ) as boolean

declare function FBS_Get_WavePointers(byval hWave       as integer            , _
                                      byval ppWaveStart as short ptr ptr=NULL , _
                                      byval ppWaveEnd   as short ptr ptr=NULL , _
                                      byval pnChannels  as integer ptr  =NULL ) as boolean

declare function FBS_Get_SoundPointers(byval hSound  as integer       , _
                                       byval ppStart as short ptr ptr=NULL , _
                                       byval ppPlay  as short ptr ptr=NULL , _
                                       byval ppEnd   as short ptr ptr=NULL) as boolean

declare function FBS_Set_SoundPointers(byval hSound    as integer , _
                                       byval pNewStart as short ptr=NULL, _
                                       byval pNewPlay  as short ptr=NULL, _
                                       byval pNewEnd   as short ptr=NULL) as boolean

' position 0.0-1.0
declare function FBS_Get_SoundPosition(byval hSound as integer, _
                                       byval pPosition as single ptr) as boolean

#ifndef NO_CALLBACK
declare function FBS_Set_SoundCallback(byval hSound as integer      , _
                                       byval cb     as FBS_BUFFERCALLBACK)  as boolean
declare function FBS_Enable_SoundCallback(byval hSound as integer) as boolean
declare function FBS_Disable_SoundCallback(byval hSound as integer) as boolean
#endif

#if defined(NO_MP3) and defined(NO_SID)
 ' no streams
#else

enum FBS_STREAM_TYPES
 FBS_NOSTREAM = 0
 #ifndef NO_MP3
  FBS_MP3_STREAM
 #endif
 #ifndef NO_SID
  FBS_SID_SREAM
 #endif
end enum



 #ifndef NO_MP3
declare function FBS_Create_MP3Stream(byref Filename as string) as boolean
declare function FBS_Play_MP3Stream(byval Volume as single=1.0, _
                                    byval Pan    as single=0.0) as boolean
declare function FBS_End_MP3Stream() as boolean
declare function FBS_Set_MP3StreamVolume(byval Volume as single) as boolean
declare function FBS_Get_MP3StreamVolume(byval pVolume as single ptr   ) as boolean
declare function FBS_Set_MP3StreamPan(byval Pan as single) as boolean
declare function FBS_Get_MP3StreamPan(byval pPan as single ptr) as boolean

declare function FBS_Get_MP3StreamBuffer(byval ppBuffer   as short ptr ptr , _
                                         byval pChannels as integer ptr   , _
                                         byval pnSamples as integer ptr) as boolean
  #ifndef NO_CALLBACK
declare function FBS_Set_MP3StreamCallback(byval cb as FBS_BUFFERCALLBACK)  as boolean
declare function FBS_Enable_MP3StreamCallback() as boolean
declare function FBS_Disable_MP3StreamCallback() as boolean
  #endif
 #endif ' NO_MP3

 #ifndef NO_SID
declare function FBS_Create_SIDStream(byref Filename as string, _
                                      byval PlayTune as integer=0, _
                                      byval pTunes as integer ptr=0) as boolean
declare function FBS_Play_SIDStream(byval Volume as single=1.0, _
                                    byval Pan    as single=0.0) as boolean
declare function FBS_End_SIDStream() as boolean
declare function FBS_Set_SIDStreamVolume(byval Volume     as single) as boolean
declare function FBS_Get_SIDStreamVolume(byval pVolume    as single ptr   ) as boolean
declare function FBS_Set_SIDStreamPan(byval Pan as single) as boolean
declare function FBS_Get_SIDStreamPan(byval pPan as single ptr) as boolean

declare function FBS_Get_SIDStreamBuffer(byval ppBuffer  as short ptr ptr , _
                                         byval pChannels as integer ptr   , _
                                         byval pnSamples as integer ptr) as boolean
declare function FBS_Get_SIDAuthor() as string
declare function FBS_Get_SIDInfo() as string
declare function FBS_Get_SIDTitle() as string

 #ifndef NO_CALLBACK
declare function FBS_Set_SIDStreamCallback(byval cb as FBS_BUFFERCALLBACK)  as boolean
declare function FBS_Enable_SIDStreamCallback() as boolean
declare function FBS_Disable_SIDStreamCallback() as boolean
  #endif
 #endif ' NO_SID

#endif ' NO_MP3 or NO_SID

#endif ' __FBSOUND_BI__
