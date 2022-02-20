'###############################################################################
'#  Sys.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: José Roca (2016), Xusinboy Bekchanov                              #
'#  Windows version functions based on WinFBX/Afx/AfxWin.inc                   #
'###############################################################################

#ifndef __USE_GTK__
	#define UNICODE
	#include once "windows.bi"
#endif

Namespace My
	Namespace Sys
		Private Function Name As String
			#ifdef __USE_GTK__
				Return "Linux"
			#else
				Return "Windows"
			#endif
		End Function
		
		Private Function Version As Long
			#ifdef __USE_GTK__
				
			#else
				' ========================================================================================
				' Returns the Windows version
				' Platform 1:
				'   400 Windows 95
				'   410 Windows 98
				'   490 Windows ME
				' Platform 2:
				'   400 Windows NT
				'   500 Windows 2000
				'   501 Windows XP
				'   502 Windows Server 2003
				'   600 Windows Vista and Windows Server 2008
				'   601 Windows 7
				'   602 Windows 8
				'   603 Windows 8.1
				' Note: As Windows 95 and Windows NT return the same version number, we also need to call
				' GetWindowsPlatform to differentiate them.
				' ========================================================================================
				Dim dwVersion As DWORD
				Dim As Long nMajorVer, nMinorVer
				dwVersion = GetVersion
				nMajorVer = LoByte(LoWord(dwVersion))
				nMinorVer = HiByte(LoWord(dwVersion))
				Return (nMajorVer + nMinorVer / 100) * 100
			#endif
		End Function
		
		Private Function Build As Long
			#ifdef __USE_GTK__
				
			#else
				' ========================================================================================
				' Returns the Windows build
				' ========================================================================================
				Dim dwVersion As DWORD
				dwVersion = GetVersion
				If dwVersion < &H80000000 Then Return HiWord(dwVersion)
			#endif
		End Function
		
		Private Function Platform As Long
			#ifdef __USE_GTK__
				
			#else
				' ========================================================================================
				' Returns the Windows platform
				'   1 Windows 95/98/ME
				'   2 Windows NT/2000/XP/Server/Vista/Windows 7
				' ========================================================================================
				Dim dwVersion As DWORD
				dwVersion = GetVersion
				Return IIf(dwVersion < &H80000000, 2, 1)
			#endif
		End Function
	End Namespace
End Namespace
