'################################################################################
'#  SysUtils.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   SysUtils.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                       #
'################################################################################

#ifdef __FB_ANDROID__
	#ifndef __USE_JNI__
		#define __USE_JNI__
	#endif
#elseif defined(__FB_JS__)
	#ifndef __USE_WASM__
		#define __USE_WASM__
	#endif
#elseif defined(__USE_COCOA__) OrElse defined(__USE_UIKIT__)
	'macOS (AppKit, -d __USE_COCOA__) and iOS (UIKit, -d __USE_UIKIT__): the views are made by the Objective-C host
	'(mff/Cocoa/mffCocoa.m, mff/UIKit/mffUIKit.m), which the program is linked with.
	'__USE_APPLE__ marks the code which both of them share (the C functions of the host, mff/Apple/mffApple.h)
	#ifndef __USE_APPLE__
		#define __USE_APPLE__
	#endif
#elseif Not defined(__USE_WASM__)
	#if Not defined(__FB_WIN32__)
		#ifndef __USE_GTK__
			#define __USE_GTK__
		#endif
	#elseif Not defined(__USE_GTK__)
		#ifndef __USE_WINAPI__
			#define __USE_WINAPI__
		#endif
	#endif
#endif

#if defined(__USE_WINAPI__) OrElse (defined(__FB_WIN32__) AndAlso Not defined(__USE_GTK4__))
    #define UNICODE
    #include once "windows.bi"
#else
    '' POSIX / Unix-like platforms
    '#if defined(__FB_LINUX__) OrElse defined(__FB_MACOSX__) OrElse defined(__FB_FREEBSD__) OrElse defined(__FB_OPENBSD__) OrElse defined(__FB_NETBSD__) OrElse defined(__FB_SOLARIS__)
    '    Extern "C"
    '        
    '        Enum clockid_t
    '            CLOCK_REALTIME = 0
    '            CLOCK_MONOTONIC = 1
    '            CLOCK_PROCESS_CPUTIME_ID = 2
    '            CLOCK_THREAD_CPUTIME_ID = 3
    '        End Enum
'
    '        Declare Function clock_gettime Alias "clock_gettime" _
    '            (ByVal clk_id As Integer, ByVal tp As timespec Ptr) As Integer
    '    End Extern
    '#endif
#endif

#ifdef __USE_GTK__
	#define __USE_CAIRO__
	'#define FHandle Widget
	'#if defined(__USE_GTK3__) Or defined(__USE_GTK4__)
	'#elseif Not defined(__USE_GTK2__)
	'	#define __USE_GTK2__
	'#endif
	'#ifdef __USE_GTK4__
	'	#include once "cairo/cairo.bi"
	'	#include once "gir_headers/Gir/PangoCairo-1.0.bi"
	'	#include once "gir_headers/Gir/Gtk-4.0.bi"
	'	#include once "gir_headers/Gir/_GObjectMacros-2.0.bi"
	'#else
	'	#include once "gtk/gtk.bi"
	'	#ifdef __USE_GTK3__
	'		#include once "glib-object.bi"
	'	#endif
	'#endif
#elseif defined(__USE_JNI__)
	#include once "jni.bi"
	#define max(a, b) IIf((a) > (b), (a), (b))
	#define min(a, b) IIf((a) < (b), (a), (b))
#elseif defined(__USE_APPLE__)
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
	#include once "Apple/mffApple.bi"
	#define NULL 0
#elseif defined(__USE_WASM__)
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
	Declare Function TimerHiRes() As Double
	Declare Sub AddColumn(Id As Any Ptr, Caption As String)
	Declare Sub AddRow(Id As Any Ptr, Text As String)
	Declare Sub AddSelectItem(Id As Any Ptr, Text As String)
	Declare Function GetDocumentWidth() As Integer
	Declare Function GetDocumentHeight() As Integer
	'The width (Vertical = 0) or the height of the client element of a control (its Id & "Client", like the pages of
	'TabControl under the tabs); -1: the control has no visible client element
	Declare Function GetClientSize(Id As Any Ptr, ByVal Vertical As Integer) As Integer
	Declare Sub InsertHTML(Value As String)
	Declare Sub SetTitle(Value As String)
	'The dark colors of the page (html.mffdark of mff.html), SetDarkMode
	Declare Sub SetPageDarkMode(ByVal Value As Boolean)
	Declare Sub FreePtr(Ptr As Any Ptr)
	Declare Sub SetVisibleByStringId(Id As String, Value As Boolean)
	'The minimize and maximize buttons of the title bar of the form Id for its WindowState (0 normal, 1 minimized,
	'2 maximized): the button of the state restores the form
	Declare Sub SetCaptionState(Id As Any Ptr, ByVal State As Integer)
	'The place on the page of the element under which the element Id is placed (its Left and Top are from there)
	Declare Function GetParentPageOffset(Id As Any Ptr, ByVal Vertical As Long) As Long
	Declare Sub SetVisible(Id As Any Ptr, Value As Boolean)
	Declare Sub ElementSetBounds(Id As Any Ptr, ByVal iLeft As Integer, ByVal iTop As Integer, ByVal iWidth As Integer, ByVal iHeight As Integer)
	Declare Sub ElementSetEnabled(Id As Any Ptr, Value As Boolean)
	Declare Sub ElementSetFocus(Id As Any Ptr)
	Declare Sub SetInnerText(Id As Any Ptr, Value As String)
	Declare Sub SetInnerTextByStringId(Id As String, Value As String)
	Declare Sub InsertSelectItem(Id As Any Ptr, ByVal Index As Integer, Text As String)
	'The picture of the item Index of a <select> (ComboBoxEx): the URLs separated by "|" (FindResourceFile), "" - none;
	'Indent: the indent of the item (10 pixels each)
	Declare Sub SetSelectItemImage(Id As Any Ptr, ByVal Index As Integer, URLs As String, ByVal Indent As Integer)
	'The icon of the form Id in its title bar, of the page (favicon) for the main form: the URLs separated by "|"
	'(FindIconFile), "" - none
	Declare Sub SetFormIcon(Id As Any Ptr, URLs As String, ByVal Main As Boolean)
	Declare Sub RemoveSelectItem(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub ClearSelectItems(Id As Any Ptr)
	Declare Sub SetMultiple(Id As Any Ptr, Value As Boolean)
	Declare Sub SetSize(Id As Any Ptr, Value As Integer)
	Declare Function GetSelectedIndex(Id As Any Ptr) As Integer
	Declare Sub SetSelectedIndex(Id As Any Ptr, Value As Integer)
	Declare Sub CreateElement(AddPosition As String, ClassName As String, Class As String, Type As String, Id As Any Ptr, Name As String, Text As String, Style As String, PositionType As String, Left As String, Top As String, Width As String, Height As String, Right As String, Bottom As String, Parent As Any Ptr)
	Declare Sub DeleteElement(Id As Any Ptr)
	'The size of the content of the element without wrapping: Horizontal - the width, otherwise the height (a tooltip)
	Declare Function ElementNaturalSize(Id As Any Ptr, ByVal Horizontal As Long) As Long
	'Moves the element Id into the element of the parent Parent (Control.Add of a control with an element)
	Declare Sub SetParentElement(Id As Any Ptr, Parent As Any Ptr)
	'The element over (ToFront) or under (not ToFront) its siblings: Control.BringToFront, Control.SendToBack
	Declare Sub ElementZOrder(Id As Any Ptr, ByVal ToFront As Long)
	Declare Function GetStringValue(Id As Any Ptr) As ZString Ptr
	Declare Sub ReadElementValue(Id As Any Ptr, ByRef Value As WString Ptr)
	Declare Sub SetStringValue(Id As Any Ptr, Value As String)
	'An <input>, a <textarea> (readOnly) or a <div contenteditable> (RichTextBox) can not be edited (TextBox.ReadOnly)
	Declare Sub SetReadOnly(Id As Any Ptr, ByVal Value As Boolean)
	'The commands of a RichTextBox (RICHTEXTCMD of mff_lib.js): "get..." returns the value; UTF-8, freed with Deallocate
	Declare Function RichTextCmd(Id As Any Ptr, Cmd As String, Value As String) As ZString Ptr
	'The selection of a TextBox or a RichTextBox: TextGetSel returns "start,end" (freed with Deallocate)
	Declare Function TextGetSel(Id As Any Ptr) As ZString Ptr
	Declare Sub TextSetSel(Id As Any Ptr, ByVal SelStart As Long, ByVal SelEnd As Long)
	Declare Sub SetBackColor(Id As Any Ptr, Value As Integer)
	Declare Sub SetForeColor(Id As Any Ptr, Value As Integer)
	Declare Sub SetFont(Id As Any Ptr, Value As String)
	Declare Sub SetChecked(Id As String, Value As Boolean)
	Declare Function GetChecked(Id As String) As Boolean
	Declare Sub SetAttribute(Id As Any Ptr, Name As String, Value As String)
	'Sets one CSS property of the element, e.g. SetStyle(Id, "cursor", "ew-resize")
	Declare Sub SetStyle(Id As Any Ptr, Name As String, Value As String)
	Declare Sub SetInnerHTML(Id As Any Ptr, Value As String)
	Declare Function GetAttribute(Id As Any Ptr, Name As String) As ZString Ptr
	'Clicks on the <a> elements of Id raise CM_CHANGE; GetPosition returns the index, GetAttribute(Id, "data-link") the href
	Declare Sub SetLinkEvent(Id As Any Ptr)
	Declare Sub OpenURL(URL As String)
	'HotKey: a key press with modifiers is written as "Ctrl+Shift+Alt+Key" into the input and raises CM_CHANGE
	Declare Sub SetHotKeyEvent(Id As Any Ptr)
	'Splitter: pointer press/move/release raise CM_CHANGE with the attributes data-drag (1, 2, 3), data-dx and data-dy
	Declare Sub SetDragEvent(Id As Any Ptr)
	Declare Sub SetRange(Id As Any Ptr, ByVal MinValue As Integer, ByVal MaxValue As Integer)
	Declare Sub SetPosition(Id As Any Ptr, ByVal Value As Integer)
	Declare Function GetPosition(Id As Any Ptr) As Integer
	Declare Sub SetItemChecked(Id As Any Ptr, ByVal Index As Integer, Value As Boolean)
	Declare Function GetItemChecked(Id As Any Ptr, ByVal Index As Integer) As Boolean
	'Titles are separated by Chr(10); clicking a tab raises CM_CHANGE, GetPosition returns the selected tab
	Declare Sub SetTabs(Id As Any Ptr, Titles As String)
	Declare Sub LoadURL(Id As Any Ptr, URL As String)
	Declare Sub LoadHTML(Id As Any Ptr, HTML As String)
	'Action: 0 - back, 1 - forward, 2 - reload, 3 - stop
	Declare Sub WebAction(Id As Any Ptr, ByVal Action As Integer)
	'Calls the exported OnTimer(Id) every Interval milliseconds until StopTimer
	Declare Sub StartTimer(Id As Any Ptr, ByVal Interval As Integer)
	Declare Sub StopTimer(Id As Any Ptr)
	'ImageBox, Picture: a picture file (Web: a URL; Android: a file or an asset), stretched or centered
	Declare Sub LoadImage(Id As Any Ptr, Path As String, Center As Boolean)
	'ToolBar: a row of buttons; the items are separated by Chr(10), the first char of an item is a flag:
	'"0" - button, "1" - disabled, "2" - checked, "3" - separator, "4" - hidden. A click raises CM_CHANGE.
	Declare Sub SetButtons(Id As Any Ptr, Items As String)
	'Canvas (My.Sys.Drawing.Canvas) of a control; Id is the control element (Web) / view (Android).
	'The path works like the one of cairo: CanvasFill and CanvasStroke keep it, CanvasNewPath starts a new one.
	'Colors are BGR, Alpha 0..255, angles in radians, Dash e.g. "10,5" ("" is solid).
	'Printing (PrintDocument): the offscreen canvas of the page Id, Width x Height pixels at 96 DPI; the Canvas draws
	'into it with the page as its Handle
	Declare Sub PageCreate(Id As Any Ptr, ByVal Width As Integer, ByVal Height As Integer)
	Declare Sub PageDelete(Id As Any Ptr)
	'The page PageId in the canvas of the control Id at x, y in w x h (PrintPreviewControl)
	Declare Sub PageDraw(Id As Any Ptr, PageId As Any Ptr, ByVal x As Integer, ByVal y As Integer, ByVal w As Integer, ByVal h As Integer)
	'The print dialog of the browser prints the pages (their addresses separated by spaces)
	Declare Sub PrintPages(Ids As String, Title As String)
	Declare Sub CanvasBegin(Id As Any Ptr)
	Declare Sub CanvasEnd(Id As Any Ptr)
	Declare Sub CanvasNewPath(Id As Any Ptr)
	Declare Sub CanvasMoveTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasLineTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasCurveTo(Id As Any Ptr, ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double, ByVal x3 As Double, ByVal y3 As Double)
	Declare Sub CanvasArc(Id As Any Ptr, ByVal cx As Double, ByVal cy As Double, ByVal r As Double, ByVal a1 As Double, ByVal a2 As Double, ByVal Negative As Integer = 0)
	Declare Sub CanvasRectPath(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasClosePath(Id As Any Ptr)
	'The current path becomes the clip of the next drawing (until CanvasRestore of a CanvasSave before it); the path is cleared
	Declare Sub CanvasClip(Id As Any Ptr)
	Declare Sub CanvasFill(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasStroke(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer, ByVal LineWidth As Double, Dash As String)
	Declare Sub CanvasFillRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Integer, ByVal Alpha As Integer)
	'Inverts the pixels of the rectangle (the caret of Windows)
	Declare Sub CanvasInvertRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	'The next drawing is turned around the point x, y by Angle degrees counterclockwise (until CanvasRestore of a
	'CanvasSave before it): the text of a font with an escapement of Windows
	Declare Sub CanvasRotate(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal Angle As Double)
	Declare Sub CanvasSave(Id As Any Ptr)
	Declare Sub CanvasRestore(Id As Any Ptr)
	Declare Sub CanvasText(Id As Any Ptr, ByVal x As Double, ByVal y As Double, Text As String, ByVal iColor As Integer, ByVal iBkColor As Integer, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer)
	Declare Function CanvasTextWidth(Id As Any Ptr, Text As String, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasTextHeight(Id As Any Ptr, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasGetPixel(Id As Any Ptr, ByVal x As Double, ByVal y As Double) As Integer
	Declare Sub CanvasImage(Id As Any Ptr, Path As String, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal Alpha As Integer)
	'Table view (ListView, TreeListView, GridData): Web - a <table>, Android - a ListView with a row of text per item.
	'Cells are separated by Chr(9), column captions and widths by Chr(10); a click on a row raises CM_CHANGE.
	Declare Sub TableInit(Id As Any Ptr)
	'The view of a ListView: "icon", "smallicon", "list", "tile" or "report" (the rows of a table). The first
	'cell of a row can begin with Chr(1) & the path of its picture & Chr(1)
	Declare Sub TableSetView(Id As Any Ptr, View As String)
	Declare Sub TableSetColumns(Id As Any Ptr, Captions As String, Widths As String)
	Declare Sub TableInsertRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableSetRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableRemoveRow(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub TableClear(Id As Any Ptr)
	Declare Sub TableSetIndex(Id As Any Ptr, ByVal Index As Integer)
	Declare Function TableGetIndex(Id As Any Ptr) As Integer
	'The rectangle of the cell Row, Col of the table (Left, Top, Right, Bottom: Long) in the coordinates of its content
	Declare Sub TableCellRect(Id As Any Ptr, ByVal Row As Long, ByVal Col As Long, ByVal pRect As Any Ptr)
	'True when the row was double clicked (Web)
	Declare Function TableDblClick(Id As Any Ptr) As Boolean
	Declare Function MessageBox(Message As String, Caption As String, MessageType As Integer, ButtonsType As Integer) As Integer
	Declare Sub SetLoadEvent(Id As Any Ptr)
	Declare Sub SetChangeEvent(Id As Any Ptr)
	Declare Sub SetClickEvent(Id As Any Ptr)
	Declare Sub SetDblClickEvent(Id As Any Ptr)
	Declare Sub SetGotFocusEvent(Id As Any Ptr)
	Declare Sub SetLostFocusEvent(Id As Any Ptr)
	Declare Sub SetKeyDownEvent(Id As Any Ptr)
	Declare Sub SetKeyPressEvent(Id As Any Ptr)
	Declare Sub SetKeyUpEvent(Id As Any Ptr)
	Declare Sub SetMouseEnterEvent(Id As Any Ptr)
	Declare Sub SetMouseDownEvent(Id As Any Ptr)
	Declare Sub SetMouseMoveEvent(Id As Any Ptr)
	'OnMouseHover: ONMOUSEHOVER of the control Id after the mouse stays 400 ms at x, y (a move or leaving it stops it)
	Declare Sub MouseHoverTimer(Id As Any Ptr, ByVal x As Integer, ByVal y As Integer, ByVal Shift As Integer)
	Declare Sub SetMouseUpEvent(Id As Any Ptr)
	Declare Sub SetMouseLeaveEvent(Id As Any Ptr)
	Declare Sub SetMouseWheelEvent(Id As Any Ptr)
	Declare Sub SetUnloadEvent(Id As Any Ptr)
	#define NULL 0
#elseif defined(__USE_WINAPI__)
	#include once "win/wincrypt.bi"
	#include once "Win/CommCtrl.bi"
	#include once "Win/CommDlg.bi"
	#include once "Win/RichEdit.bi"
	#include once "win/iphlpapi.bi"
	#define Instance GetModuleHandle(NULL)
#endif
#include once "UString.bi"
#include once "Integer.bi"
#ifdef __USE_APPLE__
	'The text of the view (mffViewGetText) into Value
	Declare Sub mffReadViewText(Id As Any Ptr, ByRef Value As WString Ptr)
	'The items of the lists (ListControl, ComboBoxEdit) with the names of the Web and Android versions
	Declare Sub ListInit(Id As Any Ptr)
	Declare Sub AddSelectItem(Id As Any Ptr, Text As String)
	Declare Sub InsertSelectItem(Id As Any Ptr, ByVal Index As Integer, Text As String)
	Declare Sub RemoveSelectItem(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub ClearSelectItems(Id As Any Ptr)
	Declare Function GetSelectedIndex(Id As Any Ptr) As Integer
	Declare Sub SetSelectedIndex(Id As Any Ptr, Value As Integer)
	'The range and the position of a TrackBar with the names of the Web and Android versions
	Declare Sub SetRange(Id As Any Ptr, ByVal MinValue As Integer, ByVal MaxValue As Integer)
	Declare Sub SetPosition(Id As Any Ptr, ByVal Value As Integer)
	Declare Function GetPosition(Id As Any Ptr) As Integer
	'The names of the Web and Android versions, which the controls share: the host functions of Apple/mffApple.bi
	Declare Sub StartTimer(Id As Any Ptr, ByVal Interval As Integer)
	Declare Sub StopTimer(Id As Any Ptr)
	'The file list of an OpenFileControl, the pages of a print preview
	Declare Sub FileViewFill(ByVal Id As Any Ptr, sDir As String, Patterns As String, ByVal Multiple As Long)
	Declare Function GetAttribute(Id As Any Ptr, AttrName As String) As ZString Ptr
	Declare Sub FreePtr(ByVal Ptr_ As Any Ptr)
	Declare Sub PageDraw(Id As Any Ptr, Page As Any Ptr, ByVal x As Integer, ByVal y As Integer, ByVal w As Integer, ByVal h As Integer)
	Declare Sub ReadElementValue(Id As Any Ptr, ByRef Value As WString Ptr)
	Declare Sub SetStringValue(Id As Any Ptr, Value As String)
	Declare Sub SetInnerHTML(Id As Any Ptr, Value As String)
	Declare Sub SetAttribute(Id As Any Ptr, AttrName As String, Value As String)
	Declare Sub SetItemChecked(Id As Any Ptr, ByVal Index As Integer, Value As Boolean)
	Declare Function GetItemChecked(Id As Any Ptr, ByVal Index As Integer) As Boolean
	Declare Sub SetTabs(Id As Any Ptr, Titles As String)
	Declare Sub SetTabsPosition(Id As Any Ptr, ByVal Position As Integer)
	Declare Function TabsStripHeight() As Integer
	Declare Sub SetButtons(Id As Any Ptr, Items As String)
	Declare Function ButtonsItemLeft(Id As Any Ptr, ByVal Index As Integer) As Integer
	Declare Function ButtonsItemWidth(Id As Any Ptr, ByVal Index As Integer) As Integer
	Declare Function ButtonsContentWidth(Id As Any Ptr) As Integer
	Declare Function ElementContentWidth(Id As Any Ptr) As Integer
	Declare Sub LoadURL(Id As Any Ptr, URL As String)
	Declare Sub LoadHTML(Id As Any Ptr, HTML As String)
	Declare Sub WebAction(Id As Any Ptr, ByVal Action As Integer)
	Declare Sub LoadImage(Id As Any Ptr, Path As String, Center As Boolean)
	Declare Sub AddResourceSearchPath(Path As String)
	'The pictures of a .rc file: they are found in the folders of AddResourceSearchPath
	Declare Sub AddResourceFile(ByRef RcFile As String)
	Declare Function FindResourceFile(ResName As String) As String
	Declare Function RemoveMnemonic(ByRef Value As WString) As UString
	Declare Sub ClipboardSetText(Text As String)
	Declare Function ClipboardGetText() As ZString Ptr
	Declare Function ShowPopupMenu(Items As String, ByVal x As Long, ByVal y As Long) As Long
	Declare Function ShowFileDialog(ByVal Mode As Long, Caption As String, InitialDir As String, FileName As String, Filter As String, ByVal FilterIndex As Long) As ZString Ptr
	Declare Function ShowFontDialog(FontName As String, ByVal Size As Long, ByVal Style As Long, ByVal FontColor As Long) As ZString Ptr
	Declare Function ShowColorDialog(Caption As String, ByVal ColorValue As Long) As Long
	Declare Function RegexCompile(Pattern As String, ByVal Flags As Long) As Long
	Declare Function RegexError() As ZString Ptr
	Declare Sub RegexFree(ByVal Id As Long)
	Declare Function RegexExec(ByVal Id As Long, Subject As String, ByVal StartByte As Long, ByVal Offsets As Long Ptr, ByVal MaxGroups As Long) As Long
	Declare Sub TableInit(Id As Any Ptr)
	Declare Sub TableSetView(Id As Any Ptr, ViewName As String)
	Declare Sub TableSetColumns(Id As Any Ptr, Captions As String, Widths As String)
	Declare Sub TableInsertRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableSetRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableRemoveRow(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub TableClear(Id As Any Ptr)
	Declare Sub TableSetIndex(Id As Any Ptr, ByVal Index As Integer)
	Declare Function TableGetIndex(Id As Any Ptr) As Integer
	Declare Sub TableCellRect(Id As Any Ptr, ByVal Row As Long, ByVal Col As Long, ByVal pRect As Any Ptr)
	Declare Function TableDblClick(Id As Any Ptr) As Boolean
	Declare Sub CanvasBegin(Id As Any Ptr)
	Declare Sub CanvasEnd(Id As Any Ptr)
	Declare Sub CanvasRepaint(Id As Any Ptr)
	Declare Sub CanvasNewPath(Id As Any Ptr)
	Declare Sub CanvasMoveTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasLineTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasCurveTo(Id As Any Ptr, ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double, ByVal x3 As Double, ByVal y3 As Double)
	Declare Sub CanvasArc(Id As Any Ptr, ByVal cx As Double, ByVal cy As Double, ByVal r As Double, ByVal a1 As Double, ByVal a2 As Double, ByVal Negative As Integer = 0)
	Declare Sub CanvasRectPath(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasClosePath(Id As Any Ptr)
	Declare Sub CanvasClip(Id As Any Ptr)
	Declare Sub CanvasFill(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasStroke(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer, ByVal LineWidth As Double, Dash As String)
	Declare Sub CanvasFillRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasInvertRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasRotate(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal Angle As Double)
	Declare Sub CanvasSave(Id As Any Ptr)
	Declare Sub CanvasRestore(Id As Any Ptr)
	Declare Sub CanvasText(Id As Any Ptr, ByVal x As Double, ByVal y As Double, Text As String, ByVal iColor As Integer, ByVal iBkColor As Integer, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer)
	Declare Function CanvasTextWidth(Id As Any Ptr, Text As String, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasTextHeight(Id As Any Ptr, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasGetPixel(Id As Any Ptr, ByVal x As Double, ByVal y As Double) As Integer
	Declare Sub CanvasImage(Id As Any Ptr, Path As String, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal Alpha As Integer)
#endif
#ifdef __USE_WASM__
	Declare Function SendHTTPRequest(url As String, method As String, data As String) As ZString Ptr
	Declare Function HtmlEscape(ByVal Value As WString Ptr) As UString
#endif

#ifdef __EXPORT_PROCS__
	#define PublicOrPrivate Public
	#define __EXPORT__ Export
#else
	#define PublicOrPrivate Private
	#define __EXPORT__
#endif

'#define In ,
'#macro Each(iter, arr)
'	index As Integer = LBound(arr) To UBound(arr)
'	#define iter arr(index)
'#endmacro

#define Each(iter, col) __index__ As Integer = 0 To col.Count - 1: Dim As Typeof(col.Item(__index__)) iter = col.Item(__index__)

#define Me This

#ifndef _L
	#ifdef __USE_GTK__
		#define _L Print __LINE__, __FILE__, __FUNCTION__:
	#else
		#define _L Print __LINE__, __FILE__, __FUNCTION__, GetErrorString(GetLastError, , True):
	#endif
#endif

Const HELP_SETPOPUP_POS = &Hd

#macro RedefineClassKeyword
	#undef Class
	#define Class Type
	#define __StartOfClassBody__ End Type
	#macro __EndOfClassBody__
		Scope
		#undef Class
		#macro Class
			Scope
			#undef Class
			#define Class Type
		#endmacro
	#endmacro
#endmacro

'#DEFINE __AUTOMATE_CREATE_CHILDS__

#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
	'Messages sent from the Web/Android/Apple side to Control.ProcessMessage
	#define CM_CHANGE      40030
	#define CM_CLICK       40031
	'The control paints its canvas (Control.PaintCanvas): OnPaint and the drawing of the control
	#define CM_PAINT       40032
	'The items of the control changed (ToolBar, ToolPalette: the buttons are shown again)
	#define CM_ITEMSCHANGED 40033
	'The mouse (Web) / a touch (Android, the left button) over a control which has a mouse event or FMouseEvents:
	'wParam - the button (0 - left, 1 - right, 2 - middle, -1 - none; a moving touch is -1, it points like the mouse),
	'lParam - the point in the pixels of the control: MffPointX(lParam), MffPointY(lParam)
	#define CM_MOUSEDOWN   40034
	#define CM_MOUSEUP     40035
	#define CM_MOUSEMOVE   40036
	#define CM_MOUSELEAVE  40037
	'The keyboard of a control which has a key event or FKeyEvents: wParam - the key code (the codes of Windows: VK_LEFT, VK_DELETE, ...),
	'CM_CHAR: wParam - the Unicode character; lParam - the state: 1 - Shift, 2 - Ctrl, 4 - Alt.
	'Message.Result = 1 (or Handled = True): the key was handled, the browser does not do its own action (Ctrl+S, Tab, ...)
	#define CM_KEYDOWN     40038
	#define CM_KEYUP       40039
	#define CM_CHAR        40040
	'wParam - 1 up, -1 down; lParam - the point like CM_MOUSE*
	#define CM_MOUSEWHEEL  40041
	#define CM_SETFOCUS    40042
	#define CM_KILLFOCUS   40043
	'Control.RequestAlign: the control lays out its own child controls (ReBar: the bands); wParam - the client width, lParam - the client height
	#define CM_SIZE        40044
	'The horizontal mouse wheel (Android: also a drag of a finger in a view which takes the text): wParam - 1 left,
	'-1 right; lParam - the point like CM_MOUSE*
	#define CM_MOUSEHWHEEL 40045
	#define MffPoint(x, y) ((CLng(y) Shl 16) Or (CLng(x) And &hFFFF))
	#define MffPointX(lParam) CShort((lParam) And &hFFFF)
	#define MffPointY(lParam) CShort(((lParam) Shr 16) And &hFFFF)
#endif
#if defined(__USE_WASM__) OrElse defined(__USE_JNI__)
	'Regular expressions of Regex.bas: JavaScript RegExp on the Web, java.util.regex on Android.
	'Flags: 1 - ignore case, 2 - multiline, 4 - dot matches all, 8 - extended. Returns the id of the pattern, 0 on an error
	Declare Function RegexCompile(Pattern As String, ByVal Flags As Long) As Long
	'The message of the last compile error (UTF-8), freed with Deallocate
	Declare Function RegexError() As ZString Ptr
	Declare Sub RegexFree(ByVal Id As Long)
	'Searches Subject (UTF-8) from the byte StartByte. Offsets gets the start and end byte of each group (-1 - the group did not match).
	'Returns the count of the groups (the whole match is the group 0), 0 if nothing was found
	Declare Function RegexExec(ByVal Id As Long, Subject As String, ByVal StartByte As Long, ByVal Offsets As Long Ptr, ByVal MaxGroups As Long) As Long
	'Modal dialogs of Dialogs.bas; all strings are UTF-8, a returned ZString Ptr is freed with Deallocate, 0 - the dialog was cancelled.
	'Mode: 0 - open, 1 - open several files, 2 - save, 3 - folder; Filter as "Text files|*.txt;*.log|All files|*.*".
	'Returns the chosen paths separated with Chr(10)
	Declare Function ShowFileDialog(ByVal Mode As Long, Caption As String, InitialDir As String, FileName As String, Filter As String, ByVal FilterIndex As Long) As ZString Ptr
	#ifdef __USE_WASM__
		'The file list of the file dialog in the element of an OpenFileControl: the folders and the files of Patterns
		'("*.bas;*.bi") in the folder Dir (UTF-8). A change raises CM_CHANGE with the attributes data-event ("select",
		'"activate", "folder"), data-dir and data-files (the chosen files separated with Chr(10))
		Declare Sub FileViewFill(ByVal Id As Any Ptr, Dir As String, Patterns As String, ByVal Multiple As Long)
	#endif
	'Style: 1 - bold, 2 - italic, 4 - underline, 8 - strikeout. Returns "Name" & Chr(10) & Size & Chr(10) & Style & Chr(10) & Color
	Declare Function ShowFontDialog(FontName As String, ByVal Size As Long, ByVal Style As Long, ByVal FontColor As Long) As ZString Ptr
	'Color is BGR (&hBBGGRR). Returns the chosen color, -1 if the dialog was cancelled
	Declare Function ShowColorDialog(Caption As String, ByVal ColorValue As Long) As Long
	'The text of the system clipboard (UTF-8); ClipboardGetText returns a ZString freed with Deallocate (0 - no text)
	Declare Sub ClipboardSetText(Text As String)
	'A popup menu at x, y (the pixels of the page): Items are the lines "Level	Enabled	Checked	Image	Caption" (UTF-8, Level 0 -
	'the items of the menu, 1 - of the item before, ...; the caption "-" is a separator). Returns the index of the chosen line, -1 - none
	Declare Function ShowPopupMenu(Items As String, ByVal x As Long, ByVal y As Long) As Long
	'Waits (ASYNCIFY) until the form Id is closed or hidden (Form.ShowModal), 0 - a wait is already running
	Declare Function ModalWait(Id As Any Ptr) As Long
	'Gives the browser the time to draw the page like emscripten_sleep, nothing while another wait runs (ModalWait)
	Declare Sub PageSleep(ByVal ms As Long)
	'The left (in the element) and the width of the item Index of the buttons of a ToolBar, -1 if there is none
	Declare Function ButtonsItemLeft(Id As Any Ptr, ByVal Index As Integer) As Integer
	Declare Function ButtonsItemWidth(Id As Any Ptr, ByVal Index As Integer) As Integer
	'The width (pixels) which the content of the element needs, 0 if it is not known (hidden)
	Declare Function ElementContentWidth(Id As Any Ptr) As Integer
	'Gives the browser the time to draw the page (ASYNCIFY of emscripten)
	Declare Sub emscripten_sleep cdecl Alias "emscripten_sleep"(ByVal ms As ULong)
	'The bar of the main menu before the main form Id: Captions are the captions of the items, separated by Chr(10)
	'("" - a hidden item, UTF-8). A click on an item calls OnMainMenu (Form.bas)
	Declare Sub SetMainMenu(Id As Any Ptr, Captions As String)
	Declare Function ClipboardGetText() As ZString Ptr
	'The picture ResName.png of a button (ToolBar, ToolPalette): the URLs (relative to the page) of Resources and of the
	'folders of AddResourceSearchPath separated by "|", the browser shows the first one which is there
	Declare Function FindResourceFile(ResName As String) As String
	#ifdef __USE_WASM__
		'The text of a button, a label, ... without the & of the access keys of Windows ("&&" is "&")
		Declare Function RemoveMnemonic(ByRef Value As WString) As UString
		Declare Function HtmlMnemonic(ByVal Value As WString Ptr) As UString
		'The resources of a .rc file ("Name PNG FileName" lines): FindResourceFile of Name gives the URLs of the file
		'(the name of the resource and the one of its file can be different, like PagePanel and Panel.png)
		Declare Sub AddResourceFile(ByRef RcFile As String)
		'The URLs of an icon (Icon.ResName) separated by "|": a file, or a resource of the .rc files of the program
		'(ICON lines) and Resources/ResName.ico, .png
		Declare Function FindIconFile(ByRef ResName As String) As String
	#endif
	Declare Sub AddResourceSearchPath(Path As String)
#endif

#ifdef __USE_WINAPI__
	#define CM_NOTIFYCHILD 39998
	#define CM_CHANGEIMAGE 39999
	#define CM_CTLCOLOR    40000
	#define CM_COMMAND     40001
	#define CM_NOTIFY      40002
	#define CM_HSCROLL     40003
	#define CM_VSCROLL     40004
	#define CM_MEASUREITEM 40005
	#define CM_DRAWITEM    40006
	#define CM_HELPCONTEXT 40007
	#define CM_CANCELMODE  40008
	#define CM_HELP        40010
	#define CM_NEEDTEXT    40011
	#define CM_CREATE      40012
	
	'Dim Shared As Message Message
	
	Declare Function EnumThreadWindowsProc(FWindow As HWND,LData As LPARAM) As BOOL
	
	Declare Function MainHandle As HWND
#elseif defined(__USE_JNI__)
	Dim Shared env         As JNIEnv Ptr
	Dim Shared Instance As jobject
	'The mffActivity object; its helper methods (listInit, listInsert, groupSetTitle, ...) are called from the controls
	Dim Shared Activity As jobject
	Declare Function ActivityMethodID(methodName As String, typeName As String) As jmethodID
	Declare Sub ListInit(Id As Any Ptr)
	Declare Sub AddSelectItem(Id As Any Ptr, Text As String)
	Declare Sub InsertSelectItem(Id As Any Ptr, ByVal Index As Integer, Text As String)
	Declare Sub RemoveSelectItem(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub ClearSelectItems(Id As Any Ptr)
	Declare Function GetSelectedIndex(Id As Any Ptr) As Integer
	Declare Sub SetSelectedIndex(Id As Any Ptr, Value As Integer)
	'Mode: 0 - single choice, 1 - multiple choice (check boxes), 2 - no choice
	Declare Sub SetInnerHTML(Id As Any Ptr, Value As String)
	Declare Sub OpenURL(URL As String)
	Declare Sub ListInitMode(Id As Any Ptr, ByVal Mode As Integer)
	Declare Sub SetItemChecked(Id As Any Ptr, ByVal Index As Integer, Value As Boolean)
	Declare Function GetItemChecked(Id As Any Ptr, ByVal Index As Integer) As Boolean
	Declare Sub SetInnerText(Id As Any Ptr, Value As String)
	Declare Sub SetStringValue(Id As Any Ptr, Value As String)
	Declare Sub ReadElementValue(Id As Any Ptr, ByRef Value As WString Ptr)
	Declare Sub SetRange(Id As Any Ptr, ByVal MinValue As Integer, ByVal MaxValue As Integer)
	Declare Sub SetPosition(Id As Any Ptr, ByVal Value As Integer)
	Declare Function GetPosition(Id As Any Ptr) As Integer
	'ComboBoxEdit.ShowDropDown: the items of the Spinner are shown in a list in its place
	Declare Sub ListShowDropDown(Id As Any Ptr, Value As Boolean)
	'The z-order of the view among its siblings: 1 - over them (BringToFront), 0 - under them (SendToBack)
	Declare Sub ViewZOrder(Id As Any Ptr, ByVal Top As Integer)
	'The title bar and the border of the designed form (the designer of the IDE) above and around its view (in pixels)
	Declare Sub FormDesignFrame(Id As Any Ptr, Title As String, ByVal CaptionHeight As Integer)
	Declare Sub SetTabs(Id As Any Ptr, Titles As String)
	'TabPosition: 0 - left, 1 - right, 2 - top, 3 - bottom (the next SetTabs makes the row of the tabs at that side)
	Declare Sub SetTabsPosition(Id As Any Ptr, ByVal Position As Integer)
	Declare Sub LoadURL(Id As Any Ptr, URL As String)
	Declare Sub LoadHTML(Id As Any Ptr, HTML As String)
	'Action: 0 - back, 1 - forward, 2 - reload, 3 - stop
	Declare Sub WebAction(Id As Any Ptr, ByVal Action As Integer)
	'mffActivity calls the exported mffActivity_onTimer(Id) every Interval milliseconds until StopTimer
	Declare Sub StartTimer(Id As Any Ptr, ByVal Interval As Integer)
	Declare Sub StopTimer(Id As Any Ptr)
	'Asks the view to paint again (after the current message)
	Declare Sub CanvasRepaint(Id As Any Ptr)
	'The touches of the view go to the exported mffActivity_onViewTouch (CM_MOUSE* and the OnMouse* events)
	Declare Sub SetTouchEvent(Id As Any Ptr)
	'The keys of the view go to the native side (onViewKey); TextInput - the view takes the text of the soft keyboard (an MffLayout)
	Declare Sub SetKeyEvent(Id As Any Ptr, TextInput As Boolean)
	'ImageBox, Picture: a picture file (Web: a URL; Android: a file or an asset), stretched or centered
	Declare Sub LoadImage(Id As Any Ptr, Path As String, Center As Boolean)
	'ToolBar: a row of buttons; the items are separated by Chr(10), the first char of an item is a flag:
	'"0" - button, "1" - disabled, "2" - checked, "3" - separator, "4" - hidden. A click raises CM_CHANGE.
	Declare Sub SetButtons(Id As Any Ptr, Items As String)
	'Android: an item can have a picture file after Chr(9) (FindResourceFile)
	'FindResourceFile (the picture file ResName.png of the data files of the program, MFF_APPDIR/Resources, or of a folder
	'of AddResourceSearchPath; "" if there is none), AddResourceSearchPath and ButtonsItemLeft (the left of the item Index
	'of the buttons in the pixels of the view, -1 if it is not known) are declared above for the Web and Android
	'The height of the row of the tabs of a TabControl (SetTabs) in pixels
	Declare Function TabsStripHeight() As Integer
	'The width of the buttons of a ToolBar in pixels (ReBar), -1 - not a ToolBar
	Declare Function ButtonsContentWidth(Id As Any Ptr) As Integer
	'The text of a caption (CommandButton, CheckBox, RadioButton, Label, GroupBox) without the mnemonics of Windows
	Declare Function RemoveMnemonic(ByRef Value As WString) As UString
	'MsgBox: an AlertDialog (mffActivity.messageBox); MessageType and ButtonsType of Application.bi, returns the
	'MessageResult (-1 - an old mffActivity.java without messageBox)
	Declare Function MessageBox(Message As String, Caption As String, MessageType As Integer, ButtonsType As Integer) As Integer
	'The title bar of a second form like the one of a full-screen dialog of Material: the close button and the caption
	'(mffActivity.formTitleBar). Visibility: 1 - shown, 0 - hidden, -1 - only the caption. The height in pixels, 0 - an
	'old mffActivity.java without it
	Declare Function FormTitleBarHeight() As Integer
	Declare Sub FormTitleBar(Id As Any Ptr, Title As String, ByVal Visibility As Integer)
	'Form.Show of a second form: its own activity (mffActivity.FormActivity) with the title and the Up button. False -
	'there is no FormActivity (AndroidManifest.xml, an older mffActivity.java): the form is a full-screen dialog
	Declare Function FormActivityShow(Id As Any Ptr, Title As String) As Boolean
	Declare Sub FormActivityTitle(Id As Any Ptr, Title As String)
	Declare Sub FormActivityHide(Id As Any Ptr)
	'The night mode of the app (AppCompatDelegate, the theme DayNight) at once, SetDarkMode
	Declare Sub SetActivityDarkMode(ByVal Value As Boolean)
	'Ends the process of the program and starts it again (mffActivity.Restart)
	Declare Sub RestartApplication()
	'The views have the colors of the night mode (mffActivity.nightMode: the dark mode of the program or of the system)
	Declare Function ActivityNightMode() As Boolean
	'The view of the form is put again into the layout of its owner (a form of Show was in its own activity before)
	Declare Sub FormAttach(Id As Any Ptr, Parent As Any Ptr)
	'A form of ShowModal over the window of its owner (over the action bar too, mffActivity.formAttachTop): the height
	'of the action bar in pixels (the owner begins there), -1 - the form stays in its owner (FormAttach)
	Declare Function FormAttachTop(Id As Any Ptr, Parent As Any Ptr) As Integer
	'A tablet (the smallest width of the screen is 600dp or more): a modal form is a dialog of its size, not full-screen
	Declare Function FormLargeScreen() As Boolean
	'The style of the main form (Id = 0) or of a second form in its activity: 1 - without the action bar (BorderStyle
	'None), 2 - immersive (WindowState wsMaximized), 4 - the close button instead of Up (BorderStyle FixedDialog)
	Declare Sub FormSetStyle(Id As Any Ptr, ByVal Style As Integer)
	'FormStyle fsStayOnTop: the form is over the other forms in its owner
	Declare Sub FormSetOnTop(Id As Any Ptr, ByVal OnTop As Boolean)
	'WindowState wsMinimized of the main form: the program goes to the background
	Declare Sub ActivityMinimize()
	'Form.ShowModal: a nested message loop until the form is hidden (FormModalEnd)
	Declare Sub FormModalWait(Id As Any Ptr)
	Declare Sub FormModalEnd(Id As Any Ptr)
	'Canvas (My.Sys.Drawing.Canvas) of a control; Id is the control element (Web) / view (Android).
	'The path works like the one of cairo: CanvasFill and CanvasStroke keep it, CanvasNewPath starts a new one.
	'Colors are BGR, Alpha 0..255, angles in radians, Dash e.g. "10,5" ("" is solid).
	Declare Sub CanvasBegin(Id As Any Ptr)
	Declare Sub CanvasEnd(Id As Any Ptr)
	Declare Sub CanvasNewPath(Id As Any Ptr)
	Declare Sub CanvasMoveTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasLineTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasCurveTo(Id As Any Ptr, ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double, ByVal x3 As Double, ByVal y3 As Double)
	Declare Sub CanvasArc(Id As Any Ptr, ByVal cx As Double, ByVal cy As Double, ByVal r As Double, ByVal a1 As Double, ByVal a2 As Double, ByVal Negative As Integer = 0)
	Declare Sub CanvasRectPath(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasClosePath(Id As Any Ptr)
	'The current path becomes the clip of the next drawing (until CanvasRestore of a CanvasSave before it); the path is cleared
	Declare Sub CanvasClip(Id As Any Ptr)
	Declare Sub CanvasFill(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasStroke(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer, ByVal LineWidth As Double, Dash As String)
	Declare Sub CanvasFillRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Integer, ByVal Alpha As Integer)
	'The colors of the pixels are inverted (the caret of Windows: it is seen on a dark background too)
	Declare Sub CanvasInvertRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasSave(Id As Any Ptr)
	Declare Sub CanvasRestore(Id As Any Ptr)
	Declare Sub CanvasText(Id As Any Ptr, ByVal x As Double, ByVal y As Double, Text As String, ByVal iColor As Integer, ByVal iBkColor As Integer, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer)
	Declare Function CanvasTextWidth(Id As Any Ptr, Text As String, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasTextHeight(Id As Any Ptr, FontName As String, ByVal FontSize As Double, ByVal Bold As Integer, ByVal Italic As Integer) As Integer
	Declare Function CanvasGetPixel(Id As Any Ptr, ByVal x As Double, ByVal y As Double) As Integer
	Declare Sub CanvasImage(Id As Any Ptr, Path As String, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal Alpha As Integer)
	'Printing (PrintDocument): a page is an MffPage (mffActivity.java) which records the drawing (a Picture) of
	'PageWidth x PageHeight pixels; the Canvas draws into it with the page as its Handle. PageCreate returns a global reference
	'(0 - an older mffActivity.java without pages), PageDelete frees it
	Declare Function PageCreate(ByVal PageWidth As Integer, ByVal PageHeight As Integer) As Any Ptr
	Declare Sub PageDelete(Page As Any Ptr)
	'The page in the canvas of the view Id at x, y in w x h, on white paper (PrintPreviewControl)
	Declare Sub PageDraw(Id As Any Ptr, Page As Any Ptr, ByVal x As Integer, ByVal y As Integer, ByVal w As Integer, ByVal h As Integer)
	'The print dialog of Android (PrintManager) prints the pages as a PDF; the paper in tenths of a millimeter
	Declare Sub PrintPages(Pages As Any Ptr Ptr, ByVal Count As Integer, Title As String, ByVal PaperWidth As Integer, ByVal PaperHeight As Integer, ByVal Landscape As Boolean)
	'Table view (ListView, TreeListView, GridData): Web - a <table>, Android - a ListView with a row of text per item.
	'Cells are separated by Chr(9), column captions and widths by Chr(10); a click on a row raises CM_CHANGE.
	Declare Sub TableInit(Id As Any Ptr)
	Declare Sub TableSetColumns(Id As Any Ptr, Captions As String, Widths As String)
	Declare Sub TableInsertRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableSetRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableRemoveRow(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub TableClear(Id As Any Ptr)
	Declare Sub TableSetIndex(Id As Any Ptr, ByVal Index As Integer)
	Declare Function TableGetIndex(Id As Any Ptr) As Integer
	'The rectangle of the cell Row, Col (Left, Top, Right, Bottom: Long) in the pixels of the view of the table
	Declare Sub TableCellRect(Id As Any Ptr, ByVal Row As Long, ByVal Col As Long, ByVal pRect As Any Ptr)
	'True when the row was double clicked (Web)
	Declare Function TableDblClick(Id As Any Ptr) As Boolean
	'The file list of an OpenFileControl (mffActivity.MffFileView) like the one of the Web: the folders and the files of
	'Patterns ("*.bas;*.bi") in the folder Folder (UTF-8) in the views "Large icons" and "List". A change raises CM_CHANGE
	Declare Sub FileViewFill(ByVal Id As Any Ptr, Folder As String, Patterns As String, ByVal Multiple As Long)
	'The last change of the file list: the event ("select", "activate", "folder"), the folder and the chosen files, each
	'one in a line (Chr(10), UTF-8)
	Declare Function FileViewState(ByVal Id As Any Ptr) As String
#endif

Namespace ClassContainer
	Private Type ClassType
	Protected:
		FClassName As WString Ptr
		FClassAncestor As WString Ptr
	Public:
		ClassProc As Any Ptr
		Declare Property ClassName ByRef As WString
		Declare Property ClassName(ByRef Value As WString)
		Declare Property ClassAncestor ByRef As WString
		Declare Property ClassAncestor(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
	
	Dim Classes()  As ClassType
	
	Declare Function FindClass(ByRef ClassName As WString) As Integer
	
	Declare Sub StoreClass(ByRef ClassName As WString, ByRef ClassAncestor As WString, ClassProc As Any Ptr)
	
	Declare Function GetClassProc Overload(ByRef ClassName As WString) As Any Ptr
	
	#ifdef __USE_WINAPI__
		Declare Function GetClassProc(FWindow As HWND) As Any Ptr
		
		Declare Function GetClassNameOf(FWindow As HWND) As String
		
		Declare Sub Finalization
	#endif
End Namespace

Using ClassContainer

#ifdef GetMN
	Declare Function GetMessageName(Message As Integer) As String
#endif

Declare Function ErrDescription(Code As Integer) ByRef As WString

Declare Function GetErrorString(ByVal Code As UInteger, ByVal MaxLen  As UShort = 1024, WithCode As Boolean = False) As UString

#ifndef __USE_MAKE__
	#include once "SysUtils.bas"
#endif