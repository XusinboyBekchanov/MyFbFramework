#include once "PrintPreviewDialog.bi"

'Property PrintPreviewDialog.Left() As Integer: Return xLeft: End Property

'Property PrintPreviewDialog.Left(value As Integer): xLeft=value: End Property
'Property PrintPreviewDialog.Top() As Integer: Return xTop: End Property
'Property PrintPreviewDialog.Top(value As Integer): xTop=value: End Property
Private Property PrintPreviewDialog.SetupDialog() As Integer: Return xSetupDialog: End Property
Private Property PrintPreviewDialog.SetupDialog(value As Integer)
	If value Then xSetupDialog=True Else xSetupDialog=False
End Property

Private Function PrintPreviewDialog.Execute As Boolean
	Return False
End Function

Private Constructor PrintPreviewDialog
	WLet(FClassName, "PrintPreviewDialog")
End Constructor
