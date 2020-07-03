'###############################################################################
'#  IniFile.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TIniFile.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "IniFile.bi"
Property IniFile.File ByRef As WString
	Return WGet(FFile)
End Property

Property IniFile.File(ByRef Value As WString)
	WLet FFile, Value
End Property

Property IniFile.SectionCount As Integer
	FSectionCount = 0
	Dim As WString Ptr s
	For i As Integer = 0 To FLines.Count -1
		s = @FLines.Item(i)
		If s[0] <> "" Then If s[0] <> Asc(";") Then If s[0] = Asc("[") Then FSectionCount += 1
	Next i
	Return FSectionCount
End Property

Property IniFile.SectionCount(Value As Integer)
End Property

Function IniFile.SectionExists(ByRef Section As WString) As Integer
	Dim As WString Ptr s
	For i As Integer = 0 To FLines.Count -1
		s = @FLines.Item(i)
		If *s <> "" Then
			If s[0] <> Asc(";") Then
				If s[0] = Asc("[") Then
					If UCase(Section) = UCase(Trim(Trim(*s,"["),"]")) Then Return i
				End If
			End If
		End If
	Next i
	Return -1
End Function

Function IniFile.KeyExists(ByRef Section As WString, ByRef Key As WString) As Integer
	Dim As Integer x
	Dim As WString Ptr s
	x = SectionExists(Section)
	If x <> -1 Then
		For i As Integer = x + 1 To FLines.Count -1
			s = @FLines.Item(i)
			If *s <> "" Then
				If s[0] <> Asc(";") Then
					If s[0] = Asc("[") Then Return -1
					If s[0] <> Asc("[") Then If UCase(Key) = UCase(Trim(Mid(*s, 1, InStr(*s, "=") - 1))) Then Return i
				End If
			End If
		Next i
	End If
	Return -1
End Function
'David Change
Function IniFile.KeyRemove(ByRef Section As WString, ByRef Key As WString) As Boolean
	Dim As Integer x
	Dim As WString Ptr s
	x = SectionExists(Section)
	If x <> -1 Then
		For i As Integer = x + 1 To FLines.Count -1
			s = @FLines.Item(i)
			If *s <> "" Then
				If s[0] <> Asc(";") Then
					If s[0] = Asc("[") Then Return False
					If s[0] <> Asc("[") AndAlso UCase(Key) = UCase(Trim(Mid(*s, 1, InStr(*s, "=") - 1))) Then
						FLines.Remove i
						Return True
					End If
				End If
			End If
		Next i
	End If
	Return False
End Function
Sub IniFile.Load(ByRef FileName As WString = "")

	Dim Result As Integer=-1 'David Change
	If FileName <> "" Then WLet FFile, FileName
	FLines.Clear
	Dim As Integer Fn =FreeFile
	'If Open(FileName For Input Encoding "utf-8" As #Fn) = 0 Then 'Line Input Not working fine in Ver 1.07 David Change
	'If Open(File For Binary Access Read As #ff) = 0 Then 'Line Input working fine in this mode
	Result = Open(*FFile For Input Encoding "utf-8" As #Fn)
	If Result <> 0 Then Result = Open(*FFile For Input Encoding "utf-16" As #Fn)
	If Result <> 0 Then Result = Open(*FFile For Input Encoding "utf-32" As #Fn)
	If Result <> 0 Then Result = Open(*FFile For Input As #Fn)
	If Result = 0 Then
		Dim Buff As WString * 1024 'David Change for V1.07 Line Input not working fine
		While Not EOF(Fn)
			Line Input #Fn, Buff
			If Buff <> "" Then FLines.Add Buff
		Wend
		Close #Fn
	End If
End Sub

Sub IniFile.Update
	'If Open(File For Binary Access Write As #1) = 0 Then
	Dim As Integer Fn =FreeFile
	If Open(*FFile For Output Encoding "utf-8" As #Fn) =0 Then
		For i As Integer = 0 To FLines.Count -1
			Print #Fn, FLines.Item(i)
		Next i
		Close #Fn
	End If
End Sub

Sub IniFile.WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
	Dim As Integer SecIndex, KeyIndex
	SecIndex = SectionExists(Section)
	If SecIndex <> -1 Then
		KeyIndex = KeyExists(Section,Key)
		If KeyIndex <> -1 Then
			FLines.Item(KeyIndex) = Key & "=" & Str(Value)
			Update
		Else
			If SecIndex < FLines.Count -1 Then
				Dim As Integer LastIndex
				For i As Integer = SecIndex +1 To FLines.Count-1
					Dim As WString Ptr s
					s = @FLines.Item(i)
					If *s <> "" Then
						LastIndex = i
						If s[0] = Asc("[") Then Exit For
					End If
				Next i
				If LastIndex = FLines.Count -1 Then
					FLines.Add Key & "=" & WStr(Value)
					Update
				Else
					FLines.Insert LastIndex, Key & "=" & WStr(Value)
				End If
				Update
			Else
				FLines.Add Key & "=" & WStr(Value)
				Update
			End If
		End If
	Else
		FLines.Add "[" & Section & "]"
		FLines.Add Key & "=" & WStr(Value)
		Update
	End If
End Sub

Sub IniFile.WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
	Dim As Integer SecIndex,KeyIndex
	SecIndex = SectionExists(Section)
	If SecIndex <> -1 Then
		KeyIndex = KeyExists(Section,Key)
		If KeyIndex <> -1 Then
			FLines.Item(KeyIndex) = Key & "=" & WStr(Value)
			Update
		Else
			If SecIndex < FLines.Count -1 Then
				Dim As Integer LastIndex
				For i As Integer = SecIndex +1 To FLines.Count-1
					Dim As WString Ptr s
					s = @FLines.Item(i)
					If *s <> "" Then
						LastIndex = i
						If s[0] = Asc("[") Then Exit For
					End If
				Next i
				If LastIndex = FLines.Count -1 Then
					FLines.Add Key & "=" & WStr(Value)
					Update
				Else
					FLines.Insert LastIndex,Key & "=" & WStr(Value)
				End If
				Update
			Else
				FLines.Add Key & "=" & WStr(Value)
				Update
			End If
		End If
	Else
		FLines.Add "[" & Section & "]"
		FLines.Add Key & "=" & WStr(Value)
		Update
	End If
End Sub

Sub IniFile.WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
	Dim As Integer SecIndex, KeyIndex
	SecIndex = SectionExists(Section)
	If SecIndex <> -1 Then
		KeyIndex = KeyExists(Section,Key)
		If KeyIndex <> -1 Then
			FLines.Item(KeyIndex) = Key & "=" & WStr(Value) & Chr(0)
			Update
		Else
			If SecIndex < FLines.Count -1 Then
				Dim As Integer LastIndex
				For i As Integer = SecIndex +1 To FLines.Count-1
					Dim As WString Ptr s
					s = @FLines.Item(i)
					If *s <> "" Then
						LastIndex = i
						If s[0] = Asc("[") Then Exit For
					End If
				Next i
				If LastIndex = FLines.Count -1 Then
					FLines.Add Key & "=" & WStr(Value)
					Update
				Else
					FLines.Insert LastIndex,Key & "=" & WStr(Value)
				End If
				Update
			Else
				FLines.Add Key & "=" & WStr(Value)
				Update
			End If
		End If
	Else
		FLines.Add "[" & Section & "]"
		FLines.Add Key & "=" & WStr(Value)
		Update
	End If
End Sub

Sub IniFile.WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
	Dim As Integer SecIndex, KeyIndex
	SecIndex = SectionExists(Section)
	If SecIndex <> -1 Then
		KeyIndex = KeyExists(Section,Key)
		If KeyIndex <> -1 Then
			FLines.Item(KeyIndex) = Key + "=" + Value + WChr(0)
			Update
		Else
			If SecIndex < FLines.Count -1 Then
				Dim As Integer LastIndex
				For i As Integer = SecIndex +1 To FLines.Count-1
					Dim As WString Ptr s
					s = @FLines.Item(i)
					If *s <> "" Then
						LastIndex = i
						If s[0] = Asc("[") Then Exit For
					End If
				Next i
				If LastIndex = FLines.Count -1 Then
					FLines.Add Key + "=" + Value
					Update
				Else
					FLines.Insert LastIndex,Key & "=" & WStr(Value)
				End If
				Update
			Else
				FLines.Add Key + "=" + Value
				Update
			End If
		End If
	Else
		FLines.Add "[" & Section & "]"
		FLines.Add Key + "=" + Value
		Update
	End If
End Sub

Function IniFile.ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			Dim Value As Integer
			s = @FLines.Item(Index)
			Return ValInt(Mid(*s, InStr(*s, "=") + 1, Len(*s)))
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Function IniFile.ReadFloat(ByRef Section As WString, ByRef Key As WString, Inplace As Double = 0.0) As Double
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			s = @FLines.Item(Index)
			Return Val(Mid(*s, InStr(*s, "=") + 1, Len(*s)))
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Function IniFile.ReadBool(ByRef Section As WString, ByRef Key As WString, Inplace As Boolean = False) As Boolean
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			s = @FLines.Item(Index)
			Return Cast(Boolean, Trim(Mid(*s, InStr(*s, "=") + 1, Len(*s))))
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Function IniFile.ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") ByRef As WString
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			WLet s, FLines.Item(Index)
			*s = Mid(*s, InStr(*s, "=") + 1, Len(*s))
			Return *s
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Operator IniFile.Cast As Any Ptr
	Return @This
End Operator

Constructor IniFile
	Dim As WString * 255 Tx
	Dim As Integer L, i, k
	#ifndef __USE_GTK__
		L = GetModuleFileName(GetModuleHandle(NULL), Tx, 255)
		Tx = Left(Tx, L)
		For i = 0 To Len(Tx)
			If Tx[i] = Asc(".") Then k = i +1
		Next i
		Wlet FFile, Mid(Tx, 1, k - 1) + ".ini"
	#else
		Wlet FFile, "Config.ini" 'David Change for hanging in linux
	#endif
End Constructor

Destructor IniFile
	If FFile Then Deallocate FFile
	FLines.Clear
End Destructor
