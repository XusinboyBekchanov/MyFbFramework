#define UNICODE
#include once "file.bi"
#undef FileExists
#ifdef __USE_GTK__
	#include once "glib.bi"
#else
	#include once "win\shlwapi.bi"
#endif
Type UStr As UString

Type UString Extends WString
Public:
	Declare Constructor()
	Declare Constructor(ByRef Value As WString)
	Declare Constructor(ByRef Value As UString)
	
	Declare Destructor()
	
	Declare Sub Resize(NewLength As Integer)
	
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
Protected:
	Dim m_Length As Integer
	Dim m_BytesCount As Integer
	
End Type

Declare Function WStrPtr(ByRef Value As UString) As WString Ptr

Declare Operator & (ByRef LeftText As UString, ByRef RightText As UString) As UString

Declare Function Replace(ByRef subject As WString, ByRef oldtext As Const WString, ByRef newtext As Const WString, ByVal start As Integer = 1, ByRef count As Integer = 0, MatchCase As Boolean = True) As UString

Declare Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString

Declare Function Val Overload(ByRef subject As UString) As Double

Declare Operator Len(ByRef lhs As UString) As Integer

#ifndef __USE_GTK__
	Declare Function FileExists Overload(ByRef filename As UString) As Long
#endif

#ifndef __USE_MAKE__
	#include once "UString.bas"
#endif
