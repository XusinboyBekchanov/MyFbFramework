'###############################################################################
'#  mff.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################
#define __USE_GTK3__
#define __EXPORT_PROCS__
#define MEMCHECK 0

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
#include once "Form.bi"
#include once "Graphic.bi"
#include once "Graphics.bi"
#include once "Grid.bi"
#include once "GroupBox.bi"
#include once "GUI.bi"
#include once "Header.bi"
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
#include once "ListItems.bi"
#include once "ListView.bi"
#include once "Menus.bi"
#include once "MonthCalendar.bi"
#include once "NativeFontControl.bi"
#include once "Object.bi"
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
#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
	#include once "WebBrowser.bi"
#endif
#include once "WStringList.bi"

Using My.Sys.Forms

#ifndef __USE_GTK__
	Function DllMain(hinstDLL As HINSTANCE, fdwReason As DWORD, lpvReserved As LPVOID) As Boolean
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
	Common Shared Ctrl As Control Ptr
	Function CreateControl Alias "CreateControl"(ByRef ClassName As String, ByRef sName As WString, ByRef Text As WString, lLeft As Integer, lTop As Integer, lWidth As Integer, lHeight As Integer, Parent As Control Ptr) As Control Ptr Export
		Ctrl = 0
		Select Case LCase(ClassName)
		Case "animate": Ctrl = New_( Animate)
		Case "chart": Ctrl = New_( Chart)
		Case "checkbox": Ctrl = New_( CheckBox)
		Case "checkedlistbox": Ctrl = New_( CheckedListBox)
		Case "comboboxedit": Ctrl = New_( ComboBoxEdit)
		Case "comboboxex": Ctrl = New_( ComboBoxEx)
		Case "commandbutton": Ctrl = New_( CommandButton)
		Case "datetimepicker": Ctrl = New_( DateTimePicker)
		Case "form": Ctrl = New_( Form)
		Case "grid": Ctrl = New_( Grid)
		Case "groupbox": Ctrl = New_( GroupBox)
		Case "header": Ctrl = New_( Header)
		Case "hotkey": Ctrl = New_( HotKey)
		Case "ipaddress": Ctrl = New_( IPAddress)
		Case "imagebox": Ctrl = New_( ImageBox)
		Case "label": Ctrl = New_( Label)
		Case "linklabel": Ctrl = New_( LinkLabel)
		Case "listcontrol": Ctrl = New_( ListControl)
		Case "listview": Ctrl = New_( ListView)
		Case "monthcalendar": Ctrl = New_( MonthCalendar)
		Case "nativefontcontrol": Ctrl = New_( NativeFontControl)
		Case "pagescroller": Ctrl = New_( PageScroller)
		Case "panel": Ctrl = New_( Panel)
		Case "picture": Ctrl = New_( Picture)
		Case "progressbar": Ctrl = New_( ProgressBar)
		Case "radiobutton": Ctrl = New_( RadioButton)
		Case "rebar": Ctrl = New_( ReBar)
		Case "richtextbox": Ctrl = New_( RichTextBox)
		Case "tabcontrol": Ctrl = New_( TabControl)
		Case "tabpage": Ctrl = New_( TabPage)
		Case "scrollbarcontrol": Ctrl = New_( ScrollBarControl)
		Case "hscrollbar": Ctrl = New_( HScrollBar)
		Case "vscrollbar": Ctrl = New_( VScrollBar)
		Case "splitter": Ctrl = New_( Splitter)
		Case "statusbar": Ctrl = New_( StatusBar)
		Case "textbox": Ctrl = New_( TextBox)
		Case "toolbar": Ctrl = New_( ToolBar)
		Case "toolpalette": Ctrl = New_( ToolPalette)
		Case "trackbar": Ctrl = New_( TrackBar)
		Case "treelistview": Ctrl = New_( TreeListView)
		Case "treeview": Ctrl = New_( TreeView)
		Case "updown": Ctrl = New_( UpDown)
		Case "usercontrol": Ctrl = New_( UserControl)
		#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
			Case "webbrowser": Ctrl = New_(WebBrowser)
		#endif
		End Select
		If Ctrl Then
			Ctrl->Name = sName
			Ctrl->WriteProperty("Text", @Text)
			Ctrl->SetBounds lLeft, lTop, lWidth, lHeight
			Ctrl->WriteProperty("Parent", Parent)
			Objects.Add Ctrl
		EndIf
		Return Ctrl
	End Function
	
	Common Shared Cpnt As Component Ptr
	Function CreateComponent Alias "CreateComponent"(ByRef ClassName As String, ByRef sName As WString, lLeft As Integer, lTop As Integer, Parent As Control Ptr) As Component Ptr Export
		Cpnt = 0
		Select Case LCase(ClassName)
		Case "imagelist": Cpnt = New_( ImageList)
		Case "timercomponent": Cpnt = New_( TimerComponent)
		Case "tooltips": Cpnt = New_( ToolTips)
		Case "mainmenu": Cpnt = New_( MainMenu)
		Case "popupmenu": Cpnt = New_( PopUpMenu)
		Case "colordialog": Cpnt = New_( ColorDialog)
		Case "folderbrowserdialog": Cpnt = New_( FolderBrowserDialog)
		Case "fontdialog": Cpnt = New_( FontDialog)
		Case "openfiledialog": Cpnt = New_( OpenFileDialog)
		Case "savefiledialog": Cpnt = New_( SaveFileDialog)
		Case "pagesetupdialog": Cpnt = New_( PageSetupDialog)
		Case "printdialog": Cpnt = New_( PrintDialog)
		Case "printpreviewdialog": Cpnt = New_( PrintPreviewDialog)
		Case "printer": Cpnt = New_( Printer)
		Case Else: Cpnt = CreateControl(ClassName, sName, sName, lLeft, lTop, 10, 10, Parent)
		End Select
		If Cpnt Then
			Cpnt->Name = sName
			Cpnt->Left = lLeft
			Cpnt->Top = lTop
			Cpnt->WriteProperty("Parent", Parent)
			Objects.Add Cpnt
		EndIf
		Return Cpnt
	End Function
	
	Common Shared Obj As My.Sys.Object Ptr
	Function CreateObject Alias "CreateObject"(ByRef ClassName As String) As Object Ptr Export
		Obj = 0
		Select Case LCase(ClassName)
		Case "menuitem": Obj = New_( MenuItem)
		Case "toolbutton": Obj = New_( ToolButton)
		Case "bitmaptype": Obj = New_( My.Sys.Drawing.BitmapType)
		Case Else: Obj = CreateComponent(ClassName, "", 0, 0, 0)
		End Select
		Objects.Add Obj
		Return Obj
	End Function
	
	Common Shared bNotRemoveObject As Boolean
	Function DeleteComponent Alias "DeleteComponent"(Ctrl As Any Ptr) As Boolean Export
		Select Case LCase(Cast(Component Ptr, Ctrl)->ClassName)
		Case "animate": Delete_( Cast(Animate Ptr, Ctrl))
		Case "chart": Delete_( Cast(Chart Ptr, Ctrl))
		Case "checkbox" :Delete_( Cast(CheckBox Ptr, Ctrl))
		Case "checkedlistbox": Delete_( Cast(CheckedListBox Ptr, Ctrl))
		Case "comboboxedit": Delete_( Cast(ComboBoxEdit Ptr, Ctrl))
		Case "comboboxex": Delete_( Cast(ComboBoxEx Ptr, Ctrl))
		Case "commandbutton": Delete_( Cast(CommandButton Ptr, Ctrl))
		Case "datetimepicker": Delete_( Cast(DateTimePicker Ptr, Ctrl))
		Case "form": Delete_( Cast(Form Ptr, Ctrl))
		Case "grid": Delete_( Cast(Grid Ptr, Ctrl))
		Case "groupbox": Delete_( Cast(GroupBox Ptr, Ctrl))
		Case "header": Delete_( Cast(Header Ptr, Ctrl))
		Case "hotkey": Delete_( Cast(HotKey Ptr, Ctrl))
		Case "ipaddress": Delete_( Cast(IPAddress Ptr, Ctrl))
		Case "imagebox": Delete_( Cast(ImageBox Ptr, Ctrl))
		Case "label": Delete_( Cast(Label Ptr, Ctrl))
		Case "linklabel": Delete_( Cast(LinkLabel Ptr, Ctrl))
		Case "listcontrol": Delete_( Cast(ListControl Ptr, Ctrl))
		Case "listview": Delete_( Cast(ListView Ptr, Ctrl))
		Case "monthcalendar": Delete_( Cast(MonthCalendar Ptr, Ctrl))
		Case "nativefontcontrol": Delete_( Cast(NativeFontControl Ptr, Ctrl))
		Case "pagescroller": Delete_( Cast(PageScroller Ptr, Ctrl))
		Case "pagesetupdialog": Delete_( Cast(PageSetupDialog Ptr, Ctrl))
		Case "printdialog": Delete_( Cast(PrintDialog Ptr, Ctrl))
		Case "printpreviewdialog": Delete_( Cast(PrintPreviewDialog Ptr, Ctrl))
		Case "printer": Delete_( Cast(Printer Ptr, Ctrl))
		Case "panel": Delete_( Cast(Panel Ptr, Ctrl))
		Case "picture": Delete_( Cast(Picture Ptr, Ctrl))
		Case "progressbar": Delete_( Cast(ProgressBar Ptr, Ctrl))
		Case "radiobutton": Delete_( Cast(RadioButton Ptr, Ctrl))
		Case "rebar": Delete_( Cast(ReBar Ptr, Ctrl))
		Case "richtextbox": Delete_( Cast(RichTextBox Ptr, Ctrl))
		Case "tabcontrol": Delete_( Cast(TabControl Ptr, Ctrl))
		Case "tabpage": Delete_( Cast(TabPage Ptr, Ctrl))
		Case "scrollbarcontrol": Delete_( Cast(ScrollBarControl Ptr, Ctrl))
		Case "hscrollbar": Delete_( Cast(HScrollBar Ptr, Ctrl))
		Case "vscrollbar": Delete_( Cast(VScrollBar Ptr, Ctrl))
		Case "splitter": Delete_( Cast(Splitter Ptr, Ctrl))
		Case "statusbar": Delete_( Cast(StatusBar Ptr, Ctrl))
		Case "textbox": Delete_( Cast(TextBox Ptr, Ctrl))
		Case "toolbar": Delete_( Cast(ToolBar Ptr, Ctrl))
		Case "toolpalette": Delete_( Cast(ToolPalette Ptr, Ctrl))
		Case "tooltips": Delete_( Cast(ToolTips Ptr, Ctrl))
		Case "trackbar": Delete_( Cast(TrackBar Ptr, Ctrl))
		Case "treelistview": Delete_( Cast(TreeListView Ptr, Ctrl))
		Case "treeview": Delete_( Cast(TreeView Ptr, Ctrl))
		Case "updown": Delete_( Cast(UpDown Ptr, Ctrl))
		Case "usercontrol": Delete_( Cast(UserControl Ptr, Ctrl))
		Case "imagelist": Delete_( Cast(ImageList Ptr, Ctrl))
		Case "timercomponent": Delete_( Cast(TimerComponent Ptr, Ctrl))
		Case "mainmenu": Delete_( Cast(MainMenu Ptr, Ctrl))
		Case "popupmenu": Delete_( Cast(PopUpMenu Ptr, Ctrl))
		Case "folderbrowserdialog": Delete_( Cast(FolderBrowserDialog Ptr, Ctrl))
		Case "colordialog": Delete_( Cast(ColorDialog Ptr, Ctrl))
		Case "fontdialog": Delete_( Cast(FontDialog Ptr, Ctrl))
		Case "openfiledialog": Delete_( Cast(OpenFileDialog Ptr, Ctrl))
		Case "savefiledialog": Delete_( Cast(SaveFileDialog Ptr, Ctrl))
		#if defined(__USE_WEBKITGTK__) Or Not defined(__USE_GTK__)
			Case "webbrowser": Delete_( Cast(WebBrowser Ptr, Ctrl))
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
		Select Case LCase(Cast(My.Sys.Object Ptr, Obj)->ClassName)
		Case "toolbutton": Delete_( Cast(ToolButton Ptr, Obj))
		Case "menuitem": Delete_( Cast(MenuItem Ptr, Obj))
		Case "bitmaptype": Delete_( Cast(My.Sys.Drawing.BitmapType Ptr, Obj))
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
			Select Case LCase(cpnt->ClassName)
			Case "imagelist":
			End Select
			Return True
		End Function
	#endif
#endif

'#IfNDef __USE_MAKE__
'	#Include Once "mff.bas"
'#EndIf
