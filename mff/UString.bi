#define UNICODE
#include once "file.bi"
#if (Not defined(__USE_JNI__)) AndAlso (Not defined(__USE_WASM__))
	#undef FileExists
	#ifdef __USE_GTK__
		#ifdef __USE_GTK4__
			#include once "gir_headers/Gir/GLib-2.0.bi"
			#include once "gir_headers/Gir/_GLibMacros-2.0.bi"
		#else
			#include once "glib.bi"
		#endif
	#else
		#include once "win\shlwapi.bi"
	#endif
#endif
#ifndef MEMCHECK
	#define MEMCHECK 0
#endif
#include once "utf_conv.bi"
#include once "FBMemCheck.bi"

Private Type UStr As UString

Private Type UString Extends WString
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
	Declare Operator Let(ByRef Value As Const ZString)
	
	Declare Operator Cast() ByRef As WString
	Declare Operator Cast() As Any Ptr
	
	Declare Property Length() As Integer
	Declare Function vptr As WString Ptr
	
	Declare Function StartsWith(ByRef Value As WString) As Boolean
	Declare Function EndsWith(ByRef Value As WString) As Boolean
	Declare Function Contains(ByRef Value As WString) As Boolean
	Declare Function TrimAll As UString
	Declare Function TrimEnd As UString
	Declare Function TrimStart As UString
	Declare Function ToLower As UString
	Declare Function ToUpper As UString
	Declare Function SubString(ByVal start As Integer, ByVal n As Integer, ByRef expression As Const String = "") As UString
	
	m_Length As Integer
	m_BufferLen As Integer
	m_BytesCount As Integer
	
	m_Data As WString Ptr
Protected:
	
End Type

Declare Function WStrPtr(ByRef Value As UString) As WString Ptr
Declare Operator & (ByRef LeftText As UString, ByRef RightText As UString) As UString
Declare Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString
Declare Function Val Overload(ByRef subject As UString) As Double
Declare Operator Len(ByRef lhs As UString) As Integer
Declare Function WGet(ByRef subject As WString Ptr) ByRef As WString
#if MEMCHECK = 0
	Declare Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)
	Declare Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString)
	Declare Sub WDeAllocate Overload(ByRef subject As WString Ptr)
	Declare Sub ZLet(ByRef subject As ZString Ptr, ByRef txt As ZString)
	Declare Sub ZDeAllocate(ByRef subject As ZString Ptr)
#endif
Declare Sub WDeAllocateEx Overload(subject() As WString Ptr)

Declare Sub WLetEx(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubjectInTxt As Boolean = True)
Declare Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString, AddBefore As Boolean = False)
Declare Function ToUtf8(ByRef nWString As WString) As String
Declare Function FromUtf8(pZString As ZString Ptr) ByRef As WString
Declare Function Replace(ByRef Expression As WString, ByRef FindingText As WString, ByRef ReplacingText As WString, ByVal Start As Integer = 1, ByVal Count As Integer = -1, MatchCase As Boolean = True, ByRef CountReplaced As Integer = 0) As UString
Declare Function ZGet(ByRef subject As ZString Ptr) As String
Declare Function InStrCount(ByRef subject As WString, ByRef searchtext As WString, start As Integer = 1, MatchCase As Boolean = True) As Long
'Declare Function Replace Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByRef wszReplaceWith As Const WString, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
'Declare Function Replace Overload(ByRef wszMainStr As WString, MatchedStr() As WString Ptr, ReplaceWith() As WString Ptr, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
Declare Function Split Overload(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As String, MatchCase As Boolean = True) As Long
Declare Function Split Overload(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As UString, MatchCase As Boolean = True) As Long
Declare Function Split Overload(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As WString Ptr, MatchCase As Boolean = True) As Long
Declare Function Join Overload(Subject() As String, ByRef Delimiter As Const WString, iStart As Integer = 0, iStep As Integer = 1) As String
Declare Function Join Overload(Subject() As UString, ByRef Delimiter As Const WString, iStart As Integer = 0, iStep As Integer = 1) As UString
Declare Function Join Overload(Subject() As WString Ptr, ByRef Delimiter As Const WString, iStart As Integer = 0, iStep As Integer = 1) As String
Declare Function StartsWith(ByRef a As Const WString, ByRef b As Const WString, Start As Integer = 0) As Boolean
Declare Function EndsWith(ByRef a As Const WString, ByRef b As Const WString) As Boolean
Declare Function StringExtract Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString
Declare Function StringExtract(ByRef wszMainStr As WString, ByRef wszDelim1 As Const WString, ByRef wszDelim2 As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString
Declare Function StringSubStringAll(ByRef wszMainStr As WString, ByRef ParseStart As Const WString, ByRef ParseEnd As Const WString, Result() As WString Ptr, MatchCase As Boolean = True) As Long

#if (Not defined(__USE_JNI__)) AndAlso (Not defined(__USE_WASM__))
	Declare Function FileExists Overload(ByRef FileName As UString) As Boolean
	Declare Function FileExists Overload(ByRef FileName As WString) As Boolean
#endif

#ifndef __USE_MAKE__
	#include once "UString.bas"
#endif
