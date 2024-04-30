#ifndef __VORBISFILE__
#define __VORBISFILE__

' ################
' # oggvorbis.bi #
' ################
#include once "fbstypes.bi"

#ifndef NO_OGG

#inclib "ogg"
#inclib "vorbis"
#inclib "vorbisfile"


extern "c"

#define OV_FALSE      -1
#define OV_EOF        -2
#define OV_HOLE       -3

#define OV_EREAD      -128
#define OV_EFAULT     -129
#define OV_EIMPL      -130
#define OV_EINVAL     -131
#define OV_ENOTVORBIS -132
#define OV_EBADHEADER -133
#define OV_EVERSION   -134
#define OV_ENOTAUDIO  -135
#define OV_EBADPACKET -136
#define OV_EBADLINK   -137
#define OV_ENOSEEK    -138


type ogg_stream_state
  as ubyte ptr      body_data     ' bytes from packet bodies
  as clong          body_storage  ' storage elements allocated
  as clong          body_fill     ' elements stored; fill mark
  as clong          body_returned ' elements of fill returned

  as long ptr       lacing_vals    ' The values that will go to the segment table
  as longint ptr    granule_vals   ' granulepos values for headers. Not compact
                                     ' this way, but it is simple coupled to the lacing fifo
  as clong          lacing_storage
  as clong          lacing_fill
  as clong          lacing_packet
  as clong          lacing_returned

  as ubyte          header(282-1)   ' working space for header encode
  as long           header_fill
  as long           e_o_s ' set when we have buffered the last packet in the logical bitstream
  as long           b_o_s ' set after we've written the initial page of a logical bitstream
  as clong          erialno
  as clong          pageno
  as longint        packetno 
  ' sequence number for decode; the framing knows where there's a hole in the data,
  ' but we need coupling so that the codec (which is in a seperate abstraction layer)
  ' also knows about the gap
  as longint        granulepos
end type

type oggpack_buffer
  as clong          endbyte
  as long           endbit
  as ubyte ptr      buffer
  as ubyte ptr      pchar
  as clong          storage
end type

type ogg_sync_state
  as ubyte ptr        pData
  as long          storage
  as long          fill
  as long          returned
  as long          unsynced
  as long          headerbytes
  as long          bodybytes
end type



type vorbis_info
  as long version
  as long channels
  as clong rate
  as clong bitrate_upper
  as clong bitrate_nominal
  as clong bitrate_lower
  as clong bitrate_window
  as any ptr codec_setup
end type

type vorbis_dsp_state
  as long              analysisp
  as vorbis_info ptr   vi

  as single ptr ptr    pcm
  as single ptr ptr    pcmret
  as long              pcm_storage
  as long              pcm_current
  as long              pcm_returned

  as long           preextrapolate
  as long           eofflag

  as clong           lW
  as clong           W
  as clong           nW
  as clong           centerW

  as longint           granulepos
  as longint           sequence

  as longint           glue_bits
  as longint           time_bits
  as longint           floor_bits
  as longint           res_bits

  as any ptr           backend_state
end type

type vorbis_comment
  ' unlimited user comment fields.  libvorbis writes 'libvorbis'
  ' whatever vendor is set to in encode
  as zstring ptr ptr user_comments
  as long ptr        comment_lengths
  as long            comments
  as zstring ptr     vendor
end type

type alloc_chain
  as any ptr          pPtr
  as alloc_chain ptr pNext
end type

type vorbis_block
  ' necessary stream state for linking to the framing abstraction
  as single ptr ptr   pcm ' this is a pointer into local storage
  as oggpack_buffer   opb

  as clong            lW
  as clong            W
  as clong            nW
  as long             pcmend
  as long             mode

  as long             eofflag
  as longint          granulepos
  as longint          sequence
  as vorbis_dsp_state ptr vd ' For read-only access of configuration

  ' local storage to avoid remallocing; it's up to the mapping to structure it
  as any ptr          localstore
  as clong            localtop
  as clong            localalloc
  as clong            totaluse
  as alloc_chain ptr  reap

  ' bitmetrics for the frame
  as clong            glue_bits
  as clong            time_bits
  as clong            floor_bits
  as clong            res_bits

  as any ptr          internal
end type

type ov_callbacks
  read_func  as function (byval pAny as any ptr,byval size as integer,byval nmemb as integer, byval pUser as any ptr) as integer
  seek_func  as function (byval pUser as any ptr, byval offset as longint, byval whence as long) as long
  close_func as function (byval pUser as any ptr) as long
  tell_func  as function (byval pUser as any ptr) as clong
end type

type OggVorbis_File
  as any ptr           datasource
  as long              seekable
  as longint           offset64
  as longint           end64
  as ogg_sync_state    oy

  ' If the FILE handle isn't seekable (eg, a pipe), only the current stream appears
  as long              links
  as longint ptr       offsets
  as longint ptr       dataoffsets
  as long ptr          serialnos
  as longint ptr       pcmlengths ' overloaded to maintain binary
                                  ' compatability; x2 size, stores both
                                  ' beginning and end values
  as vorbis_info ptr    vi
  as vorbis_comment ptr vc

  ' Decoding working state local storage
  as longint           pcm_offset
  as long              ready_state
  as clong             current_serialno
  as long              current_link

  as longint           bittrack
  as longint           samptrack

  as ogg_stream_state  os ' take physical pages, weld into a logical stream of packets
  as vorbis_dsp_state  vd ' central working state for the packet->PCM decoder
  as vorbis_block      vb ' local working space for packet->PCM decode
  as ov_callbacks      callbacks 
end type

#if 0
function OGGErrorString(code as integer) as string
  select case (code)
    case OV_EREAD:       return "Read from media."
    case OV_ENOTVORBIS:  return "Not Vorbis data."
    case OV_EVERSION:    return "Vorbis version mismatch."
    case OV_EBADHEADER:  return "Invalid Vorbis header."
    case OV_EFAULT:      return "Internal logic fault (bug or heap/stack corruption."
    case else:           return "Unknown Ogg error."
  end select
end function
#endif

' alias "" needed !
declare function ov_clear( _
byval vf as OggVorbis_File ptr) as long 

declare function ov_fopen( _
byval path as zstring ptr, _
byval vf   as OggVorbis_File ptr) as long

declare function ov_open( _
byval pFILE   as any ptr           , _
byval vf      as OggVorbis_File ptr, _
byval initial as ubyte ptr         , _
byval ibytes  as clong) as long

declare function ov_open_callbacks( _
byval datasource as any ptr           , _
byval vf         as OggVorbis_File ptr, _
byval initial    as ubyte ptr         , _
byval ibytes     as clong             , _
byval cb         as ov_callbacks) as long

declare function ov_test( _
byval pFile   as any ptr           , _
byval vf      as OggVorbis_File ptr, _
byval initial as ubyte ptr         , _
byval ibytes  as clong) as long

declare function ov_test_callbacks( _
byval datasource as any ptr           , _
byval vf         as OggVorbis_File ptr, _
byval initial    as ubyte ptr         , _
byval ibytes     as clong             , _
byval cb         as ov_callbacks) as long

declare function ov_test_open( _
byval vf as OggVorbis_File ptr) as long

declare function ov_bitrate( _
byval vf as OggVorbis_File ptr, _
byval i  as long) as clong

declare function ov_bitrate_instant( _
byval vf as OggVorbis_File ptr) as clong

declare function ov_streams( _
byval vf as OggVorbis_File ptr) as clong

declare function ov_seekable( _
byval vf as OggVorbis_File ptr) as clong

declare function ov_serialnumber( _
byval vf as OggVorbis_File ptr, _
byval i  as long) as clong

declare function ov_raw_total( _
byval vf as OggVorbis_File ptr, _
byval i  as long ) as longint

declare function ov_pcm_total( _
byval vf as OggVorbis_File ptr, _
byval i  as long ) as longint

declare function ov_time_total( _
byval vf as OggVorbis_File ptr, _
byval i  as long ) as double

declare function ov_raw_seek( _
byval  vf as OggVorbis_File ptr, _
byval pos as clong) as long

declare function ov_pcm_seek( _
byval  vf as OggVorbis_File ptr, _
byval pos as longint) as long

declare function ov_pcm_seek_page( _
byval  vf as OggVorbis_File ptr, _
byval pos as longint) as long

declare function ov_time_seek( _
byval  vf as OggVorbis_File ptr, _
byval pos as double) as long

declare function ov_time_seek_page( _
byval vf as OggVorbis_File ptr, _
byval pos as double) as long

declare function ov_raw_seek_lap( _
byval vf as OggVorbis_File ptr, _
byval pos as clong) as long

declare function ov_pcm_seek_lap( _
byval vf as OggVorbis_File ptr, _
byval pos as longint) as long

declare function ov_pcm_seek_page_lap( _
byval vf as OggVorbis_File ptr, _
byval pos as longint) as long

declare function ov_time_seek_lap( _
byval vf as OggVorbis_File ptr, _
byval pos as double) as long

declare function ov_time_seek_page_lap( _
byval vf as OggVorbis_File ptr, _
byval pos as double) as long

declare function ov_raw_tell( _
byval vf as OggVorbis_File ptr) as longint

declare function ov_pcm_tell( _
byval vf as OggVorbis_File ptr) as longint

declare function ov_time_tell( _
byval vf as OggVorbis_File ptr) as double

declare function ov_info( _
byval vf as OggVorbis_File ptr, _
byval link as long) as vorbis_info ptr

declare function ov_comment( _
byval vf as OggVorbis_File ptr, _
byval link as long) as vorbis_comment ptr

declare function ov_read_float( _
byval vf as OggVorbis_File ptr, _
byval pcm_channels as single ptr ptr ptr, _
byval samples as long, _
byval bitstream as long ptr) as clong

declare function ov_read( _
byval vf         as OggVorbis_File ptr, _
byval buffer     as ubyte ptr, _
byval length     as long, _
byval bigendianp as long, _
byval word       as long, _
byval sgned      as long, _
byval bitstream  as long ptr) as clong

declare function ov_crosslap( _
byval vf1 as OggVorbis_File ptr, _
byval vf2 as OggVorbis_File ptr) as clong

declare function ov_halfrate( _
byval vf   as OggVorbis_File ptr, _
byval flag as long) as long

declare function ov_halfrate_p( _
byval vf as OggVorbis_File ptr) as long

end extern

#endif ' NO_OGG

#endif ' __VORBISFILE__
