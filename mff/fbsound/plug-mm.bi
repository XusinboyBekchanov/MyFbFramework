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

#if __FB_OUT_DLL__ = 0
Namespace fbsound.plug_mm
#endif

' API helper section
Type WAVE_FORMATS As Long

Private _
Function InitWaveFormatEx( _
  ByRef Format1     As WAVEFORMATEX, _
  ByVal nRate      As Integer, _
  ByVal nBits      As Integer, _
  ByVal nChannels  As Integer) As WAVE_FORMATS

  If nRate < 10026 Then
    nRate=10025
  ElseIf nRate < 22051 Then
    nRate=22050
  ElseIf nRate < 44101 Then
    nRate=44100
  ElseIf nRate > 44100 Then  
    nRate=44100
  End If
  nBits\=8
  If nBits < 1 Then
    nBits=1
  ElseIf nBits > 2 Then  
    nBits=2
  End If
  nBits=nBits Shl 3

  If nChannels<2 Then
    nChannels=1
  ElseIf nChannels>2 Then
    nChannels=2
  End If

  With Format1
    .wFormatTag      = WAVE_FORMAT_PCM
    .nChannels       = nChannels
    .nSamplesPerSec  = nRate
    .wBitsPerSample  = nBits
    .nBlockAlign     = (nBits\8) * nChannels
    .nAvgBytesPerSec = (nBits\8) * nChannels * nRate
    .cbSize          = 0
  End With

  Select Case nRate
    Case 10025
      Select Case nBits
        Case 8
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_1M08
            Case 2:Return WAVE_FORMAT_1S08
          End Select
        Case 16
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_1M16
            Case 2:Return WAVE_FORMAT_1S16
          End Select
      End Select
    Case 22050
      Select Case nBits
        Case 8
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_2M08
            Case 2:Return WAVE_FORMAT_2S08
          End Select
        Case 16
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_2M16
            Case 2:Return WAVE_FORMAT_2S16
          End Select
      End Select
    Case 44100
      Select Case nBits
        Case 8
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_4M08
            Case 2:Return WAVE_FORMAT_4S08
          End Select
        Case 16
          Select Case nChannels
            Case 1:Return WAVE_FORMAT_4M16
            Case 2:Return WAVE_FORMAT_4S16
          End Select
      End Select  
  End Select  
End Function

#if __FB_OUT_DLL__ = 0
End Namespace ' fbsound.plug_mm
#endif

#endif ' NO_PLUG_MM

#endif '__FBS_PLUGOUT_MM__
