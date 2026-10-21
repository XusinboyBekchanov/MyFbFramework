'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2023)                                     #
'################################################################################

#include once "Control.bi"
#ifdef __USE_WINAPI__
	#include once "win/exdisp.bi"
	#include once "win/unknwnbase.bi"
	#ifdef __USE_WEBVIEW2__
		#include once "WebView/WebView2.bi"
	#endif
#elseif defined(__USE_GTK__)
	#include once "WebView/WebKitWebView.bi"
#endif

Namespace My.Sys.Forms
	#define QWebBrowser(__Ptr__) (*Cast(WebBrowser Ptr, __Ptr__))
	#ifdef __USE_WEBVIEW2__
		Dim Shared Handles As PointerList
	#endif
	Type NewWindowRequestedEventArgs
		#ifdef __USE_WEBVIEW2__
			Handle As ICoreWebView2NewWindowRequestedEventArgs Ptr
		#else
			Handle As Any Ptr
		#endif
		Declare Property Handled As Boolean
		Declare Property Handled(Value As Boolean)
		Declare Function GetIsUserInitiated() As Boolean
		Declare Function GetURL() ByRef As WString
	End Type

	'Provides data for the OnNavigationStarting and OnFrameNavigationStarting events
	Type NavigationStartingEventArgs
		URL As UString
		IsUserInitiated As Boolean
		IsRedirected As Boolean
		NavigationId As ULongInt
		'Set to True to cancel the navigation
		Cancel As Boolean
	End Type

	'Provides data for the OnNavigationCompleted and OnFrameNavigationCompleted events
	Type NavigationCompletedEventArgs
		IsSuccess As Boolean
		'COREWEBVIEW2_WEB_ERROR_STATUS value (0 - unknown)
		WebErrorStatus As Integer
		NavigationId As ULongInt
	End Type

	'Provides data for the OnContentLoading event
	Type ContentLoadingEventArgs
		IsErrorPage As Boolean
		NavigationId As ULongInt
	End Type

	'Provides data for the OnWebMessageReceived event
	Type WebMessageReceivedEventArgs
		'URL of the document that posted the message
		Source As UString
		WebMessageAsJson As UString
		'Empty if the message was not posted as a string
		WebMessageAsString As UString
	End Type

	'Provides data for the OnWebResourceRequested event
	Type WebResourceRequestedEventArgs
		URL As UString
		Method As UString
		'COREWEBVIEW2_WEB_RESOURCE_CONTEXT value
		ResourceContext As Integer
	End Type

	'Provides data for the OnDownloadStarting event
	Type DownloadStartingEventArgs
		URL As UString
		MimeType As UString
		TotalBytesToReceive As LongInt
		'Gets/sets the path of the file to be saved
		ResultFilePath As UString
		'Set to True to cancel the download
		Cancel As Boolean
		'Set to True to hide the default download dialog
		Handled As Boolean
	End Type

	'Provides data for the OnPermissionRequested event
	Type PermissionRequestedEventArgs
		URL As UString
		'COREWEBVIEW2_PERMISSION_KIND value
		PermissionKind As Integer
		IsUserInitiated As Boolean
		'Set to 1 to allow, 2 to deny, 0 for the default behavior
		State As Integer
	End Type

	'Provides data for the OnScriptDialogOpening event
	Type ScriptDialogOpeningEventArgs
		URL As UString
		'0 - alert, 1 - confirm, 2 - prompt, 3 - beforeunload
		Kind As Integer
		Message As UString
		DefaultText As UString
		'The text returned by a prompt dialog
		ResultText As UString
		'Set to True to respond as if the OK button was clicked
		Accept As Boolean
	End Type

	#ifdef __USE_WEBVIEW2__
		Type WebViewEventHandlerVtbl
			QueryInterface As Any Ptr
			AddRef As Any Ptr
			Release As Any Ptr
			Invoke As Any Ptr
		End Type

		'COM event handler object owned by a WebBrowser
		Type WebViewEventHandler
			lpVtbl As WebViewEventHandlerVtbl Ptr
			Owner As Any Ptr
			Vtbl As WebViewEventHandlerVtbl
		End Type
	#endif

	'`WebBrowser` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`WebBrowser` - Enables the user to navigate Web pages inside your form (Windows, Linux).
	Private Type WebBrowser Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#else
			Declare Static Sub WebView_NotifyTitle(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			Declare Static Sub WebView_NotifyUri(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			#ifdef __USE_GTK4__
				Declare Static Sub WebView_LoadChanged(web_view As Any Ptr, load_event As Long, user_data As Any Ptr)
				Declare Static Function WebView_LoadFailed(web_view As Any Ptr, load_event As Long, failing_uri As gchar Ptr, error_ As GError Ptr, user_data As Any Ptr) As gboolean
				Declare Static Function WebView_DecidePolicy(web_view As Any Ptr, decision As Any Ptr, decision_type As Long, user_data As Any Ptr) As gboolean
				Declare Static Sub WebView_Close(web_view As Any Ptr, user_data As Any Ptr)
			#else
				Declare Static Sub WebView_NotifyLoadStatus(object As GObject Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
				Declare Static Function WebView_NavigationPolicyDecisionRequested(web_view As Any Ptr, frame As Any Ptr, request As Any Ptr, navigation_action As Any Ptr, policy_decision As Any Ptr, user_data As Any Ptr) As gboolean
				Declare Static Function WebView_CloseWebView(web_view As Any Ptr, user_data As Any Ptr) As gboolean
			#endif
		#endif
	Protected:
		#ifdef __USE_GTK__
			FLoadFailed As Boolean
		#endif
		#if defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			FBody As UString
		#endif
		#ifdef __USE_WINAPI__
			#ifdef __USE_WEBVIEW2__
				Dim As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr envHandler
				Dim As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr completedHandler
				Dim As ICoreWebView2ExecuteScriptCompletedHandler Ptr ExecuteScriptCompletedHandler
				Dim As ICoreWebView2NewWindowRequestedEventHandler Ptr NewWindowRequestedEventHandler
				Dim As ICoreWebView2Controller Ptr webviewController = NULL
				Dim As ICoreWebView2 Ptr webviewWindow = NULL
				Dim As BOOL bEnvCreated = False, bExecuteScriptCompletedHandlerCreated = False
				Dim As ULong HandlerRefCount = 0
				Dim As ULong ExecuteScriptCompletedHandlerRefCount = 0
				Dim As ULong NewWindowRequestedEventHandlerRefCount = 0
				Declare Static Function EnvironmentHandlerAddRef stdcall (This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As culong
				Declare Static Function EnvironmentHandlerRelease stdcall (This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As culong
				Declare Static Function EnvironmentHandlerQueryInterface stdcall (This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Declare Static Function EnvironmentHandlerInvoke stdcall (This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, errorCode As HRESULT, arg As ICoreWebView2Environment Ptr) As HRESULT
				Declare Static Function ControllerHandlerAddRef stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As culong
				Declare Static Function ControllerHandlerRelease stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As culong
				Declare Static Function ControllerHandlerQueryInterface stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Declare Static Function ControllerHandlerInvoke stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, result As HRESULT, createdController As ICoreWebView2Controller Ptr) As HRESULT
				Declare Static Function ExecuteScriptCompletedHandlerAddRef stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As culong
				Declare Static Function ExecuteScriptCompletedHandlerRelease stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As culong
				Declare Static Function ExecuteScriptCompletedHandlerQueryInterface stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Declare Static Function ExecuteScriptCompletedHandlerInvoke stdcall (This_ As ICoreWebView2ExecuteScriptCompletedHandler Ptr, errorCode As HRESULT, resultObjectAsJson As LPCWSTR) As HRESULT
				Declare Static Function NewWindowRequestedEventHandlerAddRef stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr) As culong
				Declare Static Function NewWindowRequestedEventHandlerRelease stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr) As culong
				Declare Static Function NewWindowRequestedEventHandlerQueryInterface stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Declare Static Function NewWindowRequestedEventHandlerInvoke stdcall (This_ As ICoreWebView2NewWindowRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NewWindowRequestedEventArgs Ptr) As HRESULT
				Dim As Boolean bInternalScript
				Dim As WebViewEventHandler NavigationStartingHandler, NavigationCompletedHandler, FrameNavigationStartingHandler, FrameNavigationCompletedHandler
				Dim As WebViewEventHandler ContentLoadingHandler, SourceChangedHandler, HistoryChangedHandler, DocumentTitleChangedHandler, DOMContentLoadedHandler
				Dim As WebViewEventHandler WebMessageReceivedHandler, WebResourceRequestedHandler, DownloadStartingHandler, WindowCloseRequestedHandler
				Dim As WebViewEventHandler ContainsFullScreenElementChangedHandler, PermissionRequestedHandler, ScriptDialogOpeningHandler, ProcessFailedHandler
				Dim As WebViewEventHandler ZoomFactorChangedHandler, PrintToPdfCompletedHandler
				Declare Sub InitEventHandler(ByRef Handler As WebViewEventHandler, InvokeProc As Any Ptr)
				Declare Sub AddEventHandlers()
				Declare Static Function EventHandlerAddRef stdcall (This_ As WebViewEventHandler Ptr) As culong
				Declare Static Function EventHandlerRelease stdcall (This_ As WebViewEventHandler Ptr) As culong
				Declare Static Function EventHandlerQueryInterface stdcall (This_ As WebViewEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
				Declare Static Function NavigationStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationStartingEventArgs Ptr) As HRESULT
				Declare Static Function FrameNavigationStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationStartingEventArgs Ptr) As HRESULT
				Declare Static Function NavigationCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationCompletedEventArgs Ptr) As HRESULT
				Declare Static Function FrameNavigationCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationCompletedEventArgs Ptr) As HRESULT
				Declare Static Function ContentLoadingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ContentLoadingEventArgs Ptr) As HRESULT
				Declare Static Function SourceChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2SourceChangedEventArgs Ptr) As HRESULT
				Declare Static Function HistoryChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Declare Static Function DocumentTitleChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Declare Static Function DOMContentLoadedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2DOMContentLoadedEventArgs Ptr) As HRESULT
				Declare Static Function WebMessageReceivedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebMessageReceivedEventArgs Ptr) As HRESULT
				Declare Static Function WebResourceRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebResourceRequestedEventArgs Ptr) As HRESULT
				Declare Static Function DownloadStartingInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2DownloadStartingEventArgs Ptr) As HRESULT
				Declare Static Function WindowCloseRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Declare Static Function ContainsFullScreenElementChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
				Declare Static Function PermissionRequestedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2PermissionRequestedEventArgs Ptr) As HRESULT
				Declare Static Function ScriptDialogOpeningInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As HRESULT
				Declare Static Function ProcessFailedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ProcessFailedEventArgs Ptr) As HRESULT
				Declare Static Function ZoomFactorChangedInvoke stdcall (This_ As WebViewEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As IUnknown Ptr) As HRESULT
				Declare Static Function PrintToPdfCompletedInvoke stdcall (This_ As WebViewEventHandler Ptr, errorCode As HRESULT, isSuccessful As BOOL) As HRESULT
			#else
				hWebBrowser As HINSTANCE
				g_IWebBrowser As IWebBrowser2Vtbl Ptr
				pIWebBrowser As Integer Ptr
			#endif
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Dim As WString Ptr ScriptResult
		#ifndef ReadProperty_Off
			'Reads a property value from a stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes a property value to a stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property TabIndex As Integer
		'Gets/sets the tab order of the control within its container
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines whether the control can receive focus via Tab key
		Declare Property TabStop(Value As Boolean)
		'Navigates to the specified URL
		Declare Sub Navigate(ByVal URL As WString Ptr)
		'Navigates to the next page in history
		Declare Sub GoForward()
		'Navigates to the previous page in history
		Declare Sub GoBack()
		'Execute JavaScript code in the current document
		Declare Function ExecuteScript(ByRef JavaScript As WString, bWait As Boolean = False) ByRef As WString
		'Reloads the current document
		Declare Sub Refresh()
		'Returns the current URL of the displayed document
		Declare Function GetURL() As UString
		'Returns the current navigation state (e.g., Loading, Complete)
		Declare Function State() As Integer
		'Stops loading the current page
		Declare Sub Stop()
		'Retrieves the HTML content of the document's <body> element
		Declare Function GetBody(ByVal flag As Long = 0) As UString
		'Updates the HTML content of the document's <body> element
		Declare Sub SetBody(ByRef tText As WString, ByVal flag As Long = 0)
		'Returns the title of the current document
		Declare Function DocumentTitle() As UString
		'Prints the current page to a PDF file (WebView2), the result is reported by OnPrintToPDFCompleted
		Declare Sub PrintToPDF(ByRef FileName As WString)
		'Posts a message to the document, received there by window.chrome.webview.addEventListener("message", ...) (WebView2)
		Declare Sub PostWebMessage(ByRef Message As WString, AsJson As Boolean = False)
		'Adds a URL filter (wildcards allowed) for the OnWebResourceRequested event (WebView2)
		Declare Sub AddWebResourceRequestedFilter(ByRef URI As WString, ResourceContext As Integer = 0)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when a new browser window is requested (e.g., target="_blank" links)
		OnNewWindowRequested As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NewWindowRequestedEventArgs)
		'Triggered before the main document navigates to a new URL; set e.Cancel to cancel the navigation
		OnNavigationStarting As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NavigationStartingEventArgs)
		'Triggered when the main document has finished loading (successfully or not)
		OnNavigationCompleted As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NavigationCompletedEventArgs)
		'Triggered before a child frame navigates to a new URL; set e.Cancel to cancel the navigation
		OnFrameNavigationStarting As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NavigationStartingEventArgs)
		'Triggered when a child frame has finished loading (WebView2)
		OnFrameNavigationCompleted As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NavigationCompletedEventArgs)
		'Triggered when the document posts a message with window.chrome.webview.postMessage (WebView2)
		OnWebMessageReceived As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As WebMessageReceivedEventArgs)
		'Triggered when a resource matching a filter is requested (see AddWebResourceRequestedFilter; all resources if assigned before creation) (WebView2)
		OnWebResourceRequested As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As WebResourceRequestedEventArgs)
		'Triggered when the new document starts loading content
		OnContentLoading As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As ContentLoadingEventArgs)
		'Triggered when the DOM content of the document has been loaded (WebView2)
		OnDOMContentLoaded As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser)
		'Triggered when a download is about to start (WebView2)
		OnDownloadStarting As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As DownloadStartingEventArgs)
		'Triggered when a script started by ExecuteScript has finished; Result is the JSON result (WebView2)
		OnExecuteScript As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ErrorCode As Long, ByRef Result As WString)
		'Triggered when the navigation history has changed
		OnHistoryChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser)
		'Triggered when the URL of the document has changed
		OnSourceChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, IsNewDocument As Boolean)
		'Triggered when the browser engine has been created and is ready to use (WebView2)
		OnCreateWebViewCompleted As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, Success As Boolean)
		'Triggered when the title of the document has changed
		OnDocumentTitleChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef Title As WString)
		'Triggered when PrintToPDF has finished
		OnPrintToPDFCompleted As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, Success As Boolean)
		'Triggered when the document calls window.close()
		OnWindowCloseRequested As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser)
		'Triggered when an element of the document enters or leaves full screen mode (WebView2)
		OnContainsFullScreenElementChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ContainsFullScreenElement As Boolean)
		'Triggered when the document requests a permission (camera, microphone, geolocation...) (WebView2)
		OnPermissionRequested As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As PermissionRequestedEventArgs)
		'Triggered instead of the default alert/confirm/prompt dialogs, if assigned before creation (WebView2)
		OnScriptDialogOpening As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As ScriptDialogOpeningEventArgs)
		'Triggered when a browser process has failed or exited (WebView2)
		OnProcessFailed As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ProcessFailedKind As Integer)
		'Triggered when the zoom factor has changed (WebView2)
		OnZoomFactorChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ZoomFactor As Double)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "WebBrowser.bas"
#endif
