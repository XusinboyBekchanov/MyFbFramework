#IfDef __FB_Win32__
	#IfDef __FB_64bit__
	    '#Compile -dll -x "../mff64.dll" "mff.rc"
	#Else
	    '#Compile -dll -x "../mff32.dll" "mff.rc"
	#EndIf
#Else
	#IfDef __FB_64bit__
	    '#Compile -dll -x "../libmff64_gtk3.so"
	#Else
	    '#Compile -dll -x "../libmff32_gtk3.so"
	#EndIf
#EndIf
#Define __USE_GTK3__
#Define __EXPORT_PROCS__

#Include Once "Animate.bi"
#Include Once "Application.bi"
#Include Once "Bitmap.bi"
#Include Once "Brush.bi"
#Include Once "Canvas.bi"
#Include Once "CheckBox.bi"
#Include Once "CheckedListBox.bi"
#Include Once "Classes.bi"
#Include Once "Clipboard.bi"
#Include Once "ComboBoxEdit.bi"
#Include Once "ComboBoxEx.bi"
#Include Once "CommandButton.bi"
#Include Once "Component.bi"
#Include Once "ContainerControl.bi"
#Include Once "Control.bi"
#Include Once "Cursor.bi"
#Include Once "DateTimePicker.bi"
#Include Once "Dialogs.bi"
#Include Once "Font.bi"
#Include Once "Form.bi"
#Include Once "Graphic.bi"
#Include Once "Graphics.bi"
#Include Once "Grid.bi"
#Include Once "GroupBox.bi"
#Include Once "GUI.bi"
#Include Once "Header.bi"
#Include Once "HotKey.bi"
#Include Once "Icon.bi"
#Include Once "ImageBox.bi"
#Include Once "ImageList.bi"
#Include Once "IPAddress.bi"
#Include Once "IniFile.bi"
#Include Once "Label.bi"
#Include Once "LinkLabel.bi"
#Include Once "List.bi"
#Include Once "ListControl.bi"
#Include Once "ListItems.bi"
#Include Once "ListView.bi"
#Include Once "Menus.bi"
#Include Once "MonthCalendar.bi"
#Include Once "NativeFontControl.bi"
#Include Once "Object.bi"
#Include Once "PageScroller.bi"
#Include Once "Panel.bi"
#Include Once "Pen.bi"
#Include Once "ProgressBar.bi"
#Include Once "RadioButton.bi"
#Include Once "ReBar.bi"
#Include Once "RichTextBox.bi"
#Include Once "TabControl.bi"
#Include Once "ScrollBarControl.bi"
#Include Once "HScrollBar.bi"
#Include Once "VScrollBar.bi"
#Include Once "Splitter.bi"
#Include Once "StatusBar.bi"
#Include Once "StringList.bi"
#Include Once "SysUtils.bi"
#Include Once "TabControl.bi"
#Include Once "TextBox.bi"
#Include Once "TimerComponent.bi"
#Include Once "ToolBar.bi"
#Include Once "ToolPalette.bi"
#Include Once "ToolTips.bi"
#Include Once "TrackBar.bi"
#Include Once "TreeListView.bi"
#Include Once "TreeView.bi"
#Include Once "UpDown.bi"
#Include Once "WStringList.bi"

Using My.Sys.Forms

#IfNDef __USE_GTK__
	Function DllMain(hinstDLL As HINSTANCE, fdwReason As DWORD, lpvReserved As LPVOID) As Boolean
		Select Case fdwReason
		Case DLL_PROCESS_ATTACH
		Case DLL_PROCESS_DETACH
		Case DLL_THREAD_ATTACH
		Case DLL_THREAD_DETACH
		End Select
		Return True
	End Function
#EndIf

#IfDef __EXPORT_PROCS__
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
    'Case "ipaddress": Ctrl = New IPAddress
    Case "imagebox": Ctrl = New ImageBox
    Case "label": Ctrl = New Label
    Case "linklabel": Ctrl = New LinkLabel
    Case "listcontrol": Ctrl = New ListControl
    Case "listview": Ctrl = New ListView
    Case "monthcalendar": Ctrl = New MonthCalendar
    Case "nativefontcontrol": Ctrl = New NativeFontControl
    Case "pagescroller": Ctrl = New PageScroller
    Case "panel": Ctrl = New Panel
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
Function CreateComponent Alias "CreateComponent"(ByRef ClassName As String, ByRef sName As WString) As Component Ptr Export
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
    Case "tooltips": Cpnt = New ToolTips
    Case Else: Cpnt = CreateControl(ClassName, sName, sName, 0, 0, 10, 10, 0)
    End Select
    If Cpnt Then
        Cpnt->Name = sName
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
    Case Else: Obj = CreateComponent(ClassName, "")
    End Select
    Return Obj
End Function

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
    'Case "ipaddress": Delete Cast(IPAddress Ptr, Ctrl)
    Case "imagebox": Delete Cast(ImageBox Ptr, Ctrl)
    Case "label": Delete Cast(Label Ptr, Ctrl)
    Case "linklabel": Delete Cast(LinkLabel Ptr, Ctrl)
    Case "listcontrol": Delete Cast(ListControl Ptr, Ctrl)
    Case "listview": Delete Cast(ListView Ptr, Ctrl)
    Case "monthcalendar": Delete Cast(MonthCalendar Ptr, Ctrl)
    Case "nativefontcontrol": Delete Cast(NativeFontControl Ptr, Ctrl)
    Case "pagescroller": Delete Cast(PageScroller Ptr, Ctrl)
    Case "panel": Delete Cast(Panel Ptr, Ctrl)
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
    Return True
End Function

Function ObjectDelete Alias "ObjectDelete"(Obj As Any Ptr) As Boolean Export
    Select Case LCase(Cast(My.Sys.Object Ptr, Obj)->ClassName)
    Case "toolbutton": Delete Cast(ToolButton Ptr, Obj)
    Case "menuitem": Delete Cast(MenuItem Ptr, Obj)
    Case Else: Return DeleteComponent(Obj)
    End Select
    Return True
End Function

#IfNDef ShowPropertyPage_Off        
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
#EndIf
#EndIf
