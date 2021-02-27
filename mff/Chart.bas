'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019)                                          #
'################################################################################

#include once "Chart.bi"

Namespace My.Sys.Forms
	Function Chart.ReadProperty(ByRef PropertyName As String) As Any Ptr
		FTempString = LCase(PropertyName)
		Select Case FTempString
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Chart.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Public Sub Chart.GetCenterPie(X As Single, Y As Single)
		X = m_CenterCircle.X
		Y = m_CenterCircle.Y
	End Sub
	
	Public Property Chart.Count() As Long
		Count = ItemsCount
	End Property
	
	Public Property Chart.Special(Index As Long, Value As Boolean)
		m_Item(Index).Special = Value
		Me.Refresh
	End Property
	
	Public Property Chart.Special(Index As Long) As Boolean
		Special = m_Item(Index).Special
	End Property
	
	Public Property Chart.ItemColor(Index As Long, Value As OLE_COLOR)
		m_Item(Index).ItemColor = Value
		Me.Refresh
	End Property
	
	Public Property Chart.ItemColor(Index As Long) As OLE_COLOR
		ItemColor = m_Item(Index).ItemColor
	End Property
	
	Public Sub Chart.Clear()
		Dim i As Long
		For i = 0 To ItemsCount - 1
			GdipDeletePath m_Item(i).hPath
		Next
		ItemsCount = 0
		ReDim Preserve m_Item(0)
		Me.Refresh
	End Sub
	
	Public Function Chart.AddItem(ByVal ItemName As String, Value As Single, ItemColor As Long, Optional Special As Boolean)
		ReDim Preserve m_Item(ItemsCount)
		With m_Item(ItemsCount)
			.ItemName = ItemName
			.ItemColor = ItemColor
			.Value = Value
			.Special = Special
		End With
		ItemsCount = ItemsCount + 1
	End Function
	
	#ifndef __USE_GTK__
		Sub Chart.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QChart(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub Chart.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub Chart.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Operator Chart.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor Chart
		With This
			WLet(FClassName, "Chart")
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Chart", @This
			#else
				.Style        = WS_CHILD
				.ExStyle      = 0
				.RegisterClass "Chart", ""
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor Chart
		#ifndef __USE_GTK__
			UnregisterClass "Chart",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
