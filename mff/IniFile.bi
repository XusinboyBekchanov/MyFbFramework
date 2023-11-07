'###############################################################################
'#  IniFile.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TIniFile.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "List.bi"
#define QIniFile(__Ptr__) (*Cast(IniFile Ptr,__Ptr__))

Private Type IniFile
Private:
	FFile         As WString Ptr
	FLines        As List
	FSectionCount As Integer
	CharStart     As String = "["
	CharEnd       As String = "]"
	FSaveSuspend  As Boolean
	FFileEncoding As FileEncodings = FileEncodings.Utf8BOM
	FNewLineType  As NewLineTypes = NewLineTypes.WindowsCRLF
Public:
	Declare Function SectionExists(ByRef Section As WString) As Integer
	Declare Function KeyExists(ByRef Section As WString, ByRef Key As WString) As Integer
	
	Declare Property File ByRef As WString
	Declare Property File(ByRef Value As WString)
	Declare Function SectionCount As Integer
	Declare Sub SaveFile(ByRef FileName As WString = "")
	Declare Property SaveSuspend As Boolean
	Declare Property SaveSuspend(Value As Boolean)
	Declare Sub Load(ByRef FileName As WString = "")
	Declare Sub WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
	Declare Sub WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
	Declare Sub WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
	Declare Sub WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
	Declare Function ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
	Declare Function ReadFloat(ByRef Section As WString, ByRef Key As WString, Inplace As Double = 0.0) As Double
	Declare Function ReadBool(ByRef Section As WString, ByRef Key As WString, Inplace As Boolean = False) As Boolean
	Declare Function ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") As UString
	Declare Function KeyRemove(ByRef Section As WString, ByRef Key As WString) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Constructor(ByRef FileName As WString = "")
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "IniFile.bas"
#endif
