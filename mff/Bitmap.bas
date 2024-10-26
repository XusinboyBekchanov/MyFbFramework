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
	#ifndef ReadProperty_Off
		Private Function BitmapType.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
				#ifdef __USE_GTK__
				Case "handle": Return Handle
				#elseif defined(__USE_WINAPI__)
				Case "handle": Return @Handle
				#endif
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function BitmapType.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	#ifndef BitmapType_Width_Get_Off
		Private Property BitmapType.Width As Integer
			Return FWidth
		End Property
	#endif
	
	Private Property BitmapType.Width(Value As Integer)
		FWidth = Value
		If Changed Then Changed(*Designer, This)
	End Property
	
	#ifndef BitmapType_Height_Get_Off
		Private Property BitmapType.Height As Integer
			Return FHeight
		End Property
	#endif
	
	Private Property BitmapType.Height(Value As Integer)
		FHeight = Value
		If Changed Then Changed(*Designer, This)
	End Property
	
	Private Property BitmapType.Transparency As Boolean
		Return FTransparent
	End Property
	
	Private Property BitmapType.Transparency(Value As Boolean)
		FTransparent = Value
	End Property
	
	Private Function BitmapType.LoadFromFile(ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0, iMaskColor As Integer = 0) As Boolean
		Free
		#ifdef __USE_GTK__
			Dim As GError Ptr gerr
			If File = "" Then Return False
			If cxDesired = 0 AndAlso cyDesired = 0 Then
				Handle = gdk_pixbuf_new_from_file(ToUtf8(File), @gerr)
			Else
				Handle = gdk_pixbuf_new_from_file_at_size(ToUtf8(File), cxDesired, cyDesired, @gerr)
			End If
			If Handle = 0 Then Return False
		#elseif defined(__USE_WASM__)
			Handle = File
		#elseif defined(__USE_WINAPI__)
			Dim As Integer Pos1 = InStrRev(File, ".")
			Select Case LCase(Mid(File, Pos1 + 1))
			Case "bmp"
				Dim As BITMAP BMP
				Dim As HDC MemDC
				If Handle Then DeleteObject Handle
				Handle = LoadImageW(0, File, IMAGE_BITMAP, cxDesired, cyDesired, LR_LOADFROMFILE Or LR_LOADMAP3DCOLORS Or FLoadFlag(abs_(FTransparent)))
				If Handle = 0 Then Return False
				GetObject(Handle,SizeOf(BMP),@BMP)
				FWidth  = BMP.bmWidth
				FHeight = BMP.bmHeight
			Case Else
				Dim pImage As GpImage Ptr
				If Handle Then DeleteObject Handle: Handle = 0
				' // Initialize Gdiplus
				Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
				StartupInput.GdiplusVersion = 1
				GdiplusStartup(@token, @StartupInput, NULL)
				If token = NULL Then If Changed Then Changed(*Designer, This) End If: Return False
				' // Load the image from file
				GdipLoadImageFromFile(File, @pImage)
				If pImage = NULL Then If Changed Then Changed(*Designer, This) End If: Return False
				' // Get the image width and height
				GdipGetImageWidth(pImage, @FWidth)
				GdipGetImageHeight(pImage, @FHeight)
				' // Create bitmap from image
				GdipCreateHBITMAPFromBitmap(Cast(GpBitmap Ptr, pImage), @Handle, iMaskColor)
				' // Free the image
				If pImage Then GdipDisposeImage pImage
				' // Shutdown Gdiplus
				GdiplusShutdown token
			End Select
		#endif
		If Changed Then Changed(*Designer, This)
		Return True
	End Function
	
	#ifndef BitmapType_SaveToFile_Off
		Private Function BitmapType.SaveToFile(ByRef File As WString) As Boolean
			#ifdef __USE_WINAPI__
				Type RGB3 Field = 1
					G As Byte
					B As Byte
					R As Byte
				End Type
				Type BitmapStruct Field = 1
					Identifier      As WORD
					FileSize        As DWORD
					Reserved0       As DWORD
					bmpDataOffset   As DWORD
					bmpHeaderSize   As DWORD
					bmpWidth        As DWORD
					bmpHeight       As DWORD
					Planes          As WORD
					BitsPerPixel    As WORD
					Compression     As DWORD
					bmpDataSize     As DWORD
					HResolution     As DWORD
					VResolution     As DWORD
					Colors          As DWORD
					ImportantColors As DWORD
				End Type
				Static As BitmapStruct BM
				Dim As Integer F,x,y,Clr,Count = 0
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
				F = FreeFile_
				Open File For Binary Access Write As #F
				Put #F,,BM
				Put #F,,PixelData()
				CloseFile_(F)
				Erase PixelData
			#endif
			Return True
		End Function
	#endif
	
	#ifdef __USE_WINAPI__
		#ifndef BitmapType_LoadFromHICON_Off
			Private Function BitmapType.LoadFromHICON(IcoHandle As HICON) As Boolean
				Free
				' Initialize Gdiplus
				Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
				StartupInput.GdiplusVersion = 1
				GdiplusStartup(@token, @StartupInput, NULL)
				
				Dim BMPI As BITMAPINFOHEADER, uBMP As BITMAP, ICI As ICONINFO
				Dim r As GpRect, gBMP As BitmapData, hDC As HDC
				Dim aBits() As Long, lPtr As Long, lMaskPtr As Long
				
				Const ImageLockModeWrite As Long = &H2
				Const ImageLockModeUserInputBuf As Long = &H4
				Const PixelFormatARGB As Long = &H26200A ' ARGB pixel format (alpha channel used)
				Const PixelFormatpARGB As Long = &HE200B ' premultiplied/simple transparency
				
				GetIconInfo IcoHandle, @ICI
				If ICI.hbmColor Then                    ' sanity checks first
					If ICI.hbmMask = 0& Then Exit Function
					GetObject ICI.hbmColor, Len(uBMP), @uBMP ' get icon dimensions & bitcount
					Height = uBMP.bmHeight
				ElseIf ICI.hbmMask = 0& Then
					Exit Function
				Else                                    ' get icon dimensions & bitcount
					GetObject ICI.hbmMask, Len(uBMP), @uBMP
					Height = uBMP.bmHeight \ 2
				End If
				This.Width = uBMP.bmWidth
				Dim As Boolean isCursor = Abs(ICI.fIcon = 0&)         ' return optional parameters
				Dim As Integer HotSpotX = ICI.xHotspot
				Dim As Integer HotSpotY = ICI.yHotspot
				
				hDC = CreateCompatibleDC(0&)            ' another sanity check
				Dim As GpBitmap Ptr pvConvertHICONtoHImageEx
				If hDC = 0& Then
					If Not ICI.hbmColor = 0& Then DeleteObject ICI.hbmColor
					DeleteObject ICI.hbmMask
					GdipCreateBitmapFromHICON IcoHandle, @pvConvertHICONtoHImageEx
					Exit Function
				End If                                  ' setup how we want bits returned
				With BMPI
					.biBitCount = 32: .biPlanes = 1: .biSize = 40
					.biWidth = uBMP.bmWidth
					.biHeight = -uBMP.bmHeight
				End With
				lMaskPtr = Height * Width               ' size processing array
				ReDim aBits(0 To lMaskPtr + lMaskPtr - 1&)
				If ICI.hbmColor Then                    ' get XOR color bits
					GetDIBits hDC, ICI.hbmColor, 0&, Height, @aBits(0), Cast(LPBITMAPINFO, @BMPI), 0
					DeleteObject ICI.hbmColor
				Else                                    ' get XOR & AND B/W bits
					GetDIBits hDC, ICI.hbmMask, 0&, Height, @aBits(0), Cast(LPBITMAPINFO, @BMPI), 0
					GetDIBits hDC, ICI.hbmMask, Height, Height, @aBits(lMaskPtr), Cast(LPBITMAPINFO, @BMPI), 0
					DeleteObject ICI.hbmMask: ICI.hbmMask = 0&
					DeleteDC hDC                        ' done with the source bitmaps
				End If
				
				If uBMP.bmBitsPixel = 32 Then               ' 32 bit color source can contain XP-like alpha channel
					For lPtr = 0& To lMaskPtr - 1&          ' if it does, the icon mask is ignored
						If Not (aBits(lPtr) And &HFF000000) = 0& Then
							gBMP.PixelFormat = PixelFormatARGB
							Exit For
						End If
					Next
				End If
				If gBMP.PixelFormat = 0& Then               ' process icon mask
					If Not ICI.hbmMask = 0& Then            ' get mask info, if not already done
						GetDIBits hDC, ICI.hbmMask, 0&, Height, @aBits(lMaskPtr), Cast(LPBITMAPINFO, @BMPI), 0&
					End If                                  ' convert inverted bits to fully opaque
					For lPtr = 0& To lMaskPtr - 1&          ' set alpha channel for fully opaque bits
						If aBits(lPtr + lMaskPtr) = 0& Then
							aBits(lPtr) = &HFF000000 Or aBits(lPtr)
						ElseIf Not aBits(lPtr) = 0& Then
							aBits(lPtr) = &HFF000000 Or aBits(lPtr)
						End If
					Next
					gBMP.PixelFormat = PixelFormatpARGB
				End If
				If Not ICI.hbmMask = 0& Then                ' clean up
					DeleteObject ICI.hbmMask
					DeleteDC hDC
				End If
				
				r.Height = Height: r.Width = Width        ' setup the GDI+ stuff
				With gBMP
					.Height = Height: .Width = Width
					.Scan0 = VarPtr(aBits(0))
					.Stride = .Width * 4&
				End With                                    ' create GDI+ image & prepare to transfer bits
				If GdipCreateBitmapFromScan0(This.Width, Height, 0&, gBMP.PixelFormat, ByVal 0&, @pvConvertHICONtoHImageEx) = 0& Then
					If GdipBitmapLockBits(pvConvertHICONtoHImageEx, @r, ImageLockModeWrite Or ImageLockModeUserInputBuf, gBMP.PixelFormat, @gBMP) Then
						If GdipBitmapLockBits(pvConvertHICONtoHImageEx, @r, ImageLockModeWrite Or ImageLockModeUserInputBuf, gBMP.PixelFormat, @gBMP) Then gBMP.Scan0 = 0&
					End If
					If gBMP.Scan0 Then
						GdipBitmapUnlockBits pvConvertHICONtoHImageEx, @gBMP
					Else
						GdipDisposeImage Cast(GpImage Ptr, pvConvertHICONtoHImageEx): pvConvertHICONtoHImageEx = 0&
					End If
				End If
				Erase aBits                               ' clean up & return result
				If pvConvertHICONtoHImageEx = 0& Then GdipCreateBitmapFromHICON IcoHandle, @pvConvertHICONtoHImageEx
				' Create icon from image
				GdipCreateHBITMAPFromBitmap(pvConvertHICONtoHImageEx, @Handle, 0)
				' Shutdown Gdiplus
				GdiplusShutdown token
				Return Handle <> 0
			End Function
		#endif
	#endif

	#ifdef __USE_WINAPI__
	Private Function BitmapType.LoadFromScreen(x As Double, y As Double, iWidth As Double, iHeight As Double, iHandle As HWND = 0) As Boolean
			Free
			Dim As HWND desktop = IIf(iHandle = 0, GetDesktopWindow(), iHandle)
			If (desktop = NULL) Then
				Return False
			End If
			Dim As HDC screen_dev = GetDC(desktop)
			If (screen_dev = NULL) Then
				Return False
			End If
			' Create a compatible DC
			Dim As HDC dst_hdc = CreateCompatibleDC(screen_dev)
			If (dst_hdc = NULL) Then
				ReleaseDC(desktop, screen_dev)
				Return False
			End If
			
			' Create a new bitmap of icon size
			Dim As HBITMAP bmp = CreateCompatibleBitmap(screen_dev, iWidth, iHeight)
			If (bmp = NULL) Then
				DeleteDC(dst_hdc)
				ReleaseDC(desktop, screen_dev)
				Return False
			End If
			
			'Select it into the compatible DC
			Dim As HBITMAP old_dst_bmp = Cast(HBITMAP, SelectObject(dst_hdc, bmp))
			If (old_dst_bmp = NULL) Then
				DeleteObject(bmp)
				Return False
			End If
			' Got the image into the compatible DC
			BitBlt(dst_hdc, 0, 0, iWidth, iHeight, screen_dev, x, y, SRCCOPY)
			' Restore settings
			SelectObject(dst_hdc, old_dst_bmp)
			Handle = bmp
			DeleteDC(dst_hdc)
			ReleaseDC(desktop, screen_dev)
			Return True
		End Function
	#endif

	#ifndef BitmapType_LoadFromResourceName_Off
		Private Function BitmapType.LoadFromResourceName(ResName As String, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0, iMaskColor As Integer = 0) As Boolean
			Free
			#ifdef __USE_GTK__
				Dim As GError Ptr gerr
				If FileExists("./Resources/" & ResName & ".png") Then
					Handle = gdk_pixbuf_new_from_file(ToUtf8("./Resources/" & ResName & ".png"), @gerr)
				ElseIf FileExists("./resources/" & ResName & ".png") Then
					Handle = gdk_pixbuf_new_from_file(ToUtf8("./resources/" & ResName & ".png"), @gerr)
				ElseIf FileExists("./Resources/" & ResName & ".ico") Then
					Handle = gdk_pixbuf_new_from_file(ToUtf8("./Resources/" & ResName & ".ico"), @gerr)
				ElseIf FileExists("./resources/" & ResName & ".ico") Then
					Handle = gdk_pixbuf_new_from_file(ToUtf8("./resources/" & ResName & ".ico"), @gerr)
				Else
					Handle = gdk_pixbuf_new_from_resource(ToUtf8(ResName), @gerr)
				End If
				If gerr Then Print gerr->code, *gerr->message
			#elseif defined(__USE_WASM__)
				Handle = "Resources/" & ResName & ".png"
			#elseif defined(__USE_WINAPI__)
				Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
				Dim As BITMAP BMP
				If ModuleHandle = 0 AndAlso FileExists(ExePath & "./Resources/" & ResName & ".png") Then
					LoadFromFile(ExePath & "./Resources/" & ResName & ".png", cxDesired, cyDesired, iMaskColor)
				ElseIf ModuleHandle = 0 AndAlso FileExists(ExePath & "./Resources/" & ResName & ".ico") Then
					LoadFromFile(ExePath & "./Resources/" & ResName & ".ico", cxDesired, cyDesired, iMaskColor)
				ElseIf FindResource(ModuleHandle_, ResName, RT_BITMAP) Then
					Handle = LoadImageW(ModuleHandle_, ResName, IMAGE_BITMAP, cxDesired, cyDesired, LR_COPYFROMRESOURCE Or FLoadFlag(abs_(FTransparent)))
				ElseIf FindResource(ModuleHandle_, ResName, RT_GROUP_ICON) Then
					Dim As HICON IcoHandle
					IcoHandle = LoadImageW(ModuleHandle_, ResName, IMAGE_ICON, cxDesired, cyDesired, LR_COPYFROMRESOURCE)
					If IcoHandle = 0 Then Return False
					LoadFromHICON(IcoHandle)
				ElseIf FindResource(ModuleHandle_, ResName, RT_GROUP_CURSOR) Then
					Dim As HICON IcoHandle
					IcoHandle = LoadImageW(ModuleHandle_, ResName, IMAGE_CURSOR, cxDesired, cyDesired, LR_COPYFROMRESOURCE)
					LoadFromHICON(IcoHandle)
				Else
					Dim As HRSRC hPicture = FindResourceW(ModuleHandle_, ResName, "PNG")
					If hPicture = 0 Then hPicture = FindResourceW(ModuleHandle_, ResName, RT_GROUP_ICON)
					If hPicture = 0 Then hPicture = FindResourceW(ModuleHandle_, ResName, RT_RCDATA)
					
					Dim As HRSRC hPictureData
					Dim As Unsigned Long dwSize = SizeofResource(ModuleHandle_, hPicture)
					Dim As HGLOBAL hGlobal = NULL
					If hPicture = 0 Then Return False
					hPictureData = LockResource(LoadResource(ModuleHandle_, hPicture))
					If hPictureData = 0 Then Return False
					hGlobal = GlobalAlloc(GMEM_MOVEABLE, dwSize)
					If hGlobal = 0 Then Return False
					' Lock the memory
					Dim As LPVOID pData = GlobalLock(hGlobal)
					If pData = 0 Then
						GlobalFree(hGlobal)
						Return False
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
							GdipCreateHBITMAPFromBitmap(Cast(GpBitmap Ptr, pImage), @Handle, iMaskColor)
							
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
				End If
				GetObject(Handle,SizeOf(BMP),@BMP)
				FWidth  = BMP.bmWidth
				FHeight = BMP.bmHeight
			#endif
			If Changed Then Changed(*Designer, This)
			Return Handle <> 0
		End Function
	#endif
	
	Private Function BitmapType.LoadFromResourceID(ResID As Integer, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
		Free
		#ifdef __USE_GTK__
			Return False
		#elseif defined(__USE_WINAPI__)
			Dim As BITMAP BMP
			Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
			Handle = LoadImageW(ModuleHandle_, MAKEINTRESOURCE(ResID), IMAGE_BITMAP, cxDesired, cyDesired, LR_COPYFROMRESOURCE Or FLoadFlag(abs_(FTransparent)))
			If Handle = 0 Then Return False
			GetObject(Handle,SizeOf(BMP),@BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(*Designer, This)
		Return True
	End Function
	
	Private Sub BitmapType.Create
		#ifdef __USE_WINAPI__
			Dim rc As ..RECT
			Dim As HDC Dc
			If Handle Then DeleteObject Handle
			Dc = GetDC(0)
			FDevice = CreateCompatibleDC(Dc)
			ReleaseDC 0,Dc
			rc.left = 0
			rc.top = 0
			rc.right = FWidth
			rc.bottom = FHeight
			Handle = CreateCompatibleBitmap(FDevice,FWidth,FHeight)
			SelectObject FDevice,Handle
			FillRect(FDevice, @rc, Brush.Handle)
		#endif
		If Changed Then Changed(*Designer, This)
	End Sub
	
	Private Sub BitmapType.Clear
		#ifdef __USE_WINAPI__
			Dim rc As ..RECT
			rc.left = 0
			rc.top = 0
			rc.right = FWidth
			rc.bottom = FHeight
			FillRect FDevice, @rc, Brush.Handle
		#endif
		If Changed Then Changed(*Designer, This)
	End Sub
	
	Private Sub BitmapType.Free
		#ifdef __USE_WINAPI__
			If Handle Then DeleteObject Handle
			Handle = 0
		#elseif defined(__USE_WASM__)
			Handle = ""
		#endif
		'If Changed Then Changed(This)
	End Sub
	
	Private Operator BitmapType.Cast As Any Ptr
		Return @This
	End Operator
	
	#ifndef BitmapType_Let_WString_Off
		Private Operator BitmapType.Let(ByRef Value As WString)
			Free
			WLet(FResName, Value)
			#ifdef __USE_GTK__
				If StartsWith(Value, "/") Then
					LoadFromFile(Value)
				Else
					LoadFromResourceName(Value)
				End If
			#elseif defined(__USE_WASM__)
				If StartsWith(Value, "/") OrElse InStr(Value, ".") > 0 Then
					LoadFromFile(Value)
				Else
					LoadFromResourceName(Value)
				End If
			#else
				If (Not LoadFromResourceName(Value)) AndAlso (Not LoadFromResourceID(Val(Value))) Then
					LoadFromFile(Value)
				End If
			#endif
		End Operator
	#endif
	
	#ifdef __USE_WINAPI__
		#ifndef BitmapType_Let_HBITMAP_Off
			Private Operator BitmapType.Let(Value As HBITMAP)
				Free
				Handle = Value
			End Operator
		#endif
		
		#ifndef BitmapType_Let_HICON_Off
			Private Operator BitmapType.Let(Value As HICON)
				Free
				#ifndef BitmapType_LoadFromHICON_Off
					LoadFromHICON(Value)
				#endif
			End Operator
		#endif
	#else
		
	#endif
	
	Private Function BitmapType.ToString() ByRef As WString
		If FResName > 0 Then Return *FResName Else Return ""
	End Function
	
	Private Constructor BitmapType
		WLet(FClassName, "BitmapType")
		#ifdef __USE_WINAPI__
			FLoadFlag(0) = 0
			FLoadFlag(1) = LR_LOADTRANSPARENT
		#endif
		FWidth       = 16
		FHeight      = 16
		FTransparent = False
		'Create
	End Constructor
	
	Private Destructor BitmapType
		If FResName Then _Deallocate(FResName)
		Free
		#ifdef __USE_GTK__
			If Handle Then g_object_unref(Handle)
		#elseif defined(__USE_WINAPI__)
			If FDevice Then DeleteObject FDevice
			If Handle Then DeleteObject Handle
		#endif
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Function BitmapTypeLoadFromResourceName Alias "BitmapTypeLoadFromResourceName"(Bitm As My.Sys.Drawing.BitmapType Ptr, ResName As String, ModuleHandle As Any Ptr = 0) As Boolean  __EXPORT__
		#ifdef __USE_GTK__
			Return Bitm->LoadFromResourceName(ResName)
		#else
			Return Bitm->LoadFromResourceName(ResName, Cast(HINSTANCE, ModuleHandle))
		#endif
	End Function
	
	Function BitmapTypeLoadFromFile Alias "BitmapTypeLoadFromFile"(Bitm As My.Sys.Drawing.BitmapType Ptr, ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean __EXPORT__
		Return Bitm->LoadFromFile(File, cxDesired, cyDesired)
	End Function
#endif
