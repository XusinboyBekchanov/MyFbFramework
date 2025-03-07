'################################################################################
'#  FBSound_DS_Test.frm                                                         #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  FBSound V1.2 Copyright 2005 - 2020 by D.J.Peters (Joshy)                    #
'#   d.j.peters@web.de                                                          #
'# https://github.com/jayrm/fbsound                                             #
'# https://www.freebasic.net/forum/viewtopic.php?p=199947&hilit=fbsound+static#p199947                        #
'################################################################################

'Please copy those files (fbsound-32.dll,fbsound-mm-32.dll,fbsound-64.dll,,fbsound-mm-64.dll)
'from "VisualFBEditor\Controls\MyFbFramework\Lib\" to the current execution file directory.
' file: test02.bas
' test of secondary DirectSoundBuffer
#include once "windows.bi"       ' <- BOOL, NULL ...
#include once "win/mmsystem.bi"  ' <- WAVEFORMETEX
#include once "win/d3d9types.bi"
#include once "win/dsound.bi"    ' <- IDirectSound

#include once "crt/string.bi"    ' <- memcpy

#inclib "dxguid"
#inclib "ole32"

#define DEBUG

#ifdef DEBUG
	#ifndef dprint
		#define dprint(msg) Scope:Dim As Integer HFILE=FreeFile():Open Err For Output As #HFILE:Print #HFILE,"debug: " & msg:Close #HFILE:End Scope
	#endif
#else
	#ifndef dprint
		#define dprint(msg) :
	#endif
#endif

' GUID helper
Function Guid2String(ByVal pGuid As LPGUID) As String
	If pGuid=0 Then Return "00000000-0000-0000-0000000000000000"
	Dim As String tmp = Hex(pGuid->Data1,8) & "-" & _
	Hex(pGuid->Data2,4) & "-" & _
	Hex(pGuid->Data3,4) & "-"
	For i As Integer=0 To 7
		tmp &= Hex(pGuid->Data4(i),2)
	Next
	Return tmp
End Function

' WAVEFORMATEX helper
Sub setWaveFormatEx(ByRef wf        As WAVEFORMATEX, _
	ByVal nRate     As Integer     , _
	ByVal nChannels As Integer)
	If nChannels<2 Then nChannels=1 Else nChannels=2
	wf.wFormatTag     = WAVE_FORMAT_PCM
	wf.nChannels      = nChannels
	wf.nSamplesPerSec = nRate
	wf.wBitsPerSample = 16
	wf.nBlockAlign    = nChannels*2
	wf.nAvgBytesPerSec=wf.nSamplesPerSec*wf.nBlockAlign
	wf.cbSize         =0
End Sub

' primary DirectSoundBuffer
Type DS_PRIMARY_BUFFER
	Declare Destructor
	Declare Constructor (ByVal nPlayrate As Integer=44100, _
	ByVal nChannels As Integer=    2, _
	ByVal nBuffers  As Integer=    4, _
	ByVal nSamples  As Integer= 2048, _
	ByVal pGuid     As LPGUID)
	Declare Function getRate       As Integer
	Declare Function getBits       As Integer
	Declare Function getChannels   As Integer
	Declare Function getBuffers    As Integer
	Declare Function getFrames     As Integer
	Declare Function getFramesize  As Integer
	Declare Function getBuffersize As Integer
	Declare Function isPlaying     As Integer
	Declare Function isLocked      As Integer
	Declare Function getEvents     As LPHANDLE
	Declare Function getCurrentPosition(ByRef CurrentPlayCursor  As DWORD, _
	ByRef CurrentWriteCursor As DWORD) As Integer
	Declare Function LockPointers(ByVal from     As Integer    , _
	ByVal ppAudio1 As Any Ptr Ptr, _
	ByVal pSize1   As Integer Ptr, _
	ByVal ppAudio2 As Any Ptr Ptr, _
	ByVal pSize2   As Integer Ptr) As Integer
	Declare Function UnlockPointers(ByVal pAudio1 As Any Ptr, _
	ByVal Size1   As Integer, _
	ByVal pAudio2 As Any Ptr, _
	ByVal Size2   As Integer) As Integer
Private:
	
	As LPDIRECTSOUND       m_pDirectSound
	
	As LPDIRECTSOUNDBUFFER m_pPrimaryBuffer
	As DSBUFFERDESC        m_PrimaryBufferDesc
	As DSBCAPS             m_PrimaryCaps
	As WAVEFORMATEX        m_PrimaryWaveFormat
	
	As LPDIRECTSOUNDBUFFER m_pSecondaryBuffer
	As DSBCAPS             m_SecondaryCaps
	As DSBUFFERDESC        m_SecondaryBufferDesc
	As WAVEFORMATEX        m_SecondaryWaveFormat
	
	As LPDIRECTSOUNDNOTIFY m_pSoundNotify
	As LPDSBPOSITIONNOTIFY m_pPositionNotify
	As LPHANDLE            m_phEvents
	As Integer             m_nBuffers ' nBuffers * nFrames = getBuffersize()
	As Integer             m_nFrames  ' samples per buffer
	As Integer             m_nFramesize
	As Integer             m_Playing
	As Integer             m_Locked
End Type

Destructor DS_PRIMARY_BUFFER
	dprint("DS_PRIMARY_BUFFER~")
	If m_pDirectSound<>NULL Then
		' stop secondary buffers
		If m_pSecondaryBuffer<>NULL Then
			Dim As DWORD status
			If (IDirectSoundBuffer_GetStatus(m_pSecondaryBuffer,@status)=DS_OK) Then
				If ((status And DSBSTATUS_PLAYING)<>0) Then
					dprint("IDirectSoundBuffer_Stop(m_pSecondaryBuffer)")
					IDirectSoundBuffer_Stop(m_pSecondaryBuffer)
				End If
			End If
		End If
		' delete event handles
		If m_phEvents Then
			For i As Integer=0 To m_nBuffers-1
				If m_phEvents[i]<>NULL Then
					dprint("CloseHandle(m_phEvents[" & i & "])")
					CloseHandle(m_phEvents[i])
				End If
			Next
			Delete[] m_phEvents
		End If
		' free m_pPositionNotify
		If m_pPositionNotify Then
			Delete [] m_pPositionNotify
			m_pPositionNotify=0
		End If
		' release sound notify
		If m_pSoundNotify<>NULL Then
			dprint("IDirectSoundNotify_Release(m_pSoundNotify)")
			IDirectSoundNotify_Release(m_pSoundNotify)
			m_pSoundNotify=0
		End If
		' release secondary buffer
		If m_pSecondaryBuffer<>NULL Then
			dprint("IDirectSoundBuffer_Release(m_pSecondaryBuffer)")
			IDirectSoundBuffer_Release(m_pSecondaryBuffer)
			m_pSecondaryBuffer=0
		End If
		' release direct sound
		dprint("IDirectSound_Release(m_pDirectSound)")
		IDirectSound_Release(m_pDirectSound)
		m_pDirectSound=0
	End If
	
	' Uninitialize COM
	CoUninitialize()
	
	#ifdef DEBUG
		Sleep 2000
	#endif
End Destructor

Constructor DS_PRIMARY_BUFFER(ByVal nPlayrate As Integer, _
	ByVal nChannels As Integer, _
	ByVal nBuffers  As Integer, _
	ByVal nFrames   As Integer, _
	ByVal pGuid     As LPGUID)
	dprint("DS_PRIMARY_BUFFER()")
	' Initialize COM
	CoInitialize(NULL)
	
	If nPlayrate<     11026 Then
		nPlayrate=11025
	ElseIf nPlayrate< 22051 Then
		nPlayrate=22050
	ElseIf nPlayrate< 32001 Then
		nPlayrate=32000
	ElseIf nPlayrate< 38001 Then
		nPlayrate=38000
	ElseIf nPlayrate< 44101 Then
		nPlayrate=44100
	ElseIf nPlayrate< 48001 Then
		nPlayrate=48000
	ElseIf nPlayrate<100000 Then
		nPlayrate=96000
	Else
		nPlayrate=100000
	End If
	
	If     nBuffers< 2 Then
		nBuffers=2
	ElseIf nBuffers>64 Then
		nBuffers=64
	End If
	
	If     nFrames<  513 Then
		nFrames=512
	ElseIf nFrames< 1025 Then
		nFrames=1024
	ElseIf nFrames< 2049 Then
		nFrames=2048
	ElseIf nFrames< 4097 Then
		nFrames=4096
	ElseIf nFrames< 8193 Then
		nFrames=8192
	ElseIf nFrames<16385 Then
		nFrames=16384
	Else
		nFrames=32768
	End If
	
	' create device
	If (DirectSoundCreate(pGuid,@m_pDirectSound,NULL)=DS_OK) Then
		' set cooperative level
		If (IDirectSound_SetCooperativeLevel(m_pDirectSound,GetForegroundWindow(),DSSCL_PRIORITY)=DS_OK) Then
			' create primary sound buffer
			With m_PrimaryBufferDesc
				.dwSize       =SizeOf(DSBUFFERDESC)
				.dwFlags      =DSBCAPS_PRIMARYBUFFER
				.dwBufferBytes=0
				.lpwfxFormat  =NULL
			End With
			If (IDirectSound_CreateSoundBuffer(m_pDirectSound,@m_PrimaryBufferDesc,@m_pPrimaryBuffer,NULL)=DS_OK) Then
				dprint("create primary buffer ok")
				' get buffer caps
				m_PrimaryCaps.dwSize = SizeOf(DSBCAPS)
				If (IDirectSoundBuffer_GetCaps(m_pPrimaryBuffer,@m_PrimaryCaps)=DS_OK) Then
					Dim As Integer hwbuffersize =  m_PrimaryCaps.dwBufferBytes
					dprint("get primary caps hw buffersize " & hwbuffersize & " ok")
					setWaveFormatEx(m_PrimaryWaveFormat,nPlayrate,nChannels)
					' try format
					IDirectSoundBuffer_SetFormat(m_pPrimaryBuffer,@m_PrimaryWaveFormat)
					' get curent format
					If IDirectSoundBuffer_GetFormat(m_pPrimaryBuffer,@m_PrimaryWaveFormat,SizeOf(WAVEFORMATEX),NULL)=DS_OK Then
						dprint("get primary format ok")
						' create secondary sound buffer
						setWaveFormatEx(m_SecondaryWaveFormat,nPlayrate,nChannels)
						With m_SecondaryBufferDesc
							.dwSize       =SizeOf(DSBUFFERDESC)
							.dwFlags      =DSBCAPS_CTRLPOSITIONNOTIFY Or DSBCAPS_GETCURRENTPOSITION2
							.dwBufferBytes=nBuffers*nFrames*4
							While .dwBufferBytes<hwbuffersize
								nFrames Shl=1
								.dwBufferBytes=nBuffers*nFrames*4
							Wend
							.lpwfxFormat  =@m_SecondaryWaveFormat
						End With
						
						If IDirectSoundBuffer_Release(m_pPrimaryBuffer)=DS_OK Then
							dprint("release primary buffer ok")
							m_pPrimaryBuffer=0
						End If
						
						If (IDirectSound_CreateSoundBuffer(m_pDirectSound,@m_SecondaryBufferDesc,@m_pSecondaryBuffer,NULL)=DS_OK) Then
							dprint("create secondary buffer ok")
							' get buffer caps
							m_SecondaryCaps.dwSize = SizeOf(DSBCAPS)
							If (IDirectSoundBuffer_GetCaps(m_pSecondaryBuffer,@m_SecondaryCaps)=DS_OK) Then
								Dim As Integer swbuffersize=m_SecondaryCaps.dwBufferBytes
								dprint("get secondary caps sw buffersize " & swbuffersize & " ok")
								' get curent format
								If IDirectSoundBuffer_GetFormat(m_pSecondaryBuffer,@m_SecondaryWaveFormat,SizeOf(WAVEFORMATEX),NULL)=DS_OK Then
									dprint("get secondary format ok")
									m_nFramesize = m_SecondaryWaveFormat.nBlockAlign
									m_nBuffers   = nBuffers
									m_nFrames    = swbuffersize\(m_nFramesize*nBuffers)
									If IDirectSoundBuffer_QueryInterface(m_pSecondaryBuffer,@IID_IDirectSoundNotify,@m_pSoundNotify)=S_OK Then
										dprint("get IID_IDirectSoundNotify ok")
										m_phEvents = New HANDLE[m_nBuffers]
										m_pPositionNotify = New DSBPOSITIONNOTIFY[m_nBuffers]
										For i As Integer=0 To nBuffers-1
											m_phEvents[i]=CreateEvent(NULL,False,False,NULL)
											m_pPositionNotify[i].dwOffset=i*m_nFrames*m_nFramesize
											m_pPositionNotify[i].hEventNotify=m_phEvents[i]
											dprint("m_pPositionNotify[" & i & "].dwOffset = " & m_pPositionNotify[i].dwOffset)
										Next
										If IDirectSoundNotify_SetNotificationPositions(m_pSoundNotify,m_nBuffers,m_pPositionNotify)=DS_OK Then
											dprint("IDirectSoundNotify_SetNotificationPositions ok")
										End If
									End If ' IID_IDirectSoundNotify
								End If ' m_SecondaryWaveFormat
							End If ' m_SecondaryCaps
						End If ' m_pSecondaryBuffer
					End If ' m_PrimaryWaveFormat
					m_Playing=(IDirectSoundBuffer_Play(m_pSecondaryBuffer,0,0,DSBPLAY_LOOPING)=DS_OK)
					Dim As DWORD status
					If (IDirectSoundBuffer_GetStatus(m_pSecondaryBuffer,@status)=DS_OK) Then
						If ((status And DSBSTATUS_PLAYING)<>0) Then
							dprint("secondary buffer looping ok")
						End If
					End If ' status
				End If ' m_PrimaryCaps
			End If ' m_pPrimaryBuffer
		End If ' DSSCL_PRIORITY
	End If ' m_pDirectSound
End Constructor


Function DS_PRIMARY_BUFFER.getRate As Integer
	Return m_SecondaryWaveFormat.nSamplesPerSec
End Function
Function DS_PRIMARY_BUFFER.getBits As Integer
	Return m_SecondaryWaveFormat.wBitsPerSample
End Function
Function DS_PRIMARY_BUFFER.getChannels As Integer
	Return m_SecondaryWaveFormat.nChannels
End Function
Function DS_PRIMARY_BUFFER.getBuffers As Integer
	Return m_nBuffers
End Function
Function DS_PRIMARY_BUFFER.getFrames As Integer
	Return m_nFrames
End Function
Function DS_PRIMARY_BUFFER.getFramesize As Integer
	Return m_nFramesize
End Function
Function DS_PRIMARY_BUFFER.getBuffersize As Integer
	Return m_nFrames*m_nFramesize
End Function
Function DS_PRIMARY_BUFFER.getEvents As LPHANDLE
	Return m_phEvents
End Function
Function DS_PRIMARY_BUFFER.isPlaying As Integer
	Return m_Playing
End Function
Function DS_PRIMARY_BUFFER.isLocked As Integer
	Return m_Locked
End Function
Function DS_PRIMARY_BUFFER.getCurrentPosition(ByRef CurrentPlayCursor  As DWORD, _
	ByRef CurrentWriteCursor As DWORD) As Integer
	If (m_pSecondaryBuffer=NULL) Then Return 0
	Return (IDirectSoundBuffer_GetCurrentPosition(m_pSecondaryBuffer,@CurrentPlayCursor,@CurrentWriteCursor)=DS_OK)
End Function

Function DS_PRIMARY_BUFFER.LockPointers(ByVal from     As Integer    , _
	ByVal ppAudio1 As Any Ptr Ptr, _
	ByVal pSize1   As Integer Ptr, _
	ByVal ppAudio2 As Any Ptr Ptr, _
	ByVal pSize2   As Integer Ptr) As Integer
	If (m_pSecondaryBuffer=NULL) Then Return 0
	If (m_Locked) Then Return 0
	Dim As Integer nBytes=m_nFrames*m_nFramesize
	Dim As HRESULT ret=IDirectSoundBuffer_Lock(m_pSecondaryBuffer,from,nBytes,ppAudio1,pSize1,ppAudio2,pSize2,0)
	If ret=DSERR_BUFFERLOST Then
		dprint("buffer lost !")
		If IDirectSoundBuffer_Restore(m_pSecondaryBuffer)=DS_OK Then
			If IDirectSoundBuffer_Lock(m_pSecondaryBuffer,from,nBytes,ppAudio1,pSize1,ppAudio2,pSize2,0)=DS_OK Then
				m_Locked=-1
			End If
		End If
	ElseIf ret=DS_OK Then
		m_Locked=-1
	End If
	Return m_Locked
End Function

Function DS_PRIMARY_BUFFER.UnlockPointers(ByVal pAudio1 As Any Ptr, _
	ByVal Size1   As Integer, _
	ByVal pAudio2 As Any Ptr, _
	ByVal Size2   As Integer) As Integer
	If (m_pSecondaryBuffer=NULL) Then Return 0
	If (m_Locked=0) Then Return 0
	If (IDirectSoundBuffer_Unlock(m_pSecondaryBuffer,pAudio1,Size1,pAudio2,Size2)=DS_OK) Then
		m_Locked=0
	End If
	Return (m_Locked=0)
End Function

Type DS_DEVICE_DESCRIPTOR
Public:
	Declare Destructor
	Declare Constructor(ByVal pGuid        As LPGUID, _
	ByVal pDescription As LPCSTR, _
	ByVal pModule      As LPCSTR)
	Declare Operator cast As String
	Declare Function getGuid As LPGUID
Private:
	As LPGUID m_pGuid
	As LPCSTR m_pDescription
	As LPCSTR m_pModule
End Type
Type PDS_DEVICE_DESCRIPTOR As DS_DEVICE_DESCRIPTOR Ptr

Destructor DS_DEVICE_DESCRIPTOR
	dprint("DS_DEVICE_DESCRIPTOR~")
	If m_pGuid Then
		Delete m_pGuid
		m_pGuid=0
	End If
	If m_pDescription Then
		Delete[] m_pDescription
		m_pDescription=0
	End If
	If m_pModule Then
		Delete[] m_pModule
		m_pModule=0
	End If
End Destructor

Constructor DS_DEVICE_DESCRIPTOR(ByVal pGuid        As LPGUID, _
	ByVal pDescription As LPCSTR, _
	ByVal pModule      As LPCSTR)
	dprint("DS_DEVICE_DESCRIPTOR()")
	If (pGuid<>0) Then
		m_pGuid=New GUID
		*m_pGuid=*pGuid
	End If
	If (pDescription<>NULL) Then
		Dim As Integer nChars=Len(*pDescription)+1
		m_pDescription = New UByte[nChars]
		m_pDescription = pDescription
	End If
	If (pModule<>NULL) Then
		Dim As Integer nChars=Len(*pModule)+1
		m_pModule = New UByte[nChars]
		m_pModule = pModule
	End If
End Constructor

Operator DS_DEVICE_DESCRIPTOR.cast As String
	Dim As String tmp = Guid2String(m_pGuid) & " " & *m_pDescription
	Operator = tmp
End Operator

Function DS_DEVICE_DESCRIPTOR.getGuid As LPGUID
	Return m_pGuid
End Function


Type DS_DEVICE_LIST
	Declare Destructor
	As Integer                   nDevices
	As PDS_DEVICE_DESCRIPTOR Ptr  pDevices
End Type
Type PDS_DEVICE_LIST As DS_DEVICE_LIST Ptr

Destructor DS_DEVICE_LIST
	If (pDevices<>NULL) Then
		If nDevices>0 Then
			For i As Integer=0 To nDevices-1
				If (pDevices[i]<>NULL) Then
					Delete pDevices[i]
					pDevices[i]=0
				End If
			Next
			nDevices=0
		End If
		Deallocate pDevices
		pDevices=0
	End If
	dprint("DS_DEVICE_LIST~")
End Destructor


Function DSDeviceEnumCB(ByVal pGuid As LPGUID, ByVal pDescription As LPCSTR, ByVal pModule As LPCSTR, ByVal pUserdata As LPVOID) As BOOL
	Dim As DS_DEVICE_LIST Ptr pList=CPtr(DS_DEVICE_LIST Ptr,pUserdata)
	If (pList=NULL) Then
		dprint("DSDeviceEnumCB error: pList=NULL !")
		Return 0 ' interrupt enumeration
	End If
	' the first primary (default) device does not have a GUID
	' (ignore it here it will be two times in the list)
	If pGuid=0 Then Return 1 ' get next device
	' be sure it's not an emulated DirectSound device
	' it's better to use the MM AudioDevice directly as an emulated DirectSound device
	Dim As LPDIRECTSOUND ds
	' craete the device interface if bussy try next device
	If (DirectSoundCreate(pGuid,@ds,NULL)<>DS_OK) Then Return 1
	Dim As Integer AddDeviceToList=0
	' get device caps
	Dim As DSCAPS caps
	caps.dwSize=SizeOf(DSCAPS)
	If IDirectSound_GetCaps(ds,@caps)=DS_OK Then
		' not an emulated MM device ?
		If (caps.dwFlags And DSCAPS_EMULDRIVER)=0 Then
			' 16 bit primary sound buffer ?
			If (caps.dwFlags And DSCAPS_PRIMARY16BIT) Then
				' stereo primary sound buffer ?
				If (caps.dwFlags And DSCAPS_PRIMARYSTEREO) Then
					If (IDirectSound_SetCooperativeLevel(ds,GetForegroundWindow(),DSSCL_PRIORITY)=DS_OK) Then
						AddDeviceToList=1
					End If
				End If
			End If
		End If
	End If
	' free the interface
	IDirectSound_Release(ds)
	If AddDeviceToList<>0 Then
		' allocate new item in list
		pList->pDevices=Reallocate(pList->pDevices,SizeOf(PDS_DEVICE_DESCRIPTOR)*(pList->nDevices+1))
		pList->pDevices[pList->nDevices]=New DS_DEVICE_DESCRIPTOR(pGuid,pDescription,pModule)
		pList->nDevices+=1
	End If
	Return 1 ' allow next device enumeration
End Function

Sub FillBuffer(ByVal pBuffer As Short Ptr, ByVal nSamples As Integer)
	Static As Single w1=0
	Static As Single w2=0
	Static As Single w3=0
	Static As Single w4=0
	Dim As Short Ptr p=pBuffer
	For i As Integer=0 To nSamples-1
		Dim As Single s=Sin(w1+w2)
		Dim As Single c=Cos(w2)
		*p=s*16000:p+=1
		*p=c*16000:p+=1
		w1+=6.28/44100.0*440
		w3+=6.28/44100.0*(10*Sin(w4))
		w2+=6.28/44100.0*(880+Sin(w3)*440)
		w4+=0.00001
	Next
End Sub


'
' main
'
Dim As DS_DEVICE_LIST DeviceList
Dim As DS_PRIMARY_BUFFER Ptr pBuffer
' get list of none emulated DirectSound devices
DirectSoundEnumerate(@DSDeviceEnumCB,@DeviceList)
If DeviceList.nDevices>0 Then
	For i As Integer=0 To DeviceList.nDevices-1
		dprint("device(" & i & "):" & DeviceList.pDevices[i] )
	Next
	pBuffer = New DS_PRIMARY_BUFFER(44100,2,3,2048,DeviceList.pDevices[0]->getGuid())
	Dim As Integer PlayCursor,WriteCursor
	Dim As Short Ptr pAudio1,pAudio2
	Dim As Integer Size1,Size2
	Dim As Integer counter,running=1
	While running
		If Len(Inkey()) Then running=0
		Dim As DWORD ret = MsgWaitForMultipleObjects(pBuffer->getBuffers(),pBuffer->getEvents(),0,INFINITE,QS_POSTMESSAGE)
		If (running<>0) AndAlso (ret<pBuffer->getBuffers()) Then
			Dim As Integer BufferIndex=(ret+1) Mod pBuffer->getBuffers()
			Dim As Integer position=BufferIndex*pBuffer->getBuffersize()
			If pBuffer->LockPointers(position,@pAudio1,@Size1,@pAudio2,@Size2) Then
				If pAudio1<>NULL Then FillBuffer(pAudio1,Size1\pBuffer->getFramesize())
				If pAudio2<>NULL Then FillBuffer(pAudio2,Size2\pBuffer->getFramesize())
				pBuffer->UnlockPointers(pAudio1,Size1,pAudio2,Size2)
			End If
		End If
	Wend
	' trigger destructor
	Delete pBuffer
Else
	dprint("sorry no hardware DirectSound device !")
End If
