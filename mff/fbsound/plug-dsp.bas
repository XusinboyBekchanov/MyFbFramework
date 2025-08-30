'  ################
' # plug-dsp.bas #
'################
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"

#ifndef NO_PLUG_DSP

#include once "fbsound/plug.bi"
#include once "fbsound/plug-static.bi"
#include once "fbsound/plug-dsp.bi"

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_dsp
	extern "c"
		extern required as long
		dim shared required as long
	end extern
end namespace
#endif

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_dsp
#endif

type DSP
  as FBS_PLUG      Plug
  as FILEHANDLE    hDevice
  as zstring * 128 LastError
end type

dim shared _Me as DSP

FBS_MODULE_CDTOR_SCOPE _
sub _plug_dsp_init cdecl () FBS_MODULE_CTOR
  dprint("plug_dsp_init() module constructor")
  _Me.Plug.Plugname="DSP"
end sub

FBS_MODULE_CDTOR_SCOPE _
sub _plug_dsp_exit cdecl () FBS_MODULE_DTOR
  dprint("plug_dsp_exit~")
end sub

private _
function DSPWrite() as integer
  dim as integer ret,Buffersize,nErrors
  dim as any ptr pBuffer
  ' that should never hapent
  if _Me.hDevice             =    0 then return 0
  if _Me.Plug.lpCurentBuffer = NULL then return 0
  if _Me.Plug.Buffersize     =    0 then return 0

  Buffersize = _Me.Plug.Buffersize
  pBuffer    = _Me.Plug.lpCurentBuffer
  while (Buffersize>0) andalso (nErrors<3)
    ret = sys_write(_Me.hDevice, pBuffer, Buffersize)
    if ret = _FBS_EAGAIN then
      sleep 1
    elseif ret > 0 then
      Buffersize -= ret
      pBuffer    += ret
    else
      nErrors += 1
      _Me.LastError = "dsp: write unknow error [" & str(ret) & "]!"
      dprint(_Me.LastError)
    end if
  wend
  return 1
end function

private _
sub myThread(byval unused as any ptr)
  dim as integer BufferCounter,ThreadID,ret
  dprint("dsp: Thread()")
  _Me.Plug.lpCurentBuffer = _Me.Plug.lpBuffers[BufferCounter]
  _Me.Plug.FillBuffer(@_Me.Plug)
  while _Me.Plug.ThreadExit=false
    ret=DSPWrite()
    BufferCounter = (BufferCounter+1) mod _Me.Plug.nBuffers
    _Me.Plug.lpCurentBuffer = _Me.Plug.lpBuffers[BufferCounter]
    _Me.Plug.FillBuffer(@_Me.Plug)
  wend
  dprint("dsp: Thread~")
end sub

private _
function NumOfDeviceNames() as integer
  return 6
end function

private _
function GetDeviceName(byval index as integer) as string
  if index<0 then
    index=5
  elseif index>5 then
    index=0
  end if
  dim as string tmp    
  select case index
    case 0 : tmp = "/dev/dsp"
    case 1 : tmp = "/dev/dsp0"      
    case 2 : tmp = "/dev/dsp1"
    case 3 : tmp = "/dev/sound/dsp"
    case 4 : tmp = "/dev/sound/dsp0"
    case 5 : tmp = "/dev/sound/dsp1"
  end select
  dprint("dsp: GetDeviceName " & tmp)
  return tmp
end function

function plug_error() as string export
  dim as string tmp=_Me.LastError
  return tmp
end function

function plug_isany(byref Plug as FBS_PLUG) as boolean export
  dim as integer ret,i,j
  dim as FILEHANDLE tmp
  dprint("dsp: plug_isany()")

  Plug.Plugname=_Me.Plug.Plugname
  _Me.Plug.DeviceName=""

  for i=0 to NumOfDeviceNames()-1
    dim as string strtmp = GetDeviceName(i)
    tmp = sys_open(strptr(strtmp), _FBS_O_WRONLY or _FBS_O_NONBLOCK)
    if (tmp = _FBS_EAGAIN) then
      for j=1 to 5 ' try 5 seconds
        sleep 1000,1
        tmp = sys_open(strptr(strtmp), _FBS_O_WRONLY or _FBS_O_NONBLOCK)
        if tmp>-1 then exit for
      next
    end if
    if tmp>-1 then 
      _Me.Plug.DeviceName = strtmp
      Plug.DeviceName = _Me.Plug.DeviceName
      exit for
    end if
  next
  
  if _Me.Plug.DeviceName="" then
    _Me.LastError="dsp: isany error no free device!"
    dprint(_Me.LastError)
    return false
  end if
  
  sys_close tmp
  dprint("dsp: plug_isany~")
  return true
end function

function plug_start() as boolean export
  dprint("dsp: plug_start()")
  if _Me.hDevice  =NULL then 
     _Me.Lasterror="dsp: plug_start error: no device!"
     dprint(_Me.Lasterror)
    return false
  end if
  ' plug is running
  if _Me.Plug.ThreadID<>NULL then
    _Me.Lasterror="dsp: plug_start warning: thread is running."
    dprint(_Me.Lasterror)
    return true
  end if
  _Me.Plug.ThreadExit = false
  _Me.Plug.ThreadID = ThreadCreate(@myThread)
  if _Me.Plug.ThreadID = NULL then
    _Me.Lasterror="dsp: plug_start error: can't create thread!"
    dprint(_Me.Lasterror)
    return false
  end if
  dprint("dsp: plug_start~")
  return true
end function

function plug_stop() as boolean export
  dprint("dsp: plug_stop()")
  if _Me.hDevice=0 then 
    _Me.LastError="dsp: plug_stop error: no device!"
    dprint(_Me.LastError)
    return false
  end if
  if _Me.Plug.ThreadID=0 then
    _Me.LastError="dsp: plug_stop warning: no thread to stop."
    dprint(_Me.LastError)
    return false
  end if
  _Me.Plug.ThreadExit = true
  Threadwait _Me.Plug.ThreadID
  _Me.Plug.ThreadID = NULL

  dprint("dsp: plug_stop~")
  return true
end function

function plug_exit() as boolean export
  dprint("dsp: plug_exit()")
  dim as integer i
  if _Me.hDevice=NULL then
    _Me.LastError="dsp: plug_exit warning no open device."
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
  end if
  _Me.Plug.lpBuffers=NULL
  _Me.Plug.lpCurentBuffer=NULL
  _Me.Plug.nBuffers=0
  _Me.Plug.lpCurentBuffer=NULL
  sys_close _Me.hDevice : _Me.hDevice=NULL
  dprint("dsp: plug_exit~")
  return true
end function

function  plug_init (byref Plug as FBS_PLUG) as boolean export
  dprint("dsp: plug_init()")
  dim as long ret,cmd,arg

  ' !!! fix it !!!!
  if _Me.hDevice<>NULL then 
    _Me.LastError = "dsp: plug_init error: device is open"
    dprint(_Me.LastError)
    return false
  end if

  'Overwrite device name
  if _Me.Plug.DeviceName="" then _Me.Plug.DeviceName="/dev/dsp"
  if plug.DeviceIndex>-1 then
    _Me.Plug.DeviceName = GetDeviceName(plug.DeviceIndex)
    Plug.DeviceName = _Me.Plug.DeviceName
  end if

  Plug.fmt.nBits\=8
  Plug.fmt.nBits*=8
  if Plug.fmt.nRate<6000  then Plug.fmt.nRate=6000
  if Plug.fmt.nRate>96000 then Plug.fmt.nRate=96000
  if Plug.fmt.nBits< 8    then Plug.fmt.nbits=8
  if Plug.fmt.nBits>16    then Plug.fmt.nbits=16
  if Plug.fmt.nChannels<1 then Plug.fmt.nChannels=1
  if Plug.fmt.nChannels>2 then Plug.fmt.nChannels=2
  
  dim as string strTmp = _Me.Plug.DeviceName
  ret=sys_open(strptr(strTmp), _FBS_O_WRONLY or _FBS_O_NONBLOCK)
  if ret<0 then
    _Me.LastError = "dsp: plug_init error: can't open device ["+  _Me.Plug.DeviceName + "]!" 
    dprint(_Me.LastError)
    return false
  end if
  
  _Me.hDevice=ret
  cmd=SNDCTL_DSP_RESET:arg=0
  ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
  if ret <0 then 
    _Me.LastError="dsp: plug_init error: can't set SNDCTL_DSP_RESET!"
    dprint(_Me.LastError)
    sys_close _Me.hDevice
    _Me.hDevice=0
    return false
  end if

#if 0
  cmd=SNDCTL_DSP_NONBLOCK:arg=0
  ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
  if ret <0 then 
    _Me.LastError="dsp: plug_init error: can't set none blocking mode!"
    dprint(_Me.LastError)
    sys_close _Me.hDevice
    return false
  end if
#endif

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

  cmd=SNDCTL_DSP_SETFRAGMENT
  ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
  if ret <0 then 
    _Me.LastError="dsp: plug_init error: can't set SNDCTL_DSP_SETFRAGMENT (nBuffers*Buffersize)!"
    dprint(_Me.LastError)
    sys_close _Me.hDevice
    _Me.hDevice=0
    return false
  end if

  Plug.nBuffers  =  hiword(arg)
  Plug.Buffersize=2^loword(arg)

  cmd=SNDCTL_DSP_SPEED:arg=Plug.fmt.nRate
  ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
  if ret <0 then 
    _Me.LastError="dsp: plug_init error can't set SNDCTL_DSP_SPEED (nRate) to [" + str(Plug.fmt.nRate) + "]!"
    dprint(_Me.LastError)
    sys_close _Me.hDevice
    _Me.hDevice=0
    return false
  end if

  if Plug.fmt.nBits=8 then
    ' first try signed 8 bit
    cmd=SNDCTL_DSP_SETFMT:arg=AFMT_S8
    ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
    if ret<0 then ' try unsigned 8 bit
      cmd=SNDCTL_DSP_SETFMT:arg=AFMT_U8
      ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
      ' not all devices supports 8 bit
      if ret<0 then 
        Plug.fmt.nBits=16
      else
        Plug.fmt.Signed=false
      end if
    else
      Plug.fmt.signed=true
    end if
  end if

  ' signed 16 bit litle endian
  if Plug.fmt.nBits=16 then
    cmd=SNDCTL_DSP_SETFMT:arg=AFMT_S16_LE
    ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
    ' not all devices supports 16 bit
    if ret<0 then
      Plug.fmt.nBits=8
      cmd=SNDCTL_DSP_SETFMT:arg=AFMT_S8
      ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
      if ret<0 then
        ' last hope unsigned 8 bit
        cmd=SNDCTL_DSP_SETFMT:arg=AFMT_U8
        ret=SYS_IOCTL(_Me.hDevice,cmd,@arg) 
        if ret<0 then
          _Me.LastError="dsp: plug_init error: can't set SNDCTL_DSP_SETFMT (nBits)"
          dprint(_Me.LastError)
          sys_close _Me.hDevice
          _Me.hDevice=0
          return false
        else
          Plug.fmt.Signed=false
        end if
      else 
        Plug.fmt.Signed=true
      end if
    else
      Plug.fmt.Signed=true
    end if
  end if

  if Plug.fmt.nChannels=1 then 
    cmd=SNDCTL_DSP_CHANNELS:arg=1
    ret=SYS_IOCTL(_Me.hDevice,cmd,@arg)
    ' not all devices support mono
    if ret <0 then Plug.fmt.nChannels=2
  end if

  if Plug.fmt.nChannels=2 then 
    cmd = SNDCTL_DSP_CHANNELS : arg=2
    ret = SYS_IOCTL(_Me.hDevice, cmd, @arg)
    ' not all devices supports stereo
    if ret <0 then 
      Plug.fmt.nChannels = 1
      cmd = SNDCTL_DSP_CHANNELS : arg=1
      ret = SYS_IOCTL(_Me.hDevice, cmd, @arg)
      if ret<0 then 
        _Me.LastError="dsp: plug_init error: can't set SNDCTL_DSP_CHANNELS (nChannels)"
        dprint(_Me.LastError)
        sys_close _Me.hDevice : _Me.hDevice = NULL
        return false
      end if
    end if
  end if
  ' device is open with an usable format now
  _Me.Plug.Fmt.nRate     = Plug.fmt.nRate
  _Me.Plug.Fmt.nBits     = Plug.fmt.nBits
  _Me.Plug.Fmt.nChannels = Plug.fmt.nChannels
  _Me.Plug.Fmt.Signed    = Plug.fmt.Signed

  ' !!! Framessize and nFrames can be changed !!!
  Plug.Framesize = (Plug.fmt.nBits\8) * Plug.fmt.nChannels
  Plug.nFrames   = Plug.Buffersize\Plug.Framesize

  _Me.Plug.nBuffers   = Plug.nBuffers
  _Me.Plug.Buffersize = Plug.Buffersize
  _Me.Plug.nFrames    = Plug.nFrames
  _Me.Plug.Framesize  = Plug.Framesize

  ' create our buffers
  _Me.Plug.lpBuffers = callocate(_Me.Plug.nBuffers*sizeof(any ptr))
  Plug.lpBuffers = _Me.Plug.lpBuffers
  for ret = 0 to _Me.Plug.nBuffers-1
    _Me.Plug.lpBuffers[ret] = callocate(_Me.Plug.Buffersize)
    Plug.lpBuffers[ret] = _Me.Plug.lpBuffers[ret]
  next

  _Me.Plug.FillBuffer = Plug.FillBuffer
  dprint("dsp: plug_init~")
  return true ' i like it :-)
end function

#if __FB_OUT_DLL__ = 0
private _
function plug_filler_dsp cdecl( byref p as FBS_PLUG ) as boolean
	p.plug_init  = procptr(plug_init)
	p.plug_start = procptr(plug_start)
	p.plug_stop  = procptr(plug_stop)
	p.plug_exit  = procptr(plug_exit)
    p.plug_error = procptr(plug_error)
    return true
end function

public _
sub ctor_plug_dsp_init cdecl () FBS_MODULE_REGISTER_CDTOR
	static ctx as fbsound.cdtor.cdtor_struct = _
		( _
			procptr(_plug_dsp_init), _
			procptr(_plug_dsp_exit), _
			@"plug_dsp", _
			fbsound.cdtor.MODULE_PLUGIN3, _
			procptr(plug_filler_dsp) _
		)
	dprint( __FUNCTION__ )
	fbsound.cdtor.register( @ctx )
end sub
#endif

#if __FB_OUT_DLL__ = 0
end namespace ' fbsound.plug_dsp
#endif

#endif ' NO_PLUG_DSP
