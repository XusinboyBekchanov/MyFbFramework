#Include Once "SysUtils.bi"

Namespace My.Sys
    #DEFINE QObject(__Ptr__) *Cast(My.Sys.Object Ptr,__Ptr__)
    
    Type Object Extends Object
        Protected:
            FClassName As WString Ptr
            FClassAncestor As WString Ptr
            FName As WString Ptr
        Public:
            Declare Virtual Function ToString ByRef As WString
            Declare Property ClassName ByRef As WString
            Declare Property ClassName(ByRef Value As WString)
            Declare Property ClassAncestor ByRef As WString
            Declare Property ClassAncestor(ByRef Value As WString)
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Operator Cast As Any Ptr
            Declare Operator Cast ByRef As WString
            Declare Sub Free
            Declare Sub Dispose
            Declare Constructor
            Declare Destructor
    End Type

    Sub Object.Free
        Delete @This
    End Sub

    Sub Object.Dispose
        Delete @This
    End Sub

    Operator Object.Cast ByRef As WString
        Return This.Name
    end operator

    Operator Object.Cast As Any Ptr
        Return @This
    End Operator

    Property Object.ClassName ByRef As WString
        If FClassName = 0 Or FClassName = 24 Then
            Return WStr("")
        Else
            Return *FClassName
        End If
    End Property
    
    Property Object.ClassName(ByRef Value As WString)
        WLet FClassName, Value
    End Property
    
    Property Object.ClassAncestor ByRef As WString
        If FClassAncestor Then Return *FClassAncestor Else Return WStr("")
    End Property
    
    Property Object.ClassAncestor(ByRef Value As WString)
        WLet FClassAncestor, Value
    End Property
    
    Property Object.Name ByRef As WString
        If FName Then Return *FName Else Return WStr("")
    End Property
    
    Property Object.Name(ByRef Value As WString)
        WLet FName, Value
    End Property
    
    Function Object.ToString ByRef As WString
        Return Name
    End Function
    
    Constructor Object
        'FClassName = CAllocate(0)
        'FClassAncestor = CAllocate(0)
        'FName = CAllocate(0)
    End Constructor

    Destructor Object
        If FClassName Then Deallocate FClassName
        If FClassAncestor Then Deallocate FClassAncestor
        If FName Then Deallocate FName
    End Destructor
    
    Type NotifyEvent     As Sub(ByRef Sender As My.Sys.Object)
    Type CloseEvent      As Sub(ByRef Sender As My.Sys.Object, ByRef CloseAction As Integer)
    Type ScrollEvent     As Sub(ByRef Sender As My.Sys.Object, Code As Integer, ByRef ScrollPos As Integer)
    Type MouseDownEvent  As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
    Type MouseUpEvent    As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
    Type MouseMoveEvent  As Sub(ByRef Sender As My.Sys.Object, X As Integer, Y As Integer, Shift As Integer)
    Type MouseWheelEvent As Sub(ByRef Sender As My.Sys.Object, Direction As Short, X As Integer, Y As Integer, Shift As Integer)
    Type KeyPressEvent   As Sub(ByRef Sender As My.Sys.Object, Key As Byte)
    Type KeyDownEvent    As Sub(ByRef Sender As My.Sys.Object, Key As Word, Shift As Integer)
    Type KeyUpEvent      As Sub(ByRef Sender As My.Sys.Object, Key As Word, Shift As Integer)
    Type TimerEvent      As Sub(ByRef Sender As My.Sys.Object, TimerId As Integer, TimerProc As Any Ptr = 0)

End Namespace
