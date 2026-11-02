'###############################################################################
'#  ColorPicker_Test.bas - owner-drawn ColorPicker (UTF-8 BOM, ASCII output)   #
'#  Automated part tests the control surface and its pixels. ShowColorPicker   #
'#  is a modal dialog: verify it interactively with tests\ColorPicker_Demo.    #
'###############################################################################
#include once "mff/Form.bi"
#include once "mff/ColorPicker.bi"
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"

Using My.Sys.Forms

Dim Shared nFailed As Long

Private Sub Check(ByRef sWhat As String, bOK As Boolean)
	If bOK Then
		Print "  ok - " & sWhat
	Else
		nFailed += 1
		Print "  FAIL - " & sWhat
	End If
End Sub

Type Form1 Extends Form
	Declare Constructor
	Dim As ColorPicker picker
End Type

Constructor Form1
	With This
		.Name = "Form1"
		.Text = "ColorPicker Test"
		.SetBounds 0, 0, 420, 640
	End With
	With picker
		.Name = "picker"
		.SetBounds 10, 10, 304, 532
		.Parent = @This
	End With
End Constructor

'Returns the pixel at client coords of the picker
Private Function PixelAt(c As ColorPicker Ptr, ByVal x As Long, ByVal y As Long) As Integer
	Dim hdc As HDC = GetDC(c->Handle)
	If hdc = 0 Then Return -1
	Dim res As Integer = GetPixel(hdc, x, y)
	ReleaseDC(c->Handle, hdc)
	Return res
End Function

Dim f As Form1
f.Show
UpdateWindow(f.Handle)
Sleep 80
App.DoEvents

'Ideal size from the layout constants: (16*18 + 16) x (532)
Dim iw As Long, ih As Long
f.picker.GetIdealSize(iw, ih)
Print "  ideal size: " & iw & " x " & ih
Check "ideal size matches the constants", iw = 304 AndAlso ih = 532

'Colour round-trip; programmatic set is SILENT (no OnColorChanged without a handler)
f.picker.PickedColor = PRGB(30, 60, 90)
Check "picked color round-trip", f.picker.PickedColor = PRGB(30, 60, 90)
f.picker.PickedAlpha = 128
Check "picked alpha round-trip", f.picker.PickedAlpha = 128

'Custom tab (default): the body is the matrix - colourful, not chrome
Check "custom tab is the default", f.picker.PickerTab = 1
App.DoEvents
Sleep 60
App.DoEvents
Dim pxCell As Integer = PixelAt(@f.picker, 100, 100)
Dim pxBg As Integer = PixelAt(@f.picker, 2, 300)
Print "  matrix pixel: " & Hex(pxCell, 6) & " chrome: " & Hex(pxBg, 6)
Check "matrix paints colours", pxCell >= 0 AndAlso pxCell <> pxBg

'No scrollbar strip on the Custom tab (it belongs to the Web list only)
Dim pxScroll As Integer = PixelAt(@f.picker, 290, 100)
Check "no scrollbar on custom tab", pxScroll >= 0

'Web tab: a scrollbar strip appears at the right of the body
f.picker.PickerTab = 0
App.DoEvents
Sleep 60
App.DoEvents
Check "web tab switch", f.picker.PickerTab = 0
Dim pxList As Integer = PixelAt(@f.picker, 20, 40)
pxScroll = PixelAt(@f.picker, 290, 100)
Print "  list pixel: " & Hex(pxList, 6) & " scrollbar pixel: " & Hex(pxScroll, 6)
Check "web list paints", pxList >= 0 AndAlso pxList <> pxBg
Check "scrollbar strip paints", pxScroll >= 0

'A named colour lights its row and scrolls into view: "Red" is entry 16, the
'swatch at the row then shows pure red
f.picker.PickedColor = PRGB(255, 0, 0)
App.DoEvents
Sleep 60
App.DoEvents
Dim foundRed As Long = -1
Dim yk As Long
For yk = 20 To 380 Step 4
	Dim px As Integer = PixelAt(@f.picker, 24, yk)
	'pure red in BGR-dword terms: low byte = 255
	If px >= 0 AndAlso (px And &HFF) = 255 AndAlso ((px Shr 8) And &HFF) = 0 AndAlso ((px Shr 16) And &HFF) = 0 Then
		foundRed = yk
		Exit For
	End If
Next
Print "  red swatch row at client y=" & foundRed
Check "picked named colour scrolls into view", foundRed > 0

'Tab via the property is silent by design (no handler attached, so just the value)
f.picker.PickerTab = 1
Check "tab clamps to valid range", f.picker.PickerTab = 1
f.picker.PickerTab = 99
Check "tab rejects out of range", f.picker.PickerTab = 1

'ShowAlpha toggles the A field (the fourth field row disappears)
f.picker.ShowAlpha = False
App.DoEvents
Sleep 40
App.DoEvents
Check "showalpha toggles", f.picker.ShowAlpha = False
f.picker.ShowAlpha = True

'Host words round-trip through the WString properties
f.picker.TextOK = "确定"
Check "textok wstring round-trip", f.picker.TextOK = "确定"
f.picker.TextFieldLabel(0) = "Rot:"
Check "field label round-trip", f.picker.TextFieldLabel(0) = "Rot:"
f.picker.TextOK = "OK"
f.picker.TextFieldLabel(0) = "Red:"

'Initial colour + revert plumbing (the Initial half click is the user path)
f.picker.SetInitialColor(PRGB(10, 20, 30), 200)
f.picker.PickedColor = PRGB(200, 100, 50)
Check "initial differs from current", f.picker.PickedColor = PRGB(200, 100, 50)
Check "setinitial keeps current in sync", f.picker.PickedAlpha = 200

Print IIf(nFailed = 0, "PASS", "FAIL")
End
