'###############################################################################
'#  PagePanel.bas                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "PagePanel.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function PagePanel.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "selectedpanel": Return SelectedPanel
			Case "selectedpanelindex": Return @FSelectedPanelIndex
			Case "tabindex": Return @FTabIndex
			Case "transparent": Return @FTransparent
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function PagePanel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "selectedpanel": SelectedPanel = Value
				Case "selectedpanelindex": SelectedPanelIndex = QInteger(Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "transparent": This.Transparent = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property PagePanel.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property PagePanel.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property PagePanel.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property PagePanel.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub PagePanel.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPagePanel(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub PagePanel.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	
	#ifdef __USE_WASM__
		Private Function PagePanel.GetContent() As UString
			Return ""
		End Function
	#endif
	
	Private Sub PagePanel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC, Message.wParam)
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
				If ShowCaption Then  Canvas.TextOut(Current.X, Current.Y, FText, Font.Color, FBackColor)
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					DeleteObject(MemBmp)
					DeleteDC(memDC)
				End If
				Canvas.HandleSetted = False
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
	
	Private Property PagePanel.SelectedPanel As Control Ptr
		If FSelectedPanelIndex >= 0 AndAlso FSelectedPanelIndex <= FControlCount - 1 Then Return Controls[FSelectedPanelIndex]
		Return 0
	End Property
	
	Private Property PagePanel.SelectedPanel(Value As Control Ptr)
		If IndexOf(Value) > -1 Then
			SelectedPanelIndex = IndexOf(Value)
		End If
	End Property
	
	Private Property PagePanel.SelectedPanelIndex As Integer
		Return FSelectedPanelIndex
	End Property
	
	Private Property PagePanel.SelectedPanelIndex(Value As Integer)
		If Value >= 0 AndAlso Value <= FControlCount - 1 Then
			FSelectedPanelIndex = Value
			#ifdef __USE_WINAPI__
				For i As Integer = 0 To FControlCount - 1
					Controls[i]->Visible = i = FSelectedPanelIndex
				Next
			#elseif defined(__USE_GTK__)
				gtk_stack_set_visible_child(GTK_STACK(widget), Controls[FSelectedPanelIndex]->widget)
			#endif
		End If
	End Property
	
	Private Property PagePanel.Transparent As Boolean
		Return FTransparent
	End Property
	
	Private Property PagePanel.Transparent(Value As Boolean)
		FTransparent = Value
	End Property
	
	Private Operator PagePanel.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Sub PagePanel.CreateWnd
		Base.CreateWnd
		#ifdef __USE_JNI__
			layoutview = FHandle
		#endif
	End Sub
	
	Private Sub PagePanel.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
				#else
					.Ctrl->Repaint
				#endif
			End If
		End With
	End Sub
	
	Private Constructor PagePanel
		With This
			#ifdef __USE_GTK__
				widget = gtk_stack_new()
				.RegisterClass "PagePanel", @This
			#endif
			.Child          = @This
			.Canvas.Ctrl    = @This
			.Graphic.Ctrl   = @This
			.Graphic.OnChange = @GraphicChange
			#ifdef __USE_WINAPI__
				.RegisterClass "PagePanel"
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
			WLet(FClassName, "PagePanel")
			.Width       = 121
			.Height      = 41
			.ShowCaption = False
		End With
	End Constructor
	
	Private Destructor PagePanel
		#ifdef __USE_WINAPI__
			UnregisterClass "PagePanel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


