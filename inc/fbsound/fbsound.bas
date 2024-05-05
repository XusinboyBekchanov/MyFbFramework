'  ###############
' # fbsound.bas #
'###############
' Copyright 2005-2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"
#include once "fbsound/fbsound.bi"

#ifndef NO_MOD
 #include once "dumb/dumb.bi"
#endif

#ifndef NO_MP3
 #include once "mad/mad.bi"
#endif

#ifndef NO_SID
 #include once "csid/libcsidlight.bi"
#endif

#ifndef NO_OGG
 #include once "vorbis/codec.bi"
 #include once "vorbis/vorbisenc.bi"
 #include once "vorbis/vorbisfile.bi"
#endif

#include once "fbsound/plug.bi"
#include once "fbsound/plug-static.bi"

#include once "fbsound/fbscpu.bi"

'' always export, even when building a static lib
'' if the end user builds everything static, then
'' it doesn't really matter and if this module is
'' built in to static lib then we want the exports
'' if it is later built in to a shared library 
#define API_EXPORT EXPORT

type enum_mad_flow as mad_flow

#if defined(NO_MP3) and defined(NO_SID)
  ' no streams
#else
 type FBS_STREAM
  as boolean            InUse
  as boolean            IsStreaming
  as boolean            IsFin
  as single             Volume
  as single             lVolume
  as single             rVolume
  as single             Pan
  as FBS_FORMAT         fmt
  as ubyte ptr          pStart,pPlay,pEnd,pBuf
  as integer            nOuts
  as any ptr            hThread
 #ifndef NO_CALLBACK
  as boolean            EnabledCallback
  as FBS_BufferCallback Callback
 #endif
end type

 #ifndef NO_SID
type FBS_SID_STREAM extends FBS_STREAM
  as boolean  bFillbuffer
end type
 #endif ' NO_SID

 #ifndef NO_MP3
type FBS_MP3_STREAM extends FBS_STREAM
  as short ptr          p16,pStreamSamples
  as single             l,r,scale,nPos
  as integer            nSamplesTarget,nBytesTarget,nRest
  as integer            i
  as any ptr            hThread
  as short ptr          pFill
  as integer            RetStatus
  as ubyte ptr          pInArray
  as integer            nReadSize,nReadRest,nDecodedSize
  as ubyte ptr          pRead
  as integer            hFile,nFrames,nBytes,nInSize,nOutSize
  as mad_stream         mStream
  as mad_frame          mFrame
  as mad_synth          mSynth
  as ubyte ptr          GuardPTR
end type
 #endif ' NO_MP3
 

#endif ' NO_MP3 or NO_SID


dim shared _mix                 as mix16_t
dim shared _scale               as scale16_t
dim shared _pan                 as pan16_t
dim shared _copyright           as copyright32_t
dim shared _moveright           as moveright32_t
dim shared _copysliceright      as copysliceright32_t
dim shared _movesliceright      as movesliceright32_t
dim shared _copysliceleft       as copysliceleft32_t
dim shared _movesliceleft       as movesliceleft32_t

#if defined(NO_MP3) and defined(NOSID)
  ' no streams
#else

 #ifndef NO_SID
dim shared _SIDStream           as FBS_SID_STREAM
 #endif
 
 #ifndef NO_MP3
dim shared _MP3Stream           as FBS_MP3_STREAM
dim shared _CopySliceMP3Frame   as CopySliceMP3Frame32_t
dim shared _ScaleMP3FrameStereo as ScaleMP3Frame_22_16_t
dim shared _ScaleMP3FrameMono   as ScaleMP3Frame_12_16_t
 #endif

#endif ' NO_MP3 or NO_SID

#ifndef NO_DSP
dim shared _Filter              as Filter_t
dim shared _MasterFilters(MAX_FILTERS-1) as fbs_filter
 #ifndef NO_PITCHSHIFT
dim shared _PitchShift          as PitchShift_t
 #endif
#endif


dim shared _Sounds()            as FBS_SOUND
dim shared _nSounds             as integer
dim shared _Waves()             as FBS_WAVE
dim shared _nWaves              as integer

dim shared _PlugPath            as string
dim shared _Plugs()             as FBS_Plug
dim shared _nPlugs              as integer
dim shared _Plug                as integer
dim shared _IsRunning           as boolean
dim shared _IsInit              as boolean

dim shared _nPlayingSounds      as integer
dim shared _nPlayingStreams     as integer

dim shared _nPlayedBytes        as integer

#ifndef NO_CALLBACK
dim shared _EnabledMasterCallback as boolean
dim shared _MasterCallback        as fbs_buffercallback
dim shared _EnabledLoadCallback   as boolean
dim shared _LoadCallback          as fbs_loadcallback
#endif

dim shared _MasterBuffer        as any ptr
dim shared _MasterVolume        as single
dim shared _MaxChannels         as integer

'dim shared _seed                as integer

function FBS_Get_PlugPath() as string API_EXPORT
  dprint("FBS_Get_PlugPath() " & _PlugPath)
  return _PlugPath
end function

sub FBS_Set_PlugPath(byval NewPath as string) API_EXPORT
  dprint("FBS_Set_PlugPath(" & NewPath & ")")
  _PlugPath=NewPath
end sub

function FBS_Get_MaxChannels(byval pMaxChannels as integer ptr) as boolean API_EXPORT
  dprint("FBS_Get_MaxChannels()")
  if pMaxChannels=NULL then return false
  *pMaxChannels=_MaxChannels
  return true
end function

function FBS_Set_MaxChannels(byval MaxChannels as integer) as boolean API_EXPORT
  dprint("FBS_Set_MaxChannels(" & MaxChannels & ")")
  if MaxChannels<1   then MaxChannels=  1
  if MaxChannels>512 then MaxChannels=512
  _MaxChannels=MaxChannels
  return true
end function

#ifndef NO_DSP
private _
function _IshFilter(byval hFilter as integer) as boolean
  if (_IsInit=false)                       then return false  
  if (hFilter<0) or (hFilter>=MAX_FILTERS) then return false  
   return true
end function

function FBS_Set_MasterFilter(byval nFilter as integer, _
                              byval Center  as single, _
                              byval dB      as single, _
                              byval Octave  as single = 1.0, _
                              byval OnOff   as boolean=True) as boolean API_EXPORT

  if _IshFilter(nFilter)=false then return false  
  _Set_EQFilter(@_MasterFilters(nFilter), _
                Center, _
                db, _
                octave, _
                _Plugs(_Plug).fmt.nRate)

  _MasterFilters(nFilter).Enabled=OnOff
   return true
end function

function FBS_Enable_MasterFilter (byval nFilter as integer) as boolean API_EXPORT
  if _IshFilter(nFilter)=false then return false
  _MasterFilters(nFilter).Enabled=True
   return true
end function

function FBS_Disable_MasterFilter (byval nFilter as integer) as boolean API_EXPORT
  if _IshFilter(nFilter)=false then return false
  _MasterFilters(nFilter).Enabled=False
   return true
end function

 #ifndef NO_PITCHSHIFT
sub FBS_PitchShift(byval d as short ptr, _      ' output samples
                   byval s as short ptr, _      ' input samples
                   byval v as single   , _      ' value of shift pow(2,note*1.0/12.0)
                   byval n as integer  )  API_EXPORT ' number of samples
  if (_ISInit=false) then exit sub
  _PitchShift(d,s,v,fbs_Get_PlugRate(),n)
end sub
 #endif

#endif ' NO_DSP

private _
sub _MIXER(byval lpOChannels as any ptr, _
           byval lpIChannels as any ptr ptr, _
           byval nChannels   as integer , _
           byval nBytes      as integer )
  dim as integer i
  if nChannels<2 then
    dprint("mixer chn<2")
    exit sub
  end if

  _mix(lpOChannels, lpIChannels[0], lpIChannels[1], nBytes)
  if nChannels=2 then exit sub

  for i=2 to nChannels-1
    _mix(lpOChannels, lpOChannels, lpIChannels[i], nBytes)
  next
end sub

function FBS_Set_MasterVolume(byval Volume as single) as boolean API_EXPORT
  if (_ISInit=false) then return false
  if (Volume<0.001) then
    Volume = 0.0
  elseif (Volume>2.0) then
    Volume = 2.0
  end if  
  _MasterVolume=Volume
  return true
end function

function FBS_Get_MasterVolume(byval lpVolume as single ptr) as boolean API_EXPORT
  if _ISInit=false then return false
  *lpVolume=_MasterVolume
  return true
end function


' called from playback device
private _
sub _FillBuffer(byval pArg as any ptr)
  static as any ptr MixerChannels(512)
  dim as integer i,j,k,nSize,nBytes,rest
  dim as integer nPlayingSounds,nChannels
  dim as integer nPlayingStreams

  ' convert to Plug format
  dim as FBS_Plug ptr plug = cptr(FBS_Plug ptr,pArg)

  'that should never happen
  if (Plug                =NULL) then exit sub
  if (Plug->lpCurentBuffer=NULL) then exit sub
  if (Plug->Buffersize    <   4) then exit sub

  _Masterbuffer = Plug->lpCurentBuffer
  
  _nPlayedBytes += Plug->Buffersize

#if defined(NO_MP3) and defined(NO_SID)
  ' no streams
#else

 #ifndef NO_MP3
  with _MP3Stream
    ' is the MP3 stream active?
    if (.InUse=true) then
         
      ' enought decoded datas aviable
      if (.nOuts >= Plug->Buffersize) then
      
        nPlayingStreams+=1

        if (.pPlay + Plug->Buffersize) <= .pEnd then
                  
          if (.Volume=0.0) then
            ' silence
            zero(.pBuf, Plug->Buffersize)
          else
          
            if (.Volume<>1.0) then _scale(.pPlay,.pPlay,.Volume,Plug->Buffersize)
            
            if (Plug->Fmt.nChannels=2) andalso (.pan<>0.0) then
              _pan(.pBuf,.pPlay, .lVolume, .rVolume, Plug->Buffersize)
            else
              copy(.pBuf,.pPlay,Plug->Buffersize)
            end if
            
          end if
          'dprint("FillBuffer: mix " &  Plug->Buffersize & " bytes from MP3Stream")  
          
          .nOuts -= Plug->Buffersize
          MixerChannels(nChannels) = .pBuf : nChannels += 1
          
  #ifndef NO_CALLBACK
          ' straem user callback
          if cbool(.Callback<>NULL) andalso (.EnabledCallback=true) then
            .Callback(cptr(short ptr,.pBuf), Plug->FMT.nChannels, Plug->Buffersize shr Plug->FMT.nChannels)
          end if
  #endif
          .pPlay += Plug->Buffersize
          if (.pPlay>=.pEnd) then .pPlay=.pStart
          
          if cbool(.nOuts=0) andalso (.IsStreaming=false) then .InUse = False
        end if
        
      else ' (.nOuts<Plug->Buffersize)
        ' dprint("FillBuffer MP3Stream.nOuts: " & .nOuts & " < Plug->Buffersize: " & Plug->Buffersize )
        if cbool(.nOuts=0) andalso (.IsStreaming=false) then 
          '.InUse=false
        end if 
      
      end if
    
    end if ' .InUse=true
    
  end with
 #endif ' NO_MP3

 #ifndef NO_SID
  ' SID stream
  with _SIDStream
    
    ' is the SID stream active?
    if (.InUse=true) then

      ' enought decoded datas aviable
      if (.nOuts >= Plug->Buffersize) then
        
        nPlayingStreams+=1
        
        if (.Volume=0.0) then
          ' silence
          zero(.pBuf, Plug->Buffersize)
        else
          if (.Volume<>1.0) then _scale(.pPlay,.pPlay,.Volume,Plug->Buffersize)
          if (Plug->Fmt.nChannels=2) andalso (.pan<>0.0) then
            _pan(.pBuf,.pPlay, .lVolume, .rVolume, Plug->Buffersize)
          else
            copy(.pBuf,.pPlay,Plug->Buffersize)
          end if
        end if
       'dprint("FillBuffer: mix " &  Plug->Buffersize & " bytes from MP3Stream")  
          
        .nOuts -= Plug->Buffersize
        MixerChannels(nChannels) = .pBuf : nChannels += 1
        if .nOuts <= 0 then .bFillbuffer=true
          
  #ifndef NO_CALLBACK
        ' straem user callback
        if cbool(.Callback<>NULL) andalso (.EnabledCallback=true) then
          .Callback(cptr(short ptr,.pBuf), Plug->FMT.nChannels, Plug->Buffersize shr Plug->FMT.nChannels)
        end if
  #endif
      else
        ' signal get new buffer
        .bFillbuffer=true
      end if
      
    
    end if ' (.InUse=true
    
  end with    
 #endif ' NOSID
#endif ' NO_MP3 or NO_SID

  _nPlayingStreams = nPlayingStreams

  if (_nWaves > 0) andalso (_nSounds > 0) then
    ' how many playing sounds
    for i=0 to _nSounds-1
      if cbool(_Sounds(i).pStart<>NULL) andalso _
         cbool(_Sounds(i).pBuf  <>NULL) andalso _ 
         cbool(_Sounds(i).nLoops > 0   ) andalso _
         (_Sounds(i).Paused=false) then nPlayingSounds+=1
    next
  end if

  _nPlayingSounds =nPlayingSounds

  ' nothing or only one stream are playing?
  if (nPlayingSounds>0) then
  
    for i=0 to _nSounds-1
      ' is sound active ?
      if cbool(_Sounds(i).pStart<>NULL ) andalso _
         cbool(_Sounds(i).pBuf  <>NULL ) andalso _ 
         cbool(_Sounds(i).nLoops  >0    ) andalso _
         (_Sounds(i).Paused  =false) then

        if (_Sounds(i).Muted=false) then 
          MixerChannels(nChannels)=_Sounds(i).pBuf
          nChannels+=1
          if _Sounds(i).Speed=1.0 then 
             _copyright(_Sounds(i).pBuf  , _
                        _Sounds(i).pUserStart, _
                       @_Sounds(i).pPlay , _
                        _Sounds(i).pUserEnd  , _
                       @_Sounds(i).nLoops , _
                        Plug->Buffersize  )

          elseif _Sounds(i).Speed>0.0 then  
            _copysliceright(_Sounds(i).pBuf  , _
                            _Sounds(i).pUserStart, _
                           @_Sounds(i).pPlay , _
                            _Sounds(i).pUserEnd  , _
                           @_Sounds(i).nLoops , _
                            _Sounds(i).Speed  , _
                            Plug->Buffersize  )
          else
            _copysliceleft(_Sounds(i).pBuf  , _
                           _Sounds(i).pUserStart, _
                          @_Sounds(i).pPlay , _
                           _Sounds(i).pUserEnd  , _
                          @_Sounds(i).nLoops , _
                           _Sounds(i).Speed  , _
                           Plug->Buffersize  )
          end if
          if _Sounds(i).Volume<>1.0 then
            _scale(_Sounds(i).pBuf,_Sounds(i).pBuf,_Sounds(i).Volume,Plug->Buffersize)
          end if
          ' paning needs stereo
          if _Plugs(_Plug).Fmt.nChannels=2 then
            if _Sounds(i).pan<>0.0 then
               _pan(_Sounds(i).pBuf  , _
                    _Sounds(i).pBuf  , _
                    _Sounds(i).lVolume, _
                    _Sounds(i).rVolume, _
                    Plug->Buffersize  )
            end if
          end if
          
#ifndef NO_CALLBACK
          ' user sound callback
          if cbool(_Sounds(i).Callback<>NULL) and (_Sounds(i).EnabledCallback=true) then
            _Sounds(i).Callback(cptr(short ptr,_Sounds(i).pBuf), _
                                Plug->FMT.nChannels        , _
                                Plug->Buffersize shr Plug->FMT.nChannels)
          end if
#endif
        else ' only move playpointer
          if (_Sounds(i).Speed=1.0) then
            _moveright(_Sounds(i).pUserStart, _
                      @_Sounds(i).pPlay , _
                       _Sounds(i).pUserEnd  , _
                      @_Sounds(i).nLoops , _
                       Plug->Buffersize)
          elseif (_Sounds(i).Speed>0.0) then
            _movesliceright(_Sounds(i).pUserStart, _
                           @_Sounds(i).pPlay , _
                            _Sounds(i).pUserEnd  , _
                           @_Sounds(i).nLoops , _
                            _Sounds(i).Speed  , _
                            Plug->Buffersize)
          else
            _movesliceleft(_Sounds(i).pUserStart, _
                          @_Sounds(i).pPlay , _
                           _Sounds(i).pUserEnd  , _
                          @_Sounds(i).nLoops , _
                           _Sounds(i).Speed  , _
                           Plug->Buffersize)
          end if    
        end if ' is muted
      end if ' is sound active
      ' soundplayback are ready
      if (_Sounds(i).pStart<>NULL) andalso (_Sounds(i).nLoops<1) then
        ' user has not the hSound handle mark it as free
        if _Sounds(i).UserControl=false then _Sounds(i).pStart=NULL
      end if
      if nChannels=_MaxChannels then exit for
    next
  end if

  if nChannels<1 then
    ' there can be played sounds but muted !
    Zero(Plug->lpCurentBuffer,Plug->Buffersize)
  elseif nChannels=1 then
    ' one channel nothing to mix!
    Copy(Plug->lpCurentBuffer,MixerChannels(0),Plug->Buffersize)
  else
    ' now time to mix MixerChannels[] to Plug->lpCurentBuffer
    _mixer(Plug->lpCurentBuffer,@MixerChannels(0),nChannels,Plug->Buffersize)
  end if
  
  ' must be scaled ?
  if (_MasterVolume<>1.0) then
    _scale(Plug->lpCurentBuffer,Plug->lpCurentBuffer,_MasterVolume,Plug->Buffersize)
  end if

#ifndef NO_DSP
  ' any EQ active
  for i=0 to MAX_FILTERS-1
    if (_MasterFilters(i).Enabled=true) andalso (_MasterFilters(i).dB<>0.0f) then
      _Filter(Plug->lpCurentBuffer, _
              Plug->lpCurentBuffer, _
              @_MasterFilters(i)  , _
              Plug->Buffersize    )
    end if
  next
#endif

#ifndef NO_CALLBACK
  ' user master callback ?
  if cbool(_MasterCallback<>NULL) andalso (_EnabledMasterCallback=true) then
    _MasterCallback(cptr(short ptr,Plug->lpCurentBuffer), _
                    Plug->FMT.nChannels, _
                    Plug->Buffersize shr Plug->FMT.nChannels)

  end if
#endif

end sub

' fill wave header struct 
' return in lpDataPos the file pos of the first sample.
private _
function GetWaveInfo(byval FileName  as string , _
                     byref Hdr       As _PCM_FILE_HDR , _
                     byval lpDataPos as integer ptr) as boolean

  Dim as integer FileSize, fSize, L
  if lpDataPos=NULL then return false
  var hFile = FreeFile()
  if open(FileName for binary access read As #hFile)=0 then
    FileSize = lof(hFile)
    if FileSize > _PCM_FILE_HDR_SIZE then
      get #hFile,, Hdr.ChunkRIFF
      if Hdr.ChunkRIFF = _RIFF then
        get #hFile,, Hdr.ChunkRIFFSize
        get #hFile,, Hdr.ChunkID
        if Hdr.ChunkID = _WAVE then
          fSize = seek(hFile)
          Hdr.Chunkfmt=0
          while (Hdr.Chunkfmt <> _fmt) and (eof(hFile) = 0)
            get #hFile, fSize, Hdr.Chunkfmt
            fSize+=1
          wend
          if Hdr.Chunkfmt = _fmt then
            get #hFile, , Hdr.ChunkfmtSize
            if Hdr.ChunkfmtSize >= _PCM_FMT_SIZE then
              get #hFile, , Hdr.wFormattag
              if Hdr.wFormattag = _WAVE_FORMAT_PCM then
                get #hFile, , Hdr.nChannels
                get #hFile, , Hdr.nRate
                get #hFile, , Hdr.nBytesPerSec
                get #hFile, , Hdr.Framesize
                get #hFile, , Hdr.nBits
                Hdr.Chunkdata=0
                fSize = seek(hFile)
                while (Hdr.Chunkdata <> _data) and (eof(hFile) = 0)
                  get #hFile, fSize, Hdr.Chunkdata
                  fSize+=1
                wend
                if Hdr.Chunkdata = _data Then
                  get #hFile, , Hdr.ChunkdataSize
                  if Hdr.ChunkdataSize > 0 and eof(hFile) = 0 Then
                    L = seek(hFile)
                    *lpDataPos = L
                    close #hFile
                    return true
                  end if ' Chunkdatasize>0
                end if ' Chunkdata=_data
              end if ' wFormattag = WAVE_FORMAT_PCM
            end if ' ChunkfmtSize >= PCM_FMT_SIZE
          end if ' Chunkfmt = _fmt
        end if ' ChunkID = _WAVE
      end if ' ChunkRIFF = _RIFF
    end if ' FileSize > PCM_FILE_HDR_SIZE
  end if ' open=0
  close #hFile
  return false
end function

private _
function _LoadWave(byval Filename        as string, _
                   byval nRateTarget     as integer , _
                   byval nBitsTarget     as integer , _
                   byval nChannelsTarget as integer , _
                   byval lpnBytes        as integer ptr) as any ptr

  dim as _PCM_FILE_HDR hdr
  dim as integer   SeekPos,nBytesTarget,nSamples,nSamplesTarget,i,oPos,cPos
  dim as single    l,r
  dim as double    Scale,nPos
  dim as ubyte     v8
  dim as short     v16
  dim as short ptr p16

#ifndef NO_CALLBACK
  dim as single   percent
  dim as integer  pold,pnew
#endif        

  oPos=-1
  if GetWaveInfo(Filename,hdr,@SeekPos)=true then
    
    nSamples = hdr.Chunkdatasize \ hdr.Framesize
    
    Scale = hdr.nRate/nRateTarget
    
    nSamplesTarget = nSamples*(1.0/Scale)
    
    nBytesTarget = nSamplesTarget*(nBitsTarget\8)*nChannelsTarget
    
    var hFile = Freefile()
    if open(FileName for binary access read as #hFile)=0 then
      seek #hFile,SeekPos
      
      p16 = callocate(nBytesTarget)
      if (p16 = NULL) then
        dprint("error: LoadWave() out of memeory !")        
        close #hFile : return NULL 
      end if
      
      if nSamples<=nSamplesTarget then

#ifndef NO_CALLBACK
        percent=100.0/nSamplesTarget
#endif        
        for i=0 to nSamplesTarget-1
          ' jump over in source
          if oPos<>cPos then
            ' read samples l,r -0.5 - 0.5
            if hdr.nBits=8 then
              'read ubyte 0<->255
              get #hFile,,v8
              ' convert to -128.0 <-> +127.0
              l=csng(v8):l-=128
              ' convert to -0.5 <-> +0.5
              l*=(0.5f/128.0f)
              if hdr.nChannels=2 then 
                get #hFile,,v8
                r=csng(v8):r-=128
                ' convert to -0.5 <-> +0.5
                r*=(0.5f/128.0f)  
              else
                r=l
              end if
            else
              get #hFile,,v16 : l=(0.5f/32767.0f)*v16
              if hdr.nChannels=2 then 
                get #hFile,,v16 : r=(0.5f/32767.0f)*v16
              else 
                r=l
              end if
            end if
            oPos=cPos
          end if
          ' write every in target
          if nChannelsTarget=1 then
            p16[i    ]=cshort(l*16383f + r*16383f)
          else
            p16[i*2  ]=cshort(l*32767.0f)
            p16[i*2+1]=cshort(r*32767.0f)
          end if
          nPos+=scale : cPos=int(nPos)
          
#ifndef NO_CALLBACK
          if cbool(_LoadCallback<>NULL) and (_EnabledLoadCallback=true) then
            pnew = percent * i
            if (pnew<>pold) then
              _LoadCallback(pnew)
              pold=pnew
            end if           
          end if
#endif                    
          ' don't read more than len(source)
          if cPos>=nSamples then exit for
          
        next
        
      else ' read every source Sample
      
        scale=(1.0/scale)
        
#ifndef NO_CALLBACK        
        percent=100.0/nSamples
#endif
        for i=0 to nSamples-1
          
          ' read samples l,r -0.5 - +0.5
          if hdr.nBits=8 then
            'read ubyte 0<->255
            get #hFile,,v8
            ' convert to -128.0 <-> +127.0
            l=csng(v8):l-=128
            ' convert to -0.5 <-> +0.5
            l*=(0.5f/128.0f)
            if hdr.nChannels=2 then 
              get #hFile,,v8
              r=csng(v8):r-=128
              ' convert to -0.5 <-> +0.5
              r*=(0.5f/128.0f)  
            else
              r=l
            end if
            
          else
          
            get #hFile,,v16:l=(0.5f/32767.0f)*v16
            if hdr.nChannels=2 then
              get #hFile,,v16:r=(0.5f/32767.0f)*v16
            else 
              r=l
            end if
          
          end if
          
          ' jump over in destination
          if oPos<>cPos then 
            if nChannelsTarget=1 then
              p16[cPos    ]=cshort(l*16383.5f + r*16383.5f)
            else
              p16[cPos*2  ]=cshort(l*32767.0f)
              p16[cPos*2+1]=cshort(r*32767.0f)
            end if
            oPos=cPos
          end if
          nPos+=scale:cPos=int(nPos)

#ifndef NO_CALLBACK
          if cbool(_LoadCallback<>NULL) and (_EnabledLoadCallback=true) then
            pnew = percent * i
            if (pnew<>pold) then
              _LoadCallback(pnew)
              pold=pnew
            end if
          end if
#endif
          ' don't write more than len(target)
          if cPos >= (nSamplesTarget-1) then exit for
          
        next
        
      end if
      close #hFile
      *lpnBytes = nBytesTarget
      return p16
  
    end if ' open=0
  
  end if ' GetWaveInfo<>0
  
  return NULL
end function

private _
function _Adjust_Path(byval Path as string) as string
  var nChars=len(path)
  if nChars>0 then
    for i as integer=0 to nChars-1
      if path[i]=asc("\") then path[i]=asc("/")
    next
    if right(Path,1)<>"/" then Path=Path & "/"
  end if  
  return Path
end function

private function _Get_PlugPath() as string
  dim as string tmp = _Adjust_Path(_PlugPath)
  return tmp
end function

#if __FB_OUT_DLL__ <> 0

private _
function _InitPlugout(byval filename as string, _
                      byref p        as FBS_Plug) as boolean
  dprint("_InitPlugout(" & filename & ")")
  p.plug_hLib=0
  dprint("_InitPlugout: dylibload(" & filename & ")")
  p.plug_hLib=dylibload(filename)
  if p.plug_hLib<>0 then
    p.plug_isany=dylibsymbol(p.plug_hLib, "PLUG_ISANY" )
    if (p.plug_isany<>NULL) then
      if p.plug_isany(p)=true then
        p.plug_init =DylibSymbol( p.plug_hLib, "PLUG_INIT"  )
        p.plug_start=DylibSymbol( p.plug_hLib, "PLUG_START" )
        p.plug_stop =DylibSymbol( p.plug_hLib, "PLUG_STOP"  )
        p.plug_exit =DylibSymbol( p.plug_hLib, "PLUG_EXIT"  )
        p.plug_error=DylibSymbol( p.plug_hLib, "PLUG_ERROR" )
        if (p.plug_init <>NULL) and _
           (p.plug_start<>NULL) and _
           (p.plug_stop <>NULL) and _
           (p.plug_exit <>NULL) and _
           (p.plug_error<>NULL) then
            return true
        else
          dprint("_InitPlugout: isn't a plugout interface!")
          DylibFree p.plug_hLib
          p.plug_hLib=NULL
          return false
        end if
      else
        dprint("_InitPlugout: no free devices !")
        dprint("_InitPlugout: call DylibFree()")
        DylibFree p.plug_hLib
        p.plug_hLib=NULL
        return false
      end if
    else
      dprint("_InitPlugout: missing interface member (plug_isany)")
      dprint("_InitPlugout: call DylibFree()")
      DylibFree p.plug_hLib
      p.plug_hLib=NULL
      return false
    end if
  else
    dprint("_InitPlugout: can't load '" & filename & "' !")
    return false
  end if
end function

pluglist:
#ifdef __FB_WIN32__
 #ifndef __FB_64BIT__
  #ifndef NO_PLUG_MM  
data "fbsound-mm-32.dll"
  #endif  
  #ifndef NO_PLUG_DS 
data "fbsound-ds-32.dll"
  #endif
 #else
  #ifndef NO_PLUG_MM  
data "fbsound-mm-64.dll"
  #endif
  #ifndef NO_PLUG_DS 
data "fbsound-ds-64.dll"
  #endif 
 #endif 
 
#else

 #ifndef __FB_64BIT__
  #ifndef NO_PLUG_ALSA
data "libfbsound-alsa-32.so"
  #endif  
  #ifndef NO_PLUG_DSP
data "libfbsound-dsp-32.so"
  #endif
  #ifndef NO_PLUG_ARTS  
data "libfbsound-arts-32.so"
  #endif
 #else
  ' linux 64-bit 
  #ifndef NO_PLUG_ALSA
data "libfbsound-alsa-64.so"
  #endif  
 #endif 
#endif

data "" ' end of list
  
#endif ' not( __FB_DLL_OUT__ <> 0 )

private _
sub _Enumerate_Plugs()
  dim as string  plugname
  dim as FBS_Plug _new
  dprint("_Enumerate_Plugs()") 
  if _nPlugs>0 then exit sub

#if __FB_OUT_DLL__ = 0
  dim cdtor as const fbsound.cdtor.cdtor_struct ptr = any
  cdtor = fbsound.cdtor.getfirst_plugin()
  do while cdtor
    dprint("_Enumerate_Plugs() call plug_filler(" & *cdtor->module & ")")
    if cdtor->plug_filler(_new)=true then
      redim preserve _Plugs(_nPlugs)
      _Plugs(_nPlugs)=_new : _nPlugs+=1
    end if
    cdtor = fbsound.cdtor.getnext_plugin(cdtor)
  loop 

#else ' not( __FB_OUT_DLL__ = 0 )
  restore pluglist
  read plugname
  
  while len(plugname)
    plugname = _PlugPath & plugname
    dprint("_Enumerate_Plugs() call _initplugout(" & plugname & ")")
    if _initplugout(plugname,_new)=true then
      redim preserve _Plugs(_nPlugs)
      _Plugs(_nPlugs)=_new : _nPlugs+=1
    end if
    read plugname 
  wend
#endif ' __FB_OUT_DLL__ = 0

end sub

FBS_MODULE_CDTOR_SCOPE _
sub _fbs_init cdecl () FBS_MODULE_CTOR
  dprint("_fbs_init() module constructor")
  _PlugPath    =_Get_PlugPath()
  _Plug        =-1
  _MasterVolume=1.0
  _MaxChannels =512
#ifndef NO_MOD
  dprint("_fbs_init() module constructor call dumb_register_stdfiles()")
  dumb_register_stdfiles()
#endif
end sub

FBS_MODULE_CDTOR_SCOPE _
sub _fbs_exit cdecl () FBS_MODULE_DTOR
  dprint("_fbs_exit() module destructor")
  if (_IsInit=true) then 
    if (_IsRunning=true) then
      dprint("_fbs_exit() module destructor call fbs_Stop()")
      fbs_Stop()
    end if
    dprint("_fbs_exit() module destructor call fbs_Exit()")  
    fbs_Exit()
  end if
#ifndef NO_MOD
  dprint("_fbs_exit() module destructor call dumb_exit()")  
  dumb_exit()
#endif
end sub

#if __FB_OUT_DLL__ = 0
public _
sub ctor_fbs_init cdecl () FBS_MODULE_REGISTER_CDTOR
	static cdtor as fbsound.cdtor.cdtor_struct = _
		( _
			procptr(_fbs_init), _
			procptr(_fbs_exit), _
			@"fbs", _
			fbsound.cdtor.MODULE_MAIN _
		)
	fbsound.cdtor.register( @cdtor )
end sub
#endif

function FBS_Get_NumOfPlugouts() as integer  API_EXPORT
  return _nPlugs
end function

function FBS_Get_PlugError() as string  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).plug_error()
end function

function FBS_Get_PlugName() as string  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).PlugName
end function

public _
function FBS_Get_PlugDevice() as string  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).DeviceName
end function

public _
function FBS_Get_PlugBuffersize() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Buffersize
end function

public _
function FBS_Get_PlugBuffers() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).nBuffers
end function

public _
function FBS_Get_PlugFramesize() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Framesize
end function

public _
function FBS_Get_PlugFrames() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).nFrames
end function

public _
function FBS_Get_PlugRate() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Fmt.nRate
end function

public _
function FBS_Get_PlugBits() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Fmt.nBits
end function

public _
function FBS_Get_PlugChannels() as integer  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Fmt.nChannels
end function

public _
function FBS_Get_PlugSigned() as boolean  API_EXPORT
  if _Plug>-1 then return _Plugs(_Plug).Fmt.Signed
end function

public _
function FBS_Get_PlugRunning() as boolean  API_EXPORT
  return _IsRunning
end function

public _
function FBS_Get_PlayingSounds() as integer  API_EXPORT
  if (_IsRunning=true) then return _nPlayingSounds
end function

#if defined(NO_MP3) and defined(NO_SID)
  ' no streams
#else
function FBS_Get_PlayingStreams() as integer  API_EXPORT
  if (_IsRunning=0) then return 0
  return _nPlayingStreams
end function
#endif

function FBS_Get_PlayedBytes() as integer  API_EXPORT
  if (_IsInit=true) then return _nPlayedBytes
end function

function FBS_Get_PlayedSamples() as integer  API_EXPORT
  if FBS_Get_PlayedBytes>0 then return int(FBS_Get_PlayedBytes()\_Plugs(_Plug).Framesize)
end function

function FBS_Get_PlayTime() as double  API_EXPORT
  if FBS_Get_PlayedSamples>0 then return cdbl(FBS_Get_PlayedSamples()/_Plugs(_Plug).fmt.nRate)
end function

function FBS_Init(byval nRate        as integer, _
                  byval nChannels    as integer, _
                  byval nBuffers     as integer, _
                  byval nFrames      as integer, _
                  byval nPlugIndex   as integer, _
                  byval nDeviceIndex as integer) as boolean  API_EXPORT

  dim as integer     i
  dim as boolean  ret
  dim as FBS_Plug    _new

#if __FB_OUT_DLL__ = 0
  dprint("fbsound.cdtor.callctors()")
  fbsound.cdtor.callctors()
  #if defined( DEBUG ) or ( __FB_DEBUG__ <> 0 )
    fbsound.cdtor.dump()
  #endif
#endif

  dprint("fbs_Init(" & nRate & ", " & nChannels & ", " & nBuffers & ", " & nFrames & ", " & nPlugIndex & ", " & nDeviceIndex & ")")

  if (_nPlugs<1) then
    dprint("fbs_Init Enumerate_Plugs()")
    _Enumerate_Plugs()
  end if

  if _nPlugs=0 then
    dprint("fbs_Init: no playback devices !")
    _IsInit=false
    return false
  end if

  if _Plug>-1 then
    dprint("fbs_Init: _Plug>-1")
    _Plugs(_Plug).plug_stop()
    _Plugs(_Plug).plug_exit()
    _Plug=-1
  end if

  if nPlugIndex<0 then
    nPlugIndex=0
  else
    nPlugIndex=nPlugIndex mod _nPlugs
  end if

  _Plugs(nPlugIndex).Fmt.nRate    =nRate
  _Plugs(nPlugIndex).Fmt.nBits    =16
  _Plugs(nPlugIndex).Fmt.nChannels=nChannels
  _Plugs(nPlugIndex).nBuffers     =nBuffers
  _Plugs(nPlugIndex).nFrames      =nFrames
  _Plugs(nPlugIndex).Fillbuffer   =@_FillBuffer
  _Plugs(nPlugIndex).DeviceIndex  =nDeviceIndex

  if _Plugs(nPlugIndex).plug_init(_Plugs(nPlugIndex))=true then 
    _Plug=nPlugIndex
  else
    for nPlugIndex=0 to _nPlugs-1
      if _Plugs(nPlugIndex).plug_init(_Plugs(nPlugIndex))=true then 
        _Plug=nPlugIndex:exit for
      end if
    next
  end if

  if _Plug<>-1 then
    dprint("FBS_Init set CPU pointers !")
    _mix   = @mix16  
    _scale = @scale16
   
    if _Plugs(_Plug).Fmt.nChannels=1 then
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
    else
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
    end if
    
    _IsInit = true
    return fbs_start()

  else

    _IsInit = false
    return false

  end if
end function

function FBS_Start() as boolean  API_EXPORT
  dprint("FBS_Start()")
  if _Plug=-1 then return false  
  _IsRunning = _Plugs(_Plug).plug_start()
  return _IsRunning
end function

function FBS_Stop() as boolean  API_EXPORT
  dim as boolean ret
  dprint("FBS_Stop()")
  if _Plug = -1 then return true
  if _IsRunning = false then return true
  dprint("FBS_Stop() call _Plugs(_Plug).plug_stop()")
  ret=_Plugs(_Plug).plug_stop()
  dprint("FBS_Stop() call sleep(100,1)")
  sleep(100,1)
  if ret=true then _IsRunning=false
  dprint("FBS_Stop~")
  return ret
end function

function FBS_Exit() as boolean  API_EXPORT
  dprint("FBS_Exit()")
  dim as integer i
  if _Plug = -1 then return true
  if _IsRunning = true then 
    dprint("FBS_Exit() call FBS_Stop()")
    FBS_Stop()
    _IsRunning = false
    dprint("FBS_Exit() call sleep(100,1)")
    sleep(100,1)
  end if

#if defined(NO_MP3) and defined(NO_SID)
  ' no streams
#else

 #ifndef NO_MP3
  if (_MP3Stream.InUse=true) then
    dprint("FBS_Exit() call FBS_End_MP3Stream()")
    FBS_End_MP3Stream()
  end if  
  ' free all resources from streams 
  with _MP3Stream
    if (.pInArray       <> NULL) then deallocate .pInArray       : .pInArray = NULL  
    if (.pStreamSamples <> NULL) then deallocate .pStreamSamples : .pStreamSamples = NULL  
    if (.pBuf           <> NULL) then deallocate .pBuf           : .pBuf = NULL  
    if (.pStart         <> NULL) then deallocate .pStart         : .pStart = NULL  
  end with
 #endif

 #ifndef NO_SID
  if (_SIDStream.InUse=true) then
    dprint("FBS_Exit() call FBS_End_SIDStream()")
    FBS_End_SIDStream()
  end if  
  ' free all resources from streams 
  with _SIDStream
    if (.pBuf           <> NULL) then deallocate .pBuf           : .pBuf = NULL  
    if (.pStart         <> NULL) then deallocate .pStart         : .pStart = NULL  
  end with
 #endif

#endif ' NO_MP3 or NO_SID

  if _nSounds>0 then
  
    for i=0 to _nSounds-1
      with _Sounds(i)
        ' signal stop
        if .nLoops<>0 then
          .paused = true
          .nLoops = 0  
        end if
      
        if (.pBuf <> NULL) then
          if (.pBuf = _Sounds(i).pOrg) then
            deallocate _Sounds(i).pBuf
            .pBuf = NULL
            .pOrg = NULL
          else
            dprint("!!! pointer value are corrupt !!!")
          end if
        end if
        .pStart = NULL
        .pPlay  = NULL
        .pEnd   = NULL
      end with  
    next
  end if
  
  if (_nWaves>0) then
    for i=0 to _nWaves-1
      with _Waves(i)
        if .pStart<>NULL then
          deallocate .pStart
          .pStart = NULL
          .nBytes = 0
        end if
      end with  
    next
    _nWaves=0
  end if
  dprint("FBS_Exit() call _Plugs(_Plug).plug_exit()")
  _Plugs(_Plug).plug_exit()
  dprint("FBS_Exit() call sleep(100,1)")
  sleep(100,1)
  if _Plugs(_Plug).plug_hLib <> NULL then

#if __FB_OUT_DLL__ <> 0
    dprint("FBS_Exit() call dylibfree _Plugs(_Plug).plug_hLib")
    dylibfree _Plugs(_Plug).plug_hLib
#endif
    dprint("FBS_Exit() call sleep(100,1)")
    sleep(100,1)
    _Plugs(_Plug).plug_hLib = NULL
  end if
  _nPlugs =  0
  _Plug   = -1
  _IsInit = false
  dprint("FBS_Exit()~")

#if __FB_OUT_DLL__ = 0
  dprint("fbsound.cdtor.calldtors()")
  fbsound.cdtor.calldtors()
  #if defined( DEBUG ) or ( __FB_DEBUG__ <> 0 )
    fbsound.cdtor.dump()
  #endif
#endif

  return true
end function

function FBS_Create_Wave(byval nSamples as integer    , _
                         byval hWave    as integer ptr, _
                         byval pWave    as any ptr ptr) as boolean  API_EXPORT
  dim as any ptr pNew
  dim as integer nBytes,index
  if (hWave = NULL) then return false
  if (pWave = NULL) then return false
  *hWave=-1 
  if (_Plug   =  -1) then return false
  if (nSamples<   1) then return false
  
  nBytes  = _Plugs(_Plug).fmt.nBits \ 8
  nBytes *= _Plugs(_Plug).fmt.nChannels
  nBytes *= nSamples 
  pNew = callocate(nBytes)
  if pNew = NULL then 
    dprint("error: FBS_Create_Wave out of memory !")
    return false
  end if  
  
  if _nWaves=0 then
    ' allocate first wave object
    redim _Waves(0) : _nWaves+=1
  else
    ' search a free wave object in pool of waves
    index=-1
    for i as integer = 0 to _nWaves-1
      if _Waves(i).pStart=NULL then index=i:exit for
    next
    if index=-1 then
      ' add new wave object in pool 
      index= _nWaves : redim preserve _Waves(_nWaves) : _nWaves+=1
    end if
  end if
  _Waves(index).pStart = pNew
  _Waves(index).nBytes = nBytes
  *pWave = pNew
  *hWave = index
  return true
end function

function FBS_Load_WAVFile(byref Filename as string, _
                          byval hWave    as integer ptr) as boolean  API_EXPORT
  dprint("FBS_Load_WAVFile(" & Filename & ")")
  dim as integer nBytes
  if (hWave = NULL) then return false  
  *hWave=-1
  if _IsInit = false then return false

  var _new = _LoadWave(FileName, _
                       _Plugs(_Plug).Fmt.nRate    , _
                       _Plugs(_Plug).Fmt.nBits    , _
                       _Plugs(_Plug).Fmt.nChannels, _
                       @nBytes)

  if _new = NULL then return false
  var index = 0
  ' new sound
  if _nWaves=0 then
    redim _Waves(0) : _nWaves=1
  else
    index = -1
    for i as integer = 0 to _nWaves-1
      if _Waves(i).pStart=NULL then index = i : exit for
    next
    if index = -1 then 
      index = _nWaves
      redim preserve _Waves(_nWaves) : _nWaves += 1
    end if  
  end if
  _Waves(index).pStart = _new
  _Waves(index).nBytes = nBytes
   *hWave = index
  return true
end function

#ifndef NO_MP3
'  ##############
' # mp3 libmad #
'##############
const as integer FRAMESIZE = 1152
const as single  MP3_SCALE = 1.0f/8325.0f

type MP3_STEREO_SAMPLE
  as short l
  as short r
end type

type MP3_BUFFER
  as ubyte ptr     pStart
  as integer       Size
  as integer       hOut
  as _PCM_FILE_HDR wavehdr
  as ubyte ptr     pFilebuf
end type

' input mp3 stream
private _
function ConvertMP3Stream() as integer
  if (_MP3Stream.InUse = false) then 
    dprint("ConvertMP3Stream() MP3Stream.InUse = false !")
    return 0
  end if  

  if _MP3Stream.mSynth.pcm.length<1 then
    dprint("ConvertMP3Stream MP3Stream.mSynth.pcm.length <=  1 !")
    return 0
  end if
  
  _MP3Stream.nSamplesTarget = _MP3Stream.mSynth.pcm.length 

  if (_MP3Stream.mSynth.pcm.channels>1) then
    _ScaleMP3FrameStereo(_MP3Stream.pStreamSamples, _
                        @_MP3Stream.mSynth.pcm.samples(0,0), _
                        @_MP3Stream.mSynth.pcm.samples(1,0), _
                         _MP3Stream.nSamplesTarget)
  else

    _ScaleMP3FrameMono(_MP3Stream.pStreamSamples, _
                      @_MP3Stream.mSynth.pcm.samples(0,0), _
                       _MP3Stream.nSamplesTarget)
  end if

  _MP3Stream.nBytesTarget = _MP3Stream.nSamplesTarget * (_Plugs(_Plug).fmt.nBits\8) * _Plugs(_Plug).fmt.nChannels 

  if _MP3Stream.p16=NULL then _MP3Stream.p16=cptr(short ptr,_MP3Stream.pStart)

  if (_MP3Stream.mSynth.pcm.Samplerate = _Plugs(_Plug).fmt.nRate) then

    while ( cbool( (_MP3Stream.nOuts + _MP3Stream.nBytesTarget) > _MP3Stream.nOutSize) andalso (_MP3Stream.IsStreaming=true) )
      sleep(1,1)
    wend 
    if (_MP3Stream.IsStreaming=false) then return 0
    
    CopyMP3Frame( _MP3Stream.pStart , _
                 @_MP3Stream.p16     , _
                  _MP3Stream.pEnd   , _
                  _MP3Stream.pStreamSamples, _
                  _MP3Stream.nBytesTarget)
  else
  
    _MP3Stream.scale =_MP3Stream.mSynth.pcm.Samplerate/_Plugs(_Plug).fmt.nRate
    _MP3Stream.nBytesTarget *= (1.0/_MP3Stream.scale)
    
    while (  cbool( (_MP3Stream.nOuts + _MP3Stream.nBytesTarget) > _MP3Stream.nOutSize) andalso (_MP3Stream.IsStreaming=true) )
      sleep(1,1)
    wend
    if _MP3Stream.IsStreaming=false then return 0
    
    _CopySliceMP3Frame(_MP3Stream.pStart , _
                      @_MP3Stream.p16     , _
                       _MP3Stream.pEnd   , _
                       _MP3Stream.pStreamSamples, _
                       _MP3Stream.scale ,_
                       _MP3Stream.nBytesTarget)
                       
  end if
  
   return _MP3Stream.nBytesTarget
end function


#define IN_SIZE 8192
private _
sub _MP3StreamingThread(byval dummy as any ptr)
  dprint("_MP3StreamingThread()")
  if (_MP3Stream.InUse=false) then exit sub
  
  _MP3Stream.IsStreaming=true

  ' loop over the whole stream
  while (_MP3Stream.IsStreaming = true)
    
    ' get first buffer or fill curent buffer     
    if (_MP3Stream.mStream.buffer=NULL) or ( _MP3Stream.mStream.error = MAD_ERROR_BUFLEN) then

      if (_MP3Stream.mStream.next_frame<>NULL) then
      
        _MP3Stream.nReadRest = _MP3Stream.mStream.bufend - _MP3Stream.mStream.next_frame
        
        if _MP3Stream.nReadRest > 0 then
          copy(_MP3Stream.pInArray, cptr(any ptr,_MP3Stream.mStream.next_frame), _MP3Stream.nReadRest)
          _MP3Stream.pRead     = _MP3Stream.pInArray + _MP3Stream.nReadRest
          _MP3Stream.nReadSize = IN_SIZE - _MP3Stream.nReadRest
        end if
        
      else
        _MP3Stream.nReadSize = IN_SIZE
        _MP3Stream.pRead     = _MP3Stream.pInArray
        _MP3Stream.nReadRest = 0
      end if
      
      ' enought bytes in stream?
      if (_MP3Stream.nInSize < _MP3Stream.nReadSize) then 
        _MP3Stream.nReadSize = _MP3Stream.nInSize
      end if  
      
      ' read from stream or exit the decoding loop
      if (_MP3Stream.nReadSize=0) andalso  (_MP3Stream.nInSize=0) then
        dprint("_MP3StreamingThread _MP3Stream.nReadSize=0 and _MP3Stream.nInSize=0 !")
        exit while
      end if  

      get #_MP3Stream.hFile,,*_MP3Stream.pRead, _MP3Stream.nReadSize
      
      _MP3Stream.nInSize -= _MP3Stream.nReadSize

      ' last frame fill the rest with 0
      if (_MP3Stream.nInSize=0) then
        _MP3Stream.GuardPTR =_MP3Stream.pRead + _MP3Stream.nReadSize
        zero(_MP3Stream.GuardPTR,MAD_BUFFER_GUARD)
        _MP3Stream.nReadSize += MAD_BUFFER_GUARD
      end if

      mad_stream_buffer(@_MP3Stream.mStream, _
                         _MP3Stream.pINArray, _
                         _MP3Stream.nReadSize + _MP3Stream.nReadRest)
      _MP3Stream.mStream.error=0
    end if

    if ( mad_frame_decode(@_MP3Stream.mFrame,@_MP3Stream.mStream)<>0) then
      if (_MP3Stream.mStream.error<>0) then
        if ( MAD_RECOVERABLE(_MP3Stream.mStream.error) ) then
          if ( (_MP3Stream.mStream.error<>MAD_ERROR_LOSTSYNC) or _
               (_MP3Stream.mStream.this_frame<>_MP3Stream.GuardPTR) or _
              ( _
              ( (_MP3Stream.mStream.this_frame[0]<>asc("I")) and _
                (_MP3Stream.mStream.this_frame[1]<>asc("D")) and _
                (_MP3Stream.mStream.this_frame[2]<>asc("3")) ) _
              or _
              ( (_MP3Stream.mStream.this_frame[0]<>asc("T")) and _
                (_MP3Stream.mStream.this_frame[1]<>asc("A")) and _
                (_MP3Stream.mStream.this_frame[2]<>asc("G")) ) )) then goto get_next_frame

        else ' not recoverable
          if (_MP3Stream.mStream.error=MAD_ERROR_BUFLEN) then 
            goto get_next_frame ' get next bytes from stream
          else
            dprint("MP3StreamingThread stream error not recoverable !")
            _MP3Stream.RetStatus=4
            exit while
          end if
        end if
      end if  
      
    else ' no decode error
  
      _MP3Stream.nFrames+=1
      mad_synth_frame(@_MP3Stream.mSynth,@_MP3Stream.mFrame)
      _MP3Stream.nOuts+=ConvertMP3Stream()
      
    end if
    
    get_next_frame:

  wend

  if (_MP3Stream.nOuts>0) then
    
    _MP3Stream.nReadRest=_MP3Stream.nOuts mod _Plugs(_Plug).Buffersize
    
    if _MP3Stream.nReadRest>0 then 
      _MP3Stream.nReadRest=_Plugs(_Plug).Buffersize-_MP3Stream.nReadRest
      while ((_MP3Stream.nOuts+_MP3Stream.nReadRest)>_MP3Stream.nOutSize)
        sleep(1,1)
      wend 
      zerobuffer(_MP3Stream.pStart, @_MP3Stream.p16, _MP3Stream.pEnd, _MP3Stream.nReadRest)
      _MP3Stream.nOuts+=_MP3Stream.nReadRest
    end if
    
  end if
  
  _MP3Stream.IsStreaming=false
    
  mad_synth_finish (@_MP3Stream.mSynth )
  mad_frame_finish (@_MP3Stream.mFrame )
  mad_stream_finish(@_MP3Stream.mStream)

  if _MP3Stream.hFile<>0 then close _MP3Stream.hFile : _MP3Stream.hFile=0
  dprint("_MP3StreamingThread~")
end sub

private _
function inputcallback cdecl (byval pData   as any ptr, _
                              byval pStream as mad_stream ptr) as enum_mad_flow
  var buf = cptr(MP3_BUFFER ptr,pData)
  if buf->Size = 0 then return MAD_FLOW_STOP
  mad_stream_buffer(pStream, buf->pStart, buf->Size)
  buf->Size = 0
  return MAD_FLOW_CONTINUE
end function

private _
function outputcallback cdecl (byval lpData   as any ptr       , _
                               byval lpHeader as const mad_header ptr, _
                               byval lpPCM    as mad_pcm    ptr) as enum_mad_flow
  dim as MP3_BUFFER ptr buf=cptr(MP3_BUFFER ptr,lpData)
  dim as integer i
  if lpPCM->channels>1 then
      _ScaleMP3FrameStereo(buf->pFileBuf, _
                           @lpPCM->samples(0,0), _
                           @lpPCM->samples(1,0), _, _
                           lpPCM->length)

  else
    _ScaleMP3FrameMono(buf->pFileBuf, _
                      @lpPCM->samples(0,0), _
                       lpPCM->length)
  end if

  ' first time write wave header
  if buf->wavehdr.ChunkDataSize=0 then
    buf->wavehdr.ChunkRIFF     = _RIFF
    buf->wavehdr.ChunkRIFFSize = sizeof(_PCM_FILE_HDR)-8
    buf->wavehdr.ChunkID       = _WAVE
    buf->wavehdr.Chunkfmt      = _fmt
    buf->wavehdr.ChunkfmtSize  = 16 
    buf->wavehdr.wFormatTag    = 1
    buf->wavehdr.nChannels     = _Plugs(_Plug).fmt.nChannels
    buf->wavehdr.nRate         = lpPCM->samplerate
    buf->wavehdr.nBytesPerSec  = (_Plugs(_Plug).fmt.nBits\8)*lpPCM->samplerate*_Plugs(_Plug).fmt.nChannels
    buf->wavehdr.Framesize     = (_Plugs(_Plug).fmt.nBits\8)*_Plugs(_Plug).fmt.nChannels
    buf->wavehdr.nBits         =_Plugs(_Plug).fmt.nBits
    buf->wavehdr.Chunkdata     = _data
    put #buf->hOut,,buf->wavehdr
  end if

  buf->wavehdr.ChunkRIFFSize+=lpPCM->length*buf->wavehdr.Framesize
  buf->wavehdr.ChunkdataSize+=lpPCM->length*buf->wavehdr.Framesize
  
  put #buf->hOut,, buf->pFileBuf[0], lpPCM->length*buf->wavehdr.Framesize
  
  return MAD_FLOW_CONTINUE
end function

private _
function errorcallback cdecl (byval lpData   as any ptr       , _
                              byval lpStream as mad_stream ptr, _
                              byval lpFrame  as mad_frame  ptr) as enum_mad_flow

  dim as MP3_BUFFER ptr buf = cptr(MP3_BUFFER ptr,lpData)

  if ( MAD_RECOVERABLE(lpStream->error) ) then
    return  MAD_FLOW_CONTINUE
  else ' not recoverable
    if (lpStream->error=MAD_ERROR_BUFLEN) then 
      return  MAD_FLOW_CONTINUE
    else
      dprint("mp3 error callback not recoverable !")
      return MAD_FLOW_BREAK
    end if
  end if
end function

private _
function _DecodeMP3(byval pStart as any ptr, _
                    byval Size   as integer, _
                    byval hOut   as integer) as integer

  dim as MP3_BUFFER  buf
  dim as mad_decoder decoder
  dim as integer     result

  ' initialize our private message structure
  buf.pStart   = pStart
  buf.Size     = Size
  buf.hOut     = hOut
  buf.pFileBuf = allocate(sizeof(short)*1152*2*4)

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
  
  seek buf.hOut,1
  put #buf.hOut,,buf.wavehdr
  
  ' release the decoder
  mad_decoder_finish(@decoder)
  
  if buf.pFileBuf<>NULL then deallocate buf.pFileBuf : buf.pFileBuf=NULL 
  return result
end function

function FBS_Load_MP3File(byref Filename as string , _
                          byval phWave   as integer ptr , _
                          byref _usertmpfile_  as string) as boolean  API_EXPORT
  static as integer tmpid = 0
  dim as string outtmp

  if phWave = NULL then return false  
  *phWave = -1
  if _IsInit = false then return false  

  var infile = FileName
  var hFile = FreeFile()
  if open(infile for binary access read as #hFile)<>0 then return false  
  var size = lof(hFile)
  if size = 0 then close #hfile : return false
  dim as ubyte ptr pMP3 = callocate(size)
  if pMP3 = NULL then
    dprint("error: FBS_Load_MP3File out of memory !")
    close #hfile
    return false
  endif  

  get #hFile,,*pMP3,size
  close #hFile
    
  if _usertmpfile_="" then 
    tmpid += 1 : outtmp="_usertmpfile_mp3" & trim(str(tmpid)) & ".wav"
  else
    outtmp = _usertmpfile_
  end if
  if len(dir(outtmp)) then kill outtmp

  var hOut=Freefile()
  if open(outtmp for binary access write as #hOut)<>0 then
    close #hfile
    if (pMP3 <> NULL) then  deallocate pMP3 : pMP3=NULL 
    return false
  end if

  var ret = _DecodeMP3(pMP3, size, hOut)
  close #hOut
  
  if (pMP3<>NULL) then deallocate pMP3 : pMP3 = NULL

  if ret=0 then
    if FBS_Load_WAVFile(outtmp, phWave) = true then
      kill outtmp : return true
    else
      kill outtmp : *phWave = -1 : return false
    end if
  else
    kill outtmp : *phWave = -1 :return false
  end if
end function


function FBS_Set_MP3StreamVolume(byval Volume as single) as boolean  API_EXPORT
  if _MP3Stream.InUse=false then return false  
  if Volume>2.0    then Volume=2.0
  if Volume<0.0001 then Volume=0.0
  _MP3Stream.Volume=Volume
   return true
end function

function FBS_Get_MP3StreamVolume(byval pVolume as single ptr) as boolean  API_EXPORT
  if _MP3Stream.InUse = false then return false  
  if pVolume = NULL then return false  
  *pVolume = _MP3Stream.Volume
   return true
end function

function FBS_Set_MP3StreamPan(byval Pan as single) as boolean  API_EXPORT
  if _MP3Stream.InUse=false then return false  
  if Pan<-1.0 then Pan=-1.0
  if Pan> 1.0 then Pan= 1.0
  _MP3Stream.Pan = Pan
  if Pan>=0.0 then _MP3Stream.rVolume=1 else _MP3Stream.rVolume=Pan+1.0
  if Pan<=0.0 then _MP3Stream.lVolume=1 else _MP3Stream.lVolume=1.0-Pan
   return true
end function

function FBS_Get_MP3StreamPan(byval pPan as single ptr) as boolean  API_EXPORT
  if pPan = NULL then return false  
  if _MP3Stream.InUse = false then return false  
  *pPan = _MP3Stream.Pan
   return true
end function

function FBS_Create_MP3Stream (byref Filename as string) as boolean  API_EXPORT
  if _IsInit          = false then return false   ' not init
  if _MP3Stream.InUse = true  then return false  
  
  var hTmp = FreeFile()
  if open(Filename for binary access read as #hTmp)<>0 then
    dprint("FBS_Create_MP3Stream error: can't open MP3 stream: '" & Filename & " !")
    return false
  end if

  var nBytes = lof(hTmp)
  if (nBytes<1000) then
    close hTmp
    dprint ("MP3 stream size to short!")
    return false
  end if

  with _MP3Stream
    .hFile        = hTmp
    .nInSize      = nBytes
    .IsStreaming  = false
    .IsFin        = false
    .hThread      = 0
    .nOuts        = 0
    .nFrames      = 0
    .Volume       = 1.0
    .Pan          = 0.0
    .lVolume      =-1.0
    .rVolume      = 1.0
    .nDecodedSize = 0
    .nReadsize    = 0
    .nReadRest    = 0
    .nOutSize     = _Plugs(_Plug).Buffersize*3 '!!!
    if (.pInArray=NULL) then
      .pInArray=allocate(IN_SIZE+MAD_BUFFER_GUARD)
    end if  
    if (.pStart = NULL) then
      .pStart = callocate(.nOutSize)
      .pEnd   = .pStart + .nOutSize
    end if
    if (.pBuf = NULL) then 
      .pBuf = callocate(_Plugs(_Plug).Buffersize+512)
    end if
    if (.pStreamSamples = NULL) then 
      .pStreamSamples = callocate(1152*(_Plugs(_Plug).fmt.nBits\8)*_Plugs(_Plug).fmt.nChannels * 4)
    end if  
    
    .pPlay = .pStart
    
    mad_stream_init(@.mStream)
    mad_frame_init (@.mFrame)
    mad_synth_init (@.mSynth)
    
    .InUse = true
  end with
  return true
end function

function FBS_Play_MP3Stream (byval Volume  as single , _
                             byval Pan     as single) as boolean  API_EXPORT

  if _MP3Stream.InUse=false then return false
  
  if (_MP3Stream.IsStreaming=true) then
    dprint("FBS_Play_MP3Stream while IsStreaming=true!")
    FBS_End_MP3Stream()
    _MP3Stream.IsStreaming=false
  end if

  fbs_Set_MP3StreamVolume Volume
  fbs_Set_MP3StreamPan    Pan
  
  _MP3Stream.p16     = cptr(short ptr, _MP3Stream.pStart)
  _MP3Stream.pPlay   = _MP3Stream.pStart
  _MP3Stream.hThread = ThreadCreate(cptr(any ptr, @_MP3StreamingThread),0)
 
  if _MP3Stream.hThread=NULL then 
    dprint("FBS_Play_MP3Stream: error ThreadCreate!")
    return false
  else
    ' wait on start of decoder
    while (_MP3Stream.IsStreaming=false)
      sleep(1,1)
    wend
  end if
  
  return true
end function

function FBS_Get_MP3StreamBuffer(byval ppBuffer  as short ptr ptr, _
                                 byval pnChannels as integer ptr  , _
                                 byval pnSamples  as integer ptr  ) as boolean  API_EXPORT
  if _MP3Stream.InUse = false then return false
  *ppBuffer  = cptr(short ptr,_MP3Stream.pPlay)
  *pnChannels = _Plugs(_Plug).fmt.nChannels
  *pnSamples  = _Plugs(_Plug).Buffersize shr _Plugs(_Plug).fmt.nChannels
   return true
end function

function FBS_End_MP3Stream() as boolean  API_EXPORT
  if (_MP3Stream.InUse=false) then return true

  ' end streaming
  _MP3Stream.IsStreaming=false
  if _MP3Stream.hThread<>0 then
    ThreadWait _MP3Stream.hThread
    _MP3Stream.hThread=0
  end if 
  _MP3Stream.InUse=false
   return true
end function

#endif ' NO_MP3

#ifndef NO_SID

'  ##############
' # SID Stream #
'##############

private _
sub _SIDStreamingThread(byval dummy as any ptr)
  dprint("_SIDStreamingThread()")
  if (_SIDStream.InUse=false) then exit sub
  
  _SIDStream.IsStreaming=true

  ' loop over the whole stream
  while (_SIDStream.IsStreaming = true)
    if (_SIDStream.bFillBuffer=true) then
      libcsid_render(_SIDStream.pPlay,_Plugs(_Plug).Fmt.nChannels,_Plugs(_Plug).Buffersize)
      _SIDStream.nOuts=_Plugs(_Plug).Buffersize
      _SIDStream.bFillBuffer=false
    else
      while (_SIDStream.IsStreaming = true) and (_SIDStream.bFillBuffer=false)
        sleep(1,1)
      wend  
    end if  
  wend
 
  dprint("_SIDStreamingThread~")
end sub

function FBS_Set_SIDStreamVolume(byval Volume as single) as boolean  API_EXPORT
  if _SIDStream.InUse=false then return false  
  if Volume>2.0    then Volume=2.0
  if Volume<0.0001 then Volume=0.0
  _SIDStream.Volume=Volume
   return true
end function

function FBS_Get_SIDStreamVolume(byval pVolume as single ptr) as boolean  API_EXPORT
  if _SIDStream.InUse = false then return false  
  if pVolume = NULL then return false  
  *pVolume = _SIDStream.Volume
   return true
end function

function FBS_Set_SIDStreamPan(byval Pan as single) as boolean  API_EXPORT
  if _SIDStream.InUse=false then return false  
  if Pan<-1.0 then Pan=-1.0
  if Pan> 1.0 then Pan= 1.0
  _SIDStream.Pan = Pan
  if Pan>=0.0 then _SIDStream.rVolume=1 else _SIDStream.rVolume=Pan+1.0
  if Pan<=0.0 then _SIDStream.lVolume=1 else _SIDStream.lVolume=1.0-Pan
   return true
end function

function FBS_Get_SIDStreamPan(byval pPan as single ptr) as boolean  API_EXPORT
  if pPan = NULL then return false  
  if _SIDStream.InUse = false then return false  
  *pPan = _SIDStream.Pan
  return true
end function

function FBS_Create_SIDStream (byref Filename as string, _
                               byval PlayTune as integer, _
                               byval pTunes as integer ptr) as boolean  API_EXPORT
  if _IsInit          = false then return false   ' not init
  if _SIDStream.InUse = true  then return false  
  
  var hFile = FreeFile()
  if open(Filename,for binary,access read,as #hFile) then
    dprint("FBS_Create_SIDStream error: can't open SID stream: '" & Filename & " !")
    return false
  end if
  
  var nBytes = lof(hFile)
  if nBytes<255 then
    close #hFile
    dprint("FBS_Create_SIDStream error: empty SID stream: '" & Filename & " !")
    return false
  end if
  
  dim as ubyte ptr buffer = allocate(nBytes)
  get #hFile,,*buffer,nBytes
  close #hFile

  libcsid_init(_Plugs(_Plug).Fmt.nRate, DEFAULT_SIDMODEL)
  if PlayTune<0 then PlayTune=0
  dim as integer nTunes = buffer[&H0f]
  if PlayTune<0 then
    PlayTune=0
  elseif nTunes>0 then
    if PlayTune>=nTunes then
      PlayTune=nTunes-1
    end if
  end if  
  
  nTunes = libcsid_load(buffer,nBytes,PlayTune)
  deallocate buffer
  if pTunes then *pTunes=nTunes
 
  with _SIDStream
    .IsStreaming  = false
    .IsFin        = false
    .hThread      = 0
    .nOuts        = 0
    .Volume       = 1.0
    .Pan          = 0.0
    if (.pStart = NULL) then
      .pStart = callocate(_Plugs(_Plug).Buffersize)
      .pEnd   = .pStart + _Plugs(_Plug).Buffersize
    end if
    if (.pBuf = NULL) then 
      .pBuf = callocate(_Plugs(_Plug).Buffersize+512)
    end if
    
    .pPlay = .pStart
    
    .InUse = true
  end with
  return true
end function

function FBS_Play_SIDStream (byval Volume  as single , _
                             byval Pan     as single) as boolean  API_EXPORT

  if _SIDStream.InUse=false then 
    dprint("FBS_Play_SIDStream() called without FBS_Create_SIDStream() before ! ")
    return false
  end if  
  if (_SIDStream.IsStreaming=true) then 
    dprint("FBS_Play_SIDStream() called without FBS_Stop_SIDStream() before ! ")
    return false
  end if  

  fbs_Set_SIDStreamVolume(Volume)
  fbs_Set_SIDStreamPan(Pan)

  _SIDStream.pPlay = _SIDStream.pStart

  _SIDStream.hThread = ThreadCreate(cptr(any ptr, @_SIDStreamingThread),0)
  if _SIDStream.hThread=NULL then 
    dprint("FBS_Play_SIDStream(): error ThreadCreate!")
    return false
  else
    ' wait on start of thread
    while (_SIDStream.IsStreaming=false)
      sleep(1,1)
    wend
    ' fill first buffer
    _SIDStream.bFillbuffer = true
  end if

  return true
end function

function FBS_Get_SIDStreamBuffer(byval ppBuffer  as short ptr ptr, _
                                 byval pnChannels as integer ptr  , _
                                 byval pnSamples  as integer ptr  ) as boolean  API_EXPORT
  if _SIDStream.InUse = false then return false
  *ppBuffer  = cptr(short ptr,_SIDStream.pPlay)
  *pnChannels = _Plugs(_Plug).fmt.nChannels
  *pnSamples  = _Plugs(_Plug).Buffersize shr _Plugs(_Plug).fmt.nChannels
   return true
end function

function FBS_End_SIDStream() as boolean  API_EXPORT
  if (_SIDStream.InUse=false) then return true

  ' end streaming
  if _SIDStream.IsStreaming=true then
    _SIDStream.IsStreaming=false
    if _SIDStream.hThread<>0 then
      ThreadWait _SIDStream.hThread
    _SIDStream.hThread=0
    end if
  end if  
  _SIDStream.InUse=false
   return true
end function

function FBS_Get_SIDAuthor() as string API_EXPORT
  dim as string ret
  if (_SIDStream.InUse=true) then
    dim as const zstring ptr p=libcsid_getauthor()
    if p then ret=*p
  end if
  return ret 
end function

function FBS_Get_SIDInfo() as string API_EXPORT
  dim as string ret
  if (_SIDStream.InUse=true) then
    dim as const zstring ptr p=libcsid_getinfo()
    if p then ret=*p
  end if
  return ret 
end function

function FBS_Get_SIDTitle() as string API_EXPORT
  dim as string ret
  if (_SIDStream.InUse=true) then
    dim as const zstring ptr p=libcsid_gettitle()
    if p then ret=*p
  end if
  return ret 
end function

#endif 'NO_SID


#ifndef NO_MOD

' create hWave from *.it *.xm *.sm3 or *.mod file
function FBS_Load_MODFile(byref Filename as string     , _
                          byval hWave    as integer ptr) as boolean  API_EXPORT
  dprint("FBS_Load_MODFile()")
  if hWave=NULL  then return false  
  *hWave=-1
  if _IsInit=false then return false

  dim as any ptr duh = dumb_load_mod(filename)
  if duh=0 then duh = dumb_load_s3m(filename)
  if duh=0 then duh = dumb_load_it(filename)
  if duh=0 then duh = dumb_load_xm(filename)
  if duh=0 then duh = load_duh(filename)
  if duh=0 then 
    dprint("FBS_Load_MODFile module loading failed!")
    return false
  end if
  
  dim as single l=duh_get_length(duh)
  l/=65536.0
  'dprint("FBS_Load_MODFile length = " & l)
  
  var mod_ = duh_start_sigrenderer(duh,0,_Plugs(_Plug).fmt.nChannels,0)
  if mod_=0 then 
    dprint("FBS_Load_MODFile start wave renderer failed!")
    unload_duh duh
    return false
  end if

  var it=duh_get_it_sigrenderer(mod_)

  if (it) then
    dumb_it_set_loop_callback         (it,@dumb_it_callback_terminate,NULL)
    dumb_it_set_xm_speed_zero_callback(it,@dumb_it_callback_terminate,NULL)
  else
    dprint("FBS_Load_MODFile get_it_sigrenderer failed!")
  end if
  
  dim as single  delta       = 65536.0/_Plugs(_Plug).fmt.nRate
  dim as integer nSamples    = 0, WritePos=0,nBytes=0
  dim as integer nBufferSize = 4096*_Plugs(_Plug).Framesize
  dim as any ptr pBuffer = allocate(nBufferSize)
  if pBuffer=NULL then
     unload_duh duh
     dprint("error: FBS_Load_MODFile out of memeory !")
     return false
  end if  

  dim as integer nAllocatedBytes = l * _Plugs(_Plug).fmt.nRate * _Plugs(_Plug).Framesize
  dim as ubyte ptr pSamples = allocate(nAllocatedBytes)
  if pSamples=NULL then
     unload_duh duh
     deallocate pBuffer
     dprint("error: FBS_Load_MODFile out of memeory !")
     return false
  end if  

 #ifndef NO_CALLBACK
  dim as single   percent=100.0/nAllocatedBytes
  dim as integer  pold,pnew
 #endif

 
  dim as integer ret=1
  while ret>0
    ret=duh_render(mod_,_Plugs(_Plug).fmt.nBits,0,1.0,delta,4096,pBuffer)
    if ret>0 then
      dim as integer nNewBytes=ret*_Plugs(_Plug).Framesize
      nBytes+=nNewBytes
      
 #ifndef NO_CALLBACK
      if cbool(_LoadCallback<>NULL) andalso (_EnabledLoadCallback=true) then
        pnew = percent * nBytes
        if (pnew<>pold) then
          _LoadCallback(pnew)
          pold=pnew
        end if
      end if
 #endif
      
      if nBytes>nAllocatedBytes then
        dprint("FBS_Load_MODFile buffer realloction !")
        pSamples=reallocate(pSamples,nBytes)
      end if
      
      copy(@pSamples[WritePos], pBuffer, nNewBytes)
      WritePos+=nNewBytes
      nSamples+=ret
    end if
    
  wend
  duh_end_sigrenderer mod_
  unload_duh duh
  if nSamples=0 then
    if pBuffer  then deallocate pBuffer:pBuffer=0
    if pSamples then deallocate pSamples:pSamples=0
    dprint("FBS_Load_MODFile error: got 0 Samples !")
    return false
  end if

  dim as any ptr pWave
  if FBS_Create_Wave(nSamples,hWave,@pWave) then
    copy(pWave,pSamples,nBytes)
  else
    if pBuffer  then deallocate pBuffer :pBuffer =0
    if pSamples then deallocate pSamples:pSamples=0
    dprint("FBS_Load_MODFile FBS_Create_Wave(" & nSamples & ") failed !")
    return false
  end if

  if pBuffer  then deallocate pBuffer :pBuffer =0
  if pSamples then deallocate pSamples:pSamples=0
  dprint("FBS_Load_MODFile~")
  return true
end function

#endif ' NO_MOD


#ifndef NO_OGG
' OGG 
type OGG_BUFFER
  as ubyte ptr pBuffer
  as integer   size
  as integer   index
end type

' file i/o callbacks
private _
function _oggReadcb cdecl (byval pBuffer  as any ptr, _
                           byval ByteSize as integer, _
                           byval nBytes   as integer, _
                           byval pUser    as any ptr) as integer
  var f = cptr(OGG_BUFFER ptr, pUser)
  var pDes = cptr(ubyte ptr ,pBuffer)
  dim as ubyte ptr pSrc = f->pBuffer
  dim as integer rest   = f->Size - f->Index

  pSrc += f->Index
  if nBytes > rest then nBytes=rest
  if nBytes = 0 then return 0
  copy(pDes, pSrc, nBytes)
  f->Index += nBytes
  return nBytes
end function

private _
function _oggSeekcb cdecl (byval pUser as any ptr, byval offset as longint, byval whence as long) as long
  var f = cptr(OGG_BUFFER ptr,pUser)
  select case as const whence
    case 0 : f->Index = Offset    ' SEEK_SET
    case 1 : f->Index+= Offset    ' SEEK_CUR
    case 2 : f->Index = f->Size-1 ' SEEK_END (-1 byte)
  end select
  return f->Index
end function

private _
function _oggClosecb cdecl (byval pUser as any ptr) as long
  var f = cptr(OGG_BUFFER ptr,pUser)
  return 1
end function

private _
function _oggTellcb cdecl (byval pUser as any ptr) as clong
  var f = cptr(OGG_BUFFER ptr,pUser)
  return f->index
end function

function FBS_Load_OGGFile(byref Filename as string , _
                          byval phWave  as integer ptr , _
                          byref _usertmpfile_  as string) as boolean  API_EXPORT
  static as integer     tmpid=0
  dim as ubyte ptr      pPCM
  dim as _PCM_FILE_HDR  WaveHdr
  dim as OGG_BUFFER     buf
  dim as OggVorbis_File ovFile
  dim as ov_callbacks   ovCB
  dim as long section,buffersize
  dim as string outtmp
  if phWave = NULL then return false
  *phWave=-1
  if _IsInit = false then return false

  var infile = FileName
  
  ' read ogg in memory
  var hFile = Freefile()
  if open(infile for binary access read as #hFile)<>0 then return false
  
  var size = lof(hFile)
  if size = 0 then close #hfile : return false
  
  dim as ubyte ptr pOGG = callocate(size)
  if pOGG = NULL then 
    dprint("FBS_Load_OGGFile error: out of memory !")
    close #hfile 
    return false
  end if  
  
  get #hFile,,*pOGG, size
  close #hFile
  
  ' init callbacks
  with ovCB
    .read_func = @_oggReadcb
    .seek_func = @_oggSeekcb
    .close_func= @_oggClosecb
    .tell_func = @_oggTellcb
  end with

  buf.pBuffer  = pOGG
  buf.Size     = Size
  var ret = ov_open_callbacks(@buf,@ovFile,0,0,ovCB)
  if ret<>0 then
    if (pOGG<>0) then deallocate pOGG
    return false
  end if

  ' get nChannels and sample rate
  var vi = ov_info(@ovFile,0)

  ' create temp file
  tmpid+=1
  if _usertmpfile_="" then 
    outtmp = "tmpfile_ogg" & trim(str(tmpid)) & ".wav"
    if len(dir(outtmp)) then kill outtmp
  else
    outtmp=_usertmpfile_
  end if

  hFile=Freefile()
  if open(outtmp for binary access write as #hFile)<>0 then
    if (pOGG<>NULL) then  deallocate pOGG
    ' free ogg file
    ov_clear(@OVFile)
    return false
  end if

  ' write wave header
  with wavehdr
    .ChunkRIFF     = _RIFF
    .ChunkRIFFSize = sizeof(_PCM_FILE_HDR)-8
    .ChunkID       = _WAVE
    .Chunkfmt      = _fmt
    .ChunkfmtSize  = 16 
    .wFormatTag    = 1
    .nChannels     = vi->channels
    .nRate         = vi->rate
    .nBytesPerSec  = 2 * vi->channels * vi->rate
    .Framesize     = 2 * vi->channels
    .nBits         = 16
    .Chunkdata     = _data
  end with
  put #hFile,,wavehdr

  buffersize = 4096 * 2 * vi->channels
  dim as short pcm(vi->rate * vi->channels)

  dim as integer eFlag
  ret=1
  while (ret>0)
    size = 0 
    pPCM = cptr(ubyte ptr,@pcm(0))
    ' decode one buffer with 4096 samples
    while (size < buffersize)
      ret = ov_read(@ovFile, pPCM + size, buffersize - size, 0, 2, 1, @section)
      if (ret > 0) then
        size += ret
      else
        if (ret < 0) then
          eFlag=1
        else
          exit while
        end if
      end if
    wend
    wavehdr.ChunkRIFFSize += buffersize
    wavehdr.ChunkdataSize += buffersize
    put #hFile,,*pPCM,buffersize
  wend
  
  ret = eflag

  ' write new header in temp.wav and close it
  seek hFile,1
  put #hFile,,wavehdr
  close #hFile

  ' free ov file
  ov_clear(@OVFile)

  ' free memoryfile
  if (pOGG<>NULL) then deallocate pOGG : pOGG = NULL
  ' no error load temp wav
  if ret=0 then
    if FBS_Load_WAVFile(outtmp, phWave)=true then
      kill outtmp
      return true
    else
      kill outtmp
      *phWave=-1
      return false
    end if
  else
    kill outtmp
    *phWave=-1
    return false
  end if
end function
#endif ' NO_OGG

private _
function _IshWave(byval hWave as integer) as boolean
  if (_IsInit=false)               then return false  ' not init
  if (_nWaves<1)                   then return false  ' no waves
  if (hWave<0) or (hWave>=_nWaves) then return false  ' no legal hWave
  if _Waves(hWave).pStart = NULL   then return false  ' reloaded wave
  if _Waves(hWave).nBytes  < 1     then return false  ' reloaded wave
   return true
end function

private _
function _IshSound(byval hSound as integer) as boolean
  if (_IsInit=false)                  then return false ' not init
  if (_nWaves<1)                      then return false ' no waves
  if (_nSounds<1)                     then return false ' no sound created
  if (hSound<0) or (hSound>=_nSounds) then return false ' no legal hSound
  if (_Sounds(hSound).pStart=NULL)    then return false ' free old sound
  if (_Sounds(hSound).pBuf  =NULL)    then return false ' free old sound
  return true
end function

function FBS_Destroy_Wave(byval phWave as integer ptr) as boolean  API_EXPORT
  dim as integer hWave,hSound
  if (phWave=NULL) then return false  
  hWave = *phWave
  if _IshWave(hWave)=false then return false  

  if (_nSounds>0) then
    for hSound=0 to _nSounds-1
      if _IshSound(hSound)=true then
        if _Sounds(hSound).pStart=_Waves(hWave).pStart then
          if cbool(_Sounds(hSound).nLoops>0) and (_Sounds(hSound).Paused=false) then 
            _Sounds(hSound).Paused=true
            _Sounds(hSound).nLoops=0
            ' !!! sleep 10 'wait if playing
          end if
          _Sounds(hSound).nLoops=0
          _Sounds(hSound).pStart=NULL
          if (_Sounds(hSound).pBuf<>NULL) then
            if (_Sounds(hSound).pBuf=_Sounds(hSound).pOrg) then
              deallocate _Sounds(hSound).pBuf
              _Sounds(hSound).pBuf=NULL
              _Sounds(hSound).pOrg=NULL
            else
            dprint("!!! pointer value are corrupt !!!")
            end if
          end if
          ' !!! if _Sounds(hSound).lphSound<>NULL then *_Sounds(hSound).lphSound=-1
        end if
      end if
    next
  end if
  if (_Waves(hWave).pStart<>NULL) then 
    deallocate _Waves(hWave).pStart
    _Waves(hWave).pStart=NULL
  end if
  _Waves(hWave).nBytes=0
  *phWave=-1
   return true
end function

function FBS_Destroy_Sound(byval phSound as integer ptr) as boolean  API_EXPORT
  if (phSound=NULL)         then return false  
  var hSound = *phSound
  if _IshSound(hSound)=false then return false  
  if _Sounds(hSound).nLoops>0 then 
    _Sounds(hSound).Paused=true
    _Sounds(hSound).nLoops=0
    ' !!! sleep 100 'wait if playing 
  end if
  _Sounds(hSound).pStart=NULL
  if (_Sounds(hSound).pBuf<>NULL) then
    if (_Sounds(hSound).pBuf=_Sounds(hSound).pOrg) then
      deallocate _Sounds(hSound).pBuf
      _Sounds(hSound).pBuf=NULL
      _Sounds(hSound).pOrg=NULL
    else
      dprint("!!! pointer value are corrupt !!!")
    end if
  end if  
  *phSound = -1
   return true
end function

function FBS_Set_SoundSpeed(byval hSound as integer, _
                            byval Speed  as single) as boolean  API_EXPORT

  if _IshSound(hSound)=false then return false   ' not init

  if Speed>0.0 then
    if Speed<+0.0000015258 then 
      Speed=-0.0000015258
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
  if speed=0 then speed=1
  _Sounds(hSound).Speed=Speed
   return true
end function

function FBS_Get_SoundSpeed(byval hSound as integer , _
                            byval pSpeed  as single ptr) as boolean  API_EXPORT
  if pSpeed=NULL then return false  
  if _IshSound(hSound)=false then return false  
  *pSpeed = _Sounds(hSound).Speed
  return true
end function

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


