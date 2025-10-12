
#include once "inc/mongoose.bi"

'#ifndef __FB_64BIT__
'#libpath "win32"
'#else
'#libpath "win64"
'#endif
Dim Shared s_url As  ZString Ptr =@"ws://localhost:8000/websocket"

Private Sub fn(ByVal c As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
   If ev = MG_EV_OPEN Then
      c->is_hexdumping = 1
   ElseIf ev = MG_EV_ERROR Then
      Print *Cast(ZString Ptr, c->fd), *Cast(ZString Ptr, ev_data)
   ElseIf ev = MG_EV_WS_OPEN Then
      mg_ws_send(c, Cast(Any Ptr,@"hello"), 5, WEBSOCKET_OP_TEXT)
   ElseIf ev = MG_EV_WS_MSG Then
      Dim wm As mg_ws_message Ptr = CPtr(mg_ws_message Ptr, ev_data)
      printf(!"GOT ECHO REPLY: [%.*s]\n", CLng(wm->data_.len_), wm->data_.buf)
   End If
   If ((ev = MG_EV_ERROR) OrElse (ev = MG_EV_CLOSE)) OrElse (ev = MG_EV_WS_MSG) Then
      *CPtr(BOOL Ptr, @c->fn_data) = True
    
   End If
End Sub

   Dim mgr As mg_mgr
   Dim As  BOOL done = False
   Dim c As mg_connection Ptr
   mg_mgr_init(@mgr)
   mg_log_set(MG_LL_DEBUG)
   c = mg_ws_connect(@mgr, s_url,Cast(Any Ptr, @fn), @done, NULL)
   While c AndAlso (done = False)
      mg_mgr_poll(@mgr, 1000)
   Wend
   mg_mgr_free(@mgr)
Sleep
