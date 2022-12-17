'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Control.bi"
#ifndef __USE_GTK__
	#include once "win/exdisp.bi"
	#include once "win/unknwnbase.bi"
#else
	#ifdef __USE_GTK3__
		#inclib "webkitgtk-3.0"
	#else
		#inclib "webkitgtk-1.0"
	#endif
	Extern "C"
		Declare Function webkit_web_view_new() As GtkWidget Ptr
		Declare Sub webkit_web_view_load_uri(web_view As Any Ptr, uri As gchar Ptr)
		Declare Sub webkit_web_view_load_html(web_view As Any Ptr, text As gchar Ptr , base_uri As gchar Ptr = 0)
		Declare Sub webkit_web_view_load_html_string(web_view As Any Ptr , text As gchar Ptr , base_uri As gchar Ptr = 0)
		Declare Sub webkit_web_view_reload_bypass_cache(web_view As Any Ptr) 
		Declare Function webkit_web_view_get_uri(web_view As Any Ptr) As gchar Ptr 
		Declare Function webkit_web_view_can_go_back(web_view As Any Ptr) As gboolean
		Declare Sub webkit_web_view_go_back(web_view As Any Ptr)
		Declare Function webkit_web_view_can_go_forward(web_view As Any Ptr) As gboolean
		Declare Sub webkit_web_view_go_forward(web_view As Any Ptr) 
		Declare Sub webkit_web_view_stop_loading(web_view As Any Ptr)
		Declare Function webkit_web_view_is_loading(web_view As Any Ptr) As gboolean
		Declare Function webkit_web_view_get_load_status (web_view As Any Ptr) As Long
		Declare Function webkit_web_resource_get_data(resource As Any Ptr) As String Ptr
		Declare Function webkit_web_view_get_main_resource(web_view As Any Ptr) As Any Ptr	
	End Extern
#endif

Namespace My.Sys.Forms
	#define QWebBrowser(__Ptr__) (*Cast(WebBrowser Ptr, __Ptr__))
	
	Private Type WebBrowser Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		#ifndef __USE_GTK__
			hWebBrowser As HINSTANCE
			g_IWebBrowser As IWebBrowser2Vtbl Ptr
			pIWebBrowser As Integer Ptr
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Sub Navigate(ByVal URL As WString Ptr)
		Declare Sub GoForward()
		Declare Sub GoBack()
		Declare Sub Refresh()
		Declare Function GetURL() As UString
		Declare Function State() As Integer
		Declare Sub Stop()
		Declare Function GetBody(ByVal flag As Long = 0) As String
		Declare Sub SetBody(ByRef tText As WString, ByVal flag As Long = 0)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "WebBrowser.bas"
#endif
