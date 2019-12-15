#Include Once "PrintPreviewDialog.bi"

PROPERTY PrintPreviewDialog.Left() AS integer: RETURN xLeft: END PROPERTY

PROPERTY PrintPreviewDialog.Left(value AS integer): xLeft=value: END PROPERTY
PROPERTY PrintPreviewDialog.Top() AS integer: RETURN xTop: END PROPERTY
PROPERTY PrintPreviewDialog.Top(value AS integer): xTop=value: END PROPERTY
PROPERTY PrintPreviewDialog.SetupDialog() AS integer: RETURN xSetupDialog: END PROPERTY
PROPERTY PrintPreviewDialog.SetupDialog(value AS integer)
	IF value THEN xSetupDialog=True ELSE xSetupDialog=False
END PROPERTY

Function PrintPreviewDialog.Execute As Boolean
	Return False
End Function

