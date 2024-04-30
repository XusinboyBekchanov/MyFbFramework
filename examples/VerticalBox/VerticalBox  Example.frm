'################################################################################
'#  VerticalBox Example.frm                                                   #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################
'#Region "Form"
    #if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
        #define __MAIN_FILE__
        #ifdef __FB_WIN32__
            #cmdline "Form1.rc"
        #endif
        Const _MAIN_FILE_ = __FILE__
    #endif
    #include once "mff/Form.bi"
    #include once "mff/ScrollControl.bi"
    #include once "mff/VerticalBox.bi"
    #include once "mff/CheckBox.bi"
    
    Using My.Sys.Forms
    
    Type Form1Type Extends Form
        Declare Constructor
        
        Dim As ScrollControl ScrollControl1
        Dim As VerticalBox VerticalBox1
        Dim As CheckBox CheckBox1, CheckBox2, CheckBox3, CheckBox4
    End Type
    
    Constructor Form1Type
        #if _MAIN_FILE_ = __FILE__
            With App
                .CurLanguagePath = ExePath & "/Languages/"
                .CurLanguage = .Language
            End With
        #endif
        ' Form1
        With This
            .Name = "Form1"
            .Text = "Form1"
            .Designer = @This
            .SetBounds 0, 0, 350, 300
        End With
        ' ScrollControl1
        With ScrollControl1
            .Name = "ScrollControl1"
            .Text = "ScrollControl1"
            .TabIndex = 0
            .SetBounds 40, 40, 220, 140
            .Designer = @This
            .Parent = @This
        End With
        ' VerticalBox1
        With VerticalBox1
            .Name = "VerticalBox1"
            .Text = "VerticalBox1"
            .TabIndex = 1
            .Align = DockStyle.alTop
            .SetBounds 0, 0, 220, 120
            .Designer = @This
            .Parent = @ScrollControl1
        End With
        ' CheckBox1
        With CheckBox1
            .Name = "CheckBox1"
            .Text = "CheckBox1"
            .TabIndex = 2
            .SetBounds 60, 20, 80, 20
            .Designer = @This
            .Parent = @VerticalBox1
        End With
        ' CheckBox2
        With CheckBox2
            .Name = "CheckBox2"
            .Text = "CheckBox2"
            .TabIndex = 3
            .SetBounds 130, 30, 220, 50
            .Designer = @This
            .Parent = @VerticalBox1
        End With
        ' CheckBox3
        With CheckBox3
            .Name = "CheckBox3"
            .Text = "CheckBox3"
            .TabIndex = 5
            .SetBounds 0, 80, 220, 30
            .Designer = @This
            .Parent = @VerticalBox1
        End With
        ' CheckBox4
        With CheckBox4
            .Name = "CheckBox4"
            .Text = "CheckBox4"
            .TabIndex = 7
            .SetBounds 140, 110, 220, 80
            .Designer = @This
            .Parent = @VerticalBox1
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
