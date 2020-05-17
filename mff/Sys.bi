'###############################################################################
'#  Sys.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: José Roca (2016), Xusinboy Bekchanov                              #
'#  Windows version functions based on WinFBX/Afx/AfxWin.inc                   #
'###############################################################################

Namespace My
	Namespace Sys
		Declare Function Name As String
		
		Declare Function Version As Long
		
		Declare Function Build As Long
		
		Declare Function Platform As Long
	End Namespace
End Namespace

#ifndef __USE_MAKE__
	#include once "Sys.bas"
#endif
