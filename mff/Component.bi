'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#Include Once "Object.bi"
#IfDef __USE_GTK__
	#Include once "gtk/gtk.bi"
    #IfDef __USE_GTK3__
    	#include once "glib-object.bi"
    #EndIf
#EndIf

Namespace My.Sys.ComponentModel
    #DEFINE QComponent(__Ptr__) *Cast(Component Ptr,__Ptr__)

    Type Component Extends My.Sys.Object
        Protected:
            FClassAncestor As WString Ptr
            FDesignMode As Boolean
            FName As WString Ptr
            FParent            As Component Ptr
            FTempString As String
            #IfNDef __USE_GTK__
                FHandle As HWND
            #EndIf
        Public:
        	'Stores any extra data needed for your program.
            Tag As Any Ptr
            #IfDef __USE_GTK__
				Accelerator     As GtkAccelGroup Ptr
				widget 			As GtkWidget Ptr
				box 			As GtkWidget Ptr
				fixedwidget		As GtkWidget Ptr
				scrolledwidget	As GtkWidget Ptr
				layoutwidget	As GtkWidget Ptr
			#Else
				Accelerator        As HACCEL
				Declare Property Handle As HWND
                Declare Property Handle(Value As HWND)
			#EndIf
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Virtual Function ToString ByRef As WString
            Declare Function ClassAncestor ByRef As WString
            Declare Function GetTopLevel As Component Ptr
            Declare Property DesignMode As Boolean
            Declare Property DesignMode(Value As Boolean)
            'Returns the name used in code to identify an object.
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Property Parent As Component Ptr 'ContainerControl
			Declare Property Parent(Value As Component Ptr)
            Declare Destructor
    End Type
    
    Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "designmode": Return @FDesignMode
        Case "classancestor": Return FClassAncestor
        Case "tag": Return Tag
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

	#IfNDef GetTopLevel_Off
		Function Component.GetTopLevel As Component Ptr
			If FParent = 0 Then
				Return @This
			Else
				Return FParent->GetTopLevel()
			End If
		End Function
    #EndIf
        
	#IfNDef Parent_Off
		Property Component.Parent As Component Ptr '...'
			Return FParent 
		End Property
	
		Property Component.Parent(Value As Component Ptr)
			FParent = Value
		End Property
	#EndIf
                    
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
		#IfDef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_set_name(widget, Value)
		#EndIf
    End Property
    
    #IfNDef Handle_Off
		#IfNDef __USE_GTK__
			Property Component.Handle As HWND '...'
				Return FHandle
			End Property

			Property Component.Handle(Value As HWND) '...'
				   FHandle = Value
			End Property
		#EndIf
    #EndIf
    
    Function Component.ToString ByRef As WString
        Return This.Name
    End Function
    
    Destructor Component
        WDeallocate FName
        WDeallocate FClassAncestor
    End Destructor
End Namespace

Type Message
	Sender   As Any Ptr
	#IfDef __USE_GTK__
		widget As GtkWidget Ptr
		event As GdkEvent Ptr
		Result   As Boolean
	#Else
		hWnd     As HWND
		Msg      As UINT
		wParam   As WPARAM
		lParam   As LPARAM
		Result   As LRESULT
		wParamLo As Integer
		wParamHi As Integer
		lParamLo As Integer
		lParamHi As Integer
		Captured As Any Ptr
	#EndIf
End Type

#IfDef __USE_GTK__
	#IfnDef __USE_GTK3__
		const GDK_KEY_Escape = &hff1b
		const GDK_KEY_Left = &hff51
		const GDK_KEY_Right = &hff53
		const GDK_KEY_Up = &hff52
		const GDK_KEY_Down = &hff54
		const GDK_KEY_Home = &hff50
		const GDK_KEY_End = &hff57
		const GDK_KEY_Delete = &hffff
		const GDK_KEY_Cut = &h1008ff58
		const GDK_KEY_Copy = &h1008ff57
		const GDK_KEY_Paste = &h1008ff6d
		const GDK_KEY_Redo = &hff66
		const GDK_KEY_Undo = &hff65
		const GDK_KEY_Page_Up = &hff55
		const GDK_KEY_Page_Down = &hff56
		const GDK_KEY_Insert = &hff63
		const GDK_KEY_F9 = &hffc6
		const GDK_KEY_F6 = &hffc3
		const GDK_KEY_Tab = &hff09
		const GDK_KEY_ISO_Left_Tab = &hfe20
		const GDK_KEY_SPACE = &h020
		const GDK_KEY_BACKSPACE = &hff08
		const GDK_KEY_Return = &hff0d
	#EndIf
#EndIf

Enum Keys
	#IfDef __USE_GTK__
		Esc = GDK_KEY_ESCAPE
		Left = GDK_KEY_LEFT
		Right = GDK_KEY_RIGHT
		Up = GDK_KEY_UP
		Down = GDK_KEY_DOWN
		Home = GDK_KEY_HOME
		EndKey = GDK_KEY_END
		DeleteKey = GDK_KEY_DELETE
		Enter = GDK_KEY_RETURN
	#Else
		Esc = VK_ESCAPE
		Left = VK_LEFT
		Right = VK_RIGHT
		Up = VK_UP
		Down = VK_DOWN
		Home = VK_HOME
		EndKey = VK_END
		DeleteKey = VK_DELETE
		Enter = VK_RETURN
	#EndIf
End Enum

Sub ThreadsEnter
	#IfDef __USE_GTK__
		gdk_threads_enter()
	#EndIf
End Sub

Sub ThreadsLeave
	#IfDef __USE_GTK__
		gdk_threads_leave()
	#EndIf
End Sub
