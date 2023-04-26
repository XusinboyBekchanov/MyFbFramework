' ########################################################################################
' Platform: Microsoft Windows
' Filename: DWStrProcs.bi
' Contents: String wrapper functions.
' Compiler: FreeBasic 32 & 64-bit, Unicode.
' Copyright (c) 2018 José Roca. Freeware. Use at your own risk.
' ########################################################################################

#pragma once
#include once "DWString.bi"

' ========================================================================================
' * Returns a copy of a string with substrings removed.
' If wszMatchStr is not present in wszMainStr, all of wszMainStr is returned intact.
' This function is case sensitive.
' Example: DWStrRemove("Hello World. Welcome to the Freebasic World", "World")
' ========================================================================================
PRIVATE FUNCTION DWStrRemove OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   DIM nLen AS LONG = LEN(wszMatchStr)
   DO
      DIM nPos AS LONG = INSTR(**dws, wszMatchStr)
      IF nPos = 0 THEN EXIT DO
      dws.DelChars nPos, nLen
   LOOP
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Case insensitive version of DWStrRemove.
' Example: DWStrRemoveI("Hello World. Welcome to the Freebasic World", "world")
' ========================================================================================
PRIVATE FUNCTION DWStrRemoveI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   DIM nLen AS LONG = LEN(wszMatchStr)
   DO
      DIM nPos AS LONG = INSTR(UCASE(**dwsMainStr), **dwsMatchStr)
      IF nPos = 0 THEN EXIT DO
      dwsMainStr.DelChars nPos, nLen
   LOOP
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a copy of a string with a substring enclosed between the specified delimiters removed.
' Parameters:
' nStart: [Optional]. The one-based starting position where to start the search
' wszMainStr: The main string
' wszDelim1: The first delimiter
' wszDelim2: The second delimiter
' fRemoveAll: TRUE or FALSE. TRUE = Recursively remove all the occurrences.
' This function is case-sensitive.
' Example:
' DIM dwsText AS DWSTRING = "blah blah (text beween parentheses) blah blah"
' print DWStrRemove(dwsText, "(", ")")   ' Returns "blah blah  blah blah"
' Example:
' DIM dwsText AS DWSTRING = "As Long var1(34), var2(  73 ), var3(any)"
' print DWStrRemove(dwsText, "(", ")", TRUE)   ' Returns "As Long var1, var2, var3"
' ========================================================================================
PRIVATE FUNCTION DWStrRemove OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszDelim1 AS CONST WSTRING, BYREF wszDelim2 AS CONST WSTRING, BYVAL fRemoveAll AS BOOLEAN = FALSE) AS DWSTRING
   DIM nPos1 AS LONG = INSTR(wszMainStr, wszDelim1)
   IF nPos1 = 0 THEN RETURN wszMainStr
   DIM nPos2 AS LONG = INSTR(nPos1 + LEN(wszDelim1), wszMainStr, wszDelim2)
   IF nPos2 = 0 THEN RETURN wszMainStr
   nPos2 += LEN(wszDelim2)
   DIM nLen AS LONG = nPos2 - nPos1
   IF fRemoveAll = FALSE THEN RETURN MID(wszMainStr, 1, nPos1 - 1) & MID(wszMainStr, nPos2)
   RETURN DWStrRemove(MID(wszMainStr, 1, nPos1 - 1) & MID(wszMainStr, nPos2), wszDelim1, wszDelim2, fRemoveAll)
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWStrRemove OVERLOAD (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszDelim1 AS CONST WSTRING, BYREF wszDelim2 AS CONST WSTRING, BYVAL fRemoveAll AS BOOLEAN = FALSE) AS DWSTRING
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   DIM nPos1 AS LONG = INSTR(nStart, wszMainStr, wszDelim1)
   IF nPos1 = 0 THEN RETURN wszMainStr
   DIM nPos2 AS LONG = INSTR(nPos1, wszMainStr, wszDelim2)
   IF nPos2 = 0 THEN RETURN wszMainStr
   nPos2 += LEN(wszDelim2)
   nLen = nPos2 - nPos1
   IF fRemoveAll = FALSE THEN RETURN MID(wszMainStr, 1, nPos1 - 1) & MID(wszMainStr, nPos2)
   RETURN DWStrRemove(nStart, MID(wszMainStr, 1, nPos1 - 1) & MID(wszMainStr, nPos2), wszDelim1, wszDelim2, fRemoveAll)
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a copy of a string with characters removed.
' If wszMatchStr is not present in wszMainStr, all of wszMainStr is returned intact.
' wszMatchStr specifies a list of single characters to be searched for individually,
' a match on any one of which will cause that character to be removed from the result.
' This function is case sensitive.
' Example: DWStrRemoveAny("abacadabra", "bac")   ' -> "dr"
' ========================================================================================
PRIVATE FUNCTION DWStrRemoveAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   FOR i AS LONG = 1 TO LEN(wszMatchStr)
      DO
         DIM nPos AS LONG = INSTR(**dwsMainStr, MID(wszMatchStr, i, 1))
         IF nPos = 0 THEN EXIT DO
         dwsMainStr.DelChars nPos, 1
      LOOP
   NEXT
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrRemoveAny.
' Example: DWStrRemoveAnyI("abacadabra", "BaC")   ' -> "dr"
' ========================================================================================
PRIVATE FUNCTION DWStrRemoveAnyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   FOR i AS LONG = 1 TO LEN(wszMatchStr)
      DO
         DIM nPos AS LONG = INSTR(UCASE(**dwsMainStr), MID(**dwsMatchStr, i, 1))
         IF nPos = 0 THEN EXIT DO
         dwsMainStr.DelChars nPos, 1
      LOOP
   NEXT
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Within a specified string, replace all occurrences of one string with another string.
' Replaces all occurrences of wszMatchStr in wszMainStr with wszReplaceWith
' The replacement can cause wszMainStr to grow or condense in size.
' When a match is found, the scan for the next match begins at the position immediately
' following the prior match.
' This function is case sensitive.
' Example: DWStrReplace("Hello World", "World", "Earth")   ' -> "Hello Earth"
' ========================================================================================
PRIVATE FUNCTION DWStrReplace OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYREF wszReplaceWith AS WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM nLenReplaceWith AS LONG = LEN(wszReplaceWith)
   DIM nLenMatchStr AS LONG = LEN(wszMatchStr)
   DIM nPos AS LONG = 1
   DO
      nPos = INSTR(nPos, **dwsMainStr, wszMatchStr)
      IF nPos = 0 THEN EXIT DO
      dwsMainStr = MID(**dwsMainStr, 1, nPos - 1) + wszReplaceWith + MID(**dwsMainStr, nPos + nLenMatchStr)
      nPos += nLenReplaceWith
   LOOP
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrReplace.
' Example: DwStrReplaceI("Hello world", "World", "Earth")   ' -> "Hello Earth"
' ========================================================================================
PRIVATE FUNCTION DWStrReplaceI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYREF wszReplaceWith AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   DIM nLenReplaceWith AS LONG = LEN(wszReplaceWith)
   DIM nLenMatchStr AS LONG = LEN(wszMatchStr)
   DIM nPos AS LONG = 1
   DO
      nPos = INSTR(nPos, UCASE(**dwsMainStr), **dwsMatchStr)
      IF nPos = 0 THEN EXIT DO
      dwsMainStr = MID(**dwsMainStr, 1, nPos - 1) + wszReplaceWith + MID(**dwsMainStr, nPos + nLenMatchStr)
      nPos += nLenReplaceWith
   LOOP
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Within a specified string, replace all occurrences of any of the individual characters
' specified in the wszMainStr string.
' wszReplaceWith must be a single character. This function does not replace words therefore
' wszMatchStr will be the same size - it will not shrink or grow.
' This function is case-sensitive.
' Example: DWStrReplaceAny("abacadabra", "bac", "*")   ' -> *****d**r*
' ========================================================================================
PRIVATE FUNCTION DWStrReplaceAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYREF wszReplaceWith AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   IF LEN(wszMatchStr) = 0 THEN RETURN dwsMainStr
   IF LEN(wszReplaceWith) = 0 THEN RETURN dwsMainStr
   FOR x AS LONG = 1 TO LEN(wszMatchStr)
      FOR i AS LONG = 1 TO LEN(wszMainStr)
         IF MID(wszMatchStr, x, 1) = MID(wszMainStr, i, 1) THEN
            MID(**dwsMainStr, i, 1) = wszReplaceWith
         END IF
      NEXT
   NEXT
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrReplaceAny.
' Example: DWStrReplaceAnyI("abacadabra", "BaC", "*")   ' -> *****d**r*
' ========================================================================================
PRIVATE FUNCTION DWStrReplaceAnyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYREF wszReplaceWith AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   IF LEN(wszMatchStr) = 0 THEN RETURN dwsMainStr
   IF LEN(wszReplaceWith) = 0 THEN RETURN dwsMainStr
   FOR x AS LONG = 1 TO LEN(wszMatchStr)
      FOR i AS LONG = 1 TO LEN(wszMainStr)
         IF MID(UCASE(wszMatchStr), x, 1) = MID(UCASE(wszMainStr), i, 1) THEN
            MID(**dwsMainStr, i, 1) = wszReplaceWith
         END IF
      NEXT
   NEXT
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Reverses the contents of a string expression.
' Usage example: DIM dws AS DWSTRING = DWStrReverse("garden")
' ========================================================================================
PRIVATE FUNCTION DWStrReverse (BYREF wszMainStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM wszChar AS WSTRING * 2
   DIM nLen AS LONG = LEN(wszMainStr)
   FOR i AS LONG = 1 TO nLen \ 2
      wszChar = MID(**dwsMainStr, i, 1)
      MID(**dwsMainStr, i, 1) = MID(**dwsMainStr, nLen - i + 1, 1)
      MID(**dwsMainStr, nLen - i + 1, 1) = wszChar
   NEXT
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Extracts characters from a string up to a character or group of characters.
' Complement function to DWStrRemain.
' Returns a substring of wszMainStr starting with its first character (or the character
' specified by nStart) and up to (but not including) the first occurrence of wszMatchStr
' If wszMatchStr is not present in wszMainStr (or is null) then all of wszMainStr is
' returned from the nStart position.
' This function is case-sensitive.
' The following line returns "aba" (match on "cad")
' DIM dws AS DWSTRING = DWStrExtract(1, "abacadabra","cad")
' ========================================================================================
PRIVATE FUNCTION DWStrExtract OVERLOAD (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   DIM nPos AS LONG = INSTR(nStart, wszMainStr, wszMatchStr)
   IF nPos THEN RETURN MID(wszMainStr, nStart, nPos - nStart)
   RETURN MID(wszMainStr, nStart)
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrExtract.
' DIM dws AS DWSTRING = DWStrExtractI(1, "abacadabra","CaD")
' ========================================================================================
PRIVATE FUNCTION DWStrExtractI (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   DIM nPos AS LONG = INSTR(nStart, UCASE(wszMainStr), UCASE(wszMatchStr))
   IF nPos THEN RETURN MID(wszMainStr, nStart, nPos - nStart )
   RETURN dws = MID(wszMainStr, nStart)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the portion of a string following the occurrence of a specified delimiter up to
' the second delimiter. If one of the delimiters isn't found, it returns an empty string.
' Parameters:
' nStart: [Optional]. The one-based starting position where to start the search
' wszMainStr: The main string
' wszDelim1: The first delimiter
' wszDelim2: The second delimiter
' This function is case-sensitive.
' Example:
' DIM dwsText AS DWSTRING = "blah blah (text beween parentheses) blah blah"
' print DWStrExtract(dwsText, "(", ")")
' ========================================================================================
PRIVATE FUNCTION DWStrExtract OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszDelim1 AS CONST WSTRING, BYREF wszDelim2 AS CONST WSTRING) AS DWSTRING
   DIM nPos1 AS LONG = INSTR(wszMainStr, wszDelim1)
   IF nPos1 = 0 THEN RETURN ""
   nPos1 += LEN(wszDelim1)
   DIM nPos2 AS LONG = INSTR(nPos1, wszMainStr, wszDelim2)
   IF nPos2 = 0 THEN RETURN ""
   DIM nLen AS LONG = nPos2 - nPos1
   RETURN MID(wszMainStr, nPos1, nLen)
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWStrExtract OVERLOAD (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszDelim1 AS CONST WSTRING, BYREF wszDelim2 AS CONST WSTRING) AS DWSTRING
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   DIM nPos1 AS LONG = INSTR(nStart, wszMainStr, wszDelim1)
   IF nPos1 = 0 THEN RETURN ""
   nPos1 += LEN(wszDelim1)
   DIM nPos2 AS LONG = INSTR(nPos1, wszMainStr, wszDelim2)
   IF nPos2 = 0 THEN RETURN ""
   nLen = nPos2 - nPos1
   RETURN MID(wszMainStr, nPos1, nLen)
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Extract characters from a string up to a specific character.
' Returns a substring of wszMainStr starting with its first character (or the character
' specified by nStart) and up to (but not including) the first occurrence of wszMatchStr.
' wszMatchStr specifies a list of single characters to be searched for individually, a
' match on any one of which will cause the extract operation to be performed up to that character.
' If wszMatchStr is not present in wszMainStr (or is null) then all of wszMainStr is returned.
' This function is case-sensitive.
' The following line returns "aba" (match on "c")
' Example: DWStrExtractAny(1, "abacadabra","cd")
' ========================================================================================
PRIVATE FUNCTION DWStrExtractAny (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   FOR i AS LONG = nStart TO nLen
      FOR x AS LONG = 1 TO LEN(wszMatchStr)
         IF MID(wszMainStr, i, 1) = MID(wszMatchStr, x, 1) THEN
            dwsMainStr = MID(wszMainStr, nStart, i - nStart)
            RETURN dwsMainStr
         END IF
      NEXT
   NEXT
   RETURN ""
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrExtractAny.
' Example: DWStrExtractAnyI(1, "abacadabra","CD")
' ========================================================================================
PRIVATE FUNCTION DWStrExtractAnyI (BYVAL nStart AS LONG = 1, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dwsMainStr AS DWSTRING = wszMainStr
   DIM nLen AS LONG = LEN(wszMainStr)
   IF (nStart = 0) OR (nStart > nLen) THEN RETURN ""
   IF nStart < 0 THEN nStart = nLen + nStart + 1
   FOR i AS LONG = nStart TO nLen
      FOR x AS LONG = 1 TO LEN(wszMatchStr)
         IF MID(UCASE(wszMainStr), i, 1) = MID(UCASE(wszMatchStr), x, 1) THEN
            dwsMainStr = MID(wszMainStr, nStart, i - nStart)
            RETURN dwsMainStr
         END IF
      NEXT
   NEXT
   RETURN ""
END FUNCTION
' ========================================================================================


' ========================================================================================
' * Complement to the DWStrExtract function.
' Returns the portion of a string following the first occurrence of a substring.
' wszMainStr is searched for the string specified in wszMatchStr If found, all characters
' after wszMatchStr are returned. If wszMatchStr is not present in wszMainStr (or is null) then
' a zero-length empty string is returned.
' nStart is an optional starting position to begin searching. If nStart is not specified,
' position 1 will be used. If nStart is zero, a nul string is returned. If nStart is negative,
' the starting position is counted from right to left: if -1, the search begins at the last
' character; if -2, the second to last, and so forth.
' This function is case-sensitive.
' Example: DWStrRemain("Brevity is the soul of wit", "is ")   ' -> "the soul of wit"
' ========================================================================================
PRIVATE FUNCTION DWStrRemain (BYREF wszMainStr AS WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYVAL nStart AS LONG = 1) AS DWSTRING
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN ""
   IF nStart = 0 OR nStart > LEN(wszMainStr) THEN RETURN ""
   IF nStart < 0 THEN nStart = LEN(wszMainStr) + nStart + 1
   DIM nPos AS LONG = INSTR(nStart, wszMainStr, wszMatchStr)
   IF nPos = 0 THEN RETURN ""
   DIM dwsMainStr AS DWSTRING = wszMainStr
   dwsMainStr = MID(**dwsMainStr, nPos + LEN(wszMatchStr))
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrRemain.
' Example: DWStrRemainI("Brevity is the soul of wit", "Is ")   ' -> "the soul of wit"
' ========================================================================================
PRIVATE FUNCTION DWStrRemainI (BYREF wszMainStr AS WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYVAL nStart AS LONG = 1) AS DWSTRING
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN ""
   IF nStart = 0 OR nStart > LEN(wszMainStr) THEN RETURN ""
   IF nStart < 0 THEN nStart = LEN(wszMainStr) + nStart + 1
   DIM nPos AS LONG = INSTR(nStart, UCASE(wszMainStr), UCASE(wszMatchStr))
   IF nPos = 0 THEN RETURN ""
   DIM dwsMainStr AS DWSTRING = wszMainStr
   dwsMainStr = MID(**dwsMainStr, nPos + LEN(wszMatchStr))
   RETURN dwsMainStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Complement to the DWStrExtract function. Returns the portion of a string following the
' first occurrence of a character or group of characters.
' wszMainStr is searched for the string specified in wszMatchStr If found, all characters
' after wszMatchStr are returned. If wszMatchStr is not present in wszMainStr (or is null) then
' a zero-length empty string is returned.
' wszMatchStr specifies a list of single characters to be searched for individually. A match
' on any one of which will cause the extract operation be performed after that character.
' nStart is an optional starting position to begin searching. If nStart is not specified,
' position 1 will be used. If nStart is zero, a nul string is returned. If nStart is negative,
' the starting position is counted from right to left: if -1, the search begins at the last
' character; if -2, the second to last, and so forth.
' This function is case-sensitive.
' Example: DWStrRemainAny("I think, therefore I am", ",")   ' -> " therefore I am"
' ========================================================================================
PRIVATE FUNCTION DWStrRemainAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS WSTRING, BYVAL nStart AS LONG = 1) AS DWSTRING
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN ""
   IF nStart = 0 OR nStart > LEN(wszMainStr) THEN RETURN ""
   IF nStart < 0 THEN nStart = LEN(wszMainStr) + nStart + 1
   DIM dwsMainStr AS DWSTRING
   FOR i AS LONG = nStart TO LEN(wszMainStr)
      FOR x AS LONG = 1 TO LEN(wszMatchStr)
         IF MID(wszMainStr, i, 1) = MID(wszMatchStr, x, 1) THEN
            dwsMainStr = MID(wszMainStr, i + 1)
            RETURN dwsMainStr
         END IF
      NEXT
   NEXT
   RETURN ""
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DwStrRemainAny.
' Example: DWStrRemainAnyI("I think, therefore I am", "E")   ' -> "refore I am"
' ========================================================================================
PRIVATE FUNCTION DWStrRemainAnyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING, BYVAL nStart AS LONG = 1) AS DWSTRING
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN ""
   IF nStart = 0 OR nStart > LEN(wszMainStr) THEN RETURN ""
   IF nStart < 0 THEN nStart = LEN(wszMainStr) + nStart + 1
   DIM dwsMainStr AS DWSTRING
   FOR i AS LONG = nStart TO LEN(wszMainStr)
      FOR x AS LONG = 1 TO LEN(wszMatchStr)
         IF MID(UCASE(wszMainStr), i, 1) = MID(UCASE(wszMatchStr), x, 1) THEN
            dwsMainStr = MID(wszMainStr, i + 1)
            RETURN dwsMainStr
         END IF
      NEXT
   NEXT
   RETURN ""
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Count the number of occurrences of strings within a string.
' wszMainStr is the string expression in which to count characters.
' wszMatchStr is the string expression to count all occurrences of.
' If cbMatchStr is not present in wszMainStr, zero is returned.
' When a match is found, the scan for the next match begins at the position immediately
' following the prior match.
' This function is case-sensitive.
' Example: DIM nCount AS LONG = DWStrTally("abacadabra", "ab")   ' -> 2
' ========================================================================================
PRIVATE FUNCTION DWStrTally (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   DIM nCount AS LONG, nPos AS LONG = 1
   DIM nLen AS LONG = LEN(wszMatchStr)
   DO
      nPos = INSTR(nPos, wszMainStr, wszMatchStr)
      IF nPos = 0 THEN EXIT DO
      nCount += 1
      nPos += nLen
   LOOP
   RETURN nCount
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrTally.
' Example: DIM nCount AS LONG = DWStrTallyI("abacadabra", "Ab")   ' -> 2
' ========================================================================================
PRIVATE FUNCTION DWStrTallyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   DIM nCount AS LONG, nPos AS LONG = 1
   DIM dwsMainStr AS DWSTRING = UCASE(wszMainStr)
   DIM dwsMatchStr AS DWSTRING = UCASE (wszMatchStr)
   DIM nLen AS LONG = LEN(wszMatchStr)
   DO
      nPos = INSTR(nPos, **dwsMainStr, **dwsMatchStr)
      IF nPos = 0 THEN EXIT DO
      nCount += 1
      nPos += nLen
   LOOP
   RETURN nCount
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Count the number of occurrences of specified characters strings within a string.
' wszMainStr is the string expression in which to count characters.
' wszMatchStr is a list of single characters to be searched for individually. A match on
' any one of which will cause the count to be incremented for each occurrence of that
' character. Note that repeated characters in wszMatchStr will not increase the count.
' This function is case-sensitive.
' Example: DIM nCount AS LONG = DWStrTallyAny("abacadabra", "bac")   ' -> 8
' ========================================================================================
PRIVATE FUNCTION DWStrTallyAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN EXIT FUNCTION
   ' // Remove possible duplicates in the matches string
   DIM nPos AS LONG
   DIM dwsMatchStr AS DWSTRING = wszMatchStr
   FOR i AS LONG = 1 TO LEN(dwsMatchStr)
      nPos = INSTR(**dwsMatchStr, MID(wszMatchStr, i, 1))
      IF nPos = 0 THEN dwsMatchStr += MID(wszMatchStr, i, 1)
   NEXT
   ' // Do the count
   DIM nCount AS LONG
   FOR i AS LONG = 1 TO LEN(dwsMatchStr)
      nPos = 1
      DO
         nPos = INSTR(nPos, wszMainStr, MID(**dwsMatchStr, i, 1))
         IF nPos = 0 THEN EXIT DO
         IF nPos THEN
            nCount += 1
            nPos += 1
         END IF
      LOOP
   NEXT
   RETURN nCount
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrTallyAny.
' Example: DIM nCount AS LONG = DWStrTallyAnyI("abacadabra", "bAc")
' ========================================================================================
PRIVATE FUNCTION DWStrTallyAnyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN EXIT FUNCTION
   ' // Remove possible duplicates in the matches string
   DIM nPos AS LONG
   DIM dwsMainStr AS DWSTRING = UCASE(wszMainStr)
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   FOR i AS LONG = 1 TO LEN(dwsMatchStr)
      nPos = INSTR(**dwsMatchStr, MID(wszMatchStr, i, 1))
      IF nPos = 0 THEN dwsMatchStr += MID(wszMatchStr, i, 1)
   NEXT
   ' // Do the count
   DIM nCount AS LONG
   FOR i AS LONG = 1 TO LEN(dwsMatchStr)
      nPos = 1
      DO
         nPos = INSTR(nPos, **dwsMainStr, MID(**dwsMatchStr, i, 1))
         IF nPos = 0 THEN EXIT DO
         IF nPos THEN
            nCount += 1
            nPos += 1
         END IF
      LOOP
   NEXT
   RETURN nCount
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Determine whether each character of a string is present in another string.
' Returns zero if each character in wszMainStr is present in wszMatchStr
' If not, it returns the position of the first non-matching character in wszMainStr.
' This function is very useful for determining if a string contains only numeric digits, for example.
' This function is case-sensitive.
' If nStart evaluates to a position outside of the string, or if nStart is zero, then the
' function returns zero.
' Example: DIM nCount AS LONG = DWStrVerify(5, "123.65,22.5", "0123456789")   ' -> 7
' Rreturns 7 since 5 starts it past the first non-digit ("." at position 4)
' ========================================================================================
PRIVATE FUNCTION DWStrVerify (BYVAL nStart AS LONG, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   IF nStart <= 0 OR nStart > LEN(wszMainStr) THEN RETURN 0
   ' // Get each character in wszMainStr and look for it in wszMatchStr
   DIM AS LONG nPos, idx
   FOR i AS LONG = nStart TO LEN(wszMainStr)
      nPos = INSTR(wszMatchStr, MID(wszMainStr, i, 1))
      IF nPos = 0 THEN
         idx = i
         EXIT FOR
      END IF
   NEXT
   RETURN  idx
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case sensintive version of DWStrVerify.
' Example: DWStrVerifyI(5, "123.65abcx22.5", "0123456789ABC")   ' -> 10
' ========================================================================================
PRIVATE FUNCTION DWStrVerifyI (BYVAL nStart AS LONG, BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS LONG
   IF nStart <= 0 OR nStart > LEN(wszMainStr) THEN RETURN 0
   ' // Get each character in wszMainStr and look for it in wszMatchStr
   DIM dwsMainStr AS DWSTRING = UCASE(wszMainStr)
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   DIM AS LONG nPos, idx
   FOR i AS LONG = nStart TO LEN(dwsMainStr)
      nPos = INSTR(**dwsMatchStr, MID(**dwsMainStr, i, 1))
      IF nPos = 0 THEN
         idx = i
         EXIT FOR
      END IF
   NEXT
   RETURN  idx
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string containing a left-justified (padded) string.
' If the optional parameter wszPadCharacter not specified, the function pads the string with
' space characters to the left. Otherwise, the function pads the string with the first
' character of wszPadCharacter
' Example: DIM dws AS DWSTRING = DWStrLSet("FreeBasic", 20, "*")
' ========================================================================================
PRIVATE FUNCTION DWStrLSet (BYREF wszMainStr AS CONST WSTRING, BYVAL nStringLength AS LONG, BYREF wszPadCharacter AS CONST WSTRING = " ") AS DWSTRING
   DIM dws AS DWSTRING = WSTRING(nStringLength, wszPadCharacter)
   MID(**dws, 1, LEN(wszMainStr)) = wszMainStr
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string containing a right-justified (padded) string.
' If the optional parameter wszPadCharacter not specified, the function pads the string with
' space characters to the left. Otherwise, the function pads the string with the first
' character of wszPadCharacter.
' Example: DIM dws AS DWSTRING = DWStrRSet("FreeBasic", 20, "*")
' ========================================================================================
PRIVATE FUNCTION DWStrRSet (BYREF wszMainStr AS CONST WSTRING, BYVAL nStringLength AS LONG, BYREF wszPadCharacter AS CONST WSTRING = " ") AS DWSTRING
   IF LEN(wszMainStr) > nStringLength THEN RETURN LEFT(wszMainStr, nStringLength)
   DIM dws AS DWSTRING = WSTRING(nStringLength, wszPadCharacter)
   MID(**dws, nStringLength - LEN(wszMainStr) + 1, LEN(wszMainStr)) = wszMainStr
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string containing a centered (padded) string.
' If the optional parameter wszPadCharacter not specified, the function pads the string with
' space characters to the left. Otherwise, the function pads the string with the first
' character of wszPadCharacter.
' Example: DIM dws AS DWSTRING = DWStrCSet("FreeBasic", 20, "*")
' ========================================================================================
PRIVATE FUNCTION DWStrCSet (BYREF wszMainStr AS CONST WSTRING, BYVAL nStringLength AS LONG, BYREF wszPadCharacter AS CONST WSTRING = " ") AS DWSTRING
   IF LEN(wszMainStr) > nStringLength THEN RETURN LEFT(wszMainStr, nStringLength)
   DIM dws AS DWSTRING = WSTRING(nStringLength, wszPadCharacter)
   MID(**dws, (nStringLength - LEN(wszMainStr)) \ 2 + 1, LEN(wszMainStr)) = wszMainStr
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
'  Parses a path/file name to extract component parts.
'  This function evaluates a text path/file text name, and returns a requested part of the
'  name. The functionality is strictly one of string parsing alone.
'  wszOption is one of the following words which is used to specify the requested part:
'  PATH
'        Returns the path portion of the path/file Name. That is the text up to and
'        including the last backslash (\) or colon (:).
'  NAME
'        Returns the name portion of the path/file Name. That is the text to the right
'        of the last backslash (\) or colon (:), ending just before the last period (.).
'  EXTN
'        Returns the extension portion of the path/file name. That is the last
'        period (.) in the string plus the text to the right of it.
'  NAMEX
'        Returns the name and the EXTN parts combined.
' Example:
' DIM dwsPath AS DWSTRING = ExePath
' PRINT DWStrPathName("Name", dwsPath)
' ========================================================================================
PRIVATE FUNCTION DWStrPathName (BYREF wszOption AS CONST WSTRING, BYREF wszFileSpec AS WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   IF LEN(wszFileSpec) = 0 THEN RETURN dws
   SELECT CASE UCASE(wszOption)
      CASE "PATH"
         ' // Returns the path portion of file spec
         DIM nPos AS LONG = InstrRev(wszFileSpec, ANY ":/\")
         IF nPos THEN dws = MID(wszFileSpec, 1, nPos)
      CASE "NAME"
         ' // Retrieve the full filename
         dws = wszFileSpec
         DIM nPos AS LONG = InstrRev(wszFileSpec, ANY ":/\")
         IF nPos THEN dws = MID(wszFileSpec, nPos + 1)
         ' // Retrieve the filename
         nPos = InstrRev(dws, ".")
         IF nPos THEN dws = MID(dws, 1, nPos - 1)
      CASE "NAMEX"
         ' // Retrieve the name and extension combined
         DIM nPos AS LONG = InStrRev(wszFileSpec, ANY ":/\")
         IF nPos THEN dws = MID(wszFileSpec, nPos + 1) ELSE dws = wszFileSpec
      CASE "EXTN"
         ' // Retrieve the name and extension combined
         DIM nPos AS LONG = InstrRev(wszFileSpec, ANY ":/\")
         IF nPos THEN dws = MID(wszFileSpec, nPos + 1) ELSE dws = wszFileSpec
         ' // Retrieve the extension
         nPos = InStrRev(dws, ".")
         IF nPos THEN dws = MID(dws, nPos) ELSE dws = ""
   END SELECT
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string consisting of multiple copies of the specified string.
' This function is very similar to STRING (which makes multiple copies of a single character).
' Example: DIM dws AS DWSTRING = DWStrRepeat(5, "Paul")
' ========================================================================================
PRIVATE FUNCTION DWStrRepeat (BYVAL nCount AS LONG, BYREF wszMainStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   IF nCount <= 0 THEN RETURN dws
   ' // Create the final full buffer and insert the strings into it
   ' // in order to avoid nCount concatenations.
   DIM nLen AS LONG = LEN(wszMainStr)
   dws = SPACE(nCount * nLen)
   FOR i AS LONG = 0 TO nCount - 1
      MID(**dws, (i * nLen) + 1, nLen) = wszMainStr
   NEXT
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string with nCount characters removed from the left side of the string.
' If nCount is less than one then the entire string is returned.
' Example: DIM dws AS DWSTRING = DWStrClipLeft("1234567890", 3)
' ========================================================================================
PRIVATE FUNCTION DWStrClipLeft (BYREF wszMainStr AS CONST WSTRING, BYVAL nCount AS LONG) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   IF nCount <= 0 THEN RETURN dws
   DIM nLen AS LONG = LEN(wszMainStr)
   nCount = IIF(nLen < nCount, nLen, nCount)
   dws = MID(wszMainStr, nCount + 1)
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string with nCount characters removed from the right side of the string.
' If nCount is less than one then the entire string is returned.
' DIM dws AS DWSTRING = DWStrClipRight("1234567890", 3)
' ========================================================================================
PRIVATE FUNCTION DWStrClipRight (BYREF wszMainStr AS CONST WSTRING, BYVAL nCount AS LONG) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   IF nCount <= 0 THEN RETURN dws
   DIM nLen AS LONG = LEN(wszMainStr)
   nCount = nLen - nCount
   nCount = IIF(nLen < nCount, nLen, nCount)
   dws = LEFT(wszMainStr, nCount)
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a string with nCount characters removed starting at position nStart. The first
' character is considered position 1, the second position 2, etc...
' If nCount or nStart is less than one then the entire string is returned.
' Usage example:
' DIM dws AS DWSTRING = DWStrClipMid("1234567890", 3, 4)
' ========================================================================================
PRIVATE FUNCTION DWStrClipMid (BYREF wszMainStr AS CONST WSTRING, BYVAL nStart AS LONG, BYVAL nCount AS LONG) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   IF (nCount <= 0) OR (nStart <= 0) THEN RETURN dws
   DIM nLen AS LONG = LEN(wszMainStr)
   dws = LEFT(wszMainStr, nStart - 1) + MID(wszMainStr, nStart + nCount)
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
'  Adds paired characters to the beginning and end of a string.
'  It is particularly useful for enclosing text with parenthesess, quotes, brackets, etc.
'  For example: DWStrWrap("Paul", "<", ">") results in <Paul>
'  If only one wrap character/string is specified then that character or string is used
'  for both sides.
'  For example: DWStrWrap("Paul", "'") results in 'Paul'
'  If no wrap character/string is specified then double quotes are used.
'  For example: DWStrWrap("Paul") results in "Paul"
' ========================================================================================
PRIVATE FUNCTION DWStrWrap OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszLeftChar AS CONST WSTRING, BYREF wszRightChar AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = wszLeftChar + wszMainStr & wszRightChar
   RETURN dws
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWStrWrap OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszChar AS CONST WSTRING = CHR(34)) AS DWSTRING
   DIM dws AS DWSTRING = wszChar + wszMainStr + wszChar
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' Removes paired characters to the beginning and end of a string.
' It is particularly useful for removing text with parenthesess, quotes, brackets, etc.
' For example: DWStrUnWrap("<Paul>", "<", ">") results in Paul
' If only one unwrap character/string is specified then that character or string is used for both sides.
' For example: DWStrUnWrap("'Paul'", "'") results in Paul
' If no wrap character/string is specified then double quotes are used.
' For example: DWStrUnWrap("""Paul""") results in Paul
' ========================================================================================
PRIVATE FUNCTION DWStrUnWrap OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszLeftChar AS CONST WSTRING, BYREF wszRightChar AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = LTRIM(wszMainStr, wszLeftChar)
   dws = RTRIM(dws, wszRightChar)
   RETURN dws
END FUNCTION
' ========================================================================================
' ========================================================================================
PRIVATE FUNCTION DWStrUnWrap OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszChar AS CONST WSTRING = CHR(34)) AS DWSTRING
   DIM dws AS DWSTRING = LTRIM(wszMainStr, wszChar)
   dws = RTRIM(**dws, wszChar)
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Deletes a specified number of characters from a string expression.
' Returns a string based on wszMainStr but with nCount characters deleted
' starting at position nStart. The first character in the string is position 1, etc.
' Usage example:
' DIM dws AS DWSTRING = DWStrDelete("1234567890", 4, 3)
' ========================================================================================
PRIVATE FUNCTION DWStrDelete (BYREF wszMainStr AS CONST WSTRING, BYVAL nStart AS LONG, BYVAL nCount AS LONG) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   DIM nLen AS LONG = LEN(wszMainStr)
   IF nLen = 0 OR nStart < 0 OR nCount <= 0 OR nStart > nLen THEN RETURN dws
   dws.DelChars nStart, nCount
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Inserts a string at a specified position within another string expression.
' Returns a string consisting of wszMainStr with the string wszInsertString inserted
' at nPosition. If nPosition is greater than the length of wszMainStr or <= zero then
' wszInsertString is appended to wszMainStr. The first character in the string is position 1, etc.
' DIM dws AS DWSTRING = DWStrInsert("1234567890", "--", 6)
' ========================================================================================
PRIVATE FUNCTION DWStrInsert (BYREF wszMainStr AS CONST WSTRING, BYREF wszInsertString AS WSTRING, BYVAL nPosition AS LONG) AS DWSTRING
   DIM dws AS DWSTRING = wszMainStr
   IF nPosition <= 0 THEN RETURN dws
   IF nPosition > LEN(wszMainStr) THEN
      dws += wszInsertString
   ELSEIF nPosition = 1 THEN
      dws = wszInsertString + MID(wszMainStr, 1)
   ELSE
      dws = MID(wszMainStr, 1, nPosition - 1) + wszInsertString + MID(wszMainStr, nPosition)
   END IF
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a string containing only the characters contained in a specified match string.
' All other characters are removed. If wszMatchStr is an empty string the function returns
' an empty string. This function is case-sensitive.
' Example: DIM dws AS DWSTRING = DWStrRetain("abacadabra","b")   ' -> "bb"
' ========================================================================================
PRIVATE FUNCTION DWStrRetain (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN dws
   DIM nLen AS LONG = LEN(wszMatchStr)
   DIM nPos AS LONG = 1
   DO
      nPos = INSTR(nPos, wszMainStr, wszMatchStr)
      IF nPos = 0 THEN EXIT DO
      dws += MID(wszMainStr, nPos, nLen)
      nPos += nLen
   LOOP
   RETURN dws
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DEStrRetain.
' Example: DIM dws AS DWSTRING = DWStrRetainI("abacadabra","B")   ' -> "bb"
' ========================================================================================
PRIVATE FUNCTION DWStrRetainI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   IF LEN(wszMainStr) = 0 OR LEN(wszMatchStr) = 0 THEN RETURN dws
   DIM dwsMainStr AS DWSTRING = UCASE(wszMainStr)
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   DIM nLen AS LONG = LEN(wszMatchStr)
   DIM nPos AS LONG = 1
   DO
      nPos = INSTR(nPos, **dwsMainStr, **dwsMatchStr)
      IF nPos = 0 THEN EXIT DO
      dws += MID(wszMainStr, nPos, nLen)
      nPos += nLen
   LOOP
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a string containing only the characters contained in a specified match string.
' All other characters are removed.
' If wszMatchStr is an empty string the function returns an empty string.
' wszMatchStr specifies a list of single characters to be searched for individually.
' A match on any one of which will cause that character to be removed from the result.
' This function is case-sensitive.
' Example: DWStrRetainAny("<p>1234567890<ak;lk;l>1234567890</p>", "<;/p>")
' ========================================================================================
PRIVATE FUNCTION DWStrRetainAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   DIM nLen AS LONG = LEN(wszMainStr)
   IF nLen = 0 OR LEN(wszMatchStr) = 0 THEN RETURN dws
   DIM nPos AS LONG
   FOR i AS LONG = 1 TO nLen
      nPos = INSTR(wszMatchStr, MID(wszMainStr, i, 1))
      IF nPos THEN dws += MID(wszMainStr, i, 1)
   NEXT
   RETURN dws
END FUNCTION
' ========================================================================================
' ========================================================================================
' * Case insensitive version of DWStrRetainAny.
' Example: DWStrRetainAnyI("<p>1234567890<ak;lk;l>1234567890</p>", "<;/P>")
' ========================================================================================
PRIVATE FUNCTION DWStrRetainAnyI (BYREF wszMainStr AS CONST WSTRING, BYREF wszMatchStr AS CONST WSTRING) AS DWSTRING
   DIM dws AS DWSTRING = ""
   DIM nLen AS LONG = LEN(wszMainStr)
   IF nLen = 0 OR LEN(wszMatchStr) = 0 THEN RETURN dws
   DIM dwsMainStr AS DWSTRING = UCASE(wszMainStr)
   DIM dwsMatchStr AS DWSTRING = UCASE(wszMatchStr)
   DIM nPos AS LONG
   FOR i AS LONG = 1 TO nLen
      nPos = INSTR(**dwsMatchStr, MID(**dwsMainStr, i, 1))
      IF nPos THEN dws += MID(wszMainStr, i, 1)
   NEXT
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Shrinks a string to use a consistent single character delimiter.
' The purpose of this function is to create a string with consecutive data items (words)
' separated by a consistent single character. This makes it very straightforward to parse
' the results as needed.
' If wszMask is not defined then all leading spaces and trailing spaces are removed entirely.
' All occurrences of two or more spaces are changed to a single space. Therefore, the new
' string returned consists of zero or more words, each separated by a single space character.
' If wszMask is specified, it defines one or more delimiter characters to shrink. All leading
' and trailing mask characters are removed entirely. All occurrences of one or more mask
' characters are replaced with the first character of wszMask The new string returned consists
' of zero or more words, each separated by the character found in the first position of wszMask.
' WhiteSpace is generally defined as the four common non-printing characters:
' Space, Tab, Carriage-Return, and Line-Feed. wszbMask = Chr(32,9,13,10)
' Example: DIM dws AS DWSTRING = DWStrShrink(",,, one , two     three, four,", " ,")
' ========================================================================================
PRIVATE FUNCTION DWStrShrink (BYREF wszMainStr AS CONST WSTRING, BYREF wszMask AS CONST WSTRING = " ") AS DWSTRING
   DIM dws AS DWSTRING = ""
   IF LEN(wszMainStr) = 0 OR LEN(wszMask) = 0 THEN RETURN dws
   ' // Eliminate all leading and trailing cbMask characters
   dws = TRIM(wszMainStr, ANY wszMask)
   ' // Eliminate all duplicate wszMask characters within the string
   DIM wszReplace AS WSTRING * 2 = MID(wszMask, 1, 1)
   DIM wszDuplicate AS WSTRING * 3
   DIM nMaskLen AS LONG = LEN(wszMask)
   DIM nPos AS LONG
   FOR i AS LONG = 1 TO nMaskLen
      wszDuplicate = MID(wszMask, i, 1) + MID(wszMask, i, 1)   ' usually double spaces
      nPos = 1
      DO
         nPos = INSTR(**dws, wszDuplicate)
         IF nPos = 0 THEN EXIT DO
         dws = MID(**dws, 1, nPos - 1) + wszReplace + MID(**dws, nPos + LEN(wszDuplicate))
      LOOP
   NEXT
   ' // Replace all single characters in the mask with the first character of the mask.
   nPos = 1
   DO
      nPos = INSTR(nPos, **dws, ANY wszMask)
      IF nPos = 0 THEN EXIT DO
      ' Only do the replace if the character at the position found is
      ' different than the character we need to replace it with. This saves
      ' us from having to do an unneeded string concatenation.
      IF MID(**dws, nPos, 1) <> wszReplace  THEN
         dws = MID(**dws, 1, nPos - 1) + wszReplace + MID(**dws, nPos + 1)
      END IF
      nPos += 1
   LOOP
   ' Finally, do a pass to ensure that there are no duplicates of the
   ' first mask character because of the replacements in the step above.
   wszDuplicate = MID(wszMask, 1, 1) + MID(wszMask, 1, 1)
   nPos = 1
   DO
      nPos = INSTR(**dws, wszDuplicate)
      IF nPos = 0 THEN EXIT DO
      dws = MID(**dws, 1, nPos - 1) + wszReplace + MID(**dws, nPos + LEN(wszDuplicate))
   LOOP
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns the count of delimited fields from a string expression.
' If wszMainStr is empty (a null string) or contains no delimiter character(s), the string
' is considered to contain exactly one sub-field. In this case, DWStrParseCount returns the value 1.
' Delimiter contains a string (one or more characters) that must be fully matched.
' Delimiters are case-sensitive.
' Example: DIM nCount AS LONG = DWStrParseCount("one,two,three", ",")
' ========================================================================================
PRIVATE FUNCTION DWStrParseCount (BYREF wszMainStr AS CONST WSTRING, BYREF wszDelimiter AS CONST WSTRING = ",") AS LONG
   DIM nCount AS LONG = 1
   DIM nPos AS LONG = 1
   DO
      nPos = INSTR(nPos, wszMainStr, wszDelimiter)
      IF nPos = 0 THEN EXIT DO
      nCount += 1
      nPos += LEN(wszDelimiter)
   LOOP
   RETURN nCount
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Return the count of delimited fields from a string expression.
' If wszMainStr is empty (a null string) or contains no delimiter character(s), the string
' is considered to contain exactly one sub-field. In this case, DWStrParseCountAny returns the value 1.
' Delimiter contains a set of characters (one or more), any of which may act as a delimiter character.
' Delimiters are case-sensitive.
' Example: DIM nCount AS LONG = DWStrParseCountAny("1;2,3", ",;")
' ========================================================================================
PRIVATE FUNCTION DWStrParseCountAny (BYREF wszMainStr AS CONST WSTRING, BYREF wszDelimiter AS CONST WSTRING = ",") AS LONG
   DIM nCount AS LONG = 1
   FOR i AS LONG = 1 TO LEN(wszDelimiter)
      nCount += DWStrParseCount(wszMainStr, MID(wszDelimiter, i, 1))
   NEXT
   RETURN nCount
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns the nPosition-th substring in a string wszMainStr with separations wszDelimiter
' (one or more characters), beginning with nPosition = 1.
' ========================================================================================
PRIVATE FUNCTION DWStrParse OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYREF wszDelimiter AS CONST WSTRING, BYVAL nPosition AS LONG, BYVAL bIsAny AS BOOLEAN, BYVAL nLenDelimiter AS LONG) AS DWSTRING
   DIM nCount AS LONG, nStart AS LONG
   nPosition = ABS(nPosition)
   DIM nPos AS LONG = 1
   DIM fReverse AS BOOLEAN = IIF(nPosition < 0, TRUE, FALSE)
   DIM dws AS DWSTRING = ""
   IF fReverse THEN
      ' Reverse search
      ' Get the start of the token (j) by searching in reverse
      IF bIsAny THEN
         nPos = InstrRev(wszMainStr, ANY wszDelimiter)
      ELSE
         nPos = InstrRev(wszMainStr, wszDelimiter)
      END IF
      DO WHILE nPos > 0        ' if not found loop will be skipped
         nStart = nPos + nLenDelimiter
         nCount += 1
         nPos = nPos - nLenDelimiter
         IF nCount = nPosition THEN EXIT DO
         IF bIsAny THEN
            nPos = InStrRev(wszMainStr, ANY wszDelimiter, nPos)
         ELSE
             nPos = InStrRev(wszMainStr, wszDelimiter, nPos)
         END IF
      LOOP
      IF nPos = 0 THEN nStart = 1
      ' Now continue forward to get the end of the token
      IF bIsAny THEN
         nPos = INSTR(nStart, wszMainStr, ANY wszDelimiter)
      ELSE
         nPos = INSTR(nStart, wszMainStr, wszDelimiter)
      END IF
      IF nPos > 0 OR nCount = nPosition THEN
         IF nPos = 0 THEN
            dws = MID(wszMainStr, nStart)
         ELSE
            dws = MID(wszMainStr, nStart, nPos - nStart)
         END IF
      END IF
   ELSE
      ' Forward search
      DO
         nStart = nPos
         IF bIsAny THEN
            nPos = INSTR(nPos, wszMainStr, ANY wszDelimiter)
         ELSE
            nPos = INSTR(nPos, wszMainStr, wszDelimiter)
         END IF
         IF nPos THEN
            nCount += 1
            nPos += nLenDelimiter
         END IF
      LOOP UNTIL nPos = 0 OR nCount = nPosition
      IF nPos > 0 OR nCount = nPosition - 1 THEN
         IF nPos = 0 THEN
            dws = MID(wszMainStr, nStart)
         ELSE
            dws = MID(wszMainStr, nStart, nPos - nLenDelimiter - nStart)
         END IF
      END IF
   END IF
   RETURN dws
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Returns a delimited field from a string expression.
' wszDelimiter contains a string of one or more characters that must be fully matched to be successful.
' If nPosition evaluates to zero or is outside of the actual field count, an empty string is returned.
' If nPosition is negative then fields are searched from the right to left of the wszMainStr
' Delimiters are case-sensitive.
' Example: DIM dws AS DWSTRING = DWStrParse("one,two,three", 2)
' Example: DIM dws AS DWSTRING = DWStrParse("one;two,three", 1, ";")
' ========================================================================================
PRIVATE FUNCTION DWStrParse OVERLOAD (BYREF wszMainStr AS CONST WSTRING, BYVAL nPosition AS LONG = 1, BYREF wszDelimiter AS CONST WSTRING = ",") AS DWSTRING
   ' The parse must match the entire deliminter string
   RETURN DWStrParse(wszMainStr, wszDelimiter, nPosition, FALSE, Len(wszDelimiter))
END FUNCTION
' ========================================================================================

' ========================================================================================
' * Return a delimited field from a string expression.
' Delimiter contains a set of characters (one or more), any of which may act as a delimiter character.
' If nPosition evaluates to zero or is outside of the actual field count, an empty string is returned.
' If nPosition is negative then fields are searched from the right to left of the MainString.
' Delimiters are case-sensitive.
' Example: DIM dws AS DWSTRING = DWStrParseAny("1;2,3", 2, ",;")
' ========================================================================================
PRIVATE FUNCTION DWStrParseAny (BYREF wszMainStr AS CONST WSTRING, BYVAL nPosition AS LONG = 1, BYREF wszDelimiter AS CONST WSTRING = ",") AS DWSTRING
   ' The parse must match one character (len = 1) in the delimiter string
   RETURN DWStrParse(wszMainStr, wszDelimiter, nPosition, TRUE, 1)
END FUNCTION
' ========================================================================================
