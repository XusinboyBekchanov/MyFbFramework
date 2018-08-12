'###############################################################################
'#  Cursor.bi                                                                  #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Object.bi"

#DEFINE crArrow       LoadCursor(0,IDC_ARROW)
#DEFINE crAppStarting LoadCursor(0,IDC_APPSTARTING)
#DEFINE crCross       LoadCursor(0,IDC_CROSS)
#DEFINE crIBeam       LoadCursor(0,IDC_IBEAM)
#DEFINE crIcon        LoadCursor(0,IDC_ICON)
#DEFINE crNo          LoadCursor(0,IDC_NO)
#DEFINE crSize        LoadCursor(0,IDC_SIZE)
#DEFINE crSizeAll     LoadCursor(0,IDC_SIZEALL)
#DEFINE crSizeNESW    LoadCursor(0,IDC_SIZENESW)
#DEFINE crSizeNS      LoadCursor(0,IDC_SIZENS)
#DEFINE crSizeNWSE    LoadCursor(0,IDC_SIZENWSE)
#DEFINE crSizeWE      LoadCursor(0,IDC_SIZEWE)
#DEFINE crUpArrow     LoadCursor(0,IDC_UPARROW)
#DEFINE crWait        LoadCursor(0,IDC_WAIT)
#DEFINE crDrag        LoadCursor(GetModuleHandle(NULL),"DRAG")
#DEFINE crMultiDrag   LoadCursor(GetModuleHandle(NULL),"MULTIDRAG")
#DEFINE crHandPoint   LoadCursor(GetModuleHandle(NULL),"HANDPOINT")
#DEFINE crSQLWait     LoadCursor(GetModuleHandle(NULL),"SQLWAIT")
#DEFINE crHSplit      LoadCursor(GetModuleHandle(NULL),"HSPLIT")
#DEFINE crVSplit      LoadCursor(GetModuleHandle(NULL),"VSPLIT")
#DEFINE crNoDrop      LoadCursor(GetModuleHandle(NULL),"NODROP")

Namespace My.Sys.Drawing
    #DEFINE QCursor(__Ptr__) *Cast(Cursor Ptr,__Ptr__)

    Type Cursor Extends My.Sys.Object
        Private:
            FWidth     As Integer
            FHeight    As Integer
            FHotSpotX  As Integer
            FHotSpotY  As Integer
            Declare Sub Create
        Public:
            Graphic    As Any Ptr
            Handle     As HCURSOR
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property HotSpotX As Integer
            Declare Property HotSpotX(Value As Integer)
            Declare Property HotSpotY As Integer
            Declare Property HotSpotY(Value As Integer)
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromResourceName(ByRef ResName As WString)
            Declare Sub LoadFromResourceID(ResID As Integer)
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Operator Let(Value As HCURSOR)
            Declare Operator Let(Value As Cursor)
            Declare Constructor
            Declare Constructor(FHandle As HCursor)
            Declare Destructor
            Changed As Sub(BYREF Sender As Cursor)
    End Type

    Property Cursor.Width As Integer
        Return FWidth 
    End Property

    Property Cursor.Width(Value As Integer)
        FWidth = Value
    End Property

    Property Cursor.Height As Integer
        Return FHeight
    End Property

    Property Cursor.Height(Value As Integer)
        FHeight = Value
    End Property

    Property Cursor.HotSpotX As Integer
        Return FHotSpotX
    End Property

    Property Cursor.HotSpotX(Value As Integer)
       FHotSpotX = Value
    End Property

    Property Cursor.HotSpotY As Integer
        Return FHotSpotY
    End Property

    Property Cursor.HotSpotY(Value As Integer)
        FHotSpotY = Value
    End Property

    Sub Cursor.LoadFromFile(ByRef File As WString)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(0,File,IMAGE_CURSOR,0,0,LR_LOADFROMFILE)
        GetIconInfo(Handle, @ICIF)
        GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        FHotSpotX = ICIF.xHotSpot
        FHotSpotY = ICIF.yHotSpot
        If Changed Then Changed(This)
    End Sub

    Sub Cursor.SaveToFile(ByRef File As WString)
    End Sub

    Sub Cursor.LoadFromResourceName(ByRef ResName As WString)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
        GetIconInfo(Handle,@ICIF)
        GetObject(ICIF.hbmColor,SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        FHotSpotX = ICIF.xHotSpot
        FHotSpotY = ICIF.yHotSpot
        If Changed Then Changed(This)
    End Sub

    Sub Cursor.LoadFromResourceID(ResID As Integer)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE)
        GetIconInfo(Handle,@ICIF)
        GetObject(ICIF.hbmColor,SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        FHotSpotX = ICIF.xHotSpot
        FHotSpotY = ICIF.yHotSpot
        If Changed Then Changed(This)
    End Sub

    Sub Cursor.Create
    End Sub

    Operator Cursor.Cast As Any Ptr
        Return @This
    End Operator

    Operator Cursor.Let(ByRef Value As WString)
        If FindResource(GetModuleHandle(NULL), Value, RT_CURSOR) Then
           LoadFromResourceName(Value)
        Else
           LoadFromFile(Value)
        End If
    End Operator

    Operator Cursor.Let(Value As HCURSOR)
        Handle = Value
    End Operator

    Operator Cursor.Let(Value As Cursor)
        Handle = Value.Handle
    End Operator

    Constructor Cursor
        Handle = LoadCursor(NULL,IDC_ARROW)
        If Changed Then Changed(This)
    End Constructor

    Constructor Cursor(FHandle As HCursor)
        Handle = FHandle
        If Changed Then Changed(This)
    End Constructor

    Destructor Cursor
        If Handle Then DeleteObject Handle 
    End Destructor
End namespace
