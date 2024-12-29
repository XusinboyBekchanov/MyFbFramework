'################################################################################
'#  DynamicArrayList                                                            #
'#  Authors: FXM                                                                #
'#  Based on: the code posted on the freeBasic forum(www.freebasic.net/forum/   #
'#  See also：                                                                  #
'#   https://www.freebasic.net/forum/viewtopic.php?t=32759                      #
'#                                                                              #
'################################################################################
'https://www.freebasic.net/forum/viewtopic.php?p=305888#p305888
#include "inc/DynamicArrayList.bi"

Sub PrintList(ByRef dal As DynamicArrayList)
    Print "   list:";
    If dal.ReturnNumberOfPosition() = 0 Then
        Print " empty";
    ElseIf dal.ReturnNumberOfPosition() <= 10 Then
        For I As Integer = 1 To dal.ReturnNumberOfPosition()
            Print *CPtr(Long Ptr, dal.ReturnFromNthPosition(I));
        Next I
    Else
        For I As Integer = 1 To 5
            Print *CPtr(Long Ptr, dal.ReturnFromNthPosition(I));
        Next I
        Print " .....";
        For I As Integer = dal.ReturnNumberOfPosition() - 4 To dal.ReturnNumberOfPosition()
            Print *CPtr(Long Ptr, dal.ReturnFromNthPosition(I));
        Next I
    End If
    Print
End Sub

Sub test(ByVal NbrOfElements As Integer, ByVal NbrOfPreAllocatedNodes As Integer)
    Dim As Double t

    Print "Creating a list of " & NbrOfElements & " elements with " & NbrOfPreAllocatedNodes & " pre-allocated nodes:"
    t = Timer
    Dim As DynamicArrayList dal = DynamicArrayList(NbrOfPreAllocatedNodes)
    For I As Integer = 1 To NbrOfElements
        dal.InsertInNthPosition(New Long(I), 0)
    Next I
    t = Timer - t
    Print Using "   runtime:####.#### s"; t
    PrintList(dal)
    Print "Shifting #+3 by +" & NbrOfElements - 5 & " positions:"
    dal.ShiftTheNthPosition(+3, +(NbrOfElements - 5))
    PrintList(dal)
    Print "Shifting #-3 by +" & -(NbrOfElements - 5) & " positions:"
    dal.ShiftTheNthPosition(-3, -(NbrOfElements - 5))
    PrintList(dal)
    Print "Shifting " & NbrOfElements / 2 & " random elements each to a random position:"
    Randomize(NbrOfElements)
    t = Timer
    For I As Integer = 1 To NbrOfElements \ 2
        Dim As Integer N1 = Int(Rnd() * NbrOfElements + 1)
        Dim As Integer N2 = Int(Rnd() * NbrOfElements + 1)
        dal.ShiftTheNthPosition(N1, N2 - N1)
    Next I
    t = Timer - t
    Print Using "   runtime:####.#### s"; t
    PrintList(dal)
    Print "Suppressing all " & NbrOfElements & " elements:"
    t = Timer
    While dal.ReturnNumberOfPosition() > 0
        Delete CPtr(Long Ptr, dal.SuppressTheNthPosition(1))
    Wend
    t = Timer - t
    Print Using "   runtime:####.#### s"; t
    PrintList(dal)
    Print
End Sub

test(100000, 0)
test(100000, 100000)

Sleep
