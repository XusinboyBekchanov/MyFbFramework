'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms

	Type Form1Type Extends Form
		Declare Sub cmdStartTest_Click(ByRef Sender As Control)
		Declare Sub cmdClear_Click(ByRef Sender As Control)
		Declare Constructor
		Declare Sub TestGlobalSubString()
		Declare Sub TestUStringSubString
		Dim As TextBox txtResult
		Dim As CommandButton cmdStartTest, cmdClear
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 730, 610
		End With
		' txtResult
		With txtResult
			.Name = "txtResult"
			.Text = "txtResult"
			.TabIndex = 0
			.Multiline = True
			.ID = 1138
			.ScrollBars = ScrollBarsType.Both
			.Align = DockStyle.alNone
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Font.Size = 12
			.SetBounds 10, 10, 640, 560
			.Designer = @This
			.Parent = @This
		End With
		' cmdStartTest
		With cmdStartTest
			.Name = "cmdStartTest"
			.Text = "Start"
			.TabIndex = 1
			.Caption = "Start"
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asNone
			.SetBounds 660, 20, 50, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdStartTest_Click)
			.Parent = @This
		End With
		' cmdClear
		With cmdClear
			.Name = "cmdClear"
			.Text = "Clear"
			.TabIndex = 2
			.Caption = "Clear"
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asNone
			.SetBounds 660, 50, 50, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdClear_Click)
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

Sub Form1Type.TestGlobalSubString()
   Dim As WString * 512  MsgWstr = "===Test Global SubString Test 全局SubString函数 ===" 
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   Dim As WString * 20 mainStr = "Hello World" 
   
   ' Test 1: Normal substring  正常子串 
   Dim As WString * 200 result1 = SubString(mainStr, 7, 5)
   MsgWstr = "Test 1 - Normal substring  正常子串: '" & result1 & "' (Expected: 'World')" & IIf(result1 = "World", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   ' Test 2: With replacement 带替换 
   Dim As WString * 200 result2 = SubString(mainStr, 7, 5, "FreeBasic" )
   MsgWstr = "Test 2 - With replacement 带替换: '" & result2 & "' (Expected: 'Hello FreeBasic')" & IIf(result2 = "Hello FreeBasic", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   ' Test 3: Negative length 负长度 
   Dim As WString * 200 result3 = SubString(mainStr, 7, -2, "9" )
   MsgWstr = "Test 3 - Negative length 负长度: '" & result3 & "' (Expected: 'Hello9orld')" & IIf(result3 = "Hello9orld", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   ' Test 4: Out of bounds 超出边界 
   Dim As WString * 200 result4 = SubString(mainStr, 7, 10, "123")
   MsgWstr = "Test 4 - Out of bounds 超出边界: '" & result4 & "' (Expected: 'Hello 123')" & IIf(result4 = "Hello 123", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   ' Test 5: Empty string 空字符串 
   Dim As WString * 200 result5 = SubString("" , 1, 3, "Default" )
   MsgWstr =  "Test 5 - Empty string 空字符串: '" & result5 & "' (Expected: 'Default')" & IIf(result5 = "Default", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   ' Test 6: Start beyond length 超出起始
   Dim As WString * 200 result6 = SubString(mainStr, 20, 3, "Append" )
   MsgWstr = "Test 6 - Start beyond length 超出起始: '" & result6 & "' (Expected: 'Hello WorldAppend')" & IIf(result6 = "Hello WorldAppend", "    OK", "    NOT OK") + Chr(13, 10)
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
  ' Test 7: Replacement longer than replaced 大于被替换长度
   Dim As WString * 200 result7 = SubString(mainStr, 7, 1, "Good" )
   MsgWstr = "Test 7 - Replacement longer than replaced 大于被替换长度: '" & result7 & "' (Expected: 'Hello Goodorld')"  & IIf(result7 = "Hello Goodorld", "    OK", "    NOT OK") + Chr(13, 10)
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
End Sub

Sub Form1Type.TestUStringSubString()
   Dim As WString * 512 MsgWstr =  "=== Test UString.SubString方法 ===" 
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   Dim As UString  testStr = "Hello World" 
   ' Test 1: Normal substring  正常子串 
   Dim As UString result1 = testStr.SubString(7, 5)
   MsgWstr = "Test 1 - Normal substring  正常子串: '" & result1 & "' (Expected: 'World')" & IIf(result1 = "World", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   testStr = "Hello World" 
   ' Test 2: With replacement 带替换 
   Dim As UString result2 = testStr.SubString(7, 5, "FreeBasic" )
   MsgWstr = "Test 2 - With replacement 带替换: '" & result2 & "' (Expected: 'Hello FreeBasic')" & IIf(result2 = "Hello FreeBasic", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   testStr = "Hello World" 
   ' Test 3: Negative length 负长度（向左扩展） 
   Dim As UString result3 = testStr.SubString(7, -2, "9" )
   MsgWstr = "Test 3 - Negative length 负长度: '" & result3 & "' (Expected: 'Hello9orld'')" & IIf(result3 = "Hello9orld", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   testStr = "Hello World" 
   ' Test 4: Out of bounds 超出边界 
   Dim As UString result4 = testStr.SubString(7, 10, "123")
   MsgWstr = "Test 4 - Out of bounds 超出边界: '" & result4 & "' (Expected: 'Hello 123')" & IIf(result4 = "Hello 123", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   testStr = "Hello World" 
   ' Test 5: Empty string 空字符串 
   Dim As UString testStr1
   Dim As UString result5 = testStr1.SubString(1, 3, "Default" )
   MsgWstr =  "Test 5 - Empty string 空字符串: '" & result5 & "' (Expected: 'Default')" & IIf(result5 = "Default", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   testStr = "Hello World" 
  
   ' Test 6: Start beyond length 超出起始
   Dim As UString result6 = testStr.SubString(20, 3, "Append" )
   MsgWstr = "Test 6 - Start beyond length 超出起始: '" & result6 & "' (Expected: 'Hello WorldAppend')" & IIf(result6 = "Hello WorldAppend", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   testStr = "Hello World"
   ' Test 7: Replacement longer than replaced 大于被替换长度
   Dim As UString result7 = testStr.SubString(7, 1, "Good" )
   MsgWstr = "Test 7 - Replacement longer than replaced 大于被替换长度: '" & result7 & "' (Expected: 'Hello Goodorld')" & IIf(result7 = "Hello Goodorld", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
  
  ' Test 10: 链式调用 
  testStr = "Hello World" 
   testStr.SubString(7, 5, "FreeBasic" )
   MsgWstr = "Test 10 - Step 1 '" & testStr & "' (Expected: 'Hello FreeBasic')" & IIf(testStr = "Hello FreeBasic", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   testStr = "Hello FreeBasic" 
   testStr.SubString(7, 3, "World" )
   MsgWstr = "Test 10 - Step 2 '" & testStr & "' (Expected: 'Hello Worldc')" & IIf(testStr = "Hello Worldc", "    OK", "    NOT OK")
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   testStr = "Hello World" 
   testStr.SubString(7, 5, "FreeBasic" ).SubString(7, 8, "World" )
   MsgWstr = "Test 10 - 链式调用: '" & testStr & "' (Expected: 'Hello Worldc')" & IIf(testStr = "Hello Worldc", "    OK", "    NOT OK") + Chr(13, 10)
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
End Sub

Private Sub Form1Type.cmdStartTest_Click(ByRef Sender As Control)
Dim As WString * 1024 MsgWstr = "===Run Comprehensive Tests 综合测试报告 ===" + Chr(13, 10)
   Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   
   TestGlobalSubString()
   TestUStringSubString()
   '
   MsgWstr = "=== Test 性能测试  ===" 
   Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   Dim As Double startTime, endTime
   
   startTime = Timer
   For i As Integer = 1 To 10000
       Dim As UString perfTest = "Performance testing string" 
       perfTest.SubString(12, 8, "benchmark" )
   Next
   endTime = Timer
   MsgWstr = "10000次操作耗时: " & (endTime - startTime) & " 秒" 
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
   MsgWstr = "=== Test 完成 ===" + Chr(13, 10) 
   Debug.Print MsgWstr : txtResult.Text = txtResult.Text + Chr(13, 10) + MsgWstr
End Sub

Private Sub Form1Type.cmdClear_Click(ByRef Sender As Control)
	txtResult.Text = "" 
End Sub