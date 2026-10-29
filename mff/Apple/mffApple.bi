'################################################################################
'#  mffApple.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  The C functions of the Objective-C host of macOS (Cocoa/mffCocoa.m) and     #
'#  iOS (UIKit/mffUIKit.m), the same as Apple/mffApple.h                        #
'#  Authors: Xusinboy Bekchanov                                                 #
'################################################################################

'A view is the retained NSView/UIView (a Form: its NSWindow on macOS, its UIViewController view on iOS) which the
'host returns; Ctrl is the Control Ptr which gets the events of the view (the mffOn* functions of Control.bas).
'All strings are UTF-8; a returned ZString Ptr is made with malloc and freed with Deallocate.
'Colors are BGR (&hBBGGRR) like on Windows, -1 is the default color of the view.
Extern "C"
	'Kind: the class name of the control ("Form", "CommandButton", "Label", "TextBox", "CheckBox", "RadioButton",
	'"Panel", "GroupBox", "ListControl", "ComboBoxEdit", "ProgressBar", "TrackBar", ...) or the kind of its
	'ClassAncestor "mff:Kind" ("TextArea"). An unknown kind is a plain view which hosts the child controls and draws
	'the Canvas of the control
	Declare Function mffViewCreate(ByVal Kind As Const ZString Ptr, ByVal Ctrl As Any Ptr) As Any Ptr
	'Removes the view from its parent (closes the window of a Form) and releases it
	Declare Sub mffViewFree(ByVal Id As Any Ptr)
	'The view which hosts the child controls (the content view of a window or of a group box), View itself if it has none
	Declare Function mffViewLayout(ByVal Id As Any Ptr) As Any Ptr
	'Puts Child into the layout view of Parent (mffViewLayout)
	Declare Sub mffViewAddChild(ByVal Parent As Any Ptr, ByVal Child As Any Ptr)
	'The bounds in points from the top left corner of the parent (of the screen for a Form, its outer frame)
	Declare Sub mffViewSetBounds(ByVal Id As Any Ptr, ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long)
	'The size of the layout view (the client area), Vertical: 0 - the width, 1 - the height
	Declare Function mffViewClientSize(ByVal Id As Any Ptr, ByVal Vertical As Long) As Long
	Declare Sub mffViewSetText(ByVal Id As Any Ptr, ByVal Text As Const ZString Ptr)
	Declare Function mffViewGetText(ByVal Id As Any Ptr) As ZString Ptr
	Declare Sub mffViewSetHint(ByVal Id As Any Ptr, ByVal Text As Const ZString Ptr)
	Declare Sub mffViewSetVisible(ByVal Id As Any Ptr, ByVal Value As Long)
	Declare Sub mffViewSetEnabled(ByVal Id As Any Ptr, ByVal Value As Long)
	Declare Sub mffViewSetFocus(ByVal Id As Any Ptr)
	Declare Function mffViewHasFocus(ByVal Id As Any Ptr) As Long
	Declare Sub mffViewSetBackColor(ByVal Id As Any Ptr, ByVal Value As Long)
	Declare Sub mffViewSetForeColor(ByVal Id As Any Ptr, ByVal Value As Long)
	'Style: 1 - bold, 2 - italic, 4 - underline, 8 - strikeout; Name "" - the font of the system, Size in points
	Declare Sub mffViewSetFont(ByVal Id As Any Ptr, ByVal Name As Const ZString Ptr, ByVal Size As Single, ByVal Style As Long)
	'1 - over the sibling views (BringToFront), 0 - under them (SendToBack)
	Declare Sub mffViewZOrder(ByVal Id As Any Ptr, ByVal ToFront As Long)
	'Asks the view to paint again: the host calls mffOnPaint, then the Canvas of the control draws
	Declare Sub mffViewRepaint(ByVal Id As Any Ptr)
	'CheckBox, RadioButton: 0 - unchecked, 1 - checked, 2 - indeterminate
	Declare Sub mffViewSetChecked(ByVal Id As Any Ptr, ByVal Value As Long)
	Declare Function mffViewGetChecked(ByVal Id As Any Ptr) As Long
	Declare Sub mffViewSetReadOnly(ByVal Id As Any Ptr, ByVal Value As Long)
	'Label, TextBox: 0 - left, 1 - center, 2 - right
	Declare Sub mffViewSetAlignment(ByVal Id As Any Ptr, ByVal Value As Long)
	'TextBox: the selection in characters
	Declare Sub mffTextSetSelection(ByVal Id As Any Ptr, ByVal Start As Long, ByVal Length As Long)
	Declare Function mffTextGetSelection(ByVal Id As Any Ptr, ByVal GetLength As Long) As Long
	Declare Sub mffTextSetPassword(ByVal Id As Any Ptr, ByVal Value As Long)

	'ListBox, ComboBox: Index -1 appends the item
	Declare Sub mffListInsert(ByVal Id As Any Ptr, ByVal Index As Long, ByVal Text As Const ZString Ptr)
	Declare Sub mffListRemove(ByVal Id As Any Ptr, ByVal Index As Long)
	Declare Sub mffListClear(ByVal Id As Any Ptr)
	Declare Function mffListGetIndex(ByVal Id As Any Ptr) As Long
	Declare Sub mffListSetIndex(ByVal Id As Any Ptr, ByVal Index As Long)

	'ProgressBar, TrackBar, ScrollBar
	Declare Sub mffRangeSet(ByVal Id As Any Ptr, ByVal MinValue As Long, ByVal MaxValue As Long)
	Declare Sub mffPositionSet(ByVal Id As Any Ptr, ByVal Value As Long)
	Declare Function mffPositionGet(ByVal Id As Any Ptr) As Long

	'Forms. Modal: the host runs a nested loop until mffFormHide of the form (Form.ShowModal)
	Declare Sub mffFormShow(ByVal Id As Any Ptr, ByVal Modal As Long)
	Declare Sub mffFormHide(ByVal Id As Any Ptr)
	'0 - normal, 1 - minimized, 2 - maximized
	Declare Sub mffFormSetState(ByVal Id As Any Ptr, ByVal State As Long)
	'FormBorderStyle of Form.bi: 0 - None, 1 - SizableToolWindow, 2 - FixedToolWindow, 3 - Sizable, 4 - Fixed3D,
	'5 - FixedSingle, 6 - FixedDialog
	Declare Sub mffFormSetBorder(ByVal Id As Any Ptr, ByVal Style As Long)
	Declare Sub mffFormSetMainMenu(ByVal Id As Any Ptr, ByVal Items As Const ZString Ptr)
	Declare Function mffScreenSize(ByVal Vertical As Long) As Long

	Declare Sub mffAppRun()
	Declare Sub mffAppTerminate()
	'Handles the waiting events once (App.DoEvents)
	Declare Sub mffAppDoEvents()
	'Dark (1) or light (0) appearance of the program, -1 - the one of the system
	Declare Sub mffAppSetDarkMode(ByVal Value As Long)
	Declare Function mffAppDarkMode() As Long
	'MessageType and ButtonsType of Application.bi; returns the MessageResult
	Declare Function mffMessageBox(ByVal Msg As Const ZString Ptr, ByVal Caption As Const ZString Ptr, ByVal MessageType As Long, ByVal ButtonsType As Long) As Long
	'The host calls mffOnTimer(Id) every Interval milliseconds until mffTimerStop
	Declare Sub mffTimerStart(ByVal Id As Any Ptr, ByVal Interval As Long)
	Declare Sub mffTimerStop(ByVal Id As Any Ptr)
	Declare Sub mffClipboardSetText(ByVal Text As Const ZString Ptr)
	Declare Function mffClipboardGetText() As ZString Ptr
	Declare Sub mffOpenURL(ByVal URL As Const ZString Ptr)
End Extern
