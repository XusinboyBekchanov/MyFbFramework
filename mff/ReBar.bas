'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ReBar.bi"

Namespace My.Sys.Forms
	Sub ReBarBand.ChangeStyle(iStyle As Integer, Value As Boolean)
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
	
	Property ReBarBand.Break As Boolean
		Return FBreak
	End Property
	
	Property ReBarBand.Break(Value As Boolean)
		FBreak = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_BREAK, Value
		#endif
	End Property
	
	Property ReBarBand.ChildEdge As Boolean
		Return FChildEdge
	End Property
	
	Property ReBarBand.ChildEdge(Value As Boolean)
		FChildEdge = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_CHILDEDGE, Value
		#endif
	End Property
	
	Property ReBarBand.Caption ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Property ReBarBand.Caption(ByRef Value As WString)
		WLet FCaption, Value
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
	
	Property ReBarBand.Child As Control Ptr
		Return FChild
	End Property
	
	Property ReBarBand.Child(Value As Control Ptr)
		FChild = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				Dim As RECT rct
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
	
	Property ReBarBand.FixedBitmap As Boolean
		Return FFixedBitmap
	End Property
	
	Property ReBarBand.FixedBitmap(Value As Boolean)
		FFixedBitmap = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_FIXEDBMP, Value
		#endif
	End Property
	
	Property ReBarBand.FixedSize As Boolean
		Return FFixedSize
	End Property
	
	Property ReBarBand.FixedSize(Value As Boolean)
		FFixedSize = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_FIXEDSIZE, Value
		#endif
	End Property
	
	Property ReBarBand.GripperStyle As GripperStyles
		Return FGripperStyle
	End Property
	
	Property ReBarBand.GripperStyle(Value As GripperStyles)
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
	
	Property ReBarBand.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Property ReBarBand.ImageIndex(Value As Integer)
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
	
	Property ReBarBand.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Property ReBarBand.ImageKey(ByRef Value As WString)
		WLet FImageKey, Value
		If Parent AndAlso Parent->ImageList Then
			ImageIndex = Parent->ImageList->IndexOf(*FImageKey)
		End If
	End Property
	
	Property ReBarBand.MinWidth As Integer
		Return FMinWidth
	End Property
	
	Property ReBarBand.MinWidth(Value As Integer)
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
	
	Property ReBarBand.MinHeight As Integer
		Return FMinHeight
	End Property
	
	Property ReBarBand.MinHeight(Value As Integer)
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
	
	Property ReBarBand.Left As Integer
		#ifndef __USE_GTK__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FLeft = rc.Left
			End If
		#endif
		Return FLeft
	End Property
	
	Property ReBarBand.Left(Value As Integer)
		FLeft = Value
	End Property
	
	Property ReBarBand.Top As Integer
		#ifndef __USE_GTK__
			Dim rc As My.Sys.Drawing.RECT
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then 
				SendMessage(Parent->Handle, RB_GETRECT, Index, Cast(LPARAM, @rc))
				FLeft = rc.Top
			End If
		#endif
		Return FTop
	End Property
	
	Property ReBarBand.Top(Value As Integer)
		FTop = Value
	End Property
	
	Property ReBarBand.Height As Integer
		Return FHeight
	End Property
	
	Property ReBarBand.Height(Value As Integer)
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
	
	Property ReBarBand.Width As Integer
		Return FWidth
	End Property
	
	Property ReBarBand.Width(Value As Integer)
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
	
	Property ReBarBand.TopAlign As Boolean
		Return FTopAlign
	End Property
	
	Property ReBarBand.TopAlign(Value As Boolean)
		FTopAlign = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_TOPALIGN, Value
		#endif
	End Property
	
	Property ReBarBand.TitleVisible As Boolean
		Return FTitleVisible
	End Property
	
	Property ReBarBand.TitleVisible(Value As Boolean)
		FTitleVisible = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_HIDETITLE, Not Value
		#endif
	End Property
	
	Property ReBarBand.UseChevron As Boolean
		Return FTitleVisible
	End Property
	
	Property ReBarBand.UseChevron(Value As Boolean)
		FTitleVisible = Value
		#ifndef __USE_GTK__
			ChangeStyle RBBS_USECHEVRON, Value
		#endif
	End Property
	
	Property ReBarBand.Visible As Boolean
		Return FVisible
	End Property
	
	Property ReBarBand.Visible(Value As Boolean)
		FVisible = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then SendMessage(Parent->Handle, RB_SHOWBAND, Index, Value)
		#endif
	End Property
	
	Property ReBarBand.Index As Integer
		If Parent Then Return Parent->Bands.IndexOf(@This)
		Return -1
	End Property
	
	Property ReBarBand.Index(Value As Integer)
		If Value >= 0 AndAlso Value <= Parent->Bands.Count - 1 Then
			Dim As Integer OldIndex = Index
			If OldIndex < 0 OrElse Value = OldIndex Then Exit Property
			Dim As ReBarBand Ptr OldBand = Parent->Bands.Item(Value), MovedBand = Parent->Bands.Item(OldIndex)
			Parent->Bands.Item(OldIndex) = OldBand
			Parent->Bands.Item(Value) = MovedBand
			#ifdef __USE_GTK__
				gtk_widget_queue_draw(Parent->Handle)
			#else
				SendMessage Parent->Handle, RB_MOVEBAND, OldIndex, Value
			#endif
		End If
	End Property
	
	Sub ReBarBand.Update(Create As Boolean = False)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Index <> - 1 Then
				Dim As REBARBANDINFO rbBand
				Dim As RECT rct
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
				rbBand.fStyle = FStyle                                              ' (RBBIM_STYLE flag)
				If FChild Then
					rbBand.hwndChild = FChild->Handle                               ' (RBBIM_CHILD flag)
				End If
				If Create Then
					GetWindowRect(FChild->Handle, @rct)
					rbBand.cxMinChild = rct.Right - rct.Left                        ' Minimum width of band (RBBIM_CHILDSIZE flag)
					rbBand.cyMinChild = rct.Bottom - rct.Top                        ' Minimum height of band (RBBIM_CHILDSIZE flag)
					rbBand.cx = rct.Right - rct.Left                                ' Length of the band (RBBIM_SIZE flag)
					FMinWidth = rbBand.cxMinChild
					FMinHeight = rbBand.cyMinChild
					FWidth = rbBand.cx
					rbBand.cxIdeal = rct.Right - rct.Left
					SendMessage(Parent->Handle, RB_INSERTBAND, Index, Cast(lParam, @rbBand))
				Else
					rbBand.cxMinChild = FMinWidth                                   ' Minimum width of band (RBBIM_CHILDSIZE flag)
					rbBand.cyMinChild = FMinHeight                                  ' Minimum height of band (RBBIM_CHILDSIZE flag)
					rbBand.cx = FWidth                                              ' Length of the band (RBBIM_SIZE flag)
					rbBand.cxIdeal = FWidth
					SendMessage(Parent->Handle, RB_SETBANDINFO, Index, Cast(lParam, @rbBand))
				End If
			End If
		#endif
	End Sub
	
	Function ReBarBand.GetRect() As My.Sys.Drawing.RECT
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
	
	Constructor ReBarBand
		
	End Constructor
	
	Destructor ReBarBand
		WDeallocate FCaption
		WDeallocate FImageKey
	End Destructor
	
	Function ReBarBandCollection.Count As Integer
		Return FItems.Count
	End Function
	
	Property ReBarBandCollection.Item(Index As Integer) As ReBarBand Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Item(Index)
		Else
			Print "Not found item by index" & Index
			Return 0
		End If
	End Property
	
	Property ReBarBandCollection.Item(Index As Integer, Value As ReBarBand Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Item(Index) = Value
		Else
			Print "Not found item by index" & Index
		End If
	End Property
	
	Function ReBarBandCollection.Add(Value As Control Ptr, ByRef Caption As WString = "", ImageIndex As Integer = 0, Index As Integer = -1) As ReBarBand Ptr
		Dim As ReBarBand Ptr pBand = New_(ReBarBand)
		pBand->Caption = Caption
		pBand->Child = Value
		pBand->ImageIndex = ImageIndex
		pBand->ChildEdge = True
		pBand->GripperStyle = GripperStyles.GripperAlways
		pBand->UseChevron = True
		pBand->Parent = Parent
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim As REBARBANDINFO rbBand
				Dim As RECT rct
				
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
				rbBand.fStyle = RBBS_CHILDEDGE Or RBBS_GRIPPERALWAYS Or RBBS_USECHEVRON          ' (RBBIM_STYLE flag)
				
				rbBand.hwndChild = value->Handle                                       ' (RBBIM_CHILD flag)
				GetWindowRect(value->Handle, @rct)
				rbBand.cxMinChild = rct.Right - rct.Left                        ' Minimum width of band (RBBIM_CHILDSIZE flag)
				rbBand.cyMinChild = rct.Bottom - rct.Top                        ' Minimum height of band (RBBIM_CHILDSIZE flag)
				rbBand.cx = rct.Right - rct.Left                                ' Length of the band (RBBIM_SIZE flag)
				pBand->MinWidth = rbBand.cxMinChild
				pBand->MinHeight = rbBand.cyMinChild
				pBand->Width = rbBand.cx
				rbBand.cxIdeal = rct.Right - rct.Left
				SendMessage(Parent->Handle, RB_INSERTBAND, Index, Cast(lParam, @rbBand))
			End If
		#endif
		FItems.Add pBand
		Return pBand
	End Function
	
	Function ReBarBandCollection.Add(Value As Control Ptr, ByRef Caption As WString = "", ByRef ImageKey As WString, Index As Integer = -1) As ReBarBand Ptr
		Dim As ReBarBand Ptr pBand
		If Parent AndAlso Parent->ImageList Then
			pBand = Add(Value, Caption, Parent->ImageList->IndexOf(ImageKey), Index)
		Else
			pBand = Add(Value, Caption, -1, Index)
		End If
		If pBand Then pBand->ImageKey = ImageKey
		Return pBand
	End Function
	
	Sub ReBarBandCollection.Remove(Index As Integer)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, RB_DELETEBAND, Index, 0
		#endif
		Delete_(Cast(ReBarBand Ptr, FItems.Item(Index)))
		FItems.Remove Index
	End Sub
	
	Sub ReBarBandCollection.Clear
		For Index As Integer = 0 To FItems.Count - 1
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, RB_DELETEBAND, Index, 0
			#endif
			Delete_(Cast(ReBarBand Ptr, FItems.Item(Index)))
		Next Index
		FItems.Clear
	End Sub
	
	Function ReBarBandCollection.IndexOf(Value As ReBarBand Ptr) As Integer
		Return FItems.IndexOf(Value)
	End Function
	
	Function ReBarBandCollection.IndexOf(Value As Control Ptr) As Integer
		For Index As Integer = 0 To FItems.Count - 1
			If Cast(ReBarBand Ptr, FItems.Item(Index))->Child = Value Then Return Index
			Return FItems.IndexOf(Value)
		Next Index
		Return -1
	End Function
	
	Function ReBarBandCollection.Contains(Value As ReBarBand Ptr) As Boolean
		Return IndexOf(Value) <> -1
	End Function
	
	Function ReBarBandCollection.Contains(Value As Control Ptr) As Boolean
		Return IndexOf(Value) <> -1
	End Function
	
	Constructor ReBarBandCollection
		
	End Constructor
	
	Destructor ReBarBandCollection
		This.Clear
	End Destructor
	
	Function ReBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "autosize": Return @FAutoSize
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
			Case "autosize": This.AutoSize = QBoolean(Value) 
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property ReBar.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Property ReBar.AutoSize(Value As Boolean)
		FAutoSize = Value
		#ifndef __USE_GTK__
			ChangeStyle RBS_AUTOSIZE, Value
		#endif
	End Property
	
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
	
	Sub ReBar.Add(Ctrl As Control Ptr)
		Base.Add(Ctrl)
		Bands.Add Ctrl
	End Sub
	
	#ifndef __USE_GTK__
		Sub ReBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QReBar(Sender.Child)
					.UpdateRebar()
					For i As Integer = 0 To .Bands.Count - 1
						.Bands.Item(i)->Child = .Bands.Item(i)->Child
						.Bands.Item(i)->Update True
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
			Case WM_COMMAND
				Message.Result = -1
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
	
	#ifdef __USE_GTK__
		Sub ReBar.Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As ReBar Ptr rb = user_data
			If allocation->width <> rb->AllocatedWidth OrElse allocation->height <> rb->AllocatedHeight Then
				rb->AllocatedWidth = allocation->width
				rb->AllocatedHeight = allocation->height
				Dim As Integer FLeft, FTop, FWidth = allocation->width, FHeight, OldBandIndex
				Dim ChildAllocation As GtkAllocation
				Dim ChildWidget As GtkWidget Ptr
				For i As Integer = 0 To rb->Bands.Count - 1
					ChildWidget = rb->Bands.Item(i)->Child->Handle
					gtk_widget_get_allocation(rb->Bands.Item(i)->Child->Handle, @ChildAllocation)
					If rb->Bands.Item(i)->MinWidth = 0 OrElse rb->Bands.Item(i)->MinHeight = 0 Then
						rb->Bands.Item(i)->MinWidth = ChildAllocation.width + 11
						rb->Bands.Item(i)->MinHeight = ChildAllocation.height
					End If
				Next
				Dim As Boolean bNextNewLine
				For i As Integer = 0 To rb->Bands.Count - 1
					ChildWidget = rb->Bands.Item(i)->Child->Handle
					gtk_widget_get_allocation(rb->Bands.Item(i)->Child->Handle, @ChildAllocation)
					If FLeft = 0 Then
						FHeight += ChildAllocation.height + 2
					End If
					gtk_layout_move(gtk_layout(widget), ChildWidget, FLeft + 11, FTop)
					rb->Bands.Item(i)->Left = FLeft
					rb->Bands.Item(i)->Top = FTop
					rb->Bands.Item(i)->Width = ChildAllocation.width + 11
					rb->Bands.Item(i)->Height = FHeight
					bNextNewLine = False
					If i = rb->Bands.Count - 1 OrElse (i < rb->Bands.Count - 1 AndAlso rb->Bands.Item(i + 1)->MinWidth + 11 > FWidth - rb->Bands.Item(i)->MinWidth) Then
						ChildAllocation.width = FWidth - 11
						gtk_widget_set_size_request(ChildWidget, ChildAllocation.width, ChildAllocation.height)
						rb->Bands.Item(i)->Width = FWidth
						bNextNewLine = True
					Else
						
						FLeft += rb->Bands.Item(i)->Width
					End If
					FWidth -= rb->Bands.Item(i)->Width
					If bNextNewLine Then
						If FWidth > 0 Then
							'gtk_widget_set_size_request(rb->Bands.Item(OldBandIndex)->Child->Handle, ChildAllocation.width, ChildAllocation.height)
						End If
						FWidth = allocation->width
						FLeft = 0
						FTop += rb->Bands.Item(i)->Height
						OldBandIndex = i + 1
					End If
				Next
				If allocation->height <> FHeight Then gtk_widget_set_size_request(widget, allocation->width, FHeight)
				If rb->OnResize Then rb->OnResize(*rb, allocation->width, allocation->height)
			End If
		End Sub
		
		Function ReBar.Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As ReBar Ptr rb = Cast(Any Ptr, data1)
			Dim allocation As GtkAllocation
			gtk_widget_get_allocation(widget, @allocation)
			If allocation.width <> rb->AllocatedWidth OrElse allocation.height <> rb->AllocatedHeight Then
				Layout_SizeAllocate(widget, @allocation, data1)
			End If
			rb->Canvas.HandleSetted = True
			rb->Canvas.Handle = cr
			For i As Integer = 0 To rb->Bands.Count - 1
				With *rb->Bands.Item(i)
					cairo_set_source_rgb(cr, 240 / 255.0, 240 / 255.0, 240 / 255.0)
					cairo_rectangle cr, .Left + 0.5, .Top + 0.5, .Width, .Height
					cairo_stroke(cr)
					For j As Integer = 0 To .Height Step 4
						cairo_set_source_rgb(cr, 228 / 255.0, 228 / 255.0, 228 / 255.0)
						cairo_move_to cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5
						cairo_line_to cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5
						'cairo_rectangle cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5, 1 + 0.5, 1 + 0.5
						cairo_stroke(cr)
						cairo_set_source_rgb(cr, 195 / 255.0, 195 / 255.0, 195 / 255.0)
						cairo_move_to cr, .Left + 5 + 1 + 0.5, .Top + j + 3 + 0.5
						cairo_line_to cr, .Left + 5 + 1 + 0.5, .Top + j + 3 + 1 + 0.5
						cairo_line_to cr, .Left + 5 + 0.5, .Top + j + 3 + 1 + 0.5
						'cairo_rectangle cr, .Left + 5 + 0.5, .Top + j + 3 + 0.5, 0 + 0.5, 0 + 0.5
						cairo_stroke(cr)
					Next
				End With
			Next
			If rb->OnPaint Then rb->OnPaint(*rb, rb->Canvas)
			rb->Canvas.HandleSetted = False
			Return False
		End Function
		
		Function ReBar.Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As ReBar Ptr rb = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			Layout_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Constructor ReBar
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
			#endif
			.Width        = 100
			.Height       = 25
			.Child        = @This
		End With
	End Constructor
	
	Destructor ReBar
		#ifndef __USE_GTK__
			UnregisterClass "ReBar", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
