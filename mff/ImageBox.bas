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
		Case "graphic": Return Cast(Any Ptr, @This.Graphic)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ImageBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property ImageBox.Style As Integer
		Return FStyle
	End Property
	
	Property ImageBox.Style(Value As Integer)
		If Value <> FStyle Then
			FStyle = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
			#endif
			RecreateWnd
		End If
	End Property
	
	Property ImageBox.RealSizeImage As Boolean
		Return FRealSizeImage
	End Property
	
	Property ImageBox.RealSizeImage(Value As Boolean)
		If Value <> FRealSizeImage Then
			FRealSizeImage = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
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
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
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
		
		Sub ImageBox.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, This.Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = STN_CLICKED Then
					If OnClick Then OnClick(This)
				End If
				If Message.wParamHi = STN_DBLCLK Then
					If OnDblClick Then OnDblClick(This)
				End If
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				R = Cast(Rect,diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDraw Then
					OnDraw(This,R,Dc)
				Else
				End If
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator ImageBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor ImageBox
		#ifdef __USE_GTK__
			widget = gtk_image_new()
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
		Graphic.Ctrl = @This
		Graphic.OnChange = @GraphicChange
		FRealSizeImage   = 0
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "ImageBox", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				Base.Style = WS_CHILD Or SS_NOTIFY Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet FClassName, "ImageBox"
			WLet FClassAncestor, "Static"
			.Width       = 90
			.Height      = 17
		End With
	End Constructor
	
	Destructor ImageBox
	End Destructor
End Namespace
