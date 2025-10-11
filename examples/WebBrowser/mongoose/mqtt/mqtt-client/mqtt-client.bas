#include once "inc/mongoose.bi"
'#ifndef __FB_64BIT__
'#libpath "../../win32"
'#else
'#libpath "../../win64"
'#endif
dim shared s_url as  zstring ptr = @"mqtt://broker.hivemq.com:1883"
dim shared s_sub_topic as  zstring ptr = @"mg/+/test"
dim shared s_pub_topic as zstring ptr = @"mg/clnt/test"
dim shared s_qos as long = 1
dim shared s_conn as mg_connection ptr
'dim shared s_signo as long
Function CtrlHandler(dwCtrlType As ulong) As long
   If dwCtrlType = 0 Then  
      function= 1
       end
    End If
    Return 0
End Function
'private sub signal_handler(byval signo as long)
'   s_signo = signo
'end sub

private sub fn cdecl(byval c as mg_connection ptr, byval ev as long, byval ev_data as any ptr)
   if ev = MG_EV_OPEN then
      MG_INFO(@"%lu CREATED", c->id)
   elseif ev = MG_EV_CONNECT then
      if mg_url_is_ssl(s_url) then
             Dim opts As mg_tls_opts
            opts.ca = mg_unpacked(Cast(ZString Ptr,@"/certs/ca.pem"))
            opts.name_ = mg_url_host(s_url)
         mg_tls_init(c, @opts)
      end if
   elseif ev = MG_EV_ERROR then
         MG_ERROR_("%lu ERROR %s", c->id, cptr(zstring ptr, ev_data))
   elseif ev = MG_EV_MQTT_OPEN then
      dim subt as mg_str = mg_str_s(s_sub_topic)
      dim pubt as mg_str = mg_str_s(s_pub_topic)
      dim data_ as mg_str = mg_str_s("hello")
      MG_INFO("%lu CONNECTED to %s", c->id, s_url)
      dim sub_opts as mg_mqtt_opts
      memset(@sub_opts, 0, sizeof(sub_opts))
      sub_opts.topic = subt
      sub_opts.qos = s_qos
      mg_mqtt_sub(c, @sub_opts)
       MG_INFO("%lu SUBSCRIBED to %.*s", c->id, clng(subt.len_), subt.buf) 
      dim pub_opts as mg_mqtt_opts
      memset(@pub_opts, 0, sizeof(pub_opts))
      pub_opts.topic = pubt
      pub_opts.message = data_
      pub_opts.qos = s_qos
      pub_opts.retain = false
      mg_mqtt_pub(c, @pub_opts)
       MG_INFO("%lu PUBLISHED %.*s -> %.*s", c->id, clng(data_.len_), data_.buf, clng(pubt.len_), pubt.buf)
   elseif ev = MG_EV_MQTT_MSG then
      dim mm as mg_mqtt_message ptr = cptr(mg_mqtt_message ptr, ev_data)
       MG_INFO("%lu RECEIVED %.*s <- %.*s", c->id, clng(mm->data_.len_), mm->data_.buf, clng(mm->topic.len_), mm->topic.buf)      
   elseif ev = MG_EV_CLOSE then
        MG_INFO("%lu CLOSED", c->id)
      s_conn = NULL
   end if
end sub

private sub timer_fn cdecl(byval arg as any ptr)
   dim mgr as mg_mgr ptr = cptr(mg_mgr ptr, arg)
    Dim opts As mg_mqtt_opts
    opts.clean=true
    opts.qos=s_qos
    opts.topic = mg_str_s(s_pub_topic)
    opts.version = 4
    opts .message = mg_str_s("bye")
      
   if s_conn = NULL then
      s_conn = mg_mqtt_connect(mgr, s_url, @opts, cast(any ptr,@fn), NULL)
   end if
end sub

declare function SetConsoleCtrlHandler stdcall lib "Kernel32" alias "SetConsoleCtrlHandler"(byval HandlerRoutine as ANY PTR, byval Add_ as LONG) as LONG

   dim mgr as mg_mgr
   
For i As Integer = 1 To __FB_ARGC__ - 1
    If StrCmp(Command(i), "-u") = 0 AndAlso (i < __FB_ARGC__ - 1) Then
        i += 1
        *s_url =Command(i)
    ElseIf StrCmp(Command(i), "-p") = 0 AndAlso i < __FB_ARGC__ - 1 Then
        i += 1
        *s_pub_topic = Command(i)
    ElseIf StrCmp(Command(i), "-s") = 0 AndAlso i < __FB_ARGC__ - 1 Then
        i += 1
        *s_sub_topic = Command(i)
    ElseIf StrCmp(Command(i), "-v") = 0 AndAlso i < __FB_ARGC__ - 1 Then
        i += 1
        mg_log_level = ValInt(Command(i))
    Else
       scope 
          if (MG_LL_ERROR <= mg_log_level) then 
             mg_log_prefix(MG_LL_ERROR, __FILE__, __LINE__, __function__)
             mg_log ("Unknown option: %s. Usage:", Command(i))
            end if
          end scope
          scope
             if (MG_LL_ERROR <= mg_log_level) then 
                mg_log_prefix((MG_LL_ERROR), __FILE__, __LINE__, __function__)
                mg_log("%s [-u mqtts://SERVER:PORT] [-p PUB_TOPIC] [-s SUB_TOPIC] " "[-v DEBUG_LEVEL]", Command(0), Command(i))
             end if
            end scope
        End 1
    End If
Next
   mg_mgr_init(@mgr)
   mg_timer_add(@mgr, 3000, MG_TIMER_REPEAT or MG_TIMER_RUN_NOW, cast(any ptr, @timer_fn), @mgr)
   dim as long result = SetConsoleCtrlHandler(@CtrlHandler, 1)
   while result <> 0
      mg_mgr_poll(@mgr, 1000)
   wend
   mg_mgr_free(@mgr)
   sleep
