'###############################################################################
'#  SysUtils.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   SysUtils.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#IfDef __FB_Linux__
	#DEFINE __USE_GTK__
#Else
	#DEFINE __USE_WINAPI__
#EndIf

#IfNDef __USE_GTK__
    #DEFINE UNICODE
    #INCLUDE Once "Windows.bi"
    #INCLUDE Once "Win/CommCtrl.bi"
    #INCLUDE Once "Win/CommDlg.bi"
    #INCLUDE Once "Win/RichEdit.bi"
    #define Instance GetModuleHandle(NULL)
#EndIf
#Include Once "utf_conv.bi"
'#Include Once "UString.bi"

Const HELP_SETPOPUP_POS = &Hd

'#DEFINE __AUTOMATE_CREATE_CHILDS__
 
#IfNDef __USE_GTK__
	#DEFINE CM_NOTIFYCHILD 39998
	#DEFINE CM_CHANGEIMAGE 39999
	#DEFINE CM_CTLCOLOR    40000
	#DEFINE CM_COMMAND     40001
	#DEFINE CM_NOTIFY      40002
	#DEFINE CM_HSCROLL     40003
	#DEFINE CM_VSCROLL     40004
	#DEFINE CM_MEASUREITEM 40005
	#DEFINE CM_DRAWITEM    40006
	#DEFINE CM_HELPCONTEXT 40007
	#DEFINE CM_CANCELMODE  40008
	#DEFINE CM_HELP        40010 
	#DEFINE CM_NEEDTEXT    40011 
	#DEFINE CM_CREATE      40012 

	'Dim Shared As Message Message

	Function EnumThreadWindowsProc(FWindow As HWND,LData As LParam) As Bool
		Type WindowType
			As HWND Handle
		End Type
		Dim As WindowType Ptr Wnd = Cast(WindowType Ptr, lData)
		If (GetWindowLong(FWindow, GWL_EXSTYLE) AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then
		   Wnd->Handle = FWindow
		End If
		Return True
	End Function

	Function MainHandle As HWND
		Type WindowType
			As HWND Handle
		End Type
		Dim As WindowType Wnd
		EnumThreadWindows GetCurrentThreadID,Cast(WNDENUMPROC,@EnumThreadWindowsProc),Cast(LPARAM,@Wnd)
		Return Wnd.Handle 
	End Function
#EndIf

Function iGet(Value As Any Ptr) As Integer
	If Value = 0 Then Return 0 Else Return *Cast(Integer Ptr, Value)
End Function

Function ZGet(ByRef subject As ZString Ptr) As String
    If subject = 0 Then Return ""
    Return *subject
End Function

Sub WDeAllocate(ByRef subject AS Wstring Ptr)
    If subject <> 0 Then Deallocate subject
    subject = 0
End Sub

Sub WReAllocate(ByRef subject AS Wstring Ptr, lLen AS Integer)
    subject = Cast(WString Ptr, Reallocate(subject, (lLen + 1) * SizeOf(Wstring)))
End Sub

Function WGet(ByRef subject AS WString Ptr) ByRef As WString
    If subject = 0 Then Return "" Else Return *subject
End Function

Sub WLet(ByRef subject AS WString Ptr, ByRef txt AS WString)
    WReAllocate subject, Len(txt)
    *subject = txt
End Sub

Sub WAdd(ByRef subject AS Wstring Ptr, ByRef txt AS WString)
    Dim nLen As Integer = 0
    If subject <> 0 Then nLen = Len(*subject)
    WReAllocate subject, nLen + Len(txt)
    *subject = *subject & txt
End Sub

Namespace ClassContainer
    Type ClassType
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
    
    Property ClassType.ClassName ByRef As WString
        Return WGet(FClassName)
    End Property
    
    Property ClassType.ClassName(ByRef Value As WString)
        FClassName = Reallocate(FClassName, (Len(Value) + 1) * SizeOf(WString))
        *FClassName = Value
    End Property
    
    Property ClassType.ClassAncestor ByRef As WString
        Return WGet(FClassAncestor)
    End Property
    
    Property ClassType.ClassAncestor(ByRef Value As WString)
        FClassAncestor = Reallocate(FClassAncestor, (Len(Value) + 1) * SizeOf(WString))
        *FClassAncestor = Value
    End Property
    
    Constructor ClassType
        'FClassName = CAllocate(0)
        'FClassAncestor = CAllocate(0)
    End Constructor
    
    Destructor ClassType
        If FClassName Then DeAllocate FClassName
        If FClassAncestor Then DeAllocate FClassAncestor
    End Destructor
    
    Dim Classes()  As ClassType
    
    Function FindClass(ByRef ClassName As WString) As Integer
        For i As Integer = 0 To UBound(Classes)
            If UCase(Classes(i).ClassName) = UCase(ClassName) Then Return i
        Next i
        Return -1
    End Function
    
    Sub StoreClass(ByRef ClassName As WString, ByRef ClassAncestor As WString, ClassProc As Any Ptr)
        If FindClass(ClassName) = -1 Then
            ReDim Preserve Classes(UBound(Classes)+1) As ClassType
            Classes(UBound(Classes)).ClassName = ClassName
            Classes(UBound(Classes)).ClassAncestor = ClassAncestor
            Classes(UBound(Classes)).ClassProc = ClassProc
        End If 
    End Sub

    Function GetClassProc Overload(ByRef ClassName As WString) As Any Ptr
        For i As Integer = 0 To UBound(Classes)
            If UCase(Classes(i).ClassName) = UCase(ClassName) Then Return Classes(i).ClassProc
        Next i
        Return 0
    End Function
    
    #IFNDef __USE_GTK__
    Function GetClassProc(FWindow As HWND) As Any Ptr
        Dim As WString * 255 c
        Dim As WString Ptr ClassName
        Dim As Integer L
        L = GetClassName(FWindow, c, 255)
        ClassName = CAllocate((L + 1) * SizeOf(WString))
        *ClassName = Left(c, L)
        Return GetClassProc(*ClassName)
    End Function
    
    Function GetClassNameOf(FWindow As HWND) As String
        Dim As WString * 255 c
        Dim As WString Ptr ClassName
        Dim As Integer L
        L = GetClassName(FWindow, c, 255)
        Return Left(c, L)
    End Function
    
    Sub Finalization Destructor
        For i As Integer = 0 To UBound(Classes)
            UnregisterClass Classes(i).ClassName, GetModuleHandle(NULL)
        Next i
    End Sub
    #EndIf
End Namespace

Using ClassContainer

Function ToUtf8(pWString As WString Ptr) As String
	'#IfDef __USE_GTK__
	'	Return g_locale_to_utf8(*pWString, -1, NULL, NULL, NULL)
   '#Else
	   Dim cbLen As Integer
	   Dim m_BufferLen As Integer = Len(*pWString)
	   If m_BufferLen = 0 Then Return ""
	   Dim buffer As String = String(m_BufferLen * 5 + 1, 0)
	   Return *Cast(ZString Ptr, WCharToUTF(1, pWString, m_BufferLen * 2, StrPtr(buffer), @cbLen))
	'#EndIf
End Function

Function FromUtf8(pZString As ZString Ptr) ByRef As WString
   Dim cbLen As Integer
   Dim m_BufferLen As Integer = Len(*pZString)
   If m_BufferLen = 0 Then Return ""
   Dim buffer As WString Ptr
   WLet buffer, WString(m_BufferLen * 5 + 1, 0)
   Return WGet(UTFToWChar(1, pZString, buffer, @cbLen))
End Function

#IfDef GetMN
	Function GetMessageName(Message As Integer) As String
		Select Case Message
		Case 0: Return "WM_NULL"
		Case 1: Return "WM_CREATE"
		Case 2: Return "WM_DESTROY"
		Case 3: Return "WM_MOVE"
		Case 5: Return "WM_SIZE"
		Case 6: Return "WM_ACTIVATE"
		Case 7: Return "WM_SETFOCUS"
		Case 8: Return "WM_KILLFOCUS"
		Case 10: Return "WM_ENABLE"
		Case 11: Return "WM_SETREDRAW"
		Case 12: Return "WM_SETTEXT"
		Case 13: Return "WM_GETTEXT"
		Case 14: Return "WM_GETTEXTLENGTH"
		Case 15: Return "WM_PAINT"
		Case 16: Return "WM_CLOSE"
		Case 17: Return "WM_QUERYENDSESSION"
		Case 18: Return "WM_QUIT"
		Case 19: Return "WM_QUERYOPEN"
		Case 20: Return "WM_ERASEBKGND"
		Case 21: Return "WM_SYSCOLORCHANGE"
		Case 22: Return "WM_ENDSESSION"
		Case 24: Return "WM_SHOWWINDOW"
		Case 25: Return "WM_CTLCOLOR"
		Case 26: Return "WM_WININICHANGE"
		Case 27: Return "WM_DEVMODECHANGE"
		Case 28: Return "WM_ACTIVATEAPP"
		Case 29: Return "WM_FONTCHANGE"
		Case 30: Return "WM_TIMECHANGE"
		Case 31: Return "WM_CANCELMODE"
		Case 32: Return "WM_SETCURSOR"
		Case 33: Return "WM_MOUSEACTIVATE"
		Case 34: Return "WM_CHILDACTIVATE"
		Case 35: Return "WM_QUEUESYNC"
		Case 36: Return "WM_GETMINMAXINFO"
		Case 38: Return "WM_PAINTICON"
		Case 39: Return "WM_ICONERASEBKGND"
		Case 40: Return "WM_NEXTDLGCTL"
		Case 42: Return "WM_SPOOLERSTATUS"
		Case 43: Return "WM_DRAWITEM"
		Case 44: Return "WM_MEASUREITEM"
		Case 45: Return "WM_DELETEITEM"
		Case 46: Return "WM_VKEYTOITEM"
		Case 47: Return "WM_CHARTOITEM"
		Case 48: Return "WM_SETFONT"
		Case 49: Return "WM_GETFONT"
		Case 50: Return "WM_SETHOTKEY"
		Case 51: Return "WM_GETHOTKEY"
		Case 55: Return "WM_QUERYDRAGICON"
		Case 57: Return "WM_COMPAREITEM"
		Case 61: Return "WM_GETOBJECT"
		Case 65: Return "WM_COMPACTING"
		Case 68: Return "WM_COMMNOTIFY"
		Case 70: Return "WM_WINDOWPOSCHANGING"
		Case 71: Return "WM_WINDOWPOSCHANGED"
		Case 72: Return "WM_POWER"
		Case 73: Return "WM_COPYGLOBALDATA"
		Case 74: Return "WM_COPYDATA"
		Case 75: Return "WM_CANCELJOURNAL"
		Case 78: Return "WM_NOTIFY"
		Case 80: Return "WM_INPUTLANGCHANGEREQUEST"
		Case 81: Return "WM_INPUTLANGCHANGE"
		Case 82: Return "WM_TCARD"
		Case 83: Return "WM_HELP"
		Case 84: Return "WM_USERCHANGED"
		Case 85: Return "WM_NOTIFYFORMAT"
		Case 123: Return "WM_CONTEXTMENU"
		Case 124: Return "WM_STYLECHANGING"
		Case 125: Return "WM_STYLECHANGED"
		Case 126: Return "WM_DISPLAYCHANGE"
		Case 127: Return "WM_GETICON"
		Case 128: Return "WM_SETICON"
		Case 129: Return "WM_NCCREATE"
		Case 130: Return "WM_NCDESTROY"
		Case 131: Return "WM_NCCALCSIZE"
		Case 132: Return "WM_NCHITTEST"
		Case 133: Return "WM_NCPAINT"
		Case 134: Return "WM_NCACTIVATE"
		Case 135: Return "WM_GETDLGCODE"
		Case 136: Return "WM_SYNCPAINT"
		Case 160: Return "WM_NCMOUSEMOVE"
		Case 161: Return "WM_NCLBUTTONDOWN"
		Case 162: Return "WM_NCLBUTTONUP"
		Case 163: Return "WM_NCLBUTTONDBLCLK"
		Case 164: Return "WM_NCRBUTTONDOWN"
		Case 165: Return "WM_NCRBUTTONUP"
		Case 166: Return "WM_NCRBUTTONDBLCLK"
		Case 167: Return "WM_NCMBUTTONDOWN"
		Case 168: Return "WM_NCMBUTTONUP"
		Case 169: Return "WM_NCMBUTTONDBLCLK"
		Case 171: Return "WM_NCXBUTTONDOWN"
		Case 172: Return "WM_NCXBUTTONUP"
		Case 173: Return "WM_NCXBUTTONDBLCLK"
		Case 176: Return "EM_GETSEL"
		Case 177: Return "EM_SETSEL"
		Case 178: Return "EM_GETRECT"
		Case 179: Return "EM_SETRECT"
		Case 180: Return "EM_SETRECTNP"
		Case 181: Return "EM_SCROLL"
		Case 182: Return "EM_LINESCROLL"
		Case 183: Return "EM_SCROLLCARET"
		Case 185: Return "EM_GETMODIFY"
		Case 187: Return "EM_SETMODIFY"
		Case 188: Return "EM_GETLINECOUNT"
		Case 189: Return "EM_LINEINDEX"
		Case 190: Return "EM_SETHANDLE"
		Case 191: Return "EM_GETHANDLE"
		Case 192: Return "EM_GETTHUMB"
		Case 193: Return "EM_LINELENGTH"
		Case 194: Return "EM_REPLACESEL"
		Case 195: Return "EM_SETFONT"
		Case 196: Return "EM_GETLINE"
		Case 197: Return "EM_LIMITTEXT"
		Case 197: Return "EM_SETLIMITTEXT"
		Case 198: Return "EM_CANUNDO"
		Case 199: Return "EM_UNDO"
		Case 200: Return "EM_FMTLINES"
		Case 201: Return "EM_LINEFROMCHAR"
		Case 202: Return "EM_SETWORDBREAK"
		Case 203: Return "EM_SETTABSTOPS"
		Case 204: Return "EM_SETPASSWORDCHAR"
		Case 205: Return "EM_EMPTYUNDOBUFFER"
		Case 206: Return "EM_GETFIRSTVISIBLELINE"
		Case 207: Return "EM_SETREADONLY"
		Case 209: Return "EM_SETWORDBREAKPROC"
		Case 209: Return "EM_GETWORDBREAKPROC"
		Case 210: Return "EM_GETPASSWORDCHAR"
		Case 211: Return "EM_SETMARGINS"
		Case 212: Return "EM_GETMARGINS"
		Case 213: Return "EM_GETLIMITTEXT"
		Case 214: Return "EM_POSFROMCHAR"
		Case 215: Return "EM_CHARFROMPOS"
		Case 216: Return "EM_SETIMESTATUS"
		Case 217: Return "EM_GETIMESTATUS"
		Case 224: Return "SBM_SETPOS"
		Case 225: Return "SBM_GETPOS"
		Case 226: Return "SBM_SETRANGE"
		Case 227: Return "SBM_GETRANGE"
		Case 228: Return "SBM_ENABLE_ARROWS"
		Case 230: Return "SBM_SETRANGEREDRAW"
		Case 233: Return "SBM_SETSCROLLINFO"
		Case 234: Return "SBM_GETSCROLLINFO"
		Case 235: Return "SBM_GETSCROLLBARINFO"
		Case 240: Return "BM_GETCHECK"
		Case 241: Return "BM_SETCHECK"
		Case 242: Return "BM_GETSTATE"
		Case 243: Return "BM_SETSTATE"
		Case 244: Return "BM_SETSTYLE"
		Case 245: Return "BM_CLICK"
		Case 246: Return "BM_GETIMAGE"
		Case 247: Return "BM_SETIMAGE"
		Case 248: Return "BM_SETDONTCLICK"
		Case 255: Return "WM_INPUT"
		Case 256: Return "WM_KEYDOWN"
		Case 256: Return "WM_KEYFIRST"
		Case 257: Return "WM_KEYUP"
		Case 258: Return "WM_CHAR"
		Case 259: Return "WM_DEADCHAR"
		Case 260: Return "WM_SYSKEYDOWN"
		Case 261: Return "WM_SYSKEYUP"
		Case 262: Return "WM_SYSCHAR"
		Case 263: Return "WM_SYSDEADCHAR"
		Case 264: Return "WM_KEYLAST"
		Case 265: Return "WM_UNICHAR"
		Case 265: Return "WM_WNT_CONVERTREQUESTEX"
		Case 266: Return "WM_CONVERTREQUEST"
		Case 267: Return "WM_CONVERTRESULT"
		Case 268: Return "WM_INTERIM"
		Case 269: Return "WM_IME_STARTCOMPOSITION"
		Case 270: Return "WM_IME_ENDCOMPOSITION"
		Case 271: Return "WM_IME_COMPOSITION"
		Case 271: Return "WM_IME_KEYLAST"
		Case 272: Return "WM_INITDIALOG"
		Case 273: Return "WM_COMMAND"
		Case 274: Return "WM_SYSCOMMAND"
		Case 275: Return "WM_TIMER"
		Case 276: Return "WM_HSCROLL"
		Case 277: Return "WM_VSCROLL"
		Case 278: Return "WM_INITMENU"
		Case 279: Return "WM_INITMENUPOPUP"
		Case 280: Return "WM_SYSTIMER"
		Case 287: Return "WM_MENUSELECT"
		Case 288: Return "WM_MENUCHAR"
		Case 289: Return "WM_ENTERIDLE"
		Case 290: Return "WM_MENURBUTTONUP"
		Case 291: Return "WM_MENUDRAG"
		Case 292: Return "WM_MENUGETOBJECT"
		Case 293: Return "WM_UNINITMENUPOPUP"
		Case 294: Return "WM_MENUCOMMAND"
		Case 295: Return "WM_CHANGEUISTATE"
		Case 296: Return "WM_UPDATEUISTATE"
		Case 297: Return "WM_QUERYUISTATE"
		Case 306: Return "WM_CTLCOLORMSGBOX"
		Case 307: Return "WM_CTLCOLOREDIT"
		Case 308: Return "WM_CTLCOLORLISTBOX"
		Case 309: Return "WM_CTLCOLORBTN"
		Case 310: Return "WM_CTLCOLORDLG"
		Case 311: Return "WM_CTLCOLORSCROLLBAR"
		Case 312: Return "WM_CTLCOLORSTATIC"
		Case 512: Return "WM_MOUSEFIRST"
		Case 512: Return "WM_MOUSEMOVE"
		Case 513: Return "WM_LBUTTONDOWN"
		Case 514: Return "WM_LBUTTONUP"
		Case 515: Return "WM_LBUTTONDBLCLK"
		Case 516: Return "WM_RBUTTONDOWN"
		Case 517: Return "WM_RBUTTONUP"
		Case 518: Return "WM_RBUTTONDBLCLK"
		Case 519: Return "WM_MBUTTONDOWN"
		Case 520: Return "WM_MBUTTONUP"
		Case 521: Return "WM_MBUTTONDBLCLK"
		Case 521: Return "WM_MOUSELAST"
		Case 522: Return "WM_MOUSEWHEEL"
		Case 523: Return "WM_XBUTTONDOWN"
		Case 524: Return "WM_XBUTTONUP"
		Case 525: Return "WM_XBUTTONDBLCLK"
		Case 528: Return "WM_PARENTNOTIFY"
		Case 529: Return "WM_ENTERMENULOOP"
		Case 530: Return "WM_EXITMENULOOP"
		Case 531: Return "WM_NEXTMENU"
		Case 532: Return "WM_SIZING"
		Case 533: Return "WM_CAPTURECHANGED"
		Case 534: Return "WM_MOVING"
		Case 536: Return "WM_POWERBROADCAST"
		Case 537: Return "WM_DEVICECHANGE"
		Case 544: Return "WM_MDICREATE"
		Case 545: Return "WM_MDIDESTROY"
		Case 546: Return "WM_MDIACTIVATE"
		Case 547: Return "WM_MDIRESTORE"
		Case 548: Return "WM_MDINEXT"
		Case 549: Return "WM_MDIMAXIMIZE"
		Case 550: Return "WM_MDITILE"
		Case 551: Return "WM_MDICASCADE"
		Case 552: Return "WM_MDIICONARRANGE"
		Case 553: Return "WM_MDIGETACTIVE"
		Case 560: Return "WM_MDISETMENU"
		Case 561: Return "WM_ENTERSIZEMOVE"
		Case 562: Return "WM_EXITSIZEMOVE"
		Case 563: Return "WM_DROPFILES"
		Case 564: Return "WM_MDIREFRESHMENU"
		Case 640: Return "WM_IME_REPORT"
		Case 641: Return "WM_IME_SETCONTEXT"
		Case 642: Return "WM_IME_NOTIFY"
		Case 643: Return "WM_IME_CONTROL"
		Case 644: Return "WM_IME_COMPOSITIONFULL"
		Case 645: Return "WM_IME_SELECT"
		Case 646: Return "WM_IME_CHAR"
		Case 648: Return "WM_IME_REQUEST"
		Case 656: Return "WM_IMEKEYDOWN"
		Case 656: Return "WM_IME_KEYDOWN"
		Case 657: Return "WM_IMEKEYUP"
		Case 657: Return "WM_IME_KEYUP"
		Case 672: Return "WM_NCMOUSEHOVER"
		Case 673: Return "WM_MOUSEHOVER"
		Case 674: Return "WM_NCMOUSELEAVE"
		Case 675: Return "WM_MOUSELEAVE"
		Case 768: Return "WM_CUT"
		Case 769: Return "WM_COPY"
		Case 770: Return "WM_PASTE"
		Case 771: Return "WM_CLEAR"
		Case 772: Return "WM_UNDO"
		Case 773: Return "WM_RENDERFORMAT"
		Case 774: Return "WM_RENDERALLFORMATS"
		Case 775: Return "WM_DESTROYCLIPBOARD"
		Case 776: Return "WM_DRAWCLIPBOARD"
		Case 777: Return "WM_PAINTCLIPBOARD"
		Case 778: Return "WM_VSCROLLCLIPBOARD"
		Case 779: Return "WM_SIZECLIPBOARD"
		Case 780: Return "WM_ASKCBFORMATNAME"
		Case 781: Return "WM_CHANGECBCHAIN"
		Case 782: Return "WM_HSCROLLCLIPBOARD"
		Case 783: Return "WM_QUERYNEWPALETTE"
		Case 784: Return "WM_PALETTEISCHANGING"
		Case 785: Return "WM_PALETTECHANGED"
		Case 786: Return "WM_HOTKEY"
		Case 791: Return "WM_PRINT"
		Case 792: Return "WM_PRINTCLIENT"
		Case 793: Return "WM_APPCOMMAND"
		Case 856: Return "WM_HANDHELDFIRST"
		Case 863: Return "WM_HANDHELDLAST"
		Case 864: Return "WM_AFXFIRST"
		Case 895: Return "WM_AFXLAST"
		Case 896: Return "WM_PENWINFIRST"
		Case 897: Return "WM_RCRESULT"
		Case 898: Return "WM_HOOKRCRESULT"
		Case 899: Return "WM_GLOBALRCCHANGE"
		Case 899: Return "WM_PENMISCINFO"
		Case 900: Return "WM_SKB"
		Case 901: Return "WM_HEDITCTL"
		Case 901: Return "WM_PENCTL"
		Case 902: Return "WM_PENMISC"
		Case 903: Return "WM_CTLINIT"
		Case 904: Return "WM_PENEVENT"
		Case 911: Return "WM_PENWINLAST"
		Case 912: Return "WM_COALESCE_FIRST"
		Case 927: Return "WM_COALESCE_LAST"
		Case 992: Return "WM_DDE_FIRST"
		Case 992: Return "WM_DDE_INITIATE"
		Case 993: Return "WM_DDE_INITIATE"
		Case 994: Return "WM_DDE_ADVISE"
		Case 995: Return "WM_DDE_UNADVISE"
		Case 996: Return "WM_DDE_ACK"
		Case 997: Return "WM_DDE_DATA"
		Case 998: Return "WM_DDE_REQUEST"
		Case 999: Return "WM_DDE_POKE"
		Case 1000: Return "WM_DDE_EXECUTE"
		Case 1000: Return "WM_DDE_LAST"
		Case 1024: Return "DDM_SETFMT"
		Case 1024: Return "DM_GETDEFID"
		Case 1024: Return "NIN_SELECT"
		Case 1024: Return "TBM_GETPOS"
		Case 1024: Return "WM_PSD_PAGESETUPDLG"
		Case 1024: Return "WM_USER"
		Case 1025: Return "CBEM_INSERTITEMA"
		Case 1025: Return "DDM_DRAW"
		Case 1025: Return "DM_SETDEFID"
		Case 1025: Return "HKM_SETHOTKEY"
		Case 1025: Return "PBM_SETRANGE"
		Case 1025: Return "RB_INSERTBANDA"
		Case 1025: Return "SB_SETTEXTA"
		Case 1025: Return "TB_ENABLEBUTTON"
		Case 1025: Return "TBM_GETRANGEMIN"
		Case 1025: Return "TTM_ACTIVATE"
		Case 1025: Return "WM_CHOOSEFONT_GETLOGFONT"
		Case 1025: Return "WM_PSD_FULLPAGERECT"
		Case 1026: Return "CBEM_SETIMAGELIST"
		Case 1026: Return "DDM_CLOSE"
		Case 1026: Return "DM_REPOSITION"
		Case 1026: Return "HKM_GETHOTKEY"
		Case 1026: Return "PBM_SETPOS"
		Case 1026: Return "RB_DELETEBAND"
		Case 1026: Return "SB_GETTEXTA"
		Case 1026: Return "TB_CHECKBUTTON"
		Case 1026: Return "TBM_GETRANGEMAX"
		Case 1026: Return "WM_PSD_MINMARGINRECT"
		Case 1027: Return "CBEM_GETIMAGELIST"
		Case 1027: Return "DDM_BEGIN"
		Case 1027: Return "HKM_SETRULES"
		Case 1027: Return "PBM_DELTAPOS"
		Case 1027: Return "RB_GETBARINFO"
		Case 1027: Return "SB_GETTEXTLENGTHA"
		Case 1027: Return "TBM_GETTIC"
		Case 1027: Return "TB_PRESSBUTTON"
		Case 1027: Return "TTM_SETDELAYTIME"
		Case 1027: Return "WM_PSD_MARGINRECT"
		Case 1028: Return "CBEM_GETITEMA"
		Case 1028: Return "DDM_END"
		Case 1028: Return "PBM_SETSTEP"
		Case 1028: Return "RB_SETBARINFO"
		Case 1028: Return "SB_SETPARTS"
		Case 1028: Return "TB_HIDEBUTTON"
		Case 1028: Return "TBM_SETTIC"
		Case 1028: Return "TTM_ADDTOOLA"
		Case 1028: Return "WM_PSD_GREEKTEXTRECT"
		Case 1029: Return "CBEM_SETITEMA"
		Case 1029: Return "PBM_STEPIT"
		Case 1029: Return "TB_INDETERMINATE"
		Case 1029: Return "TBM_SETPOS"
		Case 1029: Return "TTM_DELTOOLA"
		Case 1029: Return "WM_PSD_ENVSTAMPRECT"
		Case 1030: Return "CBEM_GETCOMBOCONTROL"
		Case 1030: Return "PBM_SETRANGE32"
		Case 1030: Return "RB_SETBANDINFOA"
		Case 1030: Return "SB_GETPARTS"
		Case 1030: Return "TB_MARKBUTTON"
		Case 1030: Return "TBM_SETRANGE"
		Case 1030: Return "TTM_NEWTOOLRECTA"
		Case 1030: Return "WM_PSD_YAFULLPAGERECT"
		Case 1031: Return "CBEM_GETEDITCONTROL"
		Case 1031: Return "PBM_GETRANGE"
		Case 1031: Return "RB_SETPARENT"
		Case 1031: Return "SB_GETBORDERS"
		Case 1031: Return "TBM_SETRANGEMIN"
		Case 1031: Return "TTM_RELAYEVENT"
		Case 1032: Return "CBEM_SETEXSTYLE"
		Case 1032: Return "PBM_GETPOS"
		Case 1032: Return "RB_HITTEST"
		Case 1032: Return "SB_SETMINHEIGHT"
		Case 1032: Return "TBM_SETRANGEMAX"
		Case 1032: Return "TTM_GETTOOLINFOA"
		Case 1033: Return "CBEM_GETEXSTYLE"
		Case 1033: Return "CBEM_GETEXTENDEDSTYLE"
		Case 1033: Return "PBM_SETBARCOLOR"
		Case 1033: Return "RB_GETRECT"
		Case 1033: Return "SB_SIMPLE"
		Case 1033: Return "TB_ISBUTTONENABLED"
		Case 1033: Return "TBM_CLEARTICS"
		Case 1033: Return "TTM_SETTOOLINFOA"
		Case 1034: Return "CBEM_HASEDITCHANGED"
		Case 1034: Return "RB_INSERTBANDW"
		Case 1034: Return "SB_GETRECT"
		Case 1034: Return "TB_ISBUTTONCHECKED"
		Case 1034: Return "TBM_SETSEL"
		Case 1034: Return "TTM_HITTESTA"
		Case 1034: Return "WIZ_QUERYNUMPAGES"
		Case 1035: Return "CBEM_INSERTITEMW"
		Case 1035: Return "RB_SETBANDINFOW"
		Case 1035: Return "SB_SETTEXTW"
		Case 1035: Return "TB_ISBUTTONPRESSED"
		Case 1035: Return "TBM_SETSELSTART"
		Case 1035: Return "TTM_GETTEXTA"
		Case 1035: Return "WIZ_NEXT"
		Case 1036: Return "CBEM_SETITEMW"
		Case 1036: Return "RB_GETBANDCOUNT"
		Case 1036: Return "SB_GETTEXTLENGTHW"
		Case 1036: Return "TB_ISBUTTONHIDDEN"
		Case 1036: Return "TBM_SETSELEND"
		Case 1036: Return "TTM_UPDATETIPTEXTA"
		Case 1036: Return "WIZ_PREV"
		Case 1037: Return "CBEM_GETITEMW"
		Case 1037: Return "RB_GETROWCOUNT"
		Case 1037: Return "SB_GETTEXTW"
		Case 1037: Return "TB_ISBUTTONINDETERMINATE"
		Case 1037: Return "TTM_GETTOOLCOUNT"
		Case 1038: Return "CBEM_SETEXTENDEDSTYLE"
		Case 1038: Return "RB_GETROWHEIGHT"
		Case 1038: Return "SB_ISSIMPLE"
		Case 1038: Return "TB_ISBUTTONHIGHLIGHTED"
		Case 1038: Return "TBM_GETPTICS"
		Case 1038: Return "TTM_ENUMTOOLSA"
		Case 1039: Return "SB_SETICON"
		Case 1039: Return "TBM_GETTICPOS"
		Case 1039: Return "TTM_GETCURRENTTOOLA"
		Case 1040: Return "RB_IDTOINDEX"
		Case 1040: Return "SB_SETTIPTEXTA"
		Case 1040: Return "TBM_GETNUMTICS"
		Case 1040: Return "TTM_WINDOWFROMPOINT"
		Case 1041: Return "RB_GETTOOLTIPS"
		Case 1041: Return "SB_SETTIPTEXTW"
		Case 1041: Return "TBM_GETSELSTART"
		Case 1041: Return "TB_SETSTATE"
		Case 1041: Return "TTM_TRACKACTIVATE"
		Case 1042: Return "RB_SETTOOLTIPS"
		Case 1042: Return "SB_GETTIPTEXTA"
		Case 1042: Return "TB_GETSTATE"
		Case 1042: Return "TBM_GETSELEND"
		Case 1042: Return "TTM_TRACKPOSITION"
		Case 1043: Return "RB_SETBKCOLOR"
		Case 1043: Return "SB_GETTIPTEXTW"
		Case 1043: Return "TB_ADDBITMAP"
		Case 1043: Return "TBM_CLEARSEL"
		Case 1043: Return "TTM_SETTIPBKCOLOR"
		Case 1044: Return "RB_GETBKCOLOR"
		Case 1044: Return "SB_GETICON"
		Case 1044: Return "TB_ADDBUTTONSA"
		Case 1044: Return "TBM_SETTICFREQ"
		Case 1044: Return "TTM_SETTIPTEXTCOLOR"
		Case 1045: Return "RB_SETTEXTCOLOR"
		Case 1045: Return "TB_INSERTBUTTONA"
		Case 1045: Return "TBM_SETPAGESIZE"
		Case 1045: Return "TTM_GETDELAYTIME"
		Case 1046: Return "RB_GETTEXTCOLOR"
		Case 1046: Return "TB_DELETEBUTTON"
		Case 1046: Return "TBM_GETPAGESIZE"
		Case 1046: Return "TTM_GETTIPBKCOLOR"
		Case 1047: Return "RB_SIZETORECT"
		Case 1047: Return "TB_GETBUTTON"
		Case 1047: Return "TBM_SETLINESIZE"
		Case 1047: Return "TTM_GETTIPTEXTCOLOR"
		Case 1048: Return "RB_BEGINDRAG"
		Case 1048: Return "TB_BUTTONCOUNT"
		Case 1048: Return "TBM_GETLINESIZE"
		Case 1048: Return "TTM_SETMAXTIPWIDTH"
		Case 1049: Return "RB_ENDDRAG"
		Case 1049: Return "TB_COMMANDTOINDEX"
		Case 1049: Return "TBM_GETTHUMBRECT"
		Case 1049: Return "TTM_GETMAXTIPWIDTH"
		Case 1050: Return "RB_DRAGMOVE"
		Case 1050: Return "TBM_GETCHANNELRECT"
		Case 1050: Return "TB_SAVERESTOREA"
		Case 1050: Return "TTM_SETMARGIN"
		Case 1051: Return "RB_GETBARHEIGHT"
		Case 1051: Return "TB_CUSTOMIZE"
		Case 1051: Return "TBM_SETTHUMBLENGTH"
		Case 1051: Return "TTM_GETMARGIN"
		Case 1052: Return "RB_GETBANDINFOW"
		Case 1052: Return "TB_ADDSTRINGA"
		Case 1052: Return "TBM_GETTHUMBLENGTH"
		Case 1052: Return "TTM_POP"
		Case 1053: Return "RB_GETBANDINFOA"
		Case 1053: Return "TB_GETITEMRECT"
		Case 1053: Return "TBM_SETTOOLTIPS"
		Case 1053: Return "TTM_UPDATE"
		Case 1054: Return "RB_MINIMIZEBAND"
		Case 1054: Return "TB_BUTTONSTRUCTSIZE"
		Case 1054: Return "TBM_GETTOOLTIPS"
		Case 1054: Return "TTM_GETBUBBLESIZE"
		Case 1055: Return "RB_MAXIMIZEBAND"
		Case 1055: Return "TBM_SETTIPSIDE"
		Case 1055: Return "TB_SETBUTTONSIZE"
		Case 1055: Return "TTM_ADJUSTRECT"
		Case 1056: Return "TBM_SETBUDDY"
		Case 1056: Return "TB_SETBITMAPSIZE"
		Case 1056: Return "TTM_SETTITLEA"
		Case 1057: Return "MSG_FTS_JUMP_VA"
		Case 1057: Return "TB_AUTOSIZE"
		Case 1057: Return "TBM_GETBUDDY"
		Case 1057: Return "TTM_SETTITLEW"
		Case 1058: Return "RB_GETBANDBORDERS"
		Case 1059: Return "MSG_FTS_JUMP_QWORD"
		Case 1059: Return "RB_SHOWBAND"
		Case 1059: Return "TB_GETTOOLTIPS"
		Case 1060: Return "MSG_REINDEX_REQUEST"
		Case 1060: Return "TB_SETTOOLTIPS"
		Case 1061: Return "MSG_FTS_WHERE_IS_IT"
		Case 1061: Return "RB_SETPALETTE"
		Case 1061: Return "TB_SETPARENT"
		Case 1062: Return "RB_GETPALETTE"
		Case 1063: Return "RB_MOVEBAND"
		Case 1063: Return "TB_SETROWS"
		Case 1064: Return "TB_GETROWS"
		Case 1065: Return "TB_GETBITMAPFLAGS"
		Case 1066: Return "TB_SETCMDID"
		Case 1067: Return "RB_PUSHCHEVRON"
		Case 1067: Return "TB_CHANGEBITMAP"
		Case 1068: Return "TB_GETBITMAP"
		Case 1069: Return "MSG_GET_DEFFONT"
		Case 1069: Return "TB_GETBUTTONTEXTA"
		Case 1070: Return "TB_REPLACEBITMAP"
		Case 1071: Return "TB_SETINDENT"
		Case 1072: Return "TB_SETIMAGELIST"
		Case 1073: Return "TB_GETIMAGELIST"
		Case 1074: Return "TB_LOADIMAGES"
		Case 1074: Return "EM_CANPASTE"
		Case 1074: Return "TTM_ADDTOOLW"
		Case 1075: Return "EM_DISPLAYBAND"
		Case 1075: Return "TB_GETRECT"
		Case 1075: Return "TTM_DELTOOLW"
		Case 1076: Return "EM_EXGETSEL"
		Case 1076: Return "TB_SETHOTIMAGELIST"
		Case 1076: Return "TTM_NEWTOOLRECTW"
		Case 1077: Return "EM_EXLIMITTEXT"
		Case 1077: Return "TB_GETHOTIMAGELIST"
		Case 1077: Return "TTM_GETTOOLINFOW"
		Case 1078: Return "EM_EXLINEFROMCHAR"
		Case 1078: Return "TB_SETDISABLEDIMAGELIST"
		Case 1078: Return "TTM_SETTOOLINFOW"
		Case 1079: Return "EM_EXSETSEL"
		Case 1079: Return "TB_GETDISABLEDIMAGELIST"
		Case 1079: Return "TTM_HITTESTW"
		Case 1080: Return "EM_FINDTEXT"
		Case 1080: Return "TB_SETSTYLE"
		Case 1080: Return "TTM_GETTEXTW"
		Case 1081: Return "EM_FORMATRANGE"
		Case 1081: Return "TB_GETSTYLE"
		Case 1081: Return "TTM_UPDATETIPTEXTW"
		Case 1082: Return "EM_GETCHARFORMAT"
		Case 1082: Return "TB_GETBUTTONSIZE"
		Case 1082: Return "TTM_ENUMTOOLSW"
		Case 1083: Return "EM_GETEVENTMASK"
		Case 1083: Return "TB_SETBUTTONWIDTH"
		Case 1083: Return "TTM_GETCURRENTTOOLW"
		Case 1084: Return "EM_GETOLEINTERFACE"
		Case 1084: Return "TB_SETMAXTEXTROWS"
		Case 1085: Return "EM_GETPARAFORMAT"
		Case 1085: Return "TB_GETTEXTROWS"
		Case 1086: Return "EM_GETSELTEXT"
		Case 1086: Return "TB_GETOBJECT"
		Case 1087: Return "EM_HIDESELECTION"
		Case 1087: Return "TB_GETBUTTONINFOW"
		Case 1088: Return "EM_PASTESPECIAL"
		Case 1088: Return "TB_SETBUTTONINFOW"
		Case 1089: Return "EM_REQUESTRESIZE"
		Case 1089: Return "TB_GETBUTTONINFOA"
		Case 1090: Return "EM_SELECTIONTYPE"
		Case 1090: Return "TB_SETBUTTONINFOA"
		Case 1091: Return "EM_SETBKGNDCOLOR"
		Case 1091: Return "TB_INSERTBUTTONW"
		Case 1092: Return "EM_SETCHARFORMAT"
		Case 1092: Return "TB_ADDBUTTONSW"
		Case 1093: Return "EM_SETEVENTMASK"
		Case 1093: Return "TB_HITTEST"
		Case 1094: Return "EM_SETOLECALLBACK"
		Case 1094: Return "TB_SETDRAWTEXTFLAGS"
		Case 1095: Return "EM_SETPARAFORMAT"
		Case 1095: Return "TB_GETHOTITEM"
		Case 1096: Return "EM_SETTARGETDEVICE"
		Case 1096: Return "TB_SETHOTITEM"
		Case 1097: Return "EM_STREAMIN"
		Case 1097: Return "TB_SETANCHORHIGHLIGHT"
		Case 1098: Return "EM_STREAMOUT"
		Case 1098: Return "TB_GETANCHORHIGHLIGHT"
		Case 1099: Return "EM_GETTEXTRANGE"
		Case 1099: Return "TB_GETBUTTONTEXTW"
		Case 1100: Return "EM_FINDWORDBREAK"
		Case 1100: Return "TB_SAVERESTOREW"
		Case 1101: Return "EM_SETOPTIONS"
		Case 1101: Return "TB_ADDSTRINGW"
		Case 1102: Return "EM_GETOPTIONS"
		Case 1102: Return "TB_MAPACCELERATORA"
		Case 1103: Return "EM_FINDTEXTEX"
		Case 1103: Return "TB_GETINSERTMARK"
		Case 1104: Return "EM_GETWORDBREAKPROCEX"
		Case 1104: Return "TB_SETINSERTMARK"
		Case 1105: Return "EM_SETWORDBREAKPROCEX"
		Case 1105: Return "TB_INSERTMARKHITTEST"
		Case 1106: Return "EM_SETUNDOLIMIT"
		Case 1106: Return "TB_MOVEBUTTON"
		Case 1107: Return "TB_GETMAXSIZE"
		Case 1108: Return "EM_REDO"
		Case 1108: Return "TB_SETEXTENDEDSTYLE"
		Case 1109: Return "EM_CANREDO"
		Case 1109: Return "TB_GETEXTENDEDSTYLE"
		Case 1110: Return "EM_GETUNDONAME"
		Case 1110: Return "TB_GETPADDING"
		Case 1111: Return "EM_GETREDONAME"
		Case 1111: Return "TB_SETPADDING"
		Case 1112: Return "EM_STOPGROUPTYPING"
		Case 1112: Return "TB_SETINSERTMARKCOLOR"
		Case 1113: Return "EM_SETTEXTMODE"
		Case 1113: Return "TB_GETINSERTMARKCOLOR"
		Case 1114: Return "EM_GETTEXTMODE"
		Case 1114: Return "TB_MAPACCELERATORW"
		Case 1115: Return "EM_AUTOURLDETECT"
		Case 1115: Return "TB_GETSTRINGW"
		Case 1116: Return "EM_GETAUTOURLDETECT"
		Case 1116: Return "TB_GETSTRINGA"
		Case 1117: Return "EM_SETPALETTE"
		Case 1118: Return "EM_GETTEXTEX"
		Case 1119: Return "EM_GETTEXTLENGTHEX"
		Case 1120: Return "EM_SHOWSCROLLBAR"
		Case 1121: Return "EM_SETTEXTEX"
		Case 1123: Return "TAPI_REPLY"
		Case 1124: Return "ACM_OPENA"
		Case 1124: Return "BFFM_SETSTATUSTEXTA"
		Case 1124: Return "CDM_FIRST"
		Case 1124: Return "CDM_GETSPEC"
		Case 1124: Return "EM_SETPUNCTUATION"
		Case 1124: Return "IPM_CLEARADDRESS"
		Case 1124: Return "WM_CAP_UNICODE_START"
		Case 1125: Return "ACM_PLAY"
		Case 1125: Return "BFFM_ENABLEOK"
		Case 1125: Return "CDM_GETFILEPATH"
		Case 1125: Return "EM_GETPUNCTUATION"
		Case 1125: Return "IPM_SETADDRESS"
		Case 1125: Return "PSM_SETCURSEL"
		Case 1125: Return "UDM_SETRANGE"
		Case 1125: Return "WM_CHOOSEFONT_SETLOGFONT"
		Case 1126: Return "ACM_STOP"
		Case 1126: Return "BFFM_SETSELECTIONA"
		Case 1126: Return "CDM_GETFOLDERPATH"
		Case 1126: Return "EM_SETWORDWRAPMODE"
		Case 1126: Return "IPM_GETADDRESS"
		Case 1126: Return "PSM_REMOVEPAGE"
		Case 1126: Return "UDM_GETRANGE"
		Case 1126: Return "WM_CAP_SET_CALLBACK_ERRORW"
		Case 1126: Return "WM_CHOOSEFONT_SETFLAGS"
		Case 1127: Return "ACM_OPENW"
		Case 1127: Return "BFFM_SETSELECTIONW"
		Case 1127: Return "CDM_GETFOLDERIDLIST"
		Case 1127: Return "EM_GETWORDWRAPMODE"
		Case 1127: Return "IPM_SETRANGE"
		Case 1127: Return "PSM_ADDPAGE"
		Case 1127: Return "UDM_SETPOS"
		Case 1127: Return "WM_CAP_SET_CALLBACK_STATUSW"
		Case 1128: Return "BFFM_SETSTATUSTEXTW"
		Case 1128: Return "CDM_SETCONTROLTEXT"
		Case 1128: Return "EM_SETIMECOLOR"
		Case 1128: Return "IPM_SETFOCUS"
		Case 1128: Return "PSM_CHANGED"
		Case 1128: Return "UDM_GETPOS"
		Case 1129: Return "CDM_HIDECONTROL"
		Case 1129: Return "EM_GETIMECOLOR"
		Case 1129: Return "IPM_ISBLANK"
		Case 1129: Return "PSM_RESTARTWINDOWS"
		Case 1129: Return "UDM_SETBUDDY"
		Case 1130: Return "CDM_SETDEFEXT"
		Case 1130: Return "EM_SETIMEOPTIONS"
		Case 1130: Return "PSM_REBOOTSYSTEM"
		Case 1130: Return "UDM_GETBUDDY"
		Case 1131: Return "EM_GETIMEOPTIONS"
		Case 1131: Return "PSM_CANCELTOCLOSE"
		Case 1131: Return "UDM_SETACCEL"
		Case 1132: Return "EM_CONVPOSITION"
		Case 1132: Return "EM_CONVPOSITION"
		Case 1132: Return "PSM_QUERYSIBLINGS"
		Case 1132: Return "UDM_GETACCEL"
		Case 1133: Return "MCIWNDM_GETZOOM"
		Case 1133: Return "PSM_UNCHANGED"
		Case 1133: Return "UDM_SETBASE"
		Case 1134: Return "PSM_APPLY"
		Case 1134: Return "UDM_GETBASE"
		Case 1135: Return "PSM_SETTITLEA"
		Case 1135: Return "UDM_SETRANGE32"
		Case 1136: Return "PSM_SETWIZBUTTONS"
		Case 1136: Return "UDM_GETRANGE32"
		Case 1136: Return "WM_CAP_DRIVER_GET_NAMEW"
		Case 1137: Return "PSM_PRESSBUTTON"
		Case 1137: Return "UDM_SETPOS32"
		Case 1137: Return "WM_CAP_DRIVER_GET_VERSIONW"
		Case 1138: Return "PSM_SETCURSELID"
		Case 1138: Return "UDM_GETPOS32"
		Case 1139: Return "PSM_SETFINISHTEXTA"
		Case 1140: Return "PSM_GETTABCONTROL"
		Case 1141: Return "PSM_ISDIALOGMESSAGE"
		Case 1142: Return "MCIWNDM_REALIZE"
		Case 1142: Return "PSM_GETCURRENTPAGEHWND"
		Case 1143: Return "MCIWNDM_SETTIMEFORMATA"
		Case 1143: Return "PSM_INSERTPAGE"
		Case 1144: Return "EM_SETLANGOPTIONS"
		Case 1144: Return "MCIWNDM_GETTIMEFORMATA"
		Case 1144: Return "PSM_SETTITLEW"
		Case 1144: Return "WM_CAP_FILE_SET_CAPTURE_FILEW"
		Case 1145: Return "EM_GETLANGOPTIONS"
		Case 1145: Return "MCIWNDM_VALIDATEMEDIA"
		Case 1145: Return "PSM_SETFINISHTEXTW"
		Case 1145: Return "WM_CAP_FILE_GET_CAPTURE_FILEW"
		Case 1146: Return "EM_GETIMECOMPMODE"
		Case 1147: Return "EM_FINDTEXTW"
		Case 1147: Return "MCIWNDM_PLAYTO"
		Case 1147: Return "WM_CAP_FILE_SAVEASW"
		Case 1148: Return "EM_FINDTEXTEXW"
		Case 1148: Return "MCIWNDM_GETFILENAMEA"
		Case 1149: Return "EM_RECONVERSION"
		Case 1149: Return "MCIWNDM_GETDEVICEA"
		Case 1149: Return "PSM_SETHEADERTITLEA"
		Case 1149: Return "WM_CAP_FILE_SAVEDIBW"
		Case 1150: Return "EM_SETIMEMODEBIAS"
		Case 1150: Return "MCIWNDM_GETPALETTE"
		Case 1150: Return "PSM_SETHEADERTITLEW"
		Case 1151: Return "EM_GETIMEMODEBIAS"
		Case 1151: Return "MCIWNDM_SETPALETTE"
		Case 1151: Return "PSM_SETHEADERSUBTITLEA"
		Case 1152: Return "MCIWNDM_GETERRORA"
		Case 1152: Return "PSM_SETHEADERSUBTITLEW"
		Case 1153: Return "PSM_HWNDTOINDEX"
		Case 1154: Return "PSM_INDEXTOHWND"
		Case 1155: Return "MCIWNDM_SETINACTIVETIMER"
		Case 1155: Return "PSM_PAGETOINDEX"
		Case 1156: Return "PSM_INDEXTOPAGE"
		Case 1157: Return "DL_BEGINDRAG"
		Case 1157: Return "MCIWNDM_GETINACTIVETIMER"
		Case 1157: Return "PSM_IDTOINDEX"
		Case 1158: Return "DL_DRAGGING"
		Case 1158: Return "PSM_INDEXTOID"
		Case 1159: Return "DL_DROPPED"
		Case 1159: Return "PSM_GETRESULT"
		Case 1160: Return "DL_CANCELDRAG"
		Case 1160: Return "PSM_RECALCPAGESIZES"
		Case 1164: Return "MCIWNDM_GET_SOURCE"
		Case 1165: Return "MCIWNDM_PUT_SOURCE"
		Case 1166: Return "MCIWNDM_GET_DEST"
		Case 1167: Return "MCIWNDM_PUT_DEST"
		Case 1168: Return "MCIWNDM_CAN_PLAY"
		Case 1169: Return "MCIWNDM_CAN_WINDOW"
		Case 1170: Return "MCIWNDM_CAN_RECORD"
		Case 1171: Return "MCIWNDM_CAN_SAVE"
		Case 1172: Return "MCIWNDM_CAN_EJECT"
		Case 1173: Return "MCIWNDM_CAN_CONFIG"
		Case 1174: Return "IE_GETINK"
		Case 1174: Return "IE_MSGFIRST"
		Case 1174: Return "MCIWNDM_PALETTEKICK"
		Case 1175: Return "IE_SETINK"
		Case 1176: Return "IE_GETPENTIP"
		Case 1177: Return "IE_SETPENTIP"
		Case 1178: Return "IE_GETERASERTIP"
		Case 1179: Return "IE_SETERASERTIP"
		Case 1180: Return "IE_GETBKGND"
		Case 1181: Return "IE_SETBKGND"
		Case 1182: Return "IE_GETGRIDORIGIN"
		Case 1183: Return "IE_SETGRIDORIGIN"
		Case 1184: Return "IE_GETGRIDPEN"
		Case 1185: Return "IE_SETGRIDPEN"
		Case 1186: Return "IE_GETGRIDSIZE"
		Case 1187: Return "IE_SETGRIDSIZE"
		Case 1188: Return "IE_GETMODE"
		Case 1189: Return "IE_SETMODE"
		Case 1190: Return "IE_GETINKRECT"
		Case 1190: Return "WM_CAP_SET_MCI_DEVICEW"
		Case 1191: Return "WM_CAP_GET_MCI_DEVICEW"
		Case 1204: Return "WM_CAP_PAL_OPENW"
		Case 1205: Return "WM_CAP_PAL_SAVEW"
		Case 1208: Return "IE_GETAPPDATA"
		Case 1209: Return "IE_SETAPPDATA"
		Case 1210: Return "IE_GETDRAWOPTS"
		Case 1211: Return "IE_SETDRAWOPTS"
		Case 1212: Return "IE_GETFORMAT"
		Case 1213: Return "IE_SETFORMAT"
		Case 1214: Return "IE_GETINKINPUT"
		Case 1215: Return "IE_SETINKINPUT"
		Case 1216: Return "IE_GETNOTIFY"
		Case 1217: Return "IE_SETNOTIFY"
		Case 1218: Return "IE_GETRECOG"
		Case 1219: Return "IE_SETRECOG"
		Case 1220: Return "IE_GETSECURITY"
		Case 1221: Return "IE_SETSECURITY"
		Case 1222: Return "IE_GETSEL"
		Case 1223: Return "IE_SETSEL"
		Case 1224: Return "CDM_LAST"
		Case 1224: Return "EM_SETBIDIOPTIONS"
		Case 1224: Return "IE_DOCOMMAND"
		Case 1224: Return "MCIWNDM_NOTIFYMODE"
		Case 1225: Return "EM_GETBIDIOPTIONS"
		Case 1225: Return "IE_GETCOMMAND"
		Case 1226: Return "EM_SETTYPOGRAPHYOPTIONS"
		Case 1226: Return "IE_GETCOUNT"
		Case 1227: Return "EM_GETTYPOGRAPHYOPTIONS"
		Case 1227: Return "IE_GETGESTURE"
		Case 1227: Return "MCIWNDM_NOTIFYMEDIA"
		Case 1228: Return "EM_SETEDITSTYLE"
		Case 1228: Return "IE_GETMENU"
		Case 1229: Return "EM_GETEDITSTYLE"
		Case 1229: Return "IE_GETPAINTDC"
		Case 1229: Return "MCIWNDM_NOTIFYERROR"
		Case 1230: Return "IE_GETPDEVENT"
		Case 1231: Return "IE_GETSELCOUNT"
		Case 1232: Return "IE_GETSELITEMS"
		Case 1233: Return "IE_GETSTYLE"
		Case 1243: Return "MCIWNDM_SETTIMEFORMATW"
		Case 1244: Return "EM_OUTLINE"
		Case 1244: Return "EM_OUTLINE"
		Case 1244: Return "MCIWNDM_GETTIMEFORMATW"
		Case 1245: Return "EM_GETSCROLLPOS"
		Case 1245: Return "EM_GETSCROLLPOS"
		Case 1246: Return "EM_SETSCROLLPOS"
		Case 1246: Return "EM_SETSCROLLPOS"
		Case 1247: Return "EM_SETFONTSIZE"
		Case 1247: Return "EM_SETFONTSIZE"
		Case 1248: Return "EM_GETZOOM"
		Case 1248: Return "MCIWNDM_GETFILENAMEW"
		Case 1249: Return "EM_SETZOOM"
		Case 1249: Return "MCIWNDM_GETDEVICEW"
		Case 1250: Return "EM_GETVIEWKIND"
		Case 1251: Return "EM_SETVIEWKIND"
		Case 1252: Return "EM_GETPAGE"
		Case 1252: Return "MCIWNDM_GETERRORW"
		Case 1253: Return "EM_SETPAGE"
		Case 1254: Return "EM_GETHYPHENATEINFO"
		Case 1255: Return "EM_SETHYPHENATEINFO"
		Case 1259: Return "EM_GETPAGEROTATE"
		Case 1260: Return "EM_SETPAGEROTATE"
		Case 1261: Return "EM_GETCTFMODEBIAS"
		Case 1262: Return "EM_SETCTFMODEBIAS"
		Case 1264: Return "EM_GETCTFOPENSTATUS"
		Case 1265: Return "EM_SETCTFOPENSTATUS"
		Case 1266: Return "EM_GETIMECOMPTEXT"
		Case 1267: Return "EM_ISIME"
		Case 1268: Return "EM_GETIMEPROPERTY"
		Case 1293: Return "EM_GETQUERYRTFOBJ"
		Case 1294: Return "EM_SETQUERYRTFOBJ"
		Case 1536: Return "FM_GETFOCUS"
		Case 1537: Return "FM_GETDRIVEINFOA"
		Case 1538: Return "FM_GETSELCOUNT"
		Case 1539: Return "FM_GETSELCOUNTLFN"
		Case 1540: Return "FM_GETFILESELA"
		Case 1541: Return "FM_GETFILESELLFNA"
		Case 1542: Return "FM_REFRESH_WINDOWS"
		Case 1543: Return "FM_RELOAD_EXTENSIONS"
		Case 1553: Return "FM_GETDRIVEINFOW"
		Case 1556: Return "FM_GETFILESELW"
		Case 1557: Return "FM_GETFILESELLFNW"
		Case 1625: Return "WLX_WM_SAS"
		Case 2024: Return "SM_GETSELCOUNT"
		Case 2024: Return "UM_GETSELCOUNT"
		Case 2024: Return "WM_CPL_LAUNCH"
		Case 2025: Return "SM_GETSERVERSELA"
		Case 2025: Return "UM_GETUSERSELA"
		Case 2025: Return "WM_CPL_LAUNCHED"
		Case 2026: Return "SM_GETSERVERSELW"
		Case 2026: Return "UM_GETUSERSELW"
		Case 2027: Return "SM_GETCURFOCUSA"
		Case 2027: Return "UM_GETGROUPSELA"
		Case 2028: Return "SM_GETCURFOCUSW"
		Case 2028: Return "UM_GETGROUPSELW"
		Case 2029: Return "SM_GETOPTIONS"
		Case 2029: Return "UM_GETCURFOCUSA"
		Case 2030: Return "UM_GETCURFOCUSW"
		Case 2031: Return "UM_GETOPTIONS"
		Case 2032: Return "UM_GETOPTIONS2"
		Case 4096: Return "LVM_FIRST"
		Case 4096: Return "LVM_GETBKCOLOR"
		Case 4097: Return "LVM_SETBKCOLOR"
		Case 4098: Return "LVM_GETIMAGELIST"
		Case 4099: Return "LVM_SETIMAGELIST"
		Case 4100: Return "LVM_GETITEMCOUNT"
		Case 4101: Return "LVM_GETITEMA"
		Case 4102: Return "LVM_SETITEMA"
		Case 4103: Return "LVM_INSERTITEMA"
		Case 4104: Return "LVM_DELETEITEM"
		Case 4105: Return "LVM_DELETEALLITEMS"
		Case 4106: Return "LVM_GETCALLBACKMASK"
		Case 4107: Return "LVM_SETCALLBACKMASK"
		Case 4108: Return "LVM_GETNEXTITEM"
		Case 4109: Return "LVM_FINDITEMA"
		Case 4110: Return "LVM_GETITEMRECT"
		Case 4111: Return "LVM_SETITEMPOSITION"
		Case 4112: Return "LVM_GETITEMPOSITION"
		Case 4113: Return "LVM_GETSTRINGWIDTHA"
		Case 4114: Return "LVM_HITTEST"
		Case 4115: Return "LVM_ENSUREVISIBLE"
		Case 4116: Return "LVM_SCROLL"
		Case 4117: Return "LVM_REDRAWITEMS"
		Case 4118: Return "LVM_ARRANGE"
		Case 4119: Return "LVM_EDITLABELA"
		Case 4120: Return "LVM_GETEDITCONTROL"
		Case 4121: Return "LVM_GETCOLUMNA"
		Case 4122: Return "LVM_SETCOLUMNA"
		Case 4123: Return "LVM_INSERTCOLUMNA"
		Case 4124: Return "LVM_DELETECOLUMN"
		Case 4125: Return "LVM_GETCOLUMNWIDTH"
		Case 4126: Return "LVM_SETCOLUMNWIDTH"
		Case 4127: Return "LVM_GETHEADER"
		Case 4129: Return "LVM_CREATEDRAGIMAGE"
		Case 4130: Return "LVM_GETVIEWRECT"
		Case 4131: Return "LVM_GETTEXTCOLOR"
		Case 4132: Return "LVM_SETTEXTCOLOR"
		Case 4133: Return "LVM_GETTEXTBKCOLOR"
		Case 4134: Return "LVM_SETTEXTBKCOLOR"
		Case 4135: Return "LVM_GETTOPINDEX"
		Case 4136: Return "LVM_GETCOUNTPERPAGE"
		Case 4137: Return "LVM_GETORIGIN"
		Case 4138: Return "LVM_UPDATE"
		Case 4139: Return "LVM_SETITEMSTATE"
		Case 4140: Return "LVM_GETITEMSTATE"
		Case 4141: Return "LVM_GETITEMTEXTA"
		Case 4142: Return "LVM_SETITEMTEXTA"
		Case 4143: Return "LVM_SETITEMCOUNT"
		Case 4144: Return "LVM_SORTITEMS"
		Case 4145: Return "LVM_SETITEMPOSITION32"
		Case 4146: Return "LVM_GETSELECTEDCOUNT"
		Case 4147: Return "LVM_GETITEMSPACING"
		Case 4148: Return "LVM_GETISEARCHSTRINGA"
		Case 4149: Return "LVM_SETICONSPACING"
		Case 4150: Return "LVM_SETEXTENDEDLISTVIEWSTYLE"
		Case 4151: Return "LVM_GETEXTENDEDLISTVIEWSTYLE"
		Case 4152: Return "LVM_GETSUBITEMRECT"
		Case 4153: Return "LVM_SUBITEMHITTEST"
		Case 4154: Return "LVM_SETCOLUMNORDERARRAY"
		Case 4155: Return "LVM_GETCOLUMNORDERARRAY"
		Case 4156: Return "LVM_SETHOTITEM"
		Case 4157: Return "LVM_GETHOTITEM"
		Case 4158: Return "LVM_SETHOTCURSOR"
		Case 4159: Return "LVM_GETHOTCURSOR"
		Case 4160: Return "LVM_APPROXIMATEVIEWRECT"
		Case 4161: Return "LVM_SETWORKAREAS"
		Case 4162: Return "LVM_GETSELECTIONMARK"
		Case 4163: Return "LVM_SETSELECTIONMARK"
		Case 4164: Return "LVM_SETBKIMAGEA"
		Case 4165: Return "LVM_GETBKIMAGEA"
		Case 4166: Return "LVM_GETWORKAREAS"
		Case 4167: Return "LVM_SETHOVERTIME"
		Case 4168: Return "LVM_GETHOVERTIME"
		Case 4169: Return "LVM_GETNUMBEROFWORKAREAS"
		Case 4170: Return "LVM_SETTOOLTIPS"
		Case 4171: Return "LVM_GETITEMW"
		Case 4172: Return "LVM_SETITEMW"
		Case 4173: Return "LVM_INSERTITEMW"
		Case 4174: Return "LVM_GETTOOLTIPS"
		Case 4179: Return "LVM_FINDITEMW"
		Case 4183: Return "LVM_GETSTRINGWIDTHW"
		Case 4191: Return "LVM_GETCOLUMNW"
		Case 4192: Return "LVM_SETCOLUMNW"
		Case 4193: Return "LVM_INSERTCOLUMNW"
		Case 4211: Return "LVM_GETITEMTEXTW"
		Case 4212: Return "LVM_SETITEMTEXTW"
		Case 4213: Return "LVM_GETISEARCHSTRINGW"
		Case 4214: Return "LVM_EDITLABELW"
		Case 4235: Return "LVM_GETBKIMAGEW"
		Case 4236: Return "LVM_SETSELECTEDCOLUMN"
		Case 4237: Return "LVM_SETTILEWIDTH"
		Case 4238: Return "LVM_SETVIEW"
		Case 4239: Return "LVM_GETVIEW"
		Case 4241: Return "LVM_INSERTGROUP"
		Case 4243: Return "LVM_SETGROUPINFO"
		Case 4245: Return "LVM_GETGROUPINFO"
		Case 4246: Return "LVM_REMOVEGROUP"
		Case 4247: Return "LVM_MOVEGROUP"
		Case 4250: Return "LVM_MOVEITEMTOGROUP"
		Case 4251: Return "LVM_SETGROUPMETRICS"
		Case 4252: Return "LVM_GETGROUPMETRICS"
		Case 4253: Return "LVM_ENABLEGROUPVIEW"
		Case 4254: Return "LVM_SORTGROUPS"
		Case 4255: Return "LVM_INSERTGROUPSORTED"
		Case 4256: Return "LVM_REMOVEALLGROUPS"
		Case 4257: Return "LVM_HASGROUP"
		Case 4258: Return "LVM_SETTILEVIEWINFO"
		Case 4259: Return "LVM_GETTILEVIEWINFO"
		Case 4260: Return "LVM_SETTILEINFO"
		Case 4261: Return "LVM_GETTILEINFO"
		Case 4262: Return "LVM_SETINSERTMARK"
		Case 4263: Return "LVM_GETINSERTMARK"
		Case 4264: Return "LVM_INSERTMARKHITTEST"
		Case 4265: Return "LVM_GETINSERTMARKRECT"
		Case 4266: Return "LVM_SETINSERTMARKCOLOR"
		Case 4267: Return "LVM_GETINSERTMARKCOLOR"
		Case 4269: Return "LVM_SETINFOTIP"
		Case 4270: Return "LVM_GETSELECTEDCOLUMN"
		Case 4271: Return "LVM_ISGROUPVIEWENABLED"
		Case 4272: Return "LVM_GETOUTLINECOLOR"
		Case 4273: Return "LVM_SETOUTLINECOLOR"
		Case 4275: Return "LVM_CANCELEDITLABEL"
		Case 4276: Return "LVM_MAPINDEXTOID"
		Case 4277: Return "LVM_MAPIDTOINDEX"
		Case 4278: Return "LVM_ISITEMVISIBLE"
		Case 8192: Return "OCM__BASE"
		Case 8197: Return "LVM_SETUNICODEFORMAT"
		Case 8198: Return "LVM_GETUNICODEFORMAT"
		Case 8217: Return "OCM_CTLCOLOR"
		Case 8235: Return "OCM_DRAWITEM"
		Case 8236: Return "OCM_MEASUREITEM"
		Case 8237: Return "OCM_DELETEITEM"
		Case 8238: Return "OCM_VKEYTOITEM"
		Case 8239: Return "OCM_CHARTOITEM"
		Case 8249: Return "OCM_COMPAREITEM"
		Case 8270: Return "OCM_NOTIFY"
		Case 8465: Return "OCM_COMMAND"
		Case 8468: Return "OCM_HSCROLL"
		Case 8469: Return "OCM_VSCROLL"
		Case 8498: Return "OCM_CTLCOLORMSGBOX"
		Case 8499: Return "OCM_CTLCOLOREDIT"
		Case 8500: Return "OCM_CTLCOLORLISTBOX"
		Case 8501: Return "OCM_CTLCOLORBTN"
		Case 8502: Return "OCM_CTLCOLORDLG"
		Case 8503: Return "OCM_CTLCOLORSCROLLBAR"
		Case 8504: Return "OCM_CTLCOLORSTATIC"
		Case 8720: Return "OCM_PARENTNOTIFY"
		Case 32768: Return "WM_APP"
		Case 39998: Return "CM_NOTIFYCHILD"
		Case 39999: Return "CM_CHANGEIMAGE"
		Case 40000: Return "CM_CTLCOLOR"
		Case 40001: Return "CM_COMMAND"
		Case 40002: Return "CM_NOTIFY"
		Case 40003: Return "CM_HSCROLL"
		Case 40004: Return "CM_VSCROLL"
		Case 40005: Return "CM_MEASUREITEM"
		Case 40006: Return "CM_DRAWITEM"
		Case 40007: Return "CM_HELPCONTEXT"
		Case 40008: Return "CM_CANCELMODE"
		Case 40010: Return "CM_HELP"
		Case 40011: Return "CM_NEEDTEXT"
		Case 52429: Return "WM_RASDIALEVENT"
		Case Else: Return "Unknown message (Code: " & Message & ")"
		End Select
	End Function
#EndIf

Function ErrDescription(Code As Integer) ByRef As WString
    Select Case Code
    Case 0: Return "No error"
    Case 1: Return "Illegal function call"
    Case 2: Return "File not found signal"
    Case 3: Return "File I/O error"
    Case 4: Return "Out of memory" 
    Case 5: Return "Illegal resume" 
    Case 6: Return "Out of bounds array access"
    Case 7: Return "Null Pointer Access"
    Case 8: Return "No privileges"
    Case 9: Return "Interrupted signal" 
    Case 10: Return "Illegal instruction signal" 
    Case 11: Return "Floating point error signal"
    Case 12: Return "Segmentation violation signal"
    Case 13: Return "Termination request signal"
    Case 14: Return "Abnormal termination signal"
    Case 15: Return "Quit request signal"
    Case 16: Return "Return without gosub"
    Case 17: Return "End of file"
    Case Else: Return ""
    End Select
End Function

Public Function _Abs(Value As Boolean) As Integer
    Return Abs(CInt(Value))
End Function

Function InStrCount(ByRef subject As WString, ByRef searchtext AS Wstring, start As Integer = 1) As Integer
    Dim As Integer n, c, ls = Len(searchtext)
    If subject <> "" And searchtext <> "" Then
        n = Instr(start, subject, searchtext)
        Do While n <> 0
            c = c + 1
            n = Instr(n + ls, subject, searchtext)
        Loop
    Endif
    Return c
End Function

'Function InStrPos(ByRef subject As WString, ByRef searchtext() AS Wstring, start As Integer = 1) As Integer
    'FOr i As Integer = 1 To Len(subject)
        'For j As Integer = 0 To Ubound(searchtext)
            'If Mid(subject, i, Len(searchtext(j)) = searchtext(j) Then Return i
        'Next j
    'Next
    'Return 0
'End Function
'
'Function InStrRevPos(ByRef subject As WString, ByRef searchtext() AS Wstring, start As Integer = 1) As Integer
    'FOr i As Integer = Len(subject) To 1 Step -1
        'For j As Integer = 0 To Ubound(searchtext)
            'If Mid(subject, i, Len(searchtext(j)) = searchtext(j) Then Return i
        'Next j
    'Next
    'Return 0
'End Function

Sub Split(ByRef subject As WString, ByRef Delimiter As Wstring, result() As Wstring Ptr)
    Dim As Integer i = 1, n, l, ls = Len(subject), p = 1
    While i <= ls
        l = Len(delimiter)
        If Mid(subject, i, l) = delimiter Then
            n = n + 1
            Redim Preserve result(n - 1)
            WLet result(n - 1), Mid(subject, p, i - p)
            p = i + l
            i = p
            Continue While
        EndIf
        i = i + 1
    Wend
    n = n + 1
    Redim Preserve result(n - 1)
    WLet result(n - 1), Mid(subject, p, i - p)
End Sub

Dim Shared sReplaceText(10) As WString Ptr

Function Replace(ByRef subject As WString, ByRef oldtext As const WString, ByRef newtext As const WString, ByVal start As Integer = 1, byref count as integer = 0, memnumber As Integer = 0) ByRef As WString
    Dim As Integer n, c, ls = Len(subject), lo = Len(oldtext), ln = Len(newtext)
    If subject <> "" And oldtext <> "" And oldtext <> newtext Then
        WReallocate sReplaceText(memnumber), ls / lo * IIF(lo > ln, lo, ln)
        *sReplaceText(memnumber) = subject
        n = Instr(start, *sReplaceText(memnumber), oldtext)
        Do While n <> 0
            c = c + 1
            *sReplaceText(memnumber) = Left(*sReplaceText(memnumber), n - 1) & newtext & Mid(*sReplaceText(memnumber), n + lo)
            n = Instr(n + ln, *sReplaceText(memnumber), oldtext)
        Loop
        count = c
        Return *sReplaceText(memnumber)
    Else
        Return subject
    Endif
End Function

Function StartsWith(ByRef a As WString, ByRef b As WString) As Boolean
    Return Left(a, Len(b)) = b
End Function

Function EndsWith(ByRef a As WString, ByRef b As WString) As Boolean
    Return Right(a, Len(b)) = b
End Function
