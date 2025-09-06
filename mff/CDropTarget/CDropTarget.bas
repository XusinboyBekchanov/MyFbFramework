''
'' IDropTarget example for text objects, translated from a C++ code written by J Brown 2004 (www.catch22.net)
''

#include once "CDropTarget.bi"
#include once "../CDataObject/CDataObject.bi"
#include once "../Control.bi"
'#include once "crt/string.bi"

Namespace My.Sys.Forms
	Function DataObject.GetDataPresent(DataType As DataFormats) As Boolean
		#ifdef __USE_WINAPI__
			If pDataObject = 0 Then pDataObject = Cast(IDataObject Ptr, New CDataObject)
			Dim As FORMATETC fmtetc = (DataType, 0, DVASPECT_CONTENT, -1, IIf(DataType = DataFormats.dfBitmap, TYMED_GDI, TYMED_HGLOBAL))
			Return pDataObject->lpVtbl->QueryGetData(pDataObject, @fmtetc) = S_OK
		#else
			Return False
		#endif
	End Function
	
	Function DataObject.GetData(DataType As DataFormats) As Any Ptr
		#ifdef __USE_WINAPI__
			If pDataObject = 0 Then pDataObject = Cast(IDataObject Ptr, New CDataObject)
			Dim As FORMATETC fmtetc = (DataType, 0, DVASPECT_CONTENT, -1, IIf(DataType = DataFormats.dfBitmap, TYMED_GDI, TYMED_HGLOBAL))
			Dim As STGMEDIUM stgmed
			If ( pDataObject->lpVtbl->QueryGetData(pDataObject, @fmtetc) = S_OK) Then
				If (pDataObject->lpVtbl->GetData(pDataObject, @fmtetc, @stgmed) = S_OK) Then
					Dim As Any Ptr Result
					Dim As PVOID data_ = GlobalLock(stgmed.hGlobal)
					If DataType = DataFormats.dfText Then
						ZLet(Cast(ZString Ptr, Result), *Cast(ZString Ptr, data_))
					ElseIf DataType = DataFormats.dfUnicodeText Then
						WLet(Cast(WString Ptr, Result), *Cast(WString Ptr, data_))
					ElseIf DataType = DataFormats.dfBitmap Then
						Result = New My.Sys.Drawing.BitmapType
						Cast(My.Sys.Drawing.BitmapType Ptr, Result)->Handle = CopyImage(stgmed.hBitmap, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION)
					ElseIf DataType = DataFormats.dfENHMetaFile Then
						Result = CopyEnhMetaFile(data_, 0)
					Else
						Result = 0
					End If
					GlobalUnlock(stgmed.hGlobal)
					ReleaseStgMedium(@stgmed)
					Return Result
				End If
			End If
		#endif
		Return 0
	End Function
	
	Private Sub DataObject.SetData(DataType As DataFormats, pData As Any Ptr, Bytes As Integer = 0)
		#ifdef __USE_WINAPI__
			If pDataObject = 0 Then pDataObject = Cast(IDataObject Ptr, New CDataObject)
			Dim fe  As FORMATETC
			Dim stm As STGMEDIUM
			memset(@fe, 0, SizeOf(FORMATETC))
			memset(@stm, 0, SizeOf(STGMEDIUM))
			fe.cfFormat = DataType
			Select Case DataType
			Case DataFormats.dfText
				Dim As size_t NewBytes = Bytes
				If NewBytes = 0 Then NewBytes = (Len(*Cast(ZString Ptr, pData)) + 1) * SizeOf(ZString)
				fe.tymed    = TYMED_HGLOBAL
				Var h = GlobalAlloc(GMEM_MOVEABLE, NewBytes)
				Var z = GlobalLock(h)
				*Cast(ZString Ptr, z) = *Cast(ZString Ptr, pData)
				GlobalUnlock(h)
				stm.tymed = TYMED_HGLOBAL : stm.hGlobal = h
			Case DataFormats.dfUnicodeText
				Dim As size_t NewBytes = Bytes
				If NewBytes = 0 Then NewBytes = (Len(*Cast(WString Ptr, pData)) + 1) * SizeOf(WString)
				fe.tymed    = TYMED_HGLOBAL
				Var h = GlobalAlloc(GMEM_MOVEABLE, NewBytes)
				Var w = GlobalLock(h)
				*Cast(WString Ptr, w) = *Cast(WString Ptr, pData)
				GlobalUnlock(h)
				stm.tymed = TYMED_HGLOBAL : stm.hGlobal = h
			Case DataFormats.dfHDrop
				fe.tymed    = TYMED_HGLOBAL
				stm.tymed = TYMED_HGLOBAL : stm.hGlobal = *Cast(HGLOBAL Ptr, pData)
			Case DataFormats.dfDIB
				fe.tymed    = TYMED_HGLOBAL
				stm.tymed   = TYMED_HGLOBAL : stm.hGlobal = *Cast(HGLOBAL Ptr, pData)
			Case DataFormats.dfBitmap
				fe.tymed    = TYMED_GDI
				stm.tymed   = TYMED_GDI : stm.hBitmap = Cast(My.Sys.Drawing.BitmapType Ptr, pData)->Handle
			Case Else
				fe.tymed    = TYMED_HGLOBAL
				Var h = GlobalAlloc(GMEM_MOVEABLE, Bytes)
				memcpy(GlobalLock(h), pData, Bytes)
				GlobalUnlock(h)
				stm.tymed = TYMED_HGLOBAL : stm.hGlobal = h
			End Select
			
			fe.dwAspect = DVASPECT_CONTENT
			fe.lindex   = -1
			
			Cast(CDataObject Ptr, pDataObject)->SetData(pDataObject, @fe, @stm, True)
		#endif
	End Sub
	
	Private Sub DataObject.GetFileDropList(filePaths() As UString)
		#ifdef __USE_WINAPI__
			If pDataObject = 0 Then pDataObject = Cast(IDataObject Ptr, New CDataObject)
			Dim As FORMATETC fmtetc = (DataFormats.dfHDrop, 0, DVASPECT_CONTENT, -1, TYMED_HGLOBAL)
			Dim As STGMEDIUM stgmed
			If ( pDataObject->lpVtbl->QueryGetData(pDataObject, @fmtetc) = S_OK) Then
				If (pDataObject->lpVtbl->GetData(pDataObject, @fmtetc, @stgmed) = S_OK) Then
					Var iDrop = Cast(HDROP, stgmed.hGlobal)
					Dim As Integer filecount, length, i
					filecount = DragQueryFile(iDrop, -1, NULL, 0)
					ReDim filePaths(filecount - 1)
					Dim As WString Ptr filename
					WReAllocate(filename, MAX_PATH)
					For i = 0 To filecount - 1
						length = DragQueryFile(iDrop, i, filename, MAX_PATH)
						filePaths(i) = Left(*filename, length)
					Next
					_Deallocate(filename)
					DragFinish iDrop
					ReleaseStgMedium(@stgmed)
				End If
			End If
		#endif
	End Sub
	
	Private Sub DataObject.SetFileDropList(filePaths() As UString)
		#ifdef __USE_WINAPI__
			Dim total As Integer = 0
			For i As Integer = LBound(filePaths) To UBound(filePaths)
				total += (Len(filePaths(i)) + 1) * SizeOf(WString)
			Next
			Var hMem = GlobalAlloc(GMEM_SHARE Or GMEM_MOVEABLE Or GMEM_ZEROINIT, SizeOf(DROPFILES) + total + SizeOf(WString))
			Var p = GlobalLock(hMem)
			Var pd = Cast(DROPFILES Ptr, p)
			pd->pFiles = SizeOf(DROPFILES)
			pd->fWide  = True
			Var pCur = Cast(WString Ptr, Cast(UByte Ptr, p) + SizeOf(DROPFILES))
			Var pCur1 = pCur
			For i As Integer = LBound(filePaths) To UBound(filePaths)
				Var srcSizeOf = (Len(filePaths(i)) + 1) * SizeOf(WString)
				memcpy(pCur, filePaths(i).m_Data, srcSizeOf)
				pCur += Len(filePaths(i)) + 1
			Next
			(*pCur)[0] = 0
			GlobalUnlock(hMem)
			SetData DataFormats.dfHDrop, @hMem
		#endif
	End Sub
	
	#ifdef __USE_WINAPI__
		''
		'' Constructor for the CDropTarget class
		''
		Constructor CDropTarget()
			'' IDropTarget implementation (while there's no support for virtual methods and inheritance)
			Static As IDropTargetVtbl vtbl = _
			( _
			@CDropTarget.QueryInterface, _
			@CDropTarget.AddRef, _
			@CDropTarget.Release, _'
			@CDropTarget.DragEnter, _
			@CDropTarget.DragOver, _
			@CDropTarget.DragLeave, _
			@CDropTarget.Drop _
			)
			
			m_DropTarget.lpVtbl = @vtbl
			
			m_lRefCount  = 1
			m_fAllowDrop = False
			
			'' acquire a strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), True, False)
		End Constructor
		
		Private Sub CDropTarget.AllowDrop(Value As Boolean)
			If m_hWnd Then
				If Value Then
					'' tell OLE that the window is a drop target
					RegisterDragDrop(m_hWnd, Cast(LPDROPTARGET, @This))
				Else
					'' remove drag+drop
					RevokeDragDrop(m_hWnd)
				End If
			End If
		End Sub
		''
		'' Destructor for the CDropTarget class
		''
		Destructor CDropTarget()
			
			'' remove the strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), False, True)
			
			'' release our own reference
			m_DropTarget.lpVtbl->Release(@m_DropTarget)
			
		End Destructor
		
		
		''
		''  IUnknown::QueryInterface
		''
		Private Function CDropTarget.QueryInterface _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			If ( (memcmp( iid, @IID_IUnknown, Len( GUID ) ) = 0) Or _
				(memcmp( iid, @IID_IDropTarget, Len( GUID ) ) = 0) ) Then
				CDropTarget.AddRef( pInst )
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
		Private Function CDropTarget.AddRef _
			(ByVal pInst As IDropTarget Ptr) As ULong
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Return InterlockedIncrement(@_this->m_lRefCount)
		End Function
		
		''
		''  IUnknown::Release
		''
		Private Function CDropTarget.Release _
			(ByVal pInst As IDropTarget Ptr) As ULong
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Dim As Long count = InterlockedDecrement(@_this->m_lRefCount)
			
			If (count = 0) Then
				Return 0
			Else
				Return count
			End If
		End Function
		
		''
		''  IDropTarget::DragEnter
		''
		Private Function CDropTarget.DragEnter _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal pDataObject As IDataObject Ptr, ByVal grfKeyState As DWORD, _
			ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			Dim Data1 As DataObject
			Data1.pDataObject = pDataObject
			Dim As DragDropEffects AllowedEffect = *pdwEffect, Effect = _this->DropEffect(grfKeyState, pt, *pdwEffect)
			If cCtrl->OnDragEnter Then cCtrl->OnDragEnter(*cCtrl->Designer, *cCtrl, Data1, AllowedEffect, Effect, grfKeyState, pt.x, pt.y)
			*pdwEffect = Effect
			
			_this->m_fAllowDrop = Effect <> DragDropEffects.deNone
			_this->m_pDataObject = pDataObject
			
			Return S_OK
		End Function
		
		''
		''  IDropTarget::DragOver
		''
		Private Function CDropTarget.DragOver _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal grfKeyState As DWORD, ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			Dim Data1 As DataObject
			Data1.pDataObject = _this->m_pDataObject
			Dim As DragDropEffects AllowedEffect = *pdwEffect, Effect = _this->DropEffect(grfKeyState, pt, *pdwEffect)
			If cCtrl->OnDragOver Then cCtrl->OnDragOver(*cCtrl->Designer, *cCtrl, Data1, AllowedEffect, Effect, grfKeyState, pt.x, pt.y)
			*pdwEffect = Effect
			
			_this->m_fAllowDrop = Effect <> DragDropEffects.deNone
			
			Return S_OK
		End Function
		
		''
		''  IDropTarget::DragLeave
		''
		Private Function CDropTarget.DragLeave _
			(ByVal pInst As IDropTarget Ptr) As HRESULT
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			If cCtrl->OnDragLeave Then cCtrl->OnDragLeave(*cCtrl->Designer, *cCtrl)
			
			Return S_OK
		End Function
		
		''
		''  IDropTarget::Drop
		''
		Private Function CDropTarget.Drop _
			(ByVal pInst As IDropTarget Ptr, _
			ByVal pDataObject As IDataObject Ptr, ByVal grfKeyState As DWORD, _
			ByVal pt As POINTL, ByVal pdwEffect As DWORD Ptr) As HRESULT
			
			Dim As CDropTarget Ptr _this = Cast(CDropTarget Ptr, pInst)
			
			Dim As Control Ptr cCtrl = _this->Ctrl
			
			Dim Data1 As DataObject
			Data1.pDataObject = pDataObject
			Dim As DragDropEffects AllowedEffect = *pdwEffect, Effect = _this->DropEffect(grfKeyState, pt, *pdwEffect)
			If cCtrl->OnDragDrop Then cCtrl->OnDragDrop(*cCtrl->Designer, *cCtrl, Data1, AllowedEffect, Effect, grfKeyState, pt.x, pt.y)
			*pdwEffect = Effect
			
			_this->m_fAllowDrop = Effect <> DragDropEffects.deNone
			
			Return S_OK
		End Function
		
		''
		'' Position the edit control's caret under the mouse
		''
		Private Sub CDropTarget.PositionCursor _
			(ByVal pt As POINTL)
			
			Dim As DWORD curpos
			
			'' get the character position of mouse
			ScreenToClient(m_hWnd, Cast(Point Ptr, @pt))
			curpos = SendMessage(m_hWnd, EM_CHARFROMPOS, 0, MAKELPARAM(pt.x, pt.y))
			
			'' set cursor position
			SendMessage(m_hWnd, EM_SETSEL, LoWord(curpos), LoWord(curpos))
		End Sub
		
		''
		''
		''
		Private Sub CDropTarget.DropData _
			(ByVal pDataObject As IDataObject Ptr)
			
			'' construct a FORMATETC object
			Dim As FORMATETC fmtetc = ( CF_TEXT, 0, DVASPECT_CONTENT, -1, TYMED_HGLOBAL )
			Dim As STGMEDIUM stgmed
			
			'' See if the dataobject contains any TEXT stored as a HGLOBAL
			If ( pDataObject->lpVtbl->QueryGetData(pDataObject, @fmtetc) = S_OK) Then
				'' Yippie! the data is there, so go get it!
				If (pDataObject->lpVtbl->GetData(pDataObject, @fmtetc, @stgmed) = S_OK) Then
					'' we asked for the data as a HGLOBAL, so access it appropriately
					Dim As PVOID data_ = GlobalLock(stgmed.hGlobal)
					
					SetWindowText(m_hWnd, Cast(WString Ptr, data_))
					
					GlobalUnlock(stgmed.hGlobal)
					
					'' release the data using the COM API
					ReleaseStgMedium(@stgmed)
				End If
			End If
		End Sub
		
		''
		''  QueryDataObject private helper routine
		''
		Private Function CDropTarget.QueryDataObject _
			(ByVal pDataObject As IDataObject Ptr) As Integer
			
			Dim As FORMATETC fmtetc = ( CF_TEXT, 0, DVASPECT_CONTENT, -1, TYMED_HGLOBAL )
			
			Return pDataObject->lpVtbl->QueryGetData(pDataObject, @fmtetc) = S_OK
		End Function
		
		''
		''  DropEffect private helper routine
		''
		Private Function CDropTarget.DropEffect _
			(ByVal grfKeyState As DWORD, ByVal pt As POINTL, ByVal dwAllowed As DWORD ) As DWORD
			
			Dim As DWORD dwEffect = 0
			
			If (grfKeyState And MK_CONTROL) Then
				dwEffect = dwAllowed And DROPEFFECT_COPY
			ElseIf(grfKeyState And MK_SHIFT) Then
				dwEffect = dwAllowed And DROPEFFECT_MOVE
			End If
			
			If (dwEffect = 0) Then
				If (dwAllowed And DROPEFFECT_COPY) Then dwEffect = DROPEFFECT_COPY
				If (dwAllowed And DROPEFFECT_MOVE) Then dwEffect = DROPEFFECT_MOVE
			End If
			
			Return dwEffect
		End Function
	#endif
End Namespace
