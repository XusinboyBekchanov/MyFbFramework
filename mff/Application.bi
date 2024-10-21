'###############################################################################
'#  Application.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TApplication.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.1                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "WStringList.bi"
#include once "Dictionary.bi"
#include once "Form.bi"
Dim Shared As Dictionary mlKeys
#ifdef __USE_GTK__
	'#ifndef __FB_WIN32__
	'	#include once "crt/linux/unistd.bi"
	'#endif
	#ifdef __USE_GTK4__
		#include once "gir_headers/Gir/GModule-2.0.bi"
	#else
		#include once "gmodule.bi"
	#endif
#elseif defined(__USE_WINAPI__)
	#include once "win/winver.bi"
#endif
#ifndef APP_TITLE
	#define APP_TITLE ""
#endif

'#DEFINE crArrow       LoadCursor(0,IDC_ARROW)
'#DEFINE crAppStarting LoadCursor(0,IDC_APPSTARTING)
'#DEFINE crCross       LoadCursor(0,IDC_CROSS)
'#DEFINE crIBeam       LoadCursor(0,IDC_IBEAM)
'#DEFINE crIcon        LoadCursor(0,IDC_ICON)
'#DEFINE crNo          LoadCursor(0,IDC_NO)
'#DEFINE crSize        LoadCursor(0,IDC_SIZE)
'#DEFINE crSizeAll     LoadCursor(0,IDC_SIZEALL)
'#DEFINE crSizeNESW    LoadCursor(0,IDC_SIZENESW)
'#DEFINE crSizeNS      LoadCursor(0,IDC_SIZENS)
'#DEFINE crSizeNVSE    LoadCursor(0,IDC_SIZENWSE)
'#DEFINE crSizeWE      LoadCursor(0,IDC_SIZEWE)
'#DEFINE crUpArrow     LoadCursor(0,IDC_UPARROW)
'#DEFINE crWait        LoadCursor(0,IDC_WAIT)
'#DEFINE crDrag        LoadCursor(GetModuleHandle(NULL),"DRAG")
'#DEFINE crMultiDrag   LoadCursor(GetModuleHandle(NULL),"MULTIDRAG")
'#DEFINE crHandPoint   LoadCursor(GetModuleHandle(NULL),"HANDPOINT")
'#DEFINE crSQLWait     LoadCursor(GetModuleHandle(NULL),"SQLWAIT")
'#DEFINE crHSplit      LoadCursor(GetModuleHandle(NULL),"HSPLIT")
'#DEFINE crVSplit      LoadCursor(GetModuleHandle(NULL),"VSPLIT")
'#DEFINE crNoDrop      LoadCursor(GetModuleHandle(NULL),"NODROP")
'
Private Enum MessageType
	mtInfo
	mtWarning
	mtQuestion
	mtError
	mtOther
End Enum

Private Enum ButtonsTypes
	btNone
	btOK
	btYesNo
	btYesNoCancel
	btOkCancel
End Enum

Private Enum MessageResult
	mrAbort
	mrCancel
	mrIgnore
	mrNo
	mrOK
	mrRetry
	mrYes
End Enum

Enum FileEncodings
	PlainText
	Utf8
	Utf8BOM
	Utf16BOM
	Utf32BOM
End Enum

Enum NewLineTypes
	WindowsCRLF
	LinuxLF
	MacOSCR
End Enum

Private Enum ShutdownMode
	smAfterMainFormCloses
	smAfterAllFormsCloses
End Enum

Namespace My
	#define QApplication(__Ptr__) (*Cast(Application Ptr,__Ptr__))
	
	Private Type Application Extends My.Sys.Object
	Private:
		FDarkMode       As Boolean
		FTitle          As WString Ptr
		FCurLanguage    As WString Ptr
		FCurLanguagePath As WString Ptr
		FLanguage       As WString Ptr
		FIcon           As My.Sys.Drawing.Icon
		FExeName        As WString Ptr
		FFileName       As WString Ptr
		FHintColor      As Integer
		FHintPause      As Integer
		FHintShortPause As Integer
		FHintHidePause  As Integer
		FFormCount      As Integer
		FForms          As My.Sys.Forms.Form Ptr Ptr
		FControlCount   As Integer
		FControls       As My.Sys.Forms.Control Ptr Ptr
		FActiveForm     As My.Sys.Forms.Form Ptr
		FActiveMDIChild As My.Sys.Forms.Form Ptr
		FMainForm       As My.Sys.Forms.Form Ptr
		Declare Sub GetControls
		Declare Sub EnumControls(Control As My.Sys.Forms.Control)
		#ifdef __USE_WINAPI__
			Declare Static Function EnumThreadWindowsProc(FWindow As HWND,LData As LPARAM) As BOOL
			Declare Static Function EnumFontsProc(LOGFONT As LOGFONT Ptr, TEXTMETRIC As TEXTMETRIC Ptr, FontStyle As DWORD, hData As LPARAM) As Integer
		#endif
		Declare Sub GetFonts
		Declare Sub GetForms
		As Byte initialized
		As Any Ptr _vinfo
		As String TranslationString
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Fonts               As WStringList
		MouseX              As Integer
		MouseY              As Integer
		HelpFile            As String
		#ifdef __USE_WINAPI__
			Instance        As HINSTANCE
		#elseif defined(__USE_JNI__)
			Instance        As jobject
		#endif
		Declare Property ActiveForm As My.Sys.Forms.Form Ptr
		Declare Property ActiveForm(Value As My.Sys.Forms.Form Ptr)
		Declare Property ActiveMDIChild As My.Sys.Forms.Form Ptr
		Declare Property ActiveMDIChild(Value As My.Sys.Forms.Form Ptr)
		Declare Property DarkMode As Boolean
		Declare Property DarkMode(Value As Boolean)
		Declare Property FileName ByRef As WString
		Declare Property FileName(ByRef Value As WString)
		Declare Function Version() As String
		Declare Function GetVerInfo(ByRef InfoName As String) As String
		Declare Property Icon As My.Sys.Drawing.Icon
		Declare Property Icon(Value As My.Sys.Drawing.Icon)
		Declare Property Title ByRef As WString
		Declare Property Title(ByRef Value As WString)
		Declare Property CurLanguagePath ByRef As WString
		Declare Property CurLanguagePath(ByRef Value As WString)
		Declare Property CurLanguage ByRef As WString
		Declare Property CurLanguage(ByRef Value As WString)
		Declare Property Language ByRef As WString
		Declare Property Language(ByRef Value As WString)
		Declare Property ExeName ByRef As WString
		Declare Property ExeName(ByRef Value As WString)
		Declare Property MainForm As My.Sys.Forms.Form Ptr
		Declare Property MainForm(Value As My.Sys.Forms.Form Ptr)
'		Declare Property HintColor As Integer
'		Declare Property HintColor(value As Integer)
'		Declare Property HintPause As Integer
'		Declare Property HintPause (value As Integer)
'		Declare Property HintShortPause As Integer
'		Declare Property HintShortPause(value As Integer)
'		Declare Property HintHidePause As Integer
'		Declare Property HintHidePause(value As Integer)
		Declare Property ControlCount As Integer
		Declare Property ControlCount(Value  As Integer)
		Declare Property Controls As My.Sys.Forms.Control Ptr Ptr
		Declare Property Controls(Value  As My.Sys.Forms.Control Ptr Ptr)
		Declare Function FormCount As Integer
		Declare Property Forms As My.Sys.Forms.Form Ptr Ptr
		Declare Property Forms(Value As My.Sys.Forms.Form Ptr Ptr)
		Declare Operator Cast As Any Ptr
		Declare Sub Run
		Declare Sub Terminate
		Declare Sub DoEvents
		Declare Sub HelpCommand(CommandID As Integer,FData As Long)
		Declare Sub HelpContext(ContextID As Long)
		Declare Sub HelpJump(TopicID As String)
		Declare Function IndexOfForm(Form As My.Sys.Forms.Form Ptr) As Integer
		#ifdef __USE_WINAPI__
			Declare Function FindControl Overload(ControlHandle As HWND) As My.Sys.Forms.Control Ptr
		#endif
		Declare Function FindControl(ControlName As String) As My.Sys.Forms.Control Ptr
		Declare Function IndexOfControl(Control As My.Sys.Forms.Control Ptr) As Integer
		Declare Constructor
		Declare Destructor
		OnMouseMove As Sub(ByRef X As Integer, ByRef Y As Integer)
		OnMessage As Sub(ByRef MSG As Message)
	End Type
End Namespace

Dim Shared pApp As My.Application Ptr 'Global for entire Application

'Displays a message in a dialog box, waits for the user to click a button, and returns an Integer indicating which button the user clicked.
Declare Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
Declare Function ML(ByRef V As WString) ByRef As WString
Declare Function CheckUTF8NoBOM(ByRef SourceStr As String) As Boolean
Declare Function LoadFromFile(ByRef FileName As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) As WString Ptr
Declare Function SaveToFile(ByRef FileName As WString, ByRef wData As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) As Boolean

Namespace Debug
	Declare Sub Clear
	Declare Sub Print Overload(ByRef Msg As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print Overload(ByVal Msg As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print Overload(ByRef Msg As UString, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
End Namespace
Declare Function ApplicationMainForm Alias "ApplicationMainForm" (App As My.Application Ptr) As My.Sys.Forms.Control Ptr
Declare Function ApplicationFileName Alias "ApplicationFileName"(App As My.Application Ptr) ByRef As WString

#ifndef __USE_MAKE__
	#include once "Application.bas"
#endif
