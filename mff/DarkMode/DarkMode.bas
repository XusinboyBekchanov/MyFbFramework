#ifdef __USE_WINAPI__
	#include "Windows.bi"
#endif

#include "DarkMode.bi"

#ifdef __USE_WINAPI__
	#include "IatHook.bi"
	
	#include "UAHMenuBar.bi"
	
	#include "win\Uxtheme.bi"
	
	'#include "Vssym32.bi"
	
	'#include <unordered_set>
	'#include <mutex>
	
	'#if defined(__GNUC__) && __GNUC__ > 8
	'#define WINAPI_LAMBDA_RETURN(return_t) -> return_t WINAPI
	'#elif defined(__GNUC__)
	'#define WINAPI_LAMBDA_RETURN(return_t) WINAPI -> return_t
	'#else
	'#define WINAPI_LAMBDA_RETURN(return_t) -> return_t
	'#endif
	
	Enum IMMERSIVE_HC_CACHE_MODE
		IHCM_USE_CACHED_VALUE,
		IHCM_REFRESH
	End Enum
	
	' 1903 18362
	Enum PreferredAppMode
		Default,
		AllowDark,
		ForceDark,
		ForceLight,
		Max
	End Enum
	
	Enum WINDOWCOMPOSITIONATTRIB
		WCA_UNDEFINED = 0,
		WCA_NCRENDERING_ENABLED = 1,
		WCA_NCRENDERING_POLICY = 2,
		WCA_TRANSITIONS_FORCEDISABLED = 3,
		WCA_ALLOW_NCPAINT = 4,
		WCA_CAPTION_BUTTON_BOUNDS = 5,
		WCA_NONCLIENT_RTL_LAYOUT = 6,
		WCA_FORCE_ICONIC_REPRESENTATION = 7,
		WCA_EXTENDED_FRAME_BOUNDS = 8,
		WCA_HAS_ICONIC_BITMAP = 9,
		WCA_THEME_ATTRIBUTES = 10,
		WCA_NCRENDERING_EXILED = 11,
		WCA_NCADORNMENTINFO = 12,
		WCA_EXCLUDED_FROM_LIVEPREVIEW = 13,
		WCA_VIDEO_OVERLAY_ACTIVE = 14,
		WCA_FORCE_ACTIVEWINDOW_APPEARANCE = 15,
		WCA_DISALLOW_PEEK = 16,
		WCA_CLOAK = 17,
		WCA_CLOAKED = 18,
		WCA_ACCENT_POLICY = 19,
		WCA_FREEZE_REPRESENTATION = 20,
		WCA_EVER_UNCLOAKED = 21,
		WCA_VISUAL_OWNER = 22,
		WCA_HOLOGRAPHIC = 23,
		WCA_EXCLUDED_FROM_DDA = 24,
		WCA_PASSIVEUPDATEMODE = 25,
		WCA_USEDARKMODECOLORS = 26,
		WCA_LAST = 27
	End Enum
	
	Type WINDOWCOMPOSITIONATTRIBDATA
		As WINDOWCOMPOSITIONATTRIB Attrib
		As PVOID pvData
		As SIZE_T cbData
	End Type
	
	Type fnRtlGetNtVersionNumbers As Sub(major As LPDWORD, minor As LPDWORD, build As LPDWORD)
	Type fnSetWindowCompositionAttribute As Function(hWnd As HWND, As WINDOWCOMPOSITIONATTRIBDATA Ptr) As BOOL
	' 1809 17763
	Type fnShouldAppsUseDarkMode As Function() As BOOL ' ordinal 132
	Type fnAllowDarkModeForWindow As Function(hWnd As HWND, allow As BOOL) As BOOL ' ordinal 133
	Type fnAllowDarkModeForApp As Function(allow As BOOL) As BOOL ' ordinal 135, in 1809
	Type fnFlushMenuThemes As Sub() ' ordinal 136
	Type fnRefreshImmersiveColorPolicyState As Sub() ' ordinal 104
	Type fnIsDarkModeAllowedForWindow As Function(hWnd As HWND) As BOOL ' ordinal 137
	Type fnGetIsImmersiveColorUsingHighContrast As Function(mode As IMMERSIVE_HC_CACHE_MODE) As BOOL ' ordinal 106
	Type fnOpenNcThemeData As Function(hWnd As HWND, pszClassList As LPCWSTR) As HTHEME ' ordinal 49
	' 1903 18362
	Type fnShouldSystemUseDarkMode As Function() As BOOL ' ordinal 138
	Type fnSetPreferredAppMode As Function(appMode As PreferredAppMode) As PreferredAppMode ' ordinal 135, in 1903
	Type fnIsDarkModeAllowedForApp As Function() As BOOL ' ordinal 139
	
	#define nullptr 0
	
	Dim Shared As fnSetWindowCompositionAttribute _SetWindowCompositionAttribute = nullptr
	Dim Shared As fnShouldAppsUseDarkMode _ShouldAppsUseDarkMode = nullptr
	Dim Shared As fnAllowDarkModeForWindow _AllowDarkModeForWindow = nullptr
	Dim Shared As fnAllowDarkModeForApp _AllowDarkModeForApp = nullptr
	Dim Shared As fnFlushMenuThemes _FlushMenuThemes = nullptr
	Dim Shared As fnRefreshImmersiveColorPolicyState _RefreshImmersiveColorPolicyState = nullptr
	Dim Shared As fnIsDarkModeAllowedForWindow _IsDarkModeAllowedForWindow = nullptr
	Dim Shared As fnGetIsImmersiveColorUsingHighContrast _GetIsImmersiveColorUsingHighContrast = nullptr
	Dim Shared As fnOpenNcThemeData _OpenNcThemeData = nullptr
	' 1903 18362
	'fnShouldSystemUseDarkMode _ShouldSystemUseDarkMode = nullptr
	Dim Shared As fnSetPreferredAppMode _SetPreferredAppMode = nullptr
	
	'Dim Shared As BOOL g_darkModeSupported = False
	'Dim Shared As BOOL g_darkModeEnabled = False
	Dim Shared As DWORD g_buildNumber = 0
	
	Function ShouldAppsUseDarkMode() As BOOL
		If (_ShouldAppsUseDarkMode = 0) Then
			Return False
		End If
		
		Return _ShouldAppsUseDarkMode()
	End Function
	
	Function AllowDarkModeForWindow(hWnd As HWND, allow As bool) As bool
		If (g_darkModeSupported AndAlso _AllowDarkModeForWindow <> 0) Then
			Return _AllowDarkModeForWindow(hWnd, allow)
		End If
		Return False
	End Function
	
	Function IsHighContrast() As bool
		Dim As HIGHCONTRASTW highContrast = (SizeOf(HIGHCONTRASTW))
		If (SystemParametersInfoW(SPI_GETHIGHCONTRAST, SizeOf(HIGHCONTRASTW), @highContrast, False)) Then
			Return highContrast.dwFlags And HCF_HIGHCONTRASTON
		End If
		Return False
	End Function
	
	Sub SetTitleBarThemeColor(hWnd As HWND, dark As BOOL)
		If (g_buildNumber < 18362) Then
			SetPropW(hWnd, "UseImmersiveDarkModeColors", Cast(HANDLE, Cast(LONG_PTR, dark)))
		ElseIf (_SetWindowCompositionAttribute) Then
			Dim As WINDOWCOMPOSITIONATTRIBDATA Data1 = (WCA_USEDARKMODECOLORS, @dark, SizeOf(dark) )
			_SetWindowCompositionAttribute(hWnd, @Data1)
		End If
	End Sub
	
	Sub RefreshTitleBarThemeColor(hWnd As HWND)
		Dim As BOOL dark = False
		If (_IsDarkModeAllowedForWindow AndAlso _ShouldAppsUseDarkMode) Then
			If (_IsDarkModeAllowedForWindow(hWnd) AndAlso _ShouldAppsUseDarkMode() AndAlso Not IsHighContrast()) Then
				dark = True
			End If
		End If
		
		SetTitleBarThemeColor(hWnd, dark)
	End Sub
	
	Function IsColorSchemeChangeMessage(lParam As LPARAM) As bool
		Dim As bool Is1 = False
		If (lParam AndAlso (0 = lstrcmpi(Cast(LPCWCH, lParam), "ImmersiveColorSet")) AndAlso _RefreshImmersiveColorPolicyState) Then
			_RefreshImmersiveColorPolicyState()
			Is1 = True
		End If
		If (_GetIsImmersiveColorUsingHighContrast) Then
			_GetIsImmersiveColorUsingHighContrast(IHCM_REFRESH)
		End If
		Return Is1
	End Function
	
	Function IsColorSchemeChangeMessage(message As UINT, lParam As LPARAM) As bool
		If (message = WM_SETTINGCHANGE) Then
			Return IsColorSchemeChangeMessage(lParam)
		End If
		Return False
	End Function
	
	Sub AllowDarkModeForApp(allow As bool)
		If (_AllowDarkModeForApp) Then
			_AllowDarkModeForApp(allow)
		ElseIf (_SetPreferredAppMode) Then
			_SetPreferredAppMode(IIf(allow, PreferredAppMode.ForceDark, PreferredAppMode.Default))
		End If
	End Sub
	
	Sub FlushMenuThemes()
		If (_FlushMenuThemes) Then
			_FlushMenuThemes()
		End If
	End Sub
	
	' limit dark scroll bar to specific windows and their children
	
	Dim Shared As List g_darkScrollBarWindows
	Dim Shared As Any Ptr g_darkScrollBarMutex
	g_darkScrollBarMutex = MutexCreate
	
	Sub EnableDarkScrollBarForWindowAndChildren(hwnd As HWND)
		'MutexLock(g_darkScrollBarMutex)
		g_darkScrollBarWindows.add(hwnd)
	End Sub
	
	Function IsWindowOrParentUsingDarkScrollBar(hwnd As HWND) As BOOL
		Dim As HWND hwndRoot = GetAncestor(hwnd, GA_ROOT)
		
		'MutexLock(g_darkScrollBarMutex)
		If (g_darkScrollBarWindows.Contains(hwnd)) Then
			Return True
		End If
		If (hwnd <> hwndRoot AndAlso g_darkScrollBarWindows.Contains(hwndRoot)) Then
			Return True
		End If
		
		Return False
	End Function
	
	Function MyOpenThemeData(hWnd As HWND, classList As LPCWSTR) As HTHEME
		If (wcscmp(classList, @WStr("ScrollBar")) = 0) Then
			If (IsWindowOrParentUsingDarkScrollBar(hWnd)) Then
				hWnd = nullptr
				classList = @WStr("Explorer::ScrollBar")
			End If
		End If
		Return _OpenNcThemeData(hWnd, classList)
	End Function
	
	Sub FixDarkScrollBar()
		Dim As HMODULE hComctl = LoadLibraryEx("comctl32.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32)
		If (hComctl) Then
			Var addr = FindDelayLoadThunkInModule(hComctl, "uxtheme.dll", 49) ' OpenNcThemeData
			If (addr) Then
				Dim As DWORD oldProtect
				If (VirtualProtect(addr, SizeOf(IMAGE_THUNK_DATA), PAGE_READWRITE, @oldProtect) AndAlso _OpenNcThemeData) Then
					'				Var MyOpenThemeData = [](HWND hWnd, LPCWSTR classList) WINAPI_LAMBDA_RETURN(HTHEME) {
					'					If (wcscmp(classList, "ScrollBar") = 0) Then
					'						If (IsWindowOrParentUsingDarkScrollBar(hWnd)) Then
					'							hWnd = nullptr
					'							classList = "Explorer::ScrollBar"
					'						End If
					'					End If
					'					Return _OpenNcThemeData(hWnd, classList)
					'				};
					
					addr->u1.Function = Cast(ULONG_PTR, @MyOpenThemeData)
					VirtualProtect(addr, SizeOf(IMAGE_THUNK_DATA), oldProtect, @oldProtect)
				End If
			End If
		End If
	End Sub
	
	Function CheckBuildNumber(buildNumber As DWORD) As Boolean
		Return (buildNumber = 17763 OrElse _ ' 1809
		buildNumber = 18362 OrElse _ ' 1903
		buildNumber = 18363 OrElse _ ' 1909
		buildNumber = 19041 OrElse _ ' 2004
		buildNumber = 19042 OrElse _ ' 20H2
		buildNumber = 19043 OrElse _ ' 21H1
		buildNumber = 19044 OrElse _ ' 21H2
		(buildNumber > 19044 AndAlso buildNumber < 22000) OrElse _ ' Windows 10 Any version > 21H2
		buildNumber >= 22000)  ' Windows 11 insider builds
	End Function
	
	Function IsWindows11() As BOOL ' Or later OS version
		Return (g_buildNumber >= 22000)
	End Function
	
	Sub InitDarkMode()
		Dim As fnRtlGetNtVersionNumbers RtlGetNtVersionNumbers = nullptr
		Dim As HMODULE hNtdllModule = GetModuleHandle("ntdll.dll")
		If (hNtdllModule) Then
			RtlGetNtVersionNumbers = Cast(fnRtlGetNtVersionNumbers, GetProcAddress(hNtdllModule, "RtlGetNtVersionNumbers"))
		End If
		
		If (RtlGetNtVersionNumbers) Then
			Dim As DWORD major, minor
			RtlGetNtVersionNumbers(@major, @minor, @g_buildNumber)
			g_buildNumber = g_buildNumber And &hF0000000
			If (CBool(major = 10) AndAlso CBool(minor = 0) AndAlso CheckBuildNumber(g_buildNumber)) Then
				Dim As HMODULE hUxtheme = LoadLibraryEx("uxtheme.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32)
				If (hUxtheme) Then
					_OpenNcThemeData = Cast(fnOpenNcThemeData, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(49)))
					_RefreshImmersiveColorPolicyState = Cast(fnRefreshImmersiveColorPolicyState, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(104)))
					_GetIsImmersiveColorUsingHighContrast = Cast(fnGetIsImmersiveColorUsingHighContrast, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(106)))
					_ShouldAppsUseDarkMode = Cast(fnShouldAppsUseDarkMode, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(132)))
					_AllowDarkModeForWindow = Cast(fnAllowDarkModeForWindow, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(133)))
					
					Var ord135 = GetProcAddress(hUxtheme, MAKEINTRESOURCEA(135))
					If (g_buildNumber < 18362) Then
						_AllowDarkModeForApp = Cast(fnAllowDarkModeForApp, ord135)
					Else
						_SetPreferredAppMode = Cast(fnSetPreferredAppMode, ord135)
					End If
					
					_FlushMenuThemes = Cast(fnFlushMenuThemes, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(136)))
					_IsDarkModeAllowedForWindow = Cast(fnIsDarkModeAllowedForWindow, GetProcAddress(hUxtheme, MAKEINTRESOURCEA(137)))
					
					Dim As HMODULE hUser32Module = GetModuleHandleW("user32.dll")
					If (hUser32Module) Then
						_SetWindowCompositionAttribute = Cast(fnSetWindowCompositionAttribute, GetProcAddress(hUser32Module, "SetWindowCompositionAttribute"))
					End If
					
					If (_OpenNcThemeData AndAlso _
						_RefreshImmersiveColorPolicyState AndAlso _
						_ShouldAppsUseDarkMode AndAlso _
						_AllowDarkModeForWindow AndAlso _
						(_AllowDarkModeForApp OrElse _SetPreferredAppMode) AndAlso _
						_FlushMenuThemes AndAlso _
						_IsDarkModeAllowedForWindow) Then
						g_darkModeSupported = True
					End If
				End If
			End If
		End If
	End Sub
#endif

Sub SetDarkMode(useDark As Boolean, fixDarkScrollbar_ As Boolean)
	#ifdef __USE_WINAPI__
		If (g_darkModeSupported) Then
			AllowDarkModeForApp(useDark)
			'_RefreshImmersiveColorPolicyState()
			FlushMenuThemes()
			If (fixDarkScrollbar_) Then
				FixDarkScrollBar()
			End If
			If useDark Then
				g_darkModeEnabled = ShouldAppsUseDarkMode() AndAlso Not IsHighContrast()
			Else
				g_darkModeEnabled = False
			End If
		End If
	#elseif defined(__USE_GTK__)
		#ifdef __USE_GTK3__
			Dim As GValue bValue
			g_value_init_(@bValue, G_TYPE_BOOLEAN)
			g_value_set_boolean(@bValue, useDark)
			g_object_set_property(G_OBJECT(gtk_settings_get_default()), "gtk-application-prefer-dark-theme", @bValue)
			g_value_unset(@bValue)
		#endif
	#endif
End Sub
