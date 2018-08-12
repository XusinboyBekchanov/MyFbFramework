'###############################################################################
'#  CheckBox.bi                                                                #
'#  This file is part of MyFBFramework                                       #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QCheckBox(__Ptr__) *Cast(CheckBox Ptr,__Ptr__)

    Type CheckBox Extends Control
        Private:
            FChecked    As Boolean
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
        Public:
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property Checked As Boolean
        Declare Property Checked(Value As Boolean)
        Declare Operator Cast As Control Ptr
        Declare Constructor
        Declare Destructor
        OnClick As Sub(ByRef Sender As CheckBox)
    End Type
    
    Function CheckBox.ReadProperty(PropertyName As String) As Any Ptr
        Select Case PropertyName
        Case "Caption": Return FText
        Case "Checked": Return @FChecked
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function CheckBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Select Case PropertyName
        Case "Caption": This.Caption = QWString(Value)
        Case "Checked": Checked = QBoolean(Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function

    Property CheckBox.Caption ByRef As WString
        Return Text
    End Property

    Property CheckBox.Caption(ByRef Value As WString)
        Text = Value 
    End Property

    Property CheckBox.Checked As Boolean
        Return FChecked
    End Property

    Property CheckBox.Checked(Value As Boolean)
        FChecked = Value
        If Handle Then Perform(BM_SETCHECK,FChecked,0)
    End Property

    Sub CheckBox.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QCheckBox(Sender.Child)
                 .Perform(BM_SETCHECK, .Checked, 0)
            End With
        End If
    End Sub

    Sub CheckBox.WndProc(BYREF Message As Message)
'        If Message.Sender Then
'            If Cast(TControl Ptr,Message.Sender)->Child Then
'               Cast(CheckBox Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
'            End If
'        End If
    End Sub

    Sub CheckBox.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case CM_CTLCOLOR
            Static As HDC Dc
            Dc = Cast(HDC, Message.wParam)
            SetBKMode Dc, TRANSPARENT
            SetTextColor Dc, Font.Color
            SetBKColor Dc, This.BackColor
            SetBKMode Dc, OPAQUE    
        Case CM_COMMAND
            If Message.wParamHi = BN_CLICKED Then
                If Checked = 0 Then
                   Checked = 1 
                Else
                   Checked = 0
                End If
                If OnClick Then OnClick(This)
            End If
        End Select
        Base.ProcessMessage(Message)
    End Sub

    Operator CheckBox.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor CheckBox
        With This
            .RegisterClass "CheckBox", "Button"
            .Child                  = @This
            .ChildProc              = @WndProc
            WLet FClassName, "CheckBox"
            WLet FClassAncestor, "Button"
            .ExStyle                = 0
            .Style                  = WS_CHILD OR WS_TABSTOP OR BS_CHECKBOX
            .BackColor                  = GetSysColor(COLOR_BTNFACE)
            .Width                  = 90
            .Height                 = 17
            .FTabStop               = True
            .OnHandleIsAllocated    = @HandleIsAllocated
        End With
    End Constructor

    Destructor CheckBox
    End Destructor
End namespace
