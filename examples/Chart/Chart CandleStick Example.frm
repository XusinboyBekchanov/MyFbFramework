'Chart CandleStick Example - 股票K线图测试 (000001 SSE Composite Index Daily Data)
'测试数据: resources/000001SSE Composite Index Daily Data.csv
'功能: 红涨绿跌切换 / 成交量副图 / MA5-MA250均线 / 放大缩小(上下键+滚轮) / 左右平移(左右键+拖拽)
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1Type.rc"
		#endif
		#define __USE_GTK3__
		Const _MAIN_FILE_ = __FILE__
	#endif
'#Region "Form"
	#include once "mff/Form.bi"
	#include once "mff/Chart.bi"
	#include once "mff/Panel.bi"
	#include once "mff/CheckBox.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"

	Using My.Sys.Forms

	Type Form1Type Extends Form
		Declare Sub Form1_Create(ByRef Sender As Control)
		Declare Sub CheckBox1_Click(ByRef Sender As CheckBox)
		Declare Sub CheckBox2_Click(ByRef Sender As CheckBox)
		Declare Sub CheckBox3_Click(ByRef Sender As CheckBox)
		Declare Sub cmdLast250days_Click(ByRef Sender As Control)
		Declare Sub cmdAllData_Click(ByRef Sender As Control)
		Declare Sub cmdZoomIn_Click(ByRef Sender As Control)
		Declare Sub cmdZoomOut_Click(ByRef Sender As Control)
		Declare Sub cmdMoveLeft_Click(ByRef Sender As Control)
		Declare Sub cmdMoveRight_Click(ByRef Sender As Control)
		Declare Sub Chart1_CandleClick(ByRef Sender As Chart, Index As Long)
		Declare Constructor

		Dim As Chart Chart1
		Dim As Panel Panel1
		Dim As CheckBox CheckBox1, CheckBox2, CheckBox3, CheckBox11
		Dim As CommandButton cmdLast250days, cmdAllData, cmdZoomIn, cmdZoomOut, cmdMoveLeft, cmdMoveRight
		Dim As Label lblLoadingCSV
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
			.Text = ML("SSE Composite Index Daily Chart")
			.Designer = @This
			.SetBounds 0, 0, 1000, 660
			.OnCreate = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @Form1_Create)
		End With
		
		' Panel1 (底部工具条, 绝对布局)
		With Panel1
			.Name = "Panel1"
			.Text = "Panel1"
			.SetBounds 8, 584, 968, 42
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asAnchorProportional
			.Anchor.Left = AnchorStyle.asAnchorProportional
			'.Anchor.Bottom = AnchorStyle.asAnchorProportional
			.Designer = @This
			.Parent = @This
		End With
		' Chart1
		With Chart1
			.Name = "Chart1"
			.Text = "Chart1"
			.Title = ML("000001 Daily K-line")
			.SetBounds 8, 8, 968, 568
			.Designer = @This
			.ChartStyle = ChartStyles.CS_CandleStick
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asAnchorProportional
			.Anchor.Left = AnchorStyle.asAnchorProportional
			.Anchor.Bottom = AnchorStyle.asAnchorProportional
			.Border = False
			.LegendVisible = False
			.LabelsVisible = False
			.CandleUpRed = True
			.ShowVolume = True
			.ShowMA = True
			.VolumePanePercent = 20
			.CandleWidthPercent = 70
			.OnCandleClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Chart, Index As Long), @Chart1_CandleClick)
			.Parent = @This
		End With
		' CheckBox1
		With CheckBox1
			.Name = "CheckBox1"
			.Text = ML("Red up, green down")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 10, 11, 88, 22
			.Designer = @This
			.Checked = True
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @CheckBox1_Click)
			.Parent = @Panel1
		End With
		' CheckBox2
		With CheckBox2
			.Name = "CheckBox2"
			.Text = ML("Volume")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 110, 11, 62, 22
			.Designer = @This
			.Checked = True
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @CheckBox2_Click)
			.Parent = @Panel1
		End With
		' CheckBox3
		With CheckBox3
			.Name = "CheckBox3"
			.Text = ML("Moving Averages")
			.SetBounds 176, 11, 60, 22
			.Designer = @This
			.Checked = True
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @CheckBox3_Click)
			.Parent = @Panel1
		End With
		' cmdZoomIn 放大
		With cmdZoomIn
			.Name = "cmdZoomIn"
			.Text = ML("Zoom in")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 242, 9, 56, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdZoomIn_Click)
			.Parent = @Panel1
		End With
		' cmdZoomOut 缩小
		With cmdZoomOut
			.Name = "cmdZoomOut"
			.Text = ML("Zoom out")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 302, 9, 56, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdZoomOut_Click)
			.Parent = @Panel1
		End With
		' cmdMoveLeft 左移
		With cmdMoveLeft
			.Name = "cmdMoveLeft"
			.Text = "<<"
			.SetBounds 362, 9, 34, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdMoveLeft_Click)
			.Parent = @Panel1
		End With
		' cmdMoveRight 右移
		With cmdMoveRight
			.Name = "cmdMoveRight"
			.Text = ">>"
			.SetBounds 400, 9, 34, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdMoveRight_Click)
			.Parent = @Panel1
		End With
		' cmdLast250days 最近250日
		With cmdLast250days
			.Name = "cmdLast250days"
			.Text = ML("Last 250 days")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 442, 9, 102, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdLast250days_Click)
			.Parent = @Panel1
		End With
		' cmdAllData 全部数据
		With cmdAllData
			.Name = "cmdAllData"
			.Text = ML("All Data")
			.Font.Name = "Tahoma"
			.Font.Size = 10
			.SetBounds 548, 9, 80, 27
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdAllData_Click)
			.Parent = @Panel1
		End With
		' lblLoadingCSV
		With lblLoadingCSV
			.Name = "lblLoadingCSV"
			.Caption = ML("Loading CSV...")
			.AutoSize = True
			.SetBounds 636, 13, 302, 10
			.Designer = @This
			.Parent = @Panel1
		End With
	
		' CheckBox11
		With CheckBox11
			.Name = "CheckBox11"
			.SetBounds 20, 31, 88, 22
			.Designer = @This
			.Parent = @Panel1
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

Private Sub Form1Type.Form1_Create(ByRef Sender As Control)
	Dim As Boolean bOK
	Dim As Long i, n
	Dim paths(3) As WString * 1024
	paths(0) = ExePath & "/../../resources/000001 SSE Composite Index Daily Data.csv"
	paths(1) = ExePath & "/../resources/000001 SSE Composite Index Daily Data.csv"
	paths(2) = ExePath & "/resources/000001 SSE Composite Index Daily Data.csv"
	paths(3) = ExePath & "/000001 SSE Composite Index Daily Data.csv"
	For i = 0 To 3
		If Chart1.LoadCandlesFromCSV(paths(i)) Then
			bOK = True
			n = i
			Exit For
		End If
	Next
	If bOK Then
		Chart1.CandleStart = Chart1.CandleCount - 250
		lblLoadingCSV.Caption = n & " N=" & Chart1.CandleCount & " Start=" & Chart1.CandleStart & ML("After clicking To focus On the image: use the up/down Keys Or scroll wheel To zoom, And the Left/Right Keys Or drag To pan.")
	Else
		lblLoadingCSV.Caption = ML("CSV Load failed! Please check '000001 SSE Composite Index Daily Data.csv'")
	End If
End Sub
'
Private Sub Form1Type.CheckBox1_Click(ByRef Sender As CheckBox)
	'红涨绿跌开关: True=上涨红(中国习惯), False=上涨绿(西方习惯)
	Chart1.CandleUpRed = Sender.Checked
End Sub

Private Sub Form1Type.CheckBox2_Click(ByRef Sender As CheckBox)
	Chart1.ShowVolume = Sender.Checked
End Sub

Private Sub Form1Type.CheckBox3_Click(ByRef Sender As CheckBox)
	Chart1.ShowMA = Sender.Checked
End Sub

Private Sub Form1Type.cmdLast250days_Click(ByRef Sender As Control)
	If Chart1.CandleCount > 250 Then
		Chart1.CandleStart = Chart1.CandleCount - 250
		Chart1.CandleVisible = 0
	End If
End Sub

Private Sub Form1Type.cmdAllData_Click(ByRef Sender As Control)
	Chart1.CandleStart = 0
	Chart1.CandleVisible = 0
End Sub

Private Sub Form1Type.cmdZoomIn_Click(ByRef Sender As Control)
	Chart1.CandleZoom 0.5
End Sub
Private Sub Form1Type.cmdZoomOut_Click(ByRef Sender As Control)
	Chart1.CandleZoom 2.0
End Sub

Private Sub Form1Type.cmdMoveLeft_Click(ByRef Sender As Control)
	Dim st As Long = Chart1.CandleVisible
	If st <= 0 Then st = Chart1.CandleCount - Chart1.CandleStart
	If st < 1 Then st = 1
	Chart1.CandlePan -(st \ 10)
End Sub

Private Sub Form1Type.cmdMoveRight_Click(ByRef Sender As Control)
	Dim st As Long = Chart1.CandleVisible
	If st <= 0 Then st = Chart1.CandleCount - Chart1.CandleStart
	If st < 1 Then st = 1
	Chart1.CandlePan (st \ 10)
End Sub

Private Sub Form1Type.Chart1_CandleClick(ByRef Sender As Chart, Index As Long)
	lblLoadingCSV.Caption = ML("Clicked the K line ") & Index & " (" & Chart1.CandleMA(Index, 5) & ML(" is its MA5)")
End Sub
