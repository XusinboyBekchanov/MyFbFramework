' ########################################################################################
' Platform: Microsoft Windows
' Filename: BSTRING.bi
' Purpose: Implements an OLE stringdata type
' Compiler: Free Basic 32 & 64 bit
' Copyright (c) 2018 José Roca
'
' License: Same license as the FreeBasic include files provided with the compiler.
'
'   This library is free software; you can redistribute it and/or
'   modify it under the terms of the GNU Lesser General Public
'   License as published by the Free Software Foundation; either
'   version 2.1 of the License, or (at your option) any later version.
'
'   This library is distributed in the hope that it will be useful,
'   but WITHOUT ANY WARRANTY; without even the implied warranty of
'   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
'   Lesser General Public License for more details.
'
'   You should have received a copy of the GNU Lesser General Public
'   License along with this library; if not, write to the Free Software
'   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
'
' ########################################################################################

#pragma ONCE
#pragma once
#include once "DWString.bi"

' ========================================================================================
' // Checks if the passed pointer is a BSTR.
' // Will return FALSE if it is a null pointer.
' // If it is an OLE string it must have a descriptor; otherwise, don't.
' // Get the length in bytes looking at the descriptor and divide by 2 to get the number of
' // unicode characters, that is the value returned by the FreeBASIC LEN operator.
' // If the retrieved length if the same that the returned by LEN, then it must be an OLE string.
' ========================================================================================
FUNCTION DWStrIsBstr (BYVAL pv aS ANY PTR) AS BOOLEAN
   IF pv = NULL THEN RETURN FALSE
   DIM res AS DWORD = PEEK(DWORD, pv - 4) \ 2
   IF res = LEN(*cast(WSTRING PTR, pv)) THEN RETURN TRUE
END FUNCTION
' ========================================================================================

' ########################################################################################
'                                *** BSTRING CLASS ***
' ########################################################################################
TYPE BSTRING

Public:
   m_bstr AS BSTR

   DECLARE CONSTRUCTOR
   DECLARE CONSTRUCTOR (BYREF bs AS BSTRING)
   DECLARE CONSTRUCTOR (BYREF dws AS DWSTRING)
   DECLARE CONSTRUCTOR (BYVAL pwszStr AS WSTRING PTR, BYVAL fAttach AS LONG = TRUE)
   DECLARE CONSTRUCTOR (BYREF ansiStr AS STRING = "", BYVAL nCodePage AS UINT = 0)
   DECLARE CONSTRUCTOR (BYVAL n AS LONGINT)
   DECLARE CONSTRUCTOR (BYVAL n AS DOUBLE)
   DECLARE DESTRUCTOR
   DECLARE FUNCTION bptr () AS BSTR
   DECLARE FUNCTION vptr () AS ANY PTR
   DECLARE FUNCTION sptr () AS WSTRING PTR
   DECLARE FUNCTION wstr () BYREF AS CONST WSTRING
   DECLARE FUNCTION wchar () AS WSTRING PTR
   DECLARE SUB Append (BYVAL pwszStr AS WSTRING PTR)
   DECLARE SUB Clear
   DECLARE SUB Attach (BYVAL pbstrSrc AS BSTR)
   DECLARE FUNCTION Detach () AS BSTR
   DECLARE FUNCTION Copy () AS BSTR
   DECLARE OPERATOR CAST () BYREF AS CONST WSTRING
   DECLARE OPERATOR CAST () AS ANY PTR
   DECLARE OPERATOR LET (BYREF bs AS BSTRING)
   DECLARE OPERATOR LET (BYREF dws AS DWSTRING)
   DECLARE OPERATOR LET (BYREF s AS STRING)
   DECLARE OPERATOR LET (BYVAL pwszStr AS WSTRING PTR)
   DECLARE OPERATOR += (BYVAL pwszStr AS WSTRING PTR)
   DECLARE OPERATOR += (BYREF bs AS BSTRING)
   DECLARE OPERATOR += (BYREF dws AS DWSTRING)
   DECLARE OPERATOR += (BYVAL n AS LONGINT)
   DECLARE OPERATOR += (BYVAL n AS DOUBLE)
   DECLARE OPERATOR &= (BYVAL pwszStr AS WSTRING PTR)
   DECLARE OPERATOR &= (BYREF bs AS BSTRING)
   DECLARE OPERATOR &= (BYREF dws AS DWSTRING)
   DECLARE OPERATOR &= (BYVAL n AS LONGINT)
   DECLARE OPERATOR &= (BYVAL n AS DOUBLE)
   DECLARE PROPERTY Utf8 () AS STRING
   DECLARE PROPERTY Utf8 (BYREF utf8String AS STRING)

END TYPE
' ========================================================================================

' ========================================================================================
' Constructors
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING
   ' // Do nothing.
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYREF bs AS BSTRING)
   m_bstr = SysAllocString(bs)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYREF dws AS DWSTRING)
   m_bstr = SysAllocString(dws)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYVAL pwszStr AS WSTRING PTR, BYVAL fAttach AS LONG = TRUE)
   IF pwszStr = NULL THEN
      m_bstr = SysAllocString("")
      CBSTR_DP("CBSTR CONSTRUCTOR SysAllocString - " & .WSTR(m_bstr))
   ELSE
      ' Detect if the passed handle is an OLE string.
      ' If it is an OLE string it must have a descriptor; otherwise, don't.
      ' Get the length in bytes looking at the descriptor and divide by 2 to get the number of
      ' unicode characters, that is the value returned by the FreeBASIC LEN operator.
      DIM res AS DWORD = PEEK(DWORD, CAST(ANY PTR, pwszStr) - 4) \ 2
      ' If the retrieved length is the same that the returned by LEN, then it must be an OLE string
      IF res = .LEN(*pwszStr) AND fAttach <> FALSE THEN
         ' Attach the passed handle to the class
         m_bstr = pwszStr
      ELSE
         ' Allocate an OLE string with the contents of the string pointed by bstrHandle
         m_bstr = SysAllocString(pwszStr)
      END IF
   END IF
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYREF ansiStr AS STRING = "", BYVAL nCodePage AS UINT = 0)
   IF nCodePage = CP_UTF8 THEN
      DIM dwLen AS DWORD = MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), NULL, 0)
      IF dwLen THEN
         m_bstr = SysAllocString(.WSTR(SPACE(dwLen)))
         MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), m_bstr, dwLen * 2)
      ELSE
         m_bstr = SysAllocString("")
      END IF
   ELSE
      IF LEN(ansiStr) THEN
         m_bstr = SysAllocString(.WSTR(ansiStr))
         MultiByteToWideChar(nCodePage, MB_PRECOMPOSED, STRPTR(ansiStr), -1, m_bstr, LEN(ansiStr) * 2)
      ELSE
         m_bstr = SysAllocString("")
      END IF
   END IF
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Initializes the BSTRING with a number.
' These two constructors are needed to allow to use a number with the & operator.
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYVAL n AS LONGINT)
   m_bstr = SysAllocString(.WSTR(n))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR BSTRING (BYVAL n AS DOUBLE)
   m_bstr = SysAllocString(.WSTR(n))
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' Destructor
' ========================================================================================
PRIVATE DESTRUCTOR BSTRING
   IF m_bstr THEN SysFreeString m_bstr
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' * Appends a string to the CBSTR. The string can be a literal or a FB STRING, a WSTRING,
' a CBSTR or a CWSTR variable.
' ========================================================================================
PRIVATE SUB BSTRING.Append (BYVAL pwszStr AS WSTRING PTR)
   DIM n1 AS UINT = SysStringLen(m_bstr)
   DIM nLen AS UINT = .LEN(*pwszStr)
   IF nLen = 0 THEN EXIT SUB
   DIM b AS BSTR = SysAllocStringLen(NULL, n1 + nLen)
   IF b = NULL THEN EXIT SUB
   memcpy(b, m_bstr, n1 * SIZEOF(WSTRING))
   memcpy(b + n1, pwszStr, nLen * SIZEOF(WSTRING))
   IF m_bstr THEN SysFreeString(m_bstr)
   m_bstr = b
END SUB
' ========================================================================================

' ========================================================================================
' Frees the m_bstr member.
' ========================================================================================
PRIVATE SUB BSTRING.Clear
   IF m_bstr THEN SysFreeString(m_bstr)
   m_bstr = NULL
END SUB
' ========================================================================================

' ========================================================================================
' * Attaches a BSTR to the BSTRING object by setting the m_bstr member to pbstrSrc.
' WARNING: Don't attach a BSTRING to another BSTRING because each BSTRING will try to free
' the same BSTR when they are destroyed.
' ========================================================================================
PRIVATE SUB BSTRING.Attach (BYVAL pbstrSrc AS BSTR)
   IF m_bstr THEN SysFreeString(m_bstr)
   IF DWStrIsBstr(pbstrSrc) THEN m_bstr = pbstrSrc
END SUB
' ========================================================================================

' ========================================================================================
' * Detaches m_bstr from the BSTRING object and sets m_bstr to NULL.
' ========================================================================================
PRIVATE FUNCTION BSTRING.Detach () AS BSTR
   DIM pbstr AS BSTR = m_bstr
   m_bstr = NULL
   RETURN pbstr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Allocates and returns a copy of m_bstr.
' ========================================================================================
PRIVATE FUNCTION BSTRING.Copy () AS BSTR
   RETURN SysAllocStringLen(m_bstr, SysStringLen(m_bstr))
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the BSTR pointer
' ========================================================================================
PRIVATE OPERATOR BSTRING.CAST () AS ANY PTR
   OPERATOR =  CAST(ANY PTR, m_bstr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Returns a pointer to the string data (same as **)
' ========================================================================================
PRIVATE OPERATOR BSTRING.CAST () BYREF AS CONST WSTRING
   OPERATOR = *CAST(WSTRING PTR, m_bstr)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the underlying BSTR pointer.
' ========================================================================================
PRIVATE FUNCTION BSTRING.bptr () AS BSTR
   CBSTR_DP("CBSTR bptr")
   RETURN m_bstr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Frees the underlying BSTR and returns the address of BSTR pointer.
' To pass the underlying BSTR to an OUT BYVAL BSTR PTR parameter.
' If we pass a BSTRING to a function with an OUT BSTR parameter without first freeing it
' we will have a memory leak.
' ========================================================================================
PRIVATE FUNCTION BSTRING.vptr () AS ANY PTR
   IF m_bstr THEN SysFreeString(m_bstr) : m_bstr = NULL
   RETURN @m_bstr
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the address of the BSTRING string data (same as **)
' ========================================================================================
PRIVATE FUNCTION BSTRING.sptr () AS WSTRING PTR
   RETURN cast(WSTRING PTR, m_bstr)
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a pointer to the string data (same as **)
' ========================================================================================
PRIVATE FUNCTION BSTRING.wstr () BYREF AS CONST WSTRING
   RETURN *CAST(WSTRING PTR, m_bstr)
END FUNCTION
' ========================================================================================

' =====================================================================================
' Returns the contents of the CWSTR as a WSTRING allocated with CoTaskMemAlloc.
' Free the returned string later with CoTaskMemFree.
' Note: This is useful when we need to pass a pointer to a null terminated wide string to a
' function or method that will release it. If we pass a WSTRING it will GPF.
' If the length of the input string is 0, CoTaskMemAlloc allocates a zero-length item and
' returns a valid pointer to that item. If there is insufficient memory available,
' CoTaskMemAlloc returns NULL.
' =====================================================================================
PRIVATE FUNCTION BSTRING.wchar () AS WSTRING PTR
   DIM pwchar AS WSTRING PTR
   DIM nLen AS LONG = SysStringLen(m_bstr) * 2
   pwchar = CoTaskMemAlloc(nLen)
   IF pwchar = NULL THEN RETURN NULL
   IF nLen THEN memcpy pwchar, m_bstr, nLen
   IF nLen = 0 THEN *pwchar = CHR(0)
   RETURN pwchar
END FUNCTION
' =====================================================================================

' ========================================================================================
' Assigns new text to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.LET (BYREF bs AS BSTRING)
   IF m_bstr <> bs.m_bstr THEN   ' // If the user has done cbs = cbs, ignore it
      IF m_bstr THEN SysFreeString(m_bstr)
      m_bstr = SysAllocString(bs)
   END IF
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR BSTRING.LET (BYREF dws AS DWSTRING)
   IF m_bstr THEN SysFreeString(m_bstr)
   m_bstr = SysAllocString(dws)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR BSTRING.LET (BYREF s AS STRING)
   IF m_bstr THEN SysFreeString(m_bstr)
   m_bstr = SysAllocString(s)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR BSTRING.LET (BYVAL pwszStr AS WSTRING PTR)
   ' Free the current OLE string
   IF m_bstr THEN SysFreeString(m_bstr)
   ' Detect if the passed handle is an OLE string.
   ' If it is an OLE string it must have a descriptor; otherwise, don't.
   ' Get the length in bytes looking at the descriptor and divide by 2 to get the number of
   ' unicode characters, that is the value returned by the FreeBASIC LEN operator.
   DIM res AS DWORD = PEEK(DWORD, CAST(ANY PTR, pwszStr) - 4) \ 2
   ' If the retrieved length is the same that the returned by LEN, then it must be an OLE string
   IF res = .LEN(*pwszStr) THEN
      ' Attach the passed handle to the class
      m_bstr = pwszStr
   ELSE
      ' Allocate an OLE string with the contents of the string pointed by pwszStr
      m_bstr = SysAllocString(pwszStr)
   END IF
END OPERATOR
' ========================================================================================

' ========================================================================================
' * Appends a string to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.+= (BYVAL pwszStr AS WSTRING PTR)
   this.Append(pwszStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' * Appends a BSTRING to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.+= (BYREF bs AS BSTRING)
   this.Append(bs)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a DWSTRING to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.+= (BYREF dws AS DWSTRING)
   this.Append(dws)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a number to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.+= (BYVAL n AS LONGINT)
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Append(wsz)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR BSTRING.+= (BYVAL n AS DOUBLE)
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Append(wsz)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a string to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.&= (BYVAL pwszStr AS WSTRING PTR)
   this.Append(pwszStr)
END OPERATOR
' ========================================================================================

' ========================================================================================
' * Appends a BSTRING to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.&= (BYREF bs AS BSTRING)
   this.Append(bs)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a DWSTRING to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.&= (BYREF dws AS DWSTRING)
   this.Append(dws)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a number to the BSTRING.
' ========================================================================================
PRIVATE OPERATOR BSTRING.&= (BYVAL n AS LONGINT)
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Append(wsz)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR BSTRING.&= (BYVAL n AS DOUBLE)
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Append(wsz)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Converts the BSTRING to UTF8.
' ========================================================================================
PRIVATE PROPERTY BSTRING.Utf8 () AS STRING
   DIM cbLen AS INTEGER, bstrLen AS LONG
   IF m_bstr = NULL THEN RETURN ""
   bstrLen = SysStringLen(m_bstr)
   DIM buffer AS STRING = STRING(bstrLen * 5 + 1, 0)
   PROPERTY = *cast(ZSTRING PTR, WCharToUTF(1, cast(WSTRING PTR, m_bstr), bstrLen, STRPTR(buffer), @cbLen))
END PROPERTY
' ========================================================================================

' ========================================================================================
' Converts UTF8 to unicode and assigns it to the BSTRING.
' ========================================================================================
PRIVATE PROPERTY BSTRING.Utf8 (BYREF utf8String AS STRING)
   IF m_bstr THEN SysFreeString(m_bstr)
   DIM dwLen AS DWORD = MultiByteToWideChar(CP_UTF8, 0, STRPTR(utf8String), LEN(utf8String), NULL, 0)
   IF dwLen THEN
      m_bstr = SysAllocString(.WSTR(SPACE(dwLen)))
      MultiByteToWideChar(CP_UTF8, 0, STRPTR(utf8String), LEN(utf8String), m_bstr, dwLen * 2)
   ELSE
      m_bstr = SysAllocString("")
   END IF
END PROPERTY
' ========================================================================================

' ########################################################################################
'                         *** GLOBAL OPERATORS AND FUNCTIONS ***
' ########################################################################################

' ========================================================================================
' Returns the length, in characters, of the DWSTRING.
' ========================================================================================
PRIVATE OPERATOR LEN (BYREF bs AS BSTRING) AS UINT
   OPERATOR = SysStringLen(bs)
END OPERATOR
' ========================================================================================

' ========================================================================================
' One * returns the BSTR pointer.
' Two ** returns the adress of the start of the string data.
' ========================================================================================
PRIVATE OPERATOR * (BYREF bs AS BSTRING) AS WSTRING PTR
   OPERATOR = bs.m_bstr
END OPERATOR
' ========================================================================================

' ========================================================================================
' Concatenates two strings, converting non-strings to strings as needed
' ========================================================================================
PRIVATE OPERATOR & (BYREF bs1 AS BSTRING, BYREF bs2 AS BSTRING) AS BSTRING
   OPERATOR = bs1 + bs2
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the leftmost substring of a string
' ========================================================================================
PRIVATE FUNCTION Left OVERLOAD (BYREF bs AS BSTRING, BYVAL nChars AS INTEGER) AS BSTRING
   RETURN LEFT(**bs, nChars)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the rightmost substring of a string
' ========================================================================================
PRIVATE FUNCTION Right OVERLOAD (BYREF bs AS BSTRING, BYVAL nChars AS INTEGER) AS BSTRING
   RETURN RIGHT(**bs, nChars)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a string to a floating point number
' ========================================================================================
PRIVATE FUNCTION Val OVERLOAD (BYREF bs AS BSTRING) AS DOUBLE
   RETURN .VAL(**bs)
END FUNCTION
' ========================================================================================

' =====================================================================================
' Converts the string to a 32bit integer
' =====================================================================================
PRIVATE FUNCTION ValLng OVERLOAD (BYREF bs AS BSTRING) AS LONGINT
   RETURN .ValLng(**bs)
END FUNCTION
' =====================================================================================
' =====================================================================================
PRIVATE FUNCTION ValInt OVERLOAD (BYREF bs AS BSTRING) AS LONG
   RETURN .ValInt(**bs)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to an unsigned 32bit integer
' =====================================================================================
PRIVATE FUNCTION ValULng OVERLOAD (BYREF bs AS BSTRING) AS ULONGINT
   RETURN .ValULng(**bs)
END FUNCTION
' =====================================================================================
' =====================================================================================
PRIVATE FUNCTION ValUInt OVERLOAD (BYREF bs AS BSTRING) AS ULONG
   RETURN .ValUInt(**bs)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to a 64bit integer
' =====================================================================================
PRIVATE FUNCTION ValLongInt OVERLOAD (BYREF bs AS BSTRING) AS LONGINT
   RETURN .ValLng(**bs)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to an unsigned 64bit integer
' =====================================================================================
PRIVATE FUNCTION ValULongInt OVERLOAD (BYREF bs AS BSTRING) AS ULONGINT
   RETURN .ValULng(**bs)
END FUNCTION
' =====================================================================================
