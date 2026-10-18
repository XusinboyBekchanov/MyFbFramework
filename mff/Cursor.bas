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
			If Changed Then Changed(*Designer, This)
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
			If Changed Then Changed(*Designer, This)
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
			If Changed Then Changed(*Designer, This)
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
		#ifdef __USE_WASM__
			If Ctrl AndAlso Ctrl->Handle Then SetStyle(Ctrl->Handle, "cursor", ToUtf8(Value))
		#elseif defined(__USE_WINAPI__)
			If (Not LoadFromResourceName(Value)) AndAlso (Not LoadFromResourceID(Val(Value))) Then
				LoadFromFile(Value)
			End If
		#elseif defined(__USE_GTK__)
			If Ctrl AndAlso Ctrl->Handle Then
				Dim As GdkDisplay Ptr pdisplay = gtk_widget_get_display(Ctrl->Handle)
				Handle = NewFromName(pdisplay, Value)
				#ifdef __USE_GTK4__
					gtk_widget_set_cursor(Ctrl->Handle, Handle)
				#else
					Dim As GdkWindow Ptr win = TargetWindow
					If win Then gdk_window_set_cursor(win, Handle)
				#endif
			End If
		#endif
	End Operator

	#ifdef __USE_GTK__
		' GTK2 looks names up in the X cursor theme, CSS names like "default" are often missing there.
		' A NULL cursor resets the window to the inherited (root) cursor, under XWayland/WSLg it
		' keeps the last shape, e.g. the I-beam of an editor. The core X cursors always exist.
		Private Function Cursor.NewFromName(pdisplay As GdkDisplay Ptr, ByRef Value As WString) As GdkCursor Ptr
			#ifdef __USE_GTK4__
				Dim As GdkCursor Ptr Result = gdk_cursor_new_from_name(Value, NULL)
			#else
				Dim As GdkCursor Ptr Result = gdk_cursor_new_from_name(pdisplay, Value)
			#endif
			If Result Then Return Result
			Dim As GdkCursorType CursorType
			Select Case LCase(Value)
			Case "text": CursorType = GDK_XTERM
			Case "wait", "progress": CursorType = GDK_WATCH
			Case "crosshair": CursorType = GDK_CROSSHAIR
			Case "pointer": CursorType = GDK_HAND2
			Case "move", "all-scroll": CursorType = GDK_FLEUR
			Case "not-allowed", "no-drop": CursorType = GDK_X_CURSOR
			Case "ns-resize", "row-resize": CursorType = GDK_SB_V_DOUBLE_ARROW
			Case "ew-resize", "col-resize": CursorType = GDK_SB_H_DOUBLE_ARROW
			Case "nesw-resize": CursorType = GDK_BOTTOM_LEFT_CORNER
			Case "nwse-resize": CursorType = GDK_BOTTOM_RIGHT_CORNER
			Case Else: CursorType = GDK_LEFT_PTR
			End Select
			Return gdk_cursor_new_for_display(pdisplay, CursorType)
		End Function

		' GdkWindow whose cursor this control shows
		Private Function Cursor.TargetWindow As GdkWindow Ptr
			If Ctrl = 0 OrElse Ctrl->Handle = 0 Then Return 0
			#ifdef __USE_GTK4__
				Return gtk_widget_get_parent_window(Ctrl->Handle)
			#else
				If GTK_IS_LAYOUT(Ctrl->Handle) Then
					Return gtk_layout_get_bin_window(GTK_LAYOUT(Ctrl->Handle))
				ElseIf GTK_IS_WINDOW(Ctrl->Handle) Then
					' Form: the toplevel window, child windows without own cursor inherit it
					Return gtk_widget_get_window(Ctrl->Handle)
				Else
					Return gtk_widget_get_parent_window(Ctrl->Handle)
				End If
			#endif
		End Function
	#endif
	
	Private Function Cursor.ToString() ByRef As WString
		If FResName > 0 Then Return *FResName Else Return ""
	End Function
	
	#ifdef __USE_WINAPI__
		Private Function Cursor.ToBitmap() As HBITMAP
			Dim As BitmapType bmpType
			bmpType = Handle
			Return bmpType.Handle
		End Function
	#endif
	
	Private Operator Cursor.Let(Value As Integer)
		#ifdef __USE_WINAPI__
			If Handle Then DestroyCursor(Handle)
			Handle = Cast(HCURSOR, Value)
			If Ctrl AndAlso Ctrl->Handle Then SendMessage(Ctrl->Handle, WM_SETCURSOR, Cast(WPARAM, Ctrl->Handle), Cast(LPARAM, 1))
		#elseif defined(__USE_GTK__)
			' Cursor = 0 restores the default cursor (e.g. after crWait)
			If Value = 0 Then
				Handle = 0
				WLet(FResName, "")
				#ifdef __USE_GTK4__
					If Ctrl AndAlso Ctrl->Handle Then gtk_widget_set_cursor(Ctrl->Handle, NULL)
				#endif
				Dim As GdkWindow Ptr win = TargetWindow
				If win Then
					#ifndef __USE_GTK4__
						If GTK_IS_WINDOW(Ctrl->Handle) Then
							' Forms keep an explicit arrow (see Form.Show)
							gdk_window_set_cursor(win, gdk_cursor_new_for_display(gtk_widget_get_display(Ctrl->Handle), GDK_LEFT_PTR))
						Else
							gdk_window_set_cursor(win, NULL)
						End If
					#endif
				End If
			End If
		#endif
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
			If Ctrl AndAlso Ctrl->Handle Then SendMessage(Ctrl->Handle, WM_SETCURSOR, Cast(WPARAM, Ctrl->Handle), Cast(LPARAM, 1))
		End Operator
	#endif
	
	Private Operator Cursor.Let(Value As Cursor)
		#ifdef __USE_WINAPI__
			If Handle Then DestroyCursor(Handle)
		#endif
		Handle = Value.Handle
		#ifdef __USE_WINAPI__
			If Ctrl AndAlso Ctrl->Handle Then SendMessage(Ctrl->Handle, WM_SETCURSOR, Cast(WPARAM, Ctrl->Handle), Cast(LPARAM, 1))
		#endif
	End Operator
	
	Private Constructor Cursor
		WLet(FClassName, "Cursor")
'		#ifndef __USE_GTK__
'			Handle = LoadCursor(NULL,IDC_ARROW)
'		#endif
		If Changed Then Changed(*Designer, This)
	End Constructor
	
	Private Destructor Cursor
		#ifdef __USE_WINAPI__
			If Handle <> 0 Then 
				DestroyCursor Handle
			End If
		#endif
		If FResName Then _Deallocate(FResName)
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Sub CursorLoadFromFile Alias "CursorLoadFromFile"(Cur As My.Sys.Drawing.Cursor Ptr, ByRef File As WString) __EXPORT__
		Cur->LoadFromFile(File)
	End Sub
#endif
