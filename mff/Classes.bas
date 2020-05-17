'###############################################################################
'#  CheckedListBox.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#include once "CheckedListBox.bi"

Namespace My.Sys.Forms
	Property CheckedListBox.MultiSelect As Boolean
		Return FMultiselect
	End Property
	
	Property CheckedListBox.MultiSelect(Value As Boolean)
		If Value <> FMultiselect Then
			FMultiselect = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.ExtendSelect As Boolean
		Return FExtendSelect
	End Property
	
	Property CheckedListBox.ExtendSelect(Value As Boolean)
		If Value <> FExtendSelect Then
			FExtendSelect = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.Columns As Integer
		Return FColumns
	End Property
	
	Property CheckedListBox.Columns(Value As Integer)
		If Value <> FColumns Then
			FColumns = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Property CheckedListBox.IntegralHeight(Value As Boolean)
		If Value <> FIntegralHeight Then
			FIntegralHeight = Value
			#IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(ABs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
		End If
	End Property
	
	Property CheckedListBox.Ctl3D As Boolean
		Return FCtl3D
	End Property
	
	Property CheckedListBox.Ctl3D(Value As Boolean)
		If Value <> FCtl3D Then
			FCtl3D = Value
			#IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
		End If
	End Property
	
	Property CheckedListBox.BorderStyle As Integer
		Return FBorderStyle
	End Property
	
	Property CheckedListBox.BorderStyle(Value As Integer)
		If Value <> FBorderStyle Then
			FBorderStyle = Value
			#IfNDef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR LBS_HASSTRINGS OR LBS_NOTIFY OR AStyle(Abs_(FStyle)) OR ABorderStyle(Abs_(FBorderStyle)) OR ASortStyle(Abs_(FSort)) OR AMultiselect(Abs_(FMultiselect)) OR AExtendSelect(Abs_(FExtendSelect)) OR AMultiColumns(Abs_(FColumns)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
		End If
	End Property
	
	Property CheckedListBox.ItemCount As Integer
		#IfNDef __USE_GTK__
			If Handle Then
				Return Perform(LB_GETCOUNT,0,0)
			End If
		#EndIf
		Return Items.Count
	End Property
	
	Property CheckedListBox.ItemCount(Value As Integer)
	End Property
	
	Property CheckedListBox.ItemHeight As Integer
		Return FItemHeight
	End Property
	
	Property CheckedListBox.ItemHeight(Value As Integer)
		FItemHeight = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_SETITEMHEIGHT,0,MakeLParam(FItemHeight,0))
		#EndIf
	End Property
	
	Property CheckedListBox.TopIndex As Integer
		Return FTopIndex
	End Property
	
	Property CheckedListBox.TopIndex(Value As Integer)
		FTopIndex = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_SETTOPINDEX,FTopIndex,0)
		#EndIf
	End Property
	
	Property CheckedListBox.ItemIndex As Integer
		Return FItemIndex
	End Property
	
	Property CheckedListBox.ItemIndex(Value As Integer)
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
		Return *FText.vptr
	End Property
	
	Property CheckedListBox.Text(ByRef Value As WString)
		FText = Value
		#ifndef __USE_GTK__
			If FHandle Then Perform(LB_SELECTSTRING, -1, CInt(FText.vptr))
		#endif
	End Property
	
	Property CheckedListBox.Sort As Boolean
		Return FSort
	End Property
	
	Property CheckedListBox.Sort(Value As Boolean)
		If Value <> FSort Then
			FSort = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
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
	
	Property CheckedListBox.Item(FIndex As Integer, ByRef FItem As WString)
		Items.Item(FIndex) = FItem
	End Property
	
	Sub CheckedListBox.AddItem(ByRef FItem As WString)
		Items.Add(FItem)
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_ADDSTRING, 0, CInt(FItem))
		#EndIf
	End Sub
	
	Sub CheckedListBox.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
		Items.Add(ObjName, Obj)
		#IfNDef __USE_GTK__
			If FHandle Then Perform(LB_ADDSTRING, 0, CInt(@ObjName))
		#EndIf
	End Sub
	
	Sub CheckedListBox.RemoveItem(FIndex As Integer)
		Items.Remove(FIndex)
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_DELETESTRING, FIndex, 0)
		#EndIf
	End Sub
	
	Sub CheckedListBox.InsertItem(FIndex As Integer, ByRef FItem As WString)
		Items.Insert(FIndex, FItem)
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
		#EndIf
	End Sub
	
	Sub CheckedListBox.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
		Items.Insert(FIndex, ObjName, Obj)
		#IfNDef __USE_GTK__
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@ObjName))
		#EndIf
	End Sub
	
	Function CheckedListBox.IndexOf(ByRef FItem As WString) As Integer
		#IfNDef __USE_GTK__
			Return Perform(LB_FINDSTRING, -1, CInt(FItem))
		#Else
			Return -1
		#EndIf
	End Function
	
	Function CheckedListBox.IndexOfObject(Obj As Any Ptr) As Integer
		Return Items.IndexOfObject(Obj)
	End Function
	
	#IfNDef __USE_GTK__
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
	#EndIf
	
	#IfNDef __USE_GTK__
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
	
	Sub CheckedListBox.Clear
		Items.Clear
		#IfnDef __USE_GTK__
			Perform(LB_RESETCONTENT,0,0)
		#EndIf
	End Sub
	
	Sub CheckedListBox.SaveToFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Open File For Binary Access Write As #F
		For i = 0 To ItemCount - 1
			#IfnDef __USE_GTK__
				Dim TextLen As Integer = Perform(LB_GETTEXTLEN, i, 0)
				s = CAllocate((Len(TextLen) + 1) * SizeOf(WString))
				*s = Space(TextLen)
				Perform(LB_GETTEXT, i, CInt(s))
				Print #F, *s
			#EndIf
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
			#IfnDef __USE_GTK__
				Perform(LB_ADDSTRING, 0, CInt(s))
			#EndIf
		WEnd
		Close #F
	End Sub
	
	Operator CheckedListBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor CheckedListBox
		#ifndef __USE_GTK__
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
		#endif
		FCtl3D             = True
		FBorderStyle       = 1
		FTabStop           = True
		Items.Parent       = @This
		With This
			WLet FClassName, "CheckedListBox"
			WLet FClassAncestor, "ListBox"
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "CheckedListBox", "ListBox"
				.ChildProc   = @WndProc
				.ExStyle     = ABorderExStyle(Abs_(FCtl3D))
				Base.Style       = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width       = 121
			.Height      = 17
		End With
	End Constructor
	
	Destructor CheckedListBox
		'If Items Then DeAllocate Items
	End Destructor
End Namespace
