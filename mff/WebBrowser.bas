'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "WebBrowser.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Function WebBrowser.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Function WebBrowser.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
	
	Property WebBrowser.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property WebBrowser.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property WebBrowser.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property WebBrowser.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Sub WebBrowser.Navigate(ByVal URL As WString Ptr)
		#ifdef __USE_GTK__
			webkit_web_view_load_uri(Cast(Any Ptr, widget), ToUTF8(*URL))
		#else
			Dim vUrl As VARIANT : vUrl.vt = VT_BSTR : vUrl.bstrVal = SysAllocString(URL)
			g_IWebBrowser->Navigate2(Cast(IWebBrowser2 Ptr, pIWebBrowser), @vUrl, NULL, NULL, NULL, NULL)
			VariantClear(@vUrl)
		#endif
	End Sub
	
	Sub WebBrowser.GoForward()
		#ifdef __USE_GTK__
			If webkit_web_view_can_go_forward(widget) Then
				webkit_web_view_go_forward(widget)
			End If
		#else
			g_IWebBrowser->GoForward(Cast(IWebBrowser2 Ptr, pIWebBrowser))
		#endif
	End Sub
	
	Sub WebBrowser.GoBack()
		#ifdef __USE_GTK__
			If webkit_web_view_can_go_forward(widget) Then
				webkit_web_view_go_forward(widget)
			End If
		#else
			g_IWebBrowser->GoBack(Cast(IWebBrowser2 Ptr, pIWebBrowser))
		#endif
	End Sub
	
	Sub WebBrowser.Refresh()
		#ifdef __USE_GTK__
			webkit_web_view_reload_bypass_cache(widget)
		#else
			g_IWebBrowser->Refresh(Cast(IWebBrowser2 Ptr, pIWebBrowser))
		#endif
	End Sub
	
	Function WebBrowser.GetURL() As UString
		Dim As UString sRet
		Dim As WString Ptr buf = sRet.vptr
		#ifdef __USE_GTK__
			sRet = *webkit_web_view_get_uri(widget)
		#else
			g_IWebBrowser->get_LocationURL(Cast(IWebBrowser2 Ptr, pIWebBrowser), @buf)
		#endif
		Return *buf
	End Function
	
	Function WebBrowser.State() As Integer
		Dim iState As Integer
		#ifdef __USE_GTK__
			'#ifdef __USE_GTK3__
			'	Return webkit_web_view_is_loading(widget)
			'#else
				If webkit_web_view_get_load_status(widget) = 2 Then
					Return False
				Else
					Return True
				End If
			'#endif
		#else
			g_IWebBrowser->get_Busy(Cast(IWebBrowser2 Ptr, pIWebBrowser), Cast(VARIANT_BOOL Ptr, @iState))
		#endif
		Return iState
	End Function
	
	Sub WebBrowser.Stop()
		#ifdef __USE_GTK__
			webkit_web_view_stop_loading(widget)
		#else
			g_IWebBrowser->Stop(Cast(IWebBrowser2 Ptr, pIWebBrowser))
		#endif
	End Sub
	
	Function WebBrowser.GetBody(ByVal flag As Long) As UString
		#ifdef __USE_GTK__
			#ifndef __USE_GTK3__
				Dim As String Ptr bBuf = webkit_web_resource_get_data(webkit_web_view_get_main_resource(widget))
				If bBuf = 0 Then
					Return ""
				Else
					Return *bBuf 
				EndIf 
			#else
				Return ""
			#endif
		#else
			Dim text As WString Ptr
			Dim As UString sRet
			text = sRet.vptr
			Dim As IHTMLDocument2 Ptr htmldoc2
			Dim As IDispatch Ptr doc
			Dim As IHTMLElement Ptr BODY
			g_IWebBrowser->get_Document(Cast(IWebBrowser2 Ptr, pIWebBrowser), @doc)
			If (doc->lpVtbl->QueryInterface(doc, @IID_IHTMLDocument2, Cast(PVOID Ptr, @htmldoc2)) = S_OK) Then
				htmlDoc2->lpVtbl->get_body(htmlDoc2, @BODY)
				If flag=0 Then
					BODY->lpVtbl->get_innerHTML(BODY, @TEXT)
				Else
					BODY->lpVtbl->get_outerHTML(BODY, @TEXT)
				End If
				Function = *text
				BODY->lpVtbl->Release(BODY)
				doc->lpVtbl->Release(doc)
				htmlDoc2->lpVtbl->Release(htmlDoc2)
			End If
		#endif
	End Function
	
	Sub WebBrowser.SetBody(ByRef text As WString)
		#ifdef __USE_GTK__
			'#ifdef __USE_GTK3__
			'	webkit_web_view_load_html(Cast(Any Ptr, widget), ToUTF8(text))
			'#else
				webkit_web_view_load_html_string(Cast(Any Ptr, widget), ToUTF8(text))
			'#endif
		#else
			Dim As IHTMLDocument2 Ptr htmldoc2
			Dim As IDispatch Ptr doc
			Dim As IHTMLElement Ptr BODY
			g_IWebBrowser->get_Document(Cast(IWebBrowser2 Ptr, pIWebBrowser), @doc)
			If (doc->lpVtbl->QueryInterface(doc, @IID_IHTMLDocument2, Cast(PVOID Ptr, @htmldoc2)) = S_OK) Then
				htmlDoc2->lpVtbl->get_body(htmlDoc2, @BODY)
				BODY->lpVtbl->put_innerHTML(BODY, @text)
				BODY->lpVtbl->Release(BODY)
				doc->lpVtbl->Release(doc)
				htmlDoc2->lpVtbl->Release(htmlDoc2)
			End If
		#endif
	End Sub

	#ifndef __USE_GTK__
		Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender Then
				With QWebBrowser(Sender.Child)
					Dim i As Integer
					Dim AtlAxWinInit As Function As Boolean
					Dim AtlAxGetControl As Function(ByVal hWin As HWND, ByRef pp As Integer Ptr) As Integer
					Dim iIUnknown As Integer
					Dim pIUnknown As Integer Ptr = @iIUnknown
					Dim IUnknown1 As IUnknownVtbl Ptr
					AtlAxGetControl = Cast(Any Ptr, GetProcAddress(.hWebBrowser, "AtlAxGetControl"))
					AtlAxGetControl(.FHandle, pIUnknown)
					If pIUnknown <> 0 AndAlso *pIUnknown <> 0 Then
						IUnknown1 = Cast(IUnknownVtbl Ptr, *pIUnknown)
						i = IUnknown1->AddRef(Cast(IUnknown Ptr, pIUnknown))
						i = IUnknown1->QueryInterface(Cast(IUnknown Ptr, pIUnknown), @IID_IWebBrowser2, @.pIWebBrowser)
						.g_IWebBrowser = Cast(IWebBrowser2Vtbl Ptr, *.pIWebBrowser)
						i = .g_IWebBrowser->AddRef(Cast(IWebBrowser2 Ptr, .pIWebBrowser))
						i = IUnknown1->Release(Cast(IUnknown Ptr, pIUnknown))
					End If
				End With
			End If
		End Sub
		
		Sub WebBrowser.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub WebBrowser.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Operator WebBrowser.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor WebBrowser
		With This
			WLet(FClassName, "WebBrowser")
			FText = "about:blank"
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				widget = webkit_web_view_new()
				#ifndef __USE_GTK3__
					scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
					gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
					gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
				#endif
				webkit_web_view_load_uri(Cast(Any Ptr, widget), Cast(gchar Ptr, @"about:blank"))
			#else
				hWebBrowser = LoadLibrary("atl.dll")
				If hWebBrowser Then
					Dim AtlAxWinInit As Function As Boolean
					AtlAxWinInit = Cast(Any Ptr, GetProcAddress(hWebBrowser, "AtlAxWinInit"))
					AtlAxWinInit()
					.RegisterClass "WebBrowser", "AtlAxWin"
					WLet(.FClassAncestor, "AtlAxWin")
				End If
				.Style        = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL
				.ExStyle      = WS_EX_CLIENTEDGE
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor WebBrowser
		#ifndef __USE_GTK__
			'This.Stop()
			'DestroyWindow FHandle
			FHandle = 0
			'FreeLibrary(hWebBrowser)
			
			'UnregisterClass "WebBrowser", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
