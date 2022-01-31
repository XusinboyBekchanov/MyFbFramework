' This file contains code from
' https://github.com/stevemk14ebr/PolyHook_2_0/blob/master/sources/IatHook.cpp
' which is licensed under the MIT License.
' See PolyHook_2_0-LICENSE for more information.

#pragma once

#include "crt/stdint.bi"
#include "crt/string.bi"

Function RVA2VA(Base1 As Any Ptr, rva As Long) As Any Ptr
	Return Base1 + rva
End Function

Function DataDirectoryFromModuleBase(moduleBase As Any Ptr, entryID As size_t) As Any Ptr
	Var dosHdr = Cast(PIMAGE_DOS_HEADER, moduleBase)
	Var ntHdr = Cast(PIMAGE_NT_HEADERS, RVA2VA(moduleBase, dosHdr->e_lfanew))
	Return RVA2VA(moduleBase, ntHdr->OptionalHeader.DataDirectory(entryID).VirtualAddress)
End Function

Function FindAddressByName(moduleBase As Any Ptr, impName As PIMAGE_THUNK_DATA, impAddr As PIMAGE_THUNK_DATA, funcName As String) As PIMAGE_THUNK_DATA
	Do '(; impName->u1.Ordinal; ++ impName, ++ impAddr)
		If (IMAGE_SNAP_BY_ORDINAL(impName->u1.Ordinal)) Then
			impName = impName + 1
			impAddr = impAddr + 1
			Continue Do
		End If

		Var Import1 = Cast(PIMAGE_IMPORT_BY_NAME, RVA2VA(moduleBase, impName->u1.AddressOfData))
		If (strcmp(*Cast(ZString Ptr, @Import1->Name(0)), funcName) <> 0) Then
			impName = impName + 1
			impAddr = impAddr + 1
			Continue Do
		End If
		Return impAddr
	Loop While impName->u1.Ordinal
	Return 0 'nullptr
End Function

Function FindAddressByOrdinal(moduleBase As Any Ptr, impName As PIMAGE_THUNK_DATA, impAddr As PIMAGE_THUNK_DATA, ordinal As uint16_t) As PIMAGE_THUNK_DATA
'	UNREFERENCED_PARAMETER(moduleBase);
	Do 'For (; impName->u1.Ordinal; ++ impName, ++ impAddr)
		If (IMAGE_SNAP_BY_ORDINAL(impName->u1.Ordinal) AndAlso IMAGE_ORDINAL(impName->u1.Ordinal) = ordinal) Then
			Return impAddr
		End If
		impName = impName + 1
		impAddr = impAddr + 1
	Loop While impName->u1.Ordinal
	Return 0 'nullptr
End Function

Function FindIatThunkInModule(moduleBase As Any Ptr, dllName As String, funcName As String) As PIMAGE_THUNK_DATA
	Var imports = Cast(PIMAGE_IMPORT_DESCRIPTOR, DataDirectoryFromModuleBase(moduleBase, IMAGE_DIRECTORY_ENTRY_IMPORT))
	Do '(; imports->Name; ++ imports)
		If (_stricmp(Cast(LPCSTR, RVA2VA(moduleBase, imports->Name)), dllName) <> 0) Then
			imports += 1
			Continue Do
		End If

		Var origThunk = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->OriginalFirstThunk))
		Var thunk = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->FirstThunk))
		Return FindAddressByName(moduleBase, origThunk, thunk, funcName)
	Loop While imports->Name
	Return 0
End Function

Function FindDelayLoadThunkInModule Overload(moduleBase As Any Ptr, dllName As String, funcName As String) As PIMAGE_THUNK_DATA
	Var imports = Cast(PIMAGE_DELAYLOAD_DESCRIPTOR, DataDirectoryFromModuleBase(moduleBase, IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT))
	Do '(; imports->DllNameRVA; ++ imports)
		If (_stricmp(Cast(LPCSTR, RVA2VA(moduleBase, imports->DllNameRVA)), dllName) <> 0) Then
			imports += 1
			Continue Do
		End If

		Var impName = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->ImportNameTableRVA))
		Var impAddr = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->ImportAddressTableRVA))
		Return FindAddressByName(moduleBase, impName, impAddr, funcName)
	Loop While imports->DllNameRVA
	Return 0 'nullptr
End Function

Function FindDelayLoadThunkInModule Overload(moduleBase As Any Ptr, dllName As String, ordinal As uint16_t) As PIMAGE_THUNK_DATA
	Var imports = Cast(PIMAGE_DELAYLOAD_DESCRIPTOR, DataDirectoryFromModuleBase(moduleBase, IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT))
	Do ' (; imports->DllNameRVA; ++ imports)
		If (_stricmp(Cast(LPCSTR, RVA2VA(moduleBase, imports->DllNameRVA)), dllName) <> 0) Then
			imports += 1
			Continue Do
		End If

		Var impName = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->ImportNameTableRVA))
		Var impAddr = Cast(PIMAGE_THUNK_DATA, RVA2VA(moduleBase, imports->ImportAddressTableRVA))
		Return FindAddressByOrdinal(moduleBase, impName, impAddr, ordinal)
	Loop While imports->DllNameRVA
	Return 0 'nullptr
End Function
