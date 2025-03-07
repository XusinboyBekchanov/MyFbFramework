'https://www.freebasic.net/forum/viewtopic.php?f=7&t=10579
#include once "windows.bi"
#include once "win/mmsystem.bi"
Const MMSYSERR_NOERROR = 0
Const MAXPNAMELEN = 32

Const MIXER_LONG_NAME_CHARS = 64
Const MIXER_SHORT_NAME_CHARS = 16
Const MIXER_GETLINEINFOF_LINEID = &H2
'Const MIXER_GETLINEINFOF_COMPONENTTYPE = &H3&
'Const MIXER_GETCONTROLDETAILSF_VALUE = &H0&
'Const MIXER_GETCONTROLDETAILSF_LISTTEXT = &H1&
'Const MIXER_GETLINECONTROLSF_ONEBYID = &H1
'Const MIXER_GETLINECONTROLSF_ONEBYTYPE = &H2&
'Const MIXER_OBJECTF_WAVEOUT = &H10000000
'Const MIXER_SETCONTROLDETAILSF_VALUE = &H0&
'
'Const MIXERCONTROL_CT_CLASS_FADER = &H50000000
'Const MIXERCONTROL_CT_CLASS_SWITCH = &H20000000
'Const MIXERCONTROL_CT_UNITS_BOOLEAN = &H10000
'Const MIXERCONTROL_CT_UNITS_UNSIGNED = &H30000
'Const MIXERCONTROL_CONTROLTYPE_FADER = (MIXERCONTROL_CT_CLASS_FADER Or MIXERCONTROL_CT_UNITS_UNSIGNED)
'Const MIXERCONTROL_CONTROLTYPE_VOLUME = (MIXERCONTROL_CONTROLTYPE_FADER + 1)
'Const MIXERCONTROL_CONTROLTYPE_BASS = (MIXERCONTROL_CONTROLTYPE_FADER + 2)
'Const MIXERCONTROL_CONTROLTYPE_TREBLE = (MIXERCONTROL_CONTROLTYPE_FADER + 3)
'Const MIXERCONTROL_CONTROLTYPE_EQUALIZER = (MIXERCONTROL_CONTROLTYPE_FADER + 4)
'Const MIXERCONTROL_CONTROLTYPE_BOOLEAN = (MIXERCONTROL_CT_CLASS_SWITCH Or MIXERCONTROL_CT_UNITS_BOOLEAN)
'Const MIXERCONTROL_CONTROLTYPE_MUTE = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2)
'Const MIXERLINE_COMPONENTTYPE_SRC_FIRST = &H1000&
'Const MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0)
'Const MIXERLINE_COMPONENTTYPE_SRC_DIGITAL = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1)
'Const MIXERLINE_COMPONENTTYPE_SRC_LINE = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2)
'Const MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3)
'Const MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4)
'Const MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5)
'Const MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6)
'Const MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7)
'Const MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8)
'Const MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9)
'Const MIXERLINE_COMPONENTTYPE_SRC_ANALOG = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10)
'Const MIXERLINE_COMPONENTTYPE_SRC_LAST = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10)
'Const MIXERLINE_COMPONENTTYPE_DST_FIRST = &H0&
'Const MIXERLINE_COMPONENTTYPE_DST_UNDEFINED = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 0)
'Const MIXERLINE_COMPONENTTYPE_DST_DIGITAL = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 1)
'Const MIXERLINE_COMPONENTTYPE_DST_LINE = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 2)
'Const MIXERLINE_COMPONENTTYPE_DST_MONITOR = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 3)
'Const MIXERLINE_COMPONENTTYPE_DST_SPEAKERS = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 4)
'Const MIXERLINE_COMPONENTTYPE_DST_HEADPHONES = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 5)
'Const MIXERLINE_COMPONENTTYPE_DST_TELEPHONE = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 6)
'Const MIXERLINE_COMPONENTTYPE_DST_WAVEIN = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 7)
'Const MIXERLINE_COMPONENTTYPE_DST_VOICEIN = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8)
'Const MIXERLINE_COMPONENTTYPE_DST_LAST = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8)
'
'Type MIXERCAPS Field=1
'  wMid           As Short
'  wPid           As Short
'  vDriverVersion As Integer
'  szPname        As ZString * MAXPNAMELEN
'  fdwSupport     As Integer
'  cDestinations  As Integer
'End Type
'
'Type MIXERCONTROL Field=1
'  cbStruct       As Integer
'  dwControlID    As Integer
'  dwControlType  As Integer
'  fdwControl     As Integer
'  cMultipleItems As Integer
'  szShortName    As ZString * MIXER_SHORT_NAME_CHARS
'  szName         As ZString * MIXER_LONG_NAME_CHARS
'  Union
'    Type
'     lMinimum As Integer
'     lMaximum As Integer
'    End Type 
'    Type
'     dwMinimum As UInteger
'     dwMaximum As UInteger
'    End Type
'    dwReserved1(6-1) As Integer
'  End Union
'  Union
'    cSteps As Integer
'    cbCustomData As Integer
'    dwReserved2(6-1) As Integer
'  End Union
'End Type
'
'Type MIXERCONTROLDETAILS
'  cbStruct    As Integer
'  dwControlID As Integer
'  cChannels   As Integer
'  item        As Integer
'  cbDetails   As Integer
'  paDetails   As Any Ptr
'End Type
'
'Type MIXERCONTROLDETAILS_UNSIGNED
'  dwValue As Integer
'End Type
'
'Type MIXERLINE Field=1
'  cbStruct        As Integer
'  dwDestination   As Integer
'  dwSource        As Integer
'  dwLineID        As Integer
'  fdwLine         As Integer
'  dwUser          As Integer
'  dwComponentType As Integer
'  cChannels       As Integer
'  cConnections    As Integer
'  cControls       As Integer
'  szShortName     As ZString * MIXER_SHORT_NAME_CHARS
'  szName          As ZString * MIXER_LONG_NAME_CHARS
'  dwType          As Integer
'  dwDeviceID      As Integer
'  wMid            As Short
'  wPid            As Short
'  vDriverVersion  As Integer
'  szPname         As ZString * MAXPNAMELEN
'End Type
'
'Type MIXERLINECONTROLS
'  cbStruct  As Integer
'  dwLineID  As Integer
'  dwControl As Integer
'  cControls As Integer
'  cbmxctrl  As Integer
'  pamxctrl  As MIXERCONTROL Ptr
'End Type
'
'Extern "windows"
'Declare Function mixerClose Lib "winmm.dll" (ByVal hmx As Integer) As Integer
'Declare Function mixerGetControlDetails Lib "winmm.dll" Alias "mixerGetControlDetailsA" ( _
'  ByVal hmxobj     As Integer, _
'  ByRef pmxcd      As MIXERCONTROLDETAILS, _
'  ByVal fdwDetails As Integer) As Integer
'Declare Function mixerGetDevCaps Lib "winmm.dll" Alias "mixerGetDevCapsA" ( _
'  ByVal uMxId    As Integer, _
'  ByVal pmxcaps  As MIXERCAPS Ptr, _
'  ByVal cbmxcaps As Integer) As Integer
'Declare Function mixerGetID Lib "winmm.dll" ( _
'  ByVal hmxobj As Integer, _
'  ByVal pumxID As Integer Ptr,_
'  ByVal fdwId  As Integer) As Integer
'Declare Function mixerGetLineControls Lib "winmm.dll" Alias "mixerGetLineControlsA" ( _
'  ByVal hmxobj      As Integer, _
'  ByVal pmxlc       As MIXERLINECONTROLS Ptr, _
'  ByVal fdwControls As Integer) As Integer
'Declare Function mixerGetLineInfo Lib "winmm.dll" Alias "mixerGetLineInfoA" ( _
'  ByVal hmxobj  As Integer, _
'  ByVal pmxl    As MIXERLINE Ptr,_
'  ByVal fdwInfo As Integer) As Integer
'Declare Function mixerGetNumDevs Lib "winmm.dll" () As Integer
'Declare Function mixerMessage Lib "winmm.dll" ( _
'  ByVal hmx      As Integer, _
'  ByVal uMsg     As Integer, _
'  ByVal dwParam1 As Integer, _
'  ByVal dwParam2 As Integer) As Integer
'Declare Function mixerOpen Lib "winmm.dll" ( _
'  ByVal phmx       As Integer Ptr, _
'  ByVal uMxId      As Integer, _
'  ByVal dwCallback As Any Ptr, _
'  ByVal dwInstance As Integer, _
'  ByVal fdwOpen    As Integer) As Integer
'Declare Function mixerSetControlDetails Lib "winmm.dll" ( _
'  ByVal hmxobj     As Integer, _
'  ByRef pmxcd      As MIXERCONTROLDETAILS, _
'  ByVal fdwDetails As Integer) As Integer

'End Extern

Type MIXER_CLASS
  Declare Constructor
  Declare Destructor
  Declare Property MinWaveVolume   As Integer
  Declare Property MaxWaveVolume   As Integer
  Declare Property MinMicVolume    As Integer
  Declare Property MaxMicVolume    As Integer
  Declare Property MinWavInVolume  As Integer
  Declare Property MaxWavInVolume  As Integer
  Declare Property MinLineInVolume As Integer
  Declare Property MaxLineInVolume As Integer
  Declare Property MinCDVolume     As Integer
  Declare Property MaxCDVolume     As Integer
  Declare Property MinMidVolume    As Integer
  Declare Property MaxMidVolume    As Integer
  Declare Property WaveVolume      As Integer
  Declare Property MicroVolume     As Integer
  Declare Property WaveInVolume    As Integer
  Declare Property LineInVolume    As Integer
  Declare Property CD_Volume       As Integer
  Declare Property MIDIVolume      As Integer
  Declare Property WaveMute        As Integer
  Declare Property MicroMute       As Integer
  Declare Property WaveInMute      As Integer
  Declare Property LineInMute      As Integer
  Declare Property CD_Mute         As Integer
  Declare Property MIDIMute        As Integer
  Declare Property WaveVolume  (ByVal NewVolume As Integer)
  Declare Property MicroVolume (ByVal NewVolume As Integer)
  Declare Property WaveInVolume(ByVal NewVolume As Integer)
  Declare Property LineInVolume(ByVal NewVolume As Integer)
  Declare Property CD_Volume   (ByVal NewVolume As Integer)
  Declare Property MIDIVolume  (ByVal NewVolume As Integer)
  Declare Property WaveMute    (ByVal NewValue As Integer)
  Declare Property MicroMute   (ByVal NewValue As Integer)
  Declare Property WaveInMute  (ByVal NewValue As Integer)
  Declare Property LineInMute  (ByVal NewValue As Integer)
  Declare Property CD_Mute     (ByVal NewValue As Integer)
  Declare Property MIDIMute    (ByVal NewValue As Integer)

  Private:
  Declare Function IsCtrl(ByVal Index As Integer) As Integer
  Declare Function IsMute(ByVal Index As Integer) As Integer
  Declare Sub Prepare_mxcd
  Declare Function GetMixerControl(ByVal hMixer As Integer, _
                                   ByVal componentType As Integer, _
                                   ByRef mxc   As MIXERCONTROL, _
                                   ByVal cType As Integer) As Integer
  Declare Function SetValue(ByRef mxctl  As MIXERCONTROL, _
                            ByVal volume As Integer) As Integer
  Declare Function GetValue(ByRef mxctl As MIXERCONTROL) As Integer

  As Integer hMixer
  volCtrl As MIXERCONTROL
  micCtrl As MIXERCONTROL
  wavCtrl As MIXERCONTROL
  linCtrl As MIXERCONTROL
  cd_Ctrl As MIXERCONTROL
  midCtrl As MIXERCONTROL
  auxCtrl As MIXERCONTROL

  volMute As MIXERCONTROL
  micMute As MIXERCONTROL
  wavMute As MIXERCONTROL
  linMute As MIXERCONTROL
  cdrMute As MIXERCONTROL
  midMute As MIXERCONTROL
  auxMute As MIXERCONTROL

  as integer MinVolVol, MaxVolVol
  as integer MinMicVol, MaxMicVol
  as integer MinWavVol, MaxWavVol
  as integer MinLinVol, MaxLinVol
  as integer MinCD_Vol, MaxCD_Vol
  as integer MinMidVol, MaxMidVol
  as integer MinAuxVol, MaxAuxVol

  mLine             As MIXERLINE
  mLineControls     As MIXERLINECONTROLS
  mControldetails   As MIXERCONTROLDETAILS
  mControldetails_u As MIXERCONTROLDETAILS_UNSIGNED

  as integer bOK
  as integer rc
  as integer CtrlState
  as integer MuteState
end type

property MIXER_CLASS.MinWaveVolume as integer
  return MinVolVol
End Property

property MIXER_CLASS.MaxWaveVolume as integer
  return MaxVolVol
End Property

property MIXER_CLASS.MinMicVolume as integer
  return MinMicVol
End Property

property MIXER_CLASS.MaxMicVolume as integer
  return MaxMicVol
End Property

property MIXER_CLASS.MinWavInVolume as integer
  return MinWavVol
End Property

property MIXER_CLASS.MaxWavInVolume as integer
  return MaxWavVol
End Property

property MIXER_CLASS.MinLineInVolume as integer
  return MinLinVol
End Property

property MIXER_CLASS.MaxLineInVolume as integer
  return MaxLinVol
End Property

property MIXER_CLASS.MinCDVolume as integer
  return MinCD_Vol
End Property

property MIXER_CLASS.MaxCDVolume as integer
  return MaxCD_Vol
End Property

property MIXER_CLASS.MinMidVolume as integer
  return MinMidVol
End Property

property MIXER_CLASS.MaxMidVolume as integer
  return MaxMidVol
End Property

property MIXER_CLASS.WaveVolume as integer
  return GetValue(volCtrl)
End Property

property MIXER_CLASS.MicroVolume as integer
  return GetValue(micCtrl)
End Property

property MIXER_CLASS.WaveInVolume as integer
  return GetValue(wavCtrl)
End Property

property MIXER_CLASS.LineInVolume as integer
  return GetValue(linCtrl)
End Property

property MIXER_CLASS.CD_Volume as integer
  return GetValue(cd_Ctrl)
End Property

property MIXER_CLASS.MIDIVolume as integer
  return GetValue(midCtrl)
End Property

property MIXER_CLASS.WaveMute as integer
  return GetValue(volMute)
End Property

property MIXER_CLASS.MicroMute as integer
  return GetValue(micMute)
End Property

property MIXER_CLASS.WaveInMute as integer
  return GetValue(wavMute)
End Property

property MIXER_CLASS.LineInMute as integer
  return GetValue(linMute)
End Property

property MIXER_CLASS.CD_Mute as integer
  return GetValue(cdrMute)
End Property

property MIXER_CLASS.MIDIMute as integer
  return GetValue(midMute)
End Property

property MIXER_CLASS.WaveVolume(ByVal NewVolume as integer)
  If NewVolume < MinVolVol Then NewVolume = MinVolVol
  If NewVolume > MaxVolVol Then NewVolume = MaxVolVol
  SetValue(volCtrl, NewVolume)
End Property

property MIXER_CLASS.MicroVolume(ByVal NewVolume as integer)
  If NewVolume < MinMicVol Then NewVolume = MinMicVol
  If NewVolume > MaxMicVol Then NewVolume = MaxMicVol
  SetValue(micCtrl, NewVolume)
End Property

property MIXER_CLASS.WaveInVolume(ByVal NewVolume as integer)
  If NewVolume < MinWavVol Then NewVolume = MinWavVol
  If NewVolume > MaxWavVol Then NewVolume = MaxWavVol
  SetValue(wavCtrl, NewVolume)
End Property

property MIXER_CLASS.LineInVolume(ByVal NewVolume as integer)
  If NewVolume < MinLinVol Then NewVolume = MinLinVol
  If NewVolume > MaxLinVol Then NewVolume = MaxLinVol
  SetValue(linCtrl, NewVolume)
End Property

property MIXER_CLASS.CD_Volume(ByVal NewVolume as integer)
  If NewVolume < MinCD_Vol Then NewVolume = MinCD_Vol
  If NewVolume > MaxCD_Vol Then NewVolume = MaxCD_Vol
  SetValue(cd_Ctrl, NewVolume)
End Property

property MIXER_CLASS.MIDIVolume(ByVal NewVolume as integer)
  If NewVolume < MinMidVol Then NewVolume = MinMidVol
  If NewVolume > MaxMidVol Then NewVolume = MaxMidVol
  SetValue(midCtrl, NewVolume)
End Property

property MIXER_CLASS.WaveMute(ByVal NewValue as integer)
  SetValue(volMute, NewValue)
End Property

property MIXER_CLASS.MicroMute(ByVal NewValue as integer)
  SetValue(micMute, NewValue)
End Property

Property MIXER_CLASS.WaveInMute(ByVal NewValue As Integer)
  SetValue(wavMute, NewValue)
End Property

Property MIXER_CLASS.LineInMute(ByVal NewValue As Integer)
  SetValue(linMute, NewValue)
End Property

Property MIXER_CLASS.CD_Mute(ByVal NewValue As Integer)
  SetValue(cdrMute, NewValue)
End Property

Property MIXER_CLASS.MIDIMute(ByVal NewValue As Integer)
  SetValue(midMute, NewValue)
End Property

Function MIXER_CLASS.IsCtrl(ByVal Index As Integer) As Integer
  IsCtrl = CtrlState And Index
End Function

Function MIXER_CLASS.IsMute(ByVal Index As Integer) As Integer
  IsMute = MuteState And Index
End Function

Constructor MIXER_CLASS
  rc = mixerOpen(@hMixer, 0, 0, 0, 0)
  If rc <> MMSYSERR_NOERROR Then
    Print "error: mixerOpen!"
    Beep:Sleep
    Return
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_DST_SPEAKERS, volCtrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 1
    With volCtrl
      'MinVolVol = .lMinimum
      'MaxVolVol = .lMaximum
    End With
    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_DST_SPEAKERS, volMute, 2)
    If bOK Then MuteState = MuteState Or 1
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE, micCtrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 2
    With micCtrl
      'MinMicVol = .lMinimum
      'MaxMicVol = .lMaximum
    End With

    If bOK Then MuteState = MuteState Or 2
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT, wavCtrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 4
    With wavCtrl
      'MinWavVol = .lMinimum
      'MaxWavVol = .lMaximum
    End With
    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT, wavMute, 2)
    If bOK Then MuteState = MuteState Or 4
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_LINE, linCtrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 8
    With linCtrl
      'MinLinVol = .lMinimum
      'MaxLinVol = .lMaximum
    End With

    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_LINE, linMute, 2)
    If bOK Then MuteState = MuteState Or 8
  Else
    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY, linCtrl, 1)
    If bOK Then
      CtrlState = CtrlState Or 8
      With linCtrl
        'MinLinVol = .lMinimum
        'MaxLinVol = .lMaximum
      End With
      
      bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY, linMute, 2)
      If bOK Then MuteState = MuteState Or 8
    End If
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC, cd_Ctrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 16
    With cd_Ctrl
      'MinCD_Vol = .lMinimum
      'MaxCD_Vol = .lMaximum
    End With
    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC, cdrMute, 2)
    If bOK Then MuteState = MuteState Or 16
  End If

  bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER, midCtrl, 1)
  If bOK Then
    CtrlState = CtrlState Or 32
    With midCtrl
      'MinMidVol = .lMinimum
      'MaxMidVol = .lMaximum
    End With
    bOK = GetMixerControl(hMixer, MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER, midMute, 2)
    If bOK Then MuteState = MuteState Or 32
  End If
End Constructor

Function MIXER_CLASS.GetMixerControl( _
  ByVal hMixer        As Integer, _
  ByVal componentType As Integer, _
  ByRef mxc           As MIXERCONTROL, _
  ByVal cType         As Integer) As Integer
  Dim As Integer ctrlType, infoType
  
  Select Case cType
    Case 1
      ctrlType = MIXERCONTROL_CONTROLTYPE_VOLUME
      infoType = MIXER_GETLINEINFOF_COMPONENTTYPE
    Case 2
      ctrlType = MIXERCONTROL_CONTROLTYPE_MUTE
      infoType = MIXER_GETLINEINFOF_LINEID
    Case Else
      Return 0
  End Select

  mLine.cbStruct = SizeOf(MIXERLINE)
  mLine.dwComponentType = componentType
  rc = mixerGetLineInfo(hMixer,@mLine,infoType)

  If (MMSYSERR_NOERROR = rc) Then
    With mLineControls
      .cbStruct    = sizeof(MIXERLINECONTROLS)
      .dwLineID    = mLine.dwLineID
      .dwControl   = ctrlType
      .cControls   = 1
      .cbmxctrl    = sizeof(MIXERCONTROL)
      .pamxctrl    = @mxc
    End With
    rc = mixerGetLineControls(hMixer,@mLineControls, MIXER_GETLINECONTROLSF_ONEBYTYPE)
    If (MMSYSERR_NOERROR = rc) Then
      GetMixerControl = -1
    end if
  else
    ? "error: GetLineInfo " & rc
  End If
End Function

Function MIXER_CLASS.SetValue(byref mxctl  As MIXERCONTROL, _
                              ByVal volume as integer) As integer
  With mControldetails
    .item = 0
    .dwControlID = mxctl.dwControlID
    .cbStruct    = sizeof(MIXERCONTROLDETAILS)
    .cbDetails   = sizeof(MIXERCONTROLDETAILS_UNSIGNED)
    .paDetails   = @mControldetails_u
    .cChannels   = 1
  End With
  mControldetails_u.dwValue = volume
  rc = mixerSetControlDetails(hMixer, mControldetails, MIXER_SETCONTROLDETAILSF_VALUE)
  If (rc = MMSYSERR_NOERROR) Then return -1
End Function

Function MIXER_CLASS.GetValue(byref mxctl As MIXERCONTROL) as integer
  mControldetails_u.dwValue = 0
  With mControldetails
    .item = 0
    .dwControlID = mxctl.dwControlID
    .cbStruct    = SizeOf(MIXERCONTROLDETAILS)
    .cbDetails   = SizeOf(MIXERCONTROLDETAILS_UNSIGNED)
    .paDetails   = @mControldetails_u
    .cChannels   = 1
  End With
  rc = mixerGetControlDetails(hMixer, mControldetails, MIXER_GETCONTROLDETAILSF_VALUE)
  If (rc = MMSYSERR_NOERROR) Then
    GetValue = mControldetails_u.dwValue '# Current value
  Else
    GetValue = 0
  End If
End Function


Destructor MIXER_CLASS
  If hMixer Then mixerClose hMixer
End Destructor

'
' main
'
Dim As MIXER_CLASS mixer
Print "min:" & mixer.MinWaveVolume
Print "max:" & mixer.MaxWaveVolume
Print "curent volume:" & mixer.WaveVolume
mixer.WaveVolume=mixer.MaxWaveVolume\2
Print "now    volume:" & mixer.WaveVolume

sleep
