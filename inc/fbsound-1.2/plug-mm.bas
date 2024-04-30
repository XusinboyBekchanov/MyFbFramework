'  ###############
' # plug-mm.bas #
'###############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "../inc/plug.bi"

#ifndef NO_PLUG_MM

#include once "../inc/plug-mm.bi"

#define max_buffers 512
#define min_frames   64

type MM
  as FBS_PLUG        Plug
  as HWAVEOUT        hDevice
  as zstring * 128   LastError
  as WAVEHDR         Hdrs(max_buffers-1) 
  as any ptr         FillThreadID ,FillCondition,FillMutex
  as any ptr         WriteThreadID,WriteCondition,WriteMutex
  as boolean         FillEnd,WriteEnd
end type

dim shared _Me as MM

sub _plug_mm_init() constructor
  dprint("_plug_mm_init() constructor")
  _Me.Plug.Plugname="mm"
end sub

sub _plug_mm_exit() destructor
  dprint("_plug_mm_exit() destructor")
end sub

private _
function CreateTimeStamp() as integer
  static as integer id
  id+=1:return id
end function

private _
function GetNumOfFreeBuffers() as integer
  dim as integer i,c  
  if _Me.plug.nBuffers<1 then 
    dprint("mm: GetNumOfFreeBuffers nBuffers<1")
    return 0
  end if
  for i=0 to _Me.plug.nBuffers-1
    if (_Me.hdrs(i).dwFlags and 1)=1 and _
       (_Me.hdrs(i).dwUser=0) then c+=1
  next
  return c
end function

private _
function GetNextFreeBufferIndex() as integer
  dim as integer i,c=-1 
  if _Me.plug.nBuffers<1 then 
    dprint("mm: GetNextFreeBufferIndex nBuffers<1")
    return c
  end if

  for i=0 to _Me.plug.nBuffers-1
    ' is done ?  
    if (_Me.hdrs(i).dwFlags and 1)=1 and (_Me.hdrs(i).dwUser=0) then c=i
    if c>-1 then exit for
  next
  return c
end function

private _
function GetNumOfWaitingBuffers() as integer
  dim as integer i,c
  if _Me.plug.nBuffers <1 then 
    dprint("mm: GetNumOfWaitingBuffers nBuffers<1")
    return 0
  end if
  for i=0 to _Me.plug.nBuffers-1
    if (_Me.hdrs(i).dwFlags and 1)=1 and (_Me.hdrs(i).dwUser>0) then c+=1
  next
  return c
end function

private _
function GetNextWaitingBuffer() as integer
  dim as integer i,Timestamp=&H7FFFFFFF,c=-1 
  if _Me.plug.nBuffers <1 then 
    dprint("mm: GetNextWaitingBuffer nBuffers<1")
    return c
  end if
  for i=0 to _Me.plug.nBuffers-1
    if (_Me.hdrs(i).dwFlags and 1)=1 and (_Me.hdrs(i).dwUser>0) then
      if (_Me.hdrs(i).dwUser<Timestamp) then 
         Timestamp=_Me.hdrs(i).dwUser
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
    if (_Me.FillCondition<>0) then 
      if (_Me.FillEnd=false) andalso (_Me.WriteEnd=false) then
        CondSignal(_Me.FillCondition)
      end if  
    elseif (_Me.WriteEnd=false) andalso (_Me.FillEnd=false) then
      dprint("mm: warning: waveOutProc() FillCondition=NULL") 
    end if 
  end if
end sub

private _
sub WriteThread(byval unused as any ptr)
  dim as integer ret,i,j
  dprint("mm: WriteThread()")
  
  _Me.WriteEnd=false
  
  while (_Me.WriteEnd=false)
  
    if (_Me.WriteMutex<>0) then
      
      if (_Me.WriteCondition<>0) then
        
        MutexLock(_Me.WriteMutex)
          CondWait(_Me.WriteCondition,_Me.WriteMutex)
        MutexUnLock(_Me.WriteMutex)
        
        while GetNumofWaitingBuffers()>0 andalso (_Me.WriteEnd=false)
          i=GetNextWaitingBuffer()
          if (i>-1) then
            do  
              ret=waveOutWrite(_Me.hDevice,@_Me.hdrs(i),sizeof(WAVEHDR))
            loop while (ret=33) and (_Me.WriteEnd=0)
            if (ret<>0) then 
              dprint("mm: WriteThread waveOutWrite(" + str(i) + ")=" + str(ret) )
            else
             _Me.hdrs(i).dwUser=0
            end if    
          else
            dprint("mm: WriteThread GetNextWaitingBuffer()=-1")
          end if
        wend
      else
        dprint("mm: WriteThread: warning: WriteCondition=NULL")
      end if '(_Me.WriteCondition<>0)
    else
      dprint("mm: WriteThread: warning: WriteMutex=NULL")
    end if ' (_Me.WriteMutex<>0) 
  wend
  dprint("mm: writethread~")
end sub

private _
sub FillThread(byval unused as any ptr)
  dim as integer i
  dim as any ptr lpArg = @_Me.Plug
  dprint("mm: FillThread()")
  
  _Me.FillEnd=false
  
  _Me.Plug.FillBuffer(lpArg)
  
  while (_Me.FillEnd=false)
  
    while (GetNumOfFreeBuffers()>0) andalso (_Me.FillEnd=false)
      i=GetNextFreeBufferIndex()
      if i>-1 then
        _Me.Plug.lpCurentBuffer=_Me.hdrs(i).lpData
        _Me.Plug.FillBuffer(lpArg)
        _Me.hdrs(i).dwUser = CreateTimeStamp()
        CondSignal(_Me.WriteCondition)
      else
        dprint("mm: FillThread: GetFreeBuffer()=-1")
      end if
    wend
    
    MutexLock(_Me.FillMutex)
      CondWait(_Me.FillCondition,_Me.FillMutex)
    MutexUnlock(_Me.FillMutex)
    
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
  tmp=_Me.LastError
  return tmp
end function

function plug_isany(byref Plug as FBS_PLUG) as boolean export
  dim as integer ret,nDevices,i,j,tmp
  dprint("mm: plug_isany")
  Plug.Plugname=_Me.Plug.Plugname
  _Me.Plug.DeviceName=""
  nDevices=NumOfDeviceNames()
  if nDevices<1 then 
    _Me.LastError="mm: plug_isany error no devices!"
    dprint(_Me.LastError)
    return false
  end if  
  return true
end function

function plug_start() as boolean export
  dprint("mm: plug_start()")  
  if _Me.hDevice=0 then 
    _Me.LastError="mm: start error no device!"
    dprint(_Me.LastError)
    return false
  end if
  ' plug is running
  if (_Me.WriteThreadID<>NULL) and (_Me.FillThreadID<>NULL) then 
    _Me.LastError="mm: plug_start() warniung thread's are running."
    dprint(_Me.LastError)
    return false
  end if
  _Me.WriteCondition = CondCreate()
  _Me.WriteMutex     = MutexCreate()
  _Me.WriteEnd       = true
  _Me.WriteThreadID  = ThreadCreate(@WriteThread)
  while _Me.WriteEnd = true  : sleep(10,1): wend
  _Me.FillCondition  = CondCreate()
  _Me.FillMutex      = MutexCreate()
  _Me.FillEnd        = true
  _Me.FillThreadID   = ThreadCreate(@FillThread)
  while _Me.FillEnd  = true : sleep(10,1):wend
  return true
end function

function plug_stop() as boolean export
  dprint("mm: plug_stop()")
  if _Me.hDevice=0 then 
    _Me.LastError="mm: stop warning no open device."
    dprint(_Me.LastError)
  end if

  if (_Me.WriteThreadID=NULL) andalso (_Me.FillThreadID=NULL) then 
    _Me.LastError="mm: plug_stop() warning no running threads."
    dprint(_Me.LastError)
    return true
  end if

  _Me.WriteEnd=true
  CondSignal _Me.WriteCondition
  Threadwait _Me.WriteThreadID   : _Me.WriteThreadID=NULL
  CondDestroy _Me.WriteCondition : _Me.WriteCondition=NULL
  MutexDestroy _Me.WriteMutex    : _Me.WriteMutex=NULL

  _Me.FillEnd=true
  CondSignal _Me.FillCondition
  Threadwait _Me.FillThreadID    : _Me.FillThreadID=NULL
  CondDestroy _Me.FillCondition  : _Me.FillCondition=NULL
  MutexDestroy _Me.FillMutex     : _Me.FillMutex=NULL

  dprint("mm: plug_stop~")
  return true
end function

function plug_exit() as boolean export
  dim as integer i,ret
  dprint("mm: plug_exit()")
  if _Me.hDevice=0 then
    _Me.LastError="mm: plug_exit() warning no open device."
    dprint(_Me.LastError)
    return true
  end if

  if (_Me.WriteThreadID<>NULL) and (_Me.FillThreadID<>NULL) then
    ret=plug_stop()
    sleep(300,1)
  end if  
  
  ret=waveOutReset(_Me.hDevice)
  if ret<>0 then
    dprint("mm: plug_exit() error:waveOutReset() = " + str(ret) )
  end if
  sleep(500,1)

  for i=0 to _Me.Plug.nBuffers-1
    if _Me.hdrs(i).lpData<>NULL then
      ret=waveOutUnPrepareHeader(_Me.hDevice,@_Me.hdrs(i),sizeof(WAVEHDR))
      if ret<>0 then
        dprint("mm: plug_exit() error:waveOutUnPrepareHeader("+str(i)+ ")=" +str (ret) )
      end if
    end if
  next

  for i=0 to _Me.Plug.nBuffers-1
    if _Me.hdrs(i).lpData<>NULL then
      deallocate _Me.hdrs(i).lpData
      _Me.hdrs(i).lpData=NULL
    end if
  next

  ret=waveOutClose(_Me.hDevice)
  if ret<>0 then
    dprint("mm: plug_exit() error:waveOutClose")
  end if

  _Me.hDevice=0
  dprint("mm: plug_exit~")
  return true
end function

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
      _Me.Plug.DeviceName=GetDeviceName(flag)
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
  if _Me.hDevice<>0 then
    _Me.LastError = "mm: plug_init(): device is open!"
    dprint(_Me.LastError)
    return false
  end if

  Plug.fmt.nBits\=8
  Plug.fmt.nBits*=8
  if Plug.fmt.nRate    < 6000 then Plug.fmt.nRate    = 6000
  if Plug.fmt.nRate    >96000 then Plug.fmt.nRate    =96000
  if Plug.fmt.nBits    <   16 then Plug.fmt.nbits    =   16
  if Plug.fmt.nBits    >   16 then Plug.fmt.nbits    =   16
  if Plug.fmt.nChannels<    1 then Plug.fmt.nChannels=    1
  if Plug.fmt.nChannels>    2 then Plug.fmt.nChannels=    2

  'try user or default settings
  found=MMInit(_Me.hDevice,Plug.fmt.nRate,Plug.fmt.nBits,Plug.fmt.nChannels,mmf,Plug.DeviceIndex)

  ' stereo are a good choice
  if found=false then found=MMInit(_Me.hDevice,44100,16,2,mmf,Plug.DeviceIndex)
  if found=false then found=MMInit(_Me.hDevice,22050,16,2,mmf,Plug.DeviceIndex)
  if found=false then found=MMInit(_Me.hDevice,11025,16,2,mmf,Plug.DeviceIndex)
  ' faster 8bit stereo better than 11KHz. 16bit stereo.
  if found=false then found=MMInit(_Me.hDevice,44100,16,1,mmf,Plug.DeviceIndex)
  if found=false then found=MMInit(_Me.hDevice,22050,16,1,mmf,Plug.DeviceIndex)
  if found=false then found=MMInit(_Me.hDevice,11025,16,1,mmf,Plug.DeviceIndex)

  if found = false then
    _Me.LastError="mm: plug_init() error: can't setup any device!"
    dprint(_Me.LastError)
    return false
  end if

  Plug.fmt.nRate     =mmf.nSamplesPerSec
  Plug.fmt.nBits     =mmf.wBitsPerSample
  Plug.fmt.nChannels =mmf.nChannels
  Plug.fmt.signed    =true

  'now device is open with an usable format
  _Me.Plug.Fmt.nRate    =Plug.fmt.nRate
  _Me.Plug.Fmt.nBits    =Plug.fmt.nBits
  _Me.Plug.Fmt.nChannels=Plug.fmt.nChannels
  _Me.Plug.Fmt.Signed   =Plug.fmt.Signed

  if Plug.nBuffers<3  then Plug.nBuffers=3
  if Plug.nBuffers>max_buffers then Plug.nBuffers=max_buffers
  _Me.Plug.nBuffers=Plug.nBuffers
  if Plug.nFrames<min_frames then Plug.nFrames=min_frames

  Plug.DeviceName=_Me.Plug.DeviceName
  'dprint("device:" & plug.DeviceName)

  Plug.Framesize=(_Me.Plug.Fmt.nBits\8)*_Me.Plug.Fmt.nChannels
  Plug.Buffersize=Plug.nFrames*Plug.Framesize

  _Me.Plug.nFrames   =Plug.nFrames
  _Me.Plug.Framesize =Plug.Framesize
  _Me.Plug.Buffersize=Plug.Buffersize

  for i=0 to _Me.Plug.nBuffers-1
    _Me.hdrs(i).lpData  =callocate(_Me.Plug.Buffersize)
    _Me.hdrs(i).dwBufferLength  =_Me.Plug.Buffersize
    _Me.hdrs(i).dwLoops   =0
    _Me.hdrs(i).dwFlags   =0
    _Me.hdrs(i).dwUser=0
    ret=waveOutPrepareHeader(_Me.hDevice,@_Me.hdrs(i),sizeof(WAVEHDR))
    if ret <> 0 then
      dprint("mm: plug_init() error: prepareHeader = " & ret)
      exit for
    end if
    _Me.hdrs(i).dwFlags=_Me.hdrs(i).dwFlags or 1
  next

  if ret<>0 then
    waveOutReset(_Me.hDevice)  
    sleep(1000,1) 
    for i=0 to _Me.Plug.nBuffers-1
      if _Me.hdrs(i).lpData<>NULL then 
        if (_Me.hdrs(i).dwFlags and 1)=1 then
          ret=waveOutUnPrepareHeader(_Me.hDevice,@_Me.hdrs(i),sizeof(WAVEHDR))
          if ret<>0 then
            dprint("mm: plug_init() unprepare = " & ret)
          end if
        end if
        deallocate _Me.hdrs(i).lpData
        _Me.hdrs(i).lpData=NULL
      end if
    next  
    waveOutClose _Me.hDevice
    _Me.LastError="mm: plug_init() error: prepare headers!"
    dprint(_Me.LastError)
    return false
  end if
      
  _Me.Plug.FillBuffer=Plug.FillBuffer
  dprint("mm: plug_init~")
  
  return true ' i like it
  
end function

#endif ' NO_PLUG_MM
