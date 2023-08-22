'################################################################################
'#  Canvas.bi                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TCanvas.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'################################################################################

#include once "Graphics.bi"
#include once "Component.bi"

Namespace My.Sys.Drawing
	#define QCanvas(__Ptr__) (*Cast(Canvas Ptr, __Ptr__))
	
	Private Type Rect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	Private Type Point
		X As Long
		Y As Long
	End Type
	
	Private Type Size
		Width As Long
		Height As Long
	End Type
	
	#ifdef __USE_WINAPI__
		Private Type GpLineGradientParameter
			PointFrom  As GpPointF
			PointTo    As GpPointF
			ColorStart As Long
			ColorEnd   As Long
			WrapModes  As WrapMode
		End Type
		
		Private Enum FillStyle
			fsSurface = FLOODFILLSURFACE
			fsBorder  = FLOODFILLBORDER
		End Enum
		
		Private Enum CopyMode
			cmBlackness   = BLACKNESS
			cmDestInvert  = DSTINVERT
			cmMergeCopy   = MERGECOPY
			cmMergePaint  = MERGEPAINT
			cmNotSrcCopy  = NOTSRCCOPY
			cmNotSrcErase = NOTSRCERASE
			cmPatCopy     = PATCOPY
			cmPatInvert   = PATINVERT
			cmPatPaint    = PATPAINT
			cmSecAnd      = SRCAND
			cmSrcCopy     = SRCCOPY
			cmSrcErase    = SRCERASE
			cmSrcInvert   = SRCINVERT
			cmSrcPaint    = SRCPAINT
			cmWithness    = WHITENESS
		End Enum
		
		Private Enum BrushFillMode
			bmOpaque        = OPAQUE
			bmTransparent   = TRANSPARENT
		End Enum
	#else
		Private Enum FillStyle
			fsSurface
			fsBorder
		End Enum
		
		Private Enum CopyMode
			cmBlackness
			cmDestInvert
			cmMergeCopy
			cmMergePaint
			cmNotSrcCopy
			cmNotSrcErase
			cmPatCopy
			cmPatInvert
			cmPatPaint
			cmSecAnd
			cmSrcCopy
			cmSrcErase
			cmSrcInvert
			cmSrcPaint
			cmWithness
		End Enum
		
		Private Enum BrushFillMode
			bmOpaque
			bmTransparent
		End Enum
	#endif
	
	Private Type Canvas Extends My.Sys.Object
	Private:
		ParentControl As My.Sys.ComponentModel.Component Ptr
		Declare Static Sub Font_Create(ByRef Designer As My.Sys.Object, ByRef Sender As Font)
		Declare Static Sub Pen_Create(ByRef Designer As My.Sys.Object, ByRef Sender As Pen)
		Declare Static Sub Brush_Create(ByRef Designer As My.Sys.Object, ByRef Sender As Brush)
		iTemp           As Integer
		FBackColor      As Integer 
		FFillColor      As Integer 
		FFillMode       As BrushFillMode
		FHatchStyle     As HatchStyles
		FFillStyles     As BrushStyles
		FDrawColor      As Integer
		FDrawStyle      As PenStyle
		FDrawWidth      As Integer 
		FScaleWidth     As Long 
		FScaleHeight    As Long
		FBmpWidth       As Long
		FBmpHeight      As Long
		FDoubleBuffer   As Boolean
		imgScaleX       As Double 
		imgScaleY       As Double
		imgOffsetX      As Double 
		imgOffsetY      As Double
		FMoveToX        As Double
		FMoveToY        As Double
	Protected:
		#ifdef __USE_GTK__
			Dim As PangoContext Ptr pcontext
			#ifdef __USE_GTK4__
				Dim As cairo_region_t Ptr cairoRegion
				Dim As GdkDrawingContext Ptr DrawingContext
			#endif
		#elseif defined(__USE_WINAPI__)
			Dim As HDC DC, memDC
			Dim As HBITMAP CompatibleBmp
		#ifdef __FB_64BIT__
			Dim FGdipStartupInput As GdiplusStartupInput  'GDI+ startup info
		#else
			Dim FGdipStartupInput As Gdiplus.GdiplusStartupInput  'GDI+ startup info
		#endif
		
	#endif
	Public:
		HandleSetted         As Boolean
		CreateDoubleBuffered As Boolean
		FillGradient As Boolean
		FillOpacity As Long
		BackColorOpacity As Long
		#ifdef __USE_GTK__
			Handle  As cairo_t Ptr
			Dim As PangoLayout Ptr layout
		#elseif defined(__USE_WINAPI__)
			Handle  As HDC
			GdipToken As ULONG_PTR
			GdipGraphics As GpGraphics Ptr
			GdipBrush As GpBrush Ptr
			GdipPen As GpPen Ptr
			GdipFont As GpFont Ptr
			GpHatchStyles As GpHatchStyle = HatchStyleCross
			GpLineGradientPara As GpLineGradientParameter
		#elseif defined(__USE_JNI__)
			Handle  As jobject
		#endif
		Pen         As My.Sys.Drawing.Pen
		Brush       As My.Sys.Drawing.Brush
		Font        As My.Sys.Drawing.Font
		Clip        As Boolean
		CopyMode    As CopyMode
		Declare Sub UsingGdip(Vaule As Boolean = True)
		Declare Sub GetDevice
		Declare Sub ReleaseDevice
		Declare Sub CreateDoubleBuffer(DrawGraphicBitmap As Boolean = True, CleanBK As Boolean = False)
		Declare Sub TransferDoubleBuffer(ALeft As Long = 0, ATop As Long = 0, AWidth As Long = -1, AHeight As Long = -1)
		Declare Sub DeleteDoubleBuffer
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Width As Integer
		Declare Property Height As Integer
		Declare Property Ctrl As My.Sys.ComponentModel.Component Ptr
		Declare Property Ctrl (Value As My.Sys.ComponentModel.Component Ptr)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property Pixel(xy As Point) As Integer
		Declare Property Pixel(xy As Point, Value As Integer)
		Declare Sub Scale(x As Double, y As Double, x1 As Double, y1 As Double)
		Declare Property ScaleWidth As Integer
		Declare Property ScaleHeight As Integer
		Declare Property DrawWidth As Integer
		Declare Property DrawWidth(Value As Integer)
		Declare Property DrawColor As Integer
		Declare Property DrawColor(Value As Integer)
		Declare Property DrawStyle As PenStyle
		Declare Property DrawStyle(Value As PenStyle)
		Declare Property FillColor As Integer
		Declare Property FillColor(Value As Integer)
		Declare Property FillMode As BrushFillMode
		Declare Property FillMode(Value As BrushFillMode)
		Declare Property HatchStyle As HatchStyles
		Declare Property HatchStyle(Value As HatchStyles)
		Declare Property FillStyles As BrushStyles
		Declare Property FillStyles(Value As BrushStyles)
		Declare Sub Cls(x As Double = 0, y As Double = 0, x1 As Double = 0, y1 As Double = 0)
		Declare Sub MoveTo(x As Double,y As Double)
		Declare Sub LineTo(x As Double,y As Double)
		Declare Sub Line(x As Double, y As Double, x1 As Double, y1 As Double, FillColorBK As Integer = -1, BF As String = "" )
		Declare Sub Rectangle Overload(x As Double, y As Double, x1 As Double, y1 As Double)
		Declare Sub Rectangle(R As Rect)
		Declare Sub Ellipse Overload(x As Double, y As Double, x1 As Double, y1 As Double)
		Declare Sub Ellipse(R As Rect)
		Declare Sub Circle(x As Double, y As Double, Radial As Double, FillColorBK As Integer = -1)
		Declare Sub RoundRect Overload(x As Double, y As Double, x1 As Double, y1 As Double, nWidth As Integer, nHeight As Integer)
		Declare Sub RoundRect(R As Rect, nWidth As Integer, nHeight As Integer)
		Declare Sub Polygon(Points() As Point, Count As Long)
		Declare Sub Pie(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		Declare Sub Arc(x As Double, y As Double, x1 As Double, y1 As Double, xStart As Double, yStart As Double, xEnd As Double = 0, yEnd As Double = 0)
		Declare Sub ArcTo(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		Declare Sub AngleArc(x As Double, y As Double, Radius As Double, StartAngle As Double, SweepAngle As Double)
		Declare Sub Chord(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		Declare Sub Polyline(Points() As Point, Count As Long)
		Declare Sub PolylineTo(Points() As Point, Count As Long)
		Declare Sub PolyBeizer(Points() As Point, Count As Long)
		Declare Sub PolyBeizerTo(Points() As Point, Count As Long)
		Declare Sub SetPixel(x As Double, y As Double, PixelColor As Integer)
		Declare Function GetPixel(x As Double, y As Double) As Integer
		Declare Function Get(x As Double, y As Double, nWidth As Integer, nHeight As Integer, ByRef ImageSource As My.Sys.Drawing.BitmapType) As Any Ptr
		Declare Function Get(x As Double, y As Double, nWidth As Integer, nHeight As Integer, ByVal ImageSource As Any Ptr) As Any Ptr
		Declare Sub TextOut(x As Double, y As Double, ByRef s As WString, FG As Integer = -1, BK As Integer = -1)
		Declare Sub DrawTransparent(x As Double, y As Double, Image As Any Ptr, cTransparentColor As UInteger = 0)
		Declare Sub DrawTransparent(x As Double, y As Double, ByRef Image As My.Sys.Drawing.BitmapType, cTransparentColor As UInteger = 0)
		Declare Sub DrawAlpha(x As Double, y As Double, nWidth As Double = -1, nHeight As Double = -1, ByVal Image As Any Ptr, iSourceAlpha As Integer = 255)
		Declare Sub DrawAlpha(x As Double, y As Double, nWidth As Double = -1, nHeight As Double = -1, ByRef Image As My.Sys.Drawing.BitmapType, iSourceAlpha As Integer = 255)
		Declare Sub Draw(x As Double, y As Double, Image As Any Ptr)
		Declare Sub Draw(x As Double, y As Double, ByRef Image As My.Sys.Drawing.BitmapType)
		Declare Sub Draw(x As Double, y As Double, ByRef Image As My.Sys.Drawing.Icon)
		Declare Sub DrawStretch(x As Double, y As Double, nWidth As Integer, nHeight As Integer, Image As Any Ptr)
		Declare Sub CopyRect(Dest As Rect, Canvas As Canvas, Source As Rect)
		Declare Sub FloodFill(x As Double, y As Double, FillColorBK As Integer = -1, FillStyleBK As FillStyle)
		Declare Sub FillRect(R As Rect, FillColorBK As Integer = -1)
		Declare Sub DrawFocusRect(R As Rect)
		Declare Function TextWidth(ByRef FText As WString) As Integer
		Declare Function TextHeight(ByRef FText As WString) As Integer
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Canvas.bas"
#endif
