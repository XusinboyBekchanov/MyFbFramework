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
	#define QCanvas(__Ptr__)  *Cast(Canvas Ptr,__Ptr__)
	
	#ifdef __USE_GTK__
		Enum FillStyle
			fsSurface
			fsBorder
		End Enum
		
		Enum CopyMode
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
		
	#else
		Enum FillStyle
			fsSurface = FLOODFILLSURFACE
			fsBorder  = FLOODFILLBORDER
		End Enum
		
		Enum CopyMode
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
	#endif
	
	Type Canvas Extends My.Sys.Object
	Private:
		ParentControl As My.Sys.ComponentModel.Component Ptr
		Declare Sub GetDevice
		Declare Sub ReleaseDevice
		iTemp As Integer
	Public:
		HandleSetted As Boolean
		#ifdef __USE_GTK__
			Handle  As cairo_t Ptr
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
		#else
			Handle  As HDC
		#endif
		Pen         As My.Sys.Drawing.Pen
		Brush       As My.Sys.Drawing.Brush
		Font        As My.Sys.Drawing.Font
		Clip        As Boolean
		CopyMode    As CopyMode
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Width As Integer
		Declare Property Height As Integer
		Declare Property Ctrl As My.Sys.ComponentModel.Component Ptr
		Declare Property Ctrl (Value As My.Sys.ComponentModel.Component Ptr)
		Declare Property Pixel(xy As Point) As Integer
		Declare Property Pixel(xy As Point,Value As Integer)
		Declare Sub MoveTo(x As Integer,y As Integer)
		Declare Sub LineTo(x As Integer,y As Integer)
		Declare Sub Line(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		Declare Sub Rectangle Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		Declare Sub Rectangle(R As Rect)
		Declare Sub Ellipse Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		Declare Sub Ellipse(R As Rect)
		Declare Sub RoundRect Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nWidth As Integer,nHeight As Integer)
		Declare Sub RoundRect(R As Rect, nWidth As Integer, nHeight As Integer)
		Declare Sub Polygon(Points As Point Ptr,Count As Integer)
		Declare Sub Pie(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		Declare Sub Arc(x As Integer,y As Integer,x1 As Integer,y1 As Integer,xStart As Integer, yStart As Integer,xEnd As Integer,yEnd As Integer)
		Declare Sub ArcTo(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		Declare Sub AngleArc(x As Integer,y As Integer,Radius As Integer,StartAngle As Single,SweepAngle As Single)
		Declare Sub Chord(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		Declare Sub Polyline(Points As Point Ptr,Count As Integer)
		Declare Sub PolylineTo(Points As Point Ptr,Count As Integer)
		Declare Sub PolyBeizer(Points As Point Ptr,Count As Integer)
		Declare Sub PolyBeizerTo(Points As Point Ptr,Count As Integer)
		Declare Sub SetPixel(x As Integer,y As Integer,PixelColor As Integer)
		Declare Function GetPixel(x As Integer,y As Integer) As Integer
		Declare Sub TextOut(x As Integer,y As Integer,ByRef s As WString,FG As Integer,BK As Integer)
		Declare Sub Draw(x As Integer,y As Integer,Image As Any Ptr)
		Declare Sub StretchDraw(x As Integer,y As Integer,nWidth As Integer,nHeight As Integer,Image As Any Ptr)
		Declare Sub CopyRect(Dest As Rect, Canvas As Canvas, Source As Rect)
		Declare Sub FloodFill(x As Integer,y As Integer,FillColor As Integer,FillStyle As FillStyle)
		Declare Sub FillRect(R As Rect, FillColor As Integer = -1)
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
