#include once "Registry.bi"

Namespace My.Sys.Registry
	#ifndef __USE_GTK__
		Private Function ReadRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR) As String
			Dim As DWORD lDataTypeValue, lValueLength
			Dim sValue As String * 2048
			Dim As String Tstr1, Tstr2
			Dim lKeyValue As HKEY
			Dim lResult As Integer
			Dim td As Double
			
			sValue = ""
			
			lResult      = RegOpenKey(Group, Section, @lKeyValue)
			lValueLength = Len(sValue)
			lResult      = RegQueryValueEx(lKeyValue, Key, 0, @lDataTypeValue, Cast(Byte Ptr, @sValue), @lValueLength)
			
			If (lResult = 0) Then
				
				Select Case lDataTypeValue
				Case REG_DWORD
					td = Asc(Mid(sValue, 1, 1)) + &H100& * Asc(Mid(sValue, 2, 1)) + &H10000 * Asc(Mid(sValue, 3, 1)) + &H1000000 * CDbl(Asc(Mid(sValue, 4, 1)))
					sValue = Format(td, "000")
				Case REG_BINARY
					' Return a binary field as a hex string (2 chars per byte)
					Tstr2 = ""
					For I As Integer = 1 To lValueLength
						Tstr1 = Hex(Asc(Mid(sValue, I, 1)))
						If Len(Tstr1) = 1 Then Tstr1 = "0" & Tstr1
						Tstr2 += Tstr1
					Next
					sValue = Tstr2
				Case Else
					sValue = Left(*Cast(WString Ptr, @sValue), lValueLength - 1)
				End Select
				
			End If
			
			lResult = RegCloseKey(lKeyValue)
			
			Return sValue
			
		End Function
		
		Private Sub WriteRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR, ByVal ValType As InTypes, value As String)
			Dim lResult As Integer
			Dim lKeyValue As HKEY
			Dim lNewVal As DWORD
			Dim sNewVal As String * 2048
			
			lResult = RegCreateKey(Group, Section, @lKeyValue)
			
			If ValType = ValDWord Then
				lNewVal = CUInt(value)
				lResult = RegSetValueEx(lKeyValue, Key, 0&, ValType, Cast(Byte Ptr,@lNewVal), SizeOf(DWORD))
			Else
				If ValType = ValString Then
					sNewVal = value & Chr(0)
					lResult = RegSetValueEx(lKeyValue, Key, 0&, ValString, Cast(Byte Ptr,@sNewVal), Len(sNewVal))
				EndIf
			End If
			
			lResult = RegFlushKey(lKeyValue)
			lResult = RegCloseKey(lKeyValue)
			
		End Sub
	#endif
End Namespace
