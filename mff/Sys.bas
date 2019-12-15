'###############################################################################
'#  Sys.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: José Roca (2016), Xusinboy Bekchanov                              #
'#  Windows version functions based on WinFBX/Afx/AfxWin.inc                   #
'###############################################################################

Namespace My
	Namespace Sys
		Function Name As String
			#If __USE_GTK__ 
				Return "Linux"
			#Else
				Return "Windows"
			#Endif
		End Function
		
		Function Version As Long
			#If __USE_GTK__ 
				
			#Else
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
				DIM dwVersion AS DWORD
				DIM AS LONG nMajorVer, nMinorVer
				dwVersion = GetVersion
				nMajorVer = LOBYTE(LOWORD(dwVersion))
				nMinorVer = HIBYTE(LOWORD(dwVersion))
				Return (nMajorVer + nMinorVer / 100) * 100
			#Endif
		End Function
		
		Function Build As Long
			#If __USE_GTK__ 
				
			#Else
				' ========================================================================================
				' Returns the Windows build
				' ========================================================================================
				DIM dwVersion AS DWORD
				dwVersion = GetVersion
				If dwVersion < &H80000000 Then Return HiWord(dwVersion)
			#Endif
		End Function
		
		Function Platform As Long
			#If __USE_GTK__ 
				
			#Else
				' ========================================================================================
				' Returns the Windows platform
				'   1 Windows 95/98/ME
				'   2 Windows NT/2000/XP/Server/Vista/Windows 7
				' ========================================================================================
				DIM dwVersion AS DWORD
				dwVersion = GetVersion
				Return IIF(dwVersion < &H80000000, 2, 1)
			#Endif
		End Function
	End Namespace
End Namespace
