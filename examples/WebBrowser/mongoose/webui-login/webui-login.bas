
#include once "inc/mongoose.bi"
dim shared s_listening_url as const zstring ptr = @"http://0.0.0.0:8000"

type user
   name As Const ZString Ptr
   pass As Const ZString Ptr
   token As Const ZString Ptr
End Type

private function getuser(byval hm as mg_http_message ptr) as user ptr
   Static users(0 To ...) As user = {(@"admin", @"pass0", @"admin_token"), (@"user1", @"pass1", @"user1_token"), (@"user2", @"pass2", @"user2_token"), (NULL, NULL, NULL)}
   Dim user_ As ZString * 256
   Dim pass_ As ZString * 256
   Dim u As user Ptr
   mg_http_creds(hm, user_, SizeOf(user_), pass_, SizeOf(pass_))
   If (user_[0] <> Asc(!"\0")) AndAlso (pass_[0] <> Asc(!"\0")) Then
        u=@users(0)
         while u->name <> NULL
         If (strcmp(user_, u->Name) = 0) AndAlso (strcmp(pass_, u->pass) = 0) Then Return u
         u+=1
         wend
     
   ElseIf user_[0] = Asc(!"\0") Then
         u=@users(0)
         while u->name <> NULL
         If (strcmp(pass_, u->token) = 0) Then Return u
         u+=1
         wend
   end if
   return NULL
end function

private sub fn(byval c as mg_connection ptr, byval ev as long, byval ev_data as any ptr)
   if ev = MG_EV_HTTP_MSG then
      dim hm as mg_http_message ptr = cptr(mg_http_message ptr, ev_data)
      dim u as user ptr = getuser(hm)
      if (u = NULL) andalso mg_match(hm->uri, mg_str_s("/api/#"), NULL) then
         mg_http_reply(c, 403, "", !"Denied\n")
      elseif mg_match(hm->uri, mg_str_s("/api/data"), NULL) then
         mg_http_reply(c, 200, !"Content-Type: application/json\r\n", !"{%m:%m,%m:%m}\n", MG_ESC( "text"), MG_ESC("Hello!"), MG_ESC("data"), MG_ESC("somedata"))
      elseif mg_match(hm->uri, mg_str_s("/api/login"), NULL) then
         mg_http_reply(c, 200, !"Content-Type: application/json\r\n", !"{%m:%m,%m:%m}\n", MG_ESC("user"), MG_ESC(u->name), MG_ESC("token"), MG_ESC(u->token))
      else
             Dim As mg_http_serve_opts opts 
             opts.root_dir =@"web_root"
            mg_http_serve_dir(c, ev_data, @opts)
  
      end if
   end if
end sub


   dim mgr as mg_mgr
   mg_log_set(MG_LL_DEBUG)
   mg_mgr_init(@mgr)
   mg_http_listen(@mgr, s_listening_url, cast(any ptr,@fn), @mgr)
   while mgr.conns <> NULL
      mg_mgr_poll(@mgr, 500)
   Wend
   mg_mgr_free(@mgr)
   sleep