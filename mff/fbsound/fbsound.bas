'  ###############
' # fbsound.bas #
'###############
' Copyright 2005-2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbs-config.bi"
#include once "fbstypes.bi"
#include once "fbsound.bi"

#ifndef NO_MOD
 #include once "dumb.bi"
#endif

#ifndef NO_MP3
 #include once "mad.bi"
#endif

#ifndef NO_SID
 #include once "libcsidlight.bi"
#endif

#ifndef NO_OGG
 #include once "vorbis/codec.bi"
 #include once "vorbis/vorbisenc.bi"
 #include once "vorbis/vorbisfile.bi"
#endif

#include once "plug.bi"
#include once "plug-static.bi"
#include once "plug-static.bas"
#include once "fbscpu.bi"

'' always export, even when building a static lib
'' if the end user builds everything static, then
'' it doesn't really matter and if this module is
'' built in to static lib then we want the exports
'' if it is later built in to a shared library 

#if defined( FBSOUND_USE_DYNAMIC )
	#define API_EXPORT Export
#else
 #define API_EXPORT  
#endif
'Type enum_mad_flow As mad_flow

#if defined(NO_MP3) And defined(NO_SID)
  ' no streams
#else
 Type FBS_STREAM
  As Boolean            InUse
  As Boolean            IsStreaming
  As Boolean            IsFin
  As Single             Volume
  As Single             lVolume
  As Single             rVolume
  As Single             Pan
  As FBS_FORMAT         fmt
  As UByte Ptr          pStart,pPlay,pEnd,pBuf
  As Integer            nOuts
  As Any Ptr            hThread
 #ifndef NO_CALLBACK
  As Boolean            EnabledCallback
  As FBS_BUFFERCALLBACK Callback
 #endif
End Type

 #ifndef NO_SID
Type FBS_SID_STREAM Extends FBS_STREAM
  As Boolean  bFillbuffer
End Type
 #endif ' NO_SID

 #ifndef NO_MP3
Type FBS_MP3_STREAM Extends FBS_STREAM
  As Short Ptr          p16,pStreamSamples
  As Single             l,r,scale,nPos
  As Integer            nSamplesTarget,nBytesTarget,nRest
  As Integer            i
  As Any Ptr            hThread
  As Short Ptr          pFill
  As Integer            RetStatus
  As UByte Ptr          pInArray
  As Integer            nReadSize,nReadRest,nDecodedSize
  As UByte Ptr          pRead
  As Integer            hFile,nFrames,nBytes,nInSize,nOutSize
  As mad_stream         mStream
  As mad_frame          mFrame
  As mad_synth          mSynth
  As UByte Ptr          GuardPTR
End Type
 #endif ' NO_MP3
 

#endif ' NO_MP3 or NO_SID


Dim Shared _mix                 As mix16_t
Dim Shared _scale               As scale16_t
Dim Shared _pan                 As pan16_t
Dim Shared _copyright           As copyright32_t
Dim Shared _moveright           As moveright32_t
Dim Shared _copysliceright      As copysliceright32_t
Dim Shared _movesliceright      As movesliceright32_t
Dim Shared _copysliceleft       As copysliceleft32_t
Dim Shared _movesliceleft       As movesliceleft32_t

#if defined(NO_MP3) And defined(NOSID)
  ' no streams
#else

 #ifndef NO_SID
Dim Shared _SIDStream           As FBS_SID_STREAM
 #endif
 
 #ifndef NO_MP3
Dim Shared _MP3Stream           As FBS_MP3_STREAM
Dim Shared _CopySliceMP3Frame   As CopySliceMP3Frame32_t
Dim Shared _ScaleMP3FrameStereo As ScaleMP3Frame_22_16_t
Dim Shared _ScaleMP3FrameMono   As ScaleMP3Frame_12_16_t
 #endif

#endif ' NO_MP3 or NO_SID

#ifndef NO_DSP
Dim Shared _Filter              As Filter_t
Dim Shared _MasterFilters(MAX_FILTERS-1) As FBS_FILTER
 #ifndef NO_PITCHSHIFT
Dim Shared _PitchShift          As PitchShift_t
 #endif
#endif


Dim Shared _Sounds()            As FBS_SOUND
Dim Shared _nSounds             As Integer
Dim Shared _Waves()             As FBS_WAVE
Dim Shared _nWaves              As Integer

Dim Shared _PlugPath            As String
Dim Shared _Plugs()             As FBS_PLUG
Dim Shared _nPlugs              As Integer
Dim Shared _Plug                As Integer
Dim Shared _IsRunning           As Boolean
Dim Shared _IsInit              As Boolean

Dim Shared _nPlayingSounds      As Integer
Dim Shared _nPlayingStreams     As Integer

Dim Shared _nPlayedBytes        As Integer

#ifndef NO_CALLBACK
Dim Shared _EnabledMasterCallback As Boolean
Dim Shared _MasterCallback        As FBS_BUFFERCALLBACK
Dim Shared _EnabledLoadCallback   As Boolean
Dim Shared _LoadCallback          As FBS_LOADCALLBACK
#endif

Dim Shared _MasterBuffer        As Any Ptr
Dim Shared _MasterVolume        As Single
Dim Shared _MaxChannels         As Integer

'dim shared _seed                as integer

Function FBS_Get_PlugPath() As String API_EXPORT
  dprint("FBS_Get_PlugPath() " & _PlugPath)
  Return _PlugPath
End Function

Sub FBS_Set_PlugPath(ByVal NewPath As String) API_EXPORT
  dprint("FBS_Set_PlugPath(" & NewPath & ")")
  _PlugPath=NewPath
End Sub

Function FBS_Get_MaxChannels(ByVal pMaxChannels As Integer Ptr) As Boolean API_EXPORT
  dprint("FBS_Get_MaxChannels()")
  If pMaxChannels=NULL Then Return False
  *pMaxChannels=_MaxChannels
  Return True
End Function

Function FBS_Set_MaxChannels(ByVal MaxChannels As Integer) As Boolean API_EXPORT
  dprint("FBS_Set_MaxChannels(" & MaxChannels & ")")
  If MaxChannels<1   Then MaxChannels=  1
  If MaxChannels>512 Then MaxChannels=512
  _MaxChannels=MaxChannels
  Return True
End Function

#ifndef NO_DSP
Private _
Function _IshFilter(ByVal hFilter As Integer) As Boolean
  If (_IsInit=False)                       Then Return False  
  If (hFilter<0) Or (hFilter>=MAX_FILTERS) Then Return False  
   Return True
End Function

Function FBS_Set_MasterFilter(ByVal nFilter As Integer, _
                              ByVal Center  As Single, _
                              ByVal dB      As Single, _
                              ByVal Octave  As Single = 1.0, _
                              ByVal OnOff   As Boolean=True) As Boolean API_EXPORT

  If _IshFilter(nFilter)=False Then Return False  
  _Set_EQFilter(@_MasterFilters(nFilter), _
                Center, _
                dB, _
                Octave, _
                _Plugs(_Plug).Fmt.nRate)

  _MasterFilters(nFilter).enabled=OnOff
   Return True
End Function

Function FBS_Enable_MasterFilter (ByVal nFilter As Integer) As Boolean API_EXPORT
  If _IshFilter(nFilter)=False Then Return False
  _MasterFilters(nFilter).enabled=True
   Return True
End Function

Function FBS_Disable_MasterFilter (ByVal nFilter As Integer) As Boolean API_EXPORT
  If _IshFilter(nFilter)=False Then Return False
  _MasterFilters(nFilter).enabled=False
   Return True
End Function

 #ifndef NO_PITCHSHIFT
Sub FBS_PitchShift(ByVal d As Short Ptr, _      ' output samples
                   ByVal s As Short Ptr, _      ' input samples
                   ByVal v As Single   , _      ' value of shift pow(2,note*1.0/12.0)
                   ByVal n As Integer  )  API_EXPORT ' number of samples
  If (_IsInit=False) Then Exit Sub
  _PitchShift(d,s,v,FBS_Get_PlugRate(),n)
End Sub
 #endif

#endif ' NO_DSP

Private _
Sub _MIXER(ByVal lpOChannels As Any Ptr, _
           ByVal lpIChannels As Any Ptr Ptr, _
           ByVal nChannels   As Integer , _
           ByVal nBytes      As Integer )
  Dim As Integer i
  If nChannels<2 Then
    dprint("mixer chn<2")
    Exit Sub
  End If

  _mix(lpOChannels, lpIChannels[0], lpIChannels[1], nBytes)
  If nChannels=2 Then Exit Sub

  For i=2 To nChannels-1
    _mix(lpOChannels, lpOChannels, lpIChannels[i], nBytes)
  Next
End Sub

Function FBS_Set_MasterVolume(ByVal Volume As Single) As Boolean API_EXPORT
  If (_IsInit=False) Then Return False
  If (Volume<0.001) Then
    Volume = 0.0
  ElseIf (Volume>2.0) Then
    Volume = 2.0
  End If  
  _MasterVolume=Volume
  Return True
End Function

Function FBS_Get_MasterVolume(ByVal lpVolume As Single Ptr) As Boolean API_EXPORT
  If _IsInit=False Then Return False
  *lpVolume=_MasterVolume
  Return True
End Function


' called from playback device
Private _
Sub _FillBuffer(ByVal pArg As Any Ptr)
  Static As Any Ptr MixerChannels(512)
  Dim As Integer i,j,k,nSize,nBytes,rest
  Dim As Integer nPlayingSounds,nChannels
  Dim As Integer nPlayingStreams

  ' convert to Plug format
  Dim As FBS_PLUG Ptr plug = CPtr(FBS_PLUG Ptr,pArg)

  'that should never happen
  If (plug                =NULL) Then Exit Sub
  If (plug->lpCurentBuffer=NULL) Then Exit Sub
  If (plug->BufferSize    <   4) Then Exit Sub

  _MasterBuffer = plug->lpCurentBuffer
  
  _nPlayedBytes += plug->BufferSize

#if defined(NO_MP3) And defined(NO_SID)
  ' no streams
#else

 #ifndef NO_MP3
  With _MP3Stream
    ' is the MP3 stream active?
    If (.InUse=True) Then
         
      ' enought decoded datas aviable
      If (.nOuts >= plug->BufferSize) Then
      
        nPlayingStreams+=1

        If (.pPlay + plug->BufferSize) <= .pEnd Then
                  
          If (.Volume=0.0) Then
            ' silence
            Zero(.pBuf, plug->BufferSize)
          Else
          
            If (.Volume<>1.0) Then _scale(.pPlay,.pPlay,.Volume,plug->BufferSize)
            
            If (plug->Fmt.nChannels=2) AndAlso (.Pan<>0.0) Then
              _pan(.pBuf,.pPlay, .lVolume, .rVolume, plug->BufferSize)
            Else
              Copy(.pBuf,.pPlay,plug->BufferSize)
            End If
            
          End If
          'dprint("FillBuffer: mix " &  Plug->Buffersize & " bytes from MP3Stream")  
          
          .nOuts -= plug->BufferSize
          MixerChannels(nChannels) = .pBuf : nChannels += 1
          
  #ifndef NO_CALLBACK
          ' straem user callback
          If CBool(.Callback<>NULL) AndAlso (.EnabledCallback=True) Then
            .Callback(CPtr(Short Ptr,.pBuf), plug->Fmt.nChannels, plug->BufferSize Shr plug->Fmt.nChannels)
          End If
  #endif
          .pPlay += plug->BufferSize
          If (.pPlay>=.pEnd) Then .pPlay=.pStart
          
          If CBool(.nOuts=0) AndAlso (.IsStreaming=False) Then .InUse = False
        End If
        
      Else ' (.nOuts<Plug->Buffersize)
        ' dprint("FillBuffer MP3Stream.nOuts: " & .nOuts & " < Plug->Buffersize: " & Plug->Buffersize )
        If CBool(.nOuts=0) AndAlso (.IsStreaming=False) Then 
          '.InUse=false
        End If 
      
      End If
    
    End If ' .InUse=true
    
  End With
 #endif ' NO_MP3

 #ifndef NO_SID
  ' SID stream
  With _SIDStream
    
    ' is the SID stream active?
    If (.InUse=True) Then

      ' enought decoded datas aviable
      If (.nOuts >= plug->BufferSize) Then
        
        nPlayingStreams+=1
        
        If (.Volume=0.0) Then
          ' silence
          Zero(.pBuf, plug->BufferSize)
        Else
          If (.Volume<>1.0) Then _scale(.pPlay,.pPlay,.Volume,plug->BufferSize)
          If (plug->Fmt.nChannels=2) AndAlso (.Pan<>0.0) Then
            _pan(.pBuf,.pPlay, .lVolume, .rVolume, plug->BufferSize)
          Else
            Copy(.pBuf,.pPlay,plug->BufferSize)
          End If
        End If
       'dprint("FillBuffer: mix " &  Plug->Buffersize & " bytes from MP3Stream")  
          
        .nOuts -= plug->BufferSize
        MixerChannels(nChannels) = .pBuf : nChannels += 1
        If .nOuts <= 0 Then .bFillbuffer=True
          
  #ifndef NO_CALLBACK
        ' straem user callback
        If CBool(.Callback<>NULL) AndAlso (.EnabledCallback=True) Then
          .Callback(CPtr(Short Ptr,.pBuf), plug->Fmt.nChannels, plug->BufferSize Shr plug->Fmt.nChannels)
        End If
  #endif
      Else
        ' signal get new buffer
        .bFillbuffer=True
      End If
      
    
    End If ' (.InUse=true
    
  End With    
 #endif ' NOSID
#endif ' NO_MP3 or NO_SID

  _nPlayingStreams = nPlayingStreams

  If (_nWaves > 0) AndAlso (_nSounds > 0) Then
    ' how many playing sounds
    For i=0 To _nSounds-1
      If CBool(_Sounds(i).pStart<>NULL) AndAlso _
         CBool(_Sounds(i).pBuf  <>NULL) AndAlso _ 
         CBool(_Sounds(i).nLoops > 0   ) AndAlso _
         (_Sounds(i).paused=False) Then nPlayingSounds+=1
    Next
  End If

  _nPlayingSounds =nPlayingSounds

  ' nothing or only one stream are playing?
  If (nPlayingSounds>0) Then
  
    For i=0 To _nSounds-1
      ' is sound active ?
      If CBool(_Sounds(i).pStart<>NULL ) AndAlso _
         CBool(_Sounds(i).pBuf  <>NULL ) AndAlso _ 
         CBool(_Sounds(i).nLoops  >0    ) AndAlso _
         (_Sounds(i).paused  =False) Then

        If (_Sounds(i).muted=False) Then 
          MixerChannels(nChannels)=_Sounds(i).pBuf
          nChannels+=1
          If _Sounds(i).Speed=1.0 Then 
             _copyright(_Sounds(i).pBuf  , _
                        _Sounds(i).pUserStart, _
                       @_Sounds(i).pPlay , _
                        _Sounds(i).pUserEnd  , _
                       @_Sounds(i).nLoops , _
                        plug->BufferSize  )

          ElseIf _Sounds(i).Speed>0.0 Then  
            _copysliceright(_Sounds(i).pBuf  , _
                            _Sounds(i).pUserStart, _
                           @_Sounds(i).pPlay , _
                            _Sounds(i).pUserEnd  , _
                           @_Sounds(i).nLoops , _
                            _Sounds(i).Speed  , _
                            plug->BufferSize  )
          Else
            _copysliceleft(_Sounds(i).pBuf  , _
                           _Sounds(i).pUserStart, _
                          @_Sounds(i).pPlay , _
                           _Sounds(i).pUserEnd  , _
                          @_Sounds(i).nLoops , _
                           _Sounds(i).Speed  , _
                           plug->BufferSize  )
          End If
          If _Sounds(i).Volume<>1.0 Then
            _scale(_Sounds(i).pBuf,_Sounds(i).pBuf,_Sounds(i).Volume,plug->BufferSize)
          End If
          ' paning needs stereo
          If _Plugs(_Plug).Fmt.nChannels=2 Then
            If _Sounds(i).Pan<>0.0 Then
               _pan(_Sounds(i).pBuf  , _
                    _Sounds(i).pBuf  , _
                    _Sounds(i).lVolume, _
                    _Sounds(i).rVolume, _
                    plug->BufferSize  )
            End If
          End If
          
#ifndef NO_CALLBACK
          ' user sound callback
          If CBool(_Sounds(i).Callback<>NULL) And (_Sounds(i).EnabledCallback=True) Then
            _Sounds(i).Callback(CPtr(Short Ptr,_Sounds(i).pBuf), _
                                plug->Fmt.nChannels        , _
                                plug->BufferSize Shr plug->Fmt.nChannels)
          End If
#endif
        Else ' only move playpointer
          If (_Sounds(i).Speed=1.0) Then
            _moveright(_Sounds(i).pUserStart, _
                      @_Sounds(i).pPlay , _
                       _Sounds(i).pUserEnd  , _
                      @_Sounds(i).nLoops , _
                       plug->BufferSize)
          ElseIf (_Sounds(i).Speed>0.0) Then
            _movesliceright(_Sounds(i).pUserStart, _
                           @_Sounds(i).pPlay , _
                            _Sounds(i).pUserEnd  , _
                           @_Sounds(i).nLoops , _
                            _Sounds(i).Speed  , _
                            plug->BufferSize)
          Else
            _movesliceleft(_Sounds(i).pUserStart, _
                          @_Sounds(i).pPlay , _
                           _Sounds(i).pUserEnd  , _
                          @_Sounds(i).nLoops , _
                           _Sounds(i).Speed  , _
                           plug->BufferSize)
          End If    
        End If ' is muted
      End If ' is sound active
      ' soundplayback are ready
      If (_Sounds(i).pStart<>NULL) AndAlso (_Sounds(i).nLoops<1) Then
        ' user has not the hSound handle mark it as free
        If _Sounds(i).usercontrol=False Then _Sounds(i).pStart=NULL
      End If
      If nChannels=_MaxChannels Then Exit For
    Next
  End If

  If nChannels<1 Then
    ' there can be played sounds but muted !
    Zero(plug->lpCurentBuffer,plug->BufferSize)
  ElseIf nChannels=1 Then
    ' one channel nothing to mix!
    Copy(plug->lpCurentBuffer,MixerChannels(0),plug->BufferSize)
  Else
    ' now time to mix MixerChannels[] to Plug->lpCurentBuffer
    _MIXER(plug->lpCurentBuffer,@MixerChannels(0),nChannels,plug->BufferSize)
  End If
  
  ' must be scaled ?
  If (_MasterVolume<>1.0) Then
    _scale(plug->lpCurentBuffer,plug->lpCurentBuffer,_MasterVolume,plug->BufferSize)
  End If

#ifndef NO_DSP
  ' any EQ active
  For i=0 To MAX_FILTERS-1
    If (_MasterFilters(i).enabled=True) AndAlso (_MasterFilters(i).dB<>0.0f) Then
      _Filter(plug->lpCurentBuffer, _
              plug->lpCurentBuffer, _
              @_MasterFilters(i)  , _
              plug->BufferSize    )
    End If
  Next
#endif

#ifndef NO_CALLBACK
  ' user master callback ?
  If CBool(_MasterCallback<>NULL) AndAlso (_EnabledMasterCallback=True) Then
    _MasterCallback(CPtr(Short Ptr,plug->lpCurentBuffer), _
                    plug->Fmt.nChannels, _
                    plug->BufferSize Shr plug->Fmt.nChannels)

  End If
#endif

End Sub

' fill wave header struct 
' return in lpDataPos the file pos of the first sample.
Private _
Function GetWaveInfo(ByVal FileName  As String , _
                     ByRef Hdr       As _PCM_FILE_HDR , _
                     ByVal lpDataPos As Integer Ptr) As Boolean

  Dim As Integer FileSize, fSize, L
  If lpDataPos=NULL Then Return False
  Var hFile = FreeFile()
  If Open(FileName For Binary Access Read As #hFile)=0 Then
    FileSize = LOF(hFile)
    If FileSize > _PCM_FILE_HDR_SIZE Then
      Get #hFile,, Hdr.ChunkRIFF
      If Hdr.ChunkRIFF = _RIFF Then
        Get #hFile,, Hdr.ChunkRIFFSize
        Get #hFile,, Hdr.ChunkID
        If Hdr.ChunkID = _WAVE Then
          fSize = Seek(hFile)
          Hdr.Chunkfmt=0
          While (Hdr.Chunkfmt <> _fmt) And (EOF(hFile) = 0)
            Get #hFile, fSize, Hdr.Chunkfmt
            fSize+=1
          Wend
          If Hdr.Chunkfmt = _fmt Then
            Get #hFile, , Hdr.ChunkfmtSize
            If Hdr.ChunkfmtSize >= _PCM_FMT_SIZE Then
              Get #hFile, , Hdr.wFormatTag
              If Hdr.wFormatTag = _WAVE_FORMAT_PCM Then
                Get #hFile, , Hdr.nChannels
                Get #hFile, , Hdr.nRate
                Get #hFile, , Hdr.nBytesPerSec
                Get #hFile, , Hdr.Framesize
                Get #hFile, , Hdr.nBits
                Hdr.Chunkdata=0
                fSize = Seek(hFile)
                While (Hdr.Chunkdata <> _data) And (EOF(hFile) = 0)
                  Get #hFile, fSize, Hdr.Chunkdata
                  fSize+=1
                Wend
                If Hdr.Chunkdata = _data Then
                  Get #hFile, , Hdr.ChunkdataSize
                  If Hdr.ChunkdataSize > 0 And EOF(hFile) = 0 Then
                    L = Seek(hFile)
                    *lpDataPos = L
                    Close #hFile
                    Return True
                  End If ' Chunkdatasize>0
                End If ' Chunkdata=_data
              End If ' wFormattag = WAVE_FORMAT_PCM
            End If ' ChunkfmtSize >= PCM_FMT_SIZE
          End If ' Chunkfmt = _fmt
        End If ' ChunkID = _WAVE
      End If ' ChunkRIFF = _RIFF
    End If ' FileSize > PCM_FILE_HDR_SIZE
  End If ' open=0
  Close #hFile
  Return False
End Function

Private _
Function _LoadWave(ByVal Filename        As String, _
                   ByVal nRateTarget     As Integer , _
                   ByVal nBitsTarget     As Integer , _
                   ByVal nChannelsTarget As Integer , _
                   ByVal lpnBytes        As Integer Ptr) As Any Ptr

  Dim As _PCM_FILE_HDR hdr
  Dim As Integer   SeekPos,nBytesTarget,nSamples,nSamplesTarget,i,oPos,cPos
  Dim As Single    l,r
  Dim As Double    Scale,nPos
  Dim As UByte     v8
  Dim As Short     v16
  Dim As Short Ptr p16

#ifndef NO_CALLBACK
  Dim As Single   percent
  Dim As Integer  pold,pnew
#endif        

  oPos=-1
  If GetWaveInfo(Filename,hdr,@SeekPos)=True Then
    
    nSamples = hdr.ChunkdataSize \ hdr.Framesize
    
    Scale = hdr.nRate/nRateTarget
    
    nSamplesTarget = nSamples*(1.0/Scale)
    
    nBytesTarget = nSamplesTarget*(nBitsTarget\8)*nChannelsTarget
    
    Var hFile = FreeFile()
    If Open(Filename For Binary Access Read As #hFile)=0 Then
      Seek #hFile,SeekPos
      
      p16 = CAllocate(nBytesTarget)
      If (p16 = NULL) Then
        dprint("error: LoadWave() out of memeory !")        
        Close #hFile : Return NULL 
      End If
      
      If nSamples<=nSamplesTarget Then

#ifndef NO_CALLBACK
        percent=100.0/nSamplesTarget
#endif        
        For i=0 To nSamplesTarget-1
          ' jump over in source
          If oPos<>cPos Then
            ' read samples l,r -0.5 - 0.5
            If hdr.nBits=8 Then
              'read ubyte 0<->255
              Get #hFile,,v8
              ' convert to -128.0 <-> +127.0
              l=CSng(v8):l-=128
              ' convert to -0.5 <-> +0.5
              l*=(0.5f/128.0f)
              If hdr.nChannels=2 Then 
                Get #hFile,,v8
                r=CSng(v8):r-=128
                ' convert to -0.5 <-> +0.5
                r*=(0.5f/128.0f)  
              Else
                r=l
              End If
            Else
              Get #hFile,,v16 : l=(0.5f/32767.0f)*v16
              If hdr.nChannels=2 Then 
                Get #hFile,,v16 : r=(0.5f/32767.0f)*v16
              Else 
                r=l
              End If
            End If
            oPos=cPos
          End If
          ' write every in target
          If nChannelsTarget=1 Then
            p16[i    ]=CShort(l*16383f + r*16383f)
          Else
            p16[i*2  ]=CShort(l*32767.0f)
            p16[i*2+1]=CShort(r*32767.0f)
          End If
          nPos+=Scale : cPos=Int(nPos)
          
#ifndef NO_CALLBACK
          If CBool(_LoadCallback<>NULL) And (_EnabledLoadCallback=True) Then
            pnew = percent * i
            If (pnew<>pold) Then
              _LoadCallback(pnew)
              pold=pnew
            End If           
          End If
#endif                    
          ' don't read more than len(source)
          If cPos>=nSamples Then Exit For
          
        Next
        
      Else ' read every source Sample
      
        Scale=(1.0/Scale)
        
#ifndef NO_CALLBACK        
        percent=100.0/nSamples
#endif
        For i=0 To nSamples-1
          
          ' read samples l,r -0.5 - +0.5
          If hdr.nBits=8 Then
            'read ubyte 0<->255
            Get #hFile,,v8
            ' convert to -128.0 <-> +127.0
            l=CSng(v8):l-=128
            ' convert to -0.5 <-> +0.5
            l*=(0.5f/128.0f)
            If hdr.nChannels=2 Then 
              Get #hFile,,v8
              r=CSng(v8):r-=128
              ' convert to -0.5 <-> +0.5
              r*=(0.5f/128.0f)  
            Else
              r=l
            End If
            
          Else
          
            Get #hFile,,v16:l=(0.5f/32767.0f)*v16
            If hdr.nChannels=2 Then
              Get #hFile,,v16:r=(0.5f/32767.0f)*v16
            Else 
              r=l
            End If
          
          End If
          
          ' jump over in destination
          If oPos<>cPos Then 
            If nChannelsTarget=1 Then
              p16[cPos    ]=CShort(l*16383.5f + r*16383.5f)
            Else
              p16[cPos*2  ]=CShort(l*32767.0f)
              p16[cPos*2+1]=CShort(r*32767.0f)
            End If
            oPos=cPos
          End If
          nPos+=Scale:cPos=Int(nPos)

#ifndef NO_CALLBACK
          If CBool(_LoadCallback<>NULL) And (_EnabledLoadCallback=True) Then
            pnew = percent * i
            If (pnew<>pold) Then
              _LoadCallback(pnew)
              pold=pnew
            End If
          End If
#endif
          ' don't write more than len(target)
          If cPos >= (nSamplesTarget-1) Then Exit For
          
        Next
        
      End If
      Close #hFile
      *lpnBytes = nBytesTarget
      Return p16
  
    End If ' open=0
  
  End If ' GetWaveInfo<>0
  
  Return NULL
End Function

Private _
Function _Adjust_Path(ByVal Path As String) As String
  Var nChars=Len(Path)
  If nChars>0 Then
    For i As Integer=0 To nChars-1
      If Path[i]=Asc("\") Then Path[i]=Asc("/")
    Next
    If Right(Path,1)<>"/" Then Path=Path & "/"
  End If  
  Return Path
End Function

Private Function _Get_PlugPath() As String
  Dim As String tmp = _Adjust_Path(_PlugPath)
  Return tmp
End Function

#if __FB_OUT_DLL__ <> 0

Private _
Function _InitPlugout(ByVal filename As String, _
                      ByRef p        As FBS_PLUG) As Boolean
  dprint("_InitPlugout(" & filename & ")")
  p.plug_hLib=0
  dprint("_InitPlugout: dylibload(" & filename & ")")
  p.plug_hLib=DyLibLoad(filename)
  If p.plug_hLib<>0 Then
    p.plug_isany=DyLibSymbol(p.plug_hLib, "PLUG_ISANY" )
    If (p.plug_isany<>NULL) Then
      If p.plug_isany(p)=True Then
        p.plug_init =DyLibSymbol( p.plug_hLib, "PLUG_INIT"  )
        p.plug_start=DyLibSymbol( p.plug_hLib, "PLUG_START" )
        p.plug_stop =DyLibSymbol( p.plug_hLib, "PLUG_STOP"  )
        p.plug_exit =DyLibSymbol( p.plug_hLib, "PLUG_EXIT"  )
        p.plug_error=DyLibSymbol( p.plug_hLib, "PLUG_ERROR" )
        If (p.plug_init <>NULL) And _
           (p.plug_start<>NULL) And _
           (p.plug_stop <>NULL) And _
           (p.plug_exit <>NULL) And _
           (p.plug_error<>NULL) Then
            Return True
        Else
          dprint("_InitPlugout: isn't a plugout interface!")
          DyLibFree p.plug_hLib
          p.plug_hLib=NULL
          Return False
        End If
      Else
        dprint("_InitPlugout: no free devices !")
        dprint("_InitPlugout: call DylibFree()")
        DyLibFree p.plug_hLib
        p.plug_hLib=NULL
        Return False
      End If
    Else
      dprint("_InitPlugout: missing interface member (plug_isany)")
      dprint("_InitPlugout: call DylibFree()")
      DyLibFree p.plug_hLib
      p.plug_hLib=NULL
      Return False
    End If
  Else
    dprint("_InitPlugout: can't load '" & filename & "' !")
    Return False
  End If
End Function

pluglist:
#ifdef __FB_WIN32__
 #ifndef __FB_64BIT__
  #ifndef NO_PLUG_MM  
Data "fbsound-mm-32.dll"
  #endif  
  #ifndef NO_PLUG_DS 
Data "fbsound-ds-32.dll"
  #endif
 #else
  #ifndef NO_PLUG_MM  
Data "fbsound-mm-64.dll"
  #endif
  #ifndef NO_PLUG_DS 
Data "fbsound-ds-64.dll"
  #endif 
 #endif 
 
#else

 #ifndef __FB_64BIT__
  #ifndef NO_PLUG_ALSA
Data "libfbsound-alsa-32.so"
  #endif  
  #ifndef NO_PLUG_DSP
Data "libfbsound-dsp-32.so"
  #endif
  #ifndef NO_PLUG_ARTS  
Data "libfbsound-arts-32.so"
  #endif
 #else
  ' linux 64-bit 
  #ifndef NO_PLUG_ALSA
Data "libfbsound-alsa-64.so"
  #endif  
 #endif 
#endif

Data "" ' end of list
  
#endif ' not( __FB_DLL_OUT__ <> 0 )

Private _
Sub _Enumerate_Plugs()
  Dim As String  plugname
  Dim As FBS_PLUG _newVar
  dprint("_Enumerate_Plugs()") 
  If _nPlugs>0 Then Exit Sub

#if __FB_OUT_DLL__ = 0
  Dim cdtor As Const fbsound.cdtor.cdtor_struct Ptr = Any
  cdtor = fbsound.cdtor.getfirst_plugin()
  Do While cdtor
    dprint("_Enumerate_Plugs() call plug_filler(" & *cdtor->module & ")")
    If cdtor->plug_filler(_newVar)=True Then
      ReDim Preserve _Plugs(_nPlugs)
      _Plugs(_nPlugs)=_newVar : _nPlugs+=1
    End If
    cdtor = fbsound.cdtor.getnext_plugin(cdtor)
  Loop 

#else ' not( __FB_OUT_DLL__ = 0 )
  Restore pluglist
  Read plugname
  
  While Len(plugname)
    plugname = _PlugPath & plugname
    dprint("_Enumerate_Plugs() call _initplugout(" & plugname & ")")
    If _InitPlugout(plugname,_newVar)=True Then
      ReDim Preserve _Plugs(_nPlugs)
      _Plugs(_nPlugs)=_newVar : _nPlugs+=1
    End If
    Read plugname 
  Wend
#endif ' __FB_OUT_DLL__ = 0

End Sub

FBS_MODULE_CDTOR_SCOPE _
Sub _fbs_init cdecl () FBS_MODULE_CTOR
  dprint("_fbs_init() module constructor")
  _PlugPath    =_Get_PlugPath()
  _Plug        =-1
  _MasterVolume=1.0
  _MaxChannels =512
#ifndef NO_MOD
  dprint("_fbs_init() module constructor call dumb_register_stdfiles()")
  dumb_register_stdfiles()
#endif
End Sub

FBS_MODULE_CDTOR_SCOPE _
Sub _fbs_exit cdecl () FBS_MODULE_DTOR
  dprint("_fbs_exit() module destructor")
  If (_IsInit=True) Then 
    If (_IsRunning=True) Then
      dprint("_fbs_exit() module destructor call fbs_Stop()")
      FBS_Stop()
    End If
    dprint("_fbs_exit() module destructor call fbs_Exit()")  
    FBS_Exit()
  End If
#ifndef NO_MOD
  dprint("_fbs_exit() module destructor call dumb_exit()")  
  dumb_exit()
#endif
End Sub

#if __FB_OUT_DLL__ = 0
Public _
Sub ctor_fbs_init cdecl () FBS_MODULE_REGISTER_CDTOR
	Static cdtor As fbsound.cdtor.cdtor_struct = _
		( _
			ProcPtr(_fbs_init), _
			ProcPtr(_fbs_exit), _
			@"fbs", _
			fbsound.cdtor.MODULE_MAIN _
		)
	fbsound.cdtor.register( @cdtor )
End Sub
#endif

Function FBS_Get_NumOfPlugouts() As Integer  API_EXPORT
  Return _nPlugs
End Function

Function FBS_Get_PlugError() As String  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).plug_error()
End Function

Function FBS_Get_PlugName() As String  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).PlugName
End Function

Public _
Function FBS_Get_PlugDevice() As String  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).DeviceName
End Function

Public _
Function FBS_Get_PlugBuffersize() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).BufferSize
End Function

Public _
Function FBS_Get_PlugBuffers() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).nBuffers
End Function

Public _
Function FBS_Get_PlugFramesize() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).Framesize
End Function

Public _
Function FBS_Get_PlugFrames() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).nFrames
End Function

Public _
Function FBS_Get_PlugRate() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).Fmt.nRate
End Function

Public _
Function FBS_Get_PlugBits() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).Fmt.nBits
End Function

Public _
Function FBS_Get_PlugChannels() As Integer  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).Fmt.nChannels
End Function

Public _
Function FBS_Get_PlugSigned() As Boolean  API_EXPORT
  If _Plug>-1 Then Return _Plugs(_Plug).Fmt.signed
End Function

Public _
Function FBS_Get_PlugRunning() As Boolean  API_EXPORT
  Return _IsRunning
End Function

Public _
Function FBS_Get_PlayingSounds() As Integer  API_EXPORT
  If (_IsRunning=True) Then Return _nPlayingSounds
End Function

#if defined(NO_MP3) And defined(NO_SID)
  ' no streams
#else
Function FBS_Get_PlayingStreams() As Integer  API_EXPORT
  If (_IsRunning=0) Then Return 0
  Return _nPlayingStreams
End Function
#endif

Function FBS_Get_PlayedBytes() As Integer  API_EXPORT
  If (_IsInit=True) Then Return _nPlayedBytes
End Function

Function FBS_Get_PlayedSamples() As Integer  API_EXPORT
  If FBS_Get_PlayedBytes>0 Then Return Int(FBS_Get_PlayedBytes()\_Plugs(_Plug).Framesize)
End Function

Function FBS_Get_PlayTime() As Double  API_EXPORT
  If FBS_Get_PlayedSamples>0 Then Return CDbl(FBS_Get_PlayedSamples()/_Plugs(_Plug).Fmt.nRate)
End Function

Function FBS_Init(ByVal nRate        As Integer, _
                  ByVal nChannels    As Integer, _
                  ByVal nBuffers     As Integer, _
                  ByVal nFrames      As Integer, _
                  ByVal nPlugIndex   As Integer, _
                  ByVal nDeviceIndex As Integer) As Boolean  API_EXPORT

  Dim As Integer     i
  Dim As Boolean  ret
  Dim As FBS_PLUG    _newVar

#if __FB_OUT_DLL__ = 0
  dprint("fbsound.cdtor.callctors()")
  fbsound.cdtor.callctors()
  #if defined( Debug ) Or ( __FB_DEBUG__ <> 0 )
    fbsound.cdtor.dump()
  #endif
#endif

  dprint("fbs_Init(" & nRate & ", " & nChannels & ", " & nBuffers & ", " & nFrames & ", " & nPlugIndex & ", " & nDeviceIndex & ")")

  If (_nPlugs<1) Then
    dprint("fbs_Init Enumerate_Plugs()")
    _Enumerate_Plugs()
  End If

  If _nPlugs=0 Then
    dprint("fbs_Init: no playback devices !")
    _IsInit=False
    Return False
  End If

  If _Plug>-1 Then
    dprint("fbs_Init: _Plug>-1")
    _Plugs(_Plug).plug_stop()
    _Plugs(_Plug).plug_exit()
    _Plug=-1
  End If

  If nPlugIndex<0 Then
    nPlugIndex=0
  Else
    nPlugIndex=nPlugIndex Mod _nPlugs
  End If

  _Plugs(nPlugIndex).Fmt.nRate    =nRate
  _Plugs(nPlugIndex).Fmt.nBits    =16
  _Plugs(nPlugIndex).Fmt.nChannels=nChannels
  _Plugs(nPlugIndex).nBuffers     =nBuffers
  _Plugs(nPlugIndex).nFrames      =nFrames
  _Plugs(nPlugIndex).FillBuffer   =@_FillBuffer
  _Plugs(nPlugIndex).DeviceIndex  =nDeviceIndex

  If _Plugs(nPlugIndex).plug_init(_Plugs(nPlugIndex))=True Then 
    _Plug=nPlugIndex
  Else
    For nPlugIndex=0 To _nPlugs-1
      If _Plugs(nPlugIndex).plug_init(_Plugs(nPlugIndex))=True Then 
        _Plug=nPlugIndex:Exit For
      End If
    Next
  End If

  If _Plug<>-1 Then
    dprint("FBS_Init set CPU pointers !")
    _mix   = @Mix16  
    _scale = @Scale16
   
    If _Plugs(_Plug).Fmt.nChannels=1 Then
      _copyright          =@CopyRight16
      _moveright          =@MoveRight16
      _copysliceright     =@CopySliceRight16
      _movesliceright     =@MoveSliceRight16
      _copysliceleft      =@CopySliceLeft16
      _movesliceleft      =@MoveSliceLeft16
      _pan                = NULL '!!!
      
#ifndef NO_MP3
      _CopySliceMP3Frame  =@CopySliceMP3Frame16
      _ScaleMP3FrameStereo=@ScaleMP3Frame_21_16
      _ScaleMP3FrameMono  =@ScaleMP3Frame_11_16
#endif

#ifndef NO_DSP
      _Filter             =@_Filter_Mono_asm16
 #ifndef NO_PITCHSHIFT
      _PitchShift         =@_PitchShiftMono_asm
 #endif
#endif
    Else
      ' stereo
      _copyright          =@CopyRight32
      _moveright          =@MoveRight32
      _copysliceright     =@CopySliceRight32
      _movesliceright     =@MoveSliceRight32
      _copysliceleft      =@CopySliceLeft32
      _movesliceleft      =@MoveSliceLeft32
      _pan                =@Pan16
      
#ifndef NO_MP3
      _CopySliceMP3Frame  =@CopySliceMP3Frame32
      _ScaleMP3FrameStereo=@ScaleMP3Frame_22_16
      _ScaleMP3FrameMono  =@ScaleMP3Frame_12_16
#endif

#ifndef NO_DSP
      _Filter             =@_Filter_Stereo_asm16
 #ifndef NO_PITCHSHIFT
      _PitchShift         =@_PitchShiftStereo_asm
 #endif
#endif 
    End If
    
    _IsInit = True
    Return FBS_Start()

  Else

    _IsInit = False
    Return False

  End If
End Function

Function FBS_Start() As Boolean  API_EXPORT
  dprint("FBS_Start()")
  If _Plug=-1 Then Return False  
  _IsRunning = _Plugs(_Plug).plug_start()
  Return _IsRunning
End Function

Function FBS_Stop() As Boolean  API_EXPORT
  Dim As Boolean ret
  dprint("FBS_Stop()")
  If _Plug = -1 Then Return True
  If _IsRunning = False Then Return True
  dprint("FBS_Stop() call _Plugs(_Plug).plug_stop()")
  ret=_Plugs(_Plug).plug_stop()
  dprint("FBS_Stop() call sleep(100,1)")
  Sleep(100,1)
  If ret=True Then _IsRunning=False
  dprint("FBS_Stop~")
  Return ret
End Function

Function FBS_Exit() As Boolean  API_EXPORT
  dprint("FBS_Exit()")
  Dim As Integer i
  If _Plug = -1 Then Return True
  If _IsRunning = True Then 
    dprint("FBS_Exit() call FBS_Stop()")
    FBS_Stop()
    _IsRunning = False
    dprint("FBS_Exit() call sleep(100,1)")
    Sleep(100,1)
  End If

#if defined(NO_MP3) And defined(NO_SID)
  ' no streams
#else

 #ifndef NO_MP3
  If (_MP3Stream.InUse=True) Then
    dprint("FBS_Exit() call FBS_End_MP3Stream()")
    FBS_End_MP3Stream()
  End If  
  ' free all resources from streams 
  With _MP3Stream
    If (.pInArray       <> NULL) Then Deallocate .pInArray       : .pInArray = NULL  
    If (.pStreamSamples <> NULL) Then Deallocate .pStreamSamples : .pStreamSamples = NULL  
    If (.pBuf           <> NULL) Then Deallocate .pBuf           : .pBuf = NULL  
    If (.pStart         <> NULL) Then Deallocate .pStart         : .pStart = NULL  
  End With
 #endif

 #ifndef NO_SID
  If (_SIDStream.InUse=True) Then
    dprint("FBS_Exit() call FBS_End_SIDStream()")
    FBS_End_SIDStream()
  End If  
  ' free all resources from streams 
  With _SIDStream
    If (.pBuf           <> NULL) Then Deallocate .pBuf           : .pBuf = NULL  
    If (.pStart         <> NULL) Then Deallocate .pStart         : .pStart = NULL  
  End With
 #endif

#endif ' NO_MP3 or NO_SID

  If _nSounds>0 Then
  
    For i=0 To _nSounds-1
      With _Sounds(i)
        ' signal stop
        If .nLoops<>0 Then
          .paused = True
          .nLoops = 0  
        End If
      
        If (.pBuf <> NULL) Then
          If (.pBuf = _Sounds(i).pOrg) Then
            Deallocate _Sounds(i).pBuf
            .pBuf = NULL
            .pOrg = NULL
          Else
            dprint("!!! pointer value are corrupt !!!")
          End If
        End If
        .pStart = NULL
        .pPlay  = NULL
        .pEnd   = NULL
      End With  
    Next
  End If
  
  If (_nWaves>0) Then
    For i=0 To _nWaves-1
      With _Waves(i)
        If .pStart<>NULL Then
          Deallocate .pStart
          .pStart = NULL
          .nBytes = 0
        End If
      End With  
    Next
    _nWaves=0
  End If
  dprint("FBS_Exit() call _Plugs(_Plug).plug_exit()")
  _Plugs(_Plug).plug_exit()
  dprint("FBS_Exit() call sleep(100,1)")
  Sleep(100,1)
  If _Plugs(_Plug).plug_hLib <> NULL Then

#if __FB_OUT_DLL__ <> 0
    dprint("FBS_Exit() call dylibfree _Plugs(_Plug).plug_hLib")
    DyLibFree _Plugs(_Plug).plug_hLib
#endif
    dprint("FBS_Exit() call sleep(100,1)")
    Sleep(100,1)
    _Plugs(_Plug).plug_hLib = NULL
  End If
  _nPlugs =  0
  _Plug   = -1
  _IsInit = False
  dprint("FBS_Exit()~")

#if __FB_OUT_DLL__ = 0
  dprint("fbsound.cdtor.calldtors()")
  fbsound.cdtor.calldtors()
  #if defined( Debug ) Or ( __FB_DEBUG__ <> 0 )
    fbsound.cdtor.dump()
  #endif
#endif

  Return True
End Function

Function FBS_Create_Wave(ByVal nSamples As Integer    , _
                         ByVal hWave    As Integer Ptr, _
                         ByVal pWave    As Any Ptr Ptr) As Boolean  API_EXPORT
  Dim As Any Ptr pNew
  Dim As Integer nBytes,index
  If (hWave = NULL) Then Return False
  If (pWave = NULL) Then Return False
  *hWave=-1 
  If (_Plug   =  -1) Then Return False
  If (nSamples<   1) Then Return False
  
  nBytes  = _Plugs(_Plug).Fmt.nBits \ 8
  nBytes *= _Plugs(_Plug).Fmt.nChannels
  nBytes *= nSamples 
  pNew = CAllocate(nBytes)
  If pNew = NULL Then 
    dprint("error: FBS_Create_Wave out of memory !")
    Return False
  End If  
  
  If _nWaves=0 Then
    ' allocate first wave object
    ReDim _Waves(0) : _nWaves+=1
  Else
    ' search a free wave object in pool of waves
    index=-1
    For i As Integer = 0 To _nWaves-1
      If _Waves(i).pStart=NULL Then index=i:Exit For
    Next
    If index=-1 Then
      ' add new wave object in pool 
      index= _nWaves : ReDim Preserve _Waves(_nWaves) : _nWaves+=1
    End If
  End If
  _Waves(index).pStart = pNew
  _Waves(index).nBytes = nBytes
  *pWave = pNew
  *hWave = index
  Return True
End Function

Function FBS_Load_WAVFile(ByRef Filename As WString, _
                          ByVal hWave    As Integer Ptr) As Boolean  API_EXPORT
  dprint("FBS_Load_WAVFile(" & Filename & ")")
  Dim As Integer nBytes
  If (hWave = NULL) Then Return False  
  *hWave=-1
  If _IsInit = False Then Return False

  Var _newVar = _LoadWave(Filename, _
                       _Plugs(_Plug).Fmt.nRate    , _
                       _Plugs(_Plug).Fmt.nBits    , _
                       _Plugs(_Plug).Fmt.nChannels, _
                       @nBytes)

  If _newVar = NULL Then Return False
  Var index = 0
  ' new sound
  If _nWaves=0 Then
    ReDim _Waves(0) : _nWaves=1
  Else
    index = -1
    For i As Integer = 0 To _nWaves-1
      If _Waves(i).pStart=NULL Then index = i : Exit For
    Next
    If index = -1 Then 
      index = _nWaves
      ReDim Preserve _Waves(_nWaves) : _nWaves += 1
    End If  
  End If
  _Waves(index).pStart = _newVar
  _Waves(index).nBytes = nBytes
   *hWave = index
  Return True
End Function

#ifndef NO_MP3
'  ##############
' # mp3 libmad #
'##############
Const As Integer FRAMESIZE = 1152
Const As Single  MP3_SCALE = 1.0f/8325.0f

Type MP3_STEREO_SAMPLE
  As Short l
  As Short r
End Type

Type MP3_BUFFER
  As UByte Ptr     pStart
  As Integer       Size
  As Integer       hOut
  As _PCM_FILE_HDR wavehdr
  As UByte Ptr     pFilebuf
End Type

' input mp3 stream
Private _
Function ConvertMP3Stream() As Integer
  If (_MP3Stream.InUse = False) Then 
    dprint("ConvertMP3Stream() MP3Stream.InUse = false !")
    Return 0
  End If  

  If _MP3Stream.mSynth.pcm.length<1 Then
    dprint("ConvertMP3Stream MP3Stream.mSynth.pcm.length <=  1 !")
    Return 0
  End If
  
  _MP3Stream.nSamplesTarget = _MP3Stream.mSynth.pcm.length 

  If (_MP3Stream.mSynth.pcm.channels>1) Then
    _ScaleMP3FrameStereo(_MP3Stream.pStreamSamples, _
                        @_MP3Stream.mSynth.pcm.samples(0,0), _
                        @_MP3Stream.mSynth.pcm.samples(1,0), _
                         _MP3Stream.nSamplesTarget)
  Else

    _ScaleMP3FrameMono(_MP3Stream.pStreamSamples, _
                      @_MP3Stream.mSynth.pcm.samples(0,0), _
                       _MP3Stream.nSamplesTarget)
  End If

  _MP3Stream.nBytesTarget = _MP3Stream.nSamplesTarget * (_Plugs(_Plug).Fmt.nBits\8) * _Plugs(_Plug).Fmt.nChannels 

  If _MP3Stream.p16=NULL Then _MP3Stream.p16=CPtr(Short Ptr,_MP3Stream.pStart)

  If (_MP3Stream.mSynth.pcm.samplerate = _Plugs(_Plug).Fmt.nRate) Then

    While ( CBool( (_MP3Stream.nOuts + _MP3Stream.nBytesTarget) > _MP3Stream.nOutSize) AndAlso (_MP3Stream.IsStreaming=True) )
      Sleep(1,1)
    Wend 
    If (_MP3Stream.IsStreaming=False) Then Return 0
    
    CopyMP3Frame( _MP3Stream.pStart , _
                 @_MP3Stream.p16     , _
                  _MP3Stream.pEnd   , _
                  _MP3Stream.pStreamSamples, _
                  _MP3Stream.nBytesTarget)
  Else
  
    _MP3Stream.scale =_MP3Stream.mSynth.pcm.samplerate/_Plugs(_Plug).Fmt.nRate
    _MP3Stream.nBytesTarget *= (1.0/_MP3Stream.scale)
    
    While (  CBool( (_MP3Stream.nOuts + _MP3Stream.nBytesTarget) > _MP3Stream.nOutSize) AndAlso (_MP3Stream.IsStreaming=True) )
      Sleep(1,1)
    Wend
    If _MP3Stream.IsStreaming=False Then Return 0
    
    _CopySliceMP3Frame(_MP3Stream.pStart , _
                      @_MP3Stream.p16     , _
                       _MP3Stream.pEnd   , _
                       _MP3Stream.pStreamSamples, _
                       _MP3Stream.scale ,_
                       _MP3Stream.nBytesTarget)
                       
  End If
  
   Return _MP3Stream.nBytesTarget
End Function


#define IN_SIZE 8192
Private _
Sub _MP3StreamingThread(ByVal dummy As Any Ptr)
  dprint("_MP3StreamingThread()")
  If (_MP3Stream.InUse=False) Then Exit Sub
  
  _MP3Stream.IsStreaming=True

  ' loop over the whole stream
  While (_MP3Stream.IsStreaming = True)
    
    ' get first buffer or fill curent buffer     
    If (_MP3Stream.mStream.buffer=NULL) Or ( _MP3Stream.mStream.error = MAD_ERROR_BUFLEN) Then

      If (_MP3Stream.mStream.next_frame<>NULL) Then
      
        _MP3Stream.nReadRest = _MP3Stream.mStream.bufend - _MP3Stream.mStream.next_frame
        
        If _MP3Stream.nReadRest > 0 Then
          Copy(_MP3Stream.pInArray, CPtr(Any Ptr,_MP3Stream.mStream.next_frame), _MP3Stream.nReadRest)
          _MP3Stream.pRead     = _MP3Stream.pInArray + _MP3Stream.nReadRest
          _MP3Stream.nReadSize = IN_SIZE - _MP3Stream.nReadRest
        End If
        
      Else
        _MP3Stream.nReadSize = IN_SIZE
        _MP3Stream.pRead     = _MP3Stream.pInArray
        _MP3Stream.nReadRest = 0
      End If
      
      ' enought bytes in stream?
      If (_MP3Stream.nInSize < _MP3Stream.nReadSize) Then 
        _MP3Stream.nReadSize = _MP3Stream.nInSize
      End If  
      
      ' read from stream or exit the decoding loop
      If (_MP3Stream.nReadSize=0) AndAlso  (_MP3Stream.nInSize=0) Then
        dprint("_MP3StreamingThread _MP3Stream.nReadSize=0 and _MP3Stream.nInSize=0 !")
        Exit While
      End If  

      Get #_MP3Stream.hFile,,*_MP3Stream.pRead, _MP3Stream.nReadSize
      
      _MP3Stream.nInSize -= _MP3Stream.nReadSize

      ' last frame fill the rest with 0
      If (_MP3Stream.nInSize=0) Then
        _MP3Stream.GuardPTR =_MP3Stream.pRead + _MP3Stream.nReadSize
        Zero(_MP3Stream.GuardPTR,MAD_BUFFER_GUARD)
        _MP3Stream.nReadSize += MAD_BUFFER_GUARD
      End If

      mad_stream_buffer(@_MP3Stream.mStream, _
                         _MP3Stream.pInArray, _
                         _MP3Stream.nReadSize + _MP3Stream.nReadRest)
      _MP3Stream.mStream.error=0
    End If

    If ( mad_frame_decode(@_MP3Stream.mFrame,@_MP3Stream.mStream)<>0) Then
      If (_MP3Stream.mStream.error<>0) Then
        If ( MAD_RECOVERABLE(_MP3Stream.mStream.error) ) Then
          If ( (_MP3Stream.mStream.error<>MAD_ERROR_LOSTSYNC) Or _
               (_MP3Stream.mStream.this_frame<>_MP3Stream.GuardPTR) Or _
              ( _
              ( (_MP3Stream.mStream.this_frame[0]<>Asc("I")) And _
                (_MP3Stream.mStream.this_frame[1]<>Asc("D")) And _
                (_MP3Stream.mStream.this_frame[2]<>Asc("3")) ) _
              Or _
              ( (_MP3Stream.mStream.this_frame[0]<>Asc("T")) And _
                (_MP3Stream.mStream.this_frame[1]<>Asc("A")) And _
                (_MP3Stream.mStream.this_frame[2]<>Asc("G")) ) )) Then Goto get_next_frame

        Else ' not recoverable
          If (_MP3Stream.mStream.error=MAD_ERROR_BUFLEN) Then 
            Goto get_next_frame ' get next bytes from stream
          Else
            dprint("MP3StreamingThread stream error not recoverable !")
            _MP3Stream.RetStatus=4
            Exit While
          End If
        End If
      End If  
      
    Else ' no decode error
  
      _MP3Stream.nFrames+=1
      mad_synth_frame(@_MP3Stream.mSynth,@_MP3Stream.mFrame)
      _MP3Stream.nOuts+=ConvertMP3Stream()
      
    End If
    
    get_next_frame:

  Wend

  If (_MP3Stream.nOuts>0) Then
    
    _MP3Stream.nReadRest=_MP3Stream.nOuts Mod _Plugs(_Plug).BufferSize
    
    If _MP3Stream.nReadRest>0 Then 
      _MP3Stream.nReadRest=_Plugs(_Plug).BufferSize-_MP3Stream.nReadRest
      While ((_MP3Stream.nOuts+_MP3Stream.nReadRest)>_MP3Stream.nOutSize)
        Sleep(1,1)
      Wend 
      ZeroBuffer(_MP3Stream.pStart, @_MP3Stream.p16, _MP3Stream.pEnd, _MP3Stream.nReadRest)
      _MP3Stream.nOuts+=_MP3Stream.nReadRest
    End If
    
  End If
  
  _MP3Stream.IsStreaming=False
    
  mad_synth_finish (@_MP3Stream.mSynth )
  mad_frame_finish (@_MP3Stream.mFrame )
  mad_stream_finish(@_MP3Stream.mStream)

  If _MP3Stream.hFile<>0 Then Close _MP3Stream.hFile : _MP3Stream.hFile=0
  dprint("_MP3StreamingThread~")
End Sub

Private _
Function inputcallback cdecl (ByVal pData   As Any Ptr, _
                              ByVal pStream As mad_stream Ptr) As enum_mad_flow
  Var buf = CPtr(MP3_BUFFER Ptr,pData)
  If buf->Size = 0 Then Return MAD_FLOW_STOP
  mad_stream_buffer(pStream, buf->pStart, buf->Size)
  buf->Size = 0
  Return MAD_FLOW_CONTINUE
End Function

Private _
Function outputcallback cdecl (ByVal lpData   As Any Ptr       , _
                               ByVal lpHeader As Const mad_header Ptr, _
                               ByVal lpPCM    As mad_pcm    Ptr) As enum_mad_flow
  Dim As MP3_BUFFER Ptr buf=CPtr(MP3_BUFFER Ptr,lpData)
  Dim As Integer i
  If lpPCM->channels>1 Then
      _ScaleMP3FrameStereo(buf->pFilebuf, _
                           @lpPCM->samples(0,0), _
                           @lpPCM->samples(1,0), _, _
                           lpPCM->length)

  Else
    _ScaleMP3FrameMono(buf->pFilebuf, _
                      @lpPCM->samples(0,0), _
                       lpPCM->length)
  End If

  ' first time write wave header
  If buf->wavehdr.ChunkdataSize=0 Then
    buf->wavehdr.ChunkRIFF     = _RIFF
    buf->wavehdr.ChunkRIFFSize = SizeOf(_PCM_FILE_HDR)-8
    buf->wavehdr.ChunkID       = _WAVE
    buf->wavehdr.Chunkfmt      = _fmt
    buf->wavehdr.ChunkfmtSize  = 16 
    buf->wavehdr.wFormatTag    = 1
    buf->wavehdr.nChannels     = _Plugs(_Plug).Fmt.nChannels
    buf->wavehdr.nRate         = lpPCM->samplerate
    buf->wavehdr.nBytesPerSec  = (_Plugs(_Plug).Fmt.nBits\8)*lpPCM->samplerate*_Plugs(_Plug).Fmt.nChannels
    buf->wavehdr.Framesize     = (_Plugs(_Plug).Fmt.nBits\8)*_Plugs(_Plug).Fmt.nChannels
    buf->wavehdr.nBits         =_Plugs(_Plug).Fmt.nBits
    buf->wavehdr.Chunkdata     = _data
    Put #buf->hOut,,buf->wavehdr
  End If

  buf->wavehdr.ChunkRIFFSize+=lpPCM->length*buf->wavehdr.Framesize
  buf->wavehdr.ChunkdataSize+=lpPCM->length*buf->wavehdr.Framesize
  
  Put #buf->hOut,, buf->pFilebuf[0], lpPCM->length*buf->wavehdr.Framesize
  
  Return MAD_FLOW_CONTINUE
End Function

Private _
Function errorcallback cdecl (ByVal lpData   As Any Ptr       , _
                              ByVal lpStream As mad_stream Ptr, _
                              ByVal lpFrame  As mad_frame  Ptr) As enum_mad_flow

  Dim As MP3_BUFFER Ptr buf = CPtr(MP3_BUFFER Ptr,lpData)

  If ( MAD_RECOVERABLE(lpStream->error) ) Then
    Return  MAD_FLOW_CONTINUE
  Else ' not recoverable
    If (lpStream->error=MAD_ERROR_BUFLEN) Then 
      Return  MAD_FLOW_CONTINUE
    Else
      dprint("mp3 error callback not recoverable !")
      Return MAD_FLOW_BREAK
    End If
  End If
End Function

Private _
	Function _DecodeMP3(ByVal pStart As Any Ptr, _
                    ByVal Size   As Integer, _
                    ByVal hOut   As Integer) As Integer
  
  Dim As MP3_BUFFER  buf
  Dim As mad_decoder  decoder
  Dim As Integer     result

  ' initialize our private message structure
  buf.pStart   = pStart
  buf.Size     = Size
  buf.hOut     = hOut
  buf.pFilebuf = Allocate(SizeOf(Short)*1152*2*4)
If buf.pFilebuf = NULL Then Return -1 ' 内存分配失败处理 
  ' configure input, output, and error _FUs
  mad_decoder_init(@decoder        , _
                   @buf            , _
                   @inputcallback  , _
                   0               , _ ' header
                   0               , _ ' filter
                   @outputcallback , _
                   @errorcallback  , _ 
                   0)                  ' message

  ' start decoding 
  result = mad_decoder_run(@decoder, MAD_DECODER_MODE_SYNC)
  
  Seek hOut, 1
  Put #hOut, , buf.wavehdr
  
  ' release the decoder
  mad_decoder_finish(@decoder)
  
  If buf.pFilebuf<>NULL Then Deallocate buf.pFilebuf : buf.pFilebuf=NULL 
  Return result
End Function

Function FBS_Load_MP3File(ByRef Filename As WString , _
                          ByVal phWave   As Integer Ptr , _
                          ByRef _usertmpfile_  As String) As Boolean  API_EXPORT
  Static As Integer tmpid = 0
  Dim As String outTmp

  If phWave = NULL Then Return False  
  *phWave = -1
  If _IsInit = False Then Return False  

  Dim As WString * 260 infile = Filename
  Dim As Integer hFile = FreeFile()
  If Open(infile For Binary Access Read As #hFile)<>0 Then Return False  
  Dim As LongInt Size = LOF(hFile)
  If Size = 0 Then Close #hFile : Return False
  Dim As UByte Ptr pMP3 = CAllocate(Size+ 1)
  If pMP3 = NULL Then
    dprint(__FUNCTION__ & " " & "Error: FBS_Load_MP3File out of memory !")
    Close #hFile
    Return False
  EndIf  

  Get #hFile, , *pMP3, Size
  Close #hFile
    
  If _usertmpfile_="" Then 
    tmpid += 1 : outTmp = "_usertmpfile_mp3" & Trim(Str(tmpid)) & ".wav"
  Else
    outTmp = _usertmpfile_
  End If
  If Len(Dir(outTmp)) Then Kill outTmp

  Dim As Integer hOut = FreeFile()
  If Open(outTmp For Binary Access Write As #hOut)<>0 Then
    Close #hFile
    If (pMP3 <> NULL) Then  Deallocate pMP3 : pMP3=NULL 
    Return False
  End If

  Dim As Integer ret = _DecodeMP3(pMP3, Size, hOut)
  Close #hOut
  
  If (pMP3<>NULL) Then Deallocate pMP3 : pMP3 = NULL

  If ret=0 Then
    If FBS_Load_WAVFile(outTmp, phWave) = True Then
      Kill outTmp : Return True
    Else
      Kill outTmp : *phWave = -1 : Return False
    End If
  Else
    Kill outTmp : *phWave = -1 :Return False
  End If
End Function


Function FBS_Set_MP3StreamVolume(ByVal Volume As Single) As Boolean  API_EXPORT
  If _MP3Stream.InUse=False Then Return False  
  If Volume>2.0    Then Volume=2.0
  If Volume<0.0001 Then Volume=0.0
  _MP3Stream.Volume=Volume
   Return True
End Function

Function FBS_Get_MP3StreamVolume(ByVal pVolume As Single Ptr) As Boolean  API_EXPORT
  If _MP3Stream.InUse = False Then Return False  
  If pVolume = NULL Then Return False  
  *pVolume = _MP3Stream.Volume
   Return True
End Function

Function FBS_Set_MP3StreamPan(ByVal Pan As Single) As Boolean  API_EXPORT
  If _MP3Stream.InUse=False Then Return False  
  If Pan<-1.0 Then Pan=-1.0
  If Pan> 1.0 Then Pan= 1.0
  _MP3Stream.Pan = Pan
  If Pan>=0.0 Then _MP3Stream.rVolume=1 Else _MP3Stream.rVolume=Pan+1.0
  If Pan<=0.0 Then _MP3Stream.lVolume=1 Else _MP3Stream.lVolume=1.0-Pan
   Return True
End Function

Function FBS_Get_MP3StreamPan(ByVal pPan As Single Ptr) As Boolean  API_EXPORT
  If pPan = NULL Then Return False  
  If _MP3Stream.InUse = False Then Return False  
  *pPan = _MP3Stream.Pan
   Return True
End Function

Function FBS_Create_MP3Stream (ByRef Filename As WString) As Boolean  API_EXPORT
  If _IsInit          = False Then Return False   ' not init
  If _MP3Stream.InUse = True  Then Return False  
  
  Var hTmp = FreeFile()
  If Open(Filename For Binary Access Read As #hTmp)<>0 Then
    dprint("FBS_Create_MP3Stream error: can't open MP3 stream: '" & Filename & " !")
    Return False
  End If

  Var nBytes = LOF(hTmp)
  If (nBytes<1000) Then
    Close hTmp
    dprint ("MP3 stream size to short!")
    Return False
  End If

  With _MP3Stream
    .hFile        = hTmp
    .nInSize      = nBytes
    .IsStreaming  = False
    .IsFin        = False
    .hThread      = 0
    .nOuts        = 0
    .nFrames      = 0
    .Volume       = 1.0
    .Pan          = 0.0
    .lVolume      =-1.0
    .rVolume      = 1.0
    .nDecodedSize = 0
    .nReadSize    = 0
    .nReadRest    = 0
    .nOutSize     = _Plugs(_Plug).BufferSize*3 '!!!
    If (.pInArray=NULL) Then
      .pInArray=Allocate(IN_SIZE+MAD_BUFFER_GUARD)
    End If  
    If (.pStart = NULL) Then
      .pStart = CAllocate(.nOutSize)
      .pEnd   = .pStart + .nOutSize
    End If
    If (.pBuf = NULL) Then 
      .pBuf = CAllocate(_Plugs(_Plug).BufferSize+512)
    End If
    If (.pStreamSamples = NULL) Then 
      .pStreamSamples = CAllocate(1152*(_Plugs(_Plug).Fmt.nBits\8)*_Plugs(_Plug).Fmt.nChannels * 4)
    End If  
    
    .pPlay = .pStart
    
    mad_stream_init(@.mStream)
    mad_frame_init (@.mFrame)
    mad_synth_init (@.mSynth)
    
    .InUse = True
  End With
  Return True
End Function

Function FBS_Play_MP3Stream (ByVal Volume  As Single , _
                             ByVal Pan     As Single) As Boolean  API_EXPORT

  If _MP3Stream.InUse=False Then Return False
  
  If (_MP3Stream.IsStreaming=True) Then
    dprint("FBS_Play_MP3Stream while IsStreaming=true!")
    FBS_End_MP3Stream()
    _MP3Stream.IsStreaming=False
  End If

  FBS_Set_MP3StreamVolume Volume
  FBS_Set_MP3StreamPan    Pan
  
  _MP3Stream.p16     = CPtr(Short Ptr, _MP3Stream.pStart)
  _MP3Stream.pPlay   = _MP3Stream.pStart
  _MP3Stream.hThread = ThreadCreate(CPtr(Any Ptr, @_MP3StreamingThread),0)
 
  If _MP3Stream.hThread=NULL Then 
    dprint("FBS_Play_MP3Stream: error ThreadCreate!")
    Return False
  Else
    ' wait on start of decoder
    While (_MP3Stream.IsStreaming=False)
      Sleep(1,1)
    Wend
  End If
  
  Return True
End Function

Function FBS_Get_MP3StreamBuffer(ByVal ppBuffer  As Short Ptr Ptr, _
                                 ByVal pnChannels As Integer Ptr  , _
                                 ByVal pnSamples  As Integer Ptr  ) As Boolean  API_EXPORT
  If _MP3Stream.InUse = False Then Return False
  *ppBuffer  = CPtr(Short Ptr,_MP3Stream.pPlay)
  *pnChannels = _Plugs(_Plug).Fmt.nChannels
  *pnSamples  = _Plugs(_Plug).BufferSize Shr _Plugs(_Plug).Fmt.nChannels
   Return True
End Function

Function FBS_End_MP3Stream() As Boolean  API_EXPORT
  If (_MP3Stream.InUse=False) Then Return True

  ' end streaming
  _MP3Stream.IsStreaming=False
  If _MP3Stream.hThread<>0 Then
    ThreadWait _MP3Stream.hThread
    _MP3Stream.hThread=0
  End If 
  _MP3Stream.InUse=False
   Return True
End Function

#endif ' NO_MP3

#ifndef NO_SID

'  ##############
' # SID Stream #
'##############

Private _
Sub _SIDStreamingThread(ByVal dummy As Any Ptr)
  dprint("_SIDStreamingThread()")
  If (_SIDStream.InUse=False) Then Exit Sub
  
  _SIDStream.IsStreaming=True

  ' loop over the whole stream
  While (_SIDStream.IsStreaming = True)
    If (_SIDStream.bFillbuffer=True) Then
      libcsid_render(_SIDStream.pPlay,_Plugs(_Plug).Fmt.nChannels,_Plugs(_Plug).BufferSize)
      _SIDStream.nOuts=_Plugs(_Plug).BufferSize
      _SIDStream.bFillbuffer=False
    Else
      While (_SIDStream.IsStreaming = True) And (_SIDStream.bFillbuffer=False)
        Sleep(1,1)
      Wend  
    End If  
  Wend
 
  dprint("_SIDStreamingThread~")
End Sub

Function FBS_Set_SIDStreamVolume(ByVal Volume As Single) As Boolean  API_EXPORT
  If _SIDStream.InUse=False Then Return False  
  If Volume>2.0    Then Volume=2.0
  If Volume<0.0001 Then Volume=0.0
  _SIDStream.Volume=Volume
   Return True
End Function

Function FBS_Get_SIDStreamVolume(ByVal pVolume As Single Ptr) As Boolean  API_EXPORT
  If _SIDStream.InUse = False Then Return False  
  If pVolume = NULL Then Return False  
  *pVolume = _SIDStream.Volume
   Return True
End Function

Function FBS_Set_SIDStreamPan(ByVal Pan As Single) As Boolean  API_EXPORT
  If _SIDStream.InUse=False Then Return False  
  If Pan<-1.0 Then Pan=-1.0
  If Pan> 1.0 Then Pan= 1.0
  _SIDStream.Pan = Pan
  If Pan>=0.0 Then _SIDStream.rVolume=1 Else _SIDStream.rVolume=Pan+1.0
  If Pan<=0.0 Then _SIDStream.lVolume=1 Else _SIDStream.lVolume=1.0-Pan
   Return True
End Function

Function FBS_Get_SIDStreamPan(ByVal pPan As Single Ptr) As Boolean  API_EXPORT
  If pPan = NULL Then Return False  
  If _SIDStream.InUse = False Then Return False  
  *pPan = _SIDStream.Pan
  Return True
End Function

Function FBS_Create_SIDStream (ByRef Filename As WString, _
                               ByVal PlayTune As Integer, _
                               ByVal pTunes As Integer Ptr) As Boolean  API_EXPORT
  If _IsInit          = False Then Return False   ' not init
  If _SIDStream.InUse = True  Then Return False  
  
  Var hFile = FreeFile()
  If Open(Filename,For Binary,Access Read,As #hFile) Then
    dprint("FBS_Create_SIDStream error: can't open SID stream: '" & Filename & " !")
    Return False
  End If
  
  Var nBytes = LOF(hFile)
  If nBytes<255 Then
    Close #hFile
    dprint("FBS_Create_SIDStream error: empty SID stream: '" & Filename & " !")
    Return False
  End If
  
  Dim As UByte Ptr buffer = Allocate(nBytes)
  Get #hFile,,*buffer,nBytes
  Close #hFile

  libcsid_init(_Plugs(_Plug).Fmt.nRate, DEFAULT_SIDMODEL)
  If PlayTune<0 Then PlayTune=0
  Dim As Integer nTunes = buffer[&H0f]
  If PlayTune<0 Then
    PlayTune=0
  ElseIf nTunes>0 Then
    If PlayTune>=nTunes Then
      PlayTune=nTunes-1
    End If
  End If  
  
  nTunes = libcsid_load(buffer,nBytes,PlayTune)
  Deallocate buffer
  If pTunes Then *pTunes=nTunes
 
  With _SIDStream
    .IsStreaming  = False
    .IsFin        = False
    .hThread      = 0
    .nOuts        = 0
    .Volume       = 1.0
    .Pan          = 0.0
    If (.pStart = NULL) Then
      .pStart = CAllocate(_Plugs(_Plug).BufferSize)
      .pEnd   = .pStart + _Plugs(_Plug).BufferSize
    End If
    If (.pBuf = NULL) Then 
      .pBuf = CAllocate(_Plugs(_Plug).BufferSize+512)
    End If
    
    .pPlay = .pStart
    
    .InUse = True
  End With
  Return True
End Function

Function FBS_Play_SIDStream (ByVal Volume  As Single , _
                             ByVal Pan     As Single) As Boolean  API_EXPORT

  If _SIDStream.InUse=False Then 
    dprint("FBS_Play_SIDStream() called without FBS_Create_SIDStream() before ! ")
    Return False
  End If  
  If (_SIDStream.IsStreaming=True) Then 
    dprint("FBS_Play_SIDStream() called without FBS_Stop_SIDStream() before ! ")
    Return False
  End If  

  FBS_Set_SIDStreamVolume(Volume)
  FBS_Set_SIDStreamPan(Pan)

  _SIDStream.pPlay = _SIDStream.pStart

  _SIDStream.hThread = ThreadCreate(CPtr(Any Ptr, @_SIDStreamingThread),0)
  If _SIDStream.hThread=NULL Then 
    dprint("FBS_Play_SIDStream(): error ThreadCreate!")
    Return False
  Else
    ' wait on start of thread
    While (_SIDStream.IsStreaming=False)
      Sleep(1,1)
    Wend
    ' fill first buffer
    _SIDStream.bFillbuffer = True
  End If

  Return True
End Function

Function FBS_Get_SIDStreamBuffer(ByVal ppBuffer  As Short Ptr Ptr, _
                                 ByVal pnChannels As Integer Ptr  , _
                                 ByVal pnSamples  As Integer Ptr  ) As Boolean  API_EXPORT
  If _SIDStream.InUse = False Then Return False
  *ppBuffer  = CPtr(Short Ptr,_SIDStream.pPlay)
  *pnChannels = _Plugs(_Plug).Fmt.nChannels
  *pnSamples  = _Plugs(_Plug).BufferSize Shr _Plugs(_Plug).Fmt.nChannels
   Return True
End Function

Function FBS_End_SIDStream() As Boolean  API_EXPORT
  If (_SIDStream.InUse=False) Then Return True

  ' end streaming
  If _SIDStream.IsStreaming=True Then
    _SIDStream.IsStreaming=False
    If _SIDStream.hThread<>0 Then
      ThreadWait _SIDStream.hThread
    _SIDStream.hThread=0
    End If
  End If  
  _SIDStream.InUse=False
   Return True
End Function

Function FBS_Get_SIDAuthor() As String API_EXPORT
  Dim As String ret
  If (_SIDStream.InUse=True) Then
    Dim As Const ZString Ptr p=libcsid_getauthor()
    If p Then ret=*p
  End If
  Return ret 
End Function

Function FBS_Get_SIDInfo() As String API_EXPORT
  Dim As String ret
  If (_SIDStream.InUse=True) Then
    Dim As Const ZString Ptr p=libcsid_getinfo()
    If p Then ret=*p
  End If
  Return ret 
End Function

Function FBS_Get_SIDTitle() As String API_EXPORT
  Dim As String ret
  If (_SIDStream.InUse=True) Then
    Dim As Const ZString Ptr p=libcsid_gettitle()
    If p Then ret=*p
  End If
  Return ret 
End Function

#endif 'NO_SID


#ifndef NO_MOD

' create hWave from *.it *.xm *.sm3 or *.mod file
Function FBS_Load_MODFile(ByRef Filename As WString     , _
                          ByVal hWave    As Integer Ptr) As Boolean  API_EXPORT
  dprint("FBS_Load_MODFile()")
  If hWave=NULL  Then Return False  
  *hWave=-1
  If _IsInit=False Then Return False

  Dim As Any Ptr duh = dumb_load_mod(Filename)
  If duh=0 Then duh = dumb_load_s3m(Filename)
  If duh=0 Then duh = dumb_load_it(Filename)
  If duh=0 Then duh = dumb_load_xm(Filename)
  If duh=0 Then duh = load_duh(Filename)
  If duh=0 Then 
    dprint("FBS_Load_MODFile module loading failed!")
    Return False
  End If
  
  Dim As Single l=duh_get_length(duh)
  l/=65536.0
  'dprint("FBS_Load_MODFile length = " & l)
  
  Var mod_ = duh_start_sigrenderer(duh,0,_Plugs(_Plug).Fmt.nChannels,0)
  If mod_=0 Then 
    dprint("FBS_Load_MODFile start wave renderer failed!")
    unload_duh duh
    Return False
  End If

  Var it=duh_get_it_sigrenderer(mod_)

  If (it) Then
    dumb_it_set_loop_callback         (it,@dumb_it_callback_terminate,NULL)
    dumb_it_set_xm_speed_zero_callback(it,@dumb_it_callback_terminate,NULL)
  Else
    dprint("FBS_Load_MODFile get_it_sigrenderer failed!")
  End If
  
  Dim As Single  delta       = 65536.0/_Plugs(_Plug).Fmt.nRate
  Dim As Integer nSamples    = 0, WritePos=0,nBytes=0
  Dim As Integer nBufferSize = 4096*_Plugs(_Plug).Framesize
  Dim As Any Ptr pBuffer = Allocate(nBufferSize)
  If pBuffer=NULL Then
     unload_duh duh
     dprint("error: FBS_Load_MODFile out of memeory !")
     Return False
  End If  

  Dim As Integer nAllocatedBytes = l * _Plugs(_Plug).Fmt.nRate * _Plugs(_Plug).Framesize
  Dim As UByte Ptr pSamples = Allocate(nAllocatedBytes)
  If pSamples=NULL Then
     unload_duh duh
     Deallocate pBuffer
     dprint("error: FBS_Load_MODFile out of memeory !")
     Return False
  End If  

 #ifndef NO_CALLBACK
  Dim As Single   percent=100.0/nAllocatedBytes
  Dim As Integer  pold,pnew
 #endif

 
  Dim As Integer ret=1
  While ret>0
    ret=duh_render(mod_,_Plugs(_Plug).Fmt.nBits,0,1.0,delta,4096,pBuffer)
    If ret>0 Then
      Dim As Integer nNewBytes=ret*_Plugs(_Plug).Framesize
      nBytes+=nNewBytes
      
 #ifndef NO_CALLBACK
      If CBool(_LoadCallback<>NULL) AndAlso (_EnabledLoadCallback=True) Then
        pnew = percent * nBytes
        If (pnew<>pold) Then
          _LoadCallback(pnew)
          pold=pnew
        End If
      End If
 #endif
      
      If nBytes>nAllocatedBytes Then
        dprint("FBS_Load_MODFile buffer realloction !")
        pSamples=Reallocate(pSamples,nBytes)
      End If
      
      Copy(@pSamples[WritePos], pBuffer, nNewBytes)
      WritePos+=nNewBytes
      nSamples+=ret
    End If
    
  Wend
  duh_end_sigrenderer mod_
  unload_duh duh
  If nSamples=0 Then
    If pBuffer  Then Deallocate pBuffer:pBuffer=0
    If pSamples Then Deallocate pSamples:pSamples=0
    dprint("FBS_Load_MODFile error: got 0 Samples !")
    Return False
  End If

  Dim As Any Ptr pWave
  If FBS_Create_Wave(nSamples,hWave,@pWave) Then
    Copy(pWave,pSamples,nBytes)
  Else
    If pBuffer  Then Deallocate pBuffer :pBuffer =0
    If pSamples Then Deallocate pSamples:pSamples=0
    dprint("FBS_Load_MODFile FBS_Create_Wave(" & nSamples & ") failed !")
    Return False
  End If

  If pBuffer  Then Deallocate pBuffer :pBuffer =0
  If pSamples Then Deallocate pSamples:pSamples=0
  dprint("FBS_Load_MODFile~")
  Return True
End Function

#endif ' NO_MOD


#ifndef NO_OGG
' OGG 
Type OGG_BUFFER
  As UByte Ptr pBuffer
  As Integer   size
  As Integer   index
End Type

' file i/o callbacks
Private _
Function _oggReadcb cdecl (ByVal pBuffer  As Any Ptr, _
                           ByVal ByteSize As Integer, _
                           ByVal nBytes   As Integer, _
                           ByVal pUser    As Any Ptr) As Integer
  Var f = CPtr(OGG_BUFFER Ptr, pUser)
  Var pDes = CPtr(UByte Ptr ,pBuffer)
  Dim As UByte Ptr pSrc = f->pBuffer
  Dim As Integer rest   = f->Size - f->Index

  pSrc += f->Index
  If nBytes > rest Then nBytes=rest
  If nBytes = 0 Then Return 0
  Copy(pDes, pSrc, nBytes)
  f->Index += nBytes
  Return nBytes
End Function

Private _
Function _oggSeekcb cdecl (ByVal pUser As Any Ptr, ByVal offset As LongInt, ByVal whence As Long) As Long
  Var f = CPtr(OGG_BUFFER Ptr,pUser)
  Select case As Const whence
    Case 0 : f->Index = offset    ' SEEK_SET
    Case 1 : f->Index+= offset    ' SEEK_CUR
    Case 2 : f->Index = f->Size-1 ' SEEK_END (-1 byte)
  End Select
  Return f->Index
End Function

Private _
Function _oggClosecb cdecl (ByVal pUser As Any Ptr) As Long
  Var f = CPtr(OGG_BUFFER Ptr,pUser)
  Return 1
End Function

Private _
Function _oggTellcb cdecl (ByVal pUser As Any Ptr) As clong
  Var f = CPtr(OGG_BUFFER Ptr,pUser)
  Return f->index
End Function

Function FBS_Load_OGGFile(ByRef Filename As WString , _
                          ByVal phWave  As Integer Ptr , _
                          ByRef _usertmpfile_  As String) As Boolean  API_EXPORT
 

  ' free memoryfile
  If (pOGG<>NULL) Then Deallocate pOGG : pOGG = NULL
  ' no error load temp wav
  If ret=0 Then
    If FBS_Load_WAVFile(outtmp, phWave)=True Then
      Kill outtmp
      Return True
    Else
      Kill outtmp
      *phWave=-1
      Return False
    End If
  Else
    Kill outtmp
    *phWave=-1
    Return False
  End If
End Function
#endif ' NO_OGG

Private _
Function _IshWave(ByVal hWave As Integer) As Boolean
  If (_IsInit=False)               Then Return False  ' not init
  If (_nWaves<1)                   Then Return False  ' no waves
  If (hWave<0) Or (hWave>=_nWaves) Then Return False  ' no legal hWave
  If _Waves(hWave).pStart = NULL   Then Return False  ' reloaded wave
  If _Waves(hWave).nBytes  < 1     Then Return False  ' reloaded wave
   Return True
End Function

Private _
Function _IshSound(ByVal hSound As Integer) As Boolean
  If (_IsInit=False)                  Then Return False ' not init
  If (_nWaves<1)                      Then Return False ' no waves
  If (_nSounds<1)                     Then Return False ' no sound created
  If (hSound<0) Or (hSound>=_nSounds) Then Return False ' no legal hSound
  If (_Sounds(hSound).pStart=NULL)    Then Return False ' free old sound
  If (_Sounds(hSound).pBuf  =NULL)    Then Return False ' free old sound
  Return True
End Function

Function FBS_Destroy_Wave(ByVal phWave As Integer Ptr) As Boolean  API_EXPORT
  Dim As Integer hWave,hSound
  If (phWave=NULL) Then Return False  
  hWave = *phWave
  If _IshWave(hWave)=False Then Return False  

  If (_nSounds>0) Then
    For hSound=0 To _nSounds-1
      If _IshSound(hSound)=True Then
        If _Sounds(hSound).pStart=_Waves(hWave).pStart Then
          If CBool(_Sounds(hSound).nLoops>0) And (_Sounds(hSound).paused=False) Then 
            _Sounds(hSound).paused=True
            _Sounds(hSound).nLoops=0
            ' !!! sleep 10 'wait if playing
          End If
          _Sounds(hSound).nLoops=0
          _Sounds(hSound).pStart=NULL
          If (_Sounds(hSound).pBuf<>NULL) Then
            If (_Sounds(hSound).pBuf=_Sounds(hSound).pOrg) Then
              Deallocate _Sounds(hSound).pBuf
              _Sounds(hSound).pBuf=NULL
              _Sounds(hSound).pOrg=NULL
            Else
            dprint("!!! pointer value are corrupt !!!")
            End If
          End If
          ' !!! if _Sounds(hSound).lphSound<>NULL then *_Sounds(hSound).lphSound=-1
        End If
      End If
    Next
  End If
  If (_Waves(hWave).pStart<>NULL) Then 
    Deallocate _Waves(hWave).pStart
    _Waves(hWave).pStart=NULL
  End If
  _Waves(hWave).nBytes=0
  *phWave=-1
   Return True
End Function

Function FBS_Destroy_Sound(ByVal phSound As Integer Ptr) As Boolean  API_EXPORT
  If (phSound=NULL)         Then Return False  
  Var hSound = *phSound
  If _IshSound(hSound)=False Then Return False  
  If _Sounds(hSound).nLoops>0 Then 
    _Sounds(hSound).paused=True
    _Sounds(hSound).nLoops=0
    ' !!! sleep 100 'wait if playing 
  End If
  _Sounds(hSound).pStart=NULL
  If (_Sounds(hSound).pBuf<>NULL) Then
    If (_Sounds(hSound).pBuf=_Sounds(hSound).pOrg) Then
      Deallocate _Sounds(hSound).pBuf
      _Sounds(hSound).pBuf=NULL
      _Sounds(hSound).pOrg=NULL
    Else
      dprint("!!! pointer value are corrupt !!!")
    End If
  End If  
  *phSound = -1
   Return True
End Function

Function FBS_Set_SoundSpeed(ByVal hSound As Integer, _
                            ByVal Speed  As Single) As Boolean  API_EXPORT

  If _IshSound(hSound)=False Then Return False   ' not init

  If Speed>0.0 Then
    If Speed<+0.0000015258 Then 
      Speed=-0.0000015258
    ElseIf Speed>16383.0 Then
      Speed=16383.0
    End If 
  ElseIf Speed<0.0 Then
    If Speed>-0.0000015258 Then 
      Speed=0.0000015258
    ElseIf Speed<-16383.0 Then
      Speed=-16383.0
    End If
  End If
  If Speed=0 Then Speed=1
  _Sounds(hSound).Speed=Speed
   Return True
End Function

Function FBS_Get_SoundSpeed(ByVal hSound As Integer , _
                            ByVal pSpeed  As Single Ptr) As Boolean  API_EXPORT
  If pSpeed=NULL Then Return False  
  If _IshSound(hSound)=False Then Return False  
  *pSpeed = _Sounds(hSound).Speed
  Return True
End Function

function FBS_Set_SoundVolume(byval hSound as integer, _
                             byval Volume as single) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  if Volume>2.0    then Volume=2.0
  if Volume<0.0001 then Volume=0.0
  _Sounds(hSound).Volume=Volume
  return true
end function

function FBS_Get_SoundVolume(byval hSound as integer , _
                             byval pVolume as single ptr) as boolean  API_EXPORT
  if pVolume=NULL then return false  
  if _IshSound(hSound)=false then return false  
  *pVolume = _Sounds(hSound).Volume
  return true
end function

function FBS_Set_SoundPan(byval hSound as integer, _
                          byval Pan    as single) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false
  if Pan<-1.0 then Pan=-1.0
  if Pan> 1.0 then Pan= 1.0
  _Sounds(hSound).Pan=Pan
  if Pan>=0.0 then _Sounds(hSound).rVolume=1 else _Sounds(hSound).rVolume=Pan+1.0
  if Pan<=0.0 then _Sounds(hSound).lVolume=1 else _Sounds(hSound).lVolume=1.0-Pan
  return true
end function

function FBS_Get_SoundPan(byval hSound as integer, _
                          byval pPan as single ptr) as boolean  API_EXPORT
  if pPan=NULL then return false  
  if _IshSound(hSound) = false then return false  
  *pPan = _Sounds(hSound).Pan
   return true
end function

function FBS_Set_SoundLoops(byval hSound as integer, _
                            byval nLoops as integer=1) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false   ' not init
  if nLoops<0 then nLoops=&H7FFFFFFF ' endless !!!
  _Sounds(hSound).nLoops=nLoops
  return true
end function
function FBS_Get_SoundLoops(byval hSound as integer, _
                            byval pnLoops as integer ptr) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false
  if pnLoops=NULL            then return false
  *pnLoops = _Sounds(hSound).nLoops
  return true
end function

function FBS_Set_SoundMuted(byval hSound as integer, _
                            byval Muted  as boolean) as boolean  API_EXPORT
  if _IshSound(hSound)=false   then return false   ' not init
  _Sounds(hSound).Muted=Muted
  return true
end function
function FBS_Get_SoundMuted(byval hSound as integer, _
                            byval pMuted  as boolean ptr) as boolean  API_EXPORT
  if pMuted=NULL                then return false  
  if _IshSound(hSound)=false   then return false  
  *pMuted = _Sounds(hSound).Muted
  return true
end function

function FBS_Set_SoundPaused(byval hSound as integer, _
                             byval Paused as boolean) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  _Sounds(hSound).Paused=Paused
  return true
end function
function FBS_Get_SoundPaused(byval hSound as integer, _
                             byval pPaused as boolean ptr) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false
  if (pPaused=NULL)           then return false
  *pPaused = _Sounds(hSound).Paused
  return true
end function

function fbs_Get_WavePointers(byval hWave       as integer            , _
                              byval ppWaveStart as short ptr ptr=NULL , _
                              byval ppWaveEnd   as short ptr ptr=NULL , _
                              byval pnChannels  as integer ptr  =NULL ) as boolean  API_EXPORT
  if _IshWave(hWave)=false then return false
  if (ppWaveStart<>NULL) then *ppWaveStart = cptr(short ptr,_Waves(hWave).pStart)
  if (ppWaveEnd  <>NULL) then *ppWaveEnd   = cptr(short ptr,_Waves(hWave).pStart+_Waves(hWave).nBytes)
  if (pnChannels <>NULL) then *pnChannels  =_Plugs(_Plug).fmt.nChannels
  return true
end function

function fbs_Get_SoundPointers(byval hSound    as integer       , _
                               byval ppStart as short ptr ptr=NULL , _
                               byval ppPlay  as short ptr ptr=NULL , _
                               byval ppEnd   as short ptr ptr=NULL) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false
  if (ppStart<>NULL) then *ppStart  =cptr(short ptr,_Sounds(hSound).pUserStart)
  if (ppPlay <>NULL) then *ppPlay   =cptr(short ptr,_Sounds(hSound).pPlay     )
  if (ppEnd  <>NULL) then *ppEnd    =cptr(short ptr,_Sounds(hSound).pUserEnd  )
  return true
end function

function fbs_Get_SoundPosition(byval hSound    as integer, _
                               byval pPosition as single ptr) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  if (pPosition=NULL) then return false  
  *pPosition=0.0
  dim as short ptr ps=any,pp=any,pe=any
  if fbs_Get_SoundPointers(hSound,@ps,@pp,@pe)=false then return false
  dim as integer _s=cast(integer,ps)
  dim as integer _p=cast(integer,pp)
  dim as integer _e=cast(integer,pe)
  _e-=_s
  if _e>0 then
    _p-=_s
    if _p>0 then *pPosition=1.0/(_e/_p)
  end if
  return true
end function

function fbs_Set_SoundPointers(byval hSound    as integer , _
                               byval pNewStart as short ptr=NULL, _
                               byval pNewPlay  as short ptr=NULL, _
                               byval pNewEnd   as short ptr=NULL) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false
  dim as byte ptr pNew

  ' check start
  if pNewStart<>NULL then
   pNew=cptr(byte ptr,pNewStart)
    if pNew<_Sounds(hSound).pStart then
      _Sounds(hSound).pUserStart=_Sounds(hSound).pStart
    elseif pNew>=_Sounds(hSound).pEnd then
      _Sounds(hSound).pUserStart=_Sounds(hSound).pEnd-4
    else
      _Sounds(hSound).pUserStart=pNew
    end if
  end if

  ' check end
  if pNewEnd<>NULL then
    pNew=cptr(byte ptr,pNewEnd)
    if pNew<=_Sounds(hSound).pStart then
      _Sounds(hSound).pUserEnd=_Sounds(hSound).pStart+4
    elseif pNew>_Sounds(hSound).pEnd then
      _Sounds(hSound).pUserEnd=_Sounds(hSound).pEnd
    else
      _Sounds(hSound).pUserEnd=pNew
    end if
  end if
  ' in right order ?
  if _Sounds(hSound).pUserStart>_Sounds(hSound).pUserEnd then
    swap _Sounds(hSound).pUserStart,_Sounds(hSound).pUserEnd
  end if

  ' check pos
  if pNewPlay<>NULL then
    pNew=cptr(byte ptr,pNewPlay)
    if pNew<=_Sounds(hSound).pUserStart then
      _Sounds(hSound).pPlay=_Sounds(hSound).pUserStart
    elseif pNew>_Sounds(hSound).pUserEnd then
      _Sounds(hSound).pPlay=_Sounds(hSound).pUserEnd
    else
      _Sounds(hSound).pPlay=pNew
    end if
  else
    if _Sounds(hSound).pPlay>=_Sounds(hSound).pUserEnd then
      _Sounds(hSound).pPlay=_Sounds(hSound).pUserStart
    end if
  end if

  return true
end function


function fbs_Get_WaveLength(byval hWave as integer , _
                            byval lpMS  as integer ptr) as boolean  API_EXPORT
   if _IshWave(hWave)=false then return false
   if (lpMS=NULL) then return false
   dim as double ms
  ' bytes
  MS=_Waves(hWave).nBytes
  ' samples 
  MS/=_Plugs(_Plug).Framesize
  MS*=1000
  MS/=_Plugs(_Plug).Fmt.nRate
  *lpMS=int(ms)
   return true
end function

function fbs_Get_SoundLength(byval hSound as integer, _
                             byval pMS   as integer ptr) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  if (pMS=NULL) then return false
  dim as double ms
  ' bytes
  MS=_Sounds(hSound).pUserEnd-_Sounds(hSound).pUserStart
  ' samples
  MS/=_Plugs(_Plug).Framesize
  MS*=1000
  MS/=int(_Sounds(hSound).Speed*_Plugs(_Plug).Fmt.nRate)
  if _Sounds(hSound).nLoops>1 then
    MS*=_Sounds(hSound).nLoops
  end if
  *pMS = int(ms)
  return true
end function

function FBS_Play_Wave(byval hWave  as integer           , _
                       byval nLoops as integer     = 1   , _
                       byval Speed  as single      = 1.0 , _
                       byval Volume as single      = 1.0 , _
                       byval Pan    as single      = 0.0 , _
                       byval hSound as integer ptr = NULL) as boolean  API_EXPORT

  if _IshWave(hWave)=false then return false ' not a right hWave
  if nLoops<1 then nLoops=&H7FFFFFFF
  if Speed>0.0 then
    if Speed<+0.0000015258 then 
      Speed= -0.0000015258
    elseif Speed>16383.0 then
      Speed=16383.0
    end if  
  elseif Speed<0.0 then
    if Speed>-0.0000015258 then 
      Speed=0.0000015258
    elseif Speed<-16383.0 then
      Speed=-16383.0
    end if
  end if
  if (speed=0.0) then speed=1.0
  if (pan <-1.0) then pan=-1.0
  if (pan > 1.0) then pan= 1.0

  var index=-1
  if (_nSounds>0) then
    ' search free sound object
    for i as integer = 0 to _nSounds-1
      if _Sounds(i).pStart = NULL then index = i:exit for
    next
  end if
  
  if index = -1 then
    ' add new sound object
    index = _nSounds : redim preserve _Sounds(_nSounds) : _nSounds+=1
  end if
  with _Sounds(index)
    .pStart     = _Waves(hWave).pStart
    .pPlay      = .pStart
    .pEnd       = .pStart + _Waves(hWave).nBytes
    ' added user pointers
    .pUserStart = .pStart
    .pUserEnd   = .pEnd

    if .pBuf=NULL then 
      .pBuf = callocate(_Plugs(_Plug).Buffersize+512)
      if (.pBuf=NULL) then
        dprint( "fbs_play_wave: ERROR out of memory !")
        beep : sleep : end 1
      else
        .pOrg = .pBuf
      end if
    end if
  #ifndef NO_CALLBACK
    .Callback       = NULL
    .EnabledCallback= false
  #endif
    .nLoops = nLoops
    .Speed  = Speed
    .Volume = Volume
    .Paused = false
    .Muted  = false

    FBS_Set_SoundPan(index,Pan)
    if hSound <> NULL then 
      .phSound    = hSound
      .Usercontrol = true
      *hSound = index
    else
      .phSound    = NULL
      .Usercontrol = false
    end if
  end with
  return true
end function

function FBS_Create_Sound(byval hWave  as integer  , _
                          byval hSound as integer ptr) as boolean  API_EXPORT
  if hSound = NULL           then return false  
  if _IshWave(hWave) = false then return false   ' not a right hWave
  dim as integer index = -1
  if _nSounds>0 then
    ' search free sound object in sound pool
    for i as integer = 0 to _nSounds-1
      if _Sounds(i).pStart = NULL then index = i : exit for
    next
  end if
  
  if index = -1 then
    ' add new sound object
    index = _nSounds : redim preserve _Sounds(_nSounds) : _nSounds += 1
  end if
  with _Sounds(index)
    .pStart = _Waves(hWave).pStart
    .pPlay  = _Waves(hWave).pStart
    .pEnd   = _Waves(hWave).pStart + _Waves(hWave).nBytes
    ' user pointers
    .pUserStart = .pStart
    .pUserEnd   = .pEnd
    if .pBuf = NULL then 
      .pBuf = callocate(_Plugs(_Plug).Buffersize+512)
      if (.pBuf = NULL) then
        dprint("fbs_create_sound: ERROR out of memory !")
        beep : sleep : end 1
      else
        .pOrg = .pBuf
      end if
    end if
#ifndef NO_CALLBACK
    .Callback       = NULL
    .EnabledCallback= false
#endif
    .nLoops         = 0
    .Speed          = 1.0
    .Volume         = 1.0
    .Paused         = false
    .Muted          = false
    FBS_Set_SoundPan(index,0.0)
    .phSound       = hSound
    .Usercontrol    = true
  end with
  *hSound = index
  return true
end function

function FBS_Play_Sound(byval hSound as integer    , _
                        byval nLoops as integer = 1) as boolean  API_EXPORT
  if _IshSound(hSound) = false then return false  
  if nLoops<1 then nLoops = &H7FFFFFFF
  with _Sounds(hSound)
    .pPlay  = .pStart
    .nLoops = nLoops
  end with  
  return true
end function

#ifndef NO_CALLBACK

'  #############################
' # Section of user Callbacks #
'#############################

' load
function FBS_Set_LoadCallback(byval pCallback as FBS_LOADCALLBACK) as boolean  API_EXPORT
  if (_IsInit = false) then return false
  _EnabledLoadCallback = false
  _LoadCallback = pCallback
   return true
end function
function FBS_Enable_LoadCallback() as boolean  API_EXPORT
  if (_IsInit = false) then _EnabledLoadCallback = false : return false
  _EnabledLoadCallback = true
  return true
end function
function FBS_Disable_LoadCallback() as boolean  API_EXPORT
  if (_IsInit = false) then _EnabledLoadCallback = false : return false
  _EnabledLoadCallback = false
  return true
end function

' master
function FBS_Set_MasterCallback(byval lpCallback as FBS_BUFFERCALLBACK) as boolean  API_EXPORT
  if (_IsInit = false) then return false
  _EnabledMasterCallback = false
  _MasterCallback = lpCallBack
   return true
end function
function FBS_Enable_MasterCallback() as boolean  API_EXPORT
  if (_IsInit = false) then _EnabledMasterCallback = false : return false
  if (_MasterCallback=0) then _EnabledMasterCallback = false : return false
  _EnabledMasterCallback = true
  return true
end function
function FBS_Disable_MasterCallback() as boolean  API_EXPORT
  if (_IsInit = false) then _EnabledMasterCallback = false : return false
  _EnabledMasterCallback = false
  return true
end function

' sound
function FBS_Set_SoundCallback(byval hSound    as integer, _
                               byval pCallback as FBS_BUFFERCALLBACK) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  _Sounds(hSound).EnabledCallback = false
  _Sounds(hSound).Callback = pCallBack
   return true
end function
function FBS_Enable_SoundCallback(byval hSound as integer) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  if _Sounds(hSound).Callback = NULL then return false  
  _Sounds(hSound).EnabledCallback = true
  return true
end function
function FBS_Disable_SoundCallback(byval hSound as integer) as boolean  API_EXPORT
  if _IshSound(hSound)=false then return false  
  if _Sounds(hSound).Callback = NULL then return false  
  _Sounds(hSound).EnabledCallback = false
  return true
end function

 #ifndef NO_MP3
function FBS_Set_MP3StreamCallback(byval pCallback as FBS_BUFFERCALLBACK) as boolean  API_EXPORT
  if _MP3Stream.InUse = false then return false  
  _MP3Stream.EnabledCallback = false
  _MP3Stream.Callback = pCallBack
  return true
end function
function FBS_Enable_MP3StreamCallback() as boolean  API_EXPORT
  if _MP3Stream.InUse = false then return false  
  if _MP3Stream.Callback = NULL then return false  
  _MP3Stream.EnabledCallback = true
  return true
end function
function FBS_Disable_MP3StreamCallback() as boolean  API_EXPORT
  if _MP3Stream.InUse = false then return false  
  if _MP3Stream.Callback = NULL then return false  
  _MP3Stream.EnabledCallback = false
  return true
end function
 #endif ' NO_MP3

 #ifndef NO_SID
function FBS_Set_SIDStreamCallback(byval pCallback as FBS_BUFFERCALLBACK) as boolean  API_EXPORT
  if _SIDStream.InUse = false then return false  
  _SIDStream.EnabledCallback = false
  _SIDStream.Callback = pCallBack
  return true
end function

function FBS_Enable_SIDStreamCallback() as boolean  API_EXPORT
  if _SIDStream.InUse = false then return false  
  if _SIDStream.Callback = NULL then return false  
  _SIDStream.EnabledCallback = true
  return true
end function

function FBS_Disable_SIDStreamCallback() as boolean  API_EXPORT
  if _SIDStream.InUse = false then return false  
  if _SIDStream.Callback = NULL then return false  
  _SIDStream.EnabledCallback = false
  return true
end function
 #endif ' NO_SID
 
#endif ' NO_CALLBACK


