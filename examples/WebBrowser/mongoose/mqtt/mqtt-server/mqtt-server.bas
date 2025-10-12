
#include once "inc/mongoose.bi"
#include once "crt/stdlib.bi"

'#ifndef __FB_64BIT__
'#libpath "../../win32"
'#else
'#libpath "../../win64"
'#endif

dim shared s_listen_on as const zstring ptr = @"mqtt://0.0.0.0:1883"

type sub_
   next_ as sub_ ptr
   c as mg_connection ptr
   topic as mg_str
   qos as ubyte
end type

dim shared s_subs as sub_ ptr = NULL
'dim shared s_signo as long

'private sub signal_handler(byval signo as long)
'   s_signo = signo
'end sub
Function CtrlHandler(dwCtrlType As ulong) As long
   If dwCtrlType = 0 Then  
      function= 1
       end
    End If
    Return 0
End Function
private function mg_mqtt_next_topic(byval msg as mg_mqtt_message ptr, byval topic as mg_str ptr, byval qos as ubyte ptr, byval pos_ as uinteger) as uinteger
   dim buf as ubyte ptr = cptr(ubyte ptr, msg->dgram.buf) + pos_
   dim new_pos as uinteger
   if pos_ >= msg->dgram.len_ then
      return 0
   end if
   topic->len_ = cuint(culng(culng(buf[0]) shl 8) or buf[1])
   topic->buf = cptr(zstring ptr, buf) + 2
   new_pos = ((pos_ + 2) + topic->len_) + iif(qos = NULL, 0, 1)
   if cuint(new_pos) > msg->dgram.len_ then
      return 0
   end if
   if qos <> NULL then
      (*qos) = buf[(2 + topic->len_)]
   end if
   return new_pos
end function

private function mg_mqtt_next_sub(byval msg as mg_mqtt_message ptr, byval topic as mg_str ptr, byval qos as ubyte ptr, byval pos_ as uinteger) as uinteger
   dim tmp as ubyte
   return mg_mqtt_next_topic(msg, topic, iif(qos = NULL, @tmp, qos), pos_)
end function

#define mg_mqtt_next_unsub(msg, topic, pos_) cuint(mg_mqtt_next_topic((msg), (topic), NULL, (pos_)))

private sub fn cdecl(byval c as mg_connection ptr, byval ev as long, byval ev_data as any ptr)
   if ev = MG_EV_MQTT_CMD then
      dim mm as mg_mqtt_message ptr = cptr(mg_mqtt_message ptr, ev_data)
      MG_DEBUG("cmd %d qos %d", mm->cmd, mm->qos)
        
Select Case mm->cmd
    Case MQTT_CMD_CONNECT
        If mm->dgram.len_ < 9 Then
            mg_error(c, "Malformed MQTT frame")
        ElseIf mm->dgram.buf[8] <> 4 Then
            mg_error(c, "Unsupported MQTT version " & mm->dgram.buf[8])
        Else
            Dim As UByte response(0 To 1) = {0, 0}
            mg_mqtt_send_header(c, MQTT_CMD_CONNACK, 0, SizeOf(response))
            mg_send(c, @response(0), SizeOf(response))
        End If

    Case MQTT_CMD_SUBSCRIBE
        Dim As Integer pos_ = 4
        Dim As UByte qos, resp(0 To 255)
        Dim As mg_str topic
        Dim As Integer num_topics = 0
        pos_ = mg_mqtt_next_sub(mm, @topic, @qos, pos_)
        While pos_ > 0
            Dim As sub_ Ptr sub_ptr = Callocate(1, SizeOf(sub_))
            sub_ptr->c = c
            sub_ptr->topic = mg_strdup(topic)
            sub_ptr->qos = qos
            LIST_ADD_HEAD(sub_, @s_subs, sub_ptr)
            MG_INFO("SUB %p [%.*s]", c->fd, clng(sub_ptr->topic.len_), sub_ptr->topic.buf)
            'MG_INFO("SUB " & c->fd & " [" & Left(sub_ptr->topic.buf, sub_ptr->topic.len_) & "]")
           
            For i As Integer = 0 To sub_ptr->topic.len_ - 1
                If sub_ptr->topic.buf[i] = Asc("+") Then
                    sub_ptr->topic.buf[i] = Asc("*")
                End If
            Next
            
            resp(num_topics) = qos
            num_topics += 1
        Wend
        
        mg_mqtt_send_header(c, MQTT_CMD_SUBACK, 0, num_topics + 2)
        Dim As UShort id = mg_htons(mm->id)
        mg_send(c, @id, 2)
        mg_send(c, @resp(0), num_topics)

    Case MQTT_CMD_PUBLISH
        MG_INFO("PUB %p [%.*s] -> [%.*s]", c->fd, clng( mm->data_.len_),mm->data_.buf, clng( mm->topic.len_), mm->topic.buf)
        Dim As sub_ Ptr sub_ptr = s_subs
        While sub_ptr <> NULL
            If mg_match(mm->topic, sub_ptr->topic, NULL) Then
                Dim As mg_mqtt_opts pub_opts
                memset(@pub_opts, 0, SizeOf(pub_opts))
                pub_opts.topic = mm->topic
                pub_opts.message = mm->data_
                pub_opts.qos = 1
                pub_opts.retain = False
                mg_mqtt_pub(sub_ptr->c, @pub_opts)
            End If
            sub_ptr = sub_ptr->next_
        Wend

    Case MQTT_CMD_PINGREQ
        MG_INFO("PINGREQ " & c->fd & " -> PINGRESP")
        mg_mqtt_send_header(c, MQTT_CMD_PINGRESP, 0, 0)
End Select
elseif ev = MG_EV_ACCEPT then
    
   elseif ev = MG_EV_CLOSE then
      Dim As sub_ Ptr next_
      Dim As sub_ Ptr sub_ptr = s_subs
While sub_ptr <> NULL
    next_ = sub_ptr->next_
    If c <> sub_ptr->c Then
        sub_ptr = next_
        Continue While
    End If
    MG_INFO("UNSUB %p [%.*s]", c->fd,  clng(sub_ptr->topic.len_), sub_ptr->topic.buf)
    LIST_DELETE(sub_, @s_subs, sub_ptr)
    sub_ptr = next_
Wend
      end if
end sub

declare function SetConsoleCtrlHandler stdcall lib "Kernel32" alias "SetConsoleCtrlHandler"(byval HandlerRoutine as ANY PTR, byval Add_ as LONG) as LONG
dim mgr as mg_mgr
mg_mgr_init(@mgr)
MG_INFO("Starting on %s", s_listen_on)
mg_mqtt_listen(@mgr, s_listen_on,cast(any ptr, @fn), NULL)
   dim as long result = SetConsoleCtrlHandler(@CtrlHandler, 1)
   while result <> 0
      mg_mgr_poll(@mgr, 1000)
   wend
mg_mgr_free(@mgr)
sleep