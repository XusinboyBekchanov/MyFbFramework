'###############################################################################
'#  Header.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   THeader.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#Include Once "Control.bi"
#Include Once "ImageList.bi"
#Include Once "List.bi"

namespace My.Sys.Forms
    #DEFINE QHeader(__Ptr__) *Cast(Header Ptr,__Ptr__)
    #DEFINE QHeaderSection(__Ptr__) *Cast(HeaderSection Ptr,__Ptr__)

    Type PHeaderControl As Header

    Enum HeaderSectionStyle
        hdsText, hdsOwnerDraw 
    End Enum

    Type HeaderSection Extends My.Sys.Object
        Private:
            FCaption      As WString Ptr
            FAlignment    As Integer
            FImageIndex   As Integer
            FStyle        As Integer
            FWidth        As Integer
            AFmt(4)       As Integer
        Public:
            HeaderControl As PHeaderControl Ptr
            Tag           As Any Ptr
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Alignment As Integer
            Declare Property Alignment(Value As Integer)
            Declare Property ImageIndex As Integer
            Declare Property ImageIndex(Value As Integer)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Enum HeaderStyle
        hsNormal = 0, hsOwnerDraw
    End Enum

    Type Header Extends Control
        Private:
            FStyle            As Integer
            FFullDrag         As Boolean
            FDragReorder      As Boolean
            FHotTrack         As Boolean
            AStyle(2)         As Integer
            AHotTrack(2)      As Integer
            AFullDrag(2)      As Integer
            ADragReorder(2)   As Integer
            AFmt(4)           As Integer
            FSectionCount     As Integer
            FSections         As List
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
            Declare Function EnumMenuItems(Item As MenuItem,BYREF List As List) As Boolean
        Public:
            Images            As ImageList
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property HotTrack As Boolean
            Declare Property HotTrack(Value As Boolean)
            Declare Property FullDrag As Boolean
            Declare Property FullDrag(Value As Boolean)
            Declare Property DragReorder As Boolean
            Declare Property DragReorder(Value As Boolean)
            Declare Property SectionCount As Integer
            Declare Property SectionCount(Value As Integer)
            Declare Property Section(Index As Integer) As HeaderSection Ptr
            Declare Property Section(Index As Integer,Value As HeaderSection Ptr)
            Declare Property Captions(Index As Integer) ByRef As WString
            Declare Property Captions(Index As Integer, ByRef Value As WString)
            Declare Property Widths(Index As Integer) As Integer
            Declare Property Widths(Index As Integer,Value As Integer)
            Declare Property Alignments(Index As Integer) As Integer
            Declare Property Alignments(Index As Integer,Value As Integer)
            Declare Property ImageIndexes(Index As Integer) As Integer
            Declare Property ImageIndexes(Index As Integer,Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Sub AddSection(ByRef FCaption As WString = "", FImageIndex As Integer = -1, FWidth As Integer = 50, FAlignment As Integer = 0)
            Declare Sub AddSections CDECL(FCount As Integer,...)
            Declare Sub RemoveSection(Index As Integer)
            Declare Sub UpdateItems
            Declare Constructor
            Declare Destructor
            OnSectionClick    As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, Index As Integer, MouseButton As Integer)
            OnSectionDblClick As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, Index As Integer, MouseButton As Integer)
            OnChange          As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnChanging        As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnBeginTrack      As Sub(BYREF Sender As Header, BYREF Section As HeaderSection) 
            OnEndTrack        As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnTrack           As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnDividerDblClick As Sub(BYREF Sender As Header, Index As Integer, MouseButton As Integer)
            #IfNDef __USE_GTK__
				OnDrawSection     As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, R As Rect, State As Integer)
			#EndIf
    End Type

    'HeaderSection

    Property HeaderSection.Style As Integer
        Return FStyle
    End Property

    Property HeaderSection.Style(Value As Integer)
        If Value <> FStyle Then
           FStyle = Value
           QHeader(HeaderControl).UpdateItems
        End If
    End Property

    Property HeaderSection.Caption ByRef As WString
        Return WGet(FCaption)
    End Property

    Property HeaderSection.Caption(ByRef Value As WString)
        WLet FCaption, Value
    End Property

    Property HeaderSection.Alignment As Integer
        Return FAlignment
    End Property

    Property HeaderSection.Alignment(Value As Integer)
        If Value <> FAlignment Then
           FAlignment = Value
           QHeader(HeaderControl).UpdateItems
        End If
    End Property

    Property HeaderSection.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property HeaderSection.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
           FImageIndex = Value
           QHeader(HeaderControl).UpdateItems
        End If
    End Property

    Property HeaderSection.Width As Integer
        Return FWidth
    End Property

    Property HeaderSection.Width(Value As Integer)
        If Value <> FWidth Then
           FWidth = Value
           QHeader(HeaderControl).UpdateItems
        End If
    End Property

    Operator HeaderSection.Cast As Any Ptr
        Return @This
    End Operator

    Constructor HeaderSection
		#IfNDef __USE_GTK__
			AFmt(0)         = HDF_LEFT
			AFmt(1)         = HDF_CENTER
			AFmt(2)         = HDF_RIGHT
			AFmt(3)         = HDF_RTLREADING
		#EndIf
        WLet FCaption, ""
        FImageIndex     = -1
        FAlignment      = 0
        FWidth          = 50
    End Constructor

    Destructor HeaderSection
    End Destructor

    'Header
    Property Header.Style As Integer
        Return FStyle
    End Property

    Property Header.Style(Value As Integer)
        If FStyle <> Value Then
            FStyle = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR AFullDrag(Abs_(FFullDrag)) OR AHotTrack(Abs_(FHotTrack)) OR ADragReorder(Abs_(FDragReorder))
			#EndIf
        End If
    End Property

    Property Header.HotTrack As Boolean
        Return FHotTrack
    End Property

    Property Header.HotTrack(Value As Boolean)
        If FHotTrack <> Value Then
            FHotTrack = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR AFullDrag(Abs_(FFullDrag)) OR AHotTrack(Abs_(FHotTrack)) OR ADragReorder(Abs_(FDragReorder))
			#EndIf
        End If
    End Property

    Property Header.FullDrag As Boolean
        Return FFullDrag
    End Property

    Property Header.FullDrag(Value As Boolean)
        If FFullDrag <> Value Then
            FFullDrag = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR AFullDrag(Abs_(FFullDrag)) OR AHotTrack(Abs_(FHotTrack)) OR ADragReorder(Abs_(FDragReorder))
			#EndIf
       End If
    End Property

    Property Header.DragReorder As Boolean
        Return FDragReorder
    End Property

    Property Header.DragReorder(Value As Boolean)
        If FDragReorder <> Value Then
            DragReorder = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR AFullDrag(Abs_(FFullDrag)) OR AHotTrack(Abs_(FHotTrack)) OR ADragReorder(Abs_(FDragReorder))
			#EndIf
       End If
    End Property

    Property Header.SectionCount As Integer
        FSectionCount = FSections.Count
        Return FSectionCount
    End Property

    Property Header.SectionCount(Value As Integer)
         FSectionCount = FSections.Count
    End Property

    Property Header.Section(Index As Integer) As HeaderSection Ptr
        If Index >= 0 And Index <= SectionCount -1 Then
            Return QHeaderSection(FSections.Items[Index])
        End If
        Return NULL
    End Property

    Property Header.Section(Index As Integer, Value As HeaderSection Ptr)
        If Index >= 0 And Index <= SectionCount -1 Then
            FSections.Items[Index] = Value
        End If
    End Property

    Property Header.Captions(Index As Integer) ByRef As WString
        If Index >= 0 AND Index <= SectionCount -1 Then
            Return QHeaderSection(FSections.Items[Index]).Caption
        Else
            Return ""
        End If
    End Property

    Property Header.Captions(Index As Integer, ByRef Value As WString)
        If Index >= 0 AND Index <= SectionCount -1 Then
           QHeaderSection(FSections.Items[Index]).Caption = Value
        End If
    End Property

    Property Header.Widths(Index As Integer) As Integer
        If Index >= 0 AND Index <= SectionCount -1 Then
            Return QHeaderSection(FSections.Items[Index]).Width
        Else
            Return 0
        End If
    End Property

    Property Header.Widths(Index As Integer, Value As Integer)
        If Index >= 0 AND Index <= SectionCount -1 Then
           QHeaderSection(FSections.Items[Index]).Width = Value
        End If
    End Property

    Property Header.Alignments(Index As Integer) As Integer
        If Index >= 0 AND Index <= SectionCount -1 Then
            Return QHeaderSection(FSections.Items[Index]).Alignment
        Else
            Return 0
        End If
    End Property

    Property Header.Alignments(Index As Integer, Value As Integer)
        If Index >= 0 AND Index <= SectionCount -1 Then
           QHeaderSection(FSections.Items[Index]).Alignment = Value
        End If
    End Property

    Property Header.ImageIndexes(Index As Integer) As Integer
        If Index >= 0 AND Index <= SectionCount -1 Then
            Return QHeaderSection(FSections.Items[Index]).ImageIndex
        Else
            Return -1
        End If
    End Property

    Property Header.ImageIndexes(Index As Integer, Value As Integer)
        If Index >= 0 AND Index <= SectionCount -1 Then
           QHeaderSection(FSections.Items[Index]).ImageIndex = Value
        End If
    End Property

    Sub Header.UpdateItems
		#IfNDef __USE_GTK__
			Dim As HDITEM HI
			For i As Integer = SectionCount -1 To 0 Step -1
				Perform(HDM_DELETEITEM, i, 0)
			Next i
			For i As Integer = 0 To SectionCount - 1
				 HI.mask       = HDI_FORMAT OR HDI_WIDTH OR HDI_LPARAM OR HDI_TEXT    
				 HI.pszText    = @QHeaderSection(FSections.Items[I]).Caption
				 HI.cchTextMax = Len(QHeaderSection(FSections.Items[I]).Caption)
				 HI.cxy        = QHeaderSection(FSections.Items[I]).Width 
				 HI.fmt        = AFmt(QHeaderSection(FSections.Items[I]).Alignment)
				 HI.iImage     = QHeaderSection(FSections.Items[I]).ImageIndex
				 If HI.iImage <> -1 Then
					HI.mask = HI.mask OR HDI_IMAGE 
					HI.fmt = HI.fmt OR HDF_IMAGE
				 End If
				 If QHeaderSection(FSections.Items[I]).Style > 0 Then
					 HI.fmt = HI.fmt OR HDF_OWNERDRAW
				 Else
					 HI.fmt = HI.fmt OR HDF_STRING
				 End If
				 HI.hbm        = NULL
				 HI.lParam     = Cast(LParam,FSections.Items[I])
				 Perform(HDM_INSERTITEM, i, CInt(@HI))
			Next i
        #EndIF
    End Sub

	#IfNDef __USE_GTK__
		Sub Header.HandleIsAllocated(BYREF Sender As Control)
			Dim As HDITEM HI
			If Sender.Child Then
				With QHeader(Sender.Child)
					.Images.ParentWindow = @Sender
					SendMessage(.Handle, HDM_SETIMAGELIST, 0, Cast(LPARAM, .Images.Handle))
					For i As Integer = 0 To .SectionCount -1
						HI.mask       = HDI_FORMAT OR HDI_WIDTH OR HDI_LPARAM OR HDI_TEXT    
						HI.pszText    = @QHeaderSection(.FSections.Items[I]).Caption
						HI.cchTextMax = Len(QHeaderSection(.FSections.Items[I]).Caption)
						HI.cxy        = QHeaderSection(.FSections.Items[I]).Width 
						HI.fmt        = .AFmt(QHeaderSection(.FSections.Items[I]).Alignment)
						HI.iImage     = QHeaderSection(.FSections.Items[I]).ImageIndex
						If HI.iImage <> -1 Then
							HI.mask = HI.mask OR HDI_IMAGE 
							HI.fmt = HI.fmt OR HDF_IMAGE
						End If
						If QHeaderSection(.FSections.Items[I]).Style > 0 Then
							HI.fmt = HI.fmt OR HDF_OWNERDRAW
						Else
							HI.fmt = HI.fmt OR HDF_STRING
						End If
						HI.hbm        = NULL
						HI.lParam     = Cast(LParam, .FSections.Items[I])
						.Perform(HDM_INSERTITEM, i, CInt(@HI))
					Next i
				End With
			End If
		End Sub

		Sub Header.WndProc(BYREF Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#EndIf

    Function Header.EnumMenuItems(Item As MenuItem, BYREF List As List) As Boolean
        For i As Integer = 0 To Item.Count -1
            List.Add Item.Item(i)
            EnumMenuItems *Item.Item(i), List
        Next i
        Return True
    End Function

	#IfNDef __USE_GTK__
		Sub Header.ProcessMessage(BYREF Message As Message)
			Static As Boolean IsMenuItem
			Select Case Message.Msg
			Case WM_RBUTTONDOWN
				'PopupMenu.Window = FHandle
				'PopupMenu.Popup(Message.lParamLo, Message.lParamHi)
			Case CM_NOTIFY
				Dim As HD_NOTIFY Ptr HDN
				Dim As Integer ItemIndex, MouseButton
				HDN = Cast(HD_NOTIFY Ptr, Message.lParam)
				ItemIndex   = HDN->iItem
				MouseButton = HDN->iButton
				Select Case HDN->hdr.code
				Case HDN_BEGINTRACK
					If OnBeginTrack Then OnBeginTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_ENDTRACK
					If OnEndTrack Then OnEndTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_DIVIDERDBLCLICK
					If OnDividerDblClick Then OnDividerDblClick(This, ItemIndex,MouseButton) 
				Case HDN_ITEMCHANGED
					Dim As HD_ITEM Ptr HI
					HI = Cast(HD_ITEM Ptr,HDN->pItem)
					QHeaderSection(FSections.Items[ItemIndex]).Width = HI->cxy
					If OnChange Then OnChange(This,QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_ITEMCHANGING
					Dim As HD_ITEM Ptr HI
					HI = Cast(HD_ITEM Ptr,HDN->pItem)
					QHeaderSection(FSections.Items[ItemIndex]).Width = HI->cxy
					If OnChanging Then OnChanging(This, QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_ITEMCLICK
					If OnSectionClick Then OnSectionClick(This, QHeaderSection(FSections.Items[ItemIndex]), ItemIndex, MouseButton)
				Case HDN_ITEMDBLCLICK 
					If OnSectionDblClick Then OnSectionDblClick(This, QHeaderSection(FSections.Items[ItemIndex]), ItemIndex, MouseButton) 
				Case HDN_TRACK
					If OnTrack Then OnTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				End Select
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr Dis
				Dis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				Dim As Rect R = Dis->rcItem
				Dim As Integer Index = Dis->ItemID, State = Dis->itemState
				If OnDrawSection Then OnDrawSection(This, QHeaderSection(FSections.Items[Index]), R, State AND ODS_SELECTED <> 0)
			Case WM_MENUSELECT
				IsMenuItem = True
			Case WM_COMMAND
				Static As List List
				Dim As MenuItem Ptr Item
				If IsMenuItem Then
				   List.Clear
				   For i As Integer = 0 To ContextMenu->Count -1
						EnumMenuItems(*ContextMenu->Item(i), List)
				   Next i
				   For i As Integer = 0 To List.Count - 1
					   If QMenuItem(List.Items[i]).Command = Message.wParamLo Then
						  If QMenuItem(List.Items[i]).OnClick Then QMenuItem(List.Items[i]).OnClick(QMenuItem(List.Items[i]))
						  Exit For
					   End If
				   Next i
				   IsMenuItem = False
				End If
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Sub Header.AddSection(ByRef FCaption As WString = "", FImageIndex As Integer = -1, FWidth As Integer = 50, FAlignment As Integer = 0)
        Dim As HeaderSection Ptr PSection
        PSection = New HeaderSection
        FSections.Add PSection
        With *PSection
            .HeaderControl = @This
            .Caption       = FCaption
            .ImageIndex    = FImageIndex
            .Alignment     = FAlignment
            .Width         = FWidth
        End With
        
        #IfNDef __USE_GTK__
			Dim As HDITEM HI
			With HI
				.mask       = HDI_FORMAT OR HDI_WIDTH OR HDI_LPARAM OR HDI_TEXT
				.pszText    = @FCaption
				.cchTextMax = Len(FCaption)
				.cxy        = PSection->Width 
				.fmt        = AFmt(Abs_(PSection->Alignment))
				.iImage     = FImageIndex
				If .iImage <> -1 Then
				   .mask = .mask OR HDI_IMAGE 
				   .fmt  = .fmt OR HDF_IMAGE 
				End If
				If PSection->Style > 0 Then
					.fmt = .fmt OR HDF_OWNERDRAW
				Else
					.fmt = .fmt OR HDF_STRING
				End If
				.hbm        = NULL
				.lParam     = Cast(LParam,PSection)
			End With
			If Handle Then Perform(HDM_INSERTITEM, SectionCount - 1, CInt(@HI))
		#EndIf 
    End Sub

    #IfnDef __fb_64bit__
    Sub Header.AddSections CDECL(FCount As Integer,...)
        Dim As Any Ptr Arg
        Dim As HeaderSection Ptr PSection
        Arg = va_First()
        For i As Integer = 0 To FCount -1 
            PSection = New HeaderSection
            With *PSection
                .HeaderControl = @This
                .Caption       = *va_Arg(Arg, WString Ptr)
            End With
            FSections.Add PSection
            #IfNDef __USE_GTK__
				Dim As HDITEM HI
				With HI
					.mask       = HDI_FORMAT OR HDI_LPARAM OR HDI_TEXT OR HDI_WIDTH    
					.pszText    = @PSection->Caption
					.cchTextMax = Len(PSection->Caption)
					.cxy        = PSection->Width 
					.fmt        = AFmt(Abs_(PSection->Alignment))
					.iImage     = PSection->ImageIndex
					If .iImage <> -1 Then
						.mask = .mask OR HDI_IMAGE 
						.fmt  = .fmt OR HDF_IMAGE 
					End If
					If PSection->Style Then
						.fmt = .fmt OR HDF_OWNERDRAW
					Else
						.fmt = .fmt OR HDF_STRING
					End If
					.hbm        = NULL
					.lParam     = Cast(LParam,PSection)
				End With
				If Handle Then Perform(HDM_INSERTITEM, SectionCount - 1, CInt(@HI))
			#EndIf
			Arg = va_Next(Arg, WString Ptr)
        Next i
    End Sub
    #EndIf

    Sub Header.RemoveSection(Index As Integer)
        If Index >= 0 And Index <= SectionCount -1 Then
           FSections.Remove Index
           #IfNDef __USE_GTK__
				If Handle Then Perform(HDM_DELETEITEM, Index, 0)
			#EndIf
        End If
    End Sub

    Operator Header.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor Header
        #IfNDef __USE_GTK__
			AStyle(0)       = HDS_BUTTONS
			AStyle(1)       = 0
			AFullDrag(0)    = 0
			AFullDrag(1)    = HDS_FULLDRAG
			AHotTrack(0)    = 0
			AHotTrack(1)    = HDS_HOTTRACK
			ADragReorder(0) = 0
			ADragReorder(1) = HDS_DRAGDROP
			AFmt(0)         = HDF_LEFT
			AFmt(1)         = HDF_CENTER
			AFmt(2)         = HDF_RIGHT
			AFmt(3)         = HDF_RTLREADING
		#EndIf
        FFullDrag       = True
        FDragReorder    = False
        With This
			.Child             = @This
			#IfNDef __USE_GTK__
				.RegisterClass "Header", WC_HEADER
				.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD OR AStyle(Abs_(FStyle)) OR AFullDrag(Abs_(FFullDrag)) OR AHotTrack(Abs_(FHotTrack)) OR ADragReorder(Abs_(FDragReorder))
				.BackColor             = GetSysColor(COLOR_BTNFACE) 
				.OnHandleIsAllocated = @HandleIsAllocated
				WLet FClassAncestor, WC_HEADER
            #EndIf
            WLet FClassName, "Header"
            .Width             = 150
            .Height            = 24
            .Align             = 3
        End With  
    End Constructor

    Destructor Header
        FSections.Clear 
    End Destructor
End namespace    
