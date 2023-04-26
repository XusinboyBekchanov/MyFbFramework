' ########################################################################################
' Microsoft Windows
' File: CInt96.inc
' Contents: 96-bit (12 bytes) integer data type.
' Compiler: FreeBasic 32 & 64-bit
' (C) 2018-2020 by José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "windows.bi"
#include once "win/ole2.bi"

NAMESPACE Afx

' ========================================================================================
' CInt96 class
' ========================================================================================
TYPE CInt96

Public:
   m_int96 AS DECIMAL   ' // The underlying DECIMAL structure

Public:
   DECLARE CONSTRUCTOR
   DECLARE CONSTRUCTOR (BYREF cSrc AS CInt96)
   DECLARE CONSTRUCTOR (BYREF decSrc AS DECIMAL)
   DECLARE CONSTRUCTOR (BYVAL nInteger AS LONGINT)
   DECLARE CONSTRUCTOR (BYVAL nUInteger AS ULONGINT)
   DECLARE CONSTRUCTOR (BYREF wszSrc AS WSTRING)
   DECLARE DESTRUCTOR
   DECLARE OPERATOR LET (BYREF cSrc AS CInt96)
   DECLARE OPERATOR += (BYREF int96 AS CInt96)
   DECLARE OPERATOR -= (BYREF int96 AS CInt96)
   DECLARE OPERATOR *= (BYREF int96 AS CInt96)
   DECLARE OPERATOR /= (BYREF cOperand AS CInt96)
   DECLARE OPERATOR CAST () AS CURRENCY
   DECLARE OPERATOR CAST () AS VARIANT
   DECLARE OPERATOR CAST () AS STRING
   DECLARE FUNCTION Abs_ () AS CInt96
   DECLARE FUNCTION ToVar () AS VARIANT
   DECLARE FUNCTION Sign () AS UBYTE
   DECLARE FUNCTION IsSigned () AS BOOLEAN
   DECLARE FUNCTION IsUnsigned () AS BOOLEAN

END TYPE
' ========================================================================================

' ========================================================================================
' CInt96 constructors
' ========================================================================================
PRIVATE CONSTRUCTOR CInt96
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CInt96 (BYREF cSrc AS CInt96)
   m_int96 = cSrc.m_int96
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CInt96 (BYREF decSrc AS DECIMAL)
   IF decSrc.Scale THEN SetLastError(VarDecInt(@decSrc, @m_int96)) ELSE m_int96 = decSrc
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Make sure that nValue is greater that -9223372036854775808 or it will be truncated.
' For values smaller than -9223372036854775808 use a string.
PRIVATE CONSTRUCTOR CInt96 (BYVAL nInteger AS LONGINT)
   SetLastError(VarDecFromI8(nInteger, @m_int96))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Make sure that nValue does not exceed 18446744073709551615 or it will be truncated.
' For values greater than 18446744073709551615 use a string.
PRIVATE CONSTRUCTOR CInt96 (BYVAL nUInteger AS ULONGINT)
   SetLastError(VarDecFromUI8(nuInteger, @m_int96))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CInt96 (BYREF wszSrc AS WSTRING)
   IF INSTR(wszSrc, ".") THEN SetLastError(E_INVALIDARG) : EXIT CONSTRUCTOR
   SetLastError(VarDecFromStr(@wszSrc, 0, 0, @m_int96))
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' CInt96 destructor
' ========================================================================================
PRIVATE DESTRUCTOR CInt96
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Assignment operator
' ========================================================================================
PRIVATE OPERATOR CInt96.LET (BYREF cSrc AS CInt96)
   m_int96 = cSrc.m_int96
END OPERATOR
' ========================================================================================

' ========================================================================================
' Comparison operators.
' ========================================================================================
PRIVATE OPERATOR = (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   RETURN (VarDecCmp(@int961.m_int96, @int962.m_int96) = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <> (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   RETURN (VarDecCmp(@int961.m_int96, @int962.m_int96) <> VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR < (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   RETURN (VarDecCmp(@int961.m_int96, @int962.m_int96) = VARCMP_LT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR > (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   RETURN (VarDecCmp(@int961.m_int96, @int962.m_int96) = VARCMP_GT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <= (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@int961.m_int96, @int962.m_int96)
   RETURN (hr = VARCMP_LT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR >= (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@int961.m_int96, @int962.m_int96)
   RETURN (hr = VARCMP_GT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Math operators.
' ========================================================================================
PRIVATE OPERATOR + (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS CInt96
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecAdd(@int961.m_int96, @int962.m_int96, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN int961
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96.+= (BYREF int96Src AS CInt96)
    SetLastError(VarDecAdd(@m_int96, @int96Src.m_int96, @m_int96))
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR - (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS CInt96
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecSub(@int961.m_int96, @int962.m_int96, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN int961
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96.-= (BYREF int96Src AS CInt96)
   SetLastError(VarDecSub(@m_int96, @int96Src.m_int96, @m_int96))
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR - (BYREF int96Src AS CInt96) AS CInt96
   DIM dec AS DECIMAL
   SetLastError(VarDecNeg(@int96Src.m_int96, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR * (BYREF int961 AS CInt96, BYREF int962 AS CInt96) AS CInt96
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecMul(@int961.m_int96, @int962.m_int96, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN int961
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96.*= (BYREF int96Src AS CInt96)
   SetLasterror(VarDecMul(@m_int96, @int96Src.m_int96, @m_int96))
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR / (BYREF int96Src AS CInt96, BYREF cOperand AS CInt96) AS CInt96
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecDiv(@int96Src.m_int96, @cOperand.m_int96, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN int96Src
   IF dec.Scale THEN hr = VarDecInt(@dec, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN int96Src
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96./= (BYREF cOperand AS CInt96)
   DIM hr AS LONG = VarDecDiv(@m_int96, @cOperand.m_int96, @m_int96)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT OPERATOR
   IF m_int96.Scale THEN SetLastError(VarDecInt(@m_int96, @m_int96))
END OPERATOR
' ========================================================================================

' ========================================================================================
' Cast operators.
' ========================================================================================
PRIVATE OPERATOR CInt96.CAST () AS CURRENCY
   DIM cy AS CURRENCY
   SetLastError(VarCyFromDec(@m_int96, @cy))
   OPERATOR = cy
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96.CAST () AS VARIANT
   DIM v AS VARIANT
   v.vt = VT_DECIMAL
   v.decVal = m_int96
   RETURN v
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CInt96.CAST () AS STRING
   DIM bstrOut AS BSTR
   VarBstrFromDec(@m_int96, 0, 0, @bstrOut)
   DIM s AS STRING = *cast(WSTRING PTR, bstrOut)
   SysFreeString(bstrOut)
   OPERATOR = s
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the address of the underlying decimal value.
' ========================================================================================
PRIVATE OPERATOR * (BYREF int96 AS CInt96) AS DECIMAL PTR
   OPERATOR = VARPTR(int96.m_int96)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Retrieves the absolute value of a CInt96 data type.
' ========================================================================================
PRIVATE FUNCTION CInt96.Abs_ () AS CInt96
   DIM dec AS DECIMAL
   SetLastError(VarDecAbs(@m_int96, @dec))
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts the currency to a VT_CY variant.
' To allow to assign the decimal to a CVAR variable
' DIM dec AS CInt96 = 12345.1234
' DIM cv AS CVAR = dec.ToVar
' ========================================================================================
PRIVATE FUNCTION CInt96.ToVar () AS VARIANT
   DIM v AS VARIANT
   v.vt = VT_DECIMAL
   v.decVal = m_int96
   RETURN v
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the sign of this decimal number.
' Returns 0 if it is not signed of &h80 (128) if it is signed.
' ========================================================================================
PRIVATE FUNCTION CInt96.Sign () AS UBYTE
   RETURN m_int96.sign
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is signed or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CInt96.IsSigned () AS BOOLEAN
   IF m_int96.sign THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is unsigned or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CInt96.IsUnsigned () AS BOOLEAN
   IF m_int96.sign = 0 THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================

END NAMESPACE
