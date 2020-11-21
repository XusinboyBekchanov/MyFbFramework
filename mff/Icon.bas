'###############################################################################
'#  Icon.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TIcon.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################
#include once "Icon.bi"

Namespace My.Sys.Drawing
	Function Icon.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "height": Return @FHeight
		Case "width": Return @FWidth
		Case "resname": Return FResName
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Icon.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value <> 0 Then
			Select Case LCase(PropertyName)
			Case "height": This.Height = QInteger(Value)
			Case "width": This.Width = QInteger(Value)
			Case "resname": This.ResName = QWString(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property Icon.ResName ByRef As WString
		Return WGet(FResName)
	End Property
	
	Property Icon.ResName(ByRef Value As WString)
		WLet FResName, Value
	End Property
	
	Property Icon.Width As Integer
		Return FWidth
	End Property
	
	Property Icon.Width(Value As Integer)
	End Property
	
	Property Icon.Height As Integer
		Return FWidth
	End Property
	
	Property Icon.Height(Value As Integer)
	End Property
	
	#ifndef __USE_GTK__
		Function Icon.ToBitmap() As hBitmap
			Dim As HWND desktop = GetDesktopWindow()
			If (desktop = NULL) Then
				Return NULL
			End If
			
			Dim As HDC screen_dev = GetDC(desktop)
			If (screen_dev = NULL) Then
				Return NULL
			End If
			
			' Create a compatible DC
			Dim As HDC dst_hdc = CreateCompatibleDC(screen_dev)
			If (dst_hdc = NULL) Then
				ReleaseDC(desktop, screen_dev)
				Return NULL
			End If
			
			' Create a new bitmap of icon size
			Dim As HBITMAP bmp = CreateCompatibleBitmap(screen_dev, 16, 16)
			If (bmp = NULL) Then
				DeleteDC(dst_hdc)
				ReleaseDC(desktop, screen_dev)
				Return NULL
			End If
			
			'Select it into the compatible DC
			Dim As HBITMAP old_dst_bmp = Cast(HBITMAP, SelectObject(dst_hdc, bmp))
			If (old_dst_bmp = NULL) Then
				Return NULL
			End If
			
			' Fill the background of the compatible DC with the given colour
			'SetBkColor(dst_hdc, RGB(255, 255, 255))
			'ExtTextOut(dst_hdc, 0, 0, ETO_OPAQUE, @rect, NULL, 0, NULL)
			
			' Draw the icon into the compatible DC
			DrawIconEx(dst_hdc, 0, 0, Handle, 16, 16, 0, GetSysColorBrush( COLOR_MENU ), DI_NORMAL)
			
			' Restore settings
			SelectObject(dst_hdc, old_dst_bmp)
			DeleteDC(dst_hdc)
			ReleaseDC(desktop, screen_dev)
			'DestroyIcon(hIcon)
			Return bmp
		End Function
	#endif
	
	Function Icon.LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0) As Boolean
		#ifdef __USE_GTK__
			Dim As GError Ptr gerr
			If cx = 0 AndAlso cy = 0 Then
				Handle = gdk_pixbuf_new_from_file(ToUTF8(File), @gerr)
			Else
				Handle = gdk_pixbuf_new_from_file_at_size(ToUTF8(File), cx, cy, @gerr)
			End If
			If Handle = 0 Then Return False
		#else
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(0, File, IMAGE_CURSOR, 0, 0, LR_LOADFROMFILE)
			If Handle = 0 Then Return False
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
		This.ResName = File
		Return True
	End Function
	
	Function Icon.SaveToFile(ByRef File As WString) As Boolean
		Return False
	End Function
	
	Function Icon.LoadFromResourceName(ByRef ResourceName As WString, cx As Integer = 0, cy As Integer = 0) As Boolean
		#ifndef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			This.ResName = ResourceName
			Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_ICON, cx, cy, LR_COPYFROMRESOURCE)
			If Handle = 0 Then Return False
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
		Return True
	End Function
	
	Function Icon.LoadFromResourceID(ResID As Integer, cx As Integer = 0, cy As Integer = 0) As Boolean
		#ifndef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			This.ResName = WStr(ResID)
			Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_ICON, cx, cy, LR_COPYFROMRESOURCE)
			If Handle = 0 Then Return False
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#endif
		If Changed Then Changed(This)
		Return True
	End Function
	
	Operator Icon.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator Icon.Cast As WString Ptr
		Return This.FResName
	End Operator
	
	Operator Icon.Let(ByRef Value As WString)
		#ifndef __USE_GTK__
			If Not LoadFromResourceName(Value) Then
				LoadFromFile(Value)
			End If
		#else
			LoadFromFile(Value)
		#endif
		This.ResName = Value
	End Operator
	
	Operator Icon.Let(Value As Integer)
		LoadFromResourceID(Value)
		This.ResName = WStr(Value)
	End Operator
	
	#ifndef __USE_GTK__
		Operator Icon.Let(Value As HICON)
			Handle = Value
		End Operator
	#endif
	
	Constructor Icon
		WLet FClassName, "Icon"
	End Constructor
	
	Destructor Icon
		WDeallocate FResName
		#ifndef __USE_GTK__
			DeleteObject Handle
		#endif
	End Destructor
End Namespace
