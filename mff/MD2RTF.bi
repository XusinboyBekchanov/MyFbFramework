#include once "mff/WStringList.bi"

' RGB to RTF Color Table
Function RGBToRTF(ByVal r As Integer, ByVal g As Integer, ByVal b As Integer) As String
	Return "\red" & Str(r) & "\green" & Str(g) & "\blue" & Str(b) & ";"
End Function

' RTF Color Table to RGB (Input：\red255\green0\blue0;)
Function RTFToRGB(ByVal rtfColor As String) As Long
	Dim As Integer r, g, b
	Dim As Integer p1, p2, p3
	p1 = InStr(rtfColor, "\red")
	p2 = InStr(p1 + 1, rtfColor, "\")
	If p1 > 0 And p2 > p1 Then
		r = ValInt(Mid(rtfColor, p1 + 4, p2 - (p1 + 4)))
	End If
	p1 = InStr(rtfColor, "\green")
	p2 = InStr(p1 + 1, rtfColor, "\")
	If p1 > 0 And p2 > p1 Then
		g = ValInt(Mid(rtfColor, p1 + 6, p2 - (p1 + 6)))
	End If
	p1 = InStr(rtfColor, "\blue")
	p2 = InStr(p1 + 1, rtfColor, ";")
	If p1 > 0 And p2 > p1 Then
		b = ValInt(Mid(rtfColor, p1 + 5, p2 - (p1 + 5)))
	End If
	Return RGB(r, g, b)
End Function

' ==========================================
' Markdown Stream Converter
' ==========================================
Declare Sub UpdateRTB(ByRef tempChunk As WString = "")
Type MarkdownStreamConverter
	Private:
	Enum ParseState
		State_Normal
		State_PotentialTable
		State_InTable
		State_InCodeBlock
	End Enum
	Dim As ParseState m_State
	Dim As WString Ptr m_BufferPtr, m_TableBufferPtr
	Dim As Integer m_IC, m_TableColCount, m_TableColWIdth(Any)
	Dim As String m_DefaultStyle
	Dim As Boolean m_inListItem, m_inLineCode
	Dim As Integer m_Capacity, m_CapacityTable
Public:
	Dim As String RTFHeader, RTFFooter, RTFFontName
	Dim As WString Ptr RTFBodyPtr
	Dim As Integer ColorIndexBK, ColorIndexCodeBK, ColorIndexFore, RTFFontSizefs, ColorTableBorder
	Declare Constructor(ByRef iFontName As String = "Arial", ByVal iFontSize As Integer = 12, ByVal iForeColor As Integer = -1, ByRef colorTblStr As String = "")
	Declare Destructor()
	Declare Sub FeedChunk(ByRef chunk As WString)
	Declare Sub Flush()
	Declare Sub Initial(ByRef iFontName As String = "Arial", ByVal iFontSize As Integer = 12, ByVal iForeColor As Integer = -1, ByRef colorTblStr As String = "")
	Declare Sub ProcessLine(ByVal iLine As WString Ptr)
	Declare Function EscapeRTF(ByVal iTextPtr As WString Ptr) As WString Ptr
	Declare Function ProcessImage(ByRef imgLine As WString) As String
	Declare Function freeBasicToRTF(ByRef vbCode As WString) As WString Ptr
	Declare Function ProcessInlineStyles(ByVal iTextPtr As WString Ptr) As WString Ptr
	Declare Sub OutputNormalLine(ByVal iLinePtr As WString Ptr)
	Declare Sub OutputTableRow(ByVal iLinePtr As WString Ptr, ByVal isHead As Boolean = False, ByVal textColorIndex As Integer = 4)
End Type
Constructor MarkdownStreamConverter(ByRef iFontName As String = "Arial", ByVal iFontSize As Integer = 12, ByVal iForeColor As Integer = -1, ByRef colorTblStr As String = "")
	Initial(iFontName, iFontSize, iForeColor, colorTblStr)
End Constructor
Destructor MarkdownStreamConverter()
	If m_BufferPtr <> 0 Then _Deallocate(m_BufferPtr)
	If m_TableBufferPtr <> 0 Then _Deallocate(m_TableBufferPtr)
	If RTFBodyPtr <> 0 Then _Deallocate(RTFBodyPtr)
End Destructor

Sub MarkdownStreamConverter.Initial(ByRef iFontName As String = "Arial", ByVal iFontSize As Integer = 12, ByVal iForeColor As Integer = -1, ByRef colorTblStr As String = "")
	RTFFontName = iFontName
	RTFFontSizefs = iFontSize * 2
	ColorIndexFore = iForeColor
	ColorTableBorder = 4
	m_State = State_Normal
	m_IC = 0
	m_inLineCode = False
	m_inListItem = False
	If m_BufferPtr <> 0 Then _Deallocate(m_BufferPtr) : m_BufferPtr = 0
	If m_TableBufferPtr <> 0 Then _Deallocate(m_TableBufferPtr): m_TableBufferPtr = 0
	If RTFBodyPtr <> 0 Then _Deallocate(RTFBodyPtr) : RTFBodyPtr = 0
	If iForeColor < 0 Then
		ColorIndexFore = IIf(g_darkModeSupported AndAlso g_darkModeEnabled, 9, 0)
	Else
		ColorIndexFore = iForeColor
	End If
	ColorIndexBK = IIf(g_darkModeSupported AndAlso g_darkModeEnabled, 10, 9)
	Dim As String KeyWordColorStr, colorTblStrNew = colorTblStr
	For k As Integer = 1 To KeywordLists.Count - 1
		KeyWordColorStr &= RGBToRTF(GetRed(Keywords(k).Foreground), GetGreen(Keywords(k).Foreground), GetBlue(Keywords(k).Foreground))
	Next
	If colorTblStrNew = "" Then colorTblStrNew = _
	RGBToRTF(GetRed(NormalText.Foreground), GetGreen(NormalText.Foreground), GetBlue(NormalText.Foreground)) & _    '20
	RGBToRTF(GetRed(Strings.Foreground), GetGreen(Strings.Foreground), GetBlue(Strings.Foreground)) & _             '21
	RGBToRTF(GetRed(ColorMacros.Foreground), GetGreen(ColorMacros.Foreground), GetBlue(ColorMacros.Foreground)) & _ '22
	RGBToRTF(GetRed(Identifiers.Foreground), GetGreen(Identifiers.Foreground), GetBlue(Identifiers.Foreground)) & _ '23
	RGBToRTF(GetRed(RealNumbers.Foreground), GetGreen(RealNumbers.Foreground), GetBlue(RealNumbers.Foreground)) & _ '24
	RGBToRTF(GetRed(ColorProperties.Foreground), GetGreen(ColorProperties.Foreground), GetBlue(ColorProperties.Foreground)) & _ '25
	RGBToRTF(GetRed(ColorGlobalTypes.Foreground), GetGreen(ColorGlobalTypes.Foreground), GetBlue(ColorGlobalTypes.Foreground)) & _ '26
	RGBToRTF(GetRed(ColorGlobalEnums.Foreground), GetGreen(ColorGlobalEnums.Foreground), GetBlue(ColorGlobalEnums.Foreground)) & _ '27
	RGBToRTF(GetRed(ColorEnumMembers.Foreground), GetGreen(ColorEnumMembers.Foreground), GetBlue(ColorEnumMembers.Foreground)) & _ '28
	RGBToRTF(GetRed(ColorSharedVariables.Foreground), GetGreen(ColorSharedVariables.Foreground), GetBlue(ColorSharedVariables.Foreground)) & _ '29
	RGBToRTF(GetRed(ColorCommonVariables.Foreground), GetGreen(ColorCommonVariables.Foreground), GetBlue(ColorCommonVariables.Foreground)) & _ '30
	RGBToRTF(GetRed(ColorGlobalNamespaces.Foreground), GetGreen(ColorGlobalNamespaces.Foreground), GetBlue(ColorGlobalNamespaces.Foreground)) & _ '31
	RGBToRTF(GetRed(ColorComps.Foreground), GetGreen(ColorComps.Foreground), GetBlue(ColorComps.Foreground)) & _ '32
	RGBToRTF(GetRed(ColorGlobalFunctions.Foreground), GetGreen(ColorGlobalFunctions.Foreground), GetBlue(ColorGlobalFunctions.Foreground)) & _ '33
	RGBToRTF(GetRed(ColorDefines.Foreground), GetGreen(ColorDefines.Foreground), GetBlue(ColorDefines.Foreground)) & _ '34
	RGBToRTF(GetRed(ColorSubs.Foreground), GetGreen(ColorSubs.Foreground), GetBlue(ColorSubs.Foreground)) & _ '35
	KeyWordColorStr
	RTFHeader =  _
	"{\urtf1\ansi\deff0" & _
	"{\fonttbl{\f0\fnil\fcharset0 " & AIEditorFontName & ";}{\f1\fnil\fcharset204 Consolas;}}" & _
	"{\colortbl;" & _
	"\red0\green0\blue0;" & _       ' 1: Black (base text) Background color needs -1
	"\red255\green0\blue0;" & _     ' 2: Red
	"\red255\green128\blue0;" & _    ' 3: Orange
	"\red255\green255\blue0;" & _    ' 4: Yellow
	"\red0\green128\blue0;" & _     ' 5: Green
	"\red0\green0\blue255;" & _     ' 6: Blue
	"\red0\green150\blue240;" & _    ' 7: Indigo (actually using teal as substitute) 128
	"\red128\green0\blue128;" & _    ' 8: Purple
	"\red255\green255\blue255;" & _ ' 9: White (background)
	"\red48\green48\blue48;" & _    ' 10: Dark gray (background)
	"\red0\green200\blue200;" & _   ' 11: Teal (new)
	"\red128\green128\blue128;" & _ ' 12: Gray (new)
	"\red255\green0\blue255;" & _   ' 13: Pink (new)
	"\red0\green255\blue255;" & _     '14: 亮青 (补充代码高亮用)
	"\red150\green150\blue255;" & _   '15: 亮蓝 (补充代码高亮用)
	"\red0\green0\blue200;" & _       '16: 深蓝 (补充代码高亮用)
	"\red100\green100\blue255;" & _   '17: 中蓝 (补充代码高亮用)
	"\red0\green0\blue180;" & _       '18: 钴蓝 (补充代码高亮用)
	"\red0\green150\blue0;" & _       '19: 暗绿 (补充代码高亮用)
	colorTblStrNew & _
	"}" & _
	"\viewkind4\uc1\pard\lang2052\f0\fs" & RTFFontSizefs   ' 默认字体、字号
	RTFFooter = "}"
	'而 RTF 原生的透明背景/控件底色是通过 \ highlight0 实现的.RTF 的状态是持续性的，开启 \b 后必须手动用 \b0 关
	m_DefaultStyle = "\f0\fs" & RTFFontSizefs & "\cf" & ColorIndexFore & "\b0\highlight0"
End Sub

Sub MarkdownStreamConverter.FeedChunk(ByRef chunk As WString)
	WAdd(m_BufferPtr, chunk)
	If m_BufferPtr = 0 OrElse InStr(*m_BufferPtr, !"\n" ) < 1 Then
		UpdateRTB(chunk)
		Return
	End If
	If ColorIndexFore = 0 OrElse ColorIndexFore = 9 Then ColorIndexFore = IIf(g_darkModeSupported AndAlso g_darkModeEnabled, 9, 0)
	If ColorIndexBK = 10 OrElse ColorIndexBK = 9 Then ColorIndexBK = IIf(g_darkModeSupported AndAlso g_darkModeEnabled, 10, 9)
	Dim As WString Ptr Lines(), CurrentLinePtr
	Split(*m_BufferPtr, !"\n", Lines())
	Dim As Integer UboundCount = UBound(Lines)
	For i As Integer = 0 To UboundCount - 1
		' 检查是否为空行，空行在 Markdown 中用于分段和重置列表状态
		CurrentLinePtr = Lines(i)
		If Len(*CurrentLinePtr) > 3 AndAlso ((*CurrentLinePtr)[0] <> 32 OrElse (*CurrentLinePtr)[1] <> 32 OrElse (CurrentLinePtr)[2] <> 32) Then
			*CurrentLinePtr = RTrim(*CurrentLinePtr, Any !"\r ") ' 仅去除尾部回车和空格，保护行首空格
		Else
			*CurrentLinePtr = Trim(*CurrentLinePtr, !"\r ") ' 仅去除尾部的回车符
		End If
		If Len(*CurrentLinePtr) = 0 Then
			WAdd(RTFBodyPtr, m_DefaultStyle & "\li0\par" & Chr(10), , m_Capacity)
			m_inListItem = False ' 空行重置列表状态
			_Deallocate(CurrentLinePtr)
			Continue For
		End If
		Dim As WString Ptr EscapeRTFPtr
		EscapeRTFPtr = EscapeRTF(*CurrentLinePtr)
		_Deallocate(CurrentLinePtr)
		If EscapeRTFPtr = 0 Then Continue For
		ProcessLine(EscapeRTFPtr)
		_Deallocate(EscapeRTFPtr) : EscapeRTFPtr = 0
	Next
	_Deallocate(m_BufferPtr)
	m_BufferPtr = Lines(UboundCount)
	Erase Lines
	UpdateRTB()
End Sub

Sub MarkdownStreamConverter.Flush()
	If m_BufferPtr <> 0 AndAlso Len(*m_BufferPtr) > 0 Then
		ProcessLine(m_BufferPtr)
		WLet(m_BufferPtr, "")
		'If m_State = State_InTable OrElse m_State = State_PotentialTable Then
		'	m_State = State_Normal
		'End If
		UpdateRTB()
	End If
End Sub

' Helper function: RTF special character escaping
Function MarkdownStreamConverter.EscapeRTF(ByVal iTextPtr As WString Ptr) As WString Ptr
	If iTextPtr = 0 OrElse *iTextPtr = "" Then Return 0
	Dim As Integer Posi = 0, iLen = Len(*iTextPtr)
	If iLen < 1 Then Return 0
	' 预分配内存（按最大需求：每个字符最多6个转义字符）
	Dim As Integer bufferSize = iLen * 6 + 2
	Dim As String TmpStr
	Dim As WString Ptr ResultPtr = _Allocate(bufferSize * SizeOf(WString))     ' 预分配最大可能空间
	' 十六进制字符查表，避免在循环内使用 Hex() 产生字符串分配开销
	Dim As String hexChars = "0123456789ABCDEF"
	Dim As ULong ch
	If ResultPtr = 0 Then Return 0
	For i As Integer = 0 To iLen - 1
		If Posi >= bufferSize- 6 Then
			bufferSize *= 2
			ResultPtr = _Reallocate(ResultPtr, bufferSize * SizeOf(WString))
			If ResultPtr = 0 Then Return 0
		End If
		ch = (*iTextPtr)[i]
		Select Case ch
		Case 92, 123, 125, 126, 94  ' ASCII码值: \ { }   ^
			(*ResultPtr)[Posi] = 92
			(*ResultPtr)[Posi + 1] = ch
			Posi += 2
		Case 13  ' ASCII码值: Cr LF
			If i < iLen - 1 AndAlso (*iTextPtr)[i + 1] = 10 Then
				i += 1  ' 跳过后续的换行符 (LF)
			End If
			(*ResultPtr)[Posi] = 10
			Posi += 1
		Case 10  ' ASCII码值: Cr LF
			(*ResultPtr)[Posi] = 10
			Posi += 1
		Case 9  ' ASCII码值: TAB
			(*ResultPtr)[Posi] = 32
			(*ResultPtr)[Posi + 1] = 32
			(*ResultPtr)[Posi + 2] = 32
			(*ResultPtr)[Posi + 3] = 32
			Posi += 4
		Case 0 To 31: ' 控制字符 \uXXXX  TmpStr = Hex(ch, 4)
			(*ResultPtr)[Posi] = 92
			(*ResultPtr)[Posi + 1] = 117
			(*ResultPtr)[Posi + 2] = hexChars[(ch Shr 12) And 15]  'TmpStr[0]
			(*ResultPtr)[Posi + 3] = hexChars[(ch Shr 8) And 15]   'TmpStr[1]
			(*ResultPtr)[Posi + 4] = hexChars[(ch Shr 4) And 15]   'TmpStr[2]
			(*ResultPtr)[Posi + 5] = hexChars[ch And 15]           'TmpStr[3]
			Posi += 6
		Case Else
			(*ResultPtr)[Posi] = ch
			Posi += 1
		End Select
	Next
	(*ResultPtr)[Posi] = 0 ' 截取实际使用长度
	Return ResultPtr
End Function

' Main function: freeBasic code to RTF (with syntax highlighting)
Function MarkdownStreamConverter.freeBasicToRTF(ByRef LineText As WString) As WString Ptr
	Dim As WString Ptr rtfiText
	Dim As WString * 255 Matn, MatnLCase, MatnLCaseWithoutOldSymbol, MatnWithoutOldSymbol, OriginalCaseWord, TypeName, OldMatnLCase
	Dim As Integer L = Len(LineText)
	Dim As Boolean WithOldSymbol, bTypeAs, bKeyWord, bWithoutWith, bInAsm, TwoDots, OneDot, bQ
	Dim As Integer sc, t, u, r, q, j, QavsBoshi, MatnBoshi, IzohBoshi, OddiyMatnBoshi, tIndex, Capacity
	Dim As TypeElement Ptr te
	Dim As WStringList Ptr pkeywords
	Dim As WString Ptr PaddedLCasePtr, TrimmedLCasePtr
	WLet(PaddedLCasePtr, LCase(" " & LineText & " " ))
	If PaddedLCasePtr = 0 Then Return 0
	WLet(TrimmedLCasePtr, LCase(Trim(LineText, Any !"\t " )))
	If TrimmedLCasePtr = 0 Then
		_Deallocate(PaddedLCasePtr)
		Return 0
	End If
	bQ = False
	tIndex = -1 : j = 1
	IzohBoshi = 1
	QavsBoshi = 0
	MatnBoshi = 0
	Matn = ""
	
	Do While j <= L
		If m_IC = 0 AndAlso LineText[j - 1] = 34 Then  '""""
			bQ = Not bQ
			If bQ Then
				If OddiyMatnBoshi > 0 Then
					'OddiyMatnBoshi - 1, j - 1, NormalText
					WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j - OddiyMatnBoshi), , Capacity)
					OddiyMatnBoshi = 0
				End If
				QavsBoshi = j
			Else
				'QavsBoshi - 1, j, Strings
				WAdd(rtfiText, "\cf21 " & Mid(LineText, QavsBoshi, j - QavsBoshi + 1), , Capacity)
			End If
		ElseIf Not bQ Then
			If (LineText)[j - 1] = 47 AndAlso (LineText)[j] = 39 Then  '"/'"
				m_IC += 1
				If m_IC = 1 Then
					If OddiyMatnBoshi > 0 Then
						'OddiyMatnBoshi - 1, j - 1, NormalText
						WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j - OddiyMatnBoshi), , Capacity)
						OddiyMatnBoshi = 0
					End If
					IzohBoshi = j
				End If
				j = j + 1
			ElseIf m_IC > 0 AndAlso (LineText)[j - 1] = 39 AndAlso (LineText)[j] = 47 Then '"'/"
				m_IC -=  1
				j = j + 1
				If m_IC = 0 Then
					'IzohBoshi - 1, j, Comments
					WAdd(rtfiText, "\cf5 " & Mid(LineText, IzohBoshi, j - IzohBoshi + 1), , Capacity)
				End If
			ElseIf m_IC = 0 Then
				t = LineText[j - 1]
				u = LineText[j]
				If Mid(*PaddedLCasePtr, j, 5) = " rem " OrElse Mid(*PaddedLCasePtr, j, 6) = " @rem " OrElse Mid(*PaddedLCasePtr, j, 5) = !"\trem " Then
					If OddiyMatnBoshi > 0 Then
						'OddiyMatnBoshi - 1, j - 1, NormalText
						WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j -  OddiyMatnBoshi), , Capacity)
						OddiyMatnBoshi = 0
					End If
					'j - 1, L, Comments
					WAdd(rtfiText, "\cf5 " & Mid(LineText, j , L - j + 1), , Capacity)
					Exit Do
				ElseIf t >= 48 AndAlso t <= 57 OrElse t >= 65 AndAlso t <= 90 OrElse t >= 97 AndAlso t <= 122 OrElse t = 35 OrElse t = 36 OrElse t = 38 OrElse t = 95 Then
					If OddiyMatnBoshi > 0 Then
						'OddiyMatnBoshi - 1, j - 1, NormalText
						WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j -  OddiyMatnBoshi), , Capacity)
						OddiyMatnBoshi = 0
					End If
					If MatnBoshi = 0 Then MatnBoshi = j
					If Not (u >= 48 AndAlso u <= 57 OrElse u >= 65 AndAlso u <= 90 OrElse u >= 97 AndAlso u <= 122 OrElse u >= 127 OrElse u = 35 OrElse u = 36 OrElse u = 38 OrElse u = 95) Then
						Matn = Mid(LineText, MatnBoshi, j - MatnBoshi + 1)
						MatnLCase = LCase(Matn)
						If Trim(MatnLCase, Any !"\t ") = "" Then
							_Deallocate(PaddedLCasePtr)
							_Deallocate(TrimmedLCasePtr)
							Return 0
						End If
						If t = 35 OrElse t = 36 Then ' # or $
							MatnLCaseWithoutOldSymbol = Mid(MatnLCase, 2)
							MatnWithoutOldSymbol = Mid(Matn, 2)
							WithOldSymbol = True
						Else
							MatnLCaseWithoutOldSymbol = MatnLCase
							MatnWithoutOldSymbol = Matn
							WithOldSymbol = False
						End If
						bTypeAs = StartsWith(*TrimmedLCasePtr, "type ") AndAlso OldMatnLCase = "as"
						sc = 23 ' Identifiers
						OriginalCaseWord = "":   TypeName = ""
						If MatnBoshi > 1 Then
							r = LineText[MatnBoshi - 2]
							q = LineText[MatnBoshi - 3]
						ElseIf MatnBoshi > 0 Then
							r = LineText[MatnBoshi - 2]
							q = 0
						Else
							r = 0: q = 0
						End If
						
						pkeywords = 0
						
						bKeyWord = False
						tIndex  = -1
						bInAsm = (StartsWith(*TrimmedLCasePtr, "asm")) AndAlso CBool(MatnLCase <> "asm")
						If bInAsm Then
							tIndex = pkeywordsAsm->IndexOf(MatnLCase)
							If tIndex > -1 Then
								sc = 7 ' KeywordLists.IndexOfObject(pkeywordsAsm) ' Asm
								'OriginalCaseWord = pkeywordsAsm->Item(tIndex)
								bKeyWord = True
							End If
						End If
						TwoDots = CBool(r = 46 AndAlso q = 46)
						OneDot = False
						bWithoutWith = False
						
						If Not bInAsm Then
							If Not OneDot Then
								' Keywords
								If tIndex = -1 Then
									For k As Integer = 1 To KeywordLists.Count - 1
										pkeywords = KeywordLists.Object(k)
										tIndex = pkeywords->IndexOf(MatnLCase)
										If tIndex > -1 Then
											'OriginalCaseWord = pkeywords->Item(tIndex)
											sc = 35 + k ' Keywords(k)
											bKeyWord = True
											Exit For
										End If
										tIndex = -1
									Next
								End If
							Else
								
							End If
						End If
						
						If WithOldSymbol AndAlso Not bKeyWord Then MatnLCase = MatnLCaseWithoutOldSymbol
						If Not OneDot Then
							'Module
							If tIndex = -1 AndAlso OldMatnLCase <> "as" Then
								tIndex = pGlobalArgs->IndexOf(MatnLCase)
								If tIndex <> -1 Then
									te = pGlobalArgs->Object(tIndex)
									'OriginalCaseWord = pGlobalArgs->Item(tIndex)
									If te > 0 AndAlso SyntaxHighlightingIdentifiers Then
										Select Case te->ElementType
										Case E_EnumItem
											sc = 28 ' ColorEnumMembers
										Case E_CommonVariable
											sc = 30 ' ColorCommonVariables
										Case E_Constant
											sc = 20 ' ColorConstants
										Case E_SharedVariable
											sc = 29 ' ColorSharedVariables
										Case Else
											sc = 20 ' ColorLocalVariables
										End Select
									End If
								End If
							End If
							
							If Not bInAsm Then
								'Global
								If tIndex = -1 Then
									If bTypeAs Then tIndex = pComps->IndexOf(MatnLCase)
									If tIndex <> -1 Then
										If SyntaxHighlightingIdentifiers Then sc = 32 ' ColorComps
										'OriginalCaseWord = pComps->Item(tIndex)
									End If
								End If
								
								If tIndex = -1 Then
									If bTypeAs Then tIndex = pGlobalTypes->IndexOf(MatnLCase)
									If tIndex <> -1 Then
										If SyntaxHighlightingIdentifiers Then sc = 26 ' ColorGlobalTypes
										'OriginalCaseWord = pGlobalTypes->Item(tIndex)
									End If
								End If
								
								If tIndex = -1 Then
									If bTypeAs Then tIndex = pGlobalEnums->IndexOf(MatnLCase)
									If tIndex <> -1 Then
										If SyntaxHighlightingIdentifiers Then sc = 27 ' ColorGlobalEnums
										'OriginalCaseWord = pGlobalEnums->Item(tIndex)
									End If
								End If
								
								If tIndex = -1 Then
									tIndex = pGlobalFunctions->IndexOf(MatnLCase)
									If tIndex <> -1 Then
										te = pGlobalFunctions->Object(tIndex)
										'OriginalCaseWord = pGlobalFunctions->Item(tIndex)
										If te > 0 AndAlso SyntaxHighlightingIdentifiers Then
											Select Case te->ElementType
											Case E_Constructor, E_Destructor
												sc = 26 ' ColorGlobalTypes
											Case E_Keyword
												sc = 33 ' ColorGlobalFunctions
											Case E_Function
												sc = 33 ' ColorGlobalFunctions
											Case E_Sub
												sc = 35 ' ColorSubs
											Case E_Define
												sc = 34 ' ColorDefines
											Case E_Macro
												sc = 22 ' ColorMacros
											Case E_Property
												sc = 25 ' ColorProperties
											End Select
										End If
									End If
								End If
								
								If tIndex = -1 Then
									tIndex = pGlobalNamespaces->IndexOf(MatnLCase)
									If tIndex <> -1 Then sc = 31 ' ColorGlobalNamespaces
								End If
							End If
						End If
						If tIndex = -1 Then
							If IsNumeric(Matn) OrElse IsNumeric(MatnWithoutOldSymbol) OrElse CBool(Len(MatnLCase) > 1 AndAlso MatnLCase[0] = 38 AndAlso MatnLCase[1] = 104) Then ' "&h"
								If InStr(Matn, ".") Then
									sc = 24
								Else
									sc = 24
								End If
							Else
								sc = 23
							End If
						End If
						OldMatnLCase = MatnLCase
						If (Not bKeyWord) AndAlso WithOldSymbol Then
							'MatnBoshi - 1, MatnBoshi, NormalText
							WAdd(rtfiText, "\cf20 " & Mid(LineText, MatnBoshi, 1), , Capacity)
							'MatnBoshi, j, LineTextc
							WAdd(rtfiText, "\cf5 " & Mid(LineText, MatnBoshi + 1, j - MatnBoshi), , Capacity)
						Else
							'MatnBoshi - 1, j, Keyword  ' SC
							WAdd(rtfiText, "\cf" & sc & " " & Mid(LineText, MatnBoshi, j - MatnBoshi + 1), , Capacity)
						End If
						'End If
						MatnBoshi = 0
					End If
				ElseIf IIf(bInAsm, t = 35 OrElse t = 39, t = 39) Then
					If OddiyMatnBoshi > 0 Then
						'OddiyMatnBoshi - 1, j - 1, NormalText
						WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j - OddiyMatnBoshi), , Capacity)
						OddiyMatnBoshi = 0
					End If
					', Comments
					WAdd(rtfiText, "\cf5 " & Mid(LineText, j, L - j + 1), , Capacity)
					Exit Do
				ElseIf t <> 32 AndAlso OddiyMatnBoshi = 0 Then
					OddiyMatnBoshi = j
				ElseIf OddiyMatnBoshi = 0 AndAlso MatnBoshi = 0 Then
					WAdd(rtfiText, " ", , Capacity)
				End If
			End If
		End If
		j += 1
	Loop
	If m_IC > 0 Then
		'max(0, IzohBoshi - 1), l, Comments
		WAdd(rtfiText, "\cf5 " & Mid(LineText, Max(0, IzohBoshi), L - Max(0, IzohBoshi) + 1), , Capacity)
	ElseIf bQ Then
		'QavsBoshi - 1, j, Strings
		WAdd(rtfiText, "\cf21 " & Mid(LineText, QavsBoshi, j - QavsBoshi + 1), , Capacity)
		
	ElseIf OddiyMatnBoshi > 0 Then
		'OddiyMatnBoshi - 1, j, NormalText
		WAdd(rtfiText, "\cf20 " & Mid(LineText, OddiyMatnBoshi, j - OddiyMatnBoshi + 1), , Capacity)
	End If
	_Deallocate(PaddedLCasePtr)
	_Deallocate(TrimmedLCasePtr)
	Return rtfiText
End Function

' Helper function: Process images (simplified placeholder implementation)
Function MarkdownStreamConverter.ProcessImage(ByRef imgLine As WString) As String
	Dim As Integer altStart = InStr(imgLine, "[" )
	Dim As Integer altEnd   = InStr(altStart + 1, imgLine, "]" )
	Dim As Integer imgStart = InStr(altEnd, imgLine, "(" )
	Dim As Integer imgEnd   = InStr(imgStart + 1, imgLine, ")" )
	If altStart = 0 OrElse altEnd = 0 OrElse imgStart = 0 OrElse imgEnd = 0 Then
		Return imgLine & "\par"
	End If
	
	Dim altText As String = Mid(imgLine, altStart + 1, altEnd - altStart - 1)
	Dim imgPath As String = Mid(imgLine, imgStart + 1, imgEnd - imgStart - 1)
	
	Dim rtfImageBlock As String
	Dim imgHexData As String = LoadFromFileHex(imgPath)
	If Len(imgHexData) > 0 Then
		Dim As String imgExt = LCase(Mid(imgPath, InStrRev(imgPath, "." ) + 1))
		Dim As String rtfBlip = "\pngblip" ' 默认当作 PNG 处理
		If imgExt = "jpg" OrElse imgExt = "jpeg" Then
			rtfBlip = "\jpegblip"
		End If
		' 注意：\picw1\pich1 会让图片极小（1缇），实际应用中应根据图片像素尺寸换算为缇
		' 1英寸 = 1440缇，若图片宽100像素(96dpi)，则 \picw 约为1500 24像素为360缇
		rtfImageBlock = "{\pict" & rtfBlip & "\picw480\pich480 " & imgHexData & "}\par"
	Else
		rtfImageBlock = "{\cf7 [Image: " & altText & " (" & imgPath & ")]}\par"
	End If
	Return rtfImageBlock
End Function

Sub MarkdownStreamConverter.ProcessLine(ByVal iLinePtr As WString Ptr)
	' 空行重置列表状态
	If iLinePtr = 0 OrElse *iLinePtr = "" Then Return
	Dim As Integer iLineLen = Len(*iLinePtr)
	Select Case m_State
	Case State_Normal
		Select Case (*iLinePtr)[0]
		Case 91 '"["   '"[" & ML("User") & "]: "
			Dim As Integer level = 1
			Dim As WString Ptr ResultPtr
			If Left(*iLinePtr, 20) = "[**User Question:**]" Then
				WAdd(RTFBodyPtr, "\f1\cf2\highlight" & "14" & " " & Left("[User Question:] " & Mid(*iLinePtr, 21) & Space(300), 300) & m_DefaultStyle & "\par", , m_Capacity)
				level = 21
			ElseIf Left(*iLinePtr, 18) = "[**AI Response:**]" Then
				WAdd(RTFBodyPtr, "\f1\cf2\highlight" & "14" & " " & Left("[AI Response:] " & Mid(*iLinePtr, 19) & Space(300), 300) & m_DefaultStyle & "\par", , m_Capacity)
				level = 19
			End If
			If level = 1 Then
				'ResultPtr = ProcessInlineStyles(Mid(*iLinePtr, level))
				'If ResultPtr Then WAdd(RTFBodyPtr, m_DefaultStyle & *ResultPtr & "\par", , m_Capacity)
				'Else
				ResultPtr = ProcessInlineStyles(iLinePtr)
				If ResultPtr Then WAdd(RTFBodyPtr, m_DefaultStyle & *ResultPtr & "\par", , m_Capacity)
			End If
			If ResultPtr Then _Deallocate(ResultPtr)
		Case 96 '"`"  ' 1. Code block processing (enhanced robustness)
			'If (Trim(*iLinePtr) = "```") Then 'NOT always in the begging in GLM
			If iLineLen > 3 Then '`
				'If InStr(LCase(*iLinePtr), "```freebasic") OrElse InStr(LCase(*iLinePtr), "```fb") OrElse InStr(LCase(*iLinePtr), "```vb") Then
				m_State = State_InCodeBlock
				WAdd(RTFBodyPtr, "\f1\fs" & (RTFFontSizefs) & "\cf2\highlight" & "7" & " " & Left(*iLinePtr & Space(300), 300) & "\cf" & ColorIndexFore & "\highlight" & ColorIndexCodeBK & "\par", , m_Capacity)
			End If
		Case 49 To 57 '"1" To "9" ' 2. 解析 "1. **title 1**" 等数字标题列表
			Dim As Integer dotPos = InStr(*iLinePtr, ". **")
			If dotPos < 1 Then dotPos = InStr(*iLinePtr, ".  **")
			If dotPos < 1 Then dotPos = InStr(*iLinePtr, ".**")
			Dim As String listNum = ""
			If dotPos > 0 Then
				listNum = Left(*iLinePtr, dotPos - 1)
				If dotPos > Len(listNum) + 1 Then listNum = ""
			End If
			Dim As WString Ptr ResultPtr
			If listNum <> "" Then
				Dim As WString Ptr afterDotPtr
				WLet(afterDotPtr, LTrim(Mid(*iLinePtr, dotPos + 2)))
				If afterDotPtr = 0 Then Return
				WAdd(RTFBodyPtr,  "\b\fs" & (RTFFontSizefs + 2) & "\cf7 " & listNum & ". ", , m_Capacity)
				m_inListItem = True ' 标记进入列表项，后续缩进行属于此列表
				ResultPtr = ProcessInlineStyles(afterDotPtr)
				_Deallocate(afterDotPtr)
				If ResultPtr Then WAdd(RTFBodyPtr, m_DefaultStyle & *ResultPtr & "\par", , m_Capacity)
			Else
				ResultPtr = ProcessInlineStyles(iLinePtr)
				If ResultPtr Then WAdd(RTFBodyPtr, m_DefaultStyle & *ResultPtr & "\par", , m_Capacity)
			End If
			If ResultPtr Then _Deallocate(ResultPtr)
		Case 124
			If iLineLen > 2 AndAlso (*iLinePtr)[iLineLen - 1] = 124 Then
				m_State = State_PotentialTable
				WLet(m_TableBufferPtr, *iLinePtr)
			End If
		Case 32 '" " ' 3. 处理列表项下方的缩进内容 (如 "   abcd")
			'If m_inListItem Then
			Dim As Integer indentCount = 0
			While indentCount < iLineLen AndAlso (*iLinePtr)[indentCount] = 32
				indentCount += 1
			Wend
			Dim As Integer rtfIndent = (indentCount \ 3) * 360 + 360
			Dim As WString Ptr ResultPtr = ProcessInlineStyles(iLinePtr)
			If ResultPtr Then
				WAdd(RTFBodyPtr, "\pard\li" & rtfIndent & m_DefaultStyle & *ResultPtr & "\par", , m_Capacity)
				_Deallocate(ResultPtr)
			End If
			
		Case 33 '![]
			If iLineLen > 2 AndAlso (*iLinePtr)[1] = 91 Then
				Dim As WString Ptr ResultPtr = ProcessInlineStyles(iLinePtr)
				If ResultPtr Then
					Debug.Print __FUNCTION__ & " 291 " &  *ResultPtr
					WAdd(RTFBodyPtr, *ResultPtr, , m_Capacity)
					_Deallocate(ResultPtr)
				End If
			End If
		Case 35 '"#"   ' 5. Heading processing (optimized multi-level headings)
			Dim As Integer titleSize= 0, level = 0
			While level < 6 AndAlso level < iLineLen AndAlso (*iLinePtr)[level] = 35  ' "#"
				level += 1
			Wend
			Dim As String HeadingStyle = "\f0\cf" & ColorIndexFore & "\b "
			Select Case level
			Case 1: HeadingStyle = "\f0\fs" & (RTFFontSizefs + 20) & "\cf" & ColorIndexFore & "\b " ' H1
			Case 2: HeadingStyle = "\f0\fs" & (RTFFontSizefs + 12) & "\cf" & ColorIndexFore & "\b " ' H2
			Case 3: HeadingStyle = "\f0\fs" & (RTFFontSizefs + 8) & "\cf" & ColorIndexFore & "\b " ' H3
			Case 4: HeadingStyle = "\f0\fs" & (RTFFontSizefs + 4) & "\cf" & ColorIndexFore & "\b " ' H4
			Case Else: HeadingStyle = "\f0\fs" & (RTFFontSizefs) & "\cf" & ColorIndexFore & "\b " ' H5/H6
			End Select
			WAdd(RTFBodyPtr, HeadingStyle & Mid(*iLinePtr, level + 1) & m_DefaultStyle & "\par", , m_Capacity)
		Case Else
			OutputNormalLine(iLinePtr)
		End Select
	Case State_PotentialTable
		' 检查是否为分隔行 |---|---|
		Dim isSeparator As Boolean = True
		If iLineLen > 2 AndAlso (*iLinePtr)[0] = 124 AndAlso (*iLinePtr)[iLineLen - 1] = 124 Then
			Dim As Integer c, colCount = 1
			For i As Integer = 1 To (iLineLen - 2)
				c = (*iLinePtr)[i]
				If c = 124 Then colCount += 1  '"|"
				If c <> 45 AndAlso c <> 124 AndAlso c <> 58 AndAlso c <> 32 Then  ' "-" "|" ":" " " Then
					isSeparator = False
					Exit For
				End If
			Next
			If isSeparator Then
				' 表格确认
				m_State = State_InTable
				m_TableColCount = colCount
				ReDim m_TableColWIdth(m_TableColCount - 1)
				OutputTableRow(m_TableBufferPtr, True, ColorTableBorder) ' 输出表头行
				Exit Sub
			End If
		End If
		' 不是表格分隔，把暂存行和当前行都当普通行输出
		m_State = State_Normal
		OutputNormalLine(m_TableBufferPtr)
		WLet(m_TableBufferPtr, "")
		m_CapacityTable = 0
	Case State_InTable
		If iLineLen > 2 AndAlso (*iLinePtr)[0] = 124 AndAlso (*iLinePtr)[iLineLen - 1] = 124 Then '"|"
			OutputTableRow(iLinePtr, , ColorTableBorder)
		Else
			' 表格结束 \pard 来终止表格上下文。
			Dim As Integer colWidth = 0
			For j As Integer = 0 To m_TableColCount - 1
				colWidth += m_TableColWIdth(j) + 200
				WLetEx(m_TableBufferPtr, Replace(*m_TableBufferPtr, "\cellxTmp" & (j + 1) & " " , "\cellx" & colWidth & " " ))
			Next
			If m_TableBufferPtr <> 0 Then
				WAdd(RTFBodyPtr, Chr(10) & *m_TableBufferPtr & Chr(10) & "\pard\plain ", , m_Capacity)
				_Deallocate(m_TableBufferPtr) : m_TableBufferPtr = 0 : m_CapacityTable = 0
			End If
			m_State = State_Normal
			ProcessLine(iLinePtr)
		End If
	Case State_InCodeBlock
		' 代码结束
		If iLineLen > 0 AndAlso (*iLinePtr)[0] = 96 Then '`
			m_State = State_Normal
			WAdd(RTFBodyPtr,  "```\par" & Chr(10) & m_DefaultStyle & "\pard\plain ", , m_Capacity)
			If (*iLinePtr)[iLineLen - 1] <> 96 Then
				Dim As Integer endPosi = InStrRev(*iLinePtr, "`" )
				If endPosi > 0 Then
					*iLinePtr = Mid(*iLinePtr, endPosi + 1)
					ProcessInlineStyles(iLinePtr)
				End If
			End If
		Else
			Dim As WString Ptr freeBasicPtr = freeBasicToRTF(*iLinePtr)
			If freeBasicPtr = 0 Then Return
			WAdd(RTFBodyPtr,  *freeBasicPtr + "\line ", , m_Capacity)
			_Deallocate(freeBasicPtr)
		End If
	End Select
End Sub

Function MarkdownStreamConverter.ProcessInlineStyles(ByVal iTextPtr As WString Ptr) As WString Ptr
	If iTextPtr = 0 OrElse *iTextPtr = "" Then Return 0
	Dim As WString Ptr ResultPtr
	Dim As Integer Posi = 1, curPos = 1, endPosi, Capacity, LeniText = Len(*iTextPtr)
	Dim As WString Ptr tmpPtr, ContentPtr
	Dim As String url
	While Posi <= LeniText
		Select Case (*iTextPtr)[Posi - 1]
		Case 96  'Asc("`" )
			' 1. 处理行内代码 `code`
			endPosi = InStr(Posi + 1, *iTextPtr, "`" )
			If endPosi > 0 Then
				m_inLineCode = Not m_inLineCode
			ElseIf m_inLineCode Then
				endPosi = LeniText
			End If
			If endPosi > 0 Then
				' 追加代码之前的文本
				If Posi > curPos Then WAdd(ResultPtr, Mid(*iTextPtr, curPos, Posi - curPos), , Capacity)
				Dim As WString Ptr CodePtr
				WLet(CodePtr, Mid(*iTextPtr, Posi + 1, endPosi - Posi - 1))
				If CodePtr = 0 Then Continue While
				WAdd(ResultPtr, "\f1\fs" & RTFFontSizefs & "\highlight" & ColorIndexCodeBK & " ", , Capacity)
				Dim As WString Ptr freeBasicPtr = freeBasicToRTF(*CodePtr)
				If freeBasicPtr = 0 Then
					WAdd(ResultPtr, *CodePtr, , Capacity) '\line
				Else
					WAdd(ResultPtr,  *freeBasicPtr, , Capacity)
					_Deallocate(freeBasicPtr)
				End If
				_Deallocate(CodePtr)
				WAdd(ResultPtr, " " & m_DefaultStyle, , Capacity)
				curPos = endPosi + 1
				Posi = curPos
				Continue While
			End If
		Case 91  'Asc("[" )
			' 2. 处理链接 [text](url)
			Dim endBracket As Integer = InStr(Posi + 1, *iTextPtr, "]" )
			If endBracket > 0 Then
				Dim startParen As Integer = InStr(endBracket, *iTextPtr, "(" )
				Dim endParen As Integer = InStr(startParen, *iTextPtr, ")" )
				If startParen > 0 And endParen > 0 And startParen = endBracket + 1 Then
					url = Mid(*iTextPtr, startParen + 1, endParen - startParen - 1)
					WLet(ContentPtr, Mid(*iTextPtr, Posi + 1, endBracket - Posi - 1))
					If ContentPtr = 0 Then Continue While
					tmpPtr = ProcessInlineStyles(ContentPtr)
					' 追加链接之前的文本
					If Posi > curPos Then WAdd(ResultPtr, Mid(*iTextPtr, curPos, Posi - curPos), , Capacity)
					WAdd(ResultPtr, "{\field{\*\fldinst HYPERLINK " & "" "" & url & "" "" & "}{\fldrslt\cf7\ul " , , Capacity)
					If tmpPtr <> 0 Then
						WAdd(ResultPtr, *tmpPtr, , Capacity)
						_Deallocate(tmpPtr)
					End If
					WAdd(ResultPtr, "\ulnone\f0}}", , Capacity)
					curPos = endParen + 1
					Posi = curPos
					Continue While
				End If
			End If
		Case 33 '"!["   'Image processing
			If LeniText > 2 AndAlso (*iTextPtr)[Posi] = 91 Then
				endPosi = InStr(Posi + 1, *iTextPtr, ")" )
				If endPosi > 0 Then
					' 追加代码之前的文本
					If Posi > curPos Then WAdd(ResultPtr, Mid(*iTextPtr, curPos, Posi - curPos), , Capacity)
					Dim As WString Ptr ImageStrPtr
					WLet(ImageStrPtr, Mid(*iTextPtr, Posi, endPosi - Posi + 1))
					If ImageStrPtr = 0 Then Continue While
					WAdd(ResultPtr, ProcessImage(*ImageStrPtr), , Capacity)
					_Deallocate(ImageStrPtr)
					WAdd(ResultPtr, m_DefaultStyle, , Capacity)
					curPos = endPosi + 1
					Posi = curPos
					Continue While
				End If
			End If
		Case 42 'Asc("*" )
			If Posi < LeniText AndAlso (*iTextPtr)[Posi] = 42 Then 'Asc("*"
				endPosi = InStr(Posi + 2, *iTextPtr, "**" )
				If endPosi > 0 Then
					If Posi > curPos Then WAdd(ResultPtr, Mid(*iTextPtr, curPos, Posi - curPos), , Capacity)
					WAdd(ResultPtr, "{\b\fs" & (RTFFontSizefs + 2) & " ", , Capacity)
					WLet(ContentPtr, Mid(*iTextPtr, Posi + 2, endPosi - Posi - 2))
					If ContentPtr = 0 Then Continue While
					tmpPtr = ProcessInlineStyles(ContentPtr)
					If tmpPtr <> 0 Then
						WAdd(ResultPtr, *tmpPtr, , Capacity)
						_Deallocate(tmpPtr)
					End If
					WAdd(ResultPtr, "\b0}", , Capacity)
					curPos = endPosi + 2
					Posi = curPos
					Continue While
				End If
			Else
				' 4. *italic*
				endPosi = Posi + 1
				Do
					endPosi = InStr(endPosi, *iTextPtr, "*" )
					If endPosi = 0 Then Exit Do
					' 检查是否为加粗标记的一部分，如果是则跳过该星号
					If endPosi < LeniText AndAlso (*iTextPtr)[endPosi] = 42 Then
						endPosi += 2
					Else
						Exit Do
					End If
				Loop
				
				If endPosi > 0 Then
					If Posi > curPos Then WAdd(ResultPtr, Mid(*iTextPtr, curPos, Posi - curPos), , Capacity)
					WAdd(ResultPtr, "{\i ", , Capacity)
					' 支持斜体内嵌套其他样式 )
					WLet(ContentPtr, Mid(*iTextPtr, Posi + 1, endPosi - Posi - 1))
					If ContentPtr = 0 Then Continue While
					tmpPtr = ProcessInlineStyles(ContentPtr)
					If tmpPtr <> 0 Then
						WAdd(ResultPtr, *tmpPtr, , Capacity)
						_Deallocate(tmpPtr)
					End If
					WAdd(ResultPtr, "\i0}", , Capacity)
					curPos = endPosi + 1
					Posi = curPos
					Continue While
				End If
			End If
		End Select
		Posi += 1
	Wend
	
	' 追加剩余的普通文本
	If curPos <= LeniText Then
		Capacity = 0
		WAdd(ResultPtr, Mid(*iTextPtr, curPos), , Capacity)
	End If
	If ContentPtr Then _Deallocate(ContentPtr)
	Return ResultPtr
End Function

Sub MarkdownStreamConverter.OutputNormalLine(ByVal iLinePtr As WString Ptr)
	If iLinePtr = 0 OrElse *iLinePtr = "" Then Return
	Dim As WString Ptr ContentPtr
	Dim As String rtfPrefix
	If (*iLinePtr)[0] = 35 Then '"#"
		Dim level As Integer = 0
		' 优化：使用 WString Ptr 的指针索引表示法替代 Mid 函数，提升性能
		While level < Len(*iLinePtr) AndAlso (*iLinePtr)[level] = 35 'Asc("#" )
			level += 1
		Wend
		Dim fontSize As Integer = 48 - (level * 4)
		WLet(ContentPtr, Trim(Mid(*iLinePtr, level + 1)))
		If ContentPtr = 0 Then Return
		rtfPrefix = "\pard\sb240\sa120\fs" & fontSize & " "
	ElseIf Len(iLinePtr)>1 AndAlso (*iLinePtr)[0] = 45 AndAlso (*iLinePtr)[1] = 32 Then  '"- "
		WLet(ContentPtr, Mid(*iLinePtr, 3))
		If ContentPtr = 0 Then Return
		rtfPrefix = "\pard\li360\fi-360\bullet "
	Else
		WLet(ContentPtr, *iLinePtr)
		If ContentPtr = 0 Then Return
		rtfPrefix = "\pard "
	End If
	Dim As WString Ptr ResultPtr = ProcessInlineStyles(ContentPtr)
	If ResultPtr = 0 Then Return
	' 统一拼接 RTF 并释放内存
	WAdd(RTFBodyPtr, rtfPrefix & *ResultPtr & "\par" & Chr(10), , m_Capacity)
	'If ContentPtr <> iLinePtr Then _Deallocate(ContentPtr)
	_Deallocate(ContentPtr)
	_Deallocate(ResultPtr)
End Sub

Sub MarkdownStreamConverter.OutputTableRow(ByVal iLinePtr As WString Ptr, ByVal isHead As Boolean = False, ByVal textColorIndex As Integer = 4)
	If iLinePtr = 0 OrElse Trim(*iLinePtr) = "" Then Return
	Dim As String BorderDef
	BorderDef = "\trbrdrt\brdrs\brdrw10\brdrcf" & textColorIndex & " " & _
	"\trbrdrb\brdrs\brdrw10\brdrcf" & textColorIndex & " " & _
	"\trbrdrl\brdrs\brdrw10\brdrcf" & textColorIndex & " " & _
	"\trbrdrr\brdrs\brdrw10\brdrcf" & textColorIndex & " " & _
	"\trbrdrv\brdrs\brdrw10\brdrcf" & textColorIndex & " " & _
	"\trbrdrh\brdrs\brdrw10\brdrcf" & textColorIndex & " "
	Dim As WString Ptr ProcessInlineStylesPtr
	If isHead Then
		WLet(m_TableBufferPtr, "\trowd" & BorderDef & "\trgaph108\trleft0 ")
		m_CapacityTable =0
	Else
		WAdd(m_TableBufferPtr, "\trowd" & BorderDef & "\trgaph108\trleft0 ", , m_CapacityTable)
	End If
	For i As Integer = 1 To m_TableColCount
		WAdd(m_TableBufferPtr, "\cellxTmp" & (i) & " ", , m_CapacityTable)
	Next
	WAdd(m_TableBufferPtr, "\pard\intbl ", , m_CapacityTable)
	Dim As WString Ptr CellsColPtr()
	Dim As Integer cellWidth
	Dim As Integer count = Split(Mid(*iLinePtr, 2, Len(*iLinePtr) - 2), "|" , CellsColPtr())
	For i As Integer = 0 To m_TableColCount - 1
		If i < count Then
			ProcessInlineStylesPtr = ProcessInlineStyles(CellsColPtr(i))
			If ProcessInlineStylesPtr = 0 Then Continue For
			If isHead Then
				WAdd(m_TableBufferPtr,  "{\b\f0 " + *ProcessInlineStylesPtr + "\b0}\cell", , m_CapacityTable)
			Else
				WAdd(m_TableBufferPtr,  *ProcessInlineStylesPtr + "\cell", , m_CapacityTable)
			End If
			' 计算内容列宽（区分中英文字符）
			cellWidth = 0
			For k As Integer = 0 To Len(*CellsColPtr(i)) - 1
				If (*CellsColPtr(i))[k] > 127 Then
					cellWidth += RTFFontSizefs * 10
				Else
					cellWidth += RTFFontSizefs * 6
				End If
			Next
			If m_TableColWIdth(i) < cellWidth Then m_TableColWIdth(i) = cellWidth
		Else
			WAdd(m_TableBufferPtr, "\cell", , m_CapacityTable)
		End If
		_Deallocate(ProcessInlineStylesPtr)
		_Deallocate(CellsColPtr(i))
	Next
	Erase CellsColPtr
	WAdd(m_TableBufferPtr, "\row " + !"\r\n", , m_CapacityTable)
End Sub


'
'Dim As WString * 8096 testMarkdown
'testMarkdown = !"# Markdown to RTF Test\n" & _
'!"## Level 2 Heading\n" & _
'!"This is a paragraph containing **bold**, *italic* and `inline code`.\n" & _
'!"[Link to Baidu](http://www.baidu.com)\n" & _
'!"- Unordered list item 1\n" & _
'!"  - Sublist item 1\n" & _
'!"  - Sublist item 2\n" & _
'!"- Unordered list item 2\n" & _
'!"| Name | Age | Occupation |\n" & _
'!"|------|-----|------|\n" & _
'!"| John | 25  | Programmer |\n" & _
'!"| Jane | 30  | Designer |\n" & _
'!"```vb\n" & _
'!"Sub Test()\n" & _
'!"    Print ""Code block test ""\n" & _
'!"End Sub\n" & _
'!"```\n\n" & _
'!"| Name | Age | Occupation |\n" & _
'!"|------|-----|------|\n" & _
'!"| John | 25  | Programmer |\n" & _
'!"| Jane | 30  | Designer |\n" & _
'!"[Example image](example.png)"
'Dim As WString Ptr rtfOutput
'rtfOutput = MDtoRTF(testMarkdown)
'Print "Generated RTF content:"
'Print "--------------------------------------------------"
'Print *rtfOutput
'Print "--------------------------------------------------"
''txtThink.iTextRTF = rtfOutput
'Dim Fn As Integer = FreeFile
'Open "test.rtf" For Output As #Fn
'Print #Fn, *rtfOutput
'Close #Fn
'Print "RTF file saved as test.rtf"
'Deallocate rtfOutput
'Sleep(8000)
'End