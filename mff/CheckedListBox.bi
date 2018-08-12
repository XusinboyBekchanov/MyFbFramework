'###############################################################################
'#  CheckedListBox.bi                                                                 #
'#  This file is part of MyFBFramework                                       #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"
#Include Once "ListItems.bi"

Namespace My.Sys.Forms
    #DEFINE QCheckedListBox(__Ptr__) *Cast(CheckedListBox Ptr,__Ptr__)

    Type CheckedListBox Extends Control
        Private:
            FBorderStyle      As Integer
            FSort             As Boolean
            FSelCount         As Integer
            FSelItems         As Integer Ptr
            FTopIndex         As Integer
            FItemIndex        As Integer
            FItemHeight       As Integer
            FMultiselect      As Boolean
            FExtendSelect     As Boolean
            FColumns          As Integer
            FIntegralHeight   As Boolean
            FCtl3D            As Boolean
            ABorderStyle(3)   As Integer
            ABorderExStyle(2) As Integer
            AStyle(3)         As Integer
            ASortStyle(2)     As Integer
            AMultiselect(2)   As Integer
            AExtendSelect(2)  As Integer
            AMultiColumns(2)  As Integer
            AIntegralHeight(2)As Integer
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
        Public:
            Items             As ListItems
            Declare Property TabStop As Boolean
            Declare Property TabStop(Value As Boolean)
            Declare Property BorderStyle As Integer
            Declare Property BorderStyle(Value As Integer)
            Declare Property Ctl3D As Boolean
            Declare Property Ctl3D(Value As Boolean)
            Declare Property ItemIndex As Integer
            Declare Property ItemIndex(Value As Integer)
            Declare Property TopIndex As Integer
            Declare Property TopIndex(Value As Integer)
            Declare Property ItemHeight As Integer
            Declare Property ItemHeight(Value As Integer)
            Declare Property ItemCount As Integer
            Declare Property ItemCount(Value As Integer)
            Declare Property SelCount As Integer
            Declare Property SelCount(Value As Integer)
            Declare Property SelItems As Integer Ptr
            Declare Property SelItems(Value As Integer Ptr)
            Declare Property Sort As Boolean
            Declare Property Sort(Value As Boolean)
            Declare Property MultiSelect As Boolean
            Declare Property MultiSelect(Value As Boolean)
            Declare Property ExtendSelect As Boolean
            Declare Property ExtendSelect(Value As Boolean)
            Declare Property IntegralHeight As Boolean
            Declare Property IntegralHeight(Value As Boolean)
            Declare Property Columns As Integer
            Declare Property Columns(Value As Integer)
            Declare Property Object(FIndex As Integer) As Any Ptr
            Declare Property Object(FIndex As Integer, Obj As Any Ptr)
            Declare Property Item(FIndex As Integer) ByRef As WString
            Declare Property Item(FIndex As Integer, ByRef FItem As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Operator Cast As Control Ptr
            Declare Sub AddItem(ByRef FItem As WString)
            Declare Sub AddObject(ByRef ObjName As WString, Obj As Any Ptr)
            Declare Sub RemoveItem(FIndex As Integer)
            Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
            Declare Sub InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
            Declare Function IndexOf(ByRef Item As WString) As Integer
            Declare Function IndexOfObject(Obj As Any Ptr) As Integer
            Declare Sub Clear
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Constructor
            Declare Destructor
            OnChange      As Sub(BYREF Sender As CheckedListBox)
            OnDblClick    As Sub(BYREF Sender As CheckedListBox)
            OnKeyPress    As Sub(BYREF Sender As CheckedListBox, Key As Byte, Shift As Integer)
            OnKeyDown     As Sub(BYREF Sender As CheckedListBox, Key As Integer, Shift As Integer)
            OnKeyUp       As Sub(BYREF Sender As CheckedListBox, Key As Integer, Shift As Integer)
            OnMeasureItem As Sub(BYREF Sender As CheckedListBox, ItemIndex As Integer, BYREF Height As UInt)
            OnDrawItem    As Sub(BYREF Sender As CheckedListBox, ItemIndex As Integer, State As Integer,BYREF R As Rect,DC As HDC = 0)
    End Type

    Property CheckedListBox.MultiSelect As Boolean
        Return FMultiselect
    End Property

    Property CheckedListBox.MultiSelect(Value As Boolean)
        If Value <> FMultiselect Then
            FMultiselect = Value
            ExStyle = ABorderExStyle(Abs_(FCtl3D))
            Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.ExtendSelect As Boolean
        Return FExtendSelect
    End Property

    Property CheckedListBox.ExtendSelect(Value As Boolean)
        If Value <> FExtendSelect Then
            FExtendSelect = Value
            ExStyle = ABorderExStyle(Abs_(FCtl3D))
            Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.Columns As Integer
       Return FColumns 
    End Property

    Property CheckedListBox.Columns(Value As Integer)
        If Value <> FColumns Then
            FColumns = Value
            ExStyle = ABorderExStyle(Abs_(FCtl3D))
            Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.IntegralHeight As Boolean
        Return FIntegralHeight
    End Property

    Property CheckedListBox.IntegralHeight(Value As Boolean)
         If Value <> FIntegralHeight Then
            FIntegralHeight = Value
            ExStyle = ABorderExStyle(Abs_(FCtl3D))
            Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(ABs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.Ctl3D As Boolean
        Return FCtl3D
    End Property

    Property CheckedListBox.Ctl3D(Value As Boolean)
        If Value <> FCtl3D Then
            FCtl3D = Value
            ExStyle = ABorderExStyle(Abs_(FCtl3D))
            Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.BorderStyle As Integer
        Return FBorderStyle
    End Property

    Property CheckedListBox.BorderStyle(Value As Integer)
        If Value <> FBorderStyle Then
           FBorderStyle = Value
           ExStyle = ABorderExStyle(Abs_(FCtl3D))
           Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.ItemCount As Integer
        If Handle Then 
            Return Perform(LB_GETCOUNT,0,0)
        End If
        Return Items.Count
    End Property

    Property CheckedListBox.ItemCount(Value As Integer)
    End Property

    Property CheckedListBox.ItemHeight As Integer
        Return FItemHeight
    End Property

    Property CheckedListBox.ItemHeight(Value As Integer)
        FItemHeight = Value
        If Handle Then Perform(LB_SETITEMHEIGHT,0,MakeLParam(FItemHeight,0))
    End Property

    Property CheckedListBox.TopIndex As Integer
        Return FTopIndex
    End Property

    Property CheckedListBox.TopIndex(Value As Integer)
       FTopIndex = Value
       If Handle Then Perform(LB_SETTOPINDEX,FTopIndex,0)
    End Property  

    Property CheckedListBox.ItemIndex As Integer
        Return FItemIndex
    End Property

    Property CheckedListBox.ItemIndex(Value As Integer)
        FItemIndex = Value
        If Handle Then 
            If MultiSelect Then
                Perform(LB_SETCARETINDEX, FItemIndex, 0)
            Else
                Perform(LB_SETCURSEL,FItemIndex,0)
            End If
        End If
    End Property

    Property CheckedListBox.SelCount As Integer
        Return FSelCount
    End Property

    Property CheckedListBox.SelCount(Value As Integer)
        FSelCount = Value
    End Property

    Property CheckedListBox.SelItems As Integer Ptr
        Return FSelItems
    End Property

    Property CheckedListBox.SelItems(Value As Integer Ptr)
        FSelItems = Value
    End Property

    Property CheckedListBox.Text ByRef As WString
        Return *FText
    End Property

    Property CheckedListBox.Text(ByRef Value As WString)
        FText = ReAllocate(FText, (Len(Value) + 1) * SizeOf(WString))
        *FText = Value
        If FHandle Then Perform(LB_SELECTSTRING,-1,CInt(FText))
    End Property

    Property CheckedListBox.Sort As Boolean
        Return FSort
    End Property

    Property CheckedListBox.Sort(Value As Boolean)
        If Value <> FSort Then
           FSort = Value
           Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
        End If
    End Property

    Property CheckedListBox.Object(FIndex As Integer) As Any Ptr
        Return Items.Object(FIndex)
    End Property

    Property CheckedListBox.Object(FIndex As Integer, Obj As Any Ptr)
        Items.Object(FIndex) = Obj
    End Property

    Property CheckedListBox.Item(FIndex As Integer) ByRef As WString
        Dim As Integer L
        Dim As WString Ptr s
        If FHandle Then
           L = Perform(LB_GETTEXTLEN, FIndex, 0)
           s = CAllocate((L + 1) * SizeOf(WString))
           *s = Space(L)
           Perform(LB_GETTEXT, FIndex, CInt(s))
           Return *s
        Else
            s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
            *s = Items.Item(FIndex)
            Return *s
        End If
    End Property

    Property CheckedListBox.Item(FIndex As Integer, ByRef FItem As WString)
        Items.Item(FIndex) = FItem
    End Property

    Sub CheckedListBox.AddItem(ByRef FItem As WString)
        Items.Add(FItem)
        If Handle Then Perform(LB_ADDSTRING, 0, CInt(FItem))
    End Sub

    Sub CheckedListBox.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
        Items.Add(ObjName, Obj)
        If FHandle Then Perform(LB_ADDSTRING, 0, CInt(@ObjName))
    End Sub

    Sub CheckedListBox.RemoveItem(FIndex As Integer)
        Items.Remove(FIndex)
        If Handle Then Perform(LB_DELETESTRING, FIndex, 0)
    End Sub

    Sub CheckedListBox.InsertItem(FIndex As Integer, ByRef FItem As WString)
        Items.Insert(FIndex, FItem)
        If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
    End Sub

    Sub CheckedListBox.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
        Items.Insert(FIndex, ObjName, Obj)
        If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@ObjName))
    End Sub

    Function CheckedListBox.IndexOf(ByRef FItem As WString) As Integer
        Return Perform(LB_FINDSTRING, -1, CInt(FItem))
    End Function

    Function CheckedListBox.IndexOfObject(Obj As Any Ptr) As Integer
        Return Items.IndexOfObject(Obj)
    End Function

    Sub CheckedListBox.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QCheckedListBox(Sender.Child)
                 For i As Integer = 0 To .Items.Count -1
                    Dim As WString Ptr s = CAllocate((Len(.Items.Item(i)) + 1) * SizeOf(WString))
                    *s = .Items.Item(i)
                    .Perform(LB_ADDSTRING, 0, CInt(s))
                 Next i
                 .Perform(LB_SETITEMHEIGHT, 0, MakeLParam(.ItemHeight, 0))
                 .Columns = .Columns
                 .ItemIndex = .ItemIndex
                 If .MultiSelect Then
                     For i As Integer = 0 To .SelCount -1
                         .Perform(LB_SETSEL, 1, .SelItems[i])
                     Next i
                 End If
                 .TopIndex = .FTopIndex
            End With
        End If
    End Sub

    Sub CheckedListBox.WndProc(BYREF Message As Message)
    End Sub

    Sub CheckedListBox.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case WM_PAINT
            Message.Result = 0
        Case CM_CTLCOLOR
            Static As HDC Dc
            Dc = Cast(HDC,Message.wParam)
            SetBKMode Dc, TRANSPARENT
            SetTextColor Dc, Font.Color
            SetBKColor Dc, This.Color
            SetBKMode Dc, OPAQUE
        Case CM_COMMAND
            Select Case Message.wParamHi
            Case LBN_SELCHANGE
                If MultiSelect Then
                    FSelCount = Perform(LB_GETSELCOUNT,0,0)
                    If FSelCount Then 
                       Dim As Integer AItems(FSelCount) 
                       Perform(LB_GETSELITEMS,FSelCount,CInt(@AItems(0)))
                       SelItems = @AItems(0)
                   End If
                End If
                If OnChange Then OnChange(This)
            Case LBN_DBLCLK    
                If OnDblClick Then OnDblClick(This)
            End Select
        Case CM_MEASUREITEM
            Dim As MEASUREITEMSTRUCT Ptr miStruct
            Dim As Integer ItemID
            miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
            ItemID = Cast(Integer,miStruct->itemID)
            If OnMeasureItem Then
               OnMeasureItem(This,itemID,miStruct->itemHeight)
            Else
               miStruct->itemHeight = ItemHeight 
            End If
        Case CM_DRAWITEM
            Dim As DRAWITEMSTRUCT Ptr diStruct
            Dim As Integer ItemID,State
            Dim As Rect R
            Dim As HDC Dc
            diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
            ItemID = Cast(Integer,diStruct->itemID)
            State = Cast(Integer,diStruct->itemState)
            R = Cast(Rect,diStruct->rcItem)
            Dc = diStruct->hDC
            If OnDrawItem Then
                OnDrawItem(This,ItemID,State,R,Dc)
            Else
                If (State AND ODS_SELECTED) = ODS_SELECTED Then
                    Static As HBRUSH B 
                    If B Then DeleteObject B
                    B = CreateSolidBrush(&H800000)
                    FillRect Dc,@R,B
                    R.Left += 2
                    SetTextColor Dc,clHighlightText
                    SetBKColor Dc,&H800000
                    DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX)
                Else
                    FillRect Dc, @R, Brush.Handle
                    R.Left += 2
                    SetTextColor Dc, Font.Color
                    SetBKColor Dc, This.Color
                    DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX)
                End If
            End If
        Case WM_CHAR
            If OnKeyPress Then OnKeyPress(This,LoByte(Message.wParam),Message.wParam AND &HFFFF)
        Case WM_KEYDOWN
            If OnKeyDown Then OnKeyDown(This,Message.wParam,Message.wParam AND &HFFFF)
        Case WM_KEYUP
            If OnKeyUp Then OnKeyUp(This,Message.wParam,Message.wParam AND &HFFFF)
        End Select
    End Sub

    Sub CheckedListBox.Clear
        Items.Clear
        Perform(LB_RESETCONTENT,0,0)
    End Sub

    Sub CheckedListBox.SaveToFile(ByRef File As WString)
        Dim As Integer F, i
        Dim As WString Ptr s
        F = FreeFile
        Open File For Binary Access Write As #F
             For i = 0 To ItemCount - 1
                Dim TextLen As Integer = Perform(LB_GETTEXTLEN, i, 0)
                s = CAllocate((Len(TextLen) + 1) * SizeOf(WString))
                *s = Space(TextLen) 
                Perform(LB_GETTEXT, i, CInt(s))
                Print #F, *s
             Next i
        Close #F
    End Sub

    Sub CheckedListBox.LoadFromFile(ByRef File As WString)
        Dim As Integer F, i
        Dim As WString Ptr s
        F = FreeFile
        Clear
        Open File For Binary Access Read As #F
            s = CAllocate((LOF(F) + 1) * SIzeOf(WString))
             While Not EOF(F)
                 Line Input #F, *s
                 Perform(LB_ADDSTRING, 0, CInt(s))
             WEnd
        Close #F
    End Sub

    Operator CheckedListBox.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor CheckedListBox
        ASortStyle(0)   = 0
        ASortStyle(1)   = LBS_SORT
        AStyle(0)          = 0
        AStyle(1)          = LBS_OWNERDRAWFIXED
        AStyle(2)          = LBS_OWNERDRAWVARIABLE
        ABorderExStyle(0)  = 0 
        ABorderExStyle(1)  = WS_EX_CLIENTEDGE
        ABorderStyle(0)    = WS_BORDER 
        ABorderStyle(1)    = 0
        AMultiselect(0)    = 0 
        AMultiselect(1)    = LBS_MULTIPLESEL    
        AExtendSelect(0)   = 0
        AExtendSelect(1)   = LBS_EXTENDEDSEL    
        AMultiColumns(0)   = 0
        AMultiColumns(1)   = LBS_MULTICOLUMN    
        AIntegralHeight(0) = LBS_NOINTEGRALHEIGHT    
        AIntegralHeight(1) = 0
        FCtl3D             = True
        FBorderStyle       = 1
        Items.Parent       = @This
        With This
            .RegisterClass "CheckedListBox", "ListBox"
            .ClassName       = "CheckedListBox"
            .ClassAncestor  = "ListBox"
            .Child       = @This
            .ChildProc   = @WndProc
            .ExStyle     = ABorderExStyle(Abs_(FCtl3D))
            Base.Style       = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
            .Width       = 121
            .Height      = 17
            .Color       = GetSysColor(COLOR_WINDOW)
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor CheckedListBox
        'If Items Then DeAllocate Items
    End Destructor
End namespace
