#include once "Dialogs.bi"
#include once "Form.bi"
#include once "HorizontalBox.bi"
#include once "CommandButton.bi"
#include once "TrackBar.bi"
#include once "Label.bi"
#include once "PrintPreviewControl.bi"
#include once "ComboBoxEx.bi"
#include once "TextBox.bi"
#include once "PrintDialog.bi"

Using My.Sys.Forms

'Represents the raw preview part of print previewing from an application (Windows only).
Private Type PrintPreviewDialog Extends Dialog
Private:
	Declare Sub lblMinus_Click(ByRef Sender As Control)
	Declare Sub lblPlus_Click(ByRef Sender As Control)
	Declare Sub lblPrevious_Click(ByRef Sender As Control)
	Declare Sub lblNext_Click(ByRef Sender As Control)
	Declare Sub trbPercent_Change(ByRef Sender As TrackBar, Position As Integer)
	Declare Sub cboSize_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	Declare Sub cmdFitToWindow_Click(ByRef Sender As Control)
	Declare Sub cboOrientation_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	Declare Sub Form_Show(ByRef Sender As Form)
	Declare Sub cmdPrint_Click(ByRef Sender As Control)
	Declare Sub txtPageNumber_Activate(ByRef Sender As TextBox)
	Declare Sub pnlPrintPreviewControl_CurrentPageChanged(ByRef Sender As PrintPreviewControl)
	Declare Sub pnlPrintPreviewControl_Zoom(ByRef Sender As PrintPreviewControl)
	Declare Sub ChangePagesCount()
	
	Dim As Form frmDialog
	Dim As HorizontalBox hbxCommands
	Dim As CommandButton cmdPrint, cmdFitToWindow
	Dim As TrackBar trbPercent
	Dim As Label lblPercent, lblMinus, lblPlus, lblPrevious, lblNext, lblPagesCount
	Dim As PrintPreviewControl pnlPrintPreviewControl
	Dim As ComboBoxEx cboOrientation, cboSize
	Dim As TextBox txtPageNumber
	Dim As PrintDialog pdPrint
	
Public:
	#ifndef ReadProperty_Off
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
	#endif
	#ifndef WriteProperty_Off
		Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
	#endif
	Declare Property Caption ByRef As WString
	Declare Property Caption(ByRef Value As WString)
	Declare Property Document As PrintDocument Ptr
	Declare Property Document(Value As PrintDocument Ptr)
	Declare Function Execute() As Boolean
	Declare Constructor
End Type

#ifndef __USE_MAKE__
	#include once "PrintPreviewDialog.bas"
#endif
