'###############################################################################
'#  GroupBox.bi                                                                #
'#  This file is part of MyFBFramework                                       #
'#  Version 1.0.0                                                              #
'###############################################################################

#include Once "ContainerControl.bi"

Namespace My.Sys.Forms
    #DEFINE QGroupBox(__Ptr__) *Cast(GroupBox Ptr,__Ptr__)

    Type GroupBox Extends ContainerControl
        Private:
            FParentColor As Integer
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property ParentColor As Boolean
            Declare Property ParentColor(Value As Boolean)
            Declare Operator Cast As Control Ptr 
            Declare Constructor
            Declare Destructor
            OnClick As Sub(BYREF Sender As GroupBox)
    End Type

    Property GroupBox.Caption ByRef As WString
        Return Text
    End Property

    Property GroupBox.Caption(ByRef Value As WString)
        Text = Value 
    End Property

    Property GroupBox.ParentColor As Boolean
       Return FParentColor
    End Property
        
    Property GroupBox.ParentColor(Value As Boolean)
       FParentColor = Value
       If FParentColor Then
          This.Color = Parent->Color
          Invalidate
       End If
    End Property

    Sub GroupBox.WndProc(BYREF Message As Message)
        If Message.Sender Then
        End If
    End Sub

    Sub GroupBox.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case CM_CTLCOLOR
             Static As HDC Dc
             Dc = Cast(HDC, Message.wParam)
             SetBKMode Dc, TRANSPARENT
             SetTextColor Dc, Font.Color
             SetBKColor Dc, This.Color
             SetBKMode Dc, OPAQUE
        Case CM_COMMAND
            If Message.wParamHi = BN_CLICKED Then
                If OnClick Then OnClick(This)
            End If
        End Select
    End Sub

    Operator GroupBox.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor GroupBox
        With This
            .RegisterClass "GroupBox", "Button"
            .Child       = @This
            .ChildProc   = @WndProc
            .ClassName   = "GroupBox"
            .ClassAncestor   = "Button"
            .ExStyle     = WS_EX_TRANSPARENT
            .Style       = WS_CHILD OR BS_GROUPBOX
            .Width       = 121
            .Height      = 51
            .Color       = GetSysColor(COLOR_BTNFACE)
        End With    
    End Constructor

    Destructor GroupBox
    End Destructor
End namespace
