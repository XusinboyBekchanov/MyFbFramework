'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Progress.bi"
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Constructor
		
		Dim As Progress pSolid, pGrad, pBlocks, pVert, pMarquee, pError
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
			.SetBounds 0, 0, 467, 470
		End With
	With pSolid
		.Name = "pSolid"
		.SetBounds 20, 15, 380, 22
		.Position = 40
		.Designer = @This
		.Parent = @This
	End With
	With pGrad
		.Name = "pGrad"
		.SetBounds 20, 50, 380, 22
		.FillStyle = pfGradient
		.TextMode = ptPercent
		.Position = 65
		.Designer = @This
		.Parent = @This
	End With
	With pBlocks
		.Name = "pBlocks"
		.SetBounds 20, 85, 380, 22
		.Segmented = True
		.Position = 55
		.Designer = @This
		.Parent = @This
	End With
	With pVert
		.Name = "pVert"
		.SetBounds 20, 120, 22, 150
		.Orientation = poVertical
		.Thickness = 22
		.Position = 70
		.Designer = @This
		.Parent = @This
	End With
	With pMarquee
		.Name = "pMarquee"
		.SetBounds 60, 120, 340, 22
		.Mode = pmIndeterminate
		.Designer = @This
		.Parent = @This
	End With
	With pError
		.Name = "pError"
		.SetBounds 60, 155, 340, 22
		.State = psError
		.FillStyle = pfGradient
		.TextMode = ptCustom
		.Text = "Upload failed"
		.Position = 30
		.Designer = @This
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
