'###############################################################################
'#  ListControl.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"
#Include Once "ListItems.bi"

Namespace My.Sys.Forms
    #DEFINE QListControl(__Ptr__) *Cast(ListControl Ptr,__Ptr__)

    Enum ListControlStyle
        lbNormal = 0
        lbOwnerDrawFixed
        lbOwnerDrawVariable 
    End Enum

    Type ListControl Extends Control
        Private:
            FStyle            As Integer
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
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
        Public:
            Items             As ListItems
            Declare Property Style As ListControlStyle
            Declare Property Style(Value As ListControlStyle)
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
            OnChange      As Sub(BYREF Sender As ListControl)
            OnDblClick    As Sub(BYREF Sender As ListControl)
            OnKeyPress    As Sub(BYREF Sender As ListControl, Key As Byte, Shift As Integer)
            OnKeyDown     As Sub(BYREF Sender As ListControl, Key As Integer, Shift As Integer)
            OnKeyUp       As Sub(BYREF Sender As ListControl, Key As Integer, Shift As Integer)
            #IfNDef __USE_GTK__
				OnMeasureItem As Sub(BYREF Sender As ListControl, ItemIndex As Integer, BYREF Height As UInt)
				OnDrawItem    As Sub(BYREF Sender As ListControl, ItemIndex As Integer, State As Integer,BYREF R As Rect,DC As HDC = 0)
			#EndIf
    End Type

    Property ListControl.MultiSelect As Boolean
        Return FMultiselect
    End Property

    Property ListControl.MultiSelect(Value As Boolean)
        If Value <> FMultiselect Then
            FMultiselect = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.ExtendSelect As Boolean
        Return FExtendSelect
    End Property

    Property ListControl.ExtendSelect(Value As Boolean)
        If Value <> FExtendSelect Then
            FExtendSelect = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.Columns As Integer
       Return FColumns 
    End Property

    Property ListControl.Columns(Value As Integer)
        If Value <> FColumns Then
            FColumns = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.IntegralHeight As Boolean
        Return FIntegralHeight
    End Property

    Property ListControl.IntegralHeight(Value As Boolean)
         If Value <> FIntegralHeight Then
            FIntegralHeight = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(ABs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.Style As ListControlStyle
        Return FStyle 
    End Property

    Property ListControl.Style(Value As ListControlStyle)
        If Value <> FStyle Then
            FStyle = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.Ctl3D As Boolean
        Return FCtl3D
    End Property

    Property ListControl.Ctl3D(Value As Boolean)
        If Value <> FCtl3D Then
            FCtl3D = Value
            #IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.BorderStyle As Integer
        Return FBorderStyle
    End Property

    Property ListControl.BorderStyle(Value As Integer)
        If Value <> FBorderStyle Then
           FBorderStyle = Value
           #IfNDef __USE_GTK__
			   ExStyle = ABorderExStyle(Abs_(FCtl3D))
			   Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.ItemCount As Integer
        #IfNDef __USE_GTK__
			If Handle Then 
				Return Perform(LB_GETCOUNT,0,0)
			End If
		#EndIf
        Return Items.Count
    End Property

    Property ListControl.ItemCount(Value As Integer)
    End Property

    Property ListControl.ItemHeight As Integer
        Return FItemHeight
    End Property

    Property ListControl.ItemHeight(Value As Integer)
        FItemHeight = Value
        #IfNDef __USE_GTK__
			If Handle Then Perform(LB_SETITEMHEIGHT,0,MakeLParam(FItemHeight,0))
		#EndIf
    End Property

    Property ListControl.TopIndex As Integer
        Return FTopIndex
    End Property

    Property ListControl.TopIndex(Value As Integer)
		FTopIndex = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_SETTOPINDEX,FTopIndex,0)
		#EndIf
    End Property  

    Property ListControl.ItemIndex As Integer
        Return FItemIndex
    End Property

    Property ListControl.ItemIndex(Value As Integer)
        FItemIndex = Value
        #IfNDef __USE_GTK__
			If Handle Then 
				If MultiSelect Then
					Perform(LB_SETCARETINDEX, FItemIndex, 0)
				Else
					Perform(LB_SETCURSEL,FItemIndex,0)
				End If
			End If
		#EndIf
    End Property

    Property ListControl.SelCount As Integer
        Return FSelCount
    End Property

    Property ListControl.SelCount(Value As Integer)
        FSelCount = Value
    End Property

    Property ListControl.SelItems As Integer Ptr
        Return FSelItems
    End Property

    Property ListControl.SelItems(Value As Integer Ptr)
        FSelItems = Value
    End Property

    Property ListControl.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property ListControl.Text(ByRef Value As WString)
        FText = ReAllocate(FText, (Len(Value) + 1) * SizeOf(WString))
        *FText = Value
        #IfNDef __USE_GTK__
			If FHandle Then Perform(LB_SELECTSTRING,-1,CInt(FText))
		#EndIf
    End Property

    Property ListControl.Sort As Boolean
        Return FSort
    End Property

    Property ListControl.Sort(Value As Boolean)
        If Value <> FSort Then
           FSort = Value
           #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
        End If
    End Property

    Property ListControl.Object(FIndex As Integer) As Any Ptr
        Return Items.Object(FIndex)
    End Property

    Property ListControl.Object(FIndex As Integer, Obj As Any Ptr)
        Items.Object(FIndex) = Obj
    End Property

    Property ListControl.Item(FIndex As Integer) ByRef As WString
        Dim As Integer L
        Dim As WString Ptr s
        #IfNDef __USE_GTK__
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
		#Else
			s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
			*s = Items.Item(FIndex)
			Return *s
		#EndIf
    End Property

    Property ListControl.Item(FIndex As Integer, ByRef FItem As WString)
        Items.Item(FIndex) = FItem
    End Property

    Sub ListControl.AddItem(ByRef FItem As WString)
        Items.Add(FItem)
        #IfNDef __USE_GTK__
			If Handle Then Perform(LB_ADDSTRING, 0, CInt(FItem))
		#EndIf
    End Sub

    Sub ListControl.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
        Items.Add(ObjName, Obj)
        #IfNDef __USE_GTK__
			If FHandle Then Perform(LB_ADDSTRING, 0, CInt(@ObjName))
		#EndIf
    End Sub

    Sub ListControl.RemoveItem(FIndex As Integer)
        Items.Remove(FIndex)
        #IfNDef __USE_GTK__
			If Handle Then Perform(LB_DELETESTRING, FIndex, 0)
		#EndIf
    End Sub

    Sub ListControl.InsertItem(FIndex As Integer, ByRef FItem As WString)
        Items.Insert(FIndex, FItem)
        #IfNDef __USE_GTK__
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
		#EndIf
    End Sub

    Sub ListControl.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
        Items.Insert(FIndex, ObjName, Obj)
        #IfNDef __USE_GTK__
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@ObjName))
		#EndIf
    End Sub

    Function ListControl.IndexOf(ByRef FItem As WString) As Integer
        #IfNDef __USE_GTK__
			Return Perform(LB_FINDSTRING, -1, CInt(FItem))
		#Else
			Return -1
		#EndIf
    End Function

    Function ListControl.IndexOfObject(Obj As Any Ptr) As Integer
        Return Items.IndexOfObject(Obj)
    End Function

	#IfNDef __USE_GTK__
		Sub ListControl.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QListControl(Sender.Child)
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

		Sub ListControl.WndProc(BYREF Message As Message)
		End Sub

		Sub ListControl.ProcessMessage(BYREF Message As Message)
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBKColor Dc, This.BackColor
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
						SetBKColor Dc, This.BackColor
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
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Sub ListControl.Clear
        Items.Clear
        #IfNDef __USE_GTK__
			Perform(LB_RESETCONTENT,0,0)
		#EndIf
    End Sub

    Sub ListControl.SaveToFile(ByRef File As WString)
        Dim As Integer F, i
        Dim As WString Ptr s
        F = FreeFile
        Open File For Binary Access Write As #F
             For i = 0 To ItemCount - 1
				#IfNDef __USE_GTK__
					Dim TextLen As Integer = Perform(LB_GETTEXTLEN, i, 0)
					s = CAllocate((Len(TextLen) + 1) * SizeOf(WString))
					*s = Space(TextLen) 
					Perform(LB_GETTEXT, i, CInt(s))
					Print #F, *s
				#EndIF
             Next i
        Close #F
    End Sub

    Sub ListControl.LoadFromFile(ByRef File As WString)
        Dim As Integer F, i
        Dim As WString Ptr s
        F = FreeFile
        Clear
        Open File For Binary Access Read As #F
            s = CAllocate((LOF(F) + 1) * SIzeOf(WString))
             While Not EOF(F)
                 Line Input #F, *s
                 #IfNDef __USE_GTK__
					Perform(LB_ADDSTRING, 0, CInt(s))
				#EndIf
             WEnd
        Close #F
    End Sub

    Operator ListControl.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor ListControl
		With This
		#IfDef __USE_GTK__
			#IfDef __USE_GTK3__
				widget = gtk_list_box_new()
			#Else
				widget = gtk_list_new()
			#EndIf
			.RegisterClass "ListControl", @This
		#Else
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
		#EndIf
        FCtl3D             = True
        FBorderStyle       = 1
        Items.Parent       = @This
        
            WLet FClassName, "ListControl"
            .Child       = @This
			#IfNDef __USE_GTK__
				.RegisterClass "ListControl", "ListBox"
				WLet FClassAncestor, "ListBox"
				.ChildProc   = @WndProc
				.ExStyle     = ABorderExStyle(Abs_(FCtl3D))
				Base.Style       = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.OnHandleIsAllocated = @HandleIsAllocated
            #EndIf
            .Width       = 121
            .Height      = 17
        End With
    End Constructor

    Destructor ListControl
        'If Items Then DeAllocate Items
    End Destructor
End namespace
