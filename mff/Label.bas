'###############################################################################
'#  Label.bi                                                                   #
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

#include once "Label.bi"

Namespace My.Sys.Forms
	Private Function Label.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "alignment": Return @FAlignment
		Case "border": Return @FBorder
		Case "canvas": Return @Canvas
		Case "caption": Return Cast(Any Ptr, This.FText.vptr)
		Case "centerimage": Return @FCenterImage
		Case "realsizeimage": Return @FRealSizeImage
		Case "style": Return @FStyle
		Case "tabindex": Return @FTabIndex
		Case "text": Return Cast(Any Ptr, This.FText.vptr)
		Case "graphic": Return Cast(Any Ptr, @This.Graphic)
		Case "wordwraps": Return @FWordWraps
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Label.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "alignment": If Value <> 0 Then This.Alignment = *Cast(AlignmentConstants Ptr, Value)
		Case "border": If Value <> 0 Then This.Border = QInteger(Value)
		Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
		Case "centerimage": If Value <> 0 Then This.CenterImage = QBoolean(Value)
		Case "realsizeimage": If Value <> 0 Then This.RealSizeImage = QBoolean(Value)
		Case "style": If Value <> 0 Then This.Style = QInteger(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
		Case "graphic": This.Graphic = QWString(Value)
		Case "wordwraps": This.WordWraps = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property Label.Caption ByRef As WString
		Return Text
	End Property
	
	Private Property Label.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Private Property Label.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property Label.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property Label.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property Label.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property Label.Text ByRef As WString
		Return Base.Text
	End Property
	
	Private Property Label.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_text(GTK_LABEL(widget), ToUtf8(Value))
		#endif
	End Property
	
	Private Property Label.Border As Integer
		Return FBorder
	End Property
	
	Private Sub Label.ChangeLabelStyle
		If Style <> lsText Then
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AWordWraps(Abs_(FWordWraps)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
			#endif
		Else
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AWordWraps(Abs_(FWordWraps)) Or AAlignment(Abs_(FAlignment))
			#endif
		End If
		RecreateWnd
	End Sub
	
	Private Property Label.Border(Value As Integer)
		If Value <> FBorder Then
			FBorder = Value
			ChangeLabelStyle
		End If
	End Property
	
	Private Property Label.Style As Integer
		Return FStyle
	End Property
	
	Private Property Label.Style(Value As Integer)
		If Value <> FStyle Then
			FStyle = Value
			ChangeLabelStyle
		End If
	End Property
	
	Private Property Label.RealSizeImage As Boolean
		Return FRealSizeImage
	End Property
	
	Private Property Label.RealSizeImage(Value As Boolean)
		If Value <> FRealSizeImage Then
			FRealSizeImage = Value
			ChangeLabelStyle
		End If
	End Property
	
	Private Property Label.CenterImage As Boolean
		Return FCenterImage
	End Property
	
	Private Property Label.CenterImage(Value As Boolean)
		If Value <> FCenterImage Then
			FCenterImage = Value
			ChangeLabelStyle
		End If
	End Property
	
	Private Property Label.Alignment As AlignmentConstants
		Return FAlignment
	End Property
	
	Private Property Label.Alignment(Value As AlignmentConstants)
		If Value <> FAlignment Then
			FAlignment = Value
			ChangeLabelStyle
		End If
	End Property
	
	Private Property Label.WordWraps As Boolean
		Return FWordWraps
	End Property
	
	Private Property Label.WordWraps(Value As Boolean)
		If Value <> FWordWraps Then
			FWordWraps = value
			#ifdef __USE_GTK__
				gtk_label_set_line_wrap(gtk_label(widget), Value)
			#else
				ChangeLabelStyle
			#endif
		End If
	End Property
	
	Private Sub Label.GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifndef __USE_GTK__
					Select Case ImageType
					Case IMAGE_BITMAP
						QLabel(.Ctrl->Child).Style = lsBitmap
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
					Case IMAGE_ICON
						QLabel(.Ctrl->Child).Style = lsIcon
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case IMAGE_CURSOR
						QLabel(.Ctrl->Child).Style = lsCursor
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case IMAGE_ENHMETAFILE
						QLabel(.Ctrl->Child).Style = lsEmf
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(0))
					End Select
				#endif
			End If
		End With
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub Label.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QLabel(Sender.Child)
					.Perform(STM_SETIMAGE, .Graphic.ImageType,CInt(.Graphic.Image))
				End With
			End If
		End Sub
		
		Private Sub Label.WndProc(ByRef Message As Message)
		End Sub
	#endif
		
	Private Sub Label.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc,Font.Color
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
				Dim As ..Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				R = Cast(..Rect, diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDraw Then
					OnDraw(This, *Cast(Rect Ptr, @R), Dc)
				Else
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator Label.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor Label
		#ifdef __USE_GTK__
			widget = gtk_label_new("")
			#ifdef __USE_GTK3__
				gtk_label_set_xalign (GTK_LABEL (widget), 0.0)
			#else
				gtk_misc_set_alignment(gtk_misc(widget), 0, 0)
			#endif
			gtk_label_set_line_wrap(gtk_label(widget), True)
			#ifdef __USE_GTK3__
				eventboxwidget = gtk_event_box_new()
				gtk_container_add(gtk_container(eventboxwidget), widget)
			#endif
			This.RegisterClass "Label", @This
		#else
			AStyle(0)           = 0
			AStyle(1)           = SS_BITMAP
			AStyle(2)           = SS_ICON
			AStyle(3)           = SS_ICON
			AStyle(4)           = SS_ENHMETAFILE
			AStyle(5)           = SS_OWNERDRAW
			AAlignment(0)       = SS_LEFT
			AAlignment(1)       = SS_CENTER
			AAlignment(2)       = SS_RIGHT
			ABorder(0)          = 0
			ABorder(1)          = SS_SIMPLE
			ABorder(2)          = SS_SUNKEN
			ACenterImage(0)     = SS_RIGHTJUST
			ACenterImage(1)     = SS_CENTERIMAGE
			ARealSizeImage(0)   = 0
			ARealSizeImage(1)   = SS_REALSIZEIMAGE
			AWordWraps(0)       = SS_ENDELLIPSIS
			AWordWraps(1)       = 0
		#endif
		Graphic.Ctrl = This
		Graphic.OnChange = @GraphicChange
		FRealSizeImage   = 1
		FWordWraps       = True
		'FAlignment = 2
		FTabIndex          = -1
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "Label", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				ChangeLabelStyle
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet(FClassName, "Label")
			WLet(FClassAncestor, "Static")
			.Width       = 90
			.Height      = ScaleY(Max(8, Font.Size) /72*96+6)  '中文字号VS英文字号(磅)VS像素值的对应关系：八号＝5磅(5pt) ==(5/72)*96=6.67 =6px
		End With
	End Constructor
	
	Private Destructor Label
	End Destructor
End Namespace
