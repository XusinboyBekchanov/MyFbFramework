'###############################################################################
'#  HotKey.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "HotKey.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub HotKey.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QHotKey(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub HotKey.WndProc(ByRef Message As Message)
		End Sub
		
		Sub HotKey.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(This)
				End Select
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Property HotKey.Text ByRef As WString
		#ifndef __USE_GTK__
			Dim wHotKey As Word
			wHotKey = SendMessage(Handle, HKM_GETHOTKEY, 0, 0)
			FText = GetChrKeyCode(LoByte(LoWord(wHotKey)))
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_SHIFT) = HOTKEYF_SHIFT Then FText = "Shift+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_ALT) = HOTKEYF_ALT Then FText = "Alt+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_CONTROL) = HOTKEYF_CONTROL Then FText = "Ctrl+" & FText
		#endif
		Return *FText.vptr
	End Property
	
	Property HotKey.Text(ByRef Value As WString)
		FText = Value
		#ifndef __USE_GTK__
			Dim sKey As String = Value
			Dim wHotKey As Word
			Var Pos1 = InStrRev(sKey, "+")
			If Pos1 > 0 Then sKey = Mid(sKey, Pos1 + 1)
			wHotKey = MAKEWORD(GetAscKeyCode(sKey), IIf(InStr(Value, "Ctrl") > 0, HOTKEYF_CONTROL, 0) Or IIf(InStr(Value, "Shift") > 0, HOTKEYF_SHIFT, 0) Or IIf(InStr(Value, "Alt") > 0, HOTKEYF_ALT, 0))
			SendMessage(Handle, HKM_SETHOTKEY, wHotKey, 0)
		#endif
	End Property
	
	Operator HotKey.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor HotKey
		With This
			WLet FClassName, "HotKey"
			WLet FClassAncestor, "msctls_hotkey32"
			FTabStop           = True
			#ifndef __USE_GTK__
				.RegisterClass "HotKey","msctls_hotkey32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor HotKey
		#ifndef __USE_GTK__
			UnregisterClass "HotKey",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
