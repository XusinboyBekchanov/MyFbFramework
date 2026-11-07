'################################################################################
'#  GridDataEx.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Converted from: VBFlexGrid.ctl of VBFLXGRD18 (VB GridDataEx Control 1.8)      #
'#  Original author of the VB6 source: Krool (VBFlexGrid)                       #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'#                                                                              #
'#  A fully owner-drawn flexible grid control in the spirit of the VB           #
'#  MSGridData/MSHGridData, restructured as a MyFbFramework control             #
'#  (Extends UserControl) following the same layout conventions as MFF Grid.    #
'#                                                                              #
'#  Conversion status (batch 2):                                                #
'#   - Data model, TextMatrix/TextArray/CellXxx, AddItem/RemoveItem/Clear,     #
'#     Clip/Copy/Cut/Paste/Delete (system clipboard), Undo/Redo queue          #
'#   - Row/Col info API: Hidden/Selected/Data/ID/Resizable/Pos/Position/       #
'#     Key/Index/IsVisible/RowsVisible..., ColAlignment/FixedAlignment/        #
'#     ColSort/ColSortArrow/ColComboCue/ColCheckBoxes/ColDataType...           #
'#   - Appearance: GridLines(Fixed/Frozen), GridColor(Fixed/Frozen),           #
'#     BackColorAlt banding, TextStyle, FocusRect styles, sort arrows,         #
'#     check boxes (incl. per-cell override), flood fill, ellipsis/wrap        #
'#   - Editing: in-place FlexEditTextBox with EditRow/EditText/EditSel*,       #
'#     EditMaxLength, keyboard navigation (Shift/Ctrl+arrows, Tab cells,       #
'#     Return direction), Before/AfterEdit, EditChange/KeyDown events          #
'#   - Hit test (HitRow/HitCol/HitResult), HitTest, GetMetrics, AutoSize,      #
'#     CellEnsureVisible, BottomRow/RightCol, incremental search               #
'#   - Cell pictures/icons: SetCellPicture / CellPicture* properties render a  #
'#     HICON or HBITMAP per cell at an individual size in any of the 9         #
'#     FlexPictureAlignment directions, stretched, tiled or NoOverlap          #
'#   - Best fit: AutoSize measures with per-cell fonts, word-wrap line counts  #
'#     and BestFitMode reserves (text / sort arrow / checkbox / picture)       #
'#   - Cell editors by ColComboMode: DropDown/Editable use an in-place         #
'#     ComboBoxEdit fed by ColComboItems (CR separated, ColComboBoundColumn    #
'#     picks the value field); Calendar pops a MonthCalendar writing           #
'#     YYYY-MM-DD; Calculator pops a key panel whose = writes the result       #
'#     honoring ColNumericScale. ShowDropDown/CloseDropDown/ComboListIndex,    #
'#     F4 / Alt+Down / combo-cue click open them, click-away commits           #
'#   Not ported (COM-specific): DataSource/DataMember/CopyFromRecordset,       #
'#   OLE drag-drop, pictures (CellPicture/WallPaper), ColImageList, IME,       #
'#   property pages / OCX registration.                                        #
'#                                                                              #
'#  Event handlers: follow the MyFbFramework convention - a member handler     #
'#  omits the leading ByRef Designer parameter (the hidden This instance       #
'#  receives it). Example:                                                     #
'#    Sub Grid1_RowColChange(ByRef Sender As GridDataEx)                         #
'#  assigned via:  .OnRowColChange = Cast(Sub(ByRef Designer As My.Sys.Object, #
'#                   ByRef Sender As GridDataEx), @Grid1_RowColChange)           #
'################################################################################

#pragma once

#include once "TextBox.bi"
#include once "ComboBoxEdit.bi"
#include once "MonthCalendar.bi"
#include once "Panel.bi"
#include once "Form.bi"
#include once "Ruler.bi"
#include once "Report.bi"
#include once "PrintDocument.bi"
#include once "Label.bi"
#include once "CommandButton.bi"
#include once "GridDataExEnums.bi"
#include once "Clipboard.bi"

#ifdef __USE_WINAPI__
	#include once "win\commctrl.bi"
	#include once "win\shellapi.bi"
	#include once "win\winspool.bi"
	#include once "win\windowsx.bi"
#else
	'The key codes of Windows: the grid works with them on every platform (the Web and
	'Android send them in CM_KEYDOWN, the keys of GTK are translated by FlexKeyToVK)
	#ifndef VK_LBUTTON
		#define VK_LBUTTON &h01
	#endif
	#ifndef VK_RBUTTON
		#define VK_RBUTTON &h02
	#endif
	#ifndef VK_MBUTTON
		#define VK_MBUTTON &h04
	#endif
	#ifndef VK_BACK
		#define VK_BACK &h08
	#endif
	#ifndef VK_TAB
		#define VK_TAB &h09
	#endif
	#ifndef VK_RETURN
		#define VK_RETURN &h0D
	#endif
	#ifndef VK_SHIFT
		#define VK_SHIFT &h10
	#endif
	#ifndef VK_CONTROL
		#define VK_CONTROL &h11
	#endif
	#ifndef VK_MENU
		#define VK_MENU &h12
	#endif
	#ifndef VK_ESCAPE
		#define VK_ESCAPE &h1B
	#endif
	#ifndef VK_SPACE
		#define VK_SPACE &h20
	#endif
	#ifndef VK_PRIOR
		#define VK_PRIOR &h21
	#endif
	#ifndef VK_NEXT
		#define VK_NEXT &h22
	#endif
	#ifndef VK_END
		#define VK_END &h23
	#endif
	#ifndef VK_HOME
		#define VK_HOME &h24
	#endif
	#ifndef VK_LEFT
		#define VK_LEFT &h25
	#endif
	#ifndef VK_UP
		#define VK_UP &h26
	#endif
	#ifndef VK_RIGHT
		#define VK_RIGHT &h27
	#endif
	#ifndef VK_DOWN
		#define VK_DOWN &h28
	#endif
	#ifndef VK_INSERT
		#define VK_INSERT &h2D
	#endif
	#ifndef VK_DELETE
		#define VK_DELETE &h2E
	#endif
	#ifndef VK_NUMPAD0
		#define VK_NUMPAD0 &h60
	#endif
	#ifndef VK_MULTIPLY
		#define VK_MULTIPLY &h6A
	#endif
	#ifndef VK_ADD
		#define VK_ADD &h6B
	#endif
	#ifndef VK_SUBTRACT
		#define VK_SUBTRACT &h6D
	#endif
	#ifndef VK_DECIMAL
		#define VK_DECIMAL &h6E
	#endif
	#ifndef VK_DIVIDE
		#define VK_DIVIDE &h6F
	#endif
	#ifndef VK_F1
		#define VK_F1 &h70
	#endif
	#ifndef VK_F2
		#define VK_F2 &h71
	#endif
	#ifndef VK_F4
		#define VK_F4 &h73
	#endif
	#ifndef VK_F12
		#define VK_F12 &h7B
	#endif
	'The indexes of the system colors of Windows (FlexSysColor)
	#ifndef COLOR_SCROLLBAR
		#define COLOR_SCROLLBAR 0
	#endif
	#ifndef COLOR_WINDOW
		#define COLOR_WINDOW 5
	#endif
	#ifndef COLOR_WINDOWTEXT
		#define COLOR_WINDOWTEXT 8
	#endif
	#ifndef COLOR_HIGHLIGHT
		#define COLOR_HIGHLIGHT 13
	#endif
	#ifndef COLOR_HIGHLIGHTTEXT
		#define COLOR_HIGHLIGHTTEXT 14
	#endif
	#ifndef COLOR_BTNFACE
		#define COLOR_BTNFACE 15
	#endif
	#ifndef COLOR_BTNSHADOW
		#define COLOR_BTNSHADOW 16
	#endif
	#ifndef COLOR_GRAYTEXT
		#define COLOR_GRAYTEXT 17
	#endif
	#ifndef COLOR_BTNTEXT
		#define COLOR_BTNTEXT 18
	#endif
	#ifndef COLOR_BTNHIGHLIGHT
		#define COLOR_BTNHIGHLIGHT 20
	#endif
	#ifndef COLOR_3DDKSHADOW
		#define COLOR_3DDKSHADOW 21
	#endif
	#ifndef COLOR_3DLIGHT
		#define COLOR_3DLIGHT 22
	#endif
	#ifndef COLOR_INFOTEXT
		#define COLOR_INFOTEXT 23
	#endif
	#ifndef COLOR_INFOBK
		#define COLOR_INFOBK 24
	#endif
	#ifndef COLOR_HOTLIGHT
		#define COLOR_HOTLIGHT 26
	#endif
	#ifndef GetSysColor
		#define GetSysColor(Index) My.Sys.Forms.FlexSysColor(Index)
	#endif
#endif

Namespace My.Sys.Forms
	#define QGridDataEx(__Ptr__) (*Cast(GridDataEx Ptr, __Ptr__))

	'=== GridDataEx common helpers (absorbed from GridDataCommon.bas, which was
	'removed: the byte/word macros, DPI queries and clipboard routines only
	'wrapped MFF/WinAPI equivalents and are replaced by them at the call
	'sites; the remaining helpers live here and in GridDataEx.bas) ===
	'Shift key state constants (mirror of VB ShiftConstants).
	Const FLEX_SHIFT_MASK = 1
	Const FLEX_CTRL_MASK = 2
	Const FLEX_ALT_MASK = 4
	'Mouse button state constants.
	Const FLEX_LEFT_BUTTON = 1
	Const FLEX_RIGHT_BUTTON = 2
	Const FLEX_MIDDLE_BUTTON = 4
	'VB OLE colors are direct BGR values in this control context. System color
	'constants (&H80000000 and above) translate through GetSysColor on Windows;
	'other platforms keep the raw value.
	Declare Function FlexWinColor(ByVal CrColor As Long) As Long
	#ifdef __USE_WINAPI__
		'State readers for the raw WinAPI message path; the other platforms
		'receive the state with the input messages (CM_*, GdkEvent)
		Declare Function FlexGetShiftStateFromMsg() As Integer
		Declare Function FlexGetMouseState() As Integer
		Declare Function FlexKeyPressed(ByVal KeyCode As Long) As Boolean
		Declare Sub FlexSetWindowRedraw(ByVal hWnd As HWND, ByVal Enabled As Boolean)
	#else
		'The system colors of the light scheme (GetSysColor of Windows)
		Declare Function FlexSysColor(ByVal Index As Long) As Long
		#ifdef __USE_GTK__
			'A key of GTK (a GDK keyval) as the key code of Windows (VK_*)
			Declare Function FlexKeyToVK(ByVal KeyVal As Long) As Long
		#endif
	#endif

	Type PFlexCell As FlexCell Ptr

	'Per-cell custom formatting. lpFmtg is allocated lazily only when a cell
	'differs from defaults, mirroring the VB6 TCELL.lpFmtg design.
	'Font style bits mirror the VB6 FS_* flags.
	Const FLEX_FS_BOLD = &H1
	Const FLEX_FS_ITALIC = &H2
	Const FLEX_FS_UNDERLINE = &H4
	Const FLEX_FS_STRIKEOUT = &H8

	Type FlexCellFormat
		TextStyle As Integer = -1            'As FlexTextStyleConstants
		Alignment As Integer = -1           'As FlexAlignmentConstants
		PictureAlignment As Integer = -1     'As FlexPictureAlignmentConstants
		BackColor As Long = -1
		ForeColor As Long = -1
		ComboCue As Integer = -1             'As FlexComboCueConstants
		Checked As Integer = -1              'As FlexCheckBoxConstants
		FloodPercent As Integer = 0
		FloodColor As Long = -1
		ToolTipText As WString Ptr = 0
		FontName As WString Ptr = 0          '0/empty = inherit control font
		FontSize As Integer = 0              '0 = inherit
		FontStyle As Integer = 0             'FLEX_FS_* combination
		FontCharset As Integer = -1
		'Cell picture / icon: raw graphic handle (HICON or HBITMAP). The grid
		'does not own the handle - the caller keeps it alive.
		PictureHandle As Any Ptr = 0
		PictureIsIcon As Boolean = True      'False = HBITMAP
		PictureWidth As Long = 0             'render size in pixels, 0 = native
		PictureHeight As Long = 0
		Declare Sub Clear
		Declare Destructor
	End Type

	'Single cell: text plus optional formatting block and tag.
	Type FlexCell
		FText As WString Ptr = 0
		Fmtg As FlexCellFormat Ptr = 0
		FHasFmtg As Boolean = False
		TagPtr As Any Ptr = 0
		FHasTag As Boolean = False
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Sub ClearText
		Declare Destructor
	End Type

	'Row state flags (mirror RWIS_*).
	Const FLEX_RWIS_HIDDEN = &H1
	Const FLEX_RWIS_MERGE = &H2
	Const FLEX_RWIS_SELECTED = &H4
	Const FLEX_RWIS_NOSIZING = &H8
	Const FLEX_RWIS_FILTERED = &H10
	Const FLEX_RWIS_BOOKMARK = &H20

	Type FlexRowInfo
		Height As Long = -1                  '-1 = use default height
		State As Long = 0                    'RWIS_* combination
		ID As Long = -1
		Data As Any Ptr = 0                  'RowData (user value)
	End Type

	'Column state flags (mirror CLIS_*).
	Const FLEX_CLIS_HIDDEN = &H1
	Const FLEX_CLIS_MERGE = &H2
	Const FLEX_CLIS_NULLABLE = &H4
	Const FLEX_CLIS_NOSIZING = &H8
	Const FLEX_CLIS_CHECKBOXES = &H10
	Const FLEX_CLIS_TEXTINDENT = &H200
	Const FLEX_CLIS_CHECKBOXESHTI = &H400       'checkboxes visible but not hit-testable
	Const FLEX_CLIS_CHECKBOXESHTIFIXED = &H800
	Const FLEX_CLIS_CELLBUTTONS = &H1000        'data cells render as buttons

	Type FlexColInfo
		Width As Long = -1                   '-1 = use default width
		State As Long = 0                     'CLIS_* combination
		Key As WString Ptr = 0
		Alignment As Integer = FlexAlignmentGeneral
		FixedAlignment As Integer = -1
		WordWrapOption As Integer = -1         'As FlexWordWrapOptions
		WordWrapOptionFixed As Integer = -1
		MimicTextBox As Integer = -1           'As FlexMimicTextBoxConstants
		MimicTextBoxFixed As Integer = -1
		Sort As Integer = FlexSortNone          'As FlexSortConstants
		SortMode As Integer = FlexSortModeNormal
		SortArrow As Integer = FlexSortArrowNone
		SortArrowAlignment As Integer = FlexLeftRightAlignmentRight
		SortArrowColor As Long = -1
		ComboCue As Integer = FlexComboCueNone
		ComboMode As Integer = FlexComboModeNone
		ComboItems As WString Ptr = 0          'CR separated dropdown items
		ComboHeader As WString Ptr = 0
		ComboBoundColumn As Long = -1          'tab field written back, -1 = whole item
		CheckBoxes As Integer = 0              'Boolean stored as int for state copy
		CheckBoxAlignment As Integer = FlexCheckBoxAlignmentUsePictureAlignment
		FixedCheckBoxAlignment As Integer = -1
		DataType As Integer = 0
		NumericPrecision As UByte = 0
		NumericScale As UByte = 0
		DataCapacity As Long = 0
		Data As Any Ptr = 0                    'ColData (user value)
		FormatStr As WString Ptr = 0           'ColFormat
		FixedFormatStr As WString Ptr = 0      'FixedFormat
		Filter As WString Ptr = 0              'ColFilter criteria ("" = none)
		Lookup As WString Ptr = 0              'ColLookup "key;value|key;value"
	End Type

	'Non-contiguous selected rows list.
	Type FlexSelectedRows
		Rows(Any) As Long
		Count As Integer = 0
	End Type

	'Multi-sort key: one entry per MultiSortAdd call; the first added key is
	'the primary sort column.
	Type FlexSortKey
		Col As Long = 0
		SortType As Integer = FlexSortGenericAscending
	End Type

	'Print/report pagination layout (built once, shared by preview pages).
	Type FlexReportLayout
		PageWIn As Double = 8.27          'A4 portrait inches
		PageHIn As Double = 11.69
		ColStart(Any) As Long             'first visible column of each column group
		RowStart(Any) As Long             'first visible row of each row group
		ColPages As Long = 1
		RowPages As Long = 1
		ColScale As Double = 1.0          'fit-to-width column shrink factor
	End Type


	'Undo/Redo queue entry (mirrors VB6 TUNDOREDOENTRY, text-only).
	Type FlexUndoEntry
		OldText As WString Ptr = 0
		NewText As WString Ptr = 0
		Row As Long = 0
		Col As Long = 0
		RowSel As Long = 0
		ColSel As Long = 0
		Declare Destructor
	End Type

	'In-place editor: a TextBox that forwards keys and text changes to the host GridDataEx.
	Type FlexEditTextBox Extends TextBox
		Public:
			Grid As Any Ptr = 0
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			#ifndef __USE_WINAPI__
				'The keys of the editor (OnKeyDown) on the platforms without WM_KEYDOWN
				Declare Static Sub Edit_KeyDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			#endif
			Declare Static Sub Edit_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
			Declare Static Sub Edit_LostFocus(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
	End Type
'`GridDataEx` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`GridDataEx` - Advanced grid control supporting hierarchical data and multiple selection modes.
	Private Type GridDataEx Extends Control
	Private:
		'=== Data model (mirrors VBFlexGridCells / VBFlexGridColsInfo) ===
		Dim CellsArr(Any) As FlexCell Ptr       'flat array Rows*Cols, index Row*FCols+Col
		Dim RowsArr(Any) As FlexRowInfo
		Dim ColsArr(Any) As FlexColInfo
		Dim FRows As Long = 2
		Dim FCols As Long = 2

		'=== Geometry ===
		Dim FDefaultRowHeight As Long = 240    'twips
		Dim FDefaultColWidth As Long = 1200    'twips

		'=== Current cell / selection ===
		Dim FRow As Long = 0
		Dim FCol As Long = 0
		Dim FRowSel As Long = 0
		Dim FColSel As Long = 0
		Dim FTopRow As Long = 0
		Dim FLeftCol As Long = 0

		'=== Properties (Prop* fields mirror the VB6 Prop module-level vars) ===
		Dim FFixedRows As Long = 1
		Dim FFixedCols As Long = 1
		Dim FFrozenRows As Long = 0
		Dim FFrozenCols As Long = 0
		Dim FBackColorBkg As Long
		Dim FBackColorFixed As Long
		Dim FBackColorSel As Long
		Dim FForeColorFixed As Long
		Dim FForeColorSel As Long
		Dim FGridColor As Long
		Dim FGridColorFixed As Long
		Dim FGridLines As Integer = GridDataLineFlat
		Dim FGridLinesFixed As Integer = GridDataLineInset
		Dim FBorderStyle As Integer = FlexBorderStyleSunken
		Dim FAllowUserResizing As Integer = FlexAllowUserResizingNone
		Dim FAllowUserFreezing As Integer = FlexAllowUserFreezingNone
		Dim FSelectionMode As Integer = FlexSelectionModeFree
		Dim FFillStyle As Integer = FlexFillStyleSingle
		Dim FHighLight As Integer = FlexHighLightAlways
		Dim FFocusRect As Integer = FlexFocusRectLight
		Dim FMergeCells As Integer = FlexMergeCellsNever
		Dim FWordWrap As Boolean = False
		Dim FRedraw As Boolean = True
		Dim FDoubleBuffer As Boolean = True
		Dim FScrollBars As Integer = 3               'vbBoth
		Dim FEnabled_ As Boolean = True
		Dim FExtendLastCol As Boolean = False
		Dim FSheetBorder As Boolean = True
		Dim FAllowBigSelection As Boolean = True
		Dim FAllowSelection As Boolean = True
		Dim FAllowMultiSelection As Boolean = False
		Dim FRowSizingMode As Integer = FlexRowSizingModeIndividual
		Dim FRowHeightMin As Long = 0
		Dim FRowHeightMax As Long = 0
		Dim FColWidthMin As Long = 0
		Dim FColWidthMax As Long = 0

		'=== Extended appearance ===
		Dim FBackColorAlt As Long = -1        'alternating row background, -1 = disabled
		Dim FGridColorFrozen As Long = -1     '-1 = use FGridColor
		Dim FSortArrowColor As Long = -1
		Dim FFloodColor As Long = -1
		Dim FInsertMarkColor As Long = -1
		Dim FGridLinesFrozen As Integer = -1  '-1 = use FGridLinesFixed
		Dim FTextStyle As Integer = FlexTextStyleFlat
		Dim FTextStyleFixed As Integer = FlexTextStyleFlat
		Dim FSingleLine As Boolean = False
		Dim FEllipsisFormat As Integer = FlexEllipsisFormatNone
		Dim FEllipsisFormatFixed As Integer = FlexEllipsisFormatNone
		Dim FVisualStyles As Boolean = True
		Dim FFontQuality As Integer = FlexFontQualityDefault
		Dim FUseForeColorSel As Boolean = True

		'=== Extended behavior ===
		Dim FAllowUserEditing As Boolean = True
		Dim FScrollTrack As Boolean = True
		Dim FScrollTipFollowThumb As Boolean = False
		Dim FDisableNoScroll As Boolean = False
		Dim FTabBehavior As Integer = FlexTabControls
		Dim FDirectionAfterReturn As Integer = FlexDirectionAfterReturnDown
		Dim FWrapCellBehavior As Integer = FlexWrapNone
		Dim FWantReturn As Boolean = False
		Dim FShowInfoTips As Boolean = True
		Dim FShowLabelTips As Boolean = True
		Dim FShowScrollTips As Boolean = True
		Dim FAllowScrollLock As Boolean = True
		Dim FAutoClipboard As Boolean = False
		Dim FBestFitMode As Integer = FlexBestFitModeTextOnly
		Dim FMultiSelChangeTime As Long = 250
		Dim FWheelScrollLines As Long = 3
		Dim FAllowIncrementalSearch As Boolean = False
		Dim FClipSeparatorsCol As WString Ptr = 0   'ClipSeparatorCol, default tab
		Dim FClipSeparatorsRow As WString Ptr = 0   'ClipSeparatorRow, default CR
		Dim FClipMode As Integer = FlexClipModeNormal
		Dim FClipCopyMode As Integer = FlexClipCopyModeNormal
		Dim FClipPasteMode As Integer = FlexClipPasteModeNormal

		'=== Frozen dividers drag state ===
		Dim FHotDivider As Integer = 0          'hover feedback: same codes as FDragMode
		Dim FHotDividerIndex As Long = -1
		Dim FResizeRowAll As Boolean = False    'row sizing applied to all scrollable rows
		Dim FDividerDblClickPending As Boolean = False

		'=== Hit test cache (VB6 THITTESTINFO equivalent) ===
		Dim FHitRow As Long = 0
		Dim FHitCol As Long = 0
		Dim FHitRowDivider As Long = -1
		Dim FHitColDivider As Long = -1
		Dim FHitResult As Integer = FlexHitResultNoWhere
		Dim FMouseRow As Long = 0
		Dim FMouseCol As Long = 0

		'=== Multi-selection (non-contiguous rows via RWIS_SELECTED) ===
		Dim FMultiSelDirty As Boolean = False

		'=== Undo/Redo queue entries live outside GridDataEx (no nested types). ===
		Dim UndoQueue(Any) As FlexUndoEntry Ptr
		Dim FUndoPos As Long = -1               'index of last applied entry
		Dim FUndoLimit As Long = 200
		Dim FTextTmp As WString Ptr = 0
		'=== Incremental search state ===
		Dim FIncrSearchString As WString Ptr = 0
		Dim FIncrSearchRow As Long = 0
		Dim FIncrSearchCol As Long = 0
		Dim FIncrSearchTime As Long = 1000
		Dim FIncrSearchActive As Boolean = False

		'=== Drop-down editors (combo list, calendar, calculator) ===
		Dim ComboEdit_ As ComboBoxEdit Ptr = 0
		Dim FComboEditStyle As Integer = -1
		Dim ComboCalendar_ As MonthCalendar Ptr = 0
		Dim CalcPanel_ As Panel Ptr = 0
		Dim CalcDisplay_ As Label Ptr = 0
		Dim CalcBtn_(0 To 19) As CommandButton Ptr
		Dim FComboDropped As Boolean = False
		Dim FCalcEntry As WString Ptr = 0      'calculator display text
		Dim FCalcAccum As Double = 0
		Dim FCalcOp As Long = 0                '0 = none, else the operator char code
		Dim FCalcFresh As Boolean = True

		'=== Edit state ===
		Dim EditText_ As FlexEditTextBox Ptr = 0
		Dim FEditRow As Long = -1
		Dim FEditCol As Long = -1
		Dim FInEdit As Boolean = False
		Dim FEditReason As Integer = FlexEditReasonCode
		Dim FEditCloseMode As Integer = FlexEditCloseModeCode
		Dim FEditLocked As Boolean = False
		Dim FEditMaxLength As Long = 0          '0 = unlimited
		Dim FEditChanged As Boolean = False
		Dim FEditRowSel As Long = -1
		Dim FEditColSel As Long = -1
		Dim FComboList As WString Ptr = 0       'ComboItems of current cell column
		Dim FComboModeCell As Integer = FlexComboModeNone

		'=== Internal helpers ===
		Declare Function CellAt(ByVal Row As Long, ByVal Col As Long) As FlexCell Ptr
		Declare Function CellHasFormat(ByVal Row As Long, ByVal Col As Long) As Boolean
		Declare Function EnsureFmtg(ByVal Row As Long, ByVal Col As Long) As FlexCellFormat Ptr
		Declare Function GetRowHeightPx(ByVal Index As Long) As Long
		Declare Function GetColWidthPx(ByVal Index As Long) As Long
		Declare Function GetDefaultRowHeightPx() As Long
		Declare Function TwipsPerPixelX() As Single
		Declare Function TwipsPerPixelY() As Single
		Declare Function ClientWidthPx() As Long
		Declare Function ClientHeightPx() As Long
		Declare Function LogicalToPxX(ByVal Value As Long) As Long
		Declare Function LogicalToPxY(ByVal Value As Long) As Long
		Declare Sub UsePhysicalCanvas()
		Declare Function GetDefaultColWidthPx() As Long
		Declare Sub SetScrollBarsInternal()
		Declare Sub DrawGridArea(ByRef Cv As My.Sys.Drawing.Canvas, ByVal DrawLeft As Long, ByVal DrawTop As Long, ByVal DrawRight As Long, ByVal DrawBottom As Long)
		'Visible-range drawing helpers (only rows/cols on screen are visited).
		'Each pass draws the inclusive [Start..End] index range; the fixed
		'region and the scrolled region are painted as separate passes.
		Declare Sub DrawGridRowCells(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aRow As Long, ByVal YCur As Long, ByVal XCurStart As Long, ByVal aColStart As Long, ByVal aColEnd As Long, ByVal AreaRight As Long)
		Declare Sub DrawGridLinesRow(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aRow As Long, ByVal YCur As Long, ByVal XCurStart As Long, ByVal aColStart As Long, ByVal aColEnd As Long, ByVal AreaRight As Long)
		Declare Sub DrawGridLinesCol(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aCol As Long, ByVal XCur As Long, ByVal YCurStart As Long, ByVal aRowStart As Long, ByVal aRowEnd As Long, ByVal AreaBottom As Long)
		Declare Function RowAtY(ByVal Y As Long) As Long
		Declare Function ColAtX(ByVal X As Long) As Long
		Declare Function RowTopY(ByVal aRow As Long) As Long
		Declare Function ColLeftX(ByVal aCol As Long) As Long
		Declare Sub DrawCellContent(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean)
		Declare Sub DrawSortArrow(ByRef Cv As My.Sys.Drawing.Canvas, ByVal XCenter As Long, ByVal YCenter As Long, ByVal Direction As Integer, ByVal Clr As Long)
		Declare Sub DrawCheckBoxGlyph(ByRef Cv As My.Sys.Drawing.Canvas, ByVal XLeft As Long, ByVal YTop As Long, ByVal Size As Long, ByVal CheckedState As Integer, ByVal bDisabled As Boolean)
		Declare Sub DrawFloodFill(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal Percent As Integer, ByVal Clr As Long)
		Declare Sub ApplyTextStyleFrame(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal Style As Integer, ByVal bLight As Boolean)
		Declare Function GetCellAlign(ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean) As Integer
		Declare Function GetGridLineColor(ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean) As Long
		Declare Function EffectiveChecked(ByVal aRow As Long, ByVal aCol As Long) As Integer
		Declare Function CheckBoxesActive(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Declare Sub EnsureVisibleCell(ByVal Row As Long, ByVal Col As Long)
		Declare Function GetGridLineOffsets_AreaTop() As Long
		'Client <-> grid coordinate conversion (scroll-aware).
		Declare Function GridYFromClient(ByVal Y As Long) As Long
		Declare Function GridXFromClient(ByVal X As Long) As Long
		Declare Function IsRowVisible(ByVal aRow As Long) As Boolean
		Declare Function IsColVisible(ByVal aCol As Long) As Boolean
		Declare Sub UpdateHitTest(ByVal X As Long, ByVal Y As Long)
		Declare Sub InternalSetRowCol(ByVal NewRow As Long, ByVal NewCol As Long, ByVal NewRowSel As Long, ByVal NewColSel As Long, ByVal Flags As Long)
		Declare Sub PushUndo(ByVal aRow As Long, ByVal aCol As Long, ByRef OldText As WString, ByRef NewText As WString, ByVal SelRow As Long = -1, ByVal SelCol As Long = -1)
		Declare Sub ClearUndoQueue()
		Declare Function TextToCell(ByRef Value As WString, ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Declare Sub IncrementalSearchAdvance(ByVal CharCode As Long)
		Declare Function CommitEditInternal(ByVal CloseMode As Integer) As Boolean
		Declare Sub PositionEditBox()
		'Cell drop-down editors.
		Declare Function CellEditorRect(ByRef L As Long, ByRef T As Long, ByRef W As Long, ByRef H As Long) As Boolean
		Declare Sub EnsureComboEdit(ByVal AStyle As Integer)
		Declare Sub EnsureComboCalendar()
		Declare Sub EnsureCalcPanel()
		Declare Sub FillComboItems()
		Declare Function ComboItemValue(ByRef Item As WString) ByRef As WString
		Declare Sub CalcUpdateDisplay()
		Declare Sub CalcApplyKey(ByRef KeyCh As WString)
		Declare Function CalcApplyOp(ByVal A As Double, ByVal B As Double, ByVal Op As Long) As Double
		Declare Function CalcNumStr(ByVal R As Double) ByRef As WString
		Declare Sub ComboEdit_Selected(ByRef Sender As ComboBoxEdit, ByVal ItemIndex As Integer)
		Declare Sub ComboEdit_CloseUp(ByRef Sender As ComboBoxEdit)
		Declare Sub ComboEdit_KeyDown(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		Declare Sub ComboEdit_Changed(ByRef Sender As ComboBoxEdit)
		Declare Sub ComboCal_Select(ByRef Sender As MonthCalendar)
		Declare Sub CalcBtn_Click(ByRef Sender As Control)
		'Best-fit measurement.
		Declare Function ColWraps(ByVal aCol As Long, ByVal bFixed As Boolean) As Boolean
		Declare Sub MeasureCellText(ByVal aRow As Long, ByVal aCol As Long, ByRef W As Long, ByRef H As Long)
		'Drag-resize state (pixel coordinates in client space).
		Dim FDragMode As Integer = 0            '0 none, 1 col divider, 2 row divider
		Dim FDragIndex As Long = -1
		Dim FDragStartPos As Long = 0           'mouse pos at grab
		Dim FDragStartSize As Long = 0          'size at grab (twips)
		Declare Sub FillStyleRange(ByRef R1 As Long, ByRef C1 As Long, ByRef R2 As Long, ByRef C2 As Long)
		Declare Function CellFontStyleBit(ByVal BitFlag As Integer) As Boolean
		Declare Sub SetCellFontStyleBit(ByVal BitFlag As Integer, ByVal Value As Boolean)
		Declare Function CvCheckBoxSize() As Long
		Declare Function GetComboCueWidth(ByVal aCol As Long) As Long
		Declare Sub GetGraphicSize(ByVal Handle As Any Ptr, ByVal IsIcon As Boolean, ByRef W As Long, ByRef H As Long)
		Declare Sub RenderGraphic(ByRef Cv As My.Sys.Drawing.Canvas, ByVal Handle As Any Ptr, ByVal IsIcon As Boolean, ByVal X As Long, ByVal Y As Long, ByVal W As Long, ByVal H As Long)
		Declare Sub DrawCellPicture(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal aRow As Long, ByVal aCol As Long, ByRef IndentL As Long, ByRef IndentR As Long)
			'Merge cache: for each cell, the merged block bounds (inclusive).
		'A cell is unmerged when all four bounds equal -1.
		Dim MergeCache(Any) As Long      'flat: (Row*FCols+Col)*4 + {0=R1,1=C1,2=R2,3=C2}
		Dim FMergeDirty As Boolean = True

		'=== Geometry prefix caches: cumulative pixel offsets so row/column
		'geometry is O(1) and hit tests are O(log n) even with millions of rows.
		'Built lazily on first use after any mutation marks the cache dirty. ===
		Dim RowPrefix(Any) As Long       'RowPrefix(i) = top pixel Y of row i; RowPrefix(FRows) = total height
		Dim ColPrefix(Any) As Long       'ColPrefix(j) = left pixel X of column j; ColPrefix(FCols) = total width
		Dim FRowGeomDirty As Boolean = True
		Dim FColGeomDirty As Boolean = True
		Dim FRowUniformPx As Long = 0    '>0 = every row uses this pixel height (pure math fast path)
		Dim FColUniformPx As Long = 0
		'Deferred scroll bar update: bulk loads mark dirty instead of calling
		'SetScrollInfo per row; the state flushes before the next paint.
		Dim FScrollBarsDirty As Boolean = False
		'Physical row capacity of CellsArr/RowsArr/FMergeRows (amortized growth;
		'logical size is FRows). Cells are allocated lazily (0 = empty cell).
		Dim FCapRows As Long = 0
		#ifdef __USE_WINAPI__
			'Off-screen paint buffer for flicker-free WM_PAINT (double buffering).
			Dim FMemDc As Any Ptr = 0
			Dim FMemBmp As Any Ptr = 0
			Dim FMemOld As Any Ptr = 0
			Dim FMemW As Long = 0
			Dim FMemH As Long = 0
		#endif
		#ifndef __USE_WINAPI__
			'The own scroll bars (no scroll bars of a window): shown, the drag of a
			'thumb (1 - vertical, 2 - horizontal) from the point and the first row/column
			Dim FOwnVScroll As Boolean = False
			Dim FOwnHScroll As Boolean = False
			Dim FOwnScrollDrag As Integer = 0
			Dim FOwnScrollDragPos As Long = 0
			Dim FOwnScrollDragFirst As Long = 0
			'Android: a finger which moves after the press pans the grid
			Dim FTouchDown As Boolean = False
			Dim FTouchPanning As Boolean = False
			Dim FTouchX As Long = 0
			Dim FTouchY As Long = 0
			'The cursor shown and the one which the move asked for (SetGridCursor)
			Dim FLastCursor As Integer = 0
			Dim FPendingCursor As Integer = 0
			'GTK: the default row height followed the font (PaintOwn)
			Dim FDefaultRowFitted As Boolean = False
			'The double click of the Web and Android (two presses in a short time on one place)
			Dim FLastDownTime As Double = 0
			Dim FLastDownX As Long = -10000
			Dim FLastDownY As Long = -10000
		#endif
		Dim FMergeRows(Any) As Boolean   'per-row merge participation
		Dim FMergeCols(Any) As Boolean   'per-column merge participation
		'Header click sort state (SortOnClick): remembers the last sorted column
		'so the next header click toggles the direction.
		Dim FSortOnClick As Boolean = False
		Dim FSortClickCol As Long = -1
		Dim FSortClickDesc As Boolean = False
		'FindNext state: FindItem records its parameters here so FindNext can
		'continue the same search from the current cell.
		Dim FFindText As String = ""
		Dim FFindMatch As Integer = FlexFindMatchPartial
		Dim FFindCase As Boolean = False
		Dim FFindDir As Integer = FlexFindDirectionDown
		'=== Filter bar (batch 4): virtual row under the fixed rows showing the
		'per-column filter criteria; clicking a band cell edits the criteria
		'in place and ApplyFilters hides the non-matching rows. ===
		Dim FShowFilterBar As Boolean = False
		Dim FFilterEditActive As Boolean = False
		Dim FFilterEditCol As Long = -1
		'=== View zoom (batch 4): 0.25..4.0 scale applied to row/column
		'geometry and the control font; Ctrl+wheel changes it. ===
		Dim FZoom As Double = 1.0
		Dim FZoomBaseFont As Integer = 0
		'=== Multi-sort keys (batch 4): first added key = primary column. ===
		Dim FSortKeys(Any) As FlexSortKey
		'=== Batch 5 (VBFlexGrid 1.8 parity): wallpaper, insert mark / drop
		'highlight, drag row/col modal loop, scroll tips, file drop, reader
		'mode panning, lookup translation, format string and array interop. ===
		Dim FWallPaper As Any Ptr = 0          'HBITMAP, caller-owned
		Dim FWallPaperAlignment As Integer = FlexWallPaperAlignmentLeftTop
		Dim FInsertMark As Long = -1            '-1 = off
		Dim FInsertMarkAfter As Boolean = False
		Dim FInsertMarkMode As Integer = 0      'FlexDropTargetModeConstants
		Dim FDropHighlight As Long = -1          '-1 = off
		Dim FDropHighlightMode As Integer = 0    'FlexDropTargetModeConstants
		Dim FAllowDropFiles As Boolean = False
		Dim FAllowReaderMode As Boolean = False
		Dim FMouseTrack As Boolean = False
		Dim FAlwaysAllowComboCues As Boolean = False
		Dim FFormatString As WString Ptr = 0
		Dim FScrollTipText As WString Ptr = 0
		Dim FScrollTipHwnd As Any Ptr = 0       'tooltips_class32 tracking window
		Dim FScrollTipShown As Boolean = False
		Dim FGridLineWidth As Long = 1          '-1 = inherit GridLineWidthFixed
		Dim FGridLineWidthFixed As Long = 1
		Dim FGridLineWidthFrozen As Long = -1   '-1 = inherit Fixed
		Dim FFocusRectWidth As Long = 1         'FlexFocusRectFlat only
		Dim FDragRowColActive As Boolean = False 'modal DragRow/DragCol guard
		Dim FReaderPanning As Boolean = False   'middle-button pan state
		Dim FReaderLastX As Long = 0
		Dim FReaderLastY As Long = 0
		'True once any color property was assigned by code: the automatic
		'(theme-following) default colors will not overwrite customized ones.
		Dim FColorsCustomized As Boolean = False
	'Scrollbar theme: -1 not applied yet, 0 light, 1 dark (DarkMode_Explorer).
	Dim FScrollBarThemeDark As Integer = -1
	'Print preview window state.
	Dim FPrevForm As Form Ptr = 0
	Dim FPrevHost As Panel Ptr = 0
	Dim FPrevLbl As Label Ptr = 0
	Dim FPrevPage As Long = 1
	Dim FPrevPages As Long = 1
	Dim FPrevLandscape As Boolean = False
	Dim FPrevTitle As WString Ptr = 0
	Dim FPrevZoom As Double = 0          '0 = fit window; else display scale
	Dim FPrevOffX As Long = 0             'pan offset (page pixels)
	Dim FPrevOffY As Long = 0
	Dim FPrevDragX As Long = 0            'drag-pan state
	Dim FPrevDragY As Long = 0
	Dim FPrevDragging As Boolean = False
	Dim FPrevRulerH As Ruler Ptr = 0      'preview scales (Report.Bas style)
	Dim FPrevRulerV As Ruler Ptr = 0
	'The printing (PrintOut): the title, the orientation and the next page; GTK, the Web
	'and Android record the pages in a PrintDocument
	Dim FPrintTitle As WString Ptr = 0
	Dim FPrintLandscape As Boolean = False
	Dim FPrintPageNo As Long = 0
	#ifndef __USE_WINAPI__
		Dim FPrintDoc As PrintDocument Ptr = 0
	#endif
	Dim FReportFitWidth As Boolean = True 'shrink all columns onto one page width
	Dim FRptBuf As WString Ptr = 0         'module callback return buffer
		Declare Sub InvalidateMergeCache
		Declare Sub BuildMergeCache
		Declare Function IsMergeMaster(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Declare Function IsMergeSlave(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Declare Function CellTextRaw(ByVal aRow As Long, ByVal aCol As Long) ByRef As WString
		Declare Function CellsEqual(ByVal r1 As Long, ByVal c1 As Long, ByVal r2 As Long, ByVal c2 As Long) As Boolean
		'Color scheme helpers.
		Declare Sub SetDefaultColors(ByVal Dark As Boolean)
		Declare Sub ApplyScrollBarTheme(ByVal Dark As Boolean)
		'Report engine.
		Declare Function CollectVisRows(RowList() As Long) As Long
		Declare Function CollectVisCols(ColList() As Long) As Long
		Declare Sub BuildReportLayout(ByRef Lay As FlexReportLayout, ByVal Landscape As Boolean, ByVal XDpi As Double, ByVal YDpi As Double)
		Declare Sub RenderReportPage(ByRef Cv As My.Sys.Drawing.Canvas, ByVal PageNo As Long, ByRef Lay As FlexReportLayout, ByRef Title As WString, ByVal OffX As Double, ByVal OffY As Double, ByVal Dpi As Double)
		Declare Sub ReportText(ByRef Cv As My.Sys.Drawing.Canvas, ByRef Value As WString, ByVal BoxLeft As Double, ByVal BoxTop As Double, ByVal BoxRight As Double, ByVal BoxBottom As Double, ByVal Align As Integer, ByVal TextColor As Long)
		#ifndef __USE_WINAPI__
			Declare Static Sub PrintDoc_PrintPage(ByRef Designer As My.Sys.Object, ByRef Sender As PrintDocument, ByRef Cv As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		#endif
		Declare Sub PreviewShowPage(ByVal Delta As Long, ByVal Absolute As Long)
		Declare Sub PreviewDoPrint()
		Declare Static Sub PreviewBtn_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		Declare Static Sub PreviewHost_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas)
		Declare Static Sub PreviewHost_Wheel(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Direction As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Declare Static Sub PreviewHost_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Declare Static Sub PreviewHost_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Declare Static Sub PreviewHost_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Declare Sub PreviewSetZoom(ByVal NewZoom As Double)
		Declare Sub PreviewUpdateRulers(ByVal PageX As Long, ByVal PageY As Long, ByVal Z As Double)
		Declare Function BuildReportObject(ByRef Title As WString, ByVal GroupCol As Long) As Report Ptr
		Declare Static Sub PreviewForm_Resize(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		'Layout/persistence helpers.
		Declare Function IsNumericText(ByRef S As WString) As Boolean
		Declare Function EscapeLayoutText(ByRef S As WString) As String
		Declare Sub UnescapeLayoutText(ByRef S As WString)
		'Filter bar helpers (batch 4).
		Declare Function FilterBarHeightPx() As Long
		Declare Sub DrawFilterBar(ByRef Cv As My.Sys.Drawing.Canvas, ByVal YTop As Long, ByVal XFixed As Long, ByVal XScroll As Long, ByVal FixedColCount As Long, ByVal LeftColDraw As Long, ByVal AreaRight As Long)
		Declare Function FilterMatchText(ByRef Value As WString, ByRef Crit As WString) As Boolean
		Declare Function StartFilterEdit(ByVal aCol As Long) As Boolean
		Declare Sub ApplyFilterEdit()
		Declare Sub CancelFilterEdit()
		'Bookmark / export helpers (batch 4).
		Declare Sub DrawBookmarkMark(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X As Long, ByVal Y As Long, ByVal W As Long, ByVal H As Long, ByVal Clr As Long)
		Declare Sub DrawCellButtonGlyph(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByRef Caption As WString, ByVal Selected As Boolean, ByVal Disabled As Boolean)
		Declare Function EscapeHTMLText(ByRef S As WString) As String
		Declare Function EscapeJSONText(ByRef S As WString) As String
		'Batch 5 helpers.
		Declare Sub DrawInsertMark(ByRef Cv As My.Sys.Drawing.Canvas)
		Declare Sub DrawDropHighlight(ByRef Cv As My.Sys.Drawing.Canvas)
		Declare Sub DrawWallPaperArea(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long)
		Declare Function GetAreaLineWidth(ByVal bFixedArea As Boolean, ByVal bFrozenArea As Boolean) As Long
		Declare Function DoDragRowCol(ByVal RowIdx As Long, ByVal ColIdx As Long) As Long
		Declare Sub EnsureScrollTip()
		Declare Sub UpdateScrollTip(ByVal wBar As Long, ByVal TrackPos As Long)
		Declare Sub CancelScrollTip()
		Declare Function ParseDateText(ByRef S As WString) As Double
		Declare Function LookupTranslate(ByRef Txt As WString, ByVal Conversion As Integer, ByVal aCol As Long) ByRef As WString
		Declare Function HasLookup(ByVal aCol As Long) As Boolean
		Declare Function DrawThickHLine(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X1 As Long, ByVal X2 As Long, ByVal Y As Long, ByVal W As Long, ByVal Clr As Long) As Long
		Declare Function DrawThickVLine(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X As Long, ByVal Y1 As Long, ByVal Y2 As Long, ByVal W As Long, ByVal Clr As Long) As Long
		#ifdef __USE_GTK__
			'GTK paints the grid through OnPaint (the cairo context of the draw signal)
			Declare Static Sub GTK_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas)
		#endif
		'The input of every platform (WM_* of Windows, GdkEvent of GTK, CM_* of the Web
		'and Android): the points are physical pixels of the client area, the key codes
		'are the ones of Windows (VK_*), ShiftState has the FLEX_*_MASK bits
		Declare Sub GridMouseDown(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long, ByVal ShiftState As Integer)
		Declare Function GridMouseMove(ByVal X As Long, ByVal Y As Long) As Boolean
		Declare Function GridMouseUp(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long) As Boolean
		Declare Sub GridDblClick(ByVal X As Long, ByVal Y As Long)
		'Delta: > 0 up (vertical) or right (horizontal)
		Declare Sub GridWheel(ByVal Delta As Long, ByVal ShiftState As Integer, ByVal Horizontal As Boolean)
		'GridMouseMove, GridMouseUp, GridKeyDown: True when the grid handled the input
		Declare Function GridKeyDown(ByVal KeyCode As Integer, ByVal ShiftState As Integer) As Boolean
		Declare Sub GridKeyPress(ByVal KeyChar As Integer)
		Declare Sub GridKeyUp(ByVal KeyCode As Integer, ByVal ShiftState As Integer)
		'0 - the arrow, 1 - the column divider, 2 - the row divider, 3 - the hand
		Declare Sub SetGridCursor(ByVal Kind As Integer)
		Declare Sub GridCapture(ByVal Value As Boolean)
		#ifndef __USE_WINAPI__
			'The own scroll bars and the input of GTK, the Web and Android
			Declare Function OwnScrollBarSize() As Long
			Declare Function OwnFullWidth() As Long
			Declare Function OwnFullHeight() As Long
			Declare Function OwnScrollBarRects(ByVal Vertical As Boolean, ByRef TrackLen As Long, ByRef ThumbStart As Long, ByRef ThumbLen As Long) As Boolean
			Declare Sub DrawOwnScrollBars(ByRef Cv As My.Sys.Drawing.Canvas)
			Declare Function OwnScrollBarDown(ByVal X As Long, ByVal Y As Long) As Boolean
			Declare Function OwnScrollBarMove(ByVal X As Long, ByVal Y As Long) As Boolean
			Declare Function OwnScrollBarUp() As Boolean
			Declare Sub PaintOwn(ByRef Cv As My.Sys.Drawing.Canvas)
			Declare Sub ApplyOwnCursor(ByVal Kind As Integer)
			Declare Sub InputMouseDown(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long, ByVal ShiftState As Integer)
			Declare Sub InputMouseMove(ByVal X As Long, ByVal Y As Long)
			Declare Sub InputMouseUp(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long)
			#ifdef __USE_GTK__
				Declare Function InputKeyDown(ByVal KeyVal As Long, ByVal ShiftState As Integer) As Boolean
			#endif
		#endif
		Declare Function HitColDividerPx(ByVal X As Long, ByVal Y As Long) As Long
		Declare Function HitRowDividerPx(ByVal X As Long, ByVal Y As Long) As Long
		'Geometry prefix caches and fast cell access.
		Declare Sub BuildRowGeometry()
		Declare Sub BuildColGeometry()
		Declare Function CellCreate(ByVal aRow As Long, ByVal aCol As Long) As FlexCell Ptr
		Declare Sub EnsureRowCapacity(ByVal NeededRows As Long)
		Declare Sub InvalidateRowGeometry()
		Declare Sub InvalidateColGeometry()
		'Shifts already-drawn pixels by (dX, dY) when the content covers the
		'scroll area (ScrollWindowEx + ScrollDC on the buffer), else repaints.
		Declare Sub ScrollGridPixels(ByVal dX As Long, ByVal dY As Long)
		#ifdef __USE_WINAPI__
			Declare Sub EnsureMemSurface(ByVal Dc As HDC, ByVal W As Long, ByVal H As Long)
			Declare Sub DestroyMemSurface()
		#endif
	Public:
		Declare Function EditBoxKeyDown(ByVal KeyCode As Long, ByVal Shift As Integer) As Boolean
		Declare Sub EditBoxChanged()
		Declare Sub EditBoxLostFocus()
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub RepaintGrid()
		Declare Sub SetCell(ByVal Row As Long, ByVal Col As Long, ByRef Value As WString)
		Declare Function TextMatrix(ByVal Row As Long, ByVal Col As Long) ByRef As WString
		Declare Sub TextMatrix(ByVal Row As Long, ByVal Col As Long, ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Rows As Long
		Declare Property Rows(ByVal Value As Long)
		Declare Property Cols As Long
		Declare Property Cols(ByVal Value As Long)
		Declare Property Row As Long
		Declare Property Row(ByVal Value As Long)
		Declare Property Col As Long
		Declare Property Col(ByVal Value As Long)
		Declare Property RowSel As Long
		Declare Property RowSel(ByVal Value As Long)
		Declare Property ColSel As Long
		Declare Property ColSel(ByVal Value As Long)
		Declare Property TopRow As Long
		Declare Property TopRow(ByVal Value As Long)
		Declare Property LeftCol As Long
		Declare Property LeftCol(ByVal Value As Long)
		Declare Property FixedRows As Long
		Declare Property FixedRows(ByVal Value As Long)
		Declare Property FixedCols As Long
		Declare Property FixedCols(ByVal Value As Long)
		Declare Property FrozenRows As Long
		Declare Property FrozenRows(ByVal Value As Long)
		Declare Property FrozenCols As Long
		Declare Property FrozenCols(ByVal Value As Long)
		Declare Property BorderStyle As Integer
		Declare Property BorderStyle(ByVal Value As Integer)
		Declare Property GridLines As Integer
		Declare Property GridLines(ByVal Value As Integer)
		Declare Property GridLinesFixed As Integer
		Declare Property GridLinesFixed(ByVal Value As Integer)
		Declare Property GridLinesFrozen As Integer
		Declare Property GridLinesFrozen(ByVal Value As Integer)
		Declare Property GridColor As Long
		Declare Property GridColor(ByVal Value As Long)
		Declare Property GridColorFixed As Long
		Declare Property GridColorFixed(ByVal Value As Long)
		Declare Property GridColorFrozen As Long
		Declare Property GridColorFrozen(ByVal Value As Long)
		Declare Property BackColorBkg As Long
		Declare Property BackColorBkg(ByVal Value As Long)
		Declare Property BackColorAlt As Long
		Declare Property BackColorAlt(ByVal Value As Long)
		Declare Property BackColorFixed As Long
		Declare Property BackColorFixed(ByVal Value As Long)
		Declare Property BackColorSel As Long
		Declare Property BackColorSel(ByVal Value As Long)
		Declare Property ForeColorFixed As Long
		Declare Property ForeColorFixed(ByVal Value As Long)
		Declare Property ForeColorSel As Long
		Declare Property ForeColorSel(ByVal Value As Long)
		Declare Property SortArrowColor As Long
		Declare Property SortArrowColor(ByVal Value As Long)
		Declare Property FloodColor As Long
		Declare Property FloodColor(ByVal Value As Long)
		Declare Property InsertMarkColor As Long
		Declare Property InsertMarkColor(ByVal Value As Long)
		Declare Property TextStyle As Integer
		Declare Property TextStyle(ByVal Value As Integer)
		Declare Property TextStyleFixed As Integer
		Declare Property TextStyleFixed(ByVal Value As Integer)
		Declare Property HighLight As Integer
		Declare Property HighLight(ByVal Value As Integer)
		Declare Property FocusRect As Integer
		Declare Property FocusRect(ByVal Value As Integer)
		Declare Property WordWrap As Boolean
		Declare Property WordWrap(ByVal Value As Boolean)
		Declare Property SingleLine As Boolean
		Declare Property SingleLine(ByVal Value As Boolean)
		Declare Property EllipsisFormat As Integer
		Declare Property EllipsisFormat(ByVal Value As Integer)
		Declare Property EllipsisFormatFixed As Integer
		Declare Property EllipsisFormatFixed(ByVal Value As Integer)
		Declare Property Redraw As Boolean
		Declare Property Redraw(ByVal Value As Boolean)
		Declare Property DoubleBuffer As Boolean
		Declare Property DoubleBuffer(ByVal Value As Boolean)
		Declare Property VisualStyles As Boolean
		Declare Property VisualStyles(ByVal Value As Boolean)
		Declare Property FontQuality As Integer
		Declare Property FontQuality(ByVal Value As Integer)
		Declare Property AllowBigSelection As Boolean
		Declare Property AllowBigSelection(ByVal Value As Boolean)
		Declare Property AllowSelection As Boolean
		Declare Property AllowSelection(ByVal Value As Boolean)
		Declare Property AllowMultiSelection As Boolean
		Declare Property AllowMultiSelection(ByVal Value As Boolean)
		Declare Property AllowUserEditing As Boolean
		Declare Property AllowUserEditing(ByVal Value As Boolean)
		Declare Property AllowUserFreezing As Integer
		Declare Property AllowUserFreezing(ByVal Value As Integer)
		Declare Property AllowUserResizing As Integer
		Declare Property AllowUserResizing(ByVal Value As Integer)
		Declare Property AllowIncrementalSearch As Boolean
		Declare Property AllowIncrementalSearch(ByVal Value As Boolean)
		Declare Property SelectionMode As Integer
		Declare Property SelectionMode(ByVal Value As Integer)
		Declare Property FillStyle As Integer
		Declare Property FillStyle(ByVal Value As Integer)
		Declare Property ScrollBars As Integer
		Declare Property ScrollBars(ByVal Value As Integer)
		Declare Property ScrollTrack As Boolean
		Declare Property ScrollTrack(ByVal Value As Boolean)
		Declare Property ScrollTipFollowThumb As Boolean
		Declare Property ScrollTipFollowThumb(ByVal Value As Boolean)
		Declare Property DisableNoScroll As Boolean
		Declare Property DisableNoScroll(ByVal Value As Boolean)
		Declare Property RowSizingMode As Integer
		Declare Property RowSizingMode(ByVal Value As Integer)
		Declare Property TabBehavior As Integer
		Declare Property TabBehavior(ByVal Value As Integer)
		Declare Property DirectionAfterReturn As Integer
		Declare Property DirectionAfterReturn(ByVal Value As Integer)
		Declare Property WrapCellBehavior As Integer
		Declare Property WrapCellBehavior(ByVal Value As Integer)
		Declare Property WantReturn As Boolean
		Declare Property WantReturn(ByVal Value As Boolean)
		Declare Property ExtendLastCol As Boolean
		Declare Property ExtendLastCol(ByVal Value As Boolean)
		Declare Property SheetBorder As Boolean
		Declare Property SheetBorder(ByVal Value As Boolean)
		Declare Property BestFitMode As Integer
		Declare Property BestFitMode(ByVal Value As Integer)
		Declare Property MultiSelChangeTime As Long
		Declare Property MultiSelChangeTime(ByVal Value As Long)
		Declare Property WheelScrollLines As Long
		Declare Property WheelScrollLines(ByVal Value As Long)
		Declare Property RowHeightMin As Long
		Declare Property RowHeightMin(ByVal Value As Long)
		Declare Property RowHeightMax As Long
		Declare Property RowHeightMax(ByVal Value As Long)
		Declare Property ColWidthMin As Long
		Declare Property ColWidthMin(ByVal Value As Long)
		Declare Property ColWidthMax As Long
		Declare Property ColWidthMax(ByVal Value As Long)
		Declare Property RowHeight(ByVal Index As Long) As Long
		Declare Property RowHeight(ByVal Index As Long, ByVal Value As Long)
		Declare Property ColWidth(ByVal Index As Long) As Long
		Declare Property ColWidth(ByVal Index As Long, ByVal Value As Long)
		Declare Property RowHeightUniform As Long
		Declare Property RowHeightUniform(ByVal Value As Long)
		Declare Property RowPos(ByVal Index As Long) As Long
		Declare Property RowPosition(ByVal Index As Long) As Long
		Declare Property RowPosition(ByVal Index As Long, ByVal Value As Long)
		Declare Property ColPos(ByVal Index As Long) As Long
		Declare Property ColPosition(ByVal Index As Long) As Long
		Declare Property ColPosition(ByVal Index As Long, ByVal Value As Long)
		Declare Property RowHidden(ByVal Index As Long) As Boolean
		Declare Property RowHidden(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property RowSelected(ByVal Index As Long) As Boolean
		Declare Property RowSelected(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property SelectedRow(ByVal Index As Long) As Long
		Declare Property SelectedRows As Long
		Declare Property RowData(ByVal Index As Long) As Any Ptr
		Declare Property RowData(ByVal Index As Long, ByVal Value As Any Ptr)
		Declare Property RowID(ByVal Index As Long) As Long
		Declare Property RowID(ByVal Index As Long, ByVal Value As Long)
		Declare Property RowIndex(ByVal ID As Long) As Long
		Declare Property RowResizable(ByVal Index As Long) As Boolean
		Declare Property RowResizable(ByVal Index As Long, ByVal Value As Boolean)
		Declare Function RowIsVisible(ByVal Index As Long, ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Boolean
		Declare Function RowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Function FixedRowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Function FrozenRowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Property RowsPerPage As Long
		Declare Property ColHidden(ByVal Index As Long) As Boolean
		Declare Property ColHidden(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColKey(ByVal Index As Long) ByRef As WString
		Declare Property ColKey(ByVal Index As Long, ByRef Value As WString)
		Declare Property ColIndex(ByRef Key As WString) As Long
		Declare Function ColIsVisible(ByVal Index As Long, ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Boolean
		Declare Function ColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Function FixedColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Function FrozenColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Property ColsPerPage As Long
		Declare Property ColData(ByVal Index As Long) As Any Ptr
		Declare Property ColData(ByVal Index As Long, ByVal Value As Any Ptr)
		Declare Property ColAlignment(ByVal Index As Long) As Integer
		Declare Property ColAlignment(ByVal Index As Long, ByVal Value As Integer)
		Declare Property FixedAlignment(ByVal Index As Long) As Integer
		Declare Property FixedAlignment(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColWordWrapOption(ByVal Index As Long) As Integer
		Declare Property ColWordWrapOption(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColWordWrapOptionFixed(ByVal Index As Long) As Integer
		Declare Property ColWordWrapOptionFixed(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColSort(ByVal Index As Long) As Integer
		Declare Property ColSort(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColSortMode(ByVal Index As Long) As Integer
		Declare Property ColSortMode(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColSortArrow(ByVal Index As Long) As Integer
		Declare Property ColSortArrow(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColSortArrowAlignment(ByVal Index As Long) As Integer
		Declare Property ColSortArrowAlignment(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColSortArrowColor(ByVal Index As Long) As Long
		Declare Property ColSortArrowColor(ByVal Index As Long, ByVal Value As Long)
		Declare Property ColComboCue(ByVal Index As Long) As Integer
		Declare Property ColComboCue(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColComboMode(ByVal Index As Long) As Integer
		Declare Property ColComboMode(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColCheckBoxes(ByVal Index As Long) As Boolean
		Declare Property ColCheckBoxes(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColResizable(ByVal Index As Long) As Boolean
		Declare Property ColResizable(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColNullable(ByVal Index As Long) As Boolean
		Declare Property ColNullable(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColDataType(ByVal Index As Long) As Integer
		Declare Property ColDataType(ByVal Index As Long, ByVal Value As Integer)
		Declare Property ColNumericPrecision(ByVal Index As Long) As UByte
		Declare Property ColNumericPrecision(ByVal Index As Long, ByVal Value As UByte)
		Declare Property ColNumericScale(ByVal Index As Long) As UByte
		Declare Property ColNumericScale(ByVal Index As Long, ByVal Value As UByte)
		Declare Property ColDataCapacity(ByVal Index As Long) As Long
		Declare Property ColDataCapacity(ByVal Index As Long, ByVal Value As Long)
		Declare Property MergeCells As Integer
		Declare Property MergeCells(ByVal Value As Integer)
		Declare Property MergeRow(ByVal Index As Long) As Boolean
		Declare Property MergeRow(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property MergeCol(ByVal Index As Long) As Boolean
		Declare Property MergeCol(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property DefaultRowHeight As Long
		Declare Property DefaultRowHeight(ByVal Value As Long)
		Declare Property DefaultColWidth As Long
		Declare Property DefaultColWidth(ByVal Value As Long)
		Declare Function BottomRow(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Function RightCol(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Declare Property MouseRow As Long
		Declare Property MouseCol As Long
		Declare Property HitRow As Long
		Declare Property HitCol As Long
		Declare Property HitRowDivider As Long
		Declare Property HitColDivider As Long
		Declare Property HitResult As Integer
		'Indexed per-cell formatting (extension helpers kept from the first port stage).
		Declare Function CellBackColorAt(ByVal Row As Long, ByVal Col As Long) As Long
		Declare Sub CellBackColorAt(ByVal Row As Long, ByVal Col As Long, ByVal Value As Long)
		Declare Function CellForeColorAt(ByVal Row As Long, ByVal Col As Long) As Long
		Declare Sub CellForeColorAt(ByVal Row As Long, ByVal Col As Long, ByVal Value As Long)
		'VB6-style current-cell / selection-range cell formatting properties.
		Declare Property CellBackColor As Long
		Declare Property CellBackColor(ByVal Value As Long)
		Declare Property CellForeColor As Long
		Declare Property CellForeColor(ByVal Value As Long)
		Declare Property CellTextStyle As Integer
		Declare Property CellTextStyle(ByVal Value As Integer)
		Declare Property CellAlignment As Integer
		Declare Property CellAlignment(ByVal Value As Integer)
		Declare Property CellPictureAlignment As Integer
		Declare Property CellPictureAlignment(ByVal Value As Integer)
		Declare Property CellToolTipText ByRef As WString
		Declare Property CellToolTipText(ByRef Value As WString)
		Declare Property CellComboCue As Integer
		Declare Property CellComboCue(ByVal Value As Integer)
		Declare Property CellChecked As Integer
		Declare Property CellChecked(ByVal Value As Integer)
		Declare Property CellFloodPercent As Integer
		Declare Property CellFloodPercent(ByVal Value As Integer)
		Declare Property CellFloodColor As Long
		Declare Property CellFloodColor(ByVal Value As Long)
		'Per-cell picture / icon with individual size and alignment direction
		'(FlexPictureAlignmentConstants: 9-grid, Stretch, Tile, NoOverlap).
		Declare Property CellPicture As Any Ptr
		Declare Property CellPicture(ByVal Value As Any Ptr)
		Declare Property CellPictureIsIcon As Boolean
		Declare Property CellPictureIsIcon(ByVal Value As Boolean)
		Declare Property CellPictureWidth As Long
		Declare Property CellPictureWidth(ByVal Value As Long)
		Declare Property CellPictureHeight As Long
		Declare Property CellPictureHeight(ByVal Value As Long)
		Declare Sub SetCellPicture(ByVal Row As Long, ByVal Col As Long, ByVal Handle As Any Ptr, ByVal IsIcon As Boolean = True, ByVal WidthPx As Long = 0, ByVal HeightPx As Long = 0, ByVal Alignment As Integer = -1)
		'Per-column combo definitions (drop-down list, calendar or calculator).
		Declare Property ColComboItems(ByVal Index As Long) ByRef As WString
		Declare Property ColComboItems(ByVal Index As Long, ByRef Value As WString)
		Declare Property ColComboHeader(ByVal Index As Long) ByRef As WString
		Declare Property ColComboHeader(ByVal Index As Long, ByRef Value As WString)
		Declare Property ColComboBoundColumn(ByVal Index As Long) As Long
		Declare Property ColComboBoundColumn(ByVal Index As Long, ByVal Value As Long)
		'Current-cell combo access.
		Declare Property ComboMode As Integer
		Declare Property ComboMode(ByVal Value As Integer)
		Declare Property ComboCue As Integer
		Declare Property ComboCue(ByVal Value As Integer)
		Declare Property ComboItems ByRef As WString
		Declare Property ComboItems(ByRef Value As WString)
		Declare Property ComboListCount As Long
		Declare Property ComboListIndex As Long
		Declare Property ComboListIndex(ByVal Value As Long)
		'Drop-down popups (combo list / MonthCalendar / calculator panel).
		Declare Property ComboDropped As Boolean
		Declare Sub ShowDropDown()
		Declare Sub CloseDropDown(ByVal bCommit As Boolean = True)
		Declare Property CellFontName ByRef As WString
		Declare Property CellFontName(ByRef Value As WString)
		Declare Property CellFontSize As Integer
		Declare Property CellFontSize(ByVal Value As Integer)
		Declare Property CellFontBold As Boolean
		Declare Property CellFontBold(ByVal Value As Boolean)
		Declare Property CellFontItalic As Boolean
		Declare Property CellFontItalic(ByVal Value As Boolean)
		Declare Property CellFontUnderline As Boolean
		Declare Property CellFontUnderline(ByVal Value As Boolean)
		Declare Property CellFontStrikeThrough As Boolean
		Declare Property CellFontStrikeThrough(ByVal Value As Boolean)
		Declare Property CellFontCharset As Integer
		Declare Property CellFontCharset(ByVal Value As Integer)
		Declare Property CellHasCustomFormatting As Boolean
		Declare Property CellHasCustomFormatting(ByVal Value As Boolean)
		Declare Property CellHasTag As Boolean
		Declare Property CellHasTag(ByVal Value As Boolean)
		Declare Property CellTag As Any Ptr
		Declare Property CellTag(ByVal Value As Any Ptr)
		Declare Property CellLeft As Long
		Declare Property CellTop As Long
		Declare Property CellWidth As Long
		Declare Property CellHeight As Long
		Declare Property TextArray(ByVal Index As Long) ByRef As WString
		Declare Property TextArray(ByVal Index As Long, ByRef Value As WString)
		Declare Property Clip ByRef As WString
		Declare Property Clip(ByRef Value As WString)
		Declare Property ClipSeparatorCol ByRef As WString
		Declare Property ClipSeparatorCol(ByRef Value As WString)
		Declare Property ClipSeparatorRow ByRef As WString
		Declare Property ClipSeparatorRow(ByRef Value As WString)
		Declare Property ClipMode As Integer
		Declare Property ClipMode(ByVal Value As Integer)
		Declare Property ClipCopyMode As Integer
		Declare Property ClipCopyMode(ByVal Value As Integer)
		Declare Property ClipPasteMode As Integer
		Declare Property ClipPasteMode(ByVal Value As Integer)
		'Edit state properties.
		Declare Property EditRow As Long
		Declare Property EditCol As Long
		Declare Property EditReason As Integer
		Declare Property EditCloseMode As Integer
		Declare Property EditText ByRef As WString
		Declare Property EditText(ByRef Value As WString)
		Declare Property EditLocked As Boolean
		Declare Property EditLocked(ByVal Value As Boolean)
		Declare Property EditMaxLength As Long
		Declare Property EditMaxLength(ByVal Value As Long)
		Declare Property EditSelStart As Long
		Declare Property EditSelStart(ByVal Value As Long)
		Declare Property EditSelLength As Long
		Declare Property EditSelLength(ByVal Value As Long)
		Declare Property EditSelText ByRef As WString
		Declare Property EditSelText(ByRef Value As WString)
		Declare Property IncrementalSearchString ByRef As WString
		Declare Property Version As Integer
		'Determines the merged block containing (aRow,aCol); outputs inclusive bounds.
		'They equal (aRow,aCol,aRow,aCol) when the cell is not merged.
		Declare Sub GetMergedRange(ByVal aRow As Long, ByVal aCol As Long, ByRef R1 As Long, ByRef C1 As Long, ByRef R2 As Long, ByRef C2 As Long)
		Declare Sub GetSelRange(ByRef Row1 As Long, ByRef Col1 As Long, ByRef Row2 As Long, ByRef Col2 As Long)
		Declare Sub SelectRange(ByVal Row As Long, ByVal Col As Long, ByVal RowSel As Long = -1, ByVal ColSel As Long = -1)
		Declare Sub SelectAll
		Declare Sub CellEnsureVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly, ByVal Row As Long = -1, ByVal Col As Long = -1)
		Declare Sub GetGridLineOffsets(ByRef LeftOff As Long, ByRef TopOff As Long, ByRef RightOff As Long, ByRef BottomOff As Long)
		Declare Sub GetMetrics(ByVal Metric As Integer, ByRef CX As Long, ByRef CY As Long)
		Declare Sub HitTest(ByVal X As Long, ByVal Y As Long)
		Declare Sub ClearRowInfo(ByVal Index As Long)
		Declare Sub ClearColInfo(ByVal Index As Long)
		Declare Function AddItem(ByRef Item As Const WString, ByVal Index As Long = -1) As Boolean
		Declare Sub RemoveItem(ByVal Index As Long)
		Declare Sub Clear(ByVal Where As Integer = FlexClearEverywhere, ByVal What As Integer = FlexClearEverything)
		Declare Function ClipGet() ByRef As WString
		Declare Sub ClipSet(ByRef Value As WString)
		Declare Sub Copy()
		Declare Sub Cut()
		Declare Sub Paste()
		Declare Function CanPaste() As Boolean
		Declare Sub DeleteSel()
		Declare Sub Undo()
		Declare Sub Redo()
		Declare Function CanUndo() As Boolean
		Declare Function CanRedo() As Boolean
		Declare Sub ResetUndoQueue()
		Declare Sub Sort(ByVal SortCol As Long = -1, ByVal SortType As Integer = FlexSortGenericAscending, ByVal NaturalSort As Boolean = False, ByVal MatchCase As Boolean = False)
		Declare Function FindItem(ByRef SearchText As WString, ByVal aRow As Long = -1, ByVal aCol As Long = -1, ByVal Match As Integer = FlexFindMatchPartial, ByVal CaseSensitive As Boolean = False, ByVal ExcludeHidden As Boolean = False, ByVal Wrap As Boolean = True, ByVal Direction As Integer = FlexFindDirectionDown) As Boolean
		'Continues the last FindItem search from the cell after (or before, when
		'searching upward) the current one, wrapping around the data area.
		Declare Function FindNext() As Boolean
		'Replaces every match of What by WithText; returns the number of replaced cells.
		Declare Function ReplaceAll(ByRef What As WString, ByRef WithText As WString, ByVal Match As Integer = FlexFindMatchPartial, ByVal CaseSensitive As Boolean = False) As Long
		'Layout persistence: the grid's properties, column/row geometry and (with
		'IncludeData) every cell's text and formatting, as an INI-style UTF-8 text
		'file that LoadLayout restores.
		Declare Function SaveLayout(ByRef FileName As WString, ByVal IncludeData As Boolean = False) As Boolean
		Declare Function LoadLayout(ByRef FileName As WString, ByVal IncludeData As Boolean = False) As Boolean
		'CSV interop: quoted fields, UTF-8. ExportCSV skips hidden rows/columns;
		'ImportCSV resizes the grid to the file content.
		Declare Function ExportCSV(ByRef FileName As WString, ByVal WithHeaders As Boolean = True) As Boolean
		Declare Function ImportCSV(ByRef FileName As WString, ByVal HasHeaders As Boolean = True) As Boolean
		'Numeric range statistics over the cell texts (GridAgg* functions).
		Declare Function Aggregate(ByVal Func As Integer, ByVal Row1 As Long, ByVal Col1 As Long, ByVal Row2 As Long, ByVal Col2 As Long) As Double
		Declare Function AggregateSelection(ByVal Func As Integer) As Double
		'Compare helper (ported from GridRows.CompareStrings): character-wise
		'compare with optional case folding, natural numeric run comparison
		'(sign/integer/fraction parsed as double) and a direction multiplier.
		Declare Function CompareStrings(ByRef s1 As WString, ByRef s2 As WString, ByVal MatchCase As Boolean = True, ByVal NaturalSort As Boolean = False, ByVal Direction As Long = 1) As Long
		'Hybrid quicksort (ported from GridRows.SortArray: explicit stack,
		'median pivot, 32-entry insertion finish) over the row range
		'[StartRow..EndRow] by the given column; Sort() calls it with the
		'whole data area.
		Declare Sub SortArray(ByVal StartRow As Long = -1, ByVal EndRow As Long = -1, ByVal SortCol As Long = -1, ByVal SortType As Integer = FlexSortGenericAscending, ByVal NaturalSort As Boolean = False, ByVal MatchCase As Boolean = False)
		'When True, clicking a fixed-row header cell sorts that column (numeric
		'when the values are numeric) and a repeated click toggles the direction.
		Declare Property SortOnClick As Boolean
		Declare Property SortOnClick(ByVal Value As Boolean)
		'Reapplies the built-in light or dark color scheme (chosen by the
	'current App.DarkMode state) to every grid color; the constructor calls
	'it once, call it again after toggling App.DarkMode. Assigning any color
	'property afterwards marks the colors as customized and this method
	'resets that marker.
		Declare Sub ApplyDefaultColors()
	'Renders the grid as a paginated report and shows a preview window with
	'page navigation, fit-to-window zoom, direct printing and page count.
	'Hidden rows/columns are skipped; the fixed rows repeat on every page as
	'the table header; the report always uses the light palette.
	Declare Sub PrintPreview(ByRef Title As WString = "", ByVal Landscape As Boolean = False)
	'Prints the same paginated report directly to the default printer
	'(orientation follows the printer's current default).
	Declare Sub PrintOut(ByRef Title As WString = "", ByVal Landscape As Boolean = False)
	'True (default): shrink all visible columns onto one page width instead
	'of splitting wide tables across column-group pages (Excel "fit all
	'columns on one page").
	Declare Property ReportFitWidth As Boolean
	Declare Property ReportFitWidth(ByVal Value As Boolean)
	'Builds a band-based MFF Report (page header with field labels, detail
	'fields, page footer with page number, optional group header by the
	'given column) from the visible grid and opens its preview / print /
	'PDF pipeline. Uses the full Report.Bas feature set: bands, fields,
	'labels, CanGrow, FormatString, summaries and grouping.
	Declare Sub ReportShow(ByRef Title As WString = "", ByVal GroupCol As Long = -1, ByVal ToPDF As Boolean = False)
		'Filter bar (batch 4): per-column criteria strings. Supported forms:
		'">n" "<n" ">=n" "<=n" "<>x" "=x" (numeric when both sides parse),
		'"x*" starts with, "*x" ends with, "*x*" contains, plain text contains;
		'all comparisons are case-insensitive, "" disables the column filter.
		Declare Property ShowFilterBar As Boolean
		Declare Property ShowFilterBar(ByVal Value As Boolean)
		Declare Property ColFilter(ByVal Index As Long) ByRef As WString
		Declare Property ColFilter(ByVal Index As Long, ByRef Value As WString)
		Declare Sub ApplyFilters()
		Declare Sub ClearFilters()
		Declare Property FilteredRowCount As Long
		'Multi-column sort (batch 4): keys run in insertion order (first = most
		'significant); MultiSortRun applies them bottom-up through the stable
		'Sort and refreshes the per-column sort arrows.
		Declare Sub MultiSortClear()
		Declare Sub MultiSortAdd(ByVal Col As Long, ByVal SortType As Integer = FlexSortGenericAscending)
		Declare Sub MultiSortRun()
		Declare Property MultiSortCount As Long
		Declare Property MultiSortCol(ByVal Index As Long) As Long
		Declare Property MultiSortType(ByVal Index As Long) As Integer
		'Row bookmarks (batch 4): a ribbon marker is drawn in the row header of
		'bookmarked rows (color = InsertMarkColor, orange by default).
		Declare Property RowBookmarked(ByVal Index As Long) As Boolean
		Declare Property RowBookmarked(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property BookmarkCount As Long
		Declare Function NextBookmark(ByVal FromRow As Long = -1) As Long
		Declare Function PreviousBookmark(ByVal FromRow As Long = -1) As Long
		Declare Sub ClearBookmarks()
		'View zoom (batch 4): 0.25..4.0; scales row/column geometry and the
		'control font. Ctrl+mouse wheel changes it in 0.1 steps.
		Declare Property Zoom As Double
		Declare Property Zoom(ByVal Value As Double)
		'Multi-format export (batch 4): UTF-8 files, hidden rows/columns are
		'skipped. ExportHTML writes a styled <table> document, ExportJSON an
		'array of objects keyed by the fixed-row header (or array of arrays
		'when WithHeaders = False).
		Declare Function ExportHTML(ByRef FileName As WString, ByVal WithHeaders As Boolean = True, ByVal WithStyles As Boolean = True) As Boolean
		Declare Function ExportJSON(ByRef FileName As WString, ByVal WithHeaders As Boolean = True) As Boolean
		'=== Batch 5: remaining VBFlexGrid 1.8 public surface ===
		'Sets up columns, alignments and header texts from a format string.
		'First ";" splits column headers (row 0, "|"-separated, alignment
		'prefix < ^ >) from row headers (column 0, "|"-separated).
		Declare Property FormatString ByRef As WString
		Declare Property FormatString(ByRef Value As WString)
		'Modal drag loops: call inside e.g. BeforeMouseDown while the mouse
		'button is held; they show the insert mark, auto-scroll near the edges
		'and return the target position for RowPosition/ColPosition.
		Declare Function DragRow(ByVal Index As Long) As Long
		Declare Function DragCol(ByVal Index As Long) As Long
		'Insert mark / drop highlight visual feedback (row or column based).
		Declare Property InsertMark(ByRef After As Boolean) As Long
		Declare Property InsertMark(ByVal After As Boolean, ByVal Value As Long)
		Declare Property InsertMarkMode As Integer
		Declare Property InsertMarkMode(ByVal Value As Integer)
		Declare Function HitTestInsertMark(ByVal X As Long, ByVal Y As Long, ByRef After As Boolean) As Long
		Declare Property DropHighlight As Long
		Declare Property DropHighlight(ByVal Value As Long)
		Declare Property DropHighlightMode As Integer
		Declare Property DropHighlightMode(ByVal Value As Integer)
		'Background bitmap drawn behind the cells (HBITMAP, caller-owned).
		Declare Property WallPaper As Any Ptr
		Declare Property WallPaper(ByVal Value As Any Ptr)
		Declare Property WallPaperAlignment As Integer
		Declare Property WallPaperAlignment(ByVal Value As Integer)
		'WM_DROPFILES support: fires OnDropFiles with the CRLF-joined file list.
		Declare Property AllowDropFiles As Boolean
		Declare Property AllowDropFiles(ByVal Value As Boolean)
		'Middle-button panning (reader mode).
		Declare Property AllowReaderMode As Boolean
		Declare Property AllowReaderMode(ByVal Value As Boolean)
		Declare Property MouseTrack As Boolean
		Declare Property MouseTrack(ByVal Value As Boolean)
		'Per-column lookup translation: "key;value|key;value|...".
		Declare Property ColLookup(ByVal Index As Long) ByRef As WString
		Declare Property ColLookup(ByVal Index As Long, ByRef Value As WString)
		Declare Function LookupConv(ByRef Text As WString, ByVal Conversion As Integer, ByVal aCol As Long = -1) ByRef As WString
		'Cell text as displayed (lookup-translated when the column has one).
		Declare Function TextDisplay(ByVal aRow As Long, ByVal aCol As Long) ByRef As WString
		'Per-column text indentation via the OnCellTextIndent event (twips).
		Declare Property ColTextIndent(ByVal Index As Long) As Boolean
		Declare Property ColTextIndent(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColMimicTextBox(ByVal Index As Long) As Boolean
		Declare Property ColMimicTextBox(ByVal Index As Long, ByVal Value As Boolean)
		'Scroll tip shown while dragging the scroll thumb (ShowScrollTips).
		Declare Property ScrollTipText ByRef As WString
		Declare Property ScrollTipText(ByRef Value As WString)
		'Grid line and focus rect thickness (pixels).
		Declare Property GridLineWidth As Long
		Declare Property GridLineWidth(ByVal Value As Long)
		Declare Property GridLineWidthFixed As Long
		Declare Property GridLineWidthFixed(ByVal Value As Long)
		Declare Property GridLineWidthFrozen As Long
		Declare Property GridLineWidthFrozen(ByVal Value As Long)
		Declare Property FocusRectWidth As Long
		Declare Property FocusRectWidth(ByVal Value As Long)
		'Info/label/scroll tip and scroll-lock switches (VBFlexGrid parity).
		Declare Property ShowInfoTips As Boolean
		Declare Property ShowInfoTips(ByVal Value As Boolean)
		Declare Property ShowLabelTips As Boolean
		Declare Property ShowLabelTips(ByVal Value As Boolean)
		Declare Property ShowScrollTips As Boolean
		Declare Property ShowScrollTips(ByVal Value As Boolean)
		Declare Property AllowScrollLock As Boolean
		Declare Property AllowScrollLock(ByVal Value As Boolean)
		'Combo cues stay clickable (OnComboCueClick) even with editing off.
		Declare Property AlwaysAllowComboCues As Boolean
		Declare Property AlwaysAllowComboCues(ByVal Value As Boolean)
		'Check boxes drawn but not hit-testable (mouse clicks hit the cell).
		Declare Property ColCheckBoxesHitTestInvisible(ByVal Index As Long) As Boolean
		Declare Property ColCheckBoxesHitTestInvisible(ByVal Index As Long, ByVal Value As Boolean)
		Declare Property ColCheckBoxesHitTestInvisibleFixed(ByVal Index As Long) As Boolean
		Declare Property ColCheckBoxesHitTestInvisibleFixed(ByVal Index As Long, ByVal Value As Boolean)
		'Per-column cell buttons: every data cell of the column renders as an
		'owner-drawn command button using the cell text as its caption;
		'clicking raises OnCellButtonClick (hit result FlexHitResultCellButton).
		Declare Property ColCellButtons(ByVal Index As Long) As Boolean
		Declare Property ColCellButtons(ByVal Index As Long, ByVal Value As Boolean)
		'Edit session helpers.
		Declare Property HwndEdit As Long
		Declare Property ComboCalendarValue ByRef As WString
		'Fast bulk data exchange with String arrays (FlexRowMajor order fills
		'Arr(row, col); FlexColumnMajor fills Arr(col, row) like VB GetRows).
		Declare Function SaveArray(Arr() As WString Ptr, ByVal Order As Integer = FlexColumnMajor, ByVal MaxRows As Long = -1, ByVal MaxCols As Long = -1, ByVal StartRow As Long = -1, ByVal StartCol As Long = -1, ByVal ExcludeHidden As Boolean = False, ByVal OneDim As Boolean = False) As Boolean
		Declare Function LoadArray(Arr() As WString Ptr, ByVal Order As Integer = FlexColumnMajor, ByVal StartRow As Long = -1, ByVal StartCol As Long = -1, ByVal RestrictRows As Boolean = False, ByVal RestrictCols As Boolean = False, ByVal OneDim As Boolean = False) As Boolean
		'Clip string <-> 2D String array helpers using the clip separators.
		Declare Sub ParseClip(ByRef ClipText As WString, Arr() As WString Ptr)
		Declare Function ConstructClip(Arr() As WString Ptr) ByRef As WString
		'Search by the CellTag pointer value.
		Declare Function FindTag(ByVal TagValue As Any Ptr, ByVal aRow As Long = -1, ByVal aCol As Long = -1, ByVal ExcludeHidden As Boolean = False, ByVal Wrap As Boolean = True, ByVal Direction As Integer = FlexFindDirectionDown) As Boolean
		'Non-hidden index mapping (filters/hidden rows shift positions).
		Declare Property RowsNonHidden As Long
		Declare Property ColsNonHidden As Long
		Declare Property RowPositionFromNonHidden(ByVal NonHiddenIndex As Long) As Long
		Declare Property ColPositionFromNonHidden(ByVal NonHiddenIndex As Long) As Long
		Declare Property RowNonHiddenPosition(ByVal Index As Long) As Long
		Declare Property ColNonHiddenPosition(ByVal Index As Long) As Long
		Declare Property IncrementalSearchTime As Long
		Declare Property IncrementalSearchTime(ByVal Value As Long)
		'Renders the current view into a new HBITMAP (caller deletes it) and
		'copies that bitmap to the clipboard.
		Declare Property Picture As Any Ptr
		Declare Sub PrintToClipboard()
		Declare Sub AutoSize(ByVal RowOrCol1 As Long, ByVal RowOrCol2 As Long = -1, ByVal Mode As Integer = FlexAutoSizeModeColWidth, ByVal ScopeVal As Integer = FlexAutoSizeScopeAll, ByVal Equal As Boolean = False, ByVal ExtraSpace As Long = 0)
		Declare Function TextWidthOf(ByRef Value As WString) As Long
		Declare Function TextHeightOf(ByRef Value As WString) As Long
		Declare Sub Refresh()
		Declare Sub AutoSizeCol(ByVal aCol As Long, ByVal bIncludeFixed As Boolean = False)
		Declare Function StartEdit(ByVal Row As Long = -1, ByVal Col As Long = -1) As Boolean
		Declare Function CancelEdit() As Boolean
		Declare Function CommitEdit() As Boolean
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor

		'Raised when the current cell is about to change; set Cancel to True to keep focus.
		OnBeforeRowColChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal NewRow As Long, ByVal NewCol As Long, ByRef Cancel As Boolean)
		'Raised when the current cell changes.
		OnRowColChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when the current cell changes from one cell to another (before change applied).
		OnLeaveCell As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when the focus enters a new cell.
		OnEnterCell As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised after the selection range changed.
		OnSelChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when multiple, non-contiguous selection changed.
		OnMultiSelChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised on a single click onto a cell.
		OnClick_ As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised on a single click onto a cell (VB6 CellClick with mouse button).
		OnCellClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Button As Integer)
		'Raised on a double click onto a cell.
		OnDblClick_ As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised on a double click onto a cell (VB6 CellDblClick with mouse button).
		OnCellDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Button As Integer)
		'Raised before mouse down processing; set Cancel to True to swallow it.
		OnBeforeMouseDown As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Long, ByVal Y As Long, ByRef Cancel As Boolean)
		'Raised after a cell edit was committed.
		OnAfterEdit As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString)
		'Raised before an edit starts; set Cancel to True to prevent editing.
		OnBeforeEdit As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer, ByRef Cancel As Boolean)
		'Raised when the edit session ended (after AfterEdit).
		OnLeaveEdit As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when the edit session starts.
		OnEnterEdit As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when the in-place edit text changed.
		OnEditChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised on key down inside the in-place editor.
		OnEditKeyDown As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer)
		'Raised on key press inside the in-place editor.
		OnEditKeyPress As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyChar As Integer)
		'Raised when the edit is about to close; set Cancel to True to keep editing.
		OnEditQueryClose As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal CloseMode As Integer, ByRef Cancel As Boolean)
		'Raised before the grid was scrolled.
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised during custom sort to compare two rows; return <0, 0, >0 in Cmp.
		OnCompare As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row1 As Long, ByVal Row2 As Long, ByVal Col As Long, ByRef Cmp As Long)
		'Raised before a user resize of a divider; set Cancel to True to prevent it.
		OnBeforeUserResize As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef Cancel As Boolean)
		'Raised after a user resize; NewSize holds the new size in twips (-1 for double click auto fit).
		OnAfterUserResize As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal NewSize As Long)
		'Raised when a cell check state is about to change; set Cancel to True to prevent it.
		OnCellBeforeCheck As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer, ByRef Cancel As Boolean)
		'Raised after a cell check state changed.
		OnCellCheck As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised when a divider was double clicked (auto fit opportunity).
		OnDividerDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised on key down with the grid focused; set IsInputKey to False to forward to the parent.
		OnKeyDown As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer)
		'Raised on key press with the grid focused.
		OnKeyPress As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyChar As Integer)
		'Raised on key up with the grid focused.
		OnKeyUp As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer)
		'Raised when a combo cue of a cell was clicked.
		OnComboCueClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer)
		'Raised after a column filter changed (Col = -1 when ClearFilters ran).
		OnFilterChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Col As Long)
		'Raised while the scroll thumb is dragged; set ScrollTipText to show it.
		OnScrollTip As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised when files are dropped onto the grid (CRLF joined list).
		OnDropFiles As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef Files As WString)
		'Raised before the in-place editor window is created (styles ByRef).
		OnEditSetupStyle As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef dwStyle As Long, ByRef dwExStyle As Long)
		'Raised when the in-place editor was created but not shown yet.
		OnEditSetupWindow As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef BackColor As Long, ByRef ForeColor As Long)
		'Raised when a FlexComboModeButton cell requests a custom editor.
		OnComboButtonClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised when an incremental search session starts (ByRef to customize).
		OnBeginIncrementalSearch As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef Row As Long, ByRef Col As Long, ByRef CaseSensitive As Boolean, ByRef NoWrap As Boolean, ByRef Cancel As Boolean)
		'Raised when an incremental search session ends.
		OnEndIncrementalSearch As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx)
		'Raised before/after clipboard actions; set Cancel to block them.
		OnBeforeClipboardAction As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Action As Integer, ByRef Cancel As Boolean)
		OnAfterClipboardAction As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Action As Integer)
		'Raised when a cell button (ColCellButtons column) was clicked.
		OnCellButtonClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		'Raised for every cell of a ColTextIndent column (twips ByRef).
		OnCellTextIndent As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef IndentLeft As Long, ByRef IndentRight As Long)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "GridDataEx.bas"
#endif