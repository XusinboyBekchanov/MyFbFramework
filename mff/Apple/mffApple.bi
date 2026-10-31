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
	'The Control Ptr of the view, 0 if it is not a view of a control
	Declare Function mffViewControl(ByVal Id As Any Ptr) As Any Ptr
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
	'The pages of a PrintDocument: pictures; the Canvas draws in a page between mffCanvasBegin and mffCanvasEnd on macOS,
	'mffPageBeginDraw and mffPageEndDraw on iOS
	Declare Function mffPageCreate(ByVal PageWidth As Long, ByVal PageHeight As Long) As Any Ptr
	Declare Sub mffPageFree(ByVal Page As Any Ptr)
	Declare Sub mffPageDraw(ByVal Page As Any Ptr, ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long)
	Declare Sub mffPagesPrint(ByVal Pages As Any Ptr Ptr, ByVal Count As Long, ByVal DocName As Const ZString Ptr)
	#ifdef __USE_UIKIT__
		Declare Sub mffPageBeginDraw(ByVal Page As Any Ptr)
		Declare Sub mffPageEndDraw(ByVal Page As Any Ptr)
	#endif
	'OpenFileControl: the folders and the files of Patterns ("*.bas;*.bi") in a table; a choice raises mffOnChange,
	'mffFileViewAttr gives "data-event" (select, activate, folder), "data-dir" and "data-files" (malloc)
	Declare Sub mffFileViewFill(ByVal Id As Any Ptr, ByVal sDir As Const ZString Ptr, ByVal Patterns As Const ZString Ptr, ByVal Multiple As Long)
	Declare Function mffFileViewAttr(ByVal Id As Any Ptr, ByVal AttrName As Const ZString Ptr) As ZString Ptr
	'The bar of the menu of the program: the lines of mffPopupMenu, the host calls mffOnMenu with the index of the line
	Declare Sub mffMenuBarSet(ByVal Items As Const ZString Ptr)

	'ListControl with check boxes (CheckedListBox)
	Declare Sub mffListSetChecked(ByVal Id As Any Ptr, ByVal Index As Long, ByVal Value As Long)
	Declare Function mffListGetChecked(ByVal Id As Any Ptr, ByVal Index As Long) As Long
	'TabControl: the tabs are "Caption Tab x Tab Picture" separated by Chr(10), a click raises mffOnChange with the index, the
	'close button of a tab with -1 - Index; the selected tab is mffPositionSet. Position: 0 - left, 1 - right, 2 - top, 3 - bottom
	Declare Sub mffTabsSet(ByVal Id As Any Ptr, ByVal Titles As Const ZString Ptr)
	Declare Sub mffTabsSetPosition(ByVal Id As Any Ptr, ByVal Position As Long)
	Declare Function mffTabsStripHeight() As Long
	'ToolBar, ToolPalette: the buttons are "FlagText Tab Image Tab Options Tab Hint" separated by Chr(10); Flag: 0 - button,
	'1 - disabled, 2 - checked, 3 - separator, 4 - hidden. A click raises mffOnChange with the index.
	'mffButtonsItem: What 0 - the left of the item, 1 - its width (Index -1: the width of all), -1 if there is none
	Declare Sub mffButtonsSet(ByVal Id As Any Ptr, ByVal Items As Const ZString Ptr)
	Declare Function mffButtonsItem(ByVal Id As Any Ptr, ByVal Index As Long, ByVal What As Long) As Long
	Declare Function mffViewFittingWidth(ByVal Id As Any Ptr) As Long
	'WebBrowser (WKWebView). Action: 0 - back, 1 - forward, 2 - reload, 3 - stop
	Declare Sub mffWebLoadURL(ByVal Id As Any Ptr, ByVal URL As Const ZString Ptr)
	Declare Sub mffWebLoadHTML(ByVal Id As Any Ptr, ByVal HTML As Const ZString Ptr)
	Declare Sub mffWebAction(ByVal Id As Any Ptr, ByVal Action As Long)
	'ImageBox, Picture: a picture file stretched or centered
	Declare Sub mffViewLoadImage(ByVal Id As Any Ptr, ByVal Path As Const ZString Ptr, ByVal Center As Long)
	'The lines "Level Tab Enabled Tab Checked Tab Image Tab Caption": returns the index of the chosen line, -1 - none; x, y on the key window
	Declare Function mffPopupMenu(ByVal Items As Const ZString Ptr, ByVal x As Long, ByVal y As Long) As Long
	'Mode: 0 - open, 1 - open several files, 2 - save, 3 - folder; returns the paths separated with Chr(10), 0 - cancelled
	Declare Function mffFileDialog(ByVal Mode As Long, ByVal Caption As Const ZString Ptr, ByVal InitialDir As Const ZString Ptr, ByVal FileName As Const ZString Ptr, ByVal Filter As Const ZString Ptr, ByVal FilterIndex As Long) As ZString Ptr
	Declare Function mffFontDialog(ByVal FontName As Const ZString Ptr, ByVal Size As Long, ByVal Style As Long, ByVal FontColor As Long) As ZString Ptr
	Declare Function mffColorDialog(ByVal Caption As Const ZString Ptr, ByVal ColorValue As Long) As Long
	'NSRegularExpression: Flags 1 - ignore case, 2 - multiline, 4 - dot matches all, 8 - extended
	Declare Function mffRegexCompile(ByVal Pattern As Const ZString Ptr, ByVal Flags As Long) As Long
	Declare Function mffRegexError() As ZString Ptr
	Declare Sub mffRegexFree(ByVal Id As Long)
	Declare Function mffRegexExec(ByVal Id As Long, ByVal Subject As Const ZString Ptr, ByVal StartByte As Long, ByVal Offsets As Long Ptr, ByVal MaxGroups As Long) As Long
	'ListView, TreeView, Grid: Cells are separated by Chr(9), captions and widths of the columns by Chr(10), the first cell
	'can begin with Chr(1) & the picture & Chr(1); a click raises mffOnChange with the row. The rows are removed with mffListRemove
	Declare Sub mffTableInit(ByVal Id As Any Ptr)
	Declare Sub mffTableSetView(ByVal Id As Any Ptr, ByVal ViewName As Const ZString Ptr)
	Declare Sub mffTableSetColumns(ByVal Id As Any Ptr, ByVal Captions As Const ZString Ptr, ByVal Widths As Const ZString Ptr)
	Declare Sub mffTableInsertRow(ByVal Id As Any Ptr, ByVal Index As Long, ByVal Cells As Const ZString Ptr)
	Declare Sub mffTableSetRow(ByVal Id As Any Ptr, ByVal Index As Long, ByVal Cells As Const ZString Ptr)
	Declare Sub mffTableCellRect(ByVal Id As Any Ptr, ByVal Row As Long, ByVal Col As Long, ByVal pRect As Any Ptr)
	Declare Function mffTableDblClick() As Long
	'The Canvas draws on the view in its mffOnPaint (or on the view of mffCanvasBegin out of it)
	Declare Sub mffCanvasBegin(ByVal Id As Any Ptr)
	Declare Sub mffCanvasEnd(ByVal Id As Any Ptr)
	Declare Sub mffCanvasNewPath()
	Declare Sub mffCanvasMoveTo(ByVal x As Double, ByVal y As Double)
	Declare Sub mffCanvasLineTo(ByVal x As Double, ByVal y As Double)
	Declare Sub mffCanvasCurveTo(ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double, ByVal x3 As Double, ByVal y3 As Double)
	Declare Sub mffCanvasArc(ByVal cx As Double, ByVal cy As Double, ByVal r As Double, ByVal a1 As Double, ByVal a2 As Double, ByVal Negative As Long)
	Declare Sub mffCanvasRectPath(ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub mffCanvasClosePath()
	Declare Sub mffCanvasClip()
	Declare Sub mffCanvasFill(ByVal iColor As Long, ByVal Alpha As Long)
	Declare Sub mffCanvasStroke(ByVal iColor As Long, ByVal Alpha As Long, ByVal LineWidth As Double, ByVal Dash As Const ZString Ptr)
	Declare Sub mffCanvasFillRect(ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Long, ByVal Alpha As Long)
	Declare Sub mffCanvasInvertRect(ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub mffCanvasRotate(ByVal x As Double, ByVal y As Double, ByVal Angle As Double)
	Declare Sub mffCanvasSave()
	Declare Sub mffCanvasRestore()
	Declare Sub mffCanvasText(ByVal x As Double, ByVal y As Double, ByVal Text As Const ZString Ptr, ByVal iColor As Long, ByVal iBkColor As Long, ByVal FontName As Const ZString Ptr, ByVal FontSize As Double, ByVal Bold As Long, ByVal Italic As Long)
	Declare Function mffCanvasTextWidth(ByVal Text As Const ZString Ptr, ByVal FontName As Const ZString Ptr, ByVal FontSize As Double, ByVal Bold As Long, ByVal Italic As Long) As Long
	Declare Function mffCanvasTextHeight(ByVal FontName As Const ZString Ptr, ByVal FontSize As Double, ByVal Bold As Long, ByVal Italic As Long) As Long
	Declare Function mffCanvasGetPixel(ByVal x As Double, ByVal y As Double) As Long
	Declare Sub mffCanvasImage(ByVal Path As Const ZString Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal Alpha As Long)
End Extern
