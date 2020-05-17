'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "DateTimePicker.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub DateTimePicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QDateTimePicker(Sender.Child)
					Var SMD = Sender.Handle
					Dim ST As SYSTEMTIME
					ST.wYear=2020
					ST.wmonth=1
					ST.wday=1
					ST.wHour=0
					ST.wMinute=1
					ST.wSecond=0
					Dim s As String
					s = "HH" & ":" & "mm" & ":" & "ss"
					'SendMessage(SMD, DTM_SETFORMATW,0, Cast(LPARAM,@s))
					SendMessage(SMD,DTM_SETSYSTEMTIME,0,Cast(LPARAM,@ST))
				End With
			End If
		End Sub
		
		Sub DateTimePicker.WndProc(ByRef Message As Message)
		End Sub
		
	#endif
	
	Property DateTimePicker.TimePicker As Boolean 'David Change
		Return FTimePicker
	End Property
	
	Property DateTimePicker.TimePicker(Value As Boolean)'David Change
		If FTimePicker <> Value Then
			FTimePicker = Value
		End If
		#ifndef __USE_GTK__
			If FTimePicker Then
				This.Style  = WS_CHILD Or DTS_TIMEFOrMAT Or DTS_UPDOWN Or DTS_SHOWNONE ' NO repons
			Else
				This.Style  = WS_CHILD Or DTS_SHORTDATEFORMAT
			End If
		#endif
	End Property
	
	Sub DateTimePicker.ProcessMessage(ByRef Message As Message)
		#IfnDef __USE_GTK__
			Select Case Message.Msg
			Case WM_KEYUP
				'David Change
				'bShift = GetKeyState(VK_SHIFT) And 8000
				'bCtrl = GetKeyState(VK_CONTROL) And 8000
				If ParentHandle>0 Then
					Select Case message.wParam
					Case VK_RETURN, VK_ESCAPE,VK_LEFT,VK_RIGHT,VK_TAB 'VK_DOWN, VK_UP
						PostMessage(ParentHandle, CM_COMMAND, Message.wParam, 9993)
						'case VK_HOME,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE,VK_BACK
						'case VK_MENU 'VK_CONTROL VK_SHIFT
						'print "TextBox VK_MENU: ",VK_MENU
						'case else
					End Select
				End If
				InvalidateRect(Handle,Null,False)
				UpdateWindow Handle
				
			Case CM_NOTIFY 'WM_PAINT
				InvalidateRect(Handle,Null,False)
				UpdateWindow Handle
			Case Else
			End Select
		#Endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator DateTimePicker.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor DateTimePicker
		Dim As Boolean Result
		
		'Dim As INITCOMMONCONTROLSEX ICC
		
		'ICC.dwSize = SizeOF(ICC)
		
		'ICC.dwICC  = ICC_DATE_CLASSES
		
		'Result = InitCommonControlsEx(@ICC)
		'If Not Result Then InitCommonControls
		Text = ""
		FTabStop           = True
		With This
			WLet FClassName, "DateTimePicker"
			WLet FClassAncestor, "SysDateTimePick32"
			#ifndef __USE_GTK__
				Base.RegisterClass WStr("DateTimePicker"), WStr("SysDateTimePick32")
				.ExStyle      = 0 'WS_EX_LEFT OR WS_EX_LTRREADING OR WS_EX_RIGHTSCROLLBAR OR WS_EX_CLIENTEDGE
				.Style        = WS_CHILD Or DTS_SHORTDATEFORMAT
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor DateTimePicker
		#ifndef __USE_GTK__
			UnregisterClass "DateTimePicker",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
