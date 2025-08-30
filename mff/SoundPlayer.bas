'###############################################################################
'#  SoundPlayer.bas                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Authors: D.J.Peters (Joshy), Xusinboy Bekchanov, Liu XiaLin                #
'#  Based on:                                                                  #
'#   FBsound_oop.bi                                                            #
'#   A free sound library primarily for games                                  #
'#   Copyright 2005-2020 by D.J.Peters (Joshy)                                 #
'#   Version 1.2.0                                                             #
'###############################################################################

#include once "SoundPlayer.bi"
'Namespace My.Sys.Media
Private Constructor SoundDevice(ByVal nRate As Integer, _
	ByVal nChannels    As Integer, _
	ByVal nBuffers     As Integer, _
	ByVal nFrames      As Integer, _
	ByVal nPlugIndex   As Integer, _
	ByVal nDeviceIndex As Integer)
	IsInit = This.Init(nRate, nChannels, nBuffers, nFrames, nPlugIndex, nDeviceIndex)
End Constructor

Private Function SoundDevice.Init(ByVal nRate As Integer, _
	ByVal nChannels    As Integer, _
	ByVal nBuffers     As Integer, _
	ByVal nFrames      As Integer, _
	ByVal nPlugIndex   As Integer, _
	ByVal nDeviceIndex As Integer) As Boolean
	IsInit = FBS_Init(nRate, nChannels, nBuffers, nFrames, nPlugIndex, nDeviceIndex)
	'fbs_Set_PlugPath( FBSOUND_DLL_PATH )
	Return IsInit
End Function

Private Property SoundDevice.Volume As Single
	Dim As Single value
	FBS_Get_MasterVolume(@value)
	Return value
End Property

Private Property SoundDevice.Volume(ByVal value As Single)
	FBS_Set_MasterVolume(value)
End Property

Private Constructor SampleBuffer
	If Not _IsInit Then Var Device = SoundDevice()
	hWave = -1
End Constructor

Private Constructor SampleBuffer(ByVal nSamples As Integer, ByRef pSamples As Any Ptr)
	If Not _IsInit Then Var Device = SoundDevice()
	hWave = -1 : This.Create(nSamples, pSamples)
End Constructor

Private Constructor SampleBuffer(ByRef FileName As WString)
	If Not _IsInit Then Var Device = SoundDevice()
	hWave = -1 : This.Load(FileName)
End Constructor

Private Function SampleBuffer.getHandle() As Integer
	Return hWave
End Function

Private Sub SampleBuffer.AddReference
	nReferences += 1
End Sub

Private Sub SampleBuffer.FreeReference
	If nReferences > 0 Then nReferences -= 1
End Sub

Private Function SampleBuffer.Create(ByVal nSamples As Integer, ByRef pSamples As Any Ptr) As Boolean
	If nReferences > 0 Then
		lastError = "error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences > 1, "s ", " ") & "TIP: use FreeReference before !"
		Print lastError : Return False
	End If
	If hWave <>-1 Then
		lastError = "error: wave handle are in use tip use Destroy before !" : Print lastError : Return False
	Else
		lastError = ""
	End If
	Dim As Any Ptr pMem
	Var bResult = FBS_Create_Wave(nSamples,@hWave,@pMem)
	If bResult = False Then lastError = "error: can't create samplebuffer with " & nSamples & " samples !" : Print lastError :
	pSamples = pMem
	Return bResult
End Function

Private Function SampleBuffer.Destroy() As Boolean
	If nReferences > 0 Then
		lastError="error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
		Print lastError : Return False
	End If
	Return FBS_Destroy_Wave(@hWave)
End Function

Private Function SampleBuffer.Load(ByRef FileName As WString) As Boolean
	If Not _IsInit Then Var Device = SoundDevice()
	If nReferences > 0 Then
		lastError =  __FUNCTION__ & " " & "Error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences > 1, "s ", " ") & "TIP: use FreeReference before !"
		Print lastError : Return False
	End If
	If hWave<>-1 Then
		lastError = __FUNCTION__ & " " &  "Error: wave handle are in use tip use Destroy before !" : Print lastError : Return False
	Else
		lastError = ""
	End If
	Var nChars = Len(FileName)
	If nChars < 4 Then lastError = __FUNCTION__ & " " &  "Error: illegal path/file: " & FileName : Print lastError : Return False
	If Dir(FileName) = "" Then lastError = "Error: file not exist:  " & FileName : Print lastError : Return False
	Var dotPos = InStrRev(FileName, ".") : nChars = nChars - dotPos
	If dotPos<2 OrElse nChars<2 OrElse nChars>3 Then
		lastError =  __FUNCTION__ & " " & "Error: illegal file extension: " & FileName : Print lastError : Return False
	End If
	Dim As String  ext = UCase(Right(FileName, nChars))
	Dim As Boolean bLoaded ': Print "ext=" & ext & " hwave=" & hWave
	Select Case ext
	Case "WAV"
		bLoaded = FBS_Load_WAVFile(FileName, @hWave)
	Case "MP3", "MP2", "MP"
		bLoaded = FBS_Load_MP3File(FileName, @hWave)
		'Case "OGG"
		'bLoaded = FBS_Load_OGGFile(FileName, @hWave)
	Case "MOD", "SM3", "IT", "XM"
		bLoaded = FBS_Load_MODFile(FileName, @hWave)
	Case Else
		lastError = __FUNCTION__ & " " &  "Error: unknow file extension: '." & ext & "'" : Print lastError : Return False
	End Select
	If bLoaded = False Then lastError = __FUNCTION__ & " " & "Error: while loading '" & FileName & "' " & hWave: Print lastError
	Return bLoaded
End Function

Private Function SampleBuffer.Length() As Double
	Dim As Integer ms
	If hWave= -1 OrElse FBS_Get_WaveLength(hWave, @ms) = False Then Return 0.0
	Return ms*0.001
End Function

Private Destructor SoundPlayer
	This.Destroy()
End Destructor

Private Constructor SoundPlayer()
	hSound = -1 : This.pBuffer = 0
End Constructor

Private Constructor SoundPlayer(ByRef buffer As SampleBuffer)
	hSound = -1 : This.Create(buffer)
End Constructor

Private Constructor SoundPlayer(ByVal BufferPtr As SampleBuffer Ptr)
	hSound = -1 : This.Create(BufferPtr)
End Constructor

Private Constructor SoundPlayer(ByRef FileName As WString)
	hSound = -1 : This.Load(FileName)
End Constructor

Private Sub SoundPlayer.Destroy()
	If This.pBuffer Then
		This.pBuffer->FreeReference()
		This.pBuffer=0
	End If
	If hSound <>-1 Then FBS_Destroy_Sound(@hSound)
End Sub

Private Function SoundPlayer.Create(ByRef buffer As SampleBuffer) As Boolean
	If hSound<>-1 OrElse This.pBuffer<>0 Then This.Destroy()
	This.pBuffer = @buffer
	This.pBuffer->AddReference()
	pLength = This.pBuffer->Length
	Return FBS_Create_Sound(pBuffer->getHandle(),@hSound)
End Function

Private Function SoundPlayer.Create(ByVal BufferPtr As SampleBuffer Ptr) As Boolean
	If hSound <>-1 OrElse This.pBuffer <> 0 Then This.Destroy()
	This.pBuffer = BufferPtr
	If This.pBuffer Then
		This.pBuffer->AddReference()
		pLength = This.pBuffer->Length
		Return FBS_Create_Sound(This.pBuffer->getHandle(), @hSound)
	End If
	Return False
End Function

Private Function SoundPlayer.Load(ByRef FileName As WString) As Boolean
	'If Not _IsInit Then
	'	'Print "Error: Sound device initialization failed."
	'	'This.Destroy() : Return False
	'	Var Device = SoundDevice()
	'End If
	If hSound <> -1 OrElse This.pBuffer <> 0 Then This.Destroy()
	Dim As SampleBuffer Buffer
	Dim As Boolean bLoadok = Buffer.Load(FileName)
	If bLoadok AndAlso @Buffer <> 0 Then
		This.pBuffer = @Buffer
		This.pBuffer->AddReference()
		pLength = This.pBuffer->Length
		Dim As Boolean bOK = FBS_Create_Sound(This.pBuffer->getHandle(), @hSound)
		Print bOK
		Return bOK
	Else
		Print "error: Can not load file: " & FileName
		Return False
	End If
End Function

Private Property SoundPlayer.Volume As Single
	Dim As Single value
	If This.hSound<>-1 Then FBS_Get_SoundVolume(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Volume(ByVal value As Single)
	If This.hSound<>-1 Then FBS_Set_SoundVolume(hSound,value)
End Property

Private Property SoundPlayer.SoundLocation ByRef As WString
	Return FSoundLocation
End Property

Private Property SoundPlayer.SoundLocation(ByRef FileName As WString)
	If Trim(FileName) <> "" AndAlso FSoundLocation <> FileName Then
		If Load(FileName) Then FSoundLocation = FileName
	End If
End Property

Private Property SoundPlayer.MasterVolume As Single
	Dim As Single value
	If This.hSound <> -1 Then FBS_Get_MasterVolume(@value)
	Return value
End Property

Private Property SoundPlayer.MasterVolume(ByVal value As Single)
	If This.hSound <> -1 Then FBS_Set_MasterVolume(value)
End Property

Private Property SoundPlayer.Loops As Integer
	Dim As Integer value
	If This.hSound<>-1 Then FBS_Get_SoundLoops(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Loops(ByVal value As Integer)
	If This.hSound<>-1 Then FBS_Set_SoundLoops(hSound,value)
End Property

Private Property SoundPlayer.Speed As Single
	Dim As Single value
	If This.hSound<>-1 Then FBS_Get_SoundSpeed(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Speed(ByVal value As Single)
	If This.hSound<>-1 Then FBS_Set_SoundSpeed(hSound,value)
End Property

Private Property SoundPlayer.Pan As Single
	Dim As Single value
	If This.hSound<>-1 Then FBS_Get_SoundPan(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Pan(ByVal value As Single)
	If This.hSound<>-1 Then FBS_Set_SoundPan(hSound,value)
End Property

Private Function SoundPlayer.Play(ByVal nLoops As Integer = 1) As Boolean
	If This.hSound<>-1 Then Return  FBS_Play_Sound(This.hSound,nLoops)
	Return False
End Function

Private Property SoundPlayer.Pause As Boolean
	Dim As Boolean value
	If This.hSound<>-1 Then FBS_Get_SoundPaused(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Pause(ByVal value As Boolean)
	If This.hSound<>-1 Then FBS_Set_SoundPaused(hSound,value)
End Property

Private Property SoundPlayer.Mute As Boolean
	Dim As Boolean value
	If This.hSound<>-1 Then FBS_Get_SoundMuted(hSound,@value)
	Return value
End Property

Private Property SoundPlayer.Mute(ByVal value As Boolean)
	If This.hSound<>-1 Then FBS_Set_SoundMuted(hSound,value)
End Property

Private Function SoundPlayer.Playposition As Single
	Dim As Single value
	If This.hSound<>-1 Then FBS_Get_SoundPosition(This.hSound,@value)
	Return value
End Function

Private Function SoundPlayer.Length() As Double
	If This.pBuffer Then Return pLength Else Return -1
End Function