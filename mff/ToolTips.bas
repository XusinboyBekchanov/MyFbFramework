﻿'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "ToolTips.bi"

Namespace My.Sys.Forms
	'    #IfNDef __USE_GTK__
	'		Sub ToolTips.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
	'			If Sender.Child Then
	'				With QToolTips(Sender.Child)
	'
	'				End With
	'			End If
	'		End Sub
	'
	'		Sub ToolTips.WndProc(ByRef Message As Message)
	'		End Sub
	'
	'		Sub ToolTips.ProcessMessage(ByRef Message As Message)
	'			Base.ProcessMessage(Message)
	'		End Sub
	'	#EndIf
	
	Private Operator ToolTips.Cast As My.Sys.ComponentModel.Component Ptr
		Return Cast(My.Sys.ComponentModel.Component Ptr, @This)
	End Operator
	
	Private Constructor ToolTips
		With This
			WLet(FClassName, "ToolTips")
			WLet(FClassAncestor, "tooltips_class32")
			#ifdef __USE_GTK__
				'Widget = gtk_tooltips_new()
			#else
				'				.RegisterClass "ToolTips","tooltips_class32"
				'				.Style        = TTS_ALWAYSTIP Or WS_POPUP
				'				.ExStyle      = WS_EX_TOPMOST
				'				.ChildProc    = @WndProc
				'				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			'            .Width        = 175
			'            .Height       = 21
			'            .Child        = @This
		End With
	End Constructor
	
	Private Destructor ToolTips
		#ifndef __USE_GTK__
			'			UnregisterClass "ToolTips",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
