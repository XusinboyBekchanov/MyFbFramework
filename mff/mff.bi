'###############################################################################
'#  mff.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################
#define __USE_GTK3__
#define __EXPORT_PROCS__

#include once "Animate.bi"
#include once "Application.bi"
#include once "Bitmap.bi"
#include once "Brush.bi"
#include once "Canvas.bi"
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
#include once "TabControl.bi"
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
		Case "animate": Ctrl = New Animate
		Case "checkbox": Ctrl = New CheckBox
		Case "checkedlistbox": Ctrl = New CheckedListBox
		Case "comboboxedit": Ctrl = New ComboBoxEdit
		Case "comboboxex": Ctrl = New ComboBoxEx
		Case "commandbutton": Ctrl = New CommandButton
		Case "datetimepicker": Ctrl = New DateTimePicker
		Case "form": Ctrl = New Form
		Case "grid": Ctrl = New Grid
		Case "groupbox": Ctrl = New GroupBox
		Case "header": Ctrl = New Header
		Case "hotkey": Ctrl = New HotKey
		Case "ipaddress": Ctrl = New IPAddress
		Case "imagebox": Ctrl = New ImageBox
		Case "label": Ctrl = New Label
		Case "linklabel": Ctrl = New LinkLabel
		Case "listcontrol": Ctrl = New ListControl
		Case "listview": Ctrl = New ListView
		Case "monthcalendar": Ctrl = New MonthCalendar
		Case "nativefontcontrol": Ctrl = New NativeFontControl
		Case "pagescroller": Ctrl = New PageScroller
		Case "panel": Ctrl = New Panel
		Case "picture": Ctrl = New Picture
		Case "progressbar": Ctrl = New ProgressBar
		Case "radiobutton": Ctrl = New RadioButton
		Case "rebar": Ctrl = New ReBar
		Case "richtextbox": Ctrl = New RichTextBox
		Case "tabcontrol": Ctrl = New TabControl
		Case "tabpage": Ctrl = New TabPage
		Case "scrollbarcontrol": Ctrl = New ScrollBarControl
		Case "hscrollbar": Ctrl = New HScrollBar
		Case "vscrollbar": Ctrl = New VScrollBar
		Case "splitter": Ctrl = New Splitter
		Case "statusbar": Ctrl = New StatusBar
		Case "tabcontrol": Ctrl = New TabControl
		Case "textbox": Ctrl = New TextBox
		Case "toolbar": Ctrl = New ToolBar
		Case "toolpalette": Ctrl = New ToolPalette
		Case "trackbar": Ctrl = New TrackBar
		Case "treelistview": Ctrl = New TreeListView
		Case "treeview": Ctrl = New TreeView
		Case "updown": Ctrl = New UpDown
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
		Case "imagelist": Cpnt = New ImageList
		Case "timercomponent": Cpnt = New TimerComponent
		Case "tooltips": Cpnt = New ToolTips
		Case "mainmenu": Cpnt = New MainMenu
		Case "popupmenu": Cpnt = New PopUpMenu
		Case "colordialog": Cpnt = New ColorDialog
		Case "folderbrowserdialog": Cpnt = New FolderBrowserDialog
		Case "fontdialog": Cpnt = New FontDialog
		Case "openfiledialog": Cpnt = New OpenFileDialog
		Case "savefiledialog": Cpnt = New SaveFileDialog
		Case "pagesetupdialog": Cpnt = New PageSetupDialog
		Case "printdialog": Cpnt = New PrintDialog
		Case "printpreviewdialog": Cpnt = New PrintPreviewDialog
		Case "printer": Cpnt = New Printer
		Case "tooltips": Cpnt = New ToolTips
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
		Case "menuitem": Obj = New MenuItem
		Case "toolbutton": Obj = New ToolButton
		Case Else: Obj = CreateComponent(ClassName, "", 0, 0, 0)
		End Select
		Objects.Add Obj
		Return Obj
	End Function
	
	Common Shared bNotRemoveObject As Boolean
	Function DeleteComponent Alias "DeleteComponent"(Ctrl As Any Ptr) As Boolean Export
		Select Case LCase(Cast(Component Ptr, Ctrl)->ClassName)
		Case "animate": Delete Cast(Animate Ptr, Ctrl)
		Case "checkbox" :Delete Cast(CheckBox Ptr, Ctrl)
		Case "checkedlistbox": Delete Cast(CheckedListBox Ptr, Ctrl)
		Case "comboboxedit": Delete Cast(ComboBoxEdit Ptr, Ctrl)
		Case "comboboxex": Delete Cast(ComboBoxEx Ptr, Ctrl)
		Case "commandbutton": Delete Cast(CommandButton Ptr, Ctrl)
		Case "datetimepicker": Delete Cast(DateTimePicker Ptr, Ctrl)
		Case "form": Delete Cast(Form Ptr, Ctrl)
		Case "grid": Delete Cast(Grid Ptr, Ctrl)
		Case "groupbox": Delete Cast(GroupBox Ptr, Ctrl)
		Case "header": Delete Cast(Header Ptr, Ctrl)
		Case "hotkey": Delete Cast(HotKey Ptr, Ctrl)
		Case "ipaddress": Delete Cast(IPAddress Ptr, Ctrl)
		Case "imagebox": Delete Cast(ImageBox Ptr, Ctrl)
		Case "label": Delete Cast(Label Ptr, Ctrl)
		Case "linklabel": Delete Cast(LinkLabel Ptr, Ctrl)
		Case "listcontrol": Delete Cast(ListControl Ptr, Ctrl)
		Case "listview": Delete Cast(ListView Ptr, Ctrl)
		Case "monthcalendar": Delete Cast(MonthCalendar Ptr, Ctrl)
		Case "nativefontcontrol": Delete Cast(NativeFontControl Ptr, Ctrl)
		Case "pagescroller": Delete Cast(PageScroller Ptr, Ctrl)
		Case "pagesetupdialog": Delete Cast(PageSetupDialog Ptr, Ctrl)
		Case "printdialog": Delete Cast(PrintDialog Ptr, Ctrl)
		Case "printpreviewdialog": Delete Cast(PrintPreviewDialog Ptr, Ctrl)
		Case "printer": Delete Cast(Printer Ptr, Ctrl)
		Case "panel": Delete Cast(Panel Ptr, Ctrl)
		Case "picture": Delete Cast(Picture Ptr, Ctrl)
		Case "progressbar": Delete Cast(ProgressBar Ptr, Ctrl)
		Case "radiobutton": Delete Cast(RadioButton Ptr, Ctrl)
		Case "rebar": Delete Cast(ReBar Ptr, Ctrl)
		Case "richtextbox": Delete Cast(RichTextBox Ptr, Ctrl)
		Case "tabcontrol": Delete Cast(TabControl Ptr, Ctrl)
		Case "tabpage": Delete Cast(TabPage Ptr, Ctrl)
		Case "scrollbarcontrol": Delete Cast(ScrollBarControl Ptr, Ctrl)
		Case "hscrollbar": Delete Cast(HScrollBar Ptr, Ctrl)
		Case "vscrollbar": Delete Cast(VScrollBar Ptr, Ctrl)
		Case "splitter": Delete Cast(Splitter Ptr, Ctrl)
		Case "statusbar": Delete Cast(StatusBar Ptr, Ctrl)
		Case "tabcontrol": Delete Cast(TabControl Ptr, Ctrl)
		Case "textbox": Delete Cast(TextBox Ptr, Ctrl)
		Case "toolbar": Delete Cast(ToolBar Ptr, Ctrl)
		Case "toolpalette": Delete Cast(ToolPalette Ptr, Ctrl)
		Case "tooltips": Delete Cast(ToolTips Ptr, Ctrl)
		Case "trackbar": Delete Cast(TrackBar Ptr, Ctrl)
		Case "treelistview": Delete Cast(TreeListView Ptr, Ctrl)
		Case "treeview": Delete Cast(TreeView Ptr, Ctrl)
		Case "updown": Delete Cast(UpDown Ptr, Ctrl)
		Case "imagelist": Delete Cast(ImageList Ptr, Ctrl)
		Case "timercomponent": Delete Cast(TimerComponent Ptr, Ctrl)
		Case "tooltips": Delete Cast(ToolTips Ptr, Ctrl)
		Case "mainmenu": Delete Cast(MainMenu Ptr, Ctrl)
		Case "popupmenu": Delete Cast(PopUpMenu Ptr, Ctrl)
		Case "folderbrowserdialog": Delete Cast(FolderBrowserDialog Ptr, Ctrl)
		Case "colordialog": Delete Cast(ColorDialog Ptr, Ctrl)
		Case "fontdialog": Delete Cast(FontDialog Ptr, Ctrl)
		Case "openfiledialog": Delete Cast(OpenFileDialog Ptr, Ctrl)
		Case "savefiledialog": Delete Cast(SaveFileDialog Ptr, Ctrl)
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
		Case "toolbutton": Delete Cast(ToolButton Ptr, Obj)
		Case "menuitem": Delete Cast(MenuItem Ptr, Obj)
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
