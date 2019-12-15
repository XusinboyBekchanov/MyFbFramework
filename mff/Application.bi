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

#Include Once "WStringList.bi"
#Include Once "Control.bi"
#IfDef __USE_GTK__
	#include once "gmodule.bi"
	#include Once "crt/linux/unistd.bi"
#Else
	#include once "win/winver.bi"
#EndIf

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
Enum MessageType
	mtInfo
	mtWarning
	mtQuestion
	mtError
	mtOther
End Enum

Enum ButtonsTypes
	btNone
	btOK
	btYesNo
	btYesNoCancel
	btOkCancel
End Enum

Enum MessageResult
	mrAbort
	mrCancel
	mrIgnore
	mrNo
	mrOK
	mrRetry
	mrYes
End Enum

'Declare Function MsgBox(ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As Integer = 0, ButtonsType As Integer = 1) As Integer

Enum ShutdownMode
	smAfterMainFormCloses
	smAfterAllFormsCloses
End Enum

namespace My
	#DEFINE QApplication(__Ptr__) *Cast(Application Ptr,__Ptr__)
	
	Type Application
		Private:
		FTitle          As WString Ptr
		FIcon           As My.Sys.Drawing.Icon
		FExeName        As WString Ptr
		FFileName       As WString Ptr
		FHintColor      As Integer
		FHintPause      As Integer
		FHintShortPause As Integer
		FHintHidePause  As Integer
		FFormCount      As Integer
		FForms          As My.Sys.Forms.Control Ptr Ptr
		FControlCount   As Integer
		FControls       As My.Sys.Forms.Control Ptr Ptr
		FMainForm       As My.Sys.Forms.Control Ptr
		Declare Sub GetControls
		Declare Sub EnumControls(Control As My.Sys.Forms.Control)
		#IfNDef __USE_GTK__
			Declare Static Function EnumThreadWindowsProc(FWindow As HWND,LData As LParam) As Bool
			Declare Static Function EnumFontsProc(LogFont As LOGFONT Ptr, TextMetric As TEXTMETRIC Ptr, FontStyle As DWORD, hData As LPARAM) As Integer
		#EndIf
		Declare Sub GetFonts
		Declare Sub GetForms
		As Byte initialized
		As Any Ptr _vinfo
		As String TranslationString
		Public:
		Fonts           As WStringList
		MouseX          As Integer
		MouseY          As Integer
		HelpFile        As String
		#IfNDef __USE_GTK__
			Instance        As HINSTANCE
		#EndIf
		Declare Property FileName ByRef As WString
		Declare Property FileName(ByRef Value As WString)
		Declare Function Version() As Const String
		Declare Function GetVerInfo(ByRef InfoName As String) As String
		
		Declare Property Icon As My.Sys.Drawing.Icon
		Declare Property Icon(value As My.Sys.Drawing.Icon)
		Declare Property Title ByRef As WString
		Declare Property Title(ByRef Value As WString)
		Declare Property ExeName ByRef As WString
		Declare Property ExeName(ByRef Value As WString)
		Declare Property MainForm As My.Sys.Forms.Control Ptr
		Declare Property MainForm(Value  As My.Sys.Forms.Control Ptr) 
		Declare Property HintColor As Integer
		Declare Property HintColor(value As Integer)
		Declare Property HintPause As Integer
		Declare Property HintPause (value As Integer)
		Declare Property HintShortPause As Integer
		Declare Property HintShortPause(value As Integer)
		Declare Property HintHidePause As Integer
		Declare Property HintHidePause(value As Integer)
		Declare Property ControlCount As Integer
		Declare Property ControlCount(Value  As Integer)
		Declare Property Controls As My.Sys.Forms.Control Ptr Ptr
		Declare Property Controls(Value  As My.Sys.Forms.Control Ptr Ptr) 
		Declare Function FormCount As Integer
		Declare Property Forms As My.Sys.Forms.Control Ptr Ptr 
		Declare Property Forms(Value  As My.Sys.Forms.Control Ptr Ptr)
		Declare Operator Cast As Any Ptr
		Declare Sub Run
		Declare Sub Terminate
		Declare Sub DoEvents
		Declare Sub HelpCommand(CommandID As Integer,FData As Long)
		Declare Sub HelpContext(ContextID As Long)
		Declare Sub HelpJump(TopicID As String)
		Declare Function IndexOfForm(Form As My.Sys.Forms.Control Ptr) As Integer
		#IfNDef __USE_GTK__
			Declare Function FindControl Overload(ControlHandle As HWND) As My.Sys.Forms.Control Ptr
		#EndIf
		Declare Function FindControl(ControlName As String) As My.Sys.Forms.Control Ptr
		Declare Function IndexOfControl(Control As My.Sys.Forms.Control Ptr) As Integer
		Declare Constructor
		Declare Destructor
		OnMouseMove As Sub(BYREF X As Integer,BYREF Y As Integer)
		OnMessage As Sub(ByRef msg As Message)
	End Type
End namespace

Common Shared pApp As My.Application Ptr 'Global for entire Application

#IfDef __EXPORT_PROCS__
	Declare Function MsgBox Alias "MsgBox"(ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As Integer = 0, ButtonsType As Integer = 1) As Integer
#Else
	Declare Function MsgBox Alias "MsgBox"(ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As Integer = 0, ButtonsType As Integer = 1) As Integer
#EndIf

#IfDef __EXPORT_PROCS__
	Declare Function ApplicationMainForm Alias "ApplicationMainForm"(App As My.Application Ptr) As My.Sys.Forms.Control Ptr
	
	Declare Function ApplicationFileName Alias "ApplicationFileName"(App As My.Application Ptr) ByRef As WString
#EndIf

#IfNDef __USE_MAKE__
	#Include Once "Application.bas"
#EndIf
