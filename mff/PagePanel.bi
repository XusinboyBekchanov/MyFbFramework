'###############################################################################
'#  PagePanel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ContainerControl.bi"
#include once "Graphic.bi"
#include once "NumericUpDown.bi"

Namespace My.Sys.Forms
	#define QPagePanel(__Ptr__) (*Cast(PagePanel Ptr, __Ptr__))
	
	'Used to group collections of controls.
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
		#endif
		UpDownControl As NumericUpDown
		Declare Sub MoveUpDownControl
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
