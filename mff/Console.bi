'###############################################################################
'#  Console.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#define UNICODE
#include once "windows.bi"
Const CONSOLE_BUFFER_MAXSIZE As Long = 8191 '缓冲区最大字符数
'0	黑色	8	灰色
'1	蓝色	9	浅蓝色
'2	绿色	10	浅绿色
'3	蓝绿	11	浅青色
'4	红色	12	浅红色
'5	洋红	13	浅洋红色
'6	黄色	14	浅黄色
'7	白色	15	亮白色
#define clBlack                0 '    &H000000   '   RGB(0, 0, 0)   '纯黑
#define clBlue                 1 '    &HFF0000   '   RGB(0, 0, 255)   '纯蓝
#define clBrown                4 '    &H2A2AA5   '   RGB(165, 42, 42)   '棕色
#define clCyan                 3 '    &HFFFF00   '   RGB(0, 255, 255)   '青色
#define clDarkBlue             9 '    &H8B0000   '   RGB(0, 0, 139)   '暗蓝色
#define clDarkCyan             11 '   &H8B8B00   '   RGB(0, 139, 139)   '暗青色
#define clDarkGreen            10 '   &H006400   '   RGB(0, 100, 0)   '暗绿色
#define clDarkMagenta          13 '   &H8B008B   '   RGB(139, 0, 139)   '深洋红
#define clDarkOrange           14 '   &H008CFF   '   RGB(255, 140, 0)   '深橙色
#define clDarkRed              12 '   &H00008B   '   RGB(139, 0, 0)   '深红色
#define clGray                  8 '   &H808080   '   RGB(128, 128, 128)   '灰色
#define clGreen                 2 '   &H008000   '   RGB(0, 128, 0)   '纯绿
#define clLightWhite           15 '   &HFFFFFF   '   RGB(255, 255, 255)   '纯白
#define clPink                  5 '   &HCBC0FF   '   RGB(255, 192, 203)   '粉红
#define clRed                   4 '   &H0000FF   '   RGB(255, 0, 0)   '纯红
#define clWhite                 7 '   &HFFFFFF   '   RGB(255, 255, 255)   '纯白
#define clYellow                6 '   &H00FFFF   '   RGB(255, 255, 0)   '纯黄

Private Type ConsoleType
	'私有变量
Private:
	m_StdOut As HANDLE
	m_StdIn As HANDLE
	m_StdErr As HANDLE
	m_IsReady As Boolean
	m_DefaultForeColor As Integer
	m_DefaultBackColor As Integer
	
Public:
	' Clip rectangle 
	Declare Sub ClipRect(pX As Integer, pY As Integer, pW As Integer, pH As Integer, pMaxW As Integer, pMaxH As Integer)
	
	'Combines two 16-bit integers into one 32-bit integer (lower 16-bit integer, higher 16-bit integer)
	'Declare Function MakeDWord(pHi As Integer, pLow As Integer) As Long
	
	' Background color value range: 0 - 15
	Declare Property BackColor() As Integer
	Declare Property BackColor(v As Integer)
	'Font Change the font name and size
	Declare Property Font(v As _CONSOLE_FONT_INFOEX)
	Declare Property Font() As _CONSOLE_FONT_INFOEX
	' Buffer height
	Declare Property BufferHeight() As Integer
	' Buffer width
	Declare Property BufferWidth() As Integer
	'Window handles related to the console
	Declare Property ConsoleWindow() As HWND
	' The column where the cursor is located
	Declare Property CursorCol() As Integer
	Declare Property CursorCol(v As COORD)
	' The line where the cursor is located
	Declare Property CursorRow() As Integer
	Declare Property CursorRow(v As COORD)
	'  Cursor size Value range: 1 - 100
	Declare Property CursorSize() As Long
	Declare Property CursorSize(v As Long)
	' Whether the cursor is visible
	Declare Property CursorVisable() As Boolean
	Declare Property CursorVisable(v As Boolean)
	' Foreground color value range: 0 - 15
	Declare Property ForeColor() As Integer
	Declare Property ForeColor(v As Integer)
	' Whether or not it is full-screen
	Declare Property FullScreen() As Boolean
	Declare Property FullScreen(v As Boolean)
	' Enter the code page
	Declare Property InputCodePage() As Long
	Declare Property InputCodePage(v As Long)
	' Input mode: ENABLE_ECHO_INPUT
	Declare Property InputModeEcho() As Boolean
	Declare Property InputModeEcho(v As Boolean)
	' Input mode:ENABLE_INSERT_MODE
	Declare Property InputModeInsert() As Boolean
	Declare Property InputModeInsert(v As Boolean)
	' Input mode:ENABLE_LINE_INPUT
	Declare Property InputModeLine() As Boolean
	Declare Property InputModeLine(v As Boolean)
	' Input mode:ENABLE_MOUSE_INPUT
	Declare Property InputModeMouse() As Boolean
	Declare Property InputModeMouse(v As Boolean)
	' Input mode:ENABLE_PROCESSED_INPUT
	Declare Property InputModeProcessed() As Boolean
	Declare Property InputModeProcessed(v As Boolean)
	' Input mode:ENABLE_QUICK_EDIT_MODE
	Declare Property InputModeQuickEdit() As Boolean
	Declare Property InputModeQuickEdit(v As Boolean)
	' Input mode:ENABLE_WINDOW_INPUT
	Declare Property InputModeWindow() As Boolean
	Declare Property InputModeWindow(v As Boolean)
	' Output code page
	Declare Property OutputCodePage() As Long
	Declare Property OutputCodePage(v As Long)
	'Output mode: ENABLE_PROCESSED_OUTPUT
	Declare Property OutputModeProcessed() As Boolean
	Declare Property OutputModeProcessed(v As Boolean)
	' Output mode: ENABLE_WRAP_AT_EOL_OUTPUT
	Declare Property OutputModeWrapAtEol() As Boolean
	Declare Property OutputModeWrapAtEol(v As Boolean)
	' Standard error handles
	Declare Property StdErr() As HANDLE
	Declare Property StdErr(v As HANDLE)
	'Standard input handles
	Declare Property StdIn As HANDLE
	Declare Property StdIn(v As HANDLE)
	' Standard output handle
	Declare Property StdOut As HANDLE
	Declare Property StdOut(v As HANDLE)
	' Console title
	Declare Property Title() As String
	Declare Property Title(ByVal v As String)
	' The height of the console window
	Declare Property ViewHeight() As Integer
	' Maximum console window height
	Declare Property ViewHeightMax() As Integer
	' The width of the console window
	Declare Property ViewWidth() As Integer
	' Maximum console window width
	Declare Property ViewWidthMax() As Integer
	' Font Change the font name and size
	Declare Sub FontSize(w As Long, h As Long, fName As String = "consolas")
	' Set console size (total number of columns, total number of rows)
	Declare Sub ConsoleSize(cols As Long, lines As Long)
	' Clear screen (whether to restore attributes)
	Declare Sub Clear(ByVal pToDefault As Boolean = False)
	' Fill rectangular text (rows, columns, width, height, characters) returns the actual number of fills
	Declare Function FillRectText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pChar As Byte) As Long
	' The Fill Rectangle property returns the actual fill quantity
	Declare Function FillRectAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	'Fill rectangular text, expand
	Declare Function FillRectEx(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pChar As Byte, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	' Filled text. returns the actual number of fills
	Declare Function FillText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pChar As Byte) As Long
	' Fill Properties, QB Color Series, Returns the actual number of fills
	Declare Function FillTextAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	' Fill text, expansion, returns the actual amount of fill
	Declare Function FillTextEx(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pChar As Byte, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	' Composite character properties, return the properties of the composition
	Declare Function MakeAttribute(ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Integer
	'Move the cursor (rows, columns)
	Declare Sub MoveCursor(ByVal pRow As Integer, ByVal pCol As Integer)
	' Read buffer attributes, QB color series
	Declare Sub ReadBufferAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, buf() As Long)
	' Read buffer text, returns the text that was read
	Declare Function ReadBufferText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer) As String
	' Read the virtual keycode of the key, refer to the KeyCodeConstants
	Declare Function ReadKey() As Integer
	'Read the entire line input, returns the input text, excluding carriage returns, and does not include carriage returns
	Declare Function ReadLine(ByRef pPrompt As WString = "") As String
	' To read the password, return to enter the text, excluding the carriage return wrap
	Declare Function ReadPassword(ByRef pPrompt As String = "") As String
	' Invert foreground and background colors Return the actual number of inverts
	Declare Function ReverseTextColor(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pReverse As Boolean) As Long
	' Reverses the rectangular foreground and background color to return the actual number of inverts
	Declare Function ReverseRectColor(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pReverse As Boolean) As Long
	' Sets the console window size
	Declare Sub SetViewSize(ByVal pWidth As Integer, ByVal pHeight As Integer)
	'Explode character properties
	Declare Sub SplitAttribute(ByVal pAttribute As Integer, ByRef pForeColor As Integer, ByRef pBackColor As Integer, ByRef pReverseColor As Boolean)
	'  The length of the text, single byte counts as 1, double byte counts as 2
	Declare Function LenB(ByRef pStr As WString) As Long
	'  Write buffer properties, QB color series returns how many characters were actually written
	Declare Function WriteBufferAttribute(ByVal pRow As Integer, ByVal pCol As Integer, pAttributes() As Long, ByVal pCount As Integer) As Long
	' Write an entire line of text, returns the number of characters actually
	Declare Function WriteLine(ByRef pBuf As WString = "") As Long
	' Write the entire line of text, and the extension returns the number of characters actually written
	Declare Function WriteLineEx(ByRef pBuf As WString, ByVal pForeColor As Integer = -1, ByVal pBackColor As Integer = -1) As Long
	' Write Text, returns the actual number of characters written
	Declare Function WriteText(ByRef pBuf As WString) As Long
	'Write text extension function, returns the actual number of characters written
	Declare Function WriteTextEx(ByRef pBuf As WString, ByVal pForeColor As Integer = -1, ByVal pBackColor As Integer = -1) As Long
	Declare Constructor
	Declare Destructor
End Type
'------------------------------------------------------------------------------
'initialize
'------------------------------------------------------------------------------
Private Constructor ConsoleType   ' Class_Initialize()
	AllocConsole
	m_StdOut = GetStdHandle(STD_OUTPUT_HANDLE)
	m_StdIn = GetStdHandle(STD_INPUT_HANDLE)
	m_StdErr = GetStdHandle(STD_ERROR_HANDLE)
	m_DefaultForeColor = ForeColor
	m_DefaultBackColor = BackColor
End Constructor

' Destroyed
Private Destructor ConsoleType  'Class_Terminate()
	ForeColor = m_DefaultForeColor
	BackColor = m_DefaultBackColor
	FreeConsole
End Destructor

Private Sub ConsoleType.ClipRect(pX As Integer, pY As Integer, pW As Integer, pH As Integer, pMaxW As Integer, pMaxH As Integer)
	Dim X2 As Integer, Y2 As Integer
	If pW < 0 Then Goto ERR_OUTRANGE
	If pH < 0 Then Goto ERR_OUTRANGE
	If pX > pMaxW Then Goto ERR_OUTRANGE
	If pY > pMaxH Then Goto ERR_OUTRANGE
	X2 = pX + pW - 1
	Y2 = pY + pH - 1
	If X2 < 0 Or Y2 < 0 Then Goto ERR_OUTRANGE
	If pX < 0 Then pX = 0
	If pY < 0 Then pY = 0
	If X2 > pMaxW Then X2 = pMaxW
	If Y2 > pMaxH Then Y2 = pMaxH
	pW = X2 - pX + 1
	pH = Y2 - pY + 1
	Exit Sub
	ERR_OUTRANGE:
	pX = 0: pY = 0: pW = 0: pH = 0
End Sub

'Private Function MakeDWord(pHi As Integer, pLow As Integer) As Long
'	Return (CLng(pHi) * &H10000) Or (pLow And &HFFFF)
'End Function

Private Property ConsoleType.BackColor() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return (tmp.wAttributes And &HF0) \ &HF   'VB6
End Property

Private Property ConsoleType.BackColor(v As Integer)
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	tmp.wAttributes = (tmp.wAttributes And (Not &HF0)) Or ((v And &HF) * &H10)  'VB6
	SetConsoleTextAttribute m_StdOut, tmp.wAttributes
End Property

Private Property ConsoleType.Font() As _CONSOLE_FONT_INFOEX
	Dim x As _CONSOLE_FONT_INFOEX
	GetCurrentConsoleFontEx(m_StdOut, False, @x)
	Return x
End Property

Private Property ConsoleType.Font(v As _CONSOLE_FONT_INFOEX)
	SetCurrentConsoleFontEx(m_StdOut, 1, @v)
End Property

Private Property ConsoleType.BufferHeight() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwSize.Y
End Property

Private Property ConsoleType.BufferWidth() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwSize.X
End Property

Private Property ConsoleType.ConsoleWindow() As HWND
	Return  GetConsoleWindow()
End Property

Private Property ConsoleType.CursorCol() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwCursorPosition.X
End Property

Private Property ConsoleType.CursorCol(v As COORD)
	SetConsoleCursorPosition m_StdOut, v
End Property

Private Property ConsoleType.CursorRow() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwCursorPosition.Y
End Property

Private Property ConsoleType.CursorRow(v As COORD)
	SetConsoleCursorPosition m_StdOut, v
End Property

Private Property ConsoleType.CursorSize() As Long
	Dim tmp As CONSOLE_CURSOR_INFO
	GetConsoleCursorInfo m_StdOut, @tmp
	Return tmp.dwSize
End Property

Private Property ConsoleType.CursorSize(v As Long)
	Dim tmp As CONSOLE_CURSOR_INFO
	GetConsoleCursorInfo m_StdOut, @tmp
	tmp.dwSize = v
	SetConsoleCursorInfo m_StdOut, @tmp
End Property

Private Property ConsoleType.CursorVisable() As Boolean
	Dim tmp As CONSOLE_CURSOR_INFO
	GetConsoleCursorInfo m_StdOut, @tmp
	Return tmp.bVisible
End Property

Private Property ConsoleType.CursorVisable(v As Boolean)
	Dim tmp As CONSOLE_CURSOR_INFO
	GetConsoleCursorInfo m_StdOut, @tmp
	tmp.bVisible = v
	SetConsoleCursorInfo m_StdOut, @tmp
End Property

Private Property ConsoleType.ForeColor() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.wAttributes And &HF   'VB6
End Property

Private Property ConsoleType.ForeColor(v As Integer)
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	tmp.wAttributes = (tmp.wAttributes And (Not &HF)) Or (v And &HF) ' VB6
	SetConsoleTextAttribute m_StdOut, tmp.wAttributes
End Property

Private Property ConsoleType.FullScreen() As Boolean
	Dim ret As Long
	GetConsoleDisplayMode @ret
	Return (ret <> 0)
End Property

Private Property ConsoleType.FullScreen(v As Boolean)
	Dim tmp As COORD
	SetConsoleDisplayMode m_StdOut, IIf(v, CONSOLE_FULLSCREEN_MODE, CONSOLE_WINDOWED_MODE), @tmp
End Property

Private Property ConsoleType.InputCodePage() As Long
	InputCodePage = GetConsoleCP()
End Property

Private Property ConsoleType.InputCodePage(v As Long)
	SetConsoleCP v
End Property

Private Property ConsoleType.InputModeEcho() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_ECHO_INPUT) = ENABLE_ECHO_INPUT)
End Property

Private Property ConsoleType.InputModeEcho(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_ECHO_INPUT, ret And (Not ENABLE_ECHO_INPUT))
End Property

Private Property ConsoleType.InputModeInsert() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_INSERT_MODE) = ENABLE_INSERT_MODE)
End Property

Private Property ConsoleType.InputModeInsert(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_INSERT_MODE, ret And (Not ENABLE_INSERT_MODE))
End Property

Private Property ConsoleType.InputModeLine() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	InputModeLine = ((ret And ENABLE_LINE_INPUT) = ENABLE_LINE_INPUT)
End Property

Private Property ConsoleType.InputModeLine(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_LINE_INPUT, ret And (Not ENABLE_LINE_INPUT))
End Property

Private Property ConsoleType.InputModeMouse() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_MOUSE_INPUT) = ENABLE_MOUSE_INPUT)
End Property

Private Property ConsoleType.InputModeMouse(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_MOUSE_INPUT, ret And (Not ENABLE_MOUSE_INPUT))
End Property

Private Property ConsoleType.InputModeProcessed() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_PROCESSED_INPUT) = ENABLE_PROCESSED_INPUT)
End Property

Private Property ConsoleType.InputModeProcessed(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_PROCESSED_INPUT, ret And (Not ENABLE_PROCESSED_INPUT))
End Property

Private Property ConsoleType.InputModeQuickEdit() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_QUICK_EDIT_MODE) = ENABLE_QUICK_EDIT_MODE)
End Property

Private Property ConsoleType.InputModeQuickEdit(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_QUICK_EDIT_MODE, _
	ret And (Not ENABLE_QUICK_EDIT_MODE))
End Property

Private Property ConsoleType.InputModeWindow() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	Return ((ret And ENABLE_WINDOW_INPUT) = ENABLE_WINDOW_INPUT)
End Property

Private Property ConsoleType.InputModeWindow(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdIn, @ret
	SetConsoleMode m_StdIn, IIf(v, ret Or ENABLE_WINDOW_INPUT, ret And (Not ENABLE_WINDOW_INPUT))
End Property

Private Property ConsoleType.OutputCodePage() As Long
	Return GetConsoleOutputCP()
End Property

Private Property ConsoleType.OutputCodePage(v As Long)
	SetConsoleOutputCP v
End Property

Private Property ConsoleType.OutputModeProcessed() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdOut, @ret
	Return ((ret And ENABLE_PROCESSED_OUTPUT) = ENABLE_PROCESSED_OUTPUT)
End Property

Private Property ConsoleType.OutputModeProcessed(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdOut, @ret
	SetConsoleMode m_StdOut, IIf(v, ret Or ENABLE_PROCESSED_OUTPUT, ret And (Not ENABLE_PROCESSED_OUTPUT))
End Property

Private Property ConsoleType.OutputModeWrapAtEol() As Boolean
	Dim ret As Long
	GetConsoleMode m_StdOut, @ret
	Return ((ret And ENABLE_WRAP_AT_EOL_OUTPUT) = ENABLE_WRAP_AT_EOL_OUTPUT)
End Property

Private Property ConsoleType.OutputModeWrapAtEol(v As Boolean)
	Dim ret As Long
	GetConsoleMode m_StdOut, @ret
	SetConsoleMode m_StdOut, IIf(v, ret Or ENABLE_WRAP_AT_EOL_OUTPUT, ret And (Not ENABLE_WRAP_AT_EOL_OUTPUT))
End Property

Private Property ConsoleType.StdErr() As HANDLE
	Return m_StdErr
End Property

Private Property ConsoleType.StdErr(v As HANDLE)
	SetStdHandle STD_ERROR_HANDLE, v
	m_StdErr = GetStdHandle(STD_ERROR_HANDLE)
End Property

Private Property ConsoleType.StdIn As HANDLE
	Return m_StdIn
End Property
Private Property ConsoleType.StdIn(v As HANDLE)
	SetStdHandle STD_INPUT_HANDLE, v
	m_StdIn = GetStdHandle(STD_INPUT_HANDLE)
End Property

Private Property ConsoleType.StdOut As HANDLE
	Return m_StdOut
End Property
Private Property ConsoleType.StdOut(v As HANDLE)
	SetStdHandle STD_OUTPUT_HANDLE, v
	m_StdOut = GetStdHandle(STD_OUTPUT_HANDLE)
End Property

Private Property ConsoleType.Title() As String
	Dim buf As WString * CONSOLE_BUFFER_MAXSIZE
	Dim ret As Long
	buf = String(CONSOLE_BUFFER_MAXSIZE, Chr(0))
	ret = GetConsoleTitle(StrPtr(buf), CONSOLE_BUFFER_MAXSIZE)
	Return Left(buf, ret + 1)
End Property

Private Property ConsoleType.Title(ByVal v As String)
	SetConsoleTitle v
End Property

Private Property ConsoleType.ViewHeight() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.srWindow.Bottom - tmp.srWindow.Top + 1
End Property

Private Property ConsoleType.ViewHeightMax() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwMaximumWindowSize.Y
End Property

Private Property ConsoleType.ViewWidth() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.srWindow.Right - tmp.srWindow.Left + 1
End Property

Private Property ConsoleType.ViewWidthMax() As Integer
	Dim tmp As CONSOLE_SCREEN_BUFFER_INFO
	GetConsoleScreenBufferInfo m_StdOut, @tmp
	Return tmp.dwMaximumWindowSize.X
End Property

Private Sub ConsoleType.ConsoleSize(cols As Long, lines As Long)
	Shell "MODE CON: COLS="+Str(cols)+ "LINES="+Str(lines)
End Sub

Private Sub ConsoleType.FontSize(w As Long, h As Long, fName As String = "consolas")
	Dim As  _CONSOLE_FONT_INFOEX  x
	With x
		.cbSize = SizeOf(_CONSOLE_FONT_INFOEX)
		.nFont = 0
		.dwFontSize = Type(w, h)
		.FontFamily = 0
		.FontWeight = 100
		.FaceName= fName
	End With
	SetCurrentConsoleFontEx(m_StdOut, 1, @x )
End Sub

Private Sub ConsoleType.Clear(ByVal pToDefault As Boolean = False)
	FillText 0, 0, BufferWidth * BufferHeight, 32
	If pToDefault Then
		FillTextAttribute 0, 0, BufferWidth * BufferHeight, m_DefaultForeColor, m_DefaultBackColor, False
		ForeColor = m_DefaultForeColor
		BackColor = m_DefaultBackColor
	End If
	MoveCursor 0, 0
End Sub

Private Function ConsoleType.FillRectText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pChar As Byte) As Long
	Dim i As Integer, ret As Long
	ClipRect pCol, pRow, pWidth, pHeight, BufferWidth - 1, BufferHeight - 1
	If pWidth <= 0 Or pHeight <= 0 Then Exit Function
	For i = pRow To pRow + pHeight - 1
		ret = ret + FillText(i, pCol, pWidth, pChar)
	Next
	Return ret
End Function

Private Function ConsoleType.FillRectAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	Dim i As Integer, ret As Long
	ClipRect pCol, pRow, pWidth, pHeight, BufferWidth - 1, BufferHeight - 1
	If pWidth = 0 Or pHeight = 0 Then Exit Function
	For i = pRow To pRow + pHeight - 1
		ret = ret + FillTextAttribute(i, pCol, pWidth, pForeColor, pBackColor, pReverseColor)
	Next
	Return ret
End Function

Private Function ConsoleType.FillRectEx(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pChar As Byte, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	FillRectText pRow, pCol, pWidth, pHeight, pChar
	Return FillRectAttribute(pRow, pCol, pWidth, pHeight, pForeColor, pBackColor, pReverseColor)
End Function

Private Function ConsoleType.FillText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pChar As Byte) As Long
	Dim ret As Long
	If pRow < 0 Or pCol < 0 Then Exit Function
	FillConsoleOutputCharacter m_StdOut, pChar, pCount, Type<COORD>(pRow, pCol), @ret
	Return ret
End Function

Private Function ConsoleType.FillTextAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	Dim ret As Long, attr As Long
	If pRow < 0 Or pCol < 0 Then Exit Function
	attr = MakeAttribute(pForeColor, pBackColor, pReverseColor)
	FillConsoleOutputAttribute m_StdOut, attr, pCount, Type<COORD>(pRow, pCol), @ret
	Return ret
End Function

Private Function ConsoleType.FillTextEx(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pChar As Byte, ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Long
	FillText pRow, pCol, pCount, pChar
	Return FillTextAttribute(pRow, pCol, pCount, pForeColor, pBackColor, pReverseColor)
End Function

Private Function ConsoleType.MakeAttribute(ByVal pForeColor As Integer, ByVal pBackColor As Integer, ByVal pReverseColor As Integer) As Integer
	Dim ret As Integer
	If pReverseColor Then ret = ret Or COMMON_LVB_REVERSE_VIDEO
	ret = ret Or (pForeColor And &HF)
	ret = ret Or ((pBackColor And &HF) * &H10)
	Return ret
End Function

Private Sub ConsoleType.MoveCursor(ByVal pRow As Integer, ByVal pCol As Integer)
	SetConsoleCursorPosition m_StdOut, Type<COORD>(pRow, pCol)
End Sub

Private Sub ConsoleType.ReadBufferAttribute(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, buf() As Long)
	Dim ret As Long
	If pCount <= 0 Then Exit Sub
	ReDim buf(pCount - 1) As Long
	ReadConsoleOutputAttribute m_StdOut, Cast(LPWORD, @buf(0)), pCount, Type<COORD>(pRow, pCol), @ret
	ReDim Preserve buf(ret - 1) As Long
End Sub

Private Function ConsoleType.ReadBufferText(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer) As String
	Dim buf As String, ret As Long
	If pCount <= 0 Then Exit Function
	buf = String(pCount, Chr(0))
	ReadConsoleOutputCharacter m_StdOut, buf, pCount, Type<COORD>(pRow, pCol), @ret
	Return Left(buf, ret)
End Function

Private Function ConsoleType.ReadKey() As Integer
	Dim buf As INPUT_RECORD
	Dim ret As Long
	FlushConsoleInputBuffer m_StdIn
	Do While True
		ReadConsoleInput m_StdIn, @buf, 1, @ret
		If ret = 1 And buf.EventType = KEY_EVENT Then Exit Do
	Loop
	Return buf.Event.KeyEvent.wVirtualKeyCode
End Function

Private Function ConsoleType.ReadLine(ByRef pPrompt As WString = "") As String
	Dim buf As WString * CONSOLE_BUFFER_MAXSIZE
	Dim ret As Long
	If pPrompt <> "" Then WriteText pPrompt
	buf = String(CONSOLE_BUFFER_MAXSIZE, Chr(0))
	ReadConsole m_StdIn, StrPtr(buf), CONSOLE_BUFFER_MAXSIZE, @ret, 0
	Return Left(buf, ret - 2)
End Function

Private Function ConsoleType.ReadPassword(ByRef pPrompt As String = "") As String
	Dim buf As WString * CONSOLE_BUFFER_MAXSIZE
	Dim ret As Long, preEchoFlag As Boolean
	If pPrompt <> "" Then WriteText pPrompt
	preEchoFlag = InputModeEcho
	InputModeEcho = False
	buf = String(CONSOLE_BUFFER_MAXSIZE, Chr(0))
	ReadConsole m_StdIn, StrPtr(buf), CONSOLE_BUFFER_MAXSIZE, @ret, 0
	InputModeEcho = preEchoFlag
	Return Left(buf, ret - 2)
End Function

Private Function ConsoleType.ReverseTextColor(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pCount As Integer, ByVal pReverse As Boolean) As Long
	Dim attr() As Long
	Dim i As Long, c As Long
	ReadBufferAttribute(pRow, pCol, pCount, attr())
	c = UBound(attr)
	If pReverse Then
		For i = 0 To c
			attr(i) = attr(i) Or COMMON_LVB_REVERSE_VIDEO
		Next
	Else
		For i = 0 To c
			attr(i) = attr(i) And (Not COMMON_LVB_REVERSE_VIDEO)
		Next
	End If
	WriteBufferAttribute pRow, pCol, attr(), c
	Return c
End Function

Private Function ConsoleType.ReverseRectColor(ByVal pRow As Integer, ByVal pCol As Integer, ByVal pWidth As Integer, ByVal pHeight As Integer, ByVal pReverse As Boolean) As Long
	Dim i As Integer, ret As Long
	If pWidth < 0 Or pHeight < 0 Then Exit Function
	For i = pRow To pRow + pHeight - 1
		ret = ret + ReverseTextColor(i, pCol, pWidth, pReverse)
	Next
	Return ret
End Function

Private Sub ConsoleType.SetViewSize(ByVal pWidth As Integer, ByVal pHeight As Integer)
	Dim tmp As SMALL_RECT
	tmp.Right = pWidth - 1
	tmp.Bottom = pHeight - 1
	SetConsoleWindowInfo m_StdOut, True, @tmp
End Sub

Private Sub ConsoleType.SplitAttribute(ByVal pAttribute As Integer, ByRef pForeColor As Integer, ByRef pBackColor As Integer, ByRef pReverseColor As Boolean)
	pForeColor = pAttribute And &HF
	pBackColor = (pAttribute And &HF0) \ &H10
	pReverseColor = ((pAttribute And COMMON_LVB_REVERSE_VIDEO) = COMMON_LVB_REVERSE_VIDEO)
End Sub

Private Function ConsoleType.LenB(ByRef pStr As WString) As Long
	Dim As String tStr = pStr
	Return Len(pStr)
End Function

Private Function ConsoleType.WriteBufferAttribute(ByVal pRow As Integer, ByVal pCol As Integer, pAttributes() As Long, ByVal pCount As Integer) As Long
	Dim ret As Long
	If pCount <= 0 Then Exit Function
	If UBound(pAttributes) < 0 Then Exit Function
	WriteConsoleOutputAttribute m_StdOut, Cast(LPWORD, @pAttributes(0)), pCount, Type<COORD>(pRow, pCol), @ret
	Return ret
End Function

Private Function ConsoleType.WriteLine(ByRef pBuf As WString = "") As Long
	Dim ret As Long
	ret = WriteText(pBuf)
	ret = ret + WriteText(Chr(13, 10))
	Return ret
End Function

Private Function ConsoleType.WriteLineEx(ByRef pBuf As WString, ByVal pForeColor As Integer = -1, ByVal pBackColor As Integer = -1) As Long
	Dim ret As Long, foreIsSet As Boolean, backIsSet As Boolean
	Dim preForeColor As Integer, preBackColor As Integer
	foreIsSet = pForeColor > -1
	backIsSet = pBackColor > -1
	If foreIsSet Then
		preForeColor = ForeColor
		ForeColor = pForeColor
	End If
	If backIsSet Then
		preBackColor = BackColor
		BackColor = pBackColor
	End If
	ret = WriteLine(pBuf)
	If foreIsSet Then ForeColor = preForeColor
	If backIsSet Then BackColor = preBackColor
	Return ret
End Function

Private Function ConsoleType.WriteText(ByRef pBuf As WString) As Long
	Dim ret As Long
	If pBuf = "" Then Exit Function
	WriteConsole m_StdOut, StrPtr(pBuf), LenB(pBuf), @ret, 0
	Return ret
End Function

Private Function ConsoleType.WriteTextEx(ByRef pBuf As WString, ByVal pForeColor As Integer = -1, ByVal pBackColor As Integer = -1) As Long
	Dim ret As Long, foreIsSet As Boolean, backIsSet As Boolean
	Dim preForeColor As Integer, preBackColor As Integer
	foreIsSet = pForeColor > -1
	backIsSet = pBackColor > -1
	If foreIsSet Then
		preForeColor = ForeColor
		ForeColor = pForeColor
	End If
	If backIsSet Then
		preBackColor = BackColor
		BackColor = pBackColor
	End If
	ret = WriteText(pBuf)
	If foreIsSet Then ForeColor = preForeColor
	If backIsSet Then BackColor = preBackColor
	Return ret
End Function
