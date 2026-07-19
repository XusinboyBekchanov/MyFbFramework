''
'' Regex.bas
'' Regular expressions support for MyFbFramework
''
'' Unicode-only (WString / UString). Three pluggable backends, selected at
'' compile time -- see Regex.bi for the selection rules and link flags.
''
'' All of Match / Matches / Replace / ReplaceFirst / Split / IsMatch are
'' implemented once, in terms of Regex.EngineFindNext(), which is the only
'' function each backend has to provide. EngineFindNext always works in
'' *character* offsets into the caller's WString/UString -- backends that
'' internally operate on UTF-8 (PCRE2, GRegex) convert byte offsets back to
'' char offsets via the framework's ToUtf8()/FromUtf8() helpers so callers
'' never see a UTF-8 byte offset.
''

#include once "Regex.bi"

#ifdef __USE_PCRE2__
	#define PCRE2_CODE_UNIT_WIDTH 8
	#include once "pcre2.bi"
#endif

Namespace My.Sys.Text

	'' -------------------------------------------------------------
	'' Shared UTF-8 <-> WString char-offset helpers.
	'' Used by the PCRE2 and GRegex backends (both operate on UTF-8).
	'' Not used by the Windows/COM backend, which works natively on
	'' UTF-16 WStrings and needs no such conversion.
	'' -------------------------------------------------------------

#if (defined(__USE_PCRE2__)) Or (Not defined(__USE_WINAPI__))

	'' How many WString characters does the first ByteLen bytes of Utf8Bytes
	'' decode to? Utf8Bytes must be sliced at a UTF-8 character boundary
	'' (true for all offsets PCRE2/GRegex hand back to us).
	Private Function Utf8ByteLenToCharIndex(ByRef Utf8Bytes As String, ByVal ByteLen As Integer) As Integer
		If ByteLen <= 0 Then Return 0
		Dim As String prefix = Left(Utf8Bytes, ByteLen)
		Dim As WString Ptr w = FromUtf8(StrPtr(prefix))
		Dim As Integer n = 0
		If w <> 0 Then
			n = Len(*w)
			Deallocate(w)
		End If
		Return n
	End Function

	'' Inverse: how many UTF-8 bytes does the first CharIndex WString
	'' characters of Text encode to?
	Private Function CharIndexToUtf8ByteOffset(ByRef Text As Const WString, ByVal CharIndex As Integer) As Integer
		If CharIndex <= 0 Then Return 0
		Dim As UString prefix = Left(Text, CharIndex)
		Return Len(ToUtf8(prefix))
	End Function

#endif

	'' -------------------------------------------------------------
	'' Backend: PCRE2 (8-bit library, UTF-8 mode) -- used whenever
	'' __USE_PCRE2__ is defined, regardless of platform.
	'' -------------------------------------------------------------
#ifdef __USE_PCRE2__
	'Const PCRE2_ZERO_TERMINATED As UInteger = &hFFFFFFFF
	'Const PCRE2_UNSET As UInteger = &hFFFFFFFF
'
	'Const PCRE2_CASELESS  As ULong = &h00000008
	'Const PCRE2_MULTILINE As ULong = &h00000400
	'Const PCRE2_DOTALL    As ULong = &h00000020
	'Const PCRE2_EXTENDED  As ULong = &h00000080
	'Const PCRE2_UTF       As ULong = &h00080000 '' treat subject/pattern as UTF-8
	'Const PCRE2_UCP       As ULong = &h00020000 '' \d \w \s etc. honor Unicode properties
'
	'Extern "C"
	'	Declare Function pcre2_compile_8 Alias "pcre2_compile_8" _
	'		(ByVal pattern As Const ZString Ptr, ByVal length As UInteger, ByVal options As ULong, _
	'		 ByRef errorcode As Long, ByRef erroroffset As UInteger, ByVal ccontext As Any Ptr) As Any Ptr
'
	'	Declare Sub pcre2_code_free_8 Alias "pcre2_code_free_8" (ByVal code As Any Ptr)
'
	'	Declare Function pcre2_match_data_create_from_pattern_8 Alias "pcre2_match_data_create_from_pattern_8" _
	'		(ByVal code As Any Ptr, ByVal gcontext As Any Ptr) As Any Ptr
'
	'	Declare Sub pcre2_match_data_free_8 Alias "pcre2_match_data_free_8" (ByVal match_data As Any Ptr)
'
	'	Declare Function pcre2_match_8 Alias "pcre2_match_8" _
	'		(ByVal code As Any Ptr, ByVal subject As Const ZString Ptr, ByVal length As UInteger, _
	'		 ByVal startoffset As UInteger, ByVal options As ULong, ByVal match_data As Any Ptr, _
	'		 ByVal mcontext As Any Ptr) As Long
'
	'	Declare Function pcre2_get_ovector_pointer_8 Alias "pcre2_get_ovector_pointer_8" (ByVal match_data As Any Ptr) As UInteger Ptr
'
	'	Declare Function pcre2_get_error_message_8 Alias "pcre2_get_error_message_8" _
	'		(ByVal errorcode As Long, ByVal buffer As ZString Ptr, ByVal bufflen As UInteger) As Long
	'End Extern

	Private Function OptionsToPcre2(ByVal Options As RegexOptions) As ULong
		Dim As ULong flags = PCRE2_UTF Or PCRE2_UCP
		If (Options And reIgnoreCase)    Then flags Or= PCRE2_CASELESS
		If (Options And reMultiline)     Then flags Or= PCRE2_MULTILINE
		If (Options And reDotMatchesAll) Then flags Or= PCRE2_DOTALL
		If (Options And reExtended)      Then flags Or= PCRE2_EXTENDED
		Return flags
	End Function

	Private Sub Regex.FreeCompiled()
		If _Compiled <> NULL Then
			pcre2_code_free_8(_Compiled)
			_Compiled = NULL
		End If
	End Sub

	Private Sub Regex.Compile()
		FreeCompiled()

		Dim As String pat8 = ToUtf8(_Pattern)
		Dim As Long errCode
		Dim As UInteger errOffset
		Dim As ULong flags = OptionsToPcre2(_Options)

		_Compiled = pcre2_compile_8(StrPtr(pat8), Len(pat8), flags, @errCode, @errOffset, NULL)

		If _Compiled = NULL Then
			_Valid = False
			Dim As ZString * 256 buf
			pcre2_get_error_message_8(errCode, @buf, 256)
			_LastError = "Regex compile error at byte offset " & errOffset & ": " & buf
		Else
			_Valid = True
			_LastError = ""
		End If
	End Sub

	Private Function Regex.EngineFindNext(ByRef Text As Const WString, ByVal StartAt As Integer, ByRef OutMatch As RegexMatch) As Boolean
		OutMatch.Success = False
		If _Valid = False Then Return False

		Dim As String subj8 = ToUtf8(*Cast(WString Ptr, @Text))
		Dim As UInteger byteStart = CharIndexToUtf8ByteOffset(Text, StartAt)

		Dim As Any Ptr matchData = pcre2_match_data_create_from_pattern_8(_Compiled, NULL)
		Dim As Long rc = pcre2_match_8(_Compiled, StrPtr(subj8), Len(subj8), byteStart, 0, matchData, NULL)

		If rc < 0 Then
			pcre2_match_data_free_8(matchData)
			Return False
		End If

		Dim As UInteger Ptr ovector = pcre2_get_ovector_pointer_8(matchData)
		Dim As Integer groupCount = IIf(rc > 0, rc, 1)

		ReDim OutMatch.Groups(0 To groupCount - 1)

		For i As Integer = 0 To groupCount - 1
			Dim As UInteger sOff = ovector[2 * i]
			Dim As UInteger eOff = ovector[2 * i + 1]
			If sOff = PCRE2_UNSET Then
				OutMatch.Groups(i).Index  = -1
				OutMatch.Groups(i).Length = -1
				OutMatch.Groups(i).Value  = ""
			Else
				Dim As Integer cStart = Utf8ByteLenToCharIndex(subj8, sOff)
				Dim As Integer cEnd   = Utf8ByteLenToCharIndex(subj8, eOff)
				OutMatch.Groups(i).Index  = cStart
				OutMatch.Groups(i).Length = cEnd - cStart
				OutMatch.Groups(i).Value  = Mid(Text, cStart + 1, cEnd - cStart)
			End If
		Next

		pcre2_match_data_free_8(matchData)

		OutMatch.Success = True
		OutMatch.Value  = OutMatch.Groups(0).Value
		OutMatch.Index  = OutMatch.Groups(0).Index
		OutMatch.Length = OutMatch.Groups(0).Length
		Return True
	End Function

#elseif defined(__USE_WINAPI__)

	'#include once "windows.bi"
	'#include once "win/ole2.bi"

	'' fbc's built-in windows.bi IDispatch is a plain "lpVtbl Ptr" struct,
	'' not an Object-extending class, so Declare Abstract can't be layered
	'' directly on top of it (that's the "UDT does not extend OBJECT"
	'' error). We reserve the same vtable slots ourselves via a small
	'' Object-extending IUnknown/IDispatch chain -- exact same trick used
	'' in various FreeBASIC/COM interop write-ups -- and build IRegExp2 &
	'' friends on top of *that*.
	Type RegexIUnknown Extends Object
		Declare Abstract Function QueryInterface(ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
		Declare Abstract Function AddRef() As ULong
		Declare Abstract Function Release() As ULong
	End Type

	Type RegexIDispatch Extends RegexIUnknown
		Declare Abstract Function GetTypeInfoCount(ByVal pctinfo As UInteger Ptr) As HRESULT
		Declare Abstract Function GetTypeInfo(ByVal iTInfo As UInteger, ByVal lcid As ULong, ByVal ppTInfo As Any Ptr Ptr) As HRESULT
		Declare Abstract Function GetIDsOfNames(ByVal riid As Const GUID Ptr, ByVal rgszNames As WString Ptr Ptr, ByVal cNames As UInteger, ByVal lcid As ULong, ByVal rgDispId As Long Ptr) As HRESULT
		Declare Abstract Function Invoke(ByVal dispIdMember As Long, ByVal riid As Const GUID Ptr, ByVal lcid As ULong, ByVal wFlags As UShort, ByVal pDispParams As Any Ptr, ByVal pVarResult As Any Ptr, ByVal pExcepInfo As Any Ptr, ByVal puArgErr As UInteger Ptr) As HRESULT
	End Type

	'' IRegExp2 -- {3F4DACB0-160D-11D2-A8E9-00104B365C9F}
	Type IRegExp2 Extends RegexIDispatch
		Declare Abstract Function get_Pattern(ByVal pRetVal As BSTR Ptr) As HRESULT
		Declare Abstract Function put_Pattern(ByVal newVal As BSTR) As HRESULT
		Declare Abstract Function get_IgnoreCase(ByVal pRetVal As VARIANT_BOOL Ptr) As HRESULT
		Declare Abstract Function put_IgnoreCase(ByVal newVal As VARIANT_BOOL) As HRESULT
		Declare Abstract Function get_Global(ByVal pRetVal As VARIANT_BOOL Ptr) As HRESULT
		Declare Abstract Function put_Global(ByVal newVal As VARIANT_BOOL) As HRESULT
		Declare Abstract Function get_Multiline(ByVal pRetVal As VARIANT_BOOL Ptr) As HRESULT
		Declare Abstract Function put_Multiline(ByVal newVal As VARIANT_BOOL) As HRESULT
		Declare Abstract Function Execute(ByVal sourceString As BSTR, ByVal ppMatches As RegexIDispatch Ptr Ptr) As HRESULT
		Declare Abstract Function Test(ByVal sourceString As BSTR, ByVal pRetVal As VARIANT_BOOL Ptr) As HRESULT
		Declare Abstract Function Replace(ByVal sourceString As BSTR, ByVal replaceVar As VARIANT, ByVal pRetVal As BSTR Ptr) As HRESULT
	End Type

	'' IMatch2 -- {3F4DACB1-160D-11D2-A8E9-00104B365C9F}
	Type IMatch2 Extends RegexIDispatch
		Declare Abstract Function get_Value(ByVal pRetVal As BSTR Ptr) As HRESULT
		Declare Abstract Function get_FirstIndex(ByVal pRetVal As Long Ptr) As HRESULT
		Declare Abstract Function get_Length(ByVal pRetVal As Long Ptr) As HRESULT
		Declare Abstract Function get_SubMatches(ByVal pRetVal As RegexIDispatch Ptr Ptr) As HRESULT
	End Type

	'' IMatchCollection2 -- {3F4DACB2-160D-11D2-A8E9-00104B365C9F}
	Type IMatchCollection2 Extends RegexIDispatch
		Declare Abstract Function get_Item(ByVal index As Long, ByVal pRetVal As RegexIDispatch Ptr Ptr) As HRESULT
		Declare Abstract Function get_Count(ByVal pRetVal As Long Ptr) As HRESULT
		Declare Abstract Function get__NewEnum(ByVal pRetVal As Any Ptr Ptr) As HRESULT
	End Type

	'' ISubMatches -- {3F4DACB3-160D-11D2-A8E9-00104B365C9F}
	Type ISubMatches Extends RegexIDispatch
		Declare Abstract Function get_Item(ByVal index As Long, ByVal pRetVal As VARIANT Ptr) As HRESULT
		Declare Abstract Function get_Count(ByVal pRetVal As Long Ptr) As HRESULT
		Declare Abstract Function get__NewEnum(ByVal pRetVal As Any Ptr Ptr) As HRESULT
	End Type

	Dim Shared As Boolean gRegexComInitialized = False

	Private Sub EnsureComInitialized()
		If gRegexComInitialized = False Then
			CoInitialize(NULL)
			gRegexComInitialized = True
		End If
	End Sub

	Private Sub Regex.FreeCompiled()
		If _Compiled <> NULL Then
			Dim As IRegExp2 Ptr re = _Compiled
			re->Release()
			_Compiled = NULL
		End If
	End Sub

	Private Sub Regex.Compile()
		FreeCompiled()
		EnsureComInitialized()

		'' CLSID_RegExp / IID_IRegExp2, from the public VBScript_RegExp_55 type library.
		Dim As CLSID clsid = Type(&h3F4DACA4, &h160D, &h11D2, {&hA8, &hE9, &h00, &h10, &h4B, &h36, &h5C, &h9F})
		Dim As IID   iid   = Type(&h3F4DACB0, &h160D, &h11D2, {&hA8, &hE9, &h00, &h10, &h4B, &h36, &h5C, &h9F})

		Dim As IRegExp2 Ptr re = NULL
		If FAILED(CoCreateInstance(@clsid, NULL, CLSCTX_INPROC_SERVER, @iid, Cast(Any Ptr Ptr, @re))) Then
			_Valid = False
			_LastError = "Could not create the VBScript.RegExp (IRegExp2) COM object"
			Return
		End If

		'' _Pattern is a UString; its m_Data field is the underlying WString Ptr buffer.
		Dim As BSTR bstrPattern = SysAllocString(_Pattern.m_Data)
		re->put_Pattern(bstrPattern)
		SysFreeString(bstrPattern)
		re->put_IgnoreCase(IIf((_Options And reIgnoreCase) <> 0, -1, 0))
		re->put_Global(-1)
		re->put_Multiline(IIf((_Options And reMultiline) <> 0, -1, 0))

		'' NOTE: IRegExp2 has no equivalent of reExtended / reDotMatchesAll;
		'' those two flags are silently ignored on this backend.

		_Compiled = re
		_Valid = True
		_LastError = ""
	End Sub

	Private Function Regex.EngineFindNext(ByRef Text As Const WString, ByVal StartAt As Integer, ByRef OutMatch As RegexMatch) As Boolean
		OutMatch.Success = False
		If _Valid = False OrElse _Compiled = NULL Then Return False
		If StartAt >= Len(Text) Then Return False

		Dim As IRegExp2 Ptr re = _Compiled

		'' IRegExp2.Execute always scans from the start of the string it is
		'' given, so we feed it the remaining tail and shift offsets back by
		'' StartAt afterwards.
		Dim As UString remainder = Mid(Text, StartAt + 1)
		Dim As BSTR bstrSrc = SysAllocString(remainder.m_Data)

		'' The Matches/Match/SubMatches objects VBScript.RegExp hands back
		'' each implement exactly one dual interface, so the IDispatch*
		'' pointer these methods return out is ALREADY an
		'' IMatchCollection2*/IMatch2*/ISubMatches* -- no QueryInterface
		'' needed, the same trick AfxNova/WinFBX's CRegExp.inc relies on.
		Dim As IMatchCollection2 Ptr matches_ = NULL
		Dim As HRESULT hr = re->Execute(bstrSrc, Cast(RegexIDispatch Ptr Ptr, @matches_))
		SysFreeString(bstrSrc)
		If FAILED(hr) OrElse matches_ = NULL Then Return False

		Dim As Long count = 0
		matches_->get_Count(@count)
		If count < 1 Then
			matches_->Release()
			Return False
		End If

		Dim As IMatch2 Ptr m = NULL
		hr = matches_->get_Item(0, Cast(RegexIDispatch Ptr Ptr, @m))
		matches_->Release()
		If FAILED(hr) OrElse m = NULL Then Return False

		Dim As BSTR bstrValue = NULL
		Dim As Long firstIndex = 0
		Dim As Long matchLen = 0
		m->get_Value(@bstrValue)
		m->get_FirstIndex(@firstIndex)
		m->get_Length(@matchLen)

		ReDim OutMatch.Groups(0 To 0)
		If bstrValue <> NULL Then
			OutMatch.Groups(0).Value = *Cast(WString Ptr, bstrValue)
		Else
			OutMatch.Groups(0).Value = ""
		End If
		OutMatch.Groups(0).Index  = StartAt + firstIndex
		OutMatch.Groups(0).Length = matchLen
		If bstrValue <> NULL Then SysFreeString(bstrValue)

		'' SubMatches: IRegExp2 exposes only the captured text, not offsets,
		'' so Index/Length for groups beyond 0 are always -1 (not tracked).
		Dim As ISubMatches Ptr subs = NULL
		m->get_SubMatches(Cast(RegexIDispatch Ptr Ptr, @subs))
		m->Release()

		If subs <> NULL Then
			Dim As Long subCount = 0
			subs->get_Count(@subCount)
			If subCount > 0 Then
				ReDim Preserve OutMatch.Groups(0 To subCount)
				For i As Long = 0 To subCount - 1
					Dim As VARIANT v
					VariantInit(@v)
					subs->get_Item(i, @v)
					If v.vt = VT_BSTR Then
						OutMatch.Groups(i + 1).Value = *Cast(WString Ptr, v.bstrVal)
					Else
						OutMatch.Groups(i + 1).Value = ""
					End If
					OutMatch.Groups(i + 1).Index  = -1
					OutMatch.Groups(i + 1).Length = -1
					VariantClear(@v)
				Next
			End If
			subs->Release()
		End If

		OutMatch.Success = True
		OutMatch.Value  = OutMatch.Groups(0).Value
		OutMatch.Index  = OutMatch.Groups(0).Index
		OutMatch.Length = OutMatch.Groups(0).Length
		Return True
	End Function

	'' -------------------------------------------------------------
	'' Backend: Linux native -- GLib's GRegex (mff already links GTK/GLib
	'' on Linux via __USE_GTK__, so this adds no new dependency there).
	'' -------------------------------------------------------------
#else

	Type GErrorStruct
		domain As UInteger
		code As Long
		message As ZString Ptr
	End Type

	Const G_REGEX_CASELESS  As Long = 1 Shl 0
	Const G_REGEX_MULTILINE As Long = 1 Shl 1
	Const G_REGEX_DOTALL    As Long = 1 Shl 2
	Const G_REGEX_EXTENDED  As Long = 1 Shl 3

	Extern "C"
		Declare Function g_regex_new Alias "g_regex_new" _
			(ByVal pattern As Const ZString Ptr, ByVal compile_options As Long, ByVal match_options As Long, ByVal error As Any Ptr Ptr) As Any Ptr
		Declare Sub g_regex_unref Alias "g_regex_unref" (ByVal regex As Any Ptr)

		Declare Function g_regex_match_full Alias "g_regex_match_full" _
			(ByVal regex As Any Ptr, ByVal str As Const ZString Ptr, ByVal str_len As Long, ByVal start_position As Long, _
			 ByVal match_options As Long, ByVal match_info As Any Ptr Ptr, ByVal error As Any Ptr Ptr) As Long

		Declare Function g_match_info_get_match_count Alias "g_match_info_get_match_count" (ByVal match_info As Any Ptr) As Long
		Declare Function g_match_info_fetch_pos Alias "g_match_info_fetch_pos" _
			(ByVal match_info As Any Ptr, ByVal match_num As Long, ByRef start_pos As Long, ByRef end_pos As Long) As Long
		Declare Sub g_match_info_free Alias "g_match_info_free" (ByVal match_info As Any Ptr)

		Declare Sub g_error_free Alias "g_error_free" (ByVal error As Any Ptr)
	End Extern

	Private Function OptionsToGRegex(ByVal Options As RegexOptions) As Long
		Dim As Long flags = 0
		If (Options And reIgnoreCase)    Then flags Or= G_REGEX_CASELESS
		If (Options And reMultiline)     Then flags Or= G_REGEX_MULTILINE
		If (Options And reDotMatchesAll) Then flags Or= G_REGEX_DOTALL
		If (Options And reExtended)      Then flags Or= G_REGEX_EXTENDED
		Return flags
	End Function

	Private Sub Regex.FreeCompiled()
		If _Compiled <> NULL Then
			g_regex_unref(_Compiled)
			_Compiled = NULL
		End If
	End Sub

	Private Sub Regex.Compile()
		FreeCompiled()

		Dim As String pat8 = ToUtf8(_Pattern)
		Dim As Long flags = OptionsToGRegex(_Options)
		Dim As Any Ptr err_ = NULL

		_Compiled = g_regex_new(StrPtr(pat8), flags, 0, @err_)

		If _Compiled = NULL Then
			_Valid = False
			If err_ <> NULL Then
				Dim As GErrorStruct Ptr ge = err_
				_LastError = "Regex compile error: " & ZGet(ge->message)
				g_error_free(err_)
			Else
				_LastError = "Regex compile error (unknown)"
			End If
		Else
			_Valid = True
			_LastError = ""
		End If
	End Sub

	Private Function Regex.EngineFindNext(ByRef Text As Const WString, ByVal StartAt As Integer, ByRef OutMatch As RegexMatch) As Boolean
		OutMatch.Success = False
		If _Valid = False OrElse _Compiled = NULL Then Return False

		Dim As String subj8 = ToUtf8(*Cast(WString Ptr, @Text))
		Dim As Long byteStart = CharIndexToUtf8ByteOffset(Text, StartAt)

		Dim As Any Ptr matchInfo = NULL
		Dim As Long ok = g_regex_match_full(_Compiled, StrPtr(subj8), Len(subj8), byteStart, 0, @matchInfo, NULL)

		If ok = 0 Then
			If matchInfo <> NULL Then g_match_info_free(matchInfo)
			Return False
		End If

		Dim As Long groupCount = g_match_info_get_match_count(matchInfo)
		If groupCount < 1 Then groupCount = 1
		ReDim OutMatch.Groups(0 To groupCount - 1)

		For i As Long = 0 To groupCount - 1
			Dim As Long sOff, eOff
			Dim As Long got = g_match_info_fetch_pos(matchInfo, i, sOff, eOff)
			If got = 0 OrElse sOff < 0 Then
				OutMatch.Groups(i).Index  = -1
				OutMatch.Groups(i).Length = -1
				OutMatch.Groups(i).Value  = ""
			Else
				Dim As Integer cStart = Utf8ByteLenToCharIndex(subj8, sOff)
				Dim As Integer cEnd   = Utf8ByteLenToCharIndex(subj8, eOff)
				OutMatch.Groups(i).Index  = cStart
				OutMatch.Groups(i).Length = cEnd - cStart
				OutMatch.Groups(i).Value  = Mid(Text, cStart + 1, cEnd - cStart)
			End If
		Next

		g_match_info_free(matchInfo)

		OutMatch.Success = True
		OutMatch.Value  = OutMatch.Groups(0).Value
		OutMatch.Index  = OutMatch.Groups(0).Index
		OutMatch.Length = OutMatch.Groups(0).Length
		Return True
	End Function

#endif

	'' -------------------------------------------------------------
	'' Shared, engine-agnostic implementation. Every function below is
	'' written once, on top of Regex.EngineFindNext(), regardless of
	'' which backend was selected above.
	''
	'' NOTE ON STRING MIXING: WString and UString are different types with
	'' no automatic implicit conversion between them in every context (in
	'' particular, `Return someWString` from a UString-returning Function,
	'' and `uStringVar &= someWString`, do not reliably resolve on all fbc
	'' versions). So every place below that needs to combine a raw WString
	'' parameter (Text/Replacement) with a UString first copies it into a
	'' local `Dim As UString`, which *does* work (it goes through UString's
	'' Let-from-WString assignment), and only ever concatenates/returns
	'' UString-to-UString after that.
	'' -------------------------------------------------------------

	Constructor Regex()
		_Compiled = NULL
		_Valid = False
	End Constructor

	Constructor Regex(ByRef NewPattern As Const WString, ByVal Options As RegexOptions = reNone)
		_Compiled = NULL
		_Valid = False
		SetPattern(NewPattern, Options)
	End Constructor

	Destructor Regex()
		FreeCompiled()
	End Destructor

	Sub Regex.SetPattern(ByRef NewPattern As Const WString, ByVal Options As RegexOptions = reNone)
		_Pattern = NewPattern
		_Options = Options
		Compile()
	End Sub

	Property Regex.Pattern() As UString
		Return _Pattern
	End Property

	Property Regex.Pattern(ByRef Value As Const WString)
		SetPattern(Value, _Options)
	End Property

	Function Regex.IsValid() As Boolean
		Return _Valid
	End Function

	Function Regex.LastError() As UString
		Return _LastError
	End Function

	Function Regex.IsMatch(ByRef Text As Const WString) As Boolean
		Return IsMatch(Text, 0)
	End Function

	Function Regex.IsMatch(ByRef Text As Const WString, ByVal StartAt As Integer) As Boolean
		Dim tmp As RegexMatch
		Return EngineFindNext(Text, StartAt, tmp)
	End Function

	Function Regex.Match(ByRef Text As Const WString) As RegexMatch
		Return Match(Text, 0)
	End Function

	Function Regex.Match(ByRef Text As Const WString, ByVal StartAt As Integer) As RegexMatch
		Dim result As RegexMatch
		EngineFindNext(Text, StartAt, result)
		Return result
	End Function

	Function Regex.Matches(ByRef Text As Const WString) As RegexMatch Ptr
		Erase _LastMatches
		If _Valid = False Then Return NULL

		Dim As Integer pos = 0
		Dim As Integer textLen = Len(Text)
		Dim As Integer count = 0

		Do While pos <= textLen
			Dim m As RegexMatch
			If EngineFindNext(Text, pos, m) = False Then Exit Do

			ReDim Preserve _LastMatches(0 To count)
			_LastMatches(count) = m
			count += 1

			If m.Length <= 0 Then
				pos = m.Index + 1 '' avoid an infinite loop on zero-length matches
			Else
				pos = m.Index + m.Length
			End If
		Loop

		If count = 0 Then Return NULL
		Return @_LastMatches(0)
	End Function

	Function Regex.MatchCount() As Integer
		Return UBound(_LastMatches) + 1
	End Function

	Function Regex.ReplaceFirst(ByRef Text As Const WString, ByRef Replacement As Const WString) As UString
		Dim As UString textU = Text
		If _Valid = False Then Return textU

		Dim m As RegexMatch
		If EngineFindNext(Text, 0, m) = False Then Return textU

		Dim As UString resultU = Left(Text, m.Index) & Replacement & Mid(Text, m.Index + m.Length + 1)
		Return resultU
	End Function

	Function Regex.Replace(ByRef Text As Const WString, ByRef Replacement As Const WString) As UString
		Dim As UString textU = Text
		If _Valid = False Then Return textU

		Dim As UString replacementU = Replacement
		Dim As UString result = ""
		Dim As Integer pos = 0
		Dim As Integer textLen = Len(Text)

		Do While pos <= textLen
			Dim m As RegexMatch
			If EngineFindNext(Text, pos, m) = False Then
				Dim As UString tail = Mid(Text, pos + 1)
				result &= tail
				Exit Do
			End If

			Dim As UString beforeMatch = Mid(Text, pos + 1, m.Index - pos)
			result &= beforeMatch
			result &= replacementU

			If m.Length <= 0 Then
				If m.Index < textLen Then
					Dim As UString oneChar = Mid(Text, m.Index + 1, 1)
					result &= oneChar
				End If
				pos = m.Index + 1
			Else
				pos = m.Index + m.Length
			End If
		Loop

		Return result
	End Function

	Function Regex.Split(ByRef Text As Const WString) As UString Ptr
		Erase _LastSplit

		If _Valid = False Then
			ReDim _LastSplit(0 To 0)
			_LastSplit(0) = Text
			Return @_LastSplit(0)
		End If

		Dim As Integer pos = 0
		Dim As Integer lastEnd = 0
		Dim As Integer count = 0
		Dim As Integer textLen = Len(Text)

		Do While pos <= textLen
			Dim m As RegexMatch
			If EngineFindNext(Text, pos, m) = False Then Exit Do

			ReDim Preserve _LastSplit(0 To count)
			_LastSplit(count) = Mid(Text, lastEnd + 1, m.Index - lastEnd)
			count += 1
			lastEnd = m.Index + m.Length

			If m.Length <= 0 Then
				pos = m.Index + 1
			Else
				pos = m.Index + m.Length
			End If
		Loop

		ReDim Preserve _LastSplit(0 To count)
		_LastSplit(count) = Mid(Text, lastEnd + 1)

		Return @_LastSplit(0)
	End Function

	Function Regex.SplitCount() As Integer
		Return UBound(_LastSplit) + 1
	End Function

End Namespace
