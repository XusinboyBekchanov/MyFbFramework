'###############################################################################
'#  ImageList.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TImageList.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added png support                                              #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ImageList.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function ImageList.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "backcolor": Return @FBackColor
			Case "count": FCount = This.Count: Return @FCount
			Case "drawingstyle": Return @This.DrawingStyle
			Case "growcount": Return @GrowCount
			Case "imagelisthandle": Return Handle
			Case "imagewidth": Return @FImageWidth
			Case "imageheight": Return @FImageHeight
			Case "imagetype": Return @ImageType
			Case "initialcount": Return @InitialCount
			Case "items": Return @Items.Text
			Case "maskcolor": Return @FMaskColor
			Case "parentwindow": Return FParentWindow
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ImageList.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "backcolor": This.BackColor = QInteger(Value)
			Case "count": This.Count = QInteger(Value)
			Case "drawingstyle": This.DrawingStyle = *Cast(DrawingStyles Ptr, @Value)
			Case "growcount": This.GrowCount = QInteger(Value)
			Case "imagelisthandle": This.Handle = Value
			Case "imagewidth": This.ImageWidth = QInteger(Value)
			Case "imageheight": This.ImageHeight = QInteger(Value)
			Case "imagetype": This.ImageType = *Cast(ImageTypes Ptr, @Value)
			Case "initialcount": This.InitialCount = QInteger(Value)
			Case "items": This.Items = QWString(Value)
			Case "maskcolor": This.MaskColor = QInteger(Value)
			Case "parentwindow": This.ParentWindow = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property ImageList.ParentWindow As Component Ptr
		Return FParentWindow
	End Property
	
	Private Property ImageList.ParentWindow(Value As Component Ptr)
		FParentWindow = Value
		NotifyWindow
	End Property
	
	Private Property ImageList.ImageWidth As Integer
		Return FImageWidth
	End Property
	
	Private Property ImageList.ImageWidth(Value As Integer)
		If FImageWidth <> Value Then
			FImageWidth = Value
			#ifdef __USE_WINAPI__
				ImageList_SetIconSize(Handle, ScaleX(FImageWidth), ScaleY(FImageHeight))
			#endif
			NotifyWindow
		End If
	End Property
	
	Private Property ImageList.ImageHeight As Integer
		Return FImageHeight
	End Property
	
	Private Property ImageList.ImageHeight(Value As Integer)
		FImageHeight = Value
		#ifdef __USE_WINAPI__
			ImageList_SetIconSize(Handle, ScaleX(FImageWidth), ScaleY(FImageHeight))
		#endif
		NotifyWindow
	End Property

	Private Sub ImageList.SetImageSize(imgWidth As Integer, imgHeight As Integer, imgxdpi As Single = 1, imgydpi As Single = 1)
		If FImageWidth <> imgWidth OrElse FImageHeight <> imgHeight OrElse xdpi <> imgxdpi OrElse ydpi <> imgydpi Then
			FImageWidth = imgWidth
			FImageHeight = imgHeight
			xdpi = imgxdpi
			ydpi = imgydpi
			#ifdef __USE_WINAPI__
				If FList.Count <> ImageList_GetImageCount(Handle) Then
					For i As Integer = 0 To FList.Count - 1
						DestroyIcon FList.Item(i)
					Next i
					FList.Clear
					For i As Integer = 0 To ImageList_GetImageCount(Handle) - 1
						FList.Add ImageList_GetIcon(Handle, i, DrawingStyle Or ImageType)
					Next i
				End If
				ImageList_SetIconSize(Handle, ScaleX(FImageWidth), ScaleY(FImageHeight))
				For i As Integer = 0 To FList.Count - 1
					ImageList_AddIcon(Handle, FList.Item(i))
				Next i
			#endif
		End If
	End Sub
	
	Private Property ImageList.BackColor As Integer
		#ifdef __USE_WINAPI__
			FBackColor = ImageList_GetBkColor(Handle)
		#endif
		Return FBackColor
	End Property
	
	Private Property ImageList.BackColor(Value As Integer)
		FBackColor = Value
		#ifdef __USE_WINAPI__
			ImageList_SetBkColor(Handle,FBackColor)
		#endif
		NotifyWindow
	End Property
	
	Private Property ImageList.MaskColor As Integer
		Return FMaskColor
	End Property
	
	Private Property ImageList.MaskColor(Value As Integer)
		FMaskColor = Value
		NotifyWindow
	End Property
	
	Private Property ImageList.Count As Integer
		#ifdef __USE_WINAPI__
			FCount = ImageList_GetImageCount(Handle)
		#endif
		Return FCount
	End Property
	
	Private Property ImageList.Count(Value As Integer)
		FCount = Value
		#ifdef __USE_WINAPI__
			FCount = ImageList_SetImageCount(Handle, Value)
		#endif
	End Property
	
	#ifndef ImageList_IndexOf_Off
		Private Function ImageList.IndexOf(ByRef Key As WString) As Integer
			Return Items.IndexOfKey(Key)
		End Function
	#endif
	
	Private Sub ImageList.NotifyWindow
		If ParentWindow Then
			#ifdef __USE_WINAPI__
				If ParentWindow->Handle Then RedrawWindow ParentWindow->Handle, 0, 0, RDW_ERASE Or RDW_INVALIDATE
			#endif
		End If
	End Sub
	
	Private Sub ImageList.Create
		#ifdef __USE_WINAPI__
			If Handle Then ImageList_Destroy Handle
			Handle = ImageList_Create(FImageWidth, FImageHeight, ILC_MASK Or ILC_COLOR32, InitialCount, GrowCount)
		#endif
	End Sub
	
	Private Sub ImageList.Add(Bmp As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
		#ifdef __USE_WINAPI__
			If ImageList_Add(Handle, Bmp.Handle, Mask.Handle) <> -1 Then
				FNotChange = True
				If Not FNotAdd Then Items.Add(Key)
				FNotChange = False
			End If
		#else
			FNotChange = True
			If Not FNotAdd Then Items.Add(Key)
			FNotChange = False
		#endif
	End Sub
	
	Private Sub ImageList.Add(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
		FNotChange = True
		If Not FNotAdd Then Items.Add(Key)
		FNotChange = False
		#ifdef __USE_WINAPI__
			ImageList_AddIcon(Handle, Icon.Handle)
		#endif
	End Sub
	
	Private Sub ImageList.Add(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
		FNotChange = True
		If Not FNotAdd Then Items.Add(Key)
		FNotChange = False
		#ifdef __USE_WINAPI__
			ImageList_AddIcon(Handle, Cursor.Handle)
		#endif
	End Sub
	
	#ifndef ImageList_Add_WString_Off
		Private Sub ImageList.Add(ByRef ResName As WString, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0, iMaskColor As Integer = 255)
			FNotChange = True
			#ifdef __USE_GTK__
				FNotAdd = True
				Dim As My.Sys.Drawing.BitmapType Bitm
				Bitm.LoadFromResourceName(ResName)
				Items.Add Key, ResName, @Bitm
				This.Add Bitm, Bitm, Key
				FNotAdd = False
			#elseif defined(__USE_WINAPI__)
				Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
				FNotAdd = True
				If FindResource(ModuleHandle_, ResName, RT_BITMAP) Then
					Dim As My.Sys.Drawing.BitmapType Bitm
					Bitm.LoadFromResourceName(ResName, ModuleHandle_, , , iMaskColor)
					Items.Add Key, ResName, @Bitm
					This.Add Bitm, Bitm, Key
				ElseIf FindResource(ModuleHandle_, ResName, "PNG") OrElse FindResource(ModuleHandle_, ResName, RT_RCDATA) Then
					'AddPng ResName, Key, ModuleHandle_
					Dim As My.Sys.Drawing.BitmapType Bitm
					Bitm.LoadFromResourceName(ResName, ModuleHandle_, , , iMaskColor)
					Items.Add Key, ResName, @Bitm
					This.AddMasked Bitm, iMaskColor, Key
				ElseIf FindResource(ModuleHandle_, ResName, RT_ICON) OrElse FindResource(ModuleHandle_, ResName, RT_GROUP_ICON) Then
					Dim As My.Sys.Drawing.Icon Ico
					Ico.LoadFromResourceName(ResName, ModuleHandle_)
					Items.Add Key, ResName, @Ico
					This.Add Ico, Key
				ElseIf FindResource(ModuleHandle_, ResName, RT_CURSOR) OrElse FindResource(ModuleHandle_, ResName, RT_GROUP_CURSOR)  Then
					Dim As My.Sys.Drawing.Cursor Cur
					Cur.LoadFromResourceName(ResName, ModuleHandle_)
					Items.Add Key, ResName, @Cur
					This.Add Cur, Key
				Else
					Dim As My.Sys.Drawing.BitmapType Bitm
					If Bitm.LoadFromResourceName(ResName, ModuleHandle, , , iMaskColor) Then
						Items.Add Key, ResName, @Bitm
						If FImageWidth <> ScaleX(FImageWidth) Then
							This.AddMasked Bitm, iMaskColor, Key
						Else
							ImageList_Add(Handle, Bitm.Handle, NULL)
						End If
					End If
				End If
				FNotAdd = False
			#endif
			FNotChange = False
		End Sub
	#endif
	
	#ifndef ImageList_AddFromFile_Off
		Private Sub ImageList.AddFromFile(ByRef File As WString, ByRef Key As WString = "")
			FNotChange = True
			Dim As Integer Pos1 = InStrRev(File, ".")
			Select Case LCase(Mid(File, Pos1 + 1))
			Case "bmp"
				Dim As My.Sys.Drawing.BitmapType Bitm
				Bitm.LoadFromFile(File)
				This.Add Bitm, Bitm, Key
			Case "png"
				Dim As My.Sys.Drawing.BitmapType Bitm
				Bitm.LoadFromFile(File)
				This.AddMasked Bitm, clBlack, Key
			Case "ico"
				Dim As My.Sys.Drawing.Icon Ico
				Ico.LoadFromFile(File)
				This.Add Ico, Key
			Case "cur"
				Dim As My.Sys.Drawing.Cursor Cur
				Cur.LoadFromFile(File)
				This.Add Cur, Key
			Case Else
				Dim As My.Sys.Drawing.BitmapType Bitm
				Bitm.LoadFromFile(File)
				This.Add Bitm, Bitm, Key
			End Select
			FNotChange = False
		End Sub
	#endif
	
	Private Sub ImageList.AddMasked(ByRef Bmp As My.Sys.Drawing.BitmapType, iMaskColor As Integer, ByRef Key As WString = "")
		FNotChange = True
		If Not FNotAdd Then Items.Add(Key)
		FNotChange = False
		#ifdef __USE_WINAPI__
			If Bmp.Width <> ScaleX(FImageWidth) OrElse Bmp.Height <> ScaleY(FImageHeight) Then
				Dim As HBITMAP HBitm
				Dim As HWND desktop = GetDesktopWindow()
				If (desktop <> NULL) Then
					Dim As HDC screen_dev = GetDC(desktop)
					If (screen_dev <> NULL) Then
						' Create a compatible DC
						Dim As HDC dst_hdc = CreateCompatibleDC(screen_dev)
						If (dst_hdc = NULL) Then
							ReleaseDC(desktop, screen_dev)
						Else
							' Create a new bitmap of icon size
							HBitm = CreateCompatibleBitmap(screen_dev, ScaleX(FImageWidth), ScaleY(FImageHeight))
							If (HBitm = NULL) Then
								DeleteDC(dst_hdc)
								ReleaseDC(desktop, screen_dev)
							Else
								'Select it into the compatible DC
								Dim As HBITMAP old_dst_bmp = Cast(HBITMAP, SelectObject(dst_hdc, HBitm))
								If (old_dst_bmp <> NULL) Then
									' Draw the icon into the compatible DC
									Dim As HDC MemDC
									Dim As HBITMAP OldBitmap
									Dim As BITMAP Bitmap01
									MemDC = CreateCompatibleDC(screen_dev)
									OldBitmap = SelectObject(MemDC, Bmp.Handle)
									GetObject(Cast(HBITMAP, Bmp.Handle), SizeOf(Bitmap01), @Bitmap01)
									StretchBlt(dst_hdc, 0, 0, ScaleX(FImageWidth), ScaleY(FImageHeight), MemDC, 0, 0, Bitmap01.bmWidth, Bitmap01.bmHeight, SRCCOPY)
									' Restore settings
									SelectObject(MemDC, OldBitmap)
									SelectObject(dst_hdc, old_dst_bmp)
									DeleteDC(MemDC)
									DeleteDC(dst_hdc)
									ReleaseDC(desktop, screen_dev)
								End If
							End If
						End If
					End If
				End If
				ImageList_AddMasked(Handle, HBitm, iMaskColor)
			Else
				ImageList_AddMasked(Handle, Bmp.Handle, iMaskColor)
			End If
		#endif
		NotifyWindow
	End Sub
	
	Private Sub ImageList.AddMasked(ByRef ResName As WString, iMaskColor As Integer, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0)
		#ifdef __USE_WINAPI__
			Dim As My.Sys.Drawing.BitmapType Bitm
			Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
			Bitm.LoadFromResourceName(ResName, ModuleHandle_)
			If Bitm.Handle Then
				FNotChange = True
				If Not FNotAdd Then Items.Add(Key, ResName)
				FNotChange = False
				ImageList_AddMasked(Handle, Bitm.Handle, iMaskColor)
				NotifyWindow
			End If
		#endif
	End Sub
	
	'	Sub ImageList.AddPng(ByRef ResName As WString, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0)
	'		#ifndef __USE_GTK__
	'			Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
	'			Dim As HRSRC hPicture = FindResourceW(ModuleHandle_, ResName, "PNG")
	'			Dim As HRSRC hPictureData
	'			Dim As Unsigned Long dwSize = SizeOfResource(ModuleHandle_, hPicture)
	'			Dim As HGLOBAL hGlobal = NULL
	'			If hPicture = 0 Then Return
	'			hPictureData = LockResource(LoadResource(ModuleHandle_, hPicture))
	'			If hPictureData = 0 Then Return
	'			hGlobal = GlobalAlloc(GMEM_MOVEABLE, dwSize)
	'			If hGlobal = 0 Then Return
	'			' Lock the memory
	'			Dim As LPVOID pData = GlobalLock(hGlobal)
	'			If pData = 0 Then
	'				GlobalFree(hGlobal)
	'				Return
	'			End If
	'			' Initialize Gdiplus
	'			Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
	'			StartupInput.GdiplusVersion = 1
	'			GdiplusStartup(@token, @StartupInput, NULL)
	'			' Copy the image from the binary string file to global memory
	'			CopyMemory(pData, hPictureData, dwSize)
	'			Dim As IStream Ptr pngstream = NULL
	'			If SUCCEEDED(CreateStreamOnHGlobal(hGlobal, False, @pngstream)) Then
	'				If pngstream Then
	'					Dim pImage As GpImage Ptr, hImage As HBitmap
	'					' Create a bitmap from the data contained in the stream
	'					GdipCreateBitmapFromStream(pngstream, Cast(GpBitmap Ptr Ptr, @pImage))
	'					' Create icon from image
	'					GdipCreateHBitmapFromBitmap(Cast(GpBitmap Ptr, pImage), @hImage, clWhite)
	'					' Free the image
	'					If pImage Then GdipDisposeImage pImage
	'					pngstream->lpVtbl->Release(pngstream)
	'					FNotChange = True
	'					Items.Add(Key, ResName)
	'					'ImageList_AddIcon(Handle, hImage)
	'					ImageList_AddMasked(Handle, hImage, clWhite)
	'					NotifyWindow
	'				End If
	'			End If
	'			' Unlock the memory
	'			GlobalUnlock pData
	'			' Free the memory
	'			GlobalFree hGlobal
	'			' Shutdown Gdiplus
	'			GdiplusShutdown token
	'		#endif
	'	End Sub
	
	'	Sub ImageList.Set(Index As Integer, ByRef ResName As WString, ModuleHandle As Any Ptr = 0))
	'		FNotChange = True
	'		#ifdef __USE_GTK__
	'			Dim As My.Sys.Drawing.BitmapType Bitm
	'			Bitm.LoadFromResourceName(ResName)
	'			SetImage Bitm, Bitm, Key
	'		#else
	'			Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
	'			If FindResource(ModuleHandle_, ResName, RT_BITMAP) Then
	'				Dim As My.Sys.Drawing.BitmapType Bitm
	'				Bitm.LoadFromResourceName(ResName)
	'				SetImage Bitm, Bitm, Key
	'			ElseIf FindResource(ModuleHandle_, ResName, "PNG") OrElse FindResource(ModuleHandle_, ResName, RT_RCDATA) Then
	'				Dim As My.Sys.Drawing.BitmapType Bitm
	'				Bitm.LoadFromResourceName(ResName)
	'				SetImage Bitm, 0, Key
	'			ElseIf FindResource(ModuleHandle_, ResName, RT_ICON) OrElse FindResource(ModuleHandle_, ResName, RT_GROUP_ICON) Then
	'				Dim As My.Sys.Drawing.Icon Ico
	'				Ico.LoadFromResourceName(ResName)
	'				AddImage Ico, Key
	'			ElseIf FindResource(ModuleHandle_, ResName, RT_CURSOR) OrElse FindResource(ModuleHandle_, ResName, RT_GROUP_CURSOR) Then
	'				Dim As My.Sys.Drawing.Cursor Cur
	'				Cur.LoadFromResourceName(ResName)
	'				AddImage Cur, Key
	'			Else
	'				Dim As My.Sys.Drawing.BitmapType Bitm
	'				Bitm.LoadFromResourceName(ResName)
	'				AddMasked Bitm, 0, Key
	'			End If
	'		#endif
	'	End Sub
	'
	'	Sub ImageList.Set(ByRef Key As WString, ByRef Image As WString, ModuleHandle As Any Ptr = 0))
	'		This.SetImage(IndexOf(Key), Image, ModuleHandle)
	'	End Sub
	'
	'	Sub ImageList.SetFromFile(ByRef Key As WString, ByRef Image As WString)
	'		This.SetImage(IndexOf(Key), Image)
	'	End Sub
	
	#ifndef ImageList_Remove_Integer_Off
		Private Sub ImageList.Remove(Index As Integer)
			#ifdef __USE_WINAPI__
				FNotChange = True
				Items.Remove Index
				FNotChange = False
				ImageList_Remove(Handle, Index)
			#endif
		End Sub
	#endif
	
	Private Sub ImageList.Remove(ByRef Key As WString)
		Remove(IndexOf(Key))
	End Sub
	
	#ifndef ImageList_GetMask_Integer_Off
		Private Function ImageList.GetBitmap(Index As Integer) As My.Sys.Drawing.BitmapType
			'Dim As My.Sys.Drawing.BitmapType Ptr BMP
			#ifdef __USE_WINAPI__
				Dim IMIF As ImageInfo
				'BMP = CAllocate_(SizeOf(My.Sys.Drawing.BitmapType))
				ImageList_GetImageInfo(Handle,Index,@IMIF)
				Return IMIF.hbmImage 'BMP->Handle =
			#else
				Return FBMP
			#endif
			'Return *BMP
		End Function
	#endif
	
	#ifndef ImageList_GetMask_Integer_Off
		Private Function ImageList.GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
			'Dim As My.Sys.Drawing.BitmapType Ptr BMP
			#ifdef __USE_WINAPI__
				Dim IMIF As ImageInfo
				'BMP = CAllocate_(SizeOf(My.Sys.Drawing.BitmapType))
				ImageList_GetImageInfo(Handle,Index,@IMIF)
				Return IMIF.hbmMask 'BMP->Handle =
			#else
				Return FBMP
			#endif
			'Return *BMP
		End Function
	#endif
	
	#ifndef ImageList_GetIcon_Integer_Off
		Private Function ImageList.GetIcon(Index As Integer) As My.Sys.Drawing.Icon
			'Dim As My.Sys.Drawing.Icon Ptr ICO
			'ICO = CAllocate_(SizeOf(My.Sys.Drawing.Icon))
			#ifdef __USE_WINAPI__
				Return ImageList_GetIcon(Handle, Index, DrawingStyle Or ImageType) 'ICO->Handle =
			#else
				Return 0
			#endif
			'Return *ICO
		End Function
	#endif
	
	#ifndef ImageList_GetCursor_Integer_Off
		Private Function ImageList.GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
			'Dim As My.Sys.Drawing.Cursor Ptr CUR
			'CUR = CAllocate_(SizeOf(My.Sys.Drawing.Cursor))
			#ifdef __USE_WINAPI__
				Return ImageList_GetIcon(Handle, Index, DrawingStyle Or ImageType) 'CUR->Handle =
			#else
				Return 0
			#endif
			'Return *CUR
		End Function
	#endif
	
	Private Function ImageList.GetBitmap(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Return GetBitmap(IndexOf(Key))
		'Return *Cast(My.Sys.Drawing.BitmapType Ptr, Items.GetObject(Key))
	End Function
	
	Private Function ImageList.GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Return GetMask(IndexOf(Key))
	End Function
	
	Private Function ImageList.GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
		Return GetIcon(IndexOf(Key))
	End Function
	
	Private Function ImageList.GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
		Return GetCursor(IndexOf(Key))
	End Function
	
	Private Sub ImageList.Draw(Index As Integer, ByRef Canvas As My.Sys.Drawing.Canvas, X As Integer, Y As Integer, iWidth As Integer = -1, iHeight As Integer = -1, FG As Integer = -1, BK As Integer = -1)
		#if defined(__USE_WINAPI__) AndAlso Not defined(__USE_CAIRO__)
			If iWidth = -1 Then
				ImageList_Draw(Handle, Index, Canvas.Handle, X, Y, DrawingStyle Or ImageType)
			Else
				ImageList_DrawEx(Handle, Index, Canvas.Handle, X, Y, iWidth, iHeight, FG, BK, DrawingStyle Or ImageType)
			End If
		#endif
	End Sub
	
	#ifndef ImageList_Clear_Off
		Private Sub ImageList.Clear
			FNotChange = True
			Items.Clear
			FNotChange = False
			#ifdef __USE_WINAPI__
				ImageList_Remove Handle, -1
			#endif
		End Sub
	#endif
	
	Private Operator ImageList.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Sub ImageList.ImageList_Change(ByRef Sender As Dictionary)
		#ifdef __USE_WINAPI__
			Dim As ImageList Ptr pimgList = Sender.Tag
			If Not pimgList->FNotChange Then
				Dim As Dictionary Items
				Items.Text = Sender.Text
				pimgList->Clear
				With Items
					For i As Integer = 0 To .Count - 1
						If InStr(.Item(i)->Text, ".") > 0 Then
							pimgList->AddFromFile(.Item(i)->Text, .Item(i)->Key)
						Else
							pimgList->Add(.Item(i)->Text, .Item(i)->Key)
						End If
					Next i
				End With
			End If
		#endif
	End Sub
	
	Private Constructor ImageList(ByVal iImageWidth As Integer = 16, ByVal iImageHeight As Integer = 16)
		WLet(FClassName, "ImageList")
		InitialCount = 4
		GrowCount = 4
		FImageWidth  = iImageWidth
		FImageHeight = iImageHeight
		Items.Tag = @This
		'Items.OnChange = @ImageList_Change
		#ifdef __USE_GTK__
			Handle = gtk_icon_theme_new()
		#elseif defined(__USE_WINAPI__)
			Handle = ImageList_Create(ScaleX(FImageWidth), ScaleY(FImageHeight), ILC_COLOR32, InitialCount, GrowCount) 'ILC_MASK Or
			'Create
		#endif
	End Constructor
	
	Private Destructor ImageList
		#ifdef __USE_WINAPI__
			If Handle Then ImageList_Destroy Handle
			For i As Integer = 0 To FList.Count - 1
				DestroyIcon FList.Item(i)
			Next i
			FList.Clear
		#endif
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Sub ImageListAddFromFile Alias "ImageListAddFromFile"(imgList As My.Sys.Forms.ImageList Ptr, ByRef File As WString, ByRef Key As WString = "") __EXPORT__
		imgList->AddFromFile(File, Key)
	End Sub
	
	Sub ImageListAddFromResourceName Alias "ImageListAddFromResourceName" (imgList As My.Sys.Forms.ImageList Ptr, ByRef ResName As WString, ByRef Key As WString = "") __EXPORT__
		imgList->Add(ResName, Key)
	End Sub
	
	Function ImageListIndexOf Alias "ImageListIndexOf" (imgList As My.Sys.Forms.ImageList Ptr, ByRef Key As WString) As Integer __EXPORT__
		Return imgList->IndexOf(Key)
	End Function
	
	Sub ImageListClear Alias "ImageListClear" (imgList As My.Sys.Forms.ImageList Ptr) __EXPORT__
		imgList->Clear
	End Sub
#endif
