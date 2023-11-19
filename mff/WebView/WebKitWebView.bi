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
