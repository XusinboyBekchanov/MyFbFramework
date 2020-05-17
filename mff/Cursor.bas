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

#Include Once "Cursor.bi"

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
	
	Sub Cursor.LoadFromFile(ByRef File As WString)
		#IfNDef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(0,File,IMAGE_CURSOR,0,0,LR_LOADFROMFILE)
			GetIconInfo(Handle, @ICIF)
			GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#ENdIf
		If Changed Then Changed(This)
	End Sub
	
	Sub Cursor.SaveToFile(ByRef File As WString)
	End Sub
	
	Sub Cursor.LoadFromResourceName(ByRef ResName As WString)
		#IfNDef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
			GetIconInfo(Handle,@ICIF)
			GetObject(ICIF.hbmColor,SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#EndIf
		If Changed Then Changed(This)
	End Sub
	
	Sub Cursor.LoadFromResourceID(ResID As Integer)
		#IfNDef __USE_GTK__
			Dim As ICONINFO ICIF
			Dim As BITMAP BMP
			Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
			GetIconInfo(Handle,@ICIF)
			GetObject(ICIF.hbmColor,SizeOF(BMP), @BMP)
			FWidth  = BMP.bmWidth
			FHeight = BMP.bmHeight
			FHotSpotX = ICIF.xHotSpot
			FHotSpotY = ICIF.yHotSpot
		#EndIf
		If Changed Then Changed(This)
	End Sub
	
	Sub Cursor.Create
	End Sub
	
	Operator Cursor.Cast As Any Ptr
		Return @This
	End Operator
	
	Operator Cursor.Let(ByRef Value As WString)
		#IfNDef __USE_GTK__
			If FindResource(GetModuleHandle(NULL), Value, RT_CURSOR) Then
				LoadFromResourceName(Value)
			Else
				LoadFromFile(Value)
			End If
		#Else
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
		#EndIf
	End Operator
	
	#IfDef __USE_GTK__
		Operator Cursor.Let(Value As GdkCursorType)
			If Ctrl AndAlso Ctrl->widget Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->widget)
				Handle = gdk_cursor_new_for_display(pdisplay, Value)
			End If
		End Operator
		
	#Else
		Operator Cursor.Let(Value As HCURSOR)
			Handle = Value
		End Operator
	#EndIf
	
	Operator Cursor.Let(Value As Cursor)
		Handle = Value.Handle
	End Operator
	
	Constructor Cursor
		WLet FClassName, "Cursor"
		#IfNDef __USE_GTK__
			Handle = LoadCursor(NULL,IDC_ARROW)
		#EndIf
		If Changed Then Changed(This)
	End Constructor
	
	Destructor Cursor
		#IfNDef __USE_GTK__
			If Handle Then DeleteObject Handle
		#EndIf
	End Destructor
End namespace
