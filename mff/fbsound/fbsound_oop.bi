#ifndef __FBSOUND_OOP_BI__
#define __FBSOUND_OOP_BI__

#if Not defined( __FBSOUND_DYNAMIC_BI__ ) And Not defined ( __FBSOUND_BI__ ) 
 #include once "fbsound_dynamic.bi"
#endif

Type SampleBuffer
  Declare Constructor
  Declare Constructor(ByVal nSamples As Integer,ByRef pSamples As Any Ptr)
  Declare Constructor(ByRef filePath As String)
  Declare Function getHandle() As Integer
  Declare Function Create(ByVal nSamples As Integer,ByRef pSamples As Any Ptr) As Boolean
  Declare Function Load(ByRef filePath As String) As Boolean
  Declare Function Destroy() As Boolean
  Declare Function Length() As Double
  
  Declare Sub AddReference
  Declare Sub FreeReference
  As String lastError  
  Private:
  As Integer hWave
  As Integer nReferences
End Type
Constructor SampleBuffer
  hWave=-1
End Constructor
Constructor SampleBuffer(ByVal nSamples As Integer,ByRef pSamples As Any Ptr)
  hWave=-1 : This.Create(nSamples, pSamples)
End Constructor
Constructor SampleBuffer(ByRef filePath As String)
  hWave=-1 : This.Load(filePath)
End Constructor
Function SampleBuffer.getHandle() As Integer
  Return hWave
End Function  
Sub SampleBuffer.AddReference
  nReferences+=1
End Sub
Sub SampleBuffer.FreeReference
  If nReferences>0 Then nReferences-=1
End Sub
Function SampleBuffer.Create(ByVal nSamples As Integer,ByRef pSamples As Any Ptr) As Boolean
  If nReferences>0 Then
    lastError="error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    Return False
  End If
  If hWave<>-1 Then
    lastError="error: wave handle are in use tip use Destroy before !" : Return False
  Else  
    lastError = ""
  End If
  Dim As Any Ptr pMem
  Var bResult = FBS_Create_Wave(nSamples,@hWave,@pMem)
  If bResult=False Then lastError="error: can't create samplebuffer with " & nSamples & " samples !"
  pSamples = pMem
  Return bResult
End Function
Function SampleBuffer.Destroy() As Boolean
  If nReferences>0 Then
    lastError="error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    Return False
  End If    
  Return FBS_Destroy_Wave(@hWave)
End Function

Function SampleBuffer.Load(ByRef filePath As String) As Boolean
  If nReferences>0 Then
    lastError="error: wave object are in use by " & nReferences & " sound object" & IIf(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    Return False
  End If  
  If hWave<>-1 Then
    lastError="error: wave handle are in use tip use Destroy before !" : Return False
  Else  
    lastError = ""
  End If  
  Var nChars = Len(filePath)
  ' "x.yz"
  If nChars<4 Then lastError="error: illegal path/file: " & filePath : Return False
  Var dotPos = InStrRev(filePath,".") : nChars=nChars-dotPos
  If dotPos<2 OrElse nChars<2 OrElse nChars>3 Then
    lastError="error: illegal file extension: " & filePath : Return False
  End If  
  Var ext = Right(filePath,nChars)
  ext = UCase(ext)
  Dim As Boolean bLoaded
  Select Case ext
  Case "WAV"                : bLoaded = FBS_Load_WAVFile(filePath,@hWave)
  Case "MP3", "MP2", "MP"     : bLoaded = FBS_Load_MP3File(filePath, @hWave) : Print __FUNCTION__ & "" & lastError
  'case "OGG"                : bLoaded = FBS_Load_OGGFile(filePath,@hWave)
  Case "MOD","SM3","IT","XM": bLoaded = FBS_Load_MODFile(filePath,@hWave)
  Case Else
    lastError="error: unknow file extension: '." & ext & "'" : Return False
  End Select 
  
  If bLoaded=False Then lastError="error: while loading '" & filePath & "' " & hWave
  Return bLoaded
End Function

Function SampleBuffer.Length() As Double
  Dim As Integer ms
  If hWave=-1 OrElse FBS_Get_WaveLength(hWave,@ms)=False Then Return 0.0
  Return ms*0.001
End Function                                      

Type SoundBuffer
  Declare Destructor
  Declare Constructor(ByRef buffer As SampleBuffer)
  Declare Constructor(ByVal pBuffer As SampleBuffer Ptr)
  Declare Function Create(ByRef buffer As SampleBuffer) As Boolean
  Declare Function Create(ByVal pBuffer As SampleBuffer Ptr) As Boolean
  Declare Sub      Destroy()
  Declare Property Volume As Single
  declare property Volume(byval newVolume as single)
  declare property Loops as integer
  declare property Loops(byval newLoop as integer)
  declare property Speed as single
  declare property Speed(byval newSpeed as single)
  declare property Pan as single
  declare property Pan(byval newPan as single)
  declare function Play(byval nLoops as integer = 1) as boolean
  declare property Pause as boolean
  declare property Pause(byval bMute as boolean)
  declare property Mute as boolean
  declare property Mute(byval bMute as boolean)
  declare function Playposition as single
  private:
  as SampleBuffer ptr pBuffer
  as integer          hSound
end type
destructor SoundBuffer
  this.Destroy()
end destructor
constructor SoundBuffer(byref buffer as SampleBuffer)
  hSound=-1 : this.Create(Buffer)
end constructor
constructor SoundBuffer(byval pBuffer as SampleBuffer ptr)
  hSound=-1 : this.Create(pBuffer)
end constructor
sub SoundBuffer.Destroy()
  if this.pBuffer then 
    this.pBuffer->FreeReference()
    this.pBuffer=0
  end if  
  if hSound<>-1 then FBS_Destroy_Sound(@hSound)
end sub
function SoundBuffer.Create(byref buffer as SampleBuffer) as boolean
  if hSound<>-1 orelse this.pBuffer<>0 then this.Destroy()
  this.pBuffer = @buffer
  this.pBuffer->AddReference()
  return FBS_Create_Sound(pBuffer->getHandle(),@hSound)
end function
function SoundBuffer.Create(byval pBuffer as SampleBuffer ptr) as boolean
  if hSound<>-1 orelse this.pBuffer<>0 then this.Destroy()
  this.pBuffer = pBuffer
  if this.pBuffer then
    this.pBuffer->AddReference()
    return FBS_Create_Sound(pBuffer->getHandle(),@hSound)
  end if
  return false
end function
property SoundBuffer.Volume as single
  dim as single value
  if this.hSound<>-1 then FBS_GET_SoundVolume(hSound,@value)
  return value
end property
property SoundBuffer.Volume(byval value as single)
  if this.hSound<>-1 then FBS_SET_SoundVolume(hSound,value)
end property
property SoundBuffer.Loops as integer
  dim as integer value
  if this.hSound<>-1 then FBS_GET_SoundLoops(hSound,@value)
  return value
end property
property SoundBuffer.Loops(byval value as integer)
  if this.hSound<>-1 then FBS_SET_SoundLoops(hSound,value)
end property
property SoundBuffer.Speed as single
  dim as single value
  if this.hSound<>-1 then FBS_GET_SoundSpeed(hSound,@value)
  return value
end property
property SoundBuffer.Speed(byval value as single)
  if this.hSound<>-1 then FBS_SET_SoundSpeed(hSound,value)
end property
property SoundBuffer.Pan as single
  dim as single value
  if this.hSound<>-1 then FBS_GET_SoundPan(hSound,@value)
  return value
end property
property SoundBuffer.Pan(byval value as single)
  if this.hSound<>-1 then FBS_SET_SoundPan(hSound,value)
end property
function SoundBuffer.Play(byval nLoops as integer) as boolean
  if this.hSound<>-1 then return  FBS_Play_Sound(this.hSound,nLoops) 
  return false
end function
property SoundBuffer.Pause as boolean
  dim as boolean value
  if this.hSound<>-1 then FBS_GET_SoundPaused(hSound,@value)
  return value
end property
property SoundBuffer.Pause(byval value as boolean)
  if this.hSound<>-1 then FBS_SET_SoundPaused(hSound,value)
end property
property SoundBuffer.Mute as boolean
  dim as boolean value
  if this.hSound<>-1 then FBS_GET_SoundMuted(hSound,@value)
  return value
end property
property SoundBuffer.Mute(byval value as boolean)
  if this.hSound<>-1 then FBS_SET_SoundMuted(hSound,value)
end property
function SoundBuffer.Playposition as single
  dim as single value
  if this.hSound<>-1 then FBS_GET_SoundPosition(this.hSound,@value) 
  return value
end function

type SoundDevice
  declare constructor(byval nRate        as integer=44100, _
                      byval nChannels    as integer=    2, _
                      byval nBuffers     as integer=    3, _
                      byval nFrames      as integer= 2048, _
                      byval nPlugIndex   as integer=    0, _
                      byval nDeviceIndex as integer=    0)
  declare function Init(byval nRate        as integer=44100, _
                        byval nChannels    as integer=    2, _
                        byval nBuffers     as integer=    3, _
                        byval nFrames      as integer= 2048, _
                        byval nPlugIndex   as integer=    0, _
                        byval nDeviceIndex as integer=    0) as boolean
  declare property Volume as single
  declare property Volume(byval newVolume as single)
  private:
  as boolean IsInit
end type
constructor SoundDevice(byval nRate        as integer, _
                        byval nChannels    as integer, _
                        byval nBuffers     as integer, _
                        byval nFrames      as integer, _
                        byval nPlugIndex   as integer, _
                        byval nDeviceIndex as integer)
  
  IsInit = this.Init(nRate, nChannels, nBuffers, nFrames, nPlugIndex, nDeviceIndex)
end constructor
function SoundDevice.Init(byval nRate        as integer, _
                          byval nChannels    as integer, _
                          byval nBuffers     as integer, _
                          byval nFrames      as integer, _
                          byval nPlugIndex   as integer, _
                          byval nDeviceIndex as integer) as boolean
  IsInit = FBS_Init(nRate, nChannels, nBuffers, nFrames, nPlugIndex, nDeviceIndex)
  return IsInit
end function
property SoundDevice.Volume as single
  dim as single value
  FBS_GET_MasterVolume(@value)
  return value
end property
property SoundDevice.Volume(byval value as single)
  FBS_SET_MasterVolume(value)
end property
#endif ' #define __FBSOUND_OOP_BI__
