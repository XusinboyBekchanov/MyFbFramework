'###############################################################################
'#  IniFile.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'#  Based on:                                                                  #
'#   TIniFile.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "IniFile.bi"
Private Property IniFile.File ByRef As WString
	Return *FFile
End Property

Private Property IniFile.File(ByRef Value As WString)
	If *FFile <> Value AndAlso Value <> "" Then
		WLet(FFile, Value)
		Load(Value)
	End If
End Property

Private Property IniFile.SaveSuspend As Boolean
	Return FSaveSuspend
End Property

Private Property IniFile.SaveSuspend(Value As Boolean)
	FSaveSuspend = Value
End Property

Private Function IniFile.SectionCount As Integer
	FSectionCount = 0
	Dim As WString Ptr s
	For i As Integer = 0 To FLines.Count -1
		s = Cast(WString Ptr, FLines.Item(i))
		If Trim(*s) = "" Then Continue For  'Not allowed empty
		If (CharStart = "[" AndAlso Mid(Trim(*s), 1, 1) <> ";") Then
			If Mid(Trim(*s), 1, 1) = CharStart AndAlso Right(Trim(*s), 1) = CharEnd Then FSectionCount += 1
		ElseIf (CharStart = "<" AndAlso Mid(Trim(*s), 1, 1) = CharStart AndAlso Mid(Trim(*s), 1, 2) <> "<!" AndAlso Mid(Trim(*s), 1, 2) <> "<?") Then
			If Right(Trim(*s), 1) = CharEnd AndAlso InStr(Trim(*s), "</") < 1 Then FSectionCount += 1
		End If
	Next i
	Return FSectionCount
End Function

Private Function IniFile.SectionExists(ByRef Section As WString) As Integer
	Dim As WString Ptr s
	For i As Integer = 0 To FLines.Count - 1
		s = Cast(WString Ptr, FLines.Item(i))
		If Trim(*s) = "" Then Continue For  'Not allowed empty
		If (CharStart = "[" AndAlso Mid(Trim(*s), 1, 1) <> ";") Then
			If Mid(Trim(*s), 1, 1) = CharStart AndAlso Right(Trim(*s), 1) = CharEnd Then
				If CharStart & UCase(Section) & CharEnd = UCase(Trim(*s)) Then Return i
			End If
		ElseIf (CharStart = "<" AndAlso Mid(Trim(*s), 1, 1) = CharStart AndAlso Mid(Trim(*s), 1, 2) <> "<!" AndAlso Mid(Trim(*s), 1, 2) <> "<?") Then
			If Right(Trim(*s), 1) = CharEnd AndAlso InStr(Trim(*s), "</") < 1 Then
				If CharStart & UCase(Section) & CharEnd = UCase(Trim(*s)) Then Return i
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
			s = Cast(WString Ptr, FLines.Item(i))
			If Trim(*s) = "" Then Continue For  'Not allowed empty
			If (CharStart = "[" AndAlso Mid(Trim(*s), 1, 1) <> ";") Then
				If Mid(Trim(*s), 1, 1) = CharStart Then Return -1
				If Mid(Trim(*s), 1, 1) <> CharStart Then If UCase(Key) = UCase(Trim(Mid(Trim(*s), 1, InStr(Trim(*s), "=") - 1))) Then Return i
			ElseIf (CharStart = "<" AndAlso Mid(Trim(*s), 1, 1) = CharStart AndAlso Mid(Trim(*s), 1, 2) <> "<!") Then
				If InStr(Trim(*s), "<" & Key & ">") AndAlso InStr(Trim(*s), "</" & Key & ">") Then Return i
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
			s = Cast(WString Ptr, FLines.Item(i))
			If Trim(*s) = "" Then Continue For  'Not allowed empty
			If (CharStart = "[" AndAlso Mid(Trim(*s), 1, 1) <> ";") Then
				If Mid(Trim(*s), 1, 1) = CharStart Then Return -1
				If Mid(Trim(*s), 1, 1) <> CharStart Then If UCase(Key) = UCase(Trim(Mid(Trim(*s), 1, InStr(Trim(*s), "=") - 1))) Then FLines.Remove i : Return True
			ElseIf (CharStart = "<" AndAlso Mid(Trim(*s), 1, 1) = CharStart AndAlso Mid(Trim(*s), 1, 2) <> "<!") Then
				If InStr(Trim(*s), "<" & Key & ">") AndAlso InStr(Trim(*s), "</" & Key & ">") Then FLines.Remove i : Return True
			End If
		Next i
	End If
	Return False
End Function

Private Sub IniFile.Load(ByRef FileName As WString = "")
	Dim Result As Integer = -1 'David Change
	If FileName <> "" AndAlso *FFile<> FileName Then WLet(FFile, FileName)
	Dim As WString Ptr wData, LineBuff()
	WLet(wData, LoadFromFile(*FFile, FFileEncoding, FNewLineType))
	If Trim(*wData) = "" Then
		Debug.Print __FUNCTION__ & "(Line " & __LINE__ & ")" & Chr(9) & "ERROR on reading file: " & *FFile, True
		Exit Sub
	End If
	If Mid(Trim(LCase(*wData)), 1, 5) = "<?xml" Then CharStart = "<": CharEnd  = ">"
	Dim As String NewLineStr
	If FNewLineType = NewLineTypes.WindowsCRLF  Then
		NewLineStr = Chr(13, 10)
	ElseIf FNewLineType = NewLineTypes.LinuxLF Then
		NewLineStr = Chr(10)
	ElseIf FNewLineType = NewLineTypes.MacOSCR Then
		NewLineStr =  Chr(13)
	Else
		NewLineStr = Chr(10)
	End If
	Split(*wData, NewLineStr, LineBuff())
	FLines.Clear
	For i As Integer = 0 To UBound(LineBuff)
		FLines.Add LineBuff(i)
	Next i
	_Deallocate(wData)
End Sub

Private Sub IniFile.SaveFile(ByRef FileName As WString = "")
	'If Open(File For Binary Access Write As #Fn) = 0 Then
	Dim As WString Ptr wData
	If FileName <> "" AndAlso *FFile <> FileName Then WLet(FFile, FileName)
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
	WLet(wData, *Cast(WString Ptr, FLines.Item(0)))
	For i As Integer = 1 To FLines.Count - 1
		WAdd(wData, NewLineStr & *Cast(WString Ptr, FLines.Item(i)))
	Next i
	SaveToFile(*FFile, *wData, FFileEncoding, FNewLineType)
	Deallocate wData
End Sub

Private Sub IniFile.WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
	Dim As Integer SecIndex, KeyIndex
	Dim As WString Ptr s
	SecIndex = SectionExists(Section)
	If SecIndex <> -1 Then
		KeyIndex = KeyExists(Section, Key)
		If KeyIndex <> -1 Then
			s = Cast(WString Ptr, FLines.Item(KeyIndex))
			If (CharStart = "[") Then
				WLet(s, Key & "=" & Value)
			Else
				WLet(s, "<" & Key & ">" & Value & "</" & Key & ">")
			End If
			FLines.Item(KeyIndex) = s
			If Not FSaveSuspend Then SaveFile
		Else
			If SecIndex < FLines.Count -1 Then
				Dim As Integer LastIndex
				For i As Integer = SecIndex + 1 To FLines.Count - 1
					s = Cast(WString Ptr, FLines.Item(i))
					If *s = "" Then Continue For
					LastIndex = i
					If Mid(Trim(*s), 1, 1) = CharStart Then Exit For
				Next i
				If LastIndex = FLines.Count -1 Then
					If (CharStart = "[") Then
						s = 0 : WLet(s, Key & "=" & Value)
					Else
						s = 0 : WLet(s, "<" & Key & ">" & Value & "</" & Key & ">")
					End If
					FLines.Add s
				Else
					If (CharStart = "[") Then
						s = 0 : WLet(s, Key & "=" & Value)
					Else
						s = 0 : WLet(s, "<" & Key & ">" & Value & "</" & Key & ">")
					End If
					FLines.Insert LastIndex, s
				End If
				If Not FSaveSuspend Then SaveFile
			Else
				If (CharStart = "[") Then
					s = 0 : WLet(s, Key & "=" & Value)
				Else
					s = 0 : WLet(s, "<" & Key & ">" & Value & "</" & Key & ">")
				End If
				FLines.Add s
				If Not FSaveSuspend Then SaveFile
			End If
		End If
	Else
		s = 0 : WLet(s, CharStart & Section & CharEnd)
		FLines.Add s
		If (CharStart = "[") Then
			s = 0 : WLet(s, Key & "=" & Value)
		Else
			s = 0 : WLet(s, "<" & Key & ">" & Value & "</" & Key & ">")
		End If
		FLines.Add s
		If (CharStart <> "[") Then
			s = 0 : WLet(s, "</" & Section & ">")
			FLines.Add s
		End If
		If Not FSaveSuspend Then SaveFile
	End If
End Sub


Private Sub IniFile.WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
	WriteString(Section, Key, WStr(Value))
End Sub

Private Sub IniFile.WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
	WriteString(Section, Key, WStr(Value))
End Sub

Private Sub IniFile.WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
	Dim As String TrueStr = IIf(Value, "True", "False")
	WriteString(Section, Key, WStr(TrueStr))
End Sub

Private Function IniFile.ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			Dim Value As Integer
			s = Cast(WString Ptr, FLines.Item(Index))
			If (CharStart = "[") Then
				Return ValInt(Mid(Trim(*s), InStr(Trim(*s), "=") + 1, Len(*s)))
			Else
				Dim As Integer PosStart = Len("<" & Key & ">") + 1
				Dim As Integer PosEnd = InStr(PosStart, Trim(*s), "</")
				If PosEnd > 0 Then Return ValInt(Mid(Trim(*s), PosStart, PosEnd - PosStart)) Else Return Inplace
			End If
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
			Dim Value As Integer
			s = Cast(WString Ptr, FLines.Item(Index))
			If (CharStart = "[") Then
				If LCase(Mid(Trim(*s), InStr(Trim(*s), "=") + 1, Len(*s)))="true" Then Return True Else Return False
			Else
				Dim As Integer PosStart = Len("<" & Key & ">") + 1
				Dim As Integer PosEnd = InStr(PosStart, Trim(*s), "</")
				If PosEnd > 0 Then Return Val(Mid(Trim(*s), PosStart, PosEnd - PosStart)) Else Return Inplace
			End If
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
			Dim Value As Integer
			s = Cast(WString Ptr, FLines.Item(Index))
			If (CharStart = "[") Then
				If LCase(Mid(Trim(*s), InStr(Trim(*s), "=") + 1, Len(*s))) = "true" Then Return True Else Return False
			Else
				Dim As Integer PosStart = Len("<" & Key & ">") + 1
				Dim As Integer PosEnd = InStr(PosStart, Trim(*s), "</")
				If PosEnd > 0 AndAlso LCase(Mid(Trim(*s), PosStart, PosEnd - PosStart)) = "true" Then Return True Else Return False
			End If
		Else
			Return Inplace
		End If
	Else
		Return Inplace
	End If
End Function

Private Function IniFile.ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") As UString
	Dim As Integer Index
	Dim As WString Ptr s
	If SectionExists(Section) <> -1 Then
		Index = KeyExists(Section, Key)
		If Index <> -1 Then
			Dim Value As Integer
			s = Cast(WString Ptr, FLines.Item(Index))
			If (CharStart = "[") Then
				Return Mid(Trim(*s), InStr(Trim(*s), "=") + 1, Len(*s))
			Else
				Dim As Integer PosStart = Len("<" & Key & ">") + 1
				Dim As Integer PosEnd = InStr(PosStart, Trim(*s), "</")
				If PosEnd > 0 Then Return Mid(Trim(*s), PosStart, PosEnd - PosStart) Else Return Inplace
			End If
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
	For i As Integer = FLines.Count - 1 To 0 Step -1
		Deallocate FLines.Item(i)
		FLines.Remove i
	Next
	
End Destructor
