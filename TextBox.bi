'###############################################################################
'#  Edit.bi                                                                    #
'#  This file is part of MyFBFramework                                       #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

namespace My.Sys.Forms
    #DEFINE QTextBox(__Ptr__) *Cast(TextBox Ptr,__Ptr__)

    Enum CharCase
        ecNone,ecLower,ecUpper
    End Enum

    Type TextBox Extends Control
        Private:
            Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
        Protected:
            FTopLine          As Integer
            FSelStart         As Integer
            FSelLength        As Integer
            FSelEnd              As Integer
            FSelText          As WString Ptr
            FLine              As WString Ptr
            FCharCase         As Integer
            FMasked           As Boolean
            FMaskChar         As Byte
            FBorderStyle      As Integer
            FReadOnly         As Boolean
            FCtl3D            As Boolean
            FHideSelection    As Boolean
            FOEMConvert       As Boolean
            FMaxLength        As Integer 
            FModified         As Boolean
            ACharCase(3)      As Long
            AMaskStyle(2)     As Long
            ABorderExStyle(2) As Long 
            ABorderStyle(2)   As Long
            AOEMConvert(2)    As Long
            AHideSelection(2) As Long
            FWantReturn As Boolean
            FMultiline As Boolean
            FScrollBars As Integer
            FWordWraps As Integer
            Declare Static Sub WndProc(BYREF message As Message)
            Declare Virtual Sub ProcessMessage(BYREF message As Message)
        Public:
            Declare Sub Add(ByRef wsLine As WString)
            Declare Sub Insert(Index As Integer, ByRef wsLine As WString)
            Declare Sub Remove(Index As Integer)        
            Declare Sub GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
            Declare Sub GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
            Declare Sub SetSel(iSelStart As Integer, iSelEnd As Integer)
            Declare Sub SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
            Declare Function GetLineFromCharIndex(Index As Integer = -1) As Integer
            Declare Function GetCharIndexFromLine(Index As Integer) As Integer
            Declare Function GetLineLength(Index As Integer) As Integer
            Declare Property BorderStyle As Integer
            Declare Property BorderStyle(Value As Integer)
            Declare Property ReadOnly As Boolean
            Declare Property ReadOnly(Value As Boolean)
            Declare Property Ctl3D As Boolean
            Declare Property Ctl3D(Value As Boolean)
            Declare Property HideSelection As Boolean
            Declare Property HideSelection(Value As Boolean)
            Declare Property OEMConvert As Boolean
            Declare Property OEMConvert(Value As Boolean)
            Declare Property MaxLength As Integer
            Declare Property MaxLength(Value As Integer)
            Declare Property Modified As Boolean
            Declare Property Modified(Value As Boolean)   
            Declare Property CharCase As Integer
            Declare Property CharCase(Value As Integer)
            Declare Property Masked As Boolean
            Declare Property Masked(Value As Boolean)
            Declare Property MaskChar As Byte
            Declare Property MaskChar(Value As Byte)
            Declare Property Lines(Index As Integer) ByRef As WString
            Declare Property Lines(Index As Integer, ByRef Value As WString)
            Declare Property LinesCount As Integer
            Declare Property LinesCount(Value As Integer)
            Declare Property CaretPos As Point
            Declare Property CaretPos(Value As Point)        
            Declare Property SelStart As Integer
            Declare Property SelStart(Value As Integer)
            Declare Property SelEnd As Integer
            Declare Property SelEnd(Value As Integer)
            Declare Property SelLength As Integer
            Declare Property SelLength(Value As Integer)
            Declare Property SelText ByRef As WString
            Declare Property SelText(ByRef Value As WString)
            Declare Property ScrollBars As Integer
            Declare Property ScrollBars(Value As Integer)
            Declare Property TopLine As Integer
            Declare Property TopLine(Value as Integer)
            Declare Property WordWraps As Integer
            Declare Property WordWraps(Value as Integer)
            Declare Property WantReturn() As Boolean
            Declare Property WantReturn(Value As Boolean)
            Declare Property Multiline() As Boolean
            Declare Property Multiline(Value As Boolean)
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Sub Clear
            Declare Sub ClearUndo
            Declare Function CanUndo As Boolean
            Declare Sub Undo
            Declare Sub PasteFromClipboard
            Declare Sub CopyToClipboard
            Declare Sub CutToClipboard
            Declare Sub SelectAll
            Declare Sub ScrollToCaret
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Constructor
            Declare Destructor
            OnChange   As Sub(BYREF Sender As TextBox)
            OnGotFocus   As Sub(BYREF Sender As TextBox)
            OnLostFocus   As Sub(BYREF Sender As TextBox)
            OnHScroll   As Sub(BYREF Sender As TextBox)
            OnVScroll   As Sub(BYREF Sender As TextBox)
            OnCut As Sub(BYREF Sender As TextBox)
            OnCopy As Sub(BYREF Sender As TextBox)
            OnPaste As Sub(BYREF Sender As TextBox, ByRef Action As Integer)
    End Type

    Sub TextBox.ScrollToCaret()
        Perform EM_SCROLLCARET, 0, 0
    End Sub
    
    Property TextBox.WantReturn() As Boolean
        FWantReturn = StyleExists(ES_WANTRETURN)
        Return FWantReturn
    End Property
            
    Property TextBox.WantReturn(Value As Boolean)
        FWantReturn = Value
        ChangeStyle ES_WANTRETURN, Value
    End Property
  
    Property TextBox.Multiline() As Boolean
        Return FMultiline
    End Property
            
    Property TextBox.Multiline(Value As Boolean)
        FMultiline = Value
        If FMultiline Then
            Base.Style = Base.Style Or ES_MULTILINE Or ES_WANTRETURN
        Else
            Base.Style = Base.Style And Not ES_MULTILINE And Not ES_WANTRETURN
        End If
    End Property

    Sub TextBox.Add(ByRef wsLine As WString)
        Insert(LinesCount - 1, wsLine)
    end Sub

    Sub TextBox.Insert(Index As Integer, ByRef wsLine As WString)
        Dim As Integer iStart, LineLen
        Dim As WString Ptr sLine = CAllocate(MAXLENGTH * SizeOf(WString))
        If Index >= 0 Then
            iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
            If iStart >= 0 Then
                *sLine = wsline + WChr(13) & WChr(10) 
            Else
              iStart = SendMessage(FHandle, EM_LINEINDEX, Index - 1, 0)
              If iStart < 0 then Exit Sub
              LineLen = SendMessage(FHandle, EM_LINELENGTH, SelStart,0)
              if LineLen = 0 then Exit Sub
              iStart += LineLen
              *sLine = WChr(13) & WChr(10) + wsLine
           end if
           SendMessage(FHandle, EM_SETSEL, iStart, iStart)
           SendMessage(FHandle, EM_REPLACESEL, 0, cint(sLine))
        end if
    end Sub

    Sub TextBox.Remove(Index As Integer)
        Const Empty = ""
        Dim As Integer iStart, iEnd
        iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
        if iStart >= 0 then
           iEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0)
           if iEnd < 0 then iEnd = iStart + SendMessage(FHandle, EM_LINELENGTH, iStart, 0)
           SendMessage(FHandle, EM_SETSEL, iStart, iEnd)
           SendMessage(FHandle, EM_REPLACESEL, 0, cint(strptr(Empty)))
        End If
    End Sub
            
    Property TextBox.BorderStyle As Integer
        Return FBorderStyle
    End Property

    Property TextBox.BorderStyle(Value As Integer)
        FBorderStyle = Value
        If FBorderStyle Then
            Base.Style = Base.Style Or WS_BORDER
            Base.ExStyle = WS_EX_CLIENTEDGE
        Else
            Base.Style = Base.Style And Not WS_BORDER
            Base.ExStyle = 0
        End If
    End Property

    Property TextBox.ReadOnly As Boolean
        Return FReadOnly
    End Property

    Property TextBox.ReadOnly(Value As Boolean)
        FReadOnly = Value
        If Handle Then Perform(EM_SETREADONLY,FReadOnly,0)
    End Property

    Property TextBox.Ctl3D As Boolean
        Return FCtl3D
    End Property

    Property TextBox.Ctl3D(Value As Boolean)
        If Value <> FCtl3D Then
            FCtl3D = Value
            RecreateWnd
        End If
    End Property

    Property TextBox.HideSelection As Boolean
        Return FHideSelection
    End Property

    Property TextBox.HideSelection(Value As Boolean)
        FHideSelection = Value
        If Not FHideSelection Then Base.Style = Base.Style Or ES_NOHIDESEL Else Base.Style = Base.Style And Not ES_NOHIDESEL
    End Property

    Property TextBox.OEMConvert As Boolean
        Return FOEMConvert
    End Property

    Property TextBox.OEMConvert(Value As Boolean)
        If Value <> FOEMConvert Then
            FOEMConvert = Value
            RecreateWnd
        End If
    End Property

    Property TextBox.CharCase As Integer
        Return FCharCase
    End Property

    Property TextBox.CharCase(Value As Integer)
        If FCharCase <> Value Then
            FCharCase = Value
            RecreateWnd
        End If    
    End Property

    Property TextBox.Masked As Boolean
        Return FMasked
    End Property

    Property TextBox.Masked(Value As Boolean)
        FMasked = Value
        If Handle Then 
            If FMasked Then
                Perform(EM_SETPASSWORDCHAR,FMaskChar,0)
            Else
                Perform(EM_SETPASSWORDCHAR,0,0)
            End If
        End If
    End Property

    Property TextBox.MaskChar As Byte
        Return FMaskChar
    End Property

    Property TextBox.MaskChar(Value As Byte)
        FMaskChar = Value
        If Handle Then Perform(EM_SETPASSWORDCHAR,FMaskChar,0)
    End Property
    
    Property TextBox.TopLine As Integer
        If FHandle Then FTopLine = Perform(EM_GETFIRSTVISIBLELINE, 0, 0)
        Return FTopLine
    End Property

    Property TextBox.TopLine(Value As Integer)
        FTopLine = Value
        If FHandle Then Perform(10012, FTopLine, 0)
    End Property
    
    Sub TextBox.LoadFromFile(ByRef File As WString)
        Dim Result As Integer
        Result = Open(File For Input Encoding "utf-32" As #1)
        If Result <> 0 Then Result = Open(File For Input Encoding "utf-16" As #1)
        If Result <> 0 Then Result = Open(File For Input Encoding "utf-8" As #1)
        If Result <> 0 Then Result = Open(File For Input As #1)
        If Result = 0 Then
            FText = Cast(Wstring Ptr, ReAllocate(FText, (LOF(1) + 1) * SizeOf(WString)))
            *FText = WInput(LOF(1), #1)
            If FHandle Then SetWindowText(FHandle, FText)
            Close #1
        End If
    End Sub

    Sub TextBox.SaveToFile(ByRef File As WString)
        if Open(File For Output Encoding "utf-8" As #1) = 0 Then
            Print #1, Text;
        end if
        Close #1
    end Sub

    Function TextBox.GetLineLength(Index As Integer = -1) As Integer
        If FHandle Then
            Dim As Integer CharIndex = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
            Return SendMessage(FHandle, EM_LINELENGTH, CharIndex, 0)
        end if
        Return -1
    End Function
    
    Function TextBox.GetLineFromCharIndex(Index As Integer = -1) As Integer
        If FHandle Then
            Return SendMessage(FHandle, EM_LINEFROMCHAR, Index, 0)
        end if
        Return -1
    End Function
    
    Function TextBox.GetCharIndexFromLine(Index As Integer) As Integer
        If FHandle Then
            Return SendMessage(FHandle, EM_LINEINDEX, Index, 0)
        end if
        Return -1
    End Function
    
    Property TextBox.Lines(Index As Integer) ByRef As WString
        if FHandle Then
            Dim As Integer lThisChar = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
            Dim As Integer lChar = SendMessage(FHandle, em_linelength, lThisChar, 0)
            WLet FLine, WSpace(lChar)
            Mid(*FLine, 1, 1) = WChr(lChar And &HFF)
            Mid(*FLine, 2, 1) = WChr(lChar \ &H100)
            SendMessage(FHandle, em_getline, Index, cint(FLine))
            Return *FLine
        end if
        Return ""
    end Property

    Property TextBox.Lines(Index As Integer, ByRef Value As WString)
        If FHandle Then
            Dim As Integer iStart, iEnd
            iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
            if iStart >= 0 then
                iEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0)
                if iEnd < 0 then iEnd = iStart + SendMessage(FHandle, EM_LINELENGTH, iStart, 0)
                SendMessage(FHandle, EM_SETSEL, iStart, iEnd)
                SendMessage(FHandle, EM_REPLACESEL, True, CInt(@Value))
            End If
        End If
    End Property

    Sub TextBox.GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
        If FHandle Then
            SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), Cint(@iSelEnd))
        End If
    End Sub

    Sub TextBox.GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
        If FHandle Then
            Dim As Integer iSelStart, iSelEnd
            SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), Cint(@iSelEnd))
            iSelStartRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelStart, 0)
            iSelStartCol = iSelStart - SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0)
            iSelEndRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelEnd, 0)
            iSelEndCol = iSelStart - SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0)
        End If
    End Sub

    Sub TextBox.SetSel(iSelStart As Integer, iSelEnd As Integer)
        If FHandle Then
            SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
        End If
    End Sub

    Sub TextBox.SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
        If FHandle Then
            Dim As Integer iSelStart, iSelEnd
            iSelStart = SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0) + iSelStartCol
            iSelEnd = SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0) + iSelEndCol
            SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
        End If
    End Sub

    Property TextBox.LinesCount As Integer
        If FHandle Then
            Return SendMessage(FHandle, EM_GetLineCount, 0, 0)
        End If
        Return 0
    end Property

    Property TextBox.LinesCount(Value As Integer)
    End Property

    Property TextBox.CaretPos As Point
        If FHandle then
           Dim As Integer x, y 
           x = hiword(SendMessage(FHandle, EM_GETSEL, 0, 0))
           y = SendMessage(FHandle, EM_LINEFROMCHAR, x, 0)
           x = x - SendMessage(FHandle, EM_LINEINDEX, -1, 0)
           Return Type(x, y)
        End If
        Return Type(0, 0)
    end Property

    Property TextBox.CaretPos(value As Point)
    End Property

    Property TextBox.ScrollBars As Integer
        return FScrollBars
    End Property

    Property TextBox.ScrollBars(Value As Integer)
        FScrollBars = Value
        Select Case FScrollBars
        Case 0
            FStyle = FStyle And Not (ws_hscroll Or ws_vscroll)
        Case 1
            FStyle = (FStyle And Not ws_hscroll) Or ws_vscroll
        Case 2
            FStyle = (FStyle And Not ws_vscroll) Or ws_hscroll
        Case 3
            FStyle = FStyle Or (ws_hscroll Or ws_vscroll)
        End Select
    end Property

    Property TextBox.WordWraps As Integer
        Return FWordWraps
    End Property

    Property TextBox.WordWraps(Value As Integer)
        FWordWraps = value
        If Value Then
           FStyle = FStyle And Not es_autohscroll 
        Else
           FStyle = FStyle Or es_autohscroll
        End If
    End Property

    Property TextBox.SelStart As Integer
        Dim As Integer LStart
        SendMessage(Handle, EM_GETSEL, CInt(@LStart), 0)
        FSelStart = LStart
        Return FSelStart
    End Property

    Property TextBox.SelStart(Value As Integer)
        FSelStart = Value
        SendMessage(Handle, EM_SETSEL, Value, Value)
    End Property

    Property TextBox.SelLength As Integer
        Dim As Integer LStart,LEnd
        SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
        FSelLength = LEnd - LStart
        Return FSelLength
    End Property

    Property TextBox.SelLength(Value As Integer)
        Dim As Integer LStart,LEnd,FEnd
        FSelLength = Value
        SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
        FEnd = LStart + Value
        SendMessage(Handle, EM_SETSEL, LStart, FEnd)
        SendMessage(Handle, EM_SCROLLCARET, 0,0)
    End Property

    Property TextBox.SelEnd As Integer
        Dim As Integer LEnd
        SendMessage(Handle, EM_GETSEL, 0, CInt(@LEnd))
        FSelEnd = LEnd
        Return FSelEnd
    End Property

    Property TextBox.SelEnd(Value As Integer)
        Dim As Integer LStart, LEnd, FEnd
        FSelEnd = Value
        SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
        SendMessage(Handle, EM_SETSEL, LStart, FSelEnd)
        SendMessage(Handle, EM_SCROLLCARET, 0,0)
    End Property

    Property TextBox.SelText ByRef As WString
        If FHandle Then
            Dim As Integer LStart, LEnd
            SendMessage(FHandle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
            If LEnd - LStart <= 0 Then
                FSelText = Reallocate(FSelText, SizeOf(WString))
                *FSelText = ""
            Else
                FSelText = Reallocate(FSelText, (LEnd - LStart + 1 + 1) * SizeOf(WString))
                *FSelText = Mid(Text, LStart + 1, LEnd - LStart)
            End If
        End If
        Return *FSelText
    End Property

    Property TextBox.SelText(ByRef Value As WString)
        FSelText = Reallocate(FSelText, (Len(Value) + 1) * SizeOf(WString))
        *FSelText = Value
        SendMessage(FHandle, EM_REPLACESEL, 0, CInt(FSelText))
    End Property

    Property TextBox.MaxLength As Integer
        Return FMaxLength   
    End Property

    Property TextBox.MaxLength(Value As Integer)
        FMaxLength = Value
        If Handle Then Perform(EM_LIMITTEXT, Value, 0)
    End Property

    Property TextBox.Modified As Boolean
        If Handle Then
           FModified = (Perform(EM_GETMODIFY, 0, 0) <> 0)
        End If  
        Return FModified 
    End Property

    Property TextBox.Modified(Value As Boolean) 
        If Handle Then
           Perform(EM_SETMODIFY, Cast(Byte,Value), 0) 
        Else
           FModified = Value
        End If
    End Property

    Sub TextBox.WndProc(BYREF message As Message)
    End Sub

    Sub TextBox.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QTextBox(Sender.Child)
                'If .MaxLength <> 0 Then
                .Perform(EM_LIMITTEXT, -1, 0)
                If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
                    '.MaxLength = .MaxLength
                'End If
            End With
        End If
    End Sub
    
    Sub TextBox.ProcessMessage(BYREF message As Message)
        Select Case message.Msg
        Case CM_CTLCOLOR
            Static As HDC Dc
            Dc = Cast(HDC,Message.wParam)
            SetBKMode Dc, TRANSPARENT
            SetTextColor Dc,Font.Color
            SetBKColor Dc,This.Color
            SetBKMode Dc,OPAQUE
        Case CM_COMMAND
            Select Case Message.wParamHi
            Case BN_CLICKED
                If OnClick Then OnClick(This)
            Case EN_CHANGE
                If OnChange Then OnChange(This)
            Case EN_UPDATE
                If OnUpdate Then OnUpdate(This)
            Case EN_KILLFOCUS
                If OnLostFocus Then OnLostFocus(This)
            Case EN_SETFOCUS
                If OnGotFocus Then OnGotFocus(This)
            Case EN_VSCROLL
                If OnVScroll Then OnVScroll(This)
            Case EN_HSCROLL
                If OnHScroll Then OnHScroll(This)
            End Select
            message.result = 0
        Case WM_CUT
            If OnCut Then OnCut(This)
        Case WM_COPY
            If OnCopy Then OnCopy(This)
        Case WM_PASTE
            Dim Action AS Integer = 1
            If OnPaste Then OnPaste(This, Action)
            Select Case Action
            Case 0: message.result = -1
            Case 1: message.result = 0
            End Select
        End Select
        Base.ProcessMessage(message)
    End Sub

    Sub TextBox.Clear
        Text = ""
    End Sub

    Sub TextBox.ClearUndo
        If FHandle Then Perform(EM_EMPTYUNDOBUFFER, 0, 0)
    End Sub

    Function TextBox.CanUndo As Boolean
        If FHandle Then 
           Return (Perform(EM_CANUNDO, 0, 0) <> 0)
       Else
           Return 0
       End If
    End Function

    Sub TextBox.Undo
        If FHandle Then Perform(WM_UNDO, 0, 0)
    End Sub

    Sub TextBox.PasteFromClipboard
        If FHandle Then Perform(WM_PASTE, 0, 0)
    End Sub

    Sub TextBox.CopyToClipboard
        If FHandle Then Perform(WM_COPY, 0, 0)
    End Sub

    Sub TextBox.CutToClipboard
        If FHandle Then Perform(WM_CUT, 0, 0)
    End Sub

    Sub TextBox.SelectAll
        If FHandle Then Perform(EM_SETSEL, 0, -1)
    End Sub

    Operator TextBox.Cast As My.Sys.Forms.Control Ptr 
        Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor TextBox
        'FSelText = CAllocate(0)
        ACharCase(0)      = 0
        ACharCase(1)      = ES_UPPERCASE
        ACharCase(2)      = ES_LOWERCASE
        AMaskStyle(0)     = 0
        AMaskStyle(1)     = ES_PASSWORD
        ABorderExStyle(0) = 0 
        ABorderExStyle(1) = WS_EX_CLIENTEDGE
        ABorderStyle(0)   = 0 
        ABorderStyle(1)   = WS_BORDER
        AOEMConvert(0)    = 0
        AOEMConvert(1)    = ES_OEMCONVERT
        AHideSelection(0) = ES_NOHIDESEL 
        AHideSelection(1) = 0
        FHideSelection    = 1
        FCtl3D            = True 
        FMaskChar         = Asc("*")
        FMaxLength          = 64000
        FEnabled = True
        FTabStop = True
        With This
            .OnHandleIsAllocated = @HandleIsAllocated
            .ClassName = "TextBox"
            .ClassAncestor = "Edit"
            .Child       = @This
            .ChildProc   = @WndProc
            .ExStyle     = WS_EX_CLIENTEDGE ' OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL
            .Style       = WS_CHILD Or ES_AUTOHSCROLL Or WS_TABSTOP Or ES_WANTRETURN Or ACharCase(Abs_(FCharCase)) OR AMaskStyle(Abs_(FMasked)) OR AOEMConvert(Abs_(FOEMConvert)) OR AHideSelection(Abs_(FHideSelection))
            .Width       = 121
            .Height      = 21
            .Color       = GetSysColor(COLOR_WINDOW)
            '.Cursor      = LoadCursor(NULL, IDC_IBEAM)
            .RegisterClass "TextBox", "Edit"
        End With
    End Constructor

    Destructor TextBox
        If FSelText Then Deallocate FSelText
        If FLine Then Deallocate FLine
    End Destructor
End Namespace
