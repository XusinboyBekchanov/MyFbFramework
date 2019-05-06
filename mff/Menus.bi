'###############################################################################
'#  Menus.bi                                                                   #
'#  TMenuItem, TMainMenu, TPopupMenu                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Menus.bi                                                                  #
'#   TMenuItem, TMainMenu, TPopupMenu                                          #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Component.bi"
#Include Once "ImageList.bi"
#IfNDef __USE_GTK__
	#Include Once "win/uxtheme.bi"
#EndIf

#IfDef __USE_GTK__
	Dim Shared As GdkPixbuf Ptr EmptyPixbuf
	EmptyPixbuf = gdk_pixbuf_new (GDK_COLORSPACE_RGB, True, 8, 16, 16)
	gdk_pixbuf_fill(EmptyPixbuf, 0)
#Else
	type BP_PAINTPARAMS
        cbSize as DWORD
        dwFlags as DWORD
        prcExclude as const RECT ptr
        pBlendFunction as const BLENDFUNCTION ptr
    end type
#EndIf

Using My.Sys.ComponentModel

namespace My.Sys.Forms
type PMenu      as Menu ptr
type PMainMenu  as MainMenu ptr
type PPopupMenu as PopupMenu ptr
type PMenuItem  as MenuItem ptr

    #define QMenuItem(__Ptr__)  *cast(PMenuItem,__Ptr__)
    #define QMenu(__Ptr__)      *cast(PMenu,__Ptr__)
    #define QPopupMenu(__Ptr__) *cast(PPopupMenu,__Ptr__)
    #DEFINE QMainMenu(__Ptr__)     *Cast(PMainMenu,__Ptr__)

    const MIM_BACKGROUND      = &H2
    const MIM_APPLYTOSUBMENUS = &H80000000
    const MIM_MENUDATA        = &H00000008

    Type MenuItem Extends My.Sys.Object
        Private:
			#IfNDef __USE_GTK__
				FInfo		As MENUITEMINFO
			#EndIf
            FCount			As Integer
            FItems			As PMenuItem ptr
            FCaption		As WString Ptr
            FText			As WString Ptr
            FAccelerator	As WString Ptr
            FChecked		As boolean
            FRadioItem		As boolean
            FParent			As PMenuItem
            FEnabled		As boolean
            FVisible		As boolean
            FCommand		As integer
            FMenuIndex		As integer
            FImage			As My.Sys.Drawing.BitmapType
            FImageIndex		As Integer
            FImageKey		As WString Ptr
            FOwnerDraw		As integer
        Protected:
            #IfNDef __USE_GTK__
				FHandle		As HMENU
				'FMenu		As HMENU
			#ENdIf
            FName			As WString Ptr
            FOwner			As PMenu
        Public:
            Tag As Any Ptr
            SubMenu As PMenu
            #IfNDef __USE_GTK__
				'declare property Menu as HMENU
				'declare property Menu(value as HMENU)
				declare property Handle as HMENU
				declare property Handle(value as HMENU)
				declare sub SetInfo(byref value as MENUITEMINFO)
				declare sub SetItemInfo(byref value as MENUITEMINFO)
			#Else
				accelerator_key As guint
				accelerator_mods As GdkModifierType
				Box				As GtkWidget Ptr
				Icon			As GtkWidget Ptr
				Label			As GtkWidget Ptr
				Widget 			As GtkWidget Ptr
				Declare Static Sub MenuItemActivate(menuitem As GtkMenuItem Ptr, user_data As Any Ptr)
            #EndIf
            declare property Owner as PMenu
            declare property Owner(value as PMenu)
            declare property Name ByRef As WString
            declare property Name(ByRef value As WString)
            declare property Parent as PMenuItem
            declare property Parent(value as PMenuItem)
            declare property Command as integer
            declare property Command(value as integer)
            declare property MenuIndex as integer
            declare property MenuIndex(value as integer)
            declare property Image as My.Sys.Drawing.BitmapType
            declare property Image(value As My.Sys.Drawing.BitmapType)
            declare property ImageIndex as Integer
            declare property ImageIndex(value As Integer)
            declare property ImageKey ByRef As WString
            declare property ImageKey(ByRef value As WString)
            declare property Caption ByRef As WString
            declare property Caption(ByRef value As WString)
            declare property Checked as boolean
            declare property Checked(value as boolean)
            declare property RadioItem as boolean
            declare property RadioItem(value as boolean)
            declare property Enabled as boolean
            declare property Enabled(value as boolean)
            declare property Visible as boolean
            declare property Visible(value As boolean)
            declare property Count as integer
            declare property Count(value as integer)
            declare property Item(index as integer) as PMenuItem
            declare property Item(index as integer, value as PMenuItem)
            declare sub Click
            Declare Virtual Function ToString ByRef As WString
            declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
            declare sub Add(ByRef value as PMenuItem, Index As Integer = -1)
            declare sub Add(value() As PMenuItem)
            declare sub AddRange Cdecl(CountArgs As Integer, ...)
            declare sub Remove(value as PMenuItem)
            declare sub Insert(index as integer, value as PMenuItem)
            declare sub Clear
            declare function IndexOf(value as PMenuItem) as integer
            declare function Find(value  as integer) as PMenuItem
            declare function Find(ByRef value As WString) As PMenuItem
			declare operator cast as any ptr
            declare constructor(ByRef Label As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = Null)
            declare destructor
            OnClick as NotifyEvent
    End Type

    Type Menu Extends Component
        Private:
            FCount   as integer
            FItems   as PMenuItem ptr
        Protected:
			#IfNDef __USE_GTK__
				FInfo    as MENUINFO
				FHandle  as HMENU
            #EndIf
            FStyle   as integer
            FColor   as integer
            FMenuItems     As List
			FParentWindow as Component Ptr
            FIncSubItems  as integer
            Declare Sub GetMenuItems
            declare sub ProcessMessage(byref mess as Message)
        Public:
            ImagesList       As ImageList Ptr
			declare property ParentWindow as Component Ptr
			declare property ParentWindow(value as Component Ptr)
            #IfNDef __USE_GTK__
				declare property Handle as HMENU
				declare property Handle(value as HMENU)
            #EndIf
            declare property Style as integer
            declare property Style(value as integer)
            declare property ColorizeEntire as integer
            declare property ColorizeEntire(value as integer)
            declare property Color as integer
            declare property Color(value as integer)
            declare property Count as integer
            declare property Count(value as integer)
            declare property Item(index as integer) as PMenuItem
            declare property Item(index as integer, value as PMenuItem)
            declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare sub Add(value as PMenuItem)
            declare sub Add(value() As PMenuItem)
            declare sub AddRange Cdecl(CountArgs As Integer, ...)
            declare sub Remove(value as PMenuItem)
            declare sub Insert(index as integer, value as PMenuItem)
            declare sub Clear
            declare function IndexOf(value as PMenuItem) as integer
            declare function Find(value  as integer) as PMenuItem
            declare function Find(ByRef value As WString) As PMenuItem
            declare operator cast as any ptr
            declare constructor
            declare destructor
            OnActivate as NotifyEvent
    End Type

    Type MainMenu Extends Menu
        Private:
        Protected:
			Declare Function EnumMenuItems(ByRef Item As MenuItem) As Boolean
        Public:
			declare sub ProcessMessages(byref message as Message)
			declare property ParentWindow(value as Component Ptr)
            declare operator cast as any ptr
            declare constructor
            declare destructor
    End Type

    Type PopupMenu Extends Menu
        Private:
        Protected:
        Public:
			declare property ParentWindow(value as Component Ptr)
            declare sub Popup(x as integer, y as integer, msg As Message Ptr = 0)
            declare sub ProcessMessages(byref message as Message)
            declare operator cast as any ptr
            declare constructor
            declare destructor
            OnPopup As NotifyEvent
            OnDropDown As NotifyEvent
    End Type

    /' Global '/
    Sub AllocateCommand(value as PMenuItem)
        Static as integer uniqueId
        If uniqueId = 0 Then uniqueId = 999
        If value Then
            if(value->Command <= 0) then
                value->Command = uniqueId + 1
                uniqueId = value->Command
            End If   
        End If   
    End Sub
    
    Function MenuItem.ToString ByRef As WString
        Return This.Name
    End Function

    Sub TraverseItems(Item As MenuItem)
		#IfNDef __USE_GTK__ 
			Dim As MenuItemInfo mii
			mii.cbsize = SizeOf(mii)
			mii.fMask  = MIIM_TYPE
			For i As Integer = 0 To Item.Count-1
				GetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,true,@mii)
				mii.fType = iif((mii.fType and MFT_SEPARATOR),MFT_SEPARATOR,MFT_OWNERDRAW)
				SetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,true,@mii)
				TraverseItems(*Item.Item(i))
			Next i
		#EndIf
    End Sub

    /' MenuItem '/
    #IfNDef __USE_GTK__
		Sub MenuItem.SetInfo(ByRef value As MENUITEMINFO)
			If *FCaption = "" Then
				*FCaption = Chr(0)
			End If
			value.cbSize      = SizeOf(value)
			value.fMask       = iif(Handle,MIIM_SUBMENU,MIIM_ID) or MIIM_FTYPE Or MIIM_BITMAP Or MIIM_STRING Or MIIM_DATA or MIIM_STATE
			value.hSubMenu    = Handle
			value.fType       = iif(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
			value.fState      = iif(FEnabled, MFS_ENABLED, MFS_DISABLED) or iif(FChecked, MFS_CHECKED, MFS_UNCHECKED)
			value.wID         = iif(Handle, -1, This.Command)
			If FImageIndex <> - 1 AndAlso owner AndAlso owner->imageslist Then FImage = owner->imageslist->GetIcon(FImageIndex).ToBitmap
			Value.hbmpItem     = FImage.Handle 'IIf(FImageIndex <> - 1, HBMMENU_CALLBACK, FImage.Handle)
			value.dwItemData  = Cast(dword_Ptr, Cast(Any Ptr, @this))
			value.dwTypeData  = FCaption
			value.cch         = Len(*FCaption)
		end sub

		Sub MenuItem.SetItemInfo(ByRef value As MENUITEMINFO)
			If Parent AndAlso Parent->Handle Then
				SetMenuItemInfo(Parent->Handle, FMenuIndex, True, @value)
			ElseIf This.Owner AndAlso This.Owner->Handle Then
				SetMenuItemInfo(This.Owner->Handle, FMenuIndex, True, @value)
			End If
		End Sub
	#EndIf

    property MenuItem.MenuIndex as integer
        return FMenuIndex
    end property

    property MenuItem.MenuIndex(value as integer)
        FMenuIndex = value
    end property

    property MenuItem.Name ByRef as WString
        return WGet(FName)
    end property

    property MenuItem.Name(ByRef value as WString)
        WLet FName, value
    end property

'    declare function BeginPanningFeedback(byval hwnd as HWND) as WINBOOL
'    declare function UpdatePanningFeedback(byval hwnd as HWND, byval lTotalOverpanOffsetX as LONG, byval lTotalOverpanOffsetY as LONG, byval fInInertia as WINBOOL) as WINBOOL
'    declare function EndPanningFeedback(byval hwnd as HWND, byval fAnimateBack a-s WINBOOL) as WINBOOL
'
'    const GBF_DIRECT = &h00000001
'    const GBF_COPY = &h00000002
'    const GBF_VALIDBITS = GBF_DIRECT or GBF_COPY
'
'    declare function GetThemeBitmap(byval hTheme as HTHEME, byval iPartId as long, byval iStateId as long, byval iPropId as long, byval dwFlags as ULONG, byval phBitmap as HBITMAP ptr) as HRESULT
'    declare function GetThemeStream(byval hTheme as HTHEME, byval iPartId as long, byval iStateId as long, byval iPropId as long, byval ppvStream as any ptr ptr, byval pcbStream as DWORD ptr, byval hInst as HINSTANCE) as HRESULT
'    declare function GetThemeTransitionDuration(byval hTheme as HTHEME, byval iPartId as long, byval iStateIdFrom as long, byval iStateIdTo as long, byval iPropId as long, byval pdwDuration as DWORD ptr) as HRESULT
'
'    type HPAINTBUFFER__
'        unused as long
'    end type
'
'    type HPAINTBUFFER as HPAINTBUFFER__ ptr
'
'    type _BP_BUFFERFORMAT as long
'    enum
'        BPBF_COMPATIBLEBITMAP
'        BPBF_DIB
'        BPBF_TOPDOWNDIB
'        BPBF_TOPDOWNMONODIB
'    end enum
'
'    type BP_BUFFERFORMAT as _BP_BUFFERFORMAT
'    const BPPF_ERASE = &h00000001
'    const BPPF_NOCLIP = &h00000002
'    const BPPF_NONCLIENT = &h00000004
'
'    type _BP_PAINTPARAMS
'        cbSize as DWORD
'        dwFlags as DWORD
'        prcExclude as const RECT ptr
'        pBlendFunction as const BLENDFUNCTION ptr
'    end type
'
'    type BP_PAINTPARAMS as _BP_PAINTPARAMS
'    type PBP_PAINTPARAMS as _BP_PAINTPARAMS ptr
'    declare function BeginBufferedPaint(byval hdcTarget as HDC, byval prcTarget as const RECT ptr, byval dwFormat as BP_BUFFERFORMAT, byval pPaintParams as BP_PAINTPARAMS ptr, byval phdc as HDC ptr) as HPAINTBUFFER
'    declare function EndBufferedPaint(byval hBufferedPaint as HPAINTBUFFER, byval fUpdateTarget as WINBOOL) as HRESULT
'    declare function GetBufferedPaintTargetRect(byval hBufferedPaint as HPAINTBUFFER, byval prc as RECT ptr) as HRESULT
'    declare function GetBufferedPaintTargetDC(byval hBufferedPaint as HPAINTBUFFER) as HDC
'    declare function GetBufferedPaintDC(byval hBufferedPaint as HPAINTBUFFER) as HDC
'    declare function GetBufferedPaintBits(byval hBufferedPaint as HPAINTBUFFER, byval ppbBuffer as RGBQUAD ptr ptr, byval pcxRow as long ptr) as HRESULT
'    declare function BufferedPaintClear(byval hBufferedPaint as HPAINTBUFFER, byval prc as const RECT ptr) as HRESULT
'    declare function BufferedPaintSetAlpha(byval hBufferedPaint as HPAINTBUFFER, byval prc as const RECT ptr, byval alpha as UBYTE) as HRESULT
'    declare function BufferedPaintInit() as HRESULT
'    declare function BufferedPaintUnInit() as HRESULT
'
'    type HANIMATIONBUFFER__
'        unused as long
'    end type
'
'    type HANIMATIONBUFFER as HANIMATIONBUFFER__ ptr
'
'    type _BP_ANIMATIONSTYLE as long
'    enum
'        BPAS_NONE
'        BPAS_LINEAR
'        BPAS_CUBIC
'        BPAS_SINE
'    end enum
'
'    type BP_ANIMATIONSTYLE as _BP_ANIMATIONSTYLE
'
'    type _BP_ANIMATIONPARAMS
'        cbSize as DWORD
'        dwFlags as DWORD
'        style as BP_ANIMATIONSTYLE
'        dwDuration as DWORD
'    end type
'
'    type BP_ANIMATIONPARAMS as _BP_ANIMATIONPARAMS
'    type PBP_ANIMATIONPARAMS as _BP_ANIMATIONPARAMS ptr
'    declare function BeginBufferedAnimation(byval hwnd as HWND, byval hdcTarget as HDC, byval rcTarget as const RECT ptr, byval dwFormat as BP_BUFFERFORMAT, byval pPaintParams as BP_PAINTPARAMS ptr, byval pAnimationParams as BP_ANIMATIONPARAMS ptr, byval phdcFrom as HDC ptr, byval phdcTo as HDC ptr) as HANIMATIONBUFFER
'    declare function EndBufferedAnimation(byval hbpAnimation as HANIMATIONBUFFER, byval fUpdateTarget as WINBOOL) as HRESULT
'    declare function BufferedPaintRenderAnimation(byval hwnd as HWND, byval hdcTarget as HDC) as WINBOOL
'    declare function BufferedPaintStopAllAnimations(byval hwnd as HWND) as HRESULT
'    declare function IsCompositionActive() as WINBOOL
'
'    type WINDOWTHEMEATTRIBUTETYPE as long
'    enum
'        WTA_NONCLIENT = 1
'    end enum
'
'    type WTA_OPTIONS
'        dwFlags as DWORD
'        dwMask as DWORD
'    end type
'
'    type PWTA_OPTIONS as WTA_OPTIONS ptr
'    const WTNCA_NODRAWCAPTION = &h00000001
'    const WTNCA_NODRAWICON = &h00000002
'    const WTNCA_NOSYSMENU = &h00000004
'    const WTNCA_NOMIRRORHELP = &h00000008
'    const WTNCA_VALIDBITS = ((WTNCA_NODRAWCAPTION or WTNCA_NODRAWICON) or WTNCA_NOSYSMENU) or WTNCA_NOMIRRORHELP
'    declare function SetWindowThemeAttribute(byval hwnd as HWND, byval eAttribute as WINDOWTHEMEATTRIBUTETYPE, byval pvAttribute as PVOID, byval cbAttribute as DWORD) as HRESULT
'
'    private function SetWindowThemeNonClientAttributes cdecl(byval hwnd as HWND, byval dwMask as DWORD, byval dwAttributes as DWORD) as HRESULT
'        dim wta as WTA_OPTIONS = (dwAttributes, dwMask)
'        return SetWindowThemeAttribute(hwnd, WTA_NONCLIENT, @wta, sizeof(WTA_OPTIONS))
'    end function
'    
'    Sub InitBitmapInfo(pbmi As BITMAPINFO Ptr, cbInfo As ULONG, cx As LONG, cy As LONG, bpp As WORD)
'            ZeroMemory(pbmi, cbInfo)
'            pbmi->bmiHeader.biSize = sizeof(BITMAPINFOHEADER)
'            pbmi->bmiHeader.biPlanes = 1
'            pbmi->bmiHeader.biCompression = BI_RGB
'
'            pbmi->bmiHeader.biWidth = cx
'            pbmi->bmiHeader.biHeight = cy
'            pbmi->bmiHeader.biBitCount = bpp
'    End Sub
'
'    Function Create32BitHBITMAP(hdc1 As HDC, psize As SIZE Ptr, ppvBits as any ptr ptr, phBmp As HBITMAP Ptr) As HRESULT
'            *phBmp = NULL
'
'            Dim As BITMAPINFO bmi
'            InitBitmapInfo(@bmi, sizeof(bmi), psize->cx, psize->cy, 32)
'
'            Dim As HDC hdcUsed = IIF(hdc1, hdc1, GetDC(NULL))
'            if (hdcUsed) Then
'                *phBmp = CreateDIBSection(hdcUsed, @bmi, DIB_RGB_COLORS, ppvBits, NULL, 0)
'                if (Not hdc1 = hdcUsed) Then
'                    ReleaseDC(NULL, hdcUsed)
'                End IF
'            End If
'            return IIF(NULL = *phBmp, E_OUTOFMEMORY, S_OK)
'    End Function
'    
'    type ARGB as DWORD
'
'    Function ConvertToPARGB32(hdc As HDC, pargb As ARGB Ptr, hbmp As HBITMAP, sizImage As SIZE, cxRow As Integer) As HRESULT
'        Dim As BITMAPINFO bmi
'        InitBitmapInfo(@bmi, sizeof(bmi), sizImage.cx, sizImage.cy, 32)
'    
'        Dim As HRESULT hr = E_OUTOFMEMORY
'        Dim As HANDLE hHeap = GetProcessHeap()
'        Var pvBits = HeapAlloc(hHeap, 0, bmi.bmiHeader.biWidth * 4 * bmi.bmiHeader.biHeight)
'        if (pvBits) Then
'            hr = E_UNEXPECTED
'            if (GetDIBits(hdc, hbmp, 0, bmi.bmiHeader.biHeight, pvBits, @bmi, DIB_RGB_COLORS) = bmi.bmiHeader.biHeight) Then
'                Dim As ULONG cxDelta = cxRow - bmi.bmiHeader.biWidth
'                Dim As ARGB Ptr pargbMask = Cast(ARGB Ptr, pvBits)
'    
'                for y As ULong = bmi.bmiHeader.biHeight To 1 Step -1
'                    for x As ULong = bmi.bmiHeader.biWidth To 1 Step -1
'                    *pargbMask += 1
'                    *pargb += 1
'                        if *pargbMask Then
'                            ' transparent pixel
'                            *pargb = 0
'                        else
'                            ' opaque pixel
'                            *pargb Or= -16777216
'                        End If
'                    Next
'    
'                    pargb += cxDelta
'                Next
'    
'                hr = S_OK
'            End If
'    
'            HeapFree(hHeap, 0, pvBits)
'        End If
'    
'        return hr
'    End Function
'    
'    Function HasAlpha(pargb As ARGB Ptr, sizImage As SIZE, cxRow As Integer) As Boolean
'        Dim As ULONG cxDelta = cxRow - sizImage.cx
'        for y As ULONG = sizImage.cy To 1 Step -1
'            for x As ULONG = sizImage.cx To 1 Step -1
'            *pargb += 1
'                if (*pargb And -16777216) Then
'                    return true
'                End If
'            Next
'    
'            pargb += cxDelta
'        Next
'    
'        return false
'    End Function
'    
'    Function ConvertBufferToPARGB32(hPaintBuffer As HPAINTBUFFER, hdc As HDC, hicon As HICON, sizIcon As SIZE) As HRESULT
'        Dim As RGBQUAD Ptr prgbQuad
'        Dim As integer cxRow
'        Dim As HRESULT hr = GetBufferedPaintBits(hPaintBuffer, @prgbQuad, @cxRow)
'        if (SUCCEEDED(hr)) Then
'            Dim As ARGB Ptr pargb = Cast(ARGB Ptr, prgbQuad)
'            if (Not HasAlpha(pargb, sizIcon, cxRow)) Then
'                Dim As ICONINFO info
'                if (GetIconInfo(hicon, @info)) Then
'                    if (info.hbmMask) Then
'                        hr = ConvertToPARGB32(hdc, pargb, info.hbmMask, sizIcon, cxRow)
'                    End If
'    
'                    DeleteObject(info.hbmColor)
'                    DeleteObject(info.hbmMask)
'                End If
'            End If
'        End If
'    
'        return hr
'    End Function
'
'    Function MyIcon As Boolean
'        Dim As HRESULT hr = E_OUTOFMEMORY
'        Dim As HBITMAP hbmp = NULL
'        Dim As HICON hicon
'            Dim As SIZE sizIcon
'            sizIcon.cx = GetSystemMetrics(SM_CXSMICON)
'            sizIcon.cy = GetSystemMetrics(SM_CYSMICON)
'
'            Dim As RECT rcIcon
'            SetRect(@rcIcon, 0, 0, sizIcon.cx, sizIcon.cy)
'
'            Dim As HDC hdcDest = CreateCompatibleDC(NULL)
'        if (hdcDest) Then
'            hr = Create32BitHBITMAP(hdcDest, @sizIcon, NULL, @hbmp)
'            if (SUCCEEDED(hr)) Then
'                    hr = E_FAIL
'
'                    Dim As HBITMAP hbmpOld = Cast(HBITMAP, SelectObject(hdcDest, hbmp))
'                    if (hbmpOld) Then
'                            Dim As BLENDFUNCTION bfAlpha
'                    bfAlpha.BlendOp = AC_SRC_OVER
'                    bfAlpha.SourceConstantAlpha = 255
'                    bfAlpha.AlphaFormat = AC_SRC_ALPHA
'                            Dim paintParams As BP_PAINTPARAMS
'                        paintParams.cbSize = sizeof(paintParams)
'                        paintParams.dwFlags = BPPF_ERASE
'                        paintParams.pBlendFunction = @bfAlpha
'
'                        Dim As HDC hdcBuffer
'                        Dim As HPAINTBUFFER hPaintBuffer = BeginBufferedPaint(hdcDest, @rcIcon, BPBF_DIB, @paintParams, @hdcBuffer)
'                        if (hPaintBuffer) Then
'                            if (DrawIconEx(hdcBuffer, 0, 0, hicon, sizIcon.cx, sizIcon.cy, 0, NULL, DI_NORMAL)) Then
'                                hr = ConvertBufferToPARGB32(hPaintBuffer, hdcDest, hicon, sizIcon)
'                              End If
'
'                            EndBufferedPaint(hPaintBuffer, TRUE)
'                            End If
'
'                            SelectObject(hdcDest, hbmpOld)
'                    End If
'                End If
'
'                    DeleteDC(hdcDest)
'                End if
'
'        if (SUCCEEDED(hr)) Then
'                'hr = AddBitmapToMenuItem(hmenu, iMenuItem, fByPosition, hbmp)
'        End If
'
'            if (FAILED(hr)) Then
'                DeleteObject(hbmp)
'                hbmp = NULL
'            End If
'
'            DestroyIcon(hicon)
'
'            'if (phbmp) Then *phbmp = hbmp
'
'            return hr
'    End Function

    property MenuItem.Image As My.Sys.Drawing.BitmapType
        return FImage
    end property
        
    property MenuItem.Image(value As My.Sys.Drawing.BitmapType)
        FImage = value
        #IfNDef __USE_GTK__
			DIM mii AS MENUITEMINFOW
			mii.cbSize = SIZEOF(mii)
			mii.fMask = MIIM_BITMAP
			mii.hbmpItem = value.Handle
				   
			SetItemInfo mii
		#EndIf
    end property

    property MenuItem.ImageIndex As Integer
        return FImageIndex
    end property

    property MenuItem.ImageIndex(value As Integer)
        FImageIndex = value
        If value <> -1 AndAlso owner AndAlso owner->imageslist Then
			#IfNDef __USE_GTK__
				FImage = owner->imageslist->GetIcon(value).ToBitmap
		
				DIM mii AS MENUITEMINFOW
				mii.cbSize = SIZEOF(mii)
				mii.fMask = MIIM_BITMAP
				mii.hbmpItem = FImage 'HBMMENU_CALLBACK
				   
				SetItemInfo mii
           #EndIf
        End if
    end property
    
	#IfDef __USE_GTK__
		Sub MenuItem.MenuItemActivate(m_item As GtkMenuItem Ptr, user_data As Any Ptr) '...'
			Dim As MenuItem Ptr Ctrl = user_data
			If Ctrl Then
				If Ctrl->OnClick Then Ctrl->OnClick(*Ctrl)
			End If
		End Sub
	#EndIf

    property MenuItem.ImageKey ByRef As WString
        return WGet(FImageKey)
    end property

    property MenuItem.ImageKey(ByRef value As WString)
        WLet FImageKey, value
        #IfDef __USE_GTK__
	        If Icon Then
				gtk_image_set_from_icon_name(GTK_IMAGE(icon), Value, GTK_ICON_SIZE_MENU)
			Else
				
			End If
		#EndIf
        'gtk_container_add (GTK_CONTAINER (box), icon)
        'gtk_container_add (GTK_CONTAINER (widget), box)
		'gtk_widget_show_all (widget)
        If value <> "" AndAlso owner AndAlso owner->imageslist Then
            ImageIndex = owner->imageslist->IndexOf(value)
        End if
    end property

    property MenuItem.Command as integer
        return FCommand
    end property

    property MenuItem.Command(value as integer)
        FCommand = value
    end property

	#IfNDef __USE_GTK__
		property MenuItem.Handle as HMENU
			return FHandle
		end property

		property MenuItem.Handle(value as HMENU)
			FHandle = value
		end property
	#EndIf

    property MenuItem.Owner as PMenu
        return FOwner
    end property

    property MenuItem.Owner(value as PMenu)
        FOwner = value
    end property

'	#IfNDef __USE_GTK__
'		property MenuItem.Menu as HMENU
'			return FMenu
'		end property
'
'		property MenuItem.Menu(value as HMENU)
'			FMenu = value
'		end property
'	#EndIf

    property MenuItem.Parent as PMenuItem
        return FParent
    end property

    property MenuItem.Parent(value as PMenuItem)
        dim as PMenuItem SaveParent = FParent
        FParent = value
        if SaveParent then SaveParent->Remove(this)
        if FParent then FParent->Add(this)
    end property

    property MenuItem.Caption ByRef As WString
        return WGet(FCaption)
    end property

    property MenuItem.Caption(ByRef value As WString)
        FCaption = ReAllocate(FCaption, (Len(value) + 1) * SizeOf(WString))
        *FCaption = value
        #IfDef __USE_GTK__
			If Value <> "-" Then
				Dim p As Integer = InStr(value, !"\t")
				If p > 0 Then
					Dim As String HotKey = Mid(value, p + 1)
					WLet FText, Replace(Left(value, p), "&", "_")
					WLet FAccelerator, HotKey
					gtk_label_set_text_with_mnemonic(gtk_label(label), ToUTF8(*FText))
					If HotKey <> "" Then
						HotKey = Replace(HotKey, "Ctrl+", "<Ctrl>")
						HotKey = Replace(HotKey, "Alt+", "<Alt>")
						HotKey = Replace(HotKey, "Shift+", "<Shift>")
						gtk_accelerator_parse(ToUTF8(HotKey), @accelerator_key, @accelerator_mods)
						#IfDef __USE_GTK3__
							gtk_accel_label_set_accel(GTK_ACCEL_LABEL (label), accelerator_key, accelerator_mods) 'accelerator_mods)
						#Else
							If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Accelerator Then
								gtk_widget_add_accelerator (label, "activate", Owner->ParentWindow->Accelerator, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
							End If
						#EndIf
						'If Owner Then
						'	Dim As Component Ptr Cpnt = Owner->GetTopLevel
						'	If Cpnt->AccelGroup <> 0 Then Cpnt->AccelGroup = gtk_accel_group_new()
						'	gtk_widget_add_accelerator (widget, "activate", Cpnt->AccelGroup, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
						'End If
					End If
				Else
					WLet FText, value
					gtk_label_set_text(gtk_label(label), ToUTF8(value))
				End If
			End If
        #Else
			FInfo.dwTypeData = FCaption
			FInfo.cch        = Len(*FCaption)
			if Parent then
				SetMenuItemInfo(Parent->Handle, MenuIndex, true, @FInfo)
			elseIf Owner AndAlso Owner->Handle Then
				SetMenuItemInfo(Owner->Handle, MenuIndex, true, @FInfo)
			end if
			If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
				DrawMenuBar(Owner->ParentWindow->Handle)
			End if
		#EndIf
    end property

    property MenuItem.Checked as boolean
        return FChecked
    end property

    property MenuItem.Checked(value as boolean)
        FChecked = value
        #IfNDef __USE_GTK__
			Dim As Integer FCheck(-1 to 1) =>{MF_CHECKED, MF_UNCHECKED, MF_CHECKED}
			If Parent Then
				If Handle Then
					CheckMenuItem(Parent->Handle,cint(Handle),MF_POPUP or FCheck(FChecked))
				Else
					CheckMenuItem(Parent->Handle,MenuIndex,MF_BYPOSITION or FCheck(FChecked))
				End If
			End If
		#EndIf
    End Property

    Property MenuItem.RadioItem As Boolean
        Return FRadioItem
    End Property

    property MenuItem.RadioItem(value as boolean)
        FRadioItem = value
        dim as integer First,Last
        if Parent then
           First = Parent->Item(0)->MenuIndex
           Last  = Parent->Item(Parent->Count-1)->MenuIndex
			#IFNDef __USE_GTK__
				CheckMenuRadioItem(Parent->Handle, First, Last, MenuIndex, MF_BYPOSITION)
			#EndIf
        end if
    end property

    property MenuItem.Enabled as boolean
        return FEnabled
    end property

    property MenuItem.Enabled(value as boolean)
        FEnabled = value
        #IfNDef __USE_GTK__
			dim as integer FEnable(0 to 1) => {MF_DISABLED Or MF_GRAYED, MF_ENABLED}
			if Parent then
				EnableMenuItem(Parent->Handle, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
			elseIf Owner AndAlso Owner->Handle Then
				EnableMenuItem(Owner->Handle, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
			end if
			If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
				DrawMenuBar(Owner->ParentWindow->Handle)
			End if
		#EndIf
    end property

    property MenuItem.Visible as boolean
        return FVisible
    end property

    property MenuItem.Visible(value as boolean)
        if fvisible = value then exit property
        FVisible = value
        #IfNDef __USE_GTK__
			if FVisible = false then
			   if Parent then
				  RemoveMenu(Parent->Handle, MenuIndex, MF_BYPOSITION)
			   elseIf Owner AndAlso Owner->Handle Then
				  RemoveMenu(Owner->Handle, MenuIndex, MF_BYPOSITION)
			   end if
			else
			   SetInfo(FInfo)
			   SetItemInfo(FInfo)
			end if
		#EndIf
    end property

    property MenuItem.Count as integer
        return FCount
    end property

    property MenuItem.Count(value as integer)
    end property

    property MenuItem.Item(index as integer) as PMenuItem
        if (index > -1) and (index  <FCount) then
            return FItems[index]
        end if
        return NULL
    end property

    property MenuItem.Item(index as integer,value as PMenuItem)
    end property

    sub MenuItem.Click
        if onClick then onClick(this)
    end sub
    
    sub MenuItem.Add(ByRef value as PMenuItem, ByVal Index As Integer = -1)
        if IndexOf(value) = -1 then
            FCount += 1
			FItems = reallocate(FItems, sizeof(PMenuItem)*FCount)
			If Index <> -1 Then
				For i As Integer = FCount - 1 To Index + 1 Step -1
					FItems[i] = FItems[i-1]
				Next i
			Else
				Index = FCount - 1
			End If
			value->MenuIndex = Index
			value->FParent    = @this
			value->Owner     = Owner
'			#IfNDef __USE_GTK__
'				value->Menu      = This.Menu
'			#EndIf
		   AllocateCommand(value)
		   FItems[Index]            = value
			#Ifdef __USE_GTK__
				If SubMenu = 0 Then
					SubMenu = New PopUpMenu
					gtk_menu_item_set_submenu(gtk_menu_item(widget), SubMenu->widget)
				End If
				If Index = -1 Then
					gtk_menu_shell_append(gtk_menu_shell(SubMenu->widget), value->widget)
        		Else
        			gtk_menu_shell_insert(gtk_menu_shell(SubMenu->widget), value->widget, Index)
				End If
				If Value->box Then
					gtk_container_add (GTK_CONTAINER (Value->box), Value->icon)
				EndIf
				If Value->label Then
					gtk_label_set_text_with_mnemonic(gtk_label(Value->label), ToUTF8(*Value->FText & "	"))
				End If
				gtk_widget_show_all(value->widget)
		   #Else
				if Handle = 0 then
					Handle = CreatePopupMenu
					   dim as menuinfo mif
					   mif.cbSize     = sizeof(mif)
					   mif.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
					   mif.fMask      = MIM_MENUDATA
					   .SetMenuInfo(Handle, @mif)
					   SetInfo(FInfo)
					   SetItemInfo(FInfo)
				end if
				value->SetInfo(FInfo)
				InsertMenuItem(Handle, Index, true, @FInfo)
			#EndIf
        end if
    end sub

    Function MenuItem.Add(ByRef sCaption As WString) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Add(Value)
        Return Value
    End Function
    
    Function MenuItem.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Value->FImage     = iImage
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value, Index)
        Return Value
    End Function
    
    Function MenuItem.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Value->FImageIndex = iImageIndex
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value, Index)
        Return Value
    End Function

    Function MenuItem.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null, Index As Integer = -1) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption, sImageKey)
        WLet Value->FImageKey, sImageKey
        If Owner AndAlso Owner->ImagesList Then Value->FImageIndex = Owner->ImagesList->IndexOf(sImageKey)
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value, Index)
        Return Value
    End Function

    sub MenuItem.Add(value() As PMenuItem)
        For i as integer = 0 to Ubound(value)
            Add(value(i))
        Next
    end sub

    #IfnDef __FB_64BIT__
    sub MenuItem.AddRange Cdecl(CountArgs As Integer, ...)
        Dim value As Any Ptr
        value = Va_first()
        For i as integer = 1 to CountArgs
            Add(Va_arg(value, PMenuItem))
            value = Va_next(value, Long)
        Next
    end sub
    #EndIf
    
    sub MenuItem.Insert(Index as Integer, value as PMenuItem)
        if IndexOf(value) = -1 then
           if (Index>-1) and (Index<FCount) then
              FCount += 1
              FItems = reallocate(FItems,sizeof(PMenuItem)*FCount)
              for i as integer = Index+1 to FCount-1
                 FItems[i] = FItems[i-1]
              next i
              FItems[Index]            = value
              FItems[Index]->MenuIndex = Index
              FItems[Index]->Parent    = @this
              FItems[Index]->Owner     = Owner
'				#IfNDef __USE_GTK__
'					FItems[Index]->Menu      = This.Menu
'				#EndIf
              AllocateCommand(value)
              if FCount > 0 then
                 #IfNDef __USE_GTK__
					 if Handle = 0 then
						Handle = CreatePopupMenu
						dim as menuinfo mif
						mif.cbSize     = sizeof(mif)
						mif.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
						mif.fMask      = MIM_MENUDATA
						.SetMenuInfo(Handle,@mif)
						SetInfo(FInfo)
						if Parent then
						   SetMenuItemInfo(Parent->Handle,MenuIndex,true,@FInfo)
						end if
					 end if
				#EndIf
             end if
             #IfNDef __USE_GTK__
				value->SetInfo(FInfo)
				InsertMenuItem(Handle,Index,true,@FInfo)
			#EndIf
             for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
             next i
          end if
       end if
    end sub

    sub MenuItem.Remove(value as PMenuItem)
        dim as integer Index,i
        dim as PMenuItem FItem
        Index = IndexOf(value)
        if Index <> -1  then
            for i = Index+1 to FCount-1
                FItem = FItems[i]
                FItems[i-1] = FItem
            next i
            FCount -= 1
            FItems  = reallocate(FItems,FCount*sizeof(PMenuItem))
            for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
            next i
            #IfDef __USE_GTK__
            	If widget Then
            		'gtk_container_remove(gtk_container(widget), value->widget)
            	End If
            #Else
	            If Handle Then
	            	RemoveMenu(Handle, Index, MF_BYPOSITION)
	        	End If
        	#EndIf
        end if
    end sub

    sub MenuItem.Clear
        for i as integer = Count-1 to 0 step -1
            FItems[i] = NULL
        next i
        FItems = callocate(0)
        FCount = 0
    end sub

    function MenuItem.IndexOf(value as PMenuItem) as integer
        dim as Integer i
        for i = 0 to FCount -1
            if FItems[i] = value then return i
        next i
        return -1
    end function

    function MenuItem.Find(value as integer) as PMenuItem
        dim as PMenuItem FItem
        for i as integer = 0 to FCount -1
            if Item(i)->Command = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Command = value then return FItem
        next i
        return NULL
    end function

	function MenuItem.Find(ByRef value as WString) as PMenuItem
        dim as PMenuItem FItem
        for i as integer = 0 to FCount -1
            if Item(i)->Name = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Name = value then return FItem
        next i
        return NULL
    end function

    operator MenuItem.cast as any ptr
        return @this
    end operator

	constructor MenuItem(ByRef wCaption As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = Null)
        FVisible    = True
        FEnabled    = True
        FChecked    = False
        #IfDef __USE_GTK__
			If wCaption = "-" Then
				widget = gtk_separator_menu_item_new()
			'ElseIf wImageKey = "" Then
			'	
			'	widget = gtk_menu_item_new_with_mnemonic(wCaption)
				label = gtk_bin_get_child (GTK_BIN (widget))
			'	g_signal_connect(widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
			Else
				#IfDef __USE_GTK3__
					box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#Else
					box = gtk_hbox_new(False, 1)
				#EndIf
				If wImageKey = "" Then
					icon = gtk_image_new_from_pixbuf(EmptyPixbuf)
				Else
					icon = gtk_image_new_from_icon_name(ToUTF8(wImageKey), GTK_ICON_SIZE_MENU)
					#IfnDef __USE_GTK3__
						gtk_misc_set_alignment (GTK_MISC (icon), 0.0, 0.0)
					#EndIf
				End If
				gtk_image_set_pixel_size(gtk_image(icon), 16)
				widget = gtk_menu_item_new()
				label = gtk_accel_label_new (ToUTF8(wCaption & "   "))
				gtk_accel_label_set_accel_widget (GTK_ACCEL_LABEL (label), widget)
				gtk_box_pack_end (GTK_BOX (box), label, TRUE, TRUE, 0)
				#IfDef __USE_GTK3__
					gtk_label_set_xalign (GTK_LABEL (label), 0.0)
				#Else
					gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.0)
				#EndIf
				'gtk_container_add (GTK_CONTAINER (box), label)
				gtk_container_add (GTK_CONTAINER (widget), box)
				g_signal_connect(widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
				'g_signal_connect(widget, "event", G_CALLBACK(@EventProc), @This)
				'g_signal_connect(widget, "event-after", G_CALLBACK(@EventAfterProc), @This)
			End If
        #Else
			FImage = 0
		#ENdIf
		Caption = wCaption
        FImageIndex = -1
        OnClick = eClick
        WLet FClassName, "MenuItem"
        WLet FImageKey, wImageKey
    end constructor
    
    destructor MenuItem
        if FParent then
            FParent->Remove(@this)
        end if
        if FItems then
            delete [] FItems
            FItems = callocate(0)
        end if
        If FCaption Then Deallocate FCaption
        WDeallocate FText
        WDeallocate FAccelerator
        #IfDef __USE_GTK__
        	If gtk_is_widget(widget) Then gtk_widget_destroy(Widget)
        #Else
			if FHandle then
				DestroyMenu(FHandle)
				FHandle = 0
			end if
        #EndIf
    end destructor

    /' Menu '/
    #IfNDef __USE_GTK__
		property Menu.Handle as HMENU
			return FHandle
		end property

		property Menu.Handle(value as HMENU)
			FHandle = value
		end property
	#EndIf
		property Menu.ParentWindow as Component Ptr
			return FParentWindow
		end property

		property Menu.ParentWindow(value as Component Ptr)
			FParentWindow = value
			If ImagesList Then ImagesList->ParentWindow = FParentWindow
		end property

    property Menu.Style as integer
        return FStyle
    end property

    property Menu.Style(value as integer)
        FStyle = value
        #IfNDef __USE_GTK__
			if Handle then
				if value then
					for i as integer = 0 to FCount-1
					   TraverseItems(*Item(i))
					next i
				/'else
				   for i as integer = 0 to FCount-1
					   TraverseItems(*Item(i))
					next i '/
				end if
				if FParentWindow AndAlso IsWindow(FParentWindow->Handle) then
				   SetMenu(FParentWindow->Handle,Handle)
				   DrawMenuBar(FParentWindow->Handle)
				end if
			end if
		#EndIf
    end property

    property Menu.Color as integer
		#IfNDef __USE_GTK__
			if handle then
				dim as menuinfo mif
				mif.cbSize = sizeof(mif)
				mif.fMask  = MIM_BACKGROUND
				if GetMenuInfo(Handle,@mif) then
					dim as LOGBRUSH lb
					GetObject(mif.hbrBack,sizeof(lb),@lb)
					FColor = lb.lbColor
					return FColor
				end if   
			end if
		#EndIf
        return FColor
    end property

    property Menu.Color(value as integer)
        FColor = value
        #IfNDef __USE_GTK__
			if Handle then
				dim as menuinfo mif
				mif.cbSize = sizeof(mif)
				GetMenuInfo(Handle,@mif)
				if mif.hbrBack then
					DeleteObject(mif.hbrBack)
				end if   
				mif.hbrBack = CreateSolidBrush(FColor)
				mif.fMask   = MIM_BACKGROUND or iif(FIncSubItems,MIM_APPLYTOSUBMENUS,0)
				SetMenuInfo(Handle,@mif)
				if FParentWindow AndAlso FParentWindow->Handle then
					DrawMenuBar(FParentWindow->Handle)
					RedrawWindow(FParentWindow->Handle,0,0,rdw_invalidate or rdw_erase)
					UpdateWindow(FParentWindow->Handle)
				end if   
			end if
		#EndIf   
    end property

    property Menu.ColorizeEntire as integer
        return FIncSubitems
    end property

    property Menu.ColorizeEntire(value as integer)
        FIncSubitems = value
        Color = FColor
    end property

    property Menu.Count as integer
        return FCount
    end property

    property Menu.Count(value as integer)
    end property

    property Menu.Item(index as integer) as MenuItem ptr
         if (index>-1) and (index<FCount) then
             return FItems[Index]
         end if   
         return NULL
    end property

    property Menu.Item(index as integer,value as MenuItem ptr)
        if (index > -1) and (index < FCount) then
            FItems[Index] = value
        end if   
    end property

    sub Menu.Add(value as PMenuItem)
		#IfNDef __USE_GTK__
			Dim As MenuItemInfo FInfo
		#EndIf
        if IndexOf(value) = -1 then
            FCount          +=1
		   FItems           = reallocate(FItems,sizeof(PMenuItem)*FCount)
		   FItems[FCount-1] = value
		   value->Parent    = Null
		   value->MenuIndex = FCount -1
'               #IfNDef __USE_GTK__
'				value->Menu      = Handle
'				#EndIf
               value->Owner     = @this
               AllocateCommand(value)
               #IfDef __USE_GTK__
					gtk_menu_shell_append(gtk_menu_shell(widget), value->widget)
					If ClassName = "MainMenu" Then
					ENd If
					If gtk_is_menu_bar(widget) <> 1 Then
						If Value->box Then
							gtk_container_add (GTK_CONTAINER (Value->box), Value->icon)
						EndIf
						gtk_widget_show_all(widget)
					End If
               #Else
				value->SetInfo(FInfo)
				InsertMenuItem(Handle,-1,true,@FInfo)
				#EndIf
           for i as integer = 0 to value->Count-1
               value->item(i)->Owner = value->Owner
'               #IfNDef __USE_GTK__
'				value->item(i)->Menu  = Handle
'				#EndIf
           next i  
           #IfNDef __USE_GTK__
			if FParentWindow AndAlso IsWindow(FParentWindow->Handle) then DrawMenuBar(FParentWindow->Handle)
			#EndIf
        end if
    end sub

    Function Menu.Add(ByRef sCaption As WString) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Add(Value)
        Return Value
    End Function
    
    Function Menu.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Value->Image     = iImage
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function
    
    Function Menu.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption)
        Value->ImageIndex = iImageIndex
        Value->Caption     = sCaption
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function

    Function Menu.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem(sCaption, sImageKey)
        'WLet Value->FImageKey, sImageKey
        If ImagesList Then Value->ImageIndex = ImagesList->IndexOf(sImageKey)
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function
        
    sub Menu.Add(value() As PMenuItem)
        For i as integer = 0 to ubound(value)
            Add(value(i))
        next        
    end sub
    
    #IfnDef __FB_64BIT__
    sub Menu.AddRange Cdecl(CountArgs As Integer, ...)
        Dim value As Any Ptr
        value = Va_first()
        For i as integer = 1 to CountArgs
            Add(Va_arg(value, PMenuItem))
            value = Va_next(value, Long)
        Next
    end sub
    #EndIf

    sub Menu.Insert(Index as integer,value as PMenuItem)
		#IfNDef __USE_GTK__
			dim as MenuItemInfo FInfo
		#EndIf
        if IndexOf(value) = -1 then
           if (Index>-1) and (Index<FCount) then
              FCount +=1
              FItems = reallocate(FItems,sizeof(PMenuItem)*FCount)
              for i as integer = Index +1 to FCount-1
                 FItems[i] = FItems[i-1]
              next i
              FItems[Index]    = value
              value->MenuIndex = Index
              value->Parent    = NULL
              #IfNDef __USE_GTK__
				value->Handle    = iif(value->Handle,value->Handle,CreatePopupMenu)
'				value->Menu      = Handle
              #EndIf
              value->Owner     = this
              AllocateCommand(value)
              #IfNDef __USE_GTK__ 
				   value->SetInfo(FInfo)
				  InsertMenuItem(Handle,Index,true,@FInfo)
				#Endif
              for i as integer = 0 to FCount-1
                  FItems[i]->MenuIndex = i
              next i
              for i as integer = 0 to value->Count-1
                  value->item(i)->Owner = value->Owner
'                  #IfNDef __USE_GTK__
'					value->item(i)->Menu  = Handle
'				#EndIf
              next i
              #IfNDef __USE_GTK__
				if FParentWindow AndAlso IsWindow(FParentWindow->Handle) then DrawMenuBar(FParentWindow->Handle)
			#EndIf
          end if
       end if
    end sub

    sub Menu.Remove(value as PMenuItem)
        dim as integer Index,i
        dim as PMenuItem FItem
        Index = IndexOf(value)
        if Index <> -1  then
            for i = Index+1 to FCount-1
                FItem      = FItems[i]
                FItems[i-1] = FItem
            next i
            FCount -= 1
            FItems  = reallocate(FItems,FCount*sizeof(PMenuItem))
            for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
            next i
            #IfNDef __USE_GTK__
				if FParentWindow AndAlso IsWindow(FParentWindow->Handle) then DrawMenuBar(FParentWindow->Handle)
			#ENdif
        end if
    end sub

    function Menu.IndexOf(value as PMenuItem) as integer
        for i as integer = 0 to FCount-1
            if FItems[i] = value then return i
        next i
        return -1
    end function

    function Menu.Find(value as integer) as MenuItem ptr
        dim as MenuItem ptr FItem
        for i as integer = 0 to FCount-1
            if Item(i)->Command = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Command = value then return FItem
        next i
        return NULL
    end function
    
    function Menu.Find(ByRef Value as WString) as MenuItem ptr
        dim as MenuItem ptr FItem
        for i as integer = 0 to FCount-1
            if Item(i)->Name = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Name = value then return FItem
        next i
        return NULL
    end function

    sub Menu.Clear
        if FItems then
            delete [] FItems
            FItems = callocate(0)
        end if
    end sub

	#IfNDef __USE_GTK__
		sub Menu.ProcessMessage(byref message as Message)
			
		end sub
	#EndIf

    operator Menu.cast as any ptr
        return @this
    end operator

    constructor Menu
    end constructor

    destructor Menu
        Clear
        #IfNDef __USE_GTK__
			if FInfo.hbrBack then DeleteObject(FInfo.hbrBack)
			if FHandle then
				DestroyMenu(FHandle)
				FHandle = 0
			end if
		#EndIf   
    end destructor

	Function MainMenu.EnumMenuItems(ByRef Item As MenuItem) As Boolean
        FMenuItems.Add Item
        For i As Integer = 0 To Item.Count -1
            EnumMenuItems *Item.Item(i)
        Next i
        Return True
    End Function

	Function GetAscKeyCode(HotKey As String) As Integer
        Select Case HotKey
        Case "Backspace", "Back": Return 08
        Case "Tab": Return 09
        Case "Enter", "Return": Return 13
        Case "Escape", "Esc": Return 27
        Case "Space": Return 32
        Case "PageUp": Return 33
        Case "PageDown": Return 34
        Case "End": Return 35
        Case "Home": Return 36
        Case "Left": Return 37
        Case "Up": Return 38
        Case "Right": Return 39
        Case "Down": Return 40
        Case "Print": Return 42
        Case "Insert", "Ins": Return 45
        Case "Num0": Return 96
        Case "Num1": Return 97
        Case "Num2": Return 98
        Case "Num3": Return 99
        Case "Num4": Return 100
        Case "Num5": Return 101
        Case "Num6": Return 102
        Case "Num7": Return 103
        Case "Num8": Return 104
        Case "Num9": Return 105
        Case "F1": Return 112
        Case "F2": Return 113
        Case "F3": Return 114
        Case "F4": Return 115
        Case "F5": Return 116
        Case "F6": Return 117
        Case "F7": Return 118
        Case "F8": Return 119
        Case "F9": Return 120
        Case "F10": Return 121
        Case "F11": Return 122
        Case "F12": Return 123
        Case "Delete", "Del": : Return 127
        Case Else: Return Asc(HotKey)
        End Select
    End Function

    /' MainMenu '/
	Property MainMenu.ParentWindow(value As Component Ptr)
		FParentWindow = value
		if value then
			#IfDef __USE_GTK__
				If value Then
					If value->layoutwidget then
						'gtk_container_add(GTK_CONTAINER(value->layoutwidget), widget)
						If value->box Then gtk_box_pack_start(Gtk_Box(value->box), widget, false, false, 0)
						Dim As GdkGeometry hints
						hints.base_width = 0
						hints.base_height = 0
						hints.min_width = 0
						hints.min_height = 0
						hints.width_inc = 1
						hints.height_inc = 1
						gtk_window_set_geometry_hints(gtk_window(gtk_widget_get_toplevel(widget)), widget, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
                        For i As Integer = 0 To Count - 1
							If Item(i)->SubMenu Then
								gtk_window_set_geometry_hints(gtk_window(gtk_widget_get_toplevel(widget)), Item(i)->SubMenu->Widget, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
							End If
                        Next i
					End If
				End If
		   #Else
			   If FParentWindow AndAlso IsWindow(FParentWindow->Handle) then
				   SetMenu(FParentWindow->Handle, This.FHandle)
				   DrawMenuBar(FParentWindow->Handle)
			   end if
			#EndIf
			FMenuItems.Clear
			For i As Integer = 0 To Count -1
                EnumMenuItems *Item(i)
            Next i
            Dim As MenuItem Ptr mi
            #IfDef __USE_GTK__
				For i As Integer = 0 To FMenuItems.Count - 1
					mi = FMenuItems.Items[i]
					If mi->accelerator_key = 0 AndAlso mi->accelerator_mods = 0 Then Continue For 
					If FParentWindow->Accelerator = 0 Then
						FParentWindow->Accelerator = gtk_accel_group_new()
						gtk_window_add_accel_group (GTK_WINDOW (FParentWindow->widget), FParentWindow->Accelerator)
					End If
					If mi->accelerator_key <> 0 Then
						gtk_widget_add_accelerator(mi->widget, "activate", FParentWindow->Accelerator, mi->accelerator_key, mi->accelerator_mods, GTK_ACCEL_VISIBLE)
					End If
				Next i
            #Else
				Dim As String mnuCaption, HotKey
				Dim As Integer Pos1, CountOfHotKeys = 0
				ReDim accl(1) As ACCEL
				For i As Integer = 0 To FMenuItems.Count - 1
					mi = FMenuItems.Items[i]
					mnuCaption = mi->Caption
					Pos1 = InStr(mnuCaption, !"\t")
					If Pos1 > 0 Then
						CountOfHotKeys = CountOfHotKeys + 1
						HotKey = Mid(mnuCaption, Pos1 + 1)
						ReDim Preserve accl(CountOfHotKeys - 1) As ACCEL
						If Instr(HotKey, "Ctrl") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FCONTROL
						If Instr(HotKey, "Shift") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FSHIFT
						If Instr(HotKey, "Alt") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FALT
						accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FVIRTKEY
						Pos1 = InstrRev(HotKey, "+")
						If Pos1 > 0 Then HotKey = Mid(HotKey, Pos1 + 1)
						accl(CountOfHotKeys - 1).key = GetAscKeyCode(HotKey)
						accl(CountOfHotKeys - 1).cmd = mi->Command
					End If
				Next i
				FParentWindow->Accelerator = CreateAcceleratorTable(Cast(LPACCEL, @accl(0)), CountOfHotKeys)
			#EndIf
		end if
	end  property

	sub MainMenu.ProcessMessages(byref message as Message)
		dim As PMenuItem I
		#IfDef __USE_GTK__
		#Else
			I = Find(loword(message.wparam))
		#EndIf
		if I then I->Click
	end sub

    operator MainMenu.cast as any ptr
        return @this
    end operator

    constructor MainMenu
		#IfDef __USE_GTK__
			widget = gtk_menu_bar_new()
		#Else
			This.FHandle      = CreateMenu
		#EndIf
        WLet FClassName, "MainMenu"
        FIncSubItems = 1
        #IfNDef __USE_GTK__
			FColor       = GetSysColor(color_menu)
			FInfo.cbSize = sizeof(FInfo)
			if FInfo.hbrBack then DeleteObject(FInfo.hbrBack)
			FInfo.hbrBack    = CreateSolidBrush(FColor)
			FInfo.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
			FInfo.fMask      = MIM_BACKGROUND or iif(FIncSubItems,MIM_APPLYTOSUBMENUS,0) or mim_menudata
			SetMenuInfo(This.FHandle,@FInfo)
        #ENdIf
    end constructor

    destructor MainMenu
    end destructor


    /' PopupMenu '/
    property PopupMenu.ParentWindow(value as Component Ptr)
		#IfDef __USE_GTK__
			If FParentWindow = 0 Then
				gtk_menu_attach_to_widget(gtk_menu(widget), value->widget, NULL)
			End If
		#EndIf
		Base.ParentWindow = Value
	End Property
    
    sub PopupMenu.Popup(x as integer,y as integer, msg As Message Ptr = 0)
        #IfDef __USE_GTK__
			If msg <> 0 Then
				gtk_widget_show_all (widget)
				gtk_menu_popup (gtk_menu(widget), NULL, NULL, NULL, NULL, msg->event->button.button, msg->event->button.time)
			End If
        #Else
			If FParentWindow AndAlso FParentWindow->Handle Then
				TrackPopupMenuEx(This.FHandle,0,x,y,FParentWindow->Handle,0)
			End If
		#EndIf
    end sub
    
	sub PopupMenu.ProcessMessages(byref message as Message)
		dim As PMenuItem I
		#IfNDef __USE_GTK__
			I = Find(loword(message.wparam))
		#EndIf
		If I Then I->Click
	End Sub
	
    Operator PopupMenu.cast as any ptr
        return @this
    End Operator

    Constructor PopupMenu
		#IfDef __USE_GTK__
			widget = gtk_menu_new()
			gtk_menu_set_reserve_toggle_size(gtk_menu(widget) , false)
			'gtk_menu_set_screen(gtk_menu(widget), gdk_screen_get_default())
		#Else
			This.FHandle = CreatePopupMenu
			FInfo.cbsize     = sizeof(FInfo)
			FInfo.fmask      = MIM_MENUDATA
			FInfo.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
			SetMenuInfo(This.FHandle,@FInfo)
		#EndIf
        WLet FClassName, "PopupMenu"
    end constructor

    destructor PopupMenu
    end destructor
End namespace

#IfDef __EXPORT_PROCS__
Function MenuItemItemsCount Alias "MenuItemItemsCount"(PMenuItem As My.Sys.Forms.MenuItem Ptr) As Integer Export
	Return PMenuItem->Count
End Function

Function MenuItemsCount Alias "MenuItemsCount"(PMenu As My.Sys.Forms.Menu Ptr) As Integer Export
	Return PMenu->Count
End Function

Function MenuItemFindByName Alias "MenuItemFindByName"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr Export
	Return PMenuItem->Find(FName)
End Function

Function MenuFindByName Alias "MenuFindByName"(PMenu As My.Sys.Forms.Menu Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr Export
	Return PMenu->Find(FName)
End Function

Function MenuItemAdd Alias "MenuItemAdd"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As Any Ptr = Null, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr Export
	Return PMenuItem->Add(sCaption, sImageKey, sKey, eClick, Index)
End Function

Sub MenuItemRemove Alias "MenuItemRemove"(ParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
	ParentMenuItem->Remove PMenuItem
End Sub

Sub MenuRemove Alias "MenuRemove"(ParentMenu As My.Sys.Forms.Menu Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
	ParentMenu->Remove PMenuItem
End Sub
#EndIf
