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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			WLet(FText, *URL)
			If FHandle Then LoadURL(FHandle, ToUtf8(*URL))
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FHandle Then WebAction(FHandle, 1)
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FHandle Then WebAction(FHandle, 0)
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FHandle Then WebAction(FHandle, 2)
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FText Then sRet = *FText
			Return *buf
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FHandle Then WebAction(FHandle, 3)
		#elseif defined(__USE_WINAPI__)
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
			#ifdef __USE_GTK2__
				Dim As String Ptr bBuf = webkit_web_resource_get_data(webkit_web_view_get_main_resource(widget))
				If bBuf = 0 Then
					Return ""
				Else
					Return *bBuf
				End If
			#else
				Return ""
			#endif
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Return FBody
		#elseif defined(__USE_WINAPI__)
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
					bInternalScript = True
					webviewWindow->lpVtbl->ExecuteScript(webviewWindow, pJavaScript, ExecuteScriptCompletedHandler)
					Do While ScriptResult = 0
						App.DoEvents
					Loop
					bInternalScript = False
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
	
	Private Function WebBrowser.ExecuteScript(ByRef JavaScript As WString, bWait As Boolean = False) ByRef As WString
		If Trim(JavaScript) = "" Then Return ""
		WLet(ScriptResult,"")
		#ifdef __USE_WEBVIEW2__
			If webviewWindow Then
				WDeAllocate(ScriptResult)
				ScriptResult = 0
				webviewWindow->lpVtbl->ExecuteScript(webviewWindow, @JavaScript, ExecuteScriptCompletedHandler)
				If bWait Then
					Do While ScriptResult = 0
						App.DoEvents
					Loop
				End If
			End If
		#endif
		If ScriptResult = 0 Then Return ""
		Return *ScriptResult
	End Function

	Private Function WebBrowser.DocumentTitle() As UString
		Dim As UString sRet
		#ifdef __USE_GTK__
			Dim As gchar Ptr pTitle = webkit_web_view_get_title(widget)
			If pTitle Then
				Dim As WString Ptr pText = FromUtf8(Cast(ZString Ptr, pTitle))
				If pText Then sRet = *pText: _Deallocate(pText)
			End If
		#elseif defined(__USE_WEBVIEW2__)
			If webviewWindow Then
				Dim As WString Ptr pTitle
				webviewWindow->lpVtbl->get_DocumentTitle(webviewWindow, @pTitle)
				If pTitle Then sRet = *pTitle: CoTaskMemFree(pTitle)
			End If
		#elseif defined(__USE_WINAPI__)
			If g_IWebBrowser Then
				Dim As BSTR bTitle
				g_IWebBrowser->get_LocationName(Cast(IWebBrowser2 Ptr, pIWebBrowser), @bTitle)
				If bTitle Then sRet = *Cast(WString Ptr, bTitle): SysFreeString(bTitle)
			End If
		#endif
		Return sRet
	End Function

	Private Sub WebBrowser.PrintToPDF(ByRef FileName As WString)
		#ifdef __USE_WEBVIEW2__
			If webviewWindow Then
				Dim As GUID IID_ICoreWebView2_7 = Type(&h79c24d83, &h09a3, &h45ae, {&h94, &h18, &h48, &h7f, &h32, &ha5, &h87, &h40})
				Dim As ICoreWebView2_7 Ptr webview7
				If webviewWindow->lpVtbl->QueryInterface(webviewWindow, @IID_ICoreWebView2_7, Cast(PVOID Ptr, @webview7)) = S_OK AndAlso webview7 <> 0 Then
					webview7->lpVtbl->PrintToPdf(webview7, @FileName, NULL, Cast(ICoreWebView2PrintToPdfCompletedHandler Ptr, @PrintToPdfCompletedHandler))
					Cast(ICoreWebView2 Ptr, webview7)->lpVtbl->Release(Cast(ICoreWebView2 Ptr, webview7))
					Exit Sub
				End If
				Print "PrintToPDF requires a newer version of the WebView2 runtime."
			Else
				Print "WebView2 window has not been created. Install the WebView2 runtime."
			End If
		#endif
		If OnPrintToPDFCompleted Then OnPrintToPDFCompleted(*Designer, This, False)
	End Sub

	Private Sub WebBrowser.PostWebMessage(ByRef Message As WString, AsJson As Boolean = False)
		#ifdef __USE_WEBVIEW2__
			If webviewWindow Then
				If AsJson Then
					webviewWindow->lpVtbl->PostWebMessageAsJson(webviewWindow, @Message)
				Else
					webviewWindow->lpVtbl->PostWebMessageAsString(webviewWindow, @Message)
				End If
			Else
				Print "WebView2 window has not been created. Install the WebView2 runtime."
			End If
		#endif
	End Sub

	Private Sub WebBrowser.AddWebResourceRequestedFilter(ByRef URI As WString, ResourceContext As Integer = 0)
		#ifdef __USE_WEBVIEW2__
			If webviewWindow Then
				webviewWindow->lpVtbl->AddWebResourceRequestedFilter(webviewWindow, @URI, ResourceContext)
			Else
				Print "WebView2 window has not been created. Install the WebView2 runtime."
			End If
		#endif
	End Sub
	
	Private Sub WebBrowser.SetBody(ByRef tText As WString, ByVal flag As Long = 0)
		#ifdef __USE_GTK__
			'#ifdef __USE_GTK3__
			'	webkit_web_view_load_html(Cast(Any Ptr, widget), ToUTF8(tText))
			'#else
			webkit_web_view_load_html_string(Cast(Any Ptr, widget), ToUtf8(tText))
			'#endif
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			FBody = tText
			If FHandle Then LoadHTML(FHandle, ToUtf8(tText))
		#elseif defined(__USE_WINAPI__)
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
	
	#ifdef __USE_WINAPI__
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
						If WebB->webviewWindow = NULL Then
							If WebB->OnCreateWebViewCompleted Then WebB->OnCreateWebViewCompleted(*(WebB->Designer), *WebB, False)
							Return S_OK
						End If
						
						Dim As ICoreWebView2Settings Ptr Settings
						WebB->webviewWindow->lpVtbl->get_Settings(WebB->webviewWindow, @Settings)
						If Settings Then
							Settings->lpVtbl->put_IsScriptEnabled(Settings, ByVal 1)
							'Script dialogs are reported by OnScriptDialogOpening only if the default dialogs are disabled
							Settings->lpVtbl->put_AreDefaultScriptDialogsEnabled(Settings, IIf(WebB->OnScriptDialogOpening, 0, 1))
							Settings->lpVtbl->put_IsWebMessageEnabled(Settings, ByVal 1)
							Settings->lpVtbl->put_AreDevToolsEnabled(Settings, ByVal 0)
							Settings->lpVtbl->put_AreDefaultContextMenusEnabled(Settings, ByVal 1)
							Settings->lpVtbl->put_IsStatusBarEnabled(Settings, ByVal 1)
							Settings->lpVtbl->Release(Settings)
						End If
						Dim As EventRegistrationToken token
						WebB->webviewWindow->lpVtbl->add_NewWindowRequested(WebB->webviewWindow, WebB->NewWindowRequestedEventHandler, @token)
						WebB->AddEventHandlers
						
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
						If WebB->OnCreateWebViewCompleted Then WebB->OnCreateWebViewCompleted(*(WebB->Designer), *WebB, True)
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
					Static As WString * 1 sEmpty
					Dim As WString Ptr pResult = Cast(WString Ptr, resultObjectAsJson)
					If pResult = 0 Then pResult = @sEmpty
					If WebB->ScriptResult = 0 Then
						WebB->bExecuteScriptCompletedHandlerCreated = True
						WLet(WebB->ScriptResult, *pResult)
					End If
					If WebB->OnExecuteScript <> 0 AndAlso Not WebB->bInternalScript Then WebB->OnExecuteScript(*(WebB->Designer), *WebB, errorCode, *pResult)
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.NewWindowRequestedEventHandlerAddRef stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->NewWindowRequestedEventHandlerRefCount += 1
					Return WebB->NewWindowRequestedEventHandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.NewWindowRequestedEventHandlerRelease stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr) As culong
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					WebB->NewWindowRequestedEventHandlerRefCount -= 1
					If (WebB->NewWindowRequestedEventHandlerRefCount = 0) Then
						If (WebB->NewWindowRequestedEventHandler) Then
						'	free(WebB->ExecuteScriptCompletedHandler->lpVtbl)
						'	free(WebB->ExecuteScriptCompletedHandler)
						End If
					End If
					Return WebB->NewWindowRequestedEventHandlerRefCount
				Else
					Return 0
				End If
			End Function
			
			Function WebBrowser.NewWindowRequestedEventHandlerQueryInterface stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					*ppvObject = This_
					NewWindowRequestedEventHandlerAddRef(This_)
				End If
				Return S_OK
			End Function
			
			Function WebBrowser.NewWindowRequestedEventHandlerInvoke stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NewWindowRequestedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = Handles.Get(This_)
				If WebB Then
					Dim As NewWindowRequestedEventArgs e
					e.Handle = args
					If WebB->OnNewWindowRequested Then WebB->OnNewWindowRequested(* (WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			'Returns a copy of a string allocated by WebView2 and frees it
			Private Function TakeCoTaskString(pText As LPWSTR) As UString
				Dim As UString sRet
				If pText Then
					sRet = *Cast(WString Ptr, pText)
					CoTaskMemFree(pText)
				End If
				Return sRet
			End Function

			Private Sub WebBrowser.InitEventHandler(ByRef Handler As WebViewEventHandler, InvokeProc As Any Ptr)
				Handler.Vtbl.QueryInterface = @EventHandlerQueryInterface
				Handler.Vtbl.AddRef = @EventHandlerAddRef
				Handler.Vtbl.Release = @EventHandlerRelease
				Handler.Vtbl.Invoke = InvokeProc
				Handler.lpVtbl = @Handler.Vtbl
				Handler.Owner = @This
			End Sub

			Private Sub WebBrowser.AddEventHandlers()
				Dim As EventRegistrationToken token
				With *webviewWindow->lpVtbl
					.add_NavigationStarting(webviewWindow, Cast(ICoreWebView2NavigationStartingEventHandler Ptr, @NavigationStartingHandler), @token)
					.add_NavigationCompleted(webviewWindow, Cast(ICoreWebView2NavigationCompletedEventHandler Ptr, @NavigationCompletedHandler), @token)
					.add_FrameNavigationStarting(webviewWindow, Cast(ICoreWebView2NavigationStartingEventHandler Ptr, @FrameNavigationStartingHandler), @token)
					.add_FrameNavigationCompleted(webviewWindow, Cast(ICoreWebView2NavigationCompletedEventHandler Ptr, @FrameNavigationCompletedHandler), @token)
					.add_ContentLoading(webviewWindow, Cast(ICoreWebView2ContentLoadingEventHandler Ptr, @ContentLoadingHandler), @token)
					.add_SourceChanged(webviewWindow, Cast(ICoreWebView2SourceChangedEventHandler Ptr, @SourceChangedHandler), @token)
					.add_HistoryChanged(webviewWindow, Cast(ICoreWebView2HistoryChangedEventHandler Ptr, @HistoryChangedHandler), @token)
					.add_DocumentTitleChanged(webviewWindow, Cast(ICoreWebView2DocumentTitleChangedEventHandler Ptr, @DocumentTitleChangedHandler), @token)
					.add_WebMessageReceived(webviewWindow, Cast(ICoreWebView2WebMessageReceivedEventHandler Ptr, @WebMessageReceivedHandler), @token)
					.add_WebResourceRequested(webviewWindow, Cast(ICoreWebView2WebResourceRequestedEventHandler Ptr, @WebResourceRequestedHandler), @token)
					.add_WindowCloseRequested(webviewWindow, Cast(ICoreWebView2WindowCloseRequestedEventHandler Ptr, @WindowCloseRequestedHandler), @token)
					.add_ContainsFullScreenElementChanged(webviewWindow, Cast(ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr, @ContainsFullScreenElementChangedHandler), @token)
					.add_PermissionRequested(webviewWindow, Cast(ICoreWebView2PermissionRequestedEventHandler Ptr, @PermissionRequestedHandler), @token)
					.add_ScriptDialogOpening(webviewWindow, Cast(ICoreWebView2ScriptDialogOpeningEventHandler Ptr, @ScriptDialogOpeningHandler), @token)
					.add_ProcessFailed(webviewWindow, Cast(ICoreWebView2ProcessFailedEventHandler Ptr, @ProcessFailedHandler), @token)
				End With
				If OnWebResourceRequested Then AddWebResourceRequestedFilter("*", COREWEBVIEW2_WEB_RESOURCE_CONTEXT_ALL)
				If webviewController Then webviewController->lpVtbl->add_ZoomFactorChanged(webviewController, Cast(ICoreWebView2ZoomFactorChangedEventHandler Ptr, @ZoomFactorChangedHandler), @token)
				'DOMContentLoaded and DownloadStarting are available in the newer interfaces only
				Dim As GUID IID_ICoreWebView2_2 = Type(&h9E8F0CF8, &hE670, &h4B5E, {&hB2, &hBC, &h73, &hE0, &h61, &hE3, &h18, &h4C})
				Dim As ICoreWebView2_2 Ptr webview2_2
				If webviewWindow->lpVtbl->QueryInterface(webviewWindow, @IID_ICoreWebView2_2, Cast(PVOID Ptr, @webview2_2)) = S_OK AndAlso webview2_2 <> 0 Then
					webview2_2->lpVtbl->add_DOMContentLoaded(webview2_2, Cast(ICoreWebView2DOMContentLoadedEventHandler Ptr, @DOMContentLoadedHandler), @token)
					Cast(ICoreWebView2 Ptr, webview2_2)->lpVtbl->Release(Cast(ICoreWebView2 Ptr, webview2_2))
				End If
				Dim As GUID IID_ICoreWebView2_4 = Type(&h20d02d59, &h6df2, &h42dc, {&hbd, &h06, &hf9, &h8a, &h69, &h4b, &h13, &h02})
				Dim As ICoreWebView2_4 Ptr webview2_4
				If webviewWindow->lpVtbl->QueryInterface(webviewWindow, @IID_ICoreWebView2_4, Cast(PVOID Ptr, @webview2_4)) = S_OK AndAlso webview2_4 <> 0 Then
					webview2_4->lpVtbl->add_DownloadStarting(webview2_4, Cast(ICoreWebView2DownloadStartingEventHandler Ptr, @DownloadStartingHandler), @token)
					Cast(ICoreWebView2 Ptr, webview2_4)->lpVtbl->Release(Cast(ICoreWebView2 Ptr, webview2_4))
				End If
			End Sub

			'The handlers live as long as the WebBrowser, so reference counting is not needed
			Private Function WebBrowser.EventHandlerAddRef stdcall (This_ As WebViewEventHandler Ptr) As culong
				Return 1
			End Function

			Private Function WebBrowser.EventHandlerRelease stdcall (This_ As WebViewEventHandler Ptr) As culong
				Return 1
			End Function

			Private Function WebBrowser.EventHandlerQueryInterface stdcall (This_ As WebViewEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				*ppvObject = This_
				Return S_OK
			End Function

			Private Sub GetNavigationStartingEventArgs(args As ICoreWebView2NavigationStartingEventArgs Ptr, ByRef e As NavigationStartingEventArgs)
				Dim As LPWSTR pURL
				Dim As BOOL bValue
				args->lpVtbl->get_Uri(args, @pURL)
				e.URL = TakeCoTaskString(pURL)
				args->lpVtbl->get_IsUserInitiated(args, @bValue): e.IsUserInitiated = bValue
				args->lpVtbl->get_IsRedirected(args, @bValue): e.IsRedirected = bValue
				args->lpVtbl->get_NavigationId(args, @e.NavigationId)
			End Sub

			Private Sub GetNavigationCompletedEventArgs(args As ICoreWebView2NavigationCompletedEventArgs Ptr, ByRef e As NavigationCompletedEventArgs)
				Dim As BOOL bIsSuccess
				Dim As COREWEBVIEW2_WEB_ERROR_STATUS iStatus
				args->lpVtbl->get_IsSuccess(args, @bIsSuccess): e.IsSuccess = bIsSuccess
				args->lpVtbl->get_WebErrorStatus(args, @iStatus): e.WebErrorStatus = iStatus
				args->lpVtbl->get_NavigationId(args, @e.NavigationId)
			End Sub

			Private Function WebBrowser.NavigationStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationStartingEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnNavigationStarting Then
					Dim As NavigationStartingEventArgs e
					GetNavigationStartingEventArgs(args, e)
					WebB->OnNavigationStarting(*(WebB->Designer), *WebB, e)
					If e.Cancel Then args->lpVtbl->put_Cancel(args, True)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.FrameNavigationStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationStartingEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnFrameNavigationStarting Then
					Dim As NavigationStartingEventArgs e
					GetNavigationStartingEventArgs(args, e)
					WebB->OnFrameNavigationStarting(*(WebB->Designer), *WebB, e)
					If e.Cancel Then args->lpVtbl->put_Cancel(args, True)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.NavigationCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationCompletedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnNavigationCompleted Then
					Dim As NavigationCompletedEventArgs e
					GetNavigationCompletedEventArgs(args, e)
					WebB->OnNavigationCompleted(*(WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.FrameNavigationCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationCompletedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnFrameNavigationCompleted Then
					Dim As NavigationCompletedEventArgs e
					GetNavigationCompletedEventArgs(args, e)
					WebB->OnFrameNavigationCompleted(*(WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.ContentLoadingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ContentLoadingEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnContentLoading Then
					Dim As ContentLoadingEventArgs e
					Dim As BOOL bIsErrorPage
					args->lpVtbl->get_IsErrorPage(args, @bIsErrorPage): e.IsErrorPage = bIsErrorPage
					args->lpVtbl->get_NavigationId(args, @e.NavigationId)
					WebB->OnContentLoading(*(WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.SourceChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2SourceChangedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnSourceChanged Then
					Dim As BOOL bIsNewDocument
					args->lpVtbl->get_IsNewDocument(args, @bIsNewDocument)
					WebB->OnSourceChanged(*(WebB->Designer), *WebB, bIsNewDocument)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.HistoryChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnHistoryChanged Then WebB->OnHistoryChanged(*(WebB->Designer), *WebB)
				Return S_OK
			End Function

			Private Function WebBrowser.DocumentTitleChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnDocumentTitleChanged Then
					Dim As UString sTitle = WebB->DocumentTitle
					WebB->OnDocumentTitleChanged(*(WebB->Designer), *WebB, sTitle)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.DOMContentLoadedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2DOMContentLoadedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnDOMContentLoaded Then WebB->OnDOMContentLoaded(*(WebB->Designer), *WebB)
				Return S_OK
			End Function

			Private Function WebBrowser.WebMessageReceivedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebMessageReceivedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnWebMessageReceived Then
					Dim As WebMessageReceivedEventArgs e
					Dim As LPWSTR pText
					args->lpVtbl->get_Source(args, @pText): e.Source = TakeCoTaskString(pText)
					pText = 0: args->lpVtbl->get_WebMessageAsJson(args, @pText): e.WebMessageAsJson = TakeCoTaskString(pText)
					pText = 0: args->lpVtbl->TryGetWebMessageAsString(args, @pText): e.WebMessageAsString = TakeCoTaskString(pText)
					WebB->OnWebMessageReceived(*(WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.WebResourceRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebResourceRequestedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnWebResourceRequested Then
					Dim As WebResourceRequestedEventArgs e
					Dim As ICoreWebView2WebResourceRequest Ptr request
					Dim As COREWEBVIEW2_WEB_RESOURCE_CONTEXT iContext
					args->lpVtbl->get_ResourceContext(args, @iContext): e.ResourceContext = iContext
					args->lpVtbl->get_Request(args, @request)
					If request Then
						Dim As LPWSTR pText
						request->lpVtbl->get_Uri(request, @pText): e.URL = TakeCoTaskString(pText)
						pText = 0: request->lpVtbl->get_Method(request, @pText): e.Method = TakeCoTaskString(pText)
						request->lpVtbl->Release(request)
					End If
					WebB->OnWebResourceRequested(*(WebB->Designer), *WebB, e)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.DownloadStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2DownloadStartingEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnDownloadStarting Then
					Dim As DownloadStartingEventArgs e
					Dim As LPWSTR pText
					Dim As ICoreWebView2DownloadOperation Ptr Operation
					args->lpVtbl->get_DownloadOperation(args, @Operation)
					If Operation Then
						Operation->lpVtbl->get_Uri(Operation, @pText): e.URL = TakeCoTaskString(pText)
						pText = 0: Operation->lpVtbl->get_MimeType(Operation, @pText): e.MimeType = TakeCoTaskString(pText)
						Operation->lpVtbl->get_TotalBytesToReceive(Operation, @e.TotalBytesToReceive)
						Operation->lpVtbl->Release(Operation)
					End If
					pText = 0: args->lpVtbl->get_ResultFilePath(args, @pText): e.ResultFilePath = TakeCoTaskString(pText)
					Dim As UString OldResultFilePath = e.ResultFilePath
					WebB->OnDownloadStarting(*(WebB->Designer), *WebB, e)
					If e.Cancel Then args->lpVtbl->put_Cancel(args, True)
					If e.Handled Then args->lpVtbl->put_Handled(args, True)
					If e.ResultFilePath <> OldResultFilePath Then args->lpVtbl->put_ResultFilePath(args, e.ResultFilePath.vptr)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.WindowCloseRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnWindowCloseRequested Then WebB->OnWindowCloseRequested(*(WebB->Designer), *WebB)
				Return S_OK
			End Function

			Private Function WebBrowser.ContainsFullScreenElementChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnContainsFullScreenElementChanged Then
					Dim As BOOL bContains
					sender->lpVtbl->get_ContainsFullScreenElement(sender, @bContains)
					WebB->OnContainsFullScreenElementChanged(*(WebB->Designer), *WebB, bContains)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.PermissionRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2PermissionRequestedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnPermissionRequested Then
					Dim As PermissionRequestedEventArgs e
					Dim As LPWSTR pURL
					Dim As BOOL bIsUserInitiated
					Dim As COREWEBVIEW2_PERMISSION_KIND iKind
					Dim As COREWEBVIEW2_PERMISSION_STATE iState
					args->lpVtbl->get_Uri(args, @pURL): e.URL = TakeCoTaskString(pURL)
					args->lpVtbl->get_PermissionKind(args, @iKind): e.PermissionKind = iKind
					args->lpVtbl->get_IsUserInitiated(args, @bIsUserInitiated): e.IsUserInitiated = bIsUserInitiated
					args->lpVtbl->get_State(args, @iState): e.State = iState
					WebB->OnPermissionRequested(*(WebB->Designer), *WebB, e)
					If e.State <> iState Then args->lpVtbl->put_State(args, e.State)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.ScriptDialogOpeningInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnScriptDialogOpening Then
					Dim As ScriptDialogOpeningEventArgs e
					Dim As LPWSTR pText
					Dim As COREWEBVIEW2_SCRIPT_DIALOG_KIND iKind
					args->lpVtbl->get_Uri(args, @pText): e.URL = TakeCoTaskString(pText)
					args->lpVtbl->get_Kind(args, @iKind): e.Kind = iKind
					pText = 0: args->lpVtbl->get_Message(args, @pText): e.Message = TakeCoTaskString(pText)
					pText = 0: args->lpVtbl->get_DefaultText(args, @pText): e.DefaultText = TakeCoTaskString(pText)
					e.ResultText = e.DefaultText
					WebB->OnScriptDialogOpening(*(WebB->Designer), *WebB, e)
					If e.Accept Then
						If e.Kind = COREWEBVIEW2_SCRIPT_DIALOG_KIND_PROMPT Then args->lpVtbl->put_ResultText(args, e.ResultText.vptr)
						args->lpVtbl->Accept(args)
					End If
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.ProcessFailedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ProcessFailedEventArgs Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnProcessFailed Then
					Dim As COREWEBVIEW2_PROCESS_FAILED_KIND iKind
					args->lpVtbl->get_ProcessFailedKind(args, @iKind)
					WebB->OnProcessFailed(*(WebB->Designer), *WebB, iKind)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.ZoomFactorChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As IUnknown Ptr) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnZoomFactorChanged Then
					Dim As Double dZoomFactor = 1
					sender->lpVtbl->get_ZoomFactor(sender, @dZoomFactor)
					WebB->OnZoomFactorChanged(*(WebB->Designer), *WebB, dZoomFactor)
				End If
				Return S_OK
			End Function

			Private Function WebBrowser.PrintToPdfCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, errorCode As HRESULT, isSuccessful As BOOL) As HRESULT
				Dim As WebBrowser Ptr WebB = This_->Owner
				If WebB->OnPrintToPDFCompleted Then WebB->OnPrintToPDFCompleted(*(WebB->Designer), *WebB, errorCode = S_OK AndAlso isSuccessful <> 0)
				Return S_OK
			End Function
		#endif
		
		Private Property NewWindowRequestedEventArgs.Handled() As Boolean
			#ifdef __USE_WEBVIEW2__
				Dim bHandled As BOOL
				Handle->lpVtbl->get_Handled(Handle, @bHandled)
				Return bHandled
			#else
				Return False
			#endif
		End Property
		
		Private Property NewWindowRequestedEventArgs.Handled(Value As Boolean)
			#ifdef __USE_WEBVIEW2__
				Dim bHandled As BOOL = True
				Handle->lpVtbl->put_Handled(Handle, bHandled)
			#endif
		End Property
		
		Private Function NewWindowRequestedEventArgs.GetIsUserInitiated() As Boolean
			#ifdef __USE_WEBVIEW2__
				Dim bIsUserInitiated As BOOL
				Handle->lpVtbl->get_IsUserInitiated(Handle, @bIsUserInitiated)
				Return bIsUserInitiated
			#else
				Return False
			#endif
		End Function
		
		Private Function NewWindowRequestedEventArgs.GetURL() ByRef As WString
			#ifdef __USE_WEBVIEW2__
				Dim As WString Ptr pURL
				Handle->lpVtbl->get_Uri(Handle, @pURL)
				Return *pURL
			#else
				Return ""
			#endif
		End Function
		
		Private Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender Then
				With QWebBrowser(Sender.Child)
					#ifdef __USE_WEBVIEW2__
						'CoInitializeEx(0, COINIT_APARTMENTTHREADED)
						Dim As HRESULT hr
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
						
						.NewWindowRequestedEventHandler = malloc(SizeOf(ICoreWebView2NewWindowRequestedEventHandler))
						If (.NewWindowRequestedEventHandler = 0) Then
							Print GetLastError()
							Return
						End If
						Handles.Add .NewWindowRequestedEventHandler, @Sender
						.NewWindowRequestedEventHandler->lpVtbl = malloc(SizeOf(ICoreWebView2NewWindowRequestedEventHandlerVtbl))
						If (.NewWindowRequestedEventHandler->lpVtbl = 0) Then
							Print GetLastError()
							Return
						End If
						.NewWindowRequestedEventHandler->lpVtbl->AddRef = @NewWindowRequestedEventHandlerAddRef
						.NewWindowRequestedEventHandler->lpVtbl->Release = @NewWindowRequestedEventHandlerRelease
						.NewWindowRequestedEventHandler->lpVtbl->QueryInterface = @NewWindowRequestedEventHandlerQueryInterface
						.NewWindowRequestedEventHandler->lpVtbl->Invoke = @NewWindowRequestedEventHandlerInvoke
					
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
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QWebBrowser(Sender.Child)
					If Len(.FBody) Then
						LoadHTML(.FHandle, ToUtf8(.FBody))
					ElseIf .FText AndAlso *.FText <> "" AndAlso *.FText <> "about:blank" Then
						LoadURL(.FHandle, ToUtf8(*.FText))
					End If
				End With
			End If
		End Sub
		
		Private Sub WebBrowser.WndProc(ByRef Message As Message)
		End Sub
	#elseif defined(__USE_GTK__)
		Private Function WebKitString(pText As gchar Ptr) As UString
			Dim As UString sRet
			If pText Then
				Dim As WString Ptr pWText = FromUtf8(Cast(ZString Ptr, pText))
				If pWText Then sRet = *pWText: _Deallocate(pWText)
			End If
			Return sRet
		End Function

		Private Sub WebBrowser.WebView_NotifyTitle(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			Dim As WebBrowser Ptr WebB = user_data
			If WebB->OnDocumentTitleChanged Then
				Dim As UString sTitle = WebB->DocumentTitle
				WebB->OnDocumentTitleChanged(*(WebB->Designer), *WebB, sTitle)
			End If
		End Sub

		Private Sub WebBrowser.WebView_NotifyUri(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			Dim As WebBrowser Ptr WebB = user_data
			If WebB->OnSourceChanged Then WebB->OnSourceChanged(*(WebB->Designer), *WebB, True)
			If WebB->OnHistoryChanged Then WebB->OnHistoryChanged(*(WebB->Designer), *WebB)
		End Sub

		#ifdef __USE_GTK4__
			Private Sub WebBrowser.WebView_LoadChanged(web_view As Any Ptr, load_event As Long, user_data As Any Ptr)
				Dim As WebBrowser Ptr WebB = user_data
				Select Case load_event
				Case 0 'WEBKIT_LOAD_STARTED
					WebB->FLoadFailed = False
				Case 2 'WEBKIT_LOAD_COMMITTED
					If WebB->OnContentLoading Then
						Dim As ContentLoadingEventArgs e
						WebB->OnContentLoading(*(WebB->Designer), *WebB, e)
					End If
				Case 3 'WEBKIT_LOAD_FINISHED
					If WebB->FLoadFailed Then
						WebB->FLoadFailed = False
					ElseIf WebB->OnNavigationCompleted Then
						Dim As NavigationCompletedEventArgs e
						e.IsSuccess = True
						WebB->OnNavigationCompleted(*(WebB->Designer), *WebB, e)
					End If
				End Select
			End Sub

			Private Function WebBrowser.WebView_LoadFailed(web_view As Any Ptr, load_event As Long, failing_uri As gchar Ptr, error_ As GError Ptr, user_data As Any Ptr) As gboolean
				Dim As WebBrowser Ptr WebB = user_data
				WebB->FLoadFailed = True
				If WebB->OnNavigationCompleted Then
					Dim As NavigationCompletedEventArgs e
					e.IsSuccess = False
					WebB->OnNavigationCompleted(*(WebB->Designer), *WebB, e)
				End If
				Return False
			End Function

			Private Function WebBrowser.WebView_DecidePolicy(web_view As Any Ptr, decision As Any Ptr, decision_type As Long, user_data As Any Ptr) As gboolean
				Dim As WebBrowser Ptr WebB = user_data
				If decision_type = 0 AndAlso WebB->OnNavigationStarting Then 'WEBKIT_POLICY_DECISION_TYPE_NAVIGATION_ACTION
					Dim As Any Ptr Action = webkit_navigation_policy_decision_get_navigation_action(decision)
					If Action Then
						Dim As NavigationStartingEventArgs e
						e.URL = WebKitString(webkit_uri_request_get_uri(webkit_navigation_action_get_request(Action)))
						e.IsUserInitiated = webkit_navigation_action_is_user_gesture(Action)
						e.IsRedirected = webkit_navigation_action_is_redirect(Action)
						WebB->OnNavigationStarting(*(WebB->Designer), *WebB, e)
						If e.Cancel Then
							webkit_policy_decision_ignore(decision)
							Return True
						End If
					End If
				End If
				Return False
			End Function

			Private Sub WebBrowser.WebView_Close(web_view As Any Ptr, user_data As Any Ptr)
				Dim As WebBrowser Ptr WebB = user_data
				If WebB->OnWindowCloseRequested Then WebB->OnWindowCloseRequested(*(WebB->Designer), *WebB)
			End Sub
		#else
			Private Sub WebBrowser.WebView_NotifyLoadStatus(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
				Dim As WebBrowser Ptr WebB = user_data
				Select Case webkit_web_view_get_load_status(WebB->widget)
				Case 1 'WEBKIT_LOAD_COMMITTED
					If WebB->OnContentLoading Then
						Dim As ContentLoadingEventArgs e
						WebB->OnContentLoading(*(WebB->Designer), *WebB, e)
					End If
				Case 2, 4 'WEBKIT_LOAD_FINISHED, WEBKIT_LOAD_FAILED
					If WebB->OnNavigationCompleted Then
						Dim As NavigationCompletedEventArgs e
						e.IsSuccess = webkit_web_view_get_load_status(WebB->widget) = 2
						WebB->OnNavigationCompleted(*(WebB->Designer), *WebB, e)
					End If
				End Select
			End Sub

			Private Function WebBrowser.WebView_NavigationPolicyDecisionRequested(web_view As Any Ptr, frame As Any Ptr, request As Any Ptr, navigation_action As Any Ptr, policy_decision As Any Ptr, user_data As Any Ptr) As gboolean
				Dim As WebBrowser Ptr WebB = user_data
				Dim As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NavigationStartingEventArgs) OnStarting
				If frame = webkit_web_view_get_main_frame(web_view) Then
					OnStarting = WebB->OnNavigationStarting
				Else
					OnStarting = WebB->OnFrameNavigationStarting
				End If
				If OnStarting Then
					Dim As NavigationStartingEventArgs e
					e.URL = WebKitString(webkit_network_request_get_uri(request))
					Dim As Long iReason = webkit_web_navigation_action_get_reason(navigation_action)
					e.IsUserInitiated = (iReason = 0 OrElse iReason = 1) 'WEBKIT_WEB_NAVIGATION_REASON_LINK_CLICKED, WEBKIT_WEB_NAVIGATION_REASON_FORM_SUBMITTED
					OnStarting(*(WebB->Designer), *WebB, e)
					If e.Cancel Then
						webkit_web_policy_decision_ignore(policy_decision)
						Return True
					End If
				End If
				Return False
			End Function

			Private Function WebBrowser.WebView_CloseWebView(web_view As Any Ptr, user_data As Any Ptr) As gboolean
				Dim As WebBrowser Ptr WebB = user_data
				If WebB->OnWindowCloseRequested Then WebB->OnWindowCloseRequested(*(WebB->Designer), *WebB)
				Return False
			End Function
		#endif
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
			WLet(FText, "about:blank")
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				widget = webkit_web_view_new()
				#ifdef __USE_GTK2__
					#ifdef __USE_GTK4__
						scrolledwidget = gtk_scrolled_window_new()
					#else
						scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
					#endif
					gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
					gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
				#endif
				webkit_web_view_load_uri(Cast(Any Ptr, widget), Cast(gchar Ptr, @"about:blank"))
				g_signal_connect(widget, "notify::title", G_CALLBACK(@WebView_NotifyTitle), @This)
				g_signal_connect(widget, "notify::uri", G_CALLBACK(@WebView_NotifyUri), @This)
				#ifdef __USE_GTK4__
					g_signal_connect(widget, "load-changed", G_CALLBACK(@WebView_LoadChanged), @This)
					g_signal_connect(widget, "load-failed", G_CALLBACK(@WebView_LoadFailed), @This)
					g_signal_connect(widget, "decide-policy", G_CALLBACK(@WebView_DecidePolicy), @This)
					g_signal_connect(widget, "close", G_CALLBACK(@WebView_Close), @This)
				#else
					g_signal_connect(widget, "notify::load-status", G_CALLBACK(@WebView_NotifyLoadStatus), @This)
					g_signal_connect(widget, "navigation-policy-decision-requested", G_CALLBACK(@WebView_NavigationPolicyDecisionRequested), @This)
					g_signal_connect(widget, "close-web-view", G_CALLBACK(@WebView_CloseWebView), @This)
				#endif
			#elseif defined(__USE_WINAPI__)
				#ifdef __USE_WEBVIEW2__
					InitEventHandler NavigationStartingHandler, @NavigationStartingInvoke
					InitEventHandler NavigationCompletedHandler, @NavigationCompletedInvoke
					InitEventHandler FrameNavigationStartingHandler, @FrameNavigationStartingInvoke
					InitEventHandler FrameNavigationCompletedHandler, @FrameNavigationCompletedInvoke
					InitEventHandler ContentLoadingHandler, @ContentLoadingInvoke
					InitEventHandler SourceChangedHandler, @SourceChangedInvoke
					InitEventHandler HistoryChangedHandler, @HistoryChangedInvoke
					InitEventHandler DocumentTitleChangedHandler, @DocumentTitleChangedInvoke
					InitEventHandler DOMContentLoadedHandler, @DOMContentLoadedInvoke
					InitEventHandler WebMessageReceivedHandler, @WebMessageReceivedInvoke
					InitEventHandler WebResourceRequestedHandler, @WebResourceRequestedInvoke
					InitEventHandler DownloadStartingHandler, @DownloadStartingInvoke
					InitEventHandler WindowCloseRequestedHandler, @WindowCloseRequestedInvoke
					InitEventHandler ContainsFullScreenElementChangedHandler, @ContainsFullScreenElementChangedInvoke
					InitEventHandler PermissionRequestedHandler, @PermissionRequestedInvoke
					InitEventHandler ScriptDialogOpeningHandler, @ScriptDialogOpeningInvoke
					InitEventHandler ProcessFailedHandler, @ProcessFailedInvoke
					InitEventHandler ZoomFactorChangedHandler, @ZoomFactorChangedInvoke
					InitEventHandler PrintToPdfCompletedHandler, @PrintToPdfCompletedInvoke
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
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "iframe")
				FElementStyle = "border: 1px solid var(--mff-border, #aaa);"
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "mff:WebView")
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor WebBrowser
		#ifdef __USE_WINAPI__
			'This.Stop()
			#ifdef __USE_WEBVIEW2__
				'Closing the controller releases the event handlers, which are part of This
				If webviewController Then
					webviewController->lpVtbl->Close(webviewController)
					webviewController->lpVtbl->Release(webviewController)
					webviewController = NULL
				End If
				If webviewWindow Then
					webviewWindow->lpVtbl->Release(webviewWindow)
					webviewWindow = NULL
				End If
			#else
				If g_IWebBrowser Then g_IWebBrowser->Quit(Cast(IWebBrowser2 Ptr, pIWebBrowser))
				DestroyWindow FHandle
				FHandle = 0
				FreeLibrary(hWebBrowser)
				'UnregisterClass "WebBrowser", GetModuleHandle(NULL)
			#endif
		#endif
	End Destructor
End Namespace
