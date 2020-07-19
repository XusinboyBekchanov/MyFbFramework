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

#include once "Menus.bi"

Namespace My.Sys.Forms
	/' Global '/
	Sub AllocateCommand(value As PMenuItem)
		Static As Integer uniqueId
		If uniqueId = 0 Then uniqueId = 999
		If value Then
			If (value->Command <= 0) Then
			value->Command = uniqueId + 1
			uniqueId = value->Command
		End If
	End If
End Sub

Function MenuItem.ToString ByRef As WString
	Return This.Name
End Function

Sub TraverseItems(Item As MenuItem)
	#ifndef __USE_GTK__
		Dim As MenuItemInfo mii
		mii.cbsize = SizeOf(mii)
		mii.fMask  = MIIM_TYPE
		For i As Integer = 0 To Item.Count-1
			GetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,True,@mii)
			mii.fType = IIf((mii.fType And MFT_SEPARATOR),MFT_SEPARATOR,MFT_OWNERDRAW)
			SetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,True,@mii)
			TraverseItems(*Item.Item(i))
		Next i
	#endif
End Sub

/' MenuItem '/
#ifndef __USE_GTK__
	Sub MenuItem.SetInfo(ByRef value As MENUITEMINFO)
		If *FCaption = "" Then
			*FCaption = Chr(0)
		End If
		value.cbSize      = SizeOf(value)
		value.fMask       = IIf(Handle,MIIM_SUBMENU,MIIM_ID) Or MIIM_FTYPE Or MIIM_BITMAP Or MIIM_STRING Or MIIM_DATA Or MIIM_STATE
		value.hSubMenu    = Handle
		value.fType       = IIf(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
		value.fState      = IIf(FEnabled, MFS_ENABLED, MFS_DISABLED) Or IIf(FChecked, MFS_CHECKED, MFS_UNCHECKED)
		value.wID         = IIf(Handle, -1, This.Command)
		If FImageIndex <> - 1 AndAlso owner AndAlso owner->imageslist Then FImage = owner->imageslist->GetIcon(FImageIndex).ToBitmap
		Value.hbmpItem     = FImage.Handle 'IIf(FImageIndex <> - 1, HBMMENU_CALLBACK, FImage.Handle)
		value.dwItemData  = Cast(dword_Ptr, Cast(Any Ptr, @This))
		value.dwTypeData  = FCaption
		value.cch         = Len(*FCaption)
	End Sub
	
	Sub MenuItem.SetItemInfo(ByRef value As MENUITEMINFO)
		If Parent AndAlso Parent->Handle Then
			SetMenuItemInfo(Parent->Handle, FMenuIndex, True, @value)
		ElseIf This.Owner AndAlso This.Owner->Handle Then
			SetMenuItemInfo(This.Owner->Handle, FMenuIndex, True, @value)
		End If
	End Sub
#endif

Property MenuItem.MenuIndex As Integer
	Return FMenuIndex
End Property

Property MenuItem.MenuIndex(value As Integer)
	FMenuIndex = value
End Property

Property MenuItem.Name ByRef As WString
	Return WGet(FName)
End Property

Property MenuItem.Name(ByRef value As WString)
	WLet FName, value
End Property

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

Property MenuItem.Image As My.Sys.Drawing.BitmapType
	Return FImage
End Property

Property MenuItem.Image(value As My.Sys.Drawing.BitmapType)
	FImage = value
	#ifndef __USE_GTK__
		Dim mii As MENUITEMINFOW
		mii.cbSize = SizeOf(mii)
		mii.fMask = MIIM_BITMAP
		mii.hbmpItem = value.Handle
		
		SetItemInfo mii
	#endif
End Property

Property MenuItem.ImageIndex As Integer
	Return FImageIndex
End Property

Property MenuItem.ImageIndex(value As Integer)
	FImageIndex = value
	If value <> -1 AndAlso owner AndAlso owner->imageslist Then
		#ifndef __USE_GTK__
			FImage = owner->imageslist->GetIcon(value).ToBitmap
			
			Dim mii As MENUITEMINFOW
			mii.cbSize = SizeOf(mii)
			mii.fMask = MIIM_BITMAP
			mii.hbmpItem = FImage 'HBMMENU_CALLBACK
			
			SetItemInfo mii
		#endif
	End If
End Property

#ifdef __USE_GTK__
	Sub MenuItem.MenuItemActivate(m_item As GtkMenuItem Ptr, user_data As Any Ptr) '...'
		Dim As MenuItem Ptr Ctrl = user_data
		If Ctrl Then
			If Ctrl->OnClick Then Ctrl->OnClick(*Ctrl)
		End If
	End Sub
#endif

Property MenuItem.ImageKey ByRef As WString
	Return WGet(FImageKey)
End Property

Property MenuItem.ImageKey(ByRef value As WString)
	WLet FImageKey, value
	#ifdef __USE_GTK__
		If Icon Then
			gtk_image_set_from_icon_name(GTK_IMAGE(icon), Value, GTK_ICON_SIZE_MENU)
		Else
			
		End If
	#endif
	'gtk_container_add (GTK_CONTAINER (box), icon)
	'gtk_container_add (GTK_CONTAINER (widget), box)
	'gtk_widget_show_all (widget)
	If value <> "" AndAlso owner AndAlso owner->imageslist Then
		ImageIndex = owner->imageslist->IndexOf(value)
	End If
End Property

Property MenuItem.Command As Integer
	Return FCommand
End Property

Property MenuItem.Command(value As Integer)
	FCommand = value
End Property

#ifndef __USE_GTK__
	Property MenuItem.Handle As HMENU
		Return FHandle
	End Property
	
	Property MenuItem.Handle(value As HMENU)
		FHandle = value
	End Property
#endif

Property MenuItem.Owner As PMenu
	Return FOwner
End Property

Property MenuItem.Owner(value As PMenu)
	FOwner = value
End Property

'	#IfNDef __USE_GTK__
'		property MenuItem.Menu as HMENU
'			return FMenu
'		end property
'
'		property MenuItem.Menu(value as HMENU)
'			FMenu = value
'		end property
'	#EndIf

Property MenuItem.Parent As PMenuItem
	Return FParent
End Property

Property MenuItem.Parent(value As PMenuItem)
	Dim As PMenuItem SaveParent = FParent
	FParent = value
	If SaveParent Then SaveParent->Remove(This)
	If FParent Then FParent->Add(This)
End Property

Property MenuItem.Caption ByRef As WString
	Return WGet(FCaption)
End Property

Property MenuItem.Caption(ByRef value As WString)
	FCaption = Reallocate(FCaption, (Len(value) + 1) * SizeOf(WString))
	*FCaption = value
	#ifdef __USE_GTK__
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
					#ifdef __USE_GTK3__
						gtk_accel_label_set_accel(GTK_ACCEL_LABEL (label), accelerator_key, accelerator_mods) 'accelerator_mods)
					#else
						If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Accelerator Then
							gtk_widget_add_accelerator (label, "activate", Owner->ParentWindow->Accelerator, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
						End If
					#endif
					'If Owner Then
					'	Dim As Component Ptr Cpnt = Owner->GetTopLevel
					'	If Cpnt->AccelGroup <> 0 Then Cpnt->AccelGroup = gtk_accel_group_new()
					'	gtk_widget_add_accelerator (widget, "activate", Cpnt->AccelGroup, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
					'End If
				End If
			Else
				WLet FText, Replace(value, "&", "_")
				gtk_label_set_text_with_mnemonic(gtk_label(label), ToUTF8(*FText))
			End If
		End If
	#else
		FInfo.cbSize      = SizeOf(FInfo)
		FInfo.fMask       = MIIM_STRING
		FInfo.dwTypeData = FCaption
		FInfo.cch        = Len(*FCaption)
		If Parent Then
			SetMenuItemInfo(Parent->Handle, MenuIndex, True, @FInfo)
		ElseIf Owner AndAlso Owner->Handle Then
			SetMenuItemInfo(Owner->Handle, MenuIndex, True, @FInfo)
		End If
		If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
			DrawMenuBar(Owner->ParentWindow->Handle)
		End If
	#endif
End Property

Property MenuItem.Checked As Boolean
	Return FChecked
End Property

Property MenuItem.Checked(value As Boolean)
	FChecked = value
	#ifdef __USE_GTK__
		If gtk_is_check_menu_item(widget) Then
			gtk_check_menu_item_set_active(gtk_check_menu_item(widget), value)
		End If
	#else
		Dim As Integer FCheck(-1 To 1) =>{MF_CHECKED, MF_UNCHECKED, MF_CHECKED}
		If Parent Then
			If Handle Then
				CheckMenuItem(Parent->Handle,CInt(Handle),MF_POPUP Or FCheck(FChecked))
			Else
				CheckMenuItem(Parent->Handle,MenuIndex,MF_BYPOSITION Or FCheck(FChecked))
			End If
		End If
	#endif
End Property

Property MenuItem.RadioItem As Boolean
	Return FRadioItem
End Property

Property MenuItem.RadioItem(value As Boolean)
	FRadioItem = value
	Dim As Integer First,Last
	If Parent Then
		First = Parent->Item(0)->MenuIndex
		Last  = Parent->Item(Parent->Count-1)->MenuIndex
		#ifdef __USE_GTK__
			If gtk_is_check_menu_item(widget) Then
				gtk_check_menu_item_set_draw_as_radio(gtk_check_menu_item(widget), True)
				gtk_check_menu_item_set_active(gtk_check_menu_item(widget), value)
			End If
		#else
			CheckMenuRadioItem(Parent->Handle, First, Last, MenuIndex, MF_BYPOSITION)
		#endif
	End If
End Property

Property MenuItem.Enabled As Boolean
	Return FEnabled
End Property

Property MenuItem.Enabled(value As Boolean)
	FEnabled = value
	#ifdef __USE_GTK__
		gtk_widget_set_sensitive(widget, FEnabled)
	#else
		Dim As Integer FEnable(0 To 1) => {MF_DISABLED Or MF_GRAYED, MF_ENABLED}
		If Parent Then
			EnableMenuItem(Parent->Handle, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
		ElseIf Owner AndAlso Owner->Handle Then
			EnableMenuItem(Owner->Handle, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
		End If
'		If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
'			DrawMenuBar(Owner->ParentWindow->Handle)
'		End If
	#endif
End Property

Property MenuItem.Visible As Boolean
	Return FVisible
End Property

Property MenuItem.Visible(value As Boolean)
	If fvisible = value Then Exit Property
	FVisible = value
	#ifdef __USE_GTK__
		gtk_widget_set_visible(widget, FVisible)
	#else
		If FVisible = False Then
			If Parent Then
				RemoveMenu(Parent->Handle, MenuIndex, MF_BYPOSITION)
			ElseIf Owner AndAlso Owner->Handle Then
				RemoveMenu(Owner->Handle, MenuIndex, MF_BYPOSITION)
			End If
		Else
			SetInfo(FInfo)
			SetItemInfo(FInfo)
		End If
	#endif
End Property

Property MenuItem.Count As Integer
	Return FCount
End Property

Property MenuItem.Count(value As Integer)
End Property

Property MenuItem.Item(index As Integer) As PMenuItem
	If (index > -1) And (index  <FCount) Then
		Return FItems[index]
	End If
	Return NULL
End Property

Property MenuItem.Item(index As Integer,value As PMenuItem)
End Property

Sub MenuItem.Click
	If onClick Then onClick(This)
End Sub

Sub MenuItem.Add(ByRef value As PMenuItem, ByVal Index As Integer = -1)
	If IndexOf(value) = -1 Then
		FCount += 1
		FItems = Reallocate(FItems, SizeOf(PMenuItem)*FCount)
		If Index <> -1 Then
			For i As Integer = FCount - 1 To Index + 1 Step -1
				FItems[i] = FItems[i-1]
			Next i
		Else
			Index = FCount - 1
		End If
		value->MenuIndex = Index
		value->FParent    = @This
		value->Owner     = Owner
		'			#IfNDef __USE_GTK__
		'				value->Menu      = This.Menu
		'			#EndIf
		AllocateCommand(value)
		FItems[Index]            = value
		#ifdef __USE_GTK__
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
		#else
			If Handle = 0 Then
				Handle = CreatePopupMenu
				Dim As menuinfo mif
				mif.cbSize     = SizeOf(mif)
				mif.dwmenudata = Cast(dword_Ptr,Cast(Any Ptr, @This))
				mif.fMask      = MIM_MENUDATA
				.SetMenuInfo(Handle, @mif)
				SetInfo(FInfo)
				SetItemInfo(FInfo)
			End If
			value->SetInfo(FInfo)
			InsertMenuItem(Handle, Index, True, @FInfo)
		#endif
	End If
End Sub

Function MenuItem.Add(ByRef sCaption As WString) As MenuItem Ptr
	Dim As MenuItem Ptr Value = New MenuItem(sCaption)
	Add(Value)
	Return Value
End Function

Function MenuItem.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
	Dim As MenuItem Ptr Value = New MenuItem(sCaption, , eClick, Checkable)
	Value->FImage     = iImage
	Value->Name     = sKey
	Value->OnClick     = eClick
	Add(Value, Index)
	Return Value
End Function

Function MenuItem.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
	Dim As MenuItem Ptr Value = New MenuItem(sCaption, , eClick, Checkable)
	Value->FImageIndex = iImageIndex
	Value->Name     = sKey
	Value->OnClick     = eClick
	Add(Value, Index)
	Return Value
End Function

Function MenuItem.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null, Checkable As Boolean = False, Index As Integer = -1) As MenuItem Ptr
	Dim As MenuItem Ptr Value = New MenuItem(sCaption, sImageKey, eClick, Checkable)
	WLet Value->FImageKey, sImageKey
	If Owner AndAlso Owner->ImagesList Then Value->FImageIndex = Owner->ImagesList->IndexOf(sImageKey)
	Value->Name     = sKey
	Value->OnClick     = eClick
	Add(Value, Index)
	Return Value
End Function

Sub MenuItem.Add(value() As PMenuItem)
	For i As Integer = 0 To UBound(value)
		Add(value(i))
	Next
End Sub

#if Not defined(__FB_64BIT__) And Not defined(__FB_GCC__)
	Sub MenuItem.AddRange cdecl(CountArgs As Integer, ...)
		Dim value As Any Ptr
		value = va_first()
		For i As Integer = 1 To CountArgs
			Add(va_arg(value, PMenuItem))
			value = va_next(value, Long)
		Next
	End Sub
#endif

Sub MenuItem.Insert(Index As Integer, value As PMenuItem)
	If IndexOf(value) = -1 Then
		If (Index>-1) And (Index<FCount) Then
			FCount += 1
			FItems = Reallocate(FItems,SizeOf(PMenuItem)*FCount)
			For i As Integer = Index+1 To FCount-1
				FItems[i] = FItems[i-1]
			Next i
			FItems[Index]            = value
			FItems[Index]->MenuIndex = Index
			FItems[Index]->Parent    = @This
			FItems[Index]->Owner     = Owner
			'				#IfNDef __USE_GTK__
			'					FItems[Index]->Menu      = This.Menu
			'				#EndIf
			AllocateCommand(value)
			If FCount > 0 Then
				#ifndef __USE_GTK__
					If Handle = 0 Then
						Handle = CreatePopupMenu
						Dim As menuinfo mif
						mif.cbSize     = SizeOf(mif)
						mif.dwmenudata = Cast(dword_Ptr,Cast(Any Ptr,@This))
						mif.fMask      = MIM_MENUDATA
						.SetMenuInfo(Handle,@mif)
						SetInfo(FInfo)
						If Parent Then
							SetMenuItemInfo(Parent->Handle,MenuIndex,True,@FInfo)
						End If
					End If
				#endif
			End If
			#ifndef __USE_GTK__
				value->SetInfo(FInfo)
				InsertMenuItem(Handle,Index,True,@FInfo)
			#endif
			For i As Integer = 0 To FCount-1
				FItems[i]->MenuIndex = i
			Next i
		End If
	End If
End Sub

Sub MenuItem.Remove(value As PMenuItem)
	Dim As Integer Index,i
	Dim As PMenuItem FItem
	Index = IndexOf(value)
	If Index <> -1  Then
		For i = Index+1 To FCount-1
			FItem = FItems[i]
			FItems[i-1] = FItem
		Next i
		FCount -= 1
		FItems  = Reallocate(FItems,FCount*SizeOf(PMenuItem))
		For i As Integer = 0 To FCount-1
			FItems[i]->MenuIndex = i
		Next i
		#ifdef __USE_GTK__
			If widget Then
				'gtk_container_remove(gtk_container(widget), value->widget)
			End If
		#else
			If Handle Then
				RemoveMenu(Handle, Index, MF_BYPOSITION)
			End If
		#endif
	End If
End Sub

Sub MenuItem.Clear
	For i As Integer = Count - 1 To 0 Step -1
		Remove FItems[i]
		'FItems[i] = NULL
	Next i
	FItems = CAllocate(0)
	FCount = 0
End Sub

Function MenuItem.IndexOf(value As PMenuItem) As Integer
	Dim As Integer i
	For i = 0 To FCount -1
		If FItems[i] = value Then Return i
	Next i
	Return -1
End Function

Function MenuItem.Find(value As Integer) As PMenuItem
	Dim As PMenuItem FItem
	For i As Integer = 0 To FCount -1
		If Item(i)->Command = value Then Return Item(i)
		FItem = Item(i)->Find(value)
		If FItem Then If FItem->Command = value Then Return FItem
	Next i
	Return NULL
End Function

Function MenuItem.Find(ByRef value As WString) As PMenuItem
	Dim As PMenuItem FItem
	For i As Integer = 0 To FCount -1
		If Item(i)->Name = value Then Return Item(i)
		FItem = Item(i)->Find(value)
		If FItem Then If FItem->Name = value Then Return FItem
	Next i
	Return NULL
End Function

Operator MenuItem.cast As Any Ptr
	Return @This
End Operator

Constructor MenuItem(ByRef wCaption As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = Null, Checkable As Boolean = False)
	FVisible    = True
	FEnabled    = True
	FChecked    = False
	#ifdef __USE_GTK__
		If wCaption = "-" Then
			widget = gtk_separator_menu_item_new()
			'ElseIf wImageKey = "" Then
			'
			'	widget = gtk_menu_item_new_with_mnemonic(wCaption)
			label = gtk_bin_get_child (GTK_BIN (widget))
			'	g_signal_connect(widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
		ElseIf Checkable Then
			widget = gtk_check_menu_item_new_with_label (ToUTF8(wCaption))
			'ElseIf wImageKey = "" Then
			'
			'	widget = gtk_menu_item_new_with_mnemonic(wCaption)
			label = gtk_bin_get_child (GTK_BIN (widget))
		Else
			If wImageKey = "" Then
				icon = gtk_image_new_from_pixbuf(EmptyPixbuf)
			Else
				icon = gtk_image_new_from_icon_name(ToUTF8(wImageKey), GTK_ICON_SIZE_MENU)
				'				#ifndef __USE_GTK3__
				'					gtk_misc_set_alignment (GTK_MISC (icon), 0.0, 0.0)
				'				#endif
			End If
			gtk_image_set_pixel_size(gtk_image(icon), 16)
			#ifndef __USE_GTK3__
				widget = gtk_image_menu_item_new_with_mnemonic(ToUTF8(wCaption))
				gtk_image_menu_item_set_image (gtk_image_menu_item(widget), icon)
				gtk_image_menu_item_set_always_show_image(gtk_image_menu_item(widget), wImageKey <> "")
				label = gtk_bin_get_child (GTK_BIN (widget))
			#else
				#ifdef __USE_GTK3__
					box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#else
					box = gtk_hbox_new(False, 1)
				#endif
				widget = gtk_menu_item_new()
				label = gtk_accel_label_new (ToUTF8(wCaption & "   "))
				gtk_accel_label_set_accel_widget (GTK_ACCEL_LABEL (label), widget)
				gtk_box_pack_end (GTK_BOX (box), label, True, True, 0)
				#ifdef __USE_GTK3__
					gtk_label_set_xalign (GTK_LABEL (label), 0.0)
				#else
					gtk_label_set_justify(GTK_LABEL (label), GTK_JUSTIFY_LEFT)
				#endif
				'gtk_container_add (GTK_CONTAINER (box), label)
				gtk_container_add (GTK_CONTAINER (widget), box)
			#endif
			g_signal_connect(widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
			'g_signal_connect(widget, "event", G_CALLBACK(@EventProc), @This)
			'g_signal_connect(widget, "event-after", G_CALLBACK(@EventAfterProc), @This)
		End If
	#else
		FImage = 0
	#endif
	Caption = wCaption
	FImageIndex = -1
	OnClick = eClick
	WLet FClassName, "MenuItem"
	WLet FImageKey, wImageKey
End Constructor

Destructor MenuItem
	If FParent Then
		FParent->Remove(@This)
	End If
	If FItems Then
		Delete [] FItems
		FItems = CAllocate(0)
	End If
	If FCaption Then Deallocate FCaption
	WDeallocate FText
	WDeallocate FAccelerator
	#ifdef __USE_GTK__
		If gtk_is_widget(widget) Then gtk_widget_destroy(Widget)
	#else
		If FHandle Then
			DestroyMenu(FHandle)
			FHandle = 0
		End If
	#endif
End Destructor

/' Menu '/
#ifndef __USE_GTK__
	Property Menu.Handle As HMENU
		Return FHandle
	End Property
	
	Property Menu.Handle(value As HMENU)
		FHandle = value
	End Property
#endif
Property Menu.ParentWindow As Component Ptr
	Return FParentWindow
End Property

Property Menu.ParentWindow(value As Component Ptr)
	FParentWindow = value
	If ImagesList Then ImagesList->ParentWindow = FParentWindow
End Property

Property Menu.Style As Integer
	Return FStyle
End Property

Property Menu.Style(value As Integer)
	FStyle = value
	#ifndef __USE_GTK__
		If Handle Then
			If value Then
				For i As Integer = 0 To FCount-1
					TraverseItems(*Item(i))
				Next i
				/'else
				for i as integer = 0 to FCount-1
				TraverseItems(*Item(i))
				next i '/
			End If
			If FParentWindow AndAlso IsWindow(FParentWindow->Handle) Then
				SetMenu(FParentWindow->Handle,Handle)
				DrawMenuBar(FParentWindow->Handle)
			End If
		End If
	#endif
End Property

Property Menu.Color As Integer
	#ifndef __USE_GTK__
		If handle Then
			Dim As menuinfo mif
			mif.cbSize = SizeOf(mif)
			mif.fMask  = MIM_BACKGROUND
			If GetMenuInfo(Handle,@mif) Then
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

#If Not defined(__FB_64BIT__) And Not defined(__FB_GCC__)
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

#ifndef __USE_GTK__
	Sub Menu.ProcessMessage(ByRef message As Message)
		
	End Sub
#endif

Operator Menu.cast As Any Ptr
	Return @This
End Operator

Constructor Menu
End Constructor

Destructor Menu
	Clear
	#ifndef __USE_GTK__
		If FInfo.hbrBack Then DeleteObject(FInfo.hbrBack)
		If FHandle Then
			DestroyMenu(FHandle)
			FHandle = 0
		End If
	#endif
End Destructor

Function MainMenu.EnumMenuItems(ByRef Item As MenuItem) As Boolean
	FMenuItems.Add Item
	For i As Integer = 0 To Item.Count -1
		EnumMenuItems *Item.Item(i)
	Next i
	Return True
End Function

Function GetAscKeyCode(HotKey As String) As Integer
	Select Case HotKey
	Case "Break": Return 03
	Case "Backspace", "Back": Return 08
	Case "Tab": Return 09
	Case "Enter", "Return": Return 13
	Case "Pause": Return 19
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

Function GetChrKeyCode(KeyCode As Integer) As String
	Select Case KeyCode
	Case 03: Return "Break"
	Case 08: Return "Backspace"
	Case 09: Return "Tab"
	Case 13: Return "Enter"
	Case 19: Return "Pause"
	Case 27: Return "Escape"
	Case 32: Return "Space"
	Case 33: Return "PageUp"
	Case 34: Return "PageDown"
	Case 35: Return "End"
	Case 36: Return "Home"
	Case 37: Return "Left"
	Case 38: Return "Up"
	Case 39: Return "Right"
	Case 40: Return "Down"
	Case 42: Return "Print"
	Case 45: Return "Insert"
	Case 96: Return "Num0"
	Case 97: Return "Num1"
	Case 98: Return "Num2"
	Case 99: Return "Num3"
	Case 100: Return "Num4"
	Case 101: Return "Num5"
	Case 102: Return "Num6"
	Case 103: Return "Num7"
	Case 104: Return "Num8"
	Case 105: Return "Num9"
	Case 112: Return "F1"
	Case 113: Return "F2"
	Case 114: Return "F3"
	Case 115: Return "F4"
	Case 116: Return "F5"
	Case 117: Return "F6"
	Case 118: Return "F7"
	Case 119: Return "F8"
	Case 120: Return "F9"
	Case 121: Return "F10"
	Case 122: Return "F11"
	Case 123: Return "F12"
	Case 127: Return "Delete"
	Case Else: Return Chr(KeyCode)
	End Select
End Function

/' MainMenu '/
Property MainMenu.ParentWindow(value As Component Ptr)
	FParentWindow = value
	If value Then
		#ifdef __USE_GTK__
			If value Then
				If value->layoutwidget Then
					'gtk_container_add(GTK_CONTAINER(value->layoutwidget), widget)
					If value->box Then gtk_box_pack_start(Gtk_Box(value->box), widget, False, False, 0)
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
		#else
			If FParentWindow AndAlso IsWindow(FParentWindow->Handle) Then
				SetMenu(FParentWindow->Handle, This.FHandle)
				DrawMenuBar(FParentWindow->Handle)
			End If
		#endif
		FMenuItems.Clear
		For i As Integer = 0 To Count -1
			EnumMenuItems *Item(i)
		Next i
		Dim As MenuItem Ptr mi
		#ifdef __USE_GTK__
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
		#else
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
					If InStr(HotKey, "Ctrl") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FCONTROL
					If InStr(HotKey, "Shift") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FSHIFT
					If InStr(HotKey, "Alt") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FALT
					accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FVIRTKEY
					Pos1 = InStrRev(HotKey, "+")
					If Pos1 > 0 Then HotKey = Mid(HotKey, Pos1 + 1)
					accl(CountOfHotKeys - 1).key = GetAscKeyCode(HotKey)
					accl(CountOfHotKeys - 1).cmd = mi->Command
				End If
			Next i
			If FParentWindow Then
				If FParentWindow->Accelerator <> 0 Then DestroyAcceleratorTable(FParentWindow->Accelerator)
				FParentWindow->Accelerator = CreateAcceleratorTable(Cast(LPACCEL, @accl(0)), CountOfHotKeys)
			End If
		#endif
	End If
	End  Property
	
	Sub MainMenu.ProcessMessages(ByRef message As Message)
		Dim As PMenuItem I
		#ifdef __USE_GTK__
		#else
			I = Find(LoWord(message.wparam))
		#endif
		If I Then I->Click
	End Sub
	
	Operator MainMenu.cast As Any Ptr
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
		#ifdef __USE_GTK__
			widget = gtk_menu_new()
			gtk_menu_set_reserve_toggle_size(gtk_menu(widget) , False)
			'gtk_menu_set_screen(gtk_menu(widget), gdk_screen_get_default())
		#else
			This.FHandle = CreatePopupMenu
			FInfo.cbsize     = SizeOf(FInfo)
			FInfo.fmask      = MIM_MENUDATA
			FInfo.dwmenudata = Cast(dword_Ptr,Cast(Any Ptr,@This))
			SetMenuInfo(This.FHandle,@FInfo)
		#endif
		WLet FClassName, "PopupMenu"
	End Constructor
	
	Destructor PopupMenu
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
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
		Return PMenuItem->Add(sCaption, sImageKey, sKey, eClick, False, Index)
	End Function
	
	Sub MenuItemRemove Alias "MenuItemRemove"(ParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
		ParentMenuItem->Remove PMenuItem
	End Sub
	
	Sub MenuRemove Alias "MenuRemove"(ParentMenu As My.Sys.Forms.Menu Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
		ParentMenu->Remove PMenuItem
	End Sub
#endif
