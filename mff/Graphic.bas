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
	Function GraphicType.ReadProperty(ByRef PropertyName As String) As Any Ptr
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
	
	Function GraphicType.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
	
	Sub GraphicType.BitmapChanged(ByRef Sender As My.Sys.Drawing.BitmapType)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 0
				If .Ctrl Then
					'QGraphic(Sender.Graphic).Ctrl->Perform(CM_CHANGEIMAGE,IMAGE_BITMAP,0)
					If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	Sub GraphicType.IconChanged(ByRef Sender As My.Sys.Drawing.Icon)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 1
				If .Ctrl Then
					If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	Sub GraphicType.CursorChanged(ByRef Sender As My.Sys.Drawing.Cursor)
		If Sender.Graphic Then
			With QGraphic(Sender.Graphic)
				'#IfNDef __USE_GTK__
				.Image = Sender.Handle
				.ImageType = 2
				If .Ctrl Then
					If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
				'#EndIf
			End With
		End If
	End Sub
	
	Sub GraphicType.LoadFromFile(ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0)
		Dim As Integer Pos1 = InStrRev(File, ".")
		Select Case LCase(Mid(File, Pos1 + 1))
		Case "bmp": Bitmap.LoadFromFile(File, cxDesired, cyDesired)
		Case "png": Bitmap.LoadFromPNGFile(File, cxDesired, cyDesired)
		Case "ico": Icon.LoadFromFile(File, cxDesired, cyDesired)
		Case "cur": Cursor.LoadFromFile(File)
		Case Else: Bitmap.LoadFromFile(File, cxDesired, cyDesired)
		End Select
	End Sub
	
	#ifdef __USE_GTK__
		Sub GraphicType.LoadFromResourceName(ResName As String, ModuleHandle As Integer = 0, cxDesired As Integer = 0, cyDesired As Integer = 0)
	#else
		Sub GraphicType.LoadFromResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL), cxDesired As Integer = 0, cyDesired As Integer = 0)
	#endif
		FResName = ResName
		#ifdef __USE_GTK__
			Bitmap.LoadFromResourceName(ResName)
		#else
			If FindResource(ModuleHandle, ResName, RT_BITMAP) Then
				Bitmap.LoadFromResourceName(ResName)
			ElseIf FindResource(ModuleHandle, ResName, "PNG") Then
				Bitmap.LoadFromPNGResourceName(ResName)
			ElseIf FindResource(ModuleHandle, ResName, RT_ICON) Then
				Icon.LoadFromResourceName(ResName)
			ElseIf FindResource(ModuleHandle, ResName, RT_CURSOR) Then
				Cursor.LoadFromResourceName(ResName)
			ElseIf FindResource(ModuleHandle, ResName, RT_RCDATA) Then
				Bitmap.LoadFromPNGResourceName(ResName)
			Else
				Bitmap.LoadFromResourceName(ResName)
			End If
		#endif
	End Sub
	
	Sub GraphicType.SaveToFile(ByRef File As WString)
		If Bitmap.Handle <> 0 Then
			Bitmap.SaveToFile(File)
		ElseIf Icon.Handle <> 0 Then
			Icon.SaveToFile(File)
		ElseIf Cursor.Handle <> 0 Then
			Cursor.SaveToFile(File)
		End If
	End Sub
	
	Operator GraphicType.Let(ByRef Value As WString)
		If InStr(Value, ".") > 0 Then
			LoadFromFile(Value)
		Else
			LoadFromResourceName(Value)
		End If
	End Operator
	
	Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.BitmapType)
		Bitmap.Handle = Value.Handle
	End Operator
	
	Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.Icon)
		Icon.Handle = Value.Handle
	End Operator
	
	Operator GraphicType.Let(ByRef Value As My.Sys.Drawing.Cursor)
		Cursor.Handle = Value.Handle
	End Operator
	
	Function GraphicType.ToString() ByRef As WString
		Return *FResName.vptr
	End Function
	
	Constructor GraphicType
		WLet(FClassName, "GraphicType")
		This.Bitmap.Graphic = @This
		This.Bitmap.Changed = @BitmapChanged
		This.Icon.Graphic   = @This
		This.Icon.Changed   = @IconChanged
		This.Cursor.Graphic = @This
		This.Cursor.Changed = @CursorChanged
	End Constructor
	
	Destructor GraphicType
	End Destructor
End Namespace

Sub GraphicTypeLoadFromFile Alias "GraphicTypeLoadFromFile"(Graphic As My.Sys.Drawing.GraphicType Ptr, ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0) __EXPORT__
	Graphic->LoadFromFile(File, cxDesired, cyDesired)
End Sub
