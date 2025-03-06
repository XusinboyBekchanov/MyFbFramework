#ifdef __FB_WIN32__
	'#Compile -exx "Form2.rc"
#else
	'#Compile -exx
#endif
#include once "mff/Form.bi"
#include once "mff/CommandButton.bi"
#include once "mff/TimerComponent.bi"

Using My.Sys.Forms

'#Region "Form"
    Type Form1 Extends Form
    	Declare Sub cmdStartTimer_Click(ByRef Sender As Control)
    	Declare Sub cmdEndTimer_Click(ByRef Sender As Control)
    	Declare Sub TimerComponent1_Timer(ByRef Sender As TimerComponent)
    	Declare Constructor
        
    	Dim As CommandButton cmdStartTimer, cmdEndTimer
    	Dim As TimerComponent TimerComponent1
    End Type
    
    Constructor Form1
    	' Form1
    	With This
    		.Name = "Form1"
    		.Text = "Form1"
    		.SetBounds 0, 0, 350, 300
    	End With
    	' cmdStartTimer
    	With cmdStartTimer
    		.Name = "cmdStartTimer"
    		.Text = "Start timer"
    		.SetBounds 80, 140, 72, 48
    		.Designer = @This
    		.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdStartTimer_Click)
    		.Parent = @This
    	End With
    	' TimerComponent1
    	With TimerComponent1
    		.Name = "TimerComponent1"
    		.SetBounds 48, 62, 16, 16
    		.Interval = 10
    		.Designer = @This
    		.OnTimer = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent), @TimerComponent1_Timer)
    		.Parent = @This
    	End With
    	' cmdEndTimer
    	With cmdEndTimer
    		.Name = "cmdEndTimer"
    		.Text = "End timer"
    		.SetBounds 160, 136, 72, 48
    		.Designer = @This
    		.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdEndTimer_Click)
    		.Parent = @This
    	End With
    End Constructor
    
    Dim Shared fForm1 As Form1
    
    #ifndef _NOT_AUTORUN_FORMS_
    	App.DarkMode= True 
        fForm1.Show        
        App.Run
    #endif
'#End Region

Private Sub Form1.cmdStartTimer_Click(ByRef Sender As Control)
	fForm1.TimerComponent1.Enabled = True
End Sub

Private Sub Form1.cmdEndTimer_Click(ByRef Sender As Control)
	fForm1.TimerComponent1.Enabled = False
End Sub

Private Sub Form1.TimerComponent1_Timer(ByRef Sender As TimerComponent)
	?1
End Sub