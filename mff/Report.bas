'###############################################################################
'#  Report.bas                                                                 #
'#  This file is part of MyFBFramework                                        #
'#  See Report.bi for an overview of the design.                              #
'###############################################################################

#include once "Report.bi"

'===============================================================================
' My.Sys.Forms.ReportBand
'===============================================================================
Namespace My.Sys.Forms
	'Guards ReportBand.Parent against re-entering Report.AddBand while Report.AddBand is
	'itself the one assigning FBands(InsertAt)->Parent = @This to tag the freshly-inserted
	'slot - without this, that assignment would call back into AddBand, which inserts
	'ANOTHER (now-duplicated) band and assigns Parent again, and so on. Only a Parent
	'assignment coming from outside AddBand (e.g. "Dim b As New ReportBand : b.Parent = Rep")
	'should actually add the band.
	Dim Shared As Boolean RB_InAddBand

	Private Property ReportBand.Parent As Report Ptr
		Return FParent
	End Property

	Private Property ReportBand.Parent(Value As Report Ptr)
		FParent = Value
		'Value = 0 happens from Report.RemoveBand (FBands(Index)->Parent = 0) to clear the
		'slot - calling AddBand(@This) on a null Report there would be a null-pointer call,
		'so skip the same way inside-AddBand re-entrancy is skipped.
		If Value <> 0 AndAlso Not RB_InAddBand Then Value->AddBand(@This)
	End Property

	Constructor ReportBand
		FParent       = 0
		BandType      = rbtDetail
		Height        = 0
		GroupField    = 0
		NewPageBefore = False
		NewPageAfter  = False
		WLet(FClassName, "ReportBand")
	End Constructor

	Destructor ReportBand
		If GroupField Then WDeAllocate(GroupField) : GroupField = 0
		'If FParent <> 0 Then Cast(Report Ptr, FParent)->RemoveBand(@This)
	End Destructor

	#ifndef ReadProperty_Off
		Private Function ReportBand.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "bandtype":      Return @BandType
			Case "height":        Return @Height
			Case "groupfield":    Return Cast(Any Ptr, GroupField)
			Case "newpagebefore": Return @NewPageBefore
			Case "newpageafter":  Return @NewPageAfter
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ReportBand.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "bandtype":        If Value <> 0 Then This.BandType = *Cast(ReportBandType Ptr, Value)
			Case "height":          If Value <> 0 Then This.Height = QInteger(Value)
			Case "groupfield":      If Value <> 0 Then WLet(This.GroupField, QWString(Value))
			Case "newpagebefore":   If Value <> 0 Then This.NewPageBefore = QBoolean(Value)
			Case "newpageafter":    If Value <> 0 Then This.NewPageAfter = QBoolean(Value)
			Case "parent":          This.Parent = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportControl - common base for every field control on a Report
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportControl
		FBackColor = -1
		FVisible   = True
		WLet(FClassName, "ReportControl")
	End Constructor

	Destructor ReportControl
		DestroyHandle()
		'Unlink from the owning Report's FComponents (inherited from Component) so it never
		'holds a dangling pointer to This past this point - Component's own Destructor
		'doesn't do this (see Component.bas), so every ReportControl has to on its own.
		'If FParent <> 0 Then
		'	Dim As ReportBand Ptr P = FParent
		'	Dim As Integer idx = P->Components.IndexOf(@This)
		'	If idx >= 0 Then P->Components.Remove(idx)
		'End If
	End Destructor
	
	Private Property ReportControl.Parent As ReportBand Ptr
		Return FParent
	End Property

	Private Property ReportControl.Parent(Value As ReportBand Ptr)
		FParent = Value
		If Value <> 0 Then CreateHandle
	End Property

	Private Sub ReportControl.CreateHandle
		#ifdef __USE_WINAPI__
			If This.Handle <> 0 OrElse FParent = 0 OrElse FParent->Parent = 0 Then Return
			Dim As HWND ParentHandle = FParent->Parent->Handle
			If ParentHandle = 0 Then Return
			This.Handle = CreateWindowExW(0, "STATIC", "", WS_CHILD Or WS_VISIBLE, _
				FLeft, FTop, FWidth, FHeight, ParentHandle, 0, GetModuleHandle(NULL), 0)
		#endif
	End Sub

	Private Sub ReportControl.DestroyHandle
		#ifdef __USE_WINAPI__
			If This.Handle <> 0 Then
				DestroyWindow(This.Handle)
				This.Handle = 0
			End If
		#endif
	End Sub

	Private Property ReportControl.BackColor As Integer
		Return FBackColor
	End Property

	Private Property ReportControl.BackColor(Value As Integer)
		FBackColor = Value
	End Property

	Private Property ReportControl.Visible As Boolean
		Return FVisible
	End Property

	Private Property ReportControl.Visible(Value As Boolean)
		FVisible = Value
	End Property

	Private Property ReportControl.DesignMode As Boolean
		Return FDesignMode
	End Property

	Private Property ReportControl.DesignMode(Value As Boolean)
		If Value = FDesignMode Then Return
		FDesignMode = Value
		If Value Then CreateHandle() Else DestroyHandle()
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "backcolor": Return @FBackColor
			Case "visible":   Return @FVisible
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "backcolor": If Value <> 0 Then This.BackColor = QInteger(Value)
			Case "visible":   If Value <> 0 Then This.Visible   = QBoolean(Value)
			Case "parent":   This.Parent = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportField
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportField
		Base.Constructor
		FDataField    = 0
		FFormatString = 0
		FSummaryField = 0
		FSummaryType  = rsNone
		FCanGrow      = False
		FText         = 0
		FAlignment    = 0
		FWordWraps    = True
		WLet(FClassName, "ReportField")
	End Constructor

	Destructor ReportField
		If FDataField    Then Deallocate(FDataField)    : FDataField    = 0
		If FFormatString Then Deallocate(FFormatString) : FFormatString = 0
		If FSummaryField Then Deallocate(FSummaryField)  : FSummaryField = 0
		If FText         Then Deallocate(FText)          : FText         = 0
	End Destructor

	Private Property ReportField.Text ByRef As WString
		Return WGet(FText)
	End Property

	Private Property ReportField.Text(ByRef Value As WString)
		WLet(FText, Value)
	End Property

	Private Property ReportField.Alignment As AlignmentConstants
		Return Cast(AlignmentConstants, FAlignment)
	End Property

	Private Property ReportField.Alignment(Value As AlignmentConstants)
		FAlignment = Value
	End Property

	Private Property ReportField.WordWraps As Boolean
		Return FWordWraps
	End Property

	Private Property ReportField.WordWraps(Value As Boolean)
		FWordWraps = Value
	End Property

	Private Property ReportField.DataField ByRef As WString
		Return WGet(FDataField)
	End Property

	Private Property ReportField.DataField(ByRef Value As WString)
		WLet(FDataField, Value)
		'Show "[FieldName]" as a design-time placeholder, like Crystal Reports' {table.field}.
		If Len(Value) > 0 Then This.Text = "[" & Value & "]"
	End Property

	Private Property ReportField.FormatString ByRef As WString
		Return WGet(FFormatString)
	End Property

	Private Property ReportField.FormatString(ByRef Value As WString)
		WLet(FFormatString, Value)
	End Property

	Private Property ReportField.SummaryType As ReportSummaryType
		Return FSummaryType
	End Property

	Private Property ReportField.SummaryType(Value As ReportSummaryType)
		FSummaryType = Value
	End Property

	Private Property ReportField.SummaryField ByRef As WString
		Return WGet(FSummaryField)
	End Property

	Private Property ReportField.SummaryField(ByRef Value As WString)
		WLet(FSummaryField, Value)
	End Property

	Private Property ReportField.CanGrow As Boolean
		Return FCanGrow
	End Property

	Private Property ReportField.CanGrow(Value As Boolean)
		FCanGrow = Value
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportField.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "text":         Return Cast(Any Ptr, FText)
			Case "alignment":    Return @FAlignment
			Case "wordwraps":    Return @FWordWraps
			Case "datafield":    Return Cast(Any Ptr, FDataField)
			Case "formatstring": Return Cast(Any Ptr, FFormatString)
			Case "summarytype":  Return @FSummaryType
			Case "summaryfield": Return Cast(Any Ptr, FSummaryField)
			Case "cangrow":      Return @FCanGrow
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportField.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "text":         If Value <> 0 Then This.Text        = QWString(Value)
			Case "alignment":    If Value <> 0 Then This.Alignment   = *Cast(AlignmentConstants Ptr, Value)
			Case "wordwraps":    If Value <> 0 Then This.WordWraps   = QBoolean(Value)
			Case "datafield":    If Value <> 0 Then This.DataField   = QWString(Value)
			Case "formatstring": If Value <> 0 Then This.FormatString = QWString(Value)
			Case "summarytype":  If Value <> 0 Then This.SummaryType = *Cast(ReportSummaryType Ptr, Value)
			Case "summaryfield": If Value <> 0 Then This.SummaryField = QWString(Value)
			Case "cangrow":      If Value <> 0 Then This.CanGrow      = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportLabel
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportLabel
		Base.Constructor
		FText      = 0
		FAlignment = 0
		FWordWraps = True
		WLet(FClassName, "ReportLabel")
	End Constructor

	Destructor ReportLabel
		If FText Then Deallocate(FText) : FText = 0
	End Destructor

	Private Property ReportLabel.Text ByRef As WString
		Return WGet(FText)
	End Property

	Private Property ReportLabel.Text(ByRef Value As WString)
		WLet(FText, Value)
	End Property

	Private Property ReportLabel.Alignment As AlignmentConstants
		Return Cast(AlignmentConstants, FAlignment)
	End Property

	Private Property ReportLabel.Alignment(Value As AlignmentConstants)
		FAlignment = Value
	End Property

	Private Property ReportLabel.WordWraps As Boolean
		Return FWordWraps
	End Property

	Private Property ReportLabel.WordWraps(Value As Boolean)
		FWordWraps = Value
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportLabel.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "text":      Return Cast(Any Ptr, FText)
			Case "alignment": Return @FAlignment
			Case "wordwraps": Return @FWordWraps
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportLabel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "text":      If Value <> 0 Then This.Text      = QWString(Value)
			Case "alignment": If Value <> 0 Then This.Alignment = *Cast(AlignmentConstants Ptr, Value)
			Case "wordwraps": If Value <> 0 Then This.WordWraps = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportImage
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportImage
		Base.Constructor
		FDataField = 0
		WLet(FClassName, "ReportImage")
	End Constructor

	Destructor ReportImage
		If FDataField Then Deallocate(FDataField) : FDataField = 0
	End Destructor

	Private Property ReportImage.DataField ByRef As WString
		Return WGet(FDataField)
	End Property

	Private Property ReportImage.DataField(ByRef Value As WString)
		WLet(FDataField, Value)
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportImage.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "datafield": Return Cast(Any Ptr, FDataField)
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportImage.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "datafield": If Value <> 0 Then This.DataField = QWString(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportLine
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportLine
		Base.Constructor
		FLineWidth = 1
		FLineColor = RGB(0, 0, 0)
		FVertical  = False
		Height     = 2
		Color      = FLineColor
		WLet(FClassName, "ReportLine")
	End Constructor

	Destructor ReportLine
	End Destructor

	Private Property ReportLine.LineWidth As Integer
		Return FLineWidth
	End Property

	Private Property ReportLine.LineWidth(Value As Integer)
		FLineWidth = Value
		If Not This.Vertical Then Height = Value Else Width = Value
	End Property

	Private Property ReportLine.LineColor As Integer
		Return FLineColor
	End Property

	Private Property ReportLine.LineColor(Value As Integer)
		FLineColor = Value
		Color = Value
	End Property

	Private Property ReportLine.Vertical As Boolean
		Return FVertical
	End Property

	Private Property ReportLine.Vertical(Value As Boolean)
		FVertical = Value
	End Property

	Private Property ReportLine.Color As Integer
		Return BackColor
	End Property

	Private Property ReportLine.Color(Value As Integer)
		BackColor = Value
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportLine.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "linewidth": Return @FLineWidth
			Case "linecolor": Return @FLineColor
			Case "vertical":  Return @FVertical
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportLine.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "linewidth": If Value <> 0 Then This.LineWidth = QInteger(Value)
			Case "linecolor": If Value <> 0 Then This.LineColor = QInteger(Value)
			Case "vertical":  If Value <> 0 Then This.Vertical  = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.ReportShape
'===============================================================================
Namespace My.Sys.Forms
	Constructor ReportShape
		Base.Constructor
		FShapeKind   = rshRectangle
		FBorderColor = RGB(0, 0, 0)
		FBorderWidth = 1
		FFillColor   = RGB(255, 255, 255)
		FFilled      = False
		WLet(FClassName, "ReportShape")
	End Constructor

	Destructor ReportShape
	End Destructor

	Private Property ReportShape.ShapeKind As ReportShapeKind
		Return FShapeKind
	End Property

	Private Property ReportShape.ShapeKind(Value As ReportShapeKind)
		FShapeKind = Value
	End Property

	Private Property ReportShape.BorderColor As Integer
		Return FBorderColor
	End Property

	Private Property ReportShape.BorderColor(Value As Integer)
		FBorderColor = Value
	End Property

	Private Property ReportShape.BorderWidth As Integer
		Return FBorderWidth
	End Property

	Private Property ReportShape.BorderWidth(Value As Integer)
		FBorderWidth = Value
	End Property

	Private Property ReportShape.FillColor As Integer
		Return FFillColor
	End Property

	Private Property ReportShape.FillColor(Value As Integer)
		FFillColor = Value
		Color = Value
	End Property

	Private Property ReportShape.Filled As Boolean
		Return FFilled
	End Property

	Private Property ReportShape.Filled(Value As Boolean)
		FFilled = Value
	End Property

	Private Property ReportShape.Color As Integer
		Return BackColor
	End Property

	Private Property ReportShape.Color(Value As Integer)
		BackColor = Value
	End Property

	#ifndef ReadProperty_Off
		Private Function ReportShape.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "shapekind":   Return @FShapeKind
			Case "bordercolor": Return @FBorderColor
			Case "borderwidth": Return @FBorderWidth
			Case "fillcolor":   Return @FFillColor
			Case "filled":      Return @FFilled
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ReportShape.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "shapekind":   If Value <> 0 Then This.ShapeKind   = *Cast(ReportShapeKind Ptr, Value)
			Case "bordercolor": If Value <> 0 Then This.BorderColor = QInteger(Value)
			Case "borderwidth": If Value <> 0 Then This.BorderWidth = QInteger(Value)
			Case "fillcolor":   If Value <> 0 Then This.FillColor   = QInteger(Value)
			Case "filled":      If Value <> 0 Then This.Filled      = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
End Namespace

'===============================================================================
' My.Sys.Forms.Report - the single band-based report design surface
'===============================================================================
Namespace My.Sys.Forms
	Const RPT_EDGE_ZONE As Integer = 4 'grab tolerance, in pixels, around a band's bottom edge

	#ifdef __USE_WINAPI__
		Private Sub Report.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QReport(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub Report.WNDPROC(ByRef Message As Message)
		End Sub
	#endif

	Private Sub Report.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		
	End Sub

	Constructor Report
		With This
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Report", @This
			#endif
			.Child          = @This
			.Canvas.Ctrl    = @This
			.Graphic.Ctrl   = @This
			.Graphic.OnChange = @GraphicChange
			#ifdef __USE_WINAPI__
				.RegisterClass "Report"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "div")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "Report")
			.ShowCaption = False
		End With
		FRowCount    = 0
		FCurrentRow  = 0
		BevelOuter  = bvLowered
		Width       = 480
		Height      = 320
		FDocument.DocumentName = "Report"
	End Constructor

	Destructor Report
		For i As Integer = 0 To FBands.Count - 1
			Dim As ReportBand Ptr b = QReportBandPtr(FBands.Item(i))
			If b Then Delete b
		Next
		FBands.Clear
	End Destructor

	Private Function Report.DesignAreaLeft() As Integer
		Return BAND_LIST_WIDTH
	End Function

	Private Function Report.BandTop(Index As Integer) As Integer
		Dim As Integer y = 0
		For i As Integer = 0 To Index - 1
			y += QReportBandPtr(FBands.Item(i))->Height
		Next
		Return y
	End Function

	Private Function Report.BandAt(y As Integer) As Integer
		Dim As Integer top = 0
		For i As Integer = 0 To FBands.Count - 1
			Dim As Integer h = QReportBandPtr(FBands.Item(i))->Height
			If y >= top AndAlso y < top + h Then Return i
			top += h
		Next
		Return -1
	End Function

	Private Function Report.BandCaption(Index As Integer) As String
		If Index < 0 OrElse Index >= FBands.Count Then Return ""
		Dim As ReportBand Ptr b = QReportBandPtr(FBands.Item(Index))
		Select Case b->BandType
		Case rbtReportHeader: Return "Report Header"
		Case rbtPageHeader:   Return "Page Header"
		Case rbtGroupHeader:  Return IIf(Len(WGet(b->GroupField)) > 0, "Group Header (" & WGet(b->GroupField) & ")", "Group Header")
		Case rbtDetail:       Return "Body" 'the Detail band, shown to the user as "Body"
		Case rbtGroupFooter:  Return IIf(Len(WGet(b->GroupField)) > 0, "Group Footer (" & WGet(b->GroupField) & ")", "Group Footer")
		Case rbtPageFooter:   Return "Page Footer"
		Case rbtReportFooter: Return "Report Footer"
		End Select
		Return ""
	End Function

	'Keeps a control fully inside Report's own Panel bounds. Works uniformly on either a
	'plain native Control (e.g. a Label dropped straight onto the surface) or a
	'ReportControl (ReportField/ReportImage/ReportLine/ReportShape) since both ultimately
	'reduce to Component, which is all this needs (Left/Top/Width/Height/SetBounds are all
	'public there) - so this one Sub serves both of ShiftControlsFrom's loops below. None of
	'these leaf items ever host children of their own, so unlike Report/Panel they have no
	'reason to extend past their container's Width/Height; letting them do so only leaves
	'part of the item unreachable/unclickable past the Panel's edge. Left is also floored at
	'DesignAreaLeft() so an item can't slide under the band-name strip.
	Private Sub Report.ClampControlBounds(c As Any Ptr)
		Dim As Component Ptr cc = Cast(Component Ptr, c)
		If cc = 0 Then Return

		Dim As Integer MinX = DesignAreaLeft()
		Dim As Integer NewLeft = cc->Left
		Dim As Integer NewTop  = cc->Top
		Dim As Integer NewW    = cc->Width
		Dim As Integer NewH    = cc->Height

		'Never wider/taller than the Panel itself has room for.
		If NewW > This.Width  - MinX Then NewW = This.Width  - MinX
		If NewH > This.Height          Then NewH = This.Height
		If NewW < 1 Then NewW = 1
		If NewH < 1 Then NewH = 1

		If NewLeft < MinX             Then NewLeft = MinX
		If NewLeft + NewW > This.Width Then NewLeft = This.Width - NewW
		If NewLeft < MinX             Then NewLeft = MinX 'Panel narrower than MinX+NewW

		If NewTop < 0                   Then NewTop = 0
		If NewTop + NewH > This.Height  Then NewTop = This.Height - NewH
		If NewTop < 0                   Then NewTop = 0 'Panel shorter than NewH

		If NewLeft <> cc->Left OrElse NewTop <> cc->Top OrElse NewW <> cc->Width OrElse NewH <> cc->Height Then
			cc->SetBounds(NewLeft, NewTop, NewW, NewH)
		End If
	End Sub

	'Moves every field control whose Top >= y down/up by Delta pixels, so bands below a
	'resize/insert/remove point (and everything dropped inside them) re-flow with no gap or
	'overlap. Also re-clamps every control to the Panel's own bounds afterwards (see
	'ClampControlBounds) since a Delta can just as easily push a control past Report's
	'right/bottom edge as it can create the gap/overlap this Sub exists to close.
	'Two kinds of item can be dropped onto a band, and they live in two different places:
	'plain native Controls (e.g. a Label) in Controls()/ControlCount as usual, and
	'ReportField/ReportImage/ReportLine/ReportShape - which Extend ReportControl, i.e.
	'Component, not Control - in FComponents (inherited straight from Component). Both
	'loops below are otherwise identical.
	Private Sub Report.ShiftControlsFrom(y As Integer, Delta As Integer)
		Dim As Integer n = This.ControlCount
		For i As Integer = 0 To n - 1
			Dim As Control Ptr c = This.Controls[i]
			If c = 0 Then Continue For
			If Delta <> 0 AndAlso c->Top >= y Then c->SetBounds(c->Left, c->Top + Delta, c->Width, c->Height)
			ClampControlBounds(c)
		Next

		Dim As Integer m = This.FComponents.Count
		For i As Integer = 0 To m - 1
			Dim As Component Ptr c = Cast(Component Ptr, This.FComponents.Item(i))
			If c = 0 Then Continue For
			If Delta <> 0 AndAlso c->Top >= y Then c->SetBounds(c->Left, c->Top + Delta, c->Width, c->Height)
			ClampControlBounds(c)
		Next
	End Sub

	'Index into FComponents of the topmost (highest-index, i.e. most-recently-added)
	'ReportControl whose bounds contain (x, y), or -1 if none - used by
	'HandleMouseDown to pick which field a click on the design surface selects/starts
	'dragging.
	Private Function Report.FieldAt(x As Integer, y As Integer) As Integer
		For i As Integer = This.FComponents.Count - 1 To 0 Step -1
			Dim As ReportControl Ptr c = QReportControlPtr(This.FComponents.Item(i))
			If c = 0 OrElse c->Visible = False Then Continue For
			If x >= c->Left AndAlso x < c->Left + c->Width AndAlso _
			   y >= c->Top  AndAlso y < c->Top  + c->Height Then Return i
		Next
		Return -1
	End Function

	Private Function Report.OnBandEdge(Index As Integer, y As Integer) As Boolean
		If Index < 0 OrElse Index >= FBands.Count Then Return False
		Dim As Integer edge = BandTop(Index) + QReportBandPtr(FBands.Item(Index))->Height
		Return (y >= edge - RPT_EDGE_ZONE) AndAlso (y <= edge + RPT_EDGE_ZONE)
	End Function

	Private Function Report.BandCount() As Integer
		Return FBands.Count
	End Function

	Private Function Report.BandByIndex(Index As Integer) As ReportBand Ptr
		If Index < 0 OrElse Index >= FBands.Count Then Return 0
		Return QReportBandPtr(FBands.Item(Index))
	End Function

	Private Function Report.AddBand(NewBandType As ReportBandType) As ReportBand Ptr
		'Insert in canonical print order (the ReportBandType enum's declaration order),
		'stable relative to existing bands that share the same type (e.g. nested groups).
		Dim As Integer InsertAt = FBands.Count
		For i As Integer = 0 To FBands.Count - 1
			If CInt(QReportBandPtr(FBands.Item(i))->BandType) > CInt(NewBandType) Then InsertAt = i : Exit For
		Next

		Dim As Integer InsertY = BandTop(InsertAt)
		Dim As Integer NewHeight = IIf(NewBandType = rbtReportHeader OrElse NewBandType = rbtReportFooter OrElse _
			NewBandType = rbtPageHeader OrElse NewBandType = rbtPageFooter, 32, 24)

		'Make room: slide every existing band (and its field controls) at/after InsertAt down.
		ShiftControlsFrom(InsertY, NewHeight)
		Dim As ReportBand Ptr NewB = New ReportBand
		NewB->BandType      = NewBandType
		NewB->Height        = NewHeight
		NewB->GroupField    = 0
		NewB->NewPageBefore = False
		NewB->NewPageAfter  = False
		'FBands.Insert shifts every band at/after InsertAt up one slot for us - no manual loop
		'needed the way the old fixed-size array required.
		FBands.Insert(InsertAt, NewB)
		RB_InAddBand = True
		NewB->Parent        = @This
		RB_InAddBand = False
		Invalidate
		Return NewB
	End Function
	
	Private Sub Report.AddBand(NewBand As ReportBand Ptr)
		If NewBand = 0 Then Return
		
		'Insert in canonical print order (the ReportBandType enum's declaration order),
		'stable relative to existing bands that share the same type (e.g. nested groups).
		Dim As Integer InsertAt = FBands.Count
		For i As Integer = 0 To FBands.Count - 1
			If CInt(QReportBandPtr(FBands.Item(i))->BandType) > CInt(NewBand->BandType) Then InsertAt = i : Exit For
		Next

		Dim As Integer InsertY = BandTop(InsertAt)
		'Respect an explicitly-set Height, but fall back to the same sensible default the
		'BandType overload uses (32/24px) - a freshly-constructed ReportBand.Height is 0 until
		'the caller sets it, and a 0-height band would be invisible/undraggable.
		Dim As Integer UseHeight = NewBand->Height
		If UseHeight <= 0 Then
			UseHeight = IIf(NewBand->BandType = rbtReportHeader OrElse NewBand->BandType = rbtReportFooter OrElse _
				NewBand->BandType = rbtPageHeader OrElse NewBand->BandType = rbtPageFooter, 32, 24)
		End If

		'Make room: slide every existing band (and its field controls) at/after InsertAt down.
		ShiftControlsFrom(InsertY, UseHeight)
		'Copy every field of the caller's (already-configured) band - not just BandType, so
		'Height/GroupField/NewPageBefore/NewPageAfter set before "b.Parent = Rep" survive.
		'A brand-new ReportBand is allocated here (rather than storing NewBand itself) so this
		'Report always owns and frees its own bands - NewBand stays the caller's to manage.
		Dim As ReportBand Ptr NewB = New ReportBand
		NewB->BandType      = NewBand->BandType
		NewB->Height        = UseHeight
		NewB->GroupField    = 0
		WLet(NewB->GroupField, WGet(NewBand->GroupField))
		NewB->NewPageBefore = NewBand->NewPageBefore
		NewB->NewPageAfter  = NewBand->NewPageAfter
		FBands.Insert(InsertAt, NewB)
		RB_InAddBand = True
		NewB->Parent        = @This
		RB_InAddBand = False
		Invalidate
	End Sub

	Private Sub Report.RemoveBand(Index As Integer)
		If Index < 0 OrElse Index >= FBands.Count Then Return

		Dim As Integer y0 = BandTop(Index)
		Dim As ReportBand Ptr b = QReportBandPtr(FBands.Item(Index))
		Dim As Integer h  = b->Height

		'Drop every field control that lived inside this band - both plain native Controls
		'(Controls()/ControlCount) and ReportField/ReportImage/ReportLine/ReportShape
		'(FComponents, since those Extend ReportControl -> Component, not Control).
		Dim As Integer n = This.ControlCount
		For i As Integer = n - 1 To 0 Step -1
			Dim As Control Ptr c = This.Controls[i]
			If c = 0 Then Continue For
			If c->Top >= y0 AndAlso c->Top < y0 + h Then Delete c
		Next
		For i As Integer = This.FComponents.Count - 1 To 0 Step -1
			Dim As Component Ptr c = Cast(Component Ptr, This.FComponents.Item(i))
			If c = 0 Then Continue For
			If c->Top >= y0 AndAlso c->Top < y0 + h Then
				Delete c 'ReportControl's own Destructor unlinks it from FComponents
			End If
		Next

		'Close the gap: everything below moves up by the removed band's height.
		ShiftControlsFrom(y0 + h, -h)

		Delete b
		FBands.Remove(Index) 'shifts every later band down one slot for us
		?45845, Index

		Dim As Integer NewCount = FBands.Count
		Invalidate
	End Sub

	'Overload: remove a band by pointer (as returned by AddBand) instead of by index. Ignores
	'Band if it's 0 or doesn't belong to this Report (already removed, or from another Report).
	Private Sub Report.RemoveBand(Band As ReportBand Ptr)
		If Band = 0 Then Return
		Dim As Integer Idx = FBands.IndexOf(Band)
		If Idx >= 0 Then RemoveBand(Idx)
	End Sub

	Private Property Report.BandType(Index As Integer) As ReportBandType
		Return QReportBandPtr(FBands.Item(Index))->BandType
	End Property

	Private Property Report.BandType(Index As Integer, Value As ReportBandType)
		If Index < 0 OrElse Index >= FBands.Count Then Return
		QReportBandPtr(FBands.Item(Index))->BandType = Value
		Invalidate
	End Property

	Private Property Report.BandHeight(Index As Integer) As Integer
		If Index < 0 OrElse Index >= FBands.Count Then Return 0
		Return QReportBandPtr(FBands.Item(Index))->Height
	End Property

	Private Property Report.BandHeight(Index As Integer, Value As Integer)
		If Index < 0 OrElse Index >= FBands.Count Then Return
		Dim As ReportBand Ptr b = QReportBandPtr(FBands.Item(Index))
		Dim As Integer NewHeight = Value
		If NewHeight < 8 Then NewHeight = 8 'a band can never shrink to zero/negative height
		Dim As Integer OldBottom = BandTop(Index) + b->Height
		Dim As Integer Delta = NewHeight - b->Height
		b->Height = NewHeight
		ShiftControlsFrom(OldBottom, Delta)
		Invalidate
	End Property

	Private Property Report.BandGroupField(Index As Integer) ByRef As WString
		If Index < 0 OrElse Index >= FBands.Count Then Return WGet(0)
		Return WGet(QReportBandPtr(FBands.Item(Index))->GroupField)
	End Property

	Private Property Report.BandGroupField(Index As Integer, ByRef Value As WString)
		If Index < 0 OrElse Index >= FBands.Count Then Return
		WLet(QReportBandPtr(FBands.Item(Index))->GroupField, Value)
		Invalidate
	End Property

	Private Property Report.BandNewPageBefore(Index As Integer) As Boolean
		If Index < 0 OrElse Index >= FBands.Count Then Return False
		Return QReportBandPtr(FBands.Item(Index))->NewPageBefore
	End Property

	Private Property Report.BandNewPageBefore(Index As Integer, Value As Boolean)
		If Index < 0 OrElse Index >= FBands.Count Then Return
		QReportBandPtr(FBands.Item(Index))->NewPageBefore = Value
	End Property

	Private Property Report.BandNewPageAfter(Index As Integer) As Boolean
		If Index < 0 OrElse Index >= FBands.Count Then Return False
		Return QReportBandPtr(FBands.Item(Index))->NewPageAfter
	End Property

	Private Property Report.BandNewPageAfter(Index As Integer, Value As Boolean)
		If Index < 0 OrElse Index >= FBands.Count Then Return
		QReportBandPtr(FBands.Item(Index))->NewPageAfter = Value
	End Property

	Private Function Report.IndexOfBandType(BT As ReportBandType) As Integer
		For i As Integer = 0 To FBands.Count - 1
			If QReportBandPtr(FBands.Item(i))->BandType = BT Then Return i
		Next
		Return -1
	End Function

	#ifndef ReadProperty_Off
		Private Function Report.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "bandcount":
				Static As Integer TmpBandCount
				TmpBandCount = This.BandCount()
				Return @TmpBandCount
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function Report.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Sub Report.HandleMouseDown(x As Integer, y As Integer)
		If x < BAND_LIST_WIDTH Then
			'Clicked a row in the band-name strip - just select it.
			Dim As Integer Row = y \ BAND_LIST_ROW_H
			'If Row >= 0 AndAlso Row < FBands.Count Then This.ActiveBand = Row
			Return
		End If

		'A ReportField/ReportLabel/ReportImage/ReportLine/ReportShape has no native window to
		'hit-test a click against on its own (see ReportControl), so Report does it here:
		'select it and, since the click stayed down, start dragging it from its current
		'offset to the cursor.
		Dim As Integer HitField = FieldAt(x, y)
		If HitField >= 0 Then
			'This.ActiveField = HitField
			Dim As ReportControl Ptr c = QReportControlPtr(FComponents.Item(HitField))
			FDragField    = HitField
			FDragOffsetX  = x - c->Left
			FDragOffsetY  = y - c->Top
			#ifdef __USE_GTK__
				gtk_grab_add(widget)
			#else
				SetCapture(This.Handle)
			#endif
			Return
		End If
		'This.ActiveField = -1

		'Clicked the design surface - either start a band bottom-edge drag, or select the
		'band under the cursor (so newly dropped controls land in it).
		For i As Integer = 0 To FBands.Count - 1
			If OnBandEdge(i, y) Then
				FDragBand   = i
				FDragStartY = y
				#ifdef __USE_GTK__
					gtk_grab_add(widget)
				#else
					SetCapture(This.Handle)
				#endif
				Return
			End If
		Next
		Dim As Integer HitBand = BandAt(y)
		'If HitBand >= 0 Then This.ActiveBand = HitBand
	End Sub

	Private Sub Report.HandleMouseMove(x As Integer, y As Integer)
		If FDragField >= 0 Then
			Dim As Component Ptr c = Cast(Component Ptr, FComponents.Item(FDragField))
			If c <> 0 Then
				c->SetBounds(x - FDragOffsetX, y - FDragOffsetY, c->Width, c->Height)
				ClampControlBounds(c)
				Invalidate
			End If
		ElseIf FDragBand >= 0 Then
			Dim As Integer NewHeight = BandHeight(FDragBand) + (y - FDragStartY)
			If NewHeight < 8 Then NewHeight = 8
			BandHeight(FDragBand) = NewHeight 'setter shifts everything below automatically
			FDragStartY = y
		ElseIf x >= BAND_LIST_WIDTH Then
			Dim As Boolean OnEdge = False
			For i As Integer = 0 To FBands.Count - 1
				If OnBandEdge(i, y) Then OnEdge = True : Exit For
			Next
			This.Cursor = IIf(OnEdge, crSizeNS, crArrow)
		Else
			This.Cursor = crArrow
		End If
	End Sub

	Private Sub Report.HandleMouseUp()
		If FDragBand = -1 AndAlso FDragField = -1 Then Return
		#ifdef __USE_GTK__
			gtk_grab_remove(widget)
		#else
			ReleaseCapture()
		#endif
		FDragBand  = -1
		FDragField = -1
	End Sub

	'Overridden - rather than assigning OnPaint/OnMouseDown/OnMouseMove/OnMouseUp, the way an
	'ordinary library user of this Report control would - because those On* events belong to
	'whoever uses Report, not to Report's own internal implementation (see the type-level
	'comment in Report.bi). Calls Base.ProcessMessage throughout so Panel's own painting and
	'any On* handlers the library user did set still fire exactly as they normally would;
	'Report only adds its own design-surface drawing/hit-testing/dragging on top, and only
	'while This.DesignMode is True.
	Private Sub Report.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			If Message.Event <> 0 Then
				Select Case Message.Event->type
				Case GDK_EXPOSE
					Base.ProcessMessage(Message)
					'Design-time band-strip/field drawing is NOT done here any more - Designer
					'itself intercepts this control's expose event and draws it via
					'Designer.DrawReport, exactly like it already does for ToolBar/ToolPalette.
					'See the WINAPI branch below for the full rationale. DrawDesignSurface
					'itself is unchanged and still used for the print/PDF path via DrawBand.
					Return
				Case GDK_BUTTON_PRESS
					If This.DesignMode AndAlso Message.Event->button.button = 1 Then HandleMouseDown(Message.Event->button.x, Message.Event->button.y)
				Case GDK_MOTION_NOTIFY
					If This.DesignMode Then HandleMouseMove(Message.Event->motion.x, Message.Event->motion.y)
				Case GDK_BUTTON_RELEASE
					If This.DesignMode AndAlso Message.Event->button.button = 1 Then HandleMouseUp()
				End Select
			End If
		#elseif defined(__USE_WINAPI__)
			Select Case Message.Msg
			Case WM_PAINT
				Base.ProcessMessage(Message) 'Panel paints its own background/bevel and fires OnPaint for the library user, if set
				'Design-time band-strip/field drawing is NOT done here any more - Designer
				'itself intercepts this control's WM_PAINT and draws it via Designer.DrawReport,
				'exactly like it already does for ToolBar/ToolPalette (see HookChildProc). That
				'keeps this drawing on the same single paint cycle Designer's own background/
				'grid repaint runs on, so there is no ordering race between the two - whereas
				'calling DrawDesignSurface from here raced with Designer's own FDialog repaint
				'in a way that sometimes left the band strip painted-over. DrawDesignSurface
				'itself is unchanged and still used for the print/PDF path via DrawBand.
				Return
			Case WM_LBUTTONDOWN
				If This.DesignMode Then HandleMouseDown(UnScaleX(GET_X_LPARAM(Message.lParam)), UnScaleY(GET_Y_LPARAM(Message.lParam)))
			Case WM_MOUSEMOVE
				If This.DesignMode Then HandleMouseMove(UnScaleX(GET_X_LPARAM(Message.lParam)), UnScaleY(GET_Y_LPARAM(Message.lParam)))
			Case WM_LBUTTONUP
				If This.DesignMode Then HandleMouseUp()
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
End Namespace

'===============================================================================
' My.Sys.Forms.Report - print/paginate/render engine (merged from ReportDocument)
'===============================================================================
Namespace My.Sys.Forms
	Private Property Report.RowCount As Integer
		Return FRowCount
	End Property

	Private Property Report.RowCount(Value As Integer)
		FRowCount = Value
	End Property

	Private Property Report.Document As PrintDocument Ptr
		Return @FDocument
	End Property

	Private Function Report.MeasureBand(BandIndex As Integer, ByRef Canvas As My.Sys.Drawing.Canvas) As Integer
		If BandIndex < 0 Then Return 0
		Return This.BandHeight(BandIndex)
	End Function

	'Draws every field control of Report whose Top falls inside BandIndex's vertical span
	'onto Canvas, offset so the band's own top lines up with the given page position Top and
	'so the band-list strip's width is stripped back out (page X = design X - DesignAreaLeft).
	'RowIndex selects which data row bound fields use (ignored by header/footer bands where
	'DataField lookups still work if you want running totals, since OnGetFieldValue simply
	'receives the current RowIndex).
	Private Sub Report.DrawBand(ByRef Canvas As My.Sys.Drawing.Canvas, BandIndex As Integer, Top As Single, RowIndex As Integer)
		If BandIndex < 0 Then Exit Sub
		Dim As Report Ptr Rep = @This
		Dim As Integer BandY0 = 0
		For i As Integer = 0 To BandIndex - 1
			BandY0 += Rep->BandHeight(i)
		Next
		Dim As Integer BandY1 = BandY0 + Rep->BandHeight(BandIndex)
		Dim As Integer OffsetX = Rep->DesignAreaLeft()

		Dim As Control Ptr RepCtrl = Cast(Control Ptr, Rep)
		Dim As Integer n = RepCtrl->ControlCount()
		For i As Integer = 0 To n - 1
			Dim As Control Ptr c = RepCtrl->Controls[i]
			If c = 0 OrElse c->Visible = False Then Continue For
			If c->Top < BandY0 OrElse c->Top >= BandY1 Then Continue For 'not in this band

			Dim As Single X = c->Left - OffsetX
			Dim As Single Y = Top + (c->Top - BandY0)
			Rep->DrawReportControlContent(Canvas, c->ClassName, c, X, Y, c->Width, c->Height, RowIndex)
		Next

		'ReportField/ReportImage/ReportLine/ReportShape - these Extend ReportControl
		'(Component), not Control, so they live in FComponents instead of Controls().
		Dim As Integer m = Rep->FComponents.Count
		For i As Integer = 0 To m - 1
			Dim As ReportControl Ptr c = QReportControlPtr(Rep->FComponents.Item(i))
			If c = 0 OrElse c->Visible = False Then Continue For
			If c->Top < BandY0 OrElse c->Top >= BandY1 Then Continue For 'not in this band

			Dim As Single X = c->Left - OffsetX
			Dim As Single Y = Top + (c->Top - BandY0)
			Rep->DrawReportControlContent(Canvas, c->ClassName, c, X, Y, c->Width, c->Height, RowIndex)
		Next
	End Sub

	'Draws one field's content at (X, Y) sized W x H on Canvas - shared by DrawBand (print/
	'PDF, page coordinates) and DrawDesignSurface (design surface, un-offset local
	'coordinates), so the two always agree pixel-for-pixel on what a field looks like.
	Private Sub Report.DrawReportControlContent(ByRef Canvas As My.Sys.Drawing.Canvas, ByRef cn As String, c As Any Ptr, X As Single, Y As Single, W As Integer, H As Integer, RowIndex As Integer)
		Select Case cn
		Case "ReportField"
			Dim As ReportField Ptr f = Cast(ReportField Ptr, c)
			Canvas.Font = f->Font
			Dim As WString * 2048 Txt
			If Len(f->DataField) > 0 Then
				If OnGetFieldValue Then
					Txt = OnGetFieldValue(This, f->DataField, RowIndex)
				End If
				If Len(f->FormatString) > 0 Then Txt = This.FormatValue(Txt, f->FormatString)
			Else
				Txt = f->Text
			End If
			Dim As Integer Align = f->Alignment
			If f->WordWraps Then
				Dim Lines(64) As String
				Dim As Integer LC
				WordWrapLines(Canvas, Txt, W, Lines(), LC)
				Dim As Integer LH = Canvas.TextHeight("Ag") + 2
				For li As Integer = 0 To LC - 1
					Dim As Integer tw = Canvas.TextWidth(Lines(li))
					Dim As Single tx = X
					If Align = 1 Then tx = X + (W - tw) / 2   'centre
					If Align = 2 Then tx = X + (W - tw)       'right
					Canvas.TextOut(tx, Y + li * LH, Lines(li))
				Next
			Else
				Dim As Integer tw = Canvas.TextWidth(Txt)
				Dim As Single tx = X
				If Align = 1 Then tx = X + (W - tw) / 2
				If Align = 2 Then tx = X + (W - tw)
				Canvas.TextOut(tx, Y, Txt)
			End If

		Case "Label"
			Dim As Label Ptr lb = Cast(Label Ptr, c)
			Canvas.Font = lb->Font
			Canvas.TextOut(X, Y, lb->Text)

		Case "ReportLabel"
			Dim As ReportLabel Ptr lb = Cast(ReportLabel Ptr, c)
			Canvas.Font = lb->Font
			Dim As Integer Align = lb->Alignment
			If lb->WordWraps Then
				Dim Lines(64) As String
				Dim As Integer LC
				WordWrapLines(Canvas, lb->Text, W, Lines(), LC)
				Dim As Integer LH = Canvas.TextHeight("Ag") + 2
				For li As Integer = 0 To LC - 1
					Dim As Integer tw = Canvas.TextWidth(Lines(li))
					Dim As Single tx = X
					If Align = 1 Then tx = X + (W - tw) / 2   'centre
					If Align = 2 Then tx = X + (W - tw)       'right
					Canvas.TextOut(tx, Y + li * LH, Lines(li))
				Next
			Else
				Dim As Integer tw = Canvas.TextWidth(lb->Text)
				Dim As Single tx = X
				If Align = 1 Then tx = X + (W - tw) / 2
				If Align = 2 Then tx = X + (W - tw)
				Canvas.TextOut(tx, Y, lb->Text)
			End If

		Case "ReportImage"
			Dim As ReportImage Ptr img = Cast(ReportImage Ptr, c)
			Dim As WString * 512 Path
			If Len(img->DataField) > 0 AndAlso OnGetFieldValue Then
				Path = OnGetFieldValue(This, img->DataField, RowIndex)
				If Len(Path) > 0 Then
					Dim As My.Sys.Drawing.GraphicType g
					g.LoadFromFile(Path)
					Canvas.DrawStretch(X, Y, W, H, g.Image)
				End If
			Else
				Canvas.DrawStretch(X, Y, W, H, img->Graphic.Image)
			End If

		Case "ReportLine"
			Dim As ReportLine Ptr ln = Cast(ReportLine Ptr, c)
			Canvas.Pen.Color = ln->LineColor
			Canvas.Pen.Size  = ln->LineWidth
			If ln->Vertical Then
				Canvas.Line(X, Y, X, Y + H)
			Else
				Canvas.Line(X, Y, X + W, Y)
			End If

		Case "ReportShape"
			Dim As ReportShape Ptr sh = Cast(ReportShape Ptr, c)
			Canvas.Pen.Color   = sh->BorderColor
			Canvas.Pen.Size    = sh->BorderWidth
			Canvas.Brush.Color = sh->FillColor
			Canvas.Brush.Style = IIf(sh->Filled, My.Sys.Drawing.BrushStyles.bsSolid, My.Sys.Drawing.BrushStyles.bsClear)
			Select Case sh->ShapeKind
			Case rshEllipse
				Canvas.Ellipse(X, Y, X + W, Y + H)
			Case Else
				Canvas.Rectangle(X, Y, X + W, Y + H)
			End Select

		End Select
	End Sub

	'Returns the value the report should group on for RowIndex, using the GroupHeader/
	'GroupFooter band's own GroupField and OnGetFieldValue.
	Private Function Report.GroupKeyOf(BandIndex As Integer, RowIndex As Integer) ByRef As WString
		If BandIndex < 0 OrElse OnGetFieldValue = 0 Then Return ""
		If Len(This.BandGroupField(BandIndex)) = 0 Then Return ""
		Return OnGetFieldValue(This, This.BandGroupField(BandIndex), RowIndex)
	End Function

	'Very small formatter: supports {0:N2} (fixed decimals) and a couple of common
	'printf-style specs (%.Nf). Anything else is returned unchanged.
	Private Function Report.FormatValue(ByRef Value As WString, ByRef strFormat As WString) As String
		Dim As String f = strFormat
		Dim As Double d
		Dim As Integer p
		If .Left(f, 3) = "{0:" Then
			Dim As String spec = Mid(f, 4, Len(f) - 4)
			If .Left(spec, 1) = "N" OrElse .Left(spec, 1) = "F" Then
				d = Val(Value)
				p = ValInt(Mid(spec, 2))
				Dim As String strF = String(p, Str("0"))
				If p > 0 Then
					 strF = strF & "." & String(p, Str("0"))
				End If
				Return Str(d) 'Format(d, strF)
			ElseIf spec = "C" Then
				d = Val(Value)
				Return Str(d) 'Format(d, "0.00")
			End If
			Return Value
		ElseIf .Left(f, 1) = "%" Then
			d = Val(Value)
			Return Str(d) 'Format(d, "0.00")
		End If
		Return Value
	End Function

	'Sums/averages/counts/min/max a ReportField's SummaryField across data rows FromRow..ToRow
	'(inclusive), via OnGetFieldValue. Used for GroupFooter/ReportFooter summary fields.
	Private Function Report.ComputeSummary(Field_ As Any Ptr, FromRow As Integer, ToRow As Integer) As Double
		Dim As ReportField Ptr f = Cast(ReportField Ptr, Field_)
		If f = 0 OrElse OnGetFieldValue = 0 Then Return 0
		Dim As WString * 64 fld = IIf(Len(f->SummaryField) > 0, f->SummaryField, f->DataField)
		Dim As Double total = 0, v
		Dim As Integer n = 0
		Dim As Double mn = 1e300, mx = -1e300
		For r As Integer = FromRow To ToRow
			v = Val(OnGetFieldValue(This, fld, r))
			total += v
			n += 1
			If v < mn Then mn = v
			If v > mx Then mx = v
		Next
		Select Case f->SummaryType
		Case rsSum:     Return total
		Case rsAverage: If n > 0 Then Return total / n Else Return 0
		Case rsCount:   Return n
		Case rsMin:     If n > 0 Then Return mn Else Return 0
		Case rsMax:     If n > 0 Then Return mx Else Return 0
		Case Else:      Return 0
		End Select
	End Function

	'Bound to PrintDocument.OnPrintPage. One call = one page. State (current data row,
	'whether the report header/footer and the current group have already been printed)
	'lives on the Report instance so printing resumes correctly across calls.
	Private Sub Report.PrintPageHandler(ByRef Designer As My.Sys.Object, ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		Dim As Report Ptr Rep = Cast(Report Ptr, @Designer)
		
		If Rep = 0 Then HasMorePages = False : Exit Sub

		Dim As Integer ReportHeaderBand = Rep->IndexOfBandType(rbtReportHeader)
		Dim As Integer ReportFooterBand = Rep->IndexOfBandType(rbtReportFooter)
		Dim As Integer PageHeaderBand   = Rep->IndexOfBandType(rbtPageHeader)
		Dim As Integer PageFooterBand   = Rep->IndexOfBandType(rbtPageFooter)
		Dim As Integer GroupHeaderBand  = Rep->IndexOfBandType(rbtGroupHeader)
		Dim As Integer GroupFooterBand  = Rep->IndexOfBandType(rbtGroupFooter)
		Dim As Integer DetailBand       = Rep->IndexOfBandType(rbtDetail)

		Dim As Integer LeftM = Rep->FDocument.PrinterSettings.MarginLeft
		Dim As Integer TopM  = Rep->FDocument.PrinterSettings.MarginTop
		Dim As Integer PageW = Rep->FDocument.PrinterSettings.PageWidth
		Dim As Integer PageH = Rep->FDocument.PrinterSettings.PageLength
		Dim As Integer BottomM = Rep->FDocument.PrinterSettings.Marginbottom
		Dim As Integer BottomY = PageH - BottomM

		Dim As Integer PageFooterH = Rep->MeasureBand(PageFooterBand, Canvas)
		Dim As Single Y = TopM

		If PageHeaderBand >= 0 Then
			Rep->DrawBand(Canvas, PageHeaderBand, Y, Rep->FCurrentRow)
			Y += Rep->MeasureBand(PageHeaderBand, Canvas)
		End If

		Static ReportHeaderDone As Boolean
		Static ReportFooterDone As Boolean
		Static GroupOpen As Boolean
		Static GroupStartRow As Integer
		Static CurrentGroupKey As String

		If Rep->FCurrentRow = 0 AndAlso Not ReportHeaderDone Then
			If ReportHeaderBand >= 0 Then
				Rep->DrawBand(Canvas, ReportHeaderBand, Y, 0)
				Y += Rep->MeasureBand(ReportHeaderBand, Canvas)
			End If
			ReportHeaderDone = True
		End If

		Dim As Integer DetailH = Rep->MeasureBand(DetailBand, Canvas)
		Dim As Integer GroupHeaderH = Rep->MeasureBand(GroupHeaderBand, Canvas)
		Dim As Integer GroupFooterH = Rep->MeasureBand(GroupFooterBand, Canvas)

		Do
			If Rep->FCurrentRow >= Rep->FRowCount Then
				If GroupOpen AndAlso GroupFooterBand >= 0 Then
					Rep->DrawBand(Canvas, GroupFooterBand, Y, Rep->FCurrentRow - 1)
					Y += GroupFooterH
					GroupOpen = False
				End If
				If ReportFooterBand >= 0 AndAlso Not ReportFooterDone Then
					Rep->DrawBand(Canvas, ReportFooterBand, Y, Rep->FCurrentRow - 1)
					Y += Rep->MeasureBand(ReportFooterBand, Canvas)
					ReportFooterDone = True
				End If
				HasMorePages = False
				Exit Do
			End If

			If GroupHeaderBand >= 0 Then
				Dim As WString * 256 NewKey = Rep->GroupKeyOf(GroupHeaderBand, Rep->FCurrentRow)
				If (Not GroupOpen) OrElse NewKey <> CurrentGroupKey Then
					If GroupOpen AndAlso GroupFooterBand >= 0 Then
						Rep->DrawBand(Canvas, GroupFooterBand, Y, Rep->FCurrentRow - 1)
						Y += GroupFooterH
					End If
					Rep->DrawBand(Canvas, GroupHeaderBand, Y, Rep->FCurrentRow)
					Y += GroupHeaderH
					CurrentGroupKey = NewKey
					GroupStartRow = Rep->FCurrentRow
					GroupOpen = True
				End If
			End If

			If Y + DetailH + PageFooterH > BottomY Then
				HasMorePages = True
				Exit Do
			End If

			Rep->DrawBand(Canvas, DetailBand, Y, Rep->FCurrentRow)
			Y += DetailH
			Rep->FCurrentRow += 1
		Loop

		If PageFooterBand >= 0 Then
			Rep->DrawBand(Canvas, PageFooterBand, BottomY - PageFooterH, Rep->FCurrentRow - 1)
		End If

		If Not HasMorePages Then
			ReportHeaderDone = False
			ReportFooterDone = False
			GroupOpen = False
			CurrentGroupKey = ""
			If Rep->OnEndPrint Then Rep->OnEndPrint(*Rep->Designer, *Rep)
		End If
	End Sub

	Private Sub Report.Print()
		FCurrentRow = 0
		FDocument.Designer = Cast(My.Sys.Object Ptr, @This)
		FDocument.OnPrintPage = @PrintPageHandler
		If OnBeginPrint Then OnBeginPrint(*Designer, This)
		FDocument.Print()
	End Sub

	Private Sub Report.PrintPreview()
		FCurrentRow = 0
		FDocument.Designer = Cast(My.Sys.Object Ptr, @This)
		FDocument.OnPrintPage = @PrintPageHandler
		If OnBeginPrint Then OnBeginPrint(*Designer, This)
		Dim As PrintPreviewDialog PPD
		PPD.Document = @FDocument
		PPD.Execute
	End Sub

	Private Sub Report.ExportToPDF(ByRef FileName As WString = "", ByRef PrinterName1 As WString)
		'"Microsoft Print to PDF" is the virtual printer built into Windows 10/11; selecting
		'it and printing normally produces a PDF. Windows itself asks for the destination
		'file name in almost all driver versions - FileName is accepted here for future
		'drivers/printers that do honour a direct output path, but do not rely on it
		'suppressing the Save dialog on stock "Microsoft Print to PDF".
		Dim As String PreviousPrinter = FDocument.PrinterSettings.Name
		FDocument.PrinterSettings.Name = "Microsoft Print to PDF"
		If FDocument.PrinterSettings.Name = "" Then
			'Requested PDF printer isn't installed - let the user pick one instead of failing silently.
			If FDocument.PrinterSettings.ChoosePrinter() = "" Then Exit Sub
		End If
		This.Print()
		FDocument.PrinterSettings.Name = PreviousPrinter
	End Sub

	'Splits Text on spaces so it fits within WidthPixels, using Canvas' current Font.
	Private Sub WordWrapLines(ByRef Canvas As My.Sys.Drawing.Canvas, ByRef Text As WString, WidthPixels As Integer, Lines() As String, ByRef LineCount As Integer)
		LineCount = 0
		Dim As String Cur = ""
		Dim As String AllText = Text
		Dim As String Word
		Dim As Integer sp
		Dim As Integer StartPos = 1
		Do
			sp = InStr(StartPos, AllText, " ")
			If sp = 0 Then
				Word = Mid(AllText, StartPos)
			Else
				Word = Mid(AllText, StartPos, sp - StartPos)
			End If
			Dim As String Test
			If Cur = "" Then
				Test = Word
			Else
				Test = Cur & " " & Word
			End If
			If Canvas.TextWidth(Test) > WidthPixels AndAlso Cur <> "" Then
				If LineCount < UBound(Lines) Then Lines(LineCount) = Cur : LineCount += 1
				Cur = Word
			Else
				Cur = Test
			End If
			If sp = 0 Then Exit Do
			StartPos = sp + 1
		Loop
		If Cur <> "" AndAlso LineCount < UBound(Lines) Then Lines(LineCount) = Cur : LineCount += 1
		If LineCount = 0 Then LineCount = 1 : Lines(0) = ""
	End Sub
End Namespace

#ifdef __EXPORT_PROCS__
	Function ReportBandByIndex cdecl Alias "ReportBandByIndex" (rpt As Any Ptr, Index As Integer) As Any Ptr __EXPORT__
		If rpt = 0 Then Return 0
		Return QReport(rpt).BandByIndex(Index)
	End Function
#endif
