#ifndef __FBS_TYPES_BI__
#define __FBS_TYPES_BI__

'  ###############
' # fbstypes.bi #
'###############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

'' if fbs-config.bi wasn't included yet, be sure to 
'' it now before anything else
#include once "fbs-config.bi"

#ifndef NULL
 #define NULL cptr(any ptr,0)
#endif

const _WAVE_FORMAT_PCM as short = 1
const _PCM_WAVEFORMAT_SIZE as integer = 16

type VCCs as ulong
const as VCCs _RIFF = &H46464952 ' "RIFF"
const as VCCs _WAVE = &H45564157 ' "WAVE"
const as VCCs _fmt  = &H20746D66 ' "fmt "
const as VCCs _data = &H61746164 ' "data"


type _PCM_FILE_HDR field = 1
  ChunkRIFF         as VCCs     ' 4       Chunktype   'RIFF'
  ChunkRIFFSize     as long     ' 8       ChunkSize
  ChunkID           as VCCs     '12       ChunkID     'WAVE'
  Chunkfmt          as VCCs     '16       Chunktype   'fmt '
  ChunkfmtSize      as long     '20       ChunkSize   (16)

    wFormatTag      as short    '22  2 (1)
    nChannels       as short    '24  4
    nRate           as long     '28  8
    nBytesPerSec    as long     '32 12
    Framesize       as short    '34 14
    nBits           as short    '36 16

  Chunkdata         as VCCs     '40       Chunktype   'data'
  ChunkdataSize     as long     '44       ChunkSize
end type
const _PCM_FILE_HDR_SIZE = 44
const _PCM_FMT_SIZE      = 16

type FBS_FORMAT_t
  as integer nRate
  as integer nBits
  as integer nChannels
  as boolean signed
end type
type FBS_FORMAT as FBS_FORMAT_t

type FBS_SAMPLE    as short
type MONO_SAMPLE   as FBS_SAMPLE
type STEREO_SAMPLE field=1
  as MONO_SAMPLE   l,r
end type

' plugin callback
type FillCallback as sub (byval lpArgs as any ptr)

#ifndef NO_CALLBACK
' master,sound,stream callbacks
type FBS_BUFFERCALLBACK as sub (byval pSamples as FBS_SAMPLE ptr, _
                                byval nChannels as integer       , _
                                byval nSamples  as integer)
' load callback                                
type FBS_LOADCALLBACK as sub (byval Percent as integer)
#endif

type FBS_WAVE
  as byte ptr  pStart
  as integer   nBytes
end type

type FBS_SOUND
#ifndef NO_CALLBACK
  as FBS_BUFFERCALLBACK  Callback
  as boolean     EnabledCallback
#endif
  as integer ptr phSound
  as ubyte ptr   pStart
  as ubyte ptr   pPlay
  as ubyte ptr   pEnd
  as ubyte ptr   pUserStart
  as ubyte ptr   pUserEnd
  as ubyte ptr   pOrg
  as ubyte ptr   pBuf
  as integer     nLoops
  as single      Speed
  as single      Volume
  as single      Pan
  as single      lVolume
  as single      rVolume
  as boolean     usercontrol
  as boolean     muted
  as boolean     paused
end type

#endif ' __FBS_TYPES_BI__

