#include once "PrintDocument.bi"

Namespace My.Sys.ComponentModel
	#ifndef ReadProperty_Off
		Private Function PrintDocument.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "documentname": Return DocumentName.vptr
			Case "printersettings": Return @PrinterSettings
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function PrintDocument.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "documentname": DocumentName = QWString(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Constructor PrintDocumentPage
		WLet(FClassName, "PrintDocumentPage")
	End Constructor
	
	Private Destructor PrintDocumentPage
		#ifdef __USE_WINAPI__
			If Handle Then
				DeleteEnhMetaFile(Handle)
			End If
		#elseif defined(__USE_GTK__)
			If Surface Then cairo_surface_destroy(Surface): Surface = 0
		#endif
	End Destructor
	
	Private Function PrintDocumentPages.Add(Index As Integer = -1) As PrintDocumentPage Ptr
		Dim As PrintDocumentPage Ptr NewPage = _New(PrintDocumentPage)
		If Index > -1 Then
			FItems.Insert Index, NewPage
		Else
			FItems.Add NewPage
		End If
		Return NewPage
	End Function
	
	Private Sub PrintDocumentPages.Clear
		For i As Integer = Count - 1 To 0 Step -1
			_Delete(Cast(PrintDocumentPage Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
	End Sub
	
	Private Property PrintDocumentPages.Count As Integer
		Return FItems.Count
	End Property
	
	Private Function PrintDocumentPages.Contains(PageItem As PrintDocumentPage Ptr) As Boolean
		Return IndexOf(PageItem) <> -1
	End Function
	
	Private Function PrintDocumentPages.IndexOf(PageItem As PrintDocumentPage Ptr) As Integer
		Return FItems.IndexOf(PageItem)
	End Function
	
	Private Function PrintDocumentPages.Insert(Index As Integer, PageItem As PrintDocumentPage Ptr) As PrintDocumentPage Ptr
		FItems.Insert(Index, PageItem)
		Return PageItem
	End Function
	
	Private Property PrintDocumentPages.Item(Index As Integer) As PrintDocumentPage Ptr
		Return Cast(PrintDocumentPage Ptr, FItems.Item(Index))
	End Property
	
	Private Property PrintDocumentPages.Item(Index As Integer, Value As PrintDocumentPage Ptr)
		FItems.Item(Index) = Value
	End Property
	
	Private Sub PrintDocumentPages.Remove(Index As Integer)
		_Delete(Item(Index))
		FItems.Remove Index
	End Sub
	
	Private Constructor PrintDocumentPages
		This.Clear
	End Constructor
	
	Private Destructor PrintDocumentPages
		This.Clear
	End Destructor
	
	#ifdef __USE_WINAPI__
		Private Sub PrintDocument.Paint(HWND As HWND, hdcDestination As HDC, ByVal PageNumber As Integer)
			If PageNumber < 0 OrElse PageNumber > Pages.Count Then
				Return
			End If
			
			Dim As ENHMETAHEADER emh
			Dim As Double MillimetersPerPixelsX, MillimetersPerPixelsY
			Dim As Rect rc
			
			MillimetersPerPixelsX = GetDeviceCaps(hdcDestination, HORZRES) / GetDeviceCaps(hdcDestination, HORZSIZE) / 100
			MillimetersPerPixelsY = GetDeviceCaps(hdcDestination, VERTRES) / GetDeviceCaps(hdcDestination, VERTSIZE) / 100
			
			GetEnhMetaFileHeader(Pages.Item(PageNumber)->Handle, SizeOf(emh), @emh)
			
			rc.Left   = emh.rclFrame.Left * MillimetersPerPixelsX
			rc.Right  = rc.Left + (emh.rclFrame.Right - emh.rclFrame.Left) * MillimetersPerPixelsX
			rc.Top    = emh.rclFrame.Top * MillimetersPerPixelsX
			rc.Bottom = rc.Top + (emh.rclFrame.Bottom - emh.rclFrame.Top) * MillimetersPerPixelsX
			
			PlayEnhMetaFile(hdcDestination, Pages.Item(PageNumber)->Handle, @rc )
			
		End Sub
	#endif
	
	#ifdef __USE_GTK__
		Private Sub PrintDocument.PrintOperation_DrawPage(op As GtkPrintOperation Ptr, context As GtkPrintContext Ptr, page_nr As gint, user_data As gpointer)
			Dim As PrintDocument Ptr Doc = Cast(Any Ptr, user_data)
			If Doc = 0 OrElse page_nr < 0 OrElse page_nr >= Doc->Pages.Count Then Exit Sub
			Dim As cairo_surface_t Ptr Surface = Doc->Pages.Item(page_nr)->Surface
			If Surface = 0 Then Exit Sub
			Dim As cairo_t Ptr cr = gtk_print_context_get_cairo_context(context)
			' Pages are recorded in screen pixels at 96 DPI (see Printer.PrintableWidth)
			cairo_scale(cr, gtk_print_context_get_dpi_x(context) / 96, gtk_print_context_get_dpi_y(context) / 96)
			cairo_set_source_surface(cr, Surface, 0, 0)
			cairo_paint(cr)
		End Sub
	#endif

	Private Sub PrintDocument.Print
		#ifdef __USE_GTK__
			If Pages.Count = 0 Then Repaint
			If Pages.Count = 0 Then Return

			Dim As GtkPrintOperation Ptr op = gtk_print_operation_new()
			If Len(DocumentName) Then gtk_print_operation_set_job_name(op, ToUtf8(DocumentName))
			gtk_print_operation_set_n_pages(op, Pages.Count)
			' Report margins are already part of the recorded page
			gtk_print_operation_set_use_full_page(op, 1)

			Dim As GtkPageSetup Ptr PageSetup = gtk_page_setup_new()
			' Paper selected in PrinterSettings.PageSize, sizes are in tenths of a millimeter
			Dim As GtkPaperSize Ptr Paper = gtk_paper_size_new_custom("custom", "Custom", PrinterSettings.PageWidth / 10, PrinterSettings.PageLength / 10, GTK_UNIT_MM)
			gtk_page_setup_set_paper_size(PageSetup, Paper)
			gtk_paper_size_free(Paper)
			If PrinterSettings.Orientation = PrinterOrientation.poLandscape Then
				gtk_page_setup_set_orientation(PageSetup, GTK_PAGE_ORIENTATION_LANDSCAPE)
			Else
				gtk_page_setup_set_orientation(PageSetup, GTK_PAGE_ORIENTATION_PORTRAIT)
			End If
			gtk_print_operation_set_default_page_setup(op, PageSetup)
			g_object_unref(PageSetup)

			g_signal_connect(op, "draw-page", G_CALLBACK(@PrintOperation_DrawPage), @This)

			Dim As GError Ptr gerr
			Dim As GtkPrintOperationResult res = gtk_print_operation_run(op, GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG, NULL, @gerr)
			If res = GTK_PRINT_OPERATION_RESULT_ERROR AndAlso gerr <> 0 Then
				' Print statement is shadowed by the PrintDocument.Print method here
				g_printerr(!"Print error: %s\n", gerr->message)
				g_error_free(gerr)
			End If
			g_object_unref(op)
			Return
		#endif
		If PrinterSettings.Name = "" Then
			If PrinterSettings.ChoosePrinter() = "" Then
				Return
			End If
		End If
		
		If PrinterSettings.Handle = 0 Then Return
		
		#ifdef __USE_WINAPI__
			Dim As DOCINFO di
			di.cbSize      = SizeOf(DOCINFO)
			di.lpszDocName = DocumentName
			
			StartDoc(PrinterSettings.Handle, @di)
			
			For i As Integer = 0 To Pages.Count - 1
				StartPage(PrinterSettings.Handle)
				This.Paint(0, PrinterSettings.Handle, i)
				EndPage(PrinterSettings.Handle)
			Next
			
			EndDoc(PrinterSettings.Handle)
			DeleteDC(PrinterSettings.Handle)
			'PrinterSettings.Handle = 0
		#endif
	End Sub
	
	Private Sub PrintDocument.Repaint
		Dim As Boolean HasMorePages
		Pages.Clear
		Do
			HasMorePages = False
			Dim As PrintDocumentPage Ptr NewPage = Pages.Add
			NewPage->Canvas.HandleSetted = True
			#if defined(__USE_WINAPI__) AndAlso Not defined(__USE_CAIRO__)
				NewPage->Canvas.Handle = CreateEnhMetaFile(NULL, NULL, NULL, NULL)
			#elseif defined(__USE_GTK__)
				NewPage->Surface = cairo_recording_surface_create(CAIRO_CONTENT_COLOR_ALPHA, NULL)
				NewPage->Canvas.Handle = cairo_create(NewPage->Surface)
				NewPage->Canvas.layout = pango_cairo_create_layout(NewPage->Canvas.Handle)
				pango_layout_set_font_description(NewPage->Canvas.layout, NewPage->Canvas.Font.Handle)
			#endif
			If OnPrintPage Then OnPrintPage(*Designer, This, NewPage->Canvas, HasMorePages)
			#if defined(__USE_WINAPI__) AndAlso Not defined(__USE_CAIRO__)
				NewPage->Handle = CloseEnhMetaFile(NewPage->Canvas.Handle)
			#elseif defined(__USE_GTK__)
				If NewPage->Canvas.layout Then g_object_unref(NewPage->Canvas.layout): NewPage->Canvas.layout = 0
				cairo_destroy(NewPage->Canvas.Handle)
			#endif
			NewPage->Canvas.Handle = 0
			NewPage->Canvas.HandleSetted = False
		Loop While HasMorePages
	End Sub
	
	Constructor PrintDocument
		WLet(FClassName, "PrintDocument")
		PrinterSettings.Name = PrinterSettings.DefaultPrinter
	End Constructor
	
	Destructor PrintDocument
		#ifdef __USE_WINAPI__
			For i As Integer = 0 To Pages.Count - 1
				If Pages.Item(i)->Handle Then
					DeleteEnhMetaFile(Pages.Item(i)->Handle)
				End If
			Next
		#endif
	End Destructor
End Namespace
