'###############################################################################
'#  Animate.bas                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TAnimate.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "Animate.bi"

Namespace My.Sys.Forms
	Function Animate.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "autoplay": Return @FAutoPlay
		Case "autosize": Return @FAutoSize
		Case "center": Return @FCenter
		Case "commonavi": Return @FCommonAVI
		Case "file": Return FFile
		Case "repeat": Return @FRepeat
		Case "startframe": Return @FStartFrame
		Case "stopframe": Return @FStopFrame
		Case "timers": Return @FTimers
		Case "transparency": Return @FTransparent
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Animate.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "autoplay": AutoPlay = QBoolean(Value)
		Case "autosize": AutoSize = QBoolean(Value)
		Case "center": Center = QBoolean(Value)
		Case "commonavi": CommonAVI = *Cast(CommonAVIs Ptr, Value)
		Case "file": File = QWString(Value)
		Case "repeat": Repeat = QInteger(Value)
		Case "startframe": StartFrame = QInteger(Value)
		Case "stopframe": StopFrame = QInteger(Value)
		Case "timers": Timers = QBoolean(Value)
		Case "transparency": Transparency = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Sub Animate.GetAnimateInfo
		#ifndef __USE_GTK__
			Dim As HRSRC Resource
			Dim As HGLOBAL Global
			Dim As Any Ptr PResource
			Dim As UByte Ptr P
			Dim As Integer F, Size
			Dim As Integer Ptr Buff = Allocate_(18*SizeOf(Integer))
			If *FFile <> "" Then
				F = FreeFile
				.Open *FFile For Binary Access Read As #F
				Get #F, , *Buff, 18
				.Close #F
				FFrameCount  = Buff[12]
				FFrameWidth  = Buff[16]
				FFrameHeight = Buff[17]
			Else
				Resource  = FindResource(GetModuleHandle("Shell32"),MakeIntResource(FCommonAvi),"AVI")
				Global    = LoadResource(GetModuleHandle("Shell32"),Resource)
				PResource = LockResource(Global)
				Size = SizeOfResource(GetModuleHandle("Shell32"),Resource)
				P = Allocate_(Size)
				P = PResource
				FreeResource(Resource)
				memcpy Buff, P, 18 * SizeOf(Integer)
				FFrameCount  = Buff[12]
				FFrameWidth  = Buff[16]
				FFrameHeight = Buff[17]
			End If
		#endif
	End Sub
	
	Property Animate.Center As Boolean
		Return FCenter
	End Property
	
	Property Animate.Center(Value As Boolean)
		If FCenter <> Value Then
			FCenter = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.Transparency As Boolean
		Return FTransparent
	End Property
	
	Property Animate.Transparency(Value As Boolean)
		If FTransparent <> Value Then
			FTransparent = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.Timers As Boolean
		Return FTimers
	End Property
	
	Property Animate.Timers(Value As Boolean)
		If FTimers <> Value Then
			FTimers = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.File ByRef As WString
		Return WGet(FFile)
	End Property
	
	Property Animate.File(ByRef Value As WString)
		FFile = Reallocate_(FFile, (Len(Value) + 1) * SizeOf(WString))
		*FFile = Value
		#ifdef __USE_GTK__
			pixbuf_animation = gdk_pixbuf_animation_new_from_file(ToUTF8(*FFile), NULL)
		#else
			If FHandle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle(NULL))
				Open
			End If
		#endif
	End Property
	
	Property Animate.Repeat As Integer
		Return FRepeat
	End Property
	
	Property Animate.Repeat(Value As Integer)
		FRepeat = Value
	End Property
	
	Property Animate.AutoPlay As Boolean
		Return FAutoPlay
	End Property
	
	Property Animate.AutoPlay(Value As Boolean)
		If FAutoPlay <> Value Then
			FAutoPlay = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
			#endif
		End If
	End Property
	
	Property Animate.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Property Animate.AutoSize(Value As Boolean)
		FAutoSize = Value
		#ifndef __USE_GTK__
			If CInt(FAutoSize) AndAlso CInt(FHandle) AndAlso CInt(Not FDesignMode) Then
				This.Width = FFrameWidth
				This.Height = FFrameHeight
			End If
		#endif
	End Property
	
	Property Animate.CommonAvi As CommonAVIs
		Return FCommonAvi
	End Property
	
	Property Animate.CommonAvi(Value As CommonAVIs)
		FCommonAvi = Value
		#ifndef __USE_GTK__
			If Handle Then
				SetWindowLongPtr Handle, GWLP_HINSTANCE, CInt(GetModuleHandle("Shell32"))
				Open
			End If
		#endif
	End Property
	
	Property Animate.StartFrame As Integer
		Return FStartFrame
	End Property
	
	Property Animate.StartFrame(Value As Integer)
		FstartFrame = Value
		If FStartFrame < 0 Then FStartFrame = 0
		If FPlay Then This.Stop
		Play
	End Property
	
	Property Animate.StopFrame As Integer
		Return FStopFrame
	End Property
	
	Property Animate.StopFrame(Value As Integer)
		FStopFrame = Value
		If FStopFrame > FFrameCount Then FStopFrame = FFrameCount
		If FPlay Then This.Stop
		Play
	End Property
	
	Function Animate.FrameCount As Integer
		GetAnimateInfo
		Return FFrameCount
	End Function
	
	#ifndef __USE_GTK__
		Sub Animate.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QAnimate(Sender.Child)
					SetClassLongPtr(.Handle, GCLP_HBRBACKGROUND, 0)
					If .FOpen Then .Open
					If .FPlay Then .Play
				End With
			End If
		End Sub
		
		Sub Animate.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
		
	Sub Animate.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case ACN_START
					If OnStart Then OnStart(This)
				Case ACN_STOP
					If OnStop Then OnStop(This)
				End Select
			Case WM_NCHITTEST
				Message.Result = HTCLIENT
			Case WM_ERASEBKGND
				Dim As Rect R
				GetClientRect Handle, @R
				FillRect Cast(HDC, Message.wParam),@R, Brush.Handle
				Message.Result = -1
			Case WM_NCPAINT
				Dim As HDC Dc
				Dc = GetDCEx(Handle, 0, DCX_WINDOW Or DCX_CACHE Or DCX_CLIPSIBLINGS)
				'Future utilisation
				ReleaseDC Handle,Dc
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Sub Animate.Open
		#ifdef __USE_GTK__
			If OnOpen Then OnOpen(This)
			If FAutoPlay Then
				Play
			Else
'				If pixbuf_animation <> 0 Then
'					gtk_image_set_from_pixbuf(gtk_image(widget), gdk_pixbuf_animation_get_static_image(pixbuf_animation))
'				End If
			End If
		#else
			If Handle Then
				If OnOpen Then OnOpen(This)
				If CommonAVI = 0 Then
					If *FFile <> "" Then
						If FindResource(GetModuleHandle(NULL), *FFile, "AVI") Then
							GetAnimateInfo
							Animate_Open(FHandle, CInt(MakeIntResource(*FFile)))
							FOpen = 1
						Else
							GetAnimateInfo
							Perform(ACM_OPENW, 0, CInt(FFile))
							FOpen = 1
						End If
					End If
				ElseIf CommonAVI <> 0 Then
					If FindResource(GetModuleHandle("Shell32"), MakeIntResource(FCommonAvi), "AVI") Then
						GetAnimateInfo
						Perform(ACM_OPEN, CInt(GetModuleHandle("Shell32")), CInt(MakeIntResource(FCommonAvi)))
						FOpen = 1
					End If
				End If
			End If
		#endif
	End Sub
	
	Sub Animate.Play
		#ifdef __USE_GTK__
			If pixbuf_animation <> 0 Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				
				iter = gdk_pixbuf_animation_get_iter(pixbuf_animation, @gTime)
				If OnStart Then OnStart(This)
				FPlay = True
				Timer_cb(@This)
			End If
		#else
			If Handle Then
				Perform(ACM_PLAY, FRepeat, MakeLong(FStartFrame, FStopFrame))
				FPlay = True
			End If
		#endif
	End Sub
	
	Sub Animate.Stop
		#ifdef __USE_GTK__
			If OnStop Then OnStop(This)
			FPlay = False
		#else
			If Handle Then
				Perform(ACM_STOP,0,0)
				FPlay = False
			End If
		#endif
	End Sub
	
	Sub Animate.Close
		#ifdef __USE_GTK__
			If OnClose Then OnClose(This)
			FOpen = 0
			FPlay = False
		#else
			If Handle Then
				If OnClose Then OnClose(This)
				Perform(ACM_OPEN, 0, 0)
				FOpen = 0
				FPlay = False
			End If
		#endif
	End Sub
	
	Operator Animate.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Function Animate.Timer_cb(ByVal user_data As gpointer) As gboolean
			Dim As Animate Ptr anim = user_data
			If anim->FPlay Then
				Dim As GTimeVal gTime
				g_get_current_time(@gTime)
				gdk_pixbuf_animation_iter_advance(anim->iter, @gTime)
				g_timeout_add(gdk_pixbuf_animation_iter_get_delay_time(anim->iter), @Timer_cb, user_data)
				gtk_widget_queue_draw(anim->widget)
			End If
			Return False
		End Function
		
		Function Animate.DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Animate Ptr anim = data1
			#ifdef __USE_GTK3__
				Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
			#else
				Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
			#endif
			If anim->FDesignMode Then
				cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
				Dim As Double Ptr dashed = Allocate(SizeOf(Double) * 2)
				dashed[0] = 3.0
				dashed[1] = 3.0
				Dim As Integer len1 = SizeOf(dashed) / SizeOf(dashed[0])
				cairo_set_dash(cr, dashed, len1, 1)
				cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				cairo_stroke(cr)
			End If
			If anim->pixbuf_animation <> 0 Then
				cairo_set_operator (cr, CAIRO_OPERATOR_SOURCE)
				
				Dim As GdkPixbuf Ptr pixbuf
				
				Dim As Integer imgw, imgh
				imgw = gdk_pixbuf_animation_get_width(anim->pixbuf_animation)
				imgh = gdk_pixbuf_animation_get_height(anim->pixbuf_animation)
					
				If anim->AutoSize Then
					If AllocatedWidth <> imgw OrElse AllocatedHeight <> imgh Then
						gtk_widget_set_size_request(anim->eventboxwidget, imgw, imgh)
					End If
				End If
				
				pixbuf = gdk_pixbuf_animation_iter_get_pixbuf(anim->iter)
				If anim->Center Then
					gdk_cairo_set_source_pixbuf(cr, pixbuf, (AllocatedWidth - imgw) / 2, (AllocatedHeight - imgh) / 2)
				Else
					gdk_cairo_set_source_pixbuf(cr, pixbuf, 0, 0)
				End If
				cairo_paint(cr)
			End If
			
			Return False
		End Function
		
		Function Animate.DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			DesignDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Sub Animate.Screen_Changed(widget As GtkWidget Ptr, old_screen As GdkScreen Ptr, userdata As gpointer)
			Dim As Animate Ptr anim = userdata
			/' To check If the display supports Alpha channels, Get the colormap '/
			Dim As GdkScreen Ptr pScreen = gtk_widget_get_screen(widget)
			#ifdef __USE_GTK3__
				Dim As GdkVisual Ptr VisualOrColormap = gdk_screen_get_rgba_visual(pScreen)
			#else
				Dim As GdkColormap Ptr VisualOrColormap = gdk_screen_get_rgba_colormap(pScreen)
			#endif
			If (VisualOrColormap <> 0) Then
				Print "Your screen does not support alpha channels!"
				#ifdef __USE_GTK3__
					'VisualOrColormap = gdk_screen_get_rgb_visual(pScreen)
				#else
					VisualOrColormap = gdk_screen_get_rgb_colormap(pScreen)
				#endif
				anim->SupportsAlpha = False
			Else
				'Print "Your screen supports alpha channels!"
				anim->SupportsAlpha = True
			End If
			/' Now we have a colormap appropriate for the screen, use it '/
			#ifdef __USE_GTK3__
				'If VisualOrColormap <> 0 Then
					gtk_widget_set_visual(widget, VisualOrColormap)
				'End If
			#else
				gtk_widget_set_colormap(widget, VisualOrColormap)
			#endif
		End Sub
	#endif
	
	Constructor Animate
		Dim As Boolean Result
		#ifdef __USE_GTK__
			widget = gtk_image_new()
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(gtk_container(eventboxwidget), widget)
			gtk_widget_set_app_paintable(widget, True)
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@DesignDraw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@DesignExposeEvent), @This)
				#endif
			#endif
			g_signal_connect(G_OBJECT(widget), "screen-changed", G_CALLBACK(@Screen_Changed), @This)
			This.RegisterClass "Animate", @This
		#else
			Dim As INITCOMMONCONTROLSEX ICC
			FFile = 0 'CAllocate_(0)
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_ANIMATE_CLASS
			Result = InitCommonControlsEx(@ICC)
			If Not Result Then InitCommonControls
			ACenter(0)      = 0
			ACenter(1)      = ACS_CENTER
			ATransparent(0) = 0
			ATransparent(1) = ACS_TRANSPARENT
			ATimer(0)       = 0
			ATimer(1)       = ACS_TIMER
			AAutoplay(0)    = 0
			AAutoplay(1)    = ACS_AUTOPLAY
		#endif
		FRepeat         = -1
		FStopFrame      = -1
		FStartFrame     = 0
		FTransparent    = True
		With This
			WLet(FClassName, "Animate")
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "Animate", ANIMATE_CLASS
				.ChildProc         = @WndProc
				WLet(FClassAncestor, ANIMATE_CLASS)
				.ExStyle           = WS_EX_TRANSPARENT
				.Style             = WS_CHILD Or ACenter(Abs_(FCenter)) Or ATransparent(Abs_(FTransparent)) Or ATimer(Abs_(FTimers)) Or AAutoPlay(Abs_(FAutoPlay))
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width             = 100
			.Height            = 80
		End With
	End Constructor
	
	Destructor Animate
		If FFile Then Deallocate_( FFile)
	End Destructor
End Namespace
