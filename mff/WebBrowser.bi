'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2023)                                     #
'################################################################################

#include once "Control.bi"
#ifndef __USE_GTK__
	#include once "win/exdisp.bi"
	#include once "win/unknwnbase.bi"
	#ifdef __USE_WEBVIEW2__
		#include once "WebView/WebView2.bi"
	#endif
#else
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
	
	'`WebBrowser` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`WebBrowser` - Enables the user to navigate Web pages inside your form.
	Private Type WebBrowser Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		#ifndef __USE_GTK__
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
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when a new browser window is requested (e.g., target="_blank" links)
		OnNewWindowRequested As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As WebBrowser, ByRef e As NewWindowRequestedEventArgs)
		'OnNavigationStarting As Sub(ByRef Sender As WebBrowser)
		'OnNavigationCompleted As Sub(ByRef Sender As WebBrowser)
		'OnWebMessageReceived As Sub(ByRef Sender As WebBrowser)
		'OnWebResourceRequested As Sub(ByRef Sender As WebBrowser)
		'OnContentLoading As Sub(ByRef Sender As WebBrowser)
		'OnDownloadStarting As Sub(ByRef Sender As WebBrowser)
		'OnExecuteScript As Sub(ByRef Sender As WebBrowser)
		'OnHistoryChanged As Sub(ByRef Sender As WebBrowser)
		'OnCreateWebViewCompleted As Sub(ByRef Sender As WebBrowser)
		'OnDocumentTitleChanged As Sub(ByRef Sender As WebBrowser)
		'OnPrintToPDFCompleted As Sub(ByRef Sender As WebBrowser)
		'OnWindowCloseRequested As Sub(ByRef Sender As WebBrowser)
		
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "WebBrowser.bas"
#endif
