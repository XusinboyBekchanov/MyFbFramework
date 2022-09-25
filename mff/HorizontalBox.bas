'###############################################################################
'#  HorizontalBox.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "HorizontalBox.bi"

Namespace My.Sys.Forms
	Private Function HorizontalBox.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function HorizontalBox.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Private Property HorizontalBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property HorizontalBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property HorizontalBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property HorizontalBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property HorizontalBox.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property HorizontalBox.Text(ByRef Value As WString)
		Base.Text = Value
	End Property
		
	#ifdef __USE_WINAPI__
		Private Sub HorizontalBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QHorizontalBox(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub HorizontalBox.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	Private Sub HorizontalBox.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_PAINT, WM_CREATE, WM_ERASEBKGND
				Dim As Integer W,H
				Dim As HDC Dc, memDC
				Dim As HBITMAP Bmp
				Dim As ..Rect R, RFrame
				GetClientRect Handle, @R
				Dc = GetDC(Handle)
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
					End If
				Else
					If FDarkMode Then
						SetDark False
					End If
				End If
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					Bmp   = CreateCompatibleBitmap(Dc, R.Right, R.Bottom)
					SelectObject(memDC, Bmp)
					FillRect memDC, @R, This.Brush.Handle
					SetBkMode(memDC, TRANSPARENT)
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					SetBkColor(memDC, OPAQUE)
					Canvas.HandleSetted = True
					Canvas.Handle = memDC
					If OnPaint Then OnPaint(This, Canvas)
					Canvas.HandleSetted = False
					BitBlt(Dc, 0, 0, R.Right, R.Bottom, memDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(memDC)
				Else
					SetBkMode Dc, TRANSPARENT
					FillRect Dc, @R, This.Brush.Handle
					SetBkColor Dc, OPAQUE
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					Canvas.Handle = Dc
					If OnPaint Then OnPaint(This, Canvas)
				End If
				ReleaseDC Handle, Dc
				Message.Result = 0
				Exit Sub
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Property HorizontalBox.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property HorizontalBox.Visible(Value As Boolean)
		Base.Visible = Value
	End Property
	
	Private Operator HorizontalBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor HorizontalBox
		With This
			#ifdef __USE_GTK__
				#ifdef __USE_GTK2__
					widget = gtk_hbox_new(False, 0)
				#else
					widget = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
				#endif
				.RegisterClass "HorizontalBox", @This
			#endif
			FAutoSize = True
			Canvas.Ctrl    = @This
			.Child       = @This
			#ifdef __USE_WINAPI__
				.RegisterClass "HorizontalBox"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "HorizontalBox")
			.Width       = 121
			.Height      = 41
		End With
	End Constructor
	
	Private Destructor HorizontalBox
		#ifdef __USE_WINAPI__
			UnregisterClass "HorizontalBox", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
