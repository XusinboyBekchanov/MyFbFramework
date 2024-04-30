#include once "curl.bi"
#include "vbcompat.bi"
'https://www.freebasic.net/forum/viewtopic.php?p=274136&hilit=Curl#p274136
Type tCurlInfo
	curl As CURL Ptr
	ff As Integer
	totlen As Double
	dllen As Double
	timeout As Double = 3.0
	process As Boolean = False
	content As String
End Type
Dim Shared As tCurlInfo curlinfo
Declare Function download_curl(url As String, tout As Double = 10.0) As String
Declare Function write_callback_curl cdecl (buffer As Byte Ptr, size As Long, nitems As Long, info As tCurlInfo Ptr) As Integer

Function download_curl(url As String, tout As Double = 10.0) As String
	
	Dim As String dlurl, tmp
	Dim As Double timeout
	
	curlinfo.curl = curl_easy_init()
	If curlinfo.curl = 0 Then
		Print "ERROR"
		Return ""
	End If
 
	'' set url and callback
	'curl_easy_setopt(curlinfo.curl, CURLOPT_SSL_VERIFYPEER, 1)
	curl_easy_setopt(curlinfo.curl, CURLOPT_CAINFO, "curl-ca-bundle.crt")
	curl_easy_setopt(curlinfo.curl, CURLOPT_URL, url)
	curl_easy_setopt(curlinfo.curl, CURLOPT_WRITEDATA, @curlinfo)
	curl_easy_setopt(curlinfo.curl, CURLOPT_WRITEFUNCTION, @write_callback_curl)
	curl_easy_setopt(curlinfo.curl, CURLOPT_FOLLOWLOCATION, 1)
	curlinfo.timeout = tout
	curl_easy_perform(curlinfo.curl) 'execute..
	curl_easy_cleanup(curlinfo.curl) 'shutdown
	
	'Close curlinfo.ff
	Print curlinfo.content
	Return curlinfo.content
End Function

Function write_callback_curl cdecl (buffer As Byte Ptr, size As Long, nitems As Long, info As tCurlInfo Ptr) As Integer
	Dim As Integer x, bytes = size * nitems
	Dim As Double tot_len, dl_len, timeout = Timer + info->timeout
	
	curl_easy_getinfo(info->curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD, @info->totlen )
	curl_easy_getinfo(info->curl, CURLINFO_SIZE_DOWNLOAD, @info->dllen )
	
	If info->ff Then
		If info->totlen = -1 Then
			Print Format(info->dllen / 1024 / 1024, "#.##"); " MB (ESC to terminate)"
		Else
			Print Int(100 * info->dllen / info->totlen); "% of "; Format(info->totlen / 1024 / 1024, "#.##"); " MB (ESC to terminate)"
		End If
		Locate CsrLin - 1,1,0
		If info->totlen = info->dllen Then
			Print
		End If
		Put #info->ff, ,*buffer,bytes 'write downloaded bytes to file
	Else
		For x = 0 To bytes - 1
			info->content += Chr(buffer[x])
		Next
	End If
	
	If (Inkey = Chr(27)) Or (Timer > timeout) Then
		Print
		Return 0
	End If
	
	Return bytes
End Function

Dim As String content

content = download_curl("https://promo.betfair.com/betfairsp/prices/dwbfpricesukwin13072020.csv")
'content = download_curl("https://users.freebasic-portal.de/stw/builds/freebasic_manual.chm")
'Print "done" & content
Dim As Integer Fn = FreeFile
Open "freebasic_manual.chm" For Output As #Fn
Print #Fn, content;
Close #Fn
Sleep
