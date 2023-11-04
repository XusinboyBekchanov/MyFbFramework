'###############################################################################
'#  mff.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################
'#define __USE_GTK3__
'#ifdef __FB_WIN32__
'	#define Extension dll
'	#define Library mff
'#else
'	#define Extension so
'	#define Library libmff
'#endif
'#ifdef __FB_64BIT__
'	#define Bit3264 64
'#else
'	#define Bit3264 32
'#endif
'#if defined(__USE_GTK__) OrElse Not defined(__FB_WIN32__)
'	#ifdef __USE_GTK3__
'		#define GTKVER "_gtk3"
'	#else
'		#define GTKVER "_gtk2"
'	#endif
'#else
'	#define GTKVER ""
'#endif
'#cmdline __FB_QUOTE__(-x ../##Library##Bit3264##GTKVER.##Extension)
'#cmdline "-x ../" & Prefix & "mff" & Bit3264 & GTKVER & "." & Extension

#define __EXPORT_PROCS__
#define MEMCHECK 0

#include once "Form.bi"
#include once "Animate.bi"
#include once "Application.bi"
#include once "Bitmap.bi"
#include once "Brush.bi"
#include once "Canvas.bi"
#include once "Chart.bi"
#include once "CheckBox.bi"
#include once "CheckedListBox.bi"
#include once "Classes.bi"
#include once "Clipboard.bi"
#include once "ComboBoxEdit.bi"
#include once "ComboBoxEx.bi"
#include once "CommandButton.bi"
#include once "Component.bi"
#include once "ContainerControl.bi"
#include once "Control.bi"
#include once "Cursor.bi"
#include once "DateTimePicker.bi"
#include once "Dialogs.bi"
#include once "Font.bi"
#include once "Graphic.bi"
#include once "Graphics.bi"
#include once "Grid.bi"
#include once "GridData.bi"
#include once "GroupBox.bi"
#include once "GUI.bi"
#include once "Header.bi"
#include once "HorizontalBox.bi"
#include once "HotKey.bi"
#include once "Icon.bi"
#include once "ImageBox.bi"
#include once "ImageList.bi"
#include once "IPAddress.bi"
#include once "IniFile.bi"
#include once "Label.bi"
#include once "LinkLabel.bi"
#include once "List.bi"
#include once "ListControl.bi"
#include once "ListView.bi"
#include once "Menus.bi"
#include once "MonthCalendar.bi"
#include once "NumericUpDown.bi"
#include once "Object.bi"
#include once "OpenFileControl.bi"
#include once "PageScroller.bi"
#include once "PageSetupDialog.bi"
#include once "Panel.bi"
#include once "Pen.bi"
#include once "Picture.bi"
#include once "PrintDialog.bi"
#include once "PrintPreviewDialog.bi"
#include once "Printer.bi"
#include once "ProgressBar.bi"
#include once "RadioButton.bi"
#include once "ReBar.bi"
#include once "RichTextBox.bi"
#include once "ScrollBarControl.bi"
#include once "ScrollControl.bi"
#include once "HScrollBar.bi"
#include once "VScrollBar.bi"
#include once "Splitter.bi"
#include once "StatusBar.bi"
#include once "StringList.bi"
#include once "SysUtils.bi"
#include once "TabControl.bi"
#include once "TextBox.bi"
#include once "TimerComponent.bi"
#include once "ToolBar.bi"
#include once "ToolPalette.bi"
#include once "ToolTips.bi"
#include once "TrackBar.bi"
#include once "TreeListView.bi"
#include once "TreeView.bi"
#include once "UpDown.bi"
#include once "UserControl.bi"
#include once "VerticalBox.bi"
#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
	#include once "WebBrowser.bi"
#endif
#include once "WStringList.bi"

Using My.Sys.Forms

#ifndef __USE_GTK__
	Private Function DllMain(hinstDLL As HINSTANCE, fdwReason As DWORD, lpvReserved As LPVOID) As Boolean
		Select Case fdwReason
		Case DLL_PROCESS_ATTACH
		Case DLL_PROCESS_DETACH
		Case DLL_THREAD_ATTACH
		Case DLL_THREAD_DETACH
		End Select
		Return True
	End Function
#endif

#ifdef __EXPORT_PROCS__
	Dim Shared Objects As List
	Dim Shared Ctrl As Control Ptr
	Function CreateControl Alias "CreateControl" (ByRef ClassName As String, ByRef sName As WString, ByRef Text As WString, lLeft As Integer, lTop As Integer, lWidth As Integer, lHeight As Integer, Parent As Control Ptr) As Control Ptr Export
		Ctrl = 0
		Select Case LCase(ClassName)
		Case "animate": Ctrl = _New( Animate)
		Case "chart": Ctrl = _New( Chart)
		Case "checkbox": Ctrl = _New( CheckBox)
		Case "checkedlistbox": Ctrl = _New( CheckedListBox)
		Case "comboboxedit": Ctrl = _New( ComboBoxEdit)
		Case "comboboxex": Ctrl = _New( ComboBoxEx)
		Case "commandbutton": Ctrl = _New( CommandButton)
		Case "datetimepicker": Ctrl = _New( DateTimePicker)
		Case "form": Ctrl = _New( Form)
		Case "grid": Ctrl = _New( Grid)
		Case "griddata": Ctrl = _New( GridData)
		Case "groupbox": Ctrl = _New( GroupBox)
		Case "header": Ctrl = _New( Header)
		Case "horizontalbox": Ctrl = _New(HorizontalBox)
		Case "hotkey": Ctrl = _New( HotKey)
		Case "ipaddress": Ctrl = _New( IPAddress)
		Case "imagebox": Ctrl = _New( ImageBox)
		Case "label": Ctrl = _New( Label)
		Case "linklabel": Ctrl = _New( LinkLabel)
		Case "listcontrol": Ctrl = _New( ListControl)
		Case "listview": Ctrl = _New( ListView)
		Case "monthcalendar": Ctrl = _New( MonthCalendar)
		Case "numericupdown": Ctrl = _New(NumericUpDown)
		Case "openfilecontrol": Ctrl = _New( OpenFileControl)
		Case "pagescroller": Ctrl = _New( PageScroller)
		Case "panel": Ctrl = _New( Panel)
		Case "picture": Ctrl = _New( Picture)
		Case "progressbar": Ctrl = _New( ProgressBar)
		Case "radiobutton": Ctrl = _New( RadioButton)
		Case "rebar": Ctrl = _New( ReBar)
		Case "richtextbox": Ctrl = _New( RichTextBox)
		Case "tabcontrol": Ctrl = _New( TabControl)
		Case "tabpage": Ctrl = _New( TabPage)
		Case "scrollbarcontrol": Ctrl = _New( ScrollBarControl)
		Case "scrollcontrol": Ctrl = _New(ScrollControl)
		Case "hscrollbar": Ctrl = _New( HScrollBar)
		Case "vscrollbar": Ctrl = _New( VScrollBar)
		Case "splitter": Ctrl = _New( Splitter)
		Case "statusbar": Ctrl = _New( StatusBar)
		Case "textbox": Ctrl = _New( TextBox)
		Case "toolbar": Ctrl = _New( ToolBar)
		Case "toolpalette": Ctrl = _New( ToolPalette)
		Case "trackbar": Ctrl = _New( TrackBar)
		Case "treelistview": Ctrl = _New( TreeListView)
		Case "treeview": Ctrl = _New( TreeView)
		Case "updown": Ctrl = _New( UpDown)
		Case "usercontrol": Ctrl = _New( UserControl)
		Case "verticalbox": Ctrl = _New( VerticalBox)
		#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
			Case "webbrowser": Ctrl = _New(WebBrowser)
		#endif
		End Select
		If Ctrl Then
			Ctrl->Name = sName
			#ifndef WriteProperty_Off
				Ctrl->WriteProperty("Text", @Text)
			#endif
			Ctrl->SetBounds lLeft, lTop, lWidth, lHeight
			#ifndef WriteProperty_Off
				Ctrl->WriteProperty("Parent", Parent)
			#endif
			If Not Objects.Contains(Ctrl) Then Objects.Add Ctrl
		EndIf
		Return Ctrl
	End Function
	
	Dim Shared Cpnt As Component Ptr
	Function CreateComponent Alias "CreateComponent" (ByRef ClassName As String, ByRef sName As WString, lLeft As Integer, lTop As Integer, Parent As Control Ptr) As Component Ptr Export
		Cpnt = 0
		Select Case LCase(ClassName)
		Case "imagelist": Cpnt = _New( ImageList)
		Case "timercomponent": Cpnt = _New( TimerComponent)
		Case "tooltips": Cpnt = _New( ToolTips)
		Case "mainmenu": Cpnt = _New( MainMenu)
		Case "popupmenu": Cpnt = _New( PopupMenu)
		Case "colordialog": Cpnt = _New( ColorDialog)
		Case "folderbrowserdialog": Cpnt = _New( FolderBrowserDialog)
		Case "fontdialog": Cpnt = _New( FontDialog)
		Case "openfiledialog": Cpnt = _New( OpenFileDialog)
		Case "savefiledialog": Cpnt = _New( SaveFileDialog)
		Case "pagesetupdialog": Cpnt = _New( PageSetupDialog)
		Case "printdialog": Cpnt = _New( PrintDialog)
		Case "printpreviewdialog": Cpnt = _New( PrintPreviewDialog)
		Case "printer": Cpnt = _New( Printer)
		Case Else: Cpnt = CreateControl(ClassName, sName, sName, lLeft, lTop, 10, 10, Parent)
		End Select
		If Cpnt Then
			Cpnt->Name = sName
			Cpnt->Left = lLeft
			Cpnt->Top = lTop
			#ifndef WriteProperty_Off
				Cpnt->WriteProperty("Parent", Parent)
			#endif
			If Not Objects.Contains(Cpnt) Then Objects.Add Cpnt
		EndIf
		Return Cpnt
	End Function
	
	Dim Shared Obj As My.Sys.Object Ptr
	Function CreateObject Alias "CreateObject"(ByRef ClassName As String) As Object Ptr Export
		Obj = 0
		Select Case LCase(ClassName)
		Case "bitmaptype": Obj = _New( My.Sys.Drawing.BitmapType)
		Case "menuitem": Obj = _New( MenuItem)
		Case "statuspanel": Obj = _New( StatusPanel)
		Case "toolbutton": Obj = _New( ToolButton)
		Case Else: Obj = CreateComponent(ClassName, "", 0, 0, 0)
		End Select
		If Obj Then
			If Not Objects.Contains(Obj) Then Objects.Add Obj
		End If
		Return Obj
	End Function
	
	Dim Shared bNotRemoveObject As Boolean
	Function DeleteComponent Alias "DeleteComponent"(Ctrl As Any Ptr) As Boolean Export
		If Ctrl = 0 Then Return False
		Select Case LCase(Cast(Component Ptr, Ctrl)->ClassName)
		Case "animate": _Delete( Cast(Animate Ptr, Ctrl))
		Case "chart": _Delete( Cast(Chart Ptr, Ctrl))
		Case "checkbox" :_Delete( Cast(CheckBox Ptr, Ctrl))
		Case "checkedlistbox": _Delete( Cast(CheckedListBox Ptr, Ctrl))
		Case "comboboxedit": _Delete( Cast(ComboBoxEdit Ptr, Ctrl))
		Case "comboboxex": _Delete( Cast(ComboBoxEx Ptr, Ctrl))
		Case "commandbutton": _Delete( Cast(CommandButton Ptr, Ctrl))
		Case "datetimepicker": _Delete( Cast(DateTimePicker Ptr, Ctrl))
		Case "form": _Delete( Cast(Form Ptr, Ctrl))
		Case "grid": _Delete( Cast(Grid Ptr, Ctrl))
		Case "griddata": _Delete( Cast(GridData Ptr, Ctrl))
		Case "groupbox": _Delete( Cast(GroupBox Ptr, Ctrl))
		Case "header": _Delete( Cast(Header Ptr, Ctrl))
		Case "hotkey": _Delete( Cast(HotKey Ptr, Ctrl))
		Case "horizontalbox": _Delete(Cast(HorizontalBox Ptr, Ctrl))
		Case "ipaddress": _Delete( Cast(IPAddress Ptr, Ctrl))
		Case "imagebox": _Delete( Cast(ImageBox Ptr, Ctrl))
		Case "label": _Delete( Cast(Label Ptr, Ctrl))
		Case "linklabel": _Delete( Cast(LinkLabel Ptr, Ctrl))
		Case "listcontrol": _Delete( Cast(ListControl Ptr, Ctrl))
		Case "listview": _Delete( Cast(ListView Ptr, Ctrl))
		Case "monthcalendar": _Delete( Cast(MonthCalendar Ptr, Ctrl))
		Case "numericupdown": _Delete( Cast(NumericUpDown Ptr, Ctrl))
		Case "pagescroller": _Delete( Cast(PageScroller Ptr, Ctrl))
		Case "pagesetupdialog": _Delete( Cast(PageSetupDialog Ptr, Ctrl))
		Case "printdialog": _Delete( Cast(PrintDialog Ptr, Ctrl))
		Case "printpreviewdialog": _Delete( Cast(PrintPreviewDialog Ptr, Ctrl))
		Case "printer": _Delete( Cast(Printer Ptr, Ctrl))
		Case "openfilecontrol": _Delete( Cast(OpenFileControl Ptr, Ctrl))
		Case "panel": _Delete( Cast(Panel Ptr, Ctrl))
		Case "picture": _Delete( Cast(Picture Ptr, Ctrl))
		Case "progressbar": _Delete( Cast(ProgressBar Ptr, Ctrl))
		Case "radiobutton": _Delete( Cast(RadioButton Ptr, Ctrl))
		Case "rebar": _Delete( Cast(ReBar Ptr, Ctrl))
		Case "richtextbox": _Delete( Cast(RichTextBox Ptr, Ctrl))
		Case "tabcontrol": _Delete( Cast(TabControl Ptr, Ctrl))
		Case "tabpage": _Delete( Cast(TabPage Ptr, Ctrl))
		Case "scrollbarcontrol": _Delete( Cast(ScrollBarControl Ptr, Ctrl))
		Case "scrollcontrol": _Delete( Cast(ScrollControl Ptr, Ctrl))
		Case "hscrollbar": _Delete( Cast(HScrollBar Ptr, Ctrl))
		Case "vscrollbar": _Delete( Cast(VScrollBar Ptr, Ctrl))
		Case "splitter": _Delete( Cast(Splitter Ptr, Ctrl))
		Case "statusbar": _Delete( Cast(StatusBar Ptr, Ctrl))
		Case "textbox": _Delete( Cast(TextBox Ptr, Ctrl))
		Case "toolbar": _Delete( Cast(ToolBar Ptr, Ctrl))
		Case "toolpalette": _Delete( Cast(ToolPalette Ptr, Ctrl))
		Case "tooltips": _Delete( Cast(ToolTips Ptr, Ctrl))
		Case "trackbar": _Delete( Cast(TrackBar Ptr, Ctrl))
		Case "treelistview": _Delete( Cast(TreeListView Ptr, Ctrl))
		Case "treeview": _Delete( Cast(TreeView Ptr, Ctrl))
		Case "updown": _Delete( Cast(UpDown Ptr, Ctrl))
		Case "usercontrol": _Delete( Cast(UserControl Ptr, Ctrl))
		Case "imagelist": _Delete( Cast(ImageList Ptr, Ctrl))
		Case "timercomponent": _Delete( Cast(TimerComponent Ptr, Ctrl))
		Case "mainmenu": _Delete( Cast(MainMenu Ptr, Ctrl))
		Case "popupmenu": _Delete( Cast(PopupMenu Ptr, Ctrl))
		Case "folderbrowserdialog": _Delete( Cast(FolderBrowserDialog Ptr, Ctrl))
		Case "colordialog": _Delete( Cast(ColorDialog Ptr, Ctrl))
		Case "fontdialog": _Delete( Cast(FontDialog Ptr, Ctrl))
		Case "openfiledialog": _Delete( Cast(OpenFileDialog Ptr, Ctrl))
		Case "savefiledialog": _Delete( Cast(SaveFileDialog Ptr, Ctrl))
		Case "verticalbox": _Delete( Cast(VerticalBox Ptr, Ctrl))
		#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
			Case "webbrowser": _Delete( Cast(WebBrowser Ptr, Ctrl))
		#endif
		Case Else: Return False
		End Select
		If bNotRemoveObject = False Then 
			If Objects.Contains(Ctrl) Then
				Objects.Remove Objects.IndexOf(Ctrl)
			End If
		End If
		Return True
	End Function
	
	Function ObjectDelete Alias "ObjectDelete"(Obj As Any Ptr) As Boolean Export
		If Obj = 0 Then Return False
 		Select Case LCase(Cast(My.Sys.Object Ptr, Obj)->ClassName)
		Case "bitmaptype": _Delete( Cast(My.Sys.Drawing.BitmapType Ptr, Obj))
		Case "menuitem": _Delete( Cast(MenuItem Ptr, Obj))
		Case "statuspanel": _Delete( Cast(StatusPanel Ptr, Obj))
		Case "toolbutton": _Delete( Cast(ToolButton Ptr, Obj))
		Case Else: Return DeleteComponent(Obj)
		End Select
		If bNotRemoveObject = False Then
			If Objects.Contains(Obj) Then
				Objects.Remove Objects.IndexOf(Obj)
			End If
		End If
		Return True
	End Function
	
	Function DeleteAllObjects Alias "DeleteAllObjects"() As Boolean Export
		bNotRemoveObject = True
		For i As Integer = 0 To Objects.Count - 1
			ObjectDelete(Objects.Item(i))
		Next
		Objects.Clear
		bNotRemoveObject = False
		Return True
	End Function
	
	#ifndef ShowPropertyPage_Off
		Function ShowPropertyPage Alias "ShowPropertyPage"(Ctrl As Any Ptr) As Boolean Export
			If Objects.Contains(Ctrl) Then
				Cpnt = Objects.Item(Objects.IndexOf(Ctrl))
			Else
				Return False
			End If
			If Cpnt = 0 Then Return False
			Select Case LCase(Cpnt->ClassName)
			Case "imagelist":
			End Select
			Return True
		End Function
	#endif
#endif

'#IfNDef __USE_MAKE__
'	#Include Once "mff.bas"
'#EndIf
