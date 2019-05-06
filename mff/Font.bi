'###############################################################################
'#  Font.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TFont.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Component.bi"

Using My.Sys.ComponentModel

#IfDef __USE_GTK__
	Enum FontCharset
		Default
		Ansi
		Arabic
		Baltic
		ChineseBig5
		EastEurope
		GB2312
		Greek
		Hangul
		Hebrew
		Johab
		Mac
		OEM
		Russian
		Shiftjis
		Symbol
		Thai
		Turkish
		Vietnamese
	End Enum
#Else
	Enum FontCharset
		Default     = DEFAULT_CHARSET
		Ansi        = ANSI_CHARSET
		Arabic      = ARABIC_CHARSET
		Baltic      = BALTIC_CHARSET
		ChineseBig5 = CHINESEBIG5_CHARSET
		EastEurope  = EASTEUROPE_CHARSET
		GB2312      = GB2312_CHARSET
		Greek       = GREEK_CHARSET
		Hangul      = HANGUL_CHARSET
		Hebrew      = HEBREW_CHARSET
		Johab       = JOHAB_CHARSET
		Mac         = MAC_CHARSET
		OEM         = OEM_CHARSET
		Russian     = RUSSIAN_CHARSET
		Shiftjis    = SHIFTJIS_CHARSET
		Symbol      = SYMBOL_CHARSET
		Thai        = THAI_CHARSET
		Turkish     = TURKISH_CHARSET
		Vietnamese  = VIETNAMESE_CHARSET
	End Enum
#EndIf

Namespace My.Sys.Drawing
    #DEFINE QFont(__Ptr__) *Cast(Font Ptr,__Ptr__)

    Type Font Extends My.Sys.Object
        Private:
            FBold      As Boolean
            FItalic    As Boolean
            FUnderline As Boolean
            FStrikeOut As Boolean
            FSize      As Integer
            FName      As WString Ptr
            FColor     As Integer
            FCharSet   As Integer 
            FParent    As Component Ptr
            FBolds(2)  As Integer
            FCyPixels  As Integer
            Declare Sub Create
        Public:
			#IfDef __USE_GTK__
				Handle As PangoFontDescription Ptr
			#Else
				Handle As HFONT
			#EndIf
            Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Function ToString ByRef As WString
            Declare Property Parent As Component Ptr
            Declare Property Parent(Value As Component Ptr)
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Property Color As Integer
            Declare Property Color(Value As Integer)
            Declare Property Size As Integer
            Declare Property Size(Value As Integer)
            Declare Property CharSet As Integer 'FontCharset
            Declare Property CharSet(Value As Integer)
            Declare Property Bold As Boolean
            Declare Property Bold(Value As Boolean)
            Declare Property Italic As Boolean
            Declare Property Italic(Value As Boolean)
            Declare Property Underline As Boolean
            Declare Property Underline(Value As Boolean)
            Declare Property StrikeOut As Boolean
            Declare Property StrikeOut(Value As Boolean)
            Declare Operator Cast As Any Ptr
            Declare Operator Cast ByRef As WString
            Declare Operator Let(Value As Font) 
            Declare Constructor
            Declare Destructor
    End Type

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
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        End If
        Return True
    End Function
    
    Sub Font.Create
		#IfDef __USE_GTK__
			If Handle Then pango_font_description_free (Handle)
			Handle = pango_font_description_from_string (*FName & IIf(FBold, " Bold", "") & IIf(FItalic, " Italic", "") & " " & Str(FSize))
		#Else
			If Handle Then DeleteObject(Handle) 
			Handle = CreateFontW(-MulDiv(FSize,FcyPixels,72),0,0,0,FBolds(Abs_(FBold)),FItalic,FUnderline,FStrikeout,FCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*FName)
		#EndIf
		If Handle Then
			If FParent Then
				#IfDef __USE_GTK__
					If FParent->Widget Then
						#IfDef __USE_GTK3__
							gtk_widget_override_font(FParent->Widget, Handle)
						#Else
							gtk_widget_modify_font(FParent->Widget, Handle)
						#EndIf
					End If
				#Else
					If FParent->Handle Then
						SendMessage(FParent->Handle, WM_SETFONT,CUInt(Handle),True)
						InvalidateRect FParent->Handle, 0, True
					End If
				#EndIf
			End If
		End If
    End Sub

    Property Font.Parent As Component Ptr
        Return FParent
    End Property

    Property Font.Parent(Value As Component Ptr)
        FParent = value
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
        		Dim As GtkStyleContext Ptr WidgetStyle = gtk_widget_get_style_context(FParent->Widget)
        		Var pfd = gtk_style_context_get_font(WidgetStyle, GTK_STATE_FLAG_NORMAL)
        	#Else
        		Dim As GtkStyle Ptr WidgetStyle = gtk_widget_get_style(FParent->Widget)
        		Var pfd = WidgetStyle->font_desc
        	#EndIf
        	WLet FName, WStr(*pango_font_description_get_family(pfd))
	        FSize = pango_font_description_get_size(pfd) / PANGO_SCALE
        #Else
        	Create
        #EndIf
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
        End With
        Create
    End Operator

    Constructor Font
        WLet FClassName, "Font"
        FCharSet  = FontCharset.Default
        #IfNDef __USE_GTK__
			Dim As HDC Dc
			Dc = GetDC(HWND_DESKTOP)
			FCyPixels = GetDeviceCaps(DC, LOGPIXELSY)
			ReleaseDC(HWND_DESKTOP,DC)
	        FBolds(0) = 400
	        FBolds(1) = 700
	        WLet FName, "TAHOMA"
	        FSize     = 8
	        Create
	    #Else
	       	FSize 	  = 11
        #EndIf
    End Constructor

    Destructor Font
		#IfDef __USE_GTK__
			If Handle Then pango_font_description_free (Handle)
		#Else
			If Handle Then DeleteObject(Handle)
		#EndIf
    End Destructor
End namespace
