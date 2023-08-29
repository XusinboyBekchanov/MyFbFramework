#pragma once

Dim Shared As Boolean g_darkModeSupported
Dim Shared As Boolean g_darkModeEnabled

#ifdef __USE_WINAPI__
	Declare Function ShouldAppsUseDarkMode() As BOOL
	Declare Function AllowDarkModeForWindow(hWnd As hWnd, allow As BOOL) As BOOL
	Declare Function IsHighContrast() As BOOL
	Declare Sub RefreshTitleBarThemeColor(hWnd As hWnd)
	Declare Sub SetTitleBarThemeColor(hWnd As hWnd, dark As BOOL)
	Declare Function IsColorSchemeChangeMessage Overload(lParam As lParam) As BOOL
	Declare Function IsColorSchemeChangeMessage Overload(message As UINT, lParam As lParam) As BOOL
	Declare Sub AllowDarkModeForApp(allow As BOOL)
	Declare Sub EnableDarkScrollBarForWindowAndChildren(hwnd As hwnd)
	Declare Sub InitDarkMode()
	Declare Function IsWindows11() As BOOL
#endif
#define nullptr 0
Declare Sub SetDarkMode(useDarkMode As Boolean, fixDarkScrollbar As Boolean)

#ifndef __USE_MAKE__
	#include once "DarkMode.bas"
#endif

