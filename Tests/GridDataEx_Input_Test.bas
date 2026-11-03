'###############################################################################
'#  GridDataEx_Input_Test.bas                                                  #
'#  The input of GridDataEx through the messages of Windows (WM_LBUTTONDOWN,   #
'#  WM_KEYDOWN, WM_CHAR, WM_MOUSEWHEEL, WM_LBUTTONDBLCLK): the same handlers   #
'#  (GridMouseDown, GridKeyDown, ...) serve GTK, the Web and Android.          #
'#  UTF-8 BOM, ASCII output.                                                   #
'###############################################################################
#include once "mff/Form.bi"
#include once "mff/GridDataEx.bi"
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
	Dim As GridDataEx grid
End Type

Constructor Form1
	With This
		.Name = "Form1"
		.Text = "GridDataEx Input Test"
		.SetBounds 0, 0, 640, 420
	End With
	With grid
		.Name = "grid"
		.SetBounds 10, 10, 600, 360
		.Parent = @This
	End With
End Constructor

Dim Shared f As Form1

Private Function ColX(ByVal c As Long) As Long
	Return f.grid.ScaleX(f.grid.ColPos(c) / 15)
End Function

Private Function RowY(ByVal r As Long) As Long
	Return f.grid.ScaleY(f.grid.RowPos(r) / 15)
End Function

Private Function MakeXY(ByVal X As Long, ByVal Y As Long) As LPARAM
	Return (Y Shl 16) Or (X And &HFFFF)
End Function

f.Show
UpdateWindow(f.Handle)
App.DoEvents

With f.grid
	.Rows = 200
	.Cols = 6
	.FixedRows = 1
	.FixedCols = 1
	For r As Long = 1 To 199
		For c As Long = 1 To 5
			.TextMatrix(r, c) = "R" & r & "C" & c
		Next
	Next
	.AllowUserEditing = True
	.AllowUserResizing = FlexAllowUserResizingBoth
	.Row = 1
	.Col = 1
End With
App.DoEvents

Dim As HWND hGrid = f.grid.Handle
Dim As Long cx = ColX(3) + 20, cy = RowY(4) + 8

'The left button: the current cell follows the press
SendMessage(hGrid, WM_LBUTTONDOWN, MK_LBUTTON, MakeXY(cx, cy))
SendMessage(hGrid, WM_LBUTTONUP, 0, MakeXY(cx, cy))
Check "click selects the cell (row 4, col 3)", f.grid.Row = 4 AndAlso f.grid.Col = 3

'The keys
SendMessage(hGrid, WM_KEYDOWN, VK_DOWN, 0)
Check "Down moves to row 5", f.grid.Row = 5
SendMessage(hGrid, WM_KEYDOWN, VK_RIGHT, 0)
Check "Right moves to col 4", f.grid.Col = 4
SendMessage(hGrid, WM_KEYDOWN, VK_HOME, 0)
Check "Home moves to the first column", f.grid.Col = 1

'The wheel scrolls the rows
Dim As Long TopBefore = f.grid.TopRow
SendMessage(hGrid, WM_MOUSEWHEEL, MAKEWPARAM(0, -120), MakeXY(cx, cy))
Check "wheel down scrolls (TopRow " & TopBefore & " -> " & f.grid.TopRow & ")", f.grid.TopRow > TopBefore
SendMessage(hGrid, WM_MOUSEWHEEL, MAKEWPARAM(0, 120), MakeXY(cx, cy))
Check "wheel up scrolls back", f.grid.TopRow = TopBefore

'A typed character starts the edit with it, Return commits
f.grid.Row = 2
f.grid.Col = 2
SendMessage(hGrid, WM_CHAR, Asc("x"), 0)
Check "a character starts the editor", f.grid.EditRow = 2 AndAlso f.grid.EditCol = 2
App.DoEvents
If f.grid.EditRow = 2 Then
	f.grid.CommitEdit
	Check "the commit stores the character", f.grid.TextMatrix(2, 2) = "x"
End If

'The double click opens the editor on the cell
Dim As Long dx = ColX(2) + 20, dy = RowY(3) + 8
SendMessage(hGrid, WM_LBUTTONDBLCLK, MK_LBUTTON, MakeXY(dx, dy))
Check "double click edits (row 3, col 2)", f.grid.EditRow = 3 AndAlso f.grid.EditCol = 2
f.grid.CancelEdit

'The divider drag sizes a column
Dim As Long W0 = f.grid.ColWidth(2)
Dim As Long vx = ColX(3) - 1, vy = RowY(0) + 3
SendMessage(hGrid, WM_LBUTTONDOWN, MK_LBUTTON, MakeXY(vx, vy))
SendMessage(hGrid, WM_MOUSEMOVE, MK_LBUTTON, MakeXY(vx + 40, vy))
SendMessage(hGrid, WM_LBUTTONUP, 0, MakeXY(vx + 40, vy))
Check "divider drag widens the column (" & W0 & " -> " & f.grid.ColWidth(2) & " twips, -1 is the default)", f.grid.ColWidth(2) > 0 AndAlso f.grid.ColWidth(2) <> W0

Print IIf(nFailed = 0, "PASS", "FAIL")
End
