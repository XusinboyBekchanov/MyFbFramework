'###############################################################################
'#  GraphicType.bi                                                                 #
'#  This file is part of MyFBFramework				                           #
'#  Version 1.0.0                                                              #
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
			Declare Constructor
			Declare Destructor
			OnChange As Sub(BYREF Sender As GraphicType, Image As Any Ptr, ImageType As Integer)
	End Type

	Sub GraphicType.BitmapChanged(BYREF Sender As My.Sys.Drawing.BitmapType)
		If Sender.Graphic Then 
			With QGraphic(Sender.Graphic)
				.Image = Sender.Handle
				.ImageType = IMAGE_BITMAP
				If .Ctrl Then
				   'QGraphic(Sender.Graphic).Ctrl->Perform(CM_CHANGEIMAGE,IMAGE_BITMAP,0)
				   If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
			End With
		End If
	End Sub

	Sub GraphicType.IconChanged(BYREF Sender As My.Sys.Drawing.Icon)
		If Sender.Graphic Then 
			With QGraphic(Sender.Graphic)
				.Image = Sender.Handle
				.ImageType = IMAGE_ICON
				If .Ctrl Then
				   If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
			End With
		End If
	End Sub

	Sub GraphicType.CursorChanged(BYREF Sender As My.Sys.Drawing.Cursor)
		If Sender.Graphic Then 
		   With QGraphic(Sender.Graphic)
				.Image = Sender.Handle
				.ImageType = IMAGE_CURSOR
				If .Ctrl Then
				   If .OnChange Then .OnChange(QGraphic(Sender.Graphic), Sender.Handle, .ImageType)
				End If
			End With
		End If
	End Sub

	Constructor GraphicType
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
