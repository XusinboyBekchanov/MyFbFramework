
#include once "inc/mongoose.bi"
#include once "crt/stdio.bi"
'#ifndef __FB_64BIT__
'#libpath "win32"
'#else
'#libpath "win64"
'#endif

Dim Shared s_listen_on  As ZString Ptr = @Str("ws://localhost:8000")
Dim Shared s_web_root As Const ZString Ptr = @Str("web_root")
Dim Shared s_rpc_head As mg_rpc Ptr = NULL

Private Sub rpc_sum cdecl (ByVal r As mg_rpc_req Ptr)
   Dim a As Double = 0.0
   Dim b As Double = 0.0
   mg_json_get_num(r->frame, "$.params[0]", @a)
   mg_json_get_num(r->frame, "$.params[1]", @b)
   mg_rpc_ok(r, "%g", a + b)
End Sub

Private Sub rpc_mul cdecl(ByVal r As mg_rpc_req Ptr)
   Dim a As Double = 0.0
   Dim b As Double = 0.0
   mg_json_get_num(r->frame, "$.params[0]", @a)
   mg_json_get_num(r->frame, "$.params[1]", @b)
   mg_rpc_ok(r, "%g", a * b)
End Sub

Private Sub fn cdecl(ByVal c As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
If ev = MG_EV_OPEN Then
   
 ElseIf ev = MG_EV_WS_OPEN Then
      c->data_[0] = Asc("W")
 ElseIf ev = MG_EV_HTTP_MSG Then
      Dim hm As mg_http_message Ptr = CPtr(mg_http_message Ptr, ev_data)
      If mg_match(hm->uri, mg_str_s("/websocket"), NULL) Then
         mg_ws_upgrade(c, hm, NULL)
      Else
         Dim As mg_http_serve_opts opts 
         opts.root_dir = s_web_root
         mg_http_serve_dir(c, ev_data, @opts)
      End If
 ElseIf ev = MG_EV_WS_MSG Then
      Dim wm As mg_ws_message Ptr = CPtr(mg_ws_message Ptr, ev_data)
      Dim io As mg_iobuf  
      io.buf = 0
      io.size = 0
      io.len_ = 0
      io.align=512
      Dim r As mg_rpc_req 
      r.head = @s_rpc_head
      r.rpc = 0
      r.pfn = @mg_pfn_iobuf
      r.pfn_data = Cast(Any Ptr,@io)
      r.req_data = 0
      r.frame=wm->data_
   
      mg_rpc_process(@r)
      If io.buf Then
         mg_ws_send(c, CPtr(ZString Ptr, io.buf), io.len_, WEBSOCKET_OP_TEXT)
      End If
      mg_iobuf_free(@io)
 End If
End Sub

Private Sub timer_fn cdecl(ByVal arg As Any Ptr)
Dim mgr As mg_mgr Ptr = CPtr(mg_mgr Ptr, arg)
Dim As mg_connection Ptr c = mgr->conns
 While c <> NULL
    If (c->data_[0] <> Asc("W")) Then 
        c = c->next_
       Continue While 
    End If
    mg_ws_printf(c, WEBSOCKET_OP_TEXT,"{%m:%m,%m:[%d,%d,%d]}", MG_ESC(@"method"), MG_ESC(@"notification1"), MG_ESC(@"params"), 1,2,3)
     c = c->next_
 Wend
End Sub


   Dim mgr As mg_mgr
   mg_mgr_init(@mgr)
   mg_log_set(MG_LL_DEBUG)
   mg_timer_add(@mgr, 5000, MG_TIMER_REPEAT,Cast(Any Ptr, @timer_fn), @mgr)
   mg_rpc_add(@s_rpc_head, mg_str_s("sum"),Cast(Any Ptr,  @rpc_sum), NULL)
   mg_rpc_add(@s_rpc_head, mg_str_s("mul"), Cast(Any Ptr, @rpc_mul), NULL)
   mg_rpc_add(@s_rpc_head, mg_str_s("rpc.list"), Cast(Any Ptr, @mg_rpc_list), @s_rpc_head)
   printf(!"Starting WS listener on %s/websocket\n", s_listen_on)
   mg_http_listen(@mgr, s_listen_on, Cast(Any Ptr, @fn), NULL)
   While True
      mg_mgr_poll(@mgr, 1000)
   Wend
   mg_mgr_free(@mgr)
   mg_rpc_del(@s_rpc_head, NULL)
  Sleep
