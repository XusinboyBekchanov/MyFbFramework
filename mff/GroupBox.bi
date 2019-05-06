'###############################################################################
'#  GroupBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGroupBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include Once "ContainerControl.bi"

Namespace My.Sys.Forms
    #DEFINE QGroupBox(__Ptr__) *Cast(GroupBox Ptr,__Ptr__)

    Type GroupBox Extends ContainerControl
        Private:
            FParentColor As Integer
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Virtual Sub ProcessMessage(BYREF Message As Message)
			#EndIf
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
        #IfDef __USE_GTK__
			WLet FText, WStr(gtk_frame_get_label(GTK_FRAME(widget)))
			Return *FText
        #Else
			Return Text
		#EndIf
    End Property

    Property GroupBox.Caption(ByRef Value As WString)
		#IfDef __USE_GTK__
			If widget Then gtk_frame_set_label(GTK_FRAME(widget), ToUtf8(Value))
		#Else
			Text = Value
		#EndIf 
    End Property

    Property GroupBox.ParentColor As Boolean
       Return FParentColor
    End Property
        
    Property GroupBox.ParentColor(Value As Boolean)
       FParentColor = Value
       If FParentColor Then
          This.BackColor = This.Parent->BackColor
          Invalidate
       End If
    End Property

	#IfNDef __USE_GTK__
		Sub GroupBox.WndProc(BYREF Message As Message)
			If Message.Sender Then
			End If
		End Sub

		Sub GroupBox.ProcessMessage(BYREF Message As Message)
			Select Case Message.Msg
			Case WM_PAINT
				'Message.Result = True
				'Return
			Case WM_COMMAND
            	CallWindowProc(@SuperWndProc, GetParent(Handle), Message.Msg, Message.wParam, Message.lParam)
			Case CM_CTLCOLOR
				 Static As HDC Dc
				 Dc = Cast(HDC, Message.wParam)
				 SetBKMode Dc, TRANSPARENT
				 SetTextColor Dc, This.Font.Color
				 SetBKColor Dc, This.BackColor
				 SetBKMode Dc, OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = BN_CLICKED Then
					If OnClick Then OnClick(This)
				End If
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator GroupBox.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor GroupBox
        With This
            .Child       = @This
            #IfDef __USE_GTK__
				widget = gtk_frame_new(Null)
				.RegisterClass "GroupBox", @This
            #Else
				.RegisterClass "GroupBox", "Button"
            	.ChildProc   = @WndProc
            #EndIf
            WLet FClassName, "GroupBox"
            WLet FClassAncestor, "Button"
            #IfNDef __USE_GTK__
				.ExStyle     = WS_EX_TRANSPARENT
				.Style       = WS_CHILD OR WS_VISIBLE Or BS_GROUPBOX 'Or SS_NOPREFIX
				.BackColor       = GetSysColor(COLOR_BTNFACE)
			#EndIf
            .Width       = 121
            .Height      = 51
        End With    
    End Constructor

    Destructor GroupBox
    End Destructor
End namespace
