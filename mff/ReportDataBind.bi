'###############################################################################
'#  ReportDataBind.bi                                                          #
'#  This file is part of MyFBFramework                                        #
'#  Authors: Xusinboy Bekchanov                                               #
'#                                                                             #
'#  A tiny, database-agnostic helper that feeds ReportDocument.OnGetFieldValue #
'#  from a 2D String() result set - the exact shape SQLite3Component and       #
'#  MariaDBBox's Find/FindUtf/SQLFind methods already return:                  #
'#    rs(0, col)        -> column name                                        #
'#    rs(1..RowCount, col) -> row data                                        #
'#  ReportDataBind itself never references SQLite3Component or MariaDBBox -    #
'#  you fill the array with whichever component you're using (see the two     #
'#  worked examples in Report.bas' header comment), then hand it to a         #
'#  ReportRecordSet and point ReportDocument at it. This keeps the framework   #
'#  free of a hard dependency on either database component.                   #
'###############################################################################

#include once "Report.bi"

Namespace My.Sys.Forms
	'`ReportRecordSet` wraps a 2D String() result set (row 0 = column names) and
	'supplies ReportDocument.RowCount / OnGetFieldValue for it. Works with the array
	'shape returned by SQLite3Component/MariaDBBox's Find, FindUtf, SQLFind, or any
	'code that fills a String array the same way (e.g. Redim rs(nRows, nCols - 1)).
	Private Type ReportRecordSet
	Private:
		FColumns As WStringList
		FRows    As Integer
		FCols    As Integer
		FData    As WString Ptr Ptr
		Declare Sub Clear
	Public:
		'Copies Data(0 To RowCount, 0 To ColCount - 1) in - row 0 must hold column
		'names, rows 1..RowCount hold values, exactly like SQLite3Component.Find's
		'rs() output. RowCount/ColCount are the UBound()s of your array (not counts).
		Declare Sub Load(Data1() As String, RowCount As Integer, ColCount As Integer)
		Declare Property RowCount As Integer
		Declare Property ColumnCount As Integer
		Declare Function ColumnName(ColIndex As Integer) ByRef As WString
		Declare Function ColumnIndex(ByRef ColumnName As WString) As Integer
		'0-based DataRowIndex (0 = first data row, i.e. rs() row 1)
		Declare Function Value(DataRowIndex As Integer, ByRef ColumnName As WString) ByRef As WString
		'Ready-made OnGetFieldValue handler: Cast the ReportDocument's Report Form to
		'a type exposing `Dim As ReportRecordSet RS`, then:
		'  ReportDoc.OnGetFieldValue = @ReportRecordSet.OnGetFieldValueFromForm
		'and give your Form a public `Function GetReportRecordSet() As ReportRecordSet Ptr`
		'- see the worked example in Report.bas' header comment.
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ReportDataBind.bas"
#endif
