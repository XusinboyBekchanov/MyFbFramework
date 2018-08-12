'###############################################################################
'#  Canvas.bi                                                                  #
'#  This file is part of MyFBFramework				                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Graphics.bi"
#Include Once "Control.bi"

Namespace My.Sys.Drawing
	#DEFINE QCanvas(__Ptr__)  *Cast(Canvas Ptr,__Ptr__)

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

	Type Canvas Extends My.Sys.Object
		Private:
			ParentControl As My.Sys.Forms.Control Ptr
			Declare Sub GetDevice
			Declare Sub ReleaseDevice
		Public:
			Handle        As HDC
			Pen           As My.Sys.Drawing.Pen
			Brush         As My.Sys.Drawing.Brush
			Font          As My.Sys.Drawing.Font
			Clip          As Boolean
			CopyMode      As CopyMode
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
			Declare Sub RoundRect(R As Rect,nWidth As Integer,nHeight As Integer)
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
			Declare Sub CopyRect(Dest As Rect,Canvas As Canvas,Source As Rect)
			Declare Sub FloodFill(x As Integer,y As Integer,FillColor As Integer,FillStyle As FillStyle)
			Declare Sub FillRect(R As Rect,FillColor As Integer = -1)
			Declare Sub DrawFocusRect(R As Rect)
			Declare Function TextWidth(ByRef FText As WString) As Integer
			Declare Function TextHeight(ByRef FText As WString) As Integer
			Declare Operator Cast As Any Ptr
			Declare Constructor
			Declare Destructor
	End Type

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
		Property = .GetPixel(Handle,xy.x,xy.y)
		ReleaseDevice
	End Property

	Property Canvas.Pixel(xy As Point, Value As Integer)
		GetDevice
		.SetPixel(Handle,xy.x,xy.y,Value)
		ReleaseDevice
	End Property

	Sub Canvas.GetDevice
		If ParentControl Then
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
		End If
	End Sub

	Sub Canvas.ReleaseDevice
		If ParentControl Then If Handle Then ReleaseDc ParentControl->Handle,Handle
	End Sub

	Sub Canvas.MoveTo(x As Integer,y As Integer)
		GetDevice
		.MoveToEx Handle,x,y,0
		ReleaseDevice
	End Sub

	Sub Canvas.LineTo(x As Integer,y As Integer)
		GetDevice
		.LineTo Handle,x,y
		ReleaseDevice
	End Sub

	Sub Canvas.Line(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		.MoveToEx Handle,x,y,0
		.LineTo Handle,x1,y1
		ReleaseDevice
	End Sub

	Sub Canvas.Rectangle Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		.Rectangle Handle,x,y,x1,y1
		ReleaseDevice
	End Sub

	Sub Canvas.Rectangle(R As Rect)
		GetDevice
		.Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
		ReleaseDevice
	End Sub

	Sub Canvas.Ellipse Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer)
		GetDevice
		.Ellipse Handle,x,y,x1,y1
		ReleaseDevice
	End Sub

	Sub Canvas.Ellipse(R As Rect)
		GetDevice
		.Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
		ReleaseDevice
	End Sub

	Sub Canvas.RoundRect Overload(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nWidth As Integer,nHeight As Integer)
		GetDevice
		.RoundRect Handle,x,y,x1,y1,nWidth,nHeight
		ReleaseDevice
	End Sub

	Sub Canvas.Polygon(Points As Point Ptr,Count As Integer)
		GetDevice
		.Polygon Handle, Points, Count
		ReleaseDevice
	End Sub

	Sub Canvas.RoundRect(R As Rect,nWidth As Integer,nHeight As Integer)
		GetDevice
		.RoundRect Handle,R.Left,R.Top,R.Right,R.Bottom,nWidth,nHeight
		ReleaseDevice
	End Sub

	Sub Canvas.Chord(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		GetDevice
		.Chord(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
		ReleaseDevice
	End Sub

	Sub Canvas.Pie(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
	   GetDevice
	   .Pie(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
	   ReleaseDevice
	End Sub

	Sub Canvas.Arc(x As Integer,y As Integer,x1 As Integer,y1 As Integer,xStart As Integer, yStart As Integer,xEnd As Integer,yEnd As Integer)
		GetDevice
		.Arc(Handle,x,y,x1,y1,xStart, yStart,xEnd,yEnd)
		ReleaseDevice
	End Sub

	Sub Canvas.ArcTo(x As Integer,y As Integer,x1 As Integer,y1 As Integer,nXRadial1 As Integer,nYRadial1 As Integer,nXRadial2 As Integer,nYRadial2 As Integer)
		GetDevice
		.ArcTo Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2
		ReleaseDevice
	End Sub

	Sub Canvas.AngleArc(x As Integer,y As Integer,Radius As Integer,StartAngle As Single,SweepAngle As Single)
		GetDevice
		.AngleArc Handle,x,y,Radius,StartAngle,SweepAngle
		ReleaseDevice
	End Sub

	Sub Canvas.Polyline(Points As Point Ptr,Count As Integer)
	   GetDevice
	   .Polyline Handle,Points,Count
	   ReleaseDevice
	End Sub

	Sub Canvas.PolylineTo(Points As Point Ptr,Count As Integer)
		GetDevice
		.PolylineTo Handle,Points,Count
		ReleaseDevice
	End Sub

	Sub Canvas.PolyBeizer(Points As Point Ptr,Count As Integer)
		GetDevice
		.PolyBezier Handle,Points,Count
		ReleaseDevice
	End Sub

	Sub Canvas.PolyBeizerTo(Points As Point Ptr,Count As Integer)
		GetDevice
		.PolyBezierTo Handle,Points,Count
		ReleaseDevice
	End Sub

	Sub Canvas.SetPixel(x As Integer,y As Integer,PixelColor As Integer)
		GetDevice
		.SetPixel Handle,x,y,PixelColor
		ReleaseDevice
	End Sub

	Function Canvas.GetPixel(x As Integer,y As Integer) As Integer
		GetDevice
		Return .GetPixel(Handle,x,y)
		ReleaseDevice
	End Function

	Sub Canvas.TextOut(x As Integer,y As Integer,ByRef s As WString,FG As Integer,BK As Integer)
		GetDevice
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
		.ExtFloodFill Handle,x,y,FillColor,FillStyle
		ReleaseDevice
	End Sub

	Sub Canvas.FillRect(R As Rect,FillColor As Integer = -1)
		Static As HBRUSH B
		GetDevice
		If B Then DeleteObject B
		If FillColor <> -1 Then 
		   B = CreateSolidBrush(FillColor)
		   .FillRect Handle,@R,B
		Else
		   .FillRect Handle,@R,Brush.Handle 
		End If
		ReleaseDevice
	End Sub

	Sub Canvas.DrawFocusRect(R As Rect)
		GetDevice
		.DrawFocusRect Handle,@R
		ReleaseDevice
	End Sub

	Function Canvas.TextWidth(ByRef FText As WString) As Integer
		Dim Sz As SIZE
		GetDevice
		GetTextExtentPoint32(Handle,@FText,Len(FText),@Sz)
		ReleaseDevice
		Return Sz.cX
	End Function

	Function Canvas.TextHeight(ByRef FText As WString) As Integer
		Dim Sz As SIZE
		GetDevice
		GetTextExtentPoint32(Handle,@FText,Len(FText),@Sz)
		ReleaseDevice
		Return Sz.cY
	End Function

	Operator Canvas.Cast As Any Ptr
		Return @This
	End Operator

	Constructor Canvas
		Clip = False
	End Constructor

	Destructor Canvas
		If Handle Then ReleaseDevice
	End Destructor
End Namespace
