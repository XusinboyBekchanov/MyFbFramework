#Include Once "Graphics.bi"
#Include Once "Component.bi"
#Include Once "WStringList.bi"

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
    Enum DrawingStyle
         dsFocus       = ILD_FOCUS
         dsNormal      = ILD_NORMAL
         dsSelected    = ILD_SELECTED
         dsTransparent = ILD_TRANSPARENT
         dsBlend       = ILD_BLEND
         dsBlend25     = ILD_BLEND25
         dsBlend50     = ILD_BLEND50
    End Enum

    Enum ImageType
         itImage = 0
         itMask  = ILD_MASK
    End Enum

    Type ImageList Extends Component
        Private:
            FParentWindow As HWND
            FWidth        As Integer
            FHeight       As Integer
            FBKColor      As Integer
            FCount        As Integer
            FKeys            As WStringList
            Declare Sub Create
            Declare Sub NotifyWindow
        Public:
            Handle        As HIMAGELIST
            AllocBy       As Integer
            ImageType     As ImageType
            DrawingStyle  As DrawingStyle
            Declare Property ParentWindow As HWND
            Declare Property ParentWindow(Value As HWND)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property BKColor As Integer
            Declare Property BKColor(Value As Integer)
            Declare Property Count As Integer
            Declare Sub AddBitmap(Bitmap As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
            Declare Sub AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
            Declare Sub AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
            Declare Sub AddMasked(ByRef Bitmap As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
            Declare Sub AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
            Declare Sub Remove(Index As Integer)
            Declare Sub Remove(ByRef Key As WString)
            Declare Function GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
            Declare Function GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
            Declare Function GetIcon(Index As Integer) As My.Sys.Drawing.Icon
            Declare Function GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
            Declare Function GetBitmap(ByRef Key As WString) ByRef As My.Sys.Drawing.BitmapType
            Declare Function GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
            Declare Function GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
            Declare Function GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
            Declare Function IndexOf(ByRef Key As WString) As Integer
            Declare Sub DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
            Declare Sub Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnChange As Sub(BYREF Sender As ImageList)
    End Type

    Property ImageList.ParentWindow As HWND
        Return FParentWindow
    End Property

    Property ImageList.ParentWindow(Value As HWND)
        FParentWindow = Value
        NotifyWindow
    End Property

    Property ImageList.Width As Integer
        Return FWidth
    End Property

    Property ImageList.Width(Value As Integer)
        FWidth = Value
        ImageList_SetIconSize(Handle,FWidth,FHeight)
        NotifyWindow
    End Property

    Property ImageList.Height As Integer
        Return FHeight
    End Property

    Property ImageList.Height(Value As Integer)
        FHeight = Value
        ImageList_SetIconSize(Handle,FWidth,FHeight)
        NotifyWindow
    End Property

    Property ImageList.BKColor As Integer
        FBKColor = ImageList_GetBKColor(Handle)
        Return FBKColor
    End Property

    Property ImageList.BKColor(Value As Integer)
        FBKColor = Value
        ImageList_SetBKColor(Handle,FBKColor)
        NotifyWindow
    End Property

    Property ImageList.Count As Integer
        FCount = ImageList_GetImageCount(Handle)
        Return FCount
    End Property

    Function ImageList.IndexOf(ByRef Key As WString) As Integer
        Return FKeys.IndexOf(Key)
    End Function

    Sub ImageList.NotifyWindow
        If ParentWindow Then
            If ParentWindow Then RedrawWindow ParentWindow,0,0,RDW_ERASE OR RDW_INVALIDATE
        End If
    End Sub

    Sub ImageList.Create
        If Handle Then ImageList_Destroy Handle
        Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLOR32,AllocBy,AllocBy)
    End Sub

    Sub ImageList.AddBitmap(Bmp As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
        FKeys.Add(Key)
        ImageList_Add(Handle, Bmp.Handle, Mask.Handle)
    End Sub

    Sub ImageList.AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
        FKeys.Add(Key)
        ImageList_AddIcon(Handle,Icon.Handle)
    End Sub

    Sub ImageList.AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
        FKeys.Add(Key)
        ImageList_AddIcon(Handle,Cursor.Handle)
    End Sub

    Sub ImageList.AddMasked(ByRef Bmp As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
        FKeys.Add(Key)
        ImageList_AddMasked(Handle, Bmp.Handle,MaskColor)
        NotifyWindow
    End Sub

    Sub ImageList.AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
        Dim As My.Sys.Drawing.BitmapType Bitm
        Bitm.LoadFromResourceName(Bmp, ModuleHandle)
        If Bitm.Handle Then
            FKeys.Add(Key)
            ImageList_AddMasked(Handle, Bitm.Handle, MaskColor)
            NotifyWindow
        End If
    End Sub

    Sub ImageList.Remove(Index As Integer)
        ImageList_Remove(Handle,Index)
    End Sub

    Sub ImageList.Remove(ByRef Key As WString)
        Remove(IndexOf(Key))
    End Sub

    Function ImageList.GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
        Dim As My.Sys.Drawing.BitmapType Ptr BMP
        Dim IMIF As IMAGEINFO
        BMP = cAllocate(SizeOF(My.Sys.Drawing.BitmapType))
        ImageList_GetImageInfo(Handle,Index,@IMIF)
        BMP->Handle = IMIF.hbmImage
        Return *BMP
    End Function

    Function ImageList.GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
        Dim IMIF As IMAGEINFO
        Dim As My.Sys.Drawing.BitmapType Ptr BMP
        BMP = cAllocate(SizeOF(My.Sys.Drawing.BitmapType))
        ImageList_GetImageInfo(Handle,Index,@IMIF)
        BMP->Handle = IMIF.hbmMask
        Return *BMP
    End Function

    Function ImageList.GetIcon(Index As Integer) As My.Sys.Drawing.Icon
        Dim As My.Sys.Drawing.Icon Ptr ICO
        ICO = cAllocate(SizeOF(My.Sys.Drawing.Icon))
        ICO->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
        Return *ICO
    End Function

    Function ImageList.GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
        Dim As My.Sys.Drawing.Cursor Ptr CUR
        CUR = cAllocate(SizeOF(My.Sys.Drawing.Cursor))
        CUR->Handle = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
        Return *CUR
    End Function

    Function ImageList.GetBitmap(ByRef Key As WString) ByRef As My.Sys.Drawing.BitmapType
        Return GetBitmap(IndexOf(Key))
    End Function

    Function ImageList.GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
        Return GetMask(IndexOf(Key))
    End Function

    Function ImageList.GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
        Return GetIcon(IndexOf(Key))
    End Function

    Function ImageList.GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
        Return GetCursor(IndexOf(Key))
    End Function

    Sub ImageList.DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
        ImageList_DrawEx(Handle,Index,DestDC,X,Y,iWidth,iHeight,FG,BK,DrawingStyle OR ImageType) 
    End Sub

    Sub ImageList.Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
         ImageList_Draw(Handle,Index,DestDC,X,Y,DrawingStyle OR ImageType)
    End Sub

    Sub ImageList.Clear
        Dim As Integer i
        For i = 0 To Count -1
            ImageList_Remove(Handle,i)
        Next i
    End Sub

    Operator ImageList.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ImageList
        AllocBy = 4
        FWidth  = 16
        FHeight = 16
        Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLORDDB,AllocBy,AllocBy)
    End Constructor

    Destructor ImageList
        If Handle Then ImageList_Destroy Handle
    End Destructor
End namespace
