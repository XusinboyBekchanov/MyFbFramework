
#include once "mongoose.bi"
#include once "crt/stdio.bi"
#ifndef __FB_64BIT__
#libpath "win32"
#else
#libpath "win64"
#endif
Dim Shared s_listen_on As ZString Ptr =  @"ws://localhost:8000"
Dim Shared s_web_root As  ZString Ptr =  @"."

Private Sub fn(ByVal c As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
   If ev = MG_EV_OPEN Then
   ElseIf ev = MG_EV_HTTP_MSG Then
      Dim hm As mg_http_message Ptr = CPtr(mg_http_message Ptr, ev_data)
      If mg_match(hm->uri, mg_str_s(Cast(ZString Ptr, @"/websocket")), NULL) Then
         mg_ws_upgrade(c, hm, NULL)
      ElseIf mg_match(hm->uri, mg_str_s( Cast(ZString Ptr, @"/rest")), NULL) Then
         mg_http_reply(c, 200, "", !"{""result"": %d}\n", "123")
      Else
            Dim opts As mg_http_serve_opts
            opts.root_dir = s_web_root
         mg_http_serve_dir(c, ev_data, @opts)
      End If
   ElseIf ev = MG_EV_WS_MSG Then
      Dim wm As mg_ws_message Ptr = CPtr(mg_ws_message Ptr, ev_data)
      mg_ws_send(c, wm->data_.buf, wm->data_.len_, WEBSOCKET_OP_TEXT)
   End If
End Sub

   Dim mgr As mg_mgr
   mg_mgr_init(@mgr)
   printf(!"Starting WS listener on %s/websocket\n", s_listen_on)
   mg_http_listen(@mgr, s_listen_on,Cast(Any Ptr, @fn), NULL)
    While True
       mg_mgr_poll(@mgr, 1000) 
    Wend
   mg_mgr_free(@mgr)
Sleep
