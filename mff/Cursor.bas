'******************************************************************************
'* Cursor.bi                                                                  *
'* Authors: Nastase Eodor, Xusinboy Bekchanov                                 *
'* Based on:                                                                  *
'*  TCursor                                                                   *
'*  This file is part of FreeBasic Windows GUI ToolKit                        *
'*  Copyright (c) 2007-2008 Nastase Eodor                                     *
'*  Version 1.0.0                                                             *
'*  nastase_eodor@yahoo.com                                                   *
'* Updated and added cross-platform                                          *
'* by Xusinboy Bekchanov (2018-2019)                                         *
'******************************************************************************

#include once "Cursor.bi"

Namespace My.Sys.Drawing
	Property Cursor.Width As Integer
		Return FWidth
	End Property
	
	Property Cursor.Width(Value As Integer)
		FWidth = Value
	End Property
	
	Property Cursor.Height As Integer
		Return FHeight
	End Property
	
	Property Cursor.Height(Value As Integer)
		FHeight = Value
	End Property
	
	Property Cursor.HotSpotX As Integer
		Return FHotSpotX
	End Property
	
	Property Cursor.HotSpotX(Value As Integer)
		FHotSpotX = Value
	End Property
	
	Property Cursor.HotSpotY As Integer
		Return FHotSpotY
	End Property
	
	Property Cursor.HotSpotY(Value As Integer)
		FHotSpotY = Value
	End Property
	
	Function Cursor.LoadFromFile(ByRef File As WString) As Boolean
		#ifndef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(0,File,IMAGE_CURSOR,0,0,LR_LOADFROMFILE)
			If Handle = 0 Then Return False
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#endif
		If Changed Then Changed(This)
		Return True
	End Function
	
	Function Cursor.SaveToFile(ByRef File As WString) As Boolean
		Return False
	End Function
	
	Function Cursor.LoadFromResourceName(ByRef ResName As WString) As Boolean
		#ifndef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
			If handle = 0 Then Return False
			GetIconInfo(Handle,@ICIF)
			GetObject(ICIF.hbmColor,SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#endif
		If Changed Then Changed(This)
		Return True
	End Function
	
	Function Cursor.LoadFromResourceID(ResID As Integer) As Boolean
		#ifndef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
			If handle = 0 Then Return False
			GetIconInfo(Handle,@ICIF)
			GetObject(ICIF.hbmColor,SizeOf(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#endif
		If Changed Then Changed(This)
		Return True
	End Function
	
	Sub Cursor.Create
	End Sub
	
	Operator Cursor.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator Cursor.Let(ByRef Value As WString)
		WLet FResName, Value
		#ifndef __USE_GTK__
			If FindResourceW(GetModuleHandle(NULL), Value, RT_GROUP_CURSOR) Then
				LoadFromResourceName(Value)
			Else
				LoadFromFile(Value)
			End If
		#else
			If Ctrl AndAlso Ctrl->widget Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->widget)
				Handle = gdk_cursor_new_from_name(pdisplay, Value)
				Dim As GdkWindow Ptr win
				If gtk_is_layout(Ctrl->widget) Then
					win = gtk_layout_get_bin_window(gtk_layout(Ctrl->widget))
				Else
					win = gtk_widget_get_parent_window(Ctrl->widget)
				End If
				If win Then gdk_window_set_cursor(win, Handle)
			End If
		#endif
	End Operator
	
	Function Cursor.ToString() ByRef As WString
		Return *FResName
	End Function
	
	#ifndef __USE_GTK__
		Function Cursor.ToBitmap() As hBitmap
			Dim As BitmapType bmpType
			bmpType = Handle
			Return bmpType.Handle
		End Function
	#endif
	
	#ifdef __USE_GTK__
		Operator Cursor.Let(Value As GdkCursorType)
			If Ctrl AndAlso Ctrl->widget Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->widget)
				Handle = gdk_cursor_new_for_display(pdisplay, Value)
			End If
		End Operator
		
	#else
		Operator Cursor.Let(Value As HCURSOR)
			Handle = Value
		End Operator
	#endif
	
	Operator Cursor.Let(Value As Cursor)
		Handle = Value.Handle
	End Operator
	
	Constructor Cursor
		WLet(FClassName, "Cursor")
'		#ifndef __USE_GTK__
'			Handle = LoadCursor(NULL,IDC_ARROW)
'		#endif
		If Changed Then Changed(This)
	End Constructor
	
	Destructor Cursor
		WDeallocate FResName
		#ifndef __USE_GTK__
			If Handle Then DeleteObject Handle
		#endif
	End Destructor
End Namespace

Sub CursorLoadFromFile Alias "CursorLoadFromFile"(Cur As My.Sys.Drawing.Cursor Ptr, ByRef File As WString) __EXPORT__
	Cur->LoadFromFile(File)
End Sub
