'###############################################################################
'#  ScrollBarControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################


Namespace My.Sys.Forms
	#DEFINE QScrollBarControl(__Ptr__) *Cast(ScrollBarControl Ptr,__Ptr__)

	Enum ScrollBarControlStyle
		sbHorizontal,sbVertical
	End Enum

	Type ScrollBarControl Extends Control
		Private:
			FStyle      	As ScrollBarControlStyle
			FMin        	As Integer
			FMax        	As Integer 
			FPosition   	As Integer
			FArrowChangeSize 	As Integer
			FPageSize   	As Integer
			AStyle(2)   	As Integer
			#IfNDef __USE_GTK__
				SIF         	As SCROLLINFO
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
		Public:
			Declare Property Style As ScrollBarControlStyle
			Declare Property Style(Value As ScrollBarControlStyle)
			Declare Property MinValue As Integer
			Declare Property MinValue(Value As Integer)
			Declare Property MaxValue As Integer
			Declare Property MaxValue(Value As Integer)
			Declare Property ArrowChangeSize As Integer
			Declare Property ArrowChangeSize(Value As Integer)
			Declare Property PageSize As Integer
			Declare Property PageSize(Value As Integer)
			Declare Property Position As Integer
			Declare Property Position(Value As Integer)
			Declare Operator Cast As Control Ptr
			Declare Constructor
			Declare Destructor
			OnCnange As Sub(BYREF Sender As ScrollBarControl)
			OnScroll As Sub(BYREF Sender As ScrollBarControl, ByRef NewPos As Integer)
	End Type

	Property ScrollBarControl.Style As ScrollBarControlStyle
		Return FStyle 
	End Property

	Property ScrollBarControl.Style(Value As ScrollBarControlStyle)
		Dim As ScrollBarControlStyle OldStyle
		Dim As Integer x
		OldStyle = FStyle
		If Value <> FStyle Then
			If OldStyle = sbHorizontal Then
			  x = Height
			  Height = This.Width
			  This.Width  = x
			Else
			  x = This.Width
			  This.Width = Height
			  Height  = x 
			End If
			FStyle = Value
			#IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle))
			#EndIf 
			If This.Parent Then This.Parent->RequestAlign
		End If
	End Property

	Property ScrollBarControl.MinValue As Integer
		Return FMin
	End Property

	Property ScrollBarControl.MinValue(Value As Integer)
		FMin = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#EndIf
	End Property

	Property ScrollBarControl.MaxValue As Integer
		Return FMax
	End Property

	Property ScrollBarControl.MaxValue(Value As Integer)
		FMax = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#EndIf
	End Property

	Property ScrollBarControl.Position As Integer
		Return FPosition
	End Property

	Property ScrollBarControl.Position(Value As Integer)
		FPosition = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(SBM_SETPOS, FPosition, True)
		#EndIf
		If OnScroll Then OnScroll(This, FPosition)
	End Property

	Property ScrollBarControl.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property

	Property ScrollBarControl.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
	End Property

	Property ScrollBarControl.PageSize As Integer
		Return FPageSize
	End Property

	Property ScrollBarControl.PageSize(Value As Integer)
		If FPageSize > FMax Or Value = FPageSize Then Exit Property
		FPageSize = Value
		#IfNDef __USE_GTK__
			SIF.fMask = SIF_PAGE
			SIF.nPage = FPageSize
			If Handle Then Perform(SBM_SETSCROLLINFO, True, CInt(@SIF))
		#EndIf
	End Property

	#IfNDef __USE_GTK__
		Sub ScrollBarControl.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QScrollBarControl(Sender.Child)
					 .MinValue = .MinValue
					 .MaxValue = .MaxValue
					 .Position = .Position
					 .PageSize = .PageSize
				End With
			End If
		End Sub

		Sub ScrollBarControl.WndProc(BYREF Message As Message)
		End Sub

		Sub ScrollBarControl.ProcessMessage(BYREF Message As Message)
			Static As Integer OldPos
			Select Case Message.Msg
			Case WM_PAINT
	'			#IF DEFINED(APPLICATION)
	'			If UCase(Application.OSVersion) = "WINDOWS XP" Then
	'			   Hint = This.Hint 'XP ?!
	'			End If
	'			#ENDIF
				Message.Result = 0
			Case CM_CREATE
				sif.cbSize = sizeof(sif)
				  sif.fMask  = SIF_RANGE Or SIF_PAGE
				  sif.nMin   = FMin
				  sif.nMax   = FMax
				  sif.nPage  = FPageSize
				SetScrollInfo(FHandle, SB_CTL, @sif, TRUE)
			Case CM_HSCROLL, CM_VSCROLL
				Var lo = Loword(Message.wParam)
				sif.cbSize = sizeof(sif)
					sif.fMask  = SIF_ALL
					GetScrollInfo (FHandle, SB_CTL, @sif)
				OldPos = sif.nPos
				Select Case lo
				Case SB_TOP, SB_LEFT
					sif.nPos = sif.nMin
				Case SB_BOTTOM, SB_RIGHT
					sif.nPos = sif.nMax
				Case SB_LINEUP, SB_LINELEFT
					sif.nPos -= FArrowChangeSize
				Case SB_LINEDOWN, SB_LINERIGHT
					sif.nPos += FArrowChangeSize
				Case SB_PAGEUP, SB_PAGELEFT
					sif.nPos -= sif.nPage
				Case SB_PAGEDOWN, SB_PAGERIGHT
					sif.nPos += sif.nPage
				Case SB_THUMBPOSITION, SB_THUMBTRACK
					sif.nPos = sif.nTrackPos
				End Select
				sif.fMask = SIF_POS
				  SetScrollInfo(FHandle, SB_CTL, @sif, TRUE)
				  GetScrollInfo(FHandle, SB_CTL, @sif)
				If (Not sif.nPos = OldPos) Then
					If OnScroll Then
					   OnScroll(This, Cast(Integer, sif.nPos))
					End If
					End If
			End Select
			Base.ProcessMessage(message)
		End Sub
	#EndIf

	Operator ScrollBarControl.Cast As Control Ptr 
		Return Cast(Control Ptr, @This)
	End Operator

	Constructor ScrollBarControl
		#IfDef __USE_GTK__
			#IfDef __USE_GTK3__
				widget = gtk_scrollbar_new(GTK_ORIENTATION_HORIZONTAL, NULL)
			#Else
				widget = gtk_hscrollbar_new(NULL)
			#EndIf
			This.RegisterClass "ScrollBarControl", @This
		#Else
			SIF.cbSize = SizeOF(SCROLLINFO)
		#EndIf
		FMin       = 0
		FMax       = 100
		FPosition  = 0
		PageSize   = 1
		#IfNDef __USE_GTK__
			AStyle(0)  = SB_HORZ
			AStyle(1)  = SB_VERT
		#EndIf
		With This
			.Child       = @This
			#IfNDef __USE_GTK__
				.RegisterClass "ScrollBarControl", "ScrollBar"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				Base.Style       = WS_CHILD OR AStyle(Abs_(FStyle))
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
			WLet FClassName, "ScrollBarControl"
			WLet FClassAncestor, "ScrollBar"
			.Width       = 121
			.Height      = 17
		End With  
	End Constructor

	Destructor ScrollBarControl
	End Destructor
End Namespace
