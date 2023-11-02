'################################################################################
'#  Grid.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################
#include once "DateTimePicker.bi"
#include once "TextBox.bi"
#include once "ComboBoxEdit.bi"
#include once "ListView.bi"
#include once "ImageList.bi"

#define CHRCheck WChr(30)
#define CHRUnCheck WChr(31)
#define BLANKROW 999999999

Private Enum GridDataTypeEnum
	DT_Nothing=0
	DT_Numeric = 1
	DT_LinkLabel = 2
	DT_Boolean = 3
	DT_ProgressBar = 4
	DT_Custom = 5
	DT_Button = 6
	DT_ComBoBoxEdit = 7
	DT_Date = 8
	DT_Time = 9
	DT_String = 10
End Enum

Private Enum GridControlTypeEnum
	CT_Header=9990
	CT_CheckBox = 9991
	CT_LinkLabel = 9992
	CT_DateTimePicker = 9993
	CT_ProgressBar = 9994
	CT_Custom = 9995
	CT_Button = 9996
	CT_ComboBoxEdit = 9997
	CT_TextBox = 9999
End Enum

Private Enum FocusRectEnum
	FocusRect_None = 0
	FocusRect_Row = 1
	FocusRect_Col = 2
	FocusRect_Free = 3
End Enum

Private Enum GridFocusRectModeEnum
	GridFocus_None = 0
	GridFocus_Row = 1
	GridFocus_Col = 2
End Enum

Private Enum GridLines
	GridLine_None
	GridLine_Both
	GridLine_Vertical
	GridLine_Horizontal
End Enum

Namespace My.Sys.Forms
	#define QGridData(__Ptr__) (*Cast(GridData Ptr,__Ptr__))
	#define QGridDataItem(__Ptr__) (*Cast(GridDataItem Ptr,__Ptr__))
	#define QGridDataColumn(__Ptr__) (*Cast(GridDataColumn Ptr,__Ptr__))

	Private Type PGridDataItem As GridDataItem Ptr
	Private Type GridDataItems
	Private:
		FItems As List
		PItem As PGridDataItem
		FParentItem As PGridDataItem
		#ifndef __USE_GTK__
			lviItems As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PGridDataItem
		#else
			Declare Function FindByHandle(Value As LPARAM) As PGridDataItem
		#endif
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As PGridDataItem
		Declare Property Item(Index As Integer, Value As PGridDataItem)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0,tLocked As Boolean=False, Indent As Integer = 0) As PGridDataItem
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0,tLocked As Boolean=False, Indent As Integer = 0) As PGridDataItem
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0,tLocked As Boolean=False, Indent As Integer = 0) As PGridDataItem
		Declare Sub Remove(Index As Integer)
		Declare Property ParentItem As PGridDataItem
		Declare Property ParentItem(Value As PGridDataItem)
		Declare Function IndexOf(ByRef FItem As PGridDataItem) As Integer
		Declare Function IndexOf(ByRef FCaption As WString, ByVal WholeWords As Boolean = True, ByVal MatchCase As Boolean = True) As Integer
		Declare Function Contains(ByRef FCaption As WString, ByVal WholeWords As Boolean = True, ByVal MatchCase As Boolean = True) As Boolean
		Declare Sub Clear
		Declare Sub Sort
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type

	Private Type GridDataItem Extends My.Sys.Object
	Private:
		FText               As WString Ptr
		FHint               As WString Ptr
		FSubItems           As WStringList
		FImageIndex         As Integer
		FSelectedImageIndex As Integer
		FSmallImageIndex    As Integer
		FImageKey           As WString Ptr
		FSelectedImageKey   As WString Ptr
		FSmallImageKey      As WString Ptr
		FParentItem As PGridDataItem
		FVisible            As Boolean
		FState              As Integer
		FLocked	            As Boolean  =False
		FIndent             As Integer
		FExpanded			As Boolean
		mCellBackColor(Any)     As Integer
		mCellForeColor(Any)     As Integer

		#ifndef __USE_GTK__
			Dim lviItem             As LVITEM

		#endif
	Protected:
		#ifndef __USE_GTK__

		#endif
	Public:
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#else
			HANDLE As LPARAM
			Declare Function GetItemIndex() As Integer
		#endif
		Parent   As Control Ptr
		Items As GridDataItems
		Tag As Any Ptr
		Declare Sub SelectItem
		Declare Sub Collapse
		Declare Sub Expand
		Declare Function IsExpanded As Boolean
		Declare Function Index As Integer
		Declare Property Text(iSubItem As Integer) ByRef As WString
		Declare Property Text(iSubItem As Integer, ByRef Value As WString)
		Declare Property ForeColor(iSubItem As Integer,Value As Integer)
		Declare Property ForeColor(iSubItem As Integer)As Integer
		Declare Property BackColor(iSubItem As Integer,Value As Integer)
		Declare Property BackColor(iSubItem As Integer)As Integer
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ParentItem As PGridDataItem
		Declare Property ParentItem(Value As PGridDataItem)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property SmallImageIndex As Integer
		Declare Property SmallImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property SmallImageKey ByRef As WString
		Declare Property SmallImageKey(ByRef Value As WString)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property State As Integer
		Declare Property State(Value As Integer)
		Declare Property Locked As Boolean
		Declare Property Locked(Value As Boolean)
		Declare Property Indent As Integer
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'OnClick As Sub(ByRef Designer As My.Sys.Object, BYREF Sender As My.Sys.Object)
		'OnDblClick As Sub(ByRef Designer As My.Sys.Object, BYREF Sender As My.Sys.Object)
	End Type

	Private Type GridDataColumn Extends My.Sys.Object
	Private:
		FText         As WString Ptr
		FHint         As WString Ptr
		FImageIndex   As Integer =0
		FColWidth     As Integer =20
		FFormat       As ColumnFormat = cfCenter
		FFormatHeader As ColumnFormat = cfCenter
		FVisible      As Boolean =False
		FLocked	      As Boolean  =False
		FMuiltLine    As Boolean  =False
		FControlType   As Integer = CT_TextBox
		FDataType     As Integer = DT_String
		FGridEditComboItem As WString Ptr
		FSortOrder    As SortStyle
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
		#endif
		Index As Integer
		Parent   As Control Ptr
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property Editable As Boolean
		Declare Property Editable(Value As Boolean)
		Declare Property MuiltLine As Boolean
		Declare Property MuiltLine(Value As Boolean)
		Declare Property Locked As Boolean
		Declare Property Locked(Value As Boolean)
		Declare Property ControlType As Integer
		Declare Property ControlType(Value As Integer)
		Declare Property SortOrder As SortStyle
		Declare Property SortOrder(Value As SortStyle)
		Declare Property GridEditComboItem ByRef As WString
		Declare Property GridEditComboItem(ByRef Value As WString)
		Declare Property DataType As Integer
		Declare Property DataType(Value As Integer)
		Declare Property ColWidth As Integer
		Declare Property ColWidth(Value As Integer)
		Declare Property Format As ColumnFormat
		Declare Property Format(Value As ColumnFormat)
		Declare Property FormatHeader As ColumnFormat
		Declare Property FormatHeader(Value As ColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'OnClick As Sub(ByRef Designer As My.Sys.Object, BYREF Sender As My.Sys.Object)
		'OnDblClick As Sub(ByRef Designer As My.Sys.Object, BYREF Sender As My.Sys.Object)
	End Type

	Private Type GridDataColumns
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As GridDataColumn Ptr
		Declare Property Column(Index As Integer, Value As GridDataColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, tFormat As ColumnFormat = cfLeft, tDataType As GridDataTypeEnum = DT_String, tLocked As Boolean = False, tControlType As GridControlTypeEnum = CT_TextBox, ByRef tComboItem As WString = "", tSortOrder As SortStyle = SortStyle.ssSortAscending) As GridDataColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, tFormat As ColumnFormat = cfLeft, tDataType As GridDataTypeEnum = DT_String, tLocked As Boolean = False, tControlType As GridControlTypeEnum = CT_TextBox, ByRef tComboItem As WString = "", tSortOrder As SortStyle = SortStyle.ssSortAscending)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FColumn As GridDataColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type

	Private Type GridData Extends Control
	Private:
		mFBold                 As Boolean = False
		mFItalic               As Boolean = False
		mFUnderline            As Boolean = False
		mFStrikeOut            As Boolean = False
		mFSize                 As Integer = 11
		mFName                 As WString Ptr
		mFCharSet              As Integer = FontCharset.Default
		mFBolds(2)             As Integer
		mFCyPixels             As Integer = 0
		mFEscapement           As Integer = 0
		mFOrientation          As Integer = 0

		#ifndef __USE_GTK__
			mFontHandleBody        As HFONT
			mFontHandleBodyUnderline As HFONT 'For Link Text
			mFontHandleHeader     As HFONT
		#endif

		mFontHeight            As Integer = 6
		mFontWidth             As Integer  =6

		mFBoldHeader          As Boolean = True
		mFItalicHeader        As Boolean = False
		mFUnderlineHeader     As Boolean = False
		mFStrikeOutHeader     As Boolean = False
		mFSizeHeader          As Integer = 11
		mFNameHeader          As WString Ptr
		mHeaderForeColor      As Integer = clBlack
		mHeaderBackColor      As Integer = BGR(226, 226, 226)'clLtGray' clDkGray'clBtnFace
		mFCharSetHeader       As Integer = FontCharset.Default
		mFBoldsHeader(2)      As Integer
		mFCyPixelsHeader      As Integer = 0
		mFEscapementHeader    As Integer= 0
		mFOrientationHeader   As Integer = 0

		FView                 As ViewStyle
		FColumnHeaderHidden   As Boolean
		FSingleClickActivate  As Boolean
		FSortStyle            As SortStyle

		GridEditComboBox      As ComboBoxEdit
		GridEditText          As TextBox
		GridEditDateTimePicker As DateTimePicker
		ImgListGrid            As ImageList

		#ifdef __USE_WINAPI__
			FLvi                  As LVITEM
			mHandleHeader             As HWND
			mClientRect               As Rect
			mClientRectHeader         As Rect
		#endif
		mRowHeightHeader          As Integer = -1
		mRowHeight                As Integer = -1
		mRowHeightShow(Any)       As Integer
		#ifdef __USE_WINAPI__
			mGridDC                   As HDC
			mGridDCHeader             As HDC
		#endif
		mRow                      As Integer =0
		mCol                      As Integer =1
		mRowHover                 As Integer = 0
		mColHover                 As Integer = 1
		FItems                    As List
		'GRID PROPER
		mGridLineDrawMode        As GridLines
		mGridColorLine           As Integer = clSilver'BGR(166, 166, 166)'clSilver
		mGridColorLineHeader     As Integer = clWhite'BGR(166, 166, 166)'clSilver
		mGridColorSelected       As Integer = &HFFFFE6 '&HFFFFDE ' &HFEE8FFFF 'BGR(210, 238, 245)'BGR(178, 214, 255)
		mGridColorHover          As Integer = BGR(110, 228, 255)
		mGridColorBack           As Integer = clWhite
		mGridColorFore           As Integer = clBlack
		mGridColorEditBack       As Integer = BGR(190, 255, 255)' &H9AFA00'clWhite
		mGridLineWidth           As Integer = 1
		#ifdef __USE_WINAPI__
			mGridLinePenMode         As Integer = PS_SOLID
		#else
			mGridLinePenMode         As Integer
		#endif
		mGridFocusRect           As FocusRectEnum = FocusRect_Row
		mShowHoverBar            As Boolean = True
		mShowSelection           As Boolean = True
		mSortColumn              As Integer =0
		mSorting                 As Boolean=False
		mCountPerPage            As Integer = -1
		mDrawRowStart            As Integer = -1
		mDrawTimeLast            As Double = 0
		mAllowEdit               As Boolean = False
		mSysScrollWidth          As Integer = 20
		mScrollMaxV              As Integer = 0

		#ifdef __USE_WINAPI__
			Declare Sub EditControlShow(ByRef tComboColOld As Integer, ByVal tRow As Integer, ByVal tCol As Integer)
			Declare Sub DrawRect(tDc As HDC, R As Rect, FillColor As Integer = -1, tSelctionRow As Integer = -1, tSelctionCol As Integer = -1)
			Declare Sub DrawLine(HDC As HDC, x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer, lColor As Integer, lWidth As Integer = 1, lLineType As Integer = PS_SOLID)
			Declare Sub DrawSortArrow(DC As HDC, lX As Integer, lY As Integer, lWidth As Integer, lStep As Integer, nOrientation As SortStyle)
			Declare Sub GridReDraw(RowShowStart As Integer, RowShowEnd As Integer, RowHover As Integer = -1, ColHover As Integer = -1, DrawHeadOnly As Boolean = False)
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		#endif
		Declare Sub ProcessMessage(ByRef Message As Message)
		Declare Sub SortData(iCol As Integer,tSortStyle As SortStyle)

	Protected:
		#ifdef __USE_GTK__
			Declare Static Function GridData_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub GridData_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Sub GridData_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub GridData_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
		#else
			Declare Function GetGridDataItem(Item As Integer) As GridDataItem Ptr
		#endif
	Public:
		#ifdef __USE_GTK__
			TreeStore As GtkTreeStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			ColumnTypes As GType Ptr
		#endif
		ListItems         As GridDataItems
		Columns           As GridDataColumns
		Images            As ImageList Ptr
		StateImages       As ImageList Ptr
		SmallImages       As ImageList Ptr
		GroupHeaderImages As ImageList Ptr

		Declare Sub Init()
		Declare Sub EnsureVisible(Index As Integer)
		Declare Sub SetGridLines(tFocusRect As Integer=-1,tDrawMode As Integer=-1,tColorLine As Integer=-1,tColorLineHeader As Integer=-1,tColorEditBack As Integer=-1,tColorSelected As Integer=-1,tColorHover As Integer=-1,tWidth As Integer=-1,PenMode As Integer=-1)
		Declare Sub SetFontHeader(tFontColor As Integer=-1,tFontColorBK As Integer=-1,tNameHeader As WString="",tSizeHeader As Integer=-1,tCharSetHeader As Integer=FontCharset.Default,tBoldsHeader As Boolean=False,tItalicHeader As Boolean=False,tUnderlineHeader As Boolean=False,tStrikeoutHeader As Boolean=False)
		Declare Sub SetFont(tName As WString="",tSize As Integer=-1,tCharSet As Integer=FontCharset.Default,tBolds As Boolean=False,tItalic As Boolean=False,tUnderline As Boolean=False,tStrikeout As Boolean=False)
		Declare Sub CollapseAll
		Declare Sub ExpandAll
		Declare Property ColumnHeaderHidden As Boolean
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property View As ViewStyle
		Declare Property View(Value As ViewStyle)
		Declare Property Sort As SortStyle
		Declare Property Sort(Value As SortStyle)
		Declare Sub Refresh()
		Declare Property SelectedItem As GridDataItem Ptr
		Declare Property SelectedItem(Value As GridDataItem Ptr)
		Declare Property SelectedItemIndex As Integer
		Declare Property SelectedItemIndex(Value As Integer)
		Declare Property SelectedColumn As GridDataColumn Ptr
		Declare Property SelectedColumn(Value As GridDataColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		Declare Property SingleClickActivate(Value As Boolean)
		#ifdef __USE_WINAPI__
			Declare Property HandleHeader As HWND
			Declare Property HandleHeader(Value As HWND)
		#endif
		Declare Property RowHeightHeader As Integer
		Declare Property RowHeightHeader(Value As Integer)
		Declare Property RowHeight As Integer
		Declare Property RowHeight(Value As Integer)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property ForeColor As Integer
		Declare Property ForeColor(Value As Integer)
		Declare Property ShowHoverBar As Boolean
		Declare Property ShowHoverBar(ByVal Value As Boolean)
		Declare Property ShowSelection As Boolean
		Declare Property ShowSelection(ByVal Value As Boolean)
		Declare Property AllowEdit As Boolean
		Declare Property AllowEdit(Value As Boolean)

		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnHeadClick                 As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ColIndex As Integer)
		OnHeadColWidthAdjust        As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ColIndex As Integer)
		OnItemActivate              As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ByRef Item As GridDataItem Ptr)
		#ifdef __USE_WINAPI__
			OnItemClick             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, RowIndex As Integer, ColIndex As Integer, tGridDCC As HDC)
			OnItemDblClick          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, RowIndex As Integer, ColIndex As Integer, tGridDCC As HDC)
		#endif
		OnItemKeyDown               As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ByRef Item As GridDataItem Ptr)
		OnItemExpanding             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ByRef Item As GridDataItem Ptr)
		OnCellEditing               As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ByRef Item As GridDataItem Ptr, SubItemIndex As Integer, CellEditor As Control Ptr)
		OnCellEdited                As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, ByRef Item As GridDataItem Ptr, SubItemIndex As Integer, ByRef NewText As WString)
		#ifdef __USE_WINAPI__
			OnSelectedItemChanged   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData, RowIndex As Integer, ColIndex As Integer, tGridDCC As HDC)
		#endif
		OnBeginScroll               As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData)
		OnEndScroll                 As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridData)
	End Type

End Namespace

#ifndef __USE_MAKE__
	#include once "GridData.bas"
#endif
 
