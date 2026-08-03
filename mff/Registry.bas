#include once "Registry.bi"

Namespace My.Sys.Registry
	#ifndef __USE_GTK__
		Private Function ReadRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR) As String
			Dim As DWORD lDataTypeValue, lValueLength
			Dim sValue As String
			Dim As String Tstr1, Tstr2
			Dim lKeyValue As HKEY
			Dim lResult As Integer
			Dim td As Double
			Dim As UByte Ptr pBuffer
			
			sValue = ""
			
			lResult      = RegOpenKey(Group, Section, @lKeyValue)
			If lResult <> 0 Then Return ""
			
			lValueLength = 0
			lResult = RegQueryValueEx(lKeyValue, Key, 0, @lDataTypeValue, 0, @lValueLength)
			If lResult <> 0 OrElse lValueLength = 0 Then
				RegCloseKey(lKeyValue)
				Return ""
			End If
			
			pBuffer = _CAllocate(lValueLength)
			If pBuffer = 0 Then
				RegCloseKey(lKeyValue)
				Return ""
			End If
			
			lResult = RegQueryValueEx(lKeyValue, Key, 0, @lDataTypeValue, pBuffer, @lValueLength)
			
			If (lResult = 0) Then
				
				Select Case lDataTypeValue
				Case REG_DWORD
					If lValueLength >= 4 Then
						td = pBuffer[0] + &H100& * pBuffer[1] + &H10000 * pBuffer[2] + &H1000000 * CDbl(pBuffer[3])
						sValue = Format(td, "000")
					End If
				Case REG_BINARY
					' Return a binary field as a hex string (2 chars per byte)
					Tstr2 = ""
					For I As Integer = 0 To lValueLength - 1
						Tstr1 = Hex(pBuffer[I])
						If Len(Tstr1) = 1 Then Tstr1 = "0" & Tstr1
						Tstr2 += Tstr1
					Next
					sValue = Tstr2
				Case Else
					If lValueLength >= SizeOf(WString) Then
						sValue = Left(*Cast(WString Ptr, pBuffer), (lValueLength \ SizeOf(WString)) - 1)
					End If
				End Select
				
			End If
			
			_Deallocate(pBuffer)
			RegCloseKey(lKeyValue)
			
			Return sValue
			
		End Function
		
		Private Function IsValidUInt(ByRef s As String) As Boolean
			Dim As String t = Trim(s)
			If Len(t) = 0 Then Return False
			For i As Integer = 1 To Len(t)
				If Mid(t, i, 1) < "0" OrElse Mid(t, i, 1) > "9" Then Return False
			Next
			Return True
		End Function
		
		Private Sub WriteRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR, ByVal ValType As InTypes, value As String)
			Dim lResult As Integer
			Dim lKeyValue As HKEY
			Dim lNewVal As DWORD
			Dim sNewVal As String * 2048
			
			lResult = RegCreateKey(Group, Section, @lKeyValue)
			
			If ValType = ValDWord Then
				If IsValidUInt(value) Then
					lNewVal = CUInt(value)
					lResult = RegSetValueEx(lKeyValue, Key, 0 &, ValType, Cast(Byte Ptr, @lNewVal), SizeOf(DWORD))
				End If
			Else
				If ValType = ValString Then
					sNewVal = value & Chr(0)
					lResult = RegSetValueEx(lKeyValue, Key, 0 &, ValString, Cast(Byte Ptr, @sNewVal), Len(sNewVal) * SizeOf(WString))
				End If
			End If
			
			lResult = RegFlushKey(lKeyValue)
			lResult = RegCloseKey(lKeyValue)
			
		End Sub
	#endif
End Namespace
