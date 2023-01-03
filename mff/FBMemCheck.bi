''
'' fbmemcheck (FB Memory Checker) version 0.1
'' Copyright (C) 2020 Xusinboy Bekchanov
'' based on:
'' fbmld (FB Memory Leak Detector) version 0.6
'' Copyright (C) 2006 Daniel R. Verkamp
'' Tree storage implemented by yetifoot
''
'' This software is provided 'as-is', without any express or implied warranty.
'' In no event will the authors be held liable for any damages arising from
'' the use of this software.
''
'' Permission is granted to anyone to use this software for any purpose,
'' including commercial applications, and to alter it and redistribute it
'' freely, subject to the following restrictions:
''
'' 1. The origin of this software must not be misrepresented; you must not claim
'' that you wrote the original software. If you use this software in a product,
'' an acknowledgment in the product documentation would be appreciated but is
'' not required.
''
'' 2. Altered source versions must be plainly marked as such, and must not be
'' misrepresented as being the original software.
''
'' 3. This notice may not be removed or altered from any source
'' distribution.
''

#ifndef __FBMEMCHECK__
	#define __FBMEMCHECK__
	
	#ifndef MEMCHECK
		#define MEMCHECK 1
	#endif
	
	#if MEMCHECK = 0
		#define Allocate_(bytes) Allocate(bytes)
		#define CAllocate_(bytes) CAllocate(bytes)
		#define Reallocate_(pt, bytes) Reallocate(pt, bytes)
		#define Deallocate_(pt) Deallocate pt
		#define New_(type_) New type_
		#define Delete_(pt) Delete pt
		#define Delete_SquareBrackets(pt) Delete[] pt
	#else
		#include once "crt.bi"
		
		#define Allocate_(bytes) fbmld_allocate(bytes, __FILE__, __FUNCTION__, __LINE__)
		#define CAllocate_(bytes) fbmld_callocate(bytes, __FILE__, __FUNCTION__, __LINE__)
		#define Reallocate_(pt, bytes) fbmld_reallocate(pt, bytes, __FILE__, __FUNCTION__, __LINE__, #pt)
		#define Deallocate_(pt) fbmld_deallocate(pt, __FILE__, __FUNCTION__, __LINE__, #pt)
		#macro New_(type_)
			Cast(Typeof(New type_), fbmemcheck_new(New type_, __FILE__, __FUNCTION__, __LINE__))
		#endmacro
		#macro Delete_(pt)
			fbmemcheck_delete(pt, __FILE__, __FUNCTION__, __LINE__, #pt): Delete pt
		#endmacro
		#macro Delete_SquareBrackets(pt)
			fbmemcheck_delete(pt, __FILE__, __FUNCTION__, __LINE__, #pt): Delete[] pt
		#endmacro
		
		Dim Shared FuncName_ As String
		
		Private Type FBMemCheck
		Private:
			_FuncName As String
		Public:
			Declare Constructor(ByRef FuncName As String)
			Declare Destructor
		End Type
		
		Private Type fbmld_t
			pt       As Any Ptr
			bytes    As UInteger
			file     As String
			funcname As String
			linenum  As Integer
			value    As String
			Left     As fbmld_t Ptr
			Right    As fbmld_t Ptr
		End Type
		
		Common Shared fbmld_tree As fbmld_t Ptr
		Common Shared fbmld_deleted_tree As fbmld_t Ptr
		Common Shared fbmld_mutex As Any Ptr
		Common Shared fbmld_instances As Integer
		
		Private Sub fbmld_print(ByRef s As String)
			fprintf(stderr, "(FBMEMCHECK) " & s & Chr(10))
		End Sub
		
		Private Sub fbmld_mutexlock( )
			#ifndef FBMLD_NO_MULTITHREADING
				MutexLock(fbmld_mutex)
			#endif
		End Sub
		
		Private Sub fbmld_mutexunlock( )
			#ifndef FBMLD_NO_MULTITHREADING
				MutexUnlock(fbmld_mutex)
			#endif
		End Sub
		
		
		Private Function new_node _
			( _
			ByVal pt       As Any Ptr, _
			ByVal bytes    As UInteger, _
			ByRef file     As String, _
			ByRef funcname As String, _
			ByVal linenum  As Integer, _
			ByRef value    As String = "" _
			) As fbmld_t Ptr
			
			Dim As fbmld_t Ptr node = calloc(1, SizeOf(fbmld_t))
			
			node->pt = pt
			node->bytes = bytes
			node->file = file
			node->funcname = funcname
			node->linenum = linenum
			node->value = value
			node->left = NULL
			node->right = NULL
			
			Function = node
			
		End Function
		
		Private Sub free_node _
			( _
			ByVal node As fbmld_t Ptr _
			)
			
			node->file = ""
			node->funcname = ""
			node->value = ""
			free( node )
			
		End Sub
		
		Private Function fbmld_search _
			( _
			ByVal root    As fbmld_t Ptr Ptr, _
			ByVal pt      As Any Ptr _
			) As fbmld_t Ptr Ptr
			
			Dim As fbmld_t Ptr Ptr node = root
			Dim As Any Ptr a = pt, b = Any
			
			Asm
				mov eax, dword Ptr [a]
				bswap eax
				mov dword Ptr [a], eax
			End Asm
			
			While *node <> NULL
				b = (*node)->pt
				Asm
					mov eax, dword Ptr [b]
					bswap eax
					mov dword Ptr [b], eax
				End Asm
				If a < b Then
					node = @(*node)->left
				ElseIf a > b Then
					node = @(*node)->right
				Else
					Exit While
				End If
			Wend
			
			Function = node
			
		End Function
		
		Private Sub fbmld_insert _
			( _
			ByVal root     As fbmld_t Ptr Ptr, _
			ByVal pt       As Any Ptr, _
			ByVal bytes    As UInteger, _
			ByRef file     As String, _
			ByRef funcname As String, _
			ByVal linenum  As Integer, _
			ByRef value As String = "" _
			)
			
			Dim As fbmld_t Ptr Ptr node = fbmld_search(root, pt)
			
			If *node = NULL Then
				*node = new_node( pt, bytes, file, funcname, linenum, value )
			End If
			
		End Sub
		
		Private Sub fbmld_swap _
			( _
			ByVal node1 As fbmld_t Ptr Ptr, _
			ByVal node2 As fbmld_t Ptr Ptr _
			)
			
			Swap (*node1)->pt,       (*node2)->pt
			Swap (*node1)->bytes,    (*node2)->bytes
			Swap (*node1)->file,     (*node2)->file
			Swap (*node1)->funcname, (*node2)->funcname
			Swap (*node1)->linenum,  (*node2)->linenum
			
		End Sub
		
		Private Sub fbmld_delete _
			( _
			ByVal node As fbmld_t Ptr Ptr _
			)
			
			Dim As fbmld_t Ptr old_node = *node
			Dim As fbmld_t Ptr Ptr pred
			
			If (*node)->left = NULL Then
				*node = (*node)->right
				free_node( old_node )
			ElseIf (*node)->right = NULL Then
				*node = (*node)->left
				free_node( old_node )
			Else
				pred = @(*node)->left
				While (*pred)->right <> NULL
					pred = @(*pred)->right
				Wend
				fbmld_swap( node, pred )
				fbmld_delete( pred )
			End If
			
		End Sub
		
		Private Sub fbmld_init _
			( _
			) Constructor 101
			
			If fbmld_instances = 0 Then
				#ifndef FBMLD_NO_MULTITHREADING
					fbmld_mutex = MutexCreate()
				#endif
			End If
			fbmld_instances += 1
		End Sub
		
		Dim Shared bytesCount As UInteger
		
		Private Sub fbmld_tree_clean _
			( _
			ByVal node As fbmld_t Ptr Ptr _
			)
			
			If *node <> NULL Then
				fbmld_tree_clean( @((*node)->left) )
				fbmld_tree_clean( @((*node)->right) )
				If FuncName_ = "" OrElse FuncName_ = (*node)->funcname Then
					fbmld_print( "error: " & (*node)->bytes & " bytes allocated/created at " & (*node)->file & "(" & (*node)->funcname & "): " & (*node)->linenum & " [&H" & Hex( (*node)->pt, 8 ) & "][" & (*node)->pt & "] not deallocated/deleted" & IIf((*node)->funcname = "WREALLOCATE" OrElse (*node)->funcname = "WLET" OrElse (*node)->funcname = "USTRING.constructor" OrElse (*node)->funcname = "USTRING.operator.let" OrElse (*node)->funcname = "WSTRINGLIST.ADD" OrElse (*node)->funcname = "WSTRINGLIST.INSERT" OrElse (*node)->funcname = "USTRING.RESIZE", ". Value: """ & *Cast(WString Ptr, (*node)->pt) & """", ""))
				End If
				bytesCount += (*node)->bytes
				(*node)->file = ""
				(*node)->funcname = ""
				(*node)->value = ""
				free( (*node)->pt )
				free( *node )
				*node = NULL
			End If
		End Sub
		
		Private Sub fbmld_exit _
			( _
			) Destructor 101
			
			fbmld_instances -= 1
			
			If fbmld_instances = 0 Then
				
				#if MEMCHECK
					If fbmld_tree <> NULL Then
						fbmld_print("---- memory leaks ----")
						fbmld_tree_clean(@fbmld_tree)
						fbmld_print("totally " & Str(bytesCount) & " bytes memory not deallocated")
					Else
						fbmld_print("all memory deallocated")
					End If
				#endif
				
				#ifndef FBMLD_NO_MULTITHREADING
					If fbmld_mutex <> 0 Then
						MutexDestroy(fbmld_mutex)
						fbmld_mutex = 0
					End If
				#endif
				
			End If
			
		End Sub
		
		Private Constructor FBMemCheck(ByRef FuncName As String)
			fbmld_exit
			FuncName_ = FuncName
		End Constructor
		
		Private Destructor FBMemCheck
			fbmld_exit
		End Destructor
		
		Private Function fbmld_allocate(ByVal bytes As UInteger, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer) As Any Ptr
			Dim ret As Any Ptr = Any
			
			fbmld_mutexlock()
			
			If bytes = 0 Then
				fbmld_print("warning: allocate(0) called at " & file & " in " & funcname & ":" & linenum & "; returning NULL")
				ret = 0
			Else
				ret = Allocate(bytes) 'malloc(bytes)
				fbmld_insert(@fbmld_tree, ret, bytes, file, funcname, linenum)
			End If
			
			fbmld_mutexunlock()
			
			Return ret
		End Function
		
		Private Function fbmemcheck_new(ByVal pt As Any Ptr, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer) As Any Ptr
			Dim ret As Any Ptr = pt
			
			fbmld_mutexlock()
			
			If pt = 0 Then
				fbmld_print("warning: new(0) called at " & file & "in " & funcname & ":" & linenum & "; returning NULL")
			Else
				fbmld_insert(@fbmld_tree, ret, SizeOf(pt), file, funcname, linenum)
			End If
			
			fbmld_mutexunlock()
			
			Return ret
		End Function
		
		Private Function fbmld_callocate(ByVal bytes As UInteger, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer) As Any Ptr
			Dim ret As Any Ptr = Any
			
			fbmld_mutexlock()
			
			If bytes = 0 Then
				fbmld_print("warning: callocate(0) called at " & file & " in " & funcname & ":" & linenum & "; returning NULL")
				ret = 0
			Else
				ret =  CAllocate(bytes) 'calloc(1, bytes)
				fbmld_insert(@fbmld_tree, ret, bytes, file, funcname, linenum)
			End If
			
			fbmld_mutexunlock()
			
			Return ret
		End Function
		
		Private Function fbmld_reallocate(ByVal pt As Any Ptr, ByVal bytes As UInteger, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer, ByRef varname As String) As Any Ptr
			Dim ret As Any Ptr = Any
			Dim node As fbmld_t Ptr Ptr = Any
			Dim value As String
			
			fbmld_mutexlock()
			
			node = fbmld_search(@fbmld_tree, pt)
			'	If linenum = 378 Then
			'		?"->", pt
			'	End If
			
			If pt = NULL Then
				If bytes = 0 Then
					fbmld_print("error: reallocate(" & varname & " [NULL] , 0) called at " & file & " in " & funcname & ":" & linenum)
					ret = NULL
				Else
					ret = Allocate(bytes) 'malloc(bytes)
					fbmld_insert(@fbmld_tree, ret, bytes, file, funcname, linenum)
				End If
			ElseIf *node = NULL Then
				fbmld_print("error: invalid reallocate(" & varname & " [&H" & Hex(pt, 8) & "] ) at " & file & " in " & funcname & ":" & linenum)
				ret = NULL
			ElseIf bytes = 0 Then
				fbmld_print("warning: reallocate(" & varname & " [&H" & Hex(pt, 8) & "] , 0) called at " & file & " in " & funcname & ":" & linenum & "; deallocating")
				If *node <> NULL Then 
					fbmld_insert(@fbmld_deleted_tree, (*node)->pt, (*node)->bytes, (*node)->file, (*node)->funcname, (*node)->linenum, (*node)->value)
					fbmld_delete(node)
				End If
				Deallocate pt 'free(pt)
				ret = NULL
			Else
				If funcname = "WREALLOCATE" OrElse funcname = "WLET" Then
					value = *Cast(WString Ptr, pt)
				End If
				
				ret = Reallocate(pt, bytes) 'realloc(pt, bytes)
				
				'		If linenum = 378 Then
				'			?"<-", ret
				'		End If
				
				If ret = pt Then
					(*node)->bytes = bytes
					(*node)->file = file
					(*node)->funcname = funcname
					(*node)->linenum = linenum
				Else
					(*node)->value = value
					'			If (*node)->linenum = 378 Then
					'				?"deleting r", (*node)->pt
					'			End If
					fbmld_insert(@fbmld_deleted_tree, (*node)->pt, (*node)->bytes, (*node)->file, (*node)->funcname, (*node)->linenum, (*node)->value)
					fbmld_delete(node)
					fbmld_insert(@fbmld_tree, ret, bytes, file, funcname, linenum)
				End If
			End If
			
			fbmld_mutexunlock()
			
			Return ret
		End Function
		
		Private Sub fbmld_deallocate(ByVal pt As Any Ptr, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer, ByRef varname As String)
			Dim node As fbmld_t Ptr Ptr
			
			fbmld_mutexlock()
			
			If pt = NULL Then
				fbmld_print("warning: deallocate(" & varname & " [NULL] ) at " & file & " in " & funcname & ":" & linenum)
			Else
				node = fbmld_search(@fbmld_tree, pt)
				
				If *node = NULL Then
					fbmld_print("error: invalid deallocate(" & varname & " [&H" & Hex(pt, 8) & "] ) at " & file & " in " & funcname & ":" & linenum)
					'(*node)->file = "" ' UnComment this if you want to found problem with gdb backtrace
					node = fbmld_search(@fbmld_deleted_tree, pt)
					If *node <> NULL Then
						fbmld_print("info: this deallocated at " & (*node)->file & " in " & (*node)->funcname & ":" & (*node)->linenum & ". Value: " & (*node)->value)
					End If
				Else
					If funcname = "WDEALLOCATE" Then
						(*node)->value = *Cast(WString Ptr, (*node)->pt)
					End If
					'			If (*node)->linenum = 378 Then
					'				?"deleting d", (*node)->pt
					'			End If
					fbmld_insert(@fbmld_deleted_tree, (*node)->pt, (*node)->bytes, (*node)->file, (*node)->funcname, (*node)->linenum, (*node)->value)
					fbmld_delete(node)
					Deallocate pt 'free(pt)
				End If
			End If
			
			fbmld_mutexunlock()
		End Sub
		
		Private Sub fbmemcheck_delete(ByVal pt As Any Ptr, ByRef file As String, ByRef funcname As String, ByVal linenum As Integer, ByRef varname As String)
			Dim node As fbmld_t Ptr Ptr
			
			fbmld_mutexlock()
			
			If pt = NULL Then
				fbmld_print("warning: delete(" & varname & " [NULL] ) at " & file & " in " & funcname & ":" & linenum)
			Else
				node = fbmld_search(@fbmld_tree, pt)
				
				If *node = NULL Then
					fbmld_print("error: invalid delete(" & varname & " [&H" & Hex(pt, 8) & "] ) at " & file & " in " & funcname & ":" & linenum)
				Else
					fbmld_insert(@fbmld_deleted_tree, (*node)->pt, (*node)->bytes, (*node)->file, (*node)->funcname, (*node)->linenum, (*node)->value)
					fbmld_delete(node)
				End If
			End If
			
			fbmld_mutexunlock()
		End Sub
		
	#endif '' MEMCHECK = 0
	
#endif '' __FBMEMCHECK__

#ifndef __FBFILENUMCHECK__
	#define __FBFILENUMCHECK__
	
	#ifndef FILENUMCHECK
		#define FILENUMCHECK 1
	#endif
	
	#if FILENUMCHECK = 0
		#define FreeFile_ FreeFile
		#define CloseFile_(filenum) Close filenum
	#else
		Common Shared As Long filenumberCounter
		Common Shared As Boolean Ptr filenumbers
		#define FreeFile_ FreeFileNumber_(__FILE__, __FUNCTION__, __LINE__)
		
		Declare Function FreeFileNumber_(ByRef file As String, ByRef funcname As String, ByVal linenum As Integer) As Long
		Declare Function CloseFile_(filenum As Long) As Long
		
		Private Function FreeFileNumber_(ByRef file As String, ByRef funcname As String, ByVal linenum As Integer) As Long
			For i As Integer = 1 To filenumberCounter
				If filenumbers[i] = False Then 
					filenumbers[i] = True
					'?"FreeFile: ", i, file, funcname, linenum
					Return i
				End If
			Next
			filenumberCounter += 1
			filenumbers = Reallocate_(filenumbers, (filenumberCounter + 1) * SizeOf(Boolean))
			filenumbers[filenumberCounter] = True
			'?"FreeFile: ", filenumberCounter, file, funcname, linenum
			Return filenumberCounter
		End Function
		
		Private Function CloseFile_(filenum As Long) As Long
			If filenumberCounter >= filenum Then
				If filenumbers[filenum] Then
					filenumbers[filenum] = False
				Else
					Print "File number closed earlier"
				End If
			Else
				Print "File number not retrieved from FreeFile"
			End If
			'?"Close: ", filenum
			Return Close(filenum)
		End Function
	#endif
#endif
