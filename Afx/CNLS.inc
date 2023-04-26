' ########################################################################################
' Microsoft Windows
' File: CNLS.inc
' Contents: National language support
' Compiler: Free Basic 32 & 64 bit
' Copyright (c) 2018 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#INCLUDE ONCE "windows.bi"
#INCLUDE ONCE "win/winnls.bi"
#INCLUDE ONCE "Afx/CWStr.inc"
USING Afx

' Requires Windows Vista or superior.
#if _WIN32_WINNT = &h0602

' ========================================================================================
' CNLS Class - National Language Support
' ========================================================================================
TYPE CNLS

Private:
   m_pwszLocale AS WSTRING PTR

Public:
   DECLARE CONSTRUCTOR (BYVAL pwszLocale AS WSTRING PTR = LOCALE_NAME_USER_DEFAULT)
   DECLARE DESTRUCTOR
   DECLARE PROPERTY AbbrevDayName (BYVAL nDay AS LONG) AS CWSTR
   DECLARE PROPERTY AbbrevMonthName (BYVAL nMonth AS LONG) AS CWSTR
   DECLARE PROPERTY CountryName () AS CWSTR
   DECLARE PROPERTY CurrencySymbol () AS CWSTR
   DECLARE PROPERTY DateSeparator () AS CWSTR
   DECLARE PROPERTY DayName (BYVAL nDay AS LONG) AS CWSTR
   DECLARE PROPERTY DecimalSeparator () AS CWSTR
   DECLARE PROPERTY DigitsGrouping () AS CWSTR
   DECLARE PROPERTY DisplayName () AS CWSTR
   DECLARE PROPERTY EnglishCountryName () AS CWSTR
   DECLARE PROPERTY EnglishCurrencyName () AS CWSTR
   DECLARE PROPERTY EnglishDisplayName () AS CWSTR
   DECLARE PROPERTY EnglishLanguageName () AS CWSTR
   DECLARE PROPERTY InternationalMonetarySymbol () AS CWSTR
   DECLARE PROPERTY ISO639LanguageName () AS CWSTR
   DECLARE PROPERTY ISO639LanguageName2 () AS CWSTR
   DECLARE PROPERTY ISO3166CountryName () AS CWSTR
   DECLARE PROPERTY ISO3166CountryName2 () AS CWSTR
   DECLARE PROPERTY LanguageName () AS CWSTR
   DECLARE PROPERTY ListItemsSeparator () AS CWSTR
   DECLARE PROPERTY LocaleName () AS CWSTR
   DECLARE PROPERTY LocalizedCountryName () AS CWSTR
   DECLARE PROPERTY LocalizedDisplayName () AS CWSTR
   DECLARE PROPERTY LocalizedLanguageName () AS CWSTR
   DECLARE PROPERTY LongDateFormatString () AS CWSTR
   DECLARE PROPERTY MonetaryDecimalSeparator () AS CWSTR
   DECLARE PROPERTY MonetaryGrouping () AS CWSTR
   DECLARE PROPERTY MonetaryThousandsSeparator () AS CWSTR
   DECLARE PROPERTY MonthDayFormatString () AS CWSTR
   DECLARE PROPERTY MonthName (BYVAL nMonth AS LONG) AS CWSTR
   DECLARE PROPERTY NanString () AS CWSTR
   DECLARE PROPERTY NativeCountryName () AS CWSTR
   DECLARE PROPERTY NativeCurrencyName () AS CWSTR
   DECLARE PROPERTY NativeDigits () AS CWSTR
   DECLARE PROPERTY NativeDisplayName () AS CWSTR
   DECLARE PROPERTY NativeLanguageName () AS CWSTR
   DECLARE PROPERTY NegativeInfinityString () AS CWSTR
   DECLARE PROPERTY NegativeSign () AS CWSTR
   DECLARE PROPERTY OpenTypeLanguageTag () AS CWSTR
   DECLARE PROPERTY PermilleSymbol () AS CWSTR
   DECLARE PROPERTY PositiveInfinityString () AS CWSTR
   DECLARE PROPERTY PositiveSign () AS CWSTR
   DECLARE PROPERTY ScriptsList () AS CWSTR
   DECLARE PROPERTY ShortDateFormatString () AS CWSTR
   DECLARE PROPERTY ShortestDayName (BYVAL nDay AS LONG) AS CWSTR
   DECLARE PROPERTY ShortTimeFormatString () AS CWSTR
   DECLARE PROPERTY SortLocale () AS CWSTR
   DECLARE PROPERTY SortName () AS CWSTR
   DECLARE PROPERTY ThousandsSeparator () AS CWSTR
   DECLARE PROPERTY TimeFormatString () AS CWSTR
   DECLARE PROPERTY TimeSeparator () AS CWSTR
   DECLARE PROPERTY YearMonthFormatString () AS CWSTR

END TYPE
' ========================================================================================

' ========================================================================================
' Creates an instance of the CNLS
' - pwszLocale : Optional. Pointer to a locale name, or one of the following predefined values:
'   LOCALE_NAME_INVARIANT, LOCALE_NAME_SYSTEM_DEFAULT, LOCALE_NAME_USER_DEFAULT
' Usage example:
'   DIM pnls AS CNLS
'  PRINT pnls.AbbrevDayName(1)
' -or-
'  PRINT CNLS().AbbrevDayName(1)
' -or-
'  PRINT CNLS(LOCALE_NAME_INVARIANT).AbbrevDayName(1)
' ========================================================================================
PRIVATE CONSTRUCTOR CNLS(BYVAL pwszLocale AS WSTRING PTR = LOCALE_NAME_USER_DEFAULT)
   m_pwszLocale = pwszLocale
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
PRIVATE DESTRUCTOR CNLS
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Returns the abbreviated native day name for the specified day (1 = Monday, etc.).
' ========================================================================================
PRIVATE PROPERTY CNLS.AbbrevDayName (BYVAL nDay AS LONG) AS CWSTR
   DIM wszBuf AS WSTRING * 260
   IF nDay < 1 OR nDay > 7 THEN RETURN ""
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SABBREVDAYNAME1 + nDay - 1, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the abbreviated native month name for the specified month.
' ========================================================================================
PRIVATE PROPERTY CNLS.AbbrevMonthName (BYVAL nMonth AS LONG) AS CWSTR
   DIM wszBuf AS WSTRING * 260
   IF nMonth < 1 OR nMonth > 12 THEN RETURN ""
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SABBREVMONTHNAME1 + nMonth - 1, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full localized name of the country/region.
' Deprecated. See LocalizedCountryName.
' ========================================================================================
PRIVATE PROPERTY CNLS.CountryName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SCOUNTRY, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' String used as the local monetary symbol. The maximum number of characters allowed for
' this string is 13, including a terminating null character. For example, in the United
' States, this symbol is "$".
' ========================================================================================
PRIVATE PROPERTY CNLS.CurrencySymbol () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SCURRENCY, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) for the date separator. The maximum number of characters allowed for this
' string is four, including a terminating null character.
' This constant is deprecated. A custom locale might not have a single, uniform separator
' character. For example, a format such as "12/31, 2006" is valid.
' See ShortDateFormatString.
' ========================================================================================
PRIVATE PROPERTY CNLS.DateSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SDATE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the native day name for the specified day (1 = Monday, etc.).
' ========================================================================================
PRIVATE PROPERTY CNLS.DayName (BYVAL nDay AS LONG) AS CWSTR
   DIM wszBuf AS WSTRING * 260
   IF nDay < 1 OR nDay > 7 THEN RETURN ""
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SDAYNAME1 + nDay - 1, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) used for the decimal separator, for example, "." in "3.14" or "," in "3,14".
' The maximum number of characters allowed for this string is four, including a terminating
' null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.DecimalSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SDECIMAL, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Sizes for each group of digits to the left of the decimal. The maximum number of characters
' allowed for this string is ten, including a terminating null character. An explicit size
' is needed for each group, and sizes are separated by semicolons. If the last value is 0,
' the preceding value is repeated. For example, to group thousands, specify 3;0. Indic
' locales group the first thousand and then group by hundreds. For example, 12,34,56,789
' is represented by 3;2;0.
' ========================================================================================
PRIVATE PROPERTY CNLS.DigitsGrouping () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SGROUPING, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Primary language name included in a localized display name.
' Deprecated. See LocalizedDisplayName.
' ========================================================================================
PRIVATE PROPERTY CNLS.DisplayName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLANGDISPLAYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full English name of the country/region.
' ========================================================================================
PRIVATE PROPERTY CNLS.EnglishCountryName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SENGCOUNTRY, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' The full English name of the currency associated with the locale.
' ========================================================================================
PRIVATE PROPERTY CNLS.EnglishCurrencyName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SENGCURRNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Display name of the locale in English. Usually the display name consists of the language
' and the country/region, for example, German (Germany) for Deutsch (Deutschland).
' ========================================================================================
PRIVATE PROPERTY CNLS.EnglishDisplayName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SENGLISHDISPLAYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full English name of the language from ISO Standard 639.
' ========================================================================================
PRIVATE PROPERTY CNLS.EnglishLanguageName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SENGLANGUAGE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Three characters of the international monetary symbol specified in ISO 4217, followed by
' the character separating this string from the amount. The maximum number of characters
' allowed for this string is nine, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.InternationalMonetarySymbol () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SINTLSYMBOL, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' The abbreviated name of the language based entirely on the ISO Standard 639 values, in
' lowercase form, for example, "en" for English. The maximum number of characters allowed
' for this string is nine, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.ISO639LanguageName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SISO639LANGNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Three-letter ISO language name, in lowercase form (ISO 639-2 three-letter code for the
' language), for example, "eng" for English. The maximum number of characters allowed for
' this string is nine, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.ISO639LanguageName2 () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SISO639LANGNAME2, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Country/region name, based on ISO Standard 3166, for example, "US" for the United States.
' The maximum number of characters allowed for this string is nine, including a terminating
' null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.ISO3166CountryName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SISO3166CTRYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Three-letter ISO region name (ISO 3166 three-letter code for the country/region), for
' example, "USA" for the United States. The maximum number of characters allowed for this
' string is nine, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.ISO3166CountryName2 () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SISO3166CTRYNAME2, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full localized name of the language.
' Deprecated. See LocalizedLanguageName.
' ========================================================================================
PRIVATE PROPERTY CNLS.LanguageName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLANGUAGE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) used to separate list items, for example, a comma is used in many locales.
' The maximum number of characters allowed for this string is four, including a
' terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.ListItemsSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLIST, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Locale name, a multi-part tag to uniquely identify the locale.
' The maximum number of characters allowed for this string is 85, including a terminating
' null character. The tag is based on the language tagging conventions of RFC 4646.
' ========================================================================================
PRIVATE PROPERTY CNLS.LocaleName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full localized name of the country/region, for example, Deutschland for Germany.
' The maximum number of characters allowed for this string is 80, including a terminating
' null character. Since this name is based on the localization of the product, it changes
' for each localized version.
' ========================================================================================
PRIVATE PROPERTY CNLS.LocalizedCountryName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLOCALIZEDCOUNTRYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Windows 7 and later: Full localized name of the locale for the user interface language,
' for example, Deutsch (Deutschland) for German (Germany)" There is no limit on the number
' of characters allowed for this string. Since this name is based on the localization of
' the product, it changes for each localized version.
' ========================================================================================
PRIVATE PROPERTY CNLS.LocalizedDisplayName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLOCALIZEDDISPLAYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Full localized primary name of the user interface language included in a localized
' display name, for example, Deutsch representing German. Since this name is based on the
' localization of the product, it changes for each localized version.
' ========================================================================================
PRIVATE PROPERTY CNLS.LocalizedLanguageName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLOCALIZEDDISPLAYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Long date formatting string for the locale. The maximum number of characters allowed for
' this string is 80, including a terminating null character. The string can consist of a
' combination of day, month, year, and era format pictures and any string of characters
' enclosed in single quotes. Characters in single quotes remain as specified. For example,
' the Spanish (Spain) long date is "dddd, dd' de 'MMMM' de 'yyyy". Locales can define
' multiple long date formats.
' ========================================================================================
PRIVATE PROPERTY CNLS.LongDateFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SLONGDATE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) used as the monetary decimal separator. The maximum number of characters
' allowed for this string is four, including a terminating null character. For example,
' if a monetary amount is displayed as "$3.40", just as "three dollars and forty cents"
' is displayed in the United States, then the monetary decimal separator is ".".
' ========================================================================================
PRIVATE PROPERTY CNLS.MonetaryDecimalSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SMONDECIMALSEP, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Sizes for each group of monetary digits to the left of the decimal. The maximum number
' of characters allowed for this string is ten, including a terminating null character.
' An explicit size is needed for each group, and sizes are separated by semicolons. If the
' last value is 0, the preceding value is repeated. For example, to group thousands,
' specify 3;0. Indic languages group the first thousand and then group by hundreds. For
' example 12,34,56,789 is represented by 3;2;0.
' ========================================================================================
PRIVATE PROPERTY CNLS.MonetaryGrouping () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SMONGROUPING, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) used as the monetary separator between groups of digits to the left of the
' decimal. The maximum number of characters allowed for this string is four, including a
' terminating null character. Typically, the groups represent thousands. However, depending
' on the value specified for LOCALE_SMONGROUPING, they can represent something else.
' ========================================================================================
PRIVATE PROPERTY CNLS.MonetaryThousandsSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SMONTHOUSANDSEP, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Format string for displaying only the month and the day. The formatting is similar to
' that defined for LOCALE_SLONGDATE. For example, if the month/day pattern is the full
' month name followed by the day number with leading zeros, as in "September 03", the
' format string is "MMMM dd". The string can consist of a combination of day and month
' format pictures and any string of characters enclosed in single quotes.
' Characters in single quotes remain as specified, for example, 'de' for Spanish (Spain).
' A locale can specify only one month/day format.
' ========================================================================================
PRIVATE PROPERTY CNLS.MonthDayFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SMONTHDAY, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the native month name for the specified month.
' ========================================================================================
PRIVATE PROPERTY CNLS.MonthName (BYVAL nMonth AS LONG) AS CWSTR
   DIM wszBuf AS WSTRING * 260
   IF nMonth < 1 OR nMonth > 12 THEN RETURN ""
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SMONTHNAME1 + nMonth - 1, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' String value for "Not a number", for example, "Nan" for the English (United States) locale.
' There is no limit on the number of characters allowed for this string.
' ========================================================================================
PRIVATE PROPERTY CNLS.NanString () AS CWSTR
   DIM nLen AS LONG, wstrBuf AS CWSTR
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SNAN, BYVAL NULL, 0)
   IF nLen = 0 THEN RETURN ""
   wstrBuf = SPACE(nLen)
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SNAN, *wstrBuf, nLen)
   RETURN RTRIM(**wstrBuf)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Native name of the country/region, for example, España for Spain. The maximum number of
' characters allowed for this string is 80, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.NativeCountryName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNATIVECTRYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' The native name of the currency associated with the locale, in the native language of
' the locale. There is no limit on the number of characters allowed for this string.
' ========================================================================================
PRIVATE PROPERTY CNLS.NativeCurrencyName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNATIVECURRNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Native equivalents of ASCII 0 through 9. The maximum number of characters allowed for
' this string is eleven, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.NativeDigits () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNATIVEDIGITS, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Display name of the locale in its native language, for example, Deutsch (Deutschland)
' for the locale German (Germany).
' ========================================================================================
PRIVATE PROPERTY CNLS.NativeDisplayName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNATIVEDISPLAYNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Native name of the language, for example, ??????? for Armenian (Armenia). The maximum
' number of characters allowed for this string is 80, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.NativeLanguageName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNATIVELANGNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' String value for "negative infinity", for example, "-Infinity" for the English (United
' States) locale. There is no limit on the number of characters allowed for this string.
' ========================================================================================
PRIVATE PROPERTY CNLS.NegativeInfinityString () AS CWSTR
   DIM nLen AS LONG, wstrBuf AS CWSTR
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SNEGINFINITY, NULL, 0)
   IF nLen = 0 THEN RETURN ""
   wstrBuf = SPACE(nLen)
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SNEGINFINITY, *wstrBuf, nLen)
   RETURN RTRIM(**wstrBuf)
END PROPERTY
' ========================================================================================

' ========================================================================================
' String value for the negative sign, for example, "-" for the English (United States) locale.
' The maximum number of characters allowed for this string is five, including a terminating
' null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.NegativeSign () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SNEGATIVESIGN, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' OpenType language tag used to retrieve culturally appropriate typographic features from a font.
' ========================================================================================
PRIVATE PROPERTY CNLS.OpenTypeLanguageTag () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SOPENTYPELANGUAGETAG, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Symbol used to indicate the permille (U+2030) symbol, that is, ‰.
' ========================================================================================
PRIVATE PROPERTY CNLS.PermilleSymbol () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SPERMILLE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Windows Vista and later: String value for "positive infinity", for example, "Infinity"
' for the English (United States) locale. There is no limit on the number of characters
' allowed for the string.
' ========================================================================================
PRIVATE PROPERTY CNLS.PositiveInfinityString () AS CWSTR
   DIM nLen AS LONG, wstrBuf AS CWSTR
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SPOSINFINITY, BYVAL NULL, 0)
   IF nLen = 0 THEN RETURN ""
   wstrBuf = SPACE(nLen)
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SPOSINFINITY, *wstrBuf, nLen)
   RETURN RTRIM(wstrBuf)
END PROPERTY
' ========================================================================================

' ========================================================================================
' String value for the positive sign, for example, "+" for the English (United States)
' locale. The maximum number of characters allowed for this string is five, including a
' terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.PositiveSign () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SPOSITIVESIGN, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' A string representing a list of scripts, using the 4-character notation used in ISO 15924.
' Each script name consists of four Latin characters and the list is arranged in alphabetical
' order with each name, including the last, followed by a semicolon.
' ========================================================================================
PRIVATE PROPERTY CNLS.ScriptsList () AS CWSTR
   DIM nLen AS LONG, wstrBuf AS CWSTR
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SSCRIPTS, BYVAL NULL, 0)
   IF nLen = 0 THEN RETURN ""
   wstrBuf = SPACE(nLen)
   nLen = GetLocaleInfoEx(m_pwszLocale, LOCALE_SSCRIPTS, *wstrBuf, nLen)
   RETURN RTRIM(wstrBuf)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Short date formatting string for the locale. The maximum number of characters allowed
' for this string is 80, including a terminating null character. The string can consist of
' a combination of day, month, year, and era format pictures. For example, "M/d/yyyy"
' indicates that September 3, 2004 is written 9/3/2004.
' ========================================================================================
PRIVATE PROPERTY CNLS.ShortDateFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SSHORTDATE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Short native name of the specified day of the week.
' ========================================================================================
PRIVATE PROPERTY CNLS.ShortestDayName (BYVAL nDay AS LONG) AS CWSTR
   DIM wszBuf AS WSTRING * 260
   IF nDay < 1 OR nDay > 7 THEN RETURN ""
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SSHORTESTDAYNAME1 + nDay - 1, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Short time formatting string for the locale. Patterns are typically derived by removing
' the "ss" (seconds) value from the long time format pattern.
' For example, if the long time format is "h:mm:ss tt", the short time format is most
' likely "h:mm tt". This constant can specify multiple formats in a semicolon-delimited
' list. However, the preferred short time format should be the first value listed.
' ========================================================================================
PRIVATE PROPERTY CNLS.ShortTimeFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SSHORTTIME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Name of the locale to use for sorting or casing behavior.
' ========================================================================================
PRIVATE PROPERTY CNLS.SortLocale () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SSORTLOCALE, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' The full localized name of the sort for the specified locale identifier, dependent on
' the language of the shell. This constant is used to determine casing and sorting behavior.
' ========================================================================================
PRIVATE PROPERTY CNLS.SortName () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SSORTNAME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Characters that are used to separate groups of digits to the left of the decimal. The
' maximum number of characters allowed for this string is four, including a terminating
' null character. Typically, these groups represent thousands. However, depending on the
' value specified for LOCALE_SGROUPING, they can represent something else.
' ========================================================================================
PRIVATE PROPERTY CNLS.ThousandsSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_STHOUSAND, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Time formatting strings for the locale. The maximum number of characters allowed for
' this string is 80, including a terminating null character. The string can consist of a
' combination of hour, minute, and second format pictures.
' ========================================================================================
PRIVATE PROPERTY CNLS.TimeFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_STIMEFORMAT, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' Character(s) for the time separator. The maximum number of characters allowed for this
' string is four, including a terminating null character.
' ========================================================================================
PRIVATE PROPERTY CNLS.TimeSeparator () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_STIME, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

' ========================================================================================
' The year-month formatting string for the locale. The maximum number of characters allowed
' for this string is 80, including a terminating null character. This string shows the
' proper format for a date string that contains only the year and the month, using format
' pictures as defined in Day, Month, Year, and Era Format Pictures.
' ========================================================================================
PRIVATE PROPERTY CNLS.YearMonthFormatString () AS CWSTR
   DIM wszBuf AS WSTRING * 260
   GetLocaleInfoEx(m_pwszLocale, LOCALE_SYEARMONTH, wszBuf, SIZEOF(wszBuf))
   RETURN wszBuf
END PROPERTY
' ========================================================================================

#endif
