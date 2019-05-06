'###############################################################################
'#  IniFile.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TIniFile.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#Include Once "StringList.bi"

#DEFINE QIniFile(__Ptr__) *Cast(IniFile Ptr,__Ptr__)

Type IniFile
    Private:
        FFile As WString Ptr
        FLines        As WStringList
        FSectionCount As Integer
        Declare Function SectionExists(ByRef Section As WString) As Integer
        Declare Function KeyExists(ByRef Section As WString, ByRef Key As WString) As Integer
        Declare Sub Update
    Public:
        Declare Property File ByRef As WString
        Declare Property File(ByRef Value As WString)
        Declare Property SectionCount As Integer
        Declare Property SectionCount(Value As Integer)
        Declare Sub Load(ByRef sFile As WString = "") 
        Declare Sub WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
        Declare Sub WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
        Declare Sub WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
        Declare Sub WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
        Declare Function ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
        Declare Function ReadFloat(ByRef Section As WString, ByRef Key As WString, Inplace As Double = 0.0) As Double
        Declare Function ReadBool(ByRef Section As WString, ByRef Key As WString, Inplace As Boolean = False) As Boolean
        Declare Function ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") ByRef As WString
        Declare Operator Cast As Any Ptr
        Declare Constructor
        Declare Destructor
End Type

Property IniFile.File ByRef As WString
    Return WGet(FFile)
End Property

Property IniFile.File(ByRef Value As WString)
    WLet FFile, Value
End Property

Property IniFile.SectionCount As Integer
    FSectionCount = 0
    Dim As WString Ptr s
    For i As Integer = 0 To FLines.Count -1
        s = @FLines.Item(i)
        If s[0] <> "" Then If s[0] <> Asc(";") Then If s[0] = Asc("[") Then FSectionCount += 1
    Next i
    Return FSectionCount
End Property

Property IniFile.SectionCount(Value As Integer)
End Property

Function IniFile.SectionExists(ByRef Section As WString) As Integer
    Dim As WString Ptr s
    For i As Integer = 0 To FLines.Count -1
        s = @FLines.Item(i)
        If *s <> "" Then
            If s[0] <> Asc(";") Then
                If s[0] = Asc("[") Then 
                    If UCase(Section) = UCase(Trim(Trim(*s,"["),"]")) Then Return i
                End If
            End If
        End If
    Next i
    Return -1
End Function

Function IniFile.KeyExists(ByRef Section As WString, ByRef Key As WString) As Integer
    Dim As Integer x
    Dim As WString Ptr s
    x = SectionExists(Section)
    If x <> -1 Then
        For i As Integer = x + 1 To FLines.Count -1
            s = @FLines.Item(i)
            If *s <> "" Then 
                If s[0] <> Asc(";") Then 
                    If s[0] = Asc("[") Then Return -1
                    If s[0] <> Asc("[") Then If UCase(Key) = UCase(Trim(Mid(*s, 1, InStr(*s, "=") - 1))) Then Return i
                End If
            End If
        Next i
    End If
    Return -1
End Function

Sub IniFile.Load(ByRef sFile As WString = "")
    FLines.Clear
    If sFile <> "" Then WLet FFile, sFile
    Dim As Integer ff = FreeFile
    If Open(File For Binary Access Read As #ff) = 0 Then
        Dim As WString Ptr s
        WReallocate s, LOF(ff)
        While Not EOF(ff)
            Line Input #ff, *s
            If *s <> "" Then FLines.Add *s
        WEnd
        Close #ff
        Deallocate s
    End If 
End Sub

Sub IniFile.Update
    If Open(File For Binary Access Write As #1) = 0 Then
        For i As Integer = 0 To FLines.Count -1
            Print #1, FLines.Item(i)
        Next i
        Close #1
    End If
End Sub

Sub IniFile.WriteInteger(ByRef Section As WString, ByRef Key As WString, Value As Integer)
    Dim As Integer SecIndex, KeyIndex
    SecIndex = SectionExists(Section)
    If SecIndex <> -1 Then
        KeyIndex = KeyExists(Section,Key)
        If KeyIndex <> -1 Then
            FLines.Item(KeyIndex) = Key & "=" & Str(Value)
            Update
        Else
            If SecIndex < FLines.Count -1 Then
               Dim As Integer LastIndex
               For i As Integer = SecIndex +1 To FLines.Count-1
                   Dim As WString Ptr s
                   s = @FLines.Item(i)
                   If *s <> "" Then 
                       LastIndex = i
                       If s[0] = Asc("[") Then Exit For
                   End If
               Next i
               If LastIndex = FLines.Count -1 Then
                 FLines.Add Key & "=" & WStr(Value)
                 Update 
               Else
                  FLines.Insert LastIndex, Key & "=" & WStr(Value)
               End If
               Update
            Else
               FLines.Add Key & "=" & WStr(Value)
               Update
            End If
        End If
    Else
        FLines.Add "[" & Section & "]"
        FLines.Add Key & "=" & WStr(Value)
        Update
    End If
End Sub

Sub IniFile.WriteFloat(ByRef Section As WString, ByRef Key As WString, Value As Double)
Dim As Integer SecIndex,KeyIndex
    SecIndex = SectionExists(Section)
    If SecIndex <> -1 Then
        KeyIndex = KeyExists(Section,Key)
        If KeyIndex <> -1 Then
            FLines.Item(KeyIndex) = Key & "=" & WStr(Value)
            Update
        Else
            If SecIndex < FLines.Count -1 Then
               Dim As Integer LastIndex
               For i As Integer = SecIndex +1 To FLines.Count-1
                   Dim As WString Ptr s
                   s = @FLines.Item(i)
                   If *s <> "" Then 
                       LastIndex = i
                       If s[0] = Asc("[") Then Exit For
                   End If
               Next i
               If LastIndex = FLines.Count -1 Then
                 FLines.Add Key & "=" & WStr(Value)
                 Update 
               Else
                  FLines.Insert LastIndex,Key & "=" & WStr(Value)
               End If
               Update
            Else
               FLines.Add Key & "=" & WStr(Value)
               Update
            End If
        End If
    Else
        FLines.Add "[" & Section & "]"
        FLines.Add Key & "=" & WStr(Value)
        Update
    End If
End Sub

Sub IniFile.WriteBool(ByRef Section As WString, ByRef Key As WString, Value As Boolean)
Dim As Integer SecIndex, KeyIndex
    SecIndex = SectionExists(Section)
    If SecIndex <> -1 Then
        KeyIndex = KeyExists(Section,Key)
        If KeyIndex <> -1 Then
            FLines.Item(KeyIndex) = Key & "=" & WStr(Value) & Chr(0)
            Update
        Else
            If SecIndex < FLines.Count -1 Then
               Dim As Integer LastIndex
               For i As Integer = SecIndex +1 To FLines.Count-1
                   Dim As WString Ptr s
                   s = @FLines.Item(i)
                   If *s <> "" Then 
                       LastIndex = i
                       If s[0] = Asc("[") Then Exit For
                   End If
               Next i
               If LastIndex = FLines.Count -1 Then
                 FLines.Add Key & "=" & WStr(Value)
                 Update 
               Else
                  FLines.Insert LastIndex,Key & "=" & WStr(Value)
               End If
               Update
            Else
               FLines.Add Key & "=" & WStr(Value)
               Update
            End If
        End If
    Else
        FLines.Add "[" & Section & "]"
        FLines.Add Key & "=" & WStr(Value)
        Update
    End If
End Sub

Sub IniFile.WriteString(ByRef Section As WString, ByRef Key As WString, ByRef Value As WString)
    Dim As Integer SecIndex, KeyIndex
    SecIndex = SectionExists(Section)
    If SecIndex <> -1 Then
        KeyIndex = KeyExists(Section,Key)
        If KeyIndex <> -1 Then
            FLines.Item(KeyIndex) = Key + "=" + Value + WChr(0)
            Update
        Else
            If SecIndex < FLines.Count -1 Then
               Dim As Integer LastIndex
               For i As Integer = SecIndex +1 To FLines.Count-1
                   Dim As WString Ptr s
                   s = @FLines.Item(i)
                   If *s <> "" Then 
                       LastIndex = i
                       If s[0] = Asc("[") Then Exit For
                   End If
               Next i
               If LastIndex = FLines.Count -1 Then
                 FLines.Add Key + "=" + Value
                 Update 
               Else
                  FLines.Insert LastIndex,Key & "=" & WStr(Value)
               End If
               Update
            Else
               FLines.Add Key + "=" + Value
               Update
            End If
        End If
    Else
        FLines.Add "[" & Section & "]"
        FLines.Add Key + "=" + Value
        Update
    End If
End Sub

Function IniFile.ReadInteger(ByRef Section As WString, ByRef Key As WString, Inplace As Integer = 0) As Integer
    Dim As Integer Index
    Dim As WString Ptr s
    If SectionExists(Section) <> -1 Then
        Index = KeyExists(Section, Key)
        If Index <> -1 Then
            Dim Value As Integer
            s = @FLines.Item(Index)
            Return ValInt(Mid(*s, InStr(*s, "=") + 1, Len(*s)))
        Else
            Return Inplace
        End If
    Else
        Return Inplace
    End If
End Function

Function IniFile.ReadFloat(ByRef Section As WString, ByRef Key As WString, Inplace As Double = 0.0) As Double
    Dim As Integer Index
    Dim As WString Ptr s
    If SectionExists(Section) <> -1 Then
        Index = KeyExists(Section, Key)
        If Index <> -1 Then
            s = @FLines.Item(Index)
            Return Val(Mid(*s, InStr(*s, "=") + 1, Len(*s)))
        Else
            Return Inplace
        End If
    Else
        Return Inplace
    End If
End Function

Function IniFile.ReadBool(ByRef Section As WString, ByRef Key As WString, Inplace As Boolean = False) As Boolean
    Dim As Integer Index
    Dim As WString Ptr s
    If SectionExists(Section) <> -1 Then
        Index = KeyExists(Section, Key)
        If Index <> -1 Then
            s = @FLines.Item(Index)
            Return Cast(Boolean, Trim(Mid(*s, InStr(*s, "=") + 1, Len(*s))))
        Else
            Return Inplace
        End If
    Else
        Return Inplace
    End If
End Function

Function IniFile.ReadString(ByRef Section As WString, ByRef Key As WString, ByRef Inplace As WString = "") ByRef As WString
    Dim As Integer Index
    Dim As WString Ptr s
    If SectionExists(Section) <> -1 Then
        Index = KeyExists(Section, Key)
        If Index <> -1 Then
            WLet s, FLines.Item(Index)
            *s = Mid(*s, InStr(*s, "=") + 1, Len(*s))
            Return *s
        Else
            Return Inplace
        End If
    Else
        Return Inplace
    End If
End Function

Operator IniFile.Cast As Any Ptr
    Return @This
End Operator

Constructor IniFile
    Dim As WString * 255 Tx
    Dim As Integer L, i, k
    #IfNdef __USE_GTK__
		L = GetModuleFileName(GetModuleHandle(NULL), Tx, 255)
    #EndIf
    Tx = Left(Tx, L)
    For i = 0 To Len(Tx)
        If Tx[i] = Asc(".") Then k = i +1
    Next i
    File =  Mid(Tx, 1, k - 1) + ".ini"
End Constructor

Destructor IniFile
    'If FLines Then DeAllocate FLines
End Destructor
