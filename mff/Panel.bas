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
			Case "transparent": Return @FTransparent
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
				Case "transparent": This.Transparent = QBoolean(Value)
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
	
	#ifdef __USE_WASM__
		Private Function Panel.GetContent() As UString
			Return ""
		End Function
	#endif
	
	Private Sub Panel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBkMode Dc, Transparent
				SetTextColor Dc, Font.Color
				If Not FTransparent OrElse FDesignMode Then
					SetBkColor Dc, FBackColor
					SetBkMode Dc, OPAQUE
				Else
					Message.Result = Cast(LRESULT, GetStockObject(NULL_BRUSH))
				End If
			Case WM_PAINT 
				Dim As HDC Dc, memDC
				Dim As HBITMAP MemBmp
				Dim As PAINTSTRUCT Ps
				Dim As ..Rect R
				GetClientRect Handle, @R
				Dc = BeginPaint(Handle, @Ps)
				If Dc = 0 Then
					EndPaint This.Handle, @Ps
					Message.Result = 0
					Return
				End If
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then SetDark True
				Else
					If FDarkMode Then SetDark False
				End If
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					MemBmp   = CreateCompatibleBitmap(Dc, R.Right - R.Left, R.Bottom - R.Top)
					SelectObject(memDC, MemBmp)
					FillRect memDC, @R, Brush.Handle
					Canvas.Handle = memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.Handle = Dc
				End If
				Canvas.HandleSetted = True
				If Graphic.Visible AndAlso Graphic.Bitmap.Handle > 0 Then
					With This
						Select Case Graphic.StretchImage
						Case StretchMode.smNone
							Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, , , Graphic.Bitmap
						Case StretchMode.smStretch
							Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, ScaleX(.Width) * Graphic.ScaleFactor, ScaleY(.Height) * Graphic.ScaleFactor, Graphic.Bitmap
						Case Else 'StretchMode.smStretchProportional
							Dim As Double imgWidth = Graphic.Bitmap.Width
							Dim As Double imgHeight = Graphic.Bitmap.Height
							Dim As Double PicBoxWidth = ScaleX(.Width) * Graphic.ScaleFactor
							Dim As Double PicBoxHeight = ScaleY(.Height) * Graphic.ScaleFactor
							Dim As Double img_ratio = imgWidth / imgHeight
							Dim As Double PicBox_ratio =  PicBoxWidth / PicBoxHeight
							If (PicBox_ratio >= img_ratio) Then
								imgHeight = PicBoxHeight
								imgWidth = imgHeight *img_ratio
							Else
								imgWidth = PicBoxWidth
								imgHeight = imgWidth / img_ratio
							End If
							If Graphic.CenterImage Then
								Canvas.DrawAlpha Max((PicBoxWidth - imgWidth * Graphic.ScaleFactor) / 2, Graphic.StartX), Max((PicBoxHeight - imgHeight * Graphic.ScaleFactor) / 2, Graphic.StartY), imgWidth * Graphic.ScaleFactor, imgHeight * Graphic.ScaleFactor, Graphic.Bitmap
							Else
								Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, imgWidth, imgHeight, Graphic.Bitmap
							End If
						End Select
					End With
				End If
				If ShowCaption Then
					Canvas.Font.Size = Canvas.Font.Size
					Canvas.TextOut(Current.X, Current.Y, FText, Font.Color, FBackColor)
				End If
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					DeleteObject(MemBmp)
					DeleteDC(memDC)
				End If
				Canvas.HandleSetted = False
					If FBevelInner <> bvNone Then
						AdjustColors(FBevelInner)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					If FBevelOuter <> bvNone Then
						AdjustColors(FBevelOuter)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
				EndPaint Handle, @Ps
				Message.Result = 0
				Return
			Case CM_COMMAND
				If Message.wParamHi = STN_CLICKED Then
					If OnClick Then OnClick(*Designer, This)
				End If
				If Message.wParamHi = STN_DBLCLK Then
					If OnDblClick Then OnDblClick(*Designer, This)
				End If
			Case WM_SIZE
				InvalidateRect(Handle, NULL, True)
			Case CM_DRAWITEM
				
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
			Canvas.Line(R.Left, R.Top, R.Right, R.Top)
			Canvas.Line(R.Left, R.Top, R.Left, R.Bottom)
			Canvas.Pen.Color = FBottomColor
			Canvas.Line(R.Right, R.Top, R.Right, R.Bottom)
			Canvas.Line(R.Left, R.Bottom, R.Right, R.Bottom)
		End Sub
		
		Private Sub Panel.Frame3D(R As My.Sys.Drawing.Rect, AWidth As Integer)
			Canvas.Pen.Size = 1
			R.Bottom -= 1
			R.Right  -= 1
			While AWidth > 0
				AWidth -= 1
				DoRect(R)
				InflateRect(Cast(..Rect Ptr, @R), -1, -1)
			Wend
			R.Bottom += 1
			R.Right  += 1
		End Sub
	#endif
	
	Property Panel.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property Panel.Visible(Value As Boolean)
		Base.Visible = Value
	End Property
	
	Private Property Panel.Transparent As Boolean
		Return FTransparent
	End Property
	
	Private Property Panel.Transparent(Value As Boolean)
		FTransparent = Value
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
	
	Private Sub Panel.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
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
					'QForm(.Ctrl->Child).ChangeStyle SS_BITMAP, True
					'QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Bitmap.Handle))
					'					Case 1
					'QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 2
					'QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 3
					'QForm(.Ctrl->Child).ChangeStyle SS_ENHMETAFILE, True
					'QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(0))
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
				FDefaultBackColor = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "div")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "Panel")
			.Width       = 121
			.Height      = 41
			.ShowCaption = False
		End With
	End Constructor
	
	Private Destructor Panel
		#ifdef __USE_WINAPI__
			UnregisterClass "Panel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


