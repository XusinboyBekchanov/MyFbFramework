#include once "Integer.bi"

Private Function iGet(Value As Any Ptr) As Integer
	If Value = 0 Then Return 0 Else Return *Cast(Integer Ptr, Value)
End Function

Private Function _Abs(Value As Boolean) As Integer
	Return Abs(CInt(Value))
End Function
