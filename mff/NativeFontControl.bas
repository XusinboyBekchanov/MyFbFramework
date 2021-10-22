''################################################################################
''#  MonthCalendar.bi                                                            #
''#  This file is part of MyFBFramework                                          #
''#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
''################################################################################
'
'#include once "NativeFontControl.bi"
'
'Namespace My.Sys.Forms
'	#ifndef __USE_GTK__
'		Sub NativeFontControl.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
'			If Sender.Child Then
'				With QNativeFontControl(Sender.Child)
'					
'				End With
'			End If
'		End Sub
'		
'		Sub NativeFontControl.WndProc(ByRef Message As Message)
'		End Sub
'		
'		Sub NativeFontControl.ProcessMessage(ByRef Message As Message)
'			Base.ProcessMessage(Message)
'		End Sub
'	#endif
'	
'	Operator NativeFontControl.Cast As My.Sys.Forms.Control Ptr
'		Return Cast(My.Sys.Forms.Control Ptr, @This)
'	End Operator
'	
'	Constructor NativeFontControl
'		#ifndef __USE_GTK__
'			Dim As INITCOMMONCONTROLSEX icex
'			
'			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
'			icex.dwICC =  ICC_NATIVEFNTCTL_CLASS
'			
'			InitCommonControlsEx(@icex)
'		#endif
'		With This
'			WLet(FClassName, "NativeFontControl")
'			WLet(FClassAncestor, "NativeFontCtl")
'			#ifndef __USE_GTK__
'				.RegisterClass "NativeFontControl","NativeFontCtl"
'				.Style        = WS_CHILD Or NFS_EDIT Or NFS_STATIC Or NFS_LISTCOMBO Or NFS_BUTTON Or NFS_ALL
'				.ExStyle      = 0
'				.ChildProc    = @WndProc
'				.OnHandleIsAllocated = @HandleIsAllocated
'			#endif
'			.Width        = 175
'			.Height       = 21
'			.Child        = @This
'		End With
'	End Constructor
'	
'	Destructor NativeFontControl
'		#ifndef __USE_GTK__
'			UnregisterClass "NativeFontControl",GetModuleHandle(NULL)
'		#endif
'	End Destructor
'End Namespace
