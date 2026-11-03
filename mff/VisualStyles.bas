'################################################################################
'#  VisualStyles.bas                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Converted from: VisualStyles.bas of VBFLXGRD18 (VB FlexGrid Control 1.8)    #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'################################################################################

#include once "VisualStyles.bi"

Namespace My.Sys.Forms
	Type DLLVERSIONINFO
		cbSize As DWORD
		dwMajor As DWORD
		dwMinor As DWORD
		dwBuildNumber As DWORD
		dwPlatformID As DWORD
	End Type

	Const STAP_ALLOW_CONTROLS_ = 2
	Const S_OK_ = 0

	Function FlexActivateVisualStyles(ByVal hWnd As HWND) As Long
		Return SetWindowTheme(hWnd, NULL, NULL)
	End Function

	Function FlexRemoveVisualStyles(ByVal hWnd As HWND) As Long
		Dim As WString Ptr SubAppName = @" "
		Return SetWindowTheme(hWnd, SubAppName, SubAppName)
	End Function

	Function EnabledVisualStyles() As Boolean
		If GetComCtlVersion() >= 6 Then
			If IsThemeActive() <> 0 Then
				If IsAppThemed() <> 0 Then
					Return True
				ElseIf (GetThemeAppProperties() And STAP_ALLOW_CONTROLS_) <> 0 Then
					Return True
				End If
			End If
		End If
		Return False
	End Function

	Function GetComCtlVersion() As Long
		Static Done As Integer = False
		Static Value As Long = 0
		If Done = False Then
			Dim As DLLVERSIONINFO Version
			Version.cbSize = SizeOf(DLLVERSIONINFO)
			Dim As Any Ptr LibHandle = DylibLoad("comctl32.dll")
			If LibHandle <> 0 Then
				Dim As Any Ptr ProcAddr = DylibSymbol(LibHandle, "DllGetVersion")
				If ProcAddr <> 0 Then
					Dim As Function(ByRef pdvi As DLLVERSIONINFO) As Long DllGetVersionProc
					DllGetVersionProc = CPtr(Function(ByRef pdvi As DLLVERSIONINFO) As Long, ProcAddr)
					If DllGetVersionProc(Version) = S_OK_ Then Value = Version.dwMajor
				End If
				DylibFree(LibHandle)
			End If
			Done = True
		End If
		Return Value
	End Function
End Namespace

