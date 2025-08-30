'  ###############
' # plug-mm.bas #
'###############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbs-config.bi"
#include once "fbstypes.bi"

#ifndef NO_PLUG_MM

#include once "plug.bi"
#include once "plug-static.bi"
#include once "plug-mm.bi"

#if __FB_OUT_DLL__ = 0
Namespace fbsound.plug_mm
	Extern "c"
		Extern required As Long
		Dim Shared required As Long
	End Extern
End Namespace
#endif

#if __FB_OUT_DLL__ = 0
Namespace fbsound.plug_mm
#endif

#define max_buffers_mm 512
#define min_frames_mm   64

Type MM
  As FBS_PLUG        Plug
  As HWAVEOUT        hDevice
  As ZString * 128   LastError
  As WAVEHDR         Hdrs(max_buffers_mm-1) 
  As Any Ptr         FillThreadID ,FillCondition,FillMutex
  As Any Ptr         WriteThreadID,WriteCondition,WriteMutex
  As Boolean         FillEnd,WriteEnd
End Type

Dim Shared _MePlug As MM

FBS_MODULE_CDTOR_SCOPE _
Sub _plug_mm_init cdecl () FBS_MODULE_CTOR
  dprint("_plug_mm_init() module constructor")
  _MePlug.Plug.PlugName="mm"
End Sub

FBS_MODULE_CDTOR_SCOPE _
Sub _plug_mm_exit cdecl () FBS_MODULE_DTOR
  dprint("_plug_mm_exit() module destructor")
End Sub

Private _
Function CreateTimeStamp() As Integer
  Static As Integer id
  id+=1:Return id
End Function

Private _
Function GetNumOfFreeBuffers() As Integer
  Dim As Integer i,c  
  If _MePlug.Plug.nBuffers<1 Then 
    dprint("mm: GetNumOfFreeBuffers nBuffers<1")
    Return 0
  End If
  For i=0 To _MePlug.Plug.nBuffers-1
    If (_MePlug.Hdrs(i).dwFlags And 1)=1 And _
       (_MePlug.Hdrs(i).dwUser=0) Then c+=1
  Next
  Return c
End Function

private _
function GetNextFreeBufferIndex() as integer
  dim as integer i,c=-1 
  if _MePlug.plug.nBuffers<1 then 
    dprint("mm: GetNextFreeBufferIndex nBuffers<1")
    return c
  end if

  for i=0 to _MePlug.plug.nBuffers-1
    ' is done ?  
    if (_MePlug.hdrs(i).dwFlags and 1)=1 and (_MePlug.hdrs(i).dwUser=0) then c=i
    if c>-1 then exit for
  next
  return c
end function

private _
function GetNumOfWaitingBuffers() as integer
  dim as integer i,c
  if _MePlug.plug.nBuffers <1 then 
    dprint("mm: GetNumOfWaitingBuffers nBuffers<1")
    return 0
  end if
  for i=0 to _MePlug.plug.nBuffers-1
    if (_MePlug.hdrs(i).dwFlags and 1)=1 and (_MePlug.hdrs(i).dwUser>0) then c+=1
  next
  return c
end function

private _
function GetNextWaitingBuffer() as integer
  dim as integer i,Timestamp=&H7FFFFFFF,c=-1 
  if _MePlug.plug.nBuffers <1 then 
    dprint("mm: GetNextWaitingBuffer nBuffers<1")
    return c
  end if
  for i=0 to _MePlug.plug.nBuffers-1
    if (_MePlug.hdrs(i).dwFlags and 1)=1 and (_MePlug.hdrs(i).dwUser>0) then
      if (_MePlug.hdrs(i).dwUser<Timestamp) then 
         Timestamp=_MePlug.hdrs(i).dwUser
         c=i
      end if
    end if
  next
  if c=-1 then
    dprint("mm: GetNextWaitingBuffer c=-1")     
  end if
  return c
end function

 ' CALLBACK                        
private sub waveOutProc(byval hDevice    as HWAVEOUT, _
                        byval uMsg       as UINT, _
                        byval dwInstance as DWORD_PTR, _ ' 
                        byval dwParam1   as DWORD_PTR, _ ' lpHdr 
                        byval dwParam2   as DWORD_PTR)
  if uMsg = WOM_DONE then 
    if (_MePlug.FillCondition<>0) then 
      if (_MePlug.FillEnd=false) andalso (_MePlug.WriteEnd=false) then
        CondSignal(_MePlug.FillCondition)
      end if  
    elseif (_MePlug.WriteEnd=false) andalso (_MePlug.FillEnd=false) then
      dprint("mm: warning: waveOutProc() FillCondition=NULL") 
    end if 
  end if
end sub

private _
sub WriteThread(byval unused as any ptr)
  dim as integer ret,i,j
  dprint("mm: WriteThread()")
  
  _MePlug.WriteEnd=false
  
  while (_MePlug.WriteEnd=false)
  
    if (_MePlug.WriteMutex<>0) then
      
      if (_MePlug.WriteCondition<>0) then
        
        MutexLock(_MePlug.WriteMutex)
          CondWait(_MePlug.WriteCondition,_MePlug.WriteMutex)
        MutexUnLock(_MePlug.WriteMutex)
        
        while GetNumofWaitingBuffers()>0 andalso (_MePlug.WriteEnd=false)
          i=GetNextWaitingBuffer()
          if (i>-1) then
            do  
              ret=waveOutWrite(_MePlug.hDevice,@_MePlug.hdrs(i),sizeof(WAVEHDR))
            loop while (ret=33) and (_MePlug.WriteEnd=0)
            if (ret<>0) then 
              dprint("mm: WriteThread waveOutWrite(" + str(i) + ")=" + str(ret) )
            else
             _MePlug.hdrs(i).dwUser=0
            end if    
          else
            dprint("mm: WriteThread GetNextWaitingBuffer()=-1")
          end if
        wend
      else
        dprint("mm: WriteThread: warning: WriteCondition=NULL")
      end if '(_MePlug.WriteCondition<>0)
    else
      dprint("mm: WriteThread: warning: WriteMutex=NULL")
    end if ' (_MePlug.WriteMutex<>0) 
  wend
  dprint("mm: writethread~")
end sub

private _
sub FillThread(byval unused as any ptr)
  dim as integer i
  dim as any ptr lpArg = @_MePlug.Plug
  dprint("mm: FillThread()")
  
  _MePlug.FillEnd=false
  
  _MePlug.Plug.FillBuffer(lpArg)
  
  while (_MePlug.FillEnd=false)
  
    while (GetNumOfFreeBuffers()>0) andalso (_MePlug.FillEnd=false)
      i=GetNextFreeBufferIndex()
      if i>-1 then
        _MePlug.Plug.lpCurentBuffer=_MePlug.hdrs(i).lpData
        _MePlug.Plug.FillBuffer(lpArg)
        _MePlug.hdrs(i).dwUser = CreateTimeStamp()
        CondSignal(_MePlug.WriteCondition)
      else
        dprint("mm: FillThread: GetFreeBuffer()=-1")
      end if
    wend
    
    MutexLock(_MePlug.FillMutex)
      CondWait(_MePlug.FillCondition,_MePlug.FillMutex)
    MutexUnlock(_MePlug.FillMutex)
    
  wend
  dprint("mm: FillThread~")
end sub

private _
function NumOfDeviceNames() as integer
  return waveOutGetNumDevs()
end function

private _
function GetDeviceName(byval index as integer) as string
  dim as string tmp 
  dim as WAVEOUTCAPS caps
  if waveOutGetDevCaps(index,@caps,sizeof(WAVEOUTCAPS))<>MMSYSERR_NOERROR  then
    tmp = "card [" & trim(str(index)) & "]"
  else
    tmp = caps.szPname
  end if
  return tmp
end function

function plug_error() as string export
  dim tmp as string
  tmp=_MePlug.LastError
  return tmp
end function

function plug_isany(byref Plug as FBS_PLUG) as boolean export
  dim as integer ret,nDevices,i,j,tmp
  dprint("mm: plug_isany")
  Plug.Plugname=_MePlug.Plug.Plugname
  _MePlug.Plug.DeviceName=""
  nDevices=NumOfDeviceNames()
  if nDevices<1 then 
    _MePlug.LastError="mm: plug_isany error no devices!"
    dprint(_MePlug.LastError)
    return false
  end if  
  return true
end function

function plug_start() as boolean export
  dprint("mm: plug_start()")  
  if _MePlug.hDevice=0 then 
    _MePlug.LastError="mm: start error no device!"
    dprint(_MePlug.LastError)
    return false
  end if
  ' plug is running
  if (_MePlug.WriteThreadID<>NULL) and (_MePlug.FillThreadID<>NULL) then 
    _MePlug.LastError="mm: plug_start() warniung thread's are running."
    dprint(_MePlug.LastError)
    return false
  end if
  _MePlug.WriteCondition = CondCreate()
  _MePlug.WriteMutex     = MutexCreate()
  _MePlug.WriteEnd       = true
  _MePlug.WriteThreadID  = ThreadCreate(@WriteThread)
  while _MePlug.WriteEnd = true  : sleep(10,1): wend
  _MePlug.FillCondition  = CondCreate()
  _MePlug.FillMutex      = MutexCreate()
  _MePlug.FillEnd        = true
  _MePlug.FillThreadID   = ThreadCreate(@FillThread)
  while _MePlug.FillEnd  = true : sleep(10,1):wend
  return true
end function

function plug_stop() as boolean export
  dprint("mm: plug_stop()")
  if _MePlug.hDevice=0 then 
    _MePlug.LastError="mm: stop warning no open device."
    dprint(_MePlug.LastError)
  end if

  if (_MePlug.WriteThreadID=NULL) andalso (_MePlug.FillThreadID=NULL) then 
    _MePlug.LastError="mm: plug_stop() warning no running threads."
    dprint(_MePlug.LastError)
    return true
  end if

  _MePlug.WriteEnd=true
  CondSignal _MePlug.WriteCondition
  Threadwait _MePlug.WriteThreadID   : _MePlug.WriteThreadID=NULL
  CondDestroy _MePlug.WriteCondition : _MePlug.WriteCondition=NULL
  MutexDestroy _MePlug.WriteMutex    : _MePlug.WriteMutex=NULL

  _MePlug.FillEnd=true
  CondSignal _MePlug.FillCondition
  Threadwait _MePlug.FillThreadID    : _MePlug.FillThreadID=NULL
  CondDestroy _MePlug.FillCondition  : _MePlug.FillCondition=NULL
  MutexDestroy _MePlug.FillMutex     : _MePlug.FillMutex=NULL

  dprint("mm: plug_stop~")
  return true
end function

function plug_exit() as boolean export
  dim as integer i,ret
  dprint("mm: plug_exit()")
  if _MePlug.hDevice=0 then
    _MePlug.LastError="mm: plug_exit() warning no open device."
    dprint(_MePlug.LastError)
    return true
  end if

  if (_MePlug.WriteThreadID<>NULL) and (_MePlug.FillThreadID<>NULL) then
    ret=plug_stop()
    sleep(300,1)
  end if  
  
  ret=waveOutReset(_MePlug.hDevice)
  if ret<>0 then
    dprint("mm: plug_exit() error:waveOutReset() = " + str(ret) )
  end if
  sleep(500,1)

  for i=0 to _MePlug.Plug.nBuffers-1
    if _MePlug.hdrs(i).lpData<>NULL then
      ret=waveOutUnPrepareHeader(_MePlug.hDevice,@_MePlug.hdrs(i),sizeof(WAVEHDR))
      if ret<>0 then
        dprint("mm: plug_exit() error:waveOutUnPrepareHeader("+str(i)+ ")=" +str (ret) )
      end if
    end if
  next

  for i=0 to _MePlug.Plug.nBuffers-1
    if _MePlug.hdrs(i).lpData<>NULL then
      deallocate _MePlug.hdrs(i).lpData
      _MePlug.hdrs(i).lpData=NULL
    end if
  next

  ret=waveOutClose(_MePlug.hDevice)
  if ret<>0 then
    dprint("mm: plug_exit() error:waveOutClose")
  end if

  _MePlug.hDevice=0
  dprint("mm: plug_exit~")
  return true
end function

private _
sub setWaveFormatex(byref wf        as WAVEFORMATEX, _
                    byval nRate     as integer, _
                    byval nBits     as integer, _
                    byval nChannels as integer)
  with wf
   .wFormatTag      = WAVE_FORMAT_PCM
   .nChannels       = nChannels
   .nSamplesPerSec  = nRate
   .wBitsPerSample  = nBits
   .nBlockAlign     = (nBits\8) * nChannels
   .nAvgBytesPerSec = (nBits\8) * nChannels * nRate
   .cbSize          = 0
  end with
end sub

private _
function MMInit(byref hDevice   as HWAVEOUT, _
                byval nRate     as integer, _
                byval nBits     as integer, _
                byval nChannels as integer, _
                byref wfex      as WAVEFORMATEX, _
                byref index     as integer) as boolean

  dim as integer nDevices,i,flag,ret
  dprint("mm: MMInit()")
  nDevices=waveOutGetNumDevs()
  if nDevices<1     then return false
  setWaveFormatex wfex,nRate,nBits,nChannels
  if index<-1 then
    index=-1
  elseif index>=nDevices then
    index=nDevices-1
  end if
  
  flag=index
  
  if flag=-1 then
    for i=0 to nDevices-1
      ret=waveOutOpen(NULL,i,@wfex,0,0,WAVE_FORMAT_DIRECT_QUERY)
      if ret=0 then flag=i:exit for
    next
  else
    ret=waveOutOpen(NULL,index,@wfex,0,0,WAVE_FORMAT_DIRECT_QUERY)
    if ret=0 then flag=index else flag=-1
  end if
  
  if flag>-1 then
    ret=waveOutOpen(@hDevice, flag, @wfex, cast(DWORD_PTR,@waveOutProc),0,CALLBACK_FUNCTION)
    if ret=0 then
      _MePlug.Plug.DeviceName=GetDeviceName(flag)
      return true
    else
     dprint("mm: MMInit() open error=" & ret)   
    end if
  end if
  return false
end function

function plug_init(byref Plug as FBS_PLUG) as boolean export
  dim as integer ret,Value,nFrames,i
  dim as WAVEFORMATEX mmf
  dim as boolean found
  dprint("mm: plug_init()")
  ' !!! fix it !!!!
  If _MePlug.hDevice<>0 Then
    _MePlug.LastError = "mm: plug_init(): device is open!"
    dprint(_MePlug.LastError)
    Return False
  End If

  Plug.fmt.nBits\=8
  Plug.fmt.nBits*=8
  If Plug.fmt.nRate    < 6000 Then Plug.fmt.nRate    = 6000
  If Plug.fmt.nRate    >96000 Then Plug.fmt.nRate    =96000
  If Plug.fmt.nBits    <   16 Then Plug.fmt.nbits    =   16
  If Plug.fmt.nBits    >   16 Then Plug.fmt.nbits    =   16
  If Plug.fmt.nChannels<    1 Then Plug.fmt.nChannels=    1
  If Plug.fmt.nChannels>    2 Then Plug.fmt.nChannels=    2

  'try user or default settings
  found=MMInit(_MePlug.hDevice,Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,mmf,Plug.DeviceIndex)

  ' stereo are a good choice
  If found=False Then found=MMInit(_MePlug.hDevice,44100,16,2,mmf,Plug.DeviceIndex)
  If found=False Then found=MMInit(_MePlug.hDevice,22050,16,2,mmf,Plug.DeviceIndex)
  If found=False Then found=MMInit(_MePlug.hDevice,11025,16,2,mmf,Plug.DeviceIndex)
  ' faster 8bit stereo better than 11KHz. 16bit stereo.
  If found=False Then found=MMInit(_MePlug.hDevice,44100,16,1,mmf,Plug.DeviceIndex)
  If found=False Then found=MMInit(_MePlug.hDevice,22050,16,1,mmf,Plug.DeviceIndex)
  If found=False Then found=MMInit(_MePlug.hDevice,11025,16,1,mmf,Plug.DeviceIndex)

  If found = False Then
    _MePlug.LastError="mm: plug_init() error: can't setup any device!"
    dprint(_MePlug.LastError)
    Return False
  End If

  Plug.fmt.nRate     =mmf.nSamplesPerSec
  Plug.fmt.nBits     =mmf.wBitsPerSample
  Plug.fmt.nChannels =mmf.nChannels
  Plug.fmt.signed    =True

  'now device is open with an usable format
  _MePlug.Plug.Fmt.nRate    =Plug.fmt.nRate
  _MePlug.Plug.Fmt.nBits    =Plug.fmt.nBits
  _MePlug.Plug.Fmt.nChannels=Plug.fmt.nChannels
  _MePlug.Plug.Fmt.Signed   =Plug.fmt.Signed

  If Plug.nBuffers<3  Then Plug.nBuffers=3
  if Plug.nBuffers>max_buffers_mm then Plug.nBuffers=max_buffers_mm
  _MePlug.Plug.nBuffers=Plug.nBuffers
  if Plug.nFrames<min_frames_mm then Plug.nFrames=min_frames_mm

  Plug.DeviceName=_MePlug.Plug.DeviceName
  'dprint("device:" & plug.DeviceName)

  Plug.Framesize=(_MePlug.Plug.Fmt.nBits\8)*_MePlug.Plug.Fmt.nChannels
  Plug.Buffersize=Plug.nFrames*Plug.Framesize

  _MePlug.Plug.nFrames   =Plug.nFrames
  _MePlug.Plug.Framesize =Plug.Framesize
  _MePlug.Plug.Buffersize=Plug.Buffersize

  for i=0 to _MePlug.Plug.nBuffers-1
    _MePlug.hdrs(i).lpData  =callocate(_MePlug.Plug.Buffersize)
    _MePlug.hdrs(i).dwBufferLength  =_MePlug.Plug.Buffersize
    _MePlug.hdrs(i).dwLoops   =0
    _MePlug.hdrs(i).dwFlags   =0
    _MePlug.hdrs(i).dwUser=0
    ret=waveOutPrepareHeader(_MePlug.hDevice,@_MePlug.hdrs(i),sizeof(WAVEHDR))
    if ret <> 0 then
      dprint("mm: plug_init() error: prepareHeader = " & ret)
      exit for
    end if
    _MePlug.hdrs(i).dwFlags=_MePlug.hdrs(i).dwFlags or 1
  next

  if ret<>0 then
    waveOutReset(_MePlug.hDevice)  
    sleep(1000,1) 
    for i=0 to _MePlug.Plug.nBuffers-1
      if _MePlug.hdrs(i).lpData<>NULL then 
        if (_MePlug.hdrs(i).dwFlags and 1)=1 then
          ret=waveOutUnPrepareHeader(_MePlug.hDevice,@_MePlug.hdrs(i),sizeof(WAVEHDR))
          if ret<>0 then
            dprint("mm: plug_init() unprepare = " & ret)
          end if
        end if
        deallocate _MePlug.hdrs(i).lpData
        _MePlug.hdrs(i).lpData=NULL
      end if
    next  
    waveOutClose _MePlug.hDevice
    _MePlug.LastError="mm: plug_init() error: prepare headers!"
    dprint(_MePlug.LastError)
    return false
  end if
      
  _MePlug.Plug.FillBuffer=Plug.FillBuffer
  dprint("mm: plug_init~")
  
  return true ' i like it
  
end function

#if __FB_OUT_DLL__ = 0
private _
function plug_filler_mm cdecl( byref p as FBS_PLUG ) as boolean
	dprint( __FUNCTION__ )
	p.plug_init  = procptr(plug_init)
	p.plug_start = procptr(plug_start)
	p.plug_stop  = procptr(plug_stop)
	p.plug_exit  = procptr(plug_exit)
    p.plug_error = procptr(plug_error)
    return true
end function

public _
sub ctor_plug_mm_init cdecl () FBS_MODULE_REGISTER_CDTOR
	static ctx as fbsound.cdtor.cdtor_struct = _
		( _
			procptr(_plug_mm_init), _
			procptr(_plug_mm_exit), _
			@"plug_mm", _
			fbsound.cdtor.MODULE_PLUGIN1, _
			procptr(plug_filler_mm) _
		)
	dprint( __FUNCTION__ )
	fbsound.cdtor.register( @ctx )
end sub
#endif

#if __FB_OUT_DLL__ = 0
end namespace ' fbsound.plug_mm
#endif

#endif ' NO_PLUG_MM
