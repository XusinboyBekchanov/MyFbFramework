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
		#elseif defined(__USE_WASM__)
			PageDelete(@This)
		#elseif defined(__USE_JNI__)
			If Handle Then PageDelete(Handle): Handle = 0
		#elseif defined(__USE_APPLE__)
			If Handle Then mffPageFree(Handle): Handle = 0
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
		#ifdef __USE_APPLE__
			'The print panel of the system prints the pictures of the pages
			If Pages.Count = 0 Then Repaint
			If Pages.Count = 0 Then Return
			Dim As Any Ptr PageHandles(Pages.Count - 1)
			For i As Integer = 0 To Pages.Count - 1
				PageHandles(i) = Pages.Item(i)->Handle
			Next
			mffPagesPrint(@PageHandles(0), Pages.Count, ToUtf8(DocumentName))
			Return
		#elseif defined(__USE_WASM__)
			'Web: the print dialog of the browser prints the pages (it chooses the printer)
			If Pages.Count = 0 Then Repaint
			Dim As String Ids
			For i As Integer = 0 To Pages.Count - 1
				Ids &= Str(Cast(Integer, Pages.Item(i))) & " "
			Next
			PrintPages(Ids, ToUtf8(DocumentName))
			Return
		#elseif defined(__USE_JNI__)
			'Android: the print dialog of the system prints the pages (it chooses the printer and the paper)
			If Pages.Count = 0 Then Repaint
			If Pages.Count = 0 Then Return
			Dim As Any Ptr PageHandles(Pages.Count - 1)
			For i As Integer = 0 To Pages.Count - 1
				PageHandles(i) = Pages.Item(i)->Handle
			Next
			PrintPages(@PageHandles(0), Pages.Count, ToUtf8(DocumentName), PrinterSettings.PageWidth, PrinterSettings.PageLength, PrinterSettings.Orientation = PrinterOrientation.poLandscape)
			Return
		#endif
		#ifdef __USE_GTK__
			RunPrintOperation GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG, ""
		#elseif defined(__USE_WINAPI__)
			If PrinterSettings.Handle = 0 AndAlso PrinterSettings.Name = "" Then
				'No printer: the printer of the print dialog (ChoosePrinter makes its device context)
				If PrinterSettings.ChoosePrinter() = "" Then Return
			End If
			PrintTo ""
		#endif
	End Sub
	
	Private Function PrintDocument.ExportToPDF(ByRef FileName As WString, ByRef PrinterName As WString = "Microsoft Print to PDF") As Boolean
		If FileName = "" Then Return False
		#ifdef __USE_GTK__
			Return RunPrintOperation(GTK_PRINT_OPERATION_ACTION_EXPORT, FileName)
		#elseif defined(__USE_WINAPI__)
			'The PDF printer writes the file of DOCINFO.lpszOutput without its Save dialog
			Dim As String PreviousPrinter = PrinterSettings.Name
			PrinterSettings.Name = PrinterName
			Dim As Boolean bResult = PrintTo(FileName)
			PrinterSettings.Name = PreviousPrinter
			Return bResult
		#else
			Return False
		#endif
	End Function
	
	#ifdef __USE_GTK__
		'Prints (the print dialog) or exports to the PDF file ExportFileName (no dialog) the pages
		Private Function PrintDocument.RunPrintOperation(Action As GtkPrintOperationAction, ByRef ExportFileName As WString) As Boolean
			If Pages.Count = 0 Then Repaint
			If Pages.Count = 0 Then Return False
			
			Dim As GtkPrintOperation Ptr op = gtk_print_operation_new()
			If Len(DocumentName) Then gtk_print_operation_set_job_name(op, ToUtf8(DocumentName))
			gtk_print_operation_set_n_pages(op, Pages.Count)
			' Report margins are already part of the recorded page
			gtk_print_operation_set_use_full_page(op, 1)
			If Action = GTK_PRINT_OPERATION_ACTION_EXPORT Then gtk_print_operation_set_export_filename(op, ToUtf8(ExportFileName))
			
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
			Dim As GtkPrintOperationResult res = gtk_print_operation_run(op, Action, NULL, @gerr)
			If res = GTK_PRINT_OPERATION_RESULT_ERROR AndAlso gerr <> 0 Then
				' Print statement is shadowed by the PrintDocument.Print method here
				g_printerr(!"Print error: %s\n", gerr->message)
				g_error_free(gerr)
			End If
			g_object_unref(op)
			Return res = GTK_PRINT_OPERATION_RESULT_APPLY
		End Function
	#endif
	
	#ifdef __USE_WINAPI__
		'Prints the pages on PrinterSettings.Name (the device context of ChoosePrinter or a new one of the printer), to the
		'file OutputFileName when it is not empty
		Private Function PrintDocument.PrintTo(ByRef OutputFileName As WString) As Boolean
			If Pages.Count = 0 Then Repaint
			If Pages.Count = 0 Then Return False
			Dim As HDC hdcPrinter
			Dim As Boolean bOwnDC
			If OutputFileName = "" Then hdcPrinter = PrinterSettings.Handle
			If hdcPrinter = 0 Then
				Dim As WString * 260 wPrinterName = PrinterSettings.Name
				If wPrinterName = "" Then Return False
				hdcPrinter = CreateDC(NULL, @wPrinterName, NULL, NULL)
				If hdcPrinter = 0 Then Return False
				bOwnDC = True
			End If
			
			Dim As DOCINFO di
			di.cbSize      = SizeOf(DOCINFO)
			di.lpszDocName = DocumentName
			If OutputFileName <> "" Then di.lpszOutput = @OutputFileName
			
			Dim As Boolean bResult = StartDoc(hdcPrinter, @di) > 0
			If bResult Then
				For i As Integer = 0 To Pages.Count - 1
					StartPage(hdcPrinter)
					This.Paint(0, hdcPrinter, i)
					EndPage(hdcPrinter)
				Next
				bResult = EndDoc(hdcPrinter) > 0
			End If
			
			'The device context of ChoosePrinter stays for the next printing
			If bOwnDC Then DeleteDC(hdcPrinter)
			Return bResult
		End Function
	#endif
	
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
			#elseif defined(__USE_WASM__)
				'Web: an offscreen canvas of the page (mff_lib.js), the page is the Handle of its Canvas
				PageCreate(NewPage, PrinterSettings.PrintableWidth, PrinterSettings.PrintableHeight)
				NewPage->Canvas.Handle = NewPage
			#elseif defined(__USE_JNI__)
				'Android: the Canvas draws in pixels (the units of the form by the DPI of the main form, a canvas without a
				'control has none), the page is an MffPage of them
				NewPage->Canvas.xdpi = IIf(pApp AndAlso pApp->MainForm AndAlso pApp->MainForm->xdpi > 0, pApp->MainForm->xdpi, 1)
				NewPage->Canvas.ydpi = IIf(pApp AndAlso pApp->MainForm AndAlso pApp->MainForm->ydpi > 0, pApp->MainForm->ydpi, 1)
				NewPage->Handle = PageCreate(NewPage->Canvas.ScaleX(PrinterSettings.PrintableWidth), NewPage->Canvas.ScaleY(PrinterSettings.PrintableHeight))
				NewPage->Canvas.Handle = NewPage->Handle
			#elseif defined(__USE_APPLE__)
				NewPage->Handle = mffPageCreate(PrinterSettings.PrintableWidth, PrinterSettings.PrintableHeight)
				NewPage->Canvas.Handle = NewPage->Handle
				#ifdef __USE_UIKIT__
					mffPageBeginDraw(NewPage->Handle)
				#else
					mffCanvasBegin(NewPage->Handle)
				#endif
			#endif
			If OnPrintPage Then OnPrintPage(*Designer, This, NewPage->Canvas, HasMorePages)
			#ifdef __USE_UIKIT__
				mffPageEndDraw(NewPage->Handle)
			#elseif defined(__USE_COCOA__)
				mffCanvasEnd(NewPage->Handle)
			#endif
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
