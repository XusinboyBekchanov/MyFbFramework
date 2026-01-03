'###############################################################################
'#  PrintPreviewControl.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "Control.bi"
#include once "PrintDocument.bi"
#include once "Printer.bi"

Namespace My.Sys.Forms
	#define QPrintPreviewControl(__Ptr__) (*Cast(PrintPreviewControl Ptr, __Ptr__))
	
	'`PrintPreviewControl` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`PrintPreviewControl` - Displays document pages with zoom/scroll capabilities and print layout visualization (Windows only).
	Private Type PrintPreviewControl Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			
		#endif
	Protected:
		FZoom As Integer
		Dim As Integer FPageWidth, FPageLength, FPageSize
		Dim As Integer FCurrentPage
		Dim As PrinterOrientation FOrientation
		Dim As Integer FHorizontalArrowChangeSize
		Dim As Integer FVerticalArrowChangeSize
		Dim As Integer FHorizontalMouseWheelChangeSize
		Dim As Integer FVerticalMouseWheelChangeSize
		Declare Sub SetScrollsInfo
		Declare Sub PaintControl
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Dim As PrintDocument DefaultDocument
	Public:
		#ifndef ReadProperty_Off
			'Loads page settings from stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves page settings to stream
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Dim As PrintDocument Ptr Document
		Declare Property TabIndex As Integer
		'Tab navigation order position
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Includes in tab navigation when True
		Declare Property TabStop(Value As Boolean)
		Declare Property CurrentPage As Integer
		'Index of currently displayed page (1-based)
		Declare Property CurrentPage(Value As Integer)
		Declare Property Orientation As PrinterOrientation
		'Page orientation (Portrait/Landscape)
		Declare Property Orientation(Value As PrinterOrientation)
		Declare Property PageLength As Integer
		'Vertical page dimension in millimeters
		Declare Property PageLength(Value As Integer)
		Declare Property PageWidth As Integer
		'Horizontal page dimension in millimeters
		Declare Property PageWidth(Value As Integer)
		Declare Property PageSize As Integer
		'Paper size preset (A4/Letter/Legal etc)
		Declare Property PageSize(Value As Integer)
		Declare Property Zoom As Integer
		'Zoom percentage (10-500%)
		Declare Property Zoom(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when displayed page changes
		OnCurrentPageChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
		'Raised during viewport scrolling
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
		'Triggered when zoom level changes
		OnZoom As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PrintPreviewControl.bas"
#endif
