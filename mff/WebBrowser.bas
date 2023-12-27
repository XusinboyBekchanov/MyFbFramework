'################################################################################
'#  WebBrowser.bas                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2023)                                     #
'################################################################################

#include once "WebBrowser.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function WebBrowser.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function WebBrowser.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
	
	Private Property WebBrowser.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property WebBrowser.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property WebBrowser.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property WebBrowser.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub WebBrowser.Navigate(ByVal URL As WString Ptr)
		#ifdef __USE_GTK__
			webkit_web_view_load_uri(Cast(Any Ptr, widget), ToUtf8(*URL))
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->Navigate(webviewWindow, URL)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				Dim vUrl As VARIANT: vUrl.vt = VT_BSTR : vUrl.bstrVal = SysAllocString(URL)
				g_IWebBrowser->Navigate2(Cast(IWebBrowser2 Ptr, pIWebBrowser), @vUrl, NULL, NULL, NULL, NULL)
				VariantClear(@vUrl)
			#endif
		#endif
	End Sub
	
	Private Sub WebBrowser.GoForward()
		#ifdef __USE_GTK__
			If webkit_web_view_can_go_forward(widget) Then
				webkit_web_view_go_forward(widget)
			End If
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->GoForward(webviewWindow)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				g_IWebBrowser->GoForward(Cast(IWebBrowser2 Ptr, pIWebBrowser))
			#endif
		#endif
	End Sub
	
	Private Sub WebBrowser.GoBack()
		#ifdef __USE_GTK__
			If webkit_web_view_can_go_forward(widget) Then
				webkit_web_view_go_forward(widget)
			End If
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->GoBack(webviewWindow)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				g_IWebBrowser->GoBack(Cast(IWebBrowser2 Ptr, pIWebBrowser))
			#endif
		#endif
	End Sub
	
	Private Sub WebBrowser.Refresh()
		#ifdef __USE_GTK__
			webkit_web_view_reload_bypass_cache(widget)
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->Reload(webviewWindow)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				g_IWebBrowser->Refresh(Cast(IWebBrowser2 Ptr, pIWebBrowser))
			#endif
		#endif
	End Sub
	
	Private Function WebBrowser.GetURL() As UString
		Dim As UString sRet
		Dim As WString Ptr buf = sRet.vptr
		#ifdef __USE_GTK__
			sRet = *webkit_web_view_get_uri(widget)
			Return *buf
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					Dim tText As WString Ptr
					webviewWindow->lpVtbl->get_Source(webviewWindow, @tText)
					Function = *tText
					'_Deallocate(tText)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
					Function = ""
				End If
			#else
				g_IWebBrowser->get_LocationURL(Cast(IWebBrowser2 Ptr, pIWebBrowser), @buf)
				Return *buf
			#endif
		#endif
	End Function
	
	Private Function WebBrowser.State() As Integer
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
			#ifdef __USE_WEBVIEW2__
				'webviewWindow->lpVtbl->Reload(webviewWindow)
			#else
				g_IWebBrowser->get_Busy(Cast(IWebBrowser2 Ptr, pIWebBrowser), Cast(VARIANT_BOOL Ptr, @iState))
			#endif
		#endif
		Return iState
	End Function
	
	Private Sub WebBrowser.Stop()
		#ifdef __USE_GTK__
			webkit_web_view_stop_loading(widget)
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->Stop(webviewWindow)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				g_IWebBrowser->Stop(Cast(IWebBrowser2 Ptr, pIWebBrowser))
			#endif
		#endif
	End Sub
	
	Private Function WebBrowser.GetBody(ByVal flag As Long = 0) As UString
		#ifdef __USE_GTK__
			#ifndef __USE_GTK3__
				Dim As String Ptr bBuf = webkit_web_resource_get_data(webkit_web_view_get_main_resource(widget))
				If bBuf = 0 Then
					Return ""
				Else
					Return *bBuf
				End If
			#else
				Return ""
			#endif
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					Dim pJavaScript As WString Ptr
					Select Case flag
					Case 0
						WLet(pJavaScript, "document.body.innerHTML")
					Case 1
						WLet(pJavaScript, "document.body.outerHTML")
					Case 2
						WLet(pJavaScript, "document.body.innerText")
					Case 3
						WLet(pJavaScript, "document.body.outerText")
					End Select
					WDeAllocate(ScriptResult)
					ScriptResult = 0
					webviewWindow->lpVtbl->ExecuteScript(webviewWindow, pJavaScript, ExecuteScriptCompletedHandler)
					Do While ScriptResult = 0
						App.DoEvents
					Loop
					_Deallocate(pJavaScript)
					Return *ScriptResult
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				Dim tText As WString Ptr
				Dim As IHTMLDocument2 Ptr htmldoc2
				Dim As IDispatch Ptr doc
				g_IWebBrowser->get_Document(Cast(IWebBrowser2 Ptr, pIWebBrowser), @doc)
				Function = ""
				If doc > 0 AndAlso (doc->lpVtbl->QueryInterface(doc, @IID_IHTMLDocument2, Cast(PVOID Ptr, @htmldoc2)) = S_OK) Then
					If htmldoc2 Then
						Dim As IHTMLElement Ptr BODY
						htmldoc2->lpVtbl->get_body(htmldoc2, @BODY)
						If BODY > 0 Then
							Select Case flag
							Case 0
								BODY->lpVtbl->get_innerHTML(BODY, @tText)
							Case 1
								BODY->lpVtbl->get_outerHTML(BODY, @tText)
							Case 2
								BODY->lpVtbl->get_innerText(BODY, @tText)
							Case 3
								BODY->lpVtbl->get_outerText(BODY, @tText)
							End Select
							Function = *tText
							BODY->lpVtbl->Release(BODY)
						End If
						htmldoc2->lpVtbl->Release(htmldoc2)
					End If
					doc->lpVtbl->Release(doc)
				End If
				_Deallocate(tText)
			#endif
		#endif
	End Function
	
	Private Sub WebBrowser.SetBody(ByRef tText As WString, ByVal flag As Long = 0)
		#ifdef __USE_GTK__
			'#ifdef __USE_GTK3__
			'	webkit_web_view_load_html(Cast(Any Ptr, widget), ToUTF8(tText))
			'#else
			webkit_web_view_load_html_string(Cast(Any Ptr, widget), ToUtf8(tText))
			'#endif
		#else
			#ifdef __USE_WEBVIEW2__
				If webviewWindow Then
					webviewWindow->lpVtbl->NavigateToString(webviewWindow, @tText)
				Else
					Print "WebView2 window has not been created. Install the WebView2 runtime."
				End If
			#else
				Dim As IHTMLDocument2 Ptr htmldoc2
				Dim As IDispatch Ptr doc
				g_IWebBrowser->get_Document(Cast(IWebBrowser2 Ptr, pIWebBrowser), @doc)
				If doc > 0 AndAlso (doc->lpVtbl->QueryInterface(doc, @IID_IHTMLDocument2, Cast(PVOID Ptr, @htmldoc2)) = S_OK) Then
					If htmldoc2 Then
						Dim As IHTMLElement Ptr BODY
						htmldoc2->lpVtbl->get_body(htmldoc2, @BODY)
						If BODY > 0 Then
							Select Case flag
							Case 0
								BODY->lpVtbl->put_innerHTML(BODY, @tText)
							Case 1
								BODY->lpVtbl->put_outerHTML(BODY, @tText)
							Case 2
								BODY->lpVtbl->put_innerText(BODY, @tText)
							Case 3
								BODY->lpVtbl->put_outerText(BODY, @tText)
							End Select
							BODY->lpVtbl->Release(BODY)
						End If
						htmldoc2->lpVtbl->Release(htmldoc2)
					End If
					doc->lpVtbl->Release(doc)
				End If
			#endif
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		#ifdef __USE_WEBVIEW2__
			Function WebBrowser.EnvironmentHandlerAddRef stdcall (This_ As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->HandlerRefCount += 1
					Return WebB->HandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.EnvironmentHandlerRelease stdcall (This_ As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->HandlerRefCount -= 1
					If (WebB->HandlerRefCount = 0) Then
						If (WebB->completedHandler) Then
							free(WebB->completedHandler->lpVtbl)
							free(WebB->completedHandler)
						End If
						If (WebB->envHandler) Then
							free(WebB->envHandler->lpVtbl)
							free(WebB->envHandler)
						End If
					End If
					Return WebB->HandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.EnvironmentHandlerQueryInterface stdcall (This_ As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					*ppvObject = This_
					EnvironmentHandlerAddRef(This_)
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.EnvironmentHandlerInvoke stdcall (This_ As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, errorCode As HRESULT, arg As ICoreWebView2Environment Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					If (Not WebB->bEnvCreated) Then
						WebB->bEnvCreated = True
						Dim As CHAR ch
						WebB->completedHandler = malloc(SizeOf(ICoreWebView2CreateCoreWebView2ControllerCompletedHandler))
						If (WebB->completedHandler = 0) Then
							'printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2ControllerCompletedHandler",
							'    GetLastError()
							');
							'ch = _getch();
							Return GetLastError()
						End If
						Handles.Add WebB->completedHandler, WebB
						WebB->completedHandler->lpVtbl = malloc(SizeOf(ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVtbl))
						If (WebB->completedHandler->lpVtbl = 0) Then
							'error_printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVtbl",
							'    GetLastError()
							');
							'ch = _getch();
							Return GetLastError()
						End If
						WebB->completedHandler->lpVtbl->AddRef = @ControllerHandlerAddRef 
						WebB->completedHandler->lpVtbl->Release = @ControllerHandlerRelease
						WebB->completedHandler->lpVtbl->QueryInterface = @ControllerHandlerQueryInterface
						WebB->completedHandler->lpVtbl->Invoke = @ControllerHandlerInvoke
						
						Dim As ICoreWebView2Environment Ptr env = arg
						env->lpVtbl->CreateCoreWebView2Controller(env, WebB->FHandle, WebB->completedHandler)
					End If
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.ControllerHandlerAddRef stdcall (This_ As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->HandlerRefCount += 1
					Return WebB->HandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.ControllerHandlerRelease stdcall (This_ As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->HandlerRefCount -= 1
					If (WebB->HandlerRefCount = 0) Then
						If (WebB->completedHandler) Then
							free(WebB->completedHandler->lpVtbl)
							free(WebB->completedHandler)
						End If
						If (WebB->envHandler) Then
							free(WebB->envHandler->lpVtbl)
							free(WebB->envHandler)
						End If
					End If
					Return WebB->HandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.ControllerHandlerQueryInterface stdcall (This_ As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					*ppvObject = This_
					ControllerHandlerAddRef(This_)
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.ControllerHandlerInvoke stdcall (This_ As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, result As HRESULT, createdController As ICoreWebView2Controller Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					If WebB->bEnvCreated Then
						Dim As ICoreWebView2Controller Ptr controller = createdController
						
						If (controller <> NULL) Then
							WebB->webviewController = controller
							WebB->webviewController->lpVtbl->AddRef(WebB->webviewController)
							WebB->webviewController->lpVtbl->get_CoreWebView2(WebB->webviewController, @WebB->webviewWindow)
						End If
						
						Dim As ICoreWebView2Settings Ptr Settings
						WebB->webviewWindow->lpVtbl->get_Settings(WebB->webviewWindow, @Settings)
						Settings->lpVtbl->put_IsScriptEnabled(Settings, True)
						Settings->lpVtbl->put_AreDefaultScriptDialogsEnabled(Settings, True)
						Settings->lpVtbl->put_IsWebMessageEnabled(Settings, True)
						Settings->lpVtbl->put_AreDevToolsEnabled(Settings, False)
						Settings->lpVtbl->put_AreDefaultContextMenusEnabled(Settings, True)
						Settings->lpVtbl->put_IsStatusBarEnabled(Settings, True)
						
						Dim As Rect bounds
						GetClientRect(WebB->FHandle, @bounds)
						#ifdef __FB_64BIT__
							WebB->webviewController->lpVtbl->put_Bounds(WebB->webviewController, bounds)
						#else
							Dim Chrome_WidgetWin_0 As HWND = FindWindowEx(WebB->FHandle, 0, "Chrome_WidgetWin_0", 0)
							Dim Chrome_WidgetWin_1 As HWND = FindWindowEx(Chrome_WidgetWin_0, 0, "Chrome_WidgetWin_1", 0)
							Dim Chrome_RenderWidgetHostHWND As HWND = FindWindowEx(Chrome_WidgetWin_1, 0, "Chrome_RenderWidgetHostHWND", 0)
							Dim IntermediateD3DWindow As HWND = FindWindowEx(Chrome_RenderWidgetHostHWND, 0, "Intermediate D3D Window", 0)
							MoveWindow Chrome_WidgetWin_0, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow Chrome_WidgetWin_1, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow Chrome_RenderWidgetHostHWND, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow IntermediateD3DWindow, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
						#endif
						
						'WebB->webviewWindow->lpVtbl->Navigate(WebB->webviewWindow, "https://google.com/")
					End If
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.ExecuteScriptCompletedHandlerAddRef stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->ExecuteScriptCompletedHandlerRefCount += 1
					Return WebB->ExecuteScriptCompletedHandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.ExecuteScriptCompletedHandlerRelease stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->ExecuteScriptCompletedHandlerRefCount -= 1
					If (WebB->ExecuteScriptCompletedHandlerRefCount = 0) Then
						If (WebB->ExecuteScriptCompletedHandler) Then
						'	free(WebB->ExecuteScriptCompletedHandler->lpVtbl)
						'	free(WebB->ExecuteScriptCompletedHandler)
						End If
					End If
					Return WebB->ExecuteScriptCompletedHandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.ExecuteScriptCompletedHandlerQueryInterface stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					*ppvObject = This_
					ExecuteScriptCompletedHandlerAddRef(This_)
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.ExecuteScriptCompletedHandlerInvoke stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr, errorCode As HRESULT, resultObjectAsJson As LPCWSTR) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					'If (Not WebB->bExecuteScriptCompletedHandlerCreated) Then
					If WebB->ScriptResult = 0 Then
						WebB->bExecuteScriptCompletedHandlerCreated = True
						WLet(WebB->ScriptResult, *Cast(WString Ptr, resultObjectAsJson))
					End If
				End If
				Return S_OK
			End Function
		#endif
		
		Private Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender Then
				With QWebBrowser(Sender.Child)
					#ifdef __USE_WEBVIEW2__
						CoInitializeEx(0, COINIT_APARTMENTTHREADED)
						Dim As HRESULT hr
						
						'If SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2) = 0 Then
						'    'error_printf(
						'    '    "%s:%d: %s (0x%x).\n",
						'    '    __FILE__,
						'    '    __LINE__,
						'    '    "SetProcessDpiAwarenessContext",
						'    '    GetLastError()
						'    ');
						'    'ch = _getch();
						'    Return GetLastError()
						'End If
						
						hr = CoInitialize(NULL)
						If FAILED(hr) Then
							'error_printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "CoInitialize",
							'    hr
							');
							'ch = _getch();
							Print hr
							Return 'hr
						End If
						
						.envHandler = malloc(SizeOf(ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler))
						If .envHandler = 0 Then
							'error_printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler",
							'    GetLastError()
							');
							'ch = _getch();
							Print GetLastError()
							Return 'GetLastError()
						End If
						Handles.Add .envHandler, @Sender
						.envHandler->lpVtbl = malloc(SizeOf(ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVtbl))
						If .envHandler->lpVtbl = 0 Then
							'error_printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVtbl",
							'    GetLastError()
							');
							'ch = _getch();
							Print GetLastError()
							Return 'GetLastError()
						End If
						.envHandler->lpVtbl->AddRef = @EnvironmentHandlerAddRef
						.envHandler->lpVtbl->Release = @EnvironmentHandlerRelease
						.envHandler->lpVtbl->QueryInterface = @EnvironmentHandlerQueryInterface
						.envHandler->lpVtbl->Invoke = @EnvironmentHandlerInvoke
						
						.ExecuteScriptCompletedHandler = malloc(SizeOf(ICoreWebView2ExecuteScriptCompletedHandler))
						If (.ExecuteScriptCompletedHandler = 0) Then
							'printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2ControllerCompletedHandler",
							'    GetLastError()
							');
							'ch = _getch();
							Print GetLastError()
							Return 'GetLastError()
						End If
						Handles.Add .ExecuteScriptCompletedHandler, @Sender
						.ExecuteScriptCompletedHandler->lpVtbl = malloc(SizeOf(ICoreWebView2ExecuteScriptCompletedHandlerVtbl))
						If (.ExecuteScriptCompletedHandler->lpVtbl = 0) Then
							'error_printf(
							'    "%s:%d: %s (0x%x).\n",
							'    __FILE__,
							'    __LINE__,
							'    "Cannot allocate ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVtbl",
							'    GetLastError()
							');
							'ch = _getch();
							Print GetLastError()
							Return 'GetLastError()
						End If
						.ExecuteScriptCompletedHandler->lpVtbl->AddRef = @ExecuteScriptCompletedHandlerAddRef
						.ExecuteScriptCompletedHandler->lpVtbl->Release = @ExecuteScriptCompletedHandlerRelease
						.ExecuteScriptCompletedHandler->lpVtbl->QueryInterface = @ExecuteScriptCompletedHandlerQueryInterface
						.ExecuteScriptCompletedHandler->lpVtbl->Invoke = @ExecuteScriptCompletedHandlerInvoke
					
						UpdateWindow(.FHandle)
						
						CreateCoreWebView2Environment(.envHandler)
					#else
						Dim i As Integer
						Dim AtlAxWinInit As Function As Boolean
						Dim AtlAxGetControl As Function(ByVal hWin As HWND, ByRef pp As Integer Ptr) As Integer
						Dim iIUnknown As Integer
						Dim pIUnknown As Integer Ptr = @iIUnknown
						Dim IUnknown1 As IUnknownVtbl Ptr
						If .hWebBrowser <> 0 Then
							AtlAxGetControl = Cast(Any Ptr, GetProcAddress(.hWebBrowser, "AtlAxGetControl"))
							If AtlAxGetControl <> 0 Then
								AtlAxGetControl(.FHandle, pIUnknown)
								If pIUnknown <> 0 AndAlso *pIUnknown <> 0 Then
									IUnknown1 = Cast(IUnknownVtbl Ptr, *pIUnknown)
									i = IUnknown1->AddRef(Cast(IUnknown Ptr, pIUnknown))
									i = IUnknown1->QueryInterface(Cast(IUnknown Ptr, pIUnknown), @IID_IWebBrowser2, @.pIWebBrowser)
									.g_IWebBrowser = Cast(IWebBrowser2Vtbl Ptr, *(.pIWebBrowser))
									i = .g_IWebBrowser->AddRef(Cast(IWebBrowser2 Ptr, .pIWebBrowser))
									i = IUnknown1->Release(Cast(IUnknown Ptr, pIUnknown))
								End If
							End If
						End If
					#endif
				End With
			End If
		End Sub
		
		Private Sub WebBrowser.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub WebBrowser.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			#ifdef __USE_WEBVIEW2__
				Select Case Message.Msg
				Case WM_SIZE:
					If (webviewController <> NULL) Then
						Dim As Rect bounds
						GetClientRect(FHandle, @bounds)
						#ifdef __FB_64BIT__
							webviewController->lpVtbl->put_Bounds(webviewController, bounds)
						#else
							Dim Chrome_WidgetWin_0 As HWND = FindWindowEx(FHandle, 0, "Chrome_WidgetWin_0", 0)
							Dim Chrome_WidgetWin_1 As HWND = FindWindowEx(Chrome_WidgetWin_0, 0, "Chrome_WidgetWin_1", 0)
							Dim Chrome_RenderWidgetHostHWND As HWND = FindWindowEx(Chrome_WidgetWin_1, 0, "Chrome_RenderWidgetHostHWND", 0)
							Dim IntermediateD3DWindow As HWND = FindWindowEx(Chrome_RenderWidgetHostHWND, 0, "Intermediate D3D Window", 0)
							MoveWindow Chrome_WidgetWin_0, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow Chrome_WidgetWin_1, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow Chrome_RenderWidgetHostHWND, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
							MoveWindow IntermediateD3DWindow, bounds.Left, bounds.Top, bounds.Right, bounds.Bottom, True
						#endif
					End If
				End Select
			#endif
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator WebBrowser.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Private Constructor WebBrowser
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
				#ifdef __USE_WEBVIEW2__
					.RegisterClass "WebBrowser"
					.Style        = WS_CHILD
				#else
					hWebBrowser = LoadLibrary("atl.dll")
					If hWebBrowser Then
						Dim AtlAxWinInit As Function As Boolean
						AtlAxWinInit = Cast(Any Ptr, GetProcAddress(hWebBrowser, "AtlAxWinInit"))
						If AtlAxWinInit Then
							AtlAxWinInit()
							.RegisterClass "WebBrowser", "AtlAxWin"
						End If
						WLet(.FClassAncestor, "AtlAxWin")
					End If
					.Style        = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL
				#endif
				.ExStyle      = WS_EX_CLIENTEDGE
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor WebBrowser
		#ifndef __USE_GTK__
			'This.Stop()
			'DestroyWindow FHandle
			FHandle = 0
			'FreeLibrary(hWebBrowser)
			
			'UnregisterClass "WebBrowser", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
