#include once "CDataObject.bi"
#include once "../Control.bi"
'#include once "crt/string.bi"

Namespace My.Sys.Forms
	#ifdef __USE_WINAPI__
		''
		'' Constructor for the CDataObject class
		''
		Constructor CDataObject()
			Static As IDataObjectVtbl vtbl = _
			( _
			@CDataObject.QueryInterface, _
			@CDataObject.AddRef, _
			@CDataObject.Release, _ '
			@CDataObject.GetData, _
			@CDataObject.GetDataHere, _
			@CDataObject.QueryGetData, _
			@CDataObject.GetCanonicalFormatEtc, _
			@CDataObject.SetData, _
			@CDataObject.EnumFormatEtc, _
			@CDataObject.DAdvise, _
			@CDataObject.DUnadvise, _
			@CDataObject.EnumDAdvise _
			)
			
			m_DataObject.lpVtbl = @vtbl
			
			m_lRefCount  = 1
			
			'' acquire a strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), True, False)
		End Constructor
		
		''
		'' Destructor for the CDataObject class
		''
		Destructor CDataObject()
			
			'' remove the strong lock
			CoLockObjectExternal(Cast(LPUNKNOWN, @This), False, True)
			
			'' release our own reference
			m_DataObject.lpVtbl->Release(@m_DataObject)
			
		End Destructor
		
		
		''
		''  IUnknown::QueryInterface
		''
		Private Function CDataObject.QueryInterface _
			(ByVal pInst As IDataObject Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, pInst)
			
			If ( (memcmp( iid, @IID_IUnknown, Len( GUID ) ) = 0) Or _
				(memcmp( iid, @IID_IDataObject, Len( GUID ) ) = 0) ) Then
				CDataObject.AddRef( pInst )
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
		Private Function CDataObject.AddRef _
			(ByVal pInst As IDataObject Ptr) As ULong
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, pInst)
			
			Return InterlockedIncrement(@_this->m_lRefCount)
		End Function
		
		''
		''  IUnknown::Release
		''
		Private Function CDataObject.Release _
			(ByVal pInst As IDataObject Ptr) As ULong
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, pInst)
			
			Dim As Long count = InterlockedDecrement(@_this->m_lRefCount)
			
			If (count = 0) Then
				Return 0
			Else
				Return count
			End If
		End Function
		
		''
		''  IDataObject::GetData
		''
		Private Function CDataObject.GetData _
			(ByVal This As IDataObject Ptr, ByVal pformatetcIn As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr) As HRESULT
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, This)
			
			If pformatetcIn = 0 Or pmedium = 0 Then Return E_INVALIDARG
			
			Dim idx As Long = _this->FindSlot(pformatetcIn)
			If idx < 0 Then Return DV_E_FORMATETC
			
			Dim storedFE  As FORMATETC Ptr  = @_this->slots(idx).fe
			Dim storedSTM As STGMEDIUM Ptr = @_this->slots(idx).stm
			
			If ((storedFE->tymed And pformatetcIn->tymed) = 0) Then
				Return DV_E_TYMED
			End If
			
			Select Case storedSTM->tymed
				' --- TYMED_HGLOBAL ---
			Case TYMED_HGLOBAL
				pmedium->tymed = TYMED_HGLOBAL
				'pmedium->hGlobal = OleDuplicateData( _
				'storedSTM->hGlobal, _
				'storedFE->cfFormat, _
				'GMEM_MOVEABLE)
				pmedium->hGlobal = storedSTM->hGlobal
				If pmedium->hGlobal = 0 Then Return STG_E_MEDIUMFULL
				
				' --- TYMED_GDI ---
			Case TYMED_GDI
				pmedium->tymed = TYMED_GDI
				pmedium->hBitmap = CopyImage( _
				storedSTM->hBitmap, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION)
				If pmedium->hBitmap = 0 Then Return STG_E_MEDIUMFULL
				
				' --- TYMED_ENHMF ---
			Case TYMED_ENHMF
				pmedium->tymed = TYMED_ENHMF
				pmedium->hEnhMetaFile = CopyEnhMetaFileW( _
				storedSTM->hEnhMetaFile, NULL)
				If pmedium->hEnhMetaFile = 0 Then Return STG_E_MEDIUMFULL
				
				' --- TYMED_MF ---
			Case TYMED_MFPICT
				pmedium->tymed = TYMED_MFPICT
				pmedium->hMetaFilePict = CopyMetaFile( _
				storedSTM->hMetaFilePict, NULL)
				If pmedium->hMetaFilePict = 0 Then Return STG_E_MEDIUMFULL
				
				' --- TYMED_ISTREAM ---
			Case TYMED_ISTREAM
				pmedium->tymed = TYMED_ISTREAM
				pmedium->pstm = storedSTM->pstm
				If pmedium->pstm = 0 Then Return STG_E_MEDIUMFULL
				pmedium->pstm->lpVtbl->AddRef(pmedium->pstm)
				
				' --- TYMED_ISTORAGE ---
			Case TYMED_ISTORAGE
				pmedium->tymed = TYMED_ISTORAGE
				pmedium->pstg = storedSTM->pstg
				If pmedium->pstg = 0 Then Return STG_E_MEDIUMFULL
				pmedium->pstg->lpVtbl->AddRef(pmedium->pstg)
				
				' --- TYMED_FILE ---
			Case TYMED_FILE
				If storedSTM->lpszFileName = 0 Then Return STG_E_MEDIUMFULL
				Var Size = (lstrlenW(storedSTM->lpszFileName) + 1) * SizeOf(WString)
				pmedium->lpszFileName = CoTaskMemAlloc(Size)
				If pmedium->lpszFileName = 0 Then Return STG_E_MEDIUMFULL
				memcpy(pmedium->lpszFileName, storedSTM->lpszFileName, Size)
				pmedium->tymed = TYMED_FILE
				
			Case Else
				Return DV_E_TYMED
			End Select
			
			pmedium->pUnkForRelease = 0
			Return S_OK
		End Function
		
		''
		''  IDataObject::GetDataHere
		''
		Private Function CDataObject.GetDataHere _
			(ByVal This As IDataObject Ptr, ByVal pformatetcIn As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr) As HRESULT
			
			Return E_NOTIMPL
			
		End Function
		
		''
		''  IDataObject::QueryGetData
		''
		Private Function CDataObject.QueryGetData _
			(ByVal This As IDataObject Ptr, ByVal pformatetcIn As FORMATETC Ptr) As HRESULT
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, This)
			
			Return IIf(_this->FindSlot(pformatetcIn) <> -1, S_OK, DV_E_FORMATETC)
			
		End Function
		
		''
		''  IDataObject::GetCanonicalFormatEtc
		''
		Private Function CDataObject.GetCanonicalFormatEtc _
			(ByVal This As IDataObject Ptr, ByVal pformatectIn As FORMATETC Ptr, ByVal pformatetcOut As FORMATETC Ptr) As HRESULT
			
			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, This)
			
			If pformatetcOut = 0 Then Return E_POINTER
			
			memset(pformatetcOut, 0, SizeOf(FORMATETC))
			
			Return DATA_S_SAMEFORMATETC
		End Function
		
		Private Function CDataObject.FindSlot(pFE As FORMATETC Ptr) As Long
			For i As Long = LBound(slots) To UBound(slots)
				If slots(i).fe.cfFormat = pFE->cfFormat _
					AndAlso (slots(i).fe.tymed And pFE->tymed) Then
					Return i
				End If
			Next
			Return -1
		End Function
		
		Sub CDataObject.StoreSlot(pFE As FORMATETC Ptr, pSTM As STGMEDIUM Ptr, fRelease As BOOL)
			Var idx = FindSlot(pFE)
			If idx = -1 Then
				idx = UBound(slots) + 1
				ReDim Preserve slots(idx)
			Else
				ReleaseStgMedium(@slots(idx).stm)
			End If
			slots(idx).fe = *pFE
			If fRelease Then
				slots(idx).stm = *pSTM
				memset(pSTM, 0, SizeOf(STGMEDIUM))
			Else
				Select Case pSTM->tymed
				Case TYMED_HGLOBAL
					slots(idx).stm.tymed = TYMED_HGLOBAL
					slots(idx).stm.hGlobal = OleDuplicateData( _
					pSTM->hGlobal, _
					pFE->cfFormat, _
					GMEM_MOVEABLE)
				Case TYMED_GDI
					slots(idx).stm.tymed = TYMED_GDI
					slots(idx).stm.hBitmap = CopyImage(pSTM->hBitmap, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION)
				Case TYMED_ENHMF
					slots(idx).stm.tymed = TYMED_ENHMF
					slots(idx).stm.hEnhMetaFile = CopyEnhMetaFileW(pSTM->hEnhMetaFile, NULL)
				Case TYMED_ISTREAM
					slots(idx).stm.tymed = TYMED_ISTREAM
					pSTM->pstm->lpVtbl->AddRef(pSTM->pstm)
					slots(idx).stm.pstm = pSTM->pstm
				Case TYMED_ISTORAGE
					slots(idx).stm.tymed = TYMED_ISTORAGE
					pSTM->pstg->lpVtbl->AddRef(pSTM->pstg)
					slots(idx).stm.pstg = pSTM->pstg
				Case TYMED_MFPICT
					slots(idx).stm.tymed = TYMED_MFPICT
					slots(idx).stm.hMetaFilePict = CopyMetaFile(pSTM->hMetaFilePict, NULL)
				Case Else
					memset(@slots(idx).stm, 0, SizeOf(STGMEDIUM))
				End Select
			End If
		End Sub
		''
		''  IDataObject::SetData
		''
		Private Function CDataObject.SetData _
			(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr, ByVal fRelease As WINBOOL) As HRESULT

			Dim As CDataObject Ptr _this = Cast(CDataObject Ptr, This)
			
			If pformatetc = 0 Or pmedium = 0 Then Return E_INVALIDARG
			If (pmedium->tymed And pformatetc->tymed) = 0 Then Return DV_E_TYMED
			
			_this->StoreSlot(pformatetc, pmedium, fRelease)
			Return S_OK
		End Function
		
		Private Function CDataObject.EnumFormatEtc(ByVal This As IDataObject Ptr, ByVal dwDirection As DWORD, ByVal ppenumFormatEtc As IEnumFORMATETC Ptr Ptr) As HRESULT
			Return E_NOTIMPL
		End Function
		
		Private Function CDataObject.DAdvise(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr, ByVal advf As DWORD, ByVal pAdvSink As IAdviseSink Ptr, ByVal pdwConnection As DWORD Ptr) As HRESULT
			Return OLE_E_ADVISENOTSUPPORTED
		End Function
		
		Private Function CDataObject.DUnadvise(ByVal This As IDataObject Ptr, ByVal dwConnection As DWORD) As HRESULT
			Return OLE_E_ADVISENOTSUPPORTED
		End Function
		
		Private Function CDataObject.EnumDAdvise(ByVal This As IDataObject Ptr, ByVal ppenumAdvise As IEnumSTATDATA Ptr Ptr) As HRESULT
			Return OLE_E_ADVISENOTSUPPORTED
		End Function
	#endif
End Namespace
