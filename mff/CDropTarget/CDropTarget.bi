#ifdef __USE_WINAPI__
	#include once "windows.bi"
	#include once "win/ole2.bi"
#endif

Namespace My.Sys.Forms
	#ifdef __USE_WINAPI__
		Type CDropTarget
		Private:
			'' implements IDropTarget
			Dim As IDropTarget m_DropTarget = Any
			
		Public:
			Declare Constructor()
			Declare Destructor()
			
		Private:
			'' IDropTarget implementation (while there's no support for virtual methods and inheritance)
			Declare Static Function QueryInterface _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Declare Static Function AddRef _
			(ByVal pInst As IDropTarget Ptr) As ULong
			
			Declare Static Function Release _
			(ByVal pInst As IDropTarget Ptr) As ULong
			
			Declare Static Function DragEnter _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal pDataObject As IDataObject Ptr, ByVal grfKeyState As DWORD, _
			ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			Declare Static Function DragOver _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal grfKeyState As DWORD, ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			Declare Static Function DragLeave _
			(ByVal pInst As IDropTarget Ptr) As HRESULT
			
			Declare Static Function Drop _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal pDataObject As IDataObject Ptr, ByVal grfKeyState As DWORD, _
			ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			'' internal helper function
			Declare Sub PositionCursor(ByVal pt As POINTL)
			Declare Sub DropData(ByVal pDataObject As IDataObject Ptr)
			Declare Function DropEffect(ByVal grfKeyState As DWORD, ByVal pt As POINTL, ByVal dwAllowed As DWORD) As DWORD
			Declare Function QueryDataObject(ByVal pDataObject As IDataObject Ptr) As Integer
			
		Public:
			Declare Sub AllowDrop(Value As Boolean)
			'' member variables
			As Any Ptr Ctrl
			As Long m_lRefCount = Any
			As HWND m_hWnd = Any
			As Integer m_fAllowDrop = Any
			As IDataObject Ptr m_pDataObject = Any
		End Type
	#endif
End Namespace

