#ifndef __FBS_PLUGOUT_MM__
#define __FBS_PLUGOUT_MM__

'  ##############
' # plug-mm.bi #
'##############
' Copyright 2005-2020 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NO_PLUG_MM

#include once "windows.bi"
#include once "win/mmsystem.bi"

' API helper section
type WAVE_FORMATS as long

private _
function InitWaveFormatEx( _
  byref Format     as WAVEFORMATEX, _
  byval nRate      as integer, _
  byval nBits      as integer, _
  byval nChannels  as integer) as WAVE_FORMATS

  if nRate < 10026 then
    nRate=10025
  elseif nRate < 22051 then
    nRate=22050
  elseif nRate < 44101 then
    nRate=44100
  elseif nRate > 44100 then  
    nRate=44100
  end if
  nBits\=8
  if nBits < 1 then
    nBits=1
  elseif nBits > 2 then  
    nBits=2
  end if
  nBits=nBits shl 3

  if nChannels<2 then
    nChannels=1
  elseif nChannels>2 then
    nChannels=2
  end if

  with Format
    .wFormatTag      = WAVE_FORMAT_PCM
    .nChannels       = nChannels
    .nSamplesPerSec  = nRate
    .wBitsPerSample  = nBits
    .nBlockAlign     = (nBits\8) * nChannels
    .nAvgBytesPerSec = (nBits\8) * nChannels * nRate
    .cbSize          = 0
  end with

  select case nRate
    case 10025
      select case nBits
        case 8
          select case nChannels
            case 1:return WAVE_FORMAT_1M08
            case 2:return WAVE_FORMAT_1S08
          end select
        case 16
          select case nChannels
            case 1:return WAVE_FORMAT_1M16
            case 2:return WAVE_FORMAT_1S16
          end select
      end select
    case 22050
      select case nBits
        case 8
          select case nChannels
            case 1:return WAVE_FORMAT_2M08
            case 2:return WAVE_FORMAT_2S08
          end select
        case 16
          select case nChannels
            case 1:return WAVE_FORMAT_2M16
            case 2:return WAVE_FORMAT_2S16
          end select
      end select
    case 44100
      select case nBits
        case 8
          select case nChannels
            case 1:return WAVE_FORMAT_4M08
            case 2:return WAVE_FORMAT_4S08
          end select
        case 16
          select case nChannels
            case 1:return WAVE_FORMAT_4M16
            case 2:return WAVE_FORMAT_4S16
          end select
      end select  
  end select  
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

#endif ' NO_PLUG_MM

#endif '__FBS_PLUGOUT_MM__
