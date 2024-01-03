#include once "PrintDocument.bi"

Namespace My.Sys.ComponentModel
	Private Constructor PrintDocumentPage
		WLet(FClassName, "PrintDocumentPage")
	End Constructor
	
	Private Destructor PrintDocumentPage
		#ifdef __USE_WINAPI__
			If Handle Then
				DeleteEnhMetaFile(Handle)
			End If
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
			
			rc.Left   = emh.rclFrame.left * MillimetersPerPixelsX
			rc.Right  = rc.Left + (emh.rclFrame.right - emh.rclFrame.left) * MillimetersPerPixelsX
			rc.Top    = emh.rclFrame.top * MillimetersPerPixelsX
			rc.Bottom = rc.Top + (emh.rclFrame.bottom - emh.rclFrame.top) * MillimetersPerPixelsX
			
			PlayEnhMetaFile(hdcDestination, Pages.Item(PageNumber)->Handle, @rc )
			
		End Sub
	#endif
	
	Private Sub PrintDocument.Print
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
			#ifdef __USE_WINAPI__
				NewPage->Canvas.Handle = CreateEnhMetaFile(NULL, NULL, NULL, NULL)
			#endif
			If OnPrintPage Then OnPrintPage(This, NewPage->Canvas, HasMorePages)
			#ifdef __USE_WINAPI__
				NewPage->Handle = CloseEnhMetaFile(NewPage->Canvas.Handle)
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
