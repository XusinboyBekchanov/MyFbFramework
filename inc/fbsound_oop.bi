#ifndef __FBSOUND_OOP_BI__
#define __FBSOUND_OOP_BI__

#ifndef __FBSOUND_DYNAMIC_BI__
 #include once "fbsound_dynamic.bi"
#endif

type SampleBuffer
  declare constructor
  declare constructor(byval nSamples as integer,byref pSamples as any ptr)
  declare constructor(byref filePath as string)
  declare function getHandle() as integer
  declare function Create(byval nSamples as integer,byref pSamples as any ptr) as boolean
  declare function Load(byref filePath as string) as boolean
  declare function Destroy() as boolean
  declare function Length() as double
  
  declare sub AddReference
  declare sub FreeReference
  as string lastError  
  private:
  as integer hWave
  as integer nReferences
end type
constructor SampleBuffer
  hWave=-1
end constructor
constructor SampleBuffer(byval nSamples as integer,byref pSamples as any ptr)
  hWave=-1 : this.Create(nSamples, pSamples)
end constructor
constructor SampleBuffer(byref filePath as string)
  hWave=-1 : this.Load(filePath)
end constructor
function SampleBuffer.getHandle() as integer
  return hWave
end function  
sub SampleBuffer.AddReference
  nReferences+=1
end sub
sub SampleBuffer.FreeReference
  if nReferences>0 then nReferences-=1
end sub
function SampleBuffer.Create(byval nSamples as integer,byref pSamples as any ptr) as boolean
  if nReferences>0 then
    lastError="error: wave object are in use by " & nReferences & " sound object" & iif(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    return false
  end if
  if hWave<>-1 then
    lastError="error: wave handle are in use tip use Destroy before !" : return false
  else  
    lastError = ""
  end if
  dim as any ptr pMem
  var bResult = FBS_Create_Wave(nSamples,@hWave,@pMem)
  if bResult=false then lastError="error: can't create samplebuffer with " & nSamples & " samples !"
  pSamples = pMem
  return bResult
end function
function SampleBuffer.Destroy() as boolean
  if nReferences>0 then
    lastError="error: wave object are in use by " & nReferences & " sound object" & iif(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    return false
  end if    
  return FBS_Destroy_Wave(@hWave)
end function

function SampleBuffer.Load(byref filePath as string) as boolean
  if nReferences>0 then
    lastError="error: wave object are in use by " & nReferences & " sound object" & iif(nReferences>1,"s "," ") & "TIP: use FreeReference before !"
    return false
  end if  
  if hWave<>-1 then
    lastError="error: wave handle are in use tip use Destroy before !" : return false
  else  
    lastError = ""
  end if  
  var nChars = len(filePath)
  ' "x.yz"
  if nChars<4 then lastError="error: illegal path/file: " & filePath : return false
  var dotPos = instrrev(filePath,".") : nChars=nChars-dotPos
  if dotpos<2 orelse nChars<2 orelse nChars>3 then
    lastError="error: illegal file extension: " & filePath : return false
  end if  
  var ext = right(filePath,nChars)
  ext = ucase(ext)
  dim as boolean bLoaded
  select case ext
  case "WAV"                : bLoaded = FBS_Load_WAVFile(filePath,@hWave)
  case "MP3","MP2","MP"     : bLoaded = FBS_Load_MP3File(filePath,@hWave)
  case "OGG"                : bLoaded = FBS_Load_OGGFile(filePath,@hWave)
  case "MOD","SM3","IT","XM": bLoaded = FBS_Load_MODFile(filePath,@hWave)
  case else
    lastError="error: unknow file extension: '." & ext & "'" : return false
  end select  
  if bLoaded=false then lastError="error: while loading '" & filePath & "' " & hWave
  return bLoaded
end function

function SampleBuffer.Length() as double
  dim as integer ms
  if hWave=-1 orelse FBS_Get_WaveLength(hWave,@ms)=false then return 0.0
  return ms*0.001
end function                                      

type SoundBuffer
  declare destructor
  declare constructor(byref buffer as SampleBuffer)
  declare constructor(byval pBuffer as SampleBuffer ptr)
  declare function Create(byref buffer as SampleBuffer) as boolean
  declare function Create(byval pBuffer as SampleBuffer ptr) as boolean
  declare sub      Destroy()
  declare property Volume as single
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
