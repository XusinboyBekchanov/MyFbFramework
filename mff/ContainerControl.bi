'###############################################################################
'#  ContainerControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#Include Once "Control.bi"
#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#DEFINE QContainerControl(__Ptr__) *Cast(ContainerControl Ptr,__Ptr__)

	Type ContainerControl Extends Control
		Private:
		Protected:
			Declare Virtual Sub ProcessMessage(BYREF message As Message)
		Public:
			Canvas        As My.Sys.Drawing.Canvas
			#IfDef __USE_GTK__
				Declare Function RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
			#EndIf
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Declare Operator Cast As Control Ptr
			Declare Operator Cast As Any Ptr
			Declare Constructor
			Declare Destructor
	End Type
End namespace

#IfDef __EXPORT_PROCS__
Declare Function ControlIsContainer Alias "ControlIsContainer"(Ctrl As My.Sys.Forms.Control Ptr) As Boolean
#EndIf

#IfNDef __USE_MAKE__
	#Include Once "ContainerControl.bas"
#EndIf
