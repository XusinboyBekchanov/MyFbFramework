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

#include once "Component.bi"

Using My.Sys.ComponentModel

#ifdef __USE_WINAPI__
	Private Enum FontCharset
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
#else
	Private Enum FontCharset
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
#endif

Namespace My.Sys.Drawing
	#define QFont(__Ptr__) (*Cast(Font Ptr,__Ptr__))
	
	'`Font` is a Control within the MyFbFramework, part of the freeBasic framework.MyFbFramework.
	'`Font` - Defines text formatting attributes including typeface, size, and style characteristics.
	Private Type Font Extends My.Sys.Object
	Private:
		FBold      As Boolean
		FItalic    As Boolean
		FUnderline As Boolean
		FStrikeOut As Boolean
		FSize      As Integer
		FName      As WString Ptr
		FColor     As Integer
		FCharSet   As Integer
		FParent    As My.Sys.Object Ptr
		FBolds(2)  As Integer
		FEscapement As Integer = 0 '是字体的倾斜角。 David Change
		FOrientation As Integer = 0 '是字体的倾斜角。 David Change
		Declare Sub Create
	Public:
		#ifdef __USE_GTK__
			'Native HFONT handle reference
			Handle As PangoFontDescription Ptr
		#elseif defined(__USE_JNI__)
			'Native HFONT handle reference
			Handle As jobject
		#elseif defined(__USE_WINAPI__)
			'Native HFONT handle reference
			Handle As HFONT
		#else
			'Native HFONT handle reference
			Handle As Any Ptr
		#endif
		#ifndef ReadProperty_Off
			'Loads font settings from persistence stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves font configuration to persistence stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns formatted string (e.g., "Arial 12pt Bold")
		Declare Function ToString ByRef As WString
		Declare Property Parent As My.Sys.Object Ptr
		'Reference to parent graphic object
		Declare Property Parent(Value As My.Sys.Object Ptr)
		Declare Property Name ByRef As WString
		'Typeface family name
		Declare Property Name(ByRef Value As WString)
		Declare Property Color As Integer
		'Foreground text color
		Declare Property Color(Value As Integer)
		Declare Property Size As Integer
		'Font height in logical units
		Declare Property Size(Value As Integer)
		Declare Property Orientation As Integer
		'Text rotation angle in tenths of degrees
		Declare Property Orientation(Value As Integer)
		Declare Property CharSet As Integer 'FontCharset
		'Character set encoding (ANSI/Unicode/Symbol)
		Declare Property CharSet(Value As Integer)
		Declare Property Bold As Boolean
		'Determines if the font uses bold weight
		Declare Property Bold(Value As Boolean)
		Declare Property Italic As Boolean
		'Enables italicized text style
		Declare Property Italic(Value As Boolean)
		Declare Property Underline As Boolean
		'Enables text underlining
		Declare Property Underline(Value As Boolean)
		Declare Property StrikeOut As Boolean
		'Toggles strikethrough effect
		Declare Property StrikeOut(Value As Boolean)
		Declare Operator Cast As Any Ptr
		Declare Operator Cast ByRef As WString
		Declare Operator Let(Value As Font)
		'Triggered after GDI font object creation
		OnCreate As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Font)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

Dim Shared pDefaultFont As My.Sys.Drawing.Font Ptr

#ifndef __USE_MAKE__
	#include once "Font.bas"
#endif
