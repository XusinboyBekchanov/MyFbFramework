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
	Property ImageList.ParentWindow As Component Ptr
		Return FParentWindow
	End Property
	
	Property ImageList.ParentWindow(Value As Component Ptr)
		FParentWindow = Value
		NotifyWindow
	End Property
	
	Property ImageList.Width As Integer
		Return FWidth
	End Property
	
	Property ImageList.Width(Value As Integer)
		FWidth = Value
		#ifndef __USE_GTK__
			ImageList_SetIconSize(Handle,FWidth,FHeight)
		#endif
		NotifyWindow
	End Property
	
	Property ImageList.Height As Integer
		Return FHeight
	End Property
	
	Property ImageList.Height(Value As Integer)
		FHeight = Value
		#ifndef __USE_GTK__
			ImageList_SetIconSize(Handle,FWidth,FHeight)
		#endif
		NotifyWindow
	End Property
	
	Property ImageList.BKColor As Integer
		#ifndef __USE_GTK__
			FBKColor = ImageList_GetBKColor(Handle)
		#endif
		Return FBKColor
	End Property
	
	Property ImageList.BKColor(Value As Integer)
		FBKColor = Value
		#ifndef __USE_GTK__
			ImageList_SetBKColor(Handle,FBKColor)
		#endif
		NotifyWindow
	End Property
	
	Property ImageList.Count As Integer
		#ifndef __USE_GTK__
			FCount = ImageList_GetImageCount(Handle)
		#endif
		Return FCount
	End Property
	
	Function ImageList.IndexOf(ByRef Key As WString) As Integer
		Return FKeys.IndexOf(Key)
	End Function
	
	Sub ImageList.NotifyWindow
		If ParentWindow Then
			#ifndef __USE_GTK__
				If ParentWindow->Handle Then RedrawWindow ParentWindow->Handle,0,0,RDW_ERASE Or RDW_INVALIDATE
			#endif
		End If
	End Sub
	
	Sub ImageList.Create
		#ifndef __USE_GTK__
			If Handle Then ImageList_Destroy Handle
			Handle = ImageList_Create(FWidth,FHeight,ILC_MASK Or ILC_COLOR32,AllocBy,AllocBy)
		#endif
	End Sub
	
	Sub ImageList.AddBitmap(Bmp As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
		FKeys.Add(Key)
		#ifndef __USE_GTK__
			ImageList_Add(Handle, Bmp.Handle, Mask.Handle)
		#endif
	End Sub
	
	Sub ImageList.AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
		FKeys.Add(Key)
		#ifndef __USE_GTK__
			ImageList_AddIcon(Handle,Icon.Handle)
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Sub ImageList.AddIcon(Ico As String, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
			Dim As My.Sys.Drawing.Icon Icn
			Icn.LoadFromResourceName(Ico)
			If Icn.Handle Then
				FKeys.Add(Key)
				ImageList_AddIcon(Handle, Icn.Handle)
			End If
		End Sub
	#endif
	
	Sub ImageList.AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
		FKeys.Add(Key)
		#ifndef __USE_GTK__
			ImageList_AddIcon(Handle,Cursor.Handle)
		#endif
	End Sub
	
	Sub ImageList.AddMasked(ByRef Bmp As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
		FKeys.Add(Key)
		#ifndef __USE_GTK__
			ImageList_AddMasked(Handle, Bmp.Handle,MaskColor)
		#endif
		NotifyWindow
	End Sub
	
	#ifdef __USE_GTK__
		Sub ImageList.AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "")
	#else
		Sub ImageList.AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
	#endif
		#ifndef __USE_GTK__
			Dim As My.Sys.Drawing.BitmapType Bitm
			Bitm.LoadFromResourceName(Bmp, ModuleHandle)
			If Bitm.Handle Then
				FKeys.Add(Key)
				ImageList_AddMasked(Handle, Bitm.Handle, MaskColor)
				NotifyWindow
			End If
		#endif
	End Sub
	
	#ifdef __USE_GTK__
		Sub ImageList.AddPng(ByRef Png As WString, ByRef Key As WString = "")
	#else
		Sub ImageList.AddPng(ByRef Png As WString, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
	#endif
		#ifndef __USE_GTK__
			Dim As HRSRC hPicture = FindResourceW(ModuleHandle, Png, "PNG")
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
					Dim pImage As GpImage Ptr, hImage As HBitmap
					' Create a bitmap from the data contained in the stream
					GdipCreateBitmapFromStream(pngstream, Cast(GpBitmap Ptr Ptr, @pImage))
					' Create icon from image
					GdipCreateHBitmapFromBitmap(Cast(GpBitmap Ptr, pImage), @hImage, clWhite)
					' Free the image
					If pImage Then GdipDisposeImage pImage
					pngstream->lpVtbl->Release(pngstream)
					FKeys.Add(Key)
					'ImageList_AddIcon(Handle, hImage)
					ImageList_AddMasked(Handle, hImage, clWhite)
					NotifyWindow
				End If
			End If
			' Unlock the memory
			GlobalUnlock pData
			' Free the memory
			GlobalFree hGlobal
			' Shutdown Gdiplus
			GdiplusShutdown token
		#endif
	End Sub
	
	Sub ImageList.Remove(Index As Integer)
		#ifndef __USE_GTK__
			ImageList_Remove(Handle,Index)
		#endif
	End Sub
	
	Sub ImageList.Remove(ByRef Key As WString)
		Remove(IndexOf(Key))
	End Sub
	
	Function ImageList.GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
		Dim As My.Sys.Drawing.BitmapType Ptr BMP
		#ifndef __USE_GTK__
			Dim IMIF As ImageInfo
			BMP = CAllocate(SizeOf(My.Sys.Drawing.BitmapType))
			ImageList_GetImageInfo(Handle,Index,@IMIF)
			BMP->Handle = IMIF.hbmImage
		#endif
		Return *BMP
	End Function
	
	Function ImageList.GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
		Dim As My.Sys.Drawing.BitmapType Ptr BMP
		#ifndef __USE_GTK__
			Dim IMIF As ImageInfo
			BMP = CAllocate(SizeOf(My.Sys.Drawing.BitmapType))
			ImageList_GetImageInfo(Handle,Index,@IMIF)
			BMP->Handle = IMIF.hbmMask
		#endif
		Return *BMP
	End Function
	
	Function ImageList.GetIcon(Index As Integer) As My.Sys.Drawing.Icon
		Dim As My.Sys.Drawing.Icon Ptr ICO
		ICO = CAllocate(SizeOf(My.Sys.Drawing.Icon))
		#ifndef __USE_GTK__
			ICO->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle Or ImageType)
		#endif
		Return *ICO
	End Function
	
	Function ImageList.GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
		Dim As My.Sys.Drawing.Cursor Ptr CUR
		CUR = CAllocate(SizeOf(My.Sys.Drawing.Cursor))
		#ifndef __USE_GTK__
			CUR->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle Or ImageType)
		#endif
		Return *CUR
	End Function
	
	Function ImageList.GetBitmap(ByRef Key As WString) ByRef As My.Sys.Drawing.BitmapType
		Return GetBitmap(IndexOf(Key))
	End Function
	
	Function ImageList.GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Return GetMask(IndexOf(Key))
	End Function
	
	Function ImageList.GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
		Return GetIcon(IndexOf(Key))
	End Function
	
	Function ImageList.GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
		Return GetCursor(IndexOf(Key))
	End Function
	
	#ifndef __USE_GTK__
		Sub ImageList.DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
			ImageList_DrawEx(Handle,Index,DestDC,X,Y,iWidth,iHeight,FG,BK,DrawingStyle Or ImageType)
		End Sub
		
		Sub ImageList.Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
			ImageList_Draw(Handle,Index,DestDC,X,Y,DrawingStyle Or ImageType)
		End Sub
	#endif
	
	Sub ImageList.Clear
		Dim As Integer i
		For i = 0 To Count -1
			#ifndef __USE_GTK__
				ImageList_Remove(Handle,i)
			#endif
		Next i
	End Sub
	
	Operator ImageList.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ImageList
		WLet FClassName, "ImageList"
		AllocBy = 4
		FWidth  = 16
		FHeight = 16
		#ifdef __USE_GTK__
			widget = gtk_icon_theme_new()
		#else
			Handle = ImageList_Create(FWidth,FHeight,ILC_MASK Or ILC_COLORDDB,AllocBy,AllocBy)
		#endif
	End Constructor
	
	Destructor ImageList
		#ifndef __USE_GTK__
			If Handle Then ImageList_Destroy Handle
		#endif
	End Destructor
End Namespace
