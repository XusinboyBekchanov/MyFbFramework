'###############################################################################
'#  Label.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Graphic.bi"

Namespace My.Sys.Forms
    #DEFINE QLabel(__Ptr__) *Cast(Label Ptr,__Ptr__)

    Enum LabelStyle
        lsText, lsBitmap, lsIcon, lsCursor, lsEmf, lsOwnerDraw
    End Enum

    Enum LabelBorder
        sbNone, sbSimple, sbSunken
    End Enum

    Enum Alignment
        taLeft, taCenter, taRight
    End Enum

    Type Label Extends Control
        Private:
            FBorder           As Integer
            FStyle            As Integer
            FAlignment        As Integer
            FRealSizeImage    As Boolean
            FCenterImage      As Boolean
            AStyle(6)         As Integer
            ABorder(3)        As Integer
            AAlignment(3)     As Integer
            ARealSizeImage(2) As Integer
            ACenterImage(2)   As Integer
            #IfNdef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
            Declare Static Sub GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
        Public:
            Graphic            As My.Sys.Drawing.GraphicType
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Border As Integer
            Declare Property Border(Value As Integer)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property RealSizeImage As Boolean
            Declare Property RealSizeImage(Value As Boolean)
            Declare Property CenterImage As Boolean
            Declare Property CenterImage(Value As Boolean)
            Declare Property Alignment As Integer
            Declare Property Alignment(Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnClick    As Sub(BYREF Sender As Label)
            OnDblClick As Sub(BYREF Sender As Label)
            #IfNdef __USE_GTK__
				OnDraw     As Sub(BYREF Sender As Label,BYREF R As Rect,DC As HDC = 0)
			#EndIf
    End Type

    Function Label.ReadProperty(PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "caption": Return Cast(Any Ptr, This.FText)
        Case "text": Return Cast(Any Ptr, This.FText)
        Case "graphic": Return Cast(Any Ptr, @This.Graphic)
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Label.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
        Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function
    
    Property Label.Caption ByRef As WString
        Return Text
    End Property

    Property Label.Caption(ByRef Value As WString)
        Text = Value
    End Property

	Property Label.Text ByRef As WString
        Return Base.Text
    End Property

    Property Label.Text(ByRef Value As WString)
        Base.Text = Value
        #IfDef __USE_GTK__
			gtk_label_set_text(GTK_LABEL(widget), ToUtf8(Value))
		#EndIf
    End Property

    Property Label.Border As Integer
        Return FBorder
    End Property

    Property Label.Border(Value As Integer)
        If Value <> FBorder Then
            FBorder = Value
            If Style <> lsText Then
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				#EndIf
            Else
                #IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				#EndIf
            End If
            RecreateWnd
        End If
    End Property

    Property Label.Style As Integer
        Return FStyle 
    End Property

    Property Label.Style(Value As Integer)
        If Value <> FStyle Then
            FStyle = Value
            If FStyle <> lsText Then
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				#EndIf
            Else
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				#EndIf
            End If
            RecreateWnd
        End If
    End Property

    Property Label.RealSizeImage As Boolean
        Return FRealSizeImage
    End Property

    Property Label.RealSizeImage(Value As Boolean)
        If Value <> FRealSizeImage Then
            FRealSizeImage = Value
            If Style <> lsText Then
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				#EndIf
            Else
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				#EndIf
            End If
            RecreateWnd
        End If
    End Property

    Property Label.CenterImage As Boolean
        Return FCenterImage
    End Property

    Property Label.CenterImage(Value As Boolean)
        If Value <> FCenterImage Then
            FCenterImage = Value
            If Style <> lsText Then
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				#EndIf
            Else
				#IfNDef __USE_GTK__
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				#EndIf
            End If
            RecreateWnd
        End If
    End Property

    Property Label.Alignment As Integer
        Return FAlignment
    End Property

    Property Label.Alignment(Value As Integer)
        If Value <> FAlignment Then
           FAlignment = Value
           #IfNDef __USE_GTK__
			   If Style <> lsText Then
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				Else
					Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				End If
            #EndIf
           RecreateWnd
        End If
    End Property

    Sub Label.GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
        With Sender
            If .Ctrl->Child Then
				#IfNDef __USE_GTK__
					Select Case ImageType
					Case IMAGE_BITMAP
						QLabel(.Ctrl->Child).Style = lsBitmap
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
					Case IMAGE_ICON
						QLabel(.Ctrl->Child).Style = lsIcon
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case IMAGE_CURSOR
						QLabel(.Ctrl->Child).Style = lsCursor
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case IMAGE_ENHMETAFILE
						QLabel(.Ctrl->Child).Style = lsEmf
						QLabel(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(0))
					End Select
				#EndIf
            End If
        End With
    End Sub

	#IfNDef __USE_GTK__
		Sub Label.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QLabel(Sender.Child)
					 .Perform(STM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
				End With
			End If
		End Sub

		Sub Label.WndProc(BYREF Message As Message)
		End Sub

		Sub Label.ProcessMessage(BYREF Message As Message)
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc,Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE    
			Case CM_COMMAND
				If Message.wParamHi = STN_CLICKED Then
					If OnClick Then OnClick(This)
				End If
				If Message.wParamHi = STN_DBLCLK Then
					If OnDblClick Then OnDblClick(This)
				End If
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				R = Cast(Rect,diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDraw Then 
					OnDraw(This,R,Dc)
				Else
				End If    
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator Label.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor Label
		#IfDef __USE_GTK__
			widget = gtk_label_new("")
			This.RegisterClass "Label", @This
		#Else
			AStyle(0)        = 0
			AStyle(1)        = SS_BITMAP
			AStyle(2)        = SS_ICON 
			AStyle(3)        = SS_ICON
			AStyle(4)        = SS_ENHMETAFILE    
			AStyle(5)        = SS_OWNERDRAW
			AAlignment(0)    = SS_LEFT
			AAlignment(1)    = SS_CENTER
			AAlignment(2)    = SS_RIGHT
			ABorder(0)       = 0
			ABorder(1)       = SS_SIMPLE
			ABorder(2)       = SS_SUNKEN 
			ACenterImage(0)  = SS_RIGHTJUST
			ACenterImage(1)  = SS_CENTERIMAGE
			ARealSizeImage(0)= 0
			ARealSizeImage(1)= SS_REALSIZEIMAGE
		#EndIf
        Graphic.Ctrl = This
        Graphic.OnChange = @GraphicChange
        FRealSizeImage   = 1
        With This
            .Child       = @This
            #IfNDef __USE_GTK__
				.RegisterClass "Label", "Static"
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				If FStyle <> lsText Then
				   Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR ARealSizeImage(Abs_(FRealSizeImage)) OR ACenterImage(Abs_(FCenterImage)) 
				Else
				   Base.Style = WS_CHILD OR SS_NOTIFY OR ABorder(Abs_(FBorder)) OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment))
				End If
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
            WLet FClassName, "Label"
            WLet FClassAncestor, "Static"
            .Width       = 90
            .Height      = 17
        End With  
    End Constructor

    Destructor Label
    End Destructor
End Namespace
