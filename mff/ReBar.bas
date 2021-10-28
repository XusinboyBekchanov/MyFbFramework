'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ReBar.bi"

Namespace My.Sys.Forms
	Function ReBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ReBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property ReBar.BandCount() As Integer
		Return m_BandCount
	End Property
	
	Property ReBar.BandCount (value As Integer)
		If value > 0 Then m_BandCount = value
	End Property
	
	Property ReBar.BMP() ByRef As WString
		Return *m_BMP
	End Property
	
	Property ReBar.BMP(ByRef value As WString)
		If FileExists(value) = False Then MsgBox("Error in " & value): Exit Property
		WLet m_BMP, value
	End Property
	
	Property ReBar.BackColor() As Integer
		Return FBackColor
	End Property
	
	Property ReBar.BackColor(value As Integer)
		If value <> This.BackColor Then
			#ifndef __USE_GTK__
				FBackColor = value
				If Handle Then SendMessage(Handle, RB_SETBKCOLOR, 0, Cast(LPARAM, FBackColor))
				Invalidate
			#endif
		End If
	End Property
	
	Property ReBar.BandRect(ByVal uBand As Integer) As My.Sys.Drawing.RECT
		Dim rc As My.Sys.Drawing.RECT
		#ifndef __USE_GTK__
			Perform(RB_GETRECT, uBand, Cast(LPARAM, @rc))
		#endif
		Return rc
	End Property
	
	Sub ReBar.AddBand(value As Control Ptr, idx As Integer, ByRef Caption As WString)
		#ifndef __USE_GTK__
			If FHandle AndAlso Value->Handle Then
				Dim As REBARBANDINFO rbBand
				Dim As RECT rct
				
				rbBand.cbSize = SizeOf(REBARBANDINFO)
				rbBand.fMask = RBBIM_STYLE Or RBBIM_CHILD Or RBBIM_CHILDSIZE Or RBBIM_SIZE
				If (idx > -1) AndAlso ImageList AndAlso (ImageList->Count > 0) Then
					rbBand.fMask Or= RBBIM_IMAGE
					rbBand.iImage = idx
				End If
				If Caption <> "" Then
					rbBand.fMask Or= RBBIM_TEXT
					rbBand.lpText = @Caption
				End If
				rbBand.fStyle = RBBS_CHILDEDGE Or RBBS_GRIPPERALWAYS          ' (RBBIM_STYLE flag)
				
				rbBand.hwndChild = value->Handle                                       ' (RBBIM_CHILD flag)
				GetWindowRect(value->Handle, @rct)
				rbBand.cxMinChild = rct.Right - rct.Left                        ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = rct.Bottom - rct.Top                        ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cx = rct.Right - rct.Left                                ' Length of the band (RBBIM_SIZE flag)
				SendMessage(Handle, RB_INSERTBAND, -1, Cast(lParam, @rbBand))
			End If
		#endif
	End Sub
	
	Sub ReBar.AddBand(value As Control Ptr, ByRef Caption As WString)
		AddBand(value, -1, Caption)
	End Sub
	
	Sub ReBar.AddBand(value As Control Ptr)
		AddBand(value, -1, "")
	End Sub
	
	Sub ReBar.UpdateRebar()
		#ifndef __USE_GTK__
			If ImageList AndAlso ImageList->Count Then
				Dim As REBARINFO inf
				inf.cbSize = SizeOf(REBARINFO)
				inf.fMask = RBIM_IMAGELIST
				inf.himl = ImageList->Handle
				SendMessage(Handle, RB_SETBARINFO, 0, Cast(LPARAM, @inf))
			End If
		#endif
	End Sub
	
	Property ReBar.ShowBand(ByVal uBand As Integer, ByVal fShow As Boolean)
		#ifndef __USE_GTK__
			SendMessage(Handle, RB_SHOWBAND, uBand, fShow)
		#endif
	End Property
	
	Sub ReBar.Add(Ctrl As Control Ptr)
		Base.Add(Ctrl)
		AddBand Ctrl
	End Sub
	
	#ifndef __USE_GTK__
		Sub ReBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QReBar(Sender.Child)
					If .BackColor <> GetSysColor(COLOR_BTNFACE) Then SendMessage(.Handle, RB_SETBKCOLOR, 0, Cast(LPARAM, .BackColor))
					If .Font.Color <> 0 Then SendMessage(.Handle, RB_SETTEXTCOLOR, 0, Cast(LPARAM, .Font.Color))
					.UpdateRebar()
					For i As Integer = 0 To .ControlCount - 1
						.AddBand .Controls[i]
					Next
				End With
			End If
		End Sub
		
		Sub ReBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub ReBar.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				' SetBKMode Dc, TRANSPARENT
				' SetTextColor Dc,Font.Color
				' SetBKColor Dc,base.Color
				' SetBKMode Dc,OPAQUE
				SendMessage(Handle, RB_SETTEXTCOLOR, 0, Cast(LPARAM, This.Font.Color))
				SendMessage(Handle, RB_SETBKCOLOR, 0, Cast(LPARAM, FBackColor))
			Case CM_NOTIFY
				Dim ptnmRebar As NMREBAR Ptr            ' information about a notification message
				ptnmRebar = Cast(NMREBAR Ptr,  Message.lParam)
				If ptnmRebar->hdr.code = RBN_HEIGHTCHANGE Then
					If OnHeightChange Then OnHeightChange(This)
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator ReBar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor ReBar
		#ifndef __USE_GTK__
			Dim ticc As INITCOMMONCONTROLSEX     ' specifies common control classes to register
			ticc.dwSize = SizeOf(ticc)
			ticc.dwICC  = ICC_COOL_CLASSES Or ICC_BAR_CLASSES
			InitCommonControlsEx @ticc
		#endif
		With This
			WLet(FClassName, "ReBar")
			WLet(FClassAncestor, "ReBarWindow32")
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				layoutwidget = widget
				.RegisterClass "ReBar", @This
			#else
				.RegisterClass "ReBar", "ReBarWindow32"
				.Style        = WS_CHILD Or RBS_VARHEIGHT Or CCS_NODIVIDER Or RBS_BANDBORDERS
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
				.BackColor       = GetSysColor(COLOR_BTNFACE)
			#endif
			.Width        = 100
			.Height       = 25
			.Child        = @This
		End With
	End Constructor
	
	Destructor ReBar
		WDeallocate(m_BMP)
		#ifndef __USE_GTK__
			UnregisterClass "ReBar", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
