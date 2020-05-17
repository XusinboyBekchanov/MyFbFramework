'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Component.bi"

Namespace My.Sys.ComponentModel
	Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "designmode": Return @FDesignMode
		Case "classancestor": Return FClassAncestor
		Case "tag": Return Tag
			#ifdef __USE_GTK__
			Case "handle": Return widget
			Case "widget": Return widget
			Case "layoutwidget": Return layoutwidget
			#else
			Case "handle": Return @FHandle
			#endif
		Case "name": Return FName
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Component.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value <> 0 Then
			Select Case LCase(PropertyName)
			Case "tag": This.Tag = Value
			Case "name": This.Name = QWString(Value)
			Case "designmode": This.DesignMode = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	#ifndef GetTopLevel_Off
		Function Component.GetTopLevel As Component Ptr
			If FParent = 0 Then
				Return @This
			Else
				Return FParent->GetTopLevel()
			End If
		End Function
	#endif
	
	#ifndef Parent_Off
		Property Component.Parent As Component Ptr '...'
			Return FParent
		End Property
		
		Property Component.Parent(Value As Component Ptr)
			FParent = Value
		End Property
	#endif
	
	Function Component.ClassAncestor ByRef As WString
		Return WGet(FClassAncestor)
	End Function
	
	Property Component.DesignMode As Boolean
		Return FDesignMode
	End Property
	
	Property Component.DesignMode(Value As Boolean)
		FDesignMode = Value
	End Property
	
	Property Component.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Property Component.Name(ByRef Value As WString)
		WLet FName, Value
		#ifdef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_set_name(widget, Value)
		#endif
	End Property
	
	#ifndef Handle_Off
		#ifdef __USE_GTK__
			Property Component.Handle As GtkWidget Ptr
				Return widget
			End Property
			
			Property Component.Handle(Value As GtkWidget Ptr)
				widget = Value
			End Property
		#else
			Property Component.Handle As HWND
				Return FHandle
			End Property
			
			Property Component.Handle(Value As HWND)
				FHandle = Value
			End Property
		#endif
	#endif
	
	Function Component.ToString ByRef As WString
		Return This.Name
	End Function
	
	Destructor Component
		WDeallocate FName
		WDeallocate FClassAncestor
	End Destructor
End Namespace

Sub ThreadsEnter
	#ifdef __USE_GTK__
		gdk_threads_enter()
	#endif
End Sub

Sub ThreadsLeave
	#ifdef __USE_GTK__
		gdk_threads_leave()
	#endif
End Sub
