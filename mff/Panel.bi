'###############################################################################
'#  Panel.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TPanel.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "ContainerControl.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#DEFINE QPanel(__Ptr__) *Cast(Panel Ptr,__Ptr__)

	Enum Bevel
		 bvNone, bvLowered,bvRaised
	End Enum  

	Type Panel Extends ContainerControl
		Private:
			FTopColor    As Integer
			FBottomColor As Integer
			FBevelInner  As Integer
			FBevelOuter  As Integer
			FBorderWidth As Integer
			FBevelWidth  As Integer
			#IfNDef __USE_GTK__
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub AdjustColors(FBevel As Integer)
				Declare Sub DoRect(R As RECT)
				Declare Sub Frame3D(R As RECT, AWidth As Integer)
			#EndIf
		Public:
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			'Canvas        As My.Sys.Drawing.Canvas
			Declare Property BevelInner As Integer
			Declare Property BevelInner(Value As Integer)
			Declare Property BevelOuter As Integer
			Declare Property BevelOuter(Value As Integer)
			Declare Property BevelWidth As Integer
			Declare Property BevelWidth(Value As Integer)
			Declare Property BorderWidth As Integer
			Declare Property BorderWidth(Value As Integer)
			Declare Operator Cast As Control Ptr 
			Declare Constructor
			Declare Destructor
			#IfNDef __USE_GTK__
				OnPaint     As Sub(BYREF Sender As Panel,DC As HDC,R As Rect)
			#EndIf
	End Type

	Property Panel.BevelInner As Integer
		Return FBevelInner
	End Property

	Property Panel.BevelInner(Value As Integer)
		FBevelInner = Value
		Invalidate
	End Property

	Property Panel.BevelOuter As Integer
		Return FBevelOuter
	End Property

	Property Panel.BevelOuter(Value As Integer)
		FBevelOuter = Value
		Invalidate
	End Property

	Property Panel.BevelWidth As Integer
		Return FBevelWidth
	End Property

	Property Panel.BevelWidth(Value As Integer)
		FBevelWidth = Value
		Invalidate
	End Property

	Property Panel.BorderWidth As Integer
		Return FBorderWidth
	End Property

	Property Panel.BorderWidth(Value As Integer)
		FBorderWidth = Value
		Invalidate
	End Property

	#IfNDef __USE_GTK__
		Sub Panel.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QPanel(Sender.Child) 
				End With
			End If
		End Sub

		Sub Panel.WndProc(BYREF Message As Message)
		End Sub
	#EndIf
		Sub Panel.ProcessMessage(BYREF Message As Message)
			#IfNDef __USE_GTK__
				Select Case Message.Msg
				Case WM_PAINT
					 Dim As Integer W,H
					 Dim As HDC Dc,memDC
					 Dim As HBITMAP Bmp
					 Dim As Rect R
					 GetClientRect Handle,@R
					 Dc = GetDC(Handle)
					 If DoubleBuffered Then
						MemDC = CreateCompatibleDC(DC)
						Bmp   = CreateCompatibleBitmap(DC,R.Right,R.Bottom)
						SelectObject(MemDc,Bmp)
						SendMessage(Handle,WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
						FillRect memDc,@R,This.Brush.Handle
						SetBkColor(memDC,TRANSPARENT)
						H = Canvas.TextHeight("Wg")
						W = Canvas.TextWidth(Text)
						Canvas.TextOut((R.Right - W)/2 ,(R.Bottom - H)/2,Text,Font.Color,-1)
						SetBkColor(memDC,OPAQUE)
						If FBevelInner <> bvNone then
						   AdjustColors(FBevelInner)
						   Frame3D(R, FBevelWidth)
						End If
						Frame3D(R, FBorderWidth)
						If FBevelOuter <> bvNone then
						   AdjustColors(FBevelOuter)
						   Frame3D(R, FBevelWidth)
						End If
						If OnPaint Then OnPaint(This,memDC,R)
						BitBlt(DC, 0, 0, R.Right, R.Bottom, MemDC, 0, 0, SRCCOPY)
						DeleteObject(Bmp)
						DeleteDC(MemDC)
					 Else
						FillRect Dc,@R,This.Brush.Handle
						H = Canvas.TextHeight("Wg")
						W = Canvas.TextWidth(Text)
						Canvas.TextOut((R.Right - W)/2 ,(R.Bottom - H)/2,Text,Font.Color,-1)
						If FBevelInner <> bvNone then
						   AdjustColors(FBevelInner)
						   Frame3D(R, FBevelWidth)
						End If
						Frame3D(R, FBorderWidth)
						If FBevelOuter <> bvNone then
						   AdjustColors(FBevelOuter)
						   Frame3D(R, FBevelWidth)
						End If
						If OnPaint Then OnPaint(This,DC,R) 
					 End If
					 ReleaseDC Handle, Dc
					 Message.Result = 0
				End Select
			#EndIf
			Base.ProcessMessage(Message)
		End Sub

	#IfNDef __USE_GTK__
		Sub Panel.AdjustColors(FBevel As Integer)
			FTopColor = GetSysColor(COLOR_BTNHIGHLIGHT)
			If FBevel = bvLowered Then FTopColor = GetSysColor(COLOR_BTNSHADOW)
			FBottomColor = GetSysColor(COLOR_BTNSHADOW)
			If FBevel = bvLowered then FBottomColor = GetSysColor(COLOR_BTNHIGHLIGHT)
		End Sub

		Sub Panel.DoRect(R As RECT)
			Canvas.Pen.Color = FTopColor
			Canvas.Line(R.Left,R.Top,R.Right,R.Top)
			Canvas.Line(R.Left,R.Top,R.Left,R.Bottom)
			Canvas.Pen.Color = FBottomColor
			Canvas.Line(R.Right,R.Top,R.Right,R.Bottom)
			Canvas.Line(R.Left,R.Bottom,R.Right,R.Bottom)
		End Sub
		  
		Sub Panel.Frame3D(R As RECT,AWidth As Integer)
			Canvas.Pen.Size = 1
			R.Bottom -= 1
			R.Right  -= 1
			While AWidth > 0
				AWidth -= 1
				DoRect(R)
				InflateRect(@R, -1, -1)
			WEnd
			R.Bottom += 1
			R.Right  += 1
		End Sub
	#EndIf

	Operator Panel.Cast As Control Ptr 
		Return Cast(Control Ptr, @This)
	End Operator

	Constructor Panel
		With This
			#IfDef __USE_GTK__
				'widget = gtk_scrolled_window_new(null, null)
				'widget = gtk_layout_new(null, null)
				'widget = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
					'gtk_container_add(GTK_CONTAINER(widget), box)
					widget = gtk_layout_new(null, null)
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
			#EndIf
			FBorderWidth = 0
			'PopupMenu.Ctrl = This
			Canvas.Ctrl    = This
			.Child       = @This
			#IfNDef __USE_GTK__
				.RegisterClass "Panel"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
			WLet FClassName, "Panel"
			.Width       = 121
			.Height      = 41
		End With 
	End Constructor

	Destructor Panel
		#IfNDef __USE_GTK__
			UnregisterClass "Panel",GetModuleHandle(NULL)
		#EndIf 
	End Destructor
End namespace
