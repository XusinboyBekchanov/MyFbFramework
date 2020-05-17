'###############################################################################
'#  UpDown.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TUpDown.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "UpDown.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
	Property UpDown.MinValue As Integer
		Return FMinValue
	End Property
	
	Property UpDown.MinValue(Value As Integer)
		FMinValue = Value
		#ifndef __USE_GTK__
			If Handle Then SendMessage(Handle, UDM_SETRANGE, 0, MakeLong(FMaxValue, FMinValue))
		#endif
	End Property
	
	Property UpDown.MaxValue As Integer
		Return FMaxValue
	End Property
	
	Property UpDown.MaxValue(Value As Integer)
		FMaxValue = Value
		#ifndef __USE_GTK__
			If Handle Then SendMessage(Handle, UDM_SETRANGE, 0, MakeLong(FMaxValue, FMinValue))
		#endif
	End Property
	
	Property UpDown.Position As Integer
		#IfNDef __USE_GTK__
			If Handle Then
				FPosition = LoWord(SendMessage(Handle, UDM_GETPOS, 0, 0))
			End If
		#EndIf
		Return FPosition
	End Property
	
	Property UpDown.Position(Value As Integer)
		FPosition = Value
		#IfNDef __USE_GTK__
			If Handle Then
				SendMessage(Handle, UDM_SETPOS, 0, MakeLong(FPosition, 0))
				If FAssociate Then
					FAssociate->Text = Str(Position)
				End If
			End If
		#EndIf
	End Property
	
	Property UpDown.Increment As Integer
		Return FIncrement
	End Property
	
	Property UpDown.Increment(Value As Integer)
		If Value <> FIncrement then
			FIncrement = Value
			#IfNDef __USE_GTK__
				If Handle then
					SendMessage(Handle, UDM_GETACCEL, 1, CInt(@FUDAccel(0)))
					FUDAccel(0).nInc = Value
					SendMessage(Handle, UDM_SETACCEL, 1, CInt(@FUDAccel(0)))
				End If
			#EndIf
		End If
	End Property
	
	Property UpDown.Thousands As Boolean
		Return FThousands
	End Property
	
	Property UpDown.Thousands(Value As Boolean)
		If FThousands <> Value Then
			FThousands = Value
			#IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
			#EndIf
		End If
	End Property
	
	Property UpDown.Wrap As Boolean
		Return FWrap
	End Property
	
	Property UpDown.Wrap(Value As Boolean)
		If FWrap <> Value Then
			FWrap = Value
			#IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
			#EndIf
		End If
	End Property
	
	Property UpDown.Style As Integer
		Return FStyle
	End Property
	
	Property UpDown.Style(Value As Integer)
		Dim As Integer OldStyle,Temp
		OldStyle = FStyle
		If FStyle <> Value Then
			FStyle = Value
			If OldStyle = 0 Then
				Temp = This.Width
				This.Width = Height
				Height = Temp
			End If
			#IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR UDS_SETBUDDYINT OR AStyle(Abs_(FStyle)) OR AAlignment(Abs_(FAlignment)) OR AWrap(Abs_(FWrap)) OR AArrowKeys(Abs_(FArrowKeys)) OR AAThousand(Abs_(FThousands))
			#EndIf
		End If
	End Property
	
	Property UpDown.Associate As Control Ptr
		Return FAssociate
	End Property
	
	Property UpDown.Associate(Value As Control Ptr)
		FAssociate = Value
		If FAssociate Then
			If UCase(FAssociate->ClassName) = "TEXTBOX" Then
				#IfNDef __USE_GTK__
					SendMessage(Handle, UDM_SETBUDDY, CInt(FAssociate->Handle), 0)
				#EndIf
				FAssociate->Text = WStr(Position)
			Else
			End If
		End If
	End Property
	
	#IfNDef __USE_GTK__
		Sub UpDown.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QUpDown(Sender.Child)
					SendMessage(.Handle, UDM_SETRANGE, 0, MakeLong(.FMaxValue, .FMinValue))
					SendMessage(.Handle, UDM_SETPOS, 0, MakeLong(.FPosition, 0))
					SendMessage(.Handle, UDM_GETACCEL, 1, CInt(@.FUDAccel(0)))
					.FUDAccel(0).nInc = .FIncrement
					SendMessage(.Handle, UDM_SETACCEL, 1, CInt(@.FUDAccel(0)))
					.Position = .FPosition
				End With
			End If
		End Sub
		
		Sub UpDown.WndProc(BYREF Message As Message)
		End Sub
		
		Sub UpDown.ProcessMessage(BYREF Message As Message)
			Select Case Message.Msg
			Case WM_SIZE
				Dim As Rect R
				GetClientRect Handle,@R
				InvalidateRect Handle,@R,True
			Case CM_NOTIFY
				Dim As NMHDR Ptr NM
				NM = Cast(LPNMHDR,Message.lParam)
				If NM->Code = UDN_DELTAPOS Then
					Dim As NM_UPDOWN Ptr NMUD
					NMUD = Cast(NM_UPDOWN Ptr,Message.lParam)
					If OnChanging Then OnChanging(This,NMUD->iPos,NMUD->iDelta)
				End If
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf
	
	Operator UpDown.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor UpDown
		Dim As Boolean Result
		#IfDef __USE_GTK__
			widget = gtk_spin_button_new(NULL, 1, 0)
		#Else
			Dim As INITCOMMONCONTROLSEX ICC
			ICC.dwSize = SizeOF(ICC)
			ICC.dwICC  = ICC_UPDOWN_CLASS
			Result = InitCommonControlsEx(@ICC)
			If Not Result Then InitCommonControls
			AStyle(0)        = 0
			AStyle(1)        = UDS_HORZ
			AAlignment(0)    = UDS_ALIGNRIGHT
			AAlignment(1)    = UDS_ALIGNLEFT
			AWrap(0)         = 0
			AWrap(1)         = UDS_WRAP
			AArrowKeys(0)    = 0
			AArrowKeys(1)    = UDS_ARROWKEYS
			AAThousand(0)    = UDS_NOTHOUSANDS
			AAThousand(1)    = 0
		#endif
		FMinValue        = 0
		FMaxValue        = 100
		FArrowKeys       = True
		FIncrement       = 1
		FAlignment       = 0
		FStyle           = 0
		FThousands       = True
		FTabStop         = True
		#ifndef __USE_GTK__
			FUDAccel(0).nInc = FIncrement
		#endif
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "UpDown", UPDOWN_CLASS
				.ChildProc         = @WndProc
				WLet FClassAncestor, UPDOWN_CLASS
				.ExStyle           = 0
				Base.Style             = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(Abs_(FStyle)) Or AAlignment(Abs_(FAlignment)) Or AWrap(Abs_(FWrap)) Or AArrowKeys(Abs_(FArrowKeys)) Or AAThousand(Abs_(FThousands))
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
				.Width             = GetSystemMetrics(SM_CXVSCROLL)
				.Height            = GetSystemMetrics(SM_CYVSCROLL)
				.Height            = .Height + (.Height \ 2)
			#endif
			WLet FClassName, "UpDown"
		End With
	End Constructor
	
	Destructor UpDown
	End Destructor
End Namespace
