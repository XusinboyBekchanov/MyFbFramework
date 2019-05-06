'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStatusBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"
#Include Once "Menus.bi"

Namespace My.Sys.Forms
    #DEFINE QStatusBar(__Ptr__) *Cast(StatusBar Ptr, __Ptr__)
    #DEFINE QStatusPanel(__Ptr__) *Cast(StatusPanel Ptr, __Ptr__)

	#IfDef __USE_GTK__
		Enum BevelStyle
			  pbLowered
			  pbNone
			  pbRaised
			  pbOwnerDraw
			  pbRtlReading
			pbNoTabParsing    
		End Enum
	#Else
		Enum BevelStyle
			  pbLowered    = 0
			  pbNone       = SBT_NOBORDERS
			  pbRaised     = SBT_POPOUT
			  pbOwnerDraw  = SBT_OWNERDRAW
			  pbRtlReading = SBT_RTLREADING
			pbNoTabParsing = SBT_NOTABPARSING    
		End Enum
	#EndIf

    Type StatusPanel Extends My.Sys.Object
        Private:
            FAlignment As Integer
            FCaption   As WString Ptr
            FBevel     As BevelStyle
            FWidth     As Integer
        Public:  
            Index      As Integer
            #IfDef __USE_GTK__
				message_id As guint
				label As GtkWidget Ptr
            #EndIf
            StatusBarControl As My.Sys.Forms.Control Ptr
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Bevel As BevelStyle
            Declare Property Bevel(Value As BevelStyle)
            Declare Property Alignment As Integer
            Declare Property Alignment(Value As Integer)
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Constructor
            Declare Destructor
    End Type
            
    Type StatusBar Extends Control
        Private:
            FSimpleText   As WString Ptr
            FSimplePanel  As Boolean
            FSizeGrip     As Boolean
            AStyle(2)     As Integer
            #IfDef __USE_GTK__
				Dim As guint context_id
            #Else 
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As My.Sys.Forms.Control)
			#EndIf
        Public:
            Count         As Integer
            Font          As My.Sys.Drawing.Font
            Panels        As StatusPanel Ptr Ptr
            Declare Property Panel(Index As Integer) As StatusPanel
            Declare Property Panel(Index As Integer, Value As StatusPanel)
            Declare Property Color As Integer
            Declare Property Color(Value As Integer)
            Declare Property SimpleText ByRef As WString
            Declare Property SimpleText(ByRef Value As WString)
            Declare Property SimplePanel As Boolean
            Declare Property SimplePanel(Value As Boolean)
            Declare Property SizeGrip As Boolean
            Declare Property SizeGrip(Value As Boolean)
            Declare Function Add(ByRef wText As WString) As StatusPanel Ptr
            Declare Sub Remove(Index As Integer)
            Declare Sub Clear
            Declare Sub UpdatePanels
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Property StatusPanel.Caption ByRef As WString
        Return *FCaption
    End Property

    Property StatusPanel.Caption(ByRef Value As WString)
        FCaption = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
        *FCaption = Value
        #IfDef __USE_GTK__
			'gtk_label_set_text(gtk_label(label), Value)
        #Else
			If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
		#EndIf
    End Property

    Property StatusPanel.Width As Integer
        Return FWidth
    End Property

    Property StatusPanel.Width(Value As Integer)
        FWidth = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Property StatusPanel.Bevel As BevelStyle
        Return FBevel
    End Property

    Property StatusPanel.Bevel(Value As BevelStyle)
        FBevel = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Property StatusPanel.Alignment As Integer
        Return FAlignment
    End Property

    Property StatusPanel.Alignment(Value As Integer)
        FAlignment = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Operator StatusPanel.Cast As Any Ptr
        Return @This
    End Operator

    Operator StatusPanel.Let(ByRef Value As WString)
        Caption = Value
    End Operator

    Constructor StatusPanel
        FCaption = CAllocate(0)
        Caption   = ""
        FWidth     = 50
        FAlignment = 0
        FBevel     = 0
    End Constructor

    Destructor StatusPanel
        If FCaption Then Deallocate FCaption
    End Destructor

    Function StatusBar.Add(ByRef wText As WString) As StatusPanel Ptr
        Count += 1
        Panels = ReAllocate(Panels, SizeOF(StatusPanel) * Count)
        Panels[Count -1] = New StatusPanel
        Panels[Count -1]->Index     = Count - 1
        Panels[Count -1]->Width     = 50
        Panels[Count -1]->Caption   = wText
        Panels[Count -1]->Alignment = 0
        Panels[Count -1]->Bevel     = pbLowered
        Panels[Count -1]->StatusBarControl = @This
        #IfDef __USE_GTK__
			Panels[Count -1]->message_id = gtk_statusbar_push(gtk_statusbar(widget), context_id, wText)
		#Else
			UpdatePanels
        #EndIf
        Return Panels[Count - 1]
    End Function

    Sub StatusBar.Remove(Index As Integer)
        Dim As StatusPanel Ptr Ptr Temp
        Dim As Integer i, x = 0
        If Index >= 0 And Index <= Count -1 Then
			#IfDef __USE_GTK__
				gtk_statusbar_remove(gtk_statusbar(widget), context_id, Panels[i]->message_id)
			#EndIf
           Temp = cAllocate((Count - 1) * SizeOf(StatusPanel)) 
           x = 0
           For i = 0 To Count -1
               If i <> Index Then
                  x += 1
                  Temp[x -1] = Panels[i]
               End If
           Next i
           Count -= 1 
           Panels = cAllocate(Count*SizeOf(StatusPanel))
           For i = 0 to Count -1
               Panels[i] = Temp[i]
           Next i
           DeAllocate Temp
        End If
        #IfNDef __USE_GTK__
			UpdatePanels
		#EndIf
    End Sub

    Sub StatusBar.Clear
        For i As Integer = Count -1 To 0 Step -1
            Remove i
        Next i
        Count = 0
        #IfDef __USE_GTK__
			gtk_statusbar_remove_all(gtk_statusbar(widget), context_id)
        #Else 
			SetWindowText Handle, ""
		#EndIf
    End Sub

    Sub StatusBar.UpdatePanels
        Dim As Integer i,FWidth()
        Dim As WString Ptr s = CAllocate(0)
        ReDim FWidth(Count)
        If Count > 0 Then 
            For i = 0 To Count -1
                If i = 0 Then
                   FWidth(i) = Panels[i]->Width
                Else
                   FWidth(i) = Panels[i]->Width  + FWidth(i -1)
               End If
            Next i
            FWidth(Count - 1) = -1
            #IfNDef __USE_GTK__ 
				Perform(SB_SETPARTS, Count, CInt(@FWidth(0)))
            #EndIf
            For i = 0 To Count -1
                If Panels[i]->Alignment = 0 Then
                    s = ReAllocate(s, (Len(Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Panels[i]->Caption
                ElseIf Panels[i]->Alignment = 1 Then
                    s = ReAllocate(s, (Len(Chr(9) + Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Chr(9)+Panels[i]->Caption
                ElseIf Panels[i]->Alignment = 2 then
                    s = ReAllocate(s, (Len(Chr(9) + Chr(9) + Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Chr(9)+Chr(9)+Panels[i]->Caption
                Else 
                    s = ReAllocate(s, (Len(Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Panels[i]->Caption
                End If
                #IfNDef __USE_GTK__ 
					Perform(SB_SETTEXT, i OR Panels[i]->Bevel, CInt(s))
				#EndIf
            Next i
        End If 
        Invalidate
        WDeallocate s
    End Sub

    Property StatusBar.Panel(Index As Integer) As StatusPanel
        If Index >= 0 And Index <= Count -1 Then
           Return *Panels[Index]
        End If
    End Property

    Property StatusBar.Panel(Index As Integer, Value As StatusPanel)
        If Index >= 0 And Index <= Count -1 Then
           Panels[Index] = Value
        End If
    End Property

    Property StatusBar.Color As Integer
        Return Base.BackColor
    End Property

    Property StatusBar.Color(Value As Integer)
        Base.BackColor = Value
        #IfNDef __USE_GTK__ 
			If Handle Then SendMessage(Handle, SB_SETBKCOLOR, 0, Base.BackColor)
		#EndIf
    End Property

    Property StatusBar.SizeGrip As Boolean
        Return FSizeGrip 
    End Property

    Property StatusBar.SizeGrip(Value As Boolean)
        If Value <> FSizeGrip Then
           FSizeGrip = Value 
           #IfNDef __USE_GTK__ 
				Style  = WS_CHILD OR CCS_NOPARENTALIGN OR AStyle(Abs_(FSizeGrip))
           #EndIf
           RecreateWnd
        End If
    End Property

    Property StatusBar.SimplePanel As Boolean
        Return FSimplePanel 
    End Property

    Property StatusBar.SimplePanel(Value As Boolean)
        If Value <> FSimplePanel Then
			FSimplePanel = Value 
			#IfNDef __USE_GTK__ 
				If Handle Then 
					SendMessage(Handle, SB_SIMPLE, FSimplePanel, 0)
					SimpleText = *FSimpleText
				End If
			#EndIf
        End If
    End Property

    Property StatusBar.SimpleText ByRef As WString
        Return *FSimpleText
    End Property

    Property StatusBar.SimpleText(ByRef Value As WString)
        If SimplePanel Then
            FSimpleText = Reallocate(FSimpleText, (Len(Value) + 1) * SizeOf(WString))
            *FSimpleText = Value
            Text = *FSimpleText
            #IfNDef __USE_GTK__ 
				If FHandle Then SendMessage(Handle, SB_SETTEXT, 255, CInt(@Value))
			#EndIf
        End If    
    End Property

	#IfNDef __USE_GTK__ 
		Sub StatusBar.HandleIsAllocated(BYREF Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QStatusBar(Sender.Child)
					 SetClassLong .Handle, GCL_STYLE, GetClassLong(.Handle,GCL_STYLE) AND NOT CS_HREDRAW
					 .Perform(SB_SETBKCOLOR, 0, .Color)
					 .SimpleText = .SimpleText
					 .SimplePanel = .SimplePanel
					 .UpdatePanels
				End With
			End If
		End Sub

		Sub StatusBar.WndProc(BYREF Message As Message)
		End Sub

		Sub StatusBar.ProcessMessage(BYREF Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator StatusBar.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor StatusBar
		With This
        FSimpleText = CAllocate(0)
        #IfDef __USE_GTK__
			widget = gtk_statusbar_new
			'gtk_statusbar_set_has_resize_grip(gtk_statusbar(widget), true)
			.RegisterClass "StatusBar", @This
			WLet FSimpleText, "StatusBar"
			context_id = gtk_statusbar_get_context_id(gtk_statusbar(widget), *FSimpleText)
			'Var cont2 = gtk_statusbar_get_context_id(gtk_statusbar(widget), "statusbar 2")
			'gtk_statusbar_push(gtk_statusbar(widget), cont2, *FSimpleText)
			
        #Else 
			AStyle(0) = 0
			AStyle(1) = SBARS_SIZEGRIP 
        #EndIf
        FSizeGrip = True
            WLet FClassName, "StatusBar"
            WLet FClassAncestor, "msctls_StatusBar32"
            #IfNDef __USE_GTK__
				.RegisterClass "StatusBar","msctls_StatusBar32"
				.Style        = WS_CHILD OR CCS_NOPARENTALIGN OR AStyle(Abs_(FSizeGrip))
				.ExStyle      = 0
				.Color        = GetSysColor(COLOR_BTNFACE) 
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
            #EndIf
            .Width        = 175
            .Height       = 21
            .Child        = @This
        End With
    End Constructor

    Destructor StatusBar
        Panels = cAllocate(0)
        #IfNDef __USE_GTK__ 
			UnregisterClass "StatusBar",GetModuleHandle(NULL)
        #EndIf
        Deallocate FSimpleText
    End Destructor
End Namespace
