'###############################################################################
'#  Picture.bas                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Liu ZiQI                                           #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Created by Liu ZiQI (2019)                                                 #
'###############################################################################
'https://blog.csdn.net/mmmvp/article/details/365155

#include once "Picture.bi"
Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function Picture.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "autosize": Return @FAutoSize
			Case "centerimage": Return @FCenterImage
			Case "graphic": Return Cast(Any Ptr, @This.Graphic)
			Case "realsizeimage": Return @FRealSizeImage
			Case "stretchimage": Return @FStretchImage
			Case "transparent": Return @FTransparent
			Case "style": Return @FPictureStyle
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Picture.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "autosize": This.AutoSize = QBoolean(Value)
				Case "centerimage": This.CenterImage = QBoolean(Value)
				Case "stretchimage": This.StretchImage = *Cast(StretchMode Ptr, Value)
				Case "graphic": This.Graphic = QWString(Value)
				Case "realsizeimage": This.RealSizeImage = QBoolean(Value)
				Case "transparent": This.Transparent = QBoolean(Value)
				Case "style": This.Style = *Cast(PictureStyle Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Picture.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property Picture.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property Picture.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property Picture.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property Picture.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Private Property Picture.AutoSize(Value As Boolean)
		If Value <> FAutoSize Then
			Base.AutoSize = Value
			#ifdef __USE_WINAPI__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(abs_(FPictureStyle)) Or ARealSizeImage(abs_(FRealSizeImage)) Or ARealSizeControl(abs_(FAutoSize)) Or ACenterImage(abs_(FCenterImage AndAlso Not FAutoSize))
			#endif
		End If
		RecreateWnd
	End Property
	
	Private Property Picture.StretchImage As StretchMode
		Return FStretchImage
	End Property
	
	Private Property Picture.StretchImage(Value As StretchMode)
		If Value <> FStretchImage Then
			FStretchImage = Value
			#ifdef __USE_WINAPI__
				InvalidateRect(Handle, NULL, True)
			#endif
		End If
	End Property
	
	Private Property Picture.Style As PictureStyle
		Return FPictureStyle
	End Property
	
	Private Property Picture.Style(Value As PictureStyle)
		If Value <> FPictureStyle Then
			FPictureStyle = Value
			#ifdef __USE_WINAPI__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(abs_(FPictureStyle)) Or ARealSizeImage(abs_(FRealSizeImage)) Or ARealSizeControl(abs_(FAutoSize)) Or ACenterImage(abs_(FCenterImage AndAlso Not FAutoSize))
			#endif
		End If
		RecreateWnd
	End Property
	
	Private Property Picture.RealSizeImage As Boolean
		Return FRealSizeImage
	End Property
	
	Private Property Picture.RealSizeImage(Value As Boolean)
		If Value <> FRealSizeImage Then
			FRealSizeImage = Value
			#ifdef __USE_WINAPI__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(abs_(FPictureStyle)) Or ARealSizeImage(abs_(FRealSizeImage)) Or ARealSizeControl(abs_(FAutoSize)) Or ACenterImage(abs_(FCenterImage AndAlso Not FAutoSize))
			#endif
			RecreateWnd
		End If
	End Property
	
	Private Property Picture.CenterImage As Boolean
		Return FCenterImage
	End Property
	
	Private Property Picture.CenterImage(Value As Boolean)
		If Value <> FCenterImage Then
			FCenterImage = Value
			Graphic.CenterImage = Value
			#ifdef __USE_WINAPI__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(abs_(FPictureStyle)) Or ARealSizeImage(abs_(FRealSizeImage)) Or ARealSizeControl(abs_(FAutoSize)) Or ACenterImage(abs_(FCenterImage AndAlso Not FAutoSize))
			#endif
			RecreateWnd
		End If
	End Property
	
	Private Sub Picture.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
					If GTK_IS_IMAGE(QPicture(.Ctrl->Child).ImageWidget) Then
						Select Case ImageType
						Case 0
							gtk_image_set_from_pixbuf(GTK_IMAGE(QPicture(.Ctrl->Child).ImageWidget), .Bitmap.Handle)
						Case 1
							gtk_image_set_from_pixbuf(GTK_IMAGE(QPicture(.Ctrl->Child).ImageWidget), .Icon.Handle)
						End Select
					End If
				#elseif defined(__USE_WINAPI__)
					Select Case ImageType
					Case 0
						QPicture(.Ctrl->Child).Style = PictureStyle.ssBitmap
						QPicture(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
					Case 1
						QPicture(.Ctrl->Child).Style = PictureStyle.ssIcon
						QPicture(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case 2
						QPicture(.Ctrl->Child).Style = PictureStyle.ssCursor
						QPicture(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case 3
						QPicture(.Ctrl->Child).Style = PictureStyle.ssEmf
						QPicture(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(0))
					End Select
				#endif
			End If
		End With
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub Picture.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPicture(Sender.Child)
					#ifdef __USE_WINAPI__
						.Perform(STM_SETIMAGE, .Graphic.ImageType, CInt(.Graphic.Image))
					#endif
				End With
			End If
		End Sub
		
		Private Sub Picture.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	#ifdef __USE_WASM__
		Private Function Picture.GetContent() As UString
			Return ""
		End Function
	#endif
	
	Private Sub Picture.ProcessMessage(ByRef Message As Message)
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
			Case WM_PAINT, WM_ERASEBKGND
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
					Canvas.SetHandle memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.SetHandle Dc
				End If
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
					Canvas.TextOut(Current.X, Current.Y, FText, Font.Color, FBackColor)
				End If
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				Canvas.UnSetHandle
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					DeleteObject(MemBmp)
					DeleteDC(memDC)
				End If
				EndPaint Handle, @Ps
				Message.Result = 0
				Return
			Case WM_SIZE
				InvalidateRect(Handle, NULL, True)
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As My.Sys.Drawing.Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				R = *Cast(My.Sys.Drawing.Rect Ptr, @diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDraw Then OnDraw(*Designer, This, R, Dc)
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Property Picture.Transparent As Boolean
		Return FTransparent
	End Property
	
	Private Property Picture.Transparent(Value As Boolean)
		FTransparent = Value
		#ifdef __USE_WINAPI__
			ChangeExStyle WS_EX_TRANSPARENT, Value
		#endif
	End Property
	
	Private Operator Picture.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor Picture
		#ifdef __USE_GTK__
			ImageWidget = gtk_image_new()
			widget = gtk_layout_new(NULL, NULL)
			If GTK_IS_WIDGET(ImageWidget) Then gtk_layout_put(GTK_LAYOUT(widget), ImageWidget, 0, 0)
			This.RegisterClass "Picture", @This
		#elseif defined(__USE_WINAPI__)
			'https://blog.csdn.net/mmmvp/article/details/365155
			'常数     说明
			AStyle(0)=0
			AStyle(1)=SS_BITMAP'在静态控件中显示一幅位图(.BMP)，由控件的文本(TEXT)指定一幅包含在资源中的位图文件(非文件名)，该风格忽略控件的宽度和高度，控件将自动调整大小以适应位图。
			AStyle(2)=SS_ICON'在静态控件中显示一幅图标(.ICO)，由控件的文本(TEXT)指定一幅包含在资源中的图标文件(非文件名)，该风格忽略控件的宽度和高度，控件将自动调整大小以适应图标。
			AStyle(3)=SS_ENHMETAFILE'在静态控件中显示一增强幅图元文件(.EMF)。由控件的文本(TEXT)指定图元文件名。控件大小固定不变，图元文件按比例缩放显示在控件客户区中。
			AStyle(4)=SS_BLACKFRAME'用系统颜色组的窗口边界色(缺省为黑色)绘制一个边框，框内使用与底部窗体相同的颜色（透明）。
			AStyle(5)=SS_BLACKRECT'用系统颜色组的窗口边界色(缺省为黑色)绘制一个矩形实心控件。
			AStyle(6)=SS_GRAYFRAME'用系统颜色组的屏幕背景色绘制一个边框，框内使用与底部窗体相同的颜色（透明）。
			AStyle(7)=SS_GRAYRECT'用系统颜色组的屏幕背景色绘制一个矩形实心控件。
			AStyle(8)=SS_WHITEFRAME'用系统颜色组的窗口背景色(缺省为白色)绘制一个边框，框内使用与底部窗体相同的颜色（透明）。
			AStyle(9)=SS_WHITERECT'用系统颜色组的窗口背景色(缺省为白色)色绘制一个矩形实心控件。
			AStyle(10)=SS_ETCHEDFRAME'用下凹的3D线条绘制一个边框，框内使用与底部窗体相同的颜色（透明）。
			AStyle(11)=SS_ETCHEDHORZ'用下凹的3D线条绘制控件的上下两边，框内使用与底部窗体相同的颜色（透明）。
			AStyle(12)=SS_ETCHEDVERT'用下凹的3D线条绘制控件的左右两边，框内使用与底部窗体相同的颜色（透明）。
			AStyle(13)=SS_RIGHTJUST'与SS_BITMAP 或 SS_ICON 配合当需要对控件的大小进行自动调整时以控件的右下角为基准，只有控件的上边和左边的位置改变。
			AStyle(14)=SS_NOPREFIX'禁止对字符“&amp;”进行解释，通常字符“&amp;”会被解释成在下一个字符加一个下画线，“&amp;&amp;”会被解释成一个字符“&amp;”，用户可以使用SS_NOPREFIX风格来禁止这项解释。
			AStyle(15)=SS_NOTIFY'当控件被用户单击或双击控件时向父窗口传送STN_CLICKED, STN_DBLCLK, STN_DISABLE, 或 STN_ENABLE 通知消息。
			AStyle(16)=SS_OWNERDRAW'自绘静态控件，每当控件需要重画时，父窗口将收到WM_DRAWITEM消息。
			AStyle(17)=SS_REALSIZEIMAGE'禁止根据位图或图标大小自动进行控件尺寸的调整，如果本常数被设定，大于控件的图片其超出部份将被截去。
			AStyle(18)=SS_SUNKEN'绘制一个下沉的控件。
			AStyle(19)=SS_CENTER'文本显示水平居中，显示之前先对文本进行格式化，超过控件宽度将自动换行。
			AStyle(20)=SS_CENTERIMAGE'文本显示垂直居中。本常数还设定当位图或图标小于控件客户区时使用图片左上角点的颜色填充控件边缘。
			AStyle(21)=SS_LEFT'文本显示居左，显示之前先对文本进行格式化，超过控件宽度将自动换行。
			AStyle(22)=SS_LEFTNOWORDWRAP'文本显示居左，超过控件宽度部份将被截去，不进行自动换行处理。
			AStyle(23)=SS_RIGHT'文本显示居右，显示之前先对文本进行格式化，超过控件宽度将自动换行。
			AStyle(24)=SS_SIMPLE'文本在控件的左上角单行显示，不进行自动换行处理。父窗口进程不能对WM_CTLCOLORSTATIC消息进行处理。
			
			ACenterImage(0)  = SS_RIGHTJUST
			ACenterImage(1)  = SS_CENTERIMAGE
			ARealSizeImage(0)= 0
			ARealSizeImage(1) = SS_REALSIZEIMAGE
			ARealSizeControl(0) = SS_REALSIZECONTROL
			ARealSizeControl(1) = 0
		#endif
		This.Canvas.Ctrl    = @This
		Graphic.Ctrl = @This
		Graphic.OnChange = @GraphicChange
		FRealSizeImage   = False
		FCenterImage = True
		FPictureStyle = PictureStyle.ssBitmap
		With This
			.Child       = @This
			#ifdef __USE_WINAPI__
				.RegisterClass "Picture", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				Base.Style = WS_CHILD Or WS_EX_LAYERED Or SS_NOTIFY Or ARealSizeImage(abs_(FRealSizeImage)) Or ARealSizeControl(abs_(FAutoSize)) Or ACenterImage(abs_(FCenterImage AndAlso Not FAutoSize)) Or AStyle(abs_(FPictureStyle))
				BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				WLet(FClassAncestor, "Static")
			#endif
			WLet(FClassName, "Picture")
			FTabIndex          = -1
			.Width       = 80
			.Height      = 60
			.ShowCaption = False
		End With
	End Constructor
	Private Destructor Picture
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(ImageWidget) Then
				#ifdef __USE_GTK4__
					g_object_unref(widget)
				#else
					gtk_widget_destroy(ImageWidget)
				#endif
			End If
		#endif
	End Destructor
End Namespace

