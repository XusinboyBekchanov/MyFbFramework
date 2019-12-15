'################################################################################
'#  TimerComponent.bi                                                           #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Component.bi"
#Include Once "IntegerList.bi"

Using My.Sys.ComponentModel

Dim Shared TimersList As IntegerList

Namespace My.Sys.Forms
    
    Type TimerComponent Extends Component
        Private:
            FEnabled As Boolean
            #IfNDef __USE_GTK__ 
				Declare Static Sub TimerProc(hwnd As HWND, uMsg As Uint, idEvent As Integer, dwTime As DWord)
			#EndIf
        Public:
            Handle        As Integer
            Interval      As Integer
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnTimer As Sub(ByRef Sender As TimerComponent)
    End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "TimerComponent.bas"
#EndIf
