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

#Include Once "Graphics.bi"
#Include Once "Component.bi"
#Include Once "WStringList.bi"

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	#IfDef __USE_GTK__
		Enum DrawingStyle
			 dsFocus
			 dsNormal
			 dsSelected
			 dsTransparent
			 dsBlend
			 dsBlend25
			 dsBlend50
		End Enum

		Enum ImagesType
			 itImage = 0
			 itMask
		End Enum
    #Else
		Enum DrawingStyle
			 dsFocus       = ILD_FOCUS
			 dsNormal      = ILD_NORMAL
			 dsSelected    = ILD_SELECTED
			 dsTransparent = ILD_TRANSPARENT
			 dsBlend       = ILD_BLEND
			 dsBlend25     = ILD_BLEND25
			 dsBlend50     = ILD_BLEND50
		End Enum

		Enum ImagesType
			 itImage = 0
			 itMask  = ILD_MASK
		End Enum
	#EndIf

    Type ImageList Extends Component
        Private:
            FParentWindow As Component Ptr
            FWidth        As Integer
            FHeight       As Integer
            FBKColor      As Integer
            FCount        As Integer
            FKeys            As WStringList
            Declare Sub Create
            Declare Sub NotifyWindow
        Public:
			#IfDef __USE_GTK__
				Widget 			As GtkIconTheme Ptr
			#Else
			    Handle        As HIMAGELIST
			#ENdIf
            AllocBy       As Integer
            ImageType     As ImagesType
            DrawingStyle  As DrawingStyle
            Declare Property ParentWindow As Component Ptr
            Declare Property ParentWindow(Value As Component Ptr)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property BKColor As Integer
            Declare Property BKColor(Value As Integer)
            Declare Property Count As Integer
            Declare Sub AddBitmap(Bitmap As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
            Declare Sub AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
            #IfNDef __USE_GTK__
				Declare Sub AddIcon(Ico As String, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
            #EndIf
            Declare Sub AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
            Declare Sub AddMasked(ByRef Bitmap As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
            #IfDef __USE_GTK__
				Declare Sub AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "")
            #Else
				Declare Sub AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
            #EndIf
            #IfDef __USE_GTK__
				Declare Sub AddPng(ByRef Png As WString, ByRef Key As WString = "")
            #Else
				Declare Sub AddPng(ByRef Png As WString, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
            #EndIf
            Declare Sub Remove(Index As Integer)
            Declare Sub Remove(ByRef Key As WString)
            Declare Function GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
            Declare Function GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
            Declare Function GetIcon(Index As Integer) As My.Sys.Drawing.Icon
            Declare Function GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
            Declare Function GetBitmap(ByRef Key As WString) ByRef As My.Sys.Drawing.BitmapType
            Declare Function GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
            Declare Function GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
            Declare Function GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
            Declare Function IndexOf(ByRef Key As WString) As Integer
            #IfNDef __USE_GTK__
            	Declare Sub DrawEx(Index As Integer, DestDC As HDC, X As Integer, Y As Integer, iWidth As Integer, iHeight As Integer, FG As Integer, BK As Integer)
            	Declare Sub Draw(Index As Integer, DestDC As HDC, X As Integer, Y As Integer)
            #Endif
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnChange As Sub(BYREF Sender As ImageList)
    End Type

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
        #IfNDef __USE_GTK__
        	ImageList_SetIconSize(Handle,FWidth,FHeight)
        #EndIf
        NotifyWindow
    End Property

    Property ImageList.Height As Integer
        Return FHeight
    End Property

    Property ImageList.Height(Value As Integer)
        FHeight = Value
        #IfNDef __USE_GTK__
        	ImageList_SetIconSize(Handle,FWidth,FHeight)
        #EndIf
        NotifyWindow
    End Property

    Property ImageList.BKColor As Integer
        #IfNDef __USE_GTK__
			FBKColor = ImageList_GetBKColor(Handle)
        #EndIf
        Return FBKColor
    End Property

    Property ImageList.BKColor(Value As Integer)
        FBKColor = Value
        #IfNDef __USE_GTK__
			         ImageList_SetBKColor(Handle,FBKColor)
        #EndIf
        NotifyWindow
    End Property

    Property ImageList.Count As Integer
        #IfNDef __USE_GTK__
			         FCount = ImageList_GetImageCount(Handle)
        #EndIf
        Return FCount
    End Property

    Function ImageList.IndexOf(ByRef Key As WString) As Integer
        Return FKeys.IndexOf(Key)
    End Function

    Sub ImageList.NotifyWindow
        If ParentWindow Then
			     #IfNDef __USE_GTK__
            If ParentWindow->Handle Then RedrawWindow ParentWindow->Handle,0,0,RDW_ERASE OR RDW_INVALIDATE
			     #EndIf
        End If
    End Sub

    Sub ImageList.Create
		#IfNDef __USE_GTK__
			If Handle Then ImageList_Destroy Handle
			Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLOR32,AllocBy,AllocBy)
		#EndIf
    End Sub

    Sub ImageList.AddBitmap(Bmp As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
        FKeys.Add(Key)
        #IfNDef __USE_GTK__
			ImageList_Add(Handle, Bmp.Handle, Mask.Handle)
		#EndIf
    End Sub

    Sub ImageList.AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
        FKeys.Add(Key)
        #IfNDef __USE_GTK__
			ImageList_AddIcon(Handle,Icon.Handle)
		#EndIf
    End Sub
    
    #IfNDef __USE_GTK__
		Sub ImageList.AddIcon(Ico As String, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
			Dim As My.Sys.Drawing.Icon Icn
			Icn.LoadFromResourceName(Ico)
			If Icn.Handle Then
				FKeys.Add(Key)
				ImageList_AddIcon(Handle, Icn.Handle)
			End If
		End Sub
	#EndIf

    Sub ImageList.AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
        FKeys.Add(Key)
        #IfNDef __USE_GTK__
			ImageList_AddIcon(Handle,Cursor.Handle)
		#EndIf
    End Sub

    Sub ImageList.AddMasked(ByRef Bmp As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
        FKeys.Add(Key)
        #IfNDef __USE_GTK__
			ImageList_AddMasked(Handle, Bmp.Handle,MaskColor)
		#EndIf
        NotifyWindow
    End Sub

	#IfDef __USE_GTK__
		Sub ImageList.AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "")
	#Else
		Sub ImageList.AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
	#EndIf
		#IfNDef __USE_GTK__
			Dim As My.Sys.Drawing.BitmapType Bitm
			Bitm.LoadFromResourceName(Bmp, ModuleHandle)
			If Bitm.Handle Then
				FKeys.Add(Key)
				ImageList_AddMasked(Handle, Bitm.Handle, MaskColor)
				NotifyWindow
			End If
		#EndIf
	End Sub
	
	#IfDef __USE_GTK__
		Sub ImageList.AddPng(ByRef Png As WString, ByRef Key As WString = "")
	#Else
		Sub ImageList.AddPng(ByRef Png As WString, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
	#EndIf
		#IfNDef __USE_GTK__
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
					GdipCreateBitmapFromStream(pngstream, CAST(GpBitmap PTR PTR, @pImage))
					' Create icon from image
					GdipCreateHBitmapFromBitmap(CAST(GpBitmap PTR, pImage), @hImage, clWhite)
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
		#EndIf
	End Sub
	
    Sub ImageList.Remove(Index As Integer)
		#IfNDef __USE_GTK__
			ImageList_Remove(Handle,Index)
		#EndIf
    End Sub

    Sub ImageList.Remove(ByRef Key As WString)
        Remove(IndexOf(Key))
    End Sub

    Function ImageList.GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
        Dim As My.Sys.Drawing.BitmapType Ptr BMP
        #IfNDef __USE_GTK__
			Dim IMIF As IMAGEINFO
			BMP = cAllocate(SizeOF(My.Sys.Drawing.BitmapType))
			ImageList_GetImageInfo(Handle,Index,@IMIF)
			BMP->Handle = IMIF.hbmImage
		#EndIf
        Return *BMP
    End Function

    Function ImageList.GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
        Dim As My.Sys.Drawing.BitmapType Ptr BMP
        #IfNDef __USE_GTK__
			Dim IMIF As IMAGEINFO
			BMP = cAllocate(SizeOF(My.Sys.Drawing.BitmapType))
			ImageList_GetImageInfo(Handle,Index,@IMIF)
			BMP->Handle = IMIF.hbmMask
		#EndIf
        Return *BMP
    End Function

    Function ImageList.GetIcon(Index As Integer) As My.Sys.Drawing.Icon
        Dim As My.Sys.Drawing.Icon Ptr ICO
        ICO = cAllocate(SizeOF(My.Sys.Drawing.Icon))
        #IfNDef __USE_GTK__
			ICO->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
		#EndIf
        Return *ICO
    End Function

    Function ImageList.GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
        Dim As My.Sys.Drawing.Cursor Ptr CUR
        CUR = cAllocate(SizeOF(My.Sys.Drawing.Cursor))
        #IfNDef __USE_GTK__
			CUR->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
        #EndIf
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

	#IfNDef __USE_GTK__
		Sub ImageList.DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
			ImageList_DrawEx(Handle,Index,DestDC,X,Y,iWidth,iHeight,FG,BK,DrawingStyle OR ImageType) 
		End Sub	

		Sub ImageList.Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
			 ImageList_Draw(Handle,Index,DestDC,X,Y,DrawingStyle OR ImageType)
		End Sub
    #EndIf

    Sub ImageList.Clear
        Dim As Integer i
        For i = 0 To Count -1
			#IfNDef __USE_GTK__
				ImageList_Remove(Handle,i)
			#EndIf
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
        #IfDef __USE_GTK__
        	widget = gtk_icon_theme_new()
        #Else
			Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLORDDB,AllocBy,AllocBy)
		#EndIf
    End Constructor

    Destructor ImageList
		#IfNDef __USE_GTK__
			If Handle Then ImageList_Destroy Handle
		#EndIf
    End Destructor
End namespace
