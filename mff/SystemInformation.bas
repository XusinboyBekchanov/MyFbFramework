#include once "SystemInformation.bi"

Namespace My.Sys.Forms
	Private Function SystemInformation.GetSize(iWidth As Integer, iHeight As Integer) As My.Sys.Drawing.Size
		#ifdef __USE_WINAPI__
			Return Type<My.Sys.Drawing.Size>(GetSystemMetrics(iWidth), GetSystemMetrics(iHeight))
		#else
			Return Type<My.Sys.Drawing.Size>(0, 0)
		#endif
	End Function
	
	Private Function SystemInformation.DragSize As My.Sys.Drawing.Size
		#ifdef __USE_WINAPI__
			Return GetSize(SM_CXDRAG, SM_CYDRAG)
		#else
			Return GetSize(0, 0)
		#endif
	End Function
End Namespace

