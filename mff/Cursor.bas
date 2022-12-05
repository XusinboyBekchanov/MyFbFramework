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
#include once "Bitmap.bi"

Namespace My.Sys.Drawing
	#ifndef ReadProperty_Off
		Private Function Cursor.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "graphic": Return @Graphic
			Case "height": Return @FHeight
			Case "hotspotx": Return @FHotSpotX
			Case "hotspoty": Return @FHotSpotY
			Case "width": Return @FWidth
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Cursor.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "height": This.Height = QInteger(Value)
				Case "hotspotx": This.HotSpotX = QInteger(Value)
				Case "hotspoty": This.HotSpotY = QInteger(Value)
				Case "width": This.Width = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Cursor.Width As Integer
		Return FWidth
	End Property
	
	Private Property Cursor.Width(Value As Integer)
		FWidth = Value
	End Property
	
	Private Property Cursor.Height As Integer
		Return FHeight
	End Property
	
	Private Property Cursor.Height(Value As Integer)
		FHeight = Value
	End Property
	
	Private Property Cursor.HotSpotX As Integer
		Return FHotSpotX
	End Property
	
	Private Property Cursor.HotSpotX(Value As Integer)
		FHotSpotX = Value
	End Property
	
	Private Property Cursor.HotSpotY As Integer
		Return FHotSpotY
	End Property
	
	Private Property Cursor.HotSpotY(Value As Integer)
		FHotSpotY = Value
	End Property
	
	#ifndef Cursor_LoadFromFile_Off
		Private Function Cursor.LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0) As Boolean
			#ifdef __USE_WINAPI__
				Dim As ICONINFO ICIF
				Dim As BITMAP BMP
				If Handle Then DestroyCursor(Handle)
				Handle = LoadImage(0, File, IMAGE_CURSOR, cx, cy, LR_LOADFROMFILE)
				If Handle = 0 Then Return False
				GetIconInfo(Handle, @ICIF)
				GetObject(ICIF.hbmColor, SizeOf(BMP), @BMP)
				FWidth  = BMP.bmWidth
				FHeight = BMP.bmHeight
				FHotSpotX = ICIF.xHotspot
				FHotSpotY = ICIF.yHotspot
				DeleteObject(ICIF.hbmColor)
				DeleteObject(ICIF.hbmMask)
			#endif
			If Changed Then Changed(This)
			Return True
		End Function
	#endif
	
	#ifndef Cursor_SaveToFile_Off
		Private Function Cursor.SaveToFile(ByRef File As WString) As Boolean
			Return False
		End Function
	#endif
	
	#ifndef Cursor_LoadFromResourceName_Off
		Private Function Cursor.LoadFromResourceName(ByRef ResName As WString, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
			#ifdef __USE_WINAPI__
				Dim As ICONINFO ICIF
				Dim As BITMAP BMP
				Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
				If Handle Then DestroyCursor(Handle)
				Handle = LoadImage(ModuleHandle_, ResName, IMAGE_CURSOR, cxDesired, cyDesired, LR_COPYFROMRESOURCE)
				If Handle = 0 Then Return False
	'			GetIconInfo(Handle, @ICIF)
	'			GetObject(ICIF.hbmColor,SizeOf(BMP), @BMP)
	'			FWidth  = BMP.bmWidth
	'			FHeight = BMP.bmHeight
	'			FHotSpotX = ICIF.xHotSpot
	'			FHotSpotY = ICIF.yHotSpot
	'			?DeleteObject(ICIF.hbmColor)
	'			?DeleteObject(ICIF.hbmMask)
			#endif
			If Changed Then Changed(This)
			Return True
		End Function
	#endif
	
	#ifndef Cursor_LoadFromResourceID_Off
		Private Function Cursor.LoadFromResourceID(ResID As Integer, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
			#ifdef __USE_WINAPI__
				Dim As ICONINFO ICIF
				Dim As BITMAP BMP
				Dim As Any Ptr ModuleHandle_ = ModuleHandle: If ModuleHandle = 0 Then ModuleHandle_ = GetModuleHandle(NULL)
				If Handle Then DestroyCursor(Handle)
				Handle = LoadImage(ModuleHandle_, MAKEINTRESOURCE(ResID), IMAGE_CURSOR, cxDesired, cyDesired, LR_COPYFROMRESOURCE)
				If Handle = 0 Then Return False
				GetIconInfo(Handle,@ICIF)
				GetObject(ICIF.hbmColor,SizeOf(BMP), @BMP)
				FWidth  = BMP.bmWidth
				FHeight = BMP.bmHeight
				FHotSpotX = ICIF.xHotspot
				FHotSpotY = ICIF.yHotspot
				DeleteObject(ICIF.hbmColor)
				DeleteObject(ICIF.hbmMask)
			#endif
			If Changed Then Changed(This)
			Return True
		End Function
	#endif
	
	Private Sub Cursor.Create
	End Sub
	
	Private Operator Cursor.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Operator Cursor.Let(ByRef Value As WString)
		WLet(FResName, Value)
		#ifndef __USE_GTK__
			If (Not LoadFromResourceName(Value)) AndAlso (Not LoadFromResourceID(Val(Value))) Then
				LoadFromFile(Value)
			End If
		#else
			If Ctrl AndAlso Ctrl->Handle Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->Handle)
				Handle = gdk_cursor_new_from_name(pdisplay, Value)
				Dim As GdkWindow Ptr win
				#ifdef __USE_GTK4__
					win = gtk_widget_get_parent_window(Ctrl->Handle)
				#else
					If GTK_IS_LAYOUT(Ctrl->Handle) Then
						win = gtk_layout_get_bin_window(GTK_LAYOUT(Ctrl->Handle))
					Else
						win = gtk_widget_get_parent_window(Ctrl->Handle)
					End If
				#endif
				If win Then gdk_window_set_cursor(win, Handle)
			End If
		#endif
	End Operator
	
	Private Function Cursor.ToString() ByRef As WString
		Return *FResName
	End Function
	
	#ifdef __USE_WINAPI__
		Private Function Cursor.ToBitmap() As HBITMAP
			Dim As BitmapType bmpType
			bmpType = Handle
			Return bmpType.Handle
		End Function
	#endif
	
	Private Operator Cursor.Let(Value As Integer)
		'LoadFromResourceID(Value)
		'This.ResName = WStr(Value)
	End Operator
	
	#ifdef __USE_GTK__
		Private Operator Cursor.Let(Value As GdkCursorType)
			If Ctrl AndAlso Ctrl->Handle Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->Handle)
				Handle = gdk_cursor_new_for_display(pdisplay, Value)
			End If
		End Operator
		
	#elseif defined(__USE_WINAPI__)
		Private Operator Cursor.Let(Value As HCURSOR)
			If Handle Then DestroyCursor(Handle)
			Handle = Value
		End Operator
	#endif
	
	Private Operator Cursor.Let(Value As Cursor)
		#ifdef __USE_WINAPI__
			If Handle Then DestroyCursor(Handle)
		#endif
		Handle = Value.Handle
	End Operator
	
	Private Constructor Cursor
		WLet(FClassName, "Cursor")
'		#ifndef __USE_GTK__
'			Handle = LoadCursor(NULL,IDC_ARROW)
'		#endif
		If Changed Then Changed(This)
	End Constructor
	
	Private Destructor Cursor
		#ifdef __USE_WINAPI__
			If Handle <> 0 Then 
				DestroyCursor Handle
			End If
		#endif
		WDeallocate(FResName)
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Sub CursorLoadFromFile Alias "CursorLoadFromFile"(Cur As My.Sys.Drawing.Cursor Ptr, ByRef File As WString) __EXPORT__
		Cur->LoadFromFile(File)
	End Sub
#endif
