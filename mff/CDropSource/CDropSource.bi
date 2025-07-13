#ifdef __USE_WINAPI__
	#include once "windows.bi"
	#include once "win/ole2.bi"
#endif

Namespace My.Sys.Forms
	#ifdef __USE_WINAPI__
		Type CDropSource
		Private:
			'' implements IDropTarget
			Dim As IDropSource m_DropSource = Any
			
		Public:
			Declare Constructor()
			Declare Destructor()
			
		Private:
			'' IDropTarget implementation (while there's no support for virtual methods and inheritance)
			Declare Static Function QueryInterface _
			(ByVal pInst As IDropSource Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Declare Static Function AddRef _
			(ByVal pInst As IDropSource Ptr) As ULong
			
			Declare Static Function Release _
			(ByVal pInst As IDropSource Ptr) As ULong
			
			Declare Static Function QueryContinueDrag _
			(ByVal This As IDropSource Ptr, ByVal fEscapePressed As WINBOOL, ByVal grfKeyState As DWORD) As HRESULT
			
			Declare Static Function GiveFeedback _
			(ByVal This As IDropSource Ptr, ByVal dwEffect As DWORD) As HRESULT

		Public:
			'' member variables
			As Any Ptr Ctrl
			As Long m_lRefCount = Any
			As IDataObject Ptr m_pDataObject = Any
		End Type
	#endif
End Namespace

