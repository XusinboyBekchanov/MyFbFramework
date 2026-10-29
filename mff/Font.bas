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
				Case "charset": This.CharSet = *Cast(FontCharset Ptr, Value)
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
				'The size is in points like on Windows; CSS: [italic] [bold] size family
				SetFont(QComponent(FParent).Handle, IIf(FItalic, "italic ", "") & IIf(FBold, "bold ", "") & Str(FSize) & "pt '" & *FName & "', sans-serif")
			End If
		#elseif defined(__USE_APPLE__)
			If FParent AndAlso *FParent Is My.Sys.ComponentModel.Component AndAlso QComponent(FParent).Handle Then
				'The name of the default font is the font of the system ("")
				Dim As String sName
				If *FName <> DefaultFont.Name Then sName = ToUtf8(*FName)
				mffViewSetFont(QComponent(FParent).Handle, sName, FSize, IIf(FBold, 1, 0) Or IIf(FItalic, 2, 0) Or IIf(FUnderline, 4, 0) Or IIf(FStrikeOut, 8, 0))
			End If
		#elseif defined(__USE_JNI__)
			'The size of the font is the one of all the views (the sizes of Android are different for each kind of the
			'views); the name of the default font keeps the typeface of Android (Tahoma is not on Android)
			If FParent AndAlso *FParent Is My.Sys.ComponentModel.Component AndAlso QComponent(FParent).Handle AndAlso env AndAlso Activity Then
				Dim As Double dSize = IIf(FSize > 0, FParent->ScaleY(FSize * 96 / 72), 0)
				'The views which mffActivity makes (tabs, buttons of toolbars, rows of lists) have the size of the default font
				If FSize = DefaultFont.Size AndAlso dSize > 0 Then (*env)->CallVoidMethod(env, Activity, ActivityMethodID("textSetDefaultSize", "(D)V"), dSize)
				Dim As String sName
				If *FName <> DefaultFont.Name Then sName = ToUtf8(*FName)
				Dim As jstring jName = (*env)->NewStringUTF(env, sName)
				(*env)->CallVoidMethod(env, Activity, ActivityMethodID("textSetFont", "(Ljava/lang/Object;Ljava/lang/String;DIIII)V"), QComponent(FParent).Handle, jName, _
					dSize, CInt(FBold), CInt(FItalic), CInt(FUnderline), CInt(FStrikeOut))
				(*env)->DeleteLocalRef(env, jName)
			End If
		#else
			#ifdef __USE_GTK__
				If Handle Then pango_font_description_free (Handle)
				Handle = pango_font_description_from_string (*FName & IIf(FBold, " Bold", "") & IIf(FItalic, " Italic", "") & " " & Str(FSize))
			#elseif defined(__USE_WINAPI__)
				If Handle Then DeleteObject(Handle)
				Handle = CreateFontW(-MulDiv(FSize, ydpi * 96, 72), 0, FOrientation * 10, FOrientation * 10, FBolds(Min(1, _Abs(FBold))), FItalic, FUnderline, FStrikeOut, FCharSet, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, *FName)
			#endif
			If Handle Then
				If FParent AndAlso *FParent Is My.Sys.ComponentModel.Component Then
					#ifdef __USE_GTK__
						If QComponent(FParent).Handle Then
							#ifndef __USE_GTK2__
								#ifndef __USE_GTK4__
									gtk_widget_override_font(QComponent(FParent).Handle, Handle)
								#else
									gtk4compat_widget_set_font(QComponent(FParent).Handle, Handle)
								#endif
							#else
								gtk_widget_modify_font(QComponent(FParent).Handle, Handle)
							#endif
						End If
					#elseif defined(__USE_WINAPI__)
						If QComponent(FParent).Handle Then
							' In a layout or DPI pass the container is repainted once when the pass ends:
							'a synchronous repaint per control is the most expensive part of the pass
							SendMessage(QComponent(FParent).Handle, WM_SETFONT, CUInt(Handle), AlignLock = 0)
							If AlignLock = 0 Then
								InvalidateRect Cast(Component Ptr, FParent)->Handle, 0, True
							Else
								AlignAddWindow Cast(Component Ptr, FParent)->Handle
							End If
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
		If FDefaultName AndAlso *FName <> DefaultFont.Name Then WLet(FName, DefaultFont.Name)
		If FDefaultSize AndAlso FSize <> DefaultFont.Size Then FSize = DefaultFont.Size
		#ifdef __USE_GTK__
			If *FParent Is My.Sys.ComponentModel.Component Then
				#ifdef __USE_GTK4__
					If QComponent(FParent).Handle = 0 Then Exit Property
					Dim As PangoFontDescription Ptr pfd = pango_context_get_font_description(gtk_widget_get_pango_context(QComponent(FParent).Handle))
					If pfd = 0 Then Exit Property
				#elseif Not defined(__USE_GTK2__)
					Dim As GtkStyleContext Ptr WidgetStyle = gtk_widget_get_style_context(QComponent(FParent).Handle)
					#ifdef __USE_GTK4__
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
		FDefaultName = False
		Create
	End Property
	
	Private Property Font.Color As Integer
		Return FColor
	End Property
	
	#ifndef Font_Color_Set_Off
		Private Property Font.Color(Value As Integer)
			FColor = Value
			'Create
			#ifdef __USE_GTK__
				' GTK has no WM_CTLCOLOR: the text color is set to the widget
				If FParent AndAlso *FParent Is My.Sys.ComponentModel.Component AndAlso QComponent(FParent).Handle Then
					Dim As GtkWidget Ptr widget = QComponent(FParent).Handle
					#ifdef __USE_GTK2__
						Dim As GdkColor gColor
						gColor.red = (Value And &hFF) * 257
						gColor.green = ((Value Shr 8) And &hFF) * 257
						gColor.blue = ((Value Shr 16) And &hFF) * 257
						gtk_widget_modify_fg(widget, GTK_STATE_NORMAL, @gColor)
						gtk_widget_modify_text(widget, GTK_STATE_NORMAL, @gColor)
					#elseif defined(__USE_GTK4__)
						gtk4compat_widget_set_color(widget, Value)
					#else
						Dim As GdkRGBA gColor
						gColor.red = (Value And &hFF) / 255.0
						gColor.green = ((Value Shr 8) And &hFF) / 255.0
						gColor.blue = ((Value Shr 16) And &hFF) / 255.0
						gColor.alpha = 1.0
						gtk_widget_override_color(widget, GTK_STATE_FLAG_NORMAL, @gColor)
					#endif
				End If
			#elseif defined(__USE_WASM__)
				'The text color of the element (Control.CreateWnd sets it when the element is created later)
				If FParent AndAlso QComponent(FParent).Handle Then
					SetForeColor(QComponent(FParent).Handle, Value)
				End If
			#elseif defined(__USE_APPLE__)
				If FParent AndAlso QComponent(FParent).Handle Then mffViewSetForeColor(QComponent(FParent).Handle, Value)
			#elseif defined(__USE_JNI__)
				'The text color of a TextView (a Label, a LinkLabel, a Button...); the color of FreeBasic is BGR
				If env AndAlso FParent AndAlso QComponent(FParent).Handle Then
					Dim As jobject h = QComponent(FParent).Handle
					If (*env)->IsInstanceOf(env, h, FindJNIClass("android/widget/TextView")) Then
						Dim As Long ARGB = &hFF000000 Or ((Value And &hFF) Shl 16) Or (Value And &hFF00) Or ((Value Shr 16) And &hFF)
						(*env)->CallVoidMethod(env, h, GetMethodID("android/widget/TextView", "setTextColor", "(I)V"), ARGB)
					End If
				End If
			#endif
		End Property
	#endif
	
	Private Property Font.CharSet As FontCharset
		Return FCharSet
	End Property
	
	Private Property Font.CharSet(Value As FontCharset)
		FCharSet = Value
		Create
	End Property
	
	Private Property Font.Size As Integer
		Return FSize
	End Property
	
	Private Property Font.Size(Value As Integer)
		FSize = Value
		FDefaultSize = False
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
		WLet(FTemp, This.Name & ", " & This.Size)
		Return *FTemp
	End Operator
	
	Private Function Font.ToString ByRef As WString
		WLet(FTemp, This.Name & ", " & This.Size)
		Return *FTemp
	End Function
	
	Private Operator Font.Let(Value As Font)
		With Value
			WLet(FName, .Name)
			FBold       = .Bold
			FItalic     = .Italic
			FUnderline  = .Underline
			FStrikeOut  = .StrikeOut
			FSize       = .Size
			FColor      = .Color
			FCharSet    = .CharSet
			FOrientation = .Orientation
			xdpi        = .xdpi
			ydpi        = .ydpi
		End With
		Create
	End Operator
	
	Private Constructor Font
		WLet(FClassName, "Font")
		FCharSet  = FontCharset.Default
		WLet(FName, DefaultFont.Name)
		FSize     = DefaultFont.Size
		#ifdef __FB_WIN32__
			If *FName = "" Then WLet(FName, "Tahoma")
			If FSize = 0 Then FSize = 8
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
		#else
			If *FName = "" Then WLet(FName, "Ubuntu")
			If FSize = 0 Then FSize = 11
		#endif
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
	
	#ifdef __FB_WIN32__
		DefaultFont.Name = "Tahoma"
		DefaultFont.Size = 8
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		DefaultFont.Name = "Tahoma"
		DefaultFont.Size = 8
	#elseif defined(__USE_APPLE__)
		'The font of the system (San Francisco): 10 points of Windows are the 13 points of the controls of macOS
		DefaultFont.Name = "System"
		DefaultFont.Size = 10
	#else
		DefaultFont.Name = "Ubuntu"
		DefaultFont.Size = 11
	#endif
End Namespace
