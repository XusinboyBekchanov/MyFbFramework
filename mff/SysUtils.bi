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

#if defined(__FB_WIN32__) OrElse defined(__USE_WINAPI__)
    #define UNICODE
    #include once "windows.bi"
#else
    ' POSIX / Unix-like platforms
    #if defined(__FB_LINUX__) OrElse defined(__FB_MACOSX__) OrElse defined(__FB_FREEBSD__) OrElse defined(__FB_OPENBSD__) OrElse defined(__FB_NETBSD__) OrElse defined(__FB_SOLARIS__)
        Extern "C"
            Declare Function clock_gettime Alias "clock_gettime" _
                (ByVal clk_id As Integer, ByVal tp As timespec Ptr) As Integer
        End Extern
    #endif
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
#elseif defined(__USE_WASM__)
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
	Declare Function TimerHiRes() As Double
	Declare Sub AddColumn(Id As Any Ptr, Caption As String)
	Declare Sub AddRow(Id As Any Ptr, Text As String)
	Declare Sub AddSelectItem(Id As Any Ptr, Text As String)
	Declare Function GetDocumentWidth() As Integer
	Declare Function GetDocumentHeight() As Integer
	Declare Sub InsertHTML(Value As String)
	Declare Sub SetTitle(Value As String)
	Declare Sub FreePtr(Ptr As Any Ptr)
	Declare Sub SetVisibleByStringId(Id As String, Value As Boolean)
	Declare Sub SetVisible(Id As Any Ptr, Value As Boolean)
	Declare Sub ElementSetBounds(Id As Any Ptr, ByVal iLeft As Integer, ByVal iTop As Integer, ByVal iWidth As Integer, ByVal iHeight As Integer)
	Declare Sub ElementSetEnabled(Id As Any Ptr, Value As Boolean)
	Declare Sub ElementSetFocus(Id As Any Ptr)
	Declare Sub SetInnerText(Id As Any Ptr, Value As String)
	Declare Sub SetInnerTextByStringId(Id As String, Value As String)
	Declare Sub InsertSelectItem(Id As Any Ptr, ByVal Index As Integer, Text As String)
	Declare Sub RemoveSelectItem(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub ClearSelectItems(Id As Any Ptr)
	Declare Sub SetMultiple(Id As Any Ptr, Value As Boolean)
	Declare Sub SetSize(Id As Any Ptr, Value As Integer)
	Declare Function GetSelectedIndex(Id As Any Ptr) As Integer
	Declare Sub SetSelectedIndex(Id As Any Ptr, Value As Integer)
	Declare Sub CreateElement(AddPosition As String, ClassName As String, Class As String, Type As String, Id As Any Ptr, Name As String, Text As String, Style As String, PositionType As String, Left As String, Top As String, Width As String, Height As String, Right As String, Bottom As String, Parent As Any Ptr)
	Declare Sub DeleteElement(Id As Any Ptr)
	Declare Function GetStringValue(Id As Any Ptr) As ZString Ptr
	Declare Sub ReadElementValue(Id As Any Ptr, ByRef Value As WString Ptr)
	Declare Sub SetStringValue(Id As Any Ptr, Value As String)
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
	Declare Sub CanvasBegin(Id As Any Ptr)
	Declare Sub CanvasEnd(Id As Any Ptr)
	Declare Sub CanvasNewPath(Id As Any Ptr)
	Declare Sub CanvasMoveTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasLineTo(Id As Any Ptr, ByVal x As Double, ByVal y As Double)
	Declare Sub CanvasCurveTo(Id As Any Ptr, ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double, ByVal x3 As Double, ByVal y3 As Double)
	Declare Sub CanvasArc(Id As Any Ptr, ByVal cx As Double, ByVal cy As Double, ByVal r As Double, ByVal a1 As Double, ByVal a2 As Double, ByVal Negative As Integer = 0)
	Declare Sub CanvasRectPath(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double)
	Declare Sub CanvasClosePath(Id As Any Ptr)
	Declare Sub CanvasFill(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasStroke(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer, ByVal LineWidth As Double, Dash As String)
	Declare Sub CanvasFillRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Integer, ByVal Alpha As Integer)
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
	Declare Sub TableSetColumns(Id As Any Ptr, Captions As String, Widths As String)
	Declare Sub TableInsertRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableSetRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableRemoveRow(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub TableClear(Id As Any Ptr)
	Declare Sub TableSetIndex(Id As Any Ptr, ByVal Index As Integer)
	Declare Function TableGetIndex(Id As Any Ptr) As Integer
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

#if defined(__USE_WASM__) OrElse defined(__USE_JNI__)
	'Messages sent from the Web/Android side to Control.ProcessMessage
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
	#define MffPoint(x, y) ((CLng(y) Shl 16) Or (CLng(x) And &hFFFF))
	#define MffPointX(lParam) CShort((lParam) And &hFFFF)
	#define MffPointY(lParam) CShort(((lParam) Shr 16) And &hFFFF)
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
	Declare Sub SetTabs(Id As Any Ptr, Titles As String)
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
	'ImageBox, Picture: a picture file (Web: a URL; Android: a file or an asset), stretched or centered
	Declare Sub LoadImage(Id As Any Ptr, Path As String, Center As Boolean)
	'ToolBar: a row of buttons; the items are separated by Chr(10), the first char of an item is a flag:
	'"0" - button, "1" - disabled, "2" - checked, "3" - separator, "4" - hidden. A click raises CM_CHANGE.
	Declare Sub SetButtons(Id As Any Ptr, Items As String)
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
	Declare Sub CanvasFill(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer)
	Declare Sub CanvasStroke(Id As Any Ptr, ByVal iColor As Integer, ByVal Alpha As Integer, ByVal LineWidth As Double, Dash As String)
	Declare Sub CanvasFillRect(Id As Any Ptr, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, ByVal iColor As Integer, ByVal Alpha As Integer)
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
	Declare Sub TableSetColumns(Id As Any Ptr, Captions As String, Widths As String)
	Declare Sub TableInsertRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableSetRow(Id As Any Ptr, ByVal Index As Integer, Cells As String)
	Declare Sub TableRemoveRow(Id As Any Ptr, ByVal Index As Integer)
	Declare Sub TableClear(Id As Any Ptr)
	Declare Sub TableSetIndex(Id As Any Ptr, ByVal Index As Integer)
	Declare Function TableGetIndex(Id As Any Ptr) As Integer
	'True when the row was double clicked (Web)
	Declare Function TableDblClick(Id As Any Ptr) As Boolean
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