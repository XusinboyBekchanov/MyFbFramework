#define UNICODE
#include once "file.bi"
#undef FileExists
#ifdef __USE_GTK__
	#include once "glib.bi"
#else
	#include once "win\shlwapi.bi"
#endif
#ifndef MEMCHECK
	#define MEMCHECK 0
#endif
#include once "FBMemCheck.bi"

Type UStr As UString

Type UString Extends WString
Public:
	Declare Constructor()
	Declare Constructor(ByRef Value As WString)
	Declare Constructor(ByRef Value As UString)
	
	Declare Destructor()
	
	Declare Sub Resize(NewLength As Integer)
	Declare Function AppendBuffer(ByVal addrMemory As Any Ptr, ByVal NumBytes As ULong) As Boolean
	Declare Operator [](ByVal Index As Integer) ByRef As UShort
	
	Declare Operator Let(ByRef Value As WString)
	Declare Operator Let(ByRef Value As UString)
	
	Declare Operator Cast() ByRef As WString
	Declare Operator Cast() As Any Ptr
	
	Declare Property Length() As Integer
	Declare Function vptr As WString Ptr
	
	Declare Function StartsWith(ByRef Value As UString) As Boolean
	Declare Function EndsWith(ByRef Value As UString) As Boolean
	Declare Function TrimAll As UString
	Declare Function TrimEnd As UString
	Declare Function TrimStart As UString
	Declare Function ToLower As UString
	Declare Function ToUpper As UString
	
	m_Data As WString Ptr
	m_Length As Integer
	m_BufferLen As Integer
	m_BytesCount As Integer
Protected:
	
End Type

Declare Function WStrPtr(ByRef Value As UString) As WString Ptr

Declare Operator & (ByRef LeftText As UString, ByRef RightText As UString) As UString

Declare Function Replace(ByRef Expression As WString, ByRef FindingText As WString, ByRef ReplacingText As WString, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As UString

Declare Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString

Declare Function Val Overload(ByRef subject As UString) As Double

Declare Operator Len(ByRef lhs As UString) As Integer

Declare Sub WDeAllocate Overload(ByRef subject As WString Ptr)

Declare Sub WDeAllocate Overload(subject() As WString Ptr)

Declare Function WGet(ByRef subject As WString Ptr) ByRef As WString

#if MEMCHECK = 0
	Declare Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)
	
	Declare Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString)
#endif

Declare Sub WLetEx(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubjectInTxt As Boolean)

Declare Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString, AddBefore As Boolean = False)

Declare Function ToUtf8(ByRef nWString As WString) As String

Declare Function FromUtf8(pZString As ZString Ptr) ByRef As WString

#ifndef __USE_GTK__
	Declare Function FileExists Overload(ByRef filename As UString) As Long
#endif

#ifndef __USE_MAKE__
	#include once "UString.bas"
#endif
