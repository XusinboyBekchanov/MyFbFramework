'################################################################################
'#  GridDataExBase.bas                                                                #
'#  This file is part of the VBFlexGrid to FreeBASIC conversion.                #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'#  Converted from: VBFlexGridBase.bas of VBFLXGRD18 (VB GridDataEx Control 1.8) #
'################################################################################

#include once "GridDataExBase.bi"

Namespace My.Sys.Forms
	Type TINITCOMMONCONTROLSEX_FLEX
		dwSize As Long
		dwICC As Long
	End Type

	Type WNDCLASSEX_FLEX
		cbSize As UINT
		dwStyle As UINT
		lpfnWndProc As WNDPROC
		cbClsExtra As Long
		cbWndExtra As Long
		hInstance As HINSTANCE
		hIcon As HICON
		hCursor As HANDLE
		hbrBackground As HBRUSH
		lpszMenuName As LPCWSTR
		lpszClassName As LPCWSTR
		hIconSm As HICON
	End Type

	Const WM_CREATE_ = &H1
	Const WM_DESTROY_ = &H2
	Const WM_NCDESTROY_ = &H82
	Const CS_DBLCLKS_ = &H8
	Const IDC_ARROW_ = 32512

	Dim Shared ShellModHandle As HINSTANCE = 0
	Dim Shared ShellModCount As Long = 0
	Dim Shared FlexClassAtom As UShort = 0
	Dim Shared FlexRefCount As Long = 0
	Dim Shared FlexSplitterBrush As HANDLE = 0

	Sub FlexLoadShellMod()
		If ShellModHandle = 0 AndAlso ShellModCount = 0 Then
			ShellModHandle = Cast(HINSTANCE, LoadLibraryW("Shell32.dll"))
		End If
		ShellModCount += 1
	End Sub

	Sub FlexReleaseShellMod()
		ShellModCount -= 1
		If ShellModHandle <> 0 AndAlso ShellModCount = 0 Then
			FreeLibrary(ShellModHandle)
			ShellModHandle = 0
		End If
	End Sub

	Sub FlexInitCC(ByVal ICC As Long)
		Dim As tagINITCOMMONCONTROLSEX ICCEX
		ICCEX.dwSize = SizeOf(tagINITCOMMONCONTROLSEX)
		ICCEX.dwICC = ICC
		InitCommonControlsEx(@ICCEX)
	End Sub

	Sub FlexWndRegisterClass()
		If FlexClassAtom = 0 AndAlso FlexRefCount = 0 Then
			Dim As WNDCLASSEX_FLEX WCEX
			Dim As WString Ptr ClassNamePtr = @"VBFlexGridWndClass"
			WCEX.cbSize = SizeOf(WNDCLASSEX_FLEX)
			' CS_VREDRAW and CS_HREDRAW are not specified as entire redraw upon resize is not necessary.
			WCEX.dwStyle = CS_DBLCLKS_
			WCEX.lpfnWndProc = @FlexWindowProc
			WCEX.cbWndExtra = SizeOf(LONG_PTR)
			WCEX.hInstance = GetModuleHandleW(NULL)
			WCEX.hCursor = LoadCursorW(NULL, MAKEINTRESOURCEW(IDC_ARROW_))
			WCEX.hbrBackground = 0
			WCEX.lpszClassName = ClassNamePtr
			FlexClassAtom = RegisterClassExW(CPtr(WNDCLASSEXW Ptr, @WCEX))
			If FlexSplitterBrush = 0 Then
				Dim As BITMAP Bmp
				Dim As Long Pattern(0 To 3) = {&HAAAA5555, &HAAAA5555, &HAAAA5555, &HAAAA5555}
				Bmp.bmType = 0
				Bmp.bmWidth = 16
				Bmp.bmHeight = 8
				Bmp.bmWidthBytes = 2
				Bmp.bmPlanes = 1
				Bmp.bmBitsPixel = 1
				Bmp.bmBits = @Pattern(0)
				Dim As HBITMAP hBmp = CreateBitmapIndirect(@Bmp)
				If hBmp <> 0 Then
					FlexSplitterBrush = CreatePatternBrush(hBmp)
					DeleteObject(hBmp)
				End If
			End If
		End If
		FlexRefCount += 1
	End Sub

	Sub FlexWndReleaseClass()
		FlexRefCount -= 1
		If FlexClassAtom <> 0 AndAlso FlexRefCount = 0 Then
			UnregisterClassW(MAKEINTRESOURCEW(FlexClassAtom), GetModuleHandleW(NULL))
			FlexClassAtom = 0
			If FlexSplitterBrush <> 0 Then
				DeleteObject(FlexSplitterBrush)
				FlexSplitterBrush = 0
			End If
		End If
	End Sub

	Function FlexGetSplitterBrush() As HANDLE
		Return FlexSplitterBrush
	End Function

	Function FlexGetDragCursor(ByVal IDC As Long) As HANDLE
		Dim As HINSTANCE hLib = Cast(HINSTANCE, LoadLibraryW("ole32.dll"))
		If hLib <> 0 Then
			Dim As HANDLE Result = LoadCursorW(hLib, MAKEINTRESOURCEW(IDC))
			FreeLibrary(hLib)
			Return Result
		End If
		Return 0
	End Function

	'The VB6 version routes messages through the control COM object. Here the
	'stored GWLP_USERDATA points to a user callback context instead (see GridDataEx.bi).
	Function FlexWindowProc(ByVal hWnd As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
		Select Case wMsg
			Case WM_DESTROY_, WM_NCDESTROY_
				Return DefWindowProcW(hWnd, wMsg, wParam, lParam)
		End Select
		Return DefWindowProcW(hWnd, wMsg, wParam, lParam)
	End Function
End Namespace



