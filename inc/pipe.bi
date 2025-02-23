'################################################################################
'#  pipe.bi                                                                     #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Based on: the code posted on the freeBasic forum                            #
'#  See also:                                                                  #
'#   http://www.freebasic-portal.de/code-beispiele/kleine-helferlein/           #
'#    bipipe-bi-fuer-win-linux-299.html                                         #
'#                                                                              #
'################################################################################

#ifndef __USE_WINAPI__
	#define __USE_WINAPI__
#endif

#if defined(__USE_WINAPI__)
	#include once "windows.bi"
#elseif defined(__USE_GTK__)
	#include once "crt/linux/unistd.bi"
	Declare Function ioctl Alias "ioctl" (fd As Integer, request As ULong, ...) As Integer
	#define FIONREAD &h541B
	#define SW_NORMAL 0
#endif

Type BiPipe
Private:
	#if defined(__USE_WINAPI__)
		hProcessHandle As HANDLE
		hWritePipe As HANDLE
		hReadPipe As HANDLE
	#elseif defined(__USE_GTK__)
		pipeStdin As Long
		pipeStdout As Long
	#endif
Public:
	#if defined(__USE_WINAPI__)
		Declare Constructor (prgName As String, showmode As Short = SW_NORMAL)
	#elseif defined(__USE_GTK__)
		Declare Constructor (prgName As String)
	#endif
	Declare Destructor ()
	Declare Function write (text As String) As Integer
	Declare Function read (timeout As UInteger = 100) As String
	#if defined(__USE_WINAPI__)
		Declare Function readLine (separator As String = "a" & Chr(13, 10), timeout As UInteger = 100) As String
	#endif
End Type

#if defined(__USE_WINAPI__)
	Constructor BiPipe(prgName As String, showmode As Short = SW_NORMAL)
		Dim As STARTUPINFO si
		Dim As PROCESS_INFORMATION pi
		Dim As SECURITY_ATTRIBUTES sa
		Dim As HANDLE hReadPipe, hWritePipe, hReadChildPipe, hWriteChildPipe
		'set security attributes
		sa.nLength = SizeOf(SECURITY_ATTRIBUTES)
		sa.lpSecurityDescriptor = NULL 'use default descriptor
		sa.bInheritHandle = True
		'create one pipe for each direction
		CreatePipe(@hReadChildPipe,@hWritePipe,@sa,0) 'parent to child
		CreatePipe(@hReadPipe,@hWriteChildPipe,@sa,0) 'child to parent
		GetStartupInfo(@si)
		si.dwFlags = STARTF_USESTDHANDLES Or STARTF_USESHOWWINDOW
		si.wShowWindow = showmode 'appearance of child process window
		si.hStdOutput  = hWriteChildPipe
		si.hStdError   = hWriteChildPipe
		si.hStdInput   = hReadChildPipe
		CreateProcess(0,prgName,0,0,True,CREATE_NEW_CONSOLE,0,0,@si,@pi)
		CloseHandle(hWriteChildPipe)
		CloseHandle(hReadChildPipe)
		This.hProcessHandle = pi.hProcess 'handle to child process
		This.hWritePipe = hWritePipe
		This.hReadPipe = hReadPipe
	End Constructor
	
	Destructor BiPipe ()
		TerminateProcess(hProcessHandle, 0)
		CloseHandle(hWritePipe)
		CloseHandle(hReadPipe)
	End Destructor
	
	Function BiPipe.write (text As String) As Integer
		Dim bytesWritten As Long
		WriteFile(hWritePipe, StrPtr(text), Len(text), @bytesWritten, 0)
		Return bytesWritten
	End Function
	
	Function BiPipe.read (timeout As UInteger = 100) As String
		' Returns the whole pipe content until the pipe is empty or timeout occurs.
		' Timeout default is 100ms to prevent a deadlock.
		Dim As Long iNumberOfBytesRead, iTotalBytesAvail, iBytesLeftThisMessage
		Dim As String buffer, retText
		Dim As Double tout = Timer + Cast(Double,timeout) / 1000
		Do
			PeekNamedPipe(hReadPipe, 0, 0, 0, @iTotalBytesAvail, 0)
			If iTotalBytesAvail Then
				buffer = String(iTotalBytesAvail,Chr(0))
				ReadFile(hReadPipe, StrPtr(buffer), Len(buffer), ByVal @iNumberOfBytesRead, ByVal 0)
				retText &= buffer
			ElseIf Len(retText) Then
				Exit Do
			End If
		Loop Until Timer > tout
		Return retText
	End Function
	
	Function BiPipe.readLine (separator As String = "a" & Chr(13,10), timeout As UInteger = 100) As String
		' Returns the pipe content till the first separator if any, or otherwise the whole pipe
		' content on timeout. Timeout default is 100ms to prevent a deadlock.
		Dim As Long iNumberOfBytesRead, iTotalBytesAvail, iBytesLeftThisMessage, endPtr
		Dim As String buffer, retText, mode
		Dim As Double tout = Timer + Cast(Double,timeout) / 1000
		mode = LCase(Left(separator, 1))
		separator = Mid(separator, 2)
		Do
			PeekNamedPipe(hReadPipe, 0, 0, 0, ByVal @iTotalBytesAvail, ByVal 0)
			If iTotalBytesAvail Then
				buffer = String(iTotalBytesAvail,Chr(0))
				PeekNamedPipe(hReadPipe,StrPtr(buffer),Len(buffer),@iNumberOfBytesRead, _
				@iTotalBytesAvail,@iBytesLeftThisMessage) 'copy pipe content to buffer
				Select Case mode
				Case "a" 'any
					endPtr = InStr(buffer, Any separator) 'look for line end sign
				Case "e" 'exact
					endPtr = InStr(buffer, separator) 'look for line end sign
				End Select
				If endPtr Then 'return pipe content till line end
					Select Case mode
					Case "a"
						Do While (InStr(separator,Chr(buffer[endPtr - 1]))) And (endPtr < Len(buffer))
							endPtr += 1
						Loop
						endPtr -= 1
					Case "e"
						endPtr += Len(separator)
					End Select
					retText = Left(buffer,endPtr)
					ReadFile(hReadPipe,StrPtr(buffer),endPtr,@iNumberOfBytesRead,0) 'remove read bytes from pipe
					Select Case mode
					Case "a"
						Return RTrim(retText,Any separator) 'remove line end sign from returned string
					Case "e"
						Return Left(retText,Len(retText) - Len(separator))
					End Select
				End If
			End If
		Loop Until Timer > tout
		If iTotalBytesAvail Then 'return all pipe content
			buffer = String(iTotalBytesAvail,Chr(0))
			ReadFile(hReadPipe,StrPtr(buffer),Len(buffer),@iNumberOfBytesRead,0)
			Return buffer
		End If
		Return ""
	End Function
#elseif defined(__USE_GTK__)
	Constructor BiPipe (prgName As String)
		Dim pipeStdin(0 To 1) As Long
		Dim pipeStdout(0 To 1) As Long
		
		pipe_(@pipeStdin(0))
		pipe_(@pipeStdout(0))
		
		If fork() = 0 Then
			close_(pipeStdin(1))
			close_(pipeStdout(0))
			
			dup2(pipeStdin(0), 0)
			dup2(pipeStdout(1), 1)
			
			execl(StrPtr("/bin/sh"), StrPtr("sh"), StrPtr("-c"), StrPtr(prgName), Cast(UByte Ptr, 0))
			_exit(1)
		End If
		
		This.pipeStdin = pipeStdin(1)
		This.pipeStdout = pipeStdout(0)
		
		close_(pipeStdin(0))
		close_(pipeStdout(1))
	End Constructor
	
	Destructor BiPipe ()
		close_(pipeStdin)
		close_(pipeStdout)
	End Destructor
	
	Function BiPipe.write (text As String) As Integer
		Return write_(pipeStdin, StrPtr(text), Len(text))
	End Function
	
	Function BiPipe.read (timeout As UInteger = 100) As String
		'returns the whole pipe content until the pipe is empty or timeout occurs.
		' timeout default is 100ms to prevent a deadlock
		Dim As Integer iNumberOfBytesRead, iTotalBytesAvail, iBytesLeftThisMessage
		Dim As String buffer, retText
		Dim As Double tout = Timer + Cast(Double,timeout) / 1000
		Do
			ioctl(pipeStdout, FIONREAD, @iTotalBytesAvail)
			If iTotalBytesAvail Then
				buffer = String(iTotalBytesAvail,Chr(0))
				read_(pipeStdout, StrPtr(buffer), Len(buffer))
				retText &= buffer
			ElseIf Len(retText) Then
				Exit Do
			End If
		Loop Until Timer > tout
		Return retText
	End Function
#endif

Function bipOpen(PrgName As String, showmode As Short = SW_NORMAL) As BiPipe Ptr
	#if defined(__USE_WINAPI__)
		Return New BiPipe(PrgName, showmode)
	#elseif defined(__USE_GTK__)
		Return New BiPipe(PrgName)
	#endif
End Function

Sub bipClose(ByRef handles As BiPipe Ptr)
	Delete handles
	handles = 0
End Sub

Function bipWrite(handles As BiPipe Ptr, text As String) As Integer
	Return handles->write(text)
End Function

Function bipRead(handles As BiPipe Ptr, timeout As UInteger = 100) As String
	Return handles->read(timeout)
End Function

Function bipReadLine(handles As BiPipe Ptr, separator As String = "a" & Chr(13, 10), timeout As UInteger = 100) As String
	#if defined(__USE_WINAPI__)
		Return handles->readLine(separator, timeout)
	#elseif defined(__USE_GTK__)
		#print __FUNCTION__ Function Not implemented
		Return ""
	#endif
End Function
