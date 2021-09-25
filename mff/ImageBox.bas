'###############################################################################
'#  ImageBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "ImageBox.bi"

Namespace My.Sys.Forms
	Function ImageBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "centerimage": Return @FCenterImage
		Case "realsizeimage": Return @FRealSizeImage
		Case "style": Return @FImageStyle
		Case "graphic": Return Cast(Any Ptr, @This.Graphic)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ImageBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "centerimage": If Value <> 0 Then This.CenterImage = QBoolean(Value)
		Case "realsizeimage": If Value <> 0 Then This.RealSizeImage = QBoolean(Value)
		Case "style": If Value <> 0 Then This.Style = QInteger(Value)
		Case "graphic": This.Graphic = QWString(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property ImageBox.DesignMode As Boolean
		Return FDesignMode
	End Property
	
	#ifdef __USE_GTK__
		Function ImageBox.DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			#ifdef __USE_GTK3__
				Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
			#else
				Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
			#endif
			cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
			Dim As Double Ptr dashed = Allocate(SizeOf(Double) * 2)
			dashed[0] = 3.0
			dashed[1] = 3.0
			Dim As Integer len1 = SizeOf(dashed) / SizeOf(dashed[0])
			cairo_set_dash(cr, dashed, len1, 1)
			cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
			cairo_stroke(cr)
			Return False
		End Function
		
		Function ImageBox.DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			DesignDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Property ImageBox.DesignMode(Value As Boolean)
		FDesignMode = Value
		If Value Then
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@DesignDraw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@DesignExposeEvent), @This)
				#endif
			#endif
		End If
	End Property
		
	Property ImageBox.Style As Integer
		Return FImageStyle
	End Property
	
	Property ImageBox.Style(Value As Integer)
		'If Value <> FImageStyle Then
			FImageStyle = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FImageStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
			#endif
			RecreateWnd
		'End If
	End Property
	
	Property ImageBox.RealSizeImage As Boolean
		Return FRealSizeImage
	End Property
	
	Property ImageBox.RealSizeImage(Value As Boolean)
		If Value <> FRealSizeImage Then
			FRealSizeImage = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FImageStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
			#endif
			RecreateWnd
		End If
	End Property
	
	Property ImageBox.CenterImage As Boolean
		Return FCenterImage
	End Property
	
	Property ImageBox.CenterImage(Value As Boolean)
		If Value <> FCenterImage Then
			FCenterImage = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FImageStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
			#endif
			RecreateWnd
		End If
	End Property
	
	Sub ImageBox.GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
					Select Case ImageType
					Case 0
						gtk_image_set_from_pixbuf(gtk_image(.Ctrl->widget), .Bitmap.Handle)
					Case 1
						gtk_image_set_from_pixbuf(gtk_image(.Ctrl->widget), .Icon.Handle)
					End Select
				#else
					Select Case ImageType
					Case 0
						QImageBox(.Ctrl->Child).Style = ImageBoxStyle.ssBitmap
						QImageBox(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
					Case 1
						QImageBox(.Ctrl->Child).Style = ImageBoxStyle.ssIcon
						QImageBox(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case 2
						QImageBox(.Ctrl->Child).Style = ImageBoxStyle.ssCursor
						QImageBox(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case 3
						QImageBox(.Ctrl->Child).Style = ImageBoxStyle.ssEmf
						QImageBox(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(0))
					End Select
				#endif
			End If
		End With
	End Sub
	
	#ifndef __USE_GTK__
		Sub ImageBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QImageBox(Sender.Child)
					.Perform(STM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
				End With
			End If
		End Sub
		
		Sub ImageBox.WndProc(ByRef Message As Message)
		End Sub
	#endif
		
	Sub ImageBox.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, This.Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE
'			Case CM_COMMAND
'				If Message.wParamHi = STN_CLICKED Then
'					If OnClick Then OnClick(This)
'				End If
'				If Message.wParamHi = STN_DBLCLK Then
'					If OnDblClick Then OnDblClick(This)
'				End If
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				R = Cast(Rect,diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDraw Then
					OnDraw(This, R, Dc)
				Else
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator ImageBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor ImageBox
		#ifdef __USE_GTK__
			widget = gtk_image_new()
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(gtk_container(eventboxwidget), widget)
			This.RegisterClass "ImageBox", @This
		#else
			AStyle(0)        = SS_BITMAP
			AStyle(1)        = SS_ICON
			AStyle(2)        = SS_ICON
			AStyle(3)        = SS_ENHMETAFILE
			AStyle(4)        = SS_OWNERDRAW
			ACenterImage(0)  = SS_RIGHTJUST
			ACenterImage(1)  = SS_CENTERIMAGE
			ARealSizeImage(0)= 0
			ARealSizeImage(1)= SS_REALSIZEIMAGE
		#endif
		FImageStyle = 0
		Graphic.Ctrl = @This
		Graphic.OnChange = @GraphicChange
		FRealSizeImage   = 0
		FCenterImage   = True
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "ImageBox", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FImageStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet(FClassName, "ImageBox")
			WLet(FClassAncestor, "Static")
			.Width       = 90
			.Height      = 17
		End With
	End Constructor
	
	Destructor ImageBox
	End Destructor
End Namespace
