#Include Once "Object.bi"

Namespace My.Sys.ComponentModel
    #DEFINE QBoolean(__Ptr__) *Cast(Boolean Ptr,__Ptr__)
    #DEFINE QInteger(__Ptr__) *Cast(Integer Ptr,__Ptr__)
    #DEFINE QWString(__Ptr__) *Cast(WString Ptr,__Ptr__)
    #DEFINE QComponent(__Ptr__) *Cast(Component Ptr,__Ptr__)

    Type Component Extends My.Sys.Object
        Protected:
            FDesignMode As Boolean
            FTempString As String
        Public:
            Tag As Any Ptr
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property DesignMode As Boolean
            Declare Property DesignMode(Value As Boolean)
    End Type
    
    Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
        FTempString = LCase(PropertyName)
        Select Case FTempString
        Case "classname": Return FClassName
        Case "classancestor": Return FClassAncestor
        Case "designmode": Return @FDesignMode
        Case "name": Return FName
        Case "tag": Return Tag
        Case Else: Return 0
        End Select
        Return 0
    End Function
    
    Function Component.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        If Value <> 0 Then
            Select Case LCase(PropertyName)
            Case "name": This.Name = QWString(Value)
            Case "tag": This.Tag = Value
            Case Else: Return False
            End Select
        End If
        Return True
    End Function
    
    Property Component.DesignMode As Boolean
        Return FDesignMode
    End Property
    
    Property Component.DesignMode(Value As Boolean)
        FDesignMode = Value
    End Property
End Namespace
