﻿'################################################################################
'#  Form.bi                                                                     #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TForm.bi                                                                   #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019), Liu XiaLin (2020)                        #
'################################################################################

#include once "ContainerControl.bi"
#include once "Application.bi"
#include once "Graphic.bi"

Namespace My.Sys.Forms
	#define QForm(__Ptr__) *Cast(Form Ptr,__Ptr__)
	
	Enum ModalResults
		'Nothing шs returned from the dialog box. This means that the modal dialog continues running.
		None
		'The dialog box return value is OK (usually sent from a button labeled OK).
		OK
		'The dialog box return value is Cancel (usually sent from a button labeled Cancel).
		Cancel
		'The dialog box return value is Abort (usually sent from a button labeled Abort).
		Abort
		'The dialog box return value is Retry (usually sent from a button labeled Retry).
		Retry
		'The dialog box return value is Ignore (usually sent from a button labeled Ignore).
		Ignore
		'The dialog box return value is Yes (usually sent from a button labeled Yes).
		Yes
		'The dialog box return value is No (usually sent from a button labeled No).
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
		FFormCreated   As Boolean
		FOnCreate      As Sub(ByRef Sender As Form)
		Declare Static Sub ActiveControlChanged(ByRef Sender As Control)
		#ifdef __USE_GTK__
			ImageWidget As GtkWidget Ptr
			Declare Static Function Client_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Client_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function deactivate_cb(ByVal user_data As gpointer) As gboolean
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			Declare Static Sub WndProc(ByRef Message As Message)
		#endif
		Declare Function EnumMenuItems(Item As MenuItem) As Boolean
		Declare Sub GetMenuItems
		Declare Sub ShowItems(Ctrl As Control Ptr)
		Declare Sub HideItems(Ctrl As Control Ptr)
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		Declare Static Sub IconChanged(ByRef Sender As My.Sys.Drawing.Icon)
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		FControlBox     As Boolean
		FMinimizeBox    As Boolean
		FMaximizeBox    As Boolean
		FOpacity        As Integer
		#ifdef __USE_GTK__
			WindowWidget As GtkWidget Ptr
			HeaderBarWidget As GtkWidget Ptr
			Declare Property ParentWidget As GtkWidget Ptr
			Declare Property ParentWidget(Value As GtkWidget Ptr)
		#endif
	Public:
		'Returns the icon displayed when a form is minimized at run time.
		Icon          As My.Sys.Drawing.Icon
		'Returns/sets a graphic to be displayed in a control.
		Graphic As My.Sys.Drawing.GraphicType
		'Returns/sets the dialog result for the form.
		ModalResult   As Integer 'ModalResults
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		'Returns/sets the active control on the container control.
		Declare Property ActiveControl As Control Ptr
		Declare Property ActiveControl(Value As Control Ptr)
		Declare Property DefaultButton As Control Ptr 'CommandButton
		Declare Property DefaultButton(Value As Control Ptr)
		Declare Property CancelButton As Control Ptr 'CommandButton
		Declare Property CancelButton(Value As Control Ptr)
		'Returns/sets the border style of the form.
		Declare Property BorderStyle As Integer 'FormBorderStyle
		Declare Property BorderStyle(Value As Integer)
		'
		Declare Property FormStyle As Integer 'FormStyles
		Declare Property FormStyle(Value As Integer)
		'Returns/sets a value that indicates whether form is minimized, maximized, or normal.
		Declare Property WindowState As Integer 'WindowStates
		Declare Property WindowState(Value As Integer)
		'Returns/sets the starting position of the form at run time.
		Declare Property StartPosition As Integer 'FormStartPosition
		Declare Property StartPosition(Value As Integer)
		'Returns/sets the opacity level of the form.
		Declare Property Opacity As Integer
		Declare Property Opacity(Value As Integer)
		'Returns/sets the form that owns this form.
		Declare Property Owner As Form Ptr
		Declare Property Owner(Value As Form Ptr)
		'Returns/sets the caption of the control
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		'Returns/sets the text contained in the control
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		'Returns/sets a value indicating whether a Control-menu box is displayed on a form at run time
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
		'Returns/sets a value that determines whether an object can respond to user-generated events.
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		'Returns/sets the parent container of the control.
		Declare Property Parent As Control Ptr
		Declare Property Parent(value As Control Ptr)
		'Returns/sets a value that determines whether an object is visible or hidden.
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Operator Cast As Control Ptr
		'Brings the control to the front of the z-order.
		Declare Sub BringToFront
		'Sends the control to the back of the z-order.
		Declare Sub SendToBack
		'Invalidates the entire surface of the control and causes the control to be redrawn.
		Declare Sub Invalidate
		'Displays the control to the user.
		Declare Sub Show
		'Shows the form with the specified owner to the user.
		Declare Sub Show(ByRef OwnerForm As Form)
		'Shows the form as a modal dialog box.
		Declare Function ShowModal As Integer
		'Shows the form As a modal dialog box With the specified owner.
		Declare Function ShowModal(ByRef Parent As Form) As Integer
		'Conceals the control from the user.
		Declare Sub Hide
		Declare Sub Maximize
		Declare Sub Minimize
		'Closes the form.
		Declare Sub CloseForm
		'Centers the position of the form within the bounds of the parent form.
		Declare Sub CenterToParent
		'Centers the form on the current screen.
		Declare Sub CenterToScreen
		Declare Constructor
		Declare Destructor
		'Occurs when the form is activated in code or by the user (Windows only).
		OnActivate              As Sub(ByRef Sender As Form)
		'Occurs after a Application instance becomes active (Windows only).
		OnActivateApp           As Sub(ByRef Sender As Form)
		'Occurs when changes focus one of the controls on the form (Windows, Linux).
		OnActiveControlChange   As Sub(ByRef Sender As Form)
		'Occurs when the form is closed (Windows, Linux).
		OnClose                 As Sub(ByRef Sender As Form, ByRef Action As Integer)
		'Occurs when the form loses focus and is no longer the active form (Windows only).
		OnDeActivate            As Sub(ByRef Sender As Form)
		'Occurs after a Application instance becomes deactive (Windows only).
		OnDeActivateApp         As Sub(ByRef Sender As Form)
		'Occurs when the Visible property value changes to false (Windows only).
		OnHide                  As Sub(ByRef Sender As Form)
		'Occurs when the Visible property value changes to true (Windows, Linux).
		OnShow                  As Sub(ByRef Sender As Form)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Form.bas"
#endif
