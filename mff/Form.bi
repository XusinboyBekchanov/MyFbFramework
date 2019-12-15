'###############################################################################
'#  Form.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TForm.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "ContainerControl.bi"
#Include Once "Application.bi"

Namespace My.Sys.Forms
	#DEFINE QForm(__Ptr__) *Cast(Form Ptr,__Ptr__)
	
	Enum ModalResults
		OK
		Cancel
		Yes
		No
	End Enum
	
	Enum FormBorderStyle
		None
		SizableToolWindow
		FixedToolWindow
		Sizable
		Fixed3D
		FixedSingle
		FixedDialog
	End Enum
	
	Enum FormStyles
		fsNormal
		fsMDIForm
		fsMDIChild
		fsStayOnTop
	End Enum
	
	Enum FormStartPosition
		Manual
		CenterScreen
		DefaultLocation
		DefaultBounds
		CenterParent
	End Enum
	
	Enum WindowStates
		wsHide
		wsNormal
		wsMaximized
		wsMinimized
	End Enum
	
	Type Form Extends ContainerControl
		Private:
		FMainForm      As Boolean
		FMainStyle(2)  As Integer
		FMenuItems     As List
		FBorderStyle   As Integer
		FFormStyle     As Integer
		FBorderIcons   As Integer
		FExStyle(6)    As Integer
		FCmdShow(4)    As Integer
		FChild(2)      As Integer
		FStyle(6)      As Integer
		FClassStyle(6) As Integer
		FWindowState   As Integer
		FCreated	   As Boolean
		FOnCreate      As Sub(BYREF Sender As Form)
		Declare Static Sub ActiveControlChanged(ByRef Sender As Control)
		#IfNDef __USE_GTK__
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
			Declare Static Sub WndProc(BYREF Message As Message)
		#EndIf
		Declare Function EnumMenuItems(Item As MenuItem) As Boolean
		Declare Sub GetMenuItems
		Protected:
		Declare Sub ProcessMessage(BYREF Message As Message)
		FControlBox     As Boolean
		FMinimizeBox    As Boolean
		FMaximizeBox    As Boolean
		FOpacity        As Integer
		Public:
		Icon          As My.Sys.Drawing.Icon
		ModalResult   As Integer 'ModalResults
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property ActiveControl As Control Ptr
		Declare Property ActiveControl(Value As Control Ptr)
		Declare Property DefaultButton As Control ptr 'CommandButton
		Declare Property DefaultButton(Value As Control ptr)
		Declare Property CancelButton As Control ptr 'CommandButton
		Declare Property CancelButton(Value As Control ptr)
		Declare Property BorderStyle As Integer 'FormBorderStyle
		Declare Property BorderStyle(Value As Integer)
		Declare Property FormStyle As Integer 'FormStyles
		Declare Property FormStyle(Value As Integer)
		Declare Property WindowState As Integer 'WindowStates
		Declare Property WindowState(Value As Integer)
		Declare Property StartPosition As Integer 'FormStartPosition
		Declare Property StartPosition(Value As Integer)
		Declare Property Opacity As Integer
		Declare Property Opacity(Value As Integer)
		Declare Property Owner As Form Ptr
		Declare Property Owner(Value As Form Ptr)
		#IfDef __USE_GTK__
			WindowWidget As GtkWidget Ptr
			HeaderBarWidget As GtkWidget Ptr
			Declare Property ParentWidget As GtkWidget Ptr
			Declare Property ParentWidget(Value As GtkWidget Ptr)
		#EndIf
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property ControlBox As Boolean
		Declare Property ControlBox(Value As Boolean)            
		Declare Property MinimizeBox As Boolean
		Declare Property MinimizeBox(Value As Boolean)            
		Declare Property MaximizeBox As Boolean
		Declare Property MaximizeBox(Value As Boolean)            
		Declare Property MainForm As Boolean
		Declare Property MainForm(Value As Boolean)
		Declare Property Menu As MainMenu Ptr
		Declare Property Menu(Value As MainMenu Ptr)
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)            
		Declare Operator Cast As Control Ptr
		Declare Sub BringToFront
		Declare Sub SendToBack
		Declare Sub Invalidate
		Declare Sub Repaint
		Declare Sub Show
		Declare Sub Show(ByRef Parent As Form)
		Declare Function ShowModal As Integer
		Declare Sub Hide
		Declare Sub Maximize
		Declare Sub Minimize
		Declare Sub CloseForm
		Declare Sub Center
		Declare Constructor
		Declare Destructor
		OnActivate   As Sub(ByRef Sender As Form)
		OnActiveControlChange As Sub(ByRef Sender As Form)
		OnClose      As Sub(ByRef Sender As Form, BYREF Action As Integer)
		OnDeActivate As Sub(ByRef Sender As Form)
		OnHide       As Sub(ByRef Sender As Form)
		OnFree       As Sub(ByRef Sender As Form)
		#IfNDef __USE_GTK__
			OnPaint      As Sub(ByRef Sender As Form, DC As HDC, R As Rect)
		#EndIf
		OnSize       As Sub(ByRef Sender As Form)
		OnShow       As Sub(ByRef Sender As Form)
		OnTimer      As Sub(ByRef Sender As Form)
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "Form.bas"
#EndIf
