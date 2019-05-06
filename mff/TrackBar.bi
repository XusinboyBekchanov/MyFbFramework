'###############################################################################
'#  TrackBar.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TTrackBar.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
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
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            #EndIf
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
            OnChange As Sub(BYREF Sender As TrackBar, Position As Integer)
    End Type

    Sub TrackBar.SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
        If AMax < AMin Then Exit Sub
        If APosition < AMin Then APosition = AMin
        If APosition > AMax Then APosition = AMax
        If FMinValue <> AMin then
            FMinValue = AMin
            #IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETRANGEMIN, 1, AMin)
			#EndIf
        End If
        If FMaxValue <> AMax Then
            FMaxValue = AMax
            #IfNDef __USE_GTK__
				if Handle Then Perform(TBM_SETRANGEMAX, 1, AMax)
			#EndIf
        End If
        If FPosition <> APosition then
            FPosition = APosition
            #IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETPOS, 1, APosition)
            #EndIf
            If OnChange Then OnChange(This,Position)
        End If
    End Sub

    Property TrackBar.MinValue As Integer
        Return FMinValue
    End Property

    Property TrackBar.MinValue(Value As Integer)
        SetRanges(FPosition, Value, FMaxValue)
    End Property

    Property TrackBar.MaxValue As Integer
        Return FMaxValue 
    End Property

    Property TrackBar.MaxValue(Value As Integer)
        SetRanges(FPosition, FMinValue, Value)
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
           #IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETLINESIZE, 0, FLineSize)
			#EndIf
        End If
    End Property

    Property TrackBar.PageSize  As Integer
        Return FPageSize
    End Property

    Property TrackBar.PageSize(Value As Integer)
        If Value <> FPageSize Then
           FPageSize = Value
			#IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETPAGESIZE, 0, FPageSize)
			#EndIf
        End If
    End Property

    Property TrackBar.ThumbLength  As Integer
        Return FThumbLength
    End Property

    Property TrackBar.ThumbLength(Value As Integer)
        If Value <> FThumbLength Then
           FThumbLength = Value
           #IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETTHUMBLENGTH, Value, 0)
			#EndIf
        End If
    End Property

    Property TrackBar.Frequency As Integer
        Return FFrequency
    End Property

    Property TrackBar.Frequency(Value As Integer)
        If Value <> FFrequency Then
           FFrequency = Value
			#IfNDef __USE_GTK__
				If Handle Then Perform(TBM_SETTICFREQ, FFrequency, 1)
			#EndIf
        End If
    End Property

    Property TrackBar.SliderVisible As Boolean
        Return FSliderVisible
    End Property

    Property TrackBar.SliderVisible(Value As Boolean)
        If Value <> FSliderVisible Then
            FSliderVisible = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
			#EndIf
        End If
    End Property

    Property TrackBar.SelStart As Integer
        Return FSelStart
    End Property

    Property TrackBar.SelStart(Value As Integer)
        If Value <> FSelStart then
            FSelStart = Value
            #IfNDef __USE_GTK__
				If Handle Then
				   If (FSelStart = 0) and (FSelEnd = 0) Then
					  Perform(TBM_CLEARSEL, 1, 0)
				   Else
					  Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
				   End If
				End If
			#EndIf
        End If
    End Property

    Property TrackBar.SelEnd As Integer
        Return FSelEnd
    End Property

    Property TrackBar.SelEnd(Value As Integer)
        If Value <> SelEnd then
            SelEnd = Value
            #IfNDef __USE_GTK__
				If Handle Then
				   If (FSelStart = 0) AND (FSelEnd = 0) Then
					  Perform(TBM_CLEARSEL, 1, 0)
				   Else
					  Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
				   End If
				End If
			#EndIf
        End If
    End Property

    Property TrackBar.Tick As Integer
        Return FTick
    End Property

    Property TrackBar.Tick(Value As Integer)
        FTick = Value
        #IfNDef __USE_GTK__
			If Handle Then Perform(TBM_SETTIC, 0, FTick)
		#EndIf
    End Property

    Property TrackBar.TickMarks As Integer
        Return FTickMarks
    End Property

    Property TrackBar.TickMarks(Value As Integer)
        If FTickMarks <> Value Then
            FTickMarks = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
			#EndIf
        End If
    End Property

    Property TrackBar.TickStyle As Integer
        Return FTickStyle
    End Property

    Property TrackBar.TickStyle(Value As Integer)
        If FTickStyle <> Value Then
            FTickStyle = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
			#EndIf
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
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
			#EndIf
        End If
    End Property

	#IfNDef __USE_GTK__
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
				If OnChange Then OnChange(This, Position)
			Case CM_VSCROLL
				Position = Perform(TBM_GETPOS, 0, 0)
				If OnChange Then OnChange(This, Position)
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator TrackBar.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor TrackBar
        Dim As Boolean Result
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
				widget = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL, NULL)
			#Else
				widget = gtk_hscale_new(NULL)
			#EndIf
			RegisterClass "TrackBar", @This
        #Else
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
		#EndIf
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
            .Child             = @This
            #IfNDef __USE_GTK__
				.RegisterClass "TrackBar", TRACKBAR_CLASS
            	.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD OR TBS_FIXEDLENGTH OR TBS_ENABLESELRANGE OR AStyle(Abs_(FStyle)) OR ATickStyles(Abs_(FTickStyle)) OR ATickMarks(Abs_(FTickMarks)) OR ASliderVisible(Abs_(FSliderVisible))
				.BackColor             = GetSysColor(COLOR_BTNFACE) 
				WLet FClassAncestor, TRACKBAR_CLASS
				.OnHandleIsAllocated = @HandleIsAllocated
            #EndIf
            WLet FClassName, "TrackBar"
            .Width             = 150
            .Height            = 45
        End With  
    End Constructor

    Destructor TrackBar
    End Destructor
End namespace
