'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Object.bi"

Namespace My.Sys
	#ifndef ReadProperty_Off
		Private Function Object.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "classname": If IsEmpty Then Return 0 Else Return FClassName
			Case "designer": If IsEmpty Then Return 0 Else Return Designer
			Case Else: Return 0
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off	
		Private Function Object.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value <> 0 Then
				Select Case LCase(PropertyName)
				Case "designer": Designer = Value
				Case Else: Return False
				End Select
			End If
			Return True
		End Function
	#endif

	Private Operator Object.Cast ByRef As WString
		Return This.ClassName
	End Operator
	
	Private Operator Object.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Function Object.ClassName ByRef As WString
		If IsEmpty Then Return WStr("")
		If FClassName = 0 Or FClassName = 24 Then
			Return WStr("")
		Else
			Return *FClassName
		End If
	End Function
	
	Private Function Object.IsEmpty As Boolean
		Return @This = 0
	End Function
	
	Private Function Object.FullTypeName(ByVal baseIndex As Integer = 0) As UString
		If IsEmpty Then Return WStr("")
		Dim As String s
		Dim As ZString Ptr pz
		Dim As Any Ptr p = CPtr(Any Ptr Ptr Ptr, @This)[0][-1]     ' Ptr to RTTI info
		For I As Integer = baseIndex - 1 To 0
			p = CPtr(Any Ptr Ptr, p)[2]                            ' Ptr to Base RTTI info of previous RTTI info
			If p = 0 Then Return s
		Next I
		pz = CPtr(Any Ptr Ptr, p)[1]                               ' Ptr to mangled-typename
		Do
			Do While (*pz)[0] > Asc("9") OrElse (*pz)[0] < Asc("0")
				If (*pz)[0] = 0 Then Return s
				pz += 1
			Loop
			Dim As Integer N = Val(*pz)
			Do
				pz += 1
			Loop Until (*pz)[0] > Asc("9") OrElse (*pz)[0] < Asc("0")
			If s <> "" Then s &= "."
			s &= Left(*pz, N)
			pz += N
		Loop
	End Function
	
	Private Function Object.ToString ByRef As WString
		If IsEmpty Then Return WStr("")
		WLet(FTemp, "(" & This.ClassName & ")")
		Return *FTemp
	End Function
	
	' =====================================================================================
	' Scale the location point X per DPI
	' =====================================================================================
	#ifdef __USE_JNI__
		Private Function Object.ScaleX(ByVal cx As Single) As Integer
			Function = cx * xdpi
		End Function
	#else
		Private Function Object.ScaleX(ByVal cx As Single) As Single
			If xdpi = 0 OrElse ydpi = 0 Then
				#ifdef __USE_GTK__
					Dim As GdkScreen Ptr Screen1 = gdk_screen_get_default()
			    	Dim As gdouble dpi = gdk_screen_get_resolution(Screen1)
					xdpi = dpi / 96
					ydpi = dpi / 96
				#elseif defined(__USE_WINAPI__)
					Dim hDC As HDC
					hDC = GetDC(NULL)
					xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
					ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
					ReleaseDC NULL, hDC
				#endif
				If xdpi = 0 Then xdpi = 1
				If ydpi = 0 Then ydpi = 1
				oldxdpi = xdpi
				oldydpi = ydpi
			End If
			Function = cx * xdpi
		End Function
	#endif
	' =====================================================================================
	' Scale the location point X per DPI
	' =====================================================================================
	#ifdef __USE_JNI__
		Private Function Object.UnScaleX(ByVal cx As Single) As Integer
			If xdpi = 0 Then xdpi = 1
			Function = cx / xdpi
		End Function
	#else
		Private Function Object.UnScaleX(ByVal cx As Single) As Single
			If xdpi = 0 OrElse ydpi = 0 Then
				#ifdef __USE_GTK__
					Dim As GdkScreen Ptr Screen1 = gdk_screen_get_default()
			    	Dim As gdouble dpi = gdk_screen_get_resolution(Screen1)
					xdpi = dpi / 96
					ydpi = dpi / 96
				#elseif defined(__USE_WINAPI__)
					Dim hDC As HDC
					hDC = GetDC(NULL)
					xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
					ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
					ReleaseDC NULL, hDC
				#endif
				If xdpi = 0 Then xdpi = 1
				If ydpi = 0 Then ydpi = 1
				oldxdpi = xdpi
				oldydpi = ydpi
			End If
			Function = cx / xdpi
		End Function
	#endif
	' =====================================================================================
	' Scale the location point Y per DPI
	' =====================================================================================
	#ifdef __USE_JNI__
		Private Function Object.ScaleY(ByVal cy As Single) As Integer
			Function = cy * ydpi
		End Function
	#else
		Private Function Object.ScaleY(ByVal cy As Single) As Single
			If xdpi = 0 OrElse ydpi = 0 Then
				#ifdef __USE_GTK__
					Dim As GdkScreen Ptr Screen1 = gdk_screen_get_default()
			    	Dim As gdouble dpi = gdk_screen_get_resolution(Screen1)
					xdpi = dpi / 96
					ydpi = dpi / 96
				#elseif defined(__USE_WINAPI__)
					Dim hDC As HDC
					hDC = GetDC(NULL)
					xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
					ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
					ReleaseDC NULL, hDC
				#endif
				If xdpi = 0 Then xdpi = 1
				If ydpi = 0 Then ydpi = 1
				oldxdpi = xdpi
				oldydpi = ydpi
			End If
			Function = cy * ydpi
		End Function
	#endif
	
	' =====================================================================================
	' Scale the location point Y per DPI
	' =====================================================================================
	#ifdef __USE_JNI__
		Private Function Object.UnScaleY(ByVal cy As Single) As Integer
			If ydpi = 0 Then ydpi = 1
			Function = cy / ydpi
		End Function
	#else
		Private Function Object.UnScaleY(ByVal cy As Single) As Single
			If xdpi = 0 OrElse ydpi = 0 Then
				#ifdef __USE_GTK__
					Dim As GdkScreen Ptr Screen1 = gdk_screen_get_default()
			    	Dim As gdouble dpi = gdk_screen_get_resolution(Screen1)
					xdpi = dpi / 96
					ydpi = dpi / 96
				#elseif defined(__USE_WINAPI__)
					Dim hDC As HDC
					hDC = GetDC(NULL)
					xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
					ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
					ReleaseDC NULL, hDC
				#endif
				If xdpi = 0 Then xdpi = 1
				If ydpi = 0 Then ydpi = 1
				oldxdpi = xdpi
				oldydpi = ydpi
			End If
			Function = cy / ydpi
		End Function
	#endif

	Private Constructor Object
		FTemp = 0
		FClassName = 0 'CAllocate(0)
		'FClassAncestor = CAllocate(0)
		'FName = CAllocate(0)
	End Constructor
	
	Destructor Object
		WDeAllocate(FTemp)
		WDeAllocate(FClassName)
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	#ifndef ToString_Off
		Function ToString Alias "ToString"(Obj As My.Sys.Object Ptr) ByRef As WString Export
			Return Obj->ToString
		End Function
	#endif
	
	#ifndef ReadProperty_Off
		Function ReadProperty Alias "ReadProperty" (Obj As My.Sys.Object Ptr, ByRef PropertyName As String) As Any Ptr Export
			Return Obj->ReadProperty(PropertyName)
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Function WriteProperty Alias "WriteProperty" (Obj As My.Sys.Object Ptr, ByRef PropertyName As String, Value As Any Ptr) As Boolean Export
			Return Obj->WriteProperty(PropertyName, Value)
		End Function
	#endif
	
	#ifndef FullTypeName_Off
		Function FullTypeName Alias "FullTypeName" (Obj As My.Sys.Object Ptr, ByVal baseIndex As Integer = 0) As UString Export
			Return Obj->FullTypeName(baseIndex)
		End Function
	#endif
#endif
