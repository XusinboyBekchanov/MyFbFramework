'###############################################################################
'#  PagePanel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ContainerControl.bi"
#include once "Graphic.bi"
#include once "NumericUpDown.bi"
#include once "Panel.bi"
#include once "CommandButton.bi"

Namespace My.Sys.Forms
	#define QPagePanel(__Ptr__) (*Cast(PagePanel Ptr, __Ptr__))
	
	'Used to group collections of controls (Windows, Linux, Android, Web).
	Private Type PagePanel Extends ContainerControl
	Private:
		#ifdef __USE_WINAPI__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
		#endif
		FSelectedPanelIndex As Integer
		FTransparent As Boolean
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Protected:
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#elseif defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
			Declare Static Function Overlay_get_child_position(self As GtkOverlay Ptr, widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr) As Boolean
		#endif
		NumericUpDownControl As NumericUpDown
		#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
			UpDownButton As CommandButton
			Declare Sub UpDownButton_Click(ByRef Sender As Control)
		#else
			UpDownControl As UpDown
			UpDownPanel As Panel
			NeedBringToFront As Boolean
			Declare Sub UpDownControl_Changing(ByRef Sender As UpDown, Value As Integer, Direction As Integer)
		#endif
		mnuContext As PopupMenu
		mnuShowPanel As MenuItem
		Declare Sub NumericUpDownControl_Change(ByRef Sender As NumericUpDown)
		Declare Sub MenuItem_Click(ByRef Sender As MenuItem)
		Declare Sub MoveNumericUpDownControl
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns/sets a graphic to be displayed in a control (Windows, Linux).
		Graphic As My.Sys.Drawing.GraphicType
		Declare Property SelectedPanel As Control Ptr
		Declare Property SelectedPanel(Value As Control Ptr)
		Declare Property SelectedPanelIndex As Integer
		Declare Property SelectedPanelIndex(Value As Integer)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Transparent As Boolean
		Declare Property Transparent(Value As Boolean)
		Declare Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
		Declare Sub CreateWnd
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnSelChange    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PagePanel, NewIndex As Integer)
		OnSelChanging  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PagePanel, NewIndex As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PagePanel.bas"
#endif
