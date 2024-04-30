#ifndef __FBS_PLUGOUT_ARTS__
#define __FBS_PLUGOUT_ARTS__

'  ################
' # plug-arts.bi #
'################
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_PLUG_ARTS 

type arts_stream_t as any ptr

' error codes 
#define ARTS_E_NOSERVER     ( -1 )
#define ARTS_E_NOBACKEND    ( -2 )
#define ARTS_E_NOSTREAM     ( -3 )
#define ARTS_E_NOINIT       ( -4 )
#define ARTS_E_NOIMPL       ( -5 )

' the values for stream parameters
' see arts_parameter_t
type arts_parameter_t as long
const as arts_parameter_t ARTS_P_BUFFER_SIZE     = 1
const as arts_parameter_t ARTS_P_BUFFER_TIME     = 2
const as arts_parameter_t ARTS_P_BUFFER_SPACE    = 3
const as arts_parameter_t ARTS_P_SERVER_LATENCY  = 4
const as arts_parameter_t ARTS_P_TOTAL_LATENCY   = 5
const as arts_parameter_t ARTS_P_BLOCKING        = 6
const as arts_parameter_t ARTS_P_PACKET_SIZE     = 7
const as arts_parameter_t ARTS_P_PACKET_COUNT    = 8
const as arts_parameter_t ARTS_P_PACKET_SETTINGS = 9

' parameters for streams
' ARTS_P_BUFFER_SIZE    (rw) bytes = (ARTS_P_PACKET_SIZE * ARTS_P_PACKET_COUNT)
' ARTS_P_BUFFER_TIME    (rw) ms
' ARTS_P_BUFFER_SPACE   (r ) bytes
' ARTS_P_SERVER_LATENCY (r ) ms
' ARTS_P_TOTAL_LATENCY  (r ) ms = (BUFFER_TIME + SERVER_LATENCY)
' ARTS_P_BLOCKING       (rw) 1 / 0
' ARTS_P_PACKET_SIZE    (r ) bytes
' ARTS_P_PACKET_COUNT   (r ) count
' ARTS_P_PACKET_SETTINGS(rw) uinteger &HCCCCSSSS Size=2^SSSS

extern "c"

' initializes the aRts C API, and connects to the sound server
' return 0 if everything is all right, an error code otherwise
declare function arts_init alias "arts_init" () as long

' asks aRtsd to free the DSP device and 
' return 1 if it was successful, 
' return 0 if there were active non-suspendable modules
declare function arts_suspend alias "arts_suspend" () as long

' asks aRtsd if the DSP device is free and 
' return 1 if it is, 0 if not
declare function arts_suspended alias "arts_suspended" () as long

' converts an error code to a human readable error message
declare function arts_error_text alias "arts_error_text" ( _
byval errorcode as long) as zstring ptr

' open a stream for playing 44100/22050 , 8/16, 1/2, "streamname"
declare function arts_play_stream alias "arts_play_stream" ( _
byval rate       as long, _
byval bits       as long, _
byval channels   as long, _
byval streamname as string) as arts_stream_t

' open a stream for recording 44100/22050 , 8/16, 1/2, "streamname"
declare function arts_record_stream alias "arts_record_stream" ( _
byval rate       as long, _
byval bits       as long, _
byval channels   as long, _
byval streamname as string) as arts_stream_t

#if 0
' read samples from stream
' returns number of read bytes on success or error code
declare function arts_read alias "arts_read" ( _
byval stream   as arts_stream_t, _
byval lpBuffer as any ptr      , _
byval count    as long) as long 
#endif

' write samples to to stream
' returns number of written bytes on success or error code
declare function arts_write alias "arts_write" ( _
byval stream   as arts_stream_t, _
byval lpBuffer as any ptr      , _
byval count    as long) as long 

' configure a parameter of a stream
' returns the new value of the parameter, or an error code
declare function arts_stream_set alias "arts_stream_set" ( _
byval stream as arts_stream_t, _
byval param  as arts_parameter_t, _
byval value  as integer) as integer

' query a parameter of a stream
' returns the value of the parameter, or an error code
declare function arts_stream_get alias "arts_stream_get" ( _
byval stream as arts_stream_t, _
byval param  as arts_parameter_t) as long

' close a stream
declare sub arts_close_stream alias "arts_close_stream" ( _
byval stream as arts_stream_t)

' disconnects from the sound server and frees the aRts C API internals
declare sub arts_free alias "arts_free" ()

end extern

#endif ' NO_PLUG_ARTS

#endif ' __FBS_PLUGOUT_ARTS__
