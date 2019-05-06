'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "SysUtils.bi"

Namespace My.Sys
    #DEFINE QBoolean(__Ptr__) *Cast(Boolean Ptr,__Ptr__)
    #DEFINE QInteger(__Ptr__) *Cast(Integer Ptr,__Ptr__)
    #DEFINE QWString(__Ptr__) *Cast(WString Ptr,__Ptr__)
    #DEFINE QZString(__Ptr__) *Cast(ZString Ptr,__Ptr__)
    #DEFINE QObject(__Ptr__) *Cast(My.Sys.Object Ptr,__Ptr__)
    
    Type Object Extends Object
        Protected:
            FTemp As WString Ptr
            FClassName As WString Ptr
        Public:
            Declare Virtual Function ToString ByRef As WString
            Declare Function ClassName ByRef As WString
            Declare Operator Cast As Any Ptr
            Declare Operator Cast ByRef As WString
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Sub Free
            Declare Sub Dispose
            Declare Constructor
            Declare Destructor
    End Type
    
    Function Object.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "classname": Return FClassName
        Case Else: Return 0
        End Select
        Return 0
    End Function
    
    Function Object.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        If Value <> 0 Then
            Select Case LCase(PropertyName)
            Case Else: Return False
            End Select
        End If
        Return True
    End Function

    Sub Object.Free
        Delete @This
    End Sub

    Sub Object.Dispose
        Delete @This
    End Sub

    Operator Object.Cast ByRef As WString
        Return This.ClassName
    end operator

    Operator Object.Cast As Any Ptr
        Return @This
    End Operator

    Function Object.ClassName ByRef As WString
        If FClassName = 0 Or FClassName = 24 Then
            Return WStr("")
        Else
            Return *FClassName
        End If
    End Function
    
    Function Object.ToString ByRef As WString
        WLet FTemp, "(" & This.ClassName & ")"
        Return *FTemp
    End Function
    
    Constructor Object
        'FClassName = CAllocate(0)
        'FClassAncestor = CAllocate(0)
        'FName = CAllocate(0)
    End Constructor

    Destructor Object
    	WDeallocate FTemp
        WDeallocate FClassName
    End Destructor
    
    Type NotifyEvent     As Sub(ByRef Sender As My.Sys.Object)
    Type CloseEvent      As Sub(ByRef Sender As My.Sys.Object, ByRef CloseAction As Integer)
    Type ScrollEvent     As Sub(ByRef Sender As My.Sys.Object, Code As Integer, ByRef ScrollPos As Integer)
    Type MouseDownEvent  As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
    Type MouseUpEvent    As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
    Type MouseMoveEvent  As Sub(ByRef Sender As My.Sys.Object, X As Integer, Y As Integer, Shift As Integer)
    Type MouseWheelEvent As Sub(ByRef Sender As My.Sys.Object, Direction As Short, X As Integer, Y As Integer, Shift As Integer)
    Type KeyPressEvent   As Sub(ByRef Sender As My.Sys.Object, Key As Byte)
    Type KeyDownEvent    As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
    Type KeyUpEvent      As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
    Type TimerEvent      As Sub(ByRef Sender As My.Sys.Object, TimerId As Integer, TimerProc As Any Ptr = 0)

End Namespace

#IfDef __EXPORT_PROCS__
	#IfNDef ToString_Off
		Function ToString Alias "ToString"(Obj As My.Sys.Object Ptr) ByRef As WString Export
		    Return Obj->ToString
		End Function
	#EndIf
	
	#IfNDef ReadProperty_Off
		Function ReadProperty Alias "ReadProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String) As Any Ptr Export
			Return Ctrl->ReadProperty(PropertyName)
		End Function
	#EndIf
	
	#IfNDef WriteProperty_Off
		Function WriteProperty Alias "WriteProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String, Value As Any Ptr) As Boolean Export
			Return Ctrl->WriteProperty(PropertyName, Value)
		End Function
	#EndIf
#EndIf
