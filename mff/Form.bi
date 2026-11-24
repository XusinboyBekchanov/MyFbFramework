'################################################################################
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
#include once "Graphic.bi"
#include once "Sys.bi"

Namespace My.Sys.Forms
	#define QForm(__Ptr__) (*Cast(Form Ptr,__Ptr__))
	
	Private Enum ModalResults
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
	
	Private Enum FormBorderStyle
		None
		SizableToolWindow
		FixedToolWindow
		Sizable
		Fixed3D
		FixedSingle
		FixedDialog
	End Enum
	
	Private Enum FormStyles
		fsNormal
		fsMDIForm
		fsMDIChild
		fsStayOnTop
	End Enum
	
	Private Enum FormStartPosition
		Manual
		CenterScreen
		DefaultLocation
		DefaultBounds
		CenterParent
	End Enum
	
	Private Enum WindowStates
		wsHide
		wsNormal
		wsMaximized
		wsMinimized
	End Enum
	
	'A window or dialog box that makes up part of an application's user interface (Windows, Linux, Android, Web, macOS, iOS).
	Private Type Form Extends ContainerControl
	Private:
		InShowModal    As Boolean
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
		#ifdef __USE_WASM__
			'The bounds of the form before it was maximized or minimized (WindowState)
			FRestoreLeft   As Integer
			FRestoreTop    As Integer
			FRestoreWidth  As Integer
			FRestoreHeight As Integer
		#endif
		#ifndef __USE_WINAPI__
			'An MDI child (Form.bas): its MDI form, its state and its bounds of the normal state
			FMDIOwner      As Form Ptr
			FMDIMaximized  As Boolean
			FMDIRestore(3) As Integer
			Declare Function MDIOwnerForm As Form Ptr
			Declare Sub MDISetFrameBounds(ByVal iLeft As Integer, ByVal iTop As Integer, ByVal iWidth As Integer, ByVal iHeight As Integer)
			Declare Sub MDISetState(ByVal Value As WindowStates)
			Declare Function MDIMinimizedHeight As Integer
			Declare Function MDIIconsHeight As Integer
		#endif
		#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
			'MDI without the MDI windows of the system (Form.bas): the client area of an fsMDIForm is a control, an
			'fsMDIChild of it is in a frame with a title bar in the client area (Web: the element of the form with its title bar)
			FMDIClient     As Control Ptr
			FMDIActive     As Form Ptr
			FMDIFrame      As Control Ptr
			FMDICaption    As Control Ptr
			FMDIDragX      As Integer
			FMDIDragY      As Integer
			FMDIPressed    As Integer
			FMDICount      As Integer
			FMDIInShow     As Boolean
			'The order over each other of an MDI child (of an MDI form: the last one)
			FMDIZOrder     As Integer
			Declare Sub MDICreateClient
			Declare Sub MDIShow
			Declare Sub MDIClose
			Declare Sub MDIHide
			Declare Sub MDIBringToFront
			Declare Static Sub MDIClient_Resize(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
			Declare Static Sub MDICaption_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			Declare Static Sub MDICaption_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			Declare Static Sub MDICaption_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			Declare Static Sub MDICaption_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			Declare Static Sub MDICaption_DblClick(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		#endif
		Declare Sub MDIArrange(ByVal Kind As Integer)
		Declare Function MDIChildList(Children() As Form Ptr, ByVal Filter As Integer) As Integer
		Declare Sub MDIClientSize(ByRef ClientWidth As Integer, ByRef ClientHeight As Integer)
		FFormCreated   As Boolean
		FDPIChanging   As Boolean
		FShowInTaskbar As Boolean
		FOnCreate      As Sub(ByRef Sender As Form)
		#ifdef __USE_JNI__
			FExternalEventAction As WString * 256
			FExternalEventExtra  As WString * 256
			Declare Sub UpdateExternalEventFilter
			Declare Function IsSecondForm As Boolean
			FInShowModal As Boolean
			'The size of the form of the designer: a modal form on a tablet (Show)
			FDialogLeft As Integer
			FDialogTop As Integer
			FDialogWidth As Integer
			FDialogHeight As Integer
			Declare Function IsToolWindow As Boolean
			Declare Sub ApplyAndroidStyle
		#endif
		Declare Static Sub ActiveControlChanged(ByRef Sender As Control)
		#ifdef __USE_GTK__
			ImageWidget As GtkWidget Ptr
			Declare Static Function Client_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Client_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function deactivate_cb(ByVal user_data As gpointer) As gboolean
			#ifdef __USE_GTK4__
				' GTK4 has no delete and focus change events for windows
				Declare Static Function Form_CloseRequest(window_ As GtkWindow Ptr, user_data As Any Ptr) As Boolean
				Declare Static Sub Form_ActiveChanged(window_ As GtkWindow Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			#endif
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
			#ifdef __USE_WINAPI__
				Declare Static Function HookClientProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Declare Virtual Sub SetDark(Value As Boolean)
			#endif
		#endif
		Declare Function EnumMenuItems(Item As MenuItem) As Boolean
		Declare Sub GetMenuItems
		Declare Sub ShowItems(Ctrl As Control Ptr)
		Declare Sub HideItems(Ctrl As Control Ptr)
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		Declare Static Sub IconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
	Protected:
		FControlBox     As Boolean
		FKeyPreview     As Boolean
		FMinimizeBox    As Boolean
		FMaximizeBox    As Boolean
		FOpacity        As Integer
		FTransparent    As Boolean
		FTransparentColor As Integer
		#ifdef __USE_GTK__
			WindowWidget As GtkWidget Ptr
			HeaderBarWidget As GtkWidget Ptr
			Declare Property ParentWidget As GtkWidget Ptr
			Declare Property ParentWidget(Value As GtkWidget Ptr)
		#elseif defined(__USE_WASM__)
			Declare Virtual Function GetContent() As UString
		#endif
	Public:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		'Returns the icon displayed when a form is minimized at run time (Windows, Linux, Web, macOS).
		Icon          As My.Sys.Drawing.Icon
		'Returns/sets a graphic to be displayed in a control (Windows, Linux, Web).
		Graphic As My.Sys.Drawing.GraphicType
		'Returns/sets the dialog result for the form (Windows, Linux, Android, Web, macOS, iOS).
		ModalResult   As ModalResults
		#ifndef ReadProperty_Off
			'Reads value from the name of property (Windows, Linux, Android, Web, macOS, iOS).
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes value to the name of property (Windows, Linux, Android, Web, macOS, iOS).
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns/sets the active control on the container control (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property ActiveControl As Control Ptr
		Declare Property ActiveControl(Value As Control Ptr)
		'Returns/sets the default button for dialog, acts on the Enter / Return key (Windows, Linux)
		Declare Property DefaultButton As Control Ptr 'CommandButton
		Declare Property DefaultButton(Value As Control Ptr)
		'Returns/sets the cancel button for dialog, acts on the Esc key (Windows)
		Declare Property CancelButton As Control Ptr 'CommandButton
		Declare Property CancelButton(Value As Control Ptr)
		'Returns/sets the border style of the form (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property BorderStyle As FormBorderStyle
		Declare Property BorderStyle(Value As FormBorderStyle)
		'Determines the form's style: fsMDIForm, fsMDIChild (the MDI of mff on Android, Web, macOS, iOS), fsStayOnTop (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property FormStyle As FormStyles
		Declare Property FormStyle(Value As FormStyles)
		'Returns/sets a value that indicates whether form is minimized, maximized, or normal (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property WindowState As WindowStates
		Declare Property WindowState(Value As WindowStates)
		'Returns/sets whether keyboard events for an object are invoked before keyboard events for controls on that object (Windows only).
		Declare Property KeyPreview As Boolean
		Declare Property KeyPreview(Value As Boolean)
		'Returns/sets the starting position of the form at run time (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property StartPosition As FormStartPosition
		Declare Property StartPosition(Value As FormStartPosition)
		'Returns/sets the opacity level of the form (Windows, Linux).
		Declare Property Opacity As Integer
		Declare Property Opacity(Value As Integer)
		#ifdef __USE_JNI__
			'Returns/sets the Intent action used to receive data from an external source, e.g. a barcode/QR scanner (Android). Set together with ExternalEventExtra.
			Declare Property ExternalEventAction ByRef As WString
			Declare Property ExternalEventAction(ByRef Value As WString)
			'Returns/sets the name of the Intent extra that holds the external event data, e.g. the scanned barcode text (Android).
			Declare Property ExternalEventExtra ByRef As WString
			Declare Property ExternalEventExtra(ByRef Value As WString)
		#endif
		'Returns/sets the form that owns this form (Windows).
		Declare Property Owner As Form Ptr
		Declare Property Owner(Value As Form Ptr)
		'Returns/sets the caption of the control (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		'Returns/sets the text contained in the control (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		'Returns/sets the transparent used to display text and graphics in a form (Windows only).
		Declare Property Transparent As Boolean
		Declare Property Transparent(Value As Boolean)
		'Returns/sets the transparent color used to display text and graphics in a form (Windows only).
		Declare Property TransparentColor As Integer
		Declare Property TransparentColor(Value As Integer)
		'Returns/sets a value indicating whether a Control-menu box is displayed on a form at run time (Windows only)
		Declare Property ControlBox As Boolean
		Declare Property ControlBox(Value As Boolean)
		'Determines whether a form has a Minimize button (Windows only)
		Declare Property MinimizeBox As Boolean
		Declare Property MinimizeBox(Value As Boolean)
		'Determines whether a form has a Maximize button (Windows only)
		Declare Property MaximizeBox As Boolean
		Declare Property MaximizeBox(Value As Boolean)
		'Gets or sets the main form for application. (Windows, Linux, Android, Web, macOS, iOS)
		Declare Property MainForm As Boolean
		Declare Property MainForm(Value As Boolean)
		'Gets or sets the MainMenu that is displayed in the form (Windows, Linux, Android, Web, macOS, iOS)
		Declare Property Menu As MainMenu Ptr
		Declare Property Menu(Value As MainMenu Ptr)
		'Returns/sets a value that determines whether an object can respond to user-generated events (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		'Returns/sets the parent container of the control (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property Parent As Control Ptr
		Declare Property Parent(Value As Control Ptr)
		'Returns/sets Gets or sets a value indicating whether the form is displayed in the taskbar (Windows only).
		Declare Property ShowInTaskbar As Boolean
		Declare Property ShowInTaskbar(Value As Boolean)
		'Returns/sets a value that determines whether an object is visible or hidden (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Operator Cast As Control Ptr
		'Brings the control to the front of the z-order (Windows).
		Declare Sub BringToFront
		'Sends the control to the back of the z-order (Windows).
		Declare Sub SendToBack
		'Invalidates the entire surface of the control and causes the control to be redrawn (Windows only).
		Declare Sub Invalidate
		'Displays the control to the user (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub Show
		'Shows the form with the specified owner to the user (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub Show(ByRef OwnerForm As Form)
		'Shows the form as a modal dialog box (Windows, Linux, Android, Web, macOS, iOS).
		Declare Function ShowModal As Integer
		'Shows the form As a modal dialog box With the specified owner (Windows, Linux, Android, Web, macOS, iOS).
		Declare Function ShowModal(ByRef Parent As Form) As Integer
		'Conceals the control from the user.
		Declare Sub Hide
		'Maximizes the window (Windows, Linux).
		Declare Sub Maximize
		'Minimizes the window (Windows, Linux).
		Declare Sub Minimize
		'Closes the form (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub CloseForm
		#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
			'Puts the fsMDIChild form over the other ones in its MDI form and makes it the active one (Android, Web, macOS, iOS).
			Declare Sub MDIActivate
		#endif
		#ifdef __USE_WASM__
			'The title bar of the fsMDIChild form moved it (data-left, data-top of its element) (Web).
			Declare Sub MDIDragEnd
		#endif
		'Arranges the MDI children of the fsMDIForm form one over the other, each one a title bar lower (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub Cascade
		'Arranges the MDI children of the fsMDIForm form one under the other (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub TileHorizontal
		'Arranges the MDI children of the fsMDIForm form side by side (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub TileVertical
		'Arranges the minimized MDI children of the fsMDIForm form at the bottom of its client area (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub ArrangeIcons
		'Closes all the MDI children of the fsMDIForm form (CloseForm of each one) (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub CloseMDIChildren
		'Returns the active MDI child of the fsMDIForm form, 0 - none (Windows, Linux, Android, Web, macOS, iOS).
		Declare Property ActiveMDIChild As Form Ptr
		'Centers the position of the form within the bounds of the parent form (Windows, Linux, Android, Web, macOS, iOS).
		Declare Sub CenterToParent
		'Centers the form on the current screen (Windows, Linux, macOS, iOS).
		Declare Sub CenterToScreen(ByVal ScrLeft As Integer = 0, ByVal ScrTop As Integer = 0, ByVal ScrWidth As Integer = 0, ByVal ScrHeight As Integer = 0)
		Declare Constructor
		Declare Destructor
		'Occurs when the form is activated in code or by the user (Windows, Linux).
		OnActivate              As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs after a Application instance becomes active (Windows, Linux).
		OnActivateApp           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs when changes focus one of the controls on the form (Windows, Linux, Android, Web, macOS, iOS).
		OnActiveControlChange   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs when the form is closed (Windows, Linux, Android, Web, macOS, iOS).
		OnClose                 As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Action As Integer)
		'Occurs when the form loses focus and is no longer the active form (Windows, Linux).
		OnDeActivate            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs after a Application instance becomes deactive (Windows, Linux).
		OnDeActivateApp         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs when the application receives data from an external source, e.g. a barcode/QR scanner (Android).
		OnExternalEvent         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Data As WString)
		'Occurs when the Visible property value changes to false (Windows, Linux, Android, Web, macOS, iOS).
		OnHide                  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
		'Occurs when the Visible property value changes to true (Windows, Linux, Android, Web, macOS, iOS).
		OnShow                  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form)
	End Type
End Namespace

#ifdef __USE_JNI__
	'Android: the units of the design per inch. 96 keeps the physical size of the design (a form of the designer);
	'160 makes a unit one dp of Android (smaller, for big forms). Set it before the main form is created (onCreate).
	Dim Shared As Single AndroidDesignDpi = 96
#endif

#ifndef __USE_MAKE__
	#include once "Form.bas"
#endif
