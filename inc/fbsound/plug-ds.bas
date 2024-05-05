'  ###############
' # plug-ds.bas #
'###############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"

#ifndef NO_PLUG_DS

#include once "fbsound/plug.bi"
#include once "fbsound/plug-static.bi"
#include once "fbsound/plug-ds.bi"

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_ds
	extern "c"
		extern required as long
		dim shared required as long
	end extern
end namespace
#endif

#if __FB_OUT_DLL__ = 0
namespace fbsound.plug_ds
#endif

' GUID helper
function Guid2String(byval pGuid as LPGUID) as string
  if pGuid=0 then return "00000000-0000-0000-0000000000000000"
  dim as string tmp = hex(pGuid->Data1,8) & "-" & _
                      hex(pGuid->Data2,4) & "-" & _
                      hex(pGuid->Data3,4) & "-"
  for i as integer=0 to 7
     tmp &= hex(pGuid->Data4(i),2)
  next
  return tmp
end function

' WAVEFORMATEX helper
private _
sub setWaveFormatEx(byref wf        as WAVEFORMATEX, _
                    byval nRate     as integer     , _
                    byval nBits     as integer     , _
                    byval nChannels as integer)

  if nChannels<2 then nChannels=1 else nChannels=2
  wf.wFormatTag     = WAVE_FORMAT_PCM
  wf.nChannels      = nChannels
  wf.nSamplesPerSec = nRate
  wf.wBitsPerSample = nBits
  wf.nBlockAlign    = (nBits\8)*nChannels
  wf.nAvgBytesPerSec=wf.nSamplesPerSec*wf.nBlockAlign
  wf.cbSize         =0
end sub

type DS_DEVICE_DESCRIPTOR
  public:
  declare destructor
  declare constructor(byval pGuid        as LPGUID, _
                      byval pDescription as LPCSTR, _
                      byval pModule      as LPCSTR)
  declare operator cast as string
  declare function getGuid as LPGUID
  declare function getDescription as zstring ptr
  'private:
  as LPGUID m_pGuid
  as LPSTR m_pDescription
  as LPSTR m_pModule
end type
type PDS_DEVICE_DESCRIPTOR as DS_DEVICE_DESCRIPTOR ptr

destructor DS_DEVICE_DESCRIPTOR
  dprint("ds: DS_DEVICE_DESCRIPTOR~")
  if m_pGuid then 
    delete m_pGuid
    m_pGuid=0
  end if
  if m_pDescription then
    delete[] m_pDescription
    m_pDescription=0
  end if
  if m_pModule then
    delete[] m_pModule
    m_pModule=0
  end if
end destructor

constructor DS_DEVICE_DESCRIPTOR(byval pGuid        as LPGUID, _ 
                                 byval pDescription as LPCSTR, _
                                 byval pModule      as LPCSTR)
  dprint("ds: DS_DEVICE_DESCRIPTOR()")
  if (pGuid<>0) then
    m_pGuid=new GUID
    *m_pGUID=*pGuid
  end if
  if (pDescription<>NULL) then
    dim as integer nChars=len(*pDescription)+1
    m_pDescription=new ubyte[nChars]
    *m_pDescription=*pDescription
  end if
  if (pModule<>NULL) then
    dim as integer nChars=len(*pModule)+1
    m_pModule=new ubyte[nChars]
    *m_pModule=*pModule
  end if
end constructor

operator DS_DEVICE_DESCRIPTOR.cast as string
  dim as string tmp = Guid2String(m_pGuid) & " " & *m_pDescription
  operator = tmp
end operator

function DS_DEVICE_DESCRIPTOR.getGuid as LPGUID
  return m_pGuid
end function

function DS_DEVICE_DESCRIPTOR.getDescription as zstring ptr
  return m_pDescription
end function


type DS_DEVICE_LIST
  declare destructor
  as integer                   nDevices
  as PDS_DEVICE_DESCRIPTOR ptr  pDevices
end type
type PDS_DEVICE_LIST as DS_DEVICE_LIST ptr

destructor DS_DEVICE_LIST
  if (pDevices<>NULL) then
    if nDevices>0 then
      for i as integer=0 to nDevices-1
        if (pDevices[i]<>NULL) then
          delete pDevices[i]
          pDevices[i]=0
        end if
      next
      nDevices=0
    end if
    deallocate pDevices
    pDevices=0
  end if
  dprint("ds: DS_DEVICE_LIST~")
end destructor


function DSDeviceEnumCB(byval pGuid        as LPGUID, _
                        byval pDescription as LPCSTR, _
                        byval pModule      as LPCSTR, _
                        byval pUserdata    as LPVOID) as BOOL
  dim as DS_DEVICE_LIST ptr pList=cptr(DS_DEVICE_LIST ptr,pUserdata)
  if (pList=NULL) then 
    dprint("ds: DSDeviceEnumCB error: pList=NULL !")
    return 0 ' interrupt enumeration
  end if
  ' the first primary (default) device does not have a GUID 
  ' (ignore it here it will be two times in the list)
  if pGUID=0 then return 1 ' get next device
  ' be sure it's not an emulated DirectSound device
  ' it's better to use the MM AudioDevice directly as an emulated DirectSound device
  dim as LPDIRECTSOUND ds
  ' create the device interface if bussy try next device
  if (DirectSoundCreate(pGuid,@ds,NULL)<>DS_OK) then return 1
  dim as integer AddDeviceToList=0
  ' get device caps
  dim as DSCAPS caps
  caps.dwSize=sizeof(DSCAPS)
  if IDirectSound_GetCaps(ds,@caps)=DS_OK then
    ' not an emulated MM device ?
    if (caps.dwFlags and DSCAPS_EMULDRIVER)=0 then 
      ' 16 bit primary sound buffer ?
      if (caps.dwFlags and DSCAPS_PRIMARY16BIT) then
        ' stereo primary sound buffer ?
        if (caps.dwFlags and DSCAPS_PRIMARYSTEREO) then
          var hWin = GetForegroundWindow()
          if (hWin = 0) then hWin = GetDesktopWindow()
          if (IDirectSound_SetCooperativeLevel(ds,hWin,DSSCL_PRIORITY)=DS_OK) then
            AddDeviceToList=1
          end if         
        end if
      end if
    end if
  end if
  
  ' free the interface
  IDirectSound_Release(ds)
  if AddDeviceToList<>0 then
    ' allocate new item in list
    pList->pDevices=reallocate(pList->pDevices,sizeof(PDS_DEVICE_DESCRIPTOR)*(pList->nDevices+1))
    pList->pDevices[pList->nDevices]=new DS_DEVICE_DESCRIPTOR(pGuid,pDescription,pModule)
    pList->nDevices+=1
  end if
  return 1 ' allow next device enumeration
end function


#define max_buffers 64
#define min_frames  512

type DS
  as FBS_PLUG        Plug
  as zstring * 128   LastError
  as any ptr         FillThreadID
  as boolean         FillEnd
#if 0
  as any ptr         FillCondition,FillMutex
  as any ptr         WriteThreadID,WriteCondition,WriteMutex
  as integer         FillEnd,WriteEnd
#endif
  as DS_DEVICE_LIST      DeviceList
  as LPDIRECTSOUND       pDirectSound

  as LPDIRECTSOUNDBUFFER pPrimaryBuffer
  as DSBUFFERDESC        PrimaryBufferDesc
  as DSBCAPS             PrimaryCaps
  as WAVEFORMATEX        PrimaryWaveFormat

  as LPDIRECTSOUNDBUFFER pSecondaryBuffer
  as DSBCAPS             SecondaryCaps
  as DSBUFFERDESC        SecondaryBufferDesc
  as WAVEFORMATEX        SecondaryWaveFormat

  as LPDIRECTSOUNDNOTIFY pSoundNotify
  as LPDSBPOSITIONNOTIFY pPositionNotify
  as LPHANDLE            phEvents

  as integer             nRate
  as integer             nBits
  as integer             nChannels
  as integer             nBuffers
  as integer             nFrames
  as integer             nFramesize
  as integer             Playing
  as integer             Locked
end type

dim shared as DS _Me

FBS_MODULE_CDTOR_SCOPE _
sub _plug_ds_init cdecl () FBS_MODULE_CTOR
  dprint("ds: plug_ds_init() module constructor")
  dprint("ds: CoInitialize()")
  ' Initialize COM
  CoInitialize(NULL)
  _Me.Plug.Plugname="DirectSound"
end sub

FBS_MODULE_CDTOR_SCOPE _
sub _plug_ds_exit cdecl () FBS_MODULE_DTOR
  ' Uninitialize COM
  'dprint("ds: CoUninitialize()")
  'CoUninitialize()
  dprint("ds: plug_ds_exit() module destructor")
  #ifdef DEBUG
  sleep 2000
  #endif
end sub

private _
sub FillThread(byval unused as any ptr)
  dim as integer i
  dim as any ptr lpArg
  dprint("ds: FillThread()")
  dim as ubyte ptr pBuffer=new ubyte[_Me.Plug.Buffersize]
  
  _Me.Plug.lpCurentBuffer=pBuffer
  lpArg=@_Me.Plug
  _Me.FillEnd = false          ' signal thread loop
  _Me.Plug.FillBuffer(lpArg) ' get first buffer
  
  while _Me.FillEnd=false
    dim as DWORD ret = MsgWaitForMultipleObjects(_Me.nBuffers,_Me.pHEvents,0,INFINITE,QS_POSTMESSAGE)
    if (ret<>WAIT_TIMEOUT) andalso (_Me.FillEnd=false) then
      dim as integer BufferIndex=(ret+1) mod _Me.Plug.nBuffers
      dim as integer position=BufferIndex*_Me.Plug.Buffersize
      dim as ubyte ptr pAudio1,pAudio2
      dim as ulong nSize1,nSize2
      dim as boolean IsLocked
      dim as HRESULT LockRet=IDirectSoundBuffer_Lock(_Me.pSecondaryBuffer,position,_Me.Plug.Buffersize,@pAudio1,@nSize1,@pAudio2,@nSize2,0)
      if LockRet=DSERR_BUFFERLOST then
        dprint("ds: warning: secondary IDirectSoundBuffer_Lock() DSERR_BUFFERLOST !")
        if IDirectSoundBuffer_Restore(_Me.pSecondaryBuffer)=DS_OK then
          if IDirectSoundBuffer_Lock(_Me.pSecondaryBuffer,position,_Me.Plug.Buffersize,@pAudio1,@nSize1,@pAudio2,@nSize2,0)=DS_OK then
            IsLocked=true
          else
            dprint("ds: error: secondary IDirectSoundBuffer_Lock()") 
          end if
 
        else
          dprint("ds: error: secondary IDirectSoundBuffer_Restore()")
        end if
      elseif LockRet=DS_OK then
        IsLocked=true
      end if
      if IsLocked then
        if pAudio1 then memcpy(pAudio1,_Me.Plug.lpCurentBuffer,nSize1)
        if pAudio2 then memcpy(pAudio2,_Me.Plug.lpCurentBuffer+nSize1,nSize2)
        IDirectSoundBuffer_Unlock(_Me.pSecondaryBuffer,pAudio1,nSize1,pAudio2,nSize2)
        IsLocked=false
        _Me.Plug.FillBuffer(lpArg)
      else
        dprint("ds: error: could not lock the buffer !")
      end if
    end if
  wend

  if pBuffer then delete [] pBuffer
  dprint("ds: FillThread~")
end sub

function plug_error() as string export
  dim tmp as string
  tmp=_Me.LastError
  return tmp
end function

function plug_isany(byref Plug as FBS_PLUG) as boolean export
  dprint("ds: plug_isany()")
  if _Me.DeviceList.nDevices>0 then 
    dprint("ds: warning: plug_isany called more than once !")
    return true
  end if
  Plug.Plugname=_Me.Plug.Plugname
  _Me.Plug.DeviceName=""

  ' get list of none emulated DirectSound devices
  DirectSoundEnumerate(@DSDeviceEnumCB,@_Me.DeviceList)

  if _Me.DeviceList.nDevices<1 then 
    _Me.LastError="ds: plug_isany error: DirectSoundEnumerate() no devices !"
    dprint(_Me.LastError)
    return false
  end if 
  return true
end function

function plug_start() as boolean export
  dprint("ds: plug_start()")
  if _Me.pDirectSound=NULL then
    _Me.LastError="ds: error: plug_start no device initialized !"
    dprint(_Me.LastError)
    return false
  end if
  ' plug is running
  if (_Me.FillThreadID<>NULL) then 
    _Me.LastError="ds: warning: plug_start thread's are running."
    dprint(_Me.LastError)
    return false
  end if

  _Me.FillEnd       = true
  _Me.FillThreadID  = ThreadCreate(@FillThread)
  while _Me.FillEnd = true : sleep(10,1) : wend
  
  if (IDirectSoundBuffer_Play(_Me.pSecondaryBuffer,0,0,DSBPLAY_LOOPING)=DS_OK) then
    dprint("ds: plug_start secondary IDirectSoundBuffer_Play() ok")
    dim as DWORD status
    if (IDirectSoundBuffer_GetStatus(_Me.pSecondaryBuffer,@status)=DS_OK) then
      dprint("ds: plug_start secondary IDirectSoundBuffer_GetStatus() ok")
      if ((status and DSBSTATUS_PLAYING)<>0) then 
        dprint("ds: plug_start secondary status = DSBSTATUS_PLAYING ok")
        return true
      else
        dprint("ds: plug_start error: secondary status <> DSBSTATUS_PLAYING")
      end if  
    end if
  else
    
  end if
  _Me.LastError="ds: plug_start error: secondary IDirectSoundBuffer_Play() !"
  dprint(_Me.LastError)
  return false
  dprint("ds: plug_start~")
end function

function plug_stop() as boolean export
  dprint("ds: plug_stop()")
  if _Me.pDirectSound=NULL then
    _Me.LastError="ds: plug_stop warning: no open device."
    dprint(_Me.LastError)
  end if

  if (_Me.FillThreadID=NULL) then 
    _Me.LastError="ds: plug_stop warning: no running threads."
    dprint(_Me.LastError)
    return true
  end if

  ' signal end of thread
  _Me.FillEnd = true
  Threadwait _Me.FillThreadID
  _Me.FillThreadID = NULL

  ' stop secondary buffers
  if _Me.pSecondaryBuffer<>NULL then
    dim as DWORD status
    if IDirectSoundBuffer_GetStatus(_Me.pSecondaryBuffer,@status)=DS_OK then
      if ((status and DSBSTATUS_PLAYING)<>0) then
        if IDirectSoundBuffer_Stop(_Me.pSecondaryBuffer)=DS_OK then
        else
          dprint("ds: plug_stop error: secondary IDirectSoundBuffer_Stop()")
        end if  
        sleep(300,1)
      end if
    else
      dprint("ds: plug_stop error: secondary IDirectSoundBuffer_GetStatus()")
    end if
  end if

  dprint("ds: plug_stop~")
  return true
end function

function plug_exit() as boolean export
  dim as integer i,ret
  dprint("ds: plug_exit()")

  if _Me.pDirectSound=NULL then
    _Me.LastError="ds: plug_exit warning: no open device."
    dprint(_Me.LastError)
    return true
  end if

  if (_Me.FillThreadID<>NULL) then
    ret=plug_stop()
  end if

  ' delete event handles
  if (_Me.phEvents<>NULL) then
    for i as integer=0 to _Me.nBuffers-1
      if _Me.phEvents[i]<>NULL then 
        CloseHandle(_Me.phEvents[i])
        _Me.phEvents[i]=NULL
      end if
    next
    delete[] _Me.phEvents
  end if


  ' free pPositionNotify
  if (_Me.pPositionNotify<>NULL) then
    delete [] _Me.pPositionNotify
    _Me.pPositionNotify=0
  end if  

  ' release sound notify
  if (_Me.pSoundNotify<>NULL) then
    if IDirectSoundNotify_Release(_Me.pSoundNotify)=DS_OK then

    else
      dprint("ds: plug_exit error: IDirectSoundNotify_Release(pSoundNotify)")
    endif
    _Me.pSoundNotify=0
  end if
  
  ' release secondary buffer
  if (_Me.pSecondaryBuffer<>NULL) then
    ' dprint("IDirectSoundBuffer_Release(pSecondaryBuffer)")
    if IDirectSoundBuffer_Release(_Me.pSecondaryBuffer)=DS_OK  then
      _Me.pSecondaryBuffer=0
    else
      dprint("ds: plug_exit error: secondary IDirectSoundBuffer_Release()")
    end if  
  end if

  ' release direct sound
  if IDirectSound_Release(_Me.pDirectSound)=DS_OK then
    _Me.pDirectSound=0
  else
    dprint("ds: plug_exit error: IDirectSound_Release()")
  end if  

  dprint("ds: plug_exit~")
  return true
end function


function plug_init(byref Plug as FBS_PLUG) as boolean export
  dprint("ds: plug_init")

  if (_Me.pDirectSound<>NULL) then
    _Me.LastError="ds: plug_init error: device is open!"
    dprint(_Me.LastError)
    return false
  end if

  if (_Me.DeviceList.nDevices<1) then
    _Me.LastError="ds: plug_init error: no devices !"
    dprint(_Me.LastError)
    return false
  end if

  if Plug.DeviceIndex<0 then
    Plug.DeviceIndex=0
  elseif Plug.DeviceIndex>=_Me.DeviceList.nDevices then
    dprint("ds: plug_init warning device index out of range.")
    Plug.DeviceIndex=Plug.DeviceIndex mod _Me.DeviceList.nDevices
  end if

  _Me.nRate     = Plug.fmt.nRate
  _Me.nBits     = Plug.fmt.nBits
  _Me.nChannels = Plug.fmt.nChannels
  _Me.nBuffers  = Plug.nBuffers
  _Me.nFrames   = Plug.nFrames


  if     _Me.nRate< 11026 then
    _Me.nRate=11025
  elseif _Me.nRate< 22051 then
    _Me.nRate=22050
  elseif _Me.nRate< 32001 then
    _Me.nRate=32000
  elseif _Me.nRate< 38001 then
    _Me.nRate=38000
  elseif _Me.nRate< 44101 then
    _Me.nRate=44100
  elseif _Me.nRate< 48001 then
    _Me.nRate=48000
  elseif _Me.nRate<100000 then
    _Me.nRate=96000
  else
    _Me.nRate=100000
  end if

  if     _Me.nBuffers< 3 then ' !!! was 2 !!!
    _Me.nBuffers=2
  elseif _Me.nBuffers>64 then
    _Me.nBuffers=64
  end if

  if     _Me.nFrames<  513 then
    _Me.nFrames=512
  elseif _Me.nFrames< 1025 then
    _Me.nFrames=1024
  elseif _Me.nFrames< 2049 then
    _Me.nFrames=2048
  elseif _Me.nFrames< 4097 then
    _Me.nFrames=4096
  elseif _Me.nFrames< 8193 then
    _Me.nFrames=8192
  elseif _Me.nFrames<16385 then
    _Me.nFrames=16384
  else
    _Me.nFrames=32768
  end if

  dim as boolean found = false
  ' create device
  if (DirectSoundCreate(_Me.DeviceList.pDevices[Plug.DeviceIndex]->getGuid(),@_Me.pDirectSound,NULL)=DS_OK) then
    var hWin = GetForegroundWindow()
    if (hWin = 0) then hWin = GetDesktopWindow()
       
    ' set cooperative level
    if (IDirectSound_SetCooperativeLevel(_Me.pDirectSound,hWin,DSSCL_PRIORITY)=DS_OK) then
      ' create primary sound buffer
      with _Me.PrimaryBufferDesc
        .dwSize       =sizeof(DSBUFFERDESC)
        .dwFlags      =DSBCAPS_PRIMARYBUFFER
        .dwBufferBytes=0
        .lpwfxFormat  =NULL
      end with
      if (IDirectSound_CreateSoundBuffer(_Me.pDirectSound,@_Me.PrimaryBufferDesc,@_Me.pPrimaryBuffer,NULL)=DS_OK) then
        ' get buffer caps
        _Me.PrimaryCaps.dwSize = sizeof(DSBCAPS) 
        if (IDirectSoundBuffer_GetCaps(_Me.pPrimaryBuffer,@_Me.PrimaryCaps)=DS_OK) then
          dim as integer hwbuffersize =  _Me.PrimaryCaps.dwBufferBytes
          dprint("ds: plug_init primary caps hw buffersize " & hwbuffersize)
          setWaveFormatEx(_Me.PrimaryWaveFormat,_Me.nRate,_Me.nBits,_Me.nChannels)
          ' create secondary sound buffer
          setWaveFormatEx(_Me.SecondaryWaveFormat,_Me.nRate,_Me.nBits,_Me.nChannels)
          with _Me.SecondaryBufferDesc
            .dwSize       =sizeof(DSBUFFERDESC)
            .dwFlags      =DSBCAPS_CTRLPOSITIONNOTIFY or DSBCAPS_GETCURRENTPOSITION2
            .dwBufferBytes=_Me.nBuffers*_Me.nFrames*4
            while .dwBufferBytes<hwbuffersize
             _Me.nFrames shl=1
             .dwBufferBytes=_Me.nBuffers*_Me.nFrames*4
            wend
            .lpwfxFormat  =@_Me.SecondaryWaveFormat
          end with
          if IDirectSoundBuffer_Release(_Me.pPrimaryBuffer)=DS_OK then
            _Me.pPrimaryBuffer=0
          else
            dprint("ds: plug_init error: primary IDirectSoundBuffer_Release()")
          end if
          if (IDirectSound_CreateSoundBuffer(_Me.pDirectSound,@_Me.SecondaryBufferDesc,@_Me.pSecondaryBuffer,NULL)=DS_OK) then
            ' get buffer caps
            _Me.SecondaryCaps.dwSize = sizeof(DSBCAPS) 
            if (IDirectSoundBuffer_GetCaps(_Me.pSecondaryBuffer,@_Me.SecondaryCaps)=DS_OK) then
              dim as integer swbuffersize=_Me.SecondaryCaps.dwBufferBytes
              dprint("ds: plug_init secondary caps sw buffersize " & swbuffersize)
              ' get curent format
              if IDirectSoundBuffer_GetFormat(_Me.pSecondaryBuffer,@_Me.SecondaryWaveFormat,sizeof(WAVEFORMATEX),NULL)=DS_OK then
                _Me.nRate      = _Me.SecondaryWaveFormat.nSamplesPerSec
                _Me.nBits      = _Me.SecondaryWaveFormat.wBitsPerSample 
                _Me.nChannels  = _Me.SecondaryWaveFormat.nChannels
                _Me.nFramesize = _Me.SecondaryWaveFormat.nBlockAlign
                _Me.nFrames    = swbuffersize\(_Me.nFramesize*_Me.nBuffers)
               
                if IDirectSoundBuffer_QueryInterface(_Me.pSecondaryBuffer,@IID_IDirectSoundNotify,@_Me.pSoundNotify)=S_OK then
                  _Me.phEvents = new HANDLE[_Me.nBuffers]
                  _Me.pPositionNotify = new DSBPOSITIONNOTIFY[_Me.nBuffers]
                  for i as integer=0 to _Me.nBuffers-1
                    _Me.phEvents[i]=CreateEvent(NULL,FALSE,FALSE,NULL)
                    _Me.pPositionNotify[i].dwOffset=i*_Me.nFrames*_Me.nFramesize
                    _Me.pPositionNotify[i].hEventNotify=_Me.phEvents[i]
                  next
                  if IDirectSoundNotify_SetNotificationPositions(_Me.pSoundNotify,_Me.nBuffers,_Me.pPositionNotify)=DS_OK then
                    found=true
                  else
                    dprint("da: plug_init error: IDirectSoundNotify_SetNotificationPositions()")
                  end if
                else
                  dprint("ds: plug_init error: secondary IDirectSoundBuffer_QueryInterface(IID_IDirectSoundNotify) ")  
                end if ' IID_IDirectSoundNotify
              else
                dprint("ds: plug_init error: secondary IDirectSoundBuffer_GetFormat()")  
              end if ' SecondaryWaveFormat
            else
              dprint("ds: plug_init error: secondary IDirectSoundBuffer_GetCaps()")  
            end if ' SecondaryCaps
          else  
             dprint("ds: plug_init error: secondary IDirectSound_CreateSoundBuffer()")
          end if ' pSecondaryBuffer
        else
          dprint("ds: plug_init error: primary IDirectSoundBuffer_GetCaps()")  
        end if ' PrimaryCaps
      else  
        dprint("ds: plug_init error: primary IDirectSound_CreateSoundBuffer()")
      end if ' pPrimaryBuffer
    end if ' DSSCL_PRIORITY
  else  
    dprint("ds: plug_init error: DirectSoundCreate()")  
  end if ' pDirectSound
  
  if found=false then
    _Me.LastError="ds: plug_init error: can't create device[" & Plug.DeviceIndex & !"]\n" & *_Me.DeviceList.pDevices[Plug.DeviceIndex]
    return false
  end if
  
  ' fill callers struct
  Plug.fmt.nRate     = _Me.nRate
  Plug.fmt.nBits     = _Me.nBits
  Plug.fmt.nChannels = _Me.nChannels
  Plug.fmt.signed    = true
  Plug.nBuffers      = _Me.nBuffers
  Plug.nFrames       = _Me.nFrames
  Plug.Framesize     = _Me.nFramesize
  Plug.Buffersize    = _Me.nFrames*_Me.nFramesize
  Plug.Plugname      = _Me.Plug.Plugname
  Plug.DeviceName    = *_Me.DeviceList.pDevices[Plug.DeviceIndex]->getDescription()
  ' fill own struct
  _Me.Plug.fmt.nRate     = _Me.nRate
  _Me.Plug.fmt.nBits     = _Me.nBits
  _Me.Plug.fmt.nChannels = _Me.nChannels
  _Me.Plug.fmt.signed    = true
  _Me.Plug.nBuffers      = _Me.nBuffers
  _Me.Plug.nFrames       = _Me.nFrames
  _Me.Plug.Framesize     = _Me.nFramesize
  _Me.Plug.Buffersize    = _Me.nFrames*_Me.nFramesize
  _Me.Plug.FillBuffer    = Plug.FillBuffer

  return true
  
end function

#if __FB_OUT_DLL__ = 0
private _
function plug_filler_ds cdecl( byref p as FBS_PLUG ) as boolean
	dprint( __FUNCTION__ )
	p.plug_init  = procptr(plug_init)
	p.plug_start = procptr(plug_start)
	p.plug_stop  = procptr(plug_stop)
	p.plug_exit  = procptr(plug_exit)
    p.plug_error = procptr(plug_error)
    return true
end function

public _
sub ctor_plug_ds_init cdecl () FBS_MODULE_REGISTER_CDTOR
	static ctx as fbsound.cdtor.cdtor_struct = _
		( _
			procptr(_plug_ds_init), _
			procptr(_plug_ds_exit), _
			@"plug_ds", _
			fbsound.cdtor.MODULE_PLUGIN2, _
			procptr(plug_filler_ds) _
		)
	fbsound.cdtor.register( @ctx )
	dprint( __FUNCTION__ )
  dprint("ds: CoInitialize()")
  ' Initialize COM
  CoInitialize(NULL)
end sub
#endif

#if __FB_OUT_DLL__ = 0
end namespace ' fbsound.plug_ds
#endif

#endif ' NO_PLUG_DS
