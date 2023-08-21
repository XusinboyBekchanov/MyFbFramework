'################################################################################
'#  UserControl.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov                                                 #
'################################################################################

#include once "UserControl.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Private Sub UserControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QUserControl(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub UserControl.WndProc(ByRef Message As Message)
		End Sub
	#endif
	Private Sub UserControl.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_PAINT
				Dim As HDC Dc
				Dim As PAINTSTRUCT Ps
				Canvas.HandleSetted = True
				Dc = BeginPaint(Handle, @Ps)
				FillRect Dc, @Ps.rcPaint, Brush.Handle
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				EndPaint Handle, @Ps
				Message.Result = 0
				Canvas.HandleSetted = False
				Return
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator UserControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor UserControl
		With This
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "UserControl", @This
			#endif
			Canvas.Ctrl    = @This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "UserControl"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet(FClassName, "UserControl")
			.Width       = 121
			.Height      = 41
		End With
	End Constructor
	
	Private Destructor UserControl
		#ifndef __USE_GTK__
			UnregisterClass "UserControl", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
