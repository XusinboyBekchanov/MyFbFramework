'###############################################################################
'#  Font.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu ZiQI                       #
'#  Based on:                                                                  #
'#   TFont.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Font.bi"

Dim Shared DefaultFont As My.Sys.Drawing.Font
pDefaultFont = @DefaultFont

Namespace My.Sys.Drawing
	Function Font.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "name": Return FName
		Case "color": Return @FColor
		Case "size": Return @FSize
		Case "charset": Return @FCharset
		Case "bold": Return @FBold
		Case "italic": Return @FItalic
		Case "underline": Return @FUnderline
		Case "strikeout": Return @FStrikeOut
		Case "orientation": Return @FOrientation
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Font.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value <> 0 Then
			Select Case LCase(PropertyName)
			Case "name": This.Name = QWString(Value)
			Case "color": This.Color = QInteger(Value)
			Case "size": This.Size = QInteger(Value)
			Case "charset": This.Charset = QInteger(Value)
			Case "bold": This.Bold = QBoolean(Value)
			Case "italic": This.Italic = QBoolean(Value)
			Case "underline": This.Underline = QBoolean(Value)
			Case "strikeout": This.StrikeOut = QBoolean(Value)
			Case "orientation": This.Orientation = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Sub Font.Create
		If WGet(FName) = "" Then
			WLet FName, DefaultFont.Name
			FSize = DefaultFont.Size
		End If
		#ifdef __USE_GTK__
			If Handle Then pango_font_description_free (Handle)
			Handle = pango_font_description_from_string (*FName & IIf(FBold, " Bold", "") & IIf(FItalic, " Italic", "") & " " & Str(FSize))
		#else
			If Handle Then DeleteObject(Handle)
			Handle = CreateFontW(-MulDiv(FSize,FcyPixels,72),0,FOrientation*FSize,FOrientation*FSize,FBolds(Abs_(FBold)),FItalic,FUnderline,FStrikeout,FCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*FName)
		#endif
		If Handle Then
			If FParent Then
				#ifdef __USE_GTK__
					If FParent->Widget Then
						#ifdef __USE_GTK3__
							gtk_widget_override_font(FParent->Widget, Handle)
						#else
							gtk_widget_modify_font(FParent->Widget, Handle)
						#endif
					End If
				#else
					If FParent->Handle Then
						SendMessage(FParent->Handle, WM_SETFONT,CUInt(Handle),True)
						InvalidateRect FParent->Handle, 0, True
					End If
				#endif
			End If
		End If
	End Sub
	
	Property Font.Parent As Component Ptr
		Return FParent
	End Property
	
	Property Font.Parent(Value As Component Ptr)
		FParent = value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				Dim As GtkStyleContext Ptr WidgetStyle = gtk_widget_get_style_context(FParent->Widget)
				Var pfd = gtk_style_context_get_font(WidgetStyle, GTK_STATE_FLAG_NORMAL)
			#else
				Dim As GtkStyle Ptr WidgetStyle = gtk_widget_get_style(FParent->Widget)
				Var pfd = WidgetStyle->font_desc
			#endif
			WLet FName, WStr(*pango_font_description_get_family(pfd))
			FSize = pango_font_description_get_size(pfd) / PANGO_SCALE
		#else
			Create
		#endif
	End Property
	
	Property Font.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Property Font.Name(ByRef Value As WString)
		WLet FName, value
		Create
	End Property
	
	Property Font.Color As Integer
		Return FColor
	End Property
	
	Property Font.Color(Value As Integer)
		FColor = value
		Create
	End Property
	
	Property Font.CharSet As Integer
		Return FCharSet
	End Property
	
	Property Font.CharSet(Value As Integer)
		FCharSet = value
		Create
	End Property
	
	Property Font.Size As Integer
		Return FSize
	End Property
	
	Property Font.Size(Value As Integer)
		FSize = value
		Create
	End Property
	
	'FOrientation
	Property Font.Orientation As Integer
		Return FOrientation
	End Property
	
	Property Font.Orientation(Value As Integer)
		FOrientation = value
		Create
	End Property
	
	Property Font.Bold As Boolean
		Return FBold
	End Property
	
	Property Font.Bold(Value As Boolean)
		FBold = value
		Create
	End Property
	
	Property Font.Italic As Boolean
		Return FItalic
	End Property
	
	Property Font.Italic(Value As Boolean)
		FItalic = value
		Create
	End Property
	
	Property Font.Underline As Boolean
		Return FUnderline
	End Property
	
	Property Font.Underline(Value As Boolean)
		FUnderline = value
		Create
	End Property
	
	Property Font.StrikeOut As Boolean
		Return FStrikeout
	End Property
	
	Property Font.StrikeOut(Value As Boolean)
		FStrikeout = value
		Create
	End Property
	
	Operator Font.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator Font.Cast ByRef As WString
		Return ToString
	End Operator
	
	Function Font.ToString ByRef As WString
		WLet FTemp, This.Name & ", " & This.Size
		Return *FTemp
	End Function
	
	Operator Font.Let(Value As Font)
		With Value
			WLet FName, .Name
			FBold      = .Bold
			FItalic    = .Italic
			FUnderline = .Underline
			FStrikeOut = .StrikeOut
			FSize      = .Size
			FColor     = .Color
			FCharSet   = .CharSet
			FOrientation = .Orientation
		End With
		Create
	End Operator
	
	Constructor Font
		WLet FClassName, "Font"
		FCharSet  = FontCharset.Default
		WLet FName, DefaultFont.Name
		FSize     = DefaultFont.Size
		#ifndef __USE_GTK__
			Dim As HDC Dc
			Dc = GetDC(HWND_DESKTOP)
			FCyPixels = GetDeviceCaps(DC, LOGPIXELSY)
			ReleaseDC(HWND_DESKTOP,DC)
			FBolds(0) = 400
			FBolds(1) = 700
			Create
		#endif
	End Constructor
	
	Destructor Font
		#ifdef __USE_GTK__
			If Handle Then pango_font_description_free (Handle)
		#else
			If Handle Then DeleteObject(Handle)
		#endif
	End Destructor
	
	#ifdef __FB_LINUX__
		DefaultFont.Name = "Ubuntu"
		DefaultFont.Size = 11
	#else
		DefaultFont.Name = "Tahoma"
		DefaultFont.Size = 8
	#endif
End Namespace
