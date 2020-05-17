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
	Function Label.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return Cast(Any Ptr, This.FText.vptr)
		Case "text": Return Cast(Any Ptr, This.FText.vptr)
		Case "graphic": Return Cast(Any Ptr, @This.Graphic)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Label.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
		Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property Label.Caption ByRef As WString
		Return Text
	End Property
	
	Property Label.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Property Label.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property Label.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_text(GTK_LABEL(widget), ToUtf8(Value))
		#endif
	End Property
	
	Property Label.Border As Integer
		Return FBorder
	End Property
	
	Property Label.Border(Value As Integer)
		If Value <> FBorder Then
			FBorder = Value
			If Style <> lsText Then
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				#endif
			Else
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				#endif
			End If
			RecreateWnd
		End If
	End Property
	
	Property Label.Style As Integer
		Return FStyle
	End Property
	
	Property Label.Style(Value As Integer)
		If Value <> FStyle Then
			FStyle = Value
			If FStyle <> lsText Then
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				#endif
			Else
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				#endif
			End If
			RecreateWnd
		End If
	End Property
	
	Property Label.RealSizeImage As Boolean
		Return FRealSizeImage
	End Property
	
	Property Label.RealSizeImage(Value As Boolean)
		If Value <> FRealSizeImage Then
			FRealSizeImage = Value
			If Style <> lsText Then
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				#endif
			Else
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				#endif
			End If
			RecreateWnd
		End If
	End Property
	
	Property Label.CenterImage As Boolean
		Return FCenterImage
	End Property
	
	Property Label.CenterImage(Value As Boolean)
		If Value <> FCenterImage Then
			FCenterImage = Value
			If Style <> lsText Then
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				#endif
			Else
				#ifndef __USE_GTK__
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				#endif
			End If
			RecreateWnd
		End If
	End Property
	
	Property Label.Alignment As Integer
		Return FAlignment
	End Property
	
	Property Label.Alignment(Value As Integer)
		If Value <> FAlignment Then
			FAlignment = Value
			#ifndef __USE_GTK__
				If Style <> lsText Then
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				Else
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				End If
			#endif
			RecreateWnd
		End If
	End Property
	
	Sub Label.GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
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
		Sub Label.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QLabel(Sender.Child)
					.Perform(STM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
				End With
			End If
		End Sub
		
		Sub Label.WndProc(ByRef Message As Message)
		End Sub
		
		Sub Label.ProcessMessage(ByRef Message As Message)
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
	
	Operator Label.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor Label
		#ifdef __USE_GTK__
			widget = gtk_label_new("")
			#ifdef __USE_GTK3__
				gtk_label_set_xalign (GTK_LABEL (widget), 0.0)
			#else
				gtk_misc_set_alignment(gtk_misc(widget), 0, 0)
			#endif
			This.RegisterClass "Label", @This
		#else
			AStyle(0)        = 0
			AStyle(1)        = SS_BITMAP
			AStyle(2)        = SS_ICON
			AStyle(3)        = SS_ICON
			AStyle(4)        = SS_ENHMETAFILE
			AStyle(5)        = SS_OWNERDRAW
			AAlignment(0)    = SS_LEFT
			AAlignment(1)    = SS_CENTER
			AAlignment(2)    = SS_RIGHT
			ABorder(0)       = 0
			ABorder(1)       = SS_SIMPLE
			ABorder(2)       = SS_SUNKEN
			ACenterImage(0)  = SS_RIGHTJUST
			ACenterImage(1)  = SS_CENTERIMAGE
			ARealSizeImage(0)= 0
			ARealSizeImage(1)= SS_REALSIZEIMAGE
		#endif
		Graphic.Ctrl = This
		Graphic.OnChange = @GraphicChange
		FRealSizeImage   = 1
		'FAlignment = 2
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "Label", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				If FStyle <> lsText Then
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or ARealSizeImage(Abs_(FRealSizeImage)) Or ACenterImage(Abs_(FCenterImage))
				Else
					Base.Style = WS_CHILD Or SS_NOTIFY Or ABorder(Abs_(FBorder)) Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment))
				End If
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet FClassName, "Label"
			WLet FClassAncestor, "Static"
			.Width       = 90
			.Height      = ScaleY(Max(8, Font.Size) /72*96+6)  '中文字号VS英文字号(磅)VS像素值的对应关系：八号＝5磅(5pt) ==(5/72)*96=6.67 =6px
		End With
	End Constructor
	
	Destructor Label
	End Destructor
End Namespace
