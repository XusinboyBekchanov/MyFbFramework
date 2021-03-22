'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2021)                                          #
'#  Based on:                                                                   #
'#   Module Name: ucPieChart                                                    #
'#   Date: 23/06/2020                                                           #
'#   Module Name: ucChartArea                                                   #
'#   Date: 23/06/2020                                                           #
'#   Module Name: ucChartBar                                                    #
'#   Date: 08/08/2020                                                           #
'#   Autor:  Leandro Ascierto                                                   #
'#   Web: www.leandroascierto.com                                               #
'#   Version: 1.0.0                                                             #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"
#include once "DoubleList.bi"
#include once "IntegerList.bi"

Namespace My.Sys.Forms
	#define QChart(__Ptr__) *Cast(Chart Ptr, __Ptr__)
	
	Public Enum TextAlignmentH
		cLeft
		cCenter
		cRight
	End Enum
	
	Private Enum TextAlignmentV
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
		CS_Pie
		CS_Donut
		CS_Area
		CS_GroupedColumn
		CS_StackedBars
		CS_StackedBarsPercent
	End Enum
	
	Public Enum ChartOrientations
		CO_Vertical
		CO_Horizontal
	End Enum
	
	Public Enum LegendAligns
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
	
	Public Enum LabelsAlignments
		LP_TOP
		LP_CENTER
		LP_BOTTOM
		LP_ABOVE
	End Enum
	
	#ifdef __USE_GTK__
		Type RectL
			Left As Long
			Top As Long
			Right As Long
			Bottom As Long
		End Type
		Type RectF
			X As Single
			Y As Single
			Width As Single
			Height As Single
		End Type
		Type POINTL
			x As Long
			y As Long
		End Type
		Type POINTF
			x As Single
			y As Single
		End Type
		Type SizeF
			Width As Single
			Height As Single
		End Type
	#endif
	
	Private Type tItem
		ItemName As UString
		Value As Single
		text As UString
		TextWidth As Long
		TextHeight As Long
		ItemColor As Long
		Special As Boolean
		hPath As Any Ptr
		LegendRect As RectL
	End Type
	
	Private Type tSerie
		SerieName As UString
		TextWidth As Long
		TextHeight As Long
		SerieColor As Long
		Values As DoubleList Ptr
		PT(Any) As POINTL
		Rects(Any) As RectL
		LegendRect As RectL
		CustomColors As IntegerList Ptr
	End Type
	
	Private Const GDIP_OK As Long = &H0
	
	Type Chart Extends Control
	Private:
		Dim nScale As Single
		
		Dim m_Title As UString
		Dim m_TitleFont As My.Sys.Drawing.Font
		Dim m_TitleForeColor As ULong
		Dim m_BackColorOpacity As Long
		Dim m_FillOpacity As Long
		Dim m_Border As Boolean
		Dim m_LinesColor As ULong
		Dim m_LinesCurve As Boolean
		Dim m_LinesWidth As Long
		Dim m_VerticalLines As Boolean
		Dim m_FillGradient As Boolean
		
		Dim m_HorizontalLines As Boolean
		Dim m_ChartStyle As ChartStyles
		Dim m_ChartOrientation As ChartOrientations
		Dim m_LegendAlign As LegendAligns
		Dim m_LegendVisible As Boolean
		Dim m_WordWrap As Boolean
		Dim m_DonutWidth As Single
		Dim m_SeparatorLine As Boolean
		Dim m_SeparatorLineColor As ULong
		Dim m_SeparatorLineWidth As Single
		Dim m_LabelsVisible As Boolean
		Dim m_LabelsPositions As LabelsPositions
		Dim m_LabelsAlignments As LabelsAlignments
		Dim m_LabelsFormats As UString
		Dim m_BorderColor As ULong
		Dim m_BorderRound As Long
		Dim m_Rotation  As Long
		Dim m_CenterCircle As POINTF
		
		Dim m_AxisXVisible As Boolean
		Dim m_AxisYVisible As Boolean
		Dim m_AxisMax As Single
		Dim m_AxisMin As Single
		Dim m_AxisAngle As Single
		Dim m_AxisAlign As TextAlignmentH
		
		Dim m_Item(Any) As tItem
		Dim ItemsCount As Long
		Dim HotItem As Long
		Dim cAxisItem As WStringList Ptr
		Dim m_Serie(Any) As tSerie
		Dim SerieCount As Long
		Dim mHotSerie As Long
		Dim mHotBar As Long
		Dim MarginLeft As Single
		Dim MarginRight As Single
		Dim TopHeader As Single
		Dim Footer As Single
		Dim mHeight As Single
		Dim mWidth As Single
		Dim PtDistance As Single
		Dim AxisDistance As Single
		
		Dim m_PT As POINTL
		Dim m_Left As Long
		Dim m_Top As Long
		Dim m_Width As Long
		Dim m_Height As Long
		Dim m_FontSize As Long
		Dim m_TitleFontSize As Long
		Dim m_SeparatorLineWidth2 As Long
		Dim m_DonutWidth2 As Long
		
		#ifndef __USE_GTK__
			Dim c_lhWnd As hWND
			Dim hGraphics As GpGraphics Ptr
			Dim hd As HDC
		#else
			Dim c_lhWnd As GtkWidget Ptr
			Dim As GdkWindow Ptr win
			Dim As cairo_t Ptr cr
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
		#endif
		Dim tmrMOUSEOVER As TimerComponent
		
		#ifndef __USE_GTK__
			Dim gToken As ULONG_PTR                 'GDI+ instance token
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#else
			Declare Static Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Declare Static Function OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			Declare Static Sub OnSizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		
		Declare Sub Example()
		Declare Sub InitProperties()
		Declare Static Sub tmrMOUSEOVER_Timer_(ByRef Sender As TimerComponent)
		Declare Sub tmrMOUSEOVER_Timer(ByRef Sender As TimerComponent)
		Declare Sub GetTextSize(ByRef text As WString, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal bWordWrap As Boolean, ByRef SZ As SIZEF)
		Declare Sub DrawText(ByRef text As WString, ByVal X As Long, ByVal Y As Long, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal ForeColor As Long, HAlign As TextAlignmentH = 0, VAlign As TextAlignmentV = 0, bWordWrap As Boolean = False, Angle As Single = 0)
		Declare Sub HitTest(X As Single, Y As Single, HitResult As Integer)
		Declare Sub MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Declare Sub MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Declare Function PtInRectL(Rect As RectL, ByVal X As Long, ByVal Y As Long) As Boolean
		Declare Function PtInPath(hPath As Any Ptr, X As Single, Y As Single) As Boolean
		Declare Sub Show()
		Declare Sub Paint()
		#ifndef __USE_GTK__
			Declare Sub ManageGDIToken(ByVal projectHwnd As HWND)
		#endif
		Declare Function zFnAddr(ByVal sDLL As String, ByVal sProc As String) As Long
		Declare Function SafeRange(Value As Long, Min As Long, Max As Long) As Long
		Declare Sub Draw()
		Declare Sub ShowToolTips(BarWidth As Single = 0)
		Declare Sub RoundRect(Rect As RectF, ByVal BackColor As Long, ByVal BorderColor As Long, ByVal Round As Single, bBorder As Boolean = True, BackColorAlpha As Integer = 100, BorderColorAlpha As Integer = 100)
		Declare Function ShiftColor(ByVal clrFirst As Long, ByVal clrSecond As Long, ByVal lAlpha As Long) As Long
		Declare Function IsDarkColor(ByVal Color As Long) As Boolean
		Declare Function GetMax() As Single
		Declare Function GetMin() As Single
	Public:
		Declare Function RGBtoARGB(ByVal RGBColor As ULong, ByVal Opacity As Long) As ULong
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub GetCenterPie(X As Single, Y As Single)
		Declare Property Count() As Long
		Declare Property Special(Index As Long, Value As Boolean)
		Declare Property Special(Index As Long) As Boolean
		Declare Property ItemColor(Index As Long, Value As ULong)
		Declare Property ItemColor(Index As Long) As ULong
		Declare Property LinesColor() As ULong
		Declare Property LinesColor(ByVal New_Value As ULong)
		Declare Property LinesCurve() As Boolean
		Declare Property LinesCurve(ByVal New_Value As Boolean)
		Declare Property LinesWidth() As Long
		Declare Property LinesWidth(ByVal New_Value As Long)
		Declare Property VerticalLines() As Boolean
		Declare Property VerticalLines(ByVal New_Value As Boolean)
		Declare Sub Clear()
		Declare Sub AddItem(ByRef ItemName As WString, Value As Single, ItemColor As Long, Special As Boolean = False)
		Declare Sub AddSerie(ByVal SerieName As String, ByVal SerieColor As Long, Values As DoubleList Ptr, cCustomColors As IntegerList Ptr = 0)
		Declare Sub AddAxisItems(AxisItems As WStringList Ptr, ByVal WordWrap As Boolean = False, AxisAngle As Single = 0, AxisAlign As TextAlignmentH = cCenter)
		Declare Sub UpdateSerie(ByVal Index As Integer, ByVal SerieName As String, ByVal SerieColor As Long, Values As DoubleList Ptr)
		Declare Function SumSerieValues(Index As Long, bPositives As Boolean = False) As Single
		Declare Sub Wait(Interval As Integer)
		Declare Property Title() ByRef As WString
		Declare Property Title(ByRef New_Value As WString)
		Declare Property TitleFont() ByRef As My.Sys.Drawing.Font
		Declare Property TitleFont(ByRef New_Value As My.Sys.Drawing.Font)
		Declare Property TitleForeColor() As ULong
		Declare Property TitleForeColor(ByVal New_Value As ULong)
		Declare Property BackColorOpacity() As Long
		Declare Property BackColorOpacity(ByVal New_Value As Long)
		Declare Property FillOpacity() As Long
		Declare Property FillOpacity(ByVal New_Value As Long)
		Declare Property Border() As Boolean
		Declare Property Border(ByVal New_Value As Boolean)
		Declare Property BorderRound() As Long
		Declare Property BorderRound(ByVal New_Value As Long)
		Declare Property BorderColor() As ULong
		Declare Property BorderColor(ByVal New_Value As ULong)
		Declare Property LabelsFormats() ByRef As WString
		Declare Property LabelsFormats(ByRef New_Value As WString)
		Declare Property LabelsAlignment() As LabelsAlignments
		Declare Property LabelsAlignment(ByVal New_Value As LabelsAlignments)
		Declare Property FillGradient() As Boolean
		Declare Property FillGradient(ByVal New_Value As Boolean)
		Declare Property ChartStyle() As ChartStyles
		Declare Property ChartStyle(ByVal New_Value As ChartStyles)
		Declare Property ChartOrientation() As ChartOrientations
		Declare Property ChartOrientation(ByVal New_Value As ChartOrientations)
		Declare Property LegendAlign() As LegendAligns
		Declare Property LegendAlign(ByVal New_Value As LegendAligns)
		Declare Property LegendVisible() As Boolean
		Declare Property LegendVisible(ByVal New_Value As Boolean)
		Declare Property DonutWidth() As Single
		Declare Property DonutWidth(ByVal New_Value As Single)
		Declare Property SeparatorLine() As Boolean
		Declare Property SeparatorLine(ByVal New_Value As Boolean)
		Declare Property SeparatorLineWidth() As Single
		Declare Property SeparatorLineWidth(ByVal New_Value As Single)
		Declare Property SeparatorLineColor() As ULong
		Declare Property SeparatorLineColor(ByVal New_Value As ULong)
		Declare Property LabelsPosition() As LabelsPositions
		Declare Property LabelsPosition(ByVal New_Value As LabelsPositions)
		Declare Property LabelsVisible() As Boolean
		Declare Property LabelsVisible(ByVal New_Value As Boolean)
		Declare Property Rotation() As Long
		Declare Property Rotation(ByVal New_Value As Long)
		Declare Function GetWindowsDPI() As Double
		Declare Sub Refresh()
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemClick As Sub(Index As Long)
	End Type
	
	Declare Function Round(X As Double, Drob As Integer = 0) As Integer
End Namespace

#ifndef __USE_MAKE__
	#include once "Chart.bas"
#endif
