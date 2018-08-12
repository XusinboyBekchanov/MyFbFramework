'################################################################################
'#  CommandButton.bi                                                              #
'#  This file is part of MyFBFramework                                             #
'#  2017                                                                             #
'#  Version 1.0.0                                                                  #
'################################################################################

#DEFINE QCommandButton(__Ptr__) *Cast(CommandButton Ptr,__Ptr__)

#Include Once "Control.bi"
#Include Once "Graphic.bi"
#Include Once "List.bi"

Enum ButtonStyle
    bsText, bsBitmap, bsIcon, bsCursor, bsOwnerDraw
End Enum

Namespace My.Sys.Forms
    Type CommandButton Extends Control
        Private:
            FStyle      As ButtonStyle
            FDefault    As Boolean
            FImageType  As Integer
            AStyle(4)   As Integer
            ADefault(2) As Integer
            Declare Static Sub WndProc(BYREF message As Message)
            Declare Sub ProcessMessage(BYREF message As Message)
            Declare Static Sub GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Function EnumMenuItems(Item As MenuItem, BYREF List As List) As Boolean
        Public:
            Graphic     As My.Sys.Drawing.GraphicType
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Default As Boolean
            Declare Property Default(Value As Boolean)
            Declare Property Style As ButtonStyle
            Declare Property Style(Value As ButtonStyle)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnDraw  As Sub(BYREF Sender As CommandButton,BYREF R As Rect,DC As HDC = 0)
    End Type

    Function CommandButton.ReadProperty(PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "caption": Return Cast(Any Ptr, This.FText)
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function CommandButton.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function
    
    Property CommandButton.Caption ByRef As WString
        Return Text
    End Property

    Property CommandButton.Caption(ByRef Value As WString)
        Text = Value
    End Property

    Property CommandButton.Default As Boolean
        If Handle Then
            FDefault = (Style AND BS_DEFPUSHBUTTON)
        End If
        Return FDefault
    End Property

    Property CommandButton.Default(Value As Boolean)
        If Value <> FDefault Then
            FDefault = Value
            ChangeStyle BS_PUSHLIKE, False
            ChangeStyle BS_DEFPUSHBUTTON, True
        End If
    End Property

    Property CommandButton.Style As ButtonStyle
        Return FStyle
    End Property

    Property CommandButton.Style(Value As ButtonStyle)
        If Value <> FStyle Then
            FStyle = Value
            Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR ADefault(Abs_(FDefault)) 
        End If
    End Property

    Sub CommandButton.GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr,ImageType As Integer)
        With Sender
            If .Ctrl->Child Then
                Select Case ImageType
                Case IMAGE_BITMAP
                    QCommandButton(.Ctrl->Child).Style = bsBitmap
                    QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
                Case IMAGE_ICON
                    QCommandButton(.Ctrl->Child).Style = bsIcon
                    QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
                Case IMAGE_CURSOR
                    QCommandButton(.Ctrl->Child).Style = bsCursor
                    QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
                End Select
            End If
        End With
    End Sub

    Sub CommandButton.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With  QCommandButton(Sender.Child)
                If .Style <> bsText Then 
                   .Perform(BM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
                End If
            End With
        End If
    End Sub

    Sub CommandButton.WndProc(BYREF Message As Message)
'        If Message.Sender Then
'            If Cast(TControl Ptr,Message.Sender)->Child Then
'               Cast(CommandButton Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
'            End If
'        End If
    End Sub

    Function CommandButton.EnumMenuItems(Item As MenuItem,BYREF List As List) As Boolean
        For i As Integer = 0 To Item.Count -1
            List.Add Item.Item(i)
            EnumMenuItems *Item.Item(i),List
        Next i
        Return True
    End Function

    Sub CommandButton.ProcessMessage(BYREF msg As Message)
        Select Case msg.Msg
'        Case BM_CLICK
'            If OnClick Then OnClick(This)
        Case CM_COMMAND
            'If Message.wParamHi = BN_CLICKED Then
            '    If OnClick Then OnClick(This)
            'End If
        Case WM_GETDLGCODE: msg.Result = DLGC_BUTTON Or IIF(FDefault, DLGC_DEFPUSHBUTTON, DLGC_UNDEFPUSHBUTTON)
        Case CM_DRAWITEM
            Dim As DRAWITEMSTRUCT Ptr diStruct
            Dim As Rect R
            Dim As HDC Dc
            diStruct = Cast(DRAWITEMSTRUCT Ptr,msg.lParam)
            R = Cast(Rect,diStruct->rcItem)
            Dc = diStruct->hDC
            If OnDraw Then 
                OnDraw(This,R,Dc)
            Else
            End If
        Case WM_KEYUP
            If LoWord(msg.wParam) = VK_SPACE Or LoWord(msg.wParam) = VK_RETURN Then
                If OnClick Then OnClick(This)
                msg.Result = -1
                Return
            End If
        End Select
        Base.ProcessMessage(msg)
    End Sub

    Operator CommandButton.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor CommandButton
        AStyle(0)        = BS_TEXT
        AStyle(1)        = BS_BITMAP
        AStyle(2)        = BS_ICON 
        AStyle(3)        = BS_ICON 
        ADefault(0)      = BS_PUSHLIKE
        ADefault(1)      = BS_DEFPUSHBUTTON
        Graphic.Ctrl  = @This
        Graphic.OnChange = @GraphicChange
        FTabStop = True
        With This
            .RegisterClass "CommandButton","Button"
            .Child       = @This
            .ChildProc   = @WndProc
            WLet FClassName, "CommandButton"
            WLet FClassAncestor, "Button"
            .ExStyle     = 0
            Base.Style       = WS_CHILD OR WS_TABSTOP OR AStyle(Abs_(FStyle)) OR ADefault(Abs_(FDefault))
            .Width       = 75
            .Height      = 25
        End With  
    End Constructor

    Destructor CommandButton
    End Destructor
End Namespace
