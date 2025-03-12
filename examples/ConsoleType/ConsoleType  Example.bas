'###############################################################################
'#  Console Example                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "mff/Console.bi"
#include once "mff/NoInterface.bi"
Dim As ConsoleType Console

Console.BackColor = clGreen
Console.ForeColor = clRed
Console.Title = "VisualFBEditor - Console Example"
'MsgBox Console.Title

' Print Heart shape   打印心形图案
Dim As Single a, x, y
Dim As String LineStr
For y = 1.5 To -1.5 Step -0.1
	LineStr = ""
	For x = -1.5 To 15 Step 0.05
		a = x*x + y*y - 1
		' 这里的@符号即为打印出的心形图案符号, 可更改
		LineStr += IIf(a * a * a - x * x * y * y * y <= 0.0, "@", " ")
	Next
	If Trim(LineStr) <> "" Then Console.WriteLine(Mid(LineStr, 5, 60))
Next

Dim As Long outCodePage = Console.OutputCodePage
Console.WriteLine "Press any key to continue..."
Console.ReadKey
Console.Clear
Console.BackColor = clGreen
Console.FontSize(15, 20)
Console.WriteLine " output CodePage = " & Str(outCodePage)
Console.WriteLine " Input CodePage = " & Console.InputCodePage
Debug.Print "Input CodePage = " & Console.InputCodePage, True
'Console.OutputCodePage= 936
Console.FillTextAttribute(1, 4, 20, clYellow, clGray, clDarkBlue)
Console.WriteLine " view width=" &  Console.ViewWidth & "  view height=" &  Console.ViewHeight
Console.WriteLine " view widthMax=" &  Console.ViewWidthMax & "  view heightMax=" &  Console.ViewHeightMax
Console.WriteLine "Press any key to continue..."
Debug.Print 12345
Debug.Print " Set Col Row = 20, 30", True
Console.ReadKey
Console.WriteLine " Set Col Row = 20, 30"
Console.ConsoleSize(60, 30)
Console.WriteLine " view width=" &  Console.ViewWidth & "  view height=" &  Console.ViewHeight
Console.WriteLine " view widthMax=" &  Console.ViewWidthMax & "  view heightMax=" &  Console.ViewHeightMax


Console.InputModeLine= True
'Console.FillTextEx(10, 5, 212, 58, clYellow, clPink, clCyan)
'Dim As String YourName = Console.ReadLine("输入你的名字: ")
Dim As String YourName = Console.ReadLine("Please input your name: ")

Console.WriteLine "Hello, " & YourName
'Console.WriteLine "任意键退出程序" 
Console.WriteLine "Press any key to continue..."

Console.ReadKey

Console.WriteLine


