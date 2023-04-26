' ########################################################################################
' Microsoft Windows
' File: CPowerTime.inc
' Contents: Date and time class
' Compiler: FreeBasic 32 & 64-bit
' Written in 2019 by José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "DateTime.bi"
#include once "String.bi"
#include once "Afx/AfxTime.inc"

NAMESPACE Afx

CONST CPowerTime_Millisecond = 10000ull
CONST CPowerTime_Second = CPowerTime_Millisecond * 1000
CONST CPowerTime_Minute = CPowerTime_Second * 60
CONST CPowerTime_Hour = CPowerTime_Minute * 60
CONST CPowerTime_Day = CPowerTime_Hour * 24
CONST CPowerTime_Week = CPowerTime_Day * 7

' ########################################################################################
'                                 *** CPowerTime Class ***
' ########################################################################################

' ========================================================================================
' A CPowerTime object contains a date and time value, allowing easy calculations. The date
' and time value is stored as a 64-bit value representing the number of 100-nanosecond
' intervals since January 1, 1601. A nanosecond is one-billionth of a second.
' ========================================================================================
TYPE CPowerTime

Public:
	dwLowDateTime AS DWORD
	dwHighDateTime AS DWORD

Public:
   DECLARE CONSTRUCTOR
   DECLARE CONSTRUCTOR (BYVAL nTime AS ULONGLONG)
   DECLARE CONSTRUCTOR (BYREF ft AS FILETIME)
   DECLARE CONSTRUCTOR (BYREF st AS SYSTEMTIME)
   DECLARE DESTRUCTOR
   DECLARE OPERATOR CAST () AS ULONGLONG
   DECLARE OPERATOR LET (BYVAL nTime AS ULONGLONG)
   DECLARE OPERATOR LET (BYREF ft AS FILETIME)
   DECLARE OPERATOR LET (BYREF st AS SYSTEMTIME)
   DECLARE FUNCTION GetFileTime () AS ULONGLONG
   DECLARE SUB SetFileTime (BYVAL nTime AS ULONGLONG)
   DECLARE PROPERTY DateSerial () AS DOUBLE
   DECLARE PROPERTY DateSerial (BYVAL dTime AS DOUBLE)
   DECLARE FUNCTION GetCurrentTime () AS CPowerTime
   DECLARE FUNCTION GetAsFileTime () AS FILETIME
   DECLARE FUNCTION GetAsSystemTime () AS SYSTEMTIME
   DECLARE FUNCTION GetAsJulianDate () AS LONG
   DECLARE FUNCTION GetAsJulianDate (BYVAL nYear AS LONG, BYVAL nMonth AS LONG, BYVAL nDay AS LONG) AS LONG
   DECLARE FUNCTION Year () AS LONG
   DECLARE FUNCTION Month () AS LONG
   DECLARE FUNCTION Day () AS LONG
   DECLARE FUNCTION Hour () AS LONG
   DECLARE FUNCTION Minute () AS LONG
   DECLARE FUNCTION Second () AS LONG
   DECLARE FUNCTION MSecond () AS LONG
   DECLARE FUNCTION DayOfWeek () AS LONG
   DECLARE FUNCTION DayOfWeekString (BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DECLARE FUNCTION IsLeapYear (BYVAL nYear AS LONG = 0) AS BOOLEAN
   DECLARE FUNCTION DaysInMonth (BYVAL nMonth AS LONG, BYVAL nYear AS LONG) AS LONG
   DECLARE FUNCTION DaysInMonth () AS LONG
   DECLARE FUNCTION DaysInYear (BYVAL nYear AS LONG = 0) AS LONG
   DECLARE SUB Today ()
   DECLARE SUB Now ()
   DECLARE SUB NowUTC ()
   DECLARE SUB AddYears (BYVAL nYears AS LONG)
   DECLARE SUB AddMonths (BYVAL nMonts AS LONG)
   DECLARE SUB AddDays (BYVAL nDays AS LONG)
   DECLARE SUB AddHours (BYVAL nHours AS LONG)
   DECLARE SUB AddMinutes (BYVAL nMinutes AS LONG)
   DECLARE SUB AddSeconds (BYVAL nSeconds AS LONG)
   DECLARE SUB AddMSeconds (BYVAL nMSeconds AS LONG)
   DECLARE SUB NewDate (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0)
   DECLARE SUB NewTime (BYVAL nHour AS LONG = 0, BYVAL nMinute AS LONG = 0, BYVAL nSecond AS LONG = 0, BYVAL nMSecond AS LONG = 0)
   DECLARE FUNCTION AstroDay () AS LONG
   DECLARE FUNCTION AstroDay (BYVAL nYear AS LONG, BYVAL nMonth AS LONG, BYVAL nDay AS LONG) AS LONG
   DECLARE FUNCTION AstroDayOfWeek (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
   DECLARE SUB ToUTC
   DECLARE SUB ToLocalTime
   DECLARE SUB JulianToGregorian (BYVAL nJulian AS LONG, BYREF wDay AS WORD, BYREF wMonth AS WORD, BYREF wYear AS WORD)
   DECLARE FUNCTION WeekOne (BYVAL nYear AS LONG = 0) AS LONG
   DECLARE FUNCTION WeekNumber (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
   DECLARE FUNCTION WeeksInYear (BYVAL nYear AS LONG = 0) AS LONG
   DECLARE FUNCTION WeeksInMonth (BYVAL nMonth AS LONG = 0, BYVAL nYear AS LONG = 0) AS LONG
   DECLARE FUNCTION IsFirstDayOfMonth () AS BOOLEAN
   DECLARE FUNCTION IsLastDayOfMonth () AS BOOLEAN
   DECLARE FUNCTION DayOfYear (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
'   DECLARE SUB DateDiff(BYREF cpt AS CPowerTime, BYREF nSign AS LONG, BYREF nYears AS LONG, BYREF nMonths AS LONG, BYREF nDays AS LONG)
   DECLARE FUNCTION DaysDiff(BYREF cpt AS CPowerTime) AS LONG
   DECLARE FUNCTION DaysDiff (BYVAL nYear1 AS LONG, BYVAL nMonth1 AS LONG, BYVAL nDay1 AS LONG, _
           BYVAL nYear2 AS LONG, BYVAL nMonth2 AS LONG, BYVAL nDay2 AS LONG) AS LONG
   DECLARE FUNCTION MonthString (BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DECLARE FUNCTION DateString (BYREF wszFmt AS WSTRING, BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DECLARE FUNCTION TimeString (BYREF wszFmt AS WSTRING, BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DECLARE FUNCTION Format (BYREF wszFmt AS WSTRING) AS CWSTR

END TYPE
' ========================================================================================

' ========================================================================================
' CPowerTime constructors
' ========================================================================================
PRIVATE CONSTRUCTOR CPowerTime
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Constructs a CPowerTime object from a date and time expressed as a 64-bit value.
' ========================================================================================
PRIVATE CONSTRUCTOR CPowerTime (BYVAL nTime AS ULONGLONG)
	dwLowDateTime = CULNG(nTime)
	dwHighDateTime = CULNG(nTime shr 32)
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Constructs a CPowerTime object from a FILETIME structure.
' ========================================================================================
PRIVATE CONSTRUCTOR CPowerTime (BYREF ft AS FILETIME)
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' Constructs a CPowerTime object from a SYSTEMTIME structure.
' ========================================================================================
PRIVATE CONSTRUCTOR CPowerTime (BYREF st AS SYSTEMTIME)
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END CONSTRUCTOR
' ========================================================================================
' ========================================================================================
' CPowerTime destructor
' ========================================================================================
PRIVATE DESTRUCTOR CPowerTime
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Returns the underlying m_time value from this CPowerTime object.
' Example:
'   DIM cpt AS CPowerTime = CPowerTime().GetCurrentTime()
'   DIM nTime AS LONGLONG = cpt
'   print nTime
' ========================================================================================
PRIVATE OPERATOR CPowerTime.CAST () AS ULONGLONG
   RETURN (CULNGINT(dwHighDateTime) shl 32) OR dwLowDateTime
END OPERATOR
' ========================================================================================

' ========================================================================================
' Assigns a time value to this CPowerTime object.
' nTime: A date and time expressed as a 64-bit value.
' ========================================================================================
PRIVATE OPERATOR CPowerTime.LET (BYVAL nTime AS ULONGLONG)
   dwLowDateTime = CULNG(nTime)
   dwHighDateTime = CULNG(nTime shr 32)
END OPERATOR
' ========================================================================================
' ========================================================================================
' Assigns a FILETIME value to this CPowerTime object.
' ========================================================================================
PRIVATE OPERATOR CPowerTime.LET (BYREF ft AS FILETIME)
   dwLowDateTime = ft.dwLowDateTime
   dwHighDateTime = ft.dwHighDateTime
END OPERATOR
' ========================================================================================
' ========================================================================================
' Assigns a SYSTEMTIME value to this CPowerTime object.
' ========================================================================================
PRIVATE OPERATOR CPowerTime.LET (BYREF st AS SYSTEMTIME)
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
   dwHighDateTime = ft.dwHighDateTime
END OPERATOR
' ========================================================================================

' ========================================================================================
' Retrieves the date and time of this CPowerTime object.
' Example:
'   DIM cpt AS CPowerTime = CPowerTime().GetCurrentTime()
'   print cpt.GetFileTime
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetFileTime () AS ULONGLONG
   RETURN (CULNGINT(dwHighDateTime) shl 32) OR dwLowDateTime
END FUNCTION
' ========================================================================================

' ========================================================================================
' Sets the date and time of this CPowerTime object.
' ========================================================================================
PRIVATE SUB CPowerTime.SetFileTime (BYVAL nTime AS ULONGLONG)
	dwLowDateTime = CULNG(nTime)
	dwHighDateTime = CULNG(nTime shr 32)
END SUB
' ========================================================================================

' ========================================================================================
' Returns a CFileTime object that represents the current system date and time.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetCurrentTime () AS CPowerTime
	DIM ft AS FILETIME
	GetSystemTimeAsFileTime(@ft)
	RETURN CPowerTime(ft)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the date and time as a FILETIME structure.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetAsFileTime () AS FILETIME
   DIM ft AS FILETIME
	ft.dwLowDateTime = dwLowDateTime
	ft.dwHighDateTime = dwHighDateTime
   RETURN ft
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the date and time as a SYSTEMTIME structure.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetAsSystemTime () AS SYSTEMTIME
   DIM ft AS FILETIME
	ft.dwLowDateTime = dwLowDateTime
	ft.dwHighDateTime = dwHighDateTime
   DIM st AS SYSTEMTIME
   FileTimeToSystemTime(@ft, @st)
   RETURN st
END FUNCTION
' ========================================================================================

' ========================================================================================
' Gets/sets the date and time as a FreeBasic date serial.
' ========================================================================================
PRIVATE PROPERTY CPowerTime.DateSerial () AS DOUBLE
   DIM ft AS FILETIME
   ft.dwLowDateTime = dwLowDateTime
   ft.dwHighDateTime = dwHighDateTime
   DIM dt AS DOUBLE, st AS SYSTEMTIME
   FileTimeToSystemTime(@ft, @st)
   SystemTimeToVariantTime @st, @dt
   RETURN dt
END PROPERTY
' ========================================================================================
' ========================================================================================
PRIVATE PROPERTY CPowerTime.DateSerial (BYVAL dTime AS DOUBLE)
   DIM st AS SYSTEMTIME
   VariantTimeToSystemTime dTime, @st
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
   dwHighDateTime = ft.dwHighDateTime
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the date as a Julian date.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetAsJulianDate () AS LONG

   DIM DaysElapsed AS LONG
   DIM InvalidLeapYears AS LONG
   DIM ValidLeapYears AS LONG
   DIM DaysOfMonths AS LONG

   DIM nYear AS LONG = this.Year
   DIM nMonth AS LONG = this.Month
   DIM nDay AS LONG = this.Day

   ' // January or February? 13 or 14th month of the previous year.
   IF nMonth < 3 THEN nMonth += 12 : nYear -=1
   ' // Day 1 of julian calendar is 1/1/-4712 and there are 365.25 days per year
   DaysElapsed = INT((nYear + 4712) * 365.25)
   ' // Subtract invalid leap years
   InvalidLeapYears = nYear \ 100
   ' // Add valid leap years
   ValidLeapYears = nYear \ 400
   ' // Days of months
   DaysOfMonths = INT(30.6 * (nMonth - 1) + .2)

   RETURN DaysElapsed - InvalidLeapYears + ValidLeapYears + DaysOfMonths + nDay

END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a Gregorian date to a Julian date.
' Parameters:
' - nDay: A number between 1-31.
' - nMonth: A number between 1-12.
' - nYear: A four digit year, e.g. 2011.
' Return Value:
' - The converted date.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.GetAsJulianDate (BYVAL nYear AS LONG, BYVAL nMonth AS LONG, BYVAL nDay AS LONG) AS LONG

   DIM DaysElapsed AS LONG
   DIM InvalidLeapYears AS LONG
   DIM ValidLeapYears AS LONG
   DIM DaysOfMonths AS LONG

   IF nMonth < 1 OR nMonth > 12 THEN RETURN 0
   IF nDay < 1 OR nDay > 31 THEN RETURN 0
   ' // January or February? 13 or 14th month of the previous year.
   IF nMonth < 3 THEN nMonth += 12 : nYear -=1
   ' // Day 1 of julian calendar is 1/1/-4712 and there are 365.25 days per year
   DaysElapsed = INT((nYear + 4712) * 365.25)
   ' // Subtract invalid leap years
   InvalidLeapYears = nYear \ 100
   ' // Add valid leap years
   ValidLeapYears = nYear \ 400
   ' // Days of months
   DaysOfMonths = INT(30.6 * (nMonth - 1) + .2)

   RETURN DaysElapsed - InvalidLeapYears + ValidLeapYears + DaysOfMonths + nDay

END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the year of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Year () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wYear
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the month of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Month () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wMonth
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the day of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Day () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wDay
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the hour of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Hour () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wHour
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the minute of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Minute () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wMinute
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the second of this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Second () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wSecond
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the millisecond component of the CPowerTime object.
' This is a numeric value in the range of 0-999.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.MSecond () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wMilliSeconds
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the Day-of-Week component of the CPowerTime object.
' It is a numeric value in the range of 0-6 (representing Sunday through Saturday).
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DayOfWeek () AS LONG
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN st.wDayOfWeek
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the Day-of-Week name of the CPowerTime object, expressed as a string (Monday, Tuesday...).
' The day name is appropriate for the locale, based upon the LCID parameter. If LCID is
' not given, the default LCID for the user is substituted.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DayOfWeekString (BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DIM wszDateStr AS WSTRING * 260
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   GetDateFormatW(lcid, NULL, @st, "dddd", wszDateStr, SIZEOF(wszDateStr))
   RETURN wszDateStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' Determines if a given year is a leap year or not.
' Return value:
' - TRUE or FALSE.
' Note: A leap year is defined as all years divisible by 4, except for years divisible by
' 100 that are not also divisible by 400. Years divisible by 400 are leap years. 2000 is a
' leap year. 1900 is not a leap year.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.IsLeapYear (BYVAL nYear AS LONG = 0) AS BOOLEAN
   IF nYear = 0 THEN nYear = this.Year
   IF (nYear MOD 4 = 0 AND nYear MOD 100 <> 0) OR nYear MOD 400 = 0 THEN RETURN TRUE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of days in the specified month.
' Parameters:
' - nMonth: A two digit month (1-12).
' - nYear: A four digit year, e.g. 2011.
' Return Value:
' - The number of days.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DaysInMonth (BYVAL nMonth AS LONG, BYVAL nYear AS LONG) AS LONG
   SELECT CASE nMonth
      CASE 2 : IF AfxIsLeapYear(nYear) THEN RETURN 29 ELSE RETURN 28
      CASE 4, 6, 9, 11 : RETURN 30
      CASE 1, 3, 5, 7, 8, 10, 12 : RETURN 31
   END SELECT
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of days of this CPowerTime object.
' Return Value:
' - The number of days.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DaysInMonth () AS LONG
   SELECT CASE this.Month
      CASE 2 : IF AfxIsLeapYear(this.Year) THEN RETURN 29 ELSE RETURN 28
      CASE 4, 6, 9, 11 : RETURN 30
      CASE 1, 3, 5, 7, 8, 10, 12 : RETURN 31
   END SELECT
END FUNCTION
' ========================================================================================

' ========================================================================================
' Assigns the current local date on this computer to this CPowerTime object.
' This is suitable for applications that work with dates only.
' ========================================================================================
PRIVATE SUB CPowerTime.Today
   DIM st AS SYSTEMTIME
   GetLocalTime @st
   st.wHour = 0
   st.wMinute = 0
   st.wSecond = 0
   st.wMilliseconds = 0
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END SUB
' ========================================================================================

' ========================================================================================
' Assigns the current local date and time on this computer to this CPowerTime object.
' ========================================================================================
PRIVATE SUB CPowerTime.Now
   DIM st AS SYSTEMTIME
   GetLocalTime @st
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END SUB
' ========================================================================================

' ========================================================================================
' Assigns the current Coordinated Universal date and time (UTC) to this CPowerTime object.
' ========================================================================================
PRIVATE SUB CPowerTime.NowUTC
   DIM st AS SYSTEMTIME
   GetLocalTime @st
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
   DIM ftUTC AS FILETIME
	IF LocalFileTimeToFileTime(@ft, @ftUTC) THEN
	   dwLowDateTime = ftUTC.dwLowDateTime
	   dwHighDateTime = ftUTC.dwHighDateTime
   END IF
END SUB
' ========================================================================================

' ========================================================================================
' Adds the specified number of years to this CPowerTime object.
' You can subtract years by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddYears (BYVAL nYears AS LONG)
   IF nYears = 0 THEN RETURN
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   st.wYear += nYears
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
   dwHighDateTime = ft.dwHighDateTime
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of months to this CPowerTime object.
' You can subtract months by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddMonths (BYVAL nMonths AS LONG)
   IF nMonths = 0 THEN RETURN
   DIM nYear AS LONG = this.Year
   DIM nMonth AS LONG = this.Month
   DIM nDays AS LONG
   IF nMonths > 0 THEN
      FOR i AS LONG = 0 TO nMonths - 1
         IF i > 0 THEN nMonth += 1
         IF nMonth > 12 THEN nMonth = 1 : nYear += 1
         nDays += this.DaysInMonth(nMonth, nYear)
      NEXT
      this.SetFileTime(this.GetFileTime() + CPowerTime_Day * nDays)
   ELSE
      FOR i AS LONG = 1 TO ABS(nMonths)
         nMonth -= 1
         IF nMonth < 1 THEN nMonth = 12 : nYear -= 1
         nDays += this.DaysInMonth(nMonth, nYear)
      NEXT
      this.SetFileTime(this.GetFileTime() - CPowerTime_Day * nDays)
   END IF
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of days to this CPowerTime object.
' You can subtract days by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddDays (BYVAL nDays AS LONG)
   IF nDays = 0 THEN RETURN
   this.SetFileTime(this.GetFileTime() + CPowerTime_Day * nDays)
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of hours to this CPowerTime object.
' You can subtract hours by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddHours (BYVAL nHours AS LONG)
   IF nHours = 0 THEN RETURN
   this.SetFileTime(this.GetFileTime() + CPowerTime_Hour * nHours)
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of minutes to this CPowerTime object.
' You can subtract minutes by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddMinutes (BYVAL nMinutes AS LONG)
   IF nMinutes = 0 THEN RETURN
   this.SetFileTime(this.GetFileTime() + CPowerTime_Minute * nMinutes)
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of seconds to this CPowerTime object.
' You can subtract seconds by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddSeconds (BYVAL nSeconds AS LONG)
   IF nSeconds = 0 THEN RETURN
   this.SetFileTime(this.GetFileTime() + CPowerTime_Second * nSeconds)
END SUB
' ========================================================================================
' ========================================================================================
' Adds the specified number of milliseconds to this CPowerTime object.
' You can subtract seconds by using a negative number.
' ========================================================================================
PRIVATE SUB CPowerTime.AddMSeconds (BYVAL nMSeconds AS LONG)
   IF nMSeconds = 0 THEN RETURN
   this.SetFileTime(this.GetFileTime() + CPowerTime_Millisecond * nMSeconds)
END SUB
' ========================================================================================

' ========================================================================================
' The date component of the CPowerTime object is assigned a new value based upon the specified
' parameters. The time component is unchanged. If parameters are invalid, GetLastError
' will return ERROR_INVALID_PARAMETER.
' ========================================================================================
PRIVATE SUB CPowerTime.NewDate (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0)
   IF nYear < 1601 or nYear > 30827 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF nMonth < 0 or nMonth > 12 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF nDay < 0 or nDay > this.DaysInMonth(nMonth, nYear) THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   st.wYear = nYear
   st.wMonth = nMonth
   st.wDay = nDay
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END SUB
' ========================================================================================

' ========================================================================================
' The time component of the CPowerTime object is assigned a new value based upon the specified
' parameters. The date component is unchanged. If parameters are invalid, GetLastError
' will return ERROR_INVALID_PARAMETER.
' ========================================================================================
PRIVATE SUB CPowerTime.NewTime (BYVAL nHour AS LONG = 0, BYVAL nMinute AS LONG = 0, BYVAL nSecond AS LONG = 0, BYVAL nMSecond AS LONG = 0)
   IF nHour < 0 or nHour > 23 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF nMinute < 0 or nMinute > 59 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF nSecond < 0 or nSecond > 59 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF nMSecond < 0 or nMSecond > 999 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   st.wHour = nHour
   st.wMinute = nMinute
   st.wSecond = nSecond
   st.wMilliSeconds = nMSecond
   DIM ft AS FILETIME
   SystemTimeToFileTime @st, @ft
	dwLowDateTime = ft.dwLowDateTime
	dwHighDateTime = ft.dwHighDateTime
END SUB
' ========================================================================================

' ========================================================================================
' Returns the Astronomical Day for this CPowerTime object.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.AstroDay () AS LONG
   DIM y AS DOUBLE = this.Year + (this.Month - 2.85) / 12
   RETURN INT(INT(INT(367 * y) - 1.75 * INT(y) + this.Day) - 0.75 * INT(0.01 * y)) + 1721119
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the Astronomical Day for any given date.
' Parameters:
' - nDay: A number between 1-31.
' - nMonth; A number between 1-12.
' - nYear: A four digit year, e.g. 2011.
' Return Value:
' - The Astronomical Day.
' See: http://support.microsoft.com/kb/109451/en-us
' Note: Among other things, can be used to find the number of days between any two dates, e.g.:
' PRINT AfxAstroDay(-12400, 3, 1) - AfxAstroDay(-12400, 2, 28)  ' Prints 2
' PRINT AfxAstroDay(12000, 3, 1) - AfxAstroDay(-12000, 2, 28) ' Prints 8765822
' PRINT AfxAstroDay(1902, 2, 28) - AfxAstroDay(1898, 3, 1)  ' Prints 1459 days
' ========================================================================================
PRIVATE FUNCTION CPowerTime.AstroDay (BYVAL nYear AS LONG, BYVAL nMonth AS LONG, BYVAL nDay AS LONG) AS LONG
   DIM y AS DOUBLE = nYear + (nMonth - 2.85) / 12
   RETURN INT(INT(INT(367 * y) - 1.75 * INT(y) + nDay) - 0.75 * INT(0.01 * y)) + 1721116
END FUNCTION
' ========================================================================================

' ========================================================================================
' Calculates the day of the week, Sunday through Monday, of a given date.
' Parameters:
' - nDay: A number between 1-31.
' - nMonth; A number between 1-12.
' - nYear: A four digit year, e.g. 2011.
' Return Value:
' - A number between 0-6, where 0 = Sunday, 1 = Monday, 2 = Tuesday, 3 = Wednesday,
'   4 = Thursday, 5 = Friday, 6 = Saturday.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.AstroDayOfWeek (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   IF nMonth = 0 THEN nMonth = this.Month
   IF nDay = 0 THEN nDay = this.Day
   RETURN this.AstroDay(nYear, nMonth, nDay) MOD 7
END FUNCTION
' ========================================================================================

' ========================================================================================
' The CPowerTime object is converted to Coordinated Universal Time (UTC). It is assumed
' that previous value was in local time.
' ========================================================================================
SUB CPowerTime.ToUTC
 	DIM ft AS FILETIME, ftUTC AS FILETIME
   ft = TYPE<FILETIME>(dwLowDateTime, dwHighDateTime)
	IF LocalFileTimeToFileTime(@ft, @ftUTC) THEN
      dwLowDateTime = ftUTC.dwLowDateTime
      dwHighDateTime = ftUTC.dwHighDateTime
   END IF
END SUB
' ========================================================================================

' ========================================================================================
' The CPowerTime object is converted to local time. It is assumed that the previous value
' was in Coordinated Universal Time (UTC).
' ========================================================================================
SUB CPowerTime.ToLocalTime
	DIM ft AS FILETIME, ftLocal AS FILETIME
   ft = TYPE<FILETIME>(dwLowDateTime, dwHighDateTime)
	IF FileTimeToLocalFileTime(@ft, @ftLocal) THEN
      dwLowDateTime = ftLocal.dwLowDateTime
      dwHighDateTime = ftLocal.dwHighDateTime
   END IF
END SUB
' ========================================================================================

' ========================================================================================
' The date part of the internal CPowerTime object is compared to the date part of the
' specified external CPowerTime object. The time-of-day part of each is ignored. The
' difference is assigned to the parameter variables you provide. nSign is -1 if the internal
' value is smaller. nSign is 0 if the values are equal. nSign is +1 if the internal value
' is larger. The other parameters tell the difference as positive integer values. If
' parameters are invalid, an appropriate error code is returned in GetLastError.
' Note: Works in most cases, but fails in e.g.finding the difference between
' 2 February 2919 and 25 December 1930 (returns 88 years, 1 month 10 days instead of
' 88 years, 1 month and 8 days).
' ========================================================================================
'PRIVATE SUB CPowerTime.DateDiff (BYREF cpt AS CPowerTime, BYREF nSign AS LONG, BYREF nYears AS LONG, BYREF nMonths AS LONG, BYREF nDays AS LONG)
'   IF VARPTR(nSign) = NULL OR VARPTR (nYears) = NULL OR VARPTR(nMonths) = NULL OR VARPTR(nDays) = NULL THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
'   DIM n1 AS LONG = this.AstroDay(this.Year, this.Month, this.Day)
'   DIM n2 AS LONG = this.AstroDay(cpt.Year, cpt.Month, cpt.Day)
'   IF n1 > n2 THEN nSign = 1 ELSE IF n1 < n2 THEN nSign = -1 ELSE nSign = 0
'   DIM diff AS LONG = n1 - n2        ' // Days of difference betweenn the two dates
'   DIM y AS LONG = diff \ 365.2425   ' // Years of difference
'   diff = diff - (y * 365.2425)      ' // Number of remaining days
'   DIM m AS LONG = diff \ 30.44      ' // Months of difference
'   DIM d AS LONG = diff - m * 30.44  ' // Remaining days
'   nYears = ABS(y)
'   nMonths = ABS(m)
'   nDays = ABS(d)
'END SUB
' ========================================================================================

' ========================================================================================
' The date part of the internal CPowerTime object is compared to the date part of the
' specified external CPowerTime object. The time-of-day part of each is ignored. The
' difference in number of days is returned as the result of the function.
' Example:
' DIM cpt AS CPowerTime
' cpt.NewDate(2019, 2, 2)
' DIM cpt2 AS CPowerTime
' cpt2.NewDate(1930, 12, 25)
' print cpt.DaysDiff(cpt2)
' --or--
' print cpt2.DaysDiff(cpt)
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DaysDiff (BYREF cpt AS CPowerTime) AS LONG
   DIM n1 AS LONG = this.AstroDay(this.Year, this.Month, this.Day)
   DIM n2 AS LONG = this.AstroDay(cpt.Year, cpt.Month, cpt.Day)
   RETURN ABS(n1 - n2)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Calculates the days of difference between two dates.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DaysDiff (BYVAL nYear1 AS LONG, BYVAL nMonth1 AS LONG, BYVAL nDay1 AS LONG, _
   BYVAL nYear2 AS LONG, BYVAL nMonth2 AS LONG, BYVAL nDay2 AS LONG) AS LONG
   DIM n1 AS LONG = this.AstroDay(nYear1, nMonth1, nDay1)
   DIM n2 AS LONG = this.AstroDay(nYear2, nMonth2, nDay2)
   RETURN ABS(n1 - n2)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a Julian date to a Gregorian date.
' Parameters:
' - nJulian [in] = The julian date to convert
' - nDay [out] = The day
' - nMonth [out] = The month
' - nYear [out] = The year
' ========================================================================================
PRIVATE SUB CPowerTime.JulianToGregorian (BYVAL nJulian AS LONG, BYREF wDay AS WORD, BYREF wMonth AS WORD, BYREF wYear AS WORD)
   IF VARPTR(wDay) = 0 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF VARPTR(wMonth) = 0 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   IF VARPTR(wYear) = 0 THEN SetLastError(ERROR_INVALID_PARAMETER) : RETURN
   nJulian = nJulian + 68569
   DIM nHelp AS LONG = 4 * nJulian \ 146097
   nJulian = nJulian - ((146097 * nHelp + 3) \ 4)
   DIM nTmpYear AS LONG = 4000 * (nJulian + 1) \ 1461001
   nJulian = nJulian - (1461 * nTmpYear \ 4) + 31
   DIM nTmpMonth AS LONG = 80 * nJulian \ 2447
   wDay = nJulian - (2447 * nTmpMonth \ 80)
   wMonth = nTmpMonth + 2 - (12 * (nTmpMonth \ 11))
   wYear = 100 * (nHelp - 49) + nTmpYear + (nTmpMonth \ 11)
END SUB
' ========================================================================================

' ========================================================================================
' Returns the first day of the first week of the year. Note that the result can be one of
' the last days of the previous year, e.g. the first day of the first week of year 2002 is
' 31 December 2001. To convert the returned julian date to gregorian use JulianToGregorian.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.WeekOne (BYVAL nYear AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   DIM nFirstDay AS LONG = this.GetAsJulianDate(nYear, 1, 1) - 1  ' Dec. 31 of prev. year
   DO
      nFirstDay += 1
   LOOP UNTIL (nFirstDay MOD 7 + 1) = 4    ' until first Thursday of the year is found
   RETURN nFirstDay - 3                    ' first day of week 1 is a Monday
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the week number for a given date. The year must be a 4 digit year.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.WeekNumber (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   IF nMonth = 0 THEN nMonth = this.Month
   IF nDay = 0 THEN nDay = this.Day
   DIM nFirstDay AS LONG = this.WeekOne(nYear)
   DIM nFinalDay AS LONG = this.WeekOne(nYear + 1) - 1
   DIM nToDay AS LONG = this.GetAsJulianDate(nYear, nMonth, nDay)
   SELECT CASE nToDay
      CASE IS < nFirstDay
         ' it is week 52 or 53, but which one?
         ' therefore we need week one of previous year as a starting point
         nFirstDay = this.WeekOne(nYear - 1)
      CASE IS > nFinalDay
         ' there is only one possibility: week number 1
         RETURN 1
   END SELECT
   RETURN ((nToDay - nFirstDay) \ 7) + 1
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of weeks in the year, where weeks are taken to start on Monday. Will be 52 or 53.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.WeeksInYear (BYVAL nYear AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   DIM nWeeks AS LONG = this.WeekNumber(31, 12, nYear)
   IF nWeeks = 53 THEN RETURN 53 ELSE RETURN 52
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of weeks in the specified month and year. Will be 4 or 5.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.WeeksInMonth (BYVAL nMonth AS LONG = 0, BYVAL nYear AS LONG = 0) AS LONG
   IF nMonth = 0 THEN nMonth = this.Month
   IF nYear = 0 THEN nYear = this.Year
   IF nMonth < 1 OR nMonth > 12 THEN RETURN 0
   DIM wim AS LONG = this.AstroDayOfWeek(nYear, nMonth, 1) - 1
   IF wim = -1 THEN wim = 6
   DIM nWeeks AS LONG = (this.DaysInMonth(nMonth, nYear) + wim) \ 7
   RETURN nWeeks
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns true if today is the first day of the month; false, otherwise.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.IsFirstDayOfMonth () AS BOOLEAN
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN (st.wDay = 1)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns true if the date is the last day of the month; false, otherwise.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.IsLastDayOfMonth () AS BOOLEAN
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   RETURN (st.wDay = this.DaysInMonth(st.wMonth, st.wYear))
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of days in the specified year.
' Parameters:
' - nYear: A four digit year, e.g. 2011.
' Return Value:
' - The number of days. Will be 365 or 366 (for leap years).
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DaysInYear (BYVAL nYear AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   IF this.IsLeapYear(nYear) THEN RETURN 366 ELSE RETURN 365
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the day of the year, where Jan 1 is the first day of the year.
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DayOfYear (BYVAL nYear AS LONG = 0, BYVAL nMonth AS LONG = 0, BYVAL nDay AS LONG = 0) AS LONG
   IF nYear = 0 THEN nYear = this.Year
   IF nMonth = 0 THEN nMonth = this.Month
   IF nDay = 0 THEN nDay = this.Day
   RETURN this.AstroDay(nYear, nMonth, nDay) - this.AstroDay(nYear, 1, 1) + 1
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the Month component of the CPowerTime object, expressed as a string (January, February...).
' ========================================================================================
PRIVATE FUNCTION CPowerTime.MonthString (BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DIM wszDateStr AS WSTRING * 260
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   GetDateFormatW(lcid, NULL, @st, "MMMM", wszDateStr, SIZEOF(wszDateStr))
   RETURN wszDateStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retuns the current local date based on the specified mask, e.g. "dd-MM-yyyy".
' ========================================================================================
PRIVATE FUNCTION CPowerTime.DateString (BYREF wszMask AS WSTRING, BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   DIM wszDateStr AS WSTRING * 260
   GetDateFormatW(lcid, NULL, @st, wszMask, wszDateStr, SIZEOF(wszDateStr))
   RETURN wszDateStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retuns the current local time based on the specified mask, e.g. "hh':'mm':'ss".
' ========================================================================================
PRIVATE FUNCTION CPowerTime.TimeString (BYREF wszMask AS WSTRING, BYVAL lcid AS LCID = LOCALE_USER_DEFAULT) AS CWSTR
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   DIM wszDateStr AS WSTRING * 260
   GetTimeFormatW(lcid, NULL, @st, wszMask, wszDateStr, SIZEOF(wszDateStr))
   RETURN wszDateStr
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a CFileTime object to a string.
' This form formats the value by using the format string which contains special formatting
' codes that are preceded by a percent sign (%), as in printf.
' For more information about the formatting codes, see strftime, wcsftime in the Run-Time
' Library Reference: https://msdn.microsoft.com/en-us/library/fe06s4ak.aspx
' Example: print ct.Format("%A, %B %d, %Y %H:%M:%S")
' ========================================================================================
PRIVATE FUNCTION CPowerTime.Format (BYREF wszFmt AS WSTRING) AS CWSTR
   DIM cwsOut AS CWSTR
   IF LEN(wszFmt) = 0 THEN RETURN cwsOut
   cwsOut = STRING(128, CHR(0))
   DIM st AS SYSTEMTIME = this.GetAsSystemTime
   DIM tmTemp AS tm
   tmTemp.tm_wday = st.wDayOfWeek
   tmTemp.tm_min = st.wMinute
   tmTemp.tm_sec = st.wSecond
   tmTemp.tm_mon = st.wMonth - 1
   tmTemp.tm_mday = st.wDay
   tmTemp.tm_hour = st.wHour
   tmTemp.tm_year = st.wYear - 1900
   wcsftime(cwsOut.vptr, 128, @wszFmt, @tmTemp)
   RETURN cwsOut
END FUNCTION
' ========================================================================================

END NAMESPACE

' ########################################################################################
'                                *** Global operators ***
' ########################################################################################

USING Afx

' ========================================================================================
' Comparison operators
' ========================================================================================
PRIVATE OPERATOR = (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() = dt2.GetFileTime()
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <> (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() <> dt2.GetFileTime()
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR < (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() < dt2.GetFileTime()
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR > (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() > dt2.GetFileTime()
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR <= (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() <= dt2.GetFileTime()
END OPERATOR
' ========================================================================================
' ========================================================================================
PRIVATE OPERATOR >= (BYREF dt1 AS CPowerTime, BYREF dt2 AS CPowerTime) AS BOOLEAN
   RETURN dt1.GetFileTime() >= dt2.GetFileTime()
END OPERATOR
' ========================================================================================
