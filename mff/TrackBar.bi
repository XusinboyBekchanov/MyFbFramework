'###############################################################################
'#  TrackBar.bi                                                                #
'#  This file is part of MyFBFramework                                              #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QTrackBar(__Ptr__) *Cast(TrackBar Ptr,__Ptr__)

    Enum TrackBarOrientation
        tbVertical,tbHorizontal
    End Enum

    Enum TickMark
        tmBottomRight, tmTopLeft, tmBoth
    End Enum

    Enum TickStyle
        tsNone, tsAuto, tsManual
    End Enum

    Type TrackBar Extends Control
        Private:
            FPosition         As Integer
            FMinValue         As Integer
            FMaxValue         As Integer
            FStyle            As Integer
            FTick             As Integer 
            FTickMarks        As Integer
            FTickStyle        As Integer
            FLineSize         As Integer
            FPageSize         As Integer
            FThumbLength      As Integer
            FFrequency        As Integer
            FSelStart         As Integer
            FSelEnd           As Integer
            FSliderVisible    As Boolean
            AStyle(2)         As Integer
            ATickStyles(3)    As Integer
            ATickMarks(3)     As Integer
            ASliderVisible(2) As Integer
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Sub SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
        Public:
            Declare Property MinValue As Integer
            Declare Property MinValue(Value As Integer)
            Declare Property MaxValue As Integer
            Declare Property MaxValue(Value As Integer)
            Declare Property Position  As Integer
            Declare Property Position(Value As Integer)
            Declare Property LineSize  As Integer
            Declare Property LineSize(Value As Integer)
            Declare Property PageSize  As Integer
            Declare Property PageSize(Value As Integer)
            Declare Property Frequency As Integer
            Declare Property Frequency(Value As Integer)
            Declare Property ThumbLength  As Integer
            Declare Property ThumbLength(Value As Integer)
            Declare Property SelStart  As Integer
            Declare Property SelStart(Value As Integer)
            Declare Property SelEnd As Integer
            Declare Property SelEnd(Value As Integer)
            Declare Property SliderVisible As Boolean
            Declare Property SliderVisible(Value As Boolean)
            Declare Property Tick As Integer
            Declare Property Tick(Value As Integer)
            Declare Property TickStyle As Integer
            Declare Property TickStyle(Value As Integer)
            Declare Property TickMarks As Integer
            Declare Property TickMarks(Value As Integer)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnChange As Sub(BYREF Sender As TrackBar,Position As Integer)
    End Type

    Sub TrackBar.SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
        If AMax < AMin Then Exit Sub
        If APosition < AMin Then APosition = AMin
        If APosition > AMax Then APosition = AMax
        If FMinValue <> AMin then
            FMinValue = AMin
            If Handle Then Perform(TBM_SETRANGEMIN, 1, AMin)
        End If
        If FMaxValue <> AMax Then
            FMaxValue = AMax
            if Handle Then Perform(TBM_SETRANGEMAX, 1, AMax)
        End If
        If FPosition <> APosition then
            FPosition = APosition
            If Handle Then Perform(TBM_SETPOS, 1, APosition)
            If OnChange Then OnChange(This,Position)
        End If
    End Sub

    Property TrackBar.MinValue As Integer
        Return FMinValue
    End Property

    Property TrackBar.MinValue(Value As Integer)
        If Value <= FMaxValue Then SetRanges(FPosition, Value, FMaxValue)
    End Property

    Property TrackBar.MaxValue As Integer
        Return FMaxValue 
    End Property

    Property TrackBar.MaxValue(Value As Integer)
        If Value >= FMinValue Then SetRanges(FPosition, FMinValue, Value)
    End Property

    Property TrackBar.Position As Integer
        Return FPosition
    End Property

    Property TrackBar.Position(Value As Integer)
        SetRanges(Value, FMinValue, FMaxValue)
    End Property

    Property TrackBar.LineSize  As Integer
        Return FLineSize
    End Property

    Property TrackBar.LineSize(Value As Integer)
        If Value <> FLineSize Then
           FLineSize = Value
           If Handle Then Perform(TBM_SETLINESIZE, 0, FLineSize)
        End If
    End Property

    Property TrackBar.PageSize  As Integer
        Return FPageSize
    End Property

    Property TrackBar.PageSize(Value As Integer)
        If Value <> FPageSize Then
           FPageSize = Value
           If Handle Then Perform(TBM_SETPAGESIZE, 0, FPageSize)
        End If
    End Property

    Property TrackBar.ThumbLength  As Integer
        Return FThumbLength
    End Property

    Property TrackBar.ThumbLength(Value As Integer)
        If Value <> FThumbLength Then
           FThumbLength = Value
           If Handle Then Perform(TBM_SETTHUMBLENGTH, Value, 0)
        End If
    End Property

    Property TrackBar.Frequency As Integer
        Return FFrequency
    End Property

    Property TrackBar.Frequency(Value As Integer)
        If Value <> FFrequency Then
           FFrequency = Value
           If Handle Then Perform(TBM_SETTICFREQ, FFrequency, 1)
        End If
    End Property

    Property TrackBar.SliderVisible As Boolean
        Return FSliderVisible
    End Property

    Property TrackBar.SliderVisible(Value As Boolean)
        If Value <> FSliderVisible Then
            FSliderVisible = Value
            Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
        End If
    End Property

    Property TrackBar.SelStart As Integer
        Return FSelStart
    End Property

    Property TrackBar.SelStart(Value As Integer)
        If Value <> FSelStart then
            FSelStart = Value
            If Handle Then
               If (FSelStart = 0) and (FSelEnd = 0) Then
                  Perform(TBM_CLEARSEL, 1, 0)
               Else
                  Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
               End If
            End If
        End If
    End Property

    Property TrackBar.SelEnd As Integer
        Return FSelEnd
    End Property

    Property TrackBar.SelEnd(Value As Integer)
        If Value <> SelEnd then
            SelEnd = Value
            If Handle Then
               If (FSelStart = 0) AND (FSelEnd = 0) Then
                  Perform(TBM_CLEARSEL, 1, 0)
               Else
                  Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
               End If
            End If
        End If
    End Property

    Property TrackBar.Tick As Integer
        Return FTick
    End Property

    Property TrackBar.Tick(Value As Integer)
        FTick = Value
        If Handle Then Perform(TBM_SETTIC, 0, FTick)
    End Property

    Property TrackBar.TickMarks As Integer
        Return FTickMarks
    End Property

    Property TrackBar.TickMarks(Value As Integer)
        If FTickMarks <> Value Then
            FTickMarks = Value
            Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
        End If
    End Property

    Property TrackBar.TickStyle As Integer
        Return FTickStyle
    End Property

    Property TrackBar.TickStyle(Value As Integer)
        If FTickStyle <> Value Then
            FTickStyle = Value
            Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
        End If
    End Property

    Property TrackBar.Style As Integer
        Return FStyle
    End Property

    Property TrackBar.Style(Value As Integer)
        Dim As Integer OldStyle,Temp
        OldStyle = FStyle
        If FStyle <> Value Then
            FStyle = Value
            If OldStyle = 0 Then
                Temp = This.Width
                This.Width = Height
                Height = Temp
            End If
            Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
        End If
    End Property

    Sub TrackBar.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QTrackBar(Sender.Child)
                .Perform(TBM_SETTHUMBLENGTH, .FThumbLength, 0)
                .Perform(TBM_SETLINESIZE, 0, .FLineSize)
                .Perform(TBM_SETPAGESIZE, 0, .FPageSize)
                .Perform(TBM_SETRANGEMIN, 0, .FMinValue)
                .Perform(TBM_SETRANGEMAX, 0, .FMaxValue)
                If (.FSelStart = 0) AND (.FSelEnd = 0) Then
                    .Perform(TBM_CLEARSEL, 1, 0)
                Else
                    .Perform(TBM_SETSEL, 1, MakeLong(.FSelStart, .FSelEnd))
                End If
                .Perform(TBM_SETPOS, 1, .FPosition)
                .Perform(TBM_SETTICFREQ, .FFrequency, 1)
            End With
        End If
    End Sub

    Sub TrackBar.WndProc(BYREF Message As Message)
    End Sub

    Sub TrackBar.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case CM_HSCROLL
            Position = Perform(TBM_GETPOS, 0, 0)
        Case CM_VSCROLL
            Position = Perform(TBM_GETPOS, 0, 0)
        End Select
    End Sub

    Operator TrackBar.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor TrackBar
        Dim As Boolean Result
        Dim As INITCOMMONCONTROLSEX ICC
        ICC.dwSize = SizeOF(ICC)
        ICC.dwICC  = ICC_BAR_CLASSES
        Result = InitCommonControlsEx(@ICC)
        If Not Result Then InitCommonControls
        AStyle(0)         = TBS_HORZ
        AStyle(1)         = TBS_VERT
        ATickStyles(0)    = TBS_NOTICKS
        ATickStyles(1)    = TBS_AUTOTICKS
        ATickStyles(2)    = 0 
        ATickMarks(0)     = TBS_BOTTOM
        ATickMarks(1)     = TBS_TOP
        ATickMarks(2)     = TBS_BOTH
        ASliderVisible(0) = TBS_NOTHUMB
        ASliderVisible(1) = 0
        FMinValue         = 0
        FMaxValue         = 10
        FFrequency        = 1
        FSliderVisible    = 1
        FLineSize         = 1
        FPageSize         = 2
        FFrequency        = 1
        FThumbLength      = 20
        FTickMarks        = 0
        FTickStyle        = 1
        With This
            .RegisterClass "TrackBar", TRACKBAR_CLASS
            .Child             = @This
            .ChildProc         = @WndProc
            .ClassName         = "TrackBar"
            .ClassAncestor         = TRACKBAR_CLASS
            .ExStyle           = 0
            Base.Style             = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
            .Color             = GetSysColor(COLOR_BTNFACE) 
            .Width             = 150
            .Height            = 45
            .OnHandleIsAllocated = @HandleIsAllocated
        End With  
    End Constructor

    Destructor TrackBar
    End Destructor
End namespace
