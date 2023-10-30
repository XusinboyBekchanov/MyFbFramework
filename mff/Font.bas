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

'Gets/sets the default font that applications can use for dialog boxes and forms.
Dim Shared DefaultFont As My.Sys.Drawing.Font
pDefaultFont = @DefaultFont

Namespace My.Sys.Drawing
	#ifndef ReadProperty_Off
		Private Function Font.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "name": Return FName
			Case "color": Return @FColor
			Case "size": Return @FSize
			Case "charset": Return @FCharSet
			Case "bold": Return @FBold
			Case "italic": Return @FItalic
			Case "underline": Return @FUnderline
			Case "strikeout": Return @FStrikeOut
			Case "orientation": Return @FOrientation
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Font.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value <> 0 Then
				Select Case LCase(PropertyName)
				Case "name": This.Name = QWString(Value)
				Case "color": This.Color = QInteger(Value)
				Case "size": This.Size = QInteger(Value)
				Case "charset": This.CharSet = QInteger(Value)
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
	#endif
	
	Private Sub Font.Create
		If WGet(FName) = "" Then
			WLet(FName, DefaultFont.Name)
		End If
		If FSize = 0 Then
			FSize = DefaultFont.Size
		End If
		#ifdef __USE_WASM__
			If QComponent(FParent).Handle Then
				SetFont(QComponent(FParent).Handle, *FName & IIf(FBold, " Bold", "") & IIf(FItalic, " Italic", "") & " " & Str(FSize) & "px")
			End If
		#else
			#ifdef __USE_GTK__
				If Handle Then pango_font_description_free (Handle)
				Handle = pango_font_description_from_string (*FName & IIf(FBold, " Bold", "") & IIf(FItalic, " Italic", "") & " " & Str(FSize))
			#elseif defined(__USE_WINAPI__)
				If Handle Then DeleteObject(Handle)
				Handle = CreateFontW(-MulDiv(FSize, ydpi * 96, 72), 0, FOrientation * FSize, FOrientation * FSize, FBolds(Min(1, _Abs(FBold))), FItalic, FUnderline, FStrikeOut, FCharSet, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, *FName)
			#endif
			If Handle Then
				If FParent AndAlso *FParent Is My.Sys.ComponentModel.Component Then
					#ifdef __USE_GTK__
						If QComponent(FParent).Handle Then
							#ifndef __USE_GTK2__
								#ifndef __USE_GTK4__
									gtk_widget_override_font(QComponent(FParent).Handle, Handle)
								#endif
							#else
								gtk_widget_modify_font(QComponent(FParent).Handle, Handle)
							#endif
						End If
					#elseif defined(__USE_WINAPI__)
						If QComponent(FParent).Handle Then
							SendMessage(QComponent(FParent).Handle, WM_SETFONT, CUInt(Handle), True)
							InvalidateRect Cast(Component Ptr, FParent)->Handle, 0, True
						End If
					#endif
				End If
				If OnCreate Then OnCreate(*Designer, This)
			End If
		#endif
	End Sub
	
	Private Property Font.Parent As My.Sys.Object Ptr
		Return FParent
	End Property
	
	Private Property Font.Parent(Value As My.Sys.Object Ptr)
		FParent = Value
		#ifdef __USE_GTK__
			If *FParent Is My.Sys.ComponentModel.Component Then
				#ifndef __USE_GTK2__
					Dim As GtkStyleContext Ptr WidgetStyle = gtk_widget_get_style_context(QComponent(FParent).Handle)
					#ifdef __USE_GTK4__
						Dim As PangoFontDescription Ptr pfd
						gtk_style_context_get(WidgetStyle, GTK_STATE_FLAG_NORMAL, "font", @pfd, NULL)
					#else
						Var pfd = gtk_style_context_get_font(WidgetStyle, GTK_STATE_FLAG_NORMAL)
					#endif
				#else
					Dim As GtkStyle Ptr WidgetStyle = gtk_widget_get_style(QComponent(FParent).Handle)
					Var pfd = WidgetStyle->font_desc
				#endif
				WLet(FName, WStr(*pango_font_description_get_family(pfd)))
				FSize = pango_font_description_get_size(pfd) / PANGO_SCALE
			End If
		#else
			Create
		#endif
	End Property
	
	Private Property Font.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Private Property Font.Name(ByRef Value As WString)
		WLet(FName, Value)
		Create
	End Property
	
	Private Property Font.Color As Integer
		Return FColor
	End Property
	
	#ifndef Font_Color_Set_Off
		Private Property Font.Color(Value As Integer)
			FColor = Value
			'Create
		End Property
	#endif
	
	Private Property Font.CharSet As Integer
		Return FCharSet
	End Property
	
	Private Property Font.CharSet(Value As Integer)
		FCharSet = Value
		Create
	End Property
	
	Private Property Font.Size As Integer
		Return FSize
	End Property
	
	Private Property Font.Size(Value As Integer)
		FSize = Value
		Create
	End Property
	
	'FOrientation
	Private Property Font.Orientation As Integer
		Return FOrientation
	End Property
	
	Private Property Font.Orientation(Value As Integer)
		FOrientation = Value
		Create
	End Property
	
	Private Property Font.Bold As Boolean
		Return FBold
	End Property
	
	Private Property Font.Bold(Value As Boolean)
		FBold = Value
		Create
	End Property
	
	Private Property Font.Italic As Boolean
		Return FItalic
	End Property
	
	Private Property Font.Italic(Value As Boolean)
		FItalic = Value
		Create
	End Property
	
	Private Property Font.Underline As Boolean
		Return FUnderline
	End Property
	
	Private Property Font.Underline(Value As Boolean)
		FUnderline = Value
		Create
	End Property
	
	Private Property Font.StrikeOut As Boolean
		Return FStrikeOut
	End Property
	
	Private Property Font.StrikeOut(Value As Boolean)
		FStrikeOut = Value
		Create
	End Property
	
	Private Operator Font.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Operator Font.Cast ByRef As WString
		Return ToString
	End Operator
	
	Private Function Font.ToString ByRef As WString
		WLet(FTemp, This.Name & ", " & This.Size)
		Return *FTemp
	End Function
	
	Private Operator Font.Let(Value As Font)
		With Value
			WLet(FName, .Name)
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
	
	Private Constructor Font
		WLet(FClassName, "Font")
		FCharSet  = FontCharset.Default
		WLet(FName, DefaultFont.Name)
		FSize     = DefaultFont.Size
		#ifdef __USE_WINAPI__
			If xdpi = 0 OrElse ydpi = 0 Then
				Dim As HDC Dc
				Dc = GetDC(NULL)
				xdpi = GetDeviceCaps(Dc, LOGPIXELSX) / 96
				ydpi = GetDeviceCaps(Dc, LOGPIXELSY) / 96
				If xdpi = 0 Then xdpi = 1
				If ydpi = 0 Then ydpi = 1
				ReleaseDC(NULL, Dc)
			End If
			FBolds(0) = 400
			FBolds(1) = 700
			'Create
		#endif
	End Constructor
	
	Destructor Font
		WDeAllocate(FName)
		#ifdef __USE_GTK__
			If Handle Then pango_font_description_free (Handle)
		#elseif defined(__USE_WINAPI__)
			If Handle Then DeleteObject(Handle)
		#endif
	End Destructor
	
	#ifndef __FB_WIN32__
		DefaultFont.Name = "Ubuntu"
		DefaultFont.Size = 11
	#else
		DefaultFont.Name = "Tahoma"
		DefaultFont.Size = 8
	#endif
End Namespace
