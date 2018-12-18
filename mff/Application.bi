'###############################################################################
'#  Application.bi                                                             #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.1                                                              #
'###############################################################################

#Include Once "WStringList.bi"
#Include Once "Control.bi"
#IfDef __USE_GTK__
	#include once "gmodule.bi"
#Else
	#include once "win/winver.bi"
#EndIf

'#DEFINE crArrow       LoadCursor(0,IDC_ARROW)
'#DEFINE crAppStarting LoadCursor(0,IDC_APPSTARTING)
'#DEFINE crCross       LoadCursor(0,IDC_CROSS)
'#DEFINE crIBeam       LoadCursor(0,IDC_IBEAM)
'#DEFINE crIcon        LoadCursor(0,IDC_ICON)
'#DEFINE crNo          LoadCursor(0,IDC_NO)
'#DEFINE crSize        LoadCursor(0,IDC_SIZE)
'#DEFINE crSizeAll     LoadCursor(0,IDC_SIZEALL)
'#DEFINE crSizeNESW    LoadCursor(0,IDC_SIZENESW)
'#DEFINE crSizeNS      LoadCursor(0,IDC_SIZENS)
'#DEFINE crSizeNVSE    LoadCursor(0,IDC_SIZENWSE)
'#DEFINE crSizeWE      LoadCursor(0,IDC_SIZEWE)
'#DEFINE crUpArrow     LoadCursor(0,IDC_UPARROW)
'#DEFINE crWait        LoadCursor(0,IDC_WAIT)
'#DEFINE crDrag        LoadCursor(GetModuleHandle(NULL),"DRAG")
'#DEFINE crMultiDrag   LoadCursor(GetModuleHandle(NULL),"MULTIDRAG")
'#DEFINE crHandPoint   LoadCursor(GetModuleHandle(NULL),"HANDPOINT")
'#DEFINE crSQLWait     LoadCursor(GetModuleHandle(NULL),"SQLWAIT")
'#DEFINE crHSplit      LoadCursor(GetModuleHandle(NULL),"HSPLIT")
'#DEFINE crVSplit      LoadCursor(GetModuleHandle(NULL),"VSPLIT")
'#DEFINE crNoDrop      LoadCursor(GetModuleHandle(NULL),"NODROP")
'
Enum MessageType
	#IfDef __USE_GTK__ 
		mtInfo = GTK_MESSAGE_INFO
		mtWarning = GTK_MESSAGE_WARNING
		mtQuestion = GTK_MESSAGE_QUESTION
		mtError = GTK_MESSAGE_ERROR
		mtOther = GTK_MESSAGE_OTHER
	#Else
		mtInfo = MB_ICONINFORMATION
		mtWarning = MB_ICONEXCLAMATION
		mtQuestion = MB_ICONQUESTION
		mtError = MB_ICONERROR
		mtOther = 0
	#EndIf
End Enum

Enum ButtonsTypes
	#IfDef __USE_GTK__ 
		btNone = GTK_BUTTONS_NONE
		btOK = GTK_BUTTONS_OK
		btYesNo = GTK_BUTTONS_YES_NO
		btYesNoCancel = GTK_BUTTONS_YES_NO
		btOkCancel = GTK_BUTTONS_OK_CANCEL
	#Else
		btNone = 0
		btOK = MB_OK
		btYesNo = MB_YESNO
		btYesNoCancel = MB_YESNOCANCEL
		btOkCancel = MB_OKCANCEL
	#EndIf
End Enum

Enum MessageResult
	#IfDef __USE_GTK__ 
		mrAbort = 0
		mrCancel = GTK_RESPONSE_CANCEL
		mrIgnore = 0
		mrNo = GTK_RESPONSE_NO
		mrOK = GTK_RESPONSE_OK
		mrRetry = 0
		mrYes = GTK_RESPONSE_YES
	#Else
		mrAbort = IDABORT
		mrCancel = IDCANCEL
		mrIgnore = IDIGNORE
		mrNo = IDNO
		mrOK = IDOK
		mrRetry = IDRETRY
		mrYes = IDYES
	#EndIf
End Enum

Declare Function MsgBox(ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As Integer = 0, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As Integer
    
Enum ShutdownMode
    smAfterMainFormCloses
    smAfterAllFormsCloses
End Enum

namespace My
    #DEFINE QApplication(__Ptr__) *Cast(Application Ptr,__Ptr__)

    Type Application
        Private:
            FTitle          As WString Ptr
            FIcon           As My.Sys.Drawing.Icon
            FExeName        As WString Ptr
            FFileName       As WString Ptr
            FHintColor      As Integer
            FHintPause      As Integer
            FHintShortPause As Integer
            FHintHidePause  As Integer
            FFormCount      As Integer
            FForms          As My.Sys.Forms.Control Ptr Ptr
            FControlCount   As Integer
            FControls       As My.Sys.Forms.Control Ptr Ptr
            FMainForm       As My.Sys.Forms.Control Ptr
            Declare Sub GetControls
            Declare Sub EnumControls(Control As My.Sys.Forms.Control)
            #IfNDef __USE_GTK__
				Declare Static Function EnumThreadWindowsProc(FWindow As HWND,LData As LParam) As Bool
				Declare Static Function EnumFontsProc(LogFont As LOGFONT Ptr, TextMetric As TEXTMETRIC Ptr, FontStyle As DWORD, hData As LPARAM) As Integer
            #EndIf
            Declare Sub GetFonts
            Declare Sub GetForms
            As Byte initialized
			As Any Ptr _vinfo
			As String TranslationString
        Public:
            Fonts           As WStringList
            MouseX          As Integer
            MouseY          As Integer
            HelpFile        As String
            #IfNDef __USE_GTK__
				Instance        As HINSTANCE
			#EndIf
            Declare Property FileName ByRef As WString
            Declare Property FileName(ByRef Value As WString)
            Declare Function Version() As Const String
            Declare Function GetVerInfo(ByRef InfoName As Const String) As Const String
        
   Declare Property Icon As My.Sys.Drawing.Icon
            Declare Property Icon(value As My.Sys.Drawing.Icon)
            Declare Property Title ByRef As WString
            Declare Property Title(ByRef Value As WString)
            Declare Property ExeName ByRef As WString
            Declare Property ExeName(ByRef Value As WString)
            Declare Property MainForm As My.Sys.Forms.Control Ptr
            Declare Property MainForm(Value  As My.Sys.Forms.Control Ptr) 
            Declare Property HintColor As Integer
            Declare Property HintColor(value As Integer)
            Declare Property HintPause As Integer
            Declare Property HintPause (value As Integer)
            Declare Property HintShortPause As Integer
            Declare Property HintShortPause(value As Integer)
            Declare Property HintHidePause As Integer
            Declare Property HintHidePause(value As Integer)
            Declare Property ControlCount As Integer
            Declare Property ControlCount(Value  As Integer)
            Declare Property Controls As My.Sys.Forms.Control Ptr Ptr
            Declare Property Controls(Value  As My.Sys.Forms.Control Ptr Ptr) 
            Declare Function FormCount As Integer
            Declare Property Forms As My.Sys.Forms.Control Ptr Ptr 
            Declare Property Forms(Value  As My.Sys.Forms.Control Ptr Ptr)
            Declare Operator Cast As Any Ptr
            Declare Sub Run
            Declare Sub Terminate
            Declare Sub DoEvents
            Declare Sub HelpCommand(CommandID As Integer,FData As Long)
            Declare Sub HelpContext(ContextID As Long)
            Declare Sub HelpJump(TopicID As String)
            Declare Function IndexOfForm(Form As My.Sys.Forms.Control Ptr) As Integer
            #IfNDef __USE_GTK__
				Declare Function FindControl Overload(ControlHandle As HWND) As My.Sys.Forms.Control Ptr
            #EndIf
            Declare Function FindControl(ControlName As String) As My.Sys.Forms.Control Ptr
            Declare Function IndexOfControl(Control As My.Sys.Forms.Control Ptr) As Integer
            Declare Constructor
            Declare Destructor
            OnMouseMove As Sub(BYREF X As Integer,BYREF Y As Integer)
    End Type

    Function Application.Version As Const String
        Return GetVerInfo("FileVersion")
    End Function

    Property Application.Icon As My.Sys.Drawing.Icon
        Return FIcon
    End Property

    Property Application.Icon(value As My.Sys.Drawing.Icon)
        Dim As Integer i
        FIcon = Value
        #IfNDef __USE_GTK__
			If FIcon.Handle Then
				For i = 0 To FormCount -1
					SendMessage Forms[i]->Handle,WM_SETICON,ICON_BIG,CInt(FIcon.Handle)
				Next i
			End If
		#EndIf
    End Property
    
    Property Application.Title ByRef As WString
        If FTitle = 0 Then
            For i As Integer = 0 To FormCount -1
				#IfNDef __USE_GTK__
					If (GetWindowLong(Forms[i]->Handle, GWL_EXSTYLE) AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then
					   WLet FTitle, Forms[i]->Text
					   Return *FTitle
					End If
				#EndIf
            Next i
        Else
            Return *FTitle
        End If
    End Property

    Property Application.Title(ByRef Value As WString)
        WLet FTitle, Value
    End Property
    
    Property Application.ExeName ByRef As WString
        Dim As WString*255 Tx
        Dim As WString*225 s, En
        Dim As Integer L, i, k
        #IfNDef __USE_GTK__
			L = GetModuleFileName(GetModuleHandle(NULL), Tx, 255)
        #EndIf
        s = Left(Tx, L)
        For i = 0 to Len(s)
            If s[i] = Asc("\") Then k = i
        Next i
        En = Mid(s, k + 2, Len(s))
        WLet FFileName, s
        WLet FExeName, Mid(En, 1, InStr(En, ".") - 1)
        Return *FExeName
    End Property

    Property Application.ExeName(ByRef Value As WString)
    End Property

    Property Application.MainForm As My.Sys.Forms.Control Ptr
'        For i As Integer = 0 To FormCount -1
'            If (Forms[i]->ExStyle AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then
'                FMainForm = Forms[i]
                Return FMainForm
'            End If
'        Next i
    End Property

    Property Application.MainForm(Value As My.Sys.Forms.Control Ptr)
        FMainForm = Value
        #IfDef __USE_GTK__
            If FMainForm AndAlso FMainForm->widget Then g_signal_connect(FMainForm->widget, "destroy", G_CALLBACK(@gtk_main_quit), NULL)
        #EndIf
    End Property

    Property Application.ControlCount As Integer
        GetControls
        Return FControlCount
    End Property

    Property Application.ControlCount(Value  As Integer)
    End Property

    Property Application.Controls As My.Sys.Forms.Control Ptr Ptr 
        GetControls 
        Return FControls
    End Property

    Property Application.Controls(Value  As My.Sys.Forms.Control Ptr Ptr) 
    End Property

    Function Application.FormCount As Integer
        GetForms
        Return FFormCount
    End Function

    Property Application.Forms As My.Sys.Forms.Control Ptr Ptr 
        GetForms
        Return FForms
    End Property

    Property Application.Forms(Value  As My.Sys.Forms.Control Ptr Ptr) 
    End Property

    Property Application.HintColor As Integer
        Return FHintColor
    End Property

    Property Application.HintColor(value As Integer)
        Dim As Integer i
        FHintColor = value
        For i = 0 To ControlCount -1
        			#IfNDef __USE_GTK__
        				If Controls[i]->ToolTipHandle then SendMessage(Controls[i]->ToolTipHandle,TTM_SETTIPBKCOLOR,value,0)
        			#EndIf
        Next i
    End Property

    Property Application.HintPause As Integer
        Return FHintPause
    End Property

    Property Application.HintPause (value As Integer)
        Dim As Integer i
        FHintPause = value
        For i = 0 To ControlCount -1
			#IfNDef __USE_GTK__
				If Controls[i]->ToolTipHandle then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_INITIAL,value)     
			#EndIf
        Next i
    End Property

    Property Application.HintShortPause As Integer
        Return FHintShortPause
    End Property

    Property Application.HintShortPause(value As Integer)
        Dim As Integer i
        FHintShortPause = value
        For i = 0 To ControlCount -1
			#IfNDef __USE_GTK__
				If Controls[i]->ToolTipHandle Then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_RESHOW,value)     
			#EndIf
        Next i 
    End Property

    Property Application.HintHidePause As Integer
        Return FHintHidePause
    End Property

    Property Application.HintHidePause(value As Integer)
        Dim As Integer i
        FHintHidePause = value
        For i = 0 To ControlCount -1
			#IfNDef __USE_GTK__
				If Controls[i]->ToolTipHandle then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_AUTOPOP,value)     
			#EndIf
        Next i 
    End Property

    Sub Application.HelpCommand(CommandID As Integer,FData As Long)
        #IfNDef __USE_GTK__
			If MainForm Then WinHelp(MainForm->Handle,HelpFile,CommandID,FData)
		#EndIf
    End Sub

    Sub Application.HelpContext(ContextID As Long)
        #IfNDef __USE_GTK__
			If MainForm Then WinHelp(MainForm->Handle,HelpFile,HELP_CONTEXT,ContextID)
		#EndIf
    End Sub

    Sub Application.HelpJump(TopicID As String)
        Dim StrFmt As String
        StrFmt = "JumpID(" + Chr(34) + Chr(34) + ","+ Chr(34) + TopicID + Chr(34) + ")"+ Chr(0)
        If MainForm Then
			#IfNDef __USE_GTK__ 
			   If WinHelp(MainForm->Handle,HelpFile,HELP_COMMAND,CInt(StrPtr(StrFmt))) = 0 then 
				  WinHelp(MainForm->Handle,HelpFile,HELP_CONTENTS,NULL)
			   End If
			#EndIf
        End If
    End Sub

    Sub Application.Run
        #IfDef __USE_GTK__
			gtk_main()
		#Else
			Dim As MSG msg
			If FormCount = 0 Then
			   End 10
			End If
			Dim As My.Sys.Forms.Control Ptr Ctrl, Frm
			If MainForm Then Frm = MainForm
			'Dim As Any Ptr hWindow
			Dim TranslateAndDispatch As Boolean
			While GetMessage(@msg, NULL,0,0)
				TranslateAndDispatch = True
				If GetForegroundWindow() = frm->Handle Then
					If Frm Then
						If Frm->Accelerator Then TranslateAndDispatch = TranslateAccelerator(Frm->Handle, Frm->Accelerator, @msg) = 0
						'If TranslateAndDispatch Then TranslateAndDispatch = Not Cast(Boolean, IsDialogMessage(frm->Handle, @msg))
					End If
				End If
				If TranslateAndDispatch Then
					TranslateMessage @msg
					DispatchMessage @msg
				End If
				MouseX = msg.Pt.x
				MouseY = msg.Pt.y
				If OnMouseMove Then OnMouseMove(MouseX,MouseY) 
			Wend
		#EndIf
    End Sub

    Sub Application.Terminate
		#IfNDef __USE_GTK__
			PostQuitMessage(0)
		#EndIf
        End 1
    End Sub

    Sub Application.DoEvents
        #IfDef __USE_GTK__
			While gtk_events_pending()
				gtk_main_iteration
			Wend
        #Else
			Dim As MSG M
			If PeekMessage(@M, 0, 0, 0, PM_REMOVE) Then
			   If M.Message <> WM_QUIT Then
				   TranslateMessage @M
				   DispatchMessage @M
			   Else
				   If (GetWindowLong(M.hWnd,GWL_EXSTYLE) AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then End -1
			   End If
			End If
		#EndIf
    End Sub

    Function Application.IndexOfControl(Control As My.Sys.Forms.Control Ptr) As Integer
        Dim As Integer i
        For i = 0 To ControlCount -1
            If Controls[i] = Control Then Return i
        Next i
        Return -1
    End Function

	#IfNDef __USE_GTK__
		Function Application.FindControl(ControlHandle As HWND) As My.Sys.Forms.Control Ptr
			Dim As Integer i
			If Controls Then
				For i = 0 To ControlCount -1
					If Controls[i]->Handle = ControlHandle Then Return Controls[i]
				Next i
			End If
			Return NULL
		End Function
	#EndIf
	
    Function Application.FindControl(ControlName As String) As My.Sys.Forms.Control Ptr
        Dim As Integer i
        If Controls Then
            For i = 0 To ControlCount -1
                If UCase(Controls[i]->Name) = UCase(ControlName) Then Return Controls[i]
            Next i
        End If
        Return NULL
    End Function

    Function Application.IndexOfForm(Form As My.Sys.Forms.Control Ptr) As Integer
        Dim As Integer i
        If Forms Then
            For i = 0 To FormCount -1
				If Forms[i] = Form Then Return i
            Next i
        End If
        Return -1
    End Function
	
	#IfNDef __USE_GTK__
		Function Application.EnumThreadWindowsProc(FWindow As HWND, LData As LParam) As Bool
			Dim As My.Sys.Forms.Control Ptr AControl
			Dim As Application Ptr App
			App = Cast(Application Ptr, lData)
			AControl = Cast(My.Sys.Forms.Control Ptr, GetWindowLongPtr(FWindow,GWLP_USERDATA))
			If App Then
			   If AControl Then
				  With QApplication(App)
					  .FFormCount += 1
					  .FForms = ReAllocate(.FForms,SizeOF(My.Sys.Forms.Control)*.FFormCount)
					 .FForms[.FFormCount -1] = AControl
				 End With
			   End If
			End If
			Return True
		End Function
	#EndIf

    Sub Application.GetForms
        FForms = cAllocate(0)
        FFormCount = 0
        #IfNDef __USE_GTK__
			EnumThreadWindows GetCurrentThreadID,Cast(WNDENUMPROC,@EnumThreadWindowsProc),Cast(LPARAM,@This)
		#EndIf
    End Sub

    Sub Application.EnumControls(Control As My.Sys.Forms.Control)
        Dim As Integer i
        For i = 0 To Control.ControlCount -1
            FControlCount += 1
            FControls = ReAllocate(FControls,SizeOF(My.Sys.Forms.Control)*FControlCount)
            FControls[FControlCount -1] = Control.Controls[i]
            EnumControls(*Control.Controls[i])
        Next i
    End Sub

    Sub Application.GetControls
        Dim As Integer i
        FControls = cAllocate(0)
        FControlCount = 0
        For i = 0 To FormCount -1
            EnumControls(*Forms[i])
        Next i
    End Sub

	#IfNDef __USE_GTK__
		Function Application.EnumFontsProc(LogFont As LOGFONT Ptr, TextMetric As TEXTMETRIC Ptr, FontStyle As DWORD, hData As LPARAM) As Integer
		   *Cast(WStringList Ptr, hData).Add(LogFont->lfFaceName)
		   Return True
		End Function
	#EndIf

    Sub Application.GetFonts
		#IfNDef __USE_GTK__
		   Dim DC    As HDC
		   Dim LFont As LOGFONTA
		   DC = GetDC(HWND_DESKTOP)
		   LFont.lfCharset = DEFAULT_CHARSET
		#EndIf
       Fonts.Clear
'       EnumFontFamilies(DC,NULL,@EnumFontsProc,Cint(@Fonts)) 'OR
       'EnumFontFamiliesEx(DC,@LFont,@EnumFontsProc,CInt(@s), 0)
       'EnumFonts(DC,NULL,@EnumFontsProc,CInt(NULL))
       #IfNDef __USE_GTK__
			ReleaseDC(HWND_DESKTOP,DC)
		#EndIf
    End Sub

    Operator Application.Cast As Any Ptr
        Return @This
    End Operator

    Private Function Application.GetVerInfo(ByRef InfoName As Const String) As Const String
		Dim As ULong iret
		If TranslationString = "" Then Return ""
		Dim As WString Ptr value = 0
        Dim As Const String FullInfoName = $"\StringFileInfo\" & TranslationString & "\" & InfoName
		#IfNDef __USE_GTK__
			If VerQueryValue(_vinfo, FullInfoName, @value, @iret) Then
				''~ value = cast( zstring ptr, vqinfo )
			End If
		#EndIf
		Return WGet(value)
	End Function

	Constructor Application
		#IfDef __USE_GTK__
			gtk_init(NULL, NULL)
			gtk_icon_theme_append_search_path(gtk_icon_theme_get_default(), exepath & "/resources")
			'gtk_icon_theme_add_resource_path(gtk_icon_theme_get_default(), exepath & "/resources")
			'Dim As GList Ptr l = gtk_icon_theme_list_icons(gtk_icon_theme_get_default(), null)
			'while (l)
			'	If StartsWith(*Cast(Zstring ptr, l->Data), "VisualFBEditor") Then
			'		?*Cast(Zstring ptr, l->Data)
			'	End If
			'	If StartsWith(*Cast(Zstring ptr, l->Data), "Logo") Then
			'		?*Cast(Zstring ptr, l->Data)
			'	End If
			'	l = l->Next
			'Wend
		#Else
			InitCommonControls
			Instance = GetModuleHandle(NULL)
        #EndIf
        GetFonts
        #IfNDef __USE_GTK__
			Dim As DWORD ret, discard
		#EndIf
		This.initialized = FALSE
		This._vinfo = 0
		ExeName
		#IfNDef __USE_GTK__
			ret = GetFileVersionInfoSize(FFileName, @discard)
			If ret <> 0 Then
				This._vinfo = Allocate(ret)
				If This._vinfo Then
					If GetFileVersionInfo(FFileName, 0, ret, This._vinfo) Then
						Dim As Unsigned Short Ptr ulTranslation
						Dim As ULong iret
						If VerQueryValue(_vinfo, $"\VarFileInfo\Translation", @ulTranslation, @iret) Then
						   TranslationString = Hex(ulTranslation[0], 4) & Hex(ulTranslation[1], 4)
						End If
						This.initialized = TRUE
					End If
				End If
			End If
		#EndIf
    End Constructor

    Destructor Application
        If FForms Then DeAllocate FForms
        If FFileName Then DeAllocate FFileName
        If FExeName Then DeAllocate FExeName
        If FTitle Then DeAllocate FTitle
        If FControls Then DeAllocate FControls
        If This._vinfo <> 0 Then Deallocate(This._vinfo) : This._vinfo = 0
    End Destructor
End namespace

Dim Shared App As My.Application 'Global for entire Application

Function MsgBox OverLoad(ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As Integer = 0, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As Integer
    Dim As Integer Result = -1
    Dim As WString Ptr FCaption
    WLet FCaption, Caption
    Dim As My.Sys.Forms.Control Ptr ActiveForm
    If *FCaption = "" Then WLet FCaption, App.Title
'    For i As Integer = 0 To App.FormCount -1
'        If GetActiveWindow = App.Forms[i]->Handle Then ActiveForm = App.Forms[i]
'        If App.Forms[i]->Handle Then App.Forms[i]->Enabled = False
'    Next i
	#IfNDef __USE_GTK__
		Dim As HWND Wnd
	#EndIf
'    If ActiveForm Then
'       If ActiveForm->Handle Then
'          Wnd = ActiveForm->Handle
'       Else
'          Wnd = MainHandle
'       End If
'    End If
	#IfDef __USE_GTK__
		DIM AS GtkWidget PTR dialog
		Dim As GtkWindow Ptr win
		If App.MainForm Then
			win = Gtk_Window(App.MainForm->widget)
		End If
		dialog = gtk_message_dialog_new (win, _
										  GTK_DIALOG_DESTROY_WITH_PARENT, _
										  MsgType, _
										  IIf(ButtonsType = btYesNoCancel, btNone, ButtonsType), _
										  ToUTF8(MsgStr), _
										  NULL)
		If ButtonsType = btYesNoCancel Then
			gtk_dialog_add_button(GTK_DIALOG(dialog), ToUTF8(*Cast(WString Ptr, GTK_STOCK_CANCEL)), GTK_RESPONSE_CANCEL)
			gtk_dialog_add_button(GTK_DIALOG(dialog), ToUTF8(*Cast(WString Ptr, GTK_STOCK_NO)), GTK_RESPONSE_NO)
			gtk_dialog_add_button(GTK_DIALOG(dialog), ToUTF8(*Cast(WString Ptr, GTK_STOCK_YES)), GTK_RESPONSE_YES)
			gtk_dialog_set_default_response(GTK_DIALOG(dialog), GTK_RESPONSE_YES)
		End If
		Result = gtk_dialog_run (GTK_DIALOG (dialog))
		gtk_widget_destroy (dialog)
	#Else
		If App.MainForm Then
			Wnd = App.MainForm->Handle
		End If
		Result = MessageBox(wnd, @MsgStr, FCaption, MsgType Or ButtonsType OR MB_TOPMOST OR MB_TASKMODAL)
	#EndIf
    'Do
    '    App.DoEvents
    'Loop Until Result <> -1
'    For i As Integer = 0 To App.FormCount -1
'        If App.Forms[i]->Handle Then App.Forms[i]->Enabled = True
'    Next i
    Return Result
End Function
