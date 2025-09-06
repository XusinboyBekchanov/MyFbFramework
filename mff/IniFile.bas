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
Private Property IniFile.File ByRef As WString
	Return WGet(FFile)
End Property

Private Property IniFile.File(ByRef Value As WString)
	WLet(FFile, Value)
End Property

Private Property IniFile.SectionCount As Integer
	FSectionCount = 0
	Dim As WString Ptr s
	For i As Integer = 0 To FLines.Count -1
		s = @FLines.Item(i)
		If s[0] <> "" Then If s[0] <> Asc(";") Then If s[0] = Asc("[") Then FSectionCount += 1
	Next i
	Return FSectionCount
End Property

Private Property IniFile.SectionCount(Value As Integer)
End Property

Private Function IniFile.SectionExists(ByRef Section As WString) As Integer
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

Private Function IniFile.KeyExists(ByRef Section As WString, ByRef Key As WString) As Integer
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
Private Function IniFile.KeyRemove(ByRef Section As WString, ByRef Key As WString) As Boolean
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

Private Sub IniFile.Load(ByRef FileName As WString = "")
	Dim Result As Integer = -1 'David Change
	If FileName <> "" Then WLet(FFile, FileName)
	Dim As WString Ptr wData, LineBuff()
	wData = LoadFromFile(*FFile, FFileEncoding, FNewLineType)
	If Trim(*wData) = "" Then
		Debug.Print ML("in function") + " " +  __FUNCTION__ + " " +  ML("in Line") + " " + Str( __LINE__) + Chr(9) + ML("Open file failure!") + Chr(9) + *FFile, True
		Exit Sub
	End If
	Dim As String NewLineStr = Chr(13, 10)
	If FNewLineType = NewLineTypes.WindowsCRLF  Then
		NewLineStr = Chr(13, 10)
	ElseIf FNewLineType = NewLineTypes.LinuxLF Then
		NewLineStr = Chr(10)
	ElseIf FNewLineType = NewLineTypes.MacOSCR Then
		NewLineStr =  Chr(13)
	Else
		NewLineStr = Chr(13, 10)
	End If
	Split(*wData, NewLineStr, LineBuff())
	FLines.Clear
	For i As Integer = 0 To UBound(LineBuff)
		FLines.Add *LineBuff(i)
		_Deallocate(LineBuff(i))
	Next i
	Erase LineBuff
	_Deallocate(wData)
End Sub

Private Sub IniFile.Update
	Dim As WString Ptr wData
	Dim As String NewLineStr
	If FNewLineType = NewLineTypes.WindowsCRLF  Then
		NewLineStr = Chr(13, 10)
	ElseIf FNewLineType = NewLineTypes.LinuxLF Then
		NewLineStr = Chr(10)
	ElseIf FNewLineType = NewLineTypes.MacOSCR Then
		NewLineStr =  Chr(13)
	Else
		NewLineStr = Chr(13, 10)
	End If
	WLet(wData, FLines.Item(0)) 
	For i As Integer = 1 To FLines.Count - 1
		WAdd(wData, NewLineStr & FLines.Item(i))
	Next i
	If Not SaveToFile(*FFile, *wData, FFileEncoding, FNewLineType) Then 
		Debug.Print ML("in function") + " " +  __FUNCTION__ + " " +  ML("in Line") + " " + Str( __LINE__) + Chr(9) + ML("Save file failure!") + Chr(9) +  *FFile, True
	End If
	_Deallocate(wData)
End Sub

Private Sub IniFile.WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
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

Private Sub IniFile.WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
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

Private Sub IniFile.WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
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

Private Sub IniFile.WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
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

Private Function IniFile.ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
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

Private Function IniFile.ReadFloat(ByRef Section As WString, ByRef Key As WString, Inplace As Double = 0.0) As Double
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

Private Function IniFile.ReadBool(ByRef Section As WString, ByRef Key As WString, Inplace As Boolean = False) As Boolean
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

Private Function IniFile.ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") As UString
	Dim As Integer Index
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			Return Mid(FLines.Item(Index), InStr(FLines.Item(Index), "=") + 1, Len(FLines.Item(Index)))
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Private Operator IniFile.Cast As Any Ptr
	Return @This
End Operator

Private Constructor IniFile(ByRef FileName As WString = "")
	If Trim(FileName) = "" Then
		Dim As WString * 255 Tx
		Dim As Integer L, i, k
		#ifndef __USE_GTK__
			L = GetModuleFileName(GetModuleHandle(NULL), Tx, 255)
			Tx = Left(Tx, L)
			For i = 0 To Len(Tx)
				If Tx[i] = Asc(".") Then k = i +1
			Next i
			WLet(FFile, Mid(Tx, 1, k - 1) + ".ini")
		#else
			WLet(FFile, "Config.ini")
		#endif
	Else
		WLet(FFile, FileName)
		Load(*FFile)
	End If
End Constructor

Private Destructor IniFile
	If FFile Then _Deallocate( FFile)
	FLines.Clear
End Destructor
