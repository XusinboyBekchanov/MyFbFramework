' ########################################################################################
' Platform: Microsoft Windows
' Filename: DWSTRING.bi
' Purpose: Implements a data type for dynamic null terminated unicode strings.
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
#INCLUDE ONCE "windows.bi"
#INCLUDE ONCE "/crt/string.bi"
#INCLUDE ONCE "/crt/wchar.bi"
#INCLUDE ONCE "utf_conv.bi"

' ========================================================================================
' Macro for debug
' To allow debugging, define _DWSTRING_DEBUG_ 1 in your application before including this file.
' ========================================================================================
#ifndef _DWSTRING_DEBUG_
   #define _DWSTRING_DEBUG_ 0
#ENDIF
#ifndef _DWSTRING_DP_
   #define _DWSTRING_DP_ 1
   #MACRO DWSTRING_DP(st)
      #IF (_DWSTRING_DEBUG_ = 1)
         OutputDebugStringW(st)
      #ENDIF
   #ENDMACRO
#ENDIF
' ========================================================================================

' ########################################################################################
'                                *** DWSTRING CLASS ***
' ########################################################################################
TYPE DWSTRING

   Private:
      m_Capacity AS UINT         ' // The total size of the buffer in UTF16 characters
      m_GrowSize AS LONG = 260   ' // How much to grow the buffer by when required

   Public:
      m_pBuffer AS WSTRING PTR   ' // Pointer to the buffer
      m_BufferLen AS UINT        ' // Length in characters of the string

      DECLARE CONSTRUCTOR
      DECLARE CONSTRUCTOR (BYVAL nChars AS UINT, BYVAL bClear AS BOOLEAN)
      DECLARE CONSTRUCTOR (BYVAL pwszStr AS WSTRING PTR)
      DECLARE CONSTRUCTOR (BYREF ansiStr AS STRING, BYVAL nCodePage AS UINT = 0)
      DECLARE CONSTRUCTOR (BYREF dws AS DWSTRING)
      DECLARE CONSTRUCTOR (BYVAL n AS LONGINT)
      DECLARE CONSTRUCTOR (BYVAL n AS DOUBLE)
      DECLARE DESTRUCTOR
      DECLARE PROPERTY GrowSize () AS LONG
      DECLARE PROPERTY GrowSize (BYVAL nValue AS LONG)
      DECLARE PROPERTY Capacity () AS UINT
      DECLARE PROPERTY Capacity (BYVAL nValue AS UINT)
      DECLARE PROPERTY SizeAlloc (BYVAL nChars AS UINT)
      DECLARE PROPERTY SizeOf () AS UINT
      DECLARE FUNCTION ResizeBuffer (BYVAL nChars AS UINT, BYVAL bClear AS BOOLEAN = FALSE) AS WSTRING PTR
      DECLARE FUNCTION AppendBuffer (BYVAL memAddr AS ANY PTR, BYVAL nChars AS UINT) AS BOOLEAN
      DECLARE FUNCTION InsertBuffer (BYVAL memAddr AS ANY PTR, BYVAL nIndex AS UINT, BYVAL nChars AS UINT) AS BOOLEAN
      DECLARE SUB Clear
      DECLARE FUNCTION Add (BYVAL pwszStr AS WSTRING PTR) AS BOOLEAN
      DECLARE FUNCTION Add (BYREF ansiStr AS STRING, BYVAL nCodePage AS UINT = 0) AS BOOLEAN
      DECLARE FUNCTION Add (BYREF dws AS DWSTRING) AS BOOLEAN
      DECLARE PROPERTY Char(BYVAL nIndex AS UINT) AS USHORT
      DECLARE PROPERTY Char(BYVAL nIndex AS UINT, BYVAL nValue AS USHORT)
      DECLARE OPERATOR [] (BYVAL nIndex AS UINT) AS USHORT
      DECLARE FUNCTION DelChars (BYVAL nIndex AS UINT, BYVAL nCount AS UINT) AS BOOLEAN
      DECLARE FUNCTION Insert (BYVAL pwszStr AS WSTRING PTR, BYVAL nIndex AS UINT) AS BOOLEAN
      DECLARE FUNCTION Insert (BYREF ansiStr AS STRING, BYVAL nIndex AS UINT, BYVAL nCodePage AS UINT = 0) AS BOOLEAN
		DECLARE FUNCTION Insert (BYREF dws AS DWSTRING, BYVAL nIndex AS UINT) AS BOOLEAN
      DECLARE OPERATOR CAST () BYREF AS WSTRING
      DECLARE OPERATOR CAST () AS ANY PTR
      DECLARE OPERATOR LET (BYVAL pwszStr AS WSTRING PTR)
      DECLARE OPERATOR LET (BYREF ansiStr AS STRING)
      DECLARE OPERATOR LET (BYREF dws AS DWSTRING)
      DECLARE OPERATOR LET (BYVAL n AS LONGINT)
      DECLARE OPERATOR LET (BYVAL n AS DOUBLE)
      DECLARE OPERATOR += (BYREF ansiStr AS STRING)
      DECLARE OPERATOR += (BYVAL pwszStr AS WSTRING PTR)
      DECLARE OPERATOR += (BYREF dws AS DWSTRING)
      DECLARE OPERATOR += (BYVAL n AS LONGINT)
      DECLARE OPERATOR += (BYVAL n AS DOUBLE)
      DECLARE OPERATOR &= (BYVAL pwszStr AS WSTRING PTR)
      DECLARE OPERATOR &= (BYREF ansiStr AS STRING)
      DECLARE OPERATOR &= (BYREF dws AS DWSTRING)
      DECLARE OPERATOR &= (BYVAL n AS LONGINT)
      DECLARE OPERATOR &= (BYVAL n AS DOUBLE)
      DECLARE FUNCTION vptr () AS WSTRING PTR
      DECLARE FUNCTION sptr () AS WSTRING PTR
      DECLARE FUNCTION wstr () BYREF AS WSTRING
      DECLARE PROPERTY utf8 () AS STRING
      DECLARE PROPERTY utf8 (BYREF ansiStr AS STRING)

END TYPE
' ########################################################################################

' ========================================================================================
' DWSTRING constructors
' ========================================================================================
' ========================================================================================
' Attempts to allocate, or reserve, m_GrowSize number of bytes from the free store (heap).
' The newly allocated memory is initialized.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING
   DWSTRING_DP("DWSTRING CONSTRUCTOR - Default")
   this.ResizeBuffer(m_GrowSize, TRUE)   ' Create the initial buffer
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Attempts to allocate, or reserve, nChars number of bytes from the free store (heap).
' bClear = FALSE: The newly allocated memory is not initialized.
' bClear = TRUE: The newly allocated memory is initialized.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYVAL nChars AS UINT, BYVAL bClear AS BOOLEAN)
   DWSTRING_DP("DWSTRING CONSTRUCTOR - nChars, bClear")
   IF nChars < 1 THEN nChars = m_GrowSize
   this.ResizeBuffer(nChars, bClear)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Initializes the DWSTRING with the contents of the passed WSTRING.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYVAL pwszStr AS WSTRING PTR)
   DWSTRING_DP("DWSTRING CONSTRUCTOR - WSTRING PTR")
   IF pwszStr = NULL THEN this.ResizeBuffer(m_GrowSize) : EXIT CONSTRUCTOR
   this.Add(pwszStr)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Initializes the DWSTRING with the contents of the passed STRING.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYREF ansiStr AS STRING, BYVAL nCodePage AS UINT = 0)
   DWSTRING_DP("DWSTRING CONSTRUCTOR - STRING")
   IF .LEN(ansiStr) = 0 THEN this.ResizeBuffer(m_GrowSize) : EXIT CONSTRUCTOR
   IF .LEN(ansiStr) = 0 THEN this.ResizeBuffer(m_GrowSize) : EXIT CONSTRUCTOR
   this.Add(ansiStr, nCodePage)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Initializes the DWSTRING with the contents of the passed DWSTRING.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYREF dws AS DWSTRING)
   DWSTRING_DP("DWSTRING CONSTRUCTOR - DWSTRING")
   IF dws.m_BufferLen = 0 THEN this.ResizeBuffer(m_GrowSize) : EXIT CONSTRUCTOR
   this.Add(dws)
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' Initializes the DWSTRING with a number.
' These two constructors are needed to allow to use a number with the & operator.
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYVAL n AS LONGINT)
   DWSTRING_DP("DWSTRING CONSTRUCTOR LONGINT")
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Add(wsz)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR DWSTRING (BYVAL n AS DOUBLE)
   DWSTRING_DP("DWSTRING CONSTRUCTOR DOUBLE")
   DIM wsz AS WSTRING * 260 = .WSTR(n)
   this.Add(wsz)
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' Destructor
' ========================================================================================
PRIVATE DESTRUCTOR DWSTRING
   DWSTRING_DP("DWSTRING DESTRUCTOR - buffer: " & .WSTR(m_pBuffer))
   IF m_pBuffer THEN Deallocate(m_pBuffer)
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Number of characters to preallocate to minimize multiple allocations when doing multiple
' concatenations. A value of less than 0 indicates that it must double the capacity each
' time that the buffer needs to be resized.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.GrowSize() AS LONG
   DWSTRING_DP("DWSTRING PROPERTY GET GrowSize")
   PROPERTY = m_GrowSize
END PROPERTY
' ========================================================================================
' ========================================================================================
PRIVATE PROPERTY DWSTRING.GrowSize (BYVAL nChars AS LONG)
   DWSTRING_DP("DWSTRING PROPERTY SET Growsize")
   m_GrowSize = nChars
END PROPERTY
' ========================================================================================

' ========================================================================================
' The size of the internal string buffer is retrieved and returned to the caller. The size
' is the number of characters which can be stored without further expansion.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Capacity() AS UINT
   DWSTRING_DP("DWSTRING PROPERTY GET Capacity")
   PROPERTY = m_Capacity
END PROPERTY
' ========================================================================================
' ========================================================================================
PRIVATE PROPERTY DWSTRING.SizeOf() AS UINT
   DWSTRING_DP("DWSTRING PROPERTY GET SizeOf")
   PROPERTY = m_Capacity
END PROPERTY
' ========================================================================================
' ========================================================================================
' The internal string buffer is expanded to the specified number of characters. If the new
' capacity is smaller than the current capacity, the buffer is shortened and the contents
' that exceed the new capacity are lost.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Capacity (BYVAL nValue AS UINT)
   DWSTRING_DP("DWSTRING PROPERTY SET Capacity")
   IF nValue = m_Capacity THEN EXIT PROPERTY
   this.ResizeBuffer(nValue)
END PROPERTY
' ========================================================================================
' ========================================================================================
PRIVATE PROPERTY DWSTRING.SizeAlloc (BYVAL nValue AS UINT)
   DWSTRING_DP("DWSTRING PROPERTY SET SizeAlloc")
   IF nValue = m_Capacity THEN EXIT PROPERTY
   this.ResizeBuffer(nValue)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns a pointer to the DWSTRING buffer.
' ========================================================================================
PRIVATE OPERATOR DWSTRING.CAST () AS ANY PTR
   DWSTRING_DP("DWSTRING CAST ANY PTR - buffer: " & .WSTR(m_pBuffer))
   OPERATOR = m_pBuffer
END OPERATOR
' ========================================================================================
' ========================================================================================
' Returns the string data (same as **).
' ========================================================================================
PRIVATE OPERATOR DWSTRING.CAST () BYREF AS CONST WSTRING
   DWSTRING_DP("DWSTRING CAST BYREF AS WSTRING - buffer: " & .WSTR(m_pBuffer))
   OPERATOR = *m_pBuffer
END OPERATOR
' ========================================================================================
' ========================================================================================
' Returns the string data (same as **).
' ========================================================================================
PRIVATE FUNCTION DWSTRING.wstr () BYREF AS CONST WSTRING
   DWSTRING_DP("DWSTRING StrAddr - buffer: " & .WSTR(m_pBuffer))
   RETURN *m_pBuffer
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the address of the DWSTRING buffer (same as *)
' ========================================================================================
PRIVATE FUNCTION DWSTRING.vptr () AS WSTRING PTR
   DWSTRING_DP("DWSTRING vptr - buffer: " & .WSTR(m_pBuffer))
   RETURN m_pBuffer
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the address of the DWSTRING buffer.
' Same as vptr for this kind of data type.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.sptr () AS WSTRING PTR
   DWSTRING_DP("DWSTRING sptr - buffer: " & .WSTR(m_pBuffer))
   RETURN m_pBuffer
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the corresponding unicode integer representation of the character at the position
' specified by the nIndex parameter (1 for the first character, 2 for the second, etc.).
' If nIndex is beyond the current length of the string, a 0 is returned.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Char (BYVAL nIndex AS UINT) AS USHORT
   DWSTRING_DP("DWSTRING PROPERTY GET Char")
   IF nIndex < 1 OR nIndex > m_BufferLen THEN EXIT PROPERTY
   ' Get the numeric character code at position nIndex
   nIndex -= 1
   PROPERTY = PEEK(USHORT, m_pBuffer + nIndex)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Changes the corresponding unicode integer representation of the character at the position
' specified by the nIndex parameter (1 for the first character, 2 for the second, etc.).
' If nIndex is beyond the current length of the string, nothing is changed.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Char (BYVAL nIndex AS UINT, BYVAL nValue AS USHORT)
   DWSTRING_DP("DWSTRING PROPERTY SET Char")
   IF nIndex < 1 OR nIndex > m_BufferLen THEN EXIT PROPERTY
   ' Set the numeric character code at position nIndex (zero based)
   nIndex -= 1
   POKE USHORT, m_pBuffer + nIndex, nValue
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the corresponding ASCII or Unicode integer representation of the character at
' the zero-based position specified by the nIndex parameter (0 for the first character,
' 1 for the second, etc.), e.g. value = dws[1].
' ========================================================================================
PRIVATE OPERATOR DWSTRING.[] (BYVAL nIndex AS UINT) AS USHORT
   IF nIndex < 0 OR nIndex > m_BufferLen - 1 THEN EXIT OPERATOR
   ' Get the numeric character code at position nIndex
   OPERATOR = PEEK(USHORT, m_pBuffer + nIndex)
END OPERATOR
' ========================================================================================
' Remarks: To change a value using pointer arithmetic we need to use an intermediate
' pointer variable:
'   DIM dwsText AS DWSTRING = "This is my text."
'   DIM p AS WSTRING PTR = *dwsText
'   p[1] = ASC("x")
' or use casting:
'   (*dwsText)[1] = ASC("x")
' --or--
'   CAST(WSTRING PTR, *dwsText)[1] = ASC("x")
' When using the [] operator this way, there is not range checking. Therefore, make sure
' that the string is not empty and that the index does not exceed the range "[0, Len(dwsText) - 1]".
' Outside this range, results are undefined.
' ========================================================================================

' ========================================================================================
' Converts the DWSTRING to UTF8.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Utf8 () AS STRING
   DWSTRING_DP("DWSTRING Utf8 GET PROPERTY")
   DIM cbLen AS INTEGER
   IF m_BufferLen = 0 THEN RETURN ""
   DIM buffer AS STRING = STRING(m_BufferLen * 5 + 1, 0)
   PROPERTY = *cast(ZSTRING PTR, WCharToUTF(1, m_pBuffer, m_BufferLen * 2, STRPTR(buffer), @cbLen))
END PROPERTY
' ========================================================================================

' ========================================================================================
' Converts UTF8 to unicode and assigns it to the DWSTRING.
' ========================================================================================
PRIVATE PROPERTY DWSTRING.Utf8 (BYREF utf8String AS STRING)
   DWSTRING_DP("DWSTRING Utf8 SET PROPERTY")
   this.Clear
   this.Add(utf8String, CP_UTF8)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Resizes the internal buffer capacity
' ========================================================================================
PRIVATE FUNCTION DWSTRING.ResizeBuffer (BYVAL nChars AS UINT, BYVAL bClear AS BOOLEAN = FALSE) AS WSTRING PTR
   DWSTRING_DP("DWSTRING ResizeBuffer")
   ' // Allocate a buffer of nChars utf16 characters + 1 for the terminating null
   DIM pNewBuffer AS WSTRING PTR = IIF(bClear, CAllocate((nChars + 1) * 2), Allocate((nChars + 1) * 2))
   ' // Copy the old buffer in the new one
   IF nChars < m_BufferLen THEN m_BufferLen = nChars
   IF m_pBuffer THEN
      ' // Copy the old buffer in the new
      wmemmove(pNewBuffer, m_pBuffer, m_BufferLen)
      ' // Deallocate the old buffer
      Deallocate m_pBuffer
   END IF
   ' // Update the capacity
   m_Capacity = nChars
   ' // Store the new pointer
   m_pBuffer = pNewBuffer
   ' // Mark the end of the string with a double null
   m_pBuffer[m_BufferLen] = 0
   RETURN m_pBuffer
END FUNCTION
' ========================================================================================

' ========================================================================================
' Appends the specified number of characters from the specified memory address to the end of the buffer.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.AppendBuffer (BYVAL memAddr AS ANY PTR, BYVAL nChars AS UINT) AS BOOLEAN
   DWSTRING_DP("DWSTRING AppendBuffer")
   IF memAddr = NULL OR nChars = 0 THEN RETURN FALSE
   ' // Number of characters + extra space to avoid multiple memory allocations
   DIM nSize AS UINT = m_BufferLen + nChars + m_GrowSize
   ' // If m_GrowSize = -1 THEN double the current capacity
   IF m_GrowSize < 0 THEN nSize = (m_BufferLen + nChars) * 2
   ' // If there is not enough capacity, resize the buffer
   IF m_BufferLen + nChars > m_Capacity THEN this.ResizeBuffer(nSize)
   ' // Copy the passed buffer
   IF m_pBuffer = NULL THEN RETURN FALSE
   wmemmove(m_pBuffer + m_BufferLen, memAddr, nChars)
   ' // Update the length of the buffer
   m_BufferLen += nChars
   ' // Mark the end of the string with a double null
   m_pBuffer[m_BufferLen] = 0
   RETURN TRUE
END FUNCTION
' ========================================================================================

' ========================================================================================
' nCount characters are removed starting at the position given by nIndex.
' nIndex = 1 for the first character, 2 for the second, etc.
' Return value: If the function succeeds, it returns TRUE; otherwise, FALSE.
' Remarks: If nCount is bigger that the number of characters available to delete, the
' function deletes all the characters from nIndex to the end of the string.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.DelChars (BYVAL nIndex AS UINT, BYVAL nCount AS UINT) AS BOOLEAN
   DWSTRING_DP("DWSTRING DelChars")
   IF nIndex < 1 OR nIndex > m_BufferLen OR nCount < 1 THEN RETURN FALSE
   DIM numChars AS UINT = m_BufferLen
   IF nCount > m_BufferLen - nIndex + 1 THEN nCount = m_BufferLen - nIndex + 1
   wmemmove(m_pBuffer + nIndex - 1, m_pBuffer + (nIndex + nCount) - 1, (m_BufferLen - nIndex - nCount + 1))
   m_BufferLen -= nCount
   m_pBuffer[m_BufferLen] = 0
   RETURN TRUE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Inserts the specified number of characters from the specified memory address into the buffer.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.InsertBuffer (BYVAL memAddr AS ANY PTR, BYVAL nIndex AS UINT, BYVAL nChars AS UINT) AS BOOLEAN
   DWSTRING_DP("DWSTRING InsertBuffer")
   IF nIndex < 1 OR nIndex > m_BufferLen THEN RETURN FALSE
   ' // Determine the size of the new buffer
   IF m_BufferLen + nChars > m_Capacity THEN m_Capacity = m_BufferLen + nChars
   DIM pNewBuffer AS WSTRING PTR = Allocate((m_Capacity + 1) * 2)
   IF m_pBuffer THEN
      ' // Copy the existing data into the new buffer up to nIndex
      nIndex -= 1   ' // Buffer memory is zero-based
      wmemmove(pNewBuffer, m_pBuffer, nIndex)
      ' // Insert characters
      wmemmove(pNewBuffer + nIndex, memAddr, nChars)
      ' // Copy characters from nIndex
      wmemmove(pNewBuffer + nIndex + nChars, m_pBuffer + nIndex, m_BufferLen - nIndex)
      Deallocate m_pBuffer
   END IF
   m_pBuffer = pNewBuffer
   m_BufferLen += nChars
   m_pBuffer[m_BufferLen] = 0
   RETURN TRUE
END FUNCTION
' ========================================================================================

' ========================================================================================
' The incoming string parameter is inserted in the string starting at the position
' given by nIndex. nIndex = 1 for the first character, 2 For the second, etc.
' If nIndex is beyond the current length of the string + 1, no operation is performed.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Insert (BYREF ansiStr AS STRING, BYVAL nIndex AS UINT, BYVAL nCodePage AS UINT = 0) AS BOOLEAN
   DWSTRING_DP("DWSTRING Insert STRING")
   IF nIndex < 1 OR nIndex > m_BufferLen OR .LEN(ansiStr) = 0 THEN RETURN FALSE
   ' // Create the wide string from the incoming ansi string
   DIM dwLen AS UINT, pbuffer AS ANY PTR
   IF nCodePage = CP_UTF8 THEN
      dwLen = MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), NULL, 0)
      IF dwLen = 0 THEN RETURN FALSE
      dwLen *= 2
      pbuffer = Allocate(dwLen)
      dwLen = MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), pbuffer, dwLen)
      IF dwLen = 0 THEN RETURN FALSE
   ELSE
      dwLen = .LEN(ansiStr)
      dwLen *= 2
      pbuffer = Allocate(dwLen)
      dwLen = MultiByteToWideChar(nCodePage, MB_PRECOMPOSED, STRPTR(ansiStr), .LEN(ansiStr), pbuffer, dwLen)
      IF dwLen = 0 THEN RETURN FALSE
   END IF
   ' // Copy the string into the buffer
   DIM bRes AS BOOLEAN = this.InsertBuffer(pbuffer, nIndex, dwLen)
   Deallocate(pbuffer)
   RETURN bRes
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Insert (BYVAL pwszStr AS WSTRING PTR, BYVAL nIndex AS UINT) AS BOOLEAN
   DWSTRING_DP("DWSTRING Insert WSTRING PTR")
   IF nIndex < 1 OR nIndex > m_BufferLen THEN RETURN FALSE
   RETURN this.InsertBuffer(pwszStr, nIndex, .LEN(*pwszStr))
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Insert (BYREF dws AS DWSTRING, BYVAL nIndex AS UINT) AS BOOLEAN
   DWSTRING_DP("DWSTRING Insert DWSTRING")
   IF (nIndex < 1) OR nIndex > m_BufferLen THEN RETURN FALSE
   IF dws.m_BufferLen = 0 THEN RETURN FALSE
   RETURN this.InsertBuffer(dws.m_pBuffer, nIndex, dws.m_BufferLen)
END FUNCTION
' ========================================================================================

' ========================================================================================
' All data in the class object is erased. Actually, we only set the buffer length to zero,
' indicating no string in the buffer. The allocated memory for the buffer is deallocated
' when the class is destroyed.
' ========================================================================================
PRIVATE SUB DWSTRING.Clear
   DWSTRING_DP("DWSTRING Clear")
   m_BufferLen = 0
   m_pBuffer[m_BufferLen] = 0
END SUB
' ========================================================================================

' ========================================================================================
' The string parameter is appended to the string held in the class. If the internal string
' buffer overflows, the class will automatically extend it to an appropriate size.
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Add (BYVAL pwszStr AS WSTRING PTR) AS BOOLEAN
   DWSTRING_DP("DWSTRING Add - WSTRING PTR")
   RETURN this.AppendBuffer(pwszStr, .LEN(*pwszStr))
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Add (BYREF ansiStr AS STRING, BYVAL nCodePage AS UINT = 0) AS BOOLEAN
   DWSTRING_DP("DWSTRING Add - STRING")
   IF LEN(ansiStr) = 0 THEN RETURN FALSE
   ' // Create the wide string from the incoming ansi string
   DIM dwLen AS UINT, pbuffer AS ANY PTR
   IF nCodePage = CP_UTF8 THEN
      dwLen = MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), NULL, 0)
      IF dwLen = 0 THEN RETURN FALSE
      dwLen *= 2
      pbuffer = Allocate(dwLen)
      dwLen = MultiByteToWideChar(CP_UTF8, 0, STRPTR(ansiStr), LEN(ansiStr), pbuffer, dwLen)
      IF dwLen = 0 THEN RETURN FALSE
   ELSE
      dwLen = .LEN(ansiStr)
      dwLen *= 2
      pbuffer = Allocate(dwLen)
      dwLen = MultiByteToWideChar(nCodePage, MB_PRECOMPOSED, STRPTR(ansiStr), .LEN(ansiStr), pbuffer, dwLen)
      IF dwLen = 0 THEN RETURN FALSE
   END IF
   ' // Copy the string into the buffer
   DIM bRes AS BOOLEAN = this.AppendBuffer(pbuffer, dwLen)
   Deallocate(pbuffer)
   RETURN bRes
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWSTRING.Add (BYREF dws AS DWSTRING) AS BOOLEAN
   DWSTRING_DP("DWSTRING Add - DWSTRING")
   RETURN this.AppendBuffer(dws.m_pBuffer, dws.m_BufferLen)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Appends a WSTRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.+= (BYVAL pwszStr AS WSTRING PTR)
   DWSTRING_DP("DWSTRING OPERATOR &= WSTRING PTR")
   this.Add(pwszStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a STRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.+= (BYREF ansiStr AS STRING)
   DWSTRING_DP("DWSTRING OPERATOR += STRING")
   this.Add(ansiStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a DWSTRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.+= (BYREF dws AS DWSTRING)
   DWSTRING_DP("DWSTRING OPERATOR += DWSTRING")
   this.Add(dws)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a number to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.+= (BYVAL n AS LONGINT)
   DWSTRING_DP("DWSTRING OPERATOR += LONGINT")
   DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR DWSTRING.+= (BYVAL n AS DOUBLE)
   DWSTRING_DP("DWSTRING OPERATOR += DOUBLE")
   DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Appends a WSTRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.&= (BYVAL pwszStr AS WSTRING PTR)
   DWSTRING_DP("DWSTRING OPERATOR &= WSTRING PTR")
   this.Add(pwszStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a STRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.&= (BYREF ansiStr AS STRING)
   DWSTRING_DP("DWSTRING OPERATOR &= STRING")
   this.Add(ansiStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a DWSTRING to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.&= (BYREF dws AS DWSTRING)
   DWSTRING_DP("DWSTRING OPERATOR &= DWSTRING")
   this.Add(dws)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Appends a number to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.&= (BYVAL n AS LONGINT)
   DWSTRING_DP("DWSTRING OPERATOR &= LONGINT")
   DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR DWSTRING.&= (BYVAL n AS DOUBLE)
   DWSTRING_DP("DWSTRING OPERATOR &= DOUBLE")
   DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Assigns new text to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.Let (BYVAL pwszStr AS WSTRING PTR)
   DWSTRING_DP("DWSTRING Add - WSTRING PTR")
   this.Clear : this.Add(*pwszStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR DWSTRING.Let (BYREF ansiStr AS STRING)
   DWSTRING_DP("DWSTRING LET STRING")
   this.Clear : this.Add(ansiStr)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR DWSTRING.Let (BYREF dws AS DWSTRING)
   DWSTRING_DP("DWSTRING LET DWSTRING")
   IF m_pBuffer = dws.m_pBuffer THEN EXIT OPERATOR   ' // Ignore dws = dws
   this.Clear : this.Add(dws)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Assigns a number to the DWSTRING
' ========================================================================================
PRIVATE OPERATOR DWSTRING.Let (BYVAL n AS LONGINT)
   DWSTRING_DP("DWSTRING OPERATOR Let LONGINT")
   this.Clear : DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR DWSTRING.Let (BYVAL n AS DOUBLE)
   DWSTRING_DP("DWSTRING OPERATOR Let DOUBLE")
   this.Clear : DIM wsz AS WSTRING * 260 = .WSTR(n) : this.Add(wsz)
END OPERATOR
' ========================================================================================

' ########################################################################################
'                         *** GLOBAL OPERATORS AND FUNCTIONS ***
' ########################################################################################

' ========================================================================================
' Returns the length, in characters, of the DWSTRING.
' ========================================================================================
PRIVATE OPERATOR LEN (BYREF dws AS DWSTRING) AS UINT
   OPERATOR = dws.m_BufferLen
END OPERATOR
' ========================================================================================

' ========================================================================================
' One * returns the address of the DWSTRING buffer.
' Two ** deferences the string data.
' ========================================================================================
PRIVATE OPERATOR * (BYREF dws AS DWSTRING) AS WSTRING PTR
   OPERATOR = dws.m_pBuffer
END OPERATOR
' ========================================================================================

' ========================================================================================
' Concatenates two strings, converting non-strings to strings as needed
' ========================================================================================
PRIVATE OPERATOR & (BYREF dws1 AS DWSTRING, BYREF dws2 AS DWSTRING) AS DWSTRING
   DIM dwsRes AS DWSTRING = dws1
   dwsRes.Add(dws2)
   OPERATOR = dwsRes
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the leftmost substring of a string
' ========================================================================================
PRIVATE FUNCTION Left OVERLOAD (BYREF dws AS DWSTRING, BYVAL nChars AS INTEGER) AS DWSTRING
   RETURN LEFT(*dws.m_pBuffer, nChars)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the rightmost substring of a string
' ========================================================================================
PRIVATE FUNCTION Right OVERLOAD (BYREF dws AS DWSTRING, BYVAL nChars AS INTEGER) AS DWSTRING
   RETURN RIGHT(*dws.m_pBuffer, nChars)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a string to a floating point number
' ========================================================================================
PRIVATE FUNCTION Val OVERLOAD (BYREF dws AS DWSTRING) AS DOUBLE
   RETURN .VAL(*dws.m_pBuffer)
END FUNCTION
' ========================================================================================

' =====================================================================================
' Converts the string to a 32bit integer
' =====================================================================================
PRIVATE FUNCTION ValLng OVERLOAD (BYREF dws AS DWSTRING) AS LONGINT
   RETURN .ValLng(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================
' =====================================================================================
PRIVATE FUNCTION ValInt OVERLOAD (BYREF dws AS DWSTRING) AS LONG
   RETURN .ValInt(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to an unsigned 32bit integer
' =====================================================================================
PRIVATE FUNCTION ValULng OVERLOAD (BYREF dws AS DWSTRING) AS ULONGINT
   RETURN .ValULng(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================
' =====================================================================================
PRIVATE FUNCTION ValUInt OVERLOAD (BYREF dws AS DWSTRING) AS ULONG
   RETURN .ValUInt(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to a 64bit integer
' =====================================================================================
PRIVATE FUNCTION ValLongInt OVERLOAD (BYREF dws AS DWSTRING) AS LONGINT
   RETURN .ValLng(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================

' =====================================================================================
' Converts the string to an unsigned 64bit integer
' =====================================================================================
PRIVATE FUNCTION ValULongInt OVERLOAD (BYREF dws AS DWSTRING) AS ULONGINT
   RETURN .ValULng(*dws.m_pBuffer)
END FUNCTION
' =====================================================================================

' ########################################################################################
'                                *** HELPER FUNCTIONS ***
' ########################################################################################

' ========================================================================================
' qsort DWSTRING comparison function
' ========================================================================================
PRIVATE FUNCTION DWStringArrayCompare CDECL (BYVAL a AS DWSTRING PTR, BYVAL b AS DWSTRING PTR) AS LONG
   FUNCTION = wcscmp(a->m_pBuffer, b->m_pBuffer)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Reverse qsort DWSTRING comparison function
' ========================================================================================
PRIVATE FUNCTION DWStringArrayReverseCompare CDECL (BYVAL a AS DWSTRING PTR, BYVAL b AS DWSTRING PTR) AS LONG
   DIM r AS LONG = wcscmp(a->m_pBuffer, b->m_pBuffer)
   IF r = 1 THEN r = -1 ELSE IF r = -1 THEN r = 1
   RETURN r
END FUNCTION
' ========================================================================================

' ========================================================================================
' Sorts a one-dimensional DWSTRING array calling the C qsort function.
' Parameters:
' - rgwstr : Start of target array.
' - numElm : Number of elements in the array.
' - bAscend: TRUE for sorting in ascending order; FALSE for sorting in descending order.
' Example:
' DIM rg(1 TO 10) AS DWSTRING
' FOR i AS LONG = 1 TO 10
'    rg(i) = "string " & i
' NEXT
' FOR i AS LONG = 1 TO 10
'   print rg(i)
' NEXT
' print "---- after sorting ----"
' DWStringArraySort rg()
' FOR i AS LONG = 1 TO 10
'    print rg(i)
' NEXT
' ========================================================================================
PRIVATE SUB DWStringSort (BYREF rgwstr AS ANY PTR, BYVAL numElm AS LONG, BYVAL bAscend AS BOOLEAN = TRUE)
   IF rgwstr = NULL OR numElm < 2 THEN EXIT SUB
   IF bAscend THEN
      qsort rgwstr, numElm, SIZEOF(DWSTRING), CPTR(ANY PTR, @DWStringArrayCompare)
   ELSE
      qsort rgwstr, numElm, SIZEOF(DWSTRING) , CPTR(ANY PTR, @DWStringArrayReverseCompare)
   END IF
END SUB
' ========================================================================================
' ========================================================================================
PRIVATE SUB DWStringArraySort (rgwstr() AS DWSTRING, BYVAL bAscend AS BOOLEAN = TRUE)
   DIM numElm AS LONG = UBOUND(rgwstr) - LBOUND(rgwstr) + 1
   DWStringSort @rgwstr(LBOUND(rgwstr)), numElm, bAscend
END SUB
' ========================================================================================
