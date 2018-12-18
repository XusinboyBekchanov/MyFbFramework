'###############################################################################
'#  ProgressBar.bi                                                            #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QProgressBar(__Ptr__) *Cast(ProgressBar Ptr,__Ptr__)

    Enum ProgressBarOrientation
        pbHorizontal,pbVertical
    End Enum

    Type ProgressBar Extends Control
        Private:
            FMode32      As Boolean 
            FPosition    As Integer
            FMinValue    As Integer
            FMaxValue    As Integer
            FStep        As Integer
            FSmooth      As Boolean
            FStyle       As Integer
            ASmooth(2)   As Integer
            AStyle(2)    As Integer
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
            Declare Sub SetRange(AMin As Integer,AMax As Integer)
        Public:
            Declare Property MinValue As Integer
            Declare Property MinValue(Value As Integer)
            Declare Property MaxValue As Integer
            Declare Property MaxValue(Value As Integer)
            Declare Property Position As Integer
            Declare Property Position(Value As Integer)
            Declare Property StepValue As Integer
            Declare Property StepValue(Value As Integer)
            Declare Property Smooth As Boolean
            Declare Property Smooth(Value As Boolean)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Sub StepIt
            Declare Sub StepBy(Delta As Integer)
            Declare Constructor
            Declare Destructor
    End Type

    Sub ProgressBar.SetRange(AMin As Integer,AMax As Integer)
        If AMax < AMin Then Exit Sub
        If NOT CInt(FMode32) AND ((AMin < 0) OR (AMin > 85535) OR (AMax < 0) OR (AMax > 85535)) Then Exit Sub
        If (FMinValue <> AMin) or (FMaxValue <> AMax) Then
            #IfNDef __USE_GTK__
				If Handle Then
				   If FMode32 Then 
					   Perform(PBM_SETRANGE32, AMin, AMax)
				   Else 
					   Perform(PBM_SETRANGE, 0, MakeLong(AMin, AMax))
				   End If
				   If FMinValue > AMin Then Perform(PBM_SETPOS, AMin, 0) 
				End If
			#EndIf
        End If
        FMinValue = AMin
        FMaxValue = AMax
    End Sub

    Property ProgressBar.MinValue As Integer
        Return FMinValue
    End Property

    Property ProgressBar.MinValue(Value As Integer)
        FMinValue = Value
        SetRange(FMinValue,FMaxValue)
    End Property

    Property ProgressBar.MaxValue As Integer
       Return FMaxValue 
    End Property

    Property ProgressBar.MaxValue(Value As Integer)
        FMaxValue = Value
        SetRange(FMinValue,FMaxValue)
    End Property

    Property ProgressBar.Position As Integer
		#IfNDef __USE_GTK__
			If Handle Then
				If FMode32 Then 
					Return Perform(PBM_GETPOS, 0, 0)
				Else 
					Return Perform(PBM_DELTAPOS, 0, 0)
				End If
			End If
		#EndIf
        Return FPosition
    End Property

    Property ProgressBar.Position(Value As Integer)
        If NOT CInt(FMode32) AND ((Value < 0) OR (Value  > 65535)) Then Exit Property
        FPosition = Value
        #IfNDef __USE_GTK__
			If Handle Then Perform(PBM_SETPOS, Value, 0)
		#EndIf
    End Property

    Property ProgressBar.StepValue As Integer
        Return FStep
    End Property

    Property ProgressBar.StepValue(Value As Integer)
        If Value <> FStep then
            FStep = Value
            #IfNDef __USE_GTK__
				If Handle Then Perform(PBM_SETSTEP, FStep, 0)
			#EndIf
		End If
    End Property

    Property ProgressBar.Smooth As Boolean
        Return FSmooth
    End Property

    Property ProgressBar.Smooth(Value As Boolean)
        If FSmooth <> Value Then
            FSmooth = Value
			#IfNDef __USE_GTK__
				Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR ASmooth(Abs_(FSmooth))
			#EndIf
        End If
    End Property

    Property ProgressBar.Style As Integer
        Return FStyle
    End Property

    Property ProgressBar.Style(Value As Integer)
        Dim As Integer OldStyle, Temp
        OldStyle = FStyle
        If FStyle <> Value Then
            FStyle = Value
            If OldStyle = 0 Then
                Temp = This.Width
                This.Width = This.Height
                This.Height = Temp
            End If
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR ASmooth(Abs_(FSmooth))
			#EndIf
        End If
    End Property

	#IfNDef __USE_GTK__
		Sub ProgressBar.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With  QProgressBar(Sender.Child)
					If .FMode32 Then 
						.Perform(PBM_SETRANGE32, .FMinValue, .FMaxValue)
					Else 
						.Perform(PBM_SETRANGE, 0, MakeLong(.FMinValue, .FMaxValue))
					End If
					.Perform(PBM_SETSTEP, .FStep, 0)
					.Position = .FPosition
				End With
			End If
		End Sub
	
		Sub ProgressBar.WndProc(BYREF Message As Message)
		End Sub

		Sub ProgressBar.ProcessMessage(BYREF Message As Message)
		End Sub
	#EndIf

    Sub ProgressBar.StepIt
		#IfNDef __USE_GTK__
			If Handle Then Perform(PBM_STEPIT, 0, 0)
		#EndIf
    End Sub

    Sub ProgressBar.StepBy(Delta As Integer)
		#IfNDef __USE_GTK__
			If Handle Then  Perform(PBM_DELTAPOS, Delta, 0)
		#EndIf
    End Sub

    Operator ProgressBar.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor ProgressBar
		#IfDef __USE_GTK__
			widget = gtk_progress_bar_new()
		#Else
			Dim As INITCOMMONCONTROLSEX ICC
			ICC.dwSize = SizeOF(ICC)
			ICC.dwICC  = ICC_PROGRESS_CLASS
			FMode32 = InitCommonControlsEx(@ICC)
			ASmooth(0) = 0
			ASmooth(1) = PBS_SMOOTH
			AStyle(0)  = 0
			AStyle(1)  = PBS_VERTICAL
		#EndIf
        FMinValue  = 0
        FMaxValue  = 100
        FStep      = 10
        With This
			.Child             = @This
            #IfNDef __USE_GTK__
				.RegisterClass "ProgressBar", PROGRESS_CLASS
				.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD OR AStyle(Abs_(FStyle)) OR ASmooth(Abs_(FSmooth))
				.OnHandleIsAllocated = @HandleIsAllocated
				WLet FClassAncestor, PROGRESS_CLASS
				.Height            = GetSystemMetrics(SM_CYVSCROLL)
            #EndIf
            WLet FClassName, "ProgressBar"
            .Width             = 150
        End With  
    End Constructor

    Destructor ProgressBar
    End Destructor
End namespace
