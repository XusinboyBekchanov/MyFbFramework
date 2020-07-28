'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatusBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "StatusBar.bi"

Namespace My.Sys.Forms
	Property StatusPanel.Caption ByRef As WString
		Return *FCaption
	End Property
	
	Property StatusPanel.Caption(ByRef Value As WString)
		FCaption = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
		*FCaption = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Property StatusPanel.Width As Integer
		Return FWidth
	End Property
	
	Property StatusPanel.Width(Value As Integer)
		FWidth = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Property StatusPanel.Bevel As BevelStyle
		Return FBevel
	End Property
	
	Property StatusPanel.Bevel(Value As BevelStyle)
		FBevel = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Property StatusPanel.Alignment As Integer
		Return FAlignment
	End Property
	
	Property StatusPanel.Alignment(Value As Integer)
		FAlignment = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Operator StatusPanel.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator StatusPanel.Let(ByRef Value As WString)
		Caption = Value
	End Operator
	
	Constructor StatusPanel
		FCaption = CAllocate(0)
		Caption   = ""
		FWidth     = 50
		FAlignment = 0
		FBevel     = 0
	End Constructor
	
	Destructor StatusPanel
		If FCaption Then Deallocate FCaption
	End Destructor
	
	Function StatusBar.Add(ByRef wText As WString) As StatusPanel Ptr
		Count += 1
		Panels = Reallocate(Panels, SizeOf(StatusPanel) * Count)
		Panels[Count -1] = New StatusPanel
		Panels[Count -1]->Index     = Count - 1
		Panels[Count -1]->Width     = 50
		Panels[Count -1]->Caption   = wText
		Panels[Count -1]->Alignment = 0
		Panels[Count -1]->Bevel     = pbLowered
		Panels[Count -1]->StatusBarControl = @This
		UpdatePanels
		Return Panels[Count - 1]
	End Function
	
	Sub StatusBar.Remove(Index As Integer)
		Dim As StatusPanel Ptr Ptr Temp
		Dim As Integer i, x = 0
		If Index >= 0 And Index <= Count -1 Then
			#ifdef __USE_GTK__
				gtk_statusbar_remove(gtk_statusbar(widget), context_id, Panels[i]->message_id)
			#endif
			Temp = CAllocate((Count - 1) * SizeOf(StatusPanel))
			x = 0
			For i = 0 To Count -1
				If i <> Index Then
					x += 1
					Temp[x -1] = Panels[i]
				End If
			Next i
			Count -= 1
			Panels = CAllocate(Count*SizeOf(StatusPanel))
			For i = 0 To Count -1
				Panels[i] = Temp[i]
			Next i
			Deallocate Temp
		End If
		UpdatePanels
	End Sub
	
	Sub StatusBar.Clear
		For i As Integer = Count -1 To 0 Step -1
			Remove i
		Next i
		Count = 0
		#ifdef __USE_GTK__
			gtk_statusbar_remove_all(gtk_statusbar(widget), context_id)
		#else
			SetWindowText Handle, ""
		#endif
	End Sub
	
	Sub StatusBar.UpdatePanels
		Dim As Long i, FWidth()
		Dim As WString Ptr s
		Dim As WString Ptr ss
		ReDim FWidth(Count - 1)
		If Count > 0 Then
			For i = 0 To Count - 1
				If i = 0 Then
					FWidth(i) = Panels[i]->Width
				Else
					FWidth(i) = Panels[i]->Width  + FWidth(i -1)
				End If
			Next i
			FWidth(Count - 1) = -1
			#ifndef __USE_GTK__
				Perform(SB_SETPARTS, Count, Cast(LParam, CInt(@FWidth(0))))
			#endif
			For i = 0 To Count - 1
				If Panels[i]->Alignment = 0 Then
					WLet s, Panels[i]->Caption
				ElseIf Panels[i]->Alignment = 1 Then
					WLet s, Chr(9)+Panels[i]->Caption
				ElseIf Panels[i]->Alignment = 2 Then
					WLet s, Chr(9) & Chr(9) & Panels[i]->Caption
				Else
					WLet s, Panels[i]->Caption
				End If
				#ifndef __USE_GTK__
					Perform(SB_SETTEXT, i Or Panels[i]->Bevel, Cast(LParam, CInt(s)))
				#endif
				WLet ss, *ss & IIf(i = 0, "", !"\t") & Panels[i]->Caption
			Next i
		End If
		#ifdef __USE_GTK__
			gtk_statusbar_push(gtk_statusbar(widget), context_id, ToUTF8(*ss))
		#endif
		Invalidate
		WDeallocate s
		WDeallocate ss
	End Sub
	
	Property StatusBar.Panel(Index As Integer) As StatusPanel
		If Index >= 0 And Index <= Count -1 Then
			Return *Panels[Index]
		End If
	End Property
	
	Property StatusBar.Panel(Index As Integer, Value As StatusPanel)
		If Index >= 0 And Index <= Count -1 Then
			Panels[Index] = Value
		End If
	End Property
	
	Property StatusBar.Color As Integer
		Return Base.BackColor
	End Property
	
	Property StatusBar.Color(Value As Integer)
		Base.BackColor = Value
		#ifndef __USE_GTK__
			If Handle Then SendMessage(Handle, SB_SETBKCOLOR, 0, Base.BackColor)
		#endif
	End Property
	
	Property StatusBar.SizeGrip As Boolean
		Return FSizeGrip
	End Property
	
	Property StatusBar.SizeGrip(Value As Boolean)
		If Value <> FSizeGrip Then
			FSizeGrip = Value
			#ifndef __USE_GTK__
				Style  = WS_CHILD Or CCS_NOPARENTALIGN Or AStyle(Abs_(FSizeGrip))
			#endif
			RecreateWnd
		End If
	End Property
	
	Property StatusBar.SimplePanel As Boolean
		Return FSimplePanel
	End Property
	
	Property StatusBar.SimplePanel(Value As Boolean)
		If Value <> FSimplePanel Then
			FSimplePanel = Value
			#ifndef __USE_GTK__
				If Handle Then
					SendMessage(Handle, SB_SIMPLE, FSimplePanel, 0)
					SimpleText = *FSimpleText
				End If
			#endif
		End If
	End Property
	
	Property StatusBar.SimpleText ByRef As WString
		Return *FSimpleText
	End Property
	
	Property StatusBar.SimpleText(ByRef Value As WString)
		If SimplePanel Then
			FSimpleText = Reallocate(FSimpleText, (Len(Value) + 1) * SizeOf(WString))
			*FSimpleText = Value
			Text = *FSimpleText
			#ifndef __USE_GTK__
				If FHandle Then SendMessage(Handle, SB_SETTEXT, 255, CInt(@Value))
			#endif
		End If
	End Property
	
	#ifndef __USE_GTK__
		Sub StatusBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QStatusBar(Sender.Child)
					SetClassLong .Handle, GCL_STYLE, GetClassLong(.Handle,GCL_STYLE) And Not CS_HREDRAW
					.Perform(SB_SETBKCOLOR, 0, .Color)
					.SimpleText = .SimpleText
					.SimplePanel = .SimplePanel
					.UpdatePanels
				End With
			End If
		End Sub
		
		Sub StatusBar.WndProc(ByRef Message As Message)
		End Sub
		
		Sub StatusBar.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator StatusBar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor StatusBar
		With This
			FSimpleText = CAllocate(0)
			#ifdef __USE_GTK__
				widget = gtk_statusbar_new
				'gtk_statusbar_set_has_resize_grip(gtk_statusbar(widget), true)
				.RegisterClass "StatusBar", @This
				WLet FSimpleText, "StatusBar"
				context_id = gtk_statusbar_get_context_id(gtk_statusbar(widget), *FSimpleText)
				'Var cont2 = gtk_statusbar_get_context_id(gtk_statusbar(widget), "statusbar 2")
				'gtk_statusbar_push(gtk_statusbar(widget), cont2, *FSimpleText)
				
			#else
				AStyle(0) = 0
				AStyle(1) = SBARS_SIZEGRIP
			#endif
			FSizeGrip = True
			WLet FClassName, "StatusBar"
			WLet FClassAncestor, "msctls_StatusBar32"
			#ifndef __USE_GTK__
				.RegisterClass "StatusBar","msctls_StatusBar32"
				'David Change
				.Style        = WS_CHILD Or CCS_NOPARENTALIGN Or AStyle(Abs_(FSizeGrip)) Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS Or CCS_BOTTOM Or SBARS_TOOLTIPS
				.ExStyle      = 0
				.Color        = GetSysColor(COLOR_BTNFACE)
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			#ifdef __USE_GTK3__
				.Height       = 35
			#else
				.Height       = 21
			#endif
			.Width        = 175
			.Child        = @This
		End With
	End Constructor
	
	Destructor StatusBar
		Panels = CAllocate(0)
		#ifndef __USE_GTK__
			UnregisterClass "StatusBar",GetModuleHandle(NULL)
		#endif
		Deallocate FSimpleText
	End Destructor
End Namespace
