'################################################################################
'#  DynamicArrayList                                                            #
'#  Authors: FXM                                                                #
'#  Based on: the code posted on the freeBasic forum(www.freebasic.net/forum/   #
'#  See also：                                                                  #
'#   https://www.freebasic.net/forum/viewtopic.php?t=32759                      #
'#                                                                              #
'################################################################################
' DynamicArrayList.bi - 28 Dec 2024

#if __FB_VERSION__ < "1.10"
Type DoublyLinkedNode
    Dim As DoublyLinkedNode Ptr prevNodePtr  '' previous node pointer
    Dim As Any Ptr userPtr                   '' user pointer
    Dim As DoublyLinkedNode Ptr nextNodePtr  '' next node pointer
End Type
#endif

Type DynamicArrayList
    Public:
        Declare Function InsertInNthPosition(ByVal p As Any Ptr, ByVal n As Integer) As Any Ptr
        Declare Function SuppressTheNthPosition(ByVal n As Integer) As Any Ptr
        Declare Function ReturnFromNthPosition(ByVal n As Integer) As Any Ptr
        Declare Function UpdateTheNthPosition(ByVal p As Any Ptr, ByVal n As Integer) As Any Ptr
        Declare Function SwapNthPthPosition(ByVal n1 As Integer, ByVal n2 As Integer) As Integer
        Declare Function ShiftTheNthPosition(ByVal n As Integer, ByVal offset As Integer) As Integer
        Declare Function ReverseOrderOfPosition() As Integer
        Declare Function ReturnArrayFromPosition(array() As Any Ptr) As Integer
        Declare Function LoadArrayIntoPosition(array() As Any Ptr) As Integer
        Declare Function SearchForNthPosition(ByVal compare As Function(ByVal p As Any Ptr) As Boolean, ByVal startPosition As Integer = 1) As Integer
        Declare Sub DestroyAllNthPosition(ByVal destroy As Sub(ByVal p As Any Ptr) = 0)
        Declare Function ReturnNumberOfPosition() As Integer
        Declare Constructor()
        Declare Constructor(ByVal nbrPreAlloc As Integer)
        Declare Property NumberOfPreAllocUsed() As Integer
        Declare Property NumberOfPreAllocAvailable() As Integer
        Declare Destructor()
    Private:
        #if __FB_VERSION__ >= "1.10"
        Type DoublyLinkedNode
            Dim As DoublyLinkedNode Ptr prevNodePtr  '' previous node pointer
            Dim As Any Ptr userPtr                   '' user pointer
            Dim As DoublyLinkedNode Ptr nextNodePtr  '' next node pointer
        End Type
        #endif
        Declare Function SearchNthPositionNode(ByVal posNodeIndex As Integer) As DoublyLinkedNode Ptr
        Declare Sub SearchOffsetRecentPositionNode(ByVal posNodeIndex As Integer, ByRef recentNodePtr As DoublyLinkedNode Ptr, ByRef n As Integer)
        Declare Function TraverseNodes(ByVal nodePtr As DoublyLinkedNode Ptr, ByVal n As Integer) As DoublyLinkedNode Ptr
        Dim As DoublyLinkedNode dummyNode           '' dummy node
        Dim As Integer nbrUserNode                  '' number of user node
        Dim As Integer recent1NodeIndex             '' recent #1 node index (position)
        Dim As DoublyLinkedNode Ptr recent1NodePtr  '' recent #1 node pointer
        Dim As Integer recent2NodeIndex             '' recent #2 node index (position)
        Dim As DoublyLinkedNode Ptr recent2NodePtr  '' recent #2 node pointer
        Dim As DoublyLinkedNode Ptr preAllocPtr     '' pre-allocation pointer
        Dim As Integer nbrPreAllocDone              '' number of pre-allocation done
        Dim As Integer preAllocNbr                  '' pre-allocation number
        Dim As Integer nbrPreAllocUsed              '' number of pre-allocation used
        Declare Sub _Thread()                       '' looping thread
        Dim As Any Ptr _pt                          '' pointer to looping thread
        Dim As Any Ptr _mutex                       '' mutex for start function in thread
        Dim As Integer _flag                        '' flag for end function in thread
        Dim As Byte _end                            '' end thread looping
        Dim As DoublyLinkedNode Ptr _nodePtrT       '' function parameter 1 in thread
        Dim As Integer _nT                          '' function parameter 2 in thread
        Dim As DoublyLinkedNode Ptr _returnT        '' return from function in thread
End Type

Function DynamicArrayList.InsertInNthPosition(ByVal p As Any Ptr, ByVal n As Integer) As Any Ptr
    ' Returns 0 on error, otherwise the value of the provided user pointer
   
    ' Converts index into positive index
    Dim As Integer posNodeIndex = IIf(n <= 0, This.nbrUserNode + n + 1, n)
    ' Tests index validity
    If (posNodeIndex < 1) Or (posNodeIndex > This.nbrUserNode + 1) Then Return 0
    Dim As DoublyLinkedNode Ptr newNodePtr
    If This.preAllocNbr = This.nbrPreAllocDone Then
        ' Allocates memory for new node
        newNodePtr = Allocate(SizeOf(DoublyLinkedNode))
        If newNodePtr = 0 Then Return 0
    Else
        ' Uses pre-allocated memory
        newNodePtr = @This.preAllocPtr[This.preAllocNbr]
        This.nbrPreAllocUsed += 1
        This.preAllocNbr += 1
    End If
    ' Copies user pointer value in new node
    newNodePtr->userPtr = p
    ' Searches for node below insertion
    Dim As DoublyLinkedNode Ptr searchNodePtr = This.SearchNthPositionNode(posNodeIndex)
    ' Updates pointers of previous, inserted, and next nodes
    newNodePtr->nextNodePtr = searchNodePtr
    newNodePtr->prevNodePtr = searchNodePtr->prevNodePtr
    searchNodePtr->prevNodePtr = newNodePtr
    newNodePtr->prevNodePtr->nextNodePtr = newNodePtr
    ' Increments the number of user nodes
    This.nbrUserNode +=1
    ' Updates the recent visited node data
    If (posNodeIndex > This.recent1NodeIndex) And (This.recent1NodeIndex > This.nbrUserNode Shr 2) Then
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = newNodePtr
    ElseIf posNodeIndex < This.recent2NodeIndex Then
        This.recent1NodeIndex = posNodeIndex
        This.recent1NodePtr = newNodePtr
        This.recent2NodeIndex += 1  ' recent #2 node position shifted by the insertion
    Else
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = newNodePtr
    End If
    Return p
End Function

Function DynamicArrayList.SuppressTheNthPosition(ByVal n As Integer) As Any Ptr
    ' Returns 0 on error, otherwise the value of the provided user pointer
   
    ' Converts index into positive index
    Dim As Integer posNodeIndex = IIf(n <= 0, This.nbrUserNode + n + 1, n)
    ' Tests index validity
    If (posNodeIndex < 1) Or (posNodeIndex > This.nbrUserNode) Then Return 0
    ' Searches for node to suppress
    Dim As DoublyLinkedNode Ptr searchNodePtr = This.SearchNthPositionNode(posNodeIndex)
    ' Updates of previous and next nodes
    searchNodePtr->prevNodePtr->nextNodePtr = searchNodePtr->nextNodePtr
    searchNodePtr->nextNodePtr->prevNodePtr = searchNodePtr->prevNodePtr
    ' Updates the recent visited node data
    If (posNodeIndex < This.nbrUserNode) And (posNodeIndex <> This.recent2NodeIndex) Then
        If (posNodeIndex > This.recent1NodeIndex) And (This.recent1NodeIndex > This.nbrUserNode Shr 2) Then
            This.recent2NodeIndex = posNodeIndex
            This.recent2NodePtr = searchNodePtr->nextNodePtr
        ElseIf posNodeIndex < This.recent2NodeIndex Then
            This.recent1NodeIndex = posNodeIndex
            This.recent1NodePtr = searchNodePtr->nextNodePtr
            This.recent2NodeIndex -= 1  ' recent #2 node position shifted by the suppression
        Else
            This.recent2NodeIndex = posNodeIndex
            This.recent2NodePtr = searchNodePtr->nextNodePtr
        End If
    Else
        ' Resets the recent visited node data
        This.recent1NodePtr = @This.dummyNode
        This.recent1NodeIndex = 0
        This.recent2NodePtr = @This.dummyNode
        This.recent2NodeIndex = 0
    End If
    ' Saves user pointer of the node
    Dim As Any Ptr searchUserPtr = searchNodePtr->userPtr
    If (This.nbrPreAllocDone = 0) OrElse ((searchNodePtr < @This.preAllocPtr[0]) Or (searchNodePtr > @This.preAllocPtr[This.nbrPreAllocDone - 1])) Then
        ' Deallocates memory for the node
        Deallocate(searchNodePtr)
    Else
        ' Frees the node from the preallocated memeory
        This.nbrPreAllocUsed -= 1
        If This.nbrPreAllocUsed = 0 Then
            This.preAllocNbr = 0
        Else
            If searchNodePtr = @This.preAllocPtr[This.preAllocNbr - 1] Then This.preAllocNbr -= 1
        End If
    End If
    ' Decrements the number of user nodes
    This.nbrUserNode -= 1
    Return searchUserPtr
End Function

Function DynamicArrayList.ReturnFromNthPosition(ByVal n As Integer) As Any Ptr
    ' Returns 0 on error, otherwise the value of the provided user pointer
   
    ' Converts index into positive index
    Dim As Integer posNodeIndex = IIf(n <= 0, This.nbrUserNode + n + 1, n)
    ' Tests index validity
    If (posNodeIndex < 1) Or (posNodeIndex > This.nbrUserNode) Then Return 0
    ' Searches for user node
    Dim As DoublyLinkedNode Ptr searchNodePtr = This.SearchNthPositionNode(posNodeIndex)
    ' Updates the recent visited node data
    If (posNodeIndex > This.recent1NodeIndex) And (This.recent1NodeIndex > This.nbrUserNode Shr 2) Then
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = searchNodePtr
    ElseIf posNodeIndex < This.recent2NodeIndex Then
        This.recent1NodeIndex = posNodeIndex
        This.recent1NodePtr = searchNodePtr
    Else
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = searchNodePtr
    End If
    Return searchNodePtr->userPtr
End Function

Function DynamicArrayList.UpdateTheNthPosition(ByVal p As Any Ptr, ByVal n As Integer) As Any Ptr
    ' Returns 0 on error, otherwise the value of the provided user pointer
   
    ' Converts index into positive index
    Dim As Integer posNodeIndex = IIf(n <= 0, This.nbrUserNode + n + 1, n)
    ' Tests index validity
    If (posNodeIndex < 1) Or (posNodeIndex > This.nbrUserNode) Then Return 0
    ' Searches for user node
    Dim As DoublyLinkedNode Ptr searchNodePtr = This.SearchNthPositionNode(posNodeIndex)
    ' Updates user pointer of the node
    searchNodePtr->userPtr = p
    ' Updates the recent visited node data
    If (posNodeIndex > This.recent1NodeIndex) And (This.recent1NodeIndex > This.nbrUserNode Shr 2) Then
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = searchNodePtr
    ElseIf posNodeIndex < This.recent2NodeIndex Then
        This.recent1NodeIndex = posNodeIndex
        This.recent1NodePtr = searchNodePtr
    Else
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = searchNodePtr
    End If
    Return p
End Function

Function DynamicArrayList.SwapNthPthPosition(ByVal n1 As Integer, ByVal n2 As Integer) As Integer
    ' Returns 0 on error, otherwise -1
   
    ' Converts indexes into positive indexes
    Dim As Integer posNodeIndex1 = IIf(n1 <= 0, This.nbrUserNode + n1 + 1, n1)
    Dim As Integer posNodeIndex2 = IIf(n2 <= 0, This.nbrUserNode + n2 + 1, n2)
    ' Tests index validity
    If (posNodeIndex1 < 1) Or (posNodeIndex1 > This.nbrUserNode) Or (posNodeIndex2 < 1) Or (posNodeIndex2 > This.nbrUserNode) Or (posNodeIndex1 = posNodeIndex2) Then Return 0
    ' search for the 2 user nodes
    Dim As DoublyLinkedNode Ptr searchNodePtr1
    Dim As Integer offset1
    This.SearchOffsetRecentPositionNode(posNodeIndex1, searchNodePtr1, offset1)
    Dim As DoublyLinkedNode Ptr searchNodePtr2
    Dim As Integer offset2
    This.SearchOffsetRecentPositionNode(posNodeIndex2, searchNodePtr2, offset2)
    ' sorts the searches by offset in ascending order (in absolute value)
    If Abs(offset1) > Abs(offset2) Then
        Swap posNodeIndex1, posNodeIndex2
        Swap searchNodePtr1, searchNodePtr2
        Swap offset1, offset2
    End If
    ' lunches the shorter search from the threading loop if its offset is greater than a threshold (in absolute value)
    ' offset threshold corresponding to the thread synchronization latency
    If Abs(offset1) > 500 Then
        This._nodePtrT = searchNodePtr1
        This._nT = offset1
        MutexUnlock(This._mutex)  '' unlock mutex for child thread
        searchNodePtr2 = This.TraverseNodes(searchNodePtr2, offset2)
        While This._flag = 0      '' wait for flag set from child thread
        Wend
        This._flag = 0            '' reset flag
        searchNodePtr1 = This._returnT
    Else
        searchNodePtr1 = This.TraverseNodes(searchNodePtr1, offset1)
        searchNodePtr2 = This.TraverseNodes(searchNodePtr2, offset2)
    End If
    ' swaps the 2 user pointers
    Swap searchNodePtr1->userPtr, searchNodePtr2->userPtr
    ' Updates the recent visited node data
    If posNodeIndex2 > posNodeIndex1 Then
        This.recent1NodeIndex = posNodeIndex1
        This.recent1NodePtr = searchNodePtr1
        This.recent2NodeIndex = posNodeIndex2
        This.recent2NodePtr = searchNodePtr2
    Else
        This.recent1NodeIndex = posNodeIndex2
        This.recent1NodePtr = searchNodePtr2
        This.recent2NodeIndex = posNodeIndex1
        This.recent2NodePtr = searchNodePtr1
    End If
    Return -1
End Function

Function DynamicArrayList.ShiftTheNthPosition(ByVal n As Integer, ByVal offset As Integer) As Integer
    ' Returns 0 on error, otherwise -1
   
    ' Converts index into positive index
    Dim As Integer posNodeIndex = IIf(n <= 0, This.nbrUserNode + n + 1, n)
    ' Tests index and offset validity
    If (posNodeIndex < 1) Or (posNodeIndex > This.nbrUserNode) Or (posNodeIndex + offset < 1) Or (posNodeIndex + offset > This.nbrUserNode) Or (offset = 0) Then Return 0
    ' search for the 2 user nodes
    Dim As DoublyLinkedNode Ptr nodePtr1
    Dim As DoublyLinkedNode Ptr nodePtr2
    Dim As DoublyLinkedNode Ptr searchNodePtr1
    Dim As Integer offset1
    This.SearchOffsetRecentPositionNode(posNodeIndex, searchNodePtr1, offset1)
    Dim As DoublyLinkedNode Ptr searchNodePtr2
    Dim As Integer offset2
    This.SearchOffsetRecentPositionNode(posNodeIndex + offset, searchNodePtr2, offset2)
    ' lunches the shorter search from the threading loop if its offset is greater than a threshold (in absolute value)
    ' offset threshold corresponding to the thread synchronization latency
    If (Abs(offset1) > 500) And (Abs(offset2) > 500) Then
        If Abs(offset2) > Abs(offset1) Then
            This._nodePtrT = searchNodePtr1
            This._nT = offset1
            MutexUnlock(This._mutex)  '' unlock mutex for child thread
            nodePtr2 = This.TraverseNodes(searchNodePtr2, offset2)
            While This._flag = 0      '' wait for flag set from child thread
            Wend
            This._flag = 0            '' reset flag
            nodePtr1 = This._returnT
        Else
            This._nodePtrT = searchNodePtr2
            This._nT = offset2
            MutexUnlock(This._mutex)  '' unlock mutex for child thread
            nodePtr1 = This.TraverseNodes(searchNodePtr1, offset1)
            While This._flag = 0      '' wait for flag set from child thread
            Wend
            This._flag = 0            '' reset flag
            nodePtr2 = This._returnT
        End If
    Else
        nodePtr1 = This.TraverseNodes(searchNodePtr1, offset1)
        nodePtr2 = This.TraverseNodes(searchNodePtr2, offset2)
    End If
    ' Uninserts the node
    nodePtr1->prevNodePtr->nextNodePtr = nodePtr1->nextNodePtr
    nodePtr1->nextNodePtr->prevNodePtr = nodePtr1->prevNodePtr
    If offset > 0 Then
        ' Updates the recent visited node data
        This.recent1NodeIndex = posNodeIndex
        This.recent1NodePtr = nodePtr1->nextNodePtr
        This.recent2NodeIndex = posNodeIndex + offset
        This.recent2NodePtr = nodePtr1
        ' Inserts the node to the targeted position
        nodePtr1->nextNodePtr = nodePtr2->nextNodePtr
        nodePtr1->prevNodePtr = nodePtr2
        nodePtr2->nextNodePtr->prevNodePtr = nodePtr1
        nodePtr2->nextNodePtr = nodePtr1
    Else
        ' Updates the recent visited node data
        This.recent1NodeIndex = posNodeIndex + offset
        This.recent1NodePtr = nodePtr1
        This.recent2NodeIndex = posNodeIndex
        This.recent2NodePtr = nodePtr1->prevNodePtr
        ' Inserts the node to the targeted position
        nodePtr1->nextNodePtr = nodePtr2
        nodePtr1->prevNodePtr = nodePtr2->prevNodePtr
        nodePtr2->prevNodePtr->nextNodePtr = nodePtr1
        nodePtr2->prevNodePtr = nodePtr1
    End If
    Return -1
End Function

Function DynamicArrayList.ReverseOrderOfPosition() As Integer
    ' Returns 0 on empty list, otherwise -1
   
    ' Tests empty list
    If This.nbrUserNode = 0 Then Return 0
    ' Swaps user pointers from the ends up to the middle
    Dim As DoublyLinkedNode Ptr leftNodePtr = @This.dummyNode, rightNodePtr = @This.dummyNode
    For I As Integer = 1 To This.nbrUserNode \ 2
        leftNodePtr = leftNodePtr->nextNodePtr
        rightNodePtr = rightNodePtr->prevNodePtr
        Swap rightNodePtr->userPtr, leftNodePtr->userPtr
    Next I
    Return -1
End Function

Function DynamicArrayList.ReturnArrayFromPosition(array() As Any Ptr) As Integer
    ' Returns the number of elements
    
    If This.nbrUserNode = 0 Then Return 0
    Dim As DoublyLinkedNode Ptr nodePtr = @This.dummyNode
    ' sizes the passed array
    ReDim array(1 To This.nbrUserNode)
    ' fills in the array with the user pointers
    For I As Integer = 1 To This.nbrUserNode
        nodePtr = nodePtr->nextNodePtr
        array(I) = nodePtr->userPtr
    Next I
    Return This.nbrUserNode
End Function

Function DynamicArrayList.LoadArrayIntoPosition(array() As Any Ptr) As Integer
    ' Return 0 if the list is not empty, otherwise returns the number of loaded elements
    
    If This.nbrUserNode > 0 Then Return 0
    Dim As DoublyLinkedNode Ptr nodePtr = @This.dummyNode
    For I As Integer = LBound(array) To UBound(array)
        Dim As DoublyLinkedNode Ptr newNodePtr
        If This.preAllocNbr = This.nbrPreAllocDone Then
            ' Allocates memory for new node
            newNodePtr = Allocate(SizeOf(DoublyLinkedNode))
            If newNodePtr = 0 Then Return 0
        Else
            ' Uses pre-allocated memory
            newNodePtr = @This.preAllocPtr[This.preAllocNbr]
            This.nbrPreAllocUsed += 1
            This.preAllocNbr += 1
        End If
        ' Copies user pointer value in new node
        newNodePtr->userPtr = array(I)
        ' Updates pointers of previous and inserted nodes
        nodePtr->nextNodePtr = newNodePtr
        newNodePtr->prevNodePtr = nodePtr
        ' Inserted node becomes previous node
        nodePtr = newNodePtr
        ' Increments the number of user nodes
        This.nbrUserNode += 1
    Next I
    ' Updates pointer of last node and dummy node
    nodePtr->nextNodePtr = @This.dummyNode
    This.dummyNode.prevNodePtr = nodePtr
    Return This.nbrUserNode
End Function

Function DynamicArrayList.SearchForNthPosition(ByVal compare As Function(ByVal p As Any Ptr) As Boolean, ByVal startPosition As Integer = 1) As Integer
    ' Return 0 if the search failed, otherwise returns the position index of the first occurence found
    ' If startPosition > 0 (set of positive index used), the search begins at the startPosition index then continues in the increasing index order
    ' If startPosition < 0 (set of negative index used), the search begins at the startPosition index then continues in the decreasing index order (reverse order)
    ' The returned index uses the same set (positive or negative) of index than the one used for startPosition
    
    If compare = 0 Then Return 0
    Dim As DoublyLinkedNode Ptr nodePtr
    ' set of positive index used
    If (startPosition >= 1) And (startPosition <= This.nbrUserNode) Then
        ' search start node
        nodePtr = This.SearchNthPositionNode(startPosition)
        For I As Integer = startPosition To This.nbrUserNode
            If compare(nodePtr->userPtr) = True Then Return I
            ' next node
            nodePtr = nodePtr->nextNodePtr
        Next I
    ' set of negative index used
    ElseIf (startPosition <= -1) And (startPosition >= -This.nbrUserNode) Then
        ' search start node
        nodePtr = This.SearchNthPositionNode(This.nbrUserNode + startPosition + 1)
        For I As Integer = startPosition To -This.nbrUserNode Step -1
            If compare(nodePtr->userPtr) = True Then Return I
            ' previous node
            nodePtr = nodePtr->prevNodePtr
        Next I
    End If
    Return 0
End Function

Sub DynamicArrayList.DestroyAllNthPosition(ByVal destroy As Sub(ByVal p As Any Ptr) = 0)
    ' Deallocates memory used by user nodes one by one by transverse access, including user data in the loop if destroy <> 0 is passed
    
    Dim As DoublyLinkedNode Ptr nodePtr = This.dummyNode.nextNodePtr
    If This.nbrPreAllocDone = 0 Then
        If destroy <> 0 Then
            For I As Integer = 1 To This.nbrUserNode
                nodePtr = nodePtr->nextNodePtr
                destroy(nodePtr->prevNodePtr->userPtr)
                ' Deallocates memory for the node
                Deallocate(nodePtr->prevNodePtr)
            Next I
        Else
            For I As Integer = 1 To This.nbrUserNode
                nodePtr = nodePtr->nextNodePtr
                ' Deallocates memory for the node
                Deallocate(nodePtr->prevNodePtr)
            Next I
        End If
    Else
        If destroy <> 0 Then
            For I As Integer = 1 To This.nbrUserNode
                nodePtr = nodePtr->nextNodePtr
                destroy(nodePtr->prevNodePtr->userPtr)
                If (nodePtr->prevNodePtr < @This.preAllocPtr[0]) Or (nodePtr->prevNodePtr > @This.preAllocPtr[This.nbrPreAllocDone - 1]) Then
                    ' Deallocates memory for the node
                    Deallocate(nodePtr->prevNodePtr)
                End If
            Next I
        Else
            For I As Integer = 1 To This.nbrUserNode
                nodePtr = nodePtr->nextNodePtr
                If (nodePtr->prevNodePtr < @This.preAllocPtr[0]) Or (nodePtr->prevNodePtr > @This.preAllocPtr[This.nbrPreAllocDone - 1]) Then
                    ' Deallocates memory for the node
                    Deallocate(nodePtr->prevNodePtr)
                End If
            Next I
        End If
    End If
    ' Clears the number of user nodes
    This.nbrUserNode = 0
    ' Loops the dummy node on itself
    This.dummyNode.nextNodePtr = @This.dummyNode
    This.dummyNode.prevNodePtr = @This.dummyNode
    ' Initializes the two recent visited nodes memory with the dummy node
    This.recent1NodeIndex = 0
    This.recent1NodePtr = @This.dummyNode
    This.recent2NodeIndex = 0
    This.recent2NodePtr = @This.dummyNode
    ' Initializes the preallocated memory use
    This.nbrPreAllocUsed = 0
    This.preAllocNbr = 0
End Sub

Function DynamicArrayList.ReturnNumberOfPosition() As Integer
    Return This.nbrUserNode
End Function

Function DynamicArrayList.SearchNthPositionNode(ByVal posNodeIndex As Integer) As DoublyLinkedNode Ptr
    Dim As DoublyLinkedNode Ptr nodePtr
    Dim As Integer n
    This.SearchOffsetRecentPositionNode(posNodeIndex, nodePtr, n)
    Return This.TraverseNodes(nodePtr, n)
End Function

Sub DynamicArrayList.SearchOffsetRecentPositionNode(ByVal posNodeIndex As Integer, ByRef recentNodePtr As DoublyLinkedNode Ptr, ByRef n As Integer)
    ' The node (among these 3) memorized closest to the targeted position
    ' is chosen as starting point of the iteration (forward or backward) through the nodes
    ' (3 * 2 = 6 cases)
    If posNodeIndex < This.recent1NodeIndex Then
        If posNodeIndex <= This.recent1NodeIndex - posNodeIndex Then
            ' dummy node closest to targeted position
            recentNodePtr = @This.dummyNode
            n = posNodeIndex
        Else
            ' recent #1 visited node closest to targeted position
            recentNodePtr = This.recent1NodePtr
            n = posNodeIndex - This.recent1NodeIndex
        End If
    ElseIf posNodeIndex < This.recent2NodeIndex Then
        If posNodeIndex - This.recent1NodeIndex <= This.recent2NodeIndex - posNodeIndex Then
            ' recent #1 visited node closest to targeted position
            recentNodePtr = This.recent1NodePtr
            n = posNodeIndex - This.recent1NodeIndex
        Else
            ' recent #2 visited node closest to targeted position
            recentNodePtr = This.recent2NodePtr
            n = posNodeIndex - This.recent2NodeIndex
        End If
    Else
        If posNodeIndex - This.recent2NodeIndex <= This.nbrUserNode + 1 - posNodeIndex Then
            ' recent #2 visited node closest to targeted position
            recentNodePtr = This.recent2NodePtr
            n = posNodeIndex - This.recent2NodeIndex
        Else
            ' dummy node closest to targeted position
            recentNodePtr = @This.dummyNode
            n = posNodeIndex - This.nbrUserNode - 1
        End If
    End If
End Sub

Function DynamicArrayList.TraverseNodes(ByVal nodePtr As DoublyLinkedNode Ptr, ByVal n As Integer) As DoublyLinkedNode Ptr
    If n > 0 Then
        ' forward iteration
        #define NP nextNodePtr
        For I As Integer = n To 0 Step -25
            Select Case As Const I
            Case  0   :    Return nodePtr
            Case  1   :    Return nodePtr->NP
            Case  2   :    Return nodePtr->NP->NP
            Case  3   :    Return nodePtr->NP->NP->NP
            Case  4   :    Return nodePtr->NP->NP->NP->NP
            Case  5   :    Return nodePtr->NP->NP->NP->NP->NP
            Case  6   :    Return nodePtr->NP->NP->NP->NP->NP->NP
            Case  7   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP
            Case  8   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP
            Case  9   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 10   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 11   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 12   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 13   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 14   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 15   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 16   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 17   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 18   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 19   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 20   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 21   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 22   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 23   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case 24   :    Return nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            Case Else : nodePtr = nodePtr->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP->NP
            End Select
        Next I
    ElseIf n < 0 Then
        ' backward iteration
        #define PP prevNodePtr
        For I As Integer = n To 0 Step +25
            Select Case As Const I
            Case - 0  :    Return nodePtr
            Case - 1  :    Return nodePtr->PP
            Case - 2  :    Return nodePtr->PP->PP
            Case - 3  :    Return nodePtr->PP->PP->PP
            Case - 4  :    Return nodePtr->PP->PP->PP->PP
            Case - 5  :    Return nodePtr->PP->PP->PP->PP->PP
            Case - 6  :    Return nodePtr->PP->PP->PP->PP->PP->PP
            Case - 7  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP
            Case - 8  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP
            Case - 9  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -10  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -11  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -12  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -13  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -14  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -15  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -16  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -17  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -18  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -19  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -20  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -21  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -22  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -23  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case -24  :    Return nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            Case Else : nodePtr = nodePtr->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP->PP
            End Select
        Next I
    Else
        Return nodePtr
    End If
End Function

Constructor DynamicArrayList()
    ' Loops the dummy node on itself
    This.dummyNode.nextNodePtr = @This.dummyNode
    This.dummyNode.prevNodePtr = @This.dummyNode
    ' Initializes the two recent visited nodes memory with the dummy node
    This.recent1NodePtr = @This.dummyNode
    This.recent2NodePtr = @This.dummyNode
    ' Initializes the threading loop
    This._mutex = MutexCreate()                                              '' create mutex
    MutexLock(This._mutex)                                                   '' lock mutex
    This._pt= ThreadCreate(CPtr(Any Ptr, @DynamicArrayList._Thread), @This)  '' launch child thread
End Constructor

Constructor DynamicArrayList(ByVal nbrPreAlloc As Integer)
    Constructor()
    If nbrPreAlloc > 0 Then
        ' Pre-allocates memory for nbrPreAlloc nodes
        This.preAllocPtr = Allocate(nbrPreAlloc * SizeOf(DoublyLinkedNode))
        If This.preAllocPtr > 0 Then This.nbrPreAllocDone = nbrPreAlloc
    End If
End Constructor

Property DynamicArrayList.NumberOfPreAllocUsed() As Integer
    Return This.nbrPreAllocUsed
End Property

Property DynamicArrayList.NumberOfPreAllocAvailable() As Integer
    Return This.nbrPreAllocDone - This.preAllocNbr
End Property

Sub DynamicArrayList._Thread()
    '  Threading loop
    Do
        MutexLock(This._mutex)          '' wait for mutex unlock from main thread
        If This._end = 1 Then Exit Sub  '' exit the threading loop
        This._returnT = This.TraverseNodes(This._nodePtrT, This._nT)
        This._flag = 1                  '' set flag for main thread
    Loop
End Sub

Destructor DynamicArrayList()
    ' Deallocates memory used by user nodes one by one by transverse access
    This.DestroyAllNthPosition()
    If This.nbrPreAllocDone > 0 Then
        ' Deallocates the pre-allocated memory
        Deallocate(This.preAllocPtr)
        This.nbrPreAllocDone = 0
    End If
    ' Ends the threading loop
    This._end = 1              '' set _end for chimld thread
    MutexUnlock(This._mutex)   '' unlock mutex for child thread
    ThreadWait(This._pt)       '' wait for child thread end
    MutexDestroy(This._mutex)  '' destroy mutex
End Destructor
