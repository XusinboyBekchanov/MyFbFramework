'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Label.bi"
	#include once "mff/IconPanel.bi"
	Using My.Sys.Forms

	'IconPanel demo: a formatting bar of latching toggles (Bold, Italic,
	'Underline), separators, alignment toggles kept mutually exclusive in the
	'handler, momentary buttons and a disabled cell. The label previews the
	'chosen style.
	Type Form1Type Extends Form
		Declare Sub ipFormat_ItemClick(ByRef Sender As IconPanel, ByVal Index As Long, ByVal itemKind As IconPanelKinds, ByVal isSelected As Boolean)
		Declare Sub UpdatePreview()
		Declare Constructor

		Dim As IconPanel ipFormat
		Dim As Label lblPreview, lblInfo
		Dim As Long idxBold, idxItalic, idxUnderline, idxLeft, idxCenter, idxRight, idxBigger, idxSmaller, idxLocked
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
			.Text = "IconPanel Example"
			.Designer = @This
			.SetBounds 0, 0, 480, 300
		End With
		' ipFormat
		With ipFormat
			.Name = "ipFormat"
			.SetBounds 10, 10, 440, 36
			.Font.Size = 11
			.IconWidth = 32
			.IconHeight = 30
			idxBold = .AddItem(ikToggle, "B")
			idxItalic = .AddItem(ikToggle, "I")
			idxUnderline = .AddItem(ikToggle, "U")
			.AddSeparator
			idxLeft = .AddItem(ikToggle, "L")
			idxCenter = .AddItem(ikToggle, "C")
			idxRight = .AddItem(ikToggle, "R")
			.AddSeparator
			idxBigger = .AddItem(ikButton, "A+")
			idxSmaller = .AddItem(ikButton, "A-")
			.AddSeparator
			idxLocked = .AddItem(ikButton, "#")
			.SetEnabled idxLocked, False
			.SetSelected idxLeft, True
			.Justify = ijLeft
			.Designer = @This
			.OnItemClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As IconPanel, ByVal Index As Long, ByVal itemKind As IconPanelKinds, ByVal isSelected As Boolean), @ipFormat_ItemClick)
			.Parent = @This
		End With
		' lblPreview
		With lblPreview
			.Name = "lblPreview"
			.Text = "The quick brown fox"
			.SetBounds 20, 70, 430, 90
			.Font.Size = 14
			.Designer = @This
			.Parent = @This
		End With
		' lblInfo
		With lblInfo
			.Name = "lblInfo"
			.Text = "Click the cells of the panel"
			.SetBounds 20, 200, 430, 20
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

Private Sub Form1Type.UpdatePreview()
	With lblPreview
		.Font.Bold = ipFormat.GetSelected(idxBold)
		.Font.Italic = ipFormat.GetSelected(idxItalic)
		.Font.Underline = ipFormat.GetSelected(idxUnderline)
		If ipFormat.GetSelected(idxCenter) Then
			.Alignment = taCenter
		ElseIf ipFormat.GetSelected(idxRight) Then
			.Alignment = taRight
		Else
			.Alignment = taLeft
		End If
	End With
End Sub

Private Sub Form1Type.ipFormat_ItemClick(ByRef Sender As IconPanel, ByVal Index As Long, ByVal itemKind As IconPanelKinds, ByVal isSelected As Boolean)
	Select Case Index
	Case idxLeft, idxCenter, idxRight
		'Alignment works like a radio group: exactly one stays selected
		Sender.SetSelected idxLeft, (Index = idxLeft)
		Sender.SetSelected idxCenter, (Index = idxCenter)
		Sender.SetSelected idxRight, (Index = idxRight)
	Case idxBigger
		If lblPreview.Font.Size < 40 Then lblPreview.Font.Size = lblPreview.Font.Size + 2
	Case idxSmaller
		If lblPreview.Font.Size > 8 Then lblPreview.Font.Size = lblPreview.Font.Size - 2
	End Select
	UpdatePreview
	lblInfo.Text = "Item " & Index & " """ & Sender.GetGlyph(Index) & """ " & IIf((itemKind = ikToggle), IIf(isSelected, "selected", "unselected"), "clicked") & ", font size " & lblPreview.Font.Size
End Sub
