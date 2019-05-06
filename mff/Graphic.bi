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

#Include Once "Control.bi"

Namespace My.Sys.Drawing
	#DEFINE QGraphic(__Ptr__) *Cast(GraphicType Ptr,__Ptr__)

	Type GraphicType Extends My.Sys.Object
		Private:
			Declare Static Sub BitmapChanged(BYREF Sender As My.Sys.Drawing.BitmapType)
			Declare Static Sub IconChanged(BYREF Sender As My.Sys.Drawing.Icon)
			Declare Static Sub CursorChanged(BYREF Sender As My.Sys.Drawing.Cursor)
		Public:
			Ctrl      As My.Sys.Forms.Control Ptr
			Bitmap    As My.Sys.Drawing.BitmapType
			Icon      As My.Sys.Drawing.Icon
			Cursor    As My.Sys.Drawing.Cursor
			Image     As Any Ptr
			ImageType As Integer
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Declare Constructor
			Declare Destructor
			OnChange As Sub(BYREF Sender As GraphicType, Image As Any Ptr, ImageType As Integer)
	End Type

	Function GraphicType.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "bitmap": Return @Bitmap
        Case "icon": Return @Icon
        Case "cursor": Return @Cursor
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
    
	Sub GraphicType.BitmapChanged(BYREF Sender As My.Sys.Drawing.BitmapType)
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

	Sub GraphicType.IconChanged(BYREF Sender As My.Sys.Drawing.Icon)
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

	Sub GraphicType.CursorChanged(BYREF Sender As My.Sys.Drawing.Cursor)
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

	Constructor GraphicType
    	WLet FClassName, "GraphicType"
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
