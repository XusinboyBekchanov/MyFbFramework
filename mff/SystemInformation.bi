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
	   Declare Static Function ScreenWidth As Integer
       Declare Static Function ScreenHeight As Integer
       Declare Static Function MouseButtons As Integer
       Declare Static Function DoubleClickSize As My.Sys.Drawing.Size
       Declare Static Function WorkingArea As My.Sys.Drawing.Rect
       Declare Static Function BorderSize As My.Sys.Drawing.Size
       Declare Static Function MaxWindowTrackSize As My.Sys.Drawing.Size
		
	End Type
End Namespace

#include once "SystemInformation.bas"