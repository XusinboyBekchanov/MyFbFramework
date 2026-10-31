'AllControlsDemo: the other controls on Windows, Linux, Web (WASM) and Android.
'Web:     in VisualFBEditor choose the WASM define and compile; open the resulting .html through an HTTP server.
'Android: put this file into app/src/main/bas/Form1.bas of an "Android Project" and build it with gradlew.
#ifdef __FB_ANDROID__
	#define package mff_example_application
#endif

#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
	#define __MAIN_FILE__
	#ifdef __FB_WIN32__
		#cmdline "Form1.rc"
	#endif
	Const _MAIN_FILE_ = __FILE__
#endif

#if defined(__FB_JS__) OrElse defined(__USE_COCOA__) OrElse defined(__USE_UIKIT__)
	#define OnClient
#else
	#define OnServer
#endif

#ifdef OnClient
	#include once "mff/Form.bi"
	#include once "mff/Label.bi"
	#include once "mff/ToolBar.bi"
	#include once "mff/StatusBar.bi"
	#include once "mff/TabControl.bi"
	#include once "mff/ListView.bi"
	#include once "mff/TreeView.bi"
	#include once "mff/ProgressBar.bi"
	#include once "mff/TrackBar.bi"
	#include once "mff/NumericUpDown.bi"
	#include once "mff/DateTimePicker.bi"
	#include once "mff/CheckedListBox.bi"
	#include once "mff/LinkLabel.bi"
	#include once "mff/TimerComponent.bi"
	Using My.Sys.Forms
	Type Form1Type Extends Form
		Declare Static Sub tb_ButtonClick(ByRef Designer As My.Sys.Object, ByRef Sender As ToolBar, ByRef Button As ToolButton)
		Declare Static Sub tc_SelChange(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, NewIndex As Integer)
		Declare Static Sub lv_SelectedItemChanged(ByRef Designer As My.Sys.Object, ByRef Sender As ListView, ByVal ItemIndex As Integer)
		Declare Static Sub tv_NodeClick(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		Declare Static Sub trb_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer)
		Declare Static Sub nud_Change(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDown)
		Declare Static Sub dtp_DateTimeChanged(ByRef Designer As My.Sys.Object, ByRef Sender As DateTimePicker)
		Declare Static Sub clb_Change(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
		Declare Static Sub tmr_Timer(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Constructor
		Dim As ToolBar tb
		Dim As StatusBar sb
		Dim As TabControl tc
		Dim As TabPage Ptr tpList, tpTree, tpInput
		Dim As ListView lv
		Dim As TreeView tv
		Dim As Label lbl
		Dim As ProgressBar pb
		Dim As TrackBar trb
		Dim As NumericUpDown nud
		Dim As DateTimePicker dtp
		Dim As CheckedListBox clb
		Dim As LinkLabel ll
		Dim As TimerComponent tmr
	End Type
	Constructor Form1Type
		This.Name = "Form1": This.Text = "Барча контроллар": This.SetBounds 0, 0, 460, 420
		tb.Name = "tb": tb.Align = DockStyle.alTop: tb.Height = 30: tb.OnButtonClick = @tb_ButtonClick: tb.Parent = @This
		tb.Buttons.Add tbsAutosize, , , , "start", "Бошлаш"
		tb.Buttons.Add tbsAutosize, , , , "stop", "Тўхтатиш"
		tb.Buttons.Add tbsSeparator
		tb.Buttons.Add Cast(ToolButtonStyle, tbsAutosize Or tbsCheck), , , , "check", "Белги"
		sb.Name = "sb": sb.Align = DockStyle.alBottom: sb.Parent = @This
		sb.Add "Тайёр", 200
		sb.Add "0 %", 80
		tc.Name = "tc": tc.SetBounds 10, 40, 430, 280: tc.OnSelChange = @tc_SelChange: tc.Parent = @This
		tpList = tc.AddTab("Рўйхат")
		tpTree = tc.AddTab("Дарахт")
		tpInput = tc.AddTab("Киритиш")
		lv.Name = "lv": lv.Align = DockStyle.alClient: lv.OnSelectedItemChanged = @lv_SelectedItemChanged: lv.Parent = tpList
		lv.Columns.Add "Шаҳар", , 150
		lv.Columns.Add "Вилоят", , 150
		lv.ListItems.Add("Тошкент")->Text(1) = "Тошкент"
		lv.ListItems.Add("Самарқанд")->Text(1) = "Самарқанд"
		lv.ListItems.Add("Хива")->Text(1) = "Хоразм"
		tv.Name = "tv": tv.Align = DockStyle.alClient: tv.OnNodeClick = @tv_NodeClick: tv.Parent = tpTree
		Dim As TreeNode Ptr Node = tv.Nodes.Add("Мевалар")
		Node->Nodes.Add "Олма"
		Node->Nodes.Add "Нок"
		Node = tv.Nodes.Add("Сабзавотлар")
		Node->Nodes.Add "Сабзи"
		lbl.Name = "lbl": lbl.Text = "-": lbl.SetBounds 10, 10, 400, 20: lbl.Parent = tpInput
		trb.Name = "trb": trb.SetBounds 10, 40, 200, 30: trb.MaxValue = 100: trb.OnChange = @trb_Change: trb.Parent = tpInput
		nud.Name = "nud": nud.SetBounds 220, 40, 100, 24: nud.MaxValue = 1000: nud.OnChange = @nud_Change: nud.Parent = tpInput
		dtp.Name = "dtp": dtp.SetBounds 10, 80, 200, 24: dtp.OnDateTimeChanged = @dtp_DateTimeChanged: dtp.Parent = tpInput
		clb.Name = "clb": clb.SetBounds 220, 80, 190, 80: clb.AddItem "Бир": clb.AddItem "Икки": clb.AddItem "Уч": clb.OnChange = @clb_Change: clb.Parent = tpInput
		ll.Name = "ll": ll.Text = "<a href=""https://github.com/XusinboyBekchanov/MyFbFramework"">MyFbFramework</a>": ll.SetBounds 10, 120, 200, 24: ll.Parent = tpInput
		pb.Name = "pb": pb.SetBounds 10, 330, 430, 20: pb.Parent = @This
		tmr.Name = "tmr": tmr.Interval = 200: tmr.OnTimer = @tmr_Timer: tmr.Parent = @This
	End Constructor
	Dim Shared f As Form1Type
	Private Sub Form1Type.tb_ButtonClick(ByRef Designer As My.Sys.Object, ByRef Sender As ToolBar, ByRef Button As ToolButton)
		Select Case Button.Name
		Case "start": f.tmr.Enabled = True
		Case "stop": f.tmr.Enabled = False
		End Select
		f.sb.Panel(0)->Caption = "tb: " & Button.Caption
	End Sub
	Private Sub Form1Type.tc_SelChange(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, NewIndex As Integer)
		f.sb.Panel(0)->Caption = "tc: " & NewIndex
	End Sub
	Private Sub Form1Type.lv_SelectedItemChanged(ByRef Designer As My.Sys.Object, ByRef Sender As ListView, ByVal ItemIndex As Integer)
		If ItemIndex >= 0 Then f.sb.Panel(0)->Caption = "lv: " & Sender.ListItems.Item(ItemIndex)->Text(0)
	End Sub
	Private Sub Form1Type.tv_NodeClick(ByRef Designer As My.Sys.Object, ByRef Sender As TreeView, ByRef Item As TreeNode)
		f.sb.Panel(0)->Caption = "tv: " & Item.Text
	End Sub
	Private Sub Form1Type.trb_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer)
		f.lbl.Text = "trb: " & Position
		f.pb.Position = Position
	End Sub
	Private Sub Form1Type.nud_Change(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDown)
		f.lbl.Text = "nud: " & Sender.Text
	End Sub
	Private Sub Form1Type.dtp_DateTimeChanged(ByRef Designer As My.Sys.Object, ByRef Sender As DateTimePicker)
		f.lbl.Text = "dtp: " & Format(Sender.SelectedDate, "dd.mm.yyyy")
	End Sub
	Private Sub Form1Type.clb_Change(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
		f.lbl.Text = "clb: " & f.clb.Item(Sender.ItemIndex) & " = " & f.clb.Checked(Sender.ItemIndex)
	End Sub
	Private Sub Form1Type.tmr_Timer(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		f.pb.Position = (f.pb.Position + 5) Mod 101
		f.sb.Panel(1)->Caption = f.pb.Position & " %"
	End Sub
	f.Show
	App.Run
#endif
	
#ifdef OnServer
	#include once "mff/Form.bi"
	#include once "mff/HTTPServer.bi"
	
	Using My.Sys.Forms
	
	Type frmServerType Extends Form
		Declare Constructor
		
		Dim As HTTPServer Server
	End Type
	
	Constructor frmServerType
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = .Language
			End With
		#endif
		' Form1
		With This
			.Name = "frmServer"
			.Text = "Server"
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
		With Server
			Server.Name = "Server"
			Server.Address = "127.0.0.1"
			Server.Port = 8000
			Server.Designer = @This
			Server.Run
		End With
	End Constructor
	
	Dim Shared frmServer As frmServerType
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		frmServer.MainForm = True
		frmServer.Show
		App.Run
	#endif
#endif