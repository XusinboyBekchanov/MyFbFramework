
#include once "inc/mongoose.bi"
#include once "crt/stdlib.bi"
#include Once "utf_conv.bi"

'#ifndef __FB_64BIT__
'#libpath "win32"
'#else
'#libpath "win64"
'#endif
Declare Function MultiByteToWideChar Lib "Kernel32" Alias "MultiByteToWideChar"(ByVal CodePage As ULong, ByVal dwFlags As ULong, ByVal lpMultiByteStr As Byte Ptr, ByVal cbMultiByte As Long, ByVal lpWideCharStr As Wstring Ptr, ByVal cchWideChar As Long) As Long
Declare Function WideCharToMultiByte  Lib "Kernel32" Alias "WideCharToMultiByte"(ByVal CodePage As ULong, ByVal dwFlags As ULong, ByVal lpWideCharStr As UByte Ptr, ByVal cchWideChar As Long, ByVal lpMultiByteStr As ZString Ptr, ByVal cbMultiByte As Long, ByVal lpDefaultChar As Byte Ptr, ByVal lpUsedDefaultChar As Long Ptr) As Long
CONST CP_UTF8 = 65001
Function utf8tostr(Utf8str As String, CodePage As UINTeger = 0) As String
   Dim eLen As Integer = Len(Utf8str)
   If eLen = 0 Then Return ""
   Dim wsStr() As UByte ' = CAllocate(eLen * 2 + 2)  '+2 是为了最后空出2个00 为宽字符结尾
   ReDim wsStr(eLen * 2 + 2)
   UTFToWChar(UTF_ENCOD_UTF8, StrPtr(Utf8str), Cast(Wstring Ptr, @wsStr(0)), @eLen)
   Dim ZStr as String
   ZStr = String(eLen * 2 + 2, 0)
   Dim ZStrLen As Integer = WideCharToMultiByte(CodePage, 0, Cast(UByte Ptr, @wsStr(0)), eLen, StrPtr(ZStr), eLen * 2 + 2, NULL, NULL)
   If ZStrLen Then Function = Left(ZStr, ZStrLen)
End Function

'Dim Shared s_url As  ZString Ptr = @"http://info.cern.ch/"
Dim Shared s_url As  ZString Ptr = @"https://www.baidu.com"
Dim Shared s_post_data As  ZString Ptr = NULL
Dim Shared s_timeout_ms As  ULongInt = 1500

Private Sub fn(ByVal c As mg_connection Ptr, ByVal ev As Long, ByVal ev_data As Any Ptr)
   If ev = MG_EV_OPEN Then
   *CPtr(ULongInt Ptr, @c->data_)= mg_millis() + s_timeout_ms  
   ElseIf ev = MG_EV_POLL Then
      If ((mg_millis() > (*CPtr(ULongInt Ptr, @c->data_))) AndAlso (c->is_connecting OrElse c->is_resolving)) Then
         Print "Connect timeout"
      End If
   ElseIf ev = MG_EV_CONNECT Then
      Dim host As mg_str = mg_url_host(s_url)
      If mg_url_is_ssl(s_url) Then
         Dim opts As mg_tls_opts
         opts.ca = mg_unpacked(Cast(ZString Ptr,@"/certs/ca.pem"))
         opts.name_ = mg_url_host(s_url)
         mg_tls_init(c, @opts)
      End If
      Dim content_length As Long = IIf(s_post_data, strlen(s_post_data), 0) 
    
      mg_printf(c,@!"%s %s HTTP/1.0\r\nHost: %.*s\r\nContent-Type: octet-stream\r\nContent-Length: %d\r\n\r\n", IIf(s_post_data, "POST", "GET"), mg_url_uri(s_url), CLng(host.len_), host.buf, content_length)
      mg_send(c, Cast(Any Ptr, s_post_data), content_length)
   ElseIf ev = MG_EV_HTTP_MSG Then
      Dim hm As mg_http_message Ptr =CPtr(mg_http_message Ptr, ev_data)
     printf("%.*s", CLng(hm->message.len_), utf8tostr(*hm->message.buf))
     c->is_draining = 1
      *CPtr(bool Ptr, @c->fn_data) = True
   ElseIf ev = MG_EV_ERROR Then
      *CPtr(BOOL Ptr, @c->fn_data) = True
   End If
End Sub

   Dim log_level As  ZString Ptr = getenv("LOG_LEVEL")
   If log_level = NULL Then
      log_level = @"4"
   End If
   Dim mgr As mg_mgr 
   Dim As Bool done =0
   mg_log_set(MG_LL_DEBUG)
   mg_mgr_init(@mgr)  
   mg_http_connect(@mgr, s_url, Cast(Any Ptr, @fn), @done)
   While done = 0
    mg_mgr_poll(@mgr, 50)   
 Wend
    mg_mgr_free(@mgr)
 Sleep
