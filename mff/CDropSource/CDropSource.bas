#include once "CDropSource.bi"
#include once "../Control.bi"
'#include once "crt/string.bi"

Namespace My.Sys.Forms
	#ifdef __USE_WINAPI__
		''
		'' Constructor for the CDropSource class
		''
		Constructor CDropSource()
			Static As IDropSourceVtbl vtbl = _
			( _
			@CDropSource.QueryInterface, _
			@CDropSource.AddRef, _
			@CDropSource.Release, _ '
			@CDropSource.QueryContinueDrag, _
			@CDropSource.GiveFeedback _
			)
			
			m_DropSource.lpVtbl = @vtbl
			
			m_lRefCount  = 1
			
			'' acquire a strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), True, False)
		End Constructor
		
		''
		'' Destructor for the CDropSource class
		''
		Destructor CDropSource()
			
			'' remove the strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), False, True)
			
			'' release our own reference
			m_DropSource.lpVtbl->Release(@m_DropSource)
			
		End Destructor
		
		
		''
		''  IUnknown::QueryInterface
		''
		Private Function CDropSource.QueryInterface _
			(ByVal pInst As IDropSource Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Dim As CDropSource Ptr _this = Cast(CDropSource Ptr, pInst)
			
			If ( (memcmp( iid, @IID_IUnknown, Len( GUID ) ) = 0) Or _
				(memcmp( iid, @IID_IDropSource, Len( GUID ) ) = 0) ) Then
				CDropSource.AddRef( pInst )
				*ppvObject = pInst
				Return S_OK
			Else
				*ppvObject = NULL
				Return E_NOINTERFACE
			End If
			
		End Function
		
		''
		''  IUnknown::AddRef
		''
		Private Function CDropSource.AddRef _
			(ByVal pInst As IDropSource Ptr) As ULong
			
			Dim As CDropSource Ptr _this = Cast(CDropSource Ptr, pInst)
			
			Return InterlockedIncrement(@_this->m_lRefCount)
		End Function
		
		''
		''  IUnknown::Release
		''
		Private Function CDropSource.Release _
			(ByVal pInst As IDropSource Ptr) As ULong
			
			Dim As CDropSource Ptr _this = Cast(CDropSource Ptr, pInst)
			
			Dim As Long count = InterlockedDecrement(@_this->m_lRefCount)
			
			If (count = 0) Then
				Return 0
			Else
				Return count
			End If
		End Function
		
		''
		''  IDropSource::QueryContinueDrag
		''
		Private Function CDropSource.QueryContinueDrag _
			(ByVal This As IDropSource Ptr, ByVal fEscapePressed As WINBOOL, ByVal grfKeyState As DWORD) As HRESULT
			
			Dim As CDropSource Ptr _this = Cast(CDropSource Ptr, This)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			Dim As DragAction Action
			
			If fEscapePressed Then
				Action = DRAGDROP_S_CANCEL
			ElseIf (grfKeyState And MK_LBUTTON) = 0 Then
				Action = DRAGDROP_S_DROP
			Else
				Action = S_OK
			End If
			
			If cCtrl->OnQueryContinueDrag Then cCtrl->OnQueryContinueDrag(*cCtrl->Designer, *cCtrl, Action, fEscapePressed, grfKeyState)
			
			Return Action
		End Function
		
		''
		''  IDropSource::GiveFeedback
		''
		Private Function CDropSource.GiveFeedback _
			(ByVal This As IDropSource Ptr, ByVal dwEffect As DWORD) As HRESULT
			
			Dim As CDropSource Ptr _this = Cast(CDropSource Ptr, This)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			Dim As DragDropEffects Effect = dwEffect
			
			Dim As Boolean UseDefaultCursors = True
			
			If cCtrl->OnGiveFeedback Then cCtrl->OnGiveFeedback(*cCtrl->Designer, *cCtrl, Effect, UseDefaultCursors)
			
			If UseDefaultCursors Then
				Return DRAGDROP_S_USEDEFAULTCURSORS
			Else
				Return S_OK
			End If
		End Function
	#endif
End Namespace
