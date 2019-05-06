'###############################################################################
'#  Canvas.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TCanvas.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#Include Once "Graphics.bi"
#Include Once "Control.bi"

#IfDef __USE_GTK__
    Type Point
    	X As Integer
    	Y As Integer
    End Type
    
    Type Rect
    	Left As Integer
    	Top As Integer
    	Right As Integer
    	Bottom As Integer
    End Type
#EndIf

Namespace My.Sys.Drawing
	#DEFINE QCanvas(__Ptr__)  *Cast(Canvas Ptr,__Ptr__)

	#IfDef __USE_GTK__
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
		
	#Else
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
	#EndIf
	
	Type Canvas Extends My.Sys.Object
		Private:
			ParentControl As My.Sys.Forms.Control Ptr
			Declare Sub GetDevice
			Declare Sub ReleaseDevice
			iTemp As Integer
		Public:
			#IfNDef __USE_GTK__
				Handle        As HDC
			#EndIf
			Pen           As My.Sys.Drawing.Pen
			Brush         As My.Sys.Drawing.Brush
			Font          As My.Sys.Drawing.Font
			Clip          As Boolean
			CopyMode      As CopyMode
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Declare Property Width As Integer
			Declare Property Height As Integer
			Declare Property Ctrl As My.Sys.Forms.Control Ptr
			Declare Property Ctrl (Value As My.Sys.Forms.Control Ptr)
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

    Function Canvas.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "pen": Return @Pen
        Case "brush": Return @Brush
        Case "font": Return @Font
        Case "clip": Return @Clip
        Case "copymode": Return @CopyMode
        Case "height": iTemp = ParentControl->Height: Return @iTemp
        Case "width": iTemp = ParentControl->Width: Return @iTemp
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Canvas.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "clip": This.Clip = QBoolean(Value)
        Case "copymode": This.CopyMode = QInteger(Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function

	Property Canvas.Width As Integer
		If ParentControl Then Return ParentControl->Width
	End Property

	Property Canvas.Height As Integer
		If ParentControl Then Return ParentControl->Height
	End Property

	Property Canvas.Ctrl As My.Sys.Forms.Control Ptr
		Return ParentControl
	End Property

	Property Canvas.Ctrl(Value As My.Sys.Forms.Control Ptr)
		ParentControl = Value
		If ParentControl Then 
			'ParentControl->Canvas = @This
			Brush.Color = Ctrl->BackColor
		End If
	End Property

	Property Canvas.Pixel(xy As Point) As Integer
		GetDevice
		#IfNDef __USE_GTK__
			Return .GetPixel(Handle,xy.x,xy.y)
		#Else
			Return 0
		#EndIf
		ReleaseDevice
	End Property

	Property Canvas.Pixel(xy As Point, Value As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.SetPixel(Handle,xy.x,xy.y,Value)
		#EndIf
		ReleaseDevice
	End Property

	Sub Canvas.GetDevice
		If ParentControl Then
			#IfNDef __USE_GTK__
			   If ParentControl->Handle Then 
				   If Clip Then
					  Handle = GetDcEx(ParentControl->Handle,0,DCX_PARENTCLIP OR DCX_CACHE)
				   Else
					  Handle = GetDc(ParentControl->Handle)
				   End If
				   SelectObject(Handle,Font.Handle)
				   SelectObject(Handle,Pen.Handle)
				   SelectObject(Handle,Brush.Handle)
				   SetROP2 Handle,Pen.Mode
			   End If
			 #EndIf
		End If
	End Sub

	Sub Canvas.ReleaseDevice
		#IfNDef __USE_GTK__
			If ParentControl Then If Handle Then ReleaseDc ParentControl->Handle,Handle
		#EndIf
	End Sub

	Sub Canvas.MoveTo(x As Integer,y As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.MoveToEx Handle,x,y,0
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.LineTo(x As Integer,y As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.LineTo Handle,x,y
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Line(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.MoveToEx Handle,x,y,0
			.LineTo Handle,x1,y1
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Rectangle Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.Rectangle Handle,x,y,x1,y1
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Rectangle(R As Rect)
		GetDevice
		#IfNDef __USE_GTK__
			.Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Ellipse Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.Ellipse Handle,x,y,x1,y1
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Ellipse(R As Rect)
		GetDevice
		#IfNDef __USE_GTK__
			.Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.RoundRect Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nWidth As Integer,nHeight As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.RoundRect Handle,x,y,x1,y1,nWidth,nHeight
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Polygon(Points As Point Ptr,Count As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.Polygon Handle, Points, Count
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.RoundRect(R As Rect,nWidth As Integer,nHeight As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.RoundRect Handle,R.Left,R.Top,R.Right,R.Bottom,nWidth,nHeight
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Chord(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.Chord(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Pie(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
	   GetDevice
	   #IfNDef __USE_GTK__
		.Pie(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
	   #EndIf
	   ReleaseDevice
	End Sub

	Sub Canvas.Arc(x As Integer,y As Integer,x1 As Integer,y1 As Integer,xStart As Integer, yStart As Integer,xEnd As Integer,yEnd As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.Arc(Handle,x,y,x1,y1,xStart, yStart,xEnd,yEnd)
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.ArcTo(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.ArcTo Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.AngleArc(x As Integer,y As Integer,Radius As Integer,StartAngle As Single,SweepAngle As Single)
		GetDevice
		#IfNDef __USE_GTK__
			.AngleArc Handle,x,y,Radius,StartAngle,SweepAngle
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.Polyline(Points As Point Ptr,Count As Integer)
	   GetDevice
	   #IfNDef __USE_GTK__
			.Polyline Handle,Points,Count
	   #EndIf
	   ReleaseDevice
	End Sub

	Sub Canvas.PolylineTo(Points As Point Ptr,Count As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.PolylineTo Handle,Points,Count
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.PolyBeizer(Points As Point Ptr,Count As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.PolyBezier Handle,Points,Count
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.PolyBeizerTo(Points As Point Ptr,Count As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.PolyBezierTo Handle,Points,Count
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.SetPixel(x As Integer,y As Integer,PixelColor As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			.SetPixel Handle,x,y,PixelColor
		#EndIf
		ReleaseDevice
	End Sub

	Function Canvas.GetPixel(x As Integer,y As Integer) As Integer
		GetDevice
		#IfNDef __USE_GTK__
			Return .GetPixel(Handle,x,y)
		#Else
			Return 0
		#ENDiF
		ReleaseDevice
	End Function

	Sub Canvas.TextOut(x As Integer,y As Integer,ByRef s As WString,FG As Integer,BK As Integer)
		GetDevice
		#IfNDef __USE_GTK__
			If BK = -1 then
			   SetBKMode(Handle,TRANSPARENT)
			   SetTextColor(Handle,FG)
			   .TextOut(Handle,X,Y,@s,Len(s))
			   SetBKMode(Handle,OPAQUE) 
			Else
			   SetBKColor(Handle,BK) 
			   SetTextColor(Handle,FG)
			   .TextOut(Handle,X,Y,@s,Len(s))
			End If
		#ENdIf
		ReleaseDevice
	End Sub

	Sub Canvas.Draw(x As Integer,y As Integer,Image As Any Ptr)
		 GetDevice
		 ReleaseDevice
	End Sub

	Sub Canvas.StretchDraw(x As Integer,y As Integer,nWidth As Integer,nHeight As Integer,Image As Any Ptr)
		GetDevice
		ReleaseDevice
	End Sub

	Sub Canvas.CopyRect(Dest As Rect,Canvas As Canvas,Source As Rect)
		GetDevice
		ReleaseDevice
	End Sub

	Sub Canvas.FloodFill(x As Integer,y As Integer,FillColor As Integer,FillStyle As FillStyle)
		GetDevice
		#IfNDef __USE_GTK__
			.ExtFloodFill Handle,x,y,FillColor,FillStyle
		#EndIf
		ReleaseDevice
	End Sub

	Sub Canvas.FillRect(R As Rect,FillColor As Integer = -1)
		#IfNDef __USE_GTK__
			Static As HBRUSH B
			GetDevice
			If B Then DeleteObject B
			If FillColor <> -1 Then 
			   B = CreateSolidBrush(FillColor)
			   .FillRect Handle,@R,B
			Else
			   .FillRect Handle,@R,Brush.Handle 
			End If
		#ENdIf
		ReleaseDevice
	End Sub

	Sub Canvas.DrawFocusRect(R As Rect)
		GetDevice
		#IfNDef __USE_GTK__
			.DrawFocusRect Handle,@R
		#EndIf
		ReleaseDevice
	End Sub

	Function Canvas.TextWidth(ByRef FText As WString) As Integer
		#IfNDef __USE_GTK__
			Dim Sz As SIZE
			GetDevice
			GetTextExtentPoint32(Handle,@FText,Len(FText),@Sz)
			ReleaseDevice
			Return Sz.cX
		#Else
			Return 0
		#EndIf
	End Function

	Function Canvas.TextHeight(ByRef FText As WString) As Integer
		#IfNDef __USE_GTK__
			Dim Sz As SIZE
			GetDevice
			GetTextExtentPoint32(Handle,@FText,Len(FText),@Sz)
			ReleaseDevice
			Return Sz.cY
		#Else
			Return 0
		#EndIf
	End Function

	Operator Canvas.Cast As Any Ptr
		Return @This
	End Operator

	Constructor Canvas
		Clip = False
		WLet FClassName, "Canvas"
	End Constructor

	Destructor Canvas
		#IfNDef __USE_GTK__ 
			If Handle Then ReleaseDevice
		#EndIf
	End Destructor
End Namespace
