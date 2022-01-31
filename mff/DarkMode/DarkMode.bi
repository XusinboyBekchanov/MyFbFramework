#pragma once

Common Shared As Boolean g_darkModeSupported
Common Shared As Boolean g_darkModeEnabled


Declare Function ShouldAppsUseDarkMode() As BOOL
Declare Function AllowDarkModeForWindow(hWnd As HWND, allow As BOOL) As BOOL
Declare Function IsHighContrast() As BOOL
Declare Sub RefreshTitleBarThemeColor(hWnd As HWND)
Declare Sub SetTitleBarThemeColor(hWnd As HWND, dark As BOOL)
Declare Function IsColorSchemeChangeMessage Overload(lParam As LPARAM) As BOOL
Declare Function IsColorSchemeChangeMessage Overload(message As UINT, lParam As LPARAM) As BOOL
Declare Sub AllowDarkModeForApp(allow As BOOL)
Declare Sub EnableDarkScrollBarForWindowAndChildren(hwnd As HWND)
Declare Sub InitDarkMode()
Declare Sub SetDarkMode(useDarkMode As BOOL, fixDarkScrollbar As BOOL)
Declare Function IsWindows11() As BOOL
