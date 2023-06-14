'###############################################################################
'#  Panel.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TPanel.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Panel.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function Panel.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Panel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Panel.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property Panel.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property Panel.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property Panel.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property Panel.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property Panel.Text(ByRef Value As WString)
		Base.Text = Value
	End Property
		
	Private Property Panel.BevelInner As Integer
		Return FBevelInner
	End Property
	
	Private Property Panel.BevelInner(Value As Integer)
		FBevelInner = Value
		Invalidate
	End Property
	
	Private Property Panel.BevelOuter As Integer
		Return FBevelOuter
	End Property
	
	Private Property Panel.BevelOuter(Value As Integer)
		FBevelOuter = Value
		Invalidate
	End Property
	
	Private Property Panel.BevelWidth As Integer
		Return FBevelWidth
	End Property
	
	Private Property Panel.BevelWidth(Value As Integer)
		FBevelWidth = Value
		Invalidate
	End Property
	
	Private Property Panel.BorderWidth As Integer
		Return FBorderWidth
	End Property
	
	Private Property Panel.BorderWidth(Value As Integer)
		FBorderWidth = Value
		Invalidate
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub Panel.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPanel(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub Panel.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	Private Sub Panel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_MOUSEMOVE
				If FDownButton = True Then RedrawWindow(FHandle, NULL, NULL, RDW_INVALIDATE)
			Case WM_LBUTTONUP
				If FDownButton AndAlso Graphic.Bitmap.Handle <> 0 Then
					This.Visible= False 
					This.Visible= True 
				End If
				FDownButton = False
			Case WM_LBUTTONDOWN
				FDownButton = True
				If Handle AndAlso Graphic.Bitmap.Handle <> 0 Then SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE)
'			Case WM_ERASEBKGND
'				If OnPaint Then OnPaint(This, Canvas)
			Case WM_PAINT, WM_CREATE, WM_ERASEBKGND
				Dim As Integer W,H
				Dim As HDC Dc, memDC
				Dim As HBITMAP Bmp
				Dim As ..Rect R, RFrame
				GetClientRect Handle, @R
				Dc = GetDC(Handle)
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
'						FDarkMode = True
'						Brush.Handle = hbrBkgnd
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				Else
					If FDarkMode Then
						SetDark False
'						FDarkMode = False
'						If FBackColor = -1 Then
'							Brush.Handle = 0
'						Else
'							Brush.Color = FBackColor
'						End If
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				End If
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					Bmp   = CreateCompatibleBitmap(Dc, R.Right, R.Bottom)
					SelectObject(memDC, Bmp)
					'SendMessage(Handle, WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
					If Graphic.Bitmap.Handle = 0 Then 
						FillRect Dc, @R, This.Brush.Handle
					Else
						Canvas.DrawAlpha 0, 0, ScaleX(Width), ScaleY(Height), Graphic.Bitmap
					End If
					SetBkMode(memDC, TRANSPARENT)
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					SetBkColor(memDC, OPAQUE)
					
					'Canvas.TextOut((R.Right - W)/2,(R.Bottom - H)/2,Text,Font.Color,-1)
					If Text <> "" Then 'David Change
'						RFrame=R
'						'InflateRect(@RFrame, -1, -1)
'						RFrame.Top=R.Top+H/2
'						DoRect(RFrame,clScrollBar,clScrollBar)'cl3DDkShadow clBtnShadow
'						Canvas.Pen.Color = This.BackColor
'						Canvas.Pen.Size = 3
'						Canvas.Line(8,RFrame.Top-1,w+10,RFrame.Top-1)
'						Canvas.TextOut(10,0,Text,clWindowText,-1) 'David Change
					Else
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					End If
					If FBevelInner <> bvNone Then
						AdjustColors(FBevelInner)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					If FBevelOuter <> bvNone Then
						AdjustColors(FBevelOuter)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Canvas.HandleSetted = True
					Canvas.Handle = memDC
					If Graphic.Bitmap.Handle <> 0 Then Canvas.DrawAlpha 0, 0, ScaleX(Width), ScaleY(Height), Graphic.Bitmap
					If OnPaint Then OnPaint(This, Canvas)
					Canvas.HandleSetted = False
					BitBlt(Dc, 0, 0, R.Right, R.Bottom, memDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(memDC)
				Else
					SetBkMode Dc, TRANSPARENT
					If Graphic.Bitmap.Handle = 0 Then 
						FillRect Dc, @R, This.Brush.Handle
					Else
						Canvas.DrawAlpha 0, 0, ScaleX(Width), ScaleY(Height), Graphic.Bitmap
					End If
					SetBkColor Dc, OPAQUE
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					'Canvas.TextOut((R.Right - W)/2,(R.Bottom - H)/2,Text,Font.Color,-1)
					If Text<>"" Then 'David Change
'						RFrame=R
'						InflateRect(@RFrame, -1, -1)
'						RFrame.Top=R.Top+H/2
'						DoRect(RFrame,clScrollBar,clScrollBar)'cl3DDkShadow clBtnShadow
'						Canvas.Pen.Color = This.BackColor
'						Canvas.Pen.Size = 3
'						Canvas.Line(8,RFrame.Top-1,w+10,RFrame.Top-1)
'						Canvas.Pen.Size = 1
'						Canvas.TextOut(10,0,Text,clWindowText,-1) 'David Change
					Else
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					End If
					If FBevelInner <> bvNone Then
						AdjustColors(FBevelInner)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					If FBevelOuter <> bvNone Then
						AdjustColors(FBevelOuter)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Canvas.Handle = Dc
					If Graphic.Bitmap.Handle <> 0 Then Canvas.DrawAlpha 0, 0, ScaleX(Width), ScaleY(Height), Graphic.Bitmap
					If OnPaint Then OnPaint(This, Canvas)
				End If
				ReleaseDC Handle, Dc
				Message.Result = 0
				Exit Sub
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub Panel.AdjustColors(FBevel As Integer)
			FTopColor = GetSysColor(COLOR_BTNHIGHLIGHT)
			If FBevel = bvLowered Then FTopColor = GetSysColor(COLOR_BTNSHADOW)
			FBottomColor = GetSysColor(COLOR_BTNSHADOW)
			If FBevel = bvLowered Then FBottomColor = GetSysColor(COLOR_BTNHIGHLIGHT)
		End Sub
		
		Private Sub Panel.DoRect(R As My.Sys.Drawing.Rect, tTopColor As Integer = GetSysColor(COLOR_BTNSHADOW), tBottomColor As Integer = GetSysColor(COLOR_BTNSHADOW))
			Canvas.Pen.Color = FTopColor
			Canvas.Line(R.left, R.top, R.right, R.top)
			Canvas.Line(R.left, R.top, R.left, R.bottom)
			Canvas.Pen.Color = FBottomColor
			Canvas.Line(R.right, R.top, R.right, R.bottom)
			Canvas.Line(R.left, R.bottom, R.right, R.bottom)
		End Sub
		
		Private Sub Panel.Frame3D(R As My.Sys.Drawing.RECT, AWidth As Integer)
			Canvas.Pen.Size = 1
			R.bottom -= 1
			R.right  -= 1
			While AWidth > 0
				AWidth -= 1
				DoRect(R)
				InflateRect(Cast(..RECT Ptr, @R), -1, -1)
			Wend
			R.bottom += 1
			R.right  += 1
		End Sub
	#endif
	
	Property Panel.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property Panel.Visible(Value As Boolean)
		Base.Visible = Value
	End Property
	
	Private Operator Panel.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Sub Panel.CreateWnd
		Base.CreateWnd
		#ifdef __USE_JNI__
			layoutview = FHandle
		#endif
	End Sub
	
	Private Sub Panel.GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
					'If GTK_IS_IMAGE(QForm(.Ctrl->Child).ImageWidget) Then
					'	Select Case ImageType
					'	Case 0
					'		gtk_image_set_from_pixbuf(GTK_IMAGE(QForm(.Ctrl->Child).ImageWidget), .Bitmap.Handle)
					'	Case 1
					'		gtk_image_set_from_pixbuf(GTK_IMAGE(QForm(.Ctrl->Child).ImageWidget), .Icon.Handle)
					'	End Select
					'End If
				#else
					'					Select Case ImageType
					'					Case 0
					'						QForm(.Ctrl->Child).ChangeStyle SS_BITMAP, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Bitmap.Handle))
					'					Case 1
					'						QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 2
					'						QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 3
					'						QForm(.Ctrl->Child).ChangeStyle SS_ENHMETAFILE, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(0))
					'					End Select
					.Ctrl->Repaint
				#endif
			End If
		End With
	End Sub
	
	Private Constructor Panel
		With This
			#ifdef __USE_GTK__
				'widget = gtk_scrolled_window_new(null, null)
				'widget = gtk_layout_new(null, null)
				'widget = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
				'gtk_container_add(GTK_CONTAINER(widget), box)
				widget = gtk_layout_new(NULL, NULL)
				'gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
				'gtk_box_pack_end(Gtk_Box(widget), layoutwidget, true, true, 0)
				
				'gtk_widget_set_events(widget, _
				'         GDK_EXPOSURE_MASK Or _
				'         GDK_SCROLL_MASK Or _
				'        GDK_STRUCTURE_MASK Or _
				'       GDK_KEY_PRESS_MASK Or _
				'      GDK_KEY_RELEASE_MASK Or _
				'     GDK_FOCUS_CHANGE_MASK Or _
				'    GDK_LEAVE_NOTIFY_MASK Or _
				'   GDK_BUTTON_PRESS_MASK Or _
				'  GDK_BUTTON_RELEASE_MASK Or _
				' GDK_POINTER_MOTION_MASK Or _
				'GDK_POINTER_MOTION_HINT_MASK)
				
				'widget = gtk_fixed_new()
				'gtk_scrolled_window_set_policy(gtk_scrolled_window(widget), GTK_POLICY_EXTERNAL, GTK_POLICY_EXTERNAL)
				'gtk_scrolled_window_set_propagate_natural_width(gtk_scrolled_window(widget), true)
				'widget = gtk_fixed_new()
				.RegisterClass "Panel", @This
			#endif
			FBorderWidth = 0
			'FBevelWidth=2
			'PopupMenu.Ctrl = This
			.Child          = @This
			.Canvas.Ctrl    = @This
			.Graphic.Ctrl   = @This
			.Graphic.OnChange = @GraphicChange
			#ifdef __USE_WINAPI__
				.RegisterClass "Panel"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "Panel")
			.Width       = 121
			.Height      = 41
		End With
	End Constructor
	
	Private Destructor Panel
		#ifdef __USE_WINAPI__
			UnregisterClass "Panel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


