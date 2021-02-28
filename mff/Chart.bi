'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019)                                     #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QChart(__Ptr__) *Cast(Chart Ptr, __Ptr__)
	
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
	
	Public Enum ChartStyles
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
	
	#ifdef __USE_GTK__
		Type RectL
			Left As Long
			Top As Long
			Right As Long
			Bottom As Long
		End Type
		Type POINTL
			x As Long
			y As Long
		End Type
		Type POINTF
			x As Single
			y As Single
		End Type
		#define OLE_COLOR Integer
	#endif
	
	Private Type tItem
		ItemName As String
		Value As Single
		text As String
		TextWidth As Long
		TextHeight As Long
		ItemColor As Long
		Special As Boolean
		hPath As Any Ptr
		LegendRect As RectL
	End Type
	
	Private Const GDIP_OK As Long = &H0
	
	Type Chart Extends Control
	Private:
		Dim nScale As Single
		
		Dim m_Title As UString
		Dim m_TitleFont As My.Sys.Drawing.Font
		Dim m_TitleForeColor As OLE_COLOR
		Dim m_BackColorOpacity As Long
		Dim m_FillOpacity As Long
		Dim m_Border As Boolean
		Dim m_LinesCurve As Boolean
		Dim m_LinesWidth As Long
		Dim m_VerticalLines As Boolean
		Dim m_FillGradient As Boolean
		
		Dim m_HorizontalLines As Boolean
		Dim m_ChartStyle As ChartStyles
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
		
		Dim m_Item(Any) As tItem
		Dim ItemsCount As Long
		Dim HotItem As Long
		Dim m_PT As POINTL
		Dim m_Left As Long
		Dim m_Top As Long
		
		#ifndef __USE_GTK__
			Dim c_lhWnd As hWND
		#else
			Dim c_lhWnd As GtkWidget Ptr
		#endif
		Dim tmrMOUSEOVER As TimerComponent
		
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		
		Declare Sub Example()
		Declare Sub InitProperties()
		Declare Static Sub tmrMOUSEOVER_Timer_(ByRef Sender As TimerComponent)
		Declare Sub tmrMOUSEOVER_Timer(ByRef Sender As TimerComponent)
		#ifndef __USE_GTK__
			Declare Sub GetTextSize(ByVal hGraphics As GpGraphics Ptr, ByRef text As WString, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal bWordWrap As Boolean, ByRef SZ As SIZEF)
			Declare Sub DrawText(ByVal hGraphics As GpGraphics Ptr, ByRef text As WString, ByVal X As Long, ByVal Y As Long, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal ForeColor As Long, HAlign As CaptionAlignmentH = 0, VAlign As CaptionAlignmentV = 0, bWordWrap As Boolean = False)
		#endif
		Declare Sub HitTest(X As Single, Y As Single, HitResult As Integer)
		Declare Sub MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Declare Sub MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Declare Function PtInRectL(Rect As RectL, ByVal X As Single, ByVal Y As Single) As Boolean
		Declare Sub Paint()
		Declare Sub Show()
		#ifndef __USE_GTK__
			Declare Function ManageGDIToken(ByVal projectHwnd As HWND) As HWND
		#endif
		Declare Function zFnAddr(ByVal sDLL As String, ByVal sProc As String) As Long
		Declare Function SafeRange(Value As Long, Min As Long, Max As Long) As Long
		Declare Sub Draw()
		#ifndef __USE_GTK__
			Declare Sub ShowToolTips(hGraphics As GpGraphics Ptr)
			Declare Sub RoundRect(ByVal hGraphics As GpGraphics Ptr, Rect As RectF, ByVal BackColor As Long, ByVal BorderColor As Long, ByVal Round As Single, bBorder As Boolean = True)
		#endif
		Declare Function ShiftColor(ByVal clrFirst As Long, ByVal clrSecond As Long, ByVal lAlpha As Long) As Long
		Declare Function IsDarkColor(ByVal Color As Long) As Boolean
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub GetCenterPie(X As Single, Y As Single)
		Declare Property Count() As Long
		Declare Property Special(Index As Long, Value As Boolean)
		Declare Property Special(Index As Long) As Boolean
		Declare Property ItemColor(Index As Long, Value As OLE_COLOR)
		Declare Property ItemColor(Index As Long) As OLE_COLOR
		Declare Sub Clear()
		Declare Sub AddItem(ByRef ItemName As WString, Value As Single, ItemColor As Long, Special As Boolean = False)
		Declare Property Title() ByRef As WString
		Declare Property Title(ByRef New_Value As WString)
		Declare Property TitleFont() As My.Sys.Drawing.Font
		Declare Property TitleFont(ByRef New_Value As My.Sys.Drawing.Font)
		Declare Property TitleForeColor() As OLE_COLOR
		Declare Property TitleForeColor(ByVal New_Value As OLE_COLOR)
		Declare Property BackColorOpacity() As Long
		Declare Property BackColorOpacity(ByVal New_Value As Long)
		Declare Property FillOpacity() As Long
		Declare Property FillOpacity(ByVal New_Value As Long)
		Declare Property Border() As Boolean
		Declare Property Border(ByVal New_Value As Boolean)
		Declare Property BorderRound() As Long
		Declare Property BorderRound(ByVal New_Value As Long)
		Declare Property BorderColor() As OLE_COLOR
		Declare Property BorderColor(ByVal New_Value As OLE_COLOR)
		Declare Property LabelsFormats() As String
		Declare Property LabelsFormats(ByVal New_Value As String)
		Declare Property FillGradient() As Boolean
		Declare Property FillGradient(ByVal New_Value As Boolean)
		Declare Property ChartStyle() As ChartStyles
		Declare Property ChartStyle(ByVal New_Value As ChartStyles)
		Declare Property LegendAlign() As ucPC_LegendAlign
		Declare Property LegendAlign(ByVal New_Value As ucPC_LegendAlign)
		Declare Property LegendVisible() As Boolean
		Declare Property LegendVisible(ByVal New_Value As Boolean)
		Declare Property DonutWidth() As Single
		Declare Property DonutWidth(ByVal New_Value As Single)
		Declare Property SeparatorLine() As Boolean
		Declare Property SeparatorLine(ByVal New_Value As Boolean)
		Declare Property SeparatorLineWidth() As Single
		Declare Property SeparatorLineWidth(ByVal New_Value As Single)
		Declare Property SeparatorLineColor() As OLE_COLOR
		Declare Property SeparatorLineColor(ByVal New_Value As OLE_COLOR)
		Declare Property LabelsPosition() As LabelsPositions
		Declare Property LabelsPosition(ByVal New_Value As LabelsPositions)
		Declare Property LabelsVisible() As Boolean
		Declare Property LabelsVisible(ByVal New_Value As Boolean)
		Declare Property Rotation() As Long
		Declare Property Rotation(ByVal New_Value As Long)
		Declare Function GetWindowsDPI() As Double
		Declare Sub Refresh()
		Declare Function RGBtoARGB(ByVal RGBColor As Long, ByVal Opacity As Long) As Long
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemClick As Sub(Index As Long)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Chart.bas"
#endif
