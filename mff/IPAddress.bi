'###############################################################################
'#  IPAddress.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QIPAddress(__Ptr__) *Cast(IPAddress Ptr, __Ptr__)
    
    Type IPAddress Extends Control
        Private:
			#IfNdef __USE_GTK__
				Declare Static Sub WndProc(ByRef Message As Message)
				Declare Sub ProcessMessage(ByRef Message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			#EndIf
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    #IfNdef __USE_GTK__
		Sub IPAddress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QIPAddress(Sender.Child)
					 
				End With
			End If
		End Sub

		Sub IPAddress.WndProc(ByRef Message As Message)
		End Sub

		Sub IPAddress.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage Message
		End Sub
	#EndIf

    Operator IPAddress.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor IPAddress
		#IfNdef __USE_GTK__
			Dim As INITCOMMONCONTROLSEX icex

			icex.dwSize = sizeof(INITCOMMONCONTROLSEX)
			icex.dwICC =  ICC_INTERNET_CLASSES

			InitCommonControlsEx(@icex)
		#EndIf

        With This
			WLet FClassName, "IPAddress"
			#IfNdef __USE_GTK__
				.RegisterClass "IPAddress", WC_IPADDRESS
				WLet FClassAncestor, WC_IPADDRESS
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
            .Width        = 100
            .Height       = 32
            .Child        = @This
        End With
    End Constructor

    Destructor IPAddress
		#IfNdef __USE_GTK__
			UnregisterClass "IPAddress",GetModuleHandle(NULL)
		#EndIf
    End Destructor
End Namespace
