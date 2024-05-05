'  #################
' # plug-arts.bas #
'#################
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"

#ifndef NO_PLUG_ARTS

#include once "fbsound/plug.bi"
#include once "fbsound/plug-static.bi"
#include once "fbsound/plug-arts.bi"

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_arts
#endif

type ARTS
  as FBS_PLUG      Plug
  as arts_stream_t hDevice
  as zstring * 128 LastError
end type

dim shared _Me as ARTS

FBS_MODULE_CDTOR_SCOPE _
sub _init() FBS_MODULE_CTOR
  _Me.Plug.Plugname="ARTS"
end sub

private _
function ARTSWrite() as integer
  dim as integer ret,Buffersize,nErrors
  dim as any ptr lpBuffer
  ' that should never hapent
  if _Me.hDevice             = NULL then return 0
  if _Me.Plug.lpCurentBuffer = NULL then return 0
  if _Me.Plug.Buffersize     =    0 then return 0

  Buffersize=_Me.Plug.Buffersize
  lpBuffer  =_Me.Plug.lpCurentBuffer
  while (Buffersize>0) and (nErrors<3)
    ret=arts_write(_Me.hDevice,lpBuffer,Buffersize)
    if ret=0 then
      sleep 1
    elseif ret>0 then
      Buffersize-=ret
      lpBuffer  +=ret
    else
      nErrors+=1
      _Me.LastError="arts: error ["+ str(ret) + "]!"
      dprint(_Me.LastError)
    end if
  wend
  return nErrors
end function

private _
sub Thread(byval unused as any ptr)
  dim as integer BufferCounter,ThreadID,ret
  dim as any ptr lpArg = @_Me.Plug
  _Me.Plug.lpCurentBuffer=_Me.Plug.lpBuffers[BufferCounter]
  _Me.Plug.FillBuffer(lpArg)
  while _Me.Plug.ThreadExit=false
    ret=ARTSWrite()
    BufferCounter+=1:if BufferCounter=_Me.Plug.nBuffers then BufferCounter=0
    _Me.Plug.lpCurentBuffer=_Me.Plug.lpBuffers[BufferCounter]
    _Me.Plug.FillBuffer(lpArg)
  wend
end sub

private _
function NumOfDeviceNames() as integer
  return 1
end function

private _
function GetDeviceName(byval index as integer) as string
  dim as string tmp
  select case index
    case 1
      return "fbsound"
    case else
      tmp=str(rnd*&HFFFFFFFF)
      tmp="fbsound"+right(trim(tmp),4)
      return tmp
  end select
end function

function plug_error() as string export
  dim as string tmp
  tmp=_Me.LastError
  return tmp
end function

function plug_isany(byref Plug as FBS_PLUG) as boolean export
  dim as integer ret,i

  Plug.Plugname=_Me.Plug.Plugname
  _Me.Plug.DeviceName=""

  for i=0 to NumOfDeviceNames()-1
    ret=arts_init()
    if ret=0 then
      _Me.Plug.DeviceName=GetDeviceName(i)
      Plug.DeviceName=_Me.Plug.DeviceName
      exit for
    end if
  next
  if _Me.Plug.DeviceName="" then
    arts_free
    _Me.LastError="arts:plug_isany error can't connect to server!"
    dprint(_Me.LastError)
    return false
  end if
  arts_free
  return true
end function

function plug_start() as boolean export
  if _Me.hDevice  =NULL then 
     _Me.Lasterror="arts:plug_start error no stream!"
     dprint(_Me.Lasterror)
    return false
  end if
  ' plug is running
  if _Me.Plug.ThreadID<>NULL then
    _Me.Lasterror="arts:plug_start warning thread is running."
    dprint(_Me.Lasterror)
    return true
  end if
  _Me.Plug.ThreadExit=false
  _Me.Plug.ThreadID=ThreadCreate(cptr(any ptr,@Thread))
  if _Me.Plug.ThreadID=NULL then
    _Me.Lasterror="arts:plug_start error can't create thread!"
    dprint(_Me.Lasterror)
    return false
  end if
  return true
end function

function  plug_stop() as boolean export
  if _Me.hDevice=NULL then 
    _Me.LastError="arts:plug_stop error no stream!"
    dprint(_Me.LastError)
    return false
  end if
  if _Me.Plug.ThreadID=NULL then
    _Me.LastError="arts:plug_stop warning no thread to stop."
    dprint(_Me.LastError)
    return false
  end if
  _Me.Plug.ThreadExit=true
  Threadwait _Me.Plug.ThreadID
  _Me.Plug.ThreadID=NULL
  return true
end function

function plug_exit() as boolean export
  dim as integer i
  if _Me.hDevice=NULL then
    arts_free
    _Me.LastError="arts:plug_exit warning no stream."
    dprint(_Me.LastError)
    return true
  end if

  if _Me.Plug.ThreadID<>NULL then plug_stop()
  if _Me.Plug.lpBuffers<>NULL then
    if _Me.Plug.nBuffers>0 then
      for i=0 to _Me.Plug.nBuffers-1
        if _Me.Plug.lpBuffers[i]<>NULL then 
          deallocate _Me.Plug.lpBuffers[i]
          _Me.Plug.lpBuffers[i]=NULL
        end if
      next
    end if
    deallocate _Me.Plug.lpBuffers
    _Me.Plug.lpBuffers=NULL
  end if
  arts_close_stream _Me.hDevice
  arts_free
  _Me.hDevice=NULL
  _Me.Plug.lpCurentBuffer=NULL
  _Me.Plug.nBuffers=0
  _Me.Plug.lpCurentBuffer=NULL
  function=true
end function

function plug_init(byref Plug as FBS_PLUG) as boolean export
  dim as integer    ret,arg
  dim as boolean DontTry8Bit
  ' !!! fix it !!!!
  if _Me.hDevice<>NULL then 
    _Me.LastError = "arts:plug_init error stream is open"
    dprint(_Me.LastError)
    return false
  end if

  'Overwrite device name
  if (_Me.Plug.DeviceName="") and (Plug.DeviceName<>"") then _Me.Plug.DeviceName=Plug.DeviceName

  if _Me.Plug.DeviceName="" then _Me.Plug.DeviceName="fbsound"

  Plug.fmt.Signed=true
  Plug.fmt.nBits\=8
  Plug.fmt.nBits*=8
  if Plug.fmt.nRate<6000  then Plug.fmt.nRate=6000
  if Plug.fmt.nRate>96000 then Plug.fmt.nRate=96000
  if Plug.fmt.nBits< 8    then Plug.fmt.nbits=8
  if Plug.fmt.nBits>16    then Plug.fmt.nbits=16
  if Plug.fmt.nChannels<1 then Plug.fmt.nChannels=1
  if Plug.fmt.nChannels>2 then Plug.fmt.nChannels=2

  ret=arts_init()
  if ret<0 then
    _Me.LastError = "arts:plug_init error can't connect to server!"
    dprint(_Me.LastError)
    return false
  end if

  _Me.hDevice = arts_play_stream(Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,_Me.Plug.DeviceName)
  if _Me.hDevice<0 then
    Plug.fmt.nChannels=1
    _Me.LastError="arts: warning can't create this playback stream trying other values."
    dprint(_Me.LastError)
    plug.fmt.nRate=44100:plug.fmt.nBits=16:plug.fmt.nChannels=2
    _Me.hDevice = arts_play_stream(Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,_Me.Plug.DeviceName)
    if _Me.hDevice<0 then
      plug.fmt.nRate=22050:plug.fmt.nBits=16:plug.fmt.nChannels=2
      _Me.hDevice = arts_play_stream(Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,_Me.Plug.DeviceName)
      if _Me.hDevice<0 then
        plug.fmt.nRate=11025:plug.fmt.nBits=16:plug.fmt.nChannels=2
        _Me.hDevice = arts_play_stream(Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,_Me.Plug.DeviceName)
        if _Me.hDevice<0 then
          _Me.LastError="arts: can't create playback stream!"
          arts_close_stream _Me.hDevice
          arts_free
          _Me.hDEvice=NULL
          return false
        end if
      end if
    end if
  end if

  'now we have an playback stream with an usable format
  _Me.Plug.Fmt.nRate    =Plug.fmt.nRate
  _Me.Plug.Fmt.nBits    =Plug.fmt.nBits
  _Me.Plug.Fmt.nChannels=Plug.fmt.nChannels
  _Me.Plug.Fmt.Signed   =Plug.fmt.Signed

  ' !!! makes shorter values any sence !!!
  if Plug.nFrames<64 then Plug.nFrames=64

  if Plug.nBuffers <2 then Plug.nBuffers=2
  arg=Plug.nBuffers:arg=arg shl 16

  Plug.Framesize=(Plug.fmt.nBits\8)*Plug.fmt.nChannels
  Plug.Buffersize=Plug.nFrames*Plug.Framesize

  ' !!! fixe it to simple bit rotate !!!
  select case Plug.Buffersize
    case 0 to 16
      ret=4
    case 17 to 32
      ret=5
    case 33 to 64
      ret=6
    case 65 to 128
      ret=7
    case 129 to 256
      ret=8
    case 257 to 512
      ret=9
    case 513 to 1024
      ret=10
    case 1025 to 2048
      ret=11
    case 2049 to 4096
      ret=12
    case 4097 to 8192
      ret=13
    case 8193 to 16384
      ret=14
    case 16385 to 32768
      ret=15
    case else
      ret=16
  end select
  arg=arg or ret

  ret=arts_stream_set(_Me.hDevice,ARTS_P_PACKET_SETTINGS,arg)

  if ret<0 then
    _Me.LastError="arts:plug_init error can't set (nBuffers*Buffersize)!"
    dprint(_Me.LastError)
    arts_close_stream _Me.hDevice
    arts_free
    return false
  end if

  Plug.nBuffers  =  hiword(arg)
  Plug.Buffersize=2^loword(arg)

  ' !!! Framessize and nFrames can be changed !!!
  Plug.Framesize=(Plug.fmt.nBits\8) * Plug.fmt.nChannels
  Plug.nFrames  = Plug.Buffersize\Plug.Framesize

  _Me.Plug.nBuffers  =Plug.nBuffers
  _Me.Plug.Buffersize=Plug.Buffersize
  _Me.Plug.nFrames   =Plug.nFrames
  _Me.Plug.Framesize =Plug.Framesize

  ' create our buffers
  _Me.Plug.lpBuffers=callocate(_Me.Plug.nBuffers*SizeOf(any ptr))
  Plug.lpBuffers=_Me.Plug.lpBuffers
  for ret=0 to _Me.Plug.nBuffers-1
    _Me.Plug.lpBuffers[ret]=callocate(_Me.Plug.Buffersize)
    Plug.lpBuffers[ret]=_Me.Plug.lpBuffers[ret]
  next

  _Me.Plug.FillBuffer=Plug.FillBuffer
  return true ' i like it
end function


#if __FB_OUT_DLL__ = 0
private _
function plug_filler_arts cdecl( byref p as FBS_PLUG ) as boolean
	dprint( __FUNCTION__ )
	p.plug_init  = procptr(plug_init)
	p.plug_start = procptr(plug_start)
	p.plug_stop  = procptr(plug_stop)
	p.plug_exit  = procptr(plug_exit)
    p.plug_error = procptr(plug_error)
    return true
end function

public_
sub ctor_plug_arts_init cdecl () FBS_MODULE_REGISTER_CDTOR
	static ctx as fbsound.cdtor.cdtor_struct = _
		( _
			procptr(_plug_arts_init), _
			NULL, _
			@"plug_arts", _
			fbsound.cdtor.MODULE_PLUGIN, _
			procptr(plug_filler_arts) _
		)
	dprint( __FUNCTION__ )
	fbsound.cdtor.register( @ctx )
end sub
#endif

#if __FB_OUT_DLL__ = 0
end namespace ' fbsound.plug_arts
#endif

#endif ' NO_PLUG_ARTS
