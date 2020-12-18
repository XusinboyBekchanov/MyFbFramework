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


Namespace My.Sys.Forms
	Property VScrollBar.MinValue As Integer
		Return FMin
	End Property
	
	Property VScrollBar.MinValue(Value As Integer)
		FMin = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#endif
	End Property
	
	Property VScrollBar.MaxValue As Integer
		Return FMax
	End Property
	
	Property VScrollBar.MaxValue(Value As Integer)
		FMax = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
		#endif
	End Property
	
	Property VScrollBar.Position As Integer
		Return FPosition
	End Property
	
	Property VScrollBar.Position(Value As Integer)
		FPosition = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(SBM_SETPOS, FPosition, True)
		#endif
	End Property
	
	Property VScrollBar.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property
	
	Property VScrollBar.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
	End Property
	
	Property VScrollBar.PageSize As Integer
		Return FPageSize
	End Property
	
	Property VScrollBar.PageSize(Value As Integer)
		If FPageSize > FMax Or Value = FPageSize Then Exit Property
		FPageSize = Value
		#IfNDef __USE_GTK__
			SIF.fMask = SIF_PAGE
			SIF.nPage = FPageSize
			If Handle Then Perform(SBM_SETSCROLLINFO, True, CInt(@SIF))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub VScrollBar.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QVScrollBar(Sender.Child)
					.MinValue = .MinValue
					.MaxValue = .MaxValue
					.Position = .Position
					.PageSize = .PageSize
				End With
			End If
		End Sub
		
		Sub VScrollBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
		
	Sub VScrollBar.ProcessMessage(ByRef Message As Message)
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
	
	Operator VScrollBar.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor VScrollBar
		#ifdef __USE_GTK__
			widget = gtk_vscrollbar_new(NULL)
			This.RegisterClass "VScrollBar", @This
		#else
			SIF.cbSize = SizeOf(SCROLLINFO)
		#endif
		FMin       = 0
		FMax       = 100
		FPosition  = 0
		PageSize   = 1
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
	
	Destructor VScrollBar
	End Destructor
End Namespace
