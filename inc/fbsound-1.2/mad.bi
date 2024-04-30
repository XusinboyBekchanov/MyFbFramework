#ifndef __MAD_BI__
#define __MAD_BI__

'  ##########
' # mad.bi #
'##########

#include once "fbstypes.bi"

#ifndef NO_MP3

#ifndef __FB_64BIT__
 #define SIZEOF_LONG 4
#else
 #ifdef __FB_WIN32__
  #define SIZEOF_LONG 4
 #else
   ' only linux 64-bit !
  #define SIZEOF_LONG 8
 #endif
#endif

#inclib "mad"

extern "c"
  
#define FPM_INTEL
#define SIZEOF_INT 4
#define SIZEOF_LONG_LONG 8

type cenum as long

extern mad_version   alias "mad_version"   as const zstring ptr
extern mad_copyright alias "mad_copyright" as const zstring ptr
extern mad_author    alias "mad_author"    as const zstring ptr
extern mad_build     alias "mad_build"     as const zstring ptr

type mad_fixed_t     as long
type mad_sample_t    as mad_fixed_t

#define MAD_F_FRACBITS  28
#define MAD_F_SCALEBITS MAD_F_FRACBITS
#define MAD_F(x) (x##L)
#define MAD_F_ONE &H10000000L
#define MAD_F_MIN &H80000000L
#define MAD_F_MAX &H7fffffffL

#if 0
private _
function mad_f_mul( _
  byval a as mad_fixed_t, _
  byval b as mad_fixed_t) as mad_fixed_t
  dim as mad_fixed_t ret=any
  asm
  mov eax,dword ptr [a]
  imul dword    ptr [b]
  shrd eax, edx, 28
  mov dword ptr [ret],eax
  end asm
  return ret
end function
#endif


declare function mad_f_abs (byval a as mad_fixed_t) as mad_fixed_t
declare function mad_f_div (byval a as mad_fixed_t, byval b as mad_fixed_t) as mad_fixed_t



#ifndef LIBMAD_BIT_H
#define LIBMAD_BIT_H

'struct mad_bitptr {
'  unsigned char const *byte;
'  unsigned short cache;
'  unsigned short left;
'};

type mad_bitptr ' !!! field=1
  as const ubyte ptr _byte ' renamed byte
  as ushort          cache
  as ushort          left
end type

'void mad_bit_init(struct mad_bitptr *, unsigned char const *);
declare sub mad_bit_init(byval as mad_bitptr ptr, byval as const ubyte ptr)
#define mad_bit_finish(bitptr) ' nothing

'unsigned int mad_bit_length(struct mad_bitptr const *, struct mad_bitptr const *);
declare function mad_bit_length(byval as const mad_bitptr ptr, byval as const mad_bitptr ptr) as ulong

#define mad_bit_bitsleft(bitptr)  ((bitptr)->left)

'unsigned char const *mad_bit_nextbyte(struct mad_bitptr const *);
declare function mad_bit_nextbyte(byval as const mad_bitptr ptr) as const ubyte ptr

'void mad_bit_skip(struct mad_bitptr *, unsigned int);
declare sub mad_bit_skip(byval as mad_bitptr ptr, byval as ulong)

'unsigned long mad_bit_read(struct mad_bitptr *, unsigned int);
declare function mad_bit_read(byval as mad_bitptr ptr, byval as ulong) as culong

'void mad_bit_write(struct mad_bitptr *, unsigned int, unsigned long);
declare sub mad_bit_write(byval as mad_bitptr ptr, byval as ulong, byval as culong)

'unsigned short mad_bit_crc(struct mad_bitptr, unsigned int, unsigned short);
declare function mad_bit_crc(byval as mad_bitptr, byval as ulong, byval as ushort) as ushort
#endif ' LIBMAD_BIT_H

#ifndef LIBMAD_TIMER_H
#define LIBMAD_TIMER_H

'typedef struct {
'  signed long seconds;		/* whole seconds */
'  unsigned long fraction;	/* 1/MAD_TIMER_RESOLUTION seconds */
'} mad_timer_t;
type mad_timer_t
  as clong  seconds
  as culong fraction ' 1/MAD_TIMER_RESOLUTION
end type  
'extern mad_timer_t const mad_timer_zero
extern mad_timer_zero as mad_timer_t
#define MAD_TIMER_RESOLUTION 352800000UL

type enum_mad_units as cenum
enum mad_units 
  MAD_UNITS_HOURS   = -2
  MAD_UNITS_MINUTES = -1
  MAD_UNITS_SECONDS =  0

  ' metric units 
  MAD_UNITS_DECISECONDS  =   10
  MAD_UNITS_CENTISECONDS =  100
  MAD_UNITS_MILLISECONDS = 1000

  ' audio sample units
  MAD_UNITS_8000_HZ  =  8000
  MAD_UNITS_11025_HZ = 11025
  MAD_UNITS_12000_HZ = 12000

  MAD_UNITS_16000_HZ = 16000
  MAD_UNITS_22050_HZ = 22050
  MAD_UNITS_24000_HZ = 24000

  MAD_UNITS_32000_HZ = 32000
  MAD_UNITS_44100_HZ = 44100
  MAD_UNITS_48000_HZ = 48000

  ' video frame/field units
  MAD_UNITS_24_FPS = 24
  MAD_UNITS_25_FPS = 25
  MAD_UNITS_30_FPS = 30
  MAD_UNITS_48_FPS = 48
  MAD_UNITS_50_FPS = 50
  MAD_UNITS_60_FPS = 60

  ' CD audio frames
  MAD_UNITS_75_FPS = 75

  ' video drop-frame units
  MAD_UNITS_23_976_FPS = -24
  MAD_UNITS_24_975_FPS = -25
  MAD_UNITS_29_97_FPS  = -30
  MAD_UNITS_47_952_FPS = -48
  MAD_UNITS_49_95_FPS  = -50
  MAD_UNITS_59_94_FPS  = -60
end enum

#define mad_timer_reset(_timer) *(_timer) = mad_timer_zero

declare function mad_timer_compare(byval as mad_timer_t, byval as mad_timer_t) as long

#define mad_timer_sign(_timer) mad_timer_compare((_timer), mad_timer_zero)

declare sub mad_timer_negate(byval as mad_timer_t ptr)

declare function mad_timer_abs(byval as mad_timer_t) as mad_timer_t

declare sub mad_timer_set(byval as mad_timer_t ptr, byval as culong, byval as culong, byval as culong)

declare sub mad_timer_add(byval as mad_timer_t ptr, byval as mad_timer_t)

declare sub mad_timer_multiply(byval as mad_timer_t ptr, byval as clong)

declare function mad_timer_count(byval as mad_timer_t, byval as enum_mad_units) as clong

declare function mad_timer_fraction(byval as mad_timer_t, byval as culong) as culong

declare sub mad_timer_string(byval as mad_timer_t, byval as zstring ptr, byval as const zstring ptr, byval as enum_mad_units, byval as enum_mad_units, byval as culong)

#endif ' LIBMAD_TIMER_H

#ifndef LIBMAD_STREAM_H
#define LIBMAD_STREAM_H

#define MAD_BUFFER_GUARD 8
#define MAD_BUFFER_MDLEN (511 + 2048 + MAD_BUFFER_GUARD)

type enum_mad_error as cenum
enum mad_error
  MAD_ERROR_NONE           = &H0000 ' no error

  MAD_ERROR_BUFLEN         = &H0001 ' input buffer too small (or EOF)
  MAD_ERROR_BUFPTR         = &H0002 ' invalid (null) buffer pointer

  MAD_ERROR_NOMEM          = &H0031 ' not enough memory

  MAD_ERROR_LOSTSYNC       = &H0101 ' lost synchronization
  MAD_ERROR_BADLAYER       = &H0102 ' reserved header layer value
  MAD_ERROR_BADBITRATE     = &H0103 ' forbidden bitrate value
  MAD_ERROR_BADSAMPLERATE  = &H0104 ' reserved sample frequency value
  MAD_ERROR_BADEMPHASIS    = &H0105 ' reserved emphasis value

  MAD_ERROR_BADCRC         = &H0201 ' CRC check failed
  MAD_ERROR_BADBITALLOC    = &H0211 ' forbidden bit allocation value
  MAD_ERROR_BADSCALEFACTOR = &H0221 ' bad scalefactor index
  MAD_ERROR_BADFRAMELEN    = &H0231 ' bad frame length
  MAD_ERROR_BADBIGVALUES   = &H0232 ' bad big_values count
  MAD_ERROR_BADBLOCKTYPE   = &H0233 ' reserved block_type
  MAD_ERROR_BADSCFSI       = &H0234 ' bad scalefactor selection info
  MAD_ERROR_BADDATAPTR     = &H0235 ' bad main_data_begin pointer
  MAD_ERROR_BADPART3LEN    = &H0236 ' bad audio data length
  MAD_ERROR_BADHUFFTABLE   = &H0237 ' bad Huffman table select
  MAD_ERROR_BADHUFFDATA    = &H0238 ' Huffman data overrun
  MAD_ERROR_BADSTEREO      = &H0239 ' incompatible block_type for JS
end enum

#define MAD_RECOVERABLE(_error) iif((_error) and &Hff00,true,false)

type mad_stream
  as const ubyte ptr buffer     ' input bitstream buffer
  as const ubyte ptr bufend     ' end of buffer
  as culong          skiplen    ' bytes to skip before next frame
  as long            sync       ' stream sync found
  as culong          freerate   ' free bitrate (fixed)
  as const ubyte ptr this_frame ' start of current frame
  as const ubyte ptr next_frame ' start of next frame
  as mad_bitptr      _ptr       ' current processing bit pointer
  as mad_bitptr      anc_ptr    ' ancillary bits pointer
  as ulong           anc_bitlen ' number of ancillary bits
  as ubyte ptr       main_data  ' !!! (MAD_BUFFER_MDLEN-1)
  as ulong           md_len     ' bytes in main_data
  as long            options    ' decoding options (see below)
  as enum_mad_error  error       ' error code (see above)
end type

enum 
  MAD_OPTION_IGNORECRC      = &H0001 ' ignore CRC errors
  MAD_OPTION_HALFSAMPLERATE = &H0002 ' generate PCM at 1/2 sample rate
end enum

declare sub mad_stream_init(byval as mad_stream ptr)

declare sub mad_stream_finish(byval as mad_stream ptr)

#define mad_stream_options(stream, opts) (stream)->options = (opts)

declare sub mad_stream_buffer(byval as mad_stream ptr, byval as const ubyte ptr, byval as culong)

declare sub mad_stream_skip(byval as mad_stream ptr, byval as culong)

declare function mad_stream_sync(byval as mad_stream ptr) as long

declare function mad_stream_errorstr(byval as const mad_stream ptr) as const zstring ptr

#endif ' LIBMAD_STREAM_H

#ifndef LIBMAD_FRAME_H
#define LIBMAD_FRAME_H

type enum_mad_layer as cenum
enum mad_layer
  MAD_LAYER_I   = 1 ' Layer I
  MAD_LAYER_II  = 2 ' Layer II
  MAD_LAYER_III = 3 ' Layer III
end enum
type enum_mad_mode as cenum
enum mad_mode
  MAD_MODE_SINGLE_CHANNEL = 0 ' single channel
  MAD_MODE_DUAL_CHANNEL   = 1 ' dual channel
  MAD_MODE_JOINT_STEREO   = 2 ' joint (MS/intensity) stereo
  MAD_MODE_STEREO         = 3 ' normal LR stereo
end enum
type enum_mad_emphasis as cenum
enum mad_emphasis
  MAD_EMPHASIS_NONE       = 0 ' no emphasis
  MAD_EMPHASIS_50_15_US   = 1 ' 50/15 microseconds emphasis
  MAD_EMPHASIS_CCITT_J_17 = 3 ' CCITT J.17 emphasis
  MAD_EMPHASIS_RESERVED   = 2 ' unknown emphasis
end enum

type mad_header
  as enum_mad_layer    layer          ' audio layer (1, 2, or 3)
  as enum_mad_mode     mode           ' channel mode (see above)
  as long              mode_extension ' additional mode info
  as enum_mad_emphasis emphasis       ' de-emphasis to use (see above)
  as culong            bitrate        ' stream bitrate (bps)
  'unsigned int samplerate;
  as ulong             samplerate     ' sampling frequency (Hz)
  as ushort            crc_check      ' frame CRC accumulator
  as ushort            crc_target     ' final target CRC checksum
  as long              flags          ' flags (see below)
  as long              private_bits   ' private bits (see below)
  as mad_timer_t       duration       ' audio playing time of frame
end type

type mad_frame
  as mad_header      header            ' MPEG audio header 
  as long            options           ' decoding options (from stream)
  as mad_fixed_t     sbsample(1,35,31) ' synthesis subband filter samples
  as mad_fixed_t ptr overlap           ' (1,31,17)  Layer III block overlap data
end type

#define MAD_NCHANNELS(header) iif((header)->mode,2,1)

#define define MAD_NSBSAMPLES(header) iif((header)->layer = MAD_LAYER_I , 12 , iif( ((header)->layer = MAD_LAYER_III and ((header)->flags and MAD_FLAG_LSF_EXT)), 18 , 36))

enum
  MAD_FLAG_NPRIVATE_III = &H0007 ' number of Layer III private bits
  MAD_FLAG_INCOMPLETE   = &H0008 ' header but not data is decoded

  MAD_FLAG_PROTECTION   = &H0010 ' frame has CRC protection
  MAD_FLAG_COPYRIGHT    = &H0020 ' frame is copyright
  MAD_FLAG_ORIGINAL     = &H0040 ' frame is original (else copy)
  MAD_FLAG_PADDING      = &H0080 ' frame has additional slot

  MAD_FLAG_I_STEREO     = &H0100 ' uses intensity joint stereo
  MAD_FLAG_MS_STEREO    = &H0200 ' uses middle/side joint stereo
  MAD_FLAG_FREEFORMAT   = &H0400 ' uses free format bitrate

  MAD_FLAG_LSF_EXT      = &H1000 ' lower sampling freq. extension
  MAD_FLAG_MC_EXT       = &H2000 ' multichannel audio extension
  MAD_FLAG_MPEG_2_5_EXT = &H4000 ' MPEG 2.5 (unofficial) extension
end enum

enum
  MAD_PRIVATE_HEADER = &H0100 ' header private bit
  MAD_PRIVATE_III    = &H001f ' Layer III private bits (up to 5)
end enum

declare sub mad_header_init(byval as mad_header ptr)

#define mad_header_finish(header)  ' nothing

declare function mad_header_decode(byval as mad_header ptr, byval as mad_stream ptr) as long

declare sub mad_frame_init(byval as mad_frame ptr)

declare sub mad_frame_finish(byval as mad_frame ptr)

declare function mad_frame_decode(byval as mad_frame ptr, byval as mad_stream ptr) as long

declare sub mad_frame_mute(byval as mad_frame ptr)

#endif ' LIBMAD_FRAME_H

#ifndef LIBMAD_SYNTH_H
#define LIBMAD_SYNTH_H

type mad_pcm
  as ulong samplerate            ' sampling frequency (Hz) 
  as ushort channels             ' number of channels
  as ushort length               ' number of samples per channel
  as mad_fixed_t samples(1,1151) ' PCM output samples [ch][sample] 
end type

type mad_synth
  as mad_fixed_t filter(1, 1, 1, 15, 7) ' polyphase filterbank outputs [ch][eo][peo][s][v]
  as ulong       phase                  ' current processing phase
  as mad_pcm     pcm                    ' PCM output
end type

' single channel PCM selector
enum
  MAD_PCM_CHANNEL_SINGLE = 0
end enum

' dual channel PCM selector
enum
  MAD_PCM_CHANNEL_DUAL_1 = 0
  MAD_PCM_CHANNEL_DUAL_2 = 1
end enum 

' stereo PCM selector
enum
  MAD_PCM_CHANNEL_STEREO_LEFT  = 0
  MAD_PCM_CHANNEL_STEREO_RIGHT = 1
end enum

declare sub mad_synth_init(byval as mad_synth ptr)

#define mad_synth_finish(synth) ' nothing

declare sub mad_synth_mute(byval as mad_synth ptr)

declare sub mad_synth_frame(byval as mad_synth ptr, byval as const mad_frame ptr)

#endif ' LIBMAD_SYNTH_H

#ifndef LIBMAD_DECODER_H
#define LIBMAD_DECODER_H

type enum_mad_decoder_mode as cenum
enum mad_decoder_mode
  MAD_DECODER_MODE_SYNC  = 0
  MAD_DECODER_MODE_ASYNC = 1
end enum 

type enum_mad_flow as cenum
enum mad_flow 
  MAD_FLOW_CONTINUE = &H0000 ' continue normally
  MAD_FLOW_STOP     = &H0010 ' stop decoding normally
  MAD_FLOW_BREAK    = &H0011 ' stop decoding and signal an error
  MAD_FLOW_IGNORE   = &H0020 ' ignore the current frame
end enum

type async_t
  as clong pid
  as long in
  as long out
end type

type sync_t 
  as mad_stream stream
  as mad_frame frame
  as mad_synth synth
end type

type input_func_t   as function (byval userdata as any ptr, byval as mad_stream ptr) as enum_mad_flow
type header_func_t  as function (byval userdata as any ptr, byval as const mad_header ptr) as enum_mad_flow
type filter_func_t  as function (byval userdata as any ptr, byval as const mad_stream ptr, byval as mad_frame ptr) as enum_mad_flow
type output_func_t  as function (byval userdata as any ptr, byval as const mad_header ptr, byval as mad_pcm ptr) as enum_mad_flow
type error_func_t   as function (byval userdata as any ptr, byval as mad_stream ptr, byval as mad_frame ptr) as enum_mad_flow
type message_func_t as function (byval userdata as any ptr, byval as any ptr, byval as ulong ptr) as enum_mad_flow

type mad_decoder 
  as enum_mad_decoder_mode mode
  as long           options
  as async_t        async
  as sync_t ptr     sync
  as any ptr        cb_data
  as input_func_t   input_func
  as header_func_t  header_func
  as filter_func_t  filter_func
  as output_func_t  output_func
  as error_func_t   error_func
  as message_func_t message_func
end type

declare sub mad_decoder_init(byval as mad_decoder ptr, _
                             byval as any ptr        , _ ' userdata
                             byval as input_func_t   , _
                             byval as header_func_t  , _
                             byval as filter_func_t  , _
                             byval as output_func_t  , _
                             byval as error_func_t   , _
                             byval as message_func_t)           

declare function mad_decoder_finish(byval as mad_decoder ptr) as long

#define mad_decoder_options(decoder, opts) (decoder)->options = (opts)

declare function mad_decoder_run(byval as mad_decoder ptr, byval as enum_mad_decoder_mode) as long

declare function mad_decoder_message(byval as mad_decoder ptr, byval as any ptr, byval as ulong ptr) as long

end extern

#endif ' LIBMAD_DECODER_H

#endif ' NO_MP3

#endif ' __MAD_BI__
