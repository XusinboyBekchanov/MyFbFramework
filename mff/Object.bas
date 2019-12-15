'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Object.bi"

Namespace My.Sys    
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
