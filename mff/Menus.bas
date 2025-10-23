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
	Private Sub AllocateCommand(value As PMenuItem)
		#if defined(__USE_WINAPI__) OrElse defined(__USE_JNI__)
			Handles.Add value
			value->Command =  1000 + Handles.Count - 1
		#else
			Static As Integer uniqueId
			If uniqueId = 0 Then uniqueId = 999
			If value Then
				If (value->Command <= 0) Then
					value->Command = uniqueId + 1
					uniqueId = value->Command
				End If
			End If
		#endif
	End Sub
	
	#ifndef ReadProperty_Off
		Private Function MenuItem.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "caption": Return FCaption
			Case "checked": Return @FChecked
			Case "command": Return @FCommand
			Case "count": Return @FCount
			Case "enabled": Return @FEnabled
			Case "image": Return @FImage
			Case "imageindex": Return @FImageIndex
			Case "imagekey": Return FImageKey
			Case "menuindex": Return @FMenuIndex
			Case "name": Return FName
			Case "owner": Return FOwner
			Case "parent": Return Parent
			Case "parentmenu": Return FOwner
			Case "parentmenuitem": Return FParentMenuItem
			Case "radioitem": Return @FRadioItem
			Case "shortcut": Return FAccelerator
			Case "tag": Return Tag
			#ifdef __USE_GTK__
				Case "widget": Return @Widget
			#elseif defined(__USE_WINAPI__)
				Case "handle": Return @FHandle
			#endif
			Case "visible": Return @FVisible
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function MenuItem.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case "owner": This.Owner = Value
				Case "parent": This.Parent = Value
				Case "parentmenu": This.ParentMenu = Value
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "caption": This.Caption = QWString(Value)
				Case "checked": This.Checked = QBoolean(Value)
				Case "command": This.Command = QInteger(Value)
				Case "enabled": This.Enabled = QBoolean(Value)
				Case "image": This.Image = QWString(Value)
				Case "imageindex": This.ImageIndex = QInteger(Value)
				Case "imagekey": This.ImageKey = QWString(Value)
				Case "menuindex": This.MenuIndex = QInteger(Value)
				Case "name": This.Name = QWString(Value)
				Case "owner": This.Owner = Value
				Case "parent": This.Parent = Value
				Case "parentmenu": This.ParentMenu = Value
				Case "radioitem": This.RadioItem = QBoolean(Value)
				Case "shortcut": This.ShortCut = QWString(Value)
				Case "tag": This.Tag = Value
				Case "visible": This.Visible = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Function MenuItem.ToString ByRef As WString
		Return This.Name
	End Function
	
	#ifndef TraverseItems_Off
		Private Sub Menu.TraverseItems(MItem As MenuItem)
			#ifdef __USE_WINAPI__
				Dim As MENUITEMINFO mii
				mii.cbSize = SizeOf(mii)
				mii.fMask  = MIIM_TYPE
				For i As Integer = 0 To MItem.Count - 1
					GetMenuItemInfo(MItem.Handle, MItem.Item(i)->VisibleMenuIndex, True, @mii)
					mii.fType = IIf((mii.fType And MFT_SEPARATOR),MFT_SEPARATOR,MFT_OWNERDRAW)
					SetMenuItemInfo(MItem.Handle, MItem.Item(i)->VisibleMenuIndex, True, @mii)
					TraverseItems(*MItem.Item(i))
				Next i
			#endif
		End Sub
	#endif
	
	/' MenuItem '/
	#ifdef __USE_WINAPI__
		Private Sub MenuItem.SetInfo(ByRef value As MENUITEMINFO)
			If *FCaption = "" Then
				*FCaption = Chr(0)
			End If
			value.cbSize      = SizeOf(value)
			value.fMask       = IIf(Handle,MIIM_SUBMENU,MIIM_ID) Or MIIM_FTYPE Or MIIM_BITMAP Or MIIM_STRING Or MIIM_DATA Or MIIM_STATE
			value.hSubMenu    = Handle
			value.fType       = IIf(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
			value.fState      = IIf(FEnabled, MFS_ENABLED, MFS_DISABLED) Or IIf(FChecked, MFS_CHECKED, MFS_UNCHECKED)
			value.wID         = IIf(Handle, -1, This.Command)
			If FImageIndex <> - 1 AndAlso Owner AndAlso Owner->ImagesList Then
				FImage.LoadFromHICON(Owner->ImagesList->GetIcon(FImageIndex).Handle)
			ElseIf WGet(FImageKey) <> "" AndAlso FImage.Handle = 0 Then
				FImage.LoadFromResourceName(*FImageKey)
			End If
			If Owner <> 0 AndAlso Not Owner->DisplayIcons Then
				value.hbmpItem     = 0
			Else
				value.hbmpItem     = FImage.Handle 'IIf(FImageIndex <> - 1, HBMMENU_CALLBACK, FImage.Handle)
			End If
			value.dwItemData  = Cast(DWORD_PTR, Cast(Any Ptr, @This))
			If *FCaption = "-" Then
				WLet(pCaption, "|")
			Else
				WLet(pCaption, *FCaption & IIf(*FAccelerator = "", "", !"\t" & *FAccelerator))
			End If
			value.dwTypeData  = pCaption
			value.cch         = Len(*pCaption)
		End Sub
		
		Private Sub MenuItem.SetItemInfo(ByRef value As MENUITEMINFO)
			If ParentMenuItem AndAlso ParentMenuItem->Handle Then
				SetMenuItemInfo(ParentMenuItem->Handle, VisibleMenuIndex, True, @value)
			ElseIf This.Owner AndAlso This.Owner->Handle Then
				SetMenuItemInfo(This.Owner->Handle, VisibleMenuIndex, True, @value)
			End If
		End Sub
	#endif
	
	Private Sub MenuItem.ChangeIndex(Value As PMenuItem, Index As Integer)
		Dim OldIndex As Integer = This.IndexOf(Value)
		If OldIndex > -1 AndAlso OldIndex <> Index AndAlso Index <= FCount - 1 Then
			If Index < OldIndex Then
				For i As Integer = OldIndex - 1 To Index Step -1
					FItems[i + 1] = FItems[i]
				Next i
				FItems[Index] = Value
			Else
				For i As Integer = OldIndex + 1 To Index
					FItems[i - 1] = FItems[i]
				Next i
				FItems[Index] = Value
			End If
		End If
	End Sub
	
	Private Property MenuItem.MenuIndex As Integer
		Return FMenuIndex
	End Property
	
	Private Property MenuItem.MenuIndex(value As Integer)
		FMenuIndex = value
		If FParentMenuItem Then
			FParentMenuItem->ChangeIndex @This, FMenuIndex
		ElseIf FOwner Then
			FOwner->ChangeIndex @This, FMenuIndex
		End If
	End Property
	
	Private Function MenuItem.VisibleMenuIndex() As Integer
		Dim iIndex As Integer
		If FParentMenuItem Then
			For i As Integer = 0 To FParentMenuItem->Count - 1
				If FParentMenuItem->Item(i) = @This Then Return iIndex
				If FParentMenuItem->Item(i)->Visible Then
					iIndex += 1
				End If
			Next
			Return -1
		ElseIf FOwner Then
			For i As Integer = 0 To FOwner->Count - 1
				If FOwner->Item(i) = @This Then Return iIndex
				If FOwner->Item(i)->Visible Then
					iIndex += 1
				End If
			Next
			Return -1
		End If
	End Function
	
	Private Property MenuItem.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	#ifndef MenuItem_Name_Set_Off
		Private Property MenuItem.Name(ByRef value As WString)
			WLet(FName, value)
		End Property
	#endif
	
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
	
	Private Property MenuItem.Image As My.Sys.Drawing.BitmapType
		Return FImage
	End Property
	
	#ifndef MenuItem_Image_Set_BitmapType_Off
		Private Property MenuItem.Image(value As My.Sys.Drawing.BitmapType)
			FImage = value
			#ifdef __USE_WINAPI__
				Dim mii As MENUITEMINFOW
				mii.cbSize = SizeOf(mii)
				mii.fMask = MIIM_BITMAP
				mii.hbmpItem = value.Handle
				
				SetItemInfo mii
			#endif
		End Property
	#endif
	
	Private Property MenuItem.Image(ByRef value As WString)
		FImage = value
		#ifdef __USE_WINAPI__
			Dim mii As MENUITEMINFOW
			mii.cbSize = SizeOf(mii)
			mii.fMask = MIIM_BITMAP
			mii.hbmpItem = FImage.Handle
			
			SetItemInfo mii
		#endif
	End Property
	
	Private Property MenuItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	#ifndef MenuItem_ImageIndex_Set_Off
		Private Property MenuItem.ImageIndex(value As Integer)
			FImageIndex = value
			If value <> -1 AndAlso Owner AndAlso Owner->ImagesList Then
				#ifdef __USE_WINAPI__
					FImage.Handle = Owner->ImagesList->GetIcon(value).ToBitmap
					
					Dim mii As MENUITEMINFOW
					mii.cbSize = SizeOf(mii)
					mii.fMask = MIIM_BITMAP
					mii.hbmpItem = FImage.Handle 'HBMMENU_CALLBACK
					
					SetItemInfo mii
				#endif
			End If
		End Property
	#endif
	
	#ifdef __USE_GTK__
		Private Sub MenuItem.MenuItemActivate(m_item As GtkMenuItem Ptr, user_data As Any Ptr)
			Dim As MenuItem Ptr Ctrl = user_data
			If Ctrl->FMenuItemChecked Then
				Ctrl->FMenuItemChecked = False 
				Exit Sub
			End If
			If Ctrl Then
				If Ctrl->OnClick Then Ctrl->OnClick(*Ctrl->Designer, *Ctrl)
			End If
		End Sub
		
		Private Function MenuItem.MenuItemButtonPressEvent(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As MenuItem Ptr mi = user_data
			If mi->OnClick Then mi->OnClick(*mi->Designer, *mi)
			Return False
		End Function
	#endif
	
	Private Property MenuItem.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property MenuItem.ImageKey(ByRef value As WString)
		WLet(FImageKey, value)
		#ifdef __USE_GTK__
			If Icon Then
				gtk_image_set_from_icon_name(GTK_IMAGE(Icon), value, GTK_ICON_SIZE_MENU)
			Else
				
			End If
		#endif
		'gtk_container_add (GTK_CONTAINER (box), icon)
		'gtk_container_add (GTK_CONTAINER (widget), box)
		'gtk_widget_show_all (widget)
		If value <> "" AndAlso Owner AndAlso Owner->ImagesList Then
			ImageIndex = Owner->ImagesList->IndexOf(value)
		End If
	End Property
	
	Private Property MenuItem.Command As Integer
		Return FCommand
	End Property
	
	Private Property MenuItem.Command(value As Integer)
		FCommand = value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Property MenuItem.Handle As HMENU
			Return FHandle
		End Property
		
		Private Property MenuItem.Handle(value As HMENU)
			FHandle = value
		End Property
	#endif
	
	Private Property MenuItem.Owner As PMenu
		Return FOwner
	End Property
	
	Private Property MenuItem.Owner(value As PMenu)
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
	
	Private Property MenuItem.Parent As My.Sys.Object Ptr
		If FParentMenuItem Then
			Return FParentMenuItem
		Else
			Return FOwner
		End If
	End Property
	
	Private Property MenuItem.Parent(value As My.Sys.Object Ptr)
		If *value Is Menu Then
			ParentMenu = Cast(Menu Ptr, value)
		ElseIf *value Is MenuItem Then
			ParentMenuItem = Cast(MenuItem Ptr, value)
		End If
	End Property
	
	Private Property MenuItem.ParentMenu As PMenu
		Return FOwner
	End Property
	
	Private Property MenuItem.ParentMenu(value As PMenu)
		Dim As PMenu SaveParent = FOwner
		FOwner = value
		If SaveParent Then SaveParent->Remove(@This)
		If FOwner Then FOwner->Add(@This)
	End Property
	
	Private Property MenuItem.ParentMenuItem As PMenuItem
		Return FParentMenuItem
	End Property
	
	Private Property MenuItem.ParentMenuItem(value As PMenuItem)
		If FParentMenuItem <> value Then
			Dim As PMenuItem SaveParent = FParentMenuItem
			FParentMenuItem = value
			If SaveParent Then SaveParent->Remove(@This)
			If FParentMenuItem Then FParentMenuItem->Add(@This)
		End If
	End Property
	
	Private Property MenuItem.Caption ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Private Property MenuItem.Caption(ByRef value As WString)
		FCaption = _Reallocate(FCaption, (Len(value) + 1) * SizeOf(WString))
		*FCaption = value
		#ifdef __USE_GTK__
			If value <> "-" Then
				Dim p As Integer = InStr(value, !"\t")
				If p > 0 Then
					Dim As String HotKey = Mid(value, p + 1)
					WLet(FText, Replace(.Left(value, p), "&", "_"))
					WLet(FAccelerator, HotKey)
					gtk_label_set_text_with_mnemonic(GTK_LABEL(Label), ToUtf8(*FText))
					If HotKey <> "" Then
						HotKey = Replace(HotKey, "Ctrl+", "<Ctrl>")
						HotKey = Replace(HotKey, "Alt+", "<Alt>")
						HotKey = Replace(HotKey, "Shift+", "<Shift>")
						gtk_accelerator_parse(ToUtf8(HotKey), @accelerator_key, @accelerator_mods)
						#ifdef __USE_GTK3__
							gtk_accel_label_set_accel(GTK_ACCEL_LABEL (Label), accelerator_key, accelerator_mods) 'accelerator_mods)
						#else
							If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Accelerator Then
								gtk_widget_add_accelerator (Widget, "activate", Owner->ParentWindow->Accelerator, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
							End If
						#endif
						'If Owner Then
						'	Dim As Component Ptr Cpnt = Owner->GetTopLevel
						'	If Cpnt->AccelGroup <> 0 Then Cpnt->AccelGroup = gtk_accel_group_new()
						'	gtk_widget_add_accelerator (widget, "activate", Cpnt->AccelGroup, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
						'End If
					End If
				Else
					WLet(FText, Replace(value, "&", "_"))
					If *FText = "" Then
						gtk_label_set_text_with_mnemonic(GTK_LABEL(Label), !"\0")
					Else
						gtk_label_set_text_with_mnemonic(GTK_LABEL(Label), ToUtf8(*FText))
					End If
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			FInfo.cbSize      = SizeOf(FInfo)
			FInfo.fMask       = MIIM_STRING Or MIIM_FTYPE
			FInfo.fType       = IIf(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
			Dim As WString Ptr pCaption
			If *FCaption = "-" Then
				WLet(pCaption, "|")
			Else
				WLet(pCaption, *FCaption)
			End If
			FInfo.dwTypeData = pCaption
			FInfo.cch        = Len(*pCaption)
			If ParentMenuItem Then
				SetMenuItemInfo(ParentMenuItem->Handle, VisibleMenuIndex, True, @FInfo)
			ElseIf Owner AndAlso Owner->Handle Then
				SetMenuItemInfo(Owner->Handle, VisibleMenuIndex, True, @FInfo)
			End If
			If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
				DrawMenuBar(Owner->ParentWindow->Handle)
			End If
			WDeAllocate(pCaption)
		#endif
	End Property
	
	Private Property MenuItem.ShortCut ByRef As WString
		Return WGet(FAccelerator)
	End Property
	
	Private Property MenuItem.ShortCut(ByRef value As WString)
		FAccelerator = _Reallocate(FAccelerator, (Len(value) + 1) * SizeOf(WString))
		*FAccelerator = value
		#ifdef __USE_GTK__
			If value <> "-" AndAlso *FAccelerator <> "" Then
				Dim As String HotKey = *FAccelerator
				HotKey = Replace(HotKey, "Ctrl+", "<Ctrl>")
				HotKey = Replace(HotKey, "Alt+", "<Alt>")
				HotKey = Replace(HotKey, "Shift+", "<Shift>")
				gtk_accelerator_parse(ToUtf8(HotKey), @accelerator_key, @accelerator_mods)
				#ifdef __USE_GTK3__
					gtk_accel_label_set_accel(GTK_ACCEL_LABEL (Label), accelerator_key, accelerator_mods) 'accelerator_mods)
				#else
					If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Accelerator Then
						gtk_widget_add_accelerator (Label, "activate", Owner->ParentWindow->Accelerator, accelerator_key, accelerator_mods, GTK_ACCEL_VISIBLE)
					End If
				#endif
			End If
		#elseif defined(__USE_WINAPI__)
			FInfo.cbSize      = SizeOf(FInfo)
			FInfo.fMask       = MIIM_STRING Or MIIM_FTYPE
			FInfo.fType       = IIf(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
			Dim As WString Ptr pCaption
			If *FCaption = "-" Then
				WLet(pCaption, "|")
			Else
				WLet(pCaption, *FCaption & IIf(*FAccelerator = "", "", !"\t" & *FAccelerator))
			End If
			FInfo.dwTypeData = pCaption
			FInfo.cch        = Len(*pCaption)
			If ParentMenuItem Then
				SetMenuItemInfo(ParentMenuItem->Handle, VisibleMenuIndex, True, @FInfo)
			ElseIf Owner AndAlso Owner->Handle Then
				SetMenuItemInfo(Owner->Handle, VisibleMenuIndex, True, @FInfo)
			End If
			If Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
				DrawMenuBar(Owner->ParentWindow->Handle)
			End If
			WDeAllocate(pCaption)
		#endif
	End Property
	
	Private Property MenuItem.Checked As Boolean
		Return FChecked
	End Property
	
	Private Property MenuItem.Checked(value As Boolean)
		FChecked = value
		#ifdef __USE_GTK__
			If GTK_IS_CHECK_MENU_ITEM(Widget) Then
				FMenuItemChecked = True
				gtk_check_menu_item_set_active(GTK_CHECK_MENU_ITEM(Widget), value)
			End If
		#elseif defined(__USE_WINAPI__)
			Dim As Integer FCheck(-1 To 1) =>{MF_CHECKED, MF_UNCHECKED, MF_CHECKED}
			If ParentMenuItem AndAlso ParentMenuItem->Handle Then
				If Handle Then
					CheckMenuItem(ParentMenuItem->Handle, CInt(Handle), MF_POPUP Or FCheck(FChecked))
				Else
					CheckMenuItem(ParentMenuItem->Handle, VisibleMenuIndex, MF_BYPOSITION Or FCheck(FChecked))
				End If
			ElseIf Owner AndAlso Owner->Handle Then
				If Handle Then
					CheckMenuItem(Owner->Handle, CInt(Handle), MF_POPUP Or FCheck(FChecked))
				Else
					CheckMenuItem(Owner->Handle, VisibleMenuIndex, MF_BYPOSITION Or FCheck(FChecked))
				End If
			End If
		#endif
	End Property
	
	Private Property MenuItem.RadioItem As Boolean
		Return FRadioItem
	End Property
	
	Private Property MenuItem.RadioItem(value As Boolean)
		FRadioItem = value
		Dim As Integer First,Last
		If ParentMenuItem OrElse ParentMenu Then
			If ParentMenuItem Then
				First = ParentMenuItem->Item(0)->VisibleMenuIndex
				Last  = ParentMenuItem->Item(ParentMenuItem->Count - 1)->VisibleMenuIndex
			Else
				First = ParentMenu->Item(0)->VisibleMenuIndex
				Last  = ParentMenu->Item(ParentMenu->Count - 1)->VisibleMenuIndex
			End If
			#ifdef __USE_GTK__
				If GTK_IS_CHECK_MENU_ITEM(Widget) Then
					gtk_check_menu_item_set_draw_as_radio(GTK_CHECK_MENU_ITEM(Widget), True)
					gtk_check_menu_item_set_active(GTK_CHECK_MENU_ITEM(Widget), value)
				End If
			#elseif defined(__USE_WINAPI__)
				CheckMenuRadioItem(ParentMenu->Handle, First, Last, VisibleMenuIndex, MF_BYPOSITION)
			#endif
		End If
	End Property
	
	Private Property MenuItem.Enabled As Boolean
		Return FEnabled
	End Property
	
	Private Property MenuItem.Enabled(value As Boolean)
		FEnabled = value
		#ifdef __USE_GTK__
			gtk_widget_set_sensitive(Widget, FEnabled)
		#elseif defined(__USE_WINAPI__)
			Dim As Integer FEnable(0 To 1) => {MF_DISABLED Or MF_GRAYED, MF_ENABLED}
			If ParentMenuItem Then
				EnableMenuItem(ParentMenuItem->Handle, VisibleMenuIndex, MF_BYPOSITION Or FEnable(abs_(FEnabled)))
			ElseIf Owner AndAlso Owner->Handle Then
				EnableMenuItem(Owner->Handle, VisibleMenuIndex, MF_BYPOSITION Or FEnable(abs_(FEnabled)))
			End If
			If ParentMenuItem = 0 AndAlso Owner AndAlso Owner->ParentWindow AndAlso Owner->ParentWindow->Handle Then
				DrawMenuBar(Owner->ParentWindow->Handle)
			End If
		#endif
	End Property
	
	Private Property MenuItem.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property MenuItem.Visible(value As Boolean)
		If FVisible = value Then Exit Property
		FVisible = value
		#ifdef __USE_GTK__
			gtk_widget_set_visible(Widget, FVisible)
		#elseif defined(__USE_WINAPI__)
			If FVisible = False Then
				If ParentMenuItem Then
					RemoveMenu(ParentMenuItem->Handle, VisibleMenuIndex, MF_BYPOSITION)
				ElseIf Owner AndAlso Owner->Handle Then
					RemoveMenu(Owner->Handle, VisibleMenuIndex, MF_BYPOSITION)
				End If
			Else
				SetInfo(FInfo)
				If ParentMenuItem Then
					InsertMenuItem(ParentMenuItem->Handle, VisibleMenuIndex, True, @FInfo)
				ElseIf Owner AndAlso Owner->Handle Then
					InsertMenuItem(Owner->Handle, VisibleMenuIndex, True, @FInfo)
				End If
				'SetItemInfo(FInfo)
			End If
		#endif
	End Property
	
	Private Property MenuItem.Count As Integer
		Return FCount
	End Property
	
	Private Property MenuItem.Count(value As Integer)
	End Property
	
	Private Property MenuItem.Item(index As Integer) As PMenuItem
		If (index > -1) And (index  <FCount) Then
			Return FItems[index]
		End If
		Return 0
	End Property
	
	Private Property MenuItem.Item(index As Integer, value As PMenuItem)
	End Property
	
	Private Property MenuItem.Item(ByRef Key As WString) As PMenuItem
		Return This.Item(This.IndexOf(Key))
	End Property
	
	Private Property MenuItem.Item(ByRef Key As WString, value As PMenuItem)
	End Property
	
	Private Sub MenuItem.Click
		If OnClick Then OnClick(*Designer, This)
	End Sub
	
	Private Sub MenuItem.Add(ByRef value As PMenuItem, ByVal Index As Integer = -1)
		If IndexOf(value) = -1 Then
			FCount += 1
			FItems = _Reallocate(FItems, SizeOf(PMenuItem)*FCount)
			If Index <> -1 Then
				For i As Integer = FCount - 1 To Index + 1 Step -1
					FItems[i] = FItems[i-1]
				Next i
			Else
				Index = FCount - 1
			End If
			value->MenuIndex = Index
			value->FParentMenuItem    = @This
			value->Owner     = Owner
			'			#IfNDef __USE_GTK__
			'				value->Menu      = This.Menu
			'			#EndIf
			AllocateCommand(value)
			FItems[Index]            = value
			#ifdef __USE_GTK__
				If SubMenu = 0 Then
					SubMenu = _New( PopupMenu)
					gtk_menu_item_set_submenu(GTK_MENU_ITEM(Widget), SubMenu->Handle)
					gtk_widget_show(SubMenu->Handle)
				End If
				If Index = -1 Then
					gtk_menu_shell_append(GTK_MENU_SHELL(SubMenu->Handle), value->Widget)
				Else
					gtk_menu_shell_insert(GTK_MENU_SHELL(SubMenu->Handle), value->Widget, Index)
				End If
				If value->Box Then
					gtk_container_add (GTK_CONTAINER (value->Box), value->Icon)
					gtk_widget_show(value->Box)
					gtk_widget_show(value->Icon)
				EndIf
				If value->Label Then
					gtk_label_set_text_with_mnemonic(GTK_LABEL(value->Label), ToUtf8(*value->FText & "	"))
					gtk_widget_show(value->Label)
				End If
				If value->FVisible Then
					gtk_widget_show(value->Widget)
				End If
			#elseif defined(__USE_WINAPI__)
				If SubMenu = 0 Then
					SubMenu = _New( PopupMenu)
					SubMenu->ParentMenuItem = @This
					Handle = SubMenu->Handle
					Dim As MENUINFO mif
					mif.cbSize     = SizeOf(mif)
					mif.dwMenuData = Cast(DWORD_PTR, Cast(Any Ptr, SubMenu)) '@This))
					mif.fMask      = MIM_MENUDATA
					.SetMenuInfo(Handle, @mif)
					SetInfo(FInfo)
					SetItemInfo(FInfo)
				End If
				value->SetInfo(FInfo)
				If value->FVisible Then
					InsertMenuItem(Handle, Index, True, @FInfo)
				End If
			#endif
		End If
	End Sub
	
	Private Function MenuItem.Add(ByRef sCaption As WString) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption))
		Value->FDynamic = True
		Add(Value)
		Return Value
	End Function
	
	Private Function MenuItem.Add(ByRef sCaption As WString, ByRef iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, , eClick, Checkable))
		Value->FDynamic = True
		Value->FImage.Handle     = iImage.Handle
		Value->Name     = sKey
		Value->Enabled  = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Function MenuItem.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, , eClick, Checkable))
		Value->FDynamic = True
		Value->FImageIndex = iImageIndex
		Value->Name     = sKey
		Value->Enabled  = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Function MenuItem.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, sImageKey, eClick, Checkable))
		Value->FDynamic = True
		WLet(Value->FImageKey, sImageKey)
		If Owner AndAlso Owner->ImagesList Then Value->FImageIndex = Owner->ImagesList->IndexOf(sImageKey)
		Value->Name     = sKey
		Value->Enabled  = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Sub MenuItem.Add(value() As PMenuItem)
		For i As Integer = 0 To UBound(value)
			Add(value(i))
		Next
	End Sub
	
	Private Sub MenuItem.AddRange cdecl(CountArgs As Integer, ...)
		'Dim value As Any Ptr
		Dim args As Cva_List
		'value = va_first()
		Cva_Start(args, CountArgs)
		For i As Integer = 1 To CountArgs
			'Add(va_arg(value, PMenuItem))
			Add(Cva_Arg(args, PMenuItem))
			'value = va_next(value, Long)
		Next
		Cva_End(args)
	End Sub
	
	#ifndef MenuItem_Insert_Off
		Private Sub MenuItem.Insert(Index As Integer, value As PMenuItem)
			If IndexOf(value) = -1 Then
				If (Index>-1) And (Index<FCount) Then
					FCount += 1
					FItems = _Reallocate(FItems,SizeOf(PMenuItem)*FCount)
					For i As Integer = Index+1 To FCount-1
						FItems[i] = FItems[i-1]
					Next i
					FItems[Index]            = value
					FItems[Index]->MenuIndex = Index
					FItems[Index]->FParentMenuItem    = @This
					FItems[Index]->Owner     = Owner
					'				#IfNDef __USE_GTK__
					'					FItems[Index]->Menu      = This.Menu
					'				#EndIf
					AllocateCommand(value)
					If FCount > 0 Then
						#ifdef __USE_WINAPI__
							If Handle = 0 Then
								Handle = CreatePopupMenu
								Dim As MENUINFO mif
								mif.cbSize     = SizeOf(mif)
								mif.dwMenuData = Cast(DWORD_PTR,Cast(Any Ptr,@This))
								mif.fMask      = MIM_MENUDATA
								.SetMenuInfo(Handle,@mif)
								SetInfo(FInfo)
								If ParentMenuItem Then
									SetMenuItemInfo(ParentMenuItem->Handle, VisibleMenuIndex, True, @FInfo)
								End If
							End If
						#endif
					End If
					#ifdef __USE_WINAPI__
						value->SetInfo(FInfo)
						InsertMenuItem(Handle,Index,True,@FInfo)
					#endif
					For i As Integer = 0 To FCount-1
						FItems[i]->MenuIndex = i
					Next i
				End If
			End If
		End Sub
	#endif
	
	Private Sub MenuItem.Remove(value As PMenuItem)
		Dim As Integer Index,i
		Dim As PMenuItem FItem
		Index = IndexOf(value)
		If Index <> -1  Then
			#ifdef __USE_WINAPI__
				If FHandle Then
					RemoveMenu(FHandle, value->VisibleMenuIndex, MF_BYPOSITION)
				End If
			#endif
			For i = Index+1 To FCount-1
				FItem = FItems[i]
				FItems[i-1] = FItem
			Next i
			FCount -= 1
			If FCount = 0 Then
				_Deallocate(FItems)
			Else
				FItems = _Reallocate(FItems,FCount*SizeOf(PMenuItem))
				For i As Integer = 0 To FCount - 1
					FItems[i]->MenuIndex = i
				Next i
			End If
			#ifdef __USE_GTK__
				If Widget Then
					'gtk_container_remove(gtk_container(widget), value->widget)
				End If
			#endif
		End If
	End Sub
	
	Private Sub MenuItem.Clear
		For i As Integer = Count - 1 To 0 Step -1
			#ifdef __USE_WINAPI__
				If FItems[i]->FDynamic Then _Delete(FItems[i])
				If Handle Then
					RemoveMenu(Handle, i, MF_BYPOSITION)
				End If
			#elseif defined(__USE_GTK__)
				If SubMenu AndAlso SubMenu->Handle Then
					If GTK_IS_CONTAINER(SubMenu->Handle) Then gtk_container_remove(GTK_CONTAINER(SubMenu->Handle), FItems[i]->Widget)
					FItems[i]->Widget = 0
				End If
				If FItems[i]->FDynamic Then _Delete(FItems[i])
			#endif
			'Remove FItems[i]
			'FItems[i] = NULL
		Next i
		If FItems <> 0 Then _Deallocate(FItems)
		FItems = 0 'CAllocate_(0)
		FCount = 0
	End Sub
	
	Private Function MenuItem.IndexOf(value As PMenuItem) As Integer
		Dim As Integer i
		For i = 0 To FCount -1
			If FItems[i] = value Then Return i
		Next i
		Return -1
	End Function
	
	#ifndef MenuItem_IndexOf_WString_Off
		Private Function MenuItem.IndexOf(ByRef Key As WString) As Integer
			Dim As Integer i
			For i = 0 To FCount -1
				If FItems[i]->Name = Key Then Return i
			Next i
			Return -1
		End Function
	#endif
	
	Private Function MenuItem.Find(value As Integer) As PMenuItem
		Dim As PMenuItem FItem
		For i As Integer = 0 To FCount -1
			If Item(i)->Command = value Then Return Item(i)
			FItem = Item(i)->Find(value)
			If FItem Then If FItem->Command = value Then Return FItem
		Next i
		Return 0
	End Function
	
	#ifndef MenuItem_Find_WString_Off
		Private Function MenuItem.Find(ByRef value As WString) As PMenuItem
			Dim As PMenuItem FItem
			For i As Integer = 0 To FCount - 1
				If Item(i)->Name = value Then Return Item(i)
				FItem = Item(i)->Find(value)
				If FItem Then If FItem->Name = value Then Return FItem
			Next i
			Return 0
		End Function
	#endif
	
	Private Operator MenuItem.cast As Any Ptr
		Return @This
	End Operator
	
	Private Sub MenuItem.BitmapChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.BitmapType)
		With *Cast(MenuItem Ptr, Sender.Graphic)
			'.Caption = .Caption
		End With
	End Sub
	
	Private Constructor MenuItem(ByRef wCaption As WString = "", ByRef wImageKey As WString = "", eClick As NotifyEvent = 0, Checkable As Boolean = False)
		FVisible    = True
		FEnabled    = True
		FChecked    = False
		#ifdef __USE_GTK__
			If wCaption = "-" Then
				Widget = gtk_separator_menu_item_new()
				'ElseIf wImageKey = "" Then
				'
				'	widget = gtk_menu_item_new_with_mnemonic(wCaption)
				Label = gtk_bin_get_child (GTK_BIN (Widget))
				'	g_signal_connect(widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
			ElseIf Checkable Then
				Widget = gtk_check_menu_item_new_with_label (ToUtf8(wCaption))
				'ElseIf wImageKey = "" Then
				'
				'	widget = gtk_menu_item_new_with_mnemonic(wCaption)
				Label = gtk_bin_get_child (GTK_BIN (Widget))
				'g_signal_connect(widget, "button-release-event", G_CALLBACK(@MenuItemButtonPressEvent), @This)
				g_signal_connect(Widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
			Else
				If wImageKey = "" Then
					Icon = gtk_image_new_from_pixbuf(EmptyPixbuf)
				Else
					Icon = gtk_image_new_from_icon_name(ToUtf8(wImageKey), GTK_ICON_SIZE_MENU)
					'				#ifndef __USE_GTK3__
					'					gtk_misc_set_alignment (GTK_MISC (icon), 0.0, 0.0)
					'				#endif
				End If
				gtk_image_set_pixel_size(GTK_IMAGE(Icon), 16)
				#ifdef __USE_GTK2__
					Widget = gtk_image_menu_item_new_with_mnemonic(ToUtf8(wCaption))
					gtk_image_menu_item_set_image (GTK_IMAGE_MENU_ITEM(Widget), Icon)
					gtk_image_menu_item_set_always_show_image(GTK_IMAGE_MENU_ITEM(Widget), wImageKey <> "")
					Label = gtk_bin_get_child (GTK_BIN (Widget))
				#else
					#ifndef __USE_GTK2__
						Box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
					#else
						Box = gtk_hbox_new(False, 1)
					#endif
					Widget = gtk_menu_item_new()
					Label = gtk_accel_label_new (ToUtf8(wCaption & "   "))
					gtk_accel_label_set_accel_widget (GTK_ACCEL_LABEL (Label), Widget)
					#ifdef __USE_GTK4__
						gtk_box_pack_end(GTK_BOX (Box), Label)
					#else
						gtk_box_pack_end(GTK_BOX (Box), Label, True, True, 0)
					#endif
					#ifdef __USE_GTK3__
						gtk_label_set_xalign (GTK_LABEL (Label), 0.0)
					#else
						gtk_label_set_justify(GTK_LABEL (Label), GTK_JUSTIFY_LEFT)
					#endif
					'gtk_container_add (GTK_CONTAINER (box), label)
					gtk_container_add (GTK_CONTAINER (Widget), Box)
				#endif
				g_signal_connect(Widget, "activate", G_CALLBACK(@MenuItemActivate), @This)
				'g_signal_connect(widget, "event", G_CALLBACK(@EventProc), @This)
				'g_signal_connect(widget, "event-after", G_CALLBACK(@EventAfterProc), @This)
			End If
		#else
			FImage.Graphic = @This
			FImage.Changed = @BitmapChanged
			#ifdef __USE_WASM__
				FImage.Handle = ""
			#else
				FImage.Handle = 0
			#endif
		#endif
		Caption = wCaption
		FImageIndex = -1
		OnClick = eClick
		WLet(FClassName, "MenuItem")
		WLet(FImageKey, wImageKey)
	End Constructor
	
	Private Destructor MenuItem
		'	If FParent Then
		'		FParent->Remove(@This)
		'	End If
		This.Clear
		WDeAllocate(pCaption)
		WDeAllocate(FCaption)
		WDeAllocate(FText)
		WDeAllocate(FAccelerator)
		WDeAllocate(FName)
		WDeAllocate(FImageKey)
		If SubMenu Then _Delete(SubMenu)
		#ifdef __USE_GTK__
			#ifndef __FB_WIN32__
				If GTK_IS_WIDGET(Widget) Then 
					#ifdef __USE_GTK4__
						g_object_unref(Widget)
					#else
						gtk_widget_destroy(Widget)
					#endif
				End If
			#endif
		#elseif defined(__USE_WINAPI__)
			If ParentMenuItem Then
				RemoveMenu(ParentMenuItem->Handle, VisibleMenuIndex, MF_BYPOSITION)
			ElseIf Owner AndAlso Owner->Handle Then
				RemoveMenu(Owner->Handle, VisibleMenuIndex, MF_BYPOSITION)
			End If
		#endif
	End Destructor
	
	/' Menu '/
	#ifndef ReadProperty_Off
		Private Function Menu.ReadProperty(ByRef PropertyName As String) As Any Ptr
			FTempString = LCase(PropertyName)
			Select Case FTempString
			Case "count": Return @FCount
			Case "color": Return @FColor
			Case "colorizeentire": Return @FIncSubItems
			Case "displayicons": Return @FDisplayIcons
			Case "imageslist": Return ImagesList
			Case "parentwindow": Return FParentWindow
			Case "style": Return @FStyle
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function Menu.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "color": This.Color = QInteger(Value)
				Case "colorizeentire": This.ColorizeEntire = QInteger(Value)
				Case "displayicons": DisplayIcons = QBoolean(Value)
				Case "imageslist": ImagesList = Value
				Case "parentwindow": ParentWindow = Value
				Case "style": FStyle = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	#ifdef __USE_WINAPI__
		Private Property Menu.Handle As HMENU
			Return FHandle
		End Property
		
		Private Property Menu.Handle(value As HMENU)
			FHandle = value
		End Property
	#endif
	Private Property Menu.ParentWindow As Component Ptr
		Return FParentWindow
	End Property
	
	Private Property Menu.ParentWindow(value As Component Ptr)
		FParentWindow = value
		If ImagesList Then ImagesList->ParentWindow = FParentWindow
	End Property
	
	Private Property Menu.Style As Integer
		Return FStyle
	End Property
	
	Private Property Menu.Style(value As Integer)
		FStyle = value
		#ifdef __USE_WINAPI__
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
	
	Private Property Menu.DisplayIcons As Boolean
		Return FDisplayIcons
	End Property
	
	Private Property Menu.DisplayIcons(Value As Boolean)
		FDisplayIcons = Value
	End Property
	
	Private Property Menu.Color As Integer
		#ifdef __USE_WINAPI__
			If Handle Then
				Dim As MENUINFO mif
				mif.cbSize = SizeOf(mif)
				mif.fMask  = MIM_BACKGROUND
				If GetMenuInfo(Handle,@mif) Then
					Dim As LOGBRUSH lb
					GetObject(mif.hbrBack,SizeOf(lb),@lb)
					FColor = lb.lbColor
					Return FColor
				End If
			End If
		#endif
		Return FColor
	End Property
	
	#ifndef Menu_Color_Set_Off
		Private Property Menu.Color(value As Integer)
			FColor = value
			#ifdef __USE_WINAPI__
				If Handle Then
					Dim As MENUINFO mif
					mif.cbSize = SizeOf(mif)
					GetMenuInfo(Handle,@mif)
					If mif.hbrBack Then
						DeleteObject(mif.hbrBack)
					End If
					mif.hbrBack = CreateSolidBrush(FColor)
					mif.fMask   = MIM_BACKGROUND Or IIf(FIncSubItems,MIM_APPLYTOSUBMENUS,0)
					SetMenuInfo(Handle,@mif)
					If FParentWindow AndAlso FParentWindow->Handle Then
						DrawMenuBar(FParentWindow->Handle)
						RedrawWindow(FParentWindow->Handle,0,0,RDW_INVALIDATE Or RDW_ERASE)
						UpdateWindow(FParentWindow->Handle)
					End If
				End If
			#endif
		End Property
	#endif
	
	Private Property Menu.ColorizeEntire As Integer
		Return FIncSubItems
	End Property
	
	Private Property Menu.ColorizeEntire(value As Integer)
		FIncSubItems = value
		Color = FColor
	End Property
	
	Private Property Menu.Count As Integer
		If FParentMenuItem Then
			Return FParentMenuItem->Count
		Else
			Return FCount
		End If
	End Property
	
	Private Property Menu.Count(value As Integer)
	End Property
	
	Private Property Menu.Item(index As Integer) As MenuItem Ptr
		If FParentMenuItem Then
			If (index > -1) And (index < FParentMenuItem->Count) Then
				Return FParentMenuItem->Item(index)
			End If
		Else
			If (index > -1) And (index < FCount) Then
				Return FItems[index]
			End If
		End If
		Return 0
	End Property
	
	#ifndef Menu_Item_Set_MenuItem_Off
		Private Property Menu.Item(index As Integer, value As MenuItem Ptr)
			If FParentMenuItem Then
				If (index > -1) And (index < FParentMenuItem->Count) Then
					FParentMenuItem->Item(index) = value
				End If
			Else
				If (index > -1) And (index < FCount) Then
					FItems[index] = value
				End If
			End If
		End Property
	#endif
	
	Private Property Menu.Item(ByRef Key As WString) As PMenuItem
		Return This.Item(This.IndexOf(Key))
	End Property
	
	Private Property Menu.Item(ByRef Key As WString, value As PMenuItem)
		This.Item(This.IndexOf(Key)) = value
	End Property
	
	Private Sub Menu.Add(value As PMenuItem, Index As Integer = -1)
		If FParentMenuItem Then
			FParentMenuItem->Add value, Index
			Exit Sub
		End If
		#ifdef __USE_WINAPI__
			Dim As MENUITEMINFO FInfo
		#endif
		If IndexOf(value) = -1 Then
			FCount          +=1
			FItems           = _Reallocate(FItems, SizeOf(PMenuItem)*FCount)
			If Index <> -1 Then
				For i As Integer = FCount - 1 To Index + 1 Step -1
					FItems[i] = FItems[i-1]
				Next i
			Else
				Index = FCount - 1
			End If
			FItems[Index] = value
			value->Parent    = 0
			value->MenuIndex = Index
			'               #IfNDef __USE_GTK__
			'				value->Menu      = Handle
			'				#EndIf
			value->Owner     = @This
			AllocateCommand(value)
			#ifdef __USE_GTK__
				gtk_menu_shell_insert(GTK_MENU_SHELL(widget), value->Widget, Index)
				gtk_widget_show(value->Widget)
				If value->Label Then gtk_widget_show(value->Label)
				If ClassName = "MainMenu" Then
				End If
				If GTK_IS_MENU_BAR(widget) <> 1 Then
					If value->Box Then
						gtk_container_add (GTK_CONTAINER (value->Box), value->Icon)
						gtk_widget_show(value->Box)
						gtk_widget_show(value->Icon)
					EndIf
					'gtk_widget_show_all(widget)
				End If
			#elseif defined(__USE_WINAPI__)
				value->SetInfo(FInfo)
				If value->Visible Then
					InsertMenuItem(Handle, Index, True, @FInfo)
				End If
			#endif
			For i As Integer = 0 To value->Count-1
				value->Item(i)->Owner = value->Owner
				'               #IfNDef __USE_GTK__
				'				value->item(i)->Menu  = Handle
				'				#EndIf
			Next i
			#ifdef __USE_WINAPI__
				If FParentWindow AndAlso IsWindow(FParentWindow->Handle) Then DrawMenuBar(FParentWindow->Handle)
			#endif
		End If
	End Sub
	
	Private Function Menu.Add(ByRef sCaption As WString) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption))
		Value->FDynamic = True
		Add(Value)
		Return Value
	End Function
	
	Private Function Menu.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, , , Checkable))
		Value->FDynamic = True
		Value->Image     = iImage
		Value->Name     = sKey
		Value->Enabled     = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Function Menu.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, , , Checkable))
		Value->FDynamic = True
		Value->ImageIndex = iImageIndex
		Value->Caption     = sCaption
		Value->Name     = sKey
		Value->Enabled     = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Function Menu.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = 0, Checkable As Boolean = False, Index As Integer = -1, bEnabled As Boolean = True) As MenuItem Ptr
		Dim As MenuItem Ptr Value = _New( MenuItem(sCaption, sImageKey, , Checkable))
		Value->FDynamic = True
		'WLet Value->FImageKey, sImageKey
		If ImagesList Then Value->ImageIndex = ImagesList->IndexOf(sImageKey)
		Value->Name     = sKey
		Value->Enabled     = bEnabled
		Value->OnClick     = eClick
		Add(Value, Index)
		Return Value
	End Function
	
	Private Sub Menu.Add(value() As PMenuItem)
		For i As Integer = 0 To UBound(value)
			Add(value(i))
		Next
	End Sub
	
	Private Sub Menu.AddRange cdecl(CountArgs As Integer, ...)
		'Dim value As Any Ptr
		Dim args As Cva_List
		'value = va_first()
		Cva_Start(args, CountArgs)
		For i As Integer = 1 To CountArgs
			'Add(va_arg(value, PMenuItem))
			Add(Cva_Arg(args, PMenuItem))
			'value = va_next(value, Long)
		Next
		Cva_End(args)
	End Sub
	
	Private Sub Menu.Insert(Index As Integer, value As PMenuItem)
		If FParentMenuItem Then
			FParentMenuItem->Insert Index, value
			Exit Sub
		End If
		#ifdef __USE_WINAPI__
			Dim As MENUITEMINFO FInfo
		#endif
		If IndexOf(value) = -1 Then
			If (Index>-1) And (Index<FCount) Then
				FCount +=1
				FItems = _Reallocate(FItems,SizeOf(PMenuItem)*FCount)
				For i As Integer = Index +1 To FCount-1
					FItems[i] = FItems[i-1]
				Next i
				FItems[Index]    = value
				value->MenuIndex = Index
				value->Parent    = 0
				#ifdef __USE_WINAPI__
					value->Handle    = IIf(value->Handle, value->Handle, CreatePopupMenu)
					'				value->Menu      = Handle
				#endif
				value->Owner     = @This
				AllocateCommand(value)
				#ifdef __USE_WINAPI__
					value->SetInfo(FInfo)
					InsertMenuItem(Handle,Index,True,@FInfo)
				#endif
				For i As Integer = 0 To FCount-1
					FItems[i]->MenuIndex = i
				Next i
				For i As Integer = 0 To value->Count-1
					value->Item(i)->Owner = value->Owner
					'                  #IfNDef __USE_GTK__
					'					value->item(i)->Menu  = Handle
					'				#EndIf
				Next i
				#ifdef __USE_WINAPI__
					If FParentWindow AndAlso IsWindow(FParentWindow->Handle) Then DrawMenuBar(FParentWindow->Handle)
				#endif
			End If
		End If
	End Sub
	
	Private Sub Menu.Remove(value As PMenuItem)
		Dim As Integer Index,i
		Dim As PMenuItem FItem
		Index = IndexOf(value)
		If Index <> -1  Then
			#if defined(__USE_WINAPI__)
				If FHandle Then
					RemoveMenu(FHandle, value->VisibleMenuIndex, MF_BYPOSITION)
				End If
			#endif
			For i = Index+1 To FCount-1
				FItem      = FItems[i]
				FItems[i-1] = FItem
			Next i
			FCount -= 1
			FItems  = _Reallocate(FItems,FCount*SizeOf(PMenuItem))
			For i As Integer = 0 To FCount-1
				FItems[i]->MenuIndex = i
			Next i
			#ifdef __USE_WINAPI__
				If FParentWindow AndAlso IsWindow(FParentWindow->Handle) Then DrawMenuBar(FParentWindow->Handle)
			#endif
		End If
	End Sub
	
	Private Function Menu.IndexOf(value As PMenuItem) As Integer
		For i As Integer = 0 To FCount - 1
			If FItems[i] = value Then Return i
		Next i
		Return -1
	End Function
	
	#ifndef Menu_IndexOf_WString_Off
		Private Function Menu.IndexOf(ByRef Key As WString) As Integer
			For i As Integer = 0 To FCount - 1
				If FItems[i]->Name = Key Then Return i
			Next i
			Return -1
		End Function
	#endif
	
	Private Function Menu.Find(value As Integer) As MenuItem Ptr
		Dim As MenuItem Ptr FItem
		For i As Integer = 0 To FCount-1
			If Item(i)->Command = value Then Return Item(i)
			FItem = Item(i)->Find(value)
			If FItem Then If FItem->Command = value Then Return FItem
		Next i
		Return 0
	End Function
	
	Private Function Menu.Find(ByRef Value As WString) As MenuItem Ptr
		Dim As MenuItem Ptr FItem
		For i As Integer = 0 To FCount-1
			If Item(i)->Name = Value Then Return Item(i)
			FItem = Item(i)->Find(Value)
			If FItem Then If FItem->Name = Value Then Return FItem
		Next i
		Return 0
	End Function
	
	Private Sub Menu.ChangeIndex(Value As PMenuItem, Index As Integer)
		Dim OldIndex As Integer = This.IndexOf(Value)
		If OldIndex > -1 AndAlso OldIndex <> Index AndAlso Index <= FCount - 1 Then
			If Index < OldIndex Then
				For i As Integer = OldIndex - 1 To Index Step -1
					FItems[i + 1] = FItems[i]
				Next i
				FItems[Index] = Value
			Else
				For i As Integer = OldIndex + 1 To Index
					FItems[i - 1] = FItems[i]
				Next i
				FItems[Index] = Value
			End If
		End If
	End Sub
	
	Private Sub Menu.Clear
		If FItems Then
			For i As Integer = FCount - 1 To 0 Step -1
				If Item(i)->FDynamic Then _Delete(Item(i))
			Next i
			If FItems <> 0 Then _DeleteSquareBrackets( FItems)
			FItems = 0 'callocate_(0)
		End If
	End Sub
	
	Private Sub Menu.ProcessMessage(ByRef message As Message)
		
	End Sub
	
	Private Operator Menu.cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor Menu
		FDisplayIcons = True
	End Constructor
	
	Private Destructor Menu
		This.Clear
		#ifdef __USE_WINAPI__
			If FInfo.hbrBack Then DeleteObject(FInfo.hbrBack)
			If FHandle Then
				DestroyMenu(FHandle)
				FHandle = 0
			End If
		#endif
	End Destructor
	
	Private Function MainMenu.EnumMenuItems(ByRef Item As MenuItem) As Boolean
		FMenuItems.Add Item
		For i As Integer = 0 To Item.Count -1
			EnumMenuItems *Item.Item(i)
		Next i
		Return True
	End Function
	
	Private Function GetAscKeyCode(HotKey As String) As Integer
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
	
	Private Function GetChrKeyCode(KeyCode As Integer) As String
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
	#ifndef ReadProperty_Off
		Private Function MainMenu.ReadProperty(ByRef PropertyName As String) As Any Ptr
			FTempString = LCase(PropertyName)
			Select Case FTempString
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function MainMenu.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property MainMenu.ParentWindow(value As Component Ptr)
		FParentWindow = value
		If value Then
			#ifdef __USE_GTK__
				If value Then
					If value->layoutwidget Then
						'gtk_container_add(GTK_CONTAINER(value->layoutwidget), widget)
						#ifdef __USE_GTK4__
							If value->box Then gtk_box_pack_start(GTK_BOX(value->box), widget)
						#else
							If value->box Then gtk_box_pack_start(GTK_BOX(value->box), widget, False, False, 0)
						#endif
						Dim As GdkGeometry hints
						hints.base_width = 0
						hints.base_height = 0
						hints.min_width = 0
						hints.min_height = 0
						hints.width_inc = 1
						hints.height_inc = 1
						#ifndef __USE_GTK4__
							gtk_window_set_geometry_hints(GTK_WINDOW(gtk_widget_get_toplevel(widget)), widget, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
							For i As Integer = 0 To Count - 1
								If Item(i)->SubMenu Then
									gtk_window_set_geometry_hints(GTK_WINDOW(gtk_widget_get_toplevel(widget)), Item(i)->SubMenu->widget, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
								End If
							Next i
						#endif
						gtk_widget_show(widget)
					End If
				End If
			#elseif defined(__USE_WINAPI__)
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
						gtk_widget_add_accelerator(mi->Widget, "activate", FParentWindow->Accelerator, mi->accelerator_key, mi->accelerator_mods, GTK_ACCEL_VISIBLE)
					End If
				Next i
			#elseif defined(__USE_WINAPI__)
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
				Erase accl
			#endif
		End If
	End Property
	
	Private Sub MainMenu.ProcessMessages(ByRef message As Message)
		Dim As PMenuItem I
		#ifdef __USE_WINAPI__
			I = Find(LoWord(message.wParam))
		#endif
		If I Then I->Click
	End Sub
	
	Private Operator MainMenu.cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor MainMenu
		#ifdef __USE_GTK__
			widget = gtk_menu_bar_new()
		#elseif defined(__USE_WINAPI__)
			This.FHandle      = CreateMenu
		#endif
		WLet(FClassName, "MainMenu")
		FIncSubItems = 1
		#ifdef __USE_WINAPI__
			FColor       = GetSysColor(COLOR_MENU)
			FInfo.cbSize = SizeOf(FInfo)
			If FInfo.hbrBack Then DeleteObject(FInfo.hbrBack)
			FInfo.hbrBack    = CreateSolidBrush(FColor)
			FInfo.dwMenuData = Cast(DWORD_PTR,Cast(Any Ptr,@This))
			FInfo.fMask      = MIM_BACKGROUND Or IIf(FIncSubItems,MIM_APPLYTOSUBMENUS,0) Or MIM_MENUDATA
			SetMenuInfo(This.FHandle,@FInfo)
		#endif
	End Constructor
	
	Private Destructor MainMenu
	End Destructor
	
	
	/' PopupMenu '/
	#ifndef ReadProperty_Off
		Private Function PopupMenu.ReadProperty(ByRef PropertyName As String) As Any Ptr
			FTempString = LCase(PropertyName)
			Select Case FTempString
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function PopupMenu.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property PopupMenu.ParentMenuItem As MenuItem Ptr
		Return FParentMenuItem
	End Property
	
	Private Property PopupMenu.ParentMenuItem(value As MenuItem Ptr)
		FParentMenuItem = value
	End Property
	
	Private Property PopupMenu.ParentWindow As Component Ptr
		Return Base.ParentWindow
	End Property
	
	Private Property PopupMenu.ParentWindow(value As Component Ptr)
		#ifdef __USE_GTK__
			If FParentWindow = 0 Then
				'gtk_menu_attach_to_widget(gtk_menu(widget), value->widget, NULL)
				gtk_widget_show(widget)
			End If
		#endif
		Base.ParentWindow = value
	End Property
	
	Private Sub PopupMenu.Popup(x As Integer, y As Integer, msg As Message Ptr = 0)
		#ifdef __USE_GTK__
			If msg <> 0 Then
				'gtk_widget_show(widget)
				#ifdef __USE_GTK4__
					'gtk_menu_popup_at_pointer(GTK_MENU(widget), msg.Event)
				#else
					gtk_menu_popup(GTK_MENU(widget), NULL, NULL, NULL, NULL, msg->Event->button.button, msg->Event->button.time)
				#endif
			Else
				#ifdef __USE_GTK4__
				#else
					gtk_menu_popup(GTK_MENU(widget), NULL, NULL, NULL, NULL, NULL, NULL)
				#endif
			End If
		#elseif defined(__USE_WINAPI__)
			If FParentWindow AndAlso FParentWindow->Handle Then
				TrackPopupMenuEx(This.FHandle, 0, x, y, FParentWindow->Handle, 0)
			End If
		#endif
	End Sub
	
	Private Sub PopupMenu.ProcessMessages(ByRef message As Message)
		Dim As PMenuItem I
		#ifdef __USE_WINAPI__
			I = Find(LoWord(message.wParam))
		#endif
		If I Then I->Click
		
	End Sub
	
	Private Operator PopupMenu.cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor PopupMenu
		#ifdef __USE_GTK__
			widget = gtk_menu_new()
			gtk_menu_set_reserve_toggle_size(GTK_MENU(widget) , False)
			'gtk_menu_set_screen(gtk_menu(widget), gdk_screen_get_default())
		#elseif defined(__USE_WINAPI__)
			This.FHandle = CreatePopupMenu
			FInfo.cbSize     = SizeOf(FInfo)
			FInfo.fMask      = MIM_MENUDATA
			FInfo.dwMenuData = Cast(DWORD_PTR,Cast(Any Ptr,@This))
			SetMenuInfo(This.FHandle,@FInfo)
		#endif
		WLet(FClassName, "PopupMenu")
	End Constructor
	
	Private Destructor PopupMenu
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Function MenuItemItemsCount Alias "MenuItemItemsCount" (PMenuItem As My.Sys.Forms.MenuItem Ptr) As Integer Export
		Return PMenuItem->Count
	End Function
	
	Function MenuItemsCount Alias "MenuItemsCount" (PMenu As My.Sys.Forms.Menu Ptr) As Integer Export
		Return PMenu->Count
	End Function
	
	Function MenuItemFindByName Alias "MenuItemFindByName"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenuItem->Find(FName)
	End Function
	
	Function MenuByIndex Alias "MenuByIndex"(PMenu As My.Sys.Forms.Menu Ptr, Index As Integer) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenu->Item(Index)
	End Function
	
	Function MenuItemByIndex Alias "MenuItemByIndex"(PMenuItem As My.Sys.Forms.MenuItem Ptr, Index As Integer) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenuItem->Item(Index)
	End Function
	
	Function MenuFindByName Alias "MenuFindByName"(PMenu As My.Sys.Forms.Menu Ptr, ByRef FName As WString) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenu->Find(FName)
	End Function
	
	Function MenuFindByCommand Alias "MenuFindByCommand"(PMenu As My.Sys.Forms.Menu Ptr, FCommand As Integer) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenu->Find(FCommand)
	End Function
	
	Function MenuItemAdd Alias "MenuItemAdd"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenuItem->Add(sCaption, sImageKey, sKey, eClick, False, Index)
	End Function
	
	Function MenuItemIndexOf Alias "MenuItemIndexOf" (PParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) As Integer Export
		Return PParentMenuItem->IndexOf(PMenuItem)
	End Function
	
	Function MenuItemIndexOfKey Alias "MenuItemIndexOfKey" (PParentMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef Key As WString) As Integer Export
		Return PParentMenuItem->IndexOf(Key)
	End Function
	
	Function MenuAdd Alias "MenuAdd"(PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenuItem->Add(sCaption, sImageKey, sKey, eClick, False, Index)
	End Function
	
	Function MenuItemAddWithBitmapType Alias "MenuItemAddWithBitmapType" (PMenuItem As My.Sys.Forms.MenuItem Ptr, ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType Ptr, sKey As String = "", eClick As Any Ptr = NULL, Index As Integer = -1) As My.Sys.Forms.MenuItem Ptr Export
		Return PMenuItem->Add(sCaption, *iImage, sKey, eClick, False, Index)
	End Function
	
	Sub MenuItemRemove Alias "MenuItemRemove"(ParentMenuItem As My.Sys.Forms.MenuItem Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
		ParentMenuItem->Remove PMenuItem
	End Sub
	
	Sub MenuRemove Alias "MenuRemove"(ParentMenu As My.Sys.Forms.Menu Ptr, PMenuItem As My.Sys.Forms.MenuItem Ptr) Export
		ParentMenu->Remove PMenuItem
	End Sub
#endif
