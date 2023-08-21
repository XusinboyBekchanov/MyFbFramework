'###############################################################################
'#  Graphic.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGraphic.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Graphic.bi"

Namespace My.Sys.Drawing
	#ifndef ReadProperty_Off
		Private Function GraphicType.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "bitmap": Return @Bitmap
			Case "icon": Return @Icon
			Case "cursor": Return @Cursor
			Case "image": Return Image
			Case "imagetype": Return @ImageType
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function GraphicType.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value <> 0 Then
				Select Case LCase(PropertyName)
				Case "bitmap": This.Bitmap = QWString(Value)
				Case "icon": This.Icon = QWString(Value)
				Case "cursor": This.Cursor = QWString(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Sub GraphicType.BitmapChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.BitmapType)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 0
				If .Ctrl Then
					'QGraphic(Sender.Graphic).Ctrl->Perform(CM_CHANGEIMAGE,IMAGE_BITMAP,0)
					If .OnChange Then .OnChange(*QGraphic(Sender.Graphic).Designer, QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	Private Sub GraphicType.IconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 1
				If .Ctrl Then
					If .OnChange Then .OnChange(*QGraphic(Sender.Graphic).Designer, QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	Private Sub GraphicType.CursorChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Cursor)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 2
				If .Ctrl Then
					If .OnChange Then .OnChange(*QGraphic(Sender.Graphic).Designer, QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	#ifndef GraphicType_LoadFromFile_Off
		Private Function GraphicType.LoadFromFile(ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
			Dim As Integer Pos1 = InStrRev(File, ".")
			Select Case LCase(Mid(File, Pos1 + 1))
			Case "bmp": Return Bitmap.LoadFromFile(File, cxDesired, cyDesired)
			Case "png": Return Bitmap.LoadFromFile(File, cxDesired, cyDesired)
			Case "ico": Return Icon.LoadFromFile(File, cxDesired, cyDesired)
			Case "cur": Return Cursor.LoadFromFile(File, cxDesired, cyDesired)
			Case Else: Return Bitmap.LoadFromFile(File, cxDesired, cyDesired)
			End Select
		End Function
	#endif
	
	#ifndef GraphicType_LoadFromResourceID_Off
		Private Function GraphicType.LoadFromResourceID(ResID As Integer, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
			#ifdef __USE_GTK__
				Return Bitmap.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
			#elseif defined(__USE_WINAPI__)
				FResName = Str(ResID)
				If FindResource(ModuleHandle, FResName, RT_BITMAP) Then
					Return Bitmap.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, FResName, "PNG") Then
					Return Bitmap.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, FResName, RT_ICON) Then
					Return Icon.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, FResName, RT_CURSOR) Then
					Return Cursor.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, FResName, RT_RCDATA) Then
					Return Bitmap.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				Else
					Return Bitmap.LoadFromResourceID(ResID, ModuleHandle, cxDesired, cyDesired)
				End If
			#else
				Return False
			#endif
		End Function
	#endif
	
	#ifndef GraphicType_LoadFromResourceName_Off
		Private Function GraphicType.LoadFromResourceName(ResName As String, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
			FResName = ResName
			#ifdef __USE_GTK__
				Return Bitmap.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
			#elseif defined(__USE_WINAPI__)
				If FindResource(ModuleHandle, ResName, RT_BITMAP) Then
					Return Bitmap.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, ResName, "PNG") Then
					Return Bitmap.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, ResName, RT_ICON) Then
					Return Icon.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, ResName, RT_CURSOR) Then
					Return Cursor.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				ElseIf FindResource(ModuleHandle, ResName, RT_RCDATA) Then
					Return Bitmap.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				Else
					Return Bitmap.LoadFromResourceName(ResName, ModuleHandle, cxDesired, cyDesired)
				End If
			#else
				Return False
			#endif
		End Function
	#endif
	
	#ifndef GraphicType_SaveToFile_Off
		Private Function GraphicType.SaveToFile(ByRef File As WString) As Boolean
			If Bitmap.Handle <> 0 Then
				Return Bitmap.SaveToFile(File)
			ElseIf Icon.Handle <> 0 Then
				Return Icon.SaveToFile(File)
			ElseIf Cursor.Handle <> 0 Then
				Return Cursor.SaveToFile(File)
			End If
			Return False
		End Function
	#endif
	
	Private Operator GraphicType.Let(ByRef Value As WString)
		If (Not LoadFromResourceID(Val(Value))) AndAlso (Not LoadFromResourceName(Value)) Then
			LoadFromFile(Value)
		End If
	End Operator
	
	Private Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.BitmapType)
		Bitmap.Handle = Value.Handle
	End Operator
	
	Private Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.Icon)
		Icon.Handle = Value.Handle
	End Operator
	
	Private Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.Cursor)
		Cursor.Handle = Value.Handle
	End Operator
	
	Private Function GraphicType.ToString() ByRef As WString
		Return *FResName.vptr
	End Function
	
	Private Constructor GraphicType
		WLet(FClassName, "GraphicType")
		This.Bitmap.Graphic = @This
		This.Bitmap.Changed = @BitmapChanged
		This.Icon.Graphic   = @This
		This.Icon.Changed   = @IconChanged
		This.Cursor.Graphic = @This
		This.Cursor.Changed = @CursorChanged
	End Constructor
	
	Private Destructor GraphicType
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Sub GraphicTypeLoadFromFile Alias "GraphicTypeLoadFromFile"(Graphic As My.Sys.Drawing.GraphicType Ptr, ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0) __EXPORT__
		Graphic->LoadFromFile(File, cxDesired, cyDesired)
	End Sub
#endif
