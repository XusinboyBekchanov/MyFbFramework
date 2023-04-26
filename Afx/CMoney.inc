' ########################################################################################
' Microsoft Windows
' File: CMoney.inc
' Contents: Money data type.
' Compiler: FreeBasic 32 & 64-bit
' Written in 2019 by José Roca. Freeware. Use at your own risk.
' Notes: Because it uses a DECIMAL structure as the underlying data type, the largest
' possible value is +/-792,281,625,142,643,375,935,439,503.35 when using two decimal places.
' However, the formatting functions, FormatCurrency and FormatNumber can only return a
' maximum value of +/-922,337,203,685,477.58 because they use a currency data type. For
' greater values, you can format the returned string by yourself.
' The number of decimal places defaults to 2, but you can choose between 0-9 by defining
' them before includind CMoney.inc, e.g. #define AFX_CMONEY_DECIMAL_PLACES 4. If you choose
' more than 9 decimal places, the output will be truncated.
' The locale identifier defaults to 1033 (US), for consistency with FreeBasic numeric
' data types, but you can change it by defining it before including CMoney.inc, e.g.
' #define AFX_CMONEY_LCID 1031 (Spain). The locale identifier (LCID) instructs the methods
' of this class about input and output string should be treated. For example, if you choose
' the Spanish LCID, the formated string input and output will us a comma, instead of a point,
' as the dcimañ separator, and a point, instead of a comma, as the thousands separator.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "windows.bi"
#include once "win/ole2.bi"

NAMESPACE Afx

#if not defined(AFX_CMONEY_LCID)
   #define AFX_CMONEY_LCID 1033          ' // The locale identifier (1033 = US LCID)
#endif
#if not defined(AFX_CMONEY_DECIMAL_PLACES)
   #define AFX_CMONEY_DECIMAL_PLACES 2   ' // The number of decimal places (0-9)
#endif

' ========================================================================================
' CMoney class
' ========================================================================================
TYPE CMoney

Public:
   m_money AS DECIMAL          ' // The underlying DECIMAL structure

Public:
   DECLARE CONSTRUCTOR
   DECLARE CONSTRUCTOR (BYREF cSrc AS CMoney)
   DECLARE CONSTRUCTOR (BYVAL nInteger AS LONGINT)
   DECLARE CONSTRUCTOR (BYVAL nUInteger AS ULONGINT)
   DECLARE CONSTRUCTOR (BYREF decSrc AS DECIMAL)
   DECLARE CONSTRUCTOR (BYVAL cy AS CURRENCY)
   DECLARE CONSTRUCTOR (BYVAL nValue AS DOUBLE)
   DECLARE CONSTRUCTOR (BYREF wszSrc AS WSTRING)
   DECLARE DESTRUCTOR
   DECLARE OPERATOR LET (BYREF cSrc AS CMoney)
   DECLARE OPERATOR += (BYREF money AS CMoney)
   DECLARE OPERATOR -= (BYREF money AS CMoney)
   DECLARE OPERATOR *= (BYREF money AS CMoney)
   DECLARE OPERATOR /= (BYREF cOperand AS CMoney)
   DECLARE OPERATOR CAST () AS DOUBLE
   DECLARE OPERATOR CAST () AS CURRENCY
   DECLARE OPERATOR CAST () AS DECIMAL
   DECLARE OPERATOR CAST () AS VARIANT
   DECLARE OPERATOR CAST () AS STRING
   DECLARE FUNCTION Abs_ () AS CMoney
   DECLARE FUNCTION ToVar () AS VARIANT
   DECLARE FUNCTION ToCyVar () AS VARIANT
   DECLARE FUNCTION LocaleId () AS LCID
   DECLARE FUNCTION Sign () AS UBYTE
   DECLARE FUNCTION IsSigned () AS BOOLEAN
   DECLARE FUNCTION IsUnsigned () AS BOOLEAN
   DECLARE FUNCTION FormatCurrency (BYVAL iNumDig AS LONG = -1, BYVAL iIncLead AS LONG = -2, _
           BYVAL iUseParens AS LONG = -2, BYVAL iGroup AS LONG = -2, BYVAL dwFlags AS DWORD = 0) AS STRING
   DECLARE FUNCTION FormatNumber (BYVAL iNumDig AS LONG = -1, BYVAL iIncLead AS LONG = -2, _
           BYVAL iUseParens AS LONG = -2, BYVAL iGroup AS LONG = -2, BYVAL dwFlags AS DWORD = 0) AS STRING

END TYPE
' ========================================================================================

' ========================================================================================
' CMoney constructors
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYREF cSrc AS CMoney)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   m_money = cSrc.m_money
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYVAL nInteger AS LONGINT)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   SetLastError(VarDecFromI8(nInteger, @m_money))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYVAL nUInteger AS ULONGINT)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   SetLastError(VarDecFromUI8(nuInteger, @m_money))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYREF decSrc AS DECIMAL)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   m_money = decSrc   
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYVAL cy AS CURRENCY)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   DIM hr AS LONG = VarDecFromCy(cy, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT CONSTRUCTOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYVAL nValue AS DOUBLE)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   DIM hr AS LONG = VarDecFromR8(nValue, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT CONSTRUCTOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
PRIVATE CONSTRUCTOR CMoney (BYREF wszSrc AS WSTRING)
   m_money.scale = AFX_CMONEY_DECIMAL_PLACES
   SetLastError(VarDecFromStr(@wszSrc, AFX_CMONEY_LCID, 0, @m_money))
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' CMoney destructor
' ========================================================================================
PRIVATE DESTRUCTOR CMoney
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Assignment operator
' ========================================================================================
PRIVATE OPERATOR CMoney.LET (BYREF cSrc AS CMoney)
   m_money = cSrc.m_money
END OPERATOR
' ========================================================================================

' ========================================================================================
' Comparison operators.
' ========================================================================================
PRIVATE OPERATOR = (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   RETURN (VarDecCmp(@money1.m_money, @money2.m_money) = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <> (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   RETURN (VarDecCmp(@money1.m_money, @money2.m_money) <> VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR < (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   RETURN (VarDecCmp(@money1.m_money, @money2.m_money) = VARCMP_LT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR > (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   RETURN (VarDecCmp(@money1.m_money, @money2.m_money) = VARCMP_GT)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <= (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@money1.m_money, @money2.m_money)
   RETURN (hr = VARCMP_LT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR >= (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS BOOLEAN
   DIM hr AS HRESULT = VarDecCmp(@money1.m_money, @money2.m_money)
   RETURN (hr = VARCMP_GT) OR (hr = VARCMP_EQ)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Math operators.
' ========================================================================================
PRIVATE OPERATOR + (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS CMoney
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecAdd(@money1.m_money, @money2.m_money, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN money1
   IF dec.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@dec, AFX_CMONEY_DECIMAL_PLACES, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR CMoney.+= (BYREF moneySrc AS CMoney)
   DIM hr AS LONG = VarDecAdd(@m_money, @moneySrc.m_money, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT OPERATOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR - (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS CMoney
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecSub(@money1.m_money, @money2.m_money, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN money1
   IF dec.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@dec, AFX_CMONEY_DECIMAL_PLACES, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR CMoney.-= (BYREF moneySrc AS CMoney)
   DIM hr AS LONG = VarDecSub(@m_money, @moneySrc.m_money, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT OPERATOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR - (BYREF moneySrc AS CMoney) AS CMoney
   DIM dec AS DECIMAL
   SetLastError(VarDecNeg(@moneySrc.m_money, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR * (BYREF money1 AS CMoney, BYREF money2 AS CMoney) AS CMoney
   DIM dec AS DECIMAL
   dec.scale = AFX_CMONEY_DECIMAL_PLACES
   DIM hr AS LONG = VarDecMul(@money1.m_money, @money2.m_money, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN money1
   IF dec.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@dec, AFX_CMONEY_DECIMAL_PLACES, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR CMoney.*= (BYREF moneySrc AS CMoney)
   DIM hr AS LONG = VarDecMul(@m_money, @moneySrc.m_money, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT OPERATOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR / (BYREF moneySrc AS CMoney, BYREF cOperand AS CMoney) AS CMoney
   DIM dec AS DECIMAL
   DIM hr AS LONG = VarDecDiv(@moneySrc.m_money, @cOperand.m_money, @dec)
   IF hr <> S_OK THEN SetLastError(hr) : RETURN moneySrc
   IF dec.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@dec, AFX_CMONEY_DECIMAL_PLACES, @dec))
   RETURN dec
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR CMoney./= (BYREF cOperand AS CMoney)
   DIM hr AS LONG = VarDecDiv(@m_money, @cOperand.m_money, @m_money)
   IF hr <> S_OK THEN SetLastError(hr) : EXIT OPERATOR
   IF m_money.scale <> AFX_CMONEY_DECIMAL_PLACES THEN SetLastError(VarDecRound(@m_money, AFX_CMONEY_DECIMAL_PLACES, @m_money))
END OPERATOR
' ========================================================================================

' ========================================================================================
PRIVATE OPERATOR CMoney.CAST () AS DOUBLE
   DIM nValue AS DOUBLE
   SetLastError(VarR8FromDec(@m_money, @nValue))
   OPERATOR = nValue
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CMoney.CAST () AS CURRENCY
   DIM cy AS CURRENCY
   SetLastError(VarCyFromDec(@m_money, @cy))
   OPERATOR = cy
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CMoney.CAST () AS DECIMAL
   RETURN m_money
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CMoney.CAST () AS VARIANT
   DIM v AS VARIANT
   v.vt = VT_DECIMAL
   v.decVal = m_money
   RETURN v
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR CMoney.CAST () AS STRING
   DIM bstrOut AS BSTR
   VarBstrFromDec(@m_money, AFX_CMONEY_LCID, 0, @bstrOut)
   DIM s AS STRING = *cast(WSTRING PTR, bstrOut)
   SysFreeString(bstrOut)
   OPERATOR = s
END OPERATOR
' ========================================================================================

' ========================================================================================
' Returns the address of the underlying decimal value.
' ========================================================================================
PRIVATE OPERATOR * (BYREF money AS CMoney) AS DECIMAL PTR
   OPERATOR = VARPTR(money.m_money)
END OPERATOR
' ========================================================================================

' ========================================================================================
' Retrieves the absolute value of a CMoney data type.
' ========================================================================================
PRIVATE FUNCTION CMoney.Abs_ () AS CMoney
   DIM dec AS DECIMAL
   SetLastError(VarDecAbs(@m_money, @dec))
   RETURN dec
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the LCID (locale identifier) used for string conversions
' Default: 1033 (US).
' ========================================================================================
PRIVATE FUNCTION CMoney.LocaleId () AS LCID
   RETURN AFX_CMONEY_LCID
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the sign of this decimal number.
' Returns 0 if it is not signed of &h80 (128) if it is signed.
' ========================================================================================
PRIVATE FUNCTION CMoney.Sign () AS UBYTE
   RETURN m_money.sign
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is signed or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CMoney.IsSigned () AS BOOLEAN
   IF m_money.sign THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns true if this number is unsigned or false otherwise.
' ========================================================================================
PRIVATE FUNCTION CMoney.IsUnsigned () AS BOOLEAN
   IF m_money.sign = 0 THEN RETURN TRUE ELSE RETURN FALSE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts the money data type to a VT_DECIMAL variant.
' To allow to assign the decimal to a CVAR variable
' DIM money AS CMoney = 12345.1234
' DIM cv AS CVAR = money.ToVar
' ========================================================================================
PRIVATE FUNCTION CMoney.ToVar () AS VARIANT
   DIM v AS VARIANT
   v.vt = VT_DECIMAL
   v.decVal = m_money
   RETURN v
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts the currency to a VT_CY variant.
' ========================================================================================
PRIVATE FUNCTION CMoney.ToCyVar () AS VARIANT
   DIM v AS VARIANT, cy AS CURRENCY
   VarCyFromDec(@m_money, @cy)
   v.vt = VT_CY
   v.cyVal = cy
   RETURN v
END FUNCTION
' ========================================================================================

' =====================================================================================
' Formats a currency number into a string form.
' This function can return a maximum value of +/-922,337,203,685,477.58.
' Parameters:
' - iNumDig: The number of digits to pad to after the decimal point.
'     Specify -1 to use the system default value.
' - iIncLead: Specifies whether to include the leading digit on numbers.
'     -2 : Use the system default.
'     -1 : Include the leading digit.
'      0 : Do not include the leading digit.
' - iUseParens: Specifies whether negative numbers should use parentheses.
'     -2 : Use the system default.
'     -1 : Use parentheses.
'      0 : Do not use parentheses.
' - iGroup: Specifies whether thousands should be grouped. For example 10,000 versus 10000.
'      Note Regular numbers and currencies have separate system defaults for all the above options.
'     -2 : Use the system default.
'     -1 : Group thousands.
'      0 : Do not group thousands.
' - dwFlags
'     VAR_CALENDAR_HIJRI is the only flag that can be set.
' Example:
' DIM c AS CMoney = 12345.12
' PRINT c.FormatCurrency   --> 12.345,12 € (Spain)
' =====================================================================================
PRIVATE FUNCTION CMoney.FormatCurrency (BYVAL iNumDig AS LONG = -1, BYVAL iIncLead AS LONG = -2, _
BYVAL iUseParens AS LONG = -2, BYVAL iGroup AS LONG = -2, BYVAL dwFlags AS DWORD = 0) AS STRING
   DIM s AS STRING, bstrOut AS BSTR
   DIM v AS VARIANT = this.ToCyVar
   VarFormatCurrency(@v, iNumDig, iIncLead, iUseParens, iGroup, dwFlags, @bstrOut)
   s = *cast(WSTRING PTR, bstrOut)
   SysFreeString bstrOut
   RETURN s
END FUNCTION
' =====================================================================================

' =====================================================================================
' Formats a currency number into a string form.
' Same as FormatCurrency but without adding the currency symbol.
' This function can return a maximum value of +/-922,337,203,685,477.58.
' Example:
'   DIM c AS CMoney = 12345.12
'   PRINT c.FormatNumber   --> 12.345,12 (Spain)
' =====================================================================================
PRIVATE FUNCTION CMoney.FormatNumber (BYVAL iNumDig AS LONG = -1, BYVAL iIncLead AS LONG = -2, _
BYVAL iUseParens AS LONG = -2, BYVAL iGroup AS LONG = -2, BYVAL dwFlags AS DWORD = 0) AS STRING
   DIM s AS STRING, bstrOut AS BSTR
   DIM v AS VARIANT = this.ToCyVar
   VarFormatNumber(@v, iNumDig, iIncLead, iUseParens, iGroup, dwFlags, @bstrOut)
   s = *cast(WSTRING PTR, bstrOut)
   SysFreeString bstrOut
   RETURN s
END FUNCTION
' =====================================================================================

END NAMESPACE
