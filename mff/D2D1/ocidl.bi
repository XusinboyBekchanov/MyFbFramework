' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' --- Abhängigkeiten (Dummy-Definitionen falls nicht in Headers) ---
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
Enum PROPBAG2_TYPE
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
Type IPropertyBag2 Extends IUnknownBase
    ' 1-3. IUnknown (via IUnknownBase)

    ' 4. Read
    ' Liest Werte f�r eine oder mehrere Eigenschaften.
    Declare Abstract Function Read stdcall ( _
        ByVal cProperties As ULong, _
        ByVal pPropBag As PROPBAG2 Ptr, _
        ByVal pErrLog As Any Ptr, _       ' IErrorLog Ptr
        ByVal pvarValue As VARIANT Ptr, _
        ByVal phrError As HRESULT Ptr _
    ) As HRESULT

    ' 5. Write
    ' Schreibt Werte f�r eine oder mehrere Eigenschaften.
    Declare Abstract Function Write stdcall ( _
        ByVal cProperties As ULong, _
        ByVal pPropBag As PROPBAG2 Ptr, _
        ByVal pvarValue As VARIANT Ptr _
    ) As HRESULT

    ' 6. CountProperties
    ' Ermittelt die Anzahl der verf�gbaren Eigenschaften.
    Declare Abstract Function CountProperties stdcall ( _
        ByRef pcProperties As ULong _
    ) As HRESULT

    ' 7. GetPropertyInfo
    ' Liefert Informationen �ber bestimmte Eigenschaften.
    Declare Abstract Function GetPropertyInfo stdcall ( _
        ByVal iProperty As ULong, _
        ByVal cProperties As ULong, _
        ByVal pPropBag As PROPBAG2 Ptr, _
        ByRef pcProperties As ULong _
    ) As HRESULT

    ' 8. LoadObject
    ' Veranlasst das Bag, eine Eigenschaft in ein Objekt zu laden.
    Declare Abstract Function LoadObject stdcall ( _
        ByVal pstrName As LPCOLESTR, _
        ByVal dwHint As DWORD, _
        ByVal pUnkObject As IUnknown Ptr, _
        ByVal pErrLog As Any Ptr _        ' IErrorLog Ptr
    ) As HRESULT
End Type