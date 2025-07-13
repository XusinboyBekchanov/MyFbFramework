#ifdef __USE_WINAPI__
	#include once "windows.bi"
#endif

Namespace My.Sys.Forms
	Type SystemInformation
	Private:
		FWidth As Integer
		FHeight As Integer
		Declare Static Function GetSize(iWidth As Integer, iHeight As Integer) As My.Sys.Drawing.Size
	Public:
		Declare Static Function DragSize As My.Sys.Drawing.Size
	End Type
End Namespace

#include once "SystemInformation.bas"
