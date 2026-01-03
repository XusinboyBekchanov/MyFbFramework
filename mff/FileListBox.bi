'################################################################################
'#  FileListBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################
#include once "mff/WStringList.bi"
#include once "dir.bi"
' 常量定义
Const FILE_ATTRIBUTES = fbReadOnly Or fbHidden Or fbSystem Or fbArchive
Const DIR_ATTRIBUTES = FILE_ATTRIBUTES Or fbDirectory
Const PATH_SEPARATOR = "/"  ' 统一使用正斜杠

'Display a list of files from a specified directory, optionally filtered by file type (extension).
Type FileListBox
Private:
	m_path As String
	m_pattern As String
	m_ListIndex As Integer = -1
	m_IncludeSub As Boolean
	Folders As WStringList
	
	Declare Function NormalizePath(ByRef path As WString) As String
	Declare Sub SafeAddFile(ByRef filePath As WString)
	Declare Sub SafeAddFolder(ByRef folderPath As WString)
	Declare Sub InternalRefresh(ByRef iPath As WString)
	
Public:
	' 构造函数/析构函数
	Declare Constructor()
	Declare Destructor()
	
	' Sets/Gets the current directory path.
	Declare Property Path(ByRef newPath As WString)
	Declare Property Path() As String
	
	' Sets/gets the File filter Pattern.
	Declare Property Pattern(ByRef newPattern As String)
	Declare Property Pattern() As String
	
	' Gets the total number of files.
	Declare Property ListCount() As Integer
	
	' Gets/sets the index of the currently selected file.
	Declare Property ListIndex(ByVal Value As Integer)
	Declare Property ListIndex() As Integer
	
	' Sets/gets whether to search in subdirectories
	Declare Property IncludeSub(ByVal Value As Boolean)
	Declare Property IncludeSub() As Boolean
	
	' Gets whether the list is currently loading
	IsLoading As Boolean
	
	' Gets the full filename of the selected file.
	Declare Function FileName(ByVal Index As Integer = -1) As String
	
	' Gets the Filename List.
	FileList As WStringList
	
	' Refreshes the File List.
	Declare Sub Refresh(ByRef iPath As WString = "")
End Type

Private Property FileListBox.Path(ByRef newPath As WString)
	Dim As WString * 1024 tmpStr = NormalizePath(newPath)
	If Dir(Mid(tmpStr, 1, Len(tmpStr) - 1), fbDirectory) <> "" Then
		m_path = tmpStr
		This.Refresh(m_path)
	Else
		Debug.Print "Path does not exist: " & newPath
	End If
End Property

Private Property FileListBox.Path() As String
	Return m_path
End Property

Private Function FileListBox.FileName(ByVal Index As Integer = -1) As String
	If Index = -1 Then Index = m_ListIndex
	If Index >= 0 AndAlso Index < FileList.Count Then
		Return FileList.Item(Index)
	End If
	Return ""
End Function

Private Property FileListBox.Pattern(ByRef newPattern As String)
	If m_pattern <> newPattern Then
		m_pattern = newPattern
		Refresh()
	End If
End Property

Private Property FileListBox.Pattern() As String
	Return m_pattern
End Property

Private Property FileListBox.IncludeSub(ByVal Value As Boolean)
	If m_IncludeSub <> Value Then
		m_IncludeSub = Value
		Refresh()
	End If
End Property

Private Property FileListBox.IncludeSub() As Boolean
	Return m_IncludeSub
End Property

Private Property FileListBox.ListCount() As Integer
	Return FileList.Count
End Property

Private Property FileListBox.ListIndex(ByVal Value As Integer)
	If Value >= -1 AndAlso Value < FileList.Count Then
		m_ListIndex = Value
	End If
End Property

Private Property FileListBox.ListIndex() As Integer
	Return m_ListIndex
End Property

Private Function FileListBox.NormalizePath(ByRef iPath As WString) As String
	Dim result As String = iPath
	' 统一替换路径分隔符
	result = Replace(result, "\", PATH_SEPARATOR)
	' 确保以分隔符结尾
	If Right(result, 1) <> PATH_SEPARATOR Then result += PATH_SEPARATOR
	Return result
End Function

Private Sub FileListBox.SafeAddFile(ByRef filePath As WString)
	'MutexLock(m_Mutex)
	FileList.Add(filePath)
	'MutexUnlock(m_Mutex)
End Sub

Private Sub FileListBox.SafeAddFolder(ByRef folderPath As WString)
	'MutexLock(m_Mutex)
	Folders.Add(folderPath)
	'MutexUnlock(m_Mutex)
End Sub

Private Sub FileListBox.Refresh(ByRef iPath As WString = "")
	If IsLoading AndAlso m_path = NormalizePath(iPath) Then Return
	If Len(iPath) > 0 Then m_path = NormalizePath(iPath)
	IsLoading = False 
	FileList.Clear
	Folders.Clear
	InternalRefresh(m_path)
	IsLoading = True 
End Sub

Private Sub FileListBox.InternalRefresh(ByRef iPath As WString)
	
	Dim As WString * 1024 f 
	Dim As UInteger  Attr, SearchAttr
	Dim Patterns() As String
	If m_pattern = "" Then m_pattern = "*"
	Dim patternCount As Integer = Split(m_pattern, ";", Patterns())
	SearchAttr = IIf(m_IncludeSub, DIR_ATTRIBUTES, FILE_ATTRIBUTES)
	For i As Integer = 0 To patternCount - 1
		f = Dir(iPath & Patterns(i), SearchAttr, Attr)
		While Len(f) > 0
			If (Attr And fbDirectory) <> 0 Then
				If f <> "." AndAlso f <> ".." Then
					SafeAddFolder(iPath & f & PATH_SEPARATOR)
				End If
			Else
				SafeAddFile(iPath & f)
			End If
			f = Dir(Attr)
		Wend
	Next
	If m_IncludeSub Then
		For i As Integer = 0 To Folders.Count - 1
			InternalRefresh(Folders.Item(i))
		Next
	End If
End Sub

Constructor FileListBox()
	m_pattern = "*"
	m_ListIndex = -1
	m_IncludeSub = False
End Constructor

Destructor FileListBox()
	FileList.Clear
	Folders.Clear
End Destructor
''
'' 测试代码
'Dim As FileListBox file1
'file1.Path = "c:\GitHub\VisualFBEditorPro\Resources\AIAgent\models"
'
''file1.Pattern = "*.bas;*.doc"
''file1.Pattern = "*.png"
'
'Debug.Print "Files Count: " & file1.ListCount
'For i As Integer = 0 To file1.ListCount - 1
'	Debug.Print i & ": " & file1.FileList.Item(i)
'Next
'Sleep(5000)
'End