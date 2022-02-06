#pragma once

' MIT license, see LICENSE
' Copyright(c) 2021 adzm / Adam D. Walling

' processes messages related To UAH / Custom menubar drawing.
' return True if handled, False to continue with normal processing in your wndproc

' window messages related to menu bar drawing
#define WM_UAHDESTROYWINDOW    &h0090	' handled by DefWindowProc
#define WM_UAHDRAWMENU         &h0091	' lParam Is UAHMENU
#define WM_UAHDRAWMENUITEM     &h0092	' lParam Is UAHDRAWMENUITEM
#define WM_UAHINITMENU         &h0093	' handled by DefWindowProc
#define WM_UAHMEASUREMENUITEM  &h0094	' lParam Is UAHMEASUREMENUITEM
#define WM_UAHNCPAINTMENUPOPUP &h0095	' handled by DefWindowProc

' describes the sizes of the menu bar or menu item
Type UAHMENUITEMMETRICS As tagUAHMENUITEMMETRICS

Type rgsizeBar1
	As DWORD cx
	As DWORD cy
End Type

Type rgsizePopup1
	As DWORD cx
	As DWORD cy
End Type

Union tagUAHMENUITEMMETRICS
	' cx appears to be 14 / 0xE less than rcItem's width!
	' cy 0x14 seems stable, i wonder if it is 4 less than rcItem's height which is always 24 atm
	As rgsizeBar1 rgsizeBar(2)
	As rgsizePopup1 rgsizePopup(4)
End Union

' not really used in our case but part of the other structures
Type UAHMENUPOPUPMETRICS As tagUAHMENUPOPUPMETRICS

Type tagUAHMENUPOPUPMETRICS
	As DWORD rgcx(4)
	As DWORD fUpdateMaxWidths : 2 ' from kernel symbols, padded to full dword
End Type

' hmenu is the main window menu; hdc is the context to draw in
Type UAHMENU As tagUAHMENU

Type tagUAHMENU
	As HMENU hmenu
	As HDC hdc
	As DWORD dwFlags ' no idea what these mean, in my testing it's either 0x00000a00 or sometimes 0x00000a10
End Type

' menu items are always referred to by iPosition here
Type UAHMENUITEM As tagUAHMENUITEM

Type tagUAHMENUITEM
	As Integer iPosition ' 0 - based position of menu item in menubar
	As UAHMENUITEMMETRICS umim
	As UAHMENUPOPUPMETRICS umpm
End Type

' the DRAWITEMSTRUCT contains the states of the menu items, as well as
' the position index of the item in the menu, which is duplicated in
' the UAHMENUITEM's iPosition as well
Type UAHDRAWMENUITEM As tagUAHDRAWMENUITEM

Type tagUAHDRAWMENUITEM
	As DRAWITEMSTRUCT dis ' itemID looks uninitialized
	As UAHMENU um
	As UAHMENUITEM umi
End Type

' the MEASUREITEMSTRUCT is intended To be filled with the size of the item
' height appears to be ignored, but width can be modified
Type UAHMEASUREMENUITEM As tagUAHMEASUREMENUITEM

Type tagUAHMEASUREMENUITEM
	As MEASUREITEMSTRUCT mis
	As UAHMENU um
	As UAHMENUITEM umi
End Type

