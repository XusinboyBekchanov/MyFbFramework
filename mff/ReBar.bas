'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ReBar.bi"

Namespace My.Sys.Forms
	Private Sub ReBarBand.ChangeStyle(iStyle As Integer, Value As Boolean)
		If Value Then
			If ((FStyle And iStyle) <> iStyle) Then FStyle = FStyle Or iStyle
		ElseIf ((FStyle And iStyle) = iStyle) Then
			FStyle = FStyle And Not iStyle
		End If
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.cbSize = SizeOf(REBARBANDINFO)
				rbBand.fMask = RBBIM_STYLE
				rbBand.fStyle = FStyle
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Sub
	
	Private Property ReBarBand.Break As Boolean
		Return FBreak
	End Property
	
	Private Property ReBarBand.Break(Value As Boolean)
		FBreak = Value
		#ifdef __USE_GTK__
			If Parent Then Parent->UpdateReBar
		#else
			ChangeStyle RBBS_BREAK, Value
		#endif
	End Property
	
	Private Property ReBarBand.ChildEdge As Boolean
		Return FChildEdge
	End Property
	
	Private Property ReBarBand.ChildEdge(Value As Boolean)
		FChildEdge = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_CHILDEDGE, Value
		#endif
	End Property
	
	Private Property ReBarBand.Caption ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Private Property ReBarBand.Caption(ByRef Value As WString)
		WLet(FCaption, Value)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.cbSize = SizeOf(REBARBANDINFO)
				rbBand.fMask = RBBIM_TEXT
				rbBand.lpText = FCaption
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.Child As Control Ptr
		Return FChild
	End Property
	
	Private Property ReBarBand.Child(Value As Control Ptr)
		FChild = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				Dim As ..RECT rct
				rbBand.fMask = RBBIM_CHILD Or RBBIM_CHILDSIZE Or RBBIM_SIZE Or RBBIM_IDEALSIZE
				rbBand.hwndChild = Value->Handle                                        ' (RBBIM_CHILD flag)
				GetWindowRect(Value->Handle, @rct)
				rbBand.cxMinChild = rct.Right - rct.Left                                ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = rct.Bottom - rct.Top                                ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cx = rct.Right - rct.Left                                        ' Length of the band (RBBIM_SIZE flag)
				rbBand.cxIdeal = rct.Right - rct.Left
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.FixedBitmap As Boolean
		Return FFixedBitmap
	End Property
	
	Private Property ReBarBand.FixedBitmap(Value As Boolean)
		FFixedBitmap = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_FIXEDBMP, Value
		#endif
	End Property
	
	Private Property ReBarBand.FixedSize As Boolean
		Return FFixedSize
	End Property
	
	Private Property ReBarBand.FixedSize(Value As Boolean)
		FFixedSize = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_FIXEDSIZE, Value
		#endif
	End Property
	
	Private Property ReBarBand.GripperStyle As GripperStyles
		Return FGripperStyle
	End Property
	
	Private Property ReBarBand.GripperStyle(Value As GripperStyles)
		FGripperStyle = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_GRIPPERALWAYS, False
			ChangeStyle RBBS_NOGRIPPER, False
			Select Case Value
			Case Auto
			Case GripperAlways: ChangeStyle RBBS_GRIPPERALWAYS, True
			Case NoGripper: ChangeStyle RBBS_NOGRIPPER, True
			End Select
		#endif
	End Property
	
	Private Property ReBarBand.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ReBarBand.ImageIndex(Value As Integer)
		FImageIndex = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				If FImageIndex > -1 AndAlso Parent->ImageList <> 0 AndAlso Parent->ImageList->Count > 0 Then
					Dim As REBARBANDINFO rbBand
					rbBand.cbSize = SizeOf(REBARBANDINFO)
					rbBand.fMask Or = RBBIM_IMAGE
					rbBand.iImage = FImageIndex
					SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(lParam, @rbBand))
				End If
			End If
		#endif
	End Property
	
	Private Property ReBarBand.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property ReBarBand.ImageKey(ByRef Value As WString)
		WLet(FImageKey, Value)
		If Parent AndAlso Parent->ImageList Then
			ImageIndex = Parent->ImageList->IndexOf(*FImageKey)
		End If
	End Property
	
	Private Property ReBarBand.MinWidth As Integer
		Return FMinWidth
	End Property
	
	Private Property ReBarBand.MinWidth(Value As Integer)
		FMinWidth = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_CHILDSIZE
				rbBand.cxMinChild = FMinWidth                                ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = FMinHeight                               ' Minimum height of band (RBBIM_CHILDSIZE flag)
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.MinHeight As Integer
		Return FMinHeight
	End Property
	
	Private Property ReBarBand.MinHeight(Value As Integer)
		FMinHeight = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_CHILDSIZE
				rbBand.cxMinChild = FMinWidth                                ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = FMinHeight                               ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cyChild = FHeight
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.Left As Integer
		#ifndef __USE_GTK__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FLeft = rc.Left
			End If
		#endif
		Return FLeft
	End Property
	
	Private Property ReBarBand.Left(Value As Integer)
		FLeft = Value
	End Property
	
	Private Property ReBarBand.Top As Integer
		#ifndef __USE_GTK__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FLeft = rc.Top
			End If
		#endif
		Return FTop
	End Property
	
	Private Property ReBarBand.Top(Value As Integer)
		FTop = Value
	End Property
	
	Private Property ReBarBand.Height As Integer
		#ifdef __USE_WINAPI__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FHeight = rc.Bottom - rc.Top
			End If
		#endif
		Return FHeight
	End Property
	
	Private Property ReBarBand.Height(Value As Integer)
		FHeight = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_CHILDSIZE
				rbBand.cxMinChild = FMinWidth                                ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = FMinHeight                               ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cyChild = FHeight
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.Width As Integer
		#ifdef __USE_WINAPI__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FWidth = rc.Right - rc.Left
			End If
		#endif
		Return FWidth
	End Property
	
	Private Property ReBarBand.Width(Value As Integer)
		FWidth = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_SIZE
				rbBand.cx = FWidth
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.IdealWidth As Integer
		Return FIdealWidth
	End Property
	
	Private Property ReBarBand.IdealWidth(Value As Integer)
		FIdealWidth = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_IDEALSIZE
				rbBand.cxIdeal = FIdealWidth
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.RequestedWidth As Integer
		Return FRequestedWidth
	End Property
	
	Private Property ReBarBand.RequestedWidth(Value As Integer)
		FRequestedWidth = Value
		#ifdef __USE_GTK__
			If Parent Then Parent->UpdateReBar
		#else
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				rbBand.fMask = RBBIM_SIZE
				rbBand.cx = FRequestedWidth
				SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(LPARAM, @rbBand))
			End If
		#endif
	End Property
	
	Private Property ReBarBand.TopAlign As Boolean
		Return FTopAlign
	End Property
	
	Private Property ReBarBand.TopAlign(Value As Boolean)
		FTopAlign = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_TOPALIGN, Value
		#endif
	End Property
	
	Private Property ReBarBand.TitleVisible As Boolean
		Return FTitleVisible
	End Property
	
	Private Property ReBarBand.TitleVisible(Value As Boolean)
		FTitleVisible = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_HIDETITLE, Not Value
		#endif
	End Property
	
	Private Property ReBarBand.UseChevron As Boolean
		Return FTitleVisible
	End Property
	
	Private Property ReBarBand.UseChevron(Value As Boolean)
		FTitleVisible = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_USECHEVRON, Value
		#endif
	End Property
	
	Private Property ReBarBand.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property ReBarBand.Visible(Value As Boolean)
		FVisible = Value
		#ifdef __USE_GTK__
			gtk_widget_set_visible(Child->Handle, Value)
			gtk_widget_set_no_show_all(Child->Handle, Not Value)
			If Parent Then Parent->UpdateReBar
		#else
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then SendMessage(Parent->Handle, RB_SHOWBAND, Index, Value)
		#endif
	End Property
	
	Private Property ReBarBand.Index As Integer
		If Parent Then Return Parent->Bands.IndexOf(@This)
		Return -1
	End Property
	
	Private Property ReBarBand.Index(Value As Integer)
		If Value >= 0 AndAlso Value <= Parent->Bands.Count - 1 Then
			Dim As Integer OldIndex = Index
			If OldIndex < 0 OrElse Value = OldIndex Then Exit Property
			Parent->Bands.Move(OldIndex, Value)
		End If
	End Property
	
	Private Sub ReBarBandCollection.Move(OldIndex As Integer, Value As Integer)
		Dim As Any Ptr Band = FItems.Item(OldIndex)
		FItems.Remove OldIndex
		FItems.Insert Value, Band
		#ifdef __USE_GTK__
			Parent->UpdateReBar
		#else
			SendMessage Parent->Handle, RB_MOVEBAND, OldIndex, Value
		#endif
	End Sub
	
	Private Sub ReBarBand.Maximize()
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, RB_MAXIMIZEBAND, Index, 1
			End If
		#endif
	End Sub
	
	Private Sub ReBarBand.Minimize()
		#ifndef __USE_GTK__
			SendMessage Parent->Handle, RB_MINIMIZEBAND, Index, 0
		#endif
	End Sub
	
	Private Sub ReBarBand.Update(Create As Boolean = False)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				Dim As ..RECT rct
				rbBand.cbSize = SizeOf(REBARBANDINFO)
				rbBand.fMask = RBBIM_STYLE Or RBBIM_CHILD Or RBBIM_CHILDSIZE Or RBBIM_SIZE Or RBBIM_IDEALSIZE
				If (FImageIndex > -1) AndAlso Parent->ImageList AndAlso (Parent->ImageList->Count > 0) Then
					rbBand.fMask Or= RBBIM_IMAGE
					rbBand.iImage = FImageIndex
				End If
				If WGet(FCaption) <> "" Then
					rbBand.fMask Or= RBBIM_TEXT
					rbBand.lpText = FCaption
				End If
				rbBand.fStyle = FStyle                                          ' (RBBIM_STYLE flag)
				If FChild Then
					rbBand.hwndChild = FChild->Handle                           ' (RBBIM_CHILD flag)
				End If
				If Create Then
					GetWindowRect(FChild->Handle, @rct)
					FMinWidth = rct.Right - rct.Left
					FMinHeight = rct.Bottom - rct.Top
					FWidth = rct.Right - rct.Left
					If *FChild Is ToolBar Then
						Dim As ..SIZE sz
						SendMessage FChild->Handle, TB_GETIDEALSIZE, False, Cast(LParam, @sz)
						FIdealWidth = sz.cx
						FMinWidth = sz.cx
						FWidth = sz.cx
					Else
						FIdealWidth = rct.Right - rct.Left
					End If
				End If
				rbBand.cxMinChild = FMinWidth                                   ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = FMinHeight                                  ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cx = FWidth                                              ' Length of the band (RBBIM_SIZE flag)
				rbBand.cxIdeal = FIdealWidth
				If Create Then
					SendMessage(Parent->Handle, RB_INSERTBAND, Index, Cast(lParam, @rbBand))
					Maximize
				Else
					SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(lParam, @rbBand))
				End If
			End If
		#endif
	End Sub
	
	Private Function ReBarBand.GetRect() As My.Sys.Drawing.RECT
		Dim rc As My.Sys.Drawing.RECT
		#ifdef __USE_GTK__
			rc.Left = FLeft
			rc.Top = FTop
			rc.Right = FWidth
			rc.Bottom = FHeight
		#else
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
		#endif
		Return rc
	End Function
	
	Private Constructor ReBarBand
		FVisible = True
	End Constructor
	
	Private Destructor ReBarBand
		WDeallocate FCaption
		WDeallocate FImageKey
	End Destructor
	
	Private Function ReBarBandCollection.Count As Integer
		Return FItems.Count
	End Function
	
	Private Property ReBarBandCollection.Item(Index As Integer) As ReBarBand Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Item(Index)
		Else
			Print "Not found item by index" & Index
			Return 0
		End If
	End Property
	
	Private Property ReBarBandCollection.Item(Index As Integer, Value As ReBarBand Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Item(Index) = Value
		Else
			Print "Not found item by index" & Index
		End If
	End Property
	
	Private Function ReBarBandCollection.Add(Value As Control Ptr, ByRef Caption As WString = "", ImageIndex As Integer = 0, Index As Integer = -1) As ReBarBand Ptr
		Dim As ReBarBand Ptr pBand = New_(ReBarBand)
		pBand->Caption = Caption
		pBand->Child = Value
		pBand->ImageIndex = ImageIndex
		pBand->ChildEdge = True
		pBand->GripperStyle = GripperStyles.GripperAlways
		pBand->UseChevron = True
		pBand->Parent = Parent
		#ifdef __USE_GTK__
			If *pBand->Child Is ToolBar Then
				gtk_toolbar_set_show_arrow(gtk_toolbar(pBand->Child->Handle), False)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Dim As REBARBANDINFO rbBand
				Dim As ..RECT rct
				
				rbBand.cbSize = SizeOf(REBARBANDINFO)
				rbBand.fMask = RBBIM_STYLE Or RBBIM_CHILD Or RBBIM_CHILDSIZE Or RBBIM_SIZE Or RBBIM_IDEALSIZE
				If (ImageIndex > -1) AndAlso Parent->ImageList AndAlso (Parent->ImageList->Count > 0) Then
					rbBand.fMask Or= RBBIM_IMAGE
					rbBand.iImage = ImageIndex
				End If
				If Caption <> "" Then
					rbBand.fMask Or= RBBIM_TEXT
					rbBand.lpText = @Caption
				End If
				rbBand.fStyle = RBBS_CHILDEDGE Or RBBS_GRIPPERALWAYS 'Or RBBS_USECHEVRON          ' (RBBIM_STYLE flag)
				
				rbBand.hwndChild = value->Handle                                       ' (RBBIM_CHILD flag)
				GetWindowRect(value->Handle, @rct)
				rbBand.cxMinChild = rct.Right - rct.Left                        ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = rct.Bottom - rct.Top                        ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cx = rct.Right - rct.Left                                ' Length of the band (RBBIM_SIZE flag)
				rbBand.cxIdeal = rct.Right - rct.Left
				pBand->MinWidth = rbBand.cxMinChild
				pBand->MinHeight = rbBand.cyMinChild
				pBand->Width = rbBand.cx
				SendMessage(Parent->Handle, RB_INSERTBAND, Index, Cast(lParam, @rbBand))
			End If
		#endif
		FItems.Add pBand
		Return pBand
	End Function
	
	Private Function ReBarBandCollection.Add(Value As Control Ptr, ByRef Caption As WString = "", ByRef ImageKey As WString, Index As Integer = -1) As ReBarBand Ptr
		Dim As ReBarBand Ptr pBand
		If Parent AndAlso Parent->ImageList Then
			pBand = Add(Value, Caption, Parent->ImageList->IndexOf(ImageKey), Index)
		Else
			pBand = Add(Value, Caption, -1, Index)
		End If
		If pBand Then pBand->ImageKey = ImageKey
		Return pBand
	End Function
	
	Private Sub ReBarBandCollection.Remove(Index As Integer)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, RB_DELETEBAND, Index, 0
		#endif
		Delete_(Cast(ReBarBand Ptr, FItems.Item(Index)))
		FItems.Remove Index
	End Sub
	
	Private Sub ReBarBandCollection.Clear
		For Index As Integer = 0 To FItems.Count - 1
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, RB_DELETEBAND, Index, 0
			#endif
			Delete_(Cast(ReBarBand Ptr, FItems.Item(Index)))
		Next Index
		FItems.Clear
	End Sub
	
	Private Function ReBarBandCollection.IndexOf(Value As ReBarBand Ptr) As Integer
		Return FItems.IndexOf(Value)
	End Function
	
	Private Function ReBarBandCollection.IndexOf(Value As Control Ptr) As Integer
		For Index As Integer = 0 To FItems.Count - 1
			If Cast(ReBarBand Ptr, FItems.Item(Index))->Child = Value Then Return Index
			Return FItems.IndexOf(Value)
		Next Index
		Return -1
	End Function
	
	Private Function ReBarBandCollection.Contains(Value As ReBarBand Ptr) As Boolean
		Return IndexOf(Value) <> -1
	End Function
	
	Private Function ReBarBandCollection.Contains(Value As Control Ptr) As Boolean
		Return IndexOf(Value) <> -1
	End Function
	
	Private Constructor ReBarBandCollection
		
	End Constructor
	
	Private Destructor ReBarBandCollection
		This.Clear
	End Destructor
	
	Private Function ReBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "autosize": Return @FAutoSize
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function ReBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "autosize": This.AutoSize = QBoolean(Value) 
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Private Property ReBar.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Private Property ReBar.AutoSize(Value As Boolean)
		FAutoSize = Value
		#ifndef __USE_GTK__
			ChangeStyle RBS_AUTOSIZE, Value
		#endif
	End Property
	
	Private Sub ReBar.UpdateRebar()
		#ifdef __USE_GTK__
			If Not bWithoutUpdate Then
				AllocatedWidth = 0
				gtk_widget_queue_draw(widget)
			End If
		#else
			If ImageList AndAlso ImageList->Count Then
				Dim As REBARINFO inf
				inf.cbSize = SizeOf(REBARINFO)
				inf.fMask = RBIM_IMAGELIST
				inf.himl = ImageList->Handle
				SendMessage(Handle, RB_SETBARINFO, 0, Cast(LPARAM, @inf))
			End If
		#endif
	End Sub
	
	Private Function ReBar.RowCount() As Integer
		#ifndef __USE_GTK__
			If FHandle Then FRowCount = SendMessage(FHandle, RB_GETROWCOUNT, 0, 0)
		#endif
		Return FRowCount
	End Function
	
	Private Sub ReBar.Add(Ctrl As Control Ptr)
		Base.Add(Ctrl)
		Bands.Add Ctrl
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub ReBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QReBar(Sender.Child)
					'If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso .FDefaultBackColor = .FBackColor Then
						'SetWindowTheme(.FHandle, "DarkModeNavbar", nullptr)
						.Brush.Handle = hbrBkgnd
						SendMessageW(.FHandle, WM_THEMECHANGED, 0, 0)
						SendMessage(.FHandle, RB_SETTEXTCOLOR, 0, Cast(LPARAM, darkTextColor))
						SendMessage(.FHandle, RB_SETBKCOLOR, 0, Cast(LPARAM, darkBkColor))
						Dim As COLORSCHEME csch
						csch.dwSize = SizeOf(COLORSCHEME)
						csch.clrBtnShadow = darkBkColor
						csch.clrBtnHighlight = darkHlBkColor
						SendMessage(.FHandle, RB_SETCOLORSCHEME, 0, Cast(LPARAM, @csch))
						.FDarkMode = True
					'End If
					.UpdateRebar()
					For i As Integer = 0 To .Bands.Count - 1
						.Bands.Item(i)->Child = .Bands.Item(i)->Child
						.Bands.Item(i)->Update True
					Next
				End With
			End If
		End Sub
		
		Private Sub ReBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub ReBar.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case GDK_BUTTON_PRESS
				bPressed = True
				If InRect Then
					OldX = e->button.x
					gdk_window_set_cursor(win, gdkCursorColResize)
				End If
			Case GDK_BUTTON_RELEASE
				bPressed = False
				If InRect Then
					gdk_window_set_cursor(win, gdkCursorDefault)
				End If
			Case GDK_MOTION_NOTIFY
				If bPressed Then
					If InRect Then
						Dim As Integer MovedToItem = -1, MovedToBand = -1
						For i As Integer = 0 To Bands.Count - 1
							If Not Bands.Item(i)->Visible Then Continue For
							With *Bands.Item(i)
								If e->button.x >= .Left AndAlso e->button.x <= .Left + 11 AndAlso e->button.y >= .Top AndAlso e->button.y <= .Top + .Height Then
									MovedToItem = i
									Exit For
								ElseIf e->button.x >= .Left AndAlso e->button.x <= .Left + .Width AndAlso e->button.y >= .Top AndAlso e->button.y <= .Top + .Height Then
									MovedToBand = i
								End If 
							End With
						Next
						If MovedToItem > -1 Then
							bWithoutUpdate = True
							If Bands.Item(MovedToItem)->Break Then
								Bands.Item(DraggedItem)->Break = True
								Bands.Item(MovedToItem)->Break = False
							End If
							bWithoutUpdate = False
							Bands.Item(DraggedItem)->Index = MovedToItem
							DraggedItem = MovedToItem
						Else
							If e->button.y > Bands.Item(DraggedItem)->Top + Bands.Item(DraggedItem)->Height Then
								If MovedToBand > -1 Then
									Bands.Item(DraggedItem)->Index = Min(Bands.Count - 1, MovedToBand + 1)
									DraggedItem = Min(Bands.Count - 1, MovedToBand + 1)
								Else
									bWithoutUpdate = True
									Bands.Item(DraggedItem)->Index = Bands.Count - 1
									DraggedItem = Bands.Count - 1
									bWithoutUpdate = False
									Bands.Item(DraggedItem)->Break = True
								End If
							ElseIf e->button.y < Bands.Item(DraggedItem)->Top Then
								If MovedToBand > -1 Then
									If Bands.Item(DraggedItem)->Break Then
										bWithoutUpdate = True
										Bands.Item(DraggedItem)->Break = False
										bWithoutUpdate = False
									End If
									Bands.Item(DraggedItem)->Index = Min(Bands.Count - 1, MovedToBand + 1)
									DraggedItem = Min(Bands.Count - 1, MovedToBand + 1)
								End If
							ElseIf Bands.Item(DraggedItem)->Left > 0 Then
								If e->button.x < OldX Then
									If Bands.Item(DraggedItem - 1)->Width - (OldX - e->button.x) >= Bands.Item(DraggedItem - 1)->MinWidth Then
										bWithoutUpdate = True
										Bands.Item(DraggedItem - 1)->RequestedWidth = Bands.Item(DraggedItem - 1)->Width - (OldX - e->button.x)
										bWithoutUpdate = False 
										Bands.Item(DraggedItem)->RequestedWidth = Bands.Item(DraggedItem)->Width + (OldX - e->button.x)
										OldX = e->button.x
									End If
								Else
									If Bands.Item(DraggedItem)->Width - (OldX - e->button.x) >= Bands.Item(DraggedItem)->MinWidth Then
										bWithoutUpdate = True
										Bands.Item(DraggedItem)->RequestedWidth = Bands.Item(DraggedItem)->Width - (OldX - e->button.x)
										bWithoutUpdate = False
									End If
									Bands.Item(DraggedItem - 1)->RequestedWidth = Bands.Item(DraggedItem - 1)->Width + (e->button.x - OldX)
									OldX = e->button.x
								End If
							End If
						End If
					End If
				Else
					InRect = False
					For i As Integer = 0 To Bands.Count - 1
						If Not Bands.Item(i)->Visible Then Continue For
						With *Bands.Item(i)
							If e->button.x >= .Left AndAlso e->button.x <= .Left + 11 AndAlso e->button.y >= .Top AndAlso e->button.y <= .Top + .Height Then
								DraggedItem = i
								InRect = True
								Exit For
							End If 
						End With
					Next
					If InRect Then
						gdk_window_set_cursor(win, gdkCursorWEResize)
					Else
						gdk_window_set_cursor(win, gdkCursorDefault)
					End If
				End If
				Message.Result = True
				Return
			End Select
		#else
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_COMMAND
				Message.Result = -1
			Case WM_SIZE
				If This.Parent Then This.Parent->RequestAlign , , , @This
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
				Select Case ptnmRebar->hdr.code
				Case RBN_HEIGHTCHANGE
					If OnHeightChange Then OnHeightChange(This)
				Case NM_CUSTOMDRAW
					If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
						If Not FDarkMode Then
							FDarkMode = True
							'SetWindowTheme(FHandle, "DarkModeNavbar", nullptr)
							Brush.Handle = hbrBkgnd
							SendMessage(FHandle, RB_SETTEXTCOLOR, 0, Cast(LPARAM, darkTextColor))
							SendMessage(FHandle, RB_SETBKCOLOR, 0, Cast(LPARAM, darkBkColor))
							Dim As COLORSCHEME csch
							csch.dwSize = SizeOf(COLORSCHEME)
							csch.clrBtnShadow = darkBkColor
							csch.clrBtnHighlight = darkHlBkColor
							SendMessage(FHandle, RB_SETCOLORSCHEME, 0, Cast(LPARAM, @csch))
							SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
							Repaint
						End If
						Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
						Select Case nmcd->dwDrawStage
						Case CDDS_PREPAINT
							Message.Result = CDRF_NOTIFYPOSTPAINT
							Return
						Case CDDS_POSTPAINT
							Dim As HPEN GripperPen = CreatePen(PS_SOLID, 1, darkBkColor)
							Dim As HPEN PrevPen = SelectObject(nmcd->hdc, GripperPen)
							Dim rc As My.Sys.Drawing.RECT
							For i As Integer = 0 To Bands.Count - 1
								SendMessage(FHandle, RB_GETRECT, i, Cast(LPARAM, @rc))
								MoveToEx nmcd->hdc, rc.Left + 2, rc.Top + 2, 0
								LineTo nmcd->hdc, rc.Left + 2, rc.Bottom - 3
								MoveToEx nmcd->hdc, rc.Left + 3, rc.Top + 2, 0
								LineTo nmcd->hdc, rc.Left + 3, rc.Bottom - 3
							Next i
							SelectObject(nmcd->hdc, PrevPen)
							DeleteObject GripperPen
							Message.Result = CDRF_DODEFAULT
							Return
						End Select
					Else
						If FDarkMode Then
							FDarkMode = False
							If FBackColor = -1 Then
								Brush.Handle = 0
							Else
								Brush.Color = FBackColor
							End If
							SendMessage(Handle, RB_SETTEXTCOLOR, 0, Cast(LPARAM, This.Font.Color))
							SendMessage(Handle, RB_SETBKCOLOR, 0, Cast(LPARAM, FBackColor))
							Dim As COLORSCHEME csch
							csch.dwSize = SizeOf(COLORSCHEME)
							csch.clrBtnShadow = FBackColor
							csch.clrBtnHighlight = FBackColor
							SendMessage(FHandle, RB_SETCOLORSCHEME, 0, Cast(LPARAM, @csch))
							SetWindowTheme(FHandle, NULL, NULL)
						End If
					End If
				End Select
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator ReBar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub ReBar.Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As ReBar Ptr rb = user_data
			If allocation->width <> rb->AllocatedWidth OrElse allocation->height <> rb->AllocatedHeight Then
				rb->AllocatedWidth = allocation->width
				rb->AllocatedHeight = allocation->height
				Dim ChildAllocation As GtkAllocation
				Dim ChildWidget As GtkWidget Ptr
				For i As Integer = 0 To rb->Bands.Count - 1
					ChildWidget = rb->Bands.Item(i)->Child->Handle
					gtk_widget_get_allocation(rb->Bands.Item(i)->Child->Handle, @ChildAllocation)
					If rb->Bands.Item(i)->MinWidth = 0 OrElse rb->Bands.Item(i)->MinHeight = 0 Then
						rb->bWithoutUpdate = True
						rb->Bands.Item(i)->MinWidth = ChildAllocation.width + 11
						rb->Bands.Item(i)->MinHeight = ChildAllocation.height + 2
						rb->Bands.Item(i)->IdealWidth = ChildAllocation.width + 11
						rb->Bands.Item(i)->RequestedWidth = ChildAllocation.width + 11
						rb->Bands.Item(i)->Width = ChildAllocation.width + 11
						rb->Bands.Item(i)->Height = ChildAllocation.height + 2
						If *rb->Bands.Item(i)->Child Is ToolBar Then
							gtk_toolbar_set_show_arrow(gtk_toolbar(rb->Bands.Item(i)->Child->Handle), True)
						End If
						rb->bWithoutUpdate = False
					End If
				Next
				Dim As Boolean bNextNewLine
				Dim As Integer FLeft, FTop, FWidth = allocation->width, FHeight, OldBandIndex, RowHeight, FMinWidths
				rb->FRowCount = 0
				For i As Integer = 0 To rb->Bands.Count - 1
					If Not rb->Bands.Item(i)->Visible Then Continue For
'					ChildWidget = rb->Bands.Item(i)->Child->Handle
'					gtk_widget_get_allocation(rb->Bands.Item(i)->Child->Handle, @ChildAllocation)
					If RowHeight < rb->Bands.Item(i)->MinHeight Then RowHeight = rb->Bands.Item(i)->MinHeight
					If FLeft = 0 Then
						rb->FRowCount += 1
						FHeight += RowHeight
					End If
					rb->Bands.Item(i)->Left = FLeft
					rb->Bands.Item(i)->Top = FTop
					'rb->Bands.Item(i)->Width = rb->Bands.Item(i)->MinWidth
					rb->Bands.Item(i)->Height = RowHeight
					bNextNewLine = False
					If i = rb->Bands.Count - 1 OrElse (i < rb->Bands.Count - 1 AndAlso (rb->Bands.Item(i + 1)->MinWidth + 11 > FWidth - rb->Bands.Item(i)->MinWidth OrElse rb->Bands.Item(i + 1)->Break)) Then
						'ChildAllocation.width = FWidth - 11
						'gtk_widget_set_size_request(ChildWidget, ChildAllocation.width, ChildAllocation.height)
						'rb->Bands.Item(i)->Width = FWidth
						bNextNewLine = True
					Else
						FLeft += rb->Bands.Item(i)->MinWidth
					End If
					FWidth -= rb->Bands.Item(i)->MinWidth
					If bNextNewLine Then
						FWidth = allocation->width
						FLeft = 0
						For j As Integer = OldBandIndex To i
							If Not rb->Bands.Item(j)->Visible Then Continue For
							FMinWidths = 0
							For k As Integer = j + 1 To i
								If Not rb->Bands.Item(k)->Visible Then Continue For
								FMinWidths += rb->Bands.Item(k)->MinWidth
							Next
							With *rb->Bands.Item(j)
								ChildWidget = .Child->Handle
								.Left = FLeft
								gtk_layout_move(gtk_layout(widget), ChildWidget, .Left + 11, .Top)
								rb->bWithoutUpdate = True
								If j = i Then
									.Width = FWidth
								Else
									.Width = Max(.MinWidth, Min(.RequestedWidth, FWidth - FMinWidths))
								End If
								.Height = RowHeight
								rb->bWithoutUpdate = False
								gtk_widget_set_size_request(ChildWidget, .Width - 11, .Height - 2)
							End With
							FLeft += rb->Bands.Item(j)->Width
							FWidth -= rb->Bands.Item(j)->Width
						Next
						FWidth = allocation->width
						FLeft = 0
						FTop += rb->Bands.Item(i)->Height
						OldBandIndex = i + 1
					End If
				Next
				FHeight = Max(1, FHeight)
				If allocation->height <> FHeight Then 
					gtk_widget_set_size_request(widget, allocation->width, FHeight)
					rb->AllocatedHeight = FHeight
					rb->Height = FHeight
					If FHeight <> 1 Then
						If rb->Parent Then rb->Parent->RequestAlign
					End If
				End If
				If rb->OnResize Then rb->OnResize(*rb, allocation->width, allocation->height)
			End If
		End Sub
		
		Private Function ReBar.Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As ReBar Ptr rb = Cast(Any Ptr, data1)
			Dim allocation As GtkAllocation
			gtk_widget_get_allocation(widget, @allocation)
			If allocation.width <> rb->AllocatedWidth OrElse allocation.height <> rb->AllocatedHeight Then
				Layout_SizeAllocate(widget, @allocation, data1)
			End If
			rb->Canvas.HandleSetted = True
			rb->Canvas.Handle = cr
			If rb->cr = 0 Then
				rb->cr = cr
				rb->pdisplay = gtk_widget_get_display(widget)
				rb->gdkCursorDefault = gdk_cursor_new_from_name(rb->pdisplay, "default")
				rb->gdkCursorWEResize = gdk_cursor_new_from_name(rb->pdisplay, crSizeWE)
				rb->gdkCursorColResize = gdk_cursor_new_from_name(rb->pdisplay, "col-resize")
				#ifdef __USE_GTK3__
					rb->win = gtk_layout_get_bin_window(gtk_layout(widget))
				#endif
			End If
			For i As Integer = 0 To rb->Bands.Count - 1
				With *rb->Bands.Item(i)
					cairo_set_line_width(cr, 1)
					If g_darkModeEnabled Then
						cairo_set_source_rgb(cr, 0 / 255.0, 0 / 255.0, 0 / 255.0)
					Else
						cairo_set_source_rgb(cr, 222 / 255.0, 222 / 255.0, 222 / 255.0)
					End If
					cairo_rectangle cr, .Left + 0.5, .Top - 1 + 0.5, .Width, .Height
					cairo_stroke(cr)
					For j As Integer = 0 To .Height - 6 Step 4
						If g_darkModeEnabled Then
							cairo_set_source_rgb(cr, 0 / 255.0, 0 / 255.0, 0 / 255.0)
						Else
							cairo_set_source_rgb(cr, 195 / 255.0, 195 / 255.0, 195 / 255.0)
						End If
						'cairo_move_to cr, .Left + 5 + 1 + 0.5, .Top + j + 3 + 0.5
						'cairo_line_to cr, .Left + 5 + 1 + 0.5, .Top + j + 3 + 1 + 0.5
						'cairo_line_to cr, .Left + 5 + 0.5, .Top + j + 3 + 1 + 0.5
						If g_darkModeEnabled Then
							cairo_set_source_rgb(cr, 0 / 255.0, 0 / 255.0, 0 / 255.0)
						Else
							cairo_rectangle cr, .Left + 5, .Top + j + 3, 2, 2
						End If
						cairo_fill(cr)
						If g_darkModeEnabled Then
							cairo_set_source_rgb(cr, 0 / 255.0, 0 / 255.0, 0 / 255.0)
						Else
							cairo_set_source_rgb(cr, 228 / 255.0, 228 / 255.0, 228 / 255.0)
						End If
						'cairo_move_to cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5
						'cairo_line_to cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5
						cairo_rectangle cr, .Left + 5, .Top + j + 3, 1, 1
						cairo_fill(cr)
					Next
				End With
			Next
			If rb->OnPaint Then rb->OnPaint(*rb, rb->Canvas)
			rb->Canvas.HandleSetted = False
			Return False
		End Function
		
		Private Function ReBar.Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As ReBar Ptr rb = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			rb->win = Event->window
			Layout_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Private Constructor ReBar
		#ifndef __USE_GTK__
			Dim ticc As INITCOMMONCONTROLSEX     ' specifies common control classes to register
			ticc.dwSize = SizeOf(ticc)
			ticc.dwICC  = ICC_COOL_CLASSES Or ICC_BAR_CLASSES
			InitCommonControlsEx @ticc
		#endif
		Bands.Parent = @This
		With This
			WLet(FClassName, "ReBar")
			WLet(FClassAncestor, "ReBarWindow32")
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				layoutwidget = widget
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@Layout_Draw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@Layout_ExposeEvent), @This)
					g_signal_connect(widget, "size-allocate", G_CALLBACK(@Layout_SizeAllocate), @This)
				#endif
				.RegisterClass "ReBar", @This
			#else
				.RegisterClass "ReBar", "ReBarWindow32"
				.Style        = WS_CHILD Or RBS_VARHEIGHT Or CCS_NODIVIDER Or RBS_BANDBORDERS
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
			#endif
			.Width        = 100
			.Height       = 25
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor ReBar
		#ifndef __USE_GTK__
			UnregisterClass "ReBar", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
