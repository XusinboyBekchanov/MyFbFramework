'###############################################################################
'#  Animate.bas                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TAnimate.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "Animate.bi"

Namespace My.Sys.Forms
	Sub Animate.GetAnimateInfo
		#ifndef __USE_GTK__
			Dim As HRSRC Resource
			Dim As HGLOBAL Global
			Dim As Any Ptr PResource
			Dim As UByte Ptr P
			Dim As Integer F, Size
			Dim As Integer Ptr Buff = Allocate(18*SizeOf(Integer))
			F = FreeFile
			If *FFile <> "" Then
				.Open *FFile For Binary Access Read As #F
				Get #F, , *Buff,18
				.Close #F
				FFrameCount  = Buff[12]
				FFrameWidth  = Buff[16]
				FFrameHeight = Buff[17]
			Else
				Resource  = FindResource(GetModuleHandle("Shell32"),MakeIntResource(FCommonAvi),"AVI")
				Global    = LoadResource(GetModuleHandle("Shell32"),Resource)
				PResource = LockResource(Global)
				Size = SizeOfResource(GetModuleHandle("Shell32"),Resource)
				P = Allocate(Size)
				P = PResource
				FreeResource(Resource)
				memcpy Buff, P, 18 * SizeOf(Integer)
				FFrameCount  = Buff[12]
				FFrameWidth  = Buff[16]
				FFrameHeight = Buff[17]
			End If
		#endif
	End Sub
	
	Property Animate.Center As Boolean
		Return FCenter
	End Property
	
	Property Animate.Center(Value As Boolean)
		If FCenter <> Value Then
			FCenter = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.Transparency As Boolean
		Return FTransparent
	End Property
	
	Property Animate.Transparency(Value As Boolean)
		If FTransparent <> Value Then
			FTransparent = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.Timers As Boolean
		Return FTimers
	End Property
	
	Property Animate.Timers(Value As Boolean)
		If FTimers <> Value Then
			FTimers = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.File ByRef As WString
		Return WGet(FFile)
	End Property
	
	Property Animate.File(ByRef Value As WString)
		FFile = Reallocate(FFile, (Len(Value) + 1) * SizeOf(WString))
		*FFile = Value
		#ifndef __USE_GTK__
			If FHandle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle(NULL))
				Open
			End If
		#endif
	End Property
	
	Property Animate.Repeat As Integer
		Return FRepeat
	End Property
	
	Property Animate.Repeat(Value As Integer)
		FRepeat = Value
	End Property
	
	Property Animate.AutoPlay As Boolean
		Return FAutoPlay
	End Property
	
	Property Animate.AutoPlay(Value As Boolean)
		If FAutoPlay <> Value Then
			FAutoPlay = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Property Animate.AutoSize(Value As Boolean)
		FAutoSize = Value
		If FAutoSize Then
			This.Width = FFrameWidth
			This.Height = FFrameHeight
		End If
	End Property
	
	Property Animate.CommonAvi As Integer
		Return FCommonAvi
	End Property
	
	Property Animate.CommonAvi(Value As Integer)
		FCommonAvi = Value
		#ifndef __USE_GTK__
			If Handle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle("Shell32"))
				Open
			End If
		#endif
	End Property
	
	Property Animate.StartFrame As Integer
		Return FStartFrame
	End Property
	
	Property Animate.StartFrame(Value As Integer)
		FstartFrame = Value
		If FStartFrame < 0 Then FStartFrame = 0
		If FPlay Then This.Stop
		Play
	End Property
	
	Property Animate.StopFrame As Integer
		Return FStopFrame
	End Property
	
	Property Animate.StopFrame(Value As Integer)
		FStopFrame = Value
		If FStopFrame > FFrameCount Then FStopFrame = FFrameCount
		If FPlay Then This.Stop
		Play
	End Property
	
	Function Animate.FrameCount As Integer
		GetAnimateInfo
		Return FFrameCount
	End Function
	
	Sub Animate.HandleIsAllocated(ByRef Sender As Control)
		If Sender.Child Then
			With QAnimate(Sender.Child)
				#ifndef __USE_GTK__
					SetClassLongPtr(.Handle,GCLP_HBRBACKGROUND,0)
				#endif
				If .FOpen Then .Open
				If .FPlay Then .Play
			End With
		End If
	End Sub
	
	#ifndef __USE_GTK__
		Sub Animate.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
		
		Sub Animate.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case ACN_START
					If OnStart Then OnStart(This)
				Case ACN_STOP
					If OnStop Then OnStop(This)
				End Select
			Case WM_NCHITTEST
				Message.Result = HTCLIENT
			Case WM_ERASEBKGND
				Dim As Rect R
				GetClientRect Handle,@R
				FillRect Cast(HDC, Message.wParam),@R, Brush.Handle
				Message.Result = -1
			Case WM_NCPAINT
				Dim As HDC Dc
				Dc = GetDCEx(Handle, 0, DCX_WINDOW Or DCX_CACHE Or DCX_CLIPSIBLINGS)
				'Future utilisation
				ReleaseDC Handle,Dc
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Sub Animate.Open
		#ifndef __USE_GTK__
			If Handle Then
				If CommonAVI = 0 Then
					If *FFile <> "" Then
						If FindResource(GetModuleHandle(NULL), *FFile,"AVI") Then
							GetAnimateInfo
							Animate_Open(FHandle, CInt(MakeIntResource(*FFile)))
							FOpen = 1
						Else
							GetAnimateInfo
							Animate_Open(FHandle, CInt(FFile))
							FOpen = 1
						End If
					End If
				ElseIf CommonAVI <> 0 Then
					If FindResource(GetModuleHandle("Shell32"), MakeIntResource(FCommonAvi), "AVI") Then
						GetAnimateInfo
						Perform(ACM_OPEN, CInt(GetModuleHandle("Shell32")), CInt(MakeIntResource(FCommonAvi)))
						FOpen = 1
					End If
				End If
			End If
		#endif
	End Sub
	
	Sub Animate.Play
		#ifndef __USE_GTK__
			If Handle Then
				Perform(ACM_PLAY,FRepeat,MakeLong(FStartFrame,FStopFrame))
				FPlay = 1
			End If
		#endif
	End Sub
	
	Sub Animate.Stop
		#IfNDef __USE_GTK__
			If Handle Then
				Perform(ACM_STOP,0,0)
				FPlay = 0
			End If
		#EndIf
	End Sub
	
	Sub Animate.Close
		#IfNDef __USE_GTK__
			If Handle Then
				If OnClose Then OnClose(This)
				Perform(ACM_OPEN,0,0)
				FOpen = 0
			End If
		#EndIf
	End Sub
	
	Operator Animate.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor Animate
		Dim As Boolean Result
		#ifndef __USE_GTK__
			Dim As INITCOMMONCONTROLSEX ICC
			FFile = CAllocate(0)
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_ANIMATE_CLASS
			Result = InitCommonControlsEx(@ICC)
			If Not Result Then InitCommonControls
			ACenter(0)      = 0
			ACenter(1)      = ACS_CENTER
			ATransparent(0) = 0
			ATransparent(1) = ACS_TRANSPARENT
			ATimer(0)       = 0
			ATimer(1)       = ACS_TIMER
			AAutoplay(0)    = 0
			AAutoplay(1)    = ACS_AUTOPLAY
		#endif
		FRepeat         = -1
		FStopFrame      = -1
		FStartFrame     = 0
		With This
			WLet FClassName, "Animate"
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "Animate", ANIMATE_CLASS
				.ChildProc         = @WndProc
				WLet FClassAncestor, ANIMATE_CLASS
				.ExStyle           = WS_EX_TRANSPARENT
				.Style             = WS_CHILD Or ACenter(FCenter) Or ATransparent(FTransparent) Or ATimer(FTimers) Or AAutoPlay(FAutoPlay)
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width             = 100
			.Height            = 80
		End With
	End Constructor
	
	Destructor Animate
		If FFile Then Deallocate FFile
	End Destructor
End Namespace
