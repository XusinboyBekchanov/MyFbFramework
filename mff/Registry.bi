#include once "mff/SysUtils.bi"
#include once "vbcompat.bi"

' Possible registry data types
Enum InTypes
	ValNull = 0
	ValString = 1
	ValXString = 2
	ValBinary = 3
	ValDWord = 4
	ValLink = 6
	ValMultiString = 7
	ValResList = 8
End Enum

#ifndef __USE_GTK__
	' Registry section definitions
	'Const HKEY_CLASSES_ROOT = &H80000000
	'Const HKEY_CURRENT_USER = &H80000001
	'Const HKEY_LOCAL_MACHINE = &H80000002
	'Const HKEY_USERS = &H80000003
	'Const HKEY_PERFORMANCE_DATA = &H80000004
	'Const HKEY_CURRENT_CONFIG = &H80000005
	
	Declare Function ReadRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR) As String
	
	Declare Sub WriteRegistry(ByVal Group As HKEY, ByVal Section As LPCWSTR, ByVal Key As LPCWSTR, ByVal ValType As InTypes, value As String)
#endif

#ifndef __USE_MAKE__
	#include once "Registry.bas"
#endif
