'################################################################################
'#  GridDataExEnums.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Converted from: VBFLXGRD18 (VB GridDataEx Control 1.8)                        #
'#  Original author of the VB6 source: Krool (VBFlexGrid)                       #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'#  Contains all public enumeration constants of the GridDataEx control.          #
'################################################################################

#pragma once

#include once "Object.bi"

Namespace My.Sys.Forms
	'OLE drag/drop mode constants.
	Enum FlexOLEDropModeConstants
		FlexOLEDropModeNone = 0
		FlexOLEDropModeManual = 1
	End Enum

	'Mouse pointer constants.
	Enum FlexMousePointerConstants
		FlexMousePointerDefault = 0
		FlexMousePointerArrow = 1
		FlexMousePointerCrosshair = 2
		FlexMousePointerIbeam = 3
		FlexMousePointerHand = 4
		FlexMousePointerSizePointer = 5
		FlexMousePointerSizeNESW = 6
		FlexMousePointerSizeNS = 7
		FlexMousePointerSizeNWSE = 8
		FlexMousePointerSizeWE = 9
		FlexMousePointerUpArrow = 10
		FlexMousePointerHourglass = 11
		FlexMousePointerNoDrop = 12
		FlexMousePointerArrowHourglass = 13
		FlexMousePointerArrowQuestion = 14
		FlexMousePointerSizeAll = 15
		FlexMousePointerArrowCD = 16
		FlexMousePointerPin = 17
		FlexMousePointerPerson = 18
		FlexMousePointerPen = 19
		FlexMousePointerScrollN = 20
		FlexMousePointerScrollS = 21
		FlexMousePointerScrollE = 22
		FlexMousePointerScrollW = 23
		FlexMousePointerScrollNS = 24
		FlexMousePointerScrollWE = 25
		FlexMousePointerScrollNW = 26
		FlexMousePointerScrollNE = 27
		FlexMousePointerScrollSW = 28
		FlexMousePointerScrollSE = 29
		FlexMousePointerScrollAll = 30
		FlexMousePointerCustom = 99
	End Enum

	'Right-to-left mode constants.
	Enum FlexRightToLeftModeConstants
		FlexRightToLeftModeNoControl = 0
		FlexRightToLeftModeVBAME = 1
		FlexRightToLeftModeSystemLocale = 2
		FlexRightToLeftModeUserLocale = 3
		FlexRightToLeftModeOSLanguage = 4
	End Enum

	'Border style constants.
	Enum FlexBorderStyleConstants
		FlexBorderStyleNone = 0
		FlexBorderStyleSingle = 1
		FlexBorderStyleThin = 2
		FlexBorderStyleSunken = 3
		FlexBorderStyleRaised = 4
	End Enum

	'Left/right alignment constants.
	Enum FlexLeftRightAlignmentConstants
		FlexLeftRightAlignmentLeft = 0
		FlexLeftRightAlignmentRight = 1
	End Enum

	'Scroll orientation constants.
	Enum FlexScrollOrientationConstants
		FlexScrollOrientationHorizontal = 0
		FlexScrollOrientationVertical = 1
		FlexScrollOrientationBoth = 2
	End Enum

	'Allow user freezing constants.
	Enum FlexAllowUserFreezingConstants
		FlexAllowUserFreezingNone = 0
		FlexAllowUserFreezingColumns = 1
		FlexAllowUserFreezingRows = 2
		FlexAllowUserFreezingBoth = 3
	End Enum

	'Allow user resizing constants.
	Enum FlexAllowUserResizingConstants
		FlexAllowUserResizingNone = 0
		FlexAllowUserResizingColumns = 1
		FlexAllowUserResizingRows = 2
		FlexAllowUserResizingBoth = 3
	End Enum

	'Selection mode constants.
	Enum FlexSelectionModeConstants
		FlexSelectionModeFree = 0
		FlexSelectionModeByRow = 1
		FlexSelectionModeByColumn = 2
		FlexSelectionModeFreeByRow = 3
		FlexSelectionModeFreeByColumn = 4
	End Enum

	'Fill style constants.
	Enum FlexFillStyleConstants
		FlexFillStyleSingle = 0
		FlexFillStyleRepeat = 1
	End Enum

	'Highlight constants.
	Enum FlexHighLightConstants
		FlexHighLightNever = 0
		FlexHighLightAlways = 1
		FlexHighLightWithFocus = 2
		FlexHighLightAlwaysFocusRect = 3
	End Enum

	'Focus rect constants.
	Enum FlexFocusRectConstants
		FlexFocusRectNone = 0
		FlexFocusRectLight = 1
		FlexFocusRectHeavy = 2
		FlexFocusRectFlat = 3
	End Enum

	'Grid line constants.
	Enum GridDataLineConstants
		GridDataLineNone = 0
		GridDataLineFlat = 1
		GridDataLineInset = 2
		GridDataLineRaised = 3
		GridDataLineDashes = 4
		GridDataLineDots = 5
		GridDataLineFlatHorz = 6
		GridDataLineInsetHorz = 7
		GridDataLineRaisedHorz = 8
		GridDataLineDashesHorz = 9
		GridDataLineDotsHorz = 10
		GridDataLineFlatVert = 11
		GridDataLineInsetVert = 12
		GridDataLineRaisedVert = 13
		GridDataLineDashesVert = 14
		GridDataLineDotsVert = 15
	End Enum

	'Text style constants.
	Enum FlexTextStyleConstants
		FlexTextStyleFlat = 0
		FlexTextStyleRaised = 1
		FlexTextStyleInset = 2
		FlexTextStyleRaisedLight = 3
		FlexTextStyleInsetLight = 4
	End Enum

	'Hit test result constants.
	Enum FlexHitResultConstants
		FlexHitResultNoWhere = 0
		FlexHitResultCell = 1
		FlexHitResultDividerRowTop = 2
		FlexHitResultDividerRowBottom = 3
		FlexHitResultDividerColumnLeft = 4
		FlexHitResultDividerColumnRight = 5
		FlexHitResultDividerFrozenRowTop = 6
		FlexHitResultDividerFrozenRowBottom = 7
		FlexHitResultDividerFrozenColumnLeft = 8
		FlexHitResultDividerFrozenColumnRight = 9
		FlexHitResultComboCue = 10
		FlexHitResultComboCueDisabled = 11
		FlexHitResultCheckBox = 12
		FlexHitResultCheckBoxDisabled = 13
		FlexHitResultFilterCell = 14
		FlexHitResultCellButton = 15
	End Enum

	'Drop target mode constants.
	Enum FlexDropTargetModeConstants
		FlexDropTargetModeByRow = 0
		FlexDropTargetModeByColumn = 1
	End Enum

	'Cell alignment constants.
	Enum FlexAlignmentConstants
		FlexAlignmentLeftTop = 0
		FlexAlignmentLeftCenter = 1
		FlexAlignmentLeftBottom = 2
		FlexAlignmentCenterTop = 3
		FlexAlignmentCenterCenter = 4
		FlexAlignmentCenterBottom = 5
		FlexAlignmentRightTop = 6
		FlexAlignmentRightCenter = 7
		FlexAlignmentRightBottom = 8
		FlexAlignmentGeneral = 9
		FlexAlignmentGeneralTop = 10
		FlexAlignmentGeneralCenter = 11
		FlexAlignmentGeneralBottom = 12
	End Enum

	'Picture alignment constants.
	Enum FlexPictureAlignmentConstants
		FlexPictureAlignmentLeftTop = 0
		FlexPictureAlignmentLeftCenter = 1
		FlexPictureAlignmentLeftBottom = 2
		FlexPictureAlignmentCenterTop = 3
		FlexPictureAlignmentCenterCenter = 4
		FlexPictureAlignmentCenterBottom = 5
		FlexPictureAlignmentRightTop = 6
		FlexPictureAlignmentRightCenter = 7
		FlexPictureAlignmentRightBottom = 8
		FlexPictureAlignmentStretch = 9
		FlexPictureAlignmentTile = 10
		FlexPictureAlignmentLeftTopNoOverlap = 20
		FlexPictureAlignmentLeftCenterNoOverlap = 21
		FlexPictureAlignmentLeftBottomNoOverlap = 22
		FlexPictureAlignmentRightTopNoOverlap = 26
		FlexPictureAlignmentRightCenterNoOverlap = 27
		FlexPictureAlignmentRightBottomNoOverlap = 28
	End Enum

	'Row sizing mode constants.
	Enum FlexRowSizingModeConstants
		FlexRowSizingModeIndividual = 0
		FlexRowSizingModeAll = 1
		FlexRowSizingModeUniform = 2
	End Enum

	'Merge cells constants.
	Enum FlexMergeCellsConstants
		FlexMergeCellsNever = 0
		FlexMergeCellsFree = 1
		FlexMergeCellsRestrictRows = 2
		FlexMergeCellsRestrictColumns = 3
		FlexMergeCellsRestrictAll = 4
		FlexMergeCellsFixedOnly = 5
	End Enum

	'Sort constants.
	Enum FlexSortConstants
		FlexSortNone = 0
		FlexSortGenericAscending = 1
		FlexSortGenericDescending = 2
		FlexSortNumericAscending = 3
		FlexSortNumericDescending = 4
		FlexSortStringNoCaseAscending = 5
		FlexSortStringNoCaseDescending = 6
		FlexSortStringAscending = 7
		FlexSortStringDescending = 8
		FlexSortCustom = 9
		FlexSortUseColSort = 10
		FlexSortCurrencyAscending = 11
		FlexSortCurrencyDescending = 12
		FlexSortDateAscending = 13
		FlexSortDateDescending = 14
		FlexSortCustomText = 15
	End Enum

	'Sort mode constants.
	Enum FlexSortModeConstants
		FlexSortModeNormal = 0
		FlexSortModeTextDisplay = 1
	End Enum

	'Visibility constants.
	Enum FlexVisibilityConstants
		FlexVisibilityPartialOK = 0
		FlexVisibilityCompleteOnly = 1
	End Enum

	'Picture type constants.
	Enum FlexPictureTypeConstants
		FlexPictureTypeColor = 0
		FlexPictureTypeMonochrome = 1
		FlexPictureTypeEnhMetafile = 2
	End Enum

	'Ellipsis format constants.
	Enum FlexEllipsisFormatConstants
		FlexEllipsisFormatNone = 0
		FlexEllipsisFormatEnd = 1
		FlexEllipsisFormatPath = 2
		FlexEllipsisFormatWord = 3
	End Enum

	'Word wrap options.
	Enum FlexWordWrapOptions
		FlexWordWrapNone = 0
		FlexWordBreak = 1
		FlexSingleLine = 2
		FlexEndEllipsis = 3
		FlexPathEllipsis = 4
		FlexWordEllipsis = 5
		FlexWordBreakEndEllipsis = 6
		FlexWordBreakPathEllipsis = 7
		FlexWordBreakWordEllipsis = 8
		FlexSingleLineEndEllipsis = 9
		FlexSingleLinePathEllipsis = 10
		FlexSingleLineWordEllipsis = 11
	End Enum

	'Mimic text box constants.
	Enum FlexMimicTextBoxConstants
		FlexMimicTextBoxOn = 0
		FlexMimicTextBoxOff = 1
	End Enum

	'Clear "where" constants.
	Enum FlexClearWhereConstants
		FlexClearEverywhere = 0
		FlexClearFixed = 1
		FlexClearScrollable = 2
		FlexClearMovable = 3
		FlexClearFrozen = 4
		FlexClearSelection = 5
		FlexClearClip = 6
	End Enum

	'Clear "what" constants.
	Enum FlexClearWhatConstants
		FlexClearEverything = 0
		FlexClearText = 1
		FlexClearFormatting = 2
		FlexClearTag = 3
	End Enum

	'Tab behavior constants.
	Enum FlexTabBehaviorConstants
		FlexTabControls = 0
		FlexTabCells = 1
		FlexTabNext = 2
	End Enum

	'Direction after return constants.
	Enum FlexDirectionAfterReturnConstants
		FlexDirectionAfterReturnNone = 0
		FlexDirectionAfterReturnUp = 1
		FlexDirectionAfterReturnDown = 2
		FlexDirectionAfterReturnLeft = 3
		FlexDirectionAfterReturnRight = 4
		FlexDirectionAfterReturnEdit = 5
	End Enum

	'Wrap cell behavior constants.
	Enum FlexWrapCellBehaviorConstants
		FlexWrapNone = 0
		FlexWrapRow = 1
		FlexWrapGrid = 2
	End Enum

	'Cell settings indices used by the Cell property.
	Enum FlexCellSettings
		FlexCellText = 0
		FlexCellClip = 1
		FlexCellTextStyle = 2
		FlexCellAlignment = 3
		FlexCellPicture = 4
		FlexCellPictureAlignment = 5
		FlexCellBackColor = 6
		FlexCellForeColor = 7
		FlexCellToolTipText = 8
		FlexCellComboCue = 9
		FlexCellChecked = 10
		FlexCellFloodPercent = 11
		FlexCellFloodColor = 12
		FlexCellFontName = 13
		FlexCellFontSize = 14
		FlexCellFontBold = 15
		FlexCellFontItalic = 16
		FlexCellFontStrikeThrough = 17
		FlexCellFontUnderline = 18
		FlexCellFontCharset = 19
		FlexCellLeft = 20
		FlexCellTop = 21
		FlexCellWidth = 22
		FlexCellHeight = 23
		FlexCellSort = 24
		FlexCellTextDisplay = 25
		FlexCellTextHidden = 26
		FlexCellHasCustomFormatting = 27
		FlexCellHasTag = 28
		FlexCellTag = 29
	End Enum

	'Auto size mode constants.
	Enum FlexAutoSizeModeConstants
		FlexAutoSizeModeColWidth = 0
		FlexAutoSizeModeRowHeight = 1
	End Enum

	'Auto size scope constants.
	Enum FlexAutoSizeScopeConstants
		FlexAutoSizeScopeAll = 0
		FlexAutoSizeScopeFixed = 1
		FlexAutoSizeScopeScrollable = 2
		FlexAutoSizeScopeMovable = 3
		FlexAutoSizeScopeFrozen = 4
	End Enum

	'Clipboard mode constants.
	Enum FlexClipModeConstants
		FlexClipModeNormal = 0
		FlexClipModeExcludeHidden = 1
		FlexClipModeLookupConv = 2
		FlexClipModeLookupConvExcludeHidden = 3
	End Enum

	'Clipboard copy mode constants.
	Enum FlexClipCopyModeConstants
		FlexClipCopyModeNormal = 0
		FlexClipCopyModeIncludeFixedRows = 1
		FlexClipCopyModeIncludeFixedColumns = 2
		FlexClipCopyModeIncludeFixedAll = 3
		FlexClipCopyModeExtended = 4
		FlexClipCopyModeExtendedFixedRows = 5
		FlexClipCopyModeExtendedFixedColumns = 6
		FlexClipCopyModeExtendedFixedAll = 7
	End Enum

	'Clipboard paste mode constants.
	Enum FlexClipPasteModeConstants
		FlexClipPasteModeNormal = 0
		FlexClipPasteModeAutoSelection = 1
		FlexClipPasteModeExtended = 2
		FlexClipPasteModeExtendedAutoSelection = 3
	End Enum

	'Clipboard action constants.
	Enum FlexClipboardActionConstants
		FlexClipboardActionCopy = 0
		FlexClipboardActionCut = 1
		FlexClipboardActionPaste = 2
		FlexClipboardActionDelete = 3
	End Enum

	'Find match constants.
	Enum FlexFindMatchConstants
		FlexFindMatchExact = 0
		FlexFindMatchPartial = 1
		FlexFindMatchStartsWith = 2
		FlexFindMatchEndsWith = 3
	End Enum

	'Find direction constants.
	Enum FlexFindDirectionConstants
		FlexFindDirectionDown = 0
		FlexFindDirectionUp = 1
		FlexFindDirectionRight = 2
		FlexFindDirectionLeft = 3
	End Enum

	'Aggregate (range statistics) constants for GridDataEx.Aggregate.
	Enum GridAggConstants
		GridAggSum = 0
		GridAggCount = 1
		GridAggAverage = 2
		GridAggMin = 3
		GridAggMax = 4
		GridAggCountNumeric = 5
	End Enum

	'Array element order for SaveArray/LoadArray (batch 5).
	Enum FlexArrayOrderConstants
		FlexRowMajor = 0
		FlexColumnMajor = 1
	End Enum

	'Lookup conversion constants.
	Enum FlexLookupConvConstants
		FlexLookupConvValue = 0
		FlexLookupConvKey = 1
	End Enum

	'IME mode constants.
	Enum FlexIMEModeConstants
		FlexIMEModeNoControl = 0
		FlexIMEModeOn = 1
		FlexIMEModeOff = 2
		FlexIMEModeDisable = 3
		FlexIMEModeHiragana = 4
		FlexIMEModeKatakana = 5
		FlexIMEModeKatakanaHalf = 6
		FlexIMEModeAlphaFull = 7
		FlexIMEModeAlpha = 8
		FlexIMEModeHangulFull = 9
		FlexIMEModeHangul = 10
	End Enum

	'Edit reason constants.
	Enum FlexEditReasonConstants
		FlexEditReasonCode = 0
		FlexEditReasonF2 = 1
		FlexEditReasonSpace = 2
		FlexEditReasonKeyPress = 3
		FlexEditReasonDblClick = 4
		FlexEditReasonBackSpace = 5
		FlexEditReasonReturn = 6
		FlexEditReasonComboCueClick = 10
		FlexEditReasonComboCueDblClick = 11
		FlexEditReasonComboCueF4 = 12
		FlexEditReasonComboCueAltUpDown = 13
	End Enum

	'Edit close mode constants.
	Enum FlexEditCloseModeConstants
		FlexEditCloseModeCode = 0
		FlexEditCloseModeLostFocus = 1
		FlexEditCloseModeEscape = 2
		FlexEditCloseModeReturn = 3
		FlexEditCloseModeTab = 4
		FlexEditCloseModeShiftTab = 5
		FlexEditCloseModeNavigationKey = 6
	End Enum

	'Combo cue constants.
	Enum FlexComboCueConstants
		FlexComboCueHidden = -1
		FlexComboCueNone = 0
		FlexComboCueDropDown = 1
		FlexComboCueButton = 2
		FlexComboCueDisabledDropDown = 3
		FlexComboCueDisabledButton = 4
	End Enum

	'Combo mode constants.
	Enum FlexComboModeConstants
		FlexComboModeNone = 0
		FlexComboModeDropDown = 1
		FlexComboModeEditable = 2
		FlexComboModeButton = 3
		FlexComboModeCalendar = 4
		FlexComboModeCalculator = 5
	End Enum

	'Combo drop down reason constants.
	Enum FlexComboDropDownReasonConstants
		FlexComboDropDownReasonCode = 0
		FlexComboDropDownReasonInitialize = 1
		FlexComboDropDownReasonMouse = 2
		FlexComboDropDownReasonKeyboard = 3
	End Enum

	'Combo button value constants.
	Enum FlexComboButtonValueConstants
		FlexComboButtonValueUnpressed = 0
		FlexComboButtonValuePressed = 1
		FlexComboButtonValueDisabled = 2
	End Enum

	'Combo button draw mode constants.
	Enum FlexComboButtonDrawModeConstants
		FlexComboButtonDrawModeNormal = 0
		FlexComboButtonDrawModeOwnerDraw = 1
	End Enum

	'Sort arrow constants.
	Enum FlexSortArrowConstants
		FlexSortArrowNone = 0
		FlexSortArrowAscending = 1
		FlexSortArrowDescending = 2
	End Enum

	'Check box state constants.
	Enum FlexCheckBoxConstants
		FlexNoCheckBoxEver = -2
		FlexNoCheckBox = -1
		FlexUnchecked = 0
		FlexChecked = 1
		FlexGrayed = 2
		FlexTextAsCheckBox = 3
		FlexDisabledUnchecked = 4
		FlexDisabledChecked = 5
		FlexDisabledGrayed = 6
		FlexDisabledTextAsCheckBox = 7
	End Enum

	'Cell check reason constants.
	Enum FlexCellCheckReasonConstants
		FlexCellCheckReasonMouse = 0
		FlexCellCheckReasonKeyboard = 1
	End Enum

	'Check box alignment constants.
	Enum FlexCheckBoxAlignmentConstants
		FlexCheckBoxAlignmentLeftTop = 0
		FlexCheckBoxAlignmentLeftCenter = 1
		FlexCheckBoxAlignmentLeftBottom = 2
		FlexCheckBoxAlignmentCenterTop = 3
		FlexCheckBoxAlignmentCenterCenter = 4
		FlexCheckBoxAlignmentCenterBottom = 5
		FlexCheckBoxAlignmentRightTop = 6
		FlexCheckBoxAlignmentRightCenter = 7
		FlexCheckBoxAlignmentRightBottom = 8
		FlexCheckBoxAlignmentUsePictureAlignment = 9
	End Enum

	'Check box draw mode constants.
	Enum FlexCheckBoxDrawModeConstants
		FlexCheckBoxDrawModeNormal = 0
		FlexCheckBoxDrawModeOwnerDraw = 1
	End Enum

	'Best fit mode constants.
	Enum FlexBestFitModeConstants
		FlexBestFitModeTextOnly = 0
		FlexBestFitModeFull = 1
		FlexBestFitModeSortArrowText = 2
		FlexBestFitModeOtherText = 3
	End Enum

	'Wallpaper alignment constants.
	Enum FlexWallPaperAlignmentConstants
		FlexWallPaperAlignmentLeftTop = 0
		FlexWallPaperAlignmentLeftCenter = 1
		FlexWallPaperAlignmentLeftBottom = 2
		FlexWallPaperAlignmentCenterTop = 3
		FlexWallPaperAlignmentCenterCenter = 4
		FlexWallPaperAlignmentCenterBottom = 5
		FlexWallPaperAlignmentRightTop = 6
		FlexWallPaperAlignmentRightCenter = 7
		FlexWallPaperAlignmentRightBottom = 8
		FlexWallPaperAlignmentStretch = 9
		FlexWallPaperAlignmentTile = 10
	End Enum

	'Font quality constants.
	Enum FlexFontQualityConstants
		FlexFontQualityDefault = 0
		FlexFontQualityDraft = 1
		FlexFontQualityProof = 2
		FlexFontQualityNonAntiAliased = 3
		FlexFontQualityAntiAliased = 4
		FlexFontQualityClearType = 5
		FlexFontQualityClearTypeNatural = 6
	End Enum

	'Metric constants.
	Enum FlexMetricConstants
		FlexMetricDividerSpacing = 0
		FlexMetricTextPadding = 1
		FlexMetricCellSpacing = 2
		FlexMetricScrollBarSize = 3
		FlexMetricCheckBoxSize = 4
	End Enum

	'Data source flags.
	Enum FlexDataSourceFlags
		FlexDataSourceUnboundFixedColumns = 1
		FlexDataSourceNoData = 2
		FlexDataSourceNoFieldNames = 4
		FlexDataSourceToolTipText = 8
		FlexDataSourceChecked = 16
	End Enum
End Namespace
