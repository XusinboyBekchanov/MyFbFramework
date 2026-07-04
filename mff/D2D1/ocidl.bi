'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
' --- Dependencies (dummy definitions if not in headers) ---
#ifndef IErrorLog
    Type IErrorLog As Any
#endif
' --- ISpecifyPropertyPages ---
Type CAUUID
    cElems As ULong
    pElems As GUID Ptr
End Type
Type ISpecifyPropertyPagesVtbl
    ' IUnknown
    QueryInterface As Function(ByVal As Any Ptr, ByVal As Const IID Ptr, ByVal As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal As Any Ptr) As ULong
    Release        As Function(ByVal As Any Ptr) As ULong
    ' ISpecifyPropertyPages
    GetPages       As Function(ByVal As Any Ptr, ByVal As CAUUID Ptr) As HRESULT
End Type
Type ISpecifyPropertyPages
    lpVtbl As ISpecifyPropertyPagesVtbl Ptr
End Type
' --- IPropertyBag2 ---
Type PROPBAG2_TYPE As Long
Enum
    PROPBAG2_TYPE_UNDEFINED = 0
    PROPBAG2_TYPE_DATA = 1
    PROPBAG2_TYPE_URL = 2
    PROPBAG2_TYPE_OBJECT = 3
    PROPBAG2_TYPE_STREAM = 4
    PROPBAG2_TYPE_STORAGE = 5
    PROPBAG2_TYPE_MONIKER = 6
End Enum
Type PROPBAG2
    dwType   As DWORD
    vt       As VARTYPE
    cfType   As CLIPFORMAT
    dwHint   As DWORD
    pstrName As LPOLESTR
    clsid    As CLSID
End Type
' --- GUID Definitionen ---
Dim Shared As GUID IID_IPropertyBag2         = Type<GUID>(&h22f55882, &h280b, &h11d0, {&ha8, &ha9, &h00, &ha0, &hc9, &h0c, &h20, &h04})
Dim Shared As GUID IID_IPersistPropertyBag2  = Type<GUID>(&h22f55881, &h280b, &h11d0, {&ha8, &ha9, &h00, &ha0, &hc9, &h0c, &h20, &h04})
Dim Shared As GUID IID_ISpecifyPropertyPages = Type<GUID>(&hb196b28b, &hbab4, &h101a, {&hb6, &h9c, &h00, &haa, &h00, &h34, &h1d, &h07})
' ============================================================================
' IPropertyBag2
' ============================================================================
Type IPropertyBag2Vtbl As IPropertyBag2Vtbl_
Type IPropertyBag2
    lpVtbl As IPropertyBag2Vtbl Ptr
End Type
Type IPropertyBag2Vtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IPropertyBag2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IPropertyBag2 Ptr) As ULong
    Release As Function(ByVal This As IPropertyBag2 Ptr) As ULong

    
        ' Reads values for one or more properties.
    Read As Function(ByVal This As IPropertyBag2 Ptr,  ByVal cProperties As ULong, ByVal pPropBag As PROPBAG2 Ptr, ByVal pErrLog As Any Ptr, ByVal pvarValue As VARIANT Ptr, ByVal phrError As HRESULT Ptr ) As HRESULT
        ' 5. Write
        ' Writes values for one or more properties.
    Write As Function(ByVal This As IPropertyBag2 Ptr,  ByVal cProperties As ULong, ByVal pPropBag As PROPBAG2 Ptr, ByVal pvarValue As VARIANT Ptr ) As HRESULT
        ' 6. CountProperties
        ' Determines the number of available properties.
    CountProperties As Function(ByVal This As IPropertyBag2 Ptr,  ByRef pcProperties As ULong ) As HRESULT
        ' 7. GetPropertyInfo
        ' Provides information about certain characteristics.
    GetPropertyInfo As Function(ByVal This As IPropertyBag2 Ptr,  ByVal iProperty As ULong, ByVal cProperties As ULong, ByVal pPropBag As PROPBAG2 Ptr, ByRef pcProperties As ULong ) As HRESULT
        ' 8. LoadObject
        ' Causes the bag to load a property into an object.
    LoadObject As Function(ByVal This As IPropertyBag2 Ptr,  ByVal pstrName As LPCOLESTR, ByVal dwHint As DWORD, ByVal pUnkObject As IUnknown Ptr, ByVal pErrLog As Any Ptr ) As HRESULT
End Type
#define IPropertyBag2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IPropertyBag2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IPropertyBag2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IPropertyBag2_Read(p, a, b, c, d, e) (p)->lpVtbl->Read(p, a, b, c, d, e)
#define IPropertyBag2_Write(p, a, b, c) (p)->lpVtbl->Write(p, a, b, c)
#define IPropertyBag2_CountProperties(p, a) (p)->lpVtbl->CountProperties(p, a)
#define IPropertyBag2_GetPropertyInfo(p, a, b, c, d) (p)->lpVtbl->GetPropertyInfo(p, a, b, c, d)
#define IPropertyBag2_LoadObject(p, a, b, c, d) (p)->lpVtbl->LoadObject(p, a, b, c, d)

