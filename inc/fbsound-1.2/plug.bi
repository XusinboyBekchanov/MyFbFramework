#ifndef __FBS_PLUG_BI__
#define __FBS_PLUG_BI__

'  ###########
' # plug.bi #
'###########
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

' common to all plug-XXX interfaces
#include once "fbstypes.bi"

type FBS_PLUG_t
  as any ptr           plug_hLib
  ' interface
  as function ()                         as string   plug_error
  as function (byref Plug as FBS_PLUG_t) as boolean  plug_isany
  as function (byref Plug as FBS_PLUG_t) as boolean  plug_init
  as function ()                         as boolean  plug_start
  as function ()                         as boolean  plug_stop
  as function ()                         as boolean  plug_exit

  as any ptr           ThreadID
  as boolean           ThreadExit
  as FILLCALLBACK      FillBuffer

  ' plublic section
  as zstring * 64      PlugName
  as zstring * 64      DeviceName
  as integer           DeviceIndex
  as integer           Framesize
  as integer           nFrames
  as integer           nBuffers
  as integer           BufferSize
  as ubyte ptr         lpCurentBuffer
  as any ptr ptr       lpBuffers
  as FBS_FORMAT        Fmt
end type
type FBS_PLUG as FBS_PLUG_t

#endif ' __FBS_PLUG_BI__
