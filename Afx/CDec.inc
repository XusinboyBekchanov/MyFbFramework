' ########################################################################################
' Microsoft Windows
' File: CDec.inc
' Contents: Decimal data type
' Compiler: FreeBasic 32 & 64-bit
' (C) 2017-2020 by José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "windows.bi"
#include once "win/ole2.bi"

NAMESPACE Afx

' ========================================================================================
' CDec class - Decimal data type
' ========================================================================================
TYPE CDec

Public:
   m_lcid AS LCID     ' // The locale id
   m_dec AS DECIMAL   ' // The underlying DECIMAL structure

Public:
   DECLARE CONSTRUCTOR (BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYREF cSrc AS CDec, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYREF decSrc AS DECIMAL, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL cySrc AS CURRENCY, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL bSrc AS BYTE, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL ubSrc AS UBYTE, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL sSrc AS SHORT, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL usSrc AS USHORT, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL lSrc AS LONG, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL ulSrc AS ULONG, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL nInteger AS LONGINT, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL nUInteger AS ULONGINT, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL fSrc AS SINGLE, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL dSrc AS DOUBLE, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYREF wszSrc AS WSTRING, BYVAL lcid AS LCID = 0, BYVAL dwFlags AS ULONG = 0)
   DECLARE CONSTRUCTOR (BYVAL pDispSrc AS IDispatch PTR, BYVAL lcid AS LCID = 0)
   DECLARE CONSTRUCTOR (BYVAL varSrc AS VARIANT, BYVAL lcid AS LCID = 0)
   DECLARE DESTRUCTOR
   DECLARE OPERATOR LET (BYREF cSrc AS CDec)
   DECLARE OPERATOR += (BYREF dec AS CDec)
   DECLARE OPERATOR -= (BYREF dec AS CDec)
   DECLARE OPERATOR *= (BYREF dec AS CDec)
   DECLARE OPERATOR /= (BYREF cOperand AS CDec)
   DECLARE OPERATOR CAST () AS CURRENCY
   DECLARE OPERATOR CAST () AS VARIANT
   DECLARE OPERATOR CAST () AS STRING
   DECLARE FUNCTION DecAbs () AS CDec
   DECLARE FUNCTION DecFix () AS CDec
   DECLARE FUNCTION DecInt () AS CDec
   DECLARE FUNCTION DecRound (BYVAL nDecimals AS LONG) AS CDec
   DECLARE FUNCTION ToVar () AS VARIANT
   DECLARE FUNCTION Scale () AS UBYTE
   DECLARE FUNCTION Sign () AS UBYTE
   DECLARE FUNCTION IsSigned () AS BOOLEAN
   DECLARE FUNCTION IsUnsigned () AS BOOLEAN

END TYPE
' ========================================================================================

' ========================================================================================
' CDec constructors
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL lcid AS LCID = 0)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYREF cSrc AS CDec, BYVAL lcid AS LCID = 0)
   m_dec = cSrc.m_dec
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYREF decSrc AS DECIMAL, BYVAL lcid AS LCID = 0)
   m_dec = decSrc
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL cySrc AS CURRENCY, BYVAL lcid AS LCID = 0)
   VarDecFromCy(cySrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL bSrc AS BYTE, BYVAL lcid AS LCID = 0)
   VarDecFromI1(bSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL ubSrc AS UBYTE, BYVAL lcid AS LCID = 0)
   VarDecFromUI1(ubSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL sSrc AS SHORT, BYVAL lcid AS LCID = 0)
   VarDecFromI2(sSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL usSrc AS USHORT, BYVAL lcid AS LCID = 0)
   VarDecFromUI2(usSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL lSrc AS LONG, BYVAL lcid AS LCID = 0)
   VarDecFromI4(lSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL ulSrc AS ULONG, BYVAL lcid AS LCID = 0)
   VarDecFromUI4(ulSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL nInteger AS LONGINT, BYVAL lcid AS LCID = 0)
   VarDecFromI8(nInteger, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL nUInteger AS ULONGINT, BYVAL lcid AS LCID = 0)
   VarDecFromUI8(nuInteger, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL fSrc AS SINGLE, BYVAL lcid AS LCID = 0)
   VarDecFromR4(fSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL dSrc AS DOUBLE, BYVAL lcid AS LCID = 0)
   VarDecFromR8(dSrc, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYREF wszSrc AS WSTRING, BYVAL lcid AS LCID = 0, BYVAL dwFlags AS ULONG = 0)
   VarDecFromStr(@wszSrc, lcid, dwFlags, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL pDispSrc AS IDispatch PTR, BYVAL lcid AS LCID = 0)
   VarDecFromDisp(pDispSrc, lcid, @m_dec)
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CDec (BYVAL varSrc AS VARIANT, BYVAL lcid AS LCID = 0)
   DIM v AS VARIANT
   DIM hr AS HRESULT = VariantChangeType(@v, @varSrc, 0, VT_DECIMAL)
   IF FAILED(hr) THEN EXIT CONSTRUCTOR
   m_dec = v.decVal
   m_lcid = lcid
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' CDec destructor
' ========================================================================================
PRIVATE DESTRUCTOR CDec
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Assignment operators
' ========================================================================================
PRIVATE OPERATOR CDec.LET (BYREF cSrc AS CDec)
   m_dec = cSrc.m_dec
END OPERATOR
' ========================================================================================

' ========================================================================================
' Comparison operators.
' ========================================================================================
PRIVATE OPERATOR = (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   RETURN (VarDecCmp(@dec1.m_dec, @dec2.m_dec) = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <> (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   RETURN (VarDecCmp(@dec1.m_dec, @dec2.m_dec) <> VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR < (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   RETURN (VarDecCmp(@dec1.m_dec, @dec2.m_dec) = VARCMP_LT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR > (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   RETURN (VarDecCmp(@dec1.m_dec, @dec2.m_dec) = VARCMP_GT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <= (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@dec1.m_dec, @dec2.m_dec)
   RETURN (hr = VARCMP_LT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR >= (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@dec1.m_dec, @dec2.m_dec)
   RETURN (hr = VARCMP_GT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Math operators.
' ========================================================================================
PRIVATE OPERATOR + (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS CDec
   DIM dec AS DECIMAL
   VarDecAdd(@dec1.m_dec, @dec2.m_dec, @dec)
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec.+= (BYREF decSrc AS CDec)
   VarDecAdd(@m_dec, @decSrc.m_dec, @m_dec)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR - (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS CDec
   DIM dec AS DECIMAL
   VarDecSub(@dec1.m_dec, @dec2.m_dec, @dec)
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec.-= (BYREF decSrc AS CDec)
   VarDecSub(@m_dec, @decSrc.m_dec, @m_dec)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR - (BYREF decSrc AS CDec) AS CDec
   DIM dec AS DECIMAL
   VarDecNeg(@decSrc.m_dec, @dec)
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR * (BYREF dec1 AS CDec, BYREF dec2 AS CDec) AS CDec
   DIM dec AS DECIMAL
   VarDecMul(@dec1.m_dec, @dec2.m_dec, @dec)
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec.*= (BYREF decSrc AS CDec)
   VarDecMul(@m_dec, @decSrc.m_dec, @m_dec)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR / (BYREF decSrc AS CDec, BYREF cOperand AS CDec) AS CDec
   DIM dec AS DECIMAL
   VarDecDiv(@decSrc.m_dec, @cOperand.m_dec, @dec)
   RETURN dec
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec./= (BYREF cOperand AS CDec)
   VarDecDiv(@m_dec, @cOperand.m_dec, @m_dec)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Cast operators.
' ========================================================================================
PRIVATE OPERATOR CDec.CAST () AS CURRENCY
   DIM cy AS CURRENCY
   VarCyFromDec(@m_dec, @cy)
   OPERATOR = cy
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec.CAST () AS VARIANT
   DIM v AS VARIANT
   v.decVal = m_dec
   v.vt = VT_DECIMAL
   RETURN v
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CDec.CAST () AS STRING
   DIM bstrOut AS BSTR
   VarBstrFromDec(@m_dec, m_lcid, 0, @bstrOut)
   DIM s AS STRING = *cast(WSTRING PTR, bstrOut)
   SysFreeString(bstrOut)
   OPERATOR = s
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the address of the underlying decimal value.
' ========================================================================================
PRIVATE OPERATOR * (BYREF dec AS CDec) AS DECIMAL PTR
   OPERATOR = VARPTR(dec.m_dec)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Retrieves the absolute value of a decimal data type.
' ========================================================================================
PRIVATE FUNCTION CDec.DecAbs () AS CDec
   DIM dec AS DECIMAL
   VarDecAbs(@m_dec, @dec)
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retrieves the integer portion of a decimal data type.
' If the value is negative, then the first negative integer greater than or equal to the
' value is returned.
' ========================================================================================
PRIVATE FUNCTION CDec.DecFix () AS CDec
   DIM dec AS DECIMAL
   VarDecFix(@m_dec, @dec)
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retrieves the integer portion of a decimal data type.
' If the value is negative, then the first negative integer less than or equal to the
' value is returned.
' ========================================================================================
PRIVATE FUNCTION CDec.DecInt () AS CDec
   DIM dec AS DECIMAL
   VarDecInt(@m_dec, @dec)
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Rounds the decimal data type to a specified number of decimal places.
' ========================================================================================
PRIVATE FUNCTION CDec.DecRound (BYVAL nDecimals AS LONG) AS CDec
   DIM dec AS DECIMAL
   VarDecRound(@m_dec, nDecimals, @dec)
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts this decimal number to a VT_CY variant.
' To allow to assign the decimal to a CVAR variable
' DIM dec AS CDec = 12345.1234
' DIM cv AS CVAR = dec.ToVar
' ========================================================================================
PRIVATE FUNCTION CDec.ToVar () AS VARIANT
   DIM v AS VARIANT
   v.decVal = m_dec
   v.vt = VT_DECIMAL
   RETURN v
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the scale of this decimal number.
' ========================================================================================
PRIVATE FUNCTION CDec.Scale () AS UBYTE
   RETURN m_dec.scale
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the sign of this decimal number.
' Returns 0 if it is not signed of &h80 (128) if it is signed.
' ========================================================================================
PRIVATE FUNCTION CDec.Sign () AS UBYTE
   RETURN m_dec.sign
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is signed or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CDec.IsSigned () AS BOOLEAN
   IF m_dec.sign THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is unsigned or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CDec.IsUnsigned () AS BOOLEAN
   IF m_dec.sign = 0 THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================

END NAMESPACE
