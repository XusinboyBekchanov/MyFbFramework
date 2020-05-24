#include once "Dialogs.bi"

Type PrintPreviewDialog Extends Dialog
Private:
	xLeft As Integer        = -1                        ' Default to center
	xTop As Integer         = -1
	xWidth As Integer                                    ' Not used
	xHeight As Integer                                   ' Not used
	
Public:
	Caption As String       = ""
	
	xSetupDialog As Integer = False                     ' SetupDialog or PrintDialog
	PrinterName As String
	AllowToFile As Integer      = True
	AllowToNetwork As Integer   = True
	ShowHelpButton As Integer   = False
	HelpFile As String      = ""
	FromPage As Integer     = 1
	ToPage As Integer       = 3
	
	'Declare Property Left() As Integer
	'Declare Property Left(value As Integer)
	'Declare Property Top() As Integer
	'Declare Property Top(value As Integer)
	Declare Property SetupDialog() As Integer
	Declare Property SetupDialog(value As Integer)
	
	Declare Function Execute() As Boolean
	Declare Constructor
	
End Type

#ifndef __USE_MAKE__
	#include once "PrintPreviewDialog.bas"
#endif
