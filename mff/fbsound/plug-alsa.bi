#ifndef __FBS_PLUGOUT_ALSA__
#define __FBS_PLUGOUT_ALSA__

'  ################
' # plug-alsa.bi #
'################
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_PLUG_ALSA 

#inclib "asound"

const as long _EIO     =   -5 ' I/O error
const as long _EAGAIN   = -11 ' Try again
const as long _EPIPE    = -32 ' Broken pipe
const as long _EBADFD   = -77 ' File descriptor in bad state
const as long _ESTRPIPE = -86 ' Streams pipe error

const as long BLOCK    = 0
const as long NONBLOCK = 1
const as long ASYNC    = 2

const as long SND_PCM_STREAM_PLAYBACK = 0
const as long SND_PCM_STREAM_CAPTURE  = 1

type SND_PCM_FORMATS as long
  ' Signed 8 bit
const as SND_PCM_FORMATS SND_PCM_FORMAT_S8 = 0
  ' Unsigned 8 bit
const as SND_PCM_FORMATS  SND_PCM_FORMAT_U8 = 1
  ' Signed 16 bit Little Endian 
const as SND_PCM_FORMATS SND_PCM_FORMAT_S16_LE = 2


const as long SND_PCM_ACCESS_RW_INTERLEAVED = 3

type snd_pcm_t           as any
type snd_pcm_hw_params_t as any
type snd_pcm_sw_params_t as any

extern "c"

' PCM
declare function snd_strerror ( _
byval ecode as long) as const zstring ptr

declare function snd_pcm_open ( _
byval pcm      as snd_pcm_t ptr ptr , _
byval device   as const zstring ptr , _
byval direc    as long=SND_PCM_STREAM_PLAYBACK, _
byval mode     as long) as long     ' non blocking async

declare function snd_pcm_hw_free ( _
byval pcm as snd_pcm_t ptr) as long

declare function snd_pcm_close ( _
byval pcm as snd_pcm_t ptr) as long

declare function snd_pcm_start ( _
byval pcm as snd_pcm_t ptr) as long

declare function snd_pcm_drain ( _
byval pcm as snd_pcm_t ptr) as long

declare function snd_pcm_nonblock ( _
byval pcm as snd_pcm_t ptr, _
byval nonblock as long) as long

declare function snd_pcm_prepare (byval pcm  as snd_pcm_t ptr) as long

declare function snd_pcm_writei ( _
byval pcm    as snd_pcm_t ptr, _
byval buffer as const any ptr  , _
byval size   as long) as long

declare function snd_pcm_avail_update (byval pcm as snd_pcm_t ptr) as long

declare function snd_pcm_wait ( _
byval pcm  as snd_pcm_t ptr, _
byval timeoutms as long) as long

declare function snd_pcm_resume ( _
byval pcm as snd_pcm_t ptr) as long

'hardware
declare function snd_pcm_hw_params_malloc ( _
byval hw as snd_pcm_hw_params_t ptr ptr) as long

declare function snd_pcm_hw_params_any ( _
byval pcm as snd_pcm_t ptr, _
byval hw  as snd_pcm_hw_params_t ptr) as long

declare function snd_pcm_hw_params_set_access ( _
byval pcm  as snd_pcm_t ptr           , _
byval hw   as snd_pcm_hw_params_t ptr , _
byval mode as long) as long

declare function snd_pcm_hw_params_set_format (byval pcm as snd_pcm_t ptr          , _
                                               byval hw  as snd_pcm_hw_params_t ptr, _
                                               byval fmt as SND_PCM_FORMATS=SND_PCM_FORMAT_S16_LE) as long

declare function snd_pcm_hw_params_set_channels ( _
byval pcm      as snd_pcm_t ptr         , _
byval hw       as snd_pcm_hw_params_t ptr, _
byval Channels as ulong) as long

declare function snd_pcm_hw_params_get_channels ( _
byval hw        as const snd_pcm_hw_params_t ptr, _
byval pChannels as long ptr) as long

declare function snd_pcm_hw_params_set_rate_near ( _
byval pcm   as snd_pcm_t ptr, _
byval hw    as snd_pcm_hw_params_t ptr, _
byval pRate as ulong ptr    , _
byval pDir  as long ptr) as long

declare function snd_pcm_hw_params_get_periods ( _
byval hw     as const snd_pcm_hw_params_t ptr, _
byval pValue as ulong ptr    , _
byval pDir   as long ptr) as long

declare function snd_pcm_hw_params_set_periods ( _
byval pcm    as snd_pcm_t ptr          , _
byval hw     as snd_pcm_hw_params_t ptr, _
byval Value  as ulong                  , _
byval Dir    as long) as long

declare function snd_pcm_hw_params_set_periods_near ( _
byval pcm    as snd_pcm_t ptr          , _
byval hw     as snd_pcm_hw_params_t ptr, _
byval pValue as ulong ptr              , _
byval pDir   as long ptr) as long

declare function snd_pcm_hw_params_set_period_size ( _
byval pcm      as snd_pcm_t ptr          , _
byval params   as snd_pcm_hw_params_t ptr, _
byval nFrames  as ulong                  , _
byval Dir      as long) as long

declare function snd_pcm_hw_params_get_period_size ( _
byval params   as snd_pcm_hw_params_t ptr, _
byval pFrames  as ulong ptr        , _
byval pDir     as long ptr) as long

declare function snd_pcm_hw_params_set_period_size_near ( _
byval pcm      as snd_pcm_t ptr          , _
byval hw       as snd_pcm_hw_params_t ptr, _
byval pValue   as ulong ptr              , _
byval pDir     as long ptr) as long

declare function snd_pcm_hw_params_set_buffer_size ( _
byval pcm      as snd_pcm_t ptr          , _
byval hw       as snd_pcm_hw_params_t ptr, _
byval Frames   as ulong) as long

declare function snd_pcm_hw_params_set_buffer_size_near ( _
byval pcm      as snd_pcm_t ptr          , _
byval hw       as snd_pcm_hw_params_t ptr, _
byval pFrames  as ulong ptr) as long

declare function snd_pcm_hw_params_get_buffer_size ( _
byval hw       as snd_pcm_hw_params_t ptr, _
byval pFrames  as ulong ptr) as long

declare function snd_pcm_hw_params ( _
byval pcm      as snd_pcm_t ptr, _
byval hw       as snd_pcm_hw_params_t ptr) as long

declare sub      snd_pcm_hw_params_free ( _
byval hw       as snd_pcm_hw_params_t ptr)

' software
declare function snd_pcm_sw_params_malloc ( _
byval params   as snd_pcm_sw_params_t ptr ptr) as long

declare function snd_pcm_sw_params_current ( _
byval pcm      as snd_pcm_t ptr, _
byval params   as snd_pcm_sw_params_t ptr) as long

declare function snd_pcm_sw_params_set_avail_min ( _
byval pcm      as snd_pcm_t ptr         , _
byval params   as snd_pcm_sw_params_t ptr, _
byval uFrames  as ulong) as long

declare function snd_pcm_sw_params_set_start_threshold ( _
byval pcm      as snd_pcm_t ptr          ,  _
byval params   as snd_pcm_sw_params_t ptr, _
byval uFrames  as ulong) as long

declare function snd_pcm_sw_params ( _
byval pcm      as snd_pcm_t ptr, _
byval params   as snd_pcm_sw_params_t ptr) as long

declare sub      snd_pcm_sw_params_free ( _
byval params   as snd_pcm_sw_params_t ptr)

end extern

#endif ' NO_PLUG_ALSA 

#endif '__FBS_PLUGOUT_ALSA__
