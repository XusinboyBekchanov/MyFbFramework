'################################################################################
'#  BitmapType.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TBitmap.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019), Liu XiaLin (2020)                        #
'################################################################################

#include once "Bitmap.bi"

Namespace My.Sys.Drawing
	Property BitmapType.Width As Integer
		Return FWidth
	End Property
	
	Property BitmapType.Width(Value As Integer)
		FWidth = Value
		If Changed Then Changed(This)
	End Property
	
	Property BitmapType.Height As Integer
		Return FHeight
	End Property
	
	Property BitmapType.Height(Value As Integer)
		FHeight = Value
		If Changed Then Changed(This)
	End Property
	
	Property BitmapType.Transparency As Boolean
		Return FTransparent
	End Property
	
	Property BitmapType.Transparency(Value As Boolean)
		FTransparent = Value
	End Property
	
	Sub BitmapType.LoadFromFile(ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0)
		#ifdef __USE_GTK__
			Dim As GError Ptr gerr
			If cxDesired = 0 AndAlso cyDesired = 0 Then
				Handle = gdk_pixbuf_new_from_file(ToUTF8(File), @gerr)
			Else
				Handle = gdk_pixbuf_new_from_file_at_size(ToUTF8(File), cxDesired, cyDesired, @gerr)
			End If
		#else
			Dim As BITMAP BMP
			Dim As HDC MemDC
			If Handle Then DeleteObject Handle
			Handle = LoadImage(0,File,IMAGE_BITMAP,cxDesired,cyDesired,LR_LOADFROMFILE Or LR_LOADMAP3DCOLORS Or FLoadFlag(Abs_(FTransparent)))
			GetObject(Handle,SizeOf(BMP),@BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
	End Sub
	
	Sub BitmapType.SaveToFile(ByRef File As WString)
		#ifndef __USE_GTK__
			Type RGB3 Field = 1
				G As Byte
				B As Byte
				R As Byte
			End Type
			Type BitmapStruct Field = 1
				Identifier      As Word
				FileSize        As Dword
				Reserved0       As Dword
				bmpDataOffset   As Dword
				bmpHeaderSize   As Dword
				bmpWidth        As Dword
				bmpHeight       As Dword
				Planes          As Word
				BitsPerPixel    As Word
				Compression     As Dword
				bmpDataSize     As Dword
				HResolution     As Dword
				VResolution     As Dword
				Colors          As Dword
				ImportantColors As Dword
			End Type
			Static As BitmapStruct BM
			Dim As Integer F,x,y,Clr,Count = 0
			F = FreeFile
			ReDim PixelData(FWidth * FHeight - 1) As RGB3
			For y = FHeight-1 To 0 Step -1
				For x = 0 To FWidth - 1
					Clr = GetPixel(FDevice,x,y)
					PixelData(Count).G = GetGreen(Clr)
					PixelData(Count).R = GetRed(Clr)
					PixelData(Count).B = GetBlue(Clr)
					Count += 1
				Next x
			Next y
			BM.Identifier      = 66 + 77 * 256
			BM.Reserved0       = 0
			BM.bmpDataOffset   = 54
			BM.bmpHeaderSize   = 40
			BM.Planes          = 1
			BM.BitsPerPixel    = 24
			BM.Compression     = 0
			BM.HResolution     = 0
			BM.VResolution     = 0
			BM.Colors          = 0
			BM.ImportantColors = 0
			BM.bmpWidth        = FWidth
			BM.bmpHeight       = FHeight
			BM.bmpDataSize     = FWidth * FHeight * 3
			BM.FileSize        = BM.bmpDataOffset + BM.bmpDataSize
			Open File For Binary Access Write As #F
			Put #F,,BM
			Put #F,,PixelData()
			Close #F
		#endif
	End Sub
	
	#ifdef __USE_GTK__
		Sub BitmapType.LoadFromResourceName(ResName As String, ModuleHandle As Integer = 0, cxDesired As Integer = 0, cyDesired As Integer = 0)
	#else
		Sub BitmapType.LoadFromResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL), cxDesired As Integer = 0, cyDesired As Integer = 0)
	#endif
		#ifdef __USE_GTK__
			Dim As GError Ptr gerr
			Handle = gdk_pixbuf_new_from_resource(ToUTF8(ResName), @gerr)
		#else
			Dim As BITMAP BMP
			Handle = LoadImage(ModuleHandle,ResName,IMAGE_BITMAP,cxDesired,cyDesired,LR_COPYFROMRESOURCE Or FLoadFlag(Abs_(FTransparent)))
			GetObject(Handle,SizeOf(BMP),@BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
	End Sub
	
	#ifdef __USE_GTK__
		Sub BitmapType.LoadFromPNGResourceName(ResName As String)
	#else
		Sub BitmapType.LoadFromPNGResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL))
	#endif
		#ifdef __USE_GTK__
			Dim As GError Ptr gerr
			Handle = gdk_pixbuf_new_from_resource(ToUTF8(ResName), @gerr)
		#else
			Dim As BITMAP BMP
			Dim As HRSRC hPicture = FindResourceW(ModuleHandle, ResName, "PNG")
			Dim As HRSRC hPictureData
			Dim As Unsigned Long dwSize = SizeOfResource(ModuleHandle, hPicture)
			Dim As HGLOBAL hGlobal = NULL
			If hPicture = 0 Then Return
			hPictureData = LockResource(LoadResource(ModuleHandle, hPicture))
			If hPictureData = 0 Then Return
			hGlobal = GlobalAlloc(GMEM_MOVEABLE, dwSize)
			If hGlobal = 0 Then Return
			' Lock the memory
			Dim As LPVOID pData = GlobalLock(hGlobal)
			If pData = 0 Then
				GlobalFree(hGlobal)
				Return
			End If
			' Initialize Gdiplus
			Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
			StartupInput.GdiplusVersion = 1
			GdiplusStartup(@token, @StartupInput, NULL)
			' Copy the image from the binary string file to global memory
			CopyMemory(pData, hPictureData, dwSize)
			Dim As IStream Ptr pngstream = NULL
			If SUCCEEDED(CreateStreamOnHGlobal(hGlobal, False, @pngstream)) Then
				If pngstream Then
					'Dim As gdiplus.Color clr
					Dim pImage As GpImage Ptr ', hImage As HICON
					' Create a bitmap from the data contained in the stream
					GdipCreateBitmapFromStream(pngstream, Cast(GpBitmap Ptr Ptr, @pImage))
					' Create icon from image
					GdipCreateHBitmapFromBitmap(Cast(GpBitmap Ptr, pImage), @Handle, 0)
					' Free the image
					If pImage Then GdipDisposeImage pImage
					pngstream->lpVtbl->Release(pngstream)
				End If
			End If
			' Unlock the memory
			GlobalUnlock pData
			' Free the memory
			GlobalFree hGlobal
			' Shutdown Gdiplus
			GdiplusShutdown token
			GetObject(Handle,SizeOf(BMP),@BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
	End Sub
	
	'	Function BitmapType.FromResourceName(ResName As String, cxDesired As Integer = 0, cyDesired As Integer = 0) As BitmapType Ptr
	'		Dim As BitmapType bm
	'		bm.LoadFromResourceName(ResName,,cxDesired,cyDesired)
	'		Return @bm
	'	End Function
	
	Sub BitmapType.LoadFromResourceID(ResID As Integer, cxDesired As Integer = 0, cyDesired As Integer = 0)
		#ifndef __USE_GTK__
			Dim As BITMAP BMP
			Handle = LoadImage(GetModuleHandle(NULL),MAKEINTRESOURCE(ResID),IMAGE_BITMAP,cxDesired,cyDesired,LR_COPYFROMRESOURCE Or FLoadFlag(Abs_(FTransparent)))
			GetObject(Handle,SizeOf(BMP),@BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
	End Sub
	
	Sub BitmapType.Create
		#ifndef __USE_GTK__
			Dim rc As Rect
			Dim As HDC Dc
			If Handle Then DeleteObject Handle
			Dc = GetDC(0)
			FDevice = CreateCompatibleDC(Dc)
			ReleaseDC 0,Dc
			rc.Left = 0
			rc.Top = 0
			rc.Right = FWidth
			rc.Bottom = FHeight
			Handle = CreateCompatibleBitmap(FDevice,FWidth,FHeight)
			SelectObject FDevice,Handle
			FillRect(FDevice, @rc, Brush.Handle)
		#endif
		If Changed Then Changed(This)
	End Sub
	
	Sub BitmapType.Clear
		#ifndef __USE_GTK__
			Dim rc As RECT
			rc.Left = 0
			rc.Top = 0
			rc.Right = FWidth
			rc.Bottom = FHeight
			FillRect FDevice, @rc, Brush.Handle
		#endif
		If Changed Then Changed(This)
	End Sub
	
	Sub BitmapType.Free
		#ifndef __USE_GTK__
			If Handle Then DeleteObject Handle
			Handle = 0
		#endif
		If Changed Then Changed(This)
	End Sub
	
	Operator BitmapType.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator BitmapType.Let(ByRef Value As WString)
		#ifdef __USE_GTK__
			If StartsWith(Value, "/") Then
				LoadFromFile(Value)
			Else
				LoadFromResourceName(Value)
			End If
		#else
			If FindResource(GetModuleHandle(NULL), Value, RT_BITMAP) Then
				LoadFromResourceName(Value)
			ElseIf FindResource(GetModuleHandle(NULL), Value, "PNG") Then
				LoadFromPNGResourceName(Value)
			Else
				LoadFromFile(Value)
			End If
		#endif
	End Operator
	
	#ifndef __USE_GTK__
		Operator BitmapType.Let(Value As HBITMAP)
			Handle = Value
		End Operator
	#endif
	
	Constructor BitmapType
		WLet FClassName, "BitmapType"
		#ifndef __USE_GTK__
			FLoadFlag(0) = 0
			FLoadFlag(1) = LR_LOADTRANSPARENT
		#endif
		FWidth       = 16
		FHeight      = 16
		FTransparent = False
		Create
	End Constructor
	
	Destructor BitmapType
		Free
		#ifndef __USE_GTK__
			DeleteObject FDevice
			DeleteObject Handle
		#endif
	End Destructor
End Namespace
