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
	
	Private Type PrintPreviewControl Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			
		#endif
	Protected:
		FZoom As Integer
		Dim As Integer FPageWidth, FPageLength
		Dim As Integer FCurrentPage
		Dim As PrinterOrientation FOrientation
		Dim As Integer FHorizontalArrowChangeSize
		Dim As Integer FVerticalArrowChangeSize
		Declare Sub SetScrollsInfo
		Declare Sub PaintControl
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Dim As PrintDocument DefaultDocument
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Dim As PrintDocument Ptr Document
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property CurrentPage As Integer
		Declare Property CurrentPage(Value As Integer)
		Declare Property Orientation As PrinterOrientation
		Declare Property Orientation(Value As PrinterOrientation)
		Declare Property PageLength As Integer
		Declare Property PageLength(Value As Integer)
		Declare Property PageWidth As Integer
		Declare Property PageWidth(Value As Integer)
		Declare Property Zoom As Integer
		Declare Property Zoom(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnCurrentPageChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
		OnZoom As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PrintPreviewControl.bas"
#endif
