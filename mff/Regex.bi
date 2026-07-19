''
'' Regex.bi
'' Regular expressions support for MyFbFramework
''
'' Unicode-only API: works with WString / UString. There is no ANSI "String"
'' overload -- pass string literals or UString variables, both bind fine
'' because UString.Cast() returns the underlying buffer ByRef WString.
''
'' Backend selection (compile-time, no runtime dependency surprises):
''
''   __USE_PCRE2__ defined  -> PCRE2 (8-bit / UTF-8 mode) is used on any platform.
''                             Link:  Linux   -lpcre2-8
''                                    Windows  pcre2-8.dll / libpcre2-8.a
''
''   __USE_PCRE2__ NOT defined:
''       Windows -> the OS's own regex engine: VBScript.RegExp (IRegExp2) via
''                  COM/IDispatch late binding. No external dependency, ships
''                  with every Windows install (vbscript.dll).
''       Linux   -> GLib's GRegex, since mff already depends on GTK/GLib on
''                  Linux (__USE_GTK__). Link: `pkg-config --libs glib-2.0`
''                  (typically -lglib-2.0 -lgobject-2.0).
''
'' Usage example:
''
''   #include once "mff/Regex.bi"
''   Using My.Sys.Text
''
''   Dim re As Regex = Regex(!"\d+")
''   If re.IsMatch("abc 123 def") Then
''       Print re.Match("abc 123 def").Value    ' -> "123"
''   End If
''
''   Dim matches As RegexMatch Ptr = re.Matches("a1 b22 c333")
''   For i As Integer = 0 To re.MatchCount() - 1
''       Print matches[i].Value
''   Next
''
''   Print re.Replace("a1 b2", "#")              ' -> "a# b#"
''

#ifndef __MFF_REGEX_BI__
#define __MFF_REGEX_BI__

#include once "UString.bi"

Namespace My.Sys.Text

	'' Options that can be combined with Or
	Enum RegexOptions
		reNone           = 0
		reIgnoreCase     = 1
		reMultiline      = 2
		reDotMatchesAll  = 4  '' "." also matches newline (DOTALL)
		reExtended       = 8  '' ignore whitespace / allow comments in pattern
	End Enum

	'' A single captured group inside a match.
	'' NOTE: on the Windows COM backend, Index/Length are only meaningful for
	'' Groups(0) (the whole match); VBScript.RegExp does not expose offsets
	'' for individual capture groups, so Groups(i > 0).Index/.Length are -1.
	Type RegexGroup
		Value As UString
		Index As Integer   '' 0-based char offset into the subject WString, -1 if not tracked/captured
		Length As Integer  '' char length of the captured text, -1 if not tracked/captured
	End Type

	'' A single match result (Groups(0) is always the whole match)
	Type RegexMatch
		Value As UString
		Index As Integer
		Length As Integer
		Success As Boolean
		Groups(Any) As RegexGroup
	End Type

	Type Regex

		Public:
			Declare Constructor()
			Declare Constructor(ByRef Pattern As Const WString, ByVal Options As RegexOptions = reNone)
			Declare Destructor()

			Declare Sub SetPattern(ByRef Pattern As Const WString, ByVal Options As RegexOptions = reNone)

			Declare Function IsMatch(ByRef Text As Const WString) As Boolean
			Declare Function IsMatch(ByRef Text As Const WString, ByVal StartAt As Integer) As Boolean

			Declare Function Match(ByRef Text As Const WString) As RegexMatch
			Declare Function Match(ByRef Text As Const WString, ByVal StartAt As Integer) As RegexMatch

			Declare Function Matches(ByRef Text As Const WString) As RegexMatch Ptr
			Declare Function MatchCount() As Integer '' number of matches found by the last Matches() call

			Declare Function Replace(ByRef Text As Const WString, ByRef Replacement As Const WString) As UString
			Declare Function ReplaceFirst(ByRef Text As Const WString, ByRef Replacement As Const WString) As UString

			Declare Function Split(ByRef Text As Const WString) As UString Ptr
			Declare Function SplitCount() As Integer '' number of parts returned by the last Split() call

			Declare Function IsValid() As Boolean
			Declare Function LastError() As UString

			Declare Property Pattern() As UString
			Declare Property Pattern(ByRef Value As Const WString)

		Private:
			_Pattern As UString
			_Options As RegexOptions
			_Compiled As Any Ptr    '' backend-specific handle:
			                        ''   PCRE2   -> pcre2_code_8 Ptr
			                        ''   Windows -> IDispatch Ptr (VBScript.RegExp instance)
			                        ''   GRegex  -> GRegex Ptr
			_Valid As Boolean
			_LastError As UString
			_LastMatches(Any) As RegexMatch
			_LastSplit(Any) As UString

			Declare Sub Compile()
			Declare Sub FreeCompiled()

			'' Backend-specific match primitive. Every backend (PCRE2 / Windows /
			'' GRegex) implements this one function with the same contract:
			'' find the next match at-or-after char index StartAt in Text,
			'' fill OutMatch (char-indexed, relative to Text) and return
			'' True/False. All public methods (Match/Matches/Replace/Split/...)
			'' are implemented once, on top of this, so backends never
			'' duplicate the scanning/looping logic.
			Declare Function EngineFindNext(ByRef Text As Const WString, ByVal StartAt As Integer, ByRef OutMatch As RegexMatch) As Boolean

	End Type

End Namespace

#endif '' __MFF_REGEX_BI__

#include "Regex.bas"