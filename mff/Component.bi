#Include Once "Object.bi"

Namespace My.Sys.ComponentModel
    #DEFINE QComponent(__Ptr__) *Cast(Component Ptr,__Ptr__)

    Type Component Extends My.Sys.Object
        Protected:
            FClassAncestor As WString Ptr
            FDesignMode As Boolean
            FName As WString Ptr
            FTempString As String
        Public:
            Tag As Any Ptr
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Virtual Function ToString ByRef As WString
            Declare Function ClassAncestor ByRef As WString
            Declare Property DesignMode As Boolean
            Declare Property DesignMode(Value As Boolean)
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Destructor
    End Type
    
    Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "designmode": Return @FDesignMode
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
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        End If
        Return True
    End Function

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
    End Property
    
    Function Component.ToString ByRef As WString
        Return This.Name
    End Function
    
    Destructor Component
        WDeallocate FName
        WDeallocate FClassAncestor
    End Destructor
End Namespace
