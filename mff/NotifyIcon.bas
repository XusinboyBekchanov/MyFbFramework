'################################################################################
'#  NotifyIcon.bas                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2025)                                          #
'################################################################################

#include once "NotifyIcon.bi"
#ifdef __USE_WINAPI__
	Const WM_SHELLNOTIFY = WM_USER + 5
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function NotifyIcon.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "balloontipicon": Return @BalloonTipIcon
			Case "balloontipicontype": Return @FBalloonTipIconType
			Case "balloontiptext": Return @FNotifyIconData.szInfo
			Case "balloontiptitle": Return @FNotifyIconData.szInfoTitle
			Case "contextmenu": Return ContextMenu
			Case "icon": Return @Icon
			Case "text": Return @FNotifyIconData.szTip
			Case "visible": Return @FVisible
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function NotifyIcon.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value <> 0 Then
				Select Case LCase(PropertyName)
				Case "balloontipicon": This.BalloonTipIcon = QWString(Value)
				Case "balloontipicontype": This.BalloonTipIconType = *Cast(ToolTipIconType Ptr, Value)
				Case "balloontiptext": This.BalloonTipText = QWString(Value)
				Case "balloontiptitle": This.BalloonTipTitle = QWString(Value)
				Case "contextmenu": This.ContextMenu = QPopupMenu(Value)
				Case "icon": This.Icon = QWString(Value)
				Case "text": This.Text = QWString(Value)
				Case "visible": This.Visible = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property NotifyIcon.BalloonTipIconType As ToolTipIconType
		Return FBalloonTipIconType
	End Property
	
	Private Sub NotifyIcon.ChangeStyle(ByRef Style As Integer, iStyle As Integer, Value As Boolean)
		If Value Then
			If ((Style And iStyle) <> iStyle) Then Style = Style Or iStyle
		ElseIf ((Style And iStyle) = iStyle) Then
			Style = Style And Not iStyle
		End If
	End Sub
	
	Private Property NotifyIcon.BalloonTipIconType(Value As ToolTipIconType)
		FBalloonTipIconType = Value
		#ifdef __USE_WINAPI__
			ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_NONE, False
			ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_INFO, False
			ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_WARNING, False
			ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_ERROR, False
			ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_USER, False
			Select Case FBalloonTipIconType
			Case ToolTipIconType.None: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_NONE, True
			Case ToolTipIconType.Info: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_INFO, True
			Case ToolTipIconType.Warning: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_WARNING, True
			Case ToolTipIconType.Error: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_ERROR, True
			Case ToolTipIconType.User: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_USER, True
			End Select
		#endif
	End Property
	
	Private Property NotifyIcon.BalloonTipText ByRef As WString
		#ifdef __USE_WINAPI__
			Return FNotifyIconData.szInfo
		#else
			Return ""
		#endif
	End Property
	
	Private Property NotifyIcon.BalloonTipText(ByRef Value As WString)
		#ifdef __USE_WINAPI__
			FNotifyIconData.szInfo = Value
		#endif
	End Property
	
	Private Property NotifyIcon.BalloonTipTitle ByRef As WString
		#ifdef __USE_WINAPI__
			Return FNotifyIconData.szInfoTitle
		#else
			Return ""
		#endif
	End Property
	
	Private Property NotifyIcon.BalloonTipTitle(ByRef Value As WString)
		#ifdef __USE_WINAPI__
			FNotifyIconData.szInfoTitle = Value
		#endif
	End Property
	
	Private Property NotifyIcon.Text ByRef As WString
		#ifdef __USE_WINAPI__
			Return FNotifyIconData.szTip
		#else
			Return ""
		#endif
	End Property
	
	Private Property NotifyIcon.Text(ByRef Value As WString)
		#ifdef __USE_WINAPI__
			FNotifyIconData.szTip = Value
		#endif
	End Property
	
	Private Property NotifyIcon.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property NotifyIcon.Visible(Value As Boolean)
		'If FVisible <> Value Then
		FVisible = Value
		If Not FDesignMode Then
			#ifdef __USE_WINAPI__
				If Value Then
					If FParent AndAlso FParent->FHandle Then
						FNotifyIconData.hWnd = FParent->FHandle
						Shell_NotifyIcon(NIM_ADD, Cast(PNOTIFYICONDATA, @FNotifyIconData))
					End If
				Else
					Shell_NotifyIcon(NIM_DELETE, Cast(PNOTIFYICONDATA, @FNotifyIconData))
				End If
			#endif
		End If
		'End If
	End Property
	
	Private Sub NotifyIcon.IconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
		With *Cast(NotifyIcon Ptr, Sender.Graphic)
			#ifdef __USE_WINAPI__
				.FNotifyIconData.hIcon = Sender.Handle
			#endif
		End With
	End Sub
	
	Private Sub NotifyIcon.BalloonTipIconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
		With *Cast(NotifyIcon Ptr, Sender.Graphic)
			#ifdef __USE_WINAPI__
				.FNotifyIconData.hBalloonIcon = Sender.Handle
			#endif
		End With
	End Sub
	
	Private Sub NotifyIcon.ShowBalloonTip(timeout As Integer)
		FNotifyIconData.uFlags = NIF_INFO
		FNotifyIconData.uTimeout = timeout
		
		Shell_NotifyIcon(NIM_MODIFY, Cast(PNOTIFYICONDATA, @FNotifyIconData))
	End Sub
	
	Private Sub NotifyIcon.ShowBalloonTip(timeout As Integer, ByRef tipTitle As WString, ByRef tipText As WString, tipIconType As ToolTipIconType, tipIcon As My.Sys.Drawing.Icon Ptr = 0)
		FNotifyIconData.uFlags = NIF_INFO
		FNotifyIconData.szInfoTitle = tipTitle
		FNotifyIconData.szInfo = tipText
		FNotifyIconData.uTimeout = timeout
		ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_NONE, False
		ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_INFO, False
		ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_WARNING, False
		ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_ERROR, False
		ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_USER, False
		Select Case tipIconType
		Case ToolTipIconType.None: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_NONE, True
		Case ToolTipIconType.Info: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_INFO, True
		Case ToolTipIconType.Warning: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_WARNING, True
		Case ToolTipIconType.Error: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_ERROR, True
		Case ToolTipIconType.User: ChangeStyle FNotifyIconData.dwInfoFlags, NIIF_USER, True
		End Select
		If tipIcon Then FNotifyIconData.hBalloonIcon = tipIcon->Handle
		
		Shell_NotifyIcon(NIM_MODIFY, Cast(PNOTIFYICONDATA, @FNotifyIconData))
	End Sub
	
	Function NotifyIcon.IsWindowsVistaOrHigher() As Boolean
		Dim As OSVERSIONINFOEX osvi
		osvi.dwOSVersionInfoSize = SizeOf(OSVERSIONINFOEX)
		
		If GetVersionEx(Cast(OSVERSIONINFO Ptr, @osvi)) = 0 Then Return False
		Return (osvi.dwMajorVersion > 6) Or (osvi.dwMajorVersion = 6 And osvi.dwMinorVersion >= 0)
	End Function
	
	Private Constructor NotifyIcon
		WLet(FClassName, "NotifyIcon")
		Icon.Graphic = @This
		Icon.Changed = @IconChanged
		BalloonTipIcon.Graphic = @This
		BalloonTipIcon.Changed = @BalloonTipIconChanged
		#ifdef __USE_WINAPI__
			With FNotifyIconData
				If IsWindowsVistaOrHigher Then
					.cbSize = SizeOf (NOTIFYICONDATANEW)
				Else
					.cbSize = SizeOf (NOTIFYICONDATA)
				End If
				.uID = CUInt(@This)
				.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
				.uCallbackMessage = WM_SHELLNOTIFY
				.szTip = ""
				.uVersion = NOTIFYICON_VERSION
			End With
		#endif
	End Constructor
	
	Private Destructor NotifyIcon
		
	End Destructor
End Namespace
