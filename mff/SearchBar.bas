'################################################################################
'#  SearchBar.bas                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2024)                                          #
'################################################################################

#include once "SearchBar.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function SearchBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function SearchBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
	#endif
	
	Private Property SearchBar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property SearchBar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property SearchBar.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property SearchBar.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub SearchBar.WndProc(ByRef message As Message)
		End Sub
		
		Private Sub SearchBar.MoveIcons
			Dim rcClient As Rect
			GetClientRect(FHandle, @rcClient)
			imgSearch.SetBounds 1, Fix(rcClient.Bottom - 16) / 2, 16, 17
			imgClear.SetBounds rcClient.Right - 16, (rcClient.Bottom - 16) / 2, 16, 16
		End Sub
	#endif
	
	Private Sub SearchBar.ProcessMessage(ByRef message As Message)
		#ifdef __USE_WINAPI__
			Select Case message.Msg
			Case WM_SIZE
				MoveIcons
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Sub SearchBar.imgSearch_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			Dim hPen As HPEN
			Dim As ..Rect R
			GetClientRect Sender.Handle, @R
			FillRect(Canvas.Handle, @R, Brush.Handle)
			Dim As HBRUSH PrevBrush = SelectObject(Canvas.Handle, GetStockObject(NULL_BRUSH))
			hPen = CreatePen(PS_SOLID, 2, BGR(61, 61, 118))
			SelectObject(Canvas.Handle, hPen)
			Ellipse(Canvas.Handle, 0, 1, 13, 14)
			DeleteObject(hPen)
			hPen = CreatePen(PS_SOLID, 1, BGR(89, 94, 95))
			SelectObject(Canvas.Handle, hPen)
			Ellipse(Canvas.Handle, 0, 1, 13, 14)
			DeleteObject(hPen)
			hPen = CreatePen(PS_SOLID, 2, BGR(89, 94, 95))
			SelectObject(Canvas.Handle, hPen)
			MoveToEx(Canvas.Handle, 10, 11, NULL)
			LineTo(Canvas.Handle, 16, 17)
			MoveToEx(Canvas.Handle, 10, 11, NULL)
			LineTo(Canvas.Handle, 16, 17)
			SelectObject(Canvas.Handle, PrevBrush)
			DeleteObject(hPen)
		End Sub
		
		Sub SearchBar.imgClear_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			Dim hPen As HPEN
			Dim As ..Rect R
			GetClientRect Sender.Handle, @R
			FillRect(Canvas.Handle, @R, Brush.Handle)
			hPen = CreatePen(PS_SOLID, 2, BGR(89, 94, 95))
			SelectObject(Canvas.Handle, hPen)
			MoveToEx(Canvas.Handle, 4, 4, NULL)
			LineTo(Canvas.Handle, 12, 12)
			MoveToEx(Canvas.Handle, 12, 4, NULL)
			LineTo(Canvas.Handle, 4, 12)
			DeleteObject(hPen)
		End Sub
		
		Sub SearchBar.imgClear_Click(ByRef Sender As Control)
			Text = ""
		End Sub
		
		Private Sub SearchBar.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QSearchBar(Sender.Child)
					#ifdef __USE_WASM__
						If .OnChange Then SetChangeEvent(.FHandle)
					#elseif defined(__USE_WINAPI__)
						If .FMaxLength = 0 Then
							.Perform(EM_LIMITTEXT, -1, 0)
						Else
							.Perform(EM_LIMITTEXT, .FMaxLength, 0)
						End If
						If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
						If .FMasked Then .Masked = True
						If .FSelStart <> 0 OrElse .FSelEnd <> 0 Then .SetSel .FSelStart, .FSelEnd
						If .FLeftMargin <> 0 Then
							SendMessage(.FHandle, EM_SETMARGINS, EC_LEFTMARGIN, MAKELPARAM(ScaleX(.FLeftMargin), ScaleX(.FRightMargin)))
						End If
						If .FRightMargin <> 0 Then
							SendMessage(.FHandle, EM_SETMARGINS, EC_RIGHTMARGIN, MAKELPARAM(ScaleX(.FLeftMargin), ScaleX(.FRightMargin)))
						End If
						.MoveIcons
					#endif
				End With
			End If
		End Sub
	#endif
	
	Private Operator SearchBar.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor SearchBar
		With This
			#ifdef __USE_GTK__
				widget = gtk_search_bar_new()
			#else
				RegisterClass "SearchBar", "Edit"
				OnHandleIsAllocated = @HandleIsAllocated
				ChildProc = @WndProc
				WLet(FClassAncestor, "Edit")
				FLeftMargin = 20
				FRightMargin = 20
				imgSearch.DoubleBuffered = True
				imgSearch.Designer = @This
				imgSearch.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @imgSearch_Paint)
				imgSearch.Parent = @This
				imgClear.DoubleBuffered = True
				imgClear.Designer = @This
				imgClear.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @imgClear_Paint)
				imgClear.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @imgClear_Click)
				imgClear.Parent = @This
			#endif
			FHideSelection    = False
			FTabIndex          = -1
			FTabStop           = True
			WLet(FClassName, "SearchBar")
			Child       = @This
			Width       = 121
			Height      = ScaleY(Font.Size / 72 * 96 + 6) '21
		End With
	End Constructor
	
	Private Destructor SearchBar
		#ifdef __USE_WINAPI__
			DestroyWindow FHandle
		#endif
	End Destructor
End Namespace
