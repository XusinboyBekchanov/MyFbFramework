'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019)                                     #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QChart(__Ptr__) *Cast(Chart Ptr, __Ptr__)
	
	Private Type POINTL
		X As Long
		Y As Long
	End Type
	
	Private Type POINTF
		X As Single
		Y As Single
	End Type
	
	Private Type SIZEF
		Width As Single
		Height As Single
	End Type
	
	Private Type RectF
		Left As Single
		Top As Single
		Width As Single
		Height As Single
	End Type
	
	Private Type RectL
		Left As Long
		Top As Long
		Width As Long
		Height As Long
	End Type
	
	Private Type GDIPlusStartupInput
		GdiPlusVersion              As Long
		DebugEventCallback          As Long
		SuppressBackgroundThread    As Long
		SuppressExternalCodecs      As Long
	End Type
	
	Private Enum CaptionAlignmentH
		cLeft
		cCenter
		cRight
	End Enum
	
	Private Enum CaptionAlignmentV
		cTop
		cMiddle
		cBottom
	End Enum
	
	Private Enum GDIPLUS_FONTSTYLE
		FontStyleRegular = 0
		FontStyleBold = 1
		FontStyleItalic = 2
		FontStyleBoldItalic = 3
		FontStyleUnderline = 4
		FontStyleStrikeout = 8
	End Enum
	
	Public Enum ChartStyle
		CS_PIE
		CS_DONUT
	End Enum
	
	Public Enum ChartOrientation
		CO_Vertical
		CO_Horizontal
	End Enum
	
	Public Enum ucPC_LegendAlign
		LA_LEFT
		LA_TOP
		LA_RIGHT
		LA_BOTTOM
	End Enum
	
	Public Enum LabelsPositions
		LP_Inside
		LP_Outside
		LP_TwoColumns
	End Enum
	
	Private Type tItem
		ItemName As String
		Value As Single
		text As String
		TextWidth As Long
		TextHeight As Long
		ItemColor As Long
		Special As Boolean
		hPath As Long
		LegendRect As RectL
	End Type
	
	Type Chart Extends Control
	Private:
		Dim nScale As Single
		
		Dim m_Title As String
		Dim m_TitleFont As StdFont
		Dim m_TitleForeColor As OLE_COLOR
		Dim m_BackColor As OLE_COLOR
		Dim m_BackColorOpacity As Long
		Dim m_ForeColor As OLE_COLOR
		Dim m_FillOpacity As Long
		Dim m_Border As Boolean
		Dim m_LinesCurve As Boolean
		Dim m_LinesWidth As Long
		Dim m_VerticalLines As Boolean
		Dim m_FillGradient As Boolean
		
		Dim m_HorizontalLines As Boolean
		Dim m_ChartStyle As ChartStyle
		Dim m_ChartOrientation As ChartOrientation
		Dim m_LegendAlign As ucPC_LegendAlign
		Dim m_LegendVisible As Boolean
		Dim m_WordWrap As Boolean
		Dim m_DonutWidth As Single
		Dim m_SeparatorLine As Boolean
		Dim m_SeparatorLineColor As OLE_COLOR
		Dim m_SeparatorLineWidth As Single
		Dim m_LabelsVisible As Boolean
		Dim m_LabelsPositions As LabelsPositions
		Dim m_LabelsFormats As String
		Dim m_BorderColor As OLE_COLOR
		Dim m_BorderRound As Long
		Dim m_Rotation  As Long
		Dim m_CenterCircle As POINTF
		
		Dim m_Item() As tItem
		Dim ItemsCount As Long
		Dim HotItem As Long
		Dim m_PT As POINTL
		Dim m_Left As Long
		Dim m_Top As Long
		
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub GetCenterPie(X As Single, Y As Single)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemClick As Sub(Index As Long)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Chart.bas"
#endif
