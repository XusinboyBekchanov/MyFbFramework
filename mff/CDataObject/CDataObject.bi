#ifdef __USE_WINAPI__
	#include once "windows.bi"
	#include once "win/ole2.bi"
#endif

Namespace My.Sys.Forms
	#ifdef __USE_WINAPI__
		Type CDataObject
		Private:
			'' implements IDropObject
			Dim As IDataObject m_DataObject = Any
			
		Public:
			Declare Constructor()
			Declare Destructor()
			
		Public:
			'' IDropTarget implementation (while there's no support for virtual methods and inheritance)
			Declare Static Function QueryInterface _
			(ByVal pInst As IDataObject Ptr, _
			ByVal iid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
			
			Declare Static Function AddRef _
			(ByVal pInst As IDataObject Ptr) As ULong
			
			Declare Static Function Release _
			(ByVal pInst As IDataObject Ptr) As ULong
			
			Declare Static Function GetData(ByVal This As IDataObject Ptr, ByVal pformatetcIn As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr) As HRESULT
			Declare Static Function GetDataHere(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr) As HRESULT
			Declare Static Function QueryGetData(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr) As HRESULT
			Declare Static Function GetCanonicalFormatEtc(ByVal This As IDataObject Ptr, ByVal pformatectIn As FORMATETC Ptr, ByVal pformatetcOut As FORMATETC Ptr) As HRESULT
			Declare Static Function SetData(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr, ByVal pmedium As STGMEDIUM Ptr, ByVal fRelease As WINBOOL) As HRESULT
			Declare Static Function EnumFormatEtc(ByVal This As IDataObject Ptr, ByVal dwDirection As DWORD, ByVal ppenumFormatEtc As IEnumFORMATETC Ptr Ptr) As HRESULT
			Declare Static Function DAdvise(ByVal This As IDataObject Ptr, ByVal pformatetc As FORMATETC Ptr, ByVal advf As DWORD, ByVal pAdvSink As IAdviseSink Ptr, ByVal pdwConnection As DWORD Ptr) As HRESULT
			Declare Static Function DUnadvise(ByVal This As IDataObject Ptr, ByVal dwConnection As DWORD) As HRESULT
			Declare Static Function EnumDAdvise(ByVal This As IDataObject Ptr, ByVal ppenumAdvise As IEnumSTATDATA Ptr Ptr) As HRESULT
			
			Declare Function FindSlot(pFE As FORMATETC Ptr) As Long
			Declare Sub StoreSlot(pFE As FORMATETC Ptr, pSTM As STGMEDIUM Ptr, fRelease As BOOL)
		Public:
			'' member variables
			As Long m_lRefCount = Any
			Type DataSlot
				fe  As FORMATETC
				stm As STGMEDIUM
			End Type
			slots(Any) As DataSlot
			hMem As HGLOBAL
			fe As FORMATETC
		End Type
	#endif
End Namespace

#include once "CDataObject.bas"
