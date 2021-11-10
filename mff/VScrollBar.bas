'###############################################################################
'#  VScrollBar.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "VScrollBar.bi"

Namespace My.Sys.Forms
	Private Function VScrollBar.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "arrowchangesize": Return @This.FArrowChangeSize
		Case "maxvalue": Return @This.FMax
		Case "minvalue": Return @This.FMin
		Case "pagesize": Return @This.FPageSize
		Case "position": Return @This.FPosition
		Case "style": Return @This.FStyle
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function VScrollBar.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "arrowchangesize": This.ArrowChangeSize = QInteger(Value)
		Case "maxvalue": This.MaxValue = QInteger(Value)
		Case "minvalue": This.MinValue = QInteger(Value)
		Case "pagesize": This.PageSize = QInteger(Value)
		Case "position": This.Position = QInteger(Value)
		Case "style": This.Style = *Cast(ScrollBarControlStyle Ptr, Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property VScrollBar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property VScrollBar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property VScrollBar.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property VScrollBar.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property VScrollBar.MinValue As Integer
		Return FMin
	End Property
	
	Private Property VScrollBar.MinValue(Value As Integer)
		FMin = Value
		#ifdef __USE_GTK__
			gtk_range_set_range(gtk_range(widget), FMin, FMax)
		#else
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#endif
	End Property
	
	Private Property VScrollBar.MaxValue As Integer
		Return FMax
	End Property
	
	Private Property VScrollBar.MaxValue(Value As Integer)
		FMax = Value
		#ifdef __USE_GTK__
			gtk_range_set_range(gtk_range(widget), FMin, FMax)
		#else
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#endif
	End Property
	
	Private Property VScrollBar.Position As Integer
		#ifdef __USE_GTK__
			FPosition = gtk_range_get_value(gtk_range(widget))
		#else
			If Handle Then FPosition = Perform(SBM_GETPOS, 0, 0)
		#endif
		Return FPosition
	End Property
	
	Private Property VScrollBar.Position(Value As Integer)
		FPosition = Value
		#ifdef __USE_GTK__
			gtk_range_set_value(gtk_range(widget), CDbl(Value))
		#else
			If Handle Then Perform(SBM_SETPOS, FPosition, True)
		#endif
	End Property
	
	Private Property VScrollBar.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property
	
	Private Property VScrollBar.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
		#ifdef __USE_GTK__
			gtk_range_set_increments(gtk_range(widget), FArrowChangeSize, FPageSize)
		#endif
	End Property
	
	Private Property VScrollBar.PageSize As Integer
		Return FPageSize
	End Property
	
	Private Property VScrollBar.PageSize(Value As Integer)
		If FPageSize > FMax Or Value = FPageSize Then Exit Property
		FPageSize = Value
		#ifdef __USE_GTK__
			gtk_range_set_increments(gtk_range(widget), FArrowChangeSize, FPageSize)
		#else
			SIF.fMask = SIF_PAGE
			SIF.nPage = FPageSize
			If Handle Then Perform(SBM_SETSCROLLINFO, True, CInt(@SIF))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Sub VScrollBar.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QVScrollBar(Sender.Child)
					.MinValue = .MinValue
					.MaxValue = .MaxValue
					.Position = .Position
					.PageSize = .PageSize
				End With
			End If
		End Sub
		
		Private Sub VScrollBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
		
	Private Sub VScrollBar.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Static As Integer OldPos
			Select Case Message.Msg
			Case WM_PAINT
				'            #IF DEFINED(APPLICATION)
				'            If UCase(Application.OSVersion) = "WINDOWS XP" Then
				'               Hint = This.Hint 'XP ?!
				'            End If
				'            #ENDIF
				Message.Result = 0
			Case CM_CREATE
				sif.cbSize = SizeOf(sif)
				sif.fMask  = SIF_RANGE Or SIF_PAGE
				sif.nMin   = FMin
				sif.nMax   = FMax
				sif.nPage  = FPageSize
				SetScrollInfo(FHandle, SB_CTL, @sif, True)
			Case CM_HSCROLL, CM_VSCROLL
				Var lo = LoWord(Message.wParam)
				sif.cbSize = SizeOf(sif)
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
				SetScrollInfo(FHandle, SB_CTL, @sif, True)
				GetScrollInfo(FHandle, SB_CTL, @sif)
				If (Not sif.nPos = OldPos) Then
					If OnScroll Then
						OnScroll(This, Cast(UInteger, sif.nPos))
					End If
				End If
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Private Operator VScrollBar.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub VScrollBar.Range_ValueChanged(range As GtkRange Ptr, user_data As Any Ptr)
			Dim As VScrollBar Ptr scr = user_data
			If scr->OnScroll Then scr->OnScroll(*scr, gtk_range_get_value(range))
		End Sub
	#endif
	
	Private Constructor VScrollBar
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				widget = gtk_scrollbar_new(GTK_ORIENTATION_VERTICAL, NULL)
			#else
				widget = gtk_vscrollbar_new(NULL)
			#endif
			g_signal_connect(widget, "value-changed", G_CALLBACK(@Range_ValueChanged), @This)
			This.RegisterClass "VScrollBar", @This
		#else
			SIF.cbSize = SizeOf(SCROLLINFO)
		#endif
		MaxValue        = 100
		MinValue        = 0
		Position        = 0
		ArrowChangeSize = 1
		PageSize        = 3
		FTabIndex          = -1
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "VScrollBar", "ScrollBar"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				Base.Style       = WS_CHILD Or SB_VERT
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			WLet(FClassName, "VScrollBar")
			WLet(FClassAncestor, "ScrollBar")
			.Width       = 17
			.Height      = 121
		End With
	End Constructor
	
	Private Destructor VScrollBar
	End Destructor
End Namespace
