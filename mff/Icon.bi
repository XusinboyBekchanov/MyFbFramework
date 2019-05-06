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

#Include Once "Object.bi"
#Include Once "Bitmap.bi"

Namespace My.Sys.Drawing
    Type Icon Extends My.Sys.Object
        Private:
            FWidth  As Integer
            FHeight As Integer
            FResName As WString Ptr
        Public:
            Graphic As Any Ptr
            #IfDef __USE_GTK__
				Handle As GdkPixBuf Ptr
            #Else
				Handle  As HICON
			#EndIf
            Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property ResName ByRef As WString
            Declare Property ResName(ByRef Value As WString)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Sub LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0)
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromResourceName(ByRef ResName As WString, cx As Integer = 0, cy As Integer = 0)
            Declare Sub LoadFromResourceID(ResID As Integer, cx As Integer = 0, cy As Integer = 0)
            #IfNDef __USE_GTK__
				Declare Function ToBitmap() As hBitmap
			#EndIf
            Declare Operator Cast As Any Ptr
            Declare Operator Cast As WString Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Operator Let(Value As Integer)
            #IfNDef __USE_GTK__
				Declare Operator Let(Value As HICON)
			#EndIf
            Declare Constructor
            Declare Destructor
            Changed As Sub(BYREF Sender As Icon)
    End Type

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

	#IfNDef __USE_GTK__
		Function Icon.ToBitmap() As hBitmap
			Dim As HWND desktop = GetDesktopWindow()
			if (desktop = NULL) Then
				return NULL
			End If
			
			Dim As HDC screen_dev = GetDC(desktop)
			if (screen_dev = NULL) Then
				return NULL
			End If

			' Create a compatible DC
			Dim As HDC dst_hdc = CreateCompatibleDC(screen_dev)
			if (dst_hdc = NULL) Then
				ReleaseDC(desktop, screen_dev)
				return NULL
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
			if (old_dst_bmp = NULL) Then
				return NULL
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
			return bmp
		End Function
	#EndIf
			
    Sub Icon.LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0)
        #IfDef __USE_GTK__
			Dim As GError Ptr gerr
			If cx = 0 AndAlso cy = 0 Then
				Handle = gdk_pixbuf_new_from_file(ToUTF8(File), @gerr)
			Else
				Handle = gdk_pixbuf_new_from_file_at_size(ToUTF8(File), cx, cy, @gerr)
			End If
        #Else
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(0, File, IMAGE_CURSOR, 0, 0, LR_LOADFROMFILE)
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#EndIf
        If Changed Then Changed(This)
        This.ResName = File
    End Sub

    Sub Icon.SaveToFile(ByRef File As WString)
    End Sub

    Sub Icon.LoadFromResourceName(ByRef ResourceName As WString, cx As Integer = 0, cy As Integer = 0)
        #IfNDef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			This.ResName = ResourceName
			Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_ICON, cx, cy, LR_COPYFROMRESOURCE)
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#EndIf
        If Changed Then Changed(This)
    End Sub

    Sub Icon.LoadFromResourceID(ResID As Integer, cx As Integer = 0, cy As Integer = 0)
        #IfNDef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			This.ResName = WStr(ResID)
			Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_ICON, cx, cy, LR_COPYFROMRESOURCE)
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
		#EndIf
        If Changed Then Changed(This)
    End Sub

    Operator Icon.Cast As Any Ptr
        Return @This
    End Operator

    Operator Icon.Cast As WString Ptr
        Return This.FResName
    End Operator

    Operator Icon.Let(ByRef Value As WString)
        #IfNDef __USE_GTK__
			If FindResource(GetModuleHandle(NULL), Value, RT_ICON) Then
			   LoadFromResourceName(Value) 
			Else
			   LoadFromFile(Value)
			End If
		#Else
			LoadFromFile(Value)
		#EndIf
        This.ResName = Value
    End Operator

    Operator Icon.Let(Value As Integer)
		LoadFromResourceID(Value) 
        This.ResName = WStr(Value)
    End Operator

	#IfNDef __USE_GTK__
		Operator Icon.Let(Value As HICON)
			Handle = Value
		End Operator
	#EndIf

    Constructor Icon
        WLet FClassName, "Icon"
    End Constructor

    Destructor Icon
    	WDeallocate FResName
    End Destructor
End namespace
