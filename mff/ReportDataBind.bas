'###############################################################################
'#  ReportDataBind.bas                                                         #
'#  This file is part of MyFBFramework                                        #
'#  See ReportDataBind.bi for an overview of the design.                       #
'###############################################################################

#include once "ReportDataBind.bi"

Namespace My.Sys.Forms
	Constructor ReportRecordSet
		FRows = 0
		FCols = 0
		FData = 0
	End Constructor

	Destructor ReportRecordSet
		Clear
	End Destructor

	Private Sub ReportRecordSet.Clear
		If FData Then
			For i As Integer = 0 To (FRows + 1) * FCols - 1
				If FData[i] Then WDeAllocate(FData[i])
			Next i
			Deallocate(FData)
			FData = 0
		End If
		FColumns.Clear
		FRows = 0
		FCols = 0
	End Sub

	Private Sub ReportRecordSet.Load(Data1() As String, RowsCount As Integer, ColsCount As Integer)
		Clear
		FRows = RowsCount
		FCols = ColsCount + 1
		FData = Allocate(SizeOf(WString Ptr) * (FRows + 1) * FCols)
		For c As Integer = 0 To FCols - 1
			FColumns.Add(*FromUtf8(Data1(0, c)))
		Next c
		For r As Integer = 0 To FRows
			For c As Integer = 0 To FCols - 1
				Dim w As WString Ptr = 0
				WLet(w, *FromUtf8(Data1(r, c)))
				FData[r * FCols + c] = w
			Next c
		Next r
	End Sub

	Private Property ReportRecordSet.RowCount As Integer
		Return FRows
	End Property

	Private Property ReportRecordSet.ColumnCount As Integer
		Return FCols
	End Property

	Private Function ReportRecordSet.ColumnName(ColIndex As Integer) ByRef As WString
		If ColIndex < 0 OrElse ColIndex >= FColumns.Count Then Return ""
		Return FColumns.Item(ColIndex)
	End Function

	Private Function ReportRecordSet.ColumnIndex(ByRef ColumnName1 As WString) As Integer
		Return FColumns.IndexOf(ColumnName1, False, True)
	End Function

	Private Function ReportRecordSet.Value(DataRowIndex As Integer, ByRef ColumnName1 As WString) ByRef As WString
		Static EmptyResult As WString * 1
		Var c = ColumnIndex(ColumnName1)
		Var r = DataRowIndex + 1 'skip the header row stored at physical row 0
		If c < 0 OrElse r < 1 OrElse r > FRows OrElse FData = 0 Then Return EmptyResult
		If FData[r * FCols + c] = 0 Then Return EmptyResult
		Return *FData[r * FCols + c]
	End Function
End Namespace
